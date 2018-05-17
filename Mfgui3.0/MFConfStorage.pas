unit MFConfStorage;

interface

{MFConfStorage defines the "Confined Storage Coefficient Unit[i]" layer
 and associated parameter.}

uses ANE_LayerUnit;

type
  TConfStorageParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TConfStorageLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFConfStor = 'Confined Storage Coefficient Unit';

class Function TConfStorageParam.ANE_ParamName : string ;
begin
  result := kMFConfStor;
end;

//---------------------------
constructor TConfStorageLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := leInterpolate;
  Lock := Lock - [llType];
  ModflowTypes.GetMFConfStorageParamType.Create( ParamList, -1);
end;

class Function TConfStorageLayer.ANE_LayerName : string ;
begin
  result := kMFConfStor;
end;

function TConfStorageLayer.Units : string;
begin
  result := '';
end;

function TConfStorageParam.Value: string;
begin
  result := '1.E-4';
end;

end.
