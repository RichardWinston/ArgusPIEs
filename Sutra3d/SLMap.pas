unit SLMap;

interface

uses ANE_LayerUnit;

type
  TSutraMapLayer = class(T_ANE_MapsLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TSutraPostMapLayer = class(T_ANE_MapsLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

implementation

ResourceString
  kMap = 'Map';
  kPost = 'SUTRA Post Processing Charts';

{ TSutraMapLayer }

class function TSutraMapLayer.ANE_LayerName: string;
begin
  result := kMap;
end;

constructor TSutraMapLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Visible := False;
  Lock := StandardLayerLock;
end;

{ TSutraPostMapLayer }

class function TSutraPostMapLayer.ANE_LayerName: string;
begin
  result := kPost;
end;

constructor TSutraPostMapLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Lock := [];
end;

end.
