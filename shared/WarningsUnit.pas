unit WarningsUnit;

interface

{WarningsUnit defines a form used to display a warning to the user when a layer
 or parameter name has been changed.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, clipbrd, AnePIE;

type
  TfrmWarnings = class(TForm)
    memoWarnings: TMemo;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    btnCopy: TButton;
    Label2: TLabel;
    procedure btnCopyClick(Sender: TObject); virtual;
  private
    { Private declarations }
  public
    CurrentModelHandle : ANE_PTR;
    Procedure Moved (var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED;
    { Public declarations }
  end;


implementation

{$R *.DFM}

uses ANECB;

procedure TfrmWarnings.btnCopyClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(memoWarnings.Lines.Text));
end;

procedure TfrmWarnings.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

end.
