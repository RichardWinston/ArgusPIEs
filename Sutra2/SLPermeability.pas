unit SLPermeability;

interface

uses ANE_LayerUnit, AnePIE;

type
  TMaxPermeabilityParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMinPermeabilityParam = class(TMaxPermeabilityParam)
    class Function ANE_ParamName : string ; override;
  end;

  TPermeabilityAngleParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TPermeabilityLayer = class(T_ANE_InfoLayer)
//    OldName : string;
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
//    function WriteLayer(const CurrentModelHandle : ANE_PTR) : string; override;
    class function WriteNewRoot : string; override;
//    function WriteOldLayerName : string; override;
  end;

implementation

uses frmSutraUnit;

ResourceString
  kMaximum = 'maximum';
  kMinimum = 'minimum';
  kAngle = 'angle_of_max_to_x_axis';
  kPermeability = 'Permeability';

{ TMaxPermeabilityParam }

class function TMaxPermeabilityParam.ANE_ParamName: string;
begin
  result := kMaximum;
end;

function TMaxPermeabilityParam.Units: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := 'L^2'
      end;
    svHead:
      begin
        result := 'L/s'
      end;
  else
    begin
      Assert(False);
    end;
  end;

end;

function TMaxPermeabilityParam.Value: string;
begin
  result := '1.0E-10';
end;

{ TMinPermeabilityParam }

class function TMinPermeabilityParam.ANE_ParamName: string;
begin
  result := kMinimum;
end;

{ TPermeabilityAngleParam }

class function TPermeabilityAngleParam.ANE_ParamName: string;
begin
  result := kAngle;
end;

function TPermeabilityAngleParam.Units: string;
begin
  result := 'degrees'
end;


{ TPermeabilityLayer }

class function TPermeabilityLayer.ANE_LayerName: string;
begin
  result := kPermeability;
end;

constructor TPermeabilityLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  TMaxPermeabilityParam.Create(ParamList, -1);
  TMinPermeabilityParam.Create(ParamList, -1);
  TPermeabilityAngleParam.Create(ParamList, -1);
end;


class function TPermeabilityLayer.WriteNewRoot: string;
begin
  case frmSutra.StateVariableType of
    svPressure:
      begin
        result := TPermeabilityLayer.ANE_LayerName;
      end;
    svHead:
      begin
        result := 'Hydraulic Conductivity';
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;


end.
