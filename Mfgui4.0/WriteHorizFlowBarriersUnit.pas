unit WriteHorizFlowBarriersUnit;

interface

uses Sysutils, Classes, Forms, ANEPIE, WriteModflowDiscretization, OptionsUnit;

type
  THFBRecord = record
    Layer, IROW1, ICOL1, IROW2, ICOL2 : integer;
    Hydchr : double;
    LongDisp : double;
    TransDispHorz : double;
    TransDispVert : double;
    DiffusionCoefficient : double;
  end;

  TBarrierList = Class(TList)
    function Add(ABarrier : THFBRecord) : integer; overload;
    procedure Clear; override;
  end;

  TBarrierParamValue = Class(TObject)
  private
    Value : double;
    BarrierList : TBarrierList;
  public
    Constructor Create(RowIndex : Integer);
    Destructor Destroy; override;
  end;

  THFBPkgWriter = class(TListWriter)
  private
    ParameterNames : TStringList;
    BarrierList : TBarrierList;
    MXFB : integer;
    NHFBNP : integer;
    NPHFB : integer;
    Procedure AddParameterNameCell(ParameterName : string;
      ABarrierRecord : THFBRecord; const InvalidParameterNames : TStringList);
    Procedure AddParameterName(RowIndex : integer);
    procedure EvaluateBarriers(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure GetParamIndicies(var IsParamIndex, ParamNameIndex,
      ConductivityIndex, ThicknessIndex, AdjustForAngleIndex: ANE_INT16;
      var IsParamName, ParamName,
      ConductivityName, ThicknessName, AdjustForAngleName: string; const
      CurrentModelHandle: ANE_PTR; const HFBLayer : TLayerOptions);
    procedure GetGWT_ParamIndicies(out LongDispIndex, HorzTransDispIndex,
      VertTransDispIndex, DispersionIndex: ANE_INT16;
      const CurrentModelHandle: ANE_PTR; const HFBLayer : TLayerOptions);
    procedure AddParameterNames;

    procedure EvaluateBarrierLayer(const CurrentModelHandle: ANE_PTR;
      UnitIndex: integer; ProjectOptions: TProjectOptions;
      Discretization: TDiscretizationWriter);
    procedure WriteDataSet1;
    procedure WriteDataSets2And3;
    procedure WriteDataSet4;
    procedure WriteDatasets5and6;
  public
    constructor Create;
    Destructor Destroy; override;
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
    procedure WriteCHFB_File(
      const CurrentModelHandle: ANE_PTR; Root: string);
  end;

  TBarrier = Class(TObject)
  private
    Barrier : THFBRecord;
    procedure WriteBarrier(HFBPkgWriter : THFBPkgWriter);
  end;



implementation

uses Variables, ModflowUnit, ProgressUnit, InitializeBlockUnit,
  InitializeVertexUnit, BlockListUnit, GetCellUnit, ModflowLayerFunctions,
  BL_SegmentUnit, GridUnit, PointInsideContourUnit, CrossColumnUnit,
  CrossRowUnit, WriteNameFileUnit, UtilityFunctions;

{ THFBPkgWriter }

procedure THFBPkgWriter.AddParameterNameCell(ParameterName : string;
      ABarrierRecord : THFBRecord; const InvalidParameterNames : TStringList);
var
  ParamIndex : integer;
  AParamValue : TBarrierParamValue;
//  ErrorMessage : string;
begin
  ParamIndex := ParameterNames.IndexOf(UpperCase(ParameterName));
  if ParamIndex < 0 then
  begin
    InvalidParameterNames.Add(ParameterName);
//    raise EInvalidParameterName.Create('Invalid parameter name: ' + ParameterName
//      + '.');
  end
  else
  begin
    AParamValue := ParameterNames.Objects[ParamIndex] as TBarrierParamValue;
    AParamValue.BarrierList.Add(ABarrierRecord);
  end;
end;

procedure THFBPkgWriter.GetParamIndicies(var IsParamIndex, ParamNameIndex,
  ConductivityIndex, ThicknessIndex, AdjustForAngleIndex: ANE_INT16; var IsParamName, ParamName,
  ConductivityName, ThicknessName, AdjustForAngleName: string; const
  CurrentModelHandle: ANE_PTR; const HFBLayer : TLayerOptions);
begin
  IsParamName := ModflowTypes.GetMFIsParameterParamType.WriteParamName;
  IsParamIndex := HFBLayer.GetParameterIndex(CurrentModelHandle, IsParamName);

  ParamName := ModflowTypes.GetMFModflowParameterNameParamType.WriteParamName;
  ParamNameIndex := HFBLayer.GetParameterIndex(CurrentModelHandle, ParamName);

  ConductivityName := ModflowTypes.GetMFHFBHydCondParamType.WriteParamName;
  ConductivityIndex := HFBLayer.GetParameterIndex(CurrentModelHandle, ConductivityName);

  ThicknessName := ModflowTypes.GetMFHFBBarrierThickParamType.WriteParamName;
  ThicknessIndex := HFBLayer.GetParameterIndex(CurrentModelHandle, ThicknessName);

  AdjustForAngleName := ModflowTypes.GetAdjustForAngleParamType.WriteParamName;
  AdjustForAngleIndex := HFBLayer.GetParameterIndex(CurrentModelHandle, AdjustForAngleName);
end;


procedure THFBPkgWriter.EvaluateBarrierLayer(const
  CurrentModelHandle: ANE_PTR; UnitIndex : integer;
  ProjectOptions : TProjectOptions; Discretization : TDiscretizationWriter);
var
  LayerName : string;
  LayerHandle : ANE_PTR;
  HFBLayer : TLayerOptions;
  GridLayer : TLayerOptions;
  IsParamIndex : ANE_INT16;
  ParamNameIndex : ANE_INT16;
  ConductivityIndex : ANE_INT16;
  ThicknessIndex : ANE_INT16;
  ContourCount : integer;
  ContourIndex : integer;
  Contour : TContourObjectOptions;
  IsParam : boolean;
  ParameterName : string;
  ABarrier : THFBRecord;
  CellIndex : integer;
  ContourConductance : double;
  BarrierThickness : double;
  IsParamName, ParamName, ConductivityName, ThicknessName: string;
  ContourType : TArgusContourType;
  LayersAbove : integer;
  LayerIndex : integer;
  AdjustForAngleIndex : ANE_INT16;
  AdjustForAngleName : string;
  AdjustForAngle : boolean;
  InvalidParameterNames : TStringList;
  ErrorString : string;
  LongDispIndex, HorzTransDispIndex, VertTransDispIndex: ANE_INT16;
  DispersionIndex: ANE_INT16;
  ErrorValue: double;
begin
  ErrorValue := 1.7e308;
  InvalidParameterNames := TStringList.Create;
  try

    LayersAbove := frmMODFLOW.MODFLOWLayersAboveCount(UnitIndex);
    LayerName := ModflowTypes.GetMFHFBLayerType.WriteNewRoot
      + IntToStr(UnitIndex);
    AddVertexLayer(CurrentModelHandle,LayerName);
    LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
    HFBLayer := TLayerOptions.Create(LayerHandle);
    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try
      GetParamIndicies(IsParamIndex, ParamNameIndex,
        ConductivityIndex, ThicknessIndex, AdjustForAngleIndex, IsParamName,
        ParamName, ConductivityName,
        ThicknessName, AdjustForAngleName, CurrentModelHandle, HFBLayer);

      if frmMODFLOW.cbMOC3D.Checked then
      begin
        GetGWT_ParamIndicies(LongDispIndex, HorzTransDispIndex,
        VertTransDispIndex, DispersionIndex, CurrentModelHandle, HFBLayer);
      end;

      ContourCount := HFBLayer.NumObjects(CurrentModelHandle,pieContourObject);
      frmProgress.pbActivity.Max := ContourCount;
      for ContourIndex := 0 to ContourCount -1 do
      begin
        if not ContinueExport then break;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        Contour := TContourObjectOptions.Create
          (CurrentModelHandle,LayerHandle,ContourIndex);
        try
          ContourType := Contour.ContourType(CurrentModelHandle);
          if (ContourType = ctOpen) or (ContourType = ctClosed) then
          begin
            if frmModflow.cbMOC3D.Checked then
            begin
              ABarrier.LongDisp := Contour.GetFloatParameter(CurrentModelHandle,LongDispIndex);
              ABarrier.TransDispHorz := Contour.GetFloatParameter(CurrentModelHandle,HorzTransDispIndex);
              ABarrier.TransDispVert := Contour.GetFloatParameter(CurrentModelHandle,VertTransDispIndex);
              ABarrier.DiffusionCoefficient := Contour.GetFloatParameter(CurrentModelHandle,DispersionIndex);
            end;

            IsParam := Contour.GetBoolParameter(CurrentModelHandle,IsParamIndex);
            if IsParam then
            begin
              ParameterName := Contour.GetStringParameter(CurrentModelHandle,ParamNameIndex);
            end; // if IsParam then

            ContourConductance := Contour.GetFloatParameter(CurrentModelHandle,ConductivityIndex);
            BarrierThickness := Contour.GetFloatParameter(CurrentModelHandle,ThicknessIndex);
            AdjustForAngle := Contour.GetIntegerParameter(CurrentModelHandle,AdjustForAngleIndex) <> 0;

            for CellIndex := 0 to GGetCountOfACrossColumnList(ContourIndex) -1 do
            begin
              ABarrier.IROW1 := GGetCrossColumnRow(ContourIndex,CellIndex);
              ABarrier.IROW2 := GGetCrossColumnNeighborRow(ContourIndex,CellIndex);
              ABarrier.ICOL1 := GGetCrossColumnColumn(ContourIndex,CellIndex);
              ABarrier.ICOL2 := ABarrier.ICOL1;

              if (ABarrier.IROW1 > 0) and (ABarrier.IROW1 <= Discretization.NROW)
                and (ABarrier.IROW2 > 0) and (ABarrier.IROW2 <= Discretization.NROW)
                and (ABarrier.ICOL1 > 0) and (ABarrier.ICOL1 <= Discretization.NCOL) then
              begin
                if AdjustForAngle then
                begin
                  if GGetCrossColumnCompositeLength(ContourIndex,CellIndex) <> 0 then
                  begin
                    ABarrier.Hydchr := ContourConductance/BarrierThickness
                      * Abs(GGetCrossColumnCompositeX(ContourIndex,CellIndex)
                      / GGetCrossColumnCompositeLength(ContourIndex,CellIndex));
                  end
                  else
                  begin
                    ABarrier.Hydchr := ErrorValue;
                  end;
                end
                else
                begin
                  ABarrier.Hydchr := ContourConductance/BarrierThickness;
                end;


                if ABarrier.Hydchr <> ErrorValue then
                begin

                  for LayerIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
                  begin
                    ABarrier.Layer := LayersAbove + LayerIndex;
                    if IsParam then
                    begin
                      AddParameterNameCell(ParameterName,ABarrier, InvalidParameterNames);
                    end
                    else
                    begin
                      BarrierList.Add(ABarrier);
                    end;
                  end;
                end;
              end;
            end;

            for CellIndex := 0 to GGetCountOfACrossRowList(ContourIndex) -1 do
            begin
              ABarrier.IROW1 := GGetCrossRowRow(ContourIndex,CellIndex);
              ABarrier.IROW2 := ABarrier.IROW1;
              ABarrier.ICOL1 := GGetCrossRowColumn(ContourIndex,CellIndex);
              ABarrier.ICOL2 := GGetCrossRowNeighborColumn(ContourIndex,CellIndex);

              if (ABarrier.IROW1 > 0) and (ABarrier.IROW1 <= Discretization.NROW)
                and (ABarrier.ICOL1 > 0) and (ABarrier.ICOL1 <= Discretization.NCOL)
                and (ABarrier.ICOL2 > 0) and (ABarrier.ICOL2 <= Discretization.NCOL)
                then
              begin

                if AdjustForAngle then
                begin
                  if GGetCrossRowCompositeLength(ContourIndex,CellIndex) <> 0 then
                  begin
                    ABarrier.Hydchr := ContourConductance/BarrierThickness
                      * Abs(GGetCrossRowCompositeY(ContourIndex,CellIndex)
                      / GGetCrossRowCompositeLength(ContourIndex,CellIndex));
                  end
                  else
                  begin
                    ABarrier.Hydchr := ErrorValue;
                  end;
                end
                else
                begin
                  ABarrier.Hydchr := ContourConductance/BarrierThickness;
                end;


                if ABarrier.Hydchr <> ErrorValue then
                begin


                  for LayerIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
                  begin
                    ABarrier.Layer := LayersAbove + LayerIndex;
                    if IsParam then
                    begin
                      AddParameterNameCell(ParameterName,ABarrier,
                        InvalidParameterNames);
                    end
                    else
                    begin
                      BarrierList.Add(ABarrier);
                    end;
                  end;
                end;

              end;
            end;

          end; // if Contour.ContourType(CurrentModelHandle) = ctOpen then
        finally
          Contour.Free;
        end;

      end; // for ContourIndex := 0 to ContourCount -1 do
    finally
      HFBLayer.Free(CurrentModelHandle);
      GridLayer.Free(CurrentModelHandle);
    end;

  finally
    if InvalidParameterNames.Count > 0 then
    begin
      ErrorString := 'Horizontal Flow Barrier Contours with invalid '
        + 'MODFLOW-2000 parameter names occur in Unit ' + IntToStr(UnitIndex);
      ErrorMessages.Add('');

      ErrorMessages.Add(ErrorString);
      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorString := 'These contours will be skipped.';
      ErrorMessages.Add(ErrorString);
      frmProgress.reErrors.Lines.Add(ErrorString);

      ErrorString := 'The following is a list of the invalid parameter names.';
      ErrorMessages.Add(ErrorString);

      ErrorMessages.AddStrings(InvalidParameterNames);
    end;

    InvalidParameterNames.Free;
  end;
end;

procedure THFBPkgWriter.EvaluateBarriers(
  const CurrentModelHandle: ANE_PTR; Discretization : TDiscretizationWriter);
var
  UnitIndex : integer;
  ProjectOptions : TProjectOptions;
begin
  ProjectOptions := TProjectOptions.Create;
  try

    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;

      if frmMODFLOW.Simulated(UnitIndex) then
      begin
        if ContinueExport then
        begin
          // barriers
          frmProgress.lblActivity.Caption := 'Evaluating Horizontal Flow '
            + 'Barriers in Unit ' + IntToStr(UnitIndex);
          EvaluateBarrierLayer(CurrentModelHandle, UnitIndex, ProjectOptions,
            Discretization);
          Application.ProcessMessages;
        end;

      end;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;
  finally
    ProjectOptions.Free;
  end;


end;

procedure THFBPkgWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization : TDiscretizationWriter);
var
  FileName : string;
begin
    if ContinueExport then
    begin
      AddParameterNames;
    end;
    frmProgress.pbPackage.Max := 4 + Discretization.NUNITS ;
    frmProgress.pbPackage.Position := 0;
    if ContinueExport then
    begin
      frmProgress.lblPackage.Caption := 'Horizontal Flow Barrier';
      Application.ProcessMessages;

      EvaluateBarriers(CurrentModelHandle, Discretization);
    end;

    if ContinueExport then
    begin
      FileName := GetCurrentDir + '\' + Root + rsHFB;
      AssignFile(FFile,FileName);
      try
        if ContinueExport then
        begin
          Rewrite(FFile);
//          WriteDataReadFrom(FileName);
          frmProgress.lblActivity.Caption := 'Writing Data Set 1';
          WriteDataSet1;
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;

        if ContinueExport then
        begin
          frmProgress.lblActivity.Caption := 'Writing Data Sets 2 and 3';
          WriteDataSets2And3;
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;
        if ContinueExport then
        begin
          frmProgress.lblActivity.Caption := 'Writing Data Set 4';
          WriteDataset4;
          frmProgress.pbPackage.StepIt;
          Application.ProcessMessages;
        end;
        if ContinueExport then
        begin
          frmProgress.lblActivity.Caption := 'Writing Data Sets 5 and 6';
          WriteDatasets5and6;
          frmProgress.pbPackage.StepIt;
          Flush(FFile);
          Application.ProcessMessages;
        end;
      finally
        CloseFile(FFile);
      end;

      Application.ProcessMessages;
    end;


end;

procedure THFBPkgWriter.AddParameterNames;
var
  RowIndex : integer;
begin
  for RowIndex := 1 to frmMODFLOW.dgHFBParameters.RowCount -1 do
  begin
    AddParameterName(RowIndex);
  end;

end;

procedure THFBPkgWriter.AddParameterName(RowIndex : integer);
var
  ParamIndex : integer;
  AParamValue : TBarrierParamValue;
  ParameterName: string;
  ErrorMessage : string;
begin
  ParameterName := UpperCase(frmMODFLOW.dgHFBParameters.Cells[0,RowIndex]);
  ParamIndex := ParameterNames.IndexOf(ParameterName);
  if ParamIndex < 0 then
  begin
    AParamValue := TBarrierParamValue.Create(RowIndex);
    ParameterNames.AddObject(ParameterName,AParamValue);
  end
  else
  begin
    ErrorMessage := 'Error: Two different Horizontal-flow-barrier parameters with the same name: ' + ParameterName
      + ' in the Horizontal-flow-barrier package.  Only one of these parameters will be used.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
//    raise EInvalidParameterName.Create
//      ('Error: Two different Horizontal-flow-barrier parameters with the same name: '
//      + '"ParameterName".');
  end;
end;

procedure THFBPkgWriter.WriteDataSet1;
var
  ParamIndex : integer;
  AParam : TBarrierParamValue;
  Option : string;
begin
  MXFB := 0;
  NHFBNP := BarrierList.Count;
  NPHFB := ParameterNames.Count;
  if ParameterNames.Count > 0 then
  begin
    for ParamIndex := 0 to ParameterNames.Count -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      AParam := ParameterNames.Objects[ParamIndex] as TBarrierParamValue;
      MXFB := MXFB + AParam.BarrierList.Count;
    end;
  end;
  Option := '';
  if not frmModflow.cbPrintCellLists.Checked then
  begin
    Option := Option + ' NOPRINT';
  end;
  Writeln(FFile, NPHFB, ' ', MXFB, ' ', NHFBNP, Option);

end;


procedure THFBPkgWriter.WriteDataSets2And3;
const
  PARTYP = '''HFB'' ';
var
  ParamIndex, BarrierIndex : integer;
  AParam : TBarrierParamValue;
  PARNAM : string;
  Parval : double;
  NLST : integer;
  ABarrier : TBarrier;
begin
  if NPHFB > 0 then
  begin
    for ParamIndex := 0 to ParameterNames.Count -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      PARNAM := ParameterNames[ParamIndex];
      AParam := ParameterNames.Objects[ParamIndex] as TBarrierParamValue;
      Parval := AParam.Value;
      NLST := AParam.BarrierList.Count;
      WriteLn(FFile, '''', PARNAM, ''' ', PARTYP, ' ', FreeFormattedReal(Parval), NLST);
      for BarrierIndex := 0 to AParam.BarrierList.Count -1 do
      begin
        if not ContinueExport then break;
        Application.ProcessMessages;
        ABarrier := AParam.BarrierList[BarrierIndex];
        ABarrier.WriteBarrier(self);
      end;
    end;
  end;
end;

procedure THFBPkgWriter.WriteDatasets5and6;
var
  NameIndex : integer;
  NACTHFB : integer;
begin
  NACTHFB := NPHFB;
  Writeln(FFile, NACTHFB);

  if NACTHFB > 0 then
  begin
    for NameIndex := 0 to ParameterNames.Count -1 do
    begin
      Writeln(FFile, ParameterNames[NameIndex]);
    end;
  end;
end;


procedure THFBPkgWriter.WriteDataSet4;
var
  ABarrier : TBarrier;
  BarrierIndex : integer;
begin
  if NHFBNP > 0 then
  begin
    for BarrierIndex := 0 to BarrierList.Count -1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      ABarrier := BarrierList[BarrierIndex];
      ABarrier.WriteBarrier(self);
    end;
  end;
end;

procedure THFBPkgWriter.GetGWT_ParamIndicies(out LongDispIndex,
  HorzTransDispIndex, VertTransDispIndex, DispersionIndex: ANE_INT16;
  const CurrentModelHandle: ANE_PTR; const HFBLayer: TLayerOptions);
var
  ParamName : string;
begin
  ParamName := ModflowTypes.GetMFHFBLongDispParamType.WriteParamName;
  LongDispIndex := HFBLayer.GetParameterIndex(CurrentModelHandle, ParamName);

  ParamName := ModflowTypes.GetMFHFBHorzTransDispParamType.WriteParamName;
  HorzTransDispIndex := HFBLayer.GetParameterIndex(CurrentModelHandle, ParamName);

  ParamName := ModflowTypes.GetMFHFBVertTransDispParamType.WriteParamName;
  VertTransDispIndex := HFBLayer.GetParameterIndex(CurrentModelHandle, ParamName);

  ParamName := ModflowTypes.GetMFHFBDiffusionCoefParamType.WriteParamName;
  DispersionIndex := HFBLayer.GetParameterIndex(CurrentModelHandle, ParamName);

end;

procedure THFBPkgWriter.WriteCHFB_File(const CurrentModelHandle: ANE_PTR;
  Root: string);
var
  FileName : string;
  ParamIndex, BarrierIndex : integer;
  AParam : TBarrierParamValue;
  ABarrier : TBarrier;
  IRANGE1, IRANGE2 : integer;
  BarrierRecord : THFBRecord;
  procedure TestAndWriteBarrier;
  begin
    if (IRANGE2 = 0) then
    begin
      BarrierRecord := ABarrier.Barrier;
      IRANGE2 := 1;
    end
    else
    begin
      if (BarrierRecord.LongDisp <> ABarrier.Barrier.LongDisp)
        or (BarrierRecord.TransDispHorz <> ABarrier.Barrier.TransDispHorz)
        or (BarrierRecord.TransDispVert <> ABarrier.Barrier.TransDispVert)
        or (BarrierRecord.DiffusionCoefficient <> ABarrier.Barrier.DiffusionCoefficient)
        then
      begin
        WriteLn(FFile, IRANGE1, ' ', IRANGE2, ' ',
          FreeFormattedReal(BarrierRecord.LongDisp),
          FreeFormattedReal(BarrierRecord.TransDispHorz),
          FreeFormattedReal(BarrierRecord.TransDispVert),
          FreeFormattedReal(BarrierRecord.DiffusionCoefficient));
        IRANGE1 := IRANGE2 + 1;
        BarrierRecord := ABarrier.Barrier;
      end;

      Inc(IRANGE2);
    end;
  end;
begin

  FileName := GetCurrentDir + '\' + Root + rsCHFB;
  AssignFile(FFile,FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);


      IRANGE1 := 1;
      IRANGE2 := 0;
      if NPHFB > 0 then
      begin
        for ParamIndex := 0 to ParameterNames.Count -1 do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          AParam := ParameterNames.Objects[ParamIndex] as TBarrierParamValue;
          for BarrierIndex := 0 to AParam.BarrierList.Count -1 do
          begin
            if not ContinueExport then break;
            Application.ProcessMessages;
            ABarrier := AParam.BarrierList[BarrierIndex];
            TestAndWriteBarrier;
          end;
        end;
      end;


      if NHFBNP > 0 then
      begin
        for BarrierIndex := 0 to BarrierList.Count -1 do
        begin
          if not ContinueExport then break;
          Application.ProcessMessages;
          ABarrier := BarrierList[BarrierIndex];
          TestAndWriteBarrier;
        end;
      end;

      if IRANGE1 <= IRANGE2 then
      begin
        WriteLn(FFile, IRANGE1, ' ', IRANGE2, ' ',
          FreeFormattedReal(BarrierRecord.LongDisp),
          FreeFormattedReal(BarrierRecord.TransDispHorz),
          FreeFormattedReal(BarrierRecord.TransDispVert),
          FreeFormattedReal(BarrierRecord.DiffusionCoefficient));
      end;
    end;
  finally
    CloseFile(FFile);
  end;
end;

constructor THFBPkgWriter.Create;
begin
  inherited;
  ParameterNames := TStringList.Create;
  BarrierList := TBarrierList.Create;
end;

destructor THFBPkgWriter.Destroy;
var
  Index : integer;
  AParamValue : TBarrierParamValue;
begin
  for Index := ParameterNames.Count -1 downto 0 do
  begin
    AParamValue := ParameterNames.Objects[Index] as TBarrierParamValue;
    AParamValue.Free;
  end;
  ParameterNames.Free;

  BarrierList.Free;
  inherited;

end;

{ TBarrierParamValue }

constructor TBarrierParamValue.Create(RowIndex : Integer);
begin
  BarrierList := TBarrierList.Create;
  Value := InternationalStrToFloat(frmModflow.dgHFBParameters.Cells[2,RowIndex]);
end;

destructor TBarrierParamValue.Destroy;
begin
  BarrierList.Free;
  inherited;
end;

{ TBarrierList }

function TBarrierList.Add(ABarrier : THFBRecord): integer;
var
  BarrierObject : TBarrier;
begin
  BarrierObject := TBarrier.Create;
  result := Add(BarrierObject);
  BarrierObject.Barrier := ABarrier;
end;

procedure TBarrierList.Clear;
var
  Index : integer;
begin
  for Index := Count-1 downto 0 do
  begin
    TBarrier(Items[Index]).Free;
  end;

  inherited;

end;

{ TBarrier }

procedure TBarrier.WriteBarrier(HFBPkgWriter : THFBPkgWriter);
begin
  Writeln(HFBPkgWriter.FFile, Barrier.Layer, ' ', Barrier.IROW1, ' ',
    Barrier.ICOL1, ' ', Barrier.IROW2, ' ',  Barrier.ICOL2, ' ',
    HFBPkgWriter.FreeFormattedReal(Barrier.Hydchr));
end;

end.
