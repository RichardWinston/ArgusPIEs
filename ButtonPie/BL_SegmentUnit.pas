unit BL_SegmentUnit;

interface

uses classes, SysUtils, ANEPIE;

function GGetSegmentCount(ListIndex, CellIndex : ANE_INT32): ANE_INT32;

procedure GGetSegmentCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellSegmentFirstVertexXPos(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;

procedure GGetCellSegmentFirstVertexXPosMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellSegmentFirstVertexYPos(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;

procedure GGetCellSegmentFirstVertexYPosMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellSegmentSecondVertexXPos(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;
  
procedure GGetCellSegmentSecondVertexXPosMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellSegmentSecondVertexYPos(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;
  
procedure GGetCellSegmentSecondVertexYPosMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellSegmentXLength(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;

procedure GGetCellSegmentXLengthMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellSegmentYLength(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;

procedure GGetCellSegmentYLengthMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellSegmentLength(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;

procedure GGetCellSegmentLengthMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellSumSegmentXLength(ListIndex, CellIndex : ANE_INT32) : ANE_DOUBLE;

procedure GGetCellSumSegmentXLengthMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellSumSegmentYLength(ListIndex, CellIndex : ANE_INT32) : ANE_DOUBLE;

procedure GGetCellSumSegmentYLengthMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellSumSegmentLength(ListIndex, CellIndex : ANE_INT32) : ANE_DOUBLE;

procedure GGetCellSumSegmentLengthMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses BlockListUnit, CellVertexUnit;

function GGetSegmentCount(ListIndex, CellIndex : ANE_INT32): ANE_INT32;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.SegmentList.Count;
end;

procedure GGetSegmentCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
      result := GGetSegmentCount(ListIndex, CellIndex);
    end;
  Except on Exception do
    begin
        Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCellSegmentFirstVertexXPos(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.SegmentFirstVertexXPos(SegmentIndex);
end;

procedure GGetCellSegmentFirstVertexXPosMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  param3_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  CellIndex : ANE_INT32;          // position in list of item .
  SegmentIndex : ANE_INT32;
  param : PParameter_array;
//  AVertex : TVertex;

begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      CellIndex :=  param2_ptr^;
      param3_ptr :=  param^[2];
      SegmentIndex :=  param3_ptr^;
      result := GGetCellSegmentFirstVertexXPos(ListIndex, CellIndex,
        SegmentIndex);
    end;
  Except on Exception do
    begin
        Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetCellSegmentFirstVertexYPos(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.SegmentFirstVertexYPos(SegmentIndex);
end;

procedure GGetCellSegmentFirstVertexYPosMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  param3_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  CellIndex : ANE_INT32;          // position in list of item .
  SegmentIndex : ANE_INT32;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      CellIndex :=  param2_ptr^;
      param3_ptr :=  param^[2];
      SegmentIndex :=  param3_ptr^;
      result := GGetCellSegmentFirstVertexYPos(ListIndex, CellIndex,
        SegmentIndex);

    end;
  Except on Exception do
    begin
        Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetCellSegmentSecondVertexXPos(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.SegmentSecondVertexXPos(SegmentIndex);
end;

procedure GGetCellSegmentSecondVertexXPosMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  param3_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  CellIndex : ANE_INT32;          // position in list of item .
  SegmentIndex : ANE_INT32;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      CellIndex :=  param2_ptr^;
      param3_ptr :=  param^[2];
      SegmentIndex :=  param3_ptr^;
      result := GGetCellSegmentSecondVertexXPos(ListIndex, CellIndex,
        SegmentIndex);
    end;
  Except on Exception do
    begin
        Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetCellSegmentSecondVertexYPos(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.SegmentSecondVertexYPos(SegmentIndex);
end;

procedure GGetCellSegmentSecondVertexYPosMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  param3_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  CellIndex : ANE_INT32;          // position in list of item .
  SegmentIndex : ANE_INT32;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      CellIndex :=  param2_ptr^;
      param3_ptr :=  param^[2];
      SegmentIndex :=  param3_ptr^;
      result := GGetCellSegmentSecondVertexYPos(ListIndex, CellIndex,
        SegmentIndex);
    end;
  Except on Exception do
    begin
        Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetCellSegmentXLength(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.SegmentXLength(SegmentIndex);
end;

procedure GGetCellSegmentXLengthMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  param3_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  CellIndex : ANE_INT32;          // position in list of item .
  SegmentIndex : ANE_INT32;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      CellIndex :=  param2_ptr^;
      param3_ptr :=  param^[2];
      SegmentIndex :=  param3_ptr^;
      result := GGetCellSegmentXLength(ListIndex, CellIndex,
        SegmentIndex);

    end;
  Except on Exception do
    begin
        Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetCellSegmentYLength(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.SegmentYLength(SegmentIndex);
end;

procedure GGetCellSegmentYLengthMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  param3_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  CellIndex : ANE_INT32;          // position in list of item .
  SegmentIndex : ANE_INT32;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      CellIndex :=  param2_ptr^;
      param3_ptr :=  param^[2];
      SegmentIndex :=  param3_ptr^;
      result := GGetCellSegmentYLength(ListIndex, CellIndex,
        SegmentIndex );

    end;
  Except on Exception do
    begin
        Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetCellSegmentLength(ListIndex, CellIndex,
  SegmentIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.SegmentLength(SegmentIndex);
end;

procedure GGetCellSegmentLengthMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  param3_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  CellIndex : ANE_INT32;          // position in list of item .
  SegmentIndex : ANE_INT32;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      CellIndex :=  param2_ptr^;
      param3_ptr :=  param^[2];
      SegmentIndex :=  param3_ptr^;
      result := GGetCellSegmentLength(ListIndex, CellIndex,
        SegmentIndex);
    end;
  Except on Exception do
    begin
        Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetCellSumSegmentXLength(ListIndex, CellIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.SumSegmentXLength;
end;

procedure GGetCellSumSegmentXLengthMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
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
      result := GGetCellSumSegmentXLength(ListIndex, CellIndex);

    end;
  Except on Exception do
    begin
        Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetCellSumSegmentYLength(ListIndex, CellIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.SumSegmentYLength;
end;

procedure GGetCellSumSegmentYLengthMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
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
      result := GGetCellSumSegmentYLength(ListIndex, CellIndex);

    end;
  Except on Exception do
    begin
        Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetCellSumSegmentLength(ListIndex, CellIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.SumSegmentLength;
end;

procedure GGetCellSumSegmentLengthMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
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
      result := GGetCellSumSegmentLength(ListIndex, CellIndex);

    end;
  Except on Exception do
    begin
        Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;



end.
