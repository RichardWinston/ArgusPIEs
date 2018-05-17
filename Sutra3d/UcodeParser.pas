unit UcodeParser;

interface

uses Windows, SysUtils, Classes, Contnrs, RbwParser;

procedure AdaptParserForUcode(Parser: TRbwParser);

implementation

uses Math;

var
  OperatorList : TObjectList;
  PowerOperator: TFunctionClass;
  CaretOperator: TFunctionClass;

  AbsFunctionR: TFunctionRecord;
  ArcCosFunction: TFunctionRecord;
  ArcSinFunction: TFunctionRecord;
  ArcTanFunction: TFunctionRecord;
  MaxRFunction: TFunctionRecord;
  MinRFunction: TFunctionRecord;
  ModFunction: TFunctionRecord;

function _Mod(Values: array of pointer): double;
var
  Value1: double;
  Value2: double;
  IntDiv: integer;
begin
  Value1:= PDouble(Values[0])^;
  Value2:= PDouble(Values[1])^;
  IntDiv := Trunc(Value1/Value2);
  result := Value1 - Value2*IntDiv;
end;

function _Power(Values: array of pointer): double;
begin
  result := Power(PDouble(Values[0])^, PDouble(Values[1])^);
end;

procedure DefineDoubleAsterixOperator(Parser: TRbwParser);
var
  ArgumentDef: TOperatorArgumentDefinition;
  OperatorDefinition: TOperatorDefinition;
begin
  OperatorDefinition := TOperatorDefinition.Create;
  OperatorDefinition.OperatorName := '**';
  OperatorDefinition.ArgumentCount := acTwo;
  OperatorDefinition.Precedence := p1;
  OperatorDefinition.SignOperator := False;

  ArgumentDef := TOperatorArgumentDefinition.Create;
  OperatorDefinition.ArgumentDefinitions.Add(ArgumentDef);
  ArgumentDef.FirstArgumentType := rdtDouble;
  ArgumentDef.SecondArgumentType := rdtDouble;
  ArgumentDef.CreationMethod := cmCreate;
  ArgumentDef.FunctionClass := PowerOperator;
  ArgumentDef.OperatorClass := TOperator;

  ArgumentDef := TOperatorArgumentDefinition.Create;
  OperatorDefinition.ArgumentDefinitions.Add(ArgumentDef);
  ArgumentDef.FirstArgumentType := rdtDouble;
  ArgumentDef.SecondArgumentType := rdtInteger;
  ArgumentDef.CreationMethod := cmCreate;
  ArgumentDef.FunctionClass := PowerOperator;
  ArgumentDef.OperatorClass := TOperator;

  ArgumentDef := TOperatorArgumentDefinition.Create;
  OperatorDefinition.ArgumentDefinitions.Add(ArgumentDef);
  ArgumentDef.FirstArgumentType := rdtInteger;
  ArgumentDef.SecondArgumentType := rdtDouble;
  ArgumentDef.CreationMethod := cmCreate;
  ArgumentDef.FunctionClass := PowerOperator;
  ArgumentDef.OperatorClass := TOperator;

  ArgumentDef := TOperatorArgumentDefinition.Create;
  OperatorDefinition.ArgumentDefinitions.Add(ArgumentDef);
  ArgumentDef.FirstArgumentType := rdtInteger;
  ArgumentDef.SecondArgumentType := rdtInteger;
  ArgumentDef.CreationMethod := cmCreate;
  ArgumentDef.FunctionClass := PowerOperator;
  ArgumentDef.OperatorClass := TOperator;

  Parser.AddOperator(OperatorDefinition);
end;

procedure DefineCaretOperator(Parser: TRbwParser);
var
  ArgumentDef: TOperatorArgumentDefinition;
  OperatorDefinition: TOperatorDefinition;
begin
  OperatorDefinition := TOperatorDefinition.Create;
  OperatorDefinition.OperatorName := '^';
  OperatorDefinition.ArgumentCount := acTwo;
  OperatorDefinition.Precedence := p1;
  OperatorDefinition.SignOperator := False;

  ArgumentDef := TOperatorArgumentDefinition.Create;
  OperatorDefinition.ArgumentDefinitions.Add(ArgumentDef);
  ArgumentDef.FirstArgumentType := rdtDouble;
  ArgumentDef.SecondArgumentType := rdtDouble;
  ArgumentDef.CreationMethod := cmCreate;
  ArgumentDef.FunctionClass := CaretOperator;
  ArgumentDef.OperatorClass := TOperator;

  ArgumentDef := TOperatorArgumentDefinition.Create;
  OperatorDefinition.ArgumentDefinitions.Add(ArgumentDef);
  ArgumentDef.FirstArgumentType := rdtDouble;
  ArgumentDef.SecondArgumentType := rdtInteger;
  ArgumentDef.CreationMethod := cmCreate;
  ArgumentDef.FunctionClass := CaretOperator;
  ArgumentDef.OperatorClass := TOperator;

  ArgumentDef := TOperatorArgumentDefinition.Create;
  OperatorDefinition.ArgumentDefinitions.Add(ArgumentDef);
  ArgumentDef.FirstArgumentType := rdtInteger;
  ArgumentDef.SecondArgumentType := rdtDouble;
  ArgumentDef.CreationMethod := cmCreate;
  ArgumentDef.FunctionClass := CaretOperator;
  ArgumentDef.OperatorClass := TOperator;

  ArgumentDef := TOperatorArgumentDefinition.Create;
  OperatorDefinition.ArgumentDefinitions.Add(ArgumentDef);
  ArgumentDef.FirstArgumentType := rdtInteger;
  ArgumentDef.SecondArgumentType := rdtInteger;
  ArgumentDef.CreationMethod := cmCreate;
  ArgumentDef.FunctionClass := CaretOperator;
  ArgumentDef.OperatorClass := TOperator;

  Parser.AddOperator(OperatorDefinition);
end;

function _AbsR(Values: array of pointer): double;
begin
  result := Abs(PDouble(Values[0])^);
end;

procedure AddAbsFunc(Parser: TRbwParser);
begin
  AbsFunctionR.ResultType := rdtDouble;
  AbsFunctionR.Name := 'Abs';
  AbsFunctionR.Prototype := 'Math|Abs(Value)';
  SetLength(AbsFunctionR.InputDataTypes, 1);
  AbsFunctionR.InputDataTypes[0] := rdtDouble;
  AbsFunctionR.OptionalArguments := 0;
  AbsFunctionR.CanConvertToConstant := True;
  AbsFunctionR.RFunctionAddr := _AbsR;

  Parser.Functions.Add(AbsFunctionR);
end;

function _Arccos(Values: array of pointer): double;
begin
  result := ArcCos(PDouble(Values[0])^);
end;

procedure AddAcosFunc(Parser: TRbwParser);
begin
  ArcCosFunction.ResultType := rdtDouble;
  ArcCosFunction.Name := 'ACos';
  ArcCosFunction.Prototype := 'Trig|ACos(Value)';
  SetLength(ArcCosFunction.InputDataTypes, 1);
  ArcCosFunction.InputDataTypes[0] := rdtDouble;
  ArcCosFunction.OptionalArguments := 0;
  ArcCosFunction.CanConvertToConstant := True;
  ArcCosFunction.RFunctionAddr := _arccos;

  Parser.Functions.Add(ArcCosFunction);
end;

function _Arcsin(Values: array of pointer): double;
begin
  result := ArcSin(PDouble(Values[0])^);
end;

procedure AddAsinFunc(Parser: TRbwParser);
begin
  ArcSinFunction.ResultType := rdtDouble;
  ArcSinFunction.Name := 'ASin';
  ArcSinFunction.Prototype := 'Trig|ASin(Value)';
  SetLength(ArcSinFunction.InputDataTypes, 1);
  ArcSinFunction.InputDataTypes[0] := rdtDouble;
  ArcSinFunction.OptionalArguments := 0;
  ArcSinFunction.CanConvertToConstant := True;
  ArcSinFunction.RFunctionAddr := _arcsin;

  Parser.Functions.Add(ArcSinFunction);
end;

function _Arctan(Values: array of pointer): double;
begin
  result := ArcTan(PDouble(Values[0])^);
end;

procedure AddAtanFunc(Parser: TRbwParser);
begin
  ArcTanFunction.ResultType := rdtDouble;
  ArcTanFunction.Name := 'ATan';
  ArcTanFunction.Prototype := 'Trig|ATan(Value)';
  SetLength(ArcTanFunction.InputDataTypes, 1);
  ArcTanFunction.InputDataTypes[0] := rdtDouble;
  ArcTanFunction.OptionalArguments := 0;
  ArcTanFunction.CanConvertToConstant := True;
  ArcTanFunction.RFunctionAddr := _Arctan;

  Parser.Functions.Add(ArcTanFunction);
end;

function _MaxR(Values: array of pointer): double;
var
  Index: integer;
begin
  result := Max(PDouble(Values[0])^, PDouble(Values[1])^);
  for Index := 2 to Length(Values) - 1 do
  begin
    result := Max(result, PDouble(Values[Index])^);
  end;
end;

procedure AddMaxFunc(Parser: TRbwParser);
begin
  MaxRFunction.ResultType := rdtDouble;
  MaxRFunction.Name := 'Max';
  MaxRFunction.Prototype := 'Math|Max(Real_Value1, Real_Value2, ...)';
  SetLength(MaxRFunction.InputDataTypes, 3);
  MaxRFunction.InputDataTypes[0] := rdtDouble;
  MaxRFunction.InputDataTypes[1] := rdtDouble;
  MaxRFunction.InputDataTypes[2] := rdtDouble;
  MaxRFunction.OptionalArguments := -1;
  MaxRFunction.CanConvertToConstant := True;
  MaxRFunction.RFunctionAddr := _maxR;

  Parser.Functions.Add(MaxRFunction);
end;

function _MinR(Values: array of pointer): double;
var
  Index: integer;
begin
  result := Min(PDouble(Values[0])^, PDouble(Values[1])^);
  for Index := 2 to Length(Values) - 1 do
  begin
    result := Min(result, PDouble(Values[Index])^);
  end;
end;

procedure AddMinFunc(Parser: TRbwParser);
begin
  MinRFunction.ResultType := rdtDouble;
  MinRFunction.Name := 'Min';
  MinRFunction.Prototype := 'Math|Min(Real_Value1, Real_Value2, ...)';
  SetLength(MinRFunction.InputDataTypes, 3);
  MinRFunction.InputDataTypes[0] := rdtDouble;
  MinRFunction.InputDataTypes[1] := rdtDouble;
  MinRFunction.InputDataTypes[2] := rdtDouble;
  MinRFunction.OptionalArguments := -1;
  MinRFunction.CanConvertToConstant := True;
  MinRFunction.RFunctionAddr := _minR;

  Parser.Functions.Add(MinRFunction);
end;

procedure AddModFunc(Parser: TRbwParser);
begin
  ModFunction.ResultType := rdtDouble;
  ModFunction.Name := 'Mod';
  ModFunction.Prototype := 'Math|Mod(Numerator, Denominator)';
  SetLength(ModFunction.InputDataTypes, 2);
  ModFunction.InputDataTypes[0] := rdtDouble;
  ModFunction.InputDataTypes[1] := rdtDouble;
  ModFunction.OptionalArguments := 0;
  ModFunction.CanConvertToConstant := True;
  ModFunction.RFunctionAddr := _mod;

  Parser.Functions.Add(ModFunction);
end;

procedure AdaptParserForUcode(Parser: TRbwParser);
var
  Position: integer;
  FunctionToRemove: TStringList;
  Index: integer;
begin
  OverloadedFunctionList.Clear;

  Parser.RemoveOperator('not');
  Parser.RemoveOperator('and');
  Parser.RemoveOperator('or');
  Parser.RemoveOperator('Xor');
  Parser.RemoveOperator('div');
  Parser.RemoveOperator('mod');
  Parser.RemoveOperator('=');
  Parser.RemoveOperator('<>');
  Parser.RemoveOperator('>');
  Parser.RemoveOperator('<');
  Parser.RemoveOperator('>=');
  Parser.RemoveOperator('<=');

  FunctionToRemove := TStringList.Create;
  try
    FunctionToRemove.Add('AbsI');
    FunctionToRemove.Add('AbsR');
    FunctionToRemove.Add('ArcCos');
    FunctionToRemove.Add('ArcCosh');
    FunctionToRemove.Add('ArcSin');
    FunctionToRemove.Add('ArcSinh');
    FunctionToRemove.Add('ArcTan2');
    FunctionToRemove.Add('ArcTanh');
    FunctionToRemove.Add('Copy');
    FunctionToRemove.Add('CaseB');
    FunctionToRemove.Add('CaseI');
    FunctionToRemove.Add('CaseR');
    FunctionToRemove.Add('CaseT');
    FunctionToRemove.Add('DegToRad');
    FunctionToRemove.Add('FactorialI');
    FunctionToRemove.Add('FactorialR');
    FunctionToRemove.Add('Frac');
    FunctionToRemove.Add('FloatToText');
    FunctionToRemove.Add('IfB');
    FunctionToRemove.Add('IfI');
    FunctionToRemove.Add('IfR');
    FunctionToRemove.Add('IfT');
    FunctionToRemove.Add('IntPower');
    FunctionToRemove.Add('IntToText');
    FunctionToRemove.Add('Length');
    FunctionToRemove.Add('logN');
    FunctionToRemove.Add('LowerCase');
    FunctionToRemove.Add('MaxI');
    FunctionToRemove.Add('MaxR');
    FunctionToRemove.Add('MinI');
    FunctionToRemove.Add('MinR');
    FunctionToRemove.Add('Odd');
    FunctionToRemove.Add('Pi');
    FunctionToRemove.Add('Pos');
    FunctionToRemove.Add('Power');
    FunctionToRemove.Add('RadToDeg');
    FunctionToRemove.Add('Round');
    FunctionToRemove.Add('SqrI');
    FunctionToRemove.Add('SqrR');
    FunctionToRemove.Add('TextToInt');
    FunctionToRemove.Add('TextToIntDef');
    FunctionToRemove.Add('TextToFloat');
    FunctionToRemove.Add('TextToFloatDef');
    FunctionToRemove.Add('Trim');
    FunctionToRemove.Add('Trunc');
    FunctionToRemove.Add('UpperCase');
    FunctionToRemove.Add('Interpolate');
    FunctionToRemove.Add('Distance');

    for Index := 0 to FunctionToRemove.Count -1 do
    begin
      Position := Parser.Functions.IndexOf(UpperCase(FunctionToRemove[Index]));
      if Position >= 0 then
      begin
        Parser.Functions.Delete(Position);
      end;
    end;
  finally
    FunctionToRemove.Free;
  end;

  Parser.SpecialImplementorList.Clear;

  AddAbsFunc(Parser);
  AddAcosFunc(Parser);
  AddAsinFunc(Parser);
  AddAtanFunc(Parser);
  AddMaxFunc(Parser);
  AddMinFunc(Parser);
  AddModFunc(Parser);

  DefineDoubleAsterixOperator(Parser);
  DefineCaretOperator(Parser);

end;

procedure InitializeVariables;
begin
  OperatorList := TObjectList.Create;

  PowerOperator := TFunctionClass.Create;
  OperatorList.Add(PowerOperator);
  PowerOperator.InputDataCount := 2;
  PowerOperator.RFunctionAddr := _Power;
  PowerOperator.Name := '**';
  PowerOperator.Prototype := 'Math|**';
  PowerOperator.InputDataTypes[0] := rdtDouble;
  PowerOperator.InputDataTypes[1] := rdtDouble;
  PowerOperator.OptionalArguments := 0;

  CaretOperator := TFunctionClass.Create;
  OperatorList.Add(CaretOperator);
  CaretOperator.InputDataCount := 2;
  CaretOperator.RFunctionAddr := _Power;
  CaretOperator.Name := '^';
  CaretOperator.Prototype := 'Math|^';
  CaretOperator.InputDataTypes[0] := rdtDouble;
  CaretOperator.InputDataTypes[1] := rdtDouble;
  CaretOperator.OptionalArguments := 0;
end;


initialization
  InitializeVariables;

finalization
  OperatorList.Free;

end.
