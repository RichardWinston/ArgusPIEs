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
  SysUtils, Controls, Dialogs,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE ;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

procedure GDelphiPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, OptionsUnit;


//  kMaxFunDesc is the maximum number of PIE's in the dll
const kMaxFunDesc = 2;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts
   gLockDesc  : ANEPIEDesc;	                   // PIE descriptor
   gLockIPIEDesc : ImportPIEDesc;                // ImportPIE descriptor


// This reads an integer from the begining of a string and returns
//the integer and the string with the integer removed.
// This procedure is untested.
procedure GDelphiPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  Choice : word;
  LayerOptions : TLayerOptions;
  Index : ANE_INT32;
  AParam: TParameterOptions;
begin
  Choice := MessageDlg('Do you want to LOCK the parameters? (Yes to Lock; No to Unlock; Cancel for do nothing.',
    mtInformation, [mbYes, mbNo, mbCancel], 0);
  if (Choice = mrYes) or (Choice = mrNo) then
  begin
    LayerOptions := TLayerOptions.Create(layerHandle);
    try
      for Index := 0 to LayerOptions.NumParameters(aneHandle,pieGeneralSubParam) -1 do
      begin
        AParam := TParameterOptions.Create(layerHandle,Index);
        try
        if Choice = mrYes then
        begin
          AParam.PlusLock[aneHandle] := 'Inhibit Delete';
        end
        else if Choice = mrNo then
        begin
          AParam. MinusLock[aneHandle] := 'Inhibit Delete';
        end;
        finally
          AParam.Free;
        end;
      end;
    finally
      LayerOptions.Free(aneHandle);
    end;
  end;
end;



procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;
	gLockIPIEDesc.version := IMPORT_PIE_VERSION;
	gLockIPIEDesc.name := 'Lock Parameters';   // name of project
	gLockIPIEDesc.importFlags := kImportAllwaysVisible or kImportFromLayer;
 	gLockIPIEDesc.toLayerTypes := kPIEAnyLayer;
 	gLockIPIEDesc.fromLayerTypes := kPIEAnyLayer;
 	gLockIPIEDesc.doImportProc := @GDelphiPIE;// address of Post Processing Function function

	//
	// prepare PIE descriptor for Example Delphi PIE

	gLockDesc.name := 'Lock Parameters';      // PIE name
	gLockDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gLockDesc.descriptor := @gLockIPIEDesc;	// pointer to descriptor

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gLockDesc;
        Inc(numNames);	// add descriptor to list

	descriptors := @gFunDesc;
end;



end.
