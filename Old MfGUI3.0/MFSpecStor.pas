unit MFSpecStor;

interface

{MFSpecStor defines the "Specific Storage Unit[i]" layer
 and the associated parameter.}

uses ANE_LayerUnit;

type
  TSpecStorageParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TSpecStorageLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFSpecStorage = 'Specific Storage Unit';

class Function TSpecStorageParam.ANE_ParamName : string ;
begin
  result := kMFSpecStorage;
end;

function TSpecStorageParam.Value : string;
begin
  result := '1.E-5';
end;

//---------------------------
constructor TSpecStorageLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leInterpolate;
  Lock := Lock - [llType];
  ModflowTypes.GetMFSpecStorageParamType.Create(ParamList, -1);
end;

class Function TSpecStorageLayer.ANE_LayerName : string ;
begin
  result := kMFSpecStorage;
end;

function TSpecStorageLayer.Units : string;
begin
  result := '1/L';
end;

end.

