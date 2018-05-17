unit MT3DTimeFunctions;

interface

uses SysUtils, AnePIE;

procedure GetMT3D_DTO (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMT3D_MXSTRN (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMT3D_TIMPRS (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses
  ParamArrayUnit, Variables, ArgusFormUnit, MT3DFormUnit;

procedure GetMT3D_DTO  (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  APeriod : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin

  frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle) as ModflowTypes.GetModflowFormType;
{  ANE_GetPIEProjectHandle(funHandle, @frmMODFLOW );
  frmMODFLOW.CurrentModelHandle := funHandle;  }
//type MT3DTimeData = (tdmN, tdmLength, tdmStepSize,tdmMaxSteps, tdmCalculated);

  param := @parameters^;
  param1_ptr :=  param^[0];
  APeriod :=  param1_ptr^;

  If frmMODFLOW.sgMT3DTime.Cells[Ord(tdmCalculated),APeriod] = 'Yes'
  then
    begin
      result := 0
    end
  else
    begin
      result := StrToFloat(frmMODFLOW.sgMT3DTime.Cells[Ord(tdmStepSize),APeriod]);
    end;

  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GetMT3D_MXSTRN  (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  APeriod : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin

  frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle) as ModflowTypes.GetModflowFormType;
{  ANE_GetPIEProjectHandle(funHandle, @frmMODFLOW );
  frmMODFLOW.CurrentModelHandle := funHandle;  }
//type MT3DTimeData = (tdmN, tdmLength, tdmStepSize,tdmMaxSteps, tdmCalculated);

  param := @parameters^;
  param1_ptr :=  param^[0];
  APeriod :=  param1_ptr^;

  result := StrToiNT(frmMODFLOW.sgMT3DTime.Cells[Ord(tdmMaxSteps),APeriod]);

  ANE_INT32_PTR(reply)^ := result;
end;

procedure GetMT3D_TIMPRS  (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  APeriod : ANE_INT32;
  result : ANE_INT32;
  param : PParameter_array;
begin

  frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle) as ModflowTypes.GetModflowFormType;
{  ANE_GetPIEProjectHandle(funHandle, @frmMODFLOW );
  frmMODFLOW.CurrentModelHandle := funHandle;  }
//type MT3DPrintoutTimes = (ptmN, ptmTime);


  param := @parameters^;
  param1_ptr :=  param^[0];
  APeriod :=  param1_ptr^;

  result := StrToiNT(frmMODFLOW.sgPrintoutTimes.Cells[Ord(ptmTime),APeriod]);

  ANE_INT32_PTR(reply)^ := result;
end;

end.
