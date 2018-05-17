unit MT3DPrescribedHead;

interface

uses MFPrescribedHead, ANE_LayerUnit, SysUtils;

type
  TMT3DPrescribedHeadTimeParamList = class(T_ANE_IndexedParameterList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

type
  TMT3DPrescribedHeadLayer = Class(TPrescribedHeadLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
  end;

implementation

uses MT3DFormUnit, MT3DGeneralParameters, Variables;

constructor TMT3DPrescribedHeadTimeParamList.Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
  end;
end;

constructor TMT3DPrescribedHeadLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
var
  TimeIndex : integer;
begin
  inherited;// Create(Index,  ALayerList);
  For TimeIndex := 1 to StrToInt(frmMODFLOW.edNumPer.Text) do
  begin
    ModflowTypes.GetMT3DPrescribedHeadTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

end.
