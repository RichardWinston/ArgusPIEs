unit MFMOCConstConc;

interface

uses SysUtils, MFGenParam, ANE_LayerUnit;

const
  kGWT_TopElev = 'Top Elevation';
  kGWT_BottomElev = 'Bottom Elevation';
  kGWT_TimeVaryConc = 'Constant Concentration Unit';

type
  TGWT_TopElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TGWT_BottomElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TGwtConcBoundary = class(TConcentration)
    function Value : string; override;
  end;

  TConcentrationUsed = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
  end;

  TGWT_TimeVaryConcTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

  TGWT_TimeVaryConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables, OptionsUnit;

const
  StrConcentrationUsed = 'Concentration Used';

class Function TGWT_TopElevParam.ANE_ParamName : string ;
begin
  result := kGWT_TopElev;
end;

function TGWT_TopElevParam.Units : string;
begin
  result := LengthUnit;
end;

function TGWT_TopElevParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TGWT_BottomElevParam.ANE_ParamName : string ;
begin
  result := kGWT_BottomElev;
end;

function TGWT_BottomElevParam.Units : string;
begin
  result := LengthUnit;
end;

function TGWT_BottomElevParam.Value : string;
begin
  result := kNA;
end;


constructor TGWT_TimeVaryConcTimeParamList.Create(AnOwner :
      T_ANE_ListOfIndexedParameterLists; Index: Integer);
//var
//  NCOMP : integer;
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(ModflowTypes.GetGwt_ConcBoundaryClass.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetGWT_ConcentrationUsedParamType.ANE_ParamName);
//  ParameterOrder.Add(ModflowTypes.GetGWT_Conc3ParamClassType.ANE_ParamName);
//  ParameterOrder.Add(ModflowTypes.GetGWT_Conc4ParamClassType.ANE_ParamName);
//  ParameterOrder.Add(ModflowTypes.GetGWT_Conc5ParamClassType.ANE_ParamName);

//  if frmMODFLOW.cbGWT_.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetGwt_ConcBoundaryClass.Create(self, -1);
    ModflowTypes.GetGWT_ConcentrationUsedParamType.Create(self, -1);
//    NCOMP := StrToInt(frmMODFLOW.adeGWT_NCOMP.Text);
//    if NCOMP >= 2 then
//    begin
//      ModflowTypes.GetGWT_Conc2ParamClassType.Create(self, -1);
//    end;
//    if NCOMP >= 3 then
//    begin
//      ModflowTypes.GetGWT_Conc3ParamClassType.Create(self, -1);
//    end;
//    if NCOMP >= 4 then
//    begin
//      ModflowTypes.GetGWT_Conc4ParamClassType.Create(self, -1);
//    end;
//    if NCOMP >= 5 then
//    begin
//      ModflowTypes.GetGWT_Conc5ParamClassType.Create(self, -1);
//    end;
  end;
end;

constructor TGWT_TimeVaryConcLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
var
  TimeIndex : Integer;
begin
  inherited;// Create(Index, ALayerList);
  Lock := Lock + [llType, llEvalAlg];
  Interp := leExact;

  ModflowTypes.GetGWT_TopElevParam.Create(ParamList, -1);
  ModflowTypes.GetGWT_BottomElevParam.Create(ParamList, -1);

  For TimeIndex := 1 to StrToInt(frmMODFLOW.edNumPer.Text) do
  begin
    ModflowTypes.GetGWT_TimeVaryConcTimeParamList.Create(IndexedParamList2, -1);
  end;
end;

class Function TGWT_TimeVaryConcLayer.ANE_LayerName : string ;
begin
  result := kGWT_TimeVaryConc;
end;

function TGWT_TimeVaryConcLayer.Units : string;
begin
  result := 'M/' + LengthUnit + '^3';
end;

{ TGWT_ConcentrationParam }

//class function TGWT_ConcentrationParam.ANE_ParamName: string;
//begin
//  result := 'Concentration'
//end;
//
//function TGWT_ConcentrationParam.Units: string;
//begin
//  result := 'M/' + LengthUnit + '^3';
//end;
//
//function TGWT_ConcentrationParam.Value: string;
//begin
//  result := kNA;
//end;

{ TConcentrationUsed }

class function TConcentrationUsed.ANE_ParamName: string;
begin
  result := StrConcentrationUsed;
end;

constructor TConcentrationUsed.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvBoolean;
  Lock := StandardParameterLock + [plDef_Val, plDont_Override]
end;

function TConcentrationUsed.Value: string;
begin
  result := ModflowTypes.GetGwt_ConcBoundaryClass.WriteParamName
    + WriteIndex
    + '!='
    + kNA;
end;

{ TGwtConcBoundary }

function TGwtConcBoundary.Value: string;
begin
  result := kNA;
end;

end.
