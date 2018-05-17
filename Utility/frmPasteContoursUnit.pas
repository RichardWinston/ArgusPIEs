unit frmPasteContoursUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ArgusFormUnit, Clipbrd, CheckLst, AnePIE;

type
  TfrmPasteContours = class(TArgusForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    btnAbout: TButton;
    clbLayerNames: TCheckListBox;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure GetLayers;
    { Public declarations }
  end;

procedure GPasteToMultipleLayers(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;

var
  frmPasteContours: TfrmPasteContours;

implementation

uses OptionsUnit;

{$R *.DFM}

procedure TfrmPasteContours.GetLayers;
var
  ProjectOptions : TProjectOptions;
begin
  ProjectOptions := TProjectOptions.Create;
  try
    ProjectOptions.LayerNames(CurrentModelHandle,
      [pieInformationLayer,pieMapsLayer,pieDomainLayer],clbLayerNames.Items);
  finally
    ProjectOptions.Free;
  end;
end;


procedure TfrmPasteContours.BitBtn1Click(Sender: TObject);
var
  ContourString : string;
  Index : integer;
  ProjectOptions : TProjectOptions;
  ALayer  : TLayerOptions;
  LayerHandle : ANE_PTR;
  Position : integer;
begin
  ContourString := Clipboard.AsText;
  Position := Pos(#13, ContourString);
  While Position > 0 do
  begin
    Delete(ContourString, Position, 1);
    Position := Pos(#13, ContourString);
  end;
  ProjectOptions := TProjectOptions.Create;
  try
    for Index := 0 to clbLayerNames.Items.Count -1 do
    begin
      if clbLayerNames.Checked[Index] then
      begin
        LayerHandle := ProjectOptions.GetLayerByName
          (CurrentModelHandle,clbLayerNames.Items[Index]);
        ALayer := TLayerOptions.Create(LayerHandle);
        try
          ALayer.SetText(CurrentModelHandle, ContourString);
        finally
          ALayer.Free(CurrentModelHandle);
        end;
      end;
    end;
  finally
    ProjectOptions.Free;
  end;
end;

procedure GPasteToMultipleLayers(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
begin
  Application.CreateForm(TfrmPasteContours, frmPasteContours);
  try
    frmPasteContours.CurrentModelHandle := aneHandle;
    frmPasteContours.GetLayers;
    frmPasteContours.ShowModal;
  finally
    frmPasteContours.Free;
  end;
end;

end.
