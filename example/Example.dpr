library Example;

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
  PieUnit in 'PieUnit.pas',
  AnePIE in '..\shared\Anepie.pas',
  ImportPIE in '..\shared\ImportPIE.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  InterpolationPIE in '..\shared\InterpolationPIE.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas',
  ParamNamesAndTypes in '..\shared\ParamNamesAndTypes.pas',
  ImportExample in 'ImportExample.pas' {frmImportExample},
  ANECB in '..\shared\ANECB.pas';

{
HOW TO DEBUG A PIE.

1. Create a subdirectory under "Argus Interware\DatFile" named "ArgusPIE".
   Create the PIE in a subdirectory of that ArgusPIE directory.
2. In the "Argus Interware\DatFile" directory, make a copy of "ArgusONE.dll".
3. Rename the copy "ArgusONE.exe".
4. Compile the PIE.
5. Select "Run|Add Breakpoint|Module Load Breakpoint".
6. In the dialog box, browse to the location of the dll and select it.  Then
   close the dialog box.
7. Select "Run|Parameters" and in "Host Application" browse to the location of
   the copy of ArgusONE.exe created in step 3.  Then click the OK button.
8. Select "Run|Parameters" again and click the "Load" button.
9. Set other breakpoints as normal.

}


{$R *.RES}

// Export GetANEFunctions so Argus ONE can call it.
exports
  GetANEFunctions index 1;

begin
end.
