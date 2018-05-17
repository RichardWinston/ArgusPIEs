unit MT3DTimeVaryConc;

interface

uses ANE_LayerUnit, SysUtils;

const
  kMT3DTopElev = 'Top Elevation';
  kMT3DBottomElev = 'Bottom Elevation';
//  kMT3DPointTimeVaryConc = 'MT3D Point Time Varying Constant Concentration Unit';
  kMT3DTimeVaryConc = 'MT3D Time Varying Constant Concentration Unit';

type
  TMT3DTopElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

  TMT3DBottomElevParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
  end;

{  TMT3DPointTimeVaryConcTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;  }

  TMT3DTimeVaryConcTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create
  (AnOwner : T_ANE_ListOfIndexedParameterLists; Index: Integer); override;
  end;

{  TMT3DPointTimeVaryConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;  }

  TMT3DAreaTimeVaryConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses MT3DGeneralParameters, Variables;

class Function TMT3DTopElevParam.ANE_ParamName : string ;
begin
  result := kMT3DTopElev;
end;

function TMT3DTopElevParam.Units : string;
begin
  result := LengthUnit;
end;

function TMT3DTopElevParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TMT3DBottomElevParam.ANE_ParamName : string ;
begin
  result := kMT3DBottomElev;
end;

function TMT3DBottomElevParam.Units : string;
begin
  result := LengthUnit;
end;

function TMT3DBottomElevParam.Value : string;
begin
  result := kNA;
end;

{//---------------------------
constructor TMT3DPointTimeVaryConcTimeParamList.Create(AnOwner :
      T_ANE_ListOfIndexedParameterLists; Index: Integer);
var
  NCOMP : integer;      
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(ModflowTypes.GetMT3DMassParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DMass2ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DMass3ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DMass4ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DMass5ParamClassType.ANE_ParamName);

  ModflowTypes.GetMT3DMassParamClassType.Create(self, -1);
  NCOMP := StrToInt(frmModflow.adeMT3DNCOMP.Text);
  if NCOMP >= 2 then
  begin
    ModflowTypes.GetMT3DMass2ParamClassType.Create(self, -1 );
  end;
  if NCOMP >= 3 then
  begin
    ModflowTypes.GetMT3DMass3ParamClassType.Create(self, -1 );
  end;
  if NCOMP >= 4 then
  begin
    ModflowTypes.GetMT3DMass4ParamClassType.Create(self, -1 );
  end;
  if NCOMP >= 5 then
  begin
    ModflowTypes.GetMT3DMass5ParamClassType.Create(self, -1 );
  end;
end; }

//---------------------------
constructor TMT3DTimeVaryConcTimeParamList.Create(AnOwner :
      T_ANE_ListOfIndexedParameterLists; Index: Integer);
var
  NCOMP : integer;      
begin
  inherited;// Create(Index, AnOwner);
  ParameterOrder.Add(ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName);

  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetMT3DConcentrationParamClassType.Create(self, -1);
    NCOMP := StrToInt(frmMODFLOW.adeMT3DNCOMP.Text);
    if NCOMP >= 2 then
    begin
      ModflowTypes.GetMT3DConc2ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 3 then
    begin
      ModflowTypes.GetMT3DConc3ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 4 then
    begin
      ModflowTypes.GetMT3DConc4ParamClassType.Create(self, -1);
    end;
    if NCOMP >= 5 then
    begin
      ModflowTypes.GetMT3DConc5ParamClassType.Create(self, -1);
    end;
  end;
end;

//---------------------------
{
constructor TMT3DPointTimeVaryConcLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
var
  TimeIndex : Integer;
begin
  inherited;// Create(Index, ALayerList);
  Lock := Lock + [llType, llEvalAlg];
  Interp := leInterpolate;

  ModflowTypes.GetMT3DTopElevParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMT3DBottomElevParamClassType.Create(ParamList, -1);

  For TimeIndex := 1 to StrToInt(frmMODFLOW.edNumPer.Text) do
  begin
    ModflowTypes.GetMT3DTimeVaryConcTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TMT3DPointTimeVaryConcLayer.ANE_LayerName : string ;
begin
  result := kMT3DPointTimeVaryConc;
end;

function TMT3DPointTimeVaryConcLayer.Units : string;
begin
  result := 'M/L^3';
end;
}
//---------------------------
constructor TMT3DAreaTimeVaryConcLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
var
  TimeIndex : Integer;
begin
  inherited;// Create(Index, ALayerList);
  Lock := Lock + [llType, llEvalAlg];
  Interp := leExact;

  ModflowTypes.GetMT3DTopElevParamClassType.Create(ParamList, -1);
  ModflowTypes.GetMT3DBottomElevParamClassType.Create(ParamList, -1);

  For TimeIndex := 1 to StrToInt(frmMODFLOW.edNumPer.Text) do
  begin
    ModflowTypes.GetMT3DTimeVaryConcTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

class Function TMT3DAreaTimeVaryConcLayer.ANE_LayerName : string ;
begin
  result := kMT3DTimeVaryConc;
end;

function TMT3DAreaTimeVaryConcLayer.Units : string;
begin
  result := MT3DMassUnit + '/' + LengthUnit + '^3';
end;

end.
