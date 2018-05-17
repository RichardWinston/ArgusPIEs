unit GetAneFunctionsUnit;

interface

uses FunctionPie, ANEPIE;

procedure GetANEFunctions(var numNames: ANE_INT32;
  var descriptors: ANEPIEDescPtr); cdecl;

implementation

uses ParamNamesAndTypes, ReadMeshUnit, ReadContoursUnit, ContourIntersection;

const
  kMaxFunDesc = 13;

var
  gFunDesc: array[0..kMaxFunDesc - 1] of ^ANEPIEDesc;

  gReadMeshPieDesc: ANEPIEDesc;
  gReadMeshFunctionPieDesc: FunctionPIEDesc;

  gClearMeshPieDesc: ANEPIEDesc;
  gClearMeshFunctionPieDesc: FunctionPIEDesc;

  gReadContourPieDesc: ANEPIEDesc;
  gReadContourFunctionPieDesc: FunctionPIEDesc;

//  gClearContourPieDesc: ANEPIEDesc;
//  gClearContourFunctionPieDesc: FunctionPIEDesc;

//  gIntersectCellsPieDesc: ANEPIEDesc;
//  gIntersectCellsFunctionPieDesc: FunctionPIEDesc;

  gIntersectElementsPieDesc: ANEPIEDesc;
  gIntersectElementsFunctionPieDesc: FunctionPIEDesc;

  gIntersectCellsCountPieDesc: ANEPIEDesc;
  gIntersectCellsCountFunctionPieDesc: FunctionPIEDesc;

  gIntersectCellsNodeNumberPieDesc: ANEPIEDesc;
  gIntersectCellsNodeNumberFunctionPieDesc: FunctionPIEDesc;

  gIntersectCellsNodeDistancePieDesc: ANEPIEDesc;
  gIntersectCellsNodeDistanceFunctionPieDesc: FunctionPIEDesc;

  gContourCountPieDesc: ANEPIEDesc;
  gContourCountFunctionPieDesc: FunctionPIEDesc;

  gContourIntersectLengthPieDesc: ANEPIEDesc;
  gContourIntersectLengthFunctionPieDesc: FunctionPIEDesc;

  gCondensedIntersectCellsNodeNumberPieDesc: ANEPIEDesc;
  gCondensedIntersectCellsNodeNumberFunctionPieDesc: FunctionPIEDesc;

  gCondensedIntersectCellsNodeDistancePieDesc: ANEPIEDesc;
  gCondensedIntersectCellsNodeDistanceFunctionPieDesc: FunctionPIEDesc;

  gCondensedIIntersectCellsCountPieDesc: ANEPIEDesc;
  gCondensedIIntersectCellsCountFunctionPieDesc: FunctionPIEDesc;

  gErrorCountPieDesc: ANEPIEDesc;
  gErrorCountFunctionPieDesc: FunctionPIEDesc;

procedure GetANEFunctions(var numNames: ANE_INT32;
  var descriptors: ANEPIEDescPtr); cdecl;
const
  PIEvendor: ANE_STR = '';
  PIEproduct: ANE_STR = '';
  PIEcategory: ANE_STR = '';
  PIEneededProject: ANE_STR = '';
var
  Options: EFunctionPIEFlags;
begin
  numNames := 0;
  Options := 0;//kFunctionIsHidden

  // name of function
  gReadMeshFunctionPieDesc.name := PChar('ML_ReadMesh');
  // function address
  gReadMeshFunctionPieDesc.address := ReadMesh;
  // return value type
  gReadMeshFunctionPieDesc.returnType := kPIEBoolean;
  // number of parameters
  gReadMeshFunctionPieDesc.numParams := 1;
  // number of optional parameters
  gReadMeshFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gReadMeshFunctionPieDesc.paramNames := @gpnMeshLayer;
  // pointer to parameters types list
  gReadMeshFunctionPieDesc.paramTypes := @gOneStringTypes;
  gReadMeshFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gReadMeshFunctionPieDesc.functionFlags := Options;
  gReadMeshFunctionPieDesc.category := PIEcategory;
  gReadMeshFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gReadMeshPieDesc.name := PChar('ML_ReadMesh');
  // PIE type: PIE function
  gReadMeshPieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gReadMeshPieDesc.descriptor := @gReadMeshFunctionPieDesc;
  gReadMeshPieDesc.version := ANE_PIE_VERSION;
  gReadMeshPieDesc.vendor := PIEvendor;
  gReadMeshPieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gReadMeshPieDesc;
  // increment number of names
  Inc(numNames);

  // name of function
  gClearMeshFunctionPieDesc.name := PChar('ML_ClearMesh');
  // function address
  gClearMeshFunctionPieDesc.address := ClearMesh;
  // return value type
  gClearMeshFunctionPieDesc.returnType := kPIEBoolean;
  // number of parameters
  gClearMeshFunctionPieDesc.numParams := 0;
  // number of optional parameters
  gClearMeshFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gClearMeshFunctionPieDesc.paramNames := nil;
  // pointer to parameters types list
  gClearMeshFunctionPieDesc.paramTypes := nil;
  gClearMeshFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gClearMeshFunctionPieDesc.functionFlags := Options;
  gClearMeshFunctionPieDesc.category := PIEcategory;
  gClearMeshFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gClearMeshPieDesc.name := PChar('ML_ClearMesh');
  // PIE type: PIE function
  gClearMeshPieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gClearMeshPieDesc.descriptor := @gClearMeshFunctionPieDesc;
  gClearMeshPieDesc.version := ANE_PIE_VERSION;
  gClearMeshPieDesc.vendor := PIEvendor;
  gClearMeshPieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gClearMeshPieDesc;
  // increment number of names
  Inc(numNames);




  // name of function
  gReadContourFunctionPieDesc.name := PChar('ML_ReadContours');
  // function address
  gReadContourFunctionPieDesc.address := ReadContours;
  // return value type
  gReadContourFunctionPieDesc.returnType := kPIEBoolean;
  // number of parameters
  gReadContourFunctionPieDesc.numParams := 1;
  // number of optional parameters
  gReadContourFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gReadContourFunctionPieDesc.paramNames := @gpnInformationLayer;
  // pointer to parameters types list
  gReadContourFunctionPieDesc.paramTypes := @gOneStringTypes;
  gReadContourFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gReadContourFunctionPieDesc.functionFlags := Options;
  gReadContourFunctionPieDesc.category := PIEcategory;
  gReadContourFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gReadContourPieDesc.name := PChar('ML_ReadContours');
  // PIE type: PIE function
  gReadContourPieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gReadContourPieDesc.descriptor := @gReadContourFunctionPieDesc;
  gReadContourPieDesc.version := ANE_PIE_VERSION;
  gReadContourPieDesc.vendor := PIEvendor;
  gReadContourPieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gReadContourPieDesc;
  // increment number of names
  Inc(numNames);

  // name of function
//  gClearContourFunctionPieDesc.name := PChar('ML_ClearContours');
//  // function address
//  gClearContourFunctionPieDesc.address := ClearContours;
//  // return value type
//  gClearContourFunctionPieDesc.returnType := kPIEBoolean;
//  // number of parameters
//  gClearContourFunctionPieDesc.numParams := 0;
//  // number of optional parameters
//  gClearContourFunctionPieDesc.numOptParams := 0;
//  // pointer to parameter names list
//  gClearContourFunctionPieDesc.paramNames := nil;
//  // pointer to parameters types list
//  gClearContourFunctionPieDesc.paramTypes := nil;
//  gClearContourFunctionPieDesc.version := FUNCTION_PIE_VERSION;
//  gClearContourFunctionPieDesc.functionFlags := Options;
//  gClearContourFunctionPieDesc.category := PIEcategory;
//  gClearContourFunctionPieDesc.neededProject := PIEneededProject;
//
//  // name of PIE
//  gClearContourPieDesc.name := PChar('ML_ClearContours');
//  // PIE type: PIE function
//  gClearContourPieDesc.PieType := kFunctionPIE;
//  // pointer to descriptor
//  gClearContourPieDesc.descriptor := @gClearContourFunctionPieDesc;
//  gClearContourPieDesc.version := ANE_PIE_VERSION;
//  gClearContourPieDesc.vendor := PIEvendor;
//  gClearContourPieDesc.product := PIEproduct;
//
//  Assert(numNames < kMaxFunDesc);
//  // add descriptor to list
//  gFunDesc[numNames] := @gClearContourPieDesc;
//  // increment number of names
//  Inc(numNames);





  // name of function
//  gIntersectCellsFunctionPieDesc.name := PChar('ML_IntersectCells');
//  // function address
//  gIntersectCellsFunctionPieDesc.address := GIntersectContoursCells;
//  // return value type
//  gIntersectCellsFunctionPieDesc.returnType := kPIEBoolean;
//  // number of parameters
//  gIntersectCellsFunctionPieDesc.numParams := 0;
//  // number of optional parameters
//  gIntersectCellsFunctionPieDesc.numOptParams := 0;
//  // pointer to parameter names list
//  gIntersectCellsFunctionPieDesc.paramNames := nil;
//  // pointer to parameters types list
//  gIntersectCellsFunctionPieDesc.paramTypes := nil;
//  gIntersectCellsFunctionPieDesc.version := FUNCTION_PIE_VERSION;
//  gIntersectCellsFunctionPieDesc.functionFlags := Options;
//  gIntersectCellsFunctionPieDesc.category := PIEcategory;
//  gIntersectCellsFunctionPieDesc.neededProject := PIEneededProject;
//
//  // name of PIE
//  gIntersectCellsPieDesc.name := PChar('ML_IntersectCells');
//  // PIE type: PIE function
//  gIntersectCellsPieDesc.PieType := kFunctionPIE;
//  // pointer to descriptor
//  gIntersectCellsPieDesc.descriptor := @gIntersectCellsFunctionPieDesc;
//  gIntersectCellsPieDesc.version := ANE_PIE_VERSION;
//  gIntersectCellsPieDesc.vendor := PIEvendor;
//  gIntersectCellsPieDesc.product := PIEproduct;
//
//  Assert(numNames < kMaxFunDesc);
//  // add descriptor to list
//  gFunDesc[numNames] := @gIntersectCellsPieDesc;
//  // increment number of names
//  Inc(numNames);




  // name of function
  gIntersectElementsFunctionPieDesc.name := PChar('ML_IntersectElements');
  // function address
  gIntersectElementsFunctionPieDesc.address := GIntersectContoursElements;
  // return value type
  gIntersectElementsFunctionPieDesc.returnType := kPIEBoolean;
  // number of parameters
  gIntersectElementsFunctionPieDesc.numParams := 0;
  // number of optional parameters
  gIntersectElementsFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gIntersectElementsFunctionPieDesc.paramNames := nil;
  // pointer to parameters types list
  gIntersectElementsFunctionPieDesc.paramTypes := nil;
  gIntersectElementsFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gIntersectElementsFunctionPieDesc.functionFlags := Options;
  gIntersectElementsFunctionPieDesc.category := PIEcategory;
  gIntersectElementsFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gIntersectElementsPieDesc.name := PChar('ML_IntersectElements');
  // PIE type: PIE function
  gIntersectElementsPieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gIntersectElementsPieDesc.descriptor := @gIntersectElementsFunctionPieDesc;
  gIntersectElementsPieDesc.version := ANE_PIE_VERSION;
  gIntersectElementsPieDesc.vendor := PIEvendor;
  gIntersectElementsPieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gIntersectElementsPieDesc;
  // increment number of names
  Inc(numNames);

  // name of function
  gIntersectCellsCountFunctionPieDesc.name := PChar('ML_CellIntersectCount');
  // function address
  gIntersectCellsCountFunctionPieDesc.address := GIntersectContoursCellCount;
  // return value type
  gIntersectCellsCountFunctionPieDesc.returnType := kPIEInteger;
  // number of parameters
  gIntersectCellsCountFunctionPieDesc.numParams := 1;
  // number of optional parameters
  gIntersectCellsCountFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gIntersectCellsCountFunctionPieDesc.paramNames := @gpnContour;
  // pointer to parameters types list
  gIntersectCellsCountFunctionPieDesc.paramTypes := @gOneIntegerTypes;
  gIntersectCellsCountFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gIntersectCellsCountFunctionPieDesc.functionFlags := Options;
  gIntersectCellsCountFunctionPieDesc.category := PIEcategory;
  gIntersectCellsCountFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gIntersectCellsCountPieDesc.name := PChar('ML_CellIntersectCount');
  // PIE type: PIE function
  gIntersectCellsCountPieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gIntersectCellsCountPieDesc.descriptor := @gIntersectCellsCountFunctionPieDesc;
  gIntersectCellsCountPieDesc.version := ANE_PIE_VERSION;
  gIntersectCellsCountPieDesc.vendor := PIEvendor;
  gIntersectCellsCountPieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gIntersectCellsCountPieDesc;
  // increment number of names
  Inc(numNames);

  // name of function
  gIntersectCellsNodeNumberFunctionPieDesc.name := PChar('ML_CellIntersectNodeNumber');
  // function address
  gIntersectCellsNodeNumberFunctionPieDesc.address := GIntersectContoursNodeNumber;
  // return value type
  gIntersectCellsNodeNumberFunctionPieDesc.returnType := kPIEInteger;
  // number of parameters
  gIntersectCellsNodeNumberFunctionPieDesc.numParams := 2;
  // number of optional parameters
  gIntersectCellsNodeNumberFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gIntersectCellsNodeNumberFunctionPieDesc.paramNames := @gpnContourNode;
  // pointer to parameters types list
  gIntersectCellsNodeNumberFunctionPieDesc.paramTypes := @gTwoIntegerTypes;
  gIntersectCellsNodeNumberFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gIntersectCellsNodeNumberFunctionPieDesc.functionFlags := Options;
  gIntersectCellsNodeNumberFunctionPieDesc.category := PIEcategory;
  gIntersectCellsNodeNumberFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gIntersectCellsNodeNumberPieDesc.name := PChar('ML_CellIntersectNodeNumber');
  // PIE type: PIE function
  gIntersectCellsNodeNumberPieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gIntersectCellsNodeNumberPieDesc.descriptor := @gIntersectCellsNodeNumberFunctionPieDesc;
  gIntersectCellsNodeNumberPieDesc.version := ANE_PIE_VERSION;
  gIntersectCellsNodeNumberPieDesc.vendor := PIEvendor;
  gIntersectCellsNodeNumberPieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gIntersectCellsNodeNumberPieDesc;
  // increment number of names
  Inc(numNames);

  // name of function
  gIntersectCellsNodeDistanceFunctionPieDesc.name := PChar('ML_CellIntersectNodeDistance');
  // function address
  gIntersectCellsNodeDistanceFunctionPieDesc.address := GIntersectContoursNodeDistance;
  // return value type
  gIntersectCellsNodeDistanceFunctionPieDesc.returnType := kPIEFloat;
  // number of parameters
  gIntersectCellsNodeDistanceFunctionPieDesc.numParams := 2;
  // number of optional parameters
  gIntersectCellsNodeDistanceFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gIntersectCellsNodeDistanceFunctionPieDesc.paramNames := @gpnContourNode;
  // pointer to parameters types list
  gIntersectCellsNodeDistanceFunctionPieDesc.paramTypes := @gTwoIntegerTypes;
  gIntersectCellsNodeDistanceFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gIntersectCellsNodeDistanceFunctionPieDesc.functionFlags := Options;
  gIntersectCellsNodeDistanceFunctionPieDesc.category := PIEcategory;
  gIntersectCellsNodeDistanceFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gIntersectCellsNodeDistancePieDesc.name := PChar('ML_CellIntersectNodeDistance');
  // PIE type: PIE function
  gIntersectCellsNodeDistancePieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gIntersectCellsNodeDistancePieDesc.descriptor := @gIntersectCellsNodeDistanceFunctionPieDesc;
  gIntersectCellsNodeDistancePieDesc.version := ANE_PIE_VERSION;
  gIntersectCellsNodeDistancePieDesc.vendor := PIEvendor;
  gIntersectCellsNodeDistancePieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gIntersectCellsNodeDistancePieDesc;
  // increment number of names
  Inc(numNames);

  // name of function
  gContourIntersectLengthFunctionPieDesc.name := PChar('ML_ContourIntersectLength');
  // function address
  gContourIntersectLengthFunctionPieDesc.address := GIntersectContourLength;
  // return value type
  gContourIntersectLengthFunctionPieDesc.returnType := kPIEFloat;
  // number of parameters
  gContourIntersectLengthFunctionPieDesc.numParams := 1;
  // number of optional parameters
  gContourIntersectLengthFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gContourIntersectLengthFunctionPieDesc.paramNames := @gpnContour;
  // pointer to parameters types list
  gContourIntersectLengthFunctionPieDesc.paramTypes := @gOneIntegerTypes;
  gContourIntersectLengthFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gContourIntersectLengthFunctionPieDesc.functionFlags := Options;
  gContourIntersectLengthFunctionPieDesc.category := PIEcategory;
  gContourIntersectLengthFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gContourIntersectLengthPieDesc.name := PChar('ML_ContourIntersectLength');
  // PIE type: PIE function
  gContourIntersectLengthPieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gContourIntersectLengthPieDesc.descriptor := @gContourIntersectLengthFunctionPieDesc;
  gContourIntersectLengthPieDesc.version := ANE_PIE_VERSION;
  gContourIntersectLengthPieDesc.vendor := PIEvendor;
  gContourIntersectLengthPieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gContourIntersectLengthPieDesc;
  // increment number of names
  Inc(numNames);

  // name of function
  gContourCountFunctionPieDesc.name := PChar('ML_ContourCount');
  // function address
  gContourCountFunctionPieDesc.address := ContourCount;
  // return value type
  gContourCountFunctionPieDesc.returnType := kPIEInteger;
  // number of parameters
  gContourCountFunctionPieDesc.numParams := 0;
  // number of optional parameters
  gContourCountFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gContourCountFunctionPieDesc.paramNames := nil;
  // pointer to parameters types list
  gContourCountFunctionPieDesc.paramTypes := nil;
  gContourCountFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gContourCountFunctionPieDesc.functionFlags := Options;
  gContourCountFunctionPieDesc.category := PIEcategory;
  gContourCountFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gContourCountPieDesc.name := PChar('ML_ContourCount');
  // PIE type: PIE function
  gContourCountPieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gContourCountPieDesc.descriptor := @gContourCountFunctionPieDesc;
  gContourCountPieDesc.version := ANE_PIE_VERSION;
  gContourCountPieDesc.vendor := PIEvendor;
  gContourCountPieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gContourCountPieDesc;
  // increment number of names
  Inc(numNames);




  // name of function
  gCondensedIIntersectCellsCountFunctionPieDesc.name := PChar('ML_UniqueCellIntersectCount');
  // function address
  gCondensedIIntersectCellsCountFunctionPieDesc.address := GCondensedIntersectContoursCellCount;
  // return value type
  gCondensedIIntersectCellsCountFunctionPieDesc.returnType := kPIEInteger;
  // number of parameters
  gCondensedIIntersectCellsCountFunctionPieDesc.numParams := 1;
  // number of optional parameters
  gCondensedIIntersectCellsCountFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gCondensedIIntersectCellsCountFunctionPieDesc.paramNames := @gpnContour;
  // pointer to parameters types list
  gCondensedIIntersectCellsCountFunctionPieDesc.paramTypes := @gOneIntegerTypes;
  gCondensedIIntersectCellsCountFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gCondensedIIntersectCellsCountFunctionPieDesc.functionFlags := Options;
  gCondensedIIntersectCellsCountFunctionPieDesc.category := PIEcategory;
  gCondensedIIntersectCellsCountFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gCondensedIIntersectCellsCountPieDesc.name := PChar('ML_UniqueCellIntersectCount');
  // PIE type: PIE function
  gCondensedIIntersectCellsCountPieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gCondensedIIntersectCellsCountPieDesc.descriptor := @gCondensedIIntersectCellsCountFunctionPieDesc;
  gCondensedIIntersectCellsCountPieDesc.version := ANE_PIE_VERSION;
  gCondensedIIntersectCellsCountPieDesc.vendor := PIEvendor;
  gCondensedIIntersectCellsCountPieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gCondensedIIntersectCellsCountPieDesc;
  // increment number of names
  Inc(numNames);

  // name of function
  gCondensedIntersectCellsNodeNumberFunctionPieDesc.name := PChar('ML_UniqueCellIntersectNodeNumber');
  // function address
  gCondensedIntersectCellsNodeNumberFunctionPieDesc.address := GCondensedIntersectContoursNodeNumber;
  // return value type
  gCondensedIntersectCellsNodeNumberFunctionPieDesc.returnType := kPIEInteger;
  // number of parameters
  gCondensedIntersectCellsNodeNumberFunctionPieDesc.numParams := 2;
  // number of optional parameters
  gCondensedIntersectCellsNodeNumberFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gCondensedIntersectCellsNodeNumberFunctionPieDesc.paramNames := @gpnContourNode;
  // pointer to parameters types list
  gCondensedIntersectCellsNodeNumberFunctionPieDesc.paramTypes := @gTwoIntegerTypes;
  gCondensedIntersectCellsNodeNumberFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gCondensedIntersectCellsNodeNumberFunctionPieDesc.functionFlags := Options;
  gCondensedIntersectCellsNodeNumberFunctionPieDesc.category := PIEcategory;
  gCondensedIntersectCellsNodeNumberFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gCondensedIntersectCellsNodeNumberPieDesc.name := PChar('ML_UniqueCellIntersectNodeNumber');
  // PIE type: PIE function
  gCondensedIntersectCellsNodeNumberPieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gCondensedIntersectCellsNodeNumberPieDesc.descriptor := @gCondensedIntersectCellsNodeNumberFunctionPieDesc;
  gCondensedIntersectCellsNodeNumberPieDesc.version := ANE_PIE_VERSION;
  gCondensedIntersectCellsNodeNumberPieDesc.vendor := PIEvendor;
  gCondensedIntersectCellsNodeNumberPieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gCondensedIntersectCellsNodeNumberPieDesc;
  // increment number of names
  Inc(numNames);

  // name of function
  gCondensedIntersectCellsNodeDistanceFunctionPieDesc.name := PChar('ML_UniqueCellIntersectNodeDistance');
  // function address
  gCondensedIntersectCellsNodeDistanceFunctionPieDesc.address := GCondensedIntersectContoursNodeDistance;
  // return value type
  gCondensedIntersectCellsNodeDistanceFunctionPieDesc.returnType := kPIEFloat;
  // number of parameters
  gCondensedIntersectCellsNodeDistanceFunctionPieDesc.numParams := 2;
  // number of optional parameters
  gCondensedIntersectCellsNodeDistanceFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gCondensedIntersectCellsNodeDistanceFunctionPieDesc.paramNames := @gpnContourNode;
  // pointer to parameters types list
  gCondensedIntersectCellsNodeDistanceFunctionPieDesc.paramTypes := @gTwoIntegerTypes;
  gCondensedIntersectCellsNodeDistanceFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gCondensedIntersectCellsNodeDistanceFunctionPieDesc.functionFlags := Options;
  gCondensedIntersectCellsNodeDistanceFunctionPieDesc.category := PIEcategory;
  gCondensedIntersectCellsNodeDistanceFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gCondensedIntersectCellsNodeDistancePieDesc.name := PChar('ML_UniqueCellIntersectNodeDistance');
  // PIE type: PIE function
  gCondensedIntersectCellsNodeDistancePieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gCondensedIntersectCellsNodeDistancePieDesc.descriptor := @gCondensedIntersectCellsNodeDistanceFunctionPieDesc;
  gCondensedIntersectCellsNodeDistancePieDesc.version := ANE_PIE_VERSION;
  gCondensedIntersectCellsNodeDistancePieDesc.vendor := PIEvendor;
  gCondensedIntersectCellsNodeDistancePieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gCondensedIntersectCellsNodeDistancePieDesc;
  // increment number of names
  Inc(numNames);













  // name of function
  gErrorCountFunctionPieDesc.name := PChar('ML_ErrorCount');
  // function address
  gErrorCountFunctionPieDesc.address := GErrorCount;
  // return value type
  gErrorCountFunctionPieDesc.returnType := kPIEInteger;
  // number of parameters
  gErrorCountFunctionPieDesc.numParams := 0;
  // number of optional parameters
  gErrorCountFunctionPieDesc.numOptParams := 0;
  // pointer to parameter names list
  gErrorCountFunctionPieDesc.paramNames := nil;
  // pointer to parameters types list
  gErrorCountFunctionPieDesc.paramTypes := nil;
  gErrorCountFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gErrorCountFunctionPieDesc.functionFlags := Options;
  gErrorCountFunctionPieDesc.category := PIEcategory;
  gErrorCountFunctionPieDesc.neededProject := PIEneededProject;

  // name of PIE
  gErrorCountPieDesc.name := PChar('ML_ErrorCount');
  // PIE type: PIE function
  gErrorCountPieDesc.PieType := kFunctionPIE;
  // pointer to descriptor
  gErrorCountPieDesc.descriptor := @gErrorCountFunctionPieDesc;
  gErrorCountPieDesc.version := ANE_PIE_VERSION;
  gErrorCountPieDesc.vendor := PIEvendor;
  gErrorCountPieDesc.product := PIEproduct;

  Assert(numNames < kMaxFunDesc);
  // add descriptor to list
  gFunDesc[numNames] := @gErrorCountPieDesc;
  // increment number of names
  Inc(numNames);













  descriptors := @gFunDesc;

end;

end.

