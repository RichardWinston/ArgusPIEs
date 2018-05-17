unit MFMap;

interface

{MFMap defines the "Maps" layer.}

uses ANE_LayerUnit;

type
  TMFMapLayer = Class(T_ANE_MapsLayer)
    class Function ANE_LayerName : string ; override;
  end;

implementation

ResourceString
  kMap = 'Maps';

class Function TMFMapLayer.ANE_LayerName : string ;
begin
  result := kMap;
end;

end.
