unit SLSutraMesh;

interface

uses SysUtils, ANE_LayerUnit;

type
  TSutraParentParameter = class(T_ANE_MeshParam)
    function WriteParentIndex: string;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TNodeParameter = class(TSutraParentParameter)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TAlwaysNodeParameter = class(TSutraParentParameter)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TCustomInverseNodeParameter = class(TNodeParameter)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TCustomInverseElementParameter = class(TSutraParentParameter)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;


  TCustomIsSourceParameter = class(TAlwaysNodeParameter)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Units: string; override;
  end;

  TElevationNodeParameter = class(TAlwaysNodeParameter)
    function Units: string; override;
  end;

  TNREGParam = class(TNodeParameter)
  public
    class function ANE_ParamName: string; override;
    function Value: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TZParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
    class function UsualValue: string;
  end;

  TPORParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
    class function UsualValue: string;
  end;

  {$IFDEF SutraIce}
  TCS1Parameter = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    class function UsualValue: string;
  end;
  {$ENDIF}

  TLREGParam = class(TSutraParentParameter)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Value: string; override;
  end;

  TPMAXParam = class(TSutraParentParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TPMIDParam = class(TPMAXParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TPMINParam = class(TPMAXParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  {$IFDEF SutraIce}
  TSIGS = class(TSutraParentParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;
  {$ENDIF}

  TCustomANGLEParam = class(TSutraParentParameter)
    //    class Function ANE_ParamName : string ; override;
    //    function Value : string; override;
    function Units: string; override;
  end;

  TANGLE1Param = class(TCustomANGLEParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    class function WriteParamName: string; override;
  end;

  TANGLE2Param = class(TANGLE1Param)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TANGLE3Param = class(TANGLE1Param)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TALMAXParam = class(TSutraParentParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TALMIDParam = class(TSutraParentParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TALMINParam = class(TSutraParentParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TAT1MAXParam = class(TSutraParentParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
    class function UsualValue: string;
  end;

  TAT1MIDParam = class(TSutraParentParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TAT1MINParam = class(TSutraParentParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
    class function UsualValue: string;
  end;

  TQINParam = class(TAlwaysNodeParameter)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
    class function UsualValue: string;
  end;

  TQIN_TopSurfaceParam = class(TQINParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TIsFluidSource = class(TCustomIsSourceParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TIsTopFluidSource = class(TCustomIsSourceParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TQINTopParam = class(TElevationNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TQINBottomParam = class(TElevationNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TUINParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
    class function UsualValue: string;
  end;

  TUIN_TopSurfaceParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TIsQUINSource = class(TCustomIsSourceParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TIsTopQUINSource = class(TCustomIsSourceParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TTimeDepFluidSourceParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Value: string; override;
  end;

  TQUINParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
    class function UsualValue: string;
  end;

  TQUIN_TopSurfaceParam = class(TQUINParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TQUINTopParam = class(TElevationNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TQUINBottomParam = class(TElevationNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TTimeDepEnergySoluteSourceParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Value: string; override;
    class function UsualValue: string;
  end;

  TPBCParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
  end;

  TPBC_CommentParam = class(TAlwaysNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TPBC_TopSurfaceParam = class(TPBCParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TIsPBCSource = class(TCustomIsSourceParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TIsTopPBCSource = class(TCustomIsSourceParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TPBCTopParam = class(TElevationNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TPBCBottomParam = class(TElevationNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TpUBCParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
    class function UsualValue: string;
  end;

  TpUBC_TopSurfaceParam = class(TpUBCParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TTimeDepSpecHeadPresParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Value: string; override;
  end;

  TUBCParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
    class function UsualValue: string;
  end;

  TUBC_TopSurfaceParam = class(TUBCParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TIsUBCSource = class(TCustomIsSourceParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TIsTopUBCSource = class(TCustomIsSourceParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TUBCTopParam = class(TElevationNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TUBCBottomParam = class(TElevationNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  {$IFDEF OldSutraIce}
  TGNUU0Param = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Value: string; override;
    class function UsualValue: string;
  end;
  {$ENDIF}

  TTimeDepSpecConcTempParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Value: string; override;
    class function UsualValue: string;
  end;

  TPVECParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TUVECParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
    class function UsualValue: string;
  end;

  TINOBParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Value: string; override;
    class function UsualValue: string;
  end;

  TINOBTypeParam = class(TNodeParameter)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Value: string; override;
  end;

  TInvNodePOR_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TInvNodeThickness_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionPOR_Param = class(TCustomInverseNodeParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodePMAX_Param = class(TCustomInverseElementParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionPMAX_Param = class(TCustomInverseElementParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodePMIN_Param = class(TCustomInverseElementParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionPMIN_Param = class(TCustomInverseElementParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodeANGLE1_Param = class(TCustomInverseElementParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionANGLE1_Param = class(TCustomInverseElementParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodeALMAX_Param = class(TCustomInverseElementParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionALMAX_Param = class(TCustomInverseElementParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodeALMIN_Param = class(TCustomInverseElementParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionALMIN_Param = class(TCustomInverseElementParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodeATMAX_Param = class(TCustomInverseElementParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionATMAX_Param = class(TCustomInverseElementParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodeATMIN_Param = class(TCustomInverseElementParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionATMIN_Param = class(TCustomInverseElementParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodeQIN_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionQIN_Param = class(TCustomInverseNodeParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodeUIN_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionUIN_Param = class(TCustomInverseNodeParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodeQUIN_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionQUIN_Param = class(TCustomInverseNodeParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodePBC_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionPBC_Param = class(TCustomInverseNodeParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodePUBC_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionPUBC_Param = class(TCustomInverseNodeParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvNodeUBC_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

//  TInvNodeFunctionUBC_Param = class(TCustomInverseNodeParameter)
//    class function ANE_ParamName: string; override;
//    function Value: string; override;
//  end;

  TInvHeadObsName_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TInvConcentrationObsName_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TInvSaturationObsName_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TInvFluxObsName_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TInvSoluteFluxObsName_Param = class(TCustomInverseNodeParameter)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TSutraNodeLayerParameters = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer = -1); override;
  end;

  TSutraMeshLayer = class(T_ANE_QuadMeshLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function ANE_LayerName: string; override;
    function WriteIndex: string; override;
    function WriteOldIndex: string; override;
    function WriteLayerRoot: string; override;
    function Units: string; override;
  end;

resourcestring
  KTop = ' Top';
  KBottom = ' Bottom Unit';

implementation

uses SLUnsaturated, SLThickness, SLPorosity, SLPermeability, SLDispersivity,
  SLSourcesOfFluid, SLGeneralParameters, SLEnergySoluteSources,
  SLSpecifiedPressure, SLSpecConcOrTemp, SLInitialPressure, SLInitConcOrTemp,
  SLObservation, SLDomainDensity, frmSutraUnit, OptionsUnit, SLSpecificHeat,
  SLThermalConductivity;

resourcestring
  kNREG = 'NREG';
  kZ = 'Z';
  kPOR = 'POR';
  kCS1 = 'CS1';
  kLREG = 'LREG';
  kPMAX = 'PMAX';
  kPMID = 'PMID';
  kPMIN = 'PMIN';
  kSIGS = 'SIGS';
  kANGLEX = 'ANGLEX';
  kANGLE1 = 'ANGLE1';
  kANGLE2 = 'ANGLE2';
  kANGLE3 = 'ANGLE3';
  kALMAX = 'ALMAX';
  kALMID = 'ALMID';
  kALMIN = 'ALMIN';
  kAT1MAX = 'ATMAX';
  kAT1MID = 'ATMID';
  kAT1MIN = 'ATMIN';
  kQIN = 'QIN';
  kTopQIN = 'Top QIN';
  kIsFluidSource = 'IS_FLUID_SOURCE';
  kTopIsFluidSource = 'Top IS_FLUID_SOURCE';
  kQINtop = 'QIN top';
  kQINbottom = 'QIN bottom';
  kUIN = 'UIN';
  kTopUIN = 'Top UIN';
  kTimeDependentFluidSources = 'time_dependent_fluid_sources';
  kTopTimeDependentFluidSources = 'Top time_dependent_fluid_sources';
  kQUIN = 'QUIN';
  kIsQUINSource = 'IS_QUIN_SOURCE';
  kTopIsQUINSource = 'Top IS_QUIN_SOURCE';
  kQUINtop = 'QUIN top';
  kQUINbottom = 'QUIN bottom';
  kTopQUIN = 'Top QUIN';
  kTimeDependentEnergyOrSoluteSources
    = 'time_dependent_energy_or_solute_sources';
  kTopTimeDependentEnergyOrSoluteSources
    = 'Top time_dependent_energy_or_solute_sources';
  kPBC = 'PBC';
  ktopPBC = 'Top PBC';
  kIsPBCSource = 'IS_PBC_SOURCE';
  kTopIsPBCSource = 'Top IS_PBC_SOURCE';
  kPBCtop = 'PBC top';
  kPBC_Comment = 'PBC Comment';
  kPBCbottom = 'PBC bottom';
  kpUBC = 'pUBC';
  kToppUBC = 'Top pUBC';
  kTimeDependentSpecifiedHeadOrPressure
    = 'time_dependent_specified_head_or_pressure';
  kTopTimeDependentSpecifiedHeadOrPressure
    = 'Top time_dependent_specified_head_or_pressure';
  kUBC = 'UBC';
  kTopUBC = 'Top UBC';
  kIsUBCSource = 'IS_UBC_SOURCE';
  kTopIsUBCSource = 'Top IS_UBC_SOURCE';
  kUBCtop = 'UBC top';
  kUBCbottom = 'UBC bottom';

  kGNUU0 = 'GNUU0';

  kTimeDependentSpecifiedConcentrationOrTemperature
    = 'time_dependent_specified_concentration_or_temperature';
  kTopTimeDependentSpecifiedConcentrationOrTemperature
    = 'Top time_dependent_specified_concentration_or_temperature';
  kPVEC = 'PVEC';
  kUVEC = 'UVEC';
  kINOB = 'INOB';
  kObsType = 'ObsType';
  kSutraMesh = 'SUTRA Mesh';

  kInvTHICK = 'UString_THICK';
  kInvPOR = 'UString_POR';
  kInvPMAX = 'UString_PMAX';
  kInvPMIN = 'UString_PMIN';
  kInvANGLE1 = 'UString_ANGLE1';
  kInvALMAX = 'UString_ALMAX';
  kInvALMIN = 'UString_ALMIN';
  kInvATMAX = 'UString_ATMAX';
  kInvATMIN = 'UString_ATMIN';
  kInvQIN = 'UString_QIN';
  kInvUIN = 'UString_UIN';
  kInvQUIN = 'UString_QUIN';
  kInvPBC = 'UString_PBC';
  kInvPUBC = 'UString_pUBC';
  kInvUBC = 'UString_UBC';

//  kInvFunctionPOR = 'UFunction_POR';
//  kInvFunctionPMAX = 'UFunction_PMAX';
//  kInvFunctionPMIN = 'UFunction_PMIN';
//  kInvFunctionANGLE1 = 'UFunction_ANGLE1';
//  kInvFunctionALMAX = 'UFunction_ALMAX';
//  kInvFunctionALMIN = 'UFunction_ALMIN';
//  kInvFunctionATMAX = 'UFunction_ATMAX';
//  kInvFunctionATMIN = 'UFunction_ATMIN';
//  kInvFunctionQIN = 'UFunction_QIN';
//  kInvFunctionUIN = 'UFunction_UIN';
//  kInvFunctionQUIN = 'UFunction_QUIN';
//  kInvFunctionPBC = 'UFunction_PBC';
//  kInvFunctionPUBC = 'UFunction_pUBC';
//  kInvFunctionUBC = 'UFunction_UBC';

  kUcode_P_Observation = 'Ucode_P_Observation';
  kUcode_U_Observation = 'Ucode_U_Observation';
  kUcode_Sat_Observation = 'Ucode_Sat_Observation';
  kUcode_Flux_Observation = 'Ucode_Flux_Observation';
  kUcode_Solute_Flux_Observation = 'Ucode_U_Flux_Observation';

  { TSutraParentParameter }

constructor TSutraParentParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  if frmSutra.rb3D_nva.Checked then
  begin
    ParameterType := mptLayer;
  end;
end;

function TSutraParentParameter.WriteParentIndex: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := GetParentLayer.WriteIndex;
    if result = '' then
    begin
      result := '1';
    end
    else
    begin
      result := IntToStr(StrToInt(result) + 1)
    end;
  end
  else
  begin
    result := inherited WriteIndex;
  end;

end;

{ TNodeParameter }

constructor TNodeParameter.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  if not frmSutra.rb3D_nva.Checked then
  begin
    ParameterType := mptNode;
  end;
end;

{ TAlwaysNodeParameter }

constructor TAlwaysNodeParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
end;

{ TElevationNodeParameter }

function TElevationNodeParameter.Units: string;
begin
  result := 'L';
end;

{ TNREGParam }

class function TNREGParam.ANE_ParamName: string;
begin
  result := kNREG;
end;

constructor TNREGParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TNREGParam.Value: string;
begin
  with frmSutra do
  begin
    if rbSatUnsat.Checked or rbFreezing.Checked or rbGeneral.Checked then
    begin
      if is3D then
      begin
        result := TUnsaturatedLayer.WriteNewRoot + WriteParentIndex + '.'
          + TRegionParam.WriteParamName;
      end
      else
      begin
        result := TUnsaturatedLayer.WriteNewRoot + '.'
          + TRegionParam.WriteParamName;
      end;
    end
    else
    begin
      result := '0';
    end; 
  end;
end;

{ TTHICKParam }

class function TZParam.ANE_ParamName: string;
begin
  result := kZ;
end;

function TZParam.Units: string;
begin
  result := 'L';
end;

class function TZParam.UsualValue: string;
begin
  with frmSutra do
  begin
    if rbGeneral.Checked or
      (rbSpecific.Checked and rbUserSpecifiedThickness.Checked) then
    begin
      result := TThicknessLayer.WriteNewRoot + '.'
        + TThicknessParam.WriteParamName;
    end
    else
    begin
      result := 'If(X()>=0, ' + FloatToStr(Pi) + ', $n/a)';
    end;
  end;
end;

function TZParam.Value: string;
begin
  with frmSutra do
  begin
    if rbGeneral.Checked or
      (rbSpecific.Checked and rbUserSpecifiedThickness.Checked) then
    begin
      if Is3D then
      begin
        if WriteParentIndex = '1' then
        begin
          result := TTopElevLayer.WriteNewRoot {+ WriteParentIndex} + '.'
          + TTopElevParam.WriteParamName;
        end
        else
        begin
          result := TThicknessLayer.WriteNewRoot +
            IntToStr(StrToInt(WriteParentIndex) - 1) + '.'
            + TThicknessParam.WriteParamName;
        end;

      end
      else
      begin
        result := TThicknessLayer.WriteNewRoot + WriteParentIndex + '.'
          + TThicknessParam.WriteParamName;
      end;

    end
    else
    begin
      result := 'If(X()>=0, ' + FloatToStr(2 * Pi) + '*X(), $n/a)';
    end;
  end;
end;

{ TPORParam }

class function TPORParam.ANE_ParamName: string;
begin
  result := kPOR;
end;

function TPORParam.Units: string;
begin
  result := 'fraction';
end;

class function TPORParam.UsualValue: string;
begin
  result := TPorosityLayer.WriteNewRoot + '.'
    + TPorosityParam.WriteParamName;

end;

function TPORParam.Value: string;
begin
  result := TPorosityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TPorosityParam.WriteParamName;
end;

{ TLREGParam }

class function TLREGParam.ANE_ParamName: string;
begin
  result := kLREG;
end;

constructor TLREGParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TLREGParam.Value: string;
begin
  with frmSutra do
  begin
    if rbSatUnsat.Checked or rbFreezing.Checked or rbGeneral.Checked then
    begin
      if is3D then
      begin
        result := TUnsaturatedLayer.WriteNewRoot + WriteParentIndex
          + '.' + TRegionParam.WriteParamName;
      end
      else
      begin
        result := TUnsaturatedLayer.WriteNewRoot
          + '.' + TRegionParam.WriteParamName;
      end;
    end
    else
    begin
      result := '0';
    end;
  end;
end;

{ TPMAXParam }

class function TPMAXParam.ANE_ParamName: string;
begin
  result := kPMAX;
end;

function TPMAXParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := 'L^2';
      end;
    svHead:
      begin
        result := 'L/s';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

function TPMAXParam.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMaxPermeabilityParam.WriteParamName;
end;

{ TPMIDParam }

class function TPMIDParam.ANE_ParamName: string;
begin
  result := kPMID;
end;

function TPMIDParam.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMidPermeabilityParam.WriteParamName;
end;

{ TPMINParam }

class function TPMINParam.ANE_ParamName: string;
begin
  result := kPMIN;
end;

function TPMINParam.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMinPermeabilityParam.WriteParamName;
end;

{ TCustomANGLEParam }

{class function TCustomANGLEParam.ANE_ParamName: string;
begin
  result := kANGLE1;
end; }

function TCustomANGLEParam.Units: string;
begin
  result := 'degrees';
end;

{function TCustomANGLEParam.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TPermeabilityAngleParam.WriteParamName;
end; }

{ TANGLE1Param }

class function TANGLE1Param.ANE_ParamName: string;
begin
  result := kANGLE1;
end;

function TANGLE1Param.Value: string;
begin
  if frmSutra.Is3D then
  begin
    result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
      + THorizPermeabilityAngleParam.WriteParamName;
  end
  else
  begin
    result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
      + TPermeabilityAngleParam.WriteParamName;
  end;
  {
    result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
      + THorizPermeabilityAngleParam.WriteParamName;  }
end;

class function TANGLE1Param.WriteParamName: string;
begin
  result := inherited WriteParamName;
  if frmSutra.rb3D_va.Checked then
  begin
    result := result + '_';
  end;
end;

{ TANGLE2Param }

class function TANGLE2Param.ANE_ParamName: string;
begin
  result := kANGLE2;
end;

function TANGLE2Param.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TVertPermeabilityAngleParam.WriteParamName;
end;

{ TANGLE3Param }

class function TANGLE3Param.ANE_ParamName: string;
begin
  result := kANGLE3;
end;

function TANGLE3Param.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TRotPermeabilityAngleParam.WriteParamName;
end;

{ TALMAXParam }

class function TALMAXParam.ANE_ParamName: string;
begin
  result := kALMAX;
end;

function TALMAXParam.Units: string;
begin
  result := 'L';
end;

function TALMAXParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMaxLongDispParam.WriteParamName;
end;

{ TALMIDParam }

class function TALMIDParam.ANE_ParamName: string;
begin
  result := kALMID;
end;

function TALMIDParam.Units: string;
begin
  result := 'L';
end;

function TALMIDParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMidLongDispParam.WriteParamName;
end;

{ TALMINParam }

class function TALMINParam.ANE_ParamName: string;
begin
  result := kALMIN;
end;

function TALMINParam.Units: string;
begin
  result := 'L';
end;

function TALMINParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMinLongDispParam.WriteParamName;
end;

{ TAT1MAXParam }

class function TAT1MAXParam.ANE_ParamName: string;
begin
  result := kAT1MAX;
end;

function TAT1MAXParam.Units: string;
begin
  result := 'L';
end;

class function TAT1MAXParam.UsualValue: string;
begin
  result := TDispersivityLayer.WriteNewRoot + '.'
    + TMaxTransDisp1Param.WriteParamName;
end;

function TAT1MAXParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMaxTransDisp1Param.WriteParamName;
end;

{ TAT1MIDParam }

class function TAT1MIDParam.ANE_ParamName: string;
begin
  Result := kAT1MID;
end;

function TAT1MIDParam.Units: string;
begin
  result := 'L';
end;

function TAT1MIDParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMidTransDisp1Param.WriteParamName;
end;

{ TAT1MINParam }

class function TAT1MINParam.ANE_ParamName: string;
begin
  result := kAT1MIN;
end;

function TAT1MINParam.Units: string;
begin
  result := 'L';
end;

class function TAT1MINParam.UsualValue: string;
begin
  result := TDispersivityLayer.WriteNewRoot + '.'
    + TMinTransDisp1Param.WriteParamName;
end;

function TAT1MINParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMinTransDisp1Param.WriteParamName;
end;

{ TAT2MAXParam }

{class function TAT2MAXParam.ANE_ParamName: string;
begin
  result := kAT2MAX;
end;

function TAT2MAXParam.Units: string;
begin
  result := 'L';
end;

function TAT2MAXParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMaxTransDisp2Param.WriteParamName;
end;

{ TAT2MIDParam }

{class function TAT2MIDParam.ANE_ParamName: string;
begin
  result := kAT2MID;
end;

function TAT2MIDParam.Units: string;
begin
  result := 'L';
end;

function TAT2MIDParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMidTransDisp2Param.WriteParamName;
end;

{ TAT2MINParam }

{class function TAT2MINParam.ANE_ParamName: string;
begin
  result := kAT2MIN;
end;

function TAT2MINParam.Units: string;
begin
  result := 'L';
end;

function TAT2MINParam.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TMinTransDisp2Param.WriteParamName;
end;

{ TQINParam }

class function TQINParam.ANE_ParamName: string;
begin
  result := kQIN;
end;

function TQINParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svHead:
      begin
        result := 'L^3/s';
      end;
    svPressure:
      begin
        result := 'M/s';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

class function TQINParam.UsualValue: string;
begin
  result := 'Index(NodeAboveCntr('
    + T2DFluidSourcesLayer.WriteNewRoot
    + ')+1, NodeEffectiveValue('
    + T2DFluidSourcesLayer.WriteNewRoot + '.'
    + TResultantFluidSourceParam.WriteParamName
    + '), '
    + T2DFluidSourcesLayer.WriteNewRoot + '.'
    + TResultantFluidSourceParam.WriteParamName
    + ', '
    + T2DFluidSourcesLayer.WriteNewRoot + '.'
    + TResultantFluidSourceParam.WriteParamName
    + '*NodeEffectiveLength('
    + T2DFluidSourcesLayer.WriteNewRoot
    + '), NodeEffectiveValue('
    + T2DFluidSourcesLayer.WriteNewRoot + '.'
    + TResultantFluidSourceParam.WriteParamName
    + '), NodeEffectiveValue('
    + T2DFluidSourcesLayer.WriteNewRoot + '.'
    + TResultantFluidSourceParam.WriteParamName
    + '))';
end;

function TQINParam.Value: string;
var
  ParentIndexString: string;
begin
  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') then
    begin
      result := 'Index(NodeAboveCntr('
        + TTopFluidSourcesLayer.WriteNewRoot
        + ')+1, NodeEffectiveValue('
        + TTopFluidSourcesLayer.WriteNewRoot + '.'
        + TResultantFluidSourceParam.WriteParamName
        + '), '
        + TTopFluidSourcesLayer.WriteNewRoot + '.'
        + TResultantFluidSourceParam.WriteParamName
        + ', '
        + TTopFluidSourcesLayer.WriteNewRoot + '.'
        + TResultantFluidSourceParam.WriteParamName
        + '*NodeEffectiveLength('
        + TTopFluidSourcesLayer.WriteNewRoot
        + '), NodeEffectiveValue('
        + TTopFluidSourcesLayer.WriteNewRoot + '.'
        + TResultantFluidSourceParam.WriteParamName
        + '), NodeEffectiveValue('
        + TTopFluidSourcesLayer.WriteNewRoot + '.'
        + TResultantFluidSourceParam.WriteParamName
        + '))';
    end
    else
    begin
      //      if frmSutra.rb3D_va.Checked then
      //      begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      //      end;
      result := 'Index(NodeAboveCntr('
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString
        + ')+1, NodeEffectiveValue('
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TResultantFluidSourceParam.WriteParamName
        + '), '
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TResultantFluidSourceParam.WriteParamName
        + ', '
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TResultantFluidSourceParam.WriteParamName
        + '*NodeEffectiveLength('
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString
        + '), NodeEffectiveValue('
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TResultantFluidSourceParam.WriteParamName
        + '), NodeEffectiveValue('
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TResultantFluidSourceParam.WriteParamName
        + '))';
    end;
  end
  else
  begin
    result := 'Index(NodeAboveCntr('
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex
      + ')+1, NodeEffectiveValue('
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
      + '), '
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
      + ', '
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
      + '*NodeEffectiveLength('
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex
      + '), NodeEffectiveValue('
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
      + '), NodeEffectiveValue('
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
      + '))';
  end;
end;

{ TUINParam }

class function TUINParam.ANE_ParamName: string;
begin
  result := kUIN;
end;

constructor TUINParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
end;

function TUINParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := 'C or T';
      end;
    ttEnergy:
      begin
        result := 'degC';
      end;
    ttSolute:
      begin
        result := 'C';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

class function TUINParam.UsualValue: string;
begin
  result := 'If(NodeAboveCntr('
    + T2DFluidSourcesLayer.WriteNewRoot
    + ')=1 | NodeAboveCntr('
    + T2DFluidSourcesLayer.WriteNewRoot
    + ')=2, '
    + T2DFluidSourcesLayer.WriteNewRoot + '.'
    + TConcTempSourceParam.WriteParamName
    + ', NodeEffectiveValue('
    + T2DFluidSourcesLayer.WriteNewRoot + '.'
    + TQINUINParam.WriteParamName
    + ')/NodeEffectiveValue('
    + T2DFluidSourcesLayer.WriteNewRoot + '.'
    + TResultantFluidSourceParam.WriteParamName
    + '))';
end;

function TUINParam.Value: string;
var
  ParentIndexString: string;
begin
  {  result := 'If(NodeAboveCntr('
    + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex
    + ')=1 | NodeAboveCntr('
    + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex
    + ')=2, '
    + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TConcTempSourceParam.WriteParamName
    + ', NodeEffectiveValue('
    + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TQINUINParam.WriteParamName
    + ')/NodeEffectiveValue('
    + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
    + '))';
             }

  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') {and frmSutra.rb3D_va.Checked} then
    begin
      result := 'If(NodeAboveCntr('
        + TTopFluidSourcesLayer.WriteNewRoot
        + ')=1 | NodeAboveCntr('
        + TTopFluidSourcesLayer.WriteNewRoot
        + ')=2, '
        + TTopFluidSourcesLayer.WriteNewRoot + '.'
        + TConcTempSourceParam.WriteParamName
        + ', If(NodeEffectiveValue('
        + TTopFluidSourcesLayer.WriteNewRoot + '.'
        + TResultantFluidSourceParam.WriteParamName
        + ')=0, 0, NodeEffectiveValue('
        + TTopFluidSourcesLayer.WriteNewRoot + '.'
        + TQINUINParam.WriteParamName
        + ')/NodeEffectiveValue('
        + TTopFluidSourcesLayer.WriteNewRoot + '.'
        + TResultantFluidSourceParam.WriteParamName
        + ')))';
    end
    else
    begin
      //      if frmSutra.rb3D_va.Checked then
      //      begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      //      end;
      result := 'If(NodeAboveCntr('
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString
        + ')=1 | NodeAboveCntr('
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString
        + ')=2, '
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TConcTempSourceParam.WriteParamName
        + ', If(NodeEffectiveValue('
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TResultantFluidSourceParam.WriteParamName
        + ')=0, 0, NodeEffectiveValue('
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TQINUINParam.WriteParamName
        + ')/NodeEffectiveValue('
        + TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TResultantFluidSourceParam.WriteParamName
        + ')))';
    end;
  end
  else
  begin
    result := 'If(NodeAboveCntr('
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex
      + ')=1 | NodeAboveCntr('
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex
      + ')=2, '
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TConcTempSourceParam.WriteParamName
      + ', If(NodeEffectiveValue('
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
      + ')=0, 0, NodeEffectiveValue('
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TQINUINParam.WriteParamName
      + ')/NodeEffectiveValue('
      + T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantFluidSourceParam.WriteParamName
      + ')))';
  end;

end;

{ TTimeDepFluidSourceParam }

class function TTimeDepFluidSourceParam.ANE_ParamName: string;
begin
  result := kTimeDependentFluidSources;
end;

constructor TTimeDepFluidSourceParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TTimeDepFluidSourceParam.Value: string;
var
  ParentIndexString: string;
begin
  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') then
    begin
      result := TTopFluidSourcesLayer.WriteNewRoot + '.'
        + TTimeDependanceParam.WriteParamName;
    end
    else
    begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      result := TBottomFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TTimeDependanceParam.WriteParamName;
    end;
  end
  else
  begin
    result := T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TTimeDependanceParam.WriteParamName;
  end;
end;

{ TQUINParam }

class function TQUINParam.ANE_ParamName: string;
begin
  result := kQUIN;
end;

constructor TQUINParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
end;

function TQUINParam.Units: string;
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
        case frmSutra.StateVariableType of
          svHead:
            begin
              result := 'C*L^3)/s';
            end;
          svPressure:
            begin
              result := 'M/s';
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
  //  result := '(M or E)/s';
end;

class function TQUINParam.UsualValue: string;
begin
  result := 'Index(NodeAboveCntr('
    + T2DSoluteEnergySourcesLayer.WriteNewRoot
    + ')+1, NodeEffectiveValue('
    + T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
    + TResultantSoluteEnergySourceParam.WriteParamName
    + '), '
    + T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
    + TResultantSoluteEnergySourceParam.WriteParamName
    + ', '
    + T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
    + TResultantSoluteEnergySourceParam.WriteParamName
    + '*NodeEffectiveLength('
    + T2DSoluteEnergySourcesLayer.WriteNewRoot
    + '), NodeEffectiveValue('
    + T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
    + TResultantSoluteEnergySourceParam.WriteParamName
    + '), NodeEffectiveValue('
    + T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
    + TResultantSoluteEnergySourceParam.WriteParamName
    + '))';
end;

function TQUINParam.Value: string;
var
  ParentIndexString: string;
begin

  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') {and frmSutra.rb3D_va.Checked} then
    begin

      result := 'Index(NodeAboveCntr('
        + TTopSoluteEnergySourcesLayer.WriteNewRoot
        + ')+1, NodeEffectiveValue('
        + TTopSoluteEnergySourcesLayer.WriteNewRoot + '.'
        + TResultantSoluteEnergySourceParam.WriteParamName
        + '), '
        + TTopSoluteEnergySourcesLayer.WriteNewRoot + '.'
        + TResultantSoluteEnergySourceParam.WriteParamName
        + ', '
        + TTopSoluteEnergySourcesLayer.WriteNewRoot + '.'
        + TResultantSoluteEnergySourceParam.WriteParamName
        + '*NodeEffectiveLength('
        + TTopSoluteEnergySourcesLayer.WriteNewRoot
        + '), NodeEffectiveValue('
        + TTopSoluteEnergySourcesLayer.WriteNewRoot + '.'
        + TResultantSoluteEnergySourceParam.WriteParamName
        + '), NodeEffectiveValue('
        + TTopSoluteEnergySourcesLayer.WriteNewRoot + '.'
        + TResultantSoluteEnergySourceParam.WriteParamName
        + '))';
    end
    else
    begin

      //      if frmSutra.rb3D_va.Checked then
      //      begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      //      end;

      result := 'Index(NodeAboveCntr('
        + TBottomSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString
        + ')+1, NodeEffectiveValue('
        + TBottomSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TResultantSoluteEnergySourceParam.WriteParamName
        + '), '
        + TBottomSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TResultantSoluteEnergySourceParam.WriteParamName
        + ', '
        + TBottomSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TResultantSoluteEnergySourceParam.WriteParamName
        + '*NodeEffectiveLength('
        + TBottomSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString
        + '), NodeEffectiveValue('
        + TBottomSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TResultantSoluteEnergySourceParam.WriteParamName
        + '), NodeEffectiveValue('
        + TBottomSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString + '.'
        + TResultantSoluteEnergySourceParam.WriteParamName
        + '))';
    end;

  end
  else
  begin
    result := 'Index(NodeAboveCntr('
      + T2DSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex
      + ')+1, NodeEffectiveValue('
      + T2DSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
      + '), '
      + T2DSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
      + ', '
      + T2DSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
      + '*NodeEffectiveLength('
      + T2DSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex
      + '), NodeEffectiveValue('
      + T2DSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
      + '), NodeEffectiveValue('
      + T2DSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TResultantSoluteEnergySourceParam.WriteParamName
      + '))';
  end;

end;

{ TTimeDepEnergySoluteSourceParam }

class function TTimeDepEnergySoluteSourceParam.ANE_ParamName: string;
begin
  result := kTimeDependentEnergyOrSoluteSources;
end;

constructor TTimeDepEnergySoluteSourceParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

class function TTimeDepEnergySoluteSourceParam.UsualValue: string;
begin
  result := T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
    + TTimeDependanceParam.WriteParamName;
end;

function TTimeDepEnergySoluteSourceParam.Value: string;
var
  ParentIndexString: string;
begin
  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') then
    begin
      result := TTopSoluteEnergySourcesLayer.WriteNewRoot +
        '.'
        + TTimeDependanceParam.WriteParamName;

    end
    else
    begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      result := TBottomSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString
        + '.' + TTimeDependanceParam.WriteParamName;
    end;
  end
  else
  begin
    result := T2DSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
      + TTimeDependanceParam.WriteParamName;
  end;
end;

{ TPBCParam }

class function TPBCParam.ANE_ParamName: string;
begin
  result := kPBC;
end;

constructor TPBCParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
end;

function TPBCParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := 'M/(L s^2)'
      end;
    svHead:
      begin
        result := 'L';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

function TPBCParam.Value: string;
var
  ParentIndexString: string;
begin
  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') {and frmSutra.rb3D_va.Checked} then
    begin
      result := 'if(NodeAboveCntr('
        + TTopSpecifiedPressureLayer.WriteNewRoot
        + '),'
        + TTopSpecifiedPressureLayer.WriteNewRoot + '.'
        + TSpecPressureParam.WriteParamName
        + ',$n/a)';
    end
    else
    begin
      //      if frmSutra.rb3D_va.Checked then
      //      begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      //      end;
      result := 'if(NodeAboveCntr('
        + TBottomSpecifiedPressureLayer.WriteNewRoot + ParentIndexString
        + '),'
        + TBottomSpecifiedPressureLayer.WriteNewRoot + ParentIndexString + '.'
        + TSpecPressureParam.WriteParamName
        + ',$n/a)';
    end;
  end
  else
  begin
    result := 'if(NodeAboveCntr('
      + T2DSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex
      + '),'
      + T2DSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex + '.'
      + TSpecPressureParam.WriteParamName
      + ',$n/a)';
  end;
end;

{ TpUBCParam }

class function TpUBCParam.ANE_ParamName: string;
begin
  result := kpUBC;
end;

function TpUBCParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := 'C or T'
      end;
    ttEnergy:
      begin
        result := 'degC'
      end;
    ttSolute:
      begin
        result := 'C';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

class function TpUBCParam.UsualValue: string;
begin
  result := T2DSpecifiedPressureLayer.WriteNewRoot + '.' +
    TConcOrTempParam.WriteParamName;
end;

function TpUBCParam.Value: string;
var
  ParentIndexString: string;
begin
  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') {and frmSutra.rb3D_va.Checked} then
    begin
      result := TTopSpecifiedPressureLayer.WriteNewRoot + '.'
        +
        TConcOrTempParam.WriteParamName;
    end
    else
    begin
      //      if frmSutra.rb3D_va.Checked then
      //      begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      //      end;
      result := TBottomSpecifiedPressureLayer.WriteNewRoot + ParentIndexString +
        '.' +
        TConcOrTempParam.WriteParamName;
    end;
  end
  else
  begin
    result := T2DSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex + '.' +
      TConcOrTempParam.WriteParamName;
  end;
end;

{ TTimeDepSpecHeadPresParam }

class function TTimeDepSpecHeadPresParam.ANE_ParamName: string;
begin
  result := kTimeDependentSpecifiedHeadOrPressure;
end;

constructor TTimeDepSpecHeadPresParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TTimeDepSpecHeadPresParam.Value: string;
var
  ParentIndexString: string;
begin
  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') then
    begin
      result := TTopSpecifiedPressureLayer.WriteNewRoot + '.'
        + TTimeDependanceParam.WriteParamName;
    end
    else
    begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      result := TBottomSpecifiedPressureLayer.WriteNewRoot + ParentIndexString +
        '.' + TTimeDependanceParam.WriteParamName;
    end;
  end
  else
  begin
    result := T2DSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex + '.'
      + TTimeDependanceParam.WriteParamName;
  end;
end;

{ TUBCParam }

class function TUBCParam.ANE_ParamName: string;
begin
  result := kUBC;
end;

constructor TUBCParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
end;

function TUBCParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := 'C or T'
      end;
    ttEnergy:
      begin
        result := 'degC'
      end;
    ttSolute:
      begin
        result := 'C';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

class function TUBCParam.UsualValue: string;
begin
  result := 'if(NodeAboveCntr('
    + T2DSpecConcTempLayer.WriteNewRoot
    + '),'
    + T2DSpecConcTempLayer.WriteNewRoot + '.'
    + TSpecConcTempParam.WriteParamName
    + ',$n/a)';
end;

function TUBCParam.Value: string;
var
  ParentIndexString: string;
begin
  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') {and frmSutra.rb3D_va.Checked} then
    begin
      result := 'if(NodeAboveCntr('
        + TTopSpecConcTempLayer.WriteNewRoot
        + '),'
        + TTopSpecConcTempLayer.WriteNewRoot + '.'
        + TSpecConcTempParam.WriteParamName
        + ',$n/a)';

    end
    else
    begin
      //      if frmSutra.rb3D_va.Checked then
      //      begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      //      end;
      result := 'if(NodeAboveCntr('
        + TBottomSpecConcTempLayer.WriteNewRoot + ParentIndexString
        + '),'
        + TBottomSpecConcTempLayer.WriteNewRoot + ParentIndexString + '.'
        + TSpecConcTempParam.WriteParamName
        + ',$n/a)';

    end;
  end
  else
  begin
    result := 'if(NodeAboveCntr('
      + T2DSpecConcTempLayer.WriteNewRoot + WriteParentIndex
      + '),'
      + T2DSpecConcTempLayer.WriteNewRoot + WriteParentIndex + '.'
      + TSpecConcTempParam.WriteParamName
      + ',$n/a)';

  end;
end;

{ TTimeDepSpecConcTempParam }

class function TTimeDepSpecConcTempParam.ANE_ParamName: string;
begin
  result := kTimeDependentSpecifiedConcentrationOrTemperature;
end;

constructor TTimeDepSpecConcTempParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

class function TTimeDepSpecConcTempParam.UsualValue: string;
begin
  result := T2DSpecConcTempLayer.WriteNewRoot + '.'
    + TTimeDependanceParam.WriteParamName;
end;

function TTimeDepSpecConcTempParam.Value: string;
var
  ParentIndexString: string;
begin
  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') then
    begin
      result := TTopSpecConcTempLayer.WriteNewRoot + '.'
        + TTimeDependanceParam.WriteParamName;
    end
    else
    begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      result := TBottomSpecConcTempLayer.WriteNewRoot + ParentIndexString + '.'
        + TTimeDependanceParam.WriteParamName;
    end;
  end
  else
  begin
    result := T2DSpecConcTempLayer.WriteNewRoot + WriteParentIndex + '.'
      + TTimeDependanceParam.WriteParamName;
  end;
end;

{ TPVECParam }

class function TPVECParam.ANE_ParamName: string;
begin
  result := kPVEC;
end;

function TPVECParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := 'M/(L s^2)';
      end;
    svHead:
      begin
        result := 'L';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

function TPVECParam.Value: string;
begin
  result := TInitialPressureLayer.WriteNewRoot + WriteParentIndex + '.'
    + TInitialPressureParam.WriteParamName
end;

{ TUVECParam }

class function TUVECParam.ANE_ParamName: string;
begin
  result := kUVEC;
end;

function TUVECParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := 'C or T'
      end;
    ttEnergy:
      begin
        result := 'degC'
      end;
    ttSolute:
      begin
        result := 'C';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

class function TUVECParam.UsualValue: string;
begin
  result := TInitialConcTempLayer.WriteNewRoot + '.'
    + TInitialConcTempParam.WriteParamName;
end;

function TUVECParam.Value: string;
begin
  result := TInitialConcTempLayer.WriteNewRoot + WriteParentIndex + '.'
    + TInitialConcTempParam.WriteParamName;
end;

{ TINOBParam }

class function TINOBParam.ANE_ParamName: string;
begin
  result := kINOB;
end;

constructor TINOBParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
  ParameterType := mptNode;
end;

class function TINOBParam.UsualValue: string;
begin
    result := 'If('
      + T2DObservationLayer.WriteNewRoot + '.'
      + TIsObservedParam.WriteParamName
      + ',NodeNumber(),0)'
end;

function TINOBParam.Value: string;
var
  ParentIndexString: string;
begin
  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') {and frmSutra.rb3D_va.Checked} then
    begin
      result := 'If('
        + TTopObservationLayer.WriteNewRoot + '.'
        + TIsObservedParam.WriteParamName
        + ',NodeNumber(),0)'

    end
    else
    begin
      //      if frmSutra.rb3D_va.Checked then
      //      begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      //      end;
      result := 'If('
        + TBottomObservationLayer.WriteNewRoot + ParentIndexString + '.'
        + TIsObservedParam.WriteParamName
        + ',NodeNumber(),0)'

    end;
  end
  else
  begin
    result := 'If('
      + T2DObservationLayer.WriteNewRoot + WriteParentIndex + '.'
      + TIsObservedParam.WriteParamName
      + ',NodeNumber(),0)'
  end;
end;

{ TSutraNodeLayerParameters }

constructor TSutraNodeLayerParameters.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(TNREGParam.ANE_ParamName);
  ParameterOrder.Add(TZParam.ANE_ParamName);
  ParameterOrder.Add(TPORParam.ANE_ParamName);
  {$IFDEF SutraIce}
  ParameterOrder.Add(TCS1Parameter.ANE_ParamName);
  {$ENDIF}
  ParameterOrder.Add(TLREGParam.ANE_ParamName);
  ParameterOrder.Add(TPMAXParam.ANE_ParamName);
  ParameterOrder.Add(TPMIDParam.ANE_ParamName);
  ParameterOrder.Add(TPMINParam.ANE_ParamName);
  {$IFDEF SutraIce}
  ParameterOrder.Add(TSIGS.ANE_ParamName);
  {$ENDIF}
  ParameterOrder.Add(TANGLE1Param.ANE_ParamName);
  ParameterOrder.Add(TANGLE2Param.ANE_ParamName);
  ParameterOrder.Add(TANGLE3Param.ANE_ParamName);
  ParameterOrder.Add(TALMAXParam.ANE_ParamName);
  ParameterOrder.Add(TALMIDParam.ANE_ParamName);
  ParameterOrder.Add(TALMINParam.ANE_ParamName);
  ParameterOrder.Add(TAT1MAXParam.ANE_ParamName);
  ParameterOrder.Add(TAT1MIDParam.ANE_ParamName);
  ParameterOrder.Add(TAT1MINParam.ANE_ParamName);
  ParameterOrder.Add(TQINParam.ANE_ParamName);
  ParameterOrder.Add(TQIN_TopSurfaceParam.ANE_ParamName);

  ParameterOrder.Add(TIsFluidSource.ANE_ParamName);
  ParameterOrder.Add(TIsTopFluidSource.ANE_ParamName);
  ParameterOrder.Add(TUINParam.ANE_ParamName);
  ParameterOrder.Add(TUIN_TopSurfaceParam.ANE_ParamName);
  ParameterOrder.Add(TTimeDepFluidSourceParam.ANE_ParamName);
  ParameterOrder.Add(TQUINParam.ANE_ParamName);
  ParameterOrder.Add(TQUIN_TopSurfaceParam.ANE_ParamName);
  ParameterOrder.Add(TIsQUINSource.ANE_ParamName);
  ParameterOrder.Add(TIsTopQUINSource.ANE_ParamName);
  ParameterOrder.Add(TTimeDepEnergySoluteSourceParam.ANE_ParamName);
  ParameterOrder.Add(TPBCParam.ANE_ParamName);
  ParameterOrder.Add(TPBC_TopSurfaceParam.ANE_ParamName);
  ParameterOrder.Add(TIsPBCSource.ANE_ParamName);
  ParameterOrder.Add(TIsTopPBCSource.ANE_ParamName);

  ParameterOrder.Add(TPBC_CommentParam.ANE_ParamName);

  ParameterOrder.Add(TpUBCParam.ANE_ParamName);
  ParameterOrder.Add(TpUBC_TopSurfaceParam.ANE_ParamName);
  ParameterOrder.Add(TTimeDepSpecHeadPresParam.ANE_ParamName);
  ParameterOrder.Add(TUBCParam.ANE_ParamName);
  {$IFDEF OldSutraIce}
  ParameterOrder.Add(TGNUU0Param.ANE_ParamName);
  {$ENDIF}
  ParameterOrder.Add(TUBC_TopSurfaceParam.ANE_ParamName);
  ParameterOrder.Add(TIsUBCSource.ANE_ParamName);
  ParameterOrder.Add(TIsTopUBCSource.ANE_ParamName);
  ParameterOrder.Add(TTimeDepSpecConcTempParam.ANE_ParamName);
  ParameterOrder.Add(TPVECParam.ANE_ParamName);
  ParameterOrder.Add(TUVECParam.ANE_ParamName);

  ParameterOrder.Add(TINOBParam.ANE_ParamName);
  ParameterOrder.Add(TINOBTypeParam.ANE_ParamName);

  if frmSutra.rb3D_va.Checked then
  begin
    TZParam.Create(self, -1);
    if Position <> StrToInt(frmSutra.adeVertDisc.Text) then
    begin
      TNREGParam.Create(self, -1);
      TPORParam.Create(self, -1);
      {$IFDEF SutraIce}
      if (frmSutra.rbFreezing.Checked or frmSutra.rbEnergy.Checked) then
      begin
        TCS1Parameter.Create(self, -1);
      end;
      {$ENDIF}
      TLREGParam.Create(self, -1);
      TPMAXParam.Create(self, -1);
      TPMIDParam.Create(self, -1);
      TPMINParam.Create(self, -1);
      {$IFDEF SutraIce}
      if (frmSutra.rbFreezing.Checked or frmSutra.rbEnergy.Checked) then
      begin
        TSIGS.Create(self, -1);
      end;
      {$ENDIF}
      TANGLE1Param.Create(self, -1);
      TANGLE2Param.Create(self, -1);
      TANGLE3Param.Create(self, -1);
      TALMAXParam.Create(self, -1);
      TALMIDParam.Create(self, -1);
      TALMINParam.Create(self, -1);
      TAT1MAXParam.Create(self, -1);
      TAT1MIDParam.Create(self, -1);
      TAT1MINParam.Create(self, -1);
      TPVECParam.Create(self, -1);
      TUVECParam.Create(self, -1);
    end;
  end;

end;

{ TSutraMeshLayer }

class function TSutraMeshLayer.ANE_LayerName: string;
begin
  result := KSutraMesh;
end;

constructor TSutraMeshLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  ParameterIndex: integer;
begin
  inherited;
  Visible := False;
  Template.Add('# editable SUTRA template goes here');

  DomainLayer := TSutraDomainOutline.WriteNewRoot {+ WriteIndex};
  DensityLayer := TSutraMeshDensity.WriteNewRoot {+ WriteIndex};

  ParamList.ParameterOrder.Add(TNREGParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TZParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPORParam.ANE_ParamName);
  {$IFDEF SutraIce}
  ParamList.ParameterOrder.Add(TCS1Parameter.ANE_ParamName);
  {$ENDIF}
  ParamList.ParameterOrder.Add(TLREGParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPMAXParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPMIDParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPMINParam.ANE_ParamName);
  {$IFDEF SutraIce}
  ParamList.ParameterOrder.Add(TSIGS.ANE_ParamName);
  {$ENDIF}
  ParamList.ParameterOrder.Add(TANGLE1Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TANGLE2Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TANGLE3Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TALMAXParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TALMIDParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TALMINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TAT1MAXParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TAT1MIDParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TAT1MINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TQINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TQIN_TopSurfaceParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TIsFluidSource.ANE_ParamName);
  ParamList.ParameterOrder.Add(TIsTopFluidSource.ANE_ParamName);
  ParamList.ParameterOrder.Add(TUINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TUIN_TopSurfaceParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TTimeDepFluidSourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TQUINParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TQUIN_TopSurfaceParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TIsQUINSource.ANE_ParamName);
  ParamList.ParameterOrder.Add(TIsTopQUINSource.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDepEnergySoluteSourceParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TPBCParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPBC_TopSurfaceParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TIsPBCSource.ANE_ParamName);
  ParamList.ParameterOrder.Add(TIsTopPBCSource.ANE_ParamName);

  ParamList.ParameterOrder.Add(TPBC_CommentParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TpUBCParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TpUBC_TopSurfaceParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TTimeDepSpecHeadPresParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TUBCParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TUBC_TopSurfaceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TIsUBCSource.ANE_ParamName);
  ParamList.ParameterOrder.Add(TIsTopUBCSource.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDepSpecConcTempParam.ANE_ParamName);
  {$IFDEF OldSutraIce}
  ParamList.ParameterOrder.Add(TGNUU0Param.ANE_ParamName);
  {$ENDIF}
  ParamList.ParameterOrder.Add(TPVECParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TUVECParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TINOBParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TINOBTypeParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TInvNodeThickness_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodePOR_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionPOR_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodePMAX_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionPMAX_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodePMIN_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionPMIN_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodeANGLE1_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionANGLE1_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodeALMAX_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionALMAX_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodeALMIN_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionALMIN_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodeATMAX_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionATMAX_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodeATMIN_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionATMIN_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodeQIN_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionQIN_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodeUIN_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionUIN_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodeQUIN_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionQUIN_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodePBC_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionPBC_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodePUBC_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionPUBC_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvNodeUBC_Param.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvNodeFunctionUBC_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvHeadObsName_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvConcentrationObsName_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvFluxObsName_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvSoluteFluxObsName_Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvSaturationObsName_Param.ANE_ParamName);

  for ParameterIndex := 0 to StrToInt(frmSutra.adeVertDisc.Text) do
  begin
    TSutraNodeLayerParameters.Create(IndexedParamList1, ParameterIndex);
  end;

  if not frmSutra.rb3D_va.Checked then
  begin
    TNREGParam.Create(ParamList, -1);
    TZParam.Create(ParamList, -1);
    TPORParam.Create(ParamList, -1);
    {$IFDEF SutraIce}
    if (frmSutra.rbFreezing.Checked or frmSutra.rbEnergy.Checked) then
    begin
      TCS1Parameter.Create(ParamList, -1);
    end;
    {$ENDIF}
    TLREGParam.Create(ParamList, -1);
    TPMAXParam.Create(ParamList, -1);
    if frmSutra.rb3D_nva.Checked then
    begin
      TPMIDParam.Create(ParamList, -1);
    end;
    TPMINParam.Create(ParamList, -1);
    {$IFDEF SutraIce}
    if (frmSutra.rbFreezing.Checked or frmSutra.rbEnergy.Checked) then
    begin
      TSIGS.Create(ParamList, -1);
    end;
    {$ENDIF}
    if frmSutra.Is3D then
    begin
      TANGLE1Param.Create(ParamList, -1);
      TANGLE2Param.Create(ParamList, -1);
      TANGLE3Param.Create(ParamList, -1);
    end
    else
    begin
      TANGLE1Param.Create(ParamList, -1);
    end;
    TALMAXParam.Create(ParamList, -1);
    if frmSutra.Is3D then
    begin
      TALMIDParam.Create(ParamList, -1);
    end;
    TALMINParam.Create(ParamList, -1);

    TAT1MAXParam.Create(ParamList, -1);
    if frmSutra.Is3D then
    begin
      TAT1MIDParam.Create(ParamList, -1);
    end;
    TAT1MINParam.Create(ParamList, -1);

    if not frmSutra.Is3D then
    begin
      TQINParam.Create(ParamList, -1);
      if frmSutra.Is3D then
      begin
        TIsFluidSource.Create(ParamList, -1);
      end;
      TUINParam.Create(ParamList, -1);
      TTimeDepFluidSourceParam.Create(ParamList, -1);
      TQUINParam.Create(ParamList, -1);
      if frmSutra.Is3D then
      begin
        TIsQUINSource.Create(ParamList, -1);
      end;
      TTimeDepEnergySoluteSourceParam.Create(ParamList, -1);
      TPBCParam.Create(ParamList, -1);
      TPBC_CommentParam.Create(ParamList, -1);

      if frmSutra.Is3D then
      begin
        TIsPBCSource.Create(ParamList, -1);
      end;
      TpUBCParam.Create(ParamList, -1);
      TTimeDepSpecHeadPresParam.Create(ParamList, -1);
      TUBCParam.Create(ParamList, -1);
      if frmSutra.Is3D then
      begin
        TIsUBCSource.Create(ParamList, -1);
      end;

      TTimeDepSpecConcTempParam.Create(ParamList, -1);
      {$IFDEF OldSutraIce}
      TGNUU0Param.Create(ParamList, -1);
      {$ENDIF}
    end;
    TPVECParam.Create(ParamList, -1);
    TUVECParam.Create(ParamList, -1);
    if not frmSutra.Is3D then
    begin
      TINOBParam.Create(ParamList, -1);
      TINOBTypeParam.Create(ParamList, -1);
    end;

    if frmSutra.cbInverse.Checked
      or frmSutra.cbPreserveInverseModelParameters.Checked then
    begin
      TInvNodeThickness_Param.Create(ParamList, -1);
      TInvNodePOR_Param.Create(ParamList, -1);
//      TInvNodeFunctionPOR_Param.Create(ParamList, -1);
      TInvNodePMAX_Param.Create(ParamList, -1);
//      TInvNodeFunctionPMAX_Param.Create(ParamList, -1);
      TInvNodePMIN_Param.Create(ParamList, -1);
//      TInvNodeFunctionPMIN_Param.Create(ParamList, -1);
      TInvNodeANGLE1_Param.Create(ParamList, -1);
//      TInvNodeFunctionANGLE1_Param.Create(ParamList, -1);
      TInvNodeALMAX_Param.Create(ParamList, -1);
//      TInvNodeFunctionALMAX_Param.Create(ParamList, -1);
      TInvNodeALMIN_Param.Create(ParamList, -1);
//      TInvNodeFunctionALMIN_Param.Create(ParamList, -1);
      TInvNodeATMAX_Param.Create(ParamList, -1);
//      TInvNodeFunctionATMAX_Param.Create(ParamList, -1);
      TInvNodeATMIN_Param.Create(ParamList, -1);
//      TInvNodeFunctionATMIN_Param.Create(ParamList, -1);
      TInvNodeQIN_Param.Create(ParamList, -1);
//      TInvNodeFunctionQIN_Param.Create(ParamList, -1);
      TInvNodeUIN_Param.Create(ParamList, -1);
//      TInvNodeFunctionUIN_Param.Create(ParamList, -1);
      TInvNodeQUIN_Param.Create(ParamList, -1);
//      TInvNodeFunctionQUIN_Param.Create(ParamList, -1);
      TInvNodePBC_Param.Create(ParamList, -1);
//      TInvNodeFunctionPBC_Param.Create(ParamList, -1);
      TInvNodePUBC_Param.Create(ParamList, -1);
//      TInvNodeFunctionPUBC_Param.Create(ParamList, -1);
      TInvNodeUBC_Param.Create(ParamList, -1);
//      TInvNodeFunctionUBC_Param.Create(ParamList, -1);
    end;
    if not frmSutra.Is3D and (frmSutra.cbInverse.Checked
      or frmSutra.cbPreserveInverseModelParameters.Checked) then
    begin
      TInvHeadObsName_Param.Create(ParamList, -1);
      TInvConcentrationObsName_Param.Create(ParamList, -1);
      TInvFluxObsName_Param.Create(ParamList, -1);
      TInvSoluteFluxObsName_Param.Create(ParamList, -1);
      if frmSutra.rbSatUnsat.Checked then
      begin
        TInvSaturationObsName_Param.Create(ParamList, -1);
      end;
    end;
  end;

end;

function TSutraMeshLayer.Units: string;
begin
  result := '';
end;

function TSutraMeshLayer.WriteIndex: string;
var
  Value: integer;
begin
  result := inherited WriteIndex;
  if result <> '' then
  begin
    Value := StrToInt(result) - 1;
    if Value = 0 then
    begin
      result := '';
    end
    else
    begin
      result := IntToStr(Value);
    end;
  end;
end;

function TSutraMeshLayer.WriteLayerRoot: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    if WriteIndex = '' then
    begin
      result := inherited WriteLayerRoot + KTop;
    end
    else
    begin
      result := inherited WriteLayerRoot + KBottom;
    end;
  end
  else
  begin
    result := inherited WriteLayerRoot;
  end;
end;

function TSutraMeshLayer.WriteOldIndex: string;
var
  Value: integer;
begin
  result := inherited WriteOldIndex;
  if result <> '' then
  begin
    Value := StrToInt(result) - 1;
    if Value = 0 then
    begin
      result := '';
    end
    else
    begin
      result := IntToStr(Value);
    end;
  end;
end;

{ TQINTopParam }

class function TQINTopParam.ANE_ParamName: string;
begin
  result := kQINtop
end;

function TQINTopParam.Value: string;
begin
  result := T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TTopElevaParam.WriteParamName;
end;

{ TQINBottomParam }

class function TQINBottomParam.ANE_ParamName: string;
begin
  result := kQINbottom;
end;

function TQINBottomParam.Value: string;
begin
  result := T2DFluidSourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TBottomElevaParam.WriteParamName;
end;

{ TQUINTopParam }

class function TQUINTopParam.ANE_ParamName: string;
begin
  result := kQUINtop;
end;

function TQUINTopParam.Value: string;
begin
  result := T2DSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TTopElevaParam.WriteParamName;
end;

{ TQUINBottomParam }

class function TQUINBottomParam.ANE_ParamName: string;
begin
  result := kQUINbottom;
end;

function TQUINBottomParam.Value: string;
begin
  result := T2DSoluteEnergySourcesLayer.WriteNewRoot + WriteParentIndex + '.'
    + TBottomElevaParam.WriteParamName;
end;

{ TPBCTopParam }

class function TPBCTopParam.ANE_ParamName: string;
begin
  result := kPBCtop;
end;

function TPBCTopParam.Value: string;
begin
  result := T2DSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex + '.'
    + TTopElevaParam.WriteParamName;
end;

{ TPBCBottomParam }

class function TPBCBottomParam.ANE_ParamName: string;
begin
  result := kPBCbottom;
end;

function TPBCBottomParam.Value: string;
begin
  result := T2DSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex + '.'
    + TBottomElevaParam.WriteParamName;
end;

{ TUBCTopParam }

class function TUBCTopParam.ANE_ParamName: string;
begin
  result := kUBCtop;
end;

function TUBCTopParam.Value: string;
begin
  result := T2DSpecConcTempLayer.WriteNewRoot + WriteParentIndex + '.'
    + TTopElevaParam.WriteParamName;
end;

{ TUBCBottomParam }

class function TUBCBottomParam.ANE_ParamName: string;
begin
  result := kUBCbottom;
end;

function TUBCBottomParam.Value: string;
begin
  result := T2DSpecConcTempLayer.WriteNewRoot + WriteParentIndex + '.'
    + TBottomElevaParam.WriteParamName;
end;

{ TIsFluidSource }

class function TIsFluidSource.ANE_ParamName: string;
begin
  result := kIsFluidSource;
end;

function TIsFluidSource.Value: string;
{var
  ParentIndexString : string;}
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := '!IsNA(' + TQINParam.WriteParamName + ')';
  end
  else
  begin
    //    ParentIndexString := IntToStr(StrToInt(WriteParentIndex) - 1);
    result := '!IsNA(' + TQINParam.WriteParamName + WriteParentIndex + ')';
  end;
end;

{ TIsQUINSource }

class function TIsQUINSource.ANE_ParamName: string;
begin
  result := kIsQUINSource;
end;

function TIsQUINSource.Value: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := '!IsNA(' + TQUINParam.WriteParamName + ')';
  end
  else
  begin
    result := '!IsNA(' + TQUINParam.WriteParamName + WriteParentIndex + ')';
  end;
end;

{ TCustomIsSourceParameter }

constructor TCustomIsSourceParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
  Lock := Lock + [plDont_Override];
end;

function TCustomIsSourceParameter.Units: string;
begin
  result := 'Calculated';
end;

{ TIsPBCSource }

class function TIsPBCSource.ANE_ParamName: string;
begin
  result := kIsPBCSource;
end;

function TIsPBCSource.Value: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := '!IsNA(' + TPBCParam.WriteParamName + ')';
  end
  else
  begin
    result := '!IsNA(' + TPBCParam.WriteParamName + WriteParentIndex + ')';
  end;
end;

{ TIsUBCSource }

class function TIsUBCSource.ANE_ParamName: string;
begin
  result := kIsUBCSource;
end;

function TIsUBCSource.Value: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := '!IsNA(' + TUBCParam.WriteParamName + ')';
  end
  else
  begin
    result := '!IsNA(' + TUBCParam.WriteParamName + WriteParentIndex + ')';
  end;
end;

{ TQUIN_TopSurfaceParam }

class function TQUIN_TopSurfaceParam.ANE_ParamName: string;
begin
  result := kTopQUIN;
end;

function TQUIN_TopSurfaceParam.Value: string;
var
  ParentIndexString: string;
begin
  ParentIndexString := WriteParentIndex;
  result := 'Index(NodeAboveCntr('
    + TTopSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString
    + ')+1, NodeEffectiveValue('
    + TTopSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TResultantSoluteEnergySourceParam.WriteParamName
    + '), '
    + TTopSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TResultantSoluteEnergySourceParam.WriteParamName
    + ', '
    + TTopSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TResultantSoluteEnergySourceParam.WriteParamName
    + '*NodeEffectiveLength('
    + TTopSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString
    + '), NodeEffectiveValue('
    + TTopSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TResultantSoluteEnergySourceParam.WriteParamName
    + '), NodeEffectiveValue('
    + TTopSoluteEnergySourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TResultantSoluteEnergySourceParam.WriteParamName
    + '))';

end;

{ TQIN_TopSurfaceParam }

class function TQIN_TopSurfaceParam.ANE_ParamName: string;
begin
  result := kTopQIN
end;

function TQIN_TopSurfaceParam.Value: string;
var
  ParentIndexString: string;
begin
  ParentIndexString := WriteParentIndex;
  result := 'Index(NodeAboveCntr('
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString
    + ')+1, NodeEffectiveValue('
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TResultantFluidSourceParam.WriteParamName
    + '), '
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TResultantFluidSourceParam.WriteParamName
    + ', '
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TResultantFluidSourceParam.WriteParamName
    + '*NodeEffectiveLength('
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString
    + '), NodeEffectiveValue('
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TResultantFluidSourceParam.WriteParamName
    + '), NodeEffectiveValue('
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TResultantFluidSourceParam.WriteParamName
    + '))';
end;

{ TUBC_TopSurfaceParam }

class function TUBC_TopSurfaceParam.ANE_ParamName: string;
begin
  result := kTopUBC;
end;

function TUBC_TopSurfaceParam.Value: string;
var
  ParentIndexString: string;
begin
  ParentIndexString := WriteParentIndex;
  result := 'if(NodeAboveCntr('
    + TTopSpecConcTempLayer.WriteNewRoot + ParentIndexString
    + '),'
    + TTopSpecConcTempLayer.WriteNewRoot + ParentIndexString + '.'
    + TSpecConcTempParam.WriteParamName
    + ',$n/a)';
end;

{ TPBC_TopSurfaceParam }

class function TPBC_TopSurfaceParam.ANE_ParamName: string;
begin
  result := ktopPBC;
end;

function TPBC_TopSurfaceParam.Value: string;
var
  ParentIndexString: string;
begin
  ParentIndexString := WriteParentIndex;
  result := 'if(NodeAboveCntr('
    + TTopSpecifiedPressureLayer.WriteNewRoot + ParentIndexString
    + '),'
    + TTopSpecifiedPressureLayer.WriteNewRoot + ParentIndexString + '.'
    + TSpecPressureParam.WriteParamName
    + ',$n/a)';
end;

{ TUIN_TopSurfaceParam }

class function TUIN_TopSurfaceParam.ANE_ParamName: string;
begin
  result := kTopUIN;
end;

function TUIN_TopSurfaceParam.Value: string;
var
  ParentIndexString: string;
begin
  ParentIndexString := WriteParentIndex;
  result := 'If(NodeAboveCntr('
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString
    + ')=1 | NodeAboveCntr('
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString
    + ')=2, '
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TConcTempSourceParam.WriteParamName
    + ', If(NodeEffectiveValue('
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TResultantFluidSourceParam.WriteParamName
    + ')=0, 0, NodeEffectiveValue('
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TQINUINParam.WriteParamName
    + ')/NodeEffectiveValue('
    + TTopFluidSourcesLayer.WriteNewRoot + ParentIndexString + '.'
    + TResultantFluidSourceParam.WriteParamName
    + ')))';
end;

{ TpUBC_TopSurfaceParam }

class function TpUBC_TopSurfaceParam.ANE_ParamName: string;
begin
  result := kToppUBC;
end;

function TpUBC_TopSurfaceParam.Value: string;
var
  ParentIndexString: string;
begin
  ParentIndexString := WriteParentIndex;
  result := TTopSpecifiedPressureLayer.WriteNewRoot + ParentIndexString + '.' +
    TConcOrTempParam.WriteParamName;
end;

{ TIsTopFluidSource }

class function TIsTopFluidSource.ANE_ParamName: string;
begin
  result := kTopIsFluidSource;
end;

function TIsTopFluidSource.Value: string;
{var
  ParentIndexString : string;  }
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := '!IsNA(' + TQIN_TopSurfaceParam.WriteParamName + ')';
  end
  else
  begin
    //    ParentIndexString := IntToStr(StrToInt(WriteParentIndex));
    result := '!IsNA(' + TQIN_TopSurfaceParam.WriteParamName + WriteParentIndex
      +
      ')';
  end;

end;

{ TIsTopPBCSource }

class function TIsTopPBCSource.ANE_ParamName: string;
begin
  result := kTopIsPBCSource;
end;

function TIsTopPBCSource.Value: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := '!IsNA(' + TPBC_TopSurfaceParam.WriteParamName + ')';
  end
  else
  begin
    result := '!IsNA(' + TPBC_TopSurfaceParam.WriteParamName + WriteParentIndex
      +
      ')';
  end;

end;

{ TIsTopQUINSource }

class function TIsTopQUINSource.ANE_ParamName: string;
begin
  result := kTopIsQUINSource;
end;

function TIsTopQUINSource.Value: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := '!IsNA(' + TQUIN_TopSurfaceParam.WriteParamName + ')';
  end
  else
  begin
    result := '!IsNA(' + TQUIN_TopSurfaceParam.WriteParamName + WriteParentIndex
      + ')';
  end;
end;

{ TIsTopUBCSource }

class function TIsTopUBCSource.ANE_ParamName: string;
begin
  result := kTopIsUBCSource;
end;

function TIsTopUBCSource.Value: string;
begin
  if frmSutra.rb3D_nva.Checked then
  begin
    result := '!IsNA(' + TUBC_TopSurfaceParam.WriteParamName + ')';
  end
  else
  begin
    result := '!IsNA(' + TUBC_TopSurfaceParam.WriteParamName + WriteParentIndex
      +
      ')';
  end;
end;

{ TTopTimeDepEnergySoluteSourceParam }

{
class function TTopTimeDepEnergySoluteSourceParam.ANE_ParamName: string;
begin
  result := kTopTimeDependentEnergyOrSoluteSources;
end;

function TTopTimeDepEnergySoluteSourceParam.Value: string;
begin
  result := TTopSoluteEnergySourcesLayer.WriteNewRoot  + '.'
    + TTimeDependanceParam.WriteParamName;
end;
}

{ TTopTimeDepFluidSourceParam }

{
class function TTopTimeDepFluidSourceParam.ANE_ParamName: string;
begin
  result := kTopTimeDependentFluidSources;
end;

function TTopTimeDepFluidSourceParam.Value: string;
begin
  result := TTopFluidSourcesLayer.WriteNewRoot  + '.'
    + TTimeDependanceParam.WriteParamName;

end;
}

{ TTopTimeDepSpecConcTempParam }

{
class function TTopTimeDepSpecConcTempParam.ANE_ParamName: string;
begin
  result := kTopTimeDependentSpecifiedConcentrationOrTemperature;
end;

function TTopTimeDepSpecConcTempParam.Value: string;
begin
  result := TTopSpecConcTempLayer.WriteNewRoot  + '.'
    + TTimeDependanceParam.WriteParamName;
end;
}

{ TTopTimeDepSpecHeadPresParam }

{
class function TTopTimeDepSpecHeadPresParam.ANE_ParamName: string;
begin
  result := kTopTimeDependentSpecifiedHeadOrPressure;
end;

function TTopTimeDepSpecHeadPresParam.Value: string;
begin
  result := TTopSpecifiedPressureLayer.WriteNewRoot  + '.'
    + TTimeDependanceParam.WriteParamName;
end;
}

{ TCustomInverseNodeParameter }

constructor TCustomInverseNodeParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

{ TInvNodePOR_Param }

class function TInvNodePOR_Param.ANE_ParamName: string;
begin
  result := kInvPOR;
end;

function TInvNodePOR_Param.Value: string;
begin
  result := TPorosityLayer.WriteNewRoot + '.' + TInvPorosityParam.WriteParamName;
end;

{ TInvNodePMAX_Param }

class function TInvNodePMAX_Param.ANE_ParamName: string;
begin
  result := kInvPMAX;
end;

function TInvNodePMAX_Param.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + '.' + TInvMaxPermeabilityParam.WriteParamName;
end;

{ TInvNodePMIN_Param }

class function TInvNodePMIN_Param.ANE_ParamName: string;
begin
  result := kInvPMIN;
end;

function TInvNodePMIN_Param.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + '.' + TInvMinPermeabilityParam.WriteParamName;
end;

{ TInvNodeANGLE1_Param }

class function TInvNodeANGLE1_Param.ANE_ParamName: string;
begin
  result := kInvANGLE1;
end;

function TInvNodeANGLE1_Param.Value: string;
begin
  result := TPermeabilityLayer.WriteNewRoot + '.' + TInvPermeabilityAngleParam.WriteParamName;
end;

{ TInvNodeALMAX_Param }

class function TInvNodeALMAX_Param.ANE_ParamName: string;
begin
  result := kInvALMAX;
end;

function TInvNodeALMAX_Param.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + '.' + TInverseLongDispMaxParam.WriteParamName;
end;

{ TInvNodeALMIN_Param }

class function TInvNodeALMIN_Param.ANE_ParamName: string;
begin
  result := kInvALMIN;
end;

function TInvNodeALMIN_Param.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + '.' + TInverseLongDispMinParam.WriteParamName;
end;

{ TInvNodeATMAX_Param }

class function TInvNodeATMAX_Param.ANE_ParamName: string;
begin
  result := kInvATMAX;
end;

function TInvNodeATMAX_Param.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + '.' + TInverseTranDispMaxParam.WriteParamName;
end;

{ TInvNodeATMIN_Param }

class function TInvNodeATMIN_Param.ANE_ParamName: string;
begin
  result := kInvATMIN;
end;

function TInvNodeATMIN_Param.Value: string;
begin
  result := TDispersivityLayer.WriteNewRoot + '.' + TInverseTranDispMinParam.WriteParamName;
end;

{ TInvNodeQIN_Param }

class function TInvNodeQIN_Param.ANE_ParamName: string;
begin
  result := kInvQIN;
end;

function TInvNodeQIN_Param.Value: string;
begin
  result := 'If(' + TQINParam.ANE_ParamName + '!=0, ' +
  T2DFluidSourcesLayer.WriteNewRoot + '.' + TInverseSourceParam.WriteParamName
  + ', "")';
end;

{ TInvNodeUIN_Param }

class function TInvNodeUIN_Param.ANE_ParamName: string;
begin
  result := kInvUIN
end;

function TInvNodeUIN_Param.Value: string;
begin
  result := T2DFluidSourcesLayer.WriteNewRoot + '.' + TInverseSourceConcentrationParam.WriteParamName;
end;

{ TInvNodeQUIN_Param }

class function TInvNodeQUIN_Param.ANE_ParamName: string;
begin
  result := kInvQUIN;
end;

function TInvNodeQUIN_Param.Value: string;
begin
  result := T2DSoluteEnergySourcesLayer.WriteNewRoot + '.' + TInverseSpecifiedSoluteOrEnergySource.WriteParamName;
end;

{ TInvNodePBC_Param }

class function TInvNodePBC_Param.ANE_ParamName: string;
begin
  result := kInvPBC;
end;

function TInvNodePBC_Param.Value: string;
begin
  result := T2DSpecifiedPressureLayer.WriteNewRoot + '.' + TInvSpecPresParam.WriteParamName;
end;

{ TInvNodePUBC_Param }

class function TInvNodePUBC_Param.ANE_ParamName: string;
begin
  result := kInvPUBC
end;

function TInvNodePUBC_Param.Value: string;
begin
  result := T2DSpecifiedPressureLayer.WriteNewRoot + '.' + TInvSpecPresEnergyConcParam.WriteParamName;
end;

{ TInvNodeUBC_Param }

class function TInvNodeUBC_Param.ANE_ParamName: string;
begin
  result := kInvUBC;
end;

function TInvNodeUBC_Param.Value: string;
begin
  result := T2DSpecConcTempLayer.WriteNewRoot + '.' + TInvSpecConcParam.WriteParamName;
end;

{ TCustomInverseFunctionNodeParameter }

{ TCustomInverseFunctionNodeParameter }

{ TInvNodeFunctionPOR_Param }

//class function TInvNodeFunctionPOR_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionPOR;
//end;
//
//function TInvNodeFunctionPOR_Param.Value: string;
//begin
//  result := TPorosityLayer.WriteNewRoot + '.'
//    + TInvPorosityFunctionParam.WriteParamName;
//end;

{ TInvNodeFunctionPMAX_Param }

//class function TInvNodeFunctionPMAX_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionPMAX;
//end;

//function TInvNodeFunctionPMAX_Param.Value: string;
//begin
//  result := TPermeabilityLayer.WriteNewRoot + '.'
//    + TInvMaxPermeabilityFunctionParam.WriteParamName;
//end;

{ TInvNodeFunctionPMIN_Param }

//class function TInvNodeFunctionPMIN_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionPMIN;
//end;
//
//function TInvNodeFunctionPMIN_Param.Value: string;
//begin
//  result := TPermeabilityLayer.WriteNewRoot + '.'
//    + TInvMinPermeabilityFunctionParam.WriteParamName;
//end;

{ TInvNodeFunctionANGLE1_Param }

//class function TInvNodeFunctionANGLE1_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionANGLE1;
//end;
//
//function TInvNodeFunctionANGLE1_Param.Value: string;
//begin
//  result := TPermeabilityLayer.WriteNewRoot + '.'
//    + TInvPermeabilityAngleFunctionParam.WriteParamName;
//end;

{ TInvNodeFunctionALMAX_Param }

//class function TInvNodeFunctionALMAX_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionALMAX;
//end;
//
//function TInvNodeFunctionALMAX_Param.Value: string;
//begin
//  result := TDispersivityLayer.WriteNewRoot
//    + '.' + TInverseLongDispMaxFunctionParam.WriteParamName;
//end;

{ TInvNodeFunctionALMIN_Param }

//class function TInvNodeFunctionALMIN_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionALMIN;
//end;
//
//function TInvNodeFunctionALMIN_Param.Value: string;
//begin
//  result := TDispersivityLayer.WriteNewRoot
//    + '.' + TInverseLongDispMinFunctionParam.WriteParamName;
//end;

{ TInvNodeFunctionATMAX_Param }

//class function TInvNodeFunctionATMAX_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionATMAX;
//end;
//
//function TInvNodeFunctionATMAX_Param.Value: string;
//begin
//  result := TDispersivityLayer.WriteNewRoot
//    + '.' + TInverseTranDispMaxFunctionParam.WriteParamName;
//end;

{ TInvNodeFunctionATMIN_Param }

//class function TInvNodeFunctionATMIN_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionATMIN;
//end;
//
//function TInvNodeFunctionATMIN_Param.Value: string;
//begin
//  result := TDispersivityLayer.WriteNewRoot
//    + '.' + TInverseTranDispMinFunctionParam.WriteParamName;
//end;

{ TInvNodeFunctionQIN_Param }

//class function TInvNodeFunctionQIN_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionQIN;
//end;
//
//
//function TInvNodeFunctionQIN_Param.Value: string;
//begin
//  result := 'If(' + TQINParam.ANE_ParamName + '!=0, ' +
//  T2DFluidSourcesLayer.WriteNewRoot + '.' + TInverseSourceFunctionParam.WriteParamName
//  + ', "")';
//end;

{ TInvNodeFunctionUIN_Param }

//class function TInvNodeFunctionUIN_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionUIN;
//end;
//
//function TInvNodeFunctionUIN_Param.Value: string;
//begin
//  result := T2DFluidSourcesLayer.WriteNewRoot
//    + '.' + TInverseSourceConcentrationFunctionParam.WriteParamName;
//end;

{ TInvNodeFunctionQUIN_Param }

//class function TInvNodeFunctionQUIN_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionQUIN;
//end;
//
//function TInvNodeFunctionQUIN_Param.Value: string;
//begin
//  result := T2DSoluteEnergySourcesLayer.WriteNewRoot + '.' + TInverseSpecifiedSoluteOrEnergySourceFunction.WriteParamName;
//end;

{ TInvNodeFunctionPBC_Param }

//class function TInvNodeFunctionPBC_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionPBC;
//end;
//
//function TInvNodeFunctionPBC_Param.Value: string;
//begin
//  result := T2DSpecifiedPressureLayer.WriteNewRoot
//    + '.' + TInvSpecPresFunctionParam.WriteParamName;
//end;
//
{ TInvNodeFunctionPUBC_Param }

//class function TInvNodeFunctionPUBC_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionPUBC;
//end;
//
//function TInvNodeFunctionPUBC_Param.Value: string;
//begin
//  result := T2DSpecifiedPressureLayer.WriteNewRoot
//    + '.' + TInvSpecPresEnergyConcFunctionParam.WriteParamName;
//end;

{ TInvNodeFunctionUBC_Param }

//class function TInvNodeFunctionUBC_Param.ANE_ParamName: string;
//begin
//  result := kInvFunctionUBC;
//end;
//
//function TInvNodeFunctionUBC_Param.Value: string;
//begin
//  result := T2DSpecConcTempLayer.WriteNewRoot + '.' + TInvSpecConcFunctionParam.WriteParamName;
//end;

{ TInvHeadObsName_Param }

class function TInvHeadObsName_Param.ANE_ParamName: string;
begin
  result := kUcode_P_Observation;
end;

function TInvHeadObsName_Param.Value: string;
begin
  result := T2dUcodeHeadObservationLayer.WriteNewRoot + '.' + TObservationName.ANE_ParamName
end;

{ TCustomInverseElementParameter }

constructor TCustomInverseElementParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvString;
  if not frmSutra.rb3D_nva.Checked then
  begin
    ParameterType := mptElement;
  end;
end;

{ TPBC_CommentParam }

class function TPBC_CommentParam.ANE_ParamName: string;
begin
  result := kPBC_Comment;
end;

constructor TPBC_CommentParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
  Lock := Lock - [plDef_Val];
end;

function TPBC_CommentParam.Value: string;
var
  ParentIndexString: string;
begin
  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') then
    begin
      result :=
        TTopSpecifiedPressureLayer.WriteNewRoot + '.'
        + TCommentParam.WriteParamName;
    end
    else
    begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      result :=
        TBottomSpecifiedPressureLayer.WriteNewRoot + ParentIndexString + '.'
        + TCommentParam.WriteParamName;
    end;
  end
  else
  begin
    result :=
      T2DSpecifiedPressureLayer.WriteNewRoot + WriteParentIndex + '.'
      + TCommentParam.WriteParamName;

  end;
end;

{ TInvConcentrationObsName_Param }

class function TInvConcentrationObsName_Param.ANE_ParamName: string;
begin
  result := kUcode_U_Observation;
end;

function TInvConcentrationObsName_Param.Value: string;
begin
  result := T2dUcodeConcentrationObservationLayer.WriteNewRoot + '.'
    + TObservationName.ANE_ParamName
end;

{ TInvSaturationObsName_Param }

class function TInvSaturationObsName_Param.ANE_ParamName: string;
begin
  result := kUcode_Sat_Observation;
end;

function TInvSaturationObsName_Param.Value: string;
begin
  result := T2dUcodeSaturationObservationLayer.WriteNewRoot + '.'
    + TObservationName.ANE_ParamName
end;

{ TInvFluxObsName_Param }

class function TInvFluxObsName_Param.ANE_ParamName: string;
begin
  result := kUcode_Flux_Observation;
end;

function TInvFluxObsName_Param.Value: string;
begin
  result := T2dUcodeFluxObservationLayer.WriteNewRoot + '.'
    + TObservationName.ANE_ParamName
end;

{ TInvSoluteFluxObsName_Param }

class function TInvSoluteFluxObsName_Param.ANE_ParamName: string;
begin
  result := kUcode_Solute_Flux_Observation;
end;

function TInvSoluteFluxObsName_Param.Value: string;
begin
  result := T2dUcodeSoluteFluxObservationLayer.WriteNewRoot + '.'
    + TObservationName.ANE_ParamName
end;

{ TINOBTypeParam }

class function TINOBTypeParam.ANE_ParamName: string;
begin
  result := kObsType;
end;

constructor TINOBTypeParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
  ParameterType := mptNode;
end;

function TINOBTypeParam.Value: string;
var
  ParentIndexString: string;
begin
  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') {and frmSutra.rb3D_va.Checked} then
    begin
      result :=
        TTopObservationLayer.WriteNewRoot + '.'
        + TObservationTypeParam.WriteParamName;
    end
    else
    begin
      //      if frmSutra.rb3D_va.Checked then
      //      begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      //      end;
      result :=
        TBottomObservationLayer.WriteNewRoot + ParentIndexString + '.'
        + TObservationTypeParam.WriteParamName;
    end;
  end
  else
  begin
    result :=
      T2DObservationLayer.WriteNewRoot + WriteParentIndex + '.'
      + TObservationTypeParam.WriteParamName;
  end;
end;

{ TInvNodeThickness_Param }

class function TInvNodeThickness_Param.ANE_ParamName: string;
begin
  result := kInvTHICK;
end;

function TInvNodeThickness_Param.Value: string;
begin
  result := TThicknessLayer.WriteNewRoot + '.' + TInvThicknessParam.WriteParamName;
end;

{$IFDEF SutraIce}

{ TCS1Parameter }

class function TCS1Parameter.ANE_ParamName: string;
begin
  result := kCS1;
end;

class function TCS1Parameter.UsualValue: string;
begin
  result := TSpecificHeatLayer.WriteNewRoot + '.'
    + TSpecificHeatParam.WriteParamName;
end;

function TCS1Parameter.Value: string;
begin
  result := TSpecificHeatLayer.WriteNewRoot + WriteParentIndex + '.'
    + TSpecificHeatParam.WriteParamName;
end;

{ TSIGS }

class function TSIGS.ANE_ParamName: string;
begin
  result := kSIGS;
end;

function TSIGS.Value: string;
begin
  result := TThermalConductivityLayer.WriteNewRoot + WriteParentIndex + '.'
    + TThermalConductivityParam.WriteParamName;
end;

{ TGNUU0Param }
{$IFDEF OldSutraIce}

class function TGNUU0Param.ANE_ParamName: string;
begin
  result := kGNUU0;
end;

constructor TGNUU0Param.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
end;

class function TGNUU0Param.UsualValue: string;
begin
  result := 'if(NodeAboveCntr('
    + T2DSpecConcTempLayer.WriteNewRoot
    + '),'
    + T2DSpecConcTempLayer.WriteNewRoot + '.'
    + TConductance.WriteParamName
    + ',$n/a)';
end;

function TGNUU0Param.Value: string;
var
  ParentIndexString: string;
begin
  if frmSutra.Is3D then
  begin
    ParentIndexString := WriteParentIndex;
    if (ParentIndexString = '1') {and frmSutra.rb3D_va.Checked} then
    begin
      result := 'if(NodeAboveCntr('
        + TTopSpecConcTempLayer.WriteNewRoot
        + '),'
        + TTopSpecConcTempLayer.WriteNewRoot + '.'
        + TConductance.WriteParamName
        + ',$n/a)';

    end
    else
    begin
      //      if frmSutra.rb3D_va.Checked then
      //      begin
      ParentIndexString := IntToStr(StrToInt(ParentIndexString) - 1);
      //      end;
      result := 'if(NodeAboveCntr('
        + TBottomSpecConcTempLayer.WriteNewRoot + ParentIndexString
        + '),'
        + TBottomSpecConcTempLayer.WriteNewRoot + ParentIndexString + '.'
        + TConductance.WriteParamName
        + ',$n/a)';

    end;
  end
  else
  begin
    result := 'if(NodeAboveCntr('
      + T2DSpecConcTempLayer.WriteNewRoot + WriteParentIndex
      + '),'
      + T2DSpecConcTempLayer.WriteNewRoot + WriteParentIndex + '.'
      + TConductance.WriteParamName
      + ',$n/a)';

  end;
end;
{$ENDIF}
{$ENDIF}

end.

