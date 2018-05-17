unit frmMultValueUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ArgusDataEntry;

type
  TfrmMultValue = class(TForm)
    adeValue: TArgusDataEntry;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMultValue: TfrmMultValue;

implementation

{$R *.DFM}

end.
