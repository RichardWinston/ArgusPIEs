unit MT3DReaction;

interface

uses SysUtils, ANE_LayerUnit;

type
  TCustomReactionParameter = class(T_ANE_LayerParam)
    function Value : string; override;
    function Units : string; override;
  end;

  TRC1AParam = class(TCustomReactionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TRC1BParam = class(TCustomReactionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TRC1CParam = class(TCustomReactionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TRC1DParam = class(TCustomReactionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TRC1EParam = class(TCustomReactionParameter)
    class Function ANE_ParamName : string ; override;
  end;

  TRC2AParam = class(TCustomReactionParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TRC2BParam = class(TCustomReactionParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TRC2CParam = class(TCustomReactionParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TRC2DParam = class(TCustomReactionParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TRC2EParam = class(TCustomReactionParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMT3DReactionLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList;
      Index: Integer = -1); override;
  end;

implementation

uses Variables;

resourcestring
  rsRC1 = 'RC1_';
  rsRC2 = 'RC2_';
  rsSorption = 'MT3D Reaction Parameters Unit';

{ TCustomReactionParameter }

function TCustomReactionParameter.Units: string;
begin
  result := '1/' + TimeUnit;
end;

function TCustomReactionParameter.Value: string;
begin
  result := '1e-6';
end;

{ TRC1AParam }

class function TRC1AParam.ANE_ParamName: string;
begin
  result := rsRC1 + 'A';
end;

{ TRC1BParam }

class function TRC1BParam.ANE_ParamName: string;
begin
  result := rsRC1 + 'B';
end;

{ TRC1CParam }

class function TRC1CParam.ANE_ParamName: string;
begin
  result := rsRC1 + 'C';
end;

{ TRC1DParam }

class function TRC1DParam.ANE_ParamName: string;
begin
  result := rsRC1 + 'D';
end;

{ TRC1EParam }

class function TRC1EParam.ANE_ParamName: string;
begin
  result := rsRC1 + 'E';
end;

{ TRC2AParam }

class function TRC2AParam.ANE_ParamName: string;
begin
  result := rsRC2 + 'A';
end;

function TRC2AParam.Value: string;
begin
  result := ModflowTypes.GetMT3DRC1AParamClassType.ANE_ParamName;
end;

{ TRC2BParam }

class function TRC2BParam.ANE_ParamName: string;
begin
  result := rsRC2 + 'B';
end;

function TRC2BParam.Value: string;
begin
  result := ModflowTypes.GetMT3DRC1BParamClassType.ANE_ParamName;
end;

{ TRC2CParam }

class function TRC2CParam.ANE_ParamName: string;
begin
  result := rsRC2 + 'C';
end;

function TRC2CParam.Value: string;
begin
  result := ModflowTypes.GetMT3DRC1CParamClassType.ANE_ParamName;
end;

{ TRC2DParam }

class function TRC2DParam.ANE_ParamName: string;
begin
  result := rsRC2 + 'D';
end;

function TRC2DParam.Value: string;
begin
  result := ModflowTypes.GetMT3DRC1DParamClassType.ANE_ParamName;
end;

{ TRC2EParam }

class function TRC2EParam.ANE_ParamName: string;
begin
  result := rsRC2 + 'E';
end;

function TRC2EParam.Value: string;
begin
  result := ModflowTypes.GetMT3DRC1EParamClassType.ANE_ParamName;
end;

{ TMT3DReactionLayer }

class function TMT3DReactionLayer.ANE_LayerName: string;
begin
  result := rsSorption;
end;

constructor TMT3DReactionLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  NumSpecies : integer;
begin
  inherited;
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DRC1AParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DRC2AParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DRC1BParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DRC2BParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DRC1CParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DRC2CParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DRC1DParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DRC2DParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DRC1EParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DRC2EParamClassType.ANE_ParamName);

  NumSpecies := StrToInt(frmModflow.adeMT3DNCOMP.Text);

  ModflowTypes.GetMT3DRC1AParamClassType.Create(ParamList, -1);
  if NumSpecies >= 2 then
  begin
    ModflowTypes.GetMT3DRC1BParamClassType.Create(ParamList, -1);
  end;
  if NumSpecies >= 3 then
  begin
    ModflowTypes.GetMT3DRC1CParamClassType.Create(ParamList, -1);
  end;
  if NumSpecies >= 4 then
  begin
    ModflowTypes.GetMT3DRC1DParamClassType.Create(ParamList, -1);
  end;
  if NumSpecies >= 5 then
  begin
    ModflowTypes.GetMT3DRC1EParamClassType.Create(ParamList, -1);
  end;

  if (frmModflow.comboMT3DIsotherm.ItemIndex > 0)
    and (frmModflow.comboMT3DIsotherm.ItemIndex <> 5) then
  begin
    ModflowTypes.GetMT3DRC2AParamClassType.Create(ParamList, -1);
    if NumSpecies >= 2 then
    begin
      ModflowTypes.GetMT3DRC2BParamClassType.Create(ParamList, -1);
    end;
    if NumSpecies >= 3 then
    begin
      ModflowTypes.GetMT3DRC2CParamClassType.Create(ParamList, -1);
    end;
    if NumSpecies >= 4 then
    begin
      ModflowTypes.GetMT3DRC2DParamClassType.Create(ParamList, -1);
    end;
    if NumSpecies >= 5 then
    begin
      ModflowTypes.GetMT3DRC2EParamClassType.Create(ParamList, -1);
    end;
  end;


end;

end.
