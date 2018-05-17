unit MFMOCDisDecay;

interface

{MFMOCDisDecay defines the "Decay Coef Unit Unit[i]" layer
 and associated parameter and Parameterlist.}

uses ANE_LayerUnit, SysUtils;

type
  TMOCDisDecayCoefParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMOCDisDecayCoefParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TMOCDisDecayCoefLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFDisDecayCoefUnit = 'Decay Coef Unit';
  kMFDisDecayCoef = 'Decay Coef';

//---------------------------
class Function TMOCDisDecayCoefParam.ANE_ParamName : string ;
begin
  result := kMFDisDecayCoef;
end;

function TMOCDisDecayCoefParam.Units : string;
begin
  result := '1/T';
end;

//---------------------------
constructor TMOCDisDecayCoefParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);

  if frmMODFLOW.cbIDKTIM_DisDecay.Checked then
  begin
    ModflowTypes.GetMFMOCDisDecayCoefParamType.Create( self, -1);
  end;

end;

//---------------------------
constructor TMOCDisDecayCoefLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

  ModflowTypes.GetMFMOCDisDecayCoefParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFMOCDisDecayCoefTimeParamListType.Create(IndexedParamList2, -1);
  end;

end;

class Function TMOCDisDecayCoefLayer.ANE_LayerName : string ;
begin
  result := kMFDisDecayCoefUnit;
end;

end.
