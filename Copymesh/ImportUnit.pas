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
  SysUtils, // Dialogs, Controls,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE ;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

procedure GCopyMeshPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, OptionsUnit;


//  kMaxFunDesc is the maximum number of PIE's in the dll
const kMaxFunDesc = 2;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts

   gCopyTriMeshPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gCopyTriMeshImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gCopyQuadMeshPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gCopyQuadMeshImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

//   gtestPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
//   gtestImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor


procedure GCopyMeshPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  CurrentLayerHandle : ANE_PTR;
  CurrentLayerOptions, FromLayerOptions : TLayerOptions;
begin
  CurrentLayerHandle := ANE_LayerGetCurrent(aneHandle);
  CurrentLayerOptions := TLayerOptions.Create(CurrentLayerHandle);
  FromLayerOptions := TLayerOptions.Create(layerHandle);
  try
    CurrentLayerOptions.Text[aneHandle] := FromLayerOptions.Text[aneHandle];
  finally
    CurrentLayerOptions.Free(aneHandle);
    FromLayerOptions.Free(aneHandle);
  end;
end;

{procedure GTestPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  CurrentLayerHandle : ANE_PTR;
  CurrentLayerOptions, FromLayerOptions : TLayerOptions;
  NodeOptions : TNodeObjectOptions;
  AValue : integer;
//  X,Y : ANE_DOUBLE;
begin
  CurrentLayerHandle := ANE_LayerGetCurrent(aneHandle);
  CurrentLayerOptions := TLayerOptions.Create(aneHandle,CurrentLayerHandle);
  FromLayerOptions := TLayerOptions.Create(aneHandle,layerHandle);
  try
    NodeOptions := TNodeObjectOptions.Create(aneHandle, layerHandle,0);
    try
      AValue := NodeOptions.GetIntegerParameter(1);
      ShowMessage(IntToStr(AValue));
      ShowMessage(NodeOptions.GetStringParameter(0));
    finally
      NodeOptions.Free;
    end;

    CurrentLayerOptions.Text := FromLayerOptions.Text;
  finally
    CurrentLayerOptions.Free;
    FromLayerOptions.Free;
  end;
end; }


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

	gCopyTriMeshImportPIEDesc.version := IMPORT_PIE_VERSION;
	gCopyTriMeshImportPIEDesc.name := 'Copy Tri Mesh';   // name of project
	gCopyTriMeshImportPIEDesc.importFlags := kImportFromLayer;
 	gCopyTriMeshImportPIEDesc.fromLayerTypes := kPIETriMeshLayer;
 	gCopyTriMeshImportPIEDesc.toLayerTypes := kPIETriMeshLayer;
 	gCopyTriMeshImportPIEDesc.doImportProc := @GCopyMeshPIE;// address of Post Processing Function function

	// prepare PIE descriptor for tri mesh PIE

	gCopyTriMeshPIEDesc.name := 'Copy Tri Mesh';      // PIE name
	gCopyTriMeshPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gCopyTriMeshPIEDesc.descriptor := @gCopyTriMeshImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gCopyTriMeshPIEDesc;
        Inc(numNames);	// add descriptor to list

	gCopyQuadMeshImportPIEDesc.version := IMPORT_PIE_VERSION;
	gCopyQuadMeshImportPIEDesc.name := 'Copy Quad Mesh';   // name of project
	gCopyQuadMeshImportPIEDesc.importFlags := kImportFromLayer;
 	gCopyQuadMeshImportPIEDesc.fromLayerTypes := kPIEQuadMeshLayer;
 	gCopyQuadMeshImportPIEDesc.toLayerTypes := kPIEQuadMeshLayer;
 	gCopyQuadMeshImportPIEDesc.doImportProc := @GCopyMeshPIE;// address of Post Processing Function function

	// prepare PIE descriptor for quad mesh PIE

	gCopyQuadMeshPIEDesc.name := 'Copy Quad Mesh';      // PIE name
	gCopyQuadMeshPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gCopyQuadMeshPIEDesc.descriptor := @gCopyQuadMeshImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gCopyQuadMeshPIEDesc;
        Inc(numNames);	// add descriptor to list

{	gtestImportPIEDesc.version := IMPORT_PIE_VERSION;
	gtestImportPIEDesc.name := 'test node options';   // name of project
	gtestImportPIEDesc.importFlags := kImportFromLayer;
 	gtestImportPIEDesc.fromLayerTypes := kPIEQuadMeshLayer;
 	gtestImportPIEDesc.toLayerTypes := kPIEQuadMeshLayer;
 	gtestImportPIEDesc.doImportProc := @GTestPIE;// address of Post Processing Function function

	// prepare PIE descriptor for quad mesh PIE

	gtestPIEDesc.name := 'test node options';      // PIE name
	gtestPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gtestPIEDesc.descriptor := @gtestImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gtestPIEDesc;
        Inc(numNames);	// add descriptor to list   }

	descriptors := @gFunDesc;
end;



end.
 