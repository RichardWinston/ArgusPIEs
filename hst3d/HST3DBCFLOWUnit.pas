unit HST3DBCFLOWUnit;

interface

uses ANE_LayerUnit;

type
TBCFLOWZoneNameParam = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TBCFLOWTopElevParam = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TBCFLOWBottomElevParam = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TBCFLOWSpecStateParam = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    class Function ANE_ParamName : string ; override;
  end;

TBCFLOWSpecFluxParam = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    class Function ANE_ParamName : string ; override;
  end;

TBCFLOWLeakageParam = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    class Function ANE_ParamName : string ; override;
  end;

TBCFLOWAqInflParam = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    class Function ANE_ParamName : string ; override;
  end;

TBCFLOWHeatCondParam = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    class Function ANE_ParamName : string ; override;
  end;

TBCFLOWEvapotranspirationParam = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    class Function ANE_ParamName : string ; override;
  end;

TBCFLOWLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;


const
  kBCFLOWZoneName = 'Zone Name';
  kBCFLOWTop = 'Top Elevation';
  kBCFLOWBottom = 'Bottom Elevation';
  kBCFLOWSpecState = 'Sum Specified Value';
  kBCFLOWSpecFlux = 'Sum Specified Flux';
  kBCFLOWLeakage = 'Sum Leakage';
  kBCFLOWAqInfl = 'Sum Aquifer Influence';
  kBCFLOWHeatCond = 'Sum Heat Conduction';
  kBCFLOWEvapotranspiration = 'Sum Evapotranspiration';
  KBCFLOWLayer = 'BCFLOW Zones';

implementation

uses HST3DGridLayer, HST3D_PIE_Unit;

constructor TBCFLOWZoneNameParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvString;
end;

class Function TBCFLOWZoneNameParam.ANE_ParamName : string ;
begin
  result := kBCFLOWZoneName;
end;

function TBCFLOWZoneNameParam.Value : string;
begin
  result := '"Zone Name"';
end;

class Function TBCFLOWTopElevParam.ANE_ParamName : string ;
begin
  result := kBCFLOWTop;
end;

function TBCFLOWTopElevParam.Value : string;
begin
  result :=kGridLayer + '.' + kElevation + '1';
end;

class Function TBCFLOWBottomElevParam.ANE_ParamName : string ;
begin
  result := kBCFLOWBottom;
end;

function TBCFLOWBottomElevParam.Value : string;
begin
  result :=kGridLayer + '.' + kElevation + PIE_Data.HST3DForm.edNumLayers.Text;
end;

constructor TBCFLOWSpecStateParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvBoolean;
end;

class Function TBCFLOWSpecStateParam.ANE_ParamName : string ;
begin
  result := kBCFLOWSpecState;
end;

constructor TBCFLOWSpecFluxParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvBoolean;
end;

class Function TBCFLOWSpecFluxParam.ANE_ParamName : string ;
begin
  result := kBCFLOWSpecFlux;
end;

constructor TBCFLOWLeakageParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvBoolean;
end;

class Function TBCFLOWLeakageParam.ANE_ParamName : string ;
begin
  result := kBCFLOWLeakage;
end;

constructor TBCFLOWAqInflParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvBoolean;
end;

class Function TBCFLOWAqInflParam.ANE_ParamName : string ;
begin
  result := kBCFLOWAqInfl;
end;

constructor TBCFLOWHeatCondParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvBoolean;
end;

class Function TBCFLOWHeatCondParam.ANE_ParamName : string ;
begin
  result := kBCFLOWHeatCond;
end;

constructor TBCFLOWEvapotranspirationParam.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvBoolean;
end;

class Function TBCFLOWEvapotranspirationParam.ANE_ParamName : string ;
begin
  result := kBCFLOWEvapotranspiration;
end;

constructor TBCFLOWLayer.Create(ALayerList : T_ANE_LayerList; Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  ParamList.ParameterOrder.Add(kBCFLOWZoneName);
  ParamList.ParameterOrder.Add(kBCFLOWTop);
  ParamList.ParameterOrder.Add(kBCFLOWBottom);
  ParamList.ParameterOrder.Add(kBCFLOWSpecState);
  ParamList.ParameterOrder.Add(kBCFLOWSpecFlux);
  ParamList.ParameterOrder.Add(kBCFLOWLeakage);
  ParamList.ParameterOrder.Add(kBCFLOWAqInfl);
  ParamList.ParameterOrder.Add(kBCFLOWHeatCond);
  ParamList.ParameterOrder.Add(kBCFLOWEvapotranspiration);
  TBCFLOWZoneNameParam.Create(ParamList, -1);
  TBCFLOWTopElevParam.Create(ParamList, -1);
  TBCFLOWBottomElevParam.Create(ParamList, -1);

  if PIE_Data.HST3DForm.cbBCFLOWUseSpecState.Checked then
  begin
    TBCFLOWSpecStateParam.Create(ParamList, -1);
  end;

  if PIE_Data.HST3DForm.cbBCFLOWUseSpecFlux.Checked then
  begin
    TBCFLOWSpecFluxParam.Create(ParamList, -1);
  end;

  if PIE_Data.HST3DForm.cbBCFLOWUseLeakage.Checked then
  begin
    TBCFLOWLeakageParam.Create(ParamList, -1);
  end;

  if PIE_Data.HST3DForm.cbBCFLOWUseAqInfl.Checked then
  begin
    TBCFLOWAqInflParam.Create(ParamList, -1);
  end;

  if PIE_Data.HST3DForm.cbBCFLOWUseHeatCond.Checked then
  begin
    TBCFLOWHeatCondParam.Create(ParamList, -1);
  end;

  if PIE_Data.HST3DForm.cbBCFLOWUseET.Checked then
  begin
    TBCFLOWEvapotranspirationParam.Create(ParamList, -1);
  end;

end;

class Function TBCFLOWLayer.ANE_LayerName : string ;
begin
  result := KBCFLOWLayer;
end;

end.
