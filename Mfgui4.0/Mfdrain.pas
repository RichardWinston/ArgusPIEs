unit MFDrain;

interface

{MFDrain defines the "Line Drain Unit[i]" and "Area Drain Unit[i]" layers
 and associated parameters and Parameterlists.}

uses ANE_LayerUnit, SysUtils, MFGenParam;

type
  TDrainElevationParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TDrainBottomElevParam = class(TDrainElevationParam)
  public
    class Function ANE_ParamName : string ; override;
    Class Function UseParameter: boolean;
  end;

  TDrainOnParam = class(TOnOffParam)
  end;

  TDrainConductanceParam = class(TConductance)
    function FactorUsed: boolean; override;
  end;

  TDrainTimeParamList = class( TSteadyTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
    function IsSteadyStress : boolean; override;
  end;

  TCustomDrainLayer = Class(TCustomIFACE_Layer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
  end;

  TCustomNoReturnDrainLayer = Class(TCustomDrainLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
  end;

  TLineDrainLayer = Class(TCustomNoReturnDrainLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TAreaDrainLayer = Class(TLineDrainLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TPointDrainLayer = Class(TLineDrainLayer)
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFPointDrain = 'Point Drain Unit';
  kMFLineDrain = 'Line Drain Unit';
  kMFAreaDrain = 'Area Drain Unit';
  kMFDrainElevaton = 'Elevation';
  kMFDrainOn = 'On or Off Stress';
  kMFDrainBottomElevaton = 'Bottom Elevation';

class Function TDrainElevationParam.ANE_ParamName : string ;
begin
  result := kMFDrainElevaton;
end;

function TDrainElevationParam.Units : string;
begin
  Result := LengthUnit;
end;

//---------------------------
{class Function TDrainOnParam.ANE_ParamName : string ;
begin
  result := kMFDrainOn;
end;

function TDrainOnParam.Units : string;
begin
  result := '0 or 1';
end;

function TDrainOnParam.Value: string;
begin
  result := '1';
end;  }

//---------------------------
constructor TDrainTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);
  ParameterOrder.Add(ModflowTypes.GetMFDrainOnParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);

  ModflowTypes.GetMFDrainOnParamType.Create( self, -1);
  if (ParentLayer as TCustomDrainLayer).UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;
end;

//---------------------------
constructor TLineDrainLayer.Create( ALayerList : T_ANE_LayerList; Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create( ALayerList, Index);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFDrainTimeParamListType.Create( IndexedParamList2, -1);
  end;
end;

class Function TLineDrainLayer.ANE_LayerName : string ;
begin
  result := kMFLineDrain;
end;

//---------------------------
constructor TAreaDrainLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;
end;

class Function TAreaDrainLayer.ANE_LayerName : string ;
begin
  result := kMFAreaDrain;
end;

{ TPointDrainLayer }

class function TPointDrainLayer.ANE_LayerName: string;
begin
  result := kMFPointDrain;
end;

function TDrainTimeParamList.IsSteadyStress: boolean;
begin
  result := frmModflow.comboDrnSteady.ItemIndex = 0;
end;

{ TCustomDrainLayer }

constructor TCustomDrainLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Lock := Lock + [llEvalAlg];

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFDrainConductanceParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFDrainElevationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIsParameterParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFObservationGroupNumberParamType.ANE_ParamName);

  ModflowTypes.GetMFDrainConductanceParamType.Create( ParamList, -1);
  ModflowTypes.GetMFDrainElevationParamType.Create( ParamList, -1);
  ModflowTypes.GetMFModflowParameterNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsParameterParamType.Create( ParamList, -1);
  ModflowTypes.GetMFObservationGroupNumberParamType.Create( ParamList, -1);
end;

{ TDrainConductanceParam }

function TDrainConductanceParam.FactorUsed: boolean;
var
  Layer: T_ANE_Layer;
begin
  Layer := GetParentLayer;
  result := (Pos('Point', Layer.ANE_LayerName) = 0)
    and not frmModflow.cbCondDrn.Checked
end;

{ TDrainBottomElevParam }

class function TDrainBottomElevParam.ANE_ParamName: string;
begin
  result := kMFDrainBottomElevaton;
end;

class function TDrainBottomElevParam.UseParameter: boolean;
begin
  with frmModflow do
  begin
    result := cbSW_DrainElevation.Checked and cbSeaWat.Checked
      and cbDRN.Checked and cbSW_VDF.Checked;
  end
end;

{ TCustomNoReturnDrainLayer }

constructor TCustomNoReturnDrainLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFDrainBottomElevParamType.ANE_ParamName);
  if ModflowTypes.GetMFDrainBottomElevParamType.UseParameter then
  begin
    ModflowTypes.GetMFDrainBottomElevParamType.Create( ParamList, -1);
  end;
end;

end.
