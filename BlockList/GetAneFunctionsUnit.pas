unit GetAneFunctionsUnit;

interface

uses FunctionPie, ANEPIE;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;



implementation

uses BlockListUnit, FreeBlockUnit, FreeVertexUnit, CombinedListUnit,
     GetCellVertexUnit, GetCellUnit, InitializeBlockUnit, InitializeVertexUnit,
     BL_SegmentUnit, CrossRowUnit, CrossColumnUnit, GridUnit,
     PointInsideContourUnit, GetFractionUnit, ExceptionCounUnit,
     CheckPIEVersionFunction, UtilityFunctions;

const
  kMaxFunDesc = 56;

var
        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

        gPIEInitializeBlockDesc  :  ANEPIEDesc;
        gPIEInitializeBlockFDesc :  FunctionPIEDesc;

        gPIEInitializeVertexDesc  :  ANEPIEDesc;
        gPIEInitializeVertexFDesc :  FunctionPIEDesc;

        gPIEAddVertexDesc  :  ANEPIEDesc;
        gPIEAddVertexFDesc :  FunctionPIEDesc;

        gPIEGetCellListsCountDesc  :  ANEPIEDesc;
        gPIEGetCellListsCountFDesc :  FunctionPIEDesc;

        gPIEGetACellListCountDesc  :  ANEPIEDesc;
        gPIEGetACellListCountFDesc :  FunctionPIEDesc;

        gPIEGetACellRowDesc  :  ANEPIEDesc;
        gPIEGetACellRowFDesc :  FunctionPIEDesc;

        gPIEGetACellColumnDesc  :  ANEPIEDesc;
        gPIEGetACellColumnFDesc :  FunctionPIEDesc;

        gPIEGetACellVertexCountDesc  :  ANEPIEDesc;
        gPIEGetACellVertexCountFDesc :  FunctionPIEDesc;

        gPIEGetACellVertexXPosDesc  :  ANEPIEDesc;
        gPIEGetACellVertexXPosFDesc :  FunctionPIEDesc;

        gPIEGetACellVertexYPosDesc  :  ANEPIEDesc;
        gPIEGetACellVertexYPosFDesc :  FunctionPIEDesc;

        gPIEGetCombinedListCountDesc  :  ANEPIEDesc;
        gPIEGetCombinedListCountFDesc :  FunctionPIEDesc;

        gPIEGetACombinedCellRowDesc  :  ANEPIEDesc;
        gPIEGetACombinedCellRowFDesc :  FunctionPIEDesc;

        gPIEGetACellCombinedColumnDesc  :  ANEPIEDesc;
        gPIEGetACellCombinedColumnFDesc :  FunctionPIEDesc;

        gPIEFreeListVertexDesc  :  ANEPIEDesc;
        gPIEFreeListVertexFDesc :  FunctionPIEDesc;

        gPIEFreeListBlockDesc  :  ANEPIEDesc;
        gPIEFreeListBlockFDesc :  FunctionPIEDesc;

        gPIEGetSegmentCountDesc  :  ANEPIEDesc;
        gPIEGetSegmentCountFDesc :  FunctionPIEDesc;

        gPIEGetSegmentFirstXDesc  :  ANEPIEDesc;
        gPIEGetSegmentFirstXFDesc :  FunctionPIEDesc;

        gPIEGetSegmentFirstYDesc  :  ANEPIEDesc;
        gPIEGetSegmentFirstYFDesc :  FunctionPIEDesc;

        gPIEGetSegmentSecondXDesc  :  ANEPIEDesc;
        gPIEGetSegmentSecondXFDesc :  FunctionPIEDesc;

        gPIEGetSegmentSecondYDesc  :  ANEPIEDesc;
        gPIEGetSegmentSecondYFDesc :  FunctionPIEDesc;

        gPIEGetSegmentLengthXDesc  :  ANEPIEDesc;
        gPIEGetSegmentLengthXFDesc :  FunctionPIEDesc;

        gPIEGetSegmentLengthYDesc  :  ANEPIEDesc;
        gPIEGetSegmentLengthYFDesc :  FunctionPIEDesc;

        gPIEGetSegmentLengthDesc  :  ANEPIEDesc;
        gPIEGetSegmentLengthFDesc :  FunctionPIEDesc;

        gPIEGetSumSegmentLengthXDesc  :  ANEPIEDesc;
        gPIEGetSumSegmentLengthXFDesc :  FunctionPIEDesc;

        gPIEGetSumSegmentLengthYDesc  :  ANEPIEDesc;
        gPIEGetSumSegmentLengthYFDesc :  FunctionPIEDesc;

        gPIEGetSumSegmentLengthDesc  :  ANEPIEDesc;
        gPIEGetSumSegmentLengthFDesc :  FunctionPIEDesc;

        gPIEGetRowCrossingListsCountDesc  :  ANEPIEDesc;
        gPIEGetRowCrossingListsCountFDesc :  FunctionPIEDesc;

        gPIEGetARowCrossingListCountDesc  :  ANEPIEDesc;
        gPIEGetARowCrossingListCountFDesc :  FunctionPIEDesc;

        gPIEGetARowCrossingRowDesc  :  ANEPIEDesc;
        gPIEGetARowCrossingRowFDesc :  FunctionPIEDesc;

        gPIEGetARowCrossingColumnDesc  :  ANEPIEDesc;
        gPIEGetARowCrossingColumnFDesc :  FunctionPIEDesc;

        gPIEGetARowCrossingCompositeYDesc  :  ANEPIEDesc;
        gPIEGetARowCrossingCompositeYFDesc :  FunctionPIEDesc;

        gPIEGetSumRowCrossingCompositeYDesc  :  ANEPIEDesc;
        gPIEGetSumRowCrossingCompositeYFDesc :  FunctionPIEDesc;

        gPIEGetColumnCrossingListsCountDesc  :  ANEPIEDesc;
        gPIEGetColumnCrossingListsCountFDesc :  FunctionPIEDesc;

        gPIEGetAColumnCrossingListCountDesc  :  ANEPIEDesc;
        gPIEGetAColumnCrossingListCountFDesc :  FunctionPIEDesc;

        gPIEGetAColumnCrossingRowDesc  :  ANEPIEDesc;
        gPIEGetAColumnCrossingRowFDesc :  FunctionPIEDesc;

        gPIEGetAColumnCrossingColumnDesc  :  ANEPIEDesc;
        gPIEGetAColumnCrossingColumnFDesc :  FunctionPIEDesc;

        gPIEGetAColumnCrossingCompositeXDesc  :  ANEPIEDesc;
        gPIEGetAColumnCrossingCompositeXFDesc :  FunctionPIEDesc;

        gPIEGetSumColumnCrossingCompositeXDesc  :  ANEPIEDesc;
        gPIEGetSumColumnCrossingCompositeXFDesc :  FunctionPIEDesc;

        gPIEGetRowBoundaryDesc  :  ANEPIEDesc;
        gPIEGetRowBoundaryFDesc :  FunctionPIEDesc;

        gPIEGetColumnBoundaryDesc  :  ANEPIEDesc;
        gPIEGetColumnBoundaryFDesc :  FunctionPIEDesc;

        gPIEPointInsideContourDesc  :  ANEPIEDesc;
        gPIEPointInsideContourFDesc :  FunctionPIEDesc;

        gPIEContourTypeDesc  :  ANEPIEDesc;
        gPIEContourTypeFDesc :  FunctionPIEDesc;

        gPIEGetRowNodeDesc  :  ANEPIEDesc;
        gPIEGetRowNodeFDesc :  FunctionPIEDesc;

        gPIEGetColumnNodeDesc  :  ANEPIEDesc;
        gPIEGetColumnNodeFDesc :  FunctionPIEDesc;

        gPIEGetRowBoundaryCountDesc  :  ANEPIEDesc;
        gPIEGetRowBoundaryCountFDesc :  FunctionPIEDesc;

        gPIEGetColumnBoundaryCountDesc  :  ANEPIEDesc;
        gPIEGetColumnBoundaryCountFDesc :  FunctionPIEDesc;

        gPIEGetRowNodeCountDesc  :  ANEPIEDesc;
        gPIEGetRowNodeCountFDesc :  FunctionPIEDesc;

        gPIEGetColumnNodeCountDesc  :  ANEPIEDesc;
        gPIEGetColumnNodeCountFDesc :  FunctionPIEDesc;

        gPIEGetCellAreaDesc  :  ANEPIEDesc;
        gPIEGetCellAreaFDesc :  FunctionPIEDesc;

        gPIEGetLineFractionDesc  :  ANEPIEDesc;
        gPIEGetLineFractionFDesc :  FunctionPIEDesc;

        gPIEGetErrorCountDesc  :  ANEPIEDesc;
        gPIEGetErrorCountFDesc :  FunctionPIEDesc;

        gPIEGetAColumnCrossingNeighRowDesc  :  ANEPIEDesc;
        gPIEGetAColumnCrossingNeighRowFDesc :  FunctionPIEDesc;

        gPIEGetARowCrossingNeighColumnDesc  :  ANEPIEDesc;
        gPIEGetARowCrossingNeighColumnFDesc :  FunctionPIEDesc;

        gPIEGetRowCrossingCompositeLengthDesc  :  ANEPIEDesc;
        gPIEGetRowCrossingCompositeLengthFDesc :  FunctionPIEDesc;

        gPIEGetColumnCrossingCompositeLengthDesc  :  ANEPIEDesc;
        gPIEGetColumnCrossingCompositeLengthFDesc :  FunctionPIEDesc;

const   gpnNumber : array [0..1] of PChar = ('Number', nil);
const   gpnRow : array [0..1] of PChar = ('Row', nil);
const   gpnColumn : array [0..1] of PChar = ('Column', nil);
const   gpnListIndex : array [0..1] of PChar = ('ListIndex', nil);
const   gOneFloatTypes : array [0..1] of EPIENumberType = (kPIEFloat, 0);
const   gOneIntegerTypes : array [0..1] of EPIENumberType = (kPIEInteger, 0);

const   gpnIndexValue : array [0..2] of PChar = ('ListIndex','Value', nil);
const   gIntegerDouble : array [0..2] of EPIENumberType = (kPIEInteger, kPIEFloat, 0);

const   gpn2Index : array [0..2] of PChar = ('ListIndex','CellIndex', nil);
const   gpnColumnRow : array [0..2] of PChar = ('Column','Row', nil);
const   g2Integer : array [0..2] of EPIENumberType = (kPIEInteger, kPIEInteger, 0);

const   gpn3Index : array [0..3] of PChar = ('ListIndex','CellIndex','VertexIndex', nil);
const   gpn3IndexSeg : array [0..3] of PChar = ('ListIndex','CellIndex','SegmentIndex', nil);
const   g3Integer : array [0..3] of EPIENumberType = (kPIEInteger, kPIEInteger, kPIEInteger, 0);

const   gpn3IndexXY : array [0..3] of PChar = ('ListIndex','X','Y', nil);
const   g1Integer2Float : array [0..3] of EPIENumberType = (kPIEInteger, kPIEFloat, kPIEFloat, 0);
const   g1Integer2Float1Bool : array [0..4] of EPIENumberType = (kPIEInteger, kPIEFloat, kPIEFloat, kPIEBoolean, 0);

const   gpnGrid : array [0..1] of PChar = ('Grid_Layer_Name_as_String', nil);
const   gpnInfo : array [0..1] of PChar = ('Information_Layer_Name_as_String', nil);
const   g1String : array [0..1] of EPIENumberType = (kPIEString, 0);

const   gpnGridType : array [0..2] of PChar = ('Grid_Layer_Name_as_String', 'GridType', nil);
const   g1StringInt : array [0..2] of EPIENumberType = (kPIEString, kPIEInteger, 0);

const   gpnGridInfo : array [0..2] of PChar = ('Grid_Layer_Name_as_String','Information_Layer_Name_as_String', nil);
const   g2String : array [0..2] of EPIENumberType = (kPIEString, kPIEString, 0);

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
const
//  ModelPrefix = '';
  ModelPrefix = 'MODFLOW_';
var Options : EFunctionPIEFlags;
begin
        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They may be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

        if ShowHiddenFunctions then
        begin
          Options := 0;
        end
        else
        begin
          Options := kFunctionIsHidden;
        end;


	numNames := 0;

        // Initialize all lists.
	gPIEInitializeBlockFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEInitializeBlockFDesc.name :=PChar(ModelPrefix + 'BL_InitializeGridInformation');	// name of function
	gPIEInitializeBlockFDesc.address := GInitializeBlockMMFun;	// function address
	gPIEInitializeBlockFDesc.returnType := kPIEInteger;		// return value type
	gPIEInitializeBlockFDesc.numParams :=  1;			// number of parameters
	gPIEInitializeBlockFDesc.numOptParams := 1;			// number of optional parameters
	gPIEInitializeBlockFDesc.paramNames := @gpnGridType;		// pointer to parameter names list
	gPIEInitializeBlockFDesc.paramTypes := @g1StringInt;	        // pointer to parameters types list
	gPIEInitializeBlockFDesc.functionFlags := Options;	                // options
        gPIEInitializeBlockFDesc.category := '';
        gPIEInitializeBlockFDesc.neededProject := '';

       	gPIEInitializeBlockDesc.name  :=PChar(ModelPrefix + 'BL_InitializeGridInformation');	// name of PIE
	gPIEInitializeBlockDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEInitializeBlockDesc.descriptor := @gPIEInitializeBlockFDesc;	// pointer to descriptor
        gPIEInitializeBlockDesc.version := ANE_PIE_VERSION;
        gPIEInitializeBlockDesc.vendor := '';
        gPIEInitializeBlockDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEInitializeBlockDesc;                  // add descriptor to list
        Inc(numNames);	                                                 // increment number of names


        // Initialize list of lists of verticies.
	gPIEInitializeVertexFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEInitializeVertexFDesc.name :=PChar(ModelPrefix + 'BL_ReInitializeVertexList');	// name of function
	gPIEInitializeVertexFDesc.address := GInitializeVertexMMFun;	// function address
	gPIEInitializeVertexFDesc.returnType := kPIEBoolean;		// return value type
	gPIEInitializeVertexFDesc.numParams :=  0;			// number of parameters
	gPIEInitializeVertexFDesc.numOptParams := 0;			// number of optional parameters
	gPIEInitializeVertexFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEInitializeVertexFDesc.paramTypes := nil;	        // pointer to parameters types list
	gPIEInitializeVertexFDesc.functionFlags := Options;	                // options
        gPIEInitializeVertexFDesc.category := '';
        gPIEInitializeVertexFDesc.neededProject := '';

       	gPIEInitializeVertexDesc.name  :=PChar(ModelPrefix + 'BL_ReInitializeVertexList');	// name of PIE
	gPIEInitializeVertexDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEInitializeVertexDesc.descriptor := @gPIEInitializeVertexFDesc;	// pointer to descriptor
        gPIEInitializeVertexDesc.version := ANE_PIE_VERSION;
        gPIEInitializeVertexDesc.vendor := '';
        gPIEInitializeVertexDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEInitializeVertexDesc;              // add descriptor to list
        Inc(numNames);	                                              // increment number of names


        // Add list of lists of verticies.
	gPIEAddVertexFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEAddVertexFDesc.name :=PChar(ModelPrefix + 'BL_AddVertexLayer');	        // name of function
	gPIEAddVertexFDesc.address := GAddVertexMMFun;	        // function address
	gPIEAddVertexFDesc.returnType := kPIEBoolean;		// return value type
	gPIEAddVertexFDesc.numParams :=  1;			// number of parameters
	gPIEAddVertexFDesc.numOptParams := 0;			// number of optional parameters
	gPIEAddVertexFDesc.paramNames := @gpnInfo;		// pointer to parameter names list
	gPIEAddVertexFDesc.paramTypes := @g1String;	        // pointer to parameters types list
	gPIEAddVertexFDesc.functionFlags := Options;	                // options
        gPIEAddVertexFDesc.category := '';
        gPIEAddVertexFDesc.neededProject := '';

       	gPIEAddVertexDesc.name  :=PChar(ModelPrefix + 'BL_AddVertexLayer');	        // name of PIE
	gPIEAddVertexDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEAddVertexDesc.descriptor := @gPIEAddVertexFDesc;	// pointer to descriptor
        gPIEAddVertexDesc.version := ANE_PIE_VERSION;
        gPIEAddVertexDesc.vendor := '';
        gPIEAddVertexDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAddVertexDesc;              // add descriptor to list
        Inc(numNames);	                                       // increment number of names

        // Get Count of cell lists
	gPIEGetCellListsCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetCellListsCountFDesc.name :=PChar(ModelPrefix + 'BL_GetCountOfCellLists');	        // name of function
	gPIEGetCellListsCountFDesc.address := GGetCountOfCellListsMMFun;	// function address
	gPIEGetCellListsCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetCellListsCountFDesc.numParams :=  0;			        // number of parameters
	gPIEGetCellListsCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetCellListsCountFDesc.paramNames := nil;		                // pointer to parameter names list
	gPIEGetCellListsCountFDesc.paramTypes := nil;	                        // pointer to parameters types list
	gPIEGetCellListsCountFDesc.functionFlags := Options;	                // options
        gPIEGetCellListsCountFDesc.category := '';
        gPIEGetCellListsCountFDesc.neededProject := '';

       	gPIEGetCellListsCountDesc.name  :=PChar(ModelPrefix + 'BL_GetCountOfCellLists');		        // name of PIE
	gPIEGetCellListsCountDesc.PieType :=  kFunctionPIE;		                // PIE type: PIE function
	gPIEGetCellListsCountDesc.descriptor := @gPIEGetCellListsCountFDesc;	// pointer to descriptor
        gPIEGetCellListsCountDesc.version := ANE_PIE_VERSION;
        gPIEGetCellListsCountDesc.vendor := '';
        gPIEGetCellListsCountDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetCellListsCountDesc;                             // add descriptor to list
        Inc(numNames);	                                                                // increment number of names

        // Get Count of a particular cell list
	gPIEGetACellListCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetACellListCountFDesc.name :=PChar(ModelPrefix + 'BL_GetCountOfACellList');	        // name of function
	gPIEGetACellListCountFDesc.address := GGetCountOfACellListMMFun;	// function address
	gPIEGetACellListCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetACellListCountFDesc.numParams :=  1;			        // number of parameters
	gPIEGetACellListCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACellListCountFDesc.paramNames := @gpnListIndex;		// pointer to parameter names list
	gPIEGetACellListCountFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gPIEGetACellListCountFDesc.functionFlags := Options;	                // options
        gPIEGetACellListCountFDesc.category := '';
        gPIEGetACellListCountFDesc.neededProject := '';

       	gPIEGetACellListCountDesc.name  :=PChar(ModelPrefix + 'BL_GetCountOfACellList');		   // name of PIE
	gPIEGetACellListCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACellListCountDesc.descriptor := @gPIEGetACellListCountFDesc;   // pointer to descriptor
        gPIEGetACellListCountDesc.version := ANE_PIE_VERSION;
        gPIEGetACellListCountDesc.vendor := '';
        gPIEGetACellListCountDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACellListCountDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell Row from  a particular cell list
	gPIEGetACellRowFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetACellRowFDesc.name :=PChar(ModelPrefix + 'BL_GetCellRow');	        // name of function
	gPIEGetACellRowFDesc.address := GGetCellRowMMFun;	// function address
	gPIEGetACellRowFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetACellRowFDesc.numParams :=  2;			        // number of parameters
	gPIEGetACellRowFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACellRowFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetACellRowFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetACellRowFDesc.functionFlags := Options;	                // options
        gPIEGetACellRowFDesc.category := '';
        gPIEGetACellRowFDesc.neededProject := '';

       	gPIEGetACellRowDesc.name  :=PChar(ModelPrefix + 'BL_GetCellRow');		   // name of PIE
	gPIEGetACellRowDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACellRowDesc.descriptor := @gPIEGetACellRowFDesc;   // pointer to descriptor
        gPIEGetACellRowDesc.version := ANE_PIE_VERSION;
        gPIEGetACellRowDesc.vendor := '';
        gPIEGetACellRowDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACellRowDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell Column from  a particular cell list
	gPIEGetACellColumnFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetACellColumnFDesc.name :=PChar(ModelPrefix + 'BL_GetCellColumn');	        // name of function
	gPIEGetACellColumnFDesc.address := GGetCellColumnMMFun;	// function address
	gPIEGetACellColumnFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetACellColumnFDesc.numParams :=  2;			        // number of parameters
	gPIEGetACellColumnFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACellColumnFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetACellColumnFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetACellColumnFDesc.functionFlags := Options;	                // options
        gPIEGetACellColumnFDesc.category := '';
        gPIEGetACellColumnFDesc.neededProject := '';

       	gPIEGetACellColumnDesc.name  :=PChar(ModelPrefix + 'BL_GetCellColumn');		   // name of PIE
	gPIEGetACellColumnDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACellColumnDesc.descriptor := @gPIEGetACellColumnFDesc;   // pointer to descriptor
        gPIEGetACellColumnDesc.version := ANE_PIE_VERSION;
        gPIEGetACellColumnDesc.vendor := '';
        gPIEGetACellColumnDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACellColumnDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a number of verticies for a particular cell
	gPIEGetACellVertexCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetACellVertexCountFDesc.name :=PChar(ModelPrefix + 'BL_GetVertexCount');	        // name of function
	gPIEGetACellVertexCountFDesc.address := GGetCellVertexCountMMFun;	// function address
	gPIEGetACellVertexCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetACellVertexCountFDesc.numParams :=  2;			        // number of parameters
	gPIEGetACellVertexCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACellVertexCountFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetACellVertexCountFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetACellVertexCountFDesc.functionFlags := Options;	                // options
        gPIEGetACellVertexCountFDesc.category := '';
        gPIEGetACellVertexCountFDesc.neededProject := '';

       	gPIEGetACellVertexCountDesc.name  :=PChar(ModelPrefix + 'BL_GetVertexCount');		   // name of PIE
	gPIEGetACellVertexCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACellVertexCountDesc.descriptor := @gPIEGetACellVertexCountFDesc;   // pointer to descriptor
        gPIEGetACellVertexCountDesc.version := ANE_PIE_VERSION;
        gPIEGetACellVertexCountDesc.vendor := '';
        gPIEGetACellVertexCountDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACellVertexCountDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a XPos of a particular vertex.
	gPIEGetACellVertexXPosFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetACellVertexXPosFDesc.name :=PChar(ModelPrefix + 'BL_GetVertexXPos');	        // name of function
	gPIEGetACellVertexXPosFDesc.address := GGetCellVertexXPosMMFun;	// function address
	gPIEGetACellVertexXPosFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetACellVertexXPosFDesc.numParams :=  3;			        // number of parameters
	gPIEGetACellVertexXPosFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACellVertexXPosFDesc.paramNames := @gpn3Index;		// pointer to parameter names list
	gPIEGetACellVertexXPosFDesc.paramTypes := @g3Integer;	        // pointer to parameters types list
	gPIEGetACellVertexXPosFDesc.functionFlags := Options;	                // options
        gPIEGetACellVertexXPosFDesc.category := '';
        gPIEGetACellVertexXPosFDesc.neededProject := '';

       	gPIEGetACellVertexXPosDesc.name  :=PChar(ModelPrefix + 'BL_GetVertexXPos');		   // name of PIE
	gPIEGetACellVertexXPosDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACellVertexXPosDesc.descriptor := @gPIEGetACellVertexXPosFDesc;   // pointer to descriptor
        gPIEGetACellVertexXPosDesc.version := ANE_PIE_VERSION;
        gPIEGetACellVertexXPosDesc.vendor := '';
        gPIEGetACellVertexXPosDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACellVertexXPosDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a YPos of a particular vertex.
	gPIEGetACellVertexYPosFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetACellVertexYPosFDesc.name :=PChar(ModelPrefix + 'BL_GetVertexYPos');	        // name of function
	gPIEGetACellVertexYPosFDesc.address := GGetCellVertexYPosMMFun;	// function address
	gPIEGetACellVertexYPosFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetACellVertexYPosFDesc.numParams :=  3;			        // number of parameters
	gPIEGetACellVertexYPosFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACellVertexYPosFDesc.paramNames := @gpn3Index;		// pointer to parameter names list
	gPIEGetACellVertexYPosFDesc.paramTypes := @g3Integer;	        // pointer to parameters types list
	gPIEGetACellVertexYPosFDesc.functionFlags := Options;	                // options
        gPIEGetACellVertexYPosFDesc.category := '';
        gPIEGetACellVertexYPosFDesc.neededProject := '';

       	gPIEGetACellVertexYPosDesc.name  :=PChar(ModelPrefix + 'BL_GetVertexYPos');		   // name of PIE
	gPIEGetACellVertexYPosDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACellVertexYPosDesc.descriptor := @gPIEGetACellVertexYPosFDesc;   // pointer to descriptor
        gPIEGetACellVertexYPosDesc.version := ANE_PIE_VERSION;
        gPIEGetACellVertexYPosDesc.vendor := '';
        gPIEGetACellVertexYPosDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACellVertexYPosDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get Count of combined cell list
	gPIEGetCombinedListCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetCombinedListCountFDesc.name :=PChar(ModelPrefix + 'BL_GetCountOfCombinedCellList');	        // name of function
	gPIEGetCombinedListCountFDesc.address := GGetCountOfCombinedListMMFun;	// function address
	gPIEGetCombinedListCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetCombinedListCountFDesc.numParams :=  0;			        // number of parameters
	gPIEGetCombinedListCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetCombinedListCountFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEGetCombinedListCountFDesc.paramTypes := nil;	        // pointer to parameters types list
	gPIEGetCombinedListCountFDesc.functionFlags := Options;	                // options
        gPIEGetCombinedListCountFDesc.category := '';
        gPIEGetCombinedListCountFDesc.neededProject := '';

       	gPIEGetCombinedListCountDesc.name  :=PChar(ModelPrefix + 'BL_GetCountOfCombinedCellList');		   // name of PIE
	gPIEGetCombinedListCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetCombinedListCountDesc.descriptor := @gPIEGetCombinedListCountFDesc;   // pointer to descriptor
        gPIEGetCombinedListCountDesc.version := ANE_PIE_VERSION;
        gPIEGetCombinedListCountDesc.vendor := '';
        gPIEGetCombinedListCountDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetCombinedListCountDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell Row from combined cell list
	gPIEGetACombinedCellRowFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetACombinedCellRowFDesc.name :=PChar(ModelPrefix + 'BL_GetCellRowFromCombinedList');	        // name of function
	gPIEGetACombinedCellRowFDesc.address := GGetCellRowFromCombinedListMMFun;	// function address
	gPIEGetACombinedCellRowFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetACombinedCellRowFDesc.numParams :=  1;			        // number of parameters
	gPIEGetACombinedCellRowFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACombinedCellRowFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEGetACombinedCellRowFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gPIEGetACombinedCellRowFDesc.functionFlags := Options;	                // options
        gPIEGetACombinedCellRowFDesc.category := '';
        gPIEGetACombinedCellRowFDesc.neededProject := '';

       	gPIEGetACombinedCellRowDesc.name  :=PChar(ModelPrefix + 'BL_GetCellRowFromCombinedList');		   // name of PIE
	gPIEGetACombinedCellRowDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACombinedCellRowDesc.descriptor := @gPIEGetACombinedCellRowFDesc;   // pointer to descriptor
        gPIEGetACombinedCellRowDesc.version := ANE_PIE_VERSION;
        gPIEGetACombinedCellRowDesc.vendor := '';
        gPIEGetACombinedCellRowDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACombinedCellRowDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell Column from combined cell list
	gPIEGetACellCombinedColumnFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetACellCombinedColumnFDesc.name :=PChar(ModelPrefix + 'BL_GetCellColumnFromCombinedList');	        // name of function
	gPIEGetACellCombinedColumnFDesc.address := GGetCellColumnFromCombinedListMMFun;	// function address
	gPIEGetACellCombinedColumnFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetACellCombinedColumnFDesc.numParams :=  1;			        // number of parameters
	gPIEGetACellCombinedColumnFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACellCombinedColumnFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEGetACellCombinedColumnFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gPIEGetACellCombinedColumnFDesc.functionFlags := Options;	                // options
        gPIEGetACellCombinedColumnFDesc.category := '';
        gPIEGetACellCombinedColumnFDesc.neededProject := '';

       	gPIEGetACellCombinedColumnDesc.name  :=PChar(ModelPrefix + 'BL_GetCellColumnFromCombinedList');		   // name of PIE
	gPIEGetACellCombinedColumnDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACellCombinedColumnDesc.descriptor := @gPIEGetACellCombinedColumnFDesc;   // pointer to descriptor
        gPIEGetACellCombinedColumnDesc.version := ANE_PIE_VERSION;
        gPIEGetACellCombinedColumnDesc.vendor := '';
        gPIEGetACellCombinedColumnDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACellCombinedColumnDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        //Free List of lists of verticies
	gPIEFreeListVertexFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEFreeListVertexFDesc.name :=PChar(ModelPrefix + 'BL_FreeVertexList');	        // name of function
	gPIEFreeListVertexFDesc.address := GListFreeVertexMMFun;	// function address
	gPIEFreeListVertexFDesc.returnType := kPIEBoolean;		// return value type
	gPIEFreeListVertexFDesc.numParams :=  0;			// number of parameters
	gPIEFreeListVertexFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeListVertexFDesc.paramNames := nil;		        // pointer to parameter names list
	gPIEFreeListVertexFDesc.paramTypes := nil;	                // pointer to parameters types list
	gPIEFreeListVertexFDesc.functionFlags := Options;	                // options
        gPIEFreeListVertexFDesc.category := '';
        gPIEFreeListVertexFDesc.neededProject := '';

       	gPIEFreeListVertexDesc.name  :=PChar(ModelPrefix + 'BL_FreeVertexList');		// name of PIE
	gPIEFreeListVertexDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEFreeListVertexDesc.descriptor := @gPIEFreeListVertexFDesc;	// pointer to descriptor
        gPIEFreeListVertexDesc.version := ANE_PIE_VERSION;
        gPIEFreeListVertexDesc.vendor := '';
        gPIEFreeListVertexDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeListVertexDesc;                  // add descriptor to list
        Inc(numNames);	                                                // increment number of names


        //Free All Lists
	gPIEFreeListBlockFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEFreeListBlockFDesc.name :=PChar(ModelPrefix + 'BL_FreeAllBlockLists');	                // name of function
	gPIEFreeListBlockFDesc.address := GListFreeBlockMMFun;	        // function address
	gPIEFreeListBlockFDesc.returnType := kPIEBoolean;		// return value type
	gPIEFreeListBlockFDesc.numParams :=  0;			        // number of parameters
	gPIEFreeListBlockFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeListBlockFDesc.paramNames := nil;		        // pointer to parameter names list
	gPIEFreeListBlockFDesc.paramTypes := nil;	                // pointer to parameters types list
	gPIEFreeListBlockFDesc.functionFlags := Options;	                // options
        gPIEFreeListBlockFDesc.category := '';
        gPIEFreeListBlockFDesc.neededProject := '';

       	gPIEFreeListBlockDesc.name  :=PChar(ModelPrefix + 'BL_FreeAllBlockLists');		        // name of PIE
	gPIEFreeListBlockDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEFreeListBlockDesc.descriptor := @gPIEFreeListBlockFDesc;	// pointer to descriptor
        gPIEFreeListBlockDesc.version := ANE_PIE_VERSION;
        gPIEFreeListBlockDesc.vendor := '';
        gPIEFreeListBlockDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeListBlockDesc;                   // add descriptor to list
        Inc(numNames);	                                                // increment number of names


        //return number of segments in a cell
	gPIEGetSegmentCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSegmentCountFDesc.name :=PChar(ModelPrefix + 'BL_SegmentCount');	           // name of function
	gPIEGetSegmentCountFDesc.address := GGetSegmentCountMMFun;	   // function address
	gPIEGetSegmentCountFDesc.returnType := kPIEInteger;		   // return value type
	gPIEGetSegmentCountFDesc.numParams :=  2;			   // number of parameters
	gPIEGetSegmentCountFDesc.numOptParams := 0;			   // number of optional parameters
	gPIEGetSegmentCountFDesc.paramNames := @gpn2Index;		   // pointer to parameter names list
	gPIEGetSegmentCountFDesc.paramTypes := @g2Integer;	           // pointer to parameters types list
	gPIEGetSegmentCountFDesc.functionFlags := Options;	                // options
        gPIEGetSegmentCountFDesc.category := '';
        gPIEGetSegmentCountFDesc.neededProject := '';

       	gPIEGetSegmentCountDesc.name  :=PChar(ModelPrefix + 'BL_SegmentCount');		   // name of PIE
	gPIEGetSegmentCountDesc.PieType :=  kFunctionPIE;		   // PIE type: PIE function
	gPIEGetSegmentCountDesc.descriptor := @gPIEGetSegmentCountFDesc;   // pointer to descriptor
        gPIEGetSegmentCountDesc.version := ANE_PIE_VERSION;
        gPIEGetSegmentCountDesc.vendor := '';
        gPIEGetSegmentCountDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSegmentCountDesc;                    // add descriptor to list
        Inc(numNames);	                                                   // increment number of names


        //return XPos of first vertex in a segment.
	gPIEGetSegmentFirstXFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSegmentFirstXFDesc.name :=PChar(ModelPrefix + 'BL_SegmentFirstX');	           // name of function
	gPIEGetSegmentFirstXFDesc.address := GGetCellSegmentFirstVertexXPosMMFun;	   // function address
	gPIEGetSegmentFirstXFDesc.returnType := kPIEFloat;		   // return value type
	gPIEGetSegmentFirstXFDesc.numParams :=  3;			   // number of parameters
	gPIEGetSegmentFirstXFDesc.numOptParams := 0;			   // number of optional parameters
	gPIEGetSegmentFirstXFDesc.paramNames := @gpn3IndexSeg;		   // pointer to parameter names list
	gPIEGetSegmentFirstXFDesc.paramTypes := @g3Integer;	           // pointer to parameters types list
	gPIEGetSegmentFirstXFDesc.functionFlags := Options;	                // options
        gPIEGetSegmentFirstXFDesc.category := '';
        gPIEGetSegmentFirstXFDesc.neededProject := '';

       	gPIEGetSegmentFirstXDesc.name  :=PChar(ModelPrefix + 'BL_SegmentFirstX');		   // name of PIE
	gPIEGetSegmentFirstXDesc.PieType :=  kFunctionPIE;		   // PIE type: PIE function
	gPIEGetSegmentFirstXDesc.descriptor := @gPIEGetSegmentFirstXFDesc;   // pointer to descriptor
        gPIEGetSegmentFirstXDesc.version := ANE_PIE_VERSION;
        gPIEGetSegmentFirstXDesc.vendor := '';
        gPIEGetSegmentFirstXDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSegmentFirstXDesc;                    // add descriptor to list
        Inc(numNames);	                                                   // increment number of names


        //return YPos of first vertex in a segment.
	gPIEGetSegmentFirstYFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSegmentFirstYFDesc.name :=PChar(ModelPrefix + 'BL_SegmentFirstY');	           // name of function
	gPIEGetSegmentFirstYFDesc.address := GGetCellSegmentFirstVertexYPosMMFun;	   // function address
	gPIEGetSegmentFirstYFDesc.returnType := kPIEFloat;		   // return value type
	gPIEGetSegmentFirstYFDesc.numParams :=  3;			   // number of parameters
	gPIEGetSegmentFirstYFDesc.numOptParams := 0;			   // number of optional parameters
	gPIEGetSegmentFirstYFDesc.paramNames := @gpn3IndexSeg;		   // pointer to parameter names list
	gPIEGetSegmentFirstYFDesc.paramTypes := @g3Integer;	           // pointer to parameters types list
	gPIEGetSegmentFirstYFDesc.functionFlags := Options;	                // options
        gPIEGetSegmentFirstYFDesc.category := '';
        gPIEGetSegmentFirstYFDesc.neededProject := '';

       	gPIEGetSegmentFirstYDesc.name  :=PChar(ModelPrefix + 'BL_SegmentFirstY');		   // name of PIE
	gPIEGetSegmentFirstYDesc.PieType :=  kFunctionPIE;		   // PIE type: PIE function
	gPIEGetSegmentFirstYDesc.descriptor := @gPIEGetSegmentFirstYFDesc;   // pointer to descriptor
        gPIEGetSegmentFirstYDesc.version := ANE_PIE_VERSION;
        gPIEGetSegmentFirstYDesc.vendor := '';
        gPIEGetSegmentFirstYDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSegmentFirstYDesc;                    // add descriptor to list
        Inc(numNames);	                                                   // increment number of names


        //return XPos of second vertex in a segment.
	gPIEGetSegmentSecondXFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSegmentSecondXFDesc.name :=PChar(ModelPrefix + 'BL_SegmentSecondX');	           // name of function
	gPIEGetSegmentSecondXFDesc.address := GGetCellSegmentSecondVertexXPosMMFun;	   // function address
	gPIEGetSegmentSecondXFDesc.returnType := kPIEFloat;		   // return value type
	gPIEGetSegmentSecondXFDesc.numParams :=  3;			   // number of parameters
	gPIEGetSegmentSecondXFDesc.numOptParams := 0;			   // number of optional parameters
	gPIEGetSegmentSecondXFDesc.paramNames := @gpn3IndexSeg;		   // pointer to parameter names list
	gPIEGetSegmentSecondXFDesc.paramTypes := @g3Integer;	           // pointer to parameters types list
	gPIEGetSegmentSecondXFDesc.functionFlags := Options;	                // options
        gPIEGetSegmentSecondXFDesc.category := '';
        gPIEGetSegmentSecondXFDesc.neededProject := '';

       	gPIEGetSegmentSecondXDesc.name  :=PChar(ModelPrefix + 'BL_SegmentSecondX');		   // name of PIE
	gPIEGetSegmentSecondXDesc.PieType :=  kFunctionPIE;		   // PIE type: PIE function
	gPIEGetSegmentSecondXDesc.descriptor := @gPIEGetSegmentSecondXFDesc;   // pointer to descriptor
        gPIEGetSegmentSecondXDesc.version := ANE_PIE_VERSION;
        gPIEGetSegmentSecondXDesc.vendor := '';
        gPIEGetSegmentSecondXDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSegmentSecondXDesc;                    // add descriptor to list
        Inc(numNames);	                                                   // increment number of names


        //return YPos of second vertex in a segment.
	gPIEGetSegmentSecondYFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSegmentSecondYFDesc.name :=PChar(ModelPrefix + 'BL_SegmentSecondY');	           // name of function
	gPIEGetSegmentSecondYFDesc.address := GGetCellSegmentSecondVertexYPosMMFun;	   // function address
	gPIEGetSegmentSecondYFDesc.returnType := kPIEFloat;		   // return value type
	gPIEGetSegmentSecondYFDesc.numParams :=  3;			   // number of parameters
	gPIEGetSegmentSecondYFDesc.numOptParams := 0;			   // number of optional parameters
	gPIEGetSegmentSecondYFDesc.paramNames := @gpn3IndexSeg;		   // pointer to parameter names list
	gPIEGetSegmentSecondYFDesc.paramTypes := @g3Integer;	           // pointer to parameters types list
	gPIEGetSegmentSecondYFDesc.functionFlags := Options;	                // options
        gPIEGetSegmentSecondYFDesc.category := '';
        gPIEGetSegmentSecondYFDesc.neededProject := '';

       	gPIEGetSegmentSecondYDesc.name  :=PChar(ModelPrefix + 'BL_SegmentSecondY');		   // name of PIE
	gPIEGetSegmentSecondYDesc.PieType :=  kFunctionPIE;		   // PIE type: PIE function
	gPIEGetSegmentSecondYDesc.descriptor := @gPIEGetSegmentSecondYFDesc;   // pointer to descriptor
        gPIEGetSegmentSecondYDesc.version := ANE_PIE_VERSION;
        gPIEGetSegmentSecondYDesc.vendor := '';
        gPIEGetSegmentSecondYDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSegmentSecondYDesc;                    // add descriptor to list
        Inc(numNames);	                                                   // increment number of names


        //return X length segment.
	gPIEGetSegmentLengthXFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSegmentLengthXFDesc.name :=PChar(ModelPrefix + 'BL_SegmentLengthX');	           // name of function
	gPIEGetSegmentLengthXFDesc.address := GGetCellSegmentXLengthMMFun;	   // function address
	gPIEGetSegmentLengthXFDesc.returnType := kPIEFloat;		   // return value type
	gPIEGetSegmentLengthXFDesc.numParams :=  3;			   // number of parameters
	gPIEGetSegmentLengthXFDesc.numOptParams := 0;			   // number of optional parameters
	gPIEGetSegmentLengthXFDesc.paramNames := @gpn3IndexSeg;		   // pointer to parameter names list
	gPIEGetSegmentLengthXFDesc.paramTypes := @g3Integer;	           // pointer to parameters types list
	gPIEGetSegmentLengthXFDesc.functionFlags := Options;	                // options
        gPIEGetSegmentLengthXFDesc.category := '';
        gPIEGetSegmentLengthXFDesc.neededProject := '';

       	gPIEGetSegmentLengthXDesc.name  :=PChar(ModelPrefix + 'BL_SegmentLengthX');		   // name of PIE
	gPIEGetSegmentLengthXDesc.PieType :=  kFunctionPIE;		   // PIE type: PIE function
	gPIEGetSegmentLengthXDesc.descriptor := @gPIEGetSegmentLengthXFDesc;   // pointer to descriptor
        gPIEGetSegmentLengthXDesc.version := ANE_PIE_VERSION;
        gPIEGetSegmentLengthXDesc.vendor := '';
        gPIEGetSegmentLengthXDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSegmentLengthXDesc;                    // add descriptor to list
        Inc(numNames);	                                                   // increment number of names


        //return Y length segment.
	gPIEGetSegmentLengthYFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSegmentLengthYFDesc.name :=PChar(ModelPrefix + 'BL_SegmentLengthY');	           // name of function
	gPIEGetSegmentLengthYFDesc.address := GGetCellSegmentYLengthMMFun;	   // function address
	gPIEGetSegmentLengthYFDesc.returnType := kPIEFloat;		   // return value type
	gPIEGetSegmentLengthYFDesc.numParams :=  3;			   // number of parameters
	gPIEGetSegmentLengthYFDesc.numOptParams := 0;			   // number of optional parameters
	gPIEGetSegmentLengthYFDesc.paramNames := @gpn3IndexSeg;		   // pointer to parameter names list
	gPIEGetSegmentLengthYFDesc.paramTypes := @g3Integer;	           // pointer to parameters types list
	gPIEGetSegmentLengthYFDesc.functionFlags := Options;	                // options
        gPIEGetSegmentLengthYFDesc.category := '';
        gPIEGetSegmentLengthYFDesc.neededProject := '';

       	gPIEGetSegmentLengthYDesc.name  :=PChar(ModelPrefix + 'BL_SegmentLengthY');		   // name of PIE
	gPIEGetSegmentLengthYDesc.PieType :=  kFunctionPIE;		   // PIE type: PIE function
	gPIEGetSegmentLengthYDesc.descriptor := @gPIEGetSegmentLengthYFDesc;   // pointer to descriptor
        gPIEGetSegmentLengthYDesc.version := ANE_PIE_VERSION;
        gPIEGetSegmentLengthYDesc.vendor := '';
        gPIEGetSegmentLengthYDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSegmentLengthYDesc;                    // add descriptor to list
        Inc(numNames);	                                                   // increment number of names


        //return length segment.
	gPIEGetSegmentLengthFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSegmentLengthFDesc.name :=PChar(ModelPrefix + 'BL_SegmentLength');	           // name of function
	gPIEGetSegmentLengthFDesc.address := GGetCellSegmentLengthMMFun;	   // function address
	gPIEGetSegmentLengthFDesc.returnType := kPIEFloat;		   // return value type
	gPIEGetSegmentLengthFDesc.numParams :=  3;			   // number of parameters
	gPIEGetSegmentLengthFDesc.numOptParams := 0;			   // number of optional parameters
	gPIEGetSegmentLengthFDesc.paramNames := @gpn3IndexSeg;		   // pointer to parameter names list
	gPIEGetSegmentLengthFDesc.paramTypes := @g3Integer;	           // pointer to parameters types list
	gPIEGetSegmentLengthFDesc.functionFlags := Options;	                // options
        gPIEGetSegmentLengthFDesc.category := '';
        gPIEGetSegmentLengthFDesc.neededProject := '';

       	gPIEGetSegmentLengthDesc.name  :=PChar(ModelPrefix + 'BL_SegmentLength');		   // name of PIE
	gPIEGetSegmentLengthDesc.PieType :=  kFunctionPIE;		   // PIE type: PIE function
	gPIEGetSegmentLengthDesc.descriptor := @gPIEGetSegmentLengthFDesc;   // pointer to descriptor
        gPIEGetSegmentLengthDesc.version := ANE_PIE_VERSION;
        gPIEGetSegmentLengthDesc.vendor := '';
        gPIEGetSegmentLengthDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSegmentLengthDesc;                    // add descriptor to list
        Inc(numNames);	                                                   // increment number of names


        //return sum of segment X lengths in a cell
	gPIEGetSumSegmentLengthXFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSumSegmentLengthXFDesc.name :=PChar(ModelPrefix + 'BL_SumSegmentsX');	           // name of function
	gPIEGetSumSegmentLengthXFDesc.address := GGetCellSumSegmentXLengthMMFun;	   // function address
	gPIEGetSumSegmentLengthXFDesc.returnType := kPIEFloat;		   // return value type
	gPIEGetSumSegmentLengthXFDesc.numParams :=  2;			   // number of parameters
	gPIEGetSumSegmentLengthXFDesc.numOptParams := 0;			   // number of optional parameters
	gPIEGetSumSegmentLengthXFDesc.paramNames := @gpn2Index;		   // pointer to parameter names list
	gPIEGetSumSegmentLengthXFDesc.paramTypes := @g2Integer;	           // pointer to parameters types list
	gPIEGetSumSegmentLengthXFDesc.functionFlags := Options;	                // options
        gPIEGetSumSegmentLengthXFDesc.category := '';
        gPIEGetSumSegmentLengthXFDesc.neededProject := '';

       	gPIEGetSumSegmentLengthXDesc.name  :=PChar(ModelPrefix + 'BL_SumSegmentsX');		   // name of PIE
	gPIEGetSumSegmentLengthXDesc.PieType :=  kFunctionPIE;		   // PIE type: PIE function
	gPIEGetSumSegmentLengthXDesc.descriptor := @gPIEGetSumSegmentLengthXFDesc;   // pointer to descriptor
        gPIEGetSumSegmentLengthXDesc.version := ANE_PIE_VERSION;
        gPIEGetSumSegmentLengthXDesc.vendor := '';
        gPIEGetSumSegmentLengthXDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSumSegmentLengthXDesc;                    // add descriptor to list
        Inc(numNames);	                                                   // increment number of names


        //return sum of segment Y lengths in a cell
	gPIEGetSumSegmentLengthYFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSumSegmentLengthYFDesc.name :=PChar(ModelPrefix + 'BL_SumSegmentsY');	           // name of function
	gPIEGetSumSegmentLengthYFDesc.address := GGetCellSumSegmentYLengthMMFun;	   // function address
	gPIEGetSumSegmentLengthYFDesc.returnType := kPIEFloat;		   // return value type
	gPIEGetSumSegmentLengthYFDesc.numParams :=  2;			   // number of parameters
	gPIEGetSumSegmentLengthYFDesc.numOptParams := 0;			   // number of optional parameters
	gPIEGetSumSegmentLengthYFDesc.paramNames := @gpn2Index;		   // pointer to parameter names list
	gPIEGetSumSegmentLengthYFDesc.paramTypes := @g2Integer;	           // pointer to parameters types list
	gPIEGetSumSegmentLengthYFDesc.functionFlags := Options;	                // options
        gPIEGetSumSegmentLengthYFDesc.category := '';
        gPIEGetSumSegmentLengthYFDesc.neededProject := '';

       	gPIEGetSumSegmentLengthYDesc.name  :=PChar(ModelPrefix + 'BL_SumSegmentsY');		   // name of PIE
	gPIEGetSumSegmentLengthYDesc.PieType :=  kFunctionPIE;		   // PIE type: PIE function
	gPIEGetSumSegmentLengthYDesc.descriptor := @gPIEGetSumSegmentLengthYFDesc;   // pointer to descriptor
        gPIEGetSumSegmentLengthYDesc.version := ANE_PIE_VERSION;
        gPIEGetSumSegmentLengthYDesc.vendor := '';
        gPIEGetSumSegmentLengthYDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSumSegmentLengthYDesc;                    // add descriptor to list
        Inc(numNames);	                                                   // increment number of names


        //return sum of segment lengths in a cell
	gPIEGetSumSegmentLengthFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSumSegmentLengthFDesc.name :=PChar(ModelPrefix + 'BL_SumSegmentLengths');	           // name of function
	gPIEGetSumSegmentLengthFDesc.address := GGetCellSumSegmentLengthMMFun;	   // function address
	gPIEGetSumSegmentLengthFDesc.returnType := kPIEFloat;		   // return value type
	gPIEGetSumSegmentLengthFDesc.numParams :=  2;			   // number of parameters
	gPIEGetSumSegmentLengthFDesc.numOptParams := 0;			   // number of optional parameters
	gPIEGetSumSegmentLengthFDesc.paramNames := @gpn2Index;		   // pointer to parameter names list
	gPIEGetSumSegmentLengthFDesc.paramTypes := @g2Integer;	           // pointer to parameters types list
	gPIEGetSumSegmentLengthFDesc.functionFlags := Options;	                // options
        gPIEGetSumSegmentLengthFDesc.category := '';
        gPIEGetSumSegmentLengthFDesc.neededProject := '';

       	gPIEGetSumSegmentLengthDesc.name  :=PChar(ModelPrefix + 'BL_SumSegmentLengths');		   // name of PIE
	gPIEGetSumSegmentLengthDesc.PieType :=  kFunctionPIE;		   // PIE type: PIE function
	gPIEGetSumSegmentLengthDesc.descriptor := @gPIEGetSumSegmentLengthFDesc;   // pointer to descriptor
        gPIEGetSumSegmentLengthDesc.version := ANE_PIE_VERSION;
        gPIEGetSumSegmentLengthDesc.vendor := '';
        gPIEGetSumSegmentLengthDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSumSegmentLengthDesc;                    // add descriptor to list
        Inc(numNames);	                                                   // increment number of names





        // Get Count of Row-Crossing cell lists
	gPIEGetRowCrossingListsCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetRowCrossingListsCountFDesc.name :=PChar(ModelPrefix + 'BL_GetCountOfCrossRowLists');	        // name of function
	gPIEGetRowCrossingListsCountFDesc.address := GGetCountOfCrossRowListsMMFun;	// function address
	gPIEGetRowCrossingListsCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetRowCrossingListsCountFDesc.numParams :=  0;			        // number of parameters
	gPIEGetRowCrossingListsCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetRowCrossingListsCountFDesc.paramNames := nil;		                // pointer to parameter names list
	gPIEGetRowCrossingListsCountFDesc.paramTypes := nil;	                        // pointer to parameters types list
	gPIEGetRowCrossingListsCountFDesc.functionFlags := Options;	                // options
        gPIEGetRowCrossingListsCountFDesc.category := '';
        gPIEGetRowCrossingListsCountFDesc.neededProject := '';

       	gPIEGetRowCrossingListsCountDesc.name  :=PChar(ModelPrefix + 'BL_GetCountOfCrossRowLists');		        // name of PIE
	gPIEGetRowCrossingListsCountDesc.PieType :=  kFunctionPIE;		                // PIE type: PIE function
	gPIEGetRowCrossingListsCountDesc.descriptor := @gPIEGetRowCrossingListsCountFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetRowCrossingListsCountDesc;                             // add descriptor to list
        Inc(numNames);	                                                                // increment number of names

        // Get Count of a particular Row-Crossing cell list
	gPIEGetARowCrossingListCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetARowCrossingListCountFDesc.name :=PChar(ModelPrefix + 'BL_GetCountOfACrossRowList');	        // name of function
	gPIEGetARowCrossingListCountFDesc.address := GGetCountOfACrossRowListMMFun;	// function address
	gPIEGetARowCrossingListCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetARowCrossingListCountFDesc.numParams :=  1;			        // number of parameters
	gPIEGetARowCrossingListCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetARowCrossingListCountFDesc.paramNames := @gpnListIndex;		// pointer to parameter names list
	gPIEGetARowCrossingListCountFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gPIEGetARowCrossingListCountFDesc.functionFlags := Options;	                // options
        gPIEGetARowCrossingListCountFDesc.category := '';
        gPIEGetARowCrossingListCountFDesc.neededProject := '';

       	gPIEGetARowCrossingListCountDesc.name  :=PChar(ModelPrefix + 'BL_GetCountOfACrossRowList');		   // name of PIE
	gPIEGetARowCrossingListCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetARowCrossingListCountDesc.descriptor := @gPIEGetARowCrossingListCountFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetARowCrossingListCountDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell Row from a particular Row-Crossing cell list
	gPIEGetARowCrossingRowFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetARowCrossingRowFDesc.name :=PChar(ModelPrefix + 'BL_GetCrossRowRow');	        // name of function
	gPIEGetARowCrossingRowFDesc.address := GGetCrossRowRowMMFun;	// function address
	gPIEGetARowCrossingRowFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetARowCrossingRowFDesc.numParams :=  2;			        // number of parameters
	gPIEGetARowCrossingRowFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetARowCrossingRowFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetARowCrossingRowFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetARowCrossingRowFDesc.functionFlags := Options;	                // options
        gPIEGetARowCrossingRowFDesc.category := '';
        gPIEGetARowCrossingRowFDesc.neededProject := '';

       	gPIEGetARowCrossingRowDesc.name  := PChar(ModelPrefix + 'BL_GetCrossRowRow');		   // name of PIE
	gPIEGetARowCrossingRowDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetARowCrossingRowDesc.descriptor := @gPIEGetARowCrossingRowFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetARowCrossingRowDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell Column from a particular Row-Crossing cell list
	gPIEGetARowCrossingColumnFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetARowCrossingColumnFDesc.name := PChar(ModelPrefix + 'BL_GetCrossRowColumn');	        // name of function
	gPIEGetARowCrossingColumnFDesc.address := GGetCrossRowColumnMMFun;	// function address
	gPIEGetARowCrossingColumnFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetARowCrossingColumnFDesc.numParams :=  2;			        // number of parameters
	gPIEGetARowCrossingColumnFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetARowCrossingColumnFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetARowCrossingColumnFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetARowCrossingColumnFDesc.functionFlags := Options;	                // options
        gPIEGetARowCrossingColumnFDesc.category := '';
        gPIEGetARowCrossingColumnFDesc.neededProject := '';

       	gPIEGetARowCrossingColumnDesc.name  :=PChar(ModelPrefix + 'BL_GetCrossRowColumn');		   // name of PIE
	gPIEGetARowCrossingColumnDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetARowCrossingColumnDesc.descriptor := @gPIEGetARowCrossingColumnFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetARowCrossingColumnDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a neighboring cell Column from a particular Row-Crossing cell list
	gPIEGetARowCrossingNeighColumnFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetARowCrossingNeighColumnFDesc.name :=PChar(ModelPrefix + 'BL_GetCrossRowNeighborColumn');	        // name of function
	gPIEGetARowCrossingNeighColumnFDesc.address := GGetCrossRowNeighborColumnMMFun;	// function address
	gPIEGetARowCrossingNeighColumnFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetARowCrossingNeighColumnFDesc.numParams :=  2;			        // number of parameters
	gPIEGetARowCrossingNeighColumnFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetARowCrossingNeighColumnFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetARowCrossingNeighColumnFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetARowCrossingNeighColumnFDesc.functionFlags := Options;	                // options
        gPIEGetARowCrossingNeighColumnFDesc.category := '';
        gPIEGetARowCrossingNeighColumnFDesc.neededProject := '';

       	gPIEGetARowCrossingNeighColumnDesc.name  :=PChar(ModelPrefix + 'BL_GetCrossRowNeighborColumn');		   // name of PIE
	gPIEGetARowCrossingNeighColumnDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetARowCrossingNeighColumnDesc.descriptor := @gPIEGetARowCrossingNeighColumnFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetARowCrossingNeighColumnDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a particular Row-Crossing cell CompositeY
	gPIEGetARowCrossingCompositeYFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetARowCrossingCompositeYFDesc.name :=PChar(ModelPrefix + 'BL_GetCrossRowCompositeY');	        // name of function
	gPIEGetARowCrossingCompositeYFDesc.address := GGetCrossRowCompositeYMMFun;	// function address
	gPIEGetARowCrossingCompositeYFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetARowCrossingCompositeYFDesc.numParams :=  2;			        // number of parameters
	gPIEGetARowCrossingCompositeYFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetARowCrossingCompositeYFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetARowCrossingCompositeYFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetARowCrossingCompositeYFDesc.functionFlags := Options;	                // options
        gPIEGetARowCrossingCompositeYFDesc.category := '';
        gPIEGetARowCrossingCompositeYFDesc.neededProject := '';

       	gPIEGetARowCrossingCompositeYDesc.name  :=PChar(ModelPrefix + 'BL_GetCrossRowCompositeY');		   // name of PIE
	gPIEGetARowCrossingCompositeYDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetARowCrossingCompositeYDesc.descriptor := @gPIEGetARowCrossingCompositeYFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetARowCrossingCompositeYDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get sum of all Row-Crossing cell CompositeY's
	gPIEGetSumRowCrossingCompositeYFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSumRowCrossingCompositeYFDesc.name :=PChar(ModelPrefix + 'BL_GetSumCrossRowCompositeY');	        // name of function
	gPIEGetSumRowCrossingCompositeYFDesc.address := GGetSumCrossRowCompositeYMMFun;	// function address
	gPIEGetSumRowCrossingCompositeYFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetSumRowCrossingCompositeYFDesc.numParams :=  1;			        // number of parameters
	gPIEGetSumRowCrossingCompositeYFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetSumRowCrossingCompositeYFDesc.paramNames := @gpnListIndex;		// pointer to parameter names list
	gPIEGetSumRowCrossingCompositeYFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gPIEGetSumRowCrossingCompositeYFDesc.functionFlags := Options;	                // options
        gPIEGetSumRowCrossingCompositeYFDesc.category := '';
        gPIEGetSumRowCrossingCompositeYFDesc.neededProject := '';

       	gPIEGetSumRowCrossingCompositeYDesc.name  :=PChar(ModelPrefix + 'BL_GetSumCrossRowCompositeY');		   // name of PIE
	gPIEGetSumRowCrossingCompositeYDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetSumRowCrossingCompositeYDesc.descriptor := @gPIEGetSumRowCrossingCompositeYFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSumRowCrossingCompositeYDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names





        // Get Count of Column-Crossing cell lists
	gPIEGetColumnCrossingListsCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetColumnCrossingListsCountFDesc.name :=PChar(ModelPrefix + 'BL_GetCountOfCrossColumnLists');	        // name of function
	gPIEGetColumnCrossingListsCountFDesc.address := GGetCountOfCrossColumnListsMMFun;	// function address
	gPIEGetColumnCrossingListsCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetColumnCrossingListsCountFDesc.numParams :=  0;			        // number of parameters
	gPIEGetColumnCrossingListsCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetColumnCrossingListsCountFDesc.paramNames := nil;		                // pointer to parameter names list
	gPIEGetColumnCrossingListsCountFDesc.paramTypes := nil;	                        // pointer to parameters types list
	gPIEGetColumnCrossingListsCountFDesc.functionFlags := Options;	                // options
        gPIEGetColumnCrossingListsCountFDesc.category := '';
        gPIEGetColumnCrossingListsCountFDesc.neededProject := '';

       	gPIEGetColumnCrossingListsCountDesc.name  :=PChar(ModelPrefix + 'BL_GetCountOfCrossColumnLists');		        // name of PIE
	gPIEGetColumnCrossingListsCountDesc.PieType :=  kFunctionPIE;		                // PIE type: PIE function
	gPIEGetColumnCrossingListsCountDesc.descriptor := @gPIEGetColumnCrossingListsCountFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetColumnCrossingListsCountDesc;                             // add descriptor to list
        Inc(numNames);	                                                                // increment number of names

        // Get Count of a particular Column-Crossing cell list
	gPIEGetAColumnCrossingListCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetAColumnCrossingListCountFDesc.name :=PChar(ModelPrefix + 'BL_GetCountOfACrossColumnList');	        // name of function
	gPIEGetAColumnCrossingListCountFDesc.address := GGetCountOfACrossColumnListMMFun;	// function address
	gPIEGetAColumnCrossingListCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetAColumnCrossingListCountFDesc.numParams :=  1;			        // number of parameters
	gPIEGetAColumnCrossingListCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetAColumnCrossingListCountFDesc.paramNames := @gpnListIndex;		// pointer to parameter names list
	gPIEGetAColumnCrossingListCountFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gPIEGetAColumnCrossingListCountFDesc.functionFlags := Options;	                // options
        gPIEGetAColumnCrossingListCountFDesc.category := '';
        gPIEGetAColumnCrossingListCountFDesc.neededProject := '';

       	gPIEGetAColumnCrossingListCountDesc.name  :=PChar(ModelPrefix + 'BL_GetCountOfACrossColumnList');		   // name of PIE
	gPIEGetAColumnCrossingListCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetAColumnCrossingListCountDesc.descriptor := @gPIEGetAColumnCrossingListCountFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetAColumnCrossingListCountDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell Row from a particular Column-Crossing cell list
	gPIEGetAColumnCrossingRowFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetAColumnCrossingRowFDesc.name :=PChar(ModelPrefix + 'BL_GetCrossColumnRow');	        // name of function
	gPIEGetAColumnCrossingRowFDesc.address := GGetCrossColumnRowMMFun;	// function address
	gPIEGetAColumnCrossingRowFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetAColumnCrossingRowFDesc.numParams :=  2;			        // number of parameters
	gPIEGetAColumnCrossingRowFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetAColumnCrossingRowFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetAColumnCrossingRowFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetAColumnCrossingRowFDesc.functionFlags := Options;	                // options
        gPIEGetAColumnCrossingRowFDesc.category := '';
        gPIEGetAColumnCrossingRowFDesc.neededProject := '';

       	gPIEGetAColumnCrossingRowDesc.name  :=PChar(ModelPrefix + 'BL_GetCrossColumnRow');		   // name of PIE
	gPIEGetAColumnCrossingRowDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetAColumnCrossingRowDesc.descriptor := @gPIEGetAColumnCrossingRowFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetAColumnCrossingRowDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell in the neighboring Row from a particular Column-Crossing cell list
	gPIEGetAColumnCrossingNeighRowFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetAColumnCrossingNeighRowFDesc.name :=PChar(ModelPrefix + 'BL_GetCrossColumnNeighborRow');	        // name of function
	gPIEGetAColumnCrossingNeighRowFDesc.address := GGetCrossColumnNeighborRowMMFun;	// function address
	gPIEGetAColumnCrossingNeighRowFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetAColumnCrossingNeighRowFDesc.numParams :=  2;			        // number of parameters
	gPIEGetAColumnCrossingNeighRowFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetAColumnCrossingNeighRowFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetAColumnCrossingNeighRowFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetAColumnCrossingNeighRowFDesc.functionFlags := Options;	                // options
        gPIEGetAColumnCrossingNeighRowFDesc.category := '';
        gPIEGetAColumnCrossingNeighRowFDesc.neededProject := '';

       	gPIEGetAColumnCrossingNeighRowDesc.name  :=PChar(ModelPrefix + 'BL_GetCrossColumnNeighborRow');		   // name of PIE
	gPIEGetAColumnCrossingNeighRowDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetAColumnCrossingNeighRowDesc.descriptor := @gPIEGetAColumnCrossingNeighRowFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetAColumnCrossingNeighRowDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell Column from a particular Column-Crossing cell list
	gPIEGetAColumnCrossingColumnFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetAColumnCrossingColumnFDesc.name :=PChar(ModelPrefix + 'BL_GetCrossColumnColumn');	        // name of function
	gPIEGetAColumnCrossingColumnFDesc.address := GGetCrossColumnColumnMMFun;	// function address
	gPIEGetAColumnCrossingColumnFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetAColumnCrossingColumnFDesc.numParams :=  2;			        // number of parameters
	gPIEGetAColumnCrossingColumnFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetAColumnCrossingColumnFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetAColumnCrossingColumnFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetAColumnCrossingColumnFDesc.functionFlags := Options;	                // options
        gPIEGetAColumnCrossingColumnFDesc.category := '';
        gPIEGetAColumnCrossingColumnFDesc.neededProject := '';

       	gPIEGetAColumnCrossingColumnDesc.name  :=PChar(ModelPrefix + 'BL_GetCrossColumnColumn');		   // name of PIE
	gPIEGetAColumnCrossingColumnDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetAColumnCrossingColumnDesc.descriptor := @gPIEGetAColumnCrossingColumnFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetAColumnCrossingColumnDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a particular Column-Crossing cell CompositeX
	gPIEGetAColumnCrossingCompositeXFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetAColumnCrossingCompositeXFDesc.name :=PChar(ModelPrefix + 'BL_GetCrossColumnCompositeX');	        // name of function
	gPIEGetAColumnCrossingCompositeXFDesc.address := GGetCrossColumnCompositeXMMFun;	// function address
	gPIEGetAColumnCrossingCompositeXFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetAColumnCrossingCompositeXFDesc.numParams :=  2;			        // number of parameters
	gPIEGetAColumnCrossingCompositeXFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetAColumnCrossingCompositeXFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetAColumnCrossingCompositeXFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetAColumnCrossingCompositeXFDesc.functionFlags := Options;	                // options
        gPIEGetAColumnCrossingCompositeXFDesc.category := '';
        gPIEGetAColumnCrossingCompositeXFDesc.neededProject := '';

       	gPIEGetAColumnCrossingCompositeXDesc.name  :=PChar(ModelPrefix + 'BL_GetCrossColumnCompositeX');		   // name of PIE
	gPIEGetAColumnCrossingCompositeXDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetAColumnCrossingCompositeXDesc.descriptor := @gPIEGetAColumnCrossingCompositeXFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetAColumnCrossingCompositeXDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get sum of all Column-Crossing cell CompositeX's
	gPIEGetSumColumnCrossingCompositeXFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetSumColumnCrossingCompositeXFDesc.name :=PChar(ModelPrefix + 'BL_GetSumCrossColumnCompositeX');	        // name of function
	gPIEGetSumColumnCrossingCompositeXFDesc.address := GGetSumCrossColumnCompositeXMMFun;	// function address
	gPIEGetSumColumnCrossingCompositeXFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetSumColumnCrossingCompositeXFDesc.numParams :=  1;			        // number of parameters
	gPIEGetSumColumnCrossingCompositeXFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetSumColumnCrossingCompositeXFDesc.paramNames := @gpnListIndex;		// pointer to parameter names list
	gPIEGetSumColumnCrossingCompositeXFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gPIEGetSumColumnCrossingCompositeXFDesc.functionFlags := Options;	                // options
        gPIEGetSumColumnCrossingCompositeXFDesc.category := '';
        gPIEGetSumColumnCrossingCompositeXFDesc.neededProject := '';

       	gPIEGetSumColumnCrossingCompositeXDesc.name  :=PChar(ModelPrefix + 'BL_GetSumCrossColumnCompositeX');		   // name of PIE
	gPIEGetSumColumnCrossingCompositeXDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetSumColumnCrossingCompositeXDesc.descriptor := @gPIEGetSumColumnCrossingCompositeXFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetSumColumnCrossingCompositeXDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a Row Boundary
	gPIEGetRowBoundaryFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetRowBoundaryFDesc.name :=PChar(ModelPrefix + 'BL_GetRowBoundary');	        // name of function
	gPIEGetRowBoundaryFDesc.address := GGetRowBoundaryPositionMMFun;	// function address
	gPIEGetRowBoundaryFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetRowBoundaryFDesc.numParams :=  1;			        // number of parameters
	gPIEGetRowBoundaryFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetRowBoundaryFDesc.paramNames := @gpnRow;		// pointer to parameter names list
	gPIEGetRowBoundaryFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gPIEGetRowBoundaryFDesc.functionFlags := Options;	                // options
        gPIEGetRowBoundaryFDesc.category := '';
        gPIEGetRowBoundaryFDesc.neededProject := '';

       	gPIEGetRowBoundaryDesc.name  :=PChar(ModelPrefix + 'BL_GetRowBoundary');		   // name of PIE
	gPIEGetRowBoundaryDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetRowBoundaryDesc.descriptor := @gPIEGetRowBoundaryFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetRowBoundaryDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a Column Boundary
	gPIEGetColumnBoundaryFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetColumnBoundaryFDesc.name :=PChar(ModelPrefix + 'BL_GetColumnBoundary');	        // name of function
	gPIEGetColumnBoundaryFDesc.address := GGetColumnBoundaryPositionMMFun;	// function address
	gPIEGetColumnBoundaryFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetColumnBoundaryFDesc.numParams :=  1;			        // number of parameters
	gPIEGetColumnBoundaryFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetColumnBoundaryFDesc.paramNames := @gpnColumn;		// pointer to parameter names list
	gPIEGetColumnBoundaryFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gPIEGetColumnBoundaryFDesc.functionFlags := Options;	                // options
        gPIEGetColumnBoundaryFDesc.category := '';
        gPIEGetColumnBoundaryFDesc.neededProject := '';

       	gPIEGetColumnBoundaryDesc.name  :=PChar(ModelPrefix + 'BL_GetColumnBoundary');		   // name of PIE
	gPIEGetColumnBoundaryDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetColumnBoundaryDesc.descriptor := @gPIEGetColumnBoundaryFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetColumnBoundaryDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Determine if a point is inside a closed contour.
	gPIEPointInsideContourFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEPointInsideContourFDesc.name :=PChar(ModelPrefix + 'BL_PointInsideContour');	        // name of function
	gPIEPointInsideContourFDesc.address := GPointInsideContourMMFun;	// function address
	gPIEPointInsideContourFDesc.returnType := kPIEBoolean;		        // return value type
	gPIEPointInsideContourFDesc.numParams :=  3;			        // number of parameters
	gPIEPointInsideContourFDesc.numOptParams := 1;			        // number of optional parameters
	gPIEPointInsideContourFDesc.paramNames := @gpn3IndexXY;		// pointer to parameter names list
	gPIEPointInsideContourFDesc.paramTypes := @g1Integer2Float;	        // pointer to parameters types list
	gPIEPointInsideContourFDesc.functionFlags := Options;	                // options
        gPIEPointInsideContourFDesc.category := '';
        gPIEPointInsideContourFDesc.neededProject := '';

       	gPIEPointInsideContourDesc.name  :=PChar(ModelPrefix + 'BL_PointInsideContour');		   // name of PIE
	gPIEPointInsideContourDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEPointInsideContourDesc.descriptor := @gPIEPointInsideContourFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEPointInsideContourDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // return the contour type: point = 1, open = 2, closed = 3
	gPIEContourTypeFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEContourTypeFDesc.name :=PChar(ModelPrefix + 'BL_ContourType');	        // name of function
	gPIEContourTypeFDesc.address := GContourTypeMMFun;	// function address
	gPIEContourTypeFDesc.returnType := kPIEInteger;		        // return value type
	gPIEContourTypeFDesc.numParams :=  1;			        // number of parameters
	gPIEContourTypeFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEContourTypeFDesc.paramNames := @gpnListIndex;		// pointer to parameter names list
	gPIEContourTypeFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gPIEContourTypeFDesc.functionFlags := Options;	                // options
        gPIEContourTypeFDesc.category := '';
        gPIEContourTypeFDesc.neededProject := '';

       	gPIEContourTypeDesc.name  :=PChar(ModelPrefix + 'BL_ContourType');		   // name of PIE
	gPIEContourTypeDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEContourTypeDesc.descriptor := @gPIEContourTypeFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEContourTypeDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names


        // Get a Row Boundary
	gPIEGetRowNodeFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetRowNodeFDesc.name :=PChar(ModelPrefix + 'BL_GetRowNodePosition');	        // name of function
	gPIEGetRowNodeFDesc.address := GGetRowNodePositionMMFun;	// function address
	gPIEGetRowNodeFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetRowNodeFDesc.numParams :=  1;			        // number of parameters
	gPIEGetRowNodeFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetRowNodeFDesc.paramNames := @gpnRow;		// pointer to parameter names list
	gPIEGetRowNodeFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gPIEGetRowNodeFDesc.functionFlags := Options;	                // options
        gPIEGetRowNodeFDesc.category := '';
        gPIEGetRowNodeFDesc.neededProject := '';

       	gPIEGetRowNodeDesc.name  :=PChar(ModelPrefix + 'BL_GetRowNodePosition');		   // name of PIE
	gPIEGetRowNodeDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetRowNodeDesc.descriptor := @gPIEGetRowNodeFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetRowNodeDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a Column Boundary
	gPIEGetColumnNodeFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetColumnNodeFDesc.name :=PChar(ModelPrefix + 'BL_GetColumnNodePosition');	        // name of function
	gPIEGetColumnNodeFDesc.address := GGetColumnNodePositionMMFun;	// function address
	gPIEGetColumnNodeFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetColumnNodeFDesc.numParams :=  1;			        // number of parameters
	gPIEGetColumnNodeFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetColumnNodeFDesc.paramNames := @gpnColumn;		// pointer to parameter names list
	gPIEGetColumnNodeFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list
	gPIEGetColumnNodeFDesc.functionFlags := Options;	                // options
        gPIEGetColumnNodeFDesc.category := '';
        gPIEGetColumnNodeFDesc.neededProject := '';

       	gPIEGetColumnNodeDesc.name  :=PChar(ModelPrefix + 'BL_GetColumnNodePosition');		   // name of PIE
	gPIEGetColumnNodeDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetColumnNodeDesc.descriptor := @gPIEGetColumnNodeFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetColumnNodeDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a Count of Row Boundaries
	gPIEGetRowBoundaryCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetRowBoundaryCountFDesc.name :=PChar(ModelPrefix + 'BL_GetRowBoundaryCount');	        // name of function
	gPIEGetRowBoundaryCountFDesc.address := GGetRowBoundaryCountMMFun;	// function address
	gPIEGetRowBoundaryCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetRowBoundaryCountFDesc.numParams :=  0;			        // number of parameters
	gPIEGetRowBoundaryCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetRowBoundaryCountFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEGetRowBoundaryCountFDesc.paramTypes := nil;	        // pointer to parameters types list
	gPIEGetRowBoundaryCountFDesc.functionFlags := Options;	                // options
        gPIEGetRowBoundaryCountFDesc.category := '';
        gPIEGetRowBoundaryCountFDesc.neededProject := '';

       	gPIEGetRowBoundaryCountDesc.name  :=PChar(ModelPrefix + 'BL_GetRowBoundaryCount');		   // name of PIE
	gPIEGetRowBoundaryCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetRowBoundaryCountDesc.descriptor := @gPIEGetRowBoundaryCountFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetRowBoundaryCountDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a Count of Column Boundaries
	gPIEGetColumnBoundaryCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetColumnBoundaryCountFDesc.name :=PChar(ModelPrefix + 'BL_GetColumnBoundaryCount');	        // name of function
	gPIEGetColumnBoundaryCountFDesc.address := GGetColumnBoundaryCountMMFun;	// function address
	gPIEGetColumnBoundaryCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetColumnBoundaryCountFDesc.numParams :=  0;			        // number of parameters
	gPIEGetColumnBoundaryCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetColumnBoundaryCountFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEGetColumnBoundaryCountFDesc.paramTypes := nil;	        // pointer to parameters types list
	gPIEGetColumnBoundaryCountFDesc.functionFlags := Options;	                // options
        gPIEGetColumnBoundaryCountFDesc.category := '';
        gPIEGetColumnBoundaryCountFDesc.neededProject := '';

       	gPIEGetColumnBoundaryCountDesc.name  :=PChar(ModelPrefix + 'BL_GetColumnBoundaryCount');		   // name of PIE
	gPIEGetColumnBoundaryCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetColumnBoundaryCountDesc.descriptor := @gPIEGetColumnBoundaryCountFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetColumnBoundaryCountDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a Count of Row Nodes
	gPIEGetRowNodeCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetRowNodeCountFDesc.name :=PChar(ModelPrefix + 'BL_GetRowNodeCount');	        // name of function
	gPIEGetRowNodeCountFDesc.address := GGetRowNodeCountMMFun;	// function address
	gPIEGetRowNodeCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetRowNodeCountFDesc.numParams :=  0;			        // number of parameters
	gPIEGetRowNodeCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetRowNodeCountFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEGetRowNodeCountFDesc.paramTypes := nil;	        // pointer to parameters types list
	gPIEGetRowNodeCountFDesc.functionFlags := Options;	                // options
        gPIEGetRowNodeCountFDesc.category := '';
        gPIEGetRowNodeCountFDesc.neededProject := '';

       	gPIEGetRowNodeCountDesc.name  :=PChar(ModelPrefix + 'BL_GetRowNodeCount');		   // name of PIE
	gPIEGetRowNodeCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetRowNodeCountDesc.descriptor := @gPIEGetRowNodeCountFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetRowNodeCountDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a Count of Column Nodes
	gPIEGetColumnNodeCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetColumnNodeCountFDesc.name :=PChar(ModelPrefix + 'BL_GetColumnNodeCount');	        // name of function
	gPIEGetColumnNodeCountFDesc.address := GGetColumnNodeCountMMFun;	// function address
	gPIEGetColumnNodeCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetColumnNodeCountFDesc.numParams :=  0;			        // number of parameters
	gPIEGetColumnNodeCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetColumnNodeCountFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEGetColumnNodeCountFDesc.paramTypes := nil;	        // pointer to parameters types list
	gPIEGetColumnNodeCountFDesc.functionFlags := Options;	                // options
        gPIEGetColumnNodeCountFDesc.category := '';
        gPIEGetColumnNodeCountFDesc.neededProject := '';

       	gPIEGetColumnNodeCountDesc.name  :=PChar(ModelPrefix + 'BL_GetColumnNodeCount');		   // name of PIE
	gPIEGetColumnNodeCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetColumnNodeCountDesc.descriptor := @gPIEGetColumnNodeCountFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetColumnNodeCountDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a Cell Area
	gPIEGetCellAreaFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetCellAreaFDesc.name :=PChar(ModelPrefix + 'BL_GetCellArea');	        // name of function
	gPIEGetCellAreaFDesc.address := GGetCellAreaMMFun;	// function address
	gPIEGetCellAreaFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetCellAreaFDesc.numParams :=  2;			        // number of parameters
	gPIEGetCellAreaFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetCellAreaFDesc.paramNames := @gpnColumnRow;		// pointer to parameter names list
	gPIEGetCellAreaFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetCellAreaFDesc.functionFlags := Options;	                // options
        gPIEGetCellAreaFDesc.category := '';
        gPIEGetCellAreaFDesc.neededProject := '';

       	gPIEGetCellAreaDesc.name  :=PChar(ModelPrefix + 'BL_GetCellArea');		   // name of PIE
	gPIEGetCellAreaDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetCellAreaDesc.descriptor := @gPIEGetCellAreaFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetCellAreaDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a Cell Area
	gPIEGetLineFractionFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetLineFractionFDesc.name :=PChar(ModelPrefix + 'BL_FractionOfLine');	        // name of function
	gPIEGetLineFractionFDesc.address := GGetFractionOfLineMMFun;	// function address
	gPIEGetLineFractionFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetLineFractionFDesc.numParams :=  2;			        // number of parameters
	gPIEGetLineFractionFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetLineFractionFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetLineFractionFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetLineFractionFDesc.functionFlags := Options;	                // options
        gPIEGetLineFractionFDesc.category := '';
        gPIEGetLineFractionFDesc.neededProject := '';

       	gPIEGetLineFractionDesc.name  :=PChar(ModelPrefix + 'BL_FractionOfLine');		   // name of PIE
	gPIEGetLineFractionDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetLineFractionDesc.descriptor := @gPIEGetLineFractionFDesc;   // pointer to descriptor
        gPIEGetLineFractionDesc.version := ANE_PIE_VERSION;
        gPIEGetLineFractionDesc.vendor := '';
        gPIEGetLineFractionDesc.product := '';


	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetLineFractionDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a number of errors.
	gPIEGetErrorCountFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetErrorCountFDesc.name :=PChar(ModelPrefix + 'BL_GetErrorCount');	        // name of function
	gPIEGetErrorCountFDesc.address := GGetErrorCountMMFun;	// function address
	gPIEGetErrorCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetErrorCountFDesc.numParams :=  0;			        // number of parameters
	gPIEGetErrorCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetErrorCountFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEGetErrorCountFDesc.paramTypes := nil;	        // pointer to parameters types list
	gPIEGetErrorCountFDesc.functionFlags := Options;	                // options
        gPIEGetErrorCountFDesc.category := '';
        gPIEGetErrorCountFDesc.neededProject := '';

       	gPIEGetErrorCountDesc.name  :=PChar(ModelPrefix + 'BL_GetErrorCount');		   // name of PIE
	gPIEGetErrorCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetErrorCountDesc.descriptor := @gPIEGetErrorCountFDesc;   // pointer to descriptor
        gPIEGetErrorCountDesc.version := ANE_PIE_VERSION;
        gPIEGetErrorCountDesc.vendor := '';
        gPIEGetErrorCountDesc.product := '';


	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetErrorCountDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get Row-Crossing cell Composite Length
	gPIEGetRowCrossingCompositeLengthFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetRowCrossingCompositeLengthFDesc.name :=PChar(ModelPrefix + 'BL_GetCrossRowCompositeLength');	        // name of function
	gPIEGetRowCrossingCompositeLengthFDesc.address := GGetCrossRowCompositeLengthMMFun;	// function address
	gPIEGetRowCrossingCompositeLengthFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetRowCrossingCompositeLengthFDesc.numParams :=  2;			        // number of parameters
	gPIEGetRowCrossingCompositeLengthFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetRowCrossingCompositeLengthFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetRowCrossingCompositeLengthFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetRowCrossingCompositeLengthFDesc.functionFlags := Options;	                // options
        gPIEGetRowCrossingCompositeLengthFDesc.category := '';
        gPIEGetRowCrossingCompositeLengthFDesc.neededProject := '';

       	gPIEGetRowCrossingCompositeLengthDesc.name  :=PChar(ModelPrefix + 'BL_GetCrossRowCompositeLength');		   // name of PIE
	gPIEGetRowCrossingCompositeLengthDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetRowCrossingCompositeLengthDesc.descriptor := @gPIEGetRowCrossingCompositeLengthFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetRowCrossingCompositeLengthDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get Column-Crossing cell Composite Length
	gPIEGetColumnCrossingCompositeLengthFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetColumnCrossingCompositeLengthFDesc.name :=PChar(ModelPrefix + 'BL_GetCrossColumnCompositeLength');	        // name of function
	gPIEGetColumnCrossingCompositeLengthFDesc.address := GGetCrossColumnCompositeLengthMMFun;	// function address
	gPIEGetColumnCrossingCompositeLengthFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetColumnCrossingCompositeLengthFDesc.numParams :=  2;			        // number of parameters
	gPIEGetColumnCrossingCompositeLengthFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetColumnCrossingCompositeLengthFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetColumnCrossingCompositeLengthFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list
	gPIEGetColumnCrossingCompositeLengthFDesc.functionFlags := Options;	                // options
        gPIEGetColumnCrossingCompositeLengthFDesc.category := '';
        gPIEGetColumnCrossingCompositeLengthFDesc.neededProject := '';

       	gPIEGetColumnCrossingCompositeLengthDesc.name  :=PChar(ModelPrefix + 'BL_GetCrossColumnCompositeLength');		   // name of PIE
	gPIEGetColumnCrossingCompositeLengthDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetColumnCrossingCompositeLengthDesc.descriptor := @gPIEGetColumnCrossingCompositeLengthFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetColumnCrossingCompositeLengthDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

    	gPIECheckVersionFDesc.name := PChar(ModelPrefix + 'BL_CheckVersion');	        // name of function
	gPIECheckVersionFDesc.address := GPIECheckVersionMMFun;		// function address
	gPIECheckVersionFDesc.returnType := kPIEBoolean;		// return value type
	gPIECheckVersionFDesc.numParams :=  4;			// number of parameters
	gPIECheckVersionFDesc.numOptParams := 0;			// number of optional parameters
	gPIECheckVersionFDesc.paramNames := @gpnFourDigit;		// pointer to parameter names list
	gPIECheckVersionFDesc.paramTypes := @gFourIntegerTypes;	// pointer to parameters types list
        gPIECheckVersionFDesc.version := FUNCTION_PIE_VERSION;
        gPIECheckVersionFDesc.functionFlags := Options;
        gPIECheckVersionFDesc.category := '';
        gPIECheckVersionFDesc.neededProject := '';

       	gPIECheckVersionDesc.name  := PChar(ModelPrefix + 'BL_CheckVersion');		// name of PIE
	gPIECheckVersionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;	// pointer to descriptor
        gPIECheckVersionDesc.version := ANE_PIE_VERSION;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECheckVersionDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names


	descriptors := @gFunDesc;

end;


end.
