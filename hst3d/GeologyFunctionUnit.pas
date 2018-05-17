unit GeologyFunctionUnit;

interface

uses Sysutils, Dialogs, AnePIE;

procedure GHST3D_TopUnitMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_BottomUnitMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_CellTopUnitMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_CellBottomUnitMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_GetZMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
implementation

uses SolverFunctionsUnit, HST3DUnit, HST3D_PIE_Unit, ANECB, ANE_LayerUnit;

procedure GHST3D_TopUnitMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AUnit : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    AUnit :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.TopElevation(AUnit);
    end;
    ANE_DOUBLE_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_BottomUnitMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AUnit : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    AUnit :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.BottomElevation(AUnit);
    end;
    ANE_DOUBLE_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_CellTopUnitMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  ANodeLayer : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    ANodeLayer :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.CellTopElevation(ANodeLayer);
    end;
    ANE_DOUBLE_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_CellBottomUnitMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  ANodeLayer : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    ANodeLayer :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.CellBottomElevation(ANodeLayer);
    end;
    ANE_DOUBLE_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_GetZMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  ANodeLayer : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    ANodeLayer :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.GetZ(ANodeLayer);
    end;
    ANE_DOUBLE_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

end.
