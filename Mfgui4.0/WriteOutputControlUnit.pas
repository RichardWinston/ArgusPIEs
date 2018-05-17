unit WriteOutputControlUnit;

interface

uses Sysutils, Classes, ANEPIE, WriteModflowDiscretization;

type
  TOutputControlWriter = class(TModflowWriter)
  private
    procedure WriteHeadPrintFormat;
    procedure WriteDrawdownPrintFormat;
    procedure WriteHeadSaveFormat;
    procedure WriteDrawdownSaveFormat;
    procedure WriteHeadSaveUnit(UnitNumber : integer);
    procedure WriteDrawdownSaveUnit(UnitNumber : integer);
    procedure WriteCompactBudget;
    procedure WriteDataSet1;
    procedure WriteDataSets2and3;
  public
    procedure WriteFile(Root: string);
    class procedure AssignUnitNumbers;
  end;

implementation

uses Variables, ModflowUnit, OptionsUnit, WriteNameFileUnit,
  frameOutputControlUnit, contnrs;

{ TOutputControlWriter }


class procedure TOutputControlWriter.AssignUnitNumbers;
begin
  case frmModflow.comboExportHead.ItemIndex of
    1:
      begin
        frmModflow.GetUnitNumber('FHD');
      end;
    2:
      begin
        frmModflow.GetUnitNumber('BHD');
      end;
  end;
  case frmModflow.comboExportDrawdown.ItemIndex of
    1:
      begin
        frmModflow.GetUnitNumber('FDN');
      end;
    2:
      begin
        frmModflow.GetUnitNumber('BDN');
      end;
  end;
end;

procedure TOutputControlWriter.WriteCompactBudget;
begin
  Write(FFile, 'COMPACT BUDGET');
  if frmModflow.cbMODPATH.Checked then
  begin
    Write(FFile, ' AUX');
  end;
  Writeln(FFile)
end;

procedure TOutputControlWriter.WriteDataSet1;
begin
  WriteHeadPrintFormat;
  WriteDrawdownPrintFormat;
  case frmModflow.comboExportHead.ItemIndex of
    1:
      begin
        WriteHeadSaveFormat;
        WriteHeadSaveUnit(frmModflow.GetUnitNumber('FHD'));
      end;
    2:
      begin
        WriteHeadSaveUnit(frmModflow.GetUnitNumber('BHD'));
      end;
  end;
  case frmModflow.comboExportDrawdown.ItemIndex of
    1:
      begin
        WriteDrawdownSaveFormat;
        WriteDrawdownSaveUnit(frmModflow.GetUnitNumber('FDN'));
      end;
    2:
      begin
        WriteDrawdownSaveUnit(frmModflow.GetUnitNumber('BDN'));
      end;
  end;
  if frmModflow.cbFlowBudget.Checked then
  begin
    WriteCompactBudget;
  end;
end;

procedure TOutputControlWriter.WriteDataSets2and3;
  function ShouldPrint(TimeStepOrPeriod, Frequency : integer) : boolean;
  begin
    result := (Frequency <> 0) and ((TimeStepOrPeriod mod Frequency) = 0);
  end;
var
  PeriodIndex, StepIndex : integer;
  DataSet3 : TStringList;
  HeadPrintFrequency, DrawDownPrintFrequency : integer;
  HeadSaveFrequency, DrawDownSaveFrequency : integer;
  BudgetPrintFrequency, BudgetSaveFrequency: integer;
  LineIndex : integer;
  NSTP : integer;
  ReferencePeriod: boolean;
  NPER: integer;
  HeadPrintTimes, DrawdownPrintTimes, BudgetPrintTimes: TList;
  HeadSaveTimes, DrawdownSaveTimes, BudgetSaveTimes: TList;
  procedure WriteItem(const Choice, Frequency: integer;
    const PrintSaveString: string; const PeriodTimeList: TList);
  var
    PeriodTime: TPeriodTimeStep;
  begin
    case Choice of
      0: // none
        begin
          // Do nothing;
        end;
      1: // Each N'th timestep
        begin
          if (StepIndex = NSTP) or
            ShouldPrint(StepIndex,Frequency) then
          begin
            DataSet3.Add(PrintSaveString);
          end;
        end;
      2: // Last timestep of each Stress Period
        begin
          if (StepIndex = NSTP) then
          begin
            DataSet3.Add(PrintSaveString);
          end;
        end;
      3: // every N'th StressPeriod;
        begin
          if ((PeriodIndex = NPER) or
            ShouldPrint(PeriodIndex,Frequency))
            and (StepIndex = NSTP) then
          begin
            DataSet3.Add(PrintSaveString);
          end;
        end;
      4: // specified
        begin
          if PeriodTimeList.Count > 0 then
          begin
            PeriodTime := PeriodTimeList[0];
            if (PeriodIndex = PeriodTime.Period)
              and (StepIndex = PeriodTime.TimeStep) then
            begin
              DataSet3.Add(PrintSaveString);
              PeriodTimeList.Delete(0);
            end;
          end;
        end;
      else
        begin
          Assert(False);
        end;
    end;
  end;
begin
  HeadPrintTimes := TObjectList.Create;
  DrawdownPrintTimes := TObjectList.Create;
  BudgetPrintTimes := TObjectList.Create;
  HeadSaveTimes := TObjectList.Create;
  DrawdownSaveTimes := TObjectList.Create;
  BudgetSaveTimes := TObjectList.Create;
  DataSet3 := TStringList.Create;
  try
    with frmMODFLOW do
    begin
      HeadPrintFrequency := StrToInt(adeHeadPrintFreq.Text);
      DrawDownPrintFrequency := StrToInt(adeDrawdownPrintFreq.Text);
      HeadSaveFrequency := StrToInt(adeHeadExportFreq.Text);
      DrawDownSaveFrequency := StrToInt(adeDrawdownExportFreq.Text);
      BudgetPrintFrequency := StrToInt(adeBudPrintFreq.Text);
      BudgetSaveFrequency := StrToInt(adeBudExportFreq.Text);

      if comboHeadPrintFreq.ItemIndex = 4 then
      begin
        frmModflow.frameOC_PrintHead.FillPerStepList(HeadPrintTimes);
      end;
      if comboDrawdownPrintFreq.ItemIndex = 4 then
      begin
        frmModflow.frameOC_PrintDrawdown.FillPerStepList(DrawdownPrintTimes);
      end;
      if comboHeadExportFreq.ItemIndex = 4 then
      begin
        frmModflow.frameOC_SaveHead.FillPerStepList(HeadSaveTimes);
      end;
      if comboDrawdownExportFreq.ItemIndex = 4 then
      begin
        frmModflow.frameOC_SaveDrawdown.FillPerStepList(DrawdownSaveTimes);
      end;
      if comboBudPrintFreq.ItemIndex = 4 then
      begin
        frmModflow.frameOC_PrintBudget.FillPerStepList(BudgetPrintTimes);
      end;
      if comboBudExportFreq.ItemIndex = 4 then
      begin
        frmModflow.frameOC_SaveFlows.FillPerStepList(BudgetSaveTimes);
      end;

      NPER := dgTime.RowCount -1;
      for PeriodIndex := 1 to NPER do
      begin
        NSTP := StrToInt(dgTime.Cells[Ord(tdNumSteps),PeriodIndex]);
        ReferencePeriod := dgTime.Cells[Ord(tdRefStrPeriod),PeriodIndex]
          = dgTime.Columns[Ord(tdRefStrPeriod)].PickList[1];
        for StepIndex := 1 to NSTP do
        begin
          // temporarily write data set 3 in the DataSet3 stringlist.
          DataSet3.Clear;

          WriteItem(comboHeadPrintFreq.ItemIndex, HeadPrintFrequency,
            '   PRINT HEAD', HeadPrintTimes);

          WriteItem(comboDrawdownPrintFreq.ItemIndex, DrawDownPrintFrequency,
            '   PRINT DRAWDOWN', DrawdownPrintTimes);

          WriteItem(comboBudPrintFreq.ItemIndex, BudgetPrintFrequency,
            '   PRINT BUDGET', BudgetPrintTimes);

          WriteItem(comboHeadExportFreq.ItemIndex, HeadSaveFrequency,
            '   SAVE HEAD', HeadSaveTimes);

          WriteItem(comboDrawdownExportFreq.ItemIndex, DrawDownSaveFrequency,
            '   SAVE DRAWDOWN', DrawdownSaveTimes);

          WriteItem(comboBudExportFreq.ItemIndex, BudgetSaveFrequency,
            '   SAVE BUDGET', BudgetSaveTimes);

          if DataSet3.Count > 0 then
          begin
            // write data set 2
            WriteLn(FFile);
            if ReferencePeriod and (StepIndex = NSTP) then
            begin
              WriteLn(FFile, 'PERIOD ', PeriodIndex, ' STEP ', StepIndex,
                ' DDREFERENCE');
            end
            else
            begin
              WriteLn(FFile, 'PERIOD ', PeriodIndex, ' STEP ', StepIndex);
            end;
            // write data set 3
            for LineIndex := 0 to DataSet3.Count -1 do
            begin
              WriteLn(FFile, DataSet3[LineIndex]);
            end;
          end;

        end;
      end;
    end;
  finally
    DataSet3.Free;
    HeadPrintTimes.Free;
    DrawdownPrintTimes.Free;
    BudgetPrintTimes.Free;
    HeadSaveTimes.Free;
    DrawdownSaveTimes.Free;
    BudgetSaveTimes.Free;
  end;
end;

procedure TOutputControlWriter.WriteDrawdownPrintFormat;
var
  IDDNFM : integer;
begin
  With frmMODFLOW do
  begin
    // HEAD PRINT FORMAT
    IDDNFM := comboDrawdownPrintFormat.ItemIndex + 1;
    if comboDrawdownPrintStyle.ItemIndex = 0 then
    begin
      IDDNFM := -IDDNFM;
    end;
    WriteLn(FFile, 'DRAWDOWN PRINT FORMAT ', IDDNFM);
  end;
end;

procedure TOutputControlWriter.WriteDrawdownSaveFormat;
begin
    WriteLn(FFile, 'DRAWDOWN SAVE FORMAT '
      + frmModflow.frameDrawdownFormat.FortranFormat + ' LABEL');
end;

procedure TOutputControlWriter.WriteDrawdownSaveUnit(UnitNumber : integer);
begin
    WriteLn(FFile, 'DRAWDOWN SAVE UNIT ', UnitNumber);
end;

procedure TOutputControlWriter.WriteFile(Root: string);
var
  FileName : String;
begin
  FileName := GetCurrentDir + '\' + Root + rsOC;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);
    WriteDataSet1;
    WriteDataSets2and3;
    Flush(FFile);
  finally
    CloseFile(FFile);
  end;
end;

procedure TOutputControlWriter.WriteHeadPrintFormat;
var
  IHEDFM : integer;
begin
  With frmMODFLOW do
  begin
    // HEAD PRINT FORMAT
    IHEDFM := comboHeadPrintFormat.ItemIndex + 1;
    if comboHeadPrintStyle.ItemIndex = 0 then
    begin
      IHEDFM := -IHEDFM;
    end;
    WriteLn(FFile, 'HEAD PRINT FORMAT ', IHEDFM);
  end;
end;

procedure TOutputControlWriter.WriteHeadSaveFormat;
begin
    WriteLn(FFile, 'HEAD SAVE FORMAT '
      + frmModflow.frameHeadFormat.FortranFormat + ' LABEL');
end;

procedure TOutputControlWriter.WriteHeadSaveUnit(UnitNumber : integer);
begin
    WriteLn(FFile, 'HEAD SAVE UNIT ', UnitNumber);
end;

end.
