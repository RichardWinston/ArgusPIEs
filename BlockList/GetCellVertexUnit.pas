unit GetCellVertexUnit;

interface

uses Classes, SysUtils, ANEPIE;

function GGetCellVertexCount(ListIndex : ANE_INT32; CellIndex : ANE_INT32): ANE_INT32;

procedure GGetCellVertexCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellVertexXPos(ListIndex : ANE_INT32; CellIndex : ANE_INT32;
  VertexIndex : ANE_INT32) : ANE_DOUBLE;

procedure GGetCellVertexXPosMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellVertexYPos(ListIndex : ANE_INT32; CellIndex : ANE_INT32;
  VertexIndex : ANE_INT32) : ANE_DOUBLE;

procedure GGetCellVertexYPosMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;


implementation

uses BlockListUnit, CellVertexUnit;

function GGetCellVertexCount(ListIndex : ANE_INT32; CellIndex : ANE_INT32): ANE_INT32;
var
  AList : TList;
  ACell : TCell;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.VertexList.Count;
end;

procedure GGetCellVertexCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
      result := GGetCellVertexCount(ListIndex, CellIndex);
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCellVertexXPos(ListIndex : ANE_INT32; CellIndex : ANE_INT32;
  VertexIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
  AVertex : TBL_Vertex;
begin
  AList := MainCellList[ListIndex];
  ACell := AList[CellIndex];
  AVertex := ACell.VertexList.Items[VertexIndex];

  result := AVertex.XPos;
end;

procedure GGetCellVertexXPosMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
  VertexIndex : ANE_INT32;
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
      VertexIndex :=  param3_ptr^;

      result := GGetCellVertexXPos(ListIndex, CellIndex, VertexIndex);


    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetCellVertexYPos(ListIndex : ANE_INT32; CellIndex : ANE_INT32;
  VertexIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
  AVertex : TBL_Vertex;
begin
      AList := MainCellList[ListIndex];
      ACell := AList[CellIndex];
      AVertex := ACell.VertexList.Items[VertexIndex];

      result := AVertex.YPos;
end;

procedure GGetCellVertexYPosMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
  VertexIndex : ANE_INT32;
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
      VertexIndex :=  param3_ptr^;

      result := GGetCellVertexYPos(ListIndex, CellIndex, VertexIndex);


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
