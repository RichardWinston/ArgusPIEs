unit MFRecharge;

interface

{MFRecharge defines the "Recharge" layer
 and the associated parameters and Parameterlist.}

uses ANE_LayerUnit, SysUtils, MFGenParam, OptionsUnit;

type
  TRechElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function EvaluateLock: TParamLock; override;
  end;

  TRechStressParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TRechargeTimeParamList = class(TSteadyTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
      Position: Integer);  override;
    function IsSteadyStress : boolean; override;
  end;

  TRechargeLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
      Index: Integer = -1); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFRechargeLayer = 'Recharge';
  kMFRechargeElevParam = 'Elevation';
  kMFRechargeStressParam = 'Stress';
//  kMFRechargeLayerParam = 'Stress';

class Function TRechElevParam.ANE_ParamName : string ;
begin
  result := kMFRechargeElevParam;
end;

function TRechElevParam.EvaluateLock: TParamLock;
begin
  result := inherited EvaluateLock;
  with frmModflow do
  begin
    if (comboRchOpt.ItemIndex <> 1) or cbRechLayer.Checked then
    begin
      result := result + [plDef_Val, plDont_Override, plDontEvalColor]
    end
    else
    begin
      result := result - [plDef_Val, plDont_Override, plDontEvalColor]
    end;
  end;
end;

function TRechElevParam.Units : string;
begin
  result := LengthUnit;
end;

//---------------------------
class Function TRechStressParam.ANE_ParamName : string ;
begin
  result := kMFRechargeStressParam;
end;


function TRechStressParam.Units : string;
begin
  result := LengthUnit + '/' +TimeUnit ;
end;

//---------------------------
constructor TRechargeTimeParamList.Create(AnOwner :
      T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  AParam : T_ANE_Param;
begin
  inherited Create(AnOwner, Position);
  ParameterOrder.Add(ModflowTypes.GetMFRechStressParamType.ANE_ParamName);

  AParam := ModflowTypes.GetMFRechStressParamType.Create( self, -1);
  if (Index > 1) and (frmModflow.comboRchSteady.ItemIndex = 0) then
  begin
    AParam.Lock := AParam.Lock + [plDont_Override]
  end;
end;

//---------------------------
constructor TRechargeLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  ModflowTypes.GetMFRechElevParamType.Create( ParamList, -1);

  if frmMODFLOW.cbRechLayer.Checked and (frmMODFLOW.comboRchOpt.ItemIndex = 1) then
  begin
    ModflowTypes.GetMFModflowLayerParamType.Create( ParamList, -1);
  end;

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFRechElevParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TRechargeLayer.ANE_LayerName : string ;
begin
  result := kMFRechargeLayer;
end;

function TRechargeTimeParamList.IsSteadyStress: boolean;
begin
  result := (frmModflow.comboRchSteady.ItemIndex = 0);
end;

end.
