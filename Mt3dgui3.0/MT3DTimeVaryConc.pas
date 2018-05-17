unit MT3DTimeVaryConc;

interface

uses ANE_LayerUnit, SysUtils;

const
  kMT3DTopElev = 'Top Elevation';
  kMT3DBottomElev = 'Bottom Elevation';
  kMT3DPointTimeVaryConc = 'MT3D Point Time Varying Constant Concentration Unit';
  kMT3DAreaTimeVaryConc = 'MT3D Area Time Varying Constant Concentration Unit';

type
  TMT3DTopElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMT3DBottomElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMT3DPointTimeVaryConcTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

  TMT3DAreaTimeVaryConcTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

  TMT3DPointTimeVaryConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

  TMT3DAreaTimeVaryConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses MT3DGeneralParameters, Variables;

class Function TMT3DTopElevParam.ANE_ParamName : string ;
begin
  result := kMT3DTopElev;
end;

function TMT3DTopElevParam.Units : string;
begin
  result := 'L';
end;

function TMT3DTopElevParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TMT3DBottomElevParam.ANE_ParamName : string ;
begin
  result := kMT3DBottomElev;
end;

function TMT3DBottomElevParam.Units : string;
begin
  result := 'L';
end;

function TMT3DBottomElevParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
constructor TMT3DPointTimeVaryConcTimeParamList.Create(AnOwner :
      T_ANE_ListOfIndexedParameterLists; Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ModflowTypes.GetMT3DMassParamClassType.Create(self, -1);
end;

//---------------------------
constructor TMT3DAreaTimeVaryConcTimeParamList.Create(AnOwner :
      T_ANE_ListOfIndexedParameterLists; Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
end;

//---------------------------
constructor TMT3DPointTimeVaryConcLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
var
  TimeIndex : Integer;
begin
  inherited;// Create(Index, ALayerList);
  Lock := Lock + [llType, llEvalAlg];
  Interp := leInterpolate;

  ModflowTypes.GetMT3DTopElevParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMT3DBottomElevParamClassType.Create(ParamList, -1);

  For TimeIndex := 1 to StrToInt(frmMODFLOW.edNumPer.Text) do
  begin
    ModflowTypes.GetMT3DPointTimeVaryConcTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TMT3DPointTimeVaryConcLayer.ANE_LayerName : string ;
begin
  result := kMT3DPointTimeVaryConc;
end;

function TMT3DPointTimeVaryConcLayer.Units : string;
begin
  result := 'M';
end;

//---------------------------
constructor TMT3DAreaTimeVaryConcLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
var
  TimeIndex : Integer;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;

  For TimeIndex := 1 to StrToInt(frmMODFLOW.edNumPer.Text) do
  begin
    ModflowTypes.GetMT3DAreaTimeVaryConcTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TMT3DAreaTimeVaryConcLayer.ANE_LayerName : string ;
begin
  result := kMT3DAreaTimeVaryConc;
end;

function TMT3DAreaTimeVaryConcLayer.Units : string;
begin
  result := 'M/L^3';
end;

end.
