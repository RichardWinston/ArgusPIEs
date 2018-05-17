unit GetCellUnit;

interface

uses Classes, SysUtils, ANEPIE;

function GGetCountOfCellLists : ANE_INT32;

procedure GGetCountOfCellListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCountOfACellList(ListIndex : ANE_INT32): ANE_INT32;

procedure GGetCountOfACellListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellRow(ListIndex : ANE_INT32; CellIndex : ANE_INT32): ANE_INT32;

procedure GGetCellRowMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellColumn(ListIndex : ANE_INT32; CellIndex : ANE_INT32): ANE_INT32;
                                
procedure GGetCellColumnMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses BlockListUnit, CellVertexUnit;

function GGetCountOfCellLists : ANE_INT32;
begin
  if not (MainCellList = nil)
  then
    begin
      result := MainCellList.Count;
    end
  else
    begin
      result := 0;
    end;
end;

procedure GGetCountOfCellListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
      result := GGetCountOfCellLists;
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCountOfACellList(ListIndex : ANE_INT32): ANE_INT32;
var
  AList : TList;
begin
  AList := MainCellList[ListIndex];
  result := AList.Count;
end;

procedure GGetCountOfACellListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  param : PParameter_array;

begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      result := GGetCountOfACellList(ListIndex);
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCellRow(ListIndex : ANE_INT32; CellIndex : ANE_INT32): ANE_INT32;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList.Items[ListIndex];
  ACell := AList.Items[CellIndex];
  result := ACell.Row;
end;

procedure GGetCellRowMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  CellIndex : ANE_INT32;          // position in list of item .
  param : PParameter_array;

begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      CellIndex :=  param2_ptr^;
      result := GGetCellRow(ListIndex, CellIndex)

    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;




function GGetCellColumn(ListIndex : ANE_INT32; CellIndex : ANE_INT32): ANE_INT32;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList.Items[ListIndex];
  ACell := AList.Items[CellIndex];
  result := ACell.Column;
end;

procedure GGetCellColumnMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  CellIndex : ANE_INT32;          // position in list of item .
  param : PParameter_array;

begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      CellIndex :=  param2_ptr^;
      result := GGetCellColumn(ListIndex, CellIndex);
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
