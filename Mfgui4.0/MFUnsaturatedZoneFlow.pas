unit MFUnsaturatedZoneFlow;

interface

uses ANE_LayerUnit, SysUtils, MFGenParam;

Type
  TUzfSaturatedKz = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TUzfBrooksCoreyEpsilon = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TUzfSaturatedWaterContent = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TUzfInitialWaterContent = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TUzfExtinctionDepth = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TUzfExtinctionWaterContent = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TUzfInfiltrationRate = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TUzfPotentialEvapotranspiration = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TUzfTimeParamList = class( TSteadyTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
    function IsSteadyStress : boolean; override;
  end;

  TUzfFlowLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TUzfLayerParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
  end;

  TUzfLayer = class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TUzfStreamLakeParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
  end;

  TUzfStreamLakeLayer = class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TUzfOutputParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
    function Units: string; override;
  end;

  TUzfOutputLayer = class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TUzfGroupLayer = class(T_ANE_GroupLayer)
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

const
  kSaturatedKz = 'Saturated Kz';
  kBrooksCoreyEpsilon = 'Brooks_Corey Epsilon';
  kSaturatedWaterContent = 'Saturated Water Content';
  kInitialWaterContent = 'Initial Water Content';
  kExtinctionDepth = 'Extinction Depth';
  kExtinctionWaterContent = 'Extinction Water Content';
  kInfiltrationRate = 'Infiltration Rate';
  kPotentialEvapotranspiration = 'Potential Evapotranspiration';
  kUzfFlow = 'UZF Flow';
  kUzfLayer = 'UZF Layer';
  kUzfStreamOrLake = 'UZF Stream or Lake';
  kUzfOutput = 'UZF Output';
  kUzfGroup = 'Unsaturated Zone Flow';


{ TUzfSaturatedKz }

class function TUzfSaturatedKz.ANE_ParamName: string;
begin
  result := kSaturatedKz;
end;

function TUzfSaturatedKz.Units: string;
begin
  Result := LengthUnit + '/' + TimeUnit;
end;

function TUzfSaturatedKz.Value: string;
begin
  result := '1';
end;

{ TUzfBrooksCoreyEpsilon }

class function TUzfBrooksCoreyEpsilon.ANE_ParamName: string;
begin
  result := kBrooksCoreyEpsilon;
end;

function TUzfBrooksCoreyEpsilon.Value: string;
begin
  result := '3.5';
end;

{ TUzfSaturatedWaterContent }

class function TUzfSaturatedWaterContent.ANE_ParamName: string;
begin
  result := kSaturatedWaterContent;
end;

function TUzfSaturatedWaterContent.Units: string;
begin
  result := '0 to 1';
end;

function TUzfSaturatedWaterContent.Value: string;
begin
  result := '0.3';
end;

{ TUzfInitialWaterContent }

class function TUzfInitialWaterContent.ANE_ParamName: string;
begin
  result := kInitialWaterContent;
end;

function TUzfInitialWaterContent.Units: string;
begin
  result := '0 to 1';
end;

function TUzfInitialWaterContent.Value: string;
begin
  result := '0.3';
end;

{ TUzfExtinctionDepth }

class function TUzfExtinctionDepth.ANE_ParamName: string;
begin
  result := kExtinctionDepth;
end;

function TUzfExtinctionDepth.Units: string;
begin
  Result := LengthUnit;
end;

function TUzfExtinctionDepth.Value: string;
begin
  result := '1';
end;

{ TUzfExtinctionWaterContent }

class function TUzfExtinctionWaterContent.ANE_ParamName: string;
begin
  result := kExtinctionWaterContent;
end;

function TUzfExtinctionWaterContent.Units: string;
begin
  result := '0 to 1';
end;

function TUzfExtinctionWaterContent.Value: string;
begin
  result := '0.1';
end;

{ TUzfInfiltrationRate }

class function TUzfInfiltrationRate.ANE_ParamName: string;
begin
  result := KInfiltrationRate;
end;

function TUzfInfiltrationRate.Units: string;
begin
  Result := LengthUnit + '/' + TimeUnit;
end;

{ TUzfPotentialEvapotranspiration }

class function TUzfPotentialEvapotranspiration.ANE_ParamName: string;
begin
  result := kPotentialEvapotranspiration;
end;

function TUzfPotentialEvapotranspiration.Units: string;
begin
  Result := LengthUnit + '/' + TimeUnit;
end;

{ TUzfTimeParamList }

constructor TUzfTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;

  ParameterOrder.Add(ModflowTypes.GetMFUzfInfiltrationRateParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFUzfPotentialEvapotranspirationParamType.ANE_ParamName);

  ModflowTypes.GetMFUzfInfiltrationRateParamType.Create( self, -1);
  if frmMODFLOW.cbUzfIETFLG.Checked then
  begin
    ModflowTypes.GetMFUzfPotentialEvapotranspirationParamType.Create( self, -1);
  end;

end;

function TUzfTimeParamList.IsSteadyStress: boolean;
begin
  result := frmModflow.comboUzfTransient.ItemIndex = 0;
end;

{ TUzfFlowLayer }

class function TUzfFlowLayer.ANE_LayerName: string;
begin
  result := kUzfFlow;
end;

constructor TUzfFlowLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  NumberOfTimes: integer;
  TimeIndex: integer;
begin
  inherited;

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFUzfSaturatedKzParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFUzfBrooksCoreyEpsilonParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFUzfSaturatedWaterContentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFUzfInitialWaterContentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFUzfExtinctionDepthParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFUzfExtinctionWaterContentParamType.ANE_ParamName);

  if not frmMODFLOW.cbUzfIUZFOPT.Checked then
  begin
    ModflowTypes.GetMFUzfSaturatedKzParamType.Create(ParamList, -1);
  end;

  ModflowTypes.GetMFUzfBrooksCoreyEpsilonParamType.Create(ParamList, -1);
  ModflowTypes.GetMFUzfSaturatedWaterContentParamType.Create(ParamList, -1);
  ModflowTypes.GetMFUzfInitialWaterContentParamType.Create(ParamList, -1);

  if frmMODFLOW.cbUzfIETFLG.Checked then
  begin
    ModflowTypes.GetMFUzfExtinctionDepthParamType.Create(ParamList, -1);
    ModflowTypes.GetMFUzfExtinctionWaterContentParamType.Create(ParamList, -1);
  end;

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFUzfTimeParamListType.Create( IndexedParamList2, -1);
  end;
end;

{ TUzfLayerParam }

class function TUzfLayerParam.ANE_ParamName: string;
begin
  result := kUzfLayer;
end;

constructor TUzfLayerParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TUzfLayerParam.Value: string;
begin
  result := '1';
end;

{ TUzfLayer }

class function TUzfLayer.ANE_LayerName: string;
begin
  result := kUzfLayer;
end;

constructor TUzfLayer.Create(ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited;
  Interp := leExact;
  ModflowTypes.GetMFUzfLayerParamType.Create(ParamList, -1);
end;

{ TUzfStreamLakeParam }

class function TUzfStreamLakeParam.ANE_ParamName: string;
begin
  result := kUzfStreamOrLake;
end;

constructor TUzfStreamLakeParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TUzfStreamLakeParam.Value: string;
begin
  result := '0';
end;

{ TUzfStreamLakeLayer }

class function TUzfStreamLakeLayer.ANE_LayerName: string;
begin
  result := kUzfStreamOrLake;
end;

constructor TUzfStreamLakeLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := leExact;
  ModflowTypes.GetMFUzfStreamLakeParamType.Create(ParamList, -1);
end;

{ TUzfOutputParam }

class function TUzfOutputParam.ANE_ParamName: string;
begin
  result := kUzfOutput;
end;

constructor TUzfOutputParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TUzfOutputParam.Units: string;
begin
  result := '0 to 3';
end;

function TUzfOutputParam.Value: string;
begin
  result := '0';
end;

{ TUzfOutputLayer }

class function TUzfOutputLayer.ANE_LayerName: string;
begin
  result := kUzfOutput;
end;

constructor TUzfOutputLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := leExact;
  ModflowTypes.GetMFUzfOutputParamType.Create(ParamList, -1);
end;

{ TUzfGroupLayer }

class function TUzfGroupLayer.ANE_LayerName: string;
begin
  result := kUzfGroup;
end;

end.
