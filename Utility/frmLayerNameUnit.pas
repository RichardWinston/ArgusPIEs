unit frmLayerNameUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ArgusFormUnit;

type
  TfrmLayerName = class(TArgusForm)
    rgLayerType: TRadioGroup;
    comboLayerName: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    rgGridType: TRadioGroup;
    cbImportDemOutline: TCheckBox;
    BitBtn3: TBitBtn;
    procedure rgLayerTypeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLayerName: TfrmLayerName;

implementation

uses OptionsUnit, UtilityFunctions;


{$R *.DFM}

procedure TfrmLayerName.rgLayerTypeClick(Sender: TObject);
var
  Project : TProjectOptions;
begin
  inherited;
  rgLayerType.Enabled := not cbImportDemOutline.Checked;
  rgGridType.Enabled := (rgLayerType.ItemIndex = 0)
    and not cbImportDemOutline.Checked;

  Project := TProjectOptions.Create;
  try
    comboLayerName.Items.Clear;
    if cbImportDemOutline.Checked then
    begin
      Project.LayerNames(CurrentModelHandle,
        [pieMapsLayer],comboLayerName.Items);
    end
    else if rgLayerType.ItemIndex = 0 then
    begin
      Project.LayerNames(CurrentModelHandle,
        [pieGridLayer],comboLayerName.Items);
    end
    else
    begin
      Project.LayerNames(CurrentModelHandle,
        [pieTriMeshLayer,pieQuadMeshLayer],comboLayerName.Items);
    end;

    if comboLayerName.Items.Count > 0 then
    begin
      comboLayerName.ItemIndex := 0;
    end
    else
    begin
      comboLayerName.ItemIndex := -1;
    end;
  finally
    Project.Free;
  end;

end;

procedure TfrmLayerName.FormCreate(Sender: TObject);
var
  DllDirectory : string;
begin
  inherited;
  if GetDllDirectory(GetDLLName, DllDirectory) then
  begin
    Application.HelpFile := DllDirectory + '\Utility.chm';
  end;

end;

end.
