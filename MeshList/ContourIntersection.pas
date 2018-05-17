{$IFDEF VER170}
	{$DEFINE DELPHI9_OR_LATER}
{$ENDIF}

unit ContourIntersection;

interface

uses SysUtils, Classes, Contnrs, AnePIE, PlaneGeom, FastGeo;

//procedure GIntersectContoursCells(const refPtX: ANE_DOUBLE_PTR;
//  const refPtY: ANE_DOUBLE_PTR;
//  numParams: ANE_INT16;
//  const parameters: ANE_PTR_PTR;
//  funHandle: ANE_PTR;
//  reply: ANE_PTR); cdecl;

procedure GIntersectContoursElements(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GIntersectContoursCellCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GIntersectContoursNodeNumber(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GIntersectContoursNodeDistance(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GIntersectContourLength(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GCondensedIntersectContoursCellCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GCondensedIntersectContoursNodeNumber(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GCondensedIntersectContoursNodeDistance(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure ClearIntersectLists;
procedure IntersectWithCells;


implementation

uses Math, IntListUnit, ReadContoursUnit, RangeUnit, ReadMeshUnit,
  RangeTreeUnit, ParamArrayUnit, RealListUnit;

type
  TDistanceIndex = class(TObject)
    Distance: double;
    ArrayIndex: integer;
  end;

var
  NodeNumbers: TList;
  NodeDist: TList;
  ElementNumbers: TList;
  ContourIntersectLengths: TRealList;
  CondensedNodeNumbers: TList;
  CondensedNodeDist: TList;

// DistIndexCompare is used in sorting a list of TDistanceIndex's.
function DistIndexCompare(Item1, Item2: Pointer): Integer;
var
  di1, di2: TDistanceIndex;
  difference: double;
begin
  di1 := Item1;
  di2 := Item2;
  difference := di1.Distance - di2.Distance;
  if difference > 0 then
  begin
    result := 1;
  end
  else if difference = 0 then
  begin
    result := 0;
  end
  else
  begin
    result := -1;
  end;
end;

// Compute the distance between two points.
function Distance(const P1, P2: TRealPoint): double;
  {$IFDEF DELPHI9_OR_LATER} inline; {$ENDIF}
begin
  result := Sqrt(Sqr(P1.X - P2.X) + Sqr(P1.Y - P2.Y));
end;

// erase stored data.
procedure ClearIntersectLists;
begin
  NodeNumbers.Clear;
  NodeDist.Clear;
  ElementNumbers.Clear;
  ContourIntersectLengths.Clear;
  CondensedNodeNumbers.Clear;
  CondensedNodeDist.Clear;
end;

{
  FirstPoint is set to Intersection.

  FirstVertexIndex is set to PointIndex - 1.

  Intersection is a point of intersection between the mesh boundary and
    a contour segment.

  NodeIndex indicates the location of the intersection on the mesh boundary.

  BoundaryP1 and BoundaryP2 are set to the points on the mesh
    boundary on either side of Intersection.

  CandidateNode is set to whichever of BoundaryP1 and BoundaryP2 is
    closest to Intersection.
}
procedure UpdateFirstPoint(out FirstPoint: TRealPoint;
  out FirstVertexIndex: integer; out CandidateNode: TNode;
  const Intersection : TRealPoint;
  const PointIndex, NodeIndex: integer);
var
  BoundaryP1, BoundaryP2: TRealPoint;
begin
  FirstPoint := Intersection;
  // FirstVertexIndex is the position of the node on the contour
  // before the point of intersection.
  FirstVertexIndex := PointIndex - 1;

  // Get the positions of the two nodes on the boundary
  // on either side of the point of intersection.
  BoundaryP1 := ElementList.MeshBoundary[NodeIndex];
  BoundaryP2 := ElementList.MeshBoundary[NodeIndex + 1];
  // Determine which node on the boundary is closest to the point of
  // intersection.
  if Distance(BoundaryP1, Intersection) <
    (Distance(BoundaryP1, BoundaryP2) / 2) then
  begin
    CandidateNode := ElementList.BoundaryNodes[NodeIndex]
  end
  else
  begin
    CandidateNode := ElementList.BoundaryNodes[NodeIndex + 1]
  end;
end;

{
  FirstVertexIndex is set to the beginning of the segment in Contour
    that intersects the mesh boundary.

  StartIndex is the beginning of the first segment in Contour that will
    be tested.

  Node is set to the node on the mesh boundary at which the contour
    intersects the mesh boundary.

  Contour is the TContour that is being tested.

  Nodes is a list of node numbers that are intersected.

  NodeDistances is a list of distances of intersection between
    the cell and a contour.

  FirstPointDistance is set to the distance between the beginning of the
    segment that intersects the mesh boundary and the point of intersection.

  StartPoint is the beginning point of the intersection between the segment
    and the cell.
}

procedure FindNextPoint(out FirstVertexIndex: Integer;
  Const StartIndex: integer; var Node: TNode;
  Contour: TContour; Nodes: TIntegerList; NodeDistances: TRealList;
  var FirstPointDistance: Double; var StartPoint: TRealPoint);
var
  CandidateDistance: Double;
  Index: Integer;
  CandidateNode: TNode;
  Intersection: TRealPoint;
  ContourP2: TRealPoint;
  ContourP1: TRealPoint;
  PointIndex: Integer;
  CandidateIndicies: TIntegerArray;
  CandidatePoints: TPointArray;
  FirstPoint: TRealPoint;
  FirstPointFound: Boolean;
  NodeIndex: integer;
begin
  // If Node = nil, the first point of the contour is outside the mesh.
  // Find the first point at which the contour intersects the mesh.
  if (Node = nil) and (Contour.Count > 1) then
  begin
    FirstPointFound := False;
    // loop over points on contour.
    for PointIndex := StartIndex+1 to Contour.Count - 1 do
    begin
      ContourP1 := Contour.Points[PointIndex - 1];
      ContourP2 := Contour.Points[PointIndex];
      // Find points on mesh boundary that may intersect the
      // current segment of the contour.
      // CandidatePoints is an array of points of intersection.
      // CandidateIndicies is an array of positions of nodes below
      // the points of intersection.
      if ElementList.Intersect(ContourP1, ContourP2, CandidatePoints,
        CandidateIndicies) then
      begin
        // Get the point of intersection.
        Intersection := CandidatePoints[0];
        StartPoint := Intersection;
        FirstPointFound := True;
        // Get the distance from the point of intersection to the
        // point on the contour.
        FirstPointDistance := Distance(ContourP1, Intersection);
        // Get the position of the node below the point of intersection.
        NodeIndex := CandidateIndicies[0];
        // Figure out which node on the boundary is closest to the
        // point of intersection.
        UpdateFirstPoint(FirstPoint, FirstVertexIndex, CandidateNode,
          Intersection, PointIndex, NodeIndex);
        // loop over the remaining points (if any)
        for Index := 1 to Length(CandidatePoints) - 1 do
        begin
          // Get the distance to the point of intersction.
          Intersection := CandidatePoints[Index];
          CandidateDistance := Distance(ContourP1, Intersection);
          // If the new distance is less than the previous distance,
          // use this point.
          if CandidateDistance < FirstPointDistance then
          begin
            // Update required data.
            StartPoint := Intersection;
            FirstPointDistance := CandidateDistance;
            NodeIndex := CandidateIndicies[Index];
            UpdateFirstPoint(FirstPoint, FirstVertexIndex, CandidateNode,
              Intersection, PointIndex, NodeIndex);
          end;
        end;
      end;
      // if ElementList.Intersect(ContourP1,...
      if FirstPointFound then
      begin
        // update data.
        Node := CandidateNode;
        Nodes.Add(Node.Number);
        NodeDistances.Add(0);
        break;
      end;
    end;
  end; // if (Node = nil) and (Contour.Count > 1) then
end;

{
  ContourP1 is the beginning point of a contour segment.

  CandidatePoints contains the points of intersection between the
    segment and the cell.

  CandidateIndicies indicates where on the cell boundary those interesections
    are located.

  ClosestIndex is set to the index of the point in CandidatePoints that is
    closest to ContourP1.

  EndPoint is the location of that point of intersection.
}

procedure GetFirstIntersectionInCell(
  ContourP1: TRealPoint; CandidatePoints: TPointArray;
  CandidateIndicies: TIntegerArray; var ClosestIndex: Integer;
  var EndPoint: TRealPoint);
var
  DistanceList: TObjectList;
  Index: Integer;
  Intersection: TRealPoint;
  CandidateDistance: Double;
  DI: TDistanceIndex;
begin
  // CandidatePoints contains the points of intersection between
  // the current segment and the cell.
  if Length(CandidatePoints) > 1 then
  begin
    // The segment intersects the cell boundary at more than one point.
    // Store the distances to the points in DistanceList along with the
    // indicies.
    DistanceList := TObjectList.Create;
    try
      for Index := 0 to Length(CandidatePoints) - 1 do
      begin
        Intersection := CandidatePoints[Index];
        CandidateDistance := Distance(ContourP1, Intersection);
        DI := TDistanceIndex.Create;
        DI.Distance := CandidateDistance;
        DI.ArrayIndex := Index;
        DistanceList.Add(DI);
      end;
      // for Index := 0 to Length(CandidatePoints) -1 do
      // Sort DistanceList in ascending order according to the distance.
      DistanceList.Sort(DistIndexCompare);
      // Find the distance that is the closest match to
      // FirstPointDistance. Because of rounding errors, the match might
      // not be exact.
      DI := DistanceList[0] as TDistanceIndex;
      ClosestIndex := DI.ArrayIndex;
      EndPoint := CandidatePoints[ClosestIndex];
    finally
      DistanceList.Free;
    end;
  end
  else
  // if Length(CandidatePoints) > 1 then
  begin
    ClosestIndex := 0;
    if Length(CandidatePoints) = 1 then
    begin
      EndPoint := CandidatePoints[0];
    end;
  end;  // if Length(CandidatePoints) > 1 then... else
end;


{
  FirstPointDistance is the distance between the beginning of the current
    segment and the place where it intersects the cell boundary.

  ContourP1 is the location of the beginning of the current segment.

  CandidatePoints has the locations of all points of intersection between
    the current segment and the cell boundary.

  CandidateIndicies indicates where on the cell boundary those
    points of intersection are located.

  ClosestIndex is set to the position of the intersection in CandidatePoints
    that is just beyond FirstPointDistance.

  EndPoint is the location of that point of intersection.
}


procedure GetNextIntersectionInCell(var FirstPointDistance: Double;
  ContourP1: TRealPoint; CandidatePoints: TPointArray;
  CandidateIndicies: TIntegerArray; var ClosestIndex: Integer;
  var EndPoint: TRealPoint);
var
  DistanceList: TObjectList;
  Index: Integer;
  Intersection: TRealPoint;
  CandidateDistance: Double;
  DI: TDistanceIndex;
  TestDifference: Double;
  TempDifference: Double;
begin
  // CandidatePoints contains the points of intersection between
  // the current segment and the cell.
  if Length(CandidatePoints) > 1 then
  begin
    // The segment intersects the cell boundary at more than one point.
    // Store the distances to the points in DistanceList along with the
    // indicies.
    DistanceList := TObjectList.Create;
    try
      for Index := 0 to Length(CandidatePoints) - 1 do
      begin
        Intersection := CandidatePoints[Index];
        CandidateDistance := Distance(ContourP1, Intersection);
        DI := TDistanceIndex.Create;
        DI.Distance := CandidateDistance;
        DI.ArrayIndex := Index;
        DistanceList.Add(DI);
      end;
      // for Index := 0 to Length(CandidatePoints) -1 do
      // Sort DistanceList in ascending order according to the distance.
      DistanceList.Sort(DistIndexCompare);
      // Find the distance that is the closest match to
      // FirstPointDistance. Because of rounding errors, the match might
      // not be exact.
      DI := DistanceList[0] as TDistanceIndex;
      TestDifference := Abs(DI.Distance - FirstPointDistance);
      ClosestIndex := 0;
      for Index := 1 to DistanceList.Count - 1 do
      begin
        DI := DistanceList[Index] as TDistanceIndex;
        TempDifference := Abs(DI.Distance - FirstPointDistance);
        if TempDifference < TestDifference then
        begin
          ClosestIndex := Index;
          TestDifference := TempDifference;
        end;
      end;
      // for Index := 1 to DistanceList.Count -1 do
      // The point just beyond the point that is the closest match
      // is the one we want.
      Inc(ClosestIndex);
      if ClosestIndex < DistanceList.Count then
      begin
        DI := DistanceList[ClosestIndex] as TDistanceIndex;
        FirstPointDistance := DI.Distance;
        ClosestIndex := DI.ArrayIndex;
        EndPoint := CandidatePoints[ClosestIndex];
      end
      else
      // if CellBoundaryIndex + 1 < DistanceList.Count then
      begin
        ClosestIndex := DistanceList.Count;
      end;
    finally
      DistanceList.Free;
    end;
  end
  else
  // if Length(CandidatePoints) > 1 then else
  begin
    ClosestIndex := 1;
    if Length(CandidatePoints) = 1 then
    begin
      EndPoint := CandidatePoints[0];
      FirstPointDistance := Distance(ContourP1, EndPoint);
    end;
  end;  // if Length(CandidatePoints) > 1 then... else
end;

{
  ContourP1 and ContourP2 are the endpoints of a contour segment.

  CandidatePoints has the locations of all points of intersection between
    the current segment and the cell boundary.

  CandidateIndicies indicates where on the cell boundary those
    points of intersection are located.

  NextNodeList is a list of nodes that might be on the opposite
    side of the cell boundary ast the point of intersection.

  NextNode is set to the node whose cell actually is on
    the other side of the cell boundary.

  FirstPointDistance is the distance from the ContourP1 to the point of
    intersection on the cell boundary.
}
procedure GetNodeOnOppositeSideOfCellBoundary(ContourP1, ContourP2: TRealPoint;
  NextNodeList: TList; var NextNode: TNode; FirstPointDistance: Double);
var
  TempDistance: Double;
  TempNode: TNode;
  CandidateIndex: Integer;
  FoundFirstPoint: Boolean;
  NodeListIndex: Integer;
  TestDifference: Double;
  TempDifference: Double;
  CandidatePoints: TPointArray;
  CandidateIndicies: TIntegerArray;
begin
  // if NextNodeList = nil then
  // This is not the edge of the mesh.
  // Find the node on the opposite side of the cell boundary.
  if NextNodeList.Count > 1 then
  begin
    FoundFirstPoint := False;
    TestDifference := 0;
    NextNode := nil;
    for NodeListIndex := 0 to NextNodeList.Count - 1 do
    begin
      TempNode := NextNodeList[NodeListIndex];
      TempNode.Intersect(ContourP1, ContourP2, CandidatePoints, CandidateIndicies);
      for CandidateIndex := 0 to Length(CandidatePoints) - 1 do
      begin
        TempDistance := Distance(ContourP1, CandidatePoints[CandidateIndex]);
        TempDifference := Abs(TempDistance - FirstPointDistance);
        if FoundFirstPoint then
        begin
          if TempDifference < TestDifference then
          begin
            TestDifference := TempDifference;
            NextNode := TempNode;
          end;
        end  // if FoundFirstPoint then
        else
        begin
          FoundFirstPoint := True;
          TestDifference := TempDifference;
          NextNode := TempNode;
        end;
      end;
    end;
  end  // if NextNodeList.Count > 1 then
  else
  begin
    Assert(NextNodeList.Count = 1);
    NextNode := NextNodeList[0];
  end; // if NextNodeList.Count > 1 then else
end;

{
  ContourP1 is the first point of a contour segment.

  CandidatePoints has the points of intersection between the segment
    and the mesh boundary.

  CandidateIndicies indicates where on the mesh boundary those points
    are located.

  NextNode is set to the node at the next location where the segment
    intersects the mesh boundary.

  FirstPointDistance is the distance from the beginning of the segment
    to the previous point of intersection with the mesh boundary.

  StartPoint is set to the the location of the next point of intersection.
}
procedure FindNextIntersectionOnMeshBoundary(ContourP1: TRealPoint;
  CandidatePoints: TPointArray; CandidateIndicies: TIntegerArray;
  var NextNode: TNode; FirstPointDistance: Double; var StartPoint: TRealPoint);
var
  DistanceList: TObjectList;
  Index: Integer;
  Intersection: TRealPoint;
  CandidateDistance: Double;
  DI: TDistanceIndex;
  ClosestIndex: Integer;
  TestDifference: Double;
  TempDifference: Double;
  ArrayIndex: Integer;
  BoundaryP1: TRealPoint;
  BoundaryP2: TRealPoint;
begin
  begin
    Assert(Length(CandidatePoints) > 0);
    DistanceList := TObjectList.Create;
    try
      for Index := 0 to Length(CandidatePoints) - 1 do
      begin
        Intersection := CandidatePoints[Index];
        CandidateDistance := Distance(ContourP1, Intersection);
        DI := TDistanceIndex.Create;
        DI.Distance := CandidateDistance;
        DI.ArrayIndex := Index;
        DistanceList.Add(DI);
      end;
      // for Index := 0 to Length(CandidatePoints) -1 do
      // Sort DistanceList in ascending order according to the
      // distance.
      DistanceList.Sort(DistIndexCompare);
      ClosestIndex := 0;
      DI := DistanceList[0] as TDistanceIndex;
      TestDifference := Abs(DI.Distance - FirstPointDistance);
      for Index := 1 to DistanceList.Count - 1 do
      begin
        DI := DistanceList[Index] as TDistanceIndex;
        TempDifference := Abs(DI.Distance - FirstPointDistance);
        if TempDifference < TestDifference then
        begin
          TestDifference := TempDifference;
          ClosestIndex := Index;
        end;
      end;
      // for Index := 1 to DistanceList.Count -1 do
      if ClosestIndex + 1 < DistanceList.Count then
      begin
        DI := DistanceList[ClosestIndex + 1] as TDistanceIndex;
        ArrayIndex := DI.ArrayIndex;
        BoundaryP1 := ElementList.MeshBoundary[CandidateIndicies[ArrayIndex]];
        BoundaryP2 := ElementList.MeshBoundary[CandidateIndicies[ArrayIndex] + 1];
        if Distance(BoundaryP1, BoundaryP2) / 2 > Distance(BoundaryP1, CandidatePoints[ArrayIndex]) then
        begin
          NextNode := ElementList.BoundaryNodes[CandidateIndicies[ArrayIndex]];
        end
        else
        begin
          NextNode := ElementList.BoundaryNodes[CandidateIndicies[ArrayIndex] + 1];
        end;
        StartPoint := CandidatePoints[ArrayIndex];
      end;
    finally
      DistanceList.Free;
    end;
  end;
end;

{
  ContourP1 and ContourP2 are the endpoints of a contour segment.

  Node is the node of interest.

  StartPoint is set to the first point of interesection between the segment
    and the node around the cell.

  FirstPointDistance is set to the distance between the first point of
    the segment and the first point of interesection between the segment
    and the node around the cell.
}
procedure UpdateFirstPointDistance(ContourP1, ContourP2: TRealPoint;
  Node: TNode; var FirstPointDistance: Double; var StartPoint: TRealPoint);
var
  DistanceList: TObjectList;
  CandidateIndicies: TIntegerArray;
  CandidatePoints: TPointArray;
  Index: Integer;
  Intersection: TRealPoint;
  CandidateDistance: Double;
  DI: TDistanceIndex;
  TestDifference: Double;
  TempDifference: Double;
  ClosestIndex: integer;
begin
  Node.Intersect(ContourP1, ContourP2, CandidatePoints,
    CandidateIndicies);
  Assert(Length(CandidatePoints) > 0);
  DistanceList := TObjectList.Create;
  try
    for Index := 0 to Length(CandidatePoints) - 1 do
    begin
      Intersection := CandidatePoints[Index];
      CandidateDistance := Distance(ContourP1, Intersection);
      DI := TDistanceIndex.Create;
      DI.Distance := CandidateDistance;
      DI.ArrayIndex := Index;
      DistanceList.Add(DI);
    end;
    // for Index := 0 to Length(CandidatePoints) -1 do
    // Sort DistanceList in ascending order according to the distance.
    DistanceList.Sort(DistIndexCompare);
    // Find the distance that is the closest match to
    // FirstPointDistance. Because of rounding errors, the match might
    // not be exact.
    DI := DistanceList[0] as TDistanceIndex;
    TestDifference := Abs(DI.Distance - FirstPointDistance);
    ClosestIndex := 0;
    for Index := 1 to DistanceList.Count - 1 do
    begin
      DI := DistanceList[Index] as TDistanceIndex;
      TempDifference := Abs(DI.Distance - FirstPointDistance);
      if TempDifference < TestDifference then
      begin
        ClosestIndex := Index;
        TestDifference := TempDifference;
      end;
    end;
    // for Index := 1 to DistanceList.Count -1 do
    // The point just beyond the point that is the closest match
    // is the one we want.
      DI := DistanceList[ClosestIndex] as TDistanceIndex;
      FirstPointDistance := DI.Distance;
      StartPoint := CandidatePoints[DI.ArrayIndex];
  finally
    DistanceList.Free;
  end;
end;

{
  IntersectWithCells calculates how each contour intersects with the mesh.
  Each node whose cell intersects a contour is recorded along with the
  length of intersection.
}

procedure UpdateContourIntersectLengths;
var
  OuterIndex, InnerIndex: integer;
  Distances: TRealList;
  Value: double;
begin
  ContourIntersectLengths.Clear;
  ContourIntersectLengths.Capacity := NodeDist.Count;
  for OuterIndex := 0 to NodeDist.Count -1 do
  begin
    Value := 0;
    Distances := NodeDist[OuterIndex];
    for InnerIndex := 0 to Distances.Count -1 do
    begin
      Value := Value + Distances[InnerIndex];
    end;
    ContourIntersectLengths.Add(Value);
  end;
end;

procedure Condense;
var
  Indicies: array of Integer;
  Index: integer;
  NodeNum: TIntegerList;
  NodeDistances: TRealList;
  ConNodNum: TIntegerList;
  ConDist: TRealList;
  InnerIndex: integer;
  NodeNumber: integer;
  Distance: double;
begin
  CondensedNodeNumbers.Clear;
  CondensedNodeDist.Clear;
  SetLength(Indicies, NodeList.Count + 1);
  Assert(NodeDist.Count = NodeNumbers.Count);
  for Index := 0 to NodeDist.Count -1 do
  begin
    for InnerIndex := 0 to Length(Indicies) -1 do
    begin
      Indicies[InnerIndex] := -1;
    end;
    NodeNum := NodeNumbers[Index];
    NodeDistances := NodeDist[Index];
    Assert(NodeNum.Count = NodeDistances.Count);

    ConNodNum := TIntegerList.Create;
    CondensedNodeNumbers.Add(ConNodNum);

    ConDist := TRealList.Create;
    CondensedNodeDist.Add(ConDist);

    for InnerIndex := 0 to NodeNum.Count -1 do
    begin
      NodeNumber := NodeNum[InnerIndex];
      Distance := NodeDistances[InnerIndex];
      if Indicies[NodeNumber] < 0 then
      begin
        Indicies[NodeNumber] := ConNodNum.Add(NodeNumber);
        ConDist.Add(Distance);
      end
      else
      begin
        ConDist[Indicies[NodeNumber]] :=
          ConDist[Indicies[NodeNumber]] +  Distance
      end;
    end;
  end;
end;

procedure IntersectWithCells;
var
  ContourIndex: integer;
  Nodes: TIntegerList;
  Contour: TContour;
  Point: TRealPoint;
  NodeList: TList;
  Location: TLocationArray;
  NodeIndex: integer;
  Node: TNode;
  ContourP1, ContourP2: TRealPoint;
  FirstPoint: TRealPoint;
  FirstPointDistance: double;
  FirstVertexIndex: integer;
  CandidatePoints: TPointArray;
  CandidateIndicies: TIntegerArray;
  NodeList1, NodeList2: TList;
  NextNodeList: TList;
  NodePoint1, NodePoint2: TRealPoint;
  NextNode: TNode;
  InsideCell: boolean;
  ClosestIndex: integer;
  NodeDistances: TRealList;
  StartPoint, EndPoint: TRealPoint;
begin
  FirstPointDistance := 0;

  ClearIntersectLists;

  NodeNumbers.Capacity := ContourList.Count;
  NodeDist.Capacity := ContourList.Count;
  ContourIntersectLengths.Capacity := ContourList.Count;

  SetLength(Location, 2);
  NodeList := TList.Create;
  try
    // loop over contours.
    for ContourIndex := 0 to ContourList.Count - 1 do
    begin
      // Nodes will hold the node numbers of the nodes intersected by the
      // current contour.
      Nodes := TIntegerList.Create;
      // NodeNumbers holds the lists of node numbers.
      NodeNumbers.Add(Nodes);
      // NodeDistances will hold the length of intersection between
      // the cell around each node and the current contour.
      NodeDistances:= TRealList.Create;
      // NodeDist holds the lists of node distances.
      NodeDist.Add(NodeDistances);

      // get the current contour.
      Contour := ContourList[ContourIndex];
      // Get the first point in the contour.
      Point := Contour.Points[0];

      // Find the nodes whose cells might contain the first point.
      // NodeList will hold a list of candidate nodes.
      Location[0] := Point.X;
      Location[1] := Point.Y;
      NodeList.Clear;
      NodeRangeTree.FindInList(Location, NodeList);

      // 1.
      // See if any of the candidates actually contain the first point.
      InsideCell := False;
      Node := nil;
      for NodeIndex := 0 to NodeList.Count - 1 do
      begin
        Node := NodeList[NodeIndex];
        if Node.PointInsideCell(Point.X, Point.Y) then
        begin
          // The current node contains the first point in the contour.
          // Add it to Nodes and update variables.
          Nodes.Add(Node.Number);
          NodeDistances.Add(0);
          FirstPoint := Point;
          FirstPointDistance := 0;
          FirstVertexIndex := 0;
          InsideCell := True;
          StartPoint := Point;
          // Only one cell can contain the node so
          // break out of loop leaving Node set to the node that contained
          // the point.
          break;
        end; // if Node.PointInsideCell(Point.X, Point.Y) then
        // The current candidate node does not contain the first point.
        // Reset Node to nil.
        Node := nil;
      end; // for NodeIndex := 0 to NodeList.Count - 1 do


      // 2
      // If Node = nil, the first point of the contour is outside the mesh.
      // Find the first point at which the contour intersects the mesh.
      {
        procedure FindNextPoint(out FirstVertexIndex: Integer;
          Const StartIndex: integer; var Node: TNode;
          Contour: TContour; Nodes: TIntegerList; NodeDistances: TRealList;
          var FirstPointDistance: Double; var StartPoint: TRealPoint);
      }
      FindNextPoint(FirstVertexIndex, 0, Node, Contour,
        Nodes, NodeDistances, FirstPointDistance, StartPoint);

      // If Node = nil, the contour does not intersect the mesh.
      while Node <> nil do
      begin
        // 3.
        // At this point:
        // 1. Node is the node in the mesh that
        //    is intersected by the contour.
        // 2. FirstPointDistance is the distance from the most recent
        //    point on the contour to the point at which the contour
        //    intersects the cell around the node.
        //    FirstPointDistance is zero if the first
        //    node on the contour is inside the mesh.
        // 3. FirstVertexIndex indicates the beginning of current segment.
        //
        // Now try intersecting the current segment of the contour with the
        // cell boundary.  The first intersection point that is further away
        // from the point on the contour indicated by FirstVertexIndex than
        // FirstPointDistance is the point we are looking for.

        if FirstVertexIndex + 1 >= Contour.Count then
        begin
          // Quit when the end of the contour is reached.
          Break;
        end;
        // Get the end points of the current segment.
        ContourP1 := Contour.Points[FirstVertexIndex];
        ContourP2 := Contour.Points[FirstVertexIndex + 1];
        // Get the points of intersection between the current segment and
        // the cell boundary of the node.
        Node.Intersect(ContourP1, ContourP2, CandidatePoints,
          CandidateIndicies);

        if InsideCell then
        begin
          // Update ClosestIndex and EndPoint.
          // ClosestIndex is the intersection point
          //   that is closest to the beginning of the segment.
          // EndPoint is the location of the intersection point
          //   that is closest to the beginning of the segment.
          {
            procedure GetFirstIntersectionInCell(
              ContourP1: TRealPoint; CandidatePoints: TPointArray;
              CandidateIndicies: TIntegerArray; var ClosestIndex: Integer;
              var EndPoint: TRealPoint);
          }
          GetFirstIntersectionInCell(ContourP1,
            CandidatePoints, CandidateIndicies, ClosestIndex, EndPoint);
          InsideCell := False;
        end
        else
        begin
          // Update FirstPointDistance, ClosestIndex, and EndPoint.
          // FirstPointDistance is the distance from the beginning of the
          //   segment to the first intersection point.
          // ClosestIndex is the intersection point
          //   that is the next beyond
          //   FirstPointDistance from the beginning of the segment
          // EndPoint is the location of the intersection point
          //   that is the next beyond
          //   FirstPointDistance from the beginning of the segment
          {
            procedure GetNextIntersectionInCell(var FirstPointDistance: Double;
              ContourP1: TRealPoint; CandidatePoints: TPointArray;
              CandidateIndicies: TIntegerArray; var ClosestIndex: Integer;
              var EndPoint: TRealPoint);
          }
          GetNextIntersectionInCell(FirstPointDistance, ContourP1,
            CandidatePoints, CandidateIndicies, ClosestIndex, EndPoint);
        end;

        // 4.
        // CandidatePoints contains the points of intersection between
        // the current segment and the cell.
        // ClosestIndex now indicates the next position in CandidatePoints
        if ClosestIndex >= Length(CandidatePoints) then
        begin
          // If ClosestIndex >= Length(CandidatePoints) then there
          // is no point on the current segment of the contour
          // that intersects the node beyond the
          // point that was previously identified.  Therefore the end of the
          // current contour segment must be either inside the cell boundary.
          // or beyond the edge of the mesh.
          NextNode := Node;
          FirstPointDistance := 0;
          Inc(FirstVertexIndex);
          InsideCell :=  Node.PointInsideCell(ContourP2.X, ContourP2.Y);
          if InsideCell then
          begin
            EndPoint := ContourP2;

            // Update the length of the segment in the cell.
            NodeDistances[NodeDistances.Count -1] :=
              NodeDistances[NodeDistances.Count -1]
              + Distance(StartPoint, EndPoint);
            StartPoint := EndPoint;
          end;
        end // if ClosestIndex >= Length(CandidatePoints) then
        else
        begin
          // Update the length of the segment in the cell.
          NodeDistances[NodeDistances.Count -1] :=
            NodeDistances[NodeDistances.Count -1]
            + Distance(StartPoint, EndPoint);

          // The endpoint of the current segment is outside the cell.
          // Find the next cell that is intersected.
          NodeIndex := CandidateIndicies[ClosestIndex];
          NodeList1 := Node.CellBoundaryNodeLists[NodeIndex];
          NodeList2 := Node.CellBoundaryNodeLists[NodeIndex+1];

          // Figure out which point on the cell boundary is
          // closer to the point of intersection.
          NodePoint1 := Node.CellBoundary[NodeIndex];
          NodePoint2 := Node.CellBoundary[NodeIndex+1];
          if Distance(NodePoint1, NodePoint2)/2 <
            Distance(NodePoint1, CandidatePoints[ClosestIndex]) then
          begin
            NextNodeList := NodeList1;
          end // if Distance(NodePoint1, NodePoint2)/2...
          else
          begin
            NextNodeList := NodeList2;
          end; // if Distance(NodePoint1, NodePoint2)/2... else

          if (NodeList1 = nil) or (NodeList2 = nil) then
          begin
            // This is the edge of the mesh.  However, there may still be
            // more points on the contour segment that interesect the mesh.

            NextNode := nil;
            ContourP1 := Contour.Points[FirstVertexIndex];
            ContourP2 := Contour.Points[FirstVertexIndex +1];
            if ElementList.Intersect(ContourP1, ContourP2, CandidatePoints,
              CandidateIndicies) then
            begin
            {
              A.
                See if there are any point where the current segment
                intersects
                the mesh boundary beyond the last point of intersection.
                If so, that is the next cell to use.
            }
              FindNextIntersectionOnMeshBoundary(ContourP1, CandidatePoints,
                CandidateIndicies, NextNode, FirstPointDistance, StartPoint)
            end
            else
            begin
              Assert(False);
            end;
            if NextNode = nil then
            begin
            {
              B.
                If if there are no points where the current segment
                intersects
                the mesh boundary beyond the last point of intersection,
                loop over remaining segments until you find one that
                intersects the mesh boundary.  The closest intersection point
                to the beginning of the current segment is the one to use.

                If no node is found, the While loop will exit.
            }
              FindNextPoint(FirstVertexIndex, FirstVertexIndex+1,
                NextNode, Contour, Nodes, NodeDistances, FirstPointDistance,
                StartPoint);
              Node := NextNode;
              Continue;
            end;

          end
          else
          begin
            // This is not the edge of the mesh.
            // Find the node on the opposite side of the cell boundary.
            GetNodeOnOppositeSideOfCellBoundary(ContourP1, ContourP2,
              NextNodeList, NextNode, FirstPointDistance);
            UpdateFirstPointDistance(ContourP1, ContourP2, NextNode,
              FirstPointDistance, StartPoint);
          end; // if (NodeList1 = nil) or (NodeList2 = nil) then else
            // NextNode is the next node intersected by the contour.
        end; // if ClosestIndex >= Length(CandidatePoints) then... else

        // At this point CandidatePoints and CandidateIndicies are undefined.

        // Update the node numbers and node distances.
        if (Node <> NextNode) and (NextNode <> nil) then
        begin
          Nodes.Add(NextNode.Number);
          NodeDistances.Add(0);
        end;

        // Handle the next node.
        Node := NextNode;
      end; // while Node <> nil do
    end; // for ContourIndex := 0 to ContourList.Count - 1 do
  finally
    NodeList.Free;
  end;
  UpdateContourIntersectLengths;
  Condense;
end;

procedure IntersectWithElements;
begin
  ElementNumbers.Clear;
end;

//procedure GIntersectContoursCells(const refPtX: ANE_DOUBLE_PTR;
//  const refPtY: ANE_DOUBLE_PTR;
//  numParams: ANE_INT16;
//  const parameters: ANE_PTR_PTR;
//  funHandle: ANE_PTR;
//  reply: ANE_PTR); cdecl;
//var
//  result: ANE_BOOL;
//begin
//  result := False;
//  try
//    try
//      IntersectWithCells;
//      result := true;
//    except
//      result := False;
//    end;
//  finally
//    ANE_BOOL_PTR(reply)^ := result;
//  end;
//end;

procedure GIntersectContoursElements(const refPtX: ANE_DOUBLE_PTR;
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
      IntersectWithElements;
      result := true;
    except
      Inc(ErrorCount);
      result := False;
    end;
  finally
    ANE_BOOL_PTR(reply)^ := result;
  end;
end;

procedure GIntersectContoursCellCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  param: PParameter_array;
  P1: ANE_INT32_PTR;
  ContourNumber: ANE_INT32;
  result: ANE_INT32;
  Nodes: TIntegerList;
begin
  result := -1;
  try
    try
      if numParams <> 1 then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      param := @parameters^;
      P1 := param^[0];
      ContourNumber := P1^;
      if (ContourNumber < 0) or (ContourNumber >= NodeNumbers.Count) then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      Nodes := NodeNumbers[ContourNumber];
      result := Nodes.Count;
    except
      Inc(ErrorCount);
      result := -1;
    end;
  finally
    ANE_INT32_PTR(reply)^ := result;
  end;
end;

procedure GIntersectContoursNodeNumber(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  param: PParameter_array;
  P1, P2: ANE_INT32_PTR;
  ContourNumber: ANE_INT32;
  NodeIndex: ANE_INT32;
  Nodes: TIntegerList;
  result: ANE_INT32;
begin
  result := -1;
  try
    try
      if numParams <> 2 then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      param := @parameters^;
      P1 := param^[0];
      ContourNumber := P1^;
      P2 := param^[1];
      NodeIndex := P2^;
      if (ContourNumber < 0) or (ContourNumber >= NodeNumbers.Count) then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      Nodes := NodeNumbers[ContourNumber];
      if (NodeIndex < 0) or (NodeIndex >= Nodes.Count) then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      result := Nodes[NodeIndex];
    except
      Inc(ErrorCount);
      result := -1;
    end;
  finally
    ANE_INT32_PTR(reply)^ := result;
  end;
end;

procedure GIntersectContoursNodeDistance(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  param: PParameter_array;
  P1, P2: ANE_INT32_PTR;
  ContourNumber: ANE_INT32;
  NodeIndex: ANE_INT32;
  NodeDistances: TRealList;
  result: ANE_DOUBLE;
begin
  result := -1;
  try
    try
      if numParams <> 2 then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      param := @parameters^;
      P1 := param^[0];
      ContourNumber := P1^;
      P2 := param^[1];
      NodeIndex := P2^;
      if (ContourNumber < 0) or (ContourNumber >= NodeDist.Count) then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      NodeDistances := NodeDist[ContourNumber];
      if (NodeIndex < 0) or (NodeIndex >= NodeDistances.Count) then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      result := NodeDistances[NodeIndex];
    except
      Inc(ErrorCount);
      result := -1;
    end;
  finally
    ANE_DOUBLE_PTR(reply)^ := result;
  end;
end;

procedure GIntersectContourLength(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  param: PParameter_array;
  P1: ANE_INT32_PTR;
  ContourNumber: ANE_INT32;
  result: ANE_DOUBLE;
begin
  result := -1;
  try
    try
      if numParams <> 1 then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      param := @parameters^;
      P1 := param^[0];
      ContourNumber := P1^;
      if (ContourNumber < 0) or
        (ContourNumber >= ContourIntersectLengths.Count) then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      result := ContourIntersectLengths[ContourNumber];
    except
      Inc(ErrorCount);
      result := -1;
    end;
  finally
    ANE_DOUBLE_PTR(reply)^ := result;
  end;
end;

procedure GCondensedIntersectContoursCellCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  param: PParameter_array;
  P1: ANE_INT32_PTR;
  ContourNumber: ANE_INT32;
  result: ANE_INT32;
  Nodes: TIntegerList;
begin
  result := -1;
  try
    try
      if numParams <> 1 then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      param := @parameters^;
      P1 := param^[0];
      ContourNumber := P1^;
      if (ContourNumber < 0) or (ContourNumber >= CondensedNodeNumbers.Count) then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      Nodes := CondensedNodeNumbers[ContourNumber];
      result := Nodes.Count;
    except
      Inc(ErrorCount);
      result := -1;
    end;
  finally
    ANE_INT32_PTR(reply)^ := result;
  end;
end;

procedure GCondensedIntersectContoursNodeNumber(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  param: PParameter_array;
  P1, P2: ANE_INT32_PTR;
  ContourNumber: ANE_INT32;
  NodeIndex: ANE_INT32;
  Nodes: TIntegerList;
  result: ANE_INT32;
begin
  result := -1;
  try
    try
      if numParams <> 2 then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      param := @parameters^;
      P1 := param^[0];
      ContourNumber := P1^;
      P2 := param^[1];
      NodeIndex := P2^;
      if (ContourNumber < 0) or (ContourNumber >= CondensedNodeNumbers.Count) then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      Nodes := CondensedNodeNumbers[ContourNumber];
      if (NodeIndex < 0) or (NodeIndex >= Nodes.Count) then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      result := Nodes[NodeIndex];
    except
      Inc(ErrorCount);
      result := -1;
    end;
  finally
    ANE_INT32_PTR(reply)^ := result;
  end;
end;

procedure GCondensedIntersectContoursNodeDistance(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  param: PParameter_array;
  P1, P2: ANE_INT32_PTR;
  ContourNumber: ANE_INT32;
  NodeIndex: ANE_INT32;
  NodeDistances: TRealList;
  result: ANE_DOUBLE;
begin
  result := -1;
  try
    try
      if numParams <> 2 then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      param := @parameters^;
      P1 := param^[0];
      ContourNumber := P1^;
      P2 := param^[1];
      NodeIndex := P2^;
      if (ContourNumber < 0) or (ContourNumber >= CondensedNodeDist.Count) then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      NodeDistances := CondensedNodeDist[ContourNumber];
      if (NodeIndex < 0) or (NodeIndex >= NodeDistances.Count) then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      result := NodeDistances[NodeIndex];
    except
      Inc(ErrorCount);
      result := -1;
    end;
  finally
    ANE_DOUBLE_PTR(reply)^ := result;
  end;
end;


initialization
  NodeNumbers := TObjectList.Create;
  NodeDist := TObjectList.Create;
  ElementNumbers := TObjectList.Create;
  ContourIntersectLengths:= TRealList.Create;
  CondensedNodeNumbers := TObjectList.Create;
  CondensedNodeDist := TObjectList.Create;

finalization
  NodeNumbers.Free;
  NodeDist.Free;
  ElementNumbers.Free;
  ContourIntersectLengths.Free;
  CondensedNodeNumbers.Free;
  CondensedNodeDist.Free;

end.

