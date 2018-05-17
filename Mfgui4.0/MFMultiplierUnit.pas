unit MFMultiplierUnit;

interface

uses Sysutils, ANE_LayerUnit;

type
  TMultiplierParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMultiplierGroupLayer = class(T_ANE_GroupLayer)
    public
      class Function ANE_LayerName : string ; override;
      function WriteIndex : string; override;
      function WriteOldIndex : string; override;
    end;

  TMultiplierLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function WriteIndex : string; override;
    function WriteOldIndex : string; override;
    function WriteLayerRoot: string; override;
    function Index : Integer; 
    class function WriteMultiplierRoot(RowIndex : integer) : string;
    class function GetRow(ParmIndex: integer): integer;
  end;

  TMultiplierList = Class(T_ANE_IndexedLayerList)
    constructor Create( AnOwner : T_ANE_ListOfIndexedLayerLists;
                Position: Integer); override;
  end;

implementation

Uses Variables, GetTypesUnit;

ResourceString
  kMultiplierGroup = 'Multiplier Layers';
  kMultiplier = 'Multiplier';

{ TMultiplierParam }

class function TMultiplierParam.ANE_ParamName: string;
begin
  result := kMultiplier;
end;


{ TMultiplierLayer }

class function TMultiplierLayer.ANE_LayerName: string;
begin
  result := kMultiplier;
end;

constructor TMultiplierLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  RenameAllParameters := True;
  ModflowTypes.GetMFMultiplierParamType.Create(ParamList, -1);
//  TMultiplierParam.Create(ParamList, -1);
end;

function TMultiplierLayer.Index: Integer;
var
  IndexedLayerList : T_ANE_IndexedLayerList;
begin
  Assert(LayerList is T_ANE_IndexedLayerList);

  IndexedLayerList := LayerList as T_ANE_IndexedLayerList;
//  result := IndexedLayerList.GetNonDeletedIndexOf(self);
  result := IndexedLayerList.NonDeletedIndexOf(self);
  if result = -1 then
  begin
    result := IndexedLayerList.NonDeletedLayerCount;
  end;
end;

function TMultiplierLayer.WriteIndex: string;
begin
  result := '';
end;

class function TMultiplierLayer.GetRow(ParmIndex : integer) : integer;
var
  RowIndex : integer;
  Row : integer;
  Count : integer;
begin
  Row := -1;
  Count := 0;
  with frmMODFLOW do
  begin
    for RowIndex := 1 to dgMultiplier.RowCount -1 do
    begin
      if dgMultiplier.Cells[2,RowIndex] = dgMultiplier.Columns[2].PickList[0] then
      begin
        Inc(Count);
        if Count = ParmIndex then
        begin
          Row := RowIndex;
          Break;
        end;
      end;
    end;
  end;
  result := Row;
end;

function TMultiplierLayer.WriteLayerRoot: string;
begin
  result := WriteMultiplierRoot(GetRow(Index));
end;

class function TMultiplierLayer.WriteMultiplierRoot(
  RowIndex: integer): string;
begin
  result := frmMODFLOW.dgMultiplier.Cells[1,RowIndex] + ' Layer';
end;

function TMultiplierLayer.WriteOldIndex: string;
begin
  result := '';
end;

{ TMultiplierList }

constructor TMultiplierList.Create(AnOwner: T_ANE_ListOfIndexedLayerLists;
  Position: Integer);
var
  Index : integer;
begin
  inherited;
  RenameAllLayers := True;
  ModflowTypes.GetMFMultiplierGroupLayerType.Create(self, -1);
  for Index := 0 to StrToInt(frmMODFLOW.adeMultCount.Text)-1 do
  begin
    ModflowTypes.GetMFMultiplierLayerType.Create(self, -1);
//    TMultiplierLayer.Create(self, -1);
  end;

end;

{ TMultiplierGroupLayer }

class function TMultiplierGroupLayer.ANE_LayerName: string;
begin
  result := kMultiplierGroup;
end;

function TMultiplierGroupLayer.WriteIndex: string;
begin
  result := ''
end;

function TMultiplierGroupLayer.WriteOldIndex: string;
begin
  result := ''
end;

end.
