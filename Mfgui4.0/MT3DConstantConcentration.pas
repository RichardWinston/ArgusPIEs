unit MT3DConstantConcentration;

interface

uses SysUtils, ANE_LayerUnit;

const
  kMT3DPointConstantConc = 'MT3D Point Constant Concentration Unit';
  kMT3DAreaConstantConc = 'MT3D Area Constant Concentration Unit';

type
  TMT3DAreaConstantConcParam = class(T_ANE_ParentIndexLayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
  end;

  TMT3DAreaConstantConc2Param = class(TMT3DAreaConstantConcParam)
    class Function ANE_ParamName : string ; override;
    function WriteName : string; override;
  end;

  TMT3DAreaConstantConc3Param = class(TMT3DAreaConstantConcParam)
    class Function ANE_ParamName : string ; override;
    function WriteName : string; override;
  end;

  TMT3DAreaConstantConc4Param = class(TMT3DAreaConstantConcParam)
    class Function ANE_ParamName : string ; override;
    function WriteName : string; override;
  end;

  TMT3DAreaConstantConc5Param = class(TMT3DAreaConstantConcParam)
    class Function ANE_ParamName : string ; override;
    function WriteName : string; override;
  end;

  TMT3DPointConstantConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

  TMT3DAreaConstantConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses MT3DGeneralParameters, Variables;

class Function TMT3DAreaConstantConcParam.ANE_ParamName : string ;
begin
  result := kMT3DAreaConstantConc;
end;

function TMT3DAreaConstantConcParam.Value : string;
begin
  result := kNA;
end;

//---------------------------

constructor TMT3DPointConstantConcLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
var
  NCOMP : integer;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leInterpolate;
  Lock := Lock + [llEvalAlg, llType];

  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMassParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMass2ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMass3ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMass4ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMass5ParamClassType.ANE_ParamName);

  ModflowTypes.GetMT3DMassParamClassType.Create(ParamList, -1 );
  NCOMP := StrToInt(frmModflow.adeMT3DNCOMP.Text);
  if NCOMP >= 2 then
  begin
    ModflowTypes.GetMT3DMass2ParamClassType.Create(ParamList, -1 );
  end;
  if NCOMP >= 3 then
  begin
    ModflowTypes.GetMT3DMass3ParamClassType.Create(ParamList, -1 );
  end;
  if NCOMP >= 4 then
  begin
    ModflowTypes.GetMT3DMass4ParamClassType.Create(ParamList, -1 );
  end;
  if NCOMP >= 5 then
  begin
    ModflowTypes.GetMT3DMass5ParamClassType.Create(ParamList, -1 );
  end;
end;

class Function TMT3DPointConstantConcLayer.ANE_LayerName : string ;
begin
  result := kMT3DPointConstantConc;
end;

function TMT3DPointConstantConcLayer.Units : string;
begin
  result := MT3DMassUnit;
end;

//---------------------------

constructor TMT3DAreaConstantConcLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
var
  NCOMP : integer;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;

  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DAreaConstantConcParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DAreaConstantConc2ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DAreaConstantConc3ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DAreaConstantConc4ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DAreaConstantConc5ParamClassType.ANE_ParamName);

  ModflowTypes.GetMT3DAreaConstantConcParamClassType.Create(ParamList, -1);
  NCOMP := StrToInt(frmModflow.adeMT3DNCOMP.Text);
  if NCOMP >= 2 then
  begin
    ModflowTypes.GetMT3DAreaConstantConc2ParamClassType.Create(ParamList, -1 );
  end;
  if NCOMP >= 3 then
  begin
    ModflowTypes.GetMT3DAreaConstantConc3ParamClassType.Create(ParamList, -1 );
  end;
  if NCOMP >= 4 then
  begin
    ModflowTypes.GetMT3DAreaConstantConc4ParamClassType.Create(ParamList, -1 );
  end;
  if NCOMP >= 5 then
  begin
    ModflowTypes.GetMT3DAreaConstantConc5ParamClassType.Create(ParamList, -1 );
  end;

end;

class Function TMT3DAreaConstantConcLayer.ANE_LayerName : string ;
begin
  result := kMT3DAreaConstantConc;
end;

function TMT3DAreaConstantConcLayer.Units : string;
begin
  result := MT3DMassUnit + '/' + LengthUnit + '^3';
end;

{ TMT3DAreaConstantConc2Param }

class function TMT3DAreaConstantConc2Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'B';
end;

function TMT3DAreaConstantConc2Param.WriteName: string;
begin
  result := inherited WriteName + 'B';
end;

{ TMT3DAreaConstantConc3Param }

class function TMT3DAreaConstantConc3Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'C';
end;

function TMT3DAreaConstantConc3Param.WriteName: string;
begin
  result := inherited WriteName + 'C';
end;

{ TMT3DAreaConstantConc4Param }

class function TMT3DAreaConstantConc4Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'D';
end;

function TMT3DAreaConstantConc4Param.WriteName: string;
begin
  result := inherited WriteName + 'D';
end;

{ TMT3DAreaConstantConc5Param }

class function TMT3DAreaConstantConc5Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'E';
end;

function TMT3DAreaConstantConc5Param.WriteName: string;
begin
  result := inherited WriteName + 'E';
end;

end.
