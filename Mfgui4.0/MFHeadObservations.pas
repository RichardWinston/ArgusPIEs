unit MFHeadObservations;

interface

uses AnePIE, ANE_LayerUnit, SysUtils, MFGenParam;

type
  TIttParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : string; override;
  end;

  TObservedHeadParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStathParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TStatddParam = class(TStathParam)
    class Function ANE_ParamName : string ; override;
  end;

  TWeightParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  THeadObservationParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TWeightParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  THeadObservationsLayer = Class(TIndexedInfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

  TWeightedHeadObservationsLayer = Class(THeadObservationsLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TObservationsGroupLayer = class(T_ANE_GroupLayer)
    public
      class Function ANE_LayerName : string ; override;
      function WriteIndex : string; override;
      function WriteOldIndex : string; override;
    end;

  TObservationGroupList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

  TObservationList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

  TWeightedObservationList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;


implementation

uses Variables;

ResourceString
  kITT = 'ITT';
  kObservedHead = 'Observed Head';
  kStath = 'STATh';
  kStatdd = 'STATdd';
  kHeadObservations = 'Head Observations';
  kWeight = 'Weight Unit';
  kWeightedHeadObservations = 'Weighted Head Observations';
  kObservations = 'Observations';

{ TIttParam }

class function TIttParam.ANE_ParamName: string;
begin
  result := kITT;
end;

constructor TIttParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TIttParam.Units: string;
begin
  result := '1 or 2'
end;

function TIttParam.Value: string;
begin
  result := '2';
end;

{ TObservedHeadParam }

class function TObservedHeadParam.ANE_ParamName: string;
begin
  result := kObservedHead;
end;

function TObservedHeadParam.Units: string;
begin
  result := LengthUnit;
end;


{ TStathParam }

class function TStathParam.ANE_ParamName: string;
begin
  result := kStath;
end;

function TStathParam.Value: string;
begin
  result := '1';
end;

{ TStatddParam }

class function TStatddParam.ANE_ParamName: string;
begin
  result := kStatdd;
end;

{ THeadObservationParamList }

constructor THeadObservationParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.GetMFObservationNameParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFObservedHeadParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFReferenceStressPeriodParamClassType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFTimeParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStathParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStatddParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIsObservationParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIsPredictionParamType.WriteParamName);

  ModflowTypes.GetMFObservationNameParamType.Create( self, -1);
  ModflowTypes.GetMFObservedHeadParamType.Create( self, -1);
  ModflowTypes.GetMFReferenceStressPeriodParamClassType.Create( self, -1);
  ModflowTypes.GetMFTimeParamType.Create( self, -1);
  ModflowTypes.GetMFStathParamType.Create( self, -1);
  ModflowTypes.GetMFStatddParamType.Create( self, -1);
  ModflowTypes.GetMFIsObservationParamType.Create( self, -1);
  ModflowTypes.GetMFIsPredictionParamType.Create( self, -1);
end;

{ THeadObservationsLayer }

class function THeadObservationsLayer.ANE_LayerName: string;
begin
  result := kHeadObservations;
end;

constructor THeadObservationsLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited;
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFTopObsElevParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFBottomObsElevParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFTopLayerParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFBottomLayerParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStatFlagParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFPlotSymbolParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIttParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFObjectObservationNameParamClassType.WriteParamName);

  ModflowTypes.GetMFTopObsElevParamType.Create( ParamList, -1);
  ModflowTypes.GetMFBottomObsElevParamType.Create( ParamList, -1);
  ModflowTypes.GetMFTopLayerParamType.Create( ParamList, -1);
  ModflowTypes.GetMFBottomLayerParamType.Create( ParamList, -1);
  ModflowTypes.GetMFStatFlagParamType.Create( ParamList, -1);
  ModflowTypes.GetMFPlotSymbolParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIttParamType.Create( ParamList, -1);
  ModflowTypes.GetMFObjectObservationNameParamClassType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.adeObsHeadCount.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFHeadObservationParamListType.Create( IndexedParamList1, -1);
  end;
end;

function THeadObservationsLayer.Units: string;
begin
  result := '';
end;

{ TWeightParam }

class function TWeightParam.ANE_ParamName: string;
begin
  result := kWeight;
end;

function TWeightParam.Value: string;
begin
  result := '1';
end;

{ TWeightParamList }

constructor TWeightParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ModflowTypes.GetMFWeightParamType.Create( self, -1);

end;

{ TWeightedHeadObservationsLayer }

class function TWeightedHeadObservationsLayer.ANE_LayerName: string;
begin
  result := kWeightedHeadObservations;
end;

constructor TWeightedHeadObservationsLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  UnitIndex : Integer;
  NumberOfUnits : integer;
begin
  inherited;

  NumberOfUnits := StrToInt(frmMODFLOW.edNumUnits.Text);
  For UnitIndex := 1 to NumberOfUnits do
  begin
    ModflowTypes.GetMFWeightParamListType.Create( IndexedParamList0, -1);
  end;

end;


{ TObservationsGroupLayer }

class function TObservationsGroupLayer.ANE_LayerName: string;
begin
  result := kObservations;
end;

function TObservationsGroupLayer.WriteIndex: string;
begin
  result := '';
end;

function TObservationsGroupLayer.WriteOldIndex: string;
begin
  result := '';
end;

{ TObservationList }

constructor TObservationList.Create(AnOwner: T_ANE_ListOfIndexedLayerLists;
  Position: Integer);
var
  Index : integer;
begin
  inherited;
  for Index := 0 to StrToInt(frmMODFLOW.adeHeadObsLayerCount.Text)-1 do
  begin
    ModflowTypes.GetMFHeadObservationsLayerType.Create(self, -1);
  end;

end;

{ TObservationGroupList }

constructor TObservationGroupList.Create(
  AnOwner: T_ANE_ListOfIndexedLayerLists; Position: Integer);
begin
  inherited;
  ModflowTypes.GetMFObservationsGroupLayerType.Create(self, -1);

end;

{ TWeightedObservationList }

constructor TWeightedObservationList.Create(
  AnOwner: T_ANE_ListOfIndexedLayerLists; Position: Integer);
var
  Index : integer;
begin
  inherited;
  for Index := 0 to StrToInt(frmMODFLOW.adeWeightedHeadObsLayerCount.Text)-1 do
  begin
    ModflowTypes.GetMFWeightedHeadObservationsLayerType.Create(self, -1);
  end;

end;

end.
