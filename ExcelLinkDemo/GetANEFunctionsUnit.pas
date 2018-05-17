unit GetANEFunctionsUnit;

interface

uses
  ProjectPIE, AnePIE, Forms, sysutils, Controls, classes, FunctionPIE, Dialogs;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

const
  kMaxPIEDesc = 37;
  Project : ANE_Str = 'Excel Link';
  Vendor :  ANE_Str = 'Richard Winston';
  Product : ANE_Str = 'New MODFLOW PIE' ;

var
gPIEDesc : Array [0..kMaxPIEDesc-1] of ^ANEPIEDesc;

  gExcelLinkProjectPDesc : ProjectPIEDesc ;
  gExcelLinkPieDesc      : ANEPIEDesc ;

  GSpreadSheetNameFunctionPDesc : FunctionPIEDesc;
  gSpreadSheetNamePieDesc      : ANEPIEDesc ;

  GGridSheetNameFunctionPDesc : FunctionPIEDesc;
  gGridSheetNamePieDesc      : ANEPIEDesc ;

  GContourSheetNameFunctionPDesc : FunctionPIEDesc;
  gContourSheetNamePieDesc      : ANEPIEDesc ;

  GContourNameColumnFunctionPDesc : FunctionPIEDesc;
  gContourNameColumnPieDesc      : ANEPIEDesc ;

  GSpreadSheetCellFunctionPDesc : FunctionPIEDesc;
  gSpreadSheetCellPieDesc      : ANEPIEDesc ;

  GSpreadSheetContourFunctionPDesc : FunctionPIEDesc;
  gSpreadSheetContourPieDesc      : ANEPIEDesc ;

implementation

uses  ProjectFunctions, StringPIEFunctions, ExcelLink, ParamNamesAndTypes ;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
var
  UsualOptions : EFunctionPIEFlags;
begin
        numNames := 0;

        {$ASSERTIONS ON}
        UsualOptions := kFunctionNeedsProject;
        //MODFLOW Project
	gExcelLinkProjectPDesc.version := PROJECT_PIE_VERSION;
	gExcelLinkProjectPDesc.name := Project;
	gExcelLinkProjectPDesc.projectFlags := kProjectCanEdit or
                                            kProjectShouldClean or
                                            kProjectShouldSave;
	gExcelLinkProjectPDesc.createNewProc := GProjectNew;
	gExcelLinkProjectPDesc.editProjectProc := GEditForm;
	gExcelLinkProjectPDesc.cleanProjectProc := GClearForm;
	gExcelLinkProjectPDesc.saveProc := GSaveForm;
	gExcelLinkProjectPDesc.loadProc := GLoadForm;

	gExcelLinkPieDesc.name  := '&New Excel Link Demo Project';
	gExcelLinkPieDesc.PieType :=  kProjectPIE;
	gExcelLinkPieDesc.descriptor := @gExcelLinkProjectPDesc;

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gExcelLinkPieDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        GSpreadSheetNameFunctionPDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        GSpreadSheetNameFunctionPDesc.functionFlags := UsualOptions ;// Function options
        GSpreadSheetNameFunctionPDesc.name := 'Spread_Sheet_Name';                       // Function name
        GSpreadSheetNameFunctionPDesc.address := GetSpreadSheetName;                 // Function address
        GSpreadSheetNameFunctionPDesc.returnType := kPIEString;              // return type
        GSpreadSheetNameFunctionPDesc.numParams := 0;                        // number of parameters;
        GSpreadSheetNameFunctionPDesc.numOptParams := 0;                      // number of optional parameters;
        GSpreadSheetNameFunctionPDesc.paramNames := Nil;                     // paramter names
        GSpreadSheetNameFunctionPDesc.paramTypes := nil;                      // parameter types
        GSpreadSheetNameFunctionPDesc.neededProject := Project;               // needed project

        gSpreadSheetNamePieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gSpreadSheetNamePieDesc.vendor :=  Vendor;                           // vendor
        gSpreadSheetNamePieDesc.product := Product;                          // product
	gSpreadSheetNamePieDesc.name  := 'Spread_Sheet_Name';                            // function name
	gSpreadSheetNamePieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gSpreadSheetNamePieDesc.descriptor := @GSpreadSheetNameFunctionPDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gSpreadSheetNamePieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names


        GGridSheetNameFunctionPDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        GGridSheetNameFunctionPDesc.functionFlags := UsualOptions ;// Function options
        GGridSheetNameFunctionPDesc.name := 'Grid_Sheet_Name';                       // Function name
        GGridSheetNameFunctionPDesc.address := GetGridSheetName;                 // Function address
        GGridSheetNameFunctionPDesc.returnType := kPIEString;              // return type
        GGridSheetNameFunctionPDesc.numParams := 0;                        // number of parameters;
        GGridSheetNameFunctionPDesc.numOptParams := 0;                      // number of optional parameters;
        GGridSheetNameFunctionPDesc.paramNames := Nil;                     // paramter names
        GGridSheetNameFunctionPDesc.paramTypes := nil;                      // parameter types
        GGridSheetNameFunctionPDesc.neededProject := Project;               // needed project

        gGridSheetNamePieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gGridSheetNamePieDesc.vendor :=  Vendor;                           // vendor
        gGridSheetNamePieDesc.product := Product;                          // product
	gGridSheetNamePieDesc.name  := 'Grid_Sheet_Name';                            // function name
	gGridSheetNamePieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gGridSheetNamePieDesc.descriptor := @GGridSheetNameFunctionPDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gGridSheetNamePieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        GContourSheetNameFunctionPDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        GContourSheetNameFunctionPDesc.functionFlags := UsualOptions ;// Function options
        GContourSheetNameFunctionPDesc.name := 'Contour_Sheet_Name';                       // Function name
        GContourSheetNameFunctionPDesc.address := GetContourSheetName;                 // Function address
        GContourSheetNameFunctionPDesc.returnType := kPIEString;              // return type
        GContourSheetNameFunctionPDesc.numParams := 0;                        // number of parameters;
        GContourSheetNameFunctionPDesc.numOptParams := 0;                      // number of optional parameters;
        GContourSheetNameFunctionPDesc.paramNames := Nil;                     // paramter names
        GContourSheetNameFunctionPDesc.paramTypes := nil;                      // parameter types
        GContourSheetNameFunctionPDesc.neededProject := Project;               // needed project

        gContourSheetNamePieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gContourSheetNamePieDesc.vendor :=  Vendor;                           // vendor
        gContourSheetNamePieDesc.product := Product;                          // product
	gContourSheetNamePieDesc.name  := 'Contour_Sheet_Name';                            // function name
	gContourSheetNamePieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gContourSheetNamePieDesc.descriptor := @GContourSheetNameFunctionPDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gContourSheetNamePieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        GContourNameColumnFunctionPDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        GContourNameColumnFunctionPDesc.functionFlags := UsualOptions ;// Function options
        GContourNameColumnFunctionPDesc.name := 'Contour_Name_Column';                       // Function name
        GContourNameColumnFunctionPDesc.address := GetContourNameColumnName;                 // Function address
        GContourNameColumnFunctionPDesc.returnType := kPIEInteger;              // return type
        GContourNameColumnFunctionPDesc.numParams := 0;                        // number of parameters;
        GContourNameColumnFunctionPDesc.numOptParams := 0;                      // number of optional parameters;
        GContourNameColumnFunctionPDesc.paramNames := Nil;                     // paramter names
        GContourNameColumnFunctionPDesc.paramTypes := nil;                      // parameter types
        GContourNameColumnFunctionPDesc.neededProject := Project;               // needed project

        gContourNameColumnPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gContourNameColumnPieDesc.vendor :=  Vendor;                           // vendor
        gContourNameColumnPieDesc.product := Product;                          // product
	gContourNameColumnPieDesc.name  := 'Contour_Name_Column';                            // function name
	gContourNameColumnPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gContourNameColumnPieDesc.descriptor := @GContourNameColumnFunctionPDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gContourNameColumnPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        GSpreadSheetCellFunctionPDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        GSpreadSheetCellFunctionPDesc.functionFlags := UsualOptions ;// Function options
        GSpreadSheetCellFunctionPDesc.name := 'Spreadsheet_Cell_Value';                       // Function name
        GSpreadSheetCellFunctionPDesc.address := GPIEGridValueMMFun;                 // Function address
        GSpreadSheetCellFunctionPDesc.returnType := kPIEFloat;              // return type
        GSpreadSheetCellFunctionPDesc.numParams := 4;                        // number of parameters;
        GSpreadSheetCellFunctionPDesc.numOptParams := 0;                      // number of optional parameters;
        GSpreadSheetCellFunctionPDesc.paramNames := @gpnSpreadSheetGrid;                     // paramter names
        GSpreadSheetCellFunctionPDesc.paramTypes := @g2String2IntType;                      // parameter types
        GSpreadSheetCellFunctionPDesc.neededProject := Project;               // needed project

        gSpreadSheetCellPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gSpreadSheetCellPieDesc.vendor :=  Vendor;                           // vendor
        gSpreadSheetCellPieDesc.product := Product;                          // product
	gSpreadSheetCellPieDesc.name  := 'Spreadsheet_Cell_Value';                            // function name
	gSpreadSheetCellPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gSpreadSheetCellPieDesc.descriptor := @GSpreadSheetCellFunctionPDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gSpreadSheetCellPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        GSpreadSheetContourFunctionPDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
        GSpreadSheetContourFunctionPDesc.functionFlags := UsualOptions ;// Function options
        GSpreadSheetContourFunctionPDesc.name := 'Spreadsheet_Contour_Value';                       // Function name
        GSpreadSheetContourFunctionPDesc.address := GPIEContourValueMMFun;                 // Function address
        GSpreadSheetContourFunctionPDesc.returnType := kPIEFloat;              // return type
        GSpreadSheetContourFunctionPDesc.numParams := 5;                        // number of parameters;
        GSpreadSheetContourFunctionPDesc.numOptParams := 0;                      // number of optional parameters;
        GSpreadSheetContourFunctionPDesc.paramNames := @gpnSpreadSheetContour;                     // paramter names
        GSpreadSheetContourFunctionPDesc.paramTypes := @g3String2IntType;                      // parameter types
        GSpreadSheetContourFunctionPDesc.neededProject := Project;               // needed project

        gSpreadSheetContourPieDesc.version := ANE_PIE_VERSION;             // Function Pie version
        gSpreadSheetContourPieDesc.vendor :=  Vendor;                           // vendor
        gSpreadSheetContourPieDesc.product := Product;                          // product
	gSpreadSheetContourPieDesc.name  := 'Spreadsheet_Contour_Value';                            // function name
	gSpreadSheetContourPieDesc.PieType :=  kFunctionPIE;                    // Pie type
	gSpreadSheetContourPieDesc.descriptor := @GSpreadSheetContourFunctionPDesc;         // function PIE descriptor address

	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gSpreadSheetContourPieDesc;                      // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        descriptors := @gPIEDesc;

end;

end.
