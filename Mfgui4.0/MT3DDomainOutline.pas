unit MT3DDomainOutline;

interface

uses ANE_LayerUnit;

const
  kMT3DDomOutline = 'MT3D Domain Outline';

type
  TMT3DDomOutlineParam = class(T_ANE_LayerParam)
    constructor Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
      override;
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TMT3DDomOutlineLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses MFInactive, Variables;

class Function TMT3DDomOutlineParam.ANE_ParamName : string ;
begin
  result := kMT3DDomOutline;
end;

constructor TMT3DDomOutlineParam.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index, AParameterList);
  ValueType := pvInteger;
end;

function TMT3DDomOutlineParam.Value : string;
begin
  result := '$N/A';
end;

function TMT3DDomOutlineParam.Units : string;
begin
  result := '';
end;

//---------------------------
constructor TMT3DDomOutlineLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;
  Lock := Lock + [llType, llEvalAlg];
  ModflowTypes.GetMT3DDomOutlineParamClassType.Create(ParamList, -1);
end;

class Function TMT3DDomOutlineLayer.ANE_LayerName : string ;
begin
  result := kMT3DDomOutline;
end;

function TMT3DDomOutlineLayer.Units : string;
begin
  result := '';
end;

end.
 