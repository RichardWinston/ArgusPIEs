unit ThreeDIntListUnit;

interface

uses Classes;

type
  T3DIntegerList = class(TObject)
    private
      FList : TList;
      FMaxX : integer;
      FMaxY : Integer;
      FMaxZ : integer;
      procedure SetItem (X, Y, Z : integer; const AnInteger : integer);
      function GetItem (X, Y, Z : integer): integer;
    public
      constructor Create(MaximumX, MaximumY, MaximumZ : integer);
      destructor Destroy; Override;
      class procedure Error(const Msg: string; Data: Integer); virtual;
      Property Items[X, Y, Z : integer] : integer  read GetItem write SetItem;
      property XCount : integer read FMaxX;
      property YCount : integer read FMaxY;
      property ZCount : integer read FMaxZ;
    end;

implementation

type
  TIntegerClass = class(TObject)
    AnInteger : integer;
    end;

constructor T3DIntegerList.Create(MaximumX, MaximumY, MaximumZ : integer);
var
  Limit, Index : integer;
  AnIntegerClass : TIntegerClass;
begin
  FList := TList.Create;
  FMaxX := MaximumX;
  FMaxY := MaximumY;
  FMaxZ := MaximumZ;
  Limit := FMaxX * FMaxY * FMaxZ;
  FList.Capacity := Limit;
  for Index := 1 to Limit do
  begin
    AnIntegerClass := TIntegerClass.Create;
    AnIntegerClass.AnInteger := 0;
    FList.Add(AnIntegerClass);
  end;

end;

destructor T3DIntegerList.Destroy;
var
  AnIntegerClass : TIntegerClass;
  index : integer;
begin
  for index := FList.Count -1 downto 0 do
  begin
    AnIntegerClass := FList.Items[Index];
    AnIntegerClass.Free;
  end;
  FList.Clear;
  FList.Free;
end;

class procedure T3DIntegerList.Error(const Msg: string; Data: Integer);
begin
  TList.Error(Msg, Data);
end;

procedure T3DIntegerList.SetItem (X, Y, Z : integer;
  const  AnInteger : integer);
var
  AnIntegerClass : TIntegerClass;
  Index : integer;
begin
  if (X > FMaxX -1) or (Y > FMaxY -1) or (Z > FMaxZ -1)
     or (X < 0) or (Y < 0) or (Z < 0) then
  begin
    raise EListError.Create('X, Y, or Z is out of bounds in a T3DIntegerList');
  end;
  Index := ((Z * FMaxY) + Y) * FMaxX + X;
  AnIntegerClass := FList.Items[Index];
  if not ( AnIntegerClass.AnInteger = AnInteger) then
  begin
    AnIntegerClass.AnInteger := AnInteger;
  end;
end;

function T3DIntegerList.GetItem (X, Y, Z : integer): integer;
var
  AnIntegerClass : TIntegerClass;
  Index : integer;
begin
  if (X > FMaxX -1) or (Y > FMaxY -1) or (Z > FMaxZ -1)
    or (X < 0) or (Y < 0) or (Z < 0) then
  begin
    raise EListError.Create('X, Y, or Z is out of bounds in a T3DIntegerList');
  end;
  Index := ((Z * FMaxY) + Y) * FMaxX + X;
  AnIntegerClass := FList.Items[Index];
  result := AnIntegerClass.AnInteger;
end;

end.
