unit WriteHeadFluxObservationsUnit;

interface

uses Sysutils, StdCtrls, Grids, WriteFluxObservationsUnit;

type
  THeadFluxObservationWriter = class(TCustomObservationWriter)
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

{ THeadFluxObservationWriter }

function THeadFluxObservationWriter.GetEVF: double;
begin
  Result := InternationalStrToFloat(frmModflow.adeHeadFluxObsErrMult.Text);
end;

function THeadFluxObservationWriter.GetFileExtension: string;
begin
  result := rsChob
end;

function THeadFluxObservationWriter.GetIOWTQ: integer;
begin
  if frmModflow.cbSpecifyHeadFluxCovariances.Checked then
  begin
    result := 1;
  end
  else
  begin
    result := 0;
  end;
end;

function THeadFluxObservationWriter.GetIPRN: integer;
begin
  result := frmModflow.comboHeadFluxObsPrintFormats.ItemIndex + 1;
end;

function THeadFluxObservationWriter.GetLayerRoot: string;
begin
  result := ModflowTypes.GetMFSpecifiedHeadFluxObservationsLayerType.WriteNewRoot;
end;

function THeadFluxObservationWriter.GetNumberOfLayers: Integer;
begin
  result := StrToInt(frmModflow.adeHeadFluxObsLayerCount.Text);
end;

function THeadFluxObservationWriter.GetNumberOfTimes: Integer;
begin
  result := StrToInt(frmModflow.adeObsHeadFluxTimeCount.Text);
end;

function THeadFluxObservationWriter.GetOutKey: string;
begin
  result := 'CHOB_OUT'
end;

function THeadFluxObservationWriter.GetPackageName: string;
begin
  result := 'Specified Head Flux Observations'

end;

function THeadFluxObservationWriter.GetVarianceStringGrid: TStringGrid;
begin
  result := frmMODFLOW.dgHeadFluxObsBoundCovariances;
end;

function THeadFluxObservationWriter.UseLayer(
  const LayerIndex: integer): boolean;
begin
  result := frmModflow.clbPrescribeHeadFlux.State[LayerIndex -1] = cbChecked;
end;

end.
