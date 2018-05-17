unit GetAneFunctionsUnit;

interface

uses AnePIE, ImportPIE;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;


implementation

uses frmImportCrossSectionUnit, CalculateSutraAngles, FunctionPIE,
  ParamNamesAndTypes;

const
  kMaxFunDesc = 5;

// global variables.

var
   // list of PIE descriptors 
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;

   // PIE descriptor
   gCrossSectionsPIEDesc  : ANEPIEDesc;
   // ImportPIE descriptor
   gCrossSectionsImportPIEDesc : ImportPIEDesc;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
  numNames := 0;

   // ImportPIE descriptor
  gCrossSectionsImportPIEDesc.version := IMPORT_PIE_VERSION;
  // name of PIE
  gCrossSectionsImportPIEDesc.name := 'Import from cross sections...';
  gCrossSectionsImportPIEDesc.importFlags := 0;
  gCrossSectionsImportPIEDesc.fromLayerTypes := kPIEAnyLayer ;
  gCrossSectionsImportPIEDesc.toLayerTypes := kPIEAnyLayer ;
  // address of function that does the work.
  gCrossSectionsImportPIEDesc.doImportProc := @ImportCrossSection;

  // PIE descriptor
  // name of PIE
  gCrossSectionsPIEDesc.name := 'Import from cross sections...';      
  gCrossSectionsPIEDesc.PieType := kImportPIE;
  // pointer to descriptor
  gCrossSectionsPIEDesc.descriptor := @gCrossSectionsImportPIEDesc;

  // add descriptor to list
  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gCrossSectionsPIEDesc;
  Inc(numNames);

  // Sutra Angle 1.
  gSutraAngle1FunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gSutraAngle1FunctionPieDesc.functionFlags := 0;
  gSutraAngle1FunctionPieDesc.name := 'SUTRA_Angle1';
  gSutraAngle1FunctionPieDesc.address := @CalculateAngle1;
  gSutraAngle1FunctionPieDesc.returnType := kPIEFloat;
  gSutraAngle1FunctionPieDesc.numParams := 3;
  gSutraAngle1FunctionPieDesc.numOptParams := 0;
  gSutraAngle1FunctionPieDesc.paramNames := @gpnMapHeadingDipDipDirection;
  gSutraAngle1FunctionPieDesc.paramTypes := @gThreeDoubleTypes;

  gSutraAngle1PIEDesc.version := ANE_PIE_VERSION;
  gSutraAngle1PIEDesc.name  := 'SUTRA_Angle1';		// name of PIE
  gSutraAngle1PIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gSutraAngle1PIEDesc.descriptor := @gSutraAngle1FunctionPieDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gSutraAngle1PIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  // Sutra Angle 2.
  gSutraAngle2FunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gSutraAngle2FunctionPieDesc.functionFlags := 0;
  gSutraAngle2FunctionPieDesc.name := 'SUTRA_Angle2';
  gSutraAngle2FunctionPieDesc.address := @CalculateAngle2;
  gSutraAngle2FunctionPieDesc.returnType := kPIEFloat;
  gSutraAngle2FunctionPieDesc.numParams := 3;
  gSutraAngle2FunctionPieDesc.numOptParams := 0;
  gSutraAngle2FunctionPieDesc.paramNames := @gpnMapHeadingDipDipDirection;
  gSutraAngle2FunctionPieDesc.paramTypes := @gThreeDoubleTypes;

  gSutraAngle2PIEDesc.version := ANE_PIE_VERSION;
  gSutraAngle2PIEDesc.name  := 'SUTRA_Angle2';		// name of PIE
  gSutraAngle2PIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gSutraAngle2PIEDesc.descriptor := @gSutraAngle2FunctionPieDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gSutraAngle2PIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  // Sutra Angle 3.
  gSutraAngle3FunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gSutraAngle3FunctionPieDesc.functionFlags := 0;
  gSutraAngle3FunctionPieDesc.name := 'SUTRA_Angle3';
  gSutraAngle3FunctionPieDesc.address := @CalculateAngle3;
  gSutraAngle3FunctionPieDesc.returnType := kPIEFloat;
  gSutraAngle3FunctionPieDesc.numParams := 3;
  gSutraAngle3FunctionPieDesc.numOptParams := 0;
  gSutraAngle3FunctionPieDesc.paramNames := @gpnMapHeadingDipDipDirection;
  gSutraAngle3FunctionPieDesc.paramTypes := @gThreeDoubleTypes;

  gSutraAngle3PIEDesc.version := ANE_PIE_VERSION;
  gSutraAngle3PIEDesc.name  := 'SUTRA_Angle3';		// name of PIE
  gSutraAngle3PIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gSutraAngle3PIEDesc.descriptor := @gSutraAngle3FunctionPieDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gSutraAngle3PIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  // Average Angles
  gAverageAnglesFunctionPieDesc.version := FUNCTION_PIE_VERSION;
  gAverageAnglesFunctionPieDesc.functionFlags := 0;
  gAverageAnglesFunctionPieDesc.name := 'Average_Angles';
  gAverageAnglesFunctionPieDesc.address := @AverageAngles;
  gAverageAnglesFunctionPieDesc.returnType := kPIEFloat;
  gAverageAnglesFunctionPieDesc.numParams := 3;
  gAverageAnglesFunctionPieDesc.numOptParams := 0;
  gAverageAnglesFunctionPieDesc.paramNames := @gpnAngle1Angle2Fraction;
  gAverageAnglesFunctionPieDesc.paramTypes := @gThreeDoubleTypes;

  gAverageAnglesPIEDesc.version := ANE_PIE_VERSION;
  gAverageAnglesPIEDesc.name  := 'Average_Angles';		// name of PIE
  gAverageAnglesPIEDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
  gAverageAnglesPIEDesc.descriptor := @gAverageAnglesFunctionPieDesc;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gAverageAnglesPIEDesc;  // add descriptor to list
  Inc(numNames);	// increment number of names

  descriptors := @gFunDesc;

end;

end.
