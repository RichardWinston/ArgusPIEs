unit MFPrescribedHead;

interface

{MFPrescribedHead defines the "Prescribed Head Unit[i]" layer
 and the associated parameter.}

uses SysUtils, ANE_LayerUnit, MFGenParam;

type
  TPrescribedHeadParam = class(TCustomParentUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  public
  end;

  TMT3DPrescribedHeadTimeParamList = class(T_ANE_IndexedParameterList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

  TPrescribedHeadLayer = Class(TCustomIFACE_Layer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
    class Function UseIFACE: boolean; override;
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
var
  TimeIndex : integer;
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFPrescribedHeadParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFConcentrationParamType.ANE_ParamName);

  ModflowTypes.GetMFPrescribedHeadParamType.Create( ParamList, -1);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFConcentrationParamType.Create( ParamList, -1);
  end;
  if UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( ParamList, -1);
  end;
  For TimeIndex := 1 to StrToInt(frmMODFLOW.edNumPer.Text) do
  begin
    ModflowTypes.GetMT3DPrescribedHeadTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TPrescribedHeadLayer.ANE_LayerName : string ;
begin
  result := kMFPrescribedHead;
end;

function TPrescribedHeadLayer.Units : string;
begin
  result := LengthUnit;
end;

{ TMT3DPrescribedHeadTimeParamList }

constructor TMT3DPrescribedHeadTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Index: Integer);
var
  NCOMP : integer;
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName);
  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
    NCOMP := StrToInt(frmMODFLOW.adeMT3DNCOMP.Text);
    if NCOMP >= 2 then
    begin
      ModflowTypes.GetMT3DConc2ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 3 then
    begin
      ModflowTypes.GetMT3DConc3ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 4 then
    begin
      ModflowTypes.GetMT3DConc4ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 5 then
    begin
      ModflowTypes.GetMT3DConc5ParamClassType.Create(self, -1);
    end;

  end;

end;

class function TPrescribedHeadLayer.UseIFACE: boolean;
begin
  result := (frmMODFLOW.cbMOC3D.Checked and frmMODFLOW.cbBFLX.Checked);
end;

end.
