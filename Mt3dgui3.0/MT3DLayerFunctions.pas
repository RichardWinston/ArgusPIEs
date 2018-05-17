unit MT3DLayerFunctions;

interface

uses SysUtils, AnePIE;

procedure GetMT3D_TRPT (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMT3D_TRPV (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMT3D_DMCOEF (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMT3D_RHOB (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMT3D_SP1 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMT3D_SP2 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMT3D_RC1 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMT3D_RC2 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses Variables, MT3DFormUnit, ParamArrayUnit, ANE_LayerUnit, ArgusFormUnit;

procedure GetMT3D_TRPT (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AUnit : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle) as ModflowTypes.GetModflowFormType;

  param := @parameters^;
  param1_ptr :=  param^[0];
  AUnit :=  param1_ptr^;
//type MT3DDispersionData = (ddmN, ddmName, ddmHorDisp,ddmVertDisp, ddmMolDiffCoef);

  result := StrToFloat(frmMODFLOW.sgDispersion.Cells[Ord(ddmHorDisp),AUnit]);

  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GetMT3D_TRPV (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AUnit : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle) as ModflowTypes.GetModflowFormType;

  param := @parameters^;
  param1_ptr :=  param^[0];
  AUnit :=  param1_ptr^;
//type MT3DDispersionData = (ddmN, ddmName, ddmHorDisp,ddmVertDisp, ddmMolDiffCoef);

  result := StrToFloat(frmMODFLOW.sgDispersion.Cells[Ord(ddmVertDisp),AUnit]);

  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GetMT3D_DMCOEF (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AUnit : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle) as ModflowTypes.GetModflowFormType;

  param := @parameters^;
  param1_ptr :=  param^[0];
  AUnit :=  param1_ptr^;
//type MT3DDispersionData = (ddmN, ddmName, ddmHorDisp,ddmVertDisp, ddmMolDiffCoef);

  result := StrToFloat(frmMODFLOW.sgDispersion.Cells[Ord(ddmMolDiffCoef),AUnit]);

  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GetMT3D_RHOB (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AUnit : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle) as ModflowTypes.GetModflowFormType;

  param := @parameters^;
  param1_ptr :=  param^[0];
  AUnit :=  param1_ptr^;
//type MT3DReactionData = (rdmN, rdmName, rdmBulkDensity,rdmSorpConst1,
//     rdmSorpConst2, rdmRateConstDiss, rdmRateConstSorp);

  result := StrToFloat(frmMODFLOW.sgReaction.Cells[Ord(rdmBulkDensity),AUnit]);

  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GetMT3D_SP1 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AUnit : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle) as ModflowTypes.GetModflowFormType;

  param := @parameters^;
  param1_ptr :=  param^[0];
  AUnit :=  param1_ptr^;
//type MT3DReactionData = (rdmN, rdmName, rdmBulkDensity,rdmSorpConst1,
//     rdmSorpConst2, rdmRateConstDiss, rdmRateConstSorp);

  result := StrToFloat(frmMODFLOW.sgReaction.Cells[Ord(rdmSorpConst1),AUnit]);

  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GetMT3D_SP2 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AUnit : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle) as ModflowTypes.GetModflowFormType;

  param := @parameters^;
  param1_ptr :=  param^[0];
  AUnit :=  param1_ptr^;
//type MT3DReactionData = (rdmN, rdmName, rdmBulkDensity,rdmSorpConst1,
//     rdmSorpConst2, rdmRateConstDiss, rdmRateConstSorp);

  result := StrToFloat(frmMODFLOW.sgReaction.Cells[Ord(rdmSorpConst2),AUnit]);

  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GetMT3D_RC1 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AUnit : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle) as ModflowTypes.GetModflowFormType;

  param := @parameters^;
  param1_ptr :=  param^[0];
  AUnit :=  param1_ptr^;
//type MT3DReactionData = (rdmN, rdmName, rdmBulkDensity,rdmSorpConst1,
//     rdmSorpConst2, rdmRateConstDiss, rdmRateConstSorp);

  result := StrToFloat(frmMODFLOW.sgReaction.Cells[Ord(rdmRateConstDiss),AUnit]);

  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GetMT3D_RC2 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AUnit : ANE_INT32;
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle) as ModflowTypes.GetModflowFormType;

  param := @parameters^;
  param1_ptr :=  param^[0];
  AUnit :=  param1_ptr^;
//type MT3DReactionData = (rdmN, rdmName, rdmBulkDensity,rdmSorpConst1,
//     rdmSorpConst2, rdmRateConstDiss, rdmRateConstSorp);

  result := StrToFloat(frmMODFLOW.sgReaction.Cells[Ord(rdmRateConstSorp),AUnit]);

  ANE_DOUBLE_PTR(reply)^ := result;
end;

end.
