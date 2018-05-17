unit GridUnit;

interface

uses ANEPIE, SysUtils;

function GGetRowBoundaryCount: ANE_INT32;

procedure GGetRowBoundaryCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetColumnBoundaryCount : ANE_INT32;

procedure GGetColumnBoundaryCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetRowNodeCount : ANE_INT32;

procedure GGetRowNodeCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetColumnNodeCount : ANE_INT32;

procedure GGetColumnNodeCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetRowBoundaryPosition (Row : ANE_INT32): ANE_DOUBLE;

procedure GGetRowBoundaryPositionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetColumnBoundaryPosition (Column : ANE_INT32): ANE_DOUBLE;

procedure GGetColumnBoundaryPositionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetRowNodePosition (Row : ANE_INT32): ANE_DOUBLE;

procedure GGetRowNodePositionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetColumnNodePosition (Column : ANE_INT32): ANE_DOUBLE;

procedure GGetColumnNodePositionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GGetCellArea (Column, Row : ANE_INT32): ANE_DOUBLE;

procedure GGetCellAreaMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses BlockListUnit;

function GGetRowBoundaryCount: ANE_INT32;
begin
  result := RowList.Count;
end;

procedure GGetRowBoundaryCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
      result := GGetRowBoundaryCount;
    end
  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := -1;
      end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetColumnBoundaryCount : ANE_INT32;
begin
  result := ColumnList.Count;
end;

procedure GGetColumnBoundaryCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
      result := GGetColumnBoundaryCount;
    end
  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := 0;
      end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetRowNodeCount : ANE_INT32;
begin
  result := RowMiddleList.Count;
end;

procedure GGetRowNodeCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
      result := GGetRowNodeCount;
    end
  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := 0;
      end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetColumnNodeCount : ANE_INT32;
begin
  result := ColumnMiddleList.Count;
end;

procedure GGetColumnNodeCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
      result := GGetColumnNodeCount;
    end
  except
    on Exception do
      begin
        result := 0;
      end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetRowBoundaryPosition (Row : ANE_INT32): ANE_DOUBLE;
begin
  result := RowList[Row];
end;

procedure GGetRowBoundaryPositionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  Row : ANE_INT32;          // position in list of item .
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      Row :=  param1_ptr^;
      result := GGetRowBoundaryPosition (Row);
    end
  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := 0;
      end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetColumnBoundaryPosition (Column : ANE_INT32): ANE_DOUBLE;
begin
  result := ColumnList[Column];
end;

procedure GGetColumnBoundaryPositionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  Column : ANE_INT32;          // position in list of item .
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      Column :=  param1_ptr^;
      result := GGetColumnBoundaryPosition (Column);
    end
  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := 0;
      end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetRowNodePosition (Row : ANE_INT32): ANE_DOUBLE;
begin
  result := RowMiddleList.Items[Row];
end;

procedure GGetRowNodePositionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  Row : ANE_INT32;          // position in list of item .
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      Row :=  param1_ptr^;
      result := GGetRowNodePosition (Row);
    end
  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := 0;
      end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetColumnNodePosition (Column : ANE_INT32): ANE_DOUBLE;
begin
  result := ColumnMiddleList.Items[Column];
end;

procedure GGetColumnNodePositionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  Column : ANE_INT32;          // position in list of item .
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      Column :=  param1_ptr^;
      result := GGetColumnNodePosition (Column);
    end
  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := 0;
      end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


function GGetCellArea (Column, Row : ANE_INT32): ANE_DOUBLE;
var
  AReal, AnotherReal : double;
begin
  AReal := ColumnList[Column];
  AnotherReal := ColumnList[Column-1];
  result := AReal-AnotherReal;
  AReal := RowList[Row];
  AnotherReal := RowList[Row-1];
  result := Abs(result*(AReal-AnotherReal));
end;

procedure GGetCellAreaMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  Column : ANE_INT32;          // position in list of item .
  param2_ptr : ANE_INT32_PTR;
  Row : ANE_INT32;          // position in list of item .
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      Column :=  param1_ptr^;
      param2_ptr :=  param^[1];
      Row :=  param2_ptr^;
      result := GGetCellArea (Column, Row );
    end
  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := 0;
      end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

end.
