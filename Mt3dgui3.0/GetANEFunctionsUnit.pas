unit GetANEFunctionsUnit;

interface

uses

  ProjectPIE, AnePIE, FunctionPIE, Forms, sysutils, Controls, classes;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

const
  kMaxPIEDesc = 42;
  KMT3DPIEDesc = 13 ;

var
gPIEDesc : Array [0..kMaxPIEDesc+KMT3DPIEDesc-1] of ^ANEPIEDesc;

var
  UsualOptions : EFunctionPIEFlags ;

implementation

uses  MT3DPieDescriptors, ProjectFunctions, MOC3DGridFunctions, ModflowTimeFunctions,
      ParamNamesAndTypes, ModflowLayerFunctions, MOC3DUnitFunctions,
      MOC3DParticleFunctions, ExportTemplatePIE, RunUnit, MODFLOWPieDescriptors,
      ImportPIE, PostMODFLOWPieUnit, RunFunction, ModflowPIEFunctions;




procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
const
  Project : ANE_Str = 'MODFLOW';
  Vendor :  ANE_Str = 'Richard Winston';
  Product : ANE_Str = 'New MODFLOW PIE' ;
begin
  UsualOptions := kFunctionNeedsProject or kFunctionIsHidden;

  numNames := 0;

  {$ASSERTIONS ON}
  {Assertions are a debugging tool. They should be turned off
  in the final version. They are useful for "Just-in-time" debugging
  with Turbo-Debugger 32. See Delphi help for more information.}

  GetMODFLOWFunctions(Project, Vendor, Product, numNames);

  AddMorePieDiscriptors(Project, Vendor, Product, numNames) ;


  descriptors := @gPIEDesc;

end;

end.
