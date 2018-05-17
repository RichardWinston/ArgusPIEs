unit MT3DMassFlux;

interface

uses ANE_LayerUnit, MFGenParam, SysUtils;

type
  TCustomMassFluxParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TMassFluxAParam = class(TCustomMassFluxParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMassFluxBParam = class(TCustomMassFluxParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMassFluxCParam = class(TCustomMassFluxParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMassFluxDParam = class(TCustomMassFluxParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMassFluxEParam = class(TCustomMassFluxParam)
    class Function ANE_ParamName : string ; override;
  end;

  TMT3DMassFluxTimeParamList = class( T_ANE_IndexedParameterList)
    constructor Create(AnOwner : T_ANE_ListOfIndexedParameterLists;
      Index: Integer); override;
  end;

  TMT3DMassFluxLayer = Class(T_ANE_InfoLayer)
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer) ; override;
    class Function ANE_LayerName : string ; override;
    function Units : string; override;
  end;
  
implementation

uses Variables;

resourcestring
  rsMassFlux = 'Mass Flux Rate';
  rsMassFluxUnit = 'MT3D Point Mass Flux Unit';

{ TMassFluxParam }

class function TCustomMassFluxParam.ANE_ParamName: string;
begin
  result := rsMassFlux;
end;

function TCustomMassFluxParam.Units: string;
begin
  result := MT3DMassUnit + '/' + TimeUnit;
end;

{ TMassFluxAParam }

class function TMassFluxAParam.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'A';
end;

{ TMassFluxBParam }

class function TMassFluxBParam.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'B';
end;

{ TMassFluxCParam }

class function TMassFluxCParam.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'C';
end;

{ TMassFluxDParam }

class function TMassFluxDParam.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'D';
end;

{ TMassFluxEParam }

class function TMassFluxEParam.ANE_ParamName: string;
begin
  result := inherited ANE_ParamName + 'E';
end;

{ TMT3DMassFluxTimeParamList }

constructor TMT3DMassFluxTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Index: Integer);
var
  NCOMP : integer;      
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.GetMT3DMassFluxAParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DMassFluxBParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DMassFluxCParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DMassFluxDParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DMassFluxEParamClassType.ANE_ParamName);

  if frmMODFLOW.cbMT3D.Checked and frmMODFLOW.cbSSM.Checked then
  begin
    ModflowTypes.GetMT3DMassFluxAParamClassType.Create(self, -1);
    NCOMP := StrToInt(frmMODFLOW.adeMT3DNCOMP.Text);
    if NCOMP >= 2 then
    begin
      ModflowTypes.GetMT3DMassFluxBParamClassType.Create(self, -1);
    end;
    if NCOMP >= 3 then
    begin
      ModflowTypes.GetMT3DMassFluxCParamClassType.Create(self, -1);
    end;
    if NCOMP >= 4 then
    begin
      ModflowTypes.GetMT3DMassFluxDParamClassType.Create(self, -1);
    end;
    if NCOMP >= 5 then
    begin
      ModflowTypes.GetMT3DMassFluxEParamClassType.Create(self, -1);
    end;
  end;

end;

{ TMT3DMassFluxLayer }

class function TMT3DMassFluxLayer.ANE_LayerName: string;
begin
  result := rsMassFluxUnit;
end;

constructor TMT3DMassFluxLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : integer;  
begin
  inherited;
  Lock := Lock + [llType];

  ModflowTypes.GetMFElevationParamType.Create(ParamList, -1);

  For TimeIndex := 1 to StrToInt(frmMODFLOW.edNumPer.Text) do
  begin
    ModflowTypes.GetMT3DMassFluxTimeParamListType.Create(IndexedParamList2, -1);
  end;
end;

function TMT3DMassFluxLayer.Units: string;
begin
  result := MT3DMassUnit + '/' + TimeUnit;
end;

end.
