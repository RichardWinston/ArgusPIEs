unit MFMOCGrowth;

interface

{MFMOCGrowth defines the "Zero Order Growth Rate Unit[i]" layer
 and associated parameter and Parameterlist.}

uses ANE_LayerUnit, SysUtils;

type
  TMOCGrowthParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMOCGrowthParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TMOCGrowthLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFGrowthUnit = 'Zero Order Growth Rate Unit';
  kMFGrowth = 'Zero Order Growth Rate';

//---------------------------
class Function TMOCGrowthParam.ANE_ParamName : string ;
begin
  result := kMFGrowth;
end;

function TMOCGrowthParam.Units : string;
begin
  result := 'M/L^3T^1';
end;

//---------------------------
constructor TMOCGrowthParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);

  if frmMODFLOW.cbIDPTIM_Growth.Checked then
  begin
    ModflowTypes.GetMFMOCGrowthParamType.Create( self, -1);
  end;

end;

//---------------------------
constructor TMOCGrowthLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

  ModflowTypes.GetMFMOCGrowthParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFMOCGrowthTimeParamListType.Create(IndexedParamList2, -1);
  end;

end;

class Function TMOCGrowthLayer.ANE_LayerName : string ;
begin
  result := kMFGrowthUnit;
end;

function TMOCGrowthLayer.Units: string;
begin
  result := 'M/L^3T^1';
end;

end.
