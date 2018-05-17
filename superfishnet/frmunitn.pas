unit frmUnitN;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ArgusDataEntry;

type
  TfrmUnitNumber = class(TForm)
    adeN: TArgusDataEntry;
    Label1: TLabel;
    rgN: TRadioGroup;
    BitBtn1: TBitBtn;
    lblHigh: TLabel;
    procedure rgNClick(Sender: TObject);
  private
    { Private declarations }
  public
    function N(var MultipleUnits : Boolean): string;
    { Public declarations }
  end;

var
  frmUnitNumber: TfrmUnitNumber;

implementation

{$R *.DFM}

function TfrmUnitNumber.N(var MultipleUnits : Boolean): string;
begin
  if rgN.ItemIndex = 0 then
  begin
    result := '';
  end
  else
  begin
    result := adeN.Text;
  end;
  MultipleUnits := rgN.ItemIndex = 2;
end;

procedure TfrmUnitNumber.rgNClick(Sender: TObject);
begin
  adeN.Enabled := rgN.ItemIndex <> 0;
  lblHigh.Visible := rgN.ItemIndex = 2;
end;

end.
