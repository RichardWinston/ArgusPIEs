unit frmDeleteLayerUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, RzLstBox, RzChkLst, AnePIE;

type
  TfrmDeleteLayer = class(TForm)
    rzclLayerNames: TRzCheckList;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
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
  frmDeleteLayer: TfrmDeleteLayer;

implementation

uses ANECB, OptionsUnit, ANE_LayerUnit, FixNameUnit;

{$R *.DFM}


procedure TfrmDeleteLayer.GetLayers;
var
  ProjectOptions : TProjectOptions;
begin
  ProjectOptions := TProjectOptions.Create;
  try
    ProjectOptions.LayerNames(CurrentModelHandle,
      [pieAnyLayer],rzclLayerNames.Items);
  finally
    ProjectOptions.Free;
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
  LayerHandle : ANE_PTR;
  Index : integer;
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

end.
