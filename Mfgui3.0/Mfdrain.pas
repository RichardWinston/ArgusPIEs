unit MFDrain;

interface

{MFDrain defines the "Line Drain Unit[i]" and "Area Drain Unit[i]" layers
 and associated parameters and Parameterlists.}

uses ANE_LayerUnit, SysUtils;

type
  TDrainElevationParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TDrainOnParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  public
    function Value: string; override;

  end;

  TDrainTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TLineDrainLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TAreaDrainLayer = Class(T_ANE_InfoLayer)
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

class Function TDrainElevationParam.ANE_ParamName : string ;
begin
  result := kMFDrainElevaton;
end;

function TDrainElevationParam.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TDrainOnParam.ANE_ParamName : string ;
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
end;

//---------------------------
constructor TDrainTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);
  ModflowTypes.GetMFDrainOnParamType.Create( self, -1);
  if frmMODFLOW.cbMODPATH.Checked then
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

  ModflowTypes.GetMFConductanceParamType.Create( ParamList, -1);
  ModflowTypes.GetMFDrainElevationParamType.Create( ParamList, -1);

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
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;

  ModflowTypes.GetMFConductanceParamType.Create( ParamList, -1);
  ModflowTypes.GetMFDrainElevationParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFDrainTimeParamListType.Create( IndexedParamList2, -1);
  end;
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

end.
