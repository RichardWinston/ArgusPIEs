unit MFMOCLinExch;

interface

{MFMOCLinExch defines the "Lin Exch Coef Unit[i]" layer
 and associated parameter and Parameterlist.}

uses ANE_LayerUnit, SysUtils;

type
  TMOCLinExchCoefParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMOCLinExchCoefParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TMOCLinExchCoefLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFLinExchCoefUnit = 'Immob Exch Coef Unit';
  kMFLinExchCoef = 'Immob Exch Coef';

//---------------------------
class Function TMOCLinExchCoefParam.ANE_ParamName : string ;
begin
  result := kMFLinExchCoef;
end;

function TMOCLinExchCoefParam.Units : string;
begin
  result := '1/T';
end;

//---------------------------
constructor TMOCLinExchCoefParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);

  if frmMODFLOW.cbIDPTIM_LinExch.Checked then
  begin
    ModflowTypes.GetMFMOCLinExchCoefParamType.Create( self, -1);
  end;

end;

//---------------------------
constructor TMOCLinExchCoefLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

  if not frmMODFLOW.cbIDPTIM_LinExch.Checked then
  begin
    ModflowTypes.GetMFMOCLinExchCoefParamType.Create( ParamList, -1);
  end;

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFMOCLinExchCoefTimeParamListType.Create(IndexedParamList2, -1);
  end;

end;

class Function TMOCLinExchCoefLayer.ANE_LayerName : string ;
begin
  result := kMFLinExchCoefUnit;
end;


function TMOCLinExchCoefLayer.Units: string;
begin
  result := '1/T';
end;

end.
 