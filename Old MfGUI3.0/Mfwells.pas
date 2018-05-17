unit MFWells;

interface

{MFWells defines the "Wells Unit[i]" layer
 and the associated parameters and Parameterlist.}

uses ANE_LayerUnit, SysUtils;

type
  TWellTopParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TWellBottomParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TWellStressParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TWellTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TWellLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFWells = 'Wells Unit';
  kMFWellTop = 'Top Elevation';
  kMFWellBottom = 'Bottom Elevation';
  kMFWellStress = 'Stress';

class Function TWellTopParam.ANE_ParamName : string ;
begin
  result := kMFWellTop;
end;

function TWellTopParam.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TWellBottomParam.ANE_ParamName : string ;
begin
  result := kMFWellBottom;
end;

function TWellBottomParam.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TWellStressParam.ANE_ParamName : string ;
begin
  result := kMFWellStress;
end;

function TWellStressParam.Units : string;
begin
  result := 'L^3/T';
end;

//---------------------------
constructor TWellTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create(AnOwner, Position);
  ParameterOrder.Add(ModflowTypes.GetMFWellStressParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFConcentrationParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);

  ModflowTypes.GetMFWellStressParamType.Create(self, -1);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFConcentrationParamType.Create( self, -1);
  end;
  if frmMODFLOW.cbMODPATH.Checked then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;
end;

//---------------------------
constructor TWellLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

  ModflowTypes.GetMFWellTopParamType.Create( ParamList, -1);
  ModflowTypes.GetMFWellBottomParamType.Create( ParamList, -1);


  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFWellTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TWellLayer.ANE_LayerName : string ;
begin
  result := kMFWells;
end;

end.

