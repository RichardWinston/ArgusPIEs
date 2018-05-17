library Triangle;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

{%ToDo 'Triangle.todo'}

uses
  SysUtils,
  Classes,
  GetANEFunctionsUnit in 'GetANEFunctionsUnit.pas',
  TriangulationUnit in 'TriangulationUnit.pas',
  TurnDir in 'TurnDir.pas',
  DelaunayUnit in 'DelaunayUnit.pas',
  Determ in 'Determ.pas',
  ConvexHullUnit in 'ConvexHullUnit.pas',
  AnePIE in '..\shared\Anepie.pas',
  InterpolationPIE in '..\shared\InterpolationPIE.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas';

{$R *.RES}

exports
  GetANEFunctions index 1;
begin
end.
