unit ReadMeshUnit;

interface

uses SysUtils, Classes, QuadtreeClass, AnePIE, OptionsUnit, PlaneGeom,
  RangeTreeUnit;

type
  TIntegerArray = array of integer;

  {
    @name provides a fast way of determining the point of intersection
    between a line segment and a polyline.
  }
  TBoundarySegment = class(TObject)
  private
    // @Name is a series of points that define a polyline.
    // TBoundarySegment only has a reference to FBoundary;
    // it does not own it.
    FBoundary: TPointArray;
    // @Name is the first point in @Link(FBoundary) that is used
    // by the current @Link(TBoundarySegment).
    FStartIndex: integer;
    // @Name is the last point in @Link(FBoundary) that is used
    // by the current @Link(TBoundarySegment).
    FEndIndex: integer;
    // @Name defines the lower left corner of a rectangle that encompasses
    // the portion of @Link(FBoundary) used
    // by the current @Link(TBoundarySegment).
    FMinPoint: TRealPoint;
    // @Name defines the upper right corner of a rectangle that encompasses
    // the portion of @Link(FBoundary) used
    // by the current @Link(TBoundarySegment).
    FMaxPoint: TRealPoint;
    // @Name are two @Link(TBoundarySegment)s owned by the current
    // @Link(TBoundarySegment) that each deals with half of the portion
    // of @Link(FBoundary) that the current segment of @Link(TBoundarySegment)
    // deals with.
    FSubBoundaries: array[0..1] of TBoundarySegment;
    // @Name computes the points of intersection between a line segment
    // defined by StartPoint, EndPoint and the portion of @Link(FBoundary)
    // treated by the current @Link(TBoundarySegment).
    // Intersection contains the points of intersection.
    // Locations indicates the segment in FBoundary in which the intersections
    // occur.  For example, if the point of intersection was between points 2
    // and 3 in FBoundary, Locations would contain 2.
    // @Name returns true if the line segment intersects the part of
    // @Link(FBoundary) between @Link(FStartIndex) and @Link(FEndIndex).                                                   /
    function Intersect(const StartPoint, EndPoint: TRealPoint;
      out Intersection: TPointArray; out Locations: TIntegerArray): boolean;
  public
    // @name creates a @Link(TBoundarySegment) using Boundary as the polyline.
    // StartIndex and EndIndex indicate the portions of Boundary that will be
    // used by this @Link(TBoundarySegment).
    constructor Create(const Boundary: TPointArray;
      const StartIndex, EndIndex: integer);
    // Destroy destroys a @Link(TBoundarySegment).
    // Do not call Destroy directly. Call Free instead.
    destructor Destroy; override;
  end;

  TNode = class;
  TNodeArray = array of TNode;

  // @name represents a node in a two-dimensional finite element mesh.
  TNode = class(TObject)
  private
    // @Name is the X coordinate of the node.
    FX: ANE_DOUBLE;
    // @Name is the Y coordinate of the node.
    FY: ANE_DOUBLE;
    // @name is a list of elements that use the node.
    FElements: TList;
    // FCellBoundary is an array of points defining the boundary of the cell
    // around the node.  It is created @Link(CreateCellBoundary).
    FCellBoundary: TPointArray;
    //  For each point in @Link(FCellBoundary), the corresponding member of
    //  @name is a list of nodes on the opposite side of that point.
    FCellBoundaryNodeLists: array of TList;
    // @name is used to hold @Link(TElementEdge)s during creation of the
    // mesh boundary.
    Edges: TList;
    // @name holds the minimum and maximum X coordinates of the Nodes cell.
    XRange: TRange;
    // @name holds the minimum and maximum Y coordinates of the Nodes cell.
    YRange: TRange;
    // @name is the node number.
    FNumber: integer;
    // @name is a @Link(TBoundarySegment) used to calculate intersections
    // between contours and the node.
    FBoundary: TBoundarySegment;
    // @name returns a @Link(TRealPoint) with the nodes coordinates.
    function GetPoint: TRealPoint;
    // @name returns a point on the node's cell boundary.
    function GetCellBoundary(const Index: integer): TRealPoint;
    // @name returns a node on the opposite side of each point on the cell
    // boundary.  In some cases, GetCellBoundary returns nil because
    // the point is on the cell boundary and only the node itself is at that
    // point.
    function GetCellBoundaryNodeList(const Index: integer): TList;
    // GetCount returns the number of points in the cell boundary.
    function GetCount: integer;
  public
    // @name is the X coordinate of the node.
    property X: ANE_DOUBLE read FX;
    // @name is the Y coordinate of the node
    property Y: ANE_DOUBLE read FY;
    // @name creates an instance of @Link(TNode).
    constructor Create;
    // @name destroys the current instance of @Link(TNode).  Do not call
    // @name directly.  Call Free instead.
    destructor Destroy; override;
    // @name determines what the cell boundary is and stores it in
    // @Link(FCellBoundary).  It also sets @Link(FCellBoundaryNodes) and
    // creates @Link(FBoundary).
    procedure CreateCellBoundary;
    // PointInsideCell returns True if the point (X,Y) is inside the cell
    // boundary.
    function PointInsideCell(X, Y: ANE_DOUBLE): boolean;
    // @name is the node number.
    property Number: integer read FNumber;
    // @name is a @Link(TRealPoint) with the nodes coordinates.
    property Point: TRealPoint read GetPoint;
    // @Name computes the points of intersection between a line segment
    // defined by StartPoint, EndPoint and the cell boundary.
    // Intersection contains the points of intersection.
    // Locations indicates the segment of the cell boundary in which the
    // intersections occur.  For example, if the point of intersection
    // was between points 2
    // and 3 in the cell boundary, Locations would contain 2.
    // @Name returns true if the line segment intersects the cell boundary.                                                   /
    function Intersect(const StartPoint, EndPoint: TRealPoint;
      out Intersection: TPointArray; out Locations: TIntegerArray): boolean;
    // @name is the number of points in the cell boundary
    property Count: integer read GetCount;
    // @name holds the points on the node's cell boundary.
    property CellBoundary[const Index: integer]: TRealPoint read
    GetCellBoundary;
    // @name holds the nodes on the opposite side of each point on the cell
    // boundary.  In some cases, CellBoundaryNodes will be @nil because
    // the point is on the cell boundary and only the node itself is at that
    // point.
    property CellBoundaryNodeLists[const Index: integer]: TList read
    GetCellBoundaryNodeList;
  end;

  // @name holds a list of @Link(TNode)s.
  TNodeList = class(TObject)
  private
    FList: TList;
    // @name adds Node to the list.
    procedure Add(const Node: TNode);
    // @name returns the number of nodes in the list.
    function GetCount: integer;
    // @name returns the @Link(TNode) in the list
    // at the postion specified by Index.
    function GetNodes(const Index: integer): TNode;
  public
    // @name stores the list of nodes. The node at Index should have
    // a node number of Index.
    property Nodes[const Index: integer]: TNode read GetNodes; default;
    // @name creates an instance of @Link(TNodeList).
    constructor Create;
    // @name destroys the current @Link(TNodeList).  Do not call @name directly.
    // Call Free instead.
    destructor Destroy; override;
    // Count is the number of positions Nodes.  However, some may be nil.
    property Count: integer read GetCount;
    // Clear destroys all the nodes in the list.
    procedure Clear;
  end;

  // @name represents an element in a  two-dimensional finite element mesh.
  TElement = class(TObject)
  private
    // @name hold the @Link(TNode)s that define the element.
    FNodes: TList;
    // @name holds the minimum and maximum X coordinates of the element.
    XRange: TRange;
    // @name holds the minimum and maximum Y coordinates of the element.
    YRange: TRange;
    // GetCount returns the number of nodes in @Link(FNodes).
    function GetCount: integer;
    // GetNodes returns the @Link(TNode) at the position indicated by Index
    // in @Link(FNodes).
    function GetNodes(const Index: integer): TNode;
    // @Name returns the @Link(TNode) after Node in @Link(FNodes).
    // If Node is the last node in @Link(FNodes), @name returns the first node
    // in @Link(FNodes).
    function AfterNode(const Node: TNode): TNode;
    // @Name returns the @Link(TNode) before Node in @Link(FNodes).
    // If Node is the first node in @Link(FNodes), @name returns the last node
    // in @Link(FNodes).
    function BeforeNode(const Node: TNode): TNode;
  public
    // Nodes is the list of Nodes defining the element.
    property Nodes[const Index: integer]: TNode read GetNodes; default;
    // Count is the number of nodes in Nodes.
    property Count: integer read GetCount;
    // @name creates an instance of @Link(TElement).
    constructor Create;
    // @name destroys the current @Link(TElement).  Do not call @name directly.
    // Call Free instead.
    destructor Destroy; override;
    // @name sets X and Y to the position to the center of the element.
    procedure Center(var X, Y: double);
    // PointInsideCell returns True if the point (X,Y) is inside the element.
    function PointInsideElement(X, Y: ANE_DOUBLE): boolean;
  end;

  TMeshBoundary = class(TObject)
  private
    // @name is an array of points defining the mesh boundary.
    FMeshBoundary: TPointArray;
    // @name is an array of @Link(TNode)s defining the boundary.
    FBoundaryNodes: TNodeArray;
    // @name is a @Link(TBoundarySegment) used to calculate the intersection
    // between a line segment and the element.
    FBoundary: TBoundarySegment;
    // @name is the minimum X coordinate in the boundary.
    MinX: double;
    // @name is the maximum X coordinate in the boundary.
    MaxX: double;
    // @name is the minimum Y coordinate in the boundary.
    MinY: double;
    // @name is the maximum Y coordinate in the boundary.
    MaxY: double;
    // @name returns the @Link(TRealPoint) on the mesh boundary indicated by
    // Index.
    function GetMeshBoundary(const Index: integer): TRealPoint;
    // @name returns the @Link(TNode) on the mesh boundary indicated by
    // Index.
    function GetBoundaryNodes(const Index: integer): TNode;
    // @name returns @True if the point (X,Y) is inside the mesh boundary.
    function PointInsideMeshBoundary(X, Y: ANE_DOUBLE): boolean;
    // @name represents the @Link(TRealPoint)s that define the boundary of the
    // finite element mesh.
    property MeshBoundary[const Index: integer] : TRealPoint read GetMeshBoundary;
    // @name represents the @Link(TNode)s that define the boundary of the
    // finite element mesh.
    property BoundaryNodes[const Index: integer]: TNode read GetBoundaryNodes;
    // @Name computes the points of intersection between a line segment
    // defined by StartPoint, EndPoint and the mesh boundary.
    // Intersection contains the points of intersection.
    // Locations indicates the segment of the mesh boundary in which the
    // intersections occur.  For example, if the point of intersection
    // was between points 2
    // and 3 in the mesh boundary, Locations would contain 2.
    // @Name returns true if the line segment intersects the mesh boundary.                                                   /
    function Intersect(const StartPoint, EndPoint: TRealPoint;
      out Intersection: TPointArray; out Locations: TIntegerArray): boolean;
  public
    destructor Destroy; override;
  end;

  // @name holds a list of @Link(TElement)s.
  TElementList = class(TObject)
  private
    // FList is the list of @Link(TElement)s.
    FList: TList;
    // @name is an array of points defining the mesh boundary.
//    FMeshBoundary: TPointArray;
    // @name is an array of @Link(TNode)s defining the boundary.
//    FBoundaryNodes: TNodeArray;
    // @name is the minimum X coordinate in the mesh.
//    MinX: double;
    // @name is the maximum X coordinate in the mesh.
//    MaxX: double;
    // @name is the minimum Y coordinate in the mesh.
//    MinY: double;
    // @name is the maximum Y coordinate in the mesh.
//    MaxY: double;
    // @name is a @Link(TBoundarySegment) used to calculate the intersection
    // between a line segment and the element.
//    FBoundary: TBoundarySegment;
    FBoundaryList: TList;
    // @name adds Element to the list.
    procedure Add(const Element: TElement);
    // @name returns the number of @Link(TElement)s in FList.
    function GetCount: integer;
    // @name returns the @Link(TElement) in the list
    // at the postion specified by Index.
    function GetElements(const Index: integer): TElement;
    // @name returns the @Link(TRealPoint) on the mesh boundary indicated by
    // Index.
    function GetMeshBoundary(Index: integer): TRealPoint;
    // @name returns the @Link(TNode) on the mesh boundary indicated by
    // Index.
    function GetBoundaryNodes(Index: integer): TNode;
  public
    // Nodes stores the list of element. The node at Index should have
    // an element number of Index.
    property Elements[const Index: integer]: TElement read GetElements; default;
    // @name creates an instance of @Link(TElementList).
    constructor Create;
    // @name destroys the current @Link(TElementList).
    // Do not call @name directly.
    // Call Free instead.
    destructor Destroy; override;
    // @name is the number of Elements in the TElementList
    property Count: integer read GetCount;
    // @name destroys all the elements in the list.
    procedure Clear;
    // @name fills @Link(FMeshBoundary) with an @Link(TRealPoint) that define
    // the edge of the mesh.  It also fills @Link(BoundaryNodes) with the nodes
    // at those locations it also creates @Link(FBoundary).
    procedure CreateMeshBoundary;
    // @name returns @True if the point (X,Y) is inside the mesh boundary.
    function PointInsideMeshBoundary(X, Y: ANE_DOUBLE): boolean;
    // @name represents the @Link(TRealPoint)s that define the boundary of the
    // finite element mesh.
    property MeshBoundary[Index: integer] : TRealPoint read GetMeshBoundary;
    // @name represents the @Link(TNode)s that define the boundary of the
    // finite element mesh.
    property BoundaryNodes[Index: integer]: TNode read GetBoundaryNodes;
    // @Name computes the points of intersection between a line segment
    // defined by StartPoint, EndPoint and the mesh boundary.
    // Intersection contains the points of intersection.
    // Locations indicates the segment of the mesh boundary in which the
    // intersections occur.  For example, if the point of intersection
    // was between points 2
    // and 3 in the mesh boundary, Locations would contain 2.
    // @Name returns true if the line segment intersects the mesh boundary.                                                   /
    function Intersect(const StartPoint, EndPoint: TRealPoint;
      out Intersection: TPointArray; out Locations: TIntegerArray): boolean;
  end;

  // @name is used during the creation of the mesh boundary.
  // Each TElementEdge holds two nodes that define the edge of an element.
  TElementEdge = class(TObject)
  private
    // @name holds two nodes that define the edge of an element.
    FList: TList;
  public
    // @name returns true if Edge has the same nodes as the current edge.
    function Same(const Edge: TElementEdge): boolean;
    // @name creates an instance of TElementEdge and stores Node1 and Node2.
    constructor Create(const Node1, Node2: TNode);
    // @name destroys the current @Link(TElementEdge).
    // Do not call @name directly.
    // Call Free instead.
    destructor Destroy; override;
    // If Node is one of the nodes in the @Link(TElementEdge), @name returns
    // the other one.  If Node is not one of the nodes in the
    // @Link(TElementEdge), calling OtherNode results in an assertion failure.
    function OtherNode(const Node: TNode): TNode;
  end;

procedure ReadMesh(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure ClearMesh(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GErrorCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

var
  NodeList: TNodeList;
  ElementList: TElementList;
  NodePositions: TRbwQuadTree;
  ErrorCount: integer = 0;

implementation

uses contnrs, FastGEO, ANECB, ParamArrayUnit, RangeUnit, ReadContoursUnit,
  ContourIntersection;

procedure ReadMesh(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  LayerName: ANE_STR;
  param: PParameter_array;
  LayerHandle: ANE_PTR;
  result: ANE_BOOL;
  MeshLayer: TLayerOptions;
  ElementIndex: ANE_INT32;
  ElementOptions: TElementObjectOptions;
  Element: TElement;
  NodeCount: integer;
  NodeIndex: integer;
  ElementCount: integer;
  X, Y: ANE_DOUBLE;
  XVar, YVar: double;
  Node: TNode;
  Data: Pointer;
  TempNodeList: TList;
  TempElementList: TList;
  RangeArray: TRangeArray;
  NodeObjectOptions: TNodeObjectOptions;
begin
  result := False;
  try
    try
      if numParams < 1 then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      param := @parameters^;
      LayerName := param^[0];
      LayerHandle := ANE_LayerGetHandleByName(funHandle, LayerName);
      if LayerHandle = nil then
      begin
        Exit;
      end;

      MeshLayer := TLayerOptions.Create(LayerHandle);
      try
        NodeCount := MeshLayer.NumObjects(funHandle, pieNodeObject);
        for NodeIndex := 0 to NodeCount - 1 do
        begin
          NodeObjectOptions := TNodeObjectOptions.Create(funHandle,
            LayerHandle, NodeIndex);
          try
            NodeObjectOptions.GetLocation(funHandle, X, Y);
            Node := TNode.Create;
            Node.FNumber := NodeIndex + 1;
            Node.FX := X;
            Node.FY := Y;
            NodePositions.AddPoint(X, Y, Node);
            NodeList.Add(Node);
          finally
            NodeObjectOptions.Free;
          end;
        end;

        ElementCount := MeshLayer.NumObjects(funHandle, pieElementObject);
        for ElementIndex := 0 to ElementCount - 1 do
        begin
          ElementOptions := TElementObjectOptions.Create(funHandle,
            LayerHandle, ElementIndex);
          try
            Element := TElement.Create;
            NodeCount := ElementOptions.NumberOfNodes(funHandle);
            for NodeIndex := 0 to NodeCount - 1 do
            begin
              ElementOptions.GetNthNodeLocation(funHandle, X, Y, NodeIndex);

              Node := nil;
              if NodePositions.Count > 0 then
              begin
                XVar := X;
                YVar := Y;
                NodePositions.FirstNearestPoint(XVar, YVar, Data);
                if (X = XVar) or (Y = YVar) then
                begin
                  Node := Data;
                end;
              end;

              if Node = nil then
              begin
                Node := TNode.Create;
                Node.FX := X;
                Node.FY := Y;
                NodePositions.AddPoint(X, Y, Node);
                NodeList.Add(Node);
              end;
              Element.FNodes.Add(Node);
              Node.FElements.Add(Element);

            end;
            ElementList.Add(Element);
          finally
            ElementOptions.Free;
          end;
        end;
      finally
        MeshLayer.Free(funHandle);
      end;
      for NodeIndex := 0 to NodeList.Count - 1 do
      begin
        Node := NodeList.Nodes[NodeIndex];
        Node.CreateCellBoundary;
      end;

      TempNodeList := TList.Create;
      try
        for NodeIndex := 0 to NodeList.Count - 1 do
        begin
          TempNodeList.Add(NodeList[NodeIndex]);
        end;
        SetLength(RangeArray, 2);
        while TempNodeList.Count > 0 do
        begin
          NodeIndex := Random(TempNodeList.Count);
          Node := TempNodeList[NodeIndex];
          TempNodeList.Delete(NodeIndex);
          RangeArray[0] := Node.XRange;
          RangeArray[1] := Node.YRange;
          NodeRangeTree.Add(RangeArray, Node);
        end;

      finally
        TempNodeList.Free;
      end;

      ElementList.CreateMeshBoundary;

      TempElementList := TList.Create;
      try
        for ElementIndex := 0 to ElementList.Count - 1 do
        begin
          Element := ElementList[ElementIndex];
          TempElementList.Add(Element);
          for NodeIndex := 0 to Element.Count - 1 do
          begin
            Node := Element.Nodes[NodeIndex];
            if NodeIndex = 0 then
            begin
              Element.XRange.Min := Node.X;
              Element.YRange.Min := Node.Y;
              Element.XRange.Max := Node.X;
              Element.YRange.Max := Node.Y;
            end
            else
            begin
              if Element.XRange.Min > Node.X then
              begin
                Element.XRange.Min := Node.X;
              end
              else if Element.XRange.Max < Node.X then
              begin
                Element.XRange.Max := Node.X;
              end;

              if Element.YRange.Min > Node.Y then
              begin
                Element.YRange.Min := Node.Y;
              end
              else if Element.YRange.Max < Node.Y then
              begin
                Element.YRange.Max := Node.Y;
              end;
            end;
          end;
        end;
        SetLength(RangeArray, 2);
        while TempElementList.Count > 0 do
        begin
          ElementIndex := Random(TempElementList.Count);
          Element := TempElementList[ElementIndex];
          TempElementList.Delete(ElementIndex);
          RangeArray[0] := Element.XRange;
          RangeArray[1] := Element.YRange;
          ElementRangeTree.Add(RangeArray, Element);
        end;
      finally
        TempElementList.Free;
      end;

      result := true;
    except
      Inc(ErrorCount);
      result := False;
    end;
  finally
    ANE_BOOL_PTR(reply)^ := result;
  end;
end;

procedure ClearMesh(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_BOOL;
begin
  result := False;
  try
    try
      ContourList.Clear;
      ClearIntersectLists;
      NodeList.Clear;
      ElementList.Clear;
      NodePositions.Clear;
      NodeRangeTree.Clear;
      result := True;
      ErrorCount := 0;
    except
      Inc(ErrorCount);
      result := False;
    end;
  finally
    ANE_BOOL_PTR(reply)^ := result;
  end;
end;
{ TNode }

constructor TNode.Create;
begin
  FElements := TList.Create;
  Edges := TList.Create;
end;

function TNode.PointInsideCell(X, Y: ANE_DOUBLE): boolean;
var
  VertexIndex: integer;
  AVertex, AnotherVertex: TRealPoint;
begin // based on CACM 112
  result := (X >= XRange.Min) and (X <= XRange.Max) and (Y >= YRange.Min) and (Y
    <= YRange.Max);
  if not result then
    Exit;
  for VertexIndex := 0 to Length(FCellBoundary) - 2 do
  begin
    AVertex := FCellBoundary[VertexIndex];
    AnotherVertex := FCellBoundary[VertexIndex + 1];
    if ((Y <= AVertex.Y) = (Y > AnotherVertex.Y)) and
      (X - AVertex.X - (Y - AVertex.Y) *
      (AnotherVertex.X - AVertex.X) /
      (AnotherVertex.Y - AVertex.Y) < 0) then
    begin
      result := not result;
    end;
  end;
  result := not result;
end;

procedure TNode.CreateCellBoundary;
var
  SortedElements: TList;
  BeforeNode: TNode;
  AfterNode: TNode;
  NodeIndex: integer;
  Element: TElement;
  BeforeNodeIndex, AfterNodeIndex: integer;
  TempElements: TList;
  ElementIndex: integer;
  Found: boolean;
  Position: integer;
  NodeCount: integer;
  InnerNodeIndex: integer;
  Index: Integer;
begin
  // arrange the elements in order.
  Assert(FElements.Count > 0);
  SortedElements := TList.Create;
  TempElements := TList.Create;
  try
    // put all but the first element in TempElements.
    for ElementIndex := 1 to FElements.Count - 1 do
    begin
      TempElements.Add(FElements[ElementIndex]);
    end;

    // put the first element in SortedElements.
    Element := FElements[0];
    SortedElements.Add(Element);
    // determine where the current node is in the element's list of nodes.
    NodeIndex := Element.FNodes.IndexOf(self);
    Assert(NodeIndex >= 0);
    // Set AfterNodeIndex to the next node beyond the current node.
    if NodeIndex = Element.FNodes.Count - 1 then
    begin
      AfterNodeIndex := 0;
    end
    else
    begin
      AfterNodeIndex := NodeIndex + 1;
    end;

    // Set BeforeNodeIndex to the node just before the current node.
    if NodeIndex = 0 then
    begin
      BeforeNodeIndex := Element.FNodes.Count - 1;
    end
    else
    begin
      BeforeNodeIndex := NodeIndex - 1;
    end;
    // Get the nodes before and after the current node.
    BeforeNode := Element.Nodes[BeforeNodeIndex];
    AfterNode := Element.Nodes[AfterNodeIndex];
    Found := True;
    while Found do
    begin
      Found := False;
      // Loop over remaining nodes.
      for ElementIndex := 0 to TempElements.Count - 1 do
      begin
        Element := TempElements[ElementIndex];
        Position := Element.FNodes.IndexOf(AfterNode);
        // If the current element contains AfterNode,
        // it is the next one to add to SortedElements.
        if Position >= 0 then
        begin
          SortedElements.Add(Element);
          TempElements.Delete(ElementIndex);
          Found := True;
          // update AfterNode.
          NodeIndex := Element.FNodes.IndexOf(self);
          if Position - NodeIndex = 1 then
          begin
            Dec(NodeIndex);
            if NodeIndex < 0 then
            begin
              NodeIndex := Element.FNodes.Count - 1;
            end;
          end
          else if Position - NodeIndex = -1 then
          begin
            Inc(NodeIndex);
            if NodeIndex = Element.FNodes.Count then
            begin
              NodeIndex := 0;
            end;
          end
          else if NodeIndex = 0 then
          begin
            NodeIndex := 1;
          end
          else
          begin
            Assert(NodeIndex = Element.FNodes.Count - 1);
            Dec(NodeIndex);
          end;
          AfterNode := Element.Nodes[NodeIndex];
          Break;
        end;
      end;
    end;
    // For nodes in the interior of the mesh, TempElements should now be empty.
    // However, for nodes on the exterior, there may be additional elements in
    // TempElements.  Work in the other direction to put then in SortedElements.
    if TempElements.Count > 0 then
    begin
      Found := True;
      while Found do
      begin
        Found := False;
        // Loop over remaining nodes.
        for ElementIndex := 0 to TempElements.Count - 1 do
        begin
          Element := TempElements[ElementIndex];
          Position := Element.FNodes.IndexOf(BeforeNode);
          // If the current element contains BeforeNode,
          // it is the next one to insert at the beginning of SortedElements.
          if Position >= 0 then
          begin
            SortedElements.Insert(0, Element);
            TempElements.Delete(ElementIndex);
            Found := True;
            // update BeforeNode.
            NodeIndex := Element.FNodes.IndexOf(self);
            if Position - NodeIndex = 1 then
            begin
              Dec(NodeIndex);
              if NodeIndex < 0 then
              begin
                NodeIndex := Element.FNodes.Count - 1;
              end;
            end
            else if Position - NodeIndex = -1 then
            begin
              Inc(NodeIndex);
              if NodeIndex = Element.FNodes.Count then
              begin
                NodeIndex := 0;
              end;
            end
            else if NodeIndex = 0 then
            begin
              NodeIndex := 1;
            end
            else
            begin
              Assert(NodeIndex = Element.FNodes.Count - 1);
              Dec(NodeIndex);
            end;
            BeforeNode := Element.Nodes[NodeIndex];
            Break;
          end;
        end;
      end;
    end;
    Assert(TempElements.Count = 0);

    SetLength(FCellBoundary, FElements.Count * 2 + 3);
    SetLength(FCellBoundaryNodeLists, FElements.Count * 2 + 3);
    for Index := 0 to Length(FCellBoundaryNodeLists) -1 do
    begin
      FCellBoundaryNodeLists[Index] := nil;
    end;


    NodeCount := 0;
    Element := SortedElements[0];
    BeforeNode := Element.BeforeNode(self);
    FCellBoundary[NodeCount].X := (BeforeNode.X + X) / 2;
    FCellBoundary[NodeCount].Y := (BeforeNode.Y + Y) / 2;
    FCellBoundaryNodeLists[NodeCount] := TList.Create;
    FCellBoundaryNodeLists[NodeCount].Add(BeforeNode);
    Inc(NodeCount);
    Element.Center(FCellBoundary[NodeCount].X, FCellBoundary[NodeCount].Y);
    AfterNode := Element.AfterNode(self);

    FCellBoundaryNodeLists[NodeCount] := TList.Create;
    for InnerNodeIndex := 0 to Element.Count -1 do
    begin
      if Element.Nodes[InnerNodeIndex] <> self then
      begin
        FCellBoundaryNodeLists[NodeCount].Add(Element.Nodes[InnerNodeIndex]);
      end;
    end;

    Inc(NodeCount);
    FCellBoundary[NodeCount].X := (AfterNode.X + X) / 2;
    FCellBoundary[NodeCount].Y := (AfterNode.Y + Y) / 2;
    FCellBoundaryNodeLists[NodeCount] := TList.Create;
    FCellBoundaryNodeLists[NodeCount].Add(AfterNode);
    Inc(NodeCount);
    for ElementIndex := 1 to SortedElements.Count - 1 do
    begin
      Element := SortedElements[ElementIndex];
      Element.Center(FCellBoundary[NodeCount].X, FCellBoundary[NodeCount].Y);
      if Element.BeforeNode(self) = AfterNode then
      begin
        AfterNode := Element.AfterNode(self);
      end
      else
      begin
        Assert(Element.AfterNode(self) = AfterNode);
        AfterNode := Element.BeforeNode(self);
      end;
      FCellBoundaryNodeLists[NodeCount] := TList.Create;
      for InnerNodeIndex := 0 to Element.Count -1 do
      begin
        if Element.Nodes[InnerNodeIndex] <> self then
        begin
          FCellBoundaryNodeLists[NodeCount].Add(Element.Nodes[InnerNodeIndex]);
        end;
      end;
      Inc(NodeCount);
      FCellBoundary[NodeCount].X := (AfterNode.X + X) / 2;
      FCellBoundary[NodeCount].Y := (AfterNode.Y + Y) / 2;
      FCellBoundaryNodeLists[NodeCount] := TList.Create;
      FCellBoundaryNodeLists[NodeCount].Add(AfterNode);
      Inc(NodeCount);
    end;
    if AfterNode <> BeforeNode then
    begin
      FCellBoundary[NodeCount].X := X;
      FCellBoundary[NodeCount].Y := Y;
      FCellBoundaryNodeLists[NodeCount] := nil;
      Inc(NodeCount);
    end;
    if (FCellBoundary[NodeCount - 1].X <> FCellBoundary[0].X)
      or (FCellBoundary[NodeCount - 1].Y <> FCellBoundary[0].Y) then
    begin
      FCellBoundary[NodeCount].X := FCellBoundary[0].X;
      FCellBoundary[NodeCount].Y := FCellBoundary[0].Y;
      FCellBoundaryNodeLists[NodeCount] := TList.Create;
      FCellBoundaryNodeLists[NodeCount].Assign(FCellBoundaryNodeLists[0]);
      Inc(NodeCount);
    end;

    SetLength(FCellBoundary, NodeCount);
    SetLength(FCellBoundaryNodeLists, NodeCount);

    XRange.Min := FCellBoundary[0].X;
    YRange.Min := FCellBoundary[0].Y;
    XRange.Max := XRange.Min;
    YRange.Max := YRange.Min;
    for NodeIndex := 1 to NodeCount - 1 do
    begin
      if FCellBoundary[NodeIndex].X < XRange.Min then
      begin
        XRange.Min := FCellBoundary[NodeIndex].X;
      end
      else if FCellBoundary[NodeIndex].X > XRange.Max then
      begin
        XRange.Max := FCellBoundary[NodeIndex].X;
      end;

      if FCellBoundary[NodeIndex].Y < YRange.Min then
      begin
        YRange.Min := FCellBoundary[NodeIndex].Y;
      end
      else if FCellBoundary[NodeIndex].Y > YRange.Max then
      begin
        YRange.Max := FCellBoundary[NodeIndex].Y;
      end;
    end;

  finally
    SortedElements.Free;
    TempElements.Free;
  end;

  Assert(FBoundary = nil);
  FBoundary := TBoundarySegment.Create(FCellBoundary, 0, NodeCount - 1);

end;

destructor TNode.Destroy;
var
  Index: integer;
begin
  for Index := 0 to Length(FCellBoundaryNodeLists) -1 do
  begin
    FCellBoundaryNodeLists[Index].Free;
  end;

  FBoundary.Free;
  FElements.Free;
  Edges.Free;

  SetLength(FCellBoundaryNodeLists, 0);
  SetLength(FCellBoundary, 0);
  inherited;
end;

function TNode.GetPoint: TRealPoint;
begin
  result.X := FX;
  result.Y := FY;
end;

function TNode.Intersect(const StartPoint, EndPoint: TRealPoint;
  out Intersection: TPointArray; out Locations: TIntegerArray): boolean;
begin
  Assert(FBoundary <> nil);
  result := FBoundary.Intersect(StartPoint, EndPoint, Intersection, Locations);
end;

function TNode.GetCellBoundary(const Index: integer): TRealPoint;
begin
  result := FCellBoundary[Index];
end;

function TNode.GetCellBoundaryNodeList(const Index: integer): TList;
begin
  result := FCellBoundaryNodeLists[Index];
end;

function TNode.GetCount: integer;
begin
  result := Length(FCellBoundary);
end;

{ TNodeList }

procedure TNodeList.Add(const Node: TNode);
begin
  (FList as TObjectList).Add(Node);
end;

procedure TNodeList.Clear;
begin
  FList.Clear;
end;

constructor TNodeList.Create;
begin
  FList := TObjectList.Create;
end;

destructor TNodeList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TNodeList.GetCount: integer;
begin
  result := FList.Count;
end;

function TNodeList.GetNodes(const Index: integer): TNode;
begin
  result := FList[Index];
end;

{ TElement }

procedure TElement.Center(var X, Y: double);
var
  Index: integer;
  Node: TNode;
begin
  X := 0;
  Y := 0;
  for Index := 0 to Count - 1 do
  begin
    Node := Nodes[Index];
    X := X + Node.X;
    Y := Y + Node.Y;
  end;
  X := X / Count;
  Y := Y / Count;
end;

constructor TElement.Create;
begin
  FNodes := TList.Create;
end;

destructor TElement.Destroy;
begin
  FNodes.Free;
  inherited;
end;

function TElement.AfterNode(const Node: TNode): TNode;
var
  NodeIndex: integer;
begin
  NodeIndex := FNodes.IndexOf(Node);
  Assert(NodeIndex >= 0);
  if NodeIndex = FNodes.Count - 1 then
  begin
    NodeIndex := 0;
  end
  else
  begin
    Inc(NodeIndex)
  end;
  result := Nodes[NodeIndex];
end;

function TElement.BeforeNode(const Node: TNode): TNode;
var
  NodeIndex: integer;
begin
  NodeIndex := FNodes.IndexOf(Node);
  Assert(NodeIndex >= 0);
  if NodeIndex = 0 then
  begin
    NodeIndex := FNodes.Count - 1
  end
  else
  begin
    Dec(NodeIndex);
  end;
  result := Nodes[NodeIndex];
end;

function TElement.GetCount: integer;
begin
  result := FNodes.Count;
end;

function TElement.GetNodes(const Index: integer): TNode;
begin
  result := FNodes[Index];
end;

function TElement.PointInsideElement(X, Y: ANE_DOUBLE): boolean;
var
  NodeIndex: integer;
  ANode, AnotherNode: TNode;
begin // based on CACM 112
  result := (X >= XRange.Min) and (X <= XRange.Max) and (Y >= YRange.Min) and (Y
    <= YRange.Max);
  if not result then
    Exit;
  FNodes.Add(FNodes[0]);
  try
    for NodeIndex := 0 to FNodes.Count - 2 do
    begin
      ANode := FNodes[NodeIndex];
      AnotherNode := FNodes[NodeIndex + 1];
      if ((Y <= ANode.Y) = (Y > AnotherNode.Y)) and
        (X - ANode.X - (Y - ANode.Y) *
        (AnotherNode.X - ANode.X) /
        (AnotherNode.Y - ANode.Y) < 0) then
      begin
        result := not result;
      end;
    end;
    result := not result;
  finally
    FNodes.Delete(FNodes.Count - 1);
  end;
end;

{ TElementList }

procedure TElementList.Clear;
begin
  FList.Clear;
  FBoundaryList.Clear;
//  FreeAndNil(FBoundary);
end;

constructor TElementList.Create;
begin
  FList := TObjectList.Create;
  FBoundaryList := TObjectList.Create;
end;

destructor TElementList.Destroy;
begin
  FBoundaryList.Free;
//  FBoundary.Free;
  FList.Free;
  inherited;
end;

function TElementList.GetCount: integer;
begin
  result := FList.Count;
end;

function TElementList.GetElements(const Index: integer): TElement;
begin
  result := FList[Index]
end;

procedure TElementList.Add(const Element: TElement);
begin
  FList.Add(Element)
end;

procedure TElementList.CreateMeshBoundary;
var
  ElementIndex: integer;
  Element: TElement;
  NodeIndex: integer;
  Node1, Node2: TNode;
  EdgeIndex: integer;
  Edge, OtherEdge: TElementEdge;
  EdgeCount: integer;
  Boundary: TMeshBoundary;
begin
  FBoundaryList.Clear;

  // Each pair of adjacent nodes in an element defines an edge of the
  // element.  Internal edges are shared by exactly two elements.
  // The strategy here is to eliminate all internal edges.  The
  // edges that remain are the mesh boundary.
  EdgeCount := 0;
  for ElementIndex := 0 to Count - 1 do
  begin
    Element := Elements[ElementIndex];
    for NodeIndex := 0 to Element.Count - 1 do
    begin
      Node1 := Element.Nodes[NodeIndex];
      if NodeIndex = Element.Count - 1 then
      begin
        Node2 := Element.Nodes[0];
      end
      else
      begin
        Node2 := Element.Nodes[NodeIndex + 1];
      end;
      Edge := TElementEdge.Create(Node1, Node2);
      for EdgeIndex := 0 to Node1.Edges.Count - 1 do
      begin
        OtherEdge := Node1.Edges[EdgeIndex];
        if Edge.Same(OtherEdge) then
        begin
          Node1.Edges.Delete(EdgeIndex);
          Node2.Edges.Remove(OtherEdge);
          OtherEdge.Free;
          Edge.Free;
          Edge := nil;
          Dec(EdgeCount);
          break;
        end;
      end;
      if Edge <> nil then
      begin
        Node1.Edges.Add(Edge);
        Node2.Edges.Add(Edge);
        Inc(EdgeCount);
      end;
    end;
  end;

  while EdgeCount > 0 do
  begin
    Boundary:= TMeshBoundary.Create;
    FBoundaryList.Add(Boundary);

    with Boundary do
    begin
      SetLength(FMeshBoundary, EdgeCount + 1);
      SetLength(FBoundaryNodes, EdgeCount + 1);

      // Find a node on the edge of the mesh.
      Node1 := nil;
      for NodeIndex := 0 to NodeList.Count - 1 do
      begin
        Node1 := NodeList[NodeIndex];
        if Node1.Edges.Count > 0 then
        begin
          break;
        end;
      end;

      // Store data about the first node.
      Edge := Node1.Edges[0];
      EdgeIndex := 0;
      FMeshBoundary[EdgeIndex].X := Node1.X;
      FMeshBoundary[EdgeIndex].Y := Node1.Y;
      FBoundaryNodes[EdgeIndex] := Node1;

      // Get the next node and destroy the previous edge.
      Node1.Edges.Remove(Edge);
      Node1 := Edge.OtherNode(Node1);
      Node1.Edges.Remove(Edge);
      Edge.Free;

      // Follow the edges around the mesh boundary.
      while Node1.Edges.Count > 0 do
      begin
        Inc(EdgeIndex);
        Assert(EdgeIndex <= EdgeCount);
        FMeshBoundary[EdgeIndex].X := Node1.X;
        FMeshBoundary[EdgeIndex].Y := Node1.Y;
        FBoundaryNodes[EdgeIndex] := Node1;
        if Node1.Edges.Count > 0 then
        begin
          Edge := Node1.Edges[0];
          Node1.Edges.Remove(Edge);
          Node1 := Edge.OtherNode(Node1);
          Node1.Edges.Remove(Edge);
          Edge.Free;
        end;
      end;
      Inc(EdgeIndex);

      // Store information about the last point.
      Assert(EdgeIndex <= EdgeCount);
      FMeshBoundary[EdgeIndex].X := Node1.X;
      FMeshBoundary[EdgeIndex].Y := Node1.Y;
      FBoundaryNodes[EdgeIndex] := Node1;

      // Check that the results are valid.
      Assert((MeshBoundary[EdgeIndex].X = MeshBoundary[0].X)
        and (MeshBoundary[EdgeIndex].Y = MeshBoundary[0].Y));

      Assert(FBoundary = nil);
      FBoundary := TBoundarySegment.Create(FMeshBoundary, 0, EdgeIndex);

      SetLength(FMeshBoundary, EdgeIndex + 1);
      SetLength(FBoundaryNodes, EdgeIndex + 1);

      Dec(EdgeCount, EdgeIndex);
    end;
  end;
end;

function TElementList.PointInsideMeshBoundary(X, Y: ANE_DOUBLE): boolean;
var
  Index: integer;
  Boundary: TMeshBoundary;
begin
  result := False;
  for Index := 0 to FBoundaryList.Count -1 do
  begin
    Boundary := FBoundaryList[Index];
    if Boundary.PointInsideMeshBoundary(X, Y) then
    begin
      result := not result;
    end;
  end;
end;

function TElementList.Intersect(const StartPoint, EndPoint: TRealPoint;
  out Intersection: TPointArray; out Locations: TIntegerArray): boolean;
var
  BoundIndex: integer;
  Boundary: TMeshBoundary;
  FoundIntersection: boolean;
  TempIntersection: TPointArray;
  TempLocations: TIntegerArray;
  OldLength, NewLength: integer;
  PointIndex: integer;
  OffSet: integer;
begin
  OffSet := 0;
  FoundIntersection := False;
  for BoundIndex := 0 to FBoundaryList.Count -1 do
  begin
    Boundary := FBoundaryList[BoundIndex];
    if Boundary.Intersect(StartPoint, EndPoint,
      TempIntersection, TempLocations) then
    begin
      if FoundIntersection then
      begin
        OldLength := Length(Intersection);
        NewLength := OldLength + Length(TempIntersection);
        SetLength(Intersection, NewLength);
        SetLength(Locations, NewLength);
        for PointIndex := 0 to Length(TempIntersection) -1 do
        begin
          Intersection[PointIndex + OldLength] := TempIntersection[PointIndex];
          Locations[PointIndex + OldLength] := TempLocations[PointIndex] + OffSet;
        end;
      end
      else
      begin
        FoundIntersection := True;
        Intersection := TempIntersection;
        Locations := TempLocations;
      end;
    end;
    OffSet := OffSet + Length(Boundary.FMeshBoundary);
  end;
  result := FoundIntersection;

//  Assert(FBoundary <> nil);
//  result := FBoundary.Intersect(StartPoint, EndPoint, Intersection, Locations);
end;

function TElementList.GetMeshBoundary(Index: integer): TRealPoint;
var
  BoundIndex: integer;
  Boundary: TMeshBoundary;
  Len: integer;
begin
  for BoundIndex := 0 to FBoundaryList.Count -1 do
  begin
    Boundary := FBoundaryList[BoundIndex];
    Len := Length(Boundary.FMeshBoundary);
    if Index < Len then
    begin
      result := Boundary.MeshBoundary[Index];
      break;
    end
    else
    begin
      Dec(Index, Len);
    end;
  end;
//  result := FMeshBoundary[Index];
end;

function TElementList.GetBoundaryNodes(Index: integer): TNode;
var
  BoundIndex: integer;
  Boundary: TMeshBoundary;
  Len: integer;
begin
  result := nil;
  for BoundIndex := 0  to FBoundaryList.Count -1 do
  begin
    Boundary := FBoundaryList[BoundIndex];
    Len := Length(Boundary.FBoundaryNodes);
    if Index < Len  then
    begin
      result := Boundary.BoundaryNodes[Index];
      break;
    end
    else
    begin
      Dec(Index, Len);
    end;
  end;

//  result := FBoundaryNodes[Index];
end;

{ TElementEdge }

constructor TElementEdge.Create(const Node1, Node2: TNode);
begin
  FList := TList.Create;
  FList.Add(Node1);
  FList.Add(Node2);
end;

destructor TElementEdge.Destroy;
begin
  FList.Free;
  inherited;
end;

function TElementEdge.OtherNode(const Node: TNode): TNode;
var
  Position: integer;
begin
  Position := FList.IndexOf(Node);
  Assert(Position >= 0);
  result := FList[1 - Position];
end;

function TElementEdge.Same(const Edge: TElementEdge): boolean;
begin
  result := ((FList[0] = Edge.FList[0]) and (FList[1] = Edge.FList[1]))
    or ((FList[0] = Edge.FList[1]) and (FList[1] = Edge.FList[0]))
end;

{ TBoundarySegment }
constructor TBoundarySegment.Create(const Boundary: TPointArray;
  const StartIndex, EndIndex: integer);
var
  Middle: integer;
  Index: integer;
begin
  FBoundary := Boundary;
  FStartIndex := StartIndex;
  FEndIndex := EndIndex;
  if EndIndex - StartIndex > 4 then
  begin
    Middle := (EndIndex + StartIndex) div 2;
    FSubBoundaries[0] := TBoundarySegment.Create(Boundary, StartIndex, Middle);
    FSubBoundaries[1] := TBoundarySegment.Create(Boundary, Middle, EndIndex);
    FMinPoint := FSubBoundaries[0].FMinPoint;
    FMaxPoint := FSubBoundaries[0].FMaxPoint;
    if FMinPoint.X > FSubBoundaries[1].FMinPoint.X then
    begin
      FMinPoint.X := FSubBoundaries[1].FMinPoint.X
    end;
    if FMinPoint.Y > FSubBoundaries[1].FMinPoint.Y then
    begin
      FMinPoint.Y := FSubBoundaries[1].FMinPoint.Y
    end;
    if FMaxPoint.X < FSubBoundaries[1].FMaxPoint.X then
    begin
      FMaxPoint.X := FSubBoundaries[1].FMaxPoint.X
    end;
    if FMaxPoint.Y < FSubBoundaries[1].FMaxPoint.Y then
    begin
      FMaxPoint.Y := FSubBoundaries[1].FMaxPoint.Y
    end;
  end
  else
  begin
    FMinPoint := Boundary[StartIndex];
    FMaxPoint := Boundary[StartIndex];
    for Index := StartIndex + 1 to EndIndex do
    begin
      if FMinPoint.X > Boundary[Index].X then
      begin
        FMinPoint.X := Boundary[Index].X
      end;
      if FMinPoint.Y > Boundary[Index].Y then
      begin
        FMinPoint.Y := Boundary[Index].Y
      end;
      if FMaxPoint.X < Boundary[Index].X then
      begin
        FMaxPoint.X := Boundary[Index].X
      end;
      if FMaxPoint.Y < Boundary[Index].Y then
      begin
        FMaxPoint.Y := Boundary[Index].Y
      end;
    end;
  end;
end;

destructor TBoundarySegment.Destroy;
var
  Index: integer;
begin
  for Index := 0 to 1 do
  begin
    FSubBoundaries[Index].Free;
  end;
  inherited;
end;

{
  Compute the points of intersection between the TBoundarySegment
  and a line segment defined by StartPoint and EndPoint.
}
function TBoundarySegment.Intersect(const StartPoint, EndPoint: TRealPoint;
  out Intersection: TPointArray; out Locations: TIntegerArray): boolean;
var
  XMin, XMax: double;
  YMin, YMax: double;
  Other: TPointArray;
  OldLength: integer;
  Index: integer;
  Count: integer;
  IntersectPoint: TRealPoint;
  OtherLocations: TIntegerArray;
begin
  result := False;
  // Check if the range of X values in StartPoint to EndPoint overlaps
  // the range of the TBoundarySegment.  If the ranges don't overlap,
  // there is no intersection.
  if StartPoint.X < EndPoint.X then
  begin
    XMin := StartPoint.X;
    XMax := EndPoint.X;
  end
  else
  begin
    XMin := EndPoint.X;
    XMax := StartPoint.X;
  end;
  if (XMin > FMaxPoint.X) or (XMax < FMinPoint.X) then
  begin
    Exit;
  end;
  if StartPoint.X < EndPoint.X then
  begin
    XMin := StartPoint.X;
    XMax := EndPoint.X;
  end
  else
  begin
    XMin := EndPoint.X;
    XMax := StartPoint.X;
  end;
  if (XMin > FMaxPoint.X) or (XMax < FMinPoint.X) then
  begin
    Exit;
  end;

  // Check if the range of Y values in StartPoint to EndPoint overlaps
  // the range of the TBoundarySegment.  If the ranges don't overlap,
  // there is no intersection.
  if StartPoint.Y < EndPoint.Y then
  begin
    YMin := StartPoint.Y;
    YMax := EndPoint.Y;
  end
  else
  begin
    YMin := EndPoint.Y;
    YMax := StartPoint.Y;
  end;
  if (YMin > FMaxPoint.Y) or (YMax < FMinPoint.Y) then
  begin
    Exit;
  end;
  if StartPoint.Y < EndPoint.Y then
  begin
    YMin := StartPoint.Y;
    YMax := EndPoint.Y;
  end
  else
  begin
    YMin := EndPoint.Y;
    YMax := StartPoint.Y;
  end;
  if (YMin > FMaxPoint.Y) or (YMax < FMinPoint.Y) then
  begin
    Exit;
  end;

  // They ranges overlap.
  if FSubBoundaries[0] = nil then
  begin
    // The current TBoundarySegment has no SubBoundaries so compute
    // the intersection.
    Count := 0;
    SetLength(Intersection, FEndIndex - FStartIndex);
    SetLength(Locations, FEndIndex - FStartIndex);
    for Index := FStartIndex to FEndIndex - 1 do
    begin
      if FastGeo.Intersect(StartPoint.X, StartPoint.Y,
        EndPoint.X, EndPoint.Y,
        FBoundary[Index].X, FBoundary[Index].Y,
        FBoundary[Index + 1].X, FBoundary[Index + 1].Y) then
      begin
        IntersectionPoint(StartPoint.X, StartPoint.Y,
          EndPoint.X, EndPoint.Y,
          FBoundary[Index].X, FBoundary[Index].Y,
          FBoundary[Index + 1].X, FBoundary[Index + 1].Y,
          IntersectPoint.X, IntersectPoint.Y);
        Intersection[Count] := IntersectPoint;
        Locations[Count] := Index;
        Inc(Count);
      end;
    end;
    SetLength(Intersection, Count);
    SetLength(Locations, Count);
    result := Count > 0;
  end
  else
  begin
    // The current TBoundarySegment has SubBoundaries so have each subboundary
    // the intersection for itself and, if required, combine the results.
    if FSubBoundaries[0].Intersect(StartPoint, EndPoint, Intersection, Locations)
      then
    begin
      result := True;
      if FSubBoundaries[1].Intersect(StartPoint, EndPoint, Other, OtherLocations)
        then
      begin
        OldLength := Length(Intersection);
        SetLength(Intersection, OldLength + Length(Other));
        SetLength(Locations, OldLength + Length(Other));
        for Index := 0 to Length(Other) - 1 do
        begin
          Intersection[Index + OldLength] := Other[Index];
          Locations[Index + OldLength] := OtherLocations[Index];
        end;
      end;
    end
    else
    begin
      result := FSubBoundaries[1].Intersect(StartPoint, EndPoint, Intersection,
        Locations)
    end;
  end;
end;

procedure GErrorCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_INT32;
begin
  result := ErrorCount;
  ANE_INT32_PTR(reply)^ := result;
end;


{ TMeshBoundary }

destructor TMeshBoundary.Destroy;
begin
  FBoundary.Free;
  inherited;
end;

function TMeshBoundary.GetBoundaryNodes(const Index: integer): TNode;
begin
  result := FBoundaryNodes[Index];
end;

function TMeshBoundary.GetMeshBoundary(const Index: integer): TRealPoint;
begin
  result := FMeshBoundary[Index];
end;

function TMeshBoundary.Intersect(const StartPoint, EndPoint: TRealPoint;
  out Intersection: TPointArray; out Locations: TIntegerArray): boolean;
begin
  Assert(FBoundary <> nil);
  result := FBoundary.Intersect(StartPoint, EndPoint, Intersection, Locations);
end;

function TMeshBoundary.PointInsideMeshBoundary(X, Y: ANE_DOUBLE): boolean;
var
  VertexIndex: integer;
  AVertex, AnotherVertex: TRealPoint;
begin // based on CACM 112
  result := (X >= MinX) and (X <= MaxX) and (Y >= MinY) and (Y <= MaxY);
  if not result then
    Exit;
  for VertexIndex := 0 to Length(FMeshBoundary) - 2 do
  begin
    AVertex := MeshBoundary[VertexIndex];
    AnotherVertex := MeshBoundary[VertexIndex + 1];
    if ((Y <= AVertex.Y) = (Y > AnotherVertex.Y)) and
      (X - AVertex.X - (Y - AVertex.Y) *
      (AnotherVertex.X - AVertex.X) /
      (AnotherVertex.Y - AVertex.Y) < 0) then
    begin
      result := not result;
    end;
  end;
  result := not result;
end;

initialization
  NodeList := TNodeList.Create;
  ElementList := TElementList.Create;
  NodePositions := TRbwQuadTree.Create(nil);

finalization
  NodeList.Free;
  ElementList.Free;
  NodePositions.Free;

end.

