unit MFSubsidence;

interface

{MFSubsidence defines the layers and parameters used by the Subsidence
  and Aquifer-System Compaction Package.}

uses SysUtils, Dialogs, ANE_LayerUnit, MFInterbedUnit;

type
  TElasticStorageCoefficientParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TInelasticStorageCoefficientParam = class(TElasticStorageCoefficientParam)
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TElasticSpecificStorageParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TInelasticSpecificStorageParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  TStartingHeadParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
  end;

  TVerticalHydraulicConductivityParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
    function Value: string; override;
  end;

  TEquivalentThicknessParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units: string; override;
  end;

  TEquivalentNumberParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;



  TNoDelayIndexedParamList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer); override;
  end;

  TDelayIndexedParamList = class(T_ANE_IndexedParameterList)
    constructor Create(AnOwner: T_ANE_ListOfIndexedParameterLists;
      Position: Integer); override;
  end;

  TCustomSubsidenceLayer = class(T_ANE_InfoLayer)
  protected
    function GetParamListType: T_ANE_IndexedParameterListClass; virtual; abstract;
    procedure SetCount(const Value: integer);
    function GetCount: integer;
  public
    constructor Create(ALayerList: T_ANE_LayerList; Index: Integer); override;
    property Count: integer read GetCount write SetCount;
  end;

  TNoDelaySubsidenceLayer = class(TCustomSubsidenceLayer)
  public
    function GetParamListType: T_ANE_IndexedParameterListClass; override;
    constructor Create(ALayerList: T_ANE_LayerList; Index: Integer); override;
    class function ANE_LayerName: string; override;
  end;

  TDelaySubsidenceLayer = class(TCustomSubsidenceLayer)
  public
    function GetParamListType: T_ANE_IndexedParameterListClass; override;
    constructor Create(ALayerList: T_ANE_LayerList; Index: Integer); override;
    class function ANE_LayerName: string; override;
  end;

implementation

uses Variables;

ResourceString
  kElasticStorageCoefficient = 'Elastic Storage Coefficient';
  kInelasticStorageCoefficient = 'Inelastic Storage Coefficient';
  kElasticStorage = 'Elastic Specific Storage';
  kInelasticStorage = 'Inelastic Specific Storage';
  kStartingHead = 'Starting Head';
  kVerticalHydraulicCond = 'Vertical Hydraulic Conductivity';
  kEquivalentThickness = 'Equivalent Thickness';
  kEquivalentNumber = 'Equivalent Number';
  kNoDelaySubsidence = 'No Delay Subsidence Unit';
  kDelaySubsidence = 'Delay Subsidence Unit';

{ TNoDelayIndexedParamList }

constructor TNoDelayIndexedParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ModflowTypes.GetMFPreconsolidationHeadParamType.Create( self, -1);
  ModflowTypes.GetMFElasticStorageCoefficientParamType.Create( self, -1);
  ModflowTypes.GetMFInelasticStorageCoefficientParamType.Create( self, -1);
  ModflowTypes.GetMFStartingCompactionParamType.Create( self, -1);
end;

{ TNoDelaySubsidenceLayer }

class function TNoDelaySubsidenceLayer.ANE_LayerName: string;
begin
  result := kNoDelaySubsidence;
end;

constructor TNoDelaySubsidenceLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  UnitIndex: integer;
  ParamListIndex: integer;
begin
  inherited;
  UnitIndex := StrToInt(WriteIndex);
  for ParamListIndex := 0 to frmModflow.NoDelayInterbedCount(UnitIndex) -1 do
  begin
    ModflowTypes.GetMFNoDelayIndexedParamListType.Create(IndexedParamList0, -1);
  end;
end;

function TNoDelaySubsidenceLayer.GetParamListType: T_ANE_IndexedParameterListClass;
begin
  result := ModflowTypes.GetMFNoDelayIndexedParamListType;
end;


{ TElasticStorageCoefficientParam }

class function TElasticStorageCoefficientParam.ANE_ParamName: string;
begin
  result := kElasticStorageCoefficient;
end;

function TElasticStorageCoefficientParam.Units: string;
begin
  result := 'dimensionless';
end;

function TElasticStorageCoefficientParam.Value: string;
begin
  result := '1e-5';
end;

{ TInelasticStorageCoefficientParam }

class function TInelasticStorageCoefficientParam.ANE_ParamName: string;
begin
  result := kInelasticStorageCoefficient;
end;

function TInelasticStorageCoefficientParam.Value: string;
begin
  result := '1e-3';
end;

{ TStartingHeadParam }

class function TStartingHeadParam.ANE_ParamName: string;
begin
  result := kStartingHead;
end;

function TStartingHeadParam.Units: string;
begin
  result := LengthUnit;
end;

{ TVerticalHydraulicConductivityParam }

class function TVerticalHydraulicConductivityParam.ANE_ParamName: string;
begin
  result := kVerticalHydraulicCond;
end;

function TVerticalHydraulicConductivityParam.Units: string;
begin
  result := LengthUnit + '/' + TimeUnit
end;

function TVerticalHydraulicConductivityParam.Value: string;
begin
  result := '1e-6';
end;

{ TEquivalentThicknessParam }

class function TEquivalentThicknessParam.ANE_ParamName: string;
begin
  result := kEquivalentThickness;
end;

function TEquivalentThicknessParam.Units: string;
begin
  result := LengthUnit;
end;

{ TEquivalentNumberParam }

class function TEquivalentNumberParam.ANE_ParamName: string;
begin
  result := kEquivalentNumber;
end;

{ TDelayIndexedParamList }

constructor TDelayIndexedParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ModflowTypes.GetMFVerticalHydraulicConductivityParamType.Create( self, -1);
  ModflowTypes.GetMFStartingHeadParamType.Create( self, -1);
  ModflowTypes.GetMFPreconsolidationHeadParamType.Create( self, -1);
  ModflowTypes.GetMFElasticSpecificStorageParamType.Create( self, -1);
  ModflowTypes.GetMFInelasticSpecificStorageParamType.Create( self, -1);
  ModflowTypes.GetMFStartingCompactionParamType.Create( self, -1);
  ModflowTypes.GetMFEquivalentThicknessParamType.Create( self, -1);
  ModflowTypes.GetMFEquivalentNumberParamType.Create( self, -1);
end;

{ TDelaySubsidenceLayer }

class function TDelaySubsidenceLayer.ANE_LayerName: string;
begin
  result := kDelaySubsidence;
end;

constructor TDelaySubsidenceLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  UnitIndex: integer;
  ParamListIndex: integer;
begin
  inherited;
  UnitIndex := StrToInt(WriteIndex);
  for ParamListIndex := 0 to frmModflow.DelayInterbedCount(UnitIndex) -1 do
  begin
    ModflowTypes.GetMFDelayIndexedParamListType.Create(IndexedParamList0, -1);
  end;
end;

function TDelaySubsidenceLayer.GetParamListType: T_ANE_IndexedParameterListClass;
begin
  result := ModflowTypes.GetMFDelayIndexedParamListType;
end;

{ TCustomSubsidenceLayer }

constructor TCustomSubsidenceLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := leExact;
end;

function TCustomSubsidenceLayer.GetCount: integer;
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

procedure TCustomSubsidenceLayer.SetCount(const Value: integer);
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
      GetParamListType.Create(IndexedParamList0, -1);
    end;
  end;
end;

{ TElasticSpecificStorageParam }

class function TElasticSpecificStorageParam.ANE_ParamName: string;
begin
  result := kElasticStorage;
end;

function TElasticSpecificStorageParam.Units: string;
begin
  result := '1/' + LengthUnit;
end;

function TElasticSpecificStorageParam.Value: string;
begin
  result := '1e-6';
end;

{ TInelasticSpecificStorageParam }

class function TInelasticSpecificStorageParam.ANE_ParamName: string;
begin
  result := kInelasticStorage;
end;

function TInelasticSpecificStorageParam.Value: string;
begin
  result := '1e-4';
end;

end.

