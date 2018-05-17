unit MFWells;

interface

{MFWells defines the "Wells Unit[i]" layer
 and the associated parameters and Parameterlist.}

uses ANE_LayerUnit, SysUtils, MFGenParam;

type
  TWellTopParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TWellBottomParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TWellStressParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : String; override;
  end;

  TTotalWellStressParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : String; override;
  end;

  TWellStressIndicatorParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : String; override;
  end;

  TCustomWellTimeParamList = class( TSteadyTimeParamList)
    function IsSteadyStress : boolean; override;
  end;

  TWellTimeParamList = class( TCustomWellTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TLineAreaWellTimeParamList = class( TCustomWellTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TCustomWellLayer = Class(TCustomIFACE_Layer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
  end;

  TWellLayer = Class(TCustomWellLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TLineWellLayer = class(TCustomWellLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
  end;

  TAreaWellLayer = class(TLineWellLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
  end;

implementation

uses Variables, OptionsUnit;

ResourceString
  kMFWells = 'Wells Unit';
  kMFWellTop = 'Top Elevation';
  kMFWellBottom = 'Bottom Elevation';
  kMFWellStress = 'Stress';
  kMFTotalWellStress = 'Total Stress';
  kMFStressIndicator = 'STRESS INDICATOR';
  kMFLineWells = 'Line Wells Unit';
  kMFAreaWells = 'Area Wells Unit';

class Function TWellTopParam.ANE_ParamName : string ;
begin
  result := kMFWellTop;
end;

function TWellTopParam.Units : string;
begin
  result := LengthUnit;
end;

//---------------------------
class Function TWellBottomParam.ANE_ParamName : string ;
begin
  result := kMFWellBottom;
end;

function TWellBottomParam.Units : string;
begin
  result := LengthUnit;
end;

//---------------------------
class Function TWellStressParam.ANE_ParamName : string ;
begin
  result := kMFWellStress;
end;

function TWellStressParam.Units : string;
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetParentLayer;
  if Pos('Point', ALayer.ANE_LayerName) > 0 then
  begin
    result := LengthUnit + '^3/' +TimeUnit ;
  end
  else if Pos('Line', ALayer.ANE_LayerName) > 0 then
  begin
    result := LengthUnit + '^2/' +TimeUnit ;
  end
  else if Pos('Area', ALayer.ANE_LayerName) > 0 then
  begin
    result := LengthUnit + '/' +TimeUnit ;
  end
  else
  begin
    result := LengthUnit + '^3/' +TimeUnit ;
  end;
end;

//---------------------------
constructor TWellTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
var
  NCOMP : integer;
begin
  inherited Create(AnOwner, Position);
  ParameterOrder.Add(ModflowTypes.GetMFWellStressParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFConcentrationParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);

  ModflowTypes.GetMFWellStressParamType.Create(self, -1);
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
  if (ParentLayer as TCustomWellLayer).UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;
end;

//---------------------------
constructor TWellLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

{  ModflowTypes.GetMFWellTopParamType.Create( ParamList, -1);
  ModflowTypes.GetMFWellBottomParamType.Create( ParamList, -1);
  ModflowTypes.GetMFModflowParameterNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsParameterParamType.Create( ParamList, -1);
  ModflowTypes.GetMFObservationGroupNumberParamType.Create( ParamList, -1);
}

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFWellTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TWellLayer.ANE_LayerName : string ;
begin
  result := kMFWells;
end;

{ TLineWellLayer }

class function TLineWellLayer.ANE_LayerName: string;
begin
  result := kMFLineWells;
end;

constructor TLineWellLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create(ALayerList, Index);

{  ModflowTypes.GetMFWellTopParamType.Create( ParamList, -1);
  ModflowTypes.GetMFWellBottomParamType.Create( ParamList, -1);
  ModflowTypes.GetMFModflowParameterNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsParameterParamType.Create( ParamList, -1);
}

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFLineAreaWellTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

{ TAreaWellLayer }

class function TAreaWellLayer.ANE_LayerName: string;
begin
  result := kMFAreaWells;
end;

constructor TAreaWellLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;

{  ModflowTypes.GetMFWellTopParamType.Create( ParamList, -1);
  ModflowTypes.GetMFWellBottomParamType.Create( ParamList, -1);
  ModflowTypes.GetMFModflowParameterNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsParameterParamType.Create( ParamList, -1);


  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFLineAreaWellTimeParamListType.Create(IndexedParamList2, -1);
  end; }
end;

function TWellStressParam.Value: String;
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetParentLayer;
  if (Pos('Area', ALayer.ANE_LayerName) > 0) or
     (Pos('Line', ALayer.ANE_LayerName) > 0) then
  begin
    result := kNa;
  end
  else
  begin
    result := inherited Value;
  end;
end;

{ TTotalWellStressParam }

class function TTotalWellStressParam.ANE_ParamName: string;
begin
  result := kMFTotalWellStress;
end;

function TTotalWellStressParam.Units: string;
begin
  result := LengthUnit + '^3/' +TimeUnit ;
end;

function TTotalWellStressParam.Value: String;
begin
 result := kNa;
end;

{ TLineAreaWellTimeParamList }

constructor TLineAreaWellTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  NCOMP : integer;
begin
  inherited Create(AnOwner, Position);
  ParameterOrder.Add(ModflowTypes.GetMFWellStressParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFTotalWellStressParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFConcentrationParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFWellStressIndicatorParamType.ANE_ParamName);

  ModflowTypes.GetMFWellStressParamType.Create(self, -1);
  ModflowTypes.GetMFTotalWellStressParamType.Create(self, -1);
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
  if (ParentLayer as TCustomWellLayer).UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;
  ModflowTypes.GetMFWellStressIndicatorParamType.Create(self, -1);

end;

{ TWellStressIndicatorParam }

class function TWellStressIndicatorParam.ANE_ParamName: string;
begin
  result := kMFStressIndicator;
end;

constructor TWellStressIndicatorParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Lock := Lock + [plDef_Val,plDont_Override];
  ValueType := pvInteger;
  SetValue := True;
end;

function TWellStressIndicatorParam.Units: string;
begin
  result := 'CALCULATED';
end;

function TWellStressIndicatorParam.Value: String;
begin
  result :=
    'If('
    + ModflowTypes.GetMFWellStressParamType.ANE_ParamName + WriteIndex
    + '!=$N/A, 1, If('
    + ModflowTypes.GetMFTotalWellStressParamType.ANE_ParamName + WriteIndex
    + '!=$N/A, 2, 0))'

end;

{ TCustomWellTimeParamList }

function TCustomWellTimeParamList.IsSteadyStress: boolean;
begin
  result := frmModflow.comboWelSteady.ItemIndex = 0;
end;

{ TCustomWellLayer }

constructor TCustomWellLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Lock := Lock + [llEvalAlg];

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFWellTopParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFWellBottomParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIsParameterParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFBoundaryDensityParamType.ANE_ParamName);

  ModflowTypes.GetMFWellTopParamType.Create( ParamList, -1);
  ModflowTypes.GetMFWellBottomParamType.Create( ParamList, -1);
  ModflowTypes.GetMFModflowParameterNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsParameterParamType.Create( ParamList, -1);
  if ModflowTypes.GetMFBoundaryDensityParamType.UseInWells then
  begin
    ModflowTypes.GetMFBoundaryDensityParamType.Create( ParamList, -1);
  end;
end;

end.
