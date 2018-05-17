unit NodeElementUnit;

interface

uses Classes, SysUtils, IntListUnit, VertexUnit, FishnetContourUnit,
  BoundaryContourUnit, SegmentUnit, Math, Dialogs;

type
  TFishnet = class;
  TMesh = class;
  TNeighborHood = class;

  TNode = Class(TVertex)
    Private
      FNodeList : TList;
      FMesh : TMesh;
      FElementList : TList;
      FNeighborHood : TNeighborHood;
    public
      constructor Create(AList : TList; AMesh : TMesh);
      Destructor Destroy; override;
      function NodeNumber : Integer;
      function NodeString : string;
      function Neighborhood : TNeighborHood;
    end;

  TNeighborHood = class(TObject)
  private
    FCenterVertex : TNode;
    function IsPointInside(VertexToCheck : TVertex) : boolean;
    function DoesSegmentCrossNeighborhood(ASegment : TSegment)
      : boolean;
    Procedure NearestPointOnSegmentToCenter(ASegment : TSegment;
      var resultVertex : TVertex);
    Procedure NearestPointOnContourToCenter(AContour :TBoundaryContour;
      var resultVertex : TVertex);
    procedure MoveCenterToContour(AContour :TBoundaryContour;
      UpperCriticalAngle, LowerCriticalAngle: double);
    procedure TrimSegment(var ASegment: TSegment);
  public
    FVertexList : TList;
    constructor Create(CenterNode : TNode);
    Destructor Destroy; override;
  end;



  TQuadElement = class;

  TElementCenterVertex = class(TObject)
    private
      FElement : TQuadElement;
      function GetX : double;
      function GetY : double;
    public
      Property X : double read GetX;
      Property Y : Double read GetY;
      Constructor Create(AnElement : TQuadElement);
  end;

  TQuadElement = Class(TObject)
    private
      FElementList : TList;
      FNodeList : TList;
      FMesh : TMesh;
      FElementCenterVertex : TElementCenterVertex;
      function GetNodeCount : integer;
      function GetNode(Index : integer) : TNode;
    public
      constructor Create(AMesh : TMesh; AList : TList; Node1, Node2, Node3, Node4 : TNode);
      Destructor Destroy; override;
      function ElementNumber : integer;
      function ElementString : String;
      property NodeCount : integer read GetNodeCount;
      property Nodes[Index : integer] : TNode read GetNode;
      function ElementCenterVertex : TElementCenterVertex;
      function ElementShapeIsOK(UpperCriticalAngle, LowerCriticalAngle: double) : boolean;
      function Angle(Index : integer) : double;
    end;

  TFishnetMeshPatch = Class(TObject)
    private
      FFishnet : TFishnet;
      FElementList : TList;
      FNodeList : TList;
      FVertexList : TList;
      FXCount : integer;
      FYCount : integer;
      FNeighborBelow: TFishnetMeshPatch;
      FNeighborToRight: TFishnetMeshPatch;
      FNeighborAbove: TFishnetMeshPatch;
      FNeighborToLeft: TFishnetMeshPatch;
      FRotated : boolean;
      procedure RotateCCW;
      procedure RotateCW;
      procedure resetRotation;
      Procedure ArrangeVerticies;
      procedure CreateNodes;
      procedure CreateElements;
      procedure SetXCount(ACount : integer);
      procedure SetYCount(ACount : integer);
      procedure SetNeighborAbove(const ANeighbor: TFishnetMeshPatch);
      procedure SetNeighborBelow(const ANeighbor: TFishnetMeshPatch);
      procedure SetNeighborToLeft(const ANeighbor: TFishnetMeshPatch);
      procedure SetNeighborToRight(const ANeighbor: TFishnetMeshPatch);
      procedure CreateMesh;
//      function OppositePatch(APatch : TFishnetMeshPatch) : TFishnetMeshPatch;
//    function CommonVerticies(Patch1, Patch2: TFishnetMeshPatch): Integer;
    function GetElement(XIndex, YIndex: integer): TQuadElement;
//      function SetNeighborIfNeighbor(AnotherPatch : TFishnetMeshPatch) : boolean;
{    procedure GetLeftSideVerticies(var Vertex1, Vertex2: TVertex);
    procedure GetTopSideVerticies(var Vertex1, Vertex2: TVertex);
    procedure GetBottomSideVerticies(var Vertex1, Vertex2: TVertex);
    procedure GetRightSideVerticies(var Vertex1, Vertex2: TVertex); }
{    function GetMatchingSide(Vertex1, Vertex2: TVertex;
      AnotherPatch: TFishnetMeshPatch): integer; }
    public
      Constructor Create(Vertex1, Vertex2, Vertex3, Vertex4 : TVertex;
        AnXCount, AYCount : integer);
      Destructor Destroy ; Override;
      function GetNode(XIndex, YIndex : integer) : TNode;
      Property XCount : integer read FXCount Write SetXCount;
      Property YCount : integer read FYCount Write SetYCount;
      property NeighborToLeft : TFishnetMeshPatch read FNeighborToLeft write SetNeighborToLeft;
      property NeighborToRight : TFishnetMeshPatch read FNeighborToRight write SetNeighborToRight;
      property NeighborBelow : TFishnetMeshPatch read FNeighborBelow write SetNeighborBelow;
      property NeighborAbove : TFishnetMeshPatch read FNeighborAbove write SetNeighborAbove;
      function UpperLeftVertex : TVertex;
      function LowerLeftVertex : TVertex;
      function UpperRightVertex : TVertex;
      function LowerRightVertex : TVertex;
    end;

  TMesh = Class(TObject)
    private
      FNodeList : TList;
      FElementList : TList;
    Public
      procedure AdjustMesh(AContour : TBoundaryContour;
        UpperCriticalAngle, LowerCriticalAngle: double);
      constructor Create;
      procedure WriteMesh(MeshStrings: TStrings);
      Procedure CreateMesh(MeshString : string);
    end;

  TFishnet = Class(TMesh)
    private
      FContourList : TList; //holds TFishnetContour
      FPatchList : TList;
      procedure CreateContours(ContourStrings : TStrings;
        FirstIndex, SecondIndex : integer);
      function CreateAPatch(AContour : TFishnetContour) : TFishnetMeshPatch;
      procedure CreatePatches;
      procedure JoinPatches;
      procedure ArrangePatches;
      function SetNeighbors(Patch1, Patch2: TFishnetMeshPatch) : boolean;
//      function SameLocations(Vertex1, Vertex2 : TVertex) : boolean;
      function GetNode(X, Y : double) : TNode;
      procedure SetCounts;
      procedure RearrangeNodesAndElements;
      procedure ArrangePatchesInColumns(ColumnList: TList);
      procedure ArrangePatchesInRows(RowList: TList);
      procedure ArrangeNodesInColumnList(ColumnList: TList);
      procedure ArrangeNodesInRowList(RowList: TList);
    procedure ArrangeElementsInColumnList(ColumnList: TList);
    procedure ArrangeElementsInRowList(RowList: TList);
    public
      constructor Create(ContourStrings : TStrings;
        FirstIndex, SecondIndex : integer);
      Destructor Destroy; override;
      procedure CreateMesh;
      function RowNodeCount: integer;
      function ColumnNodeCount: integer;
  end;

{Const
  CritcalDegreeAngle = 15;

var
  LowerCriticalAngle : double = Pi*CritcalDegreeAngle/180;
  UpperCriticalAngle : double = Pi*(180-CritcalDegreeAngle)/180; }

implementation

uses SolidGeom;

{ TNode }

constructor TNode.Create(AList: TList; AMesh : TMesh);
begin
  inherited Create;
  FNodeList := AList;
  AList.Add(self);
  FMesh := AMesh;
  if FNodeList <> FMesh.FNodeList then
  begin
    FMesh.FNodeList.Add(self);
  end;
  FElementList := TList.Create;
end;

destructor TNode.Destroy;
begin
  FNodeList.Remove(self);
  if FNodeList <> FMesh.FNodeList then
  begin
    FMesh.FNodeList.Remove(self);
  end;
  FElementList.Free;
  FNeighborHood.Free;
  inherited;
end;

function TNode.Neighborhood: TNeighborHood;
var
  Index : integer;
  AnElement : TQuadElement;
  TempElementList : TList;
  NodeList : TList;
  ANode : TNode;
  InnerIndex : integer;
  InnerNodeIndex : integer;
  Found : boolean;
begin
  if (FNeighborHood = nil) and (FElementList.Count > 2) then
  begin
    // Create neighborhood
    FNeighborHood := TNeighborHood.Create(self);
    // create a temporary list of elements
    TempElementList := TList.Create;
    try
      // add all elements that use this node to the temporary list of elements
      TempElementList.Capacity := FElementList.Count;
      for Index := 0 to FElementList.Count -1 do
      begin
        AnElement := FElementList[Index];
        TempElementList.Add(AnElement);
      end;
      // Note: There always should be more than 2 elements in TempElementList
      if TempElementList.Count > 0 then
      begin
        // Get the first element in the list and delete it from the list
        AnElement := TempElementList[0];
        TempElementList.Delete(0);
        // add the center of the element to the neighborhood's list of
        // verticies
        FNeighborHood.FVertexList.Add(AnElement.ElementCenterVertex);
        // create a list of nodes
        NodeList := TList.Create;
        try
          // Add all of the nodes in AnElement to the list except
          // this node
          for Index := 0 to AnElement.FNodeList.Count -1 do
          begin
            ANode := AnElement.FNodeList[Index];
            if ANode <> self then
            begin
              NodeList.Add(ANode);
            end;
          end;
          // Search the list of the remaining elements
          while TempElementList.Count > 0 do
          begin
            // nothing has been found yet.
            Found := False;
            for Index := 0 to TempElementList.Count -1 do
            begin
              // Get an element from the list
              AnElement := TempElementList[Index];
              // loop over the nodes in AnElement
              for InnerIndex := 0 to AnElement.FNodeList.Count - 1 do
              begin
                // check and see if a node in AnElement was also among the nodes
                // of the previous element
                if NodeList.IndexOf(AnElement.FNodeList[InnerIndex]) > -1 then
                begin
                  // if so, the current element shares a side with the current
                  // element.  Remove the element from the temporary list and
                  // add it's center the the neighborhood.
                  TempElementList.Remove(AnElement);
                  FNeighborHood.FVertexList.Add(AnElement.ElementCenterVertex);
                  // clear the list of nodes and then add all the nodes of the
                  // current element to NodeList except this node.
                  NodeList.Clear;
                  for InnerNodeIndex := 0 to AnElement.FNodeList.Count -1 do
                  begin
                    ANode := AnElement.FNodeList[InnerNodeIndex];
                    if ANode <> self then
                    begin
                      NodeList.Add(ANode);
                    end;
                  end;
                  // The element that is a neighbor of the previous element has
                  // been found so you don't need to look any more.
                  Found := True;
                  break;
                end;
                // The element that is a neighbor of the previous element has
                // been found so you don't need to look any more.
                if Found then
                begin
                  break;
                end;
              end;
              // The element that is a neighbor of the previous element has
              // been found so you don't need to look any more.
              if Found then
              begin
                break;
              end;
            end;
          end;
        finally
          NodeList.Free;
        end;

      end;
    finally
      TempElementList.Free;
    end;

  end;
  result := FNeighborHood;
end;

function TNode.NodeNumber: Integer;
begin
  result := FMesh.FNodeList.IndexOf(self) + 1;
end;

function TNode.NodeString: string;
begin
  result := 'N' + Chr(9) + IntToStr(NodeNumber) + Chr(9) + FloatToStrF(X,ffGeneral,20,0)
    + Chr(9) + FloatToStrF(Y,ffGeneral,20,0);
end;



{ TQuadElement }

function TQuadElement.Angle(Index: integer): double;
var
  Node1, Node2, Node3 : TNode;
begin
  FNodeList.Add(FNodeList[0]);
  try
    begin
      if Index = 0 then
      begin
        Node1 := FNodeList[FNodeList.Count -2];
      end
      else
      begin
        Node1 := FNodeList[Index -1];
      end;
      Node2 := FNodeList[Index];
      Node3 := FNodeList[Index +1];
      try
      result := ArcCos(
        ((Node2.X-Node1.X)*(Node3.X-Node2.X) + (Node2.Y-Node1.Y)*(Node3.Y-Node2.Y))/
        ( Sqrt(Sqr(Node2.X-Node1.X) + Sqr(Node2.Y-Node1.Y)) * Sqrt(Sqr(Node3.X-Node2.X) + Sqr(Node3.Y-Node2.Y))));
      except
        on EDivByZero do
        begin
          result := Pi;
        end;
        on EInvalidOp do
        begin
          result := Pi;
        end;
      end;

    end
  finally
    FNodeList.Delete(FNodeList.Count -1);
  end;

end;

constructor TQuadElement.Create(AMesh : TMesh; AList: TList; Node1,
  Node2, Node3, Node4: TNode);
begin
  inherited Create;
  FElementList := AList;
  AList.Add(self);
  FMesh := AMesh;
  if FMesh.FElementList <> FElementList then
  begin
    FMesh.FElementList.Add(self);
  end;
  FNodeList := TList.Create;
  FNodeList.Capacity := 4;
  FNodeList.Add(Node1);
  FNodeList.Add(Node2);
  FNodeList.Add(Node3);
  FNodeList.Add(Node4);
  Node1.FElementList.Add(self);
  Node2.FElementList.Add(self);
  Node3.FElementList.Add(self);
  Node4.FElementList.Add(self);
end;

destructor TQuadElement.Destroy;
var
  Index : integer;
  ANode : TNode;
begin
  for Index := 0 to FNodeList.Count -1 do
  begin
    ANode := FNodeList[Index];
    ANode.FElementList.Remove(self);
  end;
  FNodeList.Free;
  FElementList.Remove(self);
  FElementCenterVertex.Free;
  inherited ;
end;

function TQuadElement.ElementCenterVertex: TElementCenterVertex;
begin
  if FElementCenterVertex = nil then
  begin
    FElementCenterVertex := TElementCenterVertex.Create(self);
  end;
  result := FElementCenterVertex;
end;

function TQuadElement.ElementNumber: integer;
begin
  result := FMesh.FElementList.IndexOf(self) + 1;
end;

function TQuadElement.ElementShapeIsOK(UpperCriticalAngle, LowerCriticalAngle: double): boolean;
var
  Index : integer;
  ElementAngle : double;
begin
  result := True;
  for Index := 0 to FNodeList.Count-1 do
  begin
    ElementAngle := Angle(Index) ;
    result := (ElementAngle < UpperCriticalAngle) and (ElementAngle > LowerCriticalAngle);
    if not result then
    begin
      break;
    end;
  end;

end;

function TQuadElement.ElementString: String;
var
  Index : integer;
  ANode : TNode;
begin
  result := 'E' + Chr(9) + IntToStr(ElementNumber);
  for Index := 0 to FNodeList.Count -1 do
  begin
    ANode := FNodeList[Index];
    result := result + Chr(9) + IntToStr(ANode.NodeNumber);
  end;
end;

function TQuadElement.GetNode(Index: integer): TNode;
begin
  result := FNodeList[Index];
end;

function TQuadElement.GetNodeCount: integer;
begin
  result := FNodeList.count;
end;

{ TFishnetMeshPatch }

procedure TFishnetMeshPatch.ArrangeVerticies;
var
  TempList :  TList;
  HighestVertex, AnotherVertex, NextHighestVertex : TVertex;
  Index : integer;
  HighestIndex : integer;
  NeighborIndex1, NeighborIndex2 : integer;
begin
  // upper left at 0
  // upper right at 1
  // lower right at 2
  // lower left at 3
  TempList := TList.Create;
  TempList.Count := 4;
  HighestVertex := FVertexList[0];
  NextHighestVertex := nil;
  for Index := 1 to FVertexList.Count -1 do
  begin
    AnotherVertex := FVertexList[Index];
    if AnotherVertex.X > HighestVertex.X then
    begin
      NextHighestVertex := HighestVertex;
      HighestVertex := AnotherVertex;
    end
    else if (NextHighestVertex = nil)
      or (AnotherVertex.X > NextHighestVertex.X) then
    begin
      NextHighestVertex := AnotherVertex;
    end;
  end;
  if NextHighestVertex.Y > HighestVertex.Y then
  begin
    HighestVertex := NextHighestVertex;
  end;
  TempList[1] := HighestVertex; // UpperRightVertex
  HighestIndex := FVertexList.IndexOf(HighestVertex);
  FVertexList.Delete(HighestIndex);
  NeighborIndex1 := HighestIndex;
  if NeighborIndex1 = FVertexList.Count then
  begin
    NeighborIndex1 := 0;
  end;
  NeighborIndex2 := NeighborIndex1 -1;
  if NeighborIndex2 = -1 then
  begin
    NeighborIndex2 := FVertexList.Count-1;
  end;

  HighestVertex := FVertexList[NeighborIndex1];
  AnotherVertex := FVertexList[NeighborIndex2];
    if AnotherVertex.X > HighestVertex.X then
    begin
      HighestVertex := AnotherVertex;
      AnotherVertex := FVertexList[NeighborIndex1];
    end;
{  HighestVertex := FVertexList[0];
  for Index := 1 to FVertexList.Count -1 do
  begin
    AnotherVertex := FVertexList[Index];
    if AnotherVertex.X > HighestVertex.X then
    begin
      HighestVertex := AnotherVertex;
    end;
  end;  }
  TempList[2] := HighestVertex; // LowerRight
  FVertexList.Remove(HighestVertex);

{  if TVertex(TempList[1]).Y < TVertex(TempList[2]).Y then
  begin
    TempList.Exchange(1,2);
  end; }

{  HighestVertex := FVertexList[0];
  for Index := 1 to FVertexList.Count -1 do
  begin
    AnotherVertex := FVertexList[Index];
    if AnotherVertex.Y > HighestVertex.Y then
    begin
      HighestVertex := AnotherVertex;
    end;
  end;  }
{  TempList[0] := HighestVertex; // UpperLeft
  FVertexList.Remove(HighestVertex); }
  TempList[0] := AnotherVertex; // UpperLeft
  FVertexList.Remove(AnotherVertex);
  AnotherVertex := FVertexList[0];
  TempList[3] := AnotherVertex; //LowerLeftVertex

  FVertexList.Free;
  FVertexList := TempList;
end;

constructor TFishnetMeshPatch.Create(Vertex1, Vertex2, Vertex3,
  Vertex4: TVertex; AnXCount, AYCount: integer);
begin
  FElementList := TList.Create;
  FNodeList := TList.Create;
  FVertexList := TList.Create;
  FVertexList.Capacity := 4;
  FVertexList.Add(Vertex1.Copy);
  FVertexList.Add(Vertex2.Copy);
  FVertexList.Add(Vertex3.Copy);
  FVertexList.Add(Vertex4.Copy);
  FXCount := AnXCount;
  FYCount := AYCount;
  FRotated := False;
  ArrangeVerticies;
end;

procedure TFishnetMeshPatch.CreateElements;
var
  XIndex, YIndex : integer;
  Procedure CreateElement;
  var
    Node1, Node2, Node3, Node4 : TNode;
  begin
    Node1 := GetNode(XIndex, YIndex);
    Node2 := GetNode(XIndex, YIndex+1);
    Node3 := GetNode(XIndex+1, YIndex+1);
    Node4 := GetNode(XIndex+1, YIndex);
    TQuadElement.Create(FFishnet, FElementList,Node1,Node2,Node3,Node4);
  end;
  var
    Index : integer;
begin
  for Index :=FElementList.Count -1  downto 0 do
  begin
    TQuadElement(FElementList[Index]).Free;
  end;
  FElementList.Clear;
  FElementList.Capacity := FXCount*FYCount;
  
  if FXCount > FYCount then
  begin
    for XIndex := 0 to FXCount-1 do
    begin
      for YIndex := 0 to FYCount-1 do
      begin
        CreateElement;
      end;
    end;
  end
  else
  begin
    for YIndex := 0 to FYCount-1 do
    begin
      for XIndex := 0 to FXCount-1 do
      begin
        CreateElement;
      end;
    end;
  end;
end;

procedure TFishnetMeshPatch.CreateNodes;
var
  XIndex, YIndex : integer;
  procedure CreateNode;
  var
    X1, X2 : extended;
    Y1, Y2 : extended;
    X, Y : extended;
    ANode : TNode;
  begin
    X1 := UpperLeftVertex.X + (YIndex/FYCount)* (LowerLeftVertex.X - UpperLeftVertex.X );
    X2 := UpperRightVertex.X + (YIndex/FYCount)* (LowerRightVertex.X - UpperRightVertex.X );
    X := X1 + (XIndex/FXCount) * (X2 - X1);
    Y1 := UpperLeftVertex.Y + (YIndex/FYCount)* (LowerLeftVertex.Y - UpperLeftVertex.Y );
    Y2 := UpperRightVertex.Y + (YIndex/FYCount)* (LowerRightVertex.Y - UpperRightVertex.Y );
    Y := Y1 + (XIndex/FXCount) * (Y2 - Y1);
    ANode := FFishnet.GetNode(X,Y);
    if ANode = nil then
    begin
      ANode := TNode.Create(FNodeList, FFishnet);
      ANode.X := X;
      ANode.Y := Y;
    end
    else
    begin
      FNodeList.Add(ANode);
    end; 
  end;
begin
  if FXCount > FYCount then
  begin
    for XIndex := 0 to FXCount do
    begin
      for YIndex := 0 to FYCount do
      begin
        CreateNode;
      end;
    end;
  end
  else
  begin
    for YIndex := 0 to FYCount do
    begin
      for XIndex := 0 to FXCount do
      begin
        CreateNode;
      end;
    end;
  end;
end;

destructor TFishnetMeshPatch.Destroy;
var
  Index : integer;
begin
  for Index := FElementList.Count-1 downto 0 do
  begin
    TQuadElement(FElementList[Index]).Free;
  end;
  FElementList.Free;
  FNodeList.Free;
  for Index := 0 to FVertexList.Count -1 do
  begin
    TVertex(FVertexList[Index]).Free;
  end; 
  FVertexList.Free;
  inherited;
end;

function TFishnetMeshPatch.GetNode(XIndex, YIndex: integer): TNode;
var
  Index : integer;
begin
  if FXCount > FYCount then
  begin
    Index := XIndex*(FYCount+1) + YIndex;
  end
  else
  begin
    Index := YIndex*(FXCount+1) + XIndex;
  end;
  result := FNodeList[Index];
end;

function TFishnetMeshPatch.GetElement(XIndex, YIndex: integer): TQuadElement;
var
  Index : integer;
begin
  if FXCount > FYCount then
  begin
    Index := XIndex*(FYCount) + YIndex;
  end
  else
  begin
    Index := YIndex*(FXCount) + XIndex;
  end;
  result := FElementList[Index];
end;

function TFishnetMeshPatch.LowerLeftVertex: TVertex;
begin
  // upper left at 0
  // upper right at 1
  // lower right at 2
  // lower left at 3
  result := FVertexList[3];
end;

function TFishnetMeshPatch.LowerRightVertex: TVertex;
begin
  // upper left at 0
  // upper right at 1
  // lower right at 2
  // lower left at 3
  result := FVertexList[2];
end;

procedure TFishnetMeshPatch.resetRotation;
begin
  FRotated := False;
  if (FNeighborAbove <> nil) and (FNeighborAbove.FRotated) then
  begin
    FNeighborAbove.resetRotation;
  end;
  if (FNeighborToRight <> nil) and (FNeighborToRight.FRotated) then
  begin
    FNeighborToRight.resetRotation;
  end;
  if (FNeighborBelow <> nil) and (FNeighborBelow.FRotated) then
  begin
    FNeighborBelow.resetRotation;
  end;
  if (FNeighborToLeft <> nil) and (FNeighborToLeft.FRotated) then
  begin
    FNeighborToLeft.resetRotation;
  end;

end;

procedure TFishnetMeshPatch.SetNeighborAbove(
  const ANeighbor: TFishnetMeshPatch);
begin
  Assert(FNeighborAbove = nil);
  Assert(ANeighbor.FNeighborBelow = nil);
  FNeighborAbove := ANeighbor;
  ANeighbor.FNeighborBelow := self;
end;

procedure TFishnetMeshPatch.SetNeighborBelow(
  const ANeighbor: TFishnetMeshPatch);
begin
  Assert(FNeighborBelow = nil);
  Assert(ANeighbor.FNeighborAbove = nil);
  FNeighborBelow := ANeighbor;
  ANeighbor.FNeighborAbove := self;
end;

procedure TFishnetMeshPatch.SetNeighborToLeft(
  const ANeighbor: TFishnetMeshPatch);
begin
  Assert(FNeighborToLeft = nil);
  Assert(ANeighbor.FNeighborToRight = nil);
  FNeighborToLeft := ANeighbor;
  ANeighbor.FNeighborToRight := self;
end;

procedure TFishnetMeshPatch.SetNeighborToRight(
  const ANeighbor: TFishnetMeshPatch);
begin
  Assert(FNeighborToRight = nil);
  Assert(ANeighbor.FNeighborToLeft = nil);
  FNeighborToRight := ANeighbor;
  ANeighbor.FNeighborToLeft := self;
end;

procedure TFishnetMeshPatch.SetXCount(ACount: integer);
begin
  if ACount > FXCount then
  begin
    FXCount := ACount;
    if NeighborAbove <> nil then
    begin
      NeighborAbove.XCount := ACount;
    end;
    if NeighborBelow <> nil then
    begin
      NeighborBelow.XCount := ACount;
    end;
  end;

end;

procedure TFishnetMeshPatch.SetYCount(ACount: integer);
begin
  if ACount > FYCount then
  begin
    FYCount := ACount;
    if NeighbortoLeft <> nil then
    begin
      NeighbortoLeft.YCount := ACount;
    end;
    if NeighbortoRight <> nil then
    begin
      NeighbortoRight.YCount := ACount;
    end;
  end;
end;

procedure TFishnetMeshPatch.RotateCW;
var
  temp : integer;
  ANeighbor : TFishnetMeshPatch;
begin
  // rotate clockwise 1/4 turn
  if not FRotated then
  begin
    temp := FXCount;
    FXCount := FYCount;
    FYCount := temp;
    // upper left at 0
    // upper right at 1
    // lower right at 2
    // lower left at 3
    FVertexList.Insert(0, FVertexList[FVertexList.Count -1]);
    FVertexList.Delete(FVertexList.Count -1);
    ANeighbor := FNeighborAbove;
    FNeighborAbove := FNeighborToLeft;
    FNeighborToLeft := FNeighborBelow;
    FNeighborBelow := FNeighborToRight;
    FNeighborToRight := ANeighbor;


{    ANeighbor := FNeighborAbove;
    FNeighborAbove := FNeighborToLeft;
    FNeighborToLeft := FNeighborBelow;
    FNeighborBelow := FNeighborToRight;
    FNeighborToRight := ANeighbor; }
    FRotated := True;
    if (FNeighborAbove <> nil) and not (FNeighborAbove.FRotated) then
    begin
      FNeighborAbove.RotateCW;
    end;
    if (FNeighborToRight <> nil) and not (FNeighborToRight.FRotated) then
    begin
      FNeighborToRight.RotateCW;
    end;
    if (FNeighborBelow <> nil) and not (FNeighborBelow.FRotated) then
    begin
      FNeighborBelow.RotateCW;
    end;
    if (FNeighborToLeft <> nil) and not (FNeighborToLeft.FRotated) then
    begin
      FNeighborToLeft.RotateCW;
    end;
  end;
end;

procedure TFishnetMeshPatch.RotateCCW;
var
  temp : integer;
  ANeighbor : TFishnetMeshPatch;
begin
  // rotate counterclockwise 1/4 turn
  if not FRotated then
  begin
    temp := FXCount;
    FXCount := FYCount;
    FYCount := temp;
    // upper left at 0
    // upper right at 1
    // lower right at 2
    // lower left at 3
    FVertexList.Add(FVertexList[0]);
    FVertexList.Delete(0);
{    ANeighbor := FNeighborAbove;
    FNeighborAbove := FNeighborToRight;
    FNeighborToRight := FNeighborBelow;
    FNeighborBelow := FNeighborToLeft;
    FNeighborToLeft := ANeighbor;}


    ANeighbor := FNeighborAbove;
    FNeighborAbove := FNeighborToRight;
    FNeighborToRight := FNeighborBelow;
    FNeighborBelow := FNeighborToLeft;
    FNeighborToLeft := ANeighbor;
    FRotated := True;
    if (FNeighborAbove <> nil) and not (FNeighborAbove.FRotated) then
    begin
      FNeighborAbove.RotateCCW;
    end;
    if (FNeighborToRight <> nil) and not (FNeighborToRight.FRotated) then
    begin
      FNeighborToRight.RotateCCW;
    end;
    if (FNeighborBelow <> nil) and not (FNeighborBelow.FRotated) then
    begin
      FNeighborBelow.RotateCCW;
    end;
    if (FNeighborToLeft <> nil) and not (FNeighborToLeft.FRotated) then
    begin
      FNeighborToLeft.RotateCCW;
    end;
  end;
end;

function TFishnetMeshPatch.UpperLeftVertex: TVertex;
begin
  // upper left at 0
  // upper right at 1
  // lower right at 2
  // lower left at 3
  result := FVertexList[0];
end;

function TFishnetMeshPatch.UpperRightVertex: TVertex;
begin
  // upper left at 0
  // upper right at 1
  // lower right at 2
  // lower left at 3
  result := FVertexList[1];
end;


procedure TFishnetMeshPatch.CreateMesh;
begin
  CreateNodes;
  CreateElements;
end;

{procedure TFishnetMeshPatch.GetLeftSideVerticies(Var Vertex1, Vertex2 : TVertex);
begin
  Vertex1 := LowerLeftVertex;
  Vertex2 := UpperLeftVertex;
end;

procedure TFishnetMeshPatch.GetRightSideVerticies(Var Vertex1, Vertex2 : TVertex);
begin
  Vertex1 := UpperRightVertex;
  Vertex2 := LowerRightVertex;
end;

procedure TFishnetMeshPatch.GetTopSideVerticies(Var Vertex1, Vertex2 : TVertex);
begin
  Vertex1 := UpperLeftVertex;
  Vertex2 := UpperRightVertex;
end;

procedure TFishnetMeshPatch.GetBottomSideVerticies(Var Vertex1, Vertex2 : TVertex);
begin
  Vertex1 := LowerRightVertex;
  Vertex2 := LowerLeftVertex;
end;  }

function SameLocations(Vertex1, Vertex2: TVertex): boolean;
begin
  result := (Vertex1.X = Vertex2.X) and (Vertex1.Y = Vertex2.Y)
end;

{function TFishnetMeshPatch.GetMatchingSide(Vertex1, Vertex2 : TVertex;
  AnotherPatch: TFishnetMeshPatch) : integer;
var
  PatchVertex1, PatchVertex2 : TVertex;
begin
  result := -1;
  AnotherPatch.GetTopSideVerticies(PatchVertex1, PatchVertex2);
  if
     SameLocations(Vertex1, PatchVertex1) and
     SameLocations(Vertex2, PatchVertex2) then
  begin
    result := 0;
    Exit;
  end;
  AnotherPatch.GetRightSideVerticies(PatchVertex1, PatchVertex2);
  if
     SameLocations(Vertex1, PatchVertex1) and
     SameLocations(Vertex2, PatchVertex2) then
  begin
    result := 1;
    Exit;
  end;
  AnotherPatch.GetBottomSideVerticies(PatchVertex1, PatchVertex2);
  if
     SameLocations(Vertex1, PatchVertex1) and
     SameLocations(Vertex2, PatchVertex2) then
  begin
    result := 2;
    Exit;
  end;
  AnotherPatch.GetLeftSideVerticies(PatchVertex1, PatchVertex2);
  if
     SameLocations(Vertex1, PatchVertex1) and
     SameLocations(Vertex2, PatchVertex2) then
  begin
    result := 3;
    Exit;
  end;
end;    }

{function TFishnetMeshPatch.SetNeighborIfNeighbor(
  AnotherPatch: TFishnetMeshPatch): boolean;
var
  Vertex1, Vertex2 : TVertex;
  ThisSide, MatchingSide : integer;
  Rotations : integer;
  Index : integer;
begin
  result := False;
  GetTopSideVerticies(Vertex1, Vertex2);
  MatchingSide := GetMatchingSide(Vertex1, Vertex2, AnotherPatch);
  if (MatchingSide > -1) then
  begin
    ThisSide := 0;
    result := True;
  end;

  if not result then
  begin
    GetRightSideVerticies(Vertex1, Vertex2);
    MatchingSide := GetMatchingSide(Vertex1, Vertex2, AnotherPatch);
    if (MatchingSide > -1) then
    begin
      ThisSide := 1;
      result := True;
    end;
  end;

  if not result then
  begin
    GetBottomSideVerticies(Vertex1, Vertex2);
    MatchingSide := GetMatchingSide(Vertex1, Vertex2, AnotherPatch);
    if (MatchingSide > -1) then
    begin
      ThisSide := 2;
      result := True;
    end;
  end;

  if not result then
  begin
    GetRightSideVerticies(Vertex1, Vertex2);
    MatchingSide := GetMatchingSide(Vertex1, Vertex2, AnotherPatch);
    if (MatchingSide > -1) then
    begin
      ThisSide := 3;
      result := True;
    end;
  end;

  if result then
  begin
    Rotations := ThisSide + 2 - MatchingSide;
    If Rotations < 0 then
    begin
      Inc(Rotations,4);
    end;
    for Index := 0 to Rotations -1 do
    begin
      AnotherPatch.RotateCW;
      AnotherPatch.resetRotation;
    end;

    case ThisSide of
      0:
        begin
          SetNeighborAbove(AnotherPatch);
        end;
      1:
        begin
          SetNeighborToRight(AnotherPatch);
        end;
      2:
        begin
          SetNeighborBelow(AnotherPatch);
        end;
      3:
        begin
          SetNeighborToLeft(AnotherPatch);
        end;
      else
        begin
          Assert(False);
        end;
    end;
  end;



end;}

{function TFishnetMeshPatch.CommonVerticies(Patch1,
  Patch2: TFishnetMeshPatch): Integer;
var
  AVertex, AnotherVertex : TVertex;
  SameVertexCount : integer;
  OuterIndex, InnerIndex : integer;
begin
  result := 0;
  if (Patch1 = nil) or (Patch2 = nil) then Exit;
  for OuterIndex := 0 to Patch1.FVertexList.Count -1 do
  begin
    AVertex := Patch1.FVertexList[OuterIndex];
    for InnerIndex := 0 to Patch2.FVertexList.Count -1 do
    begin
      AnotherVertex := Patch2.FVertexList[OuterIndex];
      if (AVertex.X = AnotherVertex.X) and (AVertex.Y = AnotherVertex.Y) then
      begin
        Inc(result);
        break;
      end;
    end;
  end;
end; }

{function TFishnetMeshPatch.OppositePatch(
  APatch: TFishnetMeshPatch): TFishnetMeshPatch;
var
  TempPatchList : TList;
  Index : integer;
  TempPatch : TFishnetMeshPatch;
begin
  result := nil;
  if APatch = FNeighborBelow then
  begin
    result := FNeighborAbove;
  end
  else if APatch = FNeighborAbove then
  begin
    result := FNeighborBelow;
  end
  else if APatch = FNeighborToRight then
  begin
    result := FNeighborToLeft;
  end
  else if APatch = FNeighborToLeft then
  begin
    result := FNeighborToRight;
  end
  else
  begin
    Assert(False);
  end;
  if CommonVerticies(APatch,result) > 0 then
  begin
    TempPatchList := TList.Create;
    try
      TempPatchList.Add(FNeighborBelow);
      TempPatchList.Add(FNeighborAbove);
      TempPatchList.Add(FNeighborToRight);
      TempPatchList.Add(FNeighborToLeft);
      TempPatchList.Remove(APatch);
      TempPatchList.Remove(result);
      for Index := 0 to TempPatchList.Count -1 do
      begin
        TempPatch  := TempPatchList[Index];
        if TempPatch <> nil then
        begin
          if CommonVerticies(APatch,result) = 0 then
          begin
            result := TempPatch;
            Exit;
          end;
        end;
      end;
    finally
      TempPatchList.Free;
    end;
  end;
end;  }

{ TFishnet }

procedure TFishnet.ArrangePatches;
var
  Index : integer;
  APatch : TFishnetMeshPatch;
  FoundAbove : boolean;
  NewPatchList : TList;
  FirstPatchOnRow : TFishnetMeshPatch;
  foundBelow : boolean;
  TempPatchList : TList;
  StopList : TList;
  FoundFirst : boolean;
begin
  NewPatchList := TList.Create;
  TempPatchList := TList.Create;
  StopList := TList.Create;
  try
    NewPatchList.Capacity := FPatchList.Count;
    TempPatchList.Capacity := FPatchList.Count;
    StopList.Capacity := FPatchList.Count;
    while FPatchList.Count > 0 do
    begin
      // set the first member of FPatchList to a patch that doesn't
      // have any neighbors above or to the right of it.
      FoundFirst := False;
      for Index := 0 to FPatchList.Count -1 do
      begin
        APatch := FPatchList[Index];
        if (APatch.FNeighborAbove = nil) and (APatch.FNeighborToLeft = nil) then
        begin
          FPatchList.Delete(Index);
          FPatchList.Insert(0,APatch);
          FoundFirst := True;
          break;
        end;
      end;
      Assert(FoundFirst);
      // try to find a higher patch
      repeat
        // move to the right of the first element of FPatchList and try to find a
        // neighbor above. if one is found put it at the beginning of FPatchList
        FoundAbove := False;
        while (APatch.FNeighborToRight <> nil)
          and (NewPatchList.IndexOf(APatch.FNeighborToRight) = -1) do
        begin
          APatch := APatch.FNeighborToRight;
          While (APatch.FNeighborAbove <> nil)
            and (NewPatchList.IndexOf(APatch.FNeighborAbove) = -1) do
          begin
            APatch := APatch.FNeighborAbove;
            if StopList.IndexOf(APatch) = -1 then
            begin
              FPatchList.Remove(APatch);
              FPatchList.Insert(0,APatch);
              FoundAbove := True;
              StopList.Add(APatch);
            end;
          end;
        end;
        // move to the left of the first element of FPatchList and try to find a
        // neighbor above. if one is found put it at the beginning of FPatchList
        while (APatch.FNeighborToLeft <> nil)
          and (NewPatchList.IndexOf(APatch.FNeighborToLeft) = -1) do
        begin
          APatch := APatch.FNeighborToLeft;
          While (APatch.FNeighborAbove <> nil)
            and (NewPatchList.IndexOf(APatch.FNeighborAbove) = -1) do
          begin
            APatch := APatch.FNeighborAbove;
            if StopList.IndexOf(APatch) = -1 then
            begin
              FPatchList.Remove(APatch);
              FPatchList.Insert(0,APatch);
              FoundAbove := True;
              StopList.Add(APatch);
            end;
          end;
        end;
      until Not FoundAbove;
      StopList.Clear;
      // store a row of patches in FPatchList
      APatch := FPatchList[0];
      FirstPatchOnRow := APatch;
      FPatchList.Remove(APatch);
      TempPatchList.Add(APatch);
      while (APatch.FNeighborToRight <> nil)
        and (NewPatchList.IndexOf(APatch.FNeighborToRight) = -1)
        and (TempPatchList.IndexOf(APatch.FNeighborToRight) = -1) do
      begin
        APatch := APatch.FNeighborToRight;
        FPatchList.Remove(APatch);
        TempPatchList.Add(APatch);
      end;
      // try to find the leftmost patch below the current row.
      foundBelow := True;
      While foundBelow do
      begin
        foundBelow := False;
        for Index := TempPatchList.IndexOf(FirstPatchOnRow) to TempPatchList.Count -1 do
        begin
          if Index = -1 then
          begin
            break;
          end;
          APatch := TempPatchList[Index];
          if (APatch.FNeighborBelow <> nil)
            and (NewPatchList.IndexOf(APatch.FNeighborBelow) = -1) then
          begin
            FirstPatchOnRow := APatch.FNeighborBelow;
            if StopList.IndexOf(FirstPatchOnRow) = -1 then
            begin
              StopList.Add(FirstPatchOnRow);
              foundBelow := True;
            end;
            while (FirstPatchOnRow.NeighborToLeft <> nil)
              and (NewPatchList.IndexOf(FirstPatchOnRow.NeighborToLeft) = -1) do

            begin
              FirstPatchOnRow := FirstPatchOnRow.NeighborToLeft;
            end;
            break;
          end;
        end;
        // add all the patches on the row to TempPatchList
        if FoundBelow then
        begin
          APatch := FirstPatchOnRow;
          if FPatchList.IndexOf(APatch) > -1 then
          begin
            FPatchList.Remove(APatch);
            TempPatchList.Add(APatch);
          end;
          while (APatch.FNeighborToRight <> nil)
            and (NewPatchList.IndexOf(APatch.FNeighborToRight) = -1) do
          begin
            APatch := APatch.FNeighborToRight;
            if FPatchList.IndexOf(APatch) > -1 then
            begin
              FPatchList.Remove(APatch);
              TempPatchList.Add(APatch);
            end;
          end;
        end;
      end;
      for Index := 0 to TempPatchList.Count -1 do
      begin
        NewPatchList.Add(TempPatchList[Index]);
      end;
      TempPatchList.Clear;
    end;
  finally
    FPatchList.Free;
    StopList.Free;
    FPatchList := NewPatchList;
  end;

end;

constructor TFishnet.Create(ContourStrings: TStrings;
  FirstIndex, SecondIndex : integer);
begin
  inherited Create;
  FContourList := TList.Create;
  FPatchList := TList.Create;
  CreateContours(ContourStrings, FirstIndex, SecondIndex);
  CreatePatches;
  JoinPatches;
  ArrangePatches;
  SetCounts;
end;

function TFishnet.CreateAPatch(
  AContour: TFishnetContour): TFishnetMeshPatch;
begin
  result := TFishnetMeshPatch.Create(AContour.Verticies[0],
    AContour.Verticies[1], AContour.Verticies[2],
    AContour.Verticies[3],
    AContour.Values[0], AContour.Values[1]);
  result.FFishnet := self;
end;

procedure TFishnet.CreateContours(ContourStrings: TStrings;
  FirstIndex, SecondIndex : integer);
var
  AStringList : TStringList;
  Index : Integer;
  AFishnetContour : TFishnetContour;
begin
  AStringList := TStringList.Create;
  try
    for Index := 0 to ContourStrings.Count -1 do
    begin
      if (ContourStrings[Index] = '') or (Index = ContourStrings.Count -1) then
      begin
        if (Index = ContourStrings.Count -1) then
        begin
          AStringList.Add(ContourStrings[Index]);
        end;
        AFishnetContour := TFishnetContour.Create(AStringList,FirstIndex,SecondIndex);
        FContourList.Add(AFishnetContour);
        AStringList.Clear;
      end
      else
      begin
        AStringList.Add(ContourStrings[Index]);
      end;
    end;
  finally
    AStringList.Free;
  end;

end;

procedure TFishnet.CreateMesh;
var
  PatchIndex {, Index}: integer;
  APatch : TFishNetMeshPatch;
//  ANode : TNode;
//  AnElement : TQuadElement;
begin
  for PatchIndex := 0 to FPatchList.Count -1 do
  begin
    APatch := FPatchList[PatchIndex];
    APatch.CreateMesh;
  end;
  RearrangeNodesAndElements;
end;

function TFishnet.RowNodeCount : integer;
var
  APatch : TFishnetMeshPatch;
begin
  result := 0;
  if FPatchList.Count > 0 then
  begin
      APatch := FPatchList[0];
      result := APatch.FYCount+1;
      while APatch.FNeighborBelow <> nil do
      begin
        APatch := APatch.FNeighborBelow;
        result := result + APatch.FYCount ;
      end;
  end;
end;

function TFishnet.ColumnNodeCount : integer;
var
  APatch : TFishnetMeshPatch;
begin
  result := 0;
  if FPatchList.Count > 0 then
  begin
      APatch := FPatchList[0];
      result := APatch.FXCount+1;
      while APatch.FNeighborToRight <> nil do
      begin
        APatch := APatch.FNeighborToRight;
        result := result + APatch.FXCount ;
      end;
  end;
end;

procedure TFishnet.ArrangePatchesInRows(RowList : TList);
var
  PatchRow : TList;
  APatch, FirstPatch {, PreviousPatch, NewPatch} : TFishnetMeshPatch;
  NewPatchList : TList;
begin
  NewPatchList := TList.Create;
  NewPatchList.Capacity := FPatchList.Count;
  While FPatchList.Count > 0 do
  begin
    PatchRow := TList.Create;
    RowList.Add(PatchRow);
    APatch := FPatchList[0];

    NewPatchList.Add(APatch);
    FPatchList.Delete(0);

    PatchRow.Add(APatch);
    FirstPatch := APatch;
    while (FirstPatch.NeighborBelow <> nil)
      and (FPatchList.IndexOf(FirstPatch.NeighborBelow) > -1) do
    begin
      while (APatch.NeighborToRight <> nil)
        and (FPatchList.IndexOf(APatch.NeighborToRight) > -1) do
      begin
        APatch := APatch.NeighborToRight;
        PatchRow.Add(APatch);

        NewPatchList.Add(APatch);
        FPatchList.Remove(APatch);

      end;
      if (FPatchList.IndexOf(FirstPatch.NeighborBelow) > -1) then
      begin
        FirstPatch := FirstPatch.NeighborBelow;
        APatch := FirstPatch;
        PatchRow := TList.Create;
        RowList.Add(PatchRow);
        PatchRow.Add(APatch);

        NewPatchList.Add(APatch);
        FPatchList.Remove(APatch);

      end;
    end;
    while (APatch.NeighborToRight <> nil)
      and (FPatchList.IndexOf(APatch.NeighborToRight) > -1) do
    begin
      APatch := APatch.NeighborToRight;
      PatchRow.Add(APatch);

      NewPatchList.Add(APatch);
      FPatchList.Remove(APatch);

    end;
  end;
  FPatchList.Free;
  FPatchList := NewPatchList;
{  PatchRow := TList.Create;
  RowList.Add(PatchRow);
  APatch := FPatchList[0];
  PatchRow.Add(APatch);
  FirstPatch := APatch;
  while FirstPatch.NeighborBelow <> nil do
  begin
    PreviousPatch := APatch;
    APatch := APatch.FNeighborToRight;
    while APatch.OppositePatch(PreviousPatch) <> nil do
    begin
      NewPatch := APatch.OppositePatch(PreviousPatch);
      PreviousPatch := APatch;
      APatch := NewPatch;
//      APatch := APatch.FNeighborToRight;
      PatchRow.Add(APatch);
    end;
    FirstPatch := FirstPatch.NeighborBelow;
    APatch := FirstPatch;
    PatchRow := TList.Create;
    RowList.Add(PatchRow);
    PatchRow.Add(APatch);
  end;
  while APatch.FNeighborToRight <> nil do
  begin
    APatch := APatch.FNeighborToRight;
    PatchRow.Add(APatch);
  end;  }
end;

procedure TFishnet.ArrangeNodesInRowList(RowList : TList);
var
  NewNodeList : TList;
  PatchRowIndex, PatchColumnIndex : integer;
  PatchRow : TList;
  APatch : TFishnetMeshPatch;
  RowNodeCount : integer;
  RowNodeIndex, ColumnNodeIndex : integer;
  ANode : TNode;
begin
  if RowList.Count > 0 then
  begin
    NewNodeList := TList.Create;
    NewNodeList.Capacity := FNodeList.Count;
    for PatchRowIndex := 0 to RowList.Count -1 do
    begin
      PatchRow := RowList[PatchRowIndex];
      APatch := PatchRow[0];
      RowNodeCount := APatch.YCount+1;
      for RowNodeIndex := 0 to RowNodeCount -1 do
      begin
        for PatchColumnIndex := 0 to PatchRow.Count -1 do
        begin
          APatch := PatchRow[PatchColumnIndex];
          for ColumnNodeIndex := 0 to APatch.XCount do
          begin
            ANode := APatch.GetNode(ColumnNodeIndex,RowNodeIndex);
            if NewNodeList.IndexOf(ANode) < 0 then
            begin
              NewNodeList.Add(ANode);
            end;
          end;

        end;

      end;

    end;
    Assert(FNodeList.Count = NewNodeList.Count);
    FNodeList.Free;
    FNodeList := NewNodeList;
  end;

end;

procedure TFishnet.ArrangeElementsInRowList(RowList : TList);
var
  NewElementList : TList;
  PatchRowIndex, PatchColumnIndex : integer;
  PatchRow : TList;
  APatch : TFishnetMeshPatch;
  RowElementCount : integer;
  RowElementIndex, ColumnElementIndex : integer;
  AnElement : TQuadElement;
begin
  if RowList.Count > 0 then
  begin
    NewElementList := TList.Create;
    NewElementList.Capacity := FElementList.Count;
    for PatchRowIndex := 0 to RowList.Count -1 do
    begin
      PatchRow := RowList[PatchRowIndex];
      APatch := PatchRow[0];
      RowElementCount := APatch.YCount;
      for RowElementIndex := 0 to RowElementCount -1 do
      begin
        for PatchColumnIndex := 0 to PatchRow.Count -1 do
        begin
          APatch := PatchRow[PatchColumnIndex];
          for ColumnElementIndex := 0 to APatch.XCount-1 do
          begin
            AnElement := APatch.GetElement(ColumnElementIndex,RowElementIndex);
            if NewElementList.IndexOf(AnElement) < 0 then
            begin
              NewElementList.Add(AnElement);
            end;
          end;

        end;

      end;

    end;
    Assert(FElementList.Count = NewElementList.Count);
    FElementList.Free;
    FElementList := NewElementList;
  end;

end;

procedure TFishnet.ArrangeNodesInColumnList(ColumnList : TList);
var
  NewNodeList : TList;
  PatchRowIndex, PatchColumnIndex : integer;
  PatchColumn : TList;
  APatch : TFishnetMeshPatch;
  ColumnNodeCount : integer;
  RowNodeIndex, ColumnNodeIndex : integer;
  ANode : TNode;
begin
  if ColumnList.Count > 0 then
  begin
    NewNodeList := TList.Create;
    NewNodeList.Capacity := FNodeList.Count;
    for PatchColumnIndex := 0 to ColumnList.Count -1 do
    begin
      PatchColumn := ColumnList[PatchColumnIndex];
      APatch := PatchColumn[0];
      ColumnNodeCount := APatch.XCount+1;
      for ColumnNodeIndex := 0 to ColumnNodeCount -1 do
      begin
        for PatchRowIndex := 0 to PatchColumn.Count -1 do
        begin
          APatch := PatchColumn[PatchRowIndex];
          for RowNodeIndex := 0 to APatch.YCount  do
          begin
            ANode := APatch.GetNode(ColumnNodeIndex,RowNodeIndex);
            if NewNodeList.IndexOf(ANode) < 0 then
            begin
              NewNodeList.Add(ANode);
            end;
          end;

        end;

      end;

    end;
    Assert(FNodeList.Count = NewNodeList.Count);
    FNodeList.Free;
    FNodeList := NewNodeList;
  end;

end;

procedure TFishnet.ArrangeElementsInColumnList(ColumnList : TList);
var
  NewElementList : TList;
  PatchRowIndex, PatchColumnIndex : integer;
  PatchColumn : TList;
  APatch : TFishnetMeshPatch;
  ColumnElementCount : integer;
  RowElementIndex, ColumnElementIndex : integer;
  AnElement : TQuadElement;
begin
  if ColumnList.Count > 0 then
  begin
    NewElementList := TList.Create;
    NewElementList.Capacity := FElementList.Count;
    for PatchColumnIndex := 0 to ColumnList.Count -1 do
    begin
      PatchColumn := ColumnList[PatchColumnIndex];
      APatch := PatchColumn[0];
      ColumnElementCount := APatch.XCount;
      for ColumnElementIndex := 0 to ColumnElementCount -1 do
      begin
        for PatchRowIndex := 0 to PatchColumn.Count -1 do
        begin
          APatch := PatchColumn[PatchRowIndex];
          for RowElementIndex := 0 to APatch.YCount-1  do
          begin
            AnElement := APatch.GetElement(ColumnElementIndex,RowElementIndex);
            if NewElementList.IndexOf(AnElement) < 0 then
            begin
              NewElementList.Add(AnElement);
            end;
          end;

        end;

      end;

    end;
    Assert(FElementList.Count = NewElementList.Count);
    FElementList.Free;
    FElementList := NewElementList;
  end;

end;

procedure TFishnet.ArrangePatchesInColumns(ColumnList : TList);
var
  PatchColumn : TList;
  APatch, FirstPatch : TFishnetMeshPatch;
  NewPatchList : TList;
begin
  NewPatchList := TList.Create;
  NewPatchList.Capacity := FPatchList.Count;
  While FPatchList.Count > 0 do
  begin
    PatchColumn := TList.Create;
    ColumnList.Add(PatchColumn);
    APatch := FPatchList[0];

    NewPatchList.Add(APatch);
    FPatchList.Delete(0);

    PatchColumn.Add(APatch);
    FirstPatch := APatch;
    while (FirstPatch.NeighborToRight <> nil)
      and (FPatchList.IndexOf(FirstPatch.NeighborToRight) > -1) do
    begin
      while (APatch.NeighborBelow <> nil)
        and (FPatchList.IndexOf(APatch.NeighborBelow) > -1) do
      begin
        APatch := APatch.NeighborBelow;
        PatchColumn.Add(APatch);

        NewPatchList.Add(APatch);
        FPatchList.Remove(APatch);

      end;
      if (FPatchList.IndexOf(FirstPatch.NeighborToRight) > -1) then
      begin
        FirstPatch := FirstPatch.NeighborToRight;
        APatch := FirstPatch;
        PatchColumn := TList.Create;
        ColumnList.Add(PatchColumn);
        PatchColumn.Add(APatch);

        NewPatchList.Add(APatch);
        FPatchList.Remove(APatch);

      end;
    end;
    while (APatch.NeighborBelow <> nil)
      and (FPatchList.IndexOf(APatch.NeighborBelow) > -1) do
    begin
      APatch := APatch.NeighborBelow;
      PatchColumn.Add(APatch);

      NewPatchList.Add(APatch);
      FPatchList.Remove(APatch);

    end;
  end;
  FPatchList.Free;
  FPatchList := NewPatchList;
end;

procedure TFishnet.RearrangeNodesAndElements;
var
  ListOfRowsOrColumns, AList : TList;
  RowNodeN, ColumnNodeN : integer;
  Index : integer;
begin
  if FPatchList.Count > 1 then
  begin
      RowNodeN := RowNodeCount;
      ColumnNodeN := ColumnNodeCount;
      ListOfRowsOrColumns := TList.Create;
      try

        if RowNodeN > ColumnNodeN then
        begin
          ArrangePatchesInRows(ListOfRowsOrColumns);
          ArrangeNodesInRowList(ListOfRowsOrColumns);
          ArrangeElementsInRowList(ListOfRowsOrColumns);
        end
        else
        begin
          ArrangePatchesInColumns(ListOfRowsOrColumns);
          ArrangeNodesInColumnList(ListOfRowsOrColumns);
          ArrangeElementsInColumnList(ListOfRowsOrColumns);
        end;

      finally
        for Index := 0 to ListOfRowsOrColumns.Count -1 do
        begin
          AList := ListOfRowsOrColumns[Index];
          AList.Free;
        end;
        ListOfRowsOrColumns.Free;
      end;

  end;

end;


procedure TFishnet.CreatePatches;
var
  Index : integer;
  AContour : TFishnetContour;
begin
  FPatchList.Capacity := FContourList.Count;
  for Index := 0 to FContourList.Count -1 do
  begin
    AContour := FContourList[Index];
    FPatchList.Add(CreateAPatch(AContour));
  end;

end;

destructor TFishnet.Destroy;
var
  Index : integer;
begin
  for Index := 0 to FContourList.Count -1 do
  begin
    TFishnetContour(FContourList[Index]).Free;
  end;
  FContourList.Free;
  for Index := 0 to FPatchList.Count -1 do
  begin
    TFishnetMeshPatch(FPatchList[Index]).Free;
  end;
  FPatchList.Free;
  for Index := FNodeList.Count -1  downto 0 do
  begin
    TNode(FNodeList[Index]).Free;
  end;
  FNodeList.Free;
  FElementList.Free;
  inherited;
end;

function TFishnet.GetNode(X, Y: double): TNode;
Const
  Epsilon = 1e-8;
var
  Index : integer;
  ANode : TNode;
begin
  result := nil;
  for Index := 0 to FNodeList.Count -1 do
  begin
    ANode := FNodeList[Index];
    if NearlyTheSame(ANode.X,X,Epsilon) and NearlyTheSame(ANode.Y,Y,Epsilon) then
    begin
      result := ANode;
      break;
    end;
  end;

end;

procedure TFishnet.JoinPatches;
var
  OuterIndex, InnerIndex : integer;
  Patch1, Patch2 : TFishnetMeshPatch;
begin
  for OuterIndex := 0 to FPatchList.Count -2 do
  begin
    Patch1 := FPatchList[OuterIndex];
    for InnerIndex := OuterIndex +1 to FPatchList.Count -1 do
    begin
      Patch2 := FPatchList[InnerIndex];
      SetNeighbors(Patch1,Patch2);
{      if SetNeighbors(Patch1,Patch2) then
      begin
        ShowMessage(IntToStr(OuterIndex) + '; ' + IntToStr(InnerIndex));
      end;  }  
    end;
  end;
end;

procedure TFishnet.SetCounts;
var
  Index : integer;
  APatch : TFishnetMeshPatch;
begin
  for Index := 0 to FPatchList.Count -1 do
  begin
    APatch := FPatchList[Index];
    if APatch.FNeighborBelow <> nil then
    begin
      APatch.FNeighborBelow.XCount := APatch.XCount;
    end;
    if APatch.FNeighborAbove <> nil then
    begin
      APatch.FNeighborAbove.XCount := APatch.XCount;
    end;
    if APatch.FNeighborToRight <> nil then
    begin
      APatch.FNeighborToRight.YCount := APatch.YCount;
    end;
    if APatch.FNeighborToLeft <> nil then
    begin
      APatch.FNeighborToLeft.YCount := APatch.YCount;
    end;
  end;

end;

function TFishnet.SetNeighbors(Patch1, Patch2: TFishnetMeshPatch) : boolean;
var
  FoundNeighbor : boolean;
{begin
  result := Patch1.SetNeighborIfNeighbor(Patch2);
end;}
  procedure  SetNeighbor;
  begin
    if not FoundNeighbor and
       SameLocations(Patch1.UpperLeftVertex, Patch2.LowerLeftVertex) and
       SameLocations(Patch1.UpperRightVertex, Patch2.LowerRightVertex) then
    begin
      if (Patch1.NeighborAbove <> nil) or (Patch2.NeighborBelow <> nil) then
      begin
        if (Patch1.NeighborAbove = nil) then
        begin
          Patch1.RotateCW;
          Patch1.resetRotation;
          FoundNeighbor := SetNeighbors(Patch1, Patch2);
          Assert(FoundNeighbor);
        end
        else
        begin
          Patch2.RotateCW;
          Patch2.resetRotation;
          FoundNeighbor := SetNeighbors(Patch1, Patch2);
          Assert(FoundNeighbor);
        end;
{        Patch1.SwitchCounts;
        Patch1.resetRotation;
        FoundNeighbor := SetNeighbors(Patch1, Patch2);
        Assert(FoundNeighbor);}
      end
      else
      begin
        Patch1.SetNeighborAbove(Patch2);
        FoundNeighbor := True;
      end;
    end;

    if not FoundNeighbor and
       SameLocations(Patch2.UpperLeftVertex, Patch1.LowerLeftVertex) and
       SameLocations(Patch2.UpperRightVertex, Patch1.LowerRightVertex) then
    begin
      if (Patch2.NeighborAbove <> nil) or (Patch1.NeighborBelow <> nil) then
      begin
        if (Patch2.NeighborAbove = nil) then
        begin
          Patch2.RotateCW;
          Patch2.resetRotation;
          FoundNeighbor := SetNeighbors(Patch1, Patch2);
          Assert(FoundNeighbor);
        end
        else
        begin
          Patch1.RotateCW;
          Patch1.resetRotation;
          FoundNeighbor := SetNeighbors(Patch1, Patch2);
          Assert(FoundNeighbor);
        end;
{       Patch2.SwitchCounts;
        Patch2.resetRotation;
        FoundNeighbor := SetNeighbors(Patch1, Patch2);
        Assert(FoundNeighbor);}
      end
      else
      begin
        Patch2.SetNeighborAbove(Patch1);
        FoundNeighbor := True;
      end;
    end;

    if not FoundNeighbor and
       SameLocations(Patch1.UpperLeftVertex, Patch2.UpperRightVertex) and
       SameLocations(Patch1.LowerLeftVertex, Patch2.LowerRightVertex) then
    begin
      if (Patch1.NeighborToLeft <> nil) or (Patch2.NeighborToRight <> nil) then
      begin
        if (Patch1.NeighborToLeft = nil) then
        begin
          Patch1.RotateCW;
          Patch1.resetRotation;
          FoundNeighbor := SetNeighbors(Patch1, Patch2);
          Assert(FoundNeighbor);
        end
        else
        begin
          Patch2.RotateCW;
          Patch2.resetRotation;
          FoundNeighbor := SetNeighbors(Patch1, Patch2);
          Assert(FoundNeighbor);
        end;
{        Patch1.SwitchCounts;
        Patch1.resetRotation;
        FoundNeighbor := SetNeighbors(Patch1, Patch2);
        Assert(FoundNeighbor);}
      end
      else
      begin
        Patch1.SetNeighborToLeft(Patch2);
        FoundNeighbor := True;
      end;
    end;

    if not FoundNeighbor and
       SameLocations(Patch2.UpperLeftVertex, Patch1.UpperRightVertex) and
       SameLocations(Patch2.LowerLeftVertex, Patch1.LowerRightVertex) then
    begin
      if (Patch2.NeighborToLeft <> nil) or (Patch1.NeighborToRight <> nil) then
      begin
        if (Patch2.NeighborToLeft = nil) then
        begin
          Patch2.RotateCW;
          Patch2.resetRotation;
          FoundNeighbor := SetNeighbors(Patch1, Patch2);
          Assert(FoundNeighbor);
        end
        else
        begin
          Patch1.RotateCW;
          Patch1.resetRotation;
          FoundNeighbor := SetNeighbors(Patch1, Patch2);
          Assert(FoundNeighbor);
        end;
{       Patch2.SwitchCounts;
        Patch2.resetRotation;
        FoundNeighbor := SetNeighbors(Patch1, Patch2);
        Assert(FoundNeighbor);}
      end
      else
      begin
        Patch2.SetNeighborToLeft(Patch1);
        FoundNeighbor := True;
      end;
    end;
  end;
begin
  FoundNeighbor := False;
  SetNeighbor;

  if not FoundNeighbor and
     SameLocations(Patch1.UpperRightVertex, Patch2.LowerLeftVertex) and
     SameLocations(Patch1.LowerRightVertex, Patch2.LowerRightVertex) then
  begin
    if Patch2.NeighborBelow = nil then
    begin
      Patch2.RotateCW;
      Patch2.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end
    else
    begin
      Patch1.RotateCCW;
      Patch1.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end;
  end;

  if not FoundNeighbor and
     SameLocations(Patch2.UpperRightVertex, Patch1.LowerLeftVertex) and
     SameLocations(Patch2.LowerRightVertex, Patch1.LowerRightVertex) then
  begin
    if Patch2.NeighbortoRight = nil then
    begin
      Patch2.RotateCCW;
      Patch2.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end
    else
    begin
      Patch1.RotateCW;
      Patch1.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end;
  end;

  if not FoundNeighbor and
     SameLocations(Patch1.UpperLeftVertex, Patch2.LowerRightVertex) and
     SameLocations(Patch1.UpperRightVertex, Patch2.UpperRightVertex) then
  begin
    if Patch2.NeighborToRight = nil then
    begin
      Patch2.RotateCW;
      Patch2.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end
    else
    begin
      Patch1.RotateCCW;
      Patch1.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end;
  end;

  if not FoundNeighbor and
     SameLocations(Patch2.UpperLeftVertex, Patch1.LowerRightVertex) and
     SameLocations(Patch2.UpperRightVertex, Patch1.UpperRightVertex) then
  begin
    if Patch2.NeighborAbove = nil then
    begin
      Patch2.RotateCCW;
      Patch2.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end
    else
    begin
      Patch1.RotateCW;
      Patch1.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end;
  end;





  if not FoundNeighbor and
     SameLocations(Patch1.UpperLeftVertex, Patch2.LowerRightVertex) and
     SameLocations(Patch1.LowerLeftVertex, Patch2.LowerLeftVertex) then
  begin
    if Patch2.NeighborBelow = nil then
    begin
      Patch2.RotateCCW;
      Patch2.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end
    else
    begin
      Patch1.RotateCW;
      Patch1.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end;
  end;

  if not FoundNeighbor and
     SameLocations(Patch2.UpperLeftVertex, Patch1.LowerRightVertex) and
     SameLocations(Patch2.LowerLeftVertex, Patch1.LowerLeftVertex) then
  begin
    if Patch2.NeighborToLeft = nil then
    begin
      Patch2.RotateCW;
      Patch2.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end
    else
    begin
      Patch1.RotateCCW;
      Patch1.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end;
  end;

  if not FoundNeighbor and
     SameLocations(Patch1.UpperRightVertex, Patch2.LowerLeftVertex) and
     SameLocations(Patch1.UpperLeftVertex, Patch2.UpperLeftVertex) then
  begin
    if Patch2.NeighborToLeft = nil then
    begin
      Patch2.RotateCCW;
      Patch2.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end
    else
    begin
      Patch1.RotateCW;
      Patch1.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end;
  end;

  if not FoundNeighbor and
     SameLocations(Patch2.UpperRightVertex, Patch1.LowerLeftVertex) and
     SameLocations(Patch2.UpperLeftVertex, Patch1.UpperLeftVertex) then
  begin
    if Patch1.NeighborAbove = nil then
    begin
      Patch2.RotateCW;
      Patch2.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end
    else
    begin
      Patch1.RotateCCW;
      Patch1.resetRotation;
      SetNeighbor;
      Assert(FoundNeighbor);
    end;
  end;

  result := FoundNeighbor;
end;



{ TElementCenterVertex }

constructor TElementCenterVertex.Create(AnElement: TQuadElement);
begin
  FElement := AnElement;
end;

function TElementCenterVertex.GetX: double;
var
  Index  : integer;
  ANode : TNode;
begin
  result := 0;
  for Index := 0 to FElement.NodeCount -1 do
  begin
    ANode := FElement.Nodes[Index];
    result := result + ANode.X;
  end;
  if FElement.NodeCount > 0 then
  begin
    result := result/FElement.NodeCount;
  end;
end;

function TElementCenterVertex.GetY: double;
var
  Index  : integer;
  ANode : TNode;
begin
  result := 0;
  for Index := 0 to FElement.NodeCount -1 do
  begin
    ANode := FElement.Nodes[Index];
    result := result + ANode.Y;
  end;
  if FElement.NodeCount > 0 then
  begin
    result := result/FElement.NodeCount;
  end;
end;

{ TNeighborHood }

constructor TNeighborHood.Create(CenterNode : TNode);
begin
  inherited Create;
  FCenterVertex := CenterNode;
  FVertexList := TList.Create;
end;

destructor TNeighborHood.Destroy;
begin
  FVertexList.Free;
  inherited;
end;

procedure TNeighborHood.TrimSegment(var ASegment : TSegment);
var
  Index : integer;
  AnElemVertex, AnotherElemVertex : TElementCenterVertex;
  AVertex, AnotherVertex, BoundaryVertex : TVertex;
  IntersectionCheck : boolean;
  FoundIntersection : boolean;
  FirstVertexOK : boolean;
  BoundarySegment, NewSegment : TSegment;
begin
  BoundaryVertex := nil;
  FirstVertexOK := IsPointInside(ASegment.FirstVertex);
  // There is no point on the boundary if either both verticies are inside
  // or both are outside so quit.
  if FirstVertexOK = IsPointInside(ASegment.SecondVertex) then Exit;

  AnElemVertex := FVertexList[0];
  FVertexList.Add(AnElemVertex);
  BoundaryVertex := TVertex.Create;
  Try
    try // try 1
      FoundIntersection := False;
      for Index := 0 to FVertexList.Count -2 do
      begin
        AnElemVertex := FVertexList[Index];
        AnotherElemVertex := FVertexList[Index+1];
        AVertex := TVertex.Create;
        AnotherVertex := TVertex.Create;
        try
          AVertex.X := AnElemVertex.X;
          AVertex.Y := AnElemVertex.Y;
          AnotherVertex.X := AnotherElemVertex.X;
          AnotherVertex.Y := AnotherElemVertex.Y;
          BoundarySegment := TSegment.Create(AVertex,AnotherVertex);
          try // try 2
            IntersectionCheck := ASegment.Intersection(BoundarySegment,BoundaryVertex);
            if IntersectionCheck then
            begin
              BoundarySegment.Free;
              BoundarySegment := nil;
              FoundIntersection := True;
              break;
            end; // if result then
          finally // try 2
            BoundarySegment.Free;
          end; // try 2
        finally
          AVertex.Free;
          AnotherVertex.Free;
        end;
      end; // for Index := 0 to FVertexList.Count -2 do
    finally // try 1
      FVertexList.Delete(FVertexList.Count -1);
  //    ResultVertex.Free;
    end; // try 1

    Assert(FoundIntersection);
    if FirstVertexOK then
    begin
      NewSegment := TSegment.Create(ASegment.FirstVertex,BoundaryVertex);
    end
    else
    begin
      NewSegment := TSegment.Create(BoundaryVertex,ASegment.SecondVertex);
    end;
    ASegment.Free;
    ASegment := NewSegment;
  except
    begin
      BoundaryVertex.Free;
      raise;
    end
  end;
end;

function TNeighborHood.DoesSegmentCrossNeighborhood(ASegment : TSegment)
  : boolean;
var
  BoundarySegment : TSegment;
  Index : integer;
  AnElemVertex, AnotherElemVertex : TElementCenterVertex;
  AVertex, AnotherVertex : TVertex;
  ResultVertex : TVertex;
begin
  result := IsPointInside(ASegment.FirstVertex)
    or IsPointInside(ASegment.SecondVertex);
  if not result then
  begin
    AnElemVertex := FVertexList[0];
    FVertexList.Add(AnElemVertex);
    ResultVertex := TVertex.Create;
    try // try 1
      for Index := 0 to FVertexList.Count -2 do
      begin
        AnElemVertex := FVertexList[Index];
        AnotherElemVertex := FVertexList[Index+1];
        AVertex := TVertex.Create;
        AnotherVertex := TVertex.Create;
        try
          AVertex.X := AnElemVertex.X;
          AVertex.Y := AnElemVertex.Y;
          AnotherVertex.X := AnotherElemVertex.X;
          AnotherVertex.Y := AnotherElemVertex.Y;
          BoundarySegment := TSegment.Create(AVertex,AnotherVertex);
          try // try 2
            result := ASegment.Intersection(BoundarySegment,ResultVertex);
            if result then
            begin
              BoundarySegment.Free;
              BoundarySegment := nil;
              break;
            end; // if result then
          finally // try 2
            BoundarySegment.Free;
          end; // try 2
        finally
          AVertex.Free;
          AnotherVertex.Free;
        end;
      end; // for Index := 0 to FVertexList.Count -2 do
    finally // try 1
      FVertexList.Delete(FVertexList.Count -1);
      ResultVertex.Free;
    end; // try 1
  end; //if not result then
end;

function TNeighborHood.IsPointInside(VertexToCheck: TVertex): boolean;
var
  VertexIndex : integer;
  AVertex, AnotherVertex : TElementCenterVertex;
begin   // based on CACM 112
  AVertex := FVertexList.Items[0];
  FVertexList.Add(AVertex);
  result := true;
  For VertexIndex := 0 to FVertexList.Count -2 do
  begin
    AVertex := FVertexList[VertexIndex];
    AnotherVertex := FVertexList[VertexIndex+1];
    if ((VertexToCheck.Y <= AVertex.Y) = (VertexToCheck.Y > AnotherVertex.Y)) and
       (VertexToCheck.X - AVertex.X - (VertexToCheck.Y - AVertex.Y) *
         (AnotherVertex.X - AVertex.X)/
         (AnotherVertex.Y - AVertex.Y) < 0) then
      begin
        result := not result;
      end;
  end;
  result := not result;
  FVertexList.Delete(FVertexList.Count -1);
end;

procedure TNeighborHood.MoveCenterToContour(AContour: TBoundaryContour;
  UpperCriticalAngle, LowerCriticalAngle: double);
var
  NearestPoint : TVertex;
  TempX, TempY : double;
  AQuadElement : TQuadElement;
  Index : integer;
begin
  if not FCenterVertex.Moved then
  begin
    NearestPoint := nil;
    NearestPointOnContourToCenter(AContour, NearestPoint);
    if NearestPoint <> nil then
    begin
      TempX := FCenterVertex.X;
      TempY := FCenterVertex.Y;
      FCenterVertex.X := NearestPoint.X;
      FCenterVertex.Y := NearestPoint.Y;
      FCenterVertex.Moved := True;
      for Index := 0 to FCenterVertex.FElementList.Count -1 do
      begin
        AQuadElement := FCenterVertex.FElementList[Index];
        if not AQuadElement.ElementShapeIsOK
          (UpperCriticalAngle, LowerCriticalAngle) then
        begin
          FCenterVertex.X := TempX;
          FCenterVertex.Y := TempY;
          FCenterVertex.Moved := False;
          break;
        end;
      end;
      NearestPoint.Free;
    end;
  end;
end;

procedure TNeighborHood.NearestPointOnContourToCenter(
  AContour: TBoundaryContour; var resultVertex: TVertex);
var
  Index : integer;
  AVertex : TVertex;
  ASegment : TSegment;
//  FirstVertexOK : boolean;
begin
  resultVertex.Free;
  resultVertex := nil;
  if AContour.VertexCount = 1 then
  begin
    AVertex := AContour.Verticies[0];
    if IsPointInside(AVertex) then
    begin
      resultVertex := AVertex.Copy;
    end;
  end
  else
  begin
    for Index := 0 to AContour.VertexCount -2 do
    begin
      ASegment := TSegment.Create
        (AContour.Verticies[Index],AContour.Verticies[Index+1]);
      TrimSegment(ASegment);
      try
        if DoesSegmentCrossNeighborhood(ASegment) then
        begin
          AVertex := TVertex.Create;
          NearestPointOnSegmentToCenter(ASegment, AVertex);
          Assert(AVertex <> nil);
          if (resultVertex = nil) or
            (FCenterVertex.DistanceToVertex(resultVertex) >
             FCenterVertex.DistanceToVertex(AVertex)) then
          begin
            resultVertex.Free;
            resultVertex := AVertex;
            if (Index = 0) and IsPointInside(AContour.Verticies[0]) then
            begin
              resultVertex.Free;
              resultVertex := AContour.Verticies[0].Copy;
            end;
            if (Index = AContour.VertexCount-2) and
              IsPointInside(AContour.Verticies[AContour.VertexCount-1]) then
            begin
              resultVertex.Free;
              resultVertex := AContour.Verticies[AContour.VertexCount-1].Copy;
            end;
          end
          else
          begin
            AVertex.Free;
          end;
        end;
      finally
        ASegment.Free;
      end;
    end;
  end;
end;

procedure TNeighborHood.NearestPointOnSegmentToCenter(ASegment : TSegment;
  var resultVertex: TVertex);
var
  AVertex : TVertex;
  PerpendicularSegment : TSegment;
  procedure NearestEndPoint;
  begin
    if FCenterVertex.DistanceToVertex(ASegment.FirstVertex) <
       FCenterVertex.DistanceToVertex(ASegment.SecondVertex) then
    begin
      resultVertex.X := ASegment.FirstVertex.X;
      resultVertex.Y := ASegment.FirstVertex.Y;
    end
    else
    begin
      resultVertex.X := ASegment.SecondVertex.X;
      resultVertex.Y := ASegment.SecondVertex.Y;
    end;
{    if not IsPointInside(resultVertex) then
    begin
      resultVertex.Free;
      resultVertex := nil;
    end;  }
  end;
begin
  if ASegment.IsVertical then
  begin
    resultVertex.X := ASegment.FirstVertex.X;
    resultVertex.Y := FCenterVertex.Y;
    if not ASegment.VertexWithinExtents(resultVertex) then
    begin
      NearestEndPoint;
    end;
  end
  else if ASegment.IsHorizontal then
  begin
    resultVertex.X := FCenterVertex.X;
    resultVertex.Y := ASegment.FirstVertex.Y;
    if not ASegment.VertexWithinExtents(resultVertex) then
    begin
      NearestEndPoint;
    end;
  end
  else
  begin
    AVertex := TVertex.Create;
    AVertex.X := FCenterVertex.X * 10 + 1;
    AVertex.Y := -1/ASegment.Slope * AVertex.X + FCenterVertex.Y;
    try
      begin
        PerpendicularSegment := TSegment.Create(AVertex, FCenterVertex);
        try
          ASegment.Intersection(PerpendicularSegment,resultVertex);
          if not ASegment.VertexWithinExtents(resultVertex) then
          begin
            NearestEndPoint;
          end;
        finally
          PerpendicularSegment.Free;
        end;
      end
    finally
      AVertex.Free;
    end;
  end;
end;

{ TMesh }

procedure TMesh.AdjustMesh(AContour: TBoundaryContour; UpperCriticalAngle,
  LowerCriticalAngle: double);
var
  Index : integer;
  ANode : TNode;
  ANeighborHood : TNeighborHood;
begin
  for Index := 0 to FNodeList.Count -1 do
  begin
    ANode := FNodeList[Index];
    ANeighborHood := ANode.Neighborhood;
    if ANeighborHood <> nil then
    begin
      ANeighborHood.MoveCenterToContour(AContour,
        UpperCriticalAngle, LowerCriticalAngle);
    end;
  end;
end;

constructor TMesh.Create;
begin
  inherited Create;
  FNodeList := TList.Create;
  FElementList := TList.Create;
end;

procedure TMesh.CreateMesh(MeshString: string);
  function GetNextNumberString(var AString : String) : string;
  const
    BlankSpace = ' ';
  var
    SpacePosition : integer;
  begin
    AString := Trim(AString);
    SpacePosition := Pos(BlankSpace,AString);
    if SpacePosition > 0 then
    begin
      Result := Copy(AString,1,SpacePosition-1);
      AString := Copy(AString,SpacePosition+1,Length(AString));
    end
    else
    begin
      Result := AString;
      AString := '';
    end
  end;
var
  AStringList : TStringList;
  LineIndex : integer;
  AString : String;
//  SpacePosition : integer;
  ANode, Node1, Node2, Node3, Node4 : TNode;
  NodeIndex : integer;
//  AnElement : TQuadElement;
begin
  AStringList := TStringList.Create;
  try
    AStringList.Text := MeshString;
    for LineIndex := 0 to AStringList.Count -1 do
    begin
      AString := AStringList[LineIndex];
      if (Length(AString) > 0) then
      begin
        if (AString[1] = 'N') then
        begin
          AString := Trim(Copy(AString, 2, Length(AString)));
          ANode := TNode.Create(FNodeList, self);
          GetNextNumberString(AString);
          ANode.X := StrToFloat(GetNextNumberString(AString));
          ANode.Y := StrToFloat(GetNextNumberString(AString));
        end
        else
        if AString[1] = 'E' then
        begin
          AString := Trim(Copy(AString, 2, Length(AString)));
          GetNextNumberString(AString);
          NodeIndex := StrToInt(GetNextNumberString(AString))-1;
          Node1 := FNodeList[NodeIndex];
          NodeIndex := StrToInt(GetNextNumberString(AString))-1;
          Node2 := FNodeList[NodeIndex];
          NodeIndex := StrToInt(GetNextNumberString(AString))-1;
          Node3 := FNodeList[NodeIndex];
          NodeIndex := StrToInt(GetNextNumberString(AString))-1;
          Node4 := FNodeList[NodeIndex];
          {AnElement := }TQuadElement.Create(self, FElementList, Node1, Node2, Node3, Node4);
        end;
      end;
    end;

  finally
    AStringList.Free;
  end;


end;

procedure TMesh.WriteMesh(MeshStrings: TStrings);
var
  Index: integer;
  ANode : TNode;
  AnElement : TQuadElement;
begin
  MeshStrings.Clear;
  MeshStrings.Add(IntToStr(FElementList.Count) + Chr(9) +
    IntToStr(FNodeList.Count) + Chr(9) + '0' + Chr(9) + '0');
  MeshStrings.Add('');

  for Index := 0 to FNodeList.Count -1 do
  begin
    ANode := FNodeList[Index];
    MeshStrings.Add(ANode.NodeString);
  end;

  for Index := 0 to FElementList.Count -1 do
  begin
    AnElement := FElementList[Index];
    MeshStrings.Add(AnElement.ElementString);
  end;
end;

end.
