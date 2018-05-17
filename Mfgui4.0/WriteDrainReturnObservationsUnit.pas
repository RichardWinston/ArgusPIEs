unit WriteDrainReturnObservationsUnit;

interface

uses Sysutils, StdCtrls, Grids, WriteFluxObservationsUnit;

type
  TDrainReturnObservationWriter = class(TCustomObservationWriter)
  protected
    function GetLayerRoot : string; override;
    function GetEVF : double; override;
    function GetIOWTQ : integer; override;
    function GetIPRN : integer; override;
    function GetNumberOfLayers: Integer; override;
    function GetNumberOfTimes: Integer; override;
    function GetVarianceStringGrid : TStringGrid; override;
    function GetFileExtension: string; override;
    function GetPackageName: string; override;
    function UseLayer(Const LayerIndex: integer): boolean; override;
    function GetOutKey: string; override;
  end;

implementation

Uses Variables, WriteNameFileUnit, UtilityFunctions;

{ TDrainReturnObservationWriter }

function TDrainReturnObservationWriter.GetEVF: double;
begin
  Result := InternationalStrToFloat(frmModflow.adeDrtObsErrMult.Text);
end;

function TDrainReturnObservationWriter.GetFileExtension: string;
begin
  result := rsOdt
end;

function TDrainReturnObservationWriter.GetIOWTQ: integer;
begin
  if frmModflow.cbSpecifyDRTCovariances.Checked then
  begin
    result := 1;
  end
  else
  begin
    result := 0;
  end;
end;

function TDrainReturnObservationWriter.GetIPRN: integer;
begin
  result := frmModflow.comboDrainReturnObsPrintFormats.ItemIndex + 1;
end;

function TDrainReturnObservationWriter.GetLayerRoot: string;
begin
  result := ModflowTypes.GetMFDrainReturnFluxObservationsLayerType.WriteNewRoot;
end;

function TDrainReturnObservationWriter.GetNumberOfLayers: Integer;
begin
  result := StrToInt(frmModflow.adeDRTObsLayerCount.Text);
end;

function TDrainReturnObservationWriter.GetNumberOfTimes: Integer;
begin
  result := StrToInt(frmModflow.adeObsDRTTimeCount.Text);
end;

function TDrainReturnObservationWriter.GetOutKey: string;
begin
  result := 'DTOB_OUT'
end;

function TDrainReturnObservationWriter.GetPackageName: string;
begin
  result := 'Drain Return Observations'

end;

function TDrainReturnObservationWriter.GetVarianceStringGrid: TStringGrid;
begin
  result := frmMODFLOW.dgDRTObsBoundCovariances;
end;

function TDrainReturnObservationWriter.UseLayer(
  const LayerIndex: integer): boolean;
begin
  result := frmModflow.clbDrainReturnObservations.State[LayerIndex -1] = cbChecked;
end;

end.
