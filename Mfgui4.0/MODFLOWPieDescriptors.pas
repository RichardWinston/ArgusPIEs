unit MODFLOWPieDescriptors;

interface

{MODFLOWPieDescriptors defines all the PIE descriptors in the PIE.}

uses
  ProjectPIE, AnePIE, FunctionPIE, ExportTemplatePIE, ImportPIE;

const
  MOCROW1 = 'MOC_ISROW1';
  MOCROW2 = 'MOC_ISROW2';
  MOCCOL1 = 'MOC_ISCOL1';
  MOCCOL2 = 'MOC_ISCOL2';

var
  gMODFLOWProjectPDesc : ProjectPIEDesc ;
  gMODFLOWPieDesc      : ANEPIEDesc ;

  gMocRow1FunctionDesc : FunctionPIEDesc ;
  gMocRow1PieDesc      : ANEPIEDesc ;

  gMocRow2FunctionDesc : FunctionPIEDesc ;
  gMocRow2PieDesc      : ANEPIEDesc ;

  gMocCol1FunctionDesc : FunctionPIEDesc ;
  gMocCol1PieDesc      : ANEPIEDesc ;

  gMocCol2FunctionDesc : FunctionPIEDesc ;
  gMocCol2PieDesc      : ANEPIEDesc ;

  gMFGetNumPerFunctionDesc : FunctionPIEDesc ;
  gMFGetNumPerPieDesc      : ANEPIEDesc ;

  gMFGetPerLengthFunctionDesc : FunctionPIEDesc ;
  gMFGetPerLengthPieDesc      : ANEPIEDesc ;

  gMFGetPerStepsFunctionDesc : FunctionPIEDesc ;
  gMFGetPerStepsPieDesc      : ANEPIEDesc ;

  gMFGetTimeStepMultFunctionDesc : FunctionPIEDesc ;
  gMFGetTimeStepMultPieDesc      : ANEPIEDesc ;

  gMFGetNumUnitsFunctionDesc : FunctionPIEDesc ;
  gMFGetNumUnitsPieDesc      : ANEPIEDesc ;

  gMFGetAnisotropyFunctionDesc : FunctionPIEDesc ;
  gMFGetAnisotropyPieDesc      : ANEPIEDesc ;

  gMFGetUnitSimulatedFunctionDesc : FunctionPIEDesc ;
  gMFGetUnitSimulatedPieDesc      : ANEPIEDesc ;

  gMFGetUnitAvgMethFunctionDesc : FunctionPIEDesc ;
  gMFGetUnitAvgMethPieDesc      : ANEPIEDesc ;

  gMFGetLayerTypeFunctionDesc : FunctionPIEDesc ;
  gMFGetLayerTypePieDesc      : ANEPIEDesc ;

  gMFGetVerticalDiscrFunctionDesc : FunctionPIEDesc ;
  gMFGetVerticalDiscrPieDesc      : ANEPIEDesc ;


  gMFGetUnitUsesTransFunctionDesc : FunctionPIEDesc ;
  gMFGetUnitUsesTransPieDesc      : ANEPIEDesc ;

  gMFGetUnitUsesVcontFunctionDesc : FunctionPIEDesc ;
  gMFGetUnitUsesVcontPieDesc      : ANEPIEDesc ;

  gMFGetUnitUsesSF1FunctionDesc : FunctionPIEDesc ;
  gMFGetUnitUsesSF1PieDesc      : ANEPIEDesc ;





  gMFGetMODFLOWLayerFunctionDesc : FunctionPIEDesc ;
  gMFGetMODFLOWLayerPieDesc      : ANEPIEDesc ;

  gMOCGetLongDispFunctionDesc : FunctionPIEDesc ;
  gMOCGetLongDispPieDesc      : ANEPIEDesc ;

  gMOCGetTransHorDispFunctionDesc : FunctionPIEDesc ;
  gMOCGetTransHorDispPieDesc      : ANEPIEDesc ;

  gMOCGetTransVertDispFunctionDesc : FunctionPIEDesc ;
  gMOCGetTransVertDispPieDesc      : ANEPIEDesc ;

  gMOCGetRetardationFactorFunctionDesc : FunctionPIEDesc ;
  gMOCGetRetardationFactorPieDesc      : ANEPIEDesc ;

  gMOCGetCBoundFunctionDesc : FunctionPIEDesc ;
  gMOCGetCBoundPieDesc      : ANEPIEDesc ;

  gMOCGetParticleLayerPositionFunctionDesc : FunctionPIEDesc ;
  gMOCGetParticleLayerPositionPieDesc      : ANEPIEDesc ;

  gMOCGetParticleRowPositionFunctionDesc : FunctionPIEDesc ;
  gMOCGetParticleRowPositionPieDesc      : ANEPIEDesc ;

  gMOCGetParticleColumnPositionFunctionDesc : FunctionPIEDesc ;
  gMOCGetParticleColumnPositionPieDesc      : ANEPIEDesc ;

  gMFRunExportPIEDesc : ExportTemplatePIEDesc;
  gMFRunPIEDesc       : ANEPIEDesc ;

  gMFRunMPATHExportPIEDesc : ExportTemplatePIEDesc;
  gMFRunMPATHPIEDesc       : ANEPIEDesc ;

  gMFRunZonebdgtExportPIEDesc : ExportTemplatePIEDesc;
  gMFRunZonebdgtPIEDesc       : ANEPIEDesc ;

  gMFRunSeawatExportPIEDesc : ExportTemplatePIEDesc;
  gMFRunSeawatPIEDesc       : ANEPIEDesc ;

  gMFRunGWM_ExportPIEDesc : ExportTemplatePIEDesc;
  gMFRunGWM_PIEDesc       : ANEPIEDesc ;

  gMFPostImportPIEDesc : ImportPIEDesc;
  gMFPostPIEDesc       : ANEPIEDesc ;

  gMFGetFHBTimeFunctionDesc : FunctionPIEDesc ;
  gMFGetFHBTimePieDesc      : ANEPIEDesc ;

  gMFGetMODPATHTimeFunctionDesc : FunctionPIEDesc ;
  gMFGetMODPATHTimePieDesc      : ANEPIEDesc ;

  gMFDisplayHFBImportPIEDesc  : ImportPIEDesc;
  gMFDisplayHFBPIEDesc       : ANEPIEDesc ;

  gMFGetZonebudTimeCountFunctionDesc : FunctionPIEDesc ;
  gMFGetZonebudTimeCountPieDesc      : ANEPIEDesc ;

  gMFGetZonebudTimeStepFunctionDesc : FunctionPIEDesc ;
  gMFGetZonebudTimeStepPieDesc      : ANEPIEDesc ;

  gMFGetZonebudStessPeriodFunctionDesc : FunctionPIEDesc ;
  gMFGetZonebudStessPeriodPieDesc      : ANEPIEDesc ;

  gMFGetZonebudCompositeZoneFunctionDesc : FunctionPIEDesc ;
  gMFGetZonebudCompositeZonePieDesc      : ANEPIEDesc ;

  gMFHelpImportPIEDesc : ImportPIEDesc;
  gMFHelpPIEDesc       : ANEPIEDesc ;

  gMFModpathPostImportPIEDesc : ImportPIEDesc;
  gMFModpathPostPIEDesc       : ANEPIEDesc ;

  gMFImportWellsImportPIEDesc : ImportPIEDesc;
  gMFImportWellsPIEDesc       : ANEPIEDesc ;

  gMFGetLayerFunctionDesc : FunctionPIEDesc ;
  gMFGetLayerPieDesc      : ANEPIEDesc ;

  gMFExportLakesFunctionDesc : FunctionPIEDesc ;
  gMFExportLakesPieDesc      : ANEPIEDesc ;

  gMFInitializeLakesFunctionDesc : FunctionPIEDesc ;
  gMFInitializeLakesPieDesc      : ANEPIEDesc ;

  gMFLakesNumberFunctionDesc : FunctionPIEDesc ;
  gMFLakesNumberPieDesc      : ANEPIEDesc ;

  gMFFreeBlockFunctionDesc : FunctionPIEDesc ;
  gMFFreeBlockPieDesc      : ANEPIEDesc ;

  gMFUseIBSFunctionDesc : FunctionPIEDesc ;
  gMFUseIBSPieDesc      : ANEPIEDesc ;

  gMFExportReservoirsFunctionDesc : FunctionPIEDesc ;
  gMFExportReservoirsPieDesc      : ANEPIEDesc ;

  gMFInitializeReservoirsFunctionDesc : FunctionPIEDesc ;
  gMFInitializeReservoirsPieDesc      : ANEPIEDesc ;

  gMFReservoirsNumberFunctionDesc : FunctionPIEDesc ;
  gMFReservoirsNumberPieDesc      : ANEPIEDesc ;

  gMFUseTLKFunctionDesc : FunctionPIEDesc ;
  gMFUseTLKPieDesc      : ANEPIEDesc ;

  gMFExport2000FunctionDesc : FunctionPIEDesc ;
  gMFExport2000PieDesc      : ANEPIEDesc ;

  gMFExportMT3DMSFunctionDesc : FunctionPIEDesc ;
  gMFExportMT3DMSPieDesc      : ANEPIEDesc ;

  gMFResetGagesFunctionDesc : FunctionPIEDesc ;
  gMFResetGagesPieDesc      : ANEPIEDesc ;

  gMFGageCountFunctionDesc : FunctionPIEDesc ;
  gMFGageCountPieDesc      : ANEPIEDesc ;

  gMFGageUnitNumberFunctionDesc : FunctionPIEDesc ;
  gMFGageUnitNumberPieDesc      : ANEPIEDesc ;

  gMFGetUnitNumberFunctionDesc : FunctionPIEDesc ;
  gMFGetUnitNumberPieDesc      : ANEPIEDesc ;

  gMFWriteGagesFunctionDesc : FunctionPIEDesc ;
  gMFWriteGagesPieDesc      : ANEPIEDesc ;

{  gMFInitializeLakeGagesFunctionDesc : FunctionPIEDesc ;
  gMFInitializeLakeGagesPieDesc      : ANEPIEDesc ;}

  gMFLinkUnitsImportPieDesc : ImportPIEDesc ;
  gMFLinkUnitsPieDesc      : ANEPIEDesc ;

  gMFGetMODPATHSteadyStateFunctionDesc : FunctionPIEDesc ;
  gMFGetMODPATHSteadyStatePieDesc      : ANEPIEDesc ;

  gMFGetMODPATHTimeProblemFunctionDesc : FunctionPIEDesc;
  gMFGetMODPATHTimeProblemPieDesc      : ANEPIEDesc ;

  gMT3DPostImportPIEDesc : ImportPIEDesc;
  gMT3DPostPIEDesc       : ANEPIEDesc ;

  gMFRunExportMT3DPIEDesc : ExportTemplatePIEDesc;
  gMFRunMT3DPIEDesc       : ANEPIEDesc ;

  gMFImportContoursImportPIEDesc : ImportPIEDesc;
  gMFImportContoursPIEDesc       : ANEPIEDesc ;

  gMFLinkStreamsImportPIEDesc : ImportPIEDesc;
  gMFLinkStreamsPIEDesc       : ANEPIEDesc ;

  gMFGetIboundFunctionDesc: FunctionPIEDesc ;
  gMFGetIboundPieDesc     : ANEPIEDesc ;

implementation

end.
