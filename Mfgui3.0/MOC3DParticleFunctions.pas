unit MOC3DParticleFunctions;

interface

{MOC3DParticleFunctions defines PIE functions that return the initial position
 within a cell of particles when custom particle placement is selected. }

uses SysUtils, Dialogs, AnePIE;

procedure GetParticleLayerPosition (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetParticleRowPosition (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetParticleColumnPosition (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses Variables, ModflowUnit, ParamArrayUnit, ANE_LayerUnit, ANECB, ArgusFormUnit;

procedure GetParticleLayerPosition (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AParticle : ANE_INT32;
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
      AParticle :=  param1_ptr^;

      result := StrToFloat(frmMODFLOW.sgMOC3DParticles.Cells[Ord(pdLayer)
        ,AParticle]);

      ANE_DOUBLE_PTR(reply)^ := result;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetParticleRowPosition (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AParticle : ANE_INT32;
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
      AParticle :=  param1_ptr^;

      result := StrToFloat(frmMODFLOW.sgMOC3DParticles.Cells[Ord(pdRow),AParticle]);

      ANE_DOUBLE_PTR(reply)^ := result;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GetParticleColumnPosition (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  AParticle : ANE_INT32;
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
      AParticle :=  param1_ptr^;

      result := StrToFloat(frmMODFLOW.sgMOC3DParticles.Cells[Ord(pdColumn)
        ,AParticle]);

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
