unit frmGetLayerNamesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ArgusFormUnit, ArgusDataEntry, addbtn95;

type
  TfrmGetLayerNames = class(TArgusForm)
    comboDomainOutline: TComboBox;
    Label1: TLabel;
    comboDensity: TComboBox;
    Label2: TLabel;
    btnOK: TBitBtn;
    btCancel: TBitBtn;
    cbBlockCenteredGrid: TCheckBox95;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    procedure GetData;
    { Public declarations }
  end;

var
  frmGetLayerNames: TfrmGetLayerNames;

implementation

uses OptionsUnit;

{$R *.DFM}

{ TfrmGetLayerNames }

procedure TfrmGetLayerNames.GetData;
var
  Project : TProjectOptions;
begin
  Project := TProjectOptions.Create;
  try
    Project.LayerNames(CurrentModelHandle, [pieDomainLayer],
      comboDomainOutline.Items);
    Project.LayerNames(CurrentModelHandle, [pieInformationLayer],
      comboDensity.Items);
    if comboDomainOutline.Items.Count > 0 then
    begin
      comboDomainOutline.ItemIndex := 0;
    end;
    if comboDensity.Items.Count > 0 then
    begin
      comboDensity.ItemIndex := 0;
    end;
  finally
    Project.Free;
  end;

end;

end.
