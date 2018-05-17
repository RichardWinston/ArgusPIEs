unit MT3DDrain;

interface

uses MFDrain, ANE_LayerUnit;

type
  TMT3DDrainTimeParamList = class( TDrainTimeParamList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

implementation

uses MT3DFormUnit, MT3DGeneralParameters, Variables;

constructor TMT3DDrainTimeParamList.Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer);
begin
  inherited;// Create(Index,  AnOwner);
  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
  end;
end;

end.
 