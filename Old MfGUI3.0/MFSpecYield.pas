unit MFSpecYield;

interface

{MFSpecYield defines the "Specific Yield Unit[i]" layer
 and the associated parameter.}

uses ANE_LayerUnit;

type
  TSpecYieldParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TSpecYieldLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFSpecYield = 'Specific Yield Unit';

class Function TSpecYieldParam.ANE_ParamName : string ;
begin
  result := kMFSpecYield;
end;

function TSpecYieldParam.Value : string;
begin
  result := '0.1';
end;

//---------------------------
constructor TSpecYieldLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leInterpolate;
  Lock := Lock - [llType];
  ModflowTypes.GetMFSpecYieldParamType.Create(ParamList, -1);
end;

class Function TSpecYieldLayer.ANE_LayerName : string ;
begin
  result := kMFSpecYield;
end;

function TSpecYieldLayer.Units : string;
begin
  result := 'L^3/L^3';
end;

end.

