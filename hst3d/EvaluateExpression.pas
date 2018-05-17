unit EvaluateExpression;

interface

uses AnePIE;

function EvalFloat(StringToEvaluate : string; aneHandle : ANE_PTR;
  LayerHandle : ANE_PTR) : ANE_DOUBLE;

function EvalInteger(StringToEvaluate : string; aneHandle : ANE_PTR;
  LayerHandle : ANE_PTR) : ANE_INT32;

function EvalBoolean(StringToEvaluate : string; aneHandle : ANE_PTR;
  LayerHandle : ANE_PTR) : ANE_BOOL;

function EvalString(StringToEvaluate : string; aneHandle : ANE_PTR;
  LayerHandle : ANE_PTR) : string;

implementation

uses ANECB;

function EvalFloat(StringToEvaluate : string; aneHandle : ANE_PTR;
  LayerHandle : ANE_PTR) : ANE_DOUBLE;
begin
  ANE_EvaluateStringAtLayer(aneHandle, LayerHandle,
      kPIEFloat, PChar(StringToEvaluate), @result);
end;

function EvalInteger(StringToEvaluate : string; aneHandle : ANE_PTR;
  LayerHandle : ANE_PTR) : ANE_INT32;
begin
  ANE_EvaluateStringAtLayer(aneHandle, LayerHandle,
      kPIEInteger, PChar(StringToEvaluate), @result);
end;

function EvalBoolean(StringToEvaluate : string; aneHandle : ANE_PTR;
  LayerHandle : ANE_PTR) : ANE_BOOL;
begin
  ANE_EvaluateStringAtLayer(aneHandle, LayerHandle,
      kPIEBoolean, PChar(StringToEvaluate), @result);
end;

function EvalString(StringToEvaluate : string; aneHandle : ANE_PTR;
  LayerHandle : ANE_PTR) : string;
var
  APChar : ANE_STR;
begin
  ANE_EvaluateStringAtLayer(aneHandle, LayerHandle,
      kPIEString, PChar(StringToEvaluate), @APChar);

  result := string(APChar)
end;


end.
