unit WellMt3dData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WellDataUnit, StdCtrls, ExtCtrls, ArgusDataEntry, Buttons, Grids;

type
  TfrmMT3DWellData = class(TfrmWellData)
    procedure FormCreate(Sender: TObject); override;
    procedure adeStressPeriodCountExit(Sender: TObject); override;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMT3DWellData: TfrmMT3DWellData;

implementation

uses Variables;

{$R *.DFM}

procedure TfrmMT3DWellData.FormCreate(Sender: TObject);
begin
  inherited;
  if frmModflow.cbMT3D.Checked then
  begin
    HeadersStringList.Add(ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName);
  end;
  WriteWellHeaders;
  SetColumnWidths;
//  Constraints.MinWidth := Width;
//  adeUnit.Max := StrToInt(frmModflow.edNumUnits.Text);

end;

procedure TfrmMT3DWellData.adeStressPeriodCountExit(Sender: TObject);
var
  Count : integer;
  UnitOffset : integer;
begin
  Count := 1;
  if frmModflow.cbMOC3D.Checked then
  begin
    Inc(Count);
  end;
  if frmModflow.cbMODPATH.Checked then
  begin
    Inc(Count);
  end;
  if frmModflow.cbMT3D.Checked then
  begin
    Inc(Count);
  end;
  UnitOffset := 0;
  if cbMultUnits.Checked then
  begin
    UnitOffset := 1;
  end;
  sgWellData.ColCount := StrToInt(frmModflow.edNumPer.Text)*Count + 5
    + UnitOffset;
  WriteWellHeaders;
  SetColumnWidths;
end;

end.
