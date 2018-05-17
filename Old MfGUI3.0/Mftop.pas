unit MFTop;

interface

{MFTop defines the "Elevation Top Unit[i]" layer
 and the associated parameter.}

uses ANE_LayerUnit;

type
  TTopElevParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TTopElevLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFTop = 'Elevation Top Unit';

class Function TTopElevParam.ANE_ParamName : string ;
begin
  result := kMFTop;
end;

//---------------------------
constructor TTopElevLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := leInterpolate;
  Lock := Lock - [llType];
  ModflowTypes.GetMFTopElevParamType.Create(ParamList, -1);
end;

class Function TTopElevLayer.ANE_LayerName : string ;
begin
  result := kMFTop;
end;

function TTopElevLayer.Units : string;
begin
  Result := 'L';
end;


end.
