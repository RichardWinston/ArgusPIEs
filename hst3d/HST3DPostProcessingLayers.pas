unit HST3DPostProcessingLayers;

interface

uses ANE_LayerUnit;

type
THST3DPostProcessChartLayer = Class(T_ANE_MapsLayer)
    class Function ANE_LayerName : string ; override;
  end;

THST3DPostProcessDataLayer = Class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
  end;

const
  kDataLayerName = 'HST3D Data';
  kPostChartLayer = 'HST3D PostProcessing Charts';

implementation

class Function THST3DPostProcessChartLayer.ANE_LayerName : string ;
begin
  result := kPostChartLayer;
end;

class Function THST3DPostProcessDataLayer.ANE_LayerName : string ;
begin
  result := kDataLayerName;
end;

end.
