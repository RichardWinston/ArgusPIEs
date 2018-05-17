unit frmStreamJoinDistanceUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ArgusDataEntry, Buttons;

type
  TfrmStreamJoinDistance = class(TForm)
    adeDistance: TArgusDataEntry;
    Label1: TLabel;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStreamJoinDistance: TfrmStreamJoinDistance;

implementation

{$R *.DFM}

end.
