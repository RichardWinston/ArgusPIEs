unit MT3DPieDescriptors;

interface

uses
  FunctionPIE, AnePIE, ImportPIE, ExportTemplatePIE;

var
  gMT3D_DTOFunctionDesc : FunctionPIEDesc ;
  gMT3D_DTOPieDesc      : ANEPIEDesc ;

  gMT3D_MXSTRNFunctionDesc : FunctionPIEDesc ;
  gMT3D_MXSTRNPieDesc      : ANEPIEDesc ;

  gMT3D_TRPTFunctionDesc : FunctionPIEDesc ;
  gMT3D_TRPTPieDesc      : ANEPIEDesc ;

  gMT3D_TRPVFunctionDesc : FunctionPIEDesc ;
  gMT3D_TRPVPieDesc      : ANEPIEDesc ;

  gMT3D_DMCOEFFunctionDesc : FunctionPIEDesc ;
  gMT3D_DMCOEFPieDesc      : ANEPIEDesc ;

  gMT3D_RHOBFunctionDesc : FunctionPIEDesc ;
  gMT3D_RHOBPieDesc      : ANEPIEDesc ;

  gMT3D_SP1FunctionDesc : FunctionPIEDesc ;
  gMT3D_SP1PieDesc      : ANEPIEDesc ;

  gMT3D_SP2FunctionDesc : FunctionPIEDesc ;
  gMT3D_SP2PieDesc      : ANEPIEDesc ;

  gMT3D_RC1FunctionDesc : FunctionPIEDesc ;
  gMT3D_RC1PieDesc      : ANEPIEDesc ;

  gMT3D_RC2FunctionDesc : FunctionPIEDesc ;
  gMT3D_RC2PieDesc      : ANEPIEDesc ;

  gMT3D_TIMPRSFunctionDesc : FunctionPIEDesc ;
  gMT3D_TIMPRSPieDesc      : ANEPIEDesc ;

  gMT3DPostImportPIEDesc : ImportPIEDesc;
  gMT3DPostPIEDesc       : ANEPIEDesc ;

  gMF_MfLayerFunctionDesc : FunctionPIEDesc ;
  gMF_MfLayerPieDesc      : ANEPIEDesc ;

  gMFRunExportMT3DPIEDesc : ExportTemplatePIEDesc;
  gMFRunMT3DPIEDesc       : ANEPIEDesc ;


Procedure AddMorePieDiscriptors(Const  Project, Vendor, Product : ANE_Str;
   var numNames : ANE_INT32) ;


implementation

uses PostMT3DPieUnit, GetANEFunctionsUnit, GetMODFLOWLayerFunction,
  ParamNamesAndTypes, MT3DTimeFunctions, MT3DLayerFunctions, RunMT3DUnit;

Procedure AddMorePieDiscriptors(Const  Project, Vendor, Product : ANE_Str;
   var numNames : ANE_INT32) ;
begin
        gMT3DPostImportPIEDesc.version := IMPORT_PIE_VERSION;
	gMT3DPostImportPIEDesc.name := 'MT3D Post Processing';
	gMT3DPostImportPIEDesc.importFlags := kImportAllwaysVisible or kImportNeedsProject;
        gMT3DPostImportPIEDesc.toLayerTypes :=   kPIEAnyLayer;
        gMT3DPostImportPIEDesc.fromLayerTypes :=   kPIEAnyLayer;
	gMT3DPostImportPIEDesc.doImportProc := @GPostMT3DPIE;
	gMT3DPostImportPIEDesc.neededProject := Project;

        gMT3DPostPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMT3DPostPIEDesc.vendor :=  Vendor;                           // vendor
        gMT3DPostPIEDesc.product := Product;                          // product
	gMT3DPostPIEDesc.name  := 'MT3D Post Processing';
	gMT3DPostPIEDesc.PieType :=  kImportPIE;
	gMT3DPostPIEDesc.descriptor := @gMT3DPostImportPIEDesc;

	Assert (numNames < kMaxPIEDesc+KMT3DPIEDesc) ;
        gPIEDesc[numNames] := @gMT3DPostPIEDesc;
        Inc(numNames);	// add descriptor to list

        // get MODFLOW lAYER
        gMF_MfLayerFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMF_MfLayerFunctionDesc.functionFlags := UsualOptions; // Function options
        gMF_MfLayerFunctionDesc.name := 'MODFLOW_Layer';                       // Function name
        gMF_MfLayerFunctionDesc.address := GetMODFLOW_Layer;                 // Function address
        gMF_MfLayerFunctionDesc.returnType := kPIEInteger;              // return type
        gMF_MfLayerFunctionDesc.numParams := 4;                        // number of parameters;
        gMF_MfLayerFunctionDesc.numOptParams := 0;                      // number of optional parameters;
//        gMF_MfLayerFunctionDesc.paramNames := @gpnMFLayerNames;                     // paramter names
        gMF_MfLayerFunctionDesc.paramNames := @gpnModflowLayerNames;                     // paramter names
//        gMF_MfLayerFunctionDesc.paramTypes := @gOneInteger3RealTypes;                      // parameter types
        gMF_MfLayerFunctionDesc.paramTypes := @g1Integer3RealTypes;                      // parameter types
        gMF_MfLayerFunctionDesc.neededProject := Project;               // needed project

        gMF_MfLayerPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMF_MfLayerPieDesc.vendor :=  Vendor;                           // vendor
        gMF_MfLayerPieDesc.product := Product;                          // product
	gMF_MfLayerPieDesc.name  := 'MODFLOW_Layer';                            // function name
	gMF_MfLayerPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMF_MfLayerPieDesc.descriptor := @gMF_MfLayerFunctionDesc;         // function PIE descriptor address

        // get MT3D DTO
        gMT3D_DTOFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMT3D_DTOFunctionDesc.functionFlags := UsualOptions; // Function options
        gMT3D_DTOFunctionDesc.name := 'MT3D_DTO';                       // Function name
        gMT3D_DTOFunctionDesc.address := GetMT3D_DTO;                 // Function address
        gMT3D_DTOFunctionDesc.returnType := kPIEFloat;              // return type
        gMT3D_DTOFunctionDesc.numParams := 1;                        // number of parameters;
        gMT3D_DTOFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMT3D_DTOFunctionDesc.paramNames := @gpnPeriod;                     // paramter names
        gMT3D_DTOFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMT3D_DTOFunctionDesc.neededProject := Project;               // needed project

        gMT3D_DTOPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMT3D_DTOPieDesc.vendor :=  Vendor;                           // vendor
        gMT3D_DTOPieDesc.product := Product;                          // product
	gMT3D_DTOPieDesc.name  := 'MT3D_DTO';                            // function name
	gMT3D_DTOPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMT3D_DTOPieDesc.descriptor := @gMT3D_DTOFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc+KMT3DPIEDesc);
	gPIEDesc[numNames] := @gMT3D_DTOPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MT3D MXSTRN
        gMT3D_MXSTRNFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMT3D_MXSTRNFunctionDesc.functionFlags := UsualOptions; // Function options
        gMT3D_MXSTRNFunctionDesc.name := 'MT3D_MXSTRN';                       // Function name
        gMT3D_MXSTRNFunctionDesc.address := GetMT3D_MXSTRN;                 // Function address
        gMT3D_MXSTRNFunctionDesc.returnType := kPIEInteger;              // return type
        gMT3D_MXSTRNFunctionDesc.numParams := 1;                        // number of parameters;
        gMT3D_MXSTRNFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMT3D_MXSTRNFunctionDesc.paramNames := @gpnPeriod;                     // paramter names
        gMT3D_MXSTRNFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMT3D_MXSTRNFunctionDesc.neededProject := Project;               // needed project

        gMT3D_MXSTRNPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMT3D_MXSTRNPieDesc.vendor :=  Vendor;                           // vendor
        gMT3D_MXSTRNPieDesc.product := Product;                          // product
	gMT3D_MXSTRNPieDesc.name  := 'MT3D_MXSTRN';                            // function name
	gMT3D_MXSTRNPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMT3D_MXSTRNPieDesc.descriptor := @gMT3D_MXSTRNFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc+KMT3DPIEDesc);
	gPIEDesc[numNames] := @gMT3D_MXSTRNPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MT3D TRPT
        gMT3D_TRPTFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMT3D_TRPTFunctionDesc.functionFlags := UsualOptions; // Function options
        gMT3D_TRPTFunctionDesc.name := 'MT3D_TRPT';                       // Function name
        gMT3D_TRPTFunctionDesc.address := GetMT3D_TRPT;                 // Function address
        gMT3D_TRPTFunctionDesc.returnType := kPIEFloat;              // return type
        gMT3D_TRPTFunctionDesc.numParams := 1;                        // number of parameters;
        gMT3D_TRPTFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMT3D_TRPTFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMT3D_TRPTFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMT3D_TRPTFunctionDesc.neededProject := Project;               // needed project

        gMT3D_TRPTPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMT3D_TRPTPieDesc.vendor :=  Vendor;                           // vendor
        gMT3D_TRPTPieDesc.product := Product;                          // product
	gMT3D_TRPTPieDesc.name  := 'MT3D_TRPT';                            // function name
	gMT3D_TRPTPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMT3D_TRPTPieDesc.descriptor := @gMT3D_TRPTFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc+KMT3DPIEDesc);
	gPIEDesc[numNames] := @gMT3D_TRPTPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MT3D TRPV
        gMT3D_TRPVFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMT3D_TRPVFunctionDesc.functionFlags := UsualOptions; // Function options
        gMT3D_TRPVFunctionDesc.name := 'MT3D_TRPV';                       // Function name
        gMT3D_TRPVFunctionDesc.address := GetMT3D_TRPV;                 // Function address
        gMT3D_TRPVFunctionDesc.returnType := kPIEFloat;              // return type
        gMT3D_TRPVFunctionDesc.numParams := 1;                        // number of parameters;
        gMT3D_TRPVFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMT3D_TRPVFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMT3D_TRPVFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMT3D_TRPVFunctionDesc.neededProject := Project;               // needed project

        gMT3D_TRPVPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMT3D_TRPVPieDesc.vendor :=  Vendor;                           // vendor
        gMT3D_TRPVPieDesc.product := Product;                          // product
	gMT3D_TRPVPieDesc.name  := 'MT3D_TRPV';                            // function name
	gMT3D_TRPVPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMT3D_TRPVPieDesc.descriptor := @gMT3D_TRPVFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc+KMT3DPIEDesc);
	gPIEDesc[numNames] := @gMT3D_TRPVPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MT3D DMCOEF
        gMT3D_DMCOEFFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMT3D_DMCOEFFunctionDesc.functionFlags := UsualOptions; // Function options
        gMT3D_DMCOEFFunctionDesc.name := 'MT3D_DMCOEF';                       // Function name
        gMT3D_DMCOEFFunctionDesc.address := GetMT3D_DMCOEF;                 // Function address
        gMT3D_DMCOEFFunctionDesc.returnType := kPIEFloat;              // return type
        gMT3D_DMCOEFFunctionDesc.numParams := 1;                        // number of parameters;
        gMT3D_DMCOEFFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMT3D_DMCOEFFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMT3D_DMCOEFFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMT3D_DMCOEFFunctionDesc.neededProject := Project;               // needed project

        gMT3D_DMCOEFPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMT3D_DMCOEFPieDesc.vendor :=  Vendor;                           // vendor
        gMT3D_DMCOEFPieDesc.product := Product;                          // product
	gMT3D_DMCOEFPieDesc.name  := 'MT3D_DMCOEF';                            // function name
	gMT3D_DMCOEFPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMT3D_DMCOEFPieDesc.descriptor := @gMT3D_DMCOEFFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc+KMT3DPIEDesc);
	gPIEDesc[numNames] := @gMT3D_DMCOEFPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MT3D RHOB
        gMT3D_RHOBFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMT3D_RHOBFunctionDesc.functionFlags := UsualOptions; // Function options
        gMT3D_RHOBFunctionDesc.name := 'MT3D_RHOB';                       // Function name
        gMT3D_RHOBFunctionDesc.address := GetMT3D_RHOB;                 // Function address
        gMT3D_RHOBFunctionDesc.returnType := kPIEFloat;              // return type
        gMT3D_RHOBFunctionDesc.numParams := 1;                        // number of parameters;
        gMT3D_RHOBFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMT3D_RHOBFunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMT3D_RHOBFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMT3D_RHOBFunctionDesc.neededProject := Project;               // needed project

        gMT3D_RHOBPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMT3D_RHOBPieDesc.vendor :=  Vendor;                           // vendor
        gMT3D_RHOBPieDesc.product := Product;                          // product
	gMT3D_RHOBPieDesc.name  := 'MT3D_RHOB';                            // function name
	gMT3D_RHOBPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMT3D_RHOBPieDesc.descriptor := @gMT3D_RHOBFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc+KMT3DPIEDesc);
	gPIEDesc[numNames] := @gMT3D_RHOBPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MT3D SP1
        gMT3D_SP1FunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMT3D_SP1FunctionDesc.functionFlags := UsualOptions; // Function options
        gMT3D_SP1FunctionDesc.name := 'MT3D_SP1';                       // Function name
        gMT3D_SP1FunctionDesc.address := GetMT3D_SP1;                 // Function address
        gMT3D_SP1FunctionDesc.returnType := kPIEFloat;              // return type
        gMT3D_SP1FunctionDesc.numParams := 1;                        // number of parameters;
        gMT3D_SP1FunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMT3D_SP1FunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMT3D_SP1FunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMT3D_SP1FunctionDesc.neededProject := Project;               // needed project

        gMT3D_SP1PieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMT3D_SP1PieDesc.vendor :=  Vendor;                           // vendor
        gMT3D_SP1PieDesc.product := Product;                          // product
	gMT3D_SP1PieDesc.name  := 'MT3D_SP1';                            // function name
	gMT3D_SP1PieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMT3D_SP1PieDesc.descriptor := @gMT3D_SP1FunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc+KMT3DPIEDesc);
	gPIEDesc[numNames] := @gMT3D_SP1PieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MT3D SP2
        gMT3D_SP2FunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMT3D_SP2FunctionDesc.functionFlags := UsualOptions; // Function options
        gMT3D_SP2FunctionDesc.name := 'MT3D_SP2';                       // Function name
        gMT3D_SP2FunctionDesc.address := GetMT3D_SP2;                 // Function address
        gMT3D_SP2FunctionDesc.returnType := kPIEFloat;              // return type
        gMT3D_SP2FunctionDesc.numParams := 1;                        // number of parameters;
        gMT3D_SP2FunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMT3D_SP2FunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMT3D_SP2FunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMT3D_SP2FunctionDesc.neededProject := Project;               // needed project

        gMT3D_SP2PieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMT3D_SP2PieDesc.vendor :=  Vendor;                           // vendor
        gMT3D_SP2PieDesc.product := Product;                          // product
	gMT3D_SP2PieDesc.name  := 'MT3D_SP2';                            // function name
	gMT3D_SP2PieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMT3D_SP2PieDesc.descriptor := @gMT3D_SP2FunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc+KMT3DPIEDesc);
	gPIEDesc[numNames] := @gMT3D_SP2PieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MT3D RC1
        gMT3D_RC1FunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMT3D_RC1FunctionDesc.functionFlags := UsualOptions; // Function options
        gMT3D_RC1FunctionDesc.name := 'MT3D_RC1';                       // Function name
        gMT3D_RC1FunctionDesc.address := GetMT3D_RC1;                 // Function address
        gMT3D_RC1FunctionDesc.returnType := kPIEFloat;              // return type
        gMT3D_RC1FunctionDesc.numParams := 1;                        // number of parameters;
        gMT3D_RC1FunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMT3D_RC1FunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMT3D_RC1FunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMT3D_RC1FunctionDesc.neededProject := Project;               // needed project

        gMT3D_RC1PieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMT3D_RC1PieDesc.vendor :=  Vendor;                           // vendor
        gMT3D_RC1PieDesc.product := Product;                          // product
	gMT3D_RC1PieDesc.name  := 'MT3D_RC1';                            // function name
	gMT3D_RC1PieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMT3D_RC1PieDesc.descriptor := @gMT3D_RC1FunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc+KMT3DPIEDesc);
	gPIEDesc[numNames] := @gMT3D_RC1PieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MT3D RC2
        gMT3D_RC2FunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMT3D_RC2FunctionDesc.functionFlags := UsualOptions; // Function options
        gMT3D_RC2FunctionDesc.name := 'MT3D_RC2';                       // Function name
        gMT3D_RC2FunctionDesc.address := GetMT3D_RC2;                 // Function address
        gMT3D_RC2FunctionDesc.returnType := kPIEFloat;              // return type
        gMT3D_RC2FunctionDesc.numParams := 1;                        // number of parameters;
        gMT3D_RC2FunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMT3D_RC2FunctionDesc.paramNames := @gpnUnit;                     // paramter names
        gMT3D_RC2FunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMT3D_RC2FunctionDesc.neededProject := Project;               // needed project

        gMT3D_RC2PieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMT3D_RC2PieDesc.vendor :=  Vendor;                           // vendor
        gMT3D_RC2PieDesc.product := Product;                          // product
	gMT3D_RC2PieDesc.name  := 'MT3D_RC2';                            // function name
	gMT3D_RC2PieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMT3D_RC2PieDesc.descriptor := @gMT3D_RC2FunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc+KMT3DPIEDesc);
	gPIEDesc[numNames] := @gMT3D_RC2PieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // get MT3D TIMPRS
        gMT3D_TIMPRSFunctionDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        gMT3D_TIMPRSFunctionDesc.functionFlags := UsualOptions; // Function options
        gMT3D_TIMPRSFunctionDesc.name := 'MT3D_TIMPRS';                       // Function name
        gMT3D_TIMPRSFunctionDesc.address := GetMT3D_TIMPRS;                 // Function address
        gMT3D_TIMPRSFunctionDesc.returnType := kPIEInteger;              // return type
        gMT3D_TIMPRSFunctionDesc.numParams := 1;                        // number of parameters;
        gMT3D_TIMPRSFunctionDesc.numOptParams := 0;                      // number of optional parameters;
        gMT3D_TIMPRSFunctionDesc.paramNames := @gpnPeriod;                     // paramter names
        gMT3D_TIMPRSFunctionDesc.paramTypes := @gOneIntegerTypes;                      // parameter types
        gMT3D_TIMPRSFunctionDesc.neededProject := Project;               // needed project

        gMT3D_TIMPRSPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMT3D_TIMPRSPieDesc.vendor :=  Vendor;                           // vendor
        gMT3D_TIMPRSPieDesc.product := Product;                          // product
	gMT3D_TIMPRSPieDesc.name  := 'MT3D_TIMPRS';                            // function name
	gMT3D_TIMPRSPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gMT3D_TIMPRSPieDesc.descriptor := @gMT3D_TIMPRSFunctionDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc+KMT3DPIEDesc);
	gPIEDesc[numNames] := @gMT3D_TIMPRSPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // Run Model
	gMFRunExportMT3DPIEDesc.name := 'Run M&T3D';
	gMFRunExportMT3DPIEDesc.exportType := kPIEGridLayer;
	gMFRunExportMT3DPIEDesc.exportFlags := kExportNeedsProject or kExportDontShowParamDialog;
	gMFRunExportMT3DPIEDesc.getTemplateProc := RunMT3DPIE;
        gMFRunExportMT3DPIEDesc.preExportProc := nil;
        gMFRunExportMT3DPIEDesc.postExportProc := nil;
	gMFRunExportMT3DPIEDesc.neededProject := Project;

        gMFRunMT3DPIEDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gMFRunMT3DPIEDesc.vendor :=  Vendor;                           // vendor
        gMFRunMT3DPIEDesc.product := Product;                          // product
	gMFRunMT3DPIEDesc.name  := 'Run M&T3D';
	gMFRunMT3DPIEDesc.PieType :=  kExportTemplatePIE;
	gMFRunMT3DPIEDesc.descriptor := @gMFRunExportMT3DPIEDesc;

	Assert (numNames < kMaxPIEDesc+KMT3DPIEDesc) ;
        gPIEDesc[numNames] := @gMFRunMT3DPIEDesc;
        Inc(numNames);	// add descriptor to list



end;

end.
