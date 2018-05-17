unit SLSourcesOfFluid;

interface

uses Dialogs, ANE_LayerUnit, SLGeneralParameters, SLCustomLayers;

type
  TTotalFluidSourceParam = class(TCustomTotalSourceParam)
//    class Function ANE_ParamName : string ; override;
    function Units : string; override;
//    function Value : string; override;
  end;

  TSpecificFluidSourceParam = class(TCustomSpecificSourceParam)
//    class Function ANE_ParamName : string ; override;
    function Units : string; override;
//    function Value : string; override;
  end;

  TConcTempSourceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    function WriteName : string; override;
    class function WriteParamName : string; override;
  end;

  TResultantFluidSourceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
    function Value : string; override;
    class function UsualValue : string;
  end;

  TQINUINParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
    function Value : string; override;
    class function UsualValue : string;
  end;


  TCustomFluidSourcesLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

  TVolFluidSourcesLayer = class(TCustomFluidSourcesLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

  TFluidSourcesLayer = class(TCustomFluidSourcesLayer)
    class Function WriteNewRoot : string; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

  TSurfaceFluidSourcesLayer = class(TCustomFluidSourcesLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers;

ResourceString
//  kTotalSource = 'total_source';
//  kSpecificSource = 'specific_source';
  kConcTempSource = 'conc_or_temp_of_source';
  kResultant = 'RESULTANT_FLUID_SOURCE';
  kQINUIN = 'QINUIN';
  kSources = 'Sources of Fluid';
  kSourcesSurf = 'Sources of Fluid surfaces';

{ TTotalFluidSourceParam }

{class function TTotalFluidSourceParam.ANE_ParamName: string;
begin
  result := kTotalSource;
end;   }

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

{function TTotalFluidSourceParam.Value: string;
begin
  result := kNa
end;  }

{ TSpecificFluidSourceParam }

{class function TSpecificFluidSourceParam.ANE_ParamName: string;
begin
  result := kSpecificSource
end;   }

function TSpecificFluidSourceParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := '(M/s)/(L or L^2)'
      end;
    svHead:
      begin
        result := '(L^3/s)/(L or L^2)'
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

{function TSpecificFluidSourceParam.Value: string;
begin
  result := kNa;
end;    }

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
    + TFluidSourcesLayer.WriteNewRoot + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ') | IsNumber('
    + TFluidSourcesLayer.WriteNewRoot + '.' + TTotalFluidSourceParam.ANE_ParamName
    + '), index(ContourType()+1, '
    + TFluidSourcesLayer.WriteNewRoot + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    + TFluidSourcesLayer.WriteNewRoot + '.' + TTotalFluidSourceParam.ANE_ParamName
    + ', If(IsNumber('
    + TFluidSourcesLayer.WriteNewRoot + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    + TFluidSourcesLayer.WriteNewRoot + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    + TFluidSourcesLayer.WriteNewRoot + '.' + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourLength()), If(IsNumber('
    + TFluidSourcesLayer.WriteNewRoot + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    + TFluidSourcesLayer.WriteNewRoot + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    + TFluidSourcesLayer.WriteNewRoot + '.' + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourArea()), If(IsNumber('
    + TFluidSourcesLayer.WriteNewRoot + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    + TFluidSourcesLayer.WriteNewRoot + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    + TFluidSourcesLayer.WriteNewRoot + '.' + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourArea())), $n/a)';
end;

function TResultantFluidSourceParam.Value: string;
var
  ALayer : T_ANE_Layer;
  IndexString : string;
begin
  ALayer := self.GetParentLayer;
  IndexString := ALayer.WriteIndex;
  result := 'If(IsNumber('
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ') | IsNumber('
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TTotalFluidSourceParam.ANE_ParamName
    + '), index(ContourType()+1, '
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TTotalFluidSourceParam.ANE_ParamName
    + ', If(IsNumber('
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourLength()), If(IsNumber('
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TTotalFluidSourceParam.ANE_ParamName
    + '/ContourArea()), If(IsNumber('
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + '), '
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TSpecificFluidSourceParam.ANE_ParamName
    + ', '
    + TFluidSourcesLayer.WriteNewRoot + IndexString + '.' + TTotalFluidSourceParam.ANE_ParamName
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

{ TCustomFluidSourcesLayer }

class function TCustomFluidSourcesLayer.ANE_LayerName: string;
begin
  result := kSources;
end;

constructor TCustomFluidSourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  ListOfLayerLists : T_ANE_ListOfIndexedLayerLists;
begin
  inherited;
  RenameAllParameters := True;
  Interp := leExact;

  ParamList.ParameterOrder.Add(TTotalFluidSourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TSpecificFluidSourceParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TIs3DSurfaceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TConcTempSourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDependanceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTopElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TBottomElevaParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TSourceChoice.ANE_ParamName);
  ParamList.ParameterOrder.Add(TContourType.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCommentParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TResultantFluidSourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TQINUINParam.ANE_ParamName);

  TTotalFluidSourceParam.Create(ParamList, -1);
  TSpecificFluidSourceParam.Create(ParamList, -1);
  TConcTempSourceParam.Create(ParamList, -1);
  TTimeDependanceParam.Create(ParamList, -1);
  TCommentParam.Create(ParamList, -1);
{  if frmSutra.Is3D then
  begin
    TTopElevaParam.Create(ParamList, -1);
    TBottomElevaParam.Create(ParamList, -1);
  end;   }
  with frmSutra do
  begin

    ListOfLayerLists := nil;
    if ALayerList.Owner is T_ANE_ListOfIndexedLayerLists then
    begin
      ListOfLayerLists := T_ANE_ListOfIndexedLayerLists(ALayerList.Owner);
      if (ALayerList.Owner =
        ListOfLayerLists.Owner.FirstListsOfIndexedLayers)
        and Is3D then
      begin
        TSourceChoice.Create(ParamList, -1);
        TContourType.Create(ParamList, -1);
      end
      else
      begin
        ListOfLayerLists := nil;
      end;
    end;
    if ListOfLayerLists = nil then
    begin
      TResultantFluidSourceParam.Create(ParamList, -1);
      TQINUINParam.Create(ParamList, -1);
    end;

  end;

end;

constructor TFluidSourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  if frmSutra.Is3D then
  begin
    TTopElevaParam.Create(ParamList, -1);
    TBottomElevaParam.Create(ParamList, -1);
  end;
end;

class function TFluidSourcesLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraNodeSurfaceGroupLayer.WriteNewRoot;
  end;

end;

{ TSurfaceFluidSourcesLayer }

class function TSurfaceFluidSourcesLayer.ANE_LayerName: string;
begin
  result := kSourcesSurf;
end;

constructor TSurfaceFluidSourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  ParamIndex : integer;
begin
  inherited;
  if frmSutra.Is3D then
  begin
    TZeroTopElevParam.Create(ParamList, -1);
    TZeroBottomElevaParam.Create(ParamList, -1);
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

{ TVolFluidSourcesLayer }

constructor TVolFluidSourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  if frmSutra.Is3D then
  begin
    TZeroTopElevParam.Create(ParamList, -1);
    TZeroBottomElevaParam.Create(ParamList, -1);
  end;
  ParamList.ParameterOrder.Insert(0, TFollowMeshParam.ANE_ParamName);
  TFollowMeshParam.Create(ParamList, -1);

end;

end.
