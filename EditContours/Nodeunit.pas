unit NodeUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ArgusDataEntry;

type
  TfrmNodePosition = class(TForm)
    adeY: TArgusDataEntry;
    Label2: TLabel;
    adeX: TArgusDataEntry;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNodePosition: TfrmNodePosition;

implementation

uses {EditUnit,} UtilityFunctions, frmEditUnit;

{$R *.DFM}

procedure TfrmNodePosition.BitBtn1Click(Sender: TObject);
begin
  frmEditNew.CurrentPoint.X := InternationalStrToFloat(adeX.Text);
  frmEditNew.CurrentPoint.Y := InternationalStrToFloat(adeY.Text);
  frmEditNew.zbMain.GetMinMax;
//  frmEditContours.Paintbox1.Invalidate;
  frmEditNew.zbMain.Invalidate;

end;

end.
