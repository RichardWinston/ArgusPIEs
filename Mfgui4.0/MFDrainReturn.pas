unit MFDrainReturn;

interface

uses SysUtils, ANE_LayerUnit, MFGenParam, MFDrain;

type
  TDrainReturnIndexParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); override;
    function Units : string; override;
  end;

  TDrainReturnFractionParam = class(TCustomUnitParameter)
    class Function ANE_ParamName : string ; override;
    function Units : string; override;
  end;

  TDrainReturnConductanceParam = class(TConductance)
    function FactorUsed: boolean; override;
  end;

  TDrainReturnTimeParamList = class( TDrainTimeParamList)
    constructor Create( AnOwner :T_ANE_ListOfIndexedParameterLists;
                Position: Integer);  override;
    function IsSteadyStress : boolean; override;
  end;

  TLineDrainReturnLayer = Class(TCustomDrainLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TAreaDrainReturnLayer = Class(TLineDrainReturnLayer)
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
    class Function ANE_LayerName : string ; override;
  end;

  TPointDrainReturnLayer = Class(TLineDrainReturnLayer)
    class Function ANE_LayerName : string ; override;
  end;

  TDrainReturnLayer = Class(T_ANE_InfoLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create( ALayerList : T_ANE_LayerList; Index: Integer); override;
  end;

implementation

uses Variables;

resourceString
  rsDrainReturnIndex = 'Return_Drain Index';
  rsDrainReturnFraction = 'Return_Drain Fraction';
  rsPointDrainReturn = 'Point Return_Drain Unit';
  rsLineDrainReturn = 'Line Return_Drain Unit';
  rsAreaDrainReturn = 'Area Return_Drain Unit';
  rsDrainReturnLocation = 'Drain Return Location';

{ TDrainReturnIndexParam }

class function TDrainReturnIndexParam.ANE_ParamName: string;
begin
  result := rsDrainReturnIndex;
end;

constructor TDrainReturnIndexParam.Create(
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited;
  ValueType := pvInteger;
end;

function TDrainReturnIndexParam.Units: string;
begin
  result := 'Positive integer';
end;

{ TDrainReturnFractionParam }

class function TDrainReturnFractionParam.ANE_ParamName: string;
begin
  result := rsDrainReturnFraction;
end;

function TDrainReturnFractionParam.Units: string;
begin
  result := '0 to 1';
end;

{ TDrainReturnTimeParamList }

constructor TDrainReturnTimeParamList.Create(
  AnOwner: T_ANE_ListOfIndexedParameterLists; Position: Integer);
var
  IFacePosition : integer;
begin
  inherited;
  IFacePosition := ParameterOrder.IndexOf(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);

  ParameterOrder.Insert(IFacePosition, ModflowTypes.GetDrainReturnIndexParamType.ANE_ParamName);
  ParameterOrder.Insert(IFacePosition, ModflowTypes.GetDrainReturnFractionParamType.ANE_ParamName);

  ModflowTypes.GetDrainReturnIndexParamType.Create( self, -1);
  ModflowTypes.GetDrainReturnFractionParamType.Create( self, -1);

end;

function TDrainReturnTimeParamList.IsSteadyStress: boolean;
begin
  result := frmModflow.comboDrtSteady.ItemIndex = 0;
end;

{ TLineDrainReturnLayer }

class function TLineDrainReturnLayer.ANE_LayerName: string;
begin
  result := rsLineDrainReturn;
end;

constructor TLineDrainReturnLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
var
  TimeIndex : Integer;
  NumberOfTimes : integer;
  OldConductance: T_ANE_Param;
begin
  inherited Create( ALayerList, Index);

  // replace conductance parameter.
  OldConductance := ParamList.GetParameterByName(
    ModflowTypes.GetMFDrainConductanceParamType.ANE_ParamName);
  OldConductance.Free;
  ModflowTypes.GetMFDrainReturnConductanceParamType.Create( ParamList, 0);

  NumberOfTimes := StrToInt(frmMODFLOW.edNumPer.Text);
  For TimeIndex := 1 to NumberOfTimes do
  begin
    ModflowTypes.GetMFDrainReturnTimeParamListType.Create( IndexedParamList2, -1);
  end;
end;

{ TAreaDrainReturnLayer }

class function TAreaDrainReturnLayer.ANE_LayerName: string;
begin
  result := rsAreaDrainReturn;
end;

constructor TAreaDrainReturnLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited Create( ALayerList, Index);
  Interp := leExact;
end;

{ TPointDrainReturnLayer }

class function TPointDrainReturnLayer.ANE_LayerName: string;
begin
  result := rsPointDrainReturn;
end;

{ TDrainReturnLayer }

class function TDrainReturnLayer.ANE_LayerName: string;
begin
  result := rsDrainReturnLocation;
end;

constructor TDrainReturnLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  ModflowTypes.GetDrainReturnIndexParamType.Create(ParamList, -1);
  ModflowTypes.GetMFDrainElevationParamType.Create(ParamList, -1);
end;

{ TDrainConductanceParam }

function TDrainReturnConductanceParam.FactorUsed: boolean;
var
  Layer: T_ANE_Layer;
begin
  Layer := GetParentLayer;
  result := (Pos('Point', Layer.ANE_LayerName) = 0)
    and not frmModflow.cbCondDrnRtn.Checked
end;

end.
