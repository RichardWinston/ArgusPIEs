library EditDataLayer;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

{
  Debugging Techniques:

  1.
  Save TD32 information and use Borland Turbo debugger to debug.
  (Project|Options|Linker|Include TD32 debug information)
  Start Turbo Debugger32
  Click F3 and enter the name of your dll.
  Start Argus ONE.
  After Argus ONE has started, attach to ArgusONE.dll.
  From the File menu change to the directory with the source code of the PIE.
  Click F3 and double click on your dll
  Click F3 again and load the source files.
  You can now set breakpoints in the dll.

  2.
  Delphi3: Make a copy of ArgusONE.dll and rename it ArgusONE.exe.
  (Do not overwrite the original ArgusONE.exe)
  Place the new ArgusONE.EXE in the DatFiles directory
  Make a directory named ArgusPIE under the DatFiles directory
  Put the PIE to be debugged in the new ArgusPIE directory
  Debug as normal with the integrated debugger using the new version of
  ArgusONE as the host application.

  Delphi4: Make a copy of ArgusONE.dll and rename it ArgusONE.exe.
  (Do not overwrite the original ArgusONE.exe)
  Place the new ArgusONE.EXE in the DatFiles directory
  Make a directory named ArgusPIE under the DatFiles directory
  Put the PIE to be debugged in the new ArgusPIE directory (or a subdirectory
  of it).
    Select Run Parameters and select the version of Argus ONE that is in the
  DatFiles directory. Click the Load button to start the program.
  Select "Run|Add Breakpoint|module load breakpoint" and select the
  dll to debug. Set additional breakpoints as desired.
  Click the run button to start the program
}

uses
  SysUtils,
  Classes,
  ImportUnit in 'ImportUnit.pas',
  ImportPIE in '..\shared\ImportPIE.pas',
  AnePIE in '..\shared\AnePIE.pas',
  ANECB in '..\shared\ANECB.pas',
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas',
  ArgusFormUnit in '..\SHARED\ARGUSFORMUNIT.pas' {ArgusForm},
  frmDataEditUnit in 'frmDataEditUnit.pas' {frmDataEdit},
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  ExportProgressUnit in '..\shared\ExportProgressUnit.pas' {frmExportProgress},
  RealListUnit in '..\shared\RealListUnit.pas',
  frmDataValuesUnit in 'frmDataValuesUnit.pas' {frmDataValues},
  ANE_LayerUnit in '..\shared\ANE_LayerUnit.pas',
  CheckVersionFunction in '..\shared\CheckVersionFunction.pas',
  frmDataLayerNameUnit in 'frmDataLayerNameUnit.pas' {frmDataLayerName},
  FixNameUnit in '..\shared\FixNameUnit.pas',
  WriteContourUnit in '..\shared\WriteContourUnit.pas' {frmWriteContour},
  PointContourUnit in '..\shared\PointContourUnit.pas',
  ChooseLayerUnit in '..\shared\ChooseLayerUnit.pas' {frmChooseLayer};

// The following compiler directive is required to allow inclusion
// of version information in the PIE.
{$R *.RES}

exports
  GetANEFunctions index 1;
begin
end.
