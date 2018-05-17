unit MT3DBulkDensity;

interface

uses ANE_LayerUnit, MFGenParam;

type
  TMT3DBulkDensityParam = class(TCustomParentUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMT3DBulkDensityLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

resourcestring
  rsBulkDensity = 'Bulk Density';
  rsBulkDensityUnit = 'MT3D Bulk Density Unit';

{ TMT3DBulkDensityParam }

class function TMT3DBulkDensityParam.ANE_ParamName: string;
begin
  result := rsBulkDensity
end;

function TMT3DBulkDensityParam.Value: string;
begin
  result := '0.0016';
end;

{ TMT3DBulkDensityLayer }

class function TMT3DBulkDensityLayer.ANE_LayerName: string;
begin
  result := rsBulkDensityUnit
end;

constructor TMT3DBulkDensityLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ModflowTypes.GetMT3DBulkDensityParamClassType.Create(ParamList, -1);
end;

function TMT3DBulkDensityLayer.Units: string;
begin
  result := MT3DMassUnit + '/' + LengthUnit + '^3';
end;

end.
