unit WellFunctionsUnit;

interface

uses AnePIE, SysUtils;

procedure GHST3D_WellCompletionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_WellSkinFactorMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_WellTimeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_WellFlowMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_WellSurfPresMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_WellDatumMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_WellTempMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_WellMassFracMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_WellTimeCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_WellElementCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
implementation

uses TimeFunctionsUnit, HST3D_PIE_Unit, HST3DUnit, ANE_LayerUnit, ANECB,
     UtilityFunctions;

procedure GHST3D_WellCompletionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Row : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Row :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data.HST3DForm do
  begin
    result := LocalStrToFloat(sgWellCompletion.Cells[Ord(weCompletion),Row]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_WellSkinFactorMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Row : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Row :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data.HST3DForm do
  begin
    result := LocalStrToFloat(sgWellCompletion.Cells[Ord(weSkinfactor),Row]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_WellTimeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Row : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Row :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data.HST3DForm do
  begin
    result := LocalStrToFloat(sgWellTime.Cells[Ord(wtTime),Row]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_WellFlowMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Row : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Row :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data.HST3DForm do
  begin
    result := LocalStrToFloat(sgWellTime.Cells[Ord(wtFlow),Row]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_WellSurfPresMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Row : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Row :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data.HST3DForm do
  begin
    result := LocalStrToFloat(sgWellTime.Cells[Ord(wtSurfPres),Row]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_WellDatumMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Row : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Row :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data.HST3DForm do
  begin
    result := LocalStrToFloat(sgWellTime.Cells[Ord(wtDatumPres),Row]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_WellTempMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Row : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Row :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data.HST3DForm do
  begin
    result := LocalStrToFloat(sgWellTime.Cells[Ord(wtTemp),Row]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_WellMassFracMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Row : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  Row :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data.HST3DForm do
  begin
    result := LocalStrToFloat(sgWellTime.Cells[Ord(wtMassFrac),Row]);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_WellTimeCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  RowIndex : integer;
  result : ANE_INT32;
begin
  result := 1;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data.HST3DForm do
  begin
    For RowIndex := 2 to sgWellTime.RowCount -1 do
    begin
      if LocalStrToFloat(sgWellTime.Cells[Ord(wtTime),RowIndex]) = 0 then
      begin
        result := RowIndex -1;
        break;
      end
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GHST3D_WellElementCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
begin
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data.HST3DForm do
  begin
      result :=  sgWellCompletion.RowCount -1;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

end.
