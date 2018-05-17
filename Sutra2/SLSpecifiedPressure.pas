unit SLSpecifiedPressure;

interface

uses ANE_LayerUnit, AnePIE;

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

  TSpecifiedPressureLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
    class function WriteNewRoot : string; override;
  end;

implementation

uses SLGeneralParameters, frmSutraUnit;

ResourceString
  kSpecPresParam = 'specified_pressure';
  kConcTemp = 'conc_or_temp';
  KSpecPresLayer = 'Specified Pressure';


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
  case frmSutra.TransportType of
    ttGeneral:
      begin
        result := TSpecPressureParam.ANE_ParamName;
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
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := TConcOrTempParam.ANE_ParamName;
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

{ TSpecifiedPressureLayer }

class function TSpecifiedPressureLayer.ANE_LayerName: string;
begin
  result := KSpecPresLayer;
end;

constructor TSpecifiedPressureLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  RenameAllParameters := True;
  TSpecPressureParam.Create(ParamList, -1);
  TConcOrTempParam.Create(ParamList, -1);
  TTimeDependanceParam.Create(ParamList, -1);
end;

class function TSpecifiedPressureLayer.WriteNewRoot: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := TSpecifiedPressureLayer.ANE_LayerName;
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
