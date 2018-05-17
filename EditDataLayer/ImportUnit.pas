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
  SysUtils, Classes, Controls, Forms, Dialogs,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE ;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;


implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, OptionsUnit, frmDataEditUnit, frmDataLayerNameUnit;


//  kMaxFunDesc is the maximum number of PIE's in the dll
const kMaxFunDesc = 2;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts

   gEditDataPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gEditDataImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gContour2DataPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gContour2DataImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

procedure GEditDataLayerPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
begin
  Application.CreateForm(TfrmDataEdit, frmDataEdit);
  try
    frmDataEdit.CurrentModelHandle := aneHandle;
    frmDataEdit.GetData(layerHandle);
    if frmDataEdit.OK then
    begin
      frmDataEdit.ShowModal;
    end;
  finally
    FreeAndNil(frmDataEdit);
  end;
end;

procedure GContour2DataPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
begin
  Application.CreateForm(TfrmDataLayerName, frmDataLayerName);
  try
    frmDataLayerName.CurrentModelHandle := aneHandle;
    frmDataLayerName.GetLayerNames;
    if (frmDataLayerName.ShowModal = mrOK) and frmDataLayerName.OK then
    begin
      Application.CreateForm(TfrmDataEdit, frmDataEdit);
      try
        frmDataEdit.CurrentModelHandle := aneHandle;
        frmDataEdit.GetContourData(layerHandle);
        if frmDataEdit.OK then
        begin
          frmDataEdit.LayerHandle := frmDataLayerName.LayerHandle;
          frmDataEdit.btnOKClick(frmDataEdit.btnOK);
        end;
      finally
        frmDataEdit.Free;
      end;
    end;
  finally
    frmDataLayerName.Free;
  end;
end;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

	numNames := 0;

	gEditDataImportPIEDesc.version := IMPORT_PIE_VERSION;
	gEditDataImportPIEDesc.name := 'Edit Data Layer';   // name of project
	gEditDataImportPIEDesc.importFlags := kImportFromLayer;
 	gEditDataImportPIEDesc.toLayerTypes := kPIEDataLayer;
 	gEditDataImportPIEDesc.fromLayerTypes := kPIEDataLayer;
 	gEditDataImportPIEDesc.doImportProc := @GEditDataLayerPIE;// address of Post Processing Function function

	gEditDataPIEDesc.name := 'Edit Data Layer';      // PIE name
	gEditDataPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gEditDataPIEDesc.descriptor := @gEditDataImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gEditDataPIEDesc;
        Inc(numNames);	// add descriptor to list

        //------------------------------

	gContour2DataImportPIEDesc.version := IMPORT_PIE_VERSION;
	gContour2DataImportPIEDesc.name := 'Contours To Data Layer';   // name of project
	gContour2DataImportPIEDesc.importFlags := kImportFromLayer;
 	gContour2DataImportPIEDesc.toLayerTypes := kPIEAnyLayer;
 	gContour2DataImportPIEDesc.fromLayerTypes := kPIEInformationLayer or kPIEDomainLayer;
 	gContour2DataImportPIEDesc.doImportProc := @GContour2DataPIE;// address of Post Processing Function function

	gContour2DataPIEDesc.name := 'Contours To Data Layer';      // PIE name
	gContour2DataPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gContour2DataPIEDesc.descriptor := @gContour2DataImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gContour2DataPIEDesc;
        Inc(numNames);	// add descriptor to list

	descriptors := @gFunDesc;
end;



end.
 