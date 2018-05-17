unit ChooseLayers;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, RzLstBox, RzChkLst, AnePIE;

type
  TfrmChooseLayer = class(TForm)
    rzclLayerNames: TRzCheckList;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Procedure Moved (var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED;
    { Private declarations }
  public
    CurrentModelHandle : ANE_PTR;
    procedure GetLayers;
    { Public declarations }
  end;

var
  frmChooseLayer: TfrmChooseLayer;

implementation

uses ANECB, OptionsUnit, ANE_LayerUnit, FixNameUnit;

{$R *.DFM}

type
  TValueNamedLayerParam = class(T_ANE_NamedLayerParam)
  public
    function Value : string; override;
    function Units : string; virtual;
  end;

procedure TfrmChooseLayer.GetLayers;
var
  ProjectOptions : TProjectOptions;
begin
  ProjectOptions := TProjectOptions.Create;
  try
    ProjectOptions.LayerNames(CurrentModelHandle,
      [pieTriMeshLayer,pieQuadMeshLayer,pieInformationLayer,
      pieGridLayer,pieDomainLayer],rzclLayerNames.Items);
  finally
    ProjectOptions.Free;
  end;

end;

procedure TfrmChooseLayer.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

procedure TfrmChooseLayer.BitBtn1Click(Sender: TObject);
var
  Param : TValueNamedLayerParam;
  LayerHandle : ANE_PTR:
  Index : integer;
  ParamName : string;
var
  ProjectOptions : TProjectOptions;
begin
  if MessageDlg('The layers you have checked are about to be permanently '
    + 'deleted.  Are you sure you want to do this?', mtInformation,
    [mbYes, mbNo, mbCancel], 0) = mrYes then
  begin
    ProjectOptions := TProjectOptions.Create;
    try
      for Index := rzclLayerNames.Items.Count -1 downto 0 do
      begin
        if rzclLayerNames.ItemChecked[Index] then
        begin
          LayerHandle := ProjectOptions.GetLayerByIndex(CurrentModelHandle, Index);
          ANE_LayerRemove(CurrentModelHandle, LayerHandle, True);
        end;
      end;
    finally
      ProjectOptions.Free;
    end;

  end;

end;

procedure TfrmChooseLayer.FormCreate(Sender: TObject);
begin
  comboValueType.ItemIndex := 1;
end;

{ TValueNamedLayerParam }

function TValueNamedLayerParam.Units: string;
begin
  result := frmChooseLayer.edUnits.Text;
end;

function TValueNamedLayerParam.Value: string;
begin
  result := frmChooseLayer.edValue.Text;
end;

end.
