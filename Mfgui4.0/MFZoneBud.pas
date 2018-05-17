unit MFZoneBud;

interface

{MFZoneBud defines the "ZONEBDGT Unit[i]" layer
 and the associated parameter.}

uses ANE_LayerUnit, SysUtils, MFGenParam;

type
  TZoneBudZone = class(TCustomUnitParameter)
  public
    class function ANE_ParamName: string; override;
    function Units: string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
  end;

  TZoneBudLayer = Class(T_ANE_InfoLayer)
  public
    class function ANE_LayerName: string; override;
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
      override;
  end;

implementation

uses Variables;

resourcestring
 kMFZoneBudZoneParam = 'Primary Zone';
// kMFZoneBudZoneLayer = 'ZoneBudget Unit';
 kMFZoneBudZoneLayer = 'ZONEBDGT Unit';

class function TZoneBudZone.ANE_ParamName: string;
begin
  result := kMFZoneBudZoneParam;

end;

constructor TZoneBudZone.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TZoneBudZone.Units: string;
begin
  result := ''
end;

//-----------------------------------------------

class function TZoneBudLayer.ANE_LayerName: string;
begin
  result := kMFZoneBudZoneLayer
end;

constructor TZoneBudLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Lock := Lock + [llEvalAlg]; 
  Interp := leExact;

  ModflowTypes.GetMFZoneBudZoneParamType.Create(ParamList, -1);
end;

end.
