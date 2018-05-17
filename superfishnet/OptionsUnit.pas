unit OptionsUnit;

interface

uses AnePIE, sysutils;

type
  EArgusPropertyError = Class(Exception);

  TProjectOptions = Class(TObject)
  private
    function GetAGGInactive: boolean;
    function GetAllowRotatedGrid: boolean;
    function GetArcSpliceAngle: double;
    function GetC2CDistanceAffectDensity: boolean;
    function GetC2CThreshold: integer;
    function GetC2WDistanceAffectDensity: boolean;
    function GetC2WThreshold: integer;
    function GetChangeLayerLock: boolean;
    function GetCopyDelimiter: char;
    function GetCopyIcon: boolean;
    function GetCopyName: boolean;
    function GetCopyParameters: boolean;
    function GetDensityGrowthRate: integer;
    function GetElemLinePrefix: char;
    function GetEnhancedCleanup: boolean;
    function GetExportDelimiter: char;
    function GetExportParameters: boolean;
    function GetExportSelectionOnly: boolean;
    function GetExportSeparator: char;
    function GetExportTitles: boolean;
    function GetExportWrap: integer;
    function GetIncludeDiagonal: boolean;
    function GetMaxAngle: double;
    function GetMaxEdgeGrowth: integer;
    function GetMeshWithWells: boolean;
    function GetMinAngle: double;
    function GetNodeLinePrefix: char;
    function GetNumSmoothIterations: integer;
    function GetQuadriClear: boolean;
    function GetRemovePoints: boolean;
    function GetSmallSegmentAffectDensity: boolean;
    function GetW2WDistanceAffectDensity: boolean;
    function GetW2WThreshold: integer;
    procedure SetAGGInactive(const Value: boolean);
    procedure SetAllowRotatedGrid(const Value: boolean);
    procedure SetArcSpliceAngle(const Value: double);
    procedure SetC2CDistanceAffectDensity(const Value: boolean);
    procedure SetC2CThreshold(const Value: integer);
    procedure SetC2WDistanceAffectDensity(const Value: boolean);
    procedure SetC2WThreshold(const Value: integer);
    procedure SetChangeLayerLock(const Value: boolean);
    procedure SetCopyDelimiter(const Value: char);
    procedure SetCopyIcon(const Value: boolean);
    procedure SetCopyName(const Value: boolean);
    procedure SetCopyParameters(const Value: boolean);
    procedure SetDensityGrowthRate(const Value: integer);
    procedure SetElemLinePrefix(const Value: char);
    procedure SetEnhancedCleanup(const Value: boolean);
    procedure SetExportDelimiter(const Value: char);
    procedure SetExportParameters(const Value: boolean);
    procedure SetExportSelectionOnly(const Value: boolean);
    procedure SetExportSeparator(const Value: char);
    procedure SetExportTitles(const Value: boolean);
    procedure SetExportWrap(const Value: integer);
    procedure SetIncludeDiagonal(const Value: boolean);
    procedure SetMaxAngle(const Value: double);
    procedure SetMaxEdgeGrowth(const Value: integer);
    procedure SetMeshWithWells(const Value: boolean);
    procedure SetMinAngle(const Value: double);
    procedure SetNodeLinePrefix(const Value: char);
    procedure SetNumSmoothIterations(const Value: integer);
    procedure SetQuadriClear(const Value: boolean);
    procedure SetRemovePoints(const Value: boolean);
    procedure SetSmallSegmentAffectDensity(const Value: boolean);
    procedure SetW2WDistanceAffectDensity(const Value: boolean);
    procedure SetW2WThreshold(const Value: integer);
  public
    ArgusHandle  : ANE_PTR;
    Constructor Create (aneHandle : ANE_PTR);
  published
    property MinAngle			: double read GetMinAngle write SetMinAngle;	// the document's preference	for min element angle
    property MaxAngle			: double read GetMaxAngle write SetMaxAngle;	// the document's preference	for max element angle
    property ExportDelimiter		: char read GetExportDelimiter write SetExportDelimiter;		// the document's preference	for the delimiter at contour export
    property ExportSelectionOnly       	: boolean read GetExportSelectionOnly write SetExportSelectionOnly;	// the document's preference	to export selection only
    property ExportTitles	       	: boolean read GetExportTitles write SetExportTitles;	// the document's preference	to export titles
    property ExportParameters		: boolean read GetExportParameters write SetExportParameters;	// the document's preference	to export parameters
    property ExportWrap			: integer read GetExportWrap write SetExportWrap;	// the document's preference	for wrap value for export
    property ExportSeparator		: char read GetExportSeparator write SetExportSeparator;		// the document's preference	for separator used at export
    property ElemLinePrefix		: char read GetElemLinePrefix write SetElemLinePrefix;		// the document's preference	for export element line prefix
    property NodeLinePrefix		: char read GetNodeLinePrefix write SetNodeLinePrefix;		// the document's preference	for export node line prefix
    property CopyDelimiter	       	: char read GetCopyDelimiter write SetCopyDelimiter;		// the document's preference	for the delimiter at contour copy
    property CopyName			: boolean read GetCopyName write SetCopyName;	// the document's preference	for copying contour name
    property CopyParameters		: boolean read GetCopyParameters write SetCopyParameters;	// the document's preference	for copying contour parameters
    property CopyIcon			: boolean read GetCopyIcon write SetCopyIcon;	// the document's preference	for copying contour icon
    property IncludeDiagonal		: boolean read GetIncludeDiagonal write SetIncludeDiagonal;	// the document's preference	for includeing diagonal in BW calculation
    property ChangeLayerLock		: boolean read GetChangeLayerLock write SetChangeLayerLock;	// the document's preference	for letting change layer locks
    property ArcSpliceAngle		: double read GetArcSpliceAngle write SetArcSpliceAngle;	// the document's preference	for splice angle when copying arcs
    property MeshWithWells	       	: boolean read GetMeshWithWells write SetMeshWithWells;	// the document's preference	for considering point objects while meshing
    property SmallSegmentAffectDensity	: boolean read GetSmallSegmentAffectDensity write SetSmallSegmentAffectDensity;	// the document's preference	for meshing option
    property NumSmoothIterations       	: integer read GetNumSmoothIterations write SetNumSmoothIterations;	// the document's preference	for smooth operations after meshing
    property MaxEdgeGrowth	       	: integer read GetMaxEdgeGrowth write SetMaxEdgeGrowth;	// the document's preference	for edge growth at meshing.
    property DensityGrowthRate		: integer read GetDensityGrowthRate write SetDensityGrowthRate;	// the document's preference	for density growth rate at meshing
    property C2CDistanceAffectDensity	: boolean read GetC2CDistanceAffectDensity write SetC2CDistanceAffectDensity;	// the document's preference	for contour-contour affect density during meshing
    property C2CThreshold	       	: integer read GetC2CThreshold write SetC2CThreshold;	// the document's preference	for value of contour-contour effect
    property C2WDistanceAffectDensity	: boolean read GetC2WDistanceAffectDensity write SetC2WDistanceAffectDensity;	// the document's preference	for contour-well affect density during meshing
    property C2WThreshold	       	: integer read GetC2WThreshold write SetC2WThreshold;	// the document's preference	for value of contour-well effect
    property W2WDistanceAffectDensity	: boolean read GetW2WDistanceAffectDensity write SetW2WDistanceAffectDensity;	// the document's preference	for well-well affect density during meshing
    property W2WThreshold	       	: integer read GetW2WThreshold write SetW2WThreshold;	// the document's preference	for value of well-well effect
    property RemovePoints	       	: boolean read GetRemovePoints write SetRemovePoints;	// the document's preference	for removing vertices on streight lines during meshing
    property EnhancedCleanup		: boolean read GetEnhancedCleanup write SetEnhancedCleanup;	// the document's preference	for enhanced cleanup after quadri. meshing
    property QuadriClear	       	: boolean read GetQuadriClear write SetQuadriClear;	// the document's preference	for clearing tri. after quadri. meshing
    property AGGInactive	       	: boolean read GetAGGInactive write SetAGGInactive;	// the document's preference	for block incativing after gridding
    property AllowRotatedGrid		: boolean read GetAllowRotatedGrid write SetAllowRotatedGrid;	// the document's preference	to allow rotated grid at gridding
end;

implementation

uses ANECB;

ResourceString
  kMinAngle                    = 'MinAngle';
  kMaxAngle                    = 'MaxAngle';
  kExportDelimiter             = 'ExportDelimiter';
  kExportSelectionOnly         = 'ExportSelectionOnly';
  kExportTitles                = 'ExportTitles';
  kExportParameters            = 'ExportParameters';
  kExportWrap                  = 'ExportWrap';
  kExportSeparator             = 'ExportSeparator';
  kElemLinePrefix              = 'ElemLinePrefix';
  kNodeLinePrefix              = 'NodeLinePrefix';
  kCopyDelimiter               = 'CopyDelimiter';
  kCopyName                    = 'CopyName';
  kCopyParameters              = 'CopyParameters';
  kCopyIcon                    = 'CopyIcon';
  kIncludeDiagonal             = 'IncludeDiagonal';
  kChangeLayerLock             = 'ChangeLayerLock';
  kArcSpliceAngle              = 'ArcSpliceAngle';
  kMeshWithWells               = 'MeshWithWells';
  kSmallSegmentAffectDensity   = 'SmallSegmentAffectDensity';
  kNumSmoothIterations         = 'NumSmoothIterations';
  kMaxEdgeGrowth               = 'MaxEdgeGrowth';
  kDensityGrowthRate           = 'DensityGrowthRate';
  kC2CDistanceAffectDensity    = 'C2CDistanceAffectDensity';
  kC2CThreshold                = 'C2CThreshold';
  kC2WDistanceAffectDensity    = 'C2WDistanceAffectDensity';
  kC2WThreshold                = 'C2WThreshold';
  kW2WDistanceAffectDensity    = 'W2WDistanceAffectDensity';
  kW2WThreshold                = 'W2WThreshold';
  kRemovePoints		       = 'RemovePoints';
  kEnhancedCleanup             = 'EnhancedCleanup';
  kQuadriClear		       = 'QuadriClear';
  kAGGInactive                 = 'AGGInactive';
  kAllowRotatedGrid            = 'AllowRotatedGrid';


{ TProjectOptions }

constructor TProjectOptions.Create(aneHandle: ANE_PTR);
begin
  inherited Create;
  ArgusHandle := aneHandle;
end;

function TProjectOptions.GetAGGInactive: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kAGGInactive) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kAGGInactive);
  end;
end;

function TProjectOptions.GetAllowRotatedGrid: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kAllowRotatedGrid) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kAllowRotatedGrid);
  end;
end;

function TProjectOptions.GetArcSpliceAngle: double;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kArcSpliceAngle) , kPIEFloat, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kArcSpliceAngle);
  end;
end;

function TProjectOptions.GetC2CDistanceAffectDensity: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kC2CDistanceAffectDensity) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kC2CDistanceAffectDensity);
  end;
end;

function TProjectOptions.GetC2CThreshold: integer;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kC2CThreshold) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kC2CThreshold);
  end;
end;

function TProjectOptions.GetC2WDistanceAffectDensity: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kC2WDistanceAffectDensity) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kC2WDistanceAffectDensity);
  end;
end;

function TProjectOptions.GetC2WThreshold: integer;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kC2WThreshold) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kC2WThreshold);
  end;
end;

function TProjectOptions.GetChangeLayerLock: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kChangeLayerLock) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kChangeLayerLock);
  end;
end;

function TProjectOptions.GetCopyDelimiter: char;
Var
  AneResult : ANE_STR;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kCopyDelimiter) , kPIEString, AneResult) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCopyDelimiter);
  end;
  result := String(AneResult)[1];
end;

function TProjectOptions.GetCopyIcon: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kCopyIcon) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCopyIcon);
  end;
end;

function TProjectOptions.GetCopyName: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kCopyName) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCopyName);
  end;
end;

function TProjectOptions.GetCopyParameters: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kCopyParameters) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCopyParameters);
  end;
end;

function TProjectOptions.GetDensityGrowthRate: integer;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kDensityGrowthRate) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kDensityGrowthRate);
  end;
end;

function TProjectOptions.GetElemLinePrefix: char;
Var
  AneResult : ANE_STR;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kElemLinePrefix) , kPIEString, AneResult) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kElemLinePrefix);
  end;
  result := String(AneResult)[1];
end;

function TProjectOptions.GetEnhancedCleanup: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kEnhancedCleanup) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kEnhancedCleanup);
  end;
end;

function TProjectOptions.GetExportDelimiter: char;
Var
  AneResult : ANE_STR;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kExportDelimiter) , kPIEString, AneResult) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportDelimiter);
  end;
  result := String(AneResult)[1];
end;

function TProjectOptions.GetExportParameters: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kExportParameters) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportParameters);
  end;
end;

function TProjectOptions.GetExportSelectionOnly: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kExportSelectionOnly) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportSelectionOnly);
  end;
end;

function TProjectOptions.GetExportSeparator: char;
Var
  AneResult : ANE_STR;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kExportSeparator) , kPIEString, AneResult) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportSeparator);
  end;
  result := String(AneResult)[1];
end;

function TProjectOptions.GetExportTitles: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kExportTitles) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportTitles);
  end;
end;

function TProjectOptions.GetExportWrap: integer;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kExportWrap) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportWrap);
  end;
end;

function TProjectOptions.GetIncludeDiagonal: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kIncludeDiagonal) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kIncludeDiagonal);
  end;
end;

function TProjectOptions.GetMaxAngle: double;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kMaxAngle) , kPIEFloat, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kMaxAngle);
  end;
end;

function TProjectOptions.GetMaxEdgeGrowth: integer;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kMaxEdgeGrowth) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kMaxEdgeGrowth);
  end;
end;

function TProjectOptions.GetMeshWithWells: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kMeshWithWells) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kMeshWithWells);
  end;
end;

function TProjectOptions.GetMinAngle: double;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kMinAngle) , kPIEFloat, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kMinAngle);
  end;
end;

function TProjectOptions.GetNodeLinePrefix: char;
Var
  AneResult : ANE_STR;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kNodeLinePrefix) , kPIEString, AneResult) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kNodeLinePrefix);
  end;
  result := String(AneResult)[1];
end;

function TProjectOptions.GetNumSmoothIterations: integer;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kNumSmoothIterations) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kNumSmoothIterations);
  end;
end;

function TProjectOptions.GetQuadriClear: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kQuadriClear) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kQuadriClear);
  end;
end;

function TProjectOptions.GetRemovePoints: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kRemovePoints) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kRemovePoints);
  end;
end;

function TProjectOptions.GetSmallSegmentAffectDensity: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kSmallSegmentAffectDensity) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kSmallSegmentAffectDensity);
  end;
end;

function TProjectOptions.GetW2WDistanceAffectDensity: boolean;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kW2WDistanceAffectDensity) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kW2WDistanceAffectDensity);
  end;
end;

function TProjectOptions.GetW2WThreshold: integer;
begin
  if not ANE_PropertyGet(ArgusHandle, PChar(kW2WThreshold) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kW2WThreshold);
  end;
end;

procedure TProjectOptions.SetAGGInactive(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kAGGInactive), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kAGGInactive);
  end;
end;

procedure TProjectOptions.SetAllowRotatedGrid(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kAllowRotatedGrid), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kAllowRotatedGrid);
  end;
end;

procedure TProjectOptions.SetArcSpliceAngle(const Value: double);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kArcSpliceAngle), kPIEFloat, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kArcSpliceAngle);
  end;
end;

procedure TProjectOptions.SetC2CDistanceAffectDensity(
  const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kC2CDistanceAffectDensity), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kC2CDistanceAffectDensity);
  end;
end;

procedure TProjectOptions.SetC2CThreshold(const Value: integer);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kC2CThreshold) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kC2CThreshold);
  end;
end;

procedure TProjectOptions.SetC2WDistanceAffectDensity(
  const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kC2WDistanceAffectDensity), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kC2WDistanceAffectDensity);
  end;
end;

procedure TProjectOptions.SetC2WThreshold(const Value: integer);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kC2WThreshold) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kC2WThreshold);
  end;
end;

procedure TProjectOptions.SetChangeLayerLock(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kChangeLayerLock), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kChangeLayerLock);
  end;
end;

procedure TProjectOptions.SetCopyDelimiter(const Value: char);
Var
  TempValue : String;
begin
  TempValue := Value;
  if not ANE_PropertySet(ArgusHandle, PChar(kCopyDelimiter) , kPIEString, PChar(TempValue)) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kCopyDelimiter);
  end;
end;

procedure TProjectOptions.SetCopyIcon(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kCopyIcon), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kCopyIcon);
  end;
end;

procedure TProjectOptions.SetCopyName(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kCopyName), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kCopyName);
  end;
end;

procedure TProjectOptions.SetCopyParameters(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kCopyParameters), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kCopyParameters);
  end;
end;

procedure TProjectOptions.SetDensityGrowthRate(const Value: integer);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kDensityGrowthRate) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kDensityGrowthRate);
  end;
end;

procedure TProjectOptions.SetElemLinePrefix(const Value: char);
Var
  TempValue : String;
begin
  TempValue := Value;
  if not ANE_PropertySet(ArgusHandle, PChar(kElemLinePrefix) , kPIEString, PChar(TempValue)) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kElemLinePrefix);
  end;
end;

procedure TProjectOptions.SetEnhancedCleanup(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kEnhancedCleanup), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kEnhancedCleanup);
  end;
end;

procedure TProjectOptions.SetExportDelimiter(const Value: char);
Var
  TempValue : String;
begin
  TempValue := Value;
  if not ANE_PropertySet(ArgusHandle, PChar(kExportDelimiter) , kPIEString, PChar(TempValue)) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kExportDelimiter);
  end;
end;

procedure TProjectOptions.SetExportParameters(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kExportParameters), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kExportParameters);
  end;
end;

procedure TProjectOptions.SetExportSelectionOnly(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kExportSelectionOnly), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kExportSelectionOnly);
  end;
end;

procedure TProjectOptions.SetExportSeparator(const Value: char);
Var
  TempValue : String;
begin
  TempValue := Value;
  if not ANE_PropertySet(ArgusHandle, PChar(kExportSeparator) , kPIEString, PChar(TempValue)) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kExportSeparator);
  end;
end;

procedure TProjectOptions.SetExportTitles(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kExportTitles), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kExportTitles);
  end;
end;

procedure TProjectOptions.SetExportWrap(const Value: integer);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kExportWrap) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportWrap);
  end;
end;

procedure TProjectOptions.SetIncludeDiagonal(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kIncludeDiagonal), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kIncludeDiagonal);
  end;
end;

procedure TProjectOptions.SetMaxAngle(const Value: double);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kMaxAngle), kPIEFloat, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kMaxAngle);
  end;
end;

procedure TProjectOptions.SetMaxEdgeGrowth(const Value: integer);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kMaxEdgeGrowth) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kMaxEdgeGrowth);
  end;
end;

procedure TProjectOptions.SetMeshWithWells(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kMeshWithWells), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kMeshWithWells);
  end;
end;

procedure TProjectOptions.SetMinAngle(const Value: double);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kMinAngle), kPIEFloat, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kMinAngle);
  end;
end;

procedure TProjectOptions.SetNodeLinePrefix(const Value: char);
Var
  TempValue : String;
begin
  TempValue := Value;
  if not ANE_PropertySet(ArgusHandle, PChar(kNodeLinePrefix) , kPIEString, PChar(TempValue)) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kNodeLinePrefix);
  end;
end;

procedure TProjectOptions.SetNumSmoothIterations(const Value: integer);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kNumSmoothIterations) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kNumSmoothIterations);
  end;
end;

procedure TProjectOptions.SetQuadriClear(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kQuadriClear), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kQuadriClear);
  end;
end;

procedure TProjectOptions.SetRemovePoints(const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kRemovePoints), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kRemovePoints);
  end;
end;

procedure TProjectOptions.SetSmallSegmentAffectDensity(
  const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kSmallSegmentAffectDensity), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kSmallSegmentAffectDensity);
  end;
end;

procedure TProjectOptions.SetW2WDistanceAffectDensity(
  const Value: boolean);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kW2WDistanceAffectDensity), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kW2WDistanceAffectDensity);
  end;
end;

procedure TProjectOptions.SetW2WThreshold(const Value: integer);
begin
  if not ANE_PropertySet(ArgusHandle, PChar(kW2WThreshold) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kW2WThreshold);
  end;
end;

end.
