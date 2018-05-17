unit MFGenParam;

interface

{MFGenParam defines parameters which are used in more than one type of layer.}

uses ANE_LayerUnit;

type
  TConcentration = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TConductance = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TIFACEParam = class(T_ANE_LayerParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TModflowLayerParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
    function Value : string; override;
  end;

implementation

ResourceString
  kMFConcParam = 'Concentration';
  kMFConductance = 'Conductance';
  kMFFace = 'IFACE';
  kMFLayer = 'MODFLOW Layer';

//---------------------------
class Function TConcentration.ANE_ParamName : string ;
begin
  result := kMFConcParam;
end;

function TConcentration.Units : string;
begin
  result := 'M/L^3';
end;

//---------------------------
class Function TConductance.ANE_ParamName : string ;
begin
  result := kMFConductance;
end;

function TConductance.Units : string;
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetParentLayer;
  if Pos('Point', ALayer.ANE_LayerName) > 0 then
    begin
      result := 'L^2/T';
    end
  else if Pos('Line', ALayer.ANE_LayerName) > 0 then
    begin
      result := 'L/T';
    end
  else
    begin
      result := '1/T';
    end;
end;

function TConductance.Value : string;
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetParentLayer;
  if Pos('Area', ALayer.ANE_LayerName) > 0 then
    begin
      result := kNA;
    end
  else
    begin
      result := inherited Value;
    end;
end;
//---------------------------

constructor TIFACEParam.Create(AParameterList : T_ANE_ParameterList;
            Index : Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TIFACEParam.ANE_ParamName : string ;
begin
  result := kMFFace;
end;

function TIFACEParam.Units : string;
begin
  result := '';
end;

//---------------------------

{ TModflowLayerParam }

class function TModflowLayerParam.ANE_ParamName: string;
begin
  result := kMFLayer;
end;

constructor TModflowLayerParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TModflowLayerParam.Units: string;
begin
  result := 'number';
end;

function TModflowLayerParam.Value: string;
begin
  result := '1';
end;

end.

