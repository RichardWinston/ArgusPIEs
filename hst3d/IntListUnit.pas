unit IntListUnit;

interface

uses Classes;

type
  TIntegerList = class(TObject)
    private
      FList : TList;
      procedure SetItem (Index: integer; const AnInteger : integer);
      function GetItem (Index: integer): integer;
      function GetCount : integer;
      procedure SetCapacity(ACapacity : Integer);
      function GetCapacity : integer;
    public
      procedure Add(const AnInteger : integer);
      procedure Clear;
      constructor Create;
      destructor Destroy; Override;
      procedure Delete(Index: Integer);
      class procedure Error(const Msg: string; Data: Integer); virtual;
      procedure Exchange(Index1, Index2: Integer);
      function First: Integer;
      procedure Insert(Index: Integer; AnInteger : integer);
      function Last: integer;
      procedure Move(CurIndex, NewIndex: Integer);
      procedure Pack;
      Property Items[Index: integer] : integer  read GetItem write SetItem;
      property Count : integer read GetCount;
      property Capacity : integer read GetCapacity write SetCapacity;
    end;

implementation

type
  TIntegerClass = class(TObject)
    AnInteger : integer;
    end;

constructor TIntegerList.Create;
begin
  FList := TList.Create;
end;

destructor TIntegerList.Destroy;
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

procedure TIntegerList.Add(const AnInteger : integer);
var
  AnIntegerClass : TIntegerClass;
begin
  AnIntegerClass := TIntegerClass.Create;
  AnIntegerClass.AnInteger := AnInteger;
  FList.Add(AnIntegerClass);
end;

procedure TIntegerList.Delete(Index: Integer);
var
  AnIntegerClass : TIntegerClass;
begin
  AnIntegerClass := FList.Items[Index];
  FList.Delete(Index);
  AnIntegerClass.Free;
end;

procedure TIntegerList.Clear;
begin
  FList.Clear;
end;

class procedure TIntegerList.Error(const Msg: string; Data: Integer);
begin
  TList.Error(Msg, Data);
end;

procedure TIntegerList.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;

function TIntegerList.First: Integer;
var
  AnIntegerClass : TIntegerClass;
begin
  AnIntegerClass := FList.First;
  result := AnIntegerClass.AnInteger;
end;

procedure TIntegerList.Insert(Index: Integer; AnInteger : integer);
var
  AnIntegerClass : TIntegerClass;
begin
  AnIntegerClass := TIntegerClass.Create;
  AnIntegerClass.AnInteger := AnInteger;
  FList.Insert(Index, AnIntegerClass);
end;

function TIntegerList.Last: integer;
var
  AnIntegerClass : TIntegerClass;
begin
  AnIntegerClass := FList.Last;
  result := AnIntegerClass.AnInteger;
end;

procedure TIntegerList.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
end;

procedure TIntegerList.Pack;
begin
  FList.Pack
end;

procedure TIntegerList.SetItem (Index: integer; const  AnInteger : integer);
var
  AnIntegerClass : TIntegerClass;
begin
  AnIntegerClass := FList.Items[Index];
  if not ( AnIntegerClass.AnInteger = AnInteger) then
  begin
    AnIntegerClass.AnInteger := AnInteger;
  end;
end;

function TIntegerList.GetItem (Index: integer): integer;
var
  AnIntegerClass : TIntegerClass;
begin
  AnIntegerClass := FList.Items[Index];
  result := AnIntegerClass.AnInteger;
end;

function TIntegerList.GetCount : integer;
begin
  result := FList.Count
end;

procedure TIntegerList.SetCapacity(ACapacity : Integer);
begin
  if not (FList.Capacity = ACapacity) then
  begin
    FList.Capacity := ACapacity
  end;
end;

function TIntegerList.GetCapacity : integer;
begin
  result := FList.Capacity
end;

end.
