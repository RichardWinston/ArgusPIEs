unit MFZoneUnit;

interface

uses Sysutils, ANE_LayerUnit;

type
  TZoneParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value: string; override;
    function Units: String; override;
  end;

  TZoneGroupLayer = class(T_ANE_GroupLayer)
    public
      class Function ANE_LayerName : string ; override;
      function WriteIndex : string; override;
      function WriteOldIndex : string; override;
    end;

  TZoneLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function WriteIndex : string; override;
    function WriteOldIndex : string; override;
    function WriteLayerRoot: string; override;
    class function WriteZoneRoot(RowIndex : integer) : String; virtual;
    function Index : Integer;
  end;

  TZoneList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

implementation

Uses Variables, GetTypesUnit;

ResourceString
  kZoneGroup = 'Zone Layers';
  kZone = 'Zone';

{ TZoneParam }

class function TZoneParam.ANE_ParamName: string;
begin
  result := kZone;
end;

constructor TZoneParam.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
//  SetValue := True;
end;


function TZoneParam.Units: String;
begin
  result := 'positive integer';
end;

function TZoneParam.Value: string;
begin
  result := '1';
end;

{ TZoneLayer }

class function TZoneLayer.ANE_LayerName: string;
begin
  result := kZone;
end;

constructor TZoneLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := leExact;
  Lock := Lock + [llEvalAlg];
  RenameAllParameters := True;
  ModflowTypes.GetMFZoneParamType.Create(ParamList, -1);
//  TZoneParam.Create(ParamList, -1);
end;

function TZoneLayer.Index: Integer;
var
  IndexedLayerList : T_ANE_IndexedLayerList;
begin

  Assert(LayerList is T_ANE_IndexedLayerList);

  IndexedLayerList := LayerList as T_ANE_IndexedLayerList;
  result := IndexedLayerList.IndexOf(self);
  if result = -1 then
  begin
    result := IndexedLayerList.Count;
  end;
end;

function TZoneLayer.WriteIndex: string;
begin
  result := '';
end;

function TZoneLayer.WriteLayerRoot: string;
begin
  result := WriteZoneRoot(Index);
end;

function TZoneLayer.WriteOldIndex: string;
begin
  result := '';
end;

class function TZoneLayer.WriteZoneRoot(RowIndex: integer): String;
begin
  result := frmMODFLOW.sgZoneArrays.Cells[1,RowIndex] + ' Layer';
end;

{ TZoneList }

constructor TZoneList.Create(AnOwner: T_ANE_ListOfIndexedLayerLists;
  Position: Integer);
var
  Index : integer;
begin
  inherited;
  RenameAllLayers := True;
  ModflowTypes.GetMFZoneGroupLayerType.Create(self, -1);
  for Index := 0 to StrToInt(frmMODFLOW.adeMultCount.Text)-1 do
  begin
    ModflowTypes.GetMFZoneLayerType.Create(self, -1);
//    TZoneLayer.Create(self, -1);
  end;

end;

{ TZoneGroupLayer }

class function TZoneGroupLayer.ANE_LayerName: string;
begin
  result := kZoneGroup;
end;

function TZoneGroupLayer.WriteIndex: string;
begin
  result := ''
end;

function TZoneGroupLayer.WriteOldIndex: string;
begin
  result := ''
end;

end. 
