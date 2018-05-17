unit SLSpecificHeat;

interface

uses ANE_LayerUnit, SLCustomLayers;

{$IFDEF SutraIce}
type
  TSpecificHeatParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TSpecificHeatLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    class Function WriteNewRoot : string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;
{$ENDIF}

implementation

{$IFDEF SutraIce}
uses frmSutraUnit, SLGroupLayers;

const
  kSpecificHeat = 'specific heat';
  kSpecificHeatLayer = 'Solid Grain Specific Heat';

{ TSpecificHeatParam }

class function TSpecificHeatParam.ANE_ParamName: string;
begin
  result := kSpecificHeat;
end;

function TSpecificHeatParam.Units: string;
begin
  result := 'E/(M degC)'
end;

function TSpecificHeatParam.Value: string;
begin
  result := '840';
end;

{ TSpecificHeatLayer }

class function TSpecificHeatLayer.ANE_LayerName: string;
begin
  result := kSpecificHeatLayer;
end;

constructor TSpecificHeatLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Add(TSpecificHeatParam.ANE_ParamName);
  TSpecificHeatParam.Create(ParamList, -1);
end;

class function TSpecificHeatLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;
{$ENDIF}

end.
