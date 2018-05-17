unit frmConvertChoicesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfrmConvertChoices = class(TForm)
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
  frmConvertChoices: TfrmConvertChoices;

implementation

uses frmAboutUnit;

{$R *.DFM}

procedure TfrmConvertChoices.rgChoiceClick(Sender: TObject);
begin
  btnOK.Enabled := True;
end;

procedure TfrmConvertChoices.btnAboutClick(Sender: TObject);
begin
  inherited;
  ShowAbout;

end;

end.
