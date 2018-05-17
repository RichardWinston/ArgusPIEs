unit EvalAtFunctionUnit;

interface

uses Sysutils, Classes, Dialogs,

  AnePIE, FunctionPie;

procedure GPIEEvalRealAtXYMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEEvalBoolAtXYMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEEvalIntAtXYMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEEvalStringAtXYMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
        gPIEEvalRealDesc     : ANEPIEDesc;
        gPIEEvalRealFuncDesc :  FunctionPIEDesc;

        gPIEEvalIntDesc     : ANEPIEDesc;
        gPIEEvalIntFuncDesc :  FunctionPIEDesc;

        gPIEEvalBoolDesc     : ANEPIEDesc;
        gPIEEvalBoolFuncDesc :  FunctionPIEDesc;

        gPIEEvalStringDesc     : ANEPIEDesc;
        gPIEEvalStringFuncDesc :  FunctionPIEDesc;

const   gpnXYExpressionLayer : array [0..4] of PChar = ('X', 'Y', '"Expression_As_Quoted_String"',
  '"Layer_Name_As_Quoted_String"', nil);
const   g2Float2StringTypes : array [0..4] of EPIENumberType = (kPIEFloat,
  kPIEFloat, kPIEString, kPIEString, 0);


implementation

uses ANECB, OptionsUnit, CheckPIEVersionFunction, ParamArrayUnit;

procedure GetParam(const parameters : ANE_PTR_PTR ;
  var X_ptr, Y_ptr : ANE_DOUBLE_PTR; var LayerHandle : ANE_PTR;
  var Expression : ANE_STR; numParams : ANE_INT16; myHandle : ANE_PTR   );
var
  param : PParameter_array;
//  Expression : ANE_STR;
  LayerName : ANE_STR;
begin
    param := @parameters^;
    X_ptr :=  param^[0];
    Y_ptr :=  param^[1];
    Expression := param^[2];

    LayerHandle := ANE_LayerGetCurrent(myHandle);
    if numParams > 3 then
    begin
      LayerName :=  param^[3];
      LayerHandle := ANE_LayerGetHandleByName(myHandle,LayerName);
    end;
end;

procedure GPIEEvalRealAtXYMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  X_ptr, Y_ptr : ANE_DOUBLE_PTR;
  result : ANE_DOUBLE;
  Expression : ANE_STR;
  ParsedExpression : ANE_PTR;
  LayerHandle : ANE_PTR;
begin
  result := 0;
  try // try 1
    GetParam(parameters, X_ptr, Y_ptr, LayerHandle, Expression, numParams,
      myHandle);

    ParsedExpression := ANE_ParseExpression(myHandle, LayerHandle,
      kPIEFloat, Expression);

    ANE_EvaluateParsedExpressionAtPos(myHandle, ParsedExpression, X_ptr,
      Y_ptr, @result);

    ANE_FreeParsedExpression(myHandle, ParsedExpression);

    ANE_DOUBLE_PTR(reply)^ := result;
  except on E: Exception do  // try 1
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      Result := 0;
      ANE_DOUBLE_PTR(reply)^ := result;
    end;
  end;  // try 1
end;


procedure GPIEEvalIntAtXYMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  X_ptr, Y_ptr : ANE_DOUBLE_PTR;
  result : ANE_INT32;
  Expression : ANE_STR;
  ParsedExpression : ANE_PTR;
  LayerHandle : ANE_PTR;
begin
  result := 0;
  try // try 1
    GetParam(parameters, X_ptr, Y_ptr, LayerHandle, Expression, numParams,
      myHandle);

    ParsedExpression := ANE_ParseExpression(myHandle, LayerHandle,
      kPIEInteger, Expression);

    ANE_EvaluateParsedExpressionAtPos(myHandle, ParsedExpression, X_ptr,
      Y_ptr, @result);

    ANE_FreeParsedExpression(myHandle, ParsedExpression);

    ANE_INT32_PTR(reply)^ := result;
  except on E: Exception do  // try 1
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      ANE_INT32_PTR(reply)^ := result;
    end;
  end;  // try 1
end;


procedure GPIEEvalBoolAtXYMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  X_ptr, Y_ptr : ANE_DOUBLE_PTR;
  result : ANE_BOOL;
  Expression : ANE_STR;
  ParsedExpression : ANE_PTR;
  LayerHandle : ANE_PTR;
begin
  result := False;
  try // try 1
    GetParam(parameters, X_ptr, Y_ptr, LayerHandle, Expression, numParams,
      myHandle);

    ParsedExpression := ANE_ParseExpression(myHandle, LayerHandle,
      kPIEBoolean, Expression);

    ANE_EvaluateParsedExpressionAtPos(myHandle, ParsedExpression, X_ptr,
      Y_ptr, @result);

    ANE_FreeParsedExpression(myHandle, ParsedExpression);

    ANE_BOOL_PTR(reply)^ := result;
  except on E: Exception do  // try 1
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      ANE_BOOL_PTR(reply)^ := result;
    end;
  end;  // try 1
end;


procedure GPIEEvalStringAtXYMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  X_ptr, Y_ptr : ANE_DOUBLE_PTR;
  result : ANE_STR;
  Expression : ANE_STR;
  ParsedExpression : ANE_PTR;
  LayerHandle : ANE_PTR;
begin
  result := '';
  try // try 1
    GetParam(parameters, X_ptr, Y_ptr, LayerHandle, Expression, numParams,
      myHandle);

    ParsedExpression := ANE_ParseExpression(myHandle, LayerHandle,
      kPIEString, Expression);

    ANE_EvaluateParsedExpressionAtPos(myHandle, ParsedExpression, X_ptr,
      Y_ptr, @result);

    ANE_FreeParsedExpression(myHandle, ParsedExpression);

    ANE_STR_PTR(reply)^ := result;
  except on E: Exception do  // try 1
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      ANE_STR_PTR(reply)^ := result;
    end;
  end;  // try 1
end;


end.
