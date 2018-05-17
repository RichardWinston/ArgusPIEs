unit SLSpecifiedPressure;

interface

uses ANE_LayerUnit, AnePIE, SLCustomLayers, SLGeneralParameters;

type
  TSpecPressureParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
    function WriteName: string; override;
    class function WriteParamName: string; override;
  end;

  TConcOrTempParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
    function WriteName: string; override;
    class function WriteParamName: string; override;
  end;

  TInvSpecPresParam = class(TCustomInverseParameter)
    class function ANE_ParamName: string; override;
    function WriteName: string; override;
    class function WriteParamName: string; override;
  end;

//  TInvSpecPresFunctionParam = class(TCustomInverseParameter)
//    class function ANE_ParamName: string; override;
//    function WriteName: string; override;
//    class function WriteParamName: string; override;
//  end;

  TInvSpecPresEnergyConcParam = class(TCustomInverseParameter)
    class function ANE_ParamName: string; override;
    function WriteName: string; override;
    class function WriteParamName: string; override;
  end;

//  TInvSpecPresEnergyConcFunctionParam = class(TCustomInverseParameter)
//    class function ANE_ParamName: string; override;
//    function WriteName: string; override;
//    class function WriteParamName: string; override;
//  end;

  TCustomSpecifiedPressureLayer = class(TSutraInfoLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  T2DSpecifiedPressureLayer = class(TCustomSpecifiedPressureLayer)
    class function ANE_LayerName: string; override;
    class function WriteNewRoot: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TBottomSpecifiedPressureLayer = class(T2DSpecifiedPressureLayer)
    class function ANE_LayerName: string; override;
    class function WriteNewRoot: string; override;
    class function WriteSuffix: string; virtual;
  end;

  TTopSpecifiedPressureLayer = class(T2DSpecifiedPressureLayer)
    class function WriteSuffix: string; virtual;
    class function WriteNewRoot: string; override;
  end;

  TCustom3DSpecifiedPressureLayer = class(TCustomSpecifiedPressureLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    function WriteIndex: string; override;
    function WriteOldIndex: string; override;
  end;

  TPoint3DSpecifiedPressureLayer = class(TCustom3DSpecifiedPressureLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

  TSlantedSheet3DSpecifiedPressureLayer = class(TCustom3DSpecifiedPressureLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

  TFollowMesh3DSpecifiedPressureLayer = class(TCustom3DSpecifiedPressureLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TLine3DSpecifiedPressureLayer = class(TFollowMesh3DSpecifiedPressureLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

  TVerticalSheet3DSpecifiedPressureLayer =
    class(TFollowMesh3DSpecifiedPressureLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

  TVolSpecifiedPressureLayer = class(TFollowMesh3DSpecifiedPressureLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers;

resourcestring
  kSpecPresParam = 'specified_pressure';
  kConcTemp = 'conc_or_temp';
  KSpecPresLayer = 'Specified Pressure';
  KSpecPresLayerSurface = 'Specified Pressure surfaces';
  KPointsSpecPresLayer = 'Specified Pressure Points';
  KLinesSpecPresLayer = 'Specified Pressure Lines';
  KVerticalSheetsSpecPresLayer = 'Specified Pressure Sheets Vertical';
  KSlantedSheetsSpecPresLayer = 'Specified Pressure Sheets Slanted';
  KSolidsSpecPresLayer = 'Specified Pressure Solids';
  kInvSpecPressure = 'UString_SpPress';
  kInvSpecConcEnergy = '.UString_conc_or_temp';
//  kInvSpecPressureFunction = 'UFunction_SpPress';
//  kInvSpecConcEnergyFunction = '.UFunction_conc_or_temp';

  { TSpecPressureParam }

class function TSpecPressureParam.ANE_ParamName: string;
begin
  result := kSpecPresParam;
end;

function TSpecPressureParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := 'M/(L s^2)';
      end;
    svHead:
      begin
        result := 'L';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

function TSpecPressureParam.Value: string;
begin
  result := kNa;
end;

function TSpecPressureParam.WriteName: string;
begin
  result := WriteParamName;
end;

class function TSpecPressureParam.WriteParamName: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := ANE_ParamName;
      end;
    svHead:
      begin
        result := 'specified_hydraulic_head';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

{ TConcOrTempParam }

class function TConcOrTempParam.ANE_ParamName: string;
begin
  result := kConcTemp;
end;

function TConcOrTempParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := 'C or degC'
      end;
    ttEnergy:
      begin
        result := 'degC';
      end;
    ttSolute:
      begin
        result := 'C';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

function TConcOrTempParam.Value: string;
begin
  result := kNa;
end;

function TConcOrTempParam.WriteName: string;
begin
  result := WriteParamName;
end;

class function TConcOrTempParam.WriteParamName: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_ParamName;
      end;
    ttEnergy:
      begin
        result := 'temperature';
      end;
    ttSolute:
      begin
        result := 'concentration';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TVolSpecifiedPressureLayer }

class function TVolSpecifiedPressureLayer.ANE_LayerName: string;
begin
  result := KSolidsSpecPresLayer;
end;

constructor TVolSpecifiedPressureLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  Position: integer;
begin
  inherited;
  {  if frmSutra.Is3D then
    begin
      TZeroTopElevParam.Create(ParamList, -1);
      TBottomElevaParam.Create(ParamList, -1);
    end;
    ParamList.ParameterOrder.Insert(0, TFollowMeshParam.ANE_ParamName);
    TFollowMeshParam.Create(ParamList, -1); }
  Position := ParamList.ParameterOrder.IndexOf(
    TTimeDependanceParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TZeroTopElevParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 1,
    TBottomElevaParam.ANE_ParamName);

  TZeroTopElevParam.Create(ParamList, -1);
  TBottomElevaParam.Create(ParamList, -1);
end;

class function TVolSpecifiedPressureLayer.WriteNewRoot: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := ANE_LayerName;
      end;
    svHead:
      begin
        result := 'Specified Hydraulic Head Solids';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TSpecifiedPressureSurfaceLayer }

{
class function TSpecifiedPressureSurfaceLayer.ANE_LayerName: string;
begin
  result := KSpecPresLayerSurface;
end;

constructor TSpecifiedPressureSurfaceLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  ParamIndex : integer;
begin
  inherited;
  if frmSutra.Is3D then
  begin
    TZeroTopElevParam.Create(ParamList, -1);
    TBottomElevaParam.Create(ParamList, -1);
  end;

  ParamList.ParameterOrder.Insert(0, TFollowMeshParam.ANE_ParamName);

  ParamIndex := ParamList.ParameterOrder.IndexOf(TTopElevaParam.ANE_ParamName) +1;
  ParamList.ParameterOrder.Insert(ParamIndex, TEndTopElevaParam.ANE_ParamName);
  ParamIndex := ParamList.ParameterOrder.IndexOf(TBottomElevaParam.ANE_ParamName) +1;
  ParamList.ParameterOrder.Insert(ParamIndex, TEndBottomElevaParam.ANE_ParamName);

  ParamIndex := ParamList.ParameterOrder.IndexOf(TEndBottomElevaParam.ANE_ParamName) +1;
  ParamList.ParameterOrder.Insert(ParamIndex, TX1Param.ANE_ParamName);
  Inc(ParamIndex);
  ParamList.ParameterOrder.Insert(ParamIndex, TY1Param.ANE_ParamName);
  Inc(ParamIndex);
  ParamList.ParameterOrder.Insert(ParamIndex, TZ1Param.ANE_ParamName);
  Inc(ParamIndex);
  ParamList.ParameterOrder.Insert(ParamIndex, TX2Param.ANE_ParamName);
  Inc(ParamIndex);
  ParamList.ParameterOrder.Insert(ParamIndex, TY2Param.ANE_ParamName);
  Inc(ParamIndex);
  ParamList.ParameterOrder.Insert(ParamIndex, TZ2Param.ANE_ParamName);
  Inc(ParamIndex);
  ParamList.ParameterOrder.Insert(ParamIndex, TX3Param.ANE_ParamName);
  Inc(ParamIndex);
  ParamList.ParameterOrder.Insert(ParamIndex, TY3Param.ANE_ParamName);
  Inc(ParamIndex);
  ParamList.ParameterOrder.Insert(ParamIndex, TZ3Param.ANE_ParamName);

  TFollowMeshParam.Create(ParamList, -1);

  TEndTopElevaParam.Create(ParamList, -1);
  TEndBottomElevaParam.Create(ParamList, -1);

  TX1Param.Create(ParamList, -1);
  TY1Param.Create(ParamList, -1);
  TZ1Param.Create(ParamList, -1);
  TX2Param.Create(ParamList, -1);
  TY2Param.Create(ParamList, -1);
  TZ2Param.Create(ParamList, -1);
  TX3Param.Create(ParamList, -1);
  TY3Param.Create(ParamList, -1);
  TZ3Param.Create(ParamList, -1);
end;

class function TSpecifiedPressureSurfaceLayer.WriteNewRoot: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := ANE_LayerName;
      end;
    svHead:
      begin
        result := 'Specified Hydraulic Head surfaces';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end; }

{ T2DSpecifiedPressureLayer }

class function T2DSpecifiedPressureLayer.ANE_LayerName: string;
begin
  result := KSpecPresLayer;
end;

class function TBottomSpecifiedPressureLayer.ANE_LayerName: string;
begin
  result := KSpecPresLayer + WriteSuffix;
end;

{constructor TBottomSpecifiedPressureLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  PosIndex : integer;
begin
  inherited;
  PosIndex := ParamList.ParameterOrder.IndexOf(TTimeDependanceParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(PosIndex + 1, TTopElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(PosIndex + 2, TBottomElevaParam.ANE_ParamName);
  if frmSutra.Is3D then
  begin
    TTopElevaParam.Create(ParamList, -1);
    TBottomElevaParam.Create(ParamList, -1);
  end;

end;  }

class function TBottomSpecifiedPressureLayer.WriteNewRoot: string;
begin
  if frmSutra = nil then
  begin
    result := 'Specified Hydraulic Head' + WriteSuffix;
  end
  else
  begin
    result := inherited WriteNewRoot;
    if Pos(WriteSuffix, result) < 1 then
    begin
      result := result + WriteSuffix
    end;
  end;
  if (frmSutra = nil) or frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;

end;

{ TCustomSpecifiedPressureLayer }

{class function TCustomSpecifiedPressureLayer.ANE_LayerName: string;
begin
  result := KSpecPresLayer;
end; }

constructor TCustomSpecifiedPressureLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
{var
  ListOfLayerLists : T_ANE_ListOfIndexedLayerLists;}
begin
  inherited;
  RenameAllParameters := True;
  Interp := leExact;

  ParamList.ParameterOrder.Add(TSpecPressureParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TConcOrTempParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDependanceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvSpecPresParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvSpecPresFunctionParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvSpecPresEnergyConcParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvSpecPresEnergyConcFunctionParam.ANE_ParamName);

  TSpecPressureParam.Create(ParamList, -1);
  TConcOrTempParam.Create(ParamList, -1);
  TTimeDependanceParam.Create(ParamList, -1);

  if frmSutra.cbInverse.Checked
    or frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TInvSpecPresParam.Create(ParamList, -1);
//    TInvSpecPresFunctionParam.Create(ParamList, -1);
    TInvSpecPresEnergyConcParam.Create(ParamList, -1);
//    TInvSpecPresEnergyConcFunctionParam.Create(ParamList, -1);
  end;
end;

constructor T2DSpecifiedPressureLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Add(TCommentParam.ANE_ParamName);

  TCommentParam.Create(ParamList, -1);
end;

class function T2DSpecifiedPressureLayer.WriteNewRoot: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := ANE_LayerName;
      end;
    svHead:
      begin
        result := 'Specified Hydraulic Head';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

{ TCustom3DSpecifiedPressureLayer }

constructor TCustom3DSpecifiedPressureLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
{var
  Position : integer; }
begin
  inherited;
  //  Position := ParamList.ParameterOrder.IndexOf(
  //    TCommentParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TContourType.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCommentParam.ANE_ParamName);

  TContourType.Create(ParamList, -1);
  TCommentParam.Create(ParamList, -1);
end;

function TCustom3DSpecifiedPressureLayer.WriteIndex: string;
begin
  if LayerList is T_TypedIndexedLayerList then
  begin
    result := T_TypedIndexedLayerList(LayerList).LayerIndex(self);
  end
  else
  begin
    result := inherited WriteIndex;
  end;
end;

function TCustom3DSpecifiedPressureLayer.WriteOldIndex: string;
begin
  result := WriteIndex;
end;

{ TPoint3DSpecifiedPressureLayer }

class function TPoint3DSpecifiedPressureLayer.ANE_LayerName: string;
begin
  result := KPointsSpecPresLayer;
end;

constructor TPoint3DSpecifiedPressureLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TTimeDependanceParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position, TElevationParam.ANE_ParamName);
  TElevationParam.Create(ParamList, -1);
end;

class function TPoint3DSpecifiedPressureLayer.WriteNewRoot: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := ANE_LayerName;
      end;
    svHead:
      begin
        result := 'Specified Hydraulic Head Points';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

{ TLine3DSpecifiedPressureLayer }

class function TLine3DSpecifiedPressureLayer.ANE_LayerName: string;
begin
  result := KLinesSpecPresLayer;
end;

constructor TLine3DSpecifiedPressureLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TTimeDependanceParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TBeginElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 1,
    TEndElevaParam.ANE_ParamName);

  TBeginElevaParam.Create(ParamList, -1);
  TEndElevaParam.Create(ParamList, -1);
end;

class function TLine3DSpecifiedPressureLayer.WriteNewRoot: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := ANE_LayerName;
      end;
    svHead:
      begin
        result := 'Specified Hydraulic Head Lines';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TVerticalSheet3DSpecifiedPressureLayer }

class function TVerticalSheet3DSpecifiedPressureLayer.ANE_LayerName: string;
begin
  result := KVerticalSheetsSpecPresLayer;
end;

constructor TVerticalSheet3DSpecifiedPressureLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TTimeDependanceParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TBeginTopElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 1,
    TEndTopElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 2,
    TBeginBottomElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 3,
    TEndBottomElevaParam.ANE_ParamName);

  TBeginTopElevaParam.Create(ParamList, -1);
  TEndTopElevaParam.Create(ParamList, -1);
  TBeginBottomElevaParam.Create(ParamList, -1);
  TEndBottomElevaParam.Create(ParamList, -1);
end;

class function TVerticalSheet3DSpecifiedPressureLayer.WriteNewRoot: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := ANE_LayerName;
      end;
    svHead:
      begin
        result := 'Specified Hydraulic Head Sheets Vertical';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TSlantedSheet3DSpecifiedPressureLayer }

class function TSlantedSheet3DSpecifiedPressureLayer.ANE_LayerName: string;
begin
  result := KSlantedSheetsSpecPresLayer
end;

constructor TSlantedSheet3DSpecifiedPressureLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TTimeDependanceParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TX1Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 1,
    TY1Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 2,
    TZ1Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 3,
    TX2Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 4,
    TY2Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 5,
    TZ2Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 6,
    TX3Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 7,
    TY3Param.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 8,
    TZ3Param.ANE_ParamName);

  TX1Param.Create(ParamList, -1);
  TY1Param.Create(ParamList, -1);
  TZ1Param.Create(ParamList, -1);
  TX2Param.Create(ParamList, -1);
  TY2Param.Create(ParamList, -1);
  TZ2Param.Create(ParamList, -1);
  TX3Param.Create(ParamList, -1);
  TY3Param.Create(ParamList, -1);
  TZ3Param.Create(ParamList, -1);
end;

class function TSlantedSheet3DSpecifiedPressureLayer.WriteNewRoot: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := ANE_LayerName;
      end;
    svHead:
      begin
        result := 'Specified Hydraulic Head Sheets Slanted';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TCustomNonPoint3DSpecifiedPressureLayer }

{ TFollowMesh3DSpecifiedPressureLayer }

constructor TFollowMesh3DSpecifiedPressureLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Insert(0, TFollowMeshParam.ANE_ParamName);
  TFollowMeshParam.Create(ParamList, -1);
end;

class function TBottomSpecifiedPressureLayer.WriteSuffix: string;
begin
  result := ' Bottom';
end;

{ TTopSpecifiedPressureLayer }

class function TTopSpecifiedPressureLayer.WriteNewRoot: string;
begin
  if frmSutra = nil then
  begin
    result := 'Specified Hydraulic Head' + WriteSuffix;
  end
  else
  begin
    result := inherited WriteNewRoot;
    if Pos(WriteSuffix, result) < 1 then
    begin
      result := result + WriteSuffix
    end;
  end;
end;

class function TTopSpecifiedPressureLayer.WriteSuffix: string;
begin
  result := ' Top';
end;

{ TInvSpecPresParam }

class function TInvSpecPresParam.ANE_ParamName: string;
begin
  result := kInvSpecPressure;
end;

function TInvSpecPresParam.WriteName: string;
begin
  result := WriteParamName;
end;

class function TInvSpecPresParam.WriteParamName: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := ANE_ParamName;
      end;
    svHead:
      begin
        result := 'UString_SpHead';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TInvSpecPresEnergyConcParam }

class function TInvSpecPresEnergyConcParam.ANE_ParamName: string;
begin
  result := kInvSpecConcEnergy;
end;

function TInvSpecPresEnergyConcParam.WriteName: string;
begin
  result := WriteParamName;
end;

class function TInvSpecPresEnergyConcParam.WriteParamName: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_ParamName;
      end;
    ttEnergy:
      begin
        result := 'UString_Temp';
      end;
    ttSolute:
      begin
        result := 'UString_Conc';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TInvSpecPresEnergyConcFunctionParam }

//class function TInvSpecPresEnergyConcFunctionParam.ANE_ParamName: string;
//begin
//  result := kInvSpecConcEnergyFunction;
//end;
//
//function TInvSpecPresEnergyConcFunctionParam.WriteName: string;
//begin
//  result := WriteParamName;
//end;
//
//class function TInvSpecPresEnergyConcFunctionParam.WriteParamName: string;
//begin
//  case frmSutra.TransportType of
//    ttGeneral:
//      begin
//        result := ANE_ParamName;
//      end;
//    ttEnergy:
//      begin
//        result := 'UFunction_Temp';
//      end;
//    ttSolute:
//      begin
//        result := 'UFunction_Conc';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TInvSpecPresFunctionParam }

//class function TInvSpecPresFunctionParam.ANE_ParamName: string;
//begin
//  result := kInvSpecPressureFunction;
//end;
//
//function TInvSpecPresFunctionParam.WriteName: string;
//begin
//  result := WriteParamName;
//end;
//
//class function TInvSpecPresFunctionParam.WriteParamName: string;
//begin
//  case frmSutra.StateVariableType of
//    svPressure:
//      begin
//        result := ANE_ParamName;
//      end;
//    svHead:
//      begin
//        result := 'UFunctoin_SpHead';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

end.

