unit MFGroupLayerUnit;

interface

{MFGroupLayerUnit defines the "Geological Unit" and "Post Processing" group
 layers.}

uses ANE_LayerUnit;

type
  TMFGeolUnitGroupLayer = class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TMFPostProcessingGroupLayer = class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TMFHufGroupLayer = class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

implementation

ResourceString
  rsMFGroupLayer = 'Geological Unit';
  rsPostGroup = 'Post Processing';
  rsHUF = 'HUF Layers';

class Function TMFGeolUnitGroupLayer.ANE_LayerName : string ;
begin
  result := rsMFGroupLayer;
end;

{ TMFPostProcessingGroupLayer }

class function TMFPostProcessingGroupLayer.ANE_LayerName: string;
begin
  result := rsPostGroup;
end;

{ TMFHufGroupLayer }

class function TMFHufGroupLayer.ANE_LayerName: string;
begin
  result := rsHUF;
end;

end.
