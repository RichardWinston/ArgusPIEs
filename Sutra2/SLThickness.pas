unit SLThickness;

interface

uses ANE_LayerUnit;

type
  TThicknessParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TThicknessLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

implementation

ResourceString
  kThicknessParam = 'thickness';
  kThicknessLayer = 'Thickness';

{ TThicknessParam }

class function TThicknessParam.ANE_ParamName: string;
begin
  result := kThicknessParam;
end;

function TThicknessParam.Units: string;
begin
  Result := 'L';
end;

function TThicknessParam.Value: string;
begin
  result := '1';
end;

{ TThicknessLayer }

class function TThicknessLayer.ANE_LayerName: string;
begin
  result := kThicknessLayer;
end;

constructor TThicknessLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  TThicknessParam.Create(ParamList, -1);
end;

end.
