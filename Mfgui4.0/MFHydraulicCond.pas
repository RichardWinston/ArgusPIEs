unit MFHydraulicCond;

interface

{MFHydraulicCond defines the "Hydraulic Cond Unit[i]" layer
 and associated parameters.}

uses ANE_LayerUnit, MFGenParam;

type
  TKx = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
//    function EvaluateLock: TParamLock; override;
  end;

  TKz = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMT3DLongDisp = class(T_ANE_LayerParam)
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
  kMT3DLongDisp = 'MT3D Longitudinal Dispersivity';

class Function TKx.ANE_ParamName : string ;
begin
  result := kKx;
end;

{function TKx.EvaluateLock: TParamLock;
var
  ParentLayer : T_ANE_Layer;
  UnitIndex : integer;
  LayerList : T_ANE_IndexedLayerList;
begin
  result := inherited EvaluateLock;
  ParentLayer := GetParentLayer;
  UnitIndex := (ParentLayer.LayerList as T_ANE_IndexedLayerList).Index;
  if frmModflow.Simulated(UnitIndex) then
  begin
    result := result - [plDef_Val, plDont_Override, plDontEvalColor]
  end
  else
  begin
    result := result + [plDef_Val, plDont_Override, plDontEvalColor]
  end;
end; }

function TKx.Units : string;
begin
  result := LengthUnit  + '/' + TimeUnit;
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
  result := LengthUnit  + '/' + TimeUnit;
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
  Interp := le624;
  Lock := Lock - [llType];
  ModflowTypes.GetMFKxParamType.Create(ParamList, -1);
  ModflowTypes.GetMFKzParamType.Create(ParamList, -1);
  if frmMODFLOW.cbMT3D.Checked then
  begin
    ModflowTypes.GetMT3DLongDispParamClassType.Create(ParamList, -1);
  end;

end;

class Function THydraulicCondLayer.ANE_LayerName : string ;
begin
  result := kMFHydraulicCond;
end;

function THydraulicCondLayer.Units : string;
begin
  result := LengthUnit  + '/' + TimeUnit;
end;

{ TMT3DLongDisp }

class Function TMT3DLongDisp.Ane_ParamName : string ;
begin
  result := kMT3DLongDisp;
end;

function TMT3DLongDisp.Units : string;
begin
  result := 'L';
end;

function TMT3DLongDisp.Value : string;
begin
  result := '10';
end;

end.
