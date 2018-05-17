unit SutraPIEDescriptors;

interface

uses
  ProjectPIE, AnePIE, FunctionPIE, ExportTemplatePIE, ImportPIE;

var
  gSUTRAProjectPDesc : ProjectPIEDesc ;
  gSUTRAPieDesc      : ANEPIEDesc ;

  gSutraRunExportPIEDesc : ExportTemplatePIEDesc;
  gSutraRunPIEDesc       : ANEPIEDesc ;

  gSutraPostImportPIEDesc : ImportPIEDesc;
  gSutraPostPIEDesc       : ANEPIEDesc;

  gSutraMakeVirtualMeshFunctionPieDesc : FunctionPIEDesc;
  gSutraMakeVirtualMeshPieDesc         : ANEPIEDesc;

  gSutraFreeVirtualMeshFunctionPieDesc : FunctionPIEDesc;
  gSutraFreeVirtualMeshPieDesc         : ANEPIEDesc;

  gSutraGetMorphedNodeValueFunctionPieDesc : FunctionPIEDesc;
  gSutraGetMorphedNodeValuePieDesc         : ANEPIEDesc;

  gSutraInitializePorosityFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializePorosityPieDesc         : ANEPIEDesc;

//  gSutraPorosityFunctionPieDesc : FunctionPIEDesc;
//  gSutraPorosityPieDesc         : ANEPIEDesc;

  gSutraInitializeInitialPressureFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializeInitialPressurePieDesc         : ANEPIEDesc;

  gSutraInitializeInitialConcentrationFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializeInitialConcentrationPieDesc         : ANEPIEDesc;

  gSutraInitializePermMaxFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializePermMaxPieDesc         : ANEPIEDesc;

  gSutraInitializePermMiddleFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializePermMiddlePieDesc         : ANEPIEDesc;

  gSutraInitializePermMinFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializePermMinPieDesc         : ANEPIEDesc;

  gSutraInitializeFloatExpressionFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializeFloatExpressionPieDesc         : ANEPIEDesc;

  gSutraGetMorphedElementValueFunctionPieDesc : FunctionPIEDesc;
  gSutraGetMorphedElementValuePieDesc         : ANEPIEDesc;

  gSutraGetMorphedElementAngleValueFunctionPieDesc : FunctionPIEDesc;
  gSutraGetMorphedElementAngleValuePieDesc         : ANEPIEDesc;

  gSutraGetZCountFunctionPieDesc : FunctionPIEDesc;
  gSutraGetZCountPieDesc         : ANEPIEDesc;

  gSutraGetXFunctionPieDesc : FunctionPIEDesc;
  gSutraGetXPieDesc         : ANEPIEDesc;

  gSutraGetYFunctionPieDesc : FunctionPIEDesc;
  gSutraGetYPieDesc         : ANEPIEDesc;

  gSutraGetZFunctionPieDesc : FunctionPIEDesc;
  gSutraGetZPieDesc         : ANEPIEDesc;

//  gSutraInitialConcentrationFunctionPieDesc : FunctionPIEDesc;
//  gSutraInitialConcentrationPieDesc         : ANEPIEDesc;

  gSutraInitializeSourcesOfFluidFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializeSourcesOfFluidPieDesc         : ANEPIEDesc;

  gSutraGetSourcesOfFluidFunctionPieDesc : FunctionPIEDesc;
  gSutraGetSourcesOfFluidPieDesc         : ANEPIEDesc;

  gSutraGetSourcesOfFluidConcFunctionPieDesc : FunctionPIEDesc;
  gSutraGetSourcesOfFluidConcPieDesc         : ANEPIEDesc;

  gSutraInitializeSoluteEnergyFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializeSoluteEnergyPieDesc         : ANEPIEDesc;

  gSutraGetSoluteEnergyFunctionPieDesc : FunctionPIEDesc;
  gSutraGetSoluteEnergyPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSpecifiedPressureFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSpecifiedPressurePieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSpecifiedPressureBottomFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSpecifiedPressureBottomPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSpecifiedPressureEndBottomFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSpecifiedPressureEndBottomPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSpecifiedPressureConcFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSpecifiedPressureConcPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSpecifiedPressureTimeDepFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSpecifiedPressureTimeDepPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSpecifiedPressureTopFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSpecifiedPressureTopPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSpecifiedPressureEndTopFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSpecifiedPressureEndTopPieDesc         : ANEPIEDesc;

  gSutraGetNodeZFunctionPieDesc : FunctionPIEDesc;
  gSutraGetNodeZPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenEnergySoluteBottomFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenEnergySoluteBottomPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenEnergySoluteSpecificSourceFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenEnergySoluteSpecificSourcePieDesc         : ANEPIEDesc;

  gSutraSetOverriddenEnergySoluteTopFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenEnergySoluteTopPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenEnergySoluteTotalSourceFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenEnergySoluteTotalSourcePieDesc         : ANEPIEDesc;

  gSutraSetOverriddenFluidSourceBottomFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenFluidSourceBottomPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenFluidSourceConcFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenFluidSourceConcPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenFluidSourceTopFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenFluidSourceTopPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenFluidSourceSpecificFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenFluidSourceSpecificPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenFluidSourceTotalFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenFluidSourceTotalPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceFluidSourceSpecificFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceFluidSourceSpecificPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceFluidSourceBottomFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceFluidSourceBottomPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceFluidSourceConcFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceFluidSourceConcPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceFluidSourceTopFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceFluidSourceTopPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceFluidSourceTotalFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceFluidSourceTotalPieDesc         : ANEPIEDesc;


  gSutraSetOverriddenSurfaceEnSolSourceSpecificFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceEnSolSourceSpecificPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceEnSolSourceBottomFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceEnSolSourceBottomPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceEnSolSourceTopFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceEnSolSourceTopPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceEnSolSourceTotalFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceEnSolSourceTotalPieDesc         : ANEPIEDesc;

  gSutraIsNodeABoundaryFunctionPieDesc : FunctionPIEDesc;
  gSutraIsNodeABoundaryPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceSpecifiedPressureFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceSpecifiedPressurePieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceSpecifiedPressureBottomFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceSpecifiedPressureBottomPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceSpecifiedPressureConcFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceSpecifiedPressureConcPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceSpecifiedPressureTimeDepFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceSpecifiedPressureTimeDepPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceSpecifiedPressureTopFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceSpecifiedPressureTopPieDesc         : ANEPIEDesc;

  gSutraInitializeSpecifiedPressureFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializeSpecifiedPressurePieDesc         : ANEPIEDesc;

  gSutraGetSpecifiedPressureFunctionPieDesc : FunctionPIEDesc;
  gSutraGetSpecifiedPressurePieDesc         : ANEPIEDesc;

  gSutraGetSpecifiedPressureConcFunctionPieDesc : FunctionPIEDesc;
  gSutraGetSpecifiedPressureConcPieDesc         : ANEPIEDesc;


  gSutraSetOverriddenSpecConcTempFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSpecConcTempPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSpecConcTempTopFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSpecConcTempTopPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSpecConcTempBottomFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSpecConcTempBottomPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceSpecConcTempFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceSpecConcTempPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceSpecConcTempTopFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceSpecConcTempTopPieDesc         : ANEPIEDesc;

  gSutraSetOverriddenSurfaceSpecConcTempBottomFunctionPieDesc : FunctionPIEDesc;
  gSutraSetOverriddenSurfaceSpecConcTempBottomPieDesc         : ANEPIEDesc;

  gSutraInitializeSpecifiedConcTempFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializeSpecifiedConcTempPieDesc         : ANEPIEDesc;

  gSutraGetSpecifiedConcTempFunctionPieDesc : FunctionPIEDesc;
  gSutraGetSpecifiedConcTempPieDesc         : ANEPIEDesc;

  gSutraGetBandWidthFunctionPieDesc : FunctionPIEDesc;
  gSutraGetBandWidthPieDesc         : ANEPIEDesc;

  gSutraInitializeNodeUnsatZoneFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializeNodeUnsatZonePieDesc         : ANEPIEDesc;

  gSutraGetNodeUnsatZoneFunctionPieDesc : FunctionPIEDesc;
  gSutraGetNodeUnsatZonePieDesc         : ANEPIEDesc;

  gSutraInitializeElementUnsatZoneFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializeElementUnsatZonePieDesc         : ANEPIEDesc;

  gSutraGetElementUnsatZoneFunctionPieDesc : FunctionPIEDesc;
  gSutraGetElementUnsatZonePieDesc         : ANEPIEDesc;

  gSutraGetElementNodeNumbersFunctionPieDesc : FunctionPIEDesc;
  gSutraGetElementNodeNumbersPieDesc         : ANEPIEDesc;

  gSutraInitializeObservationsFunctionPieDesc : FunctionPIEDesc;
  gSutraInitializeObservationsPieDesc         : ANEPIEDesc;

  gSutraGetObservationsFunctionPieDesc : FunctionPIEDesc;
  gSutraGetObservationsPieDesc         : ANEPIEDesc;

  gSutraGetObservationsUsedFunctionPieDesc : FunctionPIEDesc;
  gSutraGetObservationsUsedPieDesc         : ANEPIEDesc;

  gSuperFishNetPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gSuperFishNetImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

  gSetCountPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gSetCountFunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

  gGetXCountPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gGetXCountFunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

  gGetYCountPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gGetYCountFunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

  gAdjustMeshPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gAdjustMeshImportPIEDesc : ImportPIEDesc;           // Function PIE descriptor

  gEditSurfaceContoursImportPIEDesc : ImportPIEDesc;
  gEditSurfaceContoursPIEDesc       : ANEPIEDesc;

  gExport15BPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gExport15BFunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

  gExport14BPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gExport14BFunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

  gExport22PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gExport22FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

  gExport17PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gExport17FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

  gExport18PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gExport18FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

  gExport19PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gExport19FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

  gExport20PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gExport20FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

  gExportICS2PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gExportICS2FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

  gExportICS3PIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gExportICS3FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

  gExport8DPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gExport8DFunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor
{
  gDummyPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
  gDummyFunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor
}  

  gSutraViewerRunExportPIEDesc : ExportTemplatePIEDesc;
  gSutraViewerRunPIEDesc       : ANEPIEDesc ;

  gSutraHelpImportPIEDesc : ImportPIEDesc;
  gSutraHelpPIEDesc       : ANEPIEDesc;

  gReadDataSet3FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor
  gReadDataSet3PIEDesc  : ANEPIEDesc;	                   // PIE descriptor

  gGetNBI_FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor
  gGetNBI_PIEDesc  : ANEPIEDesc;	                   // PIE descriptor

  gGetNPBC_FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor
  gGetNPBC_PIEDesc  : ANEPIEDesc;	                   // PIE descriptor

  gGetNUBC_FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor
  gGetNUBC_PIEDesc  : ANEPIEDesc;	                   // PIE descriptor

  gGetNSOP_FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor
  gGetNSOP_PIEDesc  : ANEPIEDesc;	                   // PIE descriptor

  gGetNSOU_FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor
  gGetNSOU_PIEDesc  : ANEPIEDesc;	                   // PIE descriptor

  gGetNOBS_FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor
  gGetNOBS_PIEDesc  : ANEPIEDesc;	                   // PIE descriptor

  gReadOldICS2_FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor
  gReadOldICS2_PIEDesc  : ANEPIEDesc;	                   // PIE descriptor

  gReadOldICS3_FunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor
  gReadOldICS3_PIEDesc  : ANEPIEDesc;	                   // PIE descriptor

implementation

end.
