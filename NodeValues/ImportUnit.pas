unit ImportUnit;

// Save TD32 information and used Turbo debugger to debug.
// Click F3 and enter the name of your dll.
// After Argus ONE has started attach to ArgusONE.dll.
// From the File menu change to the directory with the source code of the PIE.
// Click F3 and double click on your dll
// Click F3 again and loadthe source files.
// You can now set breakpoints in the dll.

interface

uses
  SysUtils, Dialogs, Forms, Controls,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, FunctionPIE ;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;


implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, OptionsUnit, Unit1, ParamNamesAndTypes, ParamArrayUnit;


//  kMaxFunDesc is the maximum number of PIE's in the dll
const kMaxFunDesc = 1;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts
   gDelphiPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gDelphiPIEFunctionPIEDesc : FunctionPIEDesc;                // ImportPIE descriptor


// This reads an integer from the begining of a string and returns
//the integer and the string with the integer removed.
// This procedure is untested.

// import data from a text file.
procedure GDelphiPIE(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  param3_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param : PParameter_array;
  LayerName : ANE_STR;
  ParameterName: ANE_STR;
  ParameterIndex : ANE_INT16;
  NodeIndex : ANE_INT32;
  Layer: TLayerOptions;
  Project : TProjectOptions;
  LayerHandle : ANE_PTR;
  Node : TNodeObjectOptions;
  Result : ANE_DOUBLE;
begin
  result := 0;
  try
    param := @parameters^;
    LayerName :=  param^[0];
    ParameterName :=  param^[1];
    param3_ptr :=  param^[2];
    NodeIndex :=  param3_ptr^ -1;
    Project := TProjectOptions.Create;
    try
      LayerHandle := Project.GetLayerByName(funHandle,LayerName);
    finally
      Project.Free;
    end;
    if LayerHandle = nil then
    begin
      Beep;
      ShowMessage('Layer "' + String(LayerName) + '" not found.');
    end
    else
    begin
      Layer := TLayerOptions.Create(LayerHandle);
      try
        ParameterIndex := Layer.GetParameterIndex(funHandle,ParameterName);
      finally
        Layer.Free(funHandle);
      end;
      if (ParameterIndex = -1) then
      begin
        Beep;
        ShowMessage('parameter "' + String(ParameterName) + '" not found.');
      end
      else
      begin
        Node := TNodeObjectOptions.Create(funHandle,LayerHandle,NodeIndex);
        try
          result := Node.GetFloatParameter(funHandle,ParameterIndex);
        finally
          Node.Free;
        end;

      end;
    end;

  except
    On E: Exception do
    begin
      Beep;
      ShowMessage(E.Message);
    end;
  end;

  ANE_DOUBLE_PTR(reply)^ := result;


end;

{procedure GetMorphedNodeValue (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_DOUBLE;
  NodeIndex : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param : PParameter_array;
  Expression : ANE_STR;
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

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;

      param := @parameters^;
      param1_ptr :=  param^[0];
      NodeIndex :=  param1_ptr^ -1;
      NodeIndex := frmSutra.VirtualMesh.NodeNumberToNodeIndex(NodeIndex);

      Expression := param^[1];

      result := frmSutra.GetMorphedNodeValue(NodeIndex, string(Expression)) ;
      ANE_DOUBLE_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;   }


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;
	gDelphiPIEFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
	gDelphiPIEFunctionPIEDesc.name := 'NodeValue';   // name of project
        gDelphiPIEFunctionPIEDesc.address := @GDelphiPIE;
        gDelphiPIEFunctionPIEDesc.returnType := kPIEFloat;
        gDelphiPIEFunctionPIEDesc.numParams := 3;
        gDelphiPIEFunctionPIEDesc.numOptParams := 0;
        gDelphiPIEFunctionPIEDesc.paramNames := @gpnLayerParameterNode;
        gDelphiPIEFunctionPIEDesc.paramTypes := @g2String2IntegerTypes;

	//
	// prepare PIE descriptor for Example Delphi PIE

	gDelphiPIEDesc.name := 'NodeValue';      // PIE name
	gDelphiPIEDesc.PieType := kFunctionPIE;                   // PIE type: project PIE
	gDelphiPIEDesc.descriptor := @gDelphiPIEFunctionPIEDesc;	// pointer to descriptor

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gDelphiPIEDesc;
        Inc(numNames);	// add descriptor to list

	descriptors := @gFunDesc;
end;



end.
 