unit MFRiver;

interface

{MFRiver defines the "Line River Unit[i]" and "Area River Unit[i]" layers
 and the associated parameters and Parameterlist.}

uses ANE_LayerUnit, SysUtils, MFGenParam;

type
  TRiverBottomParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TRiverBedThicknessParam = class(TCustomUnitParameter)
  public
    class Function ANE_ParamName : string ; override;
    Class Function UseParameter: boolean;
    function Value : string; override;
  end;

  TRiverStageParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TRiverConductanceParam = class(TConductance)
    function FactorUsed: boolean; override;
  end;

  TRiverTimeParamList = class(TSteadyTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
    function IsSteadyStress : boolean; override;
  end;

  TLineRiverLayer = Class(TCustomIFACE_Layer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TAreaRiverLayer = Class(TLineRiverLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TPointRiverLayer = Class(TLineRiverLayer)
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFPointRiver = 'Point River Unit';
  kMFLineRiver = 'Line River Unit';
  kMFAreaRiver = 'Area River Unit';
  kMFRiverBottom = 'Bottom Elevation';
  kMFRiverStage = 'Stage Stress';
  kMFRiverBedThickness = 'Riverbed Thickness';

class Function TRiverBottomParam.ANE_ParamName : string ;
begin
  result := kMFRiverBottom;
end;

function TRiverBottomParam.Units : string;
begin
  result := LengthUnit;
end;

function TRiverBottomParam.Value : string;
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetParentLayer;
  if Pos('Area', ALayer.ANE_LayerName) > 0 then
    begin
      result := kNA;
    end
  else
    begin
      result := inherited Value;
    end;
end;

//---------------------------
class Function TRiverStageParam.ANE_ParamName : string ;
begin
  result := kMFRiverStage;
end;

function TRiverStageParam.Units : string;
begin
  result := LengthUnit;
end;

//---------------------------
constructor TRiverTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
var
  NCOMP : integer;
begin
  inherited Create( AnOwner, Position);

  ParameterOrder.Add(ModflowTypes.GetMFRiverStageParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFOnOffParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFConcentrationParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);

  ModflowTypes.GetMFRiverStageParamType.Create( self, -1);
  ModflowTypes.GetMFOnOffParamType.Create( self, -1);
  if frmMODFLOW.cbMOC3D.Checked
    or (frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked) then
  begin
    ModflowTypes.GetMFConcentrationParamType.Create( self, -1);
  end;
  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    NCOMP := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    if NCOMP >= 2 then
    begin
      ModflowTypes.GetMT3DConc2ParamClassType.Create( self, -1);
    end;
    if NCOMP >= 3 then
    begin
      ModflowTypes.GetMT3DConc3ParamClassType.Create( self, -1);
    end;
    if NCOMP >= 4 then
    begin
      ModflowTypes.GetMT3DConc4ParamClassType.Create( self, -1);
    end;
    if NCOMP >= 5 then
    begin
      ModflowTypes.GetMT3DConc5ParamClassType.Create( self, -1);
    end;
  end;
  if (ParentLayer as TLineRiverLayer).UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;

end;

//---------------------------
constructor TLineRiverLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);
  Lock := Lock + [llEvalAlg];

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFRiverConductanceParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFRiverBottomParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIsParameterParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFObservationGroupNumberParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFBoundaryDensityParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFRiverBedThicknessParamType.ANE_ParamName);

  ModflowTypes.GetMFRiverConductanceParamType.Create( ParamList, -1);
  ModflowTypes.GetMFRiverBottomParamType.Create( ParamList, -1);
  ModflowTypes.GetMFModflowParameterNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsParameterParamType.Create( ParamList, -1);
  ModflowTypes.GetMFObservationGroupNumberParamType.Create( ParamList, -1);
  if ModflowTypes.GetMFBoundaryDensityParamType.UseInRivers then
  begin
    ModflowTypes.GetMFBoundaryDensityParamType.Create( ParamList, -1);
  end;
  if ModflowTypes.GetMFRiverBedThicknessParamType.UseParameter then
  begin
    ModflowTypes.GetMFRiverBedThicknessParamType.Create(ParamList, -1);
  end;

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFRiverTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TLineRiverLayer.ANE_LayerName : string ;
begin
  result := kMFLineRiver;
end;

//---------------------------
constructor TAreaRiverLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;
end;

class Function TAreaRiverLayer.ANE_LayerName : string ;
begin
  result := kMFAreaRiver;
end;

{ TPointRiverLayer }

class function TPointRiverLayer.ANE_LayerName: string;
begin
  result := kMFPointRiver;
end;


function TRiverTimeParamList.IsSteadyStress: boolean;
begin
  result := (frmModflow.comboRivSteady.ItemIndex = 0);
end;

{ TRiverConductanceParam }

function TRiverConductanceParam.FactorUsed: boolean;
var
  Layer: T_ANE_Layer;
begin
  Layer := GetParentLayer;
  result := (Pos('Point', Layer.ANE_LayerName) = 0)
    and not frmModflow.cbCondRiv.Checked
end;

{ TRiverBedThicknessParam }

class function TRiverBedThicknessParam.ANE_ParamName: string;
begin
  result := kMFRiverBedThickness;
end;

class function TRiverBedThicknessParam.UseParameter: boolean;
begin
  with frmModflow do
  begin
    result := cbSW_RiverbedThickness.Checked and cbSeaWat.Checked
      and cbRIV.Checked and cbSW_VDF.Checked;
  end
end;

function TRiverBedThicknessParam.Value: string;
begin
  result := '1';
end;

end.
