unit MFTransmissivity;

interface

{MFTransmissivity defines the "Transmissivity Unit[i]" layer
 and the associated parameter.}

uses ANE_LayerUnit;

type
  TTransmisivityParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TTransmisivityLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFTransmisivity = 'Transmissivity Unit';

class Function TTransmisivityParam.ANE_ParamName : string ;
begin
  result := kMFTransmisivity;
end;

//---------------------------
constructor TTransmisivityLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := le624;
  Lock := Lock - [llType];
  ModflowTypes.GetMFTransmisivityParamType.Create( ParamList, -1);
end;

class Function TTransmisivityLayer.ANE_LayerName : string ;
begin
  result := kMFTransmisivity;
end;

function TTransmisivityLayer.Units : string;
begin
  result := LengthUnit + '^2/' +TimeUnit ;
end;

function TTransmisivityParam.Value: string;
begin
  result := '1000';
end;

end.
