unit ConvexHullUnit;

{
References:

de Berg, Mark; van Kreveld, Mark; Overmars, Mark; Schwarzkopf, Otfried.
  2000. Computational Geometry, Algorithms and Applications. Second Edition.
  Springer, Berlin. 367 p.

}

interface

uses Classes, TurnDir;

procedure ConvexHull(const InputList, OutputList : TList);
// InputList contains all THullPoints.
// When the procedure is done, OutputList contains those points on the
// Convex Hull of the points in InputList in a clockwise order.
// The InputList is sorted in ConvexHull;

procedure MaximalConvexHull(const InputList, OutputList : TList);
// Like ConvexHull except that the output contains all points that intersect
// the convex hull, not just the minimal set required to define the convex hull.
// All points in the input list are assumed to occur at unique locations.

implementation

uses Math, Determ;

function RSign(const AValue : double) : integer;
begin
  result := 0;
  if AValue < 0 then
  begin
    result := -1;
  end
  else if AValue > 0 then
  begin
    result := 1;
  end

end;

function CompareHullPoints (Item1, Item2: Pointer): Integer;
var
  Point1, Point2 : THullPoint;
begin
  Point1 := Item1;
  Point2 := Item2;
  result := RSign(Point1.X - Point2.X);
  if result = 0 then
  begin
    result := RSign(Point1.Y - Point2.Y);
  end;
end;

function RightTurn(const HullList : TList) : boolean;
begin
  result := TurnDirection(HullList) = tdRight;
end;

procedure ConvexHull(const InputList, OutputList : TList);
var
  Index : integer;
  Procedure UpdateHull;
  begin
    // add the current point to the OutputList.
    OutputList.Add(InputList[Index]);
    while (OutputList.Count > 2) and not RightTurn(OutputList) do
    begin
      // If you didn't make a right turn, the previous point was not
      // on the convex hull.
      OutputList.Delete(OutputList.Count -2);
    end;
  end;
begin
  // make sure nothing is in OutputList.
  OutputList.Clear;

  // make sure that OutputList is big enough
  OutputList.Capacity := InputList.Count;

  // Take care of a trivial case
  if InputList.Count < 3 then
  begin
    for Index := 0 to InputList.Count-1 do
    begin
      OutputList.Add(InputList[Index]);
    end;

//    OutputList.Assign(InputList);
    Exit;
  end;

  // Sort the input list from lowest to highest X.
  // In the event of ties, sort from lowest to highest Y.
  InputList.Sort(CompareHullPoints);

  // Loop over the InputList and update the convex hull for each point.
  for Index := 0 to InputList.Count -1 do
  begin
    UpdateHull;
  end;
  // Now we have the upper half of the convex hull.

  // Loop over the InputList and update the convex hull for each point.
  // However, skip the last point in the InputList; it has already been added.
  for Index := InputList.Count -2 downto 0 do
  begin
    UpdateHull;
  end;

  // The first point has been added twice; once at the beginning and
  // once at the end.  Delete the second copy.
  // We did need to add it to check that points prior to it weren't
  // on the convex hull but we don't want two copies of it in the
  // OutputList.
  OutputList.Delete(OutputList.Count -1);

  // Release unneeded memory.
  OutputList.Capacity := OutputList.Count;
end;

function RightTurnOrStraight(const HullList : TList) : boolean;
begin
  result := TurnDirection(HullList) <> tdLeft;
end;

procedure MaximalConvexHull(const InputList, OutputList : TList);
var
  Index : integer;
  Procedure UpdateHull;
  begin
    // add the current point to the OutputList.
    OutputList.Add(InputList[Index]);
    while (OutputList.Count > 2) and not RightTurnOrStraight(OutputList) do
    begin
      // If you didn't make a right turn, the previous point was not
      // on the maximal convex hull.
      OutputList.Delete(OutputList.Count -2);
    end;
  end;
begin
  // make sure nothing is in OutputList.
  OutputList.Clear;

  // make sure that OutputList is big enough
  OutputList.Capacity := InputList.Count;

  // Take care of a trivial case
  if InputList.Count < 3 then
  begin
    for Index := 0 to InputList.Count-1 do
    begin
      OutputList.Add(InputList[Index]);
    end;
//    OutputList.Assign(InputList);
    Exit;
  end;

  // Sort the input list from lowest to highest X.
  // In the event of ties, sort from lowest to highest Y.
  InputList.Sort(CompareHullPoints);

  // Loop over the InputList and update the convex hull for each point.
  for Index := 0 to InputList.Count -1 do
  begin
    UpdateHull;
  end;
  // Now we have the upper half of the convex hull.

  // Loop over the InputList and update the convex hull for each point.
  // However, skip the last point in the InputList; it has already been added.
  for Index := InputList.Count -2 downto 0 do
  begin
    UpdateHull;
  end;

  // The first point has been added twice; once at the beginning and
  // once at the end.  Delete the second copy.
  // We did need to add it to check that points prior to it weren't
  // on the convex hull but we don't want two copies of it in the
  // OutputList.
  OutputList.Delete(OutputList.Count -1);

  // Release unneeded memory.
  OutputList.Capacity := OutputList.Count;
end;

end.
