unit Main;

interface

uses
  ProjectPIE, AnePIE;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

implementation

uses ProjectFunctions, FunctionPIE, PieFunctionsUnit, ExportTemplatePIE;

const
  kMaxPIEDesc = 20;

var
  gExampleProjectPDesc : ProjectPIEDesc ;
  gExampleProjectDesc : ANEPIEDesc ;

  gNumUnitsFunctionPieDesc : FunctionPIEDesc;
  gNumUnitsPIEDesc : ANEPIEDesc ;

  gNumTimesFunctionPieDesc : FunctionPIEDesc;
  gNumTimesPIEDesc : ANEPIEDesc ;

  gRunExportPIEDesc : ExportTemplatePIEDesc;
  gRunPIEDesc : ANEPIEDesc ;

  gPIEDesc : Array [0..kMaxPIEDesc-1] of ^ANEPIEDesc;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
Const
  Project = 'Example Delphi Project' ;
begin
  numNames := 0;

  {$ASSERTIONS ON}
  {Assertions are a debugging tool. They should be turned off
  in the final version. They are useful for "Just-in-time" debugging
  with Turbo-Debugger 32. See Delphi help for more information.}

  gExampleProjectPDesc.version := PROJECT_PIE_VERSION;
  gExampleProjectPDesc.name := Project;
  gExampleProjectPDesc.projectFlags := kProjectShouldSave or kProjectCanEdit
    or kProjectShouldClean;
  gExampleProjectPDesc.createNewProc := GProjectNew;
  gExampleProjectPDesc.editProjectProc := GEditForm;
  gExampleProjectPDesc.cleanProjectProc := GClearForm;
  gExampleProjectPDesc.saveProc := GSaveForm;
  gExampleProjectPDesc.loadProc := GLoadForm;

  gExampleProjectDesc.version := ANE_PIE_VERSION;             // Function Pie version
  gExampleProjectDesc.name  := Project;
  gExampleProjectDesc.PieType :=  kProjectPIE;
  gExampleProjectDesc.descriptor := @gExampleProjectPDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gExampleProjectDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gNumUnitsFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gNumUnitsFunctionPieDesc.name := 'Number_of_Units';
  gNumUnitsFunctionPieDesc.functionFlags := kFunctionNeedsProject;
  gNumUnitsFunctionPieDesc.address := GNumUnits;
  gNumUnitsFunctionPieDesc.returnType := kPIEInteger;
  gNumUnitsFunctionPieDesc.numParams := 0;
  gNumUnitsFunctionPieDesc.numOptParams := 0;
  gNumUnitsFunctionPieDesc.paramNames := nil;
  gNumUnitsFunctionPieDesc.paramTypes := nil;
  gNumUnitsFunctionPieDesc.neededProject := Project;

  gNumUnitsPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
  gNumUnitsPIEDesc.name  := 'Number_of_Units';
  gNumUnitsPIEDesc.PieType :=  kFunctionPIE;
  gNumUnitsPIEDesc.descriptor := @gNumUnitsFunctionPieDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gNumUnitsPIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gNumTimesFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gNumTimesFunctionPieDesc.name := 'Number_of_Times';
  gNumTimesFunctionPieDesc.functionFlags := kFunctionNeedsProject;
  gNumTimesFunctionPieDesc.address := GNumTimes;
  gNumTimesFunctionPieDesc.returnType := kPIEInteger;
  gNumTimesFunctionPieDesc.numParams := 0;
  gNumTimesFunctionPieDesc.numOptParams := 0;
  gNumTimesFunctionPieDesc.paramNames := nil;
  gNumTimesFunctionPieDesc.paramTypes := nil;
  gNumTimesFunctionPieDesc.neededProject := Project;

  gNumTimesPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
  gNumTimesPIEDesc.name  := 'Number_of_Times';
  gNumTimesPIEDesc.PieType :=  kFunctionPIE;
  gNumTimesPIEDesc.descriptor := @gNumTimesFunctionPieDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gNumTimesPIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  // Run Model
  gRunExportPIEDesc.name := 'Export Example Model';
  gRunExportPIEDesc.exportType := kPIETriMeshLayer;
  gRunExportPIEDesc.exportFlags := kExportNeedsProject or kExportDontShowParamDialog;
  gRunExportPIEDesc.getTemplateProc := RunExample;
  gRunExportPIEDesc.preExportProc := nil;
  gRunExportPIEDesc.postExportProc := nil;
  gRunExportPIEDesc.neededProject := Project;

  gRunPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
  gRunPIEDesc.vendor :=  'A Vendor';                           // vendor
  gRunPIEDesc.product := 'A Product';                          // product
  gRunPIEDesc.name  := 'Export Example Model';
  gRunPIEDesc.PieType :=  kExportTemplatePIE;
  gRunPIEDesc.descriptor := @gRunExportPIEDesc;

  Assert (numNames < kMaxPIEDesc) ;
  gPIEDesc[numNames] := @gRunPIEDesc;
  Inc(numNames);	// add descriptor to list


  descriptors := @gPIEDesc;
end;


end.
