unit GetANEFunc;

interface

uses Forms, AnePIE;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;


implementation

uses ImportPIE, frmAddParametersUnit, TreeUnit, frmSetParamLockUnit, UtilityFunctions;

const kMaxFunDesc = 3;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts

   gParamImportPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gParamImportImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gSetParamImportPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gSetParamImportImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gSetParamLockPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gSetParamLockImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

procedure ImportMultipleParameters(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
begin
  Application.CreateForm(TfrmAddParameters, frmAddParameters);
  try
    frmAddParameters.CurrentModelHandle := aneHandle;
    frmAddParameters.GetLayers;
    frmAddParameters.ShowModal;
  finally
    frmAddParameters.Free;
  end;

end;

procedure SetMultipleParameters(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
begin
  Application.CreateForm(TfrmTree, frmTree);
  try
    frmTree.CurrentModelHandle := aneHandle;
    frmTree.GetData;
    frmTree.ShowModal;
  finally
    frmTree.Free;
  end;
end;

procedure SetMultipleParameterLocks(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
begin
  Application.CreateForm(TfrmSetParamLock, frmSetParamLock);
  try
    frmSetParamLock.CurrentModelHandle := aneHandle;
    frmSetParamLock.GetData;
    frmSetParamLock.ShowModal;
  finally
    frmSetParamLock.Free;
  end;
end;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
  numNames := 0;
  gParamImportImportPIEDesc.version := IMPORT_PIE_VERSION;
  gParamImportImportPIEDesc.name := 'Create Parameters in Multiple Layers';   // name of project
  gParamImportImportPIEDesc.importFlags := kImportAllwaysVisible;
  gParamImportImportPIEDesc.fromLayerTypes := kPIEAnyLayer  {* was kPIETriMeshLayer*/};
  gParamImportImportPIEDesc.toLayerTypes := kPIETriMeshLayer
    or kPIEQuadMeshLayer or kPIEInformationLayer or kPIEGridLayer
    or kPIEDomainLayer;
  gParamImportImportPIEDesc.doImportProc := @ImportMultipleParameters;// address of Post Processing Function function

  gParamImportPIEDesc.name := 'Create Parameters in Multiple Layers';      // PIE name
  gParamImportPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
  gParamImportPIEDesc.descriptor := @gParamImportImportPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gParamImportPIEDesc;
  Inc(numNames);	// add descriptor to list


  gSetParamImportImportPIEDesc.version := IMPORT_PIE_VERSION;
  gSetParamImportImportPIEDesc.name := 'Set Multiple Parameters';   // name of project
  gSetParamImportImportPIEDesc.importFlags := kImportAllwaysVisible;
  gSetParamImportImportPIEDesc.fromLayerTypes := kPIEAnyLayer  {* was kPIETriMeshLayer*/};
  gSetParamImportImportPIEDesc.toLayerTypes := kPIEAnyLayer;
  gSetParamImportImportPIEDesc.doImportProc := @SetMultipleParameters;// address of Post Processing Function function

  gSetParamImportPIEDesc.name := 'Set Multiple Parameters';      // PIE name
  gSetParamImportPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
  gSetParamImportPIEDesc.descriptor := @gSetParamImportImportPIEDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gSetParamImportPIEDesc;
  Inc(numNames);	// add descriptor to list


  if ShowHiddenFunctions then
  begin
    gSetParamLockImportPIEDesc.version := IMPORT_PIE_VERSION;
    gSetParamLockImportPIEDesc.name := 'Set Parameter Locks';   // name of project
    gSetParamLockImportPIEDesc.importFlags := kImportAllwaysVisible;
    gSetParamLockImportPIEDesc.fromLayerTypes := kPIEAnyLayer  {* was kPIETriMeshLayer*/};
    gSetParamLockImportPIEDesc.toLayerTypes := kPIEAnyLayer;
    gSetParamLockImportPIEDesc.doImportProc := @SetMultipleParameterLocks;// address of Post Processing Function function

    gSetParamLockPIEDesc.name := 'Set Parameter Locks';      // PIE name
    gSetParamLockPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
    gSetParamLockPIEDesc.descriptor := @gSetParamLockImportPIEDesc;	// pointer to descriptor

    Assert (numNames < kMaxFunDesc) ;
    gFunDesc[numNames] := @gSetParamLockPIEDesc;
    Inc(numNames);	// add descriptor to list
  end;

  descriptors := @gFunDesc;

end;


end.
