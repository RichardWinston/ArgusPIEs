unit GetANEFunctionsUnit;

interface

{GetANEFunctionsUnit contains the function GetANEFunctions which is the
 method whereby the PIE interacts with Argus ONE}

uses
  ProjectPIE, AnePIE, Forms, sysutils, Controls, classes;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

const
  kMaxPIEDesc = 42;
  kMaxAdditionalPies = 0;

var
gPIEDesc : Array [0..kMaxPIEDesc+kMaxAdditionalPies -1] of ^ANEPIEDesc;

implementation

uses ModflowPIEFunctions, CustomizedPieFunctions{, MODFLOWPieDescriptors, ProjectFunctions};

const
  Project : ANE_Str = 'MODFLOW';
  Vendor :  ANE_Str = 'Richard Winston';
  Product : ANE_Str = 'New MODFLOW PIE' ;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
  GetMODFLOWFunctions(Project, Vendor, Product, numNames);

  GetMoreFuctions(Project, Vendor, Product, numNames) ;

  descriptors := @gPIEDesc;

end;

end.
