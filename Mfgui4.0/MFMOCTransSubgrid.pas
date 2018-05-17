unit MFMOCTransSubgrid;

interface

{MFMOCTransSubgrid defines the "MOC3D Transport Subgrid" layer
 and the associated parameter.}

uses ANE_LayerUnit;

type
  TMOCTransSubGridParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    class function WriteParamName : string; override;
  end;

  TMOCTransSubGridLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    class function WriteNewRoot: string; override;
    function Units : string; override;
  end;

implementation

uses Variables;

resourceString
  rsMOCTransSubGrid = 'MOC3D Transport Subgrid';
  rsGWTTransSubGrid = 'GWT Transport Subgrid';

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

class function TMOCTransSubGridParam.WriteParamName: string;
begin
  if frmModflow.rbMODFLOW2000.Checked or frmModflow.rbModflow2005.Checked then
  begin
    result := rsGWTTransSubGrid;
  end
  else
  begin
    result := inherited WriteParamName;
  end;
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

class function TMOCTransSubGridLayer.WriteNewRoot: string;
begin
  if frmModflow.rbMODFLOW2000.Checked or frmModflow.rbModflow2005.Checked then
  begin
    result := rsGWTTransSubGrid;
  end
  else
  begin
    result := inherited WriteNewRoot;
  end;
end;

end.
