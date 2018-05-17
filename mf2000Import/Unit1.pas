unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, mf2kInterface;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    BitBtn1: TBitBtn;
    procedure Button1Click(Sender: TObject);
  private
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
      IWDFLG: longint;
    HDRY, STOR1, STOR2, STOR3, DMAX,
      TOL, SOSC, SOSR, RMAR, RMARM,
      CSA, FCONV, ADVSTP, FSNK, ACCL,
      HCLOSE, WSEED, RCLOSE, RELAX, DAMP,
      BCLOSE: single;
    IUNIT: TIUnitArray;
    LAYCBD, LBOTM: TLAYCBD_Array;
    PERLEN: TPERLEN_Array;
    NSTP: TNSTEP_Array;
    TSMULT: TPERLEN_Array;
    ISSFLG: TNSTEP_Array;
    LAYTYP, LAYAVG: TLAYCBD_Array;
    CHANI: TCHANI_Array;
    LAYVKA, LAYWET, LAYCON: TLAYCBD_Array;
    NWELLS, NDRAIN: longint;
    NPEVT, NPGHB, NPDRN, NPHFB, NPRIV, NPSTR, NPWEL, NPRCH, InstanceCount: longint;
    NNPWEL, NNPDRN,NNPRIV, NNPGHB, CurrentNameCount: longint;
    procedure InitializeVariables;
    procedure WriteVariables;
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form1: TForm1;

implementation

Uses Math;

{$R *.DFM}

function SingleToStr(Value: extended): string;
var
  Temp: TFloatRec;
  Index: integer;
begin
  FloatToDecimal(Temp, Value, fvExtended, 8, 8);
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


procedure TForm1.Button1Click(Sender: TObject);
var
  KPER: longint;
  NSTEP: TNSTEP_Array;
  Index: integer;
begin
  InitializeVariables;
  try

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
      IWDFLG,
    HDRY, STOR1, STOR2, STOR3, DMAX, TOL, SOSC, SOSR, RMAR, RMARM,
      CSA, FCONV, ADVSTP, FSNK, ACCL, HCLOSE, WSEED, RCLOSE, RELAX,
      DAMP, BCLOSE,
    IUNIT, LAYCBD, LBOTM, PERLEN, NSTP, TSMULT, ISSFLG,
      LAYTYP, LAYAVG, CHANI, LAYVKA, LAYWET, LAYCON);

    KPER := 1;
    for Index := 0 to NPER -1 do
    begin
      NSTEP[Index] := 1;
    end;

    for Index := 1 to NPER do
    begin
      KPER := Index;
      ReadStressPeriod(KPER, NCOL, NROW, NLAY, NWELLS, NDRAIN, NRIVER, NBOUND,
        NRCHOP, NEVTOP,
        IUNIT, ISSFLG, TSMULT, NSTEP, PERLEN);

      WriteVariables;
    end;

  finally

    CLOSE_MF2K;
  end;
end;

procedure TForm1.InitializeVariables;
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
  NWELLS := -1;
  NNPWEL := -1;
  NNPRIV := -1;
  NNPGHB := -1;
  IPRSOR := -1;
  IPCALC := -1;
  IPRSIP := -1;
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


  CurrentNameCount := -1;
  NDRAIN := -1;
  NRIVER := -1;
  NBOUND := -1;
  NRCHOP := -1;
  NEVTOP := -1;


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

procedure TForm1.WriteVariables;
var
  Index, ZoneIndex: integer;
  Value: single;
  IVALUE: longint;
  I: longint;
  ICOL, IROW, ILAY: longint;
  LayIndex, RowIndex, ColIndex: integer;
  NLAY_Plus_1: longint;
  PARAM, INSTANCE: string;
  Elevation, Cond, Q, RBOT: single;
  IDummy, ZoneCount, ZI, ClusterIndex, CellIndex: longint;
  AString: string;
  InstanceIndex, CellListIndex: integer;
  ISTART,ISTOP, NUMINST: longint;
  ParameterNames: TStringList;
  IIndex: integer;
begin
  ParameterNames := TStringList.Create;
  try

{  Memo1.Lines.Add('NLAY = '+ IntToStr(NLAY));
  Memo1.Lines.Add('NROW = '+ IntToStr(NROW));
  Memo1.Lines.Add('NCOL = '+ IntToStr(NCOL));
  Memo1.Lines.Add('NPER = '+ IntToStr(NPER));
  Memo1.Lines.Add('ITMUNI = '+ IntToStr(ITMUNI));
  Memo1.Lines.Add('LENUNI = '+ IntToStr(LENUNI));
  Memo1.Lines.Add('ISENALL = '+ IntToStr(ISENALL));
  Memo1.Lines.Add('NZN = '+ IntToStr(NZN));
  Memo1.Lines.Add('NML = '+ IntToStr(NML));
  Memo1.Lines.Add('MXITER = '+ IntToStr(MXITER));
  Memo1.Lines.Add('NPARM = '+ IntToStr(NPARM));
  Memo1.Lines.Add('ITMX = '+ IntToStr(ITMX));
  Memo1.Lines.Add('MXUP = '+ IntToStr(MXUP));
  Memo1.Lines.Add('MXLOW = '+ IntToStr(MXLOW));
  Memo1.Lines.Add('MXBW = '+ IntToStr(MXBW));
  Memo1.Lines.Add('ITER1 = '+ IntToStr(ITER1));
  Memo1.Lines.Add('NPCOND = '+ IntToStr(NPCOND));
  Memo1.Lines.Add('ICG = '+ IntToStr(ICG));
  Memo1.Lines.Add('NPLIST = '+ IntToStr(NPLIST));
  Memo1.Lines.Add('IUHEAD = '+ IntToStr(IUHEAD));
  Memo1.Lines.Add('MXSEN = '+ IntToStr(MXSEN));
  Memo1.Lines.Add('IPRINTS = '+ IntToStr(IPRINTS));
  Memo1.Lines.Add('ISENSU = '+ IntToStr(ISENSU));
  Memo1.Lines.Add('ISENPU = '+ IntToStr(ISENPU));
  Memo1.Lines.Add('ISENFM = '+ IntToStr(ISENFM));

  Memo1.Lines.Add('ITMXP = '+ IntToStr(ITMXP));
  Memo1.Lines.Add('IBEFLG = '+ IntToStr(IBEFLG));
  Memo1.Lines.Add('IYCFLG = '+ IntToStr(IYCFLG));
  Memo1.Lines.Add('IOSTAR = '+ IntToStr(IOSTAR));
  Memo1.Lines.Add('NOPT = '+ IntToStr(NOPT));
  Memo1.Lines.Add('NFIT = '+ IntToStr(NFIT));
  Memo1.Lines.Add('IAP = '+ IntToStr(IAP));
  Memo1.Lines.Add('IPRC = '+ IntToStr(IPRC));
  Memo1.Lines.Add('IPRINT = '+ IntToStr(IPRINT));
  Memo1.Lines.Add('LPRINT = '+ IntToStr(LPRINT));
  Memo1.Lines.Add('LASTX = '+ IntToStr(LASTX));
  Memo1.Lines.Add('NPNG = '+ IntToStr(NPNG));
  Memo1.Lines.Add('IPR = '+ IntToStr(IPR));
  Memo1.Lines.Add('MPR = '+ IntToStr(MPR));
  Memo1.Lines.Add('ISCALS = '+ IntToStr(ISCALS));
  Memo1.Lines.Add('NH = '+ IntToStr(ISCALS));
  Memo1.Lines.Add('MOBS = '+ IntToStr(ISCALS));
  Memo1.Lines.Add('MAXM = '+ IntToStr(ISCALS));
  Memo1.Lines.Add('NQDR = '+ IntToStr(NQDR));
  Memo1.Lines.Add('NQTDR = '+ IntToStr(NQTDR));
  Memo1.Lines.Add('NQRV = '+ IntToStr(NQRV));
  Memo1.Lines.Add('NQTRV = '+ IntToStr(NQTRV));
  Memo1.Lines.Add('NQGB = '+ IntToStr(NQGB));
  Memo1.Lines.Add('NQTGB = '+ IntToStr(NQTGB));
  Memo1.Lines.Add('NPTH = '+ IntToStr(NPTH));
  Memo1.Lines.Add('NTT2 = '+ IntToStr(NTT2));
  Memo1.Lines.Add('IOUTT2 = '+ IntToStr(IOUTT2));
  Memo1.Lines.Add('KTFLG = '+ IntToStr(KTFLG));
  Memo1.Lines.Add('KTREV = '+ IntToStr(KTREV));
  Memo1.Lines.Add('NZONAR = '+ IntToStr(NZONAR));
  Memo1.Lines.Add('NMLTAR = '+ IntToStr(NMLTAR));
  Memo1.Lines.Add('NHUF = '+ IntToStr(NHUF));



  Memo1.Lines.Add('HDRY = '+ FloatToStr(HDRY));
  Memo1.Lines.Add('STOR1 = '+ FloatToStr(STOR1));
  Memo1.Lines.Add('STOR2 = '+ FloatToStr(STOR2));
  Memo1.Lines.Add('STOR3 = '+ FloatToStr(STOR3));

  Memo1.Lines.Add('DMAX = '+ FloatToStr(DMAX));
  Memo1.Lines.Add('TOL = '+ FloatToStr(TOL));
  Memo1.Lines.Add('SOSC = '+ FloatToStr(SOSC));
  Memo1.Lines.Add('SOSR = '+ FloatToStr(SOSR));
  Memo1.Lines.Add('RMAR = '+ FloatToStr(RMAR));
  Memo1.Lines.Add('RMARM = '+ FloatToStr(RMARM));
  Memo1.Lines.Add('CSA = '+ FloatToStr(CSA));
  Memo1.Lines.Add('FCONV = '+ FloatToStr(FCONV));
  Memo1.Lines.Add('ADVSTP = '+ FloatToStr(ADVSTP));
  Memo1.Lines.Add('FSNK = '+ FloatToStr(FSNK));

  for Index := 0 to IUNITArraySize -1 do
  begin
    if IUNIT[Index] <> 0 then
    begin
      Memo1.Lines.Add('IUNIT[' + IntToStr(Index+1)
        + '] = '+ IntToStr(IUNIT[Index]));
    end;
  end;
  for Index := 0 to Min(LAYCBD_ArraySize, NLAY) -1 do
  begin
    Memo1.Lines.Add('LAYCBD[' + IntToStr(Index+1)
      + '] = '+ IntToStr(LAYCBD[Index]));
  end;
  for Index := 0 to Min(LAYCBD_ArraySize, NLAY) -1 do
  begin
    Memo1.Lines.Add('LBOTM[' + IntToStr(Index+1)
      + '] = '+ IntToStr(LBOTM[Index]));
  end;
  for Index := 0 to Min(NPER,MXPER) -1 do
  begin
    Memo1.Lines.Add('PERLEN[' + IntToStr(Index+1)
      + '] = '+ FloatToStr(PERLEN[Index]));
  end;
  for Index := 0 to Min(NPER,MXPER) -1 do
  begin
    Memo1.Lines.Add('NSTP[' + IntToStr(Index+1)
      + '] = '+ IntToStr(NSTP[Index]));
  end;
  for Index := 0 to Min(NPER,MXPER) -1 do
  begin
    Memo1.Lines.Add('TSMULT[' + IntToStr(Index+1)
      + '] = '+ FloatToStr(TSMULT[Index]));
  end;
  for Index := 0 to Min(NPER,MXPER) -1 do
  begin
    Memo1.Lines.Add('ISSFLG[' + IntToStr(Index+1)
      + '] = '+ IntToStr(ISSFLG[Index]));
  end;

  for Index := 0 to Min(NLAY,LAYCBD_ArraySize) -1 do
  begin
    Memo1.Lines.Add('LAYTYP[' + IntToStr(Index+1)
      + '] = '+ IntToStr(LAYTYP[Index]));
  end;
  for Index := 0 to Min(NLAY,LAYCBD_ArraySize) -1 do
  begin
    Memo1.Lines.Add('LAYAVG[' + IntToStr(Index+1)
      + '] = '+ IntToStr(LAYAVG[Index]));
  end;
  for Index := 0 to Min(NLAY,LAYCBD_ArraySize) -1 do
  begin
    Memo1.Lines.Add('CHANI[' + IntToStr(Index+1)
      + '] = '+ FloatToStr(CHANI[Index]));
  end;
  for Index := 0 to Min(NLAY,LAYCBD_ArraySize) -1 do
  begin
    Memo1.Lines.Add('LAYVKA[' + IntToStr(Index+1)
      + '] = '+ IntToStr(LAYVKA[Index]));
  end;
  for Index := 0 to Min(NLAY,LAYCBD_ArraySize) -1 do
  begin
    Memo1.Lines.Add('LAYWET[' + IntToStr(Index+1)
      + '] = '+ IntToStr(LAYWET[Index]));
  end;
  for Index := 1 to NCOL do
  begin
    I := Index;
    GetDELR(I, NCOL, Value);
    Memo1.Lines.Add('DELR[' + IntToStr(Index)
      + '] = '+ FloatToStr(Value));
  end;
  for Index := 1 to NROW do
  begin
    I := Index;
    GetDELC(I, NROW, Value);
    Memo1.Lines.Add('DELC[' + IntToStr(Index)
      + '] = '+ FloatToStr(Value));
  end;  }
{  NLAY_Plus_1 := NLAY + 1;
  

  for LayIndex := 1 to NLAY_Plus_1 do
  begin
    ILAY := LayIndex;
    for RowIndex := 1 to NROW do
    begin
      IROW := RowIndex;
      for ColIndex := 1 to NCOL do
      begin
        ICOL := ColIndex;
        GetBOTM(ICOL, IROW, ILAY, NCOL, NROW, NLAY_Plus_1, VALUE);
        Memo1.Lines.Add('BOTM[' + IntToStr(ColIndex)
          + ', ' +  IntToStr(RowIndex)
          + ', ' +  IntToStr(LayIndex)
          + '] = '+ FloatToStr(Value));
      end;
    end;
  end;   }
{  for LayIndex := 1 to NLAY do
  begin
    ILAY := LayIndex;
    Memo1.Lines.Add('IBOUND Layer ' + IntToStr(LayIndex));
    for RowIndex := 1 to NROW do
    begin
      IROW := RowIndex;
      AString := '';
      for ColIndex := 1 to NCOL do
      begin
        ICOL := ColIndex;
        GetIBOUND(ICOL, IROW, ILAY, NCOL, NROW, NLAY, IVALUE);
        AString := AString + IntToStr(IVALUE) + ' ';
{        Memo1.Lines.Add('IBOUND[' + IntToStr(ColIndex)
          + ', ' +  IntToStr(RowIndex)
          + ', ' +  IntToStr(LayIndex)
          + '] = '+ IntToStr(IVALUE)); }
{      end;
      Memo1.Lines.Add(AString);
    end;
  end;}
  GetIPSUM(IVALUE);
  ClusterIndex := 0;
  Memo1.Lines.Add('IPSUM = ' + IntToStr(IVALUE));
  for Index := 1 to IVALUE do
  begin
    I := Index;
    ParameterValue(I, Value);
    if PARTYP(Index) <> 'DRN' then continue;
    Memo1.Lines.Add(PARNAM(Index) + ', ' + PARTYP(Index)
       + ', ' + SingleToStr(Value));
    ParameterNames.Add(PARNAM(Index));
    GetInstanceCount(I, IVALUE);
    Memo1.Lines.Add('NUMINST = ' + IntToStr(IVALUE));
    NUMINST := IVALUE;
    GetInstanceStart(I, IVALUE);
    for InstanceIndex := 0 to NUMINST-1 do
    begin
      IIndex := IVALUE + InstanceIndex;
      Memo1.Lines.Add('InstanceName = ' + INAME(IIndex));
    end;


    {GetClusterRange(I, ISTART, ISTOP);
    for InstanceIndex := ISTART to ISTOP do
    begin
      ClusterIndex := InstanceIndex;
      IDummy := 1;
      GetIPCLST(IDummy, ClusterIndex, IVALUE);
      AString := IntToStr(IVALUE);
      IDummy := 2;
      GetIPCLST(IDummy, ClusterIndex, IVALUE);
      AString :=  AString + ', '+ IntToStr(IVALUE);
      IDummy := 3;
      GetIPCLST(IDummy, ClusterIndex, IVALUE);
      AString := AString + ', '+ IntToStr(IVALUE);
      IDummy := 4;
      GetIPCLST(IDummy, ClusterIndex, IVALUE);
      AString := AString + ', '+ IntToStr(IVALUE);
      ZoneCount := IValue;
      for ZoneIndex := 5 to ZoneCount do
      begin
        ZI := ZoneIndex;
        GetIPCLST(ZI, ClusterIndex, IVALUE);
        AString := AString + ', '+ IntToStr(IVALUE);
      end;
      Memo1.Lines.Add('Unit, Multiplier, Zones = ' + AString);
    end; }
    if PARTYP(Index) = 'DRN' then
    begin
      I := Index;
      GetClusterRange(I, ISTART, ISTOP);
      for CellListIndex := ISTART to ISTOP do
      begin
        CellIndex := CellListIndex;
        GetDrain(ILAY, IROW, ICOL, Elevation, Cond, CellIndex);
        Memo1.Lines.Add('Parameter Drain[' + IntToStr(Index) + '] = ' +
          IntToStr(ILAY) + ', ' +
          IntToStr(IROW) + ', ' +
          IntToStr(ICOL) + ', ' +
          SingleToStr(Elevation) + ', ' +
          SingleToStr(Cond));
      end;
    end;


  end;

  GetParameterCounts(NPEVT, NPGHB, NPDRN, NPHFB,
    NPRIV, NPSTR, NPWEL, NPRCH, InstanceCount);
  Memo1.Lines.Add('NPEVT = ' + IntToStr(NPEVT));
  Memo1.Lines.Add('NPGHB = ' + IntToStr(NPGHB));
  Memo1.Lines.Add('NPDRN = ' + IntToStr(NPDRN));
  Memo1.Lines.Add('NPHFB = ' + IntToStr(NPHFB));
  Memo1.Lines.Add('NPRIV = ' + IntToStr(NPRIV));
  Memo1.Lines.Add('NPSTR = ' + IntToStr(NPSTR));
  Memo1.Lines.Add('NPWEL = ' + IntToStr(NPWEL));
  Memo1.Lines.Add('NPRCH = ' + IntToStr(NPRCH));
  Memo1.Lines.Add('NDRAIN = ' + IntToStr(NDRAIN));
  Memo1.Lines.Add('InstanceCount = ' + IntToStr(InstanceCount));


  GetStressPeriodCounts(NNPWEL, NNPDRN, NNPRIV, NNPGHB, CurrentNameCount);
  Memo1.Lines.Add('NNPWEL = ' + IntToStr(NNPWEL));
  Memo1.Lines.Add('NNPDRN = ' + IntToStr(NNPDRN));
  Memo1.Lines.Add('NNPRIV = ' + IntToStr(NNPRIV));
  Memo1.Lines.Add('NNPGHB = ' + IntToStr(NNPGHB));
  Memo1.Lines.Add('CurrentNameCount = ' + IntToStr(CurrentNameCount));
  for Index := 1 to CurrentNameCount do
  begin
    I := Index;
    GetCurrentParamNameAndInstance(I, PARAM, INSTANCE);
    Memo1.Lines.Add('PARAM = ' + PARAM);
    Memo1.Lines.Add('INSTANCE = ' + INSTANCE);
//    GetCellLimits(I, ISTART, ISTOP);
      GetClusterRange(I, ISTART, ISTOP);
    Memo1.Lines.Add('ISTART, ISTOP = ' + IntToStr(ISTART) + ', ' + IntToStr(ISTOP));

    I := ParameterNames.IndexOf(PARAM)+ 1;
    if I > 0 then
    begin
//      I := Index;

      GetClusterRange(I, ISTART, ISTOP);
      if ISTART > 0 then
      begin
        for CellListIndex := ISTART to ISTOP do
        begin
          CellIndex := CellListIndex;
          if Pos('GHB',PARAM) > 0 then
          begin
            GetGHB(ILAY, IROW, ICOL, Elevation, Cond, CellIndex);
            Memo1.Lines.Add('Parameter GHB[' + IntToStr(Index) + '] = ' +
              IntToStr(ILAY) + ', ' +
              IntToStr(IROW) + ', ' +
              IntToStr(ICOL) + ', ' +
              SingleToStr(Elevation) + ', ' +
              SingleToStr(Cond));
          end
          else if Pos('DRN',PARAM) > 0 then
          begin
            GetDrain(ILAY, IROW, ICOL, Elevation, Cond, CellIndex);
            Memo1.Lines.Add('Parameter DRN[' + IntToStr(Index) + '] = ' +
              IntToStr(ILAY) + ', ' +
              IntToStr(IROW) + ', ' +
              IntToStr(ICOL) + ', ' +
              SingleToStr(Elevation) + ', ' +
              SingleToStr(Cond));
          end;
        end;
      end;

    end;
  end;

  for Index := 1 to InstanceCount do
  begin
    Memo1.Lines.Add('INAME[' + IntToStr(Index) + '] = ' + INAME(Index));
  end;
         
  {
  for Index := 1 to NDRAIN do
  begin
    I := Index;
    GetDrain(ILAY, IROW, ICOL, Elevation, Cond, I);
    Memo1.Lines.Add('Drain[' + IntToStr(Index) + '] = ' +
      IntToStr(ILAY) + ', ' +
      IntToStr(IROW) + ', ' +
      IntToStr(ICOL) + ', ' +
      SingleToStr(Elevation) + ', ' +
      SingleToStr(Cond));
  end;    }

  for Index := 1 to NWELLS do
  begin
    I := Index;
    GetWell(ILAY, IROW, ICOL, Q, I);
    Memo1.Lines.Add('WELL[' + IntToStr(Index) + '] = ' +
      IntToStr(ILAY) + ', ' +
      IntToStr(IROW) + ', ' +
      IntToStr(ICOL) + ', ' +
      SingleToStr(Q));
  end;
     {
  for Index := 1 to NRIVER do
  begin
    I := Index;
    GetRiver(ILAY, IROW, ICOL, Elevation, Cond, RBOT, I);
    Memo1.Lines.Add('RIVER[' + IntToStr(Index) + '] = ' +
      IntToStr(ILAY) + ', ' +
      IntToStr(IROW) + ', ' +
      IntToStr(ICOL) + ', ' +
      SingleToStr(Elevation) + ', ' +
      SingleToStr(Cond) + ', ' +
      SingleToStr(RBOT));
  end;

  for Index := 1 to NBOUND do
  begin
    I := Index;
    GetGHB(ILAY, IROW, ICOL, Elevation, Cond, I);
    Memo1.Lines.Add('GHB[' + IntToStr(Index) + '] = ' +
      IntToStr(ILAY) + ', ' +
      IntToStr(IROW) + ', ' +
      IntToStr(ICOL) + ', ' +
      SingleToStr(Elevation) + ', ' +
      SingleToStr(Cond));
  end;   }

  {
  if IUNIT[7] > 0 then
  begin
    // recharge
    if NPRCH = 0 then
    begin
      for RowIndex := 1 to NROW do
      begin
        IROW := RowIndex;
        for ColIndex := 1 to NCOL do
        begin
          ICOL := ColIndex;
          GetRECH(ICOL, IROW, NCOL, NROW, VALUE);
          Memo1.Lines.Add('RECH[' + IntToStr(ColIndex)
            + ', ' +  IntToStr(RowIndex)
            + '] = '+ FloatToStr(VALUE));
        end;
      end;
    end;
    if NRCHOP = 2 then
    begin
      for RowIndex := 1 to NROW do
      begin
        IROW := RowIndex;
        for ColIndex := 1 to NCOL do
        begin
          ICOL := ColIndex;
          GetIRCH(ICOL, IROW, NCOL, NROW, IVALUE);
          Memo1.Lines.Add('IRCH[' + IntToStr(ColIndex)
            + ', ' +  IntToStr(RowIndex)
            + '] = '+ IntToStr(IVALUE));
        end;
      end;
    end;

  end;

  if IUNIT[4] > 0 then
  begin
    // evt
    if NPEVT = 0 then
    begin
      for RowIndex := 1 to NROW do
      begin
        IROW := RowIndex;
        for ColIndex := 1 to NCOL do
        begin
          ICOL := ColIndex;
          GetEVTR(ICOL, IROW, NCOL, NROW, VALUE);
          Memo1.Lines.Add('EVTR[' + IntToStr(ColIndex)
            + ', ' +  IntToStr(RowIndex)
            + '] = '+ FloatToStr(VALUE));
        end;
      end;
    end;
    for RowIndex := 1 to NROW do
    begin
      IROW := RowIndex;
      for ColIndex := 1 to NCOL do
      begin
        ICOL := ColIndex;
        GetSURF(ICOL, IROW, NCOL, NROW, VALUE);
        Memo1.Lines.Add('SURF[' + IntToStr(ColIndex)
          + ', ' +  IntToStr(RowIndex)
          + '] = '+ FloatToStr(VALUE));
      end;
    end;
    for RowIndex := 1 to NROW do
    begin
      IROW := RowIndex;
      for ColIndex := 1 to NCOL do
      begin
        ICOL := ColIndex;
        GetEXDP(ICOL, IROW, NCOL, NROW, VALUE);
        Memo1.Lines.Add('EXDP[' + IntToStr(ColIndex)
          + ', ' +  IntToStr(RowIndex)
          + '] = '+ FloatToStr(VALUE));
      end;
    end;
    if NEVTOP = 2 then
    begin
      for RowIndex := 1 to NROW do
      begin
        IROW := RowIndex;
        for ColIndex := 1 to NCOL do
        begin
          ICOL := ColIndex;
          GetIEVT(ICOL, IROW, NCOL, NROW, IVALUE);
          Memo1.Lines.Add('IEVT[' + IntToStr(ColIndex)
            + ', ' +  IntToStr(RowIndex)
            + '] = '+ IntToStr(IVALUE));
        end;
      end;
    end;
  end;

  for LayIndex := 1 to NZONAR do
  begin
    ILAY := LayIndex;
    for RowIndex := 1 to NROW do
    begin
      IROW := RowIndex;
      for ColIndex := 1 to NCOL do
      begin
        ICOL := ColIndex;
        GetIZONE(ICOL, IROW, ILAY, NCOL, NROW, NZONAR, IVALUE);
        Memo1.Lines.Add('IZONE[' + IntToStr(ColIndex)
          + ', ' +  IntToStr(RowIndex)
          + ', ' +  IntToStr(LayIndex)
          + '] = '+ IntToStr(IVALUE));
      end;
    end;
  end;   }

{  for LayIndex := 1 to NMLTAR do
  begin
    ILAY := LayIndex;
    Memo1.Lines.Add('RMLT Layer ' + IntToStr(LayIndex));
    for RowIndex := 1 to NROW do
    begin
      IROW := RowIndex;
      AString := '';
      for ColIndex := 1 to NCOL do
      begin
        ICOL := ColIndex;
        GetRMLT(ICOL, IROW, ILAY, NCOL, NROW, NMLTAR, VALUE);
        AString := AString + SingleToStr(VALUE) + ' ';
      end;
      Memo1.Lines.Add(AString);
    end;
  end;    

  for Index := 1 to NMLTAR do
  begin
    Memo1.Lines.Add('MLTNAM[' + IntToStr(Index) + '] = ' + MLTNAM(Index));
  end;
{  for Index := 1 to NZONAR do
  begin
    Memo1.Lines.Add('ZONNAM[' + IntToStr(Index) + '] = ' + ZONNAM(Index));
  end;   }


  finally
    ParameterNames.Free;
  end;

end;

end.
