unit TriangulationUnit;

{
The interpolation method implemented in this unit takes too long to be
practical at the moment.  I think that the problem is that finding the triangle
containing the point of interest takes too long.  CACM Algorithm 624 has a
related algorithm that may provide ideas about how to implement this one better.

Because of the slowness of the main algorithm, I never got around to dealing
with the cases where
1, the point of interest lies outside the convex hull of the data points,
2. there are fewer than three data points,
3. all the data points lie on a straight line, or
4. several data points are at the same location.
}

interface

uses sysutils, Dialogs, Forms, classes, contnrs, AnePIE;

procedure InitializeTriangulation(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

procedure FreeTriangulation(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;

procedure EvaluateTriangulation(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;

implementation

uses DelaunayUnit, TurnDir, ConvexHullUnit;

type
  TTriangulationPoint = class(THullPoint)
    Value : double;
  end;

  TTriangulationData = Class(TObject)
    TopTriangle : TTopTriangle;
    Points : TObjectList;
    Hull : TList;
    Triangulation : TList;
    Left, Top, Right, Bottom : integer;
//    TriQuadTree : TRbwQuadTree;
    Constructor Create;
    Destructor Destroy; override;
    function InBox(const X, Y: double) : boolean;
    function InHull(const X, Y: double) : boolean;
    function Interpolate(const X, Y: double) : double;
    function Extrapolate(const X, Y: double) : double;
  end;

  TTriangulation_Record = record
    Data : TTriangulationData;
  end;

  PTriangulation_Record = ^TTriangulation_Record;

procedure InitializeTriangulation(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;
var
  Triangulation : TTriangulationData;
  Data : PTriangulation_Record;
  Point : TTriangulationPoint;
//  TempPoints : TList;
  Index : integer;
  TestValue : double;
//  TriIndex, NodeIndex : integer;
//  Triangle : TTriangle;
//  Point : TTriangulationPoint;
begin
  Triangulation := nil;
  Data := nil;
  try
    // Create the quattree with the calculate range.
    Triangulation := TTriangulationData.Create;
    Triangulation.Points.Capacity := numPoints;

    // Add all the data points to the quadtree and store the data value
    // in an array.
    for Index := 0 to numPoints -1 do
    begin
      Point := TTriangulationPoint.Create;
      Triangulation.Points.Add(Point);
      Point.Value := Values^;
      Point.X := xCoords^;
      Point.Y := yCoords^;
      Inc(xCoords);
      Inc(yCoords);
      Inc(Values);
    end;

    With Triangulation do
    begin
      MaximalConvexHull(Points, Hull);
      Hull.Add(Hull[0]);

      TopTriangle.Delaunay(Points, Triangulation);

{      for TriIndex := 0 to Triangulation.Count -1 do
      begin
        Triangle := Triangulation[TriIndex];
        for NodeIndex := 0 to 2 do
        begin
          Point := Triangle.Nodes[NodeIndex] as TTriangulationPoint;
          TriQuadTree.AddPoint(Point.X, Point.Y, Triangle);
        end;

      end;   }


      Left := 0;
      Point := Hull[0];
      TestValue := Point.Y;
      Top := 0;
      for Index := 1 to Hull.Count -1 do
      begin
        Point := Hull[Index];
        if TestValue < Point.Y then
        begin
          TestValue := Point.Y;
          Top := Index;
        end
        else
        begin
          Break;
        end;
      end;

      Point := Hull[Top];
      TestValue := Point.X;
      Right := Top;
      for Index := Top + 1 to Hull.Count -1 do
      begin
        Point := Hull[Index];
        if TestValue < Point.X then
        begin
          TestValue := Point.X;
          Right := Index;
        end
        else
        begin
          Break;
        end;
      end;

      Point := Hull[Right];
      TestValue := Point.Y;
      Bottom := Right;
      for Index := Right + 1 to Hull.Count -1 do
      begin
        Point := Hull[Index];
        if TestValue > Point.Y then
        begin
          TestValue := Point.Y;
          Bottom := Index;
        end
        else
        begin
          Break;
        end;
      end;
    end;


    // Get a record that can be passed to Argus ONE
    GetMem(Data, SizeOf(TTriangulation_Record));

    // Put the quadtree in the record.
    Data^.Data := Triangulation;
  except on E: Exception do
    begin
      // If there is an error, release the allocated memory and
      // let the user know something went wrong.
      Triangulation.Free;
      FreeMem(Data);
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  rPIEHandle := @Data^;
end;


procedure FreeTriangulation(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;
var
  Triangulation : TTriangulationData;
  Data : PTriangulation_Record;
begin
  try
    // Get the Quadtree record from Argus;
    Data := pieHandle;
    Triangulation := Data^.Data;
    // Release the memory.
    Triangulation.Free;
    FreeMem(Data);
  except on E: Exception do
    begin
      // If there is an error, let the user know something went wrong.
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;



procedure EvaluateTriangulation(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; {var} rResult : ANE_DOUBLE_PTR) ; cdecl;
var
  Triangulation : TTriangulationData;
  Data : PTriangulation_Record;
//  resultPtr : ANE_DOUBLE_PTR;
begin
  try
    // Get the Quadtree record from Argus;
    Data := pieHandle;
    Triangulation := Data^.Data;
    rResult^ := Triangulation.Interpolate(X,Y);
  except on E: Exception do
    begin
      // If there is an error, let the user know something went wrong.
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

{ TTriangulationData }

constructor TTriangulationData.Create;
begin
  inherited;
  Points := TObjectList.Create;
  TopTriangle := TTopTriangle.Create;
  Hull := TList.Create;
  Triangulation := TList.Create;
//  TriQuadTree := TRbwQuadTree.Create(nil);
end;

destructor TTriangulationData.Destroy;
begin
  Hull.Free;
  TopTriangle.Free;
  Points.Free;
  Triangulation.Free;
//  TriQuadTree.Free;
  inherited;
end;

function TTriangulationData.Extrapolate(const X, Y: double): double;
var
  LowerIndex, UpperIndex, MiddleIndex : integer;
  APoint {, Point1, Point2} : TTriangulationPoint;
  DirectionList : TList;
  FindPoint : THullPoint;
begin
  result := 0;
  Exit;
  APoint := Hull[Left];
  if Y > APoint.Y then
  begin
    APoint := Hull[Top];
    if X < APoint.X then
    begin
      LowerIndex := Left;
      UpperIndex := Top;
    end
    else
    begin
      APoint := Hull[Right];
      if Y > APoint.Y then
      begin
        LowerIndex := Top;
        UpperIndex := Right;
      end
      else
      begin
        APoint := Hull[Bottom];
        if X > APoint.X then
        begin
          LowerIndex := Right;
          UpperIndex := Bottom;
        end
        else
        begin
          LowerIndex := Bottom;
          UpperIndex := Hull.Count-1;
          Assert(False);
        end;
      end;
    end;
  end
  else
  begin
    APoint := Hull[Bottom];
    if X < APoint.X then
    begin
      LowerIndex := Bottom;
      UpperIndex := Hull.Count -1;
    end
    else
    begin
      APoint := Hull[Right];
      if Y < APoint.Y then
      begin
        LowerIndex := Right;
        UpperIndex := Bottom;
      end
      else
      begin
        APoint := Hull[Top];
        if X > APoint.X then
        begin
          LowerIndex := Top;
          UpperIndex := Right;
        end
        else
        begin
          LowerIndex := Left;
          UpperIndex := Top;
          Assert(False);
        end;
      end;
    end;
  end;
  DirectionList := TList.Create;
  FindPoint := THullPoint.Create;
  try
    FindPoint.X := X;
    FindPoint.Y := Y;
    while ((UpperIndex-LowerIndex) > 1) do
    begin
      MiddleIndex := (UpperIndex+LowerIndex) div 2;
      // find the right point
    end;
    // get the result.
  finally
    DirectionList.Free;
    FindPoint.Free;
  end;
end;

function TTriangulationData.InBox(const X, Y: double) : boolean;
var
  APoint : TTriangulationPoint;
begin
  result := False;
  APoint := Hull[Left];
  if X < APoint.X then Exit;
  APoint := Hull[Top];
  if Y > APoint.Y then Exit;
  APoint := Hull[Right];
  if X > APoint.X then Exit;
  APoint := Hull[Bottom];
  if Y < APoint.Y then Exit;
  result := True;
end;

function TTriangulationData.InHull(const X, Y: double): boolean;
var
  {Index,} LowerIndex, UpperIndex, MiddleIndex : integer;
  APoint, Point1, Point2 : TTriangulationPoint;
  YOnLine : double;
begin
  result := InBox(X,Y);
  if not result then Exit;
  LowerIndex := Left;
  UpperIndex := Right;
  while ((UpperIndex-LowerIndex) > 1) do
  begin
    MiddleIndex := (UpperIndex+LowerIndex) div 2;
    APoint := Hull[MiddleIndex];
    if APoint.X < X then
    begin
      LowerIndex := MiddleIndex;
    end
    else
    begin
      UpperIndex := MiddleIndex;
    end;
  end;
  Point2 := Hull[UpperIndex];
  if Point2.X = X then
  begin
    if Point2.Y < Y then
    begin
      result := false;
      Exit;
    end;
  end
  else
  begin
    Point1 := Hull[LowerIndex];
    YOnLine := Point1.Y +
      (Point2.Y - Point1.Y)/(Point2.X-Point1.X)
      *(X-Point1.X);
    if YOnLine < Y then
    begin
      result := false;
      Exit;
    end;
  end;

  LowerIndex := Right;
  UpperIndex := Hull.Count-1;
  while ((UpperIndex-LowerIndex) > 1) do
  begin
    MiddleIndex := (UpperIndex+LowerIndex) div 2;
    APoint := Hull[MiddleIndex];
    if APoint.X > X then
    begin
      LowerIndex := MiddleIndex;
    end
    else
    begin
      UpperIndex := MiddleIndex;
    end;
  end;
  Point2 := Hull[UpperIndex];
  if Point2.X = X then
  begin
    if Point2.Y > Y then
    begin
      result := false;
      Exit;
    end;
  end
  else
  begin
    Point1 := Hull[LowerIndex];
    YOnLine := Point1.Y +
      (Point2.Y - Point1.Y)/(Point2.X-Point1.X)
      *(X-Point1.X);
    if YOnLine > Y then
    begin
      result := false;
      Exit;
    end;
  end;
end;

function TTriangulationData.Interpolate(const X, Y: double): double;
var
  FindPoint : THullPoint;
  Triangles : TList;
  Triangle : TTriangle;
  TriangleAreaTimeTwo : double;
  Factor1, Factor2, Factor3 : double;
  Point1, Point2, Point3 : TTriangulationPoint;
  Index : integer;
//  Xi, Yi: double;
//  Data: TPointerArray;
//  PointLocation: TInTriangle;
//  Edge : integer;
begin
  if not InHull(X,Y) then
  begin
    result := Extrapolate(X,Y);
  end
  else
  begin
{    FindPoint := THullPoint.Create;
//    Triangles := TList.Create;
    try
      result := 0;
      FindPoint.X := X;
      FindPoint.Y := Y;
      Xi := X;
      Yi := Y;
      TriQuadTree.FindClosestPointsData(Xi, Yi, Data);
      for Index := 0 to Length(Data) -1 do
      begin
        Triangle := Data[Index];
          // Use finite element basis function to get result.
        with Triangle do
        begin
          Triangle.GetPointLocation(FindPoint, PointLocation, Edge);
          if PointLocation <> tiOutside then
          begin
            Point1 := Nodes[0] as TTriangulationPoint;
            Point2 := Nodes[1] as TTriangulationPoint;
            Point3 := Nodes[2] as TTriangulationPoint;
            TriangleAreaTimeTwo
              := (Point1.X*Point2.Y - Point2.X*Point1.Y)
              +  (Point3.X*Point1.Y - Point1.X*Point3.Y)
              +  (Point2.X*Point3.Y - Point3.X*Point2.Y);
            Factor1 := 1/TriangleAreaTimeTwo *
               ((Point2.X*Point3.Y - Point3.X*Point2.Y)
                 + (Point2.Y-Point3.Y)*X
                 + (Point3.X-Point2.X)*Y);
            Factor2 := 1/TriangleAreaTimeTwo *
               ((Point3.X*Point1.Y - Point1.X*Point3.Y)
                 + (Point3.Y-Point1.Y)*X
                 + (Point1.X-Point3.X)*Y);
            Factor3 := 1/TriangleAreaTimeTwo *
               ((Point1.X*Point2.Y - Point2.X*Point1.Y)
                 + (Point1.Y-Point2.Y)*X
                 + (Point2.X-Point1.X)*Y);
            result := Factor1*Point1.Value
              + Factor2*Point2.Value
              + Factor3*Point3.Value;
          end;
          break;
        end;
      end;
    finally
      FindPoint.Free;
    end;
  end;    }

    FindPoint := THullPoint.Create;
    Triangles := TList.Create;
    try
      result := 0;
      FindPoint.X := X;
      FindPoint.Y := Y;
      TopTriangle.GetTriangles(FindPoint,Triangles);
      for Index := 0 to Triangles.Count -1 do
      begin
        Triangle := Triangles[Index];
        if not Triangle.HasTopPoint then
        begin
          // Use finite element basis function to get result.
          with Triangle do
          begin
            Point1 := Nodes[0] as TTriangulationPoint;
            Point2 := Nodes[1] as TTriangulationPoint;
            Point3 := Nodes[2] as TTriangulationPoint;
            TriangleAreaTimeTwo
              := (Point1.X*Point2.Y - Point2.X*Point1.Y)
              +  (Point3.X*Point1.Y - Point1.X*Point3.Y)
              +  (Point2.X*Point3.Y - Point3.X*Point2.Y);
            Factor1 := 1/TriangleAreaTimeTwo *
               ((Point2.X*Point3.Y - Point3.X*Point2.Y)
                 + (Point2.Y-Point3.Y)*X
                 + (Point3.X-Point2.X)*Y);
            Factor2 := 1/TriangleAreaTimeTwo *
               ((Point3.X*Point1.Y - Point1.X*Point3.Y)
                 + (Point3.Y-Point1.Y)*X
                 + (Point1.X-Point3.X)*Y);
            Factor3 := 1/TriangleAreaTimeTwo *
               ((Point1.X*Point2.Y - Point2.X*Point1.Y)
                 + (Point1.Y-Point2.Y)*X
                 + (Point2.X-Point1.X)*Y);
            result := Factor1*Point1.Value
              + Factor2*Point2.Value
              + Factor3*Point3.Value;
          end;
          break;
        end;

      end;
    finally
      FindPoint.Free;
      Triangles.Free;
    end;
  end;
end;

end.
