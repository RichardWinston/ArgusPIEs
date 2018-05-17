unit MF2K_Importer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, mf2kInterface, contnrs;

type
  TMF2K_Importer = class(TObject)
  public
    NLAY, NROW, NCOL, NPER, ITMUNI,
      LENUNI, ISENALL, NZN, NML, MXITER,
      NPARM, ITMX, MXUP, MXLOW, MXBW,
      ITER1, NPCOND, ICG, NPLIST, IUHEAD,
      MXSEN, IPRINTS, ISENSU, ISENPU, ISENFM,
      ITMXP, IBEFLG, IYCFLG, IOSTAR, NOPT,
      NFIT, IAP, IPRC, IPRINT, LPRINT,
      LASTX, NPNG, IPR, MPR, ISCALS,
      NH, MOBS, MAXM, NQDR, NQTDR,
      NQRV, NQTRV, NQGB, NQTGB, NQST,
      NQTST, NQCH, NQTCH, NQDT, NQTDT,
      NPTH, NTT2, IOUTT2, KTFLG, KTREV,
      NZONAR, NMLTAR, NHUF, NRIVER, NBOUND,
      NRCHOP, NEVTOP, IPRSOR, IPCALC, IPRSIP,
      IFREQ, IPRD4, NBPOL, IPRPCG, MUTPCG,
      MXCYC, DUP, DLOW, IOUTAMG, ISS,
      IWDFLG, IWETIT, IHDWET, ISEN, NBDTIM, NETSOP,
      NETSEG, NCHDS, IITER, IADAMP, IOUTGMG, ISM, ISC: longint;
    HDRY, STOR1, STOR2, STOR3, DMAX,
      TOL, SOSC, SOSR, RMAR, RMARM,
      CSA, FCONV, ADVSTP, FSNK, ACCL,
      HCLOSE, WSEED, RCLOSE, RELAX, DAMP,
      BCLOSE, WETFCT: single;
    GMGRELAX: double;
    IUNIT: TIUnitArray;
    LAYCBD, LBOTM: TLAYCBD_Array;
    PERLEN: TPERLEN_Array;
    NSTP: TNSTEP_Array;
    TSMULT: TPERLEN_Array;
    NSTEP: TNSTEP_Array;
    ISSFLG: TNSTEP_Array;
    LAYTYP, LAYAVG: TLAYCBD_Array;
    CHANI: TCHANI_Array;
    LAYVKA, LAYWET, LAYCON: TLAYCBD_Array;
    NWELLS, NDRAIN: longint;
    NPEVT, NPGHB, NPDRN, NPHFB, NPRIV, NPSTR, NPWEL, NPRCH, NPETS, InstanceCount: longint;
    NNPWEL, NNPDRN,NNPRIV, NNPGHB, NNPCHD, CurrentNameCount: longint;
    procedure InitializeVariables;
    procedure ReadSteady;
    procedure Close;
    procedure InitializeTransient;
    procedure ReadTransient(const StressPeriodIndex: integer);
    { Public declarations }
  end;

function SingleToStr(Value: extended): string;
function DoubleToStr(Value: extended): string;

implementation

Uses Math;

function NumberToStr(Value: extended; Precision: integer): string;
var
  Temp: TFloatRec;
  Index: integer;
begin
  FloatToDecimal(Temp, Value, fvExtended, Precision, Precision);
  SetString(Result, Temp.Digits, 18);
  for Index := 1 to Length(Result) do
  begin
    if Ord(result[Index]) = 0 then
    begin
      result := Copy(result, 1, Index-1);
      break;
    end;
  end;

  if Temp.Exponent > 0 then
  begin
    if Temp.Exponent > Length(Result) then
    begin
      Insert('.', result, 2);
      result := result + 'E' + IntToStr(Temp.Exponent-1);
    end
    else
    begin
      Insert('.', result, Temp.Exponent+1);
    end;
  end
  else
  begin
    if Temp.Exponent > -4 then
    begin
      for Index := 1 to -Temp.Exponent do
      begin
        result := '0' + result;
      end;
      result := '0.' + result;
    end
    else
    begin
      Insert('.', result, 2);
      result := result + 'E' + IntToStr(Temp.Exponent-1);
    end;
  end;
  if Temp.Negative then
  begin
    result := '-' + result;
  end;
end;


function SingleToStr(Value: extended): string;
var
  Buffer: array[0..63] of Char;
begin
  SetString(Result, Buffer, FloatToText(Buffer, Value, fvExtended,
    ffGeneral, 8, 0));

//  result := NumberToStr(Value, 8);
end;

function DoubleToStr(Value: extended): string;
begin
  result := NumberToStr(Value, 16);
end;

procedure TMF2K_Importer.InitializeTransient;
var
  Index: integer;
begin
  for Index := 0 to NPER -1 do
  begin
    NSTEP[Index] := 1;
  end;
end;

procedure TMF2K_Importer.ReadTransient(const StressPeriodIndex: integer);
var
  KPER: longint;
begin
  KPER := StressPeriodIndex + 1;
  ReadStressPeriod(KPER, NCOL, NROW, NLAY, NWELLS, NDRAIN, NRIVER, NBOUND,
    NRCHOP, NEVTOP, NCHDS, ISEN, NETSOP, NETSEG,
    IUNIT, ISSFLG, TSMULT, NSTEP, PERLEN);
  GetParameterCounts(NPEVT, NPGHB, NPDRN, NPHFB,
    NPRIV, NPSTR, NPWEL, NPRCH, NPETS, InstanceCount);

end;

procedure TMF2K_Importer.ReadSteady;
begin
  InitializeVariables;

  INITMF2K(NLAY, NROW, NCOL, NPER, ITMUNI,
      LENUNI, ISENALL, NZN, NML, MXITER,
      NPARM, ITMX, MXUP, MXLOW, MXBW,
      ITER1, NPCOND, ICG, NPLIST, IUHEAD,
      MXSEN, IPRINTS, ISENSU, ISENPU, ISENFM,
      ITMXP, IBEFLG, IYCFLG, IOSTAR, NOPT,
      NFIT, IAP, IPRC, IPRINT, LPRINT,
      LASTX, NPNG, IPR, MPR, ISCALS,
      NH, MOBS, MAXM, NQDR, NQTDR,
      NQRV, NQTRV, NQGB, NQTGB, NQST,
      NQTST, NQCH, NQTCH, NQDT, NQTDT,
      NPTH, NTT2, IOUTT2, KTFLG, KTREV,
      NZONAR, NMLTAR, NHUF, NRIVER, NBOUND,
      NRCHOP, NEVTOP, IPRSOR, IPCALC, IPRSIP,
      IFREQ, IPRD4, NBPOL, IPRPCG, MUTPCG,
      MXCYC, DUP, DLOW, IOUTAMG, ISS,
      IWDFLG, IWETIT, IHDWET, ISEN, NBDTIM, NETSOP,
      NETSEG, NCHDS, IITER, IADAMP, IOUTGMG, ISM, ISC,
    HDRY, STOR1, STOR2, STOR3, DMAX, TOL, SOSC, SOSR, RMAR, RMARM,
      CSA, FCONV, ADVSTP, FSNK, ACCL, HCLOSE, WSEED, RCLOSE, RELAX,
      DAMP, BCLOSE, WETFCT,
    GMGRELAX,
    IUNIT, LAYCBD, LBOTM, PERLEN, NSTP, TSMULT, ISSFLG,
      LAYTYP, LAYAVG, CHANI, LAYVKA, LAYWET, LAYCON);

end;

procedure TMF2K_Importer.InitializeVariables;
var
  Index: integer;
begin
  NLAY := -1;
  NROW := -1;
  NCOL := -1;
  NPER := -1;
  ITMUNI := -1;
  LENUNI := -1;
  ISENALL := -1;
  NZN := -1;
  NML := -1;
  MXITER := -1;
  NPARM := -1;
  ITMX := -1;
  MXUP := -1;
  MXLOW := -1;
  MXBW := -1;
  ITER1 := -1;
  NPCOND := -1;
  ICG := -1;
  NPLIST := -1;
  IUHEAD := -1;
  MXSEN := -1;
  IPRINTS := -1;
  ISENSU := -1;
  ISENPU := -1;
  ISENFM := -1;

  ITMXP := -1;
  IBEFLG := -1;
  IYCFLG := -1;
  IOSTAR := -1;
  NOPT := -1;
  NFIT := -1;
  IAP := -1;
  IPRC := -1;
  IPRINT := -1;
  LPRINT := -1;
  LASTX := -1;
  NPNG := -1;
  IPR := -1;
  MPR := -1;
  ISCALS := -1;
  NH := -1;
  MOBS := -1;
  MAXM := -1;
  NQDR := -1;
  NQTDR := -1;
  NQRV := -1;
  NQTRV := -1;
  NQGB := -1;
  NQTGB := -1;
  NQST := -1;
  NQTST := -1;
  NQCH := -1;
  NQTCH := -1;
  NQDT := -1;
  NQTDT := -1;

  NPTH := -1;
  NTT2 := -1;
  IOUTT2 := -1;
  KTFLG := -1;
  KTREV := -1;
  NZONAR := -1;
  NMLTAR := -1;
  NHUF := -1;
  NRIVER := -1;
  NBOUND := -1;
  NRCHOP := -1;
  NEVTOP := -1;
  IPRSOR := -1;
  IPCALC := -1;
 
  NWELLS := -1;
  NNPWEL := -1;
  NNPRIV := -1;
  NNPGHB := -1;
  NNPCHD := -1;
  IFREQ := -1;
  IPRD4 := -1;
  NBPOL := -1;
  IPRPCG := -1;
  MUTPCG := -1;
  MXCYC := -1;
  DUP := -1;
  DLOW := -1;
  IOUTAMG := -1;
  ISS := -1;
  IWDFLG := -1;
  IWETIT := 1;
  IHDWET := -1;
  ISEN := 0;
  NBDTIM := 0;
  NETSOP := 0;
  NPETS := 0;
  NETSEG := 0;
  NCHDS := 0;
  IITER := 0;
  IADAMP := 0;
  IOUTGMG := 0;
  ISM := 0;
  ISC := 0;

  CurrentNameCount := -1;
  NDRAIN := -1;
  NRIVER := -1;
  NBOUND := -1;
  NRCHOP := -1;
  NEVTOP := -1;
  IPRSOR := -1;
  IPRSIP := -1;

  HDRY := -1;
  STOR1 := -1;
  STOR2 := -1;
  STOR3 := -1;

  DMAX := -1;
  TOL := -1;
  SOSC := -1;
  SOSR := -1;
  RMAR := -1;
  RMARM := -1;
  CSA := -1;
  FCONV := -1;
  ACCL := -1;
  HCLOSE := -1;
  WSEED := -1;
  RCLOSE := -1;
  RELAX := -1;
  DAMP := -1;
  BCLOSE := -1;
  WETFCT := 0;
  GMGRELAX := 0;

  for Index := 0 to IUNITArraySize -1 do
  begin
    IUNIT[Index] := 0;
  end;
  for Index := 0 to LAYCBD_ArraySize -1 do
  begin
    LAYCBD[Index] := -1;
    LBOTM[Index] := -2;
    LAYTYP[Index] := -1;
    LAYAVG[Index] := -1;
    CHANI[Index] := -1;
    LAYVKA[Index] := -1;
    LAYWET[Index] := -1;
    LAYCON[Index] := -1;
  end;
  for Index := 0 to MXPER -1 do
  begin
    PERLEN[Index] := -1;
    NSTP[Index] := -2;
    TSMULT[Index] := -1;
    ISSFLG[Index] := -2;
  end;

end;

procedure TMF2K_Importer.Close;
begin
  CLOSE_MF2K;
end;

{ THeadObservation }

end.
