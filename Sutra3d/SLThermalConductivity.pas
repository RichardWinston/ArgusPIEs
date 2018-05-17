unit SLThermalConductivity;

interface

uses ANE_LayerUnit, AnePIE, SLCustomLayers, SLGeneralParameters;

{$IFDEF SutraIce}
type
  TThermalConductivityParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TThermalConductivityLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot : string; override;
  end;
{$ENDIF}

implementation

{$IFDEF SutraIce}
uses frmSutraUnit, SLGroupLayers;

const
  KThermalConductivity = 'thermal conductivity';
  KThermalConductivityLayer = 'Solid Grain Thermal Conductivity';

{ TThermalConductivityParam }

class function TThermalConductivityParam.ANE_ParamName: string;
begin
  result := KThermalConductivity;
end;

function TThermalConductivityParam.Units: string;
begin
  result := 'E/(s L degC)';
end;

function TThermalConductivityParam.Value: string;
begin
  result := '3.5';
end;

{ TThermalConductivityLayer }

class function TThermalConductivityLayer.ANE_LayerName: string;
begin
  result := KThermalConductivityLayer;
end;

constructor TThermalConductivityLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Add(TThermalConductivityParam.ANE_ParamName);
  TThermalConductivityParam.Create(ParamList, -1);
end;

class function TThermalConductivityLayer.WriteNewRoot: string;
begin
  result := ANE_LayerName;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;
{$ENDIF}

end.
