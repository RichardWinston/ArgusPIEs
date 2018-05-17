unit HST3DThermCondLayers;

interface

uses ANE_LayerUnit;

type
TXCondParam = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TYCondParam = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TZCondParam = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TThermCondLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

const
  kThermX : string = 'X Conductivity';
  kThermY : string = 'Y Conductivity';
  kThermZ : string = 'Z Conductivity';
  kThermLayer : string = 'Thermal Conductivity Element Layer';

implementation

uses HST3DGeneralParameters, HST3DUnit;

class Function TXCondParam.ANE_ParamName : string ;
begin
  result := kThermX;
end;

function TXCondParam.Units : string;
begin
  result := 'W/m-degC or BTU/ft-h-degF';
end;

class Function TYCondParam.ANE_ParamName : string ;
begin
  result := kThermY;
end;

function TYCondParam.Units : string;
begin
  result := 'W/m-degC or BTU/ft-h-degF';
end;

class Function TZCondParam.ANE_ParamName : string ;
begin
  result := kThermZ;
end;

function TZCondParam.Units : string;
begin
  result := 'W/m-degC or BTU/ft-h-degF';
end;

constructor TThermCondLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
  TXCondParam.Create(ParamList, -1);
  TYCondParam.Create(ParamList, -1);
  TZCondParam.Create(ParamList, -1);
end;

class Function TThermCondLayer.ANE_LayerName : string ;
begin
  result := kThermLayer;
end;

end.
