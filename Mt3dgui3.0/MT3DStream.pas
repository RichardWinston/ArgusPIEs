unit MT3DStream;

interface

uses MFStreamUnit, ANE_LayerUnit;

type
  TMT3DStreamTimeParamList = class( TStreamTimeParamList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

implementation

uses MT3DFormUnit, MT3DGeneralParameters, Variables;

constructor TMT3DStreamTimeParamList.Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer);
begin
  inherited;// Create(Index,  AnOwner);
  ParameterOrder.Add(ModflowTypes.GetMT3DConcentrationParamClassType.Ane_ParamName);
  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
  end;
end;

end.
