unit PlaneGeom;

interface

uses AnePIE;

type
  TRealPoint = record
    X: ANE_DOUBLE;
    Y: ANE_DOUBLE;
  end;

  TPointArray = array of TRealPoint;

  {
    irEdge = the segments collinearly overlap, sharing a point.

    irVertex = an endpoint of one segment is on the other segment but not
      irEdge.

    irIntersect = the segments overlap properly.
    
    irNoIntersect = the segments do not overlap.
  }
  TIntersectResult = (irEdge, irVertex, irIntersect, irNoIntersect, irUndefined);

{
  SegSegInt determines the intersection between two points.
  a and b are endpoints of one segment.
  c and d are endpoints of the other segment.
  p is the point of intersection.

  Modified from O'Rouke, J. 1998. Computational Geometry in C, Second Edition.
    Cambridge University Press. Cambridge, 376 p.
}
function SegSegInt(const a, b, c, d: TRealPoint;
  var p: TRealPoint): TIntersectResult;

implementation

function Area2(const a, b, c: TRealPoint): double;
begin
  result := (b.X - a.X) * (c.Y - a.Y) -
    (c.X - a.X) * (b.Y - a.Y);
end;

function Left(const a, b, c: TRealPoint): boolean;
begin
  result := Area2(a, b, c) > 0;
end;

function LeftOn(const a, b, c: TRealPoint): boolean;
begin
  result := Area2(a, b, c) >= 0;
end;

function Collinear(const a, b, c: TRealPoint): boolean;
begin
  result := Area2(a, b, c) = 0;
end;

function Between(const a, b, c: TRealPoint): boolean;
begin
  if a.X <> b.X then
  begin
    result := ((a.X <= c.X) and (c.X <= b.X))
      or ((a.X >= c.X) and (c.X >= b.X))
  end
  else
  begin
    result := ((a.Y <= c.Y) and (c.X <= b.Y))
      or ((a.Y >= c.Y) and (c.Y >= b.Y))
  end;
end;

function ParallelInt(const a, b, c, d: TRealPoint;
  var p: TRealPoint): TIntersectResult;
begin
  if not Collinear(a, b, c) then
  begin
    result := irNoIntersect;
    Exit;
  end
  else
  begin
    result := irEdge;
    if Between(a, b, c) then
    begin
      p := c;
    end
    else if Between(a, b, d) then
    begin
      p := d;
    end
    else if Between(c, d, a) then
    begin
      p := a;
    end
    else if Between(c, d, b) then
    begin
      p := b;
    end
    else
    begin
      result := irNoIntersect;
    end;
  end;
end;

// SegSegInt determines the intersection between two points.
// a and b are endpoints of one segment.
// c and d are endpoints of the other segment.
// p is the point of intersection.
function SegSegInt(const a, b, c, d: TRealPoint;
  var p: TRealPoint): TIntersectResult;
var
  s, t, num, denom: double;
begin
  result := irUndefined;
  denom := a.X * (d.Y - c.Y) +
    b.X * (c.Y - d.Y) +
    d.X * (b.Y - a.Y) +
    c.X * (a.Y - b.Y);
  if denom = 0 then
  begin
    result := ParallelInt(a, b, c, d, p);
    Exit;
  end;

  num := a.X * (d.Y - c.Y) +
    c.X * (a.Y - d.Y) +
    d.X * (c.Y - a.Y);
  if (num = 0) or (num = denom) then
  begin
    result := irVertex;
  end;
  s := num / denom;

  num := -(a.X * (c.Y - b.Y) +
    b.X * (a.Y - c.Y) +
    c.X * (b.Y - a.Y));
  if (num = 0) or (num = denom) then
  begin
    result := irVertex;
  end;
  t := num / denom;

  p.X := a.X + s * (b.X - a.X);
  p.Y := a.Y + t * (b.Y - a.Y);

  if (0 < s) and (s < 1)
    and (0 < t) and (t < 1) then
  begin
    result := irIntersect;
  end
  else if (0 > s) or (s > 1)
    or (0 > t) or (t > 1) then
  begin
    result := irNoIntersect;
  end;
  Assert(result <> irUndefined);
end;

end.

