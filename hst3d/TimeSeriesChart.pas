unit TimeSeriesChart;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, TeeProcs, TeEngine, Chart, StdCtrls, Buttons, Series, ComCtrls,
  Printers, Grids, ArgusDataEntry, DataGrid, Menus,
  clipbrd, CheckLst;



type
  TfrmTimeSeries = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    btnPrint: TButton;
    PageControl1: TPageControl;
    tabSeries: TTabSheet;
    tabPlots: TTabSheet;
    Chart1: TChart;
    Series1: TLineSeries;
    ScrollBox1: TScrollBox;
    rgDataTypes: TRadioGroup;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Splitter1: TSplitter;
    btnSave: TButton;
    SaveDialog1: TSaveDialog;
    btnHelp: TBitBtn;
    PrintDialog1: TPrintDialog;
    btnPrintSetup: TButton;
    PrinterSetupDialog1: TPrinterSetupDialog;
    tabFormat: TTabSheet;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    dgSeriesNames: TDataGrid;
    PopupMenu1: TPopupMenu;
    WindowsMetafile1: TMenuItem;
    Bitmap1: TMenuItem;
    Panel4: TPanel;
    Label2: TLabel;
    btnTitleFont: TButton;
    btnLegendFont: TButton;
    Label7: TLabel;
    edLeftTitle: TEdit;
    Label6: TLabel;
    edBotTitle: TEdit;
    memoTitle: TMemo;
    btnLeftTitleFont: TButton;
    btnBotTitleFont: TButton;
    btnLeftAxisFont: TButton;
    btnBottomAxisFont: TButton;
    LeftMargin: TLabel;
    Label9: TLabel;
    adeLeftMargin: TArgusDataEntry;
    adeRightMargin: TArgusDataEntry;
    Label3: TLabel;
    Label4: TLabel;
    comboBottomGridStyle: TComboBox;
    comboLeftGridStyle: TComboBox;
    Label5: TLabel;
    cbLegend: TCheckBox;
    adeTopMargin: TArgusDataEntry;
    adeBottomMargin: TArgusDataEntry;
    Label11: TLabel;
    Label10: TLabel;
    comboLegendPosition: TComboBox;
    Label8: TLabel;
    Clipboard1: TMenuItem;
    EnhancedWindowsMetafile1: TMenuItem;
    File1: TMenuItem;
    EnhancedWindowsMetafile2: TMenuItem;
    WindowsMetafile2: TMenuItem;
    Bitmap2: TMenuItem;
    DataasText1: TMenuItem;
    DataasText2: TMenuItem;
    clbDataSets: TCheckListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rzclDataSetsChanging(Sender: TObject; Index: Integer;
      NewState: TCheckBoxState; var AllowChange: Boolean);
    procedure rgDataTypesClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnPrintSetupClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnTitleFontClick(Sender: TObject);
    procedure btnBotTitleFontClick(Sender: TObject);
    procedure btnLeftTitleFontClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure dgSeriesNamesDrawCell(Sender: TObject; Col, Row: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure comboStyleChange(Sender: TObject);
    procedure dgSeriesNamesUserChanged(Sender: TObject);
    procedure edChange(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure dgSeriesNamesEditButtonClick(Sender: TObject);
    procedure WindowsMetafile1Click(Sender: TObject);
    procedure Bitmap1Click(Sender: TObject);
    procedure EnhancedWindowsMetafile1Click(Sender: TObject);
    procedure EnhancedWindowsMetafile2Click(Sender: TObject);
    procedure WindowsMetafile2Click(Sender: TObject);
    procedure Bitmap2Click(Sender: TObject);
    procedure DataasText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    GridPositionList : TList;
    ColorList : TList;
    LineList : TList;
    StyleList : TList;
    LeftPrintMargin, RightPrintMargin, TopPrintMargin, BottomPrintMargin : integer;
    ChartFormatChanged : Boolean;
    Function RightTypeOfData(TypeOfData : String; Index : Integer) : boolean;
    Function GetTime(Index : Integer) : double;
    Procedure LineListClear;
    Procedure GetData(AStringList : TStringList);
    { Public declarations }
  end;

  TGridPosition = Class(TObject)
    Layer : integer;
    Row : integer;
    Column : Integer;
  end;

  TColorObject = class (TObject)
    Color : TColor;
  end;

  TPointerStyle = class (TObject)
    Style : TSeriesPointerStyle;
  end;

var
  frmTimeSeries: TfrmTimeSeries;
  AlreadyDrawing : boolean;

implementation

{$R *.DFM}

uses PostProcessingUnit, ThreeDRealListUnit, ShowHelpUnit, PostProcessingPIEUnit;


Function TfrmTimeSeries.RightTypeOfData(TypeOfData : String; Index : Integer) : boolean;
begin
  result := (Pos(TypeOfData,frmPostProcessingForm.rgDataSet.Items[Index])> 0)
end;

Function TfrmTimeSeries.GetTime(Index : Integer) : double;
var
  ALine : string;
  StartPosition, Count : integer;
begin
  ALine := frmPostProcessingForm.rgDataSet.Items[Index];
  StartPosition := Pos('time',LowerCase(ALine)) + 4;
  ALine := Copy(ALine,StartPosition,Length(ALine));
  StartPosition := Pos('time',LowerCase(ALine)) + 4;
  Count :=   Pos('(',ALine) - StartPosition;
  result := InternationalStrToFloat(Trim(Copy(ALine,StartPosition,Count)));
end;

procedure TfrmTimeSeries.FormCreate(Sender: TObject);
var
  ColorObject : TColorObject;
  APointerStyle : TPointerStyle;
  ColumnIndex : integer;
begin
  for ColumnIndex := 0 to dgSeriesNames.ColCount -1 do
  begin
    dgSeriesNames.Cells[ColumnIndex,0] := dgSeriesNames.Columns[ColumnIndex].Title.Caption;
  end;

  PageControl1.ActivePage := tabPlots;

  GridPositionList := TList.Create;
  LineList := TList.Create;
  ColorList := TList.Create;
  StyleList := TList.Create;


  ColorObject := TColorObject.Create;
  ColorObject.Color := clAqua;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clBlack;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clBlue	;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clDkGray;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clFuchsia;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clGray	;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clGreen;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clLime	;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clLtGray;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clMaroon;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clNavy	;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clOlive	;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clPurple	;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clRed;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clSilver	;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clTeal	;
  ColorList.Add(ColorObject);

  ColorObject := TColorObject.Create;
  ColorObject.Color := clYellow	;
  ColorList.Add(ColorObject);

  APointerStyle := TPointerStyle.Create;
  APointerStyle.Style := psRectangle	;
  StyleList.Add(APointerStyle);

  APointerStyle := TPointerStyle.Create;
  APointerStyle.Style := psCircle	;
  StyleList.Add(APointerStyle);

  APointerStyle := TPointerStyle.Create;
  APointerStyle.Style := psTriangle	;
  StyleList.Add(APointerStyle);

  APointerStyle := TPointerStyle.Create;
  APointerStyle.Style := psDownTriangle	;
  StyleList.Add(APointerStyle);

  APointerStyle := TPointerStyle.Create;
  APointerStyle.Style := psCross	;
  StyleList.Add(APointerStyle);

  APointerStyle := TPointerStyle.Create;
  APointerStyle.Style := psDiagCross	;
  StyleList.Add(APointerStyle);

  APointerStyle := TPointerStyle.Create;
  APointerStyle.Style := psStar	;
  StyleList.Add(APointerStyle);

  APointerStyle := TPointerStyle.Create;
  APointerStyle.Style := psDiamond	;
  StyleList.Add(APointerStyle);

  APointerStyle := TPointerStyle.Create;
  APointerStyle.Style := psSmallDot	;
  StyleList.Add(APointerStyle);

end;

Procedure TfrmTimeSeries.LineListClear;
var
  Index : integer;
begin
  for Index := LineList.Count -1 downto 0 do
  begin
    TColorObject(LineList[Index]).Free;
  end;
  LineList.Clear;
end;

procedure TfrmTimeSeries.FormDestroy(Sender: TObject);
var
  Index : integer;
begin
  for Index := GridPositionList.Count -1 downto 0 do
  begin
    TGridPosition(GridPositionList[Index]).Free;
  end;
  GridPositionList.Free;
  for Index := ColorList.Count -1 downto 0 do
  begin
    TColorObject(ColorList[Index]).Free;
  end;
  ColorList.Free;
  for Index := StyleList.Count -1 downto 0 do
  begin
    TPointerStyle(StyleList[Index]).Free;
  end;
  StyleList.Free;

  LineListClear;
  LineList.Free;

end;

procedure TfrmTimeSeries.rzclDataSetsChanging(Sender: TObject;
  Index: Integer; NewState: TCheckBoxState; var AllowChange: Boolean);
begin
  Chart1.Series[Index].Active := (NewState = cbChecked);
end;

procedure TfrmTimeSeries.rgDataTypesClick(Sender: TObject);
var
  DataGridIndex : integer;
  TypeOfData : String;
  ObservationIndex : integer;
  AGridPosition : TGridPosition;
  Time, DataValue : double;
  A3DRealList : T3DRealList;
  Line : TLineSeries;
  AColor : TColor;
begin
  Chart1.FreeAllSeries;
  TypeOfData := rgDataTypes.Items[rgDataTypes.itemIndex];
  Chart1.LeftAxis.Title.Caption := TypeOfData;
  For ObservationIndex := 0 to GridPositionList.Count -1 do
  begin
    AColor := TColorObject(ColorList.Items[ObservationIndex mod ColorList.Count]).Color;
    AGridPosition := GridPositionList[ObservationIndex];
    Line := TLineSeries.Create(self);
    Line.ParentChart := Chart1;
    Line.Title := clbDataSets.Items[ObservationIndex];
//    Line.Title := rzclDataSets.Items[ObservationIndex];
    Line.Active := (clbDataSets.State[ObservationIndex] = cbChecked);
//    Line.Active := (rzclDataSets.ItemState[ObservationIndex] = cbChecked);
    Line.SeriesColor := AColor;
    Line.Pointer.Visible := True;
    Line.Pointer.HorizSize := 3;
    Line.Pointer.VertSize := 3;
    Line.Pointer.Style := TPointerStyle(StyleList.Items[ObservationIndex mod StyleList.Count]).Style;
    for DataGridIndex := 0 to frmPostProcessingForm.ListOfDataGrids.Count - 1 do
    begin
      if RightTypeOfData(TypeOfData, DataGridIndex) then
      begin
        Time := GetTime(DataGridIndex);
        A3DRealList := frmPostProcessingForm.ListOfDataGrids.Items[DataGridIndex];
        DataValue := A3DRealList.Items[AGridPosition.Column,AGridPosition.Row,AGridPosition.Layer];
        Line.AddXY(Time,DataValue,'',clTeeColor);
      end;
    end;
  end;
  btnCancelClick(nil);
end;

procedure TfrmTimeSeries.btnPrintClick(Sender: TObject);
  function Min(Var1, Var2 : double) : double ;
  begin
    if Var1 < Var2 then
    begin
      Result := Var1;
    end
    else
    begin
      Result := Var2;
    end;
  end;
var Multiplier : double;
  Rect : TRect;
begin
  if PrintDialog1.Execute then
  begin
    Multiplier := Min((Printer.PageWidth-1-LeftPrintMargin-RightPrintMargin)/Chart1.Width,
      (Printer.PageHeight-1-TopPrintMargin-BottomPrintMargin)/Chart1.Height);
    Rect.Left := LeftPrintMargin;
    Rect.Top := TopPrintMargin;
    Rect.Right := Round(Chart1.Width*Multiplier) + LeftPrintMargin;
    Rect.Bottom := Round(Chart1.Height*Multiplier) + TopPrintMargin;
    Chart1.PrintRect(Rect);
    Chart1.Refresh;

  end;
end;

Procedure TfrmTimeSeries.GetData(AStringList : TStringList);
var
  ALine : String;
  Index : integer;
  timeIndex : integer;
  LineSeries, AnotherLineSeries : TLineSeries;
begin
  ALine := 'Time';
//  For Index := 0 to rzclDataSets.Items.Count -1 do
//  begin
//    ALine := ALine + Chr(9) + rzclDataSets.Items[Index];
//  end;
  For Index := 0 to clbDataSets.Items.Count -1 do
  begin
    ALine := ALine + Chr(9) + clbDataSets.Items[Index];
  end;
  AStringList.Add(ALine);
  ALine := 'Time';
  For Index := 0 to Chart1.SeriesList.Count -1 do
  begin
    ALine := ALine + Chr(9) + Chart1.Series[Index].Title;
  end;
  AStringList.Add(ALine);
  LineSeries := TLineSeries(Chart1.Series[0]);
  For timeIndex := 0 to LineSeries.Count - 1 do
  begin
    ALine := FloatToStr(LineSeries.XValue[timeIndex]);
    For Index := 0 to Chart1.Serieslist.Count -1 do
    begin
      AnotherLineSeries := TLineSeries(Chart1.Series[Index]);
      ALine := ALine + Chr(9) + FloatToStr(AnotherLineSeries.YValue[timeIndex]);
    end;
    AStringList.Add(ALine);
  end;
end;

procedure TfrmTimeSeries.btnSaveClick(Sender: TObject);
var
  AStringList : TStringList;
begin
  SaveDialog1.Filter := 'Text files (*.txt)|*.txt|All files (*.*)|*.*';
  SaveDialog1.DefaultExt := 'txt';
  if SaveDialog1.Execute then
  begin
    AStringList := TStringList.Create;
    Try
      begin
        GetData(AStringList);
        AStringList.SaveToFile(SaveDialog1.Filename);
      end;
    finally
      begin
        AStringList.Free;
      end;
    end;
  end;
end;

procedure TfrmTimeSeries.btnHelpClick(Sender: TObject);
var
  HtmlPage : string;
begin
  HtmlPage := 'timeseries.htm';
  ShowSpecificHTMLHelp(HtmlPage);
end;

procedure TfrmTimeSeries.btnPrintSetupClick(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
end;

procedure TfrmTimeSeries.btnApplyClick(Sender: TObject);
var
  Index : integer;
  AColor : TColorObject;
begin
  Chart1.Title.Text := memoTitle.Lines;
  Chart1.Title.Font.Assign(memoTitle.Font);
  Chart1.Legend.Visible := cbLegend.Checked;

  case comboLegendPosition.ItemIndex of
    0: Chart1.Legend.Alignment := laRight;
    1: Chart1.Legend.Alignment := laBottom;
    2: Chart1.Legend.Alignment := laLeft;
    3: Chart1.Legend.Alignment := laTop;
  end;

  case comboLeftGridStyle.ItemIndex of
    0:  Chart1.LeftAxis.Grid.Style := psClear       ;
    1:  Chart1.LeftAxis.Grid.Style := psDash        ;
    2:  Chart1.LeftAxis.Grid.Style := psDashDot     ;
    3:  Chart1.LeftAxis.Grid.Style := psDashDotDot  ;
    4:  Chart1.LeftAxis.Grid.Style := psDot         ;
    5:  Chart1.LeftAxis.Grid.Style := psInsideFrame ;
    6:  Chart1.LeftAxis.Grid.Style := psSolid       ;
  end;
  case comboBottomGridStyle.ItemIndex of
    0:  Chart1.BottomAxis.Grid.Style := psClear       ;
    1:  Chart1.BottomAxis.Grid.Style := psDash        ;
    2:  Chart1.BottomAxis.Grid.Style := psDashDot     ;
    3:  Chart1.BottomAxis.Grid.Style := psDashDotDot  ;
    4:  Chart1.BottomAxis.Grid.Style := psDot         ;
    5:  Chart1.BottomAxis.Grid.Style := psInsideFrame ;
    6:  Chart1.BottomAxis.Grid.Style := psSolid       ;
  end;
  for Index := 0 to Chart1.SeriesList.Count -1 do
  begin
    Chart1.Series[Index].Title := dgSeriesNames.Cells[0,Index+1];
    AColor := LineList.Items[Index];
    TLineSeries(Chart1.Series[Index]).SeriesColor := AColor.Color;
    case dgSeriesNames.Columns[2].PickList.IndexOf(dgSeriesNames.Cells[2,Index+1]) of
      0: TLineSeries(Chart1.Series[Index]).Pointer.Style := psRectangle    ;
      1: TLineSeries(Chart1.Series[Index]).Pointer.Style := psCircle       ;
      2: TLineSeries(Chart1.Series[Index]).Pointer.Style := psTriangle     ;
      3: TLineSeries(Chart1.Series[Index]).Pointer.Style := psDownTriangle ;
      4: TLineSeries(Chart1.Series[Index]).Pointer.Style := psCross        ;
      5: TLineSeries(Chart1.Series[Index]).Pointer.Style := psDiagCross    ;
      6: TLineSeries(Chart1.Series[Index]).Pointer.Style := psStar         ;
      7: TLineSeries(Chart1.Series[Index]).Pointer.Style := psDiamond      ;
      8: TLineSeries(Chart1.Series[Index]).Pointer.Style := psSmallDot     ;
    end;

    TLineSeries(Chart1.Series[Index]).Pointer.VertSize :=  StrToInt(dgSeriesNames.Cells[3,Index+1]);
    TLineSeries(Chart1.Series[Index]).Pointer.HorizSize :=  StrToInt(dgSeriesNames.Cells[4,Index+1]);
  end;
  Chart1.BottomAxis.Title.Caption:=  edBotTitle.Text ;
  Chart1.LeftAxis.Title.Caption  :=  edLeftTitle.Text;
  Chart1.BottomAxis.Title.Font.Assign(edBotTitle.Font);
  Chart1.LeftAxis.Title.Font.Assign(edLeftTitle.Font);
  Chart1.BottomAxis.LabelsFont.Assign(btnBottomAxisFont.Font);
  Chart1.LeftAxis.LabelsFont.Assign(btnLeftAxisFont.Font);
  LeftPrintMargin := StrToInt(adeLeftMargin.Text);
  RightPrintMargin := StrToInt(adeRightMargin.Text);
  TopPrintMargin := StrToInt(adeTopMargin.Text);
  BottomPrintMargin := StrToInt(adeBottomMargin.Text);
  Chart1.Legend.Font.Assign(btnLegendFont.Font);

  // This must be the last statement.
  ChartFormatChanged := False;
end;

procedure TfrmTimeSeries.btnCancelClick(Sender: TObject);
var
  Index : integer;
  AColor : TColorObject;
//  ARect : TRect;
begin
  memoTitle.Lines := Chart1.Title.Text;
  memoTitle.Font := Chart1.Title.Font;

  cbLegend.Checked := Chart1.Legend.Visible;

  case Chart1.Legend.Alignment  of
    laRight : comboLegendPosition.ItemIndex := 0 ;
    laBottom: comboLegendPosition.ItemIndex := 1 ;
    laLeft  : comboLegendPosition.ItemIndex := 2 ;
    laTop   : comboLegendPosition.ItemIndex := 3 ;
  end;

  case Chart1.LeftAxis.Grid.Style  of
    psClear      :  comboLeftGridStyle.ItemIndex :=   0 ;
    psDash       :  comboLeftGridStyle.ItemIndex :=   1 ;
    psDashDot    :  comboLeftGridStyle.ItemIndex :=   2 ;
    psDashDotDot :  comboLeftGridStyle.ItemIndex :=   3 ;
    psDot        :  comboLeftGridStyle.ItemIndex :=   4 ;
    psInsideFrame:  comboLeftGridStyle.ItemIndex :=   5 ;
    psSolid      :  comboLeftGridStyle.ItemIndex :=   6 ;
  end;
  case Chart1.BottomAxis.Grid.Style  of
    psClear      :  comboBottomGridStyle.ItemIndex :=   0 ;
    psDash       :  comboBottomGridStyle.ItemIndex :=   1 ;
    psDashDot    :  comboBottomGridStyle.ItemIndex :=   2 ;
    psDashDotDot :  comboBottomGridStyle.ItemIndex :=   3 ;
    psDot        :  comboBottomGridStyle.ItemIndex :=   4 ;
    psInsideFrame:  comboBottomGridStyle.ItemIndex :=   5 ;
    psSolid      :  comboBottomGridStyle.ItemIndex :=   6 ;
  end;


  dgSeriesNames.RowCount := Chart1.SeriesList.Count+1;
{  for Index := 0 to Chart1.SeriesList.Count -1 do
  begin
    sgSeriesNames.Cells[0,Index] := Chart1.Series[Index].Title;
  end;          }
  edBotTitle.Text := Chart1.BottomAxis.Title.Caption;
  edLeftTitle.Text := Chart1.LeftAxis.Title.Caption;
  edBotTitle.Font := Chart1.BottomAxis.Title.Font;
  edLeftTitle.Font := Chart1.LeftAxis.Title.Font;
  btnBottomAxisFont.Font := Chart1.BottomAxis.LabelsFont;
  btnLeftAxisFont.Font := Chart1.LeftAxis.LabelsFont;
  adeLeftMargin.Text := IntToStr(LeftPrintMargin);
  adeRightMargin.Text := IntToStr(RightPrintMargin);
  adeTopMargin.Text := IntToStr(TopPrintMargin);
  adeBottomMargin.Text := IntToStr(BottomPrintMargin);
  LineListClear;
  for Index := 0 to Chart1.SeriesList.Count -1 do
  begin
    AColor :=  TColorObject.Create;
    AColor.Color := TLineSeries(Chart1.Series[Index]).SeriesColor;
    LineList.Add(AColor);

    dgSeriesNames.Cells[0,Index+1] := Chart1.Series[Index].Title;
    
    case TLineSeries(Chart1.Series[Index]).Pointer.Style of
     psRectangle     : dgSeriesNames.Cells[2,Index+1] := dgSeriesNames.Columns[2].PickList.Strings[0];
     psCircle        : dgSeriesNames.Cells[2,Index+1] := dgSeriesNames.Columns[2].PickList.Strings[1];
     psTriangle      : dgSeriesNames.Cells[2,Index+1] := dgSeriesNames.Columns[2].PickList.Strings[2];
     psDownTriangle  : dgSeriesNames.Cells[2,Index+1] := dgSeriesNames.Columns[2].PickList.Strings[3];
     psCross         : dgSeriesNames.Cells[2,Index+1] := dgSeriesNames.Columns[2].PickList.Strings[4];
     psDiagCross     : dgSeriesNames.Cells[2,Index+1] := dgSeriesNames.Columns[2].PickList.Strings[5];
     psStar          : dgSeriesNames.Cells[2,Index+1] := dgSeriesNames.Columns[2].PickList.Strings[6];
     psDiamond       : dgSeriesNames.Cells[2,Index+1] := dgSeriesNames.Columns[2].PickList.Strings[7];
     psSmallDot      : dgSeriesNames.Cells[2,Index+1] := dgSeriesNames.Columns[2].PickList.Strings[8];
    end;

    dgSeriesNames.Cells[3,Index+1] := IntToStr(TLineSeries(Chart1.Series[Index]).Pointer.VertSize);
    dgSeriesNames.Cells[4,Index+1] := IntToStr(TLineSeries(Chart1.Series[Index]).Pointer.HorizSize);
  end;
  btnLegendFont.Font := Chart1.Legend.Font;

   // this must be the last statement.
  ChartFormatChanged := False;
end;

procedure TfrmTimeSeries.btnTitleFontClick(Sender: TObject);
begin
  FontDialog1.Font := memoTitle.Font;
  if FontDialog1.Execute then
  begin
    memoTitle.Font := FontDialog1.Font ;
    ChartFormatChanged := True;
  end;
end;

procedure TfrmTimeSeries.btnBotTitleFontClick(Sender: TObject);
begin
  FontDialog1.Font := edBotTitle.Font;
  if FontDialog1.Execute then
  begin
    edBotTitle.Font := FontDialog1.Font
  end;

end;

procedure TfrmTimeSeries.btnLeftTitleFontClick(Sender: TObject);
begin
  FontDialog1.Font := edLeftTitle.Font;
  if FontDialog1.Execute then
  begin
    edLeftTitle.Font := FontDialog1.Font
  end;

end;

procedure TfrmTimeSeries.btnFontClick(Sender: TObject);
begin
  FontDialog1.Font := TButton(Sender).Font;
  if FontDialog1.Execute then
  begin
    TButton(Sender).Font := FontDialog1.Font ;
    ChartFormatChanged := True;
  end;

end;

type
  TDataGridCrack = class(TDataGrid);

procedure TfrmTimeSeries.dgSeriesNamesDrawCell(Sender: TObject; Col,
  Row: Integer; Rect: TRect; State: TGridDrawState);
var
  BrushColor, FontColor, PenColor : TColor;
begin
  if AlreadyDrawing then Exit;
  try
    AlreadyDrawing := True;
    if (Col = 1) or (Row = 0) then
    begin
      BrushColor := dgSeriesNames.Canvas.Brush.Color;
      FontColor := dgSeriesNames.Canvas.Font.Color;
      PenColor := dgSeriesNames.Canvas.Pen.Color;
      try
        if Row = 0 then
        begin
          dgSeriesNames.Canvas.Brush.Color := clBtnFace;
//          dgSeriesNames.Cells[Col,Row] := dgSeriesNames.Columns[Col].Title.Caption;
        end
        else
        begin
          dgSeriesNames.Canvas.Brush.Color := TColorObject(LineList[Row-1]).Color;
        end;
        // change the font color to black
        dgSeriesNames.Canvas.Font.Color := clBlack;
        // draw the text
        dgSeriesNames.Canvas.TextRect(Rect,Rect.Left,Rect.Top,dgSeriesNames.
          Cells[Col,Row]);
        // draw the right and lower cell boundaries in black.
        dgSeriesNames.Canvas.Pen.Color := clBlack;
        dgSeriesNames.Canvas.MoveTo(Rect.Right,Rect.Top);
        dgSeriesNames.Canvas.LineTo(Rect.Right,Rect.Bottom);
        dgSeriesNames.Canvas.LineTo(Rect.Left,Rect.Bottom);
      finally
        dgSeriesNames.Canvas.Brush.Color := BrushColor;
        dgSeriesNames.Canvas.Font.Color := FontColor ;
        dgSeriesNames.Canvas.Pen.Color := PenColor  ;
      end;
    end
    else
    begin
      dgSeriesNames.DefaultDrawing := True;
      BrushColor := dgSeriesNames.Canvas.Brush.Color;
      FontColor := dgSeriesNames.Canvas.Font.Color;
      PenColor := dgSeriesNames.Canvas.Pen.Color;
      try
        if Row = 0 then
        begin
          dgSeriesNames.Canvas.Brush.Color := clBtnFace;
        end
        else
        begin
          dgSeriesNames.Canvas.Brush.Color := clWindow;
        end;
  //      dgSeriesNames.FixedRows := 1;
        TDataGridCrack(dgSeriesNames).DrawCell(Col,Row,Rect,State);
      finally
        dgSeriesNames.DefaultDrawing := False;
        dgSeriesNames.Canvas.Brush.Color := BrushColor;
        dgSeriesNames.Canvas.Font.Color := FontColor ;
        dgSeriesNames.Canvas.Pen.Color := PenColor  ;
      end;
    end;
  finally
    AlreadyDrawing := False;
  end;
end;

procedure TfrmTimeSeries.comboStyleChange(Sender: TObject);
begin
    ChartFormatChanged := True;

end;

procedure TfrmTimeSeries.dgSeriesNamesUserChanged(Sender: TObject);
begin
    ChartFormatChanged := True;

end;

procedure TfrmTimeSeries.edChange(Sender: TObject);
begin
    ChartFormatChanged := True;

end;

procedure TfrmTimeSeries.PageControl1Change(Sender: TObject);
begin
  If ChartFormatChanged then
  begin
    If MessageDlg('Do you wish to accept your changes in chart format?',
      mtConfirmation, [mbYes, mbNo, mbCancel],0) = mrYes then
    begin
      btnApplyClick(nil);
    end
    else
    begin
      btnCancelClick(nil);
    end;
  end;
end;

procedure TfrmTimeSeries.dgSeriesNamesEditButtonClick(Sender: TObject);
var
  Row : integer;
begin
  Row := dgSeriesNames.Selection.Top;
  ColorDialog1.Color := TColorObject(LineList[Row-1]).Color;
  if ColorDialog1.Execute then
  begin
    TColorObject(LineList[Row-1]).Color := ColorDialog1.Color;
    ChartFormatChanged := True;
  end;
end;

procedure TfrmTimeSeries.WindowsMetafile1Click(Sender: TObject);
begin
  Chart1.CopyToClipboardMetafile(False);
end;

procedure TfrmTimeSeries.Bitmap1Click(Sender: TObject);
begin
  Chart1.CopyToClipboardBitmap;
end;

procedure TfrmTimeSeries.EnhancedWindowsMetafile1Click(Sender: TObject);
begin
  Chart1.CopyToClipboardMetafile(True);
end;

procedure TfrmTimeSeries.EnhancedWindowsMetafile2Click(Sender: TObject);
begin
  SaveDialog1.Filter := 'Enhanced Windows metafiles (*.emf)|*.emf|All files (*.*)|*.*';
  SaveDialog1.DefaultExt := 'emf';
  If SaveDialog1.Execute then
  begin
    Chart1.SaveToMetafileEnh(SaveDialog1.FileName);
  end;
end;

procedure TfrmTimeSeries.WindowsMetafile2Click(Sender: TObject);
begin
  SaveDialog1.Filter := 'Windows metafiles (*.wmf)|*.wmf|All files (*.*)|*.*';
  SaveDialog1.DefaultExt := 'wmf';
  If SaveDialog1.Execute then
  begin
    Chart1.SaveToMetafile(SaveDialog1.FileName);
  end;

end;

procedure TfrmTimeSeries.Bitmap2Click(Sender: TObject);
begin
  SaveDialog1.Filter := 'Bitmap files (*.bmp)|*.bmp|All files (*.*)|*.*';
  SaveDialog1.DefaultExt := 'bmp';
  If SaveDialog1.Execute then
  begin
    Chart1.SaveToBitmapFile(SaveDialog1.FileName);
  end;

end;

procedure TfrmTimeSeries.DataasText1Click(Sender: TObject);
var
  AStringList : TStringList;
  AClipBoard :  TClipBoard;
begin
    AStringList := TStringList.Create;
    AClipBoard :=  TClipBoard.Create;
    Try
      begin
        GetData(AStringList);
        AClipBoard.SetTextBuf(PChar(AStringList.Text));
      end;
    finally
      begin
        AStringList.Free;
        AClipBoard.Free;
      end;
    end;

end;

end.
