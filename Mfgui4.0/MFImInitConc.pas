unit MFImInitConc;

interface

uses ANE_LayerUnit;

type
  TMOCImInitConcParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMOCImInitConcLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

Uses Variables;

ResourceString
  kMFMOCImInitConc = 'Immobile Initial Concentration Unit';

class Function TMOCImInitConcParam.ANE_ParamName : string ;
begin
  result := kMFMOCImInitConc;
end;

function TMOCImInitConcParam.Units: string;
begin
  result := 'M/L^3';
end;

//---------------------------
constructor TMOCImInitConcLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  Lock := Lock - [llType];
  ModflowTypes.GetMFMOCImInitConcParamType.Create(ParamList, -1);
end;

class Function TMOCImInitConcLayer.ANE_LayerName : string ;
begin
  result := kMFMOCImInitConc;
end;

function TMOCImInitConcLayer.Units : string;
begin
  result := 'M/L^3';
end;

end.
 