unit SLUnsaturated;

interface

uses ANE_LayerUnit;

type
  TRegionParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

  TUnsaturatedLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

implementation

ResourceString
  kRegion = 'region';
  kUnsaturated = 'Unsaturated Properties';

{ TRegionParam }

class function TRegionParam.ANE_ParamName: string;
begin
  result := kRegion;
end;

constructor TRegionParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

{ TUnsaturatedLayer }

class function TUnsaturatedLayer.ANE_LayerName: string;
begin
  result := kUnsaturated;
end;

constructor TUnsaturatedLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := leExact;

  TRegionParam.Create(ParamList, -1);
end;

end.
