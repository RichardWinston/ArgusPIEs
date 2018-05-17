unit RangeTreeUnit;

interface

uses sysutils, Classes;

type
  TNodePosition = (npLow, npMiddle, npHigh);

  TRange = record
    Min: double;
    Max: double;
  end;

  TRangeArray = array of TRange;

  TPointerArray = array of Pointer;

  TLocationArray = array of double;

  TRbwRangeTree = class;

  ERangeTreeError = class(Exception);

  TRangeNode = class(TObject)
  private
    DataList: TList; // the data for each data point.
    Tree: TRbwRangeTree;
    DataRanges: array of TRangeArray; // the ranges for each data point
    DivideIndex: integer;
    Middle: double;
    Children: array[TNodePosition] of TRangeNode;
    procedure Add(const Ranges: TRangeArray; const Data: Pointer);
    procedure Clear;
    procedure Find(const Location: TLocationArray; const List: TList);
    function Subdivide: boolean;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  {
    @abstract(The purpose of TRbwRangeTree is to allow for an efficient search for data
    that is associated with a range of locations using a particular location
    as the key.)

    A simple example of such a search would be a search for a box.  The box
    has a lower and an upper limit in the X and Y dimensions.
    TRbwRangeTree.Find is an efficient method of finding all the boxes that
    contain a particular X,Y location.

    To do so, you would first Add all the boxes to the TRbwRangeTree and then
    use Find for each box that you wanted to find.  Add is an O(N *Log(N))
    operation. Find is an O(log(N)) operation so using a TRbwRangeTree only
    helpful if multiple Find operations will occur.

    TRbwRangeTree works as follows:

    When a new datum is added, TRbwRangeTree adds it to the private field
    Root which is a TRangeNode.  A TRangeNode may have several children which
    are other TRangeNode's. If Root has children, it picks one and adds it
    to that child with a recursive call to Add. If Root doesn't have children,
    it checks whether it already is storing an even multiple of MaxItemsInLeaf.
    If it does, it attempts to subdivide. If it can subdivide (creating
    children) it calls Add again to add to the children.  Otherwise, it stores
    the data itself.

    When a TRangeNode attempts to subdivide, it finds the midpoint of one of the
    reanges of all its data points.  If at least one of the ranges is entirely
    below or entirely above the midpoint, it subdivides and adds its data to
    its children.  Data points that are entirely below the midpoint are added
    to one child.  Data points that are entirely above the midpoint are added
    to anotherone child.  Data points that include the midpoint are added to
    the remaining child.  This is also how it adds data if it has already
    subdivided except that the midpoint is fixed at the time the TRangeNode
    subdivided.

    If a TRangeNode is unable to subdivide with one of the ranges of all its
    data points, it cycles through all the ranges one until it either finds
    one it can use for subdividing or has tried them all.

    Limitations:

    No rebalancing occurs in TRbwRangeTree so it is a good idea to add the data
    in a random or pseudorandom fashion to avoid long, spindly trees from
    being created.

    TRbwRangeTree uses a recursive algorithm for Add and Find.  It would be
    possible to devise a nonrecursive algorithm and doing so would both
    increase the speed and lessen the possibility of stack overflows.  The
    recursive algorithm has been retained because it is simpler and thus may
    facilitate further development such as implementing some sort of
    rebalancing.

    MaxItemsInLeaf controls the amount of memory used and the speed
    of Add and Find.  In general, as MaxItemsInLeaf increases, memory use and
    speed both decrease.  By default, MaxItemsInLeaf is set to 25.

    The only way to remove items from TRbwRangeTree is to call Clear which
    removes everything from the TRbwRangeTree.
  }
  TRbwRangeTree = class(TComponent)
  private
    Root: TRangeNode;
    FDimensions: integer;
    FMaxItemsInLeaf: integer;
    procedure SetMaxItemsInLeaf(const Value: integer);
  public
    // Use Add to store data in a TRbwRangeTree. Ranges is an array of TRange.
    // Each TRange in Ranges designates a range of locations associated with
    // Data.  Data is the data that is to be stored. Data is not owned by the
    // TRbwRangeTree. The calling program is responsible for destroying the
    // memory associated with Data.
    procedure Add(const Ranges: TRangeArray; const Data: Pointer);
    // Clear removes all items from a TRbwRangeTree.
    procedure Clear;
    // Create creates and instance of TRbwRangeTree.
    constructor Create(AOwner: TComponent); override;
    // See inherited Destroy;
    destructor Destroy; override;
    // Dimensions is the length of Ranges in the first data point Added when
    // the TRbwRangeTree is created or after a call to Clear.
    property Dimensions: integer read FDimensions;
    // Find returns an array of pointers.  Each pointer in the result has
    // added with a range of values that includes Location.  For instance,
    // suppose the only data that was added was a box that extended from
    // (X,Y) = (-0.5,0.1) to (0.4, 7.0).  If Location was [0,0], the result
    // would be an array with length 0, because 0 does not lie within
    // (0.4, 0.7).  However, if Locations as [0,5], the result would be an
    // array of length 1 with the only member of the array being box.  This
    // is because 0 is within (-0.5,0.1) and 5 is within (0.4, 7.0).
    function Find(const Location: TLocationArray): TPointerArray;
    // FindInList is similar to @Link(Find) except that the pointers are
    // added to List instead of being returned as a function result.
    procedure FindInList(const Location: TLocationArray;
      const List: TList);
    // MaxItemsInLeaf controls memory usage and speed. In general, as
    // MaxItemsInLeaf increases, memory use and speed both decrease.
    // By default, MaxItemsInLeaf is set to 25.
    property MaxItemsInLeaf: integer read FMaxItemsInLeaf write
      SetMaxItemsInLeaf;
  end;

implementation

{ TRangeNode }

procedure TRangeNode.Add(const Ranges: TRangeArray; const Data: Pointer);
var
  Range: TRange;
begin
  if Children[npLow] <> nil then
  begin
    // The TRangeNode has children. Add to one of the children.
    Range := Ranges[DivideIndex];
    if Range.Max < Middle then
    begin
      Children[npLow].Add(Ranges, Data);
    end
    else if Range.Min > Middle then
    begin
      Children[npHigh].Add(Ranges, Data);
    end
    else
    begin
      Children[npMiddle].Add(Ranges, Data);
    end;
  end
  else
  begin
    // The TRangeNode doesn't have children.
    if (DataList.Count > 0) and (DataList.Count mod Tree.MaxItemsInLeaf = 0)
      then
    begin
      // Try to subdivide. If  subdivide succeeds, then add the data to
      // a child and exit.
      if Subdivide then
      begin
        Add(Ranges, Data);
        Exit;
      end;
    end;
    // Either Subdivide failed or it isn't time to subdivide.
    // Store data in node.
    if DataList.Count = DataList.Capacity then
    begin
      // If required, increaase the capacity.
      if DataList.Count = 0 then
      begin
        DataList.Capacity := Tree.MaxItemsInLeaf;
      end
      else
      begin
        DataList.Expand;
      end;
      SetLength(DataRanges, DataList.Capacity);
    end;
    // Store the Ranges.
    DataRanges[DataList.Count] := Ranges;
    // Make sure the data stored in DataRanges has a reference count of 1
    // by calling SetLength.
    SetLength(DataRanges[DataList.Count], Length(Ranges));
    // Store the data.
    DataList.Add(Data);
  end;
end;

procedure TRangeNode.Clear;
var
  Index: TNodePosition;
begin
  for Index := Low(TNodePosition) to High(TNodePosition) do
  begin
    Children[Index].Free;
    Children[Index] := nil;
  end;
  DataList.Clear;
  SetLength(DataRanges, 0);
end;

constructor TRangeNode.Create;
begin
  DataList := TList.Create;
end;

destructor TRangeNode.Destroy;
begin
  Clear;
  DataList.Free;
  inherited;
end;

procedure TRangeNode.Find(const Location: TLocationArray; const List: TList);
var
  X: double;
  DataIndex: integer;
  RangeIndex: integer;
  DataRange: TRangeArray;
  Range: TRange;
  ShouldAddToList: boolean;
begin
  DataRange := nil;
  if Children[npLow] <> nil then
  begin
    // Search In children
    X := Location[DivideIndex];
    if X < Middle then
    begin
      Children[npLow].Find(Location, List);
    end
    else if X > Middle then
    begin
      Children[npHigh].Find(Location, List);
    end;
    Children[npMiddle].Find(Location, List);
  end
  else
  begin
    // There are no children so search the TRangeNode's own data.
    for DataIndex := 0 to DataList.Count - 1 do
    begin
      ShouldAddToList := True;
      DataRange := DataRanges[DataIndex];
      for RangeIndex := 0 to Length(Location) - 1 do
      begin
        X := Location[RangeIndex];
        Range := DataRange[RangeIndex];
        if (X > Range.Max) or (X < Range.Min) then
        begin
          ShouldAddToList := False;
          break;
        end;
      end;
      if ShouldAddToList then
      begin
        List.Add(DataList[DataIndex]);
      end;
    end;
  end;
end;

// One posible way to change this method would be to compute Middle in each
// iteration of the first loop to DataList.Count and to break if the current
// range was entirely above or below that middle (or the previous middle).
// This was not implemented because there is a danger that this could lead to
// long, spindly trees.
function TRangeNode.Subdivide: boolean;
var
  DataIndex: integer;
  DataRange: TRangeArray;
  Range: TRange;
  NodeRange: TRange;
  PosIndex: TNodePosition;
  OldDivideIndex: integer;
  DivIndex: integer;
begin
  // initialize
  DataRange := nil;
  Middle := 0;
  result := false;
  // store DivideIndex in case it needs to be restored later.
  OldDivideIndex := DivideIndex;
  // loop over Dimensions to find a new DivideIndex.
  for DivIndex := 0 to Tree.Dimensions - 1 do
  begin
    // Loop over data points to find the midpoint of the ranges.
    for DataIndex := 0 to DataList.Count - 1 do
    begin
      DataRange := DataRanges[DataIndex];
      // We only look at the range for the current DivideIndex.
      // DivideIndex is changes at the end of the loop over Tree.Dimensions.
      Range := DataRange[DivideIndex];
      // Update the range of the TRangeNode
      if DataIndex = 0 then
      begin
        NodeRange := Range;
        // In revised version, Middle would be computered here.
      end
      else
      begin
        // In the revised version would be compared to middle here.
        if Range.Min < NodeRange.Min then
        begin
          NodeRange.Min := Range.Min;
        end;
        if Range.Max > NodeRange.Max then
        begin
          NodeRange.Max := Range.Max;
        end;
        // In revised version, Middle would be computered here.
        // and then the Range would be compared to middle.
      end;
    end;
    // compute the midpoint of the TRangeNode range.
    Middle := (NodeRange.Max + NodeRange.Min) / 2;
    // Check if at least one of the data points is entirely above or below
    // the midpoint.
    // In the revised version, it would probably be a good idea to include the
    // following loop but there should be a check if result is true before
    // entering it.  If result = true, break out of the outer loop.  
    for DataIndex := 0 to DataList.Count - 1 do
    begin
      DataRange := DataRanges[DataIndex];
      Range := DataRange[DivideIndex];
      if (Middle > Range.Max) or (Middle < Range.Min) then
      begin
        // at least one of the data points is entirely above or below
        // the midpoint so it will be possible to subdivide.
        result := True;
        break;
      end;
    end;
    if result then
    begin
      break;
    end
    else
    begin
      // try the next DivideIndex.
      Inc(DivideIndex);
      if DivideIndex = Tree.Dimensions then
      begin
        DivideIndex := 0;
      end;
    end;
  end;
  if result then
  begin
    // Now we actually create the children.
    for PosIndex := Low(TNodePosition) to High(TNodePosition) do
    begin
      Children[PosIndex] := TRangeNode.Create;
      Children[PosIndex].DivideIndex := DivideIndex;
      Children[PosIndex].Tree := Tree;
    end;
    // We store all the data in the childgen.
    for DataIndex := 0 to DataList.Count - 1 do
    begin
      Add(DataRanges[DataIndex], DataList[DataIndex]);
    end;
    // Release the memory used to store the data in the current TRangeNode.
    DataList.Clear;
    SetLength(DataRanges, 0);
  end
  else
  begin
    // Subdivide failed so restore the old DividIndex.
    DivideIndex := OldDivideIndex;
    // After more data points have been added, Subdivide may be called again
    // for the same TRangeNode. Middle will mostly likely have a different
    // value and there will be more data ranges compared to Middle,
    // so Subdivide may succeed the next time.
  end;
end;

{ TRbwRangeTree }

procedure TRbwRangeTree.Add(const Ranges: TRangeArray;
  const Data: Pointer);
var
  Index: integer;
  Range: TRange;
begin
  if FDimensions = 0 then
  begin
    FDimensions := Length(Ranges);
    if FDimensions = 0 then
    begin
      raise ERangeTreeError.Create('Invalid dimensions detected when adding '
        + 'data to TRbwRangeTree.');
    end;
  end
  else if FDimensions <> Length(Ranges) then
  begin
    raise ERangeTreeError.Create('Invalid dimensions detected when adding '
      + 'data to TRbwRangeTree.');
  end;

  for Index := 0 to Length(Ranges) - 1 do
  begin
    Range := Ranges[Index];
    if Range.Min > Range.Max then
    begin
      raise ERangeTreeError.Create('Invalid range detected when adding '
        + 'data to TRbwRangeTree.  In a valid Range, Range.Min <= Range.Max');
    end;
  end;

  Root.Add(Ranges, Data);
end;

procedure TRbwRangeTree.Clear;
begin
  Root.Clear;
  FDimensions := 0;
end;

constructor TRbwRangeTree.Create(AOwner: TComponent);
begin
  inherited;
  Root := TRangeNode.Create;
  Root.Tree := self;
  MaxItemsInLeaf := 25;
end;

destructor TRbwRangeTree.Destroy;
begin
  Root.Free;
  inherited;
end;

function TRbwRangeTree.Find(const Location: TLocationArray): TPointerArray;
var
  List: TList;
  Index: integer;
begin
  List := TList.Create;
  try
    Root.Find(Location, List);
    setLength(result, List.Count);
    for Index := 0 to List.Count - 1 do
    begin
      result[Index] := List[Index];
    end;
  finally
    List.Free;
  end;
end;

procedure TRbwRangeTree.FindInList(const Location: TLocationArray;
  const List: TList);
begin
  Root.Find(Location, List);
end;

procedure TRbwRangeTree.SetMaxItemsInLeaf(const Value: integer);
begin
  if (Root.Children[npLow] <> nil) or (Root.DataList.Count > 0) then
  begin
    raise ERangeTreeError.Create('Error: You can not set MaxItemsInLeaf in '
      + 'TRbwRangeTree unless the TRbwRangeTree is empty.');
  end;
  if Value <= 1 then
  begin
    raise ERangeTreeError.Create('Error: You can not MaxItemsInLeaf in '
      + 'TRbwRangeTree to a value less than or equal to 1.');
  end;

  // Make sure count = 0;
  FMaxItemsInLeaf := Value;
end;

end.

