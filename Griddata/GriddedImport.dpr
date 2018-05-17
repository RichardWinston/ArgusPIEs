library GriddedImport;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

// Save TD32 information and use Borland Turbo debugger to debug.
// (Project|Options|Linker|Include TD32 debug information)
// Start Turbo Debugger32
// Click F3 and enter the name of your dll.
// Start Argus ONE.
// After Argus ONE has started, attach to ArgusONE.dll.
// From the File menu change to the directory with the source code of the PIE.
// Click F3 and double click on your dll
// Click F3 again and load the source files.
// You can now set breakpoints in the dll.

uses
  SysUtils,
  Classes,
  ImportUnit in 'ImportUnit.pas',
  AnePIE in '..\shared\AnePIE.pas',
  ANECB in '..\shared\ANECB.pas',
  ImportPIE in '..\shared\ImportPIE.pas',
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas',
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  IntListUnit in '..\shared\IntListUnit.pas',
  ArgusFormUnit in '..\shared\ARGUSFORMUNIT.pas' {ArgusForm},
  ANE_LayerUnit in '..\shared\ANE_LayerUnit.pas',
  CheckVersionFunction in '..\shared\CheckVersionFunction.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  ExportProgressUnit in '..\shared\ExportProgressUnit.pas' {frmExportProgress},
  LayerNamePrompt in '..\shared\LayerNamePrompt.pas' {frmLayerNamePrompt},
  FixNameUnit in '..\shared\FixNameUnit.pas',
  GridUnit in 'GridUnit.pas' {frmGrid};

{$R *.RES}
  
exports
  GetANEFunctions index 1;
begin
end.
