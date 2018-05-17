unit MFCHD;

interface

uses ANE_LayerUnit, SysUtils, MFGenParam;

type
  TCHD_ElevationParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TCHD_StartHeadParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TCHD_EndHeadParam = class(TCHD_StartHeadParam)
    class Function ANE_ParamName : string ; override;
  end;

  TSeawatDensityOption = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
  end;

  TChdFluidDensity = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TCHD_TimeParamList = class(T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TCustomCHD_Layer = Class(TCustomIFACE_Layer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
  end;

  TPointLineCHD_Layer = Class(TCustomCHD_Layer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TAreaCHD_Layer = Class(TCustomCHD_Layer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

resourcestring
  rsCHD_Elevation = 'Elevation';
  rsStartHead = 'Starting Head';
  rsEndHead = 'Ending Head';
  rsConstantHead = 'Point_Line Constant Head Unit';
  rsAreaConstantHead = 'Area Constant Head Unit';
  rsSeawatDensityOption = 'SEAWAT Density Option';
  rsFluidDensity = 'Fluid Density';

{ TCHD_ElevationParam }

class function TCHD_ElevationParam.ANE_ParamName: string;
begin
  result := rsCHD_Elevation;
end;

function TCHD_ElevationParam.Units: string;
begin
  result := LengthUnit;
end;

function TCHD_ElevationParam.Value: string;
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

{ TCHD_StartHeadParam }

class function TCHD_StartHeadParam.ANE_ParamName: string;
begin
  result := rsStartHead;
end;

function TCHD_StartHeadParam.Units: string;
begin
  result := LengthUnit;
end;

function TCHD_StartHeadParam.Value: string;
begin
  If ANE_ParamName = rsConstantHead then
  begin
    result := '0';
  end
  else
  begin
    result := kNA;
  end;
end;

{ TCHD_TimeParamList }

constructor TCHD_TimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  NCOMP : integer;
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.GetMFCHD_StartHeadParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFCHD_EndHeadParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMFSeawatDensityOptionParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFChdFluidDensityParamType.ANE_ParamName);


  ParameterOrder.Add(ModflowTypes.GetMFConcentrationParamType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName);

  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);

  ModflowTypes.GetMFCHD_StartHeadParamType.Create(self, -1);
  ModflowTypes.GetMFCHD_EndHeadParamType.Create(self, -1);

  if frmMODFLOW.cbSeaWat.Checked then
  begin
    ModflowTypes.GetMFSeawatDensityOptionParamType.Create(self, -1);
    ModflowTypes.GetMFChdFluidDensityParamType.Create(self, -1);
  end;

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
  if (ParentLayer as TCustomCHD_Layer).UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;

end;

{ TPointLineCHD_Layer }

class function TPointLineCHD_Layer.ANE_LayerName: string;
begin
  result := rsConstantHead;
end;

constructor TPointLineCHD_Layer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
{var
  TimeIndex : Integer;
  NumberOfTimes : integer;   }
begin
  inherited Create(ALayerList, Index);
  Lock := Lock + [llEvalAlg];

  ModflowTypes.GetMFCHD_ElevationParamType.Create( ParamList, 0);
{  ModflowTypes.GetMFModflowParameterNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsParameterParamType.Create( ParamList, -1);
  ModflowTypes.GetMFObservationGroupNumberParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFCHD_TimeParamListType.Create(IndexedParamList2, -1);
  end;}
end;

{ TAreaCHD_Layer }

class function TAreaCHD_Layer.ANE_LayerName: string;
begin
  result := rsAreaConstantHead;
end;

constructor TAreaCHD_Layer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := leExact;
  Lock := Lock + [llEvalAlg];
end;

{ TCHD_EndHeadParam }

class function TCHD_EndHeadParam.ANE_ParamName: string;
begin
  result := rsEndHead;
end;

{ TCustomCHD_Layer }

constructor TCustomCHD_Layer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

//  ModflowTypes.GetMFCHD_ElevationParamType.Create( ParamList, -1);
  ModflowTypes.GetMFModflowParameterNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsParameterParamType.Create( ParamList, -1);
//  ModflowTypes.GetMFObservationGroupNumberParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFCHD_TimeParamListType.Create(IndexedParamList2, -1);
  end;
end;  

{ TSeawatDensityOption }

class function TSeawatDensityOption.ANE_ParamName: string;
begin
  result := rsSeawatDensityOption;
end;

constructor TSeawatDensityOption.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TSeawatDensityOption.Units: string;
begin
  result := '0 to 3';
end;

function TSeawatDensityOption.Value: string;
begin
  result := '0';
end;

{ TChdFluidDensity }

class function TChdFluidDensity.ANE_ParamName: string;
begin
  result := rsFluidDensity;
end;

function TChdFluidDensity.Units: string;
begin
  result := 'required only for option 1'
end;

function TChdFluidDensity.Value: string;
begin
  result := '1025';
end;

end.
