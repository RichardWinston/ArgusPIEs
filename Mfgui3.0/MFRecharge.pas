unit MFRecharge;

interface

{MFRecharge defines the "Recharge" layer
 and the associated parameters and Parameterlist.}

uses ANE_LayerUnit, SysUtils;

type
  TRechElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

  TRechStressParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TRechargeTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TRechargeLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables, OptionsUnit;

ResourceString
  kMFRechargeLayer = 'Recharge';
  kMFRechargeElevParam = 'Elevation';
  kMFRechargeStressParam = 'Stress';
//  kMFRechargeLayerParam = 'Stress';

class Function TRechElevParam.ANE_ParamName : string ;
begin
  result := kMFRechargeElevParam;
end;

constructor TRechElevParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  if frmMODFLOW.comboRchOpt.ItemIndex <> 1 then
  begin
    Lock := Lock + [plDont_Override];
  end;
end;

function TRechElevParam.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TRechStressParam.ANE_ParamName : string ;
begin
  result := kMFRechargeStressParam;
end;

function TRechStressParam.Units : string;
begin
  result := 'L/T';
end;

//---------------------------
constructor TRechargeTimeParamList.Create(AnOwner :
      T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited Create(AnOwner, Position);
  ModflowTypes.GetMFRechStressParamType.Create( self, -1);

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

end.

