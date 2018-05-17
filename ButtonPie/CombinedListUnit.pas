unit CombinedListUnit;

interface

uses Classes, SysUtils, ANEPIE;

var
  CombinedCellList : TList;

function  GGetCountOfCombinedList : ANE_INT32;

procedure GGetCountOfCombinedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellRowFromCombinedList(CellIndex : ANE_INT32): ANE_INT32;

procedure GGetCellRowFromCombinedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GGetCellColumnFromCombinedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses BlockListUnit, CellVertexUnit;

// The combined cell list is a list of all the cells that are intersected
// by objects. If a cell is intersected by two objects, only one version
// of that cell will appear in the combined cell list.
// GGetCountOfCombinedListMMFun returns the number of cells in the
// combined cell list.
function  GGetCountOfCombinedList : ANE_INT32;
begin
  result := CombinedCellList.Count;
end;

procedure GGetCountOfCombinedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;

begin
  try
    begin
      result := GGetCountOfCombinedList;
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCellRowFromCombinedList(CellIndex : ANE_INT32): ANE_INT32;
var
  ACell : TCell;
begin
  ACell := CombinedCellList[CellIndex];
  result := ACell.Row;
end;

// GGetCellRowFromCombinedListMMFun returns the row of the cell indicated
// by CellIndex from the combined cell list.
procedure GGetCellRowFromCombinedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  CellIndex : ANE_INT32;          // position in list of item .
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      CellIndex :=  param1_ptr^;
      result := GGetCellRowFromCombinedList(CellIndex);
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

// GGetCellColumnFromCombinedListMMFun returns the column of the cell indicated
// by CellIndex from the combined cell list.
function GGetCellColumnFromCombinedList(CellIndex : ANE_INT32) : ANE_INT32;
var
  ACell : TCell;
begin
  ACell := CombinedCellList[CellIndex];
  result := ACell.Column
end;

procedure GGetCellColumnFromCombinedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  CellIndex : ANE_INT32;          // position in list of item .
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      CellIndex :=  param1_ptr^;
      result := GGetCellColumnFromCombinedList(CellIndex);
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

end.
