unit WriteCBDY;

interface

uses Sysutils, Forms, AnePIE, WriteModflowDiscretization;

type
  TGWT_CBDY_Writer = class(TModflowWriter)
  private
    ISROW1, ISROW2, ISCOL1, ISCOL2 : integer;
    ModelHandle: ANE_PTR;
    Discretization: TDiscretizationWriter;
    procedure InitializeLimits;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteArray(const ParamName: string);
  public
    procedure WriteFile(const CurrentModelHandle: ANE_PTR;
      const DisWriter: TDiscretizationWriter; const Root: string);
  end;

implementation

uses Variables, UtilityFunctions, OptionsUnit, MOC3DGridFunctions, ModflowUnit,
  ProgressUnit, WriteNameFileUnit;

{ TGWT_CBDY_Writer }

procedure TGWT_CBDY_Writer.InitializeLimits;
var
  layerHandle : ANE_PTR;
  Layername : string;
begin
  if ModflowTypes.GetMOCUpperBoundaryConcentrationLayerType.Used or
    ModflowTypes.GetMOCLowerBoundaryConcentrationLayerType.Used or
    ModflowTypes.GetMOCLateralBoundaryConcentrationLayerType.Used then
  begin
    Layername := ModflowTypes.GetGridLayerType.ANE_LayerName;
    layerHandle := GetLayerHandle(ModelHandle,Layername);
    ISROW1 := fMOCROW1(ModelHandle,layerHandle, Discretization.NROW);
    ISROW2 := fMOCROW2(ModelHandle,layerHandle, Discretization.NROW);
    ISCOL1 := fMOCCOL1(ModelHandle,layerHandle, Discretization.NCOL);
    ISCOL2 := fMOCCOL2(ModelHandle,layerHandle, Discretization.NCOL);
  end;
end;

procedure TGWT_CBDY_Writer.WriteDataSet2;
var
  FirstUnit: integer;
  LastUnit: integer;
  UnitIndex: integer;
//  Value : double;
  DivIndex: integer;
  LateralValues : array of array of ANE_DOUBLE;
  RowIndex, ColIndex: integer;
  BlockIndex:  ANE_INT32;
  Block: TBlockObjectOptions;
  GridLayer : TLayerOptions;
  ParamName: string;
  ParameterIndex: ANE_INT32;
begin
  with frmModflow do
  begin
    FirstUnit := StrToInt(adeMOC3DLay1.Text);
    LastUnit := StrToInt(adeMOC3DLay2.Text);
    if LastUnit < 1 then
    begin
      LastUnit := UnitCount;
    end;

    SetLength(LateralValues, Discretization.NROW, Discretization.NCOL);

    GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
    try

      for UnitIndex := FirstUnit to LastUnit do
      begin
        if frmMODFLOW.Simulated(UnitIndex) then
        begin
         ParamName := ModflowTypes.GetMFGridGwtLateralBoundConcParamType.
           ANE_ParamName + IntToStr(UnitIndex);
         ParameterIndex := GridLayer.GetParameterIndex(ModelHandle,ParamName);

          for RowIndex := 0 to Discretization.NROW -1 do
          begin
            for ColIndex := 0 to Discretization.NCOL -1 do
            begin
              if ((RowIndex + 1) = ISROW1) or ((RowIndex + 1) = ISROW2)
                or ((ColIndex + 1) = ISCOL1)or ((ColIndex + 1) = ISCOL2) then
              begin
                BlockIndex := Discretization.BlockIndex(RowIndex,ColIndex);
                Block := TBlockObjectOptions.Create(ModelHandle,
                  Discretization.GridLayerHandle, BlockIndex);
                LateralValues[RowIndex,ColIndex] := Block.
                  GetFloatParameter(ModelHandle,ParameterIndex);
              end
              else
              begin
                LateralValues[RowIndex,ColIndex] := 0;
              end;
            end;
          end;

          for DivIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
          begin
            WriteU2DRELHeader;
            for RowIndex := ISROW1-1 to ISROW2-1 do
            begin
              for ColIndex := ISCOL1-1  to ISCOL2-1 do
              begin
                Write(FFile, FreeFormattedReal(LateralValues[RowIndex,ColIndex]));
              end;
              WriteLn(FFile);
            end;
          end;

          {Value := InternationalStrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells
            [Ord(trdConc),UnitIndex]);
          for DivIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
          begin
            WriteLn(FFile, FreeFormattedReal(Value));
          end; }
        end;
      end;
    finally
      GridLayer.Free(ModelHandle);
    end;
  end;
end;

procedure TGWT_CBDY_Writer.WriteDataSet1;
begin
  if ModflowTypes.GetMOCUpperBoundaryConcentrationLayerType.Used then
  begin
    WriteArray(ModflowTypes.GetMFGridGwtUppBoundConcParamType.
        ANE_ParamName);
  end;
end;

procedure TGWT_CBDY_Writer.WriteArray(const ParamName: string);
var
  GridLayerHandle : ANE_PTR;
  ParameterIndex : ANE_INT16;
  BlockIndex : ANE_INT32;
  Block : TBlockObjectOptions;
  ColIndex, RowIndex : integer;
  GridLayer: TLayerOptions;
  Value: double;
begin
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := (ISROW2 - ISROW1 + 1) * (ISCOL2 - ISCOL1 + 1);
  GridLayerHandle := Discretization.GridLayerHandle;
  GridLayer := TLayerOptions.Create(GridLayerHandle);
  try
    ParameterIndex := GridLayer.GetParameterIndex(ModelHandle,ParamName);
    WriteU2DRELHeader;
    for RowIndex := ISROW1 to ISROW2 do
    begin
      for ColIndex := ISCOL1 to ISCOL2 do
      begin
        BlockIndex := Discretization.BlockIndex(RowIndex-1,ColIndex-1);
        Block := TBlockObjectOptions.Create(ModelHandle,GridLayerHandle,
          BlockIndex);
        try
          Value := Block.
            GetFloatParameter(ModelHandle,ParameterIndex);
          Write(FFile, Value, ' ');
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;
          if not ContinueExport then Exit;
        finally
          Block.Free;
        end;
      end;
      WriteLn(FFile);
    end;
  finally
    GridLayer.Free(ModelHandle);
  end;
end;

procedure TGWT_CBDY_Writer.WriteDataSet3;
begin
  if ModflowTypes.GetMOCLowerBoundaryConcentrationLayerType.Used then
  begin
    WriteArray(ModflowTypes.GetMFGridGwtLowBoundConcParamType.
        ANE_ParamName);
  end;
end;

procedure TGWT_CBDY_Writer.WriteFile(const CurrentModelHandle: ANE_PTR;
  const DisWriter: TDiscretizationWriter; const Root: string);
var
  Count: integer;
  FileName : String;
begin
  ModelHandle := CurrentModelHandle;
  Discretization := DisWriter;

  Count := 1;
  if ModflowTypes.GetMOCUpperBoundaryConcentrationLayerType.Used then
  begin
    Inc(Count);
  end;
  if ModflowTypes.GetMOCLowerBoundaryConcentrationLayerType.Used then
  begin
    Inc(Count);
  end;

  frmProgress.lblActivity.Caption := 'CBDY file';
  frmProgress.pbPackage.Max := Count;

  FileName := GetCurrentDir + '\' + Root + rsCBDY;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);

    InitializeLimits;

    WriteDataSet1;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet2;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;

    WriteDataSet3;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  finally
    CloseFile(FFile);
  end;
end;

end.
