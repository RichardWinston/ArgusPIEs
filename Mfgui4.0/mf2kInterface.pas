unit mf2kInterface;

interface

uses Sysutils, Dialogs;

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
  TCharArray12 = array[0..11] of Char;
  TCharArray10 = array[0..9] of Char;
  TCharArray4 = array[0..3] of Char;
  TZoneArray = array[0..9] of longint;
  TString10 = string[10];

procedure ReadNewFHB_Flow(var LAYER, ROW, COLUMN, NBDTIM: longint); stdcall;

procedure ReadNewFHB_Head(var LAYER, ROW, COLUMN, NBDTIM: longint); stdcall;

procedure NewArrayInstance; stdcall;
procedure CopyParameters(var PackageIdentifier: integer); stdcall;

procedure ReadNewHufCluster(var ClusterIndex: longint;
  var Zones: TZoneArray); stdcall;

procedure ReadNewHufParameter(var Value: single; var NCLU: longint); stdcall;

procedure CreateNewHeadObs(var ObsName: TCharArray12; var LAYER, ROW, COLUMN,
  IREFSP: longint; var TOFFSET, ROFF, COFF, HOBS, STATISTIC: single;
  var STATFLAG, PLOTSYMBOL: longint); stdcall;

procedure ReadLayerProportion(var MLAY: longint; var PR: single); stdcall;
procedure ReadITT(var ITT: longint); stdcall;
procedure ReadHeadObsTime(var OBSNAM: TCharArray12; var IREFSP : longint;
  var TOFFSET, HOBS, STATh, STATdd: single; var STATFLAG, PLOTSYMBOL: longint);
  stdcall;

procedure CreateNewHfbParameter(var ParameterValue: single); stdcall;
procedure ReadCurrentHfbParameter(); stdcall;
procedure ReadNewHFB(var IsParam: boolean; var Layer, Row1, Col1, Row2,
  Col2: longint; var Hydchr: single); stdcall;

procedure GetHFB_ParamName(var AName: TString10; Length: integer);
  stdcall; external 'modflw2000.dll';

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
    IWDFLG, IWETIT, IHDWET, ISEN, NBDTIM, NETSOP,
    NETSEG, NCHDS, IITER, IADAMP, IOUTGMG, ISM, ISC: longint;
  var HDRY, STOR1, STOR2, STOR3, DMAX, TOL, SOSC, SOSR, RMAR, RMARM,
    CSA, FCONV, ADVSTP, FSNK, ACCL, HCLOSE, WSEED, RCLOSE, RELAX,
    DAMP, BCLOSE, WETFCT: single;
  var GMGRELAX: double;
  var IUNIT: TIUnitArray; var LAYCBD, LBOTM: TLAYCBD_Array;
  var PERLEN: TPERLEN_Array; var NSTP: TNSTEP_Array; var TSMULT: TPERLEN_Array;
  var ISSFLG: TNSTEP_Array; var LAYTYP, LAYAVG: TLAYCBD_Array;
  var CHANI: TCHANI_Array;
  var LAYVKA, LAYWET, LAYCON: TLAYCBD_Array);
  stdcall; external 'modflw2000.dll';

procedure ReadStressPeriod(var KPER, NCOL, NROW, NLAY, NWELLS, NDRAIN,
  NRIVER, NBOUND, NRCHOP, NEVTOP, NCHDS, ISEN, NETSOP, NETSEG: longint;
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

procedure GETAnInstance(var Value: TString11; Length: longint);
  stdcall; external 'modflw2000.dll';

procedure GETUNITNAME(var Value: TString11; Length: longint);
  stdcall; external 'modflw2000.dll';

procedure GETMULTNAME(var Value: TString11; Length: longint);
  stdcall; external 'modflw2000.dll';

procedure GETZONENAME(var Value: TString11; Length: longint);
  stdcall; external 'modflw2000.dll';

procedure GETPARAMNAME(var Value: TString11; Length: longint);
  stdcall; external 'modflw2000.dll';

procedure GETPARAMTYPE(var Value: TString5; Length: longint);
  stdcall; external 'modflw2000.dll';

procedure GetHGUNAME(var Layer: longint; var Value: TString11; Length: longint);
  stdcall; external 'modflw2000.dll';

procedure GetHGUHANI(var Layer: longint; var Value: single);
  stdcall; external 'modflw2000.dll';

procedure GetHGUVANI(var Layer: longint; var Value: single);
  stdcall; external 'modflw2000.dll';

procedure GetHufLaytype(var Layer, IValue: longint);
  stdcall; external 'modflw2000.dll';

procedure GetHufLaywet(var Layer, IValue: longint);
  stdcall; external 'modflw2000.dll';

procedure GetInstanceStart(var I: longint; var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetClusterRange(var I: longint; var ISTART, ISTOP: longint);
  stdcall; external 'modflw2000.dll';

procedure GetIPCLST(var Item, IParam: longint; var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetWell(var Layer, Row, Column : longint; var Q: single;
  var IIndex: longint);
  stdcall; external 'modflw2000.dll';

procedure GetRiver(var Layer, Row, Column: longint;
  var Elevation, Cond, RBOT: single; var IIndex: longint);
  stdcall; external 'modflw2000.dll';

procedure GetGHB(var Layer, Row, Column: longint; var Elevation, Cond: single;
  var IIndex: longint);
  stdcall; external 'modflw2000.dll';

procedure GetDrain(var Layer, Row, Column: longint; var Elevation, Cond: single;
  var IIndex: longint);
  stdcall; external 'modflw2000.dll';

procedure GetCHD(var Layer, Row, Column: longint; var SHEAD, EHEAD: single;
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

procedure GetIETS(var ICol, IRow, NCOL, NROW: longint;
  var IVALUE: longint);
  stdcall; external 'modflw2000.dll';

procedure GetETSR(var ICol, IRow, NCOL, NROW: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetETSX(var ICol, IRow, NCOL, NROW: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetETSS(var ICol, IRow, NCOL, NROW: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetPXDP(var ICol, IRow, ISeg, NCOL, NROW, NETSEG: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetPETM(var ICol, IRow, ISeg, NCOL, NROW, NETSEG: longint;
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

procedure GetHUFTOP(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
  var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetHUFTHK(var ICol, IRow, ILAY, NCOL, NROW, NLAY: longint;
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

procedure GetFhbBDTIM(var I, NBDTIM: longint; var VALUE: single);
  stdcall; external 'modflw2000.dll';

procedure GetFhbValue(var I: longint; var VALUE: single);
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
  NPRIV, NPSTR, NPWEL, NPRCH, NPETS, InstanceCount: longint);
  stdcall; external 'modflw2000.dll';

procedure GetStressPeriodCounts(var NNPWEL, NNPDRN, NNPRIV,
  NNPGHB, NNPCHD, CurrentNameCount: longint);
  stdcall; external 'modflw2000.dll';

implementation

uses ModflowImport, MF2K_Importer, Variables, DataGrid, import;

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

procedure NewArrayInstance; stdcall;
var
  ParamType: TString5;
  AType: string;
  ParamGrid: TDataGrid;
  ParamName: TString11;
  PName: string;
  Row: integer;
  InstanceName: TString11;
  Col: integer;
  Instance: string;
  Dummy: boolean;
  NewText: String;
begin
  ParamType := '     ';
  GETPARAMTYPE(ParamType, 5);
  AType := Trim(ParamType);
  if AType = 'RCH' then
  begin
    ParamGrid := frmModflow.dgRCHParametersN;
  end
  else if AType = 'EVT' then
  begin
    ParamGrid := frmModflow.dgEVTParametersN;
  end
  else if AType = 'ETS' then
  begin
    ParamGrid := frmModflow.dgETSParametersN;
  end
  else
  begin
    Exit;
  end;
  ParamName := '           ';
  GETPARAMNAME(ParamName, 11);
  PName := frmModflow.FixModflowName(Trim(ParamName));
  Row := ParamGrid.Cols[0].IndexOf(PName);
  Assert(Row > 0);

  InstanceName := '           ';
  GETAnInstance(InstanceName, 11);
  Instance := Trim(InstanceName);

  Col := frmModflowImport.CurrentStressPeriod + 4;
  if ParamGrid.Columns[Col].PickList.IndexOf(Instance) >= 0  then
  begin
    NewText := Instance;
  end
  else
  begin
    NewText := ParamGrid.Columns[Col].PickList[1];
  end;

  if Assigned(ParamGrid.OnSelectCell) then
  begin
    Dummy := True;
    ParamGrid.OnSelectCell(ParamGrid, Col, Row, Dummy);
  end;
  ParamGrid.Cells[Col, Row] := NewText;
  if Assigned(ParamGrid.OnSetEditText) then
  begin
    ParamGrid.OnSetEditText(ParamGrid, Col, Row, NewText);
  end;
end;

procedure CopyParameters(var PackageIdentifier: integer); stdcall;
var
  ParamGrid: TDataGrid;
  Col: integer;
  RowIndex: integer;
  Dummy: boolean;
  NewText: string;
begin
  ParamGrid := nil;
  case PackageIdentifier of
    1:
      begin
        ParamGrid := frmModflow.dgRCHParametersN;
      end;
    2:
      begin
        ParamGrid := frmModflow.dgEVTParametersN;
      end;
    3:
      begin
        ParamGrid := frmModflow.dgETSParametersN;
      end;
  else
    begin
      Assert(False);
    end;
  end;
  Col := frmModflowImport.CurrentStressPeriod + 4;
  for RowIndex := 1 to ParamGrid.RowCount -1 do
  begin
    if Assigned(ParamGrid.OnSelectCell) then
    begin
      Dummy := True;
      ParamGrid.OnSelectCell(ParamGrid, Col, RowIndex, Dummy);
    end;
    NewText := ParamGrid.Cells[Col-1,RowIndex];
    ParamGrid.Cells[Col, RowIndex] := NewText;
    if Assigned(ParamGrid.OnSetEditText) then
    begin
      ParamGrid.OnSetEditText(ParamGrid, Col, RowIndex, NewText);
    end;
  end;
end;

procedure ReadNewHufCluster(var ClusterIndex: longint;
  var Zones: TZoneArray); stdcall;
var
  UnitName, MultName, ZoneName: TString11;
  AGrid: TDataGrid;
  Dummy: boolean;
  NewText: string;
  ZoneIndex: integer;
  ReachedEnd: boolean;
begin
  UnitName := '           ';
  MultName := '           ';
  ZoneName := '           ';
  GETUNITNAME(UnitName, 11);
  GETMULTNAME(MultName, 11);
  GETZONENAME(ZoneName, 11);
  AGrid := frmModflow.dg3dHUFParameterClusters.Grids[frmModflow.
    dg3dHUFParameterClusters.PageCount -1];

  Dummy := True;
  frmModflow.dg3dLPFParameterClustersSelectCell(AGrid, 0, ClusterIndex, Dummy);
  NewText := Trim(UnitName);
  AGrid.Cells[0,ClusterIndex] := NewText;
  frmModflow.dg3dLPFParameterClustersSetEditText(AGrid, 0, ClusterIndex,
    NewText);

  Dummy := True;
  frmModflow.dg3dLPFParameterClustersSelectCell(AGrid, 1, ClusterIndex, Dummy);
  NewText := UpperCase(Trim(MultName));
  AGrid.Cells[1,ClusterIndex] := NewText;
  frmModflow.dg3dLPFParameterClustersSetEditText(AGrid, 1, ClusterIndex,
    NewText);

  Dummy := True;
  frmModflow.dg3dLPFParameterClustersSelectCell(AGrid, 2, ClusterIndex, Dummy);
  NewText := UpperCase(Trim(ZoneName));
  AGrid.Cells[2,ClusterIndex] := NewText;
  frmModflow.dg3dLPFParameterClustersSetEditText(AGrid, 2, ClusterIndex,
    NewText);

  ReachedEnd := (NewText = 'NONE') or (NewText = 'ALL');
  for ZoneIndex := 0 to 9 do
  begin
    if Zones[ZoneIndex] = 0 then
    begin
      ReachedEnd := True;
    end;
    Dummy := True;
    frmModflow.dg3dLPFParameterClustersSelectCell(AGrid, ZoneIndex+3,
      ClusterIndex, Dummy);
    if ReachedEnd then
    begin
      NewText := '';
    end
    else
    begin
      NewText := IntToStr(Zones[ZoneIndex]);
    end;
    AGrid.Cells[ZoneIndex+3,ClusterIndex] := NewText;
    frmModflow.dg3dLPFParameterClustersSetEditText(AGrid, ZoneIndex+3,
      ClusterIndex, NewText);
  end;
end;

procedure ReadNewHufParameter(var Value: single; var NCLU: longint); stdcall;
var
  ParamCount: integer;
  Dummy: boolean;
  NewText: string;
  ParamName: TString11;
  ParType: TString5;
  function ParamTypeToInt(ParamType: string): integer;
  begin
    result := -1;
    ParamType := Trim(UpperCase(ParamType));
    if ParamType = 'HK' then
    begin
      result := 0;
    end
    else if ParamType = 'HANI' then
    begin
      result := 1;
    end
    else if ParamType = 'VK' then
    begin
      result := 2;
    end
    else if ParamType = 'VANI' then
    begin
      result := 3;
    end
    else if ParamType = 'SS' then
    begin
      result := 4;
    end
    else if ParamType = 'SY' then
    begin
      result := 5;
    end
    else if ParamType = 'KDEP' then
    begin
      result := 6;
    end
    else if ParamType = 'SYTP' then
    begin
      result := 7;
    end
    else if ParamType = 'LVDA' then
    begin
      result := 8;
    end
    else
    begin
      Assert(False);
    end;
  end;
begin
  try
  frmModflow.adeHUFParamCount.HandleNeeded;
  frmMODFLOW.dgHUFParameters.HandleNeeded;
  ParamName := '           ';
  GetParamName(ParamName, 11);
  ParType := '     ';
  GETPARAMTYPE(ParType, 5);

  frmModflow.adeHUFParamCountEnter(nil);
  ParamCount := StrToInt(frmModflow.adeHUFParamCount.Text) + 1;
  frmModflow.adeHUFParamCount.Text := IntToStr(ParamCount);
  frmModflow.adeHUFParamCountExit(nil);
  frmMODFLOW.dgParametersEnter(frmMODFLOW.dgHUFParameters);

  Dummy := true;
  frmMODFLOW.dgParametersSelectCell(frmMODFLOW.dgHUFParameters, 0, ParamCount,
    Dummy);
  NewText := Trim(ParamName);
  frmMODFLOW.dgHUFParameters.Cells[0,ParamCount] := NewText;
  frmMODFLOW.dgParametersSetEditText(frmMODFLOW.dgHUFParameters, 0, ParamCount,
    NewText);

  Dummy := true;
  frmMODFLOW.dgParametersSelectCell(frmMODFLOW.dgHUFParameters, 1, ParamCount,
    Dummy);
  NewText := ParType;
  NewText := frmMODFLOW.dgHUFParameters.Columns[1].
    PickList[ParamTypeToInt(NewText)];
  frmMODFLOW.dgHUFParameters.Cells[1,ParamCount] := NewText;
  frmMODFLOW.dgParametersSetEditText(frmMODFLOW.dgHUFParameters, 1, ParamCount,
    NewText);

  Dummy := true;
  frmMODFLOW.dgParametersSelectCell(frmMODFLOW.dgHUFParameters, 2, ParamCount,
    Dummy);
  NewText := FloatToStr(Value);
  frmMODFLOW.dgHUFParameters.Cells[2,ParamCount] := NewText;
  frmMODFLOW.dgParametersSetEditText(frmMODFLOW.dgHUFParameters, 2, ParamCount,
    NewText);

  Dummy := true;
  frmMODFLOW.dgParametersSelectCell(frmMODFLOW.dgHUFParameters, 3, ParamCount,
    Dummy);
  NewText := IntToStr(NCLU);
  frmMODFLOW.dgHUFParameters.Cells[3,ParamCount] := NewText;
  frmMODFLOW.dgParametersSetEditText(frmMODFLOW.dgHUFParameters, 3, ParamCount,
    NewText);

  frmMODFLOW.dgExit(frmMODFLOW.dgHUFParameters);
  except on E: Exception do
    begin
      ShowMessage(E.message);
    end;
  end;
end;

procedure CreateNewHeadObs(var ObsName: TCharArray12; var LAYER, ROW, COLUMN,
  IREFSP: longint; var TOFFSET, ROFF, COFF, HOBS, STATISTIC: single;
  var STATFLAG, PLOTSYMBOL: longint); stdcall;
var
  HeadObs: THeadObservation;
begin
  Assert(frmModflowImport <> nil);
  HeadObs := frmModflowImport.CreateNewHeadObservation;
  HeadObs.OBSNAM := Trim(ObsName);
  HeadObs.LAYER := LAYER;
  HeadObs.ROW := ROW;
  HeadObs.COLUMN := COLUMN;
  HeadObs.IREFSP := IREFSP;
  HeadObs.TOFFSET := TOFFSET;
  HeadObs.ROFF := ROFF;
  HeadObs.COFF := COFF;
  HeadObs.HOBS := HOBS;
  HeadObs.STATISTIC := STATISTIC;
  HeadObs.STATFLAG := STATFLAG;
  HeadObs.PLOTSYMBOL := PLOTSYMBOL;
end;

procedure ReadLayerProportion(var MLAY: longint; var PR: single); stdcall;
var
  HeadObs: THeadObservation;
  MLayer: TMLayer;
begin
  Assert(frmModflowImport <> nil);
  HeadObs := frmModflowImport.CurrentHeadObservation;
  Assert(HeadObs <> nil);
  MLayer := TMLayer.Create;
  HeadObs.ProportionList.Add(MLayer);
  MLayer.Layer := MLAY;
  MLayer.Proportion := PR;
end;

procedure ReadITT(var ITT: longint); stdcall;
var
  HeadObs: THeadObservation;
begin
  Assert(frmModflowImport <> nil);
  HeadObs := frmModflowImport.CurrentHeadObservation;
  Assert(HeadObs <> nil);
  HeadObs.ITT := ITT;
end;

procedure ReadHeadObsTime(var OBSNAM: TCharArray12; var IREFSP : longint;
  var TOFFSET, HOBS, STATh, STATdd: single; var STATFLAG, PLOTSYMBOL: longint);
  stdcall;
var
  HeadObs: THeadObservation;
  ObsTime: THeadObservationTime;
begin
  Assert(frmModflowImport <> nil);
  HeadObs := frmModflowImport.CurrentHeadObservation;
  Assert(HeadObs <> nil);
  ObsTime := THeadObservationTime.Create;
  HeadObs.TimeList.Add(ObsTime);
  ObsTime.OBSNAM := Trim(OBSNAM);
  ObsTime.IREFSP := IREFSP;
  ObsTime.TOFFSET := TOFFSET;
  ObsTime.HOBS := HOBS;
  ObsTime.STATh := STATh;
  ObsTime.STATdd := STATdd;
  ObsTime.STATFLAG := STATFLAG;
  ObsTime.PLOTSYMBOL := PLOTSYMBOL;
end;

procedure ReadNewFHB_Flow(var LAYER, ROW, COLUMN, NBDTIM: longint); stdcall;
var
  Value: single;
  I: longint;
  Index: integer;
  Contour: TFHBContour;
  EditContours: TtypedEditContours;
begin
  EditContours := frmModflowImport.GetATypedEditContours(btMF2K_FHB, LAYER);
  Contour := TFHBContour.Create(EditContours);
  EditContours.ContourList.Add(Contour);

  Contour.Col := COLUMN;
  Contour.Row := Row;
  Contour.Layer := LAYER;
  SetLength(Contour.FlowValues, NBDTIM);

  for Index := 1 to NBDTIM do
  begin
    I := Index;
    GetFhbValue(I, Value);
    Contour.FlowValues[Index-1] := Value;
  end;
end;

procedure ReadNewFHB_Head(var LAYER, ROW, COLUMN, NBDTIM: longint); stdcall;
var
  Value: single;
  I: longint;
  Index: integer;
  Contour: TFHBContour;
  EditContours: TtypedEditContours;
begin
  EditContours := frmModflowImport.GetATypedEditContours(btMF2K_FHB, LAYER);
  Contour := TFHBContour.Create(EditContours);
  EditContours.ContourList.Add(Contour);

  Contour.Col := COLUMN;
  Contour.Row := Row;
  Contour.Layer := LAYER;
  SetLength(Contour.HeadValues, NBDTIM);

  for Index := 1 to NBDTIM do
  begin
    I := Index;
    GetFhbValue(I, Value);
    Contour.HeadValues[Index-1] := Value;
  end;
end;

procedure CreateNewHfbParameter(var ParameterValue: single); stdcall;
const
  Length = 10;
var
  AString: TString10;
  Count: Integer;
begin

  AString := '          ';
  GetHFB_ParamName(AString, Length);

  Count := StrToInt(frmModflow.adeHFBParamCount.Text);
  frmModflow.adeHFBParamCount.Text := IntToStr(Count + 1);
  frmModflow.adeHFBParamCountExit(frmModflow.adeHFBParamCount);

  frmModflow.dgHFBParameters.Cells[0,Count+1] := Trim(AString);
  frmModflow.dgHFBParameters.Cells[2,Count+1] := FloatToStr(ParameterValue);
end;

procedure ReadCurrentHfbParameter(); stdcall;
const
  Length = 10;
var
  AString: TString10;
begin
//  Length := 10;
  AString := '          ';
  GetHFB_ParamName(AString, Length);
  frmModflowImport.MF2K_HfbNamesList.Add(Trim(AString));
end;

procedure ReadNewHFB(var IsParam: boolean; var Layer, Row1, Col1, Row2,
  Col2: longint; var Hydchr: single); stdcall;
const
  Length = 10;
var
  AString: TString10;
//  Length: integer;
begin
  if IsParam then
  begin
//    Length := 10;
    AString := '          ';
    GetHFB_ParamName(AString, Length);
    frmModflowImport.StoreMF2K_HFBBoundary(Layer, Row1, Col1, Row2,
      Col2, Hydchr, AString);
  end
  else
  begin
    frmModflowImport.StoreMF2K_HFBBoundary(Layer, Row1, Col1, Row2,
      Col2, Hydchr, '');
  end;
end;

end.

