unit MFMODPATHUnit;

interface

{MFMODPATHUnit defines the "MODPATH Particles Unit[i]" layer
 and the associated parameters and Parameterlist.}

uses ANE_LayerUnit, SysUtils, MFGenParam;

type
  TMODPATH_XCount_Param = class(TCustomUnitParameter)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMODPATH_YCount_Param = class(TMODPATH_XCount_Param)
    class Function ANE_ParamName : string ; override;
  end;

  TMODPATH_ZCount_Param = class(TMODPATH_XCount_Param)
    class Function ANE_ParamName : string ; override;
  end;

  TMODPATH_ReleaseTimeParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMODPATHPartIface = class(TIFACEParam)
    function Value : string; override;
  end;

  TUpperMpathElevation = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLowerMpathElevation = class(TUpperMpathElevation)
    class Function ANE_ParamName : string ; override;
  end;

  TMODPATHTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TMODPATHLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;


implementation

uses Variables;

resourcestring
  kMODPATHXCount = 'X Particle Count';
  kMODPATHYCount = 'Y Particle Count';
  kMODPATHZCount = 'Z Particle Count';
  kMODPATHReleaseTime = 'Release Time';
  kMODPATHLayer = 'MODPATH Particles Unit';
  kMpathUpperElevation = 'Upper Elevation';
  kMpathLowerElevation = 'Lower Elevation';

constructor TMODPATH_XCount_Param.Create(AParameterList : T_ANE_ParameterList;
       Index : Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TMODPATH_XCount_Param.ANE_ParamName : string ;
begin
  result := kMODPATHXCount;
end;

function TMODPATH_XCount_Param.Units : string;
begin
  result := '>= 1';
end;

//-----------------------------------
class Function TMODPATH_YCount_Param.ANE_ParamName : string ;
begin
  result := kMODPATHYCount;
end;

//-----------------------------------
class Function TMODPATH_ZCount_Param.ANE_ParamName : string ;
begin
  result := kMODPATHZCount;
end;

//-----------------------------------
class Function TMODPATH_ReleaseTimeParam.ANE_ParamName : string ;
begin
  result := kMODPATHReleaseTime;
end;

function TMODPATH_ReleaseTimeParam.Units : string;
begin
  result := TimeUnit;
end;

function TMODPATH_ReleaseTimeParam.Value: string;
begin
  if self.WriteIndex = '1' then
  begin
    result := '0'
  end
  else
  begin
    result := kNa;
  end;
end;

//-----------------------------------
{ TMODPATHPartIface }

function TMODPATHPartIface.Value: string;
begin
  result := '-1';
end;

//-----------------------------------
constructor TMODPATHTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);

  ModflowTypes.GetMFMODPATH_ReleaseTimeParamType.Create( self, -1);
end;

//-----------------------------------

constructor TMODPATHLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfReleaseTimes: Integer;
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;

  ModflowTypes.GetMFMODPATHPartIfaceParamType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_XCountParamType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_YCountParamType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_ZCountParamType.Create(ParamList, -1);

  if frmModflow.cbMpathElevations.Checked then
  begin
    ModflowTypes.GetMFUpperMpathElevationParamType.Create(ParamList, -1);
    ModflowTypes.GetMFLowerMpathElevationParamType.Create(ParamList, -1);
  end;

  NumberOfReleaseTimes := StrToInt(frmMODFLOW.adeMODPATHMaxReleaseTime.Text);
  For TimeIndex := 1 to NumberOfReleaseTimes do
  begin
    ModflowTypes.GetMFMODPATHTimeParamListType.Create(IndexedParamList1, -1);
  end;
end;

class Function TMODPATHLayer.ANE_LayerName : string ;
begin
  result := kMODPATHLayer;
end;

function TMODPATH_XCount_Param.Value: string;
begin
  result := '1';
end;

{ TUpperMpathElevation }

class function TUpperMpathElevation.ANE_ParamName: string;
begin
  result := kMpathUpperElevation
end;

function TUpperMpathElevation.Units: string;
begin
  result := LengthUnit;
end;

{ TLowerMpathElevation }

class function TLowerMpathElevation.ANE_ParamName: string;
begin
  result := kMpathLowerElevation
end;

end.
