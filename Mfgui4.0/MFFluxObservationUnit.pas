unit MFFluxObservationUnit;

interface

uses AnePIE, ANE_LayerUnit, SysUtils, MFGenParam;

type
  TFactorParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TLossParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TObservationNumberParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TObservationGroupNumberParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TCustomFluxObservationParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TGHBFluxObservationParamList = class( TCustomFluxObservationParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TDrainFluxObservationParamList = class( TCustomFluxObservationParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TDrainReturnFluxObservationParamList = class( TCustomFluxObservationParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TRiverFluxObservationParamList = class( TCustomFluxObservationParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TSpecifiedHeadFluxObservationParamList = class( TCustomFluxObservationParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TMFCustomFluxObservationParamListClass = class of TCustomFluxObservationParamList;

  TBaseFluxObservationsLayer = Class(TIndexedInfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class function GetNumberOfTimes : integer; virtual; abstract;
    class function GetParamListType : TMFCustomFluxObservationParamListClass; virtual; abstract;
  end;

  TCustomFluxObservationsLayer = Class(TBaseFluxObservationsLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
  end;

  TGHBFluxObservationsLayer = Class(TCustomFluxObservationsLayer)
    class function GetNumberOfTimes : integer; override;
    class Function ANE_LayerName : string ; override;
    class function GetParamListType : TMFCustomFluxObservationParamListClass; override;
  end;

  TDrainFluxObservationsLayer = Class(TCustomFluxObservationsLayer)
    class function GetNumberOfTimes : integer; override;
    class Function ANE_LayerName : string ; override;
    class function GetParamListType : TMFCustomFluxObservationParamListClass; override;
  end;

  TDrainReturnFluxObservationsLayer = Class(TCustomFluxObservationsLayer)
    class function GetNumberOfTimes : integer; override;
    class Function ANE_LayerName : string ; override;
    class function GetParamListType : TMFCustomFluxObservationParamListClass; override;
  end;

  TRiverFluxObservationsLayer = Class(TCustomFluxObservationsLayer)
    class function GetNumberOfTimes : integer; override;
    class Function ANE_LayerName : string ; override;
    class function GetParamListType : TMFCustomFluxObservationParamListClass; override;
  end;

  TSpecifiedHeadFluxObservationsLayer = Class(TBaseFluxObservationsLayer)
    class function GetNumberOfTimes : integer; override;
    class Function ANE_LayerName : string ; override;
    class function GetParamListType : TMFCustomFluxObservationParamListClass; override;
  end;

  TGHBFluxObsList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

  TDrainFluxObsList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

  TDrainReturnFluxObsList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

  TRiverFluxObsList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

  TSpecifiedHeadFluxObsList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

implementation

uses Variables;

ResourceString
  kFactor = 'Factor';
  kLoss = 'Loss';
  kGHBObs = 'GHB Observations';
  kDrainObs = 'Drain Observations';
  kDrainReturnObs = 'Drain Return Observations';
  kRiverObs = 'River Observations';
  kHeadFlux = 'Prescribed_Head Flux Observations';
  KObsNumber = 'Observation Number';
  kCellGroupNumber = 'Cell Group Number';

{ TObservationNumberParam }

class function TObservationNumberParam.ANE_ParamName: string;
begin
  result := KObsNumber;
end;

constructor TObservationNumberParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

{ TFactorParam }

class function TFactorParam.ANE_ParamName: string;
begin
  result := kFactor;
end;

function TFactorParam.Value: string;
begin
  result := '1';
end;

{ TLossParam }

class function TLossParam.ANE_ParamName: string;
begin
  result := kLoss;
end;

function TLossParam.Units: string;
begin
  result := LengthUnit  + '^3/' + TimeUnit;
end;


{ TCustomFluxObservationParamList }

constructor TCustomFluxObservationParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.GetMFObservationNameParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFReferenceStressPeriodParamClassType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFTimeParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFLossParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStatisticParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFObservationNumberParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIsObservationParamType.WriteParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIsPredictionParamType.WriteParamName);

  ModflowTypes.GetMFObservationNameParamType.Create( self, -1);
  ModflowTypes.GetMFReferenceStressPeriodParamClassType.Create( self, -1);
  ModflowTypes.GetMFTimeParamType.Create( self, -1);
  ModflowTypes.GetMFLossParamType.Create( self, -1);
  ModflowTypes.GetMFStatisticParamType.Create( self, -1);
  ModflowTypes.GetMFIsObservationParamType.Create( self, -1);
  ModflowTypes.GetMFIsPredictionParamType.Create( self, -1);

end;

{ TCustomFluxObservationsLayer }

constructor TCustomFluxObservationsLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Insert(0, ModflowTypes.GetMFObservationGroupNumberParamType.WriteParamName);

  ModflowTypes.GetMFObservationGroupNumberParamType.Create( ParamList, 0);
end;

{ TGHBFluxObservationsLayer }

class function TGHBFluxObservationsLayer.ANE_LayerName: string;
begin
  result := kGHBObs;
end;

class function TGHBFluxObservationsLayer.GetNumberOfTimes: integer;
begin
  result := StrToInt(frmMODFLOW.adeObsGHBTimeCount.Text);
end;

class function TGHBFluxObservationsLayer.GetParamListType: TMFCustomFluxObservationParamListClass;
begin
  result := ModflowTypes.GetMFGHBFluxObservationParamListType;
end;

{ TDrainFluxObservationsLayer }

class function TDrainFluxObservationsLayer.ANE_LayerName: string;
begin
  result := kDrainObs;
end;

class function TDrainFluxObservationsLayer.GetNumberOfTimes: integer;
begin
  result := StrToInt(frmMODFLOW.adeObsDRNTimeCount.Text);
end;

class function TDrainFluxObservationsLayer.GetParamListType: TMFCustomFluxObservationParamListClass;
begin
  result := ModflowTypes.GetMFDrainFluxObservationParamListType;
end;

{ TRiverFluxObservationsLayer }

class function TRiverFluxObservationsLayer.ANE_LayerName: string;
begin
  result := kRiverObs;
end;

class function TRiverFluxObservationsLayer.GetNumberOfTimes: integer;
begin
  result := StrToInt(frmMODFLOW.adeObsRIVTimeCount.Text);
end;

class function TRiverFluxObservationsLayer.GetParamListType: TMFCustomFluxObservationParamListClass;
begin
  result := ModflowTypes.GetMFRiverFluxObservationParamListType;
end;

{ TGHBFluxObsList }

constructor TGHBFluxObsList.Create(AnOwner: T_ANE_ListOfIndexedLayerLists;
  Position: Integer);
var
  Index : integer;
begin
  inherited;
  for Index := 0 to StrToInt(frmMODFLOW.adeGHBObsLayerCount.Text)-1 do
  begin
    ModflowTypes.GetMFGHBFluxObservationsLayerType.Create(self, -1);
  end;
end;

{ TDrainFluxObsList }

constructor TDrainFluxObsList.Create(
  AnOwner: T_ANE_ListOfIndexedLayerLists; Position: Integer);
var
  Index : integer;
begin
  inherited;
  for Index := 0 to StrToInt(frmMODFLOW.adeDRNObsLayerCount.Text)-1 do
  begin
    ModflowTypes.GetMFDrainFluxObservationsLayerType.Create(self, -1);
  end;
end;

{ TRiverFluxObsList }

constructor TRiverFluxObsList.Create(
  AnOwner: T_ANE_ListOfIndexedLayerLists; Position: Integer);
var
  Index : integer;
begin
  inherited;
  for Index := 0 to StrToInt(frmMODFLOW.adeRIVObsLayerCount.Text)-1 do
  begin
    ModflowTypes.GetMFRiverFluxObservationsLayerType.Create(self, -1);
  end;
end;

{ TSpecifiedHeadFluxObservationsLayer }

class function TSpecifiedHeadFluxObservationsLayer.ANE_LayerName: string;
begin
  result := kHeadFlux;
end;

class function TSpecifiedHeadFluxObservationsLayer.GetNumberOfTimes: integer;
begin
  result := StrToInt(frmMODFLOW.adeObsHeadFluxTimeCount.Text);
end;

class function TSpecifiedHeadFluxObservationsLayer.GetParamListType: TMFCustomFluxObservationParamListClass;
begin
  result := ModflowTypes.GetMFSpecifiedHeadFluxObservationParamListType;
end;

{ TSpecifiedHeadFluxObsList }

constructor TSpecifiedHeadFluxObsList.Create(
  AnOwner: T_ANE_ListOfIndexedLayerLists; Position: Integer);
var
  Index : integer;  
begin
  inherited;
  for Index := 0 to StrToInt(frmMODFLOW.adeHeadFluxObsLayerCount.Text)-1 do
  begin
    ModflowTypes.GetMFSpecifiedHeadFluxObservationsLayerType.Create(self, -1);
  end;
end;

{ TGHBFluxObservationParamList }

constructor TGHBFluxObservationParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  if frmMODFLOW.cbSpecifyGHBCovariances.Checked then
  begin
    ModflowTypes.GetMFObservationNumberParamType.Create( self, -1);
  end;
end;

{ TDrainFluxObservationParamList }

constructor TDrainFluxObservationParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  if frmMODFLOW.cbSpecifyDRNCovariances.Checked then
  begin
    ModflowTypes.GetMFObservationNumberParamType.Create( self, -1);
  end;
end;

{ TRiverFluxObservationParamList }

constructor TRiverFluxObservationParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  if frmMODFLOW.cbSpecifyRiverCovariances.Checked then
  begin
    ModflowTypes.GetMFObservationNumberParamType.Create( self, -1);
  end;
end;

{ TSpecifiedHeadFluxObservationParamList }

constructor TSpecifiedHeadFluxObservationParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  if frmMODFLOW.cbSpecifyHeadFluxCovariances.Checked then
  begin
    ModflowTypes.GetMFObservationNumberParamType.Create( self, -1);
  end;
end;

{ TObservationGroupNumberParam }

class function TObservationGroupNumberParam.ANE_ParamName: string;
begin
  result := kCellGroupNumber;
end;

constructor TObservationGroupNumberParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

{ TDrainReturnFluxObservationParamList }

constructor TDrainReturnFluxObservationParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  if frmMODFLOW.cbSpecifyDRTCovariances.Checked then
  begin
    ModflowTypes.GetMFObservationNumberParamType.Create( self, -1);
  end;

end;

{ TDrainReturnFluxObservationsLayer }

class function TDrainReturnFluxObservationsLayer.ANE_LayerName: string;
begin
  result := kDrainReturnObs;
end;

class function TDrainReturnFluxObservationsLayer.GetNumberOfTimes: integer;
begin
  result := StrToInt(frmMODFLOW.adeObsDRTTimeCount.Text);
end;

class function TDrainReturnFluxObservationsLayer.GetParamListType: TMFCustomFluxObservationParamListClass;
begin
  result := ModflowTypes.GetMFDrainReturnFluxObservationParamListType;
end;

{ TDrainReturnFluxObsList }

constructor TDrainReturnFluxObsList.Create(
  AnOwner: T_ANE_ListOfIndexedLayerLists; Position: Integer);
var
  Index : integer;
begin
  inherited;
  for Index := 0 to StrToInt(frmMODFLOW.adeDRTObsLayerCount.Text)-1 do
  begin
    ModflowTypes.GetMFDrainReturnFluxObservationsLayerType.Create(self, -1);
  end;
end;

{ TBaseFluxObservationsLayer }

constructor TBaseFluxObservationsLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited;
  Interp := leExact;
//  ParamList.ParameterOrder.Add(ModflowTypes.GetMFObservationGroupNumberParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFTopObsElevParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFBottomObsElevParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFTopLayerParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFBottomLayerParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFStatFlagParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFPlotSymbolParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFFactorParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFObjectObservationNameParamClassType.WriteParamName);
//  ParamList.ParameterOrder.Add(ModflowTypes.GetMFReferenceStressPeriodParamClassType.WriteParamName);

//  ModflowTypes.GetMFObservationGroupNumberParamType.Create( ParamList, -1);
  ModflowTypes.GetMFTopObsElevParamType.Create( ParamList, -1);
  ModflowTypes.GetMFBottomObsElevParamType.Create( ParamList, -1);
  ModflowTypes.GetMFTopLayerParamType.Create( ParamList, -1);
  ModflowTypes.GetMFBottomLayerParamType.Create( ParamList, -1);
  ModflowTypes.GetMFStatFlagParamType.Create( ParamList, -1);
  ModflowTypes.GetMFPlotSymbolParamType.Create( ParamList, -1);
  ModflowTypes.GetMFFactorParamType.Create( ParamList, -1);
  ModflowTypes.GetMFObjectObservationNameParamClassType.Create( ParamList, -1);
//  ModflowTypes.GetMFReferenceStressPeriodParamClassType.Create( ParamList, -1);

  NumberOfTimes := GetNumberOfTimes;
  For TimeIndex := 1 to NumberOfTimes do
  begin
    GetParamListType.Create( IndexedParamList1, -1);
  end;
end;

end.
