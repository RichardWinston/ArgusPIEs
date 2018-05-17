unit icnorm;



interface

function invCumNorm(const p: double): double;

implementation
uses math;
// Coefficients in rational approximations.

const a: array[1..6] of double=(

-3.969683028665376e+01,
  2.209460984245205e+02,
 -2.759285104469687e+02,
  1.383577518672690e+02,
-3.066479806614716e+01,
 2.506628277459239e+00 );

const b: array[1..5] of double =(

 -5.447609879822406e+01,
 1.615858368580409e+02,
 -1.556989798598866e+02,
  6.680131188771972e+01,
 -1.328068155288572e+01  );

const c: array[1..6] of double=(

 -7.784894002430293e-03,
 -3.223964580411365e-01,
 -2.400758277161838e+00,
 -2.549732539343734e+00,
  4.374664141464968e+00,
  2.938163982698783e+00  );

const d: array[1..4] of double=(
 7.784695709041462e-03,
 3.224671290700398e-01,
 2.445134137142996e+00,
 3.754408661907416e+00 );

//Define break-points.

const p_low = 0.02425;
const p_high = 1 - p_low ;
//const infinity=1.7E308; // maximum size of double


function invCumNorm(const p: double): double;
// function obtained from P. J. Acklam,
// http://home.online.no/~pjacklam/notes/invnorm/index.html
var q,r: extended;

   begin
   if ((p<=0) or (p>=1)) then raise Einvalidargument.create('Inverse Cum Norm argument must be in range 0<p<1');

   //Rational approximation for lower region.
   if ((0 < p) and  (p< p_low)) then begin
      q := sqrt(-2*ln(p));
      result := (((((c[1]*q+c[2])*q+c[3])*q+c[4])*q+c[5])*q+c[6]) /
         ((((d[1]*q+d[2])*q+d[3])*q+d[4])*q+1);
   end;

  //Rational approximation for central region.
  if (p_low <= p) and (p <= p_high ) then begin
      q := p - 0.5 ;
      r := q*q ;
      result := (((((a[1]*r+a[2])*r+a[3])*r+a[4])*r+a[5])*r+a[6])*q /
        (((((b[1]*r+b[2])*r+b[3])*r+b[4])*r+b[5])*r+1) ;
   end;

   //Rational approximation for upper region.
   if ((p_high < p) and (p < 1))  then begin
      q := sqrt(-2*ln(1-p));
      result := -(((((c[1]*q+c[2])*q+c[3])*q+c[4])*q+c[5])*q+c[6]) /
          ((((d[1]*q+d[2])*q+d[3])*q+d[4])*q+1)  ;
   end;
end;

end.
