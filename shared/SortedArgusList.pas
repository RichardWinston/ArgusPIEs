unit SortedArgusList;

interface

uses Classes, AnePIE;

Type
  TCustomArgusObject = Class(TObject)
  public
    Pointer : ANE_PTR;
  end;

  TSortedArgusObjectList = Class(TList)
  private
    function GetPosition(Item: TCustomArgusObject): Integer;
    function GetItems(Index: Integer): TCustomArgusObject;
    procedure SetItems(Index: Integer; const Value: TCustomArgusObject);
  public
    procedure Sort;
    function Add(Item: TCustomArgusObject): Integer;
    function Extract(Item: TCustomArgusObject): TCustomArgusObject;
    function First: TCustomArgusObject;
    function IndexOf(Ptr: ANE_PTR): Integer;
    procedure Insert(Index: Integer; Item: TCustomArgusObject);
    function Last: TCustomArgusObject;
    function Remove(Item: TCustomArgusObject): Integer;
    property Items[Index: Integer]: TCustomArgusObject read GetItems write SetItems;
  end;

implementation

function MySort(Item1, Item2: Pointer): Integer;
var
  Object1 : TCustomArgusObject;
  Object2 : TCustomArgusObject;
begin
  Object1 := Item1;
  Object2 := Item2;
  if Integer(Object1.Pointer) < Integer(Object2.Pointer) then
  begin
    result := -1
  end
  else if Integer(Object1.Pointer) > Integer(Object2.Pointer) then
  begin
    result := 1
  end
  else
  begin
    result := 0
  end;
end;


{ TSortedArgusObjectList }

function TSortedArgusObjectList.Add(Item: TCustomArgusObject): Integer;
var
  Position : integer;
begin
  Position := GetPosition(Item);
  if (Position >= Count) or (Position < 0) then
  begin
    result := inherited Add(Item);
  end
  else
  begin
    insert(Position, Item);
    result := Position;
  end;

end;

function TSortedArgusObjectList.Extract(
  Item: TCustomArgusObject): TCustomArgusObject;
begin
  result := inherited Extract(Item);
end;

function TSortedArgusObjectList.First: TCustomArgusObject;
begin
  result := inherited First;
end;

function TSortedArgusObjectList.GetItems(
  Index: Integer): TCustomArgusObject;
begin
  result := Inherited Items[Index];
end;

function TSortedArgusObjectList.GetPosition(
  Item: TCustomArgusObject): Integer;
var
  FirstIndex : integer;
  LastIndex : integer;
  ThisIndex : integer;
  ThisObject : TCustomArgusObject;
  SortResult : integer;
begin
  if Count = 0 then
  begin
    result := -1;
  end
  else
  begin
    FirstIndex := 0;
    LastIndex := Count -1;
    ThisIndex := (FirstIndex + LastIndex) div 2;
    ThisObject := Items[ThisIndex];
    while (ThisObject <> Item) and ((LastIndex-FirstIndex) > 1) do
    begin
      case MySort(Item,ThisObject) of
        -1:
          begin
            LastIndex := ThisIndex;
            ThisIndex := (FirstIndex + LastIndex) div 2;
          end;
        0:
          begin
            ThisObject := Items[ThisIndex];
            break;
          end;
        1:
          begin
            FirstIndex := ThisIndex;
            ThisIndex := (FirstIndex + LastIndex) div 2;
          end;
      end;
      ThisObject := Items[ThisIndex];
    end;
    SortResult := MySort(Item,ThisObject);
    if SortResult = 0 then
    begin
      result := ThisIndex;
    end
    else if SortResult < 0 then
    begin
      result := ThisIndex;
    end
    else if SortResult > 0 then
    begin
      Inc (ThisIndex);
      if ThisIndex >= Count then
      begin
        result := ThisIndex;
      end
      else
      begin
        ThisObject := Items[ThisIndex];
        SortResult := MySort(Item,ThisObject);
        if SortResult = 0 then
        begin
          result := ThisIndex;
        end
        else if SortResult < 0 then
        begin
          result := ThisIndex;
        end
        else
        begin
          result := ThisIndex+1;
        end;
      end;
    end;
  end;
end;

function TSortedArgusObjectList.IndexOf(Ptr: ANE_PTR): Integer;
var
  ThisIndex : integer;
  ThisObject : TCustomArgusObject;
begin
  if (Count = 0) or (Ptr = nil) then
  begin
    result := -1;
  end
  else
  begin
    ThisObject := TCustomArgusObject.Create;
    try
      ThisObject.Pointer := Ptr;
      ThisIndex := GetPosition(ThisObject);
      if ThisIndex >= Count then
      begin
        result := -1;
      end
      else if Items[ThisIndex].Pointer = ThisObject.Pointer then
      begin
        result := ThisIndex;
      end
      else
      begin
        result := -1;
      end;
    finally
      ThisObject.Free;
    end;
  end;
end;

procedure TSortedArgusObjectList.Insert(Index: Integer;
  Item: TCustomArgusObject);
begin
  inherited Insert(Index, Item);
end;

function TSortedArgusObjectList.Last: TCustomArgusObject;
begin
  result := inherited Last;
end;

function TSortedArgusObjectList.Remove(Item: TCustomArgusObject): Integer;
begin
  result := inherited Remove(Item);
end;

procedure TSortedArgusObjectList.SetItems(Index: Integer;
  const Value: TCustomArgusObject);
begin
  inherited Items[Index] := Value;
end;

procedure TSortedArgusObjectList.Sort;
begin
  inherited Sort( MySort);
end;

end.
 