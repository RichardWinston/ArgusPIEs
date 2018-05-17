unit QT_Nearest;

interface

uses sysutils, Classes, Dialogs, Forms, AnePIE, QuadtreeClass, ZLib;

type
  TQT_NearestData = Class(TObject)
    FileName: string;
    YMultiplier : double;
    QuadTree : TRbwQuadTree;
    Values : array of double;
    LastTime: TDateTime;
    procedure Clear;
    Constructor Create(x_min, x_max, y_min, y_max : double{; NumPoints : integer});
    Destructor Destroy; override;
  end;

procedure InitializeQT(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

procedure InitializeQTN5(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

procedure FreeQT(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;

procedure EvaluateQT_Nearest(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;

procedure EvaluateQT_5Avg(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; {var} rResult : ANE_DOUBLE_PTR) ; cdecl;

procedure EvaluateQT_20Avg(aneHandle : ANE_PTR; pieHandle : ANE_PTR;
  x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;

procedure EvaluateQT_5InvDistSq(aneHandle : ANE_PTR; pieHandle : ANE_PTR;
  x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;

procedure EvaluateQT_20InvDistSq(aneHandle : ANE_PTR; pieHandle : ANE_PTR;
  x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;

procedure InitializeAnisotropicQT10(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

procedure InitializeAnisotropicQT30(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

procedure InitializeAnisotropicQT100(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

implementation

uses
  IntListUnit, Contnrs, TempFiles;

var
  StoredData: TList;
  OpenLocations: TIntegerList;

type
  TQT_Record = record
    Position : Integer;
  end;
  PQT_Record = ^TQT_Record;

procedure SetMinMaxCoordinates(xCoords: ANE_DOUBLE_PTR; var XMin: Double;
  var XMax: Double; yCoords: ANE_DOUBLE_PTR; var YMin: Double;
  var YMax: Double; numPoints: ANE_INT32; YMultiplier: Double);
var
  TempPointer: ANE_DOUBLE_PTR;
  Temp: Double;
  Index: Integer;
  RIndex: Integer;
const
  MaxRandom = 100;
begin
  // Although the Quadtree doesn't require that the bounds used in the
  // constructor be the true bounds of all the data, it helps if, the
  // bounds don't have to be expanded too often.
  // The data is often ordered so be sure to look at the first and last data
  // point.
  // Use the first point to set XMin, XMax, YMin, and YMax
  XMin := xCoords^;
  XMax := XMin;
  YMin := yCoords^*YMultiplier;
  YMax := YMin;
  // Use the last point to update XMin, XMax, YMin, and YMax
  TempPointer := xCoords;
  Inc(TempPointer, numPoints - 1);
  Temp := TempPointer^;
  if Temp > XMax then
    XMax := Temp;
  if Temp < XMin then
    XMin := Temp;
  TempPointer := yCoords;
  Inc(TempPointer, numPoints - 1);
  Temp := TempPointer^*YMultiplier;
  if Temp > YMax then
    YMax := Temp;
  if Temp < YMin then
    YMin := Temp;
  // It might take a lot of time to look at all the data points.
  // Looking at just a few random data points will probably be sufficient.
  for Index := 0 to MaxRandom - 1 do
  begin
    RIndex := Random(numPoints);
    TempPointer := xCoords;
    Inc(TempPointer, RIndex);
    Temp := TempPointer^;
    if Temp > XMax then
      XMax := Temp;
    if Temp < XMin then
      XMin := Temp;
    TempPointer := yCoords;
    Inc(TempPointer, RIndex);
    Temp := TempPointer^*YMultiplier;
    if Temp > YMax then
      YMax := Temp;
    if Temp < YMin then
      YMin := Temp;
  end;

  // Expanding the range a little doesn't take much work and may save a
  // little time latter on.

  Temp := (XMax - XMin)*0.2;
  XMax := XMax + Temp;
  XMin := XMin - Temp;

  Temp := (YMax - YMin)*0.2;
  YMax := YMax + Temp;
  YMin := YMin - Temp;
end;

procedure StoreData(yCoords: ANE_DOUBLE_PTR; numPoints: ANE_INT32;
  values: ANE_DOUBLE_PTR; var QuadTree: TQT_NearestData;
  xCoords: ANE_DOUBLE_PTR; YMultiplier: ANE_DOUBLE);
var
  CompressStream: TCompressionStream;
  Index: Integer;
  AValue: ANE_DOUBLE;
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  try
    CompressStream := TCompressionStream.Create(clDefault, MemStream);
    try
      // Add all the data points to the quadtree and store the data value
      // in an array.
      CompressStream.Write(numPoints, SizeOf(numPoints));
      for Index := 0 to numPoints - 1 do
      begin
        AValue := xCoords^;
        CompressStream.Write(AValue, SizeOf(AValue));
        AValue := yCoords^*YMultiplier;
        CompressStream.Write(AValue, SizeOf(AValue));
        AValue := Values^;
        CompressStream.Write(AValue, SizeOf(AValue));
        Inc(xCoords);
        Inc(yCoords);
        Inc(Values);
      end;
    finally
      CompressStream.Free;
    end;
    MemStream.Position := 0;
    MemStream.SaveToFile(QuadTree.FileName);
  finally
    MemStream.Free;
  end;
end;

function SaveQuadTree(QuadTree : TQT_NearestData): integer;
begin
  if OpenLocations.Count = 0 then
  begin
    result := StoredData.Add(QuadTree);
  end
  else
  begin
    result := OpenLocations[OpenLocations.Count-1];
    OpenLocations.Delete(OpenLocations.Count-1);
    StoredData[result] := QuadTree;
  end;
end;

procedure InitializeQT(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;
var
  QuadTree : TQT_NearestData;
  XMin, XMax, YMin, YMax, Temp : ANE_DOUBLE;
  Data : PQT_Record;
  Index: integer;
begin
  QuadTree := nil;
  Data := nil;
  try
    SetMinMaxCoordinates(xCoords, XMin, XMax, yCoords, YMin, YMax, numPoints, 1);

    // Create the quattree with the calculate range.
    QuadTree := TQT_NearestData.Create(XMin, XMax, YMin, YMax);

    StoreData(yCoords, numPoints, values, QuadTree, xCoords, 1);

    // Get a record that can be passed to Argus ONE
    GetMem(Data, SizeOf(TQT_Record));

    // Put the quadtree in the record.
    Data^.Position := SaveQuadTree(QuadTree);
  except on E: Exception do
    begin
      // If there is an error, release the allocated memory and
      // let the user know something went wrong.
      QuadTree.Free;
      FreeMem(Data);
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  rPIEHandle := @Data^;
end;

procedure InitializeQTN5(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;
const
  MaxRandom = 100;
var
  QuadTree : TQT_NearestData;
  XMin, XMax, YMin, YMax, Temp : ANE_DOUBLE;
  Index, RIndex : integer;
  TempPointer : ANE_DOUBLE_PTR;
  Data : PQT_Record;
begin
  QuadTree := nil;
  Data := nil;
  try
    SetMinMaxCoordinates(xCoords, XMin, XMax, yCoords, YMin, YMax, numPoints, 1);

    // Create the quattree with the calculate range.
    QuadTree := TQT_NearestData.Create(XMin, XMax, YMin, YMax);
    QuadTree.QuadTree.MaxPoints := 5;

    StoreData(yCoords, numPoints, values, QuadTree, xCoords, 1);

    // Get a record that can be passed to Argus ONE
    GetMem(Data, SizeOf(TQT_Record));

    // Put the quadtree in the record.
    Data^.Position := SaveQuadTree(QuadTree);
  except on E: Exception do
    begin
      // If there is an error, release the allocated memory and
      // let the user know something went wrong.
      QuadTree.Free;
      FreeMem(Data);
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  rPIEHandle := @Data^;
end;

procedure InitializeAnisotropicQT(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR;
                     YMultiplier : double) ; cdecl;
const
  MaxRandom = 100;
var
  QuadTree : TQT_NearestData;
  XMin, XMax, YMin, YMax, Temp : ANE_DOUBLE;
  Index, RIndex : integer;
  TempPointer : ANE_DOUBLE_PTR;
  Data : PQT_Record;
begin
  Assert(YMultiplier <> 0);
  QuadTree := nil;
  Data := nil;
  try
    SetMinMaxCoordinates(xCoords, XMin, XMax, yCoords, YMin, YMax, numPoints,
      YMultiplier);

    // Create the quattree with the calculate range.
    QuadTree := TQT_NearestData.Create(XMin, XMax, YMin, YMax);
    QuadTree.YMultiplier := YMultiplier;

    StoreData(yCoords, numPoints, values, QuadTree, xCoords, YMultiplier);

    // Get a record that can be passed to Argus ONE
    GetMem(Data, SizeOf(TQT_Record));

    // Put the quadtree in the record.
    Data^.Position := SaveQuadTree(QuadTree);
  except on E: Exception do
    begin
      // If there is an error, release the allocated memory and
      // let the user know something went wrong.
      QuadTree.Free;
      FreeMem(Data);
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  rPIEHandle := @Data^;
end;

procedure InitializeAnisotropicQT10(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;
begin
  InitializeAnisotropicQT(aneHandle, rPIEHandle, numPoints, xCoords,  yCoords,
    values, 10);
end;

procedure InitializeAnisotropicQT30(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;
begin
  InitializeAnisotropicQT(aneHandle, rPIEHandle, numPoints, xCoords,  yCoords,
    values, 30);
end;

procedure InitializeAnisotropicQT100(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;
begin
  InitializeAnisotropicQT(aneHandle, rPIEHandle, numPoints, xCoords,  yCoords,
    values, 100);
end;

procedure FreeQT(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;
var
  QuadTree : TQT_NearestData;
  Data : PQT_Record;
begin
  try
    // Get the Quadtree record from Argus;
    Data := pieHandle;
    OpenLocations.Add(Data^.Position);
    StoredData[Data^.Position] := nil;
    // Release the memory.
    FreeMem(Data);
  except on E: Exception do
    begin
      // If there is an error, let the user know something went wrong.
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

Const
  OneMinute = 1/24/60;

procedure Restore(QuadTree: TQT_NearestData);
var
  Index: Integer;
  MemStream: TMemoryStream;
  DeCompressStream : TDecompressionStream;
  numPoints: ANE_INT32;
  X, Y, Value: ANE_DOUBLE;
  resultPtr : ANE_DOUBLE_PTR;
  AQuadTree: TQT_NearestData;
begin
  if Length(QuadTree.Values) = 0 then
  begin
    MemStream := TMemoryStream.Create;
    try
      MemStream.LoadFromFile(QuadTree.FileName);
      MemStream.Position := 0;
      DeCompressStream := TDecompressionStream.Create(MemStream);
      try
        DeCompressStream.Read(numPoints, SizeOf(numPoints));
        SetLength(QuadTree.Values, numPoints);
        for Index := 0 to numPoints-1 do
        begin
          DeCompressStream.Read(X, SizeOf(X));
          DeCompressStream.Read(Y, SizeOf(Y));
          DeCompressStream.Read(Value, SizeOf(Value));
          QuadTree.Values[Index] := Value;
          QuadTree.QuadTree.AddPoint(X, Y, Addr(QuadTree.Values[Index]));
        end;
      finally
        DeCompressStream.Free;
      end;
    finally
      MemStream.Free;
    end;
  end;
  QuadTree.LastTime := Now;


  for Index := 0 to StoredData.Count -1 do
  begin
    if (StoredData[Index] <> nil) and (StoredData[Index] <> QuadTree) then
    begin
      AQuadTree := StoredData[Index];
      if (Now - AQuadTree.LastTime > OneMinute)
        and (Length(AQuadTree.Values) > 0) then
      begin
        AQuadTree.Clear;
      end;
    end;
  end;

end;

procedure EvaluateQT_Nearest(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; {var} rResult : ANE_DOUBLE_PTR) ; cdecl;
var
  QuadTree : TQT_NearestData;
  Data : PQT_Record;
  resultPtr : ANE_DOUBLE_PTR;
begin
  try
    // Get the Quadtree record from Argus;
    Data := pieHandle;
    QuadTree := StoredData[Data^.Position];
    Restore(QuadTree);
    // find the data value of the data point closest to (X,Y)

    resultPtr := QuadTree.QuadTree.NearestPointsFirstData
      (X, Y*QuadTree.YMultiplier);
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
   except on E: Exception do
    begin
      // If there is an error, let the user know something went wrong.
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure EvaluateQT_NAvg(aneHandle : ANE_PTR; pieHandle : ANE_PTR;
  x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR; N : integer) ; cdecl;
var
  QuadTree : TQT_NearestData;
  Data : PQT_Record;
  resultPtr : ANE_DOUBLE_PTR;
  Points : TQuadPointArray;
  PointIndex, DataIndex : integer;
  Count : integer;
  APoint : TQuadPoint;
  AResult : double;
begin
  try
    // Get the Quadtree record from Argus;
    Data := pieHandle;
    QuadTree := StoredData[Data^.Position];
    Restore(QuadTree);

    QuadTree.QuadTree.FindNearestPoints(X, Y*QuadTree.YMultiplier, N, Points);

    AResult := 0;
    Count := 0;
    for PointIndex := 0 to Length(Points) -1 do
    begin
      APoint := Points[PointIndex];
      for DataIndex := 0 to Length(APoint.Data) -1 do
      begin
        resultPtr := APoint.Data[DataIndex];
        AResult  := AResult + resultPtr^;
        Inc(Count);
      end;
    end;
    if Count <> 0 then
    begin
      AResult := AResult/Count;
    end;
    // return the result to Argus ONE.
    rResult^ := AResult;
  except on E: Exception do
    begin
      // If there is an error, let the user know something went wrong.
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure EvaluateQT_5Avg(aneHandle : ANE_PTR; pieHandle : ANE_PTR;
  x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;
begin
  EvaluateQT_NAvg(aneHandle, pieHandle, x,  y, rResult, 5);
end;

procedure EvaluateQT_20Avg(aneHandle : ANE_PTR; pieHandle : ANE_PTR;
  x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;
begin
  EvaluateQT_NAvg(aneHandle, pieHandle, x,  y, rResult, 20);
end;

procedure EvaluateQT_NInvDistSq(aneHandle : ANE_PTR; pieHandle : ANE_PTR;
  x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR; N : integer) ; cdecl;
var
  QuadTree : TQT_NearestData;
  Data : PQT_Record;
  resultPtr : ANE_DOUBLE_PTR;
  Points : TQuadPointArray;
  PointIndex, DataIndex : integer;
  APoint : TQuadPoint;
  Numerator, denominator : double;
  weight : double;
begin
  try
    // Get the Quadtree record from Argus;
    Data := pieHandle;
    QuadTree := StoredData[Data^.Position];
    Restore(QuadTree);

    QuadTree.QuadTree.FindNearestPoints(X, Y*QuadTree.YMultiplier, N, Points);

    Numerator := 0;
    Denominator := 0;
    for PointIndex := 0 to Length(Points) -1 do
    begin
      APoint := Points[PointIndex];
      if APoint.Distance = 0 then
      begin
        Numerator := 0;
        for DataIndex := 0 to Length(APoint.Data) -1 do
        begin
          resultPtr := APoint.Data[DataIndex];
          Numerator  := Numerator + resultPtr^;
        end;
        Numerator := Numerator/Length(APoint.Data);
        Denominator := 0;
        break;
      end
      else
      begin
        weight := Sqr(1/APoint.Distance);
        Denominator := Denominator + weight*Length(APoint.Data);
        for DataIndex := 0 to Length(APoint.Data) -1 do
        begin
          resultPtr := APoint.Data[DataIndex];
          Numerator  := Numerator + resultPtr^*weight;
        end;
      end;
    end;
    if denominator <> 0 then
    begin
      Numerator := Numerator/denominator;
    end;

    // return the result to Argus ONE.
    rResult^ := Numerator;
  except on E: Exception do
    begin
      // If there is an error, let the user know something went wrong.
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure EvaluateQT_5InvDistSq(aneHandle : ANE_PTR; pieHandle : ANE_PTR;
  x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;
begin
  EvaluateQT_NInvDistSq(aneHandle, pieHandle, x,  y, rResult, 5);
end;

procedure EvaluateQT_20InvDistSq(aneHandle : ANE_PTR; pieHandle : ANE_PTR;
  x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;
begin
  EvaluateQT_NInvDistSq(aneHandle, pieHandle, x,  y, rResult, 20);
end;

{ TQT_NearestData }

procedure TQT_NearestData.Clear;
begin
  SetLength(Values, 0);
  QuadTree.Clear;
end;

Constructor TQT_NearestData.Create(x_min, x_max, y_min, y_max : double{;
  NumPoints : integer});
begin
  inherited Create;
  QuadTree := TRbwQuadTree.Create(Application);
  QuadTree.Xmax := x_max;
  QuadTree.Xmin := x_min;
  QuadTree.Ymax := y_max;
  QuadTree.Ymin := y_min;
  YMultiplier := 1;
  FileName := TempFileName;
end;

Destructor TQT_NearestData.Destroy;
begin
  QuadTree.Free;
  If FileExists(FileName) then
  begin
    DeleteFile(FileName);
  end;
  inherited;
end;

Initialization;
  Randomize;
  StoredData := TObjectList.Create;
  OpenLocations := TIntegerList.Create;

finalization
  StoredData.Free;
  OpenLocations.Free;

end.
