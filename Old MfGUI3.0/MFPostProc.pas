unit MFPostProc;

interface

{MFPostProc defines the "MODFLOW Data", "MOC3D Data",
 "MODFLOW Post Processing Charts", and "MOC3D Post Processing Charts" layers.}

uses SysUtils, ANE_LayerUnit;

type
TMFPostProcessChartLayer = Class(T_ANE_MapsLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

TMocPostProcessChartLayer = Class(T_ANE_MapsLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

TMFPostProcessDataLayer = Class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
  end;

TMOCPostProcessDataLayer = Class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
  end;

implementation

ResourceString
  kDataLayerName = 'MODFLOW Data';
  kMOCDataLayerName = 'MOC3D Data';
  kPostChartLayer = 'MODFLOW Post Processing Charts';
  kMOCPostChartLayer = 'MOC3D Post Processing Charts';

class Function TMFPostProcessChartLayer.ANE_LayerName : string ;
begin
  result := kPostChartLayer;
end;

class Function TMocPostProcessChartLayer.ANE_LayerName : string ;
begin
  result := kMOCPostChartLayer;
end;

class Function TMFPostProcessDataLayer.ANE_LayerName : string ;
begin
  result := kDataLayerName;
end;

class Function TMOCPostProcessDataLayer.ANE_LayerName : string ;
begin
  result := kMOCDataLayerName;
end;


constructor TMFPostProcessChartLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Lock := [];
end;

constructor TMocPostProcessChartLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Lock := [];
end;

end.
 