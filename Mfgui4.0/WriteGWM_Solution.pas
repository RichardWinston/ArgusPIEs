unit WriteGWM_Solution;

interface

uses Windows, SysUtils, Forms, WriteModflowDiscretization, WriteGWM_DecisionVariables;

type
  TSolutionWriter = class(TModflowWriter)
  private
    Root: string;
    DecVarWriter: TWriteGWM_DecisionVariablesAndConstraintsWriter;
    procedure AssignSimpleValues(out DELTA: double; out NSIGDIG,
      NPGNMX: integer; out PGFACT: double);
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5;
    procedure WriteDataSet6;
    procedure AssignLP_Values(out LPITMAX, BBITMAX, BBITPRT,
      RANGE: integer; out CRITMFC: double);
  public
    procedure WriteFile(const Root: string;
      const DecVarWriter: TWriteGWM_DecisionVariablesAndConstraintsWriter);
  end;


implementation

uses UtilityFunctions, Variables, WriteNameFileUnit, ProgressUnit;

{ TSolutionWriter }

procedure TSolutionWriter.WriteDataSet1;
var
  SOLNTYP: string;
begin
  case frmModflow.rgGWM_SolutionType.ItemIndex of
    0:
      begin
        SOLNTYP := 'NS';
      end;
    1:
      begin
        SOLNTYP := 'MPS';
      end;
    2:
      begin
        SOLNTYP := 'LP';
      end;
    3:
      begin
        SOLNTYP := 'SLP';
      end;
  else
    begin
      Assert(False);
    end;
  end;

  WriteLn(FFile, SOLNTYP);
end;

procedure TSolutionWriter.WriteDataSet2;
var
  DELTA: double;
  NSIGDIG, NPGNMX: integer;
  PGFACT: double;
  RMNAME: string;
begin
  if frmModflow.rgGWM_SolutionType.ItemIndex = 0 then
  begin
    AssignSimpleValues(DELTA, NSIGDIG, NPGNMX, PGFACT);
    RMNAME := GetCurrentDir + '\' + Root + rsRSP;
    // 2A
    WriteLn(FFile, Delta);
    // 2B
    WriteLn(FFile, NSIGDIG, ' ', NPGNMX, ' ', PGFACT);
    // 2C
    WriteLn(FFile, RMNAME);
  end;
end;

procedure TSolutionWriter.WriteDataSet3;
var
  DELTA: double;
  NSIGDIG, NPGNMX: integer;
  PGFACT: double;
  MPSNAME: string;
begin
  if frmModflow.rgGWM_SolutionType.ItemIndex = 1 then
  begin
    AssignSimpleValues(DELTA, NSIGDIG, NPGNMX, PGFACT);
    MPSNAME := GetCurrentDir + '\' + Root + rsMSP;
    // 3A
    WriteLn(FFile, Delta);
    // 3B
    WriteLn(FFile, NSIGDIG, ' ', NPGNMX, ' ', PGFACT);
    // 3C
    WriteLn(FFile, MPSNAME);
  end;
end;

procedure TSolutionWriter.AssignSimpleValues(out DELTA: double;
  out NSIGDIG, NPGNMX: integer; out PGFACT: double);
begin
  with frmModflow do
  begin
    DELTA := InternationalStrToFloat(adeGWM_Delta.Text);
    NSIGDIG := StrToInt(adeGWM_NSIGDIG.Text);
    NPGNMX := StrToInt(adeGWM_NPGNMX.Text);
    PGFACT := InternationalStrToFloat(adeGWM_PGFACT.Text);
  end;
end;


procedure TSolutionWriter.WriteFile(const Root: string;
  const DecVarWriter: TWriteGWM_DecisionVariablesAndConstraintsWriter);
var
  FileName: string;
begin
  self.Root := Root;
  self.DecVarWriter := DecVarWriter;
  FileName := GetCurrentDir + '\' + Root + rsSOLN;
  AssignFile(FFile, FileName);
  try
    Rewrite(FFile);
    if ContinueExport then
    begin
      WriteDataReadFrom(FileName);
      frmProgress.lblActivity.Caption := 'Writing Data Set 1';
      WriteDataSet1;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;
    if ContinueExport then
    begin
      frmProgress.lblActivity.Caption := 'Writing Data Set 2';
      WriteDataSet2;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;
    if ContinueExport then
    begin
      frmProgress.lblActivity.Caption := 'Writing Data Set 3';
      WriteDataSet3;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;
    if ContinueExport then
    begin
      frmProgress.lblActivity.Caption := 'Writing Data Set 4';
      WriteDataSet4;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;
    if ContinueExport then
    begin
      frmProgress.lblActivity.Caption := 'Writing Data Set 5';
      WriteDataSet5;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;
    if ContinueExport then
    begin
      frmProgress.lblActivity.Caption := 'Writing Data Set 5';
      WriteDataSet6;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

  finally
    CloseFile(FFile);
  end;
end;

procedure TSolutionWriter.WriteDataSet4;
var
  DELTA: double;
  NSIGDIG, NPGNMX: integer;
  PGFACT: double;
  IRM: integer;
  LPITMAX: integer;
  BBITMAX: integer;
  BBITPRT: integer;
  RANGE: integer;
  RMNAME: string;
  WriteNewLine: boolean;
  CRITMFC: double;
begin
  with frmModflow do
  begin
    if rgGWM_SolutionType.ItemIndex = 2 then
    begin
      AssignSimpleValues(DELTA, NSIGDIG, NPGNMX, PGFACT);
      IRM := rgGWM_ResponseMatrix.ItemIndex;
      if cbGWM_PrintResponseMatrix.Checked then
      begin
        IRM := 5 - IRM;
      end;

      AssignLP_Values(LPITMAX, BBITMAX, BBITPRT, RANGE, CRITMFC);
      // 4A
      WriteLn(FFile, IRM);
      // 4B
      WriteLn(FFile, LPITMAX, ' ', BBITMAX);
      // 4C
      WriteLn(FFile, Delta);
      // 4D
      WriteLn(FFile, NSIGDIG, ' ', NPGNMX, ' ', PGFACT, ' ', CRITMFC);
      // 4E
      WriteLn(FFile, BBITPRT, ' ', RANGE);

      // 4F
      WriteNewLine := False;
      if IRM in [0,1,4,5] then
      begin
        RMNAME := ExtractFileName(framFilePathGWM_ResponseMatrix.edFilePath.Text);
        Write(FFile,RMNAME);
        WriteNewLine := True;
        if (IRM in [1,4]) and FileExists(RMNAME) then
        begin
          DeleteFile(RMNAME);
        end;
      end;
      if cbGWM_PrintResponseMatrix.Enabled
        and cbGWM_PrintResponseMatrix.Checked then
      begin
        RMNAME := ExtractFileName(framFilePathGWM_ResponseMatrixAscii.edFilePath.Text);
        Write(FFile, ' ', RMNAME);
        WriteNewLine := True;
        if FileExists(RMNAME) then
        begin
          DeleteFile(RMNAME);
        end;
      end;
      if WriteNewLine then
      begin
        WriteLn(FFile);
      end;
    end;
  end;
end;

procedure TSolutionWriter.AssignLP_Values(out LPITMAX, BBITMAX, BBITPRT,
  RANGE: integer; out CRITMFC: double);
begin
  with frmModflow do
  begin
    LPITMAX := StrToInt(adeGWM_LPITMAX.Text);
    BBITMAX := StrToInt(adeGWM_BBITMAX.Text);
    if cbGWM_BBITPRT.Checked then
    begin
      BBITPRT := 1;
    end
    else
    begin
      BBITPRT := 0;
    end;
    if cbGWM_Range.Checked then
    begin
      RANGE := 1;
    end
    else
    begin
      RANGE := 0;
    end;
    case rgCritMFC.ItemIndex of
      0:
        begin
          CRITMFC := 0;
        end;
      1:
        begin
          CRITMFC := StrToFloat(rdeCritMFC.Output);
        end;
      2:
        begin
          CRITMFC := -1;
        end;
      else Assert(False);
    end;
  end;
end;


procedure TSolutionWriter.WriteDataSet5;
var
  DELTA: double;
  NSIGDIG, NPGNMX: integer;
  PGFACT: double;
  LPITMAX: integer;
  BBITMAX: integer;
  BBITPRT: integer;
  RANGE: integer;
  SLPITMAX: integer;
  SLPVCRIT: double;
  SLPZCRIT: double;
  DINIT: double;
  DMIN: double;
  DSC: double;
  AFACT: double;
  NINFMX: integer;
  SLPITPRT: integer;
  CRITMFC: double;
begin
  with frmModflow do
  begin
    if rgGWM_SolutionType.ItemIndex = 3 then
    begin
      AssignSimpleValues(DELTA, NSIGDIG, NPGNMX, PGFACT);
      AssignLP_Values(LPITMAX, BBITMAX, BBITPRT, RANGE, CRITMFC);

      SLPITMAX := StrToInt(adeGWM_SLPITMAX.Text);
      SLPVCRIT := InternationalStrToFloat(adeGWM_SLPVCRIT.Text);
      SLPZCRIT := InternationalStrToFloat(adeGWM_SLPZCRIT.Text);
      DINIT := InternationalStrToFloat(adeGWM_DINIT.Text);
      DMIN := InternationalStrToFloat(adeGWM_DMIN.Text);
      DSC := InternationalStrToFloat(adeGWM_DSC.Text);
      AFACT := InternationalStrToFloat(adeGWM_AFACT.Text);
      NINFMX := StrToInt(adeGWM_NINFMX.Text);
      SLPITPRT := comboGWM_SLPITPRT.ItemIndex;
{      if cbGWM_SLPITPRT.Checked then
      begin
        SLPITPRT := 1;
      end
      else
      begin
        SLPITPRT := 0;
      end;  }

      // 5A
      WriteLn(FFile, SLPITMAX, ' ', LPITMAX, ' ', BBITMAX);
      // 5B
      WriteLn(FFile, SLPVCRIT, ' ', SLPZCRIT, ' ', DINIT, ' ', DMIN, ' ', DSC);
      // 5C
      WriteLn(FFile, NSIGDIG, ' ', NPGNMX, ' ', PGFACT, ' ', AFACT, ' ',
        NINFMX, ' ', CRITMFC);
      // 5D
      WriteLn(FFile, SLPITPRT, ' ', BBITPRT, ' ', RANGE);
    end;
  end;
end;

procedure TSolutionWriter.WriteDataSet6;
const
  IBASE = 1;
begin
  WriteLn(FFile, IBASE);
  DecVarWriter.WriteSolnDataSet6(self);
end;

end.
