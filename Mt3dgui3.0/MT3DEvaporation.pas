unit MT3DEvaporation;

interface

uses MFEvapo, ANE_LayerUnit;

type
  TMT3DEvaporationTimeParamList = class(TETTimeParamList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

implementation

uses Variables, MT3DGeneralParameters;

constructor TMT3DEvaporationTimeParamList.Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
  end;
end;

end.
