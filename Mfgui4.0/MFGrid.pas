unit MFGrid;

interface

{MFGrid defines the "MODFLOW FD Grid" layer
 and associated parameters and Parameterlists.}

uses ANE_LayerUnit;

type
  TGridETSurf = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridETExtinctionDepth = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridETLayerParam = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
    constructor Create(
      AParameterList: T_ANE_ParameterList; Index: Integer = -1); override;
  end;

  TGridETS_Surface = class(TGridETSurf)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridETS_ExtinctDepth = class(TGridETExtinctionDepth)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridETS_Layer = class(TGridETLayerParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridRechElev = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridRechLayerParam = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer = -1); override;
  end;

  TGridResElev = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridResKz = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridResThickness = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TIBoundGridParam = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridTopElev = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridBottomElev = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridThickness = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridInitialHead = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridKx = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridKz = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridAniso = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridTrans = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridVCont = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridSpecYield = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridSpecStor = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridConfStor = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    //    function Units : string; override;
  end;

  TGridWetting = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridWell = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridRiver = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridDrain = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridDrainReturn = class(TGridDrain)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridGHB = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridFHB = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridHFB = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridStream = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridSFR = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridCHD = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMOCInitConc = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridMOCPrescribedConcParam = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridMOCSubGrid = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMOCParticleRegen = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMOCParticleLayerCount = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMOCParticleRowCount = class(TGridMOCParticleLayerCount)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMOCParticleColumnCount = class(TGridMOCParticleLayerCount)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMocParticleLocation = class(T_ANE_GridParam)
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMOCPorosity = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMocParticleObservation = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridZoneBudget = class(T_ANE_GridParam)
  public
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridModpathZone = class(T_ANE_GridParam)
  public
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMultiplier = class(T_ANE_GridParam)
  public
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridZone = class(T_ANE_GridParam)
  public
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridLakeLocation = class(T_ANE_GridParam)
  public
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridIbsPreconsolidationHead = class(T_ANE_GridParam)
  public
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridIbsElasticStorage = class(T_ANE_GridParam)
  public
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridIbsInelasticStorage = class(T_ANE_GridParam)
  public
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridIbsStartingCompaction = class(T_ANE_GridParam)
  public
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMNW_Location = class(T_ANE_GridParam)
  public
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMT3DICBUND = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridMT3DActiveCell = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
    function Value: string; override;
    function Units: string; override;
  end;

  TCustomGridMT3DInitConcCell = class(T_ANE_GridParam)
    function ConcentrationParamString: string; virtual; abstract;
    function ConstantConcentrationString: string; virtual; abstract;
    function InitialConcentrationString: string; virtual; abstract;
    function MassParamString: string; virtual; abstract;
    function Units: string; override;
    function Value: string; override;
  end;

  TGridMT3DInitConcCell = class(TCustomGridMT3DInitConcCell)
    class function ANE_ParamName: string; override;
    function ConcentrationParamString: string; override;
    function ConstantConcentrationString: string; override;
    function InitialConcentrationString: string; override;
    function MassParamString: string; override;
    //    function Units : string; override;
    //    function Value : string; override;
  end;

  TGridMT3DInitConc2Cell = class(TGridMT3DInitConcCell)
    class function ANE_ParamName: string; override;
    function ConcentrationParamString: string; override;
    function ConstantConcentrationString: string; override;
    function InitialConcentrationString: string; override;
    function MassParamString: string; override;
  end;

  TGridMT3DInitConc3Cell = class(TGridMT3DInitConcCell)
    class function ANE_ParamName: string; override;
    function ConcentrationParamString: string; override;
    function ConstantConcentrationString: string; override;
    function InitialConcentrationString: string; override;
    function MassParamString: string; override;
  end;

  TGridMT3DInitConc4Cell = class(TGridMT3DInitConcCell)
    class function ANE_ParamName: string; override;
    function ConcentrationParamString: string; override;
    function ConstantConcentrationString: string; override;
    function InitialConcentrationString: string; override;
    function MassParamString: string; override;
  end;

  TGridMT3DInitConc5Cell = class(TGridMT3DInitConcCell)
    class function ANE_ParamName: string; override;
    function ConcentrationParamString: string; override;
    function ConstantConcentrationString: string; override;
    function InitialConcentrationString: string; override;
    function MassParamString: string; override;
  end;

  TGridMT3DTimeVaryConcCell = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMT3DMassFluxCell = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridMT3DObsLocCell = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridMT3DLongDispCell = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    function Units: string; override;
  end;

  TGridGwtUppBoundConc = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridGwtLowBoundConc = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridGwtLateralBoundConc = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;



  TGridUzfSaturatedKz = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridUzfBrooksCoreyEpsilon = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridUzfSaturatedWaterContent = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridUzfInitialWaterContent = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridUzfExtinctionDepth = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridUzfExtinctionWaterContent = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridUzfModflowLayerParam = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
  end;

  TGridUzfDownstreamStreamOrLake = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
  end;

  TGridUzfOutputChoice = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
  end;

  TGridGwmZone = class(T_ANE_GridParam)
    class function ANE_ParamName: string; override;
    function Value: string; override;
    constructor Create(AParameterList: T_ANE_ParameterList;
      Index: Integer); override;
  end;

  TGeologicUnitParameters = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer); override;
  end;

  TMultiplierParameters = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer); override;
  end;

  TZoneParameters = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer); override;
  end;

  TMFGridLayer = class(T_ANE_GridLayer)
    constructor Create(ALayerList: T_ANE_LayerList; Index: Integer); override;
    class function ANE_LayerName: string; override;
  end;

implementation

uses Variables, SysUtils, MODFLOWPieDescriptors, ModflowUnit,
  ModflowLayerFunctions;

const
  kMFGrid = 'MODFLOW FD Grid';
  kMFGridETSurface = 'ET Surface Elevation';
  kMFGridETExtinctionDepth = 'ET Extinction Depth';
  kMFGridETLayer = 'ET Layer';
  kMFGridRechElev = 'Recharge Elevation';
  kMFGridResElev = 'Reservoir Elevation';
  kMFGridResKz = 'Reservoir Kz';
  kMFGridResThickness = 'Reservoir Bed Thickness';
  kMFGridIBound = 'IBOUND Unit';
  kMFGridTop = 'Elev Top Unit';
  kMFGridBottom = 'Elev Bot Unit';
  kMFGridThickness = 'Thickness Unit';
  kMFGridInitialHead = 'Initial Head Unit';
  kMFGridKx = 'Kx Unit';
  kMFGridKz = 'Kz Unit';
  kMFGridAniso = 'Aniso Unit';
  kMFGridSpecYield = 'Sp_Yield Unit';
  kMFGridSpecStor = 'Sp_Storage Unit';
  kMFGridWetting = 'Wetting Unit';
  kMFGridWelLocation = 'Well Location Unit';
  kMFGridRivLocation = 'River Location Unit';
  kMFGridDrainLocation = 'Drain Location Unit';
  kMFGridDrainReturnLocation = 'Drain Return Location Unit';
  kMFGridGHBLocation = 'Gen Head B Location Unit';
  kMFGridMOCInitConc = 'Init Concentration Unit';
  kMFGridMOCSubBound = 'Subgrid Boundary';
  kMFGridMOCParticleRegen = 'Particle Regeneration Unit';
  kMFGridMOCPorosity = 'Porosity Unit';
  kMFGridHFBLocation = 'Horizontal Flow Barrier Location Unit';
  kMFGridFHBLocation = 'Flow and Head Boundary Location Unit';
  //  kMFGridZoneBudget = 'ZoneBudget Zone Unit';
  kMFGridZoneBudget = 'ZONEBDGT Zone Unit';
  kMFGridMODPATHZone = 'MPATH Zone Unit';
  kMFGridStreamLocation = 'Stream Location Unit';
  kMFGridSFRLocation = 'SFR Location Unit';
  kMFGridTrans = 'Trans Unit';
  kMFGridVcont = 'Vert Cond Unit';
  kMFGridConfStorage = 'Conf Storage Coef Unit';
  kMFGridRechargeLayer = 'Recharge Layer';
  kMFPrescribedConc = 'Prescribed Head Conc Unit';
  kMFMultiplier = 'Multiplier';
  kMFZone = 'Zone';
  kMFLakeLocation = 'Lake Location Unit';
  kIBSPreconsolidationHead = 'IBS Preconsolidation head Unit';
  kIBSElasticStorageFactor = 'IBS Elastic storage factor Unit';
  kIBSInelasticStorageFactor = 'IBS Inelastic storage factor Unit';
  kIBSStartingCompaction = 'IBS Starting compaction Unit';
  kMFGridETSSurface = 'ETS Surface Elevation';
  kMFGridETSExtinctionDepth = 'ETS Extinction Depth';
  kMFGridETSLayer = 'ETS Layer';
  kMFGridCHDLocation = 'CHD Location Unit';
  //  kMT3DPorosity = 'MT3D Porosity Unit';
  kMFGridMNWLocation = 'MNW Location';
  kMT3DICBUND = 'ICBUND Unit';
  kMT3DActiveCell = 'Active MT3D Cell Unit';
  kMT3DInitConcCell = 'MT3D Initial Concentration Unit';
  kMT3DTimeVaryConcCell = 'MT3D Time Variant Concentration Location Unit';
  kMT3DMassFluxCell = 'MT3D Mass Flux Location Unit';
  kMT3DObsLocCell = 'MT3D Observation Location Unit';
  kMT3DLongDispCell = 'MT3D Longitudinal Dispersivity Unit';
  kMT3DInitConcBCell = 'MT3D Initial ConcentrationB Unit';
  kMT3DInitConcCCell = 'MT3D Initial ConcentrationC Unit';
  kMT3DInitConcDCell = 'MT3D Initial ConcentrationD Unit';
  kMT3DInitConcECell = 'MT3D Initial ConcentrationE Unit';
  kMocParticleLayerCount ='Layer Particle Count Unit';
  kMocParticleRowCount ='Row Particle Count Unit';
  kMocParticleColumnCount ='Column Particle Count Unit';
  kMocParticleLocation ='Particle Location Unit';
  rsUpperBoundConc = 'Upper Bound Conc';
  rsLowerBoundConc = 'Lower Bound Conc';
  rsLateralBoundConc = 'Lateral Bound Conc';
  rsGWTParticleObservation = 'GWT Particle Observation';

  kUzfSaturatedKz = 'UZF Saturated Kz';
  kUzfBrooksCoreyEpsilon = 'UZF Brooks_Corey Epsilon';
  kUzfSaturatedWaterContent = 'UZF Saturated Water Content';
  kUzfInitialWaterContent = 'UZF Initial Water Content';
  kUzfExtinctionDepth = 'UZF Extinction Depth';
  kUzfExtinctionWaterContent = 'UZF Extinction Water Content';
  kUzfModflowLayer = 'UZF Modflow Layer';
  kUzfDownstreamStreamOrLake = 'UZF Downstream Stream or Lake';
  kUzfOutputChoice = 'UZF Output Choice';

class function TGridETSurf.ANE_ParamName: string;
begin
  result := kMFGridETSurface;
end;

function TGridETSurf.Value: string;
begin
  result := ModflowTypes.GetETLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFETSurfaceParamType.ANE_ParamName;
end;

function TGridETSurf.Units: string;
begin
  result := LengthUnit;
end;

//--------------------------------------------------

class function TGridRechElev.ANE_ParamName: string;
begin
  result := kMFGridRechElev;
end;

function TGridRechElev.Value: string;
begin
  result := ModflowTypes.GetRechargeLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFRechElevParamType.ANE_ParamName;
end;

function TGridRechElev.Units: string;
begin
  result := LengthUnit;
end;

//--------------------------------------------------

constructor TIBoundGridParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class function TIBoundGridParam.ANE_ParamName: string;
begin
  Result := kMFGridIBound
end;

function TIBoundGridParam.Value;
begin
  case frmMODFLOW.comboCustomize.ItemIndex of
    0:
      begin
        result := 'If((CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName
          + WriteIndex
          + ',0,1,2,3)>0),-1, 1)*BlockIsActive()*'
          + ModflowTypes.GetInactiveLayerType.ANE_LayerName
          + WriteIndex;
      end;
    1, 2:
      begin
        result := 'If((CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName
          + WriteIndex
          + ',0,1)>0)|(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName
          + WriteIndex
          + ',3)>0&'
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName
          + WriteIndex
          + '!=$N/A),-1, 1)*(BlockIsActive()'
          ;
        if frmModflow.cbActiveBoundary.Checked then
        begin
          result := result + '|(CountObjectsInBlock('
            + ModflowTypes.GetMFDomainOutType.ANE_LayerName
            + ')>0)';
        end;
        result := result + ')*If('
          + ModflowTypes.GetInactiveLayerType.ANE_LayerName
          + WriteIndex + ', 1, 0)';
      end;

  end;
end;

function TIBoundGridParam.Units: string;
begin
  Result := '-1 or 0  or 1';
end;

//--------------------------------------------------

class function TGridTopElev.ANE_ParamName: string;
begin
  result := kMFGridTop;
end;

function TGridTopElev.Value: string;
begin
  result := ModflowTypes.GetMFTopElevLayerType.ANE_LayerName + WriteIndex;
end;

function TGridTopElev.Units: string;
begin
  result := LengthUnit;
end;

//--------------------------------------------------

class function TGridBottomElev.ANE_ParamName: string;
begin
  result := kMFGridBottom;
end;

function TGridBottomElev.Value: string;
begin
  result := ModflowTypes.GetBottomElevLayerType.ANE_LayerName + WriteIndex;
end;

function TGridBottomElev.Units: string;
begin
  result := LengthUnit;
end;

//--------------------------------------------------

class function TGridThickness.ANE_ParamName: string;
begin
  result := kMFGridThickness;
end;

function TGridThickness.Value: string;
begin
  result := ModflowTypes.GetMFGridTopElevParamType.ANE_ParamName + WriteIndex
    + '-'
    + ModflowTypes.GetMFGridBottomElevParamType.ANE_ParamName + WriteIndex;
end;

function TGridThickness.Units: string;
begin
  result := LengthUnit;
end;

//--------------------------------------------------

class function TGridInitialHead.ANE_ParamName: string;
begin
  result := kMFGridInitialHead;
end;

function TGridInitialHead.Value: string;
begin
  case frmMODFLOW.comboCustomize.ItemIndex of
    0: // ver MFGUI2
      begin
        result := 'If(((CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0,1,2,3))>0),Interpolate('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + '),'
          + ModflowTypes.GetInitialHeadLayerType.ANE_LayerName + WriteIndex
          + ')*Abs('
          + TMFGridLayer.ANE_LayerName
          + '.'
          + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
          + ')';
      end;
    1: // average points and line
      begin
        {
                result := 'If(CountObjectsInBlock('
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + ',0,1)>0, ( (AverageObjectsInBlock('
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + ',0,1) )), If(CountObjectsInBlock('
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + ',2)>0, AverageObjectsInBlock('
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + '), If('
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + '!=$N/A, '
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + ', '
                  + ModflowTypes.GetInitialHeadLayerType.ANE_LayerName + WriteIndex
                  + '))) * Abs('
                  + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
                  +')';
        }
        result := 'If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0,1)>0, AverageObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0,1), '
          {          + 'If(CountObjectsInBlock('
            + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
            + ',2)>0, AverageObjectsInBlock('
            + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
            + '), '  }
        + 'If((CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',3)>0&'

        + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + '!=$N/A),'
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ', '
          + ModflowTypes.GetInitialHeadLayerType.ANE_LayerName + WriteIndex
          + ')) * Abs('
          + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
          + ')';
      end;
    2: // Points first
      begin
        {
                result := 'If(CountObjectsInBlock('
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + ',0)>0, AverageObjectsInBlock('
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + ',0), If(CountObjectsInBlock('
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + ',1)>0, AverageObjectsInBlock('
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + ',1), If(CountObjectsInBlock('
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + ',2),AverageObjectsInBlock('
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + '), If(CountObjectsInBlock('
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + ',3)>0, '
                  + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
                  + ', '
                  + ModflowTypes.GetInitialHeadLayerType.ANE_LayerName + WriteIndex
                  + ')))) * Abs('
                  + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
                  + ')';
        }
        result := 'If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0)>0, AverageObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0), If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',1)>0, AverageObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',1), '
          //          + ' If(CountObjectsInBlock('
  //          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
  //          + ',2),AverageObjectsInBlock('
  //          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
  //          + '), '
        + 'If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',3)>0&'
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + '!=$N/A, '
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ', '
          + ModflowTypes.GetInitialHeadLayerType.ANE_LayerName + WriteIndex
          + '))) * Abs('
          + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
          + ')';
      end;
  end;
end;

function TGridInitialHead.Units: string;
begin
  result := LengthUnit;
end;

//--------------------------------------------------

class function TGridKx.ANE_ParamName: string;
begin
  result := kMFGridKx;
end;

function TGridKx.Value: string;
begin
  result := ModflowTypes.GetHydraulicCondLayerType.ANE_LayerName + WriteIndex
    + '.' + ModflowTypes.GetMFKxParamType.ANE_ParamName;
  if frmMODFLOW.LpfParameterUsed(lpfHK) then
  begin
    result := frmMODFLOW.LpfParameter(lpfHK, StrToInt(WriteIndex));
  end;
end;

function TGridKx.Units: string;
begin
  result := LengthUnit + '/' + TimeUnit;
end;

//--------------------------------------------------

class function TGridKz.ANE_ParamName: string;
begin
  result := kMFGridKz;
end;

function TGridKz.Value: string;
var
  UnitIndex: integer;
begin
  result := ModflowTypes.GetHydraulicCondLayerType.ANE_LayerName + WriteIndex
    + '.' + ModflowTypes.GetMFKzParamType.ANE_ParamName;
  if frmMODFLOW.rgFlowPackage.ItemIndex = 1 then
  begin
    UnitIndex := StrToInt(WriteIndex);
    if frmMODFLOW.Simulated(UnitIndex) then
    begin
      if frmMODFLOW.LpfParameterUsed(lpfVK) then
      begin
        result := frmMODFLOW.LpfParameter(lpfVK, UnitIndex);
      end;
      if frmMODFLOW.LpfParameterUsed(lpfVANI) then
      begin
        result := ModflowTypes.GetGridLayerType.ANE_LayerName + '.'
          + ModflowTypes.GetMFGridKxParamType.ANE_ParamName
          + WriteIndex + '/('
          + frmMODFLOW.LpfParameter(lpfVANI, UnitIndex)
          + ')';
      end;
    end
    else
    begin
      if frmMODFLOW.LpfParameterUsed(lpfVKCB) then
      begin
        result := frmMODFLOW.LpfParameter(lpfVKCB, UnitIndex);
      end;
    end;
  end;
end;

function TGridKz.Units: string;
begin
  result := LengthUnit + '/' + TimeUnit;
end;

//--------------------------------------------------

class function TGridSpecYield.ANE_ParamName: string;
begin
  result := kMFGridSpecYield;
end;

function TGridSpecYield.Value: string;
begin
  result := ModflowTypes.GetMFSpecYieldLayerType.ANE_LayerName + WriteIndex;
  if frmMODFLOW.LpfParameterUsed(lpfSY) then
  begin
    result := frmMODFLOW.LpfParameter(lpfSY, StrToInt(WriteIndex));
  end;
end;

function TGridSpecYield.Units: string;
begin
  result := LengthUnit + '^3/' + LengthUnit + '^3';
end;

//--------------------------------------------------

class function TGridSpecStor.ANE_ParamName: string;
begin
  result := kMFGridSpecStor;
end;

function TGridSpecStor.Value: string;
begin
  result := ModflowTypes.GetMFSpecStorageLayerType.ANE_LayerName + WriteIndex;
  if frmMODFLOW.LpfParameterUsed(lpfSS) then
  begin
    result := frmMODFLOW.LpfParameter(lpfSS, StrToInt(WriteIndex));
  end;
end;

function TGridSpecStor.Units: string;
begin
  result := '1/' + LengthUnit;
end;

//--------------------------------------------------

class function TGridWetting.ANE_ParamName: string;
begin
  result := kMFGridWetting;
end;

function TGridWetting.Value: string;
begin
  result := 'If(' + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName
    + WriteIndex + ','
    + ModflowTypes.GetMFWettingLayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFWettingThreshParamType.ANE_ParamName + WriteIndex + ' * '
    + ModflowTypes.GetMFWettingLayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFWettingFlagParamType.ANE_ParamName + ',0)';
end;

//--------------------------------------------------

constructor TGridWell.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class function TGridWell.ANE_ParamName: string;
begin
  result := kMFGridWelLocation;
end;

function TGridWell.Value: string;
begin
  result :=
    'If(CountObjectsInBlock('
    + ModflowTypes.GetMFWellLayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFWellStressParamType.ANE_ParamName + '1' + ',0)'
    + '+ CountObjectsInBlock('
    + ModflowTypes.GetMFLineWellLayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFWellStressParamType.ANE_ParamName + '1' + ',1)';

  if frmModflow.cbUseAreaWells.Checked then
  begin
    result := result
      + '+ CountObjectsInBlock('
      + ModflowTypes.GetMFAreaWellLayerType.ANE_LayerName + WriteIndex + '.'
      + ModflowTypes.GetMFWellStressParamType.ANE_ParamName + '1' + ',2,3)'
      + '>0';

      if frmModflow.cbAreaWellContour.Enabled
        and not frmModflow.cbAreaWellContour.Checked then
      begin
        result := result
          + '|'
          + ModflowTypes.GetMFAreaWellLayerType.ANE_LayerName + WriteIndex + '.'
          + ModflowTypes.GetMFWellStressParamType.ANE_ParamName + '1'
          + '!=$N/A|'
          + ModflowTypes.GetMFAreaWellLayerType.ANE_LayerName + WriteIndex + '.'
          + ModflowTypes.GetMFTotalWellStressParamType.ANE_ParamName + '1'
          + '!=$N/A'
      end;
  end;
  result := result
    + ', 1, 0)'
end;

//--------------------------------------------------

constructor TGridRiver.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class function TGridRiver.ANE_ParamName: string;
begin
  result := kMFGridRivLocation;
end;

function TGridRiver.Value: string;
var
  CondFactorName: string;
begin
  if frmModflow.cbCondRiv.Checked then
  begin
    CondFactorName :=
      ModflowTypes.GetMFRiverConductanceParamType.ANE_ParamName;
  end
  else
  begin
    CondFactorName :=
      ModflowTypes.GetMFRiverConductanceParamType.WriteFactorName;
  end;

  if frmMODFLOW.cbAltRiv.Checked then
  begin
    result := 'If(CountObjectsInBlock('
      + ModflowTypes.GetMFPointRiverLayerType.ANE_LayerName + WriteIndex
      + '.'
      + ModflowTypes.GetMFRiverConductanceParamType.ANE_ParamName
      + ',0)>0|'
      + 'CountObjectsInBlock('
      + ModflowTypes.GetMFLineRiverLayerType.ANE_LayerName + WriteIndex
      + '.'
      + CondFactorName
      + ',1)>0';

    if frmModflow.cbUseAreaRivers.Checked then
    begin
      result := result
        + '|'
        + ModflowTypes.GetMFAreaRiverLayerType.ANE_LayerName
        + WriteIndex + '.'
        + CondFactorName + '!=$N/A';
    end;

    result := result
      + ', 1, 0)'
  end
  else
  begin
    result := 'If(CountObjectsInBlock('
      + ModflowTypes.GetMFPointRiverLayerType.ANE_LayerName + WriteIndex
      + '.' + ModflowTypes.GetMFRiverConductanceParamType.ANE_ParamName + ',0)>0|'
      + 'CountObjectsInBlock('
      + ModflowTypes.GetMFLineRiverLayerType.ANE_LayerName + WriteIndex
      + '.' + CondFactorName + ',1)>0';

    if frmModflow.cbUseAreaRivers.Checked then
    begin
      result := result
        + '|'
        + 'CountObjectsInBlock('
        + ModflowTypes.GetMFAreaRiverLayerType.ANE_LayerName + WriteIndex
        + '.' + CondFactorName
        + ',2,3)>0';
        if frmModflow.cbAreaRiverContour.Enabled
         and not frmModflow.cbAreaRiverContour.Checked then
        begin
          result := result
            + '|' + ModflowTypes.GetMFAreaRiverLayerType.ANE_LayerName
            + WriteIndex + '.'
            + CondFactorName + '!=$N/A';
        end;
    end;

    result := result
      + ', 1, 0)'
  end;
end;

//--------------------------------------------------

constructor TGridDrain.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class function TGridDrain.ANE_ParamName: string;
begin
  result := kMFGridDrainLocation;
end;

function TGridDrain.Value: string;
var
  CondFactorName: string;
begin
  if frmModflow.cbCondDrn.Checked then
  begin
    CondFactorName :=
      ModflowTypes.GetMFDrainConductanceParamType.ANE_ParamName;
  end
  else
  begin
    CondFactorName :=
      ModflowTypes.GetMFDrainConductanceParamType.WriteFactorName;
  end;

  if frmMODFLOW.cbAltDrn.Checked then
  begin
    result := 'If(CountObjectsInBlock('
      + ModflowTypes.GetMFPointDrainLayerType.ANE_LayerName + WriteIndex
      + '.' + ModflowTypes.GetMFDrainConductanceParamType.ANE_ParamName
      + ',0)>0|CountObjectsInBlock('
      + ModflowTypes.GetLineDrainLayerType.ANE_LayerName + WriteIndex
      + '.' + CondFactorName + ',1)>0';
    if frmMODFLOW.cbUseAreaDrains.Checked then
    begin
      result := result
        + '|'
        + ModflowTypes.GetAreaDrainLayerType.ANE_LayerName
        + WriteIndex + '.'
        + CondFactorName + '!=$N/A'
    end;
    result := result + ', 1, 0)'
  end
  else
  begin
    result := 'If(CountObjectsInBlock('
      + ModflowTypes.GetMFPointDrainLayerType.ANE_LayerName + WriteIndex
      + '.' + ModflowTypes.GetMFDrainConductanceParamType.ANE_ParamName
      + ',0)>0|CountObjectsInBlock('
      + ModflowTypes.GetLineDrainLayerType.ANE_LayerName + WriteIndex
      + '.' + CondFactorName + ',1)>0';

    if frmMODFLOW.cbUseAreaDrains.Checked then
    begin
      result := result
        + '|CountObjectsInBlock('
        + ModflowTypes.GetAreaDrainLayerType.ANE_LayerName + WriteIndex + '.'
        + CondFactorName
        + ',2,3)>0';

      if frmModflow.cbAreaDrainContour.Enabled
       and not frmModflow.cbAreaDrainContour.Checked then
      begin
        result := result
        + '|' + ModflowTypes.GetAreaDrainLayerType.ANE_LayerName
        + WriteIndex + '.'
        + CondFactorName + '!=$N/A';
      end;

    end;
    result := result + ', 1, 0)';
  end;
end;

//--------------------------------------------------

constructor TGridGHB.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class function TGridGHB.ANE_ParamName: string;
begin
  result := kMFGridGHBLocation;
end;

function TGridGHB.Value: string;
var
  CondFactorName: string;
begin
  if frmModflow.cbCondGhb.Checked then
  begin
    CondFactorName :=
      ModflowTypes.GetMFGhbConductanceParamType.ANE_ParamName;
  end
  else
  begin
    CondFactorName :=
      ModflowTypes.GetMFGhbConductanceParamType.WriteFactorName;
  end;

  result := 'If(CountObjectsInBlock('
    + ModflowTypes.GetPointGHBLayerType.ANE_LayerName + WriteIndex
    + '.' + ModflowTypes.GetMFGhbConductanceParamType.ANE_ParamName
    + ',0)>0|CountObjectsInBlock('
    + ModflowTypes.GetLineGHBLayerType.ANE_LayerName + WriteIndex + '.'
    + CondFactorName
    + ',1)>0';

  if frmModflow.cbUseAreaGHBs.Checked then
  begin
    result := result
      + '|CountObjectsInBlock('
      + ModflowTypes.GetAreaGHBLayerType.ANE_LayerName
      + WriteIndex + '.' + CondFactorName
      + ',2,3)>0';
    if frmModflow.cbAreaGHBContour.Enabled
       and not frmModflow.cbAreaGHBContour.Checked then
    begin
      result := result
        + '|'
        + ModflowTypes.GetAreaGHBLayerType.ANE_LayerName + WriteIndex + '.'
        + CondFactorName
        + '!=$N/A';
    end;
  end;

  result := result + ', 1, 0)'
end;

//--------------------------------------------------
{ TGridStream }

class function TGridStream.ANE_ParamName: string;
begin
  result := kMFGridStreamLocation;
end;

constructor TGridStream.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

function TGridStream.Value: string;
begin
  result := 'If(CountObjectsInBlock('
    + ModflowTypes.GetMFStreamLayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName + ',1)>0, 1, 0)'

end;

//--------------------------------------------------

constructor TGridFHB.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class function TGridFHB.ANE_ParamName: string;
begin
  result := kMFGridFHBLocation;
end;

function TGridFHB.Value: string;
begin
  result := 'If(CountObjectsInBlock('
    + ModflowTypes.GetMFPointFHBLayerType.ANE_LayerName + WriteIndex
    + '.' + ModflowTypes.GetMFFHBPointAreaHeadParamType.ANE_ParamName
    + '1,0)>0|CountObjectsInBlock('
    + ModflowTypes.GetMFLineFHBLayerType.ANE_LayerName + WriteIndex
    + '.' + ModflowTypes.GetMFFHBLineHeadStartParamType.ANE_ParamName
    + '1,1)>0';
  if frmModflow.cbUseAreaFHBs.Checked then
  begin
    result := result
      + '|CountObjectsInBlock('
      + ModflowTypes.GetMFAreaFHBLayerType.ANE_LayerName
      + WriteIndex + '.'
      + ModflowTypes.GetMFFHBPointAreaHeadParamType.ANE_ParamName +
      '1,2)>0|!IsNA('
      + ModflowTypes.GetMFAreaFHBLayerType.ANE_LayerName + WriteIndex + '.'
      + ModflowTypes.GetMFFHBPointAreaHeadParamType.ANE_ParamName
      + '1)|!IsNA('
      + ModflowTypes.GetMFAreaFHBLayerType.ANE_LayerName + WriteIndex + '.'
      + ModflowTypes.GetMFFHBAreaFluxParamType.ANE_ParamName
      + '1)'
  end;
  result := result + ', 1, 0)'
end;

//--------------------------------------------------

constructor TGridHFB.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class function TGridHFB.ANE_ParamName: string;
begin
  result := kMFGridHFBLocation;
end;

function TGridHFB.Value: string;
begin
  result := 'If(CountObjectsInBlock('
    + ModflowTypes.GetMFHFBLayerType.ANE_LayerName + WriteIndex
    + '.' + ModflowTypes.GetMFHFBHydCondParamType.ANE_ParamName + ',1,2), 1, 0)'
end;

//--------------------------------------------------

class function TGridMOCInitConc.ANE_ParamName: string;
begin
  result := kMFGridMOCInitConc;
end;

function TGridMOCInitConc.Units: string;
begin
  result := 'M/' + LengthUnit + '^3';
end;

function TGridMOCInitConc.Value: string;
begin
  result := ModflowTypes.GetMOCInitialConcLayerType.ANE_LayerName + WriteIndex;
end;

//--------------------------------------------------

constructor TGridMOCSubGrid.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class function TGridMOCSubGrid.ANE_ParamName: string;
begin
  result := kMFGridMOCSubBound;
end;

function TGridMOCSubGrid.Value: string;
begin
  result := {'(Row() >= ' + MOCROW1 + '()) & (Row() <= (If(' + MOCROW2
  + '()<=-1,NumRows(),' + MOCROW2 + '()))) & (Column() >= ' + MOCCOL1
  + '()) & ((Column() <= (If(' + MOCCOL2 + '()<=-1,NumColumns(),'
  + MOCCOL2 + '()))))'}

  {'(Row() >= If(Row()=1&Column()=1,' + MOCROW1 + '(0),  ' + MOCROW1
  + '(1))) & (Row() <= ' + MOCROW2
  + '()) & (Column() >= ' + MOCCOL1
  + '()) & (Column() <= ' + MOCCOL2 + '())' }

  {'If(Row()=1&Column()=1, (Row()>=' + MOCROW1
  + '(0)) & (Row()<=' + MOCROW2
  + '(0)) & (Column()>=' + MOCCOL1
  + '(0)) & (Column()<=' + MOCCOL2
  + '(0)), (Row()>=' + MOCROW1
  + '(1)) & (Row()<=' + MOCROW2
  + '(1)) &(Column()>=' + MOCCOL1
  + '(1)) & (Column()<=' + MOCCOL2
  + '(1)))'}

{         'If((Row()=1)&(Column()=1), If((Row()>=' + MOCROW1
  + '(0)) & (Row()<=' + MOCROW2
  + '(0)) & (Column()>=' + MOCCOL1
  + '(0)) & (Column()<=' + MOCCOL2
  + '(0)),1,0), If((Row()>=' + MOCROW1
  + '(1)) & (Row()<=' + MOCROW2
  + '(1)) &(Column()>=' + MOCCOL1
  + '(1)) & (Column()<=' + MOCCOL2
  + '(1)),1,0))' }

{         'If(((Row()=1)&(Column()=1))|'
  +  '((Row()=NumRows())&(Column()=1))|'
  +  '((Row()=1)&(Column()=NumColumns()))|'
  +  '((Row()=NumRows())&(Column()=NumColumns())), If((Row()>=' + MOCROW1
  + '(0)) & (Row()<=' + MOCROW2
  + '(0)) & (Column()>=' + MOCCOL1
  + '(0)) & (Column()<=' + MOCCOL2
  + '(0)),1,0), If((Row()>=' + MOCROW1
  + '(1)) & (Row()<=' + MOCROW2
  + '(1)) &(Column()>=' + MOCCOL1
  + '(1)) & (Column()<=' + MOCCOL2
  + '(1)),1,0))' }

  {'If((Row()>=' + MOCROW1
  + '(Column(),Row())) & (Row()<=' + MOCROW2
  + '(Column(),Row())) &(Column()>=' + MOCCOL1
  + '(Column(),Row())) & (Column()<=' + MOCCOL2
  + '(Column(),Row())),1,0))'}

  'If(Row()>=' + MOCROW1
    + '(Column(),Row())&Row()<=' + MOCROW2
    + '(Column(),Row())&Column()>=' + MOCCOL1
    + '(Column(),Row())&Column()<=' + MOCCOL2
    + '(Column(),Row()), 1, 0)'

  {         'If(Row()>=' + MOCROW1
           + '()&Row()<=' + MOCROW2
           + '()&Column()>=' + MOCCOL1
           + '()&Column()<=' + MOCCOL2
           + '(), 1, 0)' }
end;

//--------------------------------------------------

constructor TGridMOCParticleRegen.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class function TGridMOCParticleRegen.ANE_ParamName: string;
begin
  result := kMFGridMOCParticleRegen;
end;

function TGridMOCParticleRegen.Value: string;
begin
  result := 'If((CountObjectsInBlock('
    + ModflowTypes.GetMOCParticleRegenLayerType.ANE_LayerName
    + WriteIndex + ',0,1,2)>0)&(SumObjectsInBlock('
    + ModflowTypes.GetMOCParticleRegenLayerType.ANE_LayerName
    + WriteIndex + ')>0),1,If(!IsNA('
    + ModflowTypes.GetMOCParticleRegenLayerType.ANE_LayerName
    + WriteIndex + '), '
    + ModflowTypes.GetMOCParticleRegenLayerType.ANE_LayerName
    + WriteIndex + ', 0))';
end;

//--------------------------------------------------

class function TGridMOCPorosity.ANE_ParamName: string;
begin
  result := kMFGridMOCPorosity;
end;

function TGridMOCPorosity.Value: string;
var
  UnitIndex: integer;
begin
  result := ModflowTypes.GetMOCPorosityLayerType.ANE_LayerName + WriteIndex;
  if (frmMODFLOW.rgFlowPackage.ItemIndex >= 1)
    and frmMODFLOW.cbObservations.Checked
    and frmMODFLOW.cbAdvObs.Checked
    and (frmMODFLOW.dgADVParameters.RowCount > 1) then
  begin
    UnitIndex := StrToInt(WriteIndex);
    if frmMODFLOW.Simulated(UnitIndex) then
    begin
      if frmMODFLOW.ADVParameterUsed(advPRST) then
      begin
        result := frmMODFLOW.AdvParameter(advPRST, UnitIndex);
      end
      else
      begin
        result := '0';
      end;
    end
    else
    begin
      if frmMODFLOW.ADVParameterUsed(advPRCB) then
      begin
        result := frmMODFLOW.AdvParameter(advPRCB, UnitIndex);
      end
      else
      begin
        result := '0';
      end;
    end;
  end;

end;

//--------------------------------------------------

class function TGridZoneBudget.ANE_ParamName: string;
begin
  result := kMFGridZoneBudget;
end;

function TGridZoneBudget.Value: string;
begin
  result := ModflowTypes.GetZoneBudLayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFZoneBudZoneParamType.ANE_ParamName;
end;

//--------------------------------------------------

class function TGridModpathZone.ANE_ParamName: string;
begin
  result := kMFGridMODPATHZone;
end;

constructor TGridModpathZone.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGridModpathZone.Value: string;
begin
  result := ModflowTypes.GetMODPATHZoneLayerType.ANE_LayerName + WriteIndex
    + ' * '
    + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex;

end;

//--------------------------------------------------

constructor TGeologicUnitParameters.Create(AnOwner:
  T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  NCOMP: integer;
begin
  inherited Create(AnOwner, Position);

  ParameterOrder.Add(ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridTopElevParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridBottomElevParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridThicknessParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridInitialHeadParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridKxParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridKzParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridAnisoParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridTransParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridVContParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridSpecYieldParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridSpecStorParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridConfStoreParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridWettingParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridWellParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridRiverParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridDrainParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridDrainReturnParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMFGridGHBParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridStreamParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridSFRParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMFGridHFBParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridFHBParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridLakeLocationParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMFGridIbsPreconsolidationHeadParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridIbsElasticStorageParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMGridIbsInelasticStorageParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridIbsStartingCompactionParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridCHDParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMFGridMOCInitConcParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridMOCPrescribedConcParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridMOCParticleRegenParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMFGridMOCParticleColumnCountParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridMOCParticleRowCountParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridMOCParticleLayerCountParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridMocParticleLocationParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridMocParticleObservationParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridGwtLateralBoundConcParamType.ANE_ParamName);


  ParameterOrder.Add(ModflowTypes.GetMFGridMOCPorosityParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridZoneBudgetParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridModpathZoneParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMF_GridGwmZoneParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetGridMT3DICBUNDParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DActiveCellParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DInitConcCellParamClassType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetGridMT3DInitConc2ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DInitConc3ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DInitConc4ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DInitConc5ParamClassType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetGridMT3DTimeVaryConcCellParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DMassFluxParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DObsLocCellParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGridMT3DLongDispCellParamClassType.ANE_ParamName);

  ModflowTypes.GetMFIBoundGridParamType.Create(self, -1);
  ModflowTypes.GetMFGridTopElevParamType.Create(self, -1);
  ModflowTypes.GetMFGridBottomElevParamType.Create(self, -1);
  ModflowTypes.GetMFGridThicknessParamType.Create(self, -1);
  ModflowTypes.GetMFGridInitialHeadParamType.Create(self, -1);
  ModflowTypes.GetMFGridKxParamType.Create(self, -1);
  ModflowTypes.GetMFGridKzParamType.Create(self, -1);

  if frmModflow.AnisotropyUsed(Index) then
  begin
    ModflowTypes.GetMFGridAnisoParamType.Create(self, -1);
  end;
  if frmModflow.dgGeol.Cells[Ord(nuiSpecT), Index] =
    frmModflow.dgGeol.Columns[Ord(nuiSpecT)].Picklist.Strings[1] then
  begin
    ModflowTypes.GetMFGridTransParamType.Create(self, -1);
  end;
  if frmModflow.dgGeol.Cells[Ord(nuiSpecVCONT), Index] =
    frmModflow.dgGeol.Columns[Ord(nuiSpecVCONT)].Picklist.Strings[1] then
  begin
    ModflowTypes.GetMFGridVContParamType.Create(self, -1);
  end;
  if frmModflow.dgGeol.Cells[Ord(nuiSpecSF1), Index] =
    frmModflow.dgGeol.Columns[Ord(nuiSpecSF1)].Picklist.Strings[1] then
  begin
    ModflowTypes.GetMFGridConfStoreParamType.Create(self, -1);
  end;

  ModflowTypes.GetMFGridSpecYieldParamType.Create(self, -1);
  ModflowTypes.GetMFGridSpecStorParamType.Create(self, -1);
  ModflowTypes.GetMFGridWettingParamType.Create(self, -1);

  if frmMODFLOW.cbWEL.Checked then
  begin
    ModflowTypes.GetMFGridWellParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbRIV.Checked then
  begin
    ModflowTypes.GetMFGridRiverParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbDRN.Checked then
  begin
    ModflowTypes.GetMFGridDrainParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbDRT.Checked then
  begin
    ModflowTypes.GetGridDrainReturnParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbGHB.Checked then
  begin
    ModflowTypes.GetMFGridGHBParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbSTR.Checked then
  begin
    ModflowTypes.GetMFGridStreamParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbSFR.Checked then
  begin
    ModflowTypes.GetMFGridSFRParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbHFB.Checked then
  begin
    ModflowTypes.GetMFGridHFBParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbFHB.Checked then
  begin
    ModflowTypes.GetMFGridFHBParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbLAK.Checked then
  begin
    ModflowTypes.GetMFGridLakeLocationParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbCHD.Checked then
  begin
    ModflowTypes.GetMFGridCHDParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFGridMOCInitConcParamType.Create(self, -1);
    ModflowTypes.GetMFGridMOCPrescribedConcParamType.Create(self, -1);
  end;
  if frmMODFLOW.cbMOC3D.Checked
    and (frmMODFLOW.rgMOC3DSolver.ItemIndex < 2) then
  begin
    ModflowTypes.GetMFGridMOCParticleRegenParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked and frmMODFLOW.WeightedParticlesUsed
    and (frmMODFLOW.comboSpecifyParticles.ItemIndex = 1) then
  begin
    ModflowTypes.GetMFGridMOCParticleColumnCountParamType.Create(self, -1);
    ModflowTypes.GetMFGridMOCParticleRowCountParamType.Create(self, -1);
    ModflowTypes.GetMFGridMOCParticleLayerCountParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked and frmMODFLOW.WeightedParticlesUsed
    and (frmMODFLOW.comboSpecifyParticles.ItemIndex = 2) then
  begin
    ModflowTypes.GetMFGridMocParticleLocationParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked and
    frmMODFLOW.cbParticleObservations.Checked then
  begin
    ModflowTypes.GetMFGridMocParticleObservationParamType.Create(self, -1);
  end;

  if ModflowTypes.GetMOCLateralBoundaryConcentrationLayerType.Used then
  begin
    ModflowTypes.GetMFGridGwtLateralBoundConcParamType.Create(self, -1);
  end;

  if frmMODFLOW.PorosityUsed then
  begin
    ModflowTypes.GetMFGridMOCPorosityParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbZonebudget.Checked then
  begin
    ModflowTypes.GetMFGridZoneBudgetParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbMODPATH.Checked then
  begin
    ModflowTypes.GetMFGridModpathZoneParamType.Create(self, -1);
  end;

  if frmMODFLOW.cb_GWM.Checked and (StrToInt(frmMODFLOW.rdeGwmStorageStateVarCount.Output) >= 1) then
  begin
    ModflowTypes.GetMF_GridGwmZoneParamType.Create(self, -1);
  end;

  if frmMODFLOW.cbMT3D.Checked then
  begin
    ModflowTypes.GetGridMT3DICBUNDParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DActiveCellParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DInitConcCellParamClassType.Create(self, -1);

    NCOMP := StrToInt(frmMODFLOW.adeMT3DNCOMP.Text);
    if NCOMP >= 2 then
    begin
      ModflowTypes.GetGridMT3DInitConc2ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 3 then
    begin
      ModflowTypes.GetGridMT3DInitConc3ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 4 then
    begin
      ModflowTypes.GetGridMT3DInitConc4ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 5 then
    begin
      ModflowTypes.GetGridMT3DInitConc5ParamClassType.Create(self, -1);
    end;

    ModflowTypes.GetGridMT3DObsLocCellParamClassType.Create(self, -1);
    ModflowTypes.GetGridMT3DLongDispCellParamClassType.Create(self, -1);

    if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked
      and frmMODFLOW.cbMT3D_TVC.Checked then
    begin
      ModflowTypes.GetGridMT3DTimeVaryConcCellParamClassType.Create(self, -1);
    end;

    if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked
      and frmMODFLOW.cbMT3DMassFlux.Checked then
    begin
      ModflowTypes.GetGridMT3DMassFluxParamClassType.Create(self, -1);
    end;
  end;

end;

//--------------------------------------------------

class function TMFGridLayer.ANE_LayerName: string;
begin
  result := kMFGrid
end;

constructor TMFGridLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  ListIndex: integer;
  NumberOfLists: integer;
begin
  inherited Create(ALayerList, Index);
  YGridDirectionReversed := True;
  DomainLayer := ModflowTypes.GetMFDomainOutType.ANE_LayerName;
  DensityLayer := ModflowTypes.GetDensityLayerType.ANE_LayerName;

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridETSurfParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridETExtinctionDepthParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridETLayerParamType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.GetGridETS_SurfaceParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetGridETS_ExtinctDepthParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetGridETS_LayerParamType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridRechElevParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridRechLayerParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridResElevParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridResKzParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridResThicknessParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridMNW_LocationParamClassType.ANE_ParamName);



  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridUzfSaturatedKzParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridUzfBrooksCoreyEpsilonParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridUzfSaturatedWaterContentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridUzfInitialWaterContentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridUzfExtinctionDepthParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridUzfExtinctionWaterContentParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridUzfModflowLayerParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridUzfDownstreamStreamOrLakeParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridUzfOutputChoiceParamType.ANE_ParamName);




  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridMOCSubGridParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridGwtUppBoundConcParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridGwtLowBoundConcParamType.ANE_ParamName);

  if frmMODFLOW.cbEVT.Checked then
  begin
    ModflowTypes.GetMFGridETSurfParamType.Create(ParamList, -1);
    ModflowTypes.GetMFGridETExtinctionDepthParamType.Create(ParamList, -1);
    if frmMODFLOW.cbETLayer.Checked and (frmMODFLOW.comboEvtOption.ItemIndex = 1)
      then
    begin
      ModflowTypes.GetMFGridETLayerParamType.Create(ParamList, -1);
    end;
  end;

  if frmMODFLOW.cbETS.Checked then
  begin
    ModflowTypes.GetGridETS_SurfaceParamType.Create(ParamList, -1);
    ModflowTypes.GetGridETS_ExtinctDepthParamType.Create(ParamList, -1);
    if frmMODFLOW.cbETSLayer.Checked and (frmMODFLOW.comboEtsOption.ItemIndex =
      1) then
    begin
      ModflowTypes.GetGridETS_LayerParamType.Create(ParamList, -1);
    end;
  end;

  if frmMODFLOW.cbRCH.Checked then
  begin
    ModflowTypes.GetMFGridRechElevParamType.Create(ParamList, -1);
    if frmMODFLOW.cbRechLayer.Checked and (frmMODFLOW.comboRchOpt.ItemIndex = 1)
      then
    begin
      ModflowTypes.GetMFGridRechLayerParamType.Create(ParamList, -1);
    end;
  end;

  if frmMODFLOW.cbRes.Checked then
  begin
    ModflowTypes.GetMFGridResElevParamType.Create(ParamList, -1);
    ModflowTypes.GetMFGridResKzParamType.Create(ParamList, -1);
    ModflowTypes.GetMFGridResThicknessParamType.Create(ParamList, -1);
  end;

  if frmModflow.cbMNW.Checked then
  begin
    ModflowTypes.GetMFGridMNW_LocationParamClassType.Create(ParamList, -1);
  end;

  if frmModflow.cbUZF.Checked then
  begin
    if not frmModflow.cbUzfIUZFOPT.Checked then
    begin
      ModflowTypes.GetMFGridUzfSaturatedKzParamType.Create(ParamList, -1);
    end;

    ModflowTypes.GetMFGridUzfBrooksCoreyEpsilonParamType.Create(ParamList, -1);
    ModflowTypes.GetMFGridUzfSaturatedWaterContentParamType.Create(ParamList, -1);
    ModflowTypes.GetMFGridUzfInitialWaterContentParamType.Create(ParamList, -1);

    if frmModflow.cbUzfIETFLG.Checked then
    begin
      ModflowTypes.GetMFGridUzfExtinctionDepthParamType.Create(ParamList, -1);
      ModflowTypes.GetMFGridUzfExtinctionWaterContentParamType.Create(ParamList, -1);
    end;

    ModflowTypes.GetMFGridUzfModflowLayerParamType.Create(ParamList, -1);

    if frmModflow.cbUzfIRUNFLG.Checked and
      (frmModflow.cbLAK.Checked or frmModflow.cbSFR.Checked) then
    begin
      ModflowTypes.GetMFGridUzfDownstreamStreamOrLakeParamType.Create(ParamList, -1);
    end;

    ModflowTypes.GetMFGridUzfOutputChoiceParamType.Create(ParamList, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFGridMOCSubGridParamType.Create(ParamList, -1);
  end;

  if ModflowTypes.GetMOCUpperBoundaryConcentrationLayerType.Used then
  begin
    ModflowTypes.GetMFGridGwtUppBoundConcParamType.Create(ParamList, -1);
  end;

  if ModflowTypes.GetMOCLowerBoundaryConcentrationLayerType.Used then
  begin
    ModflowTypes.GetMFGridGwtLowBoundConcParamType.Create(ParamList, -1);
  end;

  NumberOfLists := StrToInt(frmMODFLOW.edNumUnits.Text);
  for ListIndex := 1 to NumberOfLists do
  begin
    ModflowTypes.GetMFGeologicUnitParametersType.Create(IndexedParamList1, -1);
  end;

  NumberOfLists := StrToInt(frmMODFLOW.adeMultCount.Text);
  for ListIndex := 1 to NumberOfLists do
  begin
    ModflowTypes.GetMFMultiplierParamListType.Create(IndexedParamListNeg1, -1);
  end;

  NumberOfLists := StrToInt(frmMODFLOW.adeZoneCount.Text);
  for ListIndex := 1 to NumberOfLists do
  begin
    ModflowTypes.GetMFZoneParamListType.Create(IndexedParamList0, -1);
  end;
end;

{ TGridTrans }

class function TGridTrans.ANE_ParamName: string;
begin
  result := kMFGridTrans
    {  kMFGridTrans = 'Trans Unit';
kMFGridVcont = 'Vert Cond Unit';
kMFGridConfStorage = 'Conf Storage Coef Unit';  }
end;

function TGridTrans.Units: string;
begin
  result := LengthUnit + '^2/' + TimeUnit;
end;

function TGridTrans.Value: string;
begin
  result := ModflowTypes.GetMFTransmisivityLayerType.ANE_LayerName + WriteIndex
    + '.' + ModflowTypes.GetMFTransmisivityParamType.ANE_ParamName + WriteIndex;
end;

{ TGridVCont }

class function TGridVCont.ANE_ParamName: string;
begin
  result := kMFGridVcont
end;

function TGridVCont.Units: string;
begin
  result := '1/' + TimeUnit;
end;

function TGridVCont.Value: string;
begin
  result := ModflowTypes.GetMFVcontLayerType.ANE_LayerName + WriteIndex
    + '.' + ModflowTypes.GetMFVcontParamType.ANE_ParamName + WriteIndex;
end;

{ TGridConfStor }

class function TGridConfStor.ANE_ParamName: string;
begin
  result := kMFGridConfStorage;
end;

function TGridConfStor.Value: string;
begin
  result := ModflowTypes.GetMFConfStorageLayerType.ANE_LayerName + WriteIndex
    + '.' + ModflowTypes.GetMFConfStorageParamType.ANE_ParamName + WriteIndex
end;

{ TGridRechLayerParam }

class function TGridRechLayerParam.ANE_ParamName: string;
begin
  result := kMFGridRechargeLayer;
end;

constructor TGridRechLayerParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer = -1);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGridRechLayerParam.Units: string;
begin
  result := 'number';
end;

function TGridRechLayerParam.Value: string;
begin
  result := ModflowTypes.GetRechargeLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFModflowLayerParamType.ANE_ParamName;
end;

{ TGridETLayerParam }

class function TGridETLayerParam.ANE_ParamName: string;
begin
  result := kMFGridETLayer;
end;

constructor TGridETLayerParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGridETLayerParam.Units: string;
begin
  result := 'number';
end;

function TGridETLayerParam.Value: string;
begin
  result := ModflowTypes.GetETLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFModflowLayerParamType.ANE_ParamName;
end;

{ TGridMOCPrescribedConcParam }

class function TGridMOCPrescribedConcParam.ANE_ParamName: string;
begin
  result := kMFPrescribedConc;
end;

function TGridMOCPrescribedConcParam.Units: string;
begin
  result := 'M/' + LengthUnit + '^3';
end;

function TGridMOCPrescribedConcParam.Value: string;
begin
  result := 'If(CountObjectsInBlock('
    + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
    + ',0)>0, AverageObjectsInBlock('
    + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMFConcentrationParamType.ANE_ParamName
    + ',0), If(CountObjectsInBlock('
    + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
    + ',1)>0, AverageObjectsInBlock('
    + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMFConcentrationParamType.ANE_ParamName
    + ',1), If(CountObjectsInBlock('
    + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
    + ',2),AverageObjectsInBlock('
    + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMFConcentrationParamType.ANE_ParamName
    + '), If(CountObjectsInBlock('
    + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
    + ',3)>0, '
    + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMFConcentrationParamType.ANE_ParamName
    + ', $N/A))))';
end;

{ TGridMultiplier }

class function TGridMultiplier.ANE_ParamName: string;
begin
  result := kMFMultiplier;
end;

function TGridMultiplier.Value: string;
var
  IndexedParameterList: T_ANE_IndexedParameterList;
  AName: string;
begin
  IndexedParameterList := ParameterList as T_ANE_IndexedParameterList;
  AName := ModflowTypes.GetMFMultiplierLayerType.
    WriteMultiplierRoot(ModflowTypes.
    GetMFMultiplierLayerType.GetRow(IndexedParameterList.Index));
  result := AName + '.' + AName;
end;

{ TMultiplierParameters }

constructor TMultiplierParameters.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ModflowTypes.GetMFGridMultiplierParamType.Create(self, -1);
end;

{ TGridZone }

class function TGridZone.ANE_ParamName: string;
begin
  result := kMFZone;
end;

constructor TGridZone.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGridZone.Value: string;
var
  IndexedParameterList: T_ANE_IndexedParameterList;
  AName: string;
begin
  IndexedParameterList := ParameterList as T_ANE_IndexedParameterList;
  AName := ModflowTypes.GetMFZoneLayerType.
    WriteZoneRoot(IndexedParameterList.Index);
  result := AName + '.' + AName;
end;

{ TZoneParameters }

constructor TZoneParameters.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ModflowTypes.GetMFGridZoneParamType.Create(self, -1);
end;

{ TGridAniso }

class function TGridAniso.ANE_ParamName: string;
begin
  result := kMFGridAniso;
end;

function TGridAniso.Value: string;
begin
  result := ModflowTypes.GetMFAnistropyLayerType.ANE_LayerName + WriteIndex
    + '.' + ModflowTypes.GetMFAnistropyParamType.ANE_ParamName + WriteIndex;
end;

{ TGridETExtinctionDepth }

class function TGridETExtinctionDepth.ANE_ParamName: string;
begin
  result := kMFGridETExtinctionDepth;
end;

function TGridETExtinctionDepth.Units: string;
begin
  result := LengthUnit;
end;

function TGridETExtinctionDepth.Value: string;
begin
  result := ModflowTypes.GetETLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFETExtDepthParamType.ANE_ParamName;
end;

{ TGridLakeLocation }

class function TGridLakeLocation.ANE_ParamName: string;
begin
  result := kMFLakeLocation;
end;

constructor TGridLakeLocation.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGridLakeLocation.Value: string;
var
  NDIV: integer;
begin
  NDIV := LayerDiscretization(StrToInt(WriteIndex));

  result := 'If('
    + ModflowTypes.GetMFLakeLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFLakeNumberParamType.ANE_ParamName
    + '> 0&('
    + ModflowTypes.GetMFGridTopElevParamType.ANE_ParamName + WriteIndex
    + ' - ('
    + ModflowTypes.GetMFGridTopElevParamType.ANE_ParamName + WriteIndex
    + ' - '
    + ModflowTypes.GetMFGridBottomElevParamType.ANE_ParamName + WriteIndex
    + ') / '
    + IntToStr(NDIV)
    + ' / 2) >= '

  //    + ModflowTypes.GetMFGridBottomElevParamType.ANE_ParamName + WriteIndex
  //    + ')/2 >= '
  + ModflowTypes.GetMFLakeLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFLakeBottomParamType.ANE_ParamName
    + ','
    + ModflowTypes.GetMFLakeLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFLakeNumberParamType.ANE_ParamName
    + ',' + kNa + ')';
end;

{ TGridIbsPreconsolidationHead }

class function TGridIbsPreconsolidationHead.ANE_ParamName: string;
begin
  result := kIBSPreconsolidationHead;
end;

function TGridIbsPreconsolidationHead.Value: string;
begin
  result := ModflowTypes.GetMFIBSLayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFPreconsolidationHeadParamType.ANE_ParamName;
end;

{ TGridIbsElasticStorage }

class function TGridIbsElasticStorage.ANE_ParamName: string;
begin
  result := kIBSElasticStorageFactor;
end;

function TGridIbsElasticStorage.Value: string;
begin
  result := ModflowTypes.GetMFIBSLayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFElasticStorageFactorParamType.ANE_ParamName;
end;

{ TGridIbsInelasticStorage }

class function TGridIbsInelasticStorage.ANE_ParamName: string;
begin
  result := kIBSInelasticStorageFactor;
end;

function TGridIbsInelasticStorage.Value: string;
begin
  result := ModflowTypes.GetMFIBSLayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFInelasticStorageFactorParamType.ANE_ParamName;
end;

{ TGridIbsStartingCompaction }

class function TGridIbsStartingCompaction.ANE_ParamName: string;
begin
  result := kIBSStartingCompaction;
end;

function TGridIbsStartingCompaction.Value: string;
begin
  result := ModflowTypes.GetMFIBSLayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFStartingCompactionParamType.ANE_ParamName;
end;

{ TGridResElev }

class function TGridResElev.ANE_ParamName: string;
begin
  result := kMFGridResElev;
end;

function TGridResElev.Units: string;
begin
  result := LengthUnit;
end;

function TGridResElev.Value: string;
begin
  result := ModflowTypes.GetMFReservoirLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFReservoirLandSurfaceParamType.ANE_ParamName;
end;

{ TGridResKz }

class function TGridResKz.ANE_ParamName: string;
begin
  result := kMFGridResKz;
end;

function TGridResKz.Units: string;
begin
  result := LengthUnit + '/' + TimeUnit;
end;

function TGridResKz.Value: string;
begin
  result := ModflowTypes.GetMFReservoirLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFReservoirKzParamType.ANE_ParamName;
end;

{ TGridResThickness }

class function TGridResThickness.ANE_ParamName: string;
begin
  result := kMFGridResThickness;
end;

function TGridResThickness.Units: string;
begin
  result := LengthUnit;
end;

function TGridResThickness.Value: string;
begin
  result := ModflowTypes.GetMFReservoirLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFReservoirBedThicknessParamType.ANE_ParamName;
end;

{ TGridSFR }

class function TGridSFR.ANE_ParamName: string;
begin
  result := kMFGridSFRLocation;
end;

constructor TGridSFR.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

function TGridSFR.Value: string;
begin
  if frmModflow.cbSFRCalcFlow.Checked then
  begin
    result := 'If(CountObjectsInBlock('
      + ModflowTypes.GetMF2KSimpleStreamLayerType.ANE_LayerName + WriteIndex
      + '.'
      + ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName + ',1)>0'
      + '|CountObjectsInBlock('
      + ModflowTypes.GetMF2K8PointChannelStreamLayerType.ANE_LayerName +
      WriteIndex + '.'
      + ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName + ',1)>0'
      + '|CountObjectsInBlock('
      + ModflowTypes.GetMF2KFormulaStreamLayerType.ANE_LayerName + WriteIndex
      + '.'
      + ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName + ',1)>0'
      + '|CountObjectsInBlock('
      + ModflowTypes.GetMF2KTableStreamLayerType.ANE_LayerName + WriteIndex + '.'
      + ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName + ',1)>0'
      + ', 1, 0)'
  end
  else
  begin
    result := 'If(CountObjectsInBlock('
      + ModflowTypes.GetMF2KSimpleStreamLayerType.ANE_LayerName + WriteIndex
      + '.'
      + ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName + ',1)>0, 1, 0)'
  end;

end;

{ TGridETS_Surface }

class function TGridETS_Surface.ANE_ParamName: string;
begin
  result := kMFGridETSSurface;
end;

function TGridETS_Surface.Value: string;
begin
  result := ModflowTypes.GetMFSegmentedETLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetSegETSurfaceParamType.ANE_ParamName;
end;

{ TGridETS_ExtinctDepth }

class function TGridETS_ExtinctDepth.ANE_ParamName: string;
begin
  result := kMFGridETSExtinctionDepth;
end;

function TGridETS_ExtinctDepth.Value: string;
begin
  result := ModflowTypes.GetMFSegmentedETLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetSegETExtDepthParamType.ANE_ParamName;
end;

{ TGridETS_Layer }

class function TGridETS_Layer.ANE_ParamName: string;
begin
  result := kMFGridETSLayer;
end;

function TGridETS_Layer.Value: string;
begin
  result := ModflowTypes.GetMFSegmentedETLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFModflowLayerParamType.ANE_ParamName;
end;

{ TGridDrainReturn }

class function TGridDrainReturn.ANE_ParamName: string;
begin
  result := kMFGridDrainReturnLocation;
end;

function TGridDrainReturn.Value: string;
var
  CondFactorName: string;
begin
  if frmModflow.cbCondDrnRtn.Checked then
  begin
    CondFactorName :=
      ModflowTypes.GetMFDrainReturnConductanceParamType.ANE_ParamName;
  end
  else
  begin
    CondFactorName :=
      ModflowTypes.GetMFDrainReturnConductanceParamType.WriteFactorName;
  end;
  if frmMODFLOW.cbAltDrt.Checked then
  begin
    result := 'If(CountObjectsInBlock('
      + ModflowTypes.GetMFPointDrainReturnLayerType.ANE_LayerName + WriteIndex
      + '.' + ModflowTypes.GetMFDrainReturnConductanceParamType.ANE_ParamName
      + ',0)>0|CountObjectsInBlock('
      + ModflowTypes.GetMFLineDrainReturnLayerType.ANE_LayerName + WriteIndex
      + '.' + CondFactorName + ',1)>0';
    if frmModflow.cbUseAreaDrainReturns.Checked then
    begin
      result := result
        + '|'
        + ModflowTypes.GetMFAreaDrainReturnLayerType.ANE_LayerName
        + WriteIndex + '.'
        + CondFactorName + '!=$N/A'
    end;
    result := result
      + ', 1, 0)'

  end
  else
  begin

    result := 'If(CountObjectsInBlock('
      + ModflowTypes.GetMFPointDrainReturnLayerType.ANE_LayerName + WriteIndex
      + '.' + ModflowTypes.GetMFDrainReturnConductanceParamType.ANE_ParamName
      + ',0)>0|CountObjectsInBlock('
      + ModflowTypes.GetMFLineDrainReturnLayerType.ANE_LayerName + WriteIndex
      + '.' + CondFactorName + ',1)>0';

    if frmModflow.cbUseAreaDrainReturns.Checked then
    begin
      result := result
        + '|CountObjectsInBlock('
        + ModflowTypes.GetMFAreaDrainReturnLayerType.ANE_LayerName + WriteIndex
        + '.'
        + CondFactorName
        + ',2,3)>0';
      if frmModflow.cbAreaDrainRetrunContour.Enabled
       and not frmModflow.cbAreaDrainRetrunContour.Checked then
      begin
        result := result
          + '|' + ModflowTypes.GetMFAreaDrainReturnLayerType.ANE_LayerName
          + WriteIndex + '.'
          + CondFactorName + '!=$N/A'
      end;

    end;
    result := result + ', 1, 0)'
  end;
end;

{ TGridCHD }

class function TGridCHD.ANE_ParamName: string;
begin
  result := kMFGridCHDLocation;
end;

constructor TGridCHD.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

function TGridCHD.Value: string;
begin
  result :=
    'If(CountObjectsInBlock('
    + ModflowTypes.GetMFPointLineCHD_LayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFCHD_StartHeadParamType.ANE_ParamName + '1' + ',0,1)';

  if frmModflow.cbUseAreaCHD.Checked then
  begin
    result := result
      + '+ If(';
    if not frmModflow.cbAreaCHDContour.Enabled
      or frmModflow.cbAreaCHDContour.Checked then
    begin
      result := result
        + '+ CountObjectsInBlock('
        + ModflowTypes.GetMFAreaCHD_LayerType.ANE_LayerName + WriteIndex + '.'
        + ModflowTypes.GetMFCHD_StartHeadParamType.ANE_ParamName + '1' + ',2,3)'
        + '>0&';
    end;

    result := result
      + '('
      + ModflowTypes.GetMFAreaCHD_LayerType.ANE_LayerName + WriteIndex + '.'
      + ModflowTypes.GetMFCHD_StartHeadParamType.ANE_ParamName + '1'
      + '!=$N/A&'
      + ModflowTypes.GetMFAreaCHD_LayerType.ANE_LayerName + WriteIndex + '.'
      + ModflowTypes.GetMFCHD_StartHeadParamType.ANE_ParamName + '1'
      + '!=$N/A)';

    result := result
      + ',1,0)';
  end;
  result := result
    + ', 1, 0)'
end;

{ TGridMT3DICBUND }

class function TGridMT3DICBUND.ANE_ParamName: string;
begin
  result := kMT3DICBUND;
end;

constructor TGridMT3DICBUND.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited; // Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridMT3DICBUND.Units: string;
begin
  result := '';
end;

function TGridMT3DICBUND.Value: string;
begin
  if frmModflow.cbSSM.Checked and frmModflow.cbMT3D_TVC.Checked then
  begin
    result := 'If((CountObjectsInBlock('
      + ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName + WriteIndex
      + ',0)>0)|'
      + ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName + WriteIndex
      + '.' + ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName + '1'
      + '!=$N/A,-1, 1)*'
      + ModflowTypes.GetGridMT3DActiveCellParamClassType.ANE_ParamName
      + WriteIndex;
  end
  else
  begin
    result := ModflowTypes.GetGridMT3DActiveCellParamClassType.ANE_ParamName
      + WriteIndex;
  end;

end;

{ TGridMT3DActiveCell }

class function TGridMT3DActiveCell.ANE_ParamName: string;
begin
  result := kMT3DActiveCell;
end;

constructor TGridMT3DActiveCell.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited; // Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TGridMT3DActiveCell.Units: string;
begin
  result := '';
end;

function TGridMT3DActiveCell.Value: string;
begin
  result := 'If('
    + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
    + '=0, 0, If(IsLayerEmpty('
    + ModflowTypes.GetMT3DDomOutlineLayerType.ANE_LayerName
    + '), '
    + ModflowTypes.GetMT3DInactiveAreaLayerType.ANE_LayerName + WriteIndex
    + '!=0, '
    + ModflowTypes.GetMT3DDomOutlineLayerType.ANE_LayerName
    + '!=$N/A&'
    + ModflowTypes.GetMT3DInactiveAreaLayerType.ANE_LayerName + WriteIndex
    + '!=0))';
  {  result := 'If('
      + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
      + '=0, 0, If(('
      + ModflowTypes.GetMT3DDomOutlineLayerType.ANE_LayerName
      + '!=' + kNA + '&'
      + ModflowTypes.GetMT3DInactiveAreaLayerType.ANE_LayerName + WriteIndex
      + '!=0)|(CountObjectsInBlock('
      + ModflowTypes.GetMT3DDomOutlineLayerType.ANE_LayerName
      + ')>0&(CountObjectsInBlock('
      + ModflowTypes.GetMT3DAreaConstantConcLayerType.ANE_LayerName + WriteIndex
      + ',0,1)>0&'
      + ModflowTypes.GetMT3DInactiveAreaLayerType.ANE_LayerName + WriteIndex
      + '!=0)), 1, 0))' }
end;

{ TGridMT3DInitConcCell }

class function TGridMT3DInitConcCell.ANE_ParamName: string;
begin
  result := kMT3DInitConcCell;
end;

function TGridMT3DInitConcCell.ConcentrationParamString: string;
begin
  result := ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConcCell.ConstantConcentrationString: string;
begin
  result := ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConcCell.InitialConcentrationString: string;
begin
  result := ModflowTypes.GetMT3DInitConcParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConcCell.MassParamString: string;
begin
  result := ModflowTypes.GetMT3DMassParamClassType.ANE_ParamName;
end;  

{ TGridMT3DTimeVaryConcCell }

class function TGridMT3DTimeVaryConcCell.ANE_ParamName: string;
begin
  result := kMT3DTimeVaryConcCell;
end;

function TGridMT3DTimeVaryConcCell.Value: string;
begin
  result := 'If('
    {    + 'CountObjectsInBlock('
+ ModflowTypes.GetMT3DPointTimeVaryConcLayerType.ANE_LayerName + WriteIndex
+ '.'
+ ModflowTypes.GetMT3DTopElevParamClassType.ANE_ParamName
+ ',0)>0|'   }
  + 'CountObjectsInBlock('
    + ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName
    + '1,0,1)>0|(('
    + ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName
    + '1!=$N/A)&('
    + 'CountObjectsInBlock('
    + ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName
    + '1,3)>0'
    + ')),'
    + ' 1, 0)';

end;

{ TGridMT3DObsLocCell }

class function TGridMT3DObsLocCell.ANE_ParamName: string;
begin
  result := kMT3DObsLocCell;
end;

function TGridMT3DObsLocCell.Units: string;
begin
  result := '';
end;

function TGridMT3DObsLocCell.Value: string;
begin
  result := 'If(CountObjectsInBlock('
    + ModflowTypes.GetMT3DObservationsLayerType.ANE_LayerName + WriteIndex
    + ',0)>0|CountObjectsInBlock('
    + ModflowTypes.GetMT3DObservationsLayerType.ANE_LayerName + WriteIndex
    + ',1)>0|'
    + ModflowTypes.GetMT3DObservationsLayerType.ANE_LayerName + WriteIndex
    + '!=$N/A, 1, 0)';

end;

{ TGridMT3DLongDispCell }

class function TGridMT3DLongDispCell.ANE_ParamName: string;
begin
  result := kMT3DLongDispCell;
end;

function TGridMT3DLongDispCell.Units: string;
begin
  result := 'L';
end;

function TGridMT3DLongDispCell.Value: string;
begin
  result := ModflowTypes.GetHydraulicCondLayerType.ANE_LayerName + WriteIndex
    + '.' + ModflowTypes.GetMT3DLongDispParamClassType.ANE_ParamName;
end;

{ TCustomGridMT3DInitConcCell }

function TCustomGridMT3DInitConcCell.Units: string;
begin
  result := 'M/L^3';
end;

function TCustomGridMT3DInitConcCell.Value: string;
begin
  if frmModflow.cbSSM.Checked then
  begin
    result := '';
    if frmModflow.cbMT3D_TVC.Checked then
    begin
      result := 'If(CountObjectsInBlock('
        + ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName + WriteIndex
        + '.'
        + ConstantConcentrationString + '1'
        + ',0)>0, AverageObjectsInBlock('
        + ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName + WriteIndex
        + '.'
        + ConstantConcentrationString + '1'
        + ',0)'
        + ', If('
        + ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName + WriteIndex
        + '.'
        + ConstantConcentrationString + '1'
        + '!=$N/A, '
        + ModflowTypes.GetMT3DAreaTimeVaryConcLayerType.ANE_LayerName + WriteIndex
        + '.'
        + ConstantConcentrationString + '1'
        + ', '
    end;

    result := result + 'If(('
      + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
      + '>=0),'


      + 'If(CountObjectsInBlock('
      + ModflowTypes.GetMT3DPointInitConcLayerType.ANE_LayerName + WriteIndex
      + '.'
      + InitialConcentrationString
      + ',0)>0, AverageObjectsInBlock('
      + ModflowTypes.GetMT3DPointInitConcLayerType.ANE_LayerName + WriteIndex
      + '.'
      + InitialConcentrationString
      + ',0), '
      + ModflowTypes.GetMT3DAreaInitConcLayerType.ANE_LayerName + WriteIndex
      + '.'
      + InitialConcentrationString
      + ')'


      + ',If('
      + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
      + '.'
      + ConcentrationParamString + '1'
      + '!=$N/A,'
      + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
      + '.'
      + ConcentrationParamString + '1'
      + ',AverageObjectsInBlock('
      + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
      + '.'
      + ConcentrationParamString + '1,0,1)'
      + '))';
    if frmModflow.cbMT3D_TVC.Checked then
    begin
      result := result + '))';
    end;
  end
  else
  begin
    result :=
      'If(CountObjectsInBlock('
      + ModflowTypes.GetMT3DPointInitConcLayerType.ANE_LayerName + WriteIndex
      + '.'
      + InitialConcentrationString
      + ',0)>0, AverageObjectsInBlock('
      + ModflowTypes.GetMT3DPointInitConcLayerType.ANE_LayerName + WriteIndex
      + '.'
      + InitialConcentrationString
      + ',0)'
      + ', '
      + ModflowTypes.GetMT3DAreaInitConcLayerType.ANE_LayerName + WriteIndex
      + '.'
      + InitialConcentrationString
      + ')';
  end;

end;

{ TGridMT3DInitConc2Cell }

class function TGridMT3DInitConc2Cell.ANE_ParamName: string;
begin
  result := kMT3DInitConcBCell;
end;

function TGridMT3DInitConc2Cell.ConcentrationParamString: string;
begin
  result := ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConc2Cell.ConstantConcentrationString: string;
begin
  result := ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConc2Cell.InitialConcentrationString: string;
begin
  result := ModflowTypes.GetMT3DInitConc2ParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConc2Cell.MassParamString: string;
begin
  result := ModflowTypes.GetMT3DMass2ParamClassType.ANE_ParamName;
end;

{ TGridMT3DInitConc3Cell }

class function TGridMT3DInitConc3Cell.ANE_ParamName: string;
begin
  result := kMT3DInitConcCCell;
end;

function TGridMT3DInitConc3Cell.ConcentrationParamString: string;
begin
  result := ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConc3Cell.ConstantConcentrationString: string;
begin
  result := ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConc3Cell.InitialConcentrationString: string;
begin
  result := ModflowTypes.GetMT3DInitConc3ParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConc3Cell.MassParamString: string;
begin
  result := ModflowTypes.GetMT3DMass3ParamClassType.ANE_ParamName;
end;

{ TGridMT3DInitConc4Cell }

class function TGridMT3DInitConc4Cell.ANE_ParamName: string;
begin
  result := kMT3DInitConcDCell;
end;

function TGridMT3DInitConc4Cell.ConcentrationParamString: string;
begin
  result := ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConc4Cell.ConstantConcentrationString: string;
begin
  result := ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConc4Cell.InitialConcentrationString: string;
begin
  result := ModflowTypes.GetMT3DInitConc4ParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConc4Cell.MassParamString: string;
begin
  result := ModflowTypes.GetMT3DMass4ParamClassType.ANE_ParamName;
end;

{ TGridMT3DInitConc5Cell }

class function TGridMT3DInitConc5Cell.ANE_ParamName: string;
begin
  result := kMT3DInitConcECell;
end;

function TGridMT3DInitConc5Cell.ConcentrationParamString: string;
begin
  result := ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConc5Cell.ConstantConcentrationString: string;
begin
  result := ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConc5Cell.InitialConcentrationString: string;
begin
  result := ModflowTypes.GetMT3DInitConc5ParamClassType.ANE_ParamName;
end;

function TGridMT3DInitConc5Cell.MassParamString: string;
begin
  result := ModflowTypes.GetMT3DMass5ParamClassType.ANE_ParamName;
end;

{ TGridMT3DMassFluxCell }

class function TGridMT3DMassFluxCell.ANE_ParamName: string;
begin
  result := kMT3DMassFluxCell;
end;

function TGridMT3DMassFluxCell.Value: string;
begin
  result := 'If('
    + 'CountObjectsInBlock('
    + ModflowTypes.GetMT3DMassFluxLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMT3DMassFluxAParamClassType.ANE_ParamName
    + '1,0)>0, 1, 0)';
end;

{ TGridMNW_Location }

class function TGridMNW_Location.ANE_ParamName: string;
begin
  result := kMFGridMNWLocation;
end;

function TGridMNW_Location.Value: string;
begin
  result := 'If(CountObjectsInBlock('
    + ModflowTypes.GetMFMNW_LayerType.ANE_LayerName
    + '.'
    + ModflowTypes.GetMFMNW_StressParamClassType.ANE_ParamName
    + '1,0,1), 1, $N/A)';
end;


{ TGridMOCParticleLayerCount }

class function TGridMOCParticleLayerCount.ANE_ParamName: string;
begin
  result := kMocParticleLayerCount;
end;

constructor TGridMOCParticleLayerCount.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGridMOCParticleLayerCount.Value: string;
begin
  result :=
    ModflowTypes.GetMOCInitialParticlePlacementLayerType.ANE_LayerName
    + WriteIndex
    + '.'
    + ModflowTypes.GetMFLayerCountParamType.ANE_ParamName
end;

{ TGridMOCParticleRowCount }

class function TGridMOCParticleRowCount.ANE_ParamName: string;
begin
  result := kMocParticleRowCount;
end;

function TGridMOCParticleRowCount.Value: string;
begin
  result :=
    ModflowTypes.GetMOCInitialParticlePlacementLayerType.ANE_LayerName
    + WriteIndex
    + '.'
    + ModflowTypes.GetMFRowCountParamType.ANE_ParamName
end;

{ TGridMOCParticleColumnCount }

class function TGridMOCParticleColumnCount.ANE_ParamName: string;
begin
  result := kMocParticleColumnCount;
end;

function TGridMOCParticleColumnCount.Value: string;
begin
  result :=
    ModflowTypes.GetMOCInitialParticlePlacementLayerType.ANE_LayerName
    + WriteIndex
    + '.'
    + ModflowTypes.GetMFColumnCountParamType.ANE_ParamName
end;

{ TGridMocParticleLocation }

class function TGridMocParticleLocation.ANE_ParamName: string;
begin
  result := kMocParticleLocation;
end;

constructor TGridMocParticleLocation.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGridMocParticleLocation.Value: string;
begin
  result := 'If(CountObjectsInBlock('
    + ModflowTypes.GetMOCInitialParticlePlacementLayerType.ANE_LayerName
    + WriteIndex
    + '.Column Count,0,1,3)>0, 1, $N/A)';
end;

{ TGridGwtUppBoundConc }

class function TGridGwtUppBoundConc.ANE_ParamName: string;
begin
  result := rsUpperBoundConc
end;

function TGridGwtUppBoundConc.Value: string;
begin
  result :=
    ModflowTypes.GetMOCUpperBoundaryConcentrationLayerType.ANE_LayerName
    + '.'
    + ModflowTypes.GetMFUpperBoundaryConcentrationParamType.ANE_ParamName;
end;

{ TGridGwtLowBoundConc }

class function TGridGwtLowBoundConc.ANE_ParamName: string;
begin
  result := rsLowerBoundConc;
end;

function TGridGwtLowBoundConc.Value: string;
begin
  result :=
    ModflowTypes.GetMOCLowerBoundaryConcentrationLayerType.ANE_LayerName
    + '.'
    + ModflowTypes.GetMFLowerBoundaryConcentrationParamType.ANE_ParamName;
end;

{ TGridMocParticleObservation }

class function TGridMocParticleObservation.ANE_ParamName: string;
begin
  result := rsGWTParticleObservation;
end;

function TGridMocParticleObservation.Value: string;
var
  LayParam: string;
begin
  LayParam :=
    ModflowTypes.GetMFMoc3dParticleObsLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMFMoc3dParticleObsParamType.ANE_ParamName;
  result := 'CountObjectsInBlock(' + LayParam + ', 0,1) + ' + LayParam;
end;

{ TGridGwtLateralBoundConc }

class function TGridGwtLateralBoundConc.ANE_ParamName: string;
begin
  result := rsLateralBoundConc;
end;

function TGridGwtLateralBoundConc.Value: string;
begin
  result :=
    ModflowTypes.GetMOCLateralBoundaryConcentrationLayerType.ANE_LayerName
    + WriteIndex + '.'
    + ModflowTypes.GetMFLateralBoundaryConcentrationParamType.ANE_ParamName;
end;

{ TGridUzfSaturatedKz }

class function TGridUzfSaturatedKz.ANE_ParamName: string;
begin
  result := kUzfSaturatedKz
end;

function TGridUzfSaturatedKz.Value: string;
begin
  result :=
    ModflowTypes.GetMFUzfFlowLayerType.ANE_LayerName
     + '.'
    + ModflowTypes.GetMFUzfSaturatedKzParamType.ANE_ParamName;
end;

{ TGridUzfBrooksCoreyEpsilon }

class function TGridUzfBrooksCoreyEpsilon.ANE_ParamName: string;
begin
  result := kUzfBrooksCoreyEpsilon
end;

function TGridUzfBrooksCoreyEpsilon.Value: string;
begin
  result :=
    ModflowTypes.GetMFUzfFlowLayerType.ANE_LayerName
     + '.'
    + ModflowTypes.GetMFUzfBrooksCoreyEpsilonParamType.ANE_ParamName;
end;

{ TGridUzfSaturatedWaterContent }

class function TGridUzfSaturatedWaterContent.ANE_ParamName: string;
begin
  result := kUzfSaturatedWaterContent;
end;

function TGridUzfSaturatedWaterContent.Value: string;
begin
  result :=
    ModflowTypes.GetMFUzfFlowLayerType.ANE_LayerName
     + '.'
    + ModflowTypes.GetMFUzfSaturatedWaterContentParamType.ANE_ParamName;
end;

{ TGridUzfInitialWaterContent }

class function TGridUzfInitialWaterContent.ANE_ParamName: string;
begin
  result := kUzfInitialWaterContent;
end;

function TGridUzfInitialWaterContent.Value: string;
begin
  result :=
    ModflowTypes.GetMFUzfFlowLayerType.ANE_LayerName
     + '.'
    + ModflowTypes.GetMFUzfInitialWaterContentParamType.ANE_ParamName;
end;

{ TGridUzfExtinctionDepth }

class function TGridUzfExtinctionDepth.ANE_ParamName: string;
begin
  result := kUzfExtinctionDepth;
end;

function TGridUzfExtinctionDepth.Value: string;
begin
  result :=
    ModflowTypes.GetMFUzfFlowLayerType.ANE_LayerName
     + '.'
    + ModflowTypes.GetMFUzfExtinctionDepthParamType.ANE_ParamName;
end;

{ TGridUzfExtinctionWaterContent }

class function TGridUzfExtinctionWaterContent.ANE_ParamName: string;
begin
  result := kUzfExtinctionWaterContent;
end;

function TGridUzfExtinctionWaterContent.Value: string;
begin
  result :=
    ModflowTypes.GetMFUzfFlowLayerType.ANE_LayerName
     + '.'
    + ModflowTypes.GetMFUzfExtinctionWaterContentParamType.ANE_ParamName;
end;

{ TGridUzfModflowLayerParam }

class function TGridUzfModflowLayerParam.ANE_ParamName: string;
begin
  result := kUzfModflowLayer;
end;

constructor TGridUzfModflowLayerParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGridUzfModflowLayerParam.Value: string;
begin
  result :=
    ModflowTypes.GetMFUzfLayerLayerType.ANE_LayerName
     + '.'
    + ModflowTypes.GetMFUzfLayerParamType.ANE_ParamName;
end;

{ TGridUzfDownstreamStreamOrLake }

class function TGridUzfDownstreamStreamOrLake.ANE_ParamName: string;
begin
  result := kUzfDownstreamStreamOrLake;
end;

constructor TGridUzfDownstreamStreamOrLake.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGridUzfDownstreamStreamOrLake.Value: string;
begin
  result :=
    ModflowTypes.GetMFUzfStreamLakeLayerType.ANE_LayerName
     + '.'
    + ModflowTypes.GetMFUzfStreamLakeParamType.ANE_ParamName;
end;

{ TGridUzfOutputChoice }

class function TGridUzfOutputChoice.ANE_ParamName: string;
begin
  result := kUzfOutputChoice;
end;

constructor TGridUzfOutputChoice.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGridUzfOutputChoice.Value: string;
begin
  result := ModflowTypes.GetMFUzfOutputLayerType.ANE_LayerName
    + '.'
    + ModflowTypes.GetMFUzfOutputParamType.ANE_ParamName;
end;

{ TGridGwmZone }

class function TGridGwmZone.ANE_ParamName: string;
begin
  result := 'GWM Storage Zone';
end;

constructor TGridGwmZone.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TGridGwmZone.Value: string;
begin
  result := ModflowTypes.GetMFGwmStorageStateLayerType.ANE_LayerName + WriteIndex
    + '.'
    + ModflowTypes.GetMF_GwmZoneNumberParamType.ANE_ParamName;
end;

end.

