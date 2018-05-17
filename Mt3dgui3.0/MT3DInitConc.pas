unit MT3DInitConc;

interface

uses ANE_LayerUnit, SysUtils;

const
  kInitParam = 'Initial Concentration';
  kMT3DTopElev = 'Top Elevation';
  kMT3DBottomElev = 'Bottom Elevation';
  kMT3DPointInitConc = 'MT3D Point Initial Concentration Unit';
  kMT3DAreaInitConc = 'MT3D Area Initial Concentration Unit';

type
  TMT3DInitConcParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;


{  TMT3DPointTimeVaryConcTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create(Index: Integer; AnOwner :
      T_ANE_ListOfIndexedParameterLists); override;
  end;

  TMT3DAreaTimeVaryConcTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create(Index: Integer; AnOwner :
      T_ANE_ListOfIndexedParameterLists); override;
  end;
}
  TMT3DPointInitConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

  TMT3DAreaInitConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses MT3DGeneralParameters, Variables;

{class Function TMT3DTopElevParam.ANE_Name : string ;
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
class Function TMT3DBottomElevParam.ANE_Name : string ;
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
//---------------------------   }

class Function TMT3DInitConcParam.ANE_ParamName : string ;
begin
  result := kInitParam;
end;

function TMT3DInitConcParam.Units : string;
begin
  result := 'M/L^3';
end;


//---------------------------
{constructor TMT3DPointTimeVaryConcTimeParamList.Create(Index: Integer; AnOwner :
      T_ANE_ListOfIndexedParameterLists);
begin
  inherited Create(Index, AnOwner);
  ModflowTypes.GetMT3DMassParamClassType.Create(-1, self);
end;

//---------------------------
constructor TMT3DAreaTimeVaryConcTimeParamList.Create(Index: Integer; AnOwner :
      T_ANE_ListOfIndexedParameterLists);
begin
  inherited Create(Index, AnOwner);
  ModflowTypes.GetMT3DConcentrationParamClassType.Create(-1, self);
end;

//---------------------------   }
constructor TMT3DPointInitConcLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
begin
  inherited;// Create(Index, ALayerList);
  Lock := Lock + [llType, llEvalAlg];
  Interp := leInterpolate;

  ModflowTypes.GetMT3DMassParamClassType.Create(ParamList, -1);
end;

class Function TMT3DPointInitConcLayer.ANE_LayerName : string ;
begin
  result := kMT3DPointInitConc;
end;

function TMT3DPointInitConcLayer.Units : string;
begin
  result := 'M';
end;

//---------------------------
constructor TMT3DAreaInitConcLayer.Create(ALayerList : T_ANE_LayerList; Index: Integer) ;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;

  ModflowTypes.GetMT3DInitConcParamClassType.Create(ParamList, -1);
end;

class Function TMT3DAreaInitConcLayer.ANE_LayerName : string ;
begin
  result := kMT3DAreaInitConc;
end;

function TMT3DAreaInitConcLayer.Units : string;
begin
  result := 'M/L^3';
end;

end.
