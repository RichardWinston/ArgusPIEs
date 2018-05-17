unit HST3DInitialWatTabLayers;

interface

uses ANE_LayerUnit;

type

TInitWatTabParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TEndInitWatTabParam = Class(TInitWatTabParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TInitWatTabLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

const
  kInitWat : string = 'Initial Water Table';
  kEndInitWat : string = 'End Initial Water Table';

implementation

uses HST3D_PIE_Unit, HST3DGridLayer;

{ TInitWatTabParam }
class Function TInitWatTabParam.ANE_ParamName : string ;
begin
  result := kInitWat;
end;

{constructor TInitWatTabParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm or ft';
end;}

function TInitWatTabParam.Units : string;
begin
  result := 'm or ft';
end;

function TInitWatTabParam.Value : string;
begin
  result := kGridLayer + '.' + kElevation + '1';
end;

{ TEndInitWatTabParam }
class Function TEndInitWatTabParam.ANE_ParamName : string ;
begin
  result := kEndInitWat;
end;

function TEndInitWatTabParam.Value : string;
begin
  result := kNA;
end;

{ TInitWatTabLayer }
constructor TInitWatTabLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
begin
  inherited;// Create(Index, ALayerList);
//  Units := 'm or ft';
  Paramlist.ParameterOrder.Add(kInitWat);
  Paramlist.ParameterOrder.Add(kEndInitWat);
  Lock := Lock + [llEvalAlg];
  Interp := leExact;
  TInitWatTabParam.Create(ParamList, -1);
  if PIE_Data.HST3DForm.cbWatTableInitialInterp.checked then
  begin
    TEndInitWatTabParam.Create(ParamList, -1);
  end;
end;

function TInitWatTabLayer.Units : string;
begin
  result := 'm or ft';
end;

class Function TInitWatTabLayer.ANE_LayerName : string ;
begin
  result := kInitWat;
end;

end.
