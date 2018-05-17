unit CellVertexUnit;

interface

uses classes, SysUtils;

type
  TBL_Vertex = class(TObject)
    XPos: double;
    YPos: double;
    Distance: Double;
    TempRowVertex: Boolean;
    TempColumnVertex: Boolean;
    Segment: double;
    // Segment is a number indicating the line segment on
    // which a vertex lies. Verticies specified by the user start at 0.5 and
    // go to n-1 + 0.5 where n is the number of verticies specified by the
    // user. Each such vertex is 1 larger than the previous vertex.
    // Verticies created by interpolation between the verticies specified
    // by the user go from 1 to n-1 and are halfway between the values assigned
    // to verticies specified by the user.
    LastVertex: Boolean;
    // set LastVertex to true if this is the last vertex in a line
    constructor Create;
    function CopyOfVertex: TBL_Vertex;

  end;

  TCell = class(TObject)
    Row: integer;
    Column: integer;
    VertexList: TList;
    SegmentList: TList;
    RowBeginCell: TCell;
    RowEndCell: TCell;
    ColumnBeginCell: TCell;
    ColumnEndCell: TCell;
    DistanceBefore: double;
    constructor Create;
    destructor Destroy; override;
    function RowCenter: double;
    function ColumnCenter: double;
    function SegmentFirstVertexXPos(SegmentIndex: integer): double;
    function SegmentFirstVertexYPos(SegmentIndex: integer): double;
    function SegmentSecondVertexXPos(SegmentIndex: integer): double;
    function SegmentSecondVertexYPos(SegmentIndex: integer): double;
    function SegmentXLength(SegmentIndex: integer): double;
    function SegmentYLength(SegmentIndex: integer): double;
    function SegmentLength(SegmentIndex: integer): double;
    function SumSegmentXLength: double;
    function SumSegmentYLength: double;
    function SumSegmentLength: double;
    function SegmentCrossesRowMidline(SegmentIndex: integer): boolean;
    function SegmentCrossesColumnMidline(SegmentIndex: integer): boolean;
    function CountSegmentCrossesRowMidline: integer;
    function CountSegmentCrossesColumnMidline: integer;
    function LineCrossesRowMidline: boolean;
    function LineCrossesColumnMidline: boolean;
    function MaxX: double;
    function MinX: double;
    function MaxY: double;
    function MinY: double;
    function CompositeY: double;
    function CompositeX: double;
    procedure SegmentMidpoint(const SegmentIndex: integer; Out X, Y: double);
//    procedure GetRotatedLineCenter(out X, Y: double);
  end;

  ENoSegments = class(Exception);

implementation

uses BlockListUnit;

constructor TBL_Vertex.Create;
begin
  inherited;
  LastVertex := False;
end;

function TBL_Vertex.CopyOfVertex: TBL_Vertex;
var
  DuplicateVertex: TBL_Vertex;
begin
  DuplicateVertex := TBL_Vertex.Create;
  DuplicateVertex.XPos := XPos;
  DuplicateVertex.YPos := YPos;
  DuplicateVertex.TempRowVertex := TempRowVertex;
  DuplicateVertex.TempColumnVertex := TempColumnVertex;
  DuplicateVertex.Distance := Distance;
  DuplicateVertex.Segment := Segment;
  result := DuplicateVertex
end;

constructor TCell.Create;
begin
  inherited;
  VertexList := TList.Create;
  SegmentList := TList.Create;
  RowBeginCell := self;
  RowEndCell := self;
  ColumnBeginCell := self;
  ColumnEndCell := self;
end;

destructor TCell.Destroy;
var
  VertexIndex: integer;
  AVertex: TBL_Vertex;
begin
  for VertexIndex := VertexList.Count - 1 downto 0 do
  begin
    AVertex := VertexList.Items[VertexIndex];
    AVertex.Free;
  end;
  VertexList.Clear;
  VertexList.Free;
  // the only things in the segment list are verticies
  // that are also in VertexList.
  SegmentList.Free;
  inherited;
end;

// RowCenter returns the y-coordinate of the center of the cell
// (for block-centered grid) or the nodal point (for grid-centered
// grids.)

function TCell.RowCenter: double;
begin
  Result := RowMiddleList[Row - 1];
end;

// RowCenter returns the x-coordinate of the center of the cell
// (for block-centered grid) or the nodal point (for grid-centered
// grids.)

function TCell.ColumnCenter: double;
begin
  Result := ColumnMiddleList[Column - 1];
end;

// SegmentFirstVertexXPos returns the x-coordinate of the first vertex in the
// segment designated by SegmentIndex

function TCell.SegmentFirstVertexXPos(SegmentIndex: integer): double;
var
  AVertex: TBL_Vertex;
begin
  AVertex := SegmentList.Items[SegmentIndex];
  result := AVertex.XPos;
end;

// SegmentFirstVertexYPos returns the y-coordinate of the first vertex in the
// segment designated by SegmentIndex

function TCell.SegmentFirstVertexYPos(SegmentIndex: integer): double;
var
  AVertex: TBL_Vertex;
begin
  AVertex := SegmentList.Items[SegmentIndex];
  result := AVertex.YPos;
end;

// SegmentSecondVertexXPos returns the x-coordinate of the second vertex in the
// segment designated by SegmentIndex

function TCell.SegmentSecondVertexXPos(SegmentIndex: integer): double;
var
  AVertex, AnotherVertex: TBL_Vertex;
begin
  AVertex := SegmentList.Items[SegmentIndex];
  AnotherVertex := VertexList.Items[VertexList.IndexOf(AVertex) + 1];
  result := AnotherVertex.XPos;
end;

// SegmentSecondVertexYPos returns the y-coordinate of the second vertex in the
// segment designated by SegmentIndex

function TCell.SegmentSecondVertexYPos(SegmentIndex: integer): double;
var
  AVertex, AnotherVertex: TBL_Vertex;
begin
  AVertex := SegmentList.Items[SegmentIndex];
  AnotherVertex := VertexList.Items[VertexList.IndexOf(AVertex) + 1];
  result := AnotherVertex.YPos;
end;

// SegmentXLength returns the distance between the first and second
// x-coordinates of the segment designated by SegmentIndex

function TCell.SegmentXLength(SegmentIndex: integer): double;
begin
  result := SegmentSecondVertexXPos(SegmentIndex) -
    SegmentFirstVertexXPos(SegmentIndex);
end;

// SegmentYLength returns the distance between the first and second
// y-coordinates of the segment designated by SegmentIndex

function TCell.SegmentYLength(SegmentIndex: integer): double;
begin
  result := SegmentSecondVertexYPos(SegmentIndex) -
    SegmentFirstVertexYPos(SegmentIndex);
end;

// SegmentLength returns the length
// of the segment designated by SegmentIndex

function TCell.SegmentLength(SegmentIndex: integer): double;
begin
  result := Sqrt(Sqr(SegmentXLength(SegmentIndex)) +
    Sqr(SegmentYLength(SegmentIndex)));
end;

// SumSegmentXLength returns the sum of distances between the x-coordinates
// of all the segments in the cell.
// Because all the segments in a cell are assumed to be part of a single
// continuous line, this could be calculated by just comparing the x-coordinates
// of the first and last vertices in the cell that are part of segments.

function TCell.SumSegmentXLength: double;
var
  SegmentIndex: integer;
begin
  result := 0;
  for SegmentIndex := 0 to SegmentList.Count - 1 do
  begin
    result := result + SegmentXLength(SegmentIndex);
  end;
end;

// SumSegmentYLength returns the sum of distances between the y-coordinates
// of all the segments in the cell.
// Because all the segments in a cell are assumed to be part of a single
// continuous line, this could be calculated by just comparing the y-coordinates
// of the first and last vertices in the cell that are part of segments.

function TCell.SumSegmentYLength: double;
var
  SegmentIndex: integer;
begin
  result := 0;
  for SegmentIndex := 0 to SegmentList.Count - 1 do
  begin
    result := result + SegmentYLength(SegmentIndex);
  end;
end;

// SumSegmentYLength returns the sum of the lengths of all the segments
// in a cell.

function TCell.SumSegmentLength: double;
var
  SegmentIndex: integer;
begin
  result := 0;
  for SegmentIndex := 0 to SegmentList.Count - 1 do
  begin
    result := result + SegmentLength(SegmentIndex);
  end;
end;

// SegmentCrossesRowMidline returns true if the segment designated by
// SegmentIndex crosses the row midline (for block centered grids) or the
// y-coordinate of the nodal point (for grid-centered grids).

function TCell.SegmentCrossesRowMidline(SegmentIndex: integer): boolean;
var
  UpperY, LowerY: double;
  ARow: double;
begin
  if SegmentFirstVertexYPos(SegmentIndex) > SegmentSecondVertexYPos(SegmentIndex)
    then
  begin
    UpperY := SegmentFirstVertexYPos(SegmentIndex);
    LowerY := SegmentSecondVertexYPos(SegmentIndex);
  end
  else
  begin
    UpperY := SegmentSecondVertexYPos(SegmentIndex);
    LowerY := SegmentFirstVertexYPos(SegmentIndex);
  end;
  ARow := RowList.Items[RowList.Count - 1];
  if ARow = RowCenter then
  begin
    result := (not (UpperY < RowCenter) and not (LowerY > RowCenter) and not
      (UpperY = LowerY));
  end
  else
  begin
    result := ((UpperY > RowCenter) and not (LowerY > RowCenter));
  end;
end;

// SegmentCrossesColumnMidline returns true if the segment designated by
// SegmentIndex crosses the column midline (for block centered grids) or the
// x-coordinate of the nodal point (for grid-centered grids).

function TCell.SegmentCrossesColumnMidline(SegmentIndex: integer): boolean;
var
  UpperX, LowerX: double;
  AColumn: double;
begin
  if SegmentFirstVertexXPos(SegmentIndex) > SegmentSecondVertexXPos(SegmentIndex)
    then
  begin
    UpperX := SegmentFirstVertexXPos(SegmentIndex);
    LowerX := SegmentSecondVertexXPos(SegmentIndex);
  end
  else
  begin
    UpperX := SegmentSecondVertexXPos(SegmentIndex);
    LowerX := SegmentFirstVertexXPos(SegmentIndex);
  end;
  AColumn := ColumnList.Items[ColumnList.Count - 1];
  if AColumn = ColumnCenter then
  begin
    result := (not (UpperX < ColumnCenter) and not (LowerX > ColumnCenter) and
      not (UpperX = LowerX));
  end
  else
  begin
    result := ((UpperX > ColumnCenter) and not (LowerX > ColumnCenter));
  end;
end;

// CountSegmentCrossesRowMidline returns the number of segments that
// crosses the row midline (for block centered grids) or the
// y-coordinate of the nodal point (for grid-centered grids).

function TCell.CountSegmentCrossesRowMidline: integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to SegmentList.Count - 1 do
  begin
    if SegmentCrossesRowMidline(i) then
    begin
      Inc(result);
    end;
  end;
end;

// CountSegmentCrossesColumnMidline returns the number of segments that
// crosses the column midline (for block centered grids) or the
// x-coordinate of the nodal point (for grid-centered grids).

function TCell.CountSegmentCrossesColumnMidline: integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to SegmentList.Count - 1 do
  begin
    if SegmentCrossesColumnMidline(i) then
    begin
      Inc(result);
    end;
  end;
end;

// LineCrossesRowMidline returns true if the beginning and end points
// of the line comprised of all the segments in the segment list
// has its two ends on opposite sides of the row midline
// (for block centered grids) or the
// y-coordinate of the nodal point (for grid-centered grids).
// Note that if the line crosses the midline and then crosses back
// LineCrossesRowMidline will return false.

function TCell.LineCrossesRowMidline: boolean;
begin
  result := Odd(CountSegmentCrossesRowMidline);
end;

// LineCrossesColumnMidline returns true if the beginning and end points
// of the line comprised of all the segments in the segment list
// has its two ends on opposite sides of the column midline
// (for block centered grids) or the
// x-coordinate of the nodal point (for grid-centered grids).
// Note that if the line crosses the midline and then crosses back
// LineCrossesColumnMidline will return false.

function TCell.LineCrossesColumnMidline: boolean;
begin
  result := Odd(CountSegmentCrossesColumnMidline);
end;

// MaxX returns the largest x-coordinate of any of the verticies in the
// segment list.

function TCell.MaxX: double;
var
  SegmentIndex: integer;
  temp: double;
begin
  if SegmentList.Count = 0 then
  begin
    raise ENoSegments.Create('The current cell has no segments');
  end;
  result := SegmentFirstVertexXPos(0);
  for SegmentIndex := 1 to SegmentList.Count - 1 do
  begin
    temp := SegmentFirstVertexXPos(SegmentIndex);
    if temp > result then
    begin
      result := temp;
    end;
  end;
  temp := SegmentSecondVertexXPos(SegmentList.Count - 1);
  if temp > result then
  begin
    result := temp;
  end;

end;

// MinX returns the smallest x-coordinate of any of the verticies in the
// segment list.

function TCell.MinX: double;
var
  SegmentIndex: integer;
  temp: double;
begin
  if SegmentList.Count = 0 then
  begin
    raise ENoSegments.Create('The current cell has no segments');
  end;
  result := SegmentFirstVertexXPos(0);
  for SegmentIndex := 1 to SegmentList.Count - 1 do
  begin
    temp := SegmentFirstVertexXPos(SegmentIndex);
    if temp < result then
    begin
      result := temp;
    end;
  end;
  temp := SegmentSecondVertexXPos(SegmentList.Count - 1);
  if temp < result then
  begin
    result := temp;
  end;

end;

// MaxY returns the largest y-coordinate of any of the verticies in the
// segment list.

function TCell.MaxY: double;
var
  SegmentIndex: integer;
  temp: double;
begin
  if SegmentList.Count = 0 then
  begin
    raise ENoSegments.Create('The current cell has no segments');
  end;
  result := SegmentFirstVertexYPos(0);
  for SegmentIndex := 1 to SegmentList.Count - 1 do
  begin
    temp := SegmentFirstVertexYPos(SegmentIndex);
    if temp > result then
    begin
      result := temp;
    end;
  end;
  temp := SegmentSecondVertexYPos(SegmentList.Count - 1);
  if temp > result then
  begin
    result := temp;
  end;

end;

// MinY returns the smalles y-coordinate of any of the verticies in the
// segment list.

function TCell.MinY: double;
var
  SegmentIndex: integer;
  temp: double;
begin
  if SegmentList.Count = 0 then
  begin
    raise ENoSegments.Create('The current cell has no segments');
  end;
  result := SegmentFirstVertexYPos(0);
  for SegmentIndex := 1 to SegmentList.Count - 1 do
  begin
    temp := SegmentFirstVertexYPos(SegmentIndex);
    if temp < result then
    begin
      result := temp;
    end;
  end;
  temp := SegmentSecondVertexYPos(SegmentList.Count - 1);
  if temp < result then
  begin
    result := temp;
  end;
end;

// CompositeY should only be called after RowEndCell and RowBeginCell
// are set to appropriate values. It is meant to give the distance in the
// Y direction between the beginning and end point of a line that crosses a
// cell midline in the y direction. It is meant to be used to incorporates
// the portions of the line in other cells that are in the same row but in
// which the line does not cross the cell midline in the y direction.

function TCell.CompositeY: double;
begin
  if SegmentSecondVertexYPos(SegmentList.Count - 1) > RowCenter then
  begin
    result := RowEndCell.MaxY - RowBeginCell.MinY;
  end
  else
  begin
    result := RowEndCell.MinY - RowBeginCell.MaxY;
  end;

end;

// CompositeY should only be called after ColumnEndCell and ColumnBeginCell
// are set to appropriate values. It is meant to give the distance in the
// X direction between the beginning and end point of a line that crosses a
// cell midline in the x direction. It is meant to be used to incorporates
// the portions of the line in other cells that are in the same column but in
// which the line does not cross the row midline in the x direction.

function TCell.CompositeX: double;
begin
  if SegmentSecondVertexXPos(SegmentList.Count - 1) > ColumnCenter then
  begin
    result := ColumnEndCell.MaxX - ColumnBeginCell.MinX;
  end
  else
  begin
    result := ColumnEndCell.MinX - ColumnBeginCell.MaxX;
  end;
end;

{
procedure TCell.GetRotatedLineCenter(out X, Y: double);
var
  TargetLength: double;
  LengthIncrement: double;
  Length: double;
  SegmentIndex: integer;
  Fraction: double;
  X1, X2, Y1, Y2: double;
begin
  X := 0;
  Y := 0;
  TargetLength := SumSegmentLength / 2;
  Length := 0;
  for SegmentIndex := 0 to SegmentList.Count - 1 do
  begin
    LengthIncrement := SegmentLength(SegmentIndex);
    if Length + LengthIncrement >= TargetLength then
    begin
      if LengthIncrement = 0 then
      begin
        Fraction := 0;
      end
      else
      begin
        Fraction := (TargetLength - Length) / LengthIncrement;
      end;
      X1 := SegmentFirstVertexXPos(SegmentIndex);
      X2 := SegmentFirstVertexYPos(SegmentIndex);
      Y1 := SegmentSecondVertexXPos(SegmentIndex);
      Y2 := SegmentSecondVertexYPos(SegmentIndex);
      X := X1 + Fraction*(X2 - X1);
      Y := Y1 + Fraction*(Y2 - Y1);
      Exit;
    end
    else
    begin
      Length := Length + LengthIncrement;
    end;

  end;

end;
}

procedure TCell.SegmentMidpoint(const SegmentIndex: integer; out X,
  Y: double);
begin
  X := (SegmentFirstVertexXPos(SegmentIndex)
    + SegmentSecondVertexXPos(SegmentIndex))/2;
  Y := (SegmentFirstVertexYPos(SegmentIndex)
    + SegmentSecondVertexYPos(SegmentIndex))/2;
end;

end.

