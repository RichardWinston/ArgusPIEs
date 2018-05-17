unit SLPorosity;

interface

uses ANE_LayerUnit;

type
  TPorosityParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TPorosityLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

implementation

ResourceString
  kPorosityParam = 'porosity';
  kPorosityLayer = 'Porosity';

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
  result := '0.1';
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
  TPorosityParam.Create(ParamList, -1);
end;

end.
