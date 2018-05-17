unit MFHorFlowBarrier;

interface

{MFHorFlowBarrier defines the "Horizontal Flow Barrier Unit[i]" layer
 and associated parameters.}

uses ANE_LayerUnit, SysUtils;

type
  THFBHydCondParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value: string; override;
  end;

  THFBBarrierThickParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value: string; override;
  end;

  TAdjustForAngle = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Value : string; override;
    function Units : string; override;
  end;

  THFBLongDispParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value: string; override;
    function RowNumber : integer;
  end;

  THFBHorzTransDispParam = class(THFBLongDispParam)
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  THFBVertTransDispParam = class(THFBLongDispParam)
    class Function ANE_ParamName : string ; override;
    function Value: string; override;
  end;

  THFBDiffusionCoefParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
    function Value: string; override;
  end;

  THFBLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

implementation

uses Variables, ModflowUnit;

ResourceString
  kMFHFBHydCond = 'Barrier Hydraulic Conductivity';
  kMFHFBBarrierThick = 'Barrier Thickness';
  kMFHFBLayer = 'Horizontal Flow Barrier Unit';
  kAdjustForAngle = 'Adjust For Angle';
  kLongDisp = 'Longitudinal Dispersivity';
  kHorzTransDisp = 'Horizontal Transverse Dispersivity';
  kVertTransDisp = 'Vertical Transverse Dispersivity';
  kDiffusionCoef = 'Diffusion Coefficient';

class Function THFBHydCondParam.ANE_ParamName : string ;
begin
  result := kMFHFBHydCond;
end;

function THFBHydCondParam.Units : string;
begin
  result := LengthUnit  + '/' + TimeUnit;
end;

function THFBHydCondParam.Value: string;
begin
  result := '1E-8';
end;

//---------------------------
class Function THFBBarrierThickParam.ANE_ParamName : string ;
begin
  result := kMFHFBBarrierThick;
end;

function THFBBarrierThickParam.Units : string;
begin
  result := LengthUnit;
end;

function THFBBarrierThickParam.Value: string;
begin
  result := '1';
end;

//---------------------------
constructor THFBLayer.Create( ALayerList : T_ANE_LayerList;
            Index: Integer);
var
  UnitNumber, FirstUnit, LastUnit : integer;
begin
  inherited Create(ALayerList, Index);
  UnitNumber := StrToInt(WriteIndex);
  FirstUnit := StrToInt(frmModflow.adeMOC3DLay1.Text);
  if FirstUnit < 1 then
  begin
    FirstUnit := 1;
  end;
  LastUnit := StrToInt(frmModflow.adeMOC3DLay2.Text);
  if LastUnit < 1 then
  begin
    LastUnit := StrToInt(frmMODFLOW.edNumUnits.Text)
  end;

  Lock := Lock + [llEvalAlg];

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHFBHydCondParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHFBBarrierThickParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetAdjustForAngleParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFModflowParameterNameParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFIsParameterParamType.ANE_ParamName);

  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHFBLongDispParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHFBHorzTransDispParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHFBVertTransDispParamType.ANE_ParamName);
  ParamList.ParameterOrder.Add(ModflowTypes.GetMFHFBDiffusionCoefParamType.ANE_ParamName);

  ModflowTypes.GetMFHFBHydCondParamType.Create( ParamList, -1);
  ModflowTypes.GetMFHFBBarrierThickParamType.Create( ParamList, -1);
  ModflowTypes.GetAdjustForAngleParamType.Create( ParamList, -1);
  ModflowTypes.GetMFModflowParameterNameParamType.Create( ParamList, -1);
  ModflowTypes.GetMFIsParameterParamType.Create( ParamList, -1);

  if frmModflow.cbMOC3D.Checked and (FirstUnit <= UnitNumber)
    and (UnitNumber <= LastUnit) then
  begin
    ModflowTypes.GetMFHFBLongDispParamType.Create( ParamList, -1);
    ModflowTypes.GetMFHFBHorzTransDispParamType.Create( ParamList, -1);
    ModflowTypes.GetMFHFBVertTransDispParamType.Create( ParamList, -1);
    ModflowTypes.GetMFHFBDiffusionCoefParamType.Create( ParamList, -1);
  end;

end;

class Function THFBLayer.ANE_LayerName : string ;
begin
  result := kMFHFBLayer;
end;

{ TAdjustForAngle }

class function TAdjustForAngle.ANE_ParamName: string;
begin
  result := kAdjustForAngle;
end;

constructor TAdjustForAngle.Create(AParameterList: T_ANE_ParameterList;
  Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TAdjustForAngle.Units: string;
begin
  result := '0 or 1';
end;

function TAdjustForAngle.Value: string;
begin
  result := '1';
end;

{ THFBLongDispParam }

class function THFBLongDispParam.ANE_ParamName: string;
begin
  result := kLongDisp;
end;

function THFBLongDispParam.RowNumber: integer;
var
  UnitNumber, FirstUnit : integer;
begin
  UnitNumber := StrToInt(GetParentLayer.WriteIndex);
  FirstUnit := StrToInt(frmModflow.adeMOC3DLay1.Text);
  if FirstUnit < 1 then
  begin
    FirstUnit := 1;
  end;
  result := UnitNumber - FirstUnit + 1;
end;

function THFBLongDispParam.Units: string;
begin
  result := LengthUnit;
end;

function THFBLongDispParam.Value: string;
begin
  result := frmModflow.sgMOC3DTransParam.Cells[1,RowNumber];
end;

{ THFBHorzTransDispParam }

class function THFBHorzTransDispParam.ANE_ParamName: string;
begin
  result := kHorzTransDisp;
end;

function THFBHorzTransDispParam.Value: string;
begin
  result := frmModflow.sgMOC3DTransParam.Cells[2,RowNumber];
//  result := THFBLongDispParam.ANE_ParamName + '/10';
end;

{ THFBVertTransDispParam }

class function THFBVertTransDispParam.ANE_ParamName: string;
begin
  result := kVertTransDisp;
end;

function THFBVertTransDispParam.Value: string;
begin
  result := frmModflow.sgMOC3DTransParam.Cells[3,RowNumber];

end;

{ THFBDiffusionCoefParam }

class function THFBDiffusionCoefParam.ANE_ParamName: string;
begin
  result := kDiffusionCoef;
end;

function THFBDiffusionCoefParam.Units: string;
begin
  result := LengthUnit  + '^2/' + TimeUnit;
end;

function THFBDiffusionCoefParam.Value: string;
begin
  result := frmModflow.adeMOC3DDiffus.Text;
end;

end.
