library MultipleDelete;

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
  AnePIE in 'AnePIE.pas',
  ImportPIE in 'ImportPIE.pas',
  ParamArrayUnit in 'ParamArrayUnit.pas',
  ParamNamesAndTypes in 'ParamNamesAndTypes.pas',
  CheckVersionFunction in 'CheckVersionFunction.pas',
  FunctionPIE in 'FunctionPIE.pas',
  FixNameUnit in 'FixNameUnit.pas',
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ANECB in '..\shared\ANECB.pas',
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  frmDeleteLayerUnit in 'frmDeleteLayerUnit.pas' {frmDeleteLayer};

exports
  GetANEFunctions index 1;

begin
end.
