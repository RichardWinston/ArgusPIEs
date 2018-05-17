unit MODFLOW_FHBFunctions;

interface

{MODFLOW_FHBFunctions defines a function for return the times associated with
 a flow and head boundary condition.}

uses SysUtils, Dialogs, AnePIE;

procedure GetMF_FHBTime (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses Variables, ModflowUnit, ParamArrayUnit, ANE_LayerUnit, ANECB,
  ArgusFormUnit, UtilityFunctions;

procedure GetMF_FHBTime (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  ATimePeriod : ANE_INT32;
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
      ATimePeriod :=  param1_ptr^;

      result := InternationalStrToFloat(frmMODFLOW.sgFHBTimes.Cells[1,ATimePeriod]);

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
