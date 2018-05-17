unit import;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, RealListUnit,
  ArgusDataEntry, Math, DataGrid, ComCtrls, Buttons, Strset, Menus,
  RBWZoomBox, AnePIE;

const
  LayerString = '; Layer ';

type
  Direction = (Down, Right, Up, Left);

  TEditContours = class;

  TSingle = class(TObject)
    Value: single;
  end;

  TPeriodInfo = class(TObject)
    DELT: single;
    NSTP: integer;
    TSMULT: single;
    function PERLEN: double;
  end;

  TGet3dValue = function(Col, Row, Layer: Integer): Single of object;
  TGet2dValue = function(Item, Index: Integer): Single of object;
  TGetSurface = function(Col, Row: Integer): Single of object;

  TUse3dValue = function(Col, Row, Layer: Integer): boolean of object;
  TUse2dValue = function(Item, Index: Integer): boolean of object;
  TUseSurface = function(Col, Row: Integer): boolean of object;

  TGet3dValueClass = class(TObject)
    Method: TGet3dValue;
    FUseAll: Boolean;
  end;

  TGetSurfaceClass = class(TObject)
    Method: TGetSurface;
  end;

  TUse3DValueClass = class(TObject)
    Method: TUse3dValue;
  end;

  TUseSurfaceClass = class(TObject)
    Method: TUseSurface;
  end;

  TFunctionList = class(TObject)
  private
    Flist: Tlist;
    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: integer read GetCount;
  end;

  TReturnSingleFunctionList = class(TFunctionList)
  end;

  T3DFunctionList = class(TReturnSingleFunctionList)
  private
    function GetItems(const Index: integer): TGet3dValue;
    function GetUse(const Index: integer): Boolean;
  public
    destructor Destroy; override;
    procedure Add(A3DFunction: TGet3dValue; UseAll: boolean);
    property Items[const Index: integer]: TGet3dValue read GetItems;
    property UseAll[const Index: integer]: Boolean read GetUse;
  end;

  TSurfaceFunctionList = class(TReturnSingleFunctionList)
  private
    function GetItems(const Index: integer): TGetSurface;
  public
    destructor Destroy; override;
    property Items[const Index: integer]: TGetSurface read GetItems;
  end;

  TUse3DFunctionList = class(TFunctionList)
  private
    function GetItems(const Index: integer): TUse3dValue;
  public
    destructor Destroy; override;
    procedure Add(A3DFunction: TUse3dValue);
    property Items[const Index: integer]: TUse3dValue read GetItems;
  end;

  TPoint = class(TObject)
  private
    FX: extended;
    FY: extended;
    PointToRight, PointToLeft, PointAbove, PointBelow: TPoint;
    RowIndex, ColIndex: integer;
    FZones: TList;
    FOnVerticalSide: boolean;
    FOnHorizontalSide: boolean;
    function ZoneCount: integer;
    function CopyPoint: TPoint;
    procedure SetX(const Value: Extended);
    procedure SetY(const Value: Extended);
  public
    property X: Extended read FX write SetX;
    property Y: Extended read FY write SetY;
    function PointToString(OriginX, OriginY, GridAngle,
      PerturbationX, PerturbationY: double;
      RowDirectionPositive, ColumnDirectionPositive {, Perturb}: boolean):
      string;
    constructor Create(AnX, AY: Extended);
    destructor Destroy; override;
    procedure RotateFromGrid(var LocalX, LocalY: extended;
      OriginX, OriginY, GridAngle: double; RowDirectionPositive,
      ColumnDirectionPositive: boolean);
  end;

  TSegment = class(TObject)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create(Point1, Point2: TPoint);
    property StartPoint: TPoint read FStartPoint;
    property EndPoint: TPoint read FEndPoint;
    function GetDirection(BeginningPoint: TPoint): Direction;
    function GetDirectionWithEnd(AnEndPoint: TPoint): Direction;
    function Length: double;
  end;

  TCell = class;

  TCustomBoundary = class(TPersistent)
  private
    UseBoundaryList: TList;
  public
    Col: integer;
    Row: integer;
    Extracted: boolean;
    Layer: integer;
    StressPeriod: integer;
    Cell: TCell;
    constructor Create(ACell: TCell; BoundaryIndex, AStressPeriod: integer);
      virtual;
    destructor Destroy; override;
    procedure AssignProperties(Index: integer); virtual; abstract;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      virtual; abstract;
  end;

  TCustomBoundaryType = class of TCustomBoundary;

  TBoundaryList = class;

  TLineBoundary = class(TCustomBoundary)
  public
    Cond: single;
  end;

  TDrainBoundary = class(TLineBoundary)
  public
    Elevation: single;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;

  TMF2KDrainBoundary = class(TLineBoundary)
  public
    Elevation: single;
    ParameterName: string;
    constructor Create(ACell: TCell; BoundaryIndex, AStressPeriod: integer;
      ParamName: string); reintroduce; virtual;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;

  TGHBBoundary = class(TLineBoundary)
  public
    BoundaryHead: single;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;

  TMF2K_GHBBoundary = class(TLineBoundary)
  public
    BoundaryHead: single;
    ParameterName: string;
    constructor Create(ACell: TCell; BoundaryIndex, AStressPeriod: integer;
      ParamName: string); reintroduce; virtual;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;

  THorizontalFlowBoundary = class(TCustomBoundary)
  public
    Col2: integer;
    Row2: integer;
    HydChr: single;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;

  TRiverBoundary = class(TLineBoundary)
  public
    Stage: single;
    RBot: single;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;

  TMF2K_RiverBoundary = class(TLineBoundary)
  public
    Stage: single;
    RBot: single;
    ParameterName: string;
    constructor Create(ACell: TCell; BoundaryIndex, AStressPeriod: integer;
      ParamName: string); reintroduce; virtual;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;

  TMF2K_CHD_Boundary = class(TCustomBoundary)
  public
    StartingHead: single;
    EndingHead: single;
    ParameterName: string;
    constructor Create(ACell: TCell; BoundaryIndex, AStressPeriod: integer;
      ParamName: string); reintroduce; virtual;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;


  TStreamBoundary = class(TLineBoundary)
  public
    Segment: Integer;
    Reach: integer;
    Flow: single;
    Stage: single;
    SBot: single;
    STop: single;
    Width: single;
    Slope: single;
    Rough: single;
    Trib: array[0..9] of integer;
    IupSeg: integer;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;

  TWellBoundary = class(TCustomBoundary)
  public
    Q: single;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;

  TMF2K_WellBoundary = class(TCustomBoundary)
  public
    Q: single;
    ParameterName: string;
    constructor Create(ACell: TCell; BoundaryIndex, AStressPeriod: integer;
      ParamName: string); reintroduce; virtual;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;

  TFHBFlowBoundary = class(TCustomBoundary)
  private
    NumberOfTimes: integer;
  public
    IAUX: integer;
    FLWRAT: array of single;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;

  TFHBHeadBoundary = class(TCustomBoundary)
  private
    NumberOfTimes: integer;
  public
    IAUX: integer;
    SBHED: array of single;
    procedure AssignProperties(Index: integer); override;
    function SimilarBoundary(ACustomBoundary: TCustomBoundary): boolean;
      override;
  end;

  TContour2 = class;

  TCell = class(TObject)
  private
    FSegments: TList; // the segments define the edges of the cell.
    function GetBoundaryCount: integer;
  public
    BoundaryList: TBoundaryList; // list of boundary conditions in the cell.
    constructor Create(Seg1, Seg2, Seg3, Seg4: TSegment);
    destructor Destroy; override;
    function CenterPoint: TPoint;
    property BoundaryCount: integer read GetBoundaryCount;
  end;

  TPointList = class(TList)
  private
    procedure EliminateExtraVerticies;
    function GetOverLappedSection: TPointList;
    function PointInside(VertexToCheck: TPoint): boolean;
    function GetFirstUnsharedPoint(AVertexList: TPointList): TPoint;
  end;

  TContourValue = class(Tobject)
    function WriteValue: string; virtual;
  end;

  TRealValue = class(TContourValue)
    Value: double;
    function WriteValue: string; override;
  end;

  TContour2 = class(TObject)
  public //private
    FPoints: TPointList;
    PointsReady: boolean;
    EditContours: TEditContours;
    ValueList: TList;
    EnclosingContours: integer;
    BoundaryIndex: integer;
    procedure PointsToStrings(OriginX, OriginY, GridAngle,
      Perturbation: double; RowDirectionPositive, ColumnDirectionPositive:
      boolean);
    procedure MakeHeader;
    procedure WriteContour(OriginX, OriginY, GridAngle,
      Perturbation: double; RowDirectionPositive, ColumnDirectionPositive:
      boolean; ContourStringList: TStringList); virtual;
    function PointInside(X, Y: extended): boolean;
  public
    Value: string;
    Heading: TStringlist;
    PointStrings: TStringList;
    constructor Create;
    destructor Destroy; override;
    procedure AddCopyOfPoint(APoint: TPoint);
    Procedure FixValue(const aneHandle : ANE_PTR);
  end;

  TStreamContour = class(TContour2)
    Layer: integer;
  end;

  TListOfVertexLists = class(TList)
  private
    procedure EliminateInteriorLists;
  end;

  TSegmentList = class(TList)
  private
    function GetListOfVertexLists: TListOfVertexLists;
  end;       

  // TReverseList is like TList except that IndexOf searches from the end
  // instead of from the beginning.

{  TReverseList = Class(TList)
  public
    function IndexOf(Item: Pointer): Integer;
  end;   }

  TZone = class(TObject)
  private
    FCells: TList;
    FSegments: TList;
    FVertexList: TPointList;
    ValueList: TList;
    function GetSegments(Index: Integer): TSegment;
    function GetSegmentCount: integer;
    procedure RoundCorners;
    procedure EliminateMiddlePoints;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(ACell: TCell);
    property Segments[Index: Integer]: TSegment read GetSegments;
    property SegmentCount: integer read GetSegmentCount;
    procedure MakeVertexList;
  end;

  TZoneList = class(TObject)
  private
    FList: TList;
    OriginX, OriginY, GridAngle: double;
    procedure RoundCorners;
  public
    constructor Create(AnOriginX, AnOriginY, AGridAngle: double);
    destructor Destroy; override;
    procedure WriteZones(Perturbation: double; RowDirectionPositive,
      ColumnDirectionPositive: boolean;
      ContourStringList: TStringList; const Offset: double);
  end;

  TBoundaryList = class(TObject)
    FList: TList;
    function GetBoundaries(Index: integer): TCustomBoundary;
    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy; override;
    property Boundaries[Index: integer]: TCustomBoundary read GetBoundaries;
    default;
    property Count: integer read GetCount;
    function Add(Item: TCustomBoundary): Integer;
    function IndexOf(ABoundary: TCustomBoundary): integer;
  end;

  T2DBlockCenteredGrid = class;

  TEditContours = class(TObject)
  public // private
    ContourList: TList;
    OriginX, OriginY, GridAngle: double;
    procedure ArrangeContours;
    { Private declarations }
  public
    constructor Create(AnOriginX, AnOriginY, AGridAngle: double);
    destructor Destroy; override;
    procedure WriteContours(Perturbation: double;
      RowDirectionPositive, ColumnDirectionPositive: boolean; ContourStringList:
      TStringList);
    { Public declarations }
  end;

  TLocalZoomPoint = class(TRBWZoomPoint)
    Col, Row: integer;
    BoundaryIndex: integer;
  end;

  TBoundCell = class(TObject)
    Row, Col: integer;
    BoundCount: integer;
  end;

  TRiverValues = (rivLay, rivRow, rivCol, rivStage, rivCond, rivRbot);
  TWellValues = (welLay, welRow, welCol, welStress);
  TDrainValues = (drnLay, drnRow, drnCol, drnElev, drnCond);
  TGHBValues = (ghbLay, ghbRow, ghbCol, ghbElev, ghbCond);
  TFHBLocations = (fhbLay, fhbRow, fhbCol, fhbAux);
  THFBLocations = (hfbRow1, hfbCol1, hfbRow2, hfbCol2, hfbHYDCHR, hfbLay);
  TStreamIntValues = (strLay, strRow, strCol, strSeg, strReach);
  TStreamRealValues = (strInfl, strStage, strCond, strBot, strTop,
    strWidth, strSlope, strRough, strOut, strIn, strLeakage);

  TArrayKinds = (akDomainOutline, akIBOUND, akInitialHead, akConfSt, akSpY,
    akTrans, akK, akBot, akTop, akVCont, akWetDry, akET, akRchRate);

  string81 = string[81];
  Iarray40 = array[0..39] of longint;
  Iarray200 = array[0..199] of longint;


  // The GETVALUE procedure in imported from modflw96.dll.
  // It reads a value from the X array.
  TGetValue = procedure(var IXINDEX: longint; var VALUE: single); stdcall;

  // The TERMINATE procedure in imported from modflw96.dll.
  // It deallocates the X array.
  TTerminate = procedure (); stdcall;

{ The INIT procedure in imported from modflw96.dll.
  it reads data from the modflow input files.  The first time it is
  called, it allocates the X-array.
  
  The names of all variables in this procedure are identical with those in
  MODFLOW-96 with the exceptions of LAYCOX, IUNITX, XX, HEADX1, and HEADX2.
  Those are exported versions of LAYCON, IUNIT, X, and the two values in
  the HEADNG array. In addition, IDLLPE is the stress period for which data
  is desired.}
  TINIT = procedure {INIT }(var IAPART, ICHFLG, ISTRT, ISUM, ITMUNI, LCIBOU,
    LCSTRT, NCOL, NLAY, NPER, NROW, NSTP, ISS, IHDWET, IWDFLG,
    IWETIT, LCBOT, LCCC, LCCV, LCDELC, LCDELR, LCHY, LCSC1, LCSC2,
    LCTOP, LCTRPY, LCWETD, IWELAL, LCWELL, MXWELL, NWELVL, NWELLS,
    IDRNAL, LCDRAI, MXDRN, NDRAIN, NDRNVL, LCRIVR, MXRIVR, NRIVER,
    NRIVVL, IRIVAL, LCIEVT, LCEVTR, LCEXDP, LCSURF, NEVTOP, LCBNDS,
    NBOUND, MXBND, NGHBVL, IGHBAL, LCIRCH, LCRECH, NRCHOP, MXITER,
    NPARM, IPCALC, IPRSIP, MXUP, MXLOW, MXBW, ITMX, IFREQ, IPRD4,
    MUTD4, IPRSOR, ITER1, NPCOND, NBPOL, IPRPCG, MUTPCG, //INBAS,
    NRESOP, IFHBCB, IFHBD3, IFHBD4, IFHBD5, IFHBSS, LCFLLC, LCBDTM,
    LCFLRT, LCHDLC, LCSBHD, NBDTIM, NFHBX1, NFHBX2, NFLW, NHED,
    LCHFBR, NHFB, MXSTRM, NSTREM, ISTCB1, ISTCB2, NSS, NTRIB, NDIV, ICALC,
    LCSTRM, LCTBAR, LCTRIB, LCIVAR, ICSTRM,
    IDLLPE
    : longint;
    var WETFCT, TSMULT, ACCL, HCLOSE, RCLOSE, RELAX, DAMP,
    WSEED, StrCONST, DELT, HDRY: single;
    var HNOFLO: double;
    var LAYCOX: Iarray200;
    var LAYAVGX: Iarray200;
    var IUNITX: Iarray40;
    var HEADX1, HEADX2: string81;
    len1, len2: longint); stdcall;

  T2DBlockCenteredGrid = class(TObject)
  private
  public // private
    FPerturbation: double;
    ColPositions, RowPositions: TRealList;
    ColCount: integer;
    RowCount: integer;
    FVertexList: TList;
    FMoreVerticies: TList;
    FHorSegmentList: TList;
    FVerSegmentList: TList;
    FCellList: TList;
    OriginX, OriginY, GridAngle: double;
    FStressPeriodCount: integer;
    function GetVertex(Col, Row: integer): TPoint;
    function GetHorSegments(Col, Row: integer): TSegment;
    function GetVerSegments(Col, Row: integer): TSegment;
    function GetCells(Col, Row: integer): TCell;
  public
    EvapSurface: array of array of array of single;
    // columns, rows, StressPeriods
    EvapRate: array of array of array of single; // columns, rows, StressPeriods
    EvapExtDepth: array of array of array of single;
    // columns, rows, StressPeriods
    EvapLayer: array of array of array of single; // columns, rows, StressPeriods
    RechRate: array of array of array of single; // columns, rows, StressPeriods
    RechLayer: array of array of array of single; // columns, rows, StressPeriods
    ETS_Surface: array of array of single; // columns, rows
    ETS_MaxRate: array of array of array of single; // columns, rows, StressPeriods
    ETS_ExtinctionDepth: array of array of single; // columns, rows
    ETS_Layer: array of array of single; // columns, rows
    ETS_IntermediateDepth: array of array of array of single; // columns, rows, NETSET-1
    ETS_IntermediateRate: array of array of array of single; // columns, rows, NETSET-1
    constructor Create(ColWidths, RowWidths: TRealList;
      AnOriginX, AnOriginY, AGridAngle: double;
      RowsPositive, ColumnsPositive: boolean;
      Importer: TObject);
    destructor Destroy; override;
    property Verticies[Col, Row: integer]: TPoint read GetVertex;
    property HorSegments[Col, Row: integer]: TSegment read GetHorSegments;
    property VerSegments[Col, Row: integer]: TSegment read GetVerSegments;
    property Cells[Col, Row: integer]: TCell read GetCells;
    function LayerZones(FunctionList: TReturnSingleFunctionList;
      Layer: Integer; Use3DFunctionList: TUse3DFunctionList;
      UseValue: boolean; Value: double): TZoneList;
    function MakeZone(ACell: TCell; Col, Row, Layer: integer;
      CompareList, ValueFunctionList: TReturnSingleFunctionList;
      UseValue: boolean; Value: double): TZone;
    procedure AddNeighbors(AZone: TZone; Col, Row, Layer: integer;
      FunctionList: TReturnSingleFunctionList);
    property Perturbation: double read FPerturbation;
    procedure MakeWellBoundaries(StressPeriod: integer);
    procedure MakeDrainBoundaries(StressPeriod: integer);
    procedure MakeRiverBoundaries(StressPeriod: integer);
    procedure MakeStreamBoundaries(StressPeriod: integer);
    procedure MakeFHBFlowBoundaries(StressPeriod: integer);
    procedure MakeFHBHeadBoundaries(StressPeriod: integer);
    procedure MakeGHBBoundaries(StressPeriod: integer);
    procedure MakeHFBBoundaries;
    function MakePointContourFromLayer(GetValueList: T3DFunctionList;
      UseValueList: TUse3DFunctionList; Layer: integer): TEditContours;
    function MakeDataPoints(GetValueList,
      GetTimeValueList: T3DFunctionList; UseValueList: TUse3DFunctionList;
      Layer, NPER: integer; RowDirectionPositive,
      ColumnDirectionPositive: boolean): TStringList;
    procedure MakeMF2K_WellBoundaries(StressPeriod: integer);
    procedure MakeMF2KDrainBoundaries(StressPeriod: integer);
    procedure MakeMF2K_GHB_Boundaries(StressPeriod: integer);
    procedure MakeMF2K_RiverBoundaries(StressPeriod: integer);
    procedure MakeMF2K_CHD_Boundaries(StressPeriod: integer);
    function PerturbAmount: double;
  end;

function Get1DIndex(Max, Index, startIndex: longint): longint;

function Get2DIndex(FirstIndexCount, SecondIndexCount, FirstIndex,
  SecondIndex, startIndex: longint): longint;
function Get3DIndex(FirstIndexCount, SecondIndexCount, ThirdIndexCount,
  FirstIndex, SecondIndex, ThirdIndex, startIndex: longint): longint;

implementation

uses contnrs, IntListUnit, ModflowImport, UtilityFunctions, mf2kInterface,
  OptionsUnit;

function Get1DIndex(Max, Index, startIndex: longint): longint;
begin
  if (Index < 0) or (Index > Max - 1) then
  begin
    raise ERangeError.Create('Range Error');
  end;
  Result := (Index) + startIndex - 1;
end;

{Get2DIndex is used to calculate the position of an element in a two
dimensional array stored in the X-array.
FirstIndexCount is the maximum number of elements in the first dimension
of the array.
SecondIndexCount is the maximum number of elements in the second dimension
of the array.
FirstIndex is the first index to the position of the element in the array.
SecondIndex is the second index to the position of the element in the array.
startIndex is the pointer to the first element of the array within the X-array.

For example: the RIVR array in the river package is declared in MODFLOW-96 as
DIMENSION(NRIVVL,MXRIVR).
NRIVVL is FirstIndexCount.
MXRIVR is SecondIndexCount.

The RIV5AL module returns LCRIVR as the location of the first element of RIVR
within the X-array so LCRIVR is startIndex.
If you wanted to access RIVR(A,B), FirstIndex would be A
and SecondIndex would be B.
}

{How it works:
  In FORTRAN, a two dimensional array is stored with the first index varying
  most frequently and the last index varying least frequently.
  Thus an array named "A" with dimension (2,3) would be stored in the following
  sequence.
  A(1,1)
  A(2,1)
  A(1,2)
  A(2,2)
  A(1,3)
  A(2,3)

  In addition the first element of an array has an index of 1 rather than an
  index of 0 as in DELPHI so A(1) in FORTRAN is equivalent to A(0) in Object
  Pascal.
  Thus the first thing to do is subtract 1 from the location of the start of
  the 2D array within the 1D array to convert from a FORTRAN location to the
  equivalent Object Pascal location. You also must make similar adjustments
  to the other indicies.
  }

function Get2DIndex(FirstIndexCount, SecondIndexCount, FirstIndex,
  SecondIndex, startIndex: longint): longint;
begin
  if (FirstIndex < 0) or (FirstIndex > FirstIndexCount - 1)
    or (SecondIndex < 0) or (SecondIndex > SecondIndexCount - 1) then
  begin
    raise ERangeError.Create('Range Error');
  end;
  Result := (startIndex - 1) +
    (SecondIndex) * FirstIndexCount +
    (FirstIndex);
end;

{Get3DIndex is used to calculate the position of an element in a three
dimensional array stored in the X-array.
FirstIndexCount is the maximum number of elements in the first dimension
of the array.
SecondIndexCount is the maximum number of elements in the second dimension
of the array.
ThirdIndexCount is the maximum number of elements in the third dimension
of the array.
FirstIndex is the first index to the position of the element in the array.
SecondIndex is the second index to the position of the element in the array.
ThirdIndex is the third index to the position of the element in the array.
startIndex is the pointer to the first element of the array within the X-array.

See the comment with GetIndex for an example of a two dimensional array
Three dimensional arrays are similar.

Note: some 3D arrays in MODFLOW may have NLAY as one of their dimensions but
may actually hold fewer values. TOP and BOT are examples. In such cases, you
must calculate the index associated with the layer number before calling
Get3DIndex.
}

function Get3DIndex(FirstIndexCount, SecondIndexCount, ThirdIndexCount,
  FirstIndex, SecondIndex, ThirdIndex, startIndex: longint): longint;
begin
  if (FirstIndex < 0) or (FirstIndex > FirstIndexCount - 1)
    or (SecondIndex < 0) or (SecondIndex > SecondIndexCount - 1)
    or (ThirdIndex < 0) or (ThirdIndex > ThirdIndexCount - 1) then
  begin
    raise ERangeError.Create('Range Error');
  end;
  Result := (startIndex - 1) +
    (ThirdIndex) * SecondIndexCount * FirstIndexCount +
    (SecondIndex) * FirstIndexCount +
    (FirstIndex);
end;

{ TBoundCell }

const
  Margin = 20;

var
  CellUsed: array of array of boolean;

type
  TCellLocation = record
    Col: integer;
    Row: integer;
  end;

  TCellStack = class(TObject)
  private
    FCapacity: integer;
    FCount: integer;
    FValues: array of TCellLocation;
    procedure SetCapacity(const Value: integer);
    property Capacity: integer read FCapacity write SetCapacity;
    procedure Push(const Location : TCellLocation);
    function Pop: TCellLocation;
    property Count: integer read FCount;
    Constructor Create;
  end;

{ TSegment }

constructor TSegment.Create(Point1, Point2: TPoint);
begin
  inherited Create;
  FStartPoint := Point1;
  FEndPoint := Point2;
end;

function TSegment.GetDirection(BeginningPoint: TPoint): Direction;
var
  FirstVertex, SecondVertex: TPoint;
begin
  if FStartPoint = BeginningPoint then
  begin
    FirstVertex := FStartPoint;
    SecondVertex := FEndPoint;
  end
  else
  begin
    FirstVertex := FEndPoint;
    SecondVertex := FStartPoint;
  end;
  // Determine the direction of the previous segment
  if FirstVertex.X = SecondVertex.X then
  begin
    if FirstVertex.Y > SecondVertex.Y then
    begin
      result := Down;
    end
    else // If PreviousSegment.StartVertex.Y > PreviousSegment.EndVertex.Y then
    begin
      result := Up;
    end;
  end
  else // if PreviousSegment.StartVertex.X = PreviousSegment.EndVertex.X then
  begin
    if FirstVertex.X > SecondVertex.X then
    begin
      result := Left;
    end
    else // If PreviousSegment.StartVertex.X > PreviousSegment.EndVertex.X then
    begin
      result := Right;
    end;
  end;

end;

function TSegment.GetDirectionWithEnd(AnEndPoint: TPoint): Direction;
begin
  result := GetDirection(AnEndPoint);
  if result < Up then
  begin
    Inc(result, 2);
  end
  else
  begin
    Dec(result, 2);
  end;

end;

function TSegment.Length: double;
begin
  result := Sqrt(Sqr(StartPoint.X - EndPoint.X) + Sqr(StartPoint.Y - EndPoint.Y));
end;

{ TCell }

function TCell.CenterPoint: TPoint;
var
  X, Y: double;
  Index: integer;
  ASeg: TSegment;
begin
  X := 0;
  Y := 0;
  for Index := 0 to FSegments.Count - 1 do
  begin
    ASeg := FSegments[Index];
    X := X + ASeg.FStartPoint.FX + ASeg.FEndPoint.FX;
    Y := Y + ASeg.FStartPoint.FY + ASeg.FEndPoint.FY;
  end;
  X := X / FSegments.Count / 2;
  Y := Y / FSegments.Count / 2;
  result := TPoint.Create(X, Y);
end;

constructor TCell.Create(Seg1, Seg2, Seg3, Seg4: TSegment);
begin
  inherited Create;
  FSegments := TList.Create;
  FSegments.Add(Seg1); // HorSeg1
  FSegments.Add(Seg2); // HorSeg2
  FSegments.Add(Seg3); // VerSeg1
  FSegments.Add(Seg4); // VerSeg2
  BoundaryList := TBoundaryList.Create;
end;

destructor TCell.Destroy;
var
  Index: integer;
begin
  FSegments.Free;
  for Index := BoundaryList.Count - 1 downto 0 do
  begin
    TCustomBoundary(BoundaryList[Index]).Free;
  end;
  BoundaryList.Free;
  inherited Destroy;
end;

function TCell.GetBoundaryCount: integer;
begin
  result := BoundaryList.Count;
end;

{ TZone }

procedure TZone.Add(ACell: TCell);
var
  Index: integer;
  SegmentIndex: integer;
begin
  if FCells.IndexOf(ACell) = -1 then
  begin
    FCells.Add(ACell);
    for Index := 0 to ACell.FSegments.Count - 1 do
    begin
      SegmentIndex := FSegments.IndexOf(ACell.FSegments[Index]);
      if SegmentIndex = -1 then
      begin
        FSegments.Add(ACell.FSegments[Index]);
      end
      else
      begin
        FSegments.Delete(SegmentIndex);
      end;
    end;
  end;
end;

constructor TZone.Create;
begin
  inherited Create;
  FSegments := TList.Create;
  FCells := TList.Create;
  FVertexList := TPointList.Create;
  ValueList := TPointList.Create;
end;

destructor TZone.Destroy;
var
  Index: integer;
begin
  FSegments.Free;
  FCells.Free;
  FVertexList.Free;
  for Index := ValueList.Count - 1 downto 0 do
  begin
    TSingle(ValueList[Index]).Free;
  end;
  ValueList.Free;
  inherited Destroy;
end;

procedure TZone.EliminateMiddlePoints;
  function IsBetween(FirstValue, SecondValue, TestValue: double): Boolean;
  var
    LowerValue, HigherValue: double;
  begin
    if FirstValue < SecondValue then
    begin
      LowerValue := FirstValue;
      HigherValue := SecondValue;
    end
    else
    begin
      HigherValue := FirstValue;
      LowerValue := SecondValue;
    end;
    result := (LowerValue <= TestValue) and (TestValue <= HigherValue);
  end;
var
  FirstPoint, SecondPoint, ThirdPoint: TPoint;
  procedure CheckMiddle(Index: integer);
  const
    Epsilon = 1E-8;
  var
    DelX1, DelX2, DelY1, DelY2: double;
    Largest: double;
    RoundError: double;
  begin
    if IsBetween(FirstPoint.X, ThirdPoint.X, SecondPoint.X) and
      IsBetween(FirstPoint.Y, ThirdPoint.Y, SecondPoint.Y) then
    begin
      DelX1 := SecondPoint.X - FirstPoint.X;
      DelX2 := ThirdPoint.X - FirstPoint.X;
      DelY1 := SecondPoint.Y - FirstPoint.Y;
      DelY2 := ThirdPoint.Y - FirstPoint.Y;
      Largest := Max(Abs(DelX1), Abs(DelX2));
      Largest := Max(Largest, Abs(DelY1));
      Largest := Max(Largest, Abs(DelY2));
      RoundError := Largest * Epsilon;
      if Abs(DelX2 * DelY1 - DelX1 * DelY2) < RoundError then
      begin
        FVertexList.Delete(Index);
        if Index = 0 then
        begin
          FVertexList.Delete(FVertexList.Count - 1);
          FVertexList.Add(FVertexList[0]);
        end;
      end;
    end;
  end;
var
  Index: integer;
begin
  for Index := FVertexList.Count - 2 downto 1 do
  begin
    FirstPoint := FVertexList[Index - 1];
    SecondPoint := FVertexList[Index];
    ThirdPoint := FVertexList[Index + 1];
    CheckMiddle(Index);
  end;
  FirstPoint := FVertexList[FVertexList.Count - 2];
  SecondPoint := FVertexList[0];
  ThirdPoint := FVertexList[1];
  CheckMiddle(0);
end;

function TZone.GetSegmentCount: integer;
begin
  result := FSegments.Count;
end;

function TZone.GetSegments(Index: Integer): TSegment;
begin
  result := FSegments[Index]
end;

procedure TZone.MakeVertexList;
var
  ListOfVertexLists: TListOfVertexLists;
  TempSegList: TSegmentList;
  AVertexList, AnotherVertexList: TPointList;
  Index, VertexIndex: integer;
  AVertex: TPoint;
begin
  // Each VertexList in ListOfVertexLists will hold
  // a set of verticies on a boundary of a zone.
  // Ultimately only the outermost boundary will be
  // saved.
  ListOfVertexLists := nil;
  try
    begin
      // TempSegList will hold a list of segments included
      // in a boundary of a zone that haven't been dealt
      // with yet.
      TempSegList := TSegmentList.Create;
      try // try 1
        TempSegList.Capacity := SegmentCount;
        // Add all the segments to TempSegList
        for Index := 0 to SegmentCount - 1 do
        begin
          TempSegList.Add(Segments[Index]);
        end;

        ListOfVertexLists := TempSegList.GetListOfVertexLists;
        // if there are any segments left in TempSegList
        // start a new VertexList
      finally // try 1
        // Get rid of TempSegList and FoundSegments
        TempSegList.Free;
      end;
      // Loop over all the VertexLists.
{      for Index := 0 to ListOfVertexLists.Count -1 do
      begin
        // Get a vertexList
        AVertexList := ListOfVertexLists[Index];
        AVertexList.EliminateExtraVerticies;
      end;  }
      // Now check which contour is outermost and get rid
      // of all others.
      while ListOfVertexLists.Count > 1 do
      begin
        ListOfVertexLists.EliminateInteriorLists;
        // Check if the one remaining VertexList ever
        // intersects itself. If it does, remove the intersecting
        // portion and place it in another VertexList
        AVertexList := ListOfVertexLists[0];
        repeat
          begin
            AnotherVertexList := AVertexList.GetOverLappedSection;
            if not (AnotherVertexList = nil) then
            begin
              // Add the new VertexList to ListOfVertexLists
              ListOfVertexLists.Add(AnotherVertexList);
            end;
          end;
        until AnotherVertexList = nil;
      end; // while ListOfVertexLists.Count > 1 do
      // Loop over all the VertexLists.
      for Index := 0 to ListOfVertexLists.Count - 1 do
      begin
        // Get a vertexList
        AVertexList := ListOfVertexLists[Index];
        for VertexIndex := 0 to AVertexList.Count - 1 do
        begin
          AVertex := AVertexList.Items[VertexIndex];
          AVertex.FZones.Add(self);
        end;
        AVertexList.EliminateExtraVerticies;
      end;
      // only one VertexList is in ListOfVertexLists
      // so it is the Vertex list of the zone.
      FVertexList.Free;
      FVertexList := ListOfVertexLists[0];
    end;
  finally
    begin
      // get rid of ListOfVertexLists
      ListOfVertexLists.Free;
    end;
  end;
end;

procedure TZone.RoundCorners;
var
  Index: integer;
  AVertex, NextVertex: TPoint;
begin
  for Index := FVertexList.Count - 2 downto 0 do
  begin
    AVertex := FVertexList[Index];
    if (AVertex.ZoneCount < 3) and (AVertex.PointToRight <> nil)
      and (AVertex.PointToLeft <> nil) and (AVertex.PointAbove <> nil)
      and (AVertex.PointBelow <> nil) then
    begin
      NextVertex := FVertexList[Index + 1];
      if NextVertex.Y = AVertex.Y then
      begin
        if NextVertex.X > AVertex.X then
        begin
          FVertexList.Insert(Index + 1, AVertex.PointToRight);
          AVertex.PointToRight.FOnHorizontalSide := True;
        end
        else
        begin
          FVertexList.Insert(Index + 1, AVertex.PointToLeft);
          AVertex.PointToLeft.FOnHorizontalSide := True;
        end;
      end
      else
      begin
        if NextVertex.Y > AVertex.Y then
        begin
          FVertexList.Insert(Index + 1, AVertex.PointAbove);
          AVertex.PointAbove.FOnVerticalSide := True;
        end
        else
        begin
          FVertexList.Insert(Index + 1, AVertex.PointBelow);
          AVertex.PointBelow.FOnVerticalSide := True;
        end;
      end;
      if Index = 0 then
      begin
        NextVertex := FVertexList[FVertexList.Count - 2];
      end
      else
      begin
        NextVertex := FVertexList[Index - 1];
      end;
      if NextVertex.Y = AVertex.Y then
      begin
        if NextVertex.X > AVertex.X then
        begin
          FVertexList[Index] := AVertex.PointToRight;
          AVertex.PointToRight.FOnHorizontalSide := True;
        end
        else
        begin
          FVertexList[Index] := AVertex.PointToLeft;
          AVertex.PointToLeft.FOnHorizontalSide := True;
        end;
      end
      else
      begin
        if NextVertex.Y > AVertex.Y then
        begin
          FVertexList[Index] := AVertex.PointAbove;
          AVertex.PointAbove.FOnVerticalSide := True;
        end
        else
        begin
          FVertexList[Index] := AVertex.PointBelow;
          AVertex.PointBelow.FOnVerticalSide := True;
        end;
      end;
      if Index = 0 then
      begin
        FVertexList[FVertexList.Count - 1] := FVertexList[0];
      end;
    end;
  end;
end;

{ T2DBlockCenteredGrid }

procedure T2DBlockCenteredGrid.AddNeighbors(AZone: TZone;
  Col, Row, Layer: integer; FunctionList: TReturnSingleFunctionList);
var
  TestValue, OtherValue: single;
  ACell: TCell;
  NewCol, NewRow: integer;
  A3DFunction: TGet3dValue;
  ASurfaceFunction: TGetSurface;
  TestValues: TList;
  Index: integer;
  SameZone: boolean;
  A3DFunctionList: T3DFunctionList;
  ASurfaceFunctionList: TSurfaceFunctionList;
  ARealValue: TRealValue;
  StressPeriodIndex: integer;
//  AddedCell: boolean;
//  NeighborCell: boolean;
  InStack: array of array of Boolean;
  CellStack: TCellStack;
  Location: TCellLocation;
  procedure AddNeighbors(Loc: TCellLocation);
  var
    NeighborLoc: TCellLocation;
  begin
    NeighborLoc := Loc;
    if NeighborLoc.Col > 0 then
    begin
      Dec(NeighborLoc.Col);
      if not CellUsed[NeighborLoc.Col, NeighborLoc.Row]
        and not InStack[NeighborLoc.Col, NeighborLoc.Row] then
      begin
        CellStack.Push(NeighborLoc);
        InStack[NeighborLoc.Col, NeighborLoc.Row] := True;
      end;
    end;
    NeighborLoc := Loc;
    if NeighborLoc.Row > 0 then
    begin
      Dec(NeighborLoc.Row);
      if not CellUsed[NeighborLoc.Col, NeighborLoc.Row]
        and not InStack[NeighborLoc.Col, NeighborLoc.Row] then
      begin
        CellStack.Push(NeighborLoc);
        InStack[NeighborLoc.Col, NeighborLoc.Row] := True;
      end;
    end;
    NeighborLoc := Loc;
    if NeighborLoc.Col < ColCount -1 then
    begin
      Inc(NeighborLoc.Col);
      if not CellUsed[NeighborLoc.Col, NeighborLoc.Row]
        and not InStack[NeighborLoc.Col, NeighborLoc.Row] then
      begin
        CellStack.Push(NeighborLoc);
        InStack[NeighborLoc.Col, NeighborLoc.Row] := True;
      end;
    end;
    NeighborLoc := Loc;
    if NeighborLoc.Row < RowCount -1 then
    begin
      Inc(NeighborLoc.Row);
      if not CellUsed[NeighborLoc.Col, NeighborLoc.Row]
        and not InStack[NeighborLoc.Col, NeighborLoc.Row] then
      begin
        CellStack.Push(NeighborLoc);
        InStack[NeighborLoc.Col, NeighborLoc.Row] := True;
      end;
    end;
  end;
  function CheckCell: boolean;
  var
    Index: integer;
    StressPeriodIndex: integer;
    ValueIndex: integer;
  begin
    result := false;
    SameZone := True;
    ValueIndex := 0;
    for Index := 0 to FunctionList.Count - 1 do
    begin
      if FunctionList is T3DFunctionList then
      begin
        A3DFunctionList := FunctionList as T3DFunctionList;
        A3DFunction := A3DFunctionList.Items[Index];
        if A3DFunctionList.UseAll[Index] then
        begin
          for StressPeriodIndex := 0 to FStressPeriodCount - 1 do
          begin
            OtherValue := A3DFunction(NewCol, NewRow, StressPeriodIndex);
            ARealValue := TestValues.Items[ValueIndex];
            TestValue := ARealValue.Value;
            SameZone := SameZone and (OtherValue = TestValue);
            Inc(ValueIndex);
            if not SameZone then
            begin
              break;
            end; // if not SameZone then
          end; // for StressPeriodIndex := 0 to FStressPeriodCount - 1 do
        end
        else // if A3DFunctionList.UseAll[Index] then
        begin
          OtherValue := A3DFunction(NewCol, NewRow, Layer);
          ARealValue := TestValues.Items[ValueIndex];
          TestValue := ARealValue.Value;
          SameZone := SameZone and (OtherValue = TestValue);
          Inc(ValueIndex);
          if not SameZone then
          begin
            break;
          end; // if not SameZone then
        end; // if A3DFunctionList.UseAll[Index] then else
      end
      else // if FunctionList is T3DFunctionList then
      begin
        ASurfaceFunctionList := FunctionList as TSurfaceFunctionList;
        ASurfaceFunction := ASurfaceFunctionList.Items[Index];
        OtherValue := ASurfaceFunction(NewCol, NewRow);
        ARealValue := TestValues.Items[ValueIndex];
        TestValue := ARealValue.Value;
        SameZone := SameZone and (OtherValue = TestValue);
        Inc(ValueIndex);
        if not SameZone then
        begin
          break;
        end; // if not SameZone then
      end; // if FunctionList is T3DFunctionList then
      if not SameZone then
      begin
        break;
      end; // if not SameZone then
    end; // for Index := 0 to FunctionList.Count - 1 do
    if SameZone then
    begin
      ACell := Cells[NewCol, NewRow];
      AZone.Add(ACell);
      CellUsed[NewCol, NewRow] := True;
      result := True;
    end; // if SameZone then
  end;
  {procedure Check;
  begin
    if not CellUsed[NewCol, NewRow] then
    begin
      NeighborCell := False;
      if (NewCol > 0) then
      begin
        ACell := Cells[NewCol - 1, NewRow];
        NeighborCell := (AZone.FCells.IndexOf(ACell) > -1);
      end;
      if (NewRow > 0) then
      begin
        ACell := Cells[NewCol, NewRow - 1];
        NeighborCell := NeighborCell or (AZone.FCells.IndexOf(ACell) > -1);
      end;
      if (NewCol < ColCount - 1) then
      begin
        ACell := Cells[NewCol + 1, NewRow];
        NeighborCell := NeighborCell or (AZone.FCells.IndexOf(ACell) > -1);
      end;
      if (NewRow < RowCount - 1) then
      begin
        ACell := Cells[NewCol, NewRow + 1];
        NeighborCell := NeighborCell or (AZone.FCells.IndexOf(ACell) > -1);
      end;
      if NeighborCell then
      begin
        AddedCell := CheckCell or AddedCell;
      end;
    end;
  end;  }
begin
  SetLength(InStack, ColCount, RowCount);
  for NewCol := 0 to ColCount - 1 do
  begin
    for NewRow := 0 to RowCount - 1 do
    begin
      InStack[NewCol,NewRow] := False;
    end; // for NewRow := 0 to RowCount -1 do
  end; // for NewCol := 0 to ColCount -1 do
  CellStack:= TCellStack.Create;
  TestValues := TList.Create;
  try
    CellStack.Capacity := ColCount * RowCount;
      for Index := 0 to FunctionList.Count - 1 do
      begin
        if FunctionList is T3DFunctionList then
        begin
          A3DFunctionList := FunctionList as T3DFunctionList;
          A3DFunction := A3DFunctionList.Items[Index];
          if A3DFunctionList.UseAll[Index] then
          begin
            for StressPeriodIndex := 0 to FStressPeriodCount - 1 do
            begin
              ARealValue := TRealValue.Create;
              ARealValue.Value := A3DFunction(Col, Row, StressPeriodIndex);
              TestValues.Add(ARealValue);
            end;
          end
          else
          begin
            ARealValue := TRealValue.Create;
            ARealValue.Value := A3DFunction(Col, Row, Layer);
            TestValues.Add(ARealValue);
          end;
        end
        else
        begin
          ASurfaceFunctionList := FunctionList as TSurfaceFunctionList;
          ASurfaceFunction := ASurfaceFunctionList.Items[Index];
          ARealValue := TRealValue.Create;
          ARealValue.Value := ASurfaceFunction(Col, Row);
          TestValues.Add(ARealValue);
        end;
      end;

      Location.Col := Col;
      Location.Row := Row;
      AddNeighbors(Location);

      While CellStack.Count > 0 do
      begin
        Location := CellStack.Pop;
        NewCol := Location.Col;
        NewRow := Location.Row;
        if CheckCell then
        begin
          AddNeighbors(Location);
        end;
      end;

      {repeat
        AddedCell := False;
        for NewCol := 0 to ColCount - 1 do
        begin
          for NewRow := 0 to RowCount - 1 do
          begin
            Check;
          end; // for NewRow := 0 to RowCount -1 do
        end; // for NewCol := 0 to ColCount -1 do
        if AddedCell then
        begin
          AddedCell := False;
          for NewCol := 0 to ColCount - 1 do
          begin
            for NewRow := RowCount - 1 downto 0 do
            begin
              Check;
            end; // for NewRow := 0 to RowCount -1 do
          end; // for NewCol := 0 to ColCount -1 do
        end;
        if AddedCell then
        begin
          AddedCell := False;
          for NewCol := ColCount - 1 downto 0 do
          begin
            for NewRow := RowCount - 1 downto 0 do
            begin
              Check;
            end; // for NewRow := 0 to RowCount -1 do
          end; // for NewCol := 0 to ColCount -1 do
        end;
        if AddedCell then
        begin
          AddedCell := False;
          for NewCol := ColCount - 1 downto 0 do
          begin
            for NewRow := 0 to RowCount - 1 do
            begin
              Check;
            end; // for NewRow := 0 to RowCount -1 do
          end; // for NewCol := 0 to ColCount -1 do
        end;
      until not AddedCell;}
  finally
    CellStack.Free;
    begin
      for index := TestValues.Count - 1 downto 0 do
      begin
        TRealValue(TestValues[index]).Free;
      end;
      TestValues.Free;
    end;
  end;
end;

constructor T2DBlockCenteredGrid.Create(ColWidths, RowWidths: TRealList;
  AnOriginX, AnOriginY, AGridAngle: double;
  RowsPositive, ColumnsPositive: boolean; Importer: TObject);
const
  Epsilon = 1E-2;
var
  XPosition, YPosition: double;
  Index: integer;
  ColIndex, RowIndex: integer;
  FirstVertex, SecondVertex, MiddleVertex: TPoint;
  HorSeg1, HorSeg2, VerSeg1, VerSeg2: TSegment;
  FirstRowPosition, LastRowPosition, FirstColPosition, LastColPosition: double;
  AModflowImporter: TfrmModflowImport;
begin
  inherited Create;
  if Importer is TfrmModflowImport then
  begin
    AModflowImporter := Importer as TfrmModflowImport;
    OriginX := AnOriginX;
    OriginY := AnOriginY;
    GridAngle := AGridAngle;

    if AModflowImporter.rgModelType.ItemIndex = 2 then
    begin
      FStressPeriodCount := AModflowImporter.MF2K_Importer.NPER;
    end
    else
    begin
      FStressPeriodCount := AModflowImporter.NPER;
    end;
    FVertexList := TList.Create;
    FMoreVerticies := TList.Create;
    FHorSegmentList := TList.Create;
    FVerSegmentList := TList.Create;
    FCellList := TList.Create;
    ColCount := ColWidths.Count;
    RowCount := RowWidths.Count;

    SetLength(CellUsed, ColCount, RowCount);
    for ColIndex := 0 to ColCount - 1 do
    begin
      for RowIndex := 0 to RowCount - 1 do
      begin
        CellUsed[ColIndex, RowIndex] := False;
      end;
    end;

    if ColWidths.Count > 0 then
    begin
      FPerturbation := ColWidths.Items[0];
    end
    else
    begin
      FPerturbation := 0;
    end;
    ColPositions := TRealList.Create;
    if ColPositions.Capacity < ColWidths.Count + 1 then
    begin
      ColPositions.Capacity := ColWidths.Count + 1;
    end;
    RowPositions := TRealList.Create;
    if RowPositions.Capacity < RowWidths.Count + 1 then
    begin
      RowPositions.Capacity := RowWidths.Count + 1;
    end;
    XPosition := OriginX;
    ColPositions.Add(XPosition);
    for Index := 0 to ColWidths.Count - 1 do
    begin
      if ColumnsPositive then
      begin
        XPosition := XPosition + ColWidths.Items[Index];
      end
      else
      begin
        XPosition := XPosition - ColWidths.Items[Index];
      end;
      ColPositions.Add(XPosition);
      FPerturbation := Min(FPerturbation, ColWidths.Items[Index]);
    end; // for Index := 0 to ColWidths.Count -1 do

    YPosition := OriginY;
    RowPositions.Add(YPosition);
    for Index := 0 to RowWidths.Count - 1 do
    begin
      if RowsPositive then
      begin
        YPosition := YPosition + RowWidths.Items[Index];
      end
      else
      begin
        YPosition := YPosition - RowWidths.Items[Index];
      end;
      RowPositions.Add(YPosition);
      FPerturbation := Min(FPerturbation, RowWidths.Items[Index]);
    end; // for Index := 0 to RowWidths.Count -1 do

    FirstRowPosition := RowPositions.Items[0];
    LastRowPosition := RowPositions.Items[RowPositions.Count - 1];
    FirstColPosition := ColPositions.Items[0];
    LastColPosition := ColPositions.Items[ColPositions.Count - 1];

    FPerturbation := Epsilon * FPerturbation;

    if FVertexList.Capacity < RowPositions.Count * ColPositions.Count then
    begin
      FVertexList.Capacity := RowPositions.Count * ColPositions.Count
    end;
    for RowIndex := 0 to RowPositions.Count - 1 do
    begin
      for ColIndex := 0 to ColPositions.Count - 1 do
      begin
        FirstVertex := TPoint.Create(ColPositions.Items[ColIndex],
          RowPositions.Items[RowIndex]);
        FVertexList.Add(FirstVertex);
        FirstVertex.RowIndex := RowIndex;
        FirstVertex.ColIndex := ColIndex;
      end;
    end; // for RowIndex := 0 to RowPositions.Count -1 do

    if FMoreVerticies.Capacity < 2 * RowPositions.Count * ColPositions.Count
      then
    begin
      FMoreVerticies.Capacity := 2 * RowPositions.Count * ColPositions.Count
    end;
    for RowIndex := 0 to RowPositions.Count - 1 do
    begin
      for ColIndex := 0 to ColPositions.Count - 2 do
      begin
        FirstVertex := GetVertex(ColIndex, RowIndex);
        SecondVertex := GetVertex(ColIndex + 1, RowIndex);
        MiddleVertex := TPoint.Create((FirstVertex.X + SecondVertex.X) / 2,
          FirstVertex.Y);
        if FirstVertex.X < MiddleVertex.X then
        begin
          FirstVertex.PointToRight := MiddleVertex;
          SecondVertex.PointToLeft := MiddleVertex;
          MiddleVertex.PointToRight := SecondVertex;
          MiddleVertex.PointToLeft := FirstVertex;
        end
        else
        begin
          FirstVertex.PointToLeft := MiddleVertex;
          SecondVertex.PointToRight := MiddleVertex;
          MiddleVertex.PointToLeft := SecondVertex;
          MiddleVertex.PointToRight := FirstVertex;
        end;
        FMoreVerticies.Add(MiddleVertex);
      end; // for ColIndex := 0 to ColPositions.Count -2 do
    end; // for RowIndex := 0 to RowPositions.Count -1 do

    for RowIndex := 0 to RowPositions.Count - 2 do
    begin
      for ColIndex := 0 to ColPositions.Count - 1 do
      begin
        FirstVertex := GetVertex(ColIndex, RowIndex);
        SecondVertex := GetVertex(ColIndex, RowIndex + 1);
        MiddleVertex := TPoint.Create(FirstVertex.X, (FirstVertex.Y +
          SecondVertex.Y) / 2);
        if FirstVertex.Y < MiddleVertex.Y then
        begin
          FirstVertex.PointAbove := MiddleVertex;
          SecondVertex.PointBelow := MiddleVertex;
          MiddleVertex.PointAbove := SecondVertex;
          MiddleVertex.PointBelow := FirstVertex;
        end
        else
        begin
          FirstVertex.PointBelow := MiddleVertex;
          SecondVertex.PointAbove := MiddleVertex;
          MiddleVertex.PointBelow := SecondVertex;
          MiddleVertex.PointAbove := FirstVertex;
        end;
        FMoreVerticies.Add(MiddleVertex);
      end; // for ColIndex := 0 to ColPositions.Count -2 do
    end; // for RowIndex := 0 to RowPositions.Count -1 do

    if FHorSegmentList.Capacity < RowPositions.Count * (ColPositions.Count - 1)
      then
    begin
      FHorSegmentList.Capacity := RowPositions.Count * (ColPositions.Count - 1);
    end;
    for RowIndex := 0 to RowPositions.Count - 1 do
    begin
      for ColIndex := 0 to ColPositions.Count - 2 do
      begin
        FirstVertex := GetVertex(ColIndex, RowIndex);
        SecondVertex := GetVertex(ColIndex + 1, RowIndex);
        FHorSegmentList.Add(TSegment.Create(FirstVertex, SecondVertex));
      end;
    end; // for RowIndex := 0 to RowPositions.Count -1 do

    if FVerSegmentList.Capacity < (RowPositions.Count - 1) * ColPositions.Count
      then
    begin
      FVerSegmentList.Capacity := (RowPositions.Count - 1) * ColPositions.Count
    end;
    for RowIndex := 0 to RowPositions.Count - 2 do
    begin
      for ColIndex := 0 to ColPositions.Count - 1 do
      begin
        FirstVertex := GetVertex(ColIndex, RowIndex);
        SecondVertex := GetVertex(ColIndex, RowIndex + 1);
        FVerSegmentList.Add(TSegment.Create(FirstVertex, SecondVertex));
      end;
    end; // for RowIndex := 0 to RowPositions.Count -1 do

    if FCellList.Capacity < RowCount * ColCount then
    begin
      FCellList.Capacity := RowCount * ColCount;
    end;
    for RowIndex := 0 to RowCount - 1 do
    begin
      for ColIndex := 0 to ColCount - 1 do
      begin
        HorSeg1 := HorSegments[ColIndex, RowIndex];
        HorSeg2 := HorSegments[ColIndex, RowIndex + 1];
        VerSeg1 := VerSegments[ColIndex, RowIndex];
        VerSeg2 := VerSegments[ColIndex + 1, RowIndex];
        FCellList.Add(TCell.Create(HorSeg1, HorSeg2, VerSeg1, VerSeg2));
      end;
    end;

    with AModflowImporter do
    begin
      if rgModelType.ItemIndex = 2 then
      begin
        with MF2K_Importer do
        begin
          if IUNIT[4] <> 0 then
          begin
            SetLength(EvapSurface, NCOL, NROW, NPER);
            SetLength(EvapRate, NCOL, NROW, NPER);
            SetLength(EvapExtDepth, NCOL, NROW, NPER);
            if NEVTOP = 2 then
            begin
              SetLength(EvapLayer, NCOL, NROW, NPER);
            end;
          end;
          if IUNIT[7] <> 0 then
          begin
            SetLength(RechRate, NCOL, NROW, NPER);
            if NRCHOP = 2 then
            begin
              SetLength(RechLayer, NCOL, NROW, NPER);
            end;
          end;
          if IUNIT[38] <> 0 then
          begin
            SetLength(ETS_Surface, NCOL, NROW);
            SetLength(ETS_MaxRate, NCOL, NROW, NPER);
            SetLength(ETS_ExtinctionDepth, NCOL, NROW);
            SetLength(ETS_IntermediateDepth, NCOL, NROW, NETSEG-1);
            SetLength(ETS_IntermediateRate, NCOL, NROW, NETSEG-1);
            if NETSOP = 2 then
            begin
              SetLength(ETS_Layer, NCOL, NROW);
            end;
          end;
        end;
      end
      else
      begin
        if IUNITX[4] <> 0 then
        begin
          SetLength(EvapSurface, NCOL, NROW, NPER);
          SetLength(EvapRate, NCOL, NROW, NPER);
          SetLength(EvapExtDepth, NCOL, NROW, NPER);
          if NEVTOP = 2 then
          begin
            SetLength(EvapLayer, NCOL, NROW, NPER);
          end;
        end;
        if IUNITX[7] <> 0 then
        begin
          SetLength(RechRate, NCOL, NROW, NPER);
          if NRCHOP = 2 then
          begin
            SetLength(RechLayer, NCOL, NROW, NPER);
          end;
        end;
      end;
    end;
  end;
end;

destructor T2DBlockCenteredGrid.Destroy;
var
  Index: Integer;
begin
  ColPositions.Free;
  RowPositions.Free;

  for Index := FVertexList.Count - 1 downto 0 do
  begin
    TPoint(FVertexList[Index]).Free;
  end;
  FVertexList.Free;

  for Index := FMoreVerticies.Count - 1 downto 0 do
  begin
    TPoint(FMoreVerticies[Index]).Free;
  end;
  FMoreVerticies.Free;

  for Index := FHorSegmentList.Count - 1 downto 0 do
  begin
    TSegment(FHorSegmentList[Index]).Free;
  end;
  FHorSegmentList.Free;

  for Index := FVerSegmentList.Count - 1 downto 0 do
  begin
    TSegment(FVerSegmentList[Index]).Free;
  end;
  FVerSegmentList.Free;

  for Index := FCellList.Count - 1 downto 0 do
  begin
    TCell(FCellList[Index]).Free;
  end;
  FCellList.Free;
  inherited Destroy;
end;

function T2DBlockCenteredGrid.GetCells(Col, Row: integer): TCell;
begin
  if not ((Col >= 0) and (Row >= 0) and (Col < ColCount) and (Row < RowCount))
    then
  begin
    Beep;
    MessageDlg('Your model is incorrectly specifying information for '
      + 'Column ' + intToStr(Col + 1) + ' and Row ' + IntToStr(Row + 1)
      + '.  Valid column numbers are from 1 to ' + IntToStr(ColCount)
      + '.  Valid row numbers are from 1 to ' + IntToStr(RowCount) + '.',
      mtError, [mbOK], 0);
    Assert(False);
  end;
  Result := FCellList[(ColCount) * Row + Col];

end;

function T2DBlockCenteredGrid.GetHorSegments(Col, Row: integer): TSegment;
begin
  Result := FHorSegmentList[(ColCount) * Row + Col];
end;

function T2DBlockCenteredGrid.GetVerSegments(Col, Row: integer): TSegment;
begin
  Result := FVerSegmentList[(ColCount + 1) * Row + Col];
end;

function T2DBlockCenteredGrid.GetVertex(Col, Row: integer): TPoint;
begin
  Result := FVertexList[(ColCount + 1) * Row + Col];
end;

function T2DBlockCenteredGrid.LayerZones(FunctionList:
  TReturnSingleFunctionList;
  Layer: Integer; Use3DFunctionList: TUse3DFunctionList;
  UseValue: boolean; Value: double): TZoneList;
var
  ColIndex, RowIndex: integer;
  ACell: TCell;
  UseIndex: integer;
begin
  result := TZoneList.Create(OriginX, OriginY, GridAngle);
  for ColIndex := 0 to ColCount - 1 do
  begin
    for RowIndex := 0 to RowCount - 1 do
    begin
      CellUsed[ColIndex, RowIndex] := False;
      for UseIndex := 0 to Use3DFunctionList.Count - 1 do
      begin
        CellUsed[ColIndex, RowIndex] := CellUsed[ColIndex, RowIndex] or
          not Use3DFunctionList.Items[UseIndex](ColIndex, RowIndex, Layer);
        if not CellUsed[ColIndex, RowIndex] then
        begin
          break;
        end;
      end;
    end;
  end;
  for ColIndex := 0 to ColCount - 1 do
  begin
    for RowIndex := 0 to RowCount - 1 do
    begin
      if not CellUsed[ColIndex, RowIndex] then
      begin
        ACell := Cells[ColIndex, RowIndex];
        result.FList.Add(MakeZone(ACell, ColIndex, RowIndex, Layer,
          FunctionList, FunctionList, UseValue, Value));
      end;
    end;
  end;
  result.RoundCorners;
end;

function T2DBlockCenteredGrid.MakeDataPoints(GetValueList, GetTimeValueList:
  T3DFunctionList;
  UseValueList: TUse3DFunctionList; Layer, NPER: integer;
  RowDirectionPositive, ColumnDirectionPositive: boolean): TStringList;
var
  ColIndex, RowIndex: integer;
  UseIndex, ValueIndex: integer;
  UseCell: boolean;
  APoint: TPoint;
  ACell: TCell;
  ALine: string;
  Value: double;
  TimeIndex: integer;
begin
  Result := TStringList.Create;
  if Result.Capacity < ColCount * RowCount + 2 then
  begin
    Result.Capacity := ColCount * RowCount + 2;
  end;
  Result.Add('');
  Result.Add('');
  for ColIndex := 0 to ColCount - 1 do
  begin
    for RowIndex := 0 to RowCount - 1 do
    begin
      UseCell := True;
      for UseIndex := 0 to UseValueList.Count - 1 do
      begin
        UseCell := UseCell and
          UseValueList.Items[UseIndex](ColIndex, RowIndex, Layer);
        if not UseCell then
        begin
          break;
        end;
      end;
      if UseCell then
      begin
        ACell := Cells[ColIndex, RowIndex];
        APoint := ACell.CenterPoint {.CopyPoint};
        try
          ALine := APoint.PointToString(OriginX, OriginY, GridAngle, 0, 0,
            RowDirectionPositive, ColumnDirectionPositive);

          for ValueIndex := 0 to GetValueList.Count - 1 do
          begin
            Value := GetValueList.Items[ValueIndex](ColIndex, RowIndex, Layer);
            ALine := ALine + Char(9) + InternationalFloatToStr(Value);
          end;
          for ValueIndex := 0 to GetTimeValueList.Count - 1 do
          begin
            for TimeIndex := 0 to NPER - 1 do
            begin
              Value := GetTimeValueList.Items[ValueIndex](ColIndex, RowIndex,
                TimeIndex);
              ALine := ALine + Char(9) + InternationalFloatToStr(Value);
            end;
          end;
        finally
          APoint.Free;
        end;
        Result.Add(ALine);
      end;
    end;
  end;
  ALine := IntToStr(result.Count - 2) + Char(9) + IntToStr(GetValueList.Count +
    GetTimeValueList.Count * NPER);
  result[0] := Aline;
end;

procedure T2DBlockCenteredGrid.MakeDrainBoundaries(StressPeriod: integer);
var
  DrainIndex: integer;
  ColIndex, RowIndex: integer;
  ACell: TCell;
begin
  for DrainIndex := 0 to frmModflowImport.NumberOfDrains - 1 do
  begin
    ColIndex := Round(frmModflowImport.GetDrain(DrainIndex, drnCol)) - 1;
    RowIndex := Round(frmModflowImport.GetDrain(DrainIndex, drnRow)) - 1;
    ACell := Cells[ColIndex, RowIndex];
    TDrainBoundary.Create(ACell, DrainIndex, StressPeriod);
  end;
end;

procedure T2DBlockCenteredGrid.MakeMF2KDrainBoundaries(StressPeriod: integer);
var
  ColIndex, RowIndex, LayerIndex: longint;
  Elevation, Cond: Single;
  IIndex, I: longint;
  ACell: TCell;
  IPSUM: longint;
  Index: integer;
  ISTART, ISTOP: longint;
  CellListIndex: integer;
  NUMINST: LongInt;
  IStressPeriod: integer;
  Count: integer;
  CellCount: integer;
begin
  if StressPeriod = 0 then
  begin
    GetIPSUM(IPSUM);
    for Index := 1 to IPSUM do
    begin
      if PARTYP(Index) <> 'DRN' then continue;
      I := Index;
      GetClusterRange(I, ISTART, ISTOP);
      GetInstanceCount(I, NUMINST);
      Count := 0;
      IStressPeriod := 0;
      CellCount := (ISTOP - ISTART + 1) div NUMINST;
      for CellListIndex := ISTART to ISTOP do
      begin
        IIndex := CellListIndex;
        GetDrain(LayerIndex, RowIndex, ColIndex, Elevation, Cond, IIndex);
        ACell := Cells[ColIndex-1, RowIndex-1];
        TMF2KDrainBoundary.Create(ACell, IIndex, IStressPeriod, PARNAM(Index));
        Inc(Count);
        if Count = CellCount then
        begin
          Count := 0;
          Inc(IStressPeriod);
        end;
      end;
    end;
  end;

  for Index := 1 to frmModflowImport.MF2K_Importer.NNPDRN do
  begin
    IIndex := Index;
    GetDrain(LayerIndex, RowIndex, ColIndex, Elevation, Cond, IIndex);
    ACell := Cells[ColIndex-1, RowIndex-1];
    TMF2KDrainBoundary.Create(ACell, IIndex, StressPeriod, '0');
  end;
end;

procedure T2DBlockCenteredGrid.MakeFHBFlowBoundaries(
  StressPeriod: integer);
var
  FlowIndex: integer;
  ColIndex, RowIndex: integer;
  ACell: TCell;
begin
  for FlowIndex := 0 to frmModflowImport.NumberOfFHBFlows - 1 do
  begin
    ColIndex := Round(frmModflowImport.GetFlowLoc(FlowIndex, fhbCol)) - 1;
    RowIndex := Round(frmModflowImport.GetFlowLoc(FlowIndex, fhbRow)) - 1;
    ACell := Cells[ColIndex, RowIndex];
    TFHBFlowBoundary.Create(ACell, FlowIndex, StressPeriod);
  end;
end;

procedure T2DBlockCenteredGrid.MakeFHBHeadBoundaries(
  StressPeriod: integer);
var
  HeadIndex: integer;
  ColIndex, RowIndex: integer;
  ACell: TCell;
begin
  for HeadIndex := 0 to frmModflowImport.NumberOfFHBHeads - 1 do
  begin
    ColIndex := Round(frmModflowImport.GetHeadLoc(HeadIndex, fhbCol)) - 1;
    RowIndex := Round(frmModflowImport.GetHeadLoc(HeadIndex, fhbRow)) - 1;
    ACell := Cells[ColIndex, RowIndex];
    TFHBHeadBoundary.Create(ACell, HeadIndex, StressPeriod);
  end;
end;

procedure T2DBlockCenteredGrid.MakeGHBBoundaries(StressPeriod: integer);
var
  GHB_Index: integer;
  ColIndex, RowIndex: integer;
  ACell: TCell;
begin
  for GHB_Index := 0 to frmModflowImport.NumberOfGHBBoundaries - 1 do
  begin
    ColIndex := Round(frmModflowImport.GetGHB(GHB_Index, ghbCol)) - 1;
    RowIndex := Round(frmModflowImport.GetGHB(GHB_Index, ghbRow)) - 1;
    ACell := Cells[ColIndex, RowIndex];
    TGHBBoundary.Create(ACell, GHB_Index, StressPeriod);
  end;
end;

procedure T2DBlockCenteredGrid.MakeHFBBoundaries;
var
  BarrierIndex: integer;
  ColIndex, RowIndex: integer;
  ACell: TCell;
begin
  for BarrierIndex := 0 to frmModflowImport.NumberOfBarriers - 1 do
  begin
    ColIndex := Round(frmModflowImport.GetHFBR(BarrierIndex, hfbCol1)) - 1;
    RowIndex := Round(frmModflowImport.GetHFBR(BarrierIndex, hfbRow1)) - 1;
    ACell := Cells[ColIndex, RowIndex];
    THorizontalFlowBoundary.Create(ACell, BarrierIndex, 0);
  end;
end;

function T2DBlockCenteredGrid.MakePointContourFromLayer(
  GetValueList: T3DFunctionList; UseValueList: TUse3DFunctionList;
  Layer: integer): TEditContours;
var
  ColIndex, RowIndex: integer;
  UseIndex, ValueIndex: integer;
  UseCell: boolean;
  AContour: TContour2;
  APoint: TPoint;
  ACell: TCell;
  ARealValue: TRealValue;
  StressPeriodIndex: integer;
begin
  Result := TEditContours.Create(OriginX, OriginY, GridAngle);
  if Result.ContourList.Capacity < ColCount * RowCount then
  begin
    Result.ContourList.Capacity := ColCount * RowCount;
  end;
  for ColIndex := 0 to ColCount - 1 do
  begin
    for RowIndex := 0 to RowCount - 1 do
    begin
      UseCell := True;
      for UseIndex := 0 to UseValueList.Count - 1 do
      begin
        UseCell := UseCell and
          UseValueList.Items[UseIndex](ColIndex, RowIndex, Layer);
        if not UseCell then
        begin
          break;
        end;
      end;
      if UseCell then
      begin
        AContour := TContour2.Create;
        Result.ContourList.Add(AContour);
        ACell := self.Cells[ColIndex, RowIndex];
        APoint := ACell.CenterPoint {.CopyPoint};
        AContour.FPoints.Add(APoint);
        for ValueIndex := 0 to GetValueList.Count - 1 do
        begin
          ARealValue := TRealValue.Create;
          if GetValueList.UseAll[ValueIndex] then
          begin
            if AContour.ValueList.Capacity < FStressPeriodCount then
            begin
              AContour.ValueList.Capacity := FStressPeriodCount;
            end;
            for StressPeriodIndex := 0 to FStressPeriodCount - 1 do
            begin
              ARealValue.Value
                := GetValueList.Items[ValueIndex](ColIndex, RowIndex,
                StressPeriodIndex);
              AContour.ValueList.Add(ARealValue);
            end;
          end
          else
          begin
            ARealValue.Value
              := GetValueList.Items[ValueIndex](ColIndex, RowIndex, Layer);
            AContour.ValueList.Add(ARealValue);
          end;
        end;
      end;
    end;
  end;
end;

procedure T2DBlockCenteredGrid.MakeRiverBoundaries(StressPeriod: integer);
var
  RiverIndex: integer;
  ColIndex, RowIndex: integer;
  ACell: TCell;
begin
  for RiverIndex := 0 to frmModflowImport.NumberOfRivers - 1 do
  begin
    ColIndex := Round(frmModflowImport.GetRIVR(RiverIndex, rivCol)) - 1;
    RowIndex := Round(frmModflowImport.GetRIVR(RiverIndex, rivRow)) - 1;
    ACell := Cells[ColIndex, RowIndex];
    TRiverBoundary.Create(ACell, RiverIndex, StressPeriod);
  end;
end;

procedure T2DBlockCenteredGrid.MakeStreamBoundaries(StressPeriod: integer);
var
  StreamIndex: integer;
  ColIndex, RowIndex: integer;
  ACell: TCell;
begin
  for StreamIndex := 0 to frmModflowImport.NumberOfStreamCells - 1 do
  begin
    ColIndex := Round(frmModflowImport.GetICSTRM(StreamIndex, strCol)) - 1;
    RowIndex := Round(frmModflowImport.GetICSTRM(StreamIndex, strRow)) - 1;
    ACell := Cells[ColIndex, RowIndex];
    TStreamBoundary.Create(ACell, StreamIndex, StressPeriod);
  end;
end;

procedure T2DBlockCenteredGrid.MakeWellBoundaries(StressPeriod: integer);
var
  WellIndex: integer;
  ColIndex, RowIndex: integer;
  ACell: TCell;
begin
  for WellIndex := 0 to frmModflowImport.NumberOfWells - 1 do
  begin
    ColIndex := Round(frmModflowImport.GetWELL(WellIndex, welCol)) - 1;
    RowIndex := Round(frmModflowImport.GetWELL(WellIndex, welRow)) - 1;
    ACell := Cells[ColIndex, RowIndex];
    TWellBoundary.Create(ACell, WellIndex, StressPeriod);
  end;
end;

procedure T2DBlockCenteredGrid.MakeMF2K_WellBoundaries(StressPeriod: integer);
var
  ColIndex, RowIndex, LayerIndex: longint;
  Q: Single;
  IIndex, I: longint;
  ACell: TCell;
  IPSUM: longint;
  Index: integer;
  ISTART, ISTOP: longint;
  CellListIndex: integer;
  NUMINST: LongInt;
  IStressPeriod: integer;
  Count: integer;
  CellCount: integer;
begin
  if StressPeriod = 0 then
  begin
    GetIPSUM(IPSUM);
    for Index := 1 to IPSUM do
    begin
      if PARTYP(Index) <> 'Q' then continue;
      I := Index;
      GetClusterRange(I, ISTART, ISTOP);
      GetInstanceCount(I, NUMINST);
      Count := 0;
      IStressPeriod := 0;
      CellCount := (ISTOP - ISTART + 1) div NUMINST;
      for CellListIndex := ISTART to ISTOP do
      begin
        IIndex := CellListIndex;
        GetWell(LayerIndex, RowIndex, ColIndex, Q, IIndex);
        ACell := Cells[ColIndex-1, RowIndex-1];
        TMF2K_WellBoundary.Create(ACell, IIndex, IStressPeriod, PARNAM(Index));
        Inc(Count);
        if Count = CellCount then
        begin
          Count := 0;
          Inc(IStressPeriod);
        end;
      end;
    end;
  end;

  for Index := 1 to frmModflowImport.MF2K_Importer.NNPWEL do
  begin
    IIndex := Index;
    GetWell(LayerIndex, RowIndex, ColIndex, Q, IIndex);
    ACell := Cells[ColIndex-1, RowIndex-1];
    TMF2K_WellBoundary.Create(ACell, IIndex, StressPeriod, '0');
  end;

end;

function T2DBlockCenteredGrid.MakeZone(ACell: TCell; Col, Row, Layer: integer;
  CompareList, ValueFunctionList: TReturnSingleFunctionList;
  UseValue: boolean; Value: double): TZone;
var
  Index: Integer;
  A3DFunction: TGet3dValue;
  ASurfaceFunction: TGetSurface;
  A3DFunctionList: T3DFunctionList;
  ASurfaceFunctionList: TSurfaceFunctionList;
  AZoneValue: TSingle;
  StressPeriodIndex: integer;
begin
  result := TZone.Create;
  if UseValue then
  begin
    AZoneValue := TSingle.Create;
    AZoneValue.Value := Value;
    result.ValueList.Add(AZoneValue);
  end
  else
  begin

    for Index := 0 to ValueFunctionList.Count - 1 do
    begin
      if ValueFunctionList is T3DFunctionList then
      begin
        A3DFunctionList := ValueFunctionList as T3DFunctionList;
        A3DFunction := A3DFunctionList.Items[Index];
        if A3DFunctionList.UseAll[Index] then
        begin
          if result.ValueList.Capacity < FStressPeriodCount then
          begin
            result.ValueList.Capacity := FStressPeriodCount;
          end;
          for StressPeriodIndex := 0 to FStressPeriodCount - 1 do
          begin
            AZoneValue := TSingle.Create;
            AZoneValue.Value := A3DFunction(Col, Row, StressPeriodIndex);
            result.ValueList.Add(AZoneValue);
          end
        end
        else
        begin
          AZoneValue := TSingle.Create;
          AZoneValue.Value := A3DFunction(Col, Row, Layer);
          result.ValueList.Add(AZoneValue);
        end;
      end
      else
      begin
        AZoneValue := TSingle.Create;
        ASurfaceFunctionList := ValueFunctionList as TSurfaceFunctionList;
        ASurfaceFunction := ASurfaceFunctionList.Items[Index];
        AZoneValue.Value := ASurfaceFunction(Col, Row);
        result.ValueList.Add(AZoneValue);
      end;
    end;
  end;

  result.Add(ACell);
  CellUsed[Col, Row] := True;
  // AddNeighbors recursively adds all cells that
  // are adjacent to ACell and for which all the
  // functions in FunctionList have the same result;
  AddNeighbors(result, Col, Row, Layer, CompareList);
  result.MakeVertexList;

end;

procedure T2DBlockCenteredGrid.MakeMF2K_GHB_Boundaries(
  StressPeriod: integer);
var
  ColIndex, RowIndex, LayerIndex: longint;
  Elevation, Cond: Single;
  IIndex, I: longint;
  ACell: TCell;
  IPSUM: longint;
  Index: integer;
  ISTART, ISTOP: longint;
  CellListIndex: integer;
  NUMINST: LongInt;
  IStressPeriod: integer;
  Count: integer;
  CellCount: integer;
begin
  if StressPeriod = 0 then
  begin
    GetIPSUM(IPSUM);
    for Index := 1 to IPSUM do
    begin
      if PARTYP(Index) <> 'GHB' then continue;
      I := Index;
      GetClusterRange(I, ISTART, ISTOP);
      GetInstanceCount(I, NUMINST);
      Count := 0;
      IStressPeriod := 0;
      CellCount := (ISTOP - ISTART + 1) div NUMINST;
      for CellListIndex := ISTART to ISTOP do
      begin
        IIndex := CellListIndex;
        GetGHB(LayerIndex, RowIndex, ColIndex, Elevation, Cond, IIndex);
        ACell := Cells[ColIndex-1, RowIndex-1];
        TMF2K_GHBBoundary.Create(ACell, IIndex, IStressPeriod, PARNAM(Index));
        Inc(Count);
        if Count = CellCount then
        begin
          Count := 0;
          Inc(IStressPeriod);
        end;
      end;
    end;
  end;

  for Index := 1 to frmModflowImport.MF2K_Importer.NNPGHB do
  begin
    IIndex := Index;
    GetGHB(LayerIndex, RowIndex, ColIndex, Elevation, Cond, IIndex);
    ACell := Cells[ColIndex-1, RowIndex-1];
    TMF2K_GHBBoundary.Create(ACell, IIndex, StressPeriod, '0');
  end;
end;

procedure T2DBlockCenteredGrid.MakeMF2K_RiverBoundaries(
  StressPeriod: integer);
var
  ColIndex, RowIndex, LayerIndex: longint;
  Elevation, Cond, RBOT: Single;
  IIndex, I: longint;
  ACell: TCell;
  IPSUM: longint;
  Index: integer;
  ISTART, ISTOP: longint;
  CellListIndex: integer;
  NUMINST: LongInt;
  IStressPeriod: integer;
  Count: integer;
  CellCount: integer;
begin
  if StressPeriod = 0 then
  begin
    GetIPSUM(IPSUM);
    for Index := 1 to IPSUM do
    begin
      if PARTYP(Index) <> 'RIV' then continue;
      I := Index;
      GetClusterRange(I, ISTART, ISTOP);
      GetInstanceCount(I, NUMINST);
      Count := 0;
      IStressPeriod := 0;
      CellCount := (ISTOP - ISTART + 1) div NUMINST;
      for CellListIndex := ISTART to ISTOP do
      begin
        IIndex := CellListIndex;
        GetRiver(LayerIndex, RowIndex, ColIndex, Elevation, Cond, RBOT, IIndex);
        ACell := Cells[ColIndex-1, RowIndex-1];
        TMF2K_RiverBoundary.Create(ACell, IIndex, IStressPeriod, PARNAM(Index));
        Inc(Count);
        if Count = CellCount then
        begin
          Count := 0;
          Inc(IStressPeriod);
        end;
      end;
    end;
  end;

  for Index := 1 to frmModflowImport.MF2K_Importer.NNPRIV do
  begin
    IIndex := Index;
      GetRiver(LayerIndex, RowIndex, ColIndex, Elevation, Cond, RBOT, IIndex);
    ACell := Cells[ColIndex-1, RowIndex-1];
    TMF2K_RiverBoundary.Create(ACell, IIndex, StressPeriod, '0');
  end;
end;

procedure T2DBlockCenteredGrid.MakeMF2K_CHD_Boundaries(
  StressPeriod: integer);
var
  ColIndex, RowIndex, LayerIndex: longint;
  StartHead, EndHead: Single;
  IIndex, I: longint;
  ACell: TCell;
  IPSUM: longint;
  Index: integer;
  ISTART, ISTOP: longint;
  CellListIndex: integer;
  NUMINST: LongInt;
  IStressPeriod: integer;
  Count: integer;
  CellCount: integer;
begin
  if StressPeriod = 0 then
  begin
    GetIPSUM(IPSUM);
    for Index := 1 to IPSUM do
    begin
      if PARTYP(Index) <> 'CHD' then continue;
      I := Index;
      GetClusterRange(I, ISTART, ISTOP);
      GetInstanceCount(I, NUMINST);
      Count := 0;
      IStressPeriod := 0;
      CellCount := (ISTOP - ISTART + 1) div NUMINST;
      for CellListIndex := ISTART to ISTOP do
      begin
        IIndex := CellListIndex;
        GetCHD(LayerIndex, RowIndex, ColIndex, StartHead, EndHead, IIndex);
        ACell := Cells[ColIndex-1, RowIndex-1];
        TMF2K_CHD_Boundary.Create(ACell, IIndex, IStressPeriod, PARNAM(Index));
        Inc(Count);
        if Count = CellCount then
        begin
          Count := 0;
          Inc(IStressPeriod);
        end;
      end;
    end;
  end;

  for Index := 1 to frmModflowImport.MF2K_Importer.NNPCHD do
  begin
    IIndex := Index;
    GetCHD(LayerIndex, RowIndex, ColIndex, StartHead, EndHead, IIndex);
    ACell := Cells[ColIndex-1, RowIndex-1];
    TMF2K_CHD_Boundary.Create(ACell, IIndex, StressPeriod, '0');
  end;
end;

function T2DBlockCenteredGrid.PerturbAmount: double;
var
  Index: integer;
  FoundFirst: boolean;
  temp: double;
begin
  FoundFirst := False;
  result := 0;
  if ColPositions.Count > 1 then
  begin
    FoundFirst := True;
    result := Abs(ColPositions[1] - ColPositions[0]);
    for Index := 1 to ColPositions.Count -1 do
    begin
      temp := Abs(ColPositions[Index] - ColPositions[Index-1]);
      if temp < result then
      begin
        result := temp
      end;
    end;
  end;
  if RowPositions.Count > 1 then
  begin
    if not FoundFirst then
    begin
      result := Abs(RowPositions[1] - RowPositions[0]);
    end;
    for Index := 1 to RowPositions.Count -1 do
    begin
      temp := Abs(RowPositions[Index] - RowPositions[Index-1]);
      if temp < result then
      begin
        result := temp
      end;
    end;
  end;
  result := result / 100;
end;

{ TZoneList }

constructor TZoneList.Create(AnOriginX, AnOriginY, AGridAngle: double);
begin
  inherited Create;
  FList := TList.Create;
  OriginX := AnOriginX;
  OriginY := AnOriginY;
  GridAngle := AGridAngle;
end;

destructor TZoneList.Destroy;
var
  Index: integer;
  AZone: TZone;
begin
  for Index := FList.Count - 1 downto 0 do
  begin
    AZone := FList[Index];
    AZone.Free;
  end;
  FList.Free;
  inherited Destroy;
end;

procedure TZoneList.RoundCorners;
var
  Index: integer;
  AZone: TZone;
begin
  for Index := 0 to FList.Count - 1 do
  begin
    AZone := FList[Index];
    AZone.RoundCorners;
    AZone.EliminateMiddlePoints;
  end;
end;

procedure TZoneList.WriteZones(Perturbation: double;
  RowDirectionPositive, ColumnDirectionPositive: boolean; ContourStringList:
  TStringList; const Offset: double);
var
  EditContours: TEditContours;
  AZone: TZone;
  Index: Integer;
  AContour: TContour2;
  AVertex: TPoint;
  VertexIndex: integer;
  ValuesIndex: Integer;
  ARealValue: TRealValue;
begin
  EditContours := TEditContours.Create(OriginX, OriginY, GridAngle);
  try
    if EditContours.ContourList.Capacity < FList.Count then
    begin
      EditContours.ContourList.Capacity := FList.Count;
    end;
    for Index := 0 to FList.Count - 1 do
    begin
      AZone := FList[Index];
      AContour := TContour2.Create;
      EditContours.ContourList.Add(AContour);

      AContour.Value := '';
      if AContour.ValueList.Capacity < AZone.ValueList.Count then
      begin
        AContour.ValueList.Capacity := AZone.ValueList.Count;
      end;
      for ValuesIndex := 0 to AZone.ValueList.Count - 1 do
      begin
        ARealValue := TRealValue.Create;
        ARealValue.Value :=
          TSingle(AZone.ValueList[ValuesIndex]).Value;
        AContour.ValueList.Add(ARealValue);
      end;

      if AContour.FPoints.Capacity < AZone.FVertexList.Count then
      begin
        AContour.FPoints.Capacity := AZone.FVertexList.Count;
      end;
      for VertexIndex := 0 to AZone.FVertexList.Count - 1 do
      begin
        AVertex := AZone.FVertexList[VertexIndex];
        AVertex := AVertex.CopyPoint;
        AVertex.X := AVertex.X + Offset;
        AVertex.Y := AVertex.Y + Offset;
        AContour.FPoints.Add(AVertex);
      end;
    end;
    EditContours.WriteContours(Perturbation, RowDirectionPositive,
      ColumnDirectionPositive, ContourStringList);

  finally
    EditContours.Free;
  end;

end;

{ T3DFunctionList }

procedure T3DFunctionList.Add(A3DFunction: TGet3dValue; UseAll: boolean);
var
  AGet3dValue: TGet3dValueClass;
begin
  AGet3dValue := TGet3dValueClass.Create;
  AGet3dValue.Method := A3DFunction;
  AGet3dValue.FUseAll := UseAll;
  FList.Add(AGet3dValue);
end;

destructor T3DFunctionList.Destroy;
var
  Index: Integer;
begin
  for Index := FList.Count - 1 downto 0 do
  begin
    TGet3dValueClass(FList[Index]).Free;
  end;
  inherited Destroy;
end;

function T3DFunctionList.GetItems(const Index: integer): TGet3dValue;
var
  AGet3dValue: TGet3dValueClass;
begin
  AGet3dValue := FList.Items[Index];
  result := AGet3dValue.Method;
end;

function T3DFunctionList.GetUse(const Index: integer): Boolean;
var
  AGet3dValue: TGet3dValueClass;
begin
  AGet3dValue := FList.Items[Index];
  result := AGet3dValue.FUseAll;
end;

{ TPointList }

procedure TPointList.EliminateExtraVerticies;
var
  Index: Integer;
  Vertex1, Vertex2, Vertex3: TPoint;
begin
  // Loop over the verticies in the vertex list.
  // For now, we will skip the first and last
  // verticies. (The first and last verticies should
  // be the same vertex.)
  for Index := Count - 2 downto 1 do
  begin
    // get three adjacent verticies in a vertexList
    Vertex1 := Items[Index - 1];
    Vertex2 := Items[Index];
    Vertex3 := Items[Index + 1];
    // Check if the verticies lie on a straight line
    if ((Vertex1.X = Vertex2.X) and (Vertex2.X = Vertex3.X)) or
      ((Vertex1.Y = Vertex2.Y) and (Vertex2.Y = Vertex3.Y)) then
    begin
      // If the verticies lie on a straight line, delete
      // the middle one.
      Delete(Index);
    end;
  end;
  // Now check if the first vertex lies on a straight line
  // with its neighbors.
  // Because the first vertex is the same as the last
  // vertex, the proper neighbor to use is the one
  // at AVertexList.Count-2 rather than AVertexList.Count-1
  Vertex1 := Items[Count - 2];
  Vertex2 := Items[0];
  Vertex3 := Items[1];
  if ((Vertex1.X = Vertex2.X) and (Vertex2.X = Vertex3.X)) or
    ((Vertex1.Y = Vertex2.Y) and (Vertex2.Y = Vertex3.Y)) then
  begin
    // If the verticies lie on a straight line, delete
    // the first vertex and its copy at the end.
    Delete(0);
    Delete(Count - 1);
    // Add a new copy of the new first vertex to the end
    // of the contour.
    Add(Vertex3);
  end;

end;

function TPointList.GetFirstUnsharedPoint(
  AVertexList: TPointList): TPoint;
var
  Index: integer;
begin
  result := nil;
  for Index := 0 to Count - 1 do
  begin
    Result := Items[Index];
    if not (AVertexList.IndexOf(Result) > -1) then
    begin
      break;
    end;
  end;
end;

function TPointList.GetOverLappedSection: TPointList;
var
  OverLapFound: boolean;
  Index, InnerIndex, AnotherIndex: Integer;
  AVertex, AnotherVertex: TPoint;
begin
  result := nil;
  OverLapFound := False;
  // Loop over the verticies in AVertexList
  for Index := 0 to Count - 3 do
  begin
    // get AVertex
    AVertex := Items[Index];
    // Loop over the remaining verticies in AVertexList
    for InnerIndex := Index + 1 to Count - 2 do
    begin
      // get AnotherVertex
      AnotherVertex := Items[InnerIndex];
      // Test whether the verticies are the same
      if AVertex = AnotherVertex then
      begin
        // if they are the same, set OverLapFound
        OverLapFound := True;
        // Create a new VertexList.
        result := TPointList.Create;
        // Add the overlap Vertex to AnotherVertexList
        result.Add(AVertex);
        // Add the other verticies between the spot
        // where the verticies overlap to AnotherVertexList
        // and remove them from AVertexList
        for AnotherIndex := Index + 1 to InnerIndex do
        begin
          result.Add(Items[AnotherIndex]);
          Items[AnotherIndex] := nil;
        end; // for AnotherIndex := Index + 1 to InnerIndex do
        // remove nil pointers from AVertexList
        Pack;
        // restart from the beginning to look for additional overlaps.
        break;
      end; // if AVertex = AnotherVertex then
    end; // For InnerIndex := Index + 1 to AVertexList.Count -2 do
    if OverLapFound then
    begin
      // restart from the beginning to look for additional overlaps.
      break;
    end; // if OverLapFound then
  end; // For Index := 0 to AVertexList.Count -3 do

end;

function TPointList.PointInside(VertexToCheck: TPoint): boolean;
var
  VertexIndex: integer;
  AVertex, AnotherVertex: TPoint;
begin // based on CACM 112
  result := true;
  for VertexIndex := 0 to Count - 2 do
  begin
    AVertex := Items[VertexIndex];
    AnotherVertex := Items[VertexIndex + 1];
    if ((VertexToCheck.FY <= AVertex.FY) = (VertexToCheck.FY > AnotherVertex.FY))
      and
      (VertexToCheck.FX - AVertex.FX - (VertexToCheck.FY - AVertex.FY) *
      (AnotherVertex.FX - AVertex.FX) /
      (AnotherVertex.FY - AVertex.FY) < 0) then
    begin
      result := not result;
    end;
  end;
  result := not result;
end;

{ TSegmentList }

function TSegmentList.GetListOfVertexLists: TListOfVertexLists;
var
  FoundSegments: TList;
  CurrentSegment, PreviousSegment: TSegment;
  CurrentVertex, InitialVertex: TPoint;
  PrevDirection, CurDirection: Direction;
  AVertexList: TPointList;
  Index: integer;
  procedure UpdateCurrentObjects;
  begin
    // Update PreviousSegment and CurrentVertex
    // add the current vertex to AVertexList and
    // remove the CurrentSegment from the SegmentList

    // Update the PreviousSegment
    PreviousSegment := CurrentSegment;
    // Update CurrentVertex
    if CurrentVertex = CurrentSegment.FStartPoint then
    begin
      CurrentVertex := CurrentSegment.FEndPoint;
    end
    else
    begin
      CurrentVertex := CurrentSegment.FStartPoint;
    end; // if CurrentVertex = CurrentSegment.EndVertex then
    // Add CurrentVertex to the vertex list.
    AVertexList.Add(CurrentVertex);
    // Remove CurrentSegment from the list of unused segments.
    Remove(CurrentSegment);
  end;
  procedure InitializeObjects;
  var
    Index: integer;
  begin
    // if there are any segments left in TempSegList
    // start a new VertexList
    Index := Count - 1;
    if Index > -1 then
    begin
      // create a list of verticies
      AVertexList := TPointList.Create;
      // add the VertexList to ListOfVertexLists
      result.Add(AVertexList);
      // Set the first segment in the new contour
      PreviousSegment := Items[Index];
      // delete the first segment from TempSegList
      Delete(Index);
      // Set the first vertex and add it to the VertexList
      InitialVertex := PreviousSegment.FStartPoint;
      AVertexList.Add(InitialVertex);
      // Set the second vertex and add it to the vertex list
      CurrentVertex := PreviousSegment.FEndPoint;
      AVertexList.Add(CurrentVertex);
    end;
  end;
begin
  result := TListOfVertexLists.Create;
  // If multiple segments match the end of the current
  // segment FoundSegments will hold a list of all those
  // segments.
  FoundSegments := TList.Create;
  try
    begin
      InitializeObjects;
      FoundSegments.Capacity := Count;
      while Count > 0 do
      begin
        // Loop over all remaining segments in TempSegList
        for Index := Count - 1 downto 0 do
        begin
          CurrentSegment := Items[Index];
          // If one end of a segment matches the current
          // vertex, add the segment to FoundSegments
          // and set Found to True.
          if (CurrentVertex = CurrentSegment.FStartPoint) or
            (CurrentVertex = CurrentSegment.FEndPoint) then
          begin
            FoundSegments.Add(CurrentSegment);
          end;
        end;
        // If any segments were found one of whose ends match
        // the current vertex, deal with those verticies.
        if FoundSegments.Count > 0 then
        begin
          // If more than one segment was found, decide
          // which one to use. Arbitrarily, we will
          // use the one that will cause the contour
          // to turn to the right. Turning left would
          // have been OK too.
          if FoundSegments.Count = 1 then
          begin
            // If only one segment was found, use that segment.
            // Set the CurrentSegment
            CurrentSegment := FoundSegments[0];

            // Update PreviousSegment and CurrentVertex
            // add the current vertex to AVertexList and
            // remove the CurrentSegment from TempSegList
            UpdateCurrentObjects;
          end
          else // if FoundSegments.Count = 1 then
          begin
            // Choose which segment to use.

            // Get the direction of PreviousSegment
            PrevDirection := PreviousSegment.GetDirectionWithEnd(CurrentVertex);

            // Loop over all the segments whose ends match
            // the current vertex.
            for Index := 0 to FoundSegments.Count - 1 do
            begin
              CurrentSegment := FoundSegments[Index];
              // Get the direction of CurrentSegment
              CurDirection := CurrentSegment.GetDirection(CurrentVertex);
              // use the current segment if that will make the
              // contour turn to the right
              if ((PrevDirection = Down) and (CurDirection = Right)) or
                ((PrevDirection = Up) and (CurDirection = Left)) or
                ((PrevDirection = Left) and (CurDirection = Down)) or
                ((PrevDirection = Right) and (CurDirection = Up)) then
              begin
                // Update PreviousSegment and CurrentVertex
                // add the current vertex to AVertexList and
                // remove the CurrentSegment from TempSegList
                UpdateCurrentObjects;
                // stop looping over segments that were found.
                break;
              end; // if ((PrevDirection = Down ) and (CurDirection = Left )) or
              //    ((PrevDirection = Up   ) and (CurDirection = Right)) or
              //    ((PrevDirection = Left ) and (CurDirection = Up   )) or
              //    ((PrevDirection = Right) and (CurDirection = Down )) then
            end; // for AnotherIndex := 0 to FoundSegments.Count -1 do
          end; // // if FoundSegments.Count = 1 then else
          // Clear FoundSegments so it will be ready for the next
          // attempt to find a segment.
          FoundSegments.Clear;
          // If we have come back to our starting point,
          // start a new vertexList.
          if CurrentVertex = InitialVertex then
          begin
            InitializeObjects;
          end;
        end
        else // if Found then
        begin
          // If no verticies were found one of whose ends matches
          // the current vertex, start a new vertex list.
          InitializeObjects;
        end; // if Found then else
      end; // while TempSegList.Count > 0 do
    end;
  finally
    begin
      FoundSegments.Free;
    end;
  end;
  result.EliminateInteriorLists;
end;

{ TListOfVertexLists }

procedure TListOfVertexLists.EliminateInteriorLists;
var
  AVertexList, AnotherVertexList: TPointList;
  Index, InnerIndex, InnermostIndex: integer;
  AVertex, AnotherVertex: TPoint;
  AllEliminated: boolean;
begin
  while Count > 1 do
  begin
    // get the first vertexList
    AVertexList := Items[0];
    if not (AVertexList[0] = AVertexList[AVertexList.Count - 1]) then
    begin
      AVertexList.Add(AVertexList[0])
    end;
    // Loop over all other vertex lists.
    for Index := Count - 1 downto 1 do
    begin
      // get another vertex list
      AnotherVertexList := Items[Index];
      if not (AnotherVertexList[0] = AnotherVertexList[AnotherVertexList.Count -
        1]) then
      begin
        AnotherVertexList.Add(AnotherVertexList[0])
      end;
      // get the first vertex in AnotherVertexList
      // that does not intercept a vertex in AVertexList
      AVertex := AnotherVertexList.GetFirstUnsharedPoint(AVertexList);
      if AVertexList.PointInside(AVertex) then
      begin
        // If it is, get rid of AnotherVertexList.
        AnotherVertexList.Free;
      end
      else
      begin
        // If it isn't, AVertexList must be inside
        // AnotherVertexList so get rid of AVertexList
        // and move AnotherVertexList to the beginning
        // of ListOfVertexLists where AVertexList
        // used to be.
        Items[0] := AnotherVertexList;
        AVertexList.Free;
        // update AVertexList
        AVertexList := AnotherVertexList;
      end;
      // Remove AnotherVertexList from its previous position.
      Delete(Index);
    end;
  end; // while ListOfVertexLists.Count > 1 do
  AVertexList := Items[0];
  repeat
    AllEliminated := True;
    for Index := AVertexList.Count - 2 downto 1 do
    begin
      AVertex := AVertexList[Index];
      for InnerIndex := Index - 1 downto 0 do
      begin
        AnotherVertex := AVertexList[InnerIndex];
        if (AVertex.X = AnotherVertex.X) and (AVertex.Y = AnotherVertex.Y) then
        begin
          for InnermostIndex := Index - 1 downto InnerIndex do
          begin
            AVertexList.Delete(InnermostIndex);
          end;
          AllEliminated := False;
        end;
        if not AllEliminated then
          break;
      end;
      if not AllEliminated then
        break;
    end;
  until AllEliminated;

end;

{ TSurfaceFunctionList }

destructor TSurfaceFunctionList.Destroy;
var
  Index: Integer;
begin
  for Index := FList.Count - 1 downto 0 do
  begin
    TGetSurfaceClass(FList[Index]).Free;
  end;
  inherited Destroy;
end;

function TSurfaceFunctionList.GetItems(const Index: integer): TGetSurface;
var
  AGetSurface: TGetSurfaceClass;
begin
  AGetSurface := FList.Items[Index];
  result := AGetSurface.Method;
end;

{ TFunctionList }

constructor TFunctionList.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TFunctionList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TFunctionList.GetCount: integer;
begin
  result := FList.Count;
end;

{ TPoint }

function TPoint.CopyPoint: TPoint;
begin
  Result := TPoint.Create(X, Y);
  result.FOnVerticalSide := FOnVerticalSide;
  result.FOnHorizontalSide := FOnHorizontalSide;
end;

constructor TPoint.Create(AnX, AY: Extended);
begin
  inherited Create;
  FZones := TList.Create;
  X := AnX;
  Y := AY;
  FOnVerticalSide := False;
  FOnHorizontalSide := False;
end;

destructor TPoint.Destroy;
begin
  FZones.Free;
  inherited Destroy;
end;

function TPoint.PointToString(OriginX, OriginY, GridAngle,
  PerturbationX, PerturbationY: double;
  RowDirectionPositive, ColumnDirectionPositive {, Perturb}: boolean): string;
var
  LocalX, LocalY: extended;
  SingleX, SingleY: extended;
begin
  RotateFromGrid(LocalX, LocalY, OriginX, OriginY, GridAngle,
    RowDirectionPositive, ColumnDirectionPositive);
  // Locations are in moved slightly to avoid a bug in Argus ONE which can't
  // handle verticies exactly in the centers of grid lines.
  if LocalX = 0 then
  begin
    SingleX := PerturbationX
  end
  else
  begin
    SingleX := LocalX + Abs(LocalX) * PerturbationX;
  end;
  if LocalY = 0 then
  begin
    SingleY := PerturbationY
  end
  else
  begin
    SingleY := LocalY + Abs(LocalY) * PerturbationY;
  end;

  result := InternationalFloatToStr(SingleX) + Chr(9) +
    InternationalFloatToStr(SingleY);
end;

procedure TPoint.RotateFromGrid(var LocalX, LocalY: extended; OriginX, OriginY,
  GridAngle: double; RowDirectionPositive, ColumnDirectionPositive: boolean);
var
  X1, Y1, PointDistance, PointAngle: double;
begin
  LocalX := X;
  LocalY := Y;
  if GridAngle <> 0 then
  begin
    X1 := X - OriginX;
    Y1 := Y - OriginY;
    if (X1 = 0) then
    begin
      PointDistance := Y1;
      PointAngle := Pi / 2;
      if not RowDirectionPositive then
      begin
        PointAngle := -PointAngle;
        PointDistance := -PointDistance;
      end;
    end
    else
    begin
      PointDistance := Sqrt(Sqr(X1) + Sqr(Y1));
      PointAngle := ArcTan(Y1 / X1);
      if X1 < 0 then
      begin
        PointAngle := PointAngle - Pi;
      end;
    end;
    // Rotate by Grid Angle
    PointAngle := PointAngle + GridAngle;
    if PointAngle < -Pi then
    begin
      PointAngle := PointAngle + 2 * Pi;
    end;
    // Convert rotated coordinates back to cartesian coordinates.
    X1 := PointDistance * Cos(PointAngle);
    Y1 := PointDistance * Sin(PointAngle);
    LocalX := X1 + OriginX;
    LocalY := Y1 + OriginY;
  end;
end;

procedure TPoint.SetX(const Value: Extended);
begin
  FX := Value;
end;

procedure TPoint.SetY(const Value: Extended);
begin
  FY := Value;
end;

constructor TContour2.Create;
begin
  inherited;
  Heading := TStringlist.Create;
  PointStrings := TStringList.Create;
  FPoints := TPointList.Create;
  ValueList := TList.Create;
  PointsReady := False;
  MakeHeader;
  Value := '';
end;

destructor TContour2.Destroy;
var
  Index: integer;
  PointIndex: integer;
  APoint: TPoint;
begin
  Heading.Free;
  PointStrings.Free;
  for Index := FPoints.Count - 1 downto 0 do
  begin
    APoint := FPoints[Index];
    if APoint <> nil then
    begin
      FPoints.Delete(Index);
      PointIndex := FPoints.IndexOf(APoint);
      if PointIndex > -1 then
      begin
        FPoints[PointIndex] := nil;
      end;
      APoint.Free;
    end;
  end;
  FPoints.Free;

  for Index := ValueList.Count - 1 downto 0 do
  begin
    TContourValue(ValueList[Index]).Free;
  end;
  ValueList.Free;

  inherited;

end;

function TContour2.PointInside(X, Y: extended): boolean;
var
  VertexIndex: integer;
  AVertex, AnotherVertex: TPoint;
begin // based on CACM 112
  result := true;
  for VertexIndex := 0 to FPoints.Count - 2 do
  begin
    AVertex := FPoints[VertexIndex];
    AnotherVertex := FPoints[VertexIndex + 1];
    if ((Y <= AVertex.FY) = (Y > AnotherVertex.FY)) and
      (X - AVertex.FX - (Y - AVertex.FY) *
      (AnotherVertex.FX - AVertex.FX) /
      (AnotherVertex.FY - AVertex.FY) < 0) then
    begin
      result := not result;
    end;
  end;
  result := not result;
end;

procedure TContour2.PointsToStrings(OriginX, OriginY, GridAngle,
  Perturbation: double; RowDirectionPositive, ColumnDirectionPositive: boolean);
var
  Index: integer;
  PointBefore, PointAfter, APoint: TPoint;
  PerturbationX, PerturbationY: double;
  X, Y: extended;
begin
  PointStrings.Clear;
  if PointStrings.Capacity < FPoints.Count + 1 then
  begin
    PointStrings.Capacity := FPoints.Count + 1;
  end;
  for Index := 0 to FPoints.Count - 1 do
  begin
    APoint := FPoints[Index];
    if FPoints.Count > 3 then
    begin
      if Index > 0 then
      begin
        PointBefore := FPoints[Index - 1]
      end
      else
      begin
        PointBefore := FPoints[FPoints.Count - 2]
      end;
      if Index < FPoints.Count - 1 then
      begin
        PointAfter := FPoints[Index + 1]
      end
      else
      begin
        PointAfter := FPoints[1]
      end;
      X := (PointBefore.FX + PointAfter.FX + APoint.FX) / 3;
      if X > APoint.FX then
      begin
        PerturbationX := Abs(Perturbation);
      end
      else
      begin
        PerturbationX := -Abs(Perturbation);
      end;
      Y := (PointBefore.FY + PointAfter.FY + APoint.FY) / 3;
      if Y > APoint.FY then
      begin
        PerturbationY := Abs(Perturbation);
      end
      else
      begin
        PerturbationY := -Abs(Perturbation);
      end;
      if not PointInside(X, Y) then
      begin
        PerturbationX := -PerturbationX;
        PerturbationY := -PerturbationY;
      end;
      PerturbationX := (EnclosingContours + 1) * PerturbationX;
      PerturbationY := (EnclosingContours + 1) * PerturbationY;
    end
    else
    begin
      PerturbationX := 0;
      PerturbationY := 0;
    end;
    if APoint.FOnVerticalSide then
    begin
      PerturbationY := 0;
    end;
    if APoint.FOnHorizontalSide then
    begin
      PerturbationX := 0;
    end;
    PointStrings.Add(APoint.PointToString(OriginX, OriginY,
      GridAngle, PerturbationX, PerturbationY, RowDirectionPositive,
      ColumnDirectionPositive
      {, Perturb}));
  end;
  PointStrings.Add('');

end;

constructor TEditContours.Create(AnOriginX, AnOriginY, AGridAngle: double);
begin
  inherited Create;
  ContourList := TList.Create;
  OriginX := AnOriginX;
  OriginY := AnOriginY;
  GridAngle := AGridAngle;
end;

destructor TEditContours.Destroy;
var
  Index: integer;
  AContour: TContour2;
begin
  for index := ContourList.Count - 1 downto 0 do
  begin
    AContour := ContourList.Items[index];
    AContour.Free;
  end;
  ContourList.Free;
  inherited Destroy;
end;

procedure TEditContours.WriteContours(Perturbation: double;
  RowDirectionPositive, ColumnDirectionPositive: boolean;
  ContourStringList: TStringList);
var
  AContourStringList: TStringList;
  Index, InnerIndex: integer;
  AContour, AnotherContour: TContour2;
  APoint, AnotherPoint: TPoint;
  PointIndex, AnotherPointIndex: integer;
  dupFound: boolean;
begin
  ArrangeContours;
  AContourStringList := TStringList.Create;
  try
    ContourStringList.Text := '';
    if ContourStringList.Capacity < ContourList.Count * 10 then
    begin
      ContourStringList.Capacity := ContourList.Count * 10;
    end;
    for index := 0 to ContourList.Count - 1 do
    begin
      AContour := ContourList.Items[index];
      AContour.EnclosingContours := 0;
      if AContour.FPoints.Count > 1 then
      begin
        for InnerIndex := 0 to ContourList.Count - 1 do
        begin
          if InnerIndex <> index then
          begin
            AnotherContour := ContourList[InnerIndex];
            APoint := nil;
            for PointIndex := 0 to AContour.FPoints.Count - 1 do
            begin
              APoint := AContour.FPoints[PointIndex];
              dupFound := False;
              for AnotherPointIndex := 0 to AnotherContour.FPoints.Count - 1 do
              begin
                AnotherPoint := AnotherContour.FPoints[AnotherPointIndex];
                if (AnotherPoint.FX = APoint.FX) and
                  (AnotherPoint.FY = APoint.FY) then
                begin
                  dupFound := True;
                  break;
                end;
              end;
              if not dupFound then
              begin
                break;
              end;
            end;

            if AnotherContour.PointInside(APoint.FX, APoint.FY) then
            begin
              Inc(AContour.EnclosingContours);
            end;
          end;

        end;
      end;

      AContour.WriteContour(OriginX, OriginY, GridAngle,
        Perturbation, RowDirectionPositive, ColumnDirectionPositive,
        AContourStringList);
      if ContourStringList.Capacity < ContourStringList.Count +
        AContourStringList.Count then
      begin
        ContourStringList.Capacity := ContourStringList.Count +
          AContourStringList.Count;
      end;
      for InnerIndex := 0 to AContourStringList.Count - 1 do
      begin
        ContourStringList.Add(AContourStringList[InnerIndex]);
      end;
    end;
    ContourStringList.Add('');
  finally
    AContourStringList.Free;
  end;
end;

function TPoint.ZoneCount: integer;
var
  Index: Integer;
begin
  for Index := FZones.Count - 1 downto 0 do
  begin
    if FZones.IndexOf(FZones[Index]) <> Index then
    begin
      FZones.Delete(Index);
    end;
  end;
  result := FZones.Count;
end;

procedure TContour2.MakeHeader;
begin
  Heading.Clear;
  Heading.Add('## Name:');
  Heading.Add('## Icon:0');
  Heading.Add('# Points Count' + Chr(9) + 'Value');
  Heading.Add('0');
  Heading.Add('# X pos' + Chr(9) + 'Y pos');

end;

procedure TEditContours.ArrangeContours;
var
  NewList: TList;
  AContour: TContour2;
  AnotherContour: TContour2;
  Index, InnerIndex: integer;
  {AVertex,}AnotherVertex: TPoint;
  Found: boolean;
begin
  if ContourList.Count > 0 then
  begin
    NewList := TList.Create;
    if NewList.Capacity < ContourList.Count then
    begin
      NewList.Capacity := ContourList.Count
    end;
    AContour := ContourList[0];
    NewList.Add(AContour);
    for Index := 1 to ContourList.Count - 1 do
    begin
      AnotherContour := ContourList[Index];
      if AnotherContour.FPoints.Count <= 1 then
      begin
        NewList.Add(AnotherContour);
        Continue;
      end;

      Found := False;
      for InnerIndex := 0 to NewList.Count - 1 do
      begin
        AContour := NewList[InnerIndex];
        if AContour.FPoints.Count <= 1 then
        begin
          Continue;
        end;

        AnotherVertex :=
          AnotherContour.FPoints.GetFirstUnsharedPoint(AContour.FPoints);
        if AContour.FPoints.PointInside(AnotherVertex) then
        begin
          NewList.Insert(InnerIndex, AnotherContour);
          Found := True;
          break;
        end
      end;
      if not Found then
      begin
        NewList.Add(AnotherContour);
      end;
    end;
    ContourList.Free;
    ContourList := NewList;
  end;

end;

{ TCustomBoundary }

constructor TCustomBoundary.Create(ACell: TCell; BoundaryIndex,
  AStressPeriod: integer);
begin
  inherited Create;
  Cell := ACell;
  Extracted := False;
  ACell.BoundaryList.Add(self);
  StressPeriod := AStressPeriod;
  AssignProperties(BoundaryIndex);
  UseBoundaryList := TList.Create;
end;

destructor TCustomBoundary.Destroy;
begin
  UseBoundaryList.Free;
  inherited
end;

{ TDrainBoundary }

procedure TDrainBoundary.AssignProperties(Index: integer);
begin
  Col := Round(frmModflowImport.GetDrain(Index, drnCol)) - 1;
  Row := Round(frmModflowImport.GetDrain(Index, drnRow)) - 1;
  Elevation := frmModflowImport.GetDrain(Index, drnElev);
  Cond := frmModflowImport.GetDrain(Index, drnCond);
  Layer := Round(frmModflowImport.GetDrain(Index, drnLay));

end;

function TDrainBoundary.SimilarBoundary(
  ACustomBoundary: TCustomBoundary): boolean;
var
  ABoundary: TDrainBoundary;
begin
  if ACustomBoundary is TDrainBoundary then
  begin
    ABoundary := ACustomBoundary as TDrainBoundary;
    result := (ABoundary.Elevation = Elevation)
      and (ABoundary.Layer = Layer)
      and (ABoundary.Cond = Cond);
  end
  else
  begin
    result := false;
  end;
end;

{ TGHBBoundary }

procedure TGHBBoundary.AssignProperties(Index: integer);
begin
  Col := Round(frmModflowImport.GetGHB(Index, ghbCol)) - 1;
  Row := Round(frmModflowImport.GetGHB(Index, ghbRow)) - 1;
  BoundaryHead := frmModflowImport.GetGHB(Index, ghbElev);
  Cond := frmModflowImport.GetGHB(Index, ghbCond);
  Layer := Round(frmModflowImport.GetGHB(Index, ghbLay));
end;

function TGHBBoundary.SimilarBoundary(
  ACustomBoundary: TCustomBoundary): boolean;
var
  ABoundary: TGHBBoundary;
begin
  if ACustomBoundary is TGHBBoundary then
  begin
    ABoundary := ACustomBoundary as TGHBBoundary;
    result := (ABoundary.Layer = Layer) and (ABoundary.Cond = Cond);
  end
  else
  begin
    result := false;
  end;
end;

{ THorizontalFlowBoundary }

procedure THorizontalFlowBoundary.AssignProperties(Index: integer);
begin
  Col := Round(frmModflowImport.GetHFBR(Index, hfbCol1)) - 1;
  Row := Round(frmModflowImport.GetHFBR(Index, hfbRow1)) - 1;
  Col2 := Round(frmModflowImport.GetHFBR(Index, hfbCol2)) - 1;
  Row2 := Round(frmModflowImport.GetHFBR(Index, hfbRow2)) - 1;
  HydChr := frmModflowImport.GetHFBR(Index, hfbHYDCHR);
  Layer := Round(frmModflowImport.GetHFBR(Index, hfbLay));
end;

function THorizontalFlowBoundary.SimilarBoundary(
  ACustomBoundary: TCustomBoundary): boolean;
var
  ABoundary: THorizontalFlowBoundary;
begin
  if ACustomBoundary is THorizontalFlowBoundary then
  begin
    ABoundary := ACustomBoundary as THorizontalFlowBoundary;
    result := (ABoundary.HydChr = HydChr) and (ABoundary.Layer = Layer);
    if result then
    begin
      if (Abs(ABoundary.Col - Col) = 1)
        and (Abs(ABoundary.Col2 - Col2) = 1) then
      begin
        if (ABoundary.Row = Row) and (ABoundary.Row2 = Row2) then
        begin
          result := True;
        end
        else
        begin
          result := False;
        end; // if (ABoundary.Row1 = Row1) and (ABoundary.Row2 = Row2) then
      end
      else if (Abs(ABoundary.Row - Row) = 1)
        and (Abs(ABoundary.Row2 - Row2) = 1) then
      begin
        if (ABoundary.Col = Col) and (ABoundary.Col2 = Col2) then
        begin
          result := True;
        end
        else
        begin
          result := False;
        end; // if (ABoundary.Col1 = Col1) and (ABoundary.Col2 = Col2) then
      end
      else // if (Abs(ABoundary.Row1 - Row1) = 1)
        //   and (Abs(ABoundary.Row2 - Row2) = 1) then
      begin
        result := False;
      end; // if (Abs(ABoundary.Row1 - Row1) = 1)
      //   and (Abs(ABoundary.Row2 - Row2) = 1) then else

    end; // if result then
  end
  else // if ACustomBoundary is THorizontalFlowBoundary then
  begin
    result := false;
  end; // if ACustomBoundary is THorizontalFlowBoundary then else
end;

{ TRiverBoundary }

procedure TRiverBoundary.AssignProperties(Index: integer);
begin

  Col := Round(frmModflowImport.GetRIVR(Index, rivCol)) - 1;
  Row := Round(frmModflowImport.GetRIVR(Index, rivRow)) - 1;
  Stage := frmModflowImport.GetRIVR(Index, rivStage);
  Cond := frmModflowImport.GetRIVR(Index, rivCond);
  RBot := frmModflowImport.GetRIVR(Index, rivRbot);
  Layer := Round(frmModflowImport.GetRIVR(Index, rivLay));
end;

function TRiverBoundary.SimilarBoundary(
  ACustomBoundary: TCustomBoundary): boolean;
var
  ABoundary: TRiverBoundary;
begin
  if ACustomBoundary is TRiverBoundary then
  begin
    ABoundary := ACustomBoundary as TRiverBoundary;
    result := (ABoundary.Cond = Cond) {and (ABoundary.Stage = Stage)}
    and (ABoundary.RBot = RBot)
      and (ABoundary.Layer = Layer);
  end
  else
  begin
    result := false;
  end;
end;

{ TStreamBoundary }

procedure TStreamBoundary.AssignProperties(Index: integer);
var
  TribIndex: integer;
begin
  Col := Round(frmModflowImport.GetICSTRM(Index, strCol)) - 1;
  Row := Round(frmModflowImport.GetICSTRM(Index, strRow)) - 1;
  Segment := Round(frmModflowImport.GetICSTRM(Index, strSeg)) - 1;
  Reach := Round(frmModflowImport.GetICSTRM(Index, strReach)) - 1;
  Layer := Round(frmModflowImport.GetICSTRM(Index, strLay));

  Flow := frmModflowImport.GetSTRM(Index, strInfl);
  Stage := frmModflowImport.GetSTRM(Index, strStage);
  Cond := frmModflowImport.GetSTRM(Index, strCond);
  SBot := frmModflowImport.GetSTRM(Index, strBot);
  STop := frmModflowImport.GetSTRM(Index, strTop);
  if frmModflowImport.CalculateStreamStage then
  begin
    Width := frmModflowImport.GetSTRM(Index, strWidth);
    Slope := frmModflowImport.GetSTRM(Index, strSlope);
    Rough := frmModflowImport.GetSTRM(Index, strRough);
  end;

  if frmModflowImport.UseStreamTributaries then
  begin
    for TribIndex := 0 to frmModflowImport.NumStreamTributaries - 1 do
    begin
      Trib[TribIndex] := Round(frmModflowImport.GetITRBAR(Segment, TribIndex));
    end;
  end;
  if frmModflowImport.UseStreamDiversions then
  begin
    IupSeg := Round(frmModflowImport.GetIDIVAR(Segment));
  end;
end;

function TStreamBoundary.SimilarBoundary(
  ACustomBoundary: TCustomBoundary): boolean;
var
  ABoundary: TStreamBoundary;
begin
  if ACustomBoundary is TStreamBoundary then
  begin
    ABoundary := ACustomBoundary as TStreamBoundary;
    result := (ABoundary.Segment = Segment)
      and (ABoundary.Layer = Layer);
  end
  else
  begin
    result := false;
  end;
end;

{ TWell }

procedure TWellBoundary.AssignProperties(Index: integer);
begin
  Q := frmModflowImport.GetWELL(Index, welStress);
  Layer := Round(frmModflowImport.GetWELL(Index, welLay));
  Col := Round(frmModflowImport.GetWELL(Index, welCol)) - 1;
  Row := Round(frmModflowImport.GetWELL(Index, welRow)) - 1;
end;

function TWellBoundary.SimilarBoundary(ACustomBoundary: TCustomBoundary):
  boolean;
begin
  if (ACustomBoundary is TWellBoundary) and (Self.Layer = ACustomBoundary.Layer)
    then
  begin
    result := True;
  end
  else
  begin
    result := false;
  end;
end;

{ TFHBFlowBoundary }

procedure TFHBFlowBoundary.AssignProperties(Index: integer);
var
  FlowIndex: integer;
begin
  Col := Round(frmModflowImport.GetFlowLoc(Index, fhbCol)) - 1;
  Row := Round(frmModflowImport.GetFlowLoc(Index, fhbRow)) - 1;
  Layer := Round(frmModflowImport.GetFlowLoc(Index, fhbLay));
  IAUX := Round(frmModflowImport.GetFlowLoc(Index, fhbAux));
  NumberOfTimes := frmModflowImport.NumberOfFHBTimes;
  SetLength(FLWRAT, NumberOfTimes);
  for FlowIndex := 0 to frmModflowImport.NumberOfFHBTimes - 1 do
  begin
    FLWRAT[FlowIndex] := frmModflowImport.GetFLWRAT(Index, FlowIndex);
  end;
end;

function TFHBFlowBoundary.SimilarBoundary(
  ACustomBoundary: TCustomBoundary): boolean;
var
  ABoundary: TFHBFlowBoundary;
begin
  if ACustomBoundary is TFHBFlowBoundary then
  begin
    ABoundary := ACustomBoundary as TFHBFlowBoundary;
    result := (ABoundary.FLWRAT = FLWRAT)
      and (ABoundary.Layer = Layer);
  end
  else
  begin
    result := false;
  end;
end;

{ TFHBHeadBoundary }

procedure TFHBHeadBoundary.AssignProperties(Index: integer);
var
  HeadIndex: integer;
begin
  Col := Round(frmModflowImport.GetHeadLoc(Index, fhbCol)) - 1;
  Row := Round(frmModflowImport.GetHeadLoc(Index, fhbRow)) - 1;
  Layer := Round(frmModflowImport.GetHeadLoc(Index, fhbLay));
  IAUX := Round(frmModflowImport.GetHeadLoc(Index, fhbAux));
  NumberOfTimes := frmModflowImport.NumberOfFHBTimes;
  SetLength(SBHED, NumberOfTimes);
  for HeadIndex := 0 to frmModflowImport.NumberOfFHBTimes - 1 do
  begin
    SBHED[HeadIndex] := frmModflowImport.GetSBHED(Index, HeadIndex);
  end;

end;

function TFHBHeadBoundary.SimilarBoundary(
  ACustomBoundary: TCustomBoundary): boolean;
var
  ABoundary: TFHBHeadBoundary;
begin
  if ACustomBoundary is TFHBHeadBoundary then
  begin
    ABoundary := ACustomBoundary as TFHBHeadBoundary;
    result := (ABoundary.SBHED = SBHED)
      and (ABoundary.Layer = Layer);
  end
  else
  begin
    result := false;
  end;
end;

{ TBoundaryList }

function TBoundaryList.Add(Item: TCustomBoundary): Integer;
begin
  result := FList.Add(Item);
end;

constructor TBoundaryList.Create;
begin
  inherited;
  FList := TList.Create;
end;

destructor TBoundaryList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TBoundaryList.GetBoundaries(Index: integer): TCustomBoundary;
begin
  result := FList[Index];
end;

function TBoundaryList.GetCount: integer;
begin
  result := FList.Count;
end;

function TBoundaryList.IndexOf(ABoundary: TCustomBoundary): integer;
begin
  result := FList.IndexOf(ABoundary);
end;

{ TContour2 }

procedure TContour2.WriteContour(OriginX, OriginY, GridAngle,
  Perturbation: double; RowDirectionPositive, ColumnDirectionPositive: boolean;
  ContourStringList: TStringList);
var
  Index: Integer;
  AValue: TContourValue;
begin
  PointsToStrings(OriginX, OriginY, GridAngle, Perturbation,
    RowDirectionPositive, ColumnDirectionPositive);

  Assert(((Value = '') and (ValueList.Count > 0)) or
    ((Value <> '') and (ValueList.Count = 0)));
  Heading[3] := IntToStr(FPoints.Count);
  if Value <> '' then
  begin
    Heading[3] := Heading[3] + Char(9) + Value;
  end;
  for Index := 0 to ValueList.Count - 1 do
  begin
    AValue := ValueList[Index];
    Heading[3] := Heading[3] + Chr(9) + AValue.WriteValue;
  end;

  ContourStringList.Text := (Heading.Text + PointStrings.Text);

end;

procedure TContour2.FixValue(const aneHandle: ANE_PTR);
var
  Delimiter: Char;
  Project: TProjectOptions;
  TabPos: integer;
  TempValue, AValue: string;
  ValueList: TStringList;
  ValueIndex: integer;
  V: double;
  E: integer;
begin
  // This procedure has been copied from PointContourUnit
  // Find out what Argus ONE is using to separate the individual values.
  Project := TProjectOptions.Create;
  try
    Delimiter := Project.ExportDelimiter[aneHandle];
  finally
    Project.Free;
  end;

  // Extract each parameter value and place it in ValueList
  TempValue := Value;
  ValueList := TStringList.Create;
  try
    TabPos := Pos(Delimiter, TempValue);
    while TabPos > 0 do
    begin
      AValue := Copy(TempValue, 1, TabPos -1);
      TempValue := Copy(TempValue, TabPos+1, MAXINT);
      ValueList.Add(AValue);
      TabPos := Pos(Delimiter, TempValue);
    end;
    if TempValue <> '' then
    begin
      ValueList.Add(TempValue);
    end;

    // put the updated paramter values in Value.
    TempValue := '';
    for ValueIndex := 0 to ValueList.Count -1 do
    begin
      AValue := ValueList[ValueIndex];
      // put string paramter values in quotes.
      if (Length(AValue) > 0) and (AValue[1] <> '"') then
      begin
        if (AValue <> 'True') and (AValue <> 'False') then
        begin
          Val(AValue, V, E);
          if E <> 0 then
          begin
            AValue := '"' + AValue + '"';
          end;
        end;
      end
      else
      begin
        if Length(AValue) = 0 then
        begin
          AValue := '""';
        end;
      end;
      // Use of #9 rather than Delimiter is correct.
      TempValue := TempValue + #9 + AValue;
    end;
    // delete the #9 at the beginning of TempValue.
    Delete(TempValue, 1, 1);
    Value := TempValue;
  finally
    ValueList.Free;
  end;
end;

{ TContourValue }

function TContourValue.WriteValue: string;
begin
  result := '$N/A';
end;

{ TRealValue }

function TRealValue.WriteValue: string;
begin
  result := InternationalFloatToStr(Value);
end;

{ TUse3DFunctionList }

procedure TUse3DFunctionList.Add(A3DFunction: TUse3dValue);
var
  AUse3DFunctionValue: TUse3DValueClass;
begin
  AUse3DFunctionValue := TUse3DValueClass.Create;
  AUse3DFunctionValue.Method := A3DFunction;
  FList.Add(AUse3DFunctionValue);
end;

destructor TUse3DFunctionList.Destroy;
var
  Index: Integer;
begin
  for Index := FList.Count - 1 downto 0 do
  begin
    TUse3dValueClass(FList[Index]).Free;
  end;
  inherited Destroy;
end;

function TUse3DFunctionList.GetItems(const Index: integer): TUse3dValue;
var
  AUse3dValue: TUse3dValueClass;
begin
  AUse3dValue := FList.Items[Index];
  result := AUse3dValue.Method;
end;

{ TPeriodInfo }

function TPeriodInfo.PERLEN: double;
begin
  if TSMULT = 1 then
  begin
    result := DELT * NSTP;
  end
  else
  begin
    result := DELT * (1 - Power(TSMULT, NSTP)) / (1 - TSMULT);
  end;
end;

procedure TContour2.AddCopyOfPoint(APoint: TPoint);
begin
  FPoints.Add(APoint.CopyPoint);
end;

{ TMF2K_WellBoundary }

procedure TMF2K_WellBoundary.AssignProperties(Index: integer);
var
  L, R, C: longint;
  QLocal: single;
  IIndex: longint;
begin
  IIndex := Index;
  GetWell(L, R, C, QLocal, IIndex);
  Layer := L;
  Row := R;
  Col := C;
  Q := QLocal;
end;

constructor TMF2K_WellBoundary.Create(ACell: TCell; BoundaryIndex,
  AStressPeriod: integer; ParamName: string);
begin
  inherited Create(ACell, BoundaryIndex, AStressPeriod);
  ParameterName := ParamName;
end;

function TMF2K_WellBoundary.SimilarBoundary(
  ACustomBoundary: TCustomBoundary): boolean;
begin
  if (ACustomBoundary is TMF2K_WellBoundary)
    and (Self.Layer = ACustomBoundary.Layer)
    and (Self.ParameterName = TMF2K_WellBoundary(ACustomBoundary).ParameterName)
    then
  begin
    result := True;
  end
  else
  begin
    result := false;
  end;
end;

{ TMF2KDrainBoundary }

procedure TMF2KDrainBoundary.AssignProperties(Index: integer);
var
  L, R, C: longint;
  Elev, Conductance: single;
  IIndex: longint;
begin
  IIndex := Index;
  GetDrain(L, R, C, Elev, Conductance, IIndex);
  Layer := L;
  Row := R;
  Col := C;
  Elevation := Elev;
  Cond := Conductance;
end;

constructor TMF2KDrainBoundary.Create(ACell: TCell; BoundaryIndex,
  AStressPeriod: integer; ParamName: string);
begin
  inherited Create(ACell, BoundaryIndex, AStressPeriod);
  ParameterName := ParamName;
end;

function TMF2KDrainBoundary.SimilarBoundary(
  ACustomBoundary: TCustomBoundary): boolean;
var
  ABoundary: TMF2KDrainBoundary;
begin
  if ACustomBoundary is TMF2KDrainBoundary then
  begin
    ABoundary := ACustomBoundary as TMF2KDrainBoundary;
    result := (ABoundary.Elevation = Elevation)
      and (ABoundary.Layer = Layer)
      and (ABoundary.Cond = Cond)
      and (ABoundary.ParameterName = ParameterName);
  end
  else
  begin
    result := false;
  end;
end;

{ TMF2K_GHBBoundary }

procedure TMF2K_GHBBoundary.AssignProperties(Index: integer);
var
  L, R, C: longint;
  Elev, Conductance: single;
  IIndex: longint;
begin
  IIndex := Index;
  GetGHB(L, R, C, Elev, Conductance, IIndex);
  Layer := L;
  Row := R;
  Col := C;
  BoundaryHead := Elev;
  Cond := Conductance;
end;

constructor TMF2K_GHBBoundary.Create(ACell: TCell; BoundaryIndex,
  AStressPeriod: integer; ParamName: string);
begin
  inherited Create(ACell, BoundaryIndex, AStressPeriod);
  ParameterName := ParamName;
end;

function TMF2K_GHBBoundary.SimilarBoundary(
  ACustomBoundary: TCustomBoundary): boolean;
var
  ABoundary: TMF2K_GHBBoundary;
begin
  if ACustomBoundary is TMF2K_GHBBoundary then
  begin
    ABoundary := ACustomBoundary as TMF2K_GHBBoundary;
    result := (ABoundary.Layer = Layer)
      and (ABoundary.Cond = Cond)
      and (ABoundary.ParameterName = ParameterName);
  end
  else
  begin
    result := false;
  end;
end;

{ TMF2K_RiverBoundary }

procedure TMF2K_RiverBoundary.AssignProperties(Index: integer);
var
  L, R, C: longint;
  Elev, Conductance, Bottom: single;
  IIndex: longint;
begin
  IIndex := Index;
  GetRiver(L, R, C, Elev, Conductance, Bottom, IIndex);
  Layer := L;
  Row := R;
  Col := C;
  RBot := Bottom;
  Stage := Elev;
  Cond := Conductance;
end;

constructor TMF2K_RiverBoundary.Create(ACell: TCell; BoundaryIndex,
  AStressPeriod: integer; ParamName: string);
begin
  inherited Create(ACell, BoundaryIndex, AStressPeriod);
  ParameterName := ParamName;
end;

function TMF2K_RiverBoundary.SimilarBoundary(
  ACustomBoundary: TCustomBoundary): boolean;
var
  ABoundary: TMF2K_RiverBoundary;
begin
  if ACustomBoundary is TMF2K_RiverBoundary then
  begin
    ABoundary := ACustomBoundary as TMF2K_RiverBoundary;
    result := (ABoundary.Cond = Cond)
      and (ABoundary.RBot = RBot)
      and (ABoundary.ParameterName = ParameterName)
      and (ABoundary.Layer = Layer);
  end
  else
  begin
    result := false;
  end;
end;

{ TCellStack }

constructor TCellStack.Create;
begin
  Capacity := 100;
end;

function TCellStack.Pop: TCellLocation;
begin
  Assert(FCount > 0);
  result := FValues[FCount -1];
  Dec(FCount);
end;

procedure TCellStack.Push(const Location: TCellLocation);
begin
  if FCount = Capacity then
  begin
    Capacity := Capacity*2;
  end;
  FValues[FCount] := Location;
  Inc(FCount);
end;

procedure TCellStack.SetCapacity(const Value: integer);
begin
  if FCapacity <> Value then
  begin
    FCapacity := Value;
    SetLength(FValues, Value);
  end;
end;

{ TReverseList }
{
function TReverseList.IndexOf(Item: Pointer): Integer;
var
  Index: integer;
begin
  result := -1;
  for Index := Count -1 downto 0 do
  begin
    if Items[Index] = Item then
    begin
      result := Index;
      Exit;
    end;
  end;
end;   }

{ TMF2K_CHD_Boundary }

procedure TMF2K_CHD_Boundary.AssignProperties(Index: integer);
var
  L, R, C: longint;
  StartH, EndH: single;
  IIndex: longint;
begin
  IIndex := Index;
  GetCHD(L, R, C, StartH, EndH, IIndex);
  Layer := L;
  Row := R;
  Col := C;
  StartingHead := StartH;
  EndingHead := EndH;
end;

constructor TMF2K_CHD_Boundary.Create(ACell: TCell; BoundaryIndex,
  AStressPeriod: integer; ParamName: string);
begin
  inherited Create(ACell, BoundaryIndex, AStressPeriod);
  ParameterName := ParamName;
end;

function TMF2K_CHD_Boundary.SimilarBoundary(
  ACustomBoundary: TCustomBoundary): boolean;
var
  ABoundary: TMF2K_CHD_Boundary;
begin
  if ACustomBoundary is TMF2K_CHD_Boundary then
  begin
    ABoundary := ACustomBoundary as TMF2K_CHD_Boundary;
    result := {(ABoundary.StartingHead = StartingHead)
      and (ABoundary.EndingHead = EndingHead)
      and} (ABoundary.ParameterName = ParameterName)
      and (ABoundary.Layer = Layer);
  end
  else
  begin
    result := false;
  end;
end;

end.

