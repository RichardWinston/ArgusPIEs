unit functionUnit;

interface

uses Windows, Forms, Sysutils,

  AnePIE, FunctionPie, ANECB;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
  
{
procedure GPIEAbsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
}

implementation

uses ProgressBarUnit, CheckPIEVersionFunction, UtilityFunctions;

const
  kMaxFunDesc = 8;

var

        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

        gPIEInitializeDesc  : ANEPIEDesc;
        gPIEInitializeFDesc : FunctionPIEDesc;

        gPIEFreeDesc  : ANEPIEDesc;
        gPIEFreeFDesc : FunctionPIEDesc;

        gPIEMaxDesc  : ANEPIEDesc;
        gPIEMaxFDesc : FunctionPIEDesc;

        gPIEAdvanceDesc  : ANEPIEDesc;
        gPIEAdvanceFDesc : FunctionPIEDesc;

        gPIEMessageDesc  : ANEPIEDesc;
        gPIEMessageFDesc : FunctionPIEDesc;

        gPIEAddLineDesc  : ANEPIEDesc;
        gPIEAddLineFDesc : FunctionPIEDesc;

        gPIESaveDesc  : ANEPIEDesc;
        gPIESaveFDesc : FunctionPIEDesc;

const   gpnNumber : array [0..1] of PChar = ('Number', nil);
const   gOneIntegerTypes : array [0..1] of EPIENumberType = (kPIEInteger, 0);

const   gpnNumberShow : array [0..2] of PChar = ('Number', 'Show_Cancel', nil);
const   gIntBoolTypes : array [0..2] of EPIENumberType = (kPIEInteger,kPIEBoolean, 0);

const   gpnMessage : array [0..1] of PChar = ('Message', nil);
const   gpnFileName : array [0..1] of PChar = ('File_Name', nil);
const   gOneStringTypes : array [0..1] of EPIENumberType = (kPIEString, 0);


procedure GPIEInitializeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_BOOL_PTR;
  Max : ANE_INT32;
  result : ANE_BOOL;
  param : PParameter_array;
  ShowCancelButton : boolean;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      Max :=  param1_ptr^;
      if ProgressBarForm = nil
      then
        begin
          ProgressBarForm := TProgressBarForm.Create(Application);
          ProgressBarForm.ProgressBar1.Max := Max;
          if numParams >= 2 then
          begin
            param2_ptr :=  param^[1];
            ShowCancelButton := param2_ptr^;
            ProgressBarForm.Panel2.Visible := ShowCancelButton;
          end;
          ProgressBarForm.Show;
          result := True;
        end
      else
        begin
          result := False;
        end;
    end;
  except on Exception do
    begin
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;

end;

procedure GPIEFreeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_BOOL;
begin
  try
    begin
      ProgressBarForm.Free;
      ProgressBarForm := nil;
      result := True;
    end;
  except on Exception do
    begin
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;

end;

procedure GPIESetMaxMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Max : ANE_INT32;
  result : ANE_BOOL;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      Max :=  param1_ptr^;
      ProgressBarForm.ProgressBar1.Max := Max;
      result := ProgressBarForm.ContinueSimulation;
    end
  except on Exception do
    begin
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIEStepItMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_BOOL;
  Step : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param : PParameter_array;
begin
  try
    begin
      if numParams > 0 then
      begin
        param := @parameters^;
        param1_ptr :=  param^[0];
        Step :=  param1_ptr^;
        ProgressBarForm.ProgressBar1.StepBy(Step);
      end
      else
      begin
        ProgressBarForm.ProgressBar1.StepIt;
      end;

{      CurrentTime := Now;
      ElapsedTime := CurrentTime - StartTime;
      ProgressBarForm.StatusBar1.Panels[0].Text := 'Elapsed Time: ' +
         FormatDateTime('hh:nn:ss',ElapsedTime);
      if not (ElapsedTime = 0) then
      begin
        RemainingTime := ((ProgressBarForm.ProgressBar1.Max -
                                ProgressBarForm.ProgressBar1.Position)
                             /ProgressBarForm.ProgressBar1.Position)*ElapsedTime;

        ProgressBarForm.StatusBar1.Panels[1].Text := 'Estimated Time Remaining: ' +
           FormatDateTime('hh:nn:ss',RemainingTime);
      end;   }
      result := ProgressBarForm.SetTime;
    end;
  except on Exception do
    begin
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIESetMessageMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_STR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
//  Max : ANE_INT32;
  result : ANE_BOOL;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
//      Max :=  param1_ptr^;
      ProgressBarForm.lblMessage.Caption := String(param1_ptr);
      result := ProgressBarForm.ContinueSimulation;
    end
  except on Exception do
    begin
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIEAddLineMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_STR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
//  Max : ANE_INT32;
  result : ANE_BOOL;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
//      Max :=  param1_ptr^;
      ProgressBarForm.RichEdit1.Lines.Add(String(param1_ptr));
      result := ProgressBarForm.ContinueSimulation;
    end
  except on Exception do
    begin
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIESaveMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_STR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  result : ANE_INT32;
  param : PParameter_array;
  Directory : string;
//  Index : integer;
  AString : array [0..MAX_PATH+1] of Char;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
{      Directory := '0';
      For Index := 1 to 10 do
      begin
        Directory := Directory + Directory;
      end;  }
      ANE_DirectoryGetCurrent(myHandle,  AString, MAX_PATH+1 );
      Directory := Trim(String(AString));
      ProgressBarForm.RichEdit1.Lines.SaveToFile(Directory + String(param1_ptr));
      result := ProgressBarForm.RichEdit1.Lines.Count;
    end
  except on Exception do
    begin
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
const
  vendor = 'USGS';
  product = 'ProgressBarPIE';
  category = '';
  neededProject = '';
//  ModelPrefix = '';
//  ModelPrefix = 'MODFLOW_';
  ModelPrefix = 'SUTRA_';
var
  CurrentfunctionFlags : integer;
begin
  if ShowHiddenFunctions then
  begin
    CurrentfunctionFlags := 0   ;
  end
  else
  begin
    CurrentfunctionFlags := kFunctionIsHidden   ;
  end;

	numNames := 0;
        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

        // Create and set the maximum value of the progress bar
	gPIEInitializeFDesc.name := PChar(ModelPrefix +'ProgressBarInitialize');	        // name of function
	gPIEInitializeFDesc.address := GPIEInitializeMMFun;		// function address
	gPIEInitializeFDesc.returnType := kPIEBoolean;		// return value type
	gPIEInitializeFDesc.numParams :=  1;			// number of parameters
	gPIEInitializeFDesc.numOptParams := 1;			// number of optional parameters
	gPIEInitializeFDesc.paramNames := @gpnNumberShow;		// pointer to parameter names list
	gPIEInitializeFDesc.paramTypes := @gIntBoolTypes;	// pointer to parameters types list
        gPIEInitializeFDesc.version := FUNCTION_PIE_VERSION;
        gPIEInitializeFDesc.functionFlags := CurrentfunctionFlags;
        gPIEInitializeFDesc.category := category;
        gPIEInitializeFDesc.neededProject := neededProject;

       	gPIEInitializeDesc.name  := PChar(ModelPrefix +'ProgressBarInitialize');		// name of PIE
	gPIEInitializeDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEInitializeDesc.descriptor := @gPIEInitializeFDesc;	// pointer to descriptor
        gPIEInitializeDesc.version := ANE_PIE_VERSION;
        gPIEInitializeDesc.vendor := vendor;
        gPIEInitializeDesc.product := product;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEInitializeDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // Free the progress bar
	gPIEFreeFDesc.name := PChar(ModelPrefix +'ProgressBarFree');	        // name of function
	gPIEFreeFDesc.address := GPIEFreeMMFun;		// function address
	gPIEFreeFDesc.returnType := kPIEBoolean;		// return value type
	gPIEFreeFDesc.numParams :=  0;			// number of parameters
	gPIEFreeFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEFreeFDesc.paramTypes := nil;	// pointer to parameters types list
        gPIEFreeFDesc.version := FUNCTION_PIE_VERSION;
        gPIEFreeFDesc.functionFlags := CurrentfunctionFlags;
        gPIEFreeFDesc.category := category;
        gPIEFreeFDesc.neededProject := neededProject;

       	gPIEFreeDesc.name  := PChar(ModelPrefix +'ProgressBarFree');		// name of PIE
	gPIEFreeDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEFreeDesc.descriptor := @gPIEFreeFDesc;	// pointer to descriptor
        gPIEFreeDesc.version := ANE_PIE_VERSION;
        gPIEFreeDesc.vendor := vendor;
        gPIEFreeDesc.product := product;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // Set the maximum value of the progress bar
	gPIEMaxFDesc.name := PChar(ModelPrefix +'ProgressBarMax');	        // name of function
	gPIEMaxFDesc.address := GPIESetMaxMMFun;		// function address
	gPIEMaxFDesc.returnType := kPIEBoolean;		// return value type
	gPIEMaxFDesc.numParams :=  1;			// number of parameters
	gPIEMaxFDesc.numOptParams := 0;			// number of optional parameters
	gPIEMaxFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEMaxFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
        gPIEMaxFDesc.version := FUNCTION_PIE_VERSION;
        gPIEMaxFDesc.functionFlags := CurrentfunctionFlags;
        gPIEMaxFDesc.category := category;
        gPIEMaxFDesc.neededProject := neededProject;

       	gPIEMaxDesc.name  := PChar(ModelPrefix +'ProgressBarMax');		// name of PIE
	gPIEMaxDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEMaxDesc.descriptor := @gPIEMaxFDesc;	// pointer to descriptor
        gPIEMaxDesc.version := ANE_PIE_VERSION;
        gPIEMaxDesc.vendor := vendor;
        gPIEMaxDesc.product := product;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEMaxDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // Advance the progress bar
	gPIEAdvanceFDesc.name := PChar(ModelPrefix +'ProgressBarAdvance');	        // name of function
	gPIEAdvanceFDesc.address := GPIEStepItMMFun;		// function address
	gPIEAdvanceFDesc.returnType := kPIEBoolean;		// return value type
	gPIEAdvanceFDesc.numParams :=  0;			// number of parameters
	gPIEAdvanceFDesc.numOptParams := 1;			// number of optional parameters
	gPIEAdvanceFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEAdvanceFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
        gPIEAdvanceFDesc.version := FUNCTION_PIE_VERSION;
        gPIEAdvanceFDesc.functionFlags := CurrentfunctionFlags;
        gPIEAdvanceFDesc.category := category;
        gPIEAdvanceFDesc.neededProject := neededProject;

       	gPIEAdvanceDesc.name  := PChar(ModelPrefix +'ProgressBarAdvance');		// name of PIE
	gPIEAdvanceDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEAdvanceDesc.descriptor := @gPIEAdvanceFDesc;	// pointer to descriptor
        gPIEAdvanceDesc.version := ANE_PIE_VERSION;
        gPIEAdvanceDesc.vendor := vendor;
        gPIEAdvanceDesc.product := product;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAdvanceDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEMessageFDesc.name := PChar(ModelPrefix +'ProgressBarSetMessage');	        // name of function
	gPIEMessageFDesc.address := GPIESetMessageMMFun;		// function address
	gPIEMessageFDesc.returnType := kPIEBoolean;		// return value type
	gPIEMessageFDesc.numParams :=  1;			// number of parameters
	gPIEMessageFDesc.numOptParams := 0;			// number of optional parameters
	gPIEMessageFDesc.paramNames := @gpnMessage;		// pointer to parameter names list
	gPIEMessageFDesc.paramTypes := @gOneStringTypes;	// pointer to parameters types list
        gPIEMessageFDesc.version := FUNCTION_PIE_VERSION;
        gPIEMessageFDesc.functionFlags := CurrentfunctionFlags;
        gPIEMessageFDesc.category := category;
        gPIEMessageFDesc.neededProject := neededProject;

       	gPIEMessageDesc.name  := PChar(ModelPrefix +'ProgressBarSetMessage');		// name of PIE
	gPIEMessageDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEMessageDesc.descriptor := @gPIEMessageFDesc;	// pointer to descriptor
        gPIEMessageDesc.version := ANE_PIE_VERSION;
        gPIEMessageDesc.vendor := vendor;
        gPIEMessageDesc.product := product;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEMessageDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEAddLineFDesc.name := PChar(ModelPrefix +'ProgressBarAddLine');	        // name of function
	gPIEAddLineFDesc.address := GPIEAddLineMMFun;		// function address
	gPIEAddLineFDesc.returnType := kPIEBoolean;		// return value type
	gPIEAddLineFDesc.numParams :=  1;			// number of parameters
	gPIEAddLineFDesc.numOptParams := 0;			// number of optional parameters
	gPIEAddLineFDesc.paramNames := @gpnMessage;		// pointer to parameter names list
	gPIEAddLineFDesc.paramTypes := @gOneStringTypes;	// pointer to parameters types list
        gPIEAddLineFDesc.version := FUNCTION_PIE_VERSION;
        gPIEAddLineFDesc.functionFlags := CurrentfunctionFlags;
        gPIEAddLineFDesc.category := category;
        gPIEAddLineFDesc.neededProject := neededProject;

       	gPIEAddLineDesc.name  := PChar(ModelPrefix +'ProgressBarAddLine');		// name of PIE
	gPIEAddLineDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEAddLineDesc.descriptor := @gPIEAddLineFDesc;	// pointer to descriptor
        gPIEAddLineDesc.version := ANE_PIE_VERSION;
        gPIEAddLineDesc.vendor := vendor;
        gPIEAddLineDesc.product := product;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAddLineDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIESaveFDesc.name := PChar(ModelPrefix + 'ProgressBarSaveToFile');	        // name of function
	gPIESaveFDesc.address := GPIESaveMMFun;		// function address
	gPIESaveFDesc.returnType := kPIEInteger;		// return value type
	gPIESaveFDesc.numParams :=  1;			// number of parameters
	gPIESaveFDesc.numOptParams := 0;			// number of optional parameters
	gPIESaveFDesc.paramNames := @gpnFileName;		// pointer to parameter names list
	gPIESaveFDesc.paramTypes := @gOneStringTypes;	// pointer to parameters types list
        gPIESaveFDesc.version := FUNCTION_PIE_VERSION;
        gPIESaveFDesc.functionFlags := CurrentfunctionFlags;
        gPIESaveFDesc.category := category;
        gPIESaveFDesc.neededProject := neededProject;

       	gPIESaveDesc.name  := PChar(ModelPrefix + 'ProgressBarSaveToFile');		// name of PIE
	gPIESaveDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIESaveDesc.descriptor := @gPIESaveFDesc;	// pointer to descriptor
        gPIESaveDesc.version := ANE_PIE_VERSION;
        gPIESaveDesc.vendor := vendor;
        gPIESaveDesc.product := product;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESaveDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIECheckVersionFDesc.name := PChar(ModelPrefix + 'ProgressBarCheckVersion');	        // name of function
	gPIECheckVersionFDesc.address := GPIECheckVersionMMFun;		// function address
	gPIECheckVersionFDesc.returnType := kPIEBoolean;		// return value type
	gPIECheckVersionFDesc.numParams :=  4;			// number of parameters
	gPIECheckVersionFDesc.numOptParams := 0;			// number of optional parameters
	gPIECheckVersionFDesc.paramNames := @gpnFourDigit;		// pointer to parameter names list
	gPIECheckVersionFDesc.paramTypes := @gFourIntegerTypes;	// pointer to parameters types list
        gPIECheckVersionFDesc.version := FUNCTION_PIE_VERSION;
        gPIECheckVersionFDesc.functionFlags := CurrentfunctionFlags;
        gPIECheckVersionFDesc.category := category;
        gPIECheckVersionFDesc.neededProject := neededProject;

       	gPIECheckVersionDesc.name  := PChar(ModelPrefix + 'ProgressBarCheckVersion');		// name of PIE
	gPIECheckVersionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;	// pointer to descriptor
        gPIECheckVersionDesc.version := ANE_PIE_VERSION;
        gPIECheckVersionDesc.vendor := vendor;
        gPIECheckVersionDesc.product := product;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECheckVersionDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names


	descriptors := @gFunDesc;

end;

end.
