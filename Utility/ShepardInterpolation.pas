unit ShepardInterpolation;

interface

uses sysutils, Dialogs, Forms, AnePIE;

procedure InitializeShepard(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

procedure EvaluateShepard(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;

procedure FreeShepard(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;

implementation

uses Math, QSHEP2D_p, QuadtreeClass;

type
  TShepardData = Class(TObject)
    YMultiplier : double;
    QuadTree : TRbwQuadTree;
    Values : array of double;
//    MemStream: TMemoryStream;
//    DeCompressStream: TDecompressionStream;
//    CurrentPosition: Int64;
    Constructor Create(x_min, x_max, y_min, y_max : double; NumPoints : integer);
    Destructor Destroy; override;
  end;

  TShepardObject = class(TObject)
    N: integer;
    X, Y, F: TSingleArray;
    NQ, NW, NR : integer;
    LCELL: T2DIntegerArray;
    LNEXT: TIntegerArray;
    XMIN, YMIN, DX, DY, RMAX: single;
    RSQ: TSingleArray;
    A: T5SingleArray;
    IER: integer;
    PointsFound: boolean;
    MaxValue, MinValue: double;
    Constructor Create;
    procedure Initialize;
    function Evaluate(PX,PY: Single): double;
  end;

  TShepardRecord = record
    ShepardData : TShepardObject;
    QuadTree : TShepardData;
  end;
  PShepardRecord = ^TShepardRecord;


procedure InitializeShepard(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;
const
  MaxRandom = 100;
var
  ShepardObject: TShepardObject;
  ShepardRecord: PShepardRecord;
  QuadTree : TShepardData;
  Index, RIndex: integer;
  XMin, XMax, YMin, YMax, Temp : double;
  TempX, TempY, TempV: ANE_DOUBLE_PTR;
  TempPointer : ANE_DOUBLE_PTR;
  DeltaV: double;
begin
  TempX := xCoords;
  TempY := yCoords;
  TempV := values;
  ShepardObject := nil;
  ShepardRecord := nil;
  QuadTree := nil;
  try
    ShepardObject := TShepardObject.Create;

    ShepardObject.N := numPoints;
    ShepardObject.NQ := Min(40, numPoints-1);
    if ShepardObject.NQ > 13 then
    begin
      ShepardObject.NQ := 13;
    end;
    ShepardObject.NW := Min(40, numPoints-1);
    if ShepardObject.NW > 19 then
    begin
      ShepardObject.NW := 19;
    end;
    ShepardObject.NR := Round(SQRT(numPoints/3));
    SetLength(ShepardObject.LCELL, Sqr(ShepardObject.NR), Sqr(ShepardObject.NR));
    SetLength(ShepardObject.LNEXT, numPoints);
    SetLength(ShepardObject.RSQ, numPoints);
    SetLength(ShepardObject.A[0], numPoints);
    SetLength(ShepardObject.A[1], numPoints);
    SetLength(ShepardObject.A[2], numPoints);
    SetLength(ShepardObject.A[3], numPoints);
    SetLength(ShepardObject.A[4], numPoints);

    SetLength(ShepardObject.X, numPoints);
    SetLength(ShepardObject.Y, numPoints);
    SetLength(ShepardObject.F, numPoints);

    ShepardObject.MaxValue := Values^;
    ShepardObject.MinValue := Values^;
    for Index := 0 to numPoints -1 do
    begin
      ShepardObject.F[Index] := Values^;
      ShepardObject.X[Index] := xCoords^;
      ShepardObject.Y[Index] := yCoords^;
      if Values^ > ShepardObject.MaxValue then
      begin
        ShepardObject.MaxValue := Values^
      end
      else if Values^ < ShepardObject.MinValue then
      begin
        ShepardObject.MinValue := Values^
      end;
      Inc(xCoords);
      Inc(yCoords);
      Inc(Values);
    end;

    DeltaV := ShepardObject.MaxValue - ShepardObject.MinValue;

    ShepardObject.MaxValue := ShepardObject.MaxValue + DeltaV*0.2;
    ShepardObject.MinValue := ShepardObject.MinValue - DeltaV*0.2;
    if numPoints >= 6 then
    begin
      ShepardObject.Initialize;
      if ShepardObject.IER <> 0 then
      begin
        Raise Exception.Create('Error initializeing Shepards interpolation method');
      end;
    end;

    xCoords := TempX;
    yCoords := TempY;
    values  := TempV;

    XMin := xCoords^;
    XMax := XMin;
    YMin := yCoords^;
    YMax := YMin;
    TempPointer := xCoords;
    Inc(TempPointer, numPoints-1);
    Temp := TempPointer^;
    if Temp > XMax then XMax := Temp;
    if Temp < XMin then XMin := Temp;
    TempPointer := yCoords;
    Inc(TempPointer, numPoints-1);
    Temp := TempPointer^;
    if Temp > YMax then YMax := Temp;
    if Temp < YMin then YMin := Temp;

    // It might take a lot of time to look at all the data points.
    // Looking at just a few random data points will probably be sufficient.
    for Index := 0 to MaxRandom-1 do
    begin
      RIndex := Random(numPoints);
      TempPointer := xCoords;
      Inc(TempPointer, RIndex);
      Temp := TempPointer^;
      if Temp > XMax then XMax := Temp;
      if Temp < XMin then XMin := Temp;
      TempPointer := yCoords;
      Inc(TempPointer, RIndex);
      Temp := TempPointer^;
      if Temp > YMax then YMax := Temp;
      if Temp < YMin then YMin := Temp;
    end;

    // Expanding the range a little doesn't take much work and may save a
    // little time latter on.

    Temp := (XMax - XMin)*0.2;
    XMax := XMax + Temp;
    XMin := XMin - Temp;

    Temp := (YMax - YMin)*0.2;
    YMax := YMax + Temp;
    YMin := YMin - Temp;

    // Create the quattree with the calculate range.
    QuadTree := TShepardData.Create(XMin, XMax, YMin, YMax, numPoints);

    // Add all the data points to the quadtree and store the data value
    // in an array.
    for Index := 0 to numPoints -1 do
    begin
      QuadTree.Values[Index] := Values^;
      QuadTree.QuadTree.AddPoint(xCoords^, yCoords^, Addr(QuadTree.Values[Index]));
      Inc(xCoords);
      Inc(yCoords);
      Inc(Values);
    end;



    // Get a record that can be passed to Argus ONE
    GetMem(ShepardRecord, SizeOf(TShepardRecord));

    // Put the quadtree in the record.
    ShepardRecord^.ShepardData := ShepardObject;
    ShepardRecord^.QuadTree := QuadTree;
  except on E: Exception do
    begin
      // If there is an error, release the allocated memory and
      // let the user know something went wrong.
      ShepardObject.Free;
      QuadTree.Free;
      FreeMem(ShepardRecord);
      ShepardRecord := nil;
      Beep;
//      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  if ShepardRecord = nil then
  begin
    rPIEHandle := nil;
  end
  else
  begin
    rPIEHandle := @ShepardRecord^;
  end;
end;

procedure FreeShepard(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;
var
  ShepardObject : TShepardObject;
  ShepardRecord : PShepardRecord;
  QuadTree : TShepardData;
begin
  try
    // Get the Quadtree record from Argus;
    ShepardRecord := pieHandle;
    if ShepardRecord <> nil then
    begin
      ShepardObject := ShepardRecord^.ShepardData;
      QuadTree := ShepardRecord^.QuadTree;
      // Release the memory.
      ShepardObject.Free;
      QuadTree.Free;
      FreeMem(ShepardRecord);
    end;
  except on E: Exception do
    begin
      // If there is an error, let the user know something went wrong.
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;


procedure EvaluateShepard(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;
var
  ShepardObject : TShepardObject;
  ShepardRecord : PShepardRecord;
  resultPtr : ANE_DOUBLE_PTR;
  QuadTree : TShepardData;
begin
  try
    // Get the ShepardObject record from Argus;
    ShepardRecord := pieHandle;
    if ShepardRecord = nil then
    begin
      rResult^ := 0
    end
    else
    begin
      ShepardObject := ShepardRecord^.ShepardData;
      rResult^ := ShepardObject.Evaluate(X,Y);
      if not ShepardObject.PointsFound then
      begin
        QuadTree := ShepardRecord^.QuadTree;
        // find the Index of the data value of the data point closest to (X,Y)
        resultPtr := QuadTree.QuadTree.NearestPointsFirstData
          (X, Y);
        if resultPtr = nil then
        begin
          // raising an error here could lead to the user having to deal with a
          // large number of error messages.  We need a better solution.
          rResult^ := 0;
        end
        else
        begin
          // return the result to Argus ONE.
          rResult^ := resultPtr^;
        end;
      end;
      if rResult^ < ShepardObject.MinValue then
      begin
        rResult^ := ShepardObject.MinValue;
      end
      else if rResult^ > ShepardObject.MaxValue then
      begin
        rResult^ := ShepardObject.MaxValue;
      end;

    end;
  except on E: Exception do
    begin
      // If there is an error, let the user know something went wrong.
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;


{ TShepardObject }

constructor TShepardObject.Create;
begin
  N := 0;
end;

function TShepardObject.Evaluate(PX,PY: Single): double;
var
  Index: integer;
begin
  if N >= 6 then
  begin
    result := QS2VAL (PX,PY, N, X,Y,F, NR, LCELL, LNEXT, XMIN, YMIN,DX,DY,
      RMAX, RSQ, A, PointsFound);
  end
  else
  begin
    PointsFound := True;
    result := 0;
    for Index := 0 to N-1 do
    begin
      result := result + F[Index];
    end;
    if N > 0 then
    begin
      result := result / N;
    end
    else
    begin
      PointsFound := False
    end;
  end;
end;

procedure TShepardObject.Initialize;
begin
  QSHEP2(N, X, Y, F, NQ, NW, NR, LCELL, LNEXT, XMIN, YMIN, DX, DY, RMAX, RSQ,
    A, IER);
end;

{ TShepardData }

constructor TShepardData.Create(x_min, x_max, y_min, y_max: double;
  NumPoints: integer);
begin
  inherited Create;
  QuadTree := TRbwQuadTree.Create(Application);
  QuadTree.Xmax := x_max;
  QuadTree.Xmin := x_min;
  QuadTree.Ymax := y_max;
  QuadTree.Ymin := y_min;
  SetLength(Values, NumPoints);
  YMultiplier := 1;
//  MemStream := TMemoryStream.Create;
//  DeCompressStream := TDecompressionStream.Create(MemStream);
//  CurrentPosition := 0;
end;

destructor TShepardData.Destroy;
begin
  QuadTree.Free;
  inherited;
end;

end.
