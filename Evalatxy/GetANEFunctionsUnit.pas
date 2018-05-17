unit GetANEFunctionsUnit;

interface

Uses AnePIE;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

implementation

uses FunctionPIE, EvalAtFunctionUnit, CheckPIEVersionFunction;

const
  kMaxFunDesc = 5;

var
  gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
var
  UsualOptions : EFunctionPIEFlags;
begin
  UsualOptions := 0;

  numNames := 0;

  {$ASSERTIONS ON}
  gPIEEvalRealFuncDesc.name := 'EvalRealAtXY';	        // name of function
  gPIEEvalRealFuncDesc.address := GPIEEvalRealAtXYMMFun;		// function address
  gPIEEvalRealFuncDesc.returnType := kPIEFloat;		// return value type
  gPIEEvalRealFuncDesc.numParams :=  3;			// number of parameters
  gPIEEvalRealFuncDesc.numOptParams := 1;			// number of optional parameters
  gPIEEvalRealFuncDesc.paramNames := @gpnXYExpressionLayer;		// pointer to parameter names list
  gPIEEvalRealFuncDesc.paramTypes := @g2Float2StringTypes;	// pointer to parameters types list
  gPIEEvalRealFuncDesc.version := FUNCTION_PIE_VERSION;
  gPIEEvalRealFuncDesc.functionFlags := UsualOptions;

  gPIEEvalRealDesc.name  := 'EvalRealAtXY';		// name of PIE
  gPIEEvalRealDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEEvalRealDesc.descriptor := @gPIEEvalRealFuncDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEEvalRealDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEEvalIntFuncDesc.name := 'EvalIntegerAtXY';	        // name of function
  gPIEEvalIntFuncDesc.address := GPIEEvalIntAtXYMMFun;		// function address
  gPIEEvalIntFuncDesc.returnType := kPIEInteger;		// return value type
  gPIEEvalIntFuncDesc.numParams :=  3;			// number of parameters
  gPIEEvalIntFuncDesc.numOptParams := 1;			// number of optional parameters
  gPIEEvalIntFuncDesc.paramNames := @gpnXYExpressionLayer;		// pointer to parameter names list
  gPIEEvalIntFuncDesc.paramTypes := @g2Float2StringTypes;	// pointer to parameters types list
  gPIEEvalIntFuncDesc.version := FUNCTION_PIE_VERSION;
  gPIEEvalIntFuncDesc.functionFlags := UsualOptions;

  gPIEEvalIntDesc.name  := 'EvalIntegerAtXY';		// name of PIE
  gPIEEvalIntDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEEvalIntDesc.descriptor := @gPIEEvalIntFuncDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEEvalIntDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEEvalBoolFuncDesc.name := 'EvalBooleanAtXY';	        // name of function
  gPIEEvalBoolFuncDesc.address := GPIEEvalBoolAtXYMMFun;		// function address
  gPIEEvalBoolFuncDesc.returnType := kPIEBoolean;		// return value type
  gPIEEvalBoolFuncDesc.numParams :=  3;			// number of parameters
  gPIEEvalBoolFuncDesc.numOptParams := 1;			// number of optional parameters
  gPIEEvalBoolFuncDesc.paramNames := @gpnXYExpressionLayer;		// pointer to parameter names list
  gPIEEvalBoolFuncDesc.paramTypes := @g2Float2StringTypes;	// pointer to parameters types list
  gPIEEvalBoolFuncDesc.version := FUNCTION_PIE_VERSION;
  gPIEEvalBoolFuncDesc.functionFlags := UsualOptions;

  gPIEEvalBoolDesc.name  := 'EvalBooleanAtXY';		// name of PIE
  gPIEEvalBoolDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEEvalBoolDesc.descriptor := @gPIEEvalBoolFuncDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEEvalBoolDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIEEvalStringFuncDesc.name := 'EvalStringAtXY';	        // name of function
  gPIEEvalStringFuncDesc.address := GPIEEvalStringAtXYMMFun;		// function address
  gPIEEvalStringFuncDesc.returnType := kPIEString;		// return value type
  gPIEEvalStringFuncDesc.numParams :=  3;			// number of parameters
  gPIEEvalStringFuncDesc.numOptParams := 1;			// number of optional parameters
  gPIEEvalStringFuncDesc.paramNames := @gpnXYExpressionLayer;		// pointer to parameter names list
  gPIEEvalStringFuncDesc.paramTypes := @g2Float2StringTypes;	// pointer to parameters types list
  gPIEEvalStringFuncDesc.version := FUNCTION_PIE_VERSION;
  gPIEEvalStringFuncDesc.functionFlags := UsualOptions;

  gPIEEvalStringDesc.name  := 'EvalStringAtXY';		// name of PIE
  gPIEEvalStringDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIEEvalStringDesc.descriptor := @gPIEEvalStringFuncDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIEEvalStringDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gPIECheckVersionFDesc.name := 'EvalAt_CheckVersion';	        // name of function
  gPIECheckVersionFDesc.address := GPIECheckVersionMMFun;		// function address
  gPIECheckVersionFDesc.returnType := kPIEBoolean;		// return value type
  gPIECheckVersionFDesc.numParams :=  4;			// number of parameters
  gPIECheckVersionFDesc.numOptParams := 0;			// number of optional parameters
  gPIECheckVersionFDesc.paramNames := @gpnFourDigit;		// pointer to parameter names list
  gPIECheckVersionFDesc.paramTypes := @gFourIntegerTypes;	// pointer to parameters types list
  gPIECheckVersionFDesc.version := FUNCTION_PIE_VERSION;
  gPIECheckVersionFDesc.functionFlags := UsualOptions;

  gPIECheckVersionDesc.name  := 'EvalAt_CheckVersion';		// name of PIE
  gPIECheckVersionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;	// pointer to descriptor
  gPIECheckVersionDesc.version := ANE_PIE_VERSION;

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gPIECheckVersionDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  descriptors := @gFunDesc;

end;

end.
