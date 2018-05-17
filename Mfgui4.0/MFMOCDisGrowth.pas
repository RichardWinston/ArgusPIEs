unit MFMOCDisGrowth;

interface

{MFMOCDisGrowth defines the "Growth Rate Unit[i]" layer
 and associated parameter and Parameterlist.}

uses ANE_LayerUnit, SysUtils, MFGenParam;

type
  TMOCDisGrowthParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMOCDisGrowthParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TMOCDisGrowthLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

ResourceString
  kMFDisGrowthUnit = 'Growth Rate Unit';
  kMFDisGrowth = 'Growth Rate';

//---------------------------
class Function TMOCDisGrowthParam.ANE_ParamName : string ;
begin
  result := kMFDisGrowth;
end;

function TMOCDisGrowthParam.Units : string;
begin
  result := 'M/' + LengthUnit + '^3' +TimeUnit ;
end;

//---------------------------
constructor TMOCDisGrowthParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);

  if frmMODFLOW.cbIDKTIM_DisGrowth.Checked then
  begin
    ModflowTypes.GetMFMOCDisGrowthParamType.Create( self, -1);
  end;

end;

//---------------------------
constructor TMOCDisGrowthLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

  ModflowTypes.GetMFMOCDisGrowthParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFMOCDisGrowthTimeParamListType.Create(IndexedParamList2, -1);
  end;

end;

class Function TMOCDisGrowthLayer.ANE_LayerName : string ;
begin
  result := kMFDisGrowthUnit;
end;

function TMOCDisGrowthLayer.Units: string;
begin
  result := 'M/' + LengthUnit + '^3' +TimeUnit ;
end;

end.
