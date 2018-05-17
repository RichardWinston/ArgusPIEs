unit SLGeneralParameters;

interface

uses ANE_LayerUnit;


type
  TTimeDependanceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Units: string; override;
  end;

  TElevationParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TBeginElevaParam = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TEndElevaParam = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TZeroTopElevParam = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TTopElevaParam = class(TZeroTopElevParam)
    function Value : string; override;
  end;

  TBeginTopElevaParam = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TEndTopElevaParam = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TBottomElevaParam = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TBeginBottomElevaParam = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TEndBottomElevaParam = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TSourceChoice = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TContourType = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TCustomTotalSourceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TCustomSpecificSourceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TFollowMeshParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TX1Param = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TX2Param = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TX3Param = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TY1Param = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TY2Param = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TY3Param = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TZ1Param = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TZ2Param = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TZ3Param = class(TElevationParam)
    class Function ANE_ParamName : string ; override;
  end;

  TCommentParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TCustomInverseParameter= class(T_ANE_LayerParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Value : string; override;
  end;

implementation

uses SLThickness, OptionsUnit;

ResourceString
  kTotalSource = 'total_source';
  kSpecificSource = 'specific_source';
  kTimeDependence = 'time_dependence';
  kElevation = 'elevation';
  kTop = 'top_elevation';
  kBeginTop = 'beginning_top_elevation';
  kBegin = 'beginning_elevation';
  kEndTop = 'ending_top_elevation';
  kEnd = 'ending_elevation';
  kBottom = 'bottom_elevation';
  kEndBottom = 'ending_bottom_elevation';
  kBeginBottom = 'beginning_bottom_elevation';
//  kUp = 'Upward Extent';
//  kDown = 'Downward Extent';
  kSourceChoice = 'TOTAL OR SPECIFIC SOURCE';
  kContourType = 'CONTOUR TYPE';
  kFollowMesh = 'follow_mesh';
  kX1 = 'X1';
  kX2 = 'X2';
  kX3 = 'X3';
  kY1 = 'Y1';
  kY2 = 'Y2';
  kY3 = 'Y3';
  kZ1 = 'Z1';
  kZ2 = 'Z2';
  kZ3 = 'Z3';
  kComment = 'comment';


{ TSourceChoice }

class function TSourceChoice.ANE_ParamName: string;
begin
  result := kSourceChoice;
end;

constructor TSourceChoice.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Lock := Lock + [plDef_Val, plDont_Override];
  SetValue := True;
  ValueType := pvInteger;
end;

function TSourceChoice.Units: string;
begin
  result := 'calculated';
end;

function TSourceChoice.Value: string;
begin
  result := 'If(IsNumber(' + TCustomTotalSourceParam.WriteParamName
    + '), 1, If(IsNumber(' + TCustomSpecificSourceParam.WriteParamName
    + '), 2, 0))'
end;

{ TTopElevaParam }

function TTopElevaParam.Value: string;
begin
  result := TThicknessLayer.WriteNewRoot + GetParentLayer.WriteIndex + '.'
    + TThicknessParam.WriteParamName
end;

{ TTimeDependanceParam }

class function TTimeDependanceParam.ANE_ParamName: string;
begin
  result := kTimeDependence;
end;

constructor TTimeDependanceParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;

function TTimeDependanceParam.Units: string;
begin
  result := '0 or 1';
end;

{ TBottomElevaParam }

class function TBottomElevaParam.ANE_ParamName: string;
begin
  result := kBottom;
end;

{ TUpwardExtent }
{
class function TUpwardExtent.ANE_ParamName: string;
begin
  result := kUp
end;

constructor TUpwardExtent.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TUpwardExtent.Units: string;
begin
  result :='Num of Node layers';
end;

function TUpwardExtent.Value: string;
begin
  result := '1';
end;

{ TDownwardExtent }
{
class function TDownwardExtent.ANE_ParamName: string;
begin
  result := kDown;
end;
}

{ TContourType }

class function TContourType.ANE_ParamName: string;
begin
  result := kContourType;
end;

constructor TContourType.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Lock := Lock + [plDef_Val, plDont_Override];
  SetValue := True;
  ValueType := pvInteger;
end;

function TContourType.Units: string;
begin
  result := 'calculated';
end;

function TContourType.Value: string;
begin
  result := 'ContourType()';
end;

{ TCustomTotalSourceParam }

class function TCustomTotalSourceParam.ANE_ParamName: string;
begin
  result := kTotalSource;
end;

function TCustomTotalSourceParam.Value: string;
begin
  result := kNa
end;

{ TCustomSpecificSourceParam }

class function TCustomSpecificSourceParam.ANE_ParamName: string;
begin
  result := kSpecificSource
end;

function TCustomSpecificSourceParam.Value: string;
begin
  result := kNa;
end;

{ TX1Param }

class function TX1Param.ANE_ParamName: string;
begin
  result := kX1;
end;

{ TX2Param }

class function TX2Param.ANE_ParamName: string;
begin
  result := kX2;
end;

function TX2Param.Value: string;
begin
  result := '1';
end;

{ TX3Param }

class function TX3Param.ANE_ParamName: string;
begin
  result := kX3;
end;

{ TY1Param }

class function TY1Param.ANE_ParamName: string;
begin
  result := kY1;
end;

{ TY2Param }

class function TY2Param.ANE_ParamName: string;
begin
  result := kY2;
end;

{ TY3Param }

class function TY3Param.ANE_ParamName: string;
begin
  result := kY3;
end;

function TY3Param.Value: string;
begin
  result := '1';
end;

{ TZ1Param }

class function TZ1Param.ANE_ParamName: string;
begin
  result := kZ1;
end;

{ TZ2Param }

class function TZ2Param.ANE_ParamName: string;
begin
  result := kZ2;
end;

{ TZ3Param }

class function TZ3Param.ANE_ParamName: string;
begin
  result := kZ3;
end;

{ TEndTopElevaParam }

class function TEndTopElevaParam.ANE_ParamName: string;
begin
  result := kEndTop;
end;

{ TEndBottomElevaParam }

class function TEndBottomElevaParam.ANE_ParamName: string;
begin
  result := kEndBottom;
end;

{ TFollowMeshParam }

class function TFollowMeshParam.ANE_ParamName: string;
begin
  result := kFollowMesh;
end;

constructor TFollowMeshParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
end;


{ TZeroTopElevParam }

class function TZeroTopElevParam.ANE_ParamName: string;
begin
  result := kTop
end;

{ TCommentParam }

class function TCommentParam.ANE_ParamName: string;
begin
  result := kComment;
end;

constructor TCommentParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

{ TBeginTopElevaParam }

class function TBeginTopElevaParam.ANE_ParamName: string;
begin
  result := kBeginTop;
end;

{ TBeginBottomElevaParam }

class function TBeginBottomElevaParam.ANE_ParamName: string;
begin
  result := kBeginBottom;
end;

{ TElevationParam }

class function TElevationParam.ANE_ParamName: string;
begin
  result := kElevation;
end;

function TElevationParam.Units: string;
begin
  result := 'L';
end;

{ TBeginElevaParam }

class function TBeginElevaParam.ANE_ParamName: string;
begin
  result := kBegin;
end;

{ TEndElevaParam }

class function TEndElevaParam.ANE_ParamName: string;
begin
  result := kEnd;
end;

{ TCustomInverseParameter }

constructor TCustomInverseParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvString;
end;

function TCustomInverseParameter.Value: string;
begin
  result := '""';
end;

end.
