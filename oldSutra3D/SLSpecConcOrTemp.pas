unit SLSpecConcOrTemp;

interface

uses ANE_LayerUnit, AnePIE, SLCustomLayers;

type
  TSpecConcTempParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    function WriteName : string; override;
    class function WriteParamName : string; override;
  end;

  TCustomSpecConcTempLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class function WriteNewRoot : string; override;
  end;

  TVolSpecConcTempLayer = class(TCustomSpecConcTempLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

  TSpecConcTempLayer = class(TCustomSpecConcTempLayer)
    class function WriteNewRoot : string; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

  TSurfaceSpecConcTempLayer = class(TCustomSpecConcTempLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class function WriteNewRoot : string; override;
  end;

implementation

uses SLGeneralParameters, frmSutraUnit, SLGroupLayers;

ResourceString
  kSpecConcTempParam = 'specified_conc_or_temp';
  kSpecConcTempLayer = 'Specified Conc or Temp';
  kSpecConcTempLayerSurf = 'Specified Conc or Temp surfaces';

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

constructor TVolSpecConcTempLayer.Create(ALayerList: T_ANE_LayerList;
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



{ TSpecConcTempLayer }

constructor TSpecConcTempLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  if frmSutra.Is3D then
  begin
    TTopElevaParam.Create(ParamList, -1);
    TBottomElevaParam.Create(ParamList, -1);
  end;
end;

class function TSpecConcTempLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraNodeSurfaceGroupLayer.WriteNewRoot;
  end;

end;

{ TSurfaceSpecConcTempLayer }

class function TSurfaceSpecConcTempLayer.ANE_LayerName: string;
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

class function TSurfaceSpecConcTempLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := TSpecConcTempLayer.ANE_LayerName;
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
end;

{ TCustomSpecConcTempLayer }

class function TCustomSpecConcTempLayer.ANE_LayerName: string;
begin
  result := kSpecConcTempLayer;
end;

constructor TCustomSpecConcTempLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  ListOfLayerLists : T_ANE_ListOfIndexedLayerLists;
begin
  inherited;
  RenameAllParameters := True;
  Interp := leExact;

  ParamList.ParameterOrder.Add(TSpecConcTempParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTimeDependanceParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TTopElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TBottomElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TContourType.ANE_ParamName);
  ParamList.ParameterOrder.Add(TCommentParam.ANE_ParamName);

  TSpecConcTempParam.Create(ParamList, -1);
  TTimeDependanceParam.Create(ParamList, -1);
  TCommentParam.Create(ParamList, -1);

{  if frmSutra.Is3D then
  begin
    TTopElevaParam.Create(ParamList, -1);
    TBottomElevaParam.Create(ParamList, -1);
  end;      }
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

class function TCustomSpecConcTempLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := TSpecConcTempLayer.ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Specified Temperature';
      end;
    ttSolute:
      begin
        result := 'Specified Concentration';
      end;
    else
      begin
        Assert(False);
      end;
  end;

end;

end.
