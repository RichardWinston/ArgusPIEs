unit HST3DActiveAreaLayers;

interface

uses ANE_LayerUnit;

type
TActiveAreaParam = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer); override;
    function WriteName : string; override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TActiveAreaLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

const
  kActiveAreaUnit = 'Active Area Element Layer';

implementation

constructor TActiveAreaParam.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
//  Name := kActiveAreaUnit;
  ValueType := pvBoolean;
end;

class Function TActiveAreaParam.ANE_ParamName : string ;
begin
  result := kActiveAreaUnit;
end;

function TActiveAreaParam.WriteName : string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.ANE_LayerName + ParentLayer.WriteIndex;
end;

function TActiveAreaParam.Value : string;
begin
  result :='$N/A';
end;

//-------------------------------------------------------------------------

constructor TActiveAreaLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  TActiveAreaParam.Create(ParamList, -1);
end;

class Function TActiveAreaLayer.ANE_LayerName : string ;
begin
  result := kActiveAreaUnit;
end;

end.
