unit SLGroupLayers;

interface

uses ANE_LayerUnit, SLCustomLayers;

type
  TSutraModelGroupLayer = class(TSutraGroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TSutraHydrogeologyGroupLayer = class(TSutraGroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TSutraHydroSourcesGroupLayer = class(TSutraGroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TSutraHydroBoundariesGroupLayer = class(TSutraGroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TSutraInitialConditionsGroupLayer = class(TSutraGroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TSutraMapPointGroupLayer = class(TSutraGroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TSutraNodeSurfaceGroupLayer = class(TSutraGroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

implementation

ResourceString
  kSUTRAModel = 'SUTRA Model';
  kHydrogeology = 'Hydrogeology';
  kHydrologicSources = 'Hydrologic Sources';
  kHydrologicBoundaries = 'Hydrologic Boundaries';
  kInitialConditions = 'Initial Conditions';
  kMapPoint = 'Map or Point Data';
  kNodeSurface = 'Surface';

{ TSutraModelGroupLayer }

class function TSutraModelGroupLayer.ANE_LayerName: string;
begin
  result := kSUTRAModel;
end;

{ TSutraHydrogeologyGroupLayer }

class function TSutraHydrogeologyGroupLayer.ANE_LayerName: string;
begin
  result := kHydrogeology;
end;

{ TSutraHydroSourcesGroupLayer }

class function TSutraHydroSourcesGroupLayer.ANE_LayerName: string;
begin
  result := kHydrologicSources;
end;

{ TSutraHydroBoundariesGroupLayer }

class function TSutraHydroBoundariesGroupLayer.ANE_LayerName: string;
begin
  result := kHydrologicBoundaries;
end;

{ TSutraInitialConditionsGroupLayer }

class function TSutraInitialConditionsGroupLayer.ANE_LayerName: string;
begin
  result := kInitialConditions;
end;

{ TSutraMapPointGroupLayer }

class function TSutraMapPointGroupLayer.ANE_LayerName: string;
begin
  result := kMapPoint;
end;

{ TSutraNodeSurfaceGroupLayer }

class function TSutraNodeSurfaceGroupLayer.ANE_LayerName: string;
begin
  result := kNodeSurface;
end;

end.
