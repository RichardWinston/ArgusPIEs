unit WriteDrainObservationsUnit;

interface

uses Sysutils, StdCtrls, Grids, WriteFluxObservationsUnit;

type
  TDrainObservationWriter = class(TCustomObservationWriter)
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

{ TDrainObservationWriter }

function TDrainObservationWriter.GetEVF: double;
begin
  Result := InternationalStrToFloat(frmModflow.adeDrnObsErrMult.Text);
end;

function TDrainObservationWriter.GetFileExtension: string;
begin
  result := rsDrob
end;

function TDrainObservationWriter.GetIOWTQ: integer;
begin
  if frmModflow.cbSpecifyDRNCovariances.Checked then
  begin
    result := 1;
  end
  else
  begin
    result := 0;
  end;
end;

function TDrainObservationWriter.GetIPRN: integer;
begin
  result := frmModflow.comboDrainObsPrintFormats.ItemIndex + 1;
end;

function TDrainObservationWriter.GetLayerRoot: string;
begin
  result := ModflowTypes.GetMFDrainFluxObservationsLayerType.WriteNewRoot;
end;

function TDrainObservationWriter.GetNumberOfLayers: Integer;
begin
  result := StrToInt(frmModflow.adeDRNObsLayerCount.Text);
end;

function TDrainObservationWriter.GetNumberOfTimes: Integer;
begin
  result := StrToInt(frmModflow.adeObsDRNTimeCount.Text);
end;

function TDrainObservationWriter.GetOutKey: string;
begin
  result := 'DROB_OUT';
end;

function TDrainObservationWriter.GetPackageName: string;
begin
  result := 'Drain Observations'

end;

function TDrainObservationWriter.GetVarianceStringGrid: TStringGrid;
begin
  result := frmMODFLOW.dgDRNObsBoundCovariances;
end;

function TDrainObservationWriter.UseLayer(
  const LayerIndex: integer): boolean;
begin
  result := frmModflow.clbDrainObservations.State[LayerIndex -1] = cbChecked;
end;

end.
