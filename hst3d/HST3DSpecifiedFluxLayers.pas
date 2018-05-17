unit HST3DSpecifiedFluxLayers;

interface

uses ANE_LayerUnit, SysUtils;

type
TUpFluidFluxParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TEndUpFluidFluxParam = Class(TUpFluidFluxParam)
    class Function ANE_ParamName : string ; override;
  end;

TUpHeatFluxParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TUpSoluteFluxParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TXFluxPosParam = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TYFluxPosParam = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer); override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
  end;

TFluidFluxParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TEndFluidFluxParam = Class(TFluidFluxParam)
    class Function ANE_ParamName : string ; override;
  end;

THeatFluxParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TSoluteFluxParam = Class(T_ANE_LayerParam)
//    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
//      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
//      override;
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

THorSpecFluxTimeParameters = Class(T_ANE_IndexedParameterList )
    constructor Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);  override;
  end;

TVerSpecFluxTimeParameters = Class(T_ANE_IndexedParameterList )
    constructor Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);  override;
  end;

THorSpecFluxLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    procedure CreateParamterList2; override;
    class Function ANE_LayerName : string ; override;
  end;

TVerSpecFluxLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList;
  Index: Integer); override;
    procedure CreateParamterList2; override;
    class Function ANE_LayerName : string ; override;
  end;

const
  kSpecFluxUpFluid : string = 'Upward Fluid Flux';
  kEndSpecFluxUpFluid : string = 'End Upward Fluid Flux';
  kSpecFluxUpHeat : string = 'Upward Heat Flux';
  kSpecFluxUpSolute : string = 'Upward Solute Flux';
  kSpecFluxUpScaledSolute : string = 'Upward Scaled Solute Flux';
  kSpecFluxXFlux : string = 'XFlux Positive';
  kSpecFluxYFlux : string = 'YFlux Positive';
  kSpecFluxFluid : string = 'Fluid Flux';
  kEndSpecFluxFluid : string = 'End Fluid Flux';
  kSpecFluxHeat : string = 'Heat Flux';
  kSpecFluxSolute : string = 'Solute Flux';
  kSpecScaledFluxSolute : string = 'Scaled Solute Flux';
  kSpecFluxHorLay : string = 'Horizontal Specified Flux Boundary NL';
  kSpecFluxVerLay : string = 'Vertical Specified Flux Boundary NL';


implementation

uses HST3DGeneralParameters, HST3DUnit, HST3D_PIE_Unit;

{ TUpFluidFluxParam }
class Function TUpFluidFluxParam.ANE_ParamName : string ;
begin
  result := kSpecFluxUpFluid;
end;

{constructor TUpFluidFluxParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm^3/m^2-t or ft^3/ft^2-t';
end;}

function TUpFluidFluxParam.Units : string;
begin
  result := 'm^3/m^2-t or ft^3/ft^2-t';
end;

function TUpFluidFluxParam.Value : string;
begin
  result := '$N/A';
end;

{ TEndUpFluidFluxParam }
class Function TEndUpFluidFluxParam.ANE_ParamName : string ;
begin
  result := kEndSpecFluxUpFluid;
end;

{ TUpHeatFluxParam }

class Function TUpHeatFluxParam.ANE_ParamName : string ;
begin
  result := kSpecFluxUpHeat;
end;

{constructor TUpHeatFluxParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'W/m^2 or BTU/ft^2-h';
end;}

function TUpHeatFluxParam.Units : string;
begin
  result := 'W/m^2 or BTU/ft^2-h';
end;

function TUpHeatFluxParam.Value : string;
begin
  result := '$N/A';
end;

{ TUpSoluteFluxParam }
class Function TUpSoluteFluxParam.ANE_ParamName : string ;
begin
  result := kSpecFluxUpSolute;
end;

{constructor TUpSoluteFluxParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'kg/m^2-t or lb/ft^2-t';
end;}

function TUpSoluteFluxParam.Units : string;
begin
  result := 'kg/m^2-t or lb/ft^2-t';
end;

function TUpSoluteFluxParam.Value : string;
begin
  result := '$N/A';
end;

{ TXFluxPosParam }
constructor TXFluxPosParam.Create(AParameterList : T_ANE_ParameterList; Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvBoolean;
end;

class Function TXFluxPosParam.ANE_ParamName : string ;
begin
  result := kSpecFluxXFlux;
end;

function TXFluxPosParam.Value : string;
begin
  result := '1';
end;

constructor TYFluxPosParam.Create(AParameterList : T_ANE_ParameterList; Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvBoolean;
end;

{ TYFluxPosParam }
class Function TYFluxPosParam.ANE_ParamName : string ;
begin
  result := kSpecFluxYFlux;
end;

function TYFluxPosParam.Value : string;
begin
  result := '1';
end;

{ TFluidFluxParam }
class Function TFluidFluxParam.ANE_ParamName : string ;
begin
  result := kSpecFluxFluid;
end;

{constructor TFluidFluxParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'm^3/m^2-t or ft^3/ft^2-t';
end;}

function TFluidFluxParam.Units : string;
begin
  result := 'm^3/m^2-t or ft^3/ft^2-t';
end;

function TFluidFluxParam.Value : string;
begin
  result := '$N/A';
end;

{ TEndFluidFluxParam }
class Function TEndFluidFluxParam.ANE_ParamName : string ;
begin
  result := kEndSpecFluxFluid;
end;

{ THeatFluxParam }
class Function THeatFluxParam.ANE_ParamName : string ;
begin
  result := kSpecFluxHeat;
end;

{constructor THeatFluxParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'W/m^2 or BTU/ft^2-h';
end;}

function THeatFluxParam.Units : string;
begin
  result := 'W/m^2 or BTU/ft^2-h';
end;

function THeatFluxParam.Value : string;
begin
  result := '$N/A';
end;

{ TSoluteFluxParam }
class Function TSoluteFluxParam.ANE_ParamName : string ;
begin
  result := kSpecFluxSolute;
end;

{constructor TSoluteFluxParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  Units := 'kg/m^2-t or lb/ft^2-t';
end;}

function TSoluteFluxParam.Units : string;
begin
  result := 'kg/m^2-t or lb/ft^2-t';
end;

function TSoluteFluxParam.Value : string;
begin
  result := '$N/A';
end;

{ THorSpecFluxTimeParameters }
constructor THorSpecFluxTimeParameters.Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(kGenParTime);
  ParameterOrder.Add(kSpecFluxUpFluid);
  ParameterOrder.Add(kEndSpecFluxUpFluid);
  ParameterOrder.Add(kGenParDens);
  ParameterOrder.Add(kGenParEndDens);
  ParameterOrder.Add(kGenParTemp);
  ParameterOrder.Add(kGenParEndTemp);
  ParameterOrder.Add(kGenParMassFrac);
  ParameterOrder.Add(kGenParEndMassFrac);
  ParameterOrder.Add(kGenParScMassFrac);
  ParameterOrder.Add(kGenParEndScMassFrac);
  ParameterOrder.Add(kSpecFluxUpHeat);
  ParameterOrder.Add(kSpecFluxUpSolute);
  TTime.Create(self, -1);
  With PIE_Data do
  begin
    if HST3DForm.cbSpecFlow.Checked then
    begin
      TUpFluidFluxParam.Create(self, -1)   ;
    end;
    if HST3DForm.cbSpecFlow.Checked
      and HST3DForm.cbSpecFlowInterp.Checked
      and HST3DForm.cbFluidFluxInterp.Checked then
    begin
      TEndUpFluidFluxParam.Create(self, -1)   ;
    end;
    if HST3DForm.cbSpecFlow.Checked then
    begin
      TDensityLayerParam.Create(self, -1)  ;
    end;
    if HST3DForm.cbSpecFlow.Checked
      and HST3DForm.cbSpecFlowInterp.Checked
      and HST3DForm.cbFluxDensityInterp.Checked then
    begin
      TEndDensityLayerParam.Create(self, -1)  ;
    end;
    if HST3DForm.cbHeat.Checked and HST3DForm.cbSpecFlow.Checked then
    begin
      TTemperature.Create(self, -1)        ;
    end;
    if HST3DForm.cbHeat.Checked and HST3DForm.cbSpecFlow.Checked
      and HST3DForm.cbSpecFlowInterp.Checked
      and HST3DForm.cbFluxTempInterp.Checked then
    begin
      TEndTemperature.Create(self, -1)        ;
    end;
    if HST3DForm.cbSolute.Checked and HST3DForm.cbSpecFlow.Checked then
    begin
      if (HST3DForm.rgMassFrac.ItemIndex = 0) then
      begin
        TMassFraction.Create(self, -1)       ;
      end;
      if (HST3DForm.rgMassFrac.ItemIndex = 0)
        and HST3DForm.cbSpecFlowInterp.Checked
        and HST3DForm.cbFluxMassFracInterp.Checked then
      begin
        TEndMassFraction.Create(self, -1)       ;
      end;
      if (HST3DForm.rgMassFrac.ItemIndex = 1) then
      begin
        TScaledMassFraction.Create(self, -1) ;
      end;
      if (HST3DForm.rgMassFrac.ItemIndex = 1)
        and HST3DForm.cbSpecFlowInterp.Checked
        and HST3DForm.cbFluxScMassFracInterp.Checked then
      begin
        TEndScaledMassFraction.Create(self, -1) ;
      end;
    end;
    if HST3DForm.cbHeat.Checked and HST3DForm.cbSpecHeat.Checked then
    begin
      TUpHeatFluxParam.Create(self, -1)    ;
    end;
    if HST3DForm.cbSolute.Checked and HST3DForm.cbSpecSolute.Checked then
    begin
        TUpSoluteFluxParam.Create(self, -1)  ;
    end;
  end;
end;

{ TVerSpecFluxTimeParameters }
constructor TVerSpecFluxTimeParameters.Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(kGenParTime);
  ParameterOrder.Add(kSpecFluxXFlux);
  ParameterOrder.Add(kSpecFluxYFlux);
  ParameterOrder.Add(kSpecFluxFluid);
  ParameterOrder.Add(kEndSpecFluxFluid);
  ParameterOrder.Add(kGenParDens);
  ParameterOrder.Add(kGenParEndDens);
  ParameterOrder.Add(kGenParTemp);
  ParameterOrder.Add(kGenParEndTemp);
  ParameterOrder.Add(kGenParMassFrac);
  ParameterOrder.Add(kGenParEndMassFrac);
  ParameterOrder.Add(kGenParScMassFrac);
  ParameterOrder.Add(kGenParEndScMassFrac);
  ParameterOrder.Add(kSpecFluxHeat);
  ParameterOrder.Add(kSpecFluxSolute);

  TTime.Create(self, -1);
  TXFluxPosParam.Create(self, -1)      ;
  TYFluxPosParam.Create(self, -1)      ;
  With PIE_Data do
  begin
    if HST3DForm.cbSpecFlow.Checked then
    begin
      TFluidFluxParam.Create(self, -1)   ;
      TDensityLayerParam.Create(self, -1)  ;
    end;
    if HST3DForm.cbFluidFluxInterp.Checked then
    begin
      TEndFluidFluxParam.Create(self, -1) ;
    end;
    if HST3DForm.cbFluxDensityInterp.Checked then
    begin
      TEndDensityLayerParam.Create(self, -1) ;
    end;
    if HST3DForm.cbHeat.Checked then
    begin
      TTemperature.Create(self, -1)        ;
    end;
    if HST3DForm.cbFluxTempInterp.Checked then
    begin
      TEndTemperature.Create(self, -1) ;
    end;
    if HST3DForm.cbSolute.Checked and HST3DForm.cbSpecFlow.Checked then
    begin
      if HST3DForm.rgMassFrac.ItemIndex = 0
      then
        begin
          TMassFraction.Create(self, -1)       ;
          if HST3DForm.cbFluxMassFracInterp.Checked then
          begin
            TEndMassFraction.Create(self, -1) ;
          end;
        end
      else
        begin
          TScaledMassFraction.Create(self, -1) ;
          if HST3DForm.cbFluxScMassFracInterp.Checked then
          begin
            TEndScaledMassFraction.Create(self, -1) ;
          end;
        end;
    end;
    if HST3DForm.cbHeat.Checked and HST3DForm.cbSpecHeat.Checked then
    begin
      THeatFluxParam.Create(self, -1)    ;
    end;
    if HST3DForm.cbSolute.Checked and HST3DForm.cbSpecSolute.Checked then
    begin
          TSoluteFluxParam.Create(self, -1)  ;
    end;
  end;
end;

{ THorSpecFluxLayer }
constructor THorSpecFluxLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
var
  timeIndex : integer;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  With PIE_Data do
  begin
    for timeIndex := 1 to StrToInt(HST3DForm.edMaxTimes.Text) do
    begin
     THorSpecFluxTimeParameters.Create(IndexedParamList2, -1);
    end;
  end;
end;

class Function THorSpecFluxLayer.ANE_LayerName : string ;
begin
  result := kSpecFluxHorLay;
end;

procedure THorSpecFluxLayer.CreateParamterList2;
begin
  Interp := leExact;
  Lock := Lock + [llEvalAlg];
  THorSpecFluxTimeParameters.Create(self.IndexedParamList2, -1);
end;

{ TVerSpecFluxLayer }
constructor TVerSpecFluxLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer);
var
  timeIndex : integer;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  With PIE_Data do
  begin
    for timeIndex := 1 to StrToInt(HST3DForm.edMaxTimes.Text) do
    begin
      TVerSpecFluxTimeParameters.Create(IndexedParamList2, -1);
    end;
  end;
end;

class Function TVerSpecFluxLayer.ANE_LayerName : string ;
begin
  result := kSpecFluxVerLay;
end;

procedure TVerSpecFluxLayer.CreateParamterList2;
begin
  Lock := Lock + [llEvalAlg];
  TVerSpecFluxTimeParameters.Create(self.IndexedParamList2, -1);
end;

end.
