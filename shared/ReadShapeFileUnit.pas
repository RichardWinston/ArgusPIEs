{
  See http://www.esri.com/library/whitepapers/pdfs/shapefile.pdf for a
  description of the Shapefile format.
}
unit ReadShapeFileUnit;

interface

uses SysUtils, Classes;

type

  TShapeFileHeader = packed record
    // BigEndian value should be 9994
    FileCode: longint;
    Unused1: longint;
    // BigEndian
    Unused2: longint;
    // BigEndian
    Unused3: longint;
    // BigEndian
    Unused4: longint;
    // BigEndian
    Unused5: longint;
    // BigEndian, measured in 16 bit words
    FileLength: longint;
    // value should be 1000
    Version: longint;
    ShapeType: longint;
    BoundingBoxXMin: double;
    BoundingBoxYMin: double;
    BoundingBoxXMax: double;
    BoundingBoxYMax: double;
    // Unused, with value 0.0, if not Measured or Z type
    BoundingBoxZMin: double;
    // Unused, with value 0.0, if not Measured or Z type
    BoundingBoxZMax: double;
    // Unused, with value 0.0, if not Measured or Z type
    BoundingBoxMMin: double;
    // Unused, with value 0.0, if not Measured or Z type
    BoundingBoxMMax: double;
  end;

  TProgressProcedure = procedure(Sender: TObject; FractionDone: double) of
    object;

const
  // Shape types
  stNull = 0;
  stPoint = 1;
  stPolyLine = 3;
  stPolygon = 5;
  stMultipoint = 8;
  stPointZ = 11;
  stPolyLineZ = 13;
  stPolygonZ = 15;
  stMultipointZ = 18;
  stPointM = 21;
  stPolyLineM = 23;
  stPolygonM = 25;
  stMultipointM = 28;
  stMultiPatch = 31;

type
  TShapeRecordHeader = packed record
    // BigEndian
    RecordNumber: longint;
    // BigEndian, measured in 16 bit words
    ContentLength: longint;
  end;

  TNullShapeRecord = packed record
    // The value of ShapeType should be 0
    ShapeType: longint;
  end;

  TPointShapeRecord = packed record
    // The value of ShapeType should be 1
    ShapeType: longint;
    X: double;
    Y: double;
  end;

  TShapePoint = packed record
    X: double;
    Y: double;
  end;

  TMultiPointShapeRecord = packed record
    // The value of ShapeType should be 8
    ShapeType: longint;
    // Xmin, Ymin, Xmax, Ymax.
    BoundingBox: array[0..3] of double;
    NumPoints: longint;
    //    Points: array of TShapePoint;
  end;

  TPolyLineShapeRecord = packed record
    // The value of ShapeType should be 3
    ShapeType: longint;
    // Xmin, Ymin, Xmax, Ymax.
    BoundingBox: array[0..3] of double;
    NumParts: longint;
    NumPoints: longint;
    //    Parts: array of integer;
    //    Points: array of TShapePoint;
  end;

  TPolygonShapeRecord = packed record
    // The value of ShapeType should be 5
    ShapeType: longint;
    // Xmin, Ymin, Xmax, Ymax.
    BoundingBox: array[0..3] of double;
    NumParts: longint;
    NumPoints: longint;
    //    Parts: array of integer;
    //    Points: array of TShapePoint;
  end;

  TPointMShapeRecord = packed record
    // The value of ShapeType should be 21
    ShapeType: longint;
    X: double;
    Y: double;
    M: double;
  end;

  TShapePointM = packed record
    X: double;
    Y: double;
    M: double;
  end;

  TMultiPointMShapeRecord = packed record
    // The value of ShapeType should be 28
    ShapeType: longint;
    // Xmin, Ymin, Xmax, Ymax.
    BoundingBox: array[0..3] of double;
    NumPoints: longint;
    //    Points: array of TShapePoint;
    //    MMin: double; // optional
    //    MMax: double; // optional
    //    MArray: array of double; // optional
  end;

  TPolyLineMShapeRecord = packed record
    // The value of ShapeType should be 23
    ShapeType: longint;
    // Xmin, Ymin, Xmax, Ymax.
    BoundingBox: array[0..3] of double;
    NumParts: longint;
    NumPoints: longint;
    //    Parts: array of integer;
    //    Points: array of TShapePoint;
    //    MMin: double; // optional
    //    MMax: double; // optional
    //    MArray: array of double; // optional
  end;

  TPolygonMShapeRecord = packed record
    // The value of ShapeType should be 25
    ShapeType: longint;
    // Xmin, Ymin, Xmax, Ymax.
    BoundingBox: array[0..3] of double;
    NumParts: longint;
    NumPoints: longint;
    //    Parts: array of integer;
    //    Points: array of TShapePoint;
    //    MMin: double; // optional
    //    MMax: double; // optional
    //    MArray: array of double; // optional
  end;

  TPointZShapeRecord = packed record
    // The value of ShapeType should be 11
    ShapeType: longint;
    X: double;
    Y: double;
    Z: double;
    M: double;
  end;

  TMultiPointZShapeRecord = packed record
    // The value of ShapeType should be 18
    ShapeType: longint;
    // Xmin, Ymin, Xmax, Ymax.
    BoundingBox: array[0..3] of double;
    NumPoints: longint;
    {    Points: array of TShapePoint;
        ZMin: double;
        ZMax: double;
        ZArray: array of double;
        MMin: double; // optional
        MMax: double; // optional
        MArray: array of double; // optional }
  end;

  TPolyLineZShapeRecord = packed record
    // The value of ShapeType should be 13
    ShapeType: longint;
    // Xmin, Ymin, Xmax, Ymax.
    BoundingBox: array[0..3] of double;
    NumParts: longint;
    NumPoints: longint;
    {    Parts: array of integer;
        Points: array of TShapePoint;
        ZMin: double;
        ZMax: double;
        ZArray: array of double;
        MMin: double; // optional
        MMax: double; // optional
        MArray: array of double; // optional  }
  end;

  TPolygonZShapeRecord = packed record
    // The value of ShapeType should be 15
    ShapeType: longint;
    // Xmin, Ymin, Xmax, Ymax.
    BoundingBox: array[0..3] of double;
    NumParts: longint;
    NumPoints: longint;
    {    Parts: array of integer;
        Points: array of TShapePoint;
        ZMin: double;
        ZMax: double;
        ZArray: array of double;
        MMin: double; // optional
        MMax: double; // optional
        MArray: array of double; // optional   }
  end;

const
  ptTriangleStrip = 0;
  ptTriangleFan = 1;
  ptOuterRing = 2;
  ptInnerRing = 3;
  ptFirstRing = 4;
  ptRing = 5;

type
  TMultiPatchShapeRecord = packed record
    // The value of ShapeType should be 31
    ShapeType: longint;
    // Xmin, Ymin, Xmax, Ymax.
    BoundingBox: array[0..3] of double;
    NumParts: longint;
    NumPoints: longint;
//    Parts: array of integer;
//    PartTypes: array of integer;
//    Points: array of TShapePoint;
//    ZMin: double;
//    ZMax: double;
//    ZArray: array of double;
    // MMin is optional
//    MMin: double; // optional
    // MMax is optional
//    MMax: double; // optional
    // MArray is optional
//    MArray: array of double; // optional
  end;

  TShapeIndexRecord = packed record
    // BigEndian, measured in 16 bit words
    Offset: longint;
    // BigEndian, measured in 16 bit words
    ContentLength: longint;
  end;

  TShapeObject = class(TObject)
  public
    NumPoints: integer;
    NumParts: integer;
    ShapeType: longint;
    // Xmin, Ymin, Xmax, Ymax.
    BoundingBox: array[0..3] of double;
    Points: array of TShapePoint;
    {
      Parts: An array of length NumParts. Stores, for each PolyLine,
        the index of its first point in the points array.
        Array indexes are with respect to 0.    }
    Parts: array of integer;
    // MMin is optional
    MMin: double;
    // MMax is optional
    MMax: double;
    // MArray is optional
    MArray: array of double;
    ZMin: double;
    ZMax: double;
    ZArray: array of double;
    PartTypes: array of integer;
    constructor Create;
  end;

type
  TShapeGeometryFile = class(TObject)
  private
    // ShapeObjects is instantiated as a TObjectList.
    ShapeObjects: TList;
    FFileHeader: TShapeFileHeader;
    FProgress: TProgressProcedure;
    function GetItems(const Index: integer): TShapeObject;
    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy; override;
    // ReadFromFile reads the geometry from a file named FileName.
    // See also @link(OnProgress).

    procedure ReadFromFile(const MainFileName, IndexFileName: string);
    // Count is the number of TShapeObjects that have been read.
    property Count: integer read GetCount;
    property Items[const Index: integer]: TShapeObject read GetItems; default;
    { FileHeader is the TShapeFileHeader at the beginning of the file.
     The most useful thing about FileHeader is ShapeType which should be
     one of:
        stNull = 0;
        stPoint = 1;
        stPolyLine = 3;
        stPolygon = 5;
        stMultipoint = 8;
        stPointZ = 11;
        stPolyLineZ = 13;
        stPolygonZ = 15;
        stMultipointZ = 18;
        stPointM = 21;
        stPolyLineM = 23;
        stPolygonM = 25;
        stMultipointM = 28;
        stMultiPatch = 31;
      }
    property FileHeader: TShapeFileHeader read FFileHeader;
    {
      @name is called each time a shape is read from the disk during
      ReadFromFile.
      FractionDone will be the fraction of the file that has been read.
    }
    property OnProgress: TProgressProcedure read FProgress write FProgress;
  end;

type
  //enumeration used in variant record
  BytePos = (EndVal, ByteVal);

  PDoubleEndianCnvRec = ^DoubleEndianCnvRec;
  DoubleEndianCnvRec = packed record
    case pos: BytePos of
      //The value we are trying to convert
      EndVal: (EndianVal: double);
      //Overlapping bytes of the double
      ByteVal: (Bytes: array[0..SizeOf(double) - 1] of byte);
  end;

  PLongintEndianCnvRec = ^LongintEndianCnvRec;
  LongintEndianCnvRec = packed record
    case pos: BytePos of
      //The value we are trying to convert
      EndVal: (EndianVal: longint);
      //Overlapping bytes of the longint
      ByteVal: (Bytes: array[0..SizeOf(longint) - 1] of byte);
  end;

procedure SwapDoubleBytes(Dest, Source: PDoubleEndianCnvRec);
procedure SwapLongIntBytes(Dest, Source: PLongintEndianCnvRec);

function ConvertDouble(const Value: double): double;
function ConvertInteger(const Value: longint): longint;

function FileShapeType(const FileName: string): integer;

implementation

uses Contnrs;

// http://community.borland.com/article/0,1410,28964,00.html
//A gets B's values swapped

// Dest and Source should not be the same.
procedure SwapDoubleBytes(Dest, Source: PDoubleEndianCnvRec);
var
  i: integer;
begin
  for i := high(Dest.Bytes) downto low(Dest.Bytes) do
    Dest.Bytes[i] := Source.Bytes[High(Dest.Bytes) - i];
end;

// Dest and Source should not be the same.
procedure SwapLongIntBytes(Dest, Source: PLongintEndianCnvRec);
var
  i: integer;
begin
  for i := high(Dest.Bytes) downto low(Dest.Bytes) do
    Dest.Bytes[i] := Source.Bytes[High(Dest.Bytes) - i];
end;

// This converts a double to or from the BigEndian format.
function ConvertDouble(const Value: double): double;
var
  Source, Dest: DoubleEndianCnvRec;
begin
  Source.EndianVal := Value;
  SwapDoubleBytes(@Dest, @Source);
  result := Dest.EndianVal;
end;

// This converts a longint to or from the BigEndian format.
function ConvertInteger(const Value: longint): longint;
var
  Source, Dest: LongintEndianCnvRec;
begin
  Source.EndianVal := Value;
  SwapLongIntBytes(@Dest, @Source);
  result := Dest.EndianVal;
end;

{ TShapeGeometryFile }

constructor TShapeGeometryFile.Create;
begin
  inherited;
  ShapeObjects := TObjectList.Create;
end;

destructor TShapeGeometryFile.Destroy;
begin
  ShapeObjects.Free;
  inherited;
end;

function TShapeGeometryFile.GetCount: integer;
begin
  result := ShapeObjects.Count;
end;

function TShapeGeometryFile.GetItems(const Index: integer): TShapeObject;
begin
  result := ShapeObjects[Index];
end;

procedure TShapeGeometryFile.ReadFromFile(const MainFileName, IndexFileName: string);
var
  // FileStream is used to read the Shapefile.
  FileStream: TFileStream;
  IndexFileStream: TFileStream;
  // ShapeType tells what kinds of shape is in the Shapefile.
  ShapeType: integer;
  // Shapefile start with a TShapeRecordHeader.
  ShapeRecordHeader: TShapeRecordHeader;
  IndexRecordHeader: TShapeIndexRecord;
  // ContentLength is the length of the content of the shape geometry
  // file in bytes.
  ContentLength, Offset: integer;
  // CurrentPosition is the position in FileStream.
  CurrentPosition: integer;
  // ContentEnd indicates where the shapes in the Shapefile end.
  ContentEnd: integer;
  // NumPoints is the number of points in the current shape.
  NumPoints: integer;
  // NumParts is the number of parts in the current shape.
  NumParts: integer;
  DummyFileHeader: TShapeFileHeader;
  procedure ReadNullShape;
  var
    NullShapeObject: TShapeObject;
    Data: TNullShapeRecord;
  begin
    NullShapeObject := TShapeObject.Create;
    ShapeObjects.Add(NullShapeObject);
    FileStream.Read(Data, SizeOf(TNullShapeRecord));
    NullShapeObject.ShapeType := Data.ShapeType;
    SetLength(NullShapeObject.Points, 0);
    NullShapeObject.NumPoints := 0;
    NullShapeObject.NumParts := 0;
  end;
  procedure ReadPointShape;
  var
    PointShapeObject: TShapeObject;
    Data: TPointShapeRecord;
  begin
    PointShapeObject := TShapeObject.Create;
    ShapeObjects.Add(PointShapeObject);
    FileStream.Read(Data, SizeOf(TPointShapeRecord));
    PointShapeObject.ShapeType := Data.ShapeType;
    SetLength(PointShapeObject.Points, 1);
    PointShapeObject.Points[0].X := Data.X;
    PointShapeObject.Points[0].Y := Data.Y;
    PointShapeObject.NumPoints := 1;
    PointShapeObject.NumParts := 1;
  end;
  procedure ReadPolyLine;
  var
    PolyLineShapeObject: TShapeObject;
    Data: TPolyLineShapeRecord;
  begin
    PolyLineShapeObject := TShapeObject.Create;
    ShapeObjects.Add(PolyLineShapeObject);
    FileStream.Read(Data, SizeOf(TPolyLineShapeRecord));
    Move(Data.BoundingBox[0], PolyLineShapeObject.BoundingBox[0],
      4 * sizeOf(Double));
    PolyLineShapeObject.ShapeType := Data.ShapeType;
    NumPoints := Data.NumPoints;
    NumParts := Data.NumParts;
    PolyLineShapeObject.NumPoints := NumPoints;
    PolyLineShapeObject.NumParts := NumParts;
    SetLength(PolyLineShapeObject.Parts, NumParts);
    SetLength(PolyLineShapeObject.Points, NumPoints);
    if NumParts > 0 then
    begin
      FileStream.Read(PolyLineShapeObject.Parts[0],
        NumParts * SizeOf(Integer));
    end;
    if NumPoints > 0 then
    begin
      FileStream.Read(PolyLineShapeObject.Points[0],
        NumPoints * SizeOf(TShapePoint));
    end;
  end;
  procedure ReadPolygon;
  var
    PolygonShapeObject: TShapeObject;
    Data: TPolygonShapeRecord;
  begin
    PolygonShapeObject := TShapeObject.Create;
    ShapeObjects.Add(PolygonShapeObject);
    FileStream.Read(Data, SizeOf(TPolygonShapeRecord));
    Move(Data.BoundingBox[0], PolygonShapeObject.BoundingBox[0],
      4 * sizeOf(Double));
    NumPoints := Data.NumPoints;
    NumParts := Data.NumParts;
    PolygonShapeObject.ShapeType := Data.ShapeType;
    PolygonShapeObject.NumPoints := Data.NumPoints;
    PolygonShapeObject.NumParts := Data.NumParts;
    SetLength(PolygonShapeObject.Parts, NumParts);
    SetLength(PolygonShapeObject.Points, NumPoints);
    if NumParts > 0 then
    begin
      FileStream.Read(PolygonShapeObject.Parts[0],
        NumParts * SizeOf(longint));
    end;
    if NumPoints > 0 then
    begin
      FileStream.Read(PolygonShapeObject.Points[0],
        NumPoints * SizeOf(TShapePoint));
    end;
  end;
  procedure ReadMultiPoint;
  var
    MultiPointShapeObject: TShapeObject;
    Data: TMultiPointShapeRecord;
    Index: Integer;
  begin
    MultiPointShapeObject := TShapeObject.Create;
    ShapeObjects.Add(MultiPointShapeObject);
    FileStream.Read(Data, SizeOf(TMultiPointShapeRecord));
    Move(Data.BoundingBox[0], MultiPointShapeObject.BoundingBox[0],
      4 * sizeOf(Double));
    NumPoints := Data.NumPoints;
    MultiPointShapeObject.NumPoints := NumPoints;
    MultiPointShapeObject.NumParts := NumPoints;
    SetLength(MultiPointShapeObject.Parts, NumPoints);
    for Index := 0 to NumPoints - 1 do
    begin
      MultiPointShapeObject.Parts[Index] := Index;
    end;
    MultiPointShapeObject.ShapeType := Data.ShapeType;
    SetLength(MultiPointShapeObject.Points, NumPoints);
    if NumPoints > 0 then
    begin
      FileStream.Read(MultiPointShapeObject.Points[0],
        NumPoints * SizeOf(TShapePoint));
    end;
  end;
  procedure ReadPointZ;
  var
    PointZShapeObject: TShapeObject;
    Data: TPointZShapeRecord;
  begin
    PointZShapeObject := TShapeObject.Create;
    ShapeObjects.Add(PointZShapeObject);
    FileStream.Read(Data, SizeOf(TPointZShapeRecord));
    PointZShapeObject.ShapeType := Data.ShapeType;
    SetLength(PointZShapeObject.Points, 1);
    PointZShapeObject.Points[0].X := Data.X;
    PointZShapeObject.Points[0].Y := Data.Y;
    SetLength(PointZShapeObject.MArray, 1);
    PointZShapeObject.MArray[0] := Data.M;
    PointZShapeObject.MMin := Data.M;
    PointZShapeObject.MMax := Data.M;
    SetLength(PointZShapeObject.ZArray, 1);
    PointZShapeObject.ZArray[0] := Data.Z;
    PointZShapeObject.ZMin := Data.Z;
    PointZShapeObject.ZMax := Data.Z;
    PointZShapeObject.NumPoints := 1;
    PointZShapeObject.NumParts := 1;
  end;
  procedure ReadPolyLineZ;
  var
    PolyLineZShapeObject: TShapeObject;
    Data: TPolyLineZShapeRecord;
  begin
    PolyLineZShapeObject := TShapeObject.Create;
    ShapeObjects.Add(PolyLineZShapeObject);
    FileStream.Read(Data, SizeOf(TPolyLineZShapeRecord));
    NumParts := Data.NumParts;
    NumPoints := Data.NumPoints;
    PolyLineZShapeObject.NumPoints := NumPoints;
    PolyLineZShapeObject.NumParts := NumParts;
    PolyLineZShapeObject.ShapeType := Data.ShapeType;
    Move(Data.BoundingBox[0], PolyLineZShapeObject.BoundingBox[0],
      4 * sizeOf(Double));

    SetLength(PolyLineZShapeObject.Parts, NumParts);
    if NumParts > 0 then
    begin
      FileStream.Read(PolyLineZShapeObject.Parts[0],
        NumParts * SizeOf(longint));
    end;
    SetLength(PolyLineZShapeObject.Points, NumPoints);
    if NumPoints > 0 then
    begin
      FileStream.Read(PolyLineZShapeObject.Points[0],
        NumPoints * SizeOf(TShapePoint));
    end;
    FileStream.Read(PolyLineZShapeObject.ZMin, SizeOf(double));
    FileStream.Read(PolyLineZShapeObject.ZMax, SizeOf(double));
    SetLength(PolyLineZShapeObject.ZArray, NumPoints);
    if NumPoints > 0 then
    begin
      FileStream.Read(PolyLineZShapeObject.ZArray[0],
        NumPoints * SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(PolyLineZShapeObject.MMin, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(PolyLineZShapeObject.MMax, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      SetLength(PolyLineZShapeObject.MArray, NumPoints);
      if NumPoints > 0 then
      begin
        FileStream.Read(PolyLineZShapeObject.MArray[0],
          NumPoints * SizeOf(double));
      end;
    end;
  end;
  procedure ReadPolygonZ;
  var
    PolygonZShapeObject: TShapeObject;
    Data: TPolygonZShapeRecord;
  begin
    PolygonZShapeObject := TShapeObject.Create;
    ShapeObjects.Add(PolygonZShapeObject);
    FileStream.Read(Data, SizeOf(TPolygonZShapeRecord));
    NumParts := Data.NumParts;
    NumPoints := Data.NumPoints;
    PolygonZShapeObject.ShapeType := Data.ShapeType;
    PolygonZShapeObject.NumParts := NumParts;
    PolygonZShapeObject.NumPoints := NumPoints;
    Move(Data.BoundingBox[0], PolygonZShapeObject.BoundingBox[0],
      4 * sizeOf(Double));
    SetLength(PolygonZShapeObject.Parts, NumParts);
    if NumParts > 0 then
    begin
      FileStream.Read(PolygonZShapeObject.Parts[0],
        NumParts * SizeOf(longint));
    end;
    SetLength(PolygonZShapeObject.Points, NumPoints);
    if NumPoints > 0 then
    begin
      FileStream.Read(PolygonZShapeObject.Points[0],
        NumPoints * SizeOf(TShapePoint));
    end;
    FileStream.Read(PolygonZShapeObject.ZMin, SizeOf(double));
    FileStream.Read(PolygonZShapeObject.ZMax, SizeOf(double));
    SetLength(PolygonZShapeObject.ZArray, NumPoints);
    if NumPoints > 0 then
    begin
      FileStream.Read(PolygonZShapeObject.ZArray[0],
        NumPoints * SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(PolygonZShapeObject.MMin, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(PolygonZShapeObject.MMax, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      SetLength(PolygonZShapeObject.MArray, NumPoints);
      if NumPoints > 0 then
      begin
        FileStream.Read(PolygonZShapeObject.MArray[0],
          NumPoints * SizeOf(double));
      end;
    end;
  end;
  procedure ReadMultipPointZ;
  var
    MultiPointZShapeObject: TShapeObject;
    Data: TMultiPointZShapeRecord;
    Index: Integer;
  begin
    MultiPointZShapeObject := TShapeObject.Create;
    ShapeObjects.Add(MultiPointZShapeObject);
    FileStream.Read(Data, SizeOf(TMultiPointZShapeRecord));
    NumPoints := Data.NumPoints;
    NumParts := 0;
    MultiPointZShapeObject.NumPoints := NumPoints;
    MultiPointZShapeObject.NumParts := NumPoints;
    SetLength(MultiPointZShapeObject.Parts, NumPoints);
    for Index := 0 to NumPoints - 1 do
    begin
      MultiPointZShapeObject.Parts[Index] := Index;
    end;
    MultiPointZShapeObject.ShapeType := Data.ShapeType;
    Move(Data.BoundingBox[0], MultiPointZShapeObject.BoundingBox[0],
      4 * sizeOf(Double));
    SetLength(MultiPointZShapeObject.Points, NumPoints);
    if NumPoints > 0 then
    begin
      FileStream.Read(MultiPointZShapeObject.Points[0],
        NumPoints * SizeOf(TShapePoint));
    end;
    FileStream.Read(MultiPointZShapeObject.ZMin, SizeOf(double));
    FileStream.Read(MultiPointZShapeObject.ZMax, SizeOf(double));
    SetLength(MultiPointZShapeObject.ZArray, NumPoints);
    if NumPoints > 0 then
    begin
      FileStream.Read(MultiPointZShapeObject.ZArray[0],
        NumPoints * SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(MultiPointZShapeObject.MMin, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(MultiPointZShapeObject.MMax, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      SetLength(MultiPointZShapeObject.MArray, NumPoints);
      if NumPoints > 0 then
      begin
        FileStream.Read(MultiPointZShapeObject.MArray[0],
          NumPoints * SizeOf(double));
      end;
    end;
  end;
  procedure ReadPointM;
  var
    PointMShapeObject: TShapeObject;
    Data: TPointMShapeRecord;
  begin
    PointMShapeObject := TShapeObject.Create;
    ShapeObjects.Add(PointMShapeObject);
    FileStream.Read(Data, SizeOf(TPointMShapeRecord));
    PointMShapeObject.NumPoints := 1;
    SetLength(PointMShapeObject.Points, 1);
    PointMShapeObject.Points[0].X := Data.X;
    PointMShapeObject.Points[0].Y := Data.Y;
    PointMShapeObject.ShapeType := ShapeType;
    SetLength(PointMShapeObject.MArray, 1);
    PointMShapeObject.MArray[0] := Data.M;
    PointMShapeObject.MMin := Data.M;
    PointMShapeObject.MMax := Data.M;
    SetLength(PointMShapeObject.Parts, 0);
    PointMShapeObject.NumPoints := 1;
    PointMShapeObject.NumParts := 0;
    SetLength(PointMShapeObject.ZArray, 0);
  end;
  procedure ReadPolyLineM;
  var
    PolyLineMShapeObject: TShapeObject;
    Data: TPolyLineMShapeRecord;
  begin
    PolyLineMShapeObject := TShapeObject.Create;
    ShapeObjects.Add(PolyLineMShapeObject);
    FileStream.Read(Data, SizeOf(TPolyLineMShapeRecord));
    NumParts := Data.NumParts;
    NumPoints := Data.NumPoints;
    PolyLineMShapeObject.NumPoints := NumPoints;
    PolyLineMShapeObject.NumParts := NumParts;
    PolyLineMShapeObject.ShapeType := Data.ShapeType;
    Move(Data.BoundingBox[0], PolyLineMShapeObject.BoundingBox[0],
      4 * sizeOf(Double));
    SetLength(PolyLineMShapeObject.Parts, NumParts);
    if NumParts > 0 then
    begin
      FileStream.Read(PolyLineMShapeObject.Parts[0],
        NumParts * SizeOf(longint));
    end;
    SetLength(PolyLineMShapeObject.Points, NumPoints);
    if NumPoints > 0 then
    begin
      FileStream.Read(PolyLineMShapeObject.Points[0],
        NumPoints * SizeOf(TShapePoint));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(PolyLineMShapeObject.MMin, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(PolyLineMShapeObject.MMax, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      SetLength(PolyLineMShapeObject.MArray, NumPoints);
      if NumPoints > 0 then
      begin
        FileStream.Read(PolyLineMShapeObject.MArray[0],
          NumPoints * SizeOf(double));
      end;
    end;
    SetLength(PolyLineMShapeObject.ZArray, 0);
  end;
  procedure ReadPolygonM;
  var
    PolygonMShapeObject: TShapeObject;
    Data: TPolygonMShapeRecord;
  begin
    PolygonMShapeObject := TShapeObject.Create;
    ShapeObjects.Add(PolygonMShapeObject);
    FileStream.Read(Data, SizeOf(TPolygonMShapeRecord));
    NumParts := Data.NumParts;
    NumPoints := Data.NumPoints;
    PolygonMShapeObject.NumPoints := NumPoints;
    PolygonMShapeObject.NumParts := NumParts;
    PolygonMShapeObject.ShapeType := Data.ShapeType;
    Move(Data.BoundingBox[0], PolygonMShapeObject.BoundingBox[0],
      4 * sizeOf(Double));
    SetLength(PolygonMShapeObject.Parts, NumParts);
    if NumParts > 0 then
    begin
      FileStream.Read(PolygonMShapeObject.Parts[0],
        NumParts * SizeOf(longint));
    end;
    SetLength(PolygonMShapeObject.Points, NumPoints);
    if NumPoints > 0 then
    begin
      FileStream.Read(PolygonMShapeObject.Points[0],
        NumPoints * SizeOf(TShapePoint));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(PolygonMShapeObject.MMin, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(PolygonMShapeObject.MMax, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      SetLength(PolygonMShapeObject.MArray, NumPoints);
      if NumPoints > 0 then
      begin
        FileStream.Read(PolygonMShapeObject.MArray[0],
          NumPoints * SizeOf(double));
      end;
    end;
    SetLength(PolygonMShapeObject.ZArray, 0);
  end;
  procedure ReadMultiPointM;
  var
    MultiPointMShapeObject: TShapeObject;
    Data: TMultiPointMShapeRecord;
    Index: Integer;
  begin
    MultiPointMShapeObject := TShapeObject.Create;
    ShapeObjects.Add(MultiPointMShapeObject);
    FileStream.Read(Data, SizeOf(TMultiPointMShapeRecord));
    NumPoints := Data.NumPoints;
    NumParts := 0;
    MultiPointMShapeObject.NumPoints := NumPoints;
    MultiPointMShapeObject.NumParts := NumPoints;
    SetLength(MultiPointMShapeObject.Parts, NumPoints);
    for Index := 0 to NumPoints - 1 do
    begin
      MultiPointMShapeObject.Parts[Index] := Index;
    end;
    MultiPointMShapeObject.ShapeType := Data.ShapeType;
    Move(Data.BoundingBox[0], MultiPointMShapeObject.BoundingBox[0],
      4 * sizeOf(Double));
    SetLength(MultiPointMShapeObject.Points, NumPoints);
    if NumPoints > 0 then
    begin
      FileStream.Read(MultiPointMShapeObject.Points[0],
        NumPoints * SizeOf(TShapePoint));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(MultiPointMShapeObject.MMin, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(MultiPointMShapeObject.MMax, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      SetLength(MultiPointMShapeObject.MArray, NumPoints);
      if NumPoints > 0 then
      begin
        FileStream.Read(MultiPointMShapeObject.MArray[0],
          NumPoints * SizeOf(double));
      end;
    end;
    SetLength(MultiPointMShapeObject.ZArray, 0);
    SetLength(MultiPointMShapeObject.Parts, 0);
  end;
  procedure ReadMultiPatch;
  var
    MultiPatchShapeObject: TShapeObject;
    Data: TMultiPatchShapeRecord;
  begin
    MultiPatchShapeObject := TShapeObject.Create;
    ShapeObjects.Add(MultiPatchShapeObject);
    FileStream.Read(Data, SizeOf(TMultiPatchShapeRecord));
    NumParts := Data.NumParts;
    NumPoints := Data.NumPoints;
    MultiPatchShapeObject.NumPoints := NumPoints;
    MultiPatchShapeObject.NumParts := NumParts;
    MultiPatchShapeObject.ShapeType := Data.ShapeType;
    Move(Data.BoundingBox[0], MultiPatchShapeObject.BoundingBox[0],
      4 * sizeOf(Double));
    SetLength(MultiPatchShapeObject.Parts, NumParts);
    SetLength(MultiPatchShapeObject.PartTypes, NumParts);
    if NumParts > 0 then
    begin
      FileStream.Read(MultiPatchShapeObject.Parts[0],
        NumParts * SizeOf(longint));
      FileStream.Read(MultiPatchShapeObject.PartTypes[0],
        NumParts * SizeOf(longint));
    end;
    SetLength(MultiPatchShapeObject.Points, NumPoints);
    if NumPoints > 0 then
    begin
      FileStream.Read(MultiPatchShapeObject.Points[0],
        NumPoints * SizeOf(TShapePoint));
    end;
    FileStream.Read(MultiPatchShapeObject.ZMin, SizeOf(double));
    FileStream.Read(MultiPatchShapeObject.ZMax, SizeOf(double));
    SetLength(MultiPatchShapeObject.ZArray, NumPoints);
    if NumPoints > 0 then
    begin
      FileStream.Read(MultiPatchShapeObject.ZArray[0],
        NumPoints * SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(MultiPatchShapeObject.MMin, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      FileStream.Read(MultiPatchShapeObject.MMax, SizeOf(double));
    end;
    if FileStream.Position < ContentEnd then
    begin
      SetLength(MultiPatchShapeObject.MArray, NumPoints);
      if NumPoints > 0 then
      begin
        FileStream.Read(MultiPatchShapeObject.MArray[0],
          NumPoints * SizeOf(double));
      end;
    end;
  end;
begin
  FileStream := TFileStream.Create(MainFileName, fmOpenRead or fmShareDenyWrite);
  IndexFileStream := TFileStream.Create(IndexFileName, fmOpenRead or fmShareDenyWrite);
  try
    FileStream.Read(FFileHeader, SizeOf(TShapeFileHeader));
    IndexFileStream.Read(DummyFileHeader, SizeOf(TShapeFileHeader));

    ShapeType := FFileHeader.ShapeType;
    while IndexFileStream.Position < IndexFileStream.Size do
    begin
      IndexFileStream.Read(IndexRecordHeader, SizeOf(TShapeIndexRecord));

      Offset := ConvertInteger(IndexRecordHeader.Offset) *2;
      FileStream.Position := Offset;

      FileStream.Read(ShapeRecordHeader, SizeOf(TShapeRecordHeader));
      CurrentPosition := FileStream.Position;
      if Assigned(OnProgress) then
      begin
        OnProgress(self, CurrentPosition / FileStream.Size);
      end;

      // ShapeRecordHeader.ContentLength is measured in 16 bit words = 2 bytes.
      ContentLength := ConvertInteger(ShapeRecordHeader.ContentLength) * 2;
      ContentEnd := CurrentPosition + ContentLength;
      Assert(ContentEnd <= FileStream.Size);
      if FileStream.Position < FileStream.Size then
      begin
        case ShapeType of
          stNull:
            begin
              ReadNullShape;
            end;
          stPoint:
            begin
              ReadPointShape;
            end;
          stPolyLine:
            begin
              ReadPolyLine;
            end;
          stPolygon:
            begin
              ReadPolygon;
            end;
          stMultipoint:
            begin
              ReadMultiPoint;
            end;
          stPointZ:
            begin
              ReadPointZ;
            end;
          stPolyLineZ:
            begin
              ReadPolyLineZ;
            end;
          stPolygonZ:
            begin
              ReadPolygonZ;
            end;
          stMultipointZ:
            begin
              ReadMultipPointZ;
            end;
          stPointM:
            begin
              ReadPointM;
            end;
          stPolyLineM:
            begin
              ReadPolyLineM;
            end;
          stPolygonM:
            begin
              ReadPolygonM;
            end;
          stMultipointM:
            begin
              ReadMultiPointM;
            end;
          stMultiPatch:
            begin
              ReadMultiPatch;
            end;
        else
          Assert(False);
        end;
      end;
    end;
  finally
    FileStream.Free;
    IndexFileStream.Free;
  end;
end;

{ TShapeObject }

constructor TShapeObject.Create;
begin
  inherited;
  SetLength(Points, 0);
  SetLength(Parts, 0);
  SetLength(MArray, 0);
  SetLength(ZArray, 0);
  SetLength(PartTypes, 0);
  NumPoints := 0;
  NumParts := 0;
end;

function FileShapeType(const FileName: string): integer;
var
  // FileStream is used to read the Shapefile.
  FileStream: TFileStream;
  FileHeader: TShapeFileHeader;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    FileStream.Read(FileHeader, SizeOf(TShapeFileHeader));
    result := FileHeader.ShapeType;
  finally
    FileStream.Free;
  end;
end;

end.

