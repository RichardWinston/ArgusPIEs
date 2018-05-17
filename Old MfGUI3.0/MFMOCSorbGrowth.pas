unit MFMOCSorbGrowth;

interface

{MFMOCSorbGrowth defines the "Sorbed Zero Order Growth Rate Unit[i]" layer
 and the associated parameter and Parameterlist.}

uses ANE_LayerUnit, SysUtils;

type
  TMOCSorbGrowthParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMOCSorbGrowthParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TMOCSorbGrowthLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFSorbGrowthUnit = 'Sorbed Zero Order Growth Rate Unit';
  kMFSorbGrowth = 'Sorbed Zero Order Growth Rate';

//---------------------------
class Function TMOCSorbGrowthParam.ANE_ParamName : string ;
begin
  result := kMFSorbGrowth;
end;

function TMOCSorbGrowthParam.Units : string;
begin
  result := 'M/L^3T^1';
end;

//---------------------------
constructor TMOCSorbGrowthParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);

  if frmMODFLOW.cbIDKTIM_SorbGrowth.Checked then
  begin
    ModflowTypes.GetMFMOCSorbGrowthParamType.Create( self, -1);
  end;

end;

//---------------------------
constructor TMOCSorbGrowthLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

  ModflowTypes.GetMFMOCSorbGrowthParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFMOCSorbGrowthTimeParamListType.Create(IndexedParamList2, -1);
  end;

end;

class Function TMOCSorbGrowthLayer.ANE_LayerName : string ;
begin
  result := kMFSorbGrowthUnit;
end;

function TMOCSorbGrowthLayer.Units: string;
begin
  result := 'M/L^3T^1';
end;

end.
