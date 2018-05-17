unit WriteMT3D_SSM;

interface

uses Sysutils, Classes, Forms, contnrs, AnePIE, WriteMT3D_Basic, CopyArrayUnit,
  WriteModflowDiscretization, WriteWellUnit, WriteDrainUnit, WriteRiverUnit,
  WriteGHBUnit, WriteStrUnit, WriteReservoirUnit, WriteFHBUnit, OptionsUnit,
  WriteCHDUnit, WriteMultiNodeWellUnit, WriteDrainReturnUnit;

type
  TBoundaryType = (btTimeVaryingConcentration, btMassFlux);

  TMT3DCellRecord = record
    Layer : integer;
    Row : integer;
    Column : integer;
    BoundaryType : TBoundaryType;
    MT3DValues : T2DDoubleArray;
  end;

  TMT3DCell = class(TObject)
    Cell : TMT3DCellRecord;
    procedure Write(const Lines : TStringList; const StressPeriod : integer);
  end;

  TMT3D_CellList = Class(TObjectList)
    function Add(const ACell : TMT3DCellRecord;
      const Errors : TStringList) : integer; overload;
    function GetCellByLocation(Layer, Row, Column : integer) : TMT3DCell;
    procedure WriteMT3DConcentrations(const StressPeriod : integer;
      const Lines: TStringList);
  end;

  TTVCParamIndicies = record
    TopName : string;
    TopIndex : ANE_INT16;
    BottomName : string;
    BottomIndex : ANE_INT16;
    ValueIndicies : array of array of ANE_INT16;
    ValueNames : array of array of string;
  end;

  TMassFluxParamIndicies = record
    ElevationIndex : ANE_INT16;
    ValueIndicies : array of array of ANE_INT16;
  end;

{  TAreaConstantConcParamIndicies = record
    ValueIndicies : array of ANE_INT16;
    ValueNames : array of string;
  end;

  TPointConstantConcParamIndicies = record
    ValueIndicies : array of ANE_INT16;
    ValueNames : array of string;
  end;  }

  TMt3dSSMWriter = class(TMT3DCustomWriter)
  private
    CurrentModelHandle : ANE_PTR;
    DisWriter : TDiscretizationWriter;
    PointSources : TObjectList;
    CellList : TMT3D_CellList;
{    function GetAreaConstantConcParamIndicies(
      const Layer : TLayerOptions): TAreaConstantConcParamIndicies;
    function GetPointConstantConcParamIndicies(
      const Layer : TLayerOptions): TPointConstantConcParamIndicies;}
    function GetTVCIndicies(const Layer : TLayerOptions) : TTVCParamIndicies;
    procedure EvaluateTVC;
    function GetMassFluxIndicies(const Layer : TLayerOptions) : TMassFluxParamIndicies;
    procedure EvaluateMassFlux;
    procedure EvaluateDataSets7And8;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSets3And4(const StressPeriod : integer);
    procedure WriteDataSets5And6(const StressPeriod : integer);
    procedure WriteDataSets7And8(const StressPeriod : integer);
//    procedure EvaluateConstantConcentrations;
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure WriteFile(const ModelHandle: ANE_PTR; const Root: string;
      const Discretization : TDiscretizationWriter);
  end;




implementation

uses Variables, WriteNameFileUnit, ProgressUnit, PointInsideContourUnit,
  UtilityFunctions, GetCellUnit;

{ TMt3dSSMWriter }

constructor TMt3dSSMWriter.Create;
begin
  inherited Create;
  PointSources := TObjectList.Create;
  CellList := TMT3D_CellList.Create;
end;

procedure TMt3dSSMWriter.WriteDataSets7And8(const StressPeriod : integer);
var
  Lines : TStringList;
  Index : integer;
begin
  Lines := PointSources[StressPeriod-1] as TStringList;
    // Data set 7
  Writeln(FFile, FixedFormattedInteger(Lines.Count, 10));
  for Index := 0 to Lines.Count -1 do
  begin
    Writeln(FFile, Lines[Index]);
  end;
end;

destructor TMt3dSSMWriter.Destroy;
begin
  PointSources.Free;
  CellList.Free;
  inherited;
end;

procedure TMt3dSSMWriter.WriteDataSet1;
begin
  with frmModflow do
  begin
    Write(FFile, 'Basic');
    if cbWEL.Checked and cbWELRetain.Checked then
    begin
      Write(FFile, ', Well');
    end;
    if cbDRN.Checked and cbDRNRetain.Checked then
    begin
      Write(FFile, ', Drain');
    end;
    if cbRCH.Checked and cbRCHRetain.Checked then
    begin
      Write(FFile, ', Recharge');
    end;
    if cbEVT.Checked and cbEVTRetain.Checked then
    begin
      Write(FFile, ', Evapotranspiration');
    end;
    if cbRIV.Checked and cbRIVRetain.Checked then
    begin
      Write(FFile, ', River');
    end;
    if cbGHB.Checked and cbGHBRetain.Checked then
    begin
      Write(FFile, ', General-head boundary');
    end;
    if cbSTR.Checked and cbSTRRetain.Checked then
    begin
      Write(FFile, ', Stream');
    end;
    if cbRES.Checked and cbRESRetain.Checked then
    begin
      Write(FFile, ', Reservoir');
    end;
    if cbFHB.Checked and cbFHBRetain.Checked then
    begin
      Write(FFile, ', Flow-and-Head boundary');
    end;
  end;
  writeLn(FFile);
end;

procedure TMt3dSSMWriter.WriteDataSets3And4(const StressPeriod: integer);
var
  INCRCH : integer;
  Expression : string;
  LayerName, ParameterName : string;
  SpeciesIndex : integer;
begin
  with frmModflow do
  begin
    if cbRCH.Checked and cbRCHRetain.Checked then
    begin
      // data set 3
      if (StressPeriod = 1) or (comboRchSteady.ItemIndex = 1) then
      begin
        INCRCH := 1;
      end
      else
      begin
        INCRCH := -1;
      end;
      WriteLn(FFile, FixedFormattedInteger(INCRCH, 10));

      // data set 4
      if (INCRCH >= 0) then
      begin
        LayerName := ModflowTypes.GetMOCRechargeConcLayerType.ANE_LayerName;

        frmProgress.pbActivity.Max := DisWriter.NROW * DisWriter.NCOL
          * StrToInt(adeMT3DNCOMP.Text); 
        for SpeciesIndex := 1 to StrToInt(adeMT3DNCOMP.Text) do
        begin
          case SpeciesIndex of
            1: ParameterName := ModflowTypes.GetMFRechConcParamType.ANE_ParamName;
            2: ParameterName := ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName;
            3: ParameterName := ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName;
            4: ParameterName := ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName;
            5: ParameterName := ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName;
          else Assert(False);
          end;
          ParameterName := ParameterName + IntToStr(StressPeriod);
          Expression := LayerName + '.' + ParameterName;
          Write2DArray(CurrentModelHandle, DisWriter, Expression);
        end;

      end;
    end;
  end;
end;

procedure TMt3dSSMWriter.WriteDataSets5And6(const StressPeriod: integer);
var
  INCEVT : integer;
  Expression : string;
  LayerName, ParameterName : string;
  SpeciesIndex : integer;
begin
  with frmModflow do
  begin
    if cbEVT.Checked and cbEVTRetain.Checked then
    begin
      // data set 5
      if (StressPeriod = 1) or (comboEvtSteady.ItemIndex = 1) then
      begin
        INCEVT := 1;
      end
      else
      begin
        INCEVT := -1;
      end;
      WriteLn(FFile, FixedFormattedInteger(INCEVT, 10));

      // data set 6
      if (INCEVT >= 0) then
      begin
        LayerName := ModflowTypes.GetETLayerType.ANE_LayerName;

        for SpeciesIndex := 1 to StrToInt(adeMT3DNCOMP.Text) do
        begin
          case SpeciesIndex of
            1: ParameterName := ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName;
            2: ParameterName := ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName;
            3: ParameterName := ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName;
            4: ParameterName := ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName;
            5: ParameterName := ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName;
          else Assert(False);
          end;
          ParameterName := ParameterName + IntToStr(StressPeriod);
          Expression := LayerName + '.' + ParameterName;
          Write2DArray(CurrentModelHandle, DisWriter, Expression);
        end;

      end;
    end;
  end;
end;

procedure TMt3dSSMWriter.EvaluateDataSets7And8;
var
  StressPeriod : integer;
  Lines : TStringList;
  Basic : TBasicPkgWriter;
  Well : TWellPkgWriter;
  Drain : TDrainPkgWriter;
  River : TRiverPkgWriter;
  GHB : TGHBPkgWriter;
  STR : TStrWriter;
  Reservoir : TReservoirWriter;
  FHB : TFHBPkgWriter;
  CHD : TCHDPkgWriter;
  MNW: TMultiNodeWellWriter;
  DrainReturn : TDrainReturnPkgWriter;
begin
  EvaluateTVC;
  EvaluateMassFlux;
//  EvaluateConstantConcentrations;
  for StressPeriod := 1 to DisWriter.NPER do
  begin
    Lines := TStringList.Create;
    PointSources.Add(Lines);
    CellList.WriteMT3DConcentrations(StressPeriod, Lines);
  end;

  Basic := TBasicPkgWriter.Create;
  try
    Basic.InitializeMT3DConcentrations(CurrentModelHandle, DisWriter);
    for StressPeriod := 1 to DisWriter.NPER do
    begin
      Lines := PointSources[StressPeriod-1] as TStringList;
      Basic.WriteMT3DConcentrations(StressPeriod, Lines);
    end;

    if frmModflow.cbRES.Checked and frmModflow.cbRESRetain.Checked then
    begin
      Reservoir := TReservoirWriter.Create;
      try
        Reservoir.InitializeArrays(CurrentModelHandle, DisWriter, Basic, True);
        for StressPeriod := 1 to DisWriter.NPER do
        begin
          Lines := PointSources[StressPeriod-1] as TStringList;
          Reservoir.WriteMT3DConcentrations(StressPeriod, Lines);
        end;
      finally
        Reservoir.Free;
      end;
    end;
  finally
    Basic.Free;
  end;


  if frmModflow.cbWEL.Checked and frmModflow.cbWELRetain.Checked then
  begin
    Well := TWellPkgWriter.Create;
    try
      Well.Evaluate(CurrentModelHandle, DisWriter);
      for StressPeriod := 1 to DisWriter.NPER do
      begin
        Lines := PointSources[StressPeriod-1] as TStringList;
        Well.WriteMT3DConcentrations(StressPeriod, Lines);
      end;
    finally
      Well.Free
    end;
  end;


  if frmModflow.cbDRN.Checked and frmModflow.cbDRNRetain.Checked then
  begin
    Drain := TDrainPkgWriter.Create;
    try
      Drain.Evaluate(CurrentModelHandle, DisWriter);
      for StressPeriod := 1 to DisWriter.NPER do
      begin
        Lines := PointSources[StressPeriod-1] as TStringList;
        Drain.WriteMT3DConcentrations(StressPeriod, Lines);
      end;
    finally
      Drain.Free
    end;
  end;

  if frmModflow.cbRIV.Checked and frmModflow.cbRIVRetain.Checked then
  begin
    River := TRiverPkgWriter.Create;
    try
      River.Evaluate(CurrentModelHandle, DisWriter);
      for StressPeriod := 1 to DisWriter.NPER do
      begin
        Lines := PointSources[StressPeriod-1] as TStringList;
        River.WriteMT3DConcentrations(StressPeriod, Lines);
      end;
    finally
      River.Free
    end;
  end;

  if frmModflow.cbGHB.Checked and frmModflow.cbGHBRetain.Checked then
  begin
    GHB := TGHBPkgWriter.Create;
    try
      GHB.Evaluate(CurrentModelHandle, DisWriter);
      for StressPeriod := 1 to DisWriter.NPER do
      begin
        Lines := PointSources[StressPeriod-1] as TStringList;
        GHB.WriteMT3DConcentrations(StressPeriod, Lines);
      end;
    finally
      GHB.Free
    end;
  end;

  if frmModflow.cbSTR.Checked and frmModflow.cbSTRRetain.Checked then
  begin
    STR := TStrWriter.Create;
    try
      STR.Evaluate(DisWriter);
      for StressPeriod := 1 to DisWriter.NPER do
      begin
        Lines := PointSources[StressPeriod-1] as TStringList;
        STR.WriteMT3DConcentrations(StressPeriod, Lines);
      end;
    finally
      STR.Free
    end;
  end;

  if frmModflow.cbFHB.Checked and frmModflow.cbFHBRetain.Checked then
  begin
    FHB := TFHBPkgWriter.Create;
    try
      FHB.Evaluate(CurrentModelHandle, DisWriter);
      for StressPeriod := 1 to DisWriter.NPER do
      begin
        Lines := PointSources[StressPeriod-1] as TStringList;
        FHB.WriteMT3DConcentrations(StressPeriod, Lines);
      end;
    finally
      FHB.Free
    end;
  end;

  if frmModflow.cbCHD.Checked and frmModflow.cbCHDRetain.Checked then
  begin
    CHD := TCHDPkgWriter.Create;
    try
      CHD.Evaluate(CurrentModelHandle, DisWriter);
      for StressPeriod := 1 to DisWriter.NPER do
      begin
        Lines := PointSources[StressPeriod-1] as TStringList;
        CHD.WriteMT3DConcentrations(StressPeriod, Lines);
      end;
    finally
      CHD.Free
    end;
  end;

  if frmModflow.cbMNW.Checked and frmModflow.cbMNW_Use.Checked then
  begin
    MNW := TMultiNodeWellWriter.Create;
    try
      MNW.Evaluate(CurrentModelHandle, DisWriter);
      for StressPeriod := 1 to DisWriter.NPER do
      begin
        Lines := PointSources[StressPeriod-1] as TStringList;
        MNW.WriteMT3DConcentrations(StressPeriod, Lines);
      end;
    finally
      MNW.Free
    end;
  end;

  if frmModflow.cbDRT.Checked and frmModflow.cbDRTRetain.Checked then
  begin
    DrainReturn := TDrainReturnPkgWriter.Create;
    try
      DrainReturn.Evaluate(CurrentModelHandle, DisWriter);
      for StressPeriod := 1 to DisWriter.NPER do
      begin
        Lines := PointSources[StressPeriod-1] as TStringList;
        DrainReturn.WriteMT3DConcentrations(StressPeriod, Lines);
      end;
    finally
      DrainReturn.Free
    end;
  end;


end;

procedure TMt3dSSMWriter.WriteDataSet2;
var
  MXSS, ISSGOUT : integer;
  Lines : TStringList;
  Index : integer;
begin
  MXSS := 0;
  for Index := 0 to PointSources.Count -1 do
  begin
    Lines := PointSources[Index] as TStringList;
    if Lines.Count > MXSS then
    begin
      MXSS := Lines.Count;
    end;
  end;
  if frmModflow.cbMt3dMultinodeWellOutput.Checked then
  begin
    ISSGOUT := frmModflow.GetUnitNumber('ISSGOUT');
  end
  else
  begin
    ISSGOUT := 0;
  end;

  WriteLn(FFile, FixedFormattedInteger(MXSS, 10),
    FixedFormattedInteger(ISSGOUT, 10));
end;

procedure TMt3dSSMWriter.WriteFile(const ModelHandle: ANE_PTR;
  const Root: string; const Discretization: TDiscretizationWriter);
var
  FileName : string;
  StressPeriod : integer;
begin
  Assert(Discretization <> nil);
  CurrentModelHandle := ModelHandle;
  DisWriter := Discretization;
  FileName := GetCurrentDir + '\' + Root + rsSSM;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);
    frmProgress.pbPackage.Position := 0;
    frmProgress.pbPackage.Max := 2 + 3*DisWriter.NPER;

    EvaluateDataSets7And8;
    frmProgress.pbPackage.Max := 2 + 3*DisWriter.NPER;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet1;
    WriteDataSet2;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    frmProgress.pbPackage.Max := 2 + 3*DisWriter.NPER;
    for StressPeriod := 1 to DisWriter.NPER do
    begin
      WriteDataSets3And4(StressPeriod);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then Exit;

      WriteDataSets5And6(StressPeriod);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then Exit;

      WriteDataSets7And8(StressPeriod);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then Exit;

    end;
  finally
    CloseFile(FFile);
  end;
end;

{procedure TMt3dSSMWriter.EvaluateConstantConcentrations;
var
  UnitIndex : integer;
  LayerName : string;
  Layer : TLayerOptions;
  AreaParamIndicies : TAreaConstantConcParamIndicies;
  PointParamIndicies : TPointConstantConcParamIndicies;
  contourIndex : integer;
  ContourCount : integer;
  Contour : TContourObjectOptions;
  RowIndex, ColIndex : integer;
  CellRecord : TMT3DCellRecord;
  CellTop, CellBottom, UnitThickness: double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  Expression : string;
  StressPeriodCount, SpeciesCount : integer;
  GridAngle : ANE_DOUBLE;
  GridLayerHandle : ANE_PTR ;
  RotatedX, RotatedY : ANE_DOUBLE;
  LayersAbove : integer;
  DiscretizationCount : integer;
  DisIndex : integer;
  LayerThickness : double;
  DisCellTop, DisCellBottom : double;
  SpeciesIndex : integer;
  Errors : TStringList;
  AString : string;
  CellIndex : integer;
  StressIndex: integer;
  CellVolume: double;
begin
  Errors := TStringList.Create;
  try
    CellRecord.BoundaryType := btConstantConcentration;
    GetGridAngle(CurrentModelHandle, ModflowTypes.GetGridLayerType.ANE_LayerName,
      GridLayerHandle, GridAngle);
    StressPeriodCount := DisWriter.NPER;
    SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    SetLength(CellRecord.MT3DValues, StressPeriodCount, SpeciesCount);
    LayersAbove := 0;

    for UnitIndex := 1 to frmModflow.UnitCount do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        DiscretizationCount := frmModflow.DiscretizationCount(UnitIndex);
        LayerName := ModflowTypes.GetMT3DAreaConstantConcLayerType.ANE_LayerName
          + IntToStr(UnitIndex);
        Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
        try
          ContourCount := Layer.NumObjects(CurrentModelHandle,pieContourObject);
          if ContourCount > 0 then
          begin
            AreaParamIndicies := GetAreaConstantConcParamIndicies(Layer);
            AddVertexLayer(CurrentModelHandle,LayerName);
            for contourIndex := 0 to ContourCount-1 do
            begin
              if not ContinueExport then break;
              frmProgress.pbActivity.StepIt;
              Application.ProcessMessages;
              Contour := TContourObjectOptions.Create
                (CurrentModelHandle,Layer.LayerHandle,ContourIndex);
              try
                if Contour.ContourType(CurrentModelHandle) <> ctClosed then
                begin
                  Continue;
                end
                else
                begin
                  for ColIndex := 1 to DisWriter.NCOL do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    CellRecord.Column := ColIndex;
                    for RowIndex := 1 to DisWriter.NROW do
                    begin
                      if not ContinueExport then break;
                      Application.ProcessMessages;
                      CellRecord.Row := RowIndex;

                      BlockIndex := DisWriter.BlockIndex(RowIndex -1, ColIndex -1);
                      ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                        DisWriter.GridLayerHandle,BlockIndex);
                      try
                        ABlock.GetCenter(CurrentModelHandle,X,Y);
                      finally
                        ABlock.Free;
                      end;
                      RotatedX := X;
                      RotatedY := Y;
                      RotatePointsToGrid(RotatedX, RotatedY, GridAngle);

                      if GPointInsideContour(contourIndex, RotatedX, RotatedY) then
                      begin
                        for SpeciesIndex := 0 to SpeciesCount -1 do
                        begin
                          Expression := LayerName + '.' + AreaParamIndicies.
                            ValueNames[SpeciesIndex];
                          CellRecord.MT3DValues[0, SpeciesIndex]
                            := Layer.RealValueAtXY(CurrentModelHandle,X,Y,Expression);
                        end;
                        for StressIndex := 1 to StressPeriodCount -1 do
                        begin
                          for SpeciesIndex := 0 to SpeciesCount -1 do
                          begin
                            CellRecord.MT3DValues[StressIndex-1, SpeciesIndex]
                              := CellRecord.MT3DValues[0, SpeciesIndex]
                          end;
                        end;

                        for DisIndex := 1 to DiscretizationCount do
                        begin
                            CellRecord.Layer := LayersAbove + DisIndex;
                            CellList.Add(CellRecord, Errors);
                        end;
                      end;
                    end;
                  end;
                end;
{                else
                begin
                  // open or point contour
//                  Top := Contour.GetFloatParameter(CurrentModelHandle,ParamIndicies.TopIndex);
//                  Bottom := Contour.GetFloatParameter(CurrentModelHandle,ParamIndicies.BottomIndex);
                  if Bottom > Top then
                  begin
                    Bottom := Top;
                  end;

                  for StressPeriodIndex := 0 to StressPeriodCount-1 do
                  begin
                    for SpeciesIndex := 0 to SpeciesCount -1 do
                    begin
                      CellRecord.MT3DValues[StressPeriodIndex,SpeciesIndex]
                        := Contour.GetFloatParameter(CurrentModelHandle,
                        ParamIndicies.ValueIndicies[StressPeriodIndex,SpeciesIndex]);
                    end;
                  end;

                  for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    CellRecord.Row := GGetCellRow(ContourIndex, CellIndex);
                    CellRecord.Column := GGetCellColumn(ContourIndex, CellIndex);
                    CellTop := DisWriter.Elevations[CellRecord.Column-1,CellRecord.Row-1,UnitIndex-1];
                    CellBottom := DisWriter.Elevations[CellRecord.Column-1,CellRecord.Row-1,UnitIndex];
                    UnitThickness := CellTop - CellBottom;
                    if UnitThickness <= 0 then Continue;

                    LayerThickness := UnitThickness/DiscretizationCount;
                    for DisIndex := 1 to DiscretizationCount do
                    begin
                      DisCellTop := CellTop - (DisIndex-1)* LayerThickness;
                      DisCellBottom := CellTop - DisIndex * LayerThickness;
                      if (Top >= DisCellBottom) and (Bottom <= DisCellTop) then
                      begin
                        CellRecord.Layer := LayersAbove + DisIndex;
                        CellList.Add(CellRecord, Errors);
                      end;

                    end;

                  end;

                end;}

{              finally
                Contour.Free;
              end;

            end;
          end;
        finally
          Layer.Free(CurrentModelHandle);
        end;









        LayerName := ModflowTypes.GetMT3DPointConstantConcLayerType.ANE_LayerName
          + IntToStr(UnitIndex);
        Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
        try
          ContourCount := Layer.NumObjects(CurrentModelHandle,pieContourObject);
          if ContourCount > 0 then
          begin
            PointParamIndicies := GetPointConstantConcParamIndicies(Layer);
            AddVertexLayer(CurrentModelHandle,LayerName);
            for contourIndex := 0 to ContourCount-1 do
            begin
              if not ContinueExport then break;
              frmProgress.pbActivity.StepIt;
              Application.ProcessMessages;
              Contour := TContourObjectOptions.Create
                (CurrentModelHandle,Layer.LayerHandle,ContourIndex);
              try
                if Contour.ContourType(CurrentModelHandle) <> ctPoint then
                begin
                  Continue;
                end
                else
                begin
                  // open or point contour

                  for SpeciesIndex := 0 to SpeciesCount -1 do
                  begin
                    CellRecord.MT3DValues[0,SpeciesIndex]
                      := Contour.GetFloatParameter(CurrentModelHandle,
                      PointParamIndicies.ValueIndicies[SpeciesIndex]);
                  end;
                  for StressIndex := 1 to StressPeriodCount-1 do
                  begin
                    for SpeciesIndex := 0 to SpeciesCount -1 do
                    begin
                      CellRecord.MT3DValues[StressIndex,SpeciesIndex]
                        := CellRecord.MT3DValues[0,SpeciesIndex];
                    end;
                  end;

                  Assert(GGetCountOfACellList(ContourIndex) <= 1);
                  for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    CellRecord.Row := GGetCellRow(ContourIndex, CellIndex);
                    CellRecord.Column := GGetCellColumn(ContourIndex, CellIndex);

                    CellTop := DisWriter.Elevations[CellRecord.Column-1,CellRecord.Row-1,UnitIndex-1];
                    CellBottom := DisWriter.Elevations[CellRecord.Column-1,CellRecord.Row-1,UnitIndex];
                    UnitThickness := CellTop - CellBottom;
                    CellVolume := UnitThickness *
                      DisWriter.DELC[CellRecord.Row-1] *
                      DisWriter.DELR[CellRecord.Column-1] /
                      DiscretizationCount;

                    if CellVolume <> 0 then
                    begin
                      for StressIndex := 0 to StressPeriodCount-1 do
                      begin
                        for SpeciesIndex := 0 to SpeciesCount -1 do
                        begin
                          CellRecord.MT3DValues[StressIndex,SpeciesIndex]
                            := CellRecord.MT3DValues[StressIndex,SpeciesIndex]
                            / CellVolume;
                        end;
                      end;
                    end;

                    for DisIndex := 1 to DiscretizationCount do
                    begin
                      CellRecord.Layer := LayersAbove + DisIndex;
                      CellList.Add(CellRecord, Errors);
                    end;

                  end;

                end;

              finally
                Contour.Free;
              end;

            end;
          end;
        finally
          Layer.Free(CurrentModelHandle);
        end;












        LayersAbove := LayersAbove + DiscretizationCount;
      end;
    end;
    if Errors.Count > 0 then
    begin
      begin
        AString := 'warning: Some Time-varying concentrations are at the '
          + 'same locations as specified mass flux cells.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := '[Layer, Row, Col]';
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(Errors);
      end;
    end;

  finally
    Errors.Free;
  end;
end;   }

procedure TMt3dSSMWriter.EvaluateTVC;
var
  UnitIndex : integer;
  LayerName : string;
  Layer : TLayerOptions;
  ParamIndicies : TTVCParamIndicies;
  contourIndex : integer;
  ContourCount : integer;
  Contour : TContourObjectOptions;
  RowIndex, ColIndex : integer;
  CellRecord : TMT3DCellRecord;
  CellTop, CellBottom : double;
  UnitThickness : double;
  Top, Bottom : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  Expression : string;
  StressPeriodCount, SpeciesCount : integer;
  GridAngle : ANE_DOUBLE;
  GridLayerHandle : ANE_PTR ;
  RotatedX, RotatedY : ANE_DOUBLE;
  LayersAbove : integer;
  DiscretizationCount : integer;
  DisIndex : integer;
  LayerThickness : double;
  DisCellTop, DisCellBottom : double;
  StressPeriodIndex, SpeciesIndex : integer;
  Errors : TStringList;
  AString : string;
  CellIndex : integer;
begin
  if not frmModflow.cbMT3D_TVC.Checked then Exit;
  Errors := TStringList.Create;
  try
    CellRecord.BoundaryType := btTimeVaryingConcentration;
    GetGridAngle(CurrentModelHandle, ModflowTypes.GetGridLayerType.ANE_LayerName,
      GridLayerHandle, GridAngle);
    StressPeriodCount := DisWriter.NPER;
    SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    SetLength(CellRecord.MT3DValues, StressPeriodCount, SpeciesCount);
    LayersAbove := 0;

    for UnitIndex := 1 to frmModflow.UnitCount do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        DiscretizationCount := frmModflow.DiscretizationCount(UnitIndex);
        LayerName := ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName
          + IntToStr(UnitIndex);
        Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
        try
          ContourCount := Layer.NumObjects(CurrentModelHandle,pieContourObject);
          if ContourCount > 0 then
          begin
            ParamIndicies := GetTVCIndicies(Layer);
            AddVertexLayer(CurrentModelHandle,LayerName);
            for contourIndex := 0 to ContourCount-1 do
            begin
              if not ContinueExport then break;
              frmProgress.pbActivity.StepIt;
              Application.ProcessMessages;
              Contour := TContourObjectOptions.Create
                (CurrentModelHandle,Layer.LayerHandle,ContourIndex);
              try
                if Contour.ContourType(CurrentModelHandle) = ctClosed then
                begin
                  for ColIndex := 1 to DisWriter.NCOL do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    CellRecord.Column := ColIndex;
                    for RowIndex := 1 to DisWriter.NROW do
                    begin
                      if not ContinueExport then break;
                      Application.ProcessMessages;
                      CellRecord.Row := RowIndex;

                      CellTop := DisWriter.Elevations[CellRecord.Column-1,CellRecord.Row-1,UnitIndex-1];
                      CellBottom := DisWriter.Elevations[CellRecord.Column-1,CellRecord.Row-1,UnitIndex];
                      UnitThickness := CellTop - CellBottom;
                      if UnitThickness <= 0 then Continue;

                      BlockIndex := DisWriter.BlockIndex(RowIndex -1, ColIndex -1);
                      ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                        DisWriter.GridLayerHandle,BlockIndex);
                      try
                        ABlock.GetCenter(CurrentModelHandle,X,Y);
                      finally
                        ABlock.Free;
                      end;
                      RotatedX := X;
                      RotatedY := Y;
                      RotatePointsToGrid(RotatedX, RotatedY, GridAngle);

                      if GPointInsideContour(contourIndex, RotatedX, RotatedY) then
                      begin
                        for StressPeriodIndex := 0 to StressPeriodCount-1 do
                        begin
                          for SpeciesIndex := 0 to SpeciesCount -1 do
                          begin
                            Expression := LayerName + '.' + ParamIndicies.
                              ValueNames[StressPeriodIndex,SpeciesIndex];
                            CellRecord.MT3DValues[StressPeriodIndex,SpeciesIndex]
                              := Layer.RealValueAtXY(CurrentModelHandle,X,Y,Expression);
                          end;
                        end;


                        Expression := LayerName + '.' + ParamIndicies.TopName;
                        Top := Layer.RealValueAtXY(CurrentModelHandle,X,Y,Expression);
                        Expression := LayerName + '.' + ParamIndicies.BottomName;
                        Bottom := Layer.RealValueAtXY(CurrentModelHandle,X,Y,Expression);
                        if Bottom > Top then
                        begin
                          Bottom := Top;
                        end;

                        LayerThickness := UnitThickness/DiscretizationCount;
                        for DisIndex := 1 to DiscretizationCount do
                        begin
                          DisCellTop := CellTop - (DisIndex-1)* LayerThickness;
                          DisCellBottom := CellTop - DisIndex * LayerThickness;
                          if (Top >= DisCellBottom) and (Bottom <= DisCellTop) then
                          begin
                            CellRecord.Layer := LayersAbove + DisIndex;
                            CellList.Add(CellRecord, Errors);
                          end;

                        end;

                      end;
                    end;
                  end;
                end
                else
                begin
                  // open or point contour
                  Top := Contour.GetFloatParameter(CurrentModelHandle,ParamIndicies.TopIndex);
                  Bottom := Contour.GetFloatParameter(CurrentModelHandle,ParamIndicies.BottomIndex);
                  if Bottom > Top then
                  begin
                    Bottom := Top;
                  end;

                  for StressPeriodIndex := 0 to StressPeriodCount-1 do
                  begin
                    for SpeciesIndex := 0 to SpeciesCount -1 do
                    begin
                      CellRecord.MT3DValues[StressPeriodIndex,SpeciesIndex]
                        := Contour.GetFloatParameter(CurrentModelHandle,
                        ParamIndicies.ValueIndicies[StressPeriodIndex,SpeciesIndex]);
                    end;
                  end;

                  for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    CellRecord.Row := GGetCellRow(ContourIndex, CellIndex);
                    CellRecord.Column := GGetCellColumn(ContourIndex, CellIndex);
                    CellTop := DisWriter.Elevations[CellRecord.Column-1,CellRecord.Row-1,UnitIndex-1];
                    CellBottom := DisWriter.Elevations[CellRecord.Column-1,CellRecord.Row-1,UnitIndex];
                    UnitThickness := CellTop - CellBottom;
                    if UnitThickness <= 0 then Continue;

                    LayerThickness := UnitThickness/DiscretizationCount;
                    for DisIndex := 1 to DiscretizationCount do
                    begin
                      DisCellTop := CellTop - (DisIndex-1)* LayerThickness;
                      DisCellBottom := CellTop - DisIndex * LayerThickness;
                      if (Top >= DisCellBottom) and (Bottom <= DisCellTop) then
                      begin
                        CellRecord.Layer := LayersAbove + DisIndex;
                        CellList.Add(CellRecord, Errors);
                      end;

                    end;

                  end;

                end;

              finally
                Contour.Free;
              end;

            end;
          end;
        finally
          Layer.Free(CurrentModelHandle);
        end;
        LayersAbove := LayersAbove + DiscretizationCount;
      end;
    end;
    if Errors.Count > 0 then
    begin
      begin
        AString := 'warning: Some Time-varying concentrations are at the '
          + 'same locations as specified mass flux cells.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := '[Layer, Row, Col]';
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(Errors);
      end;
    end;

  finally
    Errors.Free;
  end;

end;

function TMt3dSSMWriter.GetTVCIndicies(const Layer: TLayerOptions): TTVCParamIndicies;
var
  ParamName : string;
  StressPeriodCount, SpeciesCount : integer;
  StressIndex, SpeciesIndex : integer;
begin
  result.TopName := ModflowTypes.GetMT3DTopElevParamClassType.ANE_ParamName;
  result.TopIndex := Layer.GetParameterIndex(CurrentModelHandle, result.TopName);

  result.BottomName := ModflowTypes.GetMT3DBottomElevParamClassType.ANE_ParamName;
  result.BottomIndex := Layer.GetParameterIndex(CurrentModelHandle, result.BottomName);

  StressPeriodCount := DisWriter.NPER;
  SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
  SetLength(result.ValueIndicies,StressPeriodCount, SpeciesCount);
  SetLength(result.ValueNames,StressPeriodCount, SpeciesCount);
  for StressIndex := 1 to StressPeriodCount  do
  begin
    for SpeciesIndex := 1 to SpeciesCount do
    begin
      case SpeciesIndex of
        1: ParamName := ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName;
        2: ParamName := ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName;
        3: ParamName := ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName;
        4: ParamName := ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName;
        5: ParamName := ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName;
      else Assert(False);
      end;
      ParamName := ParamName + IntToStr(StressIndex);
      result.ValueNames[StressIndex-1,SpeciesIndex-1] := ParamName;
      result.ValueIndicies[StressIndex-1,SpeciesIndex-1] :=
        Layer.GetParameterIndex(CurrentModelHandle, ParamName);
    end;
  end;
end;

function TMt3dSSMWriter.GetMassFluxIndicies(
  const Layer: TLayerOptions): TMassFluxParamIndicies;
var
  ParamName : string;
  StressPeriodCount, SpeciesCount : integer;
  StressIndex, SpeciesIndex : integer;
begin
  ParamName := ModflowTypes.GetMFElevationParamType.ANE_ParamName;
  result.ElevationIndex := Layer.GetParameterIndex(CurrentModelHandle, ParamName);

  StressPeriodCount := DisWriter.NPER;
  SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
  SetLength(result.ValueIndicies,StressPeriodCount, SpeciesCount);
  for StressIndex := 1 to StressPeriodCount  do
  begin
    for SpeciesIndex := 1 to SpeciesCount do
    begin
      case SpeciesIndex of
        1: ParamName := ModflowTypes.GetMT3DMassFluxAParamClassType.ANE_ParamName;
        2: ParamName := ModflowTypes.GetMT3DMassFluxBParamClassType.ANE_ParamName;
        3: ParamName := ModflowTypes.GetMT3DMassFluxCParamClassType.ANE_ParamName;
        4: ParamName := ModflowTypes.GetMT3DMassFluxDParamClassType.ANE_ParamName;
        5: ParamName := ModflowTypes.GetMT3DMassFluxEParamClassType.ANE_ParamName;
      else Assert(False);
      end;
      ParamName := ParamName + IntToStr(StressIndex);
      result.ValueIndicies[StressIndex-1,SpeciesIndex-1] :=
        Layer.GetParameterIndex(CurrentModelHandle, ParamName);
    end;
  end;
end;

procedure TMt3dSSMWriter.EvaluateMassFlux;
var
  UnitIndex : integer;
  LayerName : string;
  Layer : TLayerOptions;
  ParamIndicies : TMassFluxParamIndicies;
  contourIndex : integer;
  ContourCount : integer;
  Contour : TContourObjectOptions;
  RowIndex, ColIndex : integer;
  CellRecord : TMT3DCellRecord;
  CellTop, CellBottom : double;
  UnitThickness : double;
  Elevation : double;
  BlockIndex : integer;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  Expression : string;
  StressPeriodCount, SpeciesCount : integer;
  GridAngle : ANE_DOUBLE;
  GridLayerHandle : ANE_PTR ;
  RotatedX, RotatedY : ANE_DOUBLE;
  LayersAbove : integer;
  DiscretizationCount : integer;
  DisIndex : integer;
  LayerThickness : double;
  DisCellTop, DisCellBottom : double;
  StressPeriodIndex, SpeciesIndex : integer;
  Errors : TStringList;
  AString : string;
  CellIndex : integer;
begin
  if not frmModflow.cbMT3DMassFlux.Checked then Exit;
  Errors := TStringList.Create;
  try
    CellRecord.BoundaryType := btMassFlux;
    GetGridAngle(CurrentModelHandle, ModflowTypes.GetGridLayerType.ANE_LayerName,
      GridLayerHandle, GridAngle);
    StressPeriodCount := DisWriter.NPER;
    SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    SetLength(CellRecord.MT3DValues, StressPeriodCount, SpeciesCount);
    LayersAbove := 0;

    for UnitIndex := 1 to frmModflow.UnitCount do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        DiscretizationCount := frmModflow.DiscretizationCount(UnitIndex);
        LayerName := ModflowTypes.GetMT3DMassFluxLayerType.ANE_LayerName
          + IntToStr(UnitIndex);
        Layer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
        try
          ContourCount := Layer.NumObjects(CurrentModelHandle,pieContourObject);
          if ContourCount > 0 then
          begin
            ParamIndicies := GetMassFluxIndicies(Layer);
            AddVertexLayer(CurrentModelHandle,LayerName);
            for contourIndex := 0 to ContourCount-1 do
            begin
              if not ContinueExport then break;
              frmProgress.pbActivity.StepIt;
              Application.ProcessMessages;
              Contour := TContourObjectOptions.Create
                (CurrentModelHandle,Layer.LayerHandle,ContourIndex);
              try
                if Contour.ContourType(CurrentModelHandle) = ctPoint then
                begin
                  // point contour
                  Elevation := Contour.GetFloatParameter(CurrentModelHandle,ParamIndicies.ElevationIndex);

                  for StressPeriodIndex := 0 to StressPeriodCount-1 do
                  begin
                    for SpeciesIndex := 0 to SpeciesCount -1 do
                    begin
                      CellRecord.MT3DValues[StressPeriodIndex,SpeciesIndex]
                        := Contour.GetFloatParameter(CurrentModelHandle,
                        ParamIndicies.ValueIndicies[StressPeriodIndex,SpeciesIndex]);
                    end;
                  end;

                  for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    CellRecord.Row := GGetCellRow(ContourIndex, CellIndex);
                    CellRecord.Column := GGetCellColumn(ContourIndex, CellIndex);
                    CellTop := DisWriter.Elevations[CellRecord.Column-1,CellRecord.Row-1,UnitIndex-1];
                    CellBottom := DisWriter.Elevations[CellRecord.Column-1,CellRecord.Row-1,UnitIndex];
                    UnitThickness := CellTop - CellBottom;
                    if UnitThickness <= 0 then Continue;

                    LayerThickness := UnitThickness/DiscretizationCount;
                    for DisIndex := 1 to DiscretizationCount do
                    begin
                      DisCellTop := CellTop - (DisIndex-1)* LayerThickness;
                      DisCellBottom := CellTop - DisIndex * LayerThickness;
                      if (Elevation >= DisCellBottom) and (Elevation <= DisCellTop) then
                      begin
                        CellRecord.Layer := LayersAbove + DisIndex;
                        CellList.Add(CellRecord, Errors);
                      end;

                    end;

                  end;

                end;

              finally
                Contour.Free;
              end;

            end;
          end;
        finally
          Layer.Free(CurrentModelHandle);
        end;
        LayersAbove := LayersAbove + DiscretizationCount;
      end;
    end;
    if Errors.Count > 0 then
    begin
      begin
        AString := 'warning: Some Time-varying concentrations are at the '
          + 'same locations as specified mass flux cells.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);

        AString := '[Layer, Row, Col]';
        ErrorMessages.Add(AString);
        ErrorMessages.AddStrings(Errors);
      end;
    end;

  finally
    Errors.Free;
  end;

end;

{function TMt3dSSMWriter.GetAreaConstantConcParamIndicies(
  const Layer: TLayerOptions): TAreaConstantConcParamIndicies;
var
  ParamName : string;
  SpeciesCount : integer;
  SpeciesIndex : integer;
begin
  SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
  SetLength(result.ValueIndicies, SpeciesCount);
  SetLength(result.ValueNames, SpeciesCount);
  for SpeciesIndex := 1 to SpeciesCount do
  begin
    case SpeciesIndex of
      1: ParamName := ModflowTypes.GetMT3DAreaConstantConcParamClassType.ANE_ParamName;
      2: ParamName := ModflowTypes.GetMT3DAreaConstantConc2ParamClassType.ANE_ParamName;
      3: ParamName := ModflowTypes.GetMT3DAreaConstantConc3ParamClassType.ANE_ParamName;
      4: ParamName := ModflowTypes.GetMT3DAreaConstantConc4ParamClassType.ANE_ParamName;
      5: ParamName := ModflowTypes.GetMT3DAreaConstantConc5ParamClassType.ANE_ParamName;
    else Assert(False);
    end;
    result.ValueNames[SpeciesIndex-1] := ParamName;
    result.ValueIndicies[SpeciesIndex-1] :=
      Layer.GetParameterIndex(CurrentModelHandle, ParamName);
  end;
end;

function TMt3dSSMWriter.GetPointConstantConcParamIndicies(
  const Layer: TLayerOptions): TPointConstantConcParamIndicies;
var
  ParamName : string;
  SpeciesCount : integer;
  SpeciesIndex : integer;
begin
  SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
  SetLength(result.ValueIndicies, SpeciesCount);
  SetLength(result.ValueNames, SpeciesCount);
  for SpeciesIndex := 1 to SpeciesCount do
  begin
    case SpeciesIndex of
      1: ParamName := ModflowTypes.GetMT3DAreaConstantConcParamClassType.ANE_ParamName;
      2: ParamName := ModflowTypes.GetMT3DAreaConstantConc2ParamClassType.ANE_ParamName;
      3: ParamName := ModflowTypes.GetMT3DAreaConstantConc3ParamClassType.ANE_ParamName;
      4: ParamName := ModflowTypes.GetMT3DAreaConstantConc4ParamClassType.ANE_ParamName;
      5: ParamName := ModflowTypes.GetMT3DAreaConstantConc5ParamClassType.ANE_ParamName;
    else Assert(False);
    end;
    result.ValueNames[SpeciesIndex-1] := ParamName;
    result.ValueIndicies[SpeciesIndex-1] :=
      Layer.GetParameterIndex(CurrentModelHandle, ParamName);
  end;
end; }

{ TMT3DCell }

procedure TMT3DCell.Write(const Lines: TStringList;
  const StressPeriod : integer);
var
  ITYPE : integer;
  ALine : string;
  SpeciesIndex : integer;
begin
  ITYPE := 0;
  if Cell.BoundaryType = btTimeVaryingConcentration then
  begin
    ITYPE := -1;
  end
  else if Cell.BoundaryType = btMassFlux then
  begin
    ITYPE := 15;
  end
  else
  begin
    Assert(False);
  end;
  Assert((Length(Cell.MT3DValues) >=StressPeriod) and (Length(Cell.MT3DValues[0]) >=1));
  ALine := TModflowWriter.FixedFormattedInteger(Cell.Layer, 10)
    + TModflowWriter.FixedFormattedInteger(Cell.Row, 10)
    + TModflowWriter.FixedFormattedInteger(Cell.Column, 10)
    + TModflowWriter.FixedFormattedReal(Cell.MT3DValues[StressPeriod-1,0], 10)
    + TModflowWriter.FixedFormattedInteger(ITYPE, 10) + ' ';
  for SpeciesIndex := 0 to Length(Cell.MT3DValues[0])-1 do
  begin
    ALine := ALine + TModflowWriter.FreeFormattedReal
      (Cell.MT3DValues[StressPeriod-1,SpeciesIndex]);
  end;
  Lines.Add(ALine);
end;

{ TMT3D_CellList }

function TMT3D_CellList.Add(const ACell: TMT3DCellRecord;
  const Errors : TStringList): integer;
var
  Cell : TMT3DCell;
  Index1, Index2 : integer;
begin
  Cell := GetCellByLocation(ACell.Layer, ACell.Row, ACell.Column);
  if Cell = nil then
  begin
    Cell := TMT3DCell.Create;
    result := inherited Add(Cell);
    Cell.Cell.Layer := ACell.Layer;
    Cell.Cell.Row := ACell.Row;
    Cell.Cell.Column := ACell.Column;
    Cell.Cell.BoundaryType := ACell.BoundaryType;
    Copy2DDoubleArray(ACell.MT3DValues, Cell.Cell.MT3DValues);
  end
  else
  begin
    if Cell.Cell.BoundaryType <> ACell.BoundaryType then
    begin
      Errors.Add(Format('%d, %d, %d', [ACell.Layer, ACell.Row, ACell.Column]));
      result := -1;
      Exit;
    end;
    result := IndexOf(Cell);

    if ACell.BoundaryType = btTimeVaryingConcentration then
    begin
      for Index1 := 0 to Length(ACell.MT3DValues) -1 do
      begin
        for Index2 := 0 to Length(ACell.MT3DValues[Index1]) -1 do
        begin
          if ACell.MT3DValues[Index1,Index2] > Cell.Cell.MT3DValues[Index1,Index2] then
          begin
            Cell.Cell.MT3DValues[Index1,Index2]:= ACell.MT3DValues[Index1,Index2];
          end;
        end;
      end;
    end
    else if ACell.BoundaryType = btMassFlux then
    begin
      for Index1 := 0 to Length(ACell.MT3DValues) -1 do
      begin
        for Index2 := 0 to Length(ACell.MT3DValues[Index1]) -1 do
        begin
          Cell.Cell.MT3DValues[Index1,Index2]:= Cell.Cell.MT3DValues[Index1,Index2]
            + ACell.MT3DValues[Index1,Index2];
        end;
      end;
    end
    else
    begin
      Assert(False);
    end;
  end;
end;

function TMT3D_CellList.GetCellByLocation(Layer, Row,
  Column: integer): TMT3DCell;
var
  Index : integer;
  ACell : TMT3DCell;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    ACell := Items[Index] as TMT3DCell;
    if (ACell.Cell.Layer = Layer) and (ACell.Cell.Row = Row)
      and (ACell.Cell.Column = Column) then
    begin
      result := ACell;
      Exit;
    end;
  end;

end;

procedure TMT3D_CellList.WriteMT3DConcentrations(const StressPeriod : integer;
      const Lines: TStringList);
var
  Index : integer;
  ACell : TMT3DCell;
begin
  for Index := 0 to Count -1 do
  begin
    ACell := Items[Index] as TMT3DCell;
    ACell.Write(Lines, StressPeriod);
  end;
end;

end.
