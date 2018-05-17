library ProgressBar;

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
  ProgressBarUnit in 'ProgressBarUnit.pas' {ProgressBarForm},
  functionUnit in 'functionUnit.pas',
  ANECB in '..\shared\ANECB.pas',
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  ANE_LayerUnit in '..\shared\ANE_LayerUnit.pas',
  CheckVersionFunction in '..\shared\CheckVersionFunction.pas',
  CheckPIEVersionFunction in '..\shared\CheckPIEVersionFunction.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  AnePIE in '..\shared\AnePIE.pas',
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas',
  FixNameUnit in '..\shared\FixNameUnit.pas',
  FastMM4Messages in '..\shared\FastMM4Messages.pas';

{$R *.RES}

// The following option requires D6 or greater.
// It allows FastMM to use additional memory.
{$SetPEFlags $20}
  
  exports
  GetANEFunctions ;

begin
end.
