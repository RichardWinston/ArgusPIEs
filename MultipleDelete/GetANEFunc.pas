unit GetANEFunc;

interface

uses Forms, AnePIE;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;


implementation

uses ImportPIE, frmDeleteLayerUnit;

const kMaxFunDesc = 1;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts

   gDeleteLayerPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gDeleteLayerImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

procedure ImportMultipleParameters(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
begin
  Application.CreateForm(TfrmDeleteLayer, frmDeleteLayer);
  try
    frmDeleteLayer.CurrentModelHandle := aneHandle;
    frmDeleteLayer.GetLayers;
    frmDeleteLayer.ShowModal;
  finally
    frmDeleteLayer.Free;
  end;

end;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
  numNames := 0;
  gDeleteLayerImportPIEDesc.version := IMPORT_PIE_VERSION;
  gDeleteLayerImportPIEDesc.name := 'Delete Multiple Layers';   // name of project
  gDeleteLayerImportPIEDesc.importFlags := kImportAllwaysVisible;
  gDeleteLayerImportPIEDesc.fromLayerTypes := kPIEAnyLayer  {* was kPIETriMeshLayer*/};
  gDeleteLayerImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gDeleteLayerImportPIEDesc.doImportProc := @ImportMultipleParameters;// address of Post Processing Function function

  // prepare PIE descriptor for Example Delphi PIE
  gDeleteLayerPIEDesc.name := 'Delete Multiple Layers';      // PIE name
  gDeleteLayerPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
  gDeleteLayerPIEDesc.descriptor := @gDeleteLayerImportPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gDeleteLayerPIEDesc;
  Inc(numNames);	// add descriptor to list

  descriptors := @gFunDesc;

end;


end.
