unit MFModPathZone;

interface

{MFModPathZone defines the "MODPATH Zone Unit" layer
 and the associated parameter.}

uses ANE_LayerUnit;

type
  TModpathZoneParam = class(T_ANE_ParentIndexLayerParam)
  public
    class function ANE_ParamName: string; override;
    function Units: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
                Index: Integer); override;
    function Value : string; override;

  end;

  TModpathZoneLayer = Class(T_ANE_InfoLayer)
  public
    class function ANE_LayerName: string; override;
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
  end;

implementation

uses Variables, OptionsUnit;

ResourceString
  kMPathZone = 'MODPATH Zone Unit';

class function TModpathZoneParam.ANE_ParamName: string;
begin
  result := kMPathZone;
end;

constructor TModpathZoneParam.Create(AParameterList: T_ANE_ParameterList;
            Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
  Lock := Lock + [plDef_Val]
end;

function TModpathZoneParam.Units: string;
begin
  result := ''

end;

function TModpathZoneParam.Value: string;
begin
  result := '1';
end;

//-----------------------------------------
class function TModpathZoneLayer.ANE_LayerName: string;
begin
  result := kMPathZone;

end;

constructor TModpathZoneLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;

  ModflowTypes.GetMFModpathZoneParamType.Create(ParamList, -1);

end;

end.
