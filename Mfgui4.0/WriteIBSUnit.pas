unit WriteIBSUnit;

interface

uses Sysutils, Forms, AnePIE, WriteModflowDiscretization;

type
  TIBSWriter = class(TModflowWriter)
  private
    HC, Sfe, Sfv, COM : array of array of double;
    IIBSOC : integer;
    Procedure WriteDataSet1;
    Procedure WriteDataSet2;
    Procedure SetArraySizes(Discretization : TDiscretizationWriter);
    Procedure EvaluateUnit(const UnitNumber : integer;
      const CurrentModelHandle: ANE_PTR;
      const Discretization : TDiscretizationWriter;
      const BasicPackage :TBasicPkgWriter);
    Procedure WriteUnit(const UnitNumber : integer;
      const CurrentModelHandle: ANE_PTR;
      const Discretization : TDiscretizationWriter;
      const BasicPackage :TBasicPkgWriter);
    Procedure WriteHC(const Discretization : TDiscretizationWriter);
    Procedure WriteSfe(const Discretization : TDiscretizationWriter);
    procedure WriteSfv(const Discretization : TDiscretizationWriter);
    procedure WriteCOM(const Discretization : TDiscretizationWriter);
    procedure WriteAllUnits(const CurrentModelHandle: ANE_PTR;
      const Discretization : TDiscretizationWriter;
      const BasicPackage :TBasicPkgWriter);
    Procedure WriteDataSet7;
    procedure WriteDataSet8;
  public
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      const Discretization : TDiscretizationWriter;
      const BasicPackage :TBasicPkgWriter);
    class procedure AssignUnitNumbers;
  end;

implementation

uses WriteNameFileUnit, Variables, ProgressUnit, OptionsUnit, ModflowUnit;

{ TIBSWriter }

class procedure TIBSWriter.AssignUnitNumbers;
begin
  with frmModflow do
  begin
    if cbFlowIBS.Checked or cbOneFlowFile.Checked then
    begin
      if cbOneFlowFile.Checked then
      begin
        frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        frmModflow.GetUnitNumber('IBSBUD');
      end;
    end;
  end;
  frmModflow.GetUnitNumber('IBSSubsidenceUnit');
  frmModflow.GetUnitNumber('IBSCompactionUnit');
  frmModflow.GetUnitNumber('IBSPreconsolidationHeadUnit');

end;

procedure TIBSWriter.EvaluateUnit(const UnitNumber: integer;
  const CurrentModelHandle: ANE_PTR; 
  const Discretization: TDiscretizationWriter;
  const BasicPackage: TBasicPkgWriter);
var
  GridLayer : TGridLayerOptions;
  ParameterName : string;
  ABlock : TBlockObjectOptions;
  PreConsolidationIndex, ElasticStorageIndex : ANE_INT16;
  InelasticStorageIndex, InitialCompactionIndex : ANE_INT16;
  RowIndex, ColIndex, BlockIndex : integer;
begin
  GridLayer := TGridLayerOptions.Create(CurrentModelHandle,
    Discretization.GridLayerHandle);
  try

    ParameterName := ModflowTypes.GetMFGridIbsPreconsolidationHeadParamType.
      WriteParamName + IntToStr(UnitNumber);
    PreConsolidationIndex := GridLayer.GetParameterIndex
      (CurrentModelHandle,ParameterName);

    ParameterName := ModflowTypes.GetMFGridIbsElasticStorageParamType.
      WriteParamName + IntToStr(UnitNumber);
    ElasticStorageIndex := GridLayer.GetParameterIndex
      (CurrentModelHandle,ParameterName);

    ParameterName := ModflowTypes.GetMGridIbsInelasticStorageParamType.
      WriteParamName + IntToStr(UnitNumber);
    InelasticStorageIndex := GridLayer.GetParameterIndex
      (CurrentModelHandle,ParameterName);

    ParameterName := ModflowTypes.GetMFGridIbsStartingCompactionParamType.
      WriteParamName + IntToStr(UnitNumber);
    InitialCompactionIndex := GridLayer.GetParameterIndex
      (CurrentModelHandle,ParameterName);

    for RowIndex := 0 to Discretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to Discretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if BasicPackage.IBOUND[ColIndex,RowIndex,UnitNumber-1] <> 0 then
        begin
          BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
          ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
            Discretization.GridLayerHandle, BlockIndex);

          HC[ColIndex,RowIndex] := ABlock.GetFloatParameter
            (CurrentModelHandle,PreConsolidationIndex);
          Sfe[ColIndex,RowIndex] := ABlock.GetFloatParameter
            (CurrentModelHandle,ElasticStorageIndex);
          Sfv[ColIndex,RowIndex] := ABlock.GetFloatParameter
            (CurrentModelHandle,InelasticStorageIndex);
          COM[ColIndex,RowIndex] := ABlock.GetFloatParameter
            (CurrentModelHandle,InitialCompactionIndex);
        end
        else
        begin
          HC[ColIndex,RowIndex] := 0;
          Sfe[ColIndex,RowIndex] := 0;
          Sfv[ColIndex,RowIndex] := 0;
          COM[ColIndex,RowIndex] := 0;
        end;
        frmProgress.pbActivity.StepIt;
      end;
    end;
  finally
    GridLayer.Free(CurrentModelHandle);
  end;
end;

procedure TIBSWriter.SetArraySizes(Discretization: TDiscretizationWriter);
begin
  With Discretization do
  begin
    SetLength(HC, NCOL, NROW);
    SetLength(Sfe, NCOL, NROW);
    SetLength(Sfv, NCOL, NROW);
    SetLength(COM, NCOL, NROW);
  end;
end;

procedure TIBSWriter.WriteAllUnits(const CurrentModelHandle: ANE_PTR;
  const Discretization: TDiscretizationWriter;
  const BasicPackage: TBasicPkgWriter);
var
  UnitIndex : integer;
begin
  SetArraySizes(Discretization);
  for UnitIndex := 1 to frmModflow.UnitCount do
  begin
    if frmModflow.Simulated(UnitIndex) and frmModflow.UseIBS(UnitIndex) then
    begin
      WriteUnit(UnitIndex, CurrentModelHandle, Discretization, BasicPackage);
    end;
    frmProgress.pbPackage.StepIt;
  end;
end;

procedure TIBSWriter.WriteCOM(const Discretization : TDiscretizationWriter);
var
  ColIndex, RowIndex : integer;
begin
  WriteU2DRELHeader;
  for RowIndex := 0 to Discretization.NROW -1 do
  begin
    for ColIndex := 0 to Discretization.NCOL -1 do
    begin
      Write(FFile, FreeFormattedReal(COM[ColIndex,RowIndex]));
      frmProgress.pbActivity.StepIt;
    end;
    WriteLn(FFile);
  end;
end;

procedure TIBSWriter.WriteDataSet1;
var
  IIBSCB : integer;
begin
  with frmModflow do
  begin
    if cbFlowIBS.Checked or cbOneFlowFile.Checked then
    begin
      if cbOneFlowFile.Checked then
      begin
        IIBSCB := frmModflow.GetUnitNumber('BUD');
      end
      else
      begin
        IIBSCB := frmModflow.GetUnitNumber('IBSBUD');
      end;
    end
    else
    begin
        IIBSCB := 0;
    end;
    IIBSOC := 1;
  end;
  WriteLn(FFile, Format('%10d %9d', [IIBSCB, IIBSOC]));
end;

procedure TIBSWriter.WriteDataSet2;
var
  UnitIndex, DiscretizationIndex : integer;
  Count : integer;
begin
  Count := 0;
  for UnitIndex := 1 to frmModflow.UnitCount do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      if frmModflow.UseIBS(UnitIndex) then
      begin
        for DiscretizationIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
        begin
          Write(FFile, ' 1');
          Inc(Count);
          if Count mod 40 = 0 then
          begin
            WriteLn(FFile);
          end;
        end;
      end
      else
      begin
        for DiscretizationIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
        begin
          Write(FFile, ' 0');
          Inc(Count);
          if Count mod 40 = 0 then
          begin
            WriteLn(FFile);
          end;
        end;
      end;
    end;
  end;
  if Count mod 40 <> 0 then
  begin
    WriteLn(FFile);
  end;
end;

procedure TIBSWriter.WriteDataSet7;
var
  PrintFormat : integer;
  ISUBFM, ICOMFM, IHCFM, ISUBUN, ICOMUN, IHCUN : integer;
begin
  if frmModflow.comboIBSPrintStyle.ItemIndex > 0 then
  begin
    PrintFormat := frmModflow.comboIBSPrintFormat.ItemIndex;
  end
  else
  begin
    PrintFormat := -frmModflow.comboIBSPrintFormat.ItemIndex;
    if PrintFormat = 0 then
    begin
      PrintFormat := -12;
    end;
  end;
  ISUBFM := PrintFormat;
  ICOMFM := PrintFormat;
  IHCFM := PrintFormat;
  ISUBUN := frmModflow.GetUnitNumber('IBSSubsidenceUnit');
  ICOMUN := frmModflow.GetUnitNumber('IBSCompactionUnit');
  IHCUN := frmModflow.GetUnitNumber('IBSPreconsolidationHeadUnit');

  WriteLn(FFile, Format('%10d %9d %9d %9d %9d %9d',
    [ISUBFM, ICOMFM, IHCFM, ISUBUN, ICOMUN, IHCUN]));
end;

procedure TIBSWriter.WriteDataSet8;
var
  StressPeriodIndex, TimeStepIndex : integer;
  StepsPerPeriod : integer;
  PrintResult : integer;
  PrintFrequency : integer;
  SaveResult : integer;
  SaveFrequency : integer;
  ISUBPR, ICOMPR, IHCPR, ISUBSV, ICOMSV, IHCSV : integer;
  NPER : integer;
begin
  if IIBSOC > 0 then
  begin
    NPER := frmModflow.dgTime.RowCount -1;
    frmProgress.pbActivity.Max := NPER;
    frmProgress.lblActivity.Caption := 'Writing Data Set 8';
    PrintFrequency := StrToInt(frmModflow.adeIBSPrintFrequency.Text);
    SaveFrequency := StrToInt(frmModflow.adeIBSSaveFrequency.Text);
    for StressPeriodIndex := 1 to NPER do
    begin
      // The IBS package does not read data set 8 for steady-state
      // stress periods.  This behavior is not documented.
      if frmModflow.IsSteady(StressPeriodIndex) then
      begin
        Continue;
      end;

      StepsPerPeriod := StrToInt(frmModflow.dgTime.Cells
        [Ord(tdNumSteps),StressPeriodIndex]);
      for TimeStepIndex := 1 to StepsPerPeriod do
      begin
        SaveResult := 0;
        PrintResult := 0;
        Case frmModflow.comboIBSPrintFrequency.ItemIndex of
          0:
            begin
              PrintResult := 0;
            end;
          1:
            begin
              if TimeStepIndex mod PrintFrequency = 0 then
              begin
                PrintResult := 1;
              end
              else
              begin
                PrintResult := 0;
              end;
            end;
          2:
            begin
              if TimeStepIndex = StepsPerPeriod then
              begin
                PrintResult := 1;
              end
              else
              begin
                PrintResult := 0;
              end;
            end;
        else Assert(False);
        end;
        Case frmModflow.comboIBSSaveFrequency.ItemIndex of
          0:
            begin
              SaveResult := 0;
            end;
          1:
            begin
              if TimeStepIndex mod SaveFrequency = 0 then
              begin
                SaveResult := 1;
              end
              else
              begin
                SaveResult := 0;
              end;
            end;
          2:
            begin
              if TimeStepIndex = StepsPerPeriod then
              begin
                SaveResult := 1;
              end
              else
              begin
                SaveResult := 0;
              end;
            end;
        else Assert(False);
        end;
        ISUBPR := PrintResult;
        ICOMPR := PrintResult;
        IHCPR := PrintResult;
        ISUBSV := SaveResult;
        ICOMSV := SaveResult;
        IHCSV := SaveResult;
        WriteLn(FFile, Format('%10d %9d %9d %9d %9d %9d',
          [ISUBPR, ICOMPR, IHCPR, ISUBSV, ICOMSV, IHCSV]));
      end;
    end;
  end;
end;

procedure TIBSWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; const Discretization: TDiscretizationWriter;
  const BasicPackage :TBasicPkgWriter);
var
  FileName : string;
begin

  if ContinueExport then
  begin
    frmProgress.lblPackage.Caption := 'Interbed Storage';
    frmProgress.pbPackage.Position := 0;
    frmProgress.pbPackage.Max := 2;

    FileName := GetCurrentDir + '\' + Root + rsIBS;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
//      WriteDataReadFrom(FileName);

      WriteDataSet1;
      WriteDataSet2;

      WriteAllUnits(CurrentModelHandle, Discretization, BasicPackage);
      frmProgress.pbPackage.StepIt;

      WriteDataSet7;
      WriteDataSet8;
      frmProgress.pbPackage.StepIt;

      Flush(FFile);
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;
end;

procedure TIBSWriter.WriteHC(const Discretization : TDiscretizationWriter);
var
  ColIndex, RowIndex : integer;
begin
  WriteU2DRELHeader;
  for RowIndex := 0 to Discretization.NROW -1 do
  begin
    for ColIndex := 0 to Discretization.NCOL -1 do
    begin
      Write(FFile, FreeFormattedReal(HC[ColIndex,RowIndex]));
      frmProgress.pbActivity.StepIt;
    end;
    WriteLn(FFile);
  end;
end;

procedure TIBSWriter.WriteSfe(const Discretization : TDiscretizationWriter);
var
  ColIndex, RowIndex : integer;
begin
  WriteU2DRELHeader;
  for RowIndex := 0 to Discretization.NROW -1 do
  begin
    for ColIndex := 0 to Discretization.NCOL -1 do
    begin
      Write(FFile, FreeFormattedReal(Sfe[ColIndex,RowIndex]));
      frmProgress.pbActivity.StepIt;
    end;
    WriteLn(FFile);
  end;
end;

procedure TIBSWriter.WriteSfv(const Discretization : TDiscretizationWriter);
var
  ColIndex, RowIndex : integer;
begin
  WriteU2DRELHeader;
  for RowIndex := 0 to Discretization.NROW -1 do
  begin
    for ColIndex := 0 to Discretization.NCOL -1 do
    begin
      Write(FFile, FreeFormattedReal(Sfv[ColIndex,RowIndex]));
      frmProgress.pbActivity.StepIt;
    end;
    WriteLn(FFile);
  end;
end;

procedure TIBSWriter.WriteUnit(const UnitNumber : integer;
      const CurrentModelHandle: ANE_PTR; 
      const Discretization : TDiscretizationWriter;
      const BasicPackage :TBasicPkgWriter);
var
  DiscretizationIndex : integer;
begin
  frmProgress.pbActivity.Position := 0;
  frmProgress.lblActivity.Caption := 'Writing Arrays for unit ' + IntToStr(UnitNumber);
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
    * (frmModflow.DiscretizationCount(UnitNumber) + 1);

  EvaluateUnit(UnitNumber, CurrentModelHandle, Discretization, BasicPackage);

  for DiscretizationIndex := 1 to frmModflow.DiscretizationCount(UnitNumber) do
  begin
    WriteHC(Discretization);
    WriteSfe(Discretization);
    WriteSfv(Discretization);
    WriteCOM(Discretization);
  end;
end;

end.
