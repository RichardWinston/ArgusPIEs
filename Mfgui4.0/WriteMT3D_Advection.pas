unit WriteMT3D_Advection;

interface

uses Sysutils, WriteModflowDiscretization;

type
  TMT3D_AdvectionWriter = class(TModflowWriter)
  private
    MIXELM : integer;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5;
  public
    procedure WriteFile(const Root: string);
  end;

implementation

uses UtilityFunctions, Variables, WriteNameFileUnit;

{ TMT3D_AdvectionWriter }

procedure TMT3D_AdvectionWriter.WriteDataSet1;
var
  PERCEL : double;
  MXPART, NADVFD : integer;
begin
  with frmModflow do
  begin
    MIXELM := comboMT3DAdvSolScheme.ItemIndex;
    if MIXELM = 4 then
    begin
      MIXELM := -1;
    end;
    PERCEL := InternationalStrToFloat(adeMT3DMaxParticleMovement.Text);
    MXPART := StrToInt(adeMT3DMaxParticleCount.Text);
    NADVFD := comboMT3DAdvWeightingScheme.ItemIndex + 1;
  end;

  writeln(FFile,
    FixedFormattedInteger(MIXELM, 10),
    FixedFormattedReal(PERCEL, 10),
    FixedFormattedInteger(MXPART, 10),
    FixedFormattedInteger(NADVFD, 10));
end;

procedure TMT3D_AdvectionWriter.WriteDataSet2;
var
  ITRACK : integer;
  WD : double;
begin
  if (MIXELM >= 1) and (MIXELM <= 3) then
  begin
    with frmModflow do
    begin
      ITRACK := comboMT3DParticleTrackingAlg.ItemIndex + 1;
      WD := InternationalStrToFloat(adeMT3DConcWeight.Text);
    end;
    Writeln(FFile,
      FixedFormattedInteger(ITRACK, 10),
      FixedFormattedReal(WD, 10));
  end;
end;

procedure TMT3D_AdvectionWriter.WriteDataSet3;
var
  DCEP : double;
  NPLANE, NPL, NPH, NPMIN, NPMAX : integer;
begin
  if (MIXELM = 1) or (MIXELM = 3) then
  begin
    with frmModflow do
    begin
      DCEP := InternationalStrToFloat(adeMT3DNeglSize.Text);
      if comboMT3DInitPartPlace.ItemIndex = 0 then
      begin
        NPLANE := 0;
      end
      else
      begin
        NPLANE := StrToInt(adeMT3DParticlePlaneCount.Text);
      end;
      NPL := StrToInt(adeMT3DInitPartSmall.Text);
      NPH := StrToInt(adeMT3DInitPartLarge.Text);
      NPMIN := StrToInt(adeMT3DMinPartPerCell.Text);
      NPMAX := StrToInt(adeMT3DMaxPartPerCell.Text);
    end;

    writeLn(FFile,
      FixedFormattedReal(DCEP, 10),
      FixedFormattedInteger(NPLANE, 10),
      FixedFormattedInteger(NPL, 10),
      FixedFormattedInteger(NPH, 10),
      FixedFormattedInteger(NPMIN, 10),
      FixedFormattedInteger(NPMAX, 10));
  end;
end;

procedure TMT3D_AdvectionWriter.WriteDataSet4;
var
  INTERP, NLSINK, NPSINK : integer;
begin
  if (MIXELM = 2) or (MIXELM = 3) then
  begin
    with frmModflow do
    begin
  //    INTERP := comboMT3DInterpMeth.ItemIndex;
      INTERP := 1;
      if comboMT3DInitPartSinkChoice.ItemIndex = 0 then
      begin
        NLSINK := 0;
      end
      else
      begin
        NLSINK := StrToInt(adeMT3DSinkParticlePlaneCount.Text);
      end;
      NPSINK := StrToInt(adeMT3DSinkParticleCount.Text);
    end;

    writeLn(FFile,
      FixedFormattedInteger(INTERP, 10),
      FixedFormattedInteger(NLSINK, 10),
      FixedFormattedInteger(NPSINK, 10));
  end;
end;

procedure TMT3D_AdvectionWriter.WriteDataSet5;
var
  DCHMOC : double;
begin
  if (MIXELM = 3) then
  begin
    DCHMOC := InternationalStrToFloat(frmModflow.adeMT3DCritRelConcGrad.Text);

    writeLn(FFile,
      FixedFormattedReal(DCHMOC, 10));
  end;

end;

procedure TMT3D_AdvectionWriter.WriteFile(const Root: string);
var
  FileName : string;
begin
  FileName := GetCurrentDir + '\' + Root + rsADV;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);

    WriteDataSet1;
    WriteDataSet2;
    WriteDataSet3;
    WriteDataSet4;
    WriteDataSet5;
  finally
    CloseFile(FFile);
  end;

end;

end.
