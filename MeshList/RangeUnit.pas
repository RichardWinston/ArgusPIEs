unit RangeUnit;

interface

uses RangeTreeUnit;

var
  NodeRangeTree: TRbwRangeTree;
  ElementRangeTree: TRbwRangeTree;

implementation

initialization
  NodeRangeTree := TRbwRangeTree.Create(nil);
  ElementRangeTree := TRbwRangeTree.Create(nil);

finalization
  NodeRangeTree.Free;
  ElementRangeTree.Free;

end.
