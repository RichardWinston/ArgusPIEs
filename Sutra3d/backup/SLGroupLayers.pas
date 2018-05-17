unit SLGroupLayers;

interface

uses ANE_LayerUnit, SLCustomLayers;

type
  TSutraModelGroupLayer = class(TSutraGroupLayer)
    class function ANE_LayerName: string; override;
  end;

  TSutraHydrogeologyGroupLayer = class(TSutraGroupLayer)
    class function ANE_LayerName: string; override;
    class function WriteNewRoot: string; override;
  end;

  TTypedSutraModelGroupLayer = class(TSutraModelGroupLayer)
    function WriteIndex: string; override;
    function WriteOldIndex: string; override;
  end;

  TSutraHydroSourcesGroupLayer = class(TTypedSutraModelGroupLayer)
    class function ANE_LayerName: string; override;
    class function WriteNewRoot: string; override;
  end;

  TSutraTopGroupLayer = class(TTypedSutraModelGroupLayer)
    class function ANE_LayerName: string; override;
  end;

  TSutraHydroBoundariesGroupLayer = class(TSutraHydroSourcesGroupLayer)
    class function ANE_LayerName: string; override;
  end;

  TSutraObservationsGroupLayer = class(TSutraHydroSourcesGroupLayer)
    class function ANE_LayerName: string; override;
  end;

  TSutraInitialConditionsGroupLayer = class(TSutraGroupLayer)
    class function ANE_LayerName: string; override;
    class function WriteNewRoot: string; override;
  end;

  TSutraMapPointGroupLayer = class(TSutraGroupLayer)
    class function ANE_LayerName: string; override;
  end;

  TSutraUnitGroupLayer = class(TSutraGroupLayer)
    class function ANE_LayerName: string; override;
    class function UpperLowerName: string;
  end;

  TBottomGroupLayer = class(TSutraGroupLayer)
    class function ANE_LayerName: string; override;
  end;

  T3DObjectsGroupLayer = class(TSutraGroupLayer)
    class function ANE_LayerName: string; override;
  end;

implementation

uses frmSutraUnit;

resourcestring
  kSUTRAModel = 'SUTRA MODEL';
  kHydrogeology = 'Hydrogeology';
  kHydrologicSources = 'Hydrologic Sources';
  kHydrologicBoundaries = 'Hydrologic Boundaries';
  kInitialConditions = 'Initial Conditions';
  kMapPoint = 'Map or Point Data';
  //  kNodeSurface = 'Surface';
  kNodeSurface = 'UNIT';
  kUpperLowerUnit = 'Unit';
  kObservationLayers = 'Observation Layers';
  k3DObjects = ': 3D objects';
  kTOP = 'TOP';
  k3dObjectsGroup = '3D OBJECTS';
  kBottom = 'BOTTOM UNIT';

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

class function TSutraHydrogeologyGroupLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;
{ TSutraHydroSourcesGroupLayer }

class function TSutraHydroSourcesGroupLayer.ANE_LayerName: string;
begin
  result := kHydrologicSources;
end;

class function TSutraHydroSourcesGroupLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if (frmSutra = nil) or frmSutra.Is3D then
  begin
    result := result + k3DObjects;
  end;
end;

{ TSutraHydroBoundariesGroupLayer }

class function TSutraHydroBoundariesGroupLayer.ANE_LayerName: string;
begin
  result := kHydrologicBoundaries;
end;

{class function TSutraHydroBoundariesGroupLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if (frmSutra = nil) or frmSutra.Is3D then
  begin
    result := result + k3DObjects;
  end;
end;  }

{ TSutraInitialConditionsGroupLayer }

class function TSutraInitialConditionsGroupLayer.ANE_LayerName: string;
begin
  result := kInitialConditions;
end;

class function TSutraInitialConditionsGroupLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;
{ TSutraMapPointGroupLayer }

class function TSutraMapPointGroupLayer.ANE_LayerName: string;
begin
  result := kMapPoint;
end;

{ TSutraUnitGroupLayer }

class function TSutraUnitGroupLayer.ANE_LayerName: string;
begin
  result := kNodeSurface;
end;

class function TSutraUnitGroupLayer.UpperLowerName: string;
begin
  result := kUpperLowerUnit;
end;

{ TTypedSutraModelGroupLayer }

function TTypedSutraModelGroupLayer.WriteIndex: string;
begin
  result := '';
end;

function TTypedSutraModelGroupLayer.WriteOldIndex: string;
begin
  result := WriteIndex;
end;

{ TSutraObservationsGroupLayer }

class function TSutraObservationsGroupLayer.ANE_LayerName: string;
begin
  result := kObservationLayers;
end;

{class function TSutraObservationsGroupLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if (frmSutra = nil) or frmSutra.Is3D then
  begin
    result := result + k3DObjects;
  end;
end;  }

{ TBottomHydroSourcesGroupLayer }

{class function TBottomHydroSourcesGroupLayer.ANE_LayerName: string;
begin
  result := WritePrefix + TSutraHydroSourcesGroupLayer.ANE_LayerName;
end;

class function TBottomHydroSourcesGroupLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if (frmSutra = nil) or frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;

class function TBottomHydroSourcesGroupLayer.WritePrefix: string;
begin
  result := 'Bottom ';
end;   }

{ TTopHydroSourcesGroupSourcesLayer }

{class function TTopHydroSourcesGroupSourcesLayer.WritePrefix: string;
begin
  result := 'Top ';
end; }

{ TBottomHydroBoundariesGroupLayer }

{class function TBottomHydroBoundariesGroupLayer.ANE_LayerName: string;
begin
  result := WritePrefix + TSutraHydroBoundariesGroupLayer.ANE_LayerName;
end;

class function TBottomHydroBoundariesGroupLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if (frmSutra = nil) or frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;

class function TBottomHydroBoundariesGroupLayer.WritePrefix: string;
begin
  result := 'Bottom ';
end;  }

{ TTopHydroBoundariesGroupLayer }

{class function TTopHydroBoundariesGroupLayer.WritePrefix: string;
begin
  result := 'Top ';
end;   }

{ TBottomObservationsGroupLayer }

{class function TBottomObservationsGroupLayer.ANE_LayerName: string;
begin
  result := WritePrefix + TSutraObservationsGroupLayer.ANE_LayerName;
end;

class function TBottomObservationsGroupLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if (frmSutra = nil) or frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;

class function TBottomObservationsGroupLayer.WritePrefix: string;
begin
  result := 'Bottom ';
end;   }

{ TTopObservationsGroupLayer }

{class function TTopObservationsGroupLayer.WritePrefix: string;
begin
  result := 'Top ';
end;  }

{ TSutraTopGroupLayer }

class function TSutraTopGroupLayer.ANE_LayerName: string;
begin
  result := kTOP;
end;

{ T3DObjectsGroupLayer }

class function T3DObjectsGroupLayer.ANE_LayerName: string;
begin
  result := k3dObjectsGroup;
end;

{ TBottomGroupLayer }

class function TBottomGroupLayer.ANE_LayerName: string;
begin
  result := kBottom;
end;

end.

