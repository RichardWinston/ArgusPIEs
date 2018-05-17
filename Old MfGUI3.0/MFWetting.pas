unit MFWetting;

interface

{MFWetting defines the "Wetting Threshold Unit[i]" layer
 and the associated parameters.}

uses ANE_LayerUnit;

type
  TWettingThreshParam = class(T_ANE_ParentIndexLayerParam)
  public
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TWettingFlagParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer);  override;
    function Units : string; override;
  end;

  TWettingLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFWettingThreshUnit = 'Wetting Threshold Unit';
  kMFWettingFlag = 'Wetting Flag';

class Function TWettingThreshParam.ANE_ParamName : string ;
begin
  result := kMFWettingThreshUnit;
end;

function TWettingThreshParam.Value: string;
begin
  result := '1';
end;

//---------------------------
class Function TWettingFlagParam.ANE_ParamName : string ;
begin
  result := kMFWettingFlag;
end;

function TWettingFlagParam.Units : string;
begin
  result := '-1 or 0 or 1';
end;

constructor TWettingFlagParam.Create(AParameterList : T_ANE_ParameterList;
   Index : Integer);
begin
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

//---------------------------
constructor TWettingLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  Lock := Lock - [llType];
  ModflowTypes.GetMFWettingThreshParamType.Create( ParamList, -1);
  ModflowTypes.GetMFWettingFlagParamType.Create(ParamList, -1);
end;

class Function TWettingLayer.ANE_LayerName : string ;
begin
  result := kMFWettingThreshUnit;
end;

function TWettingLayer.Units : string;
begin
  result := 'L';
end;

end.

