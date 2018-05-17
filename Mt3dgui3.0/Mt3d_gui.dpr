library MT3D_GUI;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

{
  Debugging Techniques:

  1.
  Save TD32 information and use Borland Turbo debugger to debug.
  (Project|Options|Linker|Include TD32 debug information)
  Start Turbo Debugger32
  Click F3 and enter the name of your dll.
  Start Argus ONE.
  After Argus ONE has started, attach to ArgusONE.dll.
  From the File menu change to the directory with the source code of the PIE.
  Click F3 and double click on your dll
  Click F3 again and load the source files.
  You can now set breakpoints in the dll.

  2.
  Make a copy of ArgusONE.dll and rename it ArgusONE.exe. (Do not overwrite
  the original ArgusONE.exe)
  Place the new ArgusONE.EXE in the DatFiles directory
  Make a directory named ArgusPIE under the DatFiles directory
  Put the PIE to be debugged in the new ArgusPIE directory
  Debug as normal with the integrated debugger using the new version of
  ArgusONE as the host application.

  In Delphi4, select "Run|Add Breakpoint|Module Load BreakPoint" and then
  browse to the location of the dll and select it.

  When starting to debug select "Run|Parameters" then browse to the
  location of the Argus ONE, select it, and click the "Load" button to
  get the program started.
}

uses
  SysUtils,
  Classes,
  GetANEFunctionsUnit in 'GetANEFunctionsUnit.pas',
  ANE_LayerUnit in '..\shared\ANE_LayerUnit.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  ExportProgressUnit in '..\shared\ExportProgressUnit.pas' {frmExportProgress},
  ParamNamesAndTypes in '..\shared\ParamNamesAndTypes.pas',
  ExportTemplatePIE in '..\shared\ExportTemplatePIE.pas',
  ANECB in '..\shared\ANECB.pas',
  AnePIE in '..\shared\AnePIE.pas',
  ArgusFormUnit in '..\shared\ARGUSFORMUNIT.pas' {ArgusForm},
  MFBottom in '..\MfGUI3.0\MFBottom.pas',
  MFDomainOut in '..\MfGUI3.0\MFDomainOut.pas',
  MFDrain in '..\MfGUI3.0\MFDrain.pas',
  MFEvapo in '..\MfGUI3.0\MFEvapo.pas',
  MFGenHeadBound in '..\MfGUI3.0\MFGenHeadBound.pas',
  MFGenParam in '..\MfGUI3.0\MFGenParam.pas',
  MFGrid in '..\MfGUI3.0\MFGrid.pas',
  MFGridDensity in '..\MfGUI3.0\MFGridDensity.pas',
  MFHydraulicCond in '..\MfGUI3.0\MFHydraulicCond.pas',
  MFInactive in '..\MfGUI3.0\MFInactive.pas',
  MFInitialHead in '..\MfGUI3.0\MFInitialHead.pas',
  MFMap in '..\MfGUI3.0\MFMap.pas',
  MFMOCInitConc in '..\MfGUI3.0\MFMOCInitConc.pas',
  MFMOCObsWell in '..\MfGUI3.0\MFMOCObsWell.pas',
  MFMOCParticleRegen in '..\MfGUI3.0\MFMOCParticleRegen.pas',
  MFMOCPorosity in '..\MfGUI3.0\MFMOCPorosity.pas',
  MFPrescribedHead in '..\MfGUI3.0\MFPrescribedHead.pas',
  MFRecharge in '..\MfGUI3.0\MFRecharge.pas',
  MFRechConc in '..\MfGUI3.0\MFRechConc.pas',
  MFRiver in '..\MfGUI3.0\MFRiver.pas',
  MFSpecStor in '..\MfGUI3.0\MFSpecStor.pas',
  MFSpecYield in '..\MfGUI3.0\MFSpecYield.pas',
  MFTop in '..\MfGUI3.0\MFTop.pas',
  MFWells in '..\MfGUI3.0\MFWells.pas',
  MFWetting in '..\MfGUI3.0\MFWetting.pas',
  ModflowUnit in '..\MfGUI3.0\ModflowUnit.pas' {frmMODFLOW},
  ReadOldUnit in '..\MfGUI3.0\ReadOldUnit.pas',
  RunUnit in '..\MfGUI3.0\RunUnit.pas' {frmRun},
  MT3DFormUnit in 'MT3DFormUnit.pas' {frmMT3D},
  MODFLOWPieDescriptors in '..\MfGUI3.0\MODFLOWPieDescriptors.pas',
  ImportPIE in '..\shared\ImportPIE.pas',
  ThreeDGriddedDataStorageUnit in '..\shared\ThreeDGriddedDataStorageUnit.pas',
  ThreeDRealListUnit in '..\shared\ThreeDRealListUnit.pas',
  FixNameUnit in '..\shared\FixNameUnit.pas',
  IntListUnit in '..\shared\IntListUnit.pas',
  RealListUnit in '..\shared\RealListUnit.pas',
  ThreeDIntListUnit in '..\shared\ThreeDIntListUnit.pas',
  RunMT3DUnit in 'RunMT3DUnit.pas' {frmRunMT3D},
  PostMODFLOW in '..\MfGUI3.0\PostMODFLOW.pas' {frmMODFLOWPostProcessing},
  MFPostProc in '..\MfGUI3.0\MFPostProc.pas',
  WritePostProcessingUnit in '..\shared\WritePostProcessingUnit.pas',
  PostMODFLOWPieUnit in '..\MfGUI3.0\PostMODFLOWPieUnit.pas',
  MOC3DGridFunctions in '..\MfGUI3.0\MOC3DGridFunctions.pas',
  MOC3DParticleFunctions in '..\MfGUI3.0\MOC3DParticleFunctions.pas',
  MOC3DUnitFunctions in '..\MfGUI3.0\MOC3DUnitFunctions.pas',
  ModflowLayerFunctions in '..\MfGUI3.0\ModflowLayerFunctions.pas',
  ModflowTimeFunctions in '..\MfGUI3.0\ModflowTimeFunctions.pas',
  MT3DGrid in 'MT3DGrid.pas',
  MT3DPorosityUnit in 'MT3DPorosityUnit.pas',
  MT3DInactiveLayer in 'MT3DInactiveLayer.pas',
  MT3DObservations in 'MT3DObservations.pas',
  MT3DConstantConcentration in 'MT3DConstantConcentration.pas',
  MT3DGeneralParameters in 'MT3DGeneralParameters.pas',
  MT3DTimeVaryConc in 'MT3DTimeVaryConc.pas',
  MT3DInitConc in 'MT3DInitConc.pas',
  MT3DDomainOutline in 'MT3DDomainOutline.pas',
  MT3DPrescribedHead in 'MT3DPrescribedHead.pas',
  MT3DRecharge in 'MT3DRecharge.pas',
  MT3DEvaporation in 'MT3DEvaporation.pas',
  MT3DHydraulicCond in 'MT3DHydraulicCond.pas',
  MT3DWells in 'MT3DWells.pas',
  MT3DDrain in 'MT3DDrain.pas',
  MT3DRiver in 'MT3DRiver.pas',
  MT3DGenHeadBoundary in 'MT3DGenHeadBoundary.pas',
  MT3DLayerStructureUnit in 'MT3DLayerStructureUnit.pas',
  MFGroupLayerUnit in '..\MfGUI3.0\MFGroupLayerUnit.pas',
  MT3DTimeFunctions in 'MT3DTimeFunctions.pas',
  MT3DLayerFunctions in 'MT3DLayerFunctions.pas',
  MT3DPieDescriptors in 'MT3DPieDescriptors.pas',
  UtilityFunctionsMT3D in 'UtilityFunctionsMT3D.pas',
  PostMT3DPieUnit in 'PostMT3DPieUnit.pas',
  MT3DPostProc in 'MT3DPostProc.pas',
  ReadOldMT3D in 'ReadOldMT3D.pas',
  MFRBWLake in 'MFRBWLake.pas',
  RunFunction in 'RunFunction.pas',
  CheckVersionFunction in '..\shared\CheckVersionFunction.pas',
  Variables in 'Variables.pas',
  GetTypesUnit in '..\MfGUI3.0\GetTypesUnit.pas',
  ModflowLayerClassTypes in '..\MfGUI3.0\ModflowLayerClassTypes.pas',
  MFStreamUnit in '..\MfGUI3.0\MFStreamUnit.pas',
  MFHorFlowBarrier in '..\MfGUI3.0\MFHorFlowBarrier.pas',
  MFFlowAndHeadBound in '..\MfGUI3.0\MFFlowAndHeadBound.pas',
  MFMODPATHUnit in '..\MfGUI3.0\MFMODPATHUnit.pas',
  MFZoneBud in '..\MfGUI3.0\MFZoneBud.pas',
  MFModPathZone in '..\MfGUI3.0\MFModPathZone.pas',
  MFModPathPost in '..\MfGUI3.0\MFModPathPost.pas',
  MFMOCTransSubgrid in '..\MfGUI3.0\MFMOCTransSubgrid.pas',
  ModflowParameterClassTypes in '..\MfGUI3.0\ModflowParameterClassTypes.pas',
  ModflowParameterListClassTypes in '..\MfGUI3.0\ModflowParameterListClassTypes.pas',
  ProgramToRunUnit in 'ProgramToRunUnit.pas',
  LayerNamePrompt in '..\shared\LayerNamePrompt.pas' {frmLayerNamePrompt},
  SelectPostFile in '..\MfGUI3.0\SelectPostFile.pas' {frmSelectPostFile},
  ProjectFunctions in '..\MfGUI3.0\ProjectFunctions.pas',
  MFLayerStructureUnit in '..\MfGUI3.0\MFLayerStructureUnit.pas',
  GetMT3DTypes in 'GetMT3DTypes.pas',
  MT3DLayerClasses in 'MT3DLayerClasses.pas',
  MT3DParameterListClasses in 'MT3DParameterListClasses.pas',
  MT3DParameterClasses in 'MT3DParameterClasses.pas',
  MFTransmissivity in '..\MfGUI3.0\MFTransmissivity.pas',
  MFVcont in '..\MfGUI3.0\MFVcont.pas',
  MFConfStorage in '..\MfGUI3.0\MFConfStorage.pas',
  HFBDisplay in '..\MfGUI3.0\HFBDisplay.pas' {frmHFBDisplay},
  ModflowHelp in '..\MfGUI3.0\ModflowHelp.pas',
  ModflowPIEFunctions in '..\MfGUI3.0\ModflowPIEFunctions.pas',
  MODFLOW_FHBFunctions in '..\MfGUI3.0\MODFLOW_FHBFunctions.pas',
  mpathplotUnit in '..\MfGUI3.0\mpathplotUnit.pas' {frmMPathPlot},
  MODPATHFunctionsUnit in '..\MfGUI3.0\MODPATHFunctionsUnit.pas',
  ZoneBudgetFunctions in '..\MfGUI3.0\ZoneBudgetFunctions.pas',
  WellDataUnit in '..\MfGUI3.0\WellDataUnit.pas' {frmWellData},
  MT3DStream in 'MT3DStream.pas',
  MFSeepage in 'MFSeepage.pas',
  MFMOCImPor in '..\MfGUI3.0\MFMOCImPor.pas',
  MFMOCLinExch in '..\MfGUI3.0\MFMOCLinExch.pas',
  MFMOCDecay in '..\MfGUI3.0\MFMOCDecay.pas',
  MFMOCGrowth in '..\MfGUI3.0\MFMOCGrowth.pas',
  MFMOCImInitConc in '..\MfGUI3.0\MFMOCImInitConc.pas',
  MFMOCRetardation in '..\MfGUI3.0\MFMOCRetardation.pas',
  MFMOCDisDecay in '..\MfGUI3.0\MFMOCDisDecay.pas',
  MFMOCSorbDecay in '..\MfGUI3.0\MFMOCSorbDecay.pas',
  MFMOCDisGrowth in '..\MfGUI3.0\MFMOCDisGrowth.pas',
  MFMOCSorbGrowth in '..\MfGUI3.0\MFMOCSorbGrowth.pas',
  WarningsUnit in '..\shared\WarningsUnit.pas' {frmWarnings},
  OptionsUnit in '..\shared\OptionsUnit.pas',
  CheckPIEVersionFunction in '..\shared\CheckPIEVersionFunction.pas',
  GetMODFLOWLayerFunction in 'GetMODFLOWLayerFunction.pas',
  ProjectPIE in '..\shared\ProjectPIE.pas',
  ContourListUnit in '..\shared\ContourListUnit.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas',
  FixMoreNamesUnit in 'FixMoreNamesUnit.pas',
  WellMt3dData in 'WellMt3dData.pas' {frmMT3DWellData};

{$R *.RES}
  
  exports GetANEFunctions;
begin
end.
