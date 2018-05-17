library MFGUI_30;

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
  Delphi3: Make a copy of ArgusONE.dll and rename it ArgusONE.exe.
  (Do not overwrite the original ArgusONE.exe)
  Place the new ArgusONE.EXE in the DatFiles directory
  Make a directory named ArgusPIE under the DatFiles directory
  Put the PIE to be debugged in the new ArgusPIE directory
  Debug as normal with the integrated debugger using the new version of
  ArgusONE as the host application.

  Delphi4: Make a copy of ArgusONE.dll and rename it ArgusONE.exe.
  (Do not overwrite the original ArgusONE.exe)
  Place the new ArgusONE.EXE in the DatFiles directory
  Make a directory named ArgusPIE under the DatFiles directory
  Put the PIE to be debugged in the new ArgusPIE directory (or a subdirectory
  of it).
    Select Run Parameters and select the version of Argus ONE that is in the
  DatFiles directory. Click the Load button to start the program.
  Select "Run|Add Breakpoint|module load breakpoint" and select the
  dll to debug. Set additional breakpoints as desired.
  Click the run button to start the program
}

{
  See comments in Variables.pas for important infomation on how to customize
  this PIE.
}
uses
  SysUtils,
  Classes,
  GetANEFunctionsUnit in 'GetANEFunctionsUnit.pas',
  ArgusFormUnit in '..\shared\ARGUSFORMUNIT.pas' {ArgusForm},
  ModflowUnit in 'ModflowUnit.pas' {frmMODFLOW},
  MFGrid in 'MFGrid.pas',
  ANE_LayerUnit in '..\shared\ANE_LayerUnit.pas',
  ModflowTimeFunctions in 'ModflowTimeFunctions.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas',
  ModflowLayerFunctions in 'ModflowLayerFunctions.pas',
  MOC3DGridFunctions in 'MOC3DGridFunctions.pas',
  MOC3DUnitFunctions in 'MOC3DUnitFunctions.pas',
  MOC3DParticleFunctions in 'MOC3DParticleFunctions.pas',
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  ExportProgressUnit in '..\shared\ExportProgressUnit.pas' {frmExportProgress},
  MFTop in 'MFTop.pas',
  MFBottom in 'MFBottom.pas',
  MFInactive in 'MFInactive.pas',
  MFPrescribedHead in 'MFPrescribedHead.pas',
  MFInitialHead in 'MFInitialHead.pas',
  MFHydraulicCond in 'MFHydraulicCond.pas',
  MFSpecYield in 'MFSpecYield.pas',
  MFSpecStor in 'MFSpecStor.pas',
  MFWetting in 'MFWetting.pas',
  MFDomainOut in 'MFDomainOut.pas',
  MFGridDensity in 'MFGridDensity.pas',
  MFLayerStructureUnit in 'MFLayerStructureUnit.pas',
  MFMap in 'MFMap.pas',
  MFRecharge in 'MFRecharge.pas',
  MFRechConc in 'MFRechConc.pas',
  MFEvapo in 'MFEvapo.pas',
  MFMOCObsWell in 'MFMOCObsWell.pas',
  MFGenParam in 'MFGenParam.pas',
  MFWells in 'MFWells.pas',
  MFRiver in 'MFRiver.pas',
  MFDrain in 'MFDrain.pas',
  MFGenHeadBound in 'MFGenHeadBound.pas',
  MFMOCInitConc in 'MFMOCInitConc.pas',
  MFMOCParticleRegen in 'MFMOCParticleRegen.pas',
  MFMOCPorosity in 'MFMOCPorosity.pas',
  ProjectFunctions in 'ProjectFunctions.pas',
  ParamNamesAndTypes in '..\shared\ParamNamesAndTypes.pas',
  RunUnit in 'RunUnit.pas' {frmRun},
  ExportTemplatePIE in '..\shared\ExportTemplatePIE.pas',
  ReadOldUnit in 'ReadOldUnit.pas',
  MODFLOWPieDescriptors in 'MODFLOWPieDescriptors.pas',
  PostMODFLOW in 'PostMODFLOW.pas' {frmMODFLOWPostProcessing},
  ThreeDGriddedDataStorageUnit in '..\shared\ThreeDGriddedDataStorageUnit.pas',
  ThreeDRealListUnit in '..\shared\ThreeDRealListUnit.pas',
  FixNameUnit in '..\shared\FixNameUnit.pas',
  IntListUnit in '..\shared\IntListUnit.pas',
  RealListUnit in '..\shared\RealListUnit.pas',
  ThreeDIntListUnit in '..\shared\ThreeDIntListUnit.pas',
  ImportPIE in '..\shared\ImportPIE.pas',
  MFPostProc in 'MFPostProc.pas',
  WritePostProcessingUnit in '..\shared\WritePostProcessingUnit.pas',
  GetTypesUnit in 'GetTypesUnit.pas',
  PostMODFLOWPieUnit in 'PostMODFLOWPieUnit.pas',
  MFGroupLayerUnit in 'MFGroupLayerUnit.pas',
  MFStreamUnit in 'MFStreamUnit.pas',
  MFHorFlowBarrier in 'MFHorFlowBarrier.pas',
  MFFlowAndHeadBound in 'MFFlowAndHeadBound.pas',
  MODFLOW_FHBFunctions in 'MODFLOW_FHBFunctions.pas',
  MFMODPATHUnit in 'MFMODPATHUnit.pas',
  MODPATHFunctionsUnit in 'MODPATHFunctionsUnit.pas',
  HFBDisplay in 'HFBDisplay.pas' {frmHFBDisplay},
  MFZoneBud in 'MFZoneBud.pas',
  ZoneBudgetFunctions in 'ZoneBudgetFunctions.pas',
  MFModPathZone in 'MFModPathZone.pas',
  ModflowLayerClassTypes in 'ModflowLayerClassTypes.pas',
  ModflowParameterListClassTypes in 'ModflowParameterListClassTypes.pas',
  ModflowHelp in 'ModflowHelp.pas',
  ReadOldMT3D in 'ReadOldMT3D.pas',
  ModflowParameterClassTypes in 'ModflowParameterClassTypes.pas',
  Variables in 'Variables.pas',
  ModflowPIEFunctions in 'ModflowPIEFunctions.pas',
  CheckVersionFunction in '..\shared\CheckVersionFunction.pas',
  mpathplotUnit in 'mpathplotUnit.pas' {frmMPathPlot},
  MFModPathPost in 'MFModPathPost.pas',
  MFMOCTransSubgrid in 'MFMOCTransSubgrid.pas',
  ContourListUnit in '..\shared\ContourListUnit.pas',
  LayerNamePrompt in '..\shared\LayerNamePrompt.pas' {frmLayerNamePrompt},
  SelectPostFile in 'SelectPostFile.pas' {frmSelectPostFile},
  ProgramToRunUnit in 'ProgramToRunUnit.pas',
  MFTransmissivity in 'MFTransmissivity.pas',
  MFVcont in 'MFVcont.pas',
  MFConfStorage in 'MFConfStorage.pas',
  CustomizedPieFunctions in 'CustomizedPieFunctions.pas',
  WellDataUnit in 'WellDataUnit.pas' {frmWellData},
  WarningsUnit in '..\shared\WarningsUnit.pas' {frmWarnings},
  MFMOCImPor in 'MFMOCImPor.pas',
  MFMOCLinExch in 'MFMOCLinExch.pas',
  MFMOCDecay in 'MFMOCDecay.pas',
  MFMOCGrowth in 'MFMOCGrowth.pas',
  MFMOCImInitConc in 'MFMOCImInitConc.pas',
  MFMOCRetardation in 'MFMOCRetardation.pas',
  MFMOCDisDecay in 'MFMOCDisDecay.pas',
  MFMOCSorbDecay in 'MFMOCSorbDecay.pas',
  MFMOCDisGrowth in 'MFMOCDisGrowth.pas',
  MFMOCSorbGrowth in 'MFMOCSorbGrowth.pas',
  CheckPIEVersionFunction in '..\shared\CheckPIEVersionFunction.pas',
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ANECB in '..\shared\ANECB.pas',
  AnePIE in '..\shared\AnePIE.pas',
  ProjectPIE in '..\shared\ProjectPIE.pas',
  FixMoreNamesUnit in 'FixMoreNamesUnit.pas';

// The following compiler directive must be added manually to allow inclusion
// of version information in the PIE.
{$R *.RES}

  exports GetANEFunctions index 1;
begin
end.
