unit MFInactive;

interface

{MFInactive defines the "Added Inactive Area Unit[i]" layer
 and associated parameter.}

uses ANE_LayerUnit, MFGenParam;

type
  TInactiveParam = class(TCustomParentUnitParameter)
  public
    constructor Create( AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units: string; override;

  end;

  TInactiveLayer = Class(T_ANE_InfoLayer)
  public
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units: string; override;
  end;

implementation

uses Variables, OptionsUnit;

ResourceString
  kMFInActive = 'Added Inactive Area Unit';

constructor TInactiveParam.Create( AParameterList : T_ANE_ParameterList;
                Index : Integer);
begin
  inherited Create(AParameterList, Index );
  ValueType := pvInteger;
  Lock := Lock + [plDef_Val];
end;

class Function TInactiveParam.ANE_ParamName : string ;
begin
  result := kMFInActive;
end;

function TInactiveParam.Value : string;
begin
  result := '1'
end;

function TInactiveParam.Units: string;
begin
  Result := '0 or 1';
end;

//---------------------------
constructor TInactiveLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;
  ModflowTypes.GetMFInactiveParamType.Create( ParamList, -1);
  Lock := Lock + [llEvalAlg];
end;

class Function TInactiveLayer.ANE_LayerName : string ;
begin
  result := kMFInActive;
end;

function TInactiveLayer.Units: string;
begin
  Result := '0 or 1';
end;

end.
