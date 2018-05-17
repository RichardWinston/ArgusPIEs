unit PolyhedronUnit;

interface

// Uses Dialogs,SysUtils;

const
  X = 0;
  Y = 1;
  Z = 2;
  DIM = 3;

type
  TPointi = array[0..DIM-1] of integer; // integer point
  TPointd = array[0..DIM-1] of double; // double point
  InPolyhedronResult = (ipVertex, ipEdge, ipFace, ipInterior, ipExterior);
  SegPlaneIntersectResult = (spiWithin, spiQOnPlane, spiROnPlane, spiOffPlane,
    spiIntersects);
  InTriangleResult = (itVertex, itEdge, itInterior, itExterior);
  SegTriangleIntersectionResult = (stiVertex, stiEdge, stiFace, stiMisses,
    stiVertexOnSegment, stiEdgeOnSegment, stiFaceOnSegment, stiDegenerate);
  BoxTestResult = (btOutside, btUnknown);

  TPolyhedron = class (TObject)
    private
      function Inbox(q, bmin, bmax : TPointi) : boolean;
      procedure RandomRay(var ray : tPointi; radius : integer);
      function BoxTest (  n : integer; a, b : tPointi ) : BoxTestResult;
      procedure AddVec(q : tPointi; var ray: tPointi );
      procedure NormalVec(  a,  b,  c: tPointi; var  N : tPointd);
      function Dot(  a: tPointi; b: tPointd ) : double;
      function PlaneCoeff(T : tPointi; var N : tPointd ; var D : double )
        : integer;
      procedure    SubVec(  a,  b : tPointi; var c : tPointi );
      function SegPlaneInt(T, q, r : tPointi; p : tPointd; var m : integer)
        : SegPlaneIntersectResult;
      function AreaSign(  a, b, c : tPointi ) : integer;
      function InTri2D(  Tp : array of tPointi;  pp :tPointi )
        : InTriangleResult;
      function InTri3D(  T : tPointi;  m : integer; p : tPointi )
        : InTriangleResult;
      function InPlane(  T : tPointi;  m: integer;  q,  r : tPointi;
        p : tPointd) : SegTriangleIntersectionResult;
      function VolumeSign(  a,  b,  c,  d : tPointi ) : integer;
      function SegTriCross(  T,  q,  r :tPointi )
        : SegTriangleIntersectionResult;
      function SegTriInt(T, q, r : tPointi; p : tPointd  )
        : SegTriangleIntersectionResult;
    public
      Vertices : array of TPointi;
      Faces : array of TPointi;
      Box : array of array[0..1] of TPointi;
      constructor Create(VertexCount, FaceCount: integer);
      function InPolyHedron(F : integer; q, bmin, bmax : TPointi;
        radius : integer) : InPolyhedronResult;
    function ComputeBox(F: integer; var bmin, bmax: tPointi): integer;
  end;


implementation

function TPolyhedron.Inbox(q, bmin, bmax : TPointi) : boolean;
begin
  result := ( ( bmin[X] <= q[X] ) and ( q[X] <= bmax[X] ) and
              ( bmin[Y] <= q[Y] ) and ( q[Y] <= bmax[Y] ) and
              ( bmin[Z] <= q[Z] ) and ( q[Z] <= bmax[Z] ) )
{  then
  begin
    result := TRUE;
  end
  else
  begin
    result := FALSE;
  end;  }

end;

procedure TPolyhedron.RandomRay(var ray : tPointi; radius : integer);
var
  x_l, y_l, z_l, w, t: double;
begin

  //* Generate a random point on a sphere of radius 1. */
  //* the sphere is sliced at z, and a random point at angle t
  //   generated on the circle of intersection. */
  z_l := {2.0 *}  random;
  t := {2.0 *} Pi * random;
  w := sqrt( 1 - Sqr(z_l) );
  x_l := w * cos( t );
  y_l := w * sin( t );

  // check this.
  ray[X] := Round( ( radius * x_l ));
  ray[Y] := Round(  ( radius * y_l ));
  ray[Z] := Round(  ( radius * z_l ));

//  /*printf( "RandomRay returns %6d %6d %6d\n", ray[X], ray[Y], ray[Z] );*/
end;

function TPolyhedron.BoxTest (  n : integer; a, b : tPointi ) : BoxTestResult;
var
  i : integer; //* Coordinate index */
  w : integer;
begin
  for i := 0 to DIM-1 do
  begin
    w := Box[ n ,0,i]; //* min: lower left */
    if ( (a[i] < w) and (b[i] < w) ) then
    begin
      result := btOutside;
      Exit;
    end;
    w := Box[ n ][1][i]; //* max: upper right */
    if ( (a[i] > w) and (b[i] > w) ) then
    begin
      result := btOutside;
      Exit;
    end;
  end;
  result := btUnknown;

end;

procedure TPolyhedron.AddVec(q : tPointi; var ray: tPointi );
var
  i : integer;
begin
  for i := 0 to DIM-1 do
  begin
    ray[i] := q[i] + ray[i]
  end;
end;

procedure TPolyhedron.NormalVec(  a,  b,  c: tPointi; var  N : tPointd);
begin
    N[X] := ( c[Z] - a[Z] ) * ( b[Y] - a[Y] ) -
           ( b[Z] - a[Z] ) * ( c[Y] - a[Y] );
    N[Y] := ( b[Z] - a[Z] ) * ( c[X] - a[X] ) -
           ( b[X] - a[X] ) * ( c[Z] - a[Z] );
    N[Z] := ( b[X] - a[X] ) * ( c[Y] - a[Y] ) -
           ( b[Y] - a[Y] ) * ( c[X] - a[X] );
end;

function TPolyhedron.Dot(  a: tPointi; b: tPointd ) : double;
var
  i : integer;
begin
  result := 0.0;

  for i := 0 to DIM-1 do
  begin
    result := result + a[i] * b[i];
  end;
end;

function TPolyhedron.PlaneCoeff(T : tPointi; var N : tPointd ; var D : double )
  : integer;
var
  i : integer;
  t_l : double; //* Temp storage */
  biggest : double; //* Largest component of normal vector. */
  m : integer; //* Index of largest component. */
begin
  biggest := 0;
  m := 0;

    NormalVec( Vertices[T[0]], Vertices[T[1]], Vertices[T[2]], N );
//    /*printf("PlaneCoeff: N=(%lf,%lf,%lf)\n", N[X],N[Y],N[Z]);*/
    D := Dot( Vertices[T[0]], N );

    //* Find the largest component of N. */

    for i := 0 to DIM -1 do
    begin
      t_l := Abs( N[i] );
      if ( t_l > biggest ) then
      begin
        biggest := t_l;
        m := i;
      end;
    end;

    result := m;

end;

procedure TPolyhedron.SubVec(  a,  b : tPointi; var c : tPointi );
var
  i : integer;
begin
  for i := 0 to DIM- 1 do
  begin
    c[i] := a[i] - b[i];
  end;
end;

function TPolyhedron.SegPlaneInt(T, q, r : tPointi; p : tPointd;
  var m : integer) : SegPlaneIntersectResult;
var
  N : tPointd;
  D : double;
  rq : tPointi;
  num, denom, t_l : double;
  i : integer;
begin

    m := PlaneCoeff( T, N, D );
    //*printf("m=%d; plane=(%lf,%lf,%lf,%lf)\n", m, N[X],N[Y],N[Z],D);*/
    num := D - Dot( q, N );
    SubVec( r, q, rq );
    denom := Dot( rq, N );
    //*printf("SegPlaneInt: num=%lf, denom=%lf\n", num, denom );*/

    if ( denom = 0.0 ) then  //* Segment is parallel to plane. */
    begin
       if ( num = 0.0 ) then  //* q is on plane. */
       begin
         result := spiWithin;
          // return 'p';
       end
       else
       begin
         result := spiOffPlane;
         //  return '0';
       end;
    end
    else
       t_l := num / denom;
    //*printf("SegPlaneInt: t=%lf \n", t );*/

    for i := 0 to DIM-1 do
    begin
      p[i] := q[i] + t_l * ( r[i] - q[i] );
    end;

    if ( (0.0 < t_l) and (t_l < 1.0) ) then
    begin
      result := spiIntersects;
//         return '1';
    end
    else if ( num = 0.0 ) then  //* t_l == 0 */
    begin
      result := spiQOnPlane
//         return 'q';
    end
    else if ( num = denom ) then //* t_l == 1 */
    begin
      result := spiROnPlane;
      //   return 'r';
    end
    else
    begin
      result := spiOffPlane;
//      return '0';
    end;
end;

function TPolyhedron.AreaSign(  a, b, c : tPointi ) : integer;
var
  area2 : double;
begin

    area2 := ( b[0] - a[0] ) * ( c[1] - a[1] ) -
            ( c[0] - a[0] ) * ( b[1] - a[1] );

    //* The area should be an integer. */
    if      ( area2 >  0.5 ) then
    begin
      result := 1;
    end
    else if ( area2 < -0.5 ) then
    begin
      result := -1;
    end
    else
    begin
      result := 0;
    end;
end;

function TPolyhedron.InTri2D(  Tp : array of tPointi;  pp :tPointi )
  : InTriangleResult;
var
  area0, area1, area2 : integer;
begin

   //* compute three AreaSign() values for pp w.r.t. each edge of the face in 2D */
   area0 := AreaSign( pp, Tp[0], Tp[1] );
   area1 := AreaSign( pp, Tp[1], Tp[2] );
   area2 := AreaSign( pp, Tp[2], Tp[0] );
   //printf("area0=%d  area1=%d  area2=%d\n",area0,area1,area2);

   if ( ( area0 = 0 ) and ( area1 > 0 ) and ( area2 > 0 ) or
        ( area1 = 0 ) and ( area0 > 0 ) and ( area2 > 0 ) or
        ( area2 = 0 ) and ( area0 > 0 ) and ( area1 > 0 ) ) then
   begin
     result := itEdge;
//     return 'E';
   end
//  InTriangleResult = (itVertex, itEdge, itInterior, itExterior);

   else if ( ( area0 = 0 ) and ( area1 < 0 ) and ( area2 < 0 ) or
        ( area1 = 0 ) and ( area0 < 0 ) and ( area2 < 0 ) or
        ( area2 = 0 ) and ( area0 < 0 ) and ( area1 < 0 ) ) then
   begin
     result := itEdge;
//     return 'E';
   end

   else if ( ( area0 >  0 ) and ( area1 > 0 ) and ( area2 > 0 ) or
        ( area0 <  0 ) and ( area1 < 0 ) and ( area2 < 0 ) ) then
   begin
     result := itInterior;
//     return 'F';
   end

   else if ( ( area0 = 0 ) and ( area1 = 0 ) and ( area2 = 0 ) ) then
   begin
     Assert(False);
   end
//     fprintf( stderr, "Error in InTriD\n" ), exit(EXIT_FAILURE);

   else if ( ( area0 = 0 ) and ( area1 = 0 ) or
        ( area0 = 0 ) and ( area2 = 0 ) or
        ( area1 = 0 ) and ( area2 = 0 ) ) then
   begin
     result := itVertex;
//     return 'V';
   end

   else
   begin
     result := itExterior;
//     return '0';
   end;
end;

function TPolyhedron.InTri3D(  T : tPointi;  m : integer; p : tPointi )
  : InTriangleResult;
var
  i : integer; //* Index for X,Y,Z           */
  j : integer; //* Index for X,Y             */
  k : integer; //* Index for triangle vertex */
  pp : tPointi; //* projected p */
  Tp : array [0..2] of tPointi; //* projected T: three new vertices */
begin

   //* Project out coordinate m in both p and the triangular face */
   j := 0;
   for i := 0 to DIM-1 do
   begin
     if ( i <> m ) then    //* skip largest coordinate */
     begin
       pp[j] := p[i];
       for k := 0 to 2 do
       begin
         Tp[k][j] := Vertices[T[k]][i];
       end;
       Inc(j);
     end;
   end;
   result := InTri2D( Tp, pp ) ;
end;

function TPolyhedron.InPlane(  T : tPointi;  m: integer;  q,  r : tPointi;
  p : tPointd) : SegTriangleIntersectionResult;
begin
    //* NOT IMPLEMENTED */
    result := stiDegenerate;
//    return 'p';
end;

function TPolyhedron.VolumeSign(  a,  b,  c,  d : tPointi ) : integer;
var
  vol : double ;
  ax, ay, az, bx, by, bz, cx, cy, cz, dx, dy, dz : double ;
  bxdx, bydy, bzdz, cxdx, cydy, czdz : double ;
begin
   ax := a[X];
   ay := a[Y];
   az := a[Z];
   bx := b[X];
   by := b[Y];
   bz := b[Z];
   cx := c[X]; 
   cy := c[Y];
   cz := c[Z];
   dx := d[X];
   dy := d[Y];
   dz := d[Z];

   bxdx:=bx-dx;
   bydy:=by-dy;
   bzdz:=bz-dz;
   cxdx:=cx-dx;
   cydy:=cy-dy;
   czdz:=cz-dz;
   vol :=   (az-dz) * (bxdx*cydy - bydy*cxdx)
         + (ay-dy) * (bzdz*cxdx - bxdx*czdz)
         + (ax-dx) * (bydy*czdz - bzdz*cydy);


   //* The volume should be an integer. */
   if      ( vol > 0.5 ) then
   begin
     result := 1;
   end
   else if ( vol < -0.5 )then
   begin
     result := -1;
   end
   else
   begin
     result := 0;
   end;
end;

function TPolyhedron.SegTriCross(  T,  q,  r :tPointi )
  : SegTriangleIntersectionResult;
var
  vol0, vol1, vol2 : integer;
begin

   vol0 := VolumeSign( q, Vertices[ T[0] ], Vertices[ T[1] ], r );
   vol1 := VolumeSign( q, Vertices[ T[1] ], Vertices[ T[2] ], r );
   vol2 := VolumeSign( q, Vertices[ T[2] ], Vertices[ T[0] ], r );

//   printf( "SegTriCross:  vol0 = %d; vol1 = %d; vol2 = %d\n",
//      vol0, vol1, vol2 );
     
   //* Same sign: segment intersects interior of triangle. */
   if ( ( ( vol0 > 0 ) and ( vol1 > 0 ) and ( vol2 > 0 ) ) or
        ( ( vol0 < 0 ) and ( vol1 < 0 ) and ( vol2 < 0 ) ) ) then
   begin
//      return 'f';
      result := stiFaceOnSegment;
   end

   //* Opposite sign: no intersection between segment and triangle */
   else if ( ( ( vol0 > 0 ) or ( vol1 > 0 ) or ( vol2 > 0 ) ) and
        ( ( vol0 < 0 ) or ( vol1 < 0 ) or ( vol2 < 0 ) ) ) then
   begin
//      return '0';
      result := stiMisses
   end


   else if ( ( vol0 = 0 ) and ( vol1 = 0 ) and ( vol2 = 0 ) ) then
   begin
     Assert(False);
   end
//     fprintf( stderr, "Error 1 in SegTriCross\n" ), exit(EXIT_FAILURE);

   //* Two zeros: segment intersects vertex. */
   else if ( ( ( vol0 = 0 ) and ( vol1 = 0 ) ) or
             ( ( vol0 = 0 ) and ( vol2 = 0 ) ) or
             ( ( vol1 = 0 ) and ( vol2 = 0 ) ) ) then
   begin
//      return 'v';
      result := stiVertex
   end

   //*/ One zero: segment intersects edge. */
   else if ( ( vol0 = 0 ) or ( vol1 = 0 ) or ( vol2 = 0 ) ) then
   begin
//      return 'e';
      result := stiEdge
   end


   else
   begin
     Assert(False);
   end;
//     fprintf( stderr, "Error 2 in SegTriCross\n" ), exit(EXIT_FAILURE);
end;

function TPolyhedron.SegTriInt(T, q, r : tPointi; p : tPointd  )
  : SegTriangleIntersectionResult;
var
  code : SegPlaneIntersectResult;
  m : integer;
begin
//    int code = '?';
    m := -1;

    code := SegPlaneInt( T, q, r, p, m );
//    printf("SegPlaneInt code=%c, m=%d; p=(%lf,%lf,%lf)\n", code,m,p[X],p[Y],p[Z]
//);

    case code of
    spiOffPlane:
      begin
        result := stiMisses;
      end;
    spiQOnPlane :
      begin
        case InTri3D( T, m, q ) of
          itVertex :
          begin
            result := stiVertex;
          end;
          itEdge :
          begin
            result := stiEdge;
          end;
          itInterior :
          begin
            result := stiFace;
          end;
          itExterior :
          begin
            result := stiMisses;
          end;
        end;
      end;
    spiROnPlane :
      begin
        case InTri3D( T, m, r ) of
          itVertex :
          begin
            result := stiVertex;
          end;
          itEdge :
          begin
            result := stiEdge;
          end;
          itInterior :
          begin
            result := stiFace;
          end;
          itExterior :
          begin
            result := stiMisses;
          end;
        end;
      end;
    spiWithin :
      begin
        result := InPlane( T, m, q, r, p );
      end;
    spiIntersects :
      begin
        result := SegTriCross( T, q, r );
      end;
    else
      begin
        Assert(False);
      end
    end;

{    if      ( code == '0')
       return '0';
    else if ( code == 'q')
       return InTri3D( T, m, q );
    else if ( code == 'r')
       return InTri3D( T, m, r );
    else if ( code == 'p' )
       return InPlane( T, m, q, r, p );
    else if ( code == '1' )
       return SegTriCross( T, q, r );
    else /* Error */
       return code; }
end;
function TPolyhedron.InPolyHedron(F : integer; q, bmin, bmax : TPointi;
  radius : integer) : InPolyhedronResult;
var
  r : TPointi; // ray endpoint
  p : TPointd; // intersection point; not used
  f_l: integer;
  k : integer;
  crossings : integer;
  code : SegTriangleIntersectionResult;
  label Loop;
begin
  if not InBox(q, bmin, bmax) then
  begin
    result := ipExterior;
    Exit;
  end;

  Loop:
  for k := 0 to F -1 do
  begin
    crossings := 0;
    RandomRay( r, radius );
    AddVec( q, r );
    for f_l := 0 to F-1 do //* Begin check each face */
    begin
      if ( BoxTest( f_l, q, r ) = btOutside) then
      begin
        code := stiMisses;
//              code := '0';
      end
      else
      begin
        code := SegTriInt( Faces[f_l], q, r, p )
      end;
      case code of
      stiDegenerate, stiVertexOnSegment, stiEdgeOnSegment:
        begin
          Goto Loop;
          // degenerate, start over
        end;
      stiFaceOnSegment:
        begin
          Inc(crossings);
        end;
      stiVertex:
        begin
          result := ipVertex;
//            code := 'V';
          Exit;
        end;
      stiEdge:
        begin
          result := ipEdge;
//            code := 'E';
          Exit;
        end;
      stiFace:
        begin
          result :=  ipFace;
//            code := 'F';
          Exit;
        end;
      stiMisses:
        begin
          // do nothing.
        end;
      else
        begin
          Assert(False);
        end;
        end;
//      end;

    end;
    break;

  end;
  if Odd(crossings) then
  begin
    result := ipInterior;
  end
  else
  begin
    result := ipExterior;
  end;

end;

constructor TPolyhedron.Create(VertexCount, FaceCount: integer);
begin
  SetLength(Vertices,VertexCount);
  SetLength(Faces,FaceCount);
  SetLength(Box,FaceCount);
end;

function TPolyhedron.ComputeBox(F: integer; var bmin, bmax: tPointi ) : integer;
var
  i, j, k : integer;
  radius : double;
begin

  for i := 0 to F-1 do
  begin
    for j := 0 to DIM-1 do
    begin
      if( Vertices[i][j] < bmin[j] ) then
      begin
	bmin[j] := Vertices[i][j];
      end;
      if( Vertices[i][j] > bmax[j] ) then
      begin
	bmax[j] := Vertices[i][j];
      end;
    end;
  end;
  
  radius := sqrt( Sqr(bmax[X] - bmin[X]) +
                 Sqr(bmax[Y] - bmin[Y]) +
                 Sqr(bmax[Z] - bmin[Z]) );
//  ShowMessage(FloatToStr(radius));
//  printf("radius = %lf\n", radius);

  result := round( radius +1 ) + 1;
end;


end.
