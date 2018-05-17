unit WriteGHBObservationsUnit;

interface

uses Sysutils, StdCtrls, Grids, WriteFluxObservationsUnit;

type
  TGHBObservationWriter = class(TCustomObservationWriter)
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

{ TGHBObservationWriter }

function TGHBObservationWriter.GetEVF: double;
begin
  Result := InternationalStrToFloat(frmModflow.adeGHBObsErrMult.Text);
end;

function TGHBObservationWriter.GetFileExtension: string;
begin
  result := rsGbob
end;

function TGHBObservationWriter.GetIOWTQ: integer;
begin
  if frmModflow.cbSpecifyGHBCovariances.Checked then
  begin
    result := 1;
  end
  else
  begin
    result := 0;
  end;
end;

function TGHBObservationWriter.GetIPRN: integer;
begin
  result := frmModflow.comboGHBObsPrintFormats.ItemIndex + 1;
end;

function TGHBObservationWriter.GetLayerRoot: string;
begin
  result := ModflowTypes.GetMFGHBFluxObservationsLayerType.WriteNewRoot;
end;

function TGHBObservationWriter.GetNumberOfLayers: Integer;
begin
  result := StrToInt(frmModflow.adeGHBObsLayerCount.Text);
end;

function TGHBObservationWriter.GetNumberOfTimes: Integer;
begin
  result := StrToInt(frmModflow.adeObsGHBTimeCount.Text);
end;

function TGHBObservationWriter.GetOutKey: string;
begin
  result := 'GBOB_OUT';
end;

function TGHBObservationWriter.GetPackageName: string;
begin
  result := 'General-Head Boundary Observations'
end;

function TGHBObservationWriter.GetVarianceStringGrid: TStringGrid;
begin
  result := frmMODFLOW.dgGHBObsBoundCovariances;
end;

function TGHBObservationWriter.UseLayer(
  const LayerIndex: integer): boolean;
begin
  result := frmModflow.clbGHB_Observations.State[LayerIndex -1] = cbChecked;
end;

end.
