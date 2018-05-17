unit MF_HUF;

interface

uses ANE_LayerUnit;

type
  THUFTopParameter = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  THUFThicknessParameter = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  THUFLayer = Class(T_ANE_NamedInfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(LayerName: string; ALayerList : T_ANE_LayerList;
      Index: Integer = -1); override;
    Procedure Rename(const NewName : string);
    function Units : string; override;
  end;


implementation

uses Variables;

resourcestring
  kHufLayer = 'HUF Geologic Unit';
  kHufTop = 'Top';
  kHufThickness = 'Thickness';

{ THUFTopParameter }

class function THUFTopParameter.ANE_ParamName: string;
begin
  result := kHufTop;
end;

function THUFTopParameter.Units: string;
begin
  result := LengthUnit
end;

{ THUFThicknessParameter }

class function THUFThicknessParameter.ANE_ParamName: string;
begin
  result := kHufThickness;
end;

function THUFThicknessParameter.Units: string;
begin
  result := LengthUnit
end;

{ THUFLayer }

class function THUFLayer.ANE_LayerName: string;
begin
  result := kHufLayer;
end;

constructor THUFLayer.Create(LayerName: string;
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited;
  ModflowTypes.GetMFHUFTopParamType.Create( ParamList, -1);
  ModflowTypes.GetMFHUFThicknessParamType.Create( ParamList, -1);
  Interp := le624;
end;

procedure THUFLayer.Rename(const NewName: string);
begin
  FName := NewName;
end;

function THUFLayer.Units: string;
begin
  result := LengthUnit
end;

end.
