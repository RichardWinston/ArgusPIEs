unit DelaunayUnit;

{
References:

de Berg, Mark; van Kreveld, Mark; Overmars, Mark; Schwarzkopf, Otfried.
  2000. Computational Geometry, Algorithms and Applications. Second Edition.
  Springer, Berlin. 367 p.

Edelsbrunner, Herbert. 2001. Geometry and Topology for Mesh Generation.
  Cambridge University Press, Cambridge, 177 p.

The algorithm used here is primarily based on chapter 9 of de Berg and others.  
}

// turning off assertions appears to have little effect on speed.

{$ASSERTIONS ON}

interface

uses Classes, Contnrs, Determ, SysUtils, TurnDir;

type
  TInTriangle = (tiOutside, tiOnEdge, tiInside);

  TTopTriangle = class;

  TTriangle = class(TObject)
  private
    Children : TList;
    FNodes : array[0..2] of THullPoint; // Nodes are in clockwise order.
    Neighbors : array[0..2] of TTriangle;
    // Nodes and Neighbors are in the same order such that
    // each Neighbor is on the edge opposite the corresponding node
    // and the next node;
    Position : integer; // The position of the triangle in Triangulation
    // during computation of the Delaunay triangulation.
    // However, the final step in computing the triangulation packs the
    // Triangulation list so that Position is no longer valid.
    Top : TTopTriangle; // The owner of the TTriangle.
    HasTopPoint2 : boolean;
    function GetNeighbor(const APoint : THullPoint) : TTriangle;
    // GetNeighbor returns the neighbor opposite APoint and the point
    // following APoint.
    function GetNode(const Index : integer) : THullPoint;
    // GetNode returns FNodes[Index];
    function InCircle(const APoint : THullPoint) : boolean;
    // InCircle returns true of APoint is inside the circle defined by the
    // corners of the triangle.
    procedure LegalizeEdge(const Point: THullPoint;
      const Edge : array of THullPoint; const Triangulation : TList);
    // Input:
    // Point is a THullPoint that has recently been added to the
    //   triangulation in a neighboring triangle.  Adding the point may may
    //   make the triangulation not a Delaunay triangulation.
    // Edge is a pair of THullPoint's in the triangle that are opposite
    //   Point. The points in Edge are in clockwise order for this triangle.
    //
    // If the triangulation can be improved by an edge flip,
    // two new triangles are created and added to the triangulation while
    // this triangle and it's neighbor containing Point are removed from the
    // triangulation.
    // The new triangles are added to the Children of both this triangle
    // and it's neighbor.
    function OppositePoint(const Edge : array of THullPoint) : THullPoint;
    // Input: Edge is a pair of THullPoint's in the triangle. The order of the
    // points doesn't matter.
    procedure ReplaceNeighbor(const OldNeighbor, NewNeighbor : TTriangle);
    // ReplaceNeighbor finds OldNeighbor in the array of neighbors and
    // replaces it with NewNeighbor.
    Procedure Split(const APoint : THullPoint; const Triangulation : TList);
    // Input: APoint is a THullPoint that is strictly inside the current
    // triangle.  The triangle is broken into three children.  The
    // Children are added to the triangulation and the current triangle
    // is removed from the triangulation.
    // Legalize edge is called as needed to make the triangulation a Delaunay
    // triangulation.
    Procedure Split4(const APoint : THullPoint; const Triangulation : TList;
      const Edge : integer);
    // Input: APoint is a THullPoint that is strictly on the edge of the current
    // triangle.  The triangle and it's neighbor (if any) are each broken into
    // two children.  The
    // Children are added to the triangulation and the current triangle
    // is removed from the triangulation.
    // Legalize edge is called as needed to make the triangulation a Delaunay
    // triangulation.
  protected
    Procedure GetTriangles(const APoint: THullPoint; const Triangles : TList);
    // GetTriangles adds all the triangles that contain APoint and
    // do not have children to Triangles.  Some of the triangles may not
    // be part of the Delaunay triangulation.
    // See HasTopPoint.
  public
    Constructor Create(const Owner: TTopTriangle);
    Destructor Destroy; override;
    procedure GetPointLocation(const APoint: THullPoint;
      out PointLocation: TInTriangle; out Edge : integer);
    // GetPointLocation determines whether APoint is inside, outside, or
    // on the edge of the triangle.  If it is on the edge, Edge indicates
    // which edge it is on.
    function HasTopPoint : boolean;
    // return true if one of the points of the triangle is also a point
    // of the top (artificial) triangle.
    // The function also sets HasTopPoint2 which is used in LegalizeEdge.
    // If HasTopPoint returns true, the triangle is not part of the Delaunay
    // triangualation.
    property Nodes[const Index: integer] : THullPoint read GetNode;
    // Nodes is an array[0..2] of THullPoint that define the corners of the
    // the triangle.
  end;

  TTopTriangle = class(TTriangle)
  private
    OwnedTriangles : TObjectList;
  public
    procedure Clear;
    // Clear frees all the TTriangles owned by TTopTriangle
    constructor Create;
    Procedure Delaunay(const Points, Triangulation : TList);
    // Input : Points is a list of THullPoint's.
    // Output : Triangulation is a List of TTriangle's defining the
    //   Delaunay triangulation of the THullPoint's in Points.
    // The number of Points in Points must be greater than 2.
    // If there was a prior call to Delaunay, any triangles created during it
    // are destroyed.
    destructor Destroy; override;
    Procedure GetTriangles(const APoint: THullPoint; const Triangles : TList);
    // GetTriangles adds all the triangles that contain APoint and
    // do not have children to Triangles.  Some of the triangles may not
    // be part of the Delaunay triangulation.
    // See HasTopPoint.
  end;

implementation

//uses Math, Unit1;

{ TTriangle }

constructor TTriangle.Create(const Owner: TTopTriangle);
begin
  inherited Create;
  Position := -1;
  Children := TList.Create;
  Top := Owner;
  if Top.OwnedTriangles <> nil then
  begin
    Top.OwnedTriangles.Add(self)
  end;
end;

destructor TTriangle.Destroy;
begin
  Children.Free;
  inherited;
end;

function TTriangle.GetNeighbor(const APoint: THullPoint): TTriangle;
Var
  Index: Integer;
  function TestValidity(const Neighbor : TTriangle) : boolean;
  // TestValidity tests that the result of the function is correct.
  // This function can be disabled by turning off assertions.
  var
    i, i2, i3 : integer;
  begin
    result := True;
    if Neighbor = nil then Exit;
    for i := 0 to 2 do
    begin
      if Neighbor.Nodes[i] = APoint then
      begin
        i2 := I-1;
        if i2 = -1 then
        begin
          I2 := 2;
        end;

        result := (Neighbor.Neighbors[I2] = self);
        if not result then Exit;
        i3 := Index + 1;
        if i3 = 3 then
        begin
          i3 := 0;
        end;
        result := (Neighbor.Nodes[i2] = self.nodes[i3]);
        Exit;
      end
    end;
    result := false;
  end;
begin
  result := nil;
  for Index := 0 to 2 do
  begin
    if Nodes[Index] = APoint then
    begin
      result := Neighbors[Index];
      Assert(TestValidity(result));
    end;
  end;
end;

function TTriangle.InCircle(const APoint: THullPoint): boolean;
var
  arr : TDetArray;
  Index : integer;
  ANode : THullPoint;
begin
// returns true if APoint is inside the circle defined by the nodes of the
// triangle. See chapter 1.4 of Edelsbrunner (2001).
  assert(APoint <> nil);
  setLength(arr, 4, 4);
  for Index := 0 to 2 do
  begin
    ANode := Nodes[index];
    arr[Index,0] := 1;
    arr[Index,1] := ANode.X;
    arr[Index,2] := ANode.Y;
    arr[Index,3] := Sqr(ANode.X) + Sqr(ANode.Y);
  end;
  arr[3,0] := 1;
  arr[3,1] := APoint.X;
  arr[3,2] := APoint.Y;
  arr[3,3] := Sqr(APoint.X) + Sqr(APoint.Y);
  result := Determinant(arr,3) * Determinant(arr,4) < 0;
end;

procedure TTriangle.LegalizeEdge(const Point: THullPoint;
  const Edge : array of THullPoint;
  const Triangulation: TList);
Var
  Neighbor : TTriangle;
  Index : Integer;
  OpPoint : THullPoint;
  Child1, Child2 : TTriangle;
  TopCount : integer;
  IsIllegal : boolean;
  EdgeIndex : integer;
  PointIndex : integer;
  DirectionTestList : TList;
  function VerifyEdge : boolean;
  // check that both edges are part of the triangle
  // and in the right direction.
  var
    Index : integer;
    E1, E2 : integer;
  begin
    E1 := -2;
    E2 := -2;
    for Index := 0 to 2 do
    begin
      If Nodes[Index] = Edge[0] then
      begin
        E1 := Index;
      end;
      If Nodes[Index] = Edge[1] then
      begin
        E2 := Index;
      end;
    end;
    if E2 = 0 then
    begin
      E2 := 3;
    end;
    result := (E2-E1=1);
  end;
begin
  // Point is the newly added point of another triangle
  // Edge is the edge of this triangle that we need to check.
  // Edge should be in clockwise direction for this triangle.
  Assert(Point <> nil);
  Assert (Triangulation <> nil);
  Assert(Point <> Edge[0]);
  Assert(Point <> Edge[1]);
  Assert(VerifyEdge);
  // if flipping edges has already removed this triangle from the
  // triangulation, skip it.
  if (Children.Count > 0) then Exit;

  // count the number of points in the edge on the outermost triangle
  // and record the position of one of them.
  EdgeIndex := -1;
  TopCount := 0;
  for Index := 0 to 2 do
  begin
    if Top.Nodes[Index] = Edge[0] then
    begin
      Inc(TopCount);
      EdgeIndex := Index;
    end;
    if Top.Nodes[Index] = Edge[1] then
    begin
      Inc(TopCount);
      EdgeIndex := Index;
    end;
  end;

  // if both points are on the edge of the outermost triangle, exit.
  If TopCount = 2 then Exit;

  // Get the neighbor on the opposite side of the edge.
  Neighbor := GetNeighbor(Edge[0]);
  if Neighbor <> nil then
  begin
    Assert(Neighbor.Children.Count = 0);

    // get the point that is opposite the edge.
    OpPoint := OppositePoint(Edge);
    // see if the either the newly added point or the opposite point belong
    // to the outermost triangle. Count them if so.
    // and record the position of one of them.  (Only one can be in the top
    // triangle.)
    PointIndex := -1;
    for Index := 0 to 2 do
    begin
      if Top.Nodes[Index] = Point then
      begin
        Inc(TopCount);
        PointIndex := Index;
        {$IFOPT c-}
        Break;
        {$ENDIF}
      end;
      if Top.Nodes[Index] = OpPoint then
      begin
        Inc(TopCount);
        PointIndex := Index;
        {$IFOPT c-}
        Break;
        {$ENDIF}
      end;
    end;

    // test if the edge is illegal.
    IsIllegal := False;
    case TopCount of
      0:
        begin
          // normal case:
          // it is illegal if the newly added point is
          // inside the neighbors circle.
          if InCircle(Point) then
          begin
            IsIllegal := True;
          end;
        end;
      1:
        begin
          // there is one point on the top triangle.
          // It's illegal if any point on the edge is part of the top
          // triangle.
          If (EdgeIndex >= 0) then
          begin
            IsIllegal := True;
          end;
        end;
      2:
        begin
          // There is one point on the edge in the top triangle
          // and one point on the proposed edge that is also in the
          // top triangle.  It's illegal if the one on the edge has
          // a higher priority.
          IsIllegal := EdgeIndex > PointIndex;
        end;
    else Assert(False);
    end;

    if IsIllegal then
    begin
      // The tests so far don't test for cases where the new triangles
      // overlap because one goes backwards. (Counterclockwise instead
      // of clockwise.

      if HasTopPoint2 or Neighbor.HasTopPoint2 then
      begin
        DirectionTestList := TList.Create;
        try
          DirectionTestList.Capacity := 3;
          DirectionTestList.Add(Point);
          DirectionTestList.Add(OpPoint);
          DirectionTestList.Add(Edge[0]);
          if TurnDirection(DirectionTestList) <> tdRight then
          begin
            Exit;
          end;

          DirectionTestList.Clear;
          DirectionTestList.Capacity := 3;
          DirectionTestList.Add(OpPoint);
          DirectionTestList.Add(Point);
          DirectionTestList.Add(Edge[1]);
          if TurnDirection(DirectionTestList) <> tdRight then
          begin
            Exit;
          end;
        finally
          DirectionTestList.Free;
        end;
      end;

      // Make babies by doing an edge flip.
      Child1 := TTriangle.Create(Top);
      Child1.FNodes[0] := Point;
      Child1.FNodes[1] := OpPoint;
      Child1.FNodes[2] := Edge[0];

      Child2 := TTriangle.Create(Top);
      Child2.FNodes[0] := OpPoint;
      Child2.FNodes[1] := Point;
      Child2.FNodes[2] := Edge[1];

      Children.Add(Child1);
      Neighbor.Children.Add(Child1);

      Children.Add(Child2);
      Neighbor.Children.Add(Child2);

      // set the neighbors for the babies.
      Child1.Neighbors[0] := Child2;
      Child1.Neighbors[1] := GetNeighbor(OpPoint);
      Child1.Neighbors[2] := Neighbor.GetNeighbor(Edge[0]);
      if Child1.Neighbors[1] <> nil then
      begin
        Child1.Neighbors[1].ReplaceNeighbor(self,Child1);
      end;
      if Child1.Neighbors[2] <> nil then
      begin
        Child1.Neighbors[2].ReplaceNeighbor(Neighbor,Child1);
      end;

      Child2.Neighbors[0] := Child1;
      Child2.Neighbors[1] := Neighbor.GetNeighbor(Point);
      Child2.Neighbors[2] := GetNeighbor(Edge[1]);
      if Child2.Neighbors[1] <> nil then
      begin
        Child2.Neighbors[1].ReplaceNeighbor(Neighbor,Child2);
      end;
      if Child2.Neighbors[2] <> nil then
      begin
        Child2.Neighbors[2].ReplaceNeighbor(self,Child2);
      end;

      // Remove self and neighbor from triangulation and add babies to it.
      if Position >= 0 then
      begin
        Triangulation[Position] := nil;
      end;
      if Neighbor.Position >= 0 then
      begin
        Triangulation[Neighbor.Position] := nil;
      end;

      if not Child1.HasTopPoint then
      begin
        Child1.Position := Triangulation.Add(Child1);
      end;
      if not Child2.HasTopPoint then
      begin
        Child2.Position := Triangulation.Add(Child2);
      end;

      // Check Children
      Neighbor := Child1.Neighbors[1];
      if (Neighbor <> nil) then
      begin
        Neighbor.LegalizeEdge(Point, [Edge[0], OpPoint], Triangulation);
      end;

      Neighbor := Child2.Neighbors[2];
      if (Neighbor <> nil) then
      begin
        Neighbor.LegalizeEdge(Point, [OpPoint, Edge[1]], Triangulation);
      end;
    end;
  end;

end;

function TTriangle.OppositePoint(const Edge: array of THullPoint): THullPoint;
var
  List : TList;
  Index : integer;
begin
  // Edge is assumed to contain two of the verticies of the triangle.
  // The function returns the third vertex.
  // There will be an assertion failure if the assumptions are violated.
  Assert(Length(Edge) = 2);
  List := TList.Create;
  try
    List.Capacity := 3;
    for Index := 0 to 2 do
    begin
      List.Add(nodes[Index])
    end;
    for Index := 0 to 1 do
    begin
      List.Remove(Edge[Index])
    end;
    Assert(List.Count = 1);
    result := List[0];
  finally
    List.Free;
  end;

end;

procedure TTriangle.GetPointLocation(const APoint: THullPoint;
  out PointLocation: TInTriangle; out Edge : integer);
var
  AList : TList;
  Index : integer;
  CurrentDirection : TTurnDirection;
  IsOnEdge : boolean;
begin
  Edge := -1;
  PointLocation := tiInside;
  AList := TList.Create;
  try
    AList.Capacity := 6;
    AList.Add(Nodes[1]);
    AList.Add(Nodes[2]);
    AList.Add(APoint);
    IsOnEdge := False;
    for Index := 0 to 2 do
    begin
      CurrentDirection := TurnDirection(AList);
      case CurrentDirection of
        tdRight:
          begin
            // do nothing;
            // if CurrentDirection is tdRight every time, the
            // point is inside the triangle.
          end;
        tdStraight:
          begin
            // The point is on a straight line with one of the edges.
            // It is either on the edge or outside the triangle.
            // Continue checking nodes to find out which.
            IsOnEdge := True;
            Edge := Index+1;
            if Edge > 2 then
            begin
              Edge := Edge-3;
            end;
          end;
        tdLeft:
          begin
            // The Point is outside the triangle.
            PointLocation := tiOutside;
            Exit;
          end;
      else Assert(False);
      end;

      AList.Insert(AList.Count -1, Nodes[Index]);
    end;
  finally
    AList.Free;
  end;
  // if the point was outside the triangle, we wouldn't get here.
  // Therefore it is either inside the triangle or on the edge.
  if IsOnEdge then
  begin
    PointLocation := tiOnEdge;
  end;

end;

procedure TTriangle.ReplaceNeighbor(const OldNeighbor,
  NewNeighbor: TTriangle);
var
  Index : integer;
  function VerifyNeighbor : boolean;
  var
    i, j : integer;
    commonnodes : integer;
  begin
    commonnodes := 0;
    for i := 0 to 2 do
    begin
      for j := 0 to 2 do
      begin
        if Nodes[i] = NewNeighbor.Nodes[j] then
        begin
          Inc(commonnodes);
        end;
      end;
    end;
    result := (commonnodes=2);
  end;
begin
// The procedure replaces OldNeighbor with NewNeighbor in the
// array of neighbors.
// There will be an assertion failure if OldNeighbor is not in the
// array of neighbors or if they do not share a common edge.
  Assert(VerifyNeighbor);

  Assert((OldNeighbor <> nil) and (NewNeighbor <> nil)
    and (NewNeighbor.Children.Count = 0));
  for Index := 0 to 2 do
  begin
    if Neighbors[Index] = OldNeighbor then
    begin
      Neighbors[Index] := NewNeighbor;
      Exit;
    end;
  end;
  Assert(False);

end;


procedure TTriangle.Split(const APoint: THullPoint;
  const Triangulation: TList);
var
  Child1, Child2, Child3 : TTriangle;
begin
  // Assumption: APoint is a point that is inside the triangle.

  Assert((APoint <> nil) and (Triangulation <> nil));

  // Make babies.
  Child1 := TTriangle.Create(Top);
  Children.Add(Child1);
  Child1.FNodes[0] := APoint;
  Child1.FNodes[1] := Nodes[0];
  Child1.FNodes[2] := Nodes[1];

  Child2 := TTriangle.Create(Top);
  Children.Add(Child2);
  Child2.FNodes[0] := APoint;
  Child2.FNodes[1] := Nodes[1];
  Child2.FNodes[2] := Nodes[2];

  Child3 := TTriangle.Create(Top);
  Children.Add(Child3);
  Child3.FNodes[0] := APoint;
  Child3.FNodes[1] := Nodes[2];
  Child3.FNodes[2] := Nodes[0];

  // Set neighbors of babies.
  Child1.Neighbors[0] := Child3;
  Child1.Neighbors[1] := Neighbors[0];
  Child1.Neighbors[2] := Child2;
  if Neighbors[0] <> nil then
  begin
    Neighbors[0].ReplaceNeighbor(self, Child1);
  end;

  Child2.Neighbors[0] := Child1;
  Child2.Neighbors[1] := Neighbors[1];
  Child2.Neighbors[2] := Child3;
  if Neighbors[1] <> nil then
  begin
    Neighbors[1].ReplaceNeighbor(self, Child2);
  end;

  Child3.Neighbors[0] := Child2;
  Child3.Neighbors[1] := Neighbors[2];
  Child3.Neighbors[2] := Child1;
  if Neighbors[2] <> nil then
  begin
    Neighbors[2].ReplaceNeighbor(self, Child3);
  end;

  // take self out of triangulation
  if Position >= 0 then
  begin
    Triangulation[Position] := nil;
  end;

  // add children to Triangulation unless they contain a point on the
  // top (artificial) triangle.
  if not Child1.HasTopPoint then
  begin
    Child1.Position := Triangulation.Add(Child1);
  end;
  if not Child2.HasTopPoint then
  begin
    Child2.Position := Triangulation.Add(Child2);
  end;
  if not Child3.HasTopPoint then
  begin
    Child3.Position := Triangulation.Add(Child3);
  end;

  // check children
  if Child1.Neighbors[1] <> nil then
  begin
    Child1.Neighbors[1].LegalizeEdge(APoint, [Nodes[1], Nodes[0]], Triangulation);
  end;

  if Child2.Neighbors[1] <> nil then
  begin
    Child2.Neighbors[1].LegalizeEdge(APoint, [Nodes[2], Nodes[1]], Triangulation);
  end;

  if Child3.Neighbors[1] <> nil then
  begin
    Child3.Neighbors[1].LegalizeEdge(APoint, [Nodes[0], Nodes[2]], Triangulation);
  end;
end;

procedure TTriangle.Split4(const APoint: THullPoint;
  const Triangulation: TList; const Edge: integer);
var
  Child1, Child2, Child3, Child4 : TTriangle;
  Edge2, Opposite : integer;
  Neighbor : TTriangle;
  OppositePoint : THullPoint;
begin
// Assumption: APoint is on an edge of the triangle.

  // Edge is the index of the side of the triangle
  // that contains APoint.

  Assert((APoint <> nil) and (Triangulation <> nil)
    and (Edge>=0) and (Edge <=2));

  // get the indicies of the other two corners of the triangle
  Edge2 := Edge + 1;
  if Edge2 > 2 then
  begin
    Edge2 := 0
  end;

  Opposite := Edge2 + 1;
  if Opposite > 2 then
  begin
    Opposite := 0
  end;

  // make babies
  Child1 := TTriangle.Create(Top);
  Children.Add(Child1);
  Child1.FNodes[0] := APoint;
  Child1.FNodes[1] := Nodes[Opposite];
  Child1.FNodes[2] := Nodes[Edge];

  Child2 := TTriangle.Create(Top);
  Children.Add(Child2);
  Child2.FNodes[0] := APoint;
  Child2.FNodes[1] := Nodes[Edge2];
  Child2.FNodes[2] := Nodes[Opposite];

  // set neighbors of babies.
  Child1.Neighbors[0] := Child2;
  Child1.Neighbors[1] := GetNeighbor(Nodes[Opposite]);
  if Child1.Neighbors[1] <> nil then
  begin
    Child1.Neighbors[1].ReplaceNeighbor(self, Child1);
  end;

  Child2.Neighbors[2] := Child1;
  Child2.Neighbors[1] := GetNeighbor(Nodes[Edge2]);
  if Child2.Neighbors[1] <> nil then
  begin
    Child2.Neighbors[1].ReplaceNeighbor(self, Child2);
  end;

  Child3 := nil;
  Child4 := nil;

  // remove self from triangulation
  if Position >= 0 then
  begin
    Triangulation[Position] := nil;
  end;

  // add children to Triangulation unless they contain a point on the
  // top (artificial) triangle.
  if not Child1.HasTopPoint then
  begin
    Child1.Position := Triangulation.Add(Child1);
  end;
  if not Child2.HasTopPoint then
  begin
    Child2.Position := Triangulation.Add(Child2);
  end;

  // get the other triangle that has the APoint on it's edge.
  Neighbor := GetNeighbor(Nodes[Edge]);
  if Neighbor <> nil then
  begin
    // Get the Neighbors far corner.
    OppositePoint := Neighbor.OppositePoint([Nodes[Edge2], Nodes[Edge]]);

    // makd babies.
    Child3 := TTriangle.Create(Top);
    Neighbor.Children.Add(Child3);
    Child3.FNodes[0] := APoint;
    Child3.FNodes[1] := Nodes[Edge];
    Child3.FNodes[2] := OppositePoint;

    Child4 := TTriangle.Create(Top);
    Neighbor.Children.Add(Child4);
    Child4.FNodes[0] := APoint;
    Child4.FNodes[1] := OppositePoint;
    Child4.FNodes[2] := Nodes[Edge2];

    // set neighbors of babies.
    Child3.Neighbors[0] := Child1;
    Child3.Neighbors[1] := Neighbor.GetNeighbor(Nodes[Edge]);
    Child3.Neighbors[2] := Child4;
    if Child3.Neighbors[1] <> nil then
    begin
      Child3.Neighbors[1].ReplaceNeighbor(Neighbor, Child3);
    end;

    Child4.Neighbors[0] := Child3;
    Child4.Neighbors[1] := Neighbor.GetNeighbor(OppositePoint);
    Child4.Neighbors[2] := Child2;
    if Child4.Neighbors[1] <> nil then
    begin
      Child4.Neighbors[1].ReplaceNeighbor(Neighbor, Child4);
    end;

    // remove Neighbor from triangulation
    if Neighbor.Position >= 0 then
    begin
      Triangulation[Neighbor.Position] := nil;
    end;

    // add children to Triangulation unless they contain a point on the
    // top (artificial) triangle.
    if not Child3.HasTopPoint then
    begin
      Child3.Position := Triangulation.Add(Child3);
    end;
    if not Child4.HasTopPoint then
    begin
      Child4.Position := Triangulation.Add(Child4);
    end;
  end;

  // set last neighbors for first two children.
  Child1.Neighbors[2] := Child3;
  Child2.Neighbors[0] := Child4;

  // check neighbors.
  Neighbor := Child1.Neighbors[1];
  if (Neighbor <> nil) then
  begin
    Neighbor.LegalizeEdge(APoint, [Nodes[Edge], Nodes[Opposite]],
      Triangulation);
  end;

  Neighbor := Child2.Neighbors[1];
  if (Neighbor <> nil) then
  begin
    Neighbor.LegalizeEdge(APoint, [Nodes[Opposite], Nodes[Edge2]],
      Triangulation);
  end;

  if Child3 <> nil then
  begin
    Neighbor := Child3.Neighbors[1];
    if (Neighbor <> nil) then
    begin
      Neighbor.LegalizeEdge(APoint, [OppositePoint, Nodes[Edge]],
        Triangulation);
    end;
  end;

  if Child4 <> nil then
  begin
    Neighbor := Child4.Neighbors[1];
    if (Neighbor <> nil) then
    begin
      Neighbor.LegalizeEdge(APoint, [Nodes[Edge2], OppositePoint],
        Triangulation);
    end;
  end;

end;

procedure TTriangle.GetTriangles(const APoint: THullPoint;
  const Triangles: TList);
var
  PointLocation: TInTriangle;
  Edge : integer;
  Index : integer;
  Child : TTriangle;
{$IFOPT c+}
  InnerIndex : integer;
  GrandChild : TTriangle;
  OldCount : integer;
{$ENDIF}
begin
  GetPointLocation(APoint, PointLocation, Edge);
  if PointLocation = tiOutside then
  begin
    Exit;
  end;
  if Children.Count > 0 then
  begin
{$IFOPT c+}
    OldCount := Triangles.Count;
{$ENDIF}
    for Index := 0 to Children.Count -1 do
    begin
      Child := Children[Index];
      Child.GetTriangles(APoint, Triangles);
    end;
{$IFOPT c+}
// The code shouldn't ever get here if GetPointLocation works properly.
// GetPointLocation may not work properly if the Epsilon value is
// inappropriate.
    if OldCount = Triangles.Count then
    begin
      for Index := 0 to Children.Count -1 do
      begin
        Child := Children[Index];
        if Child.Children.Count = 0 then
        begin
          Triangles.Add(Child)
        end
        else
        begin
          for InnerIndex := 0 to Child.Children.Count-1 do
          begin
            GrandChild := Child.Children[InnerIndex];
            GrandChild.GetTriangles(APoint, Triangles);
          end;
        end;
      end;
    end;
{$ENDIF}
  end
  else
  begin
    Triangles.Add(self);
  end;
end;

function TTriangle.HasTopPoint: boolean;
var
  i, j : integer;
begin
  // return true if one of the points of the triangle is also a point
  // of the top (artificial) triangle.
  // The function also sets HasTopPoint2 which is used in LegalizeEdge.
  result := false;
  for i := 0 to 2 do
  begin
    for j := 0 to 2 do
    begin
      if Nodes[i] = Top.Nodes[j] then
      begin
        result := True;
        HasTopPoint2 := result;
        Exit;
      end;
    end;
  end;
end;

function TTriangle.GetNode(const Index: integer): THullPoint;
begin
  result := FNodes[Index];
end;

{ TTopTriangle }

procedure TTopTriangle.Clear;
begin
  OwnedTriangles.Clear;
  Children.Clear;
end;

constructor TTopTriangle.Create;
begin
  inherited Create(self);
  Top := self;
  OwnedTriangles := TObjectList.Create;
end;

procedure TTopTriangle.Delaunay(const Points, Triangulation: TList);
const
  // When tested with 10000 points, varying PackFrequency between
  // 1 and 10000 and no noticeable effect on speed.
  // Values of 1, 10, 100, 1000, and 10000 were tested.
  PackFrequency = 4;
var
  NewPoints : TList;
  Index, TriangleIndex : integer;
  Point : THullPoint;
  MaxX, MinX, MaxY, MinY : double;
  DeltaX, DeltaY, M, CenterX, CenterY : double;
  Triangles : TList;
  Triangle : TTriangle;
  PointLocation: TInTriangle;
  Edge : integer;
  pointcount : integer;
  NilCount : integer;
begin
  // get rid of any triangles from a previous call to Delaunay.
  Clear;
  Assert((Points <> nil) and (Triangulation <> nil) and (Points.Count > 2));

  // When a new point is added, at most 4 new triangles will be added.
  // Edge flipping can add at most 8 additional triangles.
  Triangulation.Capacity := Points.Count*12+1;

  // If a Delaunay triangulation was done before,
  Nodes[0].Free;
  Nodes[1].Free;
  Nodes[2].Free;

  // find the limits of the points.
  Point := Points[0];
  MaxX := Point.X;
  MinX := MaxX;
  MaxY := Point.Y;
  MinY := MaxY;
  for Index := 1 to Points.Count -1 do
  begin
    Point := Points[Index];
    if Point.X > MaxX then
    begin
      MaxX := Point.X;
    end;
    if Point.X < MinX then
    begin
      MinX := Point.X;
    end;
    if Point.Y > MaxY then
    begin
      MaxY := Point.Y;
    end;
    if Point.Y < MinY then
    begin
      MinY := Point.Y;
    end;
  end;

  // calculate the positions of three points that will surround all of the
  // points in the list of points.
  DeltaX := MaxX - MinX;
  DeltaY := MaxY - MinY;
  M := DeltaX;
  if DeltaY > M then
  begin
    M := DeltaY;
  end;
  M := M/2;
  
  CenterX := (MaxX + MinX)/2;
  CenterY := (MaxY + MinY)/2;

  FNodes[0] := THullPoint.Create;
  FNodes[0].X := CenterX;
  FNodes[0].Y := CenterY + 3*M;

  FNodes[1] := THullPoint.Create;
  FNodes[1].X := CenterX + 3*M;
  FNodes[1].Y := CenterY;

  FNodes[2] := THullPoint.Create;
  FNodes[2].X := CenterX - 3*M;
  FNodes[2].Y := CenterY - 3*M;

  // Initialize NilCount.
  NilCount := 0;
  // Copy Points into another TList from which they will be gradually removed.
  NewPoints := TList.Create;
  try
    NewPoints.Capacity := Points.Count;
    for Index := 0 to Points.Count -1 do
    begin
      NewPoints.Add(Points[Index]);
    end;

//    NewPoints.Assign(Points);

    // create Triangles.  When a new point is added, Triangles will hold the
    // triangles that contain the new point.
    Triangles := TList.Create;
    try

      // loop until all the points have been added.
      While NewPoints.Count > 0 do
      begin

        // pick a random point to add to the triangularization.
        pointcount := NewPoints.Count;
        Index := Random(pointcount);
        while Index >= pointcount do
        begin
          Index := Random(pointcount);
        end;
        Point := NewPoints[Index];

        // If Point = nil, we have already picked this point.
        // Maybe it is time to get rid of the nil pointers.
        if Point = nil then
        begin
          Inc(NilCount);
          if ((NilCount mod PackFrequency) = 0) then
          begin
            NewPoints.Pack;
          end;
        end
        else
        begin
          // mark that we have already picked this point.
          NewPoints[Index] := nil;

          // Initialize Triangles.
          Triangles.Clear;
          Triangles.Capacity := 10;

          // Get the triangles that contain the point.
          GetTriangles(Point, Triangles);
          Assert(Triangles.Count > 0);
          // if the point is on the edge of a triangle, there may be more than
          // one triangle.
          for TriangleIndex := 0 to Triangles.Count -1 do
          begin
            Triangle := Triangles[TriangleIndex];
            // Ignore triangles that have already been split.
            // This can occur if the point is on the edge of a triangle.
            // and the other triangle on the edge has already been
            // processed.
            if Triangle.Children.Count = 0 then
            begin
              // Find out where the point is in the triangle
              // and split it into 3 or 4 triangles depending
              // on where it is.
              Triangle.GetPointLocation(Point, PointLocation, Edge);
              case PointLocation of
                tiOutside:
                  begin
                    Assert(False);
                  end;
                tiOnEdge:
                  begin
                    Triangle.Split4(Point, Triangulation, Edge);
                  end;
                tiInside:
                  begin
                    Triangle.Split(Point, Triangulation);
                  end;
              else Assert(False);
              end;
            end;
          end;
        end;
      end;
    finally
      Triangles.Free;
    end;
  finally
    NewPoints.Free;
  end;
  Assert(Triangulation.Count <= Points.Count*12+1);
  // get rid of nil pointers in Triangulation.
  Triangulation.Pack;
  // release unneeded memory.
  Triangulation.Capacity := Triangulation.Count;
end;

destructor TTopTriangle.Destroy;
begin
  Nodes[0].Free;
  Nodes[1].Free;
  Nodes[2].Free;
  OwnedTriangles.Free;
  inherited;
end;

procedure TTopTriangle.GetTriangles(const APoint: THullPoint;
  const Triangles: TList);
begin
  inherited GetTriangles(APoint, Triangles);
end;

end.
