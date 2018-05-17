unit MFAnisotropy;

interface

uses ANE_LayerUnit;

type
  TAnistropyParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TAnistropyLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kAnis = 'Anisotropy Unit';



{ TAnistropyParam }

class function TAnistropyParam.ANE_ParamName: string;
begin
  result := kAnis
end;

function TAnistropyParam.Value: string;
begin
  result := '1';
end;

{ TAnistropyLayer }

class function TAnistropyLayer.ANE_LayerName: string;
begin
  result := kAnis;
end;

constructor TAnistropyLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ModflowTypes.GetMFAnistropyParamType.Create(ParamList, -1);
end;

end.
