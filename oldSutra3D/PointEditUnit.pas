unit PointEditUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ArgusDataEntry;

type
  TfrmPointEdit = class(TForm)
    adeX: TArgusDataEntry;
    adeY: TArgusDataEntry;
    adeZ: TArgusDataEntry;
    lblX: TLabel;
    lblY: TLabel;
    lblZ: TLabel;
    btCancel: TBitBtn;
    btnOK: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPointEdit: TfrmPointEdit;

implementation

{$R *.DFM}

end.
