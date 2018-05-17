unit MFMOCParticleRegen;

interface

{MFMOCParticleRegen defines the "Particle Regeneration Unit[i]" layer
 and associated parameter.}

uses ANE_LayerUnit;

type
  TMOCParticleRegenParam = class(T_ANE_ParentIndexLayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
  end;

  TMOCParticleRegenLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFMOCParticleRegen = 'Particle Regeneration Unit';

constructor TMOCParticleRegenParam.Create(AParameterList : T_ANE_ParameterList;
                Index : Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TMOCParticleRegenParam.ANE_ParamName : string ;
begin
  result := kMFMOCParticleRegen;
end;

//---------------------------
constructor TMOCParticleRegenLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  ModflowTypes.GetMFMOCParticleRegenParamType.Create(ParamList, -1);
end;

class Function TMOCParticleRegenLayer.ANE_LayerName : string ;
begin
  result := kMFMOCParticleRegen;
end;

function TMOCParticleRegenLayer.Units : string;
begin
  result := '0 or 1';
end;

end.
