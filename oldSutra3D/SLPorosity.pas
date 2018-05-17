unit SLPorosity;

interface

uses ANE_LayerUnit, SLCustomLayers;

type
  TPorosityParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TPorosityLayer = class(TSutraInfoLayer)
    class Function ANE_LayerName : string ; override;
    class Function WriteNewRoot : string; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

implementation

uses frmSutraUnit, SLGroupLayers;

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
//  result := '0.1';
  result := frmSutra.FramPor.adeProperty.Text;
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

class function TPorosityLayer.WriteNewRoot: string;
begin
  result := inherited WriteNewRoot;
  if frmSutra.Is3D then
  begin
    result := result + ' ' + TSutraNodeSurfaceGroupLayer.WriteNewRoot;
  end;
end;

end.
