unit SLDispersivity;

interface

uses ANE_LayerUnit;

type
  TMaxLongDispParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMinLongDispParam = class(TMaxLongDispParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMaxTransDispParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMinTransDispParam = class(TMaxTransDispParam)
    class Function ANE_ParamName : string ; override;
  end;

  TDispersivityLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;

implementation

ResourceString
  kMaxLongDisp = 'longdisp_in_max_permdir';
  kMinLongDisp = 'longdisp_in_min_permdir';
  kMaxTransDisp = 'trandisp_in_max_permdir';
  kMinTransDisp = 'trandisp_in_min_permdir';
  kDispersivity = 'Dispersivity';

{ TMaxLongDispParam }

class function TMaxLongDispParam.ANE_ParamName: string;
begin
  result := kMaxLongDisp;
end;

function TMaxLongDispParam.Units: string;
begin
  Result := 'L';
end;

function TMaxLongDispParam.Value: string;
begin
  result := '0.1';
end;

{ TMinLongDispParam }

class function TMinLongDispParam.ANE_ParamName: string;
begin
  result := kMinLongDisp;
end;

{ TMaxTransDispParam }

class function TMaxTransDispParam.ANE_ParamName: string;
begin
  result := kMaxTransDisp;
end;

function TMaxTransDispParam.Units: string;
begin
  result := 'L';
end;

function TMaxTransDispParam.Value: string;
begin
  result := '0.1';
end;

{ TMinTransDispParam }

class function TMinTransDispParam.ANE_ParamName: string;
begin
  result := kMinTransDisp;
end;

{ TDispersivityLayer }

class function TDispersivityLayer.ANE_LayerName: string;
begin
  result := kDispersivity
end;

constructor TDispersivityLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  TMaxLongDispParam.Create(ParamList, -1);
  TMinLongDispParam.Create(ParamList, -1);
  TMaxTransDispParam.Create(ParamList, -1);
  TMinTransDispParam.Create(ParamList, -1);
end;

end.
