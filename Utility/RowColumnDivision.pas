unit RowColumnDivision;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, StdCtrls, Buttons, ArgusDataEntry;

type
  TfrmRowColumnDivision = class(TArgusForm)
    adeRowCount: TArgusDataEntry;
    adeColCount: TArgusDataEntry;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRowColumnDivision: TfrmRowColumnDivision;

implementation

{$R *.DFM}

end.

