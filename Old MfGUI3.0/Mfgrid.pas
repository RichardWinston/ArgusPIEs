unit MFGrid;

interface

{MFGrid defines the "MODFLOW FD Grid" layer
 and associated parameters and Parameterlists.}

uses ANE_LayerUnit;

type
  TGridETSurf = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridETLayerParam = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

  TGridRechElev = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridRechLayerParam = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
      override;
  end;

  TIBoundGridParam = class(T_ANE_GridParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridTopElev = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridBottomElev = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridThickness = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridInitialHead = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridKx = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridKz = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridTrans = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridVCont = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridSpecYield = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridSpecStor = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TGridConfStor = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
//    function Units : string; override;
  end;

  TGridWetting = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TGridWell = class(T_ANE_GridParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TGridRiver = class(T_ANE_GridParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TGridDrain = class(T_ANE_GridParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TGridGHB = class(T_ANE_GridParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TGridFHB = class(T_ANE_GridParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TGridHFB = class(T_ANE_GridParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TGridStream = class(T_ANE_GridParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TGridMOCInitConc = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TGridMOCSubGrid = class(T_ANE_GridParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TGridMOCParticleRegen = class(T_ANE_GridParam)
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TGridMOCPorosity = class(T_ANE_GridParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TGridZoneBudget = class(T_ANE_GridParam)
  public
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGridModpathZone = class(T_ANE_GridParam)
  public
    Constructor Create(AParameterList : T_ANE_ParameterList;
                Index : Integer); override;
    class function ANE_ParamName: string; override;
    function Value: string; override;
  end;

  TGeologicUnitParameters = class(T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer); override;
  end;

  TMFGridLayer = Class(T_ANE_GridLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables, SysUtils, MODFLOWPieDescriptors, ModflowUnit;

ResourceString
  kMFGrid = 'MODFLOW FD Grid';
  kMFGridETSurface = 'ET Surface Elevation';
  kMFGridETLayer = 'ET Layer';
  kMFGridRechElev = 'Recharge Elevation';
  kMFGridIBound = 'IBOUND Unit';
  kMFGridTop = 'Elev Top Unit';
  kMFGridBottom = 'Elev Bot Unit';
  kMFGridThickness = 'Thickness Unit';
  kMFGridInitialHead = 'Initial Head Unit';
  kMFGridKx = 'Kx Unit';
  kMFGridKz = 'Kz Unit';
  kMFGridSpecYield = 'Sp_Yield Unit';
  kMFGridSpecStor = 'Sp_Storage Unit';
  kMFGridWetting = 'Wetting Unit';
  kMFGridWelLocation = 'Well Location Unit';
  kMFGridRivLocation = 'River Location Unit';
  kMFGridDrainLocation = 'Drain Location Unit';
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
  kMFGridTrans = 'Trans Unit';
  kMFGridVcont = 'Vert Cond Unit';
  kMFGridConfStorage = 'Conf Storage Coef Unit';
  kMFGridRechargeLayer = 'Recharge Layer';

class Function TGridETSurf.ANE_ParamName : string ;
begin
  result := kMFGridETSurface;
end;

function TGridETSurf.Value : string;
begin
  result := ModflowTypes.GetETLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFETSurfaceParamType.ANE_ParamName;
end;

function TGridETSurf.Units : string;
begin
  result := 'L';
end;

//--------------------------------------------------
class Function TGridRechElev.ANE_ParamName : string ;
begin
  result := kMFGridRechElev;
end;

function TGridRechElev.Value : string;
begin
  result := ModflowTypes.GetRechargeLayerType.ANE_LayerName + '.'
    + ModflowTypes.GetMFRechElevParamType.ANE_ParamName;;
end;

function TGridRechElev.Units : string;
begin
  result := 'L';
end;

//--------------------------------------------------
Constructor TIBoundGridParam.Create(AParameterList : T_ANE_ParameterList;
            Index : Integer);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TIBoundGridParam.ANE_ParamName : string ;
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
{      result := 'If((CountObjectsInBlock('
        + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName
        + WriteIndex
        + ',0,1)>0)|('
        + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName
        + WriteIndex
        + '!=$N/A),-1, 1)*BlockIsActive()*'
        + ModflowTypes.GetInactiveLayerType.ANE_LayerName
        + WriteIndex;     }
{      result := 'If((CountObjectsInBlock('
        + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName
        + WriteIndex
        + ',0,1)>0)|(CountObjectsInBlock('
        + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName
        + WriteIndex
        + ',3)>0&'
        + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName
        + WriteIndex
        + '!=$N/A),-1, 1)*BlockIsActive()*'
        + ModflowTypes.GetInactiveLayerType.ANE_LayerName
        + WriteIndex;   }
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
          + '!=$N/A),-1, 1)*(BlockIsActive()';
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

function TIBoundGridParam.Units : string;
begin
  Result := '-1 or 0  or 1';
end;

//--------------------------------------------------
class Function TGridTopElev.ANE_ParamName : string ;
begin
  result := kMFGridTop;
end;

function TGridTopElev.Value : string;
begin
  result := ModflowTypes.GetMFTopElevLayerType.ANE_LayerName + WriteIndex;
end;

function TGridTopElev.Units : string;
begin
  result := 'L';
end;

//--------------------------------------------------
class Function TGridBottomElev.ANE_ParamName : string ;
begin
  result := kMFGridBottom;
end;

function TGridBottomElev.Value : string;
begin
  result := ModflowTypes.GetBottomElevLayerType.ANE_LayerName + WriteIndex;
end;

function TGridBottomElev.Units : string;
begin
  result := 'L';
end;

//--------------------------------------------------
class Function TGridThickness.ANE_ParamName : string ;
begin
  result := kMFGridThickness;
end;

function TGridThickness.Value : string;
begin
  result := ModflowTypes.GetMFGridTopElevParamType.ANE_ParamName + WriteIndex + '-'
         + ModflowTypes.GetMFGridBottomElevParamType.ANE_ParamName + WriteIndex;
end;

function TGridThickness.Units : string;
begin
  result := 'L';
end;

//--------------------------------------------------
class Function TGridInitialHead.ANE_ParamName : string ;
begin
  result := kMFGridInitialHead;
end;

function TGridInitialHead.Value : string;
begin
  case frmMODFLOW.comboCustomize.ItemIndex of
    0:
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
          + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName  + WriteIndex
          + ')';
      end;
    1:
      begin
        {result := 'If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0,1)>0, ( (SumObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0,1) )/ (CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0,1))), If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',3)>0, Interpolate('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + '), '
          + ModflowTypes.GetInitialHeadLayerType.ANE_LayerName + WriteIndex
          + ')) * Abs('
          + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
          +')'; }
          {result := 'If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0,1)>0, ( (AverageObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0,1) )), If('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + '!=$N/A, '
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ', '
          + ModflowTypes.GetInitialHeadLayerType.ANE_LayerName + WriteIndex
          + ')) * Abs('
          + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
          +')';}
        result := 'If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0,1)>0, ( (AverageObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0,1) )), If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',2)>0, AverageObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + '), If(Prescribed Head Unit1!=$N/A, '
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ', '
          + ModflowTypes.GetInitialHeadLayerType.ANE_LayerName + WriteIndex
          + '))) * Abs('
          + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
          +')';
      end;
    2:
      begin
        {result := 'If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0)>0, SumObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0) / CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0), If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',1), SumObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',1) / CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',1), If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',3)>0, Interpolate('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + '), '
          + ModflowTypes.GetInitialHeadLayerType.ANE_LayerName + WriteIndex
          + '))) * Abs('
          + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
          + ')'; }
{          result := 'If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0)>0, AverageObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',0), If(CountObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',1)>0, AverageObjectsInBlock('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ',1), If(('
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + '!=$N/A), '
          + ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName + WriteIndex
          + ', '
          + ModflowTypes.GetInitialHeadLayerType.ANE_LayerName + WriteIndex
          + '))) * Abs('
          + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex
          + ')' }
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
      end;
  end;
end;

function TGridInitialHead.Units : string;
begin
  result := 'L';
end;

//--------------------------------------------------
class Function TGridKx.ANE_ParamName : string ;
begin
  result := kMFGridKx;
end;

function TGridKx.Value : string;
begin
  result := ModflowTypes.GetHydraulicCondLayerType.ANE_LayerName + WriteIndex
         + '.' + ModflowTypes.GetMFKxParamType.ANE_ParamName;
end;

function TGridKx.Units : string;
begin
  result := 'L/T';
end;

//--------------------------------------------------
class Function TGridKz.ANE_ParamName : string ;
begin
  result := kMFGridKz;
end;

function TGridKz.Value : string;
begin
  result := ModflowTypes.GetHydraulicCondLayerType.ANE_LayerName + WriteIndex
         + '.' + ModflowTypes.GetMFKzParamType.ANE_ParamName;
end;

function TGridKz.Units : string;
begin
  result := 'L/T';
end;

//--------------------------------------------------
class Function TGridSpecYield.ANE_ParamName : string ;
begin
  result := kMFGridSpecYield;
end;

function TGridSpecYield.Value : string;
begin
  result := ModflowTypes.GetMFSpecYieldLayerType.ANE_LayerName + WriteIndex;
end;

function TGridSpecYield.Units : string;
begin
  result := 'L^3/L^3';
end;

//--------------------------------------------------
class Function TGridSpecStor.ANE_ParamName : string ;
begin
  result := kMFGridSpecStor;
end;

function TGridSpecStor.Value : string;
begin
  result := ModflowTypes.GetMFSpecStorageLayerType.ANE_LayerName + WriteIndex;
end;

function TGridSpecStor.Units : string;
begin
  result := '1/L';
end;

//--------------------------------------------------
class Function TGridWetting.ANE_ParamName : string ;
begin
  result := kMFGridWetting;
end;

function TGridWetting.Value : string;
begin
  result := 'If(' + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex + ','
     + ModflowTypes.GetMFWettingLayerType.ANE_LayerName + WriteIndex + '.'
     + ModflowTypes.GetMFWettingThreshParamType.ANE_ParamName + WriteIndex + ' * '
     + ModflowTypes.GetMFWettingLayerType.ANE_LayerName + WriteIndex + '.'
     + ModflowTypes.GetMFWettingFlagParamType.ANE_ParamName + ',0)';
end;

//--------------------------------------------------
Constructor TGridWell.Create(AParameterList : T_ANE_ParameterList;
            Index : Integer);
begin
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TGridWell.ANE_ParamName : string ;
begin
  result := kMFGridWelLocation;
end;

function TGridWell.Value : string;
begin
  result := 'If(CountObjectsInBlock('
    + ModflowTypes.GetMFWellLayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFWellTopParamType.ANE_ParamName + ',0)>0, 1, 0)'
end;

//--------------------------------------------------
Constructor TGridRiver.Create(AParameterList : T_ANE_ParameterList;
            Index : Integer);
begin
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TGridRiver.ANE_ParamName : string ;
begin
  result := kMFGridRivLocation;
end;

function TGridRiver.Value : string;
begin
  if frmMODFLOW.cbAltRiv.Checked then
  begin
    result := 'If(CountObjectsInBlock('
         + ModflowTypes.GetMFLineRiverLayerType.ANE_LayerName + WriteIndex
         + '.' + ModflowTypes.GetMFConductanceParamType.ANE_ParamName + ',1)>0|' 
         + ModflowTypes.GetMFAreaRiverLayerType.ANE_LayerName
         + WriteIndex + '.'
         + ModflowTypes.GetMFConductanceParamType.ANE_ParamName + '!=$N/A, 1, 0)'
  end
  else
  begin
    result := 'If(CountObjectsInBlock('
         + ModflowTypes.GetMFLineRiverLayerType.ANE_LayerName + WriteIndex
         + '.' + ModflowTypes.GetMFConductanceParamType.ANE_ParamName + ',1)>0|CountObjectsInBlock('
         + ModflowTypes.GetMFAreaRiverLayerType.ANE_LayerName + WriteIndex
         + '.' + ModflowTypes.GetMFConductanceParamType.ANE_ParamName
         + ',2)>0|' + ModflowTypes.GetMFAreaRiverLayerType.ANE_LayerName
         + WriteIndex + '.'
         + ModflowTypes.GetMFConductanceParamType.ANE_ParamName + '!=$N/A, 1, 0)'
  end;
end;

//--------------------------------------------------
Constructor TGridDrain.Create(AParameterList : T_ANE_ParameterList;
            Index : Integer);
begin
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TGridDrain.ANE_ParamName : string ;
begin
  result := kMFGridDrainLocation;
end;

function TGridDrain.Value : string;
begin
  if frmMODFLOW.cbAltDrn.Checked then
  begin
    result := 'If(CountObjectsInBlock('
           + ModflowTypes.GetLineDrainLayerType.ANE_LayerName + WriteIndex
           + '.' + ModflowTypes.GetMFConductanceParamType.ANE_ParamName + ',1)>0|'
           + ModflowTypes.GetAreaDrainLayerType.ANE_LayerName
           + WriteIndex + '.'
           + ModflowTypes.GetMFConductanceParamType.ANE_ParamName + '!=$N/A, 1, 0)'

  end
  else
  begin

    result := 'If(CountObjectsInBlock('
           + ModflowTypes.GetLineDrainLayerType.ANE_LayerName + WriteIndex
           + '.' + ModflowTypes.GetMFConductanceParamType.ANE_ParamName + ',1)>0|CountObjectsInBlock('
           + ModflowTypes.GetAreaDrainLayerType.ANE_LayerName + WriteIndex + '.'
           + ModflowTypes.GetMFConductanceParamType.ANE_ParamName
           + ',2)>0|' + ModflowTypes.GetAreaDrainLayerType.ANE_LayerName
           + WriteIndex + '.'
           + ModflowTypes.GetMFConductanceParamType.ANE_ParamName + '!=$N/A, 1, 0)'
  end;
end;

//--------------------------------------------------
Constructor TGridGHB.Create(AParameterList : T_ANE_ParameterList;
            Index : Integer);
begin
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TGridGHB.ANE_ParamName : string ;
begin
  result := kMFGridGHBLocation;
end;

function TGridGHB.Value : string;
begin
  result := 'If(CountObjectsInBlock('
         + ModflowTypes.GetPointGHBLayerType.ANE_LayerName + WriteIndex
         + '.' + ModflowTypes.GetMFConductanceParamType.ANE_ParamName + ',0)>0|CountObjectsInBlock('
         + ModflowTypes.GetLineGHBLayerType.ANE_LayerName + WriteIndex + '.'
         + ModflowTypes.GetMFConductanceParamType.ANE_ParamName
         + ',1)>0|CountObjectsInBlock('
         + ModflowTypes.GetAreaGHBLayerType.ANE_LayerName
         + WriteIndex + '.' + ModflowTypes.GetMFConductanceParamType.ANE_ParamName + ',2)>0|'
         + ModflowTypes.GetAreaGHBLayerType.ANE_LayerName + WriteIndex + '.'
         + ModflowTypes.GetMFConductanceParamType.ANE_ParamName
         + '!=$N/A, 1, 0)'
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
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

function TGridStream.Value: string;
begin
  result := 'If(CountObjectsInBlock('
    + ModflowTypes.GetMFStreamLayerType.ANE_LayerName + WriteIndex + '.'
    + ModflowTypes.GetMFStreamSegNumParamType.ANE_ParamName + ',1)>0, 1, 0)'

end;

//--------------------------------------------------
Constructor TGridFHB.Create(AParameterList : T_ANE_ParameterList;
            Index : Integer);
begin
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TGridFHB.ANE_ParamName : string ;
begin
  result := kMFGridFHBLocation; 
end;

function TGridFHB.Value : string;
begin
  result := 'If(CountObjectsInBlock('
         + ModflowTypes.GetMFPointFHBLayerType.ANE_LayerName + WriteIndex
         + '.' + ModflowTypes.GetMFFHBPointAreaHeadParamType.ANE_ParamName
         + '1,0)>0|CountObjectsInBlock('
         + ModflowTypes.GetMFLineFHBLayerType.ANE_LayerName + WriteIndex
         + '.' + ModflowTypes.GetMFFHBLineHeadStartParamType.ANE_ParamName
         + '1,1)>0|CountObjectsInBlock('
         + ModflowTypes.GetMFAreaFHBLayerType.ANE_LayerName
         + WriteIndex + '.' + ModflowTypes.GetMFFHBPointAreaHeadParamType.ANE_ParamName + '1,2)>0|!IsNA('
         + ModflowTypes.GetMFAreaFHBLayerType.ANE_LayerName + WriteIndex + '.'
         + ModflowTypes.GetMFFHBPointAreaHeadParamType.ANE_ParamName
         + '1)|!IsNA('
         + ModflowTypes.GetMFAreaFHBLayerType.ANE_LayerName + WriteIndex + '.'
         + ModflowTypes.GetMFFHBAreaFluxParamType.ANE_ParamName
         + '1), 1, 0)'
end;

//--------------------------------------------------
Constructor TGridHFB.Create(AParameterList : T_ANE_ParameterList;
            Index : Integer);
begin
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TGridHFB.ANE_ParamName : string ;
begin
  result := kMFGridHFBLocation;
end;

function TGridHFB.Value : string;
begin
  result := 'If(CountObjectsInBlock('
         + ModflowTypes.GetMFHFBLayerType.ANE_LayerName + WriteIndex
         + '.' + ModflowTypes.GetMFHFBHydCondParamType.ANE_ParamName + ',1,2), 1, 0)'
end;

//--------------------------------------------------
class Function TGridMOCInitConc.ANE_ParamName : string ;
begin
  result := kMFGridMOCInitConc;
end;

function TGridMOCInitConc.Value : string;
begin
  result := ModflowTypes.GetMOCInitialConcLayerType.ANE_LayerName + WriteIndex ;
end;

//--------------------------------------------------
Constructor TGridMOCSubGrid.Create(AParameterList : T_ANE_ParameterList;
            Index : Integer);
begin
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TGridMOCSubGrid.ANE_ParamName : string ;
begin
  result := kMFGridMOCSubBound;
end;

function TGridMOCSubGrid.Value : string;
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
Constructor TGridMOCParticleRegen.Create(AParameterList : T_ANE_ParameterList;
            Index : Integer);
begin
  inherited Create( AParameterList, Index);
  ValueType := pvInteger;
end;

class Function TGridMOCParticleRegen.ANE_ParamName : string ;
begin
  result := kMFGridMOCParticleRegen;
end;

function TGridMOCParticleRegen.Value : string;
begin
  result := 'If((CountObjectsInBlock('
         + ModflowTypes.GetMOCParticleRegenLayerType.ANE_LayerName
         + WriteIndex + ',0,1)>0)&(SumObjectsInBlock('
         + ModflowTypes.GetMOCParticleRegenLayerType.ANE_LayerName
         + WriteIndex + ')>0),1,If(!IsNA('
         + ModflowTypes.GetMOCParticleRegenLayerType.ANE_LayerName
         + WriteIndex + '), '
         + ModflowTypes.GetMOCParticleRegenLayerType.ANE_LayerName
         + WriteIndex + ', 0))';
end;

//--------------------------------------------------
class Function TGridMOCPorosity.ANE_ParamName : string ;
begin
  result := kMFGridMOCPorosity;
end;

function TGridMOCPorosity.Value : string;
begin
  result := ModflowTypes.GetMOCPorosityLayerType.ANE_LayerName + WriteIndex ;
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
  ValueType  := pvInteger;
end;

function TGridModpathZone.Value: string;
begin
  result := ModflowTypes.GetMODPATHZoneLayerType.ANE_LayerName + WriteIndex
    + ' * '
    + ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName + WriteIndex;

end;

//--------------------------------------------------

constructor TGeologicUnitParameters.Create(AnOwner :
      T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited Create( AnOwner, Position);

  ParameterOrder.Add(ModflowTypes.GetMFIBoundGridParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridTopElevParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridBottomElevParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridThicknessParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridInitialHeadParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridKxParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridKzParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridTransParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridVContParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridSpecYieldParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridSpecStorParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridConfStoreParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridWettingParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMFGridWellParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridRiverParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridDrainParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridGHBParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridStreamParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridHFBParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridFHBParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridMOCInitConcParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridMOCParticleRegenParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridMOCPorosityParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridZoneBudgetParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFGridModpathZoneParamType.ANE_ParamName);

  ModflowTypes.GetMFIBoundGridParamType.Create(self, -1);
  ModflowTypes.GetMFGridTopElevParamType.Create( self, -1);
  ModflowTypes.GetMFGridBottomElevParamType.Create( self, -1);
  ModflowTypes.GetMFGridThicknessParamType.Create( self, -1);
  ModflowTypes.GetMFGridInitialHeadParamType.Create( self, -1);
  ModflowTypes.GetMFGridKxParamType.Create( self, -1);
  ModflowTypes.GetMFGridKzParamType.Create( self, -1);

  if frmModflow.dgGeol.Cells[Ord(nuiSpecT),Index] =
    frmModflow.dgGeol.Columns[Ord(nuiSpecT)].Picklist.Strings[1] then
  begin
    ModflowTypes.GetMFGridTransParamType.Create( self, -1);
  end;
  if frmModflow.dgGeol.Cells[Ord(nuiSpecVCONT),Index] =
    frmModflow.dgGeol.Columns[Ord(nuiSpecVCONT)].Picklist.Strings[1] then
  begin
    ModflowTypes.GetMFGridVContParamType.Create( self, -1);
  end;
  if frmModflow.dgGeol.Cells[Ord(nuiSpecSF1),Index] =
    frmModflow.dgGeol.Columns[Ord(nuiSpecSF1)].Picklist.Strings[1] then
  begin
    ModflowTypes.GetMFGridConfStoreParamType.Create( self, -1);
  end;


  ModflowTypes.GetMFGridSpecYieldParamType.Create( self, -1);
  ModflowTypes.GetMFGridSpecStorParamType.Create( self, -1);
  ModflowTypes.GetMFGridWettingParamType.Create( self, -1);

  if frmMODFLOW.cbWEL.Checked then
  begin
    ModflowTypes.GetMFGridWellParamType.Create( self, -1);
  end;

  if frmMODFLOW.cbRIV.Checked then
  begin
    ModflowTypes.GetMFGridRiverParamType.Create( self, -1);
  end;

  if frmMODFLOW.cbDRN.Checked then
  begin
    ModflowTypes.GetMFGridDrainParamType.Create( self, -1);
  end;

  if frmMODFLOW.cbGHB.Checked then
  begin
    ModflowTypes.GetMFGridGHBParamType.Create( self, -1);
  end;

  if frmMODFLOW.cbSTR.Checked then
  begin
    ModflowTypes.GetMFGridStreamParamType.Create( self, -1);
  end;

  if frmMODFLOW.cbHFB.Checked then
  begin
    ModflowTypes.GetMFGridHFBParamType.Create( self, -1);
  end;

  if frmMODFLOW.cbFHB.Checked then
  begin
    ModflowTypes.GetMFGridFHBParamType.Create( self, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFGridMOCInitConcParamType.Create( self, -1);
    ModflowTypes.GetMFGridMOCParticleRegenParamType.Create( self, -1);
  end;

  if frmMODFLOW.cbMOC3D.Checked or frmMODFLOW.cbMODPATH.Checked  then
  begin
    ModflowTypes.GetMFGridMOCPorosityParamType.Create( self, -1);
  end;
  
  if frmMODFLOW.cbZonebudget.Checked then
  begin
    ModflowTypes.GetMFGridZoneBudgetParamType.Create( self, -1);
  end;

  if frmMODFLOW.cbMODPATH.Checked then
  begin
    ModflowTypes.GetMFGridModpathZoneParamType.Create( self, -1);
  end;

end;

//--------------------------------------------------


class Function TMFGridLayer.ANE_LayerName : string ;
begin
  result := kMFGrid
end;

constructor TMFGridLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  GeolUnitIndex : integer;
  NumberOfUnits : integer;
begin
  inherited Create( ALayerList, Index);
  YGridDirectionReversed := True;
  DomainLayer := ModflowTypes.GetMFDomainOutType.ANE_LayerName;
  DensityLayer := ModflowTypes.GetDensityLayerType.ANE_LayerName;

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridETSurfParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridETLayerParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridRechElevParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridRechLayerParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGridMOCSubGridParamType.ANE_ParamName);

  if frmMODFLOW.cbEVT.Checked then
  begin
    ModflowTypes.GetMFGridETSurfParamType.Create( ParamList, -1);
    if frmMODFLOW.cbETLayer.Checked and (frmMODFLOW.comboEvtOption.ItemIndex = 1) then
    begin
      ModflowTypes.GetMFGridETLayerParamType.Create( ParamList, -1);
    end;
  end;

  if frmMODFLOW.cbRCH.Checked then
  begin
    ModflowTypes.GetMFGridRechElevParamType.Create( ParamList, -1);
    if frmMODFLOW.cbRechLayer.Checked and (frmMODFLOW.comboRchOpt.ItemIndex = 1) then
    begin
      ModflowTypes.GetMFGridRechLayerParamType.Create( ParamList, -1);
    end;
  end;

  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFGridMOCSubGridParamType.Create( ParamList, -1);
  end;

  NumberOfUnits := StrToInt(frmMODFLOW.edNumUnits.Text);
  for GeolUnitIndex := 1 to NumberOfUnits do
  begin
    ModflowTypes.GetMFGeologicUnitParametersType.Create( IndexedParamList1, -1);
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
  result := 'L^2/T';
end;

function TGridTrans.Value: string;
begin
  result := ModflowTypes.GetMFTransmisivityLayerType.ANE_LayerName + WriteIndex;
end;

{ TGridVCont }

class function TGridVCont.ANE_ParamName: string;
begin
  result := kMFGridVcont
end;

function TGridVCont.Units: string;
begin
  result := '1/T'
end;

function TGridVCont.Value: string;
begin
  result := ModflowTypes.GetMFVcontLayerType.ANE_LayerName + WriteIndex;
end;

{ TGridConfStor }

class function TGridConfStor.ANE_ParamName: string;
begin
  result := kMFGridConfStorage;
end;

function TGridConfStor.Value: string;
begin
  result := ModflowTypes.GetMFConfStorageLayerType.ANE_LayerName + WriteIndex;
end;

{ TGridRechLayerParam }

class function TGridRechLayerParam.ANE_ParamName: string;
begin
  result := kMFGridRechargeLayer;
end;

constructor TGridRechLayerParam.Create(AParameterList : T_ANE_ParameterList; Index : Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF});
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

end.
