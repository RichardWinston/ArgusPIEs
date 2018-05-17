unit Main;

interface

uses
  AnePIE;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

implementation

uses FunctionPIE, ParamNamesAndTypes, MatrixWriterUnit;

const
  kMaxPIEDesc = 20;

var
  gWriteRealMatrixFunctionPieDesc : FunctionPIEDesc;
  gWriteRealMatrixPIEDesc : ANEPIEDesc ;

  gWriteParameterRealMatrixFunctionPieDesc : FunctionPIEDesc;
  gWriteParameterRealMatrixPIEDesc : ANEPIEDesc ;

  gWriteIntegerMatrixFunctionPieDesc : FunctionPIEDesc;
  gWriteIntegerMatrixPIEDesc : ANEPIEDesc ;

  gWriteParameterIntegerMatrixFunctionPieDesc : FunctionPIEDesc;
  gWriteParameterIntegerMatrixPIEDesc : ANEPIEDesc ;

  gInitializeMatrixFunctionPieDesc : FunctionPIEDesc;
  gInitializeMatrixPIEDesc : ANEPIEDesc ;

  gFreeMatrixFunctionPieDesc : FunctionPIEDesc;
  gFreeMatrixPIEDesc : ANEPIEDesc ;

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

  gWriteRealMatrixFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gWriteRealMatrixFunctionPieDesc.name := 'MR_WriteRealMatrix';
  gWriteRealMatrixFunctionPieDesc.functionFlags := 0;
  gWriteRealMatrixFunctionPieDesc.address := WriteRealMatrix;
  gWriteRealMatrixFunctionPieDesc.returnType := kPIEBoolean;
  gWriteRealMatrixFunctionPieDesc.numParams := 2;
  gWriteRealMatrixFunctionPieDesc.numOptParams := 0;
  gWriteRealMatrixFunctionPieDesc.paramNames := @gpnEvalstringFile;
  gWriteRealMatrixFunctionPieDesc.paramTypes := @g2StringTypes;

  gWriteRealMatrixPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
  gWriteRealMatrixPIEDesc.name  := 'MR_WriteRealMatrix';
  gWriteRealMatrixPIEDesc.PieType :=  kFunctionPIE;
  gWriteRealMatrixPIEDesc.descriptor := @gWriteRealMatrixFunctionPieDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gWriteRealMatrixPIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gWriteIntegerMatrixFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gWriteIntegerMatrixFunctionPieDesc.name := 'MR_WriteIntegerMatrix';
  gWriteIntegerMatrixFunctionPieDesc.functionFlags := 0;
  gWriteIntegerMatrixFunctionPieDesc.address := WriteIntegerMatrix;
  gWriteIntegerMatrixFunctionPieDesc.returnType := kPIEBoolean;
  gWriteIntegerMatrixFunctionPieDesc.numParams := 2;
  gWriteIntegerMatrixFunctionPieDesc.numOptParams := 0;
  gWriteIntegerMatrixFunctionPieDesc.paramNames := @gpnEvalstringFile;
  gWriteIntegerMatrixFunctionPieDesc.paramTypes := @g2StringTypes;

  gWriteIntegerMatrixPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
  gWriteIntegerMatrixPIEDesc.name  := 'MR_WriteIntegerMatrix';
  gWriteIntegerMatrixPIEDesc.PieType :=  kFunctionPIE;
  gWriteIntegerMatrixPIEDesc.descriptor := @gWriteIntegerMatrixFunctionPieDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gWriteIntegerMatrixPIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gWriteParameterRealMatrixFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gWriteParameterRealMatrixFunctionPieDesc.name := 'MR_WriteParameterRealMatrix';
  gWriteParameterRealMatrixFunctionPieDesc.functionFlags := 0;
  gWriteParameterRealMatrixFunctionPieDesc.address := WriteParameterRealMatrix;
  gWriteParameterRealMatrixFunctionPieDesc.returnType := kPIEBoolean;
  gWriteParameterRealMatrixFunctionPieDesc.numParams := 2;
  gWriteParameterRealMatrixFunctionPieDesc.numOptParams := 0;
  gWriteParameterRealMatrixFunctionPieDesc.paramNames := @gpnParameterFile;
  gWriteParameterRealMatrixFunctionPieDesc.paramTypes := @g2StringTypes;

  gWriteParameterRealMatrixPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
  gWriteParameterRealMatrixPIEDesc.name  := 'MR_WriteParameterRealMatrix';
  gWriteParameterRealMatrixPIEDesc.PieType :=  kFunctionPIE;
  gWriteParameterRealMatrixPIEDesc.descriptor := @gWriteParameterRealMatrixFunctionPieDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gWriteParameterRealMatrixPIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gWriteParameterIntegerMatrixFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gWriteParameterIntegerMatrixFunctionPieDesc.name := 'MR_WriteParameterIntegerMatrix';
  gWriteParameterIntegerMatrixFunctionPieDesc.functionFlags := 0;
  gWriteParameterIntegerMatrixFunctionPieDesc.address := WriteParameterIntegerMatrix;
  gWriteParameterIntegerMatrixFunctionPieDesc.returnType := kPIEBoolean;
  gWriteParameterIntegerMatrixFunctionPieDesc.numParams := 2;
  gWriteParameterIntegerMatrixFunctionPieDesc.numOptParams := 0;
  gWriteParameterIntegerMatrixFunctionPieDesc.paramNames := @gpnParameterFile;
  gWriteParameterIntegerMatrixFunctionPieDesc.paramTypes := @g2StringTypes;

  gWriteParameterIntegerMatrixPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
  gWriteParameterIntegerMatrixPIEDesc.name  := 'MR_WriteParameterIntegerMatrix';
  gWriteParameterIntegerMatrixPIEDesc.PieType :=  kFunctionPIE;
  gWriteParameterIntegerMatrixPIEDesc.descriptor := @gWriteParameterIntegerMatrixFunctionPieDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gWriteParameterIntegerMatrixPIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gInitializeMatrixFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gInitializeMatrixFunctionPieDesc.name := 'MR_InitializeMatrixWriter';
  gInitializeMatrixFunctionPieDesc.functionFlags := 0;
  gInitializeMatrixFunctionPieDesc.address := InitializeMatrix;
  gInitializeMatrixFunctionPieDesc.returnType := kPIEBoolean;
  gInitializeMatrixFunctionPieDesc.numParams := 1;
  gInitializeMatrixFunctionPieDesc.numOptParams := 0;
  gInitializeMatrixFunctionPieDesc.paramNames := @gpnGridlayer;
  gInitializeMatrixFunctionPieDesc.paramTypes := @gOneStringTypes;

  gInitializeMatrixPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
  gInitializeMatrixPIEDesc.name  := 'MR_InitializeMatrixWriter';
  gInitializeMatrixPIEDesc.PieType :=  kFunctionPIE;
  gInitializeMatrixPIEDesc.descriptor := @gInitializeMatrixFunctionPieDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gInitializeMatrixPIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  gFreeMatrixFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gFreeMatrixFunctionPieDesc.name := 'MR_FreeMatrixWriter';
  gFreeMatrixFunctionPieDesc.functionFlags := 0;
  gFreeMatrixFunctionPieDesc.address := FreeMatrix;
  gFreeMatrixFunctionPieDesc.returnType := kPIEBoolean;
  gFreeMatrixFunctionPieDesc.numParams := 0;
  gFreeMatrixFunctionPieDesc.numOptParams := 0;
  gFreeMatrixFunctionPieDesc.paramNames := nil;
  gFreeMatrixFunctionPieDesc.paramTypes := nil;

  gFreeMatrixPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
  gFreeMatrixPIEDesc.name  := 'MR_FreeMatrixWriter';
  gFreeMatrixPIEDesc.PieType :=  kFunctionPIE;
  gFreeMatrixPIEDesc.descriptor := @gFreeMatrixFunctionPieDesc;

  Assert(numNames < kMaxPIEDesc);
  gPIEDesc[numNames] := @gFreeMatrixPIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names


  descriptors := @gPIEDesc;
end;


end.
