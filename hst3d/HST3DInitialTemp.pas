unit HST3DInitialTemp;

interface

uses ANE_LayerUnit;

type
TInitialTempParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function WriteName : string; override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TInitialTempLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

const
  kInitTemp : string = 'Initial Temperature NL';

implementation

uses HST3DGridLayer;

{ TInitialTempParam }
class Function TInitialTempParam.ANE_ParamName : string ;
begin
  result := kInitTemp;
end;

function TInitialTempParam.Units : string;
begin
  result := 'C or F';
end;

function TInitialTempParam.WriteName : string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.ANE_LayerName + ParentLayer.WriteIndex;
end;

function TInitialTempParam.Value : string ;
begin
  result := kGridLayer + '.' + kT0;
end;

{constructor TInitialTempParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 'C or F';
end;}

{ TInitialTempLayer }
constructor TInitialTempLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
//  Units := 'C or F';
  Lock := Lock + [llEvalAlg];
  Interp := leExact;
  TInitialTempParam.Create(ParamList, -1);
end;

function TInitialTempLayer.Units : string;
begin
  result := 'C or F';
end; 

class Function TInitialTempLayer.ANE_LayerName : string ;
begin
  result := kInitTemp;
end;


end.
