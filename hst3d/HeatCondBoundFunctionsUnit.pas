unit HeatCondBoundFunctionsUnit;

interface

uses AnePIE;

procedure GHST3D_HeatBoundNodeLocationMMFun (const refPtX : ANE_DOUBLE_PTR  ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_InitialHeatBoundNodeLocationMMFun
                               (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GHST3D_InitialHeatBoundNodeTemperatureMMFun
                               (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
                                
implementation

uses SolverFunctionsUnit, HST3DUnit, HST3D_PIE_Unit, ANECB, ANE_LayerUnit;

procedure GHST3D_HeatBoundNodeLocationMMFun (const refPtX : ANE_DOUBLE_PTR    ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  ANode : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  ANode :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data do
  begin
    result := HST3DForm.HeatBoundNodeLocation(ANode);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_InitialHeatBoundNodeLocationMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  ANode : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  ANode :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data do
  begin
    result := HST3DForm.InitialHeatBoundNodeLocation(ANode);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GHST3D_InitialHeatBoundNodeTemperatureMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  ANode : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  ANode :=  param1_ptr^;
//  CurrentModelHandle := myHandle;
//  ANE_GetPIEProjectHandle(CurrentModelHandle, @PIE_Data );
  ANE_GetPIEProjectHandle(myHandle, @PIE_Data );
  PIE_Data.HST3DForm.CurrentModelHandle := myHandle;
  with PIE_Data do
  begin
    result := HST3DForm.InitialHeatBoundNodeTemperature(ANode);
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

end.
