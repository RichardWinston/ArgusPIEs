library BlockList;

{purpose: to illustrate how to create a function PIE.}

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
  BlockListUnit in 'BlockListUnit.pas',
  CellVertexUnit in 'CellVertexUnit.pas',
  GetAneFunctionsUnit in 'GetAneFunctionsUnit.pas',
  FreeBlockUnit in 'FreeBlockUnit.pas',
  FreeVertexUnit in 'FreeVertexUnit.pas',
  CombinedListUnit in 'CombinedListUnit.pas',
  GetCellVertexUnit in 'GetCellVertexUnit.pas',
  GetCellUnit in 'GetCellUnit.pas',
  InitializeBlockUnit in 'InitializeBlockUnit.pas',
  InitializeVertexUnit in 'InitializeVertexUnit.pas',
  CrossRowUnit in 'CrossRowUnit.pas',
  CrossColumnUnit in 'CrossColumnUnit.pas',
  InitializeLists in 'InitializeLists.pas',
  GridUnit in 'GridUnit.pas',
  PointInsideContourUnit in 'PointInsideContourUnit.pas',
  GetFractionUnit in 'GetFractionUnit.pas',
  ExceptionCounUnit in 'ExceptionCounUnit.pas',
  CheckPIEVersionFunction in '..\shared\CheckPIEVersionFunction.pas',
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  ANE_LayerUnit in '..\shared\ANE_LayerUnit.pas',
  CheckVersionFunction in '..\shared\CheckVersionFunction.pas',
  ANECB in '..\shared\ANECB.pas',
  AnePIE in '..\shared\AnePIE.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  BL_SegmentUnit in 'BL_SegmentUnit.pas',
  SegmentUnit in '..\shared\SegmentUnit.pas',
  VertexUnit in '..\shared\VertexUnit.pas',
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas';

{$R *.RES}
  exports
  GetANEFunctions ;
begin
end.
