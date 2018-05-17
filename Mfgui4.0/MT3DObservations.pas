unit MT3DObservations;

interface

uses ANE_LayerUnit;

const
  kMT3DObservations = 'MT3D Observations Unit';

type
  TMT3DObservationsParam = class(T_ANE_ParentIndexLayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer);
      override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMT3DObservationsLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

constructor TMT3DObservationsParam.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

class Function TMT3DObservationsParam.ANE_ParamName : string ;
begin
  result := kMT3DObservations;
end;

function TMT3DObservationsParam.Value : string;
begin
  result := kNA;
end;
//---------------------------
constructor TMT3DObservationsLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  Lock := Lock + [llType];
  ModflowTypes.GetMT3DObservationsParamClassType.Create(ParamList, -1);
end;

class Function TMT3DObservationsLayer.ANE_LayerName : string ;
begin
  result := kMT3DObservations;
end;

function TMT3DObservationsLayer.Units : string;
begin
  result := '';
end;

end.
 