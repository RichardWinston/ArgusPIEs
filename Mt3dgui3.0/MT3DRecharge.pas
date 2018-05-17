unit MT3DRecharge;

interface

uses MFRecharge, ANE_LayerUnit;

type
  TMT3DRechargeTimeParamList = class( TRechargeTimeParamList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

implementation

uses MT3DFormUnit, MT3DGeneralParameters, Variables;

constructor TMT3DRechargeTimeParamList.Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer);
begin
  inherited;// Create(Index,  AnOwner);
  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
  end;
end;

end.
