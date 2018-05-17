unit SLThickness;

interface

uses Dialogs, ANE_LayerUnit, SLCustomLayers;

type
  TThicknessParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    class function WriteParamName : string; override;
  end;

  TThicknessLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class function WriteNewRoot : string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers;

ResourceString
  kThicknessParam = 'thickness';
  kThicknessLayer = 'Thickness';
  kElevationParam = 'elevation';
  kElevationLayer = 'Elevation';

{ TThicknessParam }

class function TThicknessParam.ANE_ParamName: string;
begin
  result := kThicknessParam;
end;

function TThicknessParam.Units: string;
begin
  Result := 'L';
end;

function TThicknessParam.Value: string;
begin
  if frmSutra.Is3D then
  begin
    result := '0';
  end
  else
  begin
    result := frmSutra.adeThickness.Text;
  end;
end;

class function TThicknessParam.WriteParamName: string;
begin
  if frmSutra.Is3D then
  begin
    result := kElevationParam;
  end
  else
  begin
    result := inherited WriteParamName;
  end;
end;

{ TThicknessLayer }

class function TThicknessLayer.ANE_LayerName: string;
begin
  result := kThicknessLayer;
end;

constructor TThicknessLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Add(TThicknessParam.ANE_ParamName);
  TThicknessParam.Create(ParamList, -1);
end;

class function TThicknessLayer.WriteNewRoot: string;
begin
  if not frmSutra.Is3D then
  begin
    result := inherited WriteNewRoot;
  end
  else
  begin
    result := kElevationLayer + ' ' + TSutraNodeSurfaceGroupLayer.WriteNewRoot;
  end;
end;

end.
