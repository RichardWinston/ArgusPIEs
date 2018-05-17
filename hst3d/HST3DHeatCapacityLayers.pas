unit HST3DHeatCapacityLayers;

interface

uses ANE_LayerUnit;

type
THeatCapParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function WriteName : string; override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

THeatCapLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

const
  kHeatCap : string = 'Heat Capacity Element Layer';

implementation

uses HST3D_PIE_Unit;

{ THeatCapParam }
class Function THeatCapParam.ANE_ParamName : string ;
begin
  result := kHeatCap;
end;

function THeatCapParam.Units : string;
begin
  result := 'J/m^3-C or BTU/ft^3-F';
end;

function THeatCapParam.WriteName : string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.ANE_LayerName + ParentLayer.WriteIndex;
end;

function THeatCapParam.Value : string;
begin
  if PIE_Data.HST3DForm.rgUnits.ItemIndex = 0
  then
    begin
      result := '800 * 2800';
    end
  else
    begin
      result := '0.19107672 * 174.798316';
    end;
end;

{constructor THeatCapParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 'J/m^3-C or BTU/ft^3-F';
end;}

{ THeatCapLayer }
constructor THeatCapLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
//  Units := 'J/kg-C or BTU/lb-F';
  THeatCapParam.Create(ParamList, -1);
end;

function THeatCapLayer.Units : string;
begin
  result := 'J/kg-C or BTU/lb-F';
end;

class Function THeatCapLayer.ANE_LayerName : string ;
begin
  result := kHeatCap;
end;

end.
