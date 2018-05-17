unit ThreeDRealListUnit;

interface

uses Classes, dialogs;

type
  T3DRealList = class(TObject)
    private
      FList : TList;
      FMaxX : integer;
      FMaxY : Integer;
      FMaxZ : integer;
      procedure SetItem (X, Y, Z : integer; const AReal : double);
      function GetItem (X, Y, Z : integer): double;
    public
      constructor Create(MaximumX, MaximumY, MaximumZ : integer);
      destructor Destroy; Override;
      class procedure Error(const Msg: string; Data: Integer); virtual;
      Property Items[X, Y, Z : integer] : double  read GetItem write SetItem;
      property XCount : integer read FMaxX;
      property YCount : integer read FMaxY;
      property ZCount : integer read FMaxZ;
    end;

implementation

type
  TRealClass = Class(TObject)
    AReal : double;
    end;

constructor T3DRealList.Create(MaximumX, MaximumY, MaximumZ : integer);
var
  Limit, Index : integer;
  ARealClass : TRealClass;
begin
  FList := TList.Create;
  FMaxX := MaximumX;
  FMaxY := MaximumY;
  FMaxZ := MaximumZ;
  Limit := FMaxX * FMaxY * FMaxZ;
  FList.Capacity := Limit;
  for Index := 1 to Limit do
  begin
    ARealClass := TRealClass.Create;
    ARealClass.AReal := 0;
    FList.Add(ARealClass);
  end;

end;

destructor T3DRealList.Destroy;
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

class procedure T3DRealList.Error(const Msg: string; Data: Integer);
begin
  TList.Error(Msg, Data);
end;

procedure T3DRealList.SetItem (X, Y, Z : integer; const  AReal : double);
var
  ARealClass : TRealClass;
  Index : integer;
begin
  if (X > FMaxX -1) or (Y > FMaxY -1) or (Z > FMaxZ -1)
     or (X < 0) or (Y < 0) or (Z < 0) then
  begin
    raise EListError.Create('X, Y, or Z is out of bounds in a T3DRealList');
  end;
  Index := ((Z * FMaxY) + Y) * FMaxX + X;
  ARealClass := FList.Items[Index];
  if not ( ARealClass.AReal = AReal) then
  begin
    ARealClass.AReal := AReal;
  end;
end;

function T3DRealList.GetItem (X, Y, Z : integer): double;
var
  ARealClass : TRealClass;
  Index : integer;
begin
  if (X > FMaxX -1) or (Y > FMaxY -1) or (Z > FMaxZ -1)
     or (X < 0) or (Y < 0) or (Z < 0) then
  begin
    if (X > FMaxX -1) then
    begin
      ShowMessage('X');
    end;
    if (Y > FMaxY -1) then
    begin
      ShowMessage('Y');
    end;
    if (Z > FMaxZ -1) then
    begin
      ShowMessage('Z');
    end;
    raise EListError.Create('X, Y, or Z is out of bounds in a T3DRealList');
  end;
  Index := ((Z * FMaxY) + Y) * FMaxX + X;
  ARealClass := FList.Items[Index];
  result := ARealClass.AReal;
end;

end.
