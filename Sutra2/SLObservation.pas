unit SLObservation;

interface

uses ANE_LayerUnit;

type
  TIsObservedParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
  end;

  TObservationLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;


implementation

ResourceString
  kIsObserved = 'is_observed';
  kObservation = 'Observation';

{ TIsObservedParam }

class function TIsObservedParam.ANE_ParamName: string;
begin
  result := kIsObserved;
end;

constructor TIsObservedParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TIsObservedParam.Units: string;
begin
  result := 'True or False';
end;

{ TObservationLayer }

class function TObservationLayer.ANE_LayerName: string;
begin
  result := kObservation;
end;

constructor TObservationLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := leExact;
  TIsObservedParam.Create(ParamList, -1);
end;

end.
