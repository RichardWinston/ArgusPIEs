unit MFMOCRetardation;

interface

{MFMOCRetardation defines the "Retardation Unit[i]" layer
 and associated parameter.}

uses ANE_LayerUnit, MFGenParam;

type
  TMOCRetardationParam = class(TCustomParentUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TMOCRetardationLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

Uses Variables;

ResourceString
  kMFMOCRetardation = 'Retardation Unit';

class Function TMOCRetardationParam.ANE_ParamName : string ;
begin
  result := kMFMOCRetardation;
end;

function TMOCRetardationParam.Units: string;
begin
  result := ''
end;

function TMOCRetardationParam.Value : string;
begin
  result := '1';
end;
//---------------------------
constructor TMOCRetardationLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create(ALayerList, Index);
//  Interp := leExact;
  Lock := Lock - [llType];
  ModflowTypes.GetMFMOCRetardationParamType.Create(ParamList, -1);
end;

class Function TMOCRetardationLayer.ANE_LayerName : string ;
begin
  result := kMFMOCRetardation;
end;


function TMOCRetardationLayer.Units: string;
begin
  result := ''
end;

end. 
