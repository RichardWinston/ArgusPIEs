unit MFSegEvap;

interface

uses MFEvapo, ANE_LayerUnit, SysUtils, MFGenParam;

type
  TSegETSurface = class(TETSurface)
    class Function ANE_ParamName : string ; override;
  end;

  TSegETExtDepth = class(TETExtDepth)
    class Function ANE_ParamName : string ; override;
  end;

  TSegET_MaxFlux = class(TETExtFlux)
    class Function ANE_ParamName : string ; override;
  end;

  TSegET_IntermediateDepth = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TSegET_IntermediateProportion = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TSegETTimeParamList = class(TSteadyTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
    function IsSteadyStress : boolean; override;
  end;

  TSegET_IntermediateDepthsParamList = class( T_ANE_IndexedParameterList)
    constructor Create(AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TSegmentedETLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;


implementation

uses Variables;

resourcestring
  rsETSSurface           = 'ETS Surface';
  rsETSExtinctionDepth   = 'ETS Extinction Depth';
  rsETSIntermediateDepth = 'ETS Intermediate Depth';
  rsETSProportionalRate  = 'ETS Proportional Rate';
  rsETSFluxStress        = 'ETS Flux Stress';
  rsSegmentedEvap        = 'Segmented Evapotranspiration';

{ TSegETSurface }

class function TSegETSurface.ANE_ParamName: string;
begin
  result := rsETSSurface;
end;

{ TSegETExtDepth }

class function TSegETExtDepth.ANE_ParamName: string;
begin
  result := rsETSExtinctionDepth;
end;

{ TSegET_MaxFlux }

class function TSegET_MaxFlux.ANE_ParamName: string;
begin
  result := rsETSFluxStress;
end;

{ TSegET_IntermediateDepth }

class function TSegET_IntermediateDepth.ANE_ParamName: string;
begin
  result := rsETSIntermediateDepth;
end;

function TSegET_IntermediateDepth.Units: string;
begin
  result := 'L'
end;

{ TSegET_IntermediateProportion }

class function TSegET_IntermediateProportion.ANE_ParamName: string;
begin
  result := rsETSProportionalRate;
end;

function TSegET_IntermediateProportion.Units: string;
begin
  result := '0 to 1';
end;

{ TSegETTimeParamList }

constructor TSegETTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited Create(AnOwner, Position);
  ModflowTypes.GetSegET_MaxFluxParamType.Create( self, -1);
end;

function TSegETTimeParamList.IsSteadyStress: boolean;
begin
  result := frmModflow.comboEvtSteady.ItemIndex = 0;
end;

{ TSegET_IntermediateDepthsParamList }

constructor TSegET_IntermediateDepthsParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited Create(AnOwner, Position);
  ModflowTypes.GetSegET_IntermediateDepthParamType.Create( self, -1);
  ModflowTypes.GetSegET_IntermediateProportionParamType.Create( self, -1);
end;

{ TSegmentedETLayer }

class function TSegmentedETLayer.ANE_LayerName: string;
begin
  result := rsSegmentedEvap;
end;

constructor TSegmentedETLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : integer;
  NumberOfTimes : integer;
  NumberOfIntLayers : integer;
  IntLayerIndex : integer;
begin
  inherited Create(ALayerList, Index);

  Interp := leExact;
  ModflowTypes.GetSegETSurfaceParamType.Create( ParamList, -1);
  ModflowTypes.GetSegETExtDepthParamType.Create( ParamList, -1);

  if frmMODFLOW.cbETSLayer.Checked and (frmMODFLOW.comboEvtOption.ItemIndex = 1) then
  begin
    ModflowTypes.GetMFModflowLayerParamType.Create( ParamList, -1);
  end;
  
  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFSegETTimeParamListType.Create( IndexedParamList2, -1);
  end;

  NumberOfIntLayers := StrToInt(frmMODFLOW.adeIntElev.Text);
  for IntLayerIndex := 0 to NumberOfIntLayers -1 do
  begin
    ModflowTypes.GetMFSegET_IntermediateDepthsParamListType.Create( IndexedParamList0, -1);
  end;
end;

end.
