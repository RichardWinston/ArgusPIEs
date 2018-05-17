unit WarningsUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, clipbrd;

type
  TfrmWarnings = class(TForm)
    memoWarnings: TMemo;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    btnCopy: TButton;
    procedure btnCopyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

procedure TfrmWarnings.btnCopyClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(memoWarnings.Lines.Text));
end;

end.
