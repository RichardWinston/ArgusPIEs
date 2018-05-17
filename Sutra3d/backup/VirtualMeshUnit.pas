unit VirtualMeshUnit;

interface

uses SysUtils, classes, Math, AnePIE, IntListUnit, RealListUnit, VertexUnit,
  OptionsUnit, doublePolyhedronUnit, Dialogs;

function SortNodesXMin(Item1, Item2: Pointer): Integer;
function SortNodesXMax(Item1, Item2: Pointer): Integer;
function SortNodesYMin(Item1, Item2: Pointer): Integer;
function SortNodesYMax(Item1, Item2: Pointer): Integer;
function SortNodesZMin(Item1, Item2: Pointer): Integer;
function SortNodesZMax(Item1, Item2: Pointer): Integer;
procedure GetNodesInRange(SortedMinListOfNodes, NodesInRange : TList;
  Min, Max : double; Dimension : integer);

type
  EInvalidMesh = class(Exception);

  TReal2DMesh = class;
  TRealElement = class;

  TLocation = record
    X, Y : double;
//    LayerIndex : integer;
  end;

  TGrowthType = (gtNone, gtIncreaseDownward, gtIncreaseUpward,
    gtIncreaseTowardMiddle);
  TGrowthTypeArray = array of TGrowthType;
  

  TPolygon = Class(TObject)
    private
    FCount : integer;
    FLocations : array of TLocation;
    function GetLocation (Index : integer) : TLocation;
    public
    function IsLocationInside (Location : TLocation) : boolean;
    constructor Create(Locations : array of TLocation; Size : integer);
    property Count : integer read FCount;
    property Location[Index : integer] : TLocation read GetLocation;
  end;

  TRealNode = class(TObject)
  // TRealNode is the PIE's representation of a node on an Argus ONE mesh
  // layer.
  private
    FX, FY, FZ : ANE_DOUBLE;
    // These define the location of the node in space. FZ is defined by an
    // Argus ONE parameter.
    FMesh : TReal2DMesh;
    // FMesh is the TReal2DMesh that contains the node.
    FNodeIndex : ANE_INT32;
    // FNodeIndex is the node number of the corresponding Argus ONE node.
    // Argus displays a number 1 greater than FNodeIndex.
    FElements : TList;
    // FElements is the list of elements of which the node is a part
    Procedure GetElevation(ModelHandle : ANE_PTR; LayerIndex : integer);
    // GetElevation is called by TRealNode.Create. It assigns the correct
    // value to FZ.
    function GetElement(Index : integer): TRealElement;
    Procedure ArrangeElements;
    function Cell: TPolygon;
  public
    Constructor Create(ModelHandle : ANE_PTR; AMesh : TReal2DMesh;
      Index : ANE_INT32; LayerIndex : integer);
    // This is used to create a TRealNode and assign values to the private
    // variables.
    Destructor Destroy; override;
    function BooleanParameterValue(ModelHandle : ANE_PTR; ParameterIndex : ANE_INT16) : ANE_BOOL;
    // This gets the boolean value of the parameter set by ParameterIndex
    function IntegerParameterValue(ModelHandle : ANE_PTR; ParameterIndex : ANE_INT16) : ANE_INT32;
    // This gets the integer value of the parameter set by ParameterIndex
    function RealParameterValue(ModelHandle : ANE_PTR; ParameterIndex : ANE_INT16) : ANE_DOUBLE;
    // This gets the real number value of the parameter set by ParameterIndex
    function StringParameterValue(ModelHandle : ANE_PTR; ParameterIndex : ANE_INT16) : string;
    // This gets the string value of the parameter set by ParameterIndex
    Property X : ANE_DOUBLE read FX;
    // X is the X-coordinate of the node.
    Property Y : ANE_DOUBLE read FY;
    // Y is the Y-coordinate of the node.
    Property Z : ANE_DOUBLE read FZ;
    // Z is the Z-coordinate of the node.
    property Elements[Index : integer] : TRealElement read GetElement;
    function ElementCount : integer;
    function IsInsideCell(X, Y : double) : boolean;
    function SegmentIntercept(ASegment: TSegmentObject): TSegmentList;
    property NodeIndex : ANE_INT32 read FNodeIndex;
  end;

  TRealElement = class(TObject)
  // TRealElement is the PIE's representation of an element on an Argus ONE mesh
  // layer.
  private
    FNodes : TList;
    // FNodes is a list of TRealNode's that define the location of the element.
    // (The nodes are owned by the FMesh not the element.)
    FElementIndex : ANE_INT32;
    // FElementIndex is the element number of the corresponding Argus ONE
    // element.
    FMesh : TReal2DMesh;
    // FMesh is the TReal2DMesh that contains the element.
    Function GetNode(NodeIndex : integer) : TRealNode;
    // GetNode returns the TRealNode at position NodeIndex in FNodes.
//    function IsLocationInsideElement (AVertex: TVertex) : boolean;
  public
    constructor Create(ModelHandle : ANE_PTR; AMesh : TReal2DMesh; Index : ANE_INT32);
    // This creates a TRealElement, assigns the correct values to FElementIndex
    // and FMesh and retrieves the correct nodes from FMesh and adds them to
    // FNodes.
    constructor CreateWithNodes(ModelHandle : ANE_PTR; AMesh : TReal2DMesh;
      Index : ANE_INT32; NodeNumbers : array of integer; NodeCount : integer);
    // This creates a TRealElement, assigns the correct values to FElementIndex
    // and FMesh and retrieves the correct nodes from FMesh and adds them to
    // FNodes.
    Destructor Destroy; override;
    // this destroys the TRealElement
    function BooleanParameterValue(ModelHandle : ANE_PTR; ParameterIndex : ANE_INT16) : ANE_BOOL;
    // This gets the boolean value of the parameter set by ParameterIndex
    function IntegerParameterValue(ModelHandle : ANE_PTR;ParameterIndex : ANE_INT16) : ANE_INT32;
    // This gets the integer value of the parameter set by ParameterIndex
    function RealParameterValue(ModelHandle : ANE_PTR; ParameterIndex : ANE_INT16) : ANE_DOUBLE;
    // This gets the real number value of the parameter set by ParameterIndex
    function StringParameterValue(ModelHandle : ANE_PTR; ParameterIndex : ANE_INT16) : string;
    // This gets the string value of the parameter set by ParameterIndex
    property Nodes[NodeIndex : integer] : TRealNode read GetNode;
    // Nodes contains the list of nodes that define the element.
//    property ElementIndex : ANE_INT32 read FElementIndex;
    procedure GetCenter(var X, Y : double);
  end;

  TReal2DMesh = class(TObject)
  // TReal2DMesh is the PIE's representation of a mesh on an Argus ONE mesh
  // layer.
  private
    FNodes : TList;
    // FNodes is a list of TRealNode's in the mesh.
    // The nodes are owned by the Mesh.
    FElements : TList;
    // FElements is a list of TRealElement's in the mesh.
    // The elements are owned by the Mesh.
//    FModelHandle : ANE_PTR;
    // FModelHandle is the handle of the model containing the mesh.
    FLayerHandle : ANE_PTR;
    // FModelHandle is the handle of the layer containing the mesh.
//    FLayerOptions : TLayerOptions;
    // FLayerOptions is a TLayerOptions owned by the TReal2DMesh.
    OptionsList : TStringList;
    FLayerIndex : integer;
    function GetNode(NodeIndex : Integer) : TRealNode;
    // GetNode  returns a TRealNode from FNodes.
    function GetElement(ElementIndex : Integer) : TRealElement;
    // GetElement  returns a TRealElement from FElements.
{    function ParameterIndex(ModelHandle : ANE_PTR; ParameterName : string) : ANE_INT16;
    // ParameterIndex returns the index of the parameter with the name
    // ParameterName    }
    procedure ReadElements(ModelHandle: ANE_PTR);
    // ReadElements called by ReadMesh. It gets the elements from Argus ONE
    // and creates corresponding TRealElement's;
    Procedure ReadMesh(ModelHandle : ANE_PTR; LayerIndex : integer) ;
    // ReadMesh is called by Create. It gets the elements and nodes from
    // Argus ONE.
    procedure ReadNodes(ModelHandle: ANE_PTR; LayerIndex : integer);
    // ReadNodes called by ReadMesh. It gets the nodes from Argus ONE
    // and creates corresponding TRealNode's;
    procedure ArrangeElements;
  public
    function BooleanValue(ModelHandle : ANE_PTR; X,Y : Double; Expression : String = '') : ANE_BOOL;
    // BooleanValue uses FLayerOptions to evaluate Expression at location
    // X,Y and returns the
    // boolean result. If Expression = '', the expression that will be evaluated
    // is tha last expression that was not equal to ''.
    // FLayerOptions must have been created before calling BooleanValue.
    Constructor Create(ModelHandle : ANE_PTR; const LayerHandle : ANE_PTR;
      LayerIndex : integer);
    // Create creates TReal2DMesh and gets the nodes and elements from
    // Argus ONE.
    destructor Destroy; override;
    // Destroy destroys the  TReal2DMesh
    Property Elements[ElementIndex : integer] : TRealElement read GetElement;
    // Elements gets the TRealElement at location ElementIndex in FElements.
    procedure FreeParsedExpression(ModelHandle : ANE_PTR);
    // FreeParsedExpression calls FLayerOptions.FreeParsedExpression
    function IntegerValue(ModelHandle : ANE_PTR; X,Y : Double; Expression : String = '') : ANE_INT32;
    // BooleanValue uses FLayerOptions to evaluate Expression at location
    // X,Y and returns the integer
    // result. If Expression = '', the expression that will be evaluated
    // is tha last expression that was not equal to ''.
    // FLayerOptions must have been created before calling BooleanValue.
    Property Nodes[NodeIndex : integer] : TRealNode read GetNode;
    // Nodes gets the TRealNode at location NodeIndex in FNodes.
    procedure ParseExpression(ModelHandle : ANE_PTR; Expression: string; NumberType : TPIENumberType);
    // ParseExpression creates FLayerOptions if it does not already exist,
    // frees the current parsed expression, if any, of FLayerOptions,
    // and calls FLayerOptions.ParseExpression.
    function RealValue(ModelHandle : ANE_PTR; X,Y : Double; Expression : String = '') : ANE_DOUBLE;
    // BooleanValue uses FLayerOptions to evaluate Expression at location
    // X,Y and returns the real number
    // result. If Expression = '', the expression that will be evaluated
    // is tha last expression that was not equal to ''.
    // FLayerOptions must have been created before calling BooleanValue.
    function StringValue(ModelHandle : ANE_PTR; X,Y : Double; Expression : String = '') : string;
    // BooleanValue uses FLayerOptions to evaluate Expression at location
    // X,Y and returns the
    // string result. If Expression = '', the expression that will be evaluated
    // is tha last expression that was not equal to ''.
    // FLayerOptions must have been created before calling BooleanValue.
    function NodeCount : integer;
    procedure NodesOnSegment(const ASegment: TSegmentObject; ListOfNodes : TList);
    // NodesOnSegment fills ListOfNodes with the TRealNodes whose cells are
    // intercepted by ASegment. The Nodes are listed in the order in which
    // their cells are intercepted.
    procedure Free(ModelHandle: ANE_PTR);
  end;

  T3DMorphMesh = class(TObject)
  // T3DMorphMesh is used to hold a series of triagonal TReal2DMesh used for
  // "morphing" in the Sutra 3D PIE. It is also the ancestor of TVirtual3DMesh
  private
//    FModelHandle : ANE_PTR;
    // FModelHandle is the handle of the current Argus ONE model.
    FRealMeshList : TList;
    // FRealMeshList contains TReal2DMesh's
    FNodesPerLayer : integer;
    // NodesPerLayer is the number of nodes on each TReal2DMesh. All the
    // TReal2DMesh's must contain the same number of nodes.
    FElementsPerLayer : integer;
    // ElementsPerLayer is the number of elements on each TReal2DMesh. All the
    // TReal2DMesh's must contain the same number of elements.
//    function GetLayerHandle(ModelHandle : ANE_PTR; LayerIndex : integer) : ANE_PTR; virtual;
    // GetLayerHandle gets the Argus ONE handle of the triagonal Argus ONE
    // mesh represented in the PIE by TSutraMorphMeshLayer with index
    // LayerIndex
    function GetRealMesh(Index : integer) : TReal2DMesh;
    // GetRealMesh gets the TReal2DMesh at the postion Index from FRealMeshList.
    procedure MakeRealMeshes(ModelHandle : ANE_PTR; NumberOfMeshes : integer);
    // MakeRealMeshes gets NumberOfMeshes meshes from Argus ONE and makes the
    // corresponding TReal2DMesh. The type of mesh that is gotten is determined
    // by GetLayerHandle. MakeRealMeshes is called by Create
    function GetRealMeshCount : integer;
    function GetLayerHandle(ModelHandle : ANE_PTR; LayerIndex : integer) : ANE_PTR; virtual; abstract;
  public
    property Real2DMeshes[Index : integer] : TReal2DMesh read GetRealMesh;
    // Real2DMeshes gets the TReal2DMesh at the postion Index from FRealMeshList.
    Constructor Create(ModelHandle: ANE_PTR; NumberOfMeshes : integer);
    // Create creates the T3DMorphMesh. ModelHandle is the handle of the current
    // model. NumberOfMeshes is the number of meshes that must be gotten from
    // Argus ONE.
    Destructor Destroy; override;
    // Destroy destroys the T3DMorphMesh
    property NodesPerLayer : integer read FNodesPerLayer;
    property ElementsPerLayer : integer read FElementsPerLayer;
    property RealMeshCount : integer read GetRealMeshCount ;
    procedure Free(ModelHandle: ANE_PTR);
  end;

  TVirtual3DMesh = class;

  TVirtualNode = Class(Tobject)
  // TVirtualNode is the PIE's representation of a Sutra 3D node.
  // Not all TVirtualNode's will be at the positions of nodes in Argus ONE.
  // most of the private
  // variables are set in TVirtual3DMesh.MakeVirtualNodes
    private
      FZ : double;
      // FZ is the elevation of the node.
      MeshAbove : TReal2DMesh;
      NodeAbove : TRealNode;
      NodeBelow : TRealNode;
      // each TVirtualNode is on a straight line connecting two TRealNode's
      // in different meshes. NodeAbove is the node in the mesh above the
      // TVirtualNode. NodeBelow is the node in the mesh below the
      // TVirtualNode. If the TVirtualNode is in the lowest mesh, it is at the
      // location of NodeAbove and NodeBelow = nil.
      UnMorphedFractionAbove : double;
      // If the value of a TVirtualNode is to be evaluated without morphing,
      // UnMorphedFractionAbove represents the relative contribution of the value
      // of NodeAbove to the value of the parameter being evaluated.
      MorphedFractionAbove : double;
      // If the value of a TVirtualNode is to be evaluated with morphing,
      // MorphedFractionAbove represents the relative contribution of the value
      // of the parameter when evaluated at AboveEvalLocation to the value of
      // the parameter being evaluated.
      AboveEvalLocation : TLocation;
      // The location in the mesh above where the node is to be evaluated
      // if morphing is used.
      BelowEvalLocation : TLocation;
      // The location in the mesh below where the node is to be evaluated
      // if morphing is used.
      ElementList : TList;
      FPolyHedron : TPolyhedron;
    FLayer: integer;
      function ReadPolyhedron : TPolyhedron;
      Procedure CreatePolyhedron(NodeIndex : integer);
      function TopRealNode: TRealNode;
      procedure PartiallyCreatePolyhedron(NodeIndex : integer;
        var LastFace, LastVertex : integer);
    public
      Value1, Value2, Value3, Value4, Value5 : double;
      {$IFDEF OldSutraIce}
      Conductance: double;
      {$ENDIF}
      Transient : boolean;
      Used : boolean;
      IntValue : integer;
      NodeIndex : integer;
      Comment : string;
      Mesh : TVirtual3DMesh;
      property PolyHedron : TPolyhedron read ReadPolyhedron;
      function X : double;
      // The X-coordinate of the node.
      function Y : double;
      // The Y-coordinate of the node.
      function Z : double;
      // The Z-coordinate of the node.
      function UnMorphedBooleanParameterValue(ModelHandle : ANE_PTR; ParameterIndex : integer) : ANE_BOOL;
      function UnMorphedIntegerParameterValue(ModelHandle : ANE_PTR; ParameterIndex : integer) : ANE_INT32;
      function UnMorphedRealParameterValue(ModelHandle : ANE_PTR; AboveParameterIndex, BelowParameterIndex : integer) : ANE_DOUBLE;
      function UnMorphedStringParameterValue(ModelHandle : ANE_PTR; ParameterIndex : integer) : string;
      function MorphedRealParameterValue(ModelHandle : ANE_PTR; Expression : string) : ANE_DOUBLE;
      constructor Create(Position : integer; const VMesh : TVirtual3DMesh);
      Destructor Destroy; override;
      function LocationString : string;
      Procedure StorePolyHedron;
      Procedure FreePolyHedron;
      function TopRealX : double;
      function TopRealY : double;
      property Layer: integer read FLayer;
  end;

  TVirtualElement = Class(TObject)
    private
      FOwner : TVirtual3DMesh;
      FX, FY, FZ : Double;
      // FX, FY, and FZ represent the coordinates of the center of the element.
      MorphedFractionAbove : double;
      // If the value of a TVirtualElement is to be evaluated with morphing,
      // MorphedFractionAbove represents the relative contribution of the value
      // of the parameter when evaluated at AboveEvalLocation to the value of
      // the parameter being evaluated.
      ElementAbove : TRealElement;
      ElementBelow : TRealElement;
      // each TVirtualElement is on a straight line connecting two TRealElement's
      // in different meshes. ElementAbove is the element in the mesh above the
      // TVirtualElement. ElementBelow is the element in the mesh below the
      // TVirtualElement.
      AboveEvalLocation : TLocation;
      // The location in the mesh above where the node is to be evaluated
      // if morphing is used.
      BelowEvalLocation : TLocation;
      // The location in the mesh below where the node is to be evaluated
      // if morphing is used.
      NodeList : TList;
      // NodeList is a list of TVirtualNode's defining the location of the
      // TVirtualElement. The TVirtualNode's are owned by a TVirtual3DMesh
      // not by the TVirtualElement.
      Volume : double;
      FLayer: integer;
      procedure CreatePolyhedron;
      procedure AddFaces(CornerNode: TVirtualNode; APolyHedron: TPolyhedron;
        var LastVertex, LastFace: integer);
      function BandWidth : integer;
      function GetNode(Index : integer) : TVirtualNode;
    public
      IntValue : integer;
      constructor Create(Owner : TVirtual3DMesh);
      // Create creates the TVirtualElement. However, most of the private
      // variables are set in TVirtual3DMesh.MakeVirtualElements
      Destructor Destroy; override;
      function StringParameterValue(ParameterIndexAbove, ParameterIndexBelow : ANE_INT16) : string;
      function MorphedRealParameterValue(ModelHandle : ANE_PTR;Expression : string = '') : ANE_DOUBLE;
      function MorphedAngleParameterValue(ModelHandle : ANE_PTR; Expression: string = ''): ANE_DOUBLE;
      property ElX : double read FX;
      property ElY : double read FY;
      property ElZ : double read FZ;
      property Layer: integer read FLayer;
      property Nodes[Index : integer] : TVirtualNode read GetNode;
  end;

  TVirtual3DMesh = class(T3DMorphMesh)
  // TVirtual3DMesh is the PIE's representation of a Sutra 3D mesh.
  private
    FGrowthTypes: TGrowthTypeArray;
    FVirtualMeshCount : integer;
    FDiscretization : TIntegerList;
    // Each element in FDiscretization is the number of virtual layers
    // represented by one Argus ONE mesh.
    FGrowthRates: TRealList;
    // Each element in FGrowthRates is the rate at which elements should
    // change in size in the downward direction.
    NodeList : TList;
    // NodeList contains a list of TVirtualNode's
    FSortedNodeList : TList;
    ElementList : TList;
    // ElementList contains a list of TVirtualElement's
    FMorphMesh : T3DMorphMesh;
    // FMorphMesh is a T3DMorphMesh used for "morphing"
    procedure MakeVirtualElements(ModelHandle : ANE_PTR);
    // MakeVirtualElements creates the TVirtualElement's of the TVirtual3DMesh
    // and assigns most private variables of the TVirtualElement's
    procedure MakeVirtualNodes(ModelHandle : ANE_PTR);
    // MakeVirtualNodes creates the TVirtualNode's of the TVirtual3DMesh
    // and assigns most private variables of the TVirtualNode's
    function GetLayerHandle(ModelHandle : ANE_PTR; LayerIndex : integer) : ANE_PTR; override;
    // GetLayerHandle gets the Argus ONE handle of the Argus ONE Sutra mesh
    // represented in the PIE by TSutraMeshLayer with index
    // LayerIndex
{    function BoolVirtualNodeValue(NodeIndex : integer;
      ParameterName : string) : ANE_BOOL;
    function IntegerVirtualNodeValue(NodeIndex : integer;
      ParameterName : string) : ANE_INT32;
    function RealVirtualNodeValue(NodeIndex: integer;
      ParameterName : string) : ANE_DOUBLE;
    function StringVirtualNodeValue(NodeIndex : integer;
      ParameterName : string) : string;  }
    function GetVirtualNode(Index : integer) : TVirtualNode;
    // GetVirtualNode returns the TVirtualNode at position Index within NodeList.
    function GetVirtualElement(Index : integer) : TVirtualElement;
    // GetVirtualElement returns the TVirtualElement at position Index within ElementList.
    procedure GetNodeMorphedCoord(LayerAbove, LayerBelow : TReal2DMesh;
      ANode : TVirtualNode) ;
    // GetNodeMorphedCoord assigns the morphed locations within LayerAbove,
    // LayerBelow where ANode should be evaluated.
{    procedure GetMorphedFraction(LayerAbove, LayerBelow: TReal2dMesh;
      ParameterName : string; NodeStart, NodeEnd : Integer);}
    procedure GetNodeMorphedFraction(ModelHandle : ANE_PTR; LayerAbove, LayerBelow: TReal2dMesh;
      {ParameterName: string;} NodeStart, NodeEnd: Integer);
    // GetNodeMorphedFraction  assigns the MorphedFractionAbove of the
    // TVirtualNode's from NodeStart to NodeEnd in Nodelist. These nodes
    // must lie between LayerAbove and LayerBelow.
    procedure GetElementMorphedFraction(ModelHandle : ANE_PTR;
      LayerAbove, LayerBelow: TReal2dMesh;
      ElementStart, ElementEnd, LayerIndex: Integer);
    // GetNodeMorphedFraction  assigns the MorphedFractionAbove of the
    // TVirtualElement's from ElementStart to ElementEnd in Nodelist. These
    // elements must lie between LayerAbove and LayerBelow.
    procedure GetElementMorphedCoord(LayerAbove, LayerBelow: TReal2DMesh;
      AnElement: TVirtualElement);
    // GetNodeMorphedCoord assigns the morphed locations within LayerAbove,
    // LayerBelow where AnElement should be evaluated.
    function GetDiscretization(Index : integer) : integer;
    procedure SortNodesByMinX;
    procedure SetEpsilon;
  Public
    NodeFilePositions : TIntegerList;
    function VirtualNodeIndex(VirtualLayer, IndexOnLayer : integer) : integer;
    // VirtualNodeIndex returns the position within NodeList of a TVirtualNode
    // given its virtual layer and position on the layer.
    function VirtualElementIndex(VirtualLayer, IndexOnLayer: integer): integer;
    Constructor Create(ModelHandle: ANE_PTR; Discretization : TIntegerList;
       GrowthRates: TRealList;
       const GrowthTypes: TGrowthTypeArray; MorphMesh : T3DMorphMesh);
    // Create creates the TVirtual3DMesh. ModelHandle is the handle of the
    // current Argus ONE model, Discretization is a list of integers
    // that tells how many virtual layers is represented by each TReal2DMesh.
    // GrowthRates tells how the size of element layers should change within
    // a geologic unit.
    //  MorphMesh is the T3DMorphMesh used for morphing
    Destructor Destroy; override;
    // Destroy destroys the TVirtual3DMesh
    procedure ParseExpression(ModelHandle: ANE_PTR; Expression : string; NumberType : TPIENumberType);
    // ParseExpression calls AMesh.ParseExpression for each TReal2DMesh.
    procedure FreeParsedExpression(ModelHandle : ANE_PTR);
    // FreeParsedExpression calls AMesh.FreeParsedExpression for each TReal2DMesh.
    function GetMorphedNodeValue(ModelHandle: ANE_PTR; NodeNumber : integer; Expression : string): ANE_DOUBLE;
    // GetMorphedNodeValue gets the morphed value of the TVirtualNode indicated
    // by NodeNumber. NodeNumber is an index to node numbers starting at 0
    // and numbered along columns of nodes.
    function GetMorphedElementValue(ModelHandle: ANE_PTR; ElementIndex: integer;
      Expression : string): ANE_DOUBLE;
    // GetMorphedElementValue gets the morphed value of the TVirtualElement
    // indicated by ElementIndex.
    function GetMorphedElementAngleValue(ModelHandle: ANE_PTR; ElementIndex: integer;
      Expression: string): ANE_DOUBLE;
    property VirtualNodes[Index : integer] : TVirtualNode read GetVirtualNode;
    // VirtualNodes retrieves the TVirtualNode at position Index from NodeList
    property VirtualElements[Index : integer] : TVirtualElement read GetVirtualElement;
    // VirtualElements retrieves the TVirtualElement at position Index from ElementList
    function NodeCount : integer;
    function ElementCount : integer;
    Procedure InitializeNodeValue1;
    procedure InitializeNodeValues;
    procedure InitializeIntNodeValue;
    procedure InitializeIntElementValue;
//    function IndexOfNode(ANode : TVirtualNode) : integer;
    property Discretization[Index : integer] : integer read GetDiscretization;
    function BandWidth : integer;
    function NodeNumberToNodeIndex (NodeNumber : integer) : integer;
    // NodeNumberToNodeIndex is used to convert node numbers numbered along
    // columns of nodes to an index that can retrieve the proper node from
    // VirtualNodes.
    function NodeIndexToNodeNumber(NodeIndex: integer): integer;
    // inverse of NodeNumberToNodeIndex
    property VirtualMeshCount : integer read FVirtualMeshCount ;
    property SortedNodeList : TList read FSortedNodeList;
    function RealLayerIndex(VirtualLayerIndex : integer): integer;
    function ElementIndexToElementNumber(ElementIndex: integer): integer;
  end;

  var
    Epsilon : extended;

implementation

uses SLSutraMesh, ANECB, SegmentUnit, TriangleUnit, SLMorphLayer, SolidGeom,
  ZFunction, frmSutraUnit, VirtualMeshFunctions, UtilityFunctions, OctTreeClass;

var
  MeshModelHandle : ANE_PTR = nil;

type
    TDoubleDynArray       = array of Double;


function SortNodesXMin(Item1, Item2: Pointer): Integer;
var
  Node1, Node2 : TVirtualNode;
  Value : double;
begin
  Node1 := Item1;
  Node2 := Item2;
  Value := Node1.FPolyHedron.bmin[X] - Node2.FPolyHedron.bmin[X];
  if Value > 0 then
  begin
    result := 1;
  end
  else if Value < 0 then
  begin
    result := -1;
  end
  else
  begin
    result := 0;
  end;
end;

function SortNodesXMax(Item1, Item2: Pointer): Integer;
var
  Node1, Node2 : TVirtualNode;
  Value : double;
begin
  Node1 := Item1;
  Node2 := Item2;
  Value := Node1.FPolyHedron.bmax[X] - Node2.FPolyHedron.bmax[X];
  if Value > 0 then
  begin
    result := 1;
  end
  else if Value < 0 then
  begin
    result := -1;
  end
  else
  begin
    result := 0;
  end;
end;

function SortNodesYMin(Item1, Item2: Pointer): Integer;
var
  Node1, Node2 : TVirtualNode;
  Value : double;
begin
  Node1 := Item1;
  Node2 := Item2;
  Value := Node1.FPolyHedron.bmin[Y] - Node2.FPolyHedron.bmin[Y];
  if Value > 0 then
  begin
    result := 1;
  end
  else if Value < 0 then
  begin
    result := -1;
  end
  else
  begin
    result := 0;
  end;
end;

function SortNodesYMax(Item1, Item2: Pointer): Integer;
var
  Node1, Node2 : TVirtualNode;
  Value : double;
begin
  Node1 := Item1;
  Node2 := Item2;
  Value := Node1.FPolyHedron.bmax[Y] - Node2.FPolyHedron.bmax[Y];
  if Value > 0 then
  begin
    result := 1;
  end
  else if Value < 0 then
  begin
    result := -1;
  end
  else
  begin
    result := 0;
  end;
end;

function SortNodesZMin(Item1, Item2: Pointer): Integer;
var
  Node1, Node2 : TVirtualNode;
  Value : double;
begin
  Node1 := Item1;
  Node2 := Item2;
  Value := Node1.FPolyHedron.bmin[Z] - Node2.FPolyHedron.bmin[Z];
  if Value > 0 then
  begin
    result := 1;
  end
  else if Value < 0 then
  begin
    result := -1;
  end
  else
  begin
    result := 0;
  end;
end;

function SortNodesZMax(Item1, Item2: Pointer): Integer;
var
  Node1, Node2 : TVirtualNode;
  Value : double;
begin
  Node1 := Item1;
  Node2 := Item2;
  Value := Node1.FPolyHedron.bmax[Z] - Node2.FPolyHedron.bmax[Z];
  if Value > 0 then
  begin
    result := 1;
  end
  else if Value < 0 then
  begin
    result := -1;
  end
  else
  begin
    result := 0;
  end;
end;

procedure GetNodesInRange(SortedMinListOfNodes, NodesInRange : TList;
  Min, Max : double; Dimension : integer);
var
  LowIndex, HighIndex, MidIndex : integer;
  StartIndex, StopIndex : integer;
  ANode : TVirtualNode;
  Index : integer;
  TempList : TList;
  APolyHedron : TPolyHedron;
begin
  if Max > 0 then
  begin
    Max := Max * (1 + Epsilon);
  end
  else if Max < 0 then
  begin
    Max := Max * (1 - Epsilon);
  end
  else
  begin
    Max := Epsilon
  end;

  if Min > 0 then
  begin
    Min := Min * (1 - Epsilon);
  end
  else if Min < 0 then
  begin
    Min := Min * (1 + Epsilon);
  end
  else
  begin
    Min := -Epsilon
  end;
  Assert((Dimension = X) or (Dimension = Y) or (Dimension = Z));
  Assert(SortedMinListOfNodes <> NodesInRange);
  NodesInRange.Clear;
  if SortedMinListOfNodes.Count = 0 then Exit;

  ANode := SortedMinListOfNodes[0];
  APolyHedron := ANode.FPolyHedron;
  if APolyHedron.bmin[Dimension] > Max then
  begin
//    ANode.FreePolyHedron;
    Exit;
  end;
//  ANode.FreePolyHedron;

  ANode := SortedMinListOfNodes[SortedMinListOfNodes.Count-1];
  APolyHedron := ANode.FPolyHedron;
  if APolyHedron.bmax[Dimension] < Min then
  begin
//    ANode.FreePolyHedron;
    Exit;
  end;

  if SortedMinListOfNodes.Count = 1 then
  begin
    NodesInRange.Add(ANode);
    Exit;
  end;

  if APolyHedron.bmin[Dimension] < Max then
  begin
    StopIndex := SortedMinListOfNodes.Count-1;
  end
  else
  begin
    LowIndex := 0;
    HighIndex := SortedMinListOfNodes.Count-1;

    while HighIndex - LowIndex > 1 do
    begin
      MidIndex := (HighIndex + LowIndex) div 2;
      ANode := SortedMinListOfNodes[MidIndex];
      APolyHedron := ANode.FPolyHedron;
      if APolyHedron.bmin[Dimension] < Max then
      begin
        LowIndex := MidIndex;
      end
      else
      begin
        HighIndex := MidIndex;
      end;
    end;
    if APolyHedron.bmin[Dimension] < Max then
    begin
      StopIndex := LowIndex;
    end
    else
    begin
      StopIndex := HighIndex;
    end;
  end;



  TempList := TList.Create;
  try
    TempList.Capacity := StopIndex + 1;
    for Index := 0 to StopIndex do
    begin
      TempList.Add(SortedMinListOfNodes[Index]);
    end;
    Case Dimension of
      X:
        TempList.Sort(SortNodesXMax);
      Y:
        TempList.Sort(SortNodesYMax);
      Z:
        TempList.Sort(SortNodesZMax);
    end;
    if TempList.Count > 0 then
    begin
      ANode := TempList[0];
      APolyHedron := ANode.FPolyHedron;
      if APolyHedron.bmax[Dimension] > Min then
      begin
        StartIndex := 0;
      end
      else
      begin
        LowIndex := 0;
        HighIndex := TempList.Count-1;
        while HighIndex - LowIndex > 1 do
        begin
          MidIndex := (HighIndex + LowIndex) div 2;
          ANode := TempList[MidIndex];
          APolyHedron := ANode.FPolyHedron;
          if APolyHedron.bmax[Dimension] > Min then
          begin
            HighIndex := MidIndex;
          end
          else
          begin
            LowIndex := MidIndex;
          end;
        end;
        if APolyHedron.bmax[Dimension] > Min then
        begin
          StartIndex := HighIndex;
        end
        else
        begin
          StartIndex := LowIndex;
        end;
      end;

      NodesInRange.Capacity := TempList.Count - StartIndex;
      for Index := StartIndex to TempList.Count -1 do
      begin
        NodesInRange.Add(TempList[Index]);
      end;
    end;
  finally
    TempList.Free;
  end;
end;

{ TRealNode }

procedure TRealNode.ArrangeElements;
var
  Index, NodeIndex : integer;
  AnElement, AnotherElement : TRealElement;
  ANode : TRealNode;
  AList : TList;
  Found : boolean;
begin
  AList := TList.Create;
  if FElements.Count > 0 then
  begin
    AList.Capacity := FElements.Count;
    AnElement := FElements[0];
    AList.Add(AnElement);
    FElements.Delete(0);
    Index := AnElement.FNodes.IndexOf(self);
    Assert(Index > -1);
    if Index = AnElement.FNodes.Count -1 then
    begin
      ANode := AnElement.FNodes[0];
    end
    else
    begin
      ANode := AnElement.FNodes[Index+1];
    end;
    Found := True;
    While Found do
    begin
      Found := False;
      for Index := 0 to FElements.Count -1 do
      begin
        AnotherElement := FElements[Index];
        if AnotherElement.FNodes.IndexOf(ANode)>-1 then
        begin
          AList.Add(AnotherElement);
          FElements.Remove(AnotherElement);
          AnElement := AnotherElement;
          NodeIndex := AnElement.FNodes.IndexOf(self);
          Assert(NodeIndex > -1);
          if NodeIndex = AnElement.FNodes.Count -1 then
          begin
            ANode := AnElement.FNodes[0];
          end
          else
          begin
            ANode := AnElement.FNodes[NodeIndex+1];
          end;
          Found := True;
          break;
        end;
      end;
    end;
    if FElements.Count > 0 then
    begin
      AnElement := AList[0];
      Index := AnElement.FNodes.IndexOf(self);
      Assert(Index > -1);
      if Index = 0 then
      begin
        ANode := AnElement.FNodes[AnElement.FNodes.Count -1];
      end
      else
      begin
        ANode := AnElement.FNodes[Index-1];
      end;
      Found := True;
      While Found do
      begin
        Found := False;
        for Index := 0 to FElements.Count -1 do
        begin
          AnotherElement := FElements[Index];
          if AnotherElement.FNodes.IndexOf(ANode)>-1 then
          begin
            AList.Insert(0,AnotherElement);
            FElements.Remove(AnotherElement);
            AnElement := AnotherElement;
            NodeIndex := AnElement.FNodes.IndexOf(self);
            Assert(NodeIndex > -1);
            if NodeIndex = 0 then
            begin
              ANode := AnElement.FNodes[AnElement.FNodes.Count -1];
            end
            else
            begin
              ANode := AnElement.FNodes[NodeIndex-1];
            end;
            Found := True;
            break;
          end;
        end;
      end;
    end;
  end;
  try
    Assert(FElements.Count = 0);
  except on EAssertionFailed do
    begin
      AList.Free;
      raise Exception.Create('Error: Check that the nodes in the elements '
        + 'surrounding the node at (X,Y,Z) = ('
        + FloatToStr(FX) + ', '
        + FloatToStr(FY) + ', '
        + FloatToStr(FZ) + ') '
        + 'are numbered correctly or try recreating the mesh.')
    end;
  end;
  FElements.Free;
  FElements := AList;

end;

function TRealNode.BooleanParameterValue(ModelHandle : ANE_PTR;
  ParameterIndex: ANE_INT16): ANE_BOOL;
var
  NodeOptions : TNodeObjectOptions;
begin
  NodeOptions := TNodeObjectOptions.Create(ModelHandle,
    FMesh.FLayerHandle, FNodeIndex);
  try
    result := NodeOptions.GetBoolParameter(ModelHandle, ParameterIndex);
  finally
    NodeOptions.Free;
  end;
end;

constructor TRealNode.Create(ModelHandle : ANE_PTR; AMesh: TReal2DMesh;
  Index: ANE_INT32; LayerIndex : integer);
var
  NodeOptions : TNodeObjectOptions;
begin
  inherited Create;
  FElements := TList.Create;
  FElements.Capacity := 5;
  FMesh := AMesh;
  FNodeIndex := Index;

  NodeOptions := TNodeObjectOptions.Create
    (ModelHandle, FMesh.FLayerHandle, Index);
  try
    NodeOptions.GetLocation(ModelHandle, FX,FY);
    GetElevation(ModelHandle, LayerIndex);
  finally
    NodeOptions.Free;
  end;

end;

destructor TRealNode.Destroy;
begin
  FElements.Free;
  inherited;
end;

function TRealNode.ElementCount: integer;
begin
  result := FElements.Count;
end;

function TRealNode.GetElement(Index: integer): TRealElement;
begin
  result := FElements[Index];
end;

procedure TRealNode.GetElevation(ModelHandle : ANE_PTR; LayerIndex : integer);
var
  ParameterIndex : ANE_INT16;
  parameterName : string;
  NodeOptions : TNodeObjectOptions;
  N : String;
  MultipleUnits : boolean;
begin
  N := frmSutra.GetN(MultipleUnits);
  parameterName := TZParam.WriteParamName;
  if (N <> '0') and MultipleUnits then
  begin
    parameterName := parameterName + IntToStr(LayerIndex);
  end;


  ParameterIndex := UGetParameterIndex(ModelHandle,
         FMesh.FLayerHandle, parameterName);
  Assert( ParameterIndex>-1);
  NodeOptions := TNodeObjectOptions.Create(ModelHandle,
         FMesh.FLayerHandle, FNodeIndex);
  try
    FZ := NodeOptions.GetFloatParameter(ModelHandle, ParameterIndex);
  finally
    NodeOptions.Free;
  end;

end;

function TRealNode.IntegerParameterValue(ModelHandle : ANE_PTR;
  ParameterIndex: ANE_INT16): ANE_INT32;
var
  NodeOptions : TNodeObjectOptions;
begin
  NodeOptions := TNodeObjectOptions.Create(ModelHandle,
    FMesh.FLayerHandle, FNodeIndex);
  try
    result := NodeOptions.GetIntegerParameter(ModelHandle, ParameterIndex);
  finally
    NodeOptions.Free;
  end;
end;

function TRealNode.Cell : TPolygon;
var
  Count : integer;
  Locations : array of TLocation;
  Index, InnerIndex : integer;
  AnElement : TRealElement;
  ALocation : TLocation;
  ANode : TRealNode;
  NodeIndex : integer;
begin
  Count := FElements.Count * 4;
  Assert(Count > 0);
  SetLength(Locations, Count);
  for Index := 0 to FElements.Count -1 do
  begin
    ALocation.X := FX;
    ALocation.Y := FY;
    Locations[Index*4] := ALocation;

    AnElement := FElements[Index];

    NodeIndex := AnElement.FNodes.IndexOf(self);
    if NodeIndex = 0 then
    begin
      NodeIndex := AnElement.FNodes.Count -1;
    end
    else
    begin
      Dec(NodeIndex);
    end;
    ANode := AnElement.FNodes[NodeIndex];
    ALocation.X := (FX + ANode.FX)/2;
    ALocation.Y := (FY + ANode.FY)/2;
    Locations[Index*4+1] := ALocation;

    AnElement.GetCenter(ALocation.X, ALocation.Y);
    Locations[Index*4+2] := ALocation;

    NodeIndex := AnElement.FNodes.IndexOf(self);
    if NodeIndex = AnElement.FNodes.Count -1 then
    begin
      NodeIndex := 0;
    end
    else
    begin
      Inc(NodeIndex);
    end;
    ANode := AnElement.FNodes[NodeIndex];
    ALocation.X := (FX + ANode.FX)/2;
    ALocation.Y := (FY + ANode.FY)/2;
    Locations[Index*4+3] := ALocation;

  end;

  if NearlyTheSame(Locations[1].X, Locations[Count-1].X, Epsilon)
    and NearlyTheSame(Locations[1].Y, Locations[Count-1].Y, Epsilon) then
  begin
    for InnerIndex := 0 to Count - 3 do
    begin
      Locations[InnerIndex] := Locations[InnerIndex+2]
    end;
    Dec(Count,2);
  end;


{  for Index := Count-2 downto 0 do
  begin
    if (Locations[Index].X = Locations[Index+1].X)
      and (Locations[Index].Y = Locations[Index+1].Y) then
    begin
      for InnerIndex := Index + 1 to Count - 2 do
      begin
        Locations[InnerIndex] := Locations[InnerIndex+1]
      end;
      Dec(Count);
    end;
  end;  }

  for Index := Count-2 downto 1 do
  begin
    if NearlyTheSame(Locations[Index-1].X, Locations[Index+1].X, Epsilon)
      and NearlyTheSame(Locations[Index-1].Y, Locations[Index+1].Y, Epsilon) then
    begin
      for InnerIndex := Index to Count - 3 do
      begin
        Locations[InnerIndex] := Locations[InnerIndex+2]
      end;
      Dec(Count,2);
//      SetLength(Locations,Count);
    end;
  end;

  SetLength(Locations,Count);

//  Locations[Count-1] := Locations[0];
  result := TPolygon.Create(Locations,Count);

end;

function TRealNode.IsInsideCell(X, Y: double): boolean;
var
  TestLocation : TLocation;
  APolygon : TPolygon;
begin
  TestLocation.X := X;
  TestLocation.Y := Y;
  APolygon := Cell;
  try
    result := APolygon.IsLocationInside(TestLocation);
  finally
    APolygon.Free;
  end;
end;

function TRealNode.SegmentIntercept(ASegment : TSegmentObject) : TSegmentList;
var
  APolygon : TPolygon;
  PointList, OrderList : TList;
  Intercept : TPointd;
  Edge : TSegmentObject;
  Index : integer;
  APoint, AnotherPoint, StartPoint, EndPoint : TPointObject;
  ALocation : TLocation;
  InterceptSegment : TSegmentObject;
begin
  result := TSegmentList.Create;
  PointList := TList.Create;
  OrderList := TList.Create;
  Edge := TSegmentObject.Create;
  APolygon := Cell;
  try
    StartPoint := TPointObject.Create;
    StartPoint.Location := ASegment.StartLoc;
    OrderList.Add(StartPoint);

    EndPoint := TPointObject.Create;
    EndPoint.Location := ASegment.EndLoc;
    OrderList.Add(EndPoint);

    ALocation.X := ASegment.StartLoc[0];
    ALocation.Y := ASegment.StartLoc[1];
    if APolygon.IsLocationInside(ALocation) then
    begin
      APoint := TPointObject.Create;
      APoint.Location := ASegment.StartLoc;
      PointList.Add(APoint);
    end;

    ALocation.X := ASegment.EndLoc[0];
    ALocation.Y := ASegment.EndLoc[1];
    if APolygon.IsLocationInside(ALocation) then
    begin
      APoint := TPointObject.Create;
      APoint.Location := ASegment.EndLoc;
      PointList.Add(APoint);
    end;

    for Index := 0 to APolygon.Count -2 do
    begin
      Edge.StartLoc[0] := APolygon.Location[Index].X;
      Edge.StartLoc[1] := APolygon.Location[Index].Y;
      Edge.EndLoc[0] := APolygon.Location[Index+1].X;
      Edge.EndLoc[1] := APolygon.Location[Index+1].Y;
      if ASegment.TwoDIntersection(Edge, Intercept) then
      begin
        APoint := TPointObject.Create;
        APoint.Location := Intercept;
        PointList.Add(APoint);
      end;
    end;
    if PointList.Count > 1 then
    begin
      PointList.Sort(SortPointObjects);
      OrderList.Sort(SortPointObjects);
      if OrderList.IndexOf(StartPoint) > 0 then
      begin
        for Index := 0 to (PointList.Count -1) div 2 do
        begin
          PointList.Exchange(Index, PointList.Count-Index-1);
        end;
      end;
      for Index := 0 to PointList.Count -2 do
      begin
        APoint := PointList[Index];
        AnotherPoint := PointList[Index+1];
        ALocation.X := (APoint.X + AnotherPoint.X)/2;
        ALocation.Y := (APoint.Y + AnotherPoint.Y)/2;
        if APolygon.IsLocationInside(ALocation) then
        begin
          InterceptSegment := TSegmentObject.Create;
          InterceptSegment.StartLoc := APoint.Location;
          InterceptSegment.EndLoc := AnotherPoint.Location;
          result.Add(InterceptSegment);
        end;
      end;

    end;
  finally
    APolygon.Free;
    Edge.Free;

    for Index := 0 to PointList.Count -1 do
    begin
      TPointObject(PointList[Index]).Free;
    end;
    for Index := 0 to OrderList.Count -1 do
    begin
      TPointObject(OrderList[Index]).Free;
    end;

    PointList.Free;
    OrderList.Free;
  end;

end;

function TRealNode.RealParameterValue(ModelHandle : ANE_PTR; ParameterIndex: ANE_INT16): ANE_DOUBLE;
var
  NodeOptions : TNodeObjectOptions;
begin
  NodeOptions := TNodeObjectOptions.Create(ModelHandle,
    FMesh.FLayerHandle, FNodeIndex);
  try
    result := NodeOptions.GetFloatParameter(ModelHandle, ParameterIndex);
  finally
    NodeOptions.Free;
  end;
end;

function TRealNode.StringParameterValue(ModelHandle : ANE_PTR; ParameterIndex: ANE_INT16): string;
var
  NodeOptions : TNodeObjectOptions;
begin
  NodeOptions := TNodeObjectOptions.Create(ModelHandle,
    FMesh.FLayerHandle, FNodeIndex);
  try
    result := NodeOptions.GetStringParameter(ModelHandle, ParameterIndex);
  finally
    NodeOptions.Free;
  end;
end;

{ TRealElement }

function TRealElement.BooleanParameterValue(ModelHandle : ANE_PTR;
  ParameterIndex: ANE_INT16): ANE_BOOL;
var
  ElementOptions : TElementObjectOptions;
begin
  ElementOptions := TElementObjectOptions.Create(ModelHandle,
    FMesh.FLayerHandle, FElementIndex);
  try
    result := ElementOptions.GetBoolParameter(ModelHandle, ParameterIndex);
  finally
    ElementOptions.Free;
  end;
end;

constructor TRealElement.Create(ModelHandle : ANE_PTR; AMesh: TReal2DMesh;
  Index: ANE_INT32);
var
  ElementOptions : TElementObjectOptions;
  NodeIndex, NodeNumber : integer;
  ANode : TRealNode;
begin
  inherited Create;
  FMesh := AMesh;
  FElementIndex := Index;
  FNodes := TList.Create;
  FNodes.Capacity := 4;

  ElementOptions := TElementObjectOptions.Create
    (ModelHandle, FMesh.FLayerHandle, Index);
  try
    for NodeIndex := 0 to ElementOptions.NumberOfNodes(ModelHandle) -1 do
    begin
      NodeNumber := ElementOptions.GetNthNodeNumber(ModelHandle,NodeIndex);
      ANode := FMesh.FNodes[NodeNumber-1];
      FNodes.Add(ANode);
      ANode.FElements.Add(self);
    end;
  finally
    ElementOptions.Free;
  end;

end;

constructor TRealElement.CreateWithNodes(ModelHandle: ANE_PTR;
  AMesh: TReal2DMesh; Index: ANE_INT32; NodeNumbers: array of integer;
  NodeCount: integer);
var
//  ElementOptions : TElementObjectOptions;
  NodeIndex, NodeNumber : integer;
  ANode : TRealNode;
begin
  inherited Create;
  FMesh := AMesh;
  FElementIndex := Index;
  FNodes := TList.Create;
  FNodes.Capacity := NodeCount;

  for NodeIndex := 0 to NodeCount -1 do
  begin
    NodeNumber := NodeNumbers[NodeIndex];
    if NodeNumber > FMesh.FNodes.Count then
    begin
      raise EInvalidMesh.Create('The mesh is invalid. '
        + 'Try renumbering the mesh (Special|Renumber...).');
    end;
    ANode := FMesh.FNodes[NodeNumber-1];
    FNodes.Add(ANode);
    ANode.FElements.Add(self);
  end;
end;

destructor TRealElement.Destroy;
begin
  FNodes.Free;
  inherited;
end;

procedure TRealElement.GetCenter(var X, Y: double);
var
  Index : integer;
  ANode : TRealNode;
begin
  X := 0;
  Y := 0;

  Assert( FNodes.Count > 0);

  for Index := 0 to FNodes.Count -1 do
  begin
    ANode := FNodes[Index];
    X := X + ANode.FX;
    Y := Y + ANode.FY;
  end;

  X := X/FNodes.Count;
  Y := Y/FNodes.Count;

end;

function TRealElement.GetNode(NodeIndex: integer): TRealNode;
begin
  result := FNodes[NodeIndex];
end;

function TRealElement.IntegerParameterValue(ModelHandle : ANE_PTR;
  ParameterIndex: ANE_INT16): ANE_INT32;
var
  ElementOptions : TElementObjectOptions;
begin
  ElementOptions := TElementObjectOptions.Create(ModelHandle,
    FMesh.FLayerHandle, FElementIndex);
  try
    result := ElementOptions.GetIntegerParameter(ModelHandle, ParameterIndex);
  finally
    ElementOptions.Free;
  end;
end;

function TRealElement.RealParameterValue(ModelHandle : ANE_PTR;
  ParameterIndex: ANE_INT16): ANE_DOUBLE;
var
  ElementOptions : TElementObjectOptions;
begin
  ElementOptions := TElementObjectOptions.Create(ModelHandle,
    FMesh.FLayerHandle, FElementIndex);
  try
    result := ElementOptions.GetFloatParameter(ModelHandle, ParameterIndex);
  finally
    ElementOptions.Free;
  end;
end;

function TRealElement.StringParameterValue(ModelHandle : ANE_PTR;
  ParameterIndex: ANE_INT16): string;
var
  ElementOptions : TElementObjectOptions;
begin
  ElementOptions := TElementObjectOptions.Create(ModelHandle,
    FMesh.FLayerHandle, FElementIndex);
  try
    result := ElementOptions.GetStringParameter(ModelHandle, ParameterIndex);
  finally
    ElementOptions.Free;
  end;
end;

{ TReal2DMesh }


procedure TReal2DMesh.ArrangeElements;
var
  Index : integer;
  ANode : TRealNode;
begin
  for Index := 0 to FNodes.Count -1 do
  begin
    ANode := FNodes[Index];
    ANode.ArrangeElements;
  end;
end;

function TReal2DMesh.BooleanValue(ModelHandle : ANE_PTR; X,Y : Double; Expression: String): ANE_BOOL;
var
  LayerOptions : TLayerOptions;
  LayerIndexString : String;
begin
  LayerIndexString := '';
  if frmSutra.VerticallyAlignedMesh then
  begin
    LayerIndexString := IntToStr(FLayerIndex);
  end;
  Expression := Expression + LayerIndexString;
  LayerOptions := OptionsList.Objects[OptionsList.IndexOf(Expression)] as TLayerOptions;
  result := LayerOptions.BooleanValueAtXY(ModelHandle, X,Y{,Expression});
end;

constructor TReal2DMesh.Create(ModelHandle : ANE_PTR;
  const LayerHandle: ANE_PTR; LayerIndex : integer);
begin
  inherited Create;
  FNodes := TList.Create;
  FElements := TList.Create;
  OptionsList := TStringList.Create;
//  FModelHandle := ModelHandle;
  FLayerHandle := LayerHandle;
  FLayerIndex := LayerIndex;
  ReadMesh(ModelHandle, LayerIndex);
  ArrangeElements;
end;

procedure TReal2DMesh.Free(ModelHandle : ANE_PTR);
begin
  MeshModelHandle := ModelHandle;
  inherited Free;
end;

destructor TReal2DMesh.Destroy;
var
  Index : integer;
begin
  for Index := FNodes.Count -1 downto 0 do
  begin
    TRealNode(FNodes[Index]).Free;
  end;
  FNodes.Free;

  for Index := FElements.Count -1 downto 0 do
  begin
    TRealElement(FElements[Index]).Free;
  end;
  FElements.Free;


  FreeParsedExpression(MeshModelHandle);
  OptionsList.Free;
  inherited Destroy;
end;

procedure TReal2DMesh.FreeParsedExpression(ModelHandle : ANE_PTR);
var
  Index : integer;
  LayerOptions : TLayerOptions;
begin
  for Index := 0 to OptionsList.Count -1 do
  begin
    LayerOptions := OptionsList.Objects[Index] as TLayerOptions;
    LayerOptions.Free(ModelHandle);
  end;
  OptionsList.Clear;
//  FLayerOptions.FreeParsedExpression;
end;

function TReal2DMesh.GetElement(ElementIndex: Integer): TRealElement;
begin
  result := FElements[ElementIndex];
end;

function TReal2DMesh.GetNode(NodeIndex: Integer): TRealNode;
begin
  result := FNodes[NodeIndex];
end;


function TReal2DMesh.IntegerValue(ModelHandle : ANE_PTR; X,Y : Double; Expression: String): ANE_INT32;
var
  LayerOptions : TLayerOptions;
  LayerIndexString : String;
begin
  LayerIndexString := '';
  if frmSutra.VerticallyAlignedMesh then
  begin
    LayerIndexString := IntToStr(FLayerIndex);
  end;
  Expression := Expression + LayerIndexString;
  LayerOptions := OptionsList.Objects[OptionsList.IndexOf(Expression)] as TLayerOptions;
  result := LayerOptions.IntegerValueAtXY(ModelHandle,X,Y{,Expression});
end;

function TReal2DMesh.NodeCount: integer;
begin
  result := FNodes.Count;
end;

procedure TReal2DMesh.NodesOnSegment(const ASegment: TSegmentObject;
  ListOfNodes: TList);
var
  SegmentList : TSegmentList;
  SegmentIndex : integer;
  NodeIndex : integer;
  ANode : TRealNode;
  ListOfSegments, AnotherListOfSegments : TList;
  FirstSegment, LastSegment, AnotherSegment : TSegmentObject;
  TempLocation : TPointd;
  FoundSegment : boolean;
begin
  ListOfNodes.Clear;
  ListOfSegments := TList.Create;
  AnotherListOfSegments := TList.Create;
  try // try 1
    for NodeIndex := 0 to NodeCount -1 do
    begin
      ANode := Nodes[NodeIndex];
      SegmentList := ANode.SegmentIntercept(ASegment);
      try // try 2
        for SegmentIndex := 0 to SegmentList.Count -1 do
        begin
          ListOfSegments.Add(SegmentList[SegmentIndex]);
        end;
      finally
        SegmentList.Free;
      end; // try 2
    end; // for NodeIndex := 0 to NodeCount -1 do
    if ListOfSegments.Count > 0 then
    begin
      LastSegment := ListOfSegments[0];
      FirstSegment := ListOfSegments[0];
      AnotherListOfSegments.Add(LastSegment);
      ListOfSegments.Delete(0);
      While ListOfSegments.Count > 0 do
      begin
        FoundSegment := False;
        for SegmentIndex := 0 to ListOfSegments.Count -1 do
        begin
          AnotherSegment := ListOfSegments[SegmentIndex];
          if EndsMatch(LastSegment, AnotherSegment) then
          begin
            AnotherListOfSegments.Add(AnotherSegment);
            ListOfSegments.Delete(SegmentIndex);
            LastSegment := AnotherSegment;
            FoundSegment := True;
            break;
          end // if EndsMatch(FirstSegment, AnotherSegment) then
          else if WrongEndsMatch(LastSegment, AnotherSegment) then
          begin
            TempLocation := AnotherSegment.StartLoc;
            AnotherSegment.StartLoc := AnotherSegment.EndLoc;
            AnotherSegment.EndLoc := TempLocation;
            AnotherListOfSegments.Add(AnotherSegment);
            ListOfSegments.Delete(SegmentIndex);
            LastSegment := AnotherSegment;
            FoundSegment := True;
            break;
          end // else if WrongEndsMatch(FirstSegment, AnotherSegment) then
          else if EndsMatch(AnotherSegment, FirstSegment) then
          begin
            AnotherListOfSegments.Insert(0, AnotherSegment);
            ListOfSegments.Delete(SegmentIndex);
            FirstSegment := AnotherSegment;
            FoundSegment := True;
            break;
          end // else if EndsMatch(AnotherSegment, FirstSegment) then
          else if WrongEndsMatch(AnotherSegment, FirstSegment) then
          begin
            TempLocation := AnotherSegment.StartLoc;
            AnotherSegment.StartLoc := AnotherSegment.EndLoc;
            AnotherSegment.EndLoc := TempLocation;
            AnotherListOfSegments.Insert(0, AnotherSegment);
            ListOfSegments.Delete(SegmentIndex);
            FirstSegment := AnotherSegment;
            FoundSegment := True;
            break;
          end  // else if WrongEndsMatch(AnotherSegment, FirstSegment) then
        end; // for SegmentIndex := 0 to ListOfSegments.Count -1 do
        if not FoundSegment and (ListOfSegments.Count > 0) then
        begin
          LastSegment := ListOfSegments[0];
          AnotherListOfSegments.Add(LastSegment);
          ListOfSegments.Delete(0);
        end; // if not FoundSegment and ListOfSegments.Count > 0 then
      end; // While ListOfSegments.Count > 0 do
    end; // if ListOfSegments.Count > 0 then
    for SegmentIndex := 0 to AnotherListOfSegments.Count -1 do
    begin
      LastSegment := AnotherListOfSegments[SegmentIndex];
      for NodeIndex := 0 to NodeCount -1 do
      begin
        ANode := Nodes[NodeIndex];
        if ListOfNodes.IndexOf(ANode) < 0 then
        begin
          if ANode.IsInsideCell(
            (LastSegment.StartLoc[X] + LastSegment.EndLoc[X])/2,
            (LastSegment.StartLoc[Y] + LastSegment.EndLoc[Y])/2) then
          begin
            ListOfNodes.Add(ANode);
          end; // if ANode.IsInsideCell
        end; // if ListOfNodes.IndexOf(ANode) < 0 then

      end; // for NodeIndex := 0 to NodeCount -1 do

    end; // for SegmentIndex := 0 to AnotherListOfSegments.Count -1 do

  finally
    for SegmentIndex := 0 to AnotherListOfSegments.Count -1 do
    begin
      TSegmentObject(AnotherListOfSegments[SegmentIndex]).Free;
    end; // for SegmentIndex := 0 to AnotherListOfSegments.Count -1 do

    for SegmentIndex := 0 to ListOfSegments.Count -1 do
    begin
      TSegmentObject(AnotherListOfSegments[SegmentIndex]).Free;
    end; // for SegmentIndex := 0 to ListOfSegments.Count -1 do

    ListOfSegments.Free;
    AnotherListOfSegments.Free;
  end; // // try 1

end;

{function TReal2DMesh.ParameterIndex(ModelHandle : ANE_PTR; ParameterName: string): ANE_INT16;
begin
  result := ANE_LayerGetParameterByName(ModelHandle, FLayerHandle,
    PChar(ParameterName));
end;   }

procedure TReal2DMesh.ParseExpression(ModelHandle : ANE_PTR; Expression: string;
  NumberType : TPIENumberType);
var
  LayerOptions : TLayerOptions;
begin
  LayerOptions := TLayerOptions.Create(FLayerHandle);
  OptionsList.AddObject(Expression,LayerOptions);
  LayerOptions.ParseExpression(ModelHandle, Expression, NumberType);
end;

{
//Old version : slow
procedure TReal2DMesh.ReadElements(ModelHandle: ANE_PTR);
var
  LayerOptions : TLayerOptions;
  Index : integer;
  AnElement : TRealElement;
  NumberOfElements : Integer;
begin
  LayerOptions := TLayerOptions.Create(FLayerHandle);
  try
    NumberOfElements := LayerOptions.NumObjects(ModelHandle, pieElementObject);
    FElements.Capacity := NumberOfElements;
    for Index := 0 to NumberOfElements -1  do
    begin
      AnElement := TRealElement.Create(ModelHandle, self, Index);
      FElements.Add(AnElement);
    end;
  finally
    LayerOptions.Free(ModelHandle);
  end;
end; }

// New version
procedure TReal2DMesh.ReadElements(ModelHandle: ANE_PTR);
var
  LayerOptions : TLayerOptions;
  Index : integer;
  AnElement : TRealElement;
//  NumberOfElements : Integer;
  ProjectOptions : TProjectOptions;
  ExportParameters : ANE_BOOL;
  AStringList : TStringList;
//  CopyDelimiter : string;
  ExportSeparator : char;
  ElemLinePrefix : Char;
  NodeLinePrefix : Char;
  ExportSelectionOnly : ANE_BOOL;
  ExportTitles : ANE_BOOL;
  ExportWrap : ANE_INT32;
  ALine : string;
  Nodes : array[0..3] of ANE_INT32;
  TabPosition : integer;
  NumberOfElements : integer;
begin
  ProjectOptions := TProjectOptions.Create;
  LayerOptions := TLayerOptions.Create(FLayerHandle);
  try
      NumberOfElements := LayerOptions.NumObjects(ModelHandle, pieElementObject);
      FElements.Capacity := NumberOfElements;
{      for Index := 0 to NumberOfElements -1  do
      begin
        AnElement := TRealElement.Create(ModelHandle, self, Index);
        FElements.Add(AnElement);
      end;
      }
    ExportParameters := ProjectOptions.ExportParameters[ModelHandle];
    ExportSeparator := ProjectOptions.ExportSeparator[ModelHandle];
    ElemLinePrefix := ProjectOptions.ElemLinePrefix[ModelHandle];
    NodeLinePrefix := ProjectOptions.NodeLinePrefix[ModelHandle];
    ExportSelectionOnly := ProjectOptions.ExportSelectionOnly[ModelHandle];
    ExportTitles := ProjectOptions.ExportTitles[ModelHandle];
    ExportWrap := ProjectOptions.ExportWrap[ModelHandle];
    try
      ProjectOptions.ExportParameters[ModelHandle] := False;
      ProjectOptions.ExportSeparator[ModelHandle] := #9;
      ProjectOptions.ElemLinePrefix[ModelHandle] := 'E';
      ProjectOptions.NodeLinePrefix[ModelHandle] := 'N';
      ProjectOptions.ExportSelectionOnly[ModelHandle] := False;
      ProjectOptions.ExportTitles[ModelHandle] := False;
      ProjectOptions.ExportWrap[ModelHandle] := 0;
      AStringList := TStringList.Create;
      try
        AStringList.Text := LayerOptions.Text[ModelHandle];
        for Index := 0 to AStringList.Count -1 do
        begin
          ALine := AStringList[Index];

          if (Length(ALine) > 0) and (ALine[1] = 'E') then
          begin
            ALine := Trim(Copy(ALine,2,Length(ALine)));
            TabPosition := Pos(#9,ALine);
            ALine := Trim(Copy(ALine,TabPosition+1,Length(ALine)));
            TabPosition := Pos(#9,ALine);
            Nodes[0] := StrToInt(Copy(ALine,1,TabPosition-1));
            ALine := Trim(Copy(ALine,TabPosition+1,Length(ALine)));
            TabPosition := Pos(#9,ALine);
            Nodes[1] := StrToInt(Copy(ALine,1,TabPosition-1));
            ALine := Trim(Copy(ALine,TabPosition+1,Length(ALine)));
            TabPosition := Pos(#9,ALine);
            if TabPosition > 0 then
            begin
              Nodes[2] := StrToInt(Copy(ALine,1,TabPosition-1));
              ALine := Trim(Copy(ALine,TabPosition+1,Length(ALine)));
              Nodes[3] := StrToInt(ALine);
              AnElement := TRealElement.CreateWithNodes(ModelHandle, self, Index,
                Nodes, 4);
            end
            else
            begin
              Nodes[2] := StrToInt(ALine);
              AnElement := TRealElement.CreateWithNodes(ModelHandle, self, Index,
                Nodes, 3);
            end;
            FElements.Add(AnElement);
          end;
        end;

      finally
        AStringList.Free;
      end;


{      NumberOfElements := LayerOptions.NumObjects(ModelHandle, pieElementObject);
      FElements.Capacity := NumberOfElements;
      for Index := 0 to NumberOfElements -1  do
      begin
        AnElement := TRealElement.Create(ModelHandle, self, Index);
        FElements.Add(AnElement);
      end;  }

    finally
      ProjectOptions.ExportParameters[ModelHandle] := ExportParameters;
      ProjectOptions.ExportSeparator[ModelHandle] := ExportSeparator;
      ProjectOptions.ElemLinePrefix[ModelHandle] := ElemLinePrefix;
      ProjectOptions.NodeLinePrefix[ModelHandle] := NodeLinePrefix;
      ProjectOptions.ExportSelectionOnly[ModelHandle] := ExportSelectionOnly;
      ProjectOptions.ExportTitles[ModelHandle] := ExportTitles;
      ProjectOptions.ExportWrap[ModelHandle] := ExportWrap;
    end;

  finally
    LayerOptions.Free(ModelHandle);
    ProjectOptions.Free;
  end;
end;

procedure TReal2DMesh.ReadMesh(ModelHandle : ANE_PTR; LayerIndex : integer) ;
begin
  ReadNodes(ModelHandle, LayerIndex);
  ReadElements(ModelHandle);
end;

procedure TReal2DMesh.ReadNodes(ModelHandle: ANE_PTR; LayerIndex : integer);
var
  Index : integer;
  LayerOptions : TLayerOptions;
  ARealNode : TRealNode;
  NumberOfNodes : integer;
begin
  LayerOptions := TLayerOptions.Create( FLayerHandle);
  try
    NumberOfNodes := LayerOptions.NumObjects(ModelHandle, pieNodeObject);
    FNodes.Capacity := NumberOfNodes;
    for Index := 0 to NumberOfNodes -1 do
    begin
      ARealNode := TRealNode.Create(ModelHandle, self, Index, LayerIndex);
      FNodes.Add(ARealNode);
    end;
  finally
    LayerOptions.Free(ModelHandle);
  end;
end;

function TReal2DMesh.RealValue(ModelHandle : ANE_PTR; X,Y : Double; Expression: String): ANE_DOUBLE;
var
  LayerOptions : TLayerOptions;
  Index : integer;
  AnObject : TObject;
  LayerIndexString : String;
begin
  LayerIndexString := '';
  if frmSutra.VerticallyAlignedMesh then
  begin
    LayerIndexString := IntToStr(FLayerIndex);
  end;
  Expression := Expression + LayerIndexString;
  Index := OptionsList.IndexOf(Expression);
  AnObject := OptionsList.Objects[Index];
  LayerOptions := AnObject  as TLayerOptions;
//  LayerOptions := OptionsList.Objects[OptionsList.IndexOf(Expression)] as TLayerOptions;
  result := LayerOptions.RealValueAtXY(ModelHandle,X,Y{,Expression});
end;

function TReal2DMesh.StringValue(ModelHandle : ANE_PTR; X,Y : Double; Expression: String): string;
var
  LayerOptions : TLayerOptions;
  LayerIndexString : String;
begin
  LayerIndexString := '';
  if frmSutra.VerticallyAlignedMesh then
  begin
    LayerIndexString := IntToStr(FLayerIndex);
  end;
  Expression := Expression + LayerIndexString;
  LayerOptions := OptionsList.Objects[OptionsList.IndexOf(Expression)] as TLayerOptions;
  result := LayerOptions.StringValueAtXY(ModelHandle,X,Y{,Expression});
end;

{ TVirtual3DMesh }


constructor TVirtual3DMesh.Create(ModelHandle: ANE_PTR;
  Discretization: TIntegerList; GrowthRates: TRealList;
  const GrowthTypes: TGrowthTypeArray; MorphMesh : T3DMorphMesh);
var
  Index : integer;
begin
  inherited Create(ModelHandle, Discretization.Count);
  Assert(GrowthRates.Count = Length(GrowthTypes));
  NodeFilePositions := TIntegerList.Create;
  PolyhedronPositions := NodeFilePositions;
  FMorphMesh := MorphMesh;
  assert((FMorphMesh = nil) or (FMorphMesh.FRealMeshList.Count = Discretization.Count));
  FDiscretization := TIntegerList.Create;
  FGrowthRates:= TRealList.Create;

  FVirtualMeshCount := 0;
  Assert(Discretization.Count = GrowthRates.Count);
  for Index := 0 to Discretization.Count -1 do
  begin
    FDiscretization.Add(Discretization[Index]);
    FVirtualMeshCount := FVirtualMeshCount + Discretization[Index];
    FGrowthRates.Add(GrowthRates[Index]);
  end;
  FGrowthTypes := GrowthTypes;
  // Make FGrowthTypes unique.
  SetLength(FGrowthTypes, Length(FGrowthTypes));

  assert( FDiscretization[FDiscretization.Count -1] = 1);
  NodeList := TList.Create;
  FSortedNodeList := TList.Create;

  ElementList := TList.Create;
  MakeVirtualNodes(ModelHandle);
  SetEpsilon;
  MakeVirtualElements(ModelHandle);
  SortNodesByMinX;
end;

destructor TVirtual3DMesh.Destroy;
var
  Index : integer;
begin
  FDiscretization.Free;
  FGrowthRates.Free;
  NodeFilePositions.Free;
  PolyhedronPositions := nil;

  if NodeList <> nil then
  begin
    for Index := 0 to NodeList.Count -1 do
    begin
      TVirtualNode(NodeList[Index]).Free;
    end;
  end;
  NodeList.Free;
  FSortedNodeList.Free;
  
  if ElementList <> nil then
  begin
    for Index := 0 to ElementList.Count -1 do
    begin
      TVirtualElement(ElementList[Index]).Free;
    end;
  end;
  ElementList.Free;

  inherited Destroy;
end;

function TVirtual3DMesh.GetVirtualElement(Index: integer): TVirtualElement;
begin
  result := ElementList[Index];
end;

function TVirtual3DMesh.GetVirtualNode(Index: integer): TVirtualNode;
begin
  result := NodeList[Index];
end;

procedure TVirtual3DMesh.MakeVirtualElements(ModelHandle : ANE_PTR);
var
  OuterIndex, InnerIndex : integer;
  InnerLimit : integer;
  MeshAbove, MeshBelow : TReal2DMesh;
  MorphMeshAbove, MorphMeshBelow : TReal2DMesh;
  ElementIndex : integer;
  ElementAbove, ElementBelow : TRealElement;
  LayerIndex : integer;
  Element : TVirtualElement;
  ARealNode, AnotherRealNode : TRealNode;
  AVirtualNode: TVirtualNode;
  NodeIndex : integer;
  VirtualNodeIndexOnLayer : integer;
  ElementStart, ElementEnd : integer;
  Dummy1, Dummy2 : integer;
  SutraLayer: integer;
begin
  ElementList.Capacity := FElementsPerLayer * (FVirtualMeshCount-1);
  LayerIndex := -1;
  ElementEnd := -1;
  ElementStart := 0;
  SutraLayer := 0;
  for OuterIndex := 0 to FDiscretization.Count -2 do
  begin
    MeshAbove := FRealMeshList[OuterIndex];
    MeshBelow := FRealMeshList[OuterIndex+1];
    if FMorphMesh = nil then
    begin
      MorphMeshAbove := nil;
      MorphMeshBelow := nil;
    end
    else
    begin
      MorphMeshAbove := FMorphMesh.Real2DMeshes[OuterIndex];
      MorphMeshBelow := FMorphMesh.Real2DMeshes[OuterIndex+1];
    end;
    InnerLimit := FDiscretization[OuterIndex];
    for InnerIndex := 0 to InnerLimit -1 do
    begin
      Inc(SutraLayer);
      Inc(LayerIndex);
      for ElementIndex := 0 to MeshAbove.FElements.Count -1 do
      begin
        ElementAbove := MeshAbove.Elements[ElementIndex];
        ElementBelow := MeshBelow.Elements[ElementIndex];
        Element := TVirtualElement.Create(self);
        Element.FLayer := SutraLayer;
        Element.ElementAbove := ElementAbove;
        Element.ElementBelow := ElementBelow;
        ElementList.Add(Element);
        Inc(ElementEnd);
        for NodeIndex := 0 to ElementAbove.FNodes.Count -1 do
        begin
          ARealNode := ElementAbove.FNodes[NodeIndex];
          AnotherRealNode := ElementBelow.FNodes[NodeIndex];
          VirtualNodeIndexOnLayer := ARealNode.FNodeIndex;
          Assert(VirtualNodeIndexOnLayer = AnotherRealNode.FNodeIndex);
          AVirtualNode := NodeList[VirtualNodeIndex
            (LayerIndex,VirtualNodeIndexOnLayer)];
          Element.NodeList.Add(AVirtualNode);
          AVirtualNode.ElementList.Add(Element);
        end;
        for NodeIndex := 0 to ElementAbove.FNodes.Count -1 do
        begin
          ARealNode := ElementAbove.FNodes[NodeIndex];
          VirtualNodeIndexOnLayer := ARealNode.FNodeIndex;
          AVirtualNode := NodeList[VirtualNodeIndex
            (LayerIndex+1,VirtualNodeIndexOnLayer)];
          Element.NodeList.Add(AVirtualNode);
          AVirtualNode.ElementList.Add(Element);
        end;
        Element.FX := 0;
        Element.FY := 0;
        Element.FZ := 0;
        for NodeIndex := 0 to Element.NodeList.Count -1 do
        begin
          AVirtualNode := Element.NodeList[NodeIndex];
          Element.FX := Element.FX  + AVirtualNode.X;
          Element.FY := Element.FY  + AVirtualNode.Y;
          Element.FZ := Element.FZ  + AVirtualNode.Z;
        end;
        Element.FX := Element.FX/Element.NodeList.Count;
        Element.FY := Element.FY/Element.NodeList.Count;
        Element.FZ := Element.FZ/Element.NodeList.Count;
        GetElementMorphedCoord(MorphMeshAbove, MorphMeshBelow, Element);
      end;
    end;
    GetElementMorphedFraction(ModelHandle, MeshAbove,MeshBelow, ElementStart, ElementEnd, OuterIndex+1);
    ElementStart := ElementEnd + 1;
  end;
  for ElementIndex := 0 to ElementList.Count -1 do
  begin
    Element := ElementList[ElementIndex];
    Element.CreatePolyhedron;
  end;
  if PolyhedronChoice <> poReadFromFile then
  begin
    for NodeIndex := 0 to NodeList.Count -1 do
    begin
      try
        AVirtualNode := NodeList[NodeIndex];
//        AVirtualNode.PartiallyCreatePolyhedron(NodeIndex);
        if PolyhedronChoice = poCompute then
        begin
          AVirtualNode.PartiallyCreatePolyhedron(NodeIndex, Dummy1, Dummy2);
          AVirtualNode.FPolyHedron.ComputePolyhedronBox;
        end
        else
        begin
          AVirtualNode.CreatePolyhedron(NodeIndex);
          AVirtualNode.FPolyHedron.ComputeBox;
        end;

        AVirtualNode.StorePolyHedron;
        AVirtualNode.FreePolyHedron;
      except
        ShowMessage('Error creating polyhedron for Node ' + IntToStr(NodeIndex+1));
        raise;
      end;
    end;
  end
  else
  begin
    NodeFilePositions.Clear;
    for NodeIndex := 0 to NodeList.Count -1 do
    begin
      try
        AVirtualNode := NodeList[NodeIndex];
        AVirtualNode.FPolyHedron := TPolyhedron.Create(0,0);
        AVirtualNode.FPolyHedron.StorageIndex := NodeIndex;
        Assert(NodeIndex = AVirtualNode.NodeIndex);
        AVirtualNode.FPolyHedron.RestoreBminBMax;
      except
        ShowMessage('Error readin polyhedron for Node ' + IntToStr(NodeIndex+1));
        raise;
      end;
    end;
  end;
end;

procedure GetDiscretizationFractions(const NumberOfElementLayers: integer;
  GrowthRate: double; const GrowthType: TGrowthType;
  var Fractions: TDoubleDynArray);
var
  Index: integer;
  Sum: double;
  CurrentLength: double;
  StartIndex, StopIndex: integer;
begin
  { TODO : Use GrowthTypes here. }
  Assert(NumberOfElementLayers >= 1);

  SetLength(Fractions, NumberOfElementLayers + 1);
  Fractions[0] := 0;
  Fractions[NumberOfElementLayers] := 1;
  if NumberOfElementLayers = 1 then
  begin
    Exit;
  end;

  Assert(GrowthRate > 0);
  if GrowthRate = 1 then
  begin
    for Index := 1 to NumberOfElementLayers -1 do
    begin
      Fractions[Index] := Index/NumberOfElementLayers;
    end;
  end
  else
  begin
    CurrentLength := 1;
    Sum := CurrentLength;
    if GrowthRate <= 0 then
    begin
      GrowthRate := 1;
    end;
    case GrowthType of
      gtNone:
        begin
          for Index := 1 to NumberOfElementLayers-1 do
          begin
            Fractions[Index] := Sum;
            Sum := Sum + CurrentLength;
          end;
        end;
      gtIncreaseDownward:
        begin
          for Index := 1 to NumberOfElementLayers-1 do
          begin
            Fractions[Index] := Sum;
            CurrentLength := CurrentLength * GrowthRate;
            Sum := Sum + CurrentLength;
          end;
        end;
      gtIncreaseUpward:
        begin
          for Index := 1 to NumberOfElementLayers-1 do
          begin
            Fractions[Index] := Sum;
            CurrentLength := CurrentLength / GrowthRate;
            Sum := Sum + CurrentLength;
          end;
        end;
      gtIncreaseTowardMiddle:
        begin
          if Odd(NumberOfElementLayers) then
          begin
            StopIndex := (NumberOfElementLayers div 2);
          end
          else
          begin
            StopIndex := (NumberOfElementLayers div 2)-1;
          end;


          for Index := 1 to StopIndex do
          begin
            Fractions[Index] := Sum;
            CurrentLength := CurrentLength * GrowthRate;
            Sum := Sum + CurrentLength;
          end;
          StartIndex := StopIndex + 1;
          if not Odd(NumberOfElementLayers) then
          begin
            Fractions[StartIndex] := Sum;
            Sum := Sum + CurrentLength;
            Inc(StartIndex);
          end;
          for Index := StartIndex to NumberOfElementLayers-1 do
          begin
            Fractions[Index] := Sum;
            CurrentLength := CurrentLength / GrowthRate;
            Sum := Sum + CurrentLength;
          end;
        end;
    else Assert(False);
    end;

    for Index := 1 to NumberOfElementLayers-1 do
    begin
      Fractions[Index] := Fractions[Index]/Sum;
    end;
  end;
end;

procedure TVirtual3DMesh.MakeVirtualNodes(ModelHandle : ANE_PTR);
var
  InnerIndex, OuterIndex : integer;
  InnerLimit : integer;
  NodeIndex : integer;
  Node : TVirtualNode;
  LayerAbove, LayerBelow : TReal2DMesh;
  MorphLayerAbove, MorphLayerBelow, MeshAbove : TReal2DMesh;
  NodeStart, NodeEnd : integer;
  temp : double;
  Fractions: TDoubleDynArray;
  SutraLayer: integer;
begin
  NodeStart := 0;
  NodeEnd := -1;
  NodeList.Capacity := FVirtualMeshCount * FNodesPerLayer;
  MeshAbove := Real2DMeshes[0];
  LayerAbove := nil;
  SutraLayer := 0;
  for OuterIndex := 0 to FDiscretization.Count -1 do
  begin
    if OuterIndex > 0 then
    begin
      MeshAbove := LayerAbove;
    end;
    LayerAbove := Real2DMeshes[OuterIndex];
    if FMorphMesh = nil then
    begin
      MorphLayerAbove := nil;
    end
    else
    begin
      MorphLayerAbove := FMorphMesh.Real2DMeshes[OuterIndex];
    end;
    if OuterIndex < FDiscretization.Count -1 then
    begin
      LayerBelow := Real2DMeshes[OuterIndex+1];
      if FMorphMesh = nil then
      begin
        MorphLayerBelow := nil;
      end
      else
      begin
        MorphLayerBelow := FMorphMesh.Real2DMeshes[OuterIndex+1];
      end;
    end
    else
    begin
      LayerBelow := nil;
      MorphLayerBelow := nil;
    end;
    InnerLimit := FDiscretization[OuterIndex];
    assert(InnerLimit > 0);

    GetDiscretizationFractions(InnerLimit, FGrowthRates[OuterIndex],
      FGrowthTypes[OuterIndex], Fractions);

    for InnerIndex := 0 to InnerLimit-1 do
    begin
      Inc(SutraLayer);

      if InnerIndex = 1 then
      begin
        MeshAbove := LayerAbove;
      end;
      for NodeIndex := 0 to FNodesPerLayer -1 do
      begin
        Node := TVirtualNode.Create(NodeList.Count, self);
        Node.FLayer := SutraLayer;
        NodeList.Add(Node);
        Inc(NodeEnd);
        Node.NodeAbove :=  LayerAbove.Nodes[NodeIndex];
        Node.MeshAbove := MeshAbove;
        if LayerBelow = nil then
        begin
          Node.NodeBelow := nil;
          Node.UnMorphedFractionAbove := 1;
          Node.FZ := Node.NodeAbove.Z;
        end
        else
        begin
          Node.NodeBelow := LayerBelow.Nodes[NodeIndex];
//          Node.UnMorphedFractionAbove := (InnerLimit-InnerIndex)/InnerLimit;
          Node.UnMorphedFractionAbove := 1-Fractions[InnerIndex];
          Node.FZ := Node.UnMorphedFractionAbove*Node.NodeAbove.Z
            + (1-Node.UnMorphedFractionAbove)*Node.NodeBelow.Z;
        end;
        if FMorphMesh = nil then
        begin
          Node.MorphedFractionAbove := Node.UnMorphedFractionAbove;
          GetNodeMorphedCoord(MorphLayerAbove, MorphLayerBelow, Node);
        end
        else
        begin
          GetNodeMorphedCoord(MorphLayerAbove, MorphLayerBelow, Node);
        end;
      end;
    end;
    if FMorphMesh <> nil then
    begin
      GetNodeMorphedFraction(ModelHandle, MorphLayerAbove, MorphLayerBelow,
        NodeStart, NodeEnd);
    end;
    NodeStart := NodeEnd+1;
  end;

  Assert((FDiscretization.Count >= 2) and (NodeList.Count >= FNodesPerLayer));

  Node := NodeList[0];
  MaxX := Node.X;
  MinX := Node.X;
  MaxY := Node.Y;
  MinY := Node.Y;
  MaxZ := Node.Z;
  MinZ := Node.Z;
  for NodeIndex := 1 to NodeList.Count -1 do
  begin
    Node := NodeList[NodeIndex];
    temp := Node.X;
    if temp < MinX then
    begin
      MinX := temp
    end
    else if temp > MaxX then
    begin
      MaxX := temp;
    end;
    temp := Node.Y;
    if temp < MinY then
    begin
      MinY := temp
    end
    else if temp > MaxY then
    begin
      MaxY := temp;
    end;
    temp := Node.Z;
    if temp < MinZ then
    begin
      MinZ := temp
    end
    else if temp > MaxZ then
    begin
      MaxZ := temp;
    end;
  end;
end;

procedure TVirtual3DMesh.GetNodeMorphedCoord(LayerAbove, LayerBelow : TReal2DMesh;
  ANode : TVirtualNode) ;
Var
  TestTriangle, TriangleAbove, TriangleBelow : TTriangle;
  Vertex1, Vertex2, Vertex3, TestVertex : TVertex;
  Vertex1Above, Vertex2Above, Vertex3Above : TVertex;
  Vertex1Below, Vertex2Below, Vertex3Below : TVertex;
  MorphVertex : TVertex;
  ElementIndex : integer;
  ElementAbove, ElementBelow : TRealElement;
  Node1Above, Node2Above, Node3Above :TRealNode;
  Node1Below, Node2Below, Node3Below :TRealNode;
  NodeTriangleFound : boolean;
begin
  if (LayerAbove = nil) and (LayerBelow = nil) then
  begin
    ANode.AboveEvalLocation.X := ANode.X;
    ANode.AboveEvalLocation.Y := ANode.Y;
    ANode.BelowEvalLocation.X := ANode.X;
    ANode.BelowEvalLocation.Y := ANode.Y;
  end
  else
  begin
    NodeTriangleFound := False;
    if LayerBelow = nil then
    begin
      ANode.AboveEvalLocation.X := ANode.X;
      ANode.AboveEvalLocation.Y := ANode.Y;
      ANode.BelowEvalLocation.X := ANode.X;
      ANode.BelowEvalLocation.Y := ANode.Y;
      NodeTriangleFound := True;
    end
    else
    begin
      for ElementIndex := 0 to LayerAbove.FElements.Count -1 do
      begin
        ElementAbove := LayerAbove.Elements[ElementIndex];
        ElementBelow := LayerBelow.Elements[ElementIndex];
        Assert(ElementAbove.FNodes.Count = 3);
        Assert(ElementBelow.FNodes.Count = 3);
        Node1Above := ElementAbove.Nodes[0];
        Node2Above := ElementAbove.Nodes[1];
        Node3Above := ElementAbove.Nodes[2];
        Node1Below := ElementBelow.Nodes[0];
        Node2Below := ElementBelow.Nodes[1];
        Node3Below := ElementBelow.Nodes[2];
        if (Node1Above.Z = Node1Below.Z)
          or (Node2Above.Z = Node2Below.Z)
          or (Node3Above.Z = Node3Below.Z) then
        begin
          raise EInvalidMesh.Create('Unable to determine evaluation location of '
            + 'virtual node because two corresponding morph nodes have the same '
            + 'elevation.');
        end;
        Vertex1 := TVertex.Create;
        Vertex2 := TVertex.Create;
        Vertex3 := TVertex.Create;
        try
          Vertex1.X := Node1Above.X + (Node1Below.X - Node1Above.X)
            *(ANode.Z - Node1Above.Z)/(Node1Below.Z - Node1Above.Z);
          Vertex1.Y := Node1Above.Y + (Node1Below.Y - Node1Above.Y)
            *(ANode.Z - Node1Above.Z)/(Node1Below.Z - Node1Above.Z);
          Vertex2.X := Node2Above.X + (Node2Below.X - Node2Above.X)
            *(ANode.Z - Node2Above.Z)/(Node2Below.Z - Node2Above.Z);
          Vertex2.Y := Node2Above.Y + (Node2Below.Y - Node2Above.Y)
            *(ANode.Z - Node2Above.Z)/(Node2Below.Z - Node2Above.Z);
          Vertex3.X := Node3Above.X + (Node3Below.X - Node3Above.X)
            *(ANode.Z - Node3Above.Z)/(Node3Below.Z - Node3Above.Z);
          Vertex3.Y := Node3Above.Y + (Node3Below.Y - Node3Above.Y)
            *(ANode.Z - Node3Above.Z)/(Node3Below.Z - Node3Above.Z);
          TestTriangle := TTriangle.Create(Vertex1,Vertex2,Vertex3);
          TestVertex := TVertex.Create;
          try
            TestVertex.X := ANode.X;
            TestVertex.Y := ANode.Y;
            if TestTriangle.PointInside(TestVertex) then
            begin
              NodeTriangleFound := True;

              Vertex1Above := TVertex.Create;
              Vertex2Above := TVertex.Create;
              Vertex3Above := TVertex.Create;
              try
                Vertex1Above.X := Node1Above.X;
                Vertex1Above.Y := Node1Above.Y;
                Vertex2Above.X := Node2Above.X;
                Vertex2Above.Y := Node2Above.Y;
                Vertex3Above.X := Node3Above.X;
                Vertex3Above.Y := Node3Above.Y;
                TriangleAbove := TTriangle.Create(Vertex1Above,Vertex2Above,Vertex3Above);
                try
                  MorphVertex := TVertex.Create;
                  try
                    MorphVertex.X := ANode.X;
                    MorphVertex.Y := ANode.Y;
                    TestTriangle.Morph(TriangleAbove,MorphVertex);
                    ANode.AboveEvalLocation.X := MorphVertex.X;
                    ANode.AboveEvalLocation.Y := MorphVertex.Y;
                  finally
                    MorphVertex.Free;
                  end;
                finally
                  TriangleAbove.Free;
                end;
              finally
                Vertex1Above.Free;
                Vertex2Above.Free;
                Vertex3Above.Free;
              end;

              Vertex1Below := TVertex.Create;
              Vertex2Below := TVertex.Create;
              Vertex3Below := TVertex.Create;
              try
                Vertex1Below.X := Node1Below.X;
                Vertex1Below.Y := Node1Below.Y;
                Vertex2Below.X := Node2Below.X;
                Vertex2Below.Y := Node2Below.Y;
                Vertex3Below.X := Node3Below.X;
                Vertex3Below.Y := Node3Below.Y;
                TriangleBelow := TTriangle.Create(Vertex1Below,Vertex2Below,Vertex3Below);
                try
                  MorphVertex := TVertex.Create;
                  try
                    MorphVertex.X := ANode.X;
                    MorphVertex.Y := ANode.Y;
                    TestTriangle.Morph(TriangleBelow,MorphVertex);
                    ANode.BelowEvalLocation.X := MorphVertex.X;
                    ANode.BelowEvalLocation.Y := MorphVertex.Y;
                  finally
                    MorphVertex.Free;
                  end;
                finally
                  TriangleBelow.Free;
                end;
              finally
                Vertex1Below.Free;
                Vertex2Below.Free;
                Vertex3Below.Free;
              end;

              break;
            end;
          finally
            TestTriangle.Free;
            TestVertex.Free;
          end;

        finally
          Vertex1.Free;
          Vertex2.Free;
          Vertex3.Free;
        end;
      end;
    end;
    if not NodeTriangleFound then
    begin
      Raise EInvalidMesh.Create('One or more virtual nodes are outside the limits'
        + ' defined by the morph mesh');
    end;
  end;
end;

procedure TVirtual3DMesh.GetElementMorphedCoord(LayerAbove, LayerBelow : TReal2DMesh;
  AnElement : TVirtualElement) ;
Var
  TestTriangle, TriangleAbove, TriangleBelow : TTriangle;
  Vertex1, Vertex2, Vertex3, TestVertex : TVertex;
  Vertex1Above, Vertex2Above, Vertex3Above : TVertex;
  Vertex1Below, Vertex2Below, Vertex3Below : TVertex;
  MorphVertex : TVertex;
  ElementIndex : integer;
  ElementAbove, ElementBelow : TRealElement;
  Node1Above, Node2Above, Node3Above :TRealNode;
  Node1Below, Node2Below, Node3Below :TRealNode;
  ElementTriangleFound : boolean;
begin
  if (LayerAbove = nil) and (LayerBelow = nil) then
  begin
    AnElement.AboveEvalLocation.X := AnElement.FX;
    AnElement.AboveEvalLocation.Y := AnElement.FY;
    AnElement.BelowEvalLocation.X := AnElement.FX;
    AnElement.BelowEvalLocation.Y := AnElement.FY;
  end
  else
  begin
    ElementTriangleFound := False;
    for ElementIndex := 0 to LayerAbove.FElements.Count -1 do
    begin
      ElementAbove := LayerAbove.Elements[ElementIndex];
      ElementBelow := LayerBelow.Elements[ElementIndex];
      Assert(ElementAbove.FNodes.Count = 3);
      Assert(ElementBelow.FNodes.Count = 3);
      Node1Above := ElementAbove.Nodes[0];
      Node2Above := ElementAbove.Nodes[1];
      Node3Above := ElementAbove.Nodes[2];
      Node1Below := ElementBelow.Nodes[0];
      Node2Below := ElementBelow.Nodes[1];
      Node3Below := ElementBelow.Nodes[2];
      if (Node1Above.Z = Node1Below.Z)
        or (Node2Above.Z = Node2Below.Z)
        or (Node3Above.Z = Node3Below.Z) then
      begin
        raise EInvalidMesh.Create('Unable to determine evaluation location of '
          + 'virtual node because two corresponding morph nodes have the same '
          + 'elevation.');
      end;
      Vertex1 := TVertex.Create;
      Vertex2 := TVertex.Create;
      Vertex3 := TVertex.Create;
      try
        Vertex1.X := Node1Above.X + (Node1Below.X - Node1Above.X)
          *(AnElement.FZ - Node1Above.Z)/(Node1Below.Z - Node1Above.Z);
        Vertex1.Y := Node1Above.Y + (Node1Below.Y - Node1Above.Y)
          *(AnElement.FZ - Node1Above.Z)/(Node1Below.Z - Node1Above.Z);
        Vertex2.X := Node2Above.X + (Node2Below.X - Node2Above.X)
          *(AnElement.FZ - Node2Above.Z)/(Node2Below.Z - Node2Above.Z);
        Vertex2.Y := Node2Above.Y + (Node2Below.Y - Node2Above.Y)
          *(AnElement.FZ - Node2Above.Z)/(Node2Below.Z - Node2Above.Z);
        Vertex3.X := Node3Above.X + (Node3Below.X - Node3Above.X)
          *(AnElement.FZ - Node3Above.Z)/(Node3Below.Z - Node3Above.Z);
        Vertex3.Y := Node3Above.Y + (Node3Below.Y - Node3Above.Y)
          *(AnElement.FZ - Node3Above.Z)/(Node3Below.Z - Node3Above.Z);
        TestTriangle := TTriangle.Create(Vertex1,Vertex2,Vertex3);
        TestVertex := TVertex.Create;
        try
          TestVertex.X := AnElement.FX;
          TestVertex.Y := AnElement.FY;
          if TestTriangle.PointInside(TestVertex) then
          begin
            ElementTriangleFound := True;

            Vertex1Above := TVertex.Create;
            Vertex2Above := TVertex.Create;
            Vertex3Above := TVertex.Create;
            try
              Vertex1Above.X := Node1Above.X;
              Vertex1Above.Y := Node1Above.Y;
              Vertex2Above.X := Node2Above.X;
              Vertex2Above.Y := Node2Above.Y;
              Vertex3Above.X := Node3Above.X;
              Vertex3Above.Y := Node3Above.Y;
              TriangleAbove := TTriangle.Create(Vertex1Above,Vertex2Above,Vertex3Above);
              try
                MorphVertex := TVertex.Create;
                try
                  MorphVertex.X := AnElement.FX;
                  MorphVertex.Y := AnElement.FY;
                  TestTriangle.Morph(TriangleAbove,MorphVertex);
                  AnElement.AboveEvalLocation.X := MorphVertex.X;
                  AnElement.AboveEvalLocation.Y := MorphVertex.Y;
                finally
                  MorphVertex.Free;
                end;
              finally
                TriangleAbove.Free;
              end;
            finally
              Vertex1Above.Free;
              Vertex2Above.Free;
              Vertex3Above.Free;
            end;

            Vertex1Below := TVertex.Create;
            Vertex2Below := TVertex.Create;
            Vertex3Below := TVertex.Create;
            try
              Vertex1Below.X := Node1Below.X;
              Vertex1Below.Y := Node1Below.Y;
              Vertex2Below.X := Node2Below.X;
              Vertex2Below.Y := Node2Below.Y;
              Vertex3Below.X := Node3Below.X;
              Vertex3Below.Y := Node3Below.Y;
              TriangleBelow := TTriangle.Create(Vertex1Below,Vertex2Below,Vertex3Below);
              try
                MorphVertex := TVertex.Create;
                try
                  MorphVertex.X := AnElement.FX;
                  MorphVertex.Y := AnElement.FY;
                  TestTriangle.Morph(TriangleBelow,MorphVertex);
                  AnElement.BelowEvalLocation.X := MorphVertex.X;
                  AnElement.BelowEvalLocation.Y := MorphVertex.Y;
                finally
                  MorphVertex.Free;
                end;
              finally
                TriangleBelow.Free;
              end;
            finally
              Vertex1Below.Free;
              Vertex2Below.Free;
              Vertex3Below.Free;
            end;

            break;
          end;
        finally
          TestTriangle.Free;
          TestVertex.Free;
        end;

      finally
        Vertex1.Free;
        Vertex2.Free;
        Vertex3.Free;
      end;
    end;
    if not ElementTriangleFound then
    begin
      Raise EInvalidMesh.Create('One or more virtual element centers are '
        + 'outside the limits defined by the morph mesh');
    end;
  end;
end;

function TVirtual3DMesh.VirtualNodeIndex(VirtualLayer,
  IndexOnLayer: integer): integer;
begin
  result := VirtualLayer*FNodesPerLayer + IndexOnLayer;
end;

function TVirtual3DMesh.VirtualElementIndex(VirtualLayer,
  IndexOnLayer: integer): integer;
begin
  result := VirtualLayer*FElementsPerLayer + IndexOnLayer;
end;

procedure TVirtual3DMesh.GetNodeMorphedFraction(ModelHandle : ANE_PTR; LayerAbove,
  LayerBelow: TReal2dMesh;  NodeStart, NodeEnd : Integer);
var
  NodeIndex : integer;
  ANode : TVirtualNode;
  LayerAboveOptions, LayerBelowOptions : TLayerOptions;
  ZAbove, ZBelow : ANE_DOUBLE;
begin
  if LayerBelow = nil then
  begin
    for NodeIndex := NodeStart to NodeEnd do
    begin
      ANode := VirtualNodes[NodeIndex];
      ANode.MorphedFractionAbove := 1;
    end;
  end
  else
  begin
    LayerAboveOptions := TLayerOptions.Create(
      LayerAbove.FLayerHandle);
    LayerBelowOptions := TLayerOptions.Create(
      LayerBelow.FLayerHandle);
    try
      if NodeEnd >= NodeStart then
      begin
        ANode := VirtualNodes[NodeStart];
        ZAbove := LayerAboveOptions.RealValueAtXY(ModelHandle, ANode.AboveEvalLocation.X,
          ANode.AboveEvalLocation.Y, TSutraMorphElevation.WriteParamName);
        ZBelow := LayerBelowOptions.RealValueAtXY(ModelHandle, ANode.BelowEvalLocation.X,
          ANode.BelowEvalLocation.Y, TSutraMorphElevation.WriteParamName);
        if ZAbove = ZBelow then
        begin
          raise EInvalidMesh.Create('Invalid mesh: Check that mesh elevations '
            + 'have been set correctly.');
        end;
        ANode.MorphedFractionAbove := 1-(ZAbove - ANode.Z)/(ZAbove - ZBelow);
      end;
      for NodeIndex := NodeStart+1 to NodeEnd do
      begin
        ANode := VirtualNodes[NodeIndex];
        ZAbove := LayerAboveOptions.RealValueAtXY(ModelHandle, ANode.AboveEvalLocation.X,
          ANode.AboveEvalLocation.Y);
        ZBelow := LayerBelowOptions.RealValueAtXY(ModelHandle, ANode.BelowEvalLocation.X,
          ANode.BelowEvalLocation.Y);
        if ZAbove = ZBelow then
        begin
          raise EInvalidMesh.Create('Invalid mesh: Check that mesh elevations '
            + 'have been set correctly.');
        end;
        ANode.MorphedFractionAbove := 1-(ZAbove - ANode.Z)/(ZAbove - ZBelow);
      end;
    finally
      LayerAboveOptions.Free(ModelHandle);
      LayerBelowOptions.Free(ModelHandle);
    end;
  end;
end;

function TVirtual3DMesh.GetLayerHandle(ModelHandle : ANE_PTR; LayerIndex: integer): ANE_PTR;
var
  LayerName : string;
  N : String;
  MultipleUnits : Boolean;
begin
  N := frmSutra.GetN(MultipleUnits);
  LayerName := TSutraMeshLayer.WriteNewRoot;
  if (N = '0') then
  begin
    if LayerIndex = 1 then
    begin
      LayerName := LayerName + KTop;
    end
    else
    begin
      LayerName := LayerName + KBottom + IntToStr(LayerIndex-1);
    end;

  end;
  result := UtilityFunctions.GetLayerHandle(ModelHandle, LayerName);
end;

procedure TVirtual3DMesh.ParseExpression(ModelHandle: ANE_PTR; Expression: string;
  NumberType : TPIENumberType);
var
  Index : integer;
  AMesh : TReal2DMesh;
  LayerIndex : String;
begin
  LayerIndex := '';
  for Index := 0 to FRealMeshList.Count -1 do
  begin
    AMesh := FRealMeshList[Index];
    if frmSutra.VerticallyAlignedMesh then
    begin
      LayerIndex := IntToStr(Index+1);
    end;
    AMesh.ParseExpression(ModelHandle, Expression+LayerIndex,NumberType);
  end;
end;

procedure TVirtual3DMesh.FreeParsedExpression(ModelHandle : ANE_PTR);
var
  Index : integer;
  AMesh : TReal2DMesh;
begin
  for Index := 0 to FRealMeshList.Count -1 do
  begin
    AMesh := FRealMeshList[Index];
    AMesh.FreeParsedExpression(ModelHandle);
  end;
end;

function TVirtual3DMesh.GetMorphedNodeValue(ModelHandle: ANE_PTR; NodeNumber: integer; Expression : string): ANE_DOUBLE;
var
  ANode: TVirtualNode;
begin
  ANode := VirtualNodes[NodeNumberToNodeIndex(NodeNumber)];
  CurrentVertex  := ANode;
  result := ANode.MorphedRealParameterValue(ModelHandle,Expression);
end;

function TVirtual3DMesh.GetMorphedElementValue(ModelHandle: ANE_PTR; ElementIndex: integer;
  Expression : string): ANE_DOUBLE;
var
  AnElement: TVirtualElement;
begin
  AnElement := VirtualElements[ElementIndex];
  CurrentElement := AnElement;
  result := AnElement.MorphedRealParameterValue(ModelHandle, Expression);
end;

function TVirtual3DMesh.GetMorphedElementAngleValue(ModelHandle: ANE_PTR; ElementIndex: integer;
  Expression : string): ANE_DOUBLE;
var
  AnElement: TVirtualElement;
begin
  AnElement := VirtualElements[ElementIndex];
  CurrentElement := AnElement;
  result := AnElement.MorphedAngleParameterValue(ModelHandle, Expression);
end;

procedure TVirtual3DMesh.GetElementMorphedFraction(ModelHandle : ANE_PTR;
  LayerAbove, LayerBelow: TReal2dMesh; ElementStart, ElementEnd, LayerIndex: Integer);
var
  ElementIndex : integer;
  AnElement : TVirtualElement;
  LayerAboveOptions, LayerBelowOptions : TLayerOptions;
  ZAbove, ZBelow : ANE_DOUBLE;
  parameterRoot, parameterName : string;

  N: string;
  MultipleUnits : boolean;
  ParamIndex : string;
begin
  LayerAboveOptions := TLayerOptions.Create(
    LayerAbove.FLayerHandle);
  LayerBelowOptions := TLayerOptions.Create(
    LayerBelow.FLayerHandle);
  try
    if ElementEnd >= ElementStart then
    begin

      N := frmSutra.GetN(MultipleUnits);
      parameterRoot := TSutraMorphElevation.WriteParamName;
      parameterName := parameterRoot;
      AnElement := VirtualElements[ElementStart];
      CurrentElement := AnElement;

      if (N <> '0') and MultipleUnits then
      begin
        ParamIndex :=  IntToStr(LayerIndex);
        parameterName := parameterRoot + ParamIndex;
      end;

      ZAbove := LayerAboveOptions.RealValueAtXY(ModelHandle, AnElement.FX,
        AnElement.FY, parameterName);

      if (N <> '0') and MultipleUnits then
      begin
        if StrToInt(ParamIndex) <> StrToInt(N)+1 then
        begin
          ParamIndex :=  IntToStr(LayerIndex+1);
          parameterName := parameterRoot + ParamIndex;
        end;
      end;

      ZBelow := LayerBelowOptions.RealValueAtXY(ModelHandle, AnElement.FX,
        AnElement.FY, parameterName);
      if ZAbove = ZBelow then
      begin
        raise EInvalidMesh.Create('Invalid mesh: Check that mesh elevations '
          + 'have been set correctly.');
      end;
      AnElement.MorphedFractionAbove := 1-(ZAbove - AnElement.FZ)/(ZAbove - ZBelow);
    end;
    for ElementIndex := ElementStart+1 to ElementEnd do
    begin
      AnElement := VirtualElements[ElementIndex];
      CurrentElement := AnElement;
      ZAbove := LayerAboveOptions.RealValueAtXY(ModelHandle, AnElement.FX,
        AnElement.FY);
      ZBelow := LayerBelowOptions.RealValueAtXY(ModelHandle, AnElement.FX,
        AnElement.FY);
      if ZAbove = ZBelow then
      begin
        raise EInvalidMesh.Create('Invalid mesh: Check that mesh elevations '
          + 'have been set correctly.');
      end;
      AnElement.MorphedFractionAbove := 1-(ZAbove - AnElement.FZ)/(ZAbove - ZBelow);
    end;
  finally
    LayerAboveOptions.Free(ModelHandle);
    LayerBelowOptions.Free(ModelHandle);
  end;
end;

constructor TVirtualNode.Create(Position : integer;
   const VMesh : TVirtual3DMesh);
begin
  inherited Create;
  Used := False;
  ElementList := TList.Create;
  ElementList.Capacity := 8;
  FPolyHedron := nil;
  NodeIndex := Position;
  Mesh := VMesh;
end;

procedure TVirtualNode.PartiallyCreatePolyhedron(NodeIndex : integer;
  var LastFace, LastVertex : integer);
var
//  LastFace, LastVertex : integer;
  AnElement : TVirtualElement;
  Index : integer;
//  FaceCount, VertexCount : integer;
//  AllocatedMemory : integer;
begin
//  AllocatedMemory := GetHeapStatus.TotalAddrSpace;
  FPolyHedron.Free;
  FPolyHedron := nil;
  FPolyHedron := TPolyhedron.Create(ElementList.Count*8,ElementList.Count*12);
  if FPolyHedron.OctTree = nil then
  begin
    FPolyHedron.OctTree := TRbwOctTree.Create(nil);
  end;
  FPolyHedron.OctTree.MaxPoints := 5;
  if Length(VI_array) < ElementList.Count*8 then
  begin
    setLength(VI_array,ElementList.Count*8);
    for Index := 0 to ElementList.Count*8 -1 do
    begin
      VI_array[Index] := Index;
    end;
  end;

  FPolyHedron.OctTree.XMax := X;
  FPolyHedron.OctTree.XMin := X;
  FPolyHedron.OctTree.YMax := Y;
  FPolyHedron.OctTree.YMin := Y;
  FPolyHedron.OctTree.ZMax := Z;
  FPolyHedron.OctTree.ZMin := Z;

  LastFace := -1;
  LastVertex := -1;
  for Index := 0 to ElementList.Count -1 do
  begin
    AnElement := ElementList[Index];
    AnElement.AddFaces(self, FPolyHedron,LastVertex,LastFace);
  end;
  Assert(LastVertex<ElementList.Count*8);
  Assert(LastFace<ElementList.Count*12);
  FPolyHedron.SetArrayLengths(LastFace,LastVertex);
{  FPolyHedron.EliminateInternalFaces(LastFace, LastVertex);

  FaceCount := FPolyHedron.FaceCount;
  VertexCount := FPolyHedron.VertexCount;
  Assert((VertexCount = 8)
    or (VertexCount = 12)
    or (VertexCount = 18)
    or (VertexCount = 26));
  Assert((FaceCount = 12)
    or (FaceCount = 20)
    or (FaceCount = 32)
    or (FaceCount = 48));  }
//  AllocatedMemory := GetHeapStatus.TotalAddrSpace - AllocatedMemory;
//  ShowMessage(IntToStr(AllocatedMemory));
end;


procedure TVirtualNode.CreatePolyhedron(NodeIndex : integer);
var
  LastFace, LastVertex : integer;
  FaceCount, VertexCount : integer;
begin
  PartiallyCreatePolyhedron(NodeIndex, LastFace, LastVertex);
  FPolyHedron.EliminateInternalFaces(LastFace, LastVertex);

  FaceCount := FPolyHedron.FaceCount;
  VertexCount := FPolyHedron.VertexCount;
//{$IFNDEF Irreg3D_Meshes}
//  Assert((VertexCount = 8)
//    or (VertexCount = 12)
//    or (VertexCount = 18)
//    or (VertexCount = 26));
//  Assert((FaceCount = 12)
//    or (FaceCount = 20)
//    or (FaceCount = 32)
//    or (FaceCount = 48));
//{$ENDIF}    
end;

destructor TVirtualNode.Destroy;
begin
  ElementList.Free;
  FPolyHedron.Free;
  inherited;
end;

procedure TVirtualNode.FreePolyHedron;
begin
  if PolyhedronChoice = poMemory then Exit;
  FPolyHedron.FreeArrays;
  FPolyHedron.OctTree.Free;
  FPolyHedron.OctTree := nil;
end;

function TVirtualNode.LocationString: string;
var
  LocalX, LocalY, LocalZ : String;
begin
  try
    LocalX := FloatToStr(X);
  except
    LocalX := '?';
  end;
  try
    LocalY := FloatToStr(Y);
  except
    LocalY := '?';
  end;
  try
    LocalZ := FloatToStr(Z);
  except
    LocalZ := '?';
  end;
  result := '(X,Y,Z) = (' + LocalX + ', ' + LocalY + ', ' + LocalZ + ').';
  if Pos('?', result)> 0 then
  begin
    result := result + ' (A "?" indicates a coordinate could not be calculated.)';
  end

end;

function TVirtualNode.MorphedRealParameterValue(ModelHandle : ANE_PTR;
  Expression: string): ANE_DOUBLE;
begin
  if MeshAbove <> nil then
  begin
    result := MeshAbove.RealValue(ModelHandle, AboveEvalLocation.X,
      AboveEvalLocation.Y,Expression);
  end
  else
  begin
    if (NodeBelow = nil) or UseConstantValue or (MorphedFractionAbove = 1) then
    begin
  //    Assert(MorphedFractionAbove = 1);
      result := NodeAbove.FMesh.RealValue(ModelHandle, AboveEvalLocation.X,
        AboveEvalLocation.Y,Expression);
{      if NodeBelow <> nil then
      begin
        result := NodeBelow.FMesh.RealValue(ModelHandle, BelowEvalLocation.X,
          BelowEvalLocation.Y,Expression);
      end
      else
      begin
        result := NodeAbove.FMesh.RealValue(ModelHandle, AboveEvalLocation.X,
          AboveEvalLocation.Y,Expression);
      end; }

    end
    else
    begin
      result := NodeAbove.FMesh.RealValue(ModelHandle, AboveEvalLocation.X,
        AboveEvalLocation.Y,Expression) * MorphedFractionAbove
        + NodeBelow.FMesh.RealValue(ModelHandle, BelowEvalLocation.X,
        BelowEvalLocation.Y,Expression) * (1-MorphedFractionAbove);
    end;
  end;
end;

function TVirtualNode.ReadPolyhedron: TPolyhedron;
begin
  if PolyhedronChoice = poCompute then
  begin
    CreatePolyhedron(NodeIndex);
    FPolyHedron.ComputeBox;
  end;
  result := FPolyHedron;
end;

procedure TVirtualNode.StorePolyHedron;
begin
  FPolyhedron.Store(NodeIndex);
end;

function TVirtualNode.TopRealNode: TRealNode;
begin
  result := Mesh.Real2DMeshes[0].Nodes[NodeAbove.NodeIndex];
end;

function TVirtualNode.TopRealX: double;
begin
  result := TopRealNode.X;
end;

function TVirtualNode.TopRealY: double;
begin
  result := TopRealNode.Y;
end;

function TVirtualNode.UnMorphedBooleanParameterValue(ModelHandle : ANE_PTR; ParameterIndex : integer): ANE_BOOL;
begin
  result := NodeAbove.BooleanParameterValue(ModelHandle, ParameterIndex);
end;

function TVirtualNode.UnMorphedIntegerParameterValue(ModelHandle : ANE_PTR; ParameterIndex : integer): ANE_INT32;
begin
  result := NodeAbove.IntegerParameterValue(ModelHandle, ParameterIndex);
end;

function TVirtualNode.UnMorphedRealParameterValue(ModelHandle : ANE_PTR; AboveParameterIndex, BelowParameterIndex : integer): ANE_DOUBLE;
begin
  result := NodeAbove.RealParameterValue(ModelHandle, AboveParameterIndex)
    * UnMorphedFractionAbove
    + NodeBelow.RealParameterValue(ModelHandle, BelowParameterIndex)
    * (1-UnMorphedFractionAbove);
end;

function TVirtualNode.UnMorphedStringParameterValue(ModelHandle : ANE_PTR; ParameterIndex : integer): string;
begin
  result := NodeAbove.StringParameterValue(ModelHandle, ParameterIndex);
end;

function TVirtualNode.X: double;
begin
  if UnMorphedFractionAbove = 1 then
  begin
    Assert(NodeAbove <> nil);
    result := NodeAbove.X
  end
  else
  begin
    Assert(NodeAbove <> nil);
    Assert(NodeBelow <> nil);
    result := UnMorphedFractionAbove*NodeAbove.X
      + (1-UnMorphedFractionAbove)*NodeBelow.X;
  end;
end;

function TVirtualNode.Y: double;
begin
  if UnMorphedFractionAbove = 1 then
  begin
    Assert(NodeAbove <> nil);
    result := NodeAbove.Y
  end
  else
  begin
    Assert(NodeAbove <> nil);
    Assert(NodeBelow <> nil);
    result := UnMorphedFractionAbove*NodeAbove.Y
      + (1-UnMorphedFractionAbove)*NodeBelow.Y;
  end;
end;

function TVirtualNode.Z: double;
begin
  Result := FZ;
end;

constructor TVirtualElement.Create(Owner : TVirtual3DMesh);
begin
  inherited Create;
  FOwner := Owner;
  NodeList := TList.Create;
  NodeList.Capacity := 8;
//  PolyHedron := nil;
end;

procedure TVirtualElement.AddFaces(CornerNode : TVirtualNode;
  APolyHedron : TPolyhedron; var LastVertex, LastFace : integer);

var
  AFace : TList;
  Anode : TVirtualNode;
  function GetFaceCenterArray : TPointd;
  var
    Index : integer;
  begin
    result[X] := 0;
    result[Y] := 0;
    result[Z] := 0;
    for Index := 0 to AFace.Count -1 do
    begin
      Anode := AFace[Index];
      result[X] := result[X] + Anode.X;
      result[Y] := result[Y] + Anode.Y;
      result[Z] := result[Z] + Anode.Z;
    end;
    result[X] := result[X]/AFace.Count;
    result[Y] := result[Y]/AFace.Count;
    result[Z] := result[Z]/AFace.Count;
  end;
var
  Node0, Node1, Node2, Node3, Node4, Node5, Node6, Node7 : TVirtualNode;
  FirstNode, SecondNode : TVirtualNode;
  FaceList : TList;
  Index : integer;
  NodeIndex : integer;
  ElementCenter, FaceCenter, EdgeCenter, Corner : TPointd;
  ElementCenterIndex, FaceCenterIndex, EdgeCenterIndex1, EdgeCenterIndex2, CornerIndex : integer;
  temp : double;
  EpsilonX, EpsilonY, EpsilonZ : double;
  MinX, MinY, MinZ, MaxX, MaxY, MaxZ : double;
begin
  ANode := NodeList[0];
  MinX := ANode.X;
  MaxX := MinX;
  MinY := ANode.Y;
  MaxY := MinY;
  MinZ := ANode.Z;
  MaxZ := MinZ;
  for Index := 1 to NodeList.Count -1 do
  begin
    ANode := NodeList[Index];
    temp := ANode.X;
    if temp < MinX then
    begin
      MinX := temp
    end
    else if temp > MaxX then
    begin
      MaxX := temp;
    end;
    temp := ANode.Y;
    if temp < MinY then
    begin
      MinY := temp
    end
    else if temp > MaxY then
    begin
      MaxY := temp;
    end;
    temp := ANode.Z;
    if temp < MinZ then
    begin
      MinZ := temp
    end
    else if temp > MaxZ then
    begin
      MaxZ := temp;
    end;
  end;
  EpsilonX := (MaxX-MinX)/200000000;
  EpsilonY := (MaxY-MinY)/200000000;
  EpsilonZ := (MaxZ-MinZ)/2000000000;

  Assert(CornerNode <> nil);
  Corner[X] := CornerNode.X;
  Corner[Y] := CornerNode.Y;
  Corner[Z] := CornerNode.Z;

  CornerIndex := APolyHedron.VertexIndex(Corner,LastVertex,EpsilonX,EpsilonY,EpsilonZ);
  if CornerIndex = -1 then
  begin
    Inc(LastVertex);
    CornerIndex := LastVertex;
    APolyHedron.Vertices[CornerIndex] := Corner;
    APolyHedron.OctTree.AddPoint(Corner[X], Corner[Y], Corner[Z],
      @VI_array[LastVertex]);
  end;
  // take care of the special case where the corner is at (0,0,0);
{  else if (CornerIndex = LastVertex + 1) then
  begin
//    LastVertex := 0;
    Inc(LastVertex);
    CornerIndex := LastVertex;
    APolyHedron.Vertices[CornerIndex] := Corner;
  end;  }

  ElementCenter[X] := FX;
  ElementCenter[Y] := FY;
  ElementCenter[Z] := FZ;

  ElementCenterIndex := APolyHedron.VertexIndex(ElementCenter,LastVertex,EpsilonX,EpsilonY,EpsilonZ);
  if ElementCenterIndex = -1 then
  begin
    Inc(LastVertex);
    ElementCenterIndex := LastVertex;
    APolyHedron.Vertices[ElementCenterIndex] := ElementCenter;
    APolyHedron.OctTree.AddPoint(ElementCenter[X], ElementCenter[Y], ElementCenter[Z],
      @VI_array[LastVertex]);
  end;
{  else if (ElementCenterIndex = LastVertex + 1) then
  begin
//    LastVertex := 0;
    Inc(LastVertex);
    ElementCenterIndex := LastVertex;
    APolyHedron.Vertices[ElementCenterIndex] := ElementCenter;
  end; }

  Node0 := NodeList[0];
  Node1 := NodeList[1];
  Node2 := NodeList[2];
  Node3 := NodeList[3];
  Node4 := NodeList[4];
  Node5 := NodeList[5];
  Node6 := NodeList[6];
  Node7 := NodeList[7];
  FaceList := TList.Create;
  try
    FaceList.Capacity := 6;
    for Index := 1 to 6 do
    begin
      AFace := TList.Create;
      AFace.Capacity := 4;
      FaceList.Add(AFace);
    end;

    AFace := FaceList[0];
    AFace.Add(Node0);
    AFace.Add(Node1);
    AFace.Add(Node2);
    AFace.Add(Node3);

    AFace := FaceList[1];
    AFace.Add(Node1);
    AFace.Add(Node5);
    AFace.Add(Node6);
    AFace.Add(Node2);

    AFace := FaceList[2];
    AFace.Add(Node0);
    AFace.Add(Node4);
    AFace.Add(Node5);
    AFace.Add(Node1);

    AFace := FaceList[3];
    AFace.Add(Node3);
    AFace.Add(Node7);
    AFace.Add(Node4);
    AFace.Add(Node0);

    AFace := FaceList[4];
    AFace.Add(Node2);
    AFace.Add(Node6);
    AFace.Add(Node7);
    AFace.Add(Node3);

    AFace := FaceList[5];
    AFace.Add(Node7);
    AFace.Add(Node6);
    AFace.Add(Node5);
    AFace.Add(Node4);

    for Index := 0 to FaceList.Count -1 do
    begin
      AFace := FaceList[Index];
      NodeIndex := AFace.IndexOf(CornerNode);
      if NodeIndex > -1 then
      begin
        FaceCenter := GetFaceCenterArray;

        FaceCenterIndex := APolyHedron.VertexIndex(FaceCenter,LastVertex,EpsilonX,EpsilonY,EpsilonZ);
        if FaceCenterIndex = -1 then
        begin
          Inc(LastVertex);
          FaceCenterIndex := LastVertex;
          APolyHedron.Vertices[FaceCenterIndex] := FaceCenter;
          APolyHedron.OctTree.AddPoint(FaceCenter[X], FaceCenter[Y], FaceCenter[Z],
            @VI_array[LastVertex]);
        end;
{        else if (FaceCenterIndex = LastVertex + 1) then
        begin
          Inc(LastVertex);
          FaceCenterIndex := LastVertex;
          APolyHedron.Vertices[FaceCenterIndex] := FaceCenter;
        end;  }

        case NodeIndex of
          0,1,2:
            begin
              FirstNode := AFace[NodeIndex];
              SecondNode := AFace[NodeIndex+1];
              EdgeCenter[X] := (FirstNode.X + SecondNode.X)/2;
              EdgeCenter[Y] := (FirstNode.Y + SecondNode.Y)/2;
              EdgeCenter[Z] := (FirstNode.Z + SecondNode.Z)/2;
            end;
          3:
            begin
              FirstNode := AFace[0];
              SecondNode := AFace[3];
              EdgeCenter[X] := (FirstNode.X + SecondNode.X)/2;
              EdgeCenter[Y] := (FirstNode.Y + SecondNode.Y)/2;
              EdgeCenter[Z] := (FirstNode.Z + SecondNode.Z)/2;
            end;
          else
            begin
              Assert(False);
            end;
        end;

        EdgeCenterIndex1 := APolyHedron.VertexIndex(EdgeCenter,LastVertex,EpsilonX,EpsilonY,EpsilonZ);
        if EdgeCenterIndex1 = -1 then
        begin
          Inc(LastVertex);
          EdgeCenterIndex1 := LastVertex;
          APolyHedron.Vertices[EdgeCenterIndex1] := EdgeCenter;
          APolyHedron.OctTree.AddPoint(EdgeCenter[X], EdgeCenter[Y], EdgeCenter[Z],
            @VI_array[LastVertex]);
        end;
{        else if (EdgeCenterIndex1 = LastVertex + 1) then
        begin
          Inc(LastVertex);
          EdgeCenterIndex1 := LastVertex;
          APolyHedron.Vertices[EdgeCenterIndex1] := EdgeCenter;
        end; }

        Inc(LastFace);
        APolyHedron.FaceValue[LastFace,0] := EdgeCenterIndex1;
        APolyHedron.FaceValue[LastFace,1] := ElementCenterIndex;
        APolyHedron.FaceValue[LastFace,2] := FaceCenterIndex;

        case NodeIndex of
          0:
            begin
              FirstNode := AFace[0];
              SecondNode := AFace[3];
              EdgeCenter[X] := (FirstNode.X + SecondNode.X)/2;
              EdgeCenter[Y] := (FirstNode.Y + SecondNode.Y)/2;
              EdgeCenter[Z] := (FirstNode.Z + SecondNode.Z)/2;
            end;
          1,2,3:
            begin
              FirstNode := AFace[NodeIndex];
              SecondNode := AFace[NodeIndex-1];
              EdgeCenter[X] := (FirstNode.X + SecondNode.X)/2;
              EdgeCenter[Y] := (FirstNode.Y + SecondNode.Y)/2;
              EdgeCenter[Z] := (FirstNode.Z + SecondNode.Z)/2;
            end;
          else
            begin
              Assert(False);
            end;
        end;

        EdgeCenterIndex2 := APolyHedron.VertexIndex(EdgeCenter,LastVertex,EpsilonX,EpsilonY,EpsilonZ);
        if EdgeCenterIndex2 = -1 then
        begin
          Inc(LastVertex);
          EdgeCenterIndex2 := LastVertex;
          APolyHedron.Vertices[EdgeCenterIndex2] := EdgeCenter;
          APolyHedron.OctTree.AddPoint(EdgeCenter[X], EdgeCenter[Y], EdgeCenter[Z],
            @VI_array[LastVertex]);
        end;
{        else if (EdgeCenterIndex2 = LastVertex + 1) then
        begin
          Inc(LastVertex);
          EdgeCenterIndex2 := LastVertex;
          APolyHedron.Vertices[EdgeCenterIndex2] := EdgeCenter;
        end; }

        Inc(LastFace);
        APolyHedron.FaceValue[LastFace,0] := EdgeCenterIndex2;
        APolyHedron.FaceValue[LastFace,1] := FaceCenterIndex;
        APolyHedron.FaceValue[LastFace,2] := ElementCenterIndex;

        Inc(LastFace);
        APolyHedron.FaceValue[LastFace,0] := EdgeCenterIndex2;
        APolyHedron.FaceValue[LastFace,1] := EdgeCenterIndex1;
        APolyHedron.FaceValue[LastFace,2] := FaceCenterIndex;

        Inc(LastFace);
        APolyHedron.FaceValue[LastFace,0] := EdgeCenterIndex1;
        APolyHedron.FaceValue[LastFace,1] := EdgeCenterIndex2;
        APolyHedron.FaceValue[LastFace,2] := CornerIndex;
      end;
    end;
  finally
    for Index := 0 to FaceList.Count -1 do
    begin
      TList(FaceList[Index]).Free;
    end;
    FaceList.Free;
  end;

end;


procedure TVirtualElement.CreatePolyhedron;
var
  Node0, Node1, Node2, Node3, Node4, Node5, Node6, Node7 : TVirtualNode;
  Index : integer;
  AVolume, AnArea : extended;
  PolyHedron : TPolyhedron;
begin
  PolyHedron := TPolyhedron.Create(14, 24);
  try
    for Index := 0 to 7 do
    begin
      Node1 := NodeList[Index];
      PolyHedron.VertexValue[Index,X] := Node1.X;
      PolyHedron.VertexValue[Index,Y] := Node1.Y;
      PolyHedron.VertexValue[Index,Z] := Node1.Z;
    end;

    Node0 := NodeList[0];
    Node1 := NodeList[1];
    Node2 := NodeList[2];
    Node3 := NodeList[3];
    Node4 := NodeList[4];
    Node5 := NodeList[5];
    Node6 := NodeList[6];
    Node7 := NodeList[7];

    PolyHedron.VertexValue[8,X] := (Node0.X + Node1.X + Node2.X + Node3.X)/4;
    PolyHedron.VertexValue[8,Y] := (Node0.Y + Node1.Y + Node2.Y + Node3.Y)/4;
    PolyHedron.VertexValue[8,Z] := (Node0.Z + Node1.Z + Node2.Z + Node3.Z)/4;

    PolyHedron.VertexValue[9,X] := (Node0.X + Node1.X + Node4.X + Node5.X)/4;
    PolyHedron.VertexValue[9,Y] := (Node0.Y + Node1.Y + Node4.Y + Node5.Y)/4;
    PolyHedron.VertexValue[9,Z] := (Node0.Z + Node1.Z + Node4.Z + Node5.Z)/4;

    PolyHedron.VertexValue[10,X] := (Node1.X + Node2.X + Node5.X + Node6.X)/4;
    PolyHedron.VertexValue[10,Y] := (Node1.Y + Node2.Y + Node5.Y + Node6.Y)/4;
    PolyHedron.VertexValue[10,Z] := (Node1.Z + Node2.Z + Node5.Z + Node6.Z)/4;

    PolyHedron.VertexValue[11,X] := (Node4.X + Node5.X + Node6.X + Node7.X)/4;
    PolyHedron.VertexValue[11,Y] := (Node4.Y + Node5.Y + Node6.Y + Node7.Y)/4;
    PolyHedron.VertexValue[11,Z] := (Node4.Z + Node5.Z + Node6.Z + Node7.Z)/4;

    PolyHedron.VertexValue[12,X] := (Node0.X + Node3.X + Node4.X + Node7.X)/4;
    PolyHedron.VertexValue[12,Y] := (Node0.Y + Node3.Y + Node4.Y + Node7.Y)/4;
    PolyHedron.VertexValue[12,Z] := (Node0.Z + Node3.Z + Node4.Z + Node7.Z)/4;

    PolyHedron.VertexValue[13,X] := (Node2.X + Node3.X + Node6.X + Node7.X)/4;
    PolyHedron.VertexValue[13,Y] := (Node2.Y + Node3.Y + Node6.Y + Node7.Y)/4;
    PolyHedron.VertexValue[13,Z] := (Node2.Z + Node3.Z + Node6.Z + Node7.Z)/4;

    PolyHedron.FaceValue[0,0] := 0;
    PolyHedron.FaceValue[0,1] := 8;
    PolyHedron.FaceValue[0,2] := 1;

    PolyHedron.FaceValue[1,0] := 1;
    PolyHedron.FaceValue[1,1] := 8;
    PolyHedron.FaceValue[1,2] := 2;

    PolyHedron.FaceValue[2,0] := 2;
    PolyHedron.FaceValue[2,1] := 8;
    PolyHedron.FaceValue[2,2] := 3;

    PolyHedron.FaceValue[3,0] := 3;
    PolyHedron.FaceValue[3,1] := 8;
    PolyHedron.FaceValue[3,2] := 0;


    PolyHedron.FaceValue[4,0] := 1;
    PolyHedron.FaceValue[4,1] := 9;
    PolyHedron.FaceValue[4,2] := 0;

    PolyHedron.FaceValue[5,0] := 5;
    PolyHedron.FaceValue[5,1] := 9;
    PolyHedron.FaceValue[5,2] := 1;

    PolyHedron.FaceValue[6,0] := 4;
    PolyHedron.FaceValue[6,1] := 9;
    PolyHedron.FaceValue[6,2] := 5;

    PolyHedron.FaceValue[7,0] := 0;
    PolyHedron.FaceValue[7,1] := 9;
    PolyHedron.FaceValue[7,2] := 4;


    PolyHedron.FaceValue[8,0] := 2;
    PolyHedron.FaceValue[8,1] := 10;
    PolyHedron.FaceValue[8,2] := 1;

    PolyHedron.FaceValue[9,0] := 6;
    PolyHedron.FaceValue[9,1] := 10;
    PolyHedron.FaceValue[9,2] := 2;

    PolyHedron.FaceValue[10,0] := 5;
    PolyHedron.FaceValue[10,1] := 10;
    PolyHedron.FaceValue[10,2] := 6;

    PolyHedron.FaceValue[11,0] := 1;
    PolyHedron.FaceValue[11,1] := 10;
    PolyHedron.FaceValue[11,2] := 5;


    PolyHedron.FaceValue[12,0] := 7;
    PolyHedron.FaceValue[12,1] := 11;
    PolyHedron.FaceValue[12,2] := 6;

    PolyHedron.FaceValue[13,0] := 4;
    PolyHedron.FaceValue[13,1] := 11;
    PolyHedron.FaceValue[13,2] := 7;

    PolyHedron.FaceValue[14,0] := 5;
    PolyHedron.FaceValue[14,1] := 11;
    PolyHedron.FaceValue[14,2] := 4;

    PolyHedron.FaceValue[15,0] := 6;
    PolyHedron.FaceValue[15,1] := 11;
    PolyHedron.FaceValue[15,2] := 5;


    PolyHedron.FaceValue[16,0] := 1;
    PolyHedron.FaceValue[16,1] := 12;
    PolyHedron.FaceValue[16,2] := 4;

    PolyHedron.FaceValue[17,0] := 5;
    PolyHedron.FaceValue[17,1] := 12;
    PolyHedron.FaceValue[17,2] := 1;

    PolyHedron.FaceValue[18,0] := 8;
    PolyHedron.FaceValue[18,1] := 12;
    PolyHedron.FaceValue[18,2] := 5;

    PolyHedron.FaceValue[19,0] := 4;
    PolyHedron.FaceValue[19,1] := 12;
    PolyHedron.FaceValue[19,2] := 8;


    PolyHedron.FaceValue[20,0] := 3;
    PolyHedron.FaceValue[20,1] := 13;
    PolyHedron.FaceValue[20,2] := 2;

    PolyHedron.FaceValue[21,0] := 7;
    PolyHedron.FaceValue[21,1] := 13;
    PolyHedron.FaceValue[21,2] := 3;

    PolyHedron.FaceValue[22,0] := 6;
    PolyHedron.FaceValue[22,1] := 13;
    PolyHedron.FaceValue[22,2] := 7;

    PolyHedron.FaceValue[23,0] := 2;
    PolyHedron.FaceValue[23,1] := 13;
    PolyHedron.FaceValue[23,2] := 6;

    PolyHedron.GetProps(AVolume, AnArea);
    Volume := AVolume;
  finally
    PolyHedron.Free;
  end;
end;

destructor TVirtualElement.Destroy;
begin
  NodeList.Free;
//  PolyHedron.Free;
  inherited;
end;

function TVirtualElement.MorphedRealParameterValue(ModelHandle : ANE_PTR;
  Expression: string = ''): ANE_DOUBLE;
begin
  if UseConstantValue then
  begin
    result := ElementAbove.FMesh.RealValue(ModelHandle, AboveEvalLocation.X,
      AboveEvalLocation.Y,Expression);
  end
  else
  begin
    result := ElementAbove.FMesh.RealValue(ModelHandle, AboveEvalLocation.X,
      AboveEvalLocation.Y,Expression) * MorphedFractionAbove
      + ElementBelow.FMesh.RealValue(ModelHandle, BelowEvalLocation.X,
      BelowEvalLocation.Y,Expression) * (1-MorphedFractionAbove);
  end;
end;

function TVirtualElement.MorphedAngleParameterValue(ModelHandle : ANE_PTR;
  Expression: string = ''): ANE_DOUBLE;
{var
  AngleAbove, AngleBelow : double;
  X, Y : Double;   }
begin
{  AngleAbove := ElementAbove.FMesh.RealValue(ModelHandle,AboveEvalLocation.X,
    AboveEvalLocation.Y,Expression)*Pi/180;
  AngleBelow := ElementBelow.FMesh.RealValue(ModelHandle,BelowEvalLocation.X,
    BelowEvalLocation.Y,Expression)*Pi/180;

  X := Cos(AngleAbove) * MorphedFractionAbove + Cos(AngleBelow) * (1-MorphedFractionAbove);
  Y := Sin(AngleAbove) * MorphedFractionAbove + Sin(AngleBelow) * (1-MorphedFractionAbove);

  if X = 0 then
  begin
    if Y > 0 then
    begin
      result := 90;
    end
    else if Y = 0 then
    begin
      result := 0
    end
    else
    begin
      result := -90;
    end;
  end
  else
  begin
    result := ArcTan2(Y, X) * 180/Pi;
  end;  }
  result := ElementAbove.FMesh.RealValue(ModelHandle,AboveEvalLocation.X,
    AboveEvalLocation.Y,Expression);
end;


function TVirtualElement.StringParameterValue(
  ParameterIndexAbove, ParameterIndexBelow : ANE_INT16): string;
begin

end;

function TVirtual3DMesh.RealLayerIndex(
  VirtualLayerIndex: integer): integer;
var
  Index : integer;
  Total : integer;
begin
  Total := 0;
  result := -1;
  for Index := 0 to FDiscretization.Count -1 do
  begin
    Total := Total + FDiscretization[Index];
    if Total > VirtualLayerIndex then
    begin
      result := Index;
      Exit;
    end;
  end;
end;

procedure TVirtual3DMesh.SetEpsilon;
var
  Index : integer;
  Node : TVirtualNode;
begin
  Epsilon := 0;
  for Index := 0 to NodeCount -1 do
  begin
    Node := VirtualNodes[Index];
    if Abs(Node.X) > Epsilon then
    begin
      Epsilon := Abs(Node.X)
    end;
    if Abs(Node.Y) > Epsilon then
    begin
      Epsilon := Abs(Node.Y)
    end;
    if Abs(Node.Z) > Epsilon then
    begin
      Epsilon := Abs(Node.Z)
    end;
  end;
  Epsilon := Epsilon * 2e-11;
  doublePolyhedronUnit.Epsilon := Epsilon;
//  ShowMessage('Epsilon := ' + FloatToStr(Epsilon));
end;

{ T3DMorphMesh }

constructor T3DMorphMesh.Create(ModelHandle: ANE_PTR; NumberOfMeshes : integer);
begin
  inherited Create;
  FRealMeshList := TList.Create;
  MakeRealMeshes(ModelHandle, NumberOfMeshes);
end;

procedure T3DMorphMesh.Free(ModelHandle: ANE_PTR);
begin
  MeshModelHandle := ModelHandle;
  inherited Free;
end;


destructor T3DMorphMesh.Destroy;
var
  Index : integer;
begin
  for Index := 0 to FRealMeshList.Count -1 do
  begin
    TReal2DMesh(FRealMeshList[Index]).Free(MeshModelHandle);
  end;
  FRealMeshList.Free;
  inherited;
end;

{function T3DMorphMesh.GetLayerHandle(ModelHandle : ANE_PTR; LayerIndex: integer): ANE_PTR;
var
  LayerName : string;
begin
  LayerName := TSutraMorphMeshLayer.WriteNewRoot + IntToStr(LayerIndex);
  result := ANE_LayerGetHandleByName(ModelHandle, PChar(LayerName));
end;  }

function T3DMorphMesh.GetRealMesh(Index: integer): TReal2DMesh;
begin
  result := FRealMeshList[Index];
end;

function T3DMorphMesh.GetRealMeshCount: integer;
begin
  result := FRealMeshList.Count;
end;

procedure T3DMorphMesh.MakeRealMeshes(ModelHandle : ANE_PTR;
  NumberOfMeshes : integer);
var
  Index : integer;
  ARealMesh : TReal2DMesh;
  LayerHandle : ANE_PTR;
begin
  FRealMeshList.Capacity := NumberOfMeshes;
  for Index := 1 to NumberOfMeshes  do
  begin
    LayerHandle := GetLayerHandle(ModelHandle, Index );
    ARealMesh := TReal2DMesh.Create(ModelHandle, LayerHandle, Index);
    FRealMeshList.Add(ARealMesh);
    if Index = 1 then
    begin
      FNodesPerLayer := ARealMesh.FNodes.Count;
      FElementsPerLayer := ARealMesh.FElements.Count;
    end
    else
    begin
      if FNodesPerLayer <> ARealMesh.FNodes.Count then
      begin
        raise EInvalidMesh.Create('Invalid mesh, the number of nodes on mesh '
          + 'number ' + IntToStr(Index ) + ' does not equal the number on '
          + 'previous layers.')
      end;
      if FElementsPerLayer <> ARealMesh.FElements.Count then
      begin
        raise EInvalidMesh.Create('Invalid mesh, the number of elements on mesh '
          + 'number ' + IntToStr(Index ) + ' does not equal the number on '
          + 'previous layers.')
      end;
    end;
  end;

end;

{ TPolygon }

constructor TPolygon.Create(Locations: array of TLocation; Size: integer);
var
  Index : integer;
begin
  inherited Create;
  FCount := Size+1;
  SetLength(FLocations, FCount);
  for Index := 0 to Size -1 do
  begin
    FLocations[Index] := Locations[Index];
  end;
  FLocations[Size] := Locations[0];
end;

function TPolygon.GetLocation(Index: integer): TLocation;
begin
  result := FLocations[Index];
end;

function TPolygon.IsLocationInside(Location: TLocation): boolean;
var
  Index : integer;
  FirstLocation, SecondLocation : TLocation;
begin   // based on CACM 112
  result := true;
  For Index := 0 to FCount -2 do
  begin
    FirstLocation := FLocations[Index];
    SecondLocation := FLocations[Index+1];
    if ((Location.Y <= FirstLocation.Y) = (Location.Y > SecondLocation.Y)) and
       (Location.X - FirstLocation.X - (Location.Y - FirstLocation.Y) *
         (SecondLocation.X - FirstLocation.X)/
         (SecondLocation.Y - FirstLocation.Y) < 0) then
      begin
        result := not result;
      end;
  end;
  result := not result;
end;

function TVirtual3DMesh.NodeNumberToNodeIndex(
  NodeNumber: integer): integer;
var
  LayerIndex : integer;
  NodeIndex : integer;
begin
  LayerIndex := NodeNumber mod FVirtualMeshCount;
  NodeIndex := NodeNumber div FVirtualMeshCount;
  result := LayerIndex * FNodesPerLayer + NodeIndex;
end;

function TVirtual3DMesh.ElementIndexToElementNumber(
  ElementIndex: integer): integer;
var
  LayerIndex : integer;
  ElementNumber : integer;
begin
  LayerIndex := ElementIndex div (FVirtualMeshCount-1);
  ElementNumber := ElementIndex mod (FVirtualMeshCount-1);
  result := LayerIndex + ElementNumber * FElementsPerLayer;
end;

function TVirtual3DMesh.NodeIndexToNodeNumber(
  NodeIndex: integer): integer;
var
  LayerIndex : integer;
  NodeNumber : integer;
begin
  LayerIndex := NodeIndex div FNodesPerLayer;
  NodeNumber := NodeIndex mod FNodesPerLayer;
  result := LayerIndex + NodeNumber * FVirtualMeshCount;
end;

function TVirtual3DMesh.ElementCount: integer;
begin
  result := ElementList.Count;
end;

function TVirtual3DMesh.NodeCount: integer;
begin
  result := NodeList.Count;
end;

procedure TVirtual3DMesh.InitializeNodeValue1;
var
  Index : integer;
  ANode : TVirtualNode;
begin
  for Index := 0 to NodeCount-1 do
  begin
    ANode := VirtualNodes[Index];
    ANode.Value1 := 0;
  end;
end;

procedure TVirtual3DMesh.InitializeNodeValues;
var
  Index : integer;
  ANode : TVirtualNode;
begin
  for Index := 0 to NodeCount-1 do
  begin
    ANode := VirtualNodes[Index];
    ANode.Value1 := 0;
    ANode.Value2 := 0;
    ANode.Value3 := 0;
    ANode.Value4 := 0;
    ANode.Value5 := 0;
    {$IFDEF OldSutraIce}
    ANode.Conductance := 0;
    {$ENDIF}
    ANode.Transient := False;
    ANode.Used := False;
    ANode.Comment := '';
  end;
end;

procedure TVirtual3DMesh.InitializeIntNodeValue;
var
  Index : integer;
  ANode : TVirtualNode;
begin
  for Index := 0 to NodeCount-1 do
  begin
    ANode := VirtualNodes[Index];
    ANode.IntValue := 0;
    ANode.Used := False;
  end;
end;

procedure TVirtual3DMesh.InitializeIntElementValue;
var
  Index : integer;
  AnElement : TVirtualElement;
begin
  for Index := 0 to ElementCount-1 do
  begin
    AnElement := VirtualElements[Index];
    AnElement.IntValue := 0;
  end;
end;


{function TVirtual3DMesh.IndexOfNode(ANode: TVirtualNode): integer;
begin
  result := NodeList.IndexOf(ANode);
end;  }

function TVirtual3DMesh.GetDiscretization(Index: integer): integer;
begin
  result := FDiscretization[Index];
end;

function TVirtual3DMesh.BandWidth: integer;
var
  ElementIndex: integer;
  AnElement : TVirtualElement;
  TestValue : integer;
begin
  result := 0;
  for ElementIndex := 0 to ElementCount -1 do
  begin
    AnElement := VirtualElements[ElementIndex];
    TestValue := AnElement.BandWidth;
    if TestValue > result then
    begin
      result := TestValue;
    end;
  end;
  result := result*2+1
end;

procedure TVirtual3DMesh.SortNodesByMinX;
var
  Index : integer;
begin
  FSortedNodeList.Clear;
  for Index := 0 to NodeList.Count -1 do
  begin
    FSortedNodeList.Add(NodeList[Index]);
  end;
  FSortedNodeList.Sort(SortNodesXMin);
end;

function TVirtualElement.BandWidth: integer;
var
  NodeIndex, InnerNodeIndex : integer;
  ANode, AnotherNode : TVirtualNode;
  TestValue : integer;
  Index1, Index2 : integer;
begin
  result := 0;
  for NodeIndex := 0 to NodeList.Count -2 do
  begin
    ANode := NodeList[NodeIndex];
    Index1 := FOwner.NodeIndexToNodeNumber(ANode.NodeIndex);
    for InnerNodeIndex := NodeIndex + 1 to NodeList.Count -1 do
    begin
      AnotherNode := NodeList[InnerNodeIndex];
      Index2 := FOwner.NodeIndexToNodeNumber(AnotherNode.NodeIndex);
      TestValue := (Abs(Index1 - Index2));
      if TestValue > result then
      begin
        result := TestValue;
      end;
    end;
  end;

end;

function TVirtualElement.GetNode(Index: integer): TVirtualNode;
begin
  result := NodeList[Index];
end;

initialization

finalization
  setLength(VI_array, 0);

end.

