unit frmImportCrossSectionUnit;

interface

uses
  Windows, Messages, SysUtils,
  {$IFDEF VER190}
  Variants,
  {$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, Anepie, ARGUSFORMUNIT, ExtCtrls, RbwZoomBox, Grids, RbwDataGrid2,
  ComCtrls, StdCtrls, XBase1, FiniteElemInterp, RangeTreeUnit, Spin, Buttons,
  ArgusDataEntry;

type
  EInterpolateException = class(Exception);
  EInvalidLocation = class(Exception);

type
  TDoubleArray = array[0..MAXINT div 16] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = array[0..MAXINT div 8] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..MAXINT div 8] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;

  TDoubArray2 = array[0..1] of double;

  TCrossSecLoc = (cslName, cslStartX, cslStartY, cslEndX, cslEndY);

  TCrossSecChoice = (cscLower, cscUpper);

  TInterpolator = class(TObject)
  private
    FXCoordinates: TDoubArray4;
    FYCoordinates: TDoubArray4;
    FZValues: TDoubArray4;
  public
    function InBlock(const X, Y: double): boolean;
    function InterpolatedValue(const X, Y: double): double;
    property XCoordinates: TDoubArray4 read FXCoordinates write FXCoordinates;
    property YCoordinates: TDoubArray4 read FYCoordinates write FYCoordinates;
    property ZValues: TDoubArray4 read FZValues write FZValues;
  end;

  TInterpolatorList = class(TObject)
  private
    FFindList: TList;
    FList: TList;
    FLocations: TLocationArray;
    FRangeTree: TRbwRangeTree;
    FSorted: boolean;
    FName: string;
    FStoredResult: TInterpolator;
    function GetCapacity: integer;
    function GetCount: integer;
    function GetItem(const Index: integer): TInterpolator;
    procedure SetCapacity(const Value: integer);
  protected
    function Find(const X, Y: double): TInterpolator;
    property Items[const Index: integer]: TInterpolator read GetItem; default;
    procedure Sort;
  public
    function Add: TInterpolator;
    property Capacity: integer read GetCapacity write SetCapacity;
    procedure Clear;
    property Count: integer read GetCount;
    constructor Create;
    destructor Destroy; override;
    function InterpolatedValue(const X, Y: double; out Value: double): Boolean;
    property Name: string read FName write FName;
  end;

  TCrossSection = class;

  TCrossSectionLine = class(TObject)
  private
    FCapacity: integer;
    FCount: integer;
    FCrossSectionX: array of double;
    FLineName: string;
    FZLocations: array of double;
    FSection: TCrossSection;
    FLowerZoomPoints: TList;
    FUpperZoomPoints: TList;
    FLowerArray: TZBArray;
    FUpperArray: TZBArray;
    FStoredMinZ: boolean;
    FStoredMaxZ: boolean;
    FMaxZ: double;
    FMinZ: double;
    Function GetFraction(const Index: Integer): double;
    function GetXLocations(Index: integer): double;
    function GetYLocations(Index: integer): double;
    procedure SetCapacity(const Value: integer);
    function GetLowerZoomPoints(Index: integer): TRbwZoomPoint;
    function GetUpperZoomPoints(Index: integer): TRbwZoomPoint;
    procedure FindClosestNodes(const CrossX: double; out LowerI,
      UpperI: integer);
    procedure EnsureLowerZoomPoints;
    procedure EnsureUpperZoomPoints;
    function GetZLocations(Index: integer): double;
    procedure GetPointFromCrossX(CrossX: double; out X, Y, Z: double);
    function GetMaxZ: double;
    function GetMinZ: double;
  protected
    property Capacity: integer read FCapacity write SetCapacity;
  public
    Procedure AddPoint(Const  CrossX, Z: double);
    property Count: integer read FCount;
    constructor Create;
    Destructor Destroy; override;
    procedure GetPointAt2DTop(const DistanceFromStart: double;
      out X, Y, Z, CrossX: double);
    procedure GetPointAt2DSide(const DistanceFromStart: double;
      out X, Y, Z, CrossX: double);
    procedure GetPointAt3D(const DistanceFromStart: double;
      out X, Y, Z, CrossX: double);
    function GetLowerZFromCrossX(const CrossX: double): double;
    function GetUpperZFromCrossX(const CrossX: double): double;
    procedure Grow;
    procedure InvalidateZoomPoints;
    property LineName: string read FLineName write FLineName;
    function Select(const X, Y: integer; const WhichLine: TCrossSecChoice;
      out CrossX: double): boolean;
    Function TwoDLengthSide: double;
    Function TwoDLengthTop: double;
    function ThreeDLength: double;
    property XLocations[Index: integer]: double read GetXLocations;
    property YLocations[Index: integer]: double read GetYLocations;
    property ZLocations[Index: integer]: double read GetZLocations;
    property LowerZoomPoints[Index: integer]: TRbwZoomPoint read GetLowerZoomPoints;
    property UpperZoomPoints[Index: integer]: TRbwZoomPoint read GetUpperZoomPoints;
    property MinZ: double read GetMinZ;
    property MaxZ: double read GetMaxZ;
  end;

  TCrossSection = class(TObject)
  private
    FLines: TStringList;
    FEndX: double;
    FEndY: double;
    FSectionName: string;
    FStoredResult: TCrossSectionLine;
    FStartX: double;
    FStartY: double;
    FProfileZoomBox: TRbwZoomBox;
    FMapZoomBox: TRbwZoomBox;
    FStartPoint: TRbwZoomPoint;
    FEndPoint: TRbwZoomPoint;
    function GetCount: integer;
    function GetLength: double;
    function GetSectionLineByIndex(const Index: integer): TCrossSectionLine;
    function GetSectionLinesByName(const Name: string): TCrossSectionLine;
    function GetEndPoint: TRbwZoomPoint;
    function GetStartPoint: TRbwZoomPoint;
    procedure SetStartX(const Value: double);
    procedure SetStartY(const Value: double);
    procedure SetEndX(const Value: double);
    procedure SetEndY(const Value: double);
  public
    function AddLine(const Name: string): TCrossSectionLine;
    procedure Clear;
    property Count: integer read GetCount;
    Constructor Create(ProfileZoomBox, MapZoomBox: TRbwZoomBox);
    Destructor Destroy; override;
    property EndX: double read FEndX write SetEndX;
    property EndY: double read FEndY write SetEndY;
    procedure InvalidateZoomPoints;
    property Length: double read GetLength;
    property SectionLineByIndex[const Index: integer]: TCrossSectionLine
      read GetSectionLineByIndex;
    property SectionLinesByName[const Name: string]: TCrossSectionLine
      read GetSectionLinesByName;
    property SectionName: string read FSectionName;
    property StartPoint: TRbwZoomPoint read GetStartPoint;
    property EndPoint: TRbwZoomPoint read GetEndPoint;
    property StartX: double read FStartX write SetStartX;
    property StartY: double read FStartY write SetStartY;
  end;

  TCrossSections = class(TObject)
  private
    FSections: TStringList;
    FStoredResult: TCrossSection;
    FProfileZoomBox: TRbwZoomBox;
    FMapZoomBox: TRbwZoomBox;
    function GetCount: integer;
    function GetSectionByIndex(const Index: integer): TCrossSection;
    function GetSectionByName(const Name: string): TCrossSection;
  public
    function Add(const Name: string): TCrossSection;
    procedure Clear;
    property Count: integer read GetCount;
    constructor Create(ProfileZoomBox, MapZoomBox: TRbwZoomBox);
    destructor Destroy; override;
    procedure InvalidateZoomPoints;
    property SectionByIndex[const Index: integer]: TCrossSection
      read GetSectionByIndex;
    property SectionByName[const Name: string]: TCrossSection
      read GetSectionByName;
  end;

  TPosition = class(TPersistent)
  private
    FUpperZ: double;
    FCrossX: double;
    FSection: string;
    FLowerZ: double;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Section: string read FSection write FSection;
    property CrossX: double read FCrossX write FCrossX;
    property LowerZ: double read FLowerZ write FLowerZ;
    property UpperZ: double read FUpperZ write FUpperZ;
  end;

  TConnectingLine = class(TComponent)
  private
    FLine: string;
    FStartPosition: TPosition;
    FEndPosition: TPosition;
    Valid: boolean;
    UserGenerated: boolean;
    procedure SetEndPosition(const Value: TPosition);
    procedure SetStartPosition(const Value: TPosition);
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
  published
    property Line: string read FLine write FLine;
    property StartPosition: TPosition read FStartPosition write SetStartPosition;
    property EndPosition: TPosition read FEndPosition write SetEndPosition;
  end;

  TConnectingLines = class(TObject)
  private
    List: TList;
    function GetCount: integer;
    function GetItems(const Index: integer): TConnectingLine;
  public
    Function Add(Item: TConnectingLine): integer;
    procedure Clear;
    property Count: integer read GetCount;
    property Items[const Index: integer]: TConnectingLine read GetItems; default;
    constructor Create;
    procedure Delete(Index: Integer);
    Destructor Destroy; override;
  end;

  TfrmImportCrossSection = class(TArgusForm)
    zbCrossSections: TRbwZoomBox;
    Panel1: TPanel;
    pcMain: TPageControl;
    tabGraphical: TTabSheet;
    tabCrossSectionLocations: TTabSheet;
    rdg2Locations: TRbwDataGrid2;
    xbaseShapeFiles: TXBase;
    Panel2: TPanel;
    Label1: TLabel;
    Panel3: TPanel;
    Label2: TLabel;
    comboLowerCrossSec: TComboBox;
    Label3: TLabel;
    comboUpperCrossSec: TComboBox;
    comboLines: TComboBox;
    Label4: TLabel;
    btnNext: TBitBtn;
    tabInterpolate: TTabSheet;
    Panel4: TPanel;
    zbMap: TRbwZoomBox;
    Label5: TLabel;
    adeDelta: TArgusDataEntry;
    btnSelect: TSpeedButton;
    btnDelete: TSpeedButton;
    comboLines2: TComboBox;
    Label6: TLabel;
    btnBack: TBitBtn;
    BitBtn1: TBitBtn;
    btnApply: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    btnLoad: TButton;
    btnSave: TButton;
    procedure btnLoadClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure comboLines2Change(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure zbMapResize(Sender: TObject);
    procedure zbMapPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject); override;
    procedure FormCreate(Sender: TObject);  override;
    function GetInterpolator(const Name: String): TInterpolatorList;
    procedure btnDeleteClick(Sender: TObject);
    procedure zbCrossSectionsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zbCrossSectionsResize(Sender: TObject);
    procedure comboLinesChange(Sender: TObject);
    procedure comboUpperCrossSecChange(Sender: TObject);
    procedure comboLowerCrossSecChange(Sender: TObject);
    procedure zbCrossSectionsPaint(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
  private
    CrossSections: TCrossSections;
    FileNames: TStringList;
    SectionNames: TStringList;
    Parameters: TStringList;
    LineIds: TStringList;
    CurrentLine: TConnectingLine;
    ConnectingLines: TConnectingLines;
    Interpolators: TStringList;
    LastInterpolatorList: TInterpolatorList;
    Saved: boolean;
    procedure GetData(const FileNames, SectionNames, Parameters: TStringList);
    procedure CreateCrossSections;
    procedure CreateCrossSection(const Index: integer);
    procedure UpdateSectionDisplayControls;
    function CheckConnectingLineValidity: boolean;
    procedure ShowInvalidConnections;
    procedure CreateConnectingLine(X: Integer; Y: Integer);
    procedure CreateInterpolators;
    procedure FillConnectionsList(const Connections: TStringList);
    procedure ClearConnectionList(Connections: TStringList);
    property Interpolator[const Name: String]: TInterpolatorList read GetInterpolator;
    procedure DeleteConnectingLine(X: Integer; Y: Integer);
    procedure CreateExtraConnectingLines(Connections: TStringList);
    procedure CalculateDefaultDelta;
    procedure RemoveExtraConnectingLines;
    procedure ClearInterpolators;
    procedure CreateDataLayers;
    procedure GetInterpolationParameters(out Delta, MinX, MinY: double;
      out XCount, YCount: integer);
    procedure GetSlope(const Interpolator: TInterpolatorList;
      const X, Y, ZValue, Delta: double; out Dip, DipDirection: double);
    { Private declarations }
  public
    procedure ModelComponentName(AStringList: TStringList); override;
    { Public declarations }
  end;

var
  frmImportCrossSection: TfrmImportCrossSection;

procedure ImportCrossSection(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;

implementation

{$R *.dfm}

uses Math, Contnrs, UtilityFunctions, frmFileSelectionUnit, ReadShapeFileUnit,
  ColorSchemes, ANE_LayerUnit, ANECB, LayerNamePrompt, FixNameUnit;

const
{$IFDEF MSWINDOWS}
  ReadWritePermissions = 0;
{$ELSE}
  ReadWritePermissions = S_IREAD or S_IWRITE or S_IRGRP or S_IWGRP or S_IROTH;
{$ENDIF}

procedure ImportCrossSection(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
var
  dummy: Boolean;
  Continue: boolean;
  FileNames, SectionNames, Parameters: TStringList;
begin

  FileNames := TStringList.Create;
  Parameters := TStringList.Create;
  SectionNames := TStringList.Create;
  try
    frmFileSelection := TfrmFileSelection.Create(nil);
    try
      frmFileSelection.CurrentModelHandle := aneHandle;
      frmFileSelection.btnSelectClick(nil);
      frmFileSelection.rdg2FileNamesSelectCell(frmFileSelection.rdg2FileNames,
        1, 1, dummy);
      Continue := (frmFileSelection.rdg2FileNames.Cells[1,1] <> '')
        and (frmFileSelection.ShowModal = mrOK);
      if Continue then
      begin
        FileNames.AddStrings(frmFileSelection.rdg2FileNames.Cols[0]);
        FileNames.Delete(0);
        SectionNames.AddStrings(frmFileSelection.rdg2FileNames.Cols[1]);
        SectionNames.Delete(0);
        Parameters.AddStrings(frmFileSelection.rdg2FileNames.Cols[2]);
        Parameters.Delete(0);
      end;
    finally
      frmFileSelection.Free;
    end;

    if Continue then
    begin
      frmImportCrossSection := TfrmImportCrossSection.Create(nil);
      try
        frmImportCrossSection.CurrentModelHandle := aneHandle;
        frmImportCrossSection.GetData(FileNames, SectionNames, Parameters);
        frmImportCrossSection.ShowModal;
      finally
        frmImportCrossSection.Free;
      end;
    end;
  finally
    FileNames.Free;
    Parameters.Free;
    SectionNames.Free;
  end;
end;

function SortZoomPoints(Item1, Item2: Pointer): Integer;
var
  Point1, Point2: TRbwZoomPoint;
begin
  Point1 := Item1;
  Point2 := Item2;
  if Point2.X > Point1.X then
  begin
    result := -1;
  end
  else if Point2.X = Point1.X then
  begin
    result := 0;
  end
  else
  begin
    result := 1;
  end;
end;

function SortConnectingLines(Item1, Item2: Pointer): Integer;
var
  Line1, Line2: TConnectingLine;
begin
  Line1 := Item1;
  Line2 := Item2;
  if Line2.StartPosition.CrossX > Line1.StartPosition.CrossX then
  begin
    result := -1;
  end
  else if Line2.StartPosition.CrossX < Line1.StartPosition.CrossX then
  begin
    result := 1;
  end
  else
  begin
    if Line2.EndPosition.CrossX > Line1.EndPosition.CrossX then
    begin
      result := -1;
    end
    else if Line2.EndPosition.CrossX < Line1.EndPosition.CrossX then
    begin
      result := 1;
    end
    else
    begin
      result := 0;
    end;
  end;
end;


procedure TfrmImportCrossSection.FormCreate(Sender: TObject);
begin
  inherited;
  FileNames:= TStringList.Create;
  SectionNames:= TStringList.Create;
  Parameters:= TStringList.Create;
  ConnectingLines:= TConnectingLines.Create;
  Interpolators:= TStringList.Create;

  LineIds:= TStringList.Create;
  CrossSections:= TCrossSections.Create(zbCrossSections, zbMap);

  LineIds.Sorted := True;
  LineIds.Duplicates := dupIgnore;

  rdg2Locations.Cells[0,0] := 'Cross Section';
  rdg2Locations.Cells[1,0] := 'Starting Point X';
  rdg2Locations.Cells[2,0] := 'Starting Point Y';
  rdg2Locations.Cells[3,0] := 'Ending Point X';
  rdg2Locations.Cells[4,0] := 'Ending Point Y';

  pcMain.ActivePageIndex := 0;
  Saved := True;
end;

{ TInterpolator }

function TInterpolator.InBlock(const X, Y: double): boolean;
begin
  result := PointInside(X, Y, FXCoordinates, FYCoordinates, False);
end;

function TInterpolator.InterpolatedValue(const X, Y: double): double;
var
  Error: boolean;
begin
  FiniteElementInterpolate(X, Y, FXCoordinates,
    FYCoordinates, FZValues, Error, result);
  if Error then
  begin
    raise EInterpolateException.Create('Error interpolating value');
  end;
end;

{ TInterpolatorList }

function TInterpolatorList.Add: TInterpolator;
begin
  result := TInterpolator.Create;
  FList.Add(result);
  FSorted := False;
end;

procedure TInterpolatorList.Clear;
begin
  FList.Clear;
  FRangeTree.Clear;
  FStoredResult := nil;
end;

constructor TInterpolatorList.Create;
begin
  inherited;
  SetLength(FLocations, 2);
  FFindList:= TList.Create;
  FList:= TObjectList.Create;
  FRangeTree:= TRbwRangeTree.Create(nil);
end;

destructor TInterpolatorList.Destroy;
begin
  FRangeTree.Free;
  FList.Free;
  FFindList.Free;
  inherited;
end;

function TInterpolatorList.GetCount: integer;
begin
  result := FList.Count;
end;

function TInterpolatorList.GetItem(const Index: integer): TInterpolator;
begin
  result := FList[Index];
end;

function TInterpolatorList.GetCapacity: integer;
begin
  result := FList.Capacity;
end;

procedure TInterpolatorList.SetCapacity(const Value: integer);
begin
  FList.Capacity := Value;
end;

procedure TInterpolatorList.Sort;
var
  Index: integer;
  Interpolator: TInterpolator;
  RangeArray: TRangeArray;
  CoordIndex: integer;
begin
  FRangeTree.Clear;
  SetLength(RangeArray, 2);
  for Index := 0 to Count -1 do
  begin
    Interpolator := Items[Index];
    RangeArray[0].Min := Interpolator.XCoordinates[1];
    RangeArray[0].Max := Interpolator.XCoordinates[1];
    RangeArray[1].Min := Interpolator.YCoordinates[1];
    RangeArray[1].Max := Interpolator.YCoordinates[1];
    for CoordIndex := 2 to 4 do
    begin
      if RangeArray[0].Min > Interpolator.XCoordinates[CoordIndex] then
      begin
        RangeArray[0].Min := Interpolator.XCoordinates[CoordIndex]
      end;
      if RangeArray[0].Max < Interpolator.XCoordinates[CoordIndex] then
      begin
        RangeArray[0].Max := Interpolator.XCoordinates[CoordIndex]
      end;
      if RangeArray[1].Min > Interpolator.YCoordinates[CoordIndex] then
      begin
        RangeArray[1].Min := Interpolator.YCoordinates[CoordIndex]
      end;
      if RangeArray[1].Max < Interpolator.YCoordinates[CoordIndex] then
      begin
        RangeArray[1].Max := Interpolator.YCoordinates[CoordIndex]
      end;
    end;
    FRangeTree.Add(RangeArray, Interpolator);
  end;
  FSorted := True;
end;

function TInterpolatorList.InterpolatedValue(const X, Y: double; out Value: double): Boolean;
var
  Interpolator: TInterpolator;
begin
  Interpolator := Find(X, Y);
  if Interpolator = nil then
  begin
    result := False;
    Value := 0;
  end
  else
  begin
    result := True;
    Value := Interpolator.InterpolatedValue(X, Y);
  end;
end;

function TInterpolatorList.Find(const X, Y: double): TInterpolator;
var
  Index: integer;
  Interpolator: TInterpolator;
begin
  result := nil;
  if (FStoredResult <> nil) and FStoredResult.InBlock(X,Y) then
  begin
    result := FStoredResult;
    Exit;
  end;

  if not FSorted then
  begin
    Sort;
  end;
  FLocations[0] := X;
  FLocations[1] := Y;
  FFindList.Clear;
  FRangeTree.FindInList(FLocations, FFindList);
  for Index := 0 to FFindList.Count -1 do
  begin
    Interpolator := FFindList[Index];
    if Interpolator.InBlock(X,Y) then
    begin
      result := Interpolator;
      FStoredResult := result;
      Exit;
    end;
  end;
end;

{ TCrossSection }

procedure TCrossSectionLine.SetCapacity(const Value: integer);
begin
  FCapacity := Value;
  SetLength(FZLocations, Value);
  SetLength(FCrossSectionX, Value);

end;

function TCrossSectionLine.ThreeDLength: double;
var
  Index: integer;
begin
  result := 0;
  for Index := 0 to Count -2 do
  begin
    result := result
      + Distance(XLocations[Index], YLocations[Index], FZLocations[Index],
      XLocations[Index+1], YLocations[Index+1], FZLocations[Index+1]);
  end;
end;

procedure TCrossSectionLine.EnsureUpperZoomPoints;
var
  ZoomPoint: TRbwZoomPoint;
  Offset: Double;
  PointIndex: Integer;
begin
  if FUpperZoomPoints.Count < Count then
  begin
    FUpperZoomPoints.Clear;
    Offset := FSection.Length / 2;
    for PointIndex := 0 to Count - 1 do
    begin
      ZoomPoint := TRbwZoomPoint.Create(FSection.FProfileZoomBox);
      ZoomPoint.X := FCrossSectionX[PointIndex];
      ZoomPoint.Y := FZLocations[PointIndex] + Offset;
      FUpperZoomPoints.Add(ZoomPoint);
    end;
    FUpperZoomPoints.Sort(SortZoomPoints);
    SetLength(FUpperArray, Count);
    for PointIndex := 0 to Count - 1 do
    begin
      ZoomPoint := FUpperZoomPoints[PointIndex];
      FUpperArray[PointIndex] := ZoomPoint;
      FCrossSectionX[PointIndex] := ZoomPoint.X;
      FZLocations[PointIndex] := ZoomPoint.Y - Offset;
    end;
  end;
end;

procedure TCrossSectionLine.EnsureLowerZoomPoints;
var
  PointIndex: Integer;
  ZoomPoint: TRbwZoomPoint;
begin
  if FLowerZoomPoints.Count < Count then
  begin
    FLowerZoomPoints.Clear;
    for PointIndex := 0 to Count - 1 do
    begin
      ZoomPoint := TRbwZoomPoint.Create(FSection.FProfileZoomBox);
      ZoomPoint.X := FCrossSectionX[PointIndex];
      ZoomPoint.Y := FZLocations[PointIndex];
      FLowerZoomPoints.Add(ZoomPoint);
    end;
    FLowerZoomPoints.Sort(SortZoomPoints);
    SetLength(FLowerArray, Count);
    for PointIndex := 0 to Count - 1 do
    begin
      ZoomPoint := FLowerZoomPoints[PointIndex];
      FLowerArray[PointIndex] := ZoomPoint;
      FCrossSectionX[PointIndex] := ZoomPoint.X;
      FZLocations[PointIndex] := ZoomPoint.Y;
    end;
  end;
end;

procedure TCrossSectionLine.AddPoint(const CrossX, Z: double);
begin
  If Count = Capacity then
  begin
    Grow;
  end;
  FCrossSectionX[Count] := CrossX;
  FZLocations[Count] := Z;
  Inc(FCount);
  FStoredMinZ := False;
  FStoredMaxZ := False;
end;

procedure TCrossSectionLine.GetPointFromCrossX(CrossX: double; out X, Y, Z: double);
var
  Index: integer;
  LengthSoFar: double;
  PreviousLength: double;
  Fraction: double;
begin
  Assert(Count > 0);
  if (CrossX < FCrossSectionX[0]) and (Abs((CrossX - FCrossSectionX[0])
    /(CrossX + FCrossSectionX[0])) > 1e-8) then
  begin
    raise EInvalidLocation.Create('Invalid x coordinate of ' + FloatToStr(CrossX) );
  end;
  
  {Assert((CrossX >= FCrossSectionX[0])
    or (Abs((CrossX - FCrossSectionX[0])
    /(CrossX + FCrossSectionX[0])) < 1e-8)); }
  if CrossX > FCrossSectionX[Count-1] then
  begin
    Assert(CrossX > 0);
    if Abs((FCrossSectionX[Count-1]- CrossX)/CrossX) < 1e-14  then
    begin
      CrossX := FCrossSectionX[Count-1]
    end
    else
    begin
      Assert(False);
    end;
  end;

  for Index := 1 to Count -1 do
  begin
    LengthSoFar := FCrossSectionX[Index];
    if LengthSoFar >= CrossX then
    begin
      PreviousLength := fCrossSectionX[Index-1];
      Assert(LengthSoFar > PreviousLength);
      Fraction := (CrossX - PreviousLength)
        / (LengthSoFar - PreviousLength);
      X := Interpolate(XLocations[Index-1], XLocations[Index], Fraction);
      Y := Interpolate(YLocations[Index-1], YLocations[Index], Fraction);
      Z := Interpolate(FZLocations[Index-1], FZLocations[Index], Fraction);
      Exit;
    end;
  end;
  Assert(False);
end;

procedure TCrossSectionLine.GetPointAt3D(const DistanceFromStart: double; out X, Y, Z, CrossX: double);
var
  Index: integer;
  LengthSoFar: double;
  PreviousLength: double;
  Fraction: double;
begin
  Assert((DistanceFromStart >= 0) and (DistanceFromStart <= ThreeDLength));

  LengthSoFar := 0;
  PreviousLength := 0;
  for Index := 0 to Count -2 do
  begin
    LengthSoFar := LengthSoFar
      + Distance(XLocations[Index], YLocations[Index], FZLocations[Index],
      XLocations[Index+1], YLocations[Index+1], FZLocations[Index+1]);
    if LengthSoFar >= DistanceFromStart then
    begin
      Assert(LengthSoFar > PreviousLength);
      Fraction := (DistanceFromStart - PreviousLength)
        / (LengthSoFar - PreviousLength);
      X := Interpolate(XLocations[Index], XLocations[Index+1], Fraction);
      Y := Interpolate(YLocations[Index], YLocations[Index+1], Fraction);
      Z := Interpolate(FZLocations[Index], FZLocations[Index+1], Fraction);
      CrossX := Interpolate(FCrossSectionX[Index], FCrossSectionX[Index+1], Fraction);
    end;
    PreviousLength := LengthSoFar;
  end;
  Assert(False);
end;

Function TCrossSectionLine.GetFraction(const Index: Integer): double;
var
  CrossX: Double;
begin
  Assert((Index >= 0) and (Index < Count));
  CrossX := FCrossSectionX[Index];
  result := CrossX / FSection.Length;
end;

procedure TCrossSectionLine.GetPointAt2DTop(const DistanceFromStart: double;
  out X, Y, Z, CrossX: double);
var
  Index: integer;
  LengthSoFar: double;
  PreviousLength: double;
  Fraction: double;
begin
  Assert((DistanceFromStart >= 0) and (DistanceFromStart <= TwoDLengthTop));

  LengthSoFar := 0;
  PreviousLength := 0;
  for Index := 0 to Count -2 do
  begin
    LengthSoFar := LengthSoFar
      + Distance(XLocations[Index], YLocations[Index],
      XLocations[Index+1], YLocations[Index+1]);
    if LengthSoFar >= DistanceFromStart then
    begin
      Assert(LengthSoFar > PreviousLength);
      Fraction := (DistanceFromStart - PreviousLength)
        / (LengthSoFar - PreviousLength);
      X := Interpolate(XLocations[Index], XLocations[Index+1], Fraction);
      Y := Interpolate(YLocations[Index], YLocations[Index+1], Fraction);
      Z := Interpolate(FZLocations[Index], FZLocations[Index+1], Fraction);
      CrossX := Interpolate(FCrossSectionX[Index], FCrossSectionX[Index+1], Fraction);
    end;
    PreviousLength := LengthSoFar;
  end;
  Assert(False);
end;

procedure TCrossSectionLine.Grow;
var
  Delta: integer;
begin
  if Capacity < 16 then
  begin
    Delta := 4;
  end
  else
  begin
    Delta := Capacity div 4;
  end;
  Capacity := Capacity + Delta;
end;

function TCrossSectionLine.TwoDLengthTop: double;
var
  Index: integer;
begin
  result := 0;
  for Index := 0 to Count -2 do
  begin
    result := result
      + Distance(FCrossSectionX[Index], YLocations[Index],
      FCrossSectionX[Index+1], YLocations[Index+1]);
  end;
end;

procedure TCrossSectionLine.GetPointAt2DSide(const DistanceFromStart: double; out X,
  Y, Z, CrossX: double);
var
  Index: integer;
  LengthSoFar: double;
  PreviousLength: double;
  Fraction: double;
begin
  Assert((DistanceFromStart >= 0) and (DistanceFromStart <= TwoDLengthSide));

  LengthSoFar := 0;
  PreviousLength := 0;
  for Index := 0 to Count -2 do
  begin
    LengthSoFar := LengthSoFar
      + Distance(FCrossSectionX[Index], FZLocations[Index],
      FCrossSectionX[Index+1], FZLocations[Index+1]);
    if LengthSoFar >= DistanceFromStart then
    begin
      Assert(LengthSoFar > PreviousLength);
      Fraction := (DistanceFromStart - PreviousLength)
        / (LengthSoFar - PreviousLength);
      X := Interpolate(XLocations[Index], XLocations[Index+1], Fraction);
      Y := Interpolate(YLocations[Index], YLocations[Index+1], Fraction);
      Z := Interpolate(FZLocations[Index], FZLocations[Index+1], Fraction);
      CrossX := Interpolate(FCrossSectionX[Index], FCrossSectionX[Index+1], Fraction);
    end;
    PreviousLength := LengthSoFar;
  end;
  Assert(False);
end;

function TCrossSectionLine.TwoDLengthSide: double;
var
  Index: integer;
begin
  result := 0;
  for Index := 0 to Count -2 do
  begin
    result := result
      + Distance(XLocations[Index], FZLocations[Index],
      XLocations[Index+1], FZLocations[Index+1]);
  end;
end;

procedure TfrmImportCrossSection.GetData(const FileNames, SectionNames,
  Parameters: TStringList);
var
  FileIndex: integer;
  AFileName: string;
  LineIdValue: string;
begin
  self.FileNames.AddStrings(FileNames);
  self.SectionNames.AddStrings(SectionNames);
  self.Parameters.AddStrings(Parameters);
  Assert(FileNames.Count = SectionNames.Count);
  Assert(FileNames.Count = Parameters.Count);
  rdg2Locations.RowCount := FileNames.Count +1;
  for FileIndex := 0 to FileNames.Count -1 do
  begin
    rdg2Locations.Cells[0,FileIndex+1] := SectionNames[FileIndex];
    AFileName := FileNames[FileIndex];
    AFileName := ChangeFileExt(AFileName, '.dbf');
    Assert(FileExists(AFileName));
    xbaseShapeFiles.FileName := AFileName;
    try
      xbaseShapeFiles.Active := True;
      xbaseShapeFiles.GotoBOF;
      repeat
        LineIdValue := xbaseShapeFiles.GetFieldByName(Parameters[FileIndex]);
        LineIds.Add(LineIdValue);
        xbaseShapeFiles.GotoNext;
      until xbaseShapeFiles.Eof;
    finally
      xbaseShapeFiles.Active := False;
    end;
  end;
end;

procedure TfrmImportCrossSection.ModelComponentName(AStringList: TStringList);
begin
  // do nothing.
end;

procedure TfrmImportCrossSection.DeleteConnectingLine(X: Integer; Y: Integer);
var
  ZBArray: TZBArray;
  ConnectingIndex: Integer;
  ConnectingLine: TConnectingLine;
  Point1: TRbwZoomPoint;
  Point2: TRbwZoomPoint;
begin
  Point1 := TRbwZoomPoint.Create(zbCrossSections);
  Point2 := TRbwZoomPoint.Create(zbCrossSections);
  try
    SetLength(ZBArray, 2);
    ZBArray[0] := Point1;
    ZBArray[1] := Point2;
    for ConnectingIndex := 0 to ConnectingLines.Count - 1 do
    begin
      ConnectingLine := ConnectingLines[ConnectingIndex];
      if (ConnectingLine.Line = comboLines.Text)
        and ((ConnectingLine.StartPosition.Section = comboUpperCrossSec.Text)
        or (ConnectingLine.StartPosition.Section = comboLowerCrossSec.Text))
        and ((ConnectingLine.EndPosition.Section = comboUpperCrossSec.Text)
        or (ConnectingLine.EndPosition.Section = comboLowerCrossSec.Text)) then
      begin
        Point1.X := ConnectingLine.StartPosition.CrossX;
        Point2.X := ConnectingLine.EndPosition.CrossX;
        if ConnectingLine.StartPosition.Section = comboUpperCrossSec.Text then
        begin
          Point1.Y := ConnectingLine.StartPosition.UpperZ;
          Point2.Y := ConnectingLine.EndPosition.LowerZ;
        end
        else
        begin
          Point1.Y := ConnectingLine.StartPosition.LowerZ;
          Point2.Y := ConnectingLine.EndPosition.UpperZ;
        end;
        if zbCrossSections.SelectPolyLine(X, Y, ZBArray) then
        begin
          ConnectingLines.Delete(ConnectingIndex);
          Saved := False;
          zbCrossSections.Invalidate;
          Break;
        end;
      end;
    end;
  finally
    Point1.Free;
    Point2.Free;
  end;
end;

procedure TfrmImportCrossSection.ClearConnectionList(Connections: TStringList);
var
  Index: Integer;
begin
  for Index := Connections.Count - 1 downto 0 do
  begin
    Connections.Objects[Index].Free;
  end;
end;

procedure TfrmImportCrossSection.CreateConnectingLine(X: Integer; Y: Integer);
var
  CrossX: Double;
  Choice: TCrossSecChoice;
  SectionName: string;
  Section: TCrossSection;
  Line: TCrossSectionLine;
begin
  for Choice := Low(TCrossSecChoice) to High(TCrossSecChoice) do
  begin
    case Choice of
      cscLower:
        begin
          SectionName := comboLowerCrossSec.Text;
        end;
      cscUpper:
        begin
          SectionName := comboUpperCrossSec.Text;
        end;
    else
      begin
        Assert(False);
      end;
    end;
    Section := CrossSections.GetSectionByName(SectionName);
    if Section <> nil then
    begin
      Line := Section.GetSectionLinesByName(comboLines.Text);
      if Line <> nil then
      begin
        if Line.Select(X, Y, Choice, CrossX) then
        begin
          if CurrentLine = nil then
          begin
            CurrentLine := TConnectingLine.Create(nil);
            CurrentLine.UserGenerated := True;
            CurrentLine.StartPosition.Section := SectionName;
            CurrentLine.Line := comboLines.Text;
            CurrentLine.StartPosition.CrossX := CrossX;
            CurrentLine.StartPosition.LowerZ := Line.GetLowerZFromCrossX(CrossX);
            CurrentLine.StartPosition.UpperZ := Line.GetUpperZFromCrossX(CrossX);
            zbCrossSections.Invalidate;
          end
          else
          begin
            if CurrentLine.StartPosition.Section = SectionName then
            begin
              Beep;
              FreeAndNil(CurrentLine);
              zbCrossSections.Invalidate;
            end
            else
            begin
              CurrentLine.EndPosition.Section := SectionName;
              CurrentLine.EndPosition.CrossX := CrossX;
              CurrentLine.EndPosition.LowerZ := Line.GetLowerZFromCrossX(CrossX);
              CurrentLine.EndPosition.UpperZ := Line.GetUpperZFromCrossX(CrossX);
              ConnectingLines.Add(CurrentLine);
              Saved := False;
              CurrentLine := nil;
              zbCrossSections.Invalidate;
              break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmImportCrossSection.FormDestroy(Sender: TObject);
begin
  inherited;
  CrossSections.Free;
  FileNames.Free;
  SectionNames.Free;
  Parameters.Free;
  ConnectingLines.Free;
  LineIds.Free;
  ClearInterpolators;              ;
  Interpolators.Free;
end;

function TCrossSectionLine.GetXLocations(Index: integer): double;
var
  Fraction: double;
begin
  Fraction := GetFraction(Index);
  result := Interpolate(FSection.StartX, FSection.EndX, Fraction);
end;

function TCrossSectionLine.GetYLocations(Index: integer): double;
var
  Fraction: double;
begin
  Fraction := GetFraction(Index);
  result := Interpolate(FSection.StartY, FSection.EndY, Fraction);
end;

function TCrossSection.GetSectionLinesByName(const Name: string): TCrossSectionLine;
var
  Position: integer;
begin
  result := nil;
  if (FStoredResult <> nil) and (FStoredResult.LineName = Name) then
  begin
    result := FStoredResult;
    Exit;
  end;
  Position := FLines.IndexOf(Name);
  if Position >= 0 then
  begin
    result := SectionLineByIndex[Position];
    FStoredResult := result;
  end;
end;

function TCrossSection.AddLine(const Name: string): TCrossSectionLine;
begin
  result := SectionLinesByName[Name];
  if result = nil then
  begin
    result := TCrossSectionLine.Create;
    result.LineName := Name;
    result.FSection := self;
    FLines.AddObject(Name, result);
    FStoredResult := result;
  end;
end;

procedure TCrossSection.Clear;
var
  Index: integer;
begin
  for Index := 0 to FLines.Count -1 do
  begin
    FLines.Objects[Index].Free;
  end;
  FLines.Clear;
end;

function TCrossSection.GetLength: double;
begin
  result := Distance(StartX, StartY, EndX, EndY);
end;

function TCrossSection.GetCount: integer;
begin
  result := FLines.Count;
end;

function TCrossSection.GetSectionLineByIndex(const Index: integer): TCrossSectionLine;
begin
  result := FLines.Objects[Index] as TCrossSectionLine;
end;

{ TCrossSection }

constructor TCrossSection.Create(ProfileZoomBox, MapZoomBox: TRbwZoomBox);
begin
  inherited Create;
  FProfileZoomBox := ProfileZoomBox;
  FMapZoomBox := MapZoomBox;
  FStartPoint := TRbwZoomPoint.Create(FMapZoomBox);
  FEndPoint := TRbwZoomPoint.Create(FMapZoomBox);
  FLines:= TStringList.Create;
end;

destructor TCrossSection.Destroy;
begin
  Clear;
  FLines.Free;
  FStartPoint.Free;
  FEndPoint.Free;
  inherited;
end;

procedure TCrossSection.InvalidateZoomPoints;
var
  Index: integer;
begin
  for Index := 0 to Count -1 do
  begin
    SectionLineByIndex[Index].InvalidateZoomPoints;
  end;
end;

function TCrossSection.GetStartPoint: TRbwZoomPoint;
begin
  if FStartPoint = nil then
  begin
    FStartPoint := TRbwZoomPoint.Create(FMapZoomBox);
    FStartPoint.X := StartX;
    FStartPoint.Y := StartY;
  end;
  result := FStartPoint;
end;

function TCrossSection.GetEndPoint: TRbwZoomPoint;
begin
  if FEndPoint = nil then
  begin
    FEndPoint := TRbwZoomPoint.Create(FMapZoomBox);
    FEndPoint.X := EndX;
    FEndPoint.Y := EndY;
  end;
  result := FEndPoint;
end;

procedure TCrossSection.SetStartX(const Value: double);
begin
  if FStartX <> Value then
  begin
    FStartX := Value;
    if FStartPoint <> nil then
    begin
      FStartPoint.X := Value;
    end;
  end;
end;

procedure TCrossSection.SetStartY(const Value: double);
begin
  if FStartY <> Value then
  begin
    FStartY := Value;
    if FStartPoint <> nil then
    begin
      FStartPoint.Y := Value;
    end;
  end;
end;

procedure TCrossSection.SetEndX(const Value: double);
begin
  if FEndX <> Value then
  begin
    FEndX := Value;
    if FEndPoint <> nil then
    begin
      FEndPoint.X := Value;
    end;
  end;
end;

procedure TCrossSection.SetEndY(const Value: double);
begin
  if FEndY <> Value then
  begin
    FEndY := Value;
    if FEndPoint <> nil then
    begin
      FEndPoint.Y := Value;
    end;
  end;
end;

{ TCrossSections }

function TCrossSections.GetCount: integer;
begin
  result := FSections.Count;
end;

function TCrossSections.GetSectionByName(const Name: string): TCrossSection;
var
  Position: integer;
begin
  result := nil;
  if (FStoredResult <> nil) and (FStoredResult.FSectionName = Name) then
  begin
    result := FStoredResult;
    Exit;
  end;
  Position := FSections.IndexOf(Name);
  if Position >= 0 then
  begin
    result := SectionByIndex[Position];
    FStoredResult := result;
  end;
end;

function TCrossSections.GetSectionByIndex(const Index: integer): TCrossSection;
begin
  result := FSections.Objects[Index] as TCrossSection;
end;

constructor TCrossSections.Create(ProfileZoomBox, MapZoomBox: TRbwZoomBox);
begin
  inherited Create;
  FProfileZoomBox := ProfileZoomBox;
  FMapZoomBox := MapZoomBox;
  FSections:= TStringList.Create;
end;

procedure TCrossSections.Clear;
var
  Index: integer;
begin
  for Index := 0 to FSections.Count -1 do
  begin
    FSections.Objects[Index].Free;
  end;
  FSections.Clear;
  FStoredResult := nil;
end;

destructor TCrossSections.Destroy;
begin
  Clear;
  FSections.Free;
  inherited;
end;

function TCrossSections.Add(const Name: string): TCrossSection;
begin
  result := SectionByName[Name];
  if result = nil then
  begin
    result := TCrossSection.Create(FProfileZoomBox, FMapZoomBox);
    result.FSectionName := Name;
    FSections.AddObject(Name, result);
  end;
end;

procedure TfrmImportCrossSection.CreateCrossSection(const Index: integer);
var
  GeometryFileName: string;
  IndexFileName: string;
  SectionName: string;
  ParameterName: string;
  DataBaseFileName: string;
  Row: integer;
  GeometryFile: TShapeGeometryFile;
  ShapeIndex: integer;
  Shape: TShapeObject;
  LineID : string;
  CrossSection: TCrossSection;
  Line: TCrossSectionLine;
  PointIndex: integer;
  Point: TShapePoint;
  LineIndex: integer;
begin
  GeometryFileName := FileNames[Index];
  IndexFileName := ChangeFileExt(GeometryFileName, '.shx');
  DataBaseFileName := ChangeFileExt(GeometryFileName, '.dbf');
  SectionName := SectionNames[Index];
  ParameterName := Parameters[Index];
  Row := rdg2Locations.Cols[Ord(cslName)].IndexOf(SectionName);
  Assert(Row >= 1);

  CrossSection := CrossSections.Add(SectionName);
  CrossSection.StartX := StrToFloat(rdg2Locations.Cells[Ord(cslStartX),Row]);
  CrossSection.StartY := StrToFloat(rdg2Locations.Cells[Ord(cslStartY),Row]);
  CrossSection.EndX := StrToFloat(rdg2Locations.Cells[Ord(cslEndX),Row]);
  CrossSection.EndY := StrToFloat(rdg2Locations.Cells[Ord(cslEndY),Row]);

  GeometryFile := TShapeGeometryFile.Create;
  try
    GeometryFile.OnProgress := nil;
    GeometryFile.ReadFromFile(GeometryFileName, IndexFileName);
    xbaseShapeFiles.FileName := DataBaseFileName;
    try
      xbaseShapeFiles.Active := True;
      xbaseShapeFiles.GotoBOF;
      for ShapeIndex := 0 to GeometryFile.Count -1 do
      begin
        Shape := GeometryFile.Items[ShapeIndex];
        LineID := xbaseShapeFiles.GetFieldByName(ParameterName);

        Line := CrossSection.AddLine(LineID);

        for PointIndex := 0 to Shape.NumPoints -1 do
        begin
          Point := Shape.Points[PointIndex];
          Line.AddPoint(Point.X, Point.Y);
        end;

        xbaseShapeFiles.GotoNext;
      end;
    finally
      xbaseShapeFiles.Active := False;
    end;
  finally
    GeometryFile.Free;
  end;
  for LineIndex := 0 to CrossSection.Count -1 do
  begin
    Line := CrossSection.SectionLineByIndex[LineIndex];
    if Line.Count > 0 then
    begin
      Line.EnsureUpperZoomPoints;
      Line.EnsureLowerZoomPoints;
    end;
  end;
end;

procedure TfrmImportCrossSection.CreateCrossSections;
var
  FileIndex: integer;
begin
  for FileIndex := 0 to FileNames.Count -1 do
  begin
    CreateCrossSection(FileIndex);
  end;
end;

procedure TfrmImportCrossSection.UpdateSectionDisplayControls;
var
  Index: integer;
  CrossSection: TCrossSection;
  Sections: TStringList;
  Lines: TStringList;
  LineIndex: integer;
  Line: TCrossSectionLine;
begin
  Sections := TStringList.Create;
  Lines := TStringList.Create;
  try
    Lines.Sorted := True;
    Lines.Duplicates := dupIgnore;
    for Index := 0 to CrossSections.Count -1 do
    begin
      CrossSection := CrossSections.GetSectionByIndex(Index);
      Sections.Add(CrossSection.SectionName);
      for LineIndex := 0 to CrossSection.Count -1 do
      begin
        Line := CrossSection.GetSectionLineByIndex(LineIndex);
        Lines.Add(Line.LineName);
      end;
    end;
    comboLowerCrossSec.Items :=  Sections;
    comboUpperCrossSec.Items :=  Sections;
    comboLines.Items := Lines;
    comboLines2.Items := Lines;
    if Sections.Count > 0 then
    begin
      comboLowerCrossSec.ItemIndex := 0
    end;
    if Sections.Count > 1 then
    begin
      comboUpperCrossSec.ItemIndex := 1
    end;
    if Lines.Count > 0 then
    begin
      comboLines.ItemIndex := 0
    end;
  finally
    Sections.Free;
    Lines.Free;
  end;
end;

procedure TfrmImportCrossSection.FillConnectionsList(const Connections: TStringList);
var
  Index: integer;
  Line: TConnectingLine;
  ListName: string;
  List: TList;
  ListPosition: integer;
  TempPostion: TPosition;
begin
  TempPostion := TPosition.Create;
  try
    for Index := 0 to ConnectingLines.Count -1 do
    begin
      Line  := ConnectingLines[Index];
      Line.Valid := True;
      ListName := Line.StartPosition.Section + Line.EndPosition.Section + Line.Line;
      ListPosition := Connections.IndexOf(ListName);
      if ListPosition < 0 then
      begin
        ListName := Line.EndPosition.Section + Line.StartPosition.Section + Line.Line;
        ListPosition := Connections.IndexOf(ListName);
        if ListPosition < 0 then
        begin
          ListName := Line.StartPosition.Section + Line.EndPosition.Section + Line.Line;
          List := TList.Create;
          Connections.AddObject(ListName, List);
        end
        else
        begin
          // Switch StartPosition and EndPosition so that all
          // Lines for the same connection will be arranged in the same
          // way.
          TempPostion.Assign(Line.StartPosition);
          Line.StartPosition := Line.EndPosition;
          Line.EndPosition := TempPostion;

          List := Connections.Objects[ListPosition] as TList;
        end;
      end
      else
      begin
        List := Connections.Objects[ListPosition] as TList;
      end;
      List.Add(Line);
    end;
    for Index := 0 to Connections.Count -1 do
    begin
      List := Connections.Objects[Index] as TList;
      List.Sort(SortConnectingLines);
    end;
  finally
    TempPostion.Free;
  end;
end;

function TfrmImportCrossSection.CheckConnectingLineValidity: boolean;
var
  Connections: TStringList;
  Line1, Line2: TConnectingLine;
  List: TList;
  LineIndex: integer;
  Index: integer;
begin
  result := True;
  Connections := TStringList.Create;
  try
    FillConnectionsList(Connections);

    for Index := 0 to Connections.Count -1 do
    begin
      List := Connections.Objects[Index] as TList;
      for LineIndex := 0 to List.Count -2 do
      begin
        Line1 := List[LineIndex];
        Line2 := List[LineIndex+1];
        if Line1.EndPosition.CrossX > Line2.EndPosition.CrossX then
        begin
          Line1.Valid := False;
          Line2.Valid := False;
          result := False;
        end;
      end;
    end;
  finally
    ClearConnectionList(Connections);
    Connections.Free;
  end;
end;

procedure TfrmImportCrossSection.ShowInvalidConnections;
var
  Index: integer;
  Line: TConnectingLine;
begin
  for Index := 0 to ConnectingLines.Count -1 do
  begin
    Line := ConnectingLines[Index];
    if not Line.Valid then
    begin
      comboLines.ItemIndex := comboLines.Items.IndexOf(Line.Line);
      comboUpperCrossSec.ItemIndex := comboUpperCrossSec.Items.
        IndexOf(Line.EndPosition.Section);
      comboLowerCrossSec.ItemIndex := comboLowerCrossSec.Items.
        IndexOf(Line.StartPosition.Section);
      break;
    end;
  end;
  zbCrossSections.Invalidate;
end;

procedure TfrmImportCrossSection.CreateExtraConnectingLines(
  Connections: TStringList);
var
  ConnectionIndex: integer;
  List: TList;
  LineIndex: integer;
  ConnectingLine1, ConnectingLine2: TConnectingLine;
  StartingSection, EndingSection: TCrossSection;
  StartingLine, EndingLine: TCrossSectionLine;
  CrossXIndex: integer;
  CrossX: double;
  NewConnectingLine: TConnectingLine;
  Fraction: double;
begin
  for ConnectionIndex := 0 to Connections.Count -1 do
  begin
    List := Connections.Objects[ConnectionIndex] as TList;
    // List.Count -2 is only evaluated once at the beginning of the loop.
    // That allows items to be added to List without causing problems.
    for LineIndex := 0 to List.Count -2 do
    begin
      ConnectingLine1 := List[LineIndex];
      ConnectingLine2 := List[LineIndex+1];
      StartingSection := CrossSections.GetSectionByName(
        ConnectingLine1.StartPosition.Section);
      if StartingSection = nil then
      begin
        raise Exception.Create('Section "'
          + ConnectingLine1.StartPosition.Section
          + '" not found.');
      end;

      StartingLine := StartingSection.SectionLinesByName[ConnectingLine1.Line];
      if StartingLine = nil then
      begin
        raise Exception.Create('"' + ConnectingLine1.Line + '" not found in '
          + 'Section "'
          + ConnectingLine1.StartPosition.Section
          + '".');
      end;

      EndingSection := CrossSections.GetSectionByName(
        ConnectingLine1.EndPosition.Section);
      if EndingSection = nil then
      begin
        raise Exception.Create('Section "'
          + ConnectingLine1.EndPosition.Section
          + '" not found.');
      end;
      EndingLine := EndingSection.SectionLinesByName[ConnectingLine1.Line];
      if EndingLine = nil then
      begin
        raise Exception.Create('"' + ConnectingLine1.Line + '" not found in '
          + 'Section "'
          + ConnectingLine1.EndPosition.Section
          + '".');
      end;

      for CrossXIndex := 0 to StartingLine.Count -1 do
      begin
        CrossX := StartingLine.FCrossSectionX[CrossXIndex];
        if (CrossX > ConnectingLine1.StartPosition.CrossX)
          and (CrossX < ConnectingLine2.StartPosition.CrossX) then
        begin
          NewConnectingLine := TConnectingLine.Create(nil);
          List.Add(NewConnectingLine);
          ConnectingLines.Add(NewConnectingLine);
          NewConnectingLine.StartPosition.Section :=
            ConnectingLine1.StartPosition.Section;
          NewConnectingLine.EndPosition.Section :=
            ConnectingLine1.EndPosition.Section;
          NewConnectingLine.Line := ConnectingLine1.Line;
          NewConnectingLine.StartPosition.CrossX := CrossX;
          Fraction := (CrossX - ConnectingLine1.StartPosition.CrossX) /
            (ConnectingLine2.StartPosition.CrossX -
            ConnectingLine1.StartPosition.CrossX);
          NewConnectingLine.EndPosition.CrossX := Interpolate(
            ConnectingLine1.EndPosition.CrossX,
            ConnectingLine2.EndPosition.CrossX, Fraction);
          NewConnectingLine.StartPosition.LowerZ :=
            StartingLine.GetLowerZFromCrossX(
            NewConnectingLine.StartPosition.CrossX);
          NewConnectingLine.StartPosition.UpperZ :=
            StartingLine.GetUpperZFromCrossX(
            NewConnectingLine.StartPosition.CrossX);
          NewConnectingLine.EndPosition.LowerZ :=
            EndingLine.GetLowerZFromCrossX(
            NewConnectingLine.EndPosition.CrossX);
          NewConnectingLine.EndPosition.UpperZ :=
            EndingLine.GetUpperZFromCrossX(
            NewConnectingLine.EndPosition.CrossX);

        end;
      end;

      EndingSection := CrossSections.GetSectionByName(
        ConnectingLine1.EndPosition.Section);
      if EndingSection = nil then
      begin
        raise Exception.Create('Section "'
          + ConnectingLine1.EndPosition.Section
          + '" not found.');
      end;
      EndingLine := EndingSection.SectionLinesByName[ConnectingLine1.Line];
      if EndingLine = nil then
      begin
        raise Exception.Create('"' + ConnectingLine1.Line + '" not found in '
          + 'Section "'
          + ConnectingLine1.EndPosition.Section
          + '".');
      end;

      for CrossXIndex := 0 to EndingLine.Count -1 do
      begin
        CrossX := EndingLine.FCrossSectionX[CrossXIndex];
        if (CrossX > ConnectingLine1.EndPosition.CrossX)
          and (CrossX < ConnectingLine2.EndPosition.CrossX) then
        begin
          NewConnectingLine := TConnectingLine.Create(nil);
          List.Add(NewConnectingLine);
          ConnectingLines.Add(NewConnectingLine);
          NewConnectingLine.StartPosition.Section :=
            ConnectingLine1.StartPosition.Section;
          NewConnectingLine.EndPosition.Section :=
            ConnectingLine1.EndPosition.Section;
          NewConnectingLine.Line := ConnectingLine1.Line;
          NewConnectingLine.EndPosition.CrossX := CrossX;
          Fraction := (CrossX - ConnectingLine1.EndPosition.CrossX) /
            (ConnectingLine2.EndPosition.CrossX -
            ConnectingLine1.EndPosition.CrossX);
          NewConnectingLine.StartPosition.CrossX := Interpolate(
            ConnectingLine1.StartPosition.CrossX,
            ConnectingLine2.StartPosition.CrossX, Fraction);
          NewConnectingLine.StartPosition.LowerZ :=
            StartingLine.GetLowerZFromCrossX(
            NewConnectingLine.StartPosition.CrossX);
          NewConnectingLine.StartPosition.UpperZ :=
            StartingLine.GetUpperZFromCrossX(
            NewConnectingLine.StartPosition.CrossX);
          NewConnectingLine.EndPosition.LowerZ :=
            EndingLine.GetLowerZFromCrossX(
            NewConnectingLine.EndPosition.CrossX);
          NewConnectingLine.EndPosition.UpperZ :=
            EndingLine.GetUpperZFromCrossX(
            NewConnectingLine.EndPosition.CrossX);
        end;
      end;
    end;
    List.Sort(SortConnectingLines);
  end;
end;

procedure TfrmImportCrossSection.CreateInterpolators;
var
  Connections: TStringList;
  ConnectionIndex: integer;
  List: TList;
  LineIndex: integer;
  ConnectingLine1, ConnectingLine2: TConnectingLine;
  InterpolatorList: TInterpolatorList;
  AnInterpolator: TInterpolator;
  Section: TCrossSection;
  CrossSectionLine: TCrossSectionLine;
  X, Y, Z: double;
begin
  Connections := TStringList.Create;
  try
    FillConnectionsList(Connections);
    CreateExtraConnectingLines(Connections);
    for ConnectionIndex := 0 to Connections.Count -1 do
    begin
      List := Connections.Objects[ConnectionIndex] as TList;
      for LineIndex := 0 to List.Count -2 do
      begin
        ConnectingLine1 := List[LineIndex];
        ConnectingLine2 := List[LineIndex+1];
        InterpolatorList := Interpolator[ConnectingLine1.Line];

        AnInterpolator := InterpolatorList.Add;

        try
          Section := CrossSections.GetSectionByName(
            ConnectingLine2.StartPosition.Section);
          Assert(Section <> nil);
          CrossSectionLine := Section.SectionLinesByName[ConnectingLine2.Line];
          Assert(CrossSectionLine <> nil);
          CrossSectionLine.GetPointFromCrossX(
            ConnectingLine2.StartPosition.CrossX, X, Y, Z);
          AnInterpolator.FXCoordinates[1] := X;
          AnInterpolator.FYCoordinates[1] := Y;
          AnInterpolator.FZValues[1] := Z;

          Section := CrossSections.GetSectionByName(
            ConnectingLine2.EndPosition.Section);
          Assert(Section <> nil);
          CrossSectionLine := Section.SectionLinesByName[ConnectingLine2.Line];
          Assert(CrossSectionLine <> nil);
          CrossSectionLine.GetPointFromCrossX(
            ConnectingLine2.EndPosition.CrossX, X, Y, Z);
          AnInterpolator.FXCoordinates[2] := X;
          AnInterpolator.FYCoordinates[2] := Y;
          AnInterpolator.FZValues[2] := Z;

          Section := CrossSections.GetSectionByName(
            ConnectingLine1.EndPosition.Section);
          Assert(Section <> nil);
          CrossSectionLine := Section.SectionLinesByName[ConnectingLine1.Line];
          Assert(CrossSectionLine <> nil);
          CrossSectionLine.GetPointFromCrossX(
            ConnectingLine1.EndPosition.CrossX, X, Y, Z);
          AnInterpolator.FXCoordinates[3] := X;
          AnInterpolator.FYCoordinates[3] := Y;
          AnInterpolator.FZValues[3] := Z;

          Section := CrossSections.GetSectionByName(
            ConnectingLine1.StartPosition.Section);
          Assert(Section <> nil);
          CrossSectionLine := Section.SectionLinesByName[ConnectingLine1.Line];
          Assert(CrossSectionLine <> nil);
          CrossSectionLine.GetPointFromCrossX(
            ConnectingLine1.StartPosition.CrossX, X, Y, Z);
          AnInterpolator.FXCoordinates[4] := X;
          AnInterpolator.FYCoordinates[4] := Y;
          AnInterpolator.FZValues[4] := Z;
        except on E: EInvalidLocation do
          begin
            raise EInvalidLocation.Create(
              E.Message + ' in cross sections '
              + ConnectingLine1.StartPosition.Section + ', '
              + ConnectingLine1.EndPosition.Section + ', '
              + ConnectingLine2.StartPosition.Section + ', and '
              + ConnectingLine2.EndPosition.Section 
              + ' in lines '
              + ConnectingLine1.Line + ' and '
              + ConnectingLine2.Line + '.');
          end;
        end;
      end;
    end;

  finally
    ClearConnectionList(Connections);
    Connections.Free;
  end;
end;

procedure TfrmImportCrossSection.CalculateDefaultDelta;
var
  DeltaX, DeltaY, Delta: double;
  LogDelta: integer;
begin
  DeltaX := zbMap.MaxX - zbMap.MinX;
  DeltaY := zbMap.MaxY - zbMap.MinY;
  Delta := (DeltaX + DeltaY)/2/100;
  LogDelta := Trunc(Log10(Delta));
  Delta := Power(10, LogDelta);
  adeDelta.Text := FloatToStr(Delta);
end;

type
  TNorthSouth = (nsNeither, nsNorth, nsSouth);
  TEastWest = (ewNeither, ewEast, ewWest);

procedure TfrmImportCrossSection.GetSlope(const Interpolator: TInterpolatorList;
  const X, Y, ZValue, Delta: double;
  out Dip, DipDirection: double);
var
  XBelow, XAbove, ZXBelow, ZXAbove: double;
  YBelow, YAbove, ZYBelow, ZYAbove: double;
  temp: double;
  dz_dx, dz_dy: double;
  DeltaX, DeltaY: double;
  Fraction: double;
  ReverseDirection: boolean;
  DipDirNorthSouth: TNorthSouth;
  DipDirEastWest: TEastWest;
begin
  // Find the dip and dip direction.
  // To find the dip direction, we will look at
  // four points that are a distance Delta away
  // from X,Y.  However, we may not be able to
  // get a Z value for some of those points so
  // initialize their coordinates and values to
  // the current X,Y,Z.

  XBelow := X;
  XAbove := X;
  ZXBelow := ZValue;
  ZXAbove := ZValue;

  YBelow := Y;
  YAbove := Y;
  ZYBelow := ZValue;
  ZYAbove := ZValue;

  // Get the Zvalues of the four points.
  if Interpolator.InterpolatedValue(X-Delta,Y, temp) then
  begin
    XBelow := X-Delta;
    ZXBelow := temp;
  end;
  if Interpolator.InterpolatedValue(X+Delta,Y, temp) then
  begin
    XAbove := X+Delta;
    ZXAbove := temp;
  end;
  if Interpolator.InterpolatedValue(X,Y-Delta, temp) then
  begin
    YBelow := Y-Delta;
    ZYBelow := temp;
  end;
  if Interpolator.InterpolatedValue(X,Y+Delta, temp) then
  begin
    YAbove := Y+Delta;
    ZYAbove := temp;
  end;

  if Abs(ZXAbove - ZXBelow) < 1e-13 then
  begin
    DipDirEastWest := ewNeither;
  end
  else if ZXAbove > ZXBelow then
  begin
    DipDirEastWest := ewWest;
  end
  else
  begin
    DipDirEastWest := ewEast;
  end;

  if Abs(ZYAbove - ZYBelow) < 1e-13 then
  begin
    DipDirNorthSouth := nsNeither;
  end
  else if ZYAbove > ZYBelow then
  begin
    DipDirNorthSouth := nsSouth;
  end
  else
  begin
    DipDirNorthSouth := nsNorth;
  end;

  if XBelow = XAbove then
  begin
    dz_dx := 0;
    DeltaX := 0;
  end
  else
  begin
    // dz_dx is Delta Z due to a Delta X of 1.
    dz_dx := (ZXAbove-ZXBelow)/(XAbove-XBelow);
    // Make sure UnitDeltaZ_X is always greater
    // than or equal to zero.
    if dz_dx > -1e-13 then
    begin
      DeltaX := 1;
    end
    else
    begin
      dz_dx := -dz_dx;
      DeltaX := -1;
    end;
  end;

  if YBelow = YAbove then
  begin
    dz_dy := 0;
    DeltaY := 0;
  end
  else
  begin
    // dz_dy is Delta Z due to a Delta Y of 1.
    dz_dy := (ZYAbove-ZYBelow)/(YAbove-YBelow);
    // Make sure UnitDeltaZ_Y is always less
    // than or equal to zero.
    if dz_dy > 1e-13 then
    begin
      DeltaY := -1;
      dz_dy := -dz_dy;
    end
    else
    begin
      DeltaY := 1;
    end;
  end;

  if dz_dx = dz_dy then
  begin
    Fraction := 0;
  end
  else
  begin
    Fraction := dz_dx/(dz_dx - dz_dy);
  end;


  DeltaX := Fraction*DeltaX;
  DeltaY := (1-Fraction)*DeltaY;
  if Abs(DeltaX) < 1e-9 then
  begin
    DipDirection := 0;
  end
  else if Abs(DeltaY) < 1e-9 then
  begin
    DipDirection := Pi/2;
  end
  else
  begin
    // DeltaX and DeltaY now define the strike direction.
    // The dip direction is 90 degrees off from that.
    DipDirection := ArcTan2(DeltaY,DeltaX) - Pi/2;
    // DipDirection is from -3*Pi/2 to Pi/2
  end;

  ReverseDirection := False;
  case DipDirNorthSouth of
    nsNorth:
      begin
        if DipDirection < -Pi/2 then
        begin
          ReverseDirection := True;
        end;
      end;
    nsSouth:
      begin
        if DipDirection > -Pi/2 then
        begin
          ReverseDirection := True;
        end;
      end;
  end;

  case DipDirEastWest of
    ewEast:
      begin
        if (DipDirection < 0) and (DipDirection > -Pi) then
        begin
          ReverseDirection := True;
        end;
      end;
    ewWest:
      begin
        if (DipDirection > 0) or (DipDirection < -Pi) then
        begin
          ReverseDirection := True;
        end;
      end;
  end;

  if ReverseDirection then
  begin
    DipDirection := DipDirection - Pi;
  end;

  while DipDirection < -Pi do
  begin
    DipDirection := DipDirection + 2*Pi;
  end;

  Dip := ArcTan((dz_dx - dz_dy)*Sqrt(Sqr(DeltaX) + Sqr(DeltaY)));

  DipDirection := DipDirection*180/Pi;
  while DipDirection < -180 do
  begin
    DipDirection := DipDirection + 360;
  end;
  while DipDirection > 180 do
  begin
    DipDirection := DipDirection - 360;
  end;

  Dip := Dip*180/Pi;
end;

procedure TfrmImportCrossSection.CreateDataLayers;
const
  ElevationName = 'Elevation';
  DipName = 'Dip in degrees';
  DipDirectionName = 'Dip Direction in degrees clockwise from North';
var
  Index: integer;
  Interpolator: TInterpolatorList;
  Layer: T_ANE_DataLayer;
  LayerTemplate : String;
  LayerHandle: ANE_PTR;
  Delta, MinX, MinY: double;
  XCount, YCount: integer;
  Count: integer;
  XIndex, YIndex: integer;
  X, Y: double;
  Values: pMatrix;
  PosX, PosY: PDoubleArray;
  Names: PParamNamesArray;
  ZValue: double;
  LayerName: string;
  UserResponse : integer;
  Dip, DipDirection: double;
begin
  GetInterpolationParameters(Delta, MinX, MinY, XCount, YCount);
  for Index := 0 to Interpolators.Count -1 do
  begin
    Interpolator := Interpolators.Objects[Index] as TInterpolatorList;
    LayerName := FixArgusName(Interpolators[Index]);

    if ANE_LayerGetHandleByName(CurrentModelHandle, PChar(LayerName)) = nil then
    begin
      Layer := T_ANE_NamedDataLayer.Create(LayerName, nil);
      try
        LayerTemplate := Layer.WriteLayer(CurrentModelHandle);
        LayerHandle := ANE_LayerAddByTemplate(CurrentModelHandle,
          PChar(LayerTemplate), nil);
      finally
        Layer.Free;
      end;
    end
    else
    if not GetValidLayerWithCancel(CurrentModelHandle, LayerHandle, T_ANE_DataLayer,
      LayerName, nil, UserResponse, LayerName, True) then
    begin
      continue;
    end;
    Count := 0;
    for XIndex := 0 to XCount-1 do
    begin
      X := MinX + Delta*XIndex;
      for YIndex := 0 to YCount -1 do
      begin
        Y := MinY + Delta*YIndex;
        if Interpolator.Find(X,Y) <> nil then
        begin
          Inc(Count);
        end;
      end;
    end;
    posX := nil;
    posY := nil;
    Values := nil;
    Names := nil;
    try
      GetMem(posX, Count * SizeOf(double));
      GetMem(posY, Count * SizeOf(double));
      GetMem(Values, 3 * SizeOf(pMatrix));
      GetMem(Names, 3 * SizeOf(ANE_STR));
      try
        begin
          GetMem(Values[0], Count * SizeOf(DOUBLE));
          GetMem(Values[1], Count * SizeOf(DOUBLE));
          GetMem(Values[2], Count * SizeOf(DOUBLE));

          GetMem(Names^[0], (Length(ElevationName) + 1));
          StrPCopy(Names^[0], ElevationName);
          GetMem(Names^[1], (Length(DipName) + 1));
          StrPCopy(Names^[1], DipName);
          GetMem(Names^[2], (Length(DipDirectionName) + 1));
          StrPCopy(Names^[2], DipDirectionName);

          Count := 0;
          for XIndex := 0 to XCount-1 do
          begin
            X := MinX + Delta*XIndex;
            for YIndex := 0 to YCount -1 do
            begin
              Y := MinY + Delta*YIndex;
              if Interpolator.InterpolatedValue(X,Y, ZValue) then
              begin
                PosX^[Count] := X;
                PosY^[Count] := Y;
                Values[0]^[Count] := ZValue;

                GetSlope(Interpolator, X, Y, ZValue, Delta, Dip, DipDirection);

                Values[1]^[Count] := Dip;
                Values[2]^[Count] := DipDirection;

                Inc(Count);
              end;
            end;
          end;

          ANE_DataLayerSetData(CurrentModelHandle,
            LayerHandle,
            Count,
            @PosX^,
            @PosY^,
            3,
            @Values^,
            @Names^);

        end;
      finally
        FreeMem(Values[0]);
        FreeMem(Values[1]);
        FreeMem(Values[2]);
        
        FreeMem(Names^[0]);
        FreeMem(Names^[1]);
        FreeMem(Names^[2]);
      end;
    finally
      FreeMem(Values);
      FreeMem(posY);
      FreeMem(posX);
      FreeMem(Names);
    end;
  end;
end;

procedure TfrmImportCrossSection.btnNextClick(Sender: TObject);
begin
  inherited;
  case pcMain.ActivePageIndex of
    0: // tabCrossSectionLocations
      begin
        CrossSections.Clear;
        CreateCrossSections;
        UpdateSectionDisplayControls;
        pcMain.ActivePageIndex := 1;
        zbCrossSections.ZoomOut;
      end;
    1:
      begin
        if CheckConnectingLineValidity then
        begin
          if not Saved and (MessageDlg(
            'Do you want to save the connections between the cross sections?',
            mtInformation, [mbYes, mbNo], 0) = mrYes) then
          begin
            btnSaveClick(nil);
          end;
          CreateInterpolators;
          comboLines2.ItemIndex := comboLines.ItemIndex;
          zbMap.ZoomOut;
          CalculateDefaultDelta;
          pcMain.ActivePageIndex := 2;
          btnNext.Caption := 'Finish';
        end
        else
        begin
          ShowInvalidConnections;
        end;
      end;
    2:
      begin
        Screen.Cursor := crHourGlass;
        try
          CreateDataLayers;
        finally
          Screen.Cursor := crdefault;
        end;
        ModalResult := mrOK;
      end;
  else
    begin
      Assert(False);
    end;
  end;
  btnBack.Enabled := True;
end;

procedure TfrmImportCrossSection.zbCrossSectionsPaint(Sender: TObject);
var
  Section: TCrossSection;
  Line: TCrossSectionLine;
  PointIndex: integer;
  ZoomPoint: TRbwZoomPoint;
  LineIndex: integer;
//  SectionName: string;
  Choice: TCrossSecChoice;
  Combo: TComboBox;
  ConnectingIndex: integer;
  ConnectingLine: TConnectingLine;
  XCoord: integer;
  YCoord: integer;
begin
  inherited;
  zbCrossSections.PBCanvas.Pen.Style := psSolid;
  zbCrossSections.PBCanvas.Pen.Color := clBlack;
  for Choice := Low(TCrossSecChoice) to High(TCrossSecChoice) do
  begin
    Combo := nil;
    case Choice of
      cscLower:
        begin
          Combo := comboLowerCrossSec;
        end;
      cscUpper:
        begin
          Combo := comboUpperCrossSec;
        end;
    else
      begin
        Assert(False);
      end;
    end;

    if Combo.ItemIndex >= 0 then
    begin
      Section := CrossSections.GetSectionByName(Combo.Text);
      if Section <> nil then
      begin
        for LineIndex := 0 to Section.Count -1 do
        begin
          Line := Section.SectionLineByIndex[LineIndex];

          if Line.LineName = comboLines.Text then
          begin
            zbCrossSections.PBCanvas.Pen.Width := 2;
          end
          else
          begin
            zbCrossSections.PBCanvas.Pen.Width := 1;
          end;

          ZoomPoint := nil;
          for PointIndex := 0 to Line.Count -1 do
          begin
            case Choice of
              cscLower:
                begin
                  ZoomPoint := Line.LowerZoomPoints[PointIndex];
                end;
              cscUpper:
                begin
                  ZoomPoint := Line.UpperZoomPoints[PointIndex];
                end;
            else
              begin
                Assert(False);
              end;
            end;
            if PointIndex = 0 then
            begin
              zbCrossSections.PBCanvas.MoveTo(ZoomPoint.XCoord, ZoomPoint.YCoord);
            end
            else
            begin
              zbCrossSections.PBCanvas.LineTo(ZoomPoint.XCoord, ZoomPoint.YCoord);
            end;
          end;
        end;
      end;
    end;
  end;
  zbCrossSections.PBCanvas.Pen.Width := 0;
  zbCrossSections.PBCanvas.Pen.Style := psDash;
  zbCrossSections.PBCanvas.Brush.Style := bsSolid;
  for ConnectingIndex := 0 to ConnectingLines.Count -1 do
  begin
    ConnectingLine := ConnectingLines[ConnectingIndex];

    if (ConnectingLine.Line = comboLines.Text) and
      ((ConnectingLine.StartPosition.Section = comboUpperCrossSec.Text) or
      (ConnectingLine.StartPosition.Section = comboLowerCrossSec.Text)) and
      ((ConnectingLine.EndPosition.Section = comboUpperCrossSec.Text) or
      (ConnectingLine.EndPosition.Section = comboLowerCrossSec.Text)) then
    begin
      if ConnectingLine.Valid then
      begin
        zbCrossSections.PBCanvas.Pen.Width := 0;
        zbCrossSections.PBCanvas.Pen.Color := clBlack;
      end
      else
      begin
        zbCrossSections.PBCanvas.Pen.Width := 2;
        zbCrossSections.PBCanvas.Pen.Color := clRed;
      end;

      zbCrossSections.PBCanvas.Brush.Color := clWhite;
      if ConnectingLine.StartPosition.Section = comboLowerCrossSec.Text then
      begin
        zbCrossSections.PBCanvas.MoveTo(
          zbCrossSections.XCoord(ConnectingLine.StartPosition.CrossX),
          zbCrossSections.YCoord(ConnectingLine.StartPosition.LowerZ));
        zbCrossSections.PBCanvas.LineTo(
          zbCrossSections.XCoord(ConnectingLine.EndPosition.CrossX),
          zbCrossSections.YCoord(ConnectingLine.EndPosition.UpperZ));

        zbCrossSections.PBCanvas.Pen.Width := 0;
        zbCrossSections.PBCanvas.Brush.Color := clBlack;
        XCoord := zbCrossSections.XCoord(ConnectingLine.StartPosition.CrossX);
        YCoord := zbCrossSections.YCoord(ConnectingLine.StartPosition.LowerZ);
        zbCrossSections.PBCanvas.Rectangle(XCoord-3, YCoord-3, XCoord+3, YCoord+3);

        XCoord := zbCrossSections.XCoord(ConnectingLine.EndPosition.CrossX);
        YCoord := zbCrossSections.YCoord(ConnectingLine.EndPosition.UpperZ);
        zbCrossSections.PBCanvas.Rectangle(XCoord-3, YCoord-3, XCoord+3, YCoord+3);
      end
      else
      begin
        zbCrossSections.PBCanvas.MoveTo(
          zbCrossSections.XCoord(ConnectingLine.StartPosition.CrossX),
          zbCrossSections.YCoord(ConnectingLine.StartPosition.UpperZ));
        zbCrossSections.PBCanvas.LineTo(
          zbCrossSections.XCoord(ConnectingLine.EndPosition.CrossX),
          zbCrossSections.YCoord(ConnectingLine.EndPosition.LowerZ));

        zbCrossSections.PBCanvas.Pen.Width := 0;
        zbCrossSections.PBCanvas.Brush.Color := clBlack;
        XCoord := zbCrossSections.XCoord(ConnectingLine.StartPosition.CrossX);
        YCoord := zbCrossSections.YCoord(ConnectingLine.StartPosition.UpperZ);
        zbCrossSections.PBCanvas.Rectangle(XCoord-3, YCoord-3, XCoord+3, YCoord+3);

        XCoord := zbCrossSections.XCoord(ConnectingLine.EndPosition.CrossX);
        YCoord := zbCrossSections.YCoord(ConnectingLine.EndPosition.LowerZ);
        zbCrossSections.PBCanvas.Rectangle(XCoord-3, YCoord-3, XCoord+3, YCoord+3);
      end;

    end;
  end;

  zbCrossSections.PBCanvas.Pen.Style := psSolid;
  if CurrentLine <> nil then
  begin
    zbCrossSections.PBCanvas.Brush.Color := clBlack;
    XCoord := zbCrossSections.XCoord(CurrentLine.StartPosition.CrossX);
    if CurrentLine.StartPosition.Section = comboLowerCrossSec.Text then
    begin
      YCoord := zbCrossSections.YCoord(CurrentLine.StartPosition.LowerZ);
    end
    else
    begin
      YCoord := zbCrossSections.YCoord(CurrentLine.StartPosition.UpperZ);
    end;
    zbCrossSections.PBCanvas.Rectangle(XCoord-3, YCoord-3, XCoord+3, YCoord+3);
  end;
end;

constructor TCrossSectionLine.Create;
begin
  inherited;
  FLowerZoomPoints:= TObjectList.Create;
  FUpperZoomPoints:= TObjectList.Create;
end;

destructor TCrossSectionLine.Destroy;
begin
  FLowerZoomPoints.Free;
  FUpperZoomPoints.Free;
  inherited;
end;

function TCrossSectionLine.GetLowerZoomPoints(Index: integer): TRbwZoomPoint;
begin
  EnsureLowerZoomPoints;
  result := FLowerZoomPoints[Index];
end;

procedure TfrmImportCrossSection.comboLowerCrossSecChange(Sender: TObject);
begin
  inherited;
  zbCrossSections.Invalidate;
end;

procedure TfrmImportCrossSection.comboUpperCrossSecChange(Sender: TObject);
begin
  inherited;
  zbCrossSections.Invalidate;
end;

procedure TfrmImportCrossSection.comboLinesChange(Sender: TObject);
begin
  inherited;
  zbCrossSections.Invalidate;
end;

function TCrossSectionLine.GetUpperZoomPoints(Index: integer): TRbwZoomPoint;
begin
  EnsureUpperZoomPoints;
  result := FUpperZoomPoints[Index];
end;

procedure TCrossSectionLine.FindClosestNodes(const CrossX: double;
  out LowerI, UpperI: integer);
var
  MiddleI: integer;
begin
  if Count <= 0 then
  begin
    LowerI := -1;
    UpperI := -1;
    Exit;
  end;
  if CrossX <= FCrossSectionX[0] then
  begin
    LowerI := 0;
    UpperI := 0;
    Exit;
  end;
  if CrossX >= FCrossSectionX[Count-1] then
  begin
    LowerI := Count-1;
    UpperI := Count-1;
    Exit;
  end;
  LowerI := 0;
  UpperI := Count-1;
  While UpperI - LowerI > 1 do
  begin
    MiddleI := (UpperI + LowerI) div 2;
    if CrossX < FCrossSectionX[MiddleI] then
    begin
      UpperI := MiddleI;
    end
    else
    begin
      LowerI := MiddleI;
    end;
  end;
end;

function TCrossSectionLine.GetLowerZFromCrossX(const CrossX: double): double;
var
  LowerI, UpperI: Integer;
  XLower, XUpper: double;
  ZLower, ZUpper: double;
begin
  FindClosestNodes(CrossX, LowerI, UpperI);
  XLower := FCrossSectionX[LowerI];
  ZLower := LowerZoomPoints[LowerI].Y;
  if XLower = CrossX then
  begin
    result := ZLower;
    Exit;
  end;
  XUpper := FCrossSectionX[UpperI];
  ZUpper := LowerZoomPoints[UpperI].Y;
  if XUpper = CrossX then
  begin
    result := ZUpper;
    Exit;
  end;
  if XLower = XUpper then
  begin
    result := (ZLower + ZUpper) / 2;
    Exit;
  end;
  result := Interpolate(ZLower, ZUpper, (CrossX-XLower)/(XUpper-XLower));
end;

function TCrossSectionLine.GetUpperZFromCrossX(const CrossX: double): double;
var
  LowerI, UpperI: Integer;
  XLower, XUpper: double;
  ZLower, ZUpper: double;
begin
  FindClosestNodes(CrossX, LowerI, UpperI);
  XLower := FCrossSectionX[LowerI];
  ZLower := UpperZoomPoints[LowerI].Y;
  if XLower = CrossX then
  begin
    result := ZLower;
    Exit;
  end;
  XUpper := FCrossSectionX[UpperI];
  ZUpper := UpperZoomPoints[UpperI].Y;
  if XUpper = CrossX then
  begin
    result := ZUpper;
    Exit;
  end;
  if XLower = XUpper then
  begin
    result := (ZLower + ZUpper) / 2;
    Exit;
  end;
  result := Interpolate(ZLower, ZUpper, (CrossX-XLower)/(XUpper-XLower));
end;

procedure TCrossSectionLine.InvalidateZoomPoints;
begin
  FLowerZoomPoints.Clear;
  FUpperZoomPoints.Clear;
end;

procedure TCrossSections.InvalidateZoomPoints;
var
  Index: integer;
begin
  for Index := 0 to Count -1 do
  begin
    SectionByIndex[Index].InvalidateZoomPoints;
  end;
end;

procedure TfrmImportCrossSection.zbCrossSectionsResize(Sender: TObject);
begin
  inherited;
  zbCrossSections.ZoomOut
end;

procedure TfrmImportCrossSection.zbCrossSectionsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if btnSelect.Down then
  begin
    CreateConnectingLine(X, Y);
  end
  else if btnDelete.Down then
  begin
    DeleteConnectingLine(X, Y);
  end;
end;

function TCrossSectionLine.Select(const X, Y: integer; const WhichLine: TCrossSecChoice;
      out CrossX: double): boolean;
begin
  result := False;
  case WhichLine of
    cscLower:
      begin
        EnsureLowerZoomPoints;
        result := FSection.FProfileZoomBox.SelectPolyLine(X,Y,FLowerArray);
      end;
    cscUpper:
      begin
        EnsureUpperZoomPoints;
        result := FSection.FProfileZoomBox.SelectPolyLine(X,Y,FUpperArray);
      end;
  else
    begin
      Assert(False);
    end;
  end;
  if result then
  begin
    CrossX := FSection.FProfileZoomBox.X(X);
    if CrossX < FCrossSectionX[0] then
    begin
      CrossX := FCrossSectionX[0];
    end
    else if CrossX > FCrossSectionX[Count -1] then
    begin
      CrossX := FCrossSectionX[Count -1];
    end;
  end;
end;

{ TConnectingLines }

function TConnectingLines.Add(Item: TConnectingLine): integer;
begin
  result := List.Add(Item);
end;

procedure TConnectingLines.Clear;
begin
  List.Clear;
end;

constructor TConnectingLines.Create;
begin
  inherited;
  List := TObjectList.Create;
end;

procedure TConnectingLines.Delete(Index: Integer);
begin
  List.Delete(Index);
end;

destructor TConnectingLines.Destroy;
begin
  List.Free;
  inherited;
end;

function TConnectingLines.GetCount: integer;
begin
  result := List.Count;
end;

function TConnectingLines.GetItems(const Index: integer): TConnectingLine;
begin
  result := List[Index]
end;

{ TConnectingLine }

constructor TConnectingLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Valid := True;
  FStartPosition := TPosition.Create;
  FEndPosition := TPosition.Create;
end;

procedure TfrmImportCrossSection.btnDeleteClick(Sender: TObject);
begin
  inherited;
  FreeAndNil(CurrentLine);
end;

function TfrmImportCrossSection.GetInterpolator(
  const Name: String): TInterpolatorList;
var
  Position: integer;
begin
  if (LastInterpolatorList <> nil) and (LastInterpolatorList.Name = Name) then
  begin
    result := LastInterpolatorList;
    Exit;
  end;
  Position := Interpolators.IndexOf(Name);
  if Position < 0 then
  begin
    result := TInterpolatorList.Create;
    result.Name := Name;
    Interpolators.AddObject(Name, result);
  end
  else
  begin
    result := Interpolators.Objects[Position] as TInterpolatorList;
  end;
  LastInterpolatorList := result;
end;

function TCrossSectionLine.GetZLocations(Index: integer): double;
begin
  result := FZLocations[Index];
end;

procedure TfrmImportCrossSection.GetInterpolationParameters(
  out Delta, MinX, MinY: double; out XCount, YCount: integer);
begin
  Delta := StrToFloat(adeDelta.Text);
  MinX := Trunc(zbMap.MinX/Delta)*Delta;
  XCount := Trunc((zbMap.MaxX - zbMap.MinX)/Delta) +1;
  MinY := Trunc(zbMap.MinY/Delta)*Delta;
  YCount := Trunc((zbMap.MaxY - zbMap.MinY)/Delta) +1;
end;

procedure TfrmImportCrossSection.zbMapPaint(Sender: TObject);
var
  CrossSectionIndex: integer;
  CrossSection: TCrossSection;
  MinZ, MaxZ: double;
  Line: TCrossSectionLine;
  MinX, MinY: double;
  Delta: double;
  X, Y: double;
  XIndex, YIndex: integer;
  XCount, YCount: integer;
  InterpolatorList: TInterpolatorList;
  InterpPosition: integer;
  ZValue: double;
  Color: TColor;
  Fraction: double;
  XCoord, YCoord: integer;
begin
  inherited;
  zbMap.PBCanvas.Pen.Width := 0;
  zbMap.PBCanvas.Pen.Color := clBlack;
  zbMap.PBCanvas.Brush.Color := clBlack;
  MinZ := 0;
  MaxZ := 0;
  for CrossSectionIndex := 0 to CrossSections.Count -1 do
  begin
    CrossSection := CrossSections.SectionByIndex[CrossSectionIndex];
    zbMap.PBCanvas.MoveTo(
      CrossSection.StartPoint.XCoord,
      CrossSection.StartPoint.YCoord);
    zbMap.PBCanvas.LineTo(
      CrossSection.EndPoint.XCoord,
      CrossSection.EndPoint.YCoord);
    if comboLines2.Text <> '' then
    begin
      Line := CrossSection.GetSectionLinesByName(comboLines2.Text);
      if Line = nil then Continue;
      if CrossSectionIndex = 0 then
      begin
        MinZ := Line.MinZ;
        MaxZ := Line.MaxZ;
      end
      else
      begin
        if MinZ > Line.MinZ then
        begin
          MinZ := Line.MinZ;
        end;
        if MaxZ < Line.MaxZ then
        begin
          MaxZ := Line.MaxZ;
        end;
      end;
    end;

  end;

  if comboLines2.Text <> '' then
  begin
    InterpPosition := Interpolators.IndexOf(comboLines2.Text);
    if InterpPosition >= 0 then
    begin
      InterpolatorList := Interpolators.Objects[InterpPosition]
        as TInterpolatorList;
      Assert(InterpolatorList <> nil);

      if adeDelta.Text <> '' then
      begin

        GetInterpolationParameters(Delta, MinX, MinY, XCount, YCount);

        for XIndex := 0 to XCount-1 do
        begin
          X := MinX + Delta * XIndex;
          XCoord := zbMap.XCoord(X);
          for YIndex := 0 to YCount -1 do
          begin
            Y := MinY + Delta * YIndex;
            YCoord := zbMap.YCoord(Y);
            if InterpolatorList.InterpolatedValue(X, Y, ZValue) then
            begin
              if MaxZ = MinZ then
              begin
                if ZValue > MaxZ then
                begin
                  Fraction := 1;
                end
                else if ZValue < MinZ then
                begin
                  Fraction := 0;
                end
                else
                begin
                  Fraction := 0.5;
                end;
              end
              else
              begin
                Fraction := (ZValue - MinZ)/(MaxZ - MinZ);
                if Fraction > 1 then
                begin
                  Fraction := 1;
                end
                else if Fraction < 0 then
                begin
                  Fraction := 0;
                end
              end;
              Fraction := 1-Fraction;
              Color := FracToSpectrum(Fraction);
              zbMap.PBCanvas.Pen.Color := Color;
              zbMap.PBCanvas.Brush.Color := Color;
              zbMap.PBCanvas.Rectangle(XCoord -1, YCoord-1, XCoord+1, YCoord+1);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmImportCrossSection.zbMapResize(Sender: TObject);
begin
  inherited;
  zbMap.ZoomOut;
end;

function TCrossSectionLine.GetMaxZ: double;
var
  Index: integer;
begin
  if FStoredMaxZ then
  begin
    result := FMaxZ;
    Exit;
  end;
  if Count = 0 then
  begin
    result := 0;
    Exit;
  end;
  result := FZLocations[0];
  for Index := 1 to Count -1 do
  begin
    if result < FZLocations[Index] then
    begin
      result := FZLocations[Index]
    end;
  end;
  FMaxZ := result;
  FStoredMaxZ := True;
end;

function TCrossSectionLine.GetMinZ: double;
var
  Index: integer;
begin
  if FStoredMinZ then
  begin
    result := FMinZ;
    Exit;
  end;
  if Count = 0 then
  begin
    result := 0;
    Exit;
  end;
  result := FZLocations[0];
  for Index := 1 to Count -1 do
  begin
    if result > FZLocations[Index] then
    begin
      result := FZLocations[Index]
    end;
  end;
  FMinZ := result;
  FStoredMinZ := True;
end;

procedure TfrmImportCrossSection.RemoveExtraConnectingLines;
var
  ConnectingIndex: Integer;
  ConnectingLine: TConnectingLine;
begin
  for ConnectingIndex := ConnectingLines.Count -1 downto 0 do
  begin
    ConnectingLine := ConnectingLines[ConnectingIndex];
    if not ConnectingLine.UserGenerated then
    begin
      ConnectingLines.Delete(ConnectingIndex);
    end;
  end;
end;

procedure TfrmImportCrossSection.ClearInterpolators;
var
  Index: Integer;
begin
  for Index := 0 to Interpolators.Count -1 do
  begin
    Interpolators.Objects[Index].Free;
  end;
  Interpolators.Clear;
end;

procedure TfrmImportCrossSection.btnBackClick(Sender: TObject);
begin
  inherited;
  LastInterpolatorList := nil;
  case pcMain.ActivePageIndex of
    0: // tabCrossSectionLocations
      begin
      end;
    1:
      begin
        CrossSections.Clear;
        ConnectingLines.Clear;
        pcMain.ActivePageIndex := 0;
        btnBack.Enabled := False;
      end;
    2:
      begin
        btnNext.Caption := 'Next';
        RemoveExtraConnectingLines;
        ClearInterpolators;
        pcMain.ActivePageIndex := 1;
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

procedure TfrmImportCrossSection.comboLines2Change(Sender: TObject);
begin
  inherited;
  zbMap.Invalidate;
end;

procedure TfrmImportCrossSection.btnApplyClick(Sender: TObject);
begin
  inherited;
  if ComponentState = [] then
  begin
    zbMap.Invalidate;
  end;
end;

procedure TConnectingLine.SetStartPosition(const Value: TPosition);
begin
  FStartPosition.Assign(Value);
end;

procedure TConnectingLine.SetEndPosition(const Value: TPosition);
begin
  FEndPosition.Assign(Value);
end;

destructor TConnectingLine.Destroy;
begin
  FStartPosition.Free;
  FEndPosition.Free;
  inherited;
end;

{ TPosition }


procedure TPosition.Assign(Source: TPersistent);
var
  SourceObject: TPosition;
begin
  if Source is TPosition then
  begin
    SourceObject := TPosition(Source);
    Section := SourceObject.Section;
    CrossX := SourceObject.CrossX;
    LowerZ := SourceObject.LowerZ;
    UpperZ := SourceObject.UpperZ;
  end
  else
  begin
    inherited;
  end;
end;

procedure TfrmImportCrossSection.btnSaveClick(Sender: TObject);
var
  ConnectingIndex: integer;
  ConnectingLine: TConnectingLine;
  MemStream: TMemoryStream;
  FileStream: TFileStream;
  TempStream: TMemoryStream;
begin
  inherited;
  if SaveDialog1.Execute then
  begin
    MemStream := TMemoryStream.Create;
    TempStream := TMemoryStream.Create;
    try
      for ConnectingIndex := 0 to ConnectingLines.Count -1 do
      begin
        ConnectingLine := ConnectingLines[ConnectingIndex];
        if ConnectingLine.UserGenerated then
        begin
          MemStream.WriteComponent(ConnectingLine);
        end;
      end;
      MemStream.Position := 0;
      While MemStream.Position < MemStream.Size do
      begin
        ObjectBinaryToText(MemStream, TempStream);
      end;
      FileStream := TFileStream.Create(SaveDialog1.FileName,
        fmCreate or fmShareDenyWrite, ReadWritePermissions);
      try
        TempStream.Position := 0;
        FileStream.CopyFrom(TempStream, TempStream.Size)
      finally
        FileStream.Free;
      end;
    finally
      MemStream.Free;
      TempStream.Free;
    end;
    Saved := True;
  end;
end;

procedure TfrmImportCrossSection.btnLoadClick(Sender: TObject);
var
  FileStream: TFileStream;
  MemStream, TempStream: TMemoryStream;
  ConnectingLine: TConnectingLine;

begin
  inherited;
  if OpenDialog1.Execute then
  begin
    SaveDialog1.FileName := OpenDialog1.FileName;
    Screen.Cursor := crHourGlass;
    FileStream := TFileStream.Create(OpenDialog1.FileName,
      fmOpenRead or fmShareDenyWrite, ReadWritePermissions);
    try
      FileStream.Position := 0;
      MemStream := TMemoryStream.Create;
      TempStream := TMemoryStream.Create;
      try
        MemStream.CopyFrom(FileStream, FileStream.Size);
        MemStream.Position := 0;
        While MemStream.Position < MemStream.Size do
        begin
          ObjectTextToBinary(MemStream, TempStream);
        end;

        TempStream.Position := 0;
        while TempStream.Position < TempStream.Size do
        begin
          ConnectingLine := TempStream.ReadComponent(nil) as TConnectingLine;
          if ConnectingLine <> nil then
          begin
            ConnectingLine.UserGenerated := True;
            ConnectingLines.Add(ConnectingLine);
          end;
        end;
      finally
        MemStream.Free;
        TempStream.Free;
      end;
    finally
      FileStream.Free;
      Screen.Cursor := crDefault;
    end;
    zbCrossSections.Invalidate;
  end;
end;

Initialization
  RegisterClass(TConnectingLine);

end.
