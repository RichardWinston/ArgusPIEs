unit MOC3DUnitFunctions;

interface

{MOC3DUnitFunctions defines PIE functions that return MOC3D parameters
 associated with geologic units. These include the longitudinal and two
 transverse dispersivities, retardation and CBound.}

uses SysUtils, Dialogs, AnePIE;

procedure GetMOCLongDisp (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMOCTransHorDisp (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMOCTransVerDisp (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMOCRetardation (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMOCCBound (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses Variables, ModflowUnit, ParamArrayUnit, ANE_LayerUnit, ANECB, ArgusFormUnit;

procedure GetMOCLongDisp (const refPtX : ANE_DOUBLE_PTR      ;
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
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
        as ModflowTypes.GetModflowFormType;

      param := @parameters^;
      param1_ptr :=  param^[0];
      AUnit :=  param1_ptr^;

      result := StrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells[Ord(trdLong),AUnit]);

      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetMOCTransHorDisp (const refPtX : ANE_DOUBLE_PTR      ;
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
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
        as ModflowTypes.GetModflowFormType;

      param := @parameters^;
      param1_ptr :=  param^[0];
      AUnit :=  param1_ptr^;

      result := StrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells[Ord(trdTranHor)
        ,AUnit]);

      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetMOCTransVerDisp (const refPtX : ANE_DOUBLE_PTR      ;
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
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
        as ModflowTypes.GetModflowFormType;

      param := @parameters^;
      param1_ptr :=  param^[0];
      AUnit :=  param1_ptr^;

      result := StrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells[Ord(trdTranVer)
        ,AUnit]);

      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetMOCRetardation (const refPtX : ANE_DOUBLE_PTR      ;
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
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
        as ModflowTypes.GetModflowFormType;

      param := @parameters^;
      param1_ptr :=  param^[0];
      AUnit :=  param1_ptr^;

      result := StrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells[Ord(trdRetard)
        ,AUnit]);

      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetMOCCBound (const refPtX : ANE_DOUBLE_PTR      ;
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
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
        as ModflowTypes.GetModflowFormType;

      param := @parameters^;
      param1_ptr :=  param^[0];
      AUnit :=  param1_ptr^;

      result := StrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells[Ord(trdConc),AUnit]);

      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

end.
