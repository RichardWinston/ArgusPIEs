unit GetAneFunctionsUnit;

interface

uses AnePIE;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

implementation

uses FunctionPIE, RotatedCellsFunctionUnit;

const
  kMaxFunDesc = 20;

var
  gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;

	gPIERotatedXFDesc.name := 'Rotated X';	        // name of function
	gPIERotatedXFDesc.address := GPIERotatedXFun;		// function address
	gPIERotatedXFDesc.returnType := kPIEFloat;		// return value type
	gPIERotatedXFDesc.numParams :=  3;			// number of parameters
	gPIERotatedXFDesc.numOptParams := 0;			// number of optional parameters
	gPIERotatedXFDesc.paramNames := @gpnXYAngle;		// pointer to parameter names list
	gPIERotatedXFDesc.paramTypes := @g3FloatTypes;	// pointer to parameters types list

       	gPIERotatedXDesc.name  := 'Rotated X';		// name of PIE
	gPIERotatedXDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIERotatedXDesc.descriptor := @gPIERotatedXFDesc;	// pointer to descriptor

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIERotatedXDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIERotatedYFDesc.name := 'Rotated Y';	        // name of function
	gPIERotatedYFDesc.address := GPIERotatedYFun;		// function address
	gPIERotatedYFDesc.returnType := kPIEFloat;		// return value type
	gPIERotatedYFDesc.numParams :=  3;			// number of parameters
	gPIERotatedYFDesc.numOptParams := 0;			// number of optional parameters
	gPIERotatedYFDesc.paramNames := @gpnXYAngle;		// pointer to parameter names list
	gPIERotatedYFDesc.paramTypes := @g3FloatTypes;	// pointer to parameters types list

       	gPIERotatedYDesc.name  := 'Rotated Y';		// name of PIE
	gPIERotatedYDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIERotatedYDesc.descriptor := @gPIERotatedYFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIERotatedYDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

{        gPIERotatedXFDesc :  FunctionPIEDesc;
        gPIERotatedXDesc : ANEPIEDesc;

        gPIERotatedYFDesc :  FunctionPIEDesc;
        gPIERotatedYDesc : ANEPIEDesc; }


	descriptors := @gFunDesc;

end;

end.
