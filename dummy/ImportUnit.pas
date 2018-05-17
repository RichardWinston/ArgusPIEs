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

procedure GDelphiPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB;


//  kMaxFunDesc is the maximum number of PIE's in the dll
const kMaxFunDesc = 1;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts
   gDelphiPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gDelphiPIEImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor




// import data from a text file.
procedure GDelphiPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
{*************************************************************************
**************************************************************************
**
** This function is where 'Import' extension works.
**
** The imput parameters are:
**	aneHandler - a handle that you pass to Argus Numerical Environmets API
**	fileName  - the file name of the file selected by the user (if you asked one)
**	layerHandle - (for future use) the handle of the layer selected by the user 
**			this handle will be used to get information from this layer
**
** This function is very simple:
** It reads three numbers from a text file and treats them as the description of
** a circle, It then calculates the position of a circle (polygon actually)
** and calls the function ANE_ImportTextToLayer(aneHandle, imp) to place those points
** on the layer.
**	aneHandle is the first parameter transfered to this function
**	imp is the import string
**
** Where to go from here?
** 
**  Many options are available, including displaying a dilaog and using
** the parameter from the dialog to create informatin, or even creating random
** infromation, without using any data, either from user, or from a file.
**************************************************************************
*************************************************************************}

var
  ParameterIndex : ANE_INT32;
  AString : ANE_STR;
begin
  // Check if recharge option is selected
    // get layer handle for the recharge layer.
{  LayerHandle := ANE_LayerGetHandleByName(aneHandle,
    'Recharge'); }

  if LayerHandle <> nil then
  begin
    // get the parameter index for the recharge elevation parameter
    ParameterIndex := {ANE_LayerGetParameterByName(aneHandle, LayerHandle,
      'Elevation');  } 0;

    if ParameterIndex > -1 then
    begin
      // set the value of the parameter lock to change
      AString := 'Dont Override';

      // if recharge elevation is not used,
      // prevent the parameter value from being overridden.
      ANE_LayerParameterPropertySet (aneHandle,ParameterIndex, LayerHandle,
         '+Lock', kPIEString, AString);
    end;

  end;

end;



procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;
	gDelphiPIEImportPIEDesc.version := IMPORT_PIE_VERSION;
	gDelphiPIEImportPIEDesc.name := 'Dummy Pie';   // name of project
	gDelphiPIEImportPIEDesc.importFlags := kImportFromLayer;
 	gDelphiPIEImportPIEDesc.toLayerTypes := kPIETriMeshLayer or kPIEQuadMeshLayer or kPIEInformationLayer or kPIEGridLayer or kPIEDataLayer or kPIEDomainLayer {* was kPIETriMeshLayer*/};
 	gDelphiPIEImportPIEDesc.fromLayerTypes := gDelphiPIEImportPIEDesc.toLayerTypes {* was kPIETriMeshLayer*/};
 	gDelphiPIEImportPIEDesc.doImportProc := @GDelphiPIE;// address of Post Processing Function function

	//
	// prepare PIE descriptor for Example Delphi PIE

	gDelphiPIEDesc.name := 'Dummy Pie';      // PIE name
	gDelphiPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gDelphiPIEDesc.descriptor := @gDelphiPIEImportPIEDesc;	// pointer to descriptor

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
 