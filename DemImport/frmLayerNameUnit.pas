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
    procedure rgLayerTypeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLayerName: TfrmLayerName;

implementation

uses OptionsUnit;


{$R *.DFM}

procedure TfrmLayerName.rgLayerTypeClick(Sender: TObject);
var
  Project : TProjectOptions;
begin
  inherited;
  rgGridType.Enabled := rgLayerType.ItemIndex = 0;
  
  Project := TProjectOptions.Create;
  try
    comboLayerName.Items.Clear;
    if rgLayerType.ItemIndex = 0 then
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

end.
