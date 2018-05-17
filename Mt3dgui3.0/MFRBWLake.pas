unit MFRBWLake;

interface

uses ANE_LayerUnit, SysUtils;

const
  kMFLakeName = 'Lake Name';
  kMFLakeNumber = 'Lake Number';
  kMFLakeSimulMode = 'Simulation mode';
  kMFLakeStartStage = 'Starting Stage';
  kMFLakeMaxIterations = 'Max Iterations';
  kMFLakeStageConvCrit = 'Stage Convergence Criterion';
  kMFLakeMaxStage = 'Maximum Lake Stage';
  kMFLakeHydCond = 'Lakebed hydraulic conductivity';
  kMFLakeInputStream = 'Input Stream';
  kMFLakeOutputStream = 'Output Stream';
  kMFLakeCutOff = 'Eq Cutoff';
  kMFLakeConst = 'Eq Const';
  kMFLakeEqElev = 'Eq Elev';
  kMFLakeEqExp = 'Eq exponent';
  kMFLakeTopElev = 'Lakebed top elev';
  kMFLakeBottomElev = 'Lakebed bottom elev';
  kMFLakePrecipitation = 'Precipitation';
  kMFLakeEvapotranspiration = 'Evapotranspiration';
  kMFLakeRunoff = 'Runoff';
  kMFLakeRecharge = 'Dry Recharge';
  kMFLakeOutputOption = 'Output option';
  kMFLakeStage = 'Stage';
  kMFLakeLayer = 'Lake Unit';


type
  TLakeNameParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer);
      override;
    function Units : string; override;
    function Value : string; override;
  end;

  TLakeNumberParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer);
      override;
    function Units : string; override;
  end;

  TLakeSimulModeParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer);
      override;
    function Units : string; override;
  end;

  TLakeStartStageParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeMaxIterations = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer);
      override;
    function Units : string; override;
    function Value : string; override;
  end;

  TLakeStageConvCrit = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TLakeMaxStageParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeHydCond = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TLakeInputStreamParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer);
      override;
    function Units : string; override;
  end;

  TLakeOutputStreamParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer);
      override;
    function Units : string; override;
  end;

  TLakeCutOff1Param = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  function WriteName : string; override;
  function WriteSpecialEnd : string; override;
//  function WriteIndex : string; override;
  end;

  TLakeCutOff2Param = class(TLakeCutOff1Param)
    class Function ANE_ParamName : string ; override;
  function WriteSpecialEnd : string; override;
    function Value : string; override;
  end;

  TLakeCutOff3Param = class(TLakeCutOff2Param)
    class Function ANE_ParamName : string ; override;
  function WriteSpecialEnd : string; override;
  end;

  TLakeCutOff4Param = class(TLakeCutOff2Param)
    class Function ANE_ParamName : string ; override;
  function WriteSpecialEnd : string; override;
  end;

  TLakeCutOff5Param = class(TLakeCutOff2Param)
    class Function ANE_ParamName : string ; override;
  function WriteSpecialEnd : string; override;
  end;

  TLakeCnst1Param = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function WriteName : string; override;
    function WriteSpecialEnd : string; override;
//    function WriteIndex : string; override;
  end;

  TLakeCnst2Param = class(TLakeCnst1Param)
    class Function ANE_ParamName : string ; override;
    function WriteSpecialEnd : string; override;
    function Value : string; override;
  end;

  TLakeCnst3Param = class(TLakeCnst2Param)
    class Function ANE_ParamName : string ; override;
    function WriteSpecialEnd : string; override;
  end;

  TLakeCnst4Param = class(TLakeCnst2Param)
    class Function ANE_ParamName : string ; override;
    function WriteSpecialEnd : string; override;
  end;

  TLakeCnst5Param = class(TLakeCnst2Param)
    class Function ANE_ParamName : string ; override;
    function WriteSpecialEnd : string; override;
  end;

  TLakeEqElev1Param = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function WriteName : string; override;
    function WriteSpecialEnd : string; override;
//    function WriteIndex : string; override;
  end;

  TLakeEqElev2Param = class(TLakeEqElev1Param)
    class Function ANE_ParamName : string ; override;
    function WriteSpecialEnd : string; override;
    function Value : string; override;
  end;

  TLakeEqElev3Param = class(TLakeEqElev2Param)
    class Function ANE_ParamName : string ; override;
    function WriteSpecialEnd : string; override;
  end;

  TLakeEqElev4Param = class(TLakeEqElev2Param)
    class Function ANE_ParamName : string ; override;
    function WriteSpecialEnd : string; override;
  end;

  TLakeEqElev5Param = class(TLakeEqElev2Param)
    class Function ANE_ParamName : string ; override;
    function WriteSpecialEnd : string; override;
  end;

  TLakeEqExp1Param = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    function WriteName : string; override;
    function WriteSpecialEnd : string; override;
//    function WriteIndex : string; override;
  end;

  TLakeEqExp2Param = class(TLakeEqExp1Param)
    class Function ANE_ParamName : string ; override;
    function WriteSpecialEnd : string; override;
    function Value : string; override;
  end;

  TLakeEqExp3Param = class(TLakeEqExp2Param)
    class Function ANE_ParamName : string ; override;
    function WriteSpecialEnd : string; override;
  end;

  TLakeEqExp4Param = class(TLakeEqExp2Param)
    class Function ANE_ParamName : string ; override;
    function WriteSpecialEnd : string; override;
  end;

  TLakeEqExp5Param = class(TLakeEqExp2Param)
    class Function ANE_ParamName : string ; override;
    function WriteSpecialEnd : string; override;
  end;

  TLakeTopElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeBottomElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakePrecipParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeEvapParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeRunoffParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeRechargeParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeOutputOptionParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TLakeStageParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TLakeStreamParamList = class( T_ANE_IndexedParameterList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

  TLakeTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

  TLakeLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
  end;


implementation

uses
  Variables;

class Function TLakeNameParam.ANE_ParamName : string ;
begin
  Result := kMFLakeName;
end;

constructor TLakeNameParam.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index,  AParameterList);
  ValueType := pvString;
end;


function TLakeNameParam.Units : string;
begin
  result := '';
end;

function TLakeNameParam.Value : string;
begin
  Result := '\"Lake_Name\"';
end;

//------------------------------------------------------

class Function TLakeNumberParam.ANE_ParamName : string ;
begin
  Result := kMFLakeNumber;
end;

constructor TLakeNumberParam.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index,  AParameterList);
  ValueType := pvInteger;
end;


function TLakeNumberParam.Units : string;
begin
  result := '';
end;

//------------------------------------------------------

class Function TLakeSimulModeParam.ANE_ParamName : string ;
begin
  Result := kMFLakeSimulMode;
end;

constructor TLakeSimulModeParam.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index,  AParameterList);
  ValueType := pvInteger;
end;


function TLakeSimulModeParam.Units : string;
begin
  result := '0, 1, 2, or 3';
end;

//------------------------------------------------------

class Function TLakeStartStageParam.ANE_ParamName : string ;
begin
  Result := kMFLakeStartStage;
end;

function TLakeStartStageParam.Units : string;
begin
  result := 'L';
end;

//------------------------------------------------------

class Function TLakeMaxIterations.ANE_ParamName : string ;
begin
  Result := kMFLakeMaxIterations;
end;

constructor TLakeMaxIterations.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index,  AParameterList);
  ValueType := pvInteger;
end;


function TLakeMaxIterations.Units : string;
begin
  result := '';
end;

function TLakeMaxIterations.Value : string;
begin
  Result := '5';
end;

//------------------------------------------------------

class Function TLakeStageConvCrit.ANE_ParamName : string ;
begin
  Result := kMFLakeStageConvCrit;
end;

function TLakeStageConvCrit.Units : string;
begin
  result := 'L';
end;

function TLakeStageConvCrit.Value : string;
begin
  Result := '0.01';
end;

//------------------------------------------------------

class Function TLakeMaxStageParam.ANE_ParamName : string ;
begin
  Result := kMFLakeMaxStage;
end;

function TLakeMaxStageParam.Units : string;
begin
  result := 'L';
end;

//------------------------------------------------------

class Function TLakeHydCond.ANE_ParamName : string ;
begin
  Result := kMFLakeHydCond;
end;

function TLakeHydCond.Units : string;
begin
  result := 'L/t';
end;

function TLakeHydCond.Value : string;
begin
  Result := '100';
end;

//------------------------------------------------------

class Function TLakeInputStreamParam.ANE_ParamName : string ;
begin
  Result := kMFLakeInputStream;
end;

constructor TLakeInputStreamParam.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index,  AParameterList);
  ValueType := pvInteger;
end;


function TLakeInputStreamParam.Units : string;
begin
  result := '';
end;

//------------------------------------------------------

class Function TLakeOutputStreamParam.ANE_ParamName : string ;
begin
  Result := kMFLakeOutputStream;
end;

constructor TLakeOutputStreamParam.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer);
begin
  inherited;// Create(Index,  AParameterList);
  ValueType := pvInteger;
end;


function TLakeOutputStreamParam.Units : string;
begin
  result := '';
end;

//------------------------------------------------------

class Function TLakeCutOff1Param.ANE_ParamName : string ;
begin
  Result := kMFLakeCutOff + '1';
end;

function TLakeCutOff1Param.Units : string;
begin
  result := '';
end;

{function TLakeCutOff1Param.WriteIndex: string;
begin
  result := '';

end;}

function TLakeCutOff1Param.WriteName : string;
begin
  Result := kMFLakeCutOff;
end;

function TLakeCutOff1Param.WriteSpecialEnd : string;
begin
  Result := '1';
end;

//------------------------------------------------------

class Function TLakeCutOff2Param.ANE_ParamName : string ;
begin
  Result := kMFLakeCutOff + '2';
end;

function TLakeCutOff2Param.WriteSpecialEnd : string;
begin
  Result := '2';
end;

function TLakeCutOff2Param.Value : string;
begin
  Result := kNa;
end;
//------------------------------------------------------

class Function TLakeCutOff3Param.ANE_ParamName : string ;
begin
  Result := kMFLakeCutOff + '3';
end;

function TLakeCutOff3Param.WriteSpecialEnd : string;
begin
  Result := '3';
end;

//------------------------------------------------------

class Function TLakeCutOff4Param.ANE_ParamName : string ;
begin
  Result := kMFLakeCutOff + '4';
end;

function TLakeCutOff4Param.WriteSpecialEnd : string;
begin
  Result := '4';
end;

//------------------------------------------------------

class Function TLakeCutOff5Param.ANE_ParamName : string ;
begin
  Result := kMFLakeCutOff + '5';
end;

function TLakeCutOff5Param.WriteSpecialEnd : string;
begin
  Result := '5';
end;

//------------------------------------------------------

class Function TLakeCnst1Param.ANE_ParamName : string ;
begin
  Result := kMFLakeConst + '1';
end;

function TLakeCnst1Param.Units : string;
begin
  result := '';
end;

{function TLakeCnst1Param.WriteIndex: string;
begin
  result := '';
end; }

function TLakeCnst1Param.WriteName : string;
begin
  Result := kMFLakeConst;
end;

function TLakeCnst1Param.WriteSpecialEnd : string;
begin
  Result := '1';
end;

//------------------------------------------------------

class Function TLakeCnst2Param.ANE_ParamName : string ;
begin
  Result := kMFLakeConst + '2';
end;

function TLakeCnst2Param.WriteSpecialEnd : string;
begin
  Result := '2';
end;

function TLakeCnst2Param.Value : string;
begin
  Result := kNa;
end;
//------------------------------------------------------

class Function TLakeCnst3Param.ANE_ParamName : string ;
begin
  Result := kMFLakeConst + '3';
end;

function TLakeCnst3Param.WriteSpecialEnd : string;
begin
  Result := '3';
end;

//------------------------------------------------------

class Function TLakeCnst4Param.ANE_ParamName : string ;
begin
  Result := kMFLakeConst + '4';
end;

function TLakeCnst4Param.WriteSpecialEnd : string;
begin
  Result := '4';
end;

//------------------------------------------------------

class Function TLakeCnst5Param.ANE_ParamName : string ;
begin
  Result := kMFLakeConst + '5';
end;

function TLakeCnst5Param.WriteSpecialEnd : string;
begin
  Result := '5';
end;

//------------------------------------------------------

class Function TLakeEqElev1Param.ANE_ParamName : string ;
begin
  Result := kMFLakeEqElev + '1';
end;

function TLakeEqElev1Param.Units : string;
begin
  result := '';
end;

{function TLakeEqElev1Param.WriteIndex: string;
begin
  result := '';
end; }

function TLakeEqElev1Param.WriteName : string;
begin
  Result := kMFLakeEqElev;
end;

function TLakeEqElev1Param.WriteSpecialEnd : string;
begin
  Result := '1';
end;

//------------------------------------------------------

class Function TLakeEqElev2Param.ANE_ParamName : string ;
begin
  Result := kMFLakeEqElev + '2';
end;

function TLakeEqElev2Param.WriteSpecialEnd : string;
begin
  Result := '2';
end;

function TLakeEqElev2Param.Value : string;
begin
  Result := kNa;
end;
//------------------------------------------------------

class Function TLakeEqElev3Param.ANE_ParamName : string ;
begin
  Result := kMFLakeEqElev + '3';
end;

function TLakeEqElev3Param.WriteSpecialEnd : string;
begin
  Result := '3';
end;

//------------------------------------------------------

class Function TLakeEqElev4Param.ANE_ParamName : string ;
begin
  Result := kMFLakeEqElev + '4';
end;

function TLakeEqElev4Param.WriteSpecialEnd : string;
begin
  Result := '4';
end;

//------------------------------------------------------

class Function TLakeEqElev5Param.ANE_ParamName : string ;
begin
  Result := kMFLakeEqElev + '5';
end;

function TLakeEqElev5Param.WriteSpecialEnd : string;
begin
  Result := '5';
end;

//------------------------------------------------------

class Function TLakeEqExp1Param.ANE_ParamName : string ;
begin
  Result := kMFLakeEqExp + '1';
end;

function TLakeEqExp1Param.Units : string;
begin
  result := '';
end;

function TLakeEqExp1Param.Value : string;
begin
  result := '1.5';
end;

{function TLakeEqExp1Param.WriteIndex: string;
begin
  result := '';
end;  }

function TLakeEqExp1Param.WriteName : string;
begin
  Result := kMFLakeEqExp;
end;

function TLakeEqExp1Param.WriteSpecialEnd : string;
begin
  Result := '1';
end;

//------------------------------------------------------

class Function TLakeEqExp2Param.ANE_ParamName : string ;
begin
  Result := kMFLakeEqExp + '2';
end;

function TLakeEqExp2Param.WriteSpecialEnd : string;
begin
  Result := '2';
end;

function TLakeEqExp2Param.Value : string;
begin
  Result := kNa;
end;
//------------------------------------------------------

class Function TLakeEqExp3Param.ANE_ParamName : string ;
begin
  Result := kMFLakeEqExp + '3';
end;

function TLakeEqExp3Param.WriteSpecialEnd : string;
begin
  Result := '3';
end;

//------------------------------------------------------

class Function TLakeEqExp4Param.ANE_ParamName : string ;
begin
  Result := kMFLakeEqExp + '4';
end;

function TLakeEqExp4Param.WriteSpecialEnd : string;
begin
  Result := '4';
end;

//------------------------------------------------------

class Function TLakeEqExp5Param.ANE_ParamName : string ;
begin
  Result := kMFLakeEqExp + '5';
end;

function TLakeEqExp5Param.WriteSpecialEnd : string;
begin
  Result := '5';
end; 

//------------------------------------------------------

class Function TLakeTopElevParam.ANE_ParamName : string ;
begin
  Result := kMFLakeTopElev ;
end;

function TLakeTopElevParam.Units : string;
begin
  Result := 'L';
end;

//------------------------------------------------------

class Function TLakeBottomElevParam.ANE_ParamName : string ;
begin
  Result := kMFLakeBottomElev ;
end;

function TLakeBottomElevParam.Units : string;
begin
  Result := 'L';
end;

//------------------------------------------------------

class Function TLakePrecipParam.ANE_ParamName : string ;
begin
  Result := kMFLakePrecipitation ;
end;

function TLakePrecipParam.Units : string;
begin
  Result := 'L/t';
end;

//------------------------------------------------------

class Function TLakeEvapParam.ANE_ParamName : string ;
begin
  Result := kMFLakeEvapotranspiration ;
end;

function TLakeEvapParam.Units : string;
begin
  Result := 'L/t';
end;

//------------------------------------------------------

class Function TLakeRunoffParam.ANE_ParamName : string ;
begin
  Result := kMFLakeRunoff ;
end;

function TLakeRunoffParam.Units : string;
begin
  Result := 'L^3/t';
end;

//------------------------------------------------------

class Function TLakeRechargeParam.ANE_ParamName : string ;
begin
  Result := kMFLakeRecharge ;
end;

function TLakeRechargeParam.Units : string;
begin
  Result := 'L';
end;

//------------------------------------------------------

class Function TLakeOutputOptionParam.ANE_ParamName : string ;
begin
  Result := kMFLakeOutputOption ;
end;

function TLakeOutputOptionParam.Units : string;
begin
  Result := '0 to 15';
end;

function TLakeOutputOptionParam.Value : string;
begin
  Result := '15';
end;
//------------------------------------------------------

class Function TLakeStageParam.ANE_ParamName : string ;
begin
  Result := kMFLakeStage ;
end;

function TLakeStageParam.Units : string;
begin
  Result := 'L';
end;

//------------------------------------------------------

constructor TLakeStreamParamList.Create(AnOwner :
      T_ANE_ListOfIndexedParameterLists; Index: Integer);
var
  NumOfEquations : integer;
begin
  inherited;// Create(Index, AnOwner);

  ParameterOrder.Add(TLakeInputStreamParam.ANE_ParamName);
  ParameterOrder.Add(TLakeOutputStreamParam.ANE_ParamName);
  ParameterOrder.Add(TLakeCutOff1Param.ANE_ParamName);
  ParameterOrder.Add(TLakeCnst1Param.ANE_ParamName);
  ParameterOrder.Add(TLakeEqElev1Param.ANE_ParamName);
  ParameterOrder.Add(TLakeEqExp1Param.ANE_ParamName);
  ParameterOrder.Add(TLakeCutOff2Param.ANE_ParamName);
  ParameterOrder.Add(TLakeCnst2Param.ANE_ParamName);
  ParameterOrder.Add(TLakeEqElev2Param.ANE_ParamName);
  ParameterOrder.Add(TLakeEqExp2Param.ANE_ParamName);
  ParameterOrder.Add(TLakeCutOff3Param.ANE_ParamName);
  ParameterOrder.Add(TLakeCnst3Param.ANE_ParamName);
  ParameterOrder.Add(TLakeEqElev3Param.ANE_ParamName);
  ParameterOrder.Add(TLakeEqExp3Param.ANE_ParamName);
  ParameterOrder.Add(TLakeCutOff4Param.ANE_ParamName);
  ParameterOrder.Add(TLakeCnst4Param.ANE_ParamName);
  ParameterOrder.Add(TLakeEqElev4Param.ANE_ParamName);
  ParameterOrder.Add(TLakeEqExp4Param.ANE_ParamName);
  ParameterOrder.Add(TLakeCutOff5Param.ANE_ParamName);
  ParameterOrder.Add(TLakeCnst5Param.ANE_ParamName);
  ParameterOrder.Add(TLakeEqElev5Param.ANE_ParamName);
  ParameterOrder.Add(TLakeEqExp5Param.ANE_ParamName);

  NumOfEquations := StrToInt(frmMODFLOW.adeMaxLakEquations.Text);

  TLakeInputStreamParam.Create(self, -1);
  TLakeOutputStreamParam.Create(self, -1);
  if (NumOfEquations>0) and frmMODFLOW.cbSTR.Checked then
  begin
    TLakeCutOff1Param.Create(self, -1);
    TLakeCnst1Param.Create(self, -1);
    TLakeEqElev1Param.Create(self, -1);
    TLakeEqExp1Param.Create(self, -1);
  end;

  if (NumOfEquations>1) and frmMODFLOW.cbSTR.Checked then
  begin
    TLakeCutOff2Param.Create(self, -1);
    TLakeCnst2Param.Create(self, -1);
    TLakeEqElev2Param.Create(self, -1);
    TLakeEqExp2Param.Create(self, -1);
  end;

  if (NumOfEquations>2) and frmMODFLOW.cbSTR.Checked then
  begin
    TLakeCutOff3Param.Create(self, -1);
    TLakeCnst3Param.Create(self, -1);
    TLakeEqElev3Param.Create(self, -1);
    TLakeEqExp3Param.Create(self, -1);
  end;

  if (NumOfEquations>3) and frmMODFLOW.cbSTR.Checked then
  begin
    TLakeCutOff4Param.Create(self, -1);
    TLakeCnst4Param.Create(self, -1);
    TLakeEqElev4Param.Create(self, -1);
    TLakeEqExp4Param.Create(self, -1);
  end;

  if (NumOfEquations>4) and frmMODFLOW.cbSTR.Checked then
  begin
    TLakeCutOff5Param.Create(self, -1);
    TLakeCnst5Param.Create(self, -1);
    TLakeEqElev5Param.Create(self, -1);
    TLakeEqExp5Param.Create(self, -1);
  end;

end;

//---------------------------

constructor TLakeTimeParamList.Create(AnOwner :
      T_ANE_ListOfIndexedParameterLists; Index: Integer);
begin
  inherited;// Create(Index, AnOwner);

  TLakePrecipParam.Create(self, -1);
  TLakeEvapParam.Create(self, -1);
  TLakeRunoffParam.Create(self, -1);
  TLakeRechargeParam.Create(self, -1);
  TLakeOutputOptionParam.Create(self, -1);
  TLakeStageParam.Create(self, -1);

end;

//---------------------------

constructor TLakeLayer.Create(ALayerList : T_ANE_LayerList; Index: Integer) ;
var
  TimeIndex : Integer;
  StreamIndex : integer;
begin
  inherited;// Create(Index, ALayerList);

  Interp := leExact;
  
  TLakeNameParam.Create(ParamList, -1);
  TLakeNumberParam.Create(ParamList, -1);
  TLakeSimulModeParam.Create(ParamList, -1);
  TLakeStartStageParam.Create(ParamList, -1);
  TLakeMaxIterations.Create(ParamList, -1);
  TLakeStageConvCrit.Create(ParamList, -1);
  TLakeMaxStageParam.Create(ParamList, -1);
  TLakeHydCond.Create(ParamList, -1);
  TLakeTopElevParam.Create(ParamList, -1);
  TLakeBottomElevParam.Create(ParamList, -1);

  For StreamIndex := 1 to StrToInt(frmMODFLOW.adeMaxLakeStreams.Text) do
  begin
    ModflowTypes.GetMFLakeStreamParamListType.Create(IndexedParamList1, -1);
  end;

  For TimeIndex := 1 to StrToInt(frmMODFLOW.edNumPer.Text) do
  begin
    ModflowTypes.GetMFLakeTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TLakeLayer.ANE_LayerName : string ;
begin
  result := kMFLakeLayer;
end;

end.
