unit SLObservation;

interface

uses ANE_LayerUnit, SLCustomLayers;

type
  TIsObservedParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
  end;

  TObservationLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class Function WriteNewRoot : string; override;
  end;


implementation

uses frmSutraUnit, SLGroupLayers, SLGeneralParameters;

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

  ParamList.ParameterOrder.Add(TIsObservedParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTopElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TBottomElevaParam.ANE_ParamName);

  TIsObservedParam.Create(ParamList, -1);
  if frmSutra.Is3D then
  begin
    TTopElevaParam.Create(ParamList, -1);
    TBottomElevaParam.Create(ParamList, -1);
  end;


end;

class function TObservationLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraNodeSurfaceGroupLayer.WriteNewRoot;
  end;
end;

end.
