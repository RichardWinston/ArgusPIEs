unit MFHorFlowBarrier;

interface

{MFHorFlowBarrier defines the "Horizontal Flow Barrier Unit[i]" layer
 and associated parameters.}

uses ANE_LayerUnit, SysUtils;

type
  THFBHydCondParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  public
    function Value: string; override;
  end;

  THFBBarrierThickParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  public
    function Value: string; override;
  end;

  THFBLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFHFBHydCond = 'Barrier Hydraulic Conductivity';
  kMFHFBBarrierThick = 'Barrier Thickness';
  kMFHFBLayer = 'Horizontal Flow Barrier Unit';

class Function THFBHydCondParam.ANE_ParamName : string ;
begin
  result := kMFHFBHydCond;
end;

function THFBHydCondParam.Units : string;
begin
  result := 'L/t';
end;

function THFBHydCondParam.Value: string;
begin
  result := '1E-8';
end;

//---------------------------
class Function THFBBarrierThickParam.ANE_ParamName : string ;
begin
  result := kMFHFBBarrierThick;
end;

function THFBBarrierThickParam.Units : string;
begin
  result := 'L';
end;

function THFBBarrierThickParam.Value: string;
begin
  result := '1';
end;

//---------------------------
constructor THFBLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);

  ModflowTypes.GetMFHFBHydCondParamType.Create( ParamList, -1);
  ModflowTypes.GetMFHFBBarrierThickParamType.Create( ParamList, -1);

end;

class Function THFBLayer.ANE_LayerName : string ;
begin
  result := kMFHFBLayer;
end;

end.
