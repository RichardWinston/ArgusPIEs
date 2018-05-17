unit TimeFunctionsUnit;

interface

uses SysUtils, Dialogs, AnePIE, FunctionPIE;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

procedure GHST3D_AutotsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_DeltimMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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

procedure GHST3D_DctasMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_DtimmnMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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

procedure GHST3D_TimchgMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_MaxSolverTimesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_PrislmMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;


procedure GHST3D_PrikdMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_PriptcMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_PridvMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_PrivelMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_PrigfbMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_PribcfMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_PriwelMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_IprptcMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_ChkptdMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_PricpdMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_SavldoMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_CntmapMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_VecmapMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_PrimapMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses HST3DUnit, HST3D_PIE_Unit, ANECB, ANE_LayerUnit;

procedure GHST3D_AutotsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
  Try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.Autots(Column);
    end;
    ANE_BOOL_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

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
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.Deltim(Column);
    end;
    ANE_DOUBLE_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
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
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.Dptas(Column);
    end;
    ANE_DOUBLE_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
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
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.Dttas(Column);
    end;
    ANE_DOUBLE_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
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
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.Dctas(Column);
    end;
    ANE_DOUBLE_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
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
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.Dtimmn(Column);
    end;
    ANE_DOUBLE_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
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
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.Dtimmx(Column);
    end;
    ANE_DOUBLE_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

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
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.Timchg(Column);
    end;
    ANE_DOUBLE_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_MaxSolverTimesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
begin
  try
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.MaxSolverTimes;
    end;
    ANE_INT32_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_PrislmMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fPrislm(Column);
    end;
    ANE_INT32_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_PrikdMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fPrikd(Column);
    end;
    ANE_INT32_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_PriptcMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fPriptc(Column);
    end;
    ANE_INT32_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_PridvMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fPridv(Column);
    end;
    ANE_INT32_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_PrivelMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fPrivel(Column);
    end;
    ANE_INT32_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_PrigfbMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fPrigfb(Column);
    end;
    ANE_INT32_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_PribcfMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fPribcf(Column);
    end;
    ANE_INT32_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_PriwelMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fPriwel(Column);
    end;
    ANE_INT32_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_IprptcMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fIprptc(Column);
    end;
    ANE_INT32_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_ChkptdMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fChkptd(Column);
    end;
    ANE_BOOL_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_PricpdMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fPricpd(Column);
    end;
    ANE_INT32_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_SavldoMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fSavldo(Column);
    end;
    ANE_BOOL_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_CntmapMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fCntmap(Column);
    end;
    ANE_BOOL_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_VecmapMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fVecmap(Column);
    end;
    ANE_BOOL_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure GHST3D_PrimapMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Column : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    param := @parameters^;
    param1_ptr :=  param^[0];
    Column :=  param1_ptr^;
  //  CurrentModelHandle := myHandle;
  //  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
    ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
    PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
    with PIE_Data do
    begin
      result := HST3DForm.fPrimap(Column);
    end;
    ANE_INT32_PTR(reply)^ := result;
  Except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

end.
