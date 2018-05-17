unit MF_SW_Viscosity;

interface

uses ANE_LayerUnit, SysUtils, MFGenParam;

type
  TViscosityParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Value : String; override;
    Class Function TimeVarying: boolean;
    class function WriteParamName : string; override;
  end;

  TViscosityParamList = class( TSteadyTimeParamList)
    function IsSteadyStress : boolean; override;
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
  end;

  TViscosityLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    Class Function LayerUsed: boolean;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables;

const
  KViscosity = 'Viscosity';
  KViscosityUnit = 'Viscosity Unit';

{ TViscosityParam }

class function TViscosityParam.ANE_ParamName: string;
begin
  result := KViscosity;
end;

class function TViscosityParam.TimeVarying: boolean;
begin
  result := ModflowTypes.GetMFViscosityLayerType.LayerUsed and
    (frmModflow.comboSW_TimeVaryingViscosity.ItemIndex in [1,4])
end;

function TViscosityParam.Value: String;
begin
  if frmModflow.comboSW_TimeVaryingViscosity.ItemIndex in [0,1] then
  begin
    result := '8.904e-4';
  end
  else if frmModflow.comboSW_TimeVaryingViscosity.ItemIndex in [3,4] then
  begin
    result := '0';
  end
  else
  begin
    Assert(False);
  end;
end;

class function TViscosityParam.WriteParamName: string;
begin
  if frmModflow.comboSW_TimeVaryingViscosity.ItemIndex in [0,1] then
  begin
    result := ANE_ParamName;
  end
  else if frmModflow.comboSW_TimeVaryingViscosity.ItemIndex in [3,4] then
  begin
    result := 'Concentration';
  end
  else
  begin
    Assert(False);
  end;

end;

{ TViscosityParamList }

constructor TViscosityParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  ModflowTypes.GetMFViscosityParamType.Create(self, -1);
end;

function TViscosityParamList.IsSteadyStress: boolean;
begin
  result := frmModflow.comboSW_TimeVaryingViscosity.ItemIndex = 0;
end;

{ TViscosityLayer }

class function TViscosityLayer.ANE_LayerName: string;
begin
  result := KViscosityUnit;
end;

constructor TViscosityLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  NumberOfTimes: integer;
  TimeIndex: integer;
begin
  inherited;
  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFViscosityParamListType.Create(IndexedParamList2, -1);
  end;

end;

class function TViscosityLayer.LayerUsed: boolean;
begin
  result := frmModflow.cbSeaWat.Checked
    and frmModflow.cbSW_VDF.Checked
    and frmModflow.cbSeawatViscosity.Checked
    and (frmModflow.comboSW_ViscosityMethod.ItemIndex = 1)
    and (frmModflow.comboSW_TimeVaryingViscosity.ItemIndex in [0,1,3,4]);
end;

end.
