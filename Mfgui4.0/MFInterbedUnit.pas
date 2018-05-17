unit MFInterbedUnit;

interface

uses ANE_LayerUnit;

type
  TPreconsolidationHeadParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TElasticStorageFactorParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TInelasticStorageFactorParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TStartingCompactionParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TIBSLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

resourcestring
  kPreconsolidationHead = 'Preconsolidation head';
  kElasticStorageFactor = 'Elastic storage factor';
  kInelasticStorageFactor = 'Inelastic storage factor';
  kStartingCompaction = 'Starting compaction';
  kInterbedStorageUnit = 'Interbed Storage Unit';


{ TPreconsolidationHeadParam }

class function TPreconsolidationHeadParam.ANE_ParamName: string;
begin
  result := kPreconsolidationHead;
end;

function TPreconsolidationHeadParam.Units: string;
begin
  result := LengthUnit;
end;

{ TElasticStorageFactorParam }

class function TElasticStorageFactorParam.ANE_ParamName: string;
begin
  result := kElasticStorageFactor;
end;

{ TInelasticStorageFactorParam }

class function TInelasticStorageFactorParam.ANE_ParamName: string;
begin
  result := kInelasticStorageFactor;
end;

{ TStartingCompactionParam }

class function TStartingCompactionParam.ANE_ParamName: string;
begin
  result := kStartingCompaction;
end;

{ TIBSLayer }

class function TIBSLayer.ANE_LayerName: string;
begin
  result := kInterbedStorageUnit;
end;

constructor TIBSLayer.Create(ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited;
  ModflowTypes.GetMFPreconsolidationHeadParamType.Create( ParamList, -1);
  ModflowTypes.GetMFElasticStorageFactorParamType.Create( ParamList, -1);
  ModflowTypes.GetMFInelasticStorageFactorParamType.Create( ParamList, -1);
  ModflowTypes.GetMFStartingCompactionParamType.Create( ParamList, -1);
end;

end.
