unit SolidGeom;

interface

uses Sysutils, classes;

const
  DIM = 3;

var
  MinX, MinY, MinZ, MaxX, MaxY, MaxZ : double;

type
  TZResult = (zrNotOnLine, zrVertical, zrNotOnSegment, zrOnSegment);
  TLineIntersectionResult = (irOverlap, irSegmentsCross,
    irLinesCross, irParallel, irSkew);
  TPlaneLineIntersection = (pliSegmentCross, pliLinesCross, pliParallel);
  TPlaneIntersection = (piOutlinesCross, piPlanesCross, piParallel, piCoplanar);
  TIsInsideResult = (iiInside, iiOutside, iiEdge, iiVertex);

  ESizeError = class(Exception);

  TXYZLocation = record
    X : extended;
    Y : extended;
    Z : extended;
  end;

  PPointD = ^TPointd;
  TPointd = array[0..DIM-1] of extended;
    // extended point //adapted from "Computational Geometry in C"

  TElevationsLocations = array[0..2] of TXYZLocation;

  TPointObject = class (TObject)
  private
    function GetXYZLocation : TXYZLocation;
    Procedure SetXYZLocation(ALocation : TXYZLocation);
  public
    Location : TPointd;
    Property X : extended read Location[0] write Location[0];
    property Y : extended read Location[1] write Location[1];
    property Z : extended read Location[2] write Location[2];
    property XYZLocation : TXYZLocation read GetXYZLocation
      write SetXYZLocation;
  end;

  TXYZSegment = class(TObject)
    Private
    function GetThirdVariable(X1,X2,Y1,Y2,Z1,Z2,X,Y : extended; Var Z : extended): TZResult;
    public
    Start : TXYZLocation;
    Stop  : TXYZLocation;
    function Alpha : extended;
    function Beta : extended;
    function Gamma : extended;
    function Intersection (AnotherSegment : TXYZSegment;
      var IntersectionPoint : TXYZLocation) : TLineIntersectionResult; overload;
    function Intersection (AnotherSegment : TXYZSegment;
      var IntersectionLine : TXYZSegment) : boolean; overload;
      // returns true if the lines are not parallel
      // and false if they are parallel.
    function GetX (Y,Z : extended; Var X : extended): TZResult;
    function GetY (X,Z : extended; Var Y : extended): TZResult;
    function GetZ (X,Y : extended; Var Z : extended): TZResult;
    function Length : extended;
  end;

  TXYZPlane = class(TObject)
  private
    FCount : Integer;
    FOutline : array of TXYZLocation;
      // FOutline does not include a repetition of the first location.
    FElevations : TElevationsLocations;
    procedure SetCount (const ACount : integer);
    function GetOutlineLocation(Index : integer) : TXYZLocation;
    procedure SetOutlineLocation(Index : integer; ALocation : TXYZLocation);
    function IsInside(ALocation : TXYZLocation) : TIsInsideResult;
    procedure GetCoefficients(var A, B, C, D : extended);
    procedure Normalize(var vector: TXYZLocation);
    Procedure SetElevations(Locations : TElevationsLocations);
    procedure GetCoefficientsFromElevations(var A, B, C, D: extended);
    function GetInterceptPoints(IntersectionSegment: TXYZSegment;
      PointList: TList): boolean;
  public
    bmin, bmax : TPointd;
    function Intersection(ASegment : TXYZSegment;
      var IntersectionPoint : TXYZLocation) : TPlaneLineIntersection; overload;
    function PlaneIntersection (APlane : TXYZPlane;
      {var IntersectionSegment : TXYZSegment;} SegmentList : TList) : TPlaneIntersection; overload;
    property Count : integer read FCount write SetCount;
    property Outline[Index : integer] : TXYZLocation read GetOutlineLocation write SetOutlineLocation;
    Constructor Create(Const ACount : integer);
    function Area : extended;
    property Elevations : TElevationsLocations read FElevations write SetElevations;
    procedure SetBox;
  end;

  TXYZPlaneList = class(TObject)
  private
    FList : TList;
    function GetItems(Index: integer): TXYZPlane;
    procedure SetItems(Index: integer; const Value: TXYZPlane);
  public
    property Items[Index : integer] :TXYZPlane read GetItems write SetItems; default;
    procedure Add(APolygon : TXYZPlane);
    function Count : integer;
    Constructor Create;
    Destructor Destroy; override;
    function Remove(APolygon : TXYZPlane): Integer;
  end;

function NearlyTheSame(const X,Y, Epsilon : extended) : boolean; overload;

function NearlyTheSame(const Loc1,Loc2 : TPointd; Epsilon : extended) : boolean; overload;



implementation

Uses Math, VertexUnit, SegmentUnit, IntListUnit, RealListUnit, SolidUnit,
  doublePolyhedronUnit

          {$IFDEF DEBUG}
          , ZFunction, Dialogs, DebugUnit
          {$ENDIF}

;

function NearlyTheSame(const X,Y, Epsilon : extended) : boolean;
begin
  result := (X = Y)
    or (Abs(X-Y) < Epsilon)
    or (Abs(X-Y)/(Abs(X)+Abs(Y)+Epsilon) < Epsilon);
end;

function NearlyTheSame(const Loc1,Loc2 : TPointd; Epsilon : extended) : boolean; overload;
var
  DimIndex : integer;
begin
//  result := True;
  for DimIndex := X to Z do
  begin
    result := NearlyTheSame(Loc1[DimIndex],Loc2[DimIndex],Epsilon);
    if not result then Exit;
  end;

end;

function NearlyTheSame(const Loc1Point,Loc2Point : TXYZLocation; Epsilon : extended) : boolean; overload;
var
  Converter : TPointObject;
  Loc1,Loc2 : TPointd;
begin
  Converter := TPointObject.Create;
  try
    Converter.XYZLocation := Loc1Point;
    Loc1 := Converter.Location;
    Converter.XYZLocation := Loc2Point;
    Loc2 := Converter.Location;
    result := NearlyTheSame(Loc1,Loc2, Epsilon);
  finally
    Converter.Free;
  end;

end;
{ TXYZSegment }

function TXYZSegment.Alpha: extended;
begin
  result := Stop.X - Start.X;
end;

function TXYZSegment.Beta: extended;
begin
  result := Stop.Y - Start.Y;
end;

function TXYZSegment.Gamma: extended;
begin
  result := Stop.Z - Start.Z;
end;

function TXYZSegment.GetThirdVariable(X1, X2, Y1, Y2, Z1, Z2, X, Y: extended;
  var Z: extended): TZResult;
{const
  Epsilon = 1e-8; }
var
  Alpha1, Beta1 : extended;
  YTest : extended;
  LowerX, HigherX, LowerY, HigherY : extended;
begin
  Alpha1 := X2-X1;
  if (Alpha1 = 0) and (X <> X1) then
  begin
    result := zrNotOnLine;
  end
  else
  begin
    Beta1 := Y2-Y1;
    If ((Beta1 = 0) and (Y <> Y1))
    then
    begin
      result := zrNotOnLine;
    end
    else
    begin
      LowerX := Min(X1, X2);
      LowerY := Min(Y1, Y2);
      HigherX := Max(X1, X2);
      HigherY := Max(Y1, Y2);

      if (LowerX <= X) and (LowerY <= Y)
        and (X <= HigherX) and (Y <= HigherY)
      then
      begin
        result := zrOnSegment;
      end
      else
      begin
        result := zrNotOnSegment;
      end;

      if (Alpha1 = 0) and (Beta1 = 0) then
      begin
        result := zrVertical;
        Z := Min(Z1, Z2);
      end
      else
      begin
        if Beta1 = 0 then
        begin
          YTest := Y1;
        end
        else
        begin
          if Alpha1 = 0 then
          begin
              YTest := Y;
          end
          else
          begin
            YTest := Y1 + Beta1 * (X-X1)/Alpha1;
          end;
        end;
        if NearlyTheSame(YTest,Y,Epsilon) then
        begin
          if (Alpha1 = 0) then
          begin
            Z := Z1 + Gamma * (Y-Y1)/Beta1;
          end
          else
          begin
            Z := Z1 + Gamma * (X-X1)/Alpha1;
          end
        end
        else
        begin
          result := zrNotOnLine;
        end;
      end;
    end;
  end;
end;

function TXYZSegment.GetX(Y, Z: extended; var X: extended): TZResult;
begin
  result := GetThirdVariable(Start.Y, Stop.Y,
    Start.Z, Stop.Z, Start.X, Stop.X, Y, Z, X);
end;

function TXYZSegment.GetY(X, Z: extended; var Y: extended): TZResult;
begin
  result := GetThirdVariable(Start.X, Stop.X,
    Start.Z, Stop.Z, Start.Y, Stop.Y, X, Z, Y);
end;

function TXYZSegment.GetZ(X, Y: extended; var Z: extended): TZResult;
begin
  result := GetThirdVariable(Start.X, Stop.X,
    Start.Y, Stop.Y, Start.Z, Stop.Z, X, Y, Z);
end;

function TXYZSegment.Intersection(AnotherSegment: TXYZSegment;
  var IntersectionPoint: TXYZLocation): TLineIntersectionResult;
{const
  Epsilon = 1e-6; }
var
  ZResult1, ZResult2 : TZResult;
  Z1, Z2 : extended;
  IntersectionLine : TXYZSegment;
  LowerValue, HigherValue : extended;
begin
  if Intersection(AnotherSegment,IntersectionLine) then
  begin
    //  irSegmentsCross, irLinesCross, irSkew);
    if NearlyTheSame(IntersectionLine.Start, IntersectionLine.Stop, Epsilon) then
    begin
      //  irSegmentsCross, irLinesCross);
      IntersectionPoint := IntersectionLine.Start;
      result := irSegmentsCross;
      LowerValue := Min(Start.X, Stop.X);
      HigherValue := Max(Start.X, Stop.X);
      if (IntersectionPoint.X < LowerValue)
        or (IntersectionPoint.X > HigherValue) then
      begin
        result := irLinesCross;
      end;
      if result = irSegmentsCross then
      begin
        LowerValue := Min(Start.Y, Stop.Y)-Epsilon;
        HigherValue := Max(Start.Y, Stop.Y)+Epsilon;
        if (IntersectionPoint.Y < LowerValue)
          or (IntersectionPoint.Y > HigherValue) then
        begin
          result := irLinesCross;
        end;
      end;
      if result = irSegmentsCross then
      begin
        LowerValue := Min(Start.Z, Stop.Z)-Epsilon;
        HigherValue := Max(Start.Z, Stop.Z)+Epsilon;
        if (IntersectionPoint.Z < LowerValue)
          or (IntersectionPoint.Z > HigherValue) then
        begin
          result := irLinesCross;
        end;
      end;
      if result = irSegmentsCross then
      begin
        LowerValue := Min(AnotherSegment.Start.X, AnotherSegment.Stop.X)-Epsilon;
        HigherValue := Max(AnotherSegment.Start.X, AnotherSegment.Stop.X)+Epsilon;
        if (IntersectionPoint.X < LowerValue)
          or (IntersectionPoint.X > HigherValue) then
        begin
          result := irLinesCross;
        end;
      end;
      if result = irSegmentsCross then
      begin
        LowerValue := Min(AnotherSegment.Start.Y, AnotherSegment.Stop.Y)-Epsilon;
        HigherValue := Max(AnotherSegment.Start.Y, AnotherSegment.Stop.Y)+Epsilon;
        if (IntersectionPoint.Y < LowerValue)
          or (IntersectionPoint.Y > HigherValue) then
        begin
          result := irLinesCross;
        end;
      end;
      if result = irSegmentsCross then
      begin
        LowerValue := Min(AnotherSegment.Start.Z, AnotherSegment.Stop.Z)-Epsilon;
        HigherValue := Max(AnotherSegment.Start.Z, AnotherSegment.Stop.Z)+Epsilon;
        if (IntersectionPoint.Z < LowerValue)
          or (IntersectionPoint.Z > HigherValue) then
        begin
          result := irLinesCross;
        end;
      end;
    end
    else
    begin
      //  irSkew);
      result := irSkew;
    end;
    IntersectionLine.Free;
  end
  else
  begin
    // irOverlap,  irParallel);
    ZResult1 := GetZ(Start.X,Start.Y, Z1);
    ZResult2 := GetZ(Stop.X,Stop.Y, Z2);
    if ZResult1 = zrVertical then
    begin
      // irOverlap,  irParallel);
      if ZResult2 = zrVertical then
      begin
        if  (AnotherSegment.Start.X <> Start.X)
          or  (AnotherSegment.Start.Y <> Start.Y) then
        begin
          result := irParallel;
          Exit;
        end;

        // irOverlap, irParallel
        result := irOverlap;
        LowerValue := Min(AnotherSegment.Start.Z, AnotherSegment.Stop.Z);
        HigherValue := Max(AnotherSegment.Start.Z, AnotherSegment.Stop.Z);
        if (LowerValue <= Start.Z) and (Start.Z <= HigherValue) then
        begin
          IntersectionPoint.X := Start.X;
          IntersectionPoint.Y := Start.Y;
          IntersectionPoint.Z := Start.Z;
        end
        else if (LowerValue <= Stop.Z) and (Stop.Z <= HigherValue) then
        begin
          IntersectionPoint.X := Stop.X;
          IntersectionPoint.Y := Stop.Y;
          IntersectionPoint.Z := Stop.Z;
        end
        else
        begin
          LowerValue := Min(Start.Z, Stop.Z);
          HigherValue := Max(Start.Z, Stop.Z);
          if (LowerValue <= AnotherSegment.Start.Z) and (AnotherSegment.Start.Z <= HigherValue) then
          begin
            IntersectionPoint.X := AnotherSegment.Start.X;
            IntersectionPoint.Y := AnotherSegment.Start.Y;
            IntersectionPoint.Z := AnotherSegment.Start.Z;
          end
          else if (LowerValue <= AnotherSegment.Stop.Z) and (AnotherSegment.Stop.Z <= HigherValue) then
          begin
            IntersectionPoint.X := AnotherSegment.Stop.X;
            IntersectionPoint.Y := AnotherSegment.Stop.Y;
            IntersectionPoint.Z := AnotherSegment.Stop.Z;
          end
          else
          begin
            result := irParallel;
          end;
        end;
      end
      else
      begin
        // irParallel);
        result := irParallel
      end;
    end
    else
    begin
      // irOverlap,  irParallel);
      if Z1 = Z2 then
      begin
        // irOverlap,  irParallel);
        result := irOverlap;
        LowerValue := Min(AnotherSegment.Start.Z, AnotherSegment.Stop.Z);
        HigherValue := Max(AnotherSegment.Start.Z, AnotherSegment.Stop.Z);
        if (LowerValue <= Start.Z) and (Start.Z <= HigherValue) then
        begin
          IntersectionPoint.X := Start.X;
          IntersectionPoint.Y := Start.Y;
          IntersectionPoint.Z := Start.Z;
        end
        else if (LowerValue <= Stop.Z) and (Stop.Z <= HigherValue) then
        begin
          IntersectionPoint.X := Stop.X;
          IntersectionPoint.Y := Stop.Y;
          IntersectionPoint.Z := Stop.Z;
        end
        else
        begin
          LowerValue := Min(Start.Z, Stop.Z);
          HigherValue := Max(Start.Z, Stop.Z);
          if (LowerValue <= AnotherSegment.Start.Z) and (AnotherSegment.Start.Z <= HigherValue) then
          begin
            IntersectionPoint.X := AnotherSegment.Start.X;
            IntersectionPoint.Y := AnotherSegment.Start.Y;
            IntersectionPoint.Z := AnotherSegment.Start.Z;
          end
          else if (LowerValue <= AnotherSegment.Stop.Z) and (AnotherSegment.Stop.Z <= HigherValue) then
          begin
            IntersectionPoint.X := AnotherSegment.Stop.X;
            IntersectionPoint.Y := AnotherSegment.Stop.Y;
            IntersectionPoint.Z := AnotherSegment.Stop.Z;
          end
          else
          begin
            result := irParallel;
          end;
        end;
      end
      else
      begin
      // irParallel);
        result := irParallel;
      end;
    end;
  end;

end;


function TXYZSegment.Intersection(AnotherSegment: TXYZSegment;
  var IntersectionLine: TXYZSegment): boolean;
// http://www.mhri.edu.au/~pdb/geometry/lineline3d/
// http://astronomy.swin.edu.au/~pbourke/geometry/lineline3d/
Const
  EPS = 1e-8;
var
  p1, p2, p3, p4 : TXYZLocation;
  p13,p43,p21 : TXYZLocation;
  d1343,d4321,d1321,d4343,d2121 : extended;
  numer,denom : extended;
  mua, mub : extended;
begin
  result := true;
  p1 := Start;
  p2 := Stop;
  p3 := AnotherSegment.Start;
  p4 := AnotherSegment.Stop;

  p13.x := p1.x - p3.x;
  p13.y := p1.y - p3.y;
  p13.z := p1.z - p3.z;
  p43.x := p4.x - p3.x;
  p43.y := p4.y - p3.y;
  p43.z := p4.z - p3.z;
  if ((ABS(p43.x)  < EPS) and (ABS(p43.y)  < EPS) and (ABS(p43.z)  < EPS)) then
  begin
    result := False;
    Exit;
  end;

//  if result then
//  begin
    p21.x := p2.x - p1.x;
    p21.y := p2.y - p1.y;
    p21.z := p2.z - p1.z;
    if ((ABS(p21.x)  < EPS) and (ABS(p21.y)  < EPS) and (ABS(p21.z)  < EPS)) then
    begin
      result := False;
      Exit;
    end;
//  end;
//  if result then
//  begin
    d1343 := p13.x * p43.x + p13.y * p43.y + p13.z * p43.z;
    d4321 := p43.x * p21.x + p43.y * p21.y + p43.z * p21.z;
    d1321 := p13.x * p21.x + p13.y * p21.y + p13.z * p21.z;
    d4343 := p43.x * p43.x + p43.y * p43.y + p43.z * p43.z;
    d2121 := p21.x * p21.x + p21.y * p21.y + p21.z * p21.z;
    denom := d2121 * d4343 - d4321 * d4321;
    if (ABS(denom) < EPS) then
    begin
      result := False;
      Exit;
    end;
//  end;
//  if result then
//  begin
    numer := d1343 * d4321 - d1321 * d4343;
          {$IFDEF DEBUG}
          If (CurrentVertex.NodeIndex = 5728) then
            WriteDebugOutput('numer = ' + FloatToStr(numer));
          {$ENDIF}

    mua := numer / denom;
    mub := (d1343 + d4321 * (mua)) / d4343;
          {$IFDEF DEBUG}
          If (CurrentVertex.NodeIndex = 5728) then
          begin
            WriteDebugOutput('mua = ' + FloatToStr(mua));
            WriteDebugOutput('mub = ' + FloatToStr(mub));
          end;
          {$ENDIF}

    IntersectionLine := TXYZSegment.Create;

    IntersectionLine.Start.x := p1.x + mua * p21.x;
    IntersectionLine.Start.y := p1.y + mua * p21.y;
    IntersectionLine.Start.z := p1.z + mua * p21.z;
    IntersectionLine.Stop.x := p3.x + mub * p43.x;
    IntersectionLine.Stop.y := p3.y + mub * p43.y;
    IntersectionLine.Stop.z := p3.z + mub * p43.z;

//  end;
end;

function TXYZSegment.Length: extended;
begin
  result := Sqrt(Sqr(Start.X -Stop.X)
    + Sqr(Start.Y -Stop.Y) + Sqr(Start.Z -Stop.Z));
end;

{ TXYZPlane }

procedure TXYZPlane.Normalize(var vector : TXYZLocation);
var
  Length : extended;
begin
  Length := Sqrt(Sqr(vector.X) + Sqr(vector.Y) + Sqr(vector.Z));
  vector.X := vector.X/Length;
  vector.Y := vector.Y/Length;
  vector.Z := vector.Z/Length;
end;

function TXYZPlane.Intersection(ASegment: TXYZSegment;
  var IntersectionPoint: TXYZLocation): TPlaneLineIntersection;
//  See http://www.mhri.edu.au/~pdb/geometry/linefacet/
const
  EPS = 1e-8;
var
  d: extended;
  denom, mu : extended;
  n, pa, pb, pc, p1, p2 : TXYZLocation;
begin
  pa := FOutline[0];
  pb := FOutline[1];
  pc := FOutline[2];
  p1 := ASegment.Start;
  p2 := ASegment.Stop;
  // Calculate the parameters for the plane
  n.X := (pb.Y - pa.Y)*(pc.Z - pa.Z) - (pb.z - pa.z)*(pc.y - pa.y);
  n.Y := (pb.z - pa.z)*(pc.x - pa.x) - (pb.x - pa.x)*(pc.z - pa.z);
  n.Z := (pb.x - pa.x)*(pc.y - pa.y) - (pb.y - pa.y)*(pc.x - pa.x);
  Normalize(n);
  d := - n.x * pa.x - n.y * pa.y - n.z * pa.z;
  // Calculate the position on the line that intersects the plane */
   denom := n.x * (p2.x - p1.x) + n.y * (p2.y - p1.y) + n.z * (p2.z - p1.z);
   if (ABS(denom) < EPS) then         // Line and plane don't intersect
   begin
      result := pliParallel
   end
   else
   begin
     mu := - (d + n.x * p1.x + n.y * p1.y + n.z * p1.z) / denom;
     IntersectionPoint.x := p1.x + mu * (p2.x - p1.x);
     IntersectionPoint.y := p1.y + mu * (p2.y - p1.y);
     IntersectionPoint.z := p1.z + mu * (p2.z - p1.z);
     if (mu < 0) or (mu > 1) then  //* Intersection not along line segment */
     begin
       result := pliLinesCross
     end
     else
     begin
       //* Determine whether or not the intersection point inside the face
       if IsInside(IntersectionPoint) <> iiOutside then
       begin
         result := pliSegmentCross;
       end
       else
       begin
         result := pliLinesCross;
       end;
     end;
   end;
 end;

function TXYZPlane.GetOutlineLocation(Index: integer): TXYZLocation;
begin
  result := FOutline[Index];
end;

function TXYZPlane.GetInterceptPoints(IntersectionSegment : TXYZSegment;
  PointList : TList) : boolean;
{const
  Epsilon = 1e-8; }
var
  BoundarySegment : TXYZSegment;
  Index : integer;
  IntersectLocation : TXYZLocation;
  APoint : TPointObject;
  PointsAdded : integer;
  LineIntersectionResult : TLineIntersectionResult;
begin
  PointsAdded := 0;
  Count := Count+1;
  try

    FOutline[Count-1] := FOutline[0];
    BoundarySegment := TXYZSegment.Create;
    try
      for Index := 0 to Count -2 do
      begin
        BoundarySegment.Start := FOutline[Index];
        BoundarySegment.Stop := FOutline[Index+1];
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then
          begin
            WriteDebugOutput('Epsilon = ' + FloatToStr(Epsilon));
            WriteDebugOutput('BoundarySegment.Start.X = ' + FloatToStr(BoundarySegment.Start.X));
            WriteDebugOutput('BoundarySegment.Stop.X = ' + FloatToStr(BoundarySegment.Stop.X));
            WriteDebugOutput('BoundarySegment.Start.Y = ' + FloatToStr(BoundarySegment.Start.Y));
            WriteDebugOutput('BoundarySegment.Stop.Y = ' + FloatToStr(BoundarySegment.Stop.Y));
            WriteDebugOutput('BoundarySegment.Start.Z = ' + FloatToStr(BoundarySegment.Start.Z));
            WriteDebugOutput('BoundarySegment.Stop.Z = ' + FloatToStr(BoundarySegment.Stop.Z));
            WriteDebugOutput('IntersectionSegment.Start.X = ' + FloatToStr(IntersectionSegment.Start.X));
            WriteDebugOutput('IntersectionSegment.Stop.X = ' + FloatToStr(IntersectionSegment.Stop.X));
            WriteDebugOutput('IntersectionSegment.Start.Y = ' + FloatToStr(IntersectionSegment.Start.Y));
            WriteDebugOutput('IntersectionSegment.Stop.Y = ' + FloatToStr(IntersectionSegment.Stop.Y));
            WriteDebugOutput('IntersectionSegment.Start.Z = ' + FloatToStr(IntersectionSegment.Start.Z));
            WriteDebugOutput('IntersectionSegment.Stop.Z = ' + FloatToStr(IntersectionSegment.Stop.Z));
          end;
          {$ENDIF}
        LineIntersectionResult := IntersectionSegment.Intersection
          (BoundarySegment, IntersectLocation);
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then WriteDebugOutput('LineIntersectionResult = ' + IntToStr(Ord(LineIntersectionResult)));
          {$ENDIF}
        if (LineIntersectionResult = irOverlap)
          or (LineIntersectionResult = irSegmentsCross)
          or (LineIntersectionResult = irLinesCross) then
        begin
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then
          begin
            WriteDebugOutput('IntersectLocation.X = ' + FloatToStr(IntersectLocation.X));
            WriteDebugOutput('IntersectLocation.Y = ' + FloatToStr(IntersectLocation.Y));
            WriteDebugOutput('IntersectLocation.Z = ' + FloatToStr(IntersectLocation.Z));
          end;
          {$ENDIF}
          If    ((Min(BoundarySegment.Start.X,BoundarySegment.Stop.X)  <= IntersectLocation.X+Epsilon) or
                  (NearlyTheSame(Min(BoundarySegment.Start.X,BoundarySegment.Stop.X),IntersectLocation.X,Epsilon )))
            and ((IntersectLocation.X-Epsilon <= Max(BoundarySegment.Start.X,BoundarySegment.Stop.X) ) or
                  (NearlyTheSame(IntersectLocation.X,Max(BoundarySegment.Start.X,BoundarySegment.Stop.X),Epsilon )))
            and ((Min(BoundarySegment.Start.Y,BoundarySegment.Stop.Y)  <= IntersectLocation.Y+Epsilon) or
                  (NearlyTheSame(Min(BoundarySegment.Start.Y,BoundarySegment.Stop.Y),IntersectLocation.Y,Epsilon )))
            and ((IntersectLocation.Y-Epsilon <= Max(BoundarySegment.Start.Y,BoundarySegment.Stop.Y) ) or
                  (NearlyTheSame(IntersectLocation.Y,Max(BoundarySegment.Start.Y,BoundarySegment.Stop.Y),Epsilon )))
            and ((Min(BoundarySegment.Start.Z,BoundarySegment.Stop.Z)  <= IntersectLocation.Z+Epsilon) or
                  (NearlyTheSame(Min(BoundarySegment.Start.Z,BoundarySegment.Stop.Z),IntersectLocation.Z,Epsilon )))
            and ((IntersectLocation.Z-Epsilon <= Max(BoundarySegment.Start.Z,BoundarySegment.Stop.Z) ) or
                  (NearlyTheSame(IntersectLocation.Z,Max(BoundarySegment.Start.Z,BoundarySegment.Stop.Z),Epsilon )))
            then
          begin
            APoint := TPointObject.Create;
            APoint.XYZLocation := IntersectLocation;
            PointList.Add(APoint);
            Inc(PointsAdded);
          end
        end;
      end;
    finally
      BoundarySegment.Free;
    end;


  finally
    Count := Count-1;
  end;
  result := (PointsAdded > 1)
end;


function TXYZPlane.PlaneIntersection(APlane: TXYZPlane;
  SegmentList : TList): TPlaneIntersection;
// http://doctormath.com/faq/formulas/faq.analygeom_3.html#threeplanes
// http://www.mhri.edu.au/~pdb/geometry/cliplinetopoly/
  function Determinant(R1C1, R1C2, R2C1, R2C2: extended) : extended;
  begin
    result := R1C1*R2C2 - R1C2*R2C1;
  end;
{Const
  Epsilon = 1e-8; }
var
  A1, B1, C1, D1, A2, B2, C2, D2 : extended;
  a, b, c : extended;
  aPrime, bPrime, cPrime : extended;
  denominator : extended;
  factor : extended;
  X1,Y1,Z1 : extended;
  DeterAD, DeterBD, DeterCD : extended;
  APoint, AnotherPoint : TPointObject;
  PointList : TList;
  PointIndex : integer;
  InsideLocation : TXYZLocation;
  SegObject : TSegmentObject;
  IntersectionSegment : TXYZSegment;
begin
  GetCoefficients(A1, B1, C1, D1);
  APlane.GetCoefficients(A2, B2, C2, D2);
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then
          begin
            WriteDebugOutput('A1 = ' + FloatToStr(A1));
            WriteDebugOutput('B1 = ' + FloatToStr(B1));
            WriteDebugOutput('C1 = ' + FloatToStr(C1));
            WriteDebugOutput('D1 = ' + FloatToStr(D1));
            WriteDebugOutput('A2 = ' + FloatToStr(A2));
            WriteDebugOutput('B2 = ' + FloatToStr(B2));
            WriteDebugOutput('C2 = ' + FloatToStr(C2));
            WriteDebugOutput('D2 = ' + FloatToStr(D2));
          end;
          {$ENDIF}
  if (A1=A2) and (B1=B2) and (C1=C2) and (D1=D2) then
  begin
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then WriteDebugOutput('piCoplanar');
          {$ENDIF}
    result := piCoplanar;
  end
  else
  begin
    a := Determinant(B1,C1,B2,C2);
    b := Determinant(C1,A1,C2,A2);
    c := Determinant(A1,B1,A2,B2);
    denominator := Sqr(a) + Sqr(b) + Sqr(c);
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then
          begin
            WriteDebugOutput('a = ' + FloatToStr(a));
            WriteDebugOutput('b = ' + FloatToStr(b));
            WriteDebugOutput('c = ' + FloatToStr(c));
            WriteDebugOutput('denominator = ' + FloatToStr(denominator));
          end;
          {$ENDIF}
    if denominator = 0 then
    begin
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then WriteDebugOutput('piParallel');
          {$ENDIF}
      result := piParallel;
    end
    else
    begin
      factor := sqrt((sqr(MaxX-MinX) + Sqr(MaxY-MinY) + sqr(MaxZ-MinZ))/denominator);
      aPrime := a*factor;
      bPrime := b*factor;
      cPrime := c*factor;
      PointList := TList.Create;
      try
        PointList.Capacity := 4;
        // piOutlinesCross, piPlanesCross
        result := piPlanesCross;
        DeterAD := Determinant(D1,A1,D2,A2);
        DeterBD := Determinant(D1,B1,D2,B2);
        DeterCD := Determinant(D1,C1,D2,C2);
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then
          begin
            WriteDebugOutput('DeterAD = ' + FloatToStr(DeterAD));
            WriteDebugOutput('DeterBD = ' + FloatToStr(DeterBD));
            WriteDebugOutput('DeterCD = ' + FloatToStr(DeterCD));
          end;
          {$ENDIF}
        X1 := (b*DeterCD - c*DeterBD)/denominator;
        Y1 := (c*DeterAD - a*DeterCD)/denominator;
        Z1 := (a*DeterBD - b*DeterAD)/denominator;
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then
          begin
            WriteDebugOutput('X1 = ' + FloatToStr(X1));
            WriteDebugOutput('Y1 = ' + FloatToStr(Y1));
            WriteDebugOutput('Z1 = ' + FloatToStr(Z1));
          end;
          {$ENDIF}
        IntersectionSegment := TXYZSegment.Create;
        try
          IntersectionSegment.Start.X := X1-aPrime;
          IntersectionSegment.Start.Y := Y1-bPrime;
          IntersectionSegment.Start.Z := Z1-cPrime;
          IntersectionSegment.Stop.X := X1+aPrime;
          IntersectionSegment.Stop.Y := Y1+bPrime;
          IntersectionSegment.Stop.Z := Z1+cPrime;
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then
          begin
            WriteDebugOutput('IntersectionSegment.Start.X = ' + FloatToStr(IntersectionSegment.Start.X));
            WriteDebugOutput('IntersectionSegment.Stop.X = ' + FloatToStr(IntersectionSegment.Stop.X));
            WriteDebugOutput('IntersectionSegment.Start.Y = ' + FloatToStr(IntersectionSegment.Start.Y));
            WriteDebugOutput('IntersectionSegment.Stop.Y = ' + FloatToStr(IntersectionSegment.Stop.Y));
            WriteDebugOutput('IntersectionSegment.Start.Z = ' + FloatToStr(IntersectionSegment.Start.Z));
            WriteDebugOutput('IntersectionSegment.Stop.Z = ' + FloatToStr(IntersectionSegment.Stop.Z));
          end;
          {$ENDIF}
          // at this point IntersectionSegment has two points which are on the
          // line of intersection between self and APlane.

          if not GetInterceptPoints(IntersectionSegment,PointList) or
             not APlane.GetInterceptPoints(IntersectionSegment,PointList) then
          begin
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then WriteDebugOutput('piPlanesCross');
          {$ENDIF}
            Exit;
          end;

          PointList.Sort(SortPointObjects);
          for PointIndex := PointList.Count -2 downto 0 do
          begin
            APoint := PointList[PointIndex];
            AnotherPoint := PointList[PointIndex+1];
            if NearlyTheSame(APoint.Location, AnotherPoint.Location, Epsilon) then
{            if NearlyTheSame(APoint.X, AnotherPoint.X, Epsilon) and
               NearlyTheSame(APoint.Y, AnotherPoint.Y, Epsilon) and
               NearlyTheSame(APoint.Z, AnotherPoint.Z, Epsilon) then }
            begin
              PointList.Remove(AnotherPoint);
              AnotherPoint.Free;
            end;
          end;

          for PointIndex := PointList.Count -1 downto 0 do
          begin
            APoint := PointList[PointIndex];
            if (IsInside(APoint.XYZLocation) = iiOutside) or
               (APlane.IsInside(APoint.XYZLocation) = iiOutside) then
            begin
              PointList.Remove(APoint);
              APoint.Free;
            end;
          end;

          if PointList.Count < 2 then
          begin
            result := piPlanesCross;
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then WriteDebugOutput('piPlanesCross');
          {$ENDIF}
          end
          else
          begin
            for PointIndex := 0 to PointList.Count -2 do
            begin
              APoint := PointList[PointIndex];
              AnotherPoint := PointList[PointIndex+1];

              InsideLocation.X := (APoint.X + AnotherPoint.X)/2;
              InsideLocation.Y := (APoint.Y + AnotherPoint.Y)/2;
              InsideLocation.Z := (APoint.Z + AnotherPoint.Z)/2;
              if (IsInside(InsideLocation) <> iiOutside) and
                 (APlane.IsInside(InsideLocation) <> iiOutside) then
              begin
                SegObject := TSegmentObject.Create;
                SegObject.StartLoc := APoint.Location;
                SegObject.EndLoc := AnotherPoint.Location;
                if NearlyTheSame(SegObject.Length, 0, Epsilon) then
                begin
                  SegObject.Free;
                end
                else
                begin
                  SegmentList.Add(SegObject);
                end;

              end;
            end;
            if SegmentList.Count > 0 then
            begin
              result := piOutlinesCross;
          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then WriteDebugOutput('piOutlinesCross');
          {$ENDIF}
            end;

          end;
        finally
          IntersectionSegment.Free;
        end;
      finally
        for PointIndex := 0 to PointList.Count -1 do
        begin
          TPointObject(PointList[PointIndex]).Free;
        end;
        PointList.Free;
      end;

    end;

  end;

end;

procedure TXYZPlane.SetCount(const ACount: integer);
begin
  if ACount < 3 then
  begin
    raise ESizeError.Create('Error: at least three points are required to' +
    'define a plane.');
  end
  else
  begin
    if ACount <> FCount then
    begin
      FCount := ACount;
      SetLength(FOutline, FCount);
    end;
  end;
end;

procedure TXYZPlane.SetOutlineLocation(Index: integer;
  ALocation: TXYZLocation);
begin
  FOutline[Index] := ALocation;
end;

constructor TXYZPlane.Create(const ACount: integer);
begin
  inherited Create;
  SetCount(ACount);
end;

function TXYZPlane.IsInside(ALocation: TXYZLocation): TIsInsideResult;
var
  VertexIndex : integer;
  AVertex, AnotherVertex : TXYZLocation;
//  X, Y, Z : extended;
//  FoundCount : integer;
  UseXY, UseXZ, UseYZ, UseNone : boolean;
//  InnerVertexIndex : integer;
  FirstCheck, SecondCheck : boolean;
  testValue : extended;
  OnEdge : boolean;
  LocalEpsilon1 : extended;
  MinTest1, MaxTest1 : extended;
  LocalEpsilon2 : extended;
  MinTest2, MaxTest2 : extended;
  procedure GetDirection;
  var
    V1, V2 : TXYZLocation;
    DeltaX, DeltaY, DeltaZ : array[0..1] of extended;
    crossProductXY, crossProductXZ, crossProductYZ : extended;
    Index, OuterIndex : integer;
  begin
    Assert(Length(FOutline) >= 3);
    for OuterIndex := 0 to Length(FOutline) -3 do
    begin
      for Index := OuterIndex to OuterIndex + 1 do
      begin
        V1 := Outline[Index];
        V2 := Outline[Index+1];
        DeltaX[Index] := V2.X - V1.X;
        DeltaY[Index] := V2.Y - V1.Y;
        DeltaZ[Index] := V2.Z - V1.Z;
      end;
      crossProductXY := Abs(DeltaX[0]*DeltaY[1] - DeltaX[1]*DeltaY[0]);
      crossProductXZ := Abs(DeltaX[0]*DeltaZ[1] - DeltaX[1]*DeltaZ[0]);
      crossProductYZ := Abs(DeltaY[0]*DeltaZ[1] - DeltaY[1]*DeltaZ[0]);
      if (crossProductXY >= crossProductXZ)
        and (crossProductXY >= crossProductYZ) then
      begin
        UseXY := True;
        Exit;
      end
      else if (crossProductXZ >= crossProductXY)
        and (crossProductXZ >= crossProductYZ) then
      begin
        UseXZ := True;
        Exit;
      end
      else if (crossProductYZ >= crossProductXY)
        and (crossProductYZ >= crossProductXZ) then
      begin
        UseYZ := True;
        Exit;
      end
    end;
    UseNone := True;
  end;
begin   // based on CACM 112
  for VertexIndex := 0 to FCount -1 do
  begin
    AVertex := Outline[VertexIndex];
    if NearlyTheSame(ALocation.X, AVertex.X,Epsilon) and
       NearlyTheSame(ALocation.Y, AVertex.Y,Epsilon) and
       NearlyTheSame(ALocation.Z, AVertex.Z,Epsilon) then
    begin
      result := iiVertex;
      Exit;
    end;
  end;

  OnEdge := False;
  FirstCheck := true;
  SecondCheck := true;
  try
    begin
      UseXY := False;
      UseXZ := False;
      UseYZ := False;
      UseNone := False;
      GetDirection;
      if UseNone then
      begin
        // colinear points
        result := iiOutside;
        Exit;
      end;
      Count := Count + 1;
      FOutline[Count -1] := FOutline[0];
{      AVertex := FOutline[0];
{      X := AVertex.X;
      Y := AVertex.Y;
      Z := AVertex.Z;
      FoundCount := 0;
      for VertexIndex := 1 to Count -3 do
      begin
        AVertex := FOutline[VertexIndex];
        if not NearlyTheSame(X, AVertex.X,Epsilon) then
        begin
          for InnerVertexIndex := VertexIndex+1 to Count -2 do
          begin
            AnotherVertex :=FOutline[InnerVertexIndex];
            if not NearlyTheSame(AVertex.Y, AnotherVertex.Y,Epsilon) and
              not NearlyTheSame(X, AnotherVertex.X,Epsilon) then
            begin
              UseX := True;
              UseY := True;
              Inc(FoundCount,2);
            end
            else if not NearlyTheSame(Y, AnotherVertex.Y,Epsilon) and
              not NearlyTheSame(AVertex.X, AnotherVertex.X,Epsilon) then
            begin
              UseX := True;
              UseY := True;
              Inc(FoundCount,2);
            end
            else if not NearlyTheSame(AVertex.Z, AnotherVertex.Z,Epsilon) and
              not NearlyTheSame(X, AnotherVertex.X,Epsilon) then
            begin
              UseX := True;
              UseZ := True;
              Inc(FoundCount,2);
            end
            else if not NearlyTheSame(Z, AnotherVertex.Z,Epsilon) and
              not NearlyTheSame(AVertex.X, AnotherVertex.X,Epsilon) then
            begin
              UseX := True;
              UseZ := True;
              Inc(FoundCount,2);
            end;
            if FoundCount > 1 then
            begin
              break;
            end;
          end;
        end
        else if not NearlyTheSame(Y, AVertex.Y,Epsilon) then
        begin
          for InnerVertexIndex := VertexIndex+1 to Count -2 do
          begin
            AnotherVertex :=FOutline[InnerVertexIndex];
            if not NearlyTheSame(AVertex.X, AnotherVertex.X,Epsilon) and
              not NearlyTheSame(Y, AnotherVertex.Y,Epsilon) then
            begin
              UseX := True;
              UseY := True;
              Inc(FoundCount,2);
            end
            else if not NearlyTheSame(X, AnotherVertex.X,Epsilon) and
              not NearlyTheSame(AVertex.Y, AnotherVertex.Y,Epsilon) then
            begin
              UseX := True;
              UseY := True;
              Inc(FoundCount,2);
            end
            else if not NearlyTheSame(AVertex.Z, AnotherVertex.Z,Epsilon) and
              not NearlyTheSame(Y, AnotherVertex.Y,Epsilon) then
            begin
              UseY := True;
              UseZ := True;
              Inc(FoundCount,2);
            end
            else if not NearlyTheSame(Z, AnotherVertex.Z,Epsilon) and
              not NearlyTheSame(AVertex.Y, AnotherVertex.Y,Epsilon) then
            begin
              UseY := True;
              UseZ := True;
              Inc(FoundCount,2);
            end;
            if FoundCount > 1 then
            begin
              break;
            end;
          end;
        end
        else if not NearlyTheSame(Z, AVertex.Z,Epsilon) then
        begin
          for InnerVertexIndex := VertexIndex+1 to Count -2 do
          begin
            AnotherVertex :=FOutline[InnerVertexIndex];
            if not NearlyTheSame(AVertex.X, AnotherVertex.X,Epsilon) and
              not NearlyTheSame(Z, AnotherVertex.Z,Epsilon) then
            begin
              UseX := True;
              UseZ := True;
              Inc(FoundCount,2);
            end
            else if not NearlyTheSame(X, AnotherVertex.X,Epsilon) and
              not NearlyTheSame(AVertex.Z, AnotherVertex.Z,Epsilon) then
            begin
              UseX := True;
              UseZ := True;
              Inc(FoundCount,2);
            end
            else if not NearlyTheSame(AVertex.Y, AnotherVertex.Y,Epsilon) and
              not NearlyTheSame(Z, AnotherVertex.Z,Epsilon) then
            begin
              UseY := True;
              UseZ := True;
              Inc(FoundCount,2);
            end
            else if not NearlyTheSame(Y, AnotherVertex.Y,Epsilon) and
              not NearlyTheSame(AVertex.Z, AnotherVertex.Z,Epsilon) then
            begin
              UseY := True;
              UseZ := True;
              Inc(FoundCount,2);
            end;
            if FoundCount > 1 then
            begin
              break;
            end;
          end;
        end;
        if FoundCount > 1 then
        begin
          break;
        end;

      end;
      if FoundCount < 2 then
      begin
        result := iiOutside;
      end
      else }
      begin
        if UseXY then
        begin
          AVertex := FOutline[0];
          MinTest1 := AVertex.X;
          MaxTest1 := MinTest1;
          MinTest2 := AVertex.Y;
          MaxTest2 := MinTest2;
          for VertexIndex := 1 to Count -1 do
          begin
            AVertex := FOutline[VertexIndex];
            if MaxTest1 > AVertex.X then
            begin
              MaxTest1 := AVertex.X;
            end;
            if MinTest1 < AVertex.X then
            begin
              MinTest1 := AVertex.X;
            end;
            if MaxTest2 > AVertex.Y then
            begin
              MaxTest2 := AVertex.Y;
            end;
            if MinTest2 < AVertex.Y then
            begin
              MinTest2 := AVertex.Y;
            end;
          end;
          LocalEpsilon1 := Abs(MaxTest1-MinTest1)/10000000;
          LocalEpsilon2 := Abs(MaxTest2-MinTest2)/10000000;

          For VertexIndex := 0 to Count -2 do
          begin
            AVertex := FOutline[VertexIndex];
            AnotherVertex := FOutline[VertexIndex+1];
            if (AnotherVertex.Y <> AVertex.Y) then
            begin
              if ((ALocation.Y <= AVertex.Y)
                   or NearlyTheSame(ALocation.Y,AVertex.Y,LocalEpsilon2))
                  = ((ALocation.Y > AnotherVertex.Y)
                    and not NearlyTheSame(ALocation.Y,AnotherVertex.Y,LocalEpsilon2))
                then
              begin
                {testValue := ALocation.X - AVertex.X - (ALocation.Y - AVertex.Y) *
                   (AnotherVertex.X - AVertex.X)/
                   (AnotherVertex.Y - AVertex.Y);
                if (testValue < -LocalEpsilon) then
                begin
                  FirstCheck := not FirstCheck;
                end;
                if (testValue > LocalEpsilon) then
                begin
                  SecondCheck := not SecondCheck;
                end; }
                testValue := (AnotherVertex.X - AVertex.X)/
                  (AnotherVertex.Y - AVertex.Y)*(ALocation.Y - AVertex.Y)
                  + AVertex.X;
                if (ALocation.X  < testValue-LocalEpsilon1)
                  or NearlyTheSame(ALocation.X,testValue,LocalEpsilon1 ) then
                begin
                  FirstCheck := not FirstCheck;
                end;
                if (ALocation.X  > testValue + LocalEpsilon1)
                  or NearlyTheSame(ALocation.X,testValue,LocalEpsilon1 ) then
                begin
                  SecondCheck := not SecondCheck;
                end;
              end;
            end
            else if NearlyTheSame(ALocation.Y,AVertex.Y,LocalEpsilon2)
              and NearlyTheSame(ALocation.Y,AnotherVertex.Y,LocalEpsilon2)
              and ((ALocation.X <= AVertex.X) = (ALocation.X >= AnotherVertex.X))
              then
              begin
                OnEdge := True;
                break;
              end;
          end;
          FirstCheck := not FirstCheck;
          SecondCheck := not SecondCheck;
        end
        else if UseXZ then
        begin
          AVertex := FOutline[0];
          MinTest1 := AVertex.X;
          MaxTest1 := MinTest1;
          MinTest2 := AVertex.Z;
          MaxTest2 := MinTest2;
          for VertexIndex := 1 to Count -1 do
          begin
            AVertex := FOutline[VertexIndex];
            if MaxTest1 > AVertex.X then
            begin
              MaxTest1 := AVertex.X;
            end;
            if MinTest1 < AVertex.X then
            begin
              MinTest1 := AVertex.X;
            end;
            if MaxTest2 > AVertex.Z then
            begin
              MaxTest2 := AVertex.Z;
            end;
            if MinTest2 < AVertex.Z then
            begin
              MinTest2 := AVertex.Z;
            end;
          end;
          LocalEpsilon1 := Abs(MaxTest1-MinTest1)/10000000;
          LocalEpsilon2 := Abs(MaxTest2-MinTest2)/10000000;
{          AVertex := FOutline[0];
          MinTest := AVertex.X;
          MaxTest := MinTest;
          for VertexIndex := 1 to Count -1 do
          begin
            AVertex := FOutline[VertexIndex];
            if MaxTest > AVertex.X then
            begin
              MaxTest := AVertex.X;
            end;
            if MinTest < AVertex.X then
            begin
              MinTest := AVertex.X;
            end;
          end;
          LocalEpsilon := (MaxTest-MinTest)/1000; }

          For VertexIndex := 0 to Count -2 do
          begin
            AVertex := FOutline[VertexIndex];
            AnotherVertex := FOutline[VertexIndex+1];
            if (AnotherVertex.Z <> AVertex.Z)
            then
              begin
              if ((ALocation.Z <= AVertex.Z)
                  or NearlyTheSame(ALocation.Z,AVertex.Z,LocalEpsilon2))
                 = ((ALocation.Z > AnotherVertex.Z)
                   and not NearlyTheSame(ALocation.Z,AnotherVertex.Z,LocalEpsilon2))
                then
              begin
                {testValue := ALocation.X - AVertex.X - (ALocation.Z - AVertex.Z) *
                   (AnotherVertex.X - AVertex.X)/
                   (AnotherVertex.Z - AVertex.Z);
                if (testValue < -LocalEpsilon) then
                begin
                  FirstCheck := not FirstCheck;
                end; }
  {            end;
              if ((((ALocation.Z <= AnotherVertex.Z) or NearlyTheSame(ALocation.Z,AnotherVertex.Z,LocalEpsilon)) = (ALocation.Z > AVertex.Z)))
                and (AnotherVertex.Z <> AVertex.Z) then
              begin
                testValue := ALocation.X - AVertex.X - (ALocation.Z - AVertex.Z) *
                   (AnotherVertex.X - AVertex.X)/
                   (AnotherVertex.Z - AVertex.Z);  }
                {if (testValue > LocalEpsilon) then
                begin
                  SecondCheck := not SecondCheck;
                end;  }

                testValue := (AnotherVertex.X - AVertex.X)/
                  (AnotherVertex.Z - AVertex.Z)*(ALocation.Z - AVertex.Z)
                  + AVertex.X;
                if (ALocation.X  < testValue-LocalEpsilon1)
                  or NearlyTheSame(ALocation.X,testValue,LocalEpsilon1 ) then
                begin
                  FirstCheck := not FirstCheck;
                end;
                if (ALocation.X  > testValue + LocalEpsilon1)
                  or NearlyTheSame(ALocation.X,testValue,LocalEpsilon1 ) then
                begin
                  SecondCheck := not SecondCheck;
                end;

              end;
            end
            else if NearlyTheSame(ALocation.Z,AVertex.Z,LocalEpsilon2)
              and NearlyTheSame(ALocation.Z,AnotherVertex.Z,LocalEpsilon2)
              and ((ALocation.X <= AVertex.X) = (ALocation.X >= AnotherVertex.X))
              then
              begin
                OnEdge := True;
                break;
              end;
          end;
          FirstCheck := not FirstCheck;
          SecondCheck := not SecondCheck;
        end
        else
        begin
          AVertex := FOutline[0];
          MinTest1 := AVertex.Y;
          MaxTest1 := MinTest1;
          MinTest2 := AVertex.Z;
          MaxTest2 := MinTest2;
          for VertexIndex := 1 to Count -1 do
          begin
            AVertex := FOutline[VertexIndex];
            if MaxTest1 > AVertex.Y then
            begin
              MaxTest1 := AVertex.Y;
            end;
            if MinTest1 < AVertex.Y then
            begin
              MinTest1 := AVertex.Y;
            end;
            if MaxTest2 > AVertex.Z then
            begin
              MaxTest2 := AVertex.Z;
            end;
            if MinTest2 < AVertex.Z then
            begin
              MinTest2 := AVertex.Z;
            end;
          end;
          LocalEpsilon1 := Abs(MaxTest1-MinTest1)/10000000;
          LocalEpsilon2 := Abs(MaxTest2-MinTest2)/10000000;
{          AVertex := FOutline[0];
          MinTest := AVertex.Y;
          MaxTest := MinTest;
          for VertexIndex := 1 to Count -1 do
          begin
            AVertex := FOutline[VertexIndex];
            if MaxTest > AVertex.Y then
            begin
              MaxTest := AVertex.Y;
            end;
            if MinTest < AVertex.Y then
            begin
              MinTest := AVertex.Y;
            end;
          end;
          LocalEpsilon := (MaxTest-MinTest)/1000;  }

          For VertexIndex := 0 to Count -2 do
          begin
            AVertex := FOutline[VertexIndex];
            AnotherVertex := FOutline[VertexIndex+1];
            if (AnotherVertex.Z <> AVertex.Z) then
            begin
              if ( (ALocation.Z <= AVertex.Z)
                   or NearlyTheSame(ALocation.Z,AVertex.Z,LocalEpsilon2))
                 = ((ALocation.Z > AnotherVertex.Z)
                   and not NearlyTheSame(ALocation.Z,AnotherVertex.Z,LocalEpsilon2))
                then
              begin
                {testValue := ALocation.Y - AVertex.Y - (ALocation.Z - AVertex.Z) *
                   (AnotherVertex.Y - AVertex.Y)/
                   (AnotherVertex.Z - AVertex.Z);
                if (testValue < -LocalEpsilon) then
                begin
                  FirstCheck := not FirstCheck;
                end;
                if (testValue > LocalEpsilon) then
                begin
                  SecondCheck := not SecondCheck;
                end; }

                testValue := (AnotherVertex.Y - AVertex.Y)/
                  (AnotherVertex.Z - AVertex.Z)*(ALocation.Z - AVertex.Z)
                  + AVertex.Y;
                if (ALocation.Y  < testValue-LocalEpsilon1)
                  or NearlyTheSame(ALocation.Y,testValue,LocalEpsilon1 ) then
                begin
                  FirstCheck := not FirstCheck;
                end;
                if (ALocation.Y  > testValue + LocalEpsilon1)
                  or NearlyTheSame(ALocation.Y,testValue,LocalEpsilon1 ) then
                begin
                  SecondCheck := not SecondCheck;
                end;

              end;
            end
            else if NearlyTheSame(ALocation.Z,AVertex.Z,LocalEpsilon2)
              and NearlyTheSame(ALocation.Z,AnotherVertex.Z,LocalEpsilon2)
              and ((ALocation.Y <= AVertex.Y) = (ALocation.Y >= AnotherVertex.Y))
              then
              begin
                OnEdge := True;
                break;
              end;
          end;
          FirstCheck := not FirstCheck;
          SecondCheck := not SecondCheck;
        end;
        if OnEdge then
        begin
          result := iiEdge
        end
        else if FirstCheck and SecondCheck then
        begin
          result := iiInside
        end
        else if not FirstCheck and not SecondCheck then
        begin
          result := iiOutside
        end
        else
        begin
          result := iiEdge
        end

      end;
    end
  finally
    begin
      Count := Count - 1;
    end;
  end;
end;



procedure TXYZPlane.GetCoefficientsFromElevations(var A, B, C, D: extended);
// http://www.mhri.edu.au/~pdb/geometry/planeeq/
var
  X1, X2, X3, Y1, Y2, Y3, Z1, Z2, Z3 : extended;
  ALocation : TXYZLocation;
begin

  ALocation := FElevations[0];
  X1 := ALocation.X;
  Y1 := ALocation.Y;
  Z1 := ALocation.Z;
  ALocation := FElevations[1];
  X2 := ALocation.X;
  Y2 := ALocation.Y;
  Z2 := ALocation.Z;
  ALocation := FElevations[2];
  X3 := ALocation.X;
  Y3 := ALocation.Y;
  Z3 := ALocation.Z;

  A := y1 *(z2 - z3) + y2 *(z3 - z1) + y3 *(z1 - z2);
  B := z1 *(x2 - x3) + z2 *(x3 - x1) + z3 *(x1 - x2);
  C := x1 *(y2 - y3) + x2 *(y3 - y1) + x3 *(y1 - y2);
  D := -(x1 *(y2 *z3 - y3 *z2) + x2 *(y3 *z1 - y1 *z3) + x3 *(y1 *z2 - y2 *z1));

end;


procedure TXYZPlane.GetCoefficients(var A, B, C, D: extended);
// http://www.mhri.edu.au/~pdb/geometry/planeeq/
var
  X1, X2, X3, Y1, Y2, Y3, Z1, Z2, Z3 : extended;
  ALocation : TXYZLocation;
begin

  ALocation := FOutline[0];
  X1 := ALocation.X;
  Y1 := ALocation.Y;
  Z1 := ALocation.Z;
  ALocation := FOutline[1];
  X2 := ALocation.X;
  Y2 := ALocation.Y;
  Z2 := ALocation.Z;
  ALocation := FOutline[2];
  X3 := ALocation.X;
  Y3 := ALocation.Y;
  Z3 := ALocation.Z;

          {$IFDEF DEBUG}
          If CurrentVertex.NodeIndex = 5728 then
          begin
            WriteDebugOutput('X1 = ' + FloatToStr(X1));
            WriteDebugOutput('Y1 = ' + FloatToStr(Y1));
            WriteDebugOutput('Z1 = ' + FloatToStr(Z1));
            WriteDebugOutput('X2 = ' + FloatToStr(X2));
            WriteDebugOutput('Y2 = ' + FloatToStr(Y2));
            WriteDebugOutput('Z2 = ' + FloatToStr(Z2));
            WriteDebugOutput('X3 = ' + FloatToStr(X3));
            WriteDebugOutput('Y3 = ' + FloatToStr(Y3));
            WriteDebugOutput('Z3 = ' + FloatToStr(Z3));
          end;
          {$ENDIF}


  {$IFOpt O+}
    {$DEFINE OPTON}
  {$ELSE}
    {$UNDEF OPTON}
  {$ENDIF}
  {$O-}
  A := y1 *(z2 - z3) + y2 *(z3 - z1) + y3 *(z1 - z2);
  B := z1 *(x2 - x3) + z2 *(x3 - x1) + z3 *(x1 - x2);
  C := x1 *(y2 - y3) + x2 *(y3 - y1) + x3 *(y1 - y2);
  D := -(x1 *(y2 *z3 - y3 *z2) + x2 *(y3 *z1 - y1 *z3) + x3 *(y1 *z2 - y2 *z1));

  {$IFDEF OPTON)
    {$O+}
  {$ENDIF}
end;

function TXYZPlane.Area: extended;
var
  Xs, Ys, Zs: TRealList;
  FaceLists: TIntListList;
  Index : integer;
  Location : TXYZLocation;
  AFaceList : TIntegerList;
  ASolid : TSolid;
  Vol, Surface : extended;
begin
  Xs := TRealList.Create;
  Ys := TRealList.Create;
  Zs := TRealList.Create;
  FaceLists := TIntListList.Create;
  try
    Xs.Capacity := Count;
    Ys.Capacity := Count;
    Zs.Capacity := Count;
    AFaceList := TIntegerList.Create;
    AFaceList.Capacity := Count +1;
    FaceLists.Add(AFaceList);
    AFaceList.Add(0);
    for Index := 0 to Count -1 do
    begin
      Location := Outline[Index];
      Xs.Add(Location.X);
      Ys.Add(Location.Y);
      Zs.Add(Location.Z);
      AFaceList.Add(Index);
    end;
    ASolid := TSolid.Create(Xs, Ys, Zs, FaceLists);
    try
      ASolid.GetProps(Vol, Surface);
      result := Surface;
    finally
      ASolid.Free;
    end;


  finally
    Xs.Free;
    Ys.Free;
    Zs.Free;
    for Index := 0 to FaceLists.Count -1 do
    begin
      TIntegerList(FaceLists[Index]).Free;
    end;
    FaceLists.Free;
  end;

end;

procedure TXYZPlane.SetElevations(Locations: TElevationsLocations);
var
  A, B, C, D: extended;
  Index : integer;
  ALocation : TXYZLocation;
begin
  FElevations := Locations;
  A := 0;
  B := 0;
  C := 0;
  D := 0;
  GetCoefficientsFromElevations(A, B, C, D);
  if C <> 0 then
  begin
    for Index := 0 to FCount-1 do
    begin
      ALocation := FOutline[Index];
      ALocation.Z := (-D - A * ALocation.X - B * ALocation.Y)/C;
      FOutline[Index] := ALocation;
    end;
  end;

end;

procedure TXYZPlane.SetBox;
var
  Converter : TPointObject;
  Index, DimIndex : integer;
begin
  Converter := TPointObject.Create;
  try
    if Count > 0 then
    begin
      Converter.XYZLocation := Outline[0];
      bmin := Converter.Location;
      bmax := Converter.Location;
      for Index := 1 to Count -1 do
      begin
        Converter.XYZLocation := Outline[Index];
        for DimIndex := 0 to DIM -1 do
        begin
          if bmin[DimIndex] > Converter.Location[DimIndex] then
          begin
            bmin[DimIndex] := Converter.Location[DimIndex];
          end;
          if bmax[DimIndex] < Converter.Location[DimIndex] then
          begin
            bmax[DimIndex] := Converter.Location[DimIndex];
          end;
        end;

      end;
    end;
  finally
    Converter.Free;
  end;

end;

{ TXYZPlaneList }

procedure TXYZPlaneList.Add(APolygon: TXYZPlane);
begin
  FList.Add(APolygon);
end;

function TXYZPlaneList.Count: integer;
begin
  result := FList.Count;
end;

constructor TXYZPlaneList.Create;
begin
  inherited;
  FList := TList.Create;
end;

destructor TXYZPlaneList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TXYZPlaneList.GetItems(Index: integer): TXYZPlane;
begin
  result := FList[Index];
end;

function TXYZPlaneList.Remove(APolygon: TXYZPlane): Integer;
begin
  result := FList.Remove(APolygon);
end;

procedure TXYZPlaneList.SetItems(Index: integer; const Value: TXYZPlane);
begin
  FList[Index] := Value;
end;

{ TPointObject }

function TPointObject.GetXYZLocation: TXYZLocation;
begin
  result.X := X;
  result.Y := Y;
  result.Z := Z;
end;

procedure TPointObject.SetXYZLocation(ALocation: TXYZLocation);
begin
  X := ALocation.X;
  Y := ALocation.Y;
  Z := ALocation.Z;
end;

end.

