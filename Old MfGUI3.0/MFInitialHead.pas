unit MFInitialHead;

interface

{MFInitialHead defines the "Initial Head Unit[i]" layer
 and associated parameter.}

uses ANE_LayerUnit;

type
  TInitialHeadParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TInitialHeadLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFInitialHead = 'Initial Head Unit';

class Function TInitialHeadParam.ANE_ParamName : string ;
begin
  result := kMFInitialHead;
end;

//---------------------------
constructor TInitialHeadLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := leInterpolate;
  Lock := Lock - [llType];
  ModflowTypes.GetMFInitialHeadParamType.Create( ParamList, -1);
end;

class Function TInitialHeadLayer.ANE_LayerName : string ;
begin
  result := kMFInitialHead;
end;

function TInitialHeadLayer.Units : string;
begin
  result := 'L';
end;

end.

