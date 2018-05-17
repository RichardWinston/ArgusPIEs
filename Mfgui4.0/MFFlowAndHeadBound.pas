unit MFFlowAndHeadBound;

interface

{MFFlowAndHeadBound defines the "Point FHB Unit[i]", "Line FHB Unit[i]"
 and "Area FHB Unit[i]" layers
 and associated parameters and Parameterlists.}

uses ANE_LayerUnit, SysUtils, MFGenParam;

type
  TFHBPointAreaHeadParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TFHBPointFluxParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TFHBPointBoundaryTypeParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : string; override;
  end;

  TFHBTopElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TFHBBotElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TFHBHeadConcParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TFHBFluxConcParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TFHBLineHeadStartParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TFHBLineHeadEndParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TFHBEndHeadUsedParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
    function Value : string; override;
  end;

  TFHBLineFluxParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TFHBLineBoundaryTypeParam = class(TFHBPointBoundaryTypeParam)
    function Value : string; override;
  end;

  TFHBAreaFluxParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TFHBAreaBoundaryTypeParam = class(TFHBPointBoundaryTypeParam)
    function Value : string; override;
  end;

  TFHBPointTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TFHBLineTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TFHBAreaTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TFHBMT3DConcTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TCustomFHBLayer = Class(TCustomIFACE_Layer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class function UseIFACE: boolean; override;
  end;

  TPointFHBLayer = Class(TCustomFHBLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TLineFHBLayer = Class(TCustomFHBLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TAreaFHBLayer = Class(TCustomFHBLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables, OptionsUnit;

ResourceString
  kMFFHBPointAreaHead = 'Head Time';
  kMFFHBPointFlux = 'Flux Time';
  kMFFHBBoundaryType = 'Boundary Type';
  kMFFHBTopElev = 'Top Elev';
  kMFFHBBotElev = 'Bottom Elev';
  kMFFHBHeadConc = 'Head Concentration Time';
  kMFFHBFluxConc = 'Flux Concentration Time';
  kMFFHBLineHeadStart = 'Start_Line Head Time';
  kMFFHBLineHeadEnd = 'End_Line Head Time';
  kMFFHBLineFlux = 'Flux per Length Time';
  kMFFHBAreaFlux = 'Flux per Area Time';
  kMFPointFHB = 'Point FHB Unit';
  kMFLineFHB = 'Line FHB Unit';
  kMFAreaFHB = 'Area FHB Unit';
  kMFFHBEndHeadUsed = 'End Head Used';

class Function TFHBPointAreaHeadParam.ANE_ParamName : string ;
begin
  result := kMFFHBPointAreaHead;
end;

function TFHBPointAreaHeadParam.Units : string;
begin
  result := LengthUnit;
end;

function TFHBPointAreaHeadParam.Value : string;
begin
  result := kNA;
end;

//---------------------------

class Function TFHBPointFluxParam.ANE_ParamName : string ;
begin
  result := kMFFHBPointFlux;
end;

function TFHBPointFluxParam.Units : string;
begin
  result := LengthUnit  + '^3/' + TimeUnit;
end;

function TFHBPointFluxParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TFHBTopElevParam.ANE_ParamName : string ;
begin
  result := kMFFHBTopElev;
end;

function TFHBTopElevParam.Units : string;
begin
  result := LengthUnit;
end;

//---------------------------
class Function TFHBBotElevParam.ANE_ParamName : string ;
begin
  result := kMFFHBBotElev;
end;

function TFHBBotElevParam.Units : string;
begin
  Result := LengthUnit;
end;

//---------------------------

class Function TFHBHeadConcParam.ANE_ParamName : string ;
begin
  result := kMFFHBHeadConc;
end;

function TFHBHeadConcParam.Units : string;
begin
  result := 'M/' + LengthUnit  + '^3';
end;

//---------------------------

class Function TFHBFluxConcParam.ANE_ParamName : string ;
begin
  result := kMFFHBFluxConc;
end;

function TFHBFluxConcParam.Units : string;
begin
  result := 'M/' + LengthUnit  + '^3';
end;

//---------------------------

class Function TFHBLineHeadStartParam.ANE_ParamName : string ;
begin
  result := kMFFHBLineHeadStart;
end;

function TFHBLineHeadStartParam.Units : string;
begin
  result := LengthUnit;
end;

function TFHBLineHeadStartParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TFHBLineHeadEndParam.ANE_ParamName : string ;
begin
  result := kMFFHBLineHeadEnd;
end;

function TFHBLineHeadEndParam.Units : string;
begin
  result := LengthUnit;
end;

function TFHBLineHeadEndParam.Value : string;
begin
  result := kNA;
end;

//---------------------------

class Function TFHBLineFluxParam.ANE_ParamName : string ;
begin
  result := kMFFHBLineFlux;
end;

function TFHBLineFluxParam.Units : string;
begin
  result := LengthUnit  + '^2/' + TimeUnit;
end;

function TFHBLineFluxParam.Value : string;
begin
  result := kNA;
end;
//---------------------------
{
class Function TFHBLineEndElevParam.ANE_Name : string ;
begin
  result := kMFFHBLineElevEnd;
end;

function TFHBLineEndElevParam.Units : string;
begin
  result := 'L^2/t';
end;

function TFHBLineEndElevParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TFHBLineStartElevParam.ANE_Name : string ;
begin
  result := kMFFHBLineElevStart;
end;

function TFHBLineStartElevParam.Units : string;
begin
  result := 'L^2/t';
end;

}
//---------------------------

class Function TFHBAreaFluxParam.ANE_ParamName : string ;
begin
  result := kMFFHBAreaFlux;
end;

function TFHBAreaFluxParam.Units : string;
begin
  Result := LengthUnit + '/' + TimeUnit;
end;

function TFHBAreaFluxParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
constructor TFHBPointTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);
  ParameterOrder.Add(ModflowTypes.GetMFFHBPointAreaHeadParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBPointFluxParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBHeadConcParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBFluxConcParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBPointBoundaryTypeParamType.ANE_ParamName);

  ModflowTypes.GetMFFHBPointAreaHeadParamType.Create( self, -1);
  ModflowTypes.GetMFFHBPointFluxParamType.Create(self, -1);
  if frmMODFLOW.cbMOC3D.Checked  then
  begin
    ModflowTypes.GetMFFHBHeadConcParamType.Create( self, -1);
    ModflowTypes.GetMFFHBFluxConcParamType.Create( self, -1);
  end;
  ModflowTypes.GetMFFHBPointBoundaryTypeParamType.Create(self, -1);
{  if (ParentLayer as TCustomFHBLayer).UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;    }
end;

//---------------------------
constructor TFHBLineTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);
  ParameterOrder.Add(ModflowTypes.GetMFFHBLineHeadStartParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBLineHeadEndParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBLineFluxParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBHeadConcParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBFluxConcParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBLineBoundaryTypeParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBEndHeadUsedParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);
//  ParameterOrder.Add(ModflowTypes.GetMT3DConcentrationParamClassType.Ane_ParamName);

  ModflowTypes.GetMFFHBLineHeadStartParamType.Create( self, -1);
  ModflowTypes.GetMFFHBLineHeadEndParamType.Create( self, -1);
  ModflowTypes.GetMFFHBLineFluxParamType.Create( self, -1);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFFHBHeadConcParamType.Create( self, -1);
    ModflowTypes.GetMFFHBFluxConcParamType.Create( self, -1);
  end;
  ModflowTypes.GetMFFHBLineBoundaryTypeParamType.Create( self, -1);
  ModflowTypes.GetMFFHBEndHeadUsedParamType.Create( self, -1);
{  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
  end;}
  if (ParentLayer as TCustomFHBLayer).UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;
end;

//---------------------------
constructor TFHBAreaTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);
  ParameterOrder.Add(ModflowTypes.GetMFFHBPointAreaHeadParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBAreaFluxParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBHeadConcParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBFluxConcParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFFHBAreaBoundaryTypeParamType.ANE_ParamName);
//  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);
//  ParameterOrder.Add(ModflowTypes.GetMT3DConcentrationParamClassType.Ane_ParamName);

  ModflowTypes.GetMFFHBPointAreaHeadParamType.Create( self, -1);
  ModflowTypes.GetMFFHBAreaFluxParamType.Create( self, -1);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFFHBHeadConcParamType.Create( self, -1);
    ModflowTypes.GetMFFHBFluxConcParamType.Create( self, -1);
  end;
  ModflowTypes.GetMFFHBAreaBoundaryTypeParamType.Create( self, -1);
{  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
  end;
{  if (ParentLayer as TCustomFHBLayer).UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;  }
end;

//---------------------------

constructor TPointFHBLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfFHBPeriods : integer;
begin
  inherited Create(ALayerList, Index);
  Lock := Lock + [llEvalAlg];

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFFHBTopElevParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFFHBBotElevParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);
  ModflowTypes.GetMFFHBTopElevParamType.Create( ParamList, -1);
  ModflowTypes.GetMFFHBBotElevParamType.Create( ParamList, -1);
  if UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create(ParamList, -1);
  end;

  NumberOfFHBPeriods := StrToInt(frmMODFLOW.adeFHBNumTimes.Text);
  For TimeIndex := 1 to NumberOfFHBPeriods do
  begin
    ModflowTypes.GetMFFHBPointTimeParamListType.Create(IndexedParamList1, -1);
  end;
end;

class Function TPointFHBLayer.ANE_LayerName : string ;
begin
  result := kMFPointFHB;
end;

//---------------------------
constructor TLineFHBLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfFHBPeriods : integer;
begin
  inherited Create(ALayerList, Index);
  Lock := Lock + [llEvalAlg];

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFFHBTopElevParamType.Ane_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFFHBBotElevParamType.Ane_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);
  ModflowTypes.GetMFFHBTopElevParamType.Create(ParamList, -1);
  ModflowTypes.GetMFFHBBotElevParamType.Create(ParamList, -1);
  if UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create(ParamList, -1);
  end;

  NumberOfFHBPeriods := StrToInt(frmMODFLOW.adeFHBNumTimes.Text);
  For TimeIndex := 1 to NumberOfFHBPeriods do
  begin
    ModflowTypes.GetMFFHBLineTimeParamListType.Create(IndexedParamList1, -1);
  end;
end;

class Function TLineFHBLayer.ANE_LayerName : string ;
begin
  result := kMFLineFHB;
end;

//---------------------------
constructor TAreaFHBLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfFHBPeriods : integer;
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;
  Lock := Lock + [llEvalAlg];

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);
  if UseIFACE then
  begin
    ModflowTypes.GetMFIFACEParamType.Create(ParamList, -1);
  end;
  NumberOfFHBPeriods := StrToInt(frmMODFLOW.adeFHBNumTimes.Text);
  For TimeIndex := 1 to NumberOfFHBPeriods do
  begin
    ModflowTypes.GetMFFHBAreaTimeParamListType.Create( IndexedParamList1, -1);
  end;
end;

class Function TAreaFHBLayer.ANE_LayerName : string ;
begin
  result := kMFAreaFHB;
end;


{ TFHBPointBoundaryTypeParam }

class function TFHBPointBoundaryTypeParam.ANE_ParamName: string;
begin
  result := kMFFHBBoundaryType;
end;

constructor TFHBPointBoundaryTypeParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Lock := Lock + [plDef_Val, plDont_Override];
  ValueType := pvInteger;
end;

function TFHBPointBoundaryTypeParam.Units: string;
begin
  result := 'CALCULATED';
end;

function TFHBPointBoundaryTypeParam.Value: string;
begin
  result := 'If('
    + ModflowTypes.GetMFFHBPointAreaHeadParamType.WriteParamName + WriteIndex
    + '!='
    + kNa
    + ', 1, '
    + 'If('
    + ModflowTypes.GetMFFHBPointFluxParamType.WriteParamName + WriteIndex
    + '!='
    + kNa
    + ', 2, 0))'
end;

{ TFHBLineBoundaryTypeParam }

function TFHBLineBoundaryTypeParam.Value: string;
begin
  result := 'If('
    + ModflowTypes.GetMFFHBLineHeadStartParamType.WriteParamName + WriteIndex
    + '!='
    + kNa
    + ', 1, '
    + 'If('
    + ModflowTypes.GetMFFHBLineFluxParamType.WriteParamName + WriteIndex
    + '!='
    + kNa
    + ', 2, 0))'
end;

{ TFHBAreaBoundaryTypeParam }

function TFHBAreaBoundaryTypeParam.Value: string;
begin
  result := 'If('
    + ModflowTypes.GetMFFHBPointAreaHeadParamType.WriteParamName + WriteIndex
    + '!='
    + kNa
    + ', 1, '
    + 'If('
    + ModflowTypes.GetMFFHBAreaFluxParamType.WriteParamName + WriteIndex
    + '!='
    + kNa
    + ', 2, 0))'
end;

{ TFHBEndHeadUsedParam }

class function TFHBEndHeadUsedParam.ANE_ParamName: string;
begin
  result := kMFFHBEndHeadUsed;
end;

constructor TFHBEndHeadUsedParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  Lock := Lock + [plDef_Val, plDont_Override];
  ValueType := pvBoolean;
end;

function TFHBEndHeadUsedParam.Units: string;
begin
  result := 'CALCULATED';
end;

function TFHBEndHeadUsedParam.Value: string;
begin
  result := ModflowTypes.GetMFFHBLineHeadEndParamType.ANE_ParamName
    + WriteIndex
    + ' != '
    + kNa;
end;

{ TFHBMT3DConcTimeParamList }

constructor TFHBMT3DConcTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  NCOMP : integer;
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.GetMT3DConcentrationParamClassType.Ane_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.Ane_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.Ane_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.Ane_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.Ane_ParamName);

  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
    NCOMP := StrToInt(frmMODFLOW.adeMT3DNCOMP.Text);
    if NCOMP >= 2 then
    begin
      ModflowTypes.GetMT3DConc2ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 3 then
    begin
      ModflowTypes.GetMT3DConc3ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 4 then
    begin
      ModflowTypes.GetMT3DConc4ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 5 then
    begin
      ModflowTypes.GetMT3DConc5ParamClassType.Create(self, -1);
    end;
  end;

end;

{ TCustomFHBLayer }

constructor TCustomFHBLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
  NumberOfPeriods : integer;
begin
  inherited Create(ALayerList, Index);

  NumberOfPeriods := frmMODFLOW.dgTime.RowCount -1;
  For TimeIndex := 1 to NumberOfPeriods do
  begin
    ModflowTypes.GetMFFHBMT3DConcTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class function TCustomFHBLayer.UseIFACE: boolean;
begin
  result :=  (frmMODFLOW.cbMOC3D.Checked and frmMODFLOW.cbBFLX.Checked);;
end;

end.
