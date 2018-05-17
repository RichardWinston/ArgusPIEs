unit MfMt3dConcentrationObservationUnit;

interface

uses AnePIE, ANE_LayerUnit, SysUtils;

type
  TConcObsParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TObservationWeightParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TSpeciesParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : string; override;
  end;

  TConcWeightParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units: string; override;
  end;

  TConcentrationObservationParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TConcWeightParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TWeightedConcentrationObservationsLayer = Class(TIndexedInfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TWeightedConcentrationList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

implementation

uses Variables;

const
  KObserverdConc = 'Observed Concentration';
  KChemicalSpecies = 'Chemical Species';
  kMt3dConcentrationObs = 'MT3DMS Concentration Observations';
  kProportion = 'Proportion Unit';
  kObservationWeight = 'Observation Weight';

{ TConcentrationObservationParamList }

constructor TConcentrationObservationParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.GetMFObservationNameParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFTimeParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFConcObsParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFSpeciesParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFObservationWeightParamType.WriteParamName);


  ModflowTypes.GetMFObservationNameParamType.Create( self, -1);
  ModflowTypes.GetMFTimeParamType.Create( self, -1);
  ModflowTypes.GetMFConcObsParamType.Create( self, -1);
  ModflowTypes.GetMFSpeciesParamType.Create( self, -1);
  ModflowTypes.GetMFObservationWeightParamType.Create( self, -1);

end;

{ TConcObsParam }

class function TConcObsParam.ANE_ParamName: string;
begin
  result := KObserverdConc;
end;

{ TSpeciesParam }

class function TSpeciesParam.ANE_ParamName: string;
begin
  result := KChemicalSpecies;
end;

constructor TSpeciesParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TSpeciesParam.Units: string;
begin
  result := '1 to 5';
end;

function TSpeciesParam.Value: string;
begin
  result := '1';
end;

{ TWeightedConcentrationObservationsLayer }

class function TWeightedConcentrationObservationsLayer.ANE_LayerName: string;
begin
  result := kMt3dConcentrationObs;
end;

constructor TWeightedConcentrationObservationsLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  NumberOfTimes: integer;
  NumberOfUnits: integer;
  TimeIndex,UnitIndex: integer;
begin
  inherited;
  ModflowTypes.GetMFObjectObservationNameParamClassType.Create( ParamList, -1);
//  ModflowTypes.GetMFObservationWeightParamType.Create( ParamList, -1);


  NumberOfTimes := StrToInt(frmMODFLOW.adeConcObsTimeCount.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFConcentrationObservationParamListType.Create(
      IndexedParamList1, -1);
  end;
  NumberOfUnits := StrToInt(frmMODFLOW.edNumUnits.Text);
  For UnitIndex := 1 to NumberOfUnits do
  begin
    ModflowTypes.GetMFConcWeightParamListType.Create( IndexedParamList0, -1);
  end;

end;

{ TWeightedConcentrationList }

constructor TWeightedConcentrationList.Create(
  AnOwner: T_ANE_ListOfIndexedLayerLists; Position: Integer);
var
  Index : integer;
begin
  inherited;
  if frmModflow.cbMT3D.Checked and frmModflow.cbTOB.Checked then
  begin
    for Index := 0 to StrToInt(frmMODFLOW.adeConcObsLayerCount.Text)-1 do
    begin
      ModflowTypes.GetMT3DWeightedConcentrationObservationsLayerType.Create(self, -1);
    end;
  end;
end;

{ TConcWeightParam }

class function TConcWeightParam.ANE_ParamName: string;
begin
  result := kProportion;
end;

function TConcWeightParam.Units: string;
begin
  result := 'Set >0 to use';
end;

function TConcWeightParam.Value: string;
begin
  result := '0';
end;

{ TConcWeightParamList }

constructor TConcWeightParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ModflowTypes.GetMFConcWeightParamType.Create( self, -1);
end;

//{ TCalculateResidualsParam }
//
//class function TCalculateResidualsParam.ANE_ParamName: string;
//begin
//  result := 'Save Residuals';
//end;
//
//constructor TCalculateResidualsParam.Create(
//  AParameterList: T_ANE_ParameterList; Index: Integer);
//begin
//  inherited;
//  ValueType := pvBoolean;
//end;

//function TCalculateResidualsParam.Value: string;
//begin
//  result := '1';
//end;

{ TObservationWeightParam }

class function TObservationWeightParam.ANE_ParamName: string;
begin
  result := kObservationWeight;
end;

function TObservationWeightParam.Value: string;
begin
  result := '1';
end;

end.
