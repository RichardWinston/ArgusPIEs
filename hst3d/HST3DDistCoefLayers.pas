unit HST3DDistCoefLayers;

interface

uses ANE_LayerUnit;

type
TDistCoefLayerParam = Class(T_ANE_LayerParam)
    function WriteName : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TDistCoefLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

const
  KDistCoef : string = 'Distribution Coefficient Element Layer';

implementation

class Function TDistCoefLayerParam.ANE_ParamName : string ;
begin
  result := KDistCoef;
end;

function TDistCoefLayerParam.WriteName : string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.ANE_LayerName + ParentLayer.WriteIndex;
end;

constructor TDistCoefLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
  TDistCoefLayerParam.Create(ParamList, -1);
end;

class Function TDistCoefLayer.ANE_LayerName : string ;
begin
  result := KDistCoef;
end;

end.
