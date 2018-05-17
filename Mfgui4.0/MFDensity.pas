unit MFDensity;

interface

uses SysUtils, ANE_LayerUnit;

type
  TFluidDensityParam = class(T_ANE_LayerParam)
    public
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value : string; override;
    class function WriteParamName : string; override;
    Class Function TimeVarying: boolean;
  end;

  TFluidDensityTimeParamList = class(T_ANE_IndexedParameterList)
    public
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
      Position: Integer);  override;
  end;

  TFluidDensityLayer = class(T_ANE_InfoLayer)
    public
    constructor Create(ALayerList : T_ANE_LayerList;
      Index: Integer = -1); override;
    class Function ANE_LayerName : string ; override;
    Class Function LayerUsed: boolean;
    class Function ConcentrationUsed: boolean;
    class function WriteNewRoot : string; override;
  end;

implementation

uses Variables;

resourcestring
  rsDensity = 'Fluid Density';
  rsDensityUnit = 'Fluid Density Unit';
  rsConcentration = 'Solute Concentration';
  rsConcentrationUnit = 'Solute Concentration Unit';

{ TFluidDensityParam }

class function TFluidDensityParam.ANE_ParamName: string;
begin
  result := rsDensity;
end;

class function TFluidDensityParam.TimeVarying: boolean;
begin
  result := ModflowTypes.GetFluidDensityLayerType.LayerUsed and
    (frmModflow.comboSW_DensitySpecificationMethod.ItemIndex > 1)
end;

function TFluidDensityParam.Units: string;
begin
  if ModflowTypes.GetFluidDensityLayerType.ConcentrationUsed then
  begin
    result := '';
  end
  else
  begin
    result := MT3DMassUnit + '/' + LengthUnit + '^3';
  end;
end;

function TFluidDensityParam.Value: string;
begin
  if ModflowTypes.GetFluidDensityLayerType.ConcentrationUsed then
  begin
    result := '0';
  end
  else
  begin
    result := frmModflow.adeRefFluidDens.Text;
  end;
end;

class function TFluidDensityParam.WriteParamName: string;
begin
  if ModflowTypes.GetFluidDensityLayerType.ConcentrationUsed then
  begin
    result := rsConcentration;
  end
  else
  begin
    result := inherited WriteParamName;
  end;
end;

{ TFluidDensityTimeParamList }

constructor TFluidDensityTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
begin
  inherited;
  if ModflowTypes.GetMFFluidDensityParamType.TimeVarying then
  begin
    ModflowTypes.GetMFFluidDensityParamType.Create(self, -1);
  end;
end;

{ TFluidDensityLayer }

class function TFluidDensityLayer.ANE_LayerName: string;
begin
  result := rsDensityUnit;
end;

class function TFluidDensityLayer.ConcentrationUsed: boolean;
begin
  result := LayerUsed
    and (frmModflow.comboSW_DensitySpecificationMethod.ItemIndex in [1,3])
end;

constructor TFluidDensityLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex, NumberOfTimes: integer;
begin
  inherited;
  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFFluidDensityTimeParamListType.Create(IndexedParamList2,
      -1);
  end;
  if not ModflowTypes.GetMFFluidDensityParamType.TimeVarying then
  begin
    ModflowTypes.GetMFFluidDensityParamType.Create(ParamList, -1);
  end;
end;

class function TFluidDensityLayer.LayerUsed: boolean;
begin
  result := frmModflow.cbSeaWat.Checked
    and not frmModflow.cbSW_Coupled.Checked
    and frmModflow.cbSW_VDF.Checked
    and (frmModflow.comboSW_DensitySpecificationMethod.ItemIndex < 4)
end;

class function TFluidDensityLayer.WriteNewRoot: string;
begin
  if ConcentrationUsed then
  begin
    result := rsConcentrationUnit;
  end
  else
  begin
    result := inherited WriteNewRoot;
  end;
end;

end.
