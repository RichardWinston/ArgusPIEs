unit TriangleInterpolate;

interface

uses sysutils, Dialogs, Forms, AnePIE;

procedure InitializeTriangeInterpolate(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

procedure EvaluateTriangeInterpolate(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;

procedure FreeTriangeInterpolate(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;

implementation

uses
  SfrInterpolatorUnit, CentralMeridianUnit, TripackTypes;

type
  TTriangleInterpolationRecord = record
    SfrInterpolator : TSfrInterpolator;
  end;
  PTriangleInterpRecord = ^TTriangleInterpolationRecord;

procedure InitializeTriangeInterpolate(aneHandle : ANE_PTR;

                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;
var
  SfrInterpolator: TSfrInterpolator;
  TriangleInterpRecord: PTriangleInterpRecord;
  TempX, TempY, TempV: ANE_DOUBLE_PTR;
    X, Y, Z: TFloatArray;
  PointIndex: Integer;
begin
  TempX := xCoords;
  TempY := yCoords;
  TempV := values;
  SfrInterpolator := nil;
  TriangleInterpRecord := nil;
  try
    SfrInterpolator := TSfrInterpolator.Create;

    SetLength(X, numPoints);
    SetLength(Y, numPoints);
    SetLength(Z, numPoints);

    for PointIndex := 0 to numPoints - 1 do
    begin
      X[PointIndex] := xCoords^;
      Y[PointIndex] := yCoords^;
      Z[PointIndex] := Values^;
      Inc(xCoords);
      Inc(yCoords);
      Inc(Values);
    end;

    GetMem(TriangleInterpRecord, SizeOf(TTriangleInterpolationRecord));
    SfrInterpolator.Initialize(X, Y, Z);
    TriangleInterpRecord^.SfrInterpolator := SfrInterpolator;
  except on E: Exception do
    begin
      SfrInterpolator.Free;
      FreeMem(TriangleInterpRecord);
      TriangleInterpRecord := nil;
      Beep;
    end;
  end;
  if TriangleInterpRecord = nil then
  begin
    rPIEHandle := nil;
  end
  else
  begin
    rPIEHandle := @TriangleInterpRecord^;
  end;
end;

procedure EvaluateTriangeInterpolate(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;
var
  SfrInterpolator : TSfrInterpolator;
  TriangInterRecord : PTriangleInterpRecord;
  resultPtr : ANE_DOUBLE_PTR;
begin
  try
    // Get the SfrInterpolator record from Argus;
    TriangInterRecord := pieHandle;
    if TriangInterRecord = nil then
    begin
      rResult^ := 0
    end
    else
    begin
      SfrInterpolator := TriangInterRecord^.SfrInterpolator;
      rResult^ := SfrInterpolator.Interpolate1(X,Y);
    end;
  except on E: Exception do
    begin
      // If there is an error, let the user know something went wrong.
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure FreeTriangeInterpolate(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;
var
  SfrInterpolator : TSfrInterpolator;
  TriangleInterp : PTriangleInterpRecord;
begin
  try
    // Get the Quadtree record from Argus;
    TriangleInterp := pieHandle;
    if TriangleInterp <> nil then
    begin
      SfrInterpolator := TriangleInterp^.SfrInterpolator;
      // Release the memory.
      SfrInterpolator.Free;
      FreeMem(TriangleInterp);
    end;
  except on E: Exception do
    begin
      // If there is an error, let the user know something went wrong.
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

end.
