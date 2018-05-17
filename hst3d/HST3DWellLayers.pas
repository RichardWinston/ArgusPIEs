unit HST3DWellLayers;

interface

uses ANE_LayerUnit;

type

TWellLabel = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    class Function ANE_ParamName : string ; override;
  end;

TWellTopCompl = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellBotCompl = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellOutsideDiam = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellMethod = Class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    class Function ANE_ParamName : string ; override;
  end;

TWellRiserPipeLength = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellRiserPipeInsideDiam = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellRiserPipeRoughness = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellRiserPipeAngle = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellHeatTransCoef = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellThermDif = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellMediumThermCond = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellPipeThermCond = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellBottomTemp = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellTopTemp = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellCompletion = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

TWellSkinFactor = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

TWellFlowRate = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellLandSurfPres = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellDatumPres = Class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellFluidTemp = Class(T_ANE_LayerParam)
    function Value : string; override;
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

TWellUnitParameters = Class(T_ANE_IndexedParameterList )
    constructor Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);  override;
  end;

TWellTimeParameters = Class(T_ANE_IndexedParameterList )
    constructor Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);  override;
  end;

TWellLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    procedure CreateParamterList2; override;
    class Function ANE_LayerName : string ; override;
  end;

const
  kWellLabel : string = 'Label';
  kWellTop : string = 'Top Completion Elevation';
  kWellBottom : string = 'Bottom Completion Elevation';
  kWellOD : string = 'Outside Diameter';
  kWellMethod : string = 'Method';
  kWellRisPipeLength : string = 'Well Riser Pipe Length';
  kWellRisPipeID : string = 'Well Riser Pipe Inside Diameter';
  kWellRisPipeRough : string = 'Well Riser Pipe Roughness';
  kWellRisPipeAngle : string = 'Well Riser Pipe Angle';
  kWellHeatTransf : string = 'Heat Transfer Coefficient';
  KWellThermDif : string = 'Thermal Diffusivity';
  kWellMedThermCond : string = 'Medium Thermal Conductivity';
  kWellPipeThermCond : string = 'Pipe Thermal Conductivity';
  kWellBotTemp : string = 'Bottom Temperature';
  kWellTopTemp : string = 'Top Temperature';
  kWellCompl : string = 'Well Completion Element Layer';
  kWellSkin : string = 'Well Skin Factor Element Layer';
  KWellFlow : string = 'Flow Rate';
  kWellSurf : string = 'Land Surface Pressure';
  kWellDatum : string = 'Datum Pressure';
  kWellFluidTemp : string = 'Fluid Temperature';
  kWellLayerName : string = 'Wells';


implementation

uses
  HST3DGeneralParameters, HST3DUnit, HST3D_PIE_Unit, HST3DGridLayer;

constructor TWellLabel.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvString;
end;

class Function TWellLabel.ANE_ParamName : string ;
begin
  result := kWellLabel;
end;

function TWellTopCompl.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'm';
  end
  else
  begin
    result := 'ft';
  end;
  result := 'm or ft';
end;

class Function TWellTopCompl.ANE_ParamName : string ;
begin
  result := kWellTop;
end;

function TWellBotCompl.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'm';
  end
  else
  begin
    result := 'ft';
  end;
  result := 'm or ft';
end;

class Function TWellBotCompl.ANE_ParamName : string ;
begin
  result := kWellBottom;
end;

function TWellOutsideDiam.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'm';
  end
  else
  begin
    result := 'ft';
  end;
  result := 'm or ft';
end;

class Function TWellOutsideDiam.ANE_ParamName : string ;
begin
  result := kWellOD;
end;

constructor TWellMethod.Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

class Function TWellMethod.ANE_ParamName : string ;
begin
  result := kWellMethod;
end;

function TWellRiserPipeLength.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'm';
  end
  else
  begin
    result := 'ft';
  end;
  result := 'm or ft';
end;

class Function TWellRiserPipeLength.ANE_ParamName : string ;
begin
  result := kWellRisPipeLength;
end;

function TWellRiserPipeLength.Value : string;
begin
  result := '$N/A';
end;

function TWellRiserPipeInsideDiam.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'm';
  end
  else
  begin
    result := 'ft';
  end;
  result := 'm or ft';
end;

class Function TWellRiserPipeInsideDiam.ANE_ParamName : string ;
begin
  result := kWellRisPipeID;
end;

function TWellRiserPipeInsideDiam.Value : string;
begin
  result := '$N/A';
end;

function TWellRiserPipeRoughness.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'm';
  end
  else
  begin
    result := 'ft';
  end;
  result := 'm or ft';
end;

class Function TWellRiserPipeRoughness.ANE_ParamName : string ;
begin
  result := kWellRisPipeRough;
end;

function TWellRiserPipeRoughness.Value : string;
begin
  result := '$N/A';
end;

function TWellRiserPipeAngle.Units : string;
begin
  result := 'Degrees';
end;

class Function TWellRiserPipeAngle.ANE_ParamName : string ;
begin
  result := kWellRisPipeAngle;
end;

function TWellRiserPipeAngle.Value : string;
begin
  result := '$N/A';
end;

function TWellHeatTransCoef.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'W/m^2-degC';
  end
  else
  begin
    result := 'BTU/h-ft^2-degF';
  end;
  result := 'W/m^2-degC or BTU/h-ft^2-degF';
end;

class Function TWellHeatTransCoef.ANE_ParamName : string ;
begin
  result := kWellHeatTransf;
end;

function TWellHeatTransCoef.Value : string;
begin
  result := '$N/A';
end;

function TWellThermDif.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'm^2/s';
  end
  else
  begin
    result := 'ft^2/d';
  end;
  result := 'm^2/s or ft^2/d';
end;

class Function TWellThermDif.ANE_ParamName : string ;
begin
  result := KWellThermDif;
end;

function TWellThermDif.Value : string;
begin
  result := '$N/A';
end;

function TWellMediumThermCond.Units : string;
begin
  result := 'E/L-t-T';
end;

class Function TWellMediumThermCond.ANE_ParamName : string ;
begin
  result := kWellMedThermCond;
end;

function TWellMediumThermCond.Value : string;
begin
  result := '$N/A';
end;

function TWellPipeThermCond.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'W/m-C';
  end
  else
  begin
    result := 'BTU/ft-hr-F';
  end;
  result := 'W/m-C or BTU/ft-hr-F';
end;

class Function TWellPipeThermCond.ANE_ParamName : string ;
begin
  result := kWellPipeThermCond;
end;

function TWellPipeThermCond.Value : string;
begin
  result := '$N/A';
end;

function TWellBottomTemp.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'C';
  end
  else
  begin
    result := 'F';
  end;
  result := 'C or F';
end;

class Function TWellBottomTemp.ANE_ParamName : string ;
begin
  result := kWellBotTemp;
end;

function TWellBottomTemp.Value : string;
begin
  result := kGridLayer + '.' + kT0;
end;

function TWellTopTemp.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'C';
  end
  else
  begin
    result := 'F';
  end;
  result := 'C or F';
end;

class Function TWellTopTemp.ANE_ParamName : string ;
begin
  result := kWellTopTemp;
end;

function TWellTopTemp.Value : string;
begin
  result := kGridLayer + '.' + kT0;
end;

class Function TWellCompletion.ANE_ParamName : string ;
begin
  result := kWellCompl;
end;

class Function TWellSkinFactor.ANE_ParamName : string ;
begin
  result := kWellSkin;
end;

function TWellFlowRate.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'm^3/t';
  end
  else
  begin
    result := 'ft^3/t';
  end;
  result := 'm^3/t or ft^3/t';
end;

class Function TWellFlowRate.ANE_ParamName : string ;
begin
  result := KWellFlow;
end;

function TWellLandSurfPres.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'Pa';
  end
  else
  begin
    result := 'psi';
  end;
  result := 'Pa or psi';
end;

class Function TWellLandSurfPres.ANE_ParamName : string ;
begin
  result := kWellSurf;
end;

function TWellDatumPres.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'Pa';
  end
  else
  begin
    result := 'psi';
  end;
  result := 'Pa or psi';
end;

class Function TWellDatumPres.ANE_ParamName : string ;
begin
  result := kWellDatum;
end;

function TWellFluidTemp.Units : string;
begin
  if (PIE_Data.HST3DForm.rgUnits.ItemIndex = 0) then
  begin
    result := 'C';
  end
  else
  begin
    result := 'F';
  end;
  result := 'C or F';
end;

class Function TWellFluidTemp.ANE_ParamName : string ;
begin
  result := kWellFluidTemp;
end;

function TWellFluidTemp.Value : string ;
begin
  result := kGridLayer + '.' + kT0;
end;

constructor TWellUnitParameters.Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(kWellCompl);
  ParameterOrder.Add(kWellSkin);
  TWellCompletion.Create(self, -1);
  TWellSkinFactor.Create(self, -1);
end;

constructor TWellTimeParameters.Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer);
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(TTime.ANE_ParamName);
  ParameterOrder.Add(TWellFlowRate.ANE_ParamName);
  ParameterOrder.Add(TWellLandSurfPres.ANE_ParamName);
  ParameterOrder.Add(TWellDatumPres.ANE_ParamName);
  ParameterOrder.Add(TWellFluidTemp.ANE_ParamName);
  ParameterOrder.Add(TMassFraction.ANE_ParamName);
  ParameterOrder.Add(TScaledMassFraction.ANE_ParamName);
  TTime.Create(self, -1);
  TWellFlowRate.Create(self, -1);
  With PIE_Data do
  begin
    if HST3DForm.cbSolute.Checked and HST3DForm.cbWellRiser.Checked then
    begin
      TWellLandSurfPres.Create(self, -1);
    end;
    TWellDatumPres.Create(self, -1);
    TWellFluidTemp.Create(self, -1);
    if HST3DForm.cbSolute.Checked and (HST3DForm.rgMassFrac.ItemIndex = 0) then
    begin
      TMassFraction.Create(self, -1);
    end;
    if HST3DForm.cbSolute.Checked and (HST3DForm.rgMassFrac.ItemIndex = 1) then
    begin
      TScaledMassFraction.Create(self, -1);
    end;
  end;
end;

constructor TWellLayer.Create(ALayerList : T_ANE_LayerList; Index: Integer);
var
  UnitIndex, TimeIndex : Integer;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  ParamList.ParameterOrder.Add(TWellLabel.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellTopCompl.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellBotCompl.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellOutsideDiam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellMethod.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellRiserPipeLength.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellRiserPipeInsideDiam.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellRiserPipeRoughness.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellRiserPipeAngle.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellHeatTransCoef.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellThermDif.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellMediumThermCond.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellPipeThermCond.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellBottomTemp.ANE_ParamName);
  ParamList.ParameterOrder.Add(TWellTopTemp.ANE_ParamName);
  TWellLabel.Create(ParamList, -1);
  TWellTopCompl.Create(ParamList, -1);
  TWellBotCompl.Create(ParamList, -1);
  TWellOutsideDiam.Create(ParamList, -1);
  TWellMethod.Create(ParamList, -1);
  With PIE_Data do
  begin
    if HST3DForm.cbWellRiser.Checked then
    begin
      TWellRiserPipeLength.Create(ParamList, -1);
      TWellRiserPipeInsideDiam.Create(ParamList, -1);
      TWellRiserPipeRoughness.Create(ParamList, -1);
      TWellRiserPipeAngle.Create(ParamList, -1);
      if HST3DForm.cbHeat.Checked then
      begin
        TWellHeatTransCoef.Create(ParamList, -1);
        TWellThermDif.Create(ParamList, -1);
        TWellMediumThermCond.Create(ParamList, -1);
        TWellPipeThermCond.Create(ParamList, -1);
        TWellBottomTemp.Create(ParamList, -1);
        TWellTopTemp.Create(ParamList, -1);
      end;
    end;
    for UnitIndex := 1 to HST3DForm.sgGeology.RowCount -1 do
    begin
      TWellUnitParameters.Create(IndexedParamList1, -1);
    end;
    for TimeIndex := 1 to HST3DForm.sgSolver.ColCount -1 do
    begin
      TWellTimeParameters.Create(IndexedParamList2, -1);
    end;
  end;
end;

class Function TWellLayer.ANE_LayerName : string ;
begin
  result := kWellLayerName;
end;

procedure TWellLayer.CreateParamterList2;
begin
  TWellTimeParameters.Create(self.IndexedParamList2, -1);
end;

end.
