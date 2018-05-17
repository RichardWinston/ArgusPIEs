unit SolverFunctionsUnit;

interface

uses SysUtils, AnePIE, FunctionPIE;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

{procedure GHST3D_AutotsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;}

{procedure GHST3D_DeltimMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_DptasMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_DttasMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

{procedure GHST3D_DctasMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;}

{procedure GHST3D_DtimmnMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_DtimmxMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

{procedure GHST3D_TimchgMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR	         	); cdecl;}

implementation

uses HST3DUnit, HST3D_PIE_Unit, ANE_LayerUnit, ANECB, UtilityFunctions;

{procedure GHST3D_AutotsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_BOOL;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Column :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data do
  begin
    result := (HST3DForm.sgSolver.Cells[Column,Ord(Automatic)] = 'Yes');
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;  }

procedure GHST3D_DeltimMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Column :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data do
  begin
    result := LocalStrToFloat(HST3DForm.sgSolver.Cells[Column,Ord(TimeStepLength)]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_DptasMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Column :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data do
  begin
    result := LocalStrToFloat(HST3DForm.sgSolver.Cells[Column,Ord(MaxChangePres)]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_DttasMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Column :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data do
  begin
    result := LocalStrToFloat(HST3DForm.sgSolver.Cells[Column,Ord(MaxChangeTemp)]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_DctasMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Column :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data do
  begin
    result := LocalStrToFloat(HST3DForm.sgSolver.Cells
      [Column,Ord(MaxChangeMassFrac)]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_DtimmnMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Column :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data do
  begin
    result := LocalStrToFloat(HST3DForm.sgSolver.Cells[Column,Ord(MinTimeStep)]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_DtimmxMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Column :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data do
  begin
    result := LocalStrToFloat(HST3DForm.sgSolver.Cells[Column,Ord(MaxTimeStep)]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;
{
procedure GHST3D_TimchgMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Column :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data do
  begin
    if Column < HST3DForm.sgSolver.ColCount -1
    then
      begin
        result := LocalStrToFloat(HST3DForm.sgSolver.Cells[Column,Ord(StartTime)]);
      end
    else
      begin
        result := LocalStrToFloat(HST3DForm.sgSolver.Cells[Column,Ord(EndTime)]);
      end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;
}

end.
