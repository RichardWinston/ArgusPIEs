unit SutraGroupLayers;

interface

uses ANE_LayerUnit;

type
  TSutraModelGroupLayer = class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TSutraHydrogeologyGroupLayer = class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TSutraHydroSourcesGroupLayer = class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TSutraHydroBoundariesGroupLayer = class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TSutraInitialConditionsGroupLayer = class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TSutraMapPointGroupLayer = class(T_ANE_GroupLayer)
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

end.
