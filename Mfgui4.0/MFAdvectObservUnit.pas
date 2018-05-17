unit MFAdvectObservUnit;

interface

uses AnePIE, ANE_LayerUnit, SysUtils, MFGenParam, MFFluxObservationUnit;

type
  TXObsNumber = class(TObservationNumberParam)
    class Function ANE_ParamName : string ; override;
  end;

  TYObsNumber = class(TObservationNumberParam)
    class Function ANE_ParamName : string ; override;
  end;

  TZObsNumber = class(TObservationNumberParam)
    class Function ANE_ParamName : string ; override;
  end;

  TAdvObsElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TAdvObsGroupNumberParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TAdvObsLayerParam = class(TCustomLayerParam)
    class Function ANE_ParamName : string ; override;
//    constructor Create(AParameterList : T_ANE_ParameterList;
//      Index : Integer = -1); override;
//    function Units : string; override;
//    function Value : string; override;
    function ElevationName: string; override;
  end;

  TAdvObsNameParam = class(TObservationNameParam)
    function Units : string; override;
  end;

  TXStatisticParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TYStatisticParam = class(TXStatisticParam)
    class Function ANE_ParamName : string ; override;
  end;

  TZStatisticParam = class(TXStatisticParam)
    class Function ANE_ParamName : string ; override;
  end;

  TXStatFlagParam = class(TStatFlagParam)
    class Function ANE_ParamName : string ; override;
  end;

  TYStatFlagParam = class(TStatFlagParam)
    class Function ANE_ParamName : string ; override;
  end;

  TZStatFlagParam = class(TStatFlagParam)
    class Function ANE_ParamName : string ; override;
  end;

  TAdvectionObservationsStartingLayer = Class(TIndexedInfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

  TAdvectionObservationsLayer = Class(TIndexedInfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

  TAdvectionObservationList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

  TAdvectionStartingList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;


implementation

uses Variables, OptionsUnit;

ResourceString
  kAdvObsElev = 'Elevation';
  kObsGroup = 'Observation Group Number';
  kAdvObsLAYER = 'LAYER';
  kXStat = 'XStat';
  kYStat = 'YStat';
  kZStat = 'ZStat';
  kXStatFlag = 'XStat Flag';
  kYStatFlag = 'YStat Flag';
  kZStatFlag = 'ZStat Flag';
  kAdvObsStartingLAYER = 'Advection Starting Points';
  kAdvObsPointsLAYER = 'Advection Observation Points';
  KXObsNumber = 'X Observation Number';
  KYObsNumber = 'Y Observation Number';
  KZObsNumber = 'Z Observation Number';

{ TAdvObsElevParam }

class function TAdvObsElevParam.ANE_ParamName: string;
begin
  result := kAdvObsElev;
end;

function TAdvObsElevParam.Units: string;
begin
  result := LengthUnit;
end;

{ TAdvObsGroupNumberParam }

class function TAdvObsGroupNumberParam.ANE_ParamName: string;
begin
  result := kObsGroup;
end;

constructor TAdvObsGroupNumberParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

{ TAdvObsLayerParam }

class function TAdvObsLayerParam.ANE_ParamName: string;
begin
  result := kAdvObsLAYER;
end;

//constructor TAdvObsLayerParam.Create(AParameterList: T_ANE_ParameterList;
//  Index: Integer);
//begin
//  inherited;
//  ValueType := pvInteger;
//  Lock := Lock + [plDef_Val, plDont_Override];
//end;
//
//function TAdvObsLayerParam.Units: string;
//begin
//  result := 'CALCULATED'
//end;

function TAdvObsLayerParam.ElevationName: string;
begin
  result := ModflowTypes.GetMFAdvObsElevParamType.ANE_ParamName;
end;

//function TAdvObsLayerParam.Value: string;
//begin
//  result := 'MF_Layer(' + ModflowTypes.GetMFAdvObsElevParamType.ANE_ParamName
//    + ')';
//end;

{ TAdvectionObservationsStartingLayer }

class function TAdvectionObservationsStartingLayer.ANE_LayerName: string;
begin
  result := kAdvObsStartingLAYER;
end;

constructor TAdvectionObservationsStartingLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited;

  ModflowTypes.GetMFAdvObsGroupNumberParamType.Create( ParamList, -1);
  ModflowTypes.GetMFAdvObsElevParamType.Create( ParamList, -1);
  ModflowTypes.GetMFAdvObsLayerParamType.Create( ParamList, -1);

end;

function TAdvectionObservationsStartingLayer.Units: string;
begin
  result := '';
end;

{ TAdvObsNameParam }

function TAdvObsNameParam.Units: string;
begin
  result := '<= 12 characters';
end;

{ TXStatisticParam }

class function TXStatisticParam.ANE_ParamName: string;
begin
  result := kXStat
end;

function TXStatisticParam.Value: string;
begin
  result := '1';
end;

{ TYStatisticParam }

class function TYStatisticParam.ANE_ParamName: string;
begin
  result := kYStat;
end;

{ TZStatisticParam }

class function TZStatisticParam.ANE_ParamName: string;
begin
  result := kZStat;
end;

{ TXStatFlagParam }

class function TXStatFlagParam.ANE_ParamName: string;
begin
  result := kXStatFlag;
end;

{ TYStatFlagParam }

class function TYStatFlagParam.ANE_ParamName: string;
begin
  result := kYStatFlag;
end;

{ TZStatFlagParam }

class function TZStatFlagParam.ANE_ParamName: string;
begin
  result := kZStatFlag;
end;

{ TAdvectionObservationsLayer }

class function TAdvectionObservationsLayer.ANE_LayerName: string;
begin
  result := kAdvObsPointsLAYER;
end;

constructor TAdvectionObservationsLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFAdvObsNameParamType.WriteParamName);

//  ParamList.ParameterOrder.Add(ModflowTypes.GetMFObservationNumberParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFXObsNumberParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFYObsNumberParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFZObsNumberParamType.WriteParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFAdvObsGroupNumberParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFAdvObsElevParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFAdvObsLayerParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFAdvXStatisticParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFAdvObsXStatFlagParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFAdvYStatisticParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFAdvObsYStatFlagParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFAdvZStatisticParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFAdvObsZStatFlagParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFPlotSymbolParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFTimeParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIsObservationParamType.WriteParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIsPredictionParamType.WriteParamName);


  ModflowTypes.GetMFAdvObsNameParamType.Create( ParamList, -1);
  if frmModflow.cbSpecifyAdvCovariances.Checked then
  begin
//    ModflowTypes.GetMFObservationNumberParamType.Create( ParamList, -1);
    ModflowTypes.GetMFXObsNumberParamType.Create( ParamList, -1);
    ModflowTypes.GetMFYObsNumberParamType.Create( ParamList, -1);
    ModflowTypes.GetMFZObsNumberParamType.Create( ParamList, -1);
  end;
  ModflowTypes.GetMFAdvObsGroupNumberParamType.Create( ParamList, -1);
  ModflowTypes.GetMFAdvObsElevParamType.Create( ParamList, -1);
  ModflowTypes.GetMFAdvObsLayerParamType.Create( ParamList, -1);
  ModflowTypes.GetMFAdvXStatisticParamType.Create( ParamList, -1);
  ModflowTypes.GetMFAdvObsXStatFlagParamType.Create( ParamList, -1);
  ModflowTypes.GetMFAdvYStatisticParamType.Create( ParamList, -1);
  ModflowTypes.GetMFAdvObsYStatFlagParamType.Create( ParamList, -1);
  ModflowTypes.GetMFAdvZStatisticParamType.Create( ParamList, -1);
  ModflowTypes.GetMFAdvObsZStatFlagParamType.Create( ParamList, -1);
  ModflowTypes.GetMFPlotSymbolParamType.Create( ParamList, -1);
  ModflowTypes.GetMFTimeParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsObservationParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsPredictionParamType.Create( ParamList, -1);
end;

function TAdvectionObservationsLayer.Units: string;
begin
  result := '';
end;

{ TAdvectionObservationList }

constructor TAdvectionObservationList.Create(
  AnOwner: T_ANE_ListOfIndexedLayerLists; Position: Integer);
var
  Index : integer;
begin
  inherited;
  for Index := 0 to StrToInt(frmMODFLOW.adeAdvectObsLayerCount.Text)-1 do
  begin
    ModflowTypes.GetMFAdvectionObservationsLayerType.Create(self, -1);
  end;
end;

{ TAdvectionStartingList }

constructor TAdvectionStartingList.Create(
  AnOwner: T_ANE_ListOfIndexedLayerLists; Position: Integer);
var
  Index : integer;
begin
  inherited;
  for Index := 0 to StrToInt(frmMODFLOW.adeAdvectObsStartLayerCount.Text)-1 do
  begin
    ModflowTypes.GetMFAdvectionObservationsStartingLayerType.Create(self, -1);
  end;
end;

{ TYObsNumber }

class function TYObsNumber.ANE_ParamName: string;
begin
  result := KYObsNumber;
end;

{ TXObsNumber }

class function TXObsNumber.ANE_ParamName: string;
begin
  result := KXObsNumber;
end;

{ TZObsNumber }

class function TZObsNumber.ANE_ParamName: string;
begin
  result := KZObsNumber;
end;

end.
