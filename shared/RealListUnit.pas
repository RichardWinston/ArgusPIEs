unit RealListUnit;

interface

{$IFDEF VER200}
  {$DEFINE DELPHI7_OR_LATER}
{$ENDIF}
{$IFDEF VER190}
  {$DEFINE DELPHI7_OR_LATER}
{$ENDIF}
{$IFDEF VER180}
  {$DEFINE DELPHI7_OR_LATER}
{$ENDIF}
{$IFDEF VER170}
  {$DEFINE DELPHI7_OR_LATER}
{$ENDIF}
{$IFDEF VER150}
  {$DEFINE DELPHI7_OR_LATER}
{$ENDIF}

uses Classes, contnrs;

type
  // TRealList is similar to TList except that it stores doubles instead
  // of pointers.
  TRealList = class(TObject)
  private
    FList: TObjectList;
    FSorted: boolean;
    function GetCapacity: integer;
    function GetCount: integer;
    function GetItem(Index: integer): double;
    procedure SetCapacity(ACapacity: Integer);
    procedure SetCount(Value: integer);
    procedure SetItem(Index: integer; const AReal: double);
    procedure SetSorted(const Value: boolean);
  public
    // Add increases the count of the list by one.  If the list is sorted,
    // AReal is inserted at the appropriate place.  Otherwise it is added at
    // the end.
    function Add(const AReal: double): integer;
    // AddUnique adds AReal to the list if it isn't already in the list.
    // otherwise it returns the position of AReal in the list.
    function AddUnique(const AReal: double): integer;
    // Assign copies the contents of ARealList into the list that calls Assign.
    procedure Assign(ARealList: TRealList);
    // Capacity is the number of numbers that the TRealList can hold without
    // reallocating memory.  If you plan to add a large number of items to
    // the TRealList, setting Capacity to a large enough number first can
    // improve performance.
    property Capacity: integer read GetCapacity write SetCapacity;
    // Clear removes all real numbers from the list.
    procedure Clear;
    // Count is the number of real numbers in the TRealList.
    property Count: integer read GetCount write SetCount;
    // see inherited Create.
    constructor Create;
    // Delete removes the item at the position designated by Index
    procedure Delete(const Index: Integer);
    // see inherited Destroy.
    destructor Destroy; override;
    // Error generate an error message.
    class procedure Error(const Msg: string; Data: Integer); virtual;
    // Exchange exchanges the real numbers at postions Index1 and Index2.
    procedure Exchange(Index1, Index2: Integer);
    // First returns the first real number in the list.
    function First: double;
    // IndexOf returns the position of AReal in the list. If AReal is not in
    // the list, IndexOf returns -1.
    function IndexOf(const AReal: double): integer;
    // IndexOfClosest, returns the position of the number in the list that
    // is closes to AReal.
    function IndexOfClosest(const AReal: double): integer;
    // Insert inserts AReal at Index.
    procedure Insert(Index: Integer; AReal: double);
    // Items is used to set or retrive real numbers from the TRealList.
    // Use @Link(Count) to determine how many real numbers are in the TRealList.
    property Items[Index: integer]: double read GetItem write SetItem; default;
    // Last returns the last real number in the list.
    function Last: double;
    // Move moves the number to CurIndex to NewIndex.
    procedure Move(CurIndex, NewIndex: Integer);
    // Pack removes nil pointers from the internal TList.
    procedure Pack;
    // Sort sorts the numbers in the list in ascending order and
    // sets @Link(Sorted) to true.
    procedure Sort;
    // If Sorted is true, the numbers in the list are in ascending order and
    // when a new number is added (see @Link(Add) ) to the list, it will be
    // inserted in the correct position to keep the list sorted.
    property Sorted: boolean read FSorted write SetSorted;
  end;

implementation

type
  TRealClass = class(TObject)
    AReal: double;
  end;

function SortReals(Item1, Item2: Pointer): Integer;
var
  AReal1: TRealClass;
  AReal2: TRealClass;
  Difference: double;
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

function TRealList.Add(const AReal: double): integer;
var
  ARealClass: TRealClass;
  Top, Bottom, Middle: integer;
begin
  ARealClass := TRealClass.Create;
  ARealClass.AReal := AReal;
  if FSorted then
  begin
    if FList.Count > 0 then
    begin
      if (TRealClass(FList.Items[0]).AReal > AReal) then
      begin
        FList.Insert(0, ARealClass);
        result := 0;
      end
      else if (TRealClass(FList.Items[FList.Count - 1]).AReal < AReal) then
      begin
        result := FList.Add(ARealClass);
      end
      else
      begin
        Top := FList.Count - 1;
        Bottom := 0;
        while Top - Bottom > 1 do
        begin
          Middle := (Top + Bottom) div 2;
          if TRealClass(FList.Items[Middle]).AReal < AReal then
          begin
            Bottom := Middle;
          end
          else
          begin
            Top := Middle;
          end;
        end; // While Top - Bottom > 1 do
        FList.Insert(Top, ARealClass);
        result := Top;
      end;
    end
    else // if FList.Count > 0 then
    begin
      result := FList.Add(ARealClass);
    end;
  end
  else // if FSorted then
  begin
    Result := FList.Add(ARealClass);
  end;
end;

procedure TRealList.Delete(const Index: Integer);
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
  FSorted := False;
end;

function TRealList.First: double;
var
  ARealClass: TRealClass;
begin

  ARealClass := FList.First {$IFDEF DELPHI7_OR_LATER} as TRealClass {$ENDIF};
  result := ARealClass.AReal;
end;

procedure TRealList.Insert(Index: Integer; AReal: double);
var
  ARealClass: TRealClass;
begin
  ARealClass := TRealClass.Create;
  ARealClass.AReal := AReal;
  FList.Insert(Index, ARealClass);
  FSorted := False;
end;

function TRealList.Last: double;
var
  ARealClass: TRealClass;
begin
  ARealClass := FList.Last {$IFDEF DELPHI7_OR_LATER} as TRealClass {$ENDIF};
  result := ARealClass.AReal;
end;

procedure TRealList.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
  FSorted := False;
end;

procedure TRealList.Pack;
begin
  FList.Pack
end;

procedure TRealList.SetItem(Index: integer; const AReal: double);
var
  ARealClass: TRealClass;
begin
  ARealClass := FList.Items[Index] as TRealClass;
  if not (ARealClass.AReal = AReal) then
  begin
    ARealClass.AReal := AReal;
    FSorted := False;
  end;
end;

function TRealList.GetItem(Index: integer): double;
var
  ARealClass: TRealClass;
begin
  ARealClass := FList.Items[Index] as TRealClass;
  result := ARealClass.AReal;
end;

function TRealList.GetCount: integer;
begin
  result := FList.Count
end;

procedure TRealList.SetCapacity(ACapacity: Integer);
begin
  if not (FList.Capacity = ACapacity) then
  begin
    FList.Capacity := ACapacity
  end;
end;

function TRealList.GetCapacity: integer;
begin
  result := FList.Capacity
end;

procedure TRealList.Assign(ARealList: TRealList);
var
  Index: integer;
begin
  Count := ARealList.Count;
  for Index := 0 to Count - 1 do
  begin
    Items[Index] := ARealList.Items[Index];
  end;
  FSorted := ARealList.Sorted;
end;

procedure TRealList.SetCount(Value: integer);
var
  OldCount: integer;
  Index: integer;
  ARealClass: TRealClass;
begin
  if FList.Count <> Value then
  begin
    OldCount := FList.Count;
    FList.Count := Value;
    for Index := OldCount to Value - 1 do
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
  Index, Top, Bottom, Middle: integer;
begin
  if FSorted then
  begin
    if FList.Count = 0 then
    begin
      result := -1;
    end
    else
    begin
      if (TRealClass(FList.Items[0]).AReal > AReal) or
        (TRealClass(FList.Items[FList.Count - 1]).AReal < AReal) then
      begin
        result := -1;
      end
      else
      begin
        Top := FList.Count - 1;
        Bottom := 0;
        while Top - Bottom > 1 do
        begin
          Middle := (Top + Bottom) div 2;
          if TRealClass(FList.Items[Middle]).AReal < AReal then
          begin
            Bottom := Middle;
          end
          else
          begin
            Top := Middle;
          end;
        end; // While Top - Bottom > 1 do
        if TRealClass(FList.Items[Bottom]).AReal = AReal then
        begin
          result := Bottom;
        end
        else if TRealClass(FList.Items[Top]).AReal = AReal then
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
    for Index := 0 to FList.Count - 1 do
    begin
      if TRealClass(FList.Items[Index]).AReal = AReal then
      begin
        result := Index;
        break;
      end;
    end;
  end;
end;

procedure TRealList.Sort;
begin
  FList.Sort(SortReals);
  FSorted := True;
end;

procedure TRealList.SetSorted(const Value: boolean);
begin
  if Value then
  begin
    Sort;
  end
  else
  begin
    FSorted := False;
  end;
end;

function TRealList.AddUnique(const AReal: double): Integer;
begin
  result := IndexOf(AReal);
  if result = -1 then
  begin
    result := Add(AReal);
  end;
end;

function TRealList.IndexOfClosest(const AReal: double): integer;
var
  Index, Top, Bottom, Middle : integer;
  MinDistance, Test: double;
begin
  if FSorted then
  begin
    if FList.Count = 0 then
    begin
      result := -1;
    end
    else
    begin
      if (TRealClass(FList.Items[0]).AReal > AReal) then
      begin
        result := 0
      end
      else if (TRealClass(FList.Items[FList.Count-1]).AReal < AReal) then
      begin
        result := FList.Count-1;
      end
      else
      begin
        Top := FList.Count-1;
        Bottom := 0;
        While Top - Bottom > 1 do
        begin
          Middle := (Top+Bottom) div 2;
          if TRealClass(FList.Items[Middle]).AReal < AReal then
          begin
            Bottom := Middle;
          end
          else
          begin
            Top := Middle;
          end;
        end; // While Top - Bottom > 1 do
        if TRealClass(FList.Items[Bottom]).AReal = AReal then
        begin
          result := Bottom;
        end
        else if TRealClass(FList.Items[Top]).AReal = AReal then
        begin
          result := Top;
        end
        else if Abs(TRealClass(FList.Items[Bottom]).AReal - AReal) <
          Abs(TRealClass(FList.Items[Top]).AReal - AReal) then
        begin
          result := Bottom;
        end
        else
        begin
          result := Top;
        end;
      end;
    end;
  end
  else
  begin
    if FList.Count = 0 then
    begin
      result := -1;
    end
    else
    begin
      result := 0;
      MinDistance := Abs(TRealClass(FList.Items[0]).AReal - AReal);
      for Index := 1 to FList.Count -1 do
      begin
        Test := Abs(TRealClass(FList.Items[Index]).AReal - AReal);
        if Test < MinDistance then
        begin
          result := Index;
          MinDistance := Test;
        end;
      end;
    end;
  end;
end;

end.

