library DEM_Import;

uses
  Forms,
  frmDEM_Unit in 'frmDEM_Unit.pas' {frmDEM2BMP},
  RealListUnit in 'RealListUnit.pas',
  CentralMeridianUnit in 'CentralMeridianUnit.pas' {frmCentralMeridian},
  AboutUnit in 'AboutUnit.pas' {frmAbout},
  GetANEFunctionsUnit in 'GetANEFunctionsUnit.pas',
  AnePIE in '..\shared\AnePIE.pas',
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ArgusFormUnit in '..\shared\ARGUSFORMUNIT.pas' {ArgusForm},
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  ANECB in '..\shared\ANECB.pas',
  ExportProgressUnit in '..\shared\ExportProgressUnit.pas' {frmExportProgress},
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas',
  ImportPIE in '..\shared\ImportPIE.pas',
  frmLayerNameUnit in 'frmLayerNameUnit.pas' {frmLayerName},
  frmDataPositionUnit in 'frmDataPositionUnit.pas' {frmDataPosition},
  ANE_LayerUnit in '..\shared\ANE_LayerUnit.pas',
  CheckVersionFunction in '..\shared\CheckVersionFunction.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  LayerNamePrompt in '..\shared\LayerNamePrompt.pas' {frmLayerNamePrompt},
  FixNameUnit in '..\shared\FixNameUnit.pas',
  JpegChoicesUnit in 'JpegChoicesUnit.pas' {frmJpegChoices};

{$R *.RES}

exports
  GetANEFunctions index 1;
begin
end.
