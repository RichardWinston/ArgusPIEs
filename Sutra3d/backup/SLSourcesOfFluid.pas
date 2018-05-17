unit SLSourcesOfFluid;

interface

uses Dialogs, ANE_LayerUnit, SLGeneralParameters, SLCustomLayers;

type
  TTotalFluidSourceParam = class(TCustomTotalSourceParam)
    function Units: string; override;
  end;

  TSpecificFluidSourceParam = class(TCustomSpecificSourceParam)
    function Units: string; override;
  end;

  TConcTempSourceParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    function Units: string; override;
    function Value: string; override;
    function WriteName: string; override;
    class function WriteParamName: string; override;
  end;

  TResultantFluidSourceParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
    class function UsualValue: string;
  end;

  TQINUINParam = class(T_ANE_LayerParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Units: string; override;
    function Value: string; override;
    class function UsualValue: string;
  end;

  TInverseSourceParam = class(TCustomInverseParameter)
    class function ANE_ParamName: string; override;
  end;

//  TInverseSourceFunctionParam = class(TCustomInverseParameter)
//    class function ANE_ParamName: string; override;
//  end;

  TInverseSourceConcentrationParam = class(TCustomInverseParameter)
    class function ANE_ParamName: string; override;
  end;

//  TInverseSourceConcentrationFunctionParam = class(TCustomInverseParameter)
//    class function ANE_ParamName: string; override;
//  end;

  TCustomFluidSourcesLayer = class(TSutraInfoLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  T2DFluidSourcesLayer = class(TCustomFluidSourcesLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TCustom3DFluidSourceLayer = class(TCustomFluidSourcesLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    function WriteIndex: string; override;
    function WriteOldIndex: string; override;
  end;

  TPoint3DFluidSourceLayer = class(TCustom3DFluidSourceLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TCustomNonPoint3DFluidSourceLayer = class(TCustom3DFluidSourceLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TSlantedSheet3DFluidSourceLayer = class(TCustomNonPoint3DFluidSourceLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TCustomFollowMesh3DFluidSourceLayer = class(TCustomNonPoint3DFluidSourceLayer)
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TLine3DFluidSourceLayer = class(TCustomFollowMesh3DFluidSourceLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TVerticalSheet3DFluidSourceLayer = class(TCustomFollowMesh3DFluidSourceLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TVolFluidSourcesLayer = class(TCustomFollowMesh3DFluidSourceLayer)
    class function ANE_LayerName: string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TBottomFluidSourcesLayer = class(T2DFluidSourcesLayer)
    class function ANE_LayerName: string; override;
    class function WriteNewRoot: string; override;
    class function WriteSuffix: string; virtual;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

  TTopFluidSourcesLayer = class(TBottomFluidSourcesLayer)
    class function WriteSuffix: string; override;
    class function WriteNewRoot: string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers, OptionsUnit;

resourcestring
  kConcTempSource = 'conc_or_temp_of_source';
  kResultant = 'RESULTANT_FLUID_SOURCE';
  kQINUIN = 'QINUIN';
  kSources = 'Sources of Fluid';
  kPointSources = 'Sources of Fluid Points';
  kLineSources = 'Sources of Fluid Lines';
  kVerticalSheetSources = 'Sources of Fluid Sheets Vertical';
  kSlantedSheetSources = 'Sources of Fluid Sheets Slanted';
  kVolumeSources = 'Sources of Fluid Solids';
  kInverseSource = 'UString_TotSource';
  kInverseSourceConcentration = 'UString_TotConc';
//  kInverseSourceFunction = 'UFunction_TotSource';
//  kInverseSourceConcentrationFunction = 'UFunction_TotConc';

  { TTotalFluidSourceParam }

function TTotalFluidSourceParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        Result := 'M/s';
      end;
    svHead:
      begin
        result := 'L^3/s';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

function TSpecificFluidSourceParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := '(M/s)/(L, L^2, or L^3)'
      end;
    svHead:
      begin
        result := '(L^3/s)/(L, L^2, or L^3)'
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

{ TConcTempSourceParam }

class function TConcTempSourceParam.ANE_ParamName: string;
begin
  result := kConcTempSource;
end;

function TConcTempSourceParam.Units: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := 'C or degC'
      end;
    ttEnergy:
      begin
        result := 'degC'
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

function TConcTempSourceParam.Value: string;
begin
  result := kNa;
end;

function TConcTempSourceParam.WriteName: string;
begin
  result := WriteParamName;
end;

class function TConcTempSourceParam.WriteParamName: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_ParamName;
      end;
    ttEnergy:
      begin
        result := 'temperature_of_source';
      end;
    ttSolute:
      begin
        result := 'concentration_of_source';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TResultantFluidSourceParam }

class function TResultantFluidSourceParam.ANE_ParamName: string;
begin
  result := kResultant;
end;

constructor TResultantFluidSourceParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Lock := Lock + [plDef_Val, plDont_Override];
  SetValue := True;
end;

function TResultantFluidSourceParam.Units: string;
begin
  result := 'calculated';
end;

class function TResultantFluidSourceParam.UsualValue: string;
begin
  result := 'If(IsNumber('
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + ') | IsNumber('
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TTotalFluidSourceParam.ANE_ParamName
    + '), index(ContourType()+1, '
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TTotalFluidSourceParam.ANE_ParamName
    + ', If(IsNumber('
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourLength()), If(IsNumber('
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourArea()), If(IsNumber('
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    //    + T2DFluidSourcesLayer.WriteNewRoot + '.'
  + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourArea())), $n/a)';
end;

function TResultantFluidSourceParam.Value: string;
var
  ALayer: T_ANE_Layer;
  IndexString: string;
begin
  ALayer := self.GetParentLayer;
  IndexString := ALayer.WriteIndex;
  result := 'If(IsNumber('
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + ') | IsNumber('
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TTotalFluidSourceParam.ANE_ParamName
    + '), index(ContourType()+1, '
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TTotalFluidSourceParam.ANE_ParamName
    + ', If(IsNumber('
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourLength()), If(IsNumber('
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourArea()), If(IsNumber('
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    //    + T2DFluidSourcesLayer.WriteNewRoot + IndexString + '.'
  + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourArea())), $n/a)';
end;

{ TQINUINParam }

class function TQINUINParam.ANE_ParamName: string;
begin
  result := kQINUIN;
end;

constructor TQINUINParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Lock := Lock + [plDef_Val, plDont_Override];
  SetValue := True;
end;

function TQINUINParam.Units: string;
begin
  result := 'calculated';
end;

class function TQINUINParam.UsualValue: string;
begin
  result := TResultantFluidSourceParam.WriteParamName
    + '*'
    + TConcTempSourceParam.WriteParamName;
end;

function TQINUINParam.Value: string;
begin
  result := UsualValue;
end;

constructor TCustomFluidSourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
{var
  ListOfLayerLists : T_ANE_ListOfIndexedLayerLists; }
begin
  inherited;
  RenameAllParameters := True;
  Interp := leExact;

  ParamList.ParameterOrder.Add(TTotalFluidSourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TConcTempSourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDependanceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInverseSourceParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInverseSourceFunctionParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInverseSourceConcentrationParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInverseSourceConcentrationFunctionParam.ANE_ParamName);

  TTotalFluidSourceParam.Create(ParamList, -1);
  TConcTempSourceParam.Create(ParamList, -1);
  TTimeDependanceParam.Create(ParamList, -1);
  if frmSutra.cbInverse.Checked
    or frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TInverseSourceParam.Create(ParamList, -1);
//    TInverseSourceFunctionParam.Create(ParamList, -1);
    TInverseSourceConcentrationParam.Create(ParamList, -1);
//    TInverseSourceConcentrationFunctionParam.Create(ParamList, -1);
  end;
end;

class function TBottomFluidSourcesLayer.ANE_LayerName: string;
begin
  result := kSources + WriteSuffix;
end;

constructor TBottomFluidSourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Add(TCommentParam.ANE_ParamName);

  TCommentParam.Create(ParamList, -1);
end;

class function TBottomFluidSourcesLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if (frmSutra = nil) or frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;

{ TVolFluidSourcesLayer }

class function TVolFluidSourcesLayer.ANE_LayerName: string;
begin
  result := kVolumeSources;
end;

constructor TVolFluidSourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  Position: integer;
begin
  inherited;

  Position := ParamList.ParameterOrder.IndexOf(
    TTimeDependanceParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TZeroTopElevParam.ANE_ParamName);
  ParamList.ParameterOrder.Insert(Position + 1,
    TBottomElevaParam.ANE_ParamName);

  TZeroTopElevParam.Create(ParamList, -1);
  TBottomElevaParam.Create(ParamList, -1);
end;

{ T2DFluidSourcesLayer }

class function T2DFluidSourcesLayer.ANE_LayerName: string;
begin
  result := kSources;
end;

constructor T2DFluidSourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TTotalFluidSourceParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TSpecificFluidSourceParam.ANE_ParamName);

  //  Position := ParamList.ParameterOrder.IndexOf(
  //    TCommentParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(
    TResultantFluidSourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TQINUINParam.ANE_ParamName);

  TSpecificFluidSourceParam.Create(ParamList, -1);
  TResultantFluidSourceParam.Create(ParamList, -1);
  TQINUINParam.Create(ParamList, -1);

end;

{ TCustom3DFluidSourceLayer }

constructor TCustom3DFluidSourceLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
{var
  Position : integer;   }
begin
  inherited;
  //  Position := ParamList.ParameterOrder.IndexOf(
  //    TCommentParam.ANE_ParamName)+1;
  ParamList.ParameterOrder.Add(TContourType.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCommentParam.ANE_ParamName);

  TContourType.Create(ParamList, -1);
  TCommentParam.Create(ParamList, -1);
end;

function TCustom3DFluidSourceLayer.WriteIndex: string;
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

function TCustom3DFluidSourceLayer.WriteOldIndex: string;
begin
  result := WriteIndex;
end;

{ TPoint3DFluidSourceLayer }

class function TPoint3DFluidSourceLayer.ANE_LayerName: string;
begin
  result := kPointSources;
end;

constructor TPoint3DFluidSourceLayer.Create(ALayerList: T_ANE_LayerList;
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

{ TCustomNonPoint3DFluidSourceLayer }

constructor TCustomNonPoint3DFluidSourceLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  Position: integer;
begin
  inherited;
  Position := ParamList.ParameterOrder.IndexOf(
    TTotalFluidSourceParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position,
    TSpecificFluidSourceParam.ANE_ParamName);
  Position := ParamList.ParameterOrder.IndexOf(
    TCommentParam.ANE_ParamName) + 1;
  ParamList.ParameterOrder.Insert(Position, TSourceChoice.ANE_ParamName);

  TSpecificFluidSourceParam.Create(ParamList, -1);
  TSourceChoice.Create(ParamList, -1);
end;

{ TLine3DFluidSourceLayer }

class function TLine3DFluidSourceLayer.ANE_LayerName: string;
begin
  result := kLineSources;
end;

constructor TLine3DFluidSourceLayer.Create(ALayerList: T_ANE_LayerList;
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

{ TVerticalSheet3DFluidSourceLayer }

class function TVerticalSheet3DFluidSourceLayer.ANE_LayerName: string;
begin
  result := kVerticalSheetSources;
end;

constructor TVerticalSheet3DFluidSourceLayer.Create(
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

{ TSlantedSheet3DFluidSourceLayer }

class function TSlantedSheet3DFluidSourceLayer.ANE_LayerName: string;
begin
  result := kSlantedSheetSources;
end;

constructor TSlantedSheet3DFluidSourceLayer.Create(
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

{ TCustomFollowMesh3DFluidSourceLayer }

constructor TCustomFollowMesh3DFluidSourceLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Insert(0, TFollowMeshParam.ANE_ParamName);
  TFollowMeshParam.Create(ParamList, -1);

end;

class function TBottomFluidSourcesLayer.WriteSuffix: string;
begin
  result := ' Bottom';
end;

{ TTopFluidSourcesLayer }

class function TTopFluidSourcesLayer.WriteNewRoot: string;
begin
  result := ANE_LayerName;
end;

class function TTopFluidSourcesLayer.WriteSuffix: string;
begin
  result := ' Top';
end;

{ TInverseSourceParam }

class function TInverseSourceParam.ANE_ParamName: string;
begin
  result := kInverseSource;
end;

{ TInverseSourceConcentrationParam }

class function TInverseSourceConcentrationParam.ANE_ParamName: string;
begin
  result := kInverseSourceConcentration;
end;

{ TInverseSourceFunctionParam }

//class function TInverseSourceFunctionParam.ANE_ParamName: string;
//begin
//  result := kInverseSourceFunction;
//end;

{ TInverseSourceConcentrationFunctionParam }

//class function TInverseSourceConcentrationFunctionParam.ANE_ParamName: string;
//begin
//  result := kInverseSourceConcentrationFunction;
//end;

end.

