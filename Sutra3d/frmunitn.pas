unit frmUnitN;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ArgusDataEntry;

type
  TfrmUnitNumber = class(TForm)
    adeN: TArgusDataEntry;
    Label1: TLabel;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    function N: string;
    { Public declarations }
  end;

var
  frmUnitNumber: TfrmUnitNumber;

implementation

{$R *.DFM}

function TfrmUnitNumber.N: string;
begin
  result := adeN.Text;
end;

end.
