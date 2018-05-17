unit MainLayerStructure;

interface

uses ANE_LayerUnit;

Type
  TMyMeshDensityParameter = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function value : string; override;
  end;

  TMyDomainOutlineLayer = class(T_ANE_DomainOutlineLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
  end;

  TMyMeshDensityLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
  end;

  TMyParameter = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function value : string; override;
  end;

  TMyOptionalParameter = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function value : string; override;
    class function IncludeOptionalParameters : boolean;
  end;

  TMyTimeParameter = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function value : string; override;
  end;

  TMyOptionalTimeParameter = class(TMyOptionalParameter)
    class Function ANE_ParamName : string ; override;
    function value : string; override;
  end;

  TTimeParameterList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner :T_ANE_ListOfIndexedParameterLists;
      Position: Integer ); override;
  end;

  TMyInformationLayer = class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
  end;

  TMyOptionalInformationLayer = class(TMyInformationLayer)
    class Function ANE_LayerName : string ; override;
    class Function IncludeOptionalLayer : boolean;
  end;

  TGeologicUnit = class(T_ANE_IndexedLayerList)
    constructor Create(AnOwner : T_ANE_ListOfIndexedLayerLists;
      Position: Integer); override;
  end;

  TMyMeshNodeParameter = class(T_ANE_MeshParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
    function Value : String; override;
    class Function ANE_ParamName : string ; override;
  end;

  TMyMeshElementParameter = class(TMyMeshNodeParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer); override;
  end;

  TMyMesh = class(T_ANE_TriMeshLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
  end;

  TMyLayerStructure = class(TLayerStructure)
    constructor Create;
  end;

implementation

uses MainForm;

{ TMyDomainOutlineLayer }

class function TMyDomainOutlineLayer.ANE_LayerName: string;
begin
  result := 'My Domain Outline';
end;

constructor TMyDomainOutlineLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  TMyMeshDensityParameter.Create(self.ParamList, -1);
end;

{ TMyMeshDensityParameter }

class function TMyMeshDensityParameter.ANE_ParamName: string;
begin
  Result := 'Mesh Density';
end;

function TMyMeshDensityParameter.value: string;
begin
  result := '1';
end;

{ TMyMeshDensityLayer }

class function TMyMeshDensityLayer.ANE_LayerName: string;
begin
  result := 'My Mesh Density Layer';
end;

constructor TMyMeshDensityLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  TMyMeshDensityParameter.Create(self.ParamList, -1);
end;

{ TMyParameter }

class function TMyParameter.ANE_ParamName: string;
begin
  result := 'My Parameter';
end;

function TMyParameter.value: string;
begin
  result := '2';
end;

{ TMyOptionalParameter }

class function TMyOptionalParameter.ANE_ParamName: string;
begin
  result := 'My Optional parameter';
end;

class function TMyOptionalParameter.IncludeOptionalParameters: boolean;
begin
  result := frmMain.cbOptionalParameter.Checked;
end;

function TMyOptionalParameter.value: string;
begin
  result := '3';
end;

{ TMyInformationLayer }

class function TMyInformationLayer.ANE_LayerName: string;
begin
  result := 'My Information Layer';
end;

constructor TMyInformationLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : integer;
begin
  inherited;
  ParamList.ParameterOrder.Add(TMyParameter.ANE_ParamName);
  ParamList.ParameterOrder.Add(TMyOptionalParameter.ANE_ParamName);

  TMyParameter.Create(ParamList,-1);
  if TMyOptionalParameter.IncludeOptionalParameters then
  begin
    TMyOptionalParameter.Create(ParamList,-1);
  end;

  for TimeIndex := 0 to frmMain.NumberOfTimes -1 do
  begin
    TTimeParameterList.Create(IndexedParamList2, -1);
  end;

end;

{ TMyOptionalInformationLayer }

class function TMyOptionalInformationLayer.ANE_LayerName: string;
begin
  result := 'My Optional Information Layer';
end;

class function TMyOptionalInformationLayer.IncludeOptionalLayer: boolean;
begin
  result := frmMain.cbOptionalLayers.Checked;
end;

{ TGeologicUnit }

constructor TGeologicUnit.Create(AnOwner: T_ANE_ListOfIndexedLayerLists;
  Position: Integer);
begin
  inherited;
  LayerOrder.Add(TMyInformationLayer.ANE_LayerName);
  LayerOrder.Add(TMyOptionalInformationLayer.ANE_LayerName);

  TMyInformationLayer.Create(self,-1);
  if TMyOptionalInformationLayer.IncludeOptionalLayer then
  begin
    TMyOptionalInformationLayer.Create(self,-1);
  end;
end;

{ TMyTimeParameter }

class function TMyTimeParameter.ANE_ParamName: string;
begin
  result := 'My Time Parameter'
end;

function TMyTimeParameter.value: string;
begin
  result := '4'
end;

{ TMyOptionalTimeParameter }

class function TMyOptionalTimeParameter.ANE_ParamName: string;
begin
  result := 'My Optional Time Parameter'
end;

function TMyOptionalTimeParameter.value: string;
begin
  result := '5'
end;

{ TTimeParameterList }

constructor TTimeParameterList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(TMyTimeParameter.ANE_ParamName);
  ParameterOrder.Add(TMyOptionalTimeParameter.ANE_ParamName);

  TMyTimeParameter.Create(self, -1);
  if TMyOptionalTimeParameter.IncludeOptionalParameters then
  begin
    TMyOptionalTimeParameter.Create(self, -1);
  end;
end;

{ TMyLayerStructure }

constructor TMyLayerStructure.Create;
var
  LayerIndex : integer;
begin
  inherited;
  TMyDomainOutlineLayer.Create(UnIndexedLayers, -1);
  TMyMeshDensityLayer.Create(UnIndexedLayers, -1);
  TMyMesh.Create(UnIndexedLayers, -1);
  TMyInformationLayer.Create(UnIndexedLayers, -1);
  if TMyOptionalInformationLayer.IncludeOptionalLayer then
  begin
    TMyOptionalInformationLayer.Create(UnIndexedLayers, -1);
  end;
  for LayerIndex := 0 to frmMain.NumberOfGeologicUnits -1 do
  begin
    TGeologicUnit.Create(ListsOfIndexedLayers, -1);
  end;

end;

{ TMyMeshNodeParameter }

class function TMyMeshNodeParameter.ANE_ParamName: string;
begin
  result := 'My Node Parameter';
end;

constructor TMyMeshNodeParameter.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ParameterType := mptNode;
end;

function TMyMeshNodeParameter.Value: String;
begin
  result := TMyInformationLayer.ANE_LayerName + '.'
    + TMyParameter.ANE_ParamName;
end;

{ TMyMeshElementParameter }

class function TMyMeshElementParameter.ANE_ParamName: string;
begin
  result := 'My Element Parameter';

end;

constructor TMyMeshElementParameter.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ParameterType := mptElement;
end;

{ TMyMesh }

constructor TMyMesh.Create(ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited;
  DomainLayer := TMyDomainOutlineLayer.ANE_LayerName;
  DensityLayer := TMyMeshDensityLayer.ANE_LayerName;
  TMyMeshNodeParameter.Create(ParamList, -1);
  TMyMeshElementParameter.Create(ParamList, -1);
end;

end.
