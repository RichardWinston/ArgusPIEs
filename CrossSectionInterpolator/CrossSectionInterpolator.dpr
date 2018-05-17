library CrossSectionInterpolator;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{%File 'ModelSupport\frmFileSelectionUnit\frmFileSelectionUnit.txvpck'}
{%File 'ModelSupport\FiniteElemInterp\FiniteElemInterp.txvpck'}
{%File 'ModelSupport\OptionsUnit\OptionsUnit.txvpck'}
{%File 'ModelSupport\ArgusFormUnit\ArgusFormUnit.txvpck'}
{%File 'ModelSupport\CheckVersionFunction\CheckVersionFunction.txvpck'}
{%File 'ModelSupport\frmImportCrossSectionUnit\frmImportCrossSectionUnit.txvpck'}
{%File 'ModelSupport\ReadShapeFileUnit\ReadShapeFileUnit.txvpck'}
{%File 'ModelSupport\ImportPIE\ImportPIE.txvpck'}
{%File 'ModelSupport\CalculateSutraAngles\CalculateSutraAngles.txvpck'}
{%File 'ModelSupport\GetAneFunctionsUnit\GetAneFunctionsUnit.txvpck'}
{%File 'ModelSupport\FunctionPIE\FunctionPIE.txvpck'}
{%File 'ModelSupport\AnePIE\AnePIE.txvpck'}
{%File 'ModelSupport\ParamArrayUnit\ParamArrayUnit.txvpck'}
{%File 'ModelSupport\UtilityFunctions\UtilityFunctions.txvpck'}
{%File 'ModelSupport\ParamNamesAndTypes\ParamNamesAndTypes.txvpck'}
{%File 'ModelSupport\ANECB\ANECB.txvpck'}
{%File 'ModelSupport\RangeTreeUnit\RangeTreeUnit.txvpck'}
{%File 'ModelSupport\ColorSchemes\ColorSchemes.txvpck'}
{%File 'ModelSupport\FixNameUnit\FixNameUnit.txvpck'}
{%File 'ModelSupport\LayerNamePrompt\LayerNamePrompt.txvpck'}
{%File 'ModelSupport\ANE_LayerUnit\ANE_LayerUnit.txvpck'}
{%File 'ModelSupport\ExportProgressUnit\ExportProgressUnit.txvpck'}
{%File 'ModelSupport\default.txvpck'}

uses
  SysUtils,
  Classes,
  Anepie in '..\shared\Anepie.pas',
  ANECB in '..\shared\ANECB.pas',
  ImportPIE in '..\shared\ImportPIE.pas',
  GetAneFunctionsUnit in 'GetAneFunctionsUnit.pas',
  FiniteElemInterp in '..\shared\FiniteElemInterp.pas',
  ARGUSFORMUNIT in '..\shared\ARGUSFORMUNIT.pas' {ArgusForm},
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  ExportProgressUnit in '..\shared\ExportProgressUnit.pas' {frmExportProgress},
  frmImportCrossSectionUnit in 'frmImportCrossSectionUnit.pas' {frmImportCrossSection},
  ReadShapeFileUnit in '..\shared\ReadShapeFileUnit.pas',
  frmFileSelectionUnit in 'frmFileSelectionUnit.pas' {frmFileSelection},
  RangeTreeUnit in '..\shared\RangeTreeUnit.pas',
  ColorSchemes in '..\shared\ColorSchemes.pas',
  ANE_LayerUnit in '..\shared\ANE_LayerUnit.pas',
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas',
  CheckVersionFunction in '..\shared\CheckVersionFunction.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  FixNameUnit in '..\shared\FixNameUnit.pas',
  LayerNamePrompt in '..\shared\LayerNamePrompt.pas' {frmLayerNamePrompt},
  CalculateSutraAngles in 'CalculateSutraAngles.pas',
  ParamNamesAndTypes in '..\shared\ParamNamesAndTypes.pas';

{$R *.res}

exports
  GetANEFunctions;

begin
end.
