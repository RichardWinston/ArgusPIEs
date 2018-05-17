unit SLSpecConcOrTemp;

interface

uses ANE_LayerUnit, AnePIE, SLCustomLayers, SLGeneralParameters;

type
  TSpecConcTempParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
    function WriteName: string; override;
    class function WriteParamName: string; override;
  end;

  {$IFDEF OldSutraIce}
  TConductance = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
  end;
  {$ENDIF}

  TInvSpecConcParam   = class(TCustomInverseParameter)
    class function ANE_ParamName: string; override;
    function WriteName: string; override;
    class function WriteParamName: string; override;
  end;

//  TInvSpecConcFunctionParam   = class(TCustomInverseParameter)
//    class function ANE_ParamName: string; override;
//    function WriteName: string; override;
//    class function WriteParamName: string; override;
//  end;

  TCustomSpecConcTempLayer = class(TSutraInfoLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
    class function WriteLayerType: string; virtual; abstract;
  end;

  T2DSpecConcTempLayer = class(TCustomSpecConcTempLayer)
    class function ANE_LayerName: string; override;
    class function WriteLayerType: string; override;
  end;

  TBottomSpecConcTempLayer = class(T2DSpecConcTempLayer)
  public
    class function ANE_LayerName: string; override;
    class function WriteNewRoot: string; override;
    class function WriteSuffix: string; virtual;
  end;

  TTopSpecConcTempLayer = class(T2DSpecConcTempLayer)
    class function ANE_LayerName: string; override;
    class function WriteSuffix: string; virtual;
    class function WriteNewRoot: string; override;
  end;

  TCustom3DSpecConcTempLayer = class(TCustomSpecConcTempLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    function WriteIndex: string; override;
    function WriteOldIndex: string; override;
  end;

  TPoint3DSpecConcTempLayer = class(TCustom3DSpecConcTempLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteLayerType: string; override;
  end;

  TSlantedSheet3DSpecConcTempLayer = class(TCustom3DSpecConcTempLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteLayerType: string; override;
  end;

  TCustomFollowMesh3DSpecConcTempLayer = class(TCustom3DSpecConcTempLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TLine3DSpecConcTempLayer = class(TCustomFollowMesh3DSpecConcTempLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteLayerType: string; override;
  end;

  TVerticalSheet3DSpecConcTempLayer = class(TCustomFollowMesh3DSpecConcTempLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteLayerType: string; override;
  end;

  TVolSpecConcTempLayer = class(TCustomFollowMesh3DSpecConcTempLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteLayerType: string; override;
  end;

  {  TSurfaceSpecConcTempLayer = class(TCustomSpecConcTempLayer)
      class Function ANE_LayerName : string ; override;
      constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
         = -1 ); override;
      class function WriteNewRoot : string; override;
    end;  }

implementation

uses frmSutraUnit, SLGroupLayers;

resourcestring
  kSpecConcTempParam = 'specified_conc_or_temp';
  kSpecConcTempLayer = 'Specified Conc or Temp';
  kSpecConcTempLayerSurf = 'Specified Conc or Temp surfaces';
  kPointSpecConcTempLayer = 'Specified Conc or Temp Points';
  kLineSpecConcTempLayer = 'Specified Conc or Temp Lines';
  kVerticalSheetSpecConcTempLayer = 'Specified Conc or Temp Sheets Vertical';
  kSlantedSpecConcTempLayer = 'Specified Conc or Temp Sheets Slanted';
  kVolSpecConcTempLayer = 'Specified Conc or Temp Solids';
  kInvSpecConcTempParam = 'UString_SpConc_or_SpTemp';
  kConductance = 'Conductance';
//  kInvSpecConcTempFunctionParam = 'UFunction_SpConc_or_SpTemp';

  { TSpecConcTempParam }

class function TSpecConcTempParam.ANE_ParamName: string;
begin
  result := kSpecConcTempParam;
end;

function TSpecConcTempParam.Units: string;
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

function TSpecConcTempParam.Value: string;
begin
  result := kNa;
end;

function TSpecConcTempParam.WriteName: string;
begin
  result := WriteParamName;
end;

class function TSpecConcTempParam.WriteParamName: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := TSpecConcTempParam.ANE_ParamName;
      end;
    ttEnergy:
      begin
        result := 'specified_temperature';
      end;
    ttSolute:
      begin
        result := 'specified_concentration';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TVolSpecConcTempLayer }

class function TVolSpecConcTempLayer.ANE_LayerName: string;
begin
  result := kVolSpecConcTempLayer;
end;

constructor TVolSpecConcTempLayer.Create(ALayerList: T_ANE_LayerList;
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

class function TVolSpecConcTempLayer.WriteLayerType: string;
begin
  result := 'Solids';
end;

{ T2DSpecConcTempLayer }

class function T2DSpecConcTempLayer.ANE_LayerName: string;
begin
  result := kSpecConcTempLayer;
end;

class function TBottomSpecConcTempLayer.ANE_LayerName: string;
begin
  result := kSpecConcTempLayer + WriteSuffix;
end;

{constructor TBottomSpecConcTempLayer.Create(ALayerList: T_ANE_LayerList;
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
end; }

class function T2DSpecConcTempLayer.WriteLayerType: string;
begin
  result := '';
end;

{ TSurfaceSpecConcTempLayer }

{class function TSurfaceSpecConcTempLayer.ANE_LayerName: string;
begin
  result := kSpecConcTempLayerSurf
end;

constructor TSurfaceSpecConcTempLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
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

class function TSurfaceSpecConcTempLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Specified Temperature surfaces';
      end;
    ttSolute:
      begin
        result := 'Specified Concentration surfaces';
      end;
    else
      begin
        Assert(False);
      end;
  end;
end;  }

{ TCustomSpecConcTempLayer }

constructor TCustomSpecConcTempLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
{var
  ListOfLayerLists : T_ANE_ListOfIndexedLayerLists;}
begin
  inherited;
  RenameAllParameters := True;
  Interp := leExact;

  ParamList.ParameterOrder.Add(TSpecConcTempParam.ANE_ParamName);
  {$IFDEF OldSutraIce}
  ParamList.ParameterOrder.Add(TConductance.ANE_ParamName);
  {$ENDIF}

  ParamList.ParameterOrder.Add(TTimeDependanceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvSpecConcParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvSpecConcFunctionParam.ANE_ParamName);

  TSpecConcTempParam.Create(ParamList, -1);
  TTimeDependanceParam.Create(ParamList, -1);

  {$IFDEF OldSutraIce}
  if frmSutra.rbFreezing.Checked then
  begin
    TConductance.Create(ParamList, -1);
  end;
  {$ENDIF}

  if frmSutra.cbInverse.Checked
     or frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TInvSpecConcParam.Create(ParamList, -1);
//    TInvSpecConcFunctionParam.Create(ParamList, -1);
  end;
end;

class function TCustomSpecConcTempLayer.WriteNewRoot: string;
var
  LayerType: string;
begin
  if (frmSutra = nil) then
  begin
    result := 'Specified Concentration';
    LayerType := ' ' + WriteLayerType;
    if LayerType <> ' ' then
    begin
      result := result + LayerType
    end;
  end
  else
  begin
    case frmSutra.TransportType of
      ttGeneral:
        begin
          result := ANE_LayerName;
        end;
      ttEnergy:
        begin
          result := 'Specified Temperature';
          LayerType := ' ' + WriteLayerType;
          if LayerType <> ' ' then
          begin
            result := result + LayerType
          end;
        end;
      ttSolute:
        begin
          result := 'Specified Concentration';
          LayerType := ' ' + WriteLayerType;
          if LayerType <> ' ' then
          begin
            result := result + LayerType
          end;
        end;
    else
      begin
        Assert(False);
      end;
    end;
  end;

end;

{ TCustom3DSpecConcTempLayer }

constructor TCustom3DSpecConcTempLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
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

function TCustom3DSpecConcTempLayer.WriteIndex: string;
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

function TCustom3DSpecConcTempLayer.WriteOldIndex: string;
begin
  result := WriteIndex;
end;

{ TPoint3DSpecConcTempLayer }

class function TPoint3DSpecConcTempLayer.ANE_LayerName: string;
begin
  result := kPointSpecConcTempLayer;
end;

constructor TPoint3DSpecConcTempLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TTimeDependanceParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position, TElevationParam.ANE_ParamName);
  TElevationParam.Create(ParamList, -1);
end;

class function TPoint3DSpecConcTempLayer.WriteLayerType: string;
begin
  result := 'Points'
end;

{ TLine3DSpecConcTempLayer }

class function TLine3DSpecConcTempLayer.ANE_LayerName: string;
begin
  result := kLineSpecConcTempLayer;
end;

constructor TLine3DSpecConcTempLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
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

class function TLine3DSpecConcTempLayer.WriteLayerType: string;
begin
  result := 'Lines';
end;

{ TVerticalSheet3DSpecConcTempLayer }

class function TVerticalSheet3DSpecConcTempLayer.ANE_LayerName: string;
begin
  result := kVerticalSheetSpecConcTempLayer;
end;

constructor TVerticalSheet3DSpecConcTempLayer.Create(
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

class function TVerticalSheet3DSpecConcTempLayer.WriteLayerType: string;
begin
  result := 'Sheets Vertical';
end;

{ TSlantedSheet3DSpecConcTempLayer }

class function TSlantedSheet3DSpecConcTempLayer.ANE_LayerName: string;
begin
  result := kSlantedSpecConcTempLayer;
end;

constructor TSlantedSheet3DSpecConcTempLayer.Create(
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

class function TSlantedSheet3DSpecConcTempLayer.WriteLayerType: string;
begin
  result := 'Sheets Slanted';
end;

{ TCustomNonPoint3DSpecConcTempLayer }

{ TCustomFollowMesh3DSpecConcTempLayer }

constructor TCustomFollowMesh3DSpecConcTempLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Insert(0, TFollowMeshParam.ANE_ParamName);
  TFollowMeshParam.Create(ParamList, -1);

end;

class function TBottomSpecConcTempLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if Pos(WriteSuffix, result) < 1 then
  begin
    result := result + WriteSuffix;
  end;

  if (frmSutra = nil) or frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;

end;

class function TBottomSpecConcTempLayer.WriteSuffix: string;
begin
  result := ' Bottom';
end;

{ TTopSpecConcTempLayer }

class function TTopSpecConcTempLayer.ANE_LayerName: string;
begin
  result := kSpecConcTempLayer + WriteSuffix;
end;

class function TTopSpecConcTempLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if Pos(WriteSuffix, result) < 1 then
  begin
    result := result + WriteSuffix;
  end;
end;

class function TTopSpecConcTempLayer.WriteSuffix: string;
begin
  result := ' Top';
end;

{ TInvSpecConcParam }

class function TInvSpecConcParam.ANE_ParamName: string;
begin
  result := kInvSpecConcTempParam;
end;

function TInvSpecConcParam.WriteName: string;
begin
  result := WriteParamName;
end;

class function TInvSpecConcParam.WriteParamName: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_ParamName;
      end;
    ttEnergy:
      begin
        result := 'UString_SpTemp';
      end;
    ttSolute:
      begin
        result := 'UString_SpConc';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TInvSpecConcFunctionParam }

//class function TInvSpecConcFunctionParam.ANE_ParamName: string;
//begin
//  result := kInvSpecConcTempFunctionParam;
//end;
//
//function TInvSpecConcFunctionParam.WriteName: string;
//begin
//  result := WriteParamName;
//end;
//
//class function TInvSpecConcFunctionParam.WriteParamName: string;
//begin
//  case frmSutra.TransportType of
//    ttGeneral:
//      begin
//        result := ANE_ParamName;
//      end;
//    ttEnergy:
//      begin
//        result := 'UFunction_SpTemp';
//      end;
//    ttSolute:
//      begin
//        result := 'UFunction_SpConc';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

{ TConductance }

{$IFDEF OldSutraIce}
class function TConductance.ANE_ParamName: string;
begin
  result := kConductance;
end;
{$ENDIF}

end.

