unit frmEditGridUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, Knob, StdCtrls, contnrs, ArgusDataEntry, Grids, DataGrid, Spin, ExtCtrls, Buttons,
  RBWZoomBox, AnePIE, RBWDynamicCursor, RealListUnit, ComCtrls,
  WriteContourUnit, PointContourUnit, Clipbrd;

type
  TOriginCoordinate = class;

  TCustomGridCoordinate = class(TRBWZoomPoint)
    function GetXCoord : Integer; override;
    function GetYCoord : Integer; override;
//    Procedure SetXCoord(const AnX : Integer); override;
//    Procedure SetYCoord(const AY  : Integer); override;
    function ColumnPosition : double; virtual;
    function RowPosition : double; virtual;
    function GetColIndex : integer; virtual; abstract;
    function GetRowIndex : integer; virtual; abstract;
    procedure SetColIndex(const Value : integer); virtual; abstract;
    procedure SetRowIndex(const Value : integer); virtual; abstract;
    Property ColIndex : integer read GetColIndex Write SetColIndex;
    Property RowIndex : integer read GetRowIndex Write SetRowIndex;
    Procedure Update; virtual;
//    procedure SetX(const Value: Extended); override;
//    procedure SetY(const Value: Extended); override;
    function GetX : extended;
    function GetY : extended;
    Property X : Extended read GetX write SetX;
    Property Y : Extended read GetY write SetY;
    Property XCoord : Integer read GetXCoord write SetXCoord;
    property YCoord : Integer read GetYCoord write SetYCoord;
  end;

  TfrmEditGrid = class(TfrmWriteContour)
    dcCursor: TRBWDynamicCursor;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    sbMove: TSpeedButton;
    sbMoveColumn: TSpeedButton;
    sbMoveRow: TSpeedButton;
    sbColWidth: TSpeedButton;
    sbRowHeight: TSpeedButton;
    sbAddColumn: TSpeedButton;
    sbAddRow: TSpeedButton;
    sbDeleteColRow: TSpeedButton;
    sbRotate: TSpeedButton;
    Panel2: TPanel;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    adeXOrigin: TArgusDataEntry;
    adeYOrigin: TArgusDataEntry;
    adeAngle: TArgusDataEntry;
    knobAngle: TKnob;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    adeSmoothCriterion: TArgusDataEntry;
    zbGrid: TRBWZoomBox;
    sbPan: TSpeedButton;
    sbZoom: TSpeedButton;
    sbZoomExtents: TSpeedButton;
    sbZoomIn: TSpeedButton;
    sbZoomOut: TSpeedButton;
    sbSubdivide: TSpeedButton;
    SpeedButton1: TSpeedButton;
    sbGridPositions: TSpeedButton;
    sbGridWidths: TSpeedButton;
    BitBtn1: TBitBtn;
    btnAbout: TButton;
    SpeedButton2: TSpeedButton;
    procedure sbPanClick(Sender: TObject);
    procedure knobAngleChange(Sender: TObject);
    procedure adeAngleExit(Sender: TObject);
    procedure dcCursorDrawCursor(Sender: TObject; const AndImage,
      XorImage: TBitmap);
    procedure sbMoveColumnClick(Sender: TObject);
    procedure sbMoveClick(Sender: TObject);
    procedure sbRotateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure sbZoomClick(Sender: TObject);
    procedure sbZoomInClick(Sender: TObject);
    procedure sbZoomOutClick(Sender: TObject);
    procedure sbZoomExtentsClick(Sender: TObject);
    procedure zbGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zbGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure zbGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject); override;
    procedure sbDeleteColRowClick(Sender: TObject);
    procedure zbGridPaint(Sender: TObject);
    procedure adeXOriginExit(Sender: TObject);
    procedure adeYOriginExit(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure sbSmoothClick(Sender: TObject);
    procedure sbGridPositionsClick(Sender: TObject);
    procedure sbGridWidthsClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  protected
    procedure AssignHelpFile(FileName: string);
  private
    BlockCenteredGrid : boolean;
    FAngle: double;
    RowPositions, ColumnPositions : TRealList;
    ColumnCoordinates : TObjectList;
    RowCoordinates : TObjectList;
    RowsReversed, ColumnsReversed : boolean;
    XDirPositive, YDirPositive : boolean;
    BeginingX, BeginingY, EndingX, EndingY : double;
    StartX, StartY, CurrentX, CurrentY : integer;

    SelectedColIndex, SelectedRoIndex : integer;
    SelectedColumn : TObjectList;
    SelectedRow : TObjectList;
    StartAngle, EndAngle : double;
//    OriginCoordinate : TOriginCoordinate;
    FLastSelectedColumnIndex: integer;
    FFirstSelectedRowIndex: integer;
    FLastSelectedRowIndex: integer;
    FFirstSelectedColumnIndex: integer;
    FXOrigin: double;
    FYOrigin: double;
    FShowSelectedColumn: boolean;
    FShowSelectedRow: boolean;
    FShowOutline: boolean;
    FSelectedColumnPosition: double;
    FSelectedRowPosition: double;
    XOffset, YOffset : double;
    DomainOutline, Density : TObjectList;
    ColumnZones, RowZones : TObjectList;
    procedure SetFirstSelectedColumnIndex(const Value: integer);
    procedure SetFirstSelectedRowIndex(const Value: integer);
    procedure SetLastSelectedColumnIndex(const Value: integer);
    procedure SetLastSelectedRowIndex(const Value: integer);
    procedure SetXOrigin(const Value: double);
    procedure SetYOrigin(const Value: double);
    procedure SetShowSelectedColumn(const Value: boolean);
    procedure SetShowSelectedRow(const Value: boolean);
    procedure SetShowOutline(const Value: boolean);
    procedure SetSelectedColumnPosition(const Value: double);
    procedure SetSelectedRowPosition(const Value: double);
    procedure SetGrid;
    property SelectedRowPosition : double read FSelectedRowPosition write SetSelectedRowPosition;
    property SelectedColumnPosition : double read FSelectedColumnPosition write SetSelectedColumnPosition;
    property ShowOutline : boolean read FShowOutline write SetShowOutline;
    property ShowSelectedColumn : boolean read FShowSelectedColumn write SetShowSelectedColumn;
    property ShowSelectedRow : boolean read FShowSelectedRow write SetShowSelectedRow;
    property XOrigin : double read FXOrigin write SetXOrigin;
    property YOrigin : double read FYOrigin write SetYOrigin;
    property FirstSelectedColumnIndex : integer read FFirstSelectedColumnIndex write SetFirstSelectedColumnIndex;
    property LastSelectedColumnIndex : integer read FLastSelectedColumnIndex write SetLastSelectedColumnIndex;
    property FirstSelectedRowIndex : integer read FFirstSelectedRowIndex write SetFirstSelectedRowIndex;
    property LastSelectedRowIndex : integer read FLastSelectedRowIndex write SetLastSelectedRowIndex;
    procedure SetAngle(const Value: double);
    procedure DrawColRowCursor(const AndImage: TBitmap;
      Angle : double);
    procedure DrawColRowWidthCursor(const AndImage: TBitmap;
      Angle: double);
    procedure DrawLine(const AndImage: TBitmap; Angle: double);
//    procedure ResetOutline;
    function SelectColumnLine(X, Y: integer): integer;
    function SelectRowLine(X, Y: integer): integer;
    procedure SetSelectedColRowPositions(X, Y: integer);
    function InterpolatedY(const X1, X2, X, Y1, Y2, Y: integer): integer;
    function CheckMinMax(const X, Y: integer; const CoordList: TObjectList;
      const Index: integer): boolean;
    procedure ResetSelectedRowColPositions;
    Function GetWidth(const ColOrRowPositionList : TRealList;
      const Index : integer) : double;
    procedure SetWidth(const ColOrRowPositionList : TRealList;
      const Index : integer; const Value : double);
    function GetColumnWidth(const Index : integer) : double;
    function GetRowHeight(const Index : integer) : double;
    procedure SetColumnWidth(const Index : integer; const Value : double);
    procedure SetRowHeight(const Index : integer; const Value : double);
    property ColumnWidths[const Index : integer] : double read GetColumnWidth
      write SetColumnWidth;
    property RowHeights[const Index : integer] : double read GetRowHeight
      write SetRowHeight;
    function SelectColumnOrRow(const ColOrRowCoordinates: TObjectList;
      const X, Y: integer): integer;
    function SelectColumn(X, Y : integer) : integer;
    function SelectRow(X, Y : integer) : integer;
    procedure MakeCoordinates;
    function GetOriginCoordinate: TCustomGridCoordinate;
    procedure ResetPositions;
    Function XOffsetCoord : integer;
    Function YOffsetCoord : integer;
    function ReadDomainOutlineAndDensity : boolean;
    procedure RotateDomainOutlineAndDensity;
    procedure CreateZones;
    procedure SortZoneList(const ZoneList: TObjectList);
    procedure CreateCells(const ZoneList : TObjectList;
      const Positions : TRealList);
    procedure UpdateCoordinates;
    { Private declarations }
  public
    LayerHandle : ANE_PTR;
    function GetGrid : boolean;
    Property Angle : double read FAngle write SetAngle;
    property OriginCoordinate : TCustomGridCoordinate read GetOriginCoordinate;
    { Public declarations }
  end;

{  TCustomCoordinate = class(TRBWZoomPoint)
    function ColumnPosition : double; virtual; abstract;
    function RowPosition : double; virtual; abstract;
    Procedure Update; virtual;
  end;}


  TRowGridCoordinate = class(TCustomGridCoordinate)
    FRowIndex : integer;
    First : boolean;
    function GetColIndex : integer; override;
    function GetRowIndex : integer; override;
    procedure SetColIndex(const Value : integer); override;
    procedure SetRowIndex(const Value : integer); override;
    function ColumnPosition : double; override;
  end;

  TColGridCoordinate = class(TCustomGridCoordinate)
    FColIndex : integer;
    First : boolean;
    function GetColIndex : integer; override;
    function GetRowIndex : integer; override;
    procedure SetColIndex(const Value : integer); override;
    procedure SetRowIndex(const Value : integer); override;
    function RowPosition : double; override;
  end;

  TOriginCoordinate = class(TCustomGridCoordinate)
    function GetColIndex : integer; override;
    function GetRowIndex : integer; override;
    procedure SetColIndex(const Value : integer); override;
    procedure SetRowIndex(const Value : integer); override;
  end;

  TMoveableColCoordinate = class(TColGridCoordinate)
    function ColumnPosition : double; override;
  end;

  TMoveableRowCoordinate = class(TRowGridCoordinate)
    function RowPosition : double; override;
  end;

  TEditGridPoint = class(TArgusPoint)
    Procedure Draw; override;
    class Function GetZoomBox : TRBWZoomBox; override;
    Constructor Create; override;
  end;

  TEditGridContour = class(TContour)
    GridDensity : double;
    Procedure Draw; override;
  private
    procedure RotatePoints;
  end;

  TZone = class(TObject)
  private
    FDesiredCellSize: double;
    LowerLimit : double;
    UpperLimit : double;
    procedure SetDesiredCellSize(const Value: double);
  published
    property DesiredCellSize : double read FDesiredCellSize write SetDesiredCellSize;
  end;

var
  frmEditGrid: TfrmEditGrid;

const
  crZoomCursor : TCursor = 2;
  crXCursor : TCursor = 3;
  crSubdivide : TCursor = 4;
  SelectionRange = 5;

implementation

uses Math, UtilityFunctions, OptionsUnit, SetRowColumnConstantWidths,
  RowColumnDivision, RowColPositionsUnit, frmAboutUnit, frmGridTypeUnit,
  frmGetLayerNamesUnit;

{$R *.DFM}
{$R ZoomCur.res}

{var
  OriginX, OriginY : ANE_DOUBLE;}

function SortZones(Item1, Item2: Pointer): Integer;
var
  Zone1, Zone2 : TZone;
begin
  Zone1 := Item1;
  Zone2 := Item2;
  if Zone1.LowerLimit < Zone2.LowerLimit then
  begin
    result := -1
  end
  else if Zone1.LowerLimit > Zone2.LowerLimit then
  begin
    result := 1
  end
  else if Zone1.UpperLimit < Zone2.UpperLimit then
  begin
    result := -1
  end
  else if Zone1.UpperLimit > Zone2.UpperLimit then
  begin
    result := 1
  end
  else if Zone1.DesiredCellSize < Zone2.DesiredCellSize then
  begin
    result := -1
  end
  else if Zone1.DesiredCellSize > Zone2.DesiredCellSize then
  begin
    result := 1
  end
  else
  begin
    result := 0;
  end;
end;


procedure TfrmEditGrid.sbPanClick(Sender: TObject);
begin
  inherited;
  if sbPan.Down then
  begin
    zbGrid.Cursor := crHandPoint;
    zbGrid.PBCursor := crHandPoint;
    zbGrid.SCursor :=  crHandPoint;
  end
  else
  begin
    zbGrid.Cursor := crDefault;
    zbGrid.PBCursor := crDefault;
    zbGrid.SCursor :=  crDefault;
  end;

end;

procedure TfrmEditGrid.knobAngleChange(Sender: TObject);
begin
  Angle := knobAngle.Position * PI / 180;
  adeAngle.Text := FloatToStr(knobAngle.Position);
end;

procedure TfrmEditGrid.adeAngleExit(Sender: TObject);
var
  NewPosition : double;
begin
  NewPosition := StrToFloat(adeAngle.Text);
  while NewPosition < 0 do
  begin
    NewPosition := NewPosition + 360;
  end;
  while NewPosition > 360 do
  begin
    NewPosition := NewPosition - 360;
  end;
  knobAngle.Position := NewPosition;
end;

{procedure TfrmEditGrid.ResetOutline;
var
  RowGridCoord : TRowGridCoordinate;
  OutlinePoint : TRBWZoomPoint;
begin
  If (GridOutline.Count = 4) and (RowCoordinates.Count >= 2) then
  begin
    OutlinePoint := GridOutline[0] as TRBWZoomPoint;
    RowGridCoord := RowCoordinates[0] as TRowGridCoordinate;
    OutlinePoint.X := RowGridCoord.X;
    OutlinePoint.Y := RowGridCoord.Y;

    OutlinePoint := GridOutline[1] as TRBWZoomPoint;
    RowGridCoord := RowCoordinates[1] as TRowGridCoordinate;
    OutlinePoint.X := RowGridCoord.X;
    OutlinePoint.Y := RowGridCoord.Y;

    OutlinePoint := GridOutline[2] as TRBWZoomPoint;
    RowGridCoord := RowCoordinates[RowCoordinates.Count-1] as TRowGridCoordinate;
    OutlinePoint.X := RowGridCoord.X;
    OutlinePoint.Y := RowGridCoord.Y;

    OutlinePoint := GridOutline[3] as TRBWZoomPoint;
    RowGridCoord := RowCoordinates[RowCoordinates.Count-2] as TRowGridCoordinate;
    OutlinePoint.X := RowGridCoord.X;
    OutlinePoint.Y := RowGridCoord.Y;
  end;
end;  }

procedure TfrmEditGrid.ResetSelectedRowColPositions;
var
  Index : integer;
  Coordinate : TCustomGridCoordinate;
begin
  if ColumnPositions.Count > 0 then
  begin
    SelectedColumnPosition := ColumnPositions[0];
    for Index := 0 to SelectedColumn.Count -1 do
    begin
      Coordinate := SelectedColumn[Index] as TCustomGridCoordinate;
      Coordinate.Update;
    end;
  end;
  if RowPositions.Count > 0 then
  begin
    SelectedRowPosition := RowPositions[0];
    for Index := 0 to SelectedRow.Count -1 do
    begin
      Coordinate := SelectedRow[Index] as TCustomGridCoordinate;
      Coordinate.Update;
    end;
  end;
end;

function TfrmEditGrid.GetGrid : boolean;
var
  GridLayer : TGridLayerOptions;
  GridAngle : ANE_DOUBLE;
  Index : integer;
  NCOL, NROW :integer;
  OriginAngle, distance : double;
  ColPos, RowPos : double;
begin
  result := false;
  GridLayer := TGridLayerOptions.Create(CurrentModelHandle, LayerHandle);
  try
    GridAngle := GridLayer.GridAngle(CurrentModelHandle);
    knobAngle.Position := GridAngle * 180/Pi;

    NCOL := GridLayer.NumberOfColumns(CurrentModelHandle);
    NROW := GridLayer.NumberOfRows(CurrentModelHandle);
    if (NCOL = 0) or (NROW = 0) then Exit;

    Application.CreateForm(TfrmGridType, frmGridType);
    try
      frmGridType.ShowModal;
      BlockCenteredGrid := frmGridType.rgGridType.ItemIndex = 0;
      if not BlockCenteredGrid then
      begin
        Dec(NCOL);
        Dec(NROW);
      end;
    finally
      frmGridType.Free;
    end;



    ColumnPositions.Capacity := NCOL + 1;
    RowPositions.Capacity := NROW + 1;

//    ColumnCoordinates.Capacity := ColumnPositions.Capacity*2;
//    RowCoordinates.Capacity := RowPositions.Capacity*2;

    for Index := 0 to ColumnPositions.Capacity -1 do
    begin
      ColumnPositions.Add(GridLayer.ColumnPositions(CurrentModelHandle,Index));
    end;
    for Index := 0 to RowPositions.Capacity -1 do
    begin
      RowPositions.Add(GridLayer.RowPositions(CurrentModelHandle,Index));
    end;

    XDirPositive := GridLayer.CoordXRight[CurrentModelHandle];
    YDirPositive := GridLayer.CoordYUp[CurrentModelHandle];

    zbGrid.XPositive := XDirPositive;
    zbGrid.YPositive := YDirPositive;

    RowsReversed := GridLayer.GridReverseYDirection[CurrentModelHandle];
    ColumnsReversed := GridLayer.GridReverseXDirection[CurrentModelHandle];

    If (ColumnPositions.Count > 0) and (RowPositions.Count > 0) then
    begin
      ColPos := ColumnPositions[0];
      RowPos := RowPositions[0];

      distance := Sqrt(Sqr(ColPos) + Sqr(RowPos));
      OriginAngle := ArcTan2(RowPos,ColPos);
      XOrigin := distance*Cos(Angle+OriginAngle);
      YOrigin := distance*sin(Angle+OriginAngle);

      distance := ColPos;
      for Index := 0 to ColumnPositions.Count -1 do
      begin
        ColumnPositions[Index] := ColumnPositions[Index] - distance;
      end;

      distance := RowPos;
      for Index := 0 to RowPositions.Count -1 do
      begin
        RowPositions[Index] := RowPositions[Index] - distance;
      end;
    end
    else
    begin
      XOrigin := 0;
      YOrigin := 0;
    end;

    MakeCoordinates;
    GridAngle := GridLayer.GridAngle(CurrentModelHandle);
    knobAngle.Position := GridAngle * 180/Pi;

  finally
    GridLayer.Free(CurrentModelHandle);
  end;

    
{  for Index := 0 to ColumnPositions.Count -1 do
  begin
    ColGridCoord := TColGridCoordinate.Create(zbGrid);
    ColumnCoordinates.Add(ColGridCoord);
    ColGridCoord.ColIndex := Index;
    ColGridCoord.First := True;
    ColGridCoord.Update;

    ColGridCoord := TColGridCoordinate.Create(zbGrid);
    ColumnCoordinates.Add(ColGridCoord);
    ColGridCoord.ColIndex := Index;
    ColGridCoord.First := False;
    ColGridCoord.Update;
  end;

  for Index := 0 to RowPositions.Count -1 do
  begin
    RowGridCoord := TRowGridCoordinate.Create(zbGrid);
    RowCoordinates.Add(RowGridCoord);
    RowGridCoord.RowIndex := Index;
    RowGridCoord.First := True;
    RowGridCoord.Update;

    RowGridCoord := TRowGridCoordinate.Create(zbGrid);
    RowCoordinates.Add(RowGridCoord);
    RowGridCoord.RowIndex := Index;
    RowGridCoord.First := False;
    RowGridCoord.Update;
  end; }

  ResetPositions;
  ResetSelectedRowColPositions;

//  Assert(GridOutline.Count = 4);

//  ResetOutline;

  sbZoomExtentsClick(nil);

  result := True;

end;

procedure TfrmEditGrid.SetGrid;
var
  NCOL, NROW :integer;
  GridTemplate : TStringList;
  Index : integer;
  Template : string;
  GridLayer : TLayerOptions;
  TempXOrigin, TempYOrigin : double;
  ACoordinate : TCustomGridCoordinate;
begin
  if (ColumnPositions.Count < 2) or (RowPositions.Count < 2) then
  begin
    Beep;
    ShowMessage('No grid has been defined.');
  end
  else
  begin
    GridTemplate := TStringList.Create;
    try
      NCOL := ColumnPositions.Count -1;
      NROW := RowPositions.Count -1;
      ColumnPositions.Sort;
      RowPositions.Sort;


      if not BlockCenteredGrid then
      begin
        Inc(NROW);
        Inc(NCOL);
      end;

      GridTemplate.Add(IntToStr(NROW) + #9 + IntToStr(NCOL)
       + #9 + '0' + #9 + FloatToStr(Angle*180/Pi));


  {    ACoordinate := nil;
      if ColumnCoordinates.Count > 2 then
      begin
        if RowsReversed and ColumnsReversed then
        begin
          ACoordinate := ColumnCoordinates[ColumnCoordinates.Count-1] as TCustomGridCoordinate;
        end
        else if RowsReversed then
        begin
          ACoordinate := ColumnCoordinates[1] as TCustomGridCoordinate;
        end
        else if ColumnsReversed then
        begin
          ACoordinate := ColumnCoordinates[ColumnCoordinates.Count-2] as TCustomGridCoordinate;
        end
        else
        begin
          ACoordinate := ColumnCoordinates[0] as TCustomGridCoordinate;
        end;

      end;   }
      ACoordinate := OriginCoordinate;
  //    ACoordinate := nil;
      if ACoordinate = nil then
      begin
        TempXOrigin := {OriginCoordinate.X +} XOrigin;
        TempYOrigin := {OriginCoordinate.Y +} YOrigin;
      end
      else
      begin
        TempXOrigin := ACoordinate.X + XOrigin;
        TempYOrigin := ACoordinate.Y + YOrigin;
      end;

      GridTemplate.Add(FloatToStr(TempYOrigin));

  {    if RowsReversed then
      begin
        for Index := RowPositions.Count -2 downto 0 do
        begin
          GridTemplate.Add(FloatToStr(Abs(RowHeights[Index])));
        end;
      end
      else
      begin  }
        for Index := 0 to RowPositions.Count -2 do
        begin
          GridTemplate.Add(FloatToStr(Abs(RowHeights[Index])));
        end;
  //    end;

      GridTemplate.Add(FloatToStr(TempXOrigin));

  {   if ColumnsReversed then
      begin
        for Index := ColumnPositions.Count -2 downto 0 do
        begin
          GridTemplate.Add(FloatToStr(Abs(ColumnWidths[Index])));
        end;
      end
      else
      begin    }
        for Index := 0 to ColumnPositions.Count -2 do
        begin
          GridTemplate.Add(FloatToStr(Abs(ColumnWidths[Index])));
        end;
  //    end;

      Template := '';
      for Index := 0 to GridTemplate.Count -1 do
      begin
        Template := Template + #10 + GridTemplate[Index];
      end;

    finally
      Clipboard.AsText := GridTemplate.Text;
      GridTemplate.Free;
    end;

    GridLayer := TLayerOptions.Create(LayerHandle);;
    try
      GridLayer.ClearLayer(CurrentModelHandle,False);
      GridLayer.SetText(CurrentModelHandle,Template);
{      Beep;
      MessageDlg('To deactivate grid cells outside the domain outline, you '
        + 'must now click on the grid with the "Magic Wand" tool and then '
        + 'click on the "Deactivate" button.', mtInformation, [mbOK], 0); }
    finally
      GridLayer.Free(CurrentModelHandle);
    end;
  end;

end;

procedure TfrmEditGrid.DrawColRowCursor(const AndImage: TBitmap;
  Angle : double);
const
  LineSeparation = 1.55;
  ArrowLength = 6;
  ArrowHeadLength = 4;
var
  LineLength : double;
  X1, Y1, X2, Y2 : integer;
  lsCa, llSa, lsSa, llCa : double;
  ArrowAngle : double;
  procedure DrawLine;
  begin
    with AndImage.Canvas do
    begin
      MoveTo(X1, Y1);
      LineTo(X2, Y2);
    end
  end;
begin
  inherited;
  While Angle > Pi do
  begin
    Angle := Angle - Pi;
  end;

  While Angle < -Pi/4 do
  begin
    Angle := Angle + Pi;
  end;

  if Angle > Pi * 3/4 then
  begin
    Angle := Angle - Pi;
  end;

  LineLength := (dcCursor.CursorHeight - 5) / 4 + 0.1;
  dcCursor.HotPointX := dcCursor.CursorWidth div 2;
  dcCursor.HotPointY := dcCursor.CursorHeight div 2;

  lsCa := LineSeparation * Cos(Angle);
  llSa := LineLength * Sin(Angle);
  lsSa := LineSeparation * Sin(Angle);
  llCa := LineLength * Cos(Angle);

  X1 := Round(dcCursor.HotPointX + lsCa - llSa);
  Y1 := Round(dcCursor.HotPointY - (lsSa + llCa));
  X2 := Round(dcCursor.HotPointX + lsCa + llSa);
  Y2 := Round(dcCursor.HotPointY - (lsSa - llCa));
  DrawLine;

  X1 := Round(dcCursor.HotPointX - lsCa - llSa);
  Y1 := Round(dcCursor.HotPointY - (-lsSa + llCa));
  X2 := Round(dcCursor.HotPointX - lsCa + llSa);
  Y2 := Round(dcCursor.HotPointY - (-lsSa - llCa));
  DrawLine;

  // draw arrows;
  X2 := Round(dcCursor.HotPointX + 2*lsCa);
  Y2 := Round(dcCursor.HotPointY - 2*lsSa);

  X1 := X2 + Round(ArrowLength*Cos(Angle));
  Y1 := Y2 - Round(ArrowLength*Sin(Angle));
  DrawLine;

  ArrowAngle := Angle + Pi/4;
  X2 := X1 - Round(ArrowHeadLength*Cos(ArrowAngle));
  Y2 := Y1 + Round(ArrowHeadLength*Sin(ArrowAngle));
  DrawLine;

  ArrowAngle := Angle - Pi/4;
  X2 := X1 - Round(ArrowHeadLength*Cos(ArrowAngle));
  Y2 := Y1 + Round(ArrowHeadLength*Sin(ArrowAngle));
  DrawLine;

  X2 := Round(dcCursor.HotPointX - 2*lsCa);
  Y2 := Round(dcCursor.HotPointY + 2*lsSa);
  X1 := X2 - Round(ArrowLength*Cos(Angle));
  Y1 := Y2 + Round(ArrowLength*Sin(Angle));
  DrawLine;

  ArrowAngle := Angle + Pi/4;
  X2 := X1 + Round(ArrowHeadLength*Cos(ArrowAngle));
  Y2 := Y1 - Round(ArrowHeadLength*Sin(ArrowAngle));
  DrawLine;

  ArrowAngle := Angle - Pi/4;
  X2 := X1 + Round(ArrowHeadLength*Cos(ArrowAngle));
  Y2 := Y1 - Round(ArrowHeadLength*Sin(ArrowAngle));
  DrawLine;

end;

procedure TfrmEditGrid.DrawLine(const AndImage: TBitmap;
  Angle : double);
const
  LineLength = 12;
var
  X1, Y1, X2, Y2 : integer;
begin
  While Angle > Pi do
  begin
    Angle := Angle - Pi;
  end;

  While Angle < -Pi/4 do
  begin
    Angle := Angle + Pi;
  end;

  if Angle > Pi * 3/4 then
  begin
    Angle := Angle - Pi;
  end;

  dcCursor.HotPointX := dcCursor.CursorWidth div 2;
  dcCursor.HotPointY := dcCursor.CursorHeight div 2;

  with AndImage.Canvas do
  begin
    // draw line
    X1 := Round(dcCursor.HotPointX + LineLength*Cos(Angle));
    Y1 := Round(dcCursor.HotPointY - LineLength*Sin(Angle));

    X2 := Round(dcCursor.HotPointX - LineLength*Cos(Angle));
    Y2 := Round(dcCursor.HotPointY + LineLength*Sin(Angle));

    MoveTo(X1,Y1);
    LineTo(X2,Y2);
  end;

end;

procedure TfrmEditGrid.dcCursorDrawCursor(Sender: TObject;
  const AndImage, XorImage: TBitmap);
begin
  inherited;
  if sbMoveColumn.Down then
  begin
    DrawColRowCursor(AndImage, Angle);
  end
  else if sbMoveRow.Down then
  begin
    DrawColRowCursor(AndImage, Angle + Pi/2);
  end
  else if sbColWidth.Down then
  begin
    DrawColRowWidthCursor(AndImage,Angle);
  end
  else if sbRowHeight.Down then
  begin
    DrawColRowWidthCursor(AndImage,Angle + Pi/2);
  end
  else if sbAddColumn.Down then
  begin
    DrawLine(AndImage,Angle + Pi/2);
  end
  else if sbAddRow.Down then
  begin
    DrawLine(AndImage,Angle);
  end

end;

procedure TfrmEditGrid.SetAngle(const Value: double);
begin
//  if FAngle <> Value then
  begin
{    Coordinate := nil;
    if RowsReversed then
    begin
      if ColumnsReversed then
      begin
        if ColumnCoordinates.Count > 1 then
        begin
//          Coordinate := ColumnCoordinates[0] as TCustomGridCoordinate;
//          Coordinate := ColumnCoordinates[ColumnCoordinates.Count-1] as TCustomGridCoordinate;
          Coordinate := ColumnCoordinates[ColumnCoordinates.Count-2] as TCustomGridCoordinate;
        end;
      end
      else
      begin
        if ColumnCoordinates.Count > 1 then
        begin
        //
          Coordinate := ColumnCoordinates[0] as TCustomGridCoordinate;
        end;
      end;
    end
    else
    begin
      if ColumnsReversed then
      begin
        if ColumnCoordinates.Count > 1 then
        begin
          Coordinate := ColumnCoordinates[ColumnCoordinates.Count-2] as TCustomGridCoordinate;
        end;
      end
      else
      begin
        if ColumnCoordinates.Count >= 2 then
        begin
          Coordinate := ColumnCoordinates[0] as TCustomGridCoordinate;
        end;
      end;
    end;   }

{    Coordinate := OriginCoordinate;
    if Coordinate <> nil then
    begin
      AnX := Coordinate.X + XOrigin;
      AY := Coordinate.Y + YOrigin;
      XOrigin := AnX;
      YOrigin := AY;
    end;   }

    FAngle := Value;
    dcCursor.RedrawCursor;
//    ResetOutline;
    zbGrid.Invalidate;
  end;
end;

procedure TfrmEditGrid.ResetPositions;
var
  Delta : double;
  Index : integer;
  TempX, TempY, Dx, Dy : double;
  Coordinate : TCustomGridCoordinate;
  function GetCoordinate : TCustomGridCoordinate;
  begin
    result := nil;
    if ColumnCoordinates.Count > 2 then
    begin
      if RowsReversed and ColumnsReversed then
      begin
        result := ColumnCoordinates[ColumnCoordinates.Count-1] as TCustomGridCoordinate;
      end
      else if RowsReversed then
      begin
        result := ColumnCoordinates[1] as TCustomGridCoordinate;
      end
      else if ColumnsReversed then
      begin
        result := ColumnCoordinates[ColumnCoordinates.Count-2] as TCustomGridCoordinate;
      end
      else
      begin
        result := ColumnCoordinates[0] as TCustomGridCoordinate;
      end;
    end;
  end;

begin
  ColumnPositions.Sort;
  RowPositions.Sort;

  Coordinate := GetCoordinate;
  if Coordinate <> nil then
  begin
    TempX := XOrigin;
    TempY := YOrigin;

    Dx := Coordinate.X;
    Dy := Coordinate.Y;

    ResetSelectedRowColPositions;
    if (ColumnPositions.Count > 0) and (ColumnPositions[0] <> 0) then
    begin
      if ColumnsReversed then
      begin
        Delta := ColumnPositions[ColumnPositions.Count-1];
      end
      else
      begin
        Delta := ColumnPositions[0];
      end;
      for Index := 0 to ColumnPositions.Count -1 do
      begin
        ColumnPositions[Index] := ColumnPositions[Index] - Delta;
      end;
    end;
    if (RowPositions.Count > 0) and (RowPositions[0] <> 0) then
    begin
      if RowsReversed then
      begin
        Delta := RowPositions[RowPositions.Count-1];
      end
      else
      begin
        Delta := RowPositions[0];
      end;
      for Index := 0 to RowPositions.Count -1 do
      begin
        RowPositions[Index] := RowPositions[Index] - Delta;
      end;

    end;

    Coordinate := GetCoordinate;

    Dx := Dx - Coordinate.X;
    Dy := Dy - Coordinate.Y;

    XOrigin := TempX + Dx;
    YOrigin := TempY + Dy;

  end;
end;


procedure TfrmEditGrid.sbMoveColumnClick(Sender: TObject);
begin
  inherited;
  dcCursor.RedrawCursor;
  FirstSelectedColumnIndex := -1;
  FirstSelectedRowIndex := -1;
  if sbAddColumn.Down or sbAddRow.Down then
  begin
    zbGrid.Cursor := dcCursor.Cursor;
    zbGrid.PBCursor := dcCursor.Cursor;
    zbGrid.SCursor := dcCursor.Cursor;
  end
  else if sbSubdivide.Down then
  begin
    zbGrid.Cursor := crSubdivide;
    zbGrid.PBCursor := crSubdivide;
    zbGrid.SCursor := crSubdivide;
  end
  else
  begin
    zbGrid.Cursor := crDefault;
    zbGrid.PBCursor := crDefault;
    zbGrid.SCursor := crDefault;
  end;
  ShowSelectedColumn := ((Sender = sbAddColumn) and sbAddColumn.Down)
    {or ((Sender = sbSubdivide) and sbSubdivide.Down)};
  ShowSelectedRow := ((Sender = sbAddRow) and sbAddRow.Down)
    {or ((Sender = sbSubdivide) and sbSubdivide.Down)};
end;

procedure TfrmEditGrid.DrawColRowWidthCursor(const AndImage: TBitmap;
  Angle : double);
const
  ArrowLength = 8;
  ArrowHeadLength = 5;
var
  X1, Y1, X2, Y2, X3, Y3 : integer;
  ArrowAngle : double;
begin
  While Angle > Pi do
  begin
    Angle := Angle - Pi;
  end;

  While Angle < -Pi/4 do
  begin
    Angle := Angle + Pi;
  end;

  if Angle > Pi * 3/4 then
  begin
    Angle := Angle - Pi;
  end;

  dcCursor.HotPointX := dcCursor.CursorWidth div 2;
  dcCursor.HotPointY := dcCursor.CursorHeight div 2;

  with AndImage.Canvas do
  begin
    Brush.Color := clBlack;
    Ellipse(dcCursor.HotPointX-2,dcCursor.HotPointY-2,
      dcCursor.HotPointX+2,dcCursor.HotPointY+2);

    // draw main line
    X1 := Round(dcCursor.HotPointX + ArrowLength*Cos(Angle));
    Y1 := Round(dcCursor.HotPointY - ArrowLength*Sin(Angle));

    X2 := Round(dcCursor.HotPointX - ArrowLength*Cos(Angle));
    Y2 := Round(dcCursor.HotPointY + ArrowLength*Sin(Angle));

    MoveTo(X1,Y1);
    LineTo(X2,Y2);

    // draw first arrowheads
    ArrowAngle := Angle + Pi/4;

    X3 := X1 - Round(ArrowHeadLength*Cos(ArrowAngle));
    Y3 := Y1 + Round(ArrowHeadLength*Sin(ArrowAngle));

    MoveTo(X1,Y1);
    LineTo(X3,Y3);

    ArrowAngle := Angle - Pi/4;

    X3 := X1 - Round(ArrowHeadLength*Cos(ArrowAngle));
    Y3 := Y1 + Round(ArrowHeadLength*Sin(ArrowAngle));

    MoveTo(X1,Y1);
    LineTo(X3,Y3);

    // draw second arrowhead
    ArrowAngle := Angle + Pi/4;

    X3 := X2 + Round(ArrowHeadLength*Cos(ArrowAngle));
    Y3 := Y2 - Round(ArrowHeadLength*Sin(ArrowAngle));

    MoveTo(X2,Y2);
    LineTo(X3,Y3);

    ArrowAngle := Angle - Pi/4;

    X3 := X2 + Round(ArrowHeadLength*Cos(ArrowAngle));
    Y3 := Y2 - Round(ArrowHeadLength*Sin(ArrowAngle));

    MoveTo(X2,Y2);
    LineTo(X3,Y3);

  end;

end;

procedure TfrmEditGrid.sbMoveClick(Sender: TObject);
begin
  inherited;
  zbGrid.Cursor := crDefault;
  zbGrid.PBCursor := crDefault;
  zbGrid.SCursor := crDefault;
  ShowSelectedColumn := False;
  ShowSelectedRow := False;
end;

procedure TfrmEditGrid.sbRotateClick(Sender: TObject);
begin
  inherited;
  if sbRotate.Down then
  begin
    zbGrid.Cursor := crHandPoint;
    zbGrid.PBCursor := crHandPoint;
    zbGrid.SCursor := crHandPoint;
  end
  else
  begin
    zbGrid.Cursor := crDefault;
    zbGrid.PBCursor := crDefault;
    zbGrid.SCursor := crDefault;
  end;

  ShowSelectedColumn := False;
  ShowSelectedRow := False;
end;

procedure TfrmEditGrid.FormCreate(Sender: TObject);
var
//  Index : integer;
  ColCoordinate : TMoveableColCoordinate;
  RowCoordinate : TMoveableRowCoordinate;
begin
  inherited;
  XOffset := 0;
  YOffset := 0;
  AssignHelpFile('EditGrid.hlp');
  Screen.Cursors[crZoomCursor] := LoadCursor(hInstance,'ZOOMCURSOR');
  Screen.Cursors[crXCursor] := LoadCursor(hInstance,'XCURSOR');
  Screen.Cursors[crSubdivide] := LoadCursor(hInstance,'SUBDIVIDE');

  RowPositions := TRealList.Create;
  ColumnPositions := TRealList.Create;

  ColumnCoordinates := TObjectList.Create;
  RowCoordinates := TObjectList.Create;


  // create list of points defining the position of the selected column
  SelectedColumn := TObjectList.Create;

  ColCoordinate := TMoveableColCoordinate.Create(zbGrid);
  ColCoordinate.First := True;
  SelectedColumn.Add(ColCoordinate);

  ColCoordinate := TMoveableColCoordinate.Create(zbGrid);
  ColCoordinate.First := False;
  SelectedColumn.Add(ColCoordinate);

  // create list of points defining the position of the selected row
  SelectedRow := TObjectList.Create;

  RowCoordinate := TMoveableRowCoordinate.Create(zbGrid);
  RowCoordinate.First := True;
  SelectedRow.Add(RowCoordinate);

  RowCoordinate := TMoveableRowCoordinate.Create(zbGrid);
  RowCoordinate.First := False;
  SelectedRow.Add(RowCoordinate);

//  OriginCoordinate := TOriginCoordinate.Create(zbGrid);

end;

procedure TfrmEditGrid.sbZoomClick(Sender: TObject);
begin
  inherited;
  zbGrid.Cursor := crZoomCursor;
  zbGrid.PBCursor := crZoomCursor;
  zbGrid.SCursor := crZoomCursor;

end;

procedure TfrmEditGrid.sbZoomInClick(Sender: TObject);
begin
  inherited;
  zbGrid.ZoomBy(2);
  sbZoomOut.Enabled := True;
  sbPan.Enabled := True;
end;

procedure TfrmEditGrid.sbZoomOutClick(Sender: TObject);
begin
  inherited;
  zbGrid.ZoomBy(0.5);
end;

procedure TfrmEditGrid.sbZoomExtentsClick(Sender: TObject);
begin
  inherited;
  zbGrid.ZoomOut;
  sbZoomOut.Enabled := False;
  sbPan.Enabled := False;
  XOffset := 0;
  YOffset := 0;
end;

procedure TfrmEditGrid.zbGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
//  ResetOutline;
  CurrentX := X;
  CurrentY := Y;
  StartX := CurrentX;
  StartY := CurrentY;
  BeginingX := zbGrid.X(X);
  BeginingY := zbGrid.Y(Y);
  ShowOutline := sbMove.Down or sbRotate.Down;
{  if ShowOutline then
  begin
    zbGrid.Invalidate;
  end; }
  if sbZoom.Down then
  begin
    zbGrid.BeginZoom(X, Y);
  end;
  if sbPan.Down then
  begin
    zbGrid.BeginPan;
  end;
  if sbMoveColumn.Down or sbAddColumn.Down then
  begin
    SelectedColIndex := SelectColumnLine(X,Y);
    if (SelectedColIndex >= 0) or sbAddColumn.Down then
    begin
      SetSelectedColRowPositions(X,Y);
      ShowSelectedColumn := True;
      zbGrid.Cursor := dcCursor.Cursor;
      zbGrid.PBCursor := dcCursor.Cursor;
      zbGrid.SCursor := dcCursor.Cursor;
//      zbGrid.Invalidate;
    end;
  end;
  if sbMoveRow.Down or sbAddRow.Down then
  begin
    SelectedRoIndex := SelectRowLine(X,Y);
    if (SelectedRoIndex >= 0) or sbAddRow.Down then
    begin
      SetSelectedColRowPositions(X,Y);
      ShowSelectedRow := True;
      zbGrid.Cursor := dcCursor.Cursor;
      zbGrid.PBCursor := dcCursor.Cursor;
      zbGrid.SCursor := dcCursor.Cursor;
//      zbGrid.Invalidate;
    end;
  end;
  if sbColWidth.Down or sbSubdivide.Down then
  begin
    FirstSelectedColumnIndex := SelectColumn(X,Y);
  end;
  if sbRowHeight.Down or sbSubdivide.Down then
  begin
    FirstSelectedRowIndex := SelectRow(X,Y);
  end;
  if sbRotate.Down then
  begin
    StartAngle := ArcTan2(zbGrid.Y(Y),zbGrid.X(X));
    EndAngle := StartAngle;
  end;
end;

procedure TfrmEditGrid.zbGridMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  SelectedColumnIndex, SelectedRowIndex : integer;
  TempAngle : double;
begin
  inherited;
  CurrentX := X;
  CurrentY := Y;
  if ShowOutline then
  begin
    zbGrid.Invalidate;
  end;
  StatusBar1.SimpleText := '(X,Y) = (' + FloatToStr(zbGrid.X(X) + XOrigin)
    + ', ' + FloatToStr(zbGrid.Y(Y) + YOrigin) + ')';
  if sbZoom.Down then
  begin
    zbGrid.ContinueZoom(X,Y);
  end;
  if sbColWidth.Down or sbSubdivide.Down then
  begin
    LastSelectedColumnIndex := SelectColumn(X,Y);
    if LastSelectedColumnIndex > -1 then
    begin
      StatusBar1.SimpleText := StatusBar1.SimpleText + '; Column = '
        + IntToStr(LastSelectedColumnIndex + 1);
      if sbColWidth.Down then
      begin
        zbGrid.Cursor := dcCursor.Cursor;
        zbGrid.PBCursor := dcCursor.Cursor;
        zbGrid.SCursor := dcCursor.Cursor;
      end
      else
      begin
        zbGrid.Cursor := crSubdivide;
        zbGrid.PBCursor := crSubdivide;
        zbGrid.SCursor := crSubdivide;
      end;
    end
    else
    begin
      zbGrid.Cursor := crDefault;
      zbGrid.PBCursor := crDefault;
      zbGrid.SCursor := crDefault;
    end;
  end;
  if sbRowHeight.Down or sbSubdivide.Down then
  begin
    LastSelectedRowIndex := SelectRow(X,Y);
    if LastSelectedRowIndex > -1 then
    begin
      StatusBar1.SimpleText := StatusBar1.SimpleText + '; Row = '
        + IntToStr(LastSelectedRowIndex + 1);
      if sbRowHeight.Down then
      begin
        zbGrid.Cursor := dcCursor.Cursor;
        zbGrid.PBCursor := dcCursor.Cursor;
        zbGrid.SCursor := dcCursor.Cursor;
      end
      else
      begin
        zbGrid.Cursor := crSubdivide;
        zbGrid.PBCursor := crSubdivide;
        zbGrid.SCursor := crSubdivide;
      end;
    end
    else
    begin
      zbGrid.Cursor := crDefault;
      zbGrid.PBCursor := crDefault;
      zbGrid.SCursor := crDefault;
    end;
  end;
  if sbMoveColumn.Down or sbAddColumn.Down or sbDeleteColRow.Down then
  begin
    if not sbDeleteColRow.Down and (ShowSelectedColumn or sbAddColumn.Down) then
    begin
      SetSelectedColRowPositions(X,Y);
//      zbGrid.Invalidate;
    end
    else
    begin
      SelectedColumnIndex := SelectColumnLine(X,Y);
      if sbDeleteColRow.Down then
      begin
        ShowSelectedColumn := SelectedColumnIndex >-1;
        if ShowSelectedColumn then
        begin
          SelectedColumnPosition := ColumnPositions[SelectedColumnIndex];
          SelectedColIndex := SelectedColumnIndex
        end;
//        zbGrid.Invalidate;
      end
      else
      begin
        if (SelectedColumnIndex >= 0) or sbDeleteColRow.Down then
        begin
          zbGrid.Cursor := dcCursor.Cursor;
          zbGrid.PBCursor := dcCursor.Cursor;
          zbGrid.SCursor := dcCursor.Cursor;
        end
        else
        begin
          zbGrid.Cursor := crDefault;
          zbGrid.PBCursor := crDefault;
          zbGrid.SCursor := crDefault;
        end;
      end;
    end;
  end;
  if sbMoveRow.Down or sbAddRow.Down or sbDeleteColRow.Down then
  begin
    if  not sbDeleteColRow.Down and (ShowSelectedRow or sbAddRow.Down) then
    begin
      SetSelectedColRowPositions(X,Y);
//      zbGrid.Invalidate;
    end
    else
    begin
      SelectedRowIndex := SelectRowLine(X,Y);
      if sbDeleteColRow.Down then
      begin
        ShowSelectedRow := SelectedRowIndex >-1;
        if ShowSelectedRow then
        begin
          SelectedRowPosition := RowPositions[SelectedRowIndex];
          SelectedRoIndex := SelectedRowIndex
        end;
//        zbGrid.Invalidate;
      end
      else
      begin
        if (SelectedRowIndex >= 0) or sbDeleteColRow.Down then
        begin
          zbGrid.Cursor := dcCursor.Cursor;
          zbGrid.PBCursor := dcCursor.Cursor;
          zbGrid.SCursor := dcCursor.Cursor;
        end
        else
        begin
          zbGrid.Cursor := crDefault;
          zbGrid.PBCursor := crDefault;
          zbGrid.SCursor := crDefault;
        end;
      end;
    end;
  end;
  if sbDeleteColRow.Down then
  begin
    if ShowSelectedColumn or ShowSelectedRow then
    begin
      zbGrid.Cursor := crXCursor;
      zbGrid.PBCursor := crXCursor;
      zbGrid.SCursor := crXCursor;
    end
    else
    begin
      zbGrid.Cursor := crDefault;
      zbGrid.PBCursor := crDefault;
      zbGrid.SCursor := crDefault;
    end;
  end;
  if sbRotate.Down and (ssLeft in Shift) then
  begin
    EndAngle := ArcTan2(zbGrid.Y(Y),zbGrid.X(X));

    TempAngle := (Angle + EndAngle - StartAngle)*180/Pi;
    While TempAngle > 360 do
    begin
      TempAngle := TempAngle - 360;
    end;
    While TempAngle < 0 do
    begin
      TempAngle := TempAngle + 360;
    end;
    StatusBar1.SimpleText := StatusBar1.SimpleText +
      '; Angle = ' + FloatToStr(TempAngle);
  end;
end;

procedure TfrmEditGrid.zbGridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
//  ColOffset, RowOffset : double;
//  Distance, OffsetAngle : double;
//  DeltaX, DeltaY : double;
  Index, InnerIndex : integer;
  IndexLarger, IndexSmaller, Count : integer;
  DeltaZ, NewWidth  : double;
  ColGridCoord : TColGridCoordinate;
  RowGridCoord : TRowGridCoordinate;
  TempAngle : double;
  NewCount : integer;
  TempX, TempY, Dx, Dy : double;
begin
  inherited;
  CurrentX := X;
  CurrentY := Y;
  ShowOutline := False;
  EndingX := zbGrid.X(X);
  EndingY := zbGrid.Y(Y);
  if sbZoom.Down then
  begin
    zbGrid.FinishZoom(X,Y);
    sbZoomOut.Enabled := True;
    sbPan.Enabled := True;
  end;
  if sbPan.Down then
  begin
    zbGrid.EndPan;
  end;
  if sbMove.Down then
  begin
    XOrigin := XOrigin + EndingX-BeginingX;
    YOrigin := YOrigin + EndingY-BeginingY;
{    if (EndingX<>BeginingX) or (EndingY<>BeginingY) then
    begin
      ShowMessage('The location of the grid origin have been changed to '
        + 'reflect the new position that you have specified.');
    end; }
  end;
  if ShowSelectedColumn then
  begin
    ShowSelectedColumn := sbAddColumn.Down;
    SetSelectedColRowPositions(X,Y);
    if sbMoveColumn.Down then
    begin
      ColumnPositions[SelectedColIndex] := SelectedColumnPosition;
      ResetPositions;
    end
    else if sbAddColumn.Down then
    begin
      if ColumnPositions.IndexOf(SelectedColumnPosition) < 0 then
      begin
        if ColumnPositions.Count = 0 then
        begin
          XOrigin := SelectedColumnPosition;
        end;
        ColumnPositions.Add(SelectedColumnPosition);
        ColGridCoord := TColGridCoordinate.Create(zbGrid);
        ColumnCoordinates.Add(ColGridCoord);
        ColGridCoord.ColIndex := ColumnPositions.Count-1;
        ColGridCoord.First := True;
  //      ColGridCoord.Update;

        ColGridCoord := TColGridCoordinate.Create(zbGrid);
        ColumnCoordinates.Add(ColGridCoord);
        ColGridCoord.ColIndex := ColumnPositions.Count-1;
        ColGridCoord.First := False;

        ResetPositions
      end;
//      ColGridCoord.Update;
    end
    else if sbDeleteColRow.Down then
    begin
      ColumnPositions.Delete(SelectedColIndex);
      ColumnCoordinates.Delete(ColumnCoordinates.Count-1);
      ColumnCoordinates.Delete(ColumnCoordinates.Count-1);
      ResetPositions
    end
    else
    begin
      // subdivide columns
    end;
    ColumnPositions.Sort;
//    UpdateZoomPoints;
  end;
  if ShowSelectedRow then
  begin
    ShowSelectedRow := sbAddRow.Down;
    SetSelectedColRowPositions(X,Y);
    if sbMoveRow.Down then
    begin
      RowPositions[SelectedRoIndex] := SelectedRowPosition;
      ResetPositions;
    end
    else if sbAddRow.Down then
    begin
      if RowPositions.IndexOf(SelectedRowPosition) < 0 then
      begin
        if RowPositions.Count = 0 then
        begin
          YOrigin := SelectedRowPosition;
        end;
        RowPositions.Add(SelectedRowPosition);
        RowGridCoord := TRowGridCoordinate.Create(zbGrid);
        RowCoordinates.Add(RowGridCoord);
        RowGridCoord.RowIndex := RowPositions.Count-1;
        RowGridCoord.First := True;
  //      ColGridCoord.Update;

        RowGridCoord := TRowGridCoordinate.Create(zbGrid);
        RowCoordinates.Add(RowGridCoord);
        RowGridCoord.RowIndex := RowPositions.Count-1;
        RowGridCoord.First := False;

        ResetPositions
      end;
//      ColGridCoord.Update;
    end
    else if sbDeleteColRow.Down then
    begin
      RowPositions.Delete(SelectedRoIndex);
      RowCoordinates.Delete(RowCoordinates.Count-1);
      RowCoordinates.Delete(RowCoordinates.Count-1);
      ResetPositions
    end
    else
    begin
      // subdivide columns
    end;
    RowPositions.Sort;
//    UpdateZoomPoints;
  end;
  if sbColWidth.Down then
  begin
    LastSelectedColumnIndex := SelectColumn(X,Y);
    if (FirstSelectedColumnIndex > -1) and (LastSelectedColumnIndex > -1) then
    begin
      Application.CreateForm(TfrmSetRowColumnConstantWidths,
        frmSetRowColumnConstantWidths);
      try
        frmSetRowColumnConstantWidths.CurrentModelHandle := CurrentModelHandle;
        frmSetRowColumnConstantWidths.Caption := 'Set width of selected columns';
        frmSetRowColumnConstantWidths.lblRowOrColumn.Caption := 'Column Width';
        frmSetRowColumnConstantWidths.adeRowOrColumn.Text := FloatToStr(ColumnWidths[FirstSelectedColumnIndex]);
        if frmSetRowColumnConstantWidths.ShowModal = mrOK then
        begin
          NewWidth := StrToFloat(frmSetRowColumnConstantWidths.adeRowOrColumn.Text);
          if FirstSelectedColumnIndex > LastSelectedColumnIndex then
          begin
            IndexSmaller := LastSelectedColumnIndex;
            IndexLarger := FirstSelectedColumnIndex;
          end
          else
          begin
            IndexSmaller := FirstSelectedColumnIndex;
            IndexLarger := LastSelectedColumnIndex;
          end;

          DeltaZ := (IndexLarger+1-IndexSmaller)*NewWidth
            - (ColumnPositions[IndexLarger+1] - ColumnPositions[IndexSmaller]);
          Count := 0;
          if ColumnsReversed then
          begin
            for Index := IndexLarger  downto 0 do
            begin
              Inc(Count);
              if Index >= IndexSmaller then
              begin
                ColumnPositions[Index] := ColumnPositions[IndexLarger+1] - Count*NewWidth;
              end
              else
              begin
                ColumnPositions[Index] := ColumnPositions[Index] - DeltaZ;
              end;
            end;
          end
          else
          begin
            for Index := IndexSmaller+1  to ColumnPositions.Count -1 do
            begin
              Inc(Count);
              if Index <= IndexLarger then
              begin
                ColumnPositions[Index] := ColumnPositions[IndexSmaller] + Count*NewWidth;
              end
              else
              begin
                ColumnPositions[Index] := ColumnPositions[Index] + DeltaZ;
              end;
            end;
          end;
          ResetPositions;
        end;

        FirstSelectedColumnIndex := -1;
      finally
        frmSetRowColumnConstantWidths.Free;
      end;
    end;
  end;
  if sbRowHeight.Down then
  begin
    LastSelectedRowIndex := SelectRow(X,Y);
    if (FirstSelectedRowIndex > -1) and (LastSelectedRowIndex > -1) then
    begin
      Application.CreateForm(TfrmSetRowColumnConstantWidths,
        frmSetRowColumnConstantWidths);
      try
        frmSetRowColumnConstantWidths.CurrentModelHandle := CurrentModelHandle;
        frmSetRowColumnConstantWidths.Caption := 'Set width of selected rows';
        frmSetRowColumnConstantWidths.lblRowOrColumn.Caption := 'Row Height';
        frmSetRowColumnConstantWidths.adeRowOrColumn.Text := FloatToStr(RowHeights[FirstSelectedRowIndex]);
        if frmSetRowColumnConstantWidths.ShowModal = mrOK then
        begin
          NewWidth := StrToFloat(frmSetRowColumnConstantWidths.adeRowOrColumn.Text);
          if FirstSelectedRowIndex > LastSelectedRowIndex then
          begin
            IndexSmaller := LastSelectedRowIndex;
            IndexLarger := FirstSelectedRowIndex;
          end
          else
          begin
            IndexSmaller := FirstSelectedRowIndex;
            IndexLarger := LastSelectedRowIndex;
          end;

          DeltaZ := (IndexLarger+1-IndexSmaller)*NewWidth
            - (RowPositions[IndexLarger+1] - RowPositions[IndexSmaller]);
          Count := 0;
          if ColumnsReversed then
          begin
            for Index := IndexLarger  downto 0 do
            begin
              Inc(Count);
              if Index >= IndexSmaller then
              begin
                RowPositions[Index] := RowPositions[IndexLarger+1] - Count*NewWidth;
              end
              else
              begin
                RowPositions[Index] := RowPositions[Index] - DeltaZ;
              end;
            end;
          end
          else
          begin
            for Index := IndexSmaller+1  to RowPositions.Count -1 do
            begin
              Inc(Count);
              if Index <= IndexLarger then
              begin
                RowPositions[Index] := RowPositions[IndexSmaller] + Count*NewWidth;
              end
              else
              begin
                RowPositions[Index] := RowPositions[Index] + DeltaZ;
              end;
            end;
          end;
          ResetPositions;
        end;

        FirstSelectedRowIndex := -1;
      finally
        frmSetRowColumnConstantWidths.Free;
      end;
    end;
  end;
  if sbSubdivide.Down then
  begin
    LastSelectedColumnIndex := SelectColumn(X,Y);
    LastSelectedRowIndex := SelectRow(X,Y);
    if (FirstSelectedColumnIndex > -1) and (LastSelectedColumnIndex > -1)
      and (FirstSelectedRowIndex > -1) and (LastSelectedRowIndex > -1) then
    begin
      Application.CreateForm(TfrmRowColumnDivision,
        frmRowColumnDivision);
      try
        frmRowColumnDivision.CurrentModelHandle := CurrentModelHandle;

        if frmRowColumnDivision.ShowModal = mrOK then
        begin
          NewCount := StrToInt(frmRowColumnDivision.adeColCount.Text);
          if NewCount > 1 then
          begin
            if FirstSelectedColumnIndex > LastSelectedColumnIndex then
            begin
              IndexSmaller := LastSelectedColumnIndex;
              IndexLarger := FirstSelectedColumnIndex;
            end
            else
            begin
              IndexSmaller := FirstSelectedColumnIndex;
              IndexLarger := LastSelectedColumnIndex;
            end;

            for Index := IndexLarger  downto IndexSmaller do
            begin
              DeltaZ := ColumnWidths[Index]/NewCount;
              for InnerIndex := 2 to NewCount do
              begin
                ColumnPositions.Add(ColumnPositions[Index]+(InnerIndex-1)*DeltaZ);

                ColGridCoord := TColGridCoordinate.Create(zbGrid);
                ColumnCoordinates.Add(ColGridCoord);
                ColGridCoord.ColIndex := ColumnPositions.Count-1;
                ColGridCoord.First := True;

                ColGridCoord := TColGridCoordinate.Create(zbGrid);
                ColumnCoordinates.Add(ColGridCoord);
                ColGridCoord.ColIndex := ColumnPositions.Count-1;
                ColGridCoord.First := False;
              end;
            end;
            ColumnPositions.Sort;
          end;

          NewCount := StrToInt(frmRowColumnDivision.adeRowCount.Text);
          if NewCount > 1 then
          begin
            if FirstSelectedRowIndex > LastSelectedRowIndex then
            begin
              IndexSmaller := LastSelectedRowIndex;
              IndexLarger := FirstSelectedRowIndex;
            end
            else
            begin
              IndexSmaller := FirstSelectedRowIndex;
              IndexLarger := LastSelectedRowIndex;
            end;

            for Index := IndexLarger  downto IndexSmaller do
            begin
              DeltaZ := RowHeights[Index]/NewCount;
              for InnerIndex := 2 to NewCount do
              begin
                RowPositions.Add(RowPositions[Index]+(InnerIndex-1)*DeltaZ);

                RowGridCoord := TRowGridCoordinate.Create(zbGrid);
                RowCoordinates.Add(RowGridCoord);
                RowGridCoord.RowIndex := RowPositions.Count-1;
                RowGridCoord.First := True;

                RowGridCoord := TRowGridCoordinate.Create(zbGrid);
                RowCoordinates.Add(RowGridCoord);
                RowGridCoord.RowIndex := RowPositions.Count-1;
                RowGridCoord.First := False;
              end;
            end;
            RowPositions.Sort;
          end;
        end;

        FirstSelectedColumnIndex := -1;
        FirstSelectedRowIndex := -1;
      finally
        frmRowColumnDivision.Free;
      end;
    end;
  end;
  if sbRotate.Down then
  begin
    EndAngle := ArcTan2(zbGrid.Y(Y),zbGrid.X(X));
    TempAngle := (Angle + EndAngle - StartAngle)*180/Pi;
    While TempAngle > 360 do
    begin
      TempAngle := TempAngle - 360;
    end;
    While TempAngle < 0 do
    begin
      TempAngle := TempAngle + 360;
    end;
    knobAngle.Position := TempAngle;
  end;
//  ResetOrigin;
  zbGrid.Invalidate;

end;

procedure TfrmEditGrid.FormDestroy(Sender: TObject);
begin
  inherited;
  RowPositions.Free;
  ColumnPositions.Free;
  ColumnCoordinates.Free;
  RowCoordinates.Free;
  SelectedColumn.Free;
  SelectedRow.Free;
  DomainOutline.Free;
  Density.Free;
  ColumnZones.Free;
  RowZones.Free;
//  OriginCoordinate.Free;
end;

procedure TfrmEditGrid.sbDeleteColRowClick(Sender: TObject);
begin
  inherited;
{  zbGrid.Cursor := crXCursor;
  zbGrid.PBCursor := crXCursor;
  zbGrid.SCursor := crXCursor;  }
  ShowSelectedColumn := False;
  ShowSelectedRow := False;
end;

{ TGridCoordinate }

function TRowGridCoordinate.ColumnPosition: double;
begin
  if frmEditGrid.ColumnPositions.Count <= 1 then
  begin
    if First then
    begin
      result := frmEditGrid.zbGrid.LeftMargin;
    end
    else
    begin
      result := frmEditGrid.zbGrid.PBWidth - frmEditGrid.zbGrid.RightMargin;
    end;
  end
  else
  begin
    result := inherited ColumnPosition;
  end;
end;

function TRowGridCoordinate.GetColIndex: integer;
begin
  if First then
  begin
    result := 0;
  end
  else
  begin
    result := frmEditGrid.ColumnPositions.Count -1
  end;
end;

function TRowGridCoordinate.GetRowIndex: integer;
begin
  result := FRowIndex;
end;

procedure TRowGridCoordinate.SetColIndex(const Value: integer);
begin
  raise Exception.Create('Can''t set column index');
end;

procedure TRowGridCoordinate.SetRowIndex(const Value: integer);
begin
  FRowIndex := Value;
end;


{ TColGridCoordinate }

function TColGridCoordinate.GetColIndex: integer;
begin
  result := FColIndex;
end;

function TColGridCoordinate.GetRowIndex: integer;
begin
  if First then
  begin
    result := 0;
  end
  else
  begin
    result := frmEditGrid.RowPositions.Count -1
  end;
end;

function TColGridCoordinate.RowPosition: double;
begin
  if frmEditGrid.RowPositions.Count <= 1 then
  begin
    if First then
    begin
      result := frmEditGrid.zbGrid.TopMargin;
    end
    else
    begin
      result := frmEditGrid.zbGrid.PBHeight - frmEditGrid.zbGrid.BottomMargin;
    end;
  end
  else
  begin
    result := inherited RowPosition;
  end;

end;

procedure TColGridCoordinate.SetColIndex(const Value: integer);
begin
  FColIndex := Value;

end;

procedure TColGridCoordinate.SetRowIndex(const Value: integer);
begin
  raise Exception.Create('Can''t set row index');
end;

function TfrmEditGrid.InterpolatedY(const X1, X2, X, Y1, Y2, Y : integer) : integer;
begin
  if (X2 = X1) then
  begin
    result := Y;
  end
  else
  begin
    result := Y1 + (Y2-Y1)*(X-X1) div (X2-X1);
  end;
end;

function TfrmEditGrid.CheckMinMax(const X, Y : integer;
  const CoordList : TObjectList; const Index : integer) : boolean;
const
  SelectionRange = 5;
var
  Coord1, Coord2 : TCustomGridCoordinate;
  MinValue, MaxValue, Temp : integer;
begin
  result := False;

  Coord1 := CoordList[Index*2] as TCustomGridCoordinate;
  Coord2 := CoordList[Index*2+1] as TCustomGridCoordinate;

  MinValue := Coord1.XCoord;
  Temp := Coord2.XCoord;
  if MinValue > Temp then
  begin
    MaxValue := MinValue;
    MinValue := Temp;
  end
  else
  begin
    MaxValue := Temp;
  end;
  Dec(MinValue,SelectionRange);
  Inc(MaxValue,SelectionRange);
  if (X > MaxValue) or (X < MinValue) then
  begin
    Exit;
  end;

  MinValue := Coord1.YCoord;
  Temp := Coord2.YCoord;
  if MinValue > Temp then
  begin
    MaxValue := MinValue;
    MinValue := Temp;
  end
  else
  begin
    MaxValue := Temp;
  end;
  Dec(MinValue,SelectionRange);
  Inc(MaxValue,SelectionRange);
  if (Y > MaxValue) or (Y < MinValue) then
  begin
    Exit;
  end;
  result := True;
end;

function TfrmEditGrid.SelectColumnLine(X, Y : integer) : integer;
var
  Index : integer;
  DegAngle : double;
  InterpolatedValue : integer;
  Coord1, Coord2 : TCustomGridCoordinate;
begin
  result := -1;
  X := X - XOffsetCoord;
  Y := Y - YOffsetCoord;
  for Index := 0 to (ColumnCoordinates.Count div 2) -1 do
  begin
    if not CheckMinMax(X, Y, ColumnCoordinates, Index) then
    begin
      Continue
    end;
    Coord1 := ColumnCoordinates[Index*2] as TCustomGridCoordinate;
    Coord2 := ColumnCoordinates[Index*2+1] as TCustomGridCoordinate;

    DegAngle := knobAngle.Position;
    While DegAngle > 135 do
    begin
      DegAngle := DegAngle -180;
    end;
    if DegAngle > 45 then
    begin
      InterpolatedValue := InterpolatedY(Coord1.XCoord, Coord2.XCoord,
        X, Coord1.YCoord, Coord2.YCoord, Y);
      If Abs(Y-InterpolatedValue) < SelectionRange then
      begin
        result := Index;
        Exit;
      end;
    end
    else
    begin
      InterpolatedValue := InterpolatedY(Coord1.YCoord, Coord2.YCoord,
        Y, Coord1.XCoord, Coord2.XCoord, X);
      If Abs(X-InterpolatedValue) < SelectionRange then
      begin
        result := Index;
        Exit;
      end;
    end;
  end;

end;


procedure TfrmEditGrid.zbGridPaint(Sender: TObject);
var
  Index : integer;
  Coordinate, AnotherCoordinate : TCustomGridCoordinate;
//  ZoomCoordinate : TRBWZoomPoint;
  OldColor : TColor;
  SelectedColumnRowCoordinates : array[0..3] of TPoint;
  IndexLarger, IndexSmaller : integer;
  TempAngle : double;
  TempX, TempY, distance, PointAngle : double;
  procedure Rotate;
  begin
    if TempAngle <> 0 then
    begin
      distance := Sqrt(Sqr(TempX)+Sqr(TempY));
      PointAngle := ArcTan2(TempY,TempX);
      TempX := distance*Cos(PointAngle+TempAngle);
      TempY := distance*Sin(PointAngle+TempAngle);
    end;
  end;
begin
  inherited;
  // draw selected columns
  if (sbColWidth.Down or sbSubdivide.Down) and (FirstSelectedColumnIndex > -1)
    and (LastSelectedColumnIndex > -1) then
  begin
    if FirstSelectedColumnIndex > LastSelectedColumnIndex then
    begin
      IndexSmaller := LastSelectedColumnIndex;
      IndexLarger := FirstSelectedColumnIndex;
    end
    else
    begin
      IndexSmaller := FirstSelectedColumnIndex;
      IndexLarger := LastSelectedColumnIndex;
    end;
    Coordinate := ColumnCoordinates[IndexSmaller*2] as TCustomGridCoordinate;
    SelectedColumnRowCoordinates[0].x := Coordinate.XCoord + XOffsetCoord;
    SelectedColumnRowCoordinates[0].Y := Coordinate.YCoord + YOffsetCoord;

    Coordinate := ColumnCoordinates[IndexSmaller*2+1] as TCustomGridCoordinate;
    SelectedColumnRowCoordinates[1].x := Coordinate.XCoord + XOffsetCoord;
    SelectedColumnRowCoordinates[1].Y := Coordinate.YCoord + YOffsetCoord;

    Coordinate := ColumnCoordinates[(IndexLarger+1)*2+1] as TCustomGridCoordinate;
    SelectedColumnRowCoordinates[2].x := Coordinate.XCoord + XOffsetCoord;
    SelectedColumnRowCoordinates[2].Y := Coordinate.YCoord + YOffsetCoord;

    Coordinate := ColumnCoordinates[(IndexLarger+1)*2] as TCustomGridCoordinate;
    SelectedColumnRowCoordinates[3].x := Coordinate.XCoord + XOffsetCoord;
    SelectedColumnRowCoordinates[3].Y := Coordinate.YCoord + YOffsetCoord;

    OldColor := zbGrid.PBCanvas.Brush.Color;
    try
      zbGrid.PBCanvas.Brush.Color := clGray;
      zbGrid.PBCanvas.Polygon(SelectedColumnRowCoordinates)

    finally
      zbGrid.PBCanvas.Brush.Color := OldColor;
    end;
  end;
  // draw selected rows
  if (sbRowHeight.Down or sbSubdivide.Down) and (FirstSelectedRowIndex > -1)
    and (LastSelectedRowIndex > -1) then
  begin
    if FirstSelectedRowIndex > LastSelectedRowIndex then
    begin
      IndexSmaller := LastSelectedRowIndex;
      IndexLarger := FirstSelectedRowIndex;
    end
    else
    begin
      IndexSmaller := FirstSelectedRowIndex;
      IndexLarger := LastSelectedRowIndex;
    end;
    Coordinate := RowCoordinates[IndexSmaller*2] as TCustomGridCoordinate;
    SelectedColumnRowCoordinates[0].x := Coordinate.XCoord + XOffsetCoord;
    SelectedColumnRowCoordinates[0].Y := Coordinate.YCoord + YOffsetCoord;

    Coordinate := RowCoordinates[IndexSmaller*2+1] as TCustomGridCoordinate;
    SelectedColumnRowCoordinates[1].x := Coordinate.XCoord + XOffsetCoord;
    SelectedColumnRowCoordinates[1].Y := Coordinate.YCoord + YOffsetCoord;

    Coordinate := RowCoordinates[(IndexLarger+1)*2+1] as TCustomGridCoordinate;
    SelectedColumnRowCoordinates[2].x := Coordinate.XCoord + XOffsetCoord;
    SelectedColumnRowCoordinates[2].Y := Coordinate.YCoord + YOffsetCoord;

    Coordinate := RowCoordinates[(IndexLarger+1)*2] as TCustomGridCoordinate;
    SelectedColumnRowCoordinates[3].x := Coordinate.XCoord + XOffsetCoord;
    SelectedColumnRowCoordinates[3].Y := Coordinate.YCoord + YOffsetCoord;

    OldColor := zbGrid.PBCanvas.Brush.Color;
    try
      zbGrid.PBCanvas.Brush.Color := clGray;
      zbGrid.PBCanvas.Polygon(SelectedColumnRowCoordinates)

    finally
      zbGrid.PBCanvas.Brush.Color := OldColor;
    end;
  end;
  // draw column lines
  for Index := 0 to ColumnCoordinates.Count -1 do
  begin
    Coordinate := ColumnCoordinates[Index] as TCustomGridCoordinate;
    if Odd(Index) then
    begin
      zbGrid.PBCanvas.LineTo(Coordinate.XCoord + XOffsetCoord,
        Coordinate.YCoord + YOffsetCoord);
    end
    else
    begin
      zbGrid.PBCanvas.MoveTo(Coordinate.XCoord + XOffsetCoord,
        Coordinate.YCoord + YOffsetCoord);
    end;
  end;
  // draw column lines for grid-centered grid
  if not BlockCenteredGrid then
  begin
    zbGrid.PBCanvas.Pen.Style := psDot;
    for Index := 0 to ColumnCoordinates.Count -3 do
    begin
      Coordinate := ColumnCoordinates[Index] as TCustomGridCoordinate;
      AnotherCoordinate := ColumnCoordinates[Index+2] as TCustomGridCoordinate;
      if Odd(Index) then
      begin
        zbGrid.PBCanvas.LineTo(zbGrid.XCoord((Coordinate.X + AnotherCoordinate.X)/2)+ XOffsetCoord,
          zbGrid.YCoord((Coordinate.Y + AnotherCoordinate.Y)/2)+ YOffsetCoord);
      end
      else
      begin
        zbGrid.PBCanvas.MoveTo(zbGrid.XCoord((Coordinate.X + AnotherCoordinate.X)/2)+ XOffsetCoord,
          zbGrid.YCoord((Coordinate.Y + AnotherCoordinate.Y)/2)+ YOffsetCoord);
      end;
    end;
    zbGrid.PBCanvas.Pen.Style := psSolid;
  end;

  // draw row lines
  for Index := 0 to RowCoordinates.Count -1 do
  begin
    Coordinate := RowCoordinates[Index] as TCustomGridCoordinate;
    if Odd(Index) then
    begin
      zbGrid.PBCanvas.LineTo(Coordinate.XCoord + XOffsetCoord,
        Coordinate.YCoord + YOffsetCoord);
    end
    else
    begin
      zbGrid.PBCanvas.MoveTo(Coordinate.XCoord + XOffsetCoord,
        Coordinate.YCoord + YOffsetCoord);
    end;
  end;
  // draw row lines for grid-centered grid
  if not BlockCenteredGrid then
  begin
    zbGrid.PBCanvas.Pen.Style := psDot;
    for Index := 0 to RowCoordinates.Count -3 do
    begin
      Coordinate := RowCoordinates[Index] as TCustomGridCoordinate;
      AnotherCoordinate := RowCoordinates[Index+2] as TCustomGridCoordinate;
      if Odd(Index) then
      begin
        zbGrid.PBCanvas.LineTo(zbGrid.XCoord((Coordinate.X + AnotherCoordinate.X)/2)+ XOffsetCoord,
          zbGrid.YCoord((Coordinate.Y + AnotherCoordinate.Y)/2)+ YOffsetCoord);
      end
      else
      begin
        zbGrid.PBCanvas.MoveTo(zbGrid.XCoord((Coordinate.X + AnotherCoordinate.X)/2)+ XOffsetCoord,
          zbGrid.YCoord((Coordinate.Y + AnotherCoordinate.Y)/2)+ YOffsetCoord);
      end;
    end;
    zbGrid.PBCanvas.Pen.Style := psSolid;
  end;

  // show grid outline
  if ShowOutline
    and (RowCoordinates.Count > 1) then
  begin
    if sbMove.Down then // Panning
    begin
      Coordinate := RowCoordinates[0] as TCustomGridCoordinate;
      zbGrid.PBCanvas.Pen.Color := clGray;
      try
        zbGrid.PBCanvas.MoveTo(Coordinate.XCoord+CurrentX-StartX + XOffsetCoord,
          Coordinate.YCoord+CurrentY-StartY + YOffsetCoord);

        Coordinate := RowCoordinates[1] as TCustomGridCoordinate;
        zbGrid.PBCanvas.LineTo(Coordinate.XCoord+CurrentX-StartX + XOffsetCoord,
          Coordinate.YCoord+CurrentY-StartY + YOffsetCoord);

        Coordinate := RowCoordinates[RowCoordinates.Count-1] as TCustomGridCoordinate;
        zbGrid.PBCanvas.LineTo(Coordinate.XCoord+CurrentX-StartX + XOffsetCoord,
          Coordinate.YCoord+CurrentY-StartY + YOffsetCoord);

        Coordinate := RowCoordinates[RowCoordinates.Count-2] as TCustomGridCoordinate;
        zbGrid.PBCanvas.LineTo(Coordinate.XCoord+CurrentX-StartX + XOffsetCoord,
          Coordinate.YCoord+CurrentY-StartY + YOffsetCoord);

        Coordinate := RowCoordinates[0] as TCustomGridCoordinate;
        zbGrid.PBCanvas.LineTo(Coordinate.XCoord+CurrentX-StartX + XOffsetCoord,
          Coordinate.YCoord+CurrentY-StartY + YOffsetCoord);

      finally
        zbGrid.PBCanvas.Pen.Color := clBlack;
      end;
    end
    else // rotating
    begin
      TempAngle := EndAngle - StartAngle;
      While TempAngle > Pi do
      begin
        TempAngle := TempAngle - 2*Pi;
      end;
      While TempAngle < - Pi do
      begin
        TempAngle := TempAngle + 2*Pi;
      end;

      Coordinate := RowCoordinates[0] as TCustomGridCoordinate;
      TempX := Coordinate.X;
      TempY := Coordinate.Y;
      Rotate;
      zbGrid.PBCanvas.Pen.Color := clGray;
      try
        zbGrid.PBCanvas.MoveTo(zbGrid.XCoord(TempX) + XOffsetCoord,
          zbGrid.YCoord(TempY) + YOffsetCoord);

        Coordinate := RowCoordinates[1] as TCustomGridCoordinate;
        TempX := Coordinate.X;
        TempY := Coordinate.Y;
        Rotate;
        zbGrid.PBCanvas.LineTo(zbGrid.XCoord(TempX) + XOffsetCoord,
          zbGrid.YCoord(TempY) + YOffsetCoord);

        Coordinate := RowCoordinates[RowCoordinates.Count-1] as TCustomGridCoordinate;
        TempX := Coordinate.X;
        TempY := Coordinate.Y;
        Rotate;
        zbGrid.PBCanvas.LineTo(zbGrid.XCoord(TempX) + XOffsetCoord,
          zbGrid.YCoord(TempY) + YOffsetCoord);

        Coordinate := RowCoordinates[RowCoordinates.Count-2] as TCustomGridCoordinate;
        TempX := Coordinate.X;
        TempY := Coordinate.Y;
        Rotate;
        zbGrid.PBCanvas.LineTo(zbGrid.XCoord(TempX) + XOffsetCoord,
          zbGrid.YCoord(TempY) + YOffsetCoord);

        Coordinate := RowCoordinates[0] as TCustomGridCoordinate;
        TempX := Coordinate.X;
        TempY := Coordinate.Y;
        Rotate;
        zbGrid.PBCanvas.LineTo(zbGrid.XCoord(TempX) + XOffsetCoord,
          zbGrid.YCoord(TempY) + YOffsetCoord);
      finally
        zbGrid.PBCanvas.Pen.Color := clBlack;
      end;
    end;
  end;

  // draw selected column line
  if ShowSelectedColumn then
  begin
    zbGrid.PBCanvas.Pen.Color := clGray;
    Assert(SelectedColumn.Count = 2);
    Coordinate := SelectedColumn[0] as TCustomGridCoordinate;
    zbGrid.PBCanvas.MoveTo(Coordinate.XCoord + XOffsetCoord,
      Coordinate.YCoord + YOffsetCoord);
    Coordinate := SelectedColumn[1] as TCustomGridCoordinate;
    zbGrid.PBCanvas.LineTo(Coordinate.XCoord + XOffsetCoord,
      Coordinate.YCoord + YOffsetCoord);
    zbGrid.PBCanvas.Pen.Color := clBlack;
  end;
  // draw selected row line
  if ShowSelectedRow then
  begin
    zbGrid.PBCanvas.Pen.Color := clGray;
    Assert(SelectedRow.Count = 2);
    Coordinate := SelectedRow[0] as TCustomGridCoordinate;
    zbGrid.PBCanvas.MoveTo(Coordinate.XCoord + XOffsetCoord,
      Coordinate.YCoord + YOffsetCoord);
    Coordinate := SelectedRow[1] as TCustomGridCoordinate;
    zbGrid.PBCanvas.LineTo(Coordinate.XCoord + XOffsetCoord,
      Coordinate.YCoord + YOffsetCoord);
    zbGrid.PBCanvas.Pen.Color := clBlack;
  end;

end;

{ TCustomGridCoordinate }

function TCustomGridCoordinate.ColumnPosition: double;
var
  Index : integer;
begin
  Index := ColIndex;
  if (Index < frmEditGrid.ColumnPositions.Count) and (Index >=0) then
  begin
    result := frmEditGrid.ColumnPositions[Index];
  end
  else
  begin
    result := 0;
  end;
end;

function TCustomGridCoordinate.GetX: extended;
begin
  Update;
  result := inherited X;
end;

function TCustomGridCoordinate.GetXCoord: Integer;
begin
  Update;
  result := inherited GetXCoord;
end;

function TCustomGridCoordinate.GetY: extended;
begin
  Update;
  result := inherited Y;
end;

function TCustomGridCoordinate.GetYCoord: Integer;
begin
  Update;
  result := inherited GetYCoord;
end;

function TCustomGridCoordinate.RowPosition: double;
var
  Index : integer;
begin
  Index := RowIndex;
  if (Index < frmEditGrid.RowPositions.Count) and (Index >=0) then
  begin
    result := frmEditGrid.RowPositions[Index];
  end
  else
  begin
    result := 0;
  end;
end;

procedure TfrmEditGrid.SetSelectedColRowPositions(X, Y : integer);
var
  DeltaX, DeltaY : double;
  PointAngle : double;
  Distance : double;
begin
  X := X - XOffsetCoord;
  Y := Y - YOffsetCoord;
  DeltaX := zbGrid.X(X);
  DeltaY := zbGrid.Y(Y);
  PointAngle := Angle - ArcTan2(DeltaY,DeltaX);
  Distance := Sqrt(Sqr(DeltaX) + Sqr(DeltaY));
  SelectedColumnPosition := Distance*Cos(PointAngle);
  SelectedRowPosition := -Distance*Sin(PointAngle);
end;

{procedure TCustomGridCoordinate.SetX(const Value: Extended);
begin
  inherited X := Value;
end;  }

{procedure TCustomGridCoordinate.SetXCoord(const AnX: Integer);
begin
  inherited XCoord := AnX;
end; }

{procedure TCustomGridCoordinate.SetY(const Value: Extended);
begin
  inherited Y := Value;
end;   }

{procedure TCustomGridCoordinate.SetYCoord(const AY: Integer);
begin
  inherited YCoord := AY;
end;  }

procedure TCustomGridCoordinate.Update;
var
  RotatedX, RotatedY, LengthToPoint, Angle : double;
begin
  RotatedX := ColumnPosition;
  RotatedY := RowPosition;
  if frmEditGrid.Angle <> 0 then
  begin
    LengthToPoint := Sqrt(Sqr(RotatedX) + Sqr(RotatedY));
    Angle := ArcTan2(RotatedY,RotatedX);
    Angle := Angle + frmEditGrid.Angle;
    RotatedX := LengthToPoint*Cos(Angle);
    RotatedY := LengthToPoint*Sin(Angle);
  end;
  X := RotatedX;
  Y := RotatedY;
end;

{ TCustomCoordinate }

{procedure TCustomCoordinate.Update;
var
  RotatedX, RotatedY, LengthToPoint, Angle : double;
begin
  RotatedX := ColumnPosition;
  RotatedY := RowPosition;
  LengthToPoint := Sqrt(Sqr(RotatedX) + Sqr(RotatedY));
  Angle := ArcTan2(RotatedY,RotatedX);
  Angle := Angle + frmEditGrid.Angle;
  RotatedX := LengthToPoint*Cos(Angle);
  RotatedY := LengthToPoint*Sin(Angle);
  X := RotatedX;
  Y := RotatedY;
end; }

{ TMoveableColCoordinate }


{ TMoveableColCoordinate }

function TMoveableColCoordinate.ColumnPosition: double;
begin
  result := frmEditGrid.SelectedColumnPosition;
end;

{ TMoveableRowCoordinate }

function TMoveableRowCoordinate.RowPosition: double;
begin
  result := frmEditGrid.SelectedRowPosition;
end;

function TfrmEditGrid.SelectRowLine(X, Y: integer): integer;
var
  Index : integer;
  DegAngle : double;
  InterpolatedValue : integer;
  Coord1, Coord2 : TCustomGridCoordinate;
begin
  result := -1;
  X := X - XOffsetCoord;
  Y := Y - YOffsetCoord;
  for Index := 0 to (RowCoordinates.Count div 2) -1 do
  begin
    if not CheckMinMax(X, Y, RowCoordinates, Index) then
    begin
      Continue
    end;
    Coord1 := RowCoordinates[Index*2] as TCustomGridCoordinate;
    Coord2 := RowCoordinates[Index*2+1] as TCustomGridCoordinate;

    DegAngle := knobAngle.Position;
    While DegAngle > 135 do
    begin
      DegAngle := DegAngle -180;
    end;
    if DegAngle < 45 then
    begin
      InterpolatedValue := InterpolatedY(Coord1.XCoord, Coord2.XCoord,
        X, Coord1.YCoord, Coord2.YCoord, Y);
      If Abs(Y-InterpolatedValue) < SelectionRange then
      begin
        result := Index;
        Exit;
      end;
    end
    else
    begin
      InterpolatedValue := InterpolatedY(Coord1.YCoord, Coord2.YCoord,
        Y, Coord1.XCoord, Coord2.XCoord, X);
      If Abs(X-InterpolatedValue) < SelectionRange then
      begin
        result := Index;
        Exit;
      end;
    end;
  end;
end;

function TfrmEditGrid.GetWidth(const ColOrRowPositionList: TRealList;
  const Index: integer): double;
begin
  Assert(Index <= ColOrRowPositionList.Count -2);
  result := ColOrRowPositionList[Index+1] - ColOrRowPositionList[Index];
end;

procedure TfrmEditGrid.SetWidth(const ColOrRowPositionList: TRealList;
  const Index: integer; const Value: double);
var
  OldWidth, DeltaWidth : double;
  PositionIndex : integer;
begin
  OldWidth := GetWidth(ColOrRowPositionList, Index);
  if OldWidth <> Value then
  begin
    DeltaWidth := OldWidth - Value;
    for PositionIndex := Index + 1 to ColOrRowPositionList.Count -1 do
    begin
      ColOrRowPositionList[Index] := ColOrRowPositionList[Index] - DeltaWidth
    end;
  end;
end;

function TfrmEditGrid.GetColumnWidth(const Index: integer): double;
begin
  result := GetWidth(ColumnPositions, Index)
end;

function TfrmEditGrid.GetRowHeight(const Index: integer): double;
begin
  result := GetWidth(RowPositions, Index)
end;

procedure TfrmEditGrid.SetColumnWidth(const Index: integer;
  const Value: double);
begin
  SetWidth(ColumnPositions, Index, Value);
end;

procedure TfrmEditGrid.SetRowHeight(const Index: integer;
  const Value: double);
begin
  SetWidth(RowPositions, Index, Value);
end;

function TfrmEditGrid.SelectColumnOrRow
  (const ColOrRowCoordinates: TObjectList; const X, Y: integer): integer;
var
  ListOfZoomPoints : TList;
  Index : integer;
  Outline : TZBArray;
begin
  result := -1;
//  ListOfZoomPoints := TList.Create;
  SetLength(Outline,5);
//  try
    for Index := 0 to (ColOrRowCoordinates.Count div 2) -2 do
    begin
//      ListOfZoomPoints.Clear;
      Outline[0] := ColOrRowCoordinates[Index*2] as TRbwZoomPoint;
      Outline[1] := ColOrRowCoordinates[Index*2+1] as TRbwZoomPoint;
      Outline[2] := ColOrRowCoordinates[Index*2+3] as TRbwZoomPoint;
      Outline[3] := ColOrRowCoordinates[Index*2+2] as TRbwZoomPoint;
      Outline[4] := ColOrRowCoordinates[Index*2] as TRbwZoomPoint;
      if zbGrid.IsPointInside(zbGrid.X(X),zbGrid.Y(Y),Outline) then
      begin
        Result := Index;
        Exit;
      end;
    end;
//  finally
//    ListOfZoomPoints.Free;
//  end;
end;

function TfrmEditGrid.SelectColumn(X, Y: integer): integer;
begin
  X := X - XOffsetCoord;
  Y := Y - YOffsetCoord;
  result := SelectColumnOrRow(ColumnCoordinates, X, Y);
end;

function TfrmEditGrid.SelectRow(X, Y: integer): integer;
begin
  X := X - XOffsetCoord;
  Y := Y - YOffsetCoord;
  result := SelectColumnOrRow(RowCoordinates, X, Y);
end;

procedure TfrmEditGrid.SetFirstSelectedColumnIndex(const Value: integer);
begin
  if FFirstSelectedColumnIndex <> Value then
  begin
    FFirstSelectedColumnIndex := Value;
    zbGrid.Invalidate;
  end;
end;

procedure TfrmEditGrid.SetFirstSelectedRowIndex(const Value: integer);
begin
  if FFirstSelectedRowIndex <> Value then
  begin
    FFirstSelectedRowIndex := Value;
    zbGrid.Invalidate;
  end;
end;

procedure TfrmEditGrid.SetLastSelectedColumnIndex(const Value: integer);
begin
  if FLastSelectedColumnIndex <> Value then
  begin
    FLastSelectedColumnIndex := Value;
    zbGrid.Invalidate;
  end;
end;

procedure TfrmEditGrid.SetLastSelectedRowIndex(const Value: integer);
begin
  if FLastSelectedRowIndex <> Value then
  begin
    FLastSelectedRowIndex := Value;
    zbGrid.Invalidate;
  end;
end;

procedure TfrmEditGrid.adeXOriginExit(Sender: TObject);
begin
  inherited;
  XOrigin := StrToFloat(adeXOrigin.Text);
end;

procedure TfrmEditGrid.adeYOriginExit(Sender: TObject);
begin
  inherited;
  YOrigin := StrToFloat(adeYOrigin.Text);

end;

procedure TfrmEditGrid.SetXOrigin(const Value: double);
begin
  if FXOrigin <> Value then
  begin
    XOffset := XOffset + Value - FXOrigin;
    FXOrigin := Value;
    adeXOrigin.Text := FloatToStr(Value);
  end;
end;

procedure TfrmEditGrid.SetYOrigin(const Value: double);
begin
  if FYOrigin <> Value then
  begin
    YOffset := YOffset + Value - FYOrigin;
    FYOrigin := Value;
    adeYOrigin.Text := FloatToStr(Value);
  end;
end;

procedure TfrmEditGrid.SetShowSelectedColumn(const Value: boolean);
begin
  if FShowSelectedColumn <> Value then
  begin
    FShowSelectedColumn := Value;
    zbGrid.Invalidate;
  end;
end;

procedure TfrmEditGrid.SetShowSelectedRow(const Value: boolean);
begin
  if FShowSelectedRow <> Value then
  begin
    FShowSelectedRow := Value;
    zbGrid.Invalidate;
  end;
end;

procedure TfrmEditGrid.SetShowOutline(const Value: boolean);
begin
  if FShowOutline <> Value then
  begin
    FShowOutline := Value;
    zbGrid.Invalidate;
  end;
end;

procedure TfrmEditGrid.SetSelectedColumnPosition(const Value: double);
begin
  if FSelectedColumnPosition <> Value then
  begin
    FSelectedColumnPosition := Value;
    if ShowSelectedColumn then
    begin
      zbGrid.Invalidate;
    end;
  end;
end;

procedure TfrmEditGrid.SetSelectedRowPosition(const Value: double);
begin
  if FSelectedRowPosition <> Value then
  begin
    FSelectedRowPosition := Value;
    if ShowSelectedRow then
    begin
      zbGrid.Invalidate;
    end;
  end;
end;

procedure TfrmEditGrid.btnOKClick(Sender: TObject);
begin
  inherited;
  SetGrid;
  Beep;
  MessageDlg('You are almost finished importing your grid.  '
  + 'You must do the last step manually.  '
  + 'Make the grid layer the active layer and click on the grid with '
  + 'the "Magic Wand" tool.  '
  + 'In the dialog box, click on the "Deactivate" button.  '
  + 'Then check to make sure that all cells whose centers are inside the grid '
  + 'have been deactivated properly.  '
  + 'If an active cell should be an inactive cell or vice versa, select that '
  + 'cell and then select "Edit|Toggle Active".  '
  , mtInformation, [mbOK], 0);
end;

{procedure TfrmEditGrid.ResetOrigin;
var
  Coordinate : TCustomGridCoordinate;
  DeltaX,DeltaY : double;
begin
{  if ColumnCoordinates.Count > 2 then
  begin
{    if RowsReversed and ColumnsReversed then
    begin
      Coordinate := ColumnCoordinates[ColumnCoordinates.Count-1] as TCustomGridCoordinate;
    end
    else if RowsReversed then
    begin
      Coordinate := ColumnCoordinates[1] as TCustomGridCoordinate;
    end
    else if ColumnsReversed then
    begin
      Coordinate := ColumnCoordinates[ColumnCoordinates.Count-2] as TCustomGridCoordinate;
    end
    else
    begin
      Coordinate := ColumnCoordinates[0] as TCustomGridCoordinate;
    end;
    DeltaX := OriginCoordinate.X;
    DeltaY := OriginCoordinate.Y;
    if DeltaX <> 0 then
    begin
      XOrigin := XOrigin + DeltaX;
    end;
    if DeltaY <> 0 then
    begin
      YOrigin := YOrigin + DeltaY;
    end;
  end;
end;   }

{ TOriginCoordinate }

function TOriginCoordinate.GetColIndex: integer;
begin
  if frmEditGrid.ColumnsReversed then
  begin
    result := frmEditGrid.ColumnPositions.Count - 1;
  end
  else
  begin
    result := 0;
  end;
end;

function TOriginCoordinate.GetRowIndex: integer;
begin
  if frmEditGrid.RowsReversed then
  begin
    result := frmEditGrid.RowPositions.Count - 1;
  end
  else
  begin  
    result := 0;
  end;
end;

procedure TOriginCoordinate.SetColIndex(const Value: integer);
begin
  inherited;
  raise Exception.Create('Can''t set row index');
end;

procedure TOriginCoordinate.SetRowIndex(const Value: integer);
begin
  inherited;
  raise Exception.Create('Can''t set row index');
end;

procedure TfrmEditGrid.sbSmoothClick(Sender: TObject);
const
  Epsilon = 1e-8;
  Max = 100;
var
  Index : integer;
  Criterion : double;
  Width1, Width2 : double;
  Changed : boolean;
  Factor1, Factor2 : double;
  Count : integer;
  MaxRatio, Ratio : double;
begin
  inherited;
  Criterion := StrToFloat(adeSmoothCriterion.Text);
  Factor2 := 1/(1+Criterion*(1-Epsilon))*(1+Epsilon);
  Factor1 := 1-Factor2;
  Count := 0;
  repeat
    Inc(Count);
    Changed := False;
    for Index := 1 to ColumnPositions.count -2 do
    begin
      Width1 := ColumnWidths[Index-1];
      Width2 := ColumnWidths[Index];
      if Width1/Width2  > Criterion  then
      begin
        ColumnPositions[Index] := ColumnPositions[Index-1] +
          Factor1*(Width1+Width2);
        Changed := True;
      end
      else if Width2/Width1 > Criterion then
      begin
        ColumnPositions[Index] := ColumnPositions[Index-1] +
          Factor2*(Width1+Width2);
        Changed := True;
      end;
    end;
    for Index := ColumnPositions.count -2 downto 1 do
    begin
      Width1 := ColumnWidths[Index-1];
      Width2 := ColumnWidths[Index];
      if Width1/Width2 > Criterion then
      begin
        ColumnPositions[Index] := ColumnPositions[Index-1] +
          Factor1*(Width1+Width2);
        Changed := True;
      end
      else if Width2/Width1 > Criterion then
      begin
        ColumnPositions[Index] := ColumnPositions[Index-1] +
          Factor2*(Width1+Width2);
        Changed := True;
      end;
    end;
  until not Changed or (Count >= Max);

  Count := 0;
  repeat
    Inc(Count);
    Changed := False;
    for Index := 1 to RowPositions.count -2 do
    begin
      Width1 := RowHeights[Index-1];
      Width2 := RowHeights[Index];
      if Width1/Width2 > Criterion then
      begin
        RowPositions[Index] := RowPositions[Index-1] +
          Factor1*(Width1+Width2);
        Changed := True;
      end
      else if Width2/Width1 > Criterion then
      begin
        RowPositions[Index] := RowPositions[Index-1] +
          Factor2*(Width1+Width2);
        Changed := True;
      end;
    end;
    for Index := RowPositions.count -2 downto 1 do
    begin
      Width1 := RowHeights[Index-1];
      Width2 := RowHeights[Index];
      if Width1/Width2 > Criterion then
      begin
        RowPositions[Index] := RowPositions[Index-1] +
          Factor1*(Width1+Width2);
        Changed := True;
      end
      else if Width2/Width1 > Criterion then
      begin
        RowPositions[Index] := RowPositions[Index-1] +
          Factor2*(Width1+Width2);
        Changed := True;
      end;
    end;
  until not Changed or (Count >= Max);
  MaxRatio := 0;
  for Index := 1 to ColumnPositions.count -2 do
  begin
    Width1 := ColumnWidths[Index-1];
    Width2 := ColumnWidths[Index];
    Ratio := Width1/Width2;
    if Ratio > MaxRatio then
    begin
      MaxRatio := Ratio;
    end;
    Ratio := Width2/Width1;
    if Ratio > MaxRatio then
    begin
      MaxRatio := Ratio;
    end;
  end;
  for Index := 1 to RowPositions.count -2 do
  begin
    Width1 := RowHeights[Index-1];
    Width2 := RowHeights[Index];
    Ratio := Width1/Width2;
    if Ratio > MaxRatio then
    begin
      MaxRatio := Ratio;
    end;
    Ratio := Width2/Width1;
    if Ratio > MaxRatio then
    begin
      MaxRatio := Ratio;
    end;
  end;
  if MaxRatio > Criterion then
  begin
    Beep;
    MessageDlg('The maximum ratio between adjacent rows or columns is now '
      + FloatToStr(MaxRatio) + '.  This is higher than the criterion you '
      + 'specified.  You can try smoothing the grid again '
      + 'to reduce this ratio further.', mtWarning, [mbOK], 0);
  end;

  zbGrid.Invalidate;
end;

procedure TfrmEditGrid.AssignHelpFile(FileName : string);
var
    DllDirectory : String;
begin
  // called by FormHelp

  // This procedure assigns the proper help file to the application.
  // It may be overridden in descendent classes.
  if GetDllDirectory(DLLName, DllDirectory )
  then
    begin
      HelpFile := DllDirectory + '\' + FileName; // MODFLOW.hlp';
    end
  else
    begin
      Beep;
      ShowMessage(DLLName + ' not found.');
    end;
end;

procedure TfrmEditGrid.sbGridPositionsClick(Sender: TObject);
var
  Index : Integer;
begin
  inherited;
  Application.CreateForm(TfrmRowColPositions,frmRowColPositions);
  try
    with frmRowColPositions.FrameColPosition do
    begin
      seCount.Value := ColumnPositions.Count;
      for Index := 0 to ColumnPositions.Count -1 do
      begin
        dgPositions.Cells[1,Index] := FloatToStr(ColumnPositions[Index]);
      end;
      dgPositions.FixedCols := 1;
    end;
    with frmRowColPositions.FrameRowPosition do
    begin
      seCount.Value := RowPositions.Count;
      for Index := 0 to RowPositions.Count -1 do
      begin
        dgPositions.Cells[1,Index] := FloatToStr(RowPositions[Index]);
      end;
      dgPositions.FixedCols := 1;
    end;
    if frmRowColPositions.ShowModal = mrOK then
    begin
      with frmRowColPositions.FrameColPosition do
      begin
        ColumnPositions.Clear;
        for Index := 0 to seCount.Value -1 do
        begin
          try
            ColumnPositions.Add(StrToFloat(dgPositions.Cells[1,Index]));
          except on EConvertError do
            begin
            end;
          end;
        end;
      end;
      with frmRowColPositions.FrameRowPosition do
      begin
        RowPositions.Clear;
        for Index := 0 to seCount.Value -1 do
        begin
          try
            RowPositions.Add(StrToFloat(dgPositions.Cells[1,Index]));
          except on EConvertError do
            begin
            end;
          end;
        end;
      end;
      MakeCoordinates;
      ResetPositions;
      sbZoomExtentsClick(sbZoomExtents);
    end;

  finally
    frmRowColPositions.Free;
    frmRowColPositions := nil;
  end;
end;

procedure TfrmEditGrid.MakeCoordinates;
var
  Index : integer;
  ColGridCoord : TColGridCoordinate;
  RowGridCoord : TRowGridCoordinate;
begin
  ColumnCoordinates.Clear;
  ColumnCoordinates.Capacity := ColumnPositions.Count * 2;
  for Index := 0 to ColumnPositions.Count -1 do
  begin
    ColGridCoord := TColGridCoordinate.Create(zbGrid);
    ColumnCoordinates.Add(ColGridCoord);
    ColGridCoord.ColIndex := Index;
    ColGridCoord.First := True;
    ColGridCoord.Update;

    ColGridCoord := TColGridCoordinate.Create(zbGrid);
    ColumnCoordinates.Add(ColGridCoord);
    ColGridCoord.ColIndex := Index;
    ColGridCoord.First := False;
    ColGridCoord.Update;
  end;

  RowCoordinates.Clear;
  RowCoordinates.Capacity := RowPositions.Count * 2;
  for Index := 0 to RowPositions.Count -1 do
  begin
    RowGridCoord := TRowGridCoordinate.Create(zbGrid);
    RowCoordinates.Add(RowGridCoord);
    RowGridCoord.RowIndex := Index;
    RowGridCoord.First := True;
    RowGridCoord.Update;

    RowGridCoord := TRowGridCoordinate.Create(zbGrid);
    RowCoordinates.Add(RowGridCoord);
    RowGridCoord.RowIndex := Index;
    RowGridCoord.First := False;
    RowGridCoord.Update;
  end;
end;

procedure TfrmEditGrid.sbGridWidthsClick(Sender: TObject);
var
  Index : Integer;
  Sum : double;
begin
  inherited;
  Application.CreateForm(TfrmRowColPositions,frmRowColPositions);
  try
    with frmRowColPositions.FrameColPosition do
    begin
      lblCount.Caption := 'Number of columns';
      seCount.Value := ColumnPositions.Count-1;
      for Index := 0 to ColumnPositions.Count -2 do
      begin
        dgPositions.Cells[1,Index] := FloatToStr(ColumnWidths[Index]);
      end;
      dgPositions.FixedCols := 1;
    end;
    with frmRowColPositions.FrameRowPosition do
    begin
      lblCount.Caption := 'Number of rows';
      seCount.Value := RowPositions.Count-1;
      for Index := 0 to RowPositions.Count -2 do
      begin
        dgPositions.Cells[1,Index] := FloatToStr(RowHeights[Index]);
      end;
      dgPositions.FixedCols := 1;
    end;
    if frmRowColPositions.ShowModal = mrOK then
    begin
      with frmRowColPositions.FrameColPosition do
      begin
        Sum := 0;
        ColumnPositions.Clear;
        ColumnPositions.Add(Sum);
        for Index := 0 to seCount.Value -1 do
        begin
          try
            Sum := Sum + StrToFloat(dgPositions.Cells[1,Index]);
            ColumnPositions.Add(Sum);
          except on EConvertError do
            begin
            end;
          end;
        end;
      end;
      with frmRowColPositions.FrameRowPosition do
      begin
        Sum := 0;
        RowPositions.Clear;
        RowPositions.Add(Sum);
        for Index := 0 to seCount.Value -1 do
        begin
          try
            Sum := Sum + StrToFloat(dgPositions.Cells[1,Index]);
            RowPositions.Add(Sum);
          except on EConvertError do
            begin
            end;
          end;
        end;
      end;
      MakeCoordinates;
      ResetPositions;
      sbZoomExtentsClick(sbZoomExtents);
    end;

  finally
    frmRowColPositions.Free;
    frmRowColPositions := nil;
  end;
end;

function TfrmEditGrid.GetOriginCoordinate: TCustomGridCoordinate;
begin
  result := nil;
  if ColumnCoordinates.Count > 2 then
  begin

{    if RowsReversed and ColumnsReversed then
    begin
      result := ColumnCoordinates[ColumnCoordinates.Count-1] as TCustomGridCoordinate;
    end
    else if RowsReversed then
    begin
      result := ColumnCoordinates[1] as TCustomGridCoordinate;
    end
    else if ColumnsReversed then
    begin
      result := ColumnCoordinates[ColumnCoordinates.Count-2] as TCustomGridCoordinate;
    end
    else
    begin
      result := ColumnCoordinates[0] as TCustomGridCoordinate;
    end;  }

    result := ColumnCoordinates[0] as TCustomGridCoordinate;
  end;
end;

function TfrmEditGrid.XOffsetCoord: integer;
begin
  result := zbGrid.XCoord(XOffset) - zbGrid.XCoord(0)
end;

function TfrmEditGrid.YOffsetCoord: integer;
begin
  result := zbGrid.YCoord(YOffset) - zbGrid.YCoord(0)
end;

procedure TfrmEditGrid.btnAboutClick(Sender: TObject);
begin
  inherited;
  Application.CreateForm(TfrmAbout, frmAbout);
  try
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;

end;

function TfrmEditGrid.ReadDomainOutlineAndDensity : boolean;
var
  ContinueReading : boolean;
  DomainLayerName, DensityLayerName : string;
  ALayer : TLayerOptions;
  Index : ANE_INT32;
  Contour : TEditGridContour;
  ContourObject : TContourObjectOptions;
begin
  result := False;
  FreeAndNil(DomainOutline);
  FreeAndNil(Density);
  Application.CreateForm(TfrmGetLayerNames, frmGetLayerNames);
  try
    frmGetLayerNames.CurrentModelHandle := CurrentModelHandle;
    frmGetLayerNames.GetData;
    ContinueReading := frmGetLayerNames.ShowModal = mrOK;
    if not ContinueReading then Exit;
    DomainLayerName := frmGetLayerNames.comboDomainOutline.Text;
    DensityLayerName := frmGetLayerNames.comboDensity.Text;
  finally
    frmGetLayerNames.Free;
  end;
  ContinueReading := (DomainLayerName <> '') and (DensityLayerName <> '');
  if not ContinueReading then
  begin
    Beep;
    MessageDlg('Either no Domain Outline or no Density layer was selected.',
      mtError, [mbOK], 0);
    Exit;
  end;
  ALayer := TLayerOptions.CreateWithName(DomainLayerName,CurrentModelHandle);
  try
    ReadArgusContours(ALayer.Text[CurrentModelHandle],
      TEditGridContour,TEditGridPoint);
    DomainOutline := TObjectList.Create;
    DomainOutline.Capacity := ContourList.Count;
    for Index := 0 to ContourList.Count -1 do
    begin
      Contour := ContourList[Index];
      DomainOutline.Add(Contour);
      ContourObject := TContourObjectOptions.Create(CurrentModelHandle,
        ALayer.LayerHandle, Index);
      try
        Contour.GridDensity := ContourObject.
          GetFloatParameter(CurrentModelHandle,0);
      finally
        ContourObject.Free;
      end;
    end;
    ContourList.Clear;
    KillContourList;
  finally
    ALayer.Free(CurrentModelHandle);
  end;
  ALayer := TLayerOptions.CreateWithName(DensityLayerName,CurrentModelHandle);
  try
    ReadArgusContours(ALayer.Text[CurrentModelHandle],
      TEditGridContour,TEditGridPoint);
    Density := TObjectList.Create;
    Density.Capacity := ContourList.Count;
    for Index := 0 to ContourList.Count -1 do
    begin
      Contour := ContourList[Index];
      Density.Add(Contour);
      ContourObject := TContourObjectOptions.Create(CurrentModelHandle,
        ALayer.LayerHandle, Index);
      try
        Contour.GridDensity := ContourObject.
          GetFloatParameter(CurrentModelHandle,0);
      finally
        ContourObject.Free;
      end;
    end;
    ContourList.Clear;
    KillContourList;
  finally
    ALayer.Free(CurrentModelHandle);
  end;
  if DomainOutline.Count = 0 then
  begin
    Beep;
    MessageDlg('There are no contours on the domain outline layer named "'
      + DomainLayerName + '".', mtError, [mbOK], 0);
    Exit;
  end;
  result := True;
end;

{ TEditGridPoint }

constructor TEditGridPoint.Create;
begin
  inherited Create;
  UseForZoomOut := False;
end;

procedure TEditGridPoint.Draw;
begin
  // do nothing
end;

class function TEditGridPoint.GetZoomBox: TRBWZoomBox;
begin
  result := frmEditGrid.zbGrid;
end;

{ TEditGridContour }

procedure TEditGridContour.Draw;
begin
  // do nothing
end;

procedure TEditGridContour.RotatePoints;
var
  Index : integer;
  APoint : TEditGridPoint;
  X, Y : double;
  Limit : integer;
begin
  Limit := PointCount -1;
  if PointValues[0] = PointValues[Limit] then
  begin
    Dec(Limit);
  end;
  for index := 0 to Limit do
  begin
    APoint := PointValues[index] as TEditGridPoint;
    X := APoint.X;
    Y := APoint.Y;
    RotatePointsToGrid(X, Y, frmEditGrid.Angle);
    APoint.X := X;
    APoint.Y := Y;
  end;
end;

procedure TfrmEditGrid.RotateDomainOutlineAndDensity;
var
  Index : integer;
  AContour : TEditGridContour;
begin
  if Angle <> 0 then
  begin
    for Index := 0 to DomainOutline.Count -1 do
    begin
      AContour := DomainOutline[Index] as TEditGridContour;
      AContour.RotatePoints;
    end;
    for Index := 0 to Density.Count -1 do
    begin
      AContour := Density[Index] as TEditGridContour;
      AContour.RotatePoints;
    end;
  end;
end;

procedure TfrmEditGrid.CreateZones;
var
  AZone: TZone;
  MinX, MinY, MaxX, MaxY : double;
  DomainMinX, DomainMinY, DomainMaxX, DomainMaxY : double;
  ContourIndex : integer;
  Contour : TEditGridContour;
  PointIndex : integer;
  APoint : TEditGridPoint;
  ZoneIndex : integer;
begin
  FreeAndNil(ColumnZones);
  FreeAndNil(RowZones);
  ColumnZones := TObjectList.Create;
  RowZones := TObjectList.Create;
  for ContourIndex := 0 to DomainOutline.Count -1 do
  begin
    Contour := DomainOutline[ContourIndex] as TEditGridContour;
    if Contour.PointCount > 1 then
    begin
      APoint := Contour.PointValues[0] as TEditGridPoint;
      MinX := APoint.X;
      MinY := APoint.Y;
      MaxX := MinX;
      MaxY := MinY;
      for PointIndex := 1 to Contour.PointCount -1 do
      begin
        APoint := Contour.PointValues[PointIndex] as TEditGridPoint;
        if APoint.X > MaxX then
        begin
          MaxX := APoint.X
        end;
        if APoint.Y > MaxY then
        begin
          MaxY := APoint.Y
        end;
        if APoint.X < MinX then
        begin
          MinX := APoint.X
        end;
        if APoint.Y < MinY then
        begin
          MinY := APoint.Y
        end;
      end;
      if MaxX <> MinX then
      begin
        AZone := TZone.Create;
        AZone.LowerLimit := MinX;
        AZone.UpperLimit := MaxX;
        AZone.DesiredCellSize := Contour.GridDensity;
        ColumnZones.Add(AZone);
      end;
      if MaxY <> MinY then
      begin
        AZone := TZone.Create;
        AZone.LowerLimit := MinY;
        AZone.UpperLimit := MaxY;
        AZone.DesiredCellSize := Contour.GridDensity;
        RowZones.Add(AZone);
      end;
    end;

  end;
  if ColumnZones.Count > 0 then
  begin
    AZone := ColumnZones[0] as TZone;
    DomainMinX := AZone.LowerLimit;
    DomainMaxX := AZone.UpperLimit;
    for ZoneIndex := 1 to ColumnZones.Count -1 do
    begin
      AZone := ColumnZones[ZoneIndex] as TZone;
      if AZone.UpperLimit > DomainMaxX then
      begin
        DomainMaxX := AZone.UpperLimit
      end;
      if AZone.LowerLimit < DomainMinX then
      begin
        DomainMinX := AZone.LowerLimit
      end;
    end;
  end;
  if RowZones.Count > 0 then
  begin
    AZone := RowZones[0] as TZone;
    DomainMinY := AZone.LowerLimit;
    DomainMaxY := AZone.UpperLimit;
    for ZoneIndex := 1 to RowZones.Count -1 do
    begin
      AZone := RowZones[ZoneIndex] as TZone;
      if AZone.UpperLimit > DomainMaxY then
      begin
        DomainMaxY := AZone.UpperLimit
      end;
      if AZone.LowerLimit < DomainMinY then
      begin
        DomainMinY := AZone.LowerLimit
      end;
    end;
  end;
  for ContourIndex := 0 to Density.Count -1 do
  begin
    Contour := Density[ContourIndex] as TEditGridContour;
    if Contour.PointCount > 1 then
    begin
      APoint := Contour.PointValues[0] as TEditGridPoint;
      MinX := APoint.X;
      MinY := APoint.Y;
      MaxX := MinX;
      MaxY := MinY;
      for PointIndex := 1 to Contour.PointCount -1 do
      begin
        APoint := Contour.PointValues[PointIndex] as TEditGridPoint;
        if APoint.X > MaxX then
        begin
          MaxX := APoint.X
        end;
        if APoint.Y > MaxY then
        begin
          MaxY := APoint.Y
        end;
        if APoint.X < MinX then
        begin
          MinX := APoint.X
        end;
        if APoint.Y < MinY then
        begin
          MinY := APoint.Y
        end;
      end;

      if MaxX > DomainMaxX then
      begin
        MaxX := DomainMaxX;
      end;
      if MaxX < DomainMinX then
      begin
        MaxX := DomainMinX;
      end;
      if MinX > DomainMaxX then
      begin
        MinX := DomainMaxX;
      end;
      if MinX < DomainMinX then
      begin
        MinX := DomainMinX;
      end;

      if MaxY > DomainMaxY then
      begin
        MaxY := DomainMaxY;
      end;
      if MaxY < DomainMinY then
      begin
        MaxY := DomainMinY;
      end;
      if MinY > DomainMaxY then
      begin
        MinY := DomainMaxY;
      end;
      if MinY < DomainMinY then
      begin
        MinY := DomainMinY;
      end;


      if MaxX <> MinX then
      begin
        AZone := TZone.Create;
        AZone.LowerLimit := MinX;
        AZone.UpperLimit := MaxX;
        AZone.DesiredCellSize := Contour.GridDensity;
        ColumnZones.Add(AZone);
      end;
      if MaxY <> MinY then
      begin
        AZone := TZone.Create;
        AZone.LowerLimit := MinY;
        AZone.UpperLimit := MaxY;
        AZone.DesiredCellSize := Contour.GridDensity;
        RowZones.Add(AZone);
      end;
    end;
  end;
  SortZoneList(ColumnZones);
  SortZoneList(RowZones);
end;

procedure TfrmEditGrid.SortZoneList(const ZoneList : TObjectList);
var
  ZoneIndex, InnerZoneIndex : integer;
  Subdivided : boolean;
  AZone, Zone1, Zone2 : TZone;
begin
  repeat
    ZoneList.Sort(SortZones);
    Subdivided := False;
    for ZoneIndex := 0 to ZoneList.Count -2 do
    begin
      Zone1 := ZoneList[ZoneIndex] as TZone;
      for InnerZoneIndex := ZoneIndex + 1 to ZoneList.Count -1 do
      begin
        Zone2 := ZoneList[InnerZoneIndex] as TZone;

        if Zone2.LowerLimit >= Zone1.UpperLimit then
        begin
          break;
        end
        else if (Zone1.UpperLimit >= Zone2.UpperLimit)
          and (Zone1.DesiredCellSize <= Zone2.DesiredCellSize) then
        begin
          ZoneList.Delete(InnerZoneIndex);
          Subdivided := True;
          break;
        end
        else
        begin
          AZone := TZone.Create;
          ZoneList.Add(AZone);
          AZone.LowerLimit := Zone1.LowerLimit;
          AZone.UpperLimit := Zone2.LowerLimit;
          AZone.DesiredCellSize := Zone1.DesiredCellSize;
          if Zone1.DesiredCellSize < Zone2.DesiredCellSize then
          begin
            AZone.UpperLimit := Zone1.UpperLimit;
            Zone2.LowerLimit := AZone.UpperLimit;
          end;
          Subdivided := true;
          if Zone1.UpperLimit > Zone2.UpperLimit then
          begin
            AZone := TZone.Create;
            ZoneList.Add(AZone);
            AZone.LowerLimit := Zone2.UpperLimit;
            AZone.UpperLimit := Zone1.UpperLimit;
            AZone.DesiredCellSize := Zone1.DesiredCellSize;
          end;
          ZoneList.Delete(ZoneIndex);
          break;
        end;
      end;
      if Subdivided then break;
    end;
  until not Subdivided;
  for ZoneIndex := ZoneList.Count - 2 downto 0 do
  begin
    Zone1 := ZoneList[ZoneIndex] as TZone;
    Zone2 := ZoneList[ZoneIndex+1] as TZone;
    if Zone1.DesiredCellSize = Zone2.DesiredCellSize then
    begin
      Zone1.UpperLimit := Zone2.UpperLimit;
      ZoneList.Delete(ZoneIndex+1);
    end;
  end;
end;

procedure TfrmEditGrid.CreateCells(const ZoneList : TObjectList;
  const Positions : TRealList);
var
  Index, InnerIndex : integer;
  Capacity : integer;
  AZone : TZone;
  Limit : integer;
  function GetLimit : integer;
  var
    DoubleLimit : double;
  begin
    DoubleLimit := (AZone.UpperLimit - AZone.LowerLimit)
      /AZone.DesiredCellSize;
    if Trunc(DoubleLimit) = DoubleLimit then
    begin
      result := Trunc(DoubleLimit)
    end
    else
    begin
      result := Trunc(DoubleLimit) + 1;
    end;
  end;
  function GetPosition : double;
  begin
    if InnerIndex = Limit then
    begin
      result := AZone.UpperLimit;
    end
    else
    begin
      result := InnerIndex/Limit*(AZone.UpperLimit-AZone.LowerLimit)
        + AZone.LowerLimit;
    end;

  end;
begin
  Capacity := 1;
  for Index := 0 to ZoneList.Count -1 do
  begin
    AZone := ZoneList[Index] as TZone;
    Capacity := Capacity + GetLimit;
  end;
  Positions.Clear;
  Positions.Capacity := Capacity;
  for Index := 0 to ZoneList.Count -1 do
  begin
    AZone := ZoneList[Index] as TZone;
    if Index = 0 then
    begin
      Positions.Add(AZone.LowerLimit);
    end;
    Limit := GetLimit;
    for InnerIndex := 1 to Limit do
    begin
      Positions.Add(GetPosition);
    end;
  end;
end;

procedure TfrmEditGrid.UpdateCoordinates;
var
  Index : integer;
  Coord : TCustomGridCoordinate;
begin
  for Index := 0 to SelectedColumn.Count -1 do
  begin
    Coord := SelectedColumn[Index] as TCustomGridCoordinate;
    Coord.Update;
  end;
  for Index := 0 to SelectedRow.Count -1 do
  begin
    Coord := SelectedRow[Index] as TCustomGridCoordinate;
    Coord.Update;
  end;
  for Index := 0 to ColumnCoordinates.Count -1 do
  begin
    Coord := ColumnCoordinates[Index] as TCustomGridCoordinate;
    Coord.Update;
  end;
  for Index := 0 to RowCoordinates.Count -1 do
  begin
    Coord := RowCoordinates[Index] as TCustomGridCoordinate;
    Coord.Update;
  end;
end;

procedure TfrmEditGrid.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  if ReadDomainOutlineAndDensity then
  begin
    XOffSet := 0;
    YOffSet := 0;
    XOrigin := 0;
    YOrigin := 0;
    ColumnPositions.Clear;
    RowPositions.Clear;
    ColumnCoordinates.Clear;
    RowCoordinates.Clear;

    RotateDomainOutlineAndDensity;
    CreateZones;
    CreateCells(ColumnZones,ColumnPositions);
    CreateCells(RowZones,RowPositions);
    ColumnCoordinates.Capacity := ColumnPositions.Count*2;
    RowCoordinates.Capacity := RowPositions.Count*2;
    MakeCoordinates;
    ResetPositions;
    ResetSelectedRowColPositions;
    sbSmoothClick(nil);
    UpdateCoordinates;
    sbZoomExtentsClick(nil);
  end;
end;

{ TZone }

procedure TZone.SetDesiredCellSize(const Value: double);
begin
  if Value <= 0 then
  begin
    FDesiredCellSize := 1;
  end
  else
  begin
    FDesiredCellSize := Value;
  end;
end;

end.



