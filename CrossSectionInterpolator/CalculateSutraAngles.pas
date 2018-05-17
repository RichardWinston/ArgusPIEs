unit CalculateSutraAngles;

interface

uses AnePIE, FunctionPie;

procedure CalculateAngle1(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR;
  numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR;
  funHandle : ANE_PTR;
  reply : ANE_PTR); cdecl;

procedure CalculateAngle2(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR;
  numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR;
  funHandle : ANE_PTR;
  reply : ANE_PTR); cdecl;

procedure CalculateAngle3(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR;
  numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR;
  funHandle : ANE_PTR;
  reply : ANE_PTR); cdecl;

// Calculate a weighted average between two angle measured in degrees.
// Parameters: Angle1, Angle2, Fraction
// Fraction is the weight to be applied to Angle1
// 1-Fraction is the weight to be applied to Angle2
procedure AverageAngles(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR;
  numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR;
  funHandle : ANE_PTR;
  reply : ANE_PTR); cdecl;

var
  gSutraAngle1PIEDesc         : ANEPIEDesc;
  gSutraAngle1FunctionPieDesc :  FunctionPIEDesc;

  gSutraAngle2PIEDesc         : ANEPIEDesc;
  gSutraAngle2FunctionPieDesc :  FunctionPIEDesc;

  gSutraAngle3PIEDesc         : ANEPIEDesc;
  gSutraAngle3FunctionPieDesc :  FunctionPIEDesc;

  gAverageAnglesPIEDesc         : ANEPIEDesc;
  gAverageAnglesFunctionPieDesc :  FunctionPIEDesc;


implementation

uses Math, ParamArrayUnit;

const
  Tolerance = 1e-14;

function Angle2(const MapHeading, Dip, DipDirection: double): double;
var
  DeltaAngle: double;
begin
  Assert((MapHeading <= Pi) and (MapHeading >= -Pi));
  Assert((Dip <= Pi/2) and (Dip >= 0));
  Assert((DipDirection <= Pi) and (DipDirection >= -Pi));

  DeltaAngle := MapHeading-DipDirection;

  // Make sure DeltaAngle is in the range -Pi to Pi.
  While DeltaAngle < -Pi do
  begin
    DeltaAngle := DeltaAngle + 2*Pi;
  end;
  While DeltaAngle > Pi do
  begin
    DeltaAngle := DeltaAngle - 2*Pi;
  end;

  if Abs(DeltaAngle) < Tolerance then
  begin
    // Map direction = dip direction so result = Dip.
    result := Dip;
  end
  else if Abs(DeltaAngle - Pi)/Pi < Tolerance then
  begin
    // Map direction is opposite of dip direction so result = -Dip.
    result := -Dip;
  end
  else if Abs(DeltaAngle + Pi)/Pi < Tolerance then
  begin
    // Map direction is opposite of dip direction so result = -Dip.
    result := -Dip;
  end
  else if Abs(DeltaAngle - Pi/2)/Pi < Tolerance then
  begin
    // Map direction 90 degrees away from dip direction so result = 0.
    result := 0;
  end
  else if Abs(DeltaAngle + Pi/2)/Pi < Tolerance then
  begin
    // Map direction 90 degrees away from dip direction so result = 0.
    result := 0;
  end
  else
  begin
    result := ArcTan2(Tan(Dip), 1/Cos(DeltaAngle));
  end;
  result := -result;
end;

function Angle1(MapHeading, Dip, DipDirection: double): double;
var
  DipInMapHeadingDirection: double;
begin
  DipInMapHeadingDirection := -Angle2(MapHeading, Dip, DipDirection);
  if (DipInMapHeadingDirection < -Pi/2)
    or (DipInMapHeadingDirection > Pi/2) then
  begin
    MapHeading := MapHeading + Pi;
  end;
  result := MapHeading;
  While result < -Pi do
  begin
    result := result + 2*Pi;
  end;
  While result > Pi do
  begin
    result := result - 2*Pi;
  end;
end;

function Angle3(const MapHeading, Dip, DipDirection: double): double;
var
  DipInMapHeadingDirection: double;
  X1, Y1, Z1: double;
  X2, Y2, Z2: double;
  HorizontalLength: double;
  Length1, Length2: double;
  DotProduct: double;
  DeltaAngle: double;
  CosAngle: Double;
begin
  if Abs(MapHeading - DipDirection - Pi/2)< Tolerance then
  begin
    result := -Dip;
    Exit;
  end
  else if Abs(MapHeading - DipDirection - Pi/2 + 2*Pi)< Tolerance then
  begin
    result := -Dip;
    Exit;
  end
  else if Abs(MapHeading - DipDirection - Pi/2 - 2*Pi)< Tolerance then
  begin
    result := -Dip;
    Exit;
  end
  else if Abs(MapHeading - DipDirection + Pi/2)< Tolerance then
  begin
    result := Dip;
    Exit;
  end
  else if Abs(MapHeading - DipDirection + Pi/2 + 2*Pi)< Tolerance then
  begin
    result := Dip;
    Exit;
  end
  else if Abs(MapHeading - DipDirection + Pi/2 - 2*Pi)< Tolerance then
  begin
    result := Dip;
    Exit;
  end;

  // The Dot product of two vectors equals the product of the
  // lengths of the vectors times the cosine of the angle
  // between them.

  // Get components of the vectors.
  DipInMapHeadingDirection := -Angle2(MapHeading, Dip, DipDirection);
  if Abs(Dip) < 1e-15 then
  begin
    if (Abs(DipInMapHeadingDirection) < Tolerance)
      or (Abs(DipInMapHeadingDirection + Pi) < Tolerance)
      or (Abs(DipInMapHeadingDirection - Pi) < Tolerance) then
    begin
      result := 0;
      Exit;
    end;

    Z1 := 0;
    HorizontalLength := 1;
  end
  else
  begin
    Z1 := 1;
    HorizontalLength := Tan(Dip);
  end;

  X1 := Cos(MapHeading)*HorizontalLength;
  Y1 := Sin(MapHeading)*HorizontalLength;

  if Abs(DipInMapHeadingDirection) < Tolerance then
  begin
    Z2 := 0;
    HorizontalLength := 1;
  end
  else
  begin
    Z2 := 1;
    HorizontalLength := Tan(DipInMapHeadingDirection);
  end;

  X2 := Cos(DipDirection)*HorizontalLength;
  Y2 := Sin(DipDirection)*HorizontalLength;

  // compute lengths.
  Length1 := Sqrt(Sqr(X1) + Sqr(Y1) + Sqr(Z1));
  Length2 := Sqrt(Sqr(X2) + Sqr(Y2) + Sqr(Z2));

  // compute dot product.
  DotProduct := X1*X2 + Y1*Y2 + Z1*Z2;
  // compute angle.
  CosAngle := DotProduct/(Length1*Length2);
  if CosAngle > 1 then
  begin
    CosAngle := 1;
  end
  else if CosAngle < -1 then
  begin
    CosAngle := -1;
  end;
  result := ArcCos(CosAngle);

  DeltaAngle := MapHeading-DipDirection;

  // Make sure DeltaAngle is in the range -Pi to Pi.
  While DeltaAngle < -Pi do
  begin
    DeltaAngle := DeltaAngle + 2*Pi;
  end;
  While DeltaAngle > Pi do
  begin
    DeltaAngle := DeltaAngle - 2*Pi;
  end;
  if DeltaAngle < 0 then
  begin
    result := -result;
  end;
end;

procedure ConvertAngles(param: PParameter_array; var MapHeading: ANE_DOUBLE;
  var Dip: ANE_DOUBLE; var DipDirection: ANE_DOUBLE);
var
  param1_ptr: ANE_DOUBLE_PTR;
  param2_ptr: ANE_DOUBLE_PTR;
  param3_ptr: ANE_DOUBLE_PTR;
begin
{ On input:
  param points to the angles measured in degrees
  Map heading (extracted from param is in degrees clockwise from North)
    is the map direction of the maximum permeabilty.
  Dip is the dip angle of the bedding plane in degrees down from the horizontal.
  DipDirection is the direction of steepest descent of the horizontal plane
    in degrees clockwise from North.

  on output MapHeading and DipDirection are measured
    counterclockwise from east and all the angles are measured in radians
}
  param2_ptr := param^[1];
  Dip := param2_ptr^;

  param1_ptr := param^[0];
  MapHeading := param1_ptr^;
  MapHeading := 90 - MapHeading;

//  if (Dip > 90) or (Dip < -90) then
//  begin
//    MapHeading := MapHeading + 180;
//  end;
  while MapHeading < -180 do
  begin
    MapHeading := MapHeading + 360;
  end;
  while MapHeading > 180 do
  begin
    MapHeading := MapHeading - 360;
  end;

  param3_ptr := param^[2];
  DipDirection := param3_ptr^;
  DipDirection := 90 - DipDirection;
  if (Dip > 90) or (Dip < 0) then
  begin
    DipDirection := DipDirection + 180;
  end;
  while DipDirection < -180 do
  begin
    DipDirection := DipDirection + 360;
  end;
  while DipDirection > 180 do
  begin
    DipDirection := DipDirection - 360;
  end;

  if (Dip > 90) then
  begin
    Dip := 180 - Dip;
  end
  else if (Dip < -90) then
  begin
    Dip := 180 + Dip;
  end
  else if (Dip < 0) then
  begin
    Dip := -Dip;
  end;

  MapHeading := MapHeading * Pi / 180;
  Dip := Dip * Pi / 180;
  DipDirection := DipDirection * Pi / 180;

end;

procedure CalculateAngle1(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR;
  numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR;
  funHandle : ANE_PTR;
  reply : ANE_PTR); cdecl;
var
  MapHeading : ANE_DOUBLE;
  Dip : ANE_DOUBLE;
  DipDirection : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
  Ang2: double;
begin
  try
    param := @parameters^;
    ConvertAngles(param, MapHeading, Dip, DipDirection);

    result := Angle1(MapHeading,Dip,DipDirection);

    Ang2 := Angle2(MapHeading,Dip,DipDirection);
    if (Ang2 < -Pi/2) or (Ang2 > Pi/2) then
    begin
      result := result + Pi;
    end;

    While result > Pi do
    begin
      result := result - 2*Pi;
    end;

    result := result *180/Pi;

  except
    result := -1000;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure CalculateAngle2(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR;
  numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR;
  funHandle : ANE_PTR;
  reply : ANE_PTR); cdecl;
var
  MapHeading : ANE_DOUBLE;
  Dip : ANE_DOUBLE;
  DipDirection : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    ConvertAngles(param, MapHeading, Dip, DipDirection);

    result := Angle2(MapHeading,Dip,DipDirection);
    if result < -Pi/2 then
    begin
      result := result + Pi;
    end
    else if result > Pi/2 then
    begin
      result := result - Pi;
    end;

    While result > Pi do
    begin
      result := result - 2*Pi;
    end;

    result := result *180/Pi;

  except
    result := -1000;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure CalculateAngle3(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR;
  numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR;
  funHandle : ANE_PTR;
  reply : ANE_PTR); cdecl;
var
  MapHeading : ANE_DOUBLE;
  Dip : ANE_DOUBLE;
  DipDirection : ANE_DOUBLE;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    ConvertAngles(param, MapHeading, Dip, DipDirection);

    result := Angle3(MapHeading,Dip,DipDirection);

    result := result *180/Pi;

  except
    result := -1000;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure AdjustAngle(var Angle1: ANE_DOUBLE);
begin
  while (Angle1 > 180) do
  begin
    Angle1 := Angle1 - 360;
  end;
  while (Angle1 < -180) do
  begin
    Angle1 := Angle1 + 360;
  end;
end;

procedure AverageAngles(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR;
  numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR;
  funHandle : ANE_PTR;
  reply : ANE_PTR); cdecl;
var
  param : PParameter_array;
  param1_ptr: ANE_DOUBLE_PTR;
  param2_ptr: ANE_DOUBLE_PTR;
  param3_ptr: ANE_DOUBLE_PTR;
  Angle1, Angle2, Fraction: ANE_DOUBLE;
  difference: double;
  result : ANE_DOUBLE;
begin
  try
    param := @parameters^;
    param1_ptr := param^[0];
    param2_ptr := param^[1];
    param3_ptr := param^[2];

    Angle1   := param1_ptr^;
    Angle2   := param2_ptr^;
    Fraction := param3_ptr^;
    AdjustAngle(Angle1);
    AdjustAngle(Angle2);
    if Fraction >= 1 then
    begin
      result := Angle1;
    end
    else if Fraction <= 0 then
    begin
      result := Angle2;
    end
    else
    begin
      difference := Angle1 - Angle2;
      if difference > 180 then
      begin
        Angle1 := Angle1 - 360;
      end
      else if difference < -180 then
      begin
        Angle1 := Angle1 + 360;
      end;
      difference := Angle1 - Angle2;
      if difference > 90 then
      begin
        Angle1 := Angle1 - 180;
      end
      else if difference < -90 then
      begin
        Angle1 := Angle1 + 180;
      end;
      result := Fraction*Angle1 + (1-Fraction)*Angle2;
      AdjustAngle(result);
    end;
  except
    result := -1000;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;

end;


end.
