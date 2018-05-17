unit SLThickness;

interface

uses Dialogs, ANE_LayerUnit, SLCustomLayers, SLGeneralParameters;

type
  TThicknessParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    class function WriteParamName : string; override;
  end;

  TInvThicknessParam = class(TCustomInverseParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TThicknessLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot : string; override;
  end;

  TTopElevParam = class(TThicknessParam)
    class Function ANE_ParamName : string ; override;
    class function WriteParamName : string; override;
  end;

  TTopElevLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    function WriteIndex : string; override;
    function WriteOldIndex : string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers;

ResourceString
  kThicknessParam = 'thickness';
  kThicknessLayer = 'Thickness';
  kElevationParam = 'elevation bottom';
  kElevationLayer = 'Elevation Bottom';
  kTopElevationParam = 'elevation top';
  kTopElevationLayer = 'Elevation Top';
  kInvThickness = 'UString_Thickness';


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
    result := frmSutra.frmParameterValues.adeThickness.Output;
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
  ParamList.ParameterOrder.Add(TInvThicknessParam.ANE_ParamName);

  TThicknessParam.Create(ParamList, -1);
  if frmSutra.cbInverse.Checked
    or frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TInvThicknessParam.Create(ParamList, -1);
//    TInvPorosityFunctionParam.Create(ParamList, -1);
  end;
end;

class function TThicknessLayer.WriteNewRoot: string;
begin
  if not frmSutra.Is3D then
  begin
    result := inherited WriteNewRoot;
  end
  else
  begin
    result := kElevationLayer + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;

{ TTopElevParam }

class function TTopElevParam.ANE_ParamName: string;
begin
  result := kTopElevationParam;
end;

class function TTopElevParam.WriteParamName: string;
begin
  result := ANE_ParamName;
end;

{ TTopElevLayer }

class function TTopElevLayer.ANE_LayerName: string;
begin
  result := kTopElevationLayer;
end;

constructor TTopElevLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Add(TTopElevParam.ANE_ParamName);
  TTopElevParam.Create(ParamList, -1);
end;

function TTopElevLayer.WriteIndex: string;
begin
  result := '';
end;

function TTopElevLayer.WriteOldIndex: string;
begin
  result := '';
end;

{ TInvThicknessParam }

class function TInvThicknessParam.ANE_ParamName: string;
begin
  result := kInvThickness;
end;

end.
