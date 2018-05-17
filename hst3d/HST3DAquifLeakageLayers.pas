unit HST3DAquifLeakageLayers;

interface

uses ANE_LayerUnit;

type
TConUnitPermParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TConUnitThickParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TConUnitElevParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TPotEnParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TAqLeakTimeParameters = Class(T_ANE_IndexedParameterList )
    constructor Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);  override;
  end;

THorAqLeakageLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    procedure CreateParamterList2; override;
    class Function ANE_LayerName : string ; override;
  end;

TVerAqLeakageLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    procedure CreateParamterList2; override;
    class Function ANE_LayerName : string ; override;
  end;

const
  KAqLeakPerm : string = 'Confining Unit Permeability';
  KAqLeakThick : string = 'Confining Unit Thickness';
  KAqLeakElev : string = 'Elevation of Opposite Side of Confining Unit';
  KAqLeakPotE : string = 'Potential Energy per Unit Mass';
  KAqLeakHorLay : string = 'Horizontal Aquifer Leakage Boundary NL';
  KAqLeakVerLay : string = 'Vertical Aquifer Leakage Boundary NL';

implementation

uses HST3DGeneralParameters, HST3DUnit, HST3D_PIE_Unit;

{ TConUnitPermParam }
function TConUnitPermParam.Units : string;
begin
  result := 'm^2 or ft^2';
end;

class Function TConUnitPermParam.ANE_ParamName : string ;
begin
  result := KAqLeakPerm;
end;

{constructor TConUnitPermParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
//  Units := 'm^2 or ft^2';
end;  }

{ TConUnitThickParam }
function TConUnitThickParam.Units : string;
begin
  result := 'm or ft';
end;

class Function TConUnitThickParam.ANE_ParamName : string ;
begin
  result := KAqLeakThick;
end;

{constructor TConUnitThickParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm or ft';
end; }

{ TConUnitElevParam }
function TConUnitElevParam.Units : string;
begin
  result := 'm or ft';
end;

class Function TConUnitElevParam.ANE_ParamName : string ;
begin
  result := KAqLeakElev;
end;

{constructor TConUnitElevParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm or ft';
end; }

{ TPotEnParam }
function TPotEnParam.Units : string;
begin
  result := 'J/kg or BTU/lb';
end;

class Function TPotEnParam.ANE_ParamName : string ;
begin
  result := KAqLeakPotE;
end;

{constructor TPotEnParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'J/kg or BTU/lb';
end;  }

{ TAqLeakTimeParameters }
constructor TAqLeakTimeParameters.Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(kGenParTime);
  ParameterOrder.Add(KAqLeakPotE);
  ParameterOrder.Add(kGenParDens);
  ParameterOrder.Add(kGenParVisc);
  ParameterOrder.Add(kGenParTemp);
  ParameterOrder.Add(kGenParMassFrac);
  ParameterOrder.Add(TScaledMassFraction.ANE_ParamName);
  TTime.Create(self, -1);
  TPotEnParam.Create(self, -1);
  TDensityLayerParam.Create(self, -1);
  TViscosity.Create(self, -1);
  With PIE_Data do
  begin
    if HST3DForm.cbHeat.Checked then
    begin
      TTemperature.Create(self, -1);
    end;
    if HST3DForm.cbSolute.Checked then
    begin
      if (HST3DForm.rgMassFrac.ItemIndex = 0) then
      begin
        TMassFraction.Create(self, -1);
      end;
      if (HST3DForm.rgMassFrac.ItemIndex = 1) then
      begin
        TScaledMassFraction.Create(self, -1);
      end;
    end;
  end;
end;

{ THorAqLeakageLayer }
constructor THorAqLeakageLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
begin
  inherited;// Create(Index, ALayerList);
  Lock := Lock + [llEvalAlg];
  Interp := leExact;
  ParamList.ParameterOrder.Add(KAqLeakPerm);
  ParamList.ParameterOrder.Add(KAqLeakThick);
  ParamList.ParameterOrder.Add(KAqLeakElev);
  TConUnitPermParam.Create(ParamList, -1);
  TConUnitThickParam.Create(ParamList, -1);
  TConUnitElevParam.Create(ParamList, -1);
  With PIE_Data do
  begin
    for TimeIndex := 1 to HST3DForm.sgSolver.ColCount -1 do
    begin
      TAqLeakTimeParameters.Create(IndexedParamList2, -1);
    end;
  end;
end;

class Function THorAqLeakageLayer.ANE_LayerName : string ;
begin
  result := KAqLeakHorLay;
end;

procedure THorAqLeakageLayer.CreateParamterList2;
begin
  Interp := leExact;
  TAqLeakTimeParameters.Create(self.IndexedParamList2, -1);
end;

{ TVerAqLeakageLayer }
constructor TVerAqLeakageLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  ParamList.ParameterOrder.Add(KAqLeakPerm);
  ParamList.ParameterOrder.Add(KAqLeakThick);
  ParamList.ParameterOrder.Add(KAqLeakElev);
  TConUnitPermParam.Create(ParamList, -1);
  TConUnitThickParam.Create(ParamList, -1);
  TConUnitElevParam.Create(ParamList, -1);
  With PIE_Data do
  begin
    for TimeIndex := 1 to HST3DForm.sgSolver.ColCount -1 do
    begin
      TAqLeakTimeParameters.Create(IndexedParamList2, -1);
    end;
  end;
end;

class Function TVerAqLeakageLayer.ANE_LayerName : string ;
begin
  result := KAqLeakVerLay;
end;

procedure TVerAqLeakageLayer.CreateParamterList2;
begin
  TAqLeakTimeParameters.Create(self.IndexedParamList2, -1);
end;

end.
