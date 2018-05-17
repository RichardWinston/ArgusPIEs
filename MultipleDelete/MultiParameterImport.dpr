library MultiParameterImport;

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
  GetANEFunc in 'GetANEFunc.pas',
  ANE_LayerUnit in 'ANE_LayerUnit.pas',
  ANECB in 'ANECB.pas',
  AnePIE in 'AnePIE.pas',
  ImportPIE in 'ImportPIE.pas',
  OptionsUnit in 'OptionsUnit.pas',
  ParamArrayUnit in 'ParamArrayUnit.pas',
  ParamNamesAndTypes in 'ParamNamesAndTypes.pas',
  UtilityFunctions in 'UtilityFunctions.pas',
  CheckVersionFunction in 'CheckVersionFunction.pas',
  FunctionPIE in 'FunctionPIE.pas',
  ChooseLayers in 'ChooseLayers.pas' {frmChooseLayer},
  FixNameUnit in 'FixNameUnit.pas';

exports  
  GetANEFunctions index 1;

begin
end.
