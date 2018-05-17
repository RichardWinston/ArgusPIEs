unit MT3DSorption;

interface

uses SysUtils, ANE_LayerUnit;

type
  TCustomSorptionParameter = class(T_ANE_LayerParam)
    function Value : string; override;
  end;

  TSP1AParam = class(TCustomSorptionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TSP1BParam = class(TCustomSorptionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TSP1CParam = class(TCustomSorptionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TSP1DParam = class(TCustomSorptionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TSP1EParam = class(TCustomSorptionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TSP2AParam = class(TCustomSorptionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TSP2BParam = class(TCustomSorptionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TSP2CParam = class(TCustomSorptionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TSP2DParam = class(TCustomSorptionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TSP2EParam = class(TCustomSorptionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DSorptionLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

implementation

uses Variables;

resourcestring
  rsSP1 = 'SP1_';
  rsSP2 = 'SP2_';
  rsSorption = 'MT3D Sorption Parameters Unit';

{ TCustomSorptionParameter }

function TCustomSorptionParameter.Value: string;
begin
  result := '1';
end;

{ TSP1AParam }

class function TSP1AParam.ANE_ParamName: string;
begin
  result := rsSP1 + 'A';
end;

{ TSP1BParam }

class function TSP1BParam.ANE_ParamName: string;
begin
  result := rsSP1 + 'B';
end;

{ TSP1CParam }

class function TSP1CParam.ANE_ParamName: string;
begin
  result := rsSP1 + 'C';
end;

{ TSP1DParam }

class function TSP1DParam.ANE_ParamName: string;
begin
  result := rsSP1 + 'D';
end;

{ TSP1EParam }

class function TSP1EParam.ANE_ParamName: string;
begin
  result := rsSP1 + 'E';
end;

{ TSP2AParam }

class function TSP2AParam.ANE_ParamName: string;
begin
  result := rsSP2 + 'A';
end;

{ TSP2BParam }

class function TSP2BParam.ANE_ParamName: string;
begin
  result := rsSP2 + 'B';
end;

{ TSP2CParam }

class function TSP2CParam.ANE_ParamName: string;
begin
  result := rsSP2 + 'C';
end;

{ TSP2DParam }

class function TSP2DParam.ANE_ParamName: string;
begin
  result := rsSP2 + 'D';
end;

{ TSP2EParam }

class function TSP2EParam.ANE_ParamName: string;
begin
  result := rsSP2 + 'E';
end;

{ TMT3DSorptionLayer }

class function TMT3DSorptionLayer.ANE_LayerName: string;
begin
  result := rsSorption;
end;

constructor TMT3DSorptionLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  NumSpecies : integer;
begin
  inherited;
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSP1AParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSP2AParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSP1BParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSP2BParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSP1CParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSP2CParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSP1DParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSP2DParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSP1EParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSP2EParamClassType.ANE_ParamName);

  NumSpecies := StrToInt(frmModflow.adeMT3DNCOMP.Text);

  ModflowTypes.GetMT3DSP1AParamClassType.Create(ParamList, -1);
  if NumSpecies >= 2 then
  begin
    ModflowTypes.GetMT3DSP1BParamClassType.Create(ParamList, -1);
  end;
  if NumSpecies >= 3 then
  begin
    ModflowTypes.GetMT3DSP1CParamClassType.Create(ParamList, -1);
  end;
  if NumSpecies >= 4 then
  begin
    ModflowTypes.GetMT3DSP1DParamClassType.Create(ParamList, -1);
  end;
  if NumSpecies >= 5 then
  begin
    ModflowTypes.GetMT3DSP1EParamClassType.Create(ParamList, -1);
  end;

  if frmModflow.comboMT3DIsotherm.ItemIndex > 0 then
  begin
    ModflowTypes.GetMT3DSP2AParamClassType.Create(ParamList, -1);
    if NumSpecies >= 2 then
    begin
      ModflowTypes.GetMT3DSP2BParamClassType.Create(ParamList, -1);
    end;
    if NumSpecies >= 3 then
    begin
      ModflowTypes.GetMT3DSP2CParamClassType.Create(ParamList, -1);
    end;
    if NumSpecies >= 4 then
    begin
      ModflowTypes.GetMT3DSP2DParamClassType.Create(ParamList, -1);
    end;
    if NumSpecies >= 5 then
    begin
      ModflowTypes.GetMT3DSP2EParamClassType.Create(ParamList, -1);
    end;
  end;


end;

end.
