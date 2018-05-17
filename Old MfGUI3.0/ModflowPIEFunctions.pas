unit ModflowPIEFunctions;

interface

{ModflowPIEFunctions contains a function that adds PIE descriptors to the
 array of descriptors passed to Argus ONE.}

uses
  ProjectPIE, AnePIE, Forms, sysutils, Controls, classes;

Procedure GetMODFLOWFunctions(const Project, Vendor, Product : ANE_STR; var numNames : ANE_INT32);

implementation

uses  GetANEFunctionsUnit, MODFLOWPieDescriptors, ProjectFunctions,
      FunctionPIE, ImportPIE, MOC3DGridFunctions, ModflowTimeFunctions,
      ParamNamesAndTypes, ModflowLayerFunctions, MOC3DUnitFunctions,
      MOC3DParticleFunctions, ExportTemplatePIE, RunUnit, PostMODFLOWPieUnit,
      MODFLOW_FHBFunctions, MODPATHFunctionsUnit, HFBDisplay,
      ZoneBudgetFunctions, ModflowHelp, mpathplotUnit, WellDataUnit,
      CheckPIEVersionFunction;


Procedure GetMODFLOWFunctions(const Project, Vendor, Product : ANE_STR;  var numNames : ANE_INT32);
var
  UsualOptions : EFunctionPIEFlags ;
begin
  UsualOptions := kFunctionNeedsProject or kFunctionIsHidden;
//  UsualOptions := kFunctionNeedsProject;

	numNames := 0;

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They can be turned off
        in the final version. See Delphi help for more information.}

        //MODFLOW Project
	gMODFLOWProjectPDesc.version := PROJECT_PIE_VERSION;
	gMODFLOWProjectPDesc.name := Project;
	gMODFLOWProjectPDesc.projectFlags := kProjectCanEdit or
                                            kProjectShouldClean or
                                            kProjectShouldSave;
	gMODFLOWProjectPDesc.createNewProc := GProjectNew;
	gMODFLOWProjectPDesc.editProjectProc := GEditForm;
	gMODFLOWProjectPDesc.cleanProjectProc := GClearForm;
	gMODFLOWProjectPDesc.saveProc := GSaveForm;
	gMODFLOWProjectPDesc.loadProc := GLoadForm;

	gMODFLOWPieDesc.name  := '&New MODFLOW Project';
	gMODFLOWPieDesc.PieType :=  kProjectPIE;
	gMODFLOWPieDesc.descriptor := @gMODFLOWProjectPDesc;

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMODFLOWPieDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // MOCROW1 Pie descriptor
        gMocRow1FunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMocRow1FunctionDesc.functionFlags := UsualOptions ;   // Function options
        gMocRow1FunctionDesc.name := MOCROW1;                       // Function name
        gMocRow1FunctionDesc.address := GetMocRow1;                 // Function address
        gMocRow1FunctionDesc.returnType := kPIEInteger;              // return type
        gMocRow1FunctionDesc.numParams := 0;                        // number of parameters;
        gMocRow1FunctionDesc.numOptParams := 2;                      // number of optional parameters;
        gMocRow1FunctionDesc.paramNames := @gpnColumnRow;                     // paramter names
        gMocRow1FunctionDesc.paramTypes := @gTwoIntegerTypes;                      // parameter types
        gMocRow1FunctionDesc.neededProject := Project;               // needed project

        gMocRow1PieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMocRow1PieDesc.vendor :=  Vendor;                           // vendor
        gMocRow1PieDesc.product := Product;                          // product
	gMocRow1PieDesc.name  := MOCROW1;                            // function name
	gMocRow1PieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMocRow1PieDesc.descriptor := @gMocRow1FunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMocRow1PieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // MOCROW2 Pie descriptor
        gMocRow2FunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMocRow2FunctionDesc.functionFlags := UsualOptions ;// Function options
        gMocRow2FunctionDesc.name := MOCROW2;                       // Function name
        gMocRow2FunctionDesc.address := GetMocRow2;                 // Function address
        gMocRow2FunctionDesc.returnType := kPIEInteger;              // return type
        gMocRow2FunctionDesc.numParams := 0;                        // number of parameters;
        gMocRow2FunctionDesc.numOptParams := 2;                      // number of optional parameters;
        gMocRow2FunctionDesc.paramNames := @gpnColumnRow;                     // paramter names
        gMocRow2FunctionDesc.paramTypes := @gTwoIntegerTypes;                      // parameter types
        gMocRow2FunctionDesc.neededProject := Project;               // needed project

        gMocRow2PieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMocRow2PieDesc.vendor :=  Vendor;                           // vendor
        gMocRow2PieDesc.product := Product;                          // product
	gMocRow2PieDesc.name  := MOCROW2;                            // function name
	gMocRow2PieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMocRow2PieDesc.descriptor := @gMocRow2FunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMocRow2PieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // MOCROW1 Pie descriptor
        gMocCol1FunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMocCol1FunctionDesc.functionFlags := UsualOptions ;   // Function options
        gMocCol1FunctionDesc.name := MOCCOL1;                       // Function name
        gMocCol1FunctionDesc.address := GetMocCol1;                 // Function address
        gMocCol1FunctionDesc.returnType := kPIEInteger;              // return type
        gMocCol1FunctionDesc.numParams := 0;                        // number of parameters;
        gMocCol1FunctionDesc.numOptParams := 2;                      // number of optional parameters;
        gMocCol1FunctionDesc.paramNames := @gpnColumnRow;                     // paramter names
        gMocCol1FunctionDesc.paramTypes := @gTwoIntegerTypes;                      // parameter types
        gMocCol1FunctionDesc.neededProject := Project;               // needed project

        gMocCol1PieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMocCol1PieDesc.vendor :=  Vendor;                           // vendor
        gMocCol1PieDesc.product := Product;                          // product
	gMocCol1PieDesc.name  := MOCCOL1;                            // function name
	gMocCol1PieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMocCol1PieDesc.descriptor := @gMocCol1FunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMocCol1PieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // MOCROW2 Pie descriptor
        gMocCol2FunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMocCol2FunctionDesc.functionFlags := UsualOptions;    // Function options
        gMocCol2FunctionDesc.name := MOCCOL2;                       // Function name
        gMocCol2FunctionDesc.address := GetMocCol2;                 // Function address
        gMocCol2FunctionDesc.returnType := kPIEInteger;              // return type
        gMocCol2FunctionDesc.numParams := 0;                        // number of parameters;
        gMocCol2FunctionDesc.numOptParams := 2;                      // number of optional parameters;
        gMocCol2FunctionDesc.paramNames := @gpnColumnRow;                     // paramter names
        gMocCol2FunctionDesc.paramTypes := @gTwoIntegerTypes;                      // parameter types
        gMocCol2FunctionDesc.neededProject := Project;               // needed project

        gMocCol2PieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMocCol2PieDesc.vendor :=  Vendor;                           // vendor
        gMocCol2PieDesc.product := Product;                          // product
	gMocCol2PieDesc.name  := MOCCOL2;                            // function name
	gMocCol2PieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMocCol2PieDesc.descriptor := @gMocCol2FunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMocCol2PieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // Number of periods Pie descriptor
        gMFGetNumPerFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetNumPerFunctionDesc.functionFlags := kFunctionNeedsProject;  // Function options
        gMFGetNumPerFunctionDesc.name := 'MODFLOW_NPER';                       // Function name
        gMFGetNumPerFunctionDesc.address := GetNumPer;                 // Function address
        gMFGetNumPerFunctionDesc.returnType := kPIEInteger;              // return type
        gMFGetNumPerFunctionDesc.numParams := 0;                        // number of parameters;
        gMFGetNumPerFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetNumPerFunctionDesc.paramNames := nil;                     // paramter names
        gMFGetNumPerFunctionDesc.paramTypes := nil;                      // parameter types
        gMFGetNumPerFunctionDesc.neededProject := Project;               // needed project

        gMFGetNumPerPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetNumPerPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetNumPerPieDesc.product := Product;                          // product
	gMFGetNumPerPieDesc.name  := 'MODFLOW_NPER';                            // function name
	gMFGetNumPerPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetNumPerPieDesc.descriptor := @gMFGetNumPerFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetNumPerPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // Period length Pie descriptor
        gMFGetPerLengthFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetPerLengthFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetPerLengthFunctionDesc.name := 'MODFLOW_PERLEN';                       // Function name
        gMFGetPerLengthFunctionDesc.address := GetPerLength;                 // Function address
        gMFGetPerLengthFunctionDesc.returnType := kPIEFloat;              // return type
        gMFGetPerLengthFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetPerLengthFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetPerLengthFunctionDesc.paramNames := @gpnPeriod;                     // paramter names
        gMFGetPerLengthFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetPerLengthFunctionDesc.neededProject := Project;               // needed project

        gMFGetPerLengthPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetPerLengthPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetPerLengthPieDesc.product := Product;                          // product
	gMFGetPerLengthPieDesc.name  := 'MODFLOW_PERLEN';                            // function name
	gMFGetPerLengthPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetPerLengthPieDesc.descriptor := @gMFGetPerLengthFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetPerLengthPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // number of steps in Period Pie descriptor
        gMFGetPerStepsFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetPerStepsFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetPerStepsFunctionDesc.name := 'MODFLOW_NSTP';                       // Function name
        gMFGetPerStepsFunctionDesc.address := GetPerSteps;                 // Function address
        gMFGetPerStepsFunctionDesc.returnType := kPIEInteger;              // return type
        gMFGetPerStepsFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetPerStepsFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetPerStepsFunctionDesc.paramNames := @gpnPeriod;                     // paramter names
        gMFGetPerStepsFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetPerStepsFunctionDesc.neededProject := Project;               // needed project

        gMFGetPerStepsPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetPerStepsPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetPerStepsPieDesc.product := Product;                          // product
	gMFGetPerStepsPieDesc.name  := 'MODFLOW_NSTP';                            // function name
	gMFGetPerStepsPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetPerStepsPieDesc.descriptor := @gMFGetPerStepsFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetPerStepsPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // time step multiplier Pie descriptor
        gMFGetTimeStepMultFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetTimeStepMultFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetTimeStepMultFunctionDesc.name := 'MODFLOW_TSMULT';                       // Function name
        gMFGetTimeStepMultFunctionDesc.address := GetTimeStepMult;                 // Function address
        gMFGetTimeStepMultFunctionDesc.returnType := kPIEFloat;              // return type
        gMFGetTimeStepMultFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetTimeStepMultFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetTimeStepMultFunctionDesc.paramNames := @gpnPeriod;                     // paramter names
        gMFGetTimeStepMultFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetTimeStepMultFunctionDesc.neededProject := Project;               // needed project

        gMFGetTimeStepMultPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetTimeStepMultPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetTimeStepMultPieDesc.product := Product;                          // product
	gMFGetTimeStepMultPieDesc.name  := 'MODFLOW_TSMULT';                            // function name
	gMFGetTimeStepMultPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetTimeStepMultPieDesc.descriptor := @gMFGetTimeStepMultFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetTimeStepMultPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // number of geologic units PIE descriptor
        gMFGetNumUnitsFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetNumUnitsFunctionDesc.functionFlags := kFunctionNeedsProject;  // Function options
        gMFGetNumUnitsFunctionDesc.name := 'MODFLOW_NLAY';                       // Function name
        gMFGetNumUnitsFunctionDesc.address := GetNumUnits;                 // Function address
        gMFGetNumUnitsFunctionDesc.returnType := kPIEInteger;              // return type
        gMFGetNumUnitsFunctionDesc.numParams := 0;                        // number of parameters;
        gMFGetNumUnitsFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetNumUnitsFunctionDesc.paramNames := nil;                     // paramter names
        gMFGetNumUnitsFunctionDesc.paramTypes := nil;                      // parameter types
        gMFGetNumUnitsFunctionDesc.neededProject := Project;               // needed project

        gMFGetNumUnitsPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetNumUnitsPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetNumUnitsPieDesc.product := Product;                          // product
	gMFGetNumUnitsPieDesc.name  := 'MODFLOW_NLAY';                            // function name
	gMFGetNumUnitsPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetNumUnitsPieDesc.descriptor := @gMFGetNumUnitsFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetNumUnitsPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // anisotropy Pie descriptor
        gMFGetAnisotropyFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetAnisotropyFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetAnisotropyFunctionDesc.name := 'MODFLOW_TRPY';                       // Function name
        gMFGetAnisotropyFunctionDesc.address := GetAnisotropy;                 // Function address
        gMFGetAnisotropyFunctionDesc.returnType := kPIEFloat;              // return type
        gMFGetAnisotropyFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetAnisotropyFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetAnisotropyFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMFGetAnisotropyFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetAnisotropyFunctionDesc.neededProject := Project;               // needed project

        gMFGetAnisotropyPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetAnisotropyPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetAnisotropyPieDesc.product := Product;                          // product
	gMFGetAnisotropyPieDesc.name  := 'MODFLOW_TRPY';                            // function name
	gMFGetAnisotropyPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetAnisotropyPieDesc.descriptor := @gMFGetAnisotropyFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetAnisotropyPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // Unit Simulated Pie descriptor
        gMFGetUnitSimulatedFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetUnitSimulatedFunctionDesc.functionFlags := kFunctionNeedsProject;    // Function options
        gMFGetUnitSimulatedFunctionDesc.name := 'MODFLOW_SIMUL';                       // Function name
        gMFGetUnitSimulatedFunctionDesc.address := GetUnitSimulated;                 // Function address
        gMFGetUnitSimulatedFunctionDesc.returnType := kPIEBoolean;              // return type
        gMFGetUnitSimulatedFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetUnitSimulatedFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetUnitSimulatedFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMFGetUnitSimulatedFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetUnitSimulatedFunctionDesc.neededProject := Project;               // needed project

        gMFGetUnitSimulatedPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetUnitSimulatedPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetUnitSimulatedPieDesc.product := Product;                          // product
	gMFGetUnitSimulatedPieDesc.name  := 'MODFLOW_SIMUL';                            // function name
	gMFGetUnitSimulatedPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetUnitSimulatedPieDesc.descriptor := @gMFGetUnitSimulatedFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetUnitSimulatedPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get method of averaging transmissivity
        gMFGetUnitAvgMethFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetUnitAvgMethFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetUnitAvgMethFunctionDesc.name := 'MODFLOW_AVEMETHOD';                       // Function name
        gMFGetUnitAvgMethFunctionDesc.address := GetLayerAveragingMethod;                 // Function address
        gMFGetUnitAvgMethFunctionDesc.returnType := kPIEInteger;              // return type
        gMFGetUnitAvgMethFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetUnitAvgMethFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetUnitAvgMethFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMFGetUnitAvgMethFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetUnitAvgMethFunctionDesc.neededProject := Project;               // needed project

        gMFGetUnitAvgMethPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetUnitAvgMethPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetUnitAvgMethPieDesc.product := Product;                          // product
	gMFGetUnitAvgMethPieDesc.name  := 'MODFLOW_AVEMETHOD';                            // function name
	gMFGetUnitAvgMethPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetUnitAvgMethPieDesc.descriptor := @gMFGetUnitAvgMethFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetUnitAvgMethPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get layer type
        gMFGetLayerTypeFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetLayerTypeFunctionDesc.functionFlags := kFunctionNeedsProject;    // Function options
        gMFGetLayerTypeFunctionDesc.name := 'MODFLOW_LAYCON';                       // Function name
        gMFGetLayerTypeFunctionDesc.address := GetLayerType;                 // Function address
        gMFGetLayerTypeFunctionDesc.returnType := kPIEInteger;              // return type
        gMFGetLayerTypeFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetLayerTypeFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetLayerTypeFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMFGetLayerTypeFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetLayerTypeFunctionDesc.neededProject := Project;               // needed project

        gMFGetLayerTypePieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetLayerTypePieDesc.vendor :=  Vendor;                           // vendor
        gMFGetLayerTypePieDesc.product := Product;                          // product
	gMFGetLayerTypePieDesc.name  := 'MODFLOW_LAYCON';                            // function name
	gMFGetLayerTypePieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetLayerTypePieDesc.descriptor := @gMFGetLayerTypeFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetLayerTypePieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get vertical discretization
        gMFGetVerticalDiscrFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetVerticalDiscrFunctionDesc.functionFlags := kFunctionNeedsProject; // Function options
        gMFGetVerticalDiscrFunctionDesc.name := 'MODFLOW_NDIV';                       // Function name
        gMFGetVerticalDiscrFunctionDesc.address := GetLayerDiscretization;                 // Function address
        gMFGetVerticalDiscrFunctionDesc.returnType := kPIEInteger;              // return type
        gMFGetVerticalDiscrFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetVerticalDiscrFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetVerticalDiscrFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMFGetVerticalDiscrFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetVerticalDiscrFunctionDesc.neededProject := Project;               // needed project

        gMFGetVerticalDiscrPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetVerticalDiscrPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetVerticalDiscrPieDesc.product := Product;                          // product
	gMFGetVerticalDiscrPieDesc.name  := 'MODFLOW_NDIV';                            // function name
	gMFGetVerticalDiscrPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetVerticalDiscrPieDesc.descriptor := @gMFGetVerticalDiscrFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetVerticalDiscrPieDesc;                      // add descriptor to list
        Inc(numNames);

        // Unit uses transmissivity Pie descriptor
        gMFGetUnitUsesTransFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetUnitUsesTransFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetUnitUsesTransFunctionDesc.name := 'MODFLOW_SpecTrans';                       // Function name
        gMFGetUnitUsesTransFunctionDesc.address := GetUseTrans;                 // Function address
        gMFGetUnitUsesTransFunctionDesc.returnType := kPIEBoolean;              // return type
        gMFGetUnitUsesTransFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetUnitUsesTransFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetUnitUsesTransFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMFGetUnitUsesTransFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetUnitUsesTransFunctionDesc.neededProject := Project;               // needed project

        gMFGetUnitUsesTransPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetUnitUsesTransPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetUnitUsesTransPieDesc.product := Product;                          // product
	gMFGetUnitUsesTransPieDesc.name  := 'MODFLOW_SpecTrans';                            // function name
	gMFGetUnitUsesTransPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetUnitUsesTransPieDesc.descriptor := @gMFGetUnitUsesTransFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetUnitUsesTransPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // Unit uses VCONT Pie descriptor
        gMFGetUnitUsesVcontFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetUnitUsesVcontFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetUnitUsesVcontFunctionDesc.name := 'MODFLOW_SpecVcont';                       // Function name
        gMFGetUnitUsesVcontFunctionDesc.address := GetUseVcont;                 // Function address
        gMFGetUnitUsesVcontFunctionDesc.returnType := kPIEBoolean;              // return type
        gMFGetUnitUsesVcontFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetUnitUsesVcontFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetUnitUsesVcontFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMFGetUnitUsesVcontFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetUnitUsesVcontFunctionDesc.neededProject := Project;               // needed project

        gMFGetUnitUsesVcontPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetUnitUsesVcontPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetUnitUsesVcontPieDesc.product := Product;                          // product
	gMFGetUnitUsesVcontPieDesc.name  := 'MODFLOW_SpecVcont';                            // function name
	gMFGetUnitUsesVcontPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetUnitUsesVcontPieDesc.descriptor := @gMFGetUnitUsesVcontFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetUnitUsesVcontPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // Unit uses SP1 Pie descriptor
        gMFGetUnitUsesSF1FunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetUnitUsesSF1FunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetUnitUsesSF1FunctionDesc.name := 'MODFLOW_SpecSF1';                       // Function name
        gMFGetUnitUsesSF1FunctionDesc.address := GetUseSF1;                 // Function address
        gMFGetUnitUsesSF1FunctionDesc.returnType := kPIEBoolean;              // return type
        gMFGetUnitUsesSF1FunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetUnitUsesSF1FunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetUnitUsesSF1FunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMFGetUnitUsesSF1FunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetUnitUsesSF1FunctionDesc.neededProject := Project;               // needed project

        gMFGetUnitUsesSF1PieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetUnitUsesSF1PieDesc.vendor :=  Vendor;                           // vendor
        gMFGetUnitUsesSF1PieDesc.product := Product;                          // product
	gMFGetUnitUsesSF1PieDesc.name  := 'MODFLOW_SpecSF1';                            // function name
	gMFGetUnitUsesSF1PieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetUnitUsesSF1PieDesc.descriptor := @gMFGetUnitUsesSF1FunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetUnitUsesSF1PieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names




                                                     // increment number of names

        // get MODFLOW Layer
        gMFGetMODFLOWLayerFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetMODFLOWLayerFunctionDesc.functionFlags := kFunctionNeedsProject; // Function options
        gMFGetMODFLOWLayerFunctionDesc.name := 'MODFLOW_Layer';                       // Function name
        gMFGetMODFLOWLayerFunctionDesc.address := GetModflowLayer;                 // Function address
        gMFGetMODFLOWLayerFunctionDesc.returnType := kPIEInteger;              // return type
        gMFGetMODFLOWLayerFunctionDesc.numParams := 4;                        // number of parameters;
        gMFGetMODFLOWLayerFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetMODFLOWLayerFunctionDesc.paramNames := @gpnModflowLayerNames;                     // paramter names
        gMFGetMODFLOWLayerFunctionDesc.paramTypes := @g1Integer3RealTypes;                      // parameter types
        gMFGetMODFLOWLayerFunctionDesc.neededProject := Project;               // needed project

        gMFGetMODFLOWLayerPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetMODFLOWLayerPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetMODFLOWLayerPieDesc.product := Product;                          // product
	gMFGetMODFLOWLayerPieDesc.name  := 'MODFLOW_Layer';                            // function name
	gMFGetMODFLOWLayerPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetMODFLOWLayerPieDesc.descriptor := @gMFGetMODFLOWLayerFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetMODFLOWLayerPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MOC longitudingal dispersion
        gMOCGetLongDispFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMOCGetLongDispFunctionDesc.functionFlags := UsualOptions; // Function options
        gMOCGetLongDispFunctionDesc.name := 'MODFLOW_MOC_ALONG';                       // Function name
        gMOCGetLongDispFunctionDesc.address := GetMOCLongDisp;                 // Function address
        gMOCGetLongDispFunctionDesc.returnType := kPIEFloat;              // return type
        gMOCGetLongDispFunctionDesc.numParams := 1;                        // number of parameters;
        gMOCGetLongDispFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMOCGetLongDispFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMOCGetLongDispFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMOCGetLongDispFunctionDesc.neededProject := Project;               // needed project

        gMOCGetLongDispPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMOCGetLongDispPieDesc.vendor :=  Vendor;                           // vendor
        gMOCGetLongDispPieDesc.product := Product;                          // product
	gMOCGetLongDispPieDesc.name  := 'MODFLOW_MOC_ALONG';                            // function name
	gMOCGetLongDispPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMOCGetLongDispPieDesc.descriptor := @gMOCGetLongDispFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMOCGetLongDispPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MOC transverse horizontal dispersion
        gMOCGetTransHorDispFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMOCGetTransHorDispFunctionDesc.functionFlags := UsualOptions; // Function options
        gMOCGetTransHorDispFunctionDesc.name := 'MODFLOW_MOC_ATRANH';                       // Function name
        gMOCGetTransHorDispFunctionDesc.address := GetMOCTransHorDisp;                 // Function address
        gMOCGetTransHorDispFunctionDesc.returnType := kPIEFloat;              // return type
        gMOCGetTransHorDispFunctionDesc.numParams := 1;                        // number of parameters;
        gMOCGetTransHorDispFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMOCGetTransHorDispFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMOCGetTransHorDispFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMOCGetTransHorDispFunctionDesc.neededProject := Project;               // needed project

        gMOCGetTransHorDispPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMOCGetTransHorDispPieDesc.vendor :=  Vendor;                           // vendor
        gMOCGetTransHorDispPieDesc.product := Product;                          // product
	gMOCGetTransHorDispPieDesc.name  := 'MODFLOW_MOC_ATRANH';                            // function name
	gMOCGetTransHorDispPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMOCGetTransHorDispPieDesc.descriptor := @gMOCGetTransHorDispFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMOCGetTransHorDispPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MOC transverse horizontal dispersion
        gMOCGetTransVertDispFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMOCGetTransVertDispFunctionDesc.functionFlags := UsualOptions; // Function options
        gMOCGetTransVertDispFunctionDesc.name := 'MODFLOW_MOC_ATRANV';                       // Function name
        gMOCGetTransVertDispFunctionDesc.address := GetMOCTransVerDisp;                 // Function address
        gMOCGetTransVertDispFunctionDesc.returnType := kPIEFloat;              // return type
        gMOCGetTransVertDispFunctionDesc.numParams := 1;                        // number of parameters;
        gMOCGetTransVertDispFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMOCGetTransVertDispFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMOCGetTransVertDispFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMOCGetTransVertDispFunctionDesc.neededProject := Project;               // needed project

        gMOCGetTransVertDispPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMOCGetTransVertDispPieDesc.vendor :=  Vendor;                           // vendor
        gMOCGetTransVertDispPieDesc.product := Product;                          // product
	gMOCGetTransVertDispPieDesc.name  := 'MODFLOW_MOC_ATRANV';                            // function name
	gMOCGetTransVertDispPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMOCGetTransVertDispPieDesc.descriptor := @gMOCGetTransVertDispFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMOCGetTransVertDispPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MOC retardation factor
        gMOCGetRetardationFactorFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMOCGetRetardationFactorFunctionDesc.functionFlags := UsualOptions; // Function options
        gMOCGetRetardationFactorFunctionDesc.name := 'MODFLOW_MOC_RF';                       // Function name
        gMOCGetRetardationFactorFunctionDesc.address := GetMOCRetardation;                 // Function address
        gMOCGetRetardationFactorFunctionDesc.returnType := kPIEFloat;              // return type
        gMOCGetRetardationFactorFunctionDesc.numParams := 1;                        // number of parameters;
        gMOCGetRetardationFactorFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMOCGetRetardationFactorFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMOCGetRetardationFactorFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMOCGetRetardationFactorFunctionDesc.neededProject := Project;               // needed project

        gMOCGetRetardationFactorPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMOCGetRetardationFactorPieDesc.vendor :=  Vendor;                           // vendor
        gMOCGetRetardationFactorPieDesc.product := Product;                          // product
	gMOCGetRetardationFactorPieDesc.name  := 'MODFLOW_MOC_RF';                            // function name
	gMOCGetRetardationFactorPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMOCGetRetardationFactorPieDesc.descriptor := @gMOCGetRetardationFactorFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMOCGetRetardationFactorPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MOC C' Bound
        gMOCGetCBoundFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMOCGetCBoundFunctionDesc.functionFlags := UsualOptions; // Function options
        gMOCGetCBoundFunctionDesc.name := 'MODFLOW_MOC_CINFL';                       // Function name
        gMOCGetCBoundFunctionDesc.address := GetMOCCBound;                 // Function address
        gMOCGetCBoundFunctionDesc.returnType := kPIEFloat;              // return type
        gMOCGetCBoundFunctionDesc.numParams := 1;                        // number of parameters;
        gMOCGetCBoundFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMOCGetCBoundFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMOCGetCBoundFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMOCGetCBoundFunctionDesc.neededProject := Project;               // needed project

        gMOCGetCBoundPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMOCGetCBoundPieDesc.vendor :=  Vendor;                           // vendor
        gMOCGetCBoundPieDesc.product := Product;                          // product
	gMOCGetCBoundPieDesc.name  := 'MODFLOW_MOC_CINFL';                            // function name
	gMOCGetCBoundPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMOCGetCBoundPieDesc.descriptor := @gMOCGetCBoundFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMOCGetCBoundPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get Particle Layer Postion
        gMOCGetParticleLayerPositionFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMOCGetParticleLayerPositionFunctionDesc.functionFlags := UsualOptions; // Function options
        gMOCGetParticleLayerPositionFunctionDesc.name := 'MODFLOW_MOC_PNEWL';                       // Function name
        gMOCGetParticleLayerPositionFunctionDesc.address := GetParticleLayerPosition;                 // Function address
        gMOCGetParticleLayerPositionFunctionDesc.returnType := kPIEFloat;              // return type
        gMOCGetParticleLayerPositionFunctionDesc.numParams := 1;                        // number of parameters;
        gMOCGetParticleLayerPositionFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMOCGetParticleLayerPositionFunctionDesc.paramNames := @gpnNumber;                     // paramter names
        gMOCGetParticleLayerPositionFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMOCGetParticleLayerPositionFunctionDesc.neededProject := Project;               // needed project

        gMOCGetParticleLayerPositionPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMOCGetParticleLayerPositionPieDesc.vendor :=  Vendor;                           // vendor
        gMOCGetParticleLayerPositionPieDesc.product := Product;                          // product
	gMOCGetParticleLayerPositionPieDesc.name  := 'MODFLOW_MOC_PNEWL';                            // function name
	gMOCGetParticleLayerPositionPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMOCGetParticleLayerPositionPieDesc.descriptor := @gMOCGetParticleLayerPositionFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMOCGetParticleLayerPositionPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get Particle Row Postion
        gMOCGetParticleRowPositionFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMOCGetParticleRowPositionFunctionDesc.functionFlags := UsualOptions; // Function options
        gMOCGetParticleRowPositionFunctionDesc.name := 'MODFLOW_MOC_PNEWR';                       // Function name
        gMOCGetParticleRowPositionFunctionDesc.address := GetParticleRowPosition;                 // Function address
        gMOCGetParticleRowPositionFunctionDesc.returnType := kPIEFloat;              // return type
        gMOCGetParticleRowPositionFunctionDesc.numParams := 1;                        // number of parameters;
        gMOCGetParticleRowPositionFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMOCGetParticleRowPositionFunctionDesc.paramNames := @gpnNumber;                     // paramter names
        gMOCGetParticleRowPositionFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMOCGetParticleRowPositionFunctionDesc.neededProject := Project;               // needed project

        gMOCGetParticleRowPositionPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMOCGetParticleRowPositionPieDesc.vendor :=  Vendor;                           // vendor
        gMOCGetParticleRowPositionPieDesc.product := Product;                          // product
	gMOCGetParticleRowPositionPieDesc.name  := 'MODFLOW_MOC_PNEWR';                            // function name
	gMOCGetParticleRowPositionPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMOCGetParticleRowPositionPieDesc.descriptor := @gMOCGetParticleRowPositionFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMOCGetParticleRowPositionPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get Particle Row Postion
        gMOCGetParticleColumnPositionFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMOCGetParticleColumnPositionFunctionDesc.functionFlags := UsualOptions; // Function options
        gMOCGetParticleColumnPositionFunctionDesc.name := 'MODFLOW_MOC_PNEWC';                       // Function name
        gMOCGetParticleColumnPositionFunctionDesc.address := GetParticleColumnPosition;                 // Function address
        gMOCGetParticleColumnPositionFunctionDesc.returnType := kPIEFloat;              // return type
        gMOCGetParticleColumnPositionFunctionDesc.numParams := 1;                        // number of parameters;
        gMOCGetParticleColumnPositionFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMOCGetParticleColumnPositionFunctionDesc.paramNames := @gpnNumber;                     // paramter names
        gMOCGetParticleColumnPositionFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMOCGetParticleColumnPositionFunctionDesc.neededProject := Project;               // needed project

        gMOCGetParticleColumnPositionPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMOCGetParticleColumnPositionPieDesc.vendor :=  Vendor;                           // vendor
        gMOCGetParticleColumnPositionPieDesc.product := Product;                          // product
	gMOCGetParticleColumnPositionPieDesc.name  := 'MODFLOW_MOC_PNEWC';                            // function name
	gMOCGetParticleColumnPositionPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMOCGetParticleColumnPositionPieDesc.descriptor := @gMOCGetParticleColumnPositionFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMOCGetParticleColumnPositionPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // Run Model
	gMFRunExportPIEDesc.name := 'Run &MODFLOW/MOC3D';
	gMFRunExportPIEDesc.exportType := kPIEGridLayer;
	gMFRunExportPIEDesc.exportFlags := kExportNeedsProject or kExportDontShowParamDialog;
	gMFRunExportPIEDesc.getTemplateProc := RunModflowPIE;
        gMFRunExportPIEDesc.preExportProc := nil;
        gMFRunExportPIEDesc.postExportProc := nil;
	gMFRunExportPIEDesc.neededProject := Project;

        gMFRunPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFRunPIEDesc.vendor :=  Vendor;                           // vendor
        gMFRunPIEDesc.product := Product;                          // product
	gMFRunPIEDesc.name  := 'Run &MODFLOW/MOC3D';
	gMFRunPIEDesc.PieType :=  kExportTemplatePIE;
	gMFRunPIEDesc.descriptor := @gMFRunExportPIEDesc;

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gMFRunPIEDesc;
        Inc(numNames);	// add descriptor to list

        // Run MODPATH
	gMFRunMPATHExportPIEDesc.name := 'Run MOD&PATH';
	gMFRunMPATHExportPIEDesc.exportType := kPIEGridLayer;
	gMFRunMPATHExportPIEDesc.exportFlags := kExportNeedsProject or kExportDontShowParamDialog;
	gMFRunMPATHExportPIEDesc.getTemplateProc := RunModpathPIE;
        gMFRunMPATHExportPIEDesc.preExportProc := nil;
        gMFRunMPATHExportPIEDesc.postExportProc := nil;
	gMFRunMPATHExportPIEDesc.neededProject := Project;

        gMFRunMPATHPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFRunMPATHPIEDesc.vendor :=  Vendor;                           // vendor
        gMFRunMPATHPIEDesc.product := Product;                          // product
	gMFRunMPATHPIEDesc.name  := 'Run MOD&PATH';
	gMFRunMPATHPIEDesc.PieType :=  kExportTemplatePIE;
	gMFRunMPATHPIEDesc.descriptor := @gMFRunMPATHExportPIEDesc;

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gMFRunMPATHPIEDesc;
        Inc(numNames);	// add descriptor to list

        // Run ZONEBDGT
	gMFRunZonebdgtExportPIEDesc.name := 'Run &ZONEBDGT';
	gMFRunZonebdgtExportPIEDesc.exportType := kPIEGridLayer;
	gMFRunZonebdgtExportPIEDesc.exportFlags := kExportNeedsProject or kExportDontShowParamDialog;
	gMFRunZonebdgtExportPIEDesc.getTemplateProc := RunZondbdgtPIE;
        gMFRunZonebdgtExportPIEDesc.preExportProc := nil;
        gMFRunZonebdgtExportPIEDesc.postExportProc := nil;
	gMFRunZonebdgtExportPIEDesc.neededProject := Project;

        gMFRunZonebdgtPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFRunZonebdgtPIEDesc.vendor :=  Vendor;                           // vendor
        gMFRunZonebdgtPIEDesc.product := Product;                          // product
	gMFRunZonebdgtPIEDesc.name  := 'Run &ZONEBDGT';
	gMFRunZonebdgtPIEDesc.PieType :=  kExportTemplatePIE;
	gMFRunZonebdgtPIEDesc.descriptor := @gMFRunZonebdgtExportPIEDesc;

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gMFRunZonebdgtPIEDesc;
        Inc(numNames);	// add descriptor to list

        gMFPostImportPIEDesc.version := IMPORT_PIE_VERSION;
	gMFPostImportPIEDesc.name := 'MOD&FLOW/MOC3D Post Processing';
	gMFPostImportPIEDesc.importFlags := kImportAllwaysVisible or kImportNeedsProject;
        gMFPostImportPIEDesc.toLayerTypes :=   kPIEAnyLayer;
        gMFPostImportPIEDesc.fromLayerTypes :=   kPIEAnyLayer;
	gMFPostImportPIEDesc.doImportProc := GPostProcessingPIE;
	gMFPostImportPIEDesc.neededProject := Project;

        gMFPostPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFPostPIEDesc.vendor :=  Vendor;                           // vendor
        gMFPostPIEDesc.product := Product;                          // product
	gMFPostPIEDesc.name  := 'MOD&FLOW/MOC3D Post Processing';
	gMFPostPIEDesc.PieType :=  kImportPIE;
	gMFPostPIEDesc.descriptor := @gMFPostImportPIEDesc;

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gMFPostPIEDesc;
        Inc(numNames);	// add descriptor to list 

        // Period length Pie descriptor
        gMFGetFHBTimeFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetFHBTimeFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetFHBTimeFunctionDesc.name := 'MODFLOW_FHB_Time';                       // Function name
        gMFGetFHBTimeFunctionDesc.address := GetMF_FHBTime;                 // Function address
        gMFGetFHBTimeFunctionDesc.returnType := kPIEFloat;              // return type
        gMFGetFHBTimeFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetFHBTimeFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetFHBTimeFunctionDesc.paramNames := @gpnPeriod;                     // paramter names
        gMFGetFHBTimeFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetFHBTimeFunctionDesc.neededProject := Project;               // needed project

        gMFGetFHBTimePieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetFHBTimePieDesc.vendor :=  Vendor;                           // vendor
        gMFGetFHBTimePieDesc.product := Product;                          // product
	gMFGetFHBTimePieDesc.name  := 'MODFLOW_FHB_Time';                            // function name
	gMFGetFHBTimePieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetFHBTimePieDesc.descriptor := @gMFGetFHBTimeFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetFHBTimePieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // MODPATH Times
        gMFGetMODPATHTimeFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetMODPATHTimeFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetMODPATHTimeFunctionDesc.name := 'MODFLOW_ModpathTime';                       // Function name
        gMFGetMODPATHTimeFunctionDesc.address := GetMODPATHTime;                 // Function address
        gMFGetMODPATHTimeFunctionDesc.returnType := kPIEFloat;              // return type
        gMFGetMODPATHTimeFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetMODPATHTimeFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetMODPATHTimeFunctionDesc.paramNames := @gpnTimeIndex;                     // paramter names
        gMFGetMODPATHTimeFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetMODPATHTimeFunctionDesc.neededProject := Project;               // needed project

        gMFGetMODPATHTimePieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetMODPATHTimePieDesc.vendor :=  Vendor;                           // vendor
        gMFGetMODPATHTimePieDesc.product := Product;                          // product
	gMFGetMODPATHTimePieDesc.name  := 'MODFLOW_ModpathTime';                            // function name
	gMFGetMODPATHTimePieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetMODPATHTimePieDesc.descriptor := @gMFGetMODPATHTimeFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetMODPATHTimePieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // display HFB
        gMFDisplayHFBImportPIEDesc.version := IMPORT_PIE_VERSION;
	gMFDisplayHFBImportPIEDesc.name := '&Display Horizontal Flow Barriers';
	gMFDisplayHFBImportPIEDesc.importFlags := kImportAllwaysVisible or kImportNeedsProject;
        gMFDisplayHFBImportPIEDesc.toLayerTypes :=   kPIEAnyLayer;
        gMFDisplayHFBImportPIEDesc.fromLayerTypes :=   kPIEAnyLayer;
	gMFDisplayHFBImportPIEDesc.doImportProc := GDisplayHFBPIE;
	gMFDisplayHFBImportPIEDesc.neededProject := Project;

        gMFDisplayHFBPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFDisplayHFBPIEDesc.vendor :=  Vendor;                           // vendor
        gMFDisplayHFBPIEDesc.product := Product;                          // product
	gMFDisplayHFBPIEDesc.name  := '&Display Horizontal Flow Barriers';
	gMFDisplayHFBPIEDesc.PieType :=  kImportPIE;
	gMFDisplayHFBPIEDesc.descriptor := @gMFDisplayHFBImportPIEDesc;

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gMFDisplayHFBPIEDesc;
        Inc(numNames);	// add descriptor to list

        // Zonebud Time Count
        gMFGetZonebudTimeCountFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetZonebudTimeCountFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetZonebudTimeCountFunctionDesc.name := 'MODFLOW_ZonebudTimeCount';                       // Function name
        gMFGetZonebudTimeCountFunctionDesc.address := GetZoneBudTimeCount;                 // Function address
        gMFGetZonebudTimeCountFunctionDesc.returnType := kPIEInteger;              // return type
        gMFGetZonebudTimeCountFunctionDesc.numParams := 0;                        // number of parameters;
        gMFGetZonebudTimeCountFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetZonebudTimeCountFunctionDesc.paramNames := nil;                     // paramter names
        gMFGetZonebudTimeCountFunctionDesc.paramTypes := nil;                      // parameter types
        gMFGetZonebudTimeCountFunctionDesc.neededProject := Project;               // needed project

        gMFGetZonebudTimeCountPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetZonebudTimeCountPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetZonebudTimeCountPieDesc.product := Product;                          // product
	gMFGetZonebudTimeCountPieDesc.name  := 'MODFLOW_ZonebudTimeCount';                            // function name
	gMFGetZonebudTimeCountPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetZonebudTimeCountPieDesc.descriptor := @gMFGetZonebudTimeCountFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetZonebudTimeCountPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // Zonebud Time Step
        gMFGetZonebudTimeStepFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetZonebudTimeStepFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetZonebudTimeStepFunctionDesc.name := 'MODFLOW_ZonebudTimeStep';                       // Function name
        gMFGetZonebudTimeStepFunctionDesc.address := GetZoneBudTimeStep;                 // Function address
        gMFGetZonebudTimeStepFunctionDesc.returnType := kPIEInteger;              // return type
        gMFGetZonebudTimeStepFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetZonebudTimeStepFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetZonebudTimeStepFunctionDesc.paramNames := @gpnTimeIndex;                     // paramter names
        gMFGetZonebudTimeStepFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetZonebudTimeStepFunctionDesc.neededProject := Project;               // needed project

        gMFGetZonebudTimeStepPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetZonebudTimeStepPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetZonebudTimeStepPieDesc.product := Product;                          // product
	gMFGetZonebudTimeStepPieDesc.name  := 'MODFLOW_ZonebudTimeStep';                            // function name
	gMFGetZonebudTimeStepPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetZonebudTimeStepPieDesc.descriptor := @gMFGetZonebudTimeStepFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetZonebudTimeStepPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // Zonebud Stress Period
        gMFGetZonebudStessPeriodFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetZonebudStessPeriodFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetZonebudStessPeriodFunctionDesc.name := 'MODFLOW_ZonebudStessPeriod';              // Function name
        gMFGetZonebudStessPeriodFunctionDesc.address := GetZoneBudStressPeriod;                 // Function address
        gMFGetZonebudStessPeriodFunctionDesc.returnType := kPIEInteger;              // return type
        gMFGetZonebudStessPeriodFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetZonebudStessPeriodFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetZonebudStessPeriodFunctionDesc.paramNames := @gpnTimeIndex;                     // paramter names
        gMFGetZonebudStessPeriodFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetZonebudStessPeriodFunctionDesc.neededProject := Project;               // needed project

        gMFGetZonebudStessPeriodPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetZonebudStessPeriodPieDesc.vendor :=  Vendor;                           // vendor
        gMFGetZonebudStessPeriodPieDesc.product := Product;                          // product
	gMFGetZonebudStessPeriodPieDesc.name  := 'MODFLOW_ZonebudStessPeriod';                            // function name
	gMFGetZonebudStessPeriodPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetZonebudStessPeriodPieDesc.descriptor := @gMFGetZonebudStessPeriodFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetZonebudStessPeriodPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // Zonebud Composite Zone
        gMFGetZonebudCompositeZoneFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMFGetZonebudCompositeZoneFunctionDesc.functionFlags := UsualOptions;    // Function options
        gMFGetZonebudCompositeZoneFunctionDesc.name := 'MODFLOW_ZonebudCompositeZone';                       // Function name
        gMFGetZonebudCompositeZoneFunctionDesc.address := GetZoneBudCompositeZone;                 // Function address
        gMFGetZonebudCompositeZoneFunctionDesc.returnType := kPIEString;              // return type
        gMFGetZonebudCompositeZoneFunctionDesc.numParams := 1;                        // number of parameters;
        gMFGetZonebudCompositeZoneFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMFGetZonebudCompositeZoneFunctionDesc.paramNames := @gpnZone;                     // paramter names
        gMFGetZonebudCompositeZoneFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMFGetZonebudCompositeZoneFunctionDesc.neededProject := Project;               // needed project

        gMFGetZonebudCompositeZonePieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFGetZonebudCompositeZonePieDesc.vendor :=  Vendor;                           // vendor
        gMFGetZonebudCompositeZonePieDesc.product := Product;                          // product
	gMFGetZonebudCompositeZonePieDesc.name  := 'MODFLOW_ZonebudCompositeZone';                            // function name
	gMFGetZonebudCompositeZonePieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMFGetZonebudCompositeZonePieDesc.descriptor := @gMFGetZonebudCompositeZoneFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gMFGetZonebudCompositeZonePieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // MODPATH post processing
        gMFModpathPostImportPIEDesc.version := IMPORT_PIE_VERSION;
	gMFModpathPostImportPIEDesc.name := 'M&ODPATH Post Processing';
	gMFModpathPostImportPIEDesc.importFlags := kImportAllwaysVisible or kImportNeedsProject;
        gMFModpathPostImportPIEDesc.toLayerTypes :=   kPIEAnyLayer;
        gMFModpathPostImportPIEDesc.fromLayerTypes :=   kPIEAnyLayer;
	gMFModpathPostImportPIEDesc.doImportProc := ReadModpath;
	gMFModpathPostImportPIEDesc.neededProject := Project;

        gMFModpathPostPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFModpathPostPIEDesc.vendor :=  Vendor;                           // vendor
        gMFModpathPostPIEDesc.product := Product;                          // product
	gMFModpathPostPIEDesc.name  := 'M&ODPATH Post Processing';
	gMFModpathPostPIEDesc.PieType :=  kImportPIE;
	gMFModpathPostPIEDesc.descriptor := @gMFModpathPostImportPIEDesc;

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gMFModpathPostPIEDesc;
        Inc(numNames);	// add descriptor to list

        // MODFLOW Help
        gMFHelpImportPIEDesc.version := IMPORT_PIE_VERSION;
	gMFHelpImportPIEDesc.name := 'MODFLOW &Help';
	gMFHelpImportPIEDesc.importFlags := kImportAllwaysVisible;
        gMFHelpImportPIEDesc.toLayerTypes :=   kPIEAnyLayer;
        gMFHelpImportPIEDesc.fromLayerTypes :=   kPIEAnyLayer;
	gMFHelpImportPIEDesc.doImportProc := ShowModflowHelp;
	gMFHelpImportPIEDesc.neededProject := '';

        gMFHelpPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFHelpPIEDesc.vendor :=  Vendor;                           // vendor
        gMFHelpPIEDesc.product := Product;                          // product
	gMFHelpPIEDesc.name  := 'MODFLOW &Help';
	gMFHelpPIEDesc.PieType :=  kImportPIE;
	gMFHelpPIEDesc.descriptor := @gMFHelpImportPIEDesc;

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gMFHelpPIEDesc;
        Inc(numNames);	// add descriptor to list

        // Import Well layer
        gMFImportWellsImportPIEDesc.version := IMPORT_PIE_VERSION;
	gMFImportWellsImportPIEDesc.name := 'Import Wells';
	gMFImportWellsImportPIEDesc.importFlags := kImportNeedsProject ;
        gMFImportWellsImportPIEDesc.toLayerTypes := kPIEAnyLayer;
        gMFImportWellsImportPIEDesc.fromLayerTypes := 0;
	gMFImportWellsImportPIEDesc.doImportProc := ImportWells;
	gMFImportWellsImportPIEDesc.neededProject := Project;

        gMFImportWellsPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFImportWellsPIEDesc.vendor :=  Vendor;                           // vendor
        gMFImportWellsPIEDesc.product := Product;                          // product
	gMFImportWellsPIEDesc.name  := 'Import Wells';
	gMFImportWellsPIEDesc.PieType :=  kImportPIE;
	gMFImportWellsPIEDesc.descriptor := @gMFImportWellsImportPIEDesc;

	Assert (numNames < kMaxPIEDesc) ;
        gPIEDesc[numNames] := @gMFImportWellsPIEDesc;
        Inc(numNames);	// add descriptor to list

	gPIECheckVersionFDesc.name := 'MODFLOW_CheckVersion';	        // name of function
	gPIECheckVersionFDesc.address := GPIECheckVersionMMFun;		// function address
	gPIECheckVersionFDesc.returnType := kPIEBoolean;		// return value type
	gPIECheckVersionFDesc.numParams :=  4;			// number of parameters
	gPIECheckVersionFDesc.numOptParams := 0;			// number of optional parameters
	gPIECheckVersionFDesc.paramNames := @gpnFourDigit;		// pointer to parameter names list
	gPIECheckVersionFDesc.paramTypes := @gFourIntegerTypes;	// pointer to parameters types list
        gPIECheckVersionFDesc.version := FUNCTION_PIE_VERSION;
        gPIECheckVersionFDesc.functionFlags := UsualOptions;

       	gPIECheckVersionDesc.name  := 'MODFLOW_CheckVersion';		// name of PIE
	gPIECheckVersionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;	// pointer to descriptor
        gPIECheckVersionDesc.version := ANE_PIE_VERSION;
        gPIECheckVersionDesc.vendor := vendor;
        gPIECheckVersionDesc.product := product;

	Assert (numNames < kMaxPIEDesc) ;
	gPIEDesc[numNames] := @gPIECheckVersionDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names



end;

end.
