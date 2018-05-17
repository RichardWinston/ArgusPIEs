unit MFMOCObsWell;

interface

{MFMOCObsWell defines the "MOC3D Observation Wells" layer
 and associated parameter and Parameterlist.}

uses ANE_LayerUnit, SysUtils;

const
  MaxObsWellLayers = 5;

type
  TMOCObsElev = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMOCElevParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TMOCObsWellLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses ModflowUnit, Variables;

ResourceString
  kMFMOCObsWell = 'MOC3D Observation Wells';
  kMFMOCObsElev = 'Elevation';

//---------------------------
class Function TMOCObsElev.ANE_ParamName : string ;
begin
  result := kMFMOCObsElev;
end;

function TMOCObsElev.Units : string;
begin
  result := 'L';
end;

function TMOCObsElev.Value : string;
begin
  result := kNA;
end;

//---------------------------
constructor TMOCElevParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited  Create(AnOwner, Position);
  ModflowTypes.GetMFMOCObsElevParamType.Create( self, -1);
end;

//---------------------------
constructor TMOCObsWellLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  ObsvWellLayerIndex : integer;
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  For ObsvWellLayerIndex := 1 to MaxObsWellLayers do
  begin
    ModflowTypes.GetMOCElevParamListType.Create(IndexedParamList1, -1);
  end;
end;

class Function TMOCObsWellLayer.ANE_LayerName : string ;
begin
  result := kMFMOCObsWell;
end;

end.

