unit NodeElementUnit;

interface

uses Classes, SysUtils, IntListUnit, VertexUnit, FishnetContourUnit,
  BoundaryContourUnit, SegmentUnit, Math;

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
  public
    FVertexList : TList;
    constructor Create(CenterNode : TNode);
    Destructor Destroy; override;
    function IsPointInside(VertexToCheck : TVertex) : boolean;
    function DoesSegmentCrossNeighborhood(ASegment : TSegment)
      : boolean;
    Procedure NearestPointOnSegmentToCenter(ASegment : TSegment;
      var resultVertex : TVertex);
    Procedure NearestPointOnContourToCenter(AContour :TBoundaryContour;
      var resultVertex : TVertex);
    procedure MoveCenterToContour(AContour :TBoundaryContour;
      UpperCriticalAngle, LowerCriticalAngle: double);
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
      procedure SwitchCounts;
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
      procedure SetNeighbors(Patch1, Patch2 : TFishnetMeshPatch);
      function SameLocations(Vertex1, Vertex2 : TVertex) : boolean;
      function GetNode(X, Y : double) : TNode;
      procedure SetCounts;
      procedure RearrangeNodes;
      procedure ArrangePatchesInColumns(ColumnList: TList);
      procedure ArrangePatchesInRows(RowList: TList);
      procedure ArrangeNodesInColumnList(ColumnList: TList);
      procedure ArrangeNodesInRowList(RowList: TList);
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
    FNeighborHood := TNeighborHood.Create(self);
    TempElementList := TList.Create;
    try
      for Index := 0 to FElementList.Count -1 do
      begin
        AnElement := FElementList[Index];
        TempElementList.Add(AnElement);
      end;
      if TempElementList.Count > 0 then
      begin
        AnElement := TempElementList[0];
        TempElementList.Delete(0);
        FNeighborHood.FVertexList.Add(AnElement.ElementCenterVertex);
        NodeList := TList.Create;
        try
          for Index := 0 to AnElement.FNodeList.Count -1 do
          begin
            ANode := AnElement.FNodeList[Index];
            if ANode <> self then
            begin
              NodeList.Add(ANode);
            end;
          end;
          while TempElementList.Count > 0 do
          begin
            Found := False;
            for Index := 0 to TempElementList.Count -1 do
            begin
              AnElement := TempElementList[Index];
              for InnerIndex := 0 to AnElement.FNodeList.Count - 1 do
              begin
                if NodeList.IndexOf(AnElement.FNodeList[InnerIndex]) > -1 then
                begin
                  TempElementList.Remove(AnElement);
                  FNeighborHood.FVertexList.Add(AnElement.ElementCenterVertex);
                  NodeList.Clear;
                  for InnerNodeIndex := 0 to AnElement.FNodeList.Count -1 do
                  begin
                    ANode := AnElement.FNodeList[InnerNodeIndex];
                    if ANode <> self then
                    begin
                      NodeList.Add(ANode);
                    end;
                  end;
                  Found := True;
                  break;
                end;
                if Found then
                begin
                  break;
                end;
              end;
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
  result := 'N' + Chr(9) + IntToStr(NodeNumber) + Chr(9) + FloatToStrF(X,ffGeneral,15,0)
    + Chr(9) + FloatToStrF(Y,ffGeneral,15,0);
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
  HighestVertex, AnotherVertex : TVertex;
  Index : integer;
begin
  // upper left at 0
  // upper right at 1
  // lower right at 2
  // lower left at 3
  TempList := TList.Create;
  TempList.Count := 4;
  HighestVertex := FVertexList[0];
  for Index := 1 to FVertexList.Count -1 do
  begin
    AnotherVertex := FVertexList[Index];
    if AnotherVertex.X > HighestVertex.X then
    begin
      HighestVertex := AnotherVertex;
    end;
  end;
  TempList[1] := HighestVertex;
  FVertexList.Remove(HighestVertex);

  HighestVertex := FVertexList[0];
  for Index := 1 to FVertexList.Count -1 do
  begin
    AnotherVertex := FVertexList[Index];
    if AnotherVertex.X > HighestVertex.X then
    begin
      HighestVertex := AnotherVertex;
    end;
  end;
  TempList[2] := HighestVertex;
  FVertexList.Remove(HighestVertex);

  if TVertex(TempList[1]).Y < TVertex(TempList[2]).Y then
  begin
    TempList.Exchange(1,2);
  end;

  HighestVertex := FVertexList[0];
  for Index := 1 to FVertexList.Count -1 do
  begin
    AnotherVertex := FVertexList[Index];
    if AnotherVertex.Y > HighestVertex.Y then
    begin
      HighestVertex := AnotherVertex;
    end;
  end;
  TempList[0] := HighestVertex;
  FVertexList.Remove(HighestVertex);
  TempList[3] := FVertexList[0];

  FVertexList.Free;
  FVertexList := TempList;
end;

constructor TFishnetMeshPatch.Create(Vertex1, Vertex2, Vertex3,
  Vertex4: TVertex; AnXCount, AYCount: integer);
begin
  FElementList := TList.Create;
  FNodeList := TList.Create;
  FVertexList := TList.Create;
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
    X, Y : double;
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
  FNeighborAbove := ANeighbor;
  ANeighbor.FNeighborBelow := self;
end;

procedure TFishnetMeshPatch.SetNeighborBelow(
  const ANeighbor: TFishnetMeshPatch);
begin
  FNeighborBelow := ANeighbor;
  ANeighbor.FNeighborAbove := self;
end;

procedure TFishnetMeshPatch.SetNeighborToLeft(
  const ANeighbor: TFishnetMeshPatch);
begin
  FNeighborToLeft := ANeighbor;
  ANeighbor.FNeighborToRight := self;
end;

procedure TFishnetMeshPatch.SetNeighborToRight(
  const ANeighbor: TFishnetMeshPatch);
begin
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

procedure TFishnetMeshPatch.SwitchCounts;
var
  temp : integer;
  ANeighbor : TFishnetMeshPatch;
begin
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
    ANeighbor := self.FNeighborAbove;
    FNeighborAbove := self.FNeighborToLeft;
    FNeighborToLeft := self.FNeighborBelow;
    FNeighborBelow := self.FNeighborToRight;
    FNeighborToRight := ANeighbor;
    FRotated := True;
    if (FNeighborAbove <> nil) and not (FNeighborAbove.FRotated) then
    begin
      FNeighborAbove.SwitchCounts;
    end;
    if (FNeighborToRight <> nil) and not (FNeighborToRight.FRotated) then
    begin
      FNeighborToRight.SwitchCounts;
    end;
    if (FNeighborBelow <> nil) and not (FNeighborBelow.FRotated) then
    begin
      FNeighborBelow.SwitchCounts;
    end;
    if (FNeighborToLeft <> nil) and not (FNeighborToLeft.FRotated) then
    begin
      FNeighborToLeft.SwitchCounts;
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
begin
  NewPatchList := TList.Create;
  TempPatchList := TList.Create;
  while FPatchList.Count > 0 do
  begin
    // set the first member of FPatchList to a patch that doesn't
    // have any neighbors above or to the right of it.
    for Index := 0 to FPatchList.Count -1 do
    begin
      APatch := FPatchList[Index];
      if (APatch.FNeighborAbove = nil) and (APatch.FNeighborToLeft = nil) then
      begin
        FPatchList.Delete(Index);
        FPatchList.Insert(0,APatch);
        break;
      end;
    end;
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
          FPatchList.Remove(APatch);
          FPatchList.Insert(0,APatch);
          FoundAbove := True;
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
          FPatchList.Remove(APatch);
          FPatchList.Insert(0,APatch);
          FoundAbove := True;
        end;
      end;
    until Not FoundAbove;

    // store a row of patches in FPatchList
    APatch := FPatchList[0];
    FirstPatchOnRow := APatch;
    FPatchList.Remove(APatch);
    TempPatchList.Add(APatch);
    while (APatch.FNeighborToRight <> nil)
      and (NewPatchList.IndexOf(APatch.FNeighborToRight) = -1) do
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
          foundBelow := True;
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
        FPatchList.Remove(APatch);
        TempPatchList.Add(APatch);
        while (APatch.FNeighborToRight <> nil)
          and (NewPatchList.IndexOf(APatch.FNeighborToRight) = -1) do
        begin
          APatch := APatch.FNeighborToRight;
          FPatchList.Remove(APatch);
          TempPatchList.Add(APatch);
        end;
      end;
    end;
    for Index := 0 to TempPatchList.Count -1 do
    begin
      NewPatchList.Add(TempPatchList[Index]);
    end;
    TempPatchList.Clear;
  end;
  FPatchList.Free;
  FPatchList := NewPatchList; 

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
  RearrangeNodes;
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
  APatch, FirstPatch : TFishnetMeshPatch;
begin
  PatchRow := TList.Create;
  RowList.Add(PatchRow);
  APatch := FPatchList[0];
  PatchRow.Add(APatch);
  FirstPatch := APatch;
  while FirstPatch.NeighborBelow <> nil do
  begin
    while APatch.FNeighborToRight <> nil do
    begin
      APatch := APatch.FNeighborToRight;
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
  end;
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

procedure TFishnet.ArrangePatchesInColumns(ColumnList : TList);
var
  PatchColumn : TList;
  APatch, FirstPatch : TFishnetMeshPatch;
begin
  PatchColumn := TList.Create;
  ColumnList.Add(PatchColumn);
  APatch := FPatchList[0];
  PatchColumn.Add(APatch);
  FirstPatch := APatch;
  while FirstPatch.NeighborToRight <> nil do
  begin
    while APatch.NeighborBelow <> nil do
    begin
      APatch := APatch.NeighborBelow;
      PatchColumn.Add(APatch);
    end;
    FirstPatch := FirstPatch.NeighborToRight;
    APatch := FirstPatch;
    PatchColumn := TList.Create;
    ColumnList.Add(PatchColumn);
    PatchColumn.Add(APatch);
  end;
  while APatch.NeighborBelow <> nil do
  begin
    APatch := APatch.NeighborBelow;
    PatchColumn.Add(APatch);
  end;
end;

procedure TFishnet.RearrangeNodes;
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
          ArrangeNodesInRowList(ListOfRowsOrColumns);;
        end
        else
        begin
          ArrangePatchesInColumns(ListOfRowsOrColumns);
          ArrangeNodesInColumnList(ListOfRowsOrColumns);
        end;

      finally
        for Index := 0 to ListOfRowsOrColumns.Count -1 do
        begin
          AList := ListOfRowsOrColumns[Index];
          AList.Free;
        end;
        ListOfRowsOrColumns.Free;
      end;






      //----------------------------------

  end;

end;


procedure TFishnet.CreatePatches;
var
  Index : integer;
  AContour : TFishnetContour;
begin
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
var
  Index : integer;
  ANode : TNode;
begin
  result := nil;
  for Index := 0 to FNodeList.Count -1 do
  begin
    ANode := FNodeList[Index];
    if (ANode.X = X) and (ANode.Y = Y) then
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
    end;
  end;
end;

function TFishnet.SameLocations(Vertex1, Vertex2: TVertex): boolean;
begin
  result := (Vertex1.X = Vertex2.X) and (Vertex1.Y = Vertex2.Y)
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

procedure TFishnet.SetNeighbors(Patch1, Patch2: TFishnetMeshPatch);
var
  FoundNeighbor : boolean;
  procedure  SetNeighbor;
  begin
    if not FoundNeighbor and
       SameLocations(Patch1.UpperLeftVertex, Patch2.LowerLeftVertex) and
       SameLocations(Patch1.UpperRightVertex, Patch2.LowerRightVertex) then
    begin
      Patch1.SetNeighborAbove(Patch2);
      FoundNeighbor := True;
    end;

    if not FoundNeighbor and
       SameLocations(Patch2.UpperLeftVertex, Patch1.LowerLeftVertex) and
       SameLocations(Patch2.UpperRightVertex, Patch1.LowerRightVertex) then
    begin
      Patch2.SetNeighborAbove(Patch1);
      FoundNeighbor := True;
    end;

    if not FoundNeighbor and
       SameLocations(Patch1.UpperLeftVertex, Patch2.UpperRightVertex) and
       SameLocations(Patch1.LowerLeftVertex, Patch2.LowerRightVertex) then
    begin
      Patch1.SetNeighborToLeft(Patch2);
      FoundNeighbor := True;
    end;

    if not FoundNeighbor and
       SameLocations(Patch2.UpperLeftVertex, Patch1.UpperRightVertex) and
       SameLocations(Patch2.LowerLeftVertex, Patch1.LowerRightVertex) then
    begin
      Patch2.SetNeighborToLeft(Patch1);
      FoundNeighbor := True;
    end;
  end;
begin
  FoundNeighbor := False;
  SetNeighbor;

  if not FoundNeighbor and
     SameLocations(Patch1.UpperRightVertex, Patch2.LowerLeftVertex) and
     SameLocations(Patch1.LowerRightVertex, Patch2.LowerRightVertex) then
  begin
    Patch2.SwitchCounts;
    Patch2.resetRotation;
    SetNeighbor;
  end;

  if not FoundNeighbor and
     SameLocations(Patch2.UpperRightVertex, Patch1.LowerLeftVertex) and
     SameLocations(Patch2.LowerRightVertex, Patch1.LowerRightVertex) then
  begin
    Patch1.SwitchCounts;
    Patch1.resetRotation;
    SetNeighbor;
  end;

  if not FoundNeighbor and
     SameLocations(Patch1.UpperLeftVertex, Patch2.LowerRightVertex) and
     SameLocations(Patch1.UpperRightVertex, Patch2.UpperRightVertex) then
  begin
    Patch2.SwitchCounts;
    Patch2.resetRotation;
    SetNeighbor;
  end;

  if not FoundNeighbor and
     SameLocations(Patch2.UpperLeftVertex, Patch1.LowerRightVertex) and
     SameLocations(Patch2.UpperRightVertex, Patch1.UpperRightVertex) then
  begin
    Patch1.SwitchCounts;
    Patch1.resetRotation;
    SetNeighbor;
  end;

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
      try
        if DoesSegmentCrossNeighborhood(ASegment) then
        begin
          AVertex := TVertex.Create;
          NearestPointOnSegmentToCenter(ASegment, AVertex);
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
    if not IsPointInside(resultVertex) then
    begin
      resultVertex.Free;
      resultVertex := nil;
    end;
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
  SpacePosition : integer;
  ANode, Node1, Node2, Node3, Node4 : TNode;
  NodeIndex : integer;
  AnElement : TQuadElement;
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
          AnElement := TQuadElement.Create(self, FElementList, Node1, Node2, Node3, Node4);
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
