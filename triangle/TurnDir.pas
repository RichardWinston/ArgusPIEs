unit TurnDir;

interface

uses classes;

type
  TTurnDirection = (tdRight, tdStraight, tdLeft);

  THullPoint = class(TObject)
    X, Y : double;
  end;

function TurnDirection(const HullList : TList) : TTurnDirection;
// HullList  contains nothing but THullPoint's and must contain at least three
// points.
// The function returns the turn direction of the last three points.

implementation

uses Determ;

function MySign(const AValue : double) : integer;
const
  Epsilon = 1e-7;
begin
  result := 0;
  if AValue < -Epsilon then
  begin
    result := -1;
  end
  else if AValue > Epsilon then
  begin
    result := 1;
  end

end;

function TurnDirection(const HullList : TList) : TTurnDirection;
var
  APoint : THullPoint;
  TestArray : TDetArray; //Ary3;
  Index : integer;
begin
  SetLength(TestArray, 3, 3);
  with HullList do
  begin
    Assert(Count > 2);
    for Index := 1 to 3 do
    begin
      APoint := Items[Count-Index];
      TestArray[3-Index,0] := 1;
      TestArray[3-Index,1] := APoint.X;
      TestArray[3-Index,2] := APoint.Y;
    end;
  end;
  result := tdLeft;
  case MySign(Determinant(TestArray, 3)) of
    -1:
      begin
        result := tdRight;
      end;
    0:
      begin
        result := tdStraight;
      end;
    1:
      begin
        result := tdLeft;
      end;
  else Assert(False);
  end;
end;

end.
