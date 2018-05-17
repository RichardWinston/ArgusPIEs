unit OptionsUnit;

interface

{OptionsUnit defines classes used to set project, layer and paramter
 properties.}

uses Windows, SysUtils, Classes, Dialogs,
  AnePIE;

type
  EArgusPropertyError = Class(Exception);
  EInvalidLayerHandle = class(Exception);

  TPIEObjectType = (pieContourObject, pieBlockObject, pieElementObject,
    pieNodeObject, piePictObject, pieDataPointObject);

  TPIELayerType = (pieTriMeshLayer,pieQuadMeshLayer,pieInformationLayer,
    pieGridLayer,pieDataLayer,pieMapsLayer,pieDomainLayer,pieGroupLayer,
    pieAnyLayer);

  TPIELayerTypes = set of TPIELayerType;

  TPIEParameterType = (pieNullSubParam, pieLayerSubParam,pieMeshLayerSubParam,
    pieGridLayerSubParam, pieContourLayerSubParam, piePictLayerSubParam,
    pieElemSubParam, pieNodeSubParam, pieBlockSubParam, pieVertexSubParam,
    pieGeneralSubParam);

  TPIEParameterTypes = set of TPIEParameterType;

  TParamLockValues = (plName, plUnits, plType, plInfo, plDef_Val,
                              plDont_Override, plInhibit_Delete, plKind,
                              plDontEvalColor);

  TParamLock = set of TParamLockValues;
// TParamLock controls which parameters characteristics will be locked when a
// parameter is created.

// plName: The name of the parameter will be locked and the user will not be
//         able to edit the name without unlocking it.
// plUnits: The units of the parameter will be locked and the user will not be
//         able to edit the units without unlocking them.
// plType: The parameter type (real, integer, ...) will be locked and the
//         user will not be able to edit the parameter type without unlocking
//         it.
// plInfo: The parameter tags will be locked and the user will not be able
//         to edit the parameter tags without unlocking them.
// plDef_Val: The expression of the parameter will be locked and the user will
//         not be able to edit the expression without unlocking it.
// plDont_Override: The user will not be able to set the value of the parameter
//         except by changing the expresion.  Contours and other objects will
//         not be able to change the value of the parameter while this is
//         locked. However, if the user unlocks, overrides, and then relocks,
//         the parameter will be overriden.
// plInhibit_Delete: The user will not be able to delete the parameter without
//         unlocking it.
// plKind: The user will not be able to change the parameter type without
//         unlocking it.  This is only meaninful on layers, such as grid or
//         mesh layers that have more than one type of parameter.
// plDontEvalColor: The user will not be able to color objects based on the
//         value of this parameter.

  TPIENumberType = (pnBoolean, pnInteger, pnFloat, pnString, pnNA);

  TArgusContourType = (ctPoint, ctOpen, ctClosed);

  TBlockCorners = array [0..3] of ANE_DOUBLE;

function LockToString(const ALock : TParamLock) : string;

function StringToLock(const LockString : String) : TParamLock;

function LayerTypesToString(const LayerTypes : TPIELayerTypes) : String;

type
  TProjectOptions = Class(TObject)
  private
    function GetAGGInactive(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetAllowRotatedGrid(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetArcSpliceAngle(ModelHandle : ANE_PTR): ANE_DOUBLE;
    function GetC2CDistanceAffectDensity(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetC2CThreshold(ModelHandle : ANE_PTR): ANE_INT32;
    function GetC2WDistanceAffectDensity(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetC2WThreshold(ModelHandle : ANE_PTR): ANE_INT32;
    function GetChangeLayerLock(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetCopyDelimiter(ModelHandle : ANE_PTR): char;
    function GetCopyIcon(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetCopyName(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetCopyParameters(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetCurrentDirectory(ModelHandle : ANE_PTR) : string;
    function GetCurrentLayer(ModelHandle : ANE_PTR) : ANE_PTR;
    function GetDensityGrowthRate(ModelHandle : ANE_PTR): ANE_INT32;
    function GetElemLinePrefix(ModelHandle : ANE_PTR): char;
    function GetEnhancedCleanup(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetExportDelimiter(ModelHandle : ANE_PTR): char;
    function GetExportParameters(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetExportSelectionOnly(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetExportSeparator(ModelHandle : ANE_PTR): char;
    function GetExportTitles(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetExportWrap(ModelHandle : ANE_PTR): ANE_INT32;
    function GetIncludeDiagonal(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetMaxAngle(ModelHandle : ANE_PTR): ANE_DOUBLE;
    function GetMaxEdgeGrowth(ModelHandle : ANE_PTR): ANE_INT32;
    function GetMeshWithWells(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetMinAngle(ModelHandle : ANE_PTR): ANE_DOUBLE;
    function GetNodeLinePrefix(ModelHandle : ANE_PTR): char;
    function GetNumSmoothIterations(ModelHandle : ANE_PTR): ANE_INT32;
    function GetProjectName(ModelHandle : ANE_PTR) : string;
    function GetQuadriClear(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetRemovePoints(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetSmallSegmentAffectDensity(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetW2WDistanceAffectDensity(ModelHandle : ANE_PTR): ANE_BOOL;
    function GetW2WThreshold(ModelHandle : ANE_PTR): ANE_INT32;
    procedure SetAGGInactive(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetAllowRotatedGrid(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetArcSpliceAngle(ModelHandle : ANE_PTR; const Value: ANE_DOUBLE);
    procedure SetC2CDistanceAffectDensity(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetC2CThreshold(ModelHandle : ANE_PTR; const Value: ANE_INT32);
    procedure SetC2WDistanceAffectDensity(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetC2WThreshold(ModelHandle : ANE_PTR; const Value: ANE_INT32);
    procedure SetChangeLayerLock(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetCopyDelimiter(ModelHandle : ANE_PTR; const Value: char);
    procedure SetCopyIcon(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetCopyName(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetCopyParameters(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetCurrentDirectory(ModelHandle : ANE_PTR; const Value: string);
    procedure SetCurrentLayer(ModelHandle : ANE_PTR; const Value: ANE_PTR);
    procedure SetDensityGrowthRate(ModelHandle : ANE_PTR; const Value: ANE_INT32);
    procedure SetElemLinePrefix(ModelHandle : ANE_PTR; const Value: char);
    procedure SetEnhancedCleanup(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetExportDelimiter(ModelHandle : ANE_PTR; const Value: char);
    procedure SetExportParameters(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetExportSelectionOnly(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetExportSeparator(ModelHandle : ANE_PTR; const Value: char);
    procedure SetExportTitles(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetExportWrap(ModelHandle : ANE_PTR; const Value: ANE_INT32);
    procedure SetIncludeDiagonal(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetMaxAngle(ModelHandle : ANE_PTR; const Value: ANE_DOUBLE);
    procedure SetMaxEdgeGrowth(ModelHandle : ANE_PTR; const Value: ANE_INT32);
    procedure SetMeshWithWells(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetMinAngle(ModelHandle : ANE_PTR; const Value: ANE_DOUBLE);
    procedure SetNodeLinePrefix(ModelHandle : ANE_PTR; const Value: char);
    procedure SetNumSmoothIterations(ModelHandle : ANE_PTR; const Value: ANE_INT32);
    procedure SetQuadriClear(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetRemovePoints(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetSmallSegmentAffectDensity(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetW2WDistanceAffectDensity(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
    procedure SetW2WThreshold(ModelHandle : ANE_PTR; const Value: ANE_INT32);
  public
    property CurrentLayer[ModelHandle : ANE_PTR] : ANE_PTR read GetCurrentLayer write SetCurrentLayer;
    function GetLayerByName(ModelHandle : ANE_PTR; Name : string) : ANE_PTR; overload;
    function GetLayerByName(ModelHandle : ANE_PTR; Name : ANE_STR) : ANE_PTR; overload;
    function GetLayerByIndex(const ModelHandle: ANE_PTR;
      const index: ANE_INT32): ANE_PTR;
    property AGGInactive[ModelHandle : ANE_PTR]	       	: ANE_BOOL read GetAGGInactive write SetAGGInactive;	// the document's preference	for block inactiving after gridding
    property AllowRotatedGrid[ModelHandle : ANE_PTR]		: ANE_BOOL read GetAllowRotatedGrid write SetAllowRotatedGrid;	// the document's preference	to allow rotated grid at gridding
    property ArcSpliceAngle[ModelHandle : ANE_PTR]		: ANE_DOUBLE read GetArcSpliceAngle write SetArcSpliceAngle;	// the document's preference	for splice angle when copying arcs
    property C2CDistanceAffectDensity[ModelHandle : ANE_PTR]	: ANE_BOOL read GetC2CDistanceAffectDensity write SetC2CDistanceAffectDensity;	// the document's preference	for contour-contour affect density during meshing
    property C2CThreshold[ModelHandle : ANE_PTR]	       	: ANE_INT32 read GetC2CThreshold write SetC2CThreshold;	// the document's preference	for value of contour-contour effect
    property C2WDistanceAffectDensity[ModelHandle : ANE_PTR]	: ANE_BOOL read GetC2WDistanceAffectDensity write SetC2WDistanceAffectDensity;	// the document's preference	for contour-well affect density during meshing
    property C2WThreshold[ModelHandle : ANE_PTR]	       	: ANE_INT32 read GetC2WThreshold write SetC2WThreshold;	// the document's preference	for value of contour-well effect
    property ChangeLayerLock[ModelHandle : ANE_PTR]		: ANE_BOOL read GetChangeLayerLock write SetChangeLayerLock;	// the document's preference	for letting change layer locks
    property CopyDelimiter[ModelHandle : ANE_PTR]	       	: char read GetCopyDelimiter write SetCopyDelimiter;		// the document's preference	for the delimiter at contour copy
    property CopyIcon[ModelHandle : ANE_PTR]			: ANE_BOOL read GetCopyIcon write SetCopyIcon;	// the document's preference	for copying contour icon
    property CopyName[ModelHandle : ANE_PTR]			: ANE_BOOL read GetCopyName write SetCopyName;	// the document's preference	for copying contour name
    property CopyParameters[ModelHandle : ANE_PTR]		: ANE_BOOL read GetCopyParameters write SetCopyParameters;	// the document's preference	for copying contour parameters
    property CurrentDirectory[ModelHandle : ANE_PTR]           : string read GetCurrentDirectory write SetCurrentDirectory;
    property DensityGrowthRate[ModelHandle : ANE_PTR]		: ANE_INT32 read GetDensityGrowthRate write SetDensityGrowthRate;	// the document's preference	for density growth rate at meshing
    property EnhancedCleanup[ModelHandle : ANE_PTR]		: ANE_BOOL read GetEnhancedCleanup write SetEnhancedCleanup;	// the document's preference	for enhanced cleanup after quadri. meshing
    property ExportDelimiter[ModelHandle : ANE_PTR]		: char read GetExportDelimiter write SetExportDelimiter;		// the document's preference	for the delimiter at contour export
    property ExportParameters[ModelHandle : ANE_PTR]		: ANE_BOOL read GetExportParameters write SetExportParameters;	// the document's preference	to export parameters
    property ExportSelectionOnly[ModelHandle : ANE_PTR]       	: ANE_BOOL read GetExportSelectionOnly write SetExportSelectionOnly;	// the document's preference	to export selection only
    property ExportSeparator[ModelHandle : ANE_PTR]		: char read GetExportSeparator write SetExportSeparator;		// the document's preference	for separator used at export
    property ExportTitles[ModelHandle : ANE_PTR]	       	: ANE_BOOL read GetExportTitles write SetExportTitles;	// the document's preference	to export titles
    property ExportWrap[ModelHandle : ANE_PTR]			: ANE_INT32 read GetExportWrap write SetExportWrap;	// the document's preference	for wrap value for export
    property ElemLinePrefix[ModelHandle : ANE_PTR]		: char read GetElemLinePrefix write SetElemLinePrefix;		// the document's preference	for export element line prefix
    property IncludeDiagonal[ModelHandle : ANE_PTR]		: ANE_BOOL read GetIncludeDiagonal write SetIncludeDiagonal;	// the document's preference	for including diagonal in BW calculation
    procedure LayerNames(const ModelHandle : ANE_PTR;
      const LayerTypes : TPIELayerTypes; const AStringList : TStrings);
    property MaxAngle[ModelHandle : ANE_PTR]			: ANE_DOUBLE read GetMaxAngle write SetMaxAngle;	// the document's preference	for max element angle
    property MaxEdgeGrowth[ModelHandle : ANE_PTR]	       	: ANE_INT32 read GetMaxEdgeGrowth write SetMaxEdgeGrowth;	// the document's preference	for edge growth at meshing.
    property MeshWithWells[ModelHandle : ANE_PTR]	       	: ANE_BOOL read GetMeshWithWells write SetMeshWithWells;	// the document's preference	for considering point objects while meshing
    property MinAngle[ModelHandle : ANE_PTR]			: ANE_DOUBLE read GetMinAngle write SetMinAngle;	// the document's preference	for min element angle
    property NodeLinePrefix[ModelHandle : ANE_PTR]		: char read GetNodeLinePrefix write SetNodeLinePrefix;		// the document's preference	for export node line prefix
    property NumSmoothIterations[ModelHandle : ANE_PTR]       	: ANE_INT32 read GetNumSmoothIterations write SetNumSmoothIterations;	// the document's preference	for smooth operations after meshing
    property ProjectName[ModelHandle : ANE_PTR]                : string read GetProjectName;
    property QuadriClear[ModelHandle : ANE_PTR]	       	: ANE_BOOL read GetQuadriClear write SetQuadriClear;	// the document's preference	for clearing tri. after quadri. meshing
    property RemovePoints[ModelHandle : ANE_PTR]	       	: ANE_BOOL read GetRemovePoints write SetRemovePoints;	// the document's preference	for removing vertices on streight lines during meshing
    property SmallSegmentAffectDensity [ModelHandle : ANE_PTR]	: ANE_BOOL read GetSmallSegmentAffectDensity write SetSmallSegmentAffectDensity;	// the document's preference	for meshing option
    property W2WDistanceAffectDensity[ModelHandle : ANE_PTR]	: ANE_BOOL read GetW2WDistanceAffectDensity write SetW2WDistanceAffectDensity;	// the document's preference	for well-well affect density during meshing
    property W2WThreshold[ModelHandle : ANE_PTR]	       	: ANE_INT32 read GetW2WThreshold write SetW2WThreshold;	// the document's preference	for value of well-well effect

end;

  TLayerOptions = class(TObject)
  private
//    FModelHandle : ANE_PTR;
    FLayerHandle : ANE_PTR;
    FParsedExpression : ANE_PTR;
    ParsedExpressionList : TStringList;
    function GetAllowIntersection(ModelHandle: ANE_PTR ) : ANE_BOOL;
    function GetCoordScale(ModelHandle: ANE_PTR ): ANE_DOUBLE;
    function GetCoordUnits(ModelHandle: ANE_PTR ): string;
    function GetCoordXRight(ModelHandle: ANE_PTR ): ANE_BOOL;
    function GetCoordXYRatio(ModelHandle: ANE_PTR ): ANE_DOUBLE;
    function GetCoordYUp(ModelHandle: ANE_PTR ): ANE_BOOL;
    function GetGridReverseXDirection(ModelHandle: ANE_PTR ): ANE_BOOL;
    function GetGridReverseYDirection(ModelHandle: ANE_PTR ): ANE_BOOL;
    function GetLayerType(ModelHandle: ANE_PTR ) : TPIELayerType;
    function GetName(ModelHandle: ANE_PTR): String;
    function GetText(ModelHandle: ANE_PTR) : string;
    procedure SetAllowIntersection(ModelHandle: ANE_PTR; const Value: ANE_BOOL);
    procedure SetGridReverseXDirection(ModelHandle: ANE_PTR; const Value: ANE_BOOL);
    procedure SetGridReverseYDirection(ModelHandle: ANE_PTR; const Value: ANE_BOOL);
    procedure SetName(ModelHandle: ANE_PTR; const Name: String);
    function ANEStringValueAtXY(ModelHandle: ANE_PTR; X, Y: ANE_DOUBLE;
      Expression: String): ANE_STR;
  public
    property AllowIntersection[ModelHandle: ANE_PTR ] : ANE_BOOL read GetAllowIntersection write SetAllowIntersection;
    function BooleanValue(const ModelHandle : ANE_PTR; const StringToEvaluate : string) : ANE_BOOL;
    function BooleanValueAtXY(ModelHandle : ANE_PTR; X,Y : ANE_DOUBLE; Expression : String = '') : ANE_BOOL;
    function ClearLayer(ModelHandle: ANE_PTR; SelectedOnly : ANE_BOOL) : ANE_BOOL;
    procedure ClearParsedExpressions(ModelHandle : ANE_PTR);
    property CoordScale[ModelHandle: ANE_PTR ]	 : ANE_DOUBLE read GetCoordScale;
    property CoordUnits[ModelHandle: ANE_PTR ] : string read GetCoordUnits;
    property CoordXRight[ModelHandle: ANE_PTR ] : ANE_BOOL read GetCoordXRight;
    property CoordXYRatio[ModelHandle: ANE_PTR ]: ANE_DOUBLE read GetCoordXYRatio;
    property CoordYUp[ModelHandle: ANE_PTR ] : ANE_BOOL read GetCoordYUp;
    Constructor Create(const LayerHandle : ANE_PTR);
    constructor CreateWithName(const LayerName: string;
      ModelHandle: ANE_PTR); virtual;
    Destructor Destroy; override;
//    procedure FreeParsedExpression(ModelHandle : ANE_PTR) ;
    procedure Free(ModelHandle: ANE_PTR);
    function GetParameterIndex(ModelHandle: ANE_PTR;
      ParameterName : string) : ANE_INT32; overload;
    function GetParameterIndex(ModelHandle: ANE_PTR;
      ParameterName : ANE_STR) : ANE_INT32; overload;
    function GetParameterName(ModelHandle: ANE_PTR;
      ParameterIndex: ANE_INT32): string;
    procedure GetParameterNames(ModelHandle: ANE_PTR; Names: TStrings);
    procedure GetStrings(ModelHandle: ANE_PTR; Strings : TStrings);
    property GridReverseXDirection[ModelHandle: ANE_PTR ] : ANE_BOOL read GetGridReverseXDirection write SetGridReverseXDirection;
    property GridReverseYDirection[ModelHandle: ANE_PTR ] : ANE_BOOL read GetGridReverseYDirection write SetGridReverseYDirection;
//    function IntValueAtXY(ModelHandle: ANE_PTR; X, Y: ANE_DOUBLE;
//      Expression: String): ANE_INT32;
    procedure InvalidateCache(ModelHandle: ANE_PTR);
    property LayerHandle : ANE_PTR read FLayerHandle;
    property LayerType[ModelHandle: ANE_PTR ] : TPIELayerType read GetLayerType;
    function IntegerValue(const ModelHandle : ANE_PTR; const StringToEvaluate : string) : ANE_INT32;
    function IntegerValueAtXY(ModelHandle : ANE_PTR; X,Y : ANE_DOUBLE; Expression : String = '') : ANE_INT32;
    property Name[ModelHandle: ANE_PTR ]: String read GetName write SetName;
    function NthObject(ModelHandle: ANE_PTR; ObjectType : TPIEObjectType; Index : ANE_INT32) : ANE_PTR;
    function NumObjects (ModelHandle: ANE_PTR; ObjectType : TPIEObjectType) : ANE_INT32;
    function NumParameters(ModelHandle: ANE_PTR; ParameterType : TPIEParameterType) : ANE_INT32; overload;
    function NumParameters(ModelHandle: ANE_PTR; ParameterTypes : TPIEParameterTypes) : ANE_INT32; overload;
    procedure ParseExpression(ModelHandle: ANE_PTR; Expression: String;
      NumberType: TPIENumberType);
    function RealValue(const ModelHandle : ANE_PTR; const StringToEvaluate : string) : ANE_DOUBLE;
    function RealValueAtXY(ModelHandle : ANE_PTR; X,Y : ANE_DOUBLE; Expression : String = '') : ANE_DOUBLE;
    function Remove(ModelHandle: ANE_PTR; forceRemoval : ANE_BOOL ) : ANE_BOOL;
    procedure Rename(ModelHandle: ANE_PTR; NewName : string);
    procedure SetText(ModelHandle: ANE_PTR; const Value : String);
    function StringValue(const ModelHandle : ANE_PTR; const StringToEvaluate : string) : string;
    function StringValueAtXY(ModelHandle : ANE_PTR; X,Y : ANE_DOUBLE; Expression : String = '') : string;
    Property Text[ModelHandle: ANE_PTR ] : String read GetText write SetText;
  end;

  TGridLayerOptions = class(TLayerOptions)
    function ColumnPositions(const ModelHandle : ANE_PTR;
      const ColumnIndex : integer): ANE_DOUBLE;
    Constructor Create(const ModelHandle, LayerHandle : ANE_PTR);
    constructor CreateWithName(const LayerName: string;
      ModelHandle: ANE_PTR); override;
    function GridAngle(const ModelHandle : ANE_PTR) :ANE_DOUBLE;
    function NumberOfColumns(const ModelHandle : ANE_PTR) :ANE_INT32;
    function NumberOfRows(const ModelHandle : ANE_PTR) :ANE_INT32;
    function RowPositions(const ModelHandle : ANE_PTR;
      const RowIndex : integer): ANE_DOUBLE;
  end;

  TParameterOptions = class(TObject)
  private
//    FModelHandle : ANE_PTR;
    FLayerHandle : ANE_PTR;
    FParameterIndex : ANE_INT32;
    function GetExpr(ModelHandle: ANE_PTR) : string;
    function GetLock(ModelHandle: ANE_PTR) : string;
    function GetName(ModelHandle: ANE_PTR) : string;
    function GetNumberType(ModelHandle: ANE_PTR) : TPIENumberType;
    function GetNumberTypeString(ModelHandle: ANE_PTR) : String;
    function GetParameterType(ModelHandle: ANE_PTR) : TPIEParameterType;
    function GetUnits(ModelHandle: ANE_PTR) : string;
    procedure SetExpr(ModelHandle: ANE_PTR; const Value: string);
    procedure SetLock(ModelHandle: ANE_PTR; const Value: string);
    procedure SetMinusLock(ModelHandle: ANE_PTR; const Value: string);
    procedure SetName(ModelHandle: ANE_PTR; const Value: string);
    procedure SetPlusLock(ModelHandle: ANE_PTR; const Value: string);
    procedure SetUnits(ModelHandle: ANE_PTR; const Value: string);
    function GetLockSet(ModelHandle: ANE_PTR): TParamLock;
    procedure SetLockSet(ModelHandle: ANE_PTR; const Value: TParamLock);
    procedure SetMinusLockSet(ModelHandle: ANE_PTR;
      const Value: TParamLock);
    procedure SetPlusLockSet(ModelHandle: ANE_PTR;
      const Value: TParamLock);
  public
    Constructor Create(const LayerHandle : ANE_PTR;
      ParameterIndex : ANE_INT32);
    property Expr[ModelHandle: ANE_PTR] : string read GetExpr write SetExpr;
    property Lock[ModelHandle: ANE_PTR] : string read GetLock write SetLock;
    property LockSet[ModelHandle: ANE_PTR] : TParamLock read GetLockSet write SetLockSet;
    property MinusLock[ModelHandle: ANE_PTR] : string write SetMinusLock;
    property MinusLockSet[ModelHandle: ANE_PTR] : TParamLock write SetMinusLockSet;
    property Name[ModelHandle: ANE_PTR] : string read GetName write SetName;
    property NumberType[ModelHandle: ANE_PTR] : TPIENumberType read GetNumberType;
    property NumberTypeString[ModelHandle: ANE_PTR] : String read GetNumberTypeString;
    property ParameterType[ModelHandle: ANE_PTR] : TPIEParameterType read GetParameterType;
    property PlusLock[ModelHandle: ANE_PTR] : string write SetPlusLock;
    property PlusLockSet[ModelHandle: ANE_PTR] : TParamLock write SetPlusLockSet;
    property Units[ModelHandle: ANE_PTR] : string read GetUnits write SetUnits;
    function Rename(ModelHandle: ANE_PTR; NewName : string) : boolean; overload;
    function Rename(ModelHandle: ANE_PTR; NewName : ANE_STR) : boolean; overload;
    constructor CreateWithName(const LayerHandle, ModelHandle: ANE_PTR;
      ParameterName: String);
    constructor CreateWithNameAndLayer(const Layer: TLayerOptions;
      ParameterName: String; ModelHandle: ANE_PTR);
  end;

  TObjectOptions = class(TObject)
  private
//    FModelHandle : ANE_PTR;
    FLayerHandle : ANE_PTR;
    FObjectHandle : ANE_PTR;
    function GetObjectType : EPIEObjectType; virtual; abstract;
  public
    Constructor Create(ModelHandle : ANE_PTR; const layerHandle : ANE_PTR;
      objectIndex : ANE_INT32);
    function GetBoolParameter(ModelHandle : ANE_PTR; ParameterIndex: ANE_INT16): ANE_BOOL;
    function GetFloatParameter(ModelHandle : ANE_PTR; ParameterIndex : ANE_INT16) : ANE_DOUBLE;
    function GetIntegerParameter(ModelHandle : ANE_PTR; ParameterIndex : ANE_INT16) : ANE_INT32;
    function GetStringParameter(ModelHandle : ANE_PTR; ParameterIndex : ANE_INT16) : string;
    function SetBoolParameter(ModelHandle : ANE_PTR; ParameterIndex: ANE_INT16;
      Value : ANE_BOOL): ANE_BOOL; virtual;
    function SetFloatParameter(ModelHandle : ANE_PTR;
      ParameterIndex : ANE_INT16; Value : ANE_DOUBLE) : ANE_BOOL;  virtual;
    function SetIntegerParameter(ModelHandle : ANE_PTR;
      ParameterIndex : ANE_INT16; Value : ANE_INT32) : ANE_BOOL; virtual;
    function SetStringParameter(ModelHandle : ANE_PTR;
      ParameterIndex : ANE_INT16; Value : ANE_STR) : ANE_BOOL;  overload; virtual;
    function SetStringParameter(ModelHandle : ANE_PTR;
      ParameterIndex : ANE_INT16; Value : String) : ANE_BOOL;  overload; virtual;
    property LayerHandle : ANE_PTR read FLayerHandle;
    property ObjectHandle : ANE_PTR read FObjectHandle;
  end;

  TNodeObjectOptions = class(TObjectOptions)
  private
    function GetObjectType : EPIEObjectType; override;
  public
    Procedure GetLocation(ModelHandle : ANE_PTR; var X, Y : ANE_DOUBLE);
  end;

  TDataObjectOptions = class(TObjectOptions)
  private
    function GetObjectType : EPIEObjectType; override;
  public
    function SetBoolParameter(ModelHandle : ANE_PTR; ParameterIndex: ANE_INT16;
      Value : ANE_BOOL): ANE_BOOL; override;
    function SetFloatParameter(ModelHandle : ANE_PTR;
      ParameterIndex : ANE_INT16; Value : ANE_DOUBLE) : ANE_BOOL;  override;
    function SetIntegerParameter(ModelHandle : ANE_PTR;
      ParameterIndex : ANE_INT16; Value : ANE_INT32) : ANE_BOOL; override;
    function SetStringParameter(ModelHandle : ANE_PTR;
      ParameterIndex : ANE_INT16; Value : ANE_STR) : ANE_BOOL;  overload; override;
    function SetStringParameter(ModelHandle : ANE_PTR;
      ParameterIndex : ANE_INT16; Value : String) : ANE_BOOL;  overload; override;
    Procedure GetLocation(ModelHandle : ANE_PTR; var X, Y : ANE_DOUBLE);
  end;

  TElementObjectOptions = class(TObjectOptions)
  private
{    FModelHandle : ANE_PTR;
    FLayerHandle : ANE_PTR;
    FObjectHandle : ANE_PTR; }
    FObjectIndex : ANE_INT32;
    function GetObjectType : EPIEObjectType; override;
  public
    Constructor Create(ModelHandle : ANE_PTR; const layerHandle : ANE_PTR;
      objectIndex : ANE_INT32);
    Procedure GetNthNodeLocation(ModelHandle : ANE_PTR; var X, Y : ANE_DOUBLE;
      const NodeIndex : ANE_INT32);
    function NumberOfNodes(ModelHandle : ANE_PTR) : ANE_INT32;
{    function GetStringParameter(ParameterIndex : ANE_INT16) : string;
    function GetIntegerParameter(ParameterIndex : ANE_INT16) : ANE_INT32;
    function GetFloatParameter(ParameterIndex : ANE_INT16) : ANE_DOUBLE;
    function GetBoolParameter(ParameterIndex: ANE_INT16): ANE_BOOL; }
    function GetNthNodeNumber(ModelHandle : ANE_PTR; NodeNumber : ANE_INT32) : ANE_INT32;
    property ObjectIndex : ANE_INT32 read FObjectIndex;
  end;

  TBlockObjectOptions = class(TObjectOptions)
  private
//    FObjectIndex : ANE_INT32;
    function GetObjectType : EPIEObjectType; override;
  public
{    Constructor Create(ModelHandle : ANE_PTR; const layerHandle : ANE_PTR;
      objectIndex : ANE_INT32);
    Procedure GetNthNodeLocation(ModelHandle : ANE_PTR; var X, Y : ANE_DOUBLE;
      const NodeIndex : ANE_INT32);
    function NumberOfNodes(ModelHandle : ANE_PTR) : ANE_INT32;
    function GetNthNodeNumber(ModelHandle : ANE_PTR; NodeNumber : ANE_INT32) : ANE_INT32;}
    procedure GetCenter(const ModelHandle : ANE_PTR; var X, Y : ANE_DOUBLE);
    procedure GetCorner(const ModelHandle: ANE_PTR;
      const CornerIndex: ANE_INT32; var X, Y: ANE_DOUBLE);
    procedure GetCorners(const ModelHandle: ANE_PTR; var XArray,
      YArray: TBlockCorners);
  end;

  TContourObjectOptions = class(TObjectOptions)
  private
    function GetObjectType : EPIEObjectType; override;
  public
    Procedure GetNthNodeLocation(ModelHandle : ANE_PTR; var X, Y : ANE_DOUBLE;
      const NodeIndex : ANE_INT32);
    function NumberOfNodes(ModelHandle : ANE_PTR) : ANE_INT32;
    function IsInside (ModelHandle : ANE_PTR; X, Y : ANE_DOUBLE): boolean;
    function ContourType(ModelHandle : ANE_PTR) : TArgusContourType;
//    function ContourName(const ModelHandle : ANE_PTR) : string;
  end;

implementation

uses ANECB, ParamArrayUnit;

const
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
  kProjectName                 = 'ProjectName';


  kNameProp                    = 'Name';
  kCoordXRight	               = 'CoordXRight';
  kCoordYUp	               = 'CoordYUp';
  kCoordUnits	               = 'CoordUnits';
  kCoordScale	               = 'CoordScale';
  kCoordXYRatio	               = 'CoordXYRatio';
  kGridReverseXDirection       = 'GridReverseXDirection';
  kGridReverseYDirection       = 'GridReverseYDirection';
  kAllowIntersection           = 'Allow Intersection';


  kName                         = 'Name';
  kUnits                        = 'Units';
  kExpr                         = 'Expr';
  kLock                         = 'Lock';
  kPlusLock                     = '+Lock';
  kMinusLock                    = '-Lock';
  kType                         = 'Type';
  kTypeString                   = 'TypeStr';
  kParamType                    = 'ParamType';

type
  TParsedExpressionObject = Class(TObject)
    ParsedExpression : ANE_PTR;
  end;

var
  OptionsModelHandle : ANE_PTR = nil;

{ TProjectOptions }


function TProjectOptions.GetCurrentLayer(ModelHandle : ANE_PTR): ANE_PTR;
begin
  result := ANE_LayerGetCurrent(ModelHandle);
end;

function TProjectOptions.GetAGGInactive(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kAGGInactive) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kAGGInactive);
  end;
end;

function TProjectOptions.GetAllowRotatedGrid(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kAllowRotatedGrid) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kAllowRotatedGrid);
  end;
end;

function TProjectOptions.GetArcSpliceAngle(ModelHandle : ANE_PTR): ANE_DOUBLE;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kArcSpliceAngle) , kPIEFloat, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kArcSpliceAngle);
  end;
end;

function TProjectOptions.GetC2CDistanceAffectDensity(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kC2CDistanceAffectDensity) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kC2CDistanceAffectDensity);
  end;
end;

function TProjectOptions.GetC2CThreshold(ModelHandle : ANE_PTR): ANE_INT32;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kC2CThreshold) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kC2CThreshold);
  end;
end;

function TProjectOptions.GetC2WDistanceAffectDensity(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kC2WDistanceAffectDensity) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kC2WDistanceAffectDensity);
  end;
end;

function TProjectOptions.GetC2WThreshold(ModelHandle : ANE_PTR): ANE_INT32;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kC2WThreshold) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kC2WThreshold);
  end;
end;

function TProjectOptions.GetChangeLayerLock(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kChangeLayerLock) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kChangeLayerLock);
  end;
end;

function TProjectOptions.GetCopyDelimiter(ModelHandle : ANE_PTR): char;
Var
  AneResult : ANE_STR;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kCopyDelimiter) , kPIEString, @AneResult) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCopyDelimiter);
  end;
  if AneResult = '^t' then
  begin
    result := #9;
  end
  else
  begin
    result := String(AneResult)[1];
  end;
end;

function TProjectOptions.GetCopyIcon(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kCopyIcon) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCopyIcon);
  end;
end;

function TProjectOptions.GetCopyName(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kCopyName) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCopyName);
  end;
end;

function TProjectOptions.GetCopyParameters(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kCopyParameters) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCopyParameters);
  end;
end;


function TProjectOptions.GetCurrentDirectory(ModelHandle : ANE_PTR): string;
var
  AString : array [0..MAX_PATH+1] of Char;
begin
  ANE_DirectoryGetCurrent(ModelHandle, AString, MAX_PATH+1);
  result := string(AString);
end;

function TProjectOptions.GetDensityGrowthRate(ModelHandle : ANE_PTR): ANE_INT32;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kDensityGrowthRate) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kDensityGrowthRate);
  end;
end;

function TProjectOptions.GetElemLinePrefix(ModelHandle : ANE_PTR): char;
Var
  AneResult : ANE_STR;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kElemLinePrefix) , kPIEString, @AneResult) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kElemLinePrefix);
  end;
  result := String(AneResult)[1];
end;

function TProjectOptions.GetEnhancedCleanup(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kEnhancedCleanup) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kEnhancedCleanup);
  end;
end;

function TProjectOptions.GetExportDelimiter(ModelHandle : ANE_PTR): char;
Var
  AneResult : ANE_STR;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kExportDelimiter) , kPIEString, @AneResult) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportDelimiter);
  end;
  if AneResult = '^t' then
  begin
    result := #9;
  end
  else
  begin
    result := String(AneResult)[1];
  end;
end;

function TProjectOptions.GetExportParameters(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kExportParameters) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportParameters);
  end;
end;

function TProjectOptions.GetExportSelectionOnly(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kExportSelectionOnly) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportSelectionOnly);
  end;
end;

function TProjectOptions.GetExportSeparator(ModelHandle : ANE_PTR): char;
Var
  AneResult : ANE_STR;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kExportSeparator) , kPIEString, @AneResult) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportSeparator);
  end;
  result := String(AneResult)[1];
end;

function TProjectOptions.GetExportTitles(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kExportTitles) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportTitles);
  end;
end;

function TProjectOptions.GetExportWrap(ModelHandle : ANE_PTR): ANE_INT32;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kExportWrap) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportWrap);
  end;
end;

function TProjectOptions.GetIncludeDiagonal(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kIncludeDiagonal) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kIncludeDiagonal);
  end;
end;

function TProjectOptions.GetMaxAngle(ModelHandle : ANE_PTR): ANE_DOUBLE;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kMaxAngle) , kPIEFloat, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kMaxAngle);
  end;
end;

function TProjectOptions.GetMaxEdgeGrowth(ModelHandle : ANE_PTR): ANE_INT32;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kMaxEdgeGrowth) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kMaxEdgeGrowth);
  end;
end;

function TProjectOptions.GetMeshWithWells(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kMeshWithWells) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kMeshWithWells);
  end;
end;

function TProjectOptions.GetMinAngle(ModelHandle : ANE_PTR): ANE_DOUBLE;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kMinAngle) , kPIEFloat, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kMinAngle);
  end;
end;

function TProjectOptions.GetNodeLinePrefix(ModelHandle : ANE_PTR): char;
Var
  AneResult : ANE_STR;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kNodeLinePrefix) , kPIEString, @AneResult) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kNodeLinePrefix);
  end;
  result := String(AneResult)[1];
end;

function TProjectOptions.GetNumSmoothIterations(ModelHandle : ANE_PTR): ANE_INT32;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kNumSmoothIterations) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kNumSmoothIterations);
  end;
end;

function TProjectOptions.GetQuadriClear(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kQuadriClear) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kQuadriClear);
  end;
end;

function TProjectOptions.GetRemovePoints(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kRemovePoints) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kRemovePoints);
  end;
end;

function TProjectOptions.GetSmallSegmentAffectDensity(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kSmallSegmentAffectDensity) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kSmallSegmentAffectDensity);
  end;
end;

function TProjectOptions.GetW2WDistanceAffectDensity(ModelHandle : ANE_PTR): ANE_BOOL;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kW2WDistanceAffectDensity) , kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kW2WDistanceAffectDensity);
  end;
end;

function TProjectOptions.GetW2WThreshold(ModelHandle : ANE_PTR): ANE_INT32;
begin
  if not ANE_PropertyGet(ModelHandle, PChar(kW2WThreshold) , kPIEInteger, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kW2WThreshold);
  end;
end;

procedure TProjectOptions.LayerNames(const ModelHandle : ANE_PTR;
  const LayerTypes: TPIELayerTypes; const AStringList: TStrings);
var
  ArgusLayerTypes : EPIELayerType;
  LayerNamesPtr : ANE_STR_PTR;
  AnANE_STR : ANE_STR;
  LayerNames : PParameter_array;
  Index : integer;
  ThisString, PreviousString, AString : string;

begin
  ArgusLayerTypes := 0;
  if pieTriMeshLayer in LayerTypes then
  begin
    ArgusLayerTypes := ArgusLayerTypes or kPIETriMeshLayer;
  end;

  if pieQuadMeshLayer in LayerTypes then
  begin
    ArgusLayerTypes := ArgusLayerTypes or kPIEQuadMeshLayer;
  end;

  if pieInformationLayer in LayerTypes then
  begin
    ArgusLayerTypes := ArgusLayerTypes or kPIEInformationLayer;
  end;

  if pieGridLayer in LayerTypes then
  begin
    ArgusLayerTypes := ArgusLayerTypes or kPIEGridLayer;
  end;

  if pieDataLayer in LayerTypes then
  begin
    ArgusLayerTypes := ArgusLayerTypes or kPIEDataLayer;
  end;

  if pieMapsLayer in LayerTypes then
  begin
    ArgusLayerTypes := ArgusLayerTypes or kPIEMapsLayer;
  end;

  if pieDomainLayer in LayerTypes then
  begin
    ArgusLayerTypes := ArgusLayerTypes or kPIEDomainLayer;
  end;

  if pieGroupLayer in LayerTypes then
  begin
    ArgusLayerTypes := ArgusLayerTypes or kPIEGroupLayer;
  end;

  if pieAnyLayer in LayerTypes then
  begin
    ArgusLayerTypes := ArgusLayerTypes or kPIEAnyLayer;
  end;

  LayerNamesPtr := ANE_LayerGetNamesByType(ModelHandle, ArgusLayerTypes);
  LayerNames := @LayerNamesPtr^;
  Index := 0;
  PreviousString := '';
  repeat
  begin
    AnANE_STR :=  LayerNames^[Index];
    if AnANE_STR <> nil then
    begin
      ThisString := String(AnANE_STR);
      if Index <> 0 then
      begin
        AString := Copy(PreviousString,1,Length(PreviousString)-Length(ThisString));
        AStringList.Add(AString);
      end;
    end;
    Inc(Index);
    PreviousString := ThisString;
  end;
  until AnANE_STR = nil;
  if ThisString <> '' then
  begin
    AStringList.Add(ThisString);
  end;
  ANE_MemDelete(ModelHandle, LayerNamesPtr);
end;

//  TPIELayerType = (pieTriMeshLayer,pieQuadMeshLayer,pieInformationLayer,
//    pieGridLayer,pieDataLayer,pieMapsLayer,pieDomainLayer,pieAnyLayer);

procedure TProjectOptions.SetAGGInactive(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kAGGInactive), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kAGGInactive);
  end;
end;

procedure TProjectOptions.SetAllowRotatedGrid(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kAllowRotatedGrid), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kAllowRotatedGrid);
  end;
end;

procedure TProjectOptions.SetArcSpliceAngle(ModelHandle : ANE_PTR; const Value: ANE_DOUBLE);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kArcSpliceAngle), kPIEFloat, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kArcSpliceAngle);
  end;
end;

procedure TProjectOptions.SetC2CDistanceAffectDensity(ModelHandle : ANE_PTR;
  const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kC2CDistanceAffectDensity), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kC2CDistanceAffectDensity);
  end;
end;

procedure TProjectOptions.SetC2CThreshold(ModelHandle : ANE_PTR; const Value: ANE_INT32);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kC2CThreshold) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kC2CThreshold);
  end;
end;

procedure TProjectOptions.SetC2WDistanceAffectDensity(ModelHandle : ANE_PTR;
  const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kC2WDistanceAffectDensity), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kC2WDistanceAffectDensity);
  end;
end;

procedure TProjectOptions.SetC2WThreshold(ModelHandle : ANE_PTR; const Value: ANE_INT32);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kC2WThreshold) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kC2WThreshold);
  end;
end;

procedure TProjectOptions.SetChangeLayerLock(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kChangeLayerLock), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kChangeLayerLock);
  end;
end;

procedure TProjectOptions.SetCopyDelimiter(ModelHandle : ANE_PTR; const Value: char);
Var
  ANEValue : ANE_STR;
begin
  ANEValue := PChar(Value);
  if not ANE_PropertySet(ModelHandle, PChar(kCopyDelimiter) , kPIEString, @ANEValue) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kCopyDelimiter);
  end;
end;

procedure TProjectOptions.SetCopyIcon(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kCopyIcon), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kCopyIcon);
  end;
end;

procedure TProjectOptions.SetCopyName(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kCopyName), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kCopyName);
  end;
end;

procedure TProjectOptions.SetCopyParameters(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kCopyParameters), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kCopyParameters);
  end;
end;

procedure TProjectOptions.SetCurrentDirectory(ModelHandle : ANE_PTR; const Value: string);
var
  ValueStr : ANE_STR;
begin
  GetMem(ValueStr, Length(Value) + 1);
  try
    StrPCopy(ValueStr,Value);
    ANE_DirectorySetCurrent(ModelHandle, ValueStr);
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(ValueStr);
  end;
end;

procedure TProjectOptions.SetDensityGrowthRate(ModelHandle : ANE_PTR; const Value: ANE_INT32);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kDensityGrowthRate) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kDensityGrowthRate);
  end;
end;

procedure TProjectOptions.SetElemLinePrefix(ModelHandle : ANE_PTR; const Value: char);
Var
  ANEValue : ANE_STR;
begin
  ANEValue := PChar(Value);
  if not ANE_PropertySet(ModelHandle, PChar(kElemLinePrefix) , kPIEString, @ANEValue) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kElemLinePrefix);
  end;
end;

procedure TProjectOptions.SetEnhancedCleanup(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kEnhancedCleanup), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kEnhancedCleanup);
  end;
end;

procedure TProjectOptions.SetExportDelimiter(ModelHandle : ANE_PTR; const Value: char);
Var
  ANEValue : ANE_STR;
begin
  ANEValue := PChar(Value);
  if not ANE_PropertySet(ModelHandle, PChar(kExportDelimiter) , kPIEString, @ANEValue) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kExportDelimiter);
  end;
end;

procedure TProjectOptions.SetExportParameters(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kExportParameters), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kExportParameters);
  end;
end;

procedure TProjectOptions.SetExportSelectionOnly(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kExportSelectionOnly), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kExportSelectionOnly);
  end;
end;

procedure TProjectOptions.SetExportSeparator(ModelHandle : ANE_PTR; const Value: char);
Var
  ANEValue : ANE_STR;
begin
  ANEValue := PChar(Value);
  if not ANE_PropertySet(ModelHandle, PChar(kExportSeparator) , kPIEString, @ANEValue) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kExportSeparator);
  end;
end;

procedure TProjectOptions.SetExportTitles(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kExportTitles), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kExportTitles);
  end;
end;

procedure TProjectOptions.SetExportWrap(ModelHandle : ANE_PTR; const Value: ANE_INT32);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kExportWrap) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kExportWrap);
  end;
end;

procedure TProjectOptions.SetIncludeDiagonal(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kIncludeDiagonal), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kIncludeDiagonal);
  end;
end;

procedure TProjectOptions.SetMaxAngle(ModelHandle : ANE_PTR; const Value: ANE_DOUBLE);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kMaxAngle), kPIEFloat, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kMaxAngle);
  end;
end;

procedure TProjectOptions.SetMaxEdgeGrowth(ModelHandle : ANE_PTR; const Value: ANE_INT32);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kMaxEdgeGrowth) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kMaxEdgeGrowth);
  end;
end;

procedure TProjectOptions.SetMeshWithWells(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kMeshWithWells), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kMeshWithWells);
  end;
end;

procedure TProjectOptions.SetMinAngle(ModelHandle : ANE_PTR; const Value: ANE_DOUBLE);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kMinAngle), kPIEFloat, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kMinAngle);
  end;
end;

procedure TProjectOptions.SetNodeLinePrefix(ModelHandle : ANE_PTR; const Value: char);
Var
  ANEValue : ANE_STR;
begin
  ANEValue := PChar(Value);
  if not ANE_PropertySet(ModelHandle, PChar(kNodeLinePrefix) , kPIEString, @ANEValue) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kNodeLinePrefix);
  end;
end;

procedure TProjectOptions.SetNumSmoothIterations(ModelHandle : ANE_PTR; const Value: ANE_INT32);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kNumSmoothIterations) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kNumSmoothIterations);
  end;
end;

procedure TProjectOptions.SetQuadriClear(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kQuadriClear), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kQuadriClear);
  end;
end;

procedure TProjectOptions.SetRemovePoints(ModelHandle : ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kRemovePoints), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kRemovePoints);
  end;
end;

procedure TProjectOptions.SetSmallSegmentAffectDensity(ModelHandle : ANE_PTR;
  const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kSmallSegmentAffectDensity), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kSmallSegmentAffectDensity);
  end;
end;

procedure TProjectOptions.SetW2WDistanceAffectDensity(ModelHandle : ANE_PTR; 
  const Value: ANE_BOOL);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kW2WDistanceAffectDensity), kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kW2WDistanceAffectDensity);
  end;
end;

procedure TProjectOptions.SetW2WThreshold(ModelHandle : ANE_PTR; const Value: ANE_INT32);
begin
  if not ANE_PropertySet(ModelHandle, PChar(kW2WThreshold) , kPIEInteger, @Value) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kW2WThreshold);
  end;
end;

procedure TProjectOptions.SetCurrentLayer(ModelHandle : ANE_PTR; const Value: ANE_PTR);
begin
  ANE_LayerSetCurrent(ModelHandle, Value)
end;

function TProjectOptions.GetLayerByName(ModelHandle : ANE_PTR; Name: string): ANE_PTR;
var
  ANE_LayerNameStr : ANE_STR;
begin
//  AnANE_STR := PChar(Name);
  GetMem(ANE_LayerNameStr, Length(Name) + 1);
  try
    StrPCopy(ANE_LayerNameStr,Name);
    result := GetLayerByName(ModelHandle, ANE_LayerNameStr);
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(ANE_LayerNameStr);
  end;
//  result := GetLayerByName(ModelHandle, PChar(Name));
end;

function TProjectOptions.GetLayerByName(ModelHandle : ANE_PTR; Name: ANE_STR): ANE_PTR;
begin
  result := ANE_LayerGetHandleByName(ModelHandle, Name );
end;

function TProjectOptions.GetProjectName(ModelHandle : ANE_PTR): string;
Var
  AneResult : ANE_STR;
begin
    if not ANE_PropertyGet(ModelHandle, PChar(kProjectName) , kPIEString, @AneResult) then
    begin
      raise EArgusPropertyError.Create('Error getting ' + kProjectName);
    end;
    result := String(AneResult);
end;

function TProjectOptions.GetLayerByIndex(const ModelHandle: ANE_PTR;
  const index: ANE_INT32): ANE_PTR;
begin
  result := ANE_LayerGetHandleByIndex(ModelHandle, index);
end;

{ TParameterOptions }

constructor TParameterOptions.Create(const LayerHandle: ANE_PTR;
  ParameterIndex : ANE_INT32);
begin
  inherited Create;
  Assert(ParameterIndex >= 0);
//  FModelHandle := ModelHandle;
  FLayerHandle := LayerHandle;
  FParameterIndex := ParameterIndex;
end;

constructor TParameterOptions.CreateWithName(const LayerHandle,
  ModelHandle: ANE_PTR; ParameterName : String);
var
  Layer : TLayerOptions;
begin
  Layer := TLayerOptions.Create(LayerHandle);
  try
    CreateWithNameAndLayer(Layer,ParameterName,ModelHandle);
  finally
    Layer.Free(ModelHandle);
  end;
end;

constructor TParameterOptions.CreateWithNameAndLayer(const Layer: TLayerOptions;
  ParameterName : String; ModelHandle: ANE_PTR);
var
  ParameterIndex : ANE_INT32;
begin
  ParameterIndex := Layer.GetParameterIndex(ModelHandle,ParameterName);
  Create (Layer.LayerHandle, ParameterIndex);
end;

function TParameterOptions.GetExpr(ModelHandle: ANE_PTR) : string;
var
  AnANE_STR : ANE_STR;
begin

  if not ANE_LayerParameterPropertyGet(ModelHandle, FParameterIndex, FLayerHandle,
         PChar(kExpr), kPIEString, @AnANE_STR) then
  begin
    ShowMessage('Error getting ' + kExpr);
    raise EArgusPropertyError.Create('Error getting ' + kExpr);
  end;
  result := String(AnANE_STR);
end;

function TParameterOptions.GetLock(ModelHandle: ANE_PTR): string;
var
  AnANE_STR : ANE_STR;
begin
  if not ANE_LayerParameterPropertyGet(ModelHandle, FParameterIndex, FLayerHandle,
         PChar(kLock), kPIEString, @AnANE_STR) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kLock);
  end;
  result := String(AnANE_STR);
end;

function TParameterOptions.GetLockSet(ModelHandle: ANE_PTR): TParamLock;
begin
  result := StringToLock(Lock[ModelHandle]);
end;

function TParameterOptions.GetName(ModelHandle: ANE_PTR): string;
var
  AnANE_STR : ANE_STR;
begin
  if not ANE_LayerParameterPropertyGet(ModelHandle, FParameterIndex, FLayerHandle,
         PChar(kName), kPIEString, @AnANE_STR) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kName);
  end;
  result := String(AnANE_STR);
end;

function TParameterOptions.GetNumberType(ModelHandle: ANE_PTR): TPIENumberType;
var
  AnInteger : EPIENumberType;
begin
  if not ANE_LayerParameterPropertyGet(ModelHandle, FParameterIndex, FLayerHandle,
         PChar(kType), kPIEInteger, @AnInteger) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kType);
  end;
  case AnInteger of
    kPIEBoolean:
      begin
        result := pnBoolean;
      end;
    kPIEInteger:
      begin
        result := pnInteger;
      end;
    kPIEFloat  :
      begin
        result := pnFloat;
      end;
    kPIEString :
      begin
        result := pnString;
      end;
    kPIENA     :
      begin
        result := pnNA;
      end;
  else
    begin
      raise EArgusPropertyError.Create('Error getting ' + kType);
    end;
  end;

end;

function TParameterOptions.GetNumberTypeString(ModelHandle: ANE_PTR): String;
var
  AnANE_STR : ANE_STR;
begin
  if not ANE_LayerParameterPropertyGet(ModelHandle, FParameterIndex, FLayerHandle,
         PChar(kTypeString), kPIEString, @AnANE_STR) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kTypeString);
  end;
  result := String(AnANE_STR);
end;

function TParameterOptions.GetParameterType(ModelHandle: ANE_PTR): TPIEParameterType;
var
  AnInteger : EPIEParameterType;
begin
  if not ANE_LayerParameterPropertyGet(ModelHandle, FParameterIndex, FLayerHandle,
         PChar(kParamType), kPIEInteger, @AnInteger) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kParamType);
  end;
  case AnInteger of
    kPIENullSubParam:
      begin
        result := pieNullSubParam;
      end;
    kPIELayerSubParam:
      begin
        result := pieLayerSubParam;
      end;
    kPIEMeshLayerSubParam  :
      begin
        result := pieMeshLayerSubParam;
      end;
    kPIEGridLayerSubParam :
      begin
        result := pieGridLayerSubParam;
      end;
    kPIEContourLayerSubParam     :
      begin
        result := pieContourLayerSubParam;
      end;
    kPIEPictLayerSubParam     :
      begin
        result := piePictLayerSubParam;
      end;
    kPIEElemSubParam     :
      begin
        result := pieElemSubParam;
      end;
    kPIENodeSubParam     :
      begin
        result := pieNodeSubParam;
      end;
    kPIEBlockSubParam     :
      begin
        result := pieBlockSubParam;
      end;
    kPIEVertexSubParam     :
      begin
        result := pieVertexSubParam;
      end;
    kPIEGeneralSubParam     :
      begin
        result := pieGeneralSubParam;
      end;
  else
    begin
      raise EArgusPropertyError.Create('Error getting ' + kParamType);
    end;
  end;

end;

function TParameterOptions.GetUnits(ModelHandle: ANE_PTR): string;
var
  AnANE_STR : ANE_STR;
begin
  if not ANE_LayerParameterPropertyGet(ModelHandle, FParameterIndex, FLayerHandle,
         PChar(kUnits), kPIEString, @AnANE_STR) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kUnits);
  end;
  result := String(AnANE_STR);
end;

function TParameterOptions.Rename(ModelHandle: ANE_PTR;
  NewName: string): boolean;
var
  NewName_Str : ANE_STR;
begin
  GetMem(NewName_Str, Length(NewName) + 1);
  try
    StrPCopy(NewName_Str,NewName);
    result := ANE_LayerRenameParameter(ModelHandle, FLayerHandle,
      FParameterIndex, NewName_Str);
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(NewName_Str);
  end;
end;

function TParameterOptions.Rename(ModelHandle: ANE_PTR;
  NewName: ANE_STR): boolean;
begin
  result := ANE_LayerRenameParameter(ModelHandle, FLayerHandle,
    FParameterIndex, NewName);
end;

procedure TParameterOptions.SetExpr(ModelHandle: ANE_PTR; const Value: string);
var
  AnANE_STR : ANE_STR;
begin
//  AnANE_STR := PChar(Value);
  GetMem(AnANE_STR, Length(Value) + 1);
  try
    StrPCopy(AnANE_STR, Value);
    ANE_LayerSetParameterExpression(ModelHandle, FLayerHandle, FParameterIndex,
      AnANE_STR );
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(AnANE_STR)
  end;

{  if not ANE_LayerParameterPropertySet(ModelHandle, FParameterIndex, FLayerHandle,
         PChar(kExpr), kPIEString, AnANE_STR) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kExpr);
  end; }
end;

procedure TParameterOptions.SetLock(ModelHandle: ANE_PTR; const Value: string);
var
  AnANE_STR : ANE_STR;
begin
//  AnANE_STR := PChar(Value);
  GetMem(AnANE_STR, Length(Value) + 1);
  try
    StrPCopy(AnANE_STR, Value);
    if not ANE_LayerParameterPropertySet(ModelHandle, FParameterIndex, FLayerHandle,
           PChar(kLock), kPIEString, AnANE_STR) then
    begin
      raise EArgusPropertyError.Create('Error setting ' + kLock);
    end;
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(AnANE_STR)
  end;
end;

procedure TParameterOptions.SetLockSet(ModelHandle: ANE_PTR;
  const Value: TParamLock);
begin
  Lock[ModelHandle] := LockToString(Value);
end;

procedure TParameterOptions.SetMinusLock(ModelHandle: ANE_PTR; const Value: string);
var
  AnANE_STR : ANE_STR;
begin
//  AnANE_STR := PChar(Value);
  GetMem(AnANE_STR, Length(Value) + 1);
  try
    StrPCopy(AnANE_STR, Value);
    if not ANE_LayerParameterPropertySet(ModelHandle, FParameterIndex, FLayerHandle,
           PChar(kMinusLock), kPIEString, AnANE_STR) then
    begin
      raise EArgusPropertyError.Create('Error setting ' + kMinusLock);
    end;
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(AnANE_STR)
  end;
end;

procedure TParameterOptions.SetMinusLockSet(ModelHandle: ANE_PTR;
  const Value: TParamLock);
begin
  MinusLock[ModelHandle] := LockToString(Value);
end;

procedure TParameterOptions.SetName(ModelHandle: ANE_PTR; const Value: string);
var
  AnANE_STR : ANE_STR;
begin
//  AnANE_STR := PChar(Value);
  GetMem(AnANE_STR, Length(Value) + 1);
  try
    StrPCopy(AnANE_STR, Value);
    if not ANE_LayerParameterPropertySet(ModelHandle, FParameterIndex, FLayerHandle,
           PChar(kName), kPIEString, AnANE_STR) then
    begin
      raise EArgusPropertyError.Create('Error setting ' + kName);
    end;
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(AnANE_STR)
  end;
end;

procedure TParameterOptions.SetPlusLock(ModelHandle: ANE_PTR; const Value: string);
var
  AnANE_STR : ANE_STR;
begin
//  AnANE_STR := PChar(Value);
  GetMem(AnANE_STR, Length(Value) + 1);
  try
    StrPCopy(AnANE_STR, Value);
    if not ANE_LayerParameterPropertySet(ModelHandle, FParameterIndex, FLayerHandle,
           PChar(kPlusLock), kPIEString, AnANE_STR) then
    begin
      raise EArgusPropertyError.Create('Error setting ' + kPlusLock);
    end;
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(AnANE_STR)
  end;
end;

procedure TParameterOptions.SetPlusLockSet(ModelHandle: ANE_PTR;
  const Value: TParamLock);
begin
  PlusLock[ModelHandle] := LockToString(Value);
end;

procedure TParameterOptions.SetUnits(ModelHandle: ANE_PTR; const Value: string);
var
  AnANE_STR : ANE_STR;
begin
//  AnANE_STR := PChar(Value);
  GetMem(AnANE_STR, Length(Value) + 1);
  try
    StrPCopy(AnANE_STR, Value);
    if not ANE_LayerParameterPropertySet(ModelHandle, FParameterIndex, FLayerHandle,
           PChar(kUnits), kPIEString, AnANE_STR) then
    begin
      raise EArgusPropertyError.Create('Error setting ' + kUnits);
    end;
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(AnANE_STR)
  end;
end;

{ TLayerOptions }


function TLayerOptions.ClearLayer(ModelHandle: ANE_PTR; SelectedOnly: ANE_BOOL): ANE_BOOL;
begin
  result := ANE_LayerClear(ModelHandle,  FLayerHandle, selectedOnly );
end;

constructor TLayerOptions.Create(const LayerHandle: ANE_PTR);
begin
  inherited Create;
  FParsedExpression := nil;
  if LayerHandle = nil then
  begin
    raise EInvalidLayerHandle.Create('Invalid Layer handle');
  end;
  FLayerHandle := LayerHandle;
  ParsedExpressionList := TStringList.Create;
end;

function TLayerOptions.GetAllowIntersection(ModelHandle: ANE_PTR ) : ANE_BOOL;
begin
  if not ANE_LayerPropertyGet(ModelHandle,FLayerHandle,
    PChar(kAllowIntersection),kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kAllowIntersection);
  end;
end;

function TLayerOptions.GetName(ModelHandle: ANE_PTR) : String;
var
  ResultPChar : ANE_STR;
begin
  if not ANE_LayerPropertyGet(ModelHandle,FLayerHandle,
    PChar(kNameProp),kPIEString, @ResultPChar) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kAllowIntersection);
  end;
  result := String(ResultPChar);
end;

Procedure TLayerOptions.GetParameterNames(ModelHandle: ANE_PTR;
  Names : TStrings);
var
  ParamCount : integer;
  ParamIndex : ANE_INT32;
begin
  Names.Clear;
  ParamCount := NumParameters(ModelHandle, pieGeneralSubParam);
  for ParamIndex := 0 to ParamCount-1 do
  begin
    Names.Add(GetParameterName(ModelHandle, ParamIndex));
  end;
end;

function TLayerOptions.GetParameterName(ModelHandle: ANE_PTR;
  ParameterIndex : ANE_INT32) : string;
var
  Parameter : TParameterOptions;
begin
  Parameter := TParameterOptions.Create(LayerHandle, ParameterIndex);
  try
    result := Parameter.Name[ModelHandle];
  finally
    Parameter.Free;
  end;
end;

function TLayerOptions.GetCoordScale(ModelHandle: ANE_PTR ): ANE_DOUBLE;
begin
  if not ANE_LayerPropertyGet(ModelHandle,FLayerHandle,
    PChar(kCoordScale),kPIEFloat, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCoordScale);
  end;
end;

function TLayerOptions.GetCoordUnits(ModelHandle: ANE_PTR ): string;
var
  AnANE_STR : ANE_STR;
begin
  if not ANE_LayerPropertyGet(ModelHandle,FLayerHandle,
    PChar(kCoordUnits),kPIEString, @AnANE_STR) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCoordUnits);
  end;
  result := string(AnANE_STR);
end;


function TLayerOptions.GetCoordXRight(ModelHandle: ANE_PTR ): ANE_BOOL;
begin
  if not ANE_LayerPropertyGet(ModelHandle,FLayerHandle,
    PChar(kCoordXRight),kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCoordXRight);
  end;
end;

function TLayerOptions.GetCoordXYRatio(ModelHandle: ANE_PTR ): ANE_DOUBLE;
begin
  if not ANE_LayerPropertyGet(ModelHandle,FLayerHandle,
    PChar(kCoordXYRatio),kPIEFloat, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCoordXYRatio);
  end;
end;

function TLayerOptions.GetCoordYUp(ModelHandle: ANE_PTR ): ANE_BOOL;
begin
  if not ANE_LayerPropertyGet(ModelHandle,FLayerHandle,
    PChar(kCoordYUp),kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kCoordYUp);
  end;
end;

function TLayerOptions.GetGridReverseXDirection(ModelHandle: ANE_PTR ): ANE_BOOL;
begin
  if not ANE_LayerPropertyGet(ModelHandle,FLayerHandle,
    PChar(kGridReverseXDirection),kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kGridReverseXDirection);
  end;
end;

function TLayerOptions.GetGridReverseYDirection(ModelHandle: ANE_PTR ): ANE_BOOL;
begin
  if not ANE_LayerPropertyGet(ModelHandle,FLayerHandle,
    PChar(kGridReverseYDirection),kPIEBoolean, @result) then
  begin
    raise EArgusPropertyError.Create('Error getting ' + kGridReverseYDirection);
  end;
end;

function TLayerOptions.GetParameterIndex(ModelHandle: ANE_PTR; ParameterName: string): ANE_INT32;
begin
  result := GetParameterIndex(ModelHandle, PChar(ParameterName));
end;

function TLayerOptions.GetParameterIndex(ModelHandle: ANE_PTR; ParameterName: ANE_STR): ANE_INT32;
begin
  result := ANE_LayerGetParameterByName(ModelHandle,FLayerHandle,
    ParameterName);
end;

function TLayerOptions.GetLayerType(ModelHandle: ANE_PTR ): TPIELayerType;
var
  ThisLayer : EPIELayerType;
begin
  ThisLayer := ANE_LayerGetType(ModelHandle,FLayerHandle);
  case ThisLayer of
   kPIETriMeshLayer     :
     begin
       result := pieTriMeshLayer;
     end;
   kPIEQuadMeshLayer    :
     begin
       result := pieQuadMeshLayer;
     end;
   kPIEInformationLayer :
     begin
       result := pieInformationLayer;
     end;
   kPIEGridLayer	:
     begin
       result := pieGridLayer;
     end;
   kPIEDataLayer	:
     begin
       result := pieDataLayer;
     end;
   kPIEMapsLayer	:
     begin
       result := pieMapsLayer;
     end;
   kPIEDomainLayer      :
     begin
       result := pieDomainLayer;
     end;
   kPIEGroupLayer :
     begin
       result := pieGroupLayer;
     end;
  else ;
    raise EArgusPropertyError.Create('Error getting Layer type');
  end;


end;

function TLayerOptions.NumObjects(ModelHandle: ANE_PTR;
  ObjectType: TPIEObjectType): ANE_INT32;
var
  ArgusObjectType : EPIEObjectType;
begin
  case ObjectType of
    pieContourObject:
      begin
        ArgusObjectType := kPIEContourObject;
      end;
    pieBlockObject:
      begin
        ArgusObjectType := kPIEBlockObject;
      end;
    pieElementObject:
      begin
        ArgusObjectType := kPIEElementObject;
      end;
    pieNodeObject:
      begin
        ArgusObjectType := kPIENodeObject;
      end;
    piePictObject:
      begin
        ArgusObjectType := kPIEPictObject;
      end;
    pieDataPointObject:
      begin
//        ArgusObjectType := $0020;
        ArgusObjectType := kPIEDataPointObject;
      end;
    else
      begin
        raise EArgusPropertyError.Create('Error getting number of objects');
      end;
  end;
  result := ANE_LayerGetNumObjects(ModelHandle,FLayerHandle, ArgusObjectType);

end;

function TLayerOptions.NumParameters(ModelHandle: ANE_PTR ;
  ParameterType: TPIEParameterType): ANE_INT32;
var
  ArgusParameterType : EPIEParameterType;
begin
  case ParameterType of
    pieNullSubParam:
      begin
        ArgusParameterType := kPIENullSubParam;
      end;
    pieLayerSubParam:
      begin
        ArgusParameterType := kPIELayerSubParam;
      end;
    pieMeshLayerSubParam:
      begin
        ArgusParameterType := kPIEMeshLayerSubParam;
      end;
    pieGridLayerSubParam:
      begin
        ArgusParameterType := kPIEGridLayerSubParam;
      end;
    pieContourLayerSubParam:
      begin
        ArgusParameterType := kPIEContourLayerSubParam;
      end;
    piePictLayerSubParam:
      begin
        ArgusParameterType := kPIEPictLayerSubParam;
      end;
    pieElemSubParam:
      begin
        ArgusParameterType := kPIEElemSubParam;
      end;
    pieNodeSubParam:
      begin
        ArgusParameterType := kPIENodeSubParam;
      end;
    pieBlockSubParam:
      begin
        ArgusParameterType := kPIEBlockSubParam;
      end;
    pieVertexSubParam:
      begin
        ArgusParameterType := kPIEVertexSubParam;
      end;
    pieGeneralSubParam:
      begin
        ArgusParameterType := kPIEGeneralSubParam;
      end;
    else
      begin
        raise EArgusPropertyError.Create('Error getting number of parameters');
      end;
  end;

  result := ANE_LayerGetNumParameters(ModelHandle,FLayerHandle,
          ArgusParameterType)
end;

function TLayerOptions.Remove(ModelHandle: ANE_PTR; forceRemoval: ANE_BOOL): ANE_BOOL;
begin
  result := ANE_LayerRemove(ModelHandle,FLayerHandle,forceRemoval );
end;

procedure TLayerOptions.Rename(ModelHandle: ANE_PTR; NewName: string);
var
  NewName_Str : ANE_STR;
begin
  GetMem(NewName_Str, Length(newName) + 1);
  try
    StrPCopy(NewName_Str,newName);
    if not  ANE_LayerRename(ModelHandle, FLayerHandle, NewName_Str) then
    begin
      raise EArgusPropertyError.Create('Error renaming layer to  ' + NewName);
    end;
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(NewName_Str);
  end;
end;

procedure TLayerOptions.SetAllowIntersection(ModelHandle: ANE_PTR; const Value: ANE_BOOL);
begin

    if not ANE_LayerPropertySet(ModelHandle,FLayerHandle,
      PChar(kAllowIntersection),kPIEBoolean, @Value) then
    begin
      raise EArgusPropertyError.Create('Error setting ' + kAllowIntersection);
    end;
end;

procedure TLayerOptions.SetName(ModelHandle: ANE_PTR; const Name: String);
var
  NameAne_Str : ANE_STR;
begin
//  NameAne_Str := PChar(Name);
  GetMem(NameAne_Str, Length(Name) + 1);
  try
    StrPCopy(NameAne_Str, Name);
    if not ANE_LayerPropertySet(ModelHandle,FLayerHandle,
      PChar(kNameProp),kPIEString, @NameAne_Str) then
    begin
      raise EArgusPropertyError.Create('Error setting ' + kNameProp);
    end;
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(NameAne_Str);
  end;
end;

procedure TLayerOptions.SetGridReverseXDirection(ModelHandle: ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_LayerPropertySet(ModelHandle,FLayerHandle,
    PChar(kGridReverseXDirection),kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kGridReverseXDirection);
  end;
end;

procedure TLayerOptions.SetGridReverseYDirection(ModelHandle: ANE_PTR; const Value: ANE_BOOL);
begin
  if not ANE_LayerPropertySet(ModelHandle,FLayerHandle,
    PChar(kGridReverseYDirection),kPIEBoolean, @Value) then
  begin
    raise EArgusPropertyError.Create('Error setting ' + kGridReverseYDirection);
  end;
end;

function TLayerOptions.GetText(ModelHandle: ANE_PTR): string;
var
  AnANE_STR : ANE_STR;
begin
  ANE_ExportTextFromOtherLayer(ModelHandle, FLayerHandle, @AnANE_STR );
  result := string(AnANE_STR);
end;

procedure TLayerOptions.GetStrings(ModelHandle: ANE_PTR; Strings: TStrings);
begin
  Strings.Text := Text[ModelHandle];
end;

procedure TLayerOptions.SetText(ModelHandle: ANE_PTR; const Value: String);
var
  AString : ANE_STR;
begin
  GetMem(AString, Length(Value) + 1);
  try
    StrPCopy(AString, Value);

    ANE_ImportTextToLayerByHandle(ModelHandle, FLayerHandle, AString);
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(AString);
  end;
//  ANE_ImportTextToLayerByHandle(ModelHandle, FLayerHandle, PChar(Value));
end;

function TLayerOptions.NthObject(ModelHandle: ANE_PTR; ObjectType: TPIEObjectType;
  Index: ANE_INT32): ANE_PTR;
var
  PIEObjectType : EPIEObjectType;
begin
  case ObjectType of
    pieContourObject:
      begin
        PIEObjectType := kPIEContourObject;
      end ;
    pieBlockObject:
      begin
        PIEObjectType := kPIEBlockObject;
      end ;
    pieElementObject:
      begin
        PIEObjectType := kPIEElementObject;
      end ;
    pieNodeObject:
      begin
        PIEObjectType := kPIENodeObject;
      end ;
    piePictObject:
      begin
        PIEObjectType := kPIEPictObject;
      end ;
  else
    begin
      raise EArgusPropertyError.Create('Error getting Object Handle');
    end;
  end;

  result := ANE_LayerGetNthObjectHandle (ModelHandle, FLayerHandle,
          PIEObjectType, Index);
end;

function TLayerOptions.BooleanValueAtXY(ModelHandle : ANE_PTR; X, Y: ANE_DOUBLE;
  Expression: String): ANE_BOOL;
begin
  if Expression <> '' then
  begin
    ParseExpression(ModelHandle, Expression,pnBoolean);
  end;
  ANE_EvaluateParsedExpressionAtPos(ModelHandle, FParsedExpression,
    @x, @y, @Result);
end;

{procedure TLayerOptions.FreeParsedExpression(ModelHandle : ANE_PTR) ;
begin
  if FParsedExpression <> nil then
  begin
    ANE_FreeParsedExpression(ModelHandle,FParsedExpression);
    FParsedExpression := nil;
  end;
end; }

function TLayerOptions.IntegerValueAtXY(ModelHandle : ANE_PTR; X, Y: ANE_DOUBLE;
  Expression: String): ANE_INT32;
begin
  if Expression <> '' then
  begin
    ParseExpression(ModelHandle, Expression,pnInteger);
  end;
  ANE_EvaluateParsedExpressionAtPos(ModelHandle, FParsedExpression,
    @x, @y, @Result);
end;

function TLayerOptions.RealValueAtXY(ModelHandle : ANE_PTR; X, Y: ANE_DOUBLE;
  Expression: String): ANE_DOUBLE;
var
  LocalX, LocalY, LocalResult : ANE_DOUBLE;
begin
  if Expression <> '' then
  begin
    ParseExpression(ModelHandle, Expression,pnFloat);
  end;
  LocalX := X;
  LocalY := Y;
  ANE_EvaluateParsedExpressionAtPos(ModelHandle, FParsedExpression,
    @LocalX, @LocalY, @LocalResult);
  result := LocalResult;
end;

function TLayerOptions.ANEStringValueAtXY(ModelHandle : ANE_PTR; X, Y: ANE_DOUBLE;
  Expression: String): ANE_STR;
var
  AnANE_STR : ANE_STR;
begin
  if Expression <> '' then
  begin
    ParseExpression(ModelHandle, Expression,pnString);
  end;
  ANE_EvaluateParsedExpressionAtPos(ModelHandle, FParsedExpression,
    @x, @y, @AnANE_STR);
  result := AnANE_STR;
end;

function TLayerOptions.StringValueAtXY(ModelHandle : ANE_PTR; X, Y: ANE_DOUBLE;
  Expression: String): string;
begin
  result := String(ANEStringValueAtXY(ModelHandle, X, Y, Expression));
end;

procedure TLayerOptions.ClearParsedExpressions(ModelHandle : ANE_PTR);
var
  Index : integer;
  ParsedExpressionObject : TParsedExpressionObject;
begin
  if ParsedExpressionList <> nil then
  begin
    for Index := 0 to ParsedExpressionList.Count - 1 do
    begin
      ParsedExpressionObject := ParsedExpressionList.Objects[Index] as TParsedExpressionObject;
      ANE_FreeParsedExpression(ModelHandle,ParsedExpressionObject.ParsedExpression);
      ParsedExpressionObject.Free;
    end;
    ParsedExpressionList.Clear;
  end;
  FParsedExpression := nil;
end;

destructor TLayerOptions.Destroy ;
begin
  ClearParsedExpressions(OptionsModelHandle);
  ParsedExpressionList.Free;
  inherited;
end;

Procedure TLayerOptions.Free(ModelHandle : ANE_PTR) ;
begin
  Assert((self = nil) or (ModelHandle <> nil));
  OptionsModelHandle := ModelHandle;
  inherited Free;
end;


procedure TLayerOptions.ParseExpression(ModelHandle : ANE_PTR; Expression: String ;
  NumberType : TPIENumberType);
var
  LocalExpression : ANE_STR;
  ParsedExpressionObject : TParsedExpressionObject;
  Index : integer;
begin
  Index := ParsedExpressionList.IndexOf(Expression);
  if Index <> -1 then
  begin
    ParsedExpressionObject := ParsedExpressionList.Objects[Index] as TParsedExpressionObject;
    FParsedExpression := ParsedExpressionObject.ParsedExpression;
  end
  else
  begin
//    LocalExpression := PChar(Expression);
    GetMem(LocalExpression, Length(Expression) + 1);
    try
      StrPCopy(LocalExpression,Expression);

      case NumberType of
        pnBoolean:
          begin
            FParsedExpression := ANE_ParseExpression(ModelHandle, FLayerHandle,
              kPIEBoolean, LocalExpression);
          end;
        pnInteger:
          begin
            FParsedExpression := ANE_ParseExpression(ModelHandle, FLayerHandle,
              kPIEInteger, LocalExpression);
          end;
        pnFloat:
          begin
            FParsedExpression := ANE_ParseExpression(ModelHandle, FLayerHandle,
              kPIEFloat, LocalExpression);
          end;
        pnString:
          begin
            FParsedExpression := ANE_ParseExpression(ModelHandle, FLayerHandle,
              kPIEString, LocalExpression);
          end;
      else ;
        begin
          Assert(False);
        end;
      end;
      ANE_ProcessEvents(ModelHandle);
      ParsedExpressionObject := TParsedExpressionObject.Create;
    finally
      FreeMem(LocalExpression);
    end;
    ParsedExpressionObject.ParsedExpression := FParsedExpression;
    ParsedExpressionList.AddObject(Expression,ParsedExpressionObject);
  end;
end;

{ TNodeObjectOptions }

{constructor TNodeObjectOptions.Create(const ModelHandle, layerHandle: ANE_PTR;
  objectIndex: ANE_INT32);
begin
    FModelHandle := ModelHandle;
    FLayerHandle := layerHandle;
    FObjectHandle := ANE_LayerGetNthObjectHandle (FModelHandle,
         FLayerHandle, kPIENodeObject, objectIndex);
end; }

{function TNodeObjectOptions.GetBoolParameter
  (ParameterIndex: ANE_INT16): ANE_BOOL;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_BOOL_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of SmallInt;
begin
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEBoolean;
  GetMem(values[0], SizeOf(ANE_BOOL));
  try
    ANE_LayerGetObjectInfo(FModelHandle, FLayerHandle, kPIENodeObject,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
    result_ptr :=  values[0];
    result :=  result_ptr^;
  finally
    FreeMem(values[0]);
  end;
end;}

{function TNodeObjectOptions.GetFloatParameter(
  ParameterIndex: ANE_INT16): ANE_DOUBLE;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_DOUBLE_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of SmallInt;
begin
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEFloat;
  GetMem(values[0], SizeOf(ANE_DOUBLE));
  try
    ANE_LayerGetObjectInfo(FModelHandle, FLayerHandle, kPIENodeObject,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
    result_ptr :=  values[0];
    result :=  result_ptr^;
  finally
    FreeMem(values[0]);
  end;
end;   }

{function TNodeObjectOptions.GetIntegerParameter(
  ParameterIndex: ANE_INT16): ANE_INT32;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_INT32_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of SmallInt;
begin
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEInteger;
  GetMem(values[0], SizeOf(ANE_INT32));
  try
    ANE_LayerGetObjectInfo(FModelHandle, FLayerHandle, kPIENodeObject,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
    result_ptr :=  values[0];
    result :=  result_ptr^;
  finally
    FreeMem(values[0]);
  end;
end; }

procedure TNodeObjectOptions.GetLocation(ModelHandle : ANE_PTR;
  var X, Y: ANE_DOUBLE);
begin
  ANE_NodeObjectGetLocation(ModelHandle, FLayerHandle, FObjectHandle, @X, @Y);
end;

function TNodeObjectOptions.GetObjectType: EPIEObjectType;
begin
  result := kPIENodeObject;
end;

{function TNodeObjectOptions.GetStringParameter(
  ParameterIndex: ANE_INT16): string;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_STR_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of SmallInt;
begin
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEString;
  GetMem(values[0], SizeOf(ANE_STR));
  try
    ANE_LayerGetObjectInfo(FModelHandle, FLayerHandle, kPIENodeObject,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
    result_ptr :=  values[0];
    result :=  String(result_ptr^);
  finally
    FreeMem(values[0]);
  end;
end; }

constructor TLayerOptions.CreateWithName(const LayerName: string; ModelHandle : ANE_PTR);
var
  LayerHandle : ANE_PTR;
  Project : TProjectOptions;
begin
  OptionsModelHandle := ModelHandle;
  Project := TProjectOptions.Create;
  try
    try
      LayerHandle := Project.GetLayerByName(ModelHandle,LayerName);
      Create(LayerHandle);
    except on EInvalidLayerHandle do
      begin
        raise EInvalidLayerHandle.Create('Error: the layer "'
          + LayerName + '" does not exist.');
      end;
    end;
  finally
    Project.Free;
  end;

end;

function TLayerOptions.RealValue(const ModelHandle: ANE_PTR;
  const StringToEvaluate: string): ANE_DOUBLE;
var
  STR : ANE_STR;
begin
  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(ModelHandle,LayerHandle,kPIEFloat,
       STR,@result );
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(STR);
  end;
end;

function TLayerOptions.IntegerValue(const ModelHandle: ANE_PTR;
  const StringToEvaluate: string): ANE_INT32;
var
  STR : ANE_STR;
begin
  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(ModelHandle,LayerHandle,kPIEInteger,
       STR,@result );
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(STR);
  end;
end;

function TLayerOptions.BooleanValue(const ModelHandle: ANE_PTR;
  const StringToEvaluate: string): ANE_BOOL;
var
  STR : ANE_STR;
begin
  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(ModelHandle,LayerHandle,kPIEBoolean,
       STR,@result );
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(STR);
  end;
end;

function TLayerOptions.StringValue(const ModelHandle: ANE_PTR;
  const StringToEvaluate: string): string;
var
  AnANE_STR : ANE_STR;
  STR : ANE_STR;
begin
  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(ModelHandle,LayerHandle,kPIEString,
       STR,@AnANE_STR );
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(STR);
  end;
  result := string(AnANE_STR);
end;

procedure TLayerOptions.InvalidateCache(ModelHandle: ANE_PTR);
begin
  ANE_InvalidateCache(ModelHandle, LayerHandle);
end;

function TLayerOptions.NumParameters(ModelHandle: ANE_PTR;
  ParameterTypes: TPIEParameterTypes): ANE_INT32;
var
  ArgusParameterType : EPIEParameterType;
begin
  ArgusParameterType := 0;
  if pieNullSubParam in ParameterTypes then
  begin
    ArgusParameterType := ArgusParameterType or kPIENullSubParam;
  end;
  if pieLayerSubParam in ParameterTypes then
  begin
    ArgusParameterType := ArgusParameterType or kPIELayerSubParam;
  end;
  if pieMeshLayerSubParam in ParameterTypes then
  begin
    ArgusParameterType := ArgusParameterType or kPIEMeshLayerSubParam;
  end;
  if pieGridLayerSubParam in ParameterTypes then
  begin
    ArgusParameterType := ArgusParameterType or kPIEGridLayerSubParam;
  end;
  if pieContourLayerSubParam in ParameterTypes then
  begin
    ArgusParameterType := ArgusParameterType or kPIEContourLayerSubParam;
  end;
  if piePictLayerSubParam in ParameterTypes then
  begin
    ArgusParameterType := ArgusParameterType or kPIEPictLayerSubParam;
  end;
  if pieElemSubParam in ParameterTypes then
  begin
    ArgusParameterType := ArgusParameterType or kPIEElemSubParam;
  end;
  if pieNodeSubParam in ParameterTypes then
  begin
    ArgusParameterType := ArgusParameterType or kPIENodeSubParam;
  end;
  if pieBlockSubParam in ParameterTypes then
  begin
    ArgusParameterType := ArgusParameterType or kPIEBlockSubParam;
  end;
  if pieVertexSubParam in ParameterTypes then
  begin
    ArgusParameterType := ArgusParameterType or kPIEVertexSubParam;
  end;
  if pieGeneralSubParam in ParameterTypes then
  begin
    ArgusParameterType := ArgusParameterType or kPIEGeneralSubParam;
  end;

  result := ANE_LayerGetNumParameters(ModelHandle,FLayerHandle,
          ArgusParameterType)

end;

{ TElementObjectOptions }

constructor TElementObjectOptions.Create(ModelHandle : ANE_PTR; const
  layerHandle: ANE_PTR; objectIndex: ANE_INT32);
begin
  inherited Create(ModelHandle, layerHandle, objectIndex);
    FObjectIndex := objectIndex;
{    FModelHandle := ModelHandle;
    FLayerHandle := layerHandle;
    FObjectHandle := ANE_LayerGetNthObjectHandle (FModelHandle,
         FLayerHandle, kPIEElementObject, objectIndex); }
end;

{function TElementObjectOptions.GetBoolParameter(
  ParameterIndex: ANE_INT16): ANE_BOOL;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_BOOL_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of SmallInt;
begin
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEBoolean;
  GetMem(values[0], SizeOf(ANE_BOOL));
  try
    ANE_LayerGetObjectInfo(FModelHandle, FLayerHandle, kPIEElementObject,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
    result_ptr :=  values[0];
    result :=  result_ptr^;
  finally
    FreeMem(values[0]);
  end;
end;

function TElementObjectOptions.GetFloatParameter(
  ParameterIndex: ANE_INT16): ANE_DOUBLE;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_DOUBLE_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of SmallInt;
begin
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEFloat;
  GetMem(values[0], SizeOf(ANE_DOUBLE));
  try
    ANE_LayerGetObjectInfo(FModelHandle, FLayerHandle, kPIEElementObject,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
    result_ptr :=  values[0];
    result :=  result_ptr^;
  finally
    FreeMem(values[0]);
  end;
end;

function TElementObjectOptions.GetIntegerParameter(
  ParameterIndex: ANE_INT16): ANE_INT32;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_INT32_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of SmallInt;
begin
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEInteger;
  GetMem(values[0], SizeOf(ANE_INT32));
  try
    ANE_LayerGetObjectInfo(FModelHandle, FLayerHandle, kPIEElementObject,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
    result_ptr :=  values[0];
    result :=  result_ptr^;
  finally
    FreeMem(values[0]);
  end;
end; }


procedure TElementObjectOptions.GetNthNodeLocation(ModelHandle : ANE_PTR;
  var X, Y: ANE_DOUBLE; const NodeIndex: ANE_INT32);
begin
  ANE_ElementObjectGetNthNodeLocation(ModelHandle, FLayerHandle,
    FObjectHandle, NodeIndex, @X, @Y)
end;

function TElementObjectOptions.GetNthNodeNumber(ModelHandle : ANE_PTR;
  NodeNumber: ANE_INT32): ANE_INT32;
var
  StringToEvaluate : string;
  STR : ANE_STR;
begin
  Assert(NodeNumber >= 0);
  StringToEvaluate := 'CalcAtElemNumber('
    + IntToStr(FObjectIndex + 1) + ', NthNodeNum('
    + IntToStr(NodeNumber+1) + '))';
  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(ModelHandle, FLayerHandle, kPIEInteger,
      STR, @result);
    ANE_ProcessEvents(ModelHandle);
  finally
    FreeMem(STR);
  end;
end;

function TElementObjectOptions.GetObjectType: EPIEObjectType;
begin
  result := kPIEElementObject;
end;

{function TElementObjectOptions.GetStringParameter(
  ParameterIndex: ANE_INT16): string;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_STR_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of SmallInt;
begin
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEString;
  GetMem(values[0], SizeOf(ANE_STR));
  try
    ANE_LayerGetObjectInfo(FModelHandle, FLayerHandle, kPIEElementObject,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
    result_ptr :=  values[0];
    result :=  String(result_ptr^);
  finally
    FreeMem(values[0]);
  end;
end; }

function TElementObjectOptions.NumberOfNodes(ModelHandle : ANE_PTR): ANE_INT32;
begin
  result := ANE_ElementObjectGetNumNodes(ModelHandle, FLayerHandle,
    FObjectHandle);
end;

{ TObjectOptions }

constructor TObjectOptions.Create(ModelHandle : ANE_PTR;
  const layerHandle: ANE_PTR; objectIndex: ANE_INT32);
var
  ObjectType : EPIEObjectType;
begin
  inherited Create;
  ObjectType := GetObjectType;
//  FModelHandle := ModelHandle;
  FLayerHandle := layerHandle;
  FObjectHandle := ANE_LayerGetNthObjectHandle (ModelHandle,
       FLayerHandle, ObjectType, objectIndex);

end;

function TObjectOptions.GetBoolParameter(ModelHandle : ANE_PTR;
  ParameterIndex: ANE_INT16): ANE_BOOL;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_BOOL_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of EPIENumberType;
  ObjectType : EPIEObjectType;
begin
  Assert(ParameterIndex >= 0);
  ObjectType := GetObjectType;
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEBoolean;
  GetMem(result_ptr, SizeOf(ANE_BOOL));
  try
    values[0] := result_ptr;
    ANE_LayerGetObjectInfo(ModelHandle, FLayerHandle, ObjectType,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
//    result_ptr :=  values[0];
    result :=  result_ptr^;
  finally
    FreeMem(result_ptr);
  end;
end;

function TObjectOptions.GetFloatParameter(ModelHandle : ANE_PTR;
  ParameterIndex: ANE_INT16): ANE_DOUBLE;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_DOUBLE_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of EPIENumberType;
  ObjectType : EPIEObjectType;
begin
  Assert(ParameterIndex >= 0);
  ObjectType := GetObjectType;
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEFloat;
  GetMem(result_ptr, SizeOf(ANE_DOUBLE));
  try
    values[0] := result_ptr;
    ANE_LayerGetObjectInfo(ModelHandle, FLayerHandle, ObjectType,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
//    result_ptr :=  values[0];
    result :=  result_ptr^;
  finally
    FreeMem(result_ptr);
  end;
end;

function TObjectOptions.GetIntegerParameter(ModelHandle : ANE_PTR; 
  ParameterIndex: ANE_INT16): ANE_INT32;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_INT32_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of EPIENumberType;
  ObjectType : EPIEObjectType;
begin
  Assert(ParameterIndex >= 0);
  ObjectType := GetObjectType;
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEInteger;
  GetMem(result_ptr, SizeOf(ANE_INT32));
  try
    values[0] := result_ptr;
    ANE_LayerGetObjectInfo(ModelHandle, FLayerHandle, ObjectType,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
//    result_ptr :=  values[0];
    result :=  result_ptr^;
  finally
    FreeMem(result_ptr);
  end;
end;

function TObjectOptions.GetStringParameter(ModelHandle : ANE_PTR;
  ParameterIndex: ANE_INT16): string;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_STR_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of EPIENumberType;
  ObjectType : EPIEObjectType;
begin
  Assert(ParameterIndex >= 0);
  ObjectType := GetObjectType;
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEString;
  GetMem(result_ptr, SizeOf(ANE_STR));
  try
    values[0] := result_ptr;
    ANE_LayerGetObjectInfo(ModelHandle, FLayerHandle, ObjectType,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
//    result_ptr :=  values[0];
    result :=  String(result_ptr^);
  finally
    FreeMem(result_ptr);
  end;
end;

function TObjectOptions.SetBoolParameter(ModelHandle: ANE_PTR;
  ParameterIndex: ANE_INT16; Value : ANE_BOOL): ANE_BOOL;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_BOOL_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of EPIENumberType;
  ObjectType : EPIEObjectType;
begin
  Assert(ParameterIndex >= 0);
  ObjectType := GetObjectType;
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEBoolean;
  GetMem(result_ptr, SizeOf(ANE_BOOL));
  try
    result_ptr^ := Value;
    values[0] := result_ptr;
    result := ANE_LayerSetObjectInfo(ModelHandle, FLayerHandle, ObjectType,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
  finally
    FreeMem(result_ptr);
  end;
end;

function TObjectOptions.SetFloatParameter(ModelHandle: ANE_PTR;
  ParameterIndex: ANE_INT16; Value : ANE_DOUBLE) : ANE_BOOL;
var
  values : array [0..0] of ANE_DOUBLE_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  ANumberType : EPIENumberType;
  NumberTypes : array [0..0] of EPIENumberType;
  ObjectType : EPIEObjectType;
begin
  Assert(ParameterIndex >= 0);
  ObjectType := GetObjectType;
  valuesIndices[0] := ParameterIndex;
  ANumberType := kPIEFloat;
  NumberTypes[0] := ANumberType;

  values[0] := @Value;
  result := ANE_LayerSetObjectInfo(ModelHandle, FLayerHandle, ObjectType,
         FObjectHandle, 1, @NumberTypes, @valuesIndices, @values)
end;

function TObjectOptions.SetIntegerParameter(ModelHandle: ANE_PTR;
  ParameterIndex: ANE_INT16; Value : ANE_INT32) : ANE_BOOL;
var
  values : array [0..0] of ANE_PTR;
  result_ptr : ANE_INT32_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of EPIENumberType;
  ObjectType : EPIEObjectType;
begin
  Assert(ParameterIndex >= 0);
  ObjectType := GetObjectType;
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEInteger;
  GetMem(result_ptr, SizeOf(ANE_INT32));
  try
    result_ptr^ := Value;
    values[0] := result_ptr;
    result :=  ANE_LayerSetObjectInfo(ModelHandle, FLayerHandle, ObjectType,
           FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
  finally
    FreeMem(result_ptr);
  end;
end;

function TObjectOptions.SetStringParameter(ModelHandle: ANE_PTR;
  ParameterIndex: ANE_INT16; Value : ANE_STR) : ANE_BOOL;
var
  values : array [0..0] of ANE_PTR;
  valuesIndices : array [0..0] of ANE_INT16;
  NumberTypes : array [0..0] of EPIENumberType;
  ObjectType : EPIEObjectType;
begin
  Assert(ParameterIndex >= 0);
  ObjectType := GetObjectType;
  valuesIndices[0] := ParameterIndex;
  NumberTypes[0] := kPIEString;
  values[0] := Value;
  result :=  ANE_LayerSetObjectInfo(ModelHandle, FLayerHandle, ObjectType,
    FObjectHandle, 1, @NumberTypes, @valuesIndices, @values);
end;

function TObjectOptions.SetStringParameter(ModelHandle: ANE_PTR;
  ParameterIndex: ANE_INT16; Value: String): ANE_BOOL;
begin
  result := SetStringParameter(ModelHandle, ParameterIndex, PChar(Value));
end;

{ TContourObjectOptions }

{function TContourObjectOptions.ContourName(const ModelHandle : ANE_PTR): string;
var
  X, Y : ANE_DOUBLE;
  Layer : TLayerOptions;
begin
  GetNthNodeLocation(ModelHandle, X, Y, 0);
  Layer := TLayerOptions.Create(FLayerHandle);
  try
    result := Layer.StringValueAtXY(ModelHandle, X, Y, 'ContourName()');
  finally
    Layer.Free(ModelHandle);
  end;

end;  }

function TContourObjectOptions.ContourType(ModelHandle : ANE_PTR): TArgusContourType;
var
  NodeCount : integer;
  X1, Y1, X2, Y2 : ANE_DOUBLE;
begin
  NodeCount := NumberOfNodes(ModelHandle);
  if NodeCount = 1 then
  begin
    result := ctPoint;
  end
  else
  begin
    GetNthNodeLocation(ModelHandle, X1, Y1, 0);
    GetNthNodeLocation(ModelHandle, X2, Y2, NodeCount-1);
    if (X1 = X2) and (Y1 = Y2) then
    begin
      result := ctClosed;
    end
    else
    begin
      result := ctOpen;
    end;
  end;
end;

procedure TContourObjectOptions.GetNthNodeLocation(ModelHandle : ANE_PTR;
  var X, Y: ANE_DOUBLE; const NodeIndex: ANE_INT32);
begin
  ANE_ContourObjectGetNthVertexLocation(ModelHandle,
    FLayerHandle, FObjectHandle, NodeIndex, @X, @Y);
end;

function TContourObjectOptions.GetObjectType: EPIEObjectType;
begin
  result := kPIEContourObject;
end;

function TContourObjectOptions.IsInside(ModelHandle : ANE_PTR; X, Y: ANE_DOUBLE): boolean;
var
  NodeIndex : integer;
  NodeX, NodeY : double;
  NextNodeX, NextNodeY : double;
begin   // based on CACM 112
  result := true;
//  VertexCount := self.NumberOfNodes;
  For NodeIndex := 0 to NumberOfNodes(ModelHandle) -2 do
  begin
    GetNthNodeLocation(ModelHandle, NodeX, NodeY,NodeIndex);
    GetNthNodeLocation(ModelHandle, NextNodeX, NextNodeY,NodeIndex+1);
    if ((Y <= NodeY) = (Y > NextNodeY)) and
       (X - NodeX - (Y - NodeY) *
         (NextNodeX - NodeX)/
         (NextNodeY - NodeY) < 0) then
      begin
        result := not result;
      end;
  end;
  result := not result;
end;

function TContourObjectOptions.NumberOfNodes(ModelHandle : ANE_PTR): ANE_INT32;
begin
  result := ANE_ContourObjectGetNumVertices(ModelHandle,FLayerHandle,
    FObjectHandle);
end;

{ TBlockObjectOptions }

procedure TBlockObjectOptions.GetCorner(const ModelHandle : ANE_PTR;
  const CornerIndex : ANE_INT32; var X, Y: ANE_DOUBLE);
const
  ArrayLimit = 3;
var
  XArray : array [0..ArrayLimit] of ANE_DOUBLE;
  YArray : array [0..ArrayLimit] of ANE_DOUBLE;
begin
  ANE_BlockObjectGetLocation(ModelHandle, FLayerHandle, FObjectHandle,
         @XArray, @YArray);
  Assert((CornerIndex >= 0) and (CornerIndex <= ArrayLimit));

  X := XArray[CornerIndex];
  Y := YArray[CornerIndex];
end;

procedure TBlockObjectOptions.GetCorners(const ModelHandle : ANE_PTR;
   var XArray, YArray: TBlockCorners);
begin
  ANE_BlockObjectGetLocation(ModelHandle, FLayerHandle, FObjectHandle,
         @XArray, @YArray);
end;

procedure TBlockObjectOptions.GetCenter(const ModelHandle : ANE_PTR; var X, Y: ANE_DOUBLE);
const
  ArrayLimit = 3;
var
  XArray : array [0..ArrayLimit] of ANE_DOUBLE;
  YArray : array [0..ArrayLimit] of ANE_DOUBLE;
  Index : integer;
begin
  ANE_BlockObjectGetLocation(ModelHandle, FLayerHandle, FObjectHandle,
         @XArray, @YArray);
  X := 0;
  Y := 0;
  for Index := 0 to ArrayLimit do
  begin
    X := X + XArray[Index];
    Y := Y + YArray[Index];
  end;
  X := X/(ArrayLimit+1);
  Y := Y/(ArrayLimit+1);
end;

function TBlockObjectOptions.GetObjectType: EPIEObjectType;
begin
  result := kPIEBlockObject;
end;

{ TDataObjectOptions }

procedure TDataObjectOptions.GetLocation(ModelHandle: ANE_PTR; var X,
  Y: ANE_DOUBLE);
begin
  ANE_DataPointObjectGetLocation(ModelHandle, FLayerHandle, FObjectHandle, @X, @Y);
end;

function TDataObjectOptions.GetObjectType: EPIEObjectType;
begin
//  result := $0020;
  result := kPIEDataPointObject
end;

function TDataObjectOptions.SetBoolParameter(ModelHandle: ANE_PTR;
  ParameterIndex: ANE_INT16; Value: ANE_BOOL): ANE_BOOL;
begin
  raise EArgusPropertyError.Create('Error: you can not set values of individual data points');
end;

function TDataObjectOptions.SetFloatParameter(ModelHandle: ANE_PTR;
  ParameterIndex: ANE_INT16; Value: ANE_DOUBLE): ANE_BOOL;
begin
  raise EArgusPropertyError.Create('Error: you can not set values of individual data points');
end;

function TDataObjectOptions.SetIntegerParameter(ModelHandle: ANE_PTR;
  ParameterIndex: ANE_INT16; Value: ANE_INT32): ANE_BOOL;
begin
  raise EArgusPropertyError.Create('Error: you can not set values of individual data points');
end;

function TDataObjectOptions.SetStringParameter(ModelHandle: ANE_PTR;
  ParameterIndex: ANE_INT16; Value: ANE_STR): ANE_BOOL;
begin
  raise EArgusPropertyError.Create('Error: you can not set values of individual data points');
end;

function TDataObjectOptions.SetStringParameter(ModelHandle: ANE_PTR;
  ParameterIndex: ANE_INT16; Value: String): ANE_BOOL;
begin
  raise EArgusPropertyError.Create('Error: you can not set values of individual data points');
end;

{ TGridLayerOptions }

function TGridLayerOptions.ColumnPositions(const ModelHandle: ANE_PTR;
  const ColumnIndex: integer): ANE_DOUBLE;
var
  StringToEvaluate : string;
begin
  StringtoEvaluate := 'NthColumnPos(' + IntToStr(ColumnIndex) + ')' ;
  result := RealValue(ModelHandle,StringToEvaluate);
end;

constructor TGridLayerOptions.Create(const ModelHandle,
  LayerHandle: ANE_PTR);
begin
  inherited Create(LayerHandle);
  Assert(LayerType[ModelHandle] = pieGridLayer);
end;

constructor TGridLayerOptions.CreateWithName(const LayerName: string;
  ModelHandle: ANE_PTR);
begin
  inherited;
  Assert(LayerType[ModelHandle] = pieGridLayer);
end;

function TGridLayerOptions.GridAngle(
  const ModelHandle: ANE_PTR): ANE_DOUBLE;
var
  StringToEvaluate : string;
begin
  StringtoEvaluate := 'If(IsNA(GridAngle()), 0.0, GridAngle())';
  result := RealValue(ModelHandle,StringToEvaluate);
end;

function TGridLayerOptions.NumberOfColumns(
  const ModelHandle: ANE_PTR): ANE_INT32;
var
  StringToEvaluate : string;
begin
  StringToEvaluate := 'NumColumns()';
  result := IntegerValue(ModelHandle,StringToEvaluate);
end;

function TGridLayerOptions.NumberOfRows(const ModelHandle : ANE_PTR): ANE_INT32;
var
  StringToEvaluate : string;
begin
  StringToEvaluate := 'NumRows()';
  result := IntegerValue(ModelHandle,StringToEvaluate);
end;

function TGridLayerOptions.RowPositions(const ModelHandle: ANE_PTR;
  const RowIndex: integer): ANE_DOUBLE;
var
  StringToEvaluate : string;
begin
  StringtoEvaluate := 'NthRowPos(' + IntToStr(RowIndex) + ')' ;
  result := RealValue(ModelHandle,StringToEvaluate);
end;

function LockToString(const ALock : TParamLock) : string;
var
  // First_Lock is used to determine if a comma needs to be present before
  // the next item in the list of characteristics to be locked.
  First_Lock : Boolean;
begin
  result := '';
  if (ALock = []) then
  begin
//    result := '';
    Exit;
  end;
  First_Lock := True;
//  result := '"';
  if plName in ALock then
  begin
    result := result +  'Lock Name';
    First_Lock := False;
  end;
  if plUnits in ALock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Units';
    First_Lock := False;
  end;
  if plType in ALock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Type';
    First_Lock := False;
  end;
  if plInfo in ALock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Info';
    First_Lock := False;
  end;
  if plDef_Val in ALock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Def Val';
    First_Lock := False;
  end;
  if plDont_Override in ALock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Dont Override';
    First_Lock := False;
  end;
  if plInhibit_Delete in ALock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Inhibit Delete';
    First_Lock := False;
  end;
  if (plKind in ALock) {and CheckArgusVersion(CurrentModelHandle,4,2,0,'d',Dummy)} then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Kind';
    First_Lock := False;
  end;
  if (plDontEvalColor in ALock) {and CheckArgusVersion(CurrentModelHandle,4,2,0,'g',Dummy)} then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Dont Eval Color';
//    First_Lock := False;
  end;
//  result := result + '"'
end;

function StringToLock(const LockString : String) : TParamLock;
  // First_Lock is used to determine if a comma needs to be present before
  // the next item in the list of characteristics to be locked.
begin
  result := [];
  if Pos('Lock Name',LockString) > 0 then
  begin
    Include(result,plName);
  end;
  if Pos('Lock Units',LockString) > 0 then
  begin
    Include(result,plUnits);
  end;
  if Pos('Lock Type',LockString) > 0 then
  begin
    Include(result,plType);
  end;
  if Pos('Lock Info',LockString) > 0 then
  begin
    Include(result,plInfo);
  end;
  if Pos('Lock Def Val',LockString) > 0 then
  begin
    Include(result,plDef_Val);
  end;
  if Pos('Dont Override',LockString) > 0 then
  begin
    Include(result,plDont_Override);
  end;
  if Pos('Inhibit Delete',LockString) > 0 then
  begin
    Include(result,plInhibit_Delete);
  end;
  if Pos('Lock Kind',LockString) > 0 then
  begin
    Include(result,plKind);
  end;
  if Pos('Dont Eval Color',LockString) > 0 then
  begin
    Include(result,plDontEvalColor);
  end;
end;

function LayerTypesToString(const LayerTypes : TPIELayerTypes) : String;
var
  Layers : TStringList;
  Index : integer;
begin
{pieTriMeshLayer,pieQuadMeshLayer,pieInformationLayer,
    pieGridLayer,pieDataLayer,pieMapsLayer,pieDomainLayer,pieGroupLayer,
    pieAnyLayer}
  if pieAnyLayer in LayerTypes then
  begin
    result := 'Any Layer';
    Exit;
  end;
  Layers := TStringList.Create;
  try
    if pieTriMeshLayer in LayerTypes then
    begin
      Layers.Add('Tri-Mesh Layer');
    end;
    if pieQuadMeshLayer in LayerTypes then
    begin
      Layers.Add('Quad-Mesh Layer');
    end;
    if pieInformationLayer in LayerTypes then
    begin
      Layers.Add('Information Layer');
    end;
    if pieGridLayer in LayerTypes then
    begin
      Layers.Add('Grid Layer');
    end;
    if pieDataLayer in LayerTypes then
    begin
      Layers.Add('Data Layer');
    end;
    if pieMapsLayer in LayerTypes then
    begin
      Layers.Add('Maps Layer');
    end;
    if pieDomainLayer in LayerTypes then
    begin
      Layers.Add('Domain Outline Layer');
    end;
    if pieGroupLayer in LayerTypes then
    begin
      Layers.Add('Group Layer');
    end;
    case Layers.Count of
      0:
        begin
          result := '';
        end;
      1:
        begin
          result := Layers[0];
        end;
      2,3,4,5,6,7,8:
        begin
          Layers.Insert(Layers.Count-1, 'or');
          result := '';
          for Index := 0 to Layers.Count-1 do
          begin

            result := result + Layers[Index];
            if Index < Layers.Count-2 then
            begin
              result := result + ', ';
            end
            else
            begin
              result := result + ' ';
            end;
          end;
          SetLength(Result, Length(Result) -1);
        end;
    else
      begin
        Assert(False);
      end;
    end;
  finally
    Layers.Free;
  end;
end;

end.
