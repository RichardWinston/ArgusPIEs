unit MFBottom;

interface

{MFBottom defines the "Elevation Bottom Unit[i]" layer and associated
 parameter.}

uses ANE_LayerUnit;

type
  TBottomElevParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TBottomElevLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFBottom = 'Elevation Bottom Unit';

class Function TBottomElevParam.ANE_ParamName : string ;
begin
  result := kMFBottom;
end;

//---------------------------
constructor TBottomElevLayer.Create( ALayerList : T_ANE_LayerList; Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leInterpolate;
  Lock := Lock - [llType];
  ModflowTypes.GetMFBottomElevParamType.Create(ParamList, -1);
end;

class Function TBottomElevLayer.ANE_LayerName : string ;
begin
  result := kMFBottom;
end;

function TBottomElevLayer.Units : string;
begin
  Result := 'L';
end;


end.

