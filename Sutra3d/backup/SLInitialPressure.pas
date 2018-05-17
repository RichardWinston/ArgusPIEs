unit SLInitialPressure;

interface

uses ANE_LayerUnit, AnePIE, SLCustomLayers;

type
  TInitialPressureParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function WriteName : string; override;
    class function WriteParamName : string; override;
    function Value : string ; override;
  end;

  TInitialPressureLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot : string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers;

ResourceString
  kInitPresParam = 'initial_pressure';
  kInitPresLayer = 'Initial Pressure';

{ TInitialPressureParam }

class function TInitialPressureParam.ANE_ParamName: string;
begin
  result := kInitPresParam;
end;

function TInitialPressureParam.Units: string;
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

function TInitialPressureParam.Value: string;
begin
  result := frmSutra.frmParameterValues.FramInitPres.adeProperty.Output;
end;

function TInitialPressureParam.WriteName: string;
begin
  result := WriteParamName;
end;

class function TInitialPressureParam.WriteParamName: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := TInitialPressureParam.ANE_ParamName;
      end;
    svHead:
      begin
        result := 'initial_hydraulic_head';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

{ TInitialPressureLayer }

class function TInitialPressureLayer.ANE_LayerName: string;
begin
  result := kInitPresLayer;
end;

constructor TInitialPressureLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  RenameAllParameters := True;
  TInitialPressureParam.Create(ParamList, -1);
end;

class function TInitialPressureLayer.WriteNewRoot: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := TInitialPressureLayer.ANE_LayerName;
      end;
    svHead:
      begin
        result := 'Initial Hydraulic Head';
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
