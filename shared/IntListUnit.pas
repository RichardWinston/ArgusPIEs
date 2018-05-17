unit IntListUnit;

interface

uses Classes;

type
  TIntegerList = class(TObject)
  // TIntegerList acts much like TList except that it stores integers
  // rather than pointers.
    private
      FList : TList;
      FSorted: boolean;
      procedure SetItem (Index: integer; const AnInteger : integer);
      function GetItem (Index: integer): integer;
      function GetCount : integer;
      procedure SetCapacity(ACapacity : Integer);
      function GetCapacity : integer;
      Procedure SetSorted(AValue : boolean);
    public
      function Add(const AnInteger : integer): integer;
      procedure AddUnique(const AnInteger: integer);
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
      Property Items[Index: integer] : integer  read GetItem write SetItem; default;
      property Count : integer read GetCount;
      property Capacity : integer read GetCapacity write SetCapacity;
      property Sorted : boolean read FSorted write SetSorted;
      procedure Sort;
      function IndexOf(AnInteger: integer): integer;
      function MaxValue : integer;
      function MinValue : integer;
      function Nearest(Const TestValue : integer): integer;
    end;

  TIntListList = class(TObject)
    private
      FList : TList;
      procedure SetItem (Index: integer; const AnIntList : TIntegerList);
      function GetItem (Index: integer): TIntegerList;
      function GetCount : integer;
      procedure SetCapacity(ACapacity : Integer);
      function GetCapacity : integer;
    public
      procedure Add(const AnIntList : TIntegerList);
      procedure Clear;
      constructor Create;
      destructor Destroy; Override;
      Property Items[Index: integer] : TIntegerList  read GetItem write SetItem; default;
      property Count : integer read GetCount;
      property Capacity : integer read GetCapacity write SetCapacity;
      function IndexOf(AnIntList : TIntegerList): integer;
    end;

implementation

type
  TIntegerClass = class(TObject)
    AnInteger : integer;
    end;

constructor TIntegerList.Create;
begin
  inherited;
  FList := TList.Create;
  FSorted := False;
end;

destructor TIntegerList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;
procedure TIntegerList.AddUnique(const AnInteger : integer);
begin
  if IndexOf(AnInteger) = -1 then
  begin
    Add(AnInteger);
  end;
end;

function TIntegerList.Add(const AnInteger : integer): integer;
var
  AnIntegerClass : TIntegerClass;
  Top,Bottom, Middle : integer;
  Int1, Int2: TIntegerClass;
begin
  AnIntegerClass := TIntegerClass.Create;
  AnIntegerClass.AnInteger := AnInteger;

  if FSorted then
  begin
    if FList.Count > 0 then
    begin
      Int1 := FList.Items[0];
      Int2 := FList.Items[FList.Count-1];
      if Int1.AnInteger > AnInteger then
      begin
        FList.Insert(0,AnIntegerClass);
        result := 0;
      end
      else if (Int2.AnInteger < AnInteger) then
      begin
        result := FList.Add(AnIntegerClass);
      end
      else
      begin
        Top := FList.Count-1;
        Bottom := 0;
        While Top - Bottom > 1 do
        begin
          Middle := (Top+Bottom) div 2;
          Int1 := FList.Items[Middle];
          if Int1.AnInteger < AnInteger then
          begin
            Bottom := Middle;
          end
          else
          begin
            Top := Middle;
          end;
        end; // While Top - Bottom > 1 do
        FList.Insert(Top,AnIntegerClass);
        result := Top;
      end;
    end
    else // if FList.Count > 0 then
    begin
      result := FList.Add(AnIntegerClass);
    end;
  end
  else // if FSorted then
  begin
    result := FList.Add(AnIntegerClass);
  end;
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
//  FSorted := False;
end;

class procedure TIntegerList.Error(const Msg: string; Data: Integer);
begin
  TList.Error(Msg, Data);
end;

procedure TIntegerList.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
  FSorted := False;
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
  FSorted := False;
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
  FSorted := False;
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
    FSorted := False;
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

function SortFunction(Item1, Item2: Pointer): Integer;
Var
  Int1, Int2 : TIntegerClass;
begin
  Int1 := Item1;
  Int2 := Item2;
  if Int1.AnInteger < Int2.AnInteger then
  begin
    result := -1;
  end
  else if Int1.AnInteger = Int2.AnInteger then
  begin
    result := 0;
  end
  else
  begin
    result := 1;
  end;
end;


procedure TIntegerList.Sort;
begin
  FList.Sort(SortFunction);
  FSorted := True;
end;

function TIntegerList.IndexOf(AnInteger: integer): integer;
var
  Index, Top, Bottom, Middle : integer;
  Int1, Int2 : TIntegerClass;
begin
  if FSorted then
  begin
    if FList.Count = 0 then
    begin
      result := -1;
    end
    else
    begin
      Int1 := FList.Items[0];
      Int2 := FList.Items[FList.Count-1];
      if (Int1.AnInteger > AnInteger) or
         (Int2.AnInteger < AnInteger) then
      begin
        result := -1;
      end
      else
      begin
        Top := FList.Count-1;
        Bottom := 0;
        While Top - Bottom > 1 do
        begin
          Middle := (Top+Bottom) div 2;
          Int1 := FList.Items[Middle];
          if Int1.AnInteger < AnInteger then
          begin
            Bottom := Middle;
          end
          else
          begin
            Top := Middle;
          end;
        end; // While Top - Bottom > 1 do
        Int1 := FList.Items[Bottom];
        Int2 := FList.Items[Top];
        if Int1.AnInteger = AnInteger then
        begin
          result := Bottom;
        end
        else if Int2.AnInteger = AnInteger then
        begin
          result := Top;
        end
        else
        begin
          result := -1;

        end;
      end;
    end;
  end
  else
  begin
    result := -1;
    for Index := 0 to FList.Count -1 do
    begin
      Int1 := FList.Items[Index];
      if Int1.AnInteger = AnInteger then
      begin
        result := Index;
        break;
      end;
    end;
  end;
end;

{ TIntListList }

procedure TIntListList.Add(const AnIntList: TIntegerList);
begin
  FList.Add(AnIntList);
end;

procedure TIntListList.Clear;
begin
  FList.Clear;
end;

constructor TIntListList.Create;
begin
  inherited;
  FList := TList.Create;
end;

destructor TIntListList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TIntListList.GetCapacity: integer;
begin
  result := FList.Capacity;
end;

function TIntListList.GetCount: integer;
begin
  result := FList.Count;
end;

function TIntListList.GetItem(Index: integer): TIntegerList;
begin
  Result := FList[Index];
end;

function TIntListList.IndexOf(AnIntList: TIntegerList): integer;
begin
  result := FList.IndexOf(AnIntList);
end;

procedure TIntListList.SetCapacity(ACapacity: Integer);
begin
  FList.Capacity := ACapacity;
end;

procedure TIntListList.SetItem(Index: integer;
  const AnIntList: TIntegerList);
begin
  FList[Index] := AnIntList;
end;

procedure TIntegerList.SetSorted(AValue: boolean);
begin
  if AValue then
  begin
    Sort;
  end
  else
  begin
    FSorted := False;
  end;
end;

function TIntegerList.MaxValue: integer;
var
  Index : integer;
begin
  if Count = 0 then
  begin
    result := 0;
  end
  else
  begin
    result := Items[0];
    for Index := 1 to Count -1 do
    begin
      if Items[Index] > result then
      begin
        result := Items[Index];
      end;
    end;
  end;
end;

function TIntegerList.MinValue: integer;
var
  Index : integer;
begin
  if Count = 0 then
  begin
    result := 0;
  end
  else
  begin
    result := Items[0];
    for Index := 1 to Count -1 do
    begin
      if Items[Index] < result then
      begin
        result := Items[Index];
      end;
    end;
  end;
end;

function TIntegerList.Nearest(const TestValue: integer): integer;
var
  Index : integer;
  Delta, Test : integer;
  Top, Bottom, Middle : integer;
begin
  if Sorted then
  begin
    if FList.Count = 0 then
    begin
      result := -1;
    end
    else
    begin
      if (Items[0] > TestValue) then
      begin
        result := 0
      end
      else if (Items[Count-1] < TestValue) then
      begin
        result := Count-1;
      end
      else
      begin
        Top := Count-1;
        Bottom := 0;
        While Top - Bottom > 1 do
        begin
          Middle := (Top+Bottom) div 2;
          if Items[Middle] < TestValue then
          begin
            Bottom := Middle;
          end
          else
          begin
            Top := Middle;
          end;
        end; // While Top - Bottom > 1 do
        if Items[Bottom] = TestValue then
        begin
          result := Bottom;
        end
        else if Items[Top] = TestValue then
        begin
          result := Top;
        end
        else
        begin
          if Abs(Items[Bottom]-TestValue) < Abs(Items[Top]-TestValue) then
          begin
            result := Bottom;
          end
          else
          begin
            result := Top;
          end;
        end;
      end;
    end;
  end
  else
  begin
    result := -1;
    if Count > 0 then
    begin
      Delta := Abs(Items[0] - TestValue);
      result := 0;
      for Index := 1 to Count -1 do
      begin
        Test := Abs(Items[Index] - TestValue);
        if Test < Delta then
        begin
          Delta := Test;
          result := Index;
        end;
      end;
    end;

  end;
end;

end.
