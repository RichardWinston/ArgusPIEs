unit frmDeleteLayerUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, AnePIE, CheckLst, IntListUnit;

type
  TfrmDeleteLayer = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    btnAbout: TButton;
    clbLayerNames: TCheckListBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FLayerIndicies: TIntegerList;
    procedure Moved(var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED;
    { Private declarations }
  public
    CurrentModelHandle: ANE_PTR;
    procedure GetLayers;
    { Public declarations }
  end;

var
  frmDeleteLayer: TfrmDeleteLayer;

implementation

uses ANECB, OptionsUnit, ANE_LayerUnit, FixNameUnit, frmAboutUnit;

{$R *.DFM}

procedure TfrmDeleteLayer.GetLayers;
var
  ProjectOptions: TProjectOptions;
  AllLayerNames: TStringList;
  Index: Integer;
begin
  ProjectOptions := TProjectOptions.Create;
  AllLayerNames := TStringList.Create;
  try
    ProjectOptions.LayerNames(CurrentModelHandle,
      [pieTriMeshLayer,pieQuadMeshLayer,pieInformationLayer,
      pieGridLayer,pieDataLayer,pieMapsLayer,pieDomainLayer,pieGroupLayer,
      pieAnyLayer], AllLayerNames);

    FLayerIndicies.Clear;
    for Index := 0 to AllLayerNames.Count - 1 do
    begin
      FLayerIndicies.Add(Index);
    end;

    ProjectOptions.LayerNames(CurrentModelHandle,
      [pieTriMeshLayer,pieQuadMeshLayer,pieInformationLayer, pieGridLayer,
      pieDataLayer,pieMapsLayer,pieGroupLayer], clbLayerNames.Items);

    for Index := 0 to clbLayerNames.Items.Count - 1 do
    begin
      While clbLayerNames.Items[Index] <> AllLayerNames[Index] do
      begin
        AllLayerNames.Delete(Index);
        FLayerIndicies.Delete(Index);
      end;
    end;
  finally
    ProjectOptions.Free;
    AllLayerNames.Free;
  end;

end;

procedure TfrmDeleteLayer.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

procedure TfrmDeleteLayer.BitBtn1Click(Sender: TObject);
var
  LayerHandle: ANE_PTR;
  Index: integer;
var
  ProjectOptions: TProjectOptions;
begin
  Beep;
  if MessageDlg('The layers you have checked are about to be permanently '
    + 'deleted even if they have been locked to prevent their being deleted.  '
    + 'Are you sure you want to do this?', mtWarning,
    [mbYes, mbNo, mbCancel], 0) = mrYes then
  begin
    ProjectOptions := TProjectOptions.Create;
    try
      for Index := clbLayerNames.Items.Count - 1 downto 0 do
      begin
        if clbLayerNames.Checked[Index] then
        begin
          LayerHandle := ProjectOptions.GetLayerByIndex(CurrentModelHandle,
            FLayerIndicies[Index]);
          Assert(LayerHandle <> nil);
          ANE_LayerRemove(CurrentModelHandle, LayerHandle, True);
          ANE_ProcessEvents(CurrentModelHandle);
        end;
      end;
    finally
      ProjectOptions.Free;
    end;
  end;
end;

procedure TfrmDeleteLayer.btnAboutClick(Sender: TObject);
begin
  inherited;
  ShowAbout;
end;

procedure TfrmDeleteLayer.FormCreate(Sender: TObject);
begin
  FLayerIndicies:= TIntegerList.Create;
end;

procedure TfrmDeleteLayer.FormDestroy(Sender: TObject);
begin
  FLayerIndicies.Free;
end;

end.

