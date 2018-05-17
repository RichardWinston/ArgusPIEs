unit MFStreamUnit;

interface

{MFStreamUnit defines the "Stream Unit[i]" layer
 and the associated parameters and Parameterlist.}

uses ANE_LayerUnit, SysUtils;

type
  TStreamSegNum = class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamDownSegNum = class(TStreamSegNum)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
    end;

  TStreamDivSegNum = class(TStreamSegNum)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : string; override;
  end;

  TStreamHydCondParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TStreamFlow = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamUpStage = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamDownStage = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TStreamUpBotElev = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamDownBotElev = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TStreamUpTopElev = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamDownTopElev = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TStreamUpWidthParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamDownWidthParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TStreamSlope = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamRough = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TStreamTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TStreamLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFSegmentNum = 'Segment Number';
  kMFDownSegmentNum = 'Downstream Segment Number';
  kMFDivSegmentNum = 'Upstream Diversion Segment Number';
  kMFStreamHydCondParam = 'Streambed hydraulic conductivity';
  kMFStreamFlow = 'Flow';
  kMFStreamUpStage = 'Upstream Stage';
  kMFStreamDownStage = 'Downstream Stage';
  kMFStreamCond = 'Conductance per length';
  kMFStreamUpBotElev = 'Upstream bottom elevation';
  kMFStreamDownBotElev = 'Downstream bottom elevation';
  kMFStreamUpTopElev = 'Upstream top elevation';
  kMFStreamDownTopElev = 'Downstream top elevation';
  kMFStreamUpWidthParam = 'Upstream width';
  kMFStreamDownWidthParam = 'Downstream width';
  kMFStreamWidth = 'Width';
  kMFStreamSlope = 'Slope';
  kMFStreamRough = 'Mannings roughness';
  kMFStreamLayer = 'Stream Unit';

constructor TStreamSegNum.Create(
      AParameterList : T_ANE_ParameterList; Index : Integer);
begin
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TStreamSegNum.ANE_ParamName : string ;
begin
  result := kMFSegmentNum;
end;

function TStreamSegNum.Units : string;
begin
  result := '';
end;

//---------------------------
class Function TStreamDownSegNum.ANE_ParamName : string ;
begin
  result := kMFDownSegmentNum;
end;

constructor TStreamDownSegNum.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;

end;

function TStreamDownSegNum.Value: string;
begin
  result := kNa;
end;

//---------------------------
class Function TStreamDivSegNum.ANE_ParamName : string ;
begin
  result := kMFDivSegmentNum;
end;

constructor TStreamDivSegNum.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

function TStreamDivSegNum.Value: string;
begin
  result := kNA;

end;

//---------------------------
{ TStreamHydCondParam }

class function TStreamHydCondParam.ANE_ParamName: string;
begin
  result := kMFStreamHydCondParam;
end;

function TStreamHydCondParam.Units: string;
begin
  result := 'L/t';
end;

function TStreamHydCondParam.Value: string;
begin
  result := '100';
end;


//---------------------------
class Function TStreamFlow.ANE_ParamName : string ;
begin
  result := kMFStreamFlow;
end;

function TStreamFlow.Units : string;
begin
  result := 'L^3/t';
end;

//---------------------------
class Function TStreamUpStage.ANE_ParamName : string ;
begin
  result := kMFStreamUpStage;
end;

function TStreamUpStage.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TStreamDownStage.ANE_ParamName : string ;
begin
  result := kMFStreamDownStage;
end;

function TStreamDownStage.Units : string;
begin
  result := 'L';
end;

function TStreamDownStage.Value : string;
begin
  result := kNA;
end;

//---------------------------
{class Function TStreamCond.ANE_ParamName : string ;
begin
  result := kMFStreamCond;
end;

function TStreamCond.Units : string;
begin
  result := 'L/t';
end;
}
//---------------------------
class Function TStreamUpBotElev.ANE_ParamName : string ;
begin
  result := kMFStreamUpBotElev;
end;

function TStreamUpBotElev.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TStreamDownBotElev.ANE_ParamName : string ;
begin
  result := kMFStreamDownBotElev;
end;

function TStreamDownBotElev.Units : string;
begin
  result := 'L';
end;

function TStreamDownBotElev.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TStreamUpTopElev.ANE_ParamName : string ;
begin
  result := kMFStreamUpTopElev;
end;

function TStreamUpTopElev.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TStreamDownTopElev.ANE_ParamName : string ;
begin
  result := kMFStreamDownTopElev;
end;

function TStreamDownTopElev.Units : string;
begin
  result := 'L';
end;

function TStreamDownTopElev.Value : string;
begin
  result := kNA;
end;

//---------------------------
{class Function TStreamWidth.ANE_ParamName : string ;
begin
  result := kMFStreamWidth;
end;

function TStreamWidth.Units : string;
begin
  result := 'L';
end;
}
//---------------------------
class Function TStreamSlope.ANE_ParamName : string ;
begin
  result := kMFStreamSlope;
end;

function TStreamSlope.Units : string;
begin
  result := 'L/L';
end;

//---------------------------
class Function TStreamRough.ANE_ParamName : string ;
begin
  result := kMFStreamRough;
end;

function TStreamRough.Units : string;
begin
  result := 't/L^(1/3)';
end;

//---------------------------
constructor TStreamTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create(AnOwner, Position);

  ParameterOrder.Add(ModflowTypes.GetMFStreamFlowParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamUpStageParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamDownStageParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamUpBotElevParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamDownBotElevParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamUpTopElevParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamDownTopElevParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamUpWidthParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamDownWidthParamType.ANE_ParamName);
//  ParameterOrder.Add(TStreamWidth.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamSlopeParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFStreamRoughParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);

  ModflowTypes.GetMFStreamFlowParamType.Create(self, -1);
  ModflowTypes.GetMFStreamUpStageParamType.Create( self, -1);
  ModflowTypes.GetMFStreamDownStageParamType.Create( self, -1);

  ModflowTypes.GetMFStreamUpBotElevParamType.Create( self, -1);
  ModflowTypes.GetMFStreamDownBotElevParamType.Create( self, -1);
  ModflowTypes.GetMFStreamUpTopElevParamType.Create( self, -1);
  ModflowTypes.GetMFStreamDownTopElevParamType.Create( self, -1);
  ModflowTypes.GetMFStreamUpWidthParamType.Create( self, -1);
  ModflowTypes.GetMFStreamDownWidthParamType.Create( self, -1);

  if frmMODFLOW.cbStreamCalcFlow.Checked then
  begin
//    TStreamWidth.Create( self, -1);
    ModflowTypes.GetMFStreamSlopeParamType.Create( self, -1);
    ModflowTypes.GetMFStreamRoughParamType.Create( self, -1);
  end;

{  if frmMODFLOW.cbStreamTrib.Checked then
  begin
    ModflowTypes.GetMFStreamDownSegNumParamType.Create( self, -1);
  end; }

  if frmMODFLOW.cbMODPATH.Checked then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;
end;

//---------------------------
constructor TStreamLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfPeriods: Integer;
begin
  inherited Create(ALayerList, Index);

  ModflowTypes.GetMFStreamSegNumParamType.Create( ParamList, -1);
  ModflowTypes.GetMFStreamHydCondParamType.Create( ParamList, -1);

  if frmMODFLOW.cbStreamDiversions.Checked then
  begin
    ModflowTypes.GetMFStreamDivSegNumParamType.Create( ParamList, -1);
  end;


  NumberOfPeriods := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfPeriods do
  begin
    ModflowTypes.GetMFStreamTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TStreamLayer.ANE_LayerName : string ;
begin
  result := kMFStreamLayer;
end;

{ TStreamUpWidthParam }

class function TStreamUpWidthParam.ANE_ParamName: string;
begin
  result := kMFStreamUpWidthParam;
end;

{ TSreamDownWidthParam }

class function TStreamDownWidthParam.ANE_ParamName: string;
begin
  result := kMFStreamDownWidthParam;
end;

function TStreamDownWidthParam.Units: string;
begin
  result := 'L';
end;

function TStreamDownWidthParam.Value: string;
begin
  result := kNa;
end;

function TStreamUpWidthParam.Units: string;
begin
  result := 'L';
end;

end.

