unit SLUnsaturated;

interface

uses ANE_LayerUnit, SLCustomLayers;

type
  TRegionParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
    function Value: string; override;
  end;

  TUnsaturatedLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class Function WriteNewRoot : string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers, SLGeneralParameters;

ResourceString
//  kRegion = 'region';
  kRegion = 'Region Number';
{$IFDEF SutraIce}
  kUnsaturated = 'Regions for Unsat and_or Freezing';
{$ELSE}
  kUnsaturated = 'Unsaturated Properties';
{$ENDIF}

{ TRegionParam }

class function TRegionParam.ANE_ParamName: string;
begin
  result := kRegion;
end;

constructor TRegionParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TRegionParam.Value: string;
begin
  result := '1';
end;

{ TUnsaturatedLayer }

class function TUnsaturatedLayer.ANE_LayerName: string;
begin
  result := kUnsaturated;
end;

constructor TUnsaturatedLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := leExact;

  ParamList.ParameterOrder.Add(TRegionParam.ANE_ParamName);
{  ParamList.ParameterOrder.Add(TTopElevaParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TBottomElevaParam.ANE_ParamName);  }

  TRegionParam.Create(ParamList, -1);
{  if frmSutra.Is3D then
  begin
    TTopElevaParam.Create(ParamList, -1);
    TBottomElevaParam.Create(ParamList, -1);
  end;   }
end;

class function TUnsaturatedLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;

end.
