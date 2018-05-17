library Correlation;

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
  OptionsUnit in '..\shared\OptionsUnit.pas',
  AnePIE in '..\shared\Anepie.pas',
  ANECB in '..\shared\ANECB.pas',
  ImportPIE in '..\shared\ImportPIE.pas',
  frmCorrelationUnit in 'frmCorrelationUnit.pas' {frmCorrelation},
  ArgusFormUnit in '..\shared\ARGUSFORMUNIT.pas' {ArgusForm},
  GetANEFunctionsUnit in 'GetANEFunctionsUnit.pas',
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  ExportProgressUnit in '..\shared\ExportProgressUnit.pas' {frmExportProgress},
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas';

{$R *.RES}

  exports
  GetANEFunctions ;

begin
end.
