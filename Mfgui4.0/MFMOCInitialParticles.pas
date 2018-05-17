unit MFMOCInitialParticles;

interface

{
  MFMOCInitialParticles defines the layers and parameters used to specify
  the input for the Initial Particle Density File-Array-Based Input Format
  (IPDA) in the Groundwater Transport Process.
}

uses ANE_LayerUnit;

type
  TRowCountParam = class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TLayerCountParam = class(TRowCountParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TColumnCountParam = class(TRowCountParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMOCInitialParticlePlacementLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer = -1); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

resourcestring
  rsLayerCount = 'Layer Count';
  rsRowCount = 'Row Count';
  rsColumnCount = 'Column Count';
  rsInitParticlePlacement = 'Initial Particle Placement Unit';


{ TRowCountParam }

class function TRowCountParam.ANE_ParamName: string;
begin
  result := rsRowCount;
end;

constructor TRowCountParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TRowCountParam.Units: string;
begin
  result := '>= 1';
end;

function TRowCountParam.Value: string;
begin
  result := '1';
end;

{ TLayerCountParam }

class function TLayerCountParam.ANE_ParamName: string;
begin
  result := rsLayerCount;
end;

function TLayerCountParam.Units: string;
begin
  if frmModflow.comboSpecifyParticles.ItemIndex = 1 then
  begin
    result := inherited Units;
  end
  else
  begin
    result := '<0 or >0';
  end;
end;

{ TColumnCountParam }

class function TColumnCountParam.ANE_ParamName: string;
begin
  result := rsColumnCount;
end;

{ TMOCInitialParticlePlacementLayer }

class function TMOCInitialParticlePlacementLayer.ANE_LayerName: string;
begin
  result := rsInitParticlePlacement;
end;

constructor TMOCInitialParticlePlacementLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer = -1);
begin
  inherited;
  Interp := leExact;
  ModflowTypes.GetMFColumnCountParamType.Create(ParamList);
  ModflowTypes.GetMFRowCountParamType.Create(ParamList);
  ModflowTypes.GetMFLayerCountParamType.Create(ParamList);
end;

function TMOCInitialParticlePlacementLayer.Units: string;
begin
  result := '>= 1'
end;

end.
