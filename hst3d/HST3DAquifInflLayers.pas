unit HST3DAquifInflLayers;

interface

uses ANE_LayerUnit;

type
TWeightFacParam = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TAqInflTimeParameters = Class(T_ANE_IndexedParameterList )
    constructor Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer); override;
  end;

THorAqInflLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    procedure CreateParamterList2; override;
    class Function ANE_LayerName : string ; override;
  end;

TVerAqInflLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    procedure CreateParamterList2; override;
    class Function ANE_LayerName : string ; override;
  end;

const
  kAqInflWeight : string = 'Weighting Factor';
  kAqInflHorLayer : string = 'Horizontal Aquifer Influence Boundary NL';
  kAqInflVerLayer : string = 'Vertical Aquifer Influence Boundary NL';

implementation

uses HST3DGeneralParameters, HST3DUnit, HST3D_PIE_Unit;

class Function TWeightFacParam.ANE_ParamName : string ;
begin
  result := kAqInflWeight;
end;

function TWeightFacParam.Value : string;
begin
  result := '$N/A';
end;

//-------------------------------------------------------------------------

constructor TAqInflTimeParameters.Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(kGenParTime);
  ParameterOrder.Add(kGenParDens);
  ParameterOrder.Add(kGenParTemp);
  ParameterOrder.Add(kGenParMassFrac);
  ParameterOrder.Add(TScaledMassFraction.ANE_ParamName);
  TTime.Create(self, -1);
  TDensityLayerParam.Create(self, -1);
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

//-------------------------------------------------------------------------

constructor THorAqInflLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  With PIE_Data do
  begin
    if HST3DForm.comboAquiferInflZoneW.ItemIndex = 1 then
    begin
      TWeightFacParam.Create(ParamList, -1);
    end;
    for TimeIndex := 1 to HST3DForm.sgSolver.ColCount -1 do
    begin
      TAqInflTimeParameters.Create(IndexedParamList2, -1);
    end;
  end;
end;

class Function THorAqInflLayer.ANE_LayerName : string ;
begin
  result := kAqInflHorLayer;
end;

procedure THorAqInflLayer.CreateParamterList2;
begin
  Interp := leExact;
  TAqInflTimeParameters.Create(self.IndexedParamList2, -1);
end;

//-------------------------------------------------------------------------

constructor TVerAqInflLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
begin
  inherited;// Create(Index, ALayerList);
  Lock := Lock + [llEvalAlg];
  Interp := leExact;
  With PIE_Data do
  begin
    if HST3DForm.comboAquiferInflZoneW.ItemIndex = 1 then
      begin
        TWeightFacParam.Create(ParamList, -1);
      end;
    With PIE_Data do
    begin
      for TimeIndex := 1 to HST3DForm.sgSolver.ColCount -1 do
      begin
        TAqInflTimeParameters.Create(IndexedParamList2, -1);
      end;
    end;
  end;
end;

class Function TVerAqInflLayer.ANE_LayerName : string ;
begin
  result := kAqInflVerLayer;
end;

procedure TVerAqInflLayer.CreateParamterList2;
begin
  TAqInflTimeParameters.Create(self.IndexedParamList2, -1);
end;

end.
