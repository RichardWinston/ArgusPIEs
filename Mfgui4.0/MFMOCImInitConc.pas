unit MFMOCImInitConc;

interface

{MFMOCImInitConc defines the "Immobile Init Concentration Unit[i]" layer
 and associated parameter.}

uses SysUtils, ANE_LayerUnit, MFGenParam;

type
  TMOCImInitConcParam = class(TCustomParentSimulatedParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TCustomMT3DImInitConcParam = class(TMOCImInitConcParam)
    function Units : string; override;
  end;

  TMT3DImInitConc2Param = class(TCustomMT3DImInitConcParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DImInitConc3Param = class(TCustomMT3DImInitConcParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DImInitConc4Param = class(TCustomMT3DImInitConcParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DImInitConc5Param = class(TCustomMT3DImInitConcParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMOCImInitConcLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;

implementation

Uses Variables;

ResourceString
  kMFMOCImInitConc = 'Immobile Init Concentration Unit';
  KMT3DImInitConc = 'Immobile Init Concentration';

class Function TMOCImInitConcParam.ANE_ParamName : string ;
begin
  result := kMFMOCImInitConc;
end;

function TMOCImInitConcParam.Units: string;
begin
  result := 'M/' + LengthUnit + '^3';
end;

//---------------------------
constructor TMOCImInitConcLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  NumSpecies : integer;
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  Lock := Lock - [llType];
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFMOCImInitConcParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DImInitConc2ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DImInitConc3ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DImInitConc4ParamClassType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMT3DImInitConc5ParamClassType.ANE_ParamName);

  ModflowTypes.GetMFMOCImInitConcParamType.Create(ParamList, -1);
  if frmModflow.cbMT3D.Checked and frmModflow.cbRCT.Checked
    and not frmModflow.cbMT3D_OneDArrays.Checked
    and (frmModflow.comboMT3DIsotherm.ItemIndex >= 4) then
  begin
    NumSpecies := StrToInt(frmModflow.adeMT3DNCOMP.Text);
    if NumSpecies >= 2 then
    begin
      ModflowTypes.GetMT3DImInitConc2ParamClassType.Create(ParamList, -1);
    end;
    if NumSpecies >= 3 then
    begin
      ModflowTypes.GetMT3DImInitConc3ParamClassType.Create(ParamList, -1);
    end;
    if NumSpecies >= 4 then
    begin
      ModflowTypes.GetMT3DImInitConc4ParamClassType.Create(ParamList, -1);
    end;
    if NumSpecies >= 5 then
    begin
      ModflowTypes.GetMT3DImInitConc5ParamClassType.Create(ParamList, -1);
    end;
  end;
end;

class Function TMOCImInitConcLayer.ANE_LayerName : string ;
begin
  result := kMFMOCImInitConc;
end;

function TMOCImInitConcLayer.Units : string;
begin
  result := 'M/' + LengthUnit + '^3';
end;

{ TCustomMT3DImInitConcParam }

function TCustomMT3DImInitConcParam.Units: string;
begin
  result := MT3DMassUnit + '/' + LengthUnit + '^3';
end;

{ TMT3DImInitConc2Param }

class function TMT3DImInitConc2Param.ANE_ParamName: string;
begin
  result := KMT3DImInitConc + 'B';
end;

{ TMT3DImInitConc3Param }

class function TMT3DImInitConc3Param.ANE_ParamName: string;
begin
  result := KMT3DImInitConc + 'C';
end;

{ TMT3DImInitConc4Param }

class function TMT3DImInitConc4Param.ANE_ParamName: string;
begin
  result := KMT3DImInitConc + 'D';
end;

{ TMT3DImInitConc5Param }

class function TMT3DImInitConc5Param.ANE_ParamName: string;
begin
  result := KMT3DImInitConc + 'E';
end;

end.
