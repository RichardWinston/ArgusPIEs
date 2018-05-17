library Utility;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

{%ToDo 'Utility.todo'}

uses
  FastMM4 in '..\shared\FastMM4.pas',
  SysUtils,
  Classes,
  NodeUnit in 'NodeUnit.pas' {frmNodePosition},
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  ANECB in '..\shared\ANECB.pas',
  AnePIE in '..\shared\AnePIE.pas',
  ImportPIE in '..\shared\ImportPIE.pas',
  ImportContoursUnit in 'ImportContoursUnit.pas' {frmImportContours},
  ARGUSFORMUNIT in '..\shared\ARGUSFORMUNIT.pas' {ArgusForm},
  ANE_LayerUnit in '..\shared\ANE_LayerUnit.pas',
  CheckVersionFunction in '..\shared\CheckVersionFunction.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas',
  ExportProgressUnit in '..\shared\ExportProgressUnit.pas' {frmExportProgress},
  ImportPointsUnit in 'ImportPointsUnit.pas' {frmImportPoints},
  GetANEFunctionsUnit in 'GetANEFunctionsUnit.pas',
  WriteContourUnit in '..\shared\WriteContourUnit.pas' {frmWriteContour},
  ChooseLayerUnit in '..\shared\ChooseLayerUnit.pas' {frmChooseLayer},
  PointContourUnit in '..\shared\PointContourUnit.pas',
  MeshToContour in 'MeshToContour.pas' {frmMeshToContour},
  frmZoomUnit in 'frmZoomUnit.pas' {frmZoom},
  frmEditUnit in 'frmEditUnit.pas' {frmEditNew},
  frmDataValuesUnit in 'frmDataValuesUnit.pas' {frmDataValues},
  frmDataEditUnit in 'frmDataEditUnit.pas' {frmDataEdit},
  frmDataLayerNameUnit in 'frmDataLayerNameUnit.pas' {frmDataLayerName},
  EditDatLayerUnit in 'EditDatLayerUnit.pas',
  RealListUnit in '..\shared\RealListUnit.pas',
  FixNameUnit in '..\shared\FixNameUnit.pas',
  SetRowColumnConstantWidths in 'SetRowColumnConstantWidths.pas' {frmSetRowColumnConstantWidths},
  frmEditGridUnit in 'frmEditGridUnit.pas' {frmEditGrid},
  frmGridTypeUnit in 'frmGridTypeUnit.pas' {frmGridType},
  RowColPositionsUnit in 'RowColPositionsUnit.pas',
  RowColumnDivision in 'RowColumnDivision.pas' {frmRowColumnDivision},
  RowColumnFrameUnit in 'RowColumnFrameUnit.pas' {FramePosition: TFrame},
  EditGridFunctions in 'EditGridFunctions.pas',
  frmAboutUnit in 'frmAboutUnit.pas' {frmAbout},
  frmGetLayerNamesUnit in 'frmGetLayerNamesUnit.pas' {frmGetLayerNames},
  GridUnit in 'GridUnit.pas' {frmGrid},
  IntListUnit in '..\shared\IntListUnit.pas',
  LayerNamePrompt in '..\shared\LayerNamePrompt.pas' {frmLayerNamePrompt},
  DeclutterUnit in 'DeclutterUnit.pas' {DeclutterForm},
  JoinUnit in 'JoinUnit.pas' {JoinContoursForm},
  JpegChoicesUnit in 'JpegChoicesUnit.pas' {frmJpegChoices},
  frmDataPositionUnit in 'frmDataPositionUnit.pas' {frmDataPosition},
  frmSamplePoints_Unit in 'frmSamplePoints_Unit.pas' {frmSamplePoints},
  frmLayerNameUnit in 'frmLayerNameUnit.pas' {frmLayerName},
  CentralMeridianUnit in 'CentralMeridianUnit.pas' {frmCentralMeridian},
  TreeUnit in 'TreeUnit.pas' {frmTree},
  frmAddParametersUnit in 'frmAddParametersUnit.pas' {frmAddParameters},
  frmSetParamLockUnit in 'frmSetParamLockUnit.pas' {frmSetParamLock},
  frmDeleteLayerUnit in 'frmDeleteLayerUnit.pas' {frmDeleteLayer},
  conversionFunctionUnit in 'conversionFunctionUnit.pas',
  EvalAtFunctionUnit in 'EvalAtFunctionUnit.pas',
  CheckPIEVersionFunction in '..\shared\CheckPIEVersionFunction.pas',
  RotatedCellsFunctionUnit in 'RotatedCellsFunctionUnit.pas',
  frmSelectParameterUnit in 'frmSelectParameterUnit.pas' {frmSelectParameter},
  InterpolationPIE in '..\shared\InterpolationPIE.pas',
  QT_Nearest in 'QT_Nearest.pas',
  frmEditChoices in 'frmEditChoices.pas' {frmEdit},
  frmImportChoicesUnit in 'frmImportChoicesUnit.pas' {frmImportChoices},
  frmConvertChoicesUnit in 'frmConvertChoicesUnit.pas' {frmConvertChoices},
  frmMeshLayerChoiceUnit in 'frmMeshLayerChoiceUnit.pas' {frmMeshLayerChoice},
  frmMoveUnit in 'frmMoveUnit.pas' {frmMove},
  ReverseUnit in 'ReverseUnit.pas',
  frmPasteContoursUnit in 'frmPasteContoursUnit.pas' {frmPasteContours},
  frmPreviewUnit in 'frmPreviewUnit.pas' {frmPreview},
  frmDependsOnUnit in 'frmDependsOnUnit.pas' {frmDependsOn},
  icnorm in 'icnorm.pas',
  frmDEM_Unit in 'frmDEM_Unit.pas' {frmDEM2BMP},
  QSHEP2D_p in 'QSHEP2D_p.pas',
  ShepardInterpolation in 'ShepardInterpolation.pas',
  ColorSchemes in '..\shared\ColorSchemes.pas',
  frmImportShapeUnit in 'frmImportShapeUnit.pas' {frmImportShape},
  ReadShapeFileUnit in '..\shared\ReadShapeFileUnit.pas',
  CoordinateConversionUnit in 'CoordinateConversionUnit.pas',
  frmSampleUnit in 'frmSampleUnit.pas' {frmSample},
  FastMM4Messages in '..\shared\FastMM4Messages.pas',
  frmImportRasterDataUnit in 'frmImportRasterDataUnit.pas' {frmImportRasterData},
  hh_funcs in '..\shared\hh_funcs.pas',
  hh in '..\shared\hh.pas',
  TempFiles in '..\shared\TempFiles.pas',
  TripackTypes in '..\shared\TripackTypes.pas',
  TripackProcedures in '..\shared\TripackProcedures.pas',
  FastGEO in '..\shared\FastGEO.pas',
  SfrInterpolatorUnit in '..\shared\SfrInterpolatorUnit.pas',
  SfrProcedures in '..\shared\SfrProcedures.pas',
  TriangleInterpolate in 'TriangleInterpolate.pas';

{$R *.RES}

// The following option requires D6 or greater.
// It allows FastMM to use additional memory.
{$SetPEFlags $20}

exports
  GetANEFunctions index 1;
begin
  {$ifdef MEMCHECK}
//  MemChk;
  {$endif}
end.
