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

  TSutraNodeDataLayer = class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
//    class function WriteNewRoot : string; override;
  end;

  TSutraElementDataLayer = class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
//    class function WriteNewRoot : string; override;
  end;

implementation

//uses PostNamesUnit;

ResourceString
  kDataParam = 'value1';
  kPointData = 'Point Data';
  kD3Data = 'node Data';
  kD4Data = 'element Data';
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

{ TSutraNodeDataLayer }

class function TSutraNodeDataLayer.ANE_LayerName: string;
begin
  result := kD3Data
end;


{class function TSutraNodeDataLayer.WriteNewRoot: string;
begin
  if NodeDataLayerName = '' then
  begin
    result := inherited WriteNewRoot;
  end
  else
  begin
    result := NodeDataLayerName;
  end
end; }

{ TSutraElementDataLayer }

class function TSutraElementDataLayer.ANE_LayerName: string;
begin
  result := kD4Data;
end;

{class function TSutraElementDataLayer.WriteNewRoot: string;
begin
  if ElementDataLayerName = '' then
  begin
    result := inherited WriteNewRoot;
  end
  else
  begin
    result := ElementDataLayerName;
  end
end;  }

end.
