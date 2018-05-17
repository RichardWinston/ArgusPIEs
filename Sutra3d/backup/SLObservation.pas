unit SLObservation;

interface

uses SysUtils, ANE_LayerUnit, SLCustomLayers;

type
  TIsObservedParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
  end;

  TObservationTypeParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
  end;

  TObservationName = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TCombineObs = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Units: string; override;
  end;

  // TCustomStatFlag is used primarily to identify descendents in
  // frmSutraContourImporterUnit.
  TCustomStatFlag = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

//  TPressureHeadStatFlag = class(TCustomStatFlag)
//    class function ANE_ParamName: string; override;
//    class function WriteParamName: string; override;
//  end;
//
//  TConcentrationTemperatureStatFlag = class(TCustomStatFlag)
//    class function ANE_ParamName: string; override;
//    class function WriteParamName: string; override;
//  end;
//
//  TSaturationStatFlag = class(TCustomStatFlag)
//    class function ANE_ParamName: string; override;
//  end;
//
//  TFluxStatFlag = class(TCustomStatFlag)
//    class function ANE_ParamName: string; override;
//  end;
//
//  TSoluteFluxStatFlag = class(TCustomStatFlag)
//    class function ANE_ParamName: string; override;
//    class function WriteParamName: string; override;
//  end;


{  TCustomPlotSymbol = class(T_ANE_LayerParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TPressureHeadPlotSymbol = class(TCustomPlotSymbol)
    class function ANE_ParamName: string; override;
    class function WriteParamName: string; override;
  end;

  TConcentrationTemperaturePlotSymbol = class(TCustomPlotSymbol)
    class function ANE_ParamName: string; override;
    class function WriteParamName: string; override;
  end;

  TSaturationPlotSymbol = class(TCustomPlotSymbol)
    class function ANE_ParamName: string; override;
  end;

  TFluxPlotSymbol = class(TCustomPlotSymbol)
    class function ANE_ParamName: string; override;
  end;

  TSoluteFluxPlotSymbol = class(TCustomPlotSymbol)
    class function ANE_ParamName: string; override;
    class function WriteParamName: string; override;
  end;   }

  TCustomObservationTime = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
  end;

//  TPressureHeadObservationTime = class(T_ANE_LayerParam)
//    class function ANE_ParamName: string; override;
//    function WriteName: string; override;
//    class function WriteParamName: string; override;
//  end;
//
//  TConcentrationTemperatureObservationTime = class(TCustomObservationTime)
//    class function ANE_ParamName: string; override;
//    function WriteName: string; override;
//    class function WriteParamName: string; override;
//  end;
//
//  TSaturationObservationTime = class(TCustomObservationTime)
//    class function ANE_ParamName: string; override;
//  end;
//
//  TFluxObservationTime = class(TCustomObservationTime)
//    class function ANE_ParamName: string; override;
//  end;
//
//  TSoluteFluxObservationTime = class(TCustomObservationTime)
//    class function ANE_ParamName: string; override;
//    function WriteName: string; override;
//    class function WriteParamName: string; override;
//  end;

  TValue = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
  end;

//  TPressureHeadValue = class(T_ANE_LayerParam)
//    class function ANE_ParamName: string; override;
//    class function WriteParamName: string; override;
//  end;
//
//  TConcentrationTemperatureValue = class(T_ANE_LayerParam)
//    class function ANE_ParamName: string; override;
//    class function WriteParamName: string; override;
//  end;
//
//  TSaturationValue = class(T_ANE_LayerParam)
//    class function ANE_ParamName: string; override;
//  end;
//
  TFluxValue = class(TValue)
//    class function ANE_ParamName: string; override;
    function Units: string; override;
  end;
//
  TSoluteFluxValue = class(TValue)
//    class function ANE_ParamName: string; override;
//    class function WriteParamName: string; override;
    function Units: string; override;
  end;

  TStatistic = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
  end;

//  TPressureHeadStatistic = class(T_ANE_LayerParam)
//    class function ANE_ParamName: string; override;
//    class function WriteParamName: string; override;
//  end;
//
//  TConcentrationTemperatureStatistic = class(T_ANE_LayerParam)
//    class function ANE_ParamName: string; override;
//    class function WriteParamName: string; override;
//  end;

//  TSaturationStatistic = class(T_ANE_LayerParam)
//    class function ANE_ParamName: string; override;
//  end;

//  TFluxStatistic = class(T_ANE_LayerParam)
//    class function ANE_ParamName: string; override;
//  end;

//  TSoluteFluxStatistic = class(T_ANE_LayerParam)
//    class function ANE_ParamName: string; override;
//    class function WriteParamName: string; override;
//  end;

  TPressureObsTimeList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer = -1); override;
  end;

  TConcentrationObsTimeList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer = -1); override;
  end;

  TSaturationObsTimeList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer = -1); override;
  end;

  TFluxObsTimeList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer = -1); override;
  end;

  TSoluteFluxObsTimeList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer = -1); override;
  end;

  T2DObservationLayer = class(TSutraInfoLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  T2dUcodeHeadObservationLayer = class(TSutraInfoLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot : string; override;
  end;

  T2dUcodeConcentrationObservationLayer = class(TSutraInfoLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot : string; override;
  end;

  T2dUcodeSaturationObservationLayer = class(TSutraInfoLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  T2dUcodeFluxObservationLayer = class(TSutraInfoLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot : string; override;
  end;

  T2dUcodeSoluteFluxObservationLayer = class(TSutraInfoLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot : string; override;
  end;

  TCustom3DObservationLayer = class(TSutraInfoLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    function WriteIndex: string; override;
    function WriteOldIndex: string; override;
  end;

  TPoint3DObservationLayer = class(TCustom3DObservationLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TCustomNonPointObservationLayer = class(TCustom3DObservationLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TLine3DObservationLayer = class(TCustomNonPointObservationLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TVerticalSheet3DObservationLayer = class(TCustomNonPointObservationLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TSlantedSheet3DObservationLayer = class(TCustomNonPointObservationLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TVol3DObservationLayer = class(TCustomNonPointObservationLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TBottomObservationLayer = class(T2DObservationLayer)
    class function ANE_LayerName: string; override;
    class function WriteNewRoot: string; override;
    class function WriteSuffix: string; virtual;
  end;

  TTopObservationLayer = class(TBottomObservationLayer)
    class function WriteSuffix: string; override;
    class function WriteNewRoot: string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers, SLGeneralParameters;

resourcestring
  kIsObserved = 'is_observed';
  kObservation = 'SUTRA Observations';
  kObservationType = 'Observation output format';
  KUcodeHeadObservation = 'Generalized Head Observation';
  KUcodeConcentrationObservation = 'Generalized Conc or Temp Observation';
  KUcodeSaturationObservation = 'Generalized Saturation Observation';
  KUcodeFluxObservation = 'Generalized Observation Fluid Flow Rate at Spec P';
  KUcodeSoluteFluxObservation = 'Generalized Observation U Flow Rate at Spec P';
//  {$IFDEF SUTRA21}
  kPointObservation = 'SUTRA Observation Points';
  kLineObservation = 'SUTRA Observation Lines';
  kVerticalSheetObservation = 'SUTRA Observation Sheets Vertical';
  kSlantedSheetObservation = 'SUTRA Observation Sheets Slanted';
  kVolObservation = 'SUTRA Observation Solids';
//  {$ELSE}
//  kPointObservation = 'Observation Points';
//  kLineObservation = 'Observation Lines';
//  kVerticalSheetObservation = 'Observation Sheets Vertical';
//  kSlantedSheetObservation = 'Observation Sheets Slanted';
//  kVolObservation = 'Observation Solids';
//  {$ENDIF}

  kObsTime = 'Obs Time';
  kPressHeadObsTime = 'Pres or Head Obs Time';
  kConcTempObsTime = 'Conc or Temp Obs Time';
  kSaturationObsTime = 'Sat Obs Time';
  kFluxObsTime = 'Flux Obs Time';
  kSoluteFluxObsTime = 'Solute or Heat Flux Obs Time';

  kObsName = 'Obs Name';
  kCombineObs = 'Combine Obs Values';

  kValue = 'Value';
  kPressureValue = 'Pres or Head Value';
  kConcentrationValue = 'Conc or Temp Value';
  kSaturationValue = 'Sat Value';
  kFluxValue = 'Flux Value';
  kSoluteFluxValue = 'Solute or Heat Flux Value';

  kStatFlag = 'Statistic Type';
  kPressureStatFlag = 'Pres or Head Stat Flag';
  kConcentrationStatFlag = 'Conc or Temp Stat Flag';
  kSaturationStatFlag = 'Sat Stat Flag';
  kFluxStatFlag = 'Flux Stat Flag';
  kConcentationFluxStatFlag = 'Flux Stat Flag';
  kSoluteFluxStatFlag = 'Solute or Heat Flux Stat Flag';

  kPressurePlotSymbol = 'Pres or Head Plot Symbol';
  kConcentrationPlotSymbol = 'Conc or Temp Plot Symbol';
  kSaturationPlotSymbol = 'Sat Plot Symbol';
  kFluxPlotSymbol = 'Flux Plot Symbol';
  kSoluteFluxPlotSymbol = 'Solute or Heat Flux Plot Symbol';

  kStatistic = 'Statistic';
  kPressureStatistic = 'Pres or Head Statistic';
  kConcentrationStatistic = 'Conc or Temp Statistic';
  kSaturationStatistic = 'Sat Statistic';
  kFluxStatistic = 'Flux Statistic';
  kSoluteFluxStatistic = 'Solute or Heat Flux Statistic';

  { TIsObservedParam }

class function TIsObservedParam.ANE_ParamName: string;
begin
  result := kIsObserved;
end;

constructor TIsObservedParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TIsObservedParam.Units: string;
begin
  result := 'True or False';
end;

{ TObservationLayer }

class function T2DObservationLayer.ANE_LayerName: string;
begin
  result := kObservation;
end;

constructor T2DObservationLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
//var
//  ParameterIndex : integer;
begin
  inherited;
  Interp := leExact;

//  ParamList.ParameterOrder.Add(TObservationName.ANE_ParamName);
  ParamList.ParameterOrder.Add(TIsObservedParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TObservationTypeParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCommentParam.ANE_ParamName);

{  ParamList.ParameterOrder.Add(TCombineObs.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPressureHeadStatFlag.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPressureHeadPlotSymbol.ANE_ParamName);

  ParamList.ParameterOrder.Add(TConcentrationTemperatureStatFlag.ANE_ParamName);
  ParamList.ParameterOrder.Add(TConcentrationTemperaturePlotSymbol.ANE_ParamName);

  ParamList.ParameterOrder.Add(TSaturationStatFlag.ANE_ParamName);
  ParamList.ParameterOrder.Add(TSaturationPlotSymbol.ANE_ParamName);  }

  TIsObservedParam.Create(ParamList, -1);
  TObservationTypeParam.Create(ParamList, -1);
  TCommentParam.Create(ParamList, -1);

{  if frmSutra.cbInverse.Checked or
    frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TCombineObs.Create(ParamList, -1);
    TObservationName.Create(ParamList, -1);
    TPressureHeadStatFlag.Create(ParamList, -1);
    TPressureHeadPlotSymbol.Create(ParamList, -1);
    TConcentrationTemperatureStatFlag.Create(ParamList, -1);
    TConcentrationTemperaturePlotSymbol.Create(ParamList, -1);
    if frmSutra.rbSatUnsat.Checked then
    begin
      TSaturationStatFlag.Create(ParamList, -1);
      TSaturationPlotSymbol.Create(ParamList, -1);
    end;

    for ParameterIndex := 0 to StrToInt(frmSutra.adeObservationTimes.Text) -1 do
    begin
      TPressureObsTimeList.Create(IndexedParamList0, ParameterIndex);
      TConcentrationObsTimeList.Create(IndexedParamList1, ParameterIndex);
      if frmSutra.rbSatUnsat.Checked then
      begin
        TSaturationObsTimeList.Create(IndexedParamList2, ParameterIndex);
      end;
    end;
  end;  }
end;

{
class function T2DObservationLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraNodeSurfaceGroupLayer.UpperLowerName;
  end;
end;
}

function TIsObservedParam.Value: string;
begin
  result := 'IsNumber(ContourType())';
end;

{ TCustom3DObservationLayer }

constructor TCustom3DObservationLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := leExact;

  //  ParamList.ParameterOrder.Add(TFollowMeshParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TContourType.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCommentParam.ANE_ParamName);

  //  TFollowMeshParam.Create(ParamList, -1);
  TContourType.Create(ParamList, -1);
  TCommentParam.Create(ParamList, -1);
end;

function TCustom3DObservationLayer.WriteIndex: string;
begin
  if LayerList is T_TypedIndexedLayerList then
  begin
    result := T_TypedIndexedLayerList(LayerList).LayerIndex(self);
  end
  else
  begin
    result := inherited WriteIndex;
  end;
end;

function TCustom3DObservationLayer.WriteOldIndex: string;
begin
  result := WriteIndex;
end;

{ TPoint3DObservationLayer }

class function TPoint3DObservationLayer.ANE_LayerName: string;
begin
  result := kPointObservation;
end;

constructor TPoint3DObservationLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  //  Position := ParamList.ParameterOrder.IndexOf(
  //    TFollowMeshParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(0, TElevationParam.ANE_ParamName);
  TElevationParam.Create(ParamList, -1);
end;

{ TLine3DObservationLayer }

class function TLine3DObservationLayer.ANE_LayerName: string;
begin
  result := kLineObservation;
end;

constructor TLine3DObservationLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TFollowMeshParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TBeginElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 1,
    TEndElevaParam.ANE_ParamName);

  TBeginElevaParam.Create(ParamList, -1);
  TEndElevaParam.Create(ParamList, -1);
end;

{ TVerticalSheet3DObservationLayer }

class function TVerticalSheet3DObservationLayer.ANE_LayerName: string;
begin
  result := kVerticalSheetObservation;
end;

constructor TVerticalSheet3DObservationLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TFollowMeshParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TBeginTopElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 1,
    TEndTopElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 2,
    TBeginBottomElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 3,
    TEndBottomElevaParam.ANE_ParamName);

  TBeginTopElevaParam.Create(ParamList, -1);
  TEndTopElevaParam.Create(ParamList, -1);
  TBeginBottomElevaParam.Create(ParamList, -1);
  TEndBottomElevaParam.Create(ParamList, -1);
end;

{ TSlantedSheet3DObservationLayer }

class function TSlantedSheet3DObservationLayer.ANE_LayerName: string;
begin
  result := kSlantedSheetObservation;
end;

constructor TSlantedSheet3DObservationLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TFollowMeshParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TX1Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 1,
    TY1Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 2,
    TZ1Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 3,
    TX2Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 4,
    TY2Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 5,
    TZ2Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 6,
    TX3Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 7,
    TY3Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 8,
    TZ3Param.ANE_ParamName);

  TX1Param.Create(ParamList, -1);
  TY1Param.Create(ParamList, -1);
  TZ1Param.Create(ParamList, -1);
  TX2Param.Create(ParamList, -1);
  TY2Param.Create(ParamList, -1);
  TZ2Param.Create(ParamList, -1);
  TX3Param.Create(ParamList, -1);
  TY3Param.Create(ParamList, -1);
  TZ3Param.Create(ParamList, -1);
end;

{ TVol3DObservationLayer }

class function TVol3DObservationLayer.ANE_LayerName: string;
begin
  result := kVolObservation;
end;

constructor TVol3DObservationLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TFollowMeshParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TZeroTopElevParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 1,
    TBottomElevaParam.ANE_ParamName);

  TZeroTopElevParam.Create(ParamList, -1);
  TBottomElevaParam.Create(ParamList, -1);
end;

{ TCustomNonPointObservationLayer }

constructor TCustomNonPointObservationLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Insert(0, TFollowMeshParam.ANE_ParamName);
  TFollowMeshParam.Create(ParamList, -1);

end;

{ TBottomObservationLayer }

class function TBottomObservationLayer.ANE_LayerName: string;
begin
  result := kObservation + WriteSuffix;
end;

class function TBottomObservationLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if (frmSutra = nil) or frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;

class function TBottomObservationLayer.WriteSuffix: string;
begin
  result := ' Bottom';
end;

{ TTopObservationLayer }

class function TTopObservationLayer.WriteNewRoot: string;
begin
  result := ANE_LayerName;
end;

class function TTopObservationLayer.WriteSuffix: string;
begin
  result := ' Top';
end;

{ TPressureHeadObservationTime }

//class function TPressureHeadObservationTime.ANE_ParamName: string;
//begin
//  result := kPressHeadObsTime;
//end;
//
//function TPressureHeadObservationTime.WriteName: string;
//begin
//  result := WriteParamName;
//end;
//
//class function TPressureHeadObservationTime.WriteParamName: string;
//begin
//  case frmSutra.StateVariableType of
//    svPressure:
//      begin
//        result := 'Pres Obs Time';
//      end;
//    svHead:
//      begin
//        result := 'Head Obs Time';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TConcentrationTempaeratureObservationTime }

//class function TConcentrationTemperatureObservationTime.ANE_ParamName: string;
//begin
//  result := kConcTempObsTime;
//end;
//
//function TConcentrationTemperatureObservationTime.WriteName: string;
//begin
//  result := WriteParamName;
//end;
//
//class function TConcentrationTemperatureObservationTime.WriteParamName: string;
//begin
//  case frmSutra.TransportType of
//    ttGeneral:
//      begin
//        result := ANE_ParamName;
//      end;
//    ttEnergy:
//      begin
//        result := 'Temp Obs Time';
//      end;
//    ttSolute:
//      begin
//        result := 'Conc Obs Time';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TPressureObsTimeList }

constructor TPressureObsTimeList.Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
  Position: Integer);
begin
  inherited;
  ParameterOrder.Add(TCustomObservationTime.ANE_ParamName);
  ParameterOrder.Add(TValue.ANE_ParamName);
  ParameterOrder.Add(TStatistic.ANE_ParamName);

  TCustomObservationTime.Create(self, -1);
  if frmSutra.cbInverse.Checked or
    frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TValue.Create(self, -1);
    TStatistic.Create(self, -1);
  end;
end;

{ TPressureHeadValue }

//class function TPressureHeadValue.ANE_ParamName: string;
//begin
//  result := kPressureValue;
//end;
//
//class function TPressureHeadValue.WriteParamName: string;
//begin
//  case frmSutra.StateVariableType of
//    svPressure:
//      begin
//        result := 'Pres Value';
//      end;
//    svHead:
//      begin
//        result := 'Head Value';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TConcentrationTemperatureValue }

//class function TConcentrationTemperatureValue.ANE_ParamName: string;
//begin
//  result := kConcentrationValue;
//end;
//
//class function TConcentrationTemperatureValue.WriteParamName: string;
//begin
//  case frmSutra.TransportType of
//    ttGeneral:
//      begin
//        result := ANE_ParamName;
//      end;
//    ttEnergy:
//      begin
//        result := 'Temp Value';
//      end;
//    ttSolute:
//      begin
//        result := 'Conc Value';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TObservationName }

class function TObservationName.ANE_ParamName: string;
begin
  result := kObsName;
end;

constructor TObservationName.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

{ TPressureHeadStatFlag }

//class function TPressureHeadStatFlag.ANE_ParamName: string;
//begin
//  result := kPressureStatFlag;
//end;
//
//class function TPressureHeadStatFlag.WriteParamName: string;
//begin
//  case frmSutra.StateVariableType of
//    svPressure:
//      begin
//        result := 'Pres Stat Flag';
//      end;
//    svHead:
//      begin
//        result := 'Head Stat Flag';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TConcentrationTemperatureStatFlag }

//class function TConcentrationTemperatureStatFlag.ANE_ParamName: string;
//begin
//  result := kConcentrationStatFlag;
//end;
//
//class function TConcentrationTemperatureStatFlag.WriteParamName: string;
//begin
//  case frmSutra.TransportType of
//    ttGeneral:
//      begin
//        result := ANE_ParamName;
//      end;
//    ttEnergy:
//      begin
//        result := 'Temp Stat Flag';
//      end;
//    ttSolute:
//      begin
//        result := 'Conc Stat Flag';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TPressureHeadPlotSymbol }

{class function TPressureHeadPlotSymbol.ANE_ParamName: string;
begin
  result := kPressurePlotSymbol;
end;

class function TPressureHeadPlotSymbol.WriteParamName: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := 'Pres Plot Symbol';
      end;
    svHead:
      begin
        result := 'Head Plot Symbol';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;  }

{ TConcentrationTemperaturePlotSymbol }

{class function TConcentrationTemperaturePlotSymbol.ANE_ParamName: string;
begin
  result := kConcentrationPlotSymbol;
end;

class function TConcentrationTemperaturePlotSymbol.WriteParamName: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_ParamName;
      end;
    ttEnergy:
      begin
        result := 'Temp Plot Symbol';
      end;
    ttSolute:
      begin
        result := 'Conc Plot Symbol';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;   }

{ TPressureHeadStatistic }

//class function TPressureHeadStatistic.ANE_ParamName: string;
//begin
//  result := kPressureStatistic;
//end;
//
//class function TPressureHeadStatistic.WriteParamName: string;
//begin
//  case frmSutra.StateVariableType of
//    svPressure:
//      begin
//        result := 'Pres Statistic';
//      end;
//    svHead:
//      begin
//        result := 'Head Statistic';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TConcentrationTemperatureStatistic }

//class function TConcentrationTemperatureStatistic.ANE_ParamName: string;
//begin
//  result := kConcentrationStatistic;
//end;
//
//class function TConcentrationTemperatureStatistic.WriteParamName: string;
//begin
//  case frmSutra.TransportType of
//    ttGeneral:
//      begin
//        result := ANE_ParamName;
//      end;
//    ttEnergy:
//      begin
//        result := 'Temp Statistic';
//      end;
//    ttSolute:
//      begin
//        result := 'Conc Statistic';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TConcentrationObsTimeList }

constructor TConcentrationObsTimeList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(TCustomObservationTime.ANE_ParamName);
  ParameterOrder.Add(TValue.ANE_ParamName);
  ParameterOrder.Add(TStatistic.ANE_ParamName);

  TCustomObservationTime.Create(self, -1);
  if frmSutra.cbInverse.Checked or
    frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TValue.Create(self, -1);
    TStatistic.Create(self, -1);
  end;
end;

{ TSaturationObsTimeList }

constructor TSaturationObsTimeList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(TCustomObservationTime.ANE_ParamName);
  ParameterOrder.Add(TValue.ANE_ParamName);
  ParameterOrder.Add(TStatistic.ANE_ParamName);

  TCustomObservationTime.Create(self, -1);
  if frmSutra.cbInverse.Checked or
    frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TValue.Create(self, -1);
    TStatistic.Create(self, -1);
  end;
end;

{ TSaturationStatFlag }

//class function TSaturationStatFlag.ANE_ParamName: string;
//begin
//  result := kSaturationStatFlag;
//end;

{ TSaturationPlotSymbol }

{class function TSaturationPlotSymbol.ANE_ParamName: string;
begin
  result := kSaturationPlotSymbol;
end;    }

{ TSaturationObservationTime }

//class function TSaturationObservationTime.ANE_ParamName: string;
//begin
//  result := kSaturationObsTime;
//end;

{ TSaturationValue }

//class function TSaturationValue.ANE_ParamName: string;
//begin
//  result := kSaturationValue;
//end;

{ TSaturationStatistic }

//class function TSaturationStatistic.ANE_ParamName: string;
//begin
//  result := kSaturationStatistic;
//end;

{ TCustomStatFlag }

class function TCustomStatFlag.ANE_ParamName: string;
begin
  result := kStatFlag;
end;

constructor TCustomStatFlag.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TCustomStatFlag.Units: string;
begin
  result := '-1, 0, 1, or 2';
end;

{ TCombineObs }

class function TCombineObs.ANE_ParamName: string;
begin
  result := kCombineObs;
end;

constructor TCombineObs.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TCombineObs.Units: string;
begin
  result := '0 to 3';
end;

{ T2dUcodeHeadObservationLayer }

class function T2dUcodeHeadObservationLayer.ANE_LayerName: string;
begin
  result := KUcodeHeadObservation;
end;

constructor T2dUcodeHeadObservationLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  ParameterIndex : integer;
begin
  inherited;
  Interp := leExact;

  ParamList.ParameterOrder.Add(TObservationName.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCombineObs.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCustomStatFlag.ANE_ParamName);

  TObservationName.Create(ParamList, -1);
  if frmSutra.cbInverse.Checked or
    frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TCombineObs.Create(ParamList, -1);
    TCustomStatFlag.Create(ParamList, -1);
  end;

  for ParameterIndex := 0 to StrToInt(frmSutra.adeObservationTimes.Text) -1 do
  begin
    TPressureObsTimeList.Create(IndexedParamList0, ParameterIndex);
  end;
end;

class function T2dUcodeHeadObservationLayer.WriteNewRoot: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := 'Generalized Pressure Observation';
      end;
    svHead:
      begin
        result := ANE_LayerName;
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ T2dUcodeConcentrationObservationLayer }

class function T2dUcodeConcentrationObservationLayer.ANE_LayerName: string;
begin
  result := KUcodeConcentrationObservation;
end;

constructor T2dUcodeConcentrationObservationLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  ParameterIndex : integer;
begin
  inherited;
  Interp := leExact;

  ParamList.ParameterOrder.Add(TObservationName.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCombineObs.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCustomStatFlag.ANE_ParamName);

  TObservationName.Create(ParamList, -1);
  if frmSutra.cbInverse.Checked or
    frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TCombineObs.Create(ParamList, -1);
    TCustomStatFlag.Create(ParamList, -1);
  end;

  for ParameterIndex := 0 to StrToInt(frmSutra.adeObservationTimes.Text) -1 do
  begin
    TConcentrationObsTimeList.Create(IndexedParamList0, ParameterIndex);
  end;
end;

class function T2dUcodeConcentrationObservationLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Generalized Temperature Observation';
      end;
    ttSolute:
      begin
        result := 'Generalized Concentration Observation';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ T2dUcodeSaturationObservationLayer }

class function T2dUcodeSaturationObservationLayer.ANE_LayerName: string;
begin
  result := KUcodeSaturationObservation;
end;

constructor T2dUcodeSaturationObservationLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  ParameterIndex : integer;
begin
  inherited;
  Interp := leExact;

  ParamList.ParameterOrder.Add(TObservationName.ANE_ParamName);

  ParamList.ParameterOrder.Add(TCombineObs.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCustomStatFlag.ANE_ParamName);

  TObservationName.Create(ParamList, -1);
  if frmSutra.cbInverse.Checked or
    frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TCombineObs.Create(ParamList, -1);
    TCustomStatFlag.Create(ParamList, -1);
  end;

  for ParameterIndex := 0 to StrToInt(frmSutra.adeObservationTimes.Text) -1 do
  begin
    TSaturationObsTimeList.Create(IndexedParamList0, ParameterIndex);
  end;
end;

{ TCustomPlotSymbol }

{constructor TCustomPlotSymbol.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;   }

{ TFluxStatFlag }

//class function TFluxStatFlag.ANE_ParamName: string;
//begin
//  result := kFluxStatFlag;
//end;

{ TFluxPlotSymbol }

//class function TFluxPlotSymbol.ANE_ParamName: string;
//begin
//  result := kFluxPlotSymbol;
//end;

{ T2dUcodeFluxObservationLayer }

class function T2dUcodeFluxObservationLayer.ANE_LayerName: string;
begin
  result := KUcodeFluxObservation;
end;

constructor T2dUcodeFluxObservationLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  ParameterIndex : integer;
begin
  inherited;
  Interp := leExact;

  ParamList.ParameterOrder.Add(TObservationName.ANE_ParamName);

  ParamList.ParameterOrder.Add(TCombineObs.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCustomStatFlag.ANE_ParamName);

  TObservationName.Create(ParamList, -1);
  if frmSutra.cbInverse.Checked or
    frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TCombineObs.Create(ParamList, -1);
    TCustomStatFlag.Create(ParamList, -1);
  end;

  for ParameterIndex := 0 to StrToInt(frmSutra.adeObservationTimes.Text) -1 do
  begin
    TFluxObsTimeList.Create(IndexedParamList0, ParameterIndex);
  end;
end;

class function T2dUcodeFluxObservationLayer.WriteNewRoot: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := ANE_LayerName;
      end;
    svHead:
      begin
        result := 'Generalized Observation Fluid Flow Rate at Spec H';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TFluxObservationTime }

//class function TFluxObservationTime.ANE_ParamName: string;
//begin
//  result := kFluxObsTime;
//end;

{ TFluxValue }

//class function TFluxValue.ANE_ParamName: string;
//begin
//  result := kFluxValue;
//end;
//

function TFluxValue.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := 'M/s';
      end;
    svHead:
      begin
        result := 'L^3/s';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TFluxStatistic }

//class function TFluxStatistic.ANE_ParamName: string;
//begin
//  result := kFluxStatistic;
//end;

{ TFluxObsTimeList }

constructor TFluxObsTimeList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(TCustomObservationTime.ANE_ParamName);
  ParameterOrder.Add(TFluxValue.ANE_ParamName);
  ParameterOrder.Add(TStatistic.ANE_ParamName);

  TCustomObservationTime.Create(self, -1);
  if frmSutra.cbInverse.Checked or
    frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TFluxValue.Create(self, -1);
    TStatistic.Create(self, -1);
  end;
end;

{ TSoluteFluxStatFlag }

//class function TSoluteFluxStatFlag.ANE_ParamName: string;
//begin
//  result := kSoluteFluxStatFlag;
//end;
//
//class function TSoluteFluxStatFlag.WriteParamName: string;
//begin
//  case frmSutra.TransportType of
//    ttGeneral:
//      begin
//        result := ANE_ParamName;
//      end;
//    ttEnergy:
//      begin
//        result := 'Heat Flux Stat Flag';
//      end;
//    ttSolute:
//      begin
//        result := 'Solute Flux Stat Flag';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TSoluteFluxPlotSymbol }

//class function TSoluteFluxPlotSymbol.ANE_ParamName: string;
//begin
//  result := kSoluteFluxPlotSymbol;
//end;
//
//class function TSoluteFluxPlotSymbol.WriteParamName: string;
//begin
//  case frmSutra.TransportType of
//    ttGeneral:
//      begin
//        result := ANE_ParamName;
//      end;
//    ttEnergy:
//      begin
//        result := 'Heat Flux Plot Symbol';
//      end;
//    ttSolute:
//      begin
//        result := 'Solute Flux Plot Symbol';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TCustomObservationTime }

class function TCustomObservationTime.ANE_ParamName: string;
begin
  result := kObsTime;
end;

function TCustomObservationTime.Units: string;
begin
  result := frmSutra.comboTimeUnits.Text;
end;


{ TSoluteFluxObservationTime }

//class function TSoluteFluxObservationTime.ANE_ParamName: string;
//begin
//  result := kSoluteFluxObsTime;
//end;
//
//function TSoluteFluxObservationTime.WriteName: string;
//begin
//  result := WriteParamName;
//end;
//
//class function TSoluteFluxObservationTime.WriteParamName: string;
//begin
//  case frmSutra.TransportType of
//    ttGeneral:
//      begin
//        result := ANE_ParamName;
//      end;
//    ttEnergy:
//      begin
//        result := 'Heat Flux Obs Time';
//      end;
//    ttSolute:
//      begin
//        result := 'Solute Flux Obs Time';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TSoluteFluxValue }

//class function TSoluteFluxValue.ANE_ParamName: string;
//begin
//  result := kSoluteFluxValue;
//end;

function TSoluteFluxValue.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := '(M or E)/s';
      end;
    ttEnergy:
      begin
        result := 'E/s';
      end;
    ttSolute:
      begin
        result := 'M/s';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

//class function TSoluteFluxValue.WriteParamName: string;
//begin
//  case frmSutra.TransportType of
//    ttGeneral:
//      begin
//        result := ANE_ParamName;
//      end;
//    ttEnergy:
//      begin
//        result := 'Heat Flux Value';
//      end;
//    ttSolute:
//      begin
//        result := 'Solute Flux Value';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TSoluteFluxStatistic }

//class function TSoluteFluxStatistic.ANE_ParamName: string;
//begin
//  result := kSoluteFluxStatistic;
//end;
//
//class function TSoluteFluxStatistic.WriteParamName: string;
//begin
//  case frmSutra.TransportType of
//    ttGeneral:
//      begin
//        result := ANE_ParamName;
//      end;
//    ttEnergy:
//      begin
//        result := 'Heat Flux Statistic';
//      end;
//    ttSolute:
//      begin
//        result := 'Solute Flux Statistic';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

function TCustomObservationTime.Value: string;
begin
  result := kNA;
end;

{ TSoluteFluxObsTimeList }

constructor TSoluteFluxObsTimeList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(TCustomObservationTime.ANE_ParamName);
  ParameterOrder.Add(TSoluteFluxValue.ANE_ParamName);
  ParameterOrder.Add(TStatistic.ANE_ParamName);

  TCustomObservationTime.Create(self, -1);
  if frmSutra.cbInverse.Checked or
    frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TSoluteFluxValue.Create(self, -1);
    TStatistic.Create(self, -1);
  end;
end;

{ T2dUcodeSoluteFluxObservationLayer }

class function T2dUcodeSoluteFluxObservationLayer.ANE_LayerName: string;
begin
  result := KUcodeSoluteFluxObservation;
end;

constructor T2dUcodeSoluteFluxObservationLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  ParameterIndex : integer;
begin
  inherited;
  Interp := leExact;

  ParamList.ParameterOrder.Add(TObservationName.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCombineObs.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCustomStatFlag.ANE_ParamName);

  TObservationName.Create(ParamList, -1);
  if frmSutra.cbInverse.Checked or
    frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TCombineObs.Create(ParamList, -1);
    TCustomStatFlag.Create(ParamList, -1);
  end;

  for ParameterIndex := 0 to StrToInt(frmSutra.adeObservationTimes.Text) -1 do
  begin
    TSoluteFluxObsTimeList.Create(IndexedParamList0, ParameterIndex);
  end;
end;

class function T2dUcodeSoluteFluxObservationLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_LayerName;
      end;
    ttEnergy:
      begin
        case frmSutra.StateVariableType of
          svPressure:
            begin
              result := 'Generalized Observation Heat Flow Rate at Spec P';
            end;
          svHead:
            begin
              result := 'Generalized Observation Heat Flow Rate at Spec H';
            end;
        else
          begin
            Assert(False);
          end;
        end;
      end;
    ttSolute:
      begin
        case frmSutra.StateVariableType of
          svPressure:
            begin
              result := 'Generalized Observation Solute Flow Rate at Spec P';
            end;
          svHead:
            begin
              result := 'Generalized Observation Solute Flow Rate at Spec H';
            end;
        else
          begin
            Assert(False);
          end;
        end;
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TStatistic }

class function TStatistic.ANE_ParamName: string;
begin
  result := kStatistic;
end;

{ TValue }

class function TValue.ANE_ParamName: string;
begin
  result := kValue;
end;

{ TObservationTypeParam }

class function TObservationTypeParam.ANE_ParamName: string;
begin
  result := kObservationType;
end;

constructor TObservationTypeParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TObservationTypeParam.Units: string;
begin
  result := '1 (=obs) or 2 (=obc)';
end;

function TObservationTypeParam.Value: string;
begin
  result := '1';
end;

end.

