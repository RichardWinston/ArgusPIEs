unit MFReservoir;

interface

uses Sysutils, ANE_LayerUnit, MFGenParam;

type
  TReservoirLandSurfaceParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TReservoirKzParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TReservoirBedThicknessParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Value : string; override;
    function Units : string; override;
  end;

  TReservoirStartingStageParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TReservoirEndingStageParam = class(TCustomSteadyParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TReservoirTimeParamList = class( TSteadyTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
    function IsSteadyStress : boolean; override;
  end;

  TReservoirLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;


implementation

uses Variables;

resourcestring
  kReservoirNumber = 'Reservoir number';
  kReservoirLandSurface = 'Land surface elevation';
  kReservoirKz = 'Reservoir bed vertical hydraulic conductivity';
  kReservoirBedThickness = 'Reservoir bed thickness';
  kStartingStage = 'Starting Stage';
  kEndingStage = 'Ending Stage';
  kReservoirs = 'Reservoirs';

{ TReservoirNumberParam }

{class function TReservoirNumberParam.ANE_ParamName: string;
begin
  result := kReservoirNumber;
end;

constructor TReservoirNumberParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;  }

{ TReservoirLandSurfaceParam }

class function TReservoirLandSurfaceParam.ANE_ParamName: string;
begin
  result := kReservoirLandSurface;
end;

function TReservoirLandSurfaceParam.Units: string;
begin
  result := LengthUnit;
end;

{ TReservoirKzParam }

class function TReservoirKzParam.ANE_ParamName: string;
begin
  result := kReservoirKz;
end;

function TReservoirKzParam.Units: string;
begin
  result := LengthUnit + '/' +TimeUnit ;
end;

function TReservoirKzParam.Value: string;
begin
  result := '1';
end;

{ TReservoirBedThicknessParam }

class function TReservoirBedThicknessParam.ANE_ParamName: string;
begin
  result := kReservoirBedThickness;
end;

function TReservoirBedThicknessParam.Units: string;
begin
  result := LengthUnit;
end;

function TReservoirBedThicknessParam.Value: string;
begin
  result := '1';
end;

{ TReservoirStartingStageParam }

class function TReservoirStartingStageParam.ANE_ParamName: string;
begin
  result := kStartingStage;
end;

function TReservoirStartingStageParam.Units: string;
begin
  result := LengthUnit;
end;

{ TReservoirEndingStageParam }

class function TReservoirEndingStageParam.ANE_ParamName: string;
begin
  result := kEndingStage;
end;

function TReservoirEndingStageParam.Units: string;
begin
  result := LengthUnit;
end;

{ TReservoirTimeParamList }

constructor TReservoirTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  NCOMP : integer;  
begin
  inherited;
  ParameterOrder.Add(ModflowTypes.GetMFReservoirStartingStageParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMFReservoirEndingStageParamType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName);
  ParameterOrder.Add(ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName);

  ModflowTypes.GetMFReservoirStartingStageParamType.Create( self, -1);
  ModflowTypes.GetMFReservoirEndingStageParamType.Create( self, -1);
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

function TReservoirTimeParamList.IsSteadyStress: boolean;
begin
  result := frmModflow.comboResSteady.itemIndex = 0;
end;

{ TReservoirLayer }

class function TReservoirLayer.ANE_LayerName: string;
begin
  result := kReservoirs;
end;

constructor TReservoirLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  NumberOfTimes, TimeIndex : integer;
begin
  inherited;
  Interp := leExact;

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFReservoirLandSurfaceParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFModflowLayerParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFReservoirBedThicknessParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFReservoirKzParamType.ANE_ParamName);

  ModflowTypes.GetMFReservoirLandSurfaceParamType.Create( ParamList, -1);
  If (frmModflow.comboResOption.ItemIndex = 1)
    and frmModflow.cbRESLayer.Checked then
  begin
    ModflowTypes.GetMFModflowLayerParamType.Create( ParamList, -1);
  end;
  ModflowTypes.GetMFReservoirBedThicknessParamType.Create( ParamList, -1);
  ModflowTypes.GetMFReservoirKzParamType.Create( ParamList, -1);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFReservoirTimeParamListType.Create( IndexedParamList2, -1);
  end;

end;

end.
