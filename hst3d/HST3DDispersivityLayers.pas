unit HST3DDispersivityLayers;

interface

uses ANE_LayerUnit;

type
TLongDispParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TTransDispParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TDispLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

const
  kDispLong : string = 'Longitudinal';
  kDispTrans : string = 'Transverse';
  kDispLayer : string = 'Dispersivity Element Layer';

implementation

uses HST3DGeneralParameters, HST3DUnit;

{ TLongDispParam }
class Function TLongDispParam.ANE_ParamName : string ;
begin
  result := kDispLong;
end;

{constructor TLongDispParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm or ft';
end; }

function TLongDispParam.Units : string;
begin
  result := 'm or ft';
end;

{ TTransDispParam }
class Function TTransDispParam.ANE_ParamName : string ;
begin
  result := kDispTrans;
end;

{constructor TTransDispParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm or ft';
end; }

function TTransDispParam.Units : string;
begin
  result := 'm or ft';
end;

{ TDispLayer }
constructor TDispLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
//  Units := 'm or ft';
  TLongDispParam.Create(ParamList, -1);
  TTransDispParam.Create(ParamList, -1);
end;

function TDispLayer.Units : string;
begin
  result := 'm or ft';
end; 

class Function TDispLayer.ANE_LayerName : string ;
begin
  result := kDispLayer;
end;

end.
