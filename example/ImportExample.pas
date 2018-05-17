unit ImportExample;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, AnePIE;

type
  TfrmImportExample = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    btnOK: TBitBtn; // The "ModalResult" property of btnOK is mrOK so when
      // btnOK is clicked, the form closes and the "ModalResult" property of
      // the form becomes mrOK.
    btnCancel: TBitBtn;
    Label1: TLabel;
  protected
    // Keep Argus ONE looking pretty when the form is moved.
    Procedure Moved (var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED;
  private
    { Private declarations }
  public
    CurrentModelHandle : ANE_PTR;
    { Public declarations }
  end;

implementation

uses ANECB;

{$R *.DFM}

{ TfrmImportExample }

procedure TfrmImportExample.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  // Keep Argus ONE looking pretty when the form is moved.
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

end.
