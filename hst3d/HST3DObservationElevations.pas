unit HST3DObservationElevations;

interface

uses ANE_LayerUnit;

type
TObsElevParam = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

TObsElevParam1 = Class(TObsElevParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

TObsSurfLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

TObsPointsLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

const
  kObservationElev = 'Observation Elevation';
  kObservationSurf = 'Observation Surface';
  kObservationPoints = 'Observation Points';

implementation

class Function TObsElevParam.ANE_ParamName : string ;
begin
  result := kObservationElev;
end;

function TObsElevParam.Value : string;
begin
  result := '0';
end;

function TObsElevParam.Units : string;
begin
  result := 'm or ft';
end;

//-----------------------------

class Function TObsElevParam1.ANE_ParamName : string ;
begin
  result := kObservationElev + '1';
end;

function TObsElevParam1.Value : string;
begin
  result := kNa;
end;

//-----------------------------

constructor TObsSurfLayer.Create(ALayerList : T_ANE_LayerList; Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
  Interp := leInterpolate;
  TObsElevParam.Create(ParamList, -1);
end;

class Function TObsSurfLayer.ANE_LayerName : string ;
begin
  result := kObservationSurf;
end;

function TObsSurfLayer.Units : string;
begin
  result := 'm or ft';
end;

//-----------------------------

constructor TObsPointsLayer.Create(ALayerList : T_ANE_LayerList; Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
  Interp := leInterpolate;
  TObsElevParam1.Create(ParamList, -1);
end;

class Function TObsPointsLayer.ANE_LayerName : string ;
begin
  result := kObservationPoints;
end;

function TObsPointsLayer.Units : string;
begin
  result := 'm or ft';
end;

end.
