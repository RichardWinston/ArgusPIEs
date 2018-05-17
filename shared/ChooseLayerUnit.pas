unit ChooseLayerUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin, Grids, ExtCtrls, ANEPIE, DataGrid, OptionsUnit;

type
  TfrmChooseLayer = class(TForm)
    Panel1: TPanel;
    lblChoose: TLabel;
    comboLayerNames: TComboBox;
    cbNewLayer: TCheckBox;
    Panel2: TPanel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    pnlNewLayer: TPanel;
    seParamCount: TSpinEdit;
    lblParamCount: TLabel;
    dgParameters: TDataGrid;
    procedure seParamCountChange(Sender: TObject);
    procedure cbNewLayerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    ModelHandle : ANE_PTR;
    function GetExistingLayer(CurrentModelHandle: ANE_PTR;
      LayerTypes : TPIELayerTypes) : ANE_PTR;
    function GetExistingLayerWithContours(CurrentModelHandle: ANE_PTR;
      LayerTypes : TPIELayerTypes) : ANE_PTR;

    { Public declarations }
  end;

function GetExistingLayer(CurrentModelHandle: ANE_PTR;
  LayerTypes: TPIELayerTypes): ANE_PTR;

function GetExistingLayerWithContours(CurrentModelHandle: ANE_PTR;
  LayerTypes: TPIELayerTypes): ANE_PTR;

var
  frmChooseLayer: TfrmChooseLayer;

implementation

{$R *.DFM}

uses ANECB;

procedure TfrmChooseLayer.seParamCountChange(Sender: TObject);
var
  OldRowCount : integer;
  RowIndex : integer;
begin
  OldRowCount := dgParameters.RowCount;
  dgParameters.RowCount :=  seParamCount.Value + 1;
  for RowIndex := OldRowCount to dgParameters.RowCount -1 do
  begin
    dgParameters.Cells[1,RowIndex] := dgParameters.Columns[1].Picklist[0];
    if dgParameters.Cells[0,RowIndex] = '' then
    begin
      dgParameters.Cells[0,RowIndex] := 'Parameter' + IntToStr(RowIndex);
    end;
  end;
end;

procedure TfrmChooseLayer.cbNewLayerClick(Sender: TObject);
begin
  if cbNewLayer.Checked then
  begin
    comboLayerNames.Style := csDropDown;
    comboLayerNames.Text := '';
    ClientHeight := Panel1.Height + Panel2.Height + pnlNewLayer.Height;
    pnlNewLayer.Visible := True;
  end
  else
  begin
    pnlNewLayer.Visible := False;
    ClientHeight := Panel1.Height + Panel2.Height;
    comboLayerNames.Style := csDropDownList;
    if comboLayerNames.Items.Count > 0 then
    begin
      comboLayerNames.ItemIndex := 0;
    end;
  end;
  ANE_ProcessEvents(ModelHandle);
end;

procedure TfrmChooseLayer.FormCreate(Sender: TObject);
begin
  ClientHeight := Panel1.Height + Panel2.Height;
  dgParameters.Cells[1,1] := dgParameters.Columns[1].Picklist[0];
  dgParameters.Cells[0,1] := 'Parameter1';
end;

procedure TfrmChooseLayer.BitBtn1Click(Sender: TObject);
var
  Index : integer;
begin
  if comboLayerNames.Text = '' then
  begin
    ModalResult := mrNone;
    comboLayerNames.SetFocus;
    Beep;
    MessageDlg('You need to enter the name of a layer.', mtError, [mbOK], 0);
    Exit;
  end;
  if cbNewLayer.Checked then
  begin
    for Index := 1 to dgParameters.RowCount -1 do
    begin
      if dgParameters.Cells[0,Index] = '' then
      begin
        ModalResult := mrNone;
        dgParameters.SetFocus;
        Beep;
        MessageDlg('You need to enter a name for each parameter.', mtError, [mbOK], 0);
        Exit;
      end;

    end;

  end;

end;

function TfrmChooseLayer.GetExistingLayer(CurrentModelHandle: ANE_PTR;
  LayerTypes: TPIELayerTypes): ANE_PTR;
var
  LayerNames : TStringList;
  Project : TProjectOptions;
begin
  result := nil;
  ModelHandle := CurrentModelHandle;
  cbNewLayer.Enabled := False;
  LayerNames := TStringList.Create;
  Project := TProjectOptions.Create;
  try
    Project.LayerNames(ModelHandle, LayerTypes, LayerNames);
    comboLayerNames.Items := LayerNames;
    if LayerNames.Count > 0 then
    begin
      comboLayerNames.ItemIndex := 0;
      if LayerNames.Count = 1 then
      begin
        result := Project.GetLayerByName
          (CurrentModelHandle,frmChooseLayer.comboLayerNames.Text);
        Exit;
      end;
    end
    else
    begin
      Exit;
    end;
    lblChoose.Caption := 'Choose an existing '
      + LayerTypesToString(LayerTypes)
      + '.';
    lblChoose.Width := Panel1.Width - 19;
    if (ShowModal = mrOK)
      and (comboLayerNames.Text <> '') then
    begin
      result := Project.GetLayerByName
        (CurrentModelHandle,frmChooseLayer.comboLayerNames.Text);
    end;

  finally
    LayerNames.Free;
    Project.Free;
  end;

end;

function GetExistingLayer(CurrentModelHandle: ANE_PTR;
  LayerTypes: TPIELayerTypes): ANE_PTR;
begin
  Application.CreateForm(TfrmChooseLayer, frmChooseLayer);
  try
//    frmChooseLayer.lblChoose.Caption := 'Choose a layer.';
    result := frmChooseLayer.GetExistingLayer(CurrentModelHandle, LayerTypes);
  finally
    frmChooseLayer.Free;
  end;

end;

function GetExistingLayerWithContours(CurrentModelHandle: ANE_PTR;
  LayerTypes: TPIELayerTypes): ANE_PTR;
begin
  Application.CreateForm(TfrmChooseLayer, frmChooseLayer);
  try
    result := frmChooseLayer.GetExistingLayerWithContours(
      CurrentModelHandle, LayerTypes);
  finally
    frmChooseLayer.Free;
  end;

end;

function TfrmChooseLayer.GetExistingLayerWithContours(
  CurrentModelHandle: ANE_PTR; LayerTypes: TPIELayerTypes): ANE_PTR;
var
  LayerNames : TStringList;
  Project : TProjectOptions;
  Index : integer;
  Layer : TLayerOptions;
begin
  result := nil;
  lblChoose.Caption := 'Name of layer containing contours.';
  lblChoose.Width := Panel1.Width - (2 * lblChoose.Left);
  ModelHandle := CurrentModelHandle;
  cbNewLayer.Visible := False;
  LayerNames := TStringList.Create;
  Project := TProjectOptions.Create;
  try
    Project.LayerNames(ModelHandle, LayerTypes, LayerNames);
    comboLayerNames.Items := LayerNames;
    for Index := comboLayerNames.Items.Count -1 downto 0 do
    begin
      Layer := TLayerOptions.CreateWithName(comboLayerNames.Items[Index], CurrentModelHandle);
      try
        if Layer.NumObjects(CurrentModelHandle, pieContourObject) <= 0 then
        begin
          comboLayerNames.Items.Delete(Index);
        end;
      finally
        Layer.Free(CurrentModelHandle);
      end;
    end;
    if comboLayerNames.Items.Count > 0 then
    begin
      comboLayerNames.ItemIndex := 0;
    end
    else
    begin
      Beep;
      MessageDlg('To perform this command, you must have an '
        + 'Information layer or Domain Outline layer that has contours.',
        mtWarning, [mbOK], 0);
      Exit;
    end;
    if (frmChooseLayer.ShowModal = mrOK)
      and (frmChooseLayer.comboLayerNames.Text <> '') then
    begin
      result := Project.GetLayerByName(CurrentModelHandle,frmChooseLayer.comboLayerNames.Text);
    end;

  finally
    LayerNames.Free;
    Project.Free;
  end;

end;

end.
