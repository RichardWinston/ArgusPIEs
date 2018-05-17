unit MT3DPorosityUnit;

interface

uses ANE_LayerUnit;

const
  kMT3DPorosity = 'MT3D Porosity Unit';

type
  TMT3DPorosityParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMT3DPorosityLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

class Function TMT3DPorosityParam.ANE_ParamName : string ;
begin
  result := kMT3DPorosity;
end;

function TMT3DPorosityParam.Value : string;
begin
  result := '0.2';
end;
//---------------------------
constructor TMT3DPorosityLayer.Create(ALayerList : T_ANE_LayerList; Index: Integer) ;
begin
  inherited ;//Create(Index, ALayerList);
  Interp := leExact;
  ModflowTypes.GetMT3DPorosityParamClassType.Create(ParamList, -1);
end;

class Function TMT3DPorosityLayer.ANE_LayerName : string ;
begin
  result := kMT3DPorosity;
end;

function TMT3DPorosityLayer.Units : string;
begin
  result := 'L^3/L^3';
end;

end.
