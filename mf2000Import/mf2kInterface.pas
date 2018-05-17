unit mf2kInterface;

interface

uses Sysutils;

const
  IUNITArraySize = 100;
  LAYCBD_ArraySize = 200;
  MXPER=1000;

type
  TIUnitArray = array[0..IUNITArraySize-1] of longint;
  TLAYCBD_Array = array[0..LAYCBD_ArraySize-1] of longint;
  TCHANI_Array = array[0..LAYCBD_ArraySize-1] of single;
  TPERLEN_Array = array[0..MXPER-1] of single;
  TNSTEP_Array = array[0..MXPER-1] of longint;
  TString11 = String[11];
  TString13 = String[13];
  TString5 = String[5];
  TString201 = String[201];

procedure INITMF2K(var NLAY, NROW, NCOL, NPER, ITMUNI,
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
    IWDFLG: longint;
  var HDRY, STOR1, STOR2, STOR3, DMAX, TOL, SOSC, SOSR, RMAR, RMARM,
    CSA, FCONV, ADVSTP, FSNK, ACCL, HCLOSE, WSEED, RCLOSE, RELAX,
    DAMP, BCLOSE: single;
  var IUNIT: TIUnitArray; var LAYCBD, LBOTM: TLAYCBD_Array;
  var PERLEN: TPERLEN_Array; var NSTP: TNSTEP_Array; var TSMULT: TPERLEN_Array;
  var ISSFLG: TNSTEP_Array; var LAYTYP, LAYAVG: TLAYCBD_Array;
  var CHANI: TCHANI_Array;
  var LAYVKA, LAYWET, LAYCON: TLAYCBD_Array);
  stdcall; external 'modflw2000.dll';

procedure ReadStressPeriod(var KPER, NCOL, NROW, NLAY, NWELLS, NDRAIN,
  NRIVER, NBOUND, NRCHOP, NEVTOP: longint;
  var IUNIT: TIUnitArray;
  var ISSFLG: TNSTEP_Array;
  var TSMULT: TPERLEN_Array;
  var NSTEP: TNSTEP_Array;
  var PERLEN: TPERLEN_Array);
  stdcall; external 'modflw2000.dll';


procedure CLOSE_MF2K; stdcall; external 'modflw2000.dll';

function NIPRNAM(I: longint): string;
function OBSNAM(I: longint): string;
function EQNAM(I: longint): string;
function NAMES(I: longint): string;
function PARNAM(I: longint): string;
function PARTYP(I: longint): string;
function INAME(I: longint): string;
function MLTNAM(I: longint): string;
function ZONNAM(I: longint): string;
function MultiplierFunction(I: longint): string;

procedure GetCellLimits(var IParam: longint; var ISTART, ISTOP: longint);
  stdcall; external 'modflw2000.dll';


procedure GetInstanceStart(var I: longint; var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetClusterRange(var I: longint; var ISTART, ISTOP: longint);
  stdcall; external 'modflw2000.dll';

procedure GetIPCLST(var Item, IParam: longint; var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetWell(var Layer, Row, Column : longint; var Q: single;
  var IIndex)
  stdcall; external 'modflw2000.dll';

procedure GetRiver(var Layer, Row, Column: longint;
  var Elevation, Cond, RBOT: single; var IIndex)
  stdcall; external 'modflw2000.dll';

procedure GetGHB(var Layer, Row, Column: longint; var Elevation, Cond: single;
  var IIndex)
  stdcall; external 'modflw2000.dll';

procedure GetDrain(var Layer, Row, Column: longint; var Elevation, Cond: single;
  var IIndex: longint);
  stdcall; external 'modflw2000.dll';

procedure GetCurrentParamNameAndInstance(I: longint; var PARAM, INSTANCE: string);

procedure ParameterValue(var I: longint; var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetInstanceCount(var I: longint; var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetIZONE(var ICol, IRow, IArray, NCOL, NROW, NZONAR: longint;
  var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetDELR(var ICol, NCOL: longint; var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetDELC(var ICOW, NROW: longint; var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetIRCH(var ICol, IRow, NCOL, NROW: longint;
  var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetIEVT(var ICol, IRow, NCOL, NROW: longint;
  var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetSURF(var ICol, IRow, NCOL, NROW: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetEXDP(var ICol, IRow, NCOL, NROW: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetEVTR(var ICol, IRow, NCOL, NROW: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetRECH(var ICol, IRow, NCOL, NROW: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetBOTM(var ICol, IRow, ILAY, NCOL, NROW, NLAY_Plus_1: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetIBOUND(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetIPSUM(var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetHUFTHK(var ICol, IRow, ILAY, I, NCOL, NROW, NLAY: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetSTRT(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var VALUE: single)
  stdcall; external 'modflw2000.dll';

procedure GetLAYFLG(var I, ILAY, NLAY: longint;
  var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetISENS(var I, NPLIST: longint;
  var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetHANI(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetVKCB(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetVKA(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetHK(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetHY(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetCC(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetCV(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetWETDRY(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var VALUE: single; var IUnitBCF: longint);
  stdcall; external 'modflw2000.dll';

procedure GetTRPY(var ILAY, NLAY: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetSC2(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var VALUE: single; var IUnitBCF: longint);
  stdcall; external 'modflw2000.dll';

procedure GetSC1(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var VALUE: single; var IUnitBCF: longint);
  stdcall; external 'modflw2000.dll';

procedure GetRMLT(var ICol, IRow, IArray, NCOL, NROW, NMLTAR: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetParameterCounts(var NPEVT, NPGHB, NPDRN, NPHFB,
  NPRIV, NPSTR, NPWEL, NPRCH, InstanceCount: longint);
  stdcall; external 'modflw2000.dll';

procedure GetStressPeriodCounts(var NNPWEL, NNPDRN, NNPRIV,
  NNPGHB, CurrentNameCount: longint);
  stdcall; external 'modflw2000.dll';

implementation

procedure RetrieveNIPRNAM(var I: longint; var VALUE: TString11; length: longint);
  stdcall; external 'modflw2000.dll';

function NIPRNAM(I: longint): string;
var
  Value: TString11;
begin
  Value := '           ';
  RetrieveNIPRNAM(I, Value, Length(Value));
  result := Trim(Value);
end;

procedure RetrieveEQNAM(var I: longint; var VALUE: TString11; length: longint);
  stdcall; external 'modflw2000.dll';

function EQNAM(I: longint): string;
var
  Value: TString11;
begin
  Value := '           ';
  RetrieveEQNAM(I, Value, Length(Value));
  result := Trim(Value);
end;

procedure RetrieveNAMES(var I: longint; var VALUE: TString13; length: longint);
  stdcall; external 'modflw2000.dll';

function NAMES(I: longint): string;
var
  Value: TString13;
begin
  Value := '             ';
  RetrieveNAMES(I, Value, Length(Value));
  result := Trim(Value);
end;

procedure RetrieveOBSNAM(var I: longint; var VALUE: TString13; length: longint);
  stdcall; external 'modflw2000.dll';

function OBSNAM(I: longint): string;
var
  Value: TString13;
begin
  Value := '             ';
  RetrieveOBSNAM(I, Value, Length(Value));
  result := Trim(Value);
end;

procedure RetrievePARNAM(var I: longint; var VALUE: TString11; length: longint);
  stdcall; external 'modflw2000.dll';

function PARNAM(I: longint): string;
var
  Value: TString11;
begin
  Value := '           ';
  RetrievePARNAM(I, Value, Length(Value));
  result := Trim(Value);
end;

procedure RetrievePARTYP(var I: longint; var VALUE: TString5; length: longint);
  stdcall; external 'modflw2000.dll';

function PARTYP(I: longint): string;
var
  Value: TString5;
begin
  Value := '     ';
  RetrievePARTYP(I, Value, Length(Value));
  result := Trim(Value);
end;

procedure RetrieveINAME(var I: longint; var VALUE: TString11; length: longint);
  stdcall; external 'modflw2000.dll';

function INAME(I: longint): string;
var
  Value: TString11;
begin
  Value := '           ';
  RetrieveINAME(I, Value, Length(Value));
  result := Trim(Value);
end;

procedure RetrieveMLTNAM(var I: longint; var VALUE: TString11; length: longint);
  stdcall; external 'modflw2000.dll';

function MLTNAM(I: longint): string;
var
  Value: TString11;
begin
  Value := '           ';
  RetrieveMLTNAM(I, Value, Length(Value));
  result := Trim(Value);
end;

procedure RetrieveZONNAM(var I: longint; var VALUE: TString11; length: longint);
  stdcall; external 'modflw2000.dll';

function ZONNAM(I: longint): string;
var
  Value: TString11;
begin
  Value := '           ';
  RetrieveZONNAM(I, Value, Length(Value));
  result := Trim(Value);
end;

procedure RetrieveMultiplierFuction(var I: longint; var VALUE: TString201;
  length: longint);
  stdcall; external 'modflw2000.dll';

function MultiplierFunction(I: longint): string;
var
  Value: TString201;
  Index: integer;
begin
  Value := '';
  for Index := 1 to 201 do
  begin
    Value := Value + ' ';
  end;
  RetrieveMultiplierFuction(I, Value, Length(Value));
  result := Trim(Value);
end;


procedure RetrieveCurrentParamAndInstance(var I: longint;
  var PARAM, INSTANCE: TString11; Count1, Count2: longint);
  stdcall; external 'modflw2000.dll';

procedure GetCurrentParamNameAndInstance(I: longint; var PARAM, INSTANCE: string);
var
  localPARAM, localINSTANCE: TString11;
begin
  localPARAM := '           ';
  localINSTANCE := '           ';
  RetrieveCurrentParamAndInstance(I, localPARAM, localINSTANCE,
    Length(localPARAM), Length(localINSTANCE));
  PARAM := Trim(localPARAM);
  INSTANCE := Trim(localINSTANCE);
end;

end.
