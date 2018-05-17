unit HST3DInitialPressureLayers;

interface

uses ANE_LayerUnit;

type
TInitialPresParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function WriteOldIndex : string; override;
    function WriteIndex : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TEndInitialPresParam = Class(TInitialPresParam)
    class Function ANE_ParamName : string ; override;
  end;

TInitialPresLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

const
  kInitPres : string = 'Initial Pressure NL';
  kEndInitPres : string = 'End Initial Pressure NL';

implementation

uses HST3D_PIE_Unit;

{ TInitialPresParam }
class Function TInitialPresParam.ANE_ParamName : string ;
begin
  result := kInitPres;
end;

{constructor TInitialPresParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'Pa or psi';
end; }

function TInitialPresParam.Units : string;
begin
  result := 'Pa or psi';
end;

function TInitialPresParam.WriteIndex : string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.WriteIndex;
end;

function TInitialPresParam.WriteOldIndex : string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.WriteOldIndex;
end;

{ TEndInitialPresParam }
class Function TEndInitialPresParam.ANE_ParamName : string ;
begin
  result := kEndInitPres;
end;

{ TInitialPresLayer }
constructor TInitialPresLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
//  Units := 'Pa or psi';
  ParamList.ParameterOrder.Add(kInitPres);
  ParamList.ParameterOrder.Add(kEndInitPres);
  Lock := Lock + [llEvalAlg];
  Interp := leExact;
  TInitialPresParam.Create(ParamList, -1);
  if PIE_Data.HST3DForm.cbInitPresInterp.Checked then
  begin
    TEndInitialPresParam.Create(ParamList, -1);
  end;
end;

function TInitialPresLayer.Units : string;
begin
  result := 'Pa or psi';
end;

class Function TInitialPresLayer.ANE_LayerName : string ;
begin
  result := kInitPres;
end;

end.
