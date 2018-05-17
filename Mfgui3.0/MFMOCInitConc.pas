unit MFMOCInitConc;

interface

{MFMOCInitConc defines the "Init Concentration Unit[i]" layer
 and associated parameter.}

uses ANE_LayerUnit;

type
  TMOCInitialConcParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMOCInitialConcLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFMOCInitialConc = 'Init Concentration Unit';

class Function TMOCInitialConcParam.ANE_ParamName : string ;
begin
  result := kMFMOCInitialConc;
end;

//---------------------------
constructor TMOCInitialConcLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  Lock := Lock - [llType];
  ModflowTypes.GetMFMOCInitialConcParamType.Create( ParamList, -1);
end;

class Function TMOCInitialConcLayer.ANE_LayerName : string ;
begin
  result := kMFMOCInitialConc;
end;

function TMOCInitialConcLayer.Units : string;
begin
  result := 'M/L^3';
end;

end.

