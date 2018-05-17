unit MFMOCDecay;

interface

{MFMOCDecay defines the "First Order Decay Coef Unit[i]" layer
 and associated parameter and Parameterlist.}

uses ANE_LayerUnit, SysUtils;

type
  TMOCDecayCoefParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMOCDecayCoefParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TMOCDecayCoefLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFDecayCoefUnit = 'Immob Decay Coef Unit';
  kMFDecayCoef = 'Immob Decay Coef';

//---------------------------
class Function TMOCDecayCoefParam.ANE_ParamName : string ;
begin
  result := kMFDecayCoef;
end;

function TMOCDecayCoefParam.Units : string;
begin
  result := '1/T';
end;

//---------------------------
constructor TMOCDecayCoefParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);

  if frmMODFLOW.cbIDPTIM_Decay.Checked then
  begin
    ModflowTypes.GetMFMOCDecayCoefParamType.Create( self, -1);
  end;

end;

//---------------------------
constructor TMOCDecayCoefLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

  ModflowTypes.GetMFMOCDecayCoefParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFMOCDecayCoefTimeParamListType.Create(IndexedParamList2, -1);
  end;

end;

class Function TMOCDecayCoefLayer.ANE_LayerName : string ;
begin
  result := kMFDecayCoefUnit;
end;

function TMOCDecayCoefLayer.Units: string;
begin
  result := '1/T';
end;

end.
