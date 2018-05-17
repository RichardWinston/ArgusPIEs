unit MFGenHeadBound;

interface

{MFGenHeadBound defines the "Point GHB Unit[i]", "Line GHB Unit[i]"
 and "Area GHB Unit[i]" layers
 and associated parameters and Parameterlists.}

uses ANE_LayerUnit, SysUtils, MFGenParam;

type
  TGHBHeadParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TGhbConductanceParam = class(TConductance)
    function FactorUsed: boolean; override;
  end;

  TGHBTimeParamList = class( TSteadyTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
    function IsSteadyStress : boolean; override;
  end;

  TPointGHBLayer = Class(TCustomIFACE_Layer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TLineGHBLayer = Class(TPointGHBLayer)
{    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override; }
    class Function ANE_LayerName : string ; override;
  end;

  TAreaGHBLayer = Class(TPointGHBLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFPointGHB = 'Point Gen Head Bound Unit';
  kMFLineGHB = 'Line Gen Head Bound Unit';
  kMFAreaGHB = 'Area Gen Head Bound Unit';
  kMFGHBHead = 'Head Stress';

class Function TGHBHeadParam.ANE_ParamName : string ;
begin
  result := kMFGHBHead;
end;

function TGHBHeadParam.Units : string;
begin
  result := LengthUnit;
end;

//---------------------------
constructor TGHBTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
var
  NCOMP : integer;
begin
  inherited Create(AnOwner, Position);
  ParameterOrder.Add(ModflowTypes.GetMFGHBHeadParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFOnOffParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFConcentrationParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);

  ModflowTypes.GetMFGHBHeadParamType.Create( self, -1);
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
  if (ParentLayer as TPointGHBLayer).UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;
end;

//---------------------------
constructor TPointGHBLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);
  Lock := Lock + [llEvalAlg];

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFGhbConductanceParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIsParameterParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFObservationGroupNumberParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFElevationParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFBoundaryDensityParamType.ANE_ParamName);

  ModflowTypes.GetMFGhbConductanceParamType.Create( ParamList, -1);
  ModflowTypes.GetMFModflowParameterNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsParameterParamType.Create( ParamList, -1);
  ModflowTypes.GetMFObservationGroupNumberParamType.Create( ParamList, -1);
  if ModflowTypes.GetMFElevationParamType.UseInGHB then
  begin
    ModflowTypes.GetMFElevationParamType.Create( ParamList, -1);
  end;
  if ModflowTypes.GetMFBoundaryDensityParamType.UseInGHB then
  begin
    ModflowTypes.GetMFBoundaryDensityParamType.Create( ParamList, -1);
  end;

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetGHBTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TPointGHBLayer.ANE_LayerName : string ;
begin
  result := kMFPointGHB;
end;

class Function TLineGHBLayer.ANE_LayerName : string ;
begin
  result := kMFLineGHB;
end;

//---------------------------
constructor TAreaGHBLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;
end;

class Function TAreaGHBLayer.ANE_LayerName : string ;
begin
  result := kMFAreaGHB;
end;

function TGHBTimeParamList.IsSteadyStress: boolean;
begin
  result := frmModflow.comboGhbSteady.ItemIndex = 0;
end;

{ TGhbConductanceParam }

function TGhbConductanceParam.FactorUsed: boolean;
var
  Layer: T_ANE_Layer;
begin
  Layer := GetParentLayer;
  result := (Pos('Point', Layer.ANE_LayerName) = 0)
    and not frmModflow.cbCondGhb.Checked
end;

end.
