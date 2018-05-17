unit HST3DPorosityLayers;

interface

uses ANE_LayerUnit;

type
TPorosityParam = Class(T_ANE_LayerParam)
    function WriteName : string; override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TPorosityLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

const
  kPorosityUnit = 'Porosity Element Layer';

implementation

class Function TPorosityParam.ANE_ParamName : string ;
begin
  result := kPorosityUnit;
end;

function TPorosityParam.WriteName : string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.ANE_LayerName + ParentLayer.WriteIndex;
end;

function TPorosityParam.Value : string;
begin
  result := '0.2';
end;

constructor TPorosityLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
  TPorosityParam.Create(ParamList, -1);
end;

class Function TPorosityLayer.ANE_LayerName : string ;
begin
  result := kPorosityUnit;
end;

end.
