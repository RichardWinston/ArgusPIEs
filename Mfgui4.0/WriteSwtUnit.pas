unit WriteSwtUnit;

interface

uses AnePIE, OptionsUnit, WriteModflowDiscretization;

type
  TSwtWriter = class(TModflowWriter)
  private
    Discretization: TDiscretizationWriter;
    CurrentModelHandle, GridLayerHandle: ANE_PTR;
    GridLayer: TLayerOptions;
    ICRCC: integer;
    ISTPCS: integer;
    ISWTOC: integer;
    LocalNSYSTM: integer;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5;
    procedure WriteDataSet6;
    procedure WriteArray(const Expression, Comment: string);
    procedure WriteDataSets7to13;
    procedure WriteDataSets14and15;
    procedure WriteDataSet16;
    procedure WriteDataSet17;
  public
    procedure WriteFile(const ModelHandle: ANE_PTR; Root: string;
      Dis : TDiscretizationWriter);
    class procedure GetOutputUnits(var OutputUnits: array of integer);
  end;


implementation

uses Sysutils, Forms, Variables, WriteNameFileUnit, ProgressUnit;

{ TSwtWriter }

procedure TSwtWriter.WriteDataSet1;
var
  ISWTCB, ITHK, IVOID: integer;
begin
  with frmModflow do
  begin
    if cbFlowSwt.Checked or cbOneFlowFile.Checked then
    begin
      if cbOneFlowFile.Checked then
      begin
        ISWTCB := frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        ISWTCB := frmModflow.GetUnitNumber('SWTBUD');
      end;
    end
    else
    begin
        ISWTCB := 0;
    end;

    ISWTOC := StrToInt(adeSwtISWTOC.Text);

    LocalNSYSTM := NSYSTM;

    ITHK := comboSwtITHK.ItemIndex;

    IVOID := comboSwtIVOID.ItemIndex;

    ISTPCS := comboSwtISTPCS.ItemIndex;

    ICRCC := comboSwtICRCC.ItemIndex;
    WriteLn(FFile, ISWTCB, ' ', ISWTOC, ' ', LocalNSYSTM, ' ', ITHK, ' ', IVOID, ' ',
      ISTPCS, ' ', ICRCC,
      ' # ISWTCB, ISWTOC, NSYSTM, ITHK, IVOID, ISTPCS, ICRCC');
  end
end;

procedure TSwtWriter.WriteDataSet2;
var
  MFLayer: integer;
  UnitIndex: integer;
  LayerIndex: integer;
  InterbedIndex: integer;
begin
  MFLayer:= 0;
  for UnitIndex := 1 to frmModflow.rdgSwt.RowCount -1 do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      for LayerIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
      begin
        Inc(MFLayer);
        for InterbedIndex := 1 to frmModflow.SwtInterbedCount(UnitIndex) do
        begin
          Write(FFile, MFLayer, ' ');
        end;
      end;
    end;
  end;
  Writeln(FFile);
end;

procedure TSwtWriter.WriteDataSet3;
var
  IState, IFM: integer;
  Index: integer;
begin
  with frmModflow do
  begin
    IFM := comboSwtFormat.ItemIndex;
    for Index := 0 to jclbPrintInitialDataSets.Items.Count -1 do
    begin
      if jclbPrintInitialDataSets.Checked[Index] then
      begin
        IState := 1;
      end
      else
      begin
        IState := 0;
      end;
      Write(FFile, IState, ' ', IFM, ' ');
    end;
    Writeln(FFile);
  end;

end;

procedure TSwtWriter.WriteArray(const Expression, Comment: string);
var
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  X, Y: ANE_DOUBLE;
  Value: ANE_DOUBLE;
begin
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW
    * Discretization.NCOL;

  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    WriteU2DRELHeader(Comment);
    for RowIndex := 0 to Discretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to Discretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
        ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
          Discretization.GridLayerHandle, BlockIndex);

        try
          ABlock.GetCenter(CurrentModelHandle, X, Y);
        finally
          ABlock.Free;
        end;

        Value := GridLayer.RealValueAtXY(CurrentModelHandle, X, Y, Expression);
        Write(FFile, FreeFormattedReal(Value));

        frmProgress.pbActivity.StepIt;
      end;
      WriteLn(FFile);
    end;
  finally
    GridLayer.Free(CurrentModelHandle);
  end;
  frmProgress.pbPackage.StepIt;
end;

procedure TSwtWriter.WriteDataSet4;
var
  Expression: string;
begin
  frmProgress.lblActivity.Caption := 'Writing data set 4: GL0 = geostatic stress';
  Expression := ModflowTypes.GetMFGeostaticStressLayerType.ANE_LayerName
    + '.' + ModflowTypes.GetMFGeostaticStressParamType.ANE_ParamName;
  WriteArray(Expression, 'data set 4: GL0');
end;

procedure TSwtWriter.WriteFile(const ModelHandle: ANE_PTR; Root: string;
  Dis: TDiscretizationWriter);
var
  FileName: string;
begin
  Discretization := Dis;
  CurrentModelHandle := ModelHandle;
  GridLayerHandle := Dis.GridLayerHandle;
  GridLayer := TLayerOptions.Create(GridLayerHandle);
  try
    frmProgress.lblPackage.Caption := 'SWT - Subsidence and Aquifer-System '
      + 'Compaction Package for Water-Table Aquifers';

    FileName := GetCurrentDir + '\' + Root + rsSWT;
    AssignFile(FFile,FileName);
    try
      if ContinueExport then
      begin
        Rewrite(FFile);
        WriteDataSet1;
        WriteDataSet2;
        WriteDataSet3;

        Application.ProcessMessages;
        if not ContinueExport then Exit;
        frmProgress.pbPackage.Max := 3 + 6*LocalNSYSTM;

        WriteDataSet4;
        Application.ProcessMessages;
        if not ContinueExport then Exit;

        WriteDataSet5;
        Application.ProcessMessages;
        if not ContinueExport then Exit;

        WriteDataSet6;
        Application.ProcessMessages;
        if not ContinueExport then Exit;

        WriteDataSets7to13;
        Application.ProcessMessages;
        if not ContinueExport then Exit;

        WriteDataSets14and15;
        Application.ProcessMessages;
        if not ContinueExport then Exit;

        WriteDataSet16;
        WriteDataSet17;
      end;
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;

  finally
    GridLayer.Free(CurrentModelHandle);
  end;
end;

procedure TSwtWriter.WriteDataSet5;
var
  Expression: string;
begin
  frmProgress.lblActivity.Caption := 'Writing data set 5: SGM = specific gravity of moist or unsaturated sediments';
  Expression := ModflowTypes.GetMFSpecificGravityLayerType.ANE_LayerName
    + '.' + ModflowTypes.GetMFUnsaturatedSpecificGravityParamType.ANE_ParamName;
  WriteArray(Expression, 'data set 5: SGM');
end;

procedure TSwtWriter.WriteDataSet6;
var
  Expression: string;
begin
  frmProgress.lblActivity.Caption := 'Writing data set 6: SGS = specific gravity of saturated sediments';
  Expression := ModflowTypes.GetMFSpecificGravityLayerType.ANE_LayerName
    + '.' + ModflowTypes.GetMFSaturatedSpecificGravityParamType.ANE_ParamName;
  WriteArray(Expression, 'data set 6: SGS');
end;

procedure TSwtWriter.WriteDataSets7to13;
var
  UnitIndex: integer;
  DisIndex: integer;
  Expression: string;
  InterbedIndex: integer;
begin
  for UnitIndex := 1 to frmModflow.rdgSwt.RowCount -1 do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
      begin
        for InterbedIndex := 1 to frmModflow.SwtInterbedCount(UnitIndex) do
        begin
          // Data set 7
          frmProgress.lblActivity.Caption := 'Writing data set 7: THICK = thickness of compressible sediments';
          Expression := ModflowTypes.GetMFSwtUnitLayerType.ANE_LayerName + IntToStr(UnitIndex)
            + '.' + ModflowTypes.GetMFSwtThicknessParamType.ANE_ParamName
            + IntToStr(InterbedIndex);
          WriteArray(Expression, 'data set 7: THICK');

          if ICRCC <> 0 then
          begin
            // Data set 8
            frmProgress.lblActivity.Caption := 'Writing data set 8: Sse = initial elastic skeletal specific storage of compressible beds';
            Expression := ModflowTypes.GetMFSwtUnitLayerType.ANE_LayerName + IntToStr(UnitIndex)
              + '.' + ModflowTypes.GetMFInitialElasticSpecificStorageParamType.ANE_ParamName
              + IntToStr(InterbedIndex);
            WriteArray(Expression, 'data set 8: Sse');

            // Data set 9
            frmProgress.lblActivity.Caption := 'Writing data set 9: Ssv = initial inelastic skeletal specific storage of compressible beds';
            Expression := ModflowTypes.GetMFSwtUnitLayerType.ANE_LayerName + IntToStr(UnitIndex)
              + '.' + ModflowTypes.GetMFInitialInelasticSpecificStorageParamType.ANE_ParamName
              + IntToStr(InterbedIndex);
            WriteArray(Expression, 'data set 9: Ssv');
          end
          else
          begin
            // Data set 10
            frmProgress.lblActivity.Caption := 'Writing data set 10: Cr = recompression index of compressible beds';
            Expression := ModflowTypes.GetMFSwtUnitLayerType.ANE_LayerName + IntToStr(UnitIndex)
              + '.' + ModflowTypes.GetMFRecompressionIndexParamType.ANE_ParamName
              + IntToStr(InterbedIndex);
            WriteArray(Expression, 'data set 10: Cr');

            // Data set 11
            frmProgress.lblActivity.Caption := 'Writing data set 11: Cc = Compression index of compressible beds';
            Expression := ModflowTypes.GetMFSwtUnitLayerType.ANE_LayerName + IntToStr(UnitIndex)
              + '.' + ModflowTypes.GetMFCompressionIndexParamType.ANE_ParamName
              + IntToStr(InterbedIndex);
            WriteArray(Expression, 'data set 11: Cc');
          end;

          // Data set 12
          frmProgress.lblActivity.Caption := 'Writing data set 12: VOID = initial void ratio of compressible beds';
          Expression := ModflowTypes.GetMFSwtUnitLayerType.ANE_LayerName + IntToStr(UnitIndex)
            + '.' + ModflowTypes.GetMFInitialVoidRatioParamType.ANE_ParamName
            + IntToStr(InterbedIndex);
          WriteArray(Expression, 'data set 12: VOID');

          // Data set 13
          frmProgress.lblActivity.Caption := 'Writing data set 13: SUB = initial compaction in each system of interbeds';
          Expression := ModflowTypes.GetMFSwtUnitLayerType.ANE_LayerName + IntToStr(UnitIndex)
            + '.' + ModflowTypes.GetMFInitialCompactionParamType.ANE_ParamName
            + IntToStr(InterbedIndex);
          WriteArray(Expression, 'data set 13: SUB');
        end;
      end;
    end;
  end;
end;

class procedure TSwtWriter.GetOutputUnits(var OutputUnits: array of integer);
var
  IUnitIndex: integer;
  ColIndex, RowIndex: integer;
begin
  for ColIndex := 6 to frmModflow.rdgSwtOutput.ColCount -1 do
  begin
    IUnitIndex := ColIndex-6;
    OutputUnits[IUnitIndex] := 0;
    for RowIndex := 1 to frmModflow.rdgSwtOutput.RowCount -1 do
    begin
      if frmModflow.rdgSwtOutput.Checked[ColIndex, RowIndex] and
        (frmModflow.rdgSwtOutput.Checked[4, RowIndex] or
        frmModflow.rdgSwtOutput.Checked[5, RowIndex]) then
      begin
        OutputUnits[IUnitIndex]
          := frmModflow.GetUnitNumber('SWT_Iun' + IntToStr(IUnitIndex));
        break;
      end;
    end;
  end;
end;

procedure TSwtWriter.WriteDataSet16;
var
  OutputUnits: array [1..13] of integer;
  IUnitIndex: integer;
  IFM: integer;
begin
  if ISWTOC > 0 then
  begin
    IFM := frmModflow.comboSwtFormat.ItemIndex;
    GetOutputUnits(OutputUnits);
    for IUnitIndex := 1 to 13 do
    begin
      Write(FFile, IFM, ' ', OutputUnits[IUnitIndex], ' ');
    end;
    Writeln(FFile);
  end;
end;

procedure TSwtWriter.WriteDataSet17;
var
  ISP1, ISP2, ITS1, ITS2: integer;
  RowIndex, ColIndex: integer;
  Print: boolean;
  Save: boolean;
begin
  if ISWTOC > 0 then
  begin
    for RowIndex := 1 to frmModflow.rdgSwtOutput.RowCount -1 do
    begin
      ISP1 := StrToInt(frmModflow.rdgSwtOutput.Cells[0, RowIndex]);
      ISP2 := StrToInt(frmModflow.rdgSwtOutput.Cells[1, RowIndex]);
      ITS1 := StrToInt(frmModflow.rdgSwtOutput.Cells[2, RowIndex]);
      ITS2 := StrToInt(frmModflow.rdgSwtOutput.Cells[3, RowIndex]);
      Print := frmModflow.rdgSwtOutput.Checked[4, RowIndex];
      Save := frmModflow.rdgSwtOutput.Checked[5, RowIndex];
      Write(FFile, ISP1, ' ', ISP2, ' ', ITS1, ' ', ITS2, ' ');
      for ColIndex := 6 to frmModflow.rdgSwtOutput.ColCount -1 do
      begin
        if frmModflow.rdgSwtOutput.Checked[ColIndex, RowIndex] and Print then
        begin
          Write(FFile, '1 ');
        end
        else
        begin
          Write(FFile, '0 ');
        end;
        if frmModflow.rdgSwtOutput.Checked[ColIndex, RowIndex] and Save then
        begin
          Write(FFile, '1 ');
        end
        else
        begin
          Write(FFile, '0 ');
        end;
      end;
      Writeln(FFile);
    end;
  end;
end;

procedure TSwtWriter.WriteDataSets14and15;
var
  UnitIndex: integer;
  DisIndex: integer;
  Expression: string;
//  InterbedIndex: integer;
begin
  for UnitIndex := 1 to frmModflow.rdgSwt.RowCount -1 do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      for DisIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
      begin
        if ISTPCS <> 0 then
        begin
          // Data set 14
          frmProgress.lblActivity.Caption := 'Writing data set 14: PCSOFF = offset from initial effective stress to initial preconsolidation stress';
          Expression := ModflowTypes.GetMFSwtUnitLayerType.ANE_LayerName
            + '.' + ModflowTypes.GetMFInitialEffectiveStressOffsetParamType.ANE_ParamName;
          WriteArray(Expression, 'data set 14: PCSOFF');
        end
        else
        begin
          // Data set 15
          frmProgress.lblActivity.Caption := 'Writing data set 15:  PCS = initial preconsolidation stress';
          Expression := ModflowTypes.GetMFSwtUnitLayerType.ANE_LayerName
            + '.' + ModflowTypes.GetMFInitialPreconsolidationStressParamType.ANE_ParamName;
          WriteArray(Expression, 'data set 15:  PCS');
        end;
      end;
    end;
  end;
end;

end.
