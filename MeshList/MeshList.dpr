library MeshList;

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
  MemCheck in '..\shared\MemCheck.pas',
  SysUtils,
  Classes,
  GetAneFunctionsUnit in 'GetAneFunctionsUnit.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  Anepie in '..\shared\Anepie.pas',
  ANECB in '..\shared\ANECB.pas',
  ReadMeshUnit in 'ReadMeshUnit.pas',
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas',
  ParamNamesAndTypes in '..\shared\ParamNamesAndTypes.pas',
  ReadContoursUnit in 'ReadContoursUnit.pas',
  RangeTreeUnit in 'RangeTreeUnit.pas',
  RangeUnit in 'RangeUnit.pas',
  ContourIntersection in 'ContourIntersection.pas',
  IntListUnit in '..\shared\IntListUnit.pas',
  PlaneGeom in '..\shared\PlaneGeom.pas',
  FastGEO in '..\shared\FastGEO.pas',
  RealListUnit in '..\shared\RealListUnit.pas';

{$R *.RES}

exports
  GetANEFunctions;

begin
  MemChk;
end.
