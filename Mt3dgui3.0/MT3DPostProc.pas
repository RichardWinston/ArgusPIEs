unit MT3DPostProc;

interface

uses ANE_LayerUnit;

type
TMT3DDataLayer = Class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
  end;

TMT3DPostProcessChartLayer = Class(T_ANE_MapsLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

implementation

const
  kMT3DDataLayerName = 'MT3D Data';
  kMT3DChartLayerName = 'MT3D Post Processing Charts';

class Function TMT3DDataLayer.ANE_LayerName : string ;
begin
  result := kMT3DDataLayerName;
end;

class Function TMT3DPostProcessChartLayer.ANE_LayerName : string ;
begin
  result := kMT3DChartLayerName;
end;

constructor TMT3DPostProcessChartLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Lock := [];
end;

end.
