unit SetRowColumnConstantWidths;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, StdCtrls, Buttons, ArgusDataEntry;

type
  TfrmSetRowColumnConstantWidths = class(TArgusForm)
    adeRowOrColumn: TArgusDataEntry;
    lblRowOrColumn: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSetRowColumnConstantWidths: TfrmSetRowColumnConstantWidths;

implementation

{$R *.DFM}

end.
