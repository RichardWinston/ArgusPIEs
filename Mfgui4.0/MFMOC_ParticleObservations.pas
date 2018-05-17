unit MFMOC_ParticleObservations;

interface

uses ANE_LayerUnit, OptionsUnit;

type
  TMoc3dParticleObsParam = class(T_ANE_LayerParam)
  public
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMoc3dParticleObsLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

implementation

uses Variables;

Resourcestring
  rsObservation = 'Observation';
  rsGwtParticleObservations = 'GWT Particle Observation Unit';

{ TMoc3dParticleObsParam }

class function TMoc3dParticleObsParam.ANE_ParamName: string;
begin
  result := rsObservation;
end;

constructor TMoc3dParticleObsParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
  Lock := Lock + [plDont_Override, plDef_Val];
end;

function TMoc3dParticleObsParam.Units: string;
begin
  result := 'no value required';
end;

function TMoc3dParticleObsParam.Value: string;
begin
  result := 'If(ContourArea()>0, 1,0)'
end;

{ TMoc3dParticleObsLayer }

class function TMoc3dParticleObsLayer.ANE_LayerName: string;
begin
  result := rsGwtParticleObservations;
end;

constructor TMoc3dParticleObsLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := leExact;
  Lock := Lock + [llEvalAlg];

  ModflowTypes.GetMFMoc3dParticleObsParamType.Create(ParamList);

end;

end.
