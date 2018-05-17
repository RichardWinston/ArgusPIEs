unit WriteVariableDensityFlow;

interface

uses SysUtils, Forms, AnePIE, WriteModflowDiscretization;

type
  TVariableDensityWriter = class(TModflowWriter)
  private
    MT3DRHOFLG: integer;
    NSWTCPL: integer;
    INDENSE: integer;
    DisWriter: TDiscretizationWriter;
    BasicWriter: TBasicPkgWriter;
    CurrentModelHandle: ANE_PTR;
    X, Y: array of array of ANE_DOUBLE;
    DensityArray: array of array of double;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet4a_to_4c;
    procedure WriteDataSet5;
    procedure WriteDataSets6and7;
    procedure WriteDataSet6(const StressPeriod: integer);
    procedure WriteDataSet7(const StressPeriod: integer);
  public
    procedure WriteFile(const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter; BasicPkg : TBasicPkgWriter);
  end;

implementation

uses OptionsUnit, ProgressUnit, Variables, WriteNameFileUnit;

{ TVariableDensityWriter }

procedure TVariableDensityWriter.WriteDataSet1;
var
  MFNADVFD: integer;
  IWTABLE: integer;
begin
  if frmModflow.cbSW_Coupled.Checked then
  begin
    if frmModflow.comboDensityChoice.ItemIndex = 0 then
    begin
      MT3DRHOFLG := StrToInt(frmModflow.adeSW_ComponentChoice.Text);
    end
    else
    begin
      MT3DRHOFLG := -1;
    end;
  end
  else
  begin
    MT3DRHOFLG := 0;
  end;

  if frmModflow.comboSW_InternodalDensity.ItemIndex = 0 then
  begin
    MFNADVFD := 2;
  end
  else
  begin
    MFNADVFD := 1;
  end;

  NSWTCPL := StrToInt(frmModflow.adeSW_MaxIt.Text);

  if frmModflow.cbSW_WaterTableCorrections.Checked then
  begin
    IWTABLE := 1;
  end
  else
  begin
    IWTABLE := 0;
  end;

  WriteLn(FFile, MT3DRHOFLG, ' ', MFNADVFD, ' ', NSWTCPL, ' ', IWTABLE);
end;

procedure TVariableDensityWriter.WriteDataSet2;
var
  DENSEMIN, DENSEMAX: double;
begin
  DENSEMIN := StrToFloat(frmModflow.adeSW_MinDens.Text);
  DENSEMAX := StrToFloat(frmModflow.adeSW_MaxDens.Text);
  WriteLn(FFile, FreeFormattedReal(DENSEMIN), FreeFormattedReal(DENSEMAX));
end;

procedure TVariableDensityWriter.WriteDataSet3;
var
  DENSCRIT: double;
begin
  if (NSWTCPL = -1) or (NSWTCPL > 1) then
//  if MT3DRHOFLG >= 0 then
  begin
    DENSCRIT := StrToFloat(frmModflow.adeSW_DenConvCrit.Text);
    WriteLn(FFile, FreeFormattedReal(DENSCRIT));
  end;
end;

procedure TVariableDensityWriter.WriteDataSet4;
var
  DENSEREF, DENSESLP: double;
begin
  if MT3DRHOFLG >= 0 then
  begin
    DENSEREF := StrToFloat(frmModflow.adeRefFluidDens.Text);
    DENSESLP := StrToFloat(frmModflow.adeSW_DenseSlope.Text);
    WriteLn(FFile, FreeFormattedReal(DENSEREF), FreeFormattedReal(DENSESLP));
  end;
end;

type
  TEquationColumns =(ecN, ecSpeciesNumber, ecRefConc, ecSlope);

procedure TVariableDensityWriter.WriteDataSet4a_to_4c;
var
  DENSEREF: double;
  DRHODPRHD: double;
  PRHDREF: double;
  RowIndex: integer;
  NSRHOEOS: integer;
  MTRHOSPEC: integer;
  DRHODC: double;
  CRHOREF: double;
begin
  if MT3DRHOFLG = -1 then
  begin
    // 4a
    DENSEREF := StrToFloat(frmModflow.adeRefFluidDens.Text);
    DRHODPRHD := StrToFloat(frmModflow.adeSW_SlopePresHead.Text);
    PRHDREF := StrToFloat(frmModflow.adeSWRefHead.Text);
    WriteLn(FFile, FreeFormattedReal(DENSEREF), FreeFormattedReal(DRHODPRHD),
      FreeFormattedReal(PRHDREF));

    // 4b
    NSRHOEOS := StrToInt(frmModflow.adeSWDensCompCount.Text);
    WriteLn(FFile, NSRHOEOS);

    // 4c
    for RowIndex := 1 to NSRHOEOS do
    begin
      MTRHOSPEC := StrToInt(frmModflow.rdgSWDensTable.Cells[Ord(ecSpeciesNumber),RowIndex]);
      DRHODC := StrToFloat(frmModflow.rdgSWDensTable.Cells[Ord(ecSlope),RowIndex]);
      CRHOREF := StrToFloat(frmModflow.rdgSWDensTable.Cells[Ord(ecRefConc),RowIndex]);
      WriteLn(FFile, MTRHOSPEC, ' ', FreeFormattedReal(DRHODC),
        FreeFormattedReal(CRHOREF));
    end;

  end;
end;

procedure TVariableDensityWriter.WriteDataSet5;
var
  FIRSTDT: double;
begin
  FIRSTDT := StrToFloat(frmModflow.adeSW_FirstTimeStepLength.Text);
  WriteLn(FFile, FreeFormattedReal(FIRSTDT));
end;

procedure TVariableDensityWriter.WriteDataSet6(
  const StressPeriod: integer);
begin
  case frmModflow.comboSW_DensitySpecificationMethod.ItemIndex of
    0:  // steady density
      begin
        if StressPeriod = 1 then
        begin
          INDENSE := 1;
        end
        else
        begin
          INDENSE := -1;
        end;
      end;
    1:  // steady concentration
      begin
        if StressPeriod = 1 then
        begin
          INDENSE := 2;
        end
        else
        begin
          INDENSE := -1;
        end;
      end;
    2: // time variable density
      begin
        INDENSE := 1;
      end;
    3: // time variable concentration
      begin
        INDENSE := 2;
      end;
    4:  // Constant density = DENSEREF
      begin
        INDENSE := 0;
      end;
  else Assert(False);
  end;
  WriteLn(FFile, INDENSE);
end;

procedure TVariableDensityWriter.WriteDataSet7(
  const StressPeriod: integer);
var
  LayerRoot, ParameterName: string;
  UnitIndex: integer;
  GridLayer, DensityLayer : TLayerOptions;
  ColIndex, RowIndex: integer;
  BlockIndex: integer;
  ABlock : TBlockObjectOptions;
  DisIndex: integer;
  Max: integer;
begin
  case INDENSE of
    -1, 0:
      begin
        // do nothing
        Exit;
      end;
    1, 2:
      begin
        LayerRoot := ModflowTypes.GetFluidDensityLayerType.WriteNewRoot;
        if ModflowTypes.GetMFFluidDensityParamType.TimeVarying then
        begin
          ParameterName := ModflowTypes.GetMFFluidDensityParamType.
            WriteParamName + IntToStr(StressPeriod);
        end
        else
        begin
          ParameterName := ModflowTypes.GetMFFluidDensityParamType.
            WriteParamName;
        end;
      end;
  else
    begin
      Assert(False);
    end;
  end;

  Max := 0;
  for UnitIndex := 1 to DisWriter.NUNITS do
  begin
    if frmMODFLOW.Simulated(UnitIndex) then
    begin
      Max := Max + frmModflow.DiscretizationCount(UnitIndex) + 1
    end;
  end;
  if Length(X) = 0 then
  begin
    Max := Max + 1;
  end;
  Max := Max * DisWriter.NCOL * DisWriter.NROW;
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Max;

  if Length(X) = 0 then
  begin
    SetLength(X, DisWriter.NCOL, DisWriter.NROW);
    SetLength(Y, DisWriter.NCOL, DisWriter.NROW);
    GridLayer := TLayerOptions.Create(DisWriter.GridLayerHandle);
    try
      for RowIndex := 0 to DisWriter.NROW -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        for ColIndex := 0 to DisWriter.NCOL -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;

          BlockIndex := DisWriter.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
            DisWriter.GridLayerHandle, BlockIndex);
          try
            ABlock.GetCenter(CurrentModelHandle,
              X[ColIndex,RowIndex], Y[ColIndex,RowIndex]);
          finally
            ABlock.Free;
          end;
          frmProgress.pbActivity.StepIt;
        end;
      end;
    finally
      GridLayer.Free(CurrentModelHandle);
    end;

    SetLength(DensityArray, DisWriter.NCOL, DisWriter.NROW);
  end;

  for UnitIndex := 1 to DisWriter.NUNITS do
  begin
    if not ContinueExport then break;
    Application.ProcessMessages;
    if not frmMODFLOW.Simulated(UnitIndex) then
    begin
      Application.ProcessMessages;
    end
    else
    begin
      if ContinueExport then
      begin
        // Density
        DensityLayer := TLayerOptions.CreateWithName(LayerRoot +
          IntToStr(UnitIndex), CurrentModelHandle);
        try
          for RowIndex := 0 to DisWriter.NROW -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

            for ColIndex := 0 to DisWriter.NCOL -1 do
            begin
              Application.ProcessMessages;
              if not ContinueExport then break;

              if BasicWriter.IBOUND[ColIndex,RowIndex,UnitIndex-1] = 0 then
              begin
                DensityArray[ColIndex, RowIndex] := 0;
              end
              else
              begin
                DensityArray[ColIndex, RowIndex] :=
                  DensityLayer.RealValueAtXY(CurrentModelHandle,
                  X[ColIndex,RowIndex], Y[ColIndex,RowIndex], ParameterName);

              end;
              frmProgress.pbActivity.StepIt;
            end;
          end;
        finally
          DensityLayer.Free(CurrentModelHandle);
        end;
        for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
        begin
          WriteU2DRELHeader(LayerRoot + IntToStr(UnitIndex));
          for RowIndex := 0 to DisWriter.NROW -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

            for ColIndex := 0 to DisWriter.NCOL -1 do
            begin
              Application.ProcessMessages;
              if not ContinueExport then break;

              Write(FFile, FreeFormattedReal(DensityArray[ColIndex,RowIndex]));

              frmProgress.pbActivity.StepIt;
            end;
            WriteLn(FFile);
          end;
        end;
      end;
    end;
  end;
end;

procedure TVariableDensityWriter.WriteDataSets6and7;
var
  TimeIndex: integer;
begin
  if MT3DRHOFLG = 0 then
  begin
    frmProgress.pbPackage.Position := 0;
    frmProgress.pbPackage.Max := frmModflow.dgTime.RowCount -1;
    for TimeIndex := 1 to frmModflow.dgTime.RowCount -1 do
    begin
      frmProgress.lblActivity.Caption := 'Variable Density Flow, Time Step '
        + IntToStr(TimeIndex);
      Application.ProcessMessages;
      if not ContinueExport then break;
      WriteDataSet6(TimeIndex);
      WriteDataSet7(TimeIndex);
      frmProgress.pbPackage.StepIt;
    end;
  end;
end;

procedure TVariableDensityWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter; BasicPkg: TBasicPkgWriter);
var
  FileName: string;
begin
  DisWriter := Discretization;
  BasicWriter := BasicPkg;
  self.CurrentModelHandle := CurrentModelHandle;
  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Variable Density Flow';

    FileName := GetCurrentDir + '\' + Root + rsVDF;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      WriteDataSet1;
      WriteDataSet2;
      WriteDataSet3;
      WriteDataSet4;
      WriteDataSet4a_to_4c;
      WriteDataSet5;
      WriteDataSets6and7;
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;

end;

end.
