unit MF_HUF_RefSurf;

interface

uses ANE_LayerUnit;

type
  THUF_ReferenceSurfaceParameter = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  THUF_ReferenceSurfaceLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;


implementation

uses Variables;

ResourceString
  KHUF_RefSurf = 'HUF Reference Surface';

{ THUF_ReferenceSurfaceParameter }

class function THUF_ReferenceSurfaceParameter.ANE_ParamName: string;
begin
  result := KHUF_RefSurf;
end;

function THUF_ReferenceSurfaceParameter.Units: string;
begin
  result := LengthUnit
end;

{ THUF_ReferenceSurfaceLayer }

class function THUF_ReferenceSurfaceLayer.ANE_LayerName: string;
begin
  result := KHUF_RefSurf;
end;

constructor THUF_ReferenceSurfaceLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := le624;
  Lock := Lock - [llType];
  ModflowTypes.GetMFHUF_ReferenceSurfaceParamClassType.Create(ParamList, -1);
end;

function THUF_ReferenceSurfaceLayer.Units: string;
begin
  result := LengthUnit
end;

end.
