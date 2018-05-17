unit frmDEM_Unit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, RbwZoomBox, contnrs, ExtCtrls, Buttons, RealListUnit,
  Menus, ArgusFormUnit, AnePIE, addbtn95;

type
  TGridImportChoice = (gicNone, gicClosest, gicAverage, gicHighest, gicLowest);
  TMeshImportChoice = (micNone, micClosestNode, micAverageNode, micHighestNode,
    micLowestNode, micClosestElement, micAverageElement, micHighestElement,
    micLowestElement);

  TfrmDEM2BMP = class(TArgusForm)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    RbwZoomBox1: TRbwZoomBox;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Refresh1: TMenuItem;
    Panel1: TPanel;
    btnCancel: TBitBtn;
    sbPan: TSpeedButton;
    sbZoomExtents: TSpeedButton;
    sbZoomOut: TSpeedButton;
    sbZoomIn: TSpeedButton;
    sbZoom: TSpeedButton;
    Save1: TMenuItem;
    StatusBar1: TStatusBar;
    Help1: TMenuItem;
    Help2: TMenuItem;
    About1: TMenuItem;
    cbWhiteOcean: TCheckBox95;
    btnOK: TBitBtn;
    cbRed: TCheckBox;
    SaveasJPEG1: TMenuItem;
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure RbwZoomBox1Paint(Sender: TObject);
    procedure sbZoomExtentsClick(Sender: TObject);
    procedure sbZoomInClick(Sender: TObject);
    procedure sbZoomOutClick(Sender: TObject);
    procedure RbwZoomBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RbwZoomBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RbwZoomBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure sbZoomClick(Sender: TObject);
    procedure sbPanClick(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Help2Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SaveasJPEG1Click(Sender: TObject);

  private
    DemFile : File;
 {$IFDEF WriteB}     DemOutput : TextFile; {$ENDIF}
    CharCount : integer;
    Columncount : integer;
    angle : double;
    ResolutionX, ResolutionY : double;
    Range : array[0..1] of double;
    Corners : TObjectList;
    Done : boolean;
    CoordInSec : boolean;
    CentralMeridianRadians : double;
    DEM_Map : TBitMap;
    PointSize : integer;
    RangeList : TRealList;
    CancelBitMap : boolean;
    GridImportChoice : TGridImportChoice;
    MeshImportChoice : TMeshImportChoice;
    MinMeshX, MaxMeshX, MinMeshY, MaxMeshY : double;
    GridOutline : TZBArray;
    procedure ResetData;
    function ReadCharacters(const Count: integer): string;
    procedure ReadRecordA(const GetCentralMeridian : boolean);
    procedure ReadRecordB;
    procedure ReadRestOfRecord;
    procedure ReadRecordC;
    function FortranStrToFloat(AString: string): double;
    function UTMCentralMeridianRadians(LatitudeSeconds,
      LongitudeSeconds: double): double;
    function Get_N(LatitudeRadians : double) : double;
    function Get_T(LatitudeRadians : double) : double;
    function Get_C(LatitudeRadians : double) : double;
    function Get_A(LongitudeRadians, LatitudeRadians,
      CentralMeridianRadians: double): double;
    function Get_M(LatitudeRadians: double): double;
    procedure GetCoordinates(const LatitudeRadians, LongitudeRadians,
      CentralMeridian: double; var X, Y: double);
    procedure DrawOnBitMap;
    function BM_Width: integer;
    function BM_Height: integer;
    procedure SetCornerCoordinates;
    procedure MakeBitMap(const ShouldZoomOut : boolean);
    procedure GetRange;
    procedure GetGridOutline(const LayerName: string;
      var LayerHandle: ANE_PTR; var NRow, NCol: ANE_INT32;
      var GridAngle: ANE_DOUBLE);
    Procedure SetElevation(const Elevation, LocX, Locy : double);
    { Private declarations }
  public
    BlockList : TObjectList;
    NodeList : TObjectList;
    ElementList : TObjectList;
    Procedure GetBlockCenteredGrid(Const LayerName : string);
    procedure GetNodeCenteredGrid(const LayerName: string);
//    procedure GetGrid;
//    procedure GetMesh;
    Procedure GetMeshWithName(const LayerName : string);
    { Public declarations }
  end;

  TElevationPoint = class(TRbwZoomPoint)
  private
    FElevation: double;
    FColor : TColor;
    procedure SetElevation(const Value: double);
    procedure Draw(const ABitMap: TBitmap; const PointSize: integer);
  published
    property Elevation : double read FElevation write SetElevation;
  end;

  TNode = class(TRbwZoomPoint)
  private
    FElevation: double;
    Count : integer;
    Distance2 : double;
    procedure SetElevation(const LocX, LocY, AnElevation: double);
    function GetElevation : double;
  public
    Elements : TList;
    Points : TZBArray;
    Constructor Create; reintroduce;
    Destructor Destroy; override;
    procedure MakeCell;
    function IsInside(PointX, PointY: extended): boolean;
    Property Elevation : double read GetElevation;
  end;

  TElement = class(TObject)
  private
    FElevation: double;
    Count : integer;
    Distance2 : double;
    procedure SetElevation(const LocX, LocY, AnElevation: double); virtual;
    function GetElevation : double; virtual;
  public
    CenterX, CenterY : double;
    Points : TZBArray;
    Procedure Draw;
    procedure SetCenterPoint;
    function IndexOf(const Node : TNode) : integer;
    function IsInside(PointX, PointY: extended): boolean;
    Property Elevation : double read GetElevation;
  end;

  TBlock = class(TElement)
    Constructor Create;
    Destructor Destroy; override;
    procedure SetElevation(const LocX, LocY, AnElevation: double); override;
    function GetElevation : double; override;
  end;

  TSegment = class(TObject)
    Point1, Point2 : TRbwZoomPoint;
    function IsSimilar(const ASegment : TSegment;
      const Epsilon : extended) : boolean;
    destructor Destroy; override;
  end;

var
  frmDEM2BMP: TfrmDEM2BMP;

const  // Clarke ellipsoid
  LowerCase_a = 6378206.4; // in m
  e_square = 0.00676866;
  k_zero = 0.9996; // central scale factor
  e_prime_square = e_square/(1-e_square);
  CornerCount = 4;

type
  T3Point = array[0..3] of TPoint;
  T4Point = array[0..4] of TPoint;
  TDoubleArray = Array[0..MAXINT div 16] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = Array[0..MAXINT div 8] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..MAXINT div 8] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;

implementation

{$R *.DFM}

uses Math, CentralMeridianUnit, AboutUnit, OptionsUnit,
  UtilityFunctions, frmDataPositionUnit, LayerNamePrompt, ANE_LayerUnit,
  ANECB, JpegChoicesUnit;

type  
  TDEM_DataLayer = class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

function NearlyTheSame(const X,Y, Epsilon : extended) : boolean;
begin
  result := (X = Y)
    or (Abs(X-Y) < Epsilon)
    or (Abs(X-Y)/(Abs(X)+Abs(Y)+Epsilon) < Epsilon);
end;

function PointsNearlyTheSame(const Point1,Point2 : TRbwZoomPoint;
  const Epsilon: extended) : boolean;
var
  X1, X2, Y1, Y2 : double;
begin
  X1 := Point1.X;
  X2 := Point2.X;
  Y1 := Point1.Y;
  Y2 := Point2.Y;
  result := NearlyTheSame(X1, X2, Epsilon)
    and NearlyTheSame(Y1, Y2, Epsilon);
end;

Function FracToRainbow(Fraction : double) : TColor;
var
  Choice : integer;
begin
  Assert((Fraction>=0) and (Fraction<=1));
  fraction := Fraction*5;
  Choice := Trunc(fraction);
  fraction := Frac(fraction);
  result := 0;
  case Choice of
    0:
      begin
        result := Round(Fraction*$FF)*$100 + $FF;       // R -> R+G
      end;
    1:
      begin
        result := $FF00 + Round((1-Fraction)*$FF);      // R+G -> G
      end;
    2:
      begin
        result := Round(Fraction*$FF)*$10000 + $FF00;  // G -> G+B
      end;
    3:
      begin
        result := $FF0000 + Round((1-Fraction)*$FF)*$100; // G+B -> B
      end;
    4:
      begin
        result := Round(Fraction*$FF) + $FF0000;          // B -> B+R
      end;
    5:
      begin
        result := $FF00FF;
      end;                                               // B+R
  else
    begin
      Assert(False);
      result := 0;
    end;
  end;
end;

procedure TfrmDEM2BMP.ReadRestOfRecord;
var
  remainder : integer;
begin
  remainder := 1024 - CharCount mod 1024;
  if remainder <> 1024 then
  begin
    {$IFDEF WriteB} WriteLn(DemOutput,'remainder of record: ' + {$ENDIF} ReadCharacters(remainder){$IFDEF WriteB} ){$ENDIF};
  end;
  CharCount := 0;
end;

function TfrmDEM2BMP.ReadCharacters(const Count : integer) : string;
var
  I : integer;
  AChar : Char;
begin
  SetLength(result,Count);
  CharCount := CharCount + Count;
  for I := 1 to Count do
  begin
    BlockRead(DemFile,AChar, 1);
    result[i] := AChar;
  end;
end;

procedure TfrmDEM2BMP.SetCornerCoordinates;
var
  Index : integer;
  X, Y : double;
  CornerPoint : TRbwZoomPoint;
begin
  if CoordInSec then
  begin
    for Index := 0 to Corners.Count -1 do
    begin
      CornerPoint := Corners[Index] as TRbwZoomPoint;
      X := CornerPoint.X;
      Y := CornerPoint.Y;
      GetCoordinates(Y/60/60/180*PI, X/60/60/180*PI, CentralMeridianRadians, X, Y);
      CornerPoint.X := X;
      CornerPoint.Y := Y;
    end;
  end;
end;

procedure TfrmDEM2BMP.GetRange;
begin
  RangeList.Sort;
  if RangeList.Count > 1 then
  begin
    Range[0] := RangeList[0];
    Range[1] := RangeList[RangeList.Count-1];
  end;
  RangeList.Clear;
end;

procedure TfrmDEM2BMP.ReadRecordA(const GetCentralMeridian : boolean);
const
  CornerCount = 4;
var
  Index : integer;
  ColumncountString : string;
  AString : string;
//  temp : double;
  XString, YString : string;
  X, Y : double;
  CornerPoint : TRbwZoomPoint;
  MinOrMax : double;
begin
  CharCount := 0;
  {$IFDEF WriteB} WriteLn(DemOutput,'File name: ' + {$ENDIF} ReadCharacters(40) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Free Format Text: ' + {$ENDIF}  ReadCharacters(40) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Filler: ' +  {$ENDIF} ReadCharacters(55) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Process Code: ' + {$ENDIF}  ReadCharacters(1) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Filler: ' + {$ENDIF}  ReadCharacters(1) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Sectional Indicator: ' + {$ENDIF}  ReadCharacters(3) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'MC origin code: ' + {$ENDIF}  ReadCharacters(4) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'DEM level code: ' +  {$ENDIF} ReadCharacters(6) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Code defining elevation pattern (regular or random): ' + {$ENDIF}  ReadCharacters(6) {$IFDEF WriteB} ) {$ENDIF} ;
  AString := ReadCharacters(6);
  {$IFDEF WriteB} WriteLn(DemOutput,'Code defining ground planimetric reference system: ' + AString); {$ENDIF}
  CoordInSec := StrToInt(Trim(AString)) = 0;
  {$IFDEF WriteB} WriteLn(DemOutput,'Code defining zone in ground planimetric reference system: ' + {$ENDIF}  ReadCharacters(6) {$IFDEF WriteB} ) {$ENDIF} ;
  for Index := 1 to 15 do
  begin
    {$IFDEF WriteB} WriteLn(DemOutput,'planimetric code '  + intToStr(Index) + ': ' + {$ENDIF}  ReadCharacters(24) {$IFDEF WriteB} ) {$ENDIF} ;
  end;
  {$IFDEF WriteB} WriteLn(DemOutput,'Code defining unit of measure for ground planimetric coordinates throughout the file: ' + {$ENDIF}  ReadCharacters(6) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Code defining unit of measure for elevation coordinates throughout the file	: ' + {$ENDIF}  ReadCharacters(6) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Number (n) of sides in the polygon which defines the coverage of the DEM file: ' + {$ENDIF}  ReadCharacters(6) {$IFDEF WriteB} ) {$ENDIF} ;
  for Index := 1 to CornerCount do
  begin
    XString := ReadCharacters(24);
    YString := ReadCharacters(24);
    {$IFDEF WriteB} WriteLn(DemOutput,'corners (X,Y): ' + XString + ', ' + YString); {$ENDIF}
    X := FortranStrToFloat(XString);
    Y := FortranStrToFloat(YString);

    CornerPoint := TRbwZoomPoint.Create(RbwZoomBox1);
    try
      CornerPoint.X := X;
      CornerPoint.Y := Y;
      Corners.Add(CornerPoint);
    except
      CornerPoint.Free;
      raise;
    end;


  end;

  if CoordInSec and (Corners.Count > 0) then
  begin
    if GetCentralMeridian then
    begin
      X := 0;
      Y := 0;
      for Index := Corners.Count - CornerCount to Corners.Count -1 do
      begin
        CornerPoint := Corners[Index] as TRbwZoomPoint;
        X := X + CornerPoint.X;
        Y := Y + CornerPoint.Y;
      end;
      X := X/CornerCount;
      Y := Y/CornerCount;
      CentralMeridianRadians := UTMCentralMeridianRadians(Y,X);
    end;

  end;
  AString := ReadCharacters(24);
  {$IFDEF WriteB} WriteLn(DemOutput,'min or max elevation: ' + AString); {$ENDIF}
  MinOrMax := FortranStrToFloat(AString);
  RangeList.Add(MinOrMax);

  AString := ReadCharacters(24);
  {$IFDEF WriteB} WriteLn(DemOutput,'min or max elevation: ' + AString); {$ENDIF}
  MinOrMax := FortranStrToFloat(AString);
  RangeList.Add(MinOrMax);

  AString := ReadCharacters(24);
  Angle := StrToFloat(AString);
  {$IFDEF WriteB} WriteLn(DemOutput,'angle (radians): ' + AString); {$ENDIF}
  {$IFDEF WriteB} WriteLn(DemOutput,'accuracy code: ' + {$ENDIF}  ReadCharacters(6) {$IFDEF WriteB} ) {$ENDIF} ;
  AString := ReadCharacters(12);
  ResolutionX := StrToFloat(AString);
  {$IFDEF WriteB} WriteLn(DemOutput,'resolution X: ' + AString); {$ENDIF}
  AString := ReadCharacters(12);
  ResolutionY := StrToFloat(AString);
  {$IFDEF WriteB} WriteLn(DemOutput,'resolution Y: ' + AString); {$ENDIF}
  {$IFDEF WriteB} WriteLn(DemOutput,'resolution Z: ' + {$ENDIF}  ReadCharacters(12) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'rows: ' + {$ENDIF}  ReadCharacters(6) {$IFDEF WriteB} ) {$ENDIF} ;
  ColumncountString := ReadCharacters(6);
  ColumnCount := StrToInt(ColumncountString);
  {$IFDEF WriteB} WriteLn(DemOutput,'columns: ' + ColumncountString); {$ENDIF}
  {$IFDEF WriteB} WriteLn(DemOutput,'Largest primary contour interval: ' + {$ENDIF}  ReadCharacters(5) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'source contour interval units: ' + {$ENDIF}  ReadCharacters(1) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Smallest primary contour interval: ' + {$ENDIF}  ReadCharacters(5) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'source contour interval units: ' + {$ENDIF}  ReadCharacters(1) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Data source date: ' + {$ENDIF}  ReadCharacters(4) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Data inspection/revision date: ' + {$ENDIF}  ReadCharacters(4) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Inspection/revision flag: ' + {$ENDIF}  ReadCharacters(1) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Data validation flag: ' + {$ENDIF}  ReadCharacters(1) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Suspect and void area flag: ' + {$ENDIF}  ReadCharacters(2) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Vertical datum: ' + {$ENDIF}  ReadCharacters(2) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Horizontal datum: ' + {$ENDIF}  ReadCharacters(2) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Data Edition: ' +  {$ENDIF} ReadCharacters(4) {$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'Percent Void: ' + {$ENDIF}  ReadCharacters(4) {$IFDEF WriteB} ) {$ENDIF} ;
  ReadRestOfRecord;
end;

function TfrmDEM2BMP.FortranStrToFloat(AString : string) : double;
var
  DPos : integer;
  Sub : string;
begin
  AString := Trim(AString);
  DPos := Pos('d', AString);
  if DPos > 0 then
  begin
    AString[DPos] := 'e';
  end;
  DPos := Pos('D', AString);
  if DPos > 0 then
  begin
    AString[DPos] := 'E';
  end;
  if DecimalSeparator <> '.' then
  begin
    DPos := Pos(DecimalSeparator, AString);
    if DPos > 0 then
    begin
      AString[DPos] := DecimalSeparator;
    end;
  end;
  Sub := Copy(AString, 2, Length(AString));
  DPos := Pos('+', Sub);
  if DPos > 0 then
  begin
    if (AString[DPos] <> 'e') and (AString[DPos] <> 'E') then
    begin
      AString := Copy(AString, 1, DPos) + 'E' + Copy(AString, DPos + 1, Length(AString))
    end;
  end;
  DPos := Pos('-', Sub);
  if DPos > 0 then
  begin
    if (AString[DPos] <> 'e') and (AString[DPos] <> 'E') then
    begin
      AString := Copy(AString, 1, DPos) + 'E' + Copy(AString, DPos + 1, Length(AString))
    end;
  end;
  result := StrToFloat(AString);
end;

procedure TfrmDEM2BMP.ReadRecordB;
var
  m, n : integer;
  mString, nString : string;
  Index : integer;
  FirstX, FirstY : double;
  FirstXString, FirstYString : String;
  X, Y : double;
  AString : string;
  ElevationPoint : TElevationPoint;
  FirstPoint, SecondPoint : TElevationPoint;
begin
  FirstPoint := nil;
  CharCount := 0;
  {$IFDEF WriteB} WriteLn(DemOutput,''); {$ENDIF}
  {$IFDEF WriteB} WriteLn(DemOutput,'row: ' +{$ENDIF} ReadCharacters(6) {$IFDEF WriteB} ){$ENDIF};
  {$IFDEF WriteB} WriteLn(DemOutput,'column: ' +{$ENDIF} ReadCharacters(6) {$IFDEF WriteB} ){$ENDIF};
  mString := ReadCharacters(6);
  {$IFDEF WriteB} WriteLn(DemOutput,'m: ' + mString); {$ENDIF}
  nString := ReadCharacters(6);
  {$IFDEF WriteB} WriteLn(DemOutput,'n: ' + nString); {$ENDIF}
  FirstXString := ReadCharacters(24);
  {$IFDEF WriteB} WriteLn(DemOutput,'First X: ' + FirstXString); {$ENDIF}
  FirstYString := ReadCharacters(24);
  {$IFDEF WriteB} WriteLn(DemOutput,'First Y: ' + FirstYString); {$ENDIF}
  {$IFDEF WriteB} WriteLn(DemOutput,'Datum: ' + {$ENDIF} ReadCharacters(24){$IFDEF WriteB} ) {$ENDIF};
  {$IFDEF WriteB} WriteLn(DemOutput,'min or max: ' + {$ENDIF} ReadCharacters(24){$IFDEF WriteB} ) {$ENDIF};
  {$IFDEF WriteB} WriteLn(DemOutput,'min or max: ' + {$ENDIF} ReadCharacters(24){$IFDEF WriteB} ) {$ENDIF};
  FirstX := FortranStrToFloat(FirstXString);
  FirstY := FortranStrToFloat(FirstYString);
  m := StrToInt(Trim(mString));
  n := StrToInt(Trim(nString));
  for Index := 1 to m * n do
  begin
    if CharCount > 1024 -6 then
    begin
      ReadRestOfRecord;
    end;
    if angle = 0 then
    begin
      X := FirstX;
      Y := FirstY + (Index-1) * ResolutionY;
    end
    else
    begin
      X := FirstX + (Index-1) * ResolutionX * Sin(angle);
      Y := FirstY + (Index-1) * ResolutionY * Cos(angle);
    end;

    if CoordInSec then
    begin
      GetCoordinates(Y/60/60/180*PI, X/60/60/180*PI, CentralMeridianRadians, X, Y);
    end;

    AString := ReadCharacters(6);
    {$IFDEF WriteB} WriteLn(DemOutput,'X,Y,Elevation ' + IntToStr(Index) + ' : '
      + FloatToStr(X) + ', ' +  FloatToStr(Y) + ', ' +  AString); {$ENDIF}

    if Index =1 then
    begin
      FirstPoint := TElevationPoint.Create(RbwZoomBox1);
      try
        FirstPoint.UseForZoomOut := False;
        FirstPoint.X := X;
        FirstPoint.Y := Y;
        FirstPoint.Elevation := FortranStrToFloat(AString);
      except
        FirstPoint.Free;
        raise;
      end;
    end
    else if Index = 2 then
    begin
      SecondPoint := TElevationPoint.Create(RbwZoomBox1);
      try
        SecondPoint.UseForZoomOut := False;
        SecondPoint.X := X;
        SecondPoint.Y := Y;
        SecondPoint.Elevation := FortranStrToFloat(AString);
        PointSize := Abs(SecondPoint.YCoord - FirstPoint.YCoord) + 1;
        FirstPoint.Draw(DEM_Map, PointSize);
        SecondPoint.Draw(DEM_Map, PointSize);
      finally
        FirstPoint.Free;
        SecondPoint.Free;
      end;
    end
    else
    begin

      ElevationPoint := TElevationPoint.Create(RbwZoomBox1);
      try
        ElevationPoint.UseForZoomOut := False;
        ElevationPoint.X := X;
        ElevationPoint.Y := Y;
        ElevationPoint.Elevation := FortranStrToFloat(AString);
        ElevationPoint.Draw(DEM_Map, PointSize);
      finally
        ElevationPoint.Free;
      end;
    end;

  end;
  ReadRestOfRecord

end;

procedure TfrmDEM2BMP.ReadRecordC;
begin
  Try
  {$IFDEF WriteB} WriteLn(DemOutput,'Code indicating availability of statistics in data element 2: ' +{$ENDIF}  ReadCharacters(6){$IFDEF WriteB}) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'RMSE of file''s datum relative to absolute datum (x, y, z): '
    +{$ENDIF}  ReadCharacters(6) {$IFDEF WriteB} + ', ' + {$ELSE} ; {$ENDIF} ReadCharacters(6) {$IFDEF WriteB} + ', ' +{$ELSE} ; {$ENDIF} ReadCharacters(6) {$IFDEF WriteB}){$ENDIF};
  {$IFDEF WriteB} WriteLn(DemOutput,'sample size: ' + {$ENDIF} ReadCharacters(6){$IFDEF WriteB}){$ENDIF};
  {$IFDEF WriteB} WriteLn(DemOutput,'Code indicating availability of statistics in data element 5: ' +{$ENDIF} ReadCharacters(6){$IFDEF WriteB} ) {$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'RMSE of file''s datum relative to file''s datum (x, y, z): '
    +{$ENDIF} ReadCharacters(6) {$IFDEF WriteB} + ', ' +{$ELSE} ; {$ENDIF} ReadCharacters(6) {$IFDEF WriteB} + ', ' +{$ELSE} ; {$ENDIF} ReadCharacters(6){$IFDEF WriteB} ){$ENDIF} ;
  {$IFDEF WriteB} WriteLn(DemOutput,'sample size: ' + {$ENDIF} ReadCharacters(6) {$IFDEF WriteB} ){$ENDIF} ;
  except on E : EInOutError do
    begin
//      record C is not present.
    end;
  end;
end;

function TfrmDEM2BMP.BM_Width : integer;
begin
  if not Done then
  begin
    result := RbwZoomBox1.PBWidth - RbwZoomBox1.LeftMargin
      - RbwZoomBox1.RightMargin;
  end
  else
  begin
    result := Abs(RbwZoomBox1.XCoord(RbwZoomBox1.MaxX)
      - RbwZoomBox1.XCoord(RbwZoomBox1.MinX));
  end;
end;

function TfrmDEM2BMP.BM_Height : integer;
begin
  if not Done then
  begin
    result := RbwZoomBox1.PBHeight - RbwZoomBox1.TopMargin
      - RbwZoomBox1.BottomMargin;
  end
  else
  begin
    result := Abs(RbwZoomBox1.YCoord(RbwZoomBox1.MaxY)
      - RbwZoomBox1.YCoord(RbwZoomBox1.MinY))
  end;
end;

procedure TfrmDEM2BMP.DrawOnBitMap;
var
  ARect : TRect;
begin
  DEM_Map.Height := BM_Height;
  DEM_Map.Width :=  BM_Width;
  ARect.Left := 0;
  ARect.Top := 0;
  ARect.Right := DEM_Map.Width;
  ARect.Bottom := DEM_Map.Height;
  DEM_Map.Canvas.Brush.Color := RbwZoomBox1.PBColor;
  DEM_Map.Canvas.FillRect(ARect);

  RbwZoomBox1.Invalidate;
end;

procedure TfrmDEM2BMP.MakeBitMap(const ShouldZoomOut : boolean);
var
  Index : integer;
  FileIndex : integer;
  MeridianList : TRealList;
begin
  Open1.Enabled := False;
  Refresh1.Enabled := False;
  Save1.Enabled := False;
  sbZoom.Enabled := False;
  sbZoomIn.Enabled := False;
  sbZoomOut.Enabled := False;
  sbZoomExtents.Enabled := False;
  cbRed.Enabled := False;
//  btnCancel.Enabled := True;
  cbWhiteOcean.Enabled := False;
  btnOK.Enabled := False;
  CancelBitMap := False;
  RangeList.Clear;
  try
    ResetData;
    DrawOnBitMap;

    Corners.Clear;
    RangeList.Clear;
    MeridianList := TRealList.Create;
    try
      for FileIndex := 0 to OpenDialog1.Files.Count -1 do
      begin
        StatusBar1.Panels[1].Text := 'Reading ' + ExtractFileName(OpenDialog1.Files[FileIndex]);
        AssignFile(DemFile, OpenDialog1.Files[FileIndex]);
        try
          Reset(DemFile, SizeOf(Char));
          ReadRecordA(True);
          if CoordInSec and (MeridianList.IndexOf(CentralMeridianRadians) < 0) then
          begin
            MeridianList.Add(CentralMeridianRadians);
          end;

        finally
          CloseFile(DemFile);
        end;
      end;

      if MeridianList.Count > 1 then
      begin
        Application.CreateForm(TfrmCentralMeridian, frmCentralMeridian);
        try
          for Index := 0 to MeridianList.Count -1 do
          begin
            frmCentralMeridian.rgCentralMeridians.Items.Add(
              FloatToStr(MeridianList[Index]*180/Pi));
          end;
          if not frmCentralMeridian.ShowModal = mrOK then
          begin
            Exit;
          end;
          CentralMeridianRadians := MeridianList[frmCentralMeridian.rgCentralMeridians.ItemIndex];
        finally
          frmCentralMeridian.Free;
        end;

      end;
      GetRange;
      SetCornerCoordinates;
      if ShouldZoomOut then
      begin
        RbwZoomBox1.ZoomOut;
      end
      else
      begin
        RbwZoomBox1.GetMinMax;
      end;

      Done := True;
      DrawOnBitMap;

      Corners.Clear;

      for FileIndex := 0 to OpenDialog1.Files.Count -1 do
      begin
        StatusBar1.Panels[1].Text := 'Reading ' + ExtractFileName(OpenDialog1.Files[FileIndex]);
        AssignFile(DemFile, OpenDialog1.Files[FileIndex]);
    {$IFDEF WriteB}
        AssignFile(DemOutput, SaveDialog1.FileName);
    {$ENDIF}

        try
          Reset(DemFile, SizeOf(Char));
    {$IFDEF WriteB}
          Rewrite(DemOutput);
    {$ENDIF}
          ReadRecordA(False);
          for Index := 1 to ColumnCount do
          begin
            if CancelBitMap then Exit;
            ReadRecordB;
            Application.ProcessMessages;
            if Index mod 20 = 0 then
            begin
              RbwZoomBox1.Invalidate;
            end;

          end;
          ReadRecordC;

        finally
          CloseFile(DemFile);
    {$IFDEF WriteB}
          CloseFile(DemOutput);
    {$ENDIF}
        end;
      end;
      SetCornerCoordinates;
    finally
      MeridianList.Free;
    end;
  finally
    Open1.Enabled := True;
    Refresh1.Enabled := True;
    sbZoom.Enabled := True;
    sbZoomIn.Enabled := True;
    sbZoomOut.Enabled := True;
    sbZoomExtents.Enabled := True;
    cbRed.Enabled := True;
//    btnCancel.Enabled := False;
    btnOK.Enabled := True;
    cbWhiteOcean.Enabled := True;
    Save1.Enabled := True;
    StatusBar1.Panels[1].Text := 'Done';
  end;
end;

function TfrmDEM2BMP.UTMCentralMeridianRadians(LatitudeSeconds,
  LongitudeSeconds: double): double;
var
  LongAngleDegrees : integer;
  CenterMeridianDegrees : integer;
begin
  LongAngleDegrees := Trunc(LongitudeSeconds/3600);
  CenterMeridianDegrees := LongAngleDegrees div 6;
  CenterMeridianDegrees := CenterMeridianDegrees * 6;
  if CenterMeridianDegrees < 0 then
  begin
    CenterMeridianDegrees := CenterMeridianDegrees - 3;
  end
  else
  begin
    CenterMeridianDegrees := CenterMeridianDegrees + 3;
  end;
  result := CenterMeridianDegrees*Pi/180;
end;

function TfrmDEM2BMP.Get_N(LatitudeRadians: double): double;
begin
  result := LowerCase_a/Sqrt(1- e_square*Sqr(Sin(LatitudeRadians)));
end;

function TfrmDEM2BMP.Get_T(LatitudeRadians: double): double;
begin
  result := Sqr(Tan(LatitudeRadians));
end;

function TfrmDEM2BMP.Get_C(LatitudeRadians: double): double;
begin
  result := e_prime_square*Sqr(Cos(LatitudeRadians));
end;

function TfrmDEM2BMP.Get_A(LongitudeRadians, LatitudeRadians,
  CentralMeridianRadians: double): double;
begin
  Result := (LongitudeRadians - CentralMeridianRadians) * Cos(LatitudeRadians);
end;

function TfrmDEM2BMP.Get_M(LatitudeRadians: double): double;
var
  e_fourth, e_sixth : double;
begin
  e_fourth := Sqr(e_square);
  e_sixth := Power(e_square,3);
  Result := LowerCase_a *((1-e_square/4 - 3*e_fourth/64 - 5 * e_sixth/256)
    * LatitudeRadians - (3*e_square/8 + 3*e_fourth/32 + 45*e_sixth/1024)
    * sin(2*LatitudeRadians) + (15*e_fourth/256 + 45*e_sixth/1024)
    * sin(4*LatitudeRadians) - (35*e_sixth/3072) * sin(6*LatitudeRadians));
end;

procedure TfrmDEM2BMP.GetCoordinates(const LatitudeRadians,
  LongitudeRadians, CentralMeridian: double; var X, Y: double);
const
  M_zero = 0;
var
  N, A, T, C, M  : double;
begin
  N := Get_N(LatitudeRadians);
  A := Get_A(LongitudeRadians, LatitudeRadians, CentralMeridian);
  T := Get_T(LatitudeRadians);
  C := Get_C(LatitudeRadians);
  M := Get_M(LatitudeRadians);

  X := k_zero * N *(A + (1 - T +C)*Power(A,3)/6 + (5 -18*T + Sqr(T)
    + 72*C - 58*e_prime_square)* Power(A,5)/120);

  Y := k_zero * (M - M_zero + N * Tan(LatitudeRadians) *
    (Sqr(A)/2 + (5 - T + 9*C + 4*Sqr(C)) * Power(A,4)/24 +
    (61 - 58* T + Sqr(T) + 600 * C - 330*e_prime_square)*Power(A,6)/720));

  X := X + 500000;

  if Y < 0 then
  begin
    Y := Y + 10000000
  end;
end;

procedure TfrmDEM2BMP.FormCreate(Sender: TObject);
var
  DllDirectory : string;
begin
  Constraints.MinWidth := Width;
  Corners := TObjectList.Create;
  DEM_Map := TBitMap.Create;
  RangeList := TRealList.Create;
  DrawOnBitMap;
  PointSize := 1;
  if GetDllDirectory(GetDLLName, DllDirectory) then
  begin
    Application.HelpFile := DllDirectory + '\DEM_Import.hlp';
  end;

end;

procedure TfrmDEM2BMP.FormDestroy(Sender: TObject);
var
  Index : integer;
begin
  Corners.Free;
  DEM_Map.Free;
  RangeList.Free;
  BlockList.Free;
  NodeList.Free;
  ElementList.Free;
  for Index := 0 to Length(GridOutline) -2 do
  begin
    GridOutline[Index].Free;
  end;
end;

procedure TfrmDEM2BMP.RbwZoomBox1Paint(Sender: TObject);
var
  Rect : TRect;
  HeightRatio, WidthRatio : double;
  Index : integer;
  Block : TBlock;
  Element : TElement;
begin

  if (Dem_Map.Height = BM_Height)
    and (Dem_Map.Width = BM_Width) then
  begin
    RbwZoomBox1.PBCanvas.Draw(RbwZoomBox1.LeftMargin,
      RbwZoomBox1.TopMargin, DEM_Map);
  end
  else
  begin
    Rect.Left:= RbwZoomBox1.LeftMargin;
    Rect.Top := RbwZoomBox1.TopMargin;

    HeightRatio := DEM_Map.Height/BM_Height;
    WidthRatio :=  DEM_Map.Width/BM_Width;
    if HeightRatio > WidthRatio then
    begin
      Rect.Bottom := Rect.Top + BM_Height;
      Rect.Right := Rect.Left + Round(Dem_Map.Width/HeightRatio);
    end
    else
    begin
      Rect.Right := Rect.Left + BM_Width;
      Rect.Bottom := Rect.Top + Round(Dem_Map.Height/WidthRatio);
    end;
    RbwZoomBox1.PBCanvas.StretchDraw(Rect,DEM_Map);
  end;   
  if BlockList <> nil then
  begin
    for Index := 0 to BlockList.Count -1 do
    begin
      Block := BlockList[Index] as TBlock;
      Block.Draw;
    end;
  end;
  if ElementList <> nil then
  begin
    for Index := 0 to ElementList.Count -1 do
    begin
      Element := ElementList[Index] as TElement;
      Element.Draw;
    end;
  end;
end;

{ TElevationPoint }

procedure TElevationPoint.Draw(const ABitMap : TBitmap;
  const PointSize : integer);
var
  Rect: TRect;
  BM_X, BM_Y : integer;
  OffSet : integer;
begin
  OffSet := PointSize  div 2;
  ABitMap.Canvas.Brush.Color := FColor;
  BM_X := XCoord - ZoomBox.LeftMargin - OffSet;
  BM_Y := YCoord - ZoomBox.TopMargin - OffSet;
  Rect.Top := BM_Y;
  Rect.Left := BM_X;
  Rect.Bottom := BM_Y+PointSize;
  Rect.Right := BM_X+ PointSize;
  ABitMap.Canvas.FillRect(Rect);
end;

procedure TElevationPoint.SetElevation(const Value: double);
var
  Fraction : double;
begin
  FElevation := Value;

  if frmDEM2BMP.Range[1] = frmDEM2BMP.Range[0] then
  begin
    FColor := 0;
  end
  else
  begin
    if frmDEM2BMP.cbWhiteOcean.Checked and (Value = 0) then
    begin
      FColor := frmDEM2BMP.RbwZoomBox1.PBColor;
    end
    else
    begin
      Fraction := (Elevation - frmDEM2BMP.Range[0])
        /(frmDEM2BMP.Range[1] - frmDEM2BMP.Range[0]);
      if frmDEM2BMP.cbRed.Checked then
      begin
        Fraction := 1 - Fraction; 
      end;

      FColor := FracToRainbow(Fraction);
    end;
  end;

  frmDEM2BMP.SetElevation(FElevation, X, Y);

end;

procedure TfrmDEM2BMP.sbZoomExtentsClick(Sender: TObject);
begin
  RbwZoomBox1.ZoomOut;
  sbPan.Enabled := False;
end;

procedure TfrmDEM2BMP.sbZoomInClick(Sender: TObject);
begin
  RbwZoomBox1.ZoomBy(2);
  sbPan.Enabled := True;
end;

procedure TfrmDEM2BMP.sbZoomOutClick(Sender: TObject);
begin
  RbwZoomBox1.ZoomBy(0.5);
end;

procedure TfrmDEM2BMP.RbwZoomBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if sbZoom.Down then
  begin
    RbwZoomBox1.BeginZoom(X,Y);
  end
  else if sbPan.Down then
  begin
    RbwZoomBox1.BeginPan
  end;

end;

procedure TfrmDEM2BMP.RbwZoomBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if sbZoom.Down then
  begin
    RbwZoomBox1.FinishZoom(X,Y);
    sbPan.Enabled := True;
  end
  else if sbPan.Down then
  begin
    RbwZoomBox1.EndPan;
  end;

end;

procedure TfrmDEM2BMP.RbwZoomBox1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if sbZoom.Down then
  begin
    RbwZoomBox1.ContinueZoom(X,Y);
  end;
  StatusBar1.Panels[0].Text := '(X,Y) = ' + FloatToStr(RbwZoomBox1.X(x)) + ', ' +
    FloatToStr(RbwZoomBox1.Y(Y));
end;

procedure TfrmDEM2BMP.btnRefreshClick(Sender: TObject);
begin
  MakeBitmap(False);
end;

procedure TfrmDEM2BMP.btnCancelClick(Sender: TObject);
begin
  CancelBitMap := True;
end;

procedure TfrmDEM2BMP.Open1Click(Sender: TObject);
var
  ModalResult : integer;
begin
  Application.CreateForm(TfrmDataPosition, frmDataPosition);
  try
    if BlockList <> nil then
    begin
      frmDataPosition.PageControl1.ActivePage := frmDataPosition.tabGrid;
    end
    else
    begin
      frmDataPosition.PageControl1.ActivePage := frmDataPosition.tabMesh;
    end;
    ModalResult := frmDataPosition.ShowModal;
    if ModalResult = mrOK then
    begin
      if BlockList <> nil then
      begin
        MeshImportChoice := micNone;
        GridImportChoice := TGridImportChoice(frmDataPosition.rgGrid.ItemIndex+1);
      end
      else
      begin
        GridImportChoice := gicNone;
        MeshImportChoice := TMeshImportChoice(frmDataPosition.rgMesh.ItemIndex+1);
      end;
    end;

    if (ModalResult = mrOK) and OpenDialog1.Execute
      {$IFDEF WriteB} and SaveDialog1.Execute {$ENDIF}
      then
    begin
      MakeBitMap(True);
    end;
  finally
    frmDataPosition.Free;
  end;

end;

procedure TfrmDEM2BMP.Refresh1Click(Sender: TObject);
begin
  MakeBitmap(False);
end;

procedure TfrmDEM2BMP.sbZoomClick(Sender: TObject);
begin
  if sbZoom.Down then
  begin
    RbwZoomBox1.Cursor := crCross;
    RbwZoomBox1.PBCursor := crCross;
    RbwZoomBox1.SCursor := crCross;
  end
  else
  begin
    RbwZoomBox1.Cursor := crDefault;
    RbwZoomBox1.PBCursor := crDefault;
    RbwZoomBox1.SCursor := crDefault;
  end;
end;

procedure TfrmDEM2BMP.sbPanClick(Sender: TObject);
begin
  if sbPan.Down then
  begin
    RbwZoomBox1.Cursor := crHandPoint;
    RbwZoomBox1.PBCursor := crHandPoint;
    RbwZoomBox1.SCursor := crHandPoint;
  end
  else
  begin
    RbwZoomBox1.Cursor := crDefault;
    RbwZoomBox1.PBCursor := crDefault;
    RbwZoomBox1.SCursor := crDefault;
  end;

end;

procedure TfrmDEM2BMP.Save1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    DEM_Map.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TfrmDEM2BMP.About1Click(Sender: TObject);
begin
  Application.CreateForm(TfrmAbout, frmAbout);
  try
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;
end;

procedure TfrmDEM2BMP.Help2Click(Sender: TObject);
begin
  Application.HelpContext(10);
end;

procedure TfrmDEM2BMP.GetGridOutline(const LayerName : string;
  var LayerHandle : ANE_PTR; var NRow, NCol : ANE_INT32;
  var GridAngle : ANE_DOUBLE);
var
  MinX, MaxX, MinY, MaxY : ANE_DOUBLE;
  Index : integer;
  X, Y : double;
begin
  GetGrid(CurrentModelHandle, LayerName,
    LayerHandle, NRow, NCol, MinX, MaxX, MinY, MaxY, GridAngle);
  SetLength(GridOutline,5);
  for Index := 0 to 3 do
  begin
    GridOutline[Index] := TRbwZoomPoint.Create(RbwZoomBox1);
  end;
  GridOutline[4] := GridOutline[0];

  X := MinX;
  Y := MinY;
  RotatePointsFromGrid(X,Y,GridAngle);
  GridOutline[0].X := X;
  GridOutline[0].Y := Y;

  X := MaxX;
  Y := MinY;
  RotatePointsFromGrid(X,Y,GridAngle);
  GridOutline[1].X := X;
  GridOutline[1].Y := Y;

  X := MaxX;
  Y := MaxY;
  RotatePointsFromGrid(X,Y,GridAngle);
  GridOutline[2].X := X;
  GridOutline[2].Y := Y;

  X := MinX;
  Y := MaxY;
  RotatePointsFromGrid(X,Y,GridAngle);
  GridOutline[3].X := X;
  GridOutline[3].Y := Y;

end;

procedure TfrmDEM2BMP.GetNodeCenteredGrid(Const LayerName : string);
var
  LayerHandle : ANE_PTR;
  NRow, NCol : ANE_INT32;
  GridAngle : ANE_DOUBLE;
  RowPositions1, ColPositions1 : TRealList;
  RowPositions2, ColPositions2 : TRealList;
  RowIndex, ColIndex : integer;
  GridLayer : TGridLayerOptions;
  Block : TBlock;
  X, Y : double;
  RowsReversed, ColumnsReversed : boolean;
begin
  GetGridOutline(LayerName,
    LayerHandle, NRow, NCol, GridAngle);
  if (NRow > 0) and (NCol > 0) then
  begin
    RowPositions1 := TRealList.Create;
    ColPositions1 := TRealList.Create;
    RowPositions2 := TRealList.Create;
    ColPositions2 := TRealList.Create;
    GridLayer := TGridLayerOptions.Create(CurrentModelHandle, LayerHandle);
    try
      for RowIndex := 0 to NRow-1 do
      begin
        RowPositions1.Add(GridLayer.RowPositions(CurrentModelHandle,RowIndex));
      end;
      for ColIndex := 0 to NCol-1 do
      begin
        ColPositions1.Add(GridLayer.ColumnPositions(CurrentModelHandle,ColIndex));
      end;

      RowsReversed := GridLayer.GridReverseYDirection[CurrentModelHandle];
      ColumnsReversed := GridLayer.GridReverseXDirection[CurrentModelHandle];

      if RowsReversed then
      begin
        for RowIndex := 1 to ((RowPositions1.Count -1) div 2) do
        begin
          RowPositions1.Exchange(RowIndex, RowPositions1.Count -RowIndex);
        end;
      end;

      if ColumnsReversed then
      begin
        for ColIndex := 1 to ((ColPositions1.Count -1) div 2) do
        begin
          ColPositions1.Exchange(ColIndex, ColPositions1.Count -ColIndex);
        end;
      end;

      RowPositions2.Add(RowPositions1[0]);
      for RowIndex := 0 to RowPositions1.Count -2 do
      begin
        RowPositions2.Add((RowPositions1[RowIndex] + RowPositions1[RowIndex+1])/2);
      end;
      RowPositions2.Add(RowPositions1[RowPositions1.Count-1]);

      ColPositions2.Add(ColPositions1[0]);
      for ColIndex := 0 to ColPositions1.Count -2 do
      begin
        ColPositions2.Add((ColPositions1[ColIndex] + ColPositions1[ColIndex+1])/2);
      end;
      ColPositions2.Add(ColPositions1[ColPositions1.Count-1]);

      BlockList := TObjectList.Create;
      for RowIndex := 0 to RowPositions2.Count -2 do
      begin
        for ColIndex := 0 to ColPositions2.Count -2 do
        begin
          Block := TBlock.Create;
          BlockList.Add(Block);

          X := ColPositions2[ColIndex];
          Y := RowPositions2[RowIndex];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.Points[0] := TRbwZoomPoint.Create(RbwZoomBox1);
          Block.Points[0].X := X;
          Block.Points[0].Y := Y;

          X := ColPositions2[ColIndex+1];
          Y := RowPositions2[RowIndex];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.Points[1] := TRbwZoomPoint.Create(RbwZoomBox1);
          Block.Points[1].X := X;
          Block.Points[1].Y := Y;

          X := ColPositions2[ColIndex+1];
          Y := RowPositions2[RowIndex+1];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.Points[2] := TRbwZoomPoint.Create(RbwZoomBox1);
          Block.Points[2].X := X;
          Block.Points[2].Y := Y;

          X := ColPositions2[ColIndex];
          Y := RowPositions2[RowIndex+1];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.Points[3] := TRbwZoomPoint.Create(RbwZoomBox1);
          Block.Points[3].X := X;
          Block.Points[3].Y := Y;

          X := ColPositions1[ColIndex];
          Y := RowPositions1[RowIndex];
          RotatePointsFromGrid(X,Y,GridAngle);
          Block.CenterX := X;
          Block.CenterY := Y;
        end;

      end;

    finally
      RowPositions1.Free;
      ColPositions1.Free;
      RowPositions2.Free;
      ColPositions2.Free;
      GridLayer.Free(CurrentModelhandle);
    end;
  end;
  RbwZoomBox1.ZoomOut;
end;

procedure TfrmDEM2BMP.GetBlockCenteredGrid(Const LayerName : string);
var
  GridLayer : TGridLayerOptions;
  BlockIndex : ANE_INT32;
  Block : TBlock;
  BlockOptions : TBlockObjectOptions;
  XArray, YArray : TBlockCorners;
  CornerIndex : integer;
  LayerHandle : ANE_PTR;
  NRow, NCol : ANE_INT32;
  GridAngle : ANE_DOUBLE;
//  CornerPoint : TRbwZoomPoint;
begin
  GetGridOutline(LayerName, LayerHandle, NRow, NCol, GridAngle);
  GridLayer := TGridLayerOptions.Create(CurrentModelHandle, LayerHandle);
  try
    BlockList := TObjectList.Create;
    for BlockIndex := 0 to GridLayer.NumObjects(CurrentModelHandle,pieBlockObject) -1 do
    begin
      Block := TBlock.Create;
      BlockList.Add(Block);
      BlockOptions := TBlockObjectOptions.Create(CurrentModelHandle,
        GridLayer.LayerHandle, BlockIndex);
      try
        BlockOptions.GetCorners(CurrentModelHandle, XArray, YArray);
        for CornerIndex := 0 to CornerCount -1 do
        begin
          Block.Points[CornerIndex] := TRbwZoomPoint.Create(RbwZoomBox1);
          Block.Points[CornerIndex].X := XArray[CornerIndex];
          Block.Points[CornerIndex].Y := YArray[CornerIndex];
        end;
        Block.SetCenterPoint;
      finally
        BlockOptions.Free;
      end;
    end;
  finally
    GridLayer.Free(CurrentModelHandle);
  end;
  RbwZoomBox1.ZoomOut;
end;

{ TBlock }


constructor TBlock.Create;
begin
  inherited;
  SetLength(Points, CornerCount);
end;

{destructor TBlock.Destroy;
var
  PointIndex : integer;
begin
  for PointIndex := 0 to Length(Points)-1 do
  begin
    Points[PointIndex].Free;
  end;
end;  }

{procedure TBlock.Draw;
var
  PolygonPoints : array[0..CornerCount] of TPoint;
  Index : integer;
begin
  for Index := 0 to CornerCount - 1 do
  begin
    PolygonPoints[Index].X := Points[Index].XCoord;
    PolygonPoints[Index].Y := Points[Index].YCoord;
  end;
  PolygonPoints[CornerCount] := PolygonPoints[0];
  frmDEM2BMP.RbwZoomBox1.PBCanvas.Pen.Color := clBlack;
//  frmDEM2BMP.Canvas.Brush.Style := bsClear;
  frmDEM2BMP.RbwZoomBox1.PBCanvas.Polyline(PolygonPoints);
end;}

{procedure TBlock.SetCenterPoint;
var
  Index : integer;
begin
  CenterX := 0;
  CenterY := 0;
  for Index := 0 to CornerCount -1 do
  begin
    CenterX := CenterX + Points[Index].X;
    CenterY := CenterY + Points[Index].Y;
  end;
  CenterX := CenterX/CornerCount;
  CenterY := CenterY/CornerCount;
end;     }

{procedure TfrmDEM2BMP.GetGrid;
var
  Project : TProjectOptions;
  GridLayerNames : TStringList;
begin
  Project := TProjectOptions.Create;
  GridLayerNames := TStringList.Create;
  try
    Project.LayerNames(CurrentModelHandle, [pieGridLayer],GridLayerNames);
    if GridLayerNames.Count > 0 then
    begin
      GetNodeCenteredGrid(GridLayerNames[0]);
    end;
  finally
    GridLayerNames.Free;
    Project.Free;
  end;

end;

procedure TfrmDEM2BMP.GetMesh;
var
  Project : TProjectOptions;
  MeshLayerNames : TStringList;
begin
  Project := TProjectOptions.Create;
  MeshLayerNames := TStringList.Create;
  try
    Project.LayerNames(CurrentModelHandle, [pieTriMeshLayer,pieQuadMeshLayer],MeshLayerNames);
    if MeshLayerNames.Count > 0 then
    begin
      GetMeshWithName(MeshLayerNames[0]);
    end;
  finally
    MeshLayerNames.Free;
    Project.Free;
  end;
end;  }

procedure TfrmDEM2BMP.GetMeshWithName(const LayerName: string);
var
  MeshLayer : TLayerOptions;
  NodeIndex : ANE_INT32;
  ElementIndex : ANE_INT32;
  NodeOption : TNodeObjectOptions;
  Node : TNode;
  X, Y: ANE_DOUBLE;
  ElementOptions : TElementObjectOptions;
  Element : TElement;
  NodeCount : integer;
begin
  MeshLayer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
  try
    NodeList := TObjectList.Create;
    ElementList := TObjectList.Create;

    for NodeIndex := 0 to MeshLayer.NumObjects
      (CurrentModelHandle, pieNodeObject) -1 do
    begin
      NodeOption := TNodeObjectOptions.Create(CurrentModelHandle,
        MeshLayer.LayerHandle, NodeIndex);
      try
        Node := TNode.Create;
        NodeList.Add(Node);
        NodeOption.GetLocation(CurrentModelHandle, X, Y);
        Node.X := X;
        Node.Y := Y;
      finally
        NodeOption.Free;
      end;
    end;

    for ElementIndex := 0 to MeshLayer.NumObjects
      (CurrentModelHandle, pieElementObject) -1 do
    begin
      ElementOptions := TElementObjectOptions.Create
        (CurrentModelHandle,MeshLayer.LayerHandle, ElementIndex);
      try
        NodeCount := ElementOptions.NumberOfNodes(CurrentModelHandle);
        Element := TElement.Create;
        ElementList.Add(Element);
        SetLength(Element.Points,NodeCount);
        for NodeIndex := 0 to NodeCount-1 do
        begin
          Node := NodeList[ElementOptions.GetNthNodeNumber
            (CurrentModelHandle,NodeIndex) -1] as TNode;
          Element.Points[NodeIndex] := Node;
          Node.Elements.Add(Element);
        end;
        Element.SetCenterPoint;
      finally
        ElementOptions.Free;
      end;
    end;
    for NodeIndex := 0 to NodeList.Count -1 do
    begin
      Node := NodeList[NodeIndex] as TNode;
      Node.MakeCell;
    end;

  finally
    MeshLayer.Free(CurrentModelHandle);
  end;
  RbwZoomBox1.ZoomOut;
  MinMeshX := RbwZoomBox1.MinX;
  MaxMeshX := RbwZoomBox1.MaxX;
  MinMeshY := RbwZoomBox1.MinY;
  MaxMeshY := RbwZoomBox1.MaxY;
end;

{ TElement }

{destructor TElement.Destroy;
var
  PointIndex : integer;
begin
  for PointIndex := 0 to Length(Points)-1 do
  begin
    Points[PointIndex].Free;
  end;
  inherited;
end;    }

procedure TElement.Draw;
var
  PLine3 : T3Point;
  PLine4 : T4Point;
  Index : integer;
begin
  if Length(Points) = 3 then
  begin
    for Index := 0 to Length(Points) - 1 do
    begin
      PLine3[Index].X := Points[Index].XCoord;
      PLine3[Index].Y := Points[Index].YCoord;
    end;
    PLine3[Length(Points)] := PLine3[0];
    frmDEM2BMP.RbwZoomBox1.PBCanvas.Pen.Color := clBlack;
    frmDEM2BMP.RbwZoomBox1.PBCanvas.Polyline(PLine3);
  end
  else if Length(Points) = 4 then
  begin
    for Index := 0 to Length(Points) - 1 do
    begin
      PLine4[Index].X := Points[Index].XCoord;
      PLine4[Index].Y := Points[Index].YCoord;
    end;
    PLine4[Length(Points)] := PLine4[0];
    frmDEM2BMP.RbwZoomBox1.PBCanvas.Pen.Color := clBlack;
    frmDEM2BMP.RbwZoomBox1.PBCanvas.Polyline(PLine4);
  end;

end;

function TElement.GetElevation: double;
begin
  case frmDEM2BMP.MeshImportChoice of
    micClosestElement, micHighestElement, micLowestElement:
      begin
        if Count = 0 then
        begin
          result := 0;
        end
        else
        begin
          result := FElevation;
        end;
      end;
    micAverageElement:
      begin
        if Count = 0 then
        begin
          result := 0;
        end
        else
        begin
          result := FElevation/Count;
        end;
      end;
  else
    result := 0;
  end;
end;

function TElement.IndexOf(const Node: TNode): integer;
var
  Index : integer;
begin
  result := -1;
  for Index := 0 to Length(Points) -1 do
  begin
    if Points[Index] = Node then
    begin
      result := Index;
      Exit;
    end;
  end;
end;

function TElement.IsInside(PointX, PointY: extended): boolean;
var
  ArrayLength : integer;
begin
  ArrayLength := Length(Points);
  try
    SetLength(Points,ArrayLength+1);
    Points[ArrayLength] := Points[0];
    result := frmDEM2BMP.RbwZoomBox1.IsPointInside(PointX, PointY, Points);
  finally
    SetLength(Points,ArrayLength);
  end;
end;

procedure TElement.SetCenterPoint;
var
  Index : integer;
begin
  CenterX := 0;
  CenterY := 0;
  for Index := 0 to Length(Points) -1 do
  begin
    CenterX := CenterX + Points[Index].X;
    CenterY := CenterY + Points[Index].Y;
  end;
  CenterX := CenterX/Length(Points);
  CenterY := CenterY/Length(Points);
end;

destructor TBlock.Destroy;
var
  PointIndex : integer;
begin
  for PointIndex := 0 to Length(Points)-1 do
  begin
    Points[PointIndex].Free;
  end;
  inherited;
end;

function TBlock.GetElevation: double;
begin
  case frmDEM2BMP.GridImportChoice of
    gicClosest, gicHighest, gicLowest:
      begin
        if Count = 0 then
        begin
          result := 0;
        end
        else
        begin
          result := FElevation;
        end;
      end;
    gicAverage:
      begin
        if Count = 0 then
        begin
          result := 0;
        end
        else
        begin
          result := FElevation/Count;
        end;
      end;
  else
    result := 0;
  end;
end;

procedure TBlock.SetElevation(const LocX, LocY, AnElevation: double);
var
  PointDistance2 : double;
begin
  case frmDEM2BMP.GridImportChoice of
    gicClosest:
      begin
        if Count = 0 then
        begin
          FElevation := AnElevation;
          Count := 1;
          Distance2 := Sqr(CenterX - LocX) + Sqr(CenterY - LocY);
        end
        else
        begin
          PointDistance2 := Sqr(CenterX - LocX) + Sqr(CenterY - LocY);
          if PointDistance2 < Distance2 then
          begin
            FElevation := AnElevation;
            Distance2 := PointDistance2;
          end;
        end;
      end;
    gicAverage:
      begin
        FElevation := FElevation + AnElevation;
        Inc(Count);
      end;
    gicHighest:
      begin
        if Count = 0 then
        begin
          FElevation := AnElevation;
          Count := 1;
        end
        else
        begin
          if AnElevation > FElevation then
          begin
            FElevation := AnElevation;
          end;
        end;
      end;
    gicLowest:
      begin
        if Count = 0 then
        begin
          FElevation := AnElevation;
          Count := 1;
        end
        else
        begin
          if AnElevation < FElevation then
          begin
            FElevation := AnElevation;
          end;
        end;
      end;
  end;
end;

{ TNode }

constructor TNode.Create;
begin
  inherited Create(frmDEM2BMP.RbwZoomBox1);
  Elements := TList.Create;
end;

destructor TNode.Destroy;
var
  PointIndex : integer;
begin
  Elements.Free;
  for PointIndex := 0 to Length(Points)-1 do
  begin
    Points[PointIndex].Free;
  end;
  inherited;
end;

function TNode.GetElevation: double;
begin
  case frmDEM2BMP.MeshImportChoice of
    micClosestNode, micHighestNode, micLowestNode:
      begin
        if Count = 0 then
        begin
          result := 0;
        end
        else
        begin
          result := FElevation;
        end;
      end;
    micAverageNode:
      begin
        if Count = 0 then
        begin
          result := 0;
        end
        else
        begin
          result := FElevation/Count;
        end;
      end;
  else
    result := 0;
  end;
end;

function TNode.IsInside(PointX, PointY: extended): boolean;
var
  ArrayLength : integer;
begin
  ArrayLength := Length(Points);
  try
    SetLength(Points,ArrayLength+1);
    Points[ArrayLength] := Points[0];
    result := ZoomBox.IsPointInside(PointX, PointY, Points);
  finally
    SetLength(Points,ArrayLength);
  end;
end;

procedure TNode.MakeCell;
const
  Epsilon = 1e-8;
Var
  NextNode, PreviousNode : TNode;
  NodeIndex, SegmentIndex : integer;
  Element : TElement;
  CellParts : TList;
  CellPart : TList;
  ElementIndex : integer;
  OuterCellPart, InnerCellPart : TList;
  SideDeleted : boolean;
  NextSideFound : boolean;
  CellList : TList;
  FirstPoint, LastPoint : TRbwZoomPoint;
  ASegment : TSegment;
  function DeleteSide : boolean;
  var
    OuterCellPartIndex, InnerCellPartIndex : integer;
    OuterSegmentIndex, InnerSegmentIndex : integer;
    Seg1, Seg2 : TSegment;
  begin
    result := False;
    for OuterCellPartIndex := 0 to CellParts.Count -2 do
    begin
      OuterCellPart := CellParts[OuterCellPartIndex];
      for InnerCellPartIndex := OuterCellPartIndex + 1 to CellParts.Count -1 do
      begin
        InnerCellPart := CellParts[InnerCellPartIndex];
        for OuterSegmentIndex := OuterCellPart.Count -1 downto 0 do
        begin
          Seg1 := OuterCellPart[OuterSegmentIndex];
          for InnerSegmentIndex := InnerCellPart.Count -1 downto 0 do
          begin
            Seg2 := InnerCellPart[InnerSegmentIndex];
            if Seg1.IsSimilar(Seg2, Epsilon) then
            begin
              result := True;
              Seg1.Free;
              Seg2.Free;
              OuterCellPart.Delete(OuterSegmentIndex);
              InnerCellPart.Delete(InnerSegmentIndex);
              Exit;
            end;
          end;
        end;
      end;
    end;
  end;
  function GetNextSide : boolean;
  var
    ElementIndex : integer;
    SegmentIndex : integer;
    LastPoint, NextPoint : TRbwZoomPoint;
    ASegment : TSegment;
  begin
    result := False;
    LastPoint := CellList[CellList.Count -1];
    for ElementIndex := 0 to CellParts.Count -1 do
    begin
      CellPart := CellParts[ElementIndex];
      if CellPart.Count > 0 then
      begin
        ASegment := CellPart[0];
        NextPoint := ASegment.Point1;
        if PointsNearlyTheSame(LastPoint,NextPoint,Epsilon) then
        begin
//          ASegment.Free;
          for SegmentIndex := 0 to CellPart.Count -1 do
          begin
            ASegment := CellPart[SegmentIndex];
            CellList.Add(ASegment.Point2);
            ASegment.Point2 := nil;
            ASegment.Free;
          end;
          CellPart.Clear;
          result := True;
          Exit;
        end
        else
        begin
          ASegment := CellPart[CellPart.Count -1];
          NextPoint := ASegment.Point2;
          if PointsNearlyTheSame(LastPoint,NextPoint,Epsilon) then
          begin
//            ASegment.Free;
            for SegmentIndex := CellPart.Count -1 downto 0 do
            begin
              ASegment := CellPart[SegmentIndex];
              CellList.Add(ASegment.Point1);
              ASegment.Point1 := nil;
              ASegment.Free;
            end;
            CellPart.Clear;
            result := True;
            Exit;
          end
        end;

      end;
    end;
  end;
begin
  CellList := TList.Create;
  CellParts := TList.Create;
  try
    for ElementIndex := 0 to Elements.Count -1 do
    begin
      Element := Elements[ElementIndex];
      NodeIndex := Element.IndexOf(self);
      if NodeIndex >= Length(Element.Points) - 1 then
      begin
        NodeIndex := 0
      end
      else
      begin
        Inc(NodeIndex);
      end;
      NextNode := Element.Points[NodeIndex] as TNode;
      Dec(NodeIndex,2);
      if NodeIndex < 0 then
      begin
        NodeIndex := Length(Element.Points) + NodeIndex;
      end;
      PreviousNode := Element.Points[NodeIndex] as TNode;
      CellPart := TList.Create;
      CellParts.Add(CellPart);

      ASegment := TSegment.Create;
      CellPart.Add(ASegment);
      ASegment.Point1 := TRbwZoomPoint.Create(frmDEM2BMP.RbwZoomBox1);
      ASegment.Point1.X := X;
      ASegment.Point1.Y := Y;
      ASegment.Point2 := TRbwZoomPoint.Create(frmDEM2BMP.RbwZoomBox1);
      ASegment.Point2.X := (X + PreviousNode.X)/2;
      ASegment.Point2.Y := (Y + PreviousNode.Y)/2;

      ASegment := TSegment.Create;
      CellPart.Add(ASegment);
      ASegment.Point1 := TRbwZoomPoint.Create(frmDEM2BMP.RbwZoomBox1);
      ASegment.Point1.X := (X + PreviousNode.X)/2;
      ASegment.Point1.Y := (Y + PreviousNode.Y)/2;
      ASegment.Point2 := TRbwZoomPoint.Create(frmDEM2BMP.RbwZoomBox1);
      ASegment.Point2.X := Element.CenterX;
      ASegment.Point2.Y := Element.CenterY;

      ASegment := TSegment.Create;
      CellPart.Add(ASegment);
      ASegment.Point1 := TRbwZoomPoint.Create(frmDEM2BMP.RbwZoomBox1);
      ASegment.Point1.X := Element.CenterX;
      ASegment.Point1.Y := Element.CenterY;
      ASegment.Point2 := TRbwZoomPoint.Create(frmDEM2BMP.RbwZoomBox1);
      ASegment.Point2.X := (X + NextNode.X)/2;
      ASegment.Point2.Y := (Y + NextNode.Y)/2;

      ASegment := TSegment.Create;
      CellPart.Add(ASegment);
      ASegment.Point1 := TRbwZoomPoint.Create(frmDEM2BMP.RbwZoomBox1);
      ASegment.Point1.X := (X + NextNode.X)/2;
      ASegment.Point1.Y := (Y + NextNode.Y)/2;
      ASegment.Point2 := TRbwZoomPoint.Create(frmDEM2BMP.RbwZoomBox1);
      ASegment.Point2.X := X;
      ASegment.Point2.Y := Y;
    end;
    Repeat
      SideDeleted := DeleteSide;
    until not SideDeleted;

    for ElementIndex := CellParts.Count -1 downto 0 do
    begin
      CellPart := CellParts[ElementIndex];
      if CellPart.Count = 0 then
      begin
        CellPart.Free;
        CellParts.Delete(ElementIndex);
      end;
    end;

    if CellParts.Count > 0 then
    begin
      CellPart := CellParts[0];
      for SegmentIndex := 0 to CellPart.Count -1 do
      begin
        ASegment := CellPart[SegmentIndex];
        if SegmentIndex = 0 then
        begin
          CellList.Add(ASegment.Point1);
          ASegment.Point1 := nil;
        end;
        CellList.Add(ASegment.Point2);
        ASegment.Point2 := nil;
        ASegment.Free;
      end;
      CellPart.Free;
      CellParts.Delete(0);

      repeat
        NextSideFound := GetNextSide
      until not NextSideFound;

    end;

    if CellList.Count > 1 then
    begin
      FirstPoint := CellList[0];
      LastPoint := CellList[CellList.Count -1];
      if PointsNearlyTheSame(FirstPoint,LastPoint,Epsilon) then
      begin
        LastPoint.Free;
        CellList.Delete(CellList.Count -1);
      end;

    end;

    SetLength(Points,CellList.Count);
    for NodeIndex := 0 to CellList.Count -1 do
    begin
      Points[NodeIndex] := CellList[NodeIndex];
    end;

  finally
    for ElementIndex := 0 to CellParts.Count -1 do
    begin
      CellPart := CellParts[ElementIndex];
      CellPart.Free;
    end;
    CellParts.Free;
    CellList.Free;
  end;

end;

procedure TNode.SetElevation(const LocX, LocY, AnElevation: double);
var
  PointDistance2 : double;
begin
  case frmDEM2BMP.MeshImportChoice of
    micClosestNode:
      begin
        if Count = 0 then
        begin
          FElevation := AnElevation;
          Count := 1;
          Distance2 := Sqr(X - LocX) + Sqr(Y - LocY);
        end
        else
        begin
          PointDistance2 := Sqr(X - LocX) + Sqr(Y - LocY);
          if PointDistance2 < Distance2 then
          begin
            FElevation := AnElevation;
            Distance2 := PointDistance2;
          end;
        end;
      end;
    micAverageNode:
      begin
        FElevation := FElevation + AnElevation;
        Inc(Count);
      end;
    micHighestNode:
      begin
        if Count = 0 then
        begin
          FElevation := AnElevation;
          Count := 1;
        end
        else
        begin
          if AnElevation > FElevation then
          begin
            FElevation := AnElevation;
          end;
        end;
      end;
    micLowestNode:
      begin
        if Count = 0 then
        begin
          FElevation := AnElevation;
          Count := 1;
        end
        else
        begin
          if AnElevation < FElevation then
          begin
            FElevation := AnElevation;
          end;
        end;
      end;
  end;
end;

{ TSegment }

destructor TSegment.Destroy;
begin
  Point1.Free;
  Point2.Free;
  inherited;
end;

function TSegment.IsSimilar(const ASegment: TSegment;
  const Epsilon : extended): boolean;
begin
  result := (PointsNearlyTheSame(Point1,ASegment.Point1, Epsilon)
    and PointsNearlyTheSame(Point2,ASegment.Point2, Epsilon)) or
    (PointsNearlyTheSame(Point1,ASegment.Point2, Epsilon)
    and PointsNearlyTheSame(Point2,ASegment.Point1, Epsilon))
end;


procedure TElement.SetElevation(const LocX, LocY, AnElevation: double);
var
  PointDistance2 : double;
begin
  case frmDEM2BMP.MeshImportChoice of
    micClosestElement:
      begin
        if Count = 0 then
        begin
          FElevation := AnElevation;
          Count := 1;
          Distance2 := Sqr(CenterX - LocX) + Sqr(CenterY - LocY);
        end
        else
        begin
          PointDistance2 := Sqr(CenterX - LocX) + Sqr(CenterY - LocY);
          if PointDistance2 < Distance2 then
          begin
            FElevation := AnElevation;
            Distance2 := PointDistance2;
          end;
        end;
      end;
    micAverageElement:
      begin
        FElevation := FElevation + AnElevation;
        Inc(Count);
      end;
    micHighestElement:
      begin
        if Count = 0 then
        begin
          FElevation := AnElevation;
          Count := 1;
        end
        else
        begin
          if AnElevation > FElevation then
          begin
            FElevation := AnElevation;
          end;
        end;
      end;
    micLowestElement:
      begin
        if Count = 0 then
        begin
          FElevation := AnElevation;
          Count := 1;
        end
        else
        begin
          if AnElevation < FElevation then
          begin
            FElevation := AnElevation;
          end;
        end;
      end;
  end;
end;

procedure TfrmDEM2BMP.SetElevation(const Elevation, LocX, Locy: double);
var
  Index : integer;
  Block : TBlock;
  Node : TNode;
  Element : TElement;
begin
  if BlockList <> nil then
  begin
    if RbwZoomBox1.IsPointInside(LocX, LocY, GridOutline) then
    begin
      for Index := 0 to BlockList.Count -1 do
      begin
        Block := BlockList[Index] as TBlock;
        if Block.IsInside(LocX, LocY) then
        begin
          Block.SetElevation(LocX, LocY,Elevation);
          break;
        end;
      end;
    end;
  end
  else if NodeList <> nil then
  begin
    if (LocX <= MaxMeshX) and (LocX >= MinMeshX)
      and (LocY <= MaxMeshY) and (LocY >= MinMeshY) then
    begin
      case MeshImportChoice of
        micClosestNode, micAverageNode, micHighestNode, micLowestNode:
          begin
            for Index := 0 to NodeList.Count -1 do
            begin
              Node := NodeList[Index] as TNode;
              if Node.IsInside(LocX, LocY) then
              begin
                Node.SetElevation(LocX, LocY,Elevation);
                break;
              end;
            end;
          end;
        micClosestElement, micAverageElement, micHighestElement, micLowestElement:
          begin
            for Index := 0 to ElementList.Count -1 do
            begin
              Element := ElementList[Index] as TElement;
              if Element.IsInside(LocX, LocY) then
              begin
                Element.SetElevation(LocX, LocY,Elevation);
                break;
              end;
            end;
          end;
      end;
    end;
  end;
end;

procedure TfrmDEM2BMP.ResetData;
var
  Index : integer;
  Block : TBlock;
  Node : TNode;
  Element : TElement;
begin
  if BlockList <> nil then
  begin
    for Index := 0 to BlockList.Count -1 do
    begin
      Block := BlockList[Index] as TBlock;
      Block.Count := 0;
      Block.FElevation := 0;
      Block.Distance2 := 0;
    end;
  end;
  if NodeList <> nil then
  begin
    for Index := 0 to NodeList.Count -1 do
    begin
      Node := NodeList[Index] as TNode;
      Node.Count := 0;
      Node.FElevation := 0;
      Node.Distance2 := 0;
    end;
  end;
  if ElementList <> nil then
  begin
    for Index := 0 to ElementList.Count -1 do
    begin
      Element := ElementList[Index] as TElement;
      Element.Count := 0;
      Element.FElevation := 0;
      Element.Distance2 := 0;
    end;
  end;
end;

procedure TfrmDEM2BMP.btnOKClick(Sender: TObject);
var
  LayerHandle : ANE_PTR;
  Index : integer;
  Block : TBlock;
  Node : TNode;
  Element : TElement;
  Elevations, XValues, YValues : TRealList;
  LayerName : string;
  UserResponse : integer;
  posX : PDoubleArray;
  posY : PDoubleArray;
  dataParameters : pMatrix;
  paramNames : PParamNamesArray;
  numPoints, numDataParameters, NameIndex : integer;
  AName : string;
  Project : TProjectOptions;
  DEM_DataLayer : TDEM_DataLayer;
  LayerTemplate : string;
begin
  inherited;
  LayerName := TDEM_DataLayer.ANE_LayerName;
  UserResponse := 0;
  Project := TProjectOptions.Create;
  try
    LayerHandle := Project.GetLayerByName(CurrentModelHandle,LayerName);
  finally
    Project.Free;
  end;

  if LayerHandle = nil then
  begin
    DEM_DataLayer := TDEM_DataLayer.Create(nil, -1);
    try
      LayerTemplate := DEM_DataLayer.WriteLayer(CurrentModelHandle);
      LayerHandle := ANE_LayerAddByTemplate(CurrentModelHandle, PChar(LayerTemplate), nil);
    finally
      DEM_DataLayer.Free;
    end;
  end
  else
  begin
    if not GetValidLayerWithCancel(CurrentModelHandle, LayerHandle,
      TDEM_DataLayer, LayerName, nil, UserResponse) then
    begin
      ModalResult := mrNone;
      Exit;
    end;

  end;

  if LayerHandle = nil then
  begin
    ModalResult := mrNone;
    Beep;
    MessageDlg('Error getting data layer.', mtError, [mbOK], 0);
    Exit;
  end
  else
  begin
    Elevations := TRealList.Create;
    XValues := TRealList.Create;
    YValues := TRealList.Create;
    try
      if BlockList <> nil then
      begin
        for Index := 0 to BlockList.Count -1 do
        begin
          Block := BlockList[Index] as TBlock;
          if Block.Count <> 0 then
          begin
            Elevations.Add(Block.Elevation);
            XValues.Add(Block.CenterX);
            YValues.Add(Block.CenterY);
          end;
        end;
      end
      else if NodeList <> nil then
      begin
        case MeshImportChoice of
          micClosestNode, micAverageNode, micHighestNode, micLowestNode:
            begin
              for Index := 0 to NodeList.Count -1 do
              begin
                Node := NodeList[Index] as TNode;
                if Node.Count <> 0 then
                begin
                  Elevations.Add(Node.Elevation);
                  XValues.Add(Node.X);
                  YValues.Add(Node.Y);
                end;
              end;
            end;
          micClosestElement, micAverageElement, micHighestElement, micLowestElement:
            begin
              for Index := 0 to ElementList.Count -1 do
              begin
                Element := ElementList[Index] as TElement;
                if Element.Count <> 0 then
                begin
                  Elevations.Add(Element.Elevation);
                  XValues.Add(Element.CenterX);
                  YValues.Add(Element.CenterY);
                end;
              end;
            end;
        end;
      end;

      if Elevations.Count > 0 then
      begin
        // Set numDataParameters
        numPoints := Elevations.Count;
        numDataParameters := 1;

        // allocate memory for arrays to be passed to Argus ONE.
        GetMem(posX, numPoints*SizeOf(ANE_DOUBLE));
        GetMem(posY, numPoints*SizeOf(ANE_DOUBLE));
        GetMem(dataParameters, numDataParameters*SizeOf(pMatrix));
        GetMem(paramNames, numDataParameters*SizeOf(ANE_STR));
        try
          begin
            FOR Index := 0 TO numDataParameters-1 DO
              begin
                 GetMem(dataParameters[Index], numPoints*SizeOf(ANE_DOUBLE));
              end;

            // Fill name array.
            for NameIndex := 0 to numDataParameters -1 do
            begin
              assert(NameIndex < numDataParameters);
              AName := LayerName;
              GetMem(paramNames^[NameIndex],(Length(AName) + 1));
              StrPCopy(paramNames^[NameIndex], AName);
            end;
            for Index := 0 to numPoints -1 do
            begin
              posX^[Index] := XValues[Index];
              posY^[Index] := YValues[Index];
              dataParameters[0]^[Index] := Elevations[Index];
            end;
            ANE_DataLayerSetData(CurrentModelHandle ,
                          LayerHandle ,
                          numPoints, // :	  ANE_INT32   ;
                          @posX^, //:		  ANE_DOUBLE_PTR  ;
                          @posY^, // :	    ANE_DOUBLE_PTR   ;
                          numDataParameters, // : ANE_INT32     ;
                          @dataParameters^, // : ANE_DOUBLE_PTR_PTR  ;
                          @paramNames^  );


          end;
        finally
          begin
            // free memory of arrays passed to Argus ONE.
            FOR Index := numDataParameters-1 DOWNTO 0 DO
              begin
                assert(Index < numDataParameters);
                FreeMem(dataParameters[Index]);
                FreeMem(paramNames^[Index]);
              end;
            FreeMem(dataParameters  );
            FreeMem(posY);
            FreeMem(posX);
            FreeMem(paramNames);
          end;
        end;
      end;
    finally
      Elevations.Free;
      XValues.Free;
      YValues.Free;
    end;
  end

end;

{ TDEM_DataLayer }

class function TDEM_DataLayer.ANE_LayerName: string;
begin
  result := 'DEM_Data';
end;

procedure TfrmDEM2BMP.FormResize(Sender: TObject);
begin
  inherited;
  Statusbar1.Panels[0].Width := Statusbar1.Width div 2;
end;

constructor TDEM_DataLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := leNN2D;
end;

procedure TfrmDEM2BMP.SaveasJPEG1Click(Sender: TObject);
begin
  inherited;
  Application.CreateForm(TfrmJpegChoices, frmJpegChoices);
  try
    frmJpegChoices.SaveasJPEG(DEM_Map);
  finally
    frmJpegChoices.Free;
  end;
end;

end.
