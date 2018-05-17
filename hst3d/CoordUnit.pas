unit CoordUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TCoordForm = class(TForm)
    rgCoord: TRadioGroup;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure rgCoordClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CoordForm: TCoordForm;

implementation

uses HST3DUnit, HST3D_PIE_Unit;

{$R *.DFM}

procedure TCoordForm.BitBtn1Click(Sender: TObject);
begin
  with PIE_Data do
  begin
    HST3DForm.rgCoord.ItemIndex := rgCoord.ItemIndex;
//    HST3DForm.rgUnits.ItemIndex := rgUnits.ItemIndex;
    inherited;
  end;
end;

procedure TCoordForm.rgCoordClick(Sender: TObject);
begin
  if rgCoord.ItemIndex = 1 then
  begin
    rgCoord.ItemIndex := 0;
    ShowMessage('Sorry, cylindrical coordinates aren''t supported yet.');
  end;  
end;

end.
