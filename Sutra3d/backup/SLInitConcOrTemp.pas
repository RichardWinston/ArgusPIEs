unit SLInitConcOrTemp;

interface

uses ANE_LayerUnit, AnePIE, SLCustomLayers;

type
  TInitialConcTempParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    class function WriteParamName: string; override;
    function Value : string ; override;
  end;

  TInitialConcTempLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot : string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers;

ResourceString
  kInitConcTempParam = 'initial_conc_or_temp';
  kInitConcTempLayer = 'Initial Conc or Temp';


{ TInitialConcTempParam }

class function TInitialConcTempParam.ANE_ParamName: string;
begin
  result := kInitConcTempParam;
end;

function TInitialConcTempParam.Units: string;
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

function TInitialConcTempParam.Value: string;
begin
  result := frmSutra.frmParameterValues.FramInitTempConc.adeProperty.Output;
end;

class function TInitialConcTempParam.WriteParamName: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := ANE_ParamName;
      end;
    ttEnergy:
      begin
        result := 'initial_temperature';
      end;
    ttSolute:
      begin
        result := 'initial_concentration';
      end;
    else
      begin
        Assert(False);
      end;
  end;
end;


{ TInitialConcTempLayer }

class function TInitialConcTempLayer.ANE_LayerName: string;
begin
  result := kInitConcTempLayer
end;

constructor TInitialConcTempLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  RenameAllParameters := True;
  TInitialConcTempParam.Create(ParamList,-1);
end;

class function TInitialConcTempLayer.WriteNewRoot: string;
begin
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := TInitialConcTempLayer.ANE_LayerName;
      end;
    ttEnergy:
      begin
        result := 'Initial Temperature';
      end;
    ttSolute:
      begin
        result := 'Initial Concentration';
      end;
    else
      begin
        Assert(False);
      end;
  end;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;

end.
 