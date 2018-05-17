unit ChooseLayerUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin, Grids, ExtCtrls, ANEPIE, DataGrid;

type
  TfrmChooseLayer = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
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
    { Public declarations }
  end;

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
end;

procedure TfrmChooseLayer.BitBtn1Click(Sender: TObject);
begin
  if comboLayerNames.Text = '' then
  begin
    ModalResult := mrNone;
    comboLayerNames.SetFocus;
    Beep;
    MessageDlg('You need to enter the name of a layer', mtError, [mbOK], 0);
  end;
end;

end.
