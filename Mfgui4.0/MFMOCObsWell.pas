unit MFMOCObsWell;

interface

{MFMOCObsWell defines the "MOC3D Observation Wells" layer
 and associated parameter and Parameterlist.}

uses ANE_LayerUnit, SysUtils;


type
  TMOCObsElev = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMOC_IsObservation = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TMOCElevParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TMOCObsWellLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    class function WriteNewRoot: string; override;
  end;

implementation

uses ModflowUnit, Variables, OptionsUnit;

ResourceString
  kMFMOCObsWell = 'MOC3D Observation Wells';
  kMFGWTObsWell = 'GWT Observation Wells';
  kMFMOCObsElev = 'Elevation';
  kMFMOC_IsObservation = 'Is Observation';

//---------------------------
class Function TMOCObsElev.ANE_ParamName : string ;
begin
  result := kMFMOCObsElev;
end;

function TMOCObsElev.Units : string;
begin
  result := LengthUnit;
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
  ModflowTypes.GetMFMOC_IsObservationParamType.Create( self, -1);
end;

//---------------------------
constructor TMOCObsWellLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  ObsvWellLayerIndex : integer;
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  Lock := Lock + [llEvalAlg];
  For ObsvWellLayerIndex := 1 to MaxObsWellParameters do
  begin
    ModflowTypes.GetMOCElevParamListType.Create(IndexedParamList1, -1);
  end;
end;

class Function TMOCObsWellLayer.ANE_LayerName : string ;
begin
  result := kMFMOCObsWell;
end;

{ TMOC_IsObservation }

class function TMOC_IsObservation.ANE_ParamName: string;
begin
  result := kMFMOC_IsObservation;
end;

constructor TMOC_IsObservation.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
  Lock := Lock + [plDef_Val, plDont_Override];
end;

function TMOC_IsObservation.Units: string;
begin
  result := 'Calculated';
end;

function TMOC_IsObservation.Value: string;
begin
  result := ModflowTypes.GetMFMOCObsElevParamType.ANE_ParamName + WriteIndex
   + '!=' + kNa;
end;

class function TMOCObsWellLayer.WriteNewRoot: string;
begin
  if frmModflow.rbMODFLOW2000.Checked or frmModflow.rbModflow2005.Checked then
  begin
    result := kMFGWTObsWell;
  end
  else
  begin
    result := inherited WriteNewRoot;
  end;
end;

end.
