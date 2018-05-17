unit WriteBFLX_Unit;

interface

uses SysUtils, Forms, AnePIE, OptionsUnit, WriteModflowDiscretization;
                      
type
  EInvalidIndex = class(Exception);

  TBFLX_Writer = class(TListWriter)
  private
    CurrentModelHandle: ANE_PTR;
    NCOL, NROW, NLAY: integer;
    FIFACE: array of array of array of Integer;
    FUsed: array of array of array of boolean;
    XCenter: array of array of double;
    YCenter: array of array of double;
    ISROW1, ISROW2, ISCOL1, ISCOL2 : integer;
    NCHNDS: integer;
    procedure GetCellCenters(const Discretization: TDiscretizationWriter);
    procedure EvaluatePrescribedHeadLayer(const UnitIndex: integer;
      const ProjectOptions: TProjectOptions; const StartMFLayer: integer);
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    function GetIFACE(Layer, Row, Column: integer): integer;
    function GetUsed(Layer, Row, Column: integer): boolean;
    procedure SetIFACE(Layer, Row, Column: integer; const Value: integer);
    procedure ValidateCellIndicies(var Layer, Row, Column: integer);
    procedure EvaluatePrescribedHeads;
    Procedure SetArraySizes(LayerCount, RowCount, ColCount: integer);
    procedure EvaluteBasicIFACE(const Discretization: TDiscretizationWriter);
    procedure SetRowColumnLimits;
  public
    Constructor Create(const Discretization: TDiscretizationWriter;
      const ModelHandle: ANE_PTR);
    property Used[Layer, Row, Column: integer]: boolean read GetUsed;
    property IFACE[Layer, Row, Column: integer]: integer read GetIFACE
      write SetIFACE;
    procedure Evaluate(const Discretization: TDiscretizationWriter;
      const CHD_Writer, FHB_Writer: TListWriter);
    procedure WriteFile(Root: string;
      const Discretization : TDiscretizationWriter;
      const CHD_Writer, FHB_Writer: TListWriter);
  end;

implementation

uses Variables, ProgressUnit, PointInsideContourUnit, GetCellUnit, WriteCHDUnit,
  WriteFHBUnit, WriteNameFileUnit, UtilityFunctions, MOC3DGridFunctions;

{ TBFLX_Writer }

procedure TBFLX_Writer.EvaluatePrescribedHeads;
var
  UnitIndex: integer;
  ProjectOptions: TProjectOptions;
  StartMFLayer: integer;
  FirstMoc3dUnit, LastMoc3dUnit : integer;
begin
  FirstMoc3dUnit := StrToInt(frmMODFLOW.adeMOC3DLay1.Text);
  LastMoc3dUnit := StrToInt(frmMODFLOW.adeMOC3DLay2.Text);
  if LastMoc3dUnit = -1 then
  begin
    LastMoc3dUnit := StrToInt(frmMODFLOW.edNumUnits.Text);
  end;

  ProjectOptions := TProjectOptions.Create;
  try
    StartMFLayer := 1;
    for UnitIndex := 1 to frmModflow.UnitCount do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        if (UnitIndex >= FirstMoc3dUnit) and (UnitIndex <= LastMoc3dUnit) then
        begin
          EvaluatePrescribedHeadLayer(UnitIndex,ProjectOptions,
            StartMFLayer);
        end;
        StartMFLayer := StartMFLayer + frmModflow.
          DiscretizationCount(UnitIndex);
      end;
    end;
  finally
    ProjectOptions.Free;
  end;
end;

procedure TBFLX_Writer.EvaluatePrescribedHeadLayer(
  const UnitIndex: integer; const ProjectOptions: TProjectOptions;
  const StartMFLayer: integer);
var
  LayerName: string;
  LayerHandle: ANE_PTR;
  PrescribedHeadLayer: TLayerOptions;
  ContourCount: integer;
  IFACE_Index: ANE_INT16;
  IFACE_Name: string;
  ContourIndex: integer;
  Contour: TContourObjectOptions;
  RowIndex, ColIndex: integer;
  X, Y: double;
  InContour: boolean;
  IFACE_Value: integer;
  LayerIndex: integer;
  EndMFLayer: integer;
  CellIndex: integer;
begin
  if not frmMODFLOW.Simulated(UnitIndex) then Exit;
  EndMFLayer := StartMFLayer + frmMODFLOW.DiscretizationCount(UnitIndex) -1;

  LayerName := ModflowTypes.GetPrescribedHeadLayerType.WriteNewRoot
    + IntToStr(UnitIndex);

  AddVertexLayer(CurrentModelHandle,LayerName);
  LayerHandle :=  ProjectOptions.GetLayerByName(CurrentModelHandle,LayerName);
  PrescribedHeadLayer := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := PrescribedHeadLayer.NumObjects(CurrentModelHandle,pieContourObject);
    if ContourCount > 0 then
    begin
      IFACE_Name := ModflowTypes.GetMFIFACEParamType.WriteParamName;
      IFACE_Index := PrescribedHeadLayer.GetParameterIndex(CurrentModelHandle,
        IFACE_Name);
      for ContourIndex := 0 to ContourCount -1 do
      begin
        if not ContinueExport then break;
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        Contour := TContourObjectOptions.Create
          (CurrentModelHandle,LayerHandle,ContourIndex);
        try
          IFACE_Value := Contour.GetIntegerParameter(CurrentModelHandle,
            IFACE_Index);
          if Contour.ContourType(CurrentModelHandle) = ctClosed then
          begin
            for RowIndex := ISROW1 to ISROW2 do
            begin
              for ColIndex := ISCOL1 to ISCOL2 do
              begin
                X := XCenter[RowIndex-1,ColIndex-1];
                Y := YCenter[RowIndex-1,ColIndex-1];
                InContour := GPointInsideContour(ContourIndex, X, Y);
                if InContour then
                begin
                  for LayerIndex := StartMFLayer to EndMFLayer do
                  begin
                    IFACE[LayerIndex,RowIndex,ColIndex] := IFACE_Value;
                  end;
                end;
              end;
            end;
          end; // if Contour.ContourType(CurrentModelHandle) = ctClosed then

          for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
          begin
            if not ContinueExport then break;
            Application.ProcessMessages;
            RowIndex := GGetCellRow(ContourIndex, CellIndex);
            if (RowIndex >= ISROW1) and (RowIndex <= ISROW2) then
            begin
              ColIndex := GGetCellColumn(ContourIndex, CellIndex);
              if (ColIndex >= ISCOL1) and (ColIndex <= ISCOL2) then
              begin
                for LayerIndex := StartMFLayer to EndMFLayer do
                begin
                  IFACE[LayerIndex,RowIndex,ColIndex] := IFACE_Value;
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
    PrescribedHeadLayer.Free(CurrentModelHandle);
  end;
end;

procedure TBFLX_Writer.GetCellCenters(const Discretization: TDiscretizationWriter);
var
  ColIndex, RowIndex: integer;
  BlockIndex: integer;
  X, Y: ANE_DOUBLE;
  ABlock: TBlockObjectOptions;
begin
  for ColIndex := 0 to NCOL-1 do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    for RowIndex := 0 to NROW-1 do
    begin
      if not ContinueExport then break;
      Application.ProcessMessages;
      BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
      ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
        Discretization.GridLayerHandle,BlockIndex);
      try
        ABlock.GetCenter(CurrentModelHandle,X,Y);
        XCenter[RowIndex, ColIndex] := X;
        YCenter[RowIndex, ColIndex] := Y;
      finally
        ABlock.Free;
      end;
    end;
  end;
end;

function TBFLX_Writer.GetIFACE(Layer, Row, Column: integer): integer;
begin
  ValidateCellIndicies(Layer, Row, Column);
  result := FIFACE[Layer, Row, Column];
end;

function TBFLX_Writer.GetUsed(Layer, Row, Column: integer): boolean;
begin
  ValidateCellIndicies(Layer, Row, Column);
  result := FUsed[Layer, Row, Column];
end;


procedure TBFLX_Writer.SetArraySizes(LayerCount, RowCount,
  ColCount: integer);
begin
  NLAY := LayerCount;
  NROW := RowCount;
  NCOL := ColCount;
  SetLength(FIFACE, NLAY, NROW, NCOL);
  SetLength(FUsed, NLAY, NROW, NCOL);
  SetLength(XCenter, NROW, NCOL);
  SetLength(YCenter, NROW, NCOL);
end;

procedure TBFLX_Writer.SetIFACE(Layer, Row, Column: integer;
  const Value: integer);
begin
  ValidateCellIndicies(Layer, Row, Column);
  FIFACE[Layer, Row, Column] := Value;
  if not FUsed[Layer, Row, Column] then
  begin
    FUsed[Layer, Row, Column] := True;
    Inc(NCHNDS);
  end;
end;

procedure TBFLX_Writer.ValidateCellIndicies(var Layer, Row,
  Column: integer);
begin
  if (Layer <= 0) or (Row <= 0) or (Column <= 0)
    or (Layer > NLAY) or (Row > NROW) or (Column > NCOL) then
  begin
    raise EInvalidIndex.Create('Invalid cell index.');
  end;
  Dec(Layer);
  Dec(Row);
  Dec(Column);
end;

procedure TBFLX_Writer.WriteDataSet1;
var
  IRCHTP: integer;
begin
  if frmMODFLOW.cbRCH.Checked and frmMODFLOW.cbRCHRetain.Checked then
  begin
    IRCHTP := frmMODFLOW.comboMODPATH_RechargeITOP.ItemIndex;
    WriteLn(FFile, IRCHTP);
  end;
end;

procedure TBFLX_Writer.WriteDataSet2;
var
  IEVTTP: integer;
begin
  if (frmMODFLOW.cbEVT.Checked and frmMODFLOW.cbEVTRetain.Checked)
    or (frmMODFLOW.cbETS.Checked and frmMODFLOW.cbETSRetain.Checked) then
  begin
    IEVTTP := frmMODFLOW.comboMODPATH_EvapITOP.ItemIndex;
    WriteLn(FFile, IEVTTP);
  end;
end;

procedure TBFLX_Writer.WriteDataSet3;
begin
    WriteLn(FFile, NCHNDS);
end;

procedure TBFLX_Writer.WriteDataSet4;
var
  Layer, Row, Col, IFACE_Value: integer;
begin
  If NCHNDS > 0 then
  begin
    for Layer := 1 to NLAY do
    begin
      for Row := 1 to NROW do
      begin
        for Col := 1 to NCOL do
        begin
          if Used[Layer, Row, Col] then
          begin
            IFACE_Value := IFACE[Layer, Row, Col];
            WriteLn(FFile, Layer, ' ', Row, ' ', Col, ' ', IFACE_Value);
          end;
        end;
      end;
    end;
  end;
end;

constructor TBFLX_Writer.Create(const Discretization: TDiscretizationWriter; const ModelHandle: ANE_PTR);
begin
  CurrentModelHandle := ModelHandle;
  Assert(Discretization <> nil);
  SetArraySizes(Discretization.NLAY, Discretization.NROW, Discretization.NCOL);
end;

procedure TBFLX_Writer.EvaluteBasicIFACE(
  const Discretization: TDiscretizationWriter);
begin
  GetCellCenters(Discretization);
  EvaluatePrescribedHeads;
end;

procedure TBFLX_Writer.Evaluate(
  const Discretization: TDiscretizationWriter; const CHD_Writer,
  FHB_Writer: TListWriter);
begin
  SetRowColumnLimits;
  NCHNDS := 0;
  Assert(Discretization <> nil);
  EvaluteBasicIFACE(Discretization);
  frmProgress.pbPackage.StepIt;
  Application.ProcessMessages;
  if CHD_Writer <> nil then
  begin
    (CHD_Writer as TCHDPkgWriter).RecordIFACE(self);
  end;
  frmProgress.pbPackage.StepIt;
  Application.ProcessMessages;
  if FHB_Writer <> nil then
  begin
    (FHB_Writer as TFHBPkgWriter).RecordIFACE(self);
  end;
  frmProgress.pbPackage.StepIt;
  Application.ProcessMessages;
end;

procedure TBFLX_Writer.WriteFile(Root: string;
  const Discretization: TDiscretizationWriter; const CHD_Writer,
  FHB_Writer: TListWriter);
var
  FileName: string;
begin
  frmProgress.lblPackage.Caption := 'BFLX package';
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := 4;
  Evaluate(Discretization, CHD_Writer, FHB_Writer);
  if ContinueExport then
  begin
    FileName := GetCurrentDir + '\' + Root + rsBFLX;
    AssignFile(FFile,FileName);
    try
      if ContinueExport then
      begin
        Rewrite(FFile);
        WriteDataSet1;
        WriteDataSet2;
        WriteDataSet3;
        WriteDataSet4;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
    finally
      CloseFile(FFile);
    end;
  end;

end;

procedure TBFLX_Writer.SetRowColumnLimits;
var
  layerHandle : ANE_PTR;
  NRow, NCol : ANE_INT32;
  ModelHandle : ANE_PTR;
  Layername : string;
begin
  ModelHandle := frmMODFLOW.CurrentModelHandle;

  Layername := ModflowTypes.GetGridLayerType.ANE_LayerName;
  layerHandle := GetLayerHandle(ModelHandle,Layername);

  GetNumRowsCols(ModelHandle, LayerHandle, NRow, NCol);

  ISROW1 := fMOCROW1(ModelHandle,layerHandle,NRow);
  ISROW2 := fMOCROW2(ModelHandle,layerHandle,NRow);
  ISCOL1 := fMOCCOL1(ModelHandle,layerHandle,NCol);
  ISCOL2 := fMOCCOL2(ModelHandle,layerHandle,NCol);
end;

end.
