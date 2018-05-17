unit ExportProgressUnit;

interface

{This unit describes a progress bar that is used in a variety of situations.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ANEPIE;

type
  TfrmExportProgress = class(TForm)
    ProgressBar1: TProgressBar;
  private
    { Private declarations }
  public
    CurrentModelHandle : ANE_PTR;
    Procedure Moved (var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED;
    { Public declarations }
  end;

var
  frmExportProgress: TfrmExportProgress;

implementation

Uses ANECB;

{$R *.DFM}

{ TfrmExportProgress }

procedure TfrmExportProgress.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;

end;

end.
