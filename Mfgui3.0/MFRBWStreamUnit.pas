unit MFRBWStreamUnit;

interface

uses ANE_LayerUnit, SysUtils;

const
  kMFRBWStreamSegmentParam = 'Segment Number';
  kMFRBWStreamDownstreamSegmentParam = 'Downstream Segment Number';
  kMFRBWStreamDiversionSegmentParam = 'Upstream Diversion Segment Number';
  kMFRBWStreamHydCondParam = 'Streambed hydraulic conductivity';
  kMFRBWStreamFlowParam = 'Flow';
  kMFRBWStreamUpStageParam = 'Upstream Stage';
  kMFRBWStreamDownStageParam = 'Downstream Stage';
  kMFRBWStreamUpTopElevParam = 'Upstream top elevation';
  kMFRBWStreamDownTopElevParam = 'Downstream top elevation';
  kMFRBWStreamUpBotElevParam = 'Upstream bottom elevation';
  kMFRBWStreamDownBotElevParam = 'Downstream bottom elevation';
  kMFRBWStreamUpWidthParam = 'Upstream width';
  kMFRBWStreamDownWidthParam = 'Downstream width';
  kMFRBWStreamSlopeParam = 'Slope';
  kMFRBWStreamRoughParam = 'Mannings roughness';
  kMFRBWStreamLayer = 'Stream Unit';


type
  TRBWStreamSegmentParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    Constructor Create(Index : Integer;
      AParameterList : T_ANE_ParameterList); override;
    function Units : string; override;
  end;

  TRBWStreamDownstreamSegmentParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    Constructor Create(Index : Integer;
      AParameterList : T_ANE_ParameterList); override;
    function Units : string; override;
    function Value : string; override;
  end;

  TRBWStreamDiversionSegmentParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    Constructor Create(Index : Integer;
      AParameterList : T_ANE_ParameterList); override;
    function Units : string; override;
    function Value : string; override;
  end;

  TRBWStreamHydCondParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TRBWStreamFlowParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    function Units : string; override;
  end;

  TRBWStreamUpStageParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    function Units : string; override;
  end;

  TRBWStreamDownStageParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TRBWStreamUpTopElevParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    function Units : string; override;
  end;

  TRBWStreamDownTopElevParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TRBWStreamUpBotElevParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    function Units : string; override;
  end;

  TRBWStreamDownBotElevParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TRBWStreamUpWidthParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    function Units : string; override;
  end;

  TRBWStreamDownWidthParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TRBWStreamSlopeParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    function Units : string; override;
  end;

  TRBWStreamRoughParam = class(T_ANE_LayerParam)
    class Function ANE_Name : string ; override;
    function Units : string; override;
  end;

  TRBWStreamTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create(Index: Integer; AnOwner :
      T_ANE_ListOfIndexedParameterLists); override;
  end;

  TRBWStreamLayer = Class(T_ANE_InfoLayer)
    constructor Create(Index: Integer; ALayerList : T_ANE_LayerList); override;
    class Function ANE_Name : string ; override;
  end;

implementation

uses MainFormUnit;

class Function TRBWStreamSegmentParam.ANE_Name : string ;
begin
  result := kMFRBWStreamSegmentParam;
end;

Constructor TRBWStreamSegmentParam.Create(Index : Integer;
            AParameterList : T_ANE_ParameterList);
begin
  inherited Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TRBWStreamSegmentParam.Units : string;
begin
  result := '';
end;

//---------------------------

class Function TRBWStreamDownstreamSegmentParam.ANE_Name : string ;
begin
  result := kMFRBWStreamDownstreamSegmentParam;
end;

Constructor TRBWStreamDownstreamSegmentParam.Create(Index : Integer;
            AParameterList : T_ANE_ParameterList);
begin
  inherited Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TRBWStreamDownstreamSegmentParam.Units : string;
begin
  result := '';
end;

function TRBWStreamDownstreamSegmentParam.Value : string;
begin
  result := kNA;
end;
//---------------------------

class Function TRBWStreamDiversionSegmentParam.ANE_Name : string ;
begin
  result := kMFRBWStreamDiversionSegmentParam;
end;

Constructor TRBWStreamDiversionSegmentParam.Create(Index : Integer;
            AParameterList : T_ANE_ParameterList);
begin
  inherited Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TRBWStreamDiversionSegmentParam.Units : string;
begin
  result := '';
end;

function TRBWStreamDiversionSegmentParam.Value : string;
begin
  result := kNA;
end;
//---------------------------
class Function TRBWStreamHydCondParam.ANE_Name : string ;
begin
  result := kMFRBWStreamHydCondParam;
end;

function TRBWStreamHydCondParam.Units : string;
begin
  result := 'L/t';
end;

function TRBWStreamHydCondParam.Value : string;
begin
  result := '100';
end;
//---------------------------
class Function TRBWStreamFlowParam.ANE_Name : string ;
begin
  result := kMFRBWStreamFlowParam;
end;

function TRBWStreamFlowParam.Units : string;
begin
  result := 'L^3/t';
end;

//---------------------------
class Function TRBWStreamUpStageParam.ANE_Name : string ;
begin
  result := kMFRBWStreamUpStageParam;
end;

function TRBWStreamUpStageParam.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TRBWStreamDownStageParam.ANE_Name : string ;
begin
  result := kMFRBWStreamDownStageParam;
end;

function TRBWStreamDownStageParam.Units : string;
begin
  result := 'L';
end;

function TRBWStreamDownStageParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TRBWStreamUpTopElevParam.ANE_Name : string ;
begin
  result := kMFRBWStreamUpTopElevParam;
end;

function TRBWStreamUpTopElevParam.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TRBWStreamDownTopElevParam.ANE_Name : string ;
begin
  result := kMFRBWStreamDownTopElevParam;
end;

function TRBWStreamDownTopElevParam.Units : string;
begin
  result := 'L';
end;

function TRBWStreamDownTopElevParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TRBWStreamUpBotElevParam.ANE_Name : string ;
begin
  result := kMFRBWStreamUpBotElevParam;
end;

function TRBWStreamUpBotElevParam.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TRBWStreamDownBotElevParam.ANE_Name : string ;
begin
  result := kMFRBWStreamDownBotElevParam;
end;

function TRBWStreamDownBotElevParam.Units : string;
begin
  result := 'L';
end;

function TRBWStreamDownBotElevParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TRBWStreamUpWidthParam.ANE_Name : string ;
begin
  result := kMFRBWStreamUpWidthParam;
end;

function TRBWStreamUpWidthParam.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TRBWStreamDownWidthParam.ANE_Name : string ;
begin
  result := kMFRBWStreamDownWidthParam;
end;

function TRBWStreamDownWidthParam.Units : string;
begin
  result := 'L';
end;

function TRBWStreamDownWidthParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TRBWStreamSlopeParam.ANE_Name : string ;
begin
  result := kMFRBWStreamSlopeParam;
end;

function TRBWStreamSlopeParam.Units : string;
begin
  result := 'L/L';
end;

//---------------------------
class Function TRBWStreamRoughParam.ANE_Name : string ;
begin
  result := kMFRBWStreamRoughParam;
end;

function TRBWStreamRoughParam.Units : string;
begin
  result := 't/L^1/3';
end;

//---------------------------
constructor TRBWStreamTimeParamList.Create(Index: Integer; AnOwner :
      T_ANE_ListOfIndexedParameterLists);
begin
  inherited Create(Index, AnOwner);

  ParameterOrder.Add(TRBWStreamFlowParam.Ane_Name);
  ParameterOrder.Add(TRBWStreamUpStageParam.Ane_Name);
  ParameterOrder.Add(TRBWStreamDownStageParam.Ane_Name);
  ParameterOrder.Add(TRBWStreamUpTopElevParam.Ane_Name);
  ParameterOrder.Add(TRBWStreamDownTopElevParam.Ane_Name);
  ParameterOrder.Add(TRBWStreamUpBotElevParam.Ane_Name);
  ParameterOrder.Add(TRBWStreamDownBotElevParam.Ane_Name);
  ParameterOrder.Add(TRBWStreamUpWidthParam.Ane_Name);
  ParameterOrder.Add(TRBWStreamDownWidthParam.Ane_Name);
  ParameterOrder.Add(TRBWStreamSlopeParam.Ane_Name);
  ParameterOrder.Add(TRBWStreamRoughParam.Ane_Name);

  TRBWStreamFlowParam.Create(-1, self);
  TRBWStreamUpStageParam.Create(-1, self);
  TRBWStreamDownStageParam.Create(-1, self);
  TRBWStreamUpTopElevParam.Create(-1, self);
  TRBWStreamDownTopElevParam.Create(-1, self);
  TRBWStreamUpBotElevParam.Create(-1, self);
  TRBWStreamDownBotElevParam.Create(-1, self);
  TRBWStreamUpWidthParam.Create(-1, self);
  TRBWStreamDownWidthParam.Create(-1, self);
  if frmMODFLOW.cbRBWCalculateStage.Checked then
  begin
    TRBWStreamSlopeParam.Create(-1, self);
    TRBWStreamRoughParam.Create(-1, self);
  end;
{  if frmMODFLOW.cbMOC3D.Checked then
  begin
    TConcentration.Create(-1, self);
  end;}

end;
//---------------------------
constructor TRBWStreamLayer.Create(Index: Integer;
  ALayerList : T_ANE_LayerList);
var
  TimeIndex : Integer;
begin
  inherited Create(Index, ALayerList);

  ParamList.ParameterOrder.Add(TRBWStreamSegmentParam.ANE_Name);
  ParamList.ParameterOrder.Add(TRBWStreamDownstreamSegmentParam.ANE_Name);
  ParamList.ParameterOrder.Add(TRBWStreamDiversionSegmentParam.ANE_Name);
  ParamList.ParameterOrder.Add(TRBWStreamHydCondParam.ANE_Name);

  TRBWStreamSegmentParam.Create(-1, ParamList);

  if frmMODFLOW.cbRBWUseTributaries.Checked then
  begin
    TRBWStreamDownstreamSegmentParam.Create(-1, ParamList);
  end;

  if frmMODFLOW.cbRBWUseDiversions.Checked then
  begin
    TRBWStreamDiversionSegmentParam.Create(-1, ParamList);
  end;

  TRBWStreamHydCondParam.Create(-1, ParamList);

  For TimeIndex := 1 to StrToInt(frmMODFLOW.edNumPer.Text) do
  begin
    GetMFRBWStreamTimeParamListType.Create(-1, IndexedParamList2);
  end;
end;

class Function TRBWStreamLayer.ANE_Name : string ;
begin
  result := kMFRBWStreamLayer;
end;

//---------------------------

end.
