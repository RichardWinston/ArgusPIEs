unit MFHydraulicCond;

interface

{MFHydraulicCond defines the "Hydraulic Cond Unit[i]" layer
 and associated parameters.}

uses ANE_LayerUnit;

type
  TKx = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TKz = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  THydraulicCondLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFHydraulicCond = 'Hydraulic Cond Unit';
  kKx = 'Kx';
  kKz = 'Kz';

class Function TKx.ANE_ParamName : string ;
begin
  result := kKx;
end;

function TKx.Units : string;
begin
  result := 'L/T';
end;

function TKx.Value : string;
begin
  result := '100';
end;

//---------------------------
class Function TKz.ANE_ParamName : string ;
begin
  result := kKz;
end;

function TKz.Units : string;
begin
  result := 'L/T';
end;

function TKz.Value : string;
begin
  result := '1';
end;

//---------------------------
constructor THydraulicCondLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := leInterpolate;
  Lock := Lock - [llType];
  ModflowTypes.GetMFKxParamType.Create(ParamList, -1);
  ModflowTypes.GetMFKzParamType.Create(ParamList, -1);

end;

class Function THydraulicCondLayer.ANE_LayerName : string ;
begin
  result := kMFHydraulicCond;
end;

function THydraulicCondLayer.Units : string;
begin
  result := 'L/T';
end;

end.

