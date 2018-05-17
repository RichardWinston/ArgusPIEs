unit SLPermeability;

interface

uses ANE_LayerUnit, AnePIE, SLCustomLayers, SLGeneralParameters;

type
  TMaxPermeabilityParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TInvMaxPermeabilityParam = class(TCustomInverseParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TMidPermeabilityParam = class(TMaxPermeabilityParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMinPermeabilityParam = class(TMaxPermeabilityParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TInvMinPermeabilityParam = class(TCustomInverseParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TPermeabilityAngleParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TInvPermeabilityAngleParam = class(TCustomInverseParameter)
    class Function ANE_ParamName : string ; override;
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
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
    class function WriteNewRoot : string; override;
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
  kInvPermMax = 'UString_Maximum';
  kInvPermMin = 'UString_Minimum';
  kInvPermAngle = 'UString_Angle';
//  kInvPermMaxFunction = 'UFunction_Maximum';
//  kInvPermMinFunction = 'UFunction_Minimum';
//  kInvPermAngleFunction = 'UFunction_Angle';

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
  result := frmSutra.frmParameterValues.FramDMaxHydCond.adeProperty.Output;
end;

{ TMinPermeabilityParam }

class function TMinPermeabilityParam.ANE_ParamName: string;
begin
  result := kMinimum;
end;

function TMinPermeabilityParam.Value: string;
begin
  result := frmSutra.frmParameterValues.FramDMinHydCond.adeProperty.Output;
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
  result := frmSutra.frmParameterValues.FramPermAngleXY.adeProperty.Output;
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

  ParamList.ParameterOrder.Add(TInvMaxPermeabilityParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvMaxPermeabilityFunctionParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvMinPermeabilityParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvMinPermeabilityFunctionParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvPermeabilityAngleParam.ANE_ParamName);
//  ParamList.ParameterOrder.Add(TInvPermeabilityAngleFunctionParam.ANE_ParamName);

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

  if frmSutra.cbInverse.Checked
    or frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TInvMaxPermeabilityParam.Create(ParamList, -1);
//    TInvMaxPermeabilityFunctionParam.Create(ParamList, -1);
    TInvMinPermeabilityParam.Create(ParamList, -1);
//    TInvMinPermeabilityFunctionParam.Create(ParamList, -1);
    if frmSutra.Is3D then
    begin
    end
    else
    begin
      TInvPermeabilityAngleParam.Create(ParamList, -1);
//      TInvPermeabilityAngleFunctionParam.Create(ParamList, -1);
    end;
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
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
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
  result := frmSutra.frmParameterValues.FramPermAngleVertical.adeProperty.Output;
end;

{ TRotPermeabilityAngleParam }

class function TRotPermeabilityAngleParam.ANE_ParamName: string;
begin
  result := kRotAngle;
end;

function TRotPermeabilityAngleParam.Value: string;
begin
  result := frmSutra.frmParameterValues.FramPermAngleRotational.adeProperty.Output;
end;

{ TMidPermeabilityParam }

class function TMidPermeabilityParam.ANE_ParamName: string;
begin
  result := kMiddle;
end;

function TMidPermeabilityParam.Value: string;
begin
  result := frmSutra.frmParameterValues.FramDMidHydCond.adeProperty.Output;
end;

{ TInvMaxPermeabilityParam }

class function TInvMaxPermeabilityParam.ANE_ParamName: string;
begin
  result := kInvPermMax;
end;

{ TInvMinPermeabilityParam }

class function TInvMinPermeabilityParam.ANE_ParamName: string;
begin
  result := kInvPermMin;
end;

{ TInvPermeabilityAngleParam }

class function TInvPermeabilityAngleParam.ANE_ParamName: string;
begin
  result := kInvPermAngle;
end;

{ TInvMaxPermeabilityFunctionParam }

//class function TInvMaxPermeabilityFunctionParam.ANE_ParamName: string;
//begin
//  result := kInvPermMaxFunction;
//end;

{ TInvMinPermeabilityFunctionParam }

//class function TInvMinPermeabilityFunctionParam.ANE_ParamName: string;
//begin
//  result := kInvPermMinFunction;
//end;


{ TInvPermeabilityAngleFunctionParam }

//class function TInvPermeabilityAngleFunctionParam.ANE_ParamName: string;
//begin
//  result := kInvPermAngleFunction;
//end;

end.
