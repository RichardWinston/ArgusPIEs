unit MF_GWT_CBDY;

interface

uses Sysutils, ANE_LayerUnit;

type
  TUpperBoundaryConcentrationParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TLowerBoundaryConcentrationParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TUpperBoundaryConcentrationLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    Class Function Used: boolean;
  end;

  TLowerBoundaryConcentrationLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    Class Function Used: boolean;
  end;

  TLateralBoundaryConcentrationParam = class(T_ANE_LayerParam)
    class Function ANE_ParamName : string ; override;
  end;

  TLateralBoundaryConcentrationLayer = Class(T_ANE_InfoLayer)
    constructor Create( ALayerList : T_ANE_LayerList;
            Index: Integer); override;
    class Function ANE_LayerName : string ; override;
    Class Function Used: boolean;
  end;


implementation

uses Variables;

resourcestring
  rsUpperBoundaryConcentration = 'Upper Boundary Concentration';
  rsLowerBoundaryConcentration = 'Lower Boundary Concentration';
  rsLateralBoundaryConcentration = 'Lateral Boundary Concentration';
  rsLateralBoundaryConcentrationUnit = 'Lateral Boundary Concentration Unit';

{ TUpperBoundaryConcentrationParam }

class function TUpperBoundaryConcentrationParam.ANE_ParamName: string;
begin
  result := rsUpperBoundaryConcentration;
end;

{ TLowerBoundaryConcentrationParam }

class function TLowerBoundaryConcentrationParam.ANE_ParamName: string;
begin
  result := rsLowerBoundaryConcentration;
end;

{ TUpperBoundaryConcentrationLayer }

class function TUpperBoundaryConcentrationLayer.ANE_LayerName: string;
begin
  result := rsUpperBoundaryConcentration;
end;

constructor TUpperBoundaryConcentrationLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  Lock := Lock - [llType];
  ModflowTypes.GetMFUpperBoundaryConcentrationParamType.Create(ParamList, -1);
end;

class function TUpperBoundaryConcentrationLayer.Used: boolean;
begin
  with frmModflow do
  begin
    result := cbMOC3D.Checked and cbCBDY.Checked
      and (StrToInt(adeMOC3DLay1.Text) > 1);
  end;
end;

{ TLowerBoundaryConcentrationLayer }

class function TLowerBoundaryConcentrationLayer.ANE_LayerName: string;
begin
  result := rsLowerBoundaryConcentration;
end;

constructor TLowerBoundaryConcentrationLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  Lock := Lock - [llType];
  ModflowTypes.GetMFLowerBoundaryConcentrationParamType.Create(ParamList, -1);
end;

class function TLowerBoundaryConcentrationLayer.Used: boolean;
var
  LastUnit: integer;
begin
  with frmModflow do
  begin
    LastUnit := StrToInt(adeMOC3DLay2.Text);
    result := cbMOC3D.Checked and cbCBDY.Checked and (LastUnit > 0)
      and (LastUnit < UnitCount);
  end;
end;

{ TLateralBoundaryConcentrationParam }

class function TLateralBoundaryConcentrationParam.ANE_ParamName: string;
begin
  result := rsLateralBoundaryConcentration;
end;

{ TLateralBoundaryConcentrationLayer }

class function TLateralBoundaryConcentrationLayer.ANE_LayerName: string;
begin
  result := rsLateralBoundaryConcentrationUnit;
end;

constructor TLateralBoundaryConcentrationLayer.Create(
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited Create(ALayerList, Index);
  Interp := leExact;
  Lock := Lock - [llType];
  ModflowTypes.GetMFLateralBoundaryConcentrationParamType.Create(ParamList, -1);
end;

class function TLateralBoundaryConcentrationLayer.Used: boolean;
begin
  with frmModflow do
  begin
    result := cbMOC3D.Checked and cbCBDY.Checked;
  end;
end;

end.
