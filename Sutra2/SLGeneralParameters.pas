unit SLGeneralParameters;

interface

uses ANE_LayerUnit;

type
  TTimeDependanceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

implementation

ResourceString
  kTimeDependence = 'time_dependence';

{ TTimeDependanceParam }

class function TTimeDependanceParam.ANE_ParamName: string;
begin
  result := kTimeDependence;
end;

constructor TTimeDependanceParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

end.
