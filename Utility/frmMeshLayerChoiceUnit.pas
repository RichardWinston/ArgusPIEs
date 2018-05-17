unit frmMeshLayerChoiceUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ArgusFormUnit, siComboBox, Buttons, OptionsUnit, AnePIE;

type
  TfrmMeshLayerChoice = class(TArgusForm)
    siComboFrom: TsiComboBox;
    siComboTo: TsiComboBox;
    Label1: TLabel;
    Label2: TLabel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    BitBtn1: TBitBtn;
    btnAbout: TButton;
    procedure btnAboutClick(Sender: TObject);
  private
    { Private declarations }
  public
    function GetMeshLayers(LayerType : TPIELayerType) : boolean;
    function GetTriMeshLayers : boolean;
    function GetQuadMeshLayers : boolean;
    procedure CopyMesh;
    { Public declarations }
  end;

var
  frmMeshLayerChoice: TfrmMeshLayerChoice;

procedure GCopyTriQuadMeshPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR; const IsTriMesh : boolean); cdecl;

implementation

uses frmAboutUnit;

{$R *.DFM}

{ TfrmMeshLayerChoice }

procedure TfrmMeshLayerChoice.CopyMesh;
var
  ToLayerOptions, FromLayerOptions : TLayerOptions;
begin
  ToLayerOptions := TLayerOptions.CreateWithName(siComboTo.Text, CurrentModelHandle);
  FromLayerOptions := TLayerOptions.CreateWithName(siComboFrom.Text, CurrentModelHandle);
  try
    ToLayerOptions.Text[CurrentModelHandle] := FromLayerOptions.Text[CurrentModelHandle];
  finally
    ToLayerOptions.Free(CurrentModelHandle);
    FromLayerOptions.Free(CurrentModelHandle);
  end;
end;

function TfrmMeshLayerChoice.GetMeshLayers(LayerType: TPIELayerType) : boolean;
var
  ProjectOptions : TProjectOptions;
  Index : integer;
  Width, temp : integer;
begin
  ProjectOptions := TProjectOptions.Create;
  try
    ProjectOptions.LayerNames(CurrentModelHandle, [LayerType],
      siComboFrom.Items);
    result := siComboFrom.Items.Count > 0;
    if result then
    begin
      siComboTo.Items := siComboFrom.Items;
      siComboFrom.ItemIndex := 0;
      siComboTo.ItemIndex := 0;
      Width := siComboFrom.Width;
      for Index := 0 to siComboFrom.Items.Count -1 do
      begin
        temp := Canvas.TextWidth(siComboFrom.Items[Index] + '  ');
        if temp > Width then
        begin
          Width:= Temp;
        end;
      end;
      siComboFrom.CWX := Width - siComboFrom.Width;
      siComboTo.CWX := siComboFrom.CWX;
    end;
  finally
    ProjectOptions.Free;
  end;
end;

function TfrmMeshLayerChoice.GetQuadMeshLayers : boolean;
begin
  result := GetMeshLayers(pieQuadMeshLayer);
end;

function TfrmMeshLayerChoice.GetTriMeshLayers : boolean;
begin
  result := GetMeshLayers(pieTriMeshLayer);
end;

procedure GCopyTriQuadMeshPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR; const IsTriMesh : boolean); cdecl;
var
  LayersValid : boolean;
begin
  Application.CreateForm(TfrmMeshLayerChoice, frmMeshLayerChoice);
  try
    frmMeshLayerChoice.CurrentModelHandle := aneHandle;
    if IsTriMesh then
    begin
      LayersValid := frmMeshLayerChoice.GetTriMeshLayers;
      frmMeshLayerChoice.Caption := 'Copy Tri Mesh';
    end
    else
    begin
      LayersValid := frmMeshLayerChoice.GetQuadMeshLayers;
      frmMeshLayerChoice.Caption := 'Copy Quad Mesh';
    end;
    if LayersValid then
    begin
      if frmMeshLayerChoice.ShowModal = mrOK then
      begin
        frmMeshLayerChoice.CopyMesh;
      end;
    end
    else
    begin
      Beep;
      MessageDlg('No layers of the appropriate type exist.',
        mtError, [mbOK], 0);
    end;
  finally
    frmMeshLayerChoice.Free;
  end;
end;


procedure TfrmMeshLayerChoice.btnAboutClick(Sender: TObject);
begin
  inherited;
  ShowAbout;

end;

end.
