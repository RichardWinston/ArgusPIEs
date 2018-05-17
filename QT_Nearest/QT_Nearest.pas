unit QT_Nearest;

interface

uses sysutils, Dialogs, AnePIE;

{procedure InitializeQT_Nearest(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

procedure FreeQT_Nearest(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;

procedure EvaluateQT_Nearest(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;  }

procedure InitializeQT_Nearest2(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

procedure FreeQT_Nearest2(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;

procedure EvaluateQT_Nearest2(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;

implementation

uses QuadtreeClass;

{
var
  QTResult : ANE_DOUBLE;
}

type
  TQT_NearestData = Class(TObject)
    QuadTree : TQuadTree;
    Values : array of double;
    Constructor Create(x_min, x_max, y_min, y_max : double; NumPoints : integer);
    Destructor Destroy; override;
  end;
  TQT_Record = record
    Data : TQT_NearestData;
  end;
  PQT_Record = ^TQT_Record;

  TQuadTreeRecord = record
    QuadTree : TQuadTree;
  end;
  PQuadTreeRecord = ^TQuadTreeRecord;

procedure FreeData(Data : pointer);
begin
  FreeMem(Data);
end;
{
procedure InitializeQT_Nearest(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;
const
  MaxRandom = 100;
//  Type TXY = (xx, yy);
var
  QuadTree : TQuadTree;
  XMin, XMax, YMin, YMax, Temp : double;
  Index, RIndex : integer;
  DataPointer : ANE_DOUBLE_PTR;
  TempPointer : ANE_DOUBLE_PTR;
  Data : PQuadTreeRecord;
begin
  try
    Data := nil;
    rPIEHandle^ := nil;
    QuadTree := nil;
    RIndex := Random(numPoints);
    XMin := xCoords^;
    XMax := XMin;
    YMin := yCoords^;
    YMax := YMin;
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
    QuadTree := TQuadTree.Create(XMin, XMax, YMin, YMax, FreeData);
    for Index := 0 to numPoints -1 do
    begin
      GetMem(DataPointer, SizeOf(ANE_DOUBLE));
      DataPointer^ := values^;
      QuadTree.AddPoint(xCoords^, yCoords^, DataPointer);
      Inc(values);
      Inc(xCoords);
      Inc(yCoords);
    end;
    GetMem(Data, SizeOf(TQuadTreeRecord));
    Data^.QuadTree := QuadTree;
  except on E: Exception do
    begin
      QuadTree.Free;
//      QuadTree := nil;
      FreeMem(Data);
    end;
  end;
  rPIEHandle := @Data^;
end;

procedure FreeQT_Nearest(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;
var
//  QuadTree : TQuadTree;
  Data : PQuadTreeRecord;
begin
  Data := pieHandle;
  Data^.QuadTree.Free;
  FreeMem(Data);

end;

procedure EvaluateQT_Nearest(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; rResult : ANE_DOUBLE_PTR) ; cdecl;
var
  QuadTree : TQuadTree;
  Data : PQuadTreeRecord;
begin
  Data := pieHandle;
  QuadTree := Data^.QuadTree;
  rResult^ := ANE_DOUBLE_PTR(QuadTree.NearestPointsData(X, Y))^;
end;
}




procedure InitializeQT_Nearest2(aneHandle : ANE_PTR;
                  var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;
const
  MaxRandom = 100;
//  Type TXY = (xx, yy);
var
  QuadTree : TQT_NearestData;
  XMin, XMax, YMin, YMax, Temp : double;
  Index, RIndex : integer;
//  DataPointer : ANE_DOUBLE_PTR;
  TempPointer : ANE_DOUBLE_PTR;
  Data : PQT_Record;
begin
  QuadTree := nil;
  Data := nil;
  try
//    rPIEHandle^ := nil;
//    Data^ := nil;
//    RIndex := Random(numPoints);
    // Although the Quadtree doesn't require that the bounds used in the
    // constructor be the true bounds of all the data, it helps if, the
    // bounds don't have to be expanded too often.

    // The data is often ordered so be sure to look at the first and last data
    // point.

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
    QuadTree := TQT_NearestData.Create(XMin, XMax, YMin, YMax, numPoints);
//    QuadTree.values := values;
//    QuadTree.numPoints := numPoints;
//    TempPointer := QuadTree.Values;

    // Add all the data points to the quadtree and store the data value
    // in an array.
    for Index := 0 to numPoints -1 do
    begin
//      try
      QuadTree.Values[Index] := Values^;
      QuadTree.QuadTree.AddPoint(xCoords^, yCoords^, Index);
      Inc(xCoords);
      Inc(yCoords);
      Inc(Values);
//      Inc(TempPointer);
{      Except
        begin
          ShowMessage(IntToStr(Index));
          raise;
        end
      end;  }
    end;

    // Get a record that can be passed to Argus ONE
    GetMem(Data, SizeOf(TQT_Record));

    // Put the quadtree in the record.
    Data^.Data := QuadTree;
  except on E: Exception do
    begin
      // If there is an error, release the allocated memory and
      // let the user know something went wrong.
      QuadTree.Free;
//      QuadTree := nil;
      FreeMem(Data);
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  rPIEHandle := @Data^;
end;

procedure FreeQT_Nearest2(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;
var
  QuadTree : TQT_NearestData;
  Data : PQT_Record;
begin
  try
    // Get the Quadtree record from Argus;
    Data := pieHandle;
    QuadTree := Data^.Data;
    // Release the memory.
    QuadTree.Free;
    FreeMem(Data);
  except on E: Exception do
    begin
      // If there is an error, let the user know something went wrong.
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure EvaluateQT_Nearest2(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; {var} rResult : ANE_DOUBLE_PTR) ; cdecl;
var
  QuadTree : TQT_NearestData;
  Index : integer;
//  TempValue : ANE_DOUBLE_PTR;
  Data : PQT_Record;
begin
  try
    // Get the Quadtree record from Argus;
    Data := pieHandle;
    QuadTree := Data^.Data;
    // find the Index of the data value of the data point closest to (X,Y)
    Index := QuadTree.QuadTree.NearestPointsData(X, Y);
  //  TempValue := QuadTree.QuadTree.NearestPointsData(X, Y);
    if Index < 0 then
    begin
      // raising an error here could lead to the user having to deal with a
      // large number of error messages.  We need a better solution.
      rResult^ := 0;
    end
    else
    begin
      // return the result to Argus ONE.
      rResult^ := QuadTree.Values[Index];
    end;
  except on E: Exception do
    begin
      // If there is an error, let the user know something went wrong.
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;






{ TQT_NearestData }

Constructor TQT_NearestData.Create(x_min, x_max, y_min, y_max : double;
  NumPoints : integer);
begin
  inherited Create;
  QuadTree := TQuadTree.Create(x_min, x_max, y_min, y_max{, nil});
//  GetMem(Values, NumPoints*SizeOf(ANE_DOUBLE));
  SetLength(Values, NumPoints);
end;

Destructor TQT_NearestData.Destroy; 
begin
  QuadTree.Free;
//  FreeMem(Values);
  inherited;
end;


Initialization;
  Randomize;

end.
