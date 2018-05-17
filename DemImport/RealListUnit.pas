unit RealListUnit;

interface

uses Classes, contnrs;

type
  TRealList = class(TObject)
  // TRealList is similar to TList except that it stores doubles instead
  // of pointers.
    private
      FList : TObjectList;
      function GetCapacity : integer;
      function GetCount : integer;
      function GetItem (Index: integer): double;
      procedure SetCapacity(ACapacity : Integer);
      procedure SetCount(Value : integer);
      procedure SetItem (Index: integer; const AReal : double);
    public
      Procedure Assign(ARealList : TRealList);
      function Add(const AReal : double) : integer;
      constructor Create;
      destructor Destroy; Override;
      procedure Delete(Index: Integer);
      class procedure Error(const Msg: string; Data: Integer); virtual;
      procedure Exchange(Index1, Index2: Integer);
      function First: double;
      procedure Insert(Index: Integer; AReal : double);
      function Last: double;
      procedure Move(CurIndex, NewIndex: Integer);
      procedure Pack;
      Property Items[Index: integer] : double  read GetItem write SetItem; default;
      property Count : integer read GetCount write SetCount;
      property Capacity : integer read GetCapacity write SetCapacity;
      procedure Clear;
      function IndexOf(Const AReal : double) : integer;
      procedure Sort;
    end;

implementation

type
  TRealClass = Class(TObject)
    AReal : double;
    end;

function SortReals(Item1, Item2: Pointer): Integer;
var
  AReal1 : TRealClass;
  AReal2 : TRealClass;
  Difference : double;
begin
  AReal1 := Item1;
  AReal2 := Item2;
  Difference := AReal1.AReal - AReal2.AReal;
  if Difference < 0 then
  begin
    result := -1;
  end
  else if Difference = 0 then
  begin
    result := 0;
  end
  else
  begin
    result := 1;
  end;
end;

constructor TRealList.Create;
begin
  inherited;
  FList := TObjectList.Create;
end;

destructor TRealList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TRealList.Add(const AReal : double) : integer;
var
  ARealClass : TRealClass;
begin
  ARealClass := TRealClass.Create;
  ARealClass.AReal := AReal;
  result := FList.Add(ARealClass);
end;

procedure TRealList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;


class procedure TRealList.Error(const Msg: string; Data: Integer);
begin
  TList.Error(Msg, Data);
end;

procedure TRealList.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;

function TRealList.First: double;
var
  ARealClass : TRealClass;
begin
  ARealClass := FList.First;
  result := ARealClass.AReal;
end;

procedure TRealList.Insert(Index: Integer; AReal : double);
var
  ARealClass : TRealClass;
begin
  ARealClass := TRealClass.Create;
  ARealClass.AReal := AReal;
  FList.Insert(Index, ARealClass);
end;

function TRealList.Last: double;
var
  ARealClass : TRealClass;
begin
  ARealClass := FList.Last;
  result := ARealClass.AReal;
end;

procedure TRealList.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
end;

procedure TRealList.Pack;
begin
  FList.Pack
end;

procedure TRealList.SetItem (Index: integer; const  AReal : double);
var
  ARealClass : TRealClass;
begin
  ARealClass := FList.Items[Index] as TRealClass;
  if not ( ARealClass.AReal = AReal) then
  begin
    ARealClass.AReal := AReal;
  end;
end;

function TRealList.GetItem (Index: integer): double;
var
  ARealClass : TRealClass;
begin
  ARealClass := FList.Items[Index] as TRealClass;
  result := ARealClass.AReal;
end;

function TRealList.GetCount : integer;
begin
  result := FList.Count
end;

procedure TRealList.SetCapacity(ACapacity : Integer);
begin
  if not (FList.Capacity = ACapacity) then
  begin
    FList.Capacity := ACapacity
  end;
end;

function TRealList.GetCapacity : integer;
begin
  result := FList.Capacity
end;

procedure TRealList.Assign(ARealList: TRealList);
var
  Index : integer;
begin
  Count := ARealList.Count;
  for Index := 0 to Count -1 do
  begin
    Items[Index] := ARealList.Items[Index];
  end;
end;

procedure TRealList.SetCount(Value: integer);
var
  OldCount : integer;
  Index : integer;
  ARealClass : TRealClass;
begin
  if FList.Count <> Value then
  begin
    OldCount := FList.Count;
    FList.Count := Value;
    for Index := OldCount to Value -1 do
    begin
      ARealClass := TRealClass.Create;
      ARealClass.AReal := 0;
      FList[Index] := ARealClass;
    end;
  end;
end;

procedure TRealList.Clear;
begin
  FList.Clear;  
end;

function TRealList.IndexOf(const AReal: double): integer;
var
  Index : integer;
begin
  result := -1;
  for Index := 0 to Count -1 do
  begin
    if Items[Index] = AReal then
    begin
      result := Index;
      Exit;
    end;
  end;
end;

procedure TRealList.Sort;
begin
  FList.Sort(SortReals);
end;

end.
