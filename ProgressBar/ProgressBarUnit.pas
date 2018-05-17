unit ProgressBarUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons;

type
  TProgressBarForm = class(TForm)
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    lblMessage: TLabel;
    StatusBar1: TStatusBar;
    RichEdit1: TRichEdit;
    Panel2: TPanel;
    btnAbort: TBitBtn;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    ContinueSimulation : boolean;
    function SetTime: boolean;
    { Public declarations }
  end;

var
  ProgressBarForm: TProgressBarForm;
  StartTime : TDateTime;

implementation

{$R *.DFM}

procedure TProgressBarForm.FormCreate(Sender: TObject);
var
  localtop : integer;
begin
  ContinueSimulation := True;
  Panel2.Visible := False;
  Left := (Screen.Width-Width) div 2;
  localtop := (Screen.Height-Height) div 2 - 220;
  if localtop > 0
  then
    begin
      Top := localtop;
    end
  else
    begin
      Top := Screen.Height div 2;
    end;

  StartTime := Now;
end;

procedure TProgressBarForm.btnAbortClick(Sender: TObject);
begin
  lblMessage.Caption := 'Attempting to abort simulation.';
  ContinueSimulation := False;
end;

function TProgressBarForm.SetTime: boolean;
var
  ElapsedTime : TDateTime;
  RemainingTime : TDateTime;
begin
  ElapsedTime := Now - StartTime;
  StatusBar1.Panels[0].Text := 'Elapsed Time: ' +
     FormatDateTime('hh:nn:ss',ElapsedTime);
  if (ElapsedTime <> 0) and (ProgressBar1.Position <> 0) then
  begin
    RemainingTime := ((ProgressBar1.Max - ProgressBar1.Position)
                         /ProgressBar1.Position)*ElapsedTime;

    StatusBar1.Panels[1].Text := 'Estimated Time Remaining: ' +
       FormatDateTime('hh:nn:ss',RemainingTime);
  end;
  result := ContinueSimulation;
end;

procedure TProgressBarForm.Timer1Timer(Sender: TObject);
begin
  SetTime;
end;

end.
