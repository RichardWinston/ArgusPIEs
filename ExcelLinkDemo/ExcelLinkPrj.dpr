library ExcelLinkPrj;

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

{
  See comments in Variables.pas for important infomation on how to customize
  this PIE.
}
uses
  SysUtils,
  Classes,
  ProjectPIE in 'ProjectPIE.pas',
  GetANEFunctionsUnit in 'GetANEFunctionsUnit.pas',
  FunctionPIE in 'FunctionPIE.pas',
  ParamArrayUnit in 'ParamArrayUnit.pas',
  ProjectFunctions in 'ProjectFunctions.pas',
  ParamNamesAndTypes in 'ParamNamesAndTypes.pas',
  ExportTemplatePIE in 'ExportTemplatePIE.pas',
  ImportPIE in 'ImportPIE.pas',
  ExcelLink in 'ExcelLink.pas' {frmExcelLink},
  Ads_DB in 'ads_db.pas',
  ads_excel in 'ads_excel.pas',
  Ads_Misc in 'ads_misc.pas',
  Ads_Strg in 'ads_strg.pas',
  ANECB in 'ANECB.pas',
  AnePIE in 'AnePIE.pas',
  ANE_LayerUnit in 'ANE_LayerUnit.pas',
  UtilityFunctions in 'UtilityFunctions.pas',
  CheckVersionFunction in 'CheckVersionFunction.pas',
  StringPIEFunctions in 'StringPIEFunctions.pas';

// The following compiler directive must be added manually to allow inclusion
// of version information in the PIE.
{$R *.RES}

  exports GetANEFunctions index 1;
begin
end.
