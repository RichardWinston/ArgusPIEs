unit Mt3dMolecularDiffusion;

interface

uses SysUtils, ANE_LayerUnit;

type
  TCustomMolecularDiffusionParameter = class(T_ANE_LayerParam)
    function Value : string; override;
    function Units : string; override;
  end;

  TMolDiffAParam = class(TCustomMolecularDiffusionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TMolDiffBParam = class(TCustomMolecularDiffusionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TMolDiffCParam = class(TCustomMolecularDiffusionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TMolDiffDParam = class(TCustomMolecularDiffusionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TMolDiffEParam = class(TCustomMolecularDiffusionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DMolecularDiffusionLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

implementation

uses Variables;

Const
  kMolecularDiffusion = 'Molecular Diffusion_';
  kMolecularDiffusionUnit = 'MT3D Molecular Diffusion Unit';

{ TCustomMolecularDiffusionParameter }

function TCustomMolecularDiffusionParameter.Units: string;
begin
  result := LengthUnit + '^2/' + TimeUnit;
end;

function TCustomMolecularDiffusionParameter.Value: string;
begin
  result := '0';
end;

{ TMolDiffAParam }

class function TMolDiffAParam.ANE_ParamName: string;
begin
  result := kMolecularDiffusion + 'A';
end;

{ TMolDiffBParam }

class function TMolDiffBParam.ANE_ParamName: string;
begin
  result := kMolecularDiffusion + 'B';
end;

{ TMolDiffCParam }

class function TMolDiffCParam.ANE_ParamName: string;
begin
  result := kMolecularDiffusion + 'C';
end;

{ TMolDiffDParam }

class function TMolDiffDParam.ANE_ParamName: string;
begin
  result := kMolecularDiffusion + 'D';
end;

{ TMolDiffEParam }

class function TMolDiffEParam.ANE_ParamName: string;
begin
  result := kMolecularDiffusion + 'E';
end;

{ TMT3DMolecularDiffusionLayer }

class function TMT3DMolecularDiffusionLayer.ANE_LayerName: string;
begin
  result := kMolecularDiffusionUnit;
end;

constructor TMT3DMolecularDiffusionLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
var
  NumMobileSpecies : integer;
begin
  inherited;
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMolDiffAParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMolDiffBParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMolDiffCParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMolDiffDParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMolDiffEParamClassType.ANE_ParamName);

  NumMobileSpecies := StrToInt(frmModflow.adeMT3DMCOMP.Text);

  ModflowTypes.GetMT3DMolDiffAParamClassType.Create(ParamList, -1);
  if NumMobileSpecies >= 2 then
  begin
    ModflowTypes.GetMT3DMolDiffBParamClassType.Create(ParamList, -1);
  end;
  if NumMobileSpecies >= 3 then
  begin
    ModflowTypes.GetMT3DMolDiffCParamClassType.Create(ParamList, -1);
  end;
  if NumMobileSpecies >= 4 then
  begin
    ModflowTypes.GetMT3DMolDiffDParamClassType.Create(ParamList, -1);
  end;
  if NumMobileSpecies >= 5 then
  begin
    ModflowTypes.GetMT3DMolDiffEParamClassType.Create(ParamList, -1);
  end;
end;

end.
