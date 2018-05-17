unit MF_SWT;

interface

uses SysUtils, ANE_LayerUnit;

type
  T_SWT_Group = class(T_ANE_GroupLayer)
  public
    class Function ANE_LayerName : string ; override;
  end;

  TGeostaticStressParam  = class(T_ANE_LayerParam)
  public
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
  end;

  TGeostaticStressLayer = class(T_ANE_InfoLayer)
  public
    class Function ANE_LayerName : string ; override;
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
  end;

  TCustomSpecificGravityParam = class(T_ANE_LayerParam)
    function Units: string; override;
  end;

  TUnsaturatedSpecificGravityParam = class(TCustomSpecificGravityParam)
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TSaturatedSpecificGravityParam = class(TCustomSpecificGravityParam)
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TSpecificGravityLayer = class(T_ANE_InfoLayer)
  public
    class Function ANE_LayerName : string ; override;
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
  end;

  TSwtThicknessParam  = class(T_ANE_LayerParam)
  public
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TCustomSpecificStorageParam = class(T_ANE_LayerParam)
    function Units: string; override;
  end;

  TInitialElasticSpecificStorageParam  = class(TCustomSpecificStorageParam)
  public
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TInitialInelasticSpecificStorageParam  = class(TCustomSpecificStorageParam)
  public
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TCustomCompressionIndexParam = class(T_ANE_LayerParam)
    function Units: string; override;
  end;

  TCompressionIndexParam = class(TCustomCompressionIndexParam)
  public
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TRecompressionIndexParam = class(TCustomCompressionIndexParam)
  public
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TInitialVoidRatioParam  = class(T_ANE_LayerParam)
  public
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TInitialCompactionParam  = class(T_ANE_LayerParam)
  public
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
  end;

  TCustomStressParam = class(T_ANE_LayerParam)
    function Units: string; override;
  end;

  TInitialEffectiveStressOffsetParam = class(TCustomStressParam)
  public
    class Function ANE_ParamName : string ; override;
  end;

  TInitialPreconsolidationStressParam = class(TCustomStressParam)
  public
    class Function ANE_ParamName : string ; override;
  end;

  TSwtIndexedParamList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer); override;
  end;

  TSwtUnitLayer = class(T_ANE_InfoLayer)
  private
    function GetCount: integer;
    procedure SetCount(const Value: integer);
  public
    constructor Create(ALayerList: T_ANE_LayerList; Index: Integer); override;
    class function ANE_LayerName: string; override;
    property Count: integer read GetCount write SetCount;
  end;

implementation

uses Variables;

const
  kSWT = 'SWT';
  kGeostaticStress = 'Geostatic Stress';
  kUnsaturatedSpecificGravity = 'Unsaturated Specific Gravity';
  KSaturatedSpecificGravity = 'Saturated Specific Gravity';
  KSpecificGravity = 'Specific Gravity';
  kThickness = 'Thickness';
  kInitialElasticSpecificStorage = 'Initial Elastic Specific Storage';
  kInitialInelasticSpecificStorage = 'Initial Inelastic Specific Storage';
  kDimensionless = 'dimensionless';
  kCompressionIndex = 'Compression Index';
  kRecompressionIndex = 'Recompression Index';
  kInitialVoidRatio = 'Initial Void Ratio';
  kInitialCompaction = 'Initial Compaction';
  KInitialEffectiveStressOffset = 'Initial Effective Stress Offset';
  kInitialPreconsolidationStress = 'Initial Preconsolidation Stress';
  KSwtUnit = 'SWT Unit';

{ T_SWT_Group }

class function T_SWT_Group.ANE_LayerName: string;
begin
  result := kSWT;
end;

{ TGeostaticStressParam }

class function TGeostaticStressParam.ANE_ParamName: string;
begin
  result := kGeostaticStress;
end;

function TGeostaticStressParam.Units: string;
begin
  result := LengthUnit;
end;

{ TGeostaticStressLayer }

class function TGeostaticStressLayer.ANE_LayerName: string;
begin
  result := kGeostaticStress;
end;

constructor TGeostaticStressLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited Create(ALayerList, Index);
  ModflowTypes.GetMFGeostaticStressParamType.Create( ParamList, -1);
end;

{ TCustomSpecificGravityParam }

function TCustomSpecificGravityParam.Units: string;
begin
  result := kDimensionless;
end;

{ TUnsaturatedSpecificGravityParam }

class function TUnsaturatedSpecificGravityParam.ANE_ParamName: string;
begin
  result := kUnsaturatedSpecificGravity;
end;

function TUnsaturatedSpecificGravityParam.Value: string;
begin
  result := '1.7';
end;

{ TSaturatedSpecificGravityParam }

class function TSaturatedSpecificGravityParam.ANE_ParamName: string;
begin
  result := KSaturatedSpecificGravity;
end;

function TSaturatedSpecificGravityParam.Value: string;
begin
  result := '2.0';
end;

{ TSpecificGravityLayer }

class function TSpecificGravityLayer.ANE_LayerName: string;
begin
  result := KSpecificGravity;
end;

constructor TSpecificGravityLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ModflowTypes.GetMFSaturatedSpecificGravityParamType.Create( ParamList, -1);
  ModflowTypes.GetMFUnsaturatedSpecificGravityParamType.Create( ParamList, -1);
end;

{ TSwtThicknessParam }

class function TSwtThicknessParam.ANE_ParamName: string;
begin
  result := kThickness;
end;

function TSwtThicknessParam.Units: string;
begin
  result := LengthUnit;
end;

function TSwtThicknessParam.Value: string;
begin
  result := '1';
end;

{ TCustomSpecificStorageParam }

function TCustomSpecificStorageParam.Units: string;
begin
  result := '1/' + LengthUnit;
end;

{ TInitialElasticSpecificStorageParam }

class function TInitialElasticSpecificStorageParam.ANE_ParamName: string;
begin
  result := kInitialElasticSpecificStorage;
end;

function TInitialElasticSpecificStorageParam.Value: string;
begin
  result := '1e-5';
end;

{ TInitialInelasticSpecificStorageParam }

class function TInitialInelasticSpecificStorageParam.ANE_ParamName: string;
begin
  result := kInitialInelasticSpecificStorage;
end;

function TInitialInelasticSpecificStorageParam.Value: string;
begin
  result := '1e-4';
end;

{ TCustomCompressionIndexParam }

function TCustomCompressionIndexParam.Units: string;
begin
  result := kDimensionless;
end;

{ TCompressionIndexParam }

class function TCompressionIndexParam.ANE_ParamName: string;
begin
  result := kCompressionIndex;
end;

function TCompressionIndexParam.Value: string;
begin
  result := '0.25';
end;

{ TRecompressionIndexParam }

class function TRecompressionIndexParam.ANE_ParamName: string;
begin
  result := kRecompressionIndex;
end;

function TRecompressionIndexParam.Value: string;
begin
  result := '0.01';
end;

{ TInitialVoidRatioParam }

class function TInitialVoidRatioParam.ANE_ParamName: string;
begin
  result := kInitialVoidRatio;
end;

function TInitialVoidRatioParam.Units: string;
begin
   result := kDimensionless;
end;

function TInitialVoidRatioParam.Value: string;
begin
  result := '0.8';
end;

{ TInitialCompactionParam }

class function TInitialCompactionParam.ANE_ParamName: string;
begin
  result := kInitialCompaction;
end;

function TInitialCompactionParam.Units: string;
begin
  result := LengthUnit;
end;

{ TCustomStressParam }

function TCustomStressParam.Units: string;
begin
  result := LengthUnit;
end;

{ TInitialEffectiveStressOffsetParam }

class function TInitialEffectiveStressOffsetParam.ANE_ParamName: string;
begin
  result := KInitialEffectiveStressOffset;
end;

{ TInitialPreconsolidationStressParam }

class function TInitialPreconsolidationStressParam.ANE_ParamName: string;
begin
  result := kInitialPreconsolidationStress;
end;

{ TSwtIndexedParamList }

constructor TSwtIndexedParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.GetMFSwtThicknessParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFCompressionIndexParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFRecompressionIndexParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFInitialElasticSpecificStorageParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFInitialInelasticSpecificStorageParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFInitialVoidRatioParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFInitialCompactionParamType.ANE_ParamName);
//  ParameterOrder.Add(ModflowTypes.GetMFInitialEffectiveStressOffsetParamType.ANE_ParamName);
//  ParameterOrder.Add(ModflowTypes.GetMFInitialPreconsolidationStressParamType.ANE_ParamName);

  ModflowTypes.GetMFSwtThicknessParamType.Create( self, -1);
  if frmModflow.comboSwtICRCC.ItemIndex = 0 then
  begin
    ModflowTypes.GetMFCompressionIndexParamType.Create( self, -1);
    ModflowTypes.GetMFRecompressionIndexParamType.Create( self, -1);
  end
  else
  begin
    ModflowTypes.GetMFInitialElasticSpecificStorageParamType.Create( self, -1);
    ModflowTypes.GetMFInitialInelasticSpecificStorageParamType.Create( self, -1);
  end;

  ModflowTypes.GetMFInitialVoidRatioParamType.Create( self, -1);
  ModflowTypes.GetMFInitialCompactionParamType.Create( self, -1);
//  if frmModflow.comboSwtISTPCS.ItemIndex = 0 then
//  begin
//    ModflowTypes.GetMFInitialPreconsolidationStressParamType.Create( self, -1);
//  end
//  else
//  begin
//    ModflowTypes.GetMFInitialEffectiveStressOffsetParamType.Create( self, -1);
//  end;
end;

  { TSwtUnitLayer }
  
class function TSwtUnitLayer.ANE_LayerName: string;
begin
  result := KSwtUnit;
end;

constructor TSwtUnitLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  UnitIndex: integer;
  ParamListIndex: integer;
begin
  inherited;
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFInitialEffectiveStressOffsetParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFInitialPreconsolidationStressParamType.ANE_ParamName);
  if frmModflow.comboSwtISTPCS.ItemIndex = 0 then
  begin
    ModflowTypes.GetMFInitialPreconsolidationStressParamType.Create(ParamList, -1);
  end
  else
  begin
    ModflowTypes.GetMFInitialEffectiveStressOffsetParamType.Create(ParamList, -1);
  end;

  UnitIndex := StrToInt(WriteIndex);
  for ParamListIndex := 0 to frmModflow.SwtInterbedCount(UnitIndex) -1 do
  begin
    ModflowTypes.GetMFSwtIndexedParamListType.Create(IndexedParamList0, -1);
  end;
end;

function TSwtUnitLayer.GetCount: integer;
var
  Index: integer;
  ParamList: T_ANE_IndexedParameterList;
begin
  result := 0;
  for Index := 0 to IndexedParamList0.Count -1 do
  begin
    ParamList := IndexedParamList0.Items[Index];
    if ParamList.Status <> sDeleted then
    begin
      Inc(result);
    end;
  end;
end;

procedure TSwtUnitLayer.SetCount(const Value: integer);
var
  Index: integer;
  ParamList: T_ANE_IndexedParameterList;
begin
  inherited;
  if IndexedParamList0.Count >= Value then
  begin
    for Index := IndexedParamList0.Count -1 downto 0 do
    begin
      ParamList := IndexedParamList0.Items[Index];
      if (Index < Value) then
      begin
        if ParamList.Status = sDeleted then
        begin
          ParamList.Status := sNormal;
        end;
      end
      else
      begin
        ParamList.DeleteSelf;
      end;
    end;
  end
  else
  begin
    for Index := 0 to IndexedParamList0.Count -1 do
    begin
      ParamList := IndexedParamList0.Items[Index];
      if ParamList.Status = sDeleted then
      begin
        ParamList.Status := sNormal;
      end;
    end;
    for Index := IndexedParamList0.Count to Value-1 do
    begin
      ModflowTypes.GetMFSwtIndexedParamListType.Create(IndexedParamList0, -1);
    end;
  end;
end;

end.
