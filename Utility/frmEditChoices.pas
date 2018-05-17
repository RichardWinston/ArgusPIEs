unit frmEditChoices;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfrmEdit = class(TForm)
    rgChoice: TRadioGroup;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    BitBtn1: TBitBtn;
    btnAbout: TButton;
    procedure rgChoiceClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEdit: TfrmEdit;

implementation

uses frmAboutUnit;

{$R *.DFM}

procedure TfrmEdit.rgChoiceClick(Sender: TObject);
begin
  btnOK.Enabled := True;
end;

procedure TfrmEdit.btnAboutClick(Sender: TObject);
begin
  inherited;
  ShowAbout;

end;

end.
