unit FiniteElemInterp;

interface

type
  TDoubArray4 = array[1..4] of double;

{
  FiniteElementInterpolate:

  Input: X, Y = the X and Y coordinates of a point.

  Input: XCorners, YCorners = the coordinates of 4 corners
    of a quadrilateral element in counterclockwise order
    containing X and Y.

  Input: CornerValues = the values of some parameter of
    interest at the four corners of a quadrilateral element.

  Output: Error;  Error is set to True if (X, Y) is not
    inside the quadrilateral. Otherwise Error is set to False.
    
  Output: Z_Out = the interpolated value of the values in
    CornerValues at (XSI, ETA) using a finite element
    Basis function.
}
procedure FiniteElementInterpolate(const X, Y: double;
  const XCorners, YCorners, CornerValues: TDoubArray4;
  out Error: boolean; out Z_Out: double);

implementation

{
  ConvertCoord2:

  Input: XK, YK = the X and Y coordinates of a point.
  Input: XCorners, YCorners = the coordinates of 4 corners
    of a quadrilateral in counterclockwise order containing
    XK and YK.
  Output: Error;  Error is set to True if (XK, YK) is not
    inside the quadrilateral. Otherwise Error is set to False.
  Output: XSI, ETA the converted coordinates of XK, YK
    in a square whose diagonal is from (-1,-1) to (1,1).

  ConvertCoord2 has been converted from
  SUBROUTINE ITER2D in SutraPlot.
}

procedure ConvertCoord2(const XK, YK: double;
  const XCorners, YCorners: TDoubArray4; out Error: boolean;
  out XSI, ETA: double);
var
  X1, X2, X3, X4: double;
  Y1, Y2, Y3, Y4: double;
  AX, BX, CX, DX: double;
  AY, BY, CY, DY: double;
  ITER, ITOTAL: integer;
  XSI0, ETA0: double;
  F10, F20, FP11, FP12, FP21, FP22: double;
  DET, DELXSI, DELETA: double;
const
  ITRMAX = 10;
  TOL = 0.001;
  EPS = 0.001;
begin
  Error := True;
  X1 := XCorners[1];
  X2 := XCorners[2];
  X3 := XCorners[3];
  X4 := XCorners[4];
  Y1 := YCorners[1];
  Y2 := YCorners[2];
  Y3 := YCorners[3];
  Y4 := YCorners[4];

  AX := +X1 + X2 + X3 + X4;
  BX := -X1 + X2 + X3 - X4;
  CX := -X1 - X2 + X3 + X4;
  DX := +X1 - X2 + X3 - X4;
  AY := +Y1 + Y2 + Y3 + Y4;
  BY := -Y1 + Y2 + Y3 - Y4;
  CY := -Y1 - Y2 + Y3 + Y4;
  DY := +Y1 - Y2 + Y3 - Y4;

  ITER := 0;
  XSI := 0.;
  ETA := 0.;

  //!.....START OF ITERATION LOOP
  repeat
    XSI0 := XSI;
    ETA0 := ETA;
    ITER := ITER + 1;

    ITOTAL := ITOTAL + 1;

    F10 := AX - 4. * XK + BX * XSI0 + CX * ETA0 + DX * XSI0 * ETA0;
    F20 := AY - 4. * YK + BY * XSI0 + CY * ETA0 + DY * XSI0 * ETA0;

    FP11 := BX + DX * ETA0;
    FP12 := CX + DX * XSI0;
    FP21 := BY + DY * ETA0;
    FP22 := CY + DY * XSI0;

    DET := FP11 * FP22 - FP12 * FP21;

    DELXSI := (-F10 * FP22 + F20 * FP12) / DET;
    DELETA := (-F20 * FP11 + F10 * FP21) / DET;

    XSI := XSI0 + DELXSI;
    ETA := ETA0 + DELETA;

    //!.....Continue iterating if change in XSI, ETA or ZETA > .001
    if (ITER > ITRMAX) then
    begin
      Exit;
    end;

    if (ABS(DELXSI) > TOL) or (ABS(DELETA) > TOL) then
      Continue;

    //!.....END OF ITERATION LOOP

    if (ABS(XSI) > 1.0 + EPS) then
    begin
      Error := True;
      Exit;
    end;
    if (ABS(ETA) > 1.0 + EPS) then
    begin
      Error := True;
      Exit;
    end;
    Error := False;
    Exit;
  until False;

end;

{
  InterpolateInSquare:

  Input: CornerValues = the values of some parameter of
    interest at the four corners of a square whose diagonal
    extend from (-1,-1) to (1,1).
  Input: XSI, ETA = the X and Y coordinates of a point in
    that square.
  Output: Z_Out = the interpolated value of the values in
    CornerValues at (XSI, ETA) using a finite element
    Basis function.
}
procedure InterpolateInSquare(const CornerValues: TDoubArray4;
  const XSI, ETA: double; out Z_Out: double);
var
  N1, N2, N3, N4: double;
begin
  N1 := (1 - XSI) * (1 - ETA) / 4;
  N2 := (1 + XSI) * (1 - ETA) / 4;
  N3 := (1 + XSI) * (1 + ETA) / 4;
  N4 := (1 - XSI) * (1 + ETA) / 4;
  Z_Out := N1 * CornerValues[1]
    + N2 * CornerValues[2]
    + N3 * CornerValues[3]
    + N4 * CornerValues[4];
end;

procedure FiniteElementInterpolate(const X, Y: double;
  const XCorners, YCorners, CornerValues: TDoubArray4;
  out Error: boolean; out Z_Out: double);
var
  XSI, ETA: double;
begin
  ConvertCoord2(X, Y, XCorners, YCorners, Error, XSI, ETA);
  if not Error then
  begin
    InterpolateInSquare(CornerValues, XSI, ETA, Z_Out);
  end;
end;

end.
