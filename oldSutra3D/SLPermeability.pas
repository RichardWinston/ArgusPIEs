unit SLPermeability;

interface

uses ANE_LayerUnit, AnePIE, SLCustomLayers;

type
  TMaxPermeabilityParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMidPermeabilityParam = class(TMaxPermeabilityParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMinPermeabilityParam = class(TMaxPermeabilityParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TPermeabilityAngleParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  THorizPermeabilityAngleParam = class(TPermeabilityAngleParam)
    class Function ANE_ParamName : string ; override;
  end;

  TVertPermeabilityAngleParam = class(TPermeabilityAngleParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TRotPermeabilityAngleParam = class(TPermeabilityAngleParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TPermeabilityLayer = class(TSutraInfoLayer)
//    OldName : string;
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
//    function WriteLayer(const CurrentModelHandle : ANE_PTR) : string; override;
    class function WriteNewRoot : string; override;
//    function WriteOldLayerName : string; override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers;

ResourceString
  kMaximum = 'maximum';
  kMiddle = 'middle';
  kMinimum = 'minimum';
  kAngle = 'angle_of_max_to_x_axis';
  kPermeability = 'Permeability';
  kHorizAngle = 'horizontal angle';
  kVertAngle = 'vertical angle';
  kRotAngle = 'rotational angle';

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
  result := frmSutra.FramDMaxHydCond.adeProperty.Text;
end;

{ TMinPermeabilityParam }

class function TMinPermeabilityParam.ANE_ParamName: string;
begin
  result := kMinimum;
end;

function TMinPermeabilityParam.Value: string;
begin
  result := frmSutra.FramDMinHydCond.adeProperty.Text;
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


function TPermeabilityAngleParam.Value: string;
begin
  result := frmSutra.FramPermAngleXY.adeProperty.Text;
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
  ParamList.ParameterOrder.Add(TMaxPermeabilityParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TMidPermeabilityParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TMinPermeabilityParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TPermeabilityAngleParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(THorizPermeabilityAngleParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TVertPermeabilityAngleParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TRotPermeabilityAngleParam.ANE_ParamName);

  TMaxPermeabilityParam.Create(ParamList, -1);
  if frmSutra.Is3D then
  begin
    TMidPermeabilityParam.Create(ParamList, -1);
  end;
  TMinPermeabilityParam.Create(ParamList, -1);
  if frmSutra.Is3D then
  begin
    THorizPermeabilityAngleParam.Create(ParamList, -1);
    TVertPermeabilityAngleParam.Create(ParamList, -1);
    TRotPermeabilityAngleParam.Create(ParamList, -1);
  end
  else
  begin
    TPermeabilityAngleParam.Create(ParamList, -1);
  end;
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
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraNodeSurfaceGroupLayer.WriteNewRoot;
  end;
end;


{ THorizPermeabilityAngleParam }

class function THorizPermeabilityAngleParam.ANE_ParamName: string;
begin
  result := kHorizAngle;
end;


{ TVertPermeabilityAngleParam }

class function TVertPermeabilityAngleParam.ANE_ParamName: string;
begin
  result := kVertAngle;
end;

function TVertPermeabilityAngleParam.Value: string;
begin
  result := frmSutra.FramPermAngleVertical.adeProperty.Text;
end;

{ TRotPermeabilityAngleParam }

class function TRotPermeabilityAngleParam.ANE_ParamName: string;
begin
  result := kRotAngle;
end;

function TRotPermeabilityAngleParam.Value: string;
begin
  result := frmSutra.FramPermAngleRotational.adeProperty.Text;
end;

{ TMidPermeabilityParam }

class function TMidPermeabilityParam.ANE_ParamName: string;
begin
  result := kMiddle;
end;

function TMidPermeabilityParam.Value: string;
begin
  result := frmSutra.FramDMidHydCond.adeProperty.Text;
end;

end.
