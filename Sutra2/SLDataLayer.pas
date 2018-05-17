unit SLDataLayer;

interface

uses ANE_LayerUnit;

type
  TSutraDataParam = class(T_ANE_DataParam)
    class Function ANE_ParamName : string ; override;
  end;

  TSutraDataLayer = class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

  TSutraD3DataLayer = class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TSutraD4DataLayer = class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
  end;

implementation

ResourceString
  kDataParam = 'value1';
  kPointData = 'Point Data';
  kD3Data = 'D3 Data';
  kD4Data = 'D4 Data';
{ TSutraDataParam }

class function TSutraDataParam.ANE_ParamName: string;
begin
  result := kDataParam;
end;

{ TSutraDataLayer }

class function TSutraDataLayer.ANE_LayerName: string;
begin
  result := kPointData;
end;

constructor TSutraDataLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  TSutraDataParam.Create(ParamList, -1);
end;

{ TSutraD3DataLayer }

class function TSutraD3DataLayer.ANE_LayerName: string;
begin
  result := kD3Data
end;


{ TSutraD4DataLayer }

class function TSutraD4DataLayer.ANE_LayerName: string;
begin
  result := kD4Data;
end;

end.
