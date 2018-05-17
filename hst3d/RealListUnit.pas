unit RealListUnit;

interface

uses Classes;

type
  TRealList = class(TObject)
    private
      FList : TList;
      procedure SetItem (Index: integer; const AReal : double);
      function GetItem (Index: integer): double;
      function GetCount : integer;
      procedure SetCapacity(ACapacity : Integer);
      function GetCapacity : integer;
    public
      procedure Add(const AReal : double);
      procedure Clear;
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
      Property Items[Index: integer] : double  read GetItem write SetItem;
      property Count : integer read GetCount;
      property Capacity : integer read GetCapacity write SetCapacity;
    end;

implementation

type
  TRealClass = Class(TObject)
    AReal : double;
    end;

constructor TRealList.Create;
begin
  FList := TList.Create;
end;

destructor TRealList.Destroy;
var
  ARealClass : TRealClass;
  index : integer;
begin
  for index := FList.Count -1 downto 0 do
  begin
    ARealClass := FList.Items[Index];
    ARealClass.Free;
  end;
  FList.Clear;
  FList.Free;
end;

procedure TRealList.Add(const AReal : double);
var
  ARealClass : TRealClass;
begin
  ARealClass := TRealClass.Create;
  ARealClass.AReal := AReal;
  FList.Add(ARealClass);
end;

procedure TRealList.Delete(Index: Integer);
var
  ARealClass : TRealClass;
begin
  ARealClass := FList.Items[Index];
  FList.Delete(Index);
  ARealClass.Free;
end;

procedure TRealList.Clear;
begin
  FList.Clear;
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
  ARealClass := FList.Items[Index];
  if not ( ARealClass.AReal = AReal) then
  begin
    ARealClass.AReal := AReal;
  end;
end;

function TRealList.GetItem (Index: integer): double;
var
  ARealClass : TRealClass;
begin
  ARealClass := FList.Items[Index];
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

end.

