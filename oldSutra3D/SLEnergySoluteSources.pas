unit SLEnergySoluteSources;

interface

uses ANE_LayerUnit, AnePIE, SLGeneralParameters, SLCustomLayers;

type
  TTotalSoluteEnergySourceParam = class(TCustomTotalSourceParam)
//    class Function ANE_ParamName : string ; override;
    function Units : string; override;
//    function Value : string; override;
  end;

  TSpecificSoluteEnergySourceParam = class(TCustomSpecificSourceParam)
//    class Function ANE_ParamName : string ; override;
    function Units : string; override;
//    function Value : string; override;
  end;

  TResultantSoluteEnergySourceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
    function Value : string; override;
    function WriteName : string; override;
    Class function WriteParamName : string ; override;
    class function UsualValue : string;
  end;

  TCustomSoluteEnergySourcesLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class function WriteNewRoot : string; override;
  end;

  TVolSoluteEnergySourcesLayer = class(TCustomSoluteEnergySourcesLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

  TSoluteEnergySourcesLayer = class(TCustomSoluteEnergySourcesLayer)
    class function WriteNewRoot : string; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

  TSurfaceSoluteEnergySourcesLayer = class(TCustomSoluteEnergySourcesLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class function WriteNewRoot : string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers;

ResourceString
//  kTotalSource = 'total_source';
//  kSpecificSource = 'specific_source';
  kResultantEnergySolute = 'RESULTANT_ENERGY_OR_SOLUTE_SOURCES';
  kEnergySoluteSource = 'Sources of Energy or Solute';
  kEnergySoluteSourceSurf = 'Sources of Energy or Solute Surfaces';

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
        result := '((M or E)/s)/(L or L^2)';
      end;
    ttEnergy:
      begin
        result := '(E/s)/(L or L^2)'
      end;
    ttSolute:
      begin
        case frmSutra.StateVariableType of
          svPressure:
            begin
              result := '(M/s)/(L or L^2)';
            end;
          svHead:
            begin
              result := '((C*L^3)/s)/(L or L^2)';
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
  Lock := Lock + [plDef_Val,plDont_Override];
  SetValue := True;
end;

function TResultantSoluteEnergySourceParam.Units: string;
begin
  result := 'calculated'
end;

class function TResultantSoluteEnergySourceParam.UsualValue: string;
begin
  result := 'If(IsNumber('
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + ')|IsNumber('
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '), If(IsNumber('
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + '), '
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + ', If(ContourType()=3, '
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '/ContourArea(), If(ContourType()=2, '
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '/ContourLength(), '
    + TSoluteEnergySourcesLayer.WriteNewRoot + '.' + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '))), $n/a)';
end;

function TResultantSoluteEnergySourceParam.Value: string;
var
  ALayer : T_ANE_Layer;
  IndexString : string;
begin
  ALayer := self.GetParentLayer;
  IndexString := ALayer.WriteIndex;
  result := 'If(IsNumber('
    + TSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.' + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + ')|IsNumber('
    + TSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.' + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '), If(IsNumber('
    + TSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.' + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + '), '
    + TSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.' + TSpecificSoluteEnergySourceParam.ANE_ParamName
    + ', If(ContourType()=3, '
    + TSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.' + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '/ContourArea(), If(ContourType()=2, '
    + TSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.' + TTotalSoluteEnergySourceParam.ANE_ParamName
    + '/ContourLength(), '
    + TSoluteEnergySourcesLayer.WriteNewRoot + IndexString + '.' + TTotalSoluteEnergySourceParam.ANE_ParamName
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

constructor TVolSoluteEnergySourcesLayer.Create(ALayerList: T_ANE_LayerList;
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


{ TSoluteEnergySourcesLayer }

constructor TSoluteEnergySourcesLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  if frmSutra.Is3D then
  begin
    TTopElevaParam.Create(ParamList, -1);
    TBottomElevaParam.Create(ParamList, -1);
  end;
end;

class function TSoluteEnergySourcesLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraNodeSurfaceGroupLayer.WriteNewRoot;
  end;
end;

{ TSurfaceSoluteEnergySourcesLayer }

class function TSurfaceSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kEnergySoluteSourceSurf
end;

constructor TSurfaceSoluteEnergySourcesLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
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

{ TCustomSoluteEnergySourcesLayer }

class function TCustomSoluteEnergySourcesLayer.ANE_LayerName: string;
begin
  result := kEnergySoluteSource
end;

constructor TCustomSoluteEnergySourcesLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  ListOfLayerLists : T_ANE_ListOfIndexedLayerLists;
begin
  inherited;
  Interp := leExact;
  RenameAllParameters := True;

  ParamList.ParameterOrder.Add(TTotalSoluteEnergySourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TSpecificSoluteEnergySourceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDependanceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTopElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TBottomElevaParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TSourceChoice.ANE_ParamName);
  ParamList.ParameterOrder.Add(TContourType.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCommentParam.ANE_ParamName);

  ParamList.ParameterOrder.Add(TResultantSoluteEnergySourceParam.ANE_ParamName);

  TTotalSoluteEnergySourceParam.Create(ParamList, -1);
  TSpecificSoluteEnergySourceParam.Create(ParamList, -1);
  TTimeDependanceParam.Create(ParamList, -1);
  TCommentParam.Create(ParamList, -1);

{  if frmSutra.Is3D then
  begin
    TTopElevaParam.Create(ParamList, -1);
    TBottomElevaParam.Create(ParamList, -1);
  end;  }
  {
  with frmSutra do
  begin
    if rbGeneral.Checked or (rbSpecific.Checked and
      (rb3D_va.Checked or rb3D_nva.Checked)) then
    begin
      TTopElevaParam.Create(ParamList, -1);
      TBottomElevaParam.Create(ParamList, -1);
    end;
  end;
  TResultantSoluteEnergySourceParam.Create(ParamList, -1);
}

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
      TResultantSoluteEnergySourceParam.Create(ParamList, -1);
    end;

  end;

end;

class function TCustomSoluteEnergySourcesLayer.WriteNewRoot: string;
begin

  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := TSoluteEnergySourcesLayer.ANE_LayerName;
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

end.
