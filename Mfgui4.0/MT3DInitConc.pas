unit MT3DInitConc;

interface

uses SysUtils, ANE_LayerUnit, MT3DGeneralParameters;

const
  kInitParam = 'Initial Concentration';
  kSorbInitParam = 'Sorbed Initial Concentration';
  kMT3DTopElev = 'Top Elevation';
  kMT3DBottomElev = 'Bottom Elevation';
  kMT3DPointInitConc = 'MT3D Point Initial Concentration Unit';
  kMT3DAreaInitConc = 'MT3D Area Initial Concentration Unit';
  kSorbMass = 'Sorbed Mass';

type
  TMT3DInitConcParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMT3DInitConc2Param = class(TMT3DInitConcParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DInitConc3Param = class(TMT3DInitConcParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DInitConc4Param = class(TMT3DInitConcParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DInitConc5Param = class(TMT3DInitConcParam)
    class Function ANE_ParamName : string ; override;
  end;

{  TMT3DSorbInitConcParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DSorbInitConc2Param = class(TMT3DSorbInitConcParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DSorbInitConc3Param = class(TMT3DSorbInitConcParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DSorbInitConc4Param = class(TMT3DSorbInitConcParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DSorbInitConc5Param = class(TMT3DSorbInitConcParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DSorbMassParam = class(TMT3DMassParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DSorbMass2Param = class(TMT3DSorbMassParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DSorbMass3Param = class(TMT3DSorbMassParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DSorbMass4Param = class(TMT3DSorbMassParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DSorbMass5Param = class(TMT3DSorbMassParam)
    class Function ANE_ParamName : string ; override;
  end;   }

{  TMT3DPointTimeVaryConcTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create(Index: Integer; AnOwner :
      T_ANE_ListOfIndexedParameterLists); override;
  end;

  TMT3DAreaTimeVaryConcTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create(Index: Integer; AnOwner :
      T_ANE_ListOfIndexedParameterLists); override;
  end;
}
  TMT3DPointInitConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

  TMT3DAreaInitConcLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

uses Variables;

{class Function TMT3DTopElevParam.ANE_Name : string ;
begin
  result := kMT3DTopElev;
end;

function TMT3DTopElevParam.Units : string;
begin
  result := 'L';
end;

function TMT3DTopElevParam.Value : string;
begin
  result := kNA;
end;

//---------------------------
class Function TMT3DBottomElevParam.ANE_Name : string ;
begin
  result := kMT3DBottomElev;
end;

function TMT3DBottomElevParam.Units : string;
begin
  result := 'L';
end;

function TMT3DBottomElevParam.Value : string;
begin
  result := kNA;
end;
//---------------------------   }

class Function TMT3DInitConcParam.ANE_ParamName : string ;
begin
  result := kInitParam;
end;

function TMT3DInitConcParam.Units : string;
begin
  result := MT3DMassUnit + '/' + LengthUnit + '^3';
end;


//---------------------------
{constructor TMT3DPointTimeVaryConcTimeParamList.Create(Index: Integer; AnOwner :
      T_ANE_ListOfIndexedParameterLists);
begin
  inherited Create(Index, AnOwner);
  ModflowTypes.GetMT3DMassParamClassType.Create(-1, self);
end;

//---------------------------
constructor TMT3DAreaTimeVaryConcTimeParamList.Create(Index: Integer; AnOwner :
      T_ANE_ListOfIndexedParameterLists);
begin
  inherited Create(Index, AnOwner);
  ModflowTypes.GetMT3DConcentrationParamClassType.Create(-1, self);
end;

//---------------------------   }
constructor TMT3DPointInitConcLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer) ;
var
  NCOMP : integer;  
begin
  inherited;// Create(Index, ALayerList);
  Lock := Lock + [llType, llEvalAlg];
  Interp := leInterpolate;

  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DInitConcParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DInitConc2ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DInitConc3ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DInitConc4ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DInitConc5ParamClassType.ANE_ParamName);
{  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMassParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMass2ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMass3ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMass4ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DMass5ParamClassType.ANE_ParamName);
{  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSorbMassParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSorbMass2ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSorbMass3ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSorbMass4ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSorbMass5ParamClassType.ANE_ParamName); }


  NCOMP := StrToInt(frmModflow.adeMT3DNCOMP.Text);
  ModflowTypes.GetMT3DInitConcParamClassType.Create(ParamList, -1);
  if NCOMP >= 2 then
  begin
    ModflowTypes.GetMT3DInitConc2ParamClassType.Create(ParamList, -1 );
  end;
  if NCOMP >= 3 then
  begin
    ModflowTypes.GetMT3DInitConc3ParamClassType.Create(ParamList, -1 );
  end;
  if NCOMP >= 4 then
  begin
    ModflowTypes.GetMT3DInitConc4ParamClassType.Create(ParamList, -1 );
  end;
  if NCOMP >= 5 then
  begin
    ModflowTypes.GetMT3DInitConc5ParamClassType.Create(ParamList, -1 );
  end;

{  ModflowTypes.GetMT3DMassParamClassType.Create(ParamList, -1);
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
{  if frmModflow.cbRCT.Checked then
  begin
    ModflowTypes.GetMT3DSorbMassParamClassType.Create(ParamList, -1);
    if NCOMP >= 2 then
    begin
      ModflowTypes.GetMT3DSorbMass2ParamClassType.Create(ParamList, -1 );
    end;
    if NCOMP >= 3 then
    begin
      ModflowTypes.GetMT3DSorbMass3ParamClassType.Create(ParamList, -1 );
    end;
    if NCOMP >= 4 then
    begin
      ModflowTypes.GetMT3DSorbMass4ParamClassType.Create(ParamList, -1 );
    end;
    if NCOMP >= 5 then
    begin
      ModflowTypes.GetMT3DSorbMass5ParamClassType.Create(ParamList, -1 );
    end;
  end;  }

end;

class Function TMT3DPointInitConcLayer.ANE_LayerName : string ;
begin
  result := kMT3DPointInitConc;
end;

function TMT3DPointInitConcLayer.Units : string;
begin
  result := MT3DMassUnit;
end;

//---------------------------
constructor TMT3DAreaInitConcLayer.Create(ALayerList : T_ANE_LayerList; Index: Integer) ;
var
  NCOMP : integer;
begin
  inherited;// Create(Index, ALayerList);
  Interp := leExact;

  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DInitConcParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DInitConc2ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DInitConc3ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DInitConc4ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DInitConc5ParamClassType.ANE_ParamName);
{  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSorbInitConcParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSorbInitConc2ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSorbInitConc3ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSorbInitConc4ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DSorbInitConc5ParamClassType.ANE_ParamName);  }

  NCOMP := StrToInt(frmModflow.adeMT3DNCOMP.Text);
  ModflowTypes.GetMT3DInitConcParamClassType.Create(ParamList, -1);
  if NCOMP >= 2 then
  begin
    ModflowTypes.GetMT3DInitConc2ParamClassType.Create(ParamList, -1 );
  end;
  if NCOMP >= 3 then
  begin
    ModflowTypes.GetMT3DInitConc3ParamClassType.Create(ParamList, -1 );
  end;
  if NCOMP >= 4 then
  begin
    ModflowTypes.GetMT3DInitConc4ParamClassType.Create(ParamList, -1 );
  end;
  if NCOMP >= 5 then
  begin
    ModflowTypes.GetMT3DInitConc5ParamClassType.Create(ParamList, -1 );
  end;
{  if frmModflow.cbRCT.Checked then
  begin
    ModflowTypes.GetMT3DSorbInitConcParamClassType.Create(ParamList, -1);
    if NCOMP >= 2 then
    begin
      ModflowTypes.GetMT3DSorbInitConc2ParamClassType.Create(ParamList, -1 );
    end;
    if NCOMP >= 3 then
    begin
      ModflowTypes.GetMT3DSorbInitConc3ParamClassType.Create(ParamList, -1 );
    end;
    if NCOMP >= 4 then
    begin
      ModflowTypes.GetMT3DSorbInitConc4ParamClassType.Create(ParamList, -1 );
    end;
    if NCOMP >= 5 then
    begin
      ModflowTypes.GetMT3DSorbInitConc5ParamClassType.Create(ParamList, -1 );
    end;
  end;}
end;

class Function TMT3DAreaInitConcLayer.ANE_LayerName : string ;
begin
  result := kMT3DAreaInitConc;
end;

function TMT3DAreaInitConcLayer.Units : string;
begin
  result := MT3DMassUnit + '/' + LengthUnit + '^3';
end;

{ TMT3DInitConc2Param }

class function TMT3DInitConc2Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'B';
end;

{ TMT3DInitConc3Param }

class function TMT3DInitConc3Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'C';
end;

{ TMT3DInitConc4Param }

class function TMT3DInitConc4Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'D';
end;

{ TMT3DInitConc5Param }

class function TMT3DInitConc5Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'E';
end;

{ TMT3DSorbInitConcParam }

{class function TMT3DSorbInitConcParam.ANE_ParamName: string;
begin
  result := kSorbInitParam;
end;

{ TMT3DSorbInitConc2Param }

{class function TMT3DSorbInitConc2Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'B';
end;

{ TMT3DSorbInitConc3Param }

{class function TMT3DSorbInitConc3Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'C';
end;

{ TMT3DSorbInitConc4Param }

{class function TMT3DSorbInitConc4Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'D';
end;

{ TMT3DSorbInitConc5Param }

{class function TMT3DSorbInitConc5Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'E';
end;

{ TMT3DSorbMassParam }

{class function TMT3DSorbMassParam.ANE_ParamName: string;
begin
  result := kSorbMass;
end;

{ TMT3DSorbMass5Param }

{class function TMT3DSorbMass5Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'E';
end;

{ TMT3DSorbMass4Param }

{class function TMT3DSorbMass4Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'D';
end;

{ TMT3DSorbMass3Param }

{class function TMT3DSorbMass3Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'C';
end;

{ TMT3DSorbMass2Param }

{class function TMT3DSorbMass2Param.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'B';
end;  }

end.

