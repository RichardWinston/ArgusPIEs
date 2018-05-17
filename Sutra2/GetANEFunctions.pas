unit GetANEFunctions;

interface

uses
  ProjectPIE, AnePIE, Forms, sysutils, Controls, classes;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

const
  kMaxPIEDesc = 42;
  kMaxAdditionalPies = 0;

var
gPIEDesc : Array [0..kMaxPIEDesc+kMaxAdditionalPies-1] of ^ANEPIEDesc;

implementation

uses SutraPIEFunctions, CustomizedSutraPieFunctions{, MODFLOWPieDescriptors, ProjectFunctions};

const
  Project : ANE_Str = 'MODFLOW';
  Vendor :  ANE_Str = 'Richard Winston';
  Product : ANE_Str = 'New MODFLOW PIE' ;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
  SutraPIEFunctions(Project, Vendor, Product, numNames);

  GetMoreFuctions(Project, Vendor, Product, numNames) ;

  descriptors := @gPIEDesc;

end;
end.
