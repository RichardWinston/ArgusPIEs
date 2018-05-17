unit MFSeepage;

interface

uses ANE_LayerUnit, SysUtils;

type
  TLineSeepageElevationParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TAreaSeepageElevationParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : String; override;
  end;

  TSeepageOnParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  public
    function Value: string; override;

  end;

  TSeepageTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TLineSeepageLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TAreaSeepageLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

ResourceString
  kMFLineSeepage = 'Line Seepage Unit';
  kMFAreaSeepage = 'Area Seepage Unit';
  kMFSeepageElevaton = 'Elevation';
  kMFSeepageOn = 'On or Off Stress';

class Function TLineSeepageElevationParam.ANE_ParamName : string ;
begin
  result := kMFSeepageElevaton;
end;

function TLineSeepageElevationParam.Units : string;
begin
  result := 'L';
end;

//---------------------------
class Function TAreaSeepageElevationParam.ANE_ParamName : string ;
begin
  result := kMFSeepageElevaton;
end;

function TAreaSeepageElevationParam.Units : string;
begin
  result := 'L';
end;

function TAreaSeepageElevationParam.Value: String;
begin
  result := kNA
end;

//---------------------------
class Function TSeepageOnParam.ANE_ParamName : string ;
begin
  result := kMFSeepageOn;
end;

function TSeepageOnParam.Units : string;
begin
  result := '0 or 1';
end;

function TSeepageOnParam.Value: string;
begin
  result := '1';
end;

//---------------------------
constructor TSeepageTimeParamList.Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);
begin
  inherited Create( AnOwner, Position);
  ModflowTypes.GetMFSeepageOnParamClassType.Create( self, -1);
{  if frmMODFLOW.cbMODPATH.Checked then
  begin
    ModflowTypes.GetMFIFACEParamType.Create( self, -1);
  end;  }
end;

//---------------------------
constructor TLineSeepageLayer.Create( ALayerList : T_ANE_LayerList; Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create( ALayerList, Index);

//  ModflowTypes.GetMFConductanceParamType.Create( ParamList, -1);
  ModflowTypes.GetMFLineSeepageElevationParamClassType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFSeepageTimeParamListType.Create( IndexedParamList2, -1);
  end;
end;

class Function TLineSeepageLayer.ANE_LayerName : string ;
begin
  result := kMFLineSeepage;
end;

//---------------------------
constructor TAreaSeepageLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;

//  ModflowTypes.GetMFConductanceParamType.Create( ParamList, -1);
  ModflowTypes.GetMFAreaSeepageElevationParamClassType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFSeepageTimeParamListType.Create( IndexedParamList2, -1);
  end;
end;

class Function TAreaSeepageLayer.ANE_LayerName : string ;
begin
  result := kMFAreaSeepage;
end;

end.
