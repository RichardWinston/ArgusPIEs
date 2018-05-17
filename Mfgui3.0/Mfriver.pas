unit MFRiver;

interface

{MFRiver defines the "Line River Unit[i]" and "Area River Unit[i]" layers
 and the associated parameters and Parameterlist.}

uses ANE_LayerUnit, SysUtils;

type
  TRiverBottomParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TRiverStageParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TRiverTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TLineRiverLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TAreaRiverLayer = Class(T_ANE_InfoLayer)
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

class Function TRiverBottomParam.ANE_ParamName : string ;
begin
  result := kMFRiverBottom;
end;

function TRiverBottomParam.Units : string;
begin
  result := 'L';
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
  result := 'L';
end;

//---------------------------
constructor TRiverTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);

  ParameterOrder.Add(ModflowTypes.GetMFRiverStageParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFConcentrationParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);

  ModflowTypes.GetMFRiverStageParamType.Create( self, -1);
  if frmMODFLOW.cbMOC3D.Checked then
  begin
    ModflowTypes.GetMFConcentrationParamType.Create( self, -1);
  end;
  if frmMODFLOW.cbMODPATH.Checked then
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

  ModflowTypes.GetMFConductanceParamType.Create( ParamList, -1);
  ModflowTypes.GetMFRiverBottomParamType.Create( ParamList, -1);

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
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;

  ModflowTypes.GetMFConductanceParamType.Create( ParamList, -1);
  ModflowTypes.GetMFRiverBottomParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFRiverTimeParamListType.Create(IndexedParamList2, -1);
  end;
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


end.

