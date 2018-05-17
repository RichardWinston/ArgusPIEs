unit MFModPathPost;

interface

{MFModPathPost defines the "MODPATH Pathlines" and "MODPATH Endpoints" layers
 and the associated parameters.}

uses ANE_LayerUnit, SysUtils;

type
  TMODPATH_FirstLayerParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
  end;

  TMODPATH_FirstTimeParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
  end;

  TMODPATH_LastLayerParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
  end;

  TMODPATH_LastTimeParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
  end;

  TMODPATH_StartingZoneParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

  TMODPATH_EndingZoneParam = class(TMODPATH_StartingZoneParam)
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
  rsFirstTime = 'Starting Time';
  rsLastLayer = 'Ending Layer';
  rsLastTime = 'Ending Time';
  rsStartZone = 'Starting Zone';
  rsEndZone = 'Ending Zone';
  rsPaths = 'MODPATH Pathlines';
  rsEnd = 'MODPATH Endpoints';

{ TMODPATH_FirstLayerParam }

class function TMODPATH_FirstLayerParam.ANE_ParamName: string;
begin
  result := rsFirstLayer;
end;

constructor TMODPATH_FirstLayerParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
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
  result := 't';
end;

{ TMODPATH_LastLayerParam }

class function TMODPATH_LastLayerParam.ANE_ParamName: string;
begin
  result := rsLastLayer;
end;

constructor TMODPATH_LastLayerParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Lock := [];
end;

function TMODPATH_LastLayerParam.Units: string;
begin
  result := 'Layer';
end;

{ TMODPATH_LastTimeParam }

class function TMODPATH_LastTimeParam.ANE_ParamName: string;
begin
  result := rsLastTime;
end;

constructor TMODPATH_LastTimeParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Lock := [];
end;

function TMODPATH_LastTimeParam.Units: string;
begin
  result := 't';
end;

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
  ModflowTypes.GetMFMODPATH_StartingZoneParamType.Create(ParamList, -1);
  ModflowTypes.GetMFMODPATH_EndingZoneParamType.Create(ParamList, -1);

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

end.
