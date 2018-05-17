unit WriteParamEstUnit;

interface

uses Sysutils, Classes, ANEPIE, WriteModflowDiscretization;

type
  TParamEstWriter = class(TModflowWriter)
  private
    NegNames : TStringList;
    IPR : integer;
    function GetNPNG : integer;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5;
    procedure WriteDataSet6;
    procedure WriteDataSet7;
    procedure WriteDataSet8;
    procedure WriteDataSet9;
    procedure WriteDataSet10;
  public
    procedure WriteFile(Root: string);
  end;

implementation

Uses Variables, WriteNameFileUnit, ProgressUnit, UtilityFunctions;

{ TParamEstWriter }

function TParamEstWriter.GetNPNG: integer;
var
  Index : integer;
  AString : string;
begin
  NegNames.Clear;
  with frmModflow.dgNegParam do
  begin
    AString := Columns[1].PickList[1];
    for Index := 1 to RowCount -1 do
    begin
      if Cells[1,Index] = AString then
      begin
        NegNames.Add(Cells[1,Index]);
      end;
    end;
  end;
  result := NegNames.Count;
end;

procedure TParamEstWriter.WriteDataSet1;
var
  MaxIter : integer;
  MaxChange, TOL, SOSC : double;
begin
  with frmModflow do
  begin
    MaxIter := StrToInt(adeMaxParamEstIterations.Text);
    MaxChange := InternationalStrToFloat(adeMaxParamChange.Text);
    TOL := InternationalStrToFloat(adeParamEstTol.Text);
    SOSC := InternationalStrToFloat(adeParamEstSecClosCrit.Text);
  end;
  WriteLn(FFile, MaxIter, ' ',
  FreeFormattedReal(MaxChange),
  FreeFormattedReal(TOL),
  FreeFormattedReal(SOSC)
{  Format(' %.13e %.13e %.13e', [MaxChange, TOL, SOSC])});
end;

procedure TParamEstWriter.WriteDataSet2;
var
  IBEFLG, IYCFLG, IOSTAR, NOPT, NFIT, IAP : integer;
  SOSR, RMAR, RMARM : double;
begin
  with frmModflow do
  begin
    IBEFLG := comboBealeInput.ItemIndex;
    IYCFLG := comboYcintInput.ItemIndex;
    if cbParamEstScreenPrint.Checked then
    begin
      IOSTAR := 0;
    end
    else
    begin
      IOSTAR := 1;
    end;

    if cbParamEstRMatrix.Checked then
    begin
      NOPT := 1;
    end
    else
    begin
      NOPT := 0;
    end;

    if cbIAP.Checked then
    begin
      IAP := 1;
    end
    else
    begin
      IAP := 0;
    end;

    NFIT := StrToInt(adeParamEstRMatrixIterations.Text);

    SOSR := InternationalStrToFloat(adeParamEstRMatrixCriterion.Text);
    RMAR := InternationalStrToFloat(adeRMAR.Text);
    RMARM := InternationalStrToFloat(adeRMARM.Text);
  end;
  WriteLn(FFile, IBEFLG, ' ', IYCFLG, ' ', IOSTAR, ' ', NOPT, ' ', NFIT, ' ',
    FreeFormattedReal(SOSR),
    FreeFormattedReal(RMAR),
    FreeFormattedReal(RMARM),
    {Format(' %.13e %.13e %.13e ', [SOSR, RMAR, RMARM]),} IAP);
end;

procedure TParamEstWriter.WriteDataSet3;
var
  IPRCOV, IPRINT, LPRINT : integer;
begin
  with frmModflow do
  begin
    IPRCOV := comboParamEstVarPrintFormat.ItemIndex + 1;
    IPRINT := comboParamEstStatisticsPrint.ItemIndex;
    if cbParamEstEigenvectorPrint.Checked then
    begin
      LPRINT := 1;
    end
    else
    begin
      LPRINT := 0;
    end;
  end;
  WriteLn(FFile, IPRCOV, ' ', IPRINT, ' ', LPRINT);
end;

procedure TParamEstWriter.WriteDataSet4;
var
  CSA, FCONV : double;
  LASTX : integer;
begin
  with frmModflow do
  begin
    CSA := InternationalStrToFloat(adeParamEstSearchDirection.Text);
    FCONV := InternationalStrToFloat(adeParamEstCoarseConvCrit.Text);
    LASTX := comboLastx.ItemIndex;
  end;
  WriteLn(FFile,
    FreeFormattedReal(CSA),
    FreeFormattedReal(FCONV),
    {Format('%.13e %.13e ', [CSA, FCONV] ),} LASTX) ;
end;

procedure TParamEstWriter.WriteDataSet5;
var
  NPNG, MPR : integer;
begin
  NPNG := GetNPNG;
  with frmMODFLOW do
  begin
    IPR := dgParamEstCovNames.RowCount -1;
    MPR := dgPriorEquations.RowCount -1;
  end;
  WriteLn(FFile, NPNG, ' ', IPR, ' ', MPR);

end;

procedure TParamEstWriter.WriteDataSet6;
var
  Index : integer;
begin
  for Index := 0 to NegNames.Count -1 do
  begin
    WriteLn(FFile, NegNames[Index]);
  end;

end;

procedure TParamEstWriter.WriteDataSet7;
var
  Index : integer;
  PlotSymbol : integer;
  BPRI : double;
begin
  with frmModflow.dgParamEstCovNames do
  begin
    for Index := 1 to RowCount -1 do
    begin
      PlotSymbol := StrToInt(Cells[1,Index]);
      BPRI := InternationalStrToFloat(Cells[2,Index]);
      WriteLn(FFile, Cells[0,Index], ' ', BPRI, ' ', PlotSymbol);
    end;
  end;
end;

procedure TParamEstWriter.WriteDataSet9;
var
  RowIndex, ColIndex, Index : integer;
  WPF : double;
begin
  Index := 0;
  with frmModflow.dgParamEstCovariance do
  begin
    for RowIndex := 1 to RowCount -1 do
    begin
      for ColIndex := 1 to ColCount -1 do
      begin
        WPF := InternationalStrToFloat(Cells[ColIndex,RowIndex]);
//        Write(FFile, Format('%.10e ', [WPF]));
        Write(FFile, Format('%g ', [WPF]));
        Inc(Index);
        if Index = 6 then
        begin
          WriteLn(FFile);
          Index := 0;
        end;
      end;
      if (Index <> 0) then
      begin
        WriteLn(FFile);
        Index := 0;
      end;
    end;
  end;

end;

procedure TParamEstWriter.WriteDataSet10;
const
  kSTAT = 'STAT';
var
  Index : integer;
begin
  with frmModflow do
  begin
    for Index := 1 to dgPriorEquations.RowCount -1 do
    begin
      WriteLn(FFile, PriorEquation(Index));
    end;
  end;
end;

procedure TParamEstWriter.WriteFile(Root: string);
var
  FileName : string;
begin
  frmProgress.lblPackage.Caption := 'Parameter estimation';
  NegNames := TStringList.Create;
  try
    FileName := GetCurrentDir + '\' + Root + rsPes;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      WriteDataSet1;
      WriteDataSet2;
      WriteDataSet3;
      WriteDataSet4;
      WriteDataSet5;
      WriteDataSet6;
      WriteDataSet7;
      WriteDataSet8;
      WriteDataSet9;
      WriteDataSet10;
      Flush(FFile);
    finally
      CloseFile(FFile);
    end;
  finally
    NegNames.Free;
  end;

end;

procedure TParamEstWriter.WriteDataSet8;
var
  IWTP : integer;
begin
  if IPR > 0 then
  begin
    IWTP := frmMODFLOW.rgPriorInfoDataType.ItemIndex;
    WriteLn(FFile, IWTP);
  end;
end;

end.
