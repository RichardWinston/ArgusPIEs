unit SLSpecifiedPressure;

interface

uses ANE_LayerUnit, AnePIE, SLCustomLayers;

type
  TSpecPressureParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    function WriteName : string; override;
    class function WriteParamName : string; override;
  end;

  TConcOrTempParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    function WriteName : string; override;
    class function WriteParamName : string; override;
  end;

  TCustomSpecifiedPressureLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class function WriteNewRoot : string; override;
  end;

  TVolSpecifiedPressureLayer = class(TCustomSpecifiedPressureLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

  TSpecifiedPressureLayer = class(TCustomSpecifiedPressureLayer)
    class function WriteNewRoot : string; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

  TSpecifiedPressureSurfaceLayer = class(TCustomSpecifiedPressureLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class function WriteNewRoot : string; override;
  end;

implementation

uses SLGeneralParameters, frmSutraUnit, SLGroupLayers;

ResourceString
  kSpecPresParam = 'specified_pressure';
  kConcTemp = 'conc_or_temp';
  KSpecPresLayer = 'Specified Pressure';
  KSpecPresLayerSurface = 'Specified Pressure surfaces';


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

constructor TVolSpecifiedPressureLayer.Create(ALayerList: T_ANE_LayerList;
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

{ TSpecifiedPressureSurfaceLayer }

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
end;

{ TSpecifiedPressureLayer }

constructor TSpecifiedPressureLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  if frmSutra.Is3D then
  begin
    TTopElevaParam.Create(ParamList, -1);
    TBottomElevaParam.Create(ParamList, -1);
  end;  

end;

class function TSpecifiedPressureLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraNodeSurfaceGroupLayer.WriteNewRoot;
  end;


end;

{ TCustomSpecifiedPressureLayer }

class function TCustomSpecifiedPressureLayer.ANE_LayerName: string;
begin
  result := KSpecPresLayer;
end;

constructor TCustomSpecifiedPressureLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  ListOfLayerLists : T_ANE_ListOfIndexedLayerLists;
begin
  inherited;
  RenameAllParameters := True;
  Interp := leExact;

  ParamList.ParameterOrder.Add(TSpecPressureParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TConcOrTempParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDependanceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTopElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TBottomElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TContourType.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCommentParam.ANE_ParamName);

  TSpecPressureParam.Create(ParamList, -1);
  TConcOrTempParam.Create(ParamList, -1);
  TTimeDependanceParam.Create(ParamList, -1);
  TCommentParam.Create(ParamList, -1);

{  if frmSutra.Is3D then
  begin
    TTopElevaParam.Create(ParamList, -1);
    TBottomElevaParam.Create(ParamList, -1);
  end;  }
  with frmSutra do
  begin

    if ALayerList.Owner is T_ANE_ListOfIndexedLayerLists then
    begin
      ListOfLayerLists := T_ANE_ListOfIndexedLayerLists(ALayerList.Owner);
      if (ALayerList.Owner =
        ListOfLayerLists.Owner.FirstListsOfIndexedLayers)
        and Is3D then
      begin
        TContourType.Create(ParamList, -1);
      end;
    end;

  end;

end;

class function TCustomSpecifiedPressureLayer.WriteNewRoot: string;
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

end.
