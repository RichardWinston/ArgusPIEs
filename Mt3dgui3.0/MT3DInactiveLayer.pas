unit MT3DInactiveLayer;

interface

uses ANE_LayerUnit;

const
  kMT3DInactive = 'Added MT3D Inactive Area Unit';

type
  TMT3DInactiveAreaParam = class(T_ANE_ParentIndexLayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
      override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMT3DInactiveAreaLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses MFInactive, Variables;

class Function TMT3DInactiveAreaParam.ANE_ParamName : string ;
begin
  result := kMT3DInactive;
end;

constructor TMT3DInactiveAreaParam.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TMT3DInactiveAreaParam.Value : string;
begin
  result := TInactiveLayer.ANE_LayerName;
end;
//---------------------------
constructor TMT3DInactiveAreaLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  Lock := Lock + [llType];
  ModflowTypes.GetMT3DInactiveAreaParamClassType.Create(ParamList, -1);
end;

class Function TMT3DInactiveAreaLayer.ANE_LayerName : string ;
begin
  result := kMT3DInactive;
end;

function TMT3DInactiveAreaLayer.Units : string;
begin
  result := '';
end;

end.
