unit WriteRiverObservationsUnit;

interface

uses Sysutils, StdCtrls, Grids, WriteFluxObservationsUnit;

type
  TRiverObservationWriter = class(TCustomObservationWriter)
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

{ TRiverObservationWriter }

function TRiverObservationWriter.GetEVF: double;
begin
  Result := InternationalStrToFloat(frmModflow.adeRivObsErrMult.Text);
end;

function TRiverObservationWriter.GetFileExtension: string;
begin
  result := rsRvob
end;

function TRiverObservationWriter.GetIOWTQ: integer;
begin
  if frmModflow.cbSpecifyRiverCovariances.Checked then
  begin
    result := 1;
  end
  else
  begin
    result := 0;
  end;
end;

function TRiverObservationWriter.GetIPRN: integer;
begin
  result := frmModflow.comboRiverObsPrintFormats.ItemIndex + 1;
end;

function TRiverObservationWriter.GetLayerRoot: string;
begin
  result := ModflowTypes.GetMFRiverFluxObservationsLayerType.WriteNewRoot;
end;

function TRiverObservationWriter.GetNumberOfLayers: Integer;
begin
  result := StrToInt(frmModflow.adeRIVObsLayerCount.Text);
end;

function TRiverObservationWriter.GetNumberOfTimes: Integer;
begin
  result := StrToInt(frmModflow.adeObsRIVTimeCount.Text);
end;

function TRiverObservationWriter.GetOutKey: string;
begin
  Result := 'RVOB_OUT';
end;

function TRiverObservationWriter.GetPackageName: string;
begin
  result := 'River Observations'

end;

function TRiverObservationWriter.GetVarianceStringGrid: TStringGrid;
begin
  result := frmMODFLOW.dgRIVObsBoundCovariances;
end;

function TRiverObservationWriter.UseLayer(
  const LayerIndex: integer): boolean;
begin
  result := frmModflow.clbRiverObservations.State[LayerIndex -1] = cbChecked;
end;

end.
