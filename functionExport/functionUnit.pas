unit functionUnit;

interface

uses 

  AnePIE, FunctionPie, Dialogs, Sysutils;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
  

implementation



const
  kMaxFunDesc = 20;

var

        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

        gPIEOpenFileDesc  : ANEPIEDesc;
        gPIEOpenFileFDesc :  FunctionPIEDesc;

        gPIECloseFileDesc  : ANEPIEDesc;
        gPIECloseFileFDesc :  FunctionPIEDesc;

        gPIEWriteIntegerDesc  : ANEPIEDesc;
        gPIEWriteIntegerFDesc :  FunctionPIEDesc;

        gPIEEndLineDesc  : ANEPIEDesc;
        gPIEEndLineFDesc :  FunctionPIEDesc;

        F : TextFile;

const   gpnNumber : array [0..1] of PChar = ('Number', nil);
const   gOneIntegerTypes : array [0..1] of EPIENumberType = (kPIEInteger, 0);

const   gpnFile : array [0..1] of PChar = ('File_Name', nil);
const   gOneStringTypes : array [0..1] of EPIENumberType = (kPIEString, 0);

procedure GPIEOpenFileMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  FileName : ANE_STR;
  result : ANE_BOOL;
  param : PParameter_array;
begin
  result := False ;
  try
    try
      param := @parameters^;
      FileName :=  param^[0];

      AssignFile(F, String(FileName));
      Rewrite(F);
      result := true;
    except On E: Exception do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
  ANE_BOOL_PTR(reply)^ := result;
  end;
end;

procedure GPIECloseFileMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_BOOL;
begin
  result := False ;
  try
    try
      CloseFile(F);
      result := true;
    except On E: Exception do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
  ANE_BOOL_PTR(reply)^ := result;
  end;
end;

procedure GPIEWriteIntegerMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1Ptr : ANE_INT32_PTR;
  AnInteger : ANE_INT32;
  result : ANE_BOOL;
  param : PParameter_array;
begin
  result := False ;
  try
    try
      param := @parameters^;
      param1Ptr :=  param^[0];
      AnInteger :=  param1Ptr^;
      Write(F, AnInteger, ' ');
      result := true;
    except On E: Exception do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
  ANE_BOOL_PTR(reply)^ := result;
  end;
end;

procedure GPIEEndLineMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_BOOL;
begin
  result := False ;
  try
    try
      Writeln(F);
      result := true;
    except On E: Exception do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
  ANE_BOOL_PTR(reply)^ := result;
  end;
end;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

	numNames := 0;

	gPIEOpenFileFDesc.name := 'Open_File';	        // name of function
	gPIEOpenFileFDesc.address := GPIEOpenFileMMFun;		// function address
	gPIEOpenFileFDesc.returnType := kPIEBoolean;		// return value type
	gPIEOpenFileFDesc.numParams :=  1;			// number of parameters
	gPIEOpenFileFDesc.numOptParams := 0;			// number of optional parameters
	gPIEOpenFileFDesc.paramNames := @gpnFile;		// pointer to parameter names list
	gPIEOpenFileFDesc.paramTypes := @gOneStringTypes;	// pointer to parameters types list

       	gPIEOpenFileDesc.name  := 'Open_File';		// name of PIE
	gPIEOpenFileDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEOpenFileDesc.descriptor := @gPIEOpenFileFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEOpenFileDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIECloseFileFDesc.name := 'Close_File';	        // name of function
	gPIECloseFileFDesc.address := GPIECloseFileMMFun;		// function address
	gPIECloseFileFDesc.returnType := kPIEBoolean;		// return value type
	gPIECloseFileFDesc.numParams :=  0;			// number of parameters
	gPIECloseFileFDesc.numOptParams := 0;			// number of optional parameters
	gPIECloseFileFDesc.paramNames := nil;		// pointer to parameter names list
	gPIECloseFileFDesc.paramTypes := nil;	// pointer to parameters types list

       	gPIECloseFileDesc.name  := 'Close_File';		// name of PIE
	gPIECloseFileDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECloseFileDesc.descriptor := @gPIECloseFileFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECloseFileDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEWriteIntegerFDesc.name := 'Write_Integer';	        // name of function
	gPIEWriteIntegerFDesc.address := GPIEWriteIntegerMMFun;		// function address
	gPIEWriteIntegerFDesc.returnType := kPIEBoolean;		// return value type
	gPIEWriteIntegerFDesc.numParams :=  1;			// number of parameters
	gPIEWriteIntegerFDesc.numOptParams := 0;			// number of optional parameters
	gPIEWriteIntegerFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEWriteIntegerFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list

       	gPIEWriteIntegerDesc.name  := 'Write_Integer';		// name of PIE
	gPIEWriteIntegerDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEWriteIntegerDesc.descriptor := @gPIEWriteIntegerFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEWriteIntegerDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names


	gPIEEndLineFDesc.name := 'End_Line';	        // name of function
	gPIEEndLineFDesc.address := GPIEEndLineMMFun;		// function address
	gPIEEndLineFDesc.returnType := kPIEBoolean;		// return value type
	gPIEEndLineFDesc.numParams :=  0;			// number of parameters
	gPIEEndLineFDesc.numOptParams := 0;			// number of optional parameters
	gPIEEndLineFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEEndLineFDesc.paramTypes := nil;	// pointer to parameters types list

       	gPIEEndLineDesc.name  := 'End_Line';		// name of PIE
	gPIEEndLineDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEEndLineDesc.descriptor := @gPIEEndLineFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEEndLineDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names



	descriptors := @gFunDesc;

end;

end.
