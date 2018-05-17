unit MFEvapo;

interface

{MFEvapo defines the "Evapotranspiration" layer
 and associated parameters.}

uses ANE_LayerUnit, SysUtils;

type
  TETSurface = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TETExtDepth = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TETExtFlux = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TETTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TETLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFEvapotranspiration = 'Evapotranspiration';
  kMFEvtSurface = 'EVT Surface';
  kMFEvtExtDepth = 'EVT Extinction Depth';
  kMFEvtFluxStress = 'EVT Flux Stress';

class Function TETSurface.ANE_ParamName : string ;
begin
  result := kMFEvtSurface;
end;

function TETSurface.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TETExtDepth.ANE_ParamName : string ;
begin
  result := kMFEvtExtDepth;
end;

function TETExtDepth.Units : string;
begin
  result := 'L';
end;

function TETExtDepth.Value : string;
begin
  result := '1';
end;

//---------------------------
class Function TETExtFlux.ANE_ParamName : string ;
begin
  result := kMFEvtFluxStress;
end;

function TETExtFlux.Units : string;
begin
  result := 'L/t';
end;

//---------------------------
constructor TETTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create(AnOwner, Position);
  ModflowTypes.GetMFETExtFluxParamType.Create( self, -1);
end;

//---------------------------
constructor TETLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : integer;
  NumberOfTimes : integer;
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;
  ModflowTypes.GetMFETSurfaceParamType.Create( ParamList, -1);
  ModflowTypes.GetMFETExtDepthParamType.Create( ParamList, -1);

  if frmMODFLOW.cbETLayer.Checked and (frmMODFLOW.comboEvtOption.ItemIndex = 1) then
  begin
    ModflowTypes.GetMFModflowLayerParamType.Create( ParamList, -1);
  end;
  
  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetETTimeParamListType.Create( IndexedParamList2, -1);
  end;
end;

class Function TETLayer.ANE_LayerName : string ;
begin
  result := kMFEvapotranspiration;
end;

end.

