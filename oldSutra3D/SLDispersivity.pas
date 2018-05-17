unit SLDispersivity;

interface

uses ANE_LayerUnit, SLCustomLayers;

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

  TMaxTransDisp2Param = class(TMaxTransDisp1Param)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMidTransDisp2Param = class(TMaxTransDisp1Param)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMinTransDisp2Param = class(TMaxTransDisp1Param)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TDispersivityLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class function WriteNewRoot : string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers;

ResourceString
  kMaxLongDisp = 'longdisp_in_max_permdir';
  kMidLongDisp = 'longdisp_in_mid_permdir';
  kMinLongDisp = 'longdisp_in_min_permdir';
  kMaxTransDisp1 = 'trandisp1_in_max_permdir';
  kMidTransDisp1 = 'trandisp1_in_mid_permdir';
  kMinTransDisp1 = 'trandisp1_in_min_permdir';
  kMaxTransDisp2 = 'trandisp2_in_max_permdir';
  kMidTransDisp2 = 'trandisp2_in_mid_permdir';
  kMinTransDisp2 = 'trandisp2_in_min_permdir';
  kMaxTransDisp = 'trandisp_in_max_permdir';
  kMidTransDisp = 'trandisp_in_mid_permdir';
  kMinTransDisp = 'trandisp_in_min_permdir';
  kDispersivity = 'Dispersivity';

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
  result := frmSutra.FramLongDispMax.adeProperty.Text;
end;

{ TMidLongDispParam }

class function TMidLongDispParam.ANE_ParamName: string;
begin
  result := kMidLongDisp;
end;

function TMidLongDispParam.Value: string;
begin
  result := frmSutra.FramLongDispMid.adeProperty.Text;
end;

{ TMinLongDispParam }

class function TMinLongDispParam.ANE_ParamName: string;
begin
  result := kMinLongDisp;
end;

function TMinLongDispParam.Value: string;
begin
  result := frmSutra.FramLongDispMin.adeProperty.Text;
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
  result := frmSutra.FramTransvDispMax.adeProperty.Text;
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
  result := frmSutra.FramTransvDisp1Mid.adeProperty.Text;
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
  result := frmSutra.FramTransvDispMin.adeProperty.Text;
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

class function TMaxTransDisp2Param.ANE_ParamName: string;
begin
  result := kMaxTransDisp2;
end;

function TMaxTransDisp2Param.Value: string;
begin
  result := frmSutra.FramTransvDisp2Max.adeProperty.Text;
end;

{ TMidTransDisp2Param }

class function TMidTransDisp2Param.ANE_ParamName: string;
begin
  result := kMidTransDisp2;
end;

function TMidTransDisp2Param.Value: string;
begin
  result := frmSutra.FramTransvDisp2Mid.adeProperty.Text;
end;

{ TMinTransDisp2Param }

class function TMinTransDisp2Param.ANE_ParamName: string;
begin
  result := kMinTransDisp2;
end;

function TMinTransDisp2Param.Value: string;
begin
  result := frmSutra.FramTransvDisp2Min.adeProperty.Text;
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
  ParamList.ParameterOrder.Add(TMaxTransDisp2Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TMidTransDisp2Param.ANE_ParamName);
  ParamList.ParameterOrder.Add(TMinTransDisp2Param.ANE_ParamName);

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
  if frmSutra.Is3D then
  begin
    TMaxTransDisp2Param.Create(ParamList, -1);
    TMidTransDisp2Param.Create(ParamList, -1);
    TMinTransDisp2Param.Create(ParamList, -1);
  end;
end;

class function TDispersivityLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraNodeSurfaceGroupLayer.WriteNewRoot;
  end;
end;

end.
