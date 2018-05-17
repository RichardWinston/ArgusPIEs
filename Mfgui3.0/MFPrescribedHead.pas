unit MFPrescribedHead;

interface

{MFPrescribedHead defines the "Prescribed Head Unit[i]" layer
 and the associated parameter.}

uses ANE_LayerUnit;

type
  TPrescribedHeadParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  public
  end;

  TPrescribedHeadLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFPrescribedHead = 'Prescribed Head Unit';

class Function TPrescribedHeadParam.ANE_ParamName : string ;
begin
  result := kMFPrescribedHead;
end;

function TPrescribedHeadParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
constructor TPrescribedHeadLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFPrescribedHeadParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFConcentrationParamType.ANE_ParamName);

  ModflowTypes.GetMFPrescribedHeadParamType.Create( ParamList, -1);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFConcentrationParamType.Create( ParamList, -1);
  end;
end;

class Function TPrescribedHeadLayer.ANE_LayerName : string ;
begin
  result := kMFPrescribedHead;
end;

function TPrescribedHeadLayer.Units : string;
begin
  result := 'L';
end;

end.

