unit frmTimerUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls;

type
  TfrmTimer = class(TForm)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTimer: TfrmTimer;

implementation

uses functionUnit;

{$R *.DFM}

procedure TfrmTimer.Timer1Timer(Sender: TObject);
begin
  Inc(Counter);
  if RenameFile(FirstFilePath, SecondFilePath) then
  begin
    Counter := 1000;
  end;
end;

end.
