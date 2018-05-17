unit GetANEFunctionsUnit;

interface

uses
  ProjectPIE, AnePIE, Forms, sysutils, Controls, classes;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

const
  kMaxPIEDesc = 103;
  kMaxAdditionalPies = 0;

var
  gPIEDesc : Array [0..kMaxPIEDesc+kMaxAdditionalPies-1] of ^ANEPIEDesc;

implementation

uses SutraPIEFunctions, CustomizedSutraPieFunctions;

const
  Project : ANE_Str = 'SUTRA';
  Vendor :  ANE_Str = 'Richard Winston';
  Product : ANE_Str = 'New SUTRA PIE' ;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
  GetSutraFunctions(Project, Vendor, Product, numNames);

  GetMoreFuctions(Project, Vendor, Product, numNames) ;

  descriptors := @gPIEDesc;

end;
end.
