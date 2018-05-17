unit frmCorrelationUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, StdCtrls, siComboBox, Buttons, Grids, TeeProcs, TeEngine,
  Chart, ComCtrls, ExtCtrls, Series, AnePIE, Clipbrd;

type
  TfrmCorrelation = class(TArgusForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    tabChart: TTabSheet;
    tabValues: TTabSheet;
    chartData: TChart;
    sgValues: TStringGrid;
    BitBtn1: TBitBtn;
    comboNames: TsiComboBox;
    Label1: TLabel;
    Label2: TLabel;
    comboX: TsiComboBox;
    Label3: TLabel;
    ComboY: TsiComboBox;
    btnPlot: TButton;
    Values: TPointSeries;
    btnCopyValues: TButton;
    procedure comboNamesChange(Sender: TObject);
    procedure comboXChange(Sender: TObject);
    procedure btnPlotClick(Sender: TObject);
    procedure btnCopyValuesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure FormResize(Sender: TObject);
  private
    procedure GetLayers;
    procedure EvaluateCWX(const Combo: TsiComboBox);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCorrelation: TfrmCorrelation;

procedure ShowCorrelation (aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;

implementation

uses OptionsUnit;

{$R *.DFM}

{ TfrmCorrelation }

procedure TfrmCorrelation.EvaluateCWX(const Combo: TsiComboBox);
var
  Width, TestWidth: integer;
  Index: integer;
begin
  Width := 0;
  for Index := 0 to Combo.Items.Count -1 do
  begin
    TestWidth := Canvas.TextWidth(Combo.Items[Index]);
    if TestWidth > Width then
    begin
      Width := TestWidth;
    end;
  end;
  Width := Width + 10;
  if Width > Combo.Width then
  begin
    Combo.CWX := Width - Combo.Width;
  end
  else
  begin
    Combo.CWX := 0;
  end;
end;

procedure TfrmCorrelation.GetLayers;
var
  ProjectOptions: TProjectOptions;
  Names: TStringList;
begin
  ProjectOptions := TProjectOptions.Create;
  Names := TStringList.Create;
  try
    ProjectOptions.LayerNames(CurrentModelHandle, [pieInformationLayer], Names);
    comboNames.Items := Names;
    comboNames.ItemIndex := -1;
    EvaluateCWX(comboNames);
  finally
    ProjectOptions.Free;
    Names.Free;
  end;

end;

procedure TfrmCorrelation.comboNamesChange(Sender: TObject);
var
  Layer: TLayerOptions;
  Names: TStringList;
  Index: ANE_INT32;
  Parameter: TParameterOptions;
begin
  Values.Clear;
  Layer := TLayerOptions.CreateWithName(comboNames.Items[comboNames.ItemIndex],
    CurrentModelHandle);
  Names:= TStringList.Create;
  try
    Layer.GetParameterNames(CurrentModelHandle, Names);
    for Index := Names.Count -1 downto 0 do
    begin
      Parameter := TParameterOptions.Create(Layer.LayerHandle, Index);
      try
        if Parameter.NumberType[CurrentModelHandle] <> pnFloat then
        begin
          Names.Delete(Index);
        end;
      finally
        Parameter.Free;
      end;
    end;

    ComboX.Items := Names;
    ComboY.Items := Names;
    ComboX.Enabled := Names.Count >= 2;
    ComboY.Enabled := ComboX.Enabled;
    ComboX.ItemIndex := -1;
    ComboY.ItemIndex := -1;
    btnPlot.Enabled := False;
    EvaluateCWX(ComboX);
    ComboY.CWX := ComboX.CWX;
  finally
    Layer.Free(CurrentModelHandle);
    Names.Free;
  end;

end;

procedure TfrmCorrelation.comboXChange(Sender: TObject);
begin
  Values.Clear;
  btnPlot.Enabled := (comboNames.ItemIndex >= 0) and (comboX.ItemIndex >= 0)
    and (comboY.ItemIndex >= 0) and (comboX.ItemIndex <> comboY.ItemIndex);
  btnCopyValues.Enabled := btnPlot.Enabled;
end;

procedure TfrmCorrelation.btnPlotClick(Sender: TObject);
var
  ContourIndex: ANE_INT32;
  Layer: TLayerOptions;
  XIndex: ANE_INT32;
  YIndex: ANE_INT32;
  Contour: TContourObjectOptions;
  X, Y: ANE_DOUBLE;
  Name: string;
begin
  Layer := TLayerOptions.CreateWithName(comboNames.Items[comboNames.ItemIndex],
    CurrentModelHandle);
  try
    Name := comboX.Items[comboX.ItemIndex];
    XIndex := Layer.GetParameterIndex(CurrentModelHandle, Name);
    sgValues.Cells[1,0] := Name;
    chartData.BottomAxis.Title.Caption := Name;

    Name := comboY.Items[comboY.ItemIndex];
    YIndex := Layer.GetParameterIndex(CurrentModelHandle, Name);
    sgValues.Cells[2,0] := Name;
    chartData.LeftAxis.Title.Caption := Name;

    sgValues.RowCount := Layer.NumObjects(CurrentModelHandle,
      pieContourObject) + 1;
      
    for ContourIndex := 0 to
      Layer.NumObjects(CurrentModelHandle, pieContourObject) -1 do
    begin
      Contour := TContourObjectOptions.Create(CurrentModelHandle,
        Layer.LayerHandle, ContourIndex);
      try
        X := Contour.GetFloatParameter(CurrentModelHandle, XIndex);
        Y := Contour.GetFloatParameter(CurrentModelHandle, YIndex);
        Values.AddXY(X, Y);
        sgValues.Cells[0,ContourIndex+1] := IntToStr(ContourIndex+1);
        sgValues.Cells[1,ContourIndex+1] := FloatToStr(X);
        sgValues.Cells[2,ContourIndex+1] := FloatToStr(Y);
      finally
        Contour.Free;
      end;
    end;
  finally
    Layer.Free(CurrentModelHandle);
  end;
end;

procedure ShowCorrelation (aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
begin
  Application.CreateForm(TfrmCorrelation, frmCorrelation);
  try
    frmCorrelation.CurrentModelHandle := aneHandle;
    frmCorrelation.GetLayers;
    frmCorrelation.ShowModal;
  finally
    frmCorrelation.Free;
  end;
end;

procedure TfrmCorrelation.btnCopyValuesClick(Sender: TObject);
var
  Text: TStringList;
  Index: integer;
begin
  Text := TStringList.Create;
  try
    Text.Capacity := sgValues.RowCount -1;
    for Index := 0 to sgValues.RowCount -1 do
    begin
      Text.Add(sgValues.Cells[1,Index] + #9 + sgValues.Cells[2,Index]);
    end;
    ClipBoard.AsText := Text.Text;
  finally
    Text.Free;
  end;
  ShowMessage('The data have been copied to the clipboard.');
end;

procedure TfrmCorrelation.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmCorrelation.FormResize(Sender: TObject);
begin
  inherited;
  EvaluateCWX(comboNames);
  EvaluateCWX(comboX);
  ComboY.CWX := comboX.CWX;  
end;

end.
