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
  SysUtils, Dialogs,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE ;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, GridUnit;


//  kMaxFunDesc is the maximum number of PIE's in the dll
const kMaxFunDesc = 1;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts
   gGriddedDataDesc  : ANEPIEDesc;	                   // PIE descriptor
   gGriddedDataImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor



procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;
	gGriddedDataImportPIEDesc.version := IMPORT_PIE_VERSION;
	gGriddedDataImportPIEDesc.name := 'Import gridded data';   // name of project
	gGriddedDataImportPIEDesc.importFlags := kImportFromLayer or kImportAllwaysVisible;
 	gGriddedDataImportPIEDesc.fromLayerTypes := kPIEGridLayer {* was kPIETriMeshLayer*/};
 	gGriddedDataImportPIEDesc.toLayerTypes := kPIEAnyLayer {* was kPIETriMeshLayer*/};
 	gGriddedDataImportPIEDesc.doImportProc := @GGridDataPIE;// address of Post Processing Function function

	//
	// prepare PIE descriptor for Example Delphi PIE

	gGriddedDataDesc.name := 'Import gridded data';      // PIE name
	gGriddedDataDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gGriddedDataDesc.descriptor := @gGriddedDataImportPIEDesc;	// pointer to descriptor

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gGriddedDataDesc;
        Inc(numNames);	// add descriptor to list

	descriptors := @gFunDesc;
end;



end.
 