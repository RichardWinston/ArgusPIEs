unit MFPostProc;

interface

{MFPostProc defines the "MODFLOW Data", "MOC3D Data",
 "MODFLOW Post Processing Charts", and "MOC3D Post Processing Charts" layers.}

uses SysUtils, ANE_LayerUnit;

type
TMFPostProcessChartLayer = Class(T_ANE_MapsLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

TMocPostProcessChartLayer = Class(T_ANE_MapsLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

TMT3DPostProcessChartLayer = Class(T_ANE_MapsLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList;
      Index: Integer = -1); override;
  end;


TMFPostProcessDataLayer = Class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
  end;

TMOCPostProcessDataLayer = Class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
    class function WriteNewRoot: string; override;
  end;

TMT3DPostProcessDataLayer = Class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
  end;


implementation

uses Variables;

ResourceString
  kDataLayerName = 'MODFLOW Data';
  kMOCDataLayerName = 'MOC3D Data';
  kMT3DDataLayerName = 'MT3DMS Data';
  kPostChartLayer = 'MODFLOW Post Processing Charts';
  kMOCPostChartLayer = 'MOC3D Post Processing Charts';
  kMT3DPostChartLayer = 'MT3DMS Post Processing Charts';
  kGWTDataLayerName = 'GWT Data';
  kGWTPostChartLayer = 'GWT Post Processing Charts';

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

class function TMocPostProcessChartLayer.WriteNewRoot: string;
begin
  if frmModflow.rbMODFLOW2000.Checked or frmModflow.rbModflow2005.Checked then
  begin
    result := kGWTPostChartLayer;
  end
  else
  begin
    result := inherited WriteNewRoot;
  end;
end;

class function TMOCPostProcessDataLayer.WriteNewRoot: string;
begin
  if frmModflow.rbMODFLOW2000.Checked or frmModflow.rbModflow2005.Checked then
  begin
    result := kGWTDataLayerName;
  end
  else
  begin
    result := inherited WriteNewRoot;
  end;
end;

{ TMT3DPostProcessDataLayer }

class function TMT3DPostProcessDataLayer.ANE_LayerName: string;
begin
  result := kMT3DDataLayerName;
end;

{ TMT3DPostProcessChartLayer }

class function TMT3DPostProcessChartLayer.ANE_LayerName: string;
begin
  result := kMT3DPostChartLayer
end;

constructor TMT3DPostProcessChartLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Lock := [];
end;

end.
