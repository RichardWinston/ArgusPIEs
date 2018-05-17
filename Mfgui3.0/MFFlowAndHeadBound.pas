unit MFFlowAndHeadBound;

interface

{MFFlowAndHeadBound defines the "Point FHB Unit[i]", "Line FHB Unit[i]"
 and "Area FHB Unit[i]" layers
 and associated parameters and Parameterlists.}

uses ANE_LayerUnit, SysUtils;

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

  TFHBLineFluxParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TFHBAreaFluxParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
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

  TPointFHBLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TLineFHBLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TAreaFHBLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFFHBPointAreaHead = 'Head Time';
  kMFFHBPointFlux = 'Flux Time';
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

class Function TFHBPointAreaHeadParam.ANE_ParamName : string ;
begin
  result := kMFFHBPointAreaHead;
end;

function TFHBPointAreaHeadParam.Units : string;
begin
  result := 'L';
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
  result := 'L^3/t';
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
  result := 'L';
end;

//---------------------------
class Function TFHBBotElevParam.ANE_ParamName : string ;
begin
  result := kMFFHBBotElev;
end;

function TFHBBotElevParam.Units : string;
begin
  result := 'L';
end;

//---------------------------

class Function TFHBHeadConcParam.ANE_ParamName : string ;
begin
  result := kMFFHBHeadConc;
end;

function TFHBHeadConcParam.Units : string;
begin
  result := 'M/L^3';
end;

//---------------------------

class Function TFHBFluxConcParam.ANE_ParamName : string ;
begin
  result := kMFFHBFluxConc;
end;

function TFHBFluxConcParam.Units : string;
begin
  result := 'M/L^3';
end;

//---------------------------

class Function TFHBLineHeadStartParam.ANE_ParamName : string ;
begin
  result := kMFFHBLineHeadStart;
end;

function TFHBLineHeadStartParam.Units : string;
begin
  result := 'L';
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
  result := 'L';
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
  result := 'L^2/t';
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
  result := 'L/t';
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

  ModflowTypes.GetMFFHBPointAreaHeadParamType.Create( self, -1);
  ModflowTypes.GetMFFHBPointFluxParamType.Create(self, -1);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFFHBHeadConcParamType.Create( self, -1);
    ModflowTypes.GetMFFHBFluxConcParamType.Create( self, -1);
  end;
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

  ModflowTypes.GetMFFHBLineHeadStartParamType.Create( self, -1);
  ModflowTypes.GetMFFHBLineHeadEndParamType.Create( self, -1);
  ModflowTypes.GetMFFHBLineFluxParamType.Create( self, -1);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFFHBHeadConcParamType.Create( self, -1);
    ModflowTypes.GetMFFHBFluxConcParamType.Create( self, -1);
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

  ModflowTypes.GetMFFHBPointAreaHeadParamType.Create( self, -1);
  ModflowTypes.GetMFFHBAreaFluxParamType.Create( self, -1);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFFHBHeadConcParamType.Create( self, -1);
    ModflowTypes.GetMFFHBFluxConcParamType.Create( self, -1);
  end;
end;

//---------------------------

constructor TPointFHBLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfFHBPeriods : integer;
begin
  inherited Create(ALayerList, Index);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFFHBTopElevParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFFHBBotElevParamType.ANE_ParamName);
  ModflowTypes.GetMFFHBTopElevParamType.Create( ParamList, -1);
  ModflowTypes.GetMFFHBBotElevParamType.Create( ParamList, -1);

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

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFFHBTopElevParamType.Ane_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFFHBBotElevParamType.Ane_ParamName);
  ModflowTypes.GetMFFHBTopElevParamType.Create(ParamList, -1);
  ModflowTypes.GetMFFHBBotElevParamType.Create(ParamList, -1);

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


end.

