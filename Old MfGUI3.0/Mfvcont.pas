unit MFVcont;

interface

{MFTransmissivity defines the "Vertical Conductance Unit[i]" layer
 and the associated parameter.}

uses ANE_LayerUnit;

type
  TVcontParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TVcontLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFVcont = 'Vertical Conductance Unit';

class Function TVcontParam.ANE_ParamName : string ;
begin
  result := kMFVcont;
end;

//---------------------------
constructor TVcontLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := leInterpolate;
  Lock := Lock - [llType];
  ModflowTypes.GetMFVcontParamType.Create( ParamList, -1);
end;

class Function TVcontLayer.ANE_LayerName : string ;
begin
  result := kMFVcont;
end;

function TVcontLayer.Units : string;
begin
  result := '1/T';
end;

function TVcontParam.Value: string;
begin
  result := '0.1';
end;

end.
