unit SLDispersivity;

interface

uses ANE_LayerUnit, SLCustomLayers, SLGeneralParameters;

type
  TMaxLongDispParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMidLongDispParam = class(TMaxLongDispParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMinLongDispParam = class(TMaxLongDispParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMaxTransDisp1Param = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    class function WriteParamName : string ; override;
  end;

  TMidTransDisp1Param = class(TMaxTransDisp1Param)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    class function WriteParamName : string ; override;
  end;

  TMinTransDisp1Param = class(TMaxTransDisp1Param)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    class function WriteParamName : string ; override;
  end;

  TInverseLongDispMaxParam = class(TCustomInverseParameter)
    class Function ANE_ParamName : string ; override;
  end;

//  TInverseLongDispMaxFunctionParam = class(TCustomInverseParameter)
//    class Function ANE_ParamName : string ; override;
//  end;

  TInverseLongDispMinParam = class(TCustomInverseParameter)
    class Function ANE_ParamName : string ; override;
  end;

//  TInverseLongDispMinFunctionParam = class(TCustomInverseParameter)
//    class Function ANE_ParamName : string ; override;
//  end;

  TInverseTranDispMaxParam = class(TCustomInverseParameter)
    class Function ANE_ParamName : string ; override;
  end;

//  TInverseTranDispMaxFunctionParam = class(TCustomInverseParameter)
//    class Function ANE_ParamName : string ; override;
//  end;

  TInverseTranDispMinParam = class(TCustomInverseParameter)
    class Function ANE_ParamName : string ; override;
  end;

//  TInverseTranDispMinFunctionParam = class(TCustomInverseParameter)
//    class Function ANE_ParamName : string ; override;
//  end;

  TDispersivityLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot : string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers;

ResourceString
  kMaxLongDisp = 'longdisp_in_max_permdir';
  kMidLongDisp = 'longdisp_in_mid_permdir';
  kMinLongDisp = 'longdisp_in_min_permdir';
  kMaxTransDisp1 = 'trandisp_in_max_permdir';
  kMidTransDisp1 = 'trandisp_in_mid_permdir';
  kMinTransDisp1 = 'trandisp_in_min_permdir';
  kMaxTransDisp = 'trandisp_in_max_permdir';
  kMidTransDisp = 'trandisp_in_mid_permdir';
  kMinTransDisp = 'trandisp_in_min_permdir';
  kDispersivity = 'Dispersivity';

  kInvLongDispMax = 'UString_LongMax';
  kInvLongDispMin = 'UString_LongMin';
  kInvTransDispMax = 'UString_TranMax';
  kInvTransDispMin = 'UString_TranMin';
//  kInvLongDispMaxFunction = 'UFunction_LongMax';
//  kInvLongDispMinFunction = 'UFunction_LongMin';
//  kInvTransDispMaxFunction = 'UFunction_TranMax';
//  kInvTransDispMinFunction = 'UFunction_TranMin';


{ TMaxLongDispParam }

class function TMaxLongDispParam.ANE_ParamName: string;
begin
  result := kMaxLongDisp;
end;

function TMaxLongDispParam.Units: string;
begin
  Result := 'L';
end;

function TMaxLongDispParam.Value: string;
begin
  result := frmSutra.frmParameterValues.FramLongDispMax.adeProperty.Output;
end;

{ TMidLongDispParam }

class function TMidLongDispParam.ANE_ParamName: string;
begin
  result := kMidLongDisp;
end;

function TMidLongDispParam.Value: string;
begin
  result := frmSutra.frmParameterValues.FramLongDispMid.adeProperty.Output;
end;

{ TMinLongDispParam }

class function TMinLongDispParam.ANE_ParamName: string;
begin
  result := kMinLongDisp;
end;

function TMinLongDispParam.Value: string;
begin
  result := frmSutra.frmParameterValues.FramLongDispMin.adeProperty.Output;
end;

{ TMaxTransDisp1Param }

class function TMaxTransDisp1Param.ANE_ParamName: string;
begin
  result := kMaxTransDisp1;
end;

function TMaxTransDisp1Param.Units: string;
begin
  result := 'L';
end;

function TMaxTransDisp1Param.Value: string;
begin
  result := frmSutra.frmParameterValues.FramTransvDispMax.adeProperty.Output;
end;

class function TMaxTransDisp1Param.WriteParamName: string;
begin
  if frmSutra.rgDimensions.ItemIndex = 0 then
  begin
    result := kMaxTransDisp;
  end
  else
  begin
    result := ANE_ParamName;
  end;
end;

{ TMidTransDisp1Param }

class function TMidTransDisp1Param.ANE_ParamName: string;
begin
  result := kMidTransDisp1;
end;

function TMidTransDisp1Param.Value: string;
begin
  result := frmSutra.frmParameterValues.FramTransvDisp1Mid.adeProperty.Output;
end;

class function TMidTransDisp1Param.WriteParamName: string;
begin
  if frmSutra.rgDimensions.ItemIndex = 0 then
  begin
    result := kMidTransDisp;
  end
  else
  begin
    result := ANE_ParamName;
  end;
end;

{ TMinTransDisp1Param }

class function TMinTransDisp1Param.ANE_ParamName: string;
begin
  result := kMinTransDisp1;
end;

function TMinTransDisp1Param.Value: string;
begin
  result := frmSutra.frmParameterValues.FramTransvDispMin.adeProperty.Output;
end;

class function TMinTransDisp1Param.WriteParamName: string;
begin
  if frmSutra.rgDimensions.ItemIndex = 0 then
  begin
    result := kMinTransDisp;
  end
  else
  begin
    result := ANE_ParamName;
  end;
end;

{ TMaxTransDisp2Param }

{class function TMaxTransDisp2Param.ANE_ParamName: string;
begin
  result := kMaxTransDisp2;
end;

function TMaxTransDisp2Param.Value: string;
begin
  result := frmSutra.FramTransvDisp2Max.adeProperty.Output;
end;

{ TMidTransDisp2Param }

{class function TMidTransDisp2Param.ANE_ParamName: string;
begin
  result := kMidTransDisp2;
end;

function TMidTransDisp2Param.Value: string;
begin
  result := frmSutra.FramTransvDisp2Mid.adeProperty.Output;
end;

{ TMinTransDisp2Param }

{class function TMinTransDisp2Param.ANE_ParamName: string;
begin
  result := kMinTransDisp2;
end;

function TMinTransDisp2Param.Value: string;
begin
  result := frmSutra.FramTransvDisp2Min.adeProperty.Output;
end;

{ TDispersivityLayer }

class function TDispersivityLayer.ANE_LayerName: string;
begin
  result := kDispersivity
end;

constructor TDispersivityLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Add(TMaxLongDispParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TMidLongDispParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TMinLongDispParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TMaxTransDisp1Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TMidTransDisp1Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TMinTransDisp1Param.ANE_ParamName);

  ParamList.ParameterOrder.Add(TInverseLongDispMaxParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInverseLongDispMaxFunctionParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInverseLongDispMinParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInverseLongDispMinFunctionParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInverseTranDispMaxParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInverseTranDispMaxFunctionParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInverseTranDispMinParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInverseTranDispMinFunctionParam.ANE_ParamName);

  TMaxLongDispParam.Create(ParamList, -1);
  if frmSutra.Is3D then
  begin
    TMidLongDispParam.Create(ParamList, -1);
  end;
  TMinLongDispParam.Create(ParamList, -1);
  TMaxTransDisp1Param.Create(ParamList, -1);
  if frmSutra.Is3D then
  begin
    TMidTransDisp1Param.Create(ParamList, -1);
  end;
  TMinTransDisp1Param.Create(ParamList, -1);

  if frmSutra.cbInverse.Checked
    or frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TInverseLongDispMaxParam.Create(ParamList, -1);
//    TInverseLongDispMaxFunctionParam.Create(ParamList, -1);
    TInverseLongDispMinParam.Create(ParamList, -1);
//    TInverseLongDispMinFunctionParam.Create(ParamList, -1);
    TInverseTranDispMaxParam.Create(ParamList, -1);
//    TInverseTranDispMaxFunctionParam.Create(ParamList, -1);
    TInverseTranDispMinParam.Create(ParamList, -1);
//    TInverseTranDispMinFunctionParam.Create(ParamList, -1);
  end;
end;

class function TDispersivityLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;

{ TInverseLongDispMaxParam }

class function TInverseLongDispMaxParam.ANE_ParamName: string;
begin
  result := kInvLongDispMax;
end;

{ TInverseLongDispMinParam }

class function TInverseLongDispMinParam.ANE_ParamName: string;
begin
  result := kInvLongDispMin;
end;

{ TInverseTranDispMaxParam }

class function TInverseTranDispMaxParam.ANE_ParamName: string;
begin
  result := kInvTransDispMax;
end;

{ TInverseTranDispMinParam }

class function TInverseTranDispMinParam.ANE_ParamName: string;
begin
  result := kInvTransDispMin;
end;

{ TInverseLongDispMaxFunctionParam }

//class function TInverseLongDispMaxFunctionParam.ANE_ParamName: string;
//begin
//  result := kInvLongDispMaxFunction;
//end;

{ TInverseLongDispMinFunctionParam }

//class function TInverseLongDispMinFunctionParam.ANE_ParamName: string;
//begin
//  result := kInvLongDispMinFunction;
//end;

{ TInverseTranDispMaxFunctionParam }

//class function TInverseTranDispMaxFunctionParam.ANE_ParamName: string;
//begin
//  result := kInvTransDispMaxFunction;
//end;

{ TInverseTranDispMinFunctionParam }

//class function TInverseTranDispMinFunctionParam.ANE_ParamName: string;
//begin
//  result := kInvTransDispMinFunction;
//end;

end.
