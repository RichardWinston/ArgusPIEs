library ParamSet;

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
  frmAddParametersUnit in 'frmAddParametersUnit.pas' {frmAddParameters},
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ANECB in '..\shared\ANECB.pas',
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  ANE_LayerUnit in '..\shared\ANE_LayerUnit.pas',
  AnePIE in '..\shared\AnePIE.pas',
  FixNameUnit in '..\shared\FixNameUnit.pas',
  ImportPIE in '..\shared\ImportPIE.pas',
  CheckVersionFunction in '..\shared\CheckVersionFunction.pas',
  TreeUnit in 'TreeUnit.pas' {frmTree},
  frmSetParamLockUnit in 'frmSetParamLockUnit.pas' {frmSetParamLock};

// The following compiler directive must be added manually to allow inclusion
// of version information in the PIE.
{$R *.RES}

exports
  GetANEFunctions index 1;

begin
end.
