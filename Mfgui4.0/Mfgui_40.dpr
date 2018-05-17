library MFGUI_40;

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
Subject:
             Re: Debugging DLLs Under Windows 2000
        Date:
             Thu, 28 Sep 2000 15:17:19 -0400
        From:
             "Davinci Jeremie" <DJeremie@LorisTech.com>
 Organization:
             Loris Technologies
  Newsgroups:
             borland.public.delphi.winapi
  References:
             1




I solved it!  Borland should note this!!!!
just do this...

Run "Local Security Policy" from the "Administrative Tools" folder. Expand
"Local Policies", and then click on "User Rights Assignment". In the right
hand panel, you should see "Act as part of the operating system". Double
click on it, and select "Add..." to add a user to the list. Add your current
user to the list that you intend to debug with Close this window after
adding the user.
Then reboot.

Davinci.

"Davinci Jeremie" <DJeremie@LorisTech.com> wrote in message
news:39d38d9d$1_1@dnews...
> I know quite a few people MUST have had this problem under windows 2000.
I
> am unable to debug a DLL under windows 2000 and every install of windows
> 2000 and Delphi 5 that I have has this problem.
>
> Let me explain some more.   If you set the Host Application and then run
it
> the DLL's break points and Stop and Delphi exceptions do not work.   If
you
> select Run|Attach to Process then the break points work.   Am I missing
> something here?  Also note that if the Host application is a Delphi
> application everything works fine.  I have 3 computers with Windows 2000
> installed with Delphi and none of them debug properly My Window NT 4
machine
> works fine.
>
> Please note my problem is not with debugging ISAPI DLL's it is with
> debugging DLLs and OCX files on Windows 2000.   If this is just a bug and
no
> one has solved it then fine just tell me so.
>
> I have lived with this too long some one please help!
>
> Sorry for the cross post but no one seems to have an answer.
>
> Davinci
>
>
>
>
}

{
From http://www.delphifaq.com/fq/q3079.shtml
See also: http://www.nsonic.de/Delphi/txt_WIS00637.htm

Debugging a DLL in Windows XP

Question:

I used to debug DLLs in Delphi using Delphi's menu item 'Run Parameters'
where I set the 'Host Application' to be any program which would load my
DLL. This does not work on Windows XP any more.

Answer:

Run the program that loads the DLL from the Delphi IDE (yes, this means
that it has to be a Delphi host application).

After this, switch back to the Delphi IDE and press Ctrl-Alt-M to list
all modules. Sometimes there will be your DLL with path, but if not,
then right click on the DLL, select 'Reload Symbol Table' and set the
full path to the DLL. Then the breakpoints will be active.

If the DLL will be compiled in the system path (any directory on %PATH%)
this problem doesn't occur.
}



{
  See comments in Variables.pas for important infomation on how to customize
  this PIE.
}
{%ToDo 'Mfgui_40.todo'}
{%TogetherDiagram 'ModelSupport_Mfgui_40\default.txaPackage'}
{$SetPEFlags $20}

uses
  FastMM4 in '..\shared\FastMM4.pas',
  FastMM4Messages in '..\shared\FastMM4Messages.pas',
  SysUtils,
  Classes,
  GetANEFunctionsUnit in 'GetANEFunctionsUnit.pas',
  ARGUSFORMUNIT in '..\shared\ARGUSFORMUNIT.pas' {ArgusForm},
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
  Mfbottom in 'Mfbottom.pas',
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
  FixMoreNamesUnit in 'FixMoreNamesUnit.pas',
  frmMultiplierEditUnit in 'frmMultiplierEditUnit.pas' {frmMultiplierEditor},
  MFMultiplierUnit in 'MFMultiplierUnit.pas',
  MFZoneUnit in 'MFZoneUnit.pas',
  WriteModflowDiscretization in 'WriteModflowDiscretization.pas',
  WriteModflowFilesUnit in 'WriteModflowFilesUnit.pas',
  WriteMultiplierUnit in 'WriteMultiplierUnit.pas',
  WriteModflowZonesUnit in 'WriteModflowZonesUnit.pas',
  WriteOutputControlUnit in 'WriteOutputControlUnit.pas',
  WriteBCF_Unit in 'WriteBCF_Unit.pas',
  ProgressUnit in 'ProgressUnit.pas' {frmProgress},
  frmMultValueUnit in 'frmMultValueUnit.pas' {frmMultValue},
  WriteRiverUnit in 'WriteRiverUnit.pas',
  WriteLayerPropertyFlow in 'WriteLayerPropertyFlow.pas',
  MFAnisotropy in 'MFAnisotropy.pas',
  WriteRechargeUnit in 'WriteRechargeUnit.pas',
  WriteEvapUnit in 'WriteEvapUnit.pas',
  InitializeBlockUnit in '..\blocklist\InitializeBlockUnit.pas',
  BlockListUnit in '..\blocklist\BlockListUnit.pas',
  CellVertexUnit in '..\blocklist\CellVertexUnit.pas',
  CombinedListUnit in '..\blocklist\CombinedListUnit.pas',
  InitializeLists in '..\blocklist\InitializeLists.pas',
  InitializeVertexUnit in '..\blocklist\InitializeVertexUnit.pas',
  GetCellUnit in '..\blocklist\GetCellUnit.pas',
  BL_SegmentUnit in '..\blocklist\BL_SegmentUnit.pas',
  PointInsideContourUnit in '..\blocklist\PointInsideContourUnit.pas',
  GridUnit in '..\blocklist\GridUnit.pas',
  SegmentUnit in '..\shared\SegmentUnit.pas',
  VertexUnit in '..\shared\VertexUnit.pas',
  FreeBlockUnit in '..\blocklist\FreeBlockUnit.pas',
  WriteWellUnit in 'WriteWellUnit.pas',
  GetFractionUnit in '..\blocklist\GetFractionUnit.pas',
  WriteDrainUnit in 'WriteDrainUnit.pas',
  WriteGHBUnit in 'WriteGHBUnit.pas',
  WriteSolversUnit in 'WriteSolversUnit.pas',
  WriteHorizFlowBarriersUnit in 'WriteHorizFlowBarriersUnit.pas',
  CrossColumnUnit in '..\blocklist\CrossColumnUnit.pas',
  CrossRowUnit in '..\blocklist\CrossRowUnit.pas',
  WriteNameFileUnit in 'WriteNameFileUnit.pas',
  WriteFHBUnit in 'WriteFHBUnit.pas',
  GetLayerUnit in 'GetLayerUnit.pas',
  MFHeadObservations in 'MFHeadObservations.pas',
  MFFluxObservationUnit in 'MFFluxObservationUnit.pas',
  WriteFluxObservationsUnit in 'WriteFluxObservationsUnit.pas',
  WriteGHBObservationsUnit in 'WriteGHBObservationsUnit.pas',
  WriteDrainObservationsUnit in 'WriteDrainObservationsUnit.pas',
  WriteRiverObservationsUnit in 'WriteRiverObservationsUnit.pas',
  WriteHeadFluxObservationsUnit in 'WriteHeadFluxObservationsUnit.pas',
  WriteHeadObsUnit in 'WriteHeadObsUnit.pas',
  GetCellVertexUnit in '..\blocklist\GetCellVertexUnit.pas',
  WriteSensitivityUnit in 'WriteSensitivityUnit.pas',
  frmPriorEquationEditorUnit in 'frmPriorEquationEditorUnit.pas' {frmPriorEquationEditor},
  WriteParamEstUnit in 'WriteParamEstUnit.pas',
  MFAdvectObservUnit in 'MFAdvectObservUnit.pas',
  WriteAdvectionObservationsUnit in 'WriteAdvectionObservationsUnit.pas',
  MFLakes in 'MFLakes.pas',
  WriteLakesUnit in 'WriteLakesUnit.pas',
  MFInterbedUnit in 'MFInterbedUnit.pas',
  MFReservoir in 'MFReservoir.pas',
  WriteReservoirUnit in 'WriteReservoirUnit.pas',
  PackageFunctions in 'PackageFunctions.pas',
  WriteGageUnit in 'WriteGageUnit.pas',
  DebugUnit in '..\shared\DebugUnit.pas',
  UnitNumbers in 'UnitNumbers.pas',
  LinkUnits in 'LinkUnits.pas',
  ModflowImport in 'ModflowImport.pas' {frmModflowImport},
  frmDataValuesUnit in 'frmDataValuesUnit.pas' {frmDataValues},
  WriteMoc3d in 'WriteMoc3d.pas',
  WriteStreamUnit in 'WriteStreamUnit.pas',
  ConserveResourcesUnit in '..\shared\ConserveResourcesUnit.pas',
  DecayCalculator in 'DecayCalculator.pas' {frmDecayCalculator},
  WriteStrUnit in 'WriteStrUnit.pas',
  MFSegEvap in 'MFSegEvap.pas',
  WriteETSUnit in 'WriteETSUnit.pas',
  MFDrainReturn in 'MFDrainReturn.pas',
  WriteDrainReturnUnit in 'WriteDrainReturnUnit.pas',
  WriteDrainReturnObservationsUnit in 'WriteDrainReturnObservationsUnit.pas',
  MF_HYDMOD_Unit in 'MF_HYDMOD_Unit.pas',
  WriteIBSUnit in 'WriteIBSUnit.pas',
  WriteHydmodUnit in 'WriteHydmodUnit.pas',
  MFCHD in 'MFCHD.pas',
  frmDistributeParticlesUnit in 'frmDistributeParticlesUnit.pas' {frmDistributeParticles},
  WriteCHDUnit in 'WriteCHDUnit.pas',
  framHUF_Unit in 'framHUF_Unit.pas' {framHUF: TFrame},
  MF_HUF in 'MF_HUF.pas',
  WriteHUF_Unit in 'WriteHUF_Unit.pas',
  MT3DDomainOutline in 'MT3DDomainOutline.pas',
  MT3DGeneralParameters in 'MT3DGeneralParameters.pas',
  MT3DInactiveLayer in 'MT3DInactiveLayer.pas',
  MT3DInitConc in 'MT3DInitConc.pas',
  MT3DLayerClasses in 'MT3DLayerClasses.pas',
  MT3DObservations in 'MT3DObservations.pas',
  MT3DParameterClasses in 'MT3DParameterClasses.pas',
  MT3DParameterListClasses in 'MT3DParameterListClasses.pas',
  MT3DPostProc in 'MT3DPostProc.pas',
  MT3DTimeVaryConc in 'MT3DTimeVaryConc.pas',
  WriteMT3D_Basic in 'WriteMT3D_Basic.pas',
  WriteMT3D_Advection in 'WriteMT3D_Advection.pas',
  WriteMT3D_Dispersion in 'WriteMT3D_Dispersion.pas',
  WriteMT3D_Chem in 'WriteMT3D_Chem.pas',
  MT3DBulkDensity in 'MT3DBulkDensity.pas',
  MT3DSorption in 'MT3DSorption.pas',
  MT3DReaction in 'MT3DReaction.pas',
  WriteMT3D_GCG in 'WriteMT3D_GCG.pas',
  WriteMT3D_SSM in 'WriteMT3D_SSM.pas',
  WriteMT3DUnit in 'WriteMT3DUnit.pas',
  WriteMt3dLink in 'WriteMt3dLink.pas',
  CopyArrayUnit in 'CopyArrayUnit.pas',
  frmMt3dFilesUnit in 'frmMt3dFilesUnit.pas' {frmMt3dFiles},
  framFilePathUnit in '..\shared\framFilePathUnit.pas' {framFilePath: TFrame},
  MT3DMassFlux in 'MT3DMassFlux.pas',
  import in 'import.pas',
  WriteContourUnit in '..\shared\WriteContourUnit.pas' {frmWriteContour},
  PointContourUnit in '..\shared\PointContourUnit.pas',
  ChooseLayerUnit in '..\shared\ChooseLayerUnit.pas' {frmChooseLayer},
  PostMODFLOWPieUnit in 'PostMODFLOWPieUnit.pas',
  frmContourImporterUnit in 'frmContourImporterUnit.pas' {frmContourImporter},
  MF_MNW in 'MF_MNW.pas',
  WriteMultiNodeWellUnit in 'WriteMultiNodeWellUnit.pas',
  MF_DAFLOW in 'MF_DAFLOW.pas',
  WriteDaflow in 'WriteDaflow.pas',
  FlowReaderUnit in 'FlowReaderUnit.pas',
  InternetConnection in '..\shared\InternetConnection.pas',
  WriteBFLX_Unit in 'WriteBFLX_Unit.pas',
  mf2kInterface in 'mf2kInterface.pas',
  MF2K_Importer in 'MF2K_Importer.pas',
  MF_HUF_RefSurf in 'MF_HUF_RefSurf.pas',
  frmLinkStreamUnit in 'frmLinkStreamUnit.pas' {frmLinkStreams},
  frmStreamJoinDistanceUnit in 'frmStreamJoinDistanceUnit.pas' {frmStreamJoinDistance},
  MFSubsidence in 'MFSubsidence.pas',
  WriteSubsidence in 'WriteSubsidence.pas',
  frmStreamLinkChoiceUnit in 'frmStreamLinkChoiceUnit.pas' {frmStreamLinkChoice},
  MFDensity in 'MFDensity.pas',
  WriteVariableDensityFlow in 'WriteVariableDensityFlow.pas',
  MFMOCInitialParticles in 'MFMOCInitialParticles.pas',
  WriteIPDA in 'WriteIPDA.pas',
  WriteIPDL in 'WriteIPDL.pas',
  frameFormatDescriptor in 'frameFormatDescriptor.pas' {frameFormat: TFrame},
  MF_GWT_CBDY in 'MF_GWT_CBDY.pas',
  WriteCBDY in 'WriteCBDY.pas',
  frameOutputControlUnit in 'frameOutputControlUnit.pas' {frameOutputControl: TFrame},
  MF_GWM_Flux in 'MF_GWM_Flux.pas',
  MF_GWM_HeadConstraint in 'MF_GWM_HeadConstraint.pas',
  MF_GWM_DrawdownConstraint in 'MF_GWM_DrawdownConstraint.pas',
  MF_GWM_HeadDifference in 'MF_GWM_HeadDifference.pas',
  MF_GWM_Gradient in 'MF_GWM_Gradient.pas',
  MF_GWM_StreamFlow in 'MF_GWM_StreamFlow.pas',
  MF_GWM_StreamDepletion in 'MF_GWM_StreamDepletion.pas',
  frameGWM_Unit in 'frameGWM_Unit.pas' {frameGWM: TFrame},
  WriteGWM_DecisionVariables in 'WriteGWM_DecisionVariables.pas',
  WriteGWM_ObjectiveFunction in 'WriteGWM_ObjectiveFunction.pas',
  WriteGWM_SummaryConstraints in 'WriteGWM_SummaryConstraints.pas',
  WriteGWM_HeadConstraints in 'WriteGWM_HeadConstraints.pas',
  WriteGWM_StreamConstraints in 'WriteGWM_StreamConstraints.pas',
  WriteGWM_Solution in 'WriteGWM_Solution.pas',
  MFMOC_ParticleObservations in 'MFMOC_ParticleObservations.pas',
  WriteGwtParticleObservation in 'WriteGwtParticleObservation.pas',
  hh in '..\shared\hh.pas',
  hh_funcs in '..\shared\hh_funcs.pas',
  MFUnsaturatedZoneFlow in 'MFUnsaturatedZoneFlow.pas',
  WriteUZF in 'WriteUZF.pas',
  Mt3dMolecularDiffusion in 'Mt3dMolecularDiffusion.pas',
  MF_SWT in 'MF_SWT.pas',
  WriteSwtUnit in 'WriteSwtUnit.pas',
  MfMt3dConcentrationObservationUnit in 'MfMt3dConcentrationObservationUnit.pas',
  WriteMT3D_TOB in 'WriteMT3D_TOB.pas',
  MF_SW_Viscosity in 'MF_SW_Viscosity.pas',
  WriteSeawatViscosity in 'WriteSeawatViscosity.pas',
  ReadModflowArrayUnit in 'ReadModflowArrayUnit.pas',
  MF_MNW2 in 'MF_MNW2.pas',
  frameMnw2PumpUnit in 'frameMnw2PumpUnit.pas' {frameMnw2Pump: TFrame},
  WriteMNW2Unit in 'WriteMNW2Unit.pas',
  TempFiles in '..\shared\TempFiles.pas',
  ReadMt3dArrayUnit in 'ReadMt3dArrayUnit.pas',
  MF_GWM_StateVariables in 'MF_GWM_StateVariables.pas',
  WriteGWM_StateVariables in 'WriteGWM_StateVariables.pas',
  MFMOCConstConc in 'MFMOCConstConc.pas',
  WriteGWTConstantConc in 'WriteGWTConstantConc.pas',
  MFMOC_VolumeBalancing in 'MFMOC_VolumeBalancing.pas',
  WriteGWT_VBAL in 'WriteGWT_VBAL.pas';

// The following compiler directive is required to allow inclusion
// of version information in the PIE.
{$R *.RES}

  exports GetANEFunctions, CreateNewHeadObs, ReadLayerProportion, ReadITT,
    ReadHeadObsTime, ReadNewHufParameter, ReadNewHufCluster, NewArrayInstance,
    ReadNewFHB_Flow, ReadNewFHB_Head, CreateNewHfbParameter, ReadNewHFB,
    ReadCurrentHfbParameter, CopyParameters;
begin
end.
