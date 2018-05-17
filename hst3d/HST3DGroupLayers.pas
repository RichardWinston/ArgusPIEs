unit HST3DGroupLayers;

interface

uses ANE_LayerUnit;

type
TNodeLayer = Class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

TUnitLayer = Class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

type
TMapGroupLayer = Class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

type
TUnindexedGroupLayer = Class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

type
TPostProcessingGroupLayer = Class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

const
  kNodeGroupLayer = 'Node Layer';
  kUnitGroupLayer = 'Element Layer';
  kMapGroupLayer  = 'Map Layers';
  kUnIndexedGroupLayer = 'Unindexed Layers';
  kPostGroupLayer = 'HST3D Output';

implementation

class Function TNodeLayer.ANE_LayerName : string ;
begin
  result := kNodeGroupLayer;
end;

class Function TUnitLayer.ANE_LayerName : string ;
begin
  result := kUnitGroupLayer;
end;

class Function TMapGroupLayer.ANE_LayerName : string ;
begin
  result := kMapGroupLayer;
end;

class Function TUnindexedGroupLayer.ANE_LayerName : string ;
begin
  result := kUnIndexedGroupLayer;
end;

class Function TPostProcessingGroupLayer.ANE_LayerName : string ;
begin
  result := kPostGroupLayer;
end;

end.
