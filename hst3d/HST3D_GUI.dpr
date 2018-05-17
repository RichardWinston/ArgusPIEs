library HST3D_GUI;

{purpose: to illustrate how to display a form in a PIE.}

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }


uses
  FastMM4 in '..\shared\FastMM4.pas',
  SysUtils,
  Classes,
  ProjectPIE in 'ProjectPIE.pas',
  AnePIE in 'AnePIE.pas',
  ANECB in 'ANECB.pas',
  ANE_LayerUnit in 'ANE_LayerUnit.pas',
  CoordUnit in 'CoordUnit.pas' {CoordForm},
  HST3D_PIE_Unit in 'HST3D_PIE_Unit.pas',
  RunUnit in 'RunUnit.pas' {RunForm},
  ExportTemplatePIE in 'ExportTemplatePIE.pas',
  FunctionPIE in 'FunctionPIE.pas',
  TimeFunctionsUnit in 'TimeFunctionsUnit.pas',
  GeologyFunctionUnit in 'GeologyFunctionUnit.pas',
  HeatCondBoundFunctionsUnit in 'HeatCondBoundFunctionsUnit.pas',
  HST3DWellLayers in 'HST3DWellLayers.pas',
  HST3DDomainDensityLayers in 'HST3DDomainDensityLayers.pas',
  HST3DGeneralParameters in 'HST3DGeneralParameters.pas',
  HST3DGridLayer in 'HST3DGridLayer.pas',
  HST3DRiverLayers in 'HST3DRiverLayers.pas',
  HST3DInitialWatTabLayers in 'HST3DInitialWatTabLayers.pas',
  HST3DGroupLayers in 'HST3DGroupLayers.pas',
  HST3DActiveAreaLayers in 'HST3DActiveAreaLayers.pas',
  HST3DSpecifiedStateLayers in 'HST3DSpecifiedStateLayers.pas',
  HST3DInitialPressureLayers in 'HST3DInitialPressureLayers.pas',
  HST3DInitialTemp in 'HST3DInitialTemp.pas',
  HST3DInitialMassFracLayers in 'HST3DInitialMassFracLayers.pas',
  HST3DHeatCondLayers in 'HST3DHeatCondLayers.pas',
  HST3DSpecifiedFluxLayers in 'HST3DSpecifiedFluxLayers.pas',
  HST3DAquifLeakageLayers in 'HST3DAquifLeakageLayers.pas',
  HST3DEvapotranspirationLayers in 'HST3DEvapotranspirationLayers.pas',
  HST3DAquifInflLayers in 'HST3DAquifInflLayers.pas',
  HST3DPermeabilityLayers in 'HST3DPermeabilityLayers.pas',
  HST3DPorosityLayers in 'HST3DPorosityLayers.pas',
  HST3DVertCompLayers in 'HST3DVertCompLayers.pas',
  HST3DHeatCapacityLayers in 'HST3DHeatCapacityLayers.pas',
  HST3DThermCondLayers in 'HST3DThermCondLayers.pas',
  HST3DDispersivityLayers in 'HST3DDispersivityLayers.pas',
  HST3DDistCoefLayers in 'HST3DDistCoefLayers.pas',
  HST3DGeologyLayerList in 'HST3DGeologyLayerList.pas',
  HST3DLayerStructureUnit in 'HST3DLayerStructureUnit.pas',
  ProgressUnit in 'ProgressUnit.pas' {ProgressForm},
  FixNameUnit in 'FixNameUnit.pas',
  IntListUnit in 'IntListUnit.pas',
  PostProcessingUnit in 'PostProcessingUnit.pas' {frmPostProcessingForm},
  RealListUnit in 'RealListUnit.pas',
  ThreeDGriddedDataStorageUnit in 'ThreeDGriddedDataStorageUnit.pas',
  ThreeDIntListUnit in 'ThreeDIntListUnit.pas',
  ThreeDRealListUnit in 'ThreeDRealListUnit.pas',
  ImportPIE in 'ImportPIE.pas',
  WritePostProcessingUnit in 'WritePostProcessingUnit.pas',
  MonthlyDataImportUnit in 'MonthlyDataImportUnit.pas' {frmImport},
  ParseContourUnit in 'ParseContourUnit.pas',
  MonthlyDataUnit in 'MonthlyDataUnit.pas',
  TimeDataUnit in 'TimeDataUnit.pas',
  HST3DUnit in 'HST3DUnit.pas' {HST3DForm},
  ShowHelpUnit in 'ShowHelpUnit.pas',
  SolverFunctionsUnit in 'SolverFunctionsUnit.pas',
  HST3DBCFLOWUnit in 'HST3DBCFLOWUnit.pas',
  UtilityFunctions in 'UtilityFunctions.pas',
  HST3DPostProcessingLayers in 'HST3DPostProcessingLayers.pas',
  conversionsUnit in 'conversionsUnit.pas',
  WellFunctionsUnit in 'WellFunctionsUnit.pas',
  RotationCalculator in 'RotationCalculator.pas' {frmRotation},
  ParamNamesAndTypes in 'ParamNamesAndTypes.pas',
  HST3DObservationElevations in 'HST3DObservationElevations.pas',
  CreateObsGridUnit in 'CreateObsGridUnit.pas',
  EvaluateExpression in 'EvaluateExpression.pas',
  PostProcessingPIEUnit in 'PostProcessingPIEUnit.pas',
  TimeSeriesChart in 'TimeSeriesChart.pas' {frmTimeSeries},
  RenameUnit in 'RenameUnit.pas',
  CheckVersionFunction in 'CheckVersionFunction.pas',
  ConserveResourcesUnit in '..\shared\ConserveResourcesUnit.pas',
  FastMM4Messages in '..\shared\FastMM4Messages.pas';

{$R *.RES}


  exports GetANEFunctions;
begin
end.
