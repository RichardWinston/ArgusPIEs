unit MFMOCTransSubgrid;

interface

{MFMOCTransSubgrid defines the "MOC3D Transport Subgrid" layer
 and the associated parameter.}

uses ANE_LayerUnit;

type
  TMOCTransSubGridParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Units : string; override;
  end;

  TMOCTransSubGridLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

resourceString
  rsMOCTransSubGrid = 'MOC3D Transport Subgrid';

{ TMOCTransSubGridParam }

class function TMOCTransSubGridParam.ANE_ParamName: string;
begin
  result := rsMOCTransSubGrid;
end;

constructor TMOCTransSubGridParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger
end;

function TMOCTransSubGridParam.Units: string;
begin
  result := '';
end;

{ TMOCTransSubGridLayer }

class function TMOCTransSubGridLayer.ANE_LayerName: string;
begin
  result := rsMOCTransSubGrid;
end;

constructor TMOCTransSubGridLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ModflowTypes.GetMFMOCTransSubGridParamType.Create(ParamList, -1);

end;

function TMOCTransSubGridLayer.Units: string;
begin
  result := '';
end;

end.
