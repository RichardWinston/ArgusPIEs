unit OkCancelUnit;

interface

uses 

  AnePIE, FunctionPie, Dialogs, Controls;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
  
procedure GPIEOkCancelFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses RadioSelectionUnit, EditSelection, CheckPIEVersionFunction,
  UtilityFunctions;

const
  kMaxFunDesc = 20;

const   gpnMessage : array [0..4] of PChar = ('Message', 'Choices_Height',
            'Width', 'Question_Height', nil);
const   gOneStringTypes : array [0..4] of EPIENumberType = (kPIEString,
             kPIEInteger, kPIEInteger, kPIEInteger, 0);

const   gpnNumber : array [0..1] of PChar = ('Number', nil);
const   gOneNumberTypes : array [0..1] of EPIENumberType = (kPIEInteger, 0);

const   gpnMessageResponse : array [0..2] of PChar = ('Message', 'Response', nil);
const   gTwoStringTypes : array [0..2] of EPIENumberType = (kPIEString,
             kPIEString, 0);
const   gString3FloatTypes : array [0..4] of EPIENumberType = (kPIEString,
             kPIEFloat, kPIEFloat, kPIEFloat, 0);
const   gString3IntegerTypes : array [0..4] of EPIENumberType = (kPIEString,
             kPIEInteger, kPIEInteger, kPIEInteger, 0);

const   gpnMessages : array [0..5] of PChar = ('Message', 'Message',
            'Message', 'Message', 'Message', nil);
const   gFiveStringTypes : array [0..5] of EPIENumberType = (kPIEString,
             kPIEString, kPIEString, kPIEString, kPIEString, 0);

const   gpnMessageHidecancel : array [0..2] of PChar = ('Message',
            'Hide_Cancel', nil);
const   gStringBooleanTypes : array [0..2] of EPIENumberType = (kPIEString,
             kPIEBoolean, 0);

var
        result : ANE_BOOL;

        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

        gPIEIsOKFDesc :  FunctionPIEDesc;
        gPIEIsOKDesc  :  ANEPIEDesc;

        gPIEAddRadioChoiceFDesc :  FunctionPIEDesc;
        gPIEAddRadioChoiceDesc  :  ANEPIEDesc;

        gPIEGetRadioChoiceFDesc :  FunctionPIEDesc;
        gPIEGetRadioChoiceDesc  :  ANEPIEDesc;

        gPIERadioChoiceFreeFDesc :  FunctionPIEDesc;
        gPIERadioChoiceFreeDesc  :  ANEPIEDesc;

        gPIEUserSelectionFDesc :  FunctionPIEDesc;
        gPIEUserSelectionDesc  :  ANEPIEDesc;

        gPIEUserIntegerSelectionFDesc :  FunctionPIEDesc;
        gPIEUserIntegerSelectionDesc  :  ANEPIEDesc;

procedure GPIEOkCancelFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AMessage : ANE_STR;
  param : PParameter_array;
  HideCancel : ANE_BOOL;
  Param2Ptr : ANE_BOOL_PTR;
begin
  param := @parameters^;
  AMessage :=  param^[0];
  if numParams > 1 then
  begin
    Param2Ptr :=  param^[1];
    HideCancel := Param2Ptr^;
  end
  else
  begin
    HideCancel := False;
  end;

  if HideCancel then
  begin
    result := (MessageDlg(String(AMessage), mtWarning,
              [ mbYes, mbNo], 0) = mrYes);
  end
  else
  begin
    result := (MessageDlg(String(AMessage), mtWarning,
              [ mbYes, mbNo, mbCancel], 0) = mrYes);
  end;

  ANE_BOOL_PTR(reply)^ := result;
end;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
var
  Options : EFunctionPIEFlags;
begin
        if ShowHiddenFunctions then
        begin
          Options := 0;
        end
        else
        begin
          Options := kFunctionIsHidden;
        end;


	numNames := 0;

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

        // IsOK function
        gPIEIsOKFDesc.version    := FUNCTION_PIE_VERSION ;
        gPIEIsOKFDesc.functionFlags    := Options ;
	gPIEIsOKFDesc.name := 'IsOK';	        // name of function
	gPIEIsOKFDesc.address := GPIEOkCancelFun;		// function address
	gPIEIsOKFDesc.returnType := kPIEBoolean;		// return value type
	gPIEIsOKFDesc.numParams :=  1;			// number of parameters
	gPIEIsOKFDesc.numOptParams := 1;			// number of optional parameters
	gPIEIsOKFDesc.paramNames := @gpnMessageHidecancel;		// pointer to parameter names list
	gPIEIsOKFDesc.paramTypes := @gStringBooleanTypes;	// pointer to parameters types list
	gPIEIsOKFDesc.functionHandle := nil;
	gPIEIsOKFDesc.category := '';
	gPIEIsOKFDesc.neededProject := '';

       	gPIEIsOKDesc.version  := ANE_PIE_VERSION;
       	gPIEIsOKDesc.vendor  := '';
       	gPIEIsOKDesc.product  := '';
       	gPIEIsOKDesc.name  := 'IsOK';		// name of PIE
	gPIEIsOKDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEIsOKDesc.descriptor := @gPIEIsOKFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEIsOKDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names


        // add radio choice function
        gPIEAddRadioChoiceFDesc.version    := FUNCTION_PIE_VERSION ;
        gPIEAddRadioChoiceFDesc.functionFlags    := Options ;
	gPIEAddRadioChoiceFDesc.name := 'ok_Add_Radio_Choice';	        // name of function
	gPIEAddRadioChoiceFDesc.address := GPIEAddRadioChoiceFun;		// function address
	gPIEAddRadioChoiceFDesc.returnType := kPIEBoolean;		// return value type
	gPIEAddRadioChoiceFDesc.numParams :=  1;			// number of parameters
	gPIEAddRadioChoiceFDesc.numOptParams := 4;			// number of optional parameters
	gPIEAddRadioChoiceFDesc.paramNames := @gpnMessages;		// pointer to parameter names list
	gPIEAddRadioChoiceFDesc.paramTypes := @gFiveStringTypes;	// pointer to parameters types list
	gPIEAddRadioChoiceFDesc.functionHandle := nil;
	gPIEAddRadioChoiceFDesc.category := '';
	gPIEAddRadioChoiceFDesc.neededProject := '';

       	gPIEAddRadioChoiceDesc.version  := ANE_PIE_VERSION;
       	gPIEAddRadioChoiceDesc.vendor  := '';
       	gPIEAddRadioChoiceDesc.product  := '';
       	gPIEAddRadioChoiceDesc.name  := 'ok_Add_Radio_Choice';		// name of PIE
	gPIEAddRadioChoiceDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEAddRadioChoiceDesc.descriptor := @gPIEAddRadioChoiceFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAddRadioChoiceDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names


        gPIEGetRadioChoiceFDesc.version    := FUNCTION_PIE_VERSION ;
        gPIEGetRadioChoiceFDesc.functionFlags    := Options ;
	gPIEGetRadioChoiceFDesc.name := 'ok_Get_Radio_Choice';	        // name of function
	gPIEGetRadioChoiceFDesc.address := GPIEGetRadioChoiceFun;		// function address
	gPIEGetRadioChoiceFDesc.returnType := kPIEInteger;		// return value type
	gPIEGetRadioChoiceFDesc.numParams :=  1;			// number of parameters
	gPIEGetRadioChoiceFDesc.numOptParams := 3;			// number of optional parameters
	gPIEGetRadioChoiceFDesc.paramNames := @gpnMessage;		// pointer to parameter names list
	gPIEGetRadioChoiceFDesc.paramTypes := @gOneStringTypes;	// pointer to parameters types list
	gPIEGetRadioChoiceFDesc.functionHandle := nil;
	gPIEGetRadioChoiceFDesc.category := '';
	gPIEGetRadioChoiceFDesc.neededProject := '';

       	gPIEGetRadioChoiceDesc.version  := ANE_PIE_VERSION;
       	gPIEGetRadioChoiceDesc.vendor  := '';
       	gPIEGetRadioChoiceDesc.product  := '';
       	gPIEGetRadioChoiceDesc.name  := 'ok_Get_Radio_Choice';		// name of PIE
	gPIEGetRadioChoiceDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetRadioChoiceDesc.descriptor := @gPIEGetRadioChoiceFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetRadioChoiceDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        gPIERadioChoiceFreeFDesc.version    := FUNCTION_PIE_VERSION ;
        gPIERadioChoiceFreeFDesc.functionFlags    := Options ;
	gPIERadioChoiceFreeFDesc.name := 'ok_Radio_Free';	        // name of function
	gPIERadioChoiceFreeFDesc.address := GPIERadioChoiceFreeFun;		// function address
	gPIERadioChoiceFreeFDesc.returnType := kPIEBoolean;		// return value type
	gPIERadioChoiceFreeFDesc.numParams :=  0;			// number of parameters
	gPIERadioChoiceFreeFDesc.numOptParams := 0;			// number of optional parameters
	gPIERadioChoiceFreeFDesc.paramNames := nil;		// pointer to parameter names list
	gPIERadioChoiceFreeFDesc.paramTypes := nil;	// pointer to parameters types list
	gPIERadioChoiceFreeFDesc.functionHandle := nil;
	gPIERadioChoiceFreeFDesc.category := '';
	gPIERadioChoiceFreeFDesc.neededProject := '';

       	gPIERadioChoiceFreeDesc.version  := ANE_PIE_VERSION;
       	gPIERadioChoiceFreeDesc.vendor  := '';
       	gPIERadioChoiceFreeDesc.product  := '';
       	gPIERadioChoiceFreeDesc.name  := 'ok_Radio_Free';		// name of PIE
	gPIERadioChoiceFreeDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIERadioChoiceFreeDesc.descriptor := @gPIERadioChoiceFreeFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIERadioChoiceFreeDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        gPIEUserSelectionFDesc.version    := FUNCTION_PIE_VERSION ;
        gPIEUserSelectionFDesc.functionFlags    := Options ;
	gPIEUserSelectionFDesc.name := 'ok_UserFloat';	        // name of function
	gPIEUserSelectionFDesc.address := GPIEGetEditFloatResponseFun;		// function address
	gPIEUserSelectionFDesc.returnType := kPIEFloat;		// return value type
	gPIEUserSelectionFDesc.numParams :=  2;			// number of parameters
	gPIEUserSelectionFDesc.numOptParams := 2;			// number of optional parameters
	gPIEUserSelectionFDesc.paramNames := @gpnMessageResponse;		// pointer to parameter names list
	gPIEUserSelectionFDesc.paramTypes := @gString3FloatTypes;	// pointer to parameters types list
	gPIEUserSelectionFDesc.functionHandle := nil;
	gPIEUserSelectionFDesc.category := '';
	gPIEUserSelectionFDesc.neededProject := '';

       	gPIEUserSelectionDesc.version  := ANE_PIE_VERSION;
       	gPIEUserSelectionDesc.vendor  := '';
       	gPIEUserSelectionDesc.product  := '';
       	gPIEUserSelectionDesc.name  := 'ok_UserFloat';		// name of PIE
	gPIEUserSelectionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEUserSelectionDesc.descriptor := @gPIEUserSelectionFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEUserSelectionDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // Get Integer
        gPIEUserIntegerSelectionFDesc.version    := FUNCTION_PIE_VERSION ;
        gPIEUserIntegerSelectionFDesc.functionFlags    := Options ;
	gPIEUserIntegerSelectionFDesc.name := 'ok_UserInteger';	        // name of function
	gPIEUserIntegerSelectionFDesc.address := GPIEGetEditIntegerResponseFun;		// function address
	gPIEUserIntegerSelectionFDesc.returnType := kPIEInteger;		// return value type
	gPIEUserIntegerSelectionFDesc.numParams :=  2;			// number of parameters
	gPIEUserIntegerSelectionFDesc.numOptParams := 2;			// number of optional parameters
	gPIEUserIntegerSelectionFDesc.paramNames := @gpnMessageResponse;		// pointer to parameter names list
	gPIEUserIntegerSelectionFDesc.paramTypes := @gString3IntegerTypes;	// pointer to parameters types list
	gPIEUserIntegerSelectionFDesc.functionHandle := nil;
	gPIEUserIntegerSelectionFDesc.category := '';
	gPIEUserIntegerSelectionFDesc.neededProject := '';

       	gPIEUserIntegerSelectionDesc.version  := ANE_PIE_VERSION;
       	gPIEUserIntegerSelectionDesc.vendor  := '';
       	gPIEUserIntegerSelectionDesc.product  := '';
       	gPIEUserIntegerSelectionDesc.name  := 'ok_UserInteger';		// name of PIE
	gPIEUserIntegerSelectionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEUserIntegerSelectionDesc.descriptor := @gPIEUserIntegerSelectionFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEUserIntegerSelectionDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names







	gPIECheckVersionFDesc.name := 'ok_CheckVersion';	        // name of function
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

       	gPIECheckVersionDesc.name  := 'ok_CheckVersion';		// name of PIE
	gPIECheckVersionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;	// pointer to descriptor
        gPIECheckVersionDesc.version := ANE_PIE_VERSION;
        gPIECheckVersionDesc.vendor := '';
        gPIECheckVersionDesc.product := '';

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECheckVersionDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names





	descriptors := @gFunDesc;

end;

end.
