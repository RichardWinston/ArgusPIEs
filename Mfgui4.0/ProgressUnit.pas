unit ProgressUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TfrmProgress = class(TForm)
    pbOverall: TProgressBar;
    pbPackage: TProgressBar;
    pbActivity: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    BitBtn1: TBitBtn;
    lblPackage: TLabel;
    lblActivity: TLabel;
    sbProgress: TStatusBar;
    Timer1: TTimer;
    reErrors: TRichEdit;
    Label6: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FStartTime : TDateTime;
    { Private declarations }
  public
    procedure TestDuplicateObservationNames;
    { Public declarations }
  end;


var
  ContinueExport : Boolean = True;
  ErrorMessages : TStringList;
  ShowWarnings : boolean = False;

function frmProgress: TfrmProgress;
Procedure FreefrmProgress;
procedure AddObservationName(const AName: string);
procedure ClearObservationNames;

implementation

{$R *.DFM}
var
  FfrmProgress: TfrmProgress;
  ObservationNames: TStringList;
  ObservationDuplicates: TStringList;

procedure ClearObservationNames;
begin
  ObservationNames.Clear;
end;

procedure AddObservationName(const AName: string);
begin
  if ObservationNames.IndexOf(AName) < 0 then
  begin
    ObservationNames.Add(AName);
  end
  else
  begin
    if ObservationDuplicates.IndexOf(AName) < 0 then
    begin
      ObservationDuplicates.Add(AName);
    end;
  end;
end;

function frmProgress: TfrmProgress;
begin
  if FfrmProgress = nil then
  begin
    Application.CreateForm(TfrmProgress,FfrmProgress);
  end;
  result := FfrmProgress;
end;

procedure TfrmProgress.BitBtn1Click(Sender: TObject);
begin
  ContinueExport := False;
end;

procedure TfrmProgress.Timer1Timer(Sender: TObject);
var
  CurrentTime : TDateTime;
  ElapsedTime : TDateTime;
  TimeRemaining : TDateTime;
  Fraction : double;
  ElapsedTimeString : string;
  TimeRemainingString : string;
  ActivityMax, PackageMax, OverallMax : integer;
  ActivityPosition, PackagePosition, OverallPosition : integer;
  function TimeString(ATime: TDateTime) : String;
  begin
    result := FormatDateTime('hh:mm:ss', ATime);
{    if Pos('12', result) = 1 then
    begin
      result[1] := '0';
      result[2] := '0';
    end; }
  end;
begin
  Try
    CurrentTime := Now;
    ElapsedTime := CurrentTime - FStartTime;
    ElapsedTimeString := TimeString(ElapsedTime);
    sbProgress.Panels[0].Text := 'Elapsed time: ' + ElapsedTimeString;
    ActivityMax := pbActivity.Max;
    PackageMax :=  pbPackage.Max;
    OverallMax :=  pbOverall.Max;
    if (ActivityMax = 0) or (PackageMax = 0) or (OverallMax = 0) then
    begin
      sbProgress.Panels[1].Text := 'Estimated time remaining: Unknown';
    end
    else
    begin
      ActivityPosition := pbActivity.Position;
      PackagePosition := pbPackage.Position;
      OverallPosition := pbOverall.Position;
      Fraction := OverallPosition/OverallMax +
        PackagePosition/PackageMax/OverallMax +
        ActivityPosition/ActivityMax/PackageMax/OverallMax;
      If (Fraction = 0) then
      begin
        sbProgress.Panels[1].Text := 'Estimated time remaining: Unknown';
      end
      else
      begin
        TimeRemaining := ElapsedTime * (1/Fraction -1);
        TimeRemainingString := TimeString(TimeRemaining);
        sbProgress.Panels[1].Text := 'Estimated time remaining: '
          + TimeRemainingString;
      end;
    end;
  Except on EZeroDivide do
    begin
      sbProgress.Panels[1].Text := 'Estimated time remaining: Unknown';
    end;
  end;

end;

procedure TfrmProgress.FormCreate(Sender: TObject);
begin
  FStartTime := Now;
end;

Procedure FreefrmProgress;
begin
  FfrmProgress.Free;
  FfrmProgress := nil;
end;

procedure TfrmProgress.TestDuplicateObservationNames;
var
  ErrorString: string;
begin
  if ObservationDuplicates.Count > 0 then
  begin
    ErrorMessages.Add('');

    ErrorString := 'Warning: one or more observation names are duplicates '
      + 'of other observation names.';
    ErrorMessages.Add(ErrorString);
    reErrors.Lines.Add(ErrorString);

    ErrorMessages.AddStrings(ObservationDuplicates);
  end;

end;

initialization
  ErrorMessages := TStringList.Create;
  ObservationNames := TStringList.Create;
  ObservationDuplicates := TStringList.Create;
  ObservationNames.Sorted := true;
  ObservationNames.Duplicates := dupError;

finalization
  FfrmProgress.Free;
  ErrorMessages.Free;
  ObservationNames.Free;
  ObservationDuplicates.Free;

end.
