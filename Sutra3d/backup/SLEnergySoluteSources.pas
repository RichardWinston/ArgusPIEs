unit SLEnergySoluteSources;

interface

uses ANE_LayerUnit, AnePIE, SLGeneralParameters, SLCustomLayers;

type
  TTotalSoluteEnergySourceParam = class(TCustomTotalSourceParam)
    function Units: string; override;
  end;

  TSpecificSoluteEnergySourceParam = class(TCustomSpecificSourceParam)
    function Units: string; override;
  end;

  TInverseSpecifiedSoluteOrEnergySource = class(TCustomInverseParameter)
    class Function ANE_ParamName : string ; override;
    function WriteName: string; override;
    class function WriteParamName: string; override;
  end;

//  TInverseSpecifiedSoluteOrEnergySourceFunction = class(TCustomInverseParameter)
//    class Function ANE_ParamName : string ; override;
//    function WriteName: string; override;
//    class function WriteParamName: string; override;
//  end;

  TResultantSoluteEnergySourceParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
    function WriteName: string; override;
    class function WriteParamName: string; override;
    class function UsualValue: string;
  end;

  TCustomSoluteEnergySourcesLayer = class(TSutraInfoLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  T2DSoluteEnergySourcesLayer = class(TCustomSoluteEnergySourcesLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

  TCustom3DSoluteEnergySourcesLayer = class(TCustomSoluteEnergySourcesLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    function WriteIndex: string; override;
    function WriteOldIndex: string; override;
  end;

  TPoint3DSoluteEnergySourcesLayer = class(TCustom3DSoluteEnergySourcesLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

  TCustomNonPoint3DSoluteEnergySourcesLayer =
    class(TCustom3DSoluteEnergySourcesLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TSlantedSheet3DSoluteEnergySourcesLayer =
    class(TCustomNonPoint3DSoluteEnergySourcesLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

  TCustomFollowMesh3DSoluteEnergySourcesLayer =
    class(TCustomNonPoint3DSoluteEnergySourcesLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TLine3DSoluteEnergySourcesLayer =
    class(TCustomFollowMesh3DSoluteEnergySourcesLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

  TVerticalSheet3DSoluteEnergySourcesLayer =
    class(TCustomFollowMesh3DSoluteEnergySourcesLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

  TVolSoluteEnergySourcesLayer =
    class(TCustomFollowMesh3DSoluteEnergySourcesLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot: string; override;
  end;

  TBottomSoluteEnergySourcesLayer = class(T2DSoluteEnergySourcesLayer)
    class function ANE_LayerName: string; override;
    class function WriteNewRoot: string; override;
    //    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
    //       = -1 ); override;
    class function WriteSuffix: string; virtual;
  end;

  TTopSoluteEnergySourcesLayer = class(T2DSoluteEnergySourcesLayer)
    class function ANE_LayerName: string; override;
    class function WriteSuffix: string; virtual;
    class function WriteNewRoot: string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers, OptionsUnit;

resourcestring
  //  kTotalSource = 'total_source';
  //  kSpecificSource = 'specific_source';
  kResultantEnergySolute = 'RESULTANT_ENERGY_OR_SOLUTE_SOURCES';
  kEnergySoluteSource = 'Sources of Energy or Solute';
  //  kEnergySoluteSourceSurf = 'Sources of Energy or Solute Surfaces';
  kPointEnergySoluteSource = 'Sources of Energy or Solute Points';
  kLineEnergySoluteSource = 'Sources of Energy or Solute Lines';
  kVerticalEnergySoluteSource = 'Sources of Energy or Solute Sheets Vertical';
  kSlantedEnergySoluteSource = 'Sources of Energy or Solute Sheets Slanted';
  kVolumeEnergySoluteSource = 'Sources of Energy or Solute Solids';
  kInverseEnergySolute = 'UString_TotEnergy_or_TotConc';
//  kInverseEnergySoluteFunction = 'UFunction_TotEnergy_or_TotConc';

  { TTotalSoluteEnergySourceParam }

  {class function TTotalSoluteEnergySourceParam.ANE_ParamName: string;
  begin
    result := kTotalSource;
  end;}

function TTotalSoluteEnergySourceParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := '(M or E)/s';
      end;
    ttEnergy:
      begin
        result := 'E/s'
      end;
    ttSolute:
      begin
        case frmSutra.StateVariableType of
          svPressure:
            begin
              result := 'M/s';
            end;
          svHead:
            begin
              result := '(C*L^3)/s';
            end;
        else
          begin
            Assert(False);
          end;
        end;
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

{function TTotalSoluteEnergySourceParam.Value: string;
begin
  result := kNa;
end;   }

{ TSpecificSoluteEnergySourceParam }

{class function TSpecificSoluteEnergySourceParam.ANE_ParamName: string;
begin
  result := kSpecificSource;
end;  }

function TSpecificSoluteEnergySourceParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := '((M or E)/s)/(L, L^2, or L^3)';
      end;
    ttEnergy:
      begin
        result := '(E/s)/(L, L^2, or L^3)'
      end;
    ttSolute:
      begin
        case frmSutra.StateVariableType of
          svPressure:
            begin
              result := '(M/s)/(L, L^2, or L^3)';
            end;
          svHead:
            begin
              result := '((C*L^3)/s)/(L, L^2, or L^3)';
            end;
        else
          begin
            Assert(False);
          end;
        end;
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

{function TSpecificSoluteEnergySourceParam.Value: string;
begin
  result := kNa;
end;}

{ TResultantSoluteEnergySourceParam }

class function TResultantSoluteEnergySourceParam.ANE_ParamName: string;
begin
  result := kResultantEnergySolute
end;

constructor TResultantSoluteEnergySourceParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Lock := Lock + [plDef_Val, plDont_Override];
  SetValue := True;
end;

function TResultantSoluteEnergySourceParam.Units: string;
begin
  result := 'calculated'
end;

class function TResultantSoluteEnergySourceParam.UsualValue: string;
begin
  result := 'If(IsNumber('
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
  + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + ')|IsNumber('
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
  + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '), If(IsNumber('
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
  + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + '), '
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
  + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + ', If(ContourType()=3, '
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
  + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '/ContourArea(), If(ContourType()=2, '
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
  + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '/ContourLength(), '
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + '.'
  + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '))), $n/a)';
end;

function TResultantSoluteEnergySourceParam.Value: string;
var
  ALayer: T_ANE_Layer;
  IndexString: string;
begin
  ALayer := self.GetParentLayer;
  IndexString := ALayer.WriteIndex;
  result := 'If(IsNumber('
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.'
  + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + ')|IsNumber('
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.'
  + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '), If(IsNumber('
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.'
  + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + '), '
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.'
  + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + ', If(ContourType()=3, '
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.'
  + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '/ContourArea(), If(ContourType()=2, '
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.'
  + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '/ContourLength(), '
    //    + T2DSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.'
  + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '))), $n/a)';
end;

function TResultantSoluteEnergySourceParam.WriteName: string;
begin
  result := WriteParamName;
end;

class function TResultantSoluteEnergySourceParam.WriteParamName: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := TResultantSoluteEnergySourceParam.ANE_ParamName;
      end;
    ttEnergy:
      begin
        result := 'RESULTANT_ENERGY_SOURCES';
      end;
    ttSolute:
      begin
        result := 'RESULTANT_SOLUTE_SOURCES';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

{ TVolSoluteEnergySourcesLayer }

class function TVolSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kVolumeEnergySoluteSource;
end;

constructor TVolSoluteEnergySourcesLayer.Create(ALayerList: T_ANE_LayerList;
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

class function TVolSoluteEnergySourcesLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Sources of Energy Solids';
      end;
    ttSolute:
      begin
        result := 'Sources of Solute Solids';
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

{ TBottomSoluteEnergySourcesLayer }

class function TBottomSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kEnergySoluteSource + WriteSuffix;
end;

{constructor TBottomSoluteEnergySourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer = -1);
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

class function TBottomSoluteEnergySourcesLayer.WriteNewRoot: string;
begin
  if (frmSutra = nil) then
  begin
    result := 'Sources of Solute' + WriteSuffix;
  end
  else
  begin
    result := inherited WriteNewRoot;
    ;
  end;
  if Pos(WriteSuffix, result) < 1 then
  begin
    result := result + WriteSuffix
  end;
  if (frmSutra = nil) or frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;

{ TSurfaceSoluteEnergySourcesLayer }

{
class function TSurfaceSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kEnergySoluteSourceSurf
end;

constructor TSurfaceSoluteEnergySourcesLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer = -1);
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

class function TSurfaceSoluteEnergySourcesLayer.WriteNewRoot: string;
begin

  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := TSoluteEnergySourcesLayer.ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Sources of Energy surfaces';
      end;
    ttSolute:
      begin
        result := 'Sources of Solute surfaces';
      end;
    else
      begin
        Assert(False);
      end;
  end;

end;
}

{ TCustomSoluteEnergySourcesLayer }

{class function TCustomSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kEnergySoluteSource
end;  }

constructor TCustomSoluteEnergySourcesLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
{var
  ListOfLayerLists : T_ANE_ListOfIndexedLayerLists;}
begin
  inherited;
  Interp := leExact;
  RenameAllParameters := True;

  ParamList.ParameterOrder.Add(TTotalSoluteEnergySourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDependanceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInverseSpecifiedSoluteOrEnergySource.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInverseSpecifiedSoluteOrEnergySourceFunction.ANE_ParamName);

  TTotalSoluteEnergySourceParam.Create(ParamList, -1);
  TTimeDependanceParam.Create(ParamList, -1);
  if frmSutra.cbInverse.Checked
    or frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TInverseSpecifiedSoluteOrEnergySource.Create(ParamList, -1);
//    TInverseSpecifiedSoluteOrEnergySourceFunction.Create(ParamList, -1);
  end;

end;

class function TBottomSoluteEnergySourcesLayer.WriteSuffix: string;
begin
  result := ' Bottom';
end;

{ T2DSoluteEnergySourcesLayer }

class function T2DSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kEnergySoluteSource;
end;

constructor T2DSoluteEnergySourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TTotalSoluteEnergySourceParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TSpecificSoluteEnergySourceParam.ANE_ParamName);

  //  Position := ParamList.ParameterOrder.IndexOf(
  //    TCommentParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(
    TResultantSoluteEnergySourceParam.ANE_ParamName);

  TSpecificSoluteEnergySourceParam.Create(ParamList, -1);
  TResultantSoluteEnergySourceParam.Create(ParamList, -1);

end;

class function T2DSoluteEnergySourcesLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Sources of Energy';
      end;
    ttSolute:
      begin
        result := 'Sources of Solute';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TCustom3DSoluteEnergySourcesLayer }

constructor TCustom3DSoluteEnergySourcesLayer.Create(
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

function TCustom3DSoluteEnergySourcesLayer.WriteIndex: string;
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

function TCustom3DSoluteEnergySourcesLayer.WriteOldIndex: string;
begin
  result := WriteIndex;
end;

{ TPoint3DSoluteEnergySourcesLayer }

class function TPoint3DSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kPointEnergySoluteSource;
end;

constructor TPoint3DSoluteEnergySourcesLayer.Create(
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

class function TPoint3DSoluteEnergySourcesLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Sources of Energy Points';
      end;
    ttSolute:
      begin
        result := 'Sources of Solute Points';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TLine3DSoluteEnergySourcesLayer }

class function TLine3DSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kLineEnergySoluteSource;
end;

constructor TLine3DSoluteEnergySourcesLayer.Create(
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

class function TLine3DSoluteEnergySourcesLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Sources of Energy Lines';
      end;
    ttSolute:
      begin
        result := 'Sources of Solute Lines';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TVerticalSheet3DSoluteEnergySourcesLayer }

class function TVerticalSheet3DSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kVerticalEnergySoluteSource;
end;

constructor TVerticalSheet3DSoluteEnergySourcesLayer.Create(
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

class function TVerticalSheet3DSoluteEnergySourcesLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Sources of Energy Sheets Vertical';
      end;
    ttSolute:
      begin
        result := 'Sources of Solute Sheets Vertical';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TSlantedSheet3DSoluteEnergySourcesLayer }

class function TSlantedSheet3DSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kSlantedEnergySoluteSource
end;

constructor TSlantedSheet3DSoluteEnergySourcesLayer.Create(
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

class function TSlantedSheet3DSoluteEnergySourcesLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Sources of Energy Sheets Slanted';
      end;
    ttSolute:
      begin
        result := 'Sources of Solute Sheets Slanted';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TCustomNonPoint3DSoluteEnergySourcesLayer }

constructor TCustomNonPoint3DSoluteEnergySourcesLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TTotalSoluteEnergySourceParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TSpecificSoluteEnergySourceParam.ANE_ParamName);
  Position := ParamList.ParameterOrder.IndexOf(
    TCommentParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position, TSourceChoice.ANE_ParamName);

  TSpecificSoluteEnergySourceParam.Create(ParamList, -1);
  TSourceChoice.Create(ParamList, -1);
end;

{ TCustomFollowMesh3DSoluteEnergySourcesLayer }

constructor TCustomFollowMesh3DSoluteEnergySourcesLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Insert(0, TFollowMeshParam.ANE_ParamName);
  TFollowMeshParam.Create(ParamList, -1);

end;

{ TTopSoluteEnergySourcesLayer }

class function TTopSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kEnergySoluteSource + WriteSuffix;
end;

class function TTopSoluteEnergySourcesLayer.WriteNewRoot: string;
begin
  if (frmSutra = nil) then
  begin
    result := 'Sources of Solute' + WriteSuffix;
  end
  else
  begin
    result := inherited WriteNewRoot;
  end;
  if Pos(WriteSuffix, result) < 1 then
  begin
    result := result + WriteSuffix
  end;
end;

class function TTopSoluteEnergySourcesLayer.WriteSuffix: string;
begin
  result := ' Top';
end;

{ TInverseSpecifiedSoluteOrEnergySource }

class function TInverseSpecifiedSoluteOrEnergySource.ANE_ParamName: string;
begin
  result := kInverseEnergySolute;
end;

function TInverseSpecifiedSoluteOrEnergySource.WriteName: string;
begin
  result := WriteParamName;
end;

class function TInverseSpecifiedSoluteOrEnergySource.WriteParamName: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_ParamName;
      end;
    ttEnergy:
      begin
        result := 'UString_TotEnergy';
      end;
    ttSolute:
      begin
        result := 'UString_TotConc';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TInverseSpecifiedSoluteOrEnergySourceFunction }

//class function TInverseSpecifiedSoluteOrEnergySourceFunction.ANE_ParamName: string;
//begin
//  result := kInverseEnergySoluteFunction;
//end;
//
//function TInverseSpecifiedSoluteOrEnergySourceFunction.WriteName: string;
//begin
//  result := WriteParamName;
//end;
//
//class function TInverseSpecifiedSoluteOrEnergySourceFunction.WriteParamName: string;
//begin
//  case frmSutra.TransportType of
//    ttGeneral:
//      begin
//        result := ANE_ParamName;
//      end;
//    ttEnergy:
//      begin
//        result := 'UFunction_TotEnergy';
//      end;
//    ttSolute:
//      begin
//        result := 'UFunction_TotConc';
//      end;
//  else
//    begin
//      Assert(False);
//    end;
//  end;
//end;

end.

