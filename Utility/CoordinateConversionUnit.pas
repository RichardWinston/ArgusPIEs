unit CoordinateConversionUnit;

interface

type
  TEllipsoid = record
    LowerCase_a: double;
    e_square: double;
    k_zero: double;
    e_prime_square: double;
  end;

procedure ConvertToUTM(const LatitudeRadians,
  LongitudeRadians, CentralMeridianInRadians: double;
  out X, Y: double);

const
  // From Snyder, 1987
  Clarke1866: TEllipsoid =
    (LowerCase_a: 6378206.4;
    e_square: 0.00676866;
    k_zero: 0.9996;
    e_prime_square: 0.00676866/(1-0.00676866));

  // all others from Peter H. Dana
  // http://www.colorado.edu/geography/gcraft/notes/coordsys/coordsys_f.html
  // See also http://earth-info.nga.mil/GandG/geolay/TR80003A.html
  Airy1830: TEllipsoid =
    (LowerCase_a: 6377563.396;
    e_square: 0.00667054;
    k_zero: 0.9996;
    e_prime_square: 0.00667054/(1-0.00667054));

  Bessel1841: TEllipsoid =
    (LowerCase_a: 6377397.155;
    e_square: 0.006674372;
    k_zero: 0.9996;
    e_prime_square: 0.006674372/(1-0.006674372));

  Clarke1880: TEllipsoid =
    (LowerCase_a: 6378249.145;
    e_square: 0.006803511;
    k_zero: 0.9996;
    e_prime_square: 0.006803511/(1-0.006803511));

  Everest1830: TEllipsoid =
    (LowerCase_a: 6377276.345;
    e_square: 0.006637847;
    k_zero: 0.9996;
    e_prime_square: 0.006637847/(1-0.006637847));

  Fischer1960: TEllipsoid =
    (LowerCase_a: 638166.0;
    e_square: 0.006693422;
    k_zero: 0.9996;
    e_prime_square: 0.006693422/(1-0.006693422));

  Fischer1968: TEllipsoid =
    (LowerCase_a: 638150.0;
    e_square: 0.006693422;
    k_zero: 0.9996;
    e_prime_square: 0.006693422/(1-0.006693422));

  GRS67_1967: TEllipsoid =
    (LowerCase_a: 6378160.0;
    e_square: 0.006694605;
    k_zero: 0.9996;
    e_prime_square: 0.006694605/(1-0.006694605));

  GRS75_1975: TEllipsoid =
    (LowerCase_a: 6378140.0;
    e_square: 0.006694385;
    k_zero: 0.9996;
    e_prime_square: 0.006694385/(1-0.006694385));

  GRS80_1980: TEllipsoid =
    (LowerCase_a: 6378137.0;
    e_square: 0.00669438;
    k_zero: 0.9996;
    e_prime_square: 0.00669438/(1-0.00669438));

  Hough1956: TEllipsoid =
    (LowerCase_a: 6378270.0;
    e_square: 0.00672267;
    k_zero: 0.9996;
    e_prime_square: 0.00672267/(1-0.00672267));

  International1924: TEllipsoid =
    (LowerCase_a: 6378388.0;
    e_square: 0.00672267;
    k_zero: 0.9996;
    e_prime_square: 0.00672267/(1-0.00672267));

  Krassowsky1940: TEllipsoid =
    (LowerCase_a: 6378245.0;
    e_square: 0.006693422;
    k_zero: 0.9996;
    e_prime_square: 0.006693422/(1-0.006693422));

  SouthAmerican1969: TEllipsoid =
    (LowerCase_a: 6378160.0;
    e_square: 0.006694542;
    k_zero: 0.9996;
    e_prime_square: 0.006694542/(1-0.006694542));

  WGS60_1960: TEllipsoid =
    (LowerCase_a: 6378165.0;
    e_square: 0.006693422;
    k_zero: 0.9996;
    e_prime_square: 0.006693422/(1-0.006693422));

  WGS66_1966: TEllipsoid =
    (LowerCase_a: 6378145;
    e_square: 0.006694542;
    k_zero: 0.9996;
    e_prime_square: 0.006694542/(1-0.006694542));

  WGS72_1972: TEllipsoid =
    (LowerCase_a: 6378135;
    e_square: 0.006694318;
    k_zero: 0.9996;
    e_prime_square: 0.006694318/(1-0.006694318));

  WGS84: TEllipsoid =
    (LowerCase_a: 6378137;
    e_square: 0.00669438;
    k_zero: 0.9996;
    e_prime_square: 0.00669438/(1-0.00669438));

var
  Ellipsoid: TEllipsoid;

implementation

uses Math;


{type
  TEllipsoid = record
    LowerCase_a: double;
    e_square: double;
    k_zero: double;
    e_prime_square: double;
  end; }

//const  // Clarke ellipsoid
{  LowerCase_a = 6378206.4; // in m
  e_square = 0.00676866;
  k_zero = 0.9996; // central scale factor
  e_prime_square = e_square/(1-e_square);   }

{  Clarke: TEllipsoid =
    (LowerCase_a: 6378206.4;
    e_square: 0.00676866;
    k_zero: 0.9996;
    e_prime_square: 0.00676866/(1-0.00676866));  }


function Get_N(LatitudeRadians: double): double;
begin
  result := Ellipsoid.LowerCase_a/Sqrt(1- Ellipsoid.e_square*Sqr(Sin(LatitudeRadians)));
end;

function Get_T(LatitudeRadians: double): double;
begin
  result := Sqr(Tan(LatitudeRadians));
end;

function Get_C(LatitudeRadians: double): double;
begin
  result := Ellipsoid.e_prime_square*Sqr(Cos(LatitudeRadians));
end;

function Get_A(LongitudeRadians, LatitudeRadians,
  CentralMeridianRadians: double): double;
begin
  Result := (LongitudeRadians - CentralMeridianRadians) * Cos(LatitudeRadians);
end;

function Get_M(LatitudeRadians: double): double;
var
  e_fourth, e_sixth : double;
begin
  e_fourth := Sqr(Ellipsoid.e_square);
  e_sixth := Power(Ellipsoid.e_square,3);
  Result := Ellipsoid.LowerCase_a *((1-Ellipsoid.e_square/4 - 3*e_fourth/64 - 5 * e_sixth/256)
    * LatitudeRadians - (3*Ellipsoid.e_square/8 + 3*e_fourth/32 + 45*e_sixth/1024)
    * sin(2*LatitudeRadians) + (15*e_fourth/256 + 45*e_sixth/1024)
    * sin(4*LatitudeRadians) - (35*e_sixth/3072) * sin(6*LatitudeRadians));
end;

procedure ConvertToUTM(const LatitudeRadians,
  LongitudeRadians, CentralMeridianInRadians: double;
  out X, Y: double);
const
  M_zero = 0;
var
  N, A, T, C, M  : double;
begin
  N := Get_N(LatitudeRadians);
  A := Get_A(LongitudeRadians, LatitudeRadians, CentralMeridianInRadians);
  T := Get_T(LatitudeRadians);
  C := Get_C(LatitudeRadians);
  M := Get_M(LatitudeRadians);

  X := Ellipsoid.k_zero * N *(A + (1 - T +C)*Power(A,3)/6 + (5 -18*T + Sqr(T)
    + 72*C - 58*Ellipsoid.e_prime_square)* Power(A,5)/120);

  Y := Ellipsoid.k_zero * (M - M_zero + N * Tan(LatitudeRadians) *
    (Sqr(A)/2 + (5 - T + 9*C + 4*Sqr(C)) * Power(A,4)/24 +
    (61 - 58* T + Sqr(T) + 600 * C - 330*Ellipsoid.e_prime_square)*Power(A,6)/720));

  X := X + 500000;

  if Y < 0 then
  begin
    Y := Y + 10000000
  end;
end;

initialization
  Ellipsoid := Clarke1866;

end.
