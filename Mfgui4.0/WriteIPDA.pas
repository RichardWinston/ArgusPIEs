unit WriteIPDA;

interface

uses SysUtils, AnePIE, WriteModflowDiscretization;

type
  TSetIntArrayMember = procedure(Col, Row, UnitIndex : integer;
    Value : integer) of object;

  T3DIntArray = array of array of array of integer;


  TIpdaWriter = class(TModflowWriter)
  private
    ISROW1, ISROW2, ISCOL1, ISCOL2 : integer;
    FirstMoc3dUnit, LastMoc3dUnit : integer;
    ModelHandle: ANE_PTR;
    Discretization: TDiscretizationWriter;
    BasicWriter : TBasicPkgWriter;
    NPTLAYA: T3DIntArray;
    NPTROWA: T3DIntArray;
    NPTCOLA: T3DIntArray;
    procedure InitializeArrays;
    procedure SetUnitIntegerArray(const ParameterRoot : String;
      AnArray : T3DIntArray);
    procedure SetNPTLAYA;
    procedure SetNPTROWA;
    procedure SetNPTCOLA;
    procedure Evaluate;
    procedure WriteUnit(const UnitIndex: integer);
    procedure WriteDataSets2to4;

    procedure WriteDataSet1;
    procedure WriteDataSet2(const UnitIndex: integer);
    procedure WriteDataSet3(const UnitIndex: integer);
    procedure WriteDataSet4(const UnitIndex: integer);
    procedure InitializeUnitCounts;
  public
    procedure WriteFile(const CurrentModelHandle: ANE_PTR;
      const DisWriter: TDiscretizationWriter; const BasicPkg : TBasicPkgWriter;
      const Root: string);
  end;


implementation

uses Forms, UtilityFunctions, OptionsUnit, Variables, ProgressUnit,
  MOC3DGridFunctions, WriteNameFileUnit;

{ TIpdaWriter }

procedure TIpdaWriter.Evaluate;
begin
  if ContinueExport then
  begin
    SetNPTLAYA;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;
  if ContinueExport then
  begin
    SetNPTROWA;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;
  if ContinueExport then
  begin
    SetNPTCOLA;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;
end;

procedure TIpdaWriter.InitializeUnitCounts;
begin
  FirstMoc3dUnit := StrToInt(frmMODFLOW.adeMOC3DLay1.Text);
  LastMoc3dUnit := StrToInt(frmMODFLOW.adeMOC3DLay2.Text);
  if LastMoc3dUnit = -1 then
  begin
    LastMoc3dUnit := StrToInt(frmMODFLOW.edNumUnits.Text);
  end;
end;

procedure TIpdaWriter.InitializeArrays;
var
  UnitCount, RowCount, ColCount: integer;
  layerHandle : ANE_PTR;
  Layername : string;
begin
  Layername := ModflowTypes.GetGridLayerType.ANE_LayerName;
  layerHandle := GetLayerHandle(ModelHandle,Layername);
  ISROW1 := fMOCROW1(ModelHandle,layerHandle, Discretization.NROW);
  ISROW2 := fMOCROW2(ModelHandle,layerHandle, Discretization.NROW);
  ISCOL1 := fMOCCOL1(ModelHandle,layerHandle, Discretization.NCOL);
  ISCOL2 := fMOCCOL2(ModelHandle,layerHandle, Discretization.NCOL);
  
  UnitCount := LastMoc3dUnit-FirstMoc3dUnit+1;
  RowCount := ISROW2-ISROW1+1;
  ColCount := ISCOL2-ISCOL1+1;

  SetLength(NPTLAYA, UnitCount, RowCount, ColCount);
  SetLength(NPTROWA, UnitCount, RowCount, ColCount);
  SetLength(NPTCOLA, UnitCount, RowCount, ColCount);
end;

procedure TIpdaWriter.SetNPTCOLA;
begin
  SetUnitIntegerArray(ModflowTypes.
    GetMFGridMOCParticleColumnCountParamType.ANE_ParamName, NPTCOLA)
end;

procedure TIpdaWriter.SetNPTLAYA;
begin
  SetUnitIntegerArray(ModflowTypes.
    GetMFGridMOCParticleLayerCountParamType.ANE_ParamName, NPTLAYA)
end;

procedure TIpdaWriter.SetNPTROWA;
begin
  SetUnitIntegerArray(ModflowTypes.
    GetMFGridMOCParticleRowCountParamType.ANE_ParamName, NPTROWA)
end;

procedure TIpdaWriter.SetUnitIntegerArray(const ParameterRoot: String;
  AnArray : T3DIntArray);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
  ColI, RowI, LayI: integer;
begin
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := (LastMoc3dUnit - FirstMoc3dUnit + 1)
    * (ISROW2 - ISROW1 + 1) * (ISCOL2 - ISCOL1 + 1);

  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      if frmMODFLOW.Simulated(UnitIndex) then
      begin
        ParameterName := ParameterRoot + IntToStr(UnitIndex);
        ParameterIndex := GridLayer.GetParameterIndex(
          ModelHandle,ParameterName);

        LayI := UnitIndex-FirstMoc3dUnit;
        for RowIndex := ISROW1-1 to ISROW2-1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;

          RowI := RowIndex-ISROW1+1;
          for ColIndex := ISCOL1-1 to ISCOL2-1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

            ColI := ColIndex-ISCOL1+1;
            if BasicWriter.IBOUND[ColIndex,RowIndex,UnitIndex-1] = 0 then
            begin
              AnArray[LayI, RowI, ColI] := 0;
            end
            else
            begin
              BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
              ABlock := TBlockObjectOptions.Create(ModelHandle,
                Discretization.GridLayerHandle, BlockIndex);
              try
                AnArray[LayI, RowI, ColI] :=
                  ABlock.GetIntegerParameter(ModelHandle, ParameterIndex);
              finally
                ABlock.Free;
              end;
            end;

            frmProgress.pbActivity.StepIt;
          end;
        end;
      end;
    end;

  finally
    GridLayer.Free(ModelHandle);
  end;
end;

procedure TIpdaWriter.WriteDataSet1;
VAR
  NPMAX: integer;
begin
  NPMAX := StrToInt(frmModflow.adeMOC3DMaxParticles.Text);
  writeln(FFile, NPMAX);
end;

procedure TIpdaWriter.WriteDataSet2(const UnitIndex: integer);
var
  UnitI: integer;
  Col, Row: integer;
begin
  WriteU2DINTHeader('NPTLAYA; Unit ' + IntToStr(UnitIndex));
  UnitI := UnitIndex - FirstMoc3dUnit;
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := (ISROW2-ISROW1+1)*(ISCOL2-ISCOL1+1);
  for Row := 0 to ISROW2-ISROW1 do
  begin
    if ContinueExport then
    begin
      for Col := 0 to ISCOL2-ISCOL1 do
      begin
        if ContinueExport then
        begin
          Write(FFile, NPTLAYA[UnitI,Row,Col], ' ');
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages
        end;
      end;
      writeLn(FFile);
    end;
  end;
end;

procedure TIpdaWriter.WriteDataSet3(const UnitIndex: integer);
var
  UnitI: integer;
  Col, Row: integer;
begin
  WriteU2DINTHeader('NPTROWA; Unit ' + IntToStr(UnitIndex));
  UnitI := UnitIndex - FirstMoc3dUnit;
  for Row := 0 to ISROW2-ISROW1 do
  begin
    if ContinueExport then
    begin
      for Col := 0 to ISCOL2-ISCOL1 do
      begin
        if ContinueExport then
        begin
          Write(FFile, NPTROWA[UnitI,Row,Col], ' ');
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages
        end;
      end;
      writeLn(FFile);
    end;
  end;
end;

procedure TIpdaWriter.WriteDataSet4(const UnitIndex: integer);
var
  UnitI: integer;
  Col, Row: integer;
begin
  WriteU2DINTHeader('NPTCOLA; Unit ' + IntToStr(UnitIndex));
  UnitI := UnitIndex - FirstMoc3dUnit;
  for Row := 0 to ISROW2-ISROW1 do
  begin
    if ContinueExport then
    begin
      for Col := 0 to ISCOL2-ISCOL1 do
      begin
        if ContinueExport then
        begin
          Write(FFile, NPTCOLA[UnitI,Row,Col], ' ');
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages
        end;
      end;
      writeLn(FFile);
    end;
  end;
end;

procedure TIpdaWriter.WriteDataSets2to4;
var
  UnitIndex: integer;
  DisIndex: integer;
begin
  for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
  begin
    for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
    begin
      WriteUnit(UnitIndex);
    end;
  end;
end;

procedure TIpdaWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  const DisWriter: TDiscretizationWriter; const BasicPkg: TBasicPkgWriter;
  const Root: string);
var
  FileName: string;
  UnitIndex: integer;
  LayerCount: integer;
begin
  ModelHandle := CurrentModelHandle;
  Discretization := DisWriter;
  BasicWriter := BasicPkg;
  FileName := GetCurrentDir + '\' + Root + rsIPDA;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);
    WriteDataReadFrom(FileName);

    InitializeUnitCounts;
    LayerCount := 0;
    for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
    begin
      LayerCount := LayerCount + frmModflow.DiscretizationCount(UnitIndex);
    end;

    frmProgress.pbPackage.Position := 0;
    frmProgress.pbPackage.Max := 4 + (LayerCount*3);

    if ContinueExport then
    begin
      InitializeArrays;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      Evaluate;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      WriteDataSet1;
      WriteDataSets2to4;
      Application.ProcessMessages;
    end;
  finally
    CloseFile(FFile);
  end;
end;

procedure TIpdaWriter.WriteUnit(const UnitIndex: integer);
begin
  if ContinueExport then
  begin
    WriteDataSet2(UnitIndex);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    WriteDataSet3(UnitIndex);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    WriteDataSet4(UnitIndex);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;
end;

end.
