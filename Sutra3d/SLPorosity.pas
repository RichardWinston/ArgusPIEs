unit SLPorosity;

interface

uses ANE_LayerUnit, SLCustomLayers, SLGeneralParameters;

type
  TPorosityParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TInvPorosityParam = class(TCustomInverseParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TPorosityLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    class Function WriteNewRoot : string; override;
    constructor Create(ALayerList: T_ANE_LayerList;
      Index: Integer = -1); override;
  end;


implementation

uses frmSutraUnit, SLGroupLayers;

ResourceString
  kPorosityParam = 'porosity';
  kPorosityLayer = 'Porosity';
  kInvPorosity = 'UString_Porosity';
//  kInvPorosityFunction = 'UFunction_Porosity';

{ TPorosityParam }

class function TPorosityParam.ANE_ParamName: string;
begin
  result := kPorosityParam;
end;

function TPorosityParam.Units: string;
begin
  result := 'fraction';
end;

function TPorosityParam.Value: string;
begin
//  result := '0.1';
  result := frmSutra.frmParameterValues.FramPor.adeProperty.Output;
end;

{ TPorosityLayer }

class function TPorosityLayer.ANE_LayerName: string;
begin
  result := kPorosityLayer;
end;

constructor TPorosityLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Add(TPorosityParam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TInvPorosityParam.ANE_ParamName);

  TPorosityParam.Create(ParamList, -1);
  if frmSutra.cbInverse.Checked
    or frmSutra.cbPreserveInverseModelParameters.Checked then
  begin
    TInvPorosityParam.Create(ParamList, -1);
  end;

end;

class function TPorosityLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraUnitGroupLayer.UpperLowerName;
  end;
end;

{ TInvPorosityParam }

class function TInvPorosityParam.ANE_ParamName: string;
begin
  result := kInvPorosity;
end;

{ TInvPorosityFunctionParam }

//class function TInvPorosityFunctionParam.ANE_ParamName: string;
//begin
//  result := kInvPorosityFunction;
//end;

end.
