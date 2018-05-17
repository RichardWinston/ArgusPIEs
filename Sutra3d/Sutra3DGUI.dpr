library Sutra3DGUI;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{%ToDo 'Sutra3DGUI.todo'}

uses
  FastMM4 in '..\shared\FastMM4.pas',
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
  IntListUnit in '..\shared\IntListUnit.pas',
  SLMorphLayer in 'SLMorphLayer.pas',
  SLGeoUnit in 'SLGeoUnit.pas',
  VirtualMeshUnit in 'VirtualMeshUnit.pas',
  SegmentUnit in '..\shared\SegmentUnit.pas',
  TriangleUnit in '..\shared\TriangleUnit.pas',
  VertexUnit in '..\shared\VertexUnit.pas',
  VirtualMeshFunctions in 'VirtualMeshFunctions.pas',
  ParamNamesAndTypes in '..\shared\ParamNamesAndTypes.pas',
  SutraVertMeshCount in 'SutraVertMeshCount.pas',
  RealListUnit in '..\shared\RealListUnit.pas',
  doublePolyhedronUnit in '..\shared\doublePolyhedronUnit.pas',
  SolidGeom in '..\shared\SolidGeom.pas',
  SolidUnit in '..\shared\SolidUnit.pas',
  SourcesOfFluidFunctions in 'SourcesOfFluidFunctions.pas',
  VirtMeshUtilFunctions in 'VirtMeshUtilFunctions.pas',
  SourcesOfSoluteFunctions in 'SourcesOfSoluteFunctions.pas',
  OverriddenArrayUnit in 'OverriddenArrayUnit.pas',
  ZFunction in 'ZFunction.pas',
  SpecifiedPressFunctions in 'SpecifiedPressFunctions.pas',
  BoundaryNodeFunction in 'BoundaryNodeFunction.pas',
  SpecifiedConcTempFunctions in 'SpecifiedConcTempFunctions.pas',
  UnsatZoneFunctions in 'UnsatZoneFunctions.pas',
  ObservationFunctions in 'ObservationFunctions.pas',
  BoundaryContourUnit in 'BoundaryContourUnit.pas',
  FishnetContourUnit in 'FishnetContourUnit.pas',
  SuperfishUnit in 'SuperfishUnit.pas',
  NodeElementUnit in 'NodeElementUnit.pas',
  SurfaceEdit in 'SurfaceEdit.pas' {frmSurfaceEdit},
  PointEditUnit in 'PointEditUnit.pas' {frmPointEdit},
  LayerSelectUnit in 'LayerSelectUnit.pas' {frmLayerSelect},
  SurfaceEditPIE in 'SurfaceEditPIE.pas',
  UpdateOldFiles in 'UpdateOldFiles.pas',
  SLCustomLayers in 'SLCustomLayers.pas',
  DefaultValueFrame in 'DefaultValueFrame.pas' {FrmDefaultValue: TFrame},
  SutraHelp in 'SutraHelp.pas',
  S_Stream in 'S_stream.pas',
  S_Huge in 'S_huge.pas',
  S_StrRes in 'S_strres.pas',
  S_String in 'S_string.pas',
  S_Consts in 'S_consts.pas',
  NumberStream in 'NumberStream.pas',
  ReadDataSet3Unit in 'ReadDataSet3Unit.pas',
  ReadOldICSUnit in 'ReadOldICSUnit.pas',
  DecayConstCalculator in 'DecayConstCalculator.pas' {frmDecayConstCalculator},
  DebugUnit in '..\shared\DebugUnit.pas',
  Get3DElementValue in 'Get3DElementValue.pas',
  frmNodeNumberConvertUnit in 'frmNodeNumberConvertUnit.pas' {frmNodeNumConvert},
  framFilePathUnit in '..\shared\framFilePathUnit.pas' {framFilePath: TFrame},
  SLSutraMeshGeoUnit in 'SLSutraMeshGeoUnit.pas',
  frmParameterValuesUnit in 'frmParameterValuesUnit.pas' {frmParameterValues},
  WriteContourUnit in '..\shared\WriteContourUnit.pas' {frmWriteContour},
  frmSutraContourImporterUnit in 'frmSutraContourImporterUnit.pas' {frmSutraContourImporter},
  PointContourUnit in '..\shared\PointContourUnit.pas',
  ChooseLayerUnit in '..\shared\ChooseLayerUnit.pas' {frmChooseLayer},
  UcodeParameterFunctions in 'UcodeParameterFunctions.pas',
  frmSutraPriorEquationEditorUnit in 'frmSutraPriorEquationEditorUnit.pas' {frmSutraPriorEquationEditor},
  frmChangeValuesUnit in 'frmChangeValuesUnit.pas' {frmChangeValues},
  FastMM4Messages in '..\shared\FastMM4Messages.pas',
  hh_funcs in '..\shared\hh_funcs.pas',
  hh in '..\shared\hh.pas',
  UcodeParser in 'UcodeParser.pas',
  frmEquationEditorUnit in 'frmEquationEditorUnit.pas' {frmEquationEditor},
  UcodePriorInfoFunctions in 'UcodePriorInfoFunctions.pas',
  SLUcodeFactors in 'SLUcodeFactors.pas',
  SLSpecificHeat in 'SLSpecificHeat.pas',
  SLThermalConductivity in 'SLThermalConductivity.pas',
  frameUnSatUnit in 'frameUnSatUnit.pas' {frameUnsat: TFrame},
  framePermUnit in 'framePermUnit.pas' {framePerm: TFrame},
  frameIceSatUnit in 'frameIceSatUnit.pas' {frameIceSat: TFrame},
  frameRegionParamsUnit in 'frameRegionParamsUnit.pas' {frameRegionParams: TFrame};

// The following compiler directive must be added manually to allow inclusion
// of version information in the PIE.
{$R *.RES}

// The following option requires D6 or greater.
// It allows FastMM to use additional memory.
{$SetPEFlags $20}

  exports GetANEFunctions index 1;
begin
  {$ifdef MEMCHECK}
//  MemChk;
  {$endif}
end.
