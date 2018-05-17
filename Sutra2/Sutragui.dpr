library SutraGUI;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  ARGUSFORMUNIT in '..\shared\ARGUSFORMUNIT.pas' {ArgusForm},
  frmSutraUnit in 'frmSutraUnit.pas' {frmSutra},
  AnePIE in '..\shared\AnePIE.pas',
  ANE_LayerUnit in '..\shared\ANE_LayerUnit.pas',
  ANECB in '..\shared\ANECB.pas',
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  CheckVersionFunction in '..\shared\CheckVersionFunction.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  ExportProgressUnit in '..\shared\ExportProgressUnit.pas' {frmExportProgress},
  ReadOldSutra in 'ReadOldSutra.pas',
  ProjectFunctions in 'ProjectFunctions.pas',
  GlobalVariables in 'GlobalVariables.pas',
  GetANEFunctionsUnit in 'GetANEFunctionsUnit.pas',
  SutraPIEFunctions in 'SutraPIEFunctions.pas',
  CustomizedSutraPieFunctions in 'CustomizedSutraPieFunctions.pas',
  ProjectPIE in '..\shared\ProjectPIE.pas',
  SutraPIEDescriptors in 'SutraPIEDescriptors.pas',
  ExportTemplatePIE in '..\shared\ExportTemplatePIE.pas',
  ImportPIE in '..\shared\ImportPIE.pas',
  SLGroupLayers in 'SLGroupLayers.pas',
  SLFishnetMeshLayout in 'SLFishnetMeshLayout.pas',
  SLDomainDensity in 'SLDomainDensity.pas',
  SLObservation in 'SLObservation.pas',
  SLThickness in 'SLThickness.pas',
  SLPorosity in 'SLPorosity.pas',
  SLPermeability in 'SLPermeability.pas',
  SLDispersivity in 'SLDispersivity.pas',
  SLUnsaturated in 'SLUnsaturated.pas',
  SLSourcesOfFluid in 'SLSourcesOfFluid.pas',
  SLEnergySoluteSources in 'SLEnergySoluteSources.pas',
  SLGeneralParameters in 'SLGeneralParameters.pas',
  SLSpecifiedPressure in 'SLSpecifiedPressure.pas',
  SLSpecConcOrTemp in 'SLSpecConcOrTemp.pas',
  SLInitialPressure in 'SLInitialPressure.pas',
  SLInitConcOrTemp in 'SLInitConcOrTemp.pas',
  SLMap in 'SLMap.pas',
  SLDataLayer in 'SLDataLayer.pas',
  SLSutraMesh in 'SLSutraMesh.pas',
  SLLayerStructure in 'SLLayerStructure.pas',
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas',
  RunsutraUnit in 'RunsutraUnit.pas' {frmRun},
  WarningsUnit in '..\shared\WarningsUnit.pas' {frmWarnings},
  PostSutraUnit in 'PostSutraUnit.pas' {frmPostSutra},
  GetListViewCellStringUnit in '..\shared\GetListViewCellStringUnit.pas',
  FixNameUnit in '..\shared\FixNameUnit.pas',
  LayerNamePrompt in '..\shared\LayerNamePrompt.pas' {frmLayerNamePrompt},
  WriteSutraPostProcessingUnit in 'WriteSutraPostProcessingUnit.pas',
  IntListUnit in '..\shared\IntListUnit.pas';

// The following compiler directive must be added manually to allow inclusion
// of version information in the PIE.
{$R *.RES}

  exports GetANEFunctions index 1;
begin
end.
