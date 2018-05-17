library EditContoursPie;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

{%ToDo 'EditContoursPie.todo'}

uses
  SysUtils,
  Classes,
  NodeUnit in 'NodeUnit.pas' {frmNodePosition},
  UtilityFunctions in '..\shared\UtilityFunctions.pas',
  ANECB in '..\shared\ANECB.pas',
  AnePIE in '..\shared\AnePIE.pas',
  ImportPIE in '..\shared\ImportPIE.pas',
  ImportContoursUnit in 'ImportContoursUnit.pas' {frmImportContours},
  ArgusFormUnit in '..\shared\ARGUSFORMUNIT.pas' {ArgusForm},
  ANE_LayerUnit in '..\shared\ANE_LayerUnit.pas',
  CheckVersionFunction in '..\shared\CheckVersionFunction.pas',
  FunctionPIE in '..\shared\FunctionPIE.pas',
  OptionsUnit in '..\shared\OptionsUnit.pas',
  ParamArrayUnit in '..\shared\ParamArrayUnit.pas',
  ExportProgressUnit in '..\shared\ExportProgressUnit.pas' {frmExportProgress},
  ImportPointsUnit in 'ImportPointsUnit.pas' {frmImportPoints},
  GetANEFunctionsUnit in 'GetANEFunctionsUnit.pas',
  WriteContourUnit in '..\shared\WriteContourUnit.pas' {frmWriteContour},
  ChooseLayerUnit in '..\shared\ChooseLayerUnit.pas' {frmChooseLayer},
  PointContourUnit in '..\shared\PointContourUnit.pas',
  MeshToContour in 'MeshToContour.pas' {frmMeshToContour},
  frmZoomUnit in 'frmZoomUnit.pas' {frmZoom},
  frmEditUnit in 'frmEditUnit.pas' {frmEditNew};

{$R *.RES}

exports
  GetANEFunctions index 1;
begin
end.
