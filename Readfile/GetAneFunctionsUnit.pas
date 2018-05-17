unit GetAneFunctionsUnit;

interface

uses Windows, SysUtils,

  AnePIE, FunctionPie;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

procedure GPIEGetValueMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEClearFilesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIESaveFilesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses ValueFileUnit, CheckPIEVersionFunction;

const
  kMaxFunDesc = 20;

var

        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

        gPIEGetValueDesc : ANEPIEDesc;
        gPIEGetValueFDesc :  FunctionPIEDesc;

        gPIEClearFilesDesc : ANEPIEDesc;
        gPIEClearFilesFDesc :  FunctionPIEDesc;

        gPIESaveFilesDesc : ANEPIEDesc;
        gPIESaveFilesFDesc :  FunctionPIEDesc;

//        gPIEGetNADesc : ANEPIEDesc;
//        gPIEGetNAFDesc :  FunctionPIEDesc;

const   gpnKeyDefaultFile : array [0..3] of PChar = ('Key', 'Default_Value', 'File_Name', nil);
const   gStringFloatStringTypes : array [0..3] of EPIENumberType = (kPIEString, kPIEFloat or kPIENA, kPIEString, 0);

// const   gpnValue : array [0..1] of PChar = ('Value', nil);
// const   gBoolNATypes : array [0..1] of EPIENumberType = (kPIEBoolean or kPIENA, 0 );

function GetCurrentDir: string;
var
  Buffer: array[0..MAX_PATH - 1] of Char;
begin
  SetString(Result, Buffer, GetCurrentDirectory(SizeOf(Buffer), Buffer));
end;

procedure GPIEGetValueMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Key : ANE_STR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param2_ptr : ANE_DOUBLE_PTR;
  DefaultValue : ANE_DOUBLE;
  fileName : ANE_STR;
  result : ANE_DOUBLE;
  param : PParameter_array;
  fileNameString : string;

begin
  param := @parameters^;
  Key :=  param^[0];
  param2_ptr :=  param^[1];
{  if param2_ptr <> nil then
  begin }
    DefaultValue :=  param2_ptr^;
//  end;
  if numParams > 2 then
  begin
    fileName := param^[2];
    fileNameString := String(fileName);
    if ExtractFileDir(fileNameString) = '' then
    begin
      fileNameString := GetCurrentDir + '\' + fileNameString;
    end;
  end
  else
  begin
    fileNameString := GetCurrentDir + '\Default.txt'
  end;
{  if param2_ptr = nil then
  begin
    if FileList.GetNAValue(fileNameString, String(Key) result ) then
    begin
      ANE_DOUBLE_PTR(reply)^ := result;
{    end
    else
    begin
      reply := nil;
    end;
  end
  else
  begin }
    result := FileList.GetValue(fileNameString, String(Key), DefaultValue);
    ANE_DOUBLE_PTR(reply)^ := result;
//  end;
end;

{procedure GPIEGetNAMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_BOOL_PTR;
  result : ANE_BOOL;
  param : PParameter_array;

begin
  param := @parameters^;
  param1_ptr :=  param^[0];
  if param1_ptr <> nil then
  begin
    result :=  param1_ptr^;
    ANE_BOOL_PTR(reply)^ := result;
  end
  else
  begin
    reply := nil;
  end;
end;       }

procedure GPIEClearFilesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
begin
  FileList.ClearFiles;
  ANE_BOOL_PTR(reply)^ := True;
end;

procedure GPIESaveFilesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
begin
  FileList.SaveFiles;
  ANE_BOOL_PTR(reply)^ := True;
end;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
const
//  ModelPrefix = '';
  ModelPrefix = 'MODFLOW_';
//  ModelPrefix = 'SUTRA_';
begin

	numNames := 0;

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

	gPIEGetValueFDesc.name := PChar(ModelPrefix + 'RF_Get_Value_From_File');	        // name of function
	gPIEGetValueFDesc.address := GPIEGetValueMMFun;		// function address
	gPIEGetValueFDesc.returnType := kPIEFloat;		// return value type
	gPIEGetValueFDesc.numParams :=  2;			// number of parameters
	gPIEGetValueFDesc.numOptParams := 1;			// number of optional parameters
	gPIEGetValueFDesc.paramNames := @gpnKeyDefaultFile;		// pointer to parameter names list
	gPIEGetValueFDesc.paramTypes := @gStringFloatStringTypes;	// pointer to parameters types list

       	gPIEGetValueDesc.name  := PChar(ModelPrefix + 'RF_Get_Value_From_File');		// name of PIE
	gPIEGetValueDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetValueDesc.descriptor := @gPIEGetValueFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetValueDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names


	gPIESaveFilesFDesc.name := PChar(ModelPrefix + 'RF_Save_Files');	        // name of function
	gPIESaveFilesFDesc.address := GPIESaveFilesMMFun;		// function address
	gPIESaveFilesFDesc.returnType := kPIEBoolean;		// return value type
	gPIESaveFilesFDesc.numParams :=  0;			// number of parameters
	gPIESaveFilesFDesc.numOptParams := 0;			// number of optional parameters
	gPIESaveFilesFDesc.paramNames := nil;		// pointer to parameter names list
	gPIESaveFilesFDesc.paramTypes := nil;	// pointer to parameters types list

       	gPIESaveFilesDesc.name  := PChar(ModelPrefix + 'RF_Save_Files');		// name of PIE
	gPIESaveFilesDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIESaveFilesDesc.descriptor := @gPIESaveFilesFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESaveFilesDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names


	gPIEClearFilesFDesc.name := PChar(ModelPrefix + 'RF_Clear_Files');	        // name of function
	gPIEClearFilesFDesc.address := GPIEClearFilesMMFun;		// function address
	gPIEClearFilesFDesc.returnType := kPIEBoolean;		// return value type
	gPIEClearFilesFDesc.numParams :=  0;			// number of parameters
	gPIEClearFilesFDesc.numOptParams := 0;			// number of optional parameters
	gPIEClearFilesFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEClearFilesFDesc.paramTypes := nil;	// pointer to parameters types list

       	gPIEClearFilesDesc.name  := PChar(ModelPrefix + 'RF_Clear_Files');		// name of PIE
	gPIEClearFilesDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEClearFilesDesc.descriptor := @gPIEClearFilesFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEClearFilesDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIECheckVersionFDesc.name := PChar(ModelPrefix + 'RF_CheckVersion');	        // name of function
	gPIECheckVersionFDesc.address := GPIECheckVersionMMFun;		// function address
	gPIECheckVersionFDesc.returnType := kPIEBoolean;		// return value type
	gPIECheckVersionFDesc.numParams :=  4;			// number of parameters
	gPIECheckVersionFDesc.numOptParams := 0;			// number of optional parameters
	gPIECheckVersionFDesc.paramNames := @gpnFourDigit;		// pointer to parameter names list
	gPIECheckVersionFDesc.paramTypes := @gFourIntegerTypes;	// pointer to parameters types list
        gPIECheckVersionFDesc.version := FUNCTION_PIE_VERSION;

       	gPIECheckVersionDesc.name  := PChar(ModelPrefix + 'RF_CheckVersion');		// name of PIE
	gPIECheckVersionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;	// pointer to descriptor
        gPIECheckVersionDesc.version := ANE_PIE_VERSION;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECheckVersionDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names





{	gPIEGetNAFDesc.name := 'RF_GetNA';	        // name of function
	gPIEGetNAFDesc.address := GPIEGetNAMMFun;		// function address
	gPIEGetNAFDesc.returnType := kPIEBoolean or kPIENA;		// return value type
	gPIEGetNAFDesc.numParams :=  1;			// number of parameters
	gPIEGetNAFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetNAFDesc.paramNames := @gpnValue;		// pointer to parameter names list
	gPIEGetNAFDesc.paramTypes := @gBoolNATypes;	// pointer to parameters types list

       	gPIEGetNADesc.name  := 'RF_GetNA';		// name of PIE
	gPIEGetNADesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetNADesc.descriptor := @gPIEGetNAFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetNADesc;  // add descriptor to list
        Inc(numNames);	// increment number of names  }

	descriptors := @gFunDesc;
end;

end.
