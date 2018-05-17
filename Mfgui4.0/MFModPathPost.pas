unit MFModPathPost;

interface

{MFModPathPost defines the "MODPATH Pathlines" and "MODPATH Endpoints" layers
 and the associated parameters.}

uses ANE_LayerUnit, SysUtils;

type
  TMODPATH_FirstLayerParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
  end;

  TMODPATH_FirstTimeParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
  end;

  TMODPATH_LastLayerParam = class(TMODPATH_FirstLayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMODPATH_LastTimeParam = class(TMODPATH_FirstTimeParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMODPATH_StartingZoneParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TMODPATH_EndingZoneParam = class(TMODPATH_StartingZoneParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMODPATH_StartingRowParam = class(TMODPATH_StartingZoneParam)
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
  end;

  TMODPATH_StartingColumnParam = class(TMODPATH_StartingZoneParam)
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
  end;

  TMODPATH_StartX = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
  end;

  TMODPATH_StartY = class(TMODPATH_StartX)
    class Function ANE_ParamName : string ; override;
  end;

  TMODPATH_StartZ = class(TMODPATH_StartX)
    class Function ANE_ParamName : string ; override;
  end;

  TMODPATH_EndX = class(TMODPATH_StartX)
    class Function ANE_ParamName : string ; override;
  end;

  TMODPATH_EndY = class(TMODPATH_StartX)
    class Function ANE_ParamName : string ; override;
  end;

  TMODPATH_EndZ = class(TMODPATH_StartX)
    class Function ANE_ParamName : string ; override;
  end;


  TMODPATHPostLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TMODPATHPostEndLayer = Class(TMODPATHPostLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

resourceString
  rsFirstLayer = 'Starting Layer';
  rsFirstRow = 'Starting Row';
  rsFirstColumn = 'Starting Column';
  rsFirstTime = 'Starting Time';
  rsLastLayer = 'Ending Layer';
  rsLastTime = 'Ending Time';
  rsStartZone = 'Starting Zone';
  rsEndZone = 'Ending Zone';
  rsPaths = 'MODPATH Pathlines';
  rsEnd = 'MODPATH Endpoints';
  rsStartX = 'Start X';
  rsStartY = 'Start Y';
  rsStartZ = 'Start Z';
  rsEndX = 'End X';
  rsEndY = 'End Y';
  rsEndZ = 'End Z';

{ TMODPATH_FirstLayerParam }

class function TMODPATH_FirstLayerParam.ANE_ParamName: string;
begin
  result := rsFirstLayer;
end;

constructor TMODPATH_FirstLayerParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
  Lock := [];
end;

function TMODPATH_FirstLayerParam.Units: string;
begin
  result := 'Layer';
end;

{ TMODPATH_FirstTimeParam }

class function TMODPATH_FirstTimeParam.ANE_ParamName: string;
begin
  result := rsFirstTime;
end;

constructor TMODPATH_FirstTimeParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Lock := [];
end;

function TMODPATH_FirstTimeParam.Units: string;
begin
  result := TimeUnit;
end;

{ TMODPATH_LastLayerParam }

class function TMODPATH_LastLayerParam.ANE_ParamName: string;
begin
  result := rsLastLayer;
end;

{
constructor TMODPATH_LastLayerParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
  Lock := [];
end;
}

{
function TMODPATH_LastLayerParam.Units: string;
begin
  result := 'Layer';
end;
}

{ TMODPATH_LastTimeParam }

class function TMODPATH_LastTimeParam.ANE_ParamName: string;
begin
  result := rsLastTime;
end;

{
constructor TMODPATH_LastTimeParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Lock := [];
end;
}

{
function TMODPATH_LastTimeParam.Units: string;
begin
  result := TimeUnit;
end;
}

{ TMODPATHPostLayer }

class function TMODPATHPostLayer.ANE_LayerName: string;
begin
  result := rsPaths
end;

constructor TMODPATHPostLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Lock := [];

  ModflowTypes.GetMFMODPATH_FirstLayerParamType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_FirstTimeParamType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_LastLayerParamType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_LastTimeParamType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_StartingColumnParamType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_StartingRowParamType.Create(ParamList, -1);

end;

{ TMODPATHPostEndLayer }

class function TMODPATHPostEndLayer.ANE_LayerName: string;
begin
  result := rsEnd;
end;

constructor TMODPATHPostEndLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Lock := [];
  ModflowTypes.GetMFMODPATH_StartXParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_StartYParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_StartZParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_EndXParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_EndYParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_EndZParamClassType.Create(ParamList, -1);

  ModflowTypes.GetMFMODPATH_StartingZoneParamType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_EndingZoneParamType.Create(ParamList, -1);
//  ModflowTypes.GetMFMODPATH_StartingColumnParamType.Create(ParamList, -1);
//  ModflowTypes.GetMFMODPATH_StartingRowParamType.Create(ParamList, -1);

end;

{ TMODPATH_StartingZoneParam }

class function TMODPATH_StartingZoneParam.ANE_ParamName: string;
begin
  result := rsStartZone;
end;

constructor TMODPATH_StartingZoneParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Lock := [];
  ValueType := pvInteger;
end;

{ TMODPATH_EndingZoneParam }

class function TMODPATH_EndingZoneParam.ANE_ParamName: string;
begin
  result := rsEndZone;
end;

{ TMODPATH_StartingRowParam }

class function TMODPATH_StartingRowParam.ANE_ParamName: string;
begin
  result := rsFirstRow;
end;

function TMODPATH_StartingRowParam.Units: string;
begin
  result := 'Row';
end;

{ TMODPATH_StartingColumnParam }

class function TMODPATH_StartingColumnParam.ANE_ParamName: string;
begin
  result := rsFirstColumn;
end;

function TMODPATH_StartingColumnParam.Units: string;
begin
  result := 'Column';
end;

{ TMODPATH_StartX }

class function TMODPATH_StartX.ANE_ParamName: string;
begin
  result := rsStartX;
end;

constructor TMODPATH_StartX.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Lock := [];
end;

function TMODPATH_StartX.Units: string;
begin
  result := LengthUnit;
end;

{ TMODPATH_StartY }

class function TMODPATH_StartY.ANE_ParamName: string;
begin
  result := rsStartY;
end;

{ TMODPATH_StartZ }

class function TMODPATH_StartZ.ANE_ParamName: string;
begin
  result := rsStartZ;
end;

{ TMODPATH_EndX }

class function TMODPATH_EndX.ANE_ParamName: string;
begin
  result := rsEndX;
end;

{ TMODPATH_EndY }

class function TMODPATH_EndY.ANE_ParamName: string;
begin
  result := rsEndY;
end;

{ TMODPATH_EndZ }

class function TMODPATH_EndZ.ANE_ParamName: string;
begin
  result := rsEndZ;
end;

end.
