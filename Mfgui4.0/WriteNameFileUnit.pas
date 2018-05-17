unit WriteNameFileUnit;

interface

uses Windows, Sysutils, StdCtrls, ANEPIE, WriteModflowDiscretization, WriteUZF;

// Fortran unit assignments
//const
//  kGlobal  =  9; // Global listing file
//  kList    = 10; // MODFLOW Listing file
//  kBas     = 11; // Basic Package File
//  kOC      = 12; //Output Control File
//  KBCF     = 13; // BCF File or LPF File
//  kRCH     = 14; // Recharge File
//  kRIV     = 15; // River File
//  kWEL     = 16; // Well File
//  kDRN     = 17; // Drain File
//  kGHB     = 18; // GHB File
//  kEVT     = 19; // EVT File
//  kSIP     = 20; // SIP File
//  kSOR     = 21; // SOR File
//  kBHD     = 22; // binary head file
//  kFHD     = 23; // formatted head file
//  kBDN     = 24; // binary drawdown file
//  kFDN     = 25; // formatted drawdown file
//  kRIVbdg  = 27; // River budget file
//  kRCHbdg  = 28; // Recharge budget file
//  kWELbdg  = 29; // Well budget file
//  kDRNbdg  = 30; // Drain budget file
//  kEVTbdg  = 31; // EVT budget file
//  kGHBbdg  = 32; // GHB budget file
//  kbdg     = 33; // BCF or LPF or combined budget file
//  kPCG     = 34; // PCG File
//  kDE4     = 35; // DE4 File
//  kSTRbdg1 = 36; // Stream budget file 1
//  kSTRbdg2 = 37; // Stream budget file 2
//  kHFB     = 38; // HFB file
//  kFHBbdg  = 39; // FHB budget file
//  kFHB     = 40; // FHB file
//  kSTR     = 41; // Stream file
//  kInHead  = 42; // Initial head source file
//  kDis     = 43; // discretization file
//  kMult    = 44; //Multiplier array File
//  kZone    = 45; //Zone array File
//  kObs     = 46; // Observation file
//  kHob     = 47; // head Observation file
//  kGbob    = 48; // GHB Observation file
//  kDrob    = 49; // Drain Observation file
//  kRvob    = 50; // River Observation file
//  kChob    = 51; // Constant head Observation file
//  kSensBin = 52; // Sensitivity binary file;
//  kSenAscii = 53; // Sensitivity ASCII file;
//  kSen     = 54; // Sensitivity input file
//  kPes     = 55; // Sensitivity input file
//  kMOC3D   = 56; // MOC3D information file
//  kAdvIOUTTT2 = 57; // output unit number for particle tracking positions in Advection observations;
//  kAdvObs  = 58; // Advection observations files
//  kLakeBdg  = 59; // Lake budget files
//  kLake  = 60; // Lake input files
//  kIBS  = 61; // IBS file
//  kIBSBdg  = 62; // IBS budget file
//# 63 IBS subsidence files
//# 64 IBS compaction files
//# 65 IBS preconsolidation head files
//  kRES  = 66; // RES file
//  kRESBdg  = 67; // RES budget file
//  kTLK  = 68; // TLK input file
//  kTLKBdg  = 69; // TLK budget file
//# 70 MOC3D information file
//  kTLKInRestart  = 71; // TLK input restart record
//  kTLKOutRestart  = 72; // TLK output restart record

//  kIUHEAD = 73;
  {IUHEAD of sensitivity file. kIUHEAD must be greater than the unit number of
  all other files that are used.}

resourcestring
  rsNam = '.nam';
  rsGlobal = '.lsg';
  rsList = '.lst';
  rsBAS = '.bas';
  rsOC = '.oc';
  rsBCF = '.bcf';
  rsLPF = '.lpf';
  rsWEL = '.wel';
  rsRCH = '.rch';
  rsDRN = '.drn';
  rsRIV = '.riv';
  rsEVT = '.evt';
  rsGHB = '.ghb';
  rsHFB = '.hfb';
  rsFHB = '.fhb';
  rsSTR = '.str';
  rsSIP = '.sip';
  rsSOR = '.sor';
  rsPCG = '.pcg';
  rsDE4 = '.de4';
  rsMOC3D = '.gwt';
  rsFhd = '.fhd';
  rsBhd = '.bhd';
  rsFdn = '.fdn';
  rsBdn = '.bdn';
  rsBud = '.bud';
  rsBwe = '.bwe';
  rsBrc = '.brc';
  rsBdr = '.bdr';
  rsBri = '.bri';
  rsBev = '.bev';
  rsBgh = '.bgh';
  rsBfh = '.bfh';
  rsBsf1 = '.bsf1';
  rsBsf2 = '.bsf2';
  rsBst1 = '.bst1';
  rsBst2 = '.bst2';
  rsDis = '.dis';
  rsMult = '.mul';
  rsZone = '.zon';
  rsObs = '.obs';
  rsHob = '.ohd'; //'.hob';
  rsGbob = '.ogb'; //'.gbob';
  rsDrob = '.odr'; //'.drob';
  rsRvob = '.orv'; //'.rvob';
  rsChob = '.och'; //'.chob';
  rsSen = '.sen';
  rsSenb = '.seb';
  rsSena = '.sea';
  rsPes = '.pes';
  rsOad = '.oad'; // observations of advection;
  rsPart = '.prt'; // particle locations;
  rsLak = '.lak'; // lake package
  rsLakbdg = '.blk'; // lake package budget file
  rsRes = '.res'; // reservoir package
  rsResbdg = '.brs'; // reservoir package budget file
  rsTks = '.tks'; // Transient leakage package restart file.
  rsGage = '.gag'; // Gage input file
  rsGageOut = '.ggo'; // Gage input file
  rsOut = '.out'; // MOC3D output file
  rsMoc = '.moc'; // main MOC3D input file
  rsCrc = '.crc'; // Concentration of recharge
  rsCn2 = '.cn2';
  rsCna = '.cna';
  rsCnb = '.cnb';
  rsVla = '.vla';
  rsVlb = '.vlb';
  rsPta = '.pta';
  rsPtb = '.ptb';
  rsAge = '.age'; // MOC3D Age file
  rsDp = '.dp'; // MOC3D Double Porosity file
  rsDk = '.dk'; // MOC3D Simple Reactions file
  rsMObs = '.mob'; // MOC3D observation file
  rsOba = '.oba';
  rsSFR = '.sfr';
  rsStob = '.ost';
  rsETS = '.ets';
  rsBet = '.bet';
  rsDRT = '.drt';
  rsBdt = '.bdt';
  rsOdt = '.odt';
  rsLMG = '.lmg';
  rsIBS = '.ibs'; // Interbed storage package input
  rsISS = '.iss'; // Interbed storage package subsidence
  rsISC = '.isc'; // Interbed storage package compaction
  rsISH = '.ish'; // Interbed storage package preconsolidation head
  rsIBSB = '.ibsb'; // Interbed storage package budget file
  rsHYD = '.hyd'; // HYDMOD input;
  rsHYO = '.hyo'; // HYDMOD output;
  rsCHFB = '.chfb';
  rsCHD = '.chd';
  rsHUF = '.huf'; // HUF package input file.
  rsHHD = '.hhd'; // HUF formatted heads
  rsHBH = '.hbh'; // HUF binary heads
  rsBTN = '.btn'; // MT3D basic transport file
  rsADV = '.adv'; // MT3D advection package
  rsDSP = '.dsp'; // MT3D dispersion package
  rsRCT = '.rct'; // MT3D reaction package
  rsGCG = '.gcg'; // MT3D Generalized Conjugate Gradient Solver
  rsSSM = '.ssm'; // MT3D Source and Sink mixing package.
  rsMnm = '.mnm'; // MT3D Name file
  rsMLS = '.mls'; // MT3D List file
  rsTOB = '.tob'; // MT3D Transportation Observation file.
  rsLMT = '.lmt'; // input file for MT3D link in MODFLOW-2000
  rsFTL = '.ftl'; // Flow file for MT3D produced by MODFLOW-2000
  rsUCN = '.ucn'; // unformatted MT3D concentration file
  rsCNF = '.cnf'; // MT3D grid configuratin file.
  rsMTO = '.mto'; // MT3DMS observation file
  rsMAS = '.mass'; // MT3DMS mass budget summary
  rsMNW = '.mnw'; // Multi-Node well package
  rsMNW2 = '.mnw2'; // Multi-Node well package version 2
  rsMNWI = '.mnwi'; // Multi-Node well information package
  rsMNWIOut = '.mnwiOut'; // Multi-Node well information package output file
  rsMnwiWel = '.mnwiWel'; // Multi-Node well information package  Well File
  rsMnwiQSum = '.mnwiQsum'; // Multi-Node well information package
  rsMnwiQByNd = '.mnwiByNd'; // Multi-Node well information package
  rsWL1 = '.wl1'; // Well 1 style input file generated by MNW
  rsBYN = '.byn'; // BYNODE output file from MNW package
  rsQSU = '.qsu'; // QSUM output file from MNW package
  rsBMN = '.bmn'; // Budget file for Multi-Node Well package
  rsBMN2 = '.bmn2'; // Budget file for Multi-Node Well package
  rsDAF = '.daf'; // DAFLOW input file
  rsDAFG = '.dafg'; // DAFLOW link to groundwater file
  rsDAFF = '.daff'; // DAFLOW output file.
  rsDAB = '.dab'; // DAFLOW budget file.
  rsBFLX = '.bflx'; // BFLX package input file
  rsLVDA = '.lvda'; // LVDA input file for HUF package
  rsHFLW = '.hflw'; // interpolated HUF Flows
  rsKDEP = '.kdep'; // KDEP input file for HUF package
  rsSUB = '.sub'; // input file for SUB package
  rsSUBON = '.subo'; // binary output file for SUB package (An integer get appended to this.)
  rsSUBB = '.subb'; // budget file for SUB package
  rsSUBR = '.subr'; // SUB restart file
  rsVDF = '.vdf'; // Variable Density Flow input file (SEAWAT)
  rsGMG = '.gmg'; // Geometeric Multigrid package input file.
  rsGMGMHC = '.gmgmhc'; // Maximum head changed for Geometeric Multigrid package.
  rsIPDA = '.ipda'; // GWT IPDA file
  rsIPDL = '.ipdl'; // GWT IPDL file
  rsCBDY = '.cbdy'; // GWT CBDY file
  rsDECVAR = '.decvar'; // GWM Decision Variables (DECVAR) file.
  rsOBJFNC = '.objfnc'; // GWM Objective Functions (OBJFNC) file.
  rsVARCON = '.varcon'; // GWM Variable constraints (VARCON) file.
  rsSUMCON = '.sumcon'; // GWM Linear summation constrains (SUMCON) file.
  rsHEDCON = '.hedcon'; // GWM Head constraints file.
  rsSTRCON = '.strmcon'; // GWM stream constraints file.
  rsSTAVAR = '.stavar'; // GWM State Variables file.
  rsSOLN = '.soln'; // GWM Solution and Output control file.
  rsRSP = '.rsp'; // GWM Response matrix file.
  rsMSP = '.msp'; // GWM MSP file.
  rsGWM = '.gwm'; // GWM GWM file
  rsMNWO = '.mnwo'; // MNW observation file input.
  rsMNWO_Out = '.mnwo_out'; // MNW observation file output.
  rsPTOB = '.ptob'; //GWT Particle Observations file
  rsPTO = '.pto'; // Particle Observations output file
  rsMPTO = '.mpto'; // Multi-Node Well Particle Observations output file
  rsSSTR = '.sstr'; // GWT starting Stress Period File.
  rsPRTP = '.prtp'; // GWT PRTP file.
  rsGWMWFILE = '.GWMWFILE.wel'; // Well-package input file generated by GWM.
  rsUZF = '.uzf'; // input file for UZF package.
  rsUzfo = '.uzfo'; // output file for UZF package.
  rsISGOUT = '.isgout'; //output file for MNW concentrations in MT3DMS
  rsSWT = '.swt'; // SWT package input file.
  rsSWTOUT = '.swt_out'; // SWT package output file.
  rsSWTB = '.swtb'; // SWT package budget file.
  rsOCN = '.OCN'; // MT3DMS Concentration Observation output
  rsMFX = '.MFX'; // MT3DMS flux Observation output
  rsPST = '.PST'; // MT3DMS binary Observation output
  rsVSC = '.vsc'; // SEAWAT Viscosity package.
  rsMBRP = '.mbrp'; // GWT MBRP output file
  rsMBIT = '.mbit'; // GWT MBIT output file
  rsCCBD = '.ccbd'; // GWT CCBD input file
  rsVBAL = '.vbal'; // GWT CCBD input file

type
  TNameFileWriter = class(TModflowWriter)
  private
    procedure WriteMT3DInputFileNames(root: string; const IsSeaWat: boolean);
  public
    procedure WriteNameFile(root: string; UzfWriter: TUzfWriter);
    procedure WriteObservationFile(root: string);
    procedure WriteBFFile(root: string);
    function WriteBatchFile(CurrentModelHandle: ANE_PTR;
      UseCalibration: boolean; Root: string): string;
    procedure DeleteAFile(FileName: string);
    procedure WriteMOC3DNameFile(root: string; NumObs: integer);
    function WriteYcintBatchFile(CurrentModelHandle: ANE_PTR;
      UseCalibration: boolean; Root: string): string;
    function WriteBealeBatchFile(CurrentModelHandle: ANE_PTR;
      UseCalibration: boolean; Root: string): string;
    procedure WriteMT3DNameFile(root: string);
    function WriteMT3DBatchFile(CurrentModelHandle: ANE_PTR;
      UseCalibration: boolean; Root: string): string;
    procedure WriteGWM_NameFile(root: string);
  end;

function UseInitialHeads: boolean;
function ExportSensitivityBinaryfile: boolean;
function ExportSensitivityAsciifile: boolean;
function UseZones: boolean;
function UseMultipliers: boolean;
function UseObservations: boolean;
function UseIBS: boolean;
function UseSUB: boolean;
function UseHYD: boolean;
function ExportCHD: boolean;
function UseMt3dLinkInput: boolean;
function UseMNW: boolean;
function UseMNW2: boolean;
function UseMNWI: boolean;
function UseDaflow: boolean;
function UseBFLX: boolean;
function UseFHB: boolean;
function UseCHD: boolean;
function UseSFR: boolean;
function ExportVariableDensityFlow: boolean;
function UseIntegeratedMassTransport: boolean;
function UseGHBObservations: boolean;
function UseDrainObservations: boolean;
function UseDrainReturnObservations: boolean;
function UseRiverObservations: boolean;
function UseHeadFluxObservations: boolean;
function UseHeadObservations: boolean;
function UseAdvectionObservations: boolean;
function UseIPDA: boolean;
function UseIPDL: boolean;
function UseCBDY: boolean;
function UseGWM: boolean;
function UsePTOB: boolean;
function UseCCBD: boolean;
function UseVBAL: Boolean;
function UseSWT: boolean;
function UseViscosityPackage: boolean;
function ExportViscosity: boolean;

implementation

uses Variables, ModflowUnit, ProgressUnit, OptionsUnit, ANECB, UnitNumbers,
  WriteGageUnit, WriteModflowFilesUnit, WriteGwtParticleObservation,
  WriteSwtUnit;

function UseMt3dLinkInput: boolean;
begin
  result := frmModflow.cbMT3D.Checked and frmModflow.cbUseMT3D.Checked;
end;

function UseZones: boolean;
begin
  result := StrToInt(frmModflow.adeZoneCount.Text) > 0;
end;

function UseMultipliers: boolean;
begin
  result := StrToInt(frmModflow.adeMultCount.Text) > 0;
end;

function UseLPF: boolean;
begin
  result := frmModflow.rgFlowPackage.ItemIndex = 1;
end;

function UseHUF: boolean;
begin
  result := frmModflow.rgFlowPackage.ItemIndex = 2;
end;

function UseLVDA: boolean;
begin
  result := UseHUF and frmModflow.HufParameterUsed(hufLVDA)
end;

function UseKDEP: boolean;
begin
  result := UseHUF and frmModflow.HufParameterUsed(hufKDEP)
end;

function UseAge: boolean;
begin
  result := frmModflow.cbAge.Checked;
//    and (frmModflow.rgMOC3DSolver.ItemIndex <> 2);
end;

function UseDoublePorosity: boolean;
begin
  result := frmModflow.cbDualPorosity.Checked
    and (frmModflow.rgMOC3DSolver.ItemIndex <> 2);
end;

function UseSimpleReactions: boolean;
begin
  result := frmModflow.cbSimpleReactions.Checked
    and (frmModflow.rgMOC3DSolver.ItemIndex <> 2);
end;

function UseBCF: boolean;
begin
  result := frmModflow.rgFlowPackage.ItemIndex = 0;
end;

function UseRCH: boolean;
begin
  result := frmModflow.cbRCH.Checked
    and frmModflow.cbRCHRetain.Checked;
end;

function UseBFLX: boolean;
begin
  result := frmModflow.cbMOC3D.Checked and frmModflow.cbBFLX.Checked
end;

function UseIPDA: boolean;
begin
  result := frmModflow.cbMOC3D.Checked
    and frmModflow.WeightedParticlesUsed
    and (frmModflow.comboSpecifyParticles.ItemIndex = 1)
end;

function UseCBDY: boolean;
begin
  result := frmModflow.cbMOC3D.Checked
    and frmModflow.cbCBDY.Checked;
end;

function UsePTOB: boolean;
begin
  result := frmModflow.cbMOC3D.Checked
    and frmModflow.cbParticleObservations.Checked;
end;

function UseCCBD: boolean;
begin
  result := frmModflow.cbMOC3D.Checked
    and frmModflow.cbCCBD.Checked;
end;

function UseVBAL: Boolean;
begin
  result := frmModflow.cbMOC3D.Checked
    and frmModflow.cbVBAL.Checked;
end;

function UseIPDL: boolean;
begin
  result := frmModflow.cbMOC3D.Checked
    and frmModflow.WeightedParticlesUsed
    and (frmModflow.comboSpecifyParticles.ItemIndex = 2)
end;

function UseEVT: boolean;
begin
  result := frmModflow.cbEVT.Checked
    and frmModflow.cbEVTRetain.Checked;
end;

function UseETS: boolean;
begin
  result := frmModflow.cbETS.Checked
    and frmModflow.cbETSRetain.Checked;
end;

function UseRiv: boolean;
begin
  result := frmModflow.cbRIV.Checked
    and frmModflow.cbRIVRetain.Checked;
end;

function UseWEL: boolean;
begin
  result := frmModflow.cbWEL.Checked and frmModflow.cbWELRetain.Checked;
end;

function UseMNW: boolean;
begin
  result := frmModflow.cbMNW.Checked and frmModflow.cbMNW_Use.Checked;
end;

function UseMNW2: boolean;
begin
  result := frmModflow.cbMnw2.Checked and frmModflow.cbUseMnw2.Checked;
end;

function UseMNWI: boolean;
begin
  result := UseMNW2
    and frmModflow.cbMnwi.Checked and frmModflow.cbUseMnwi.Checked;
end;

function UseDaflow: boolean;
begin
  result := frmModflow.cbDAFLOW.Checked and frmModflow.cbUseDAFLOW.Checked;
end;

function ExportDaflowBudget: boolean;
begin
  result := UseDaflow and frmModflow.cbFlowDaflow.Checked
end;


function UseDRN: boolean;
begin
  result := frmModflow.cbDRN.Checked and frmModflow.cbDRNRetain.Checked;
end;

function UseDRT: boolean;
begin
  result := frmModflow.cbDRT.Checked and frmModflow.cbDRTRetain.Checked;
end;

function UseGHB: boolean;
begin
  result := frmModflow.cbGHB.Checked and frmModflow.cbGHBRetain.Checked;
end;

function UseHFB: boolean;
begin
  result := frmModflow.cbHFB.Checked and frmModflow.cbHFBRetain.Checked;
end;

function UseFHB: boolean;
begin
  result := frmModflow.cbFHB.Checked and frmModflow.cbFHBRetain.Checked;
end;

function UseLak: boolean;
begin
  result := frmModflow.cbLAK.Checked
    and frmModflow.cbLAKRetain.Checked;
end;

function UseReservoir: boolean;
begin
  result := frmModflow.cbRES.Checked
    and frmModflow.cbRESRetain.Checked;
end;

function UseSIP: boolean;
begin
  result := frmMODFLOW.rgSolMeth.ItemIndex = Ord(scSIP);
end;

function UseSOR: boolean;
begin
  result := frmMODFLOW.rgSolMeth.ItemIndex = Ord(scSOR);
end;

function UseDE4: boolean;
begin
  result := frmMODFLOW.rgSolMeth.ItemIndex = Ord(scDE4);
end;

function UsePCG2: boolean;
begin
  result := frmMODFLOW.rgSolMeth.ItemIndex = Ord(scPCG2);
end;

function UseLMG: boolean;
begin
  result := frmMODFLOW.rgSolMeth.ItemIndex = Ord(scLMG);
end;

function UseGMG: boolean;
begin
  result := frmMODFLOW.rgSolMeth.ItemIndex = Ord(scGMG);
end;

function UseGMG_MaxHeadChangeOutput: boolean;
begin
  result := UseGMG and frmModflow.cbGMG_IUNITMHC.Checked;
end;

function UseInitialHeads: boolean;
begin
  result := frmModflow.cbInitial.Checked
    and (frmModflow.comboBinaryInitialHeadChoice.ItemIndex = 0);
end;

function UseObservations: boolean;
begin
  result := frmMODFLOW.cbObservations.Checked;
end;

function ExportObservations: boolean;
begin
  result := UseObservations and frmMODFLOW.rbMODFLOW2000.Checked;
end;

function Use_SSTR: boolean;
var
  IPERGWT: integer;
begin
  IPERGWT := StrToInt(frmModflow.adeStartTransportStressPeriod.Text);
  result := IPERGWT > 1;
end;

function Use_PRTP: boolean;
begin
  result := frmModflow.cbAdjustParticleLocations.Enabled
    and frmModflow.cbAdjustParticleLocations.Checked;
end;

function UseHeadObservations: boolean;
var
  Index: integer;
  UseHeadObs, UseWeightedHeadObs: boolean;
begin
  result := UseObservations and (frmMODFLOW.cbHeadObservations.Checked
    or frmMODFLOW.cbWeightedHeadObservations.Checked);
  if result then
  begin
    UseHeadObs := False;
    if frmMODFLOW.cbHeadObservations.Checked then
    begin
      for Index := 0 to frmMODFLOW.clbObservationLayers.Items.Count -1 do
      begin
        if frmMODFLOW.clbObservationLayers.State[Index] = cbChecked then
        begin
          UseHeadObs := True;
          break;
        end;
      end;
    end;
    UseWeightedHeadObs := False;
    if frmMODFLOW.cbWeightedHeadObservations.Checked then
    begin
      for Index := 0 to frmMODFLOW.clbWeightedObservationLayers.Items.Count -1 do
      begin
        if frmMODFLOW.clbWeightedObservationLayers.State[Index] = cbChecked then
        begin
          UseWeightedHeadObs := True;
          break;
        end;
      end;
    end;
    result := UseHeadObs or UseWeightedHeadObs;
  end;
end;

function UseHeadFluxObservations: boolean;
var
  Index: integer;
begin
  result := UseObservations and frmMODFLOW.cbHeadFluxObservations.Checked;
  if result then
  begin
    result := False;
    for Index := 0 to frmMODFLOW.clbPrescribeHeadFlux.Items.Count -1 do
    begin
      if frmMODFLOW.clbPrescribeHeadFlux.State[Index] = cbChecked then
      begin
        result := True;
        break;
      end;
    end;
  end;
end;

function UseDrainObservations: boolean;
var
  Index: integer;
begin
  result := UseObservations and frmMODFLOW.cbDRNObservations.Checked and UseDRN;
  if result then
  begin
    result := False;
    for Index := 0 to frmMODFLOW.clbDrainObservations.Items.Count -1 do
    begin
      if frmMODFLOW.clbDrainObservations.State[Index] = cbChecked then
      begin
        result := True;
        break;
      end;
    end;
  end;
end;

function UseDrainReturnObservations: boolean;
var
  Index: integer;
begin
  result := UseObservations and frmMODFLOW.cbDRTObservations.Checked and UseDRT;
  if result then
  begin
    result := False;
    for Index := 0 to frmMODFLOW.clbDrainReturnObservations.Items.Count -1 do
    begin
      if frmMODFLOW.clbDrainReturnObservations.State[Index] = cbChecked then
      begin
        result := True;
        break;
      end;
    end;
  end;
end;

function UseGHBObservations: boolean;
var
  Index: integer;
begin
  result := UseObservations and frmMODFLOW.cbGHBObservations.Checked and UseGHB;
  if result then
  begin
    result := False;
    for Index := 0 to frmMODFLOW.clbGHB_Observations.Items.Count -1 do
    begin
      if frmMODFLOW.clbGHB_Observations.State[Index] = cbChecked then
      begin
        result := True;
        break;
      end;
    end;
  end;
end;

function UseRiverObservations: boolean;
var
  Index: integer;
begin
  result := UseObservations and frmMODFLOW.cbRIVObservations.Checked and UseRIV;
  if result then
  begin
    result := False;
    for Index := 0 to frmMODFLOW.clbRiverObservations.Items.Count -1 do
    begin
      if frmMODFLOW.clbRiverObservations.State[Index] = cbChecked then
      begin
        result := True;
        break;
      end;
    end;
  end;
end;

function UseAdvectionObservations: boolean;
//var
//  Index: integer;
//  StartPointsUsed, ObsUsed: boolean;
begin
  result := UseObservations and frmMODFLOW.cbAdvObs.Checked
    and frmMODFLOW.AdvectionObservationsDefined;
{  if result then
  begin
    ObsUsed := False;
    for Index := 0 to frmMODFLOW.clbAdvObs.Items.Count -1 do
    begin
      if frmMODFLOW.clbAdvObs.State[Index] = cbChecked then
      begin
        ObsUsed := True;
        break;
      end;
    end;
    StartPointsUsed := False;
    for Index := 0 to frmMODFLOW.clbAdvObsStartPoints.Items.Count -1 do
    begin
      if frmMODFLOW.clbAdvObsStartPoints.State[Index] = cbChecked then
      begin
        StartPointsUsed := True;
        break;
      end;
    end;
    result := ObsUsed and StartPointsUsed;
  end; }
end;

function UseMOC3D: boolean;
begin
  result := frmModflow.cbMOC3D.Checked and frmModflow.cbUseSolute.Checked;
end;

{function UseMNWO: boolean;
begin
  result := UseMNW and UseMOC3D
    and (frmModflow.comboMnwObservations.ItemIndex >= 1)
    and (frmModflow.MultiNodeWellNames.Count > 0);
end; }


function UseSensitivity: boolean;
begin
  result := frmModflow.cbSensitivity.Checked;
end;

function UseParameterEstimation: boolean;
begin
  result := frmModflow.cbParamEst.Checked
    and UseSensitivity and UseObservations;
end;

function UseVariableDensityFlow: boolean;
begin
  result := frmModflow.cbSeaWat.Checked
    and frmModflow.cbSW_VDF.Checked
    and frmModflow.rbMODFLOW2000.Checked;
end;

function ExportVariableDensityFlow: boolean;
begin
  result := UseVariableDensityFlow
    and frmModflow.cbExpVdf.Checked;
end;

function UseViscosityPackage: boolean;
begin
  result := frmModflow.cbSeaWat.Checked
    and frmModflow.cbSW_VDF.Checked
    and frmModflow.cbSeawatViscosity.Checked
    and frmModflow.rbMODFLOW2000.Checked;
end;

function ExportViscosity: boolean;
begin
  result := UseViscosityPackage
    and frmModflow.cbExpVsc.Checked;
end;

function UseIntegeratedMassTransport: boolean;
begin
  result := frmModflow.cbSeaWat.Checked
    and frmModflow.cbMT3D.Checked
    and frmModflow.rbMODFLOW2000.Checked
    and frmModflow.cbSW_MT3D.Checked;
end;

function ExportFormattedHeads: boolean;
begin
  result := frmModflow.comboExportHead.ItemIndex = 1;
end;

function ExportBinaryHeads: boolean;
begin
  result := frmModflow.comboExportHead.ItemIndex = 2;
end;

function ExportFormattedDrawdown: boolean;
begin
  result := frmModflow.comboExportDrawdown.ItemIndex = 1;
end;

function ExportBinaryDrawdown: boolean;
begin
  result := frmModflow.comboExportDrawdown.ItemIndex = 2;
end;

function ExportBCFBudget: boolean;
begin
  result := frmModflow.cbFlowBCF.Checked
    and UseBCF;
end;

function ExportLPFBudget: boolean;
begin
  result := frmModflow.cbFlowLPF.Checked
    and UseLPF;
end;

function ExportHUFBudget: boolean;
begin
  result := frmModflow.cbFlowHUF.Checked
    and UseHUF;
end;

function ExportMNWBudget: boolean;
begin
  result := UseMNW and frmModflow.cbFlowMNW.Checked
end;

function ExportMnw2Budget: boolean;
begin
  result := UseMNW2 and frmModflow.cbFlowMnw2.Checked
end;

function ExportWELBudget: boolean;
begin
  result := UseWEL and frmModflow.cbFlowWel.Checked
end;

function ExportRCHBudget: boolean;
begin
  result := UseRCH and frmModflow.cbFlowRCH.Checked
end;

function ExportDRNBudget: boolean;
begin
  result := UseDRN and frmModflow.cbFlowDrn.Checked
end;

function ExportDRTBudget: boolean;
begin
  result := UseDRT and frmModflow.cbFlowDrt.Checked
end;

function ExportRIVBudget: boolean;
begin
  result := UseRIV and frmModflow.cbFlowRiv.Checked
end;

function ExportEVTBudget: boolean;
begin
  result := UseEVT and frmModflow.cbFlowEvt.Checked
end;

function ExportETSBudget: boolean;
begin
  result := UseETS and frmModflow.cbFlowETS.Checked
end;

function ExportGHBBudget: boolean;
begin
  result := UseGHB and frmModflow.cbFlowGHB.Checked
end;

function UseSFR: boolean;
begin
  result := frmModflow.cbSFR.Checked
    and frmModflow.cbSFRRetain.Checked;
end;

function ExportSFRBudget1: boolean;
begin
  result := UseSFR and frmModflow.cbFlowSfr.Checked
end;

function ExportSFRBudget2: boolean;
begin
  result := UseSFR and frmModflow.cbFlowSfr2.Checked
end;

function ExportSTRBudget1: boolean;
begin
  result := StreamUsed and frmModflow.cbFlowSTR.Checked
end;

function ExportSTRBudget2: boolean;
begin
  result := StreamUsed and frmModflow.cbFlowSTR2.Checked
end;

function ExportLakeBudget: boolean;
begin
  result := UseLak and frmModflow.cbFlowLak.Checked
end;

function ExportReservoirBudget: boolean;
begin
  result := UseReservoir and frmModflow.cbFlowRES.Checked
end;

function ExportFHBBudget: boolean;
begin
  result := UseFHB and frmModflow.cbFlowFhb.Checked
end;

function ExportSensitivityBinaryfile: boolean;
begin
  result := UseSensitivity and frmModflow.cbSensBinary.Checked
    and not UseParameterEstimation;
end;

function ExportSensitivityAsciifile: boolean;
begin
  result := UseSensitivity and frmModflow.cbSensPrint.Checked
    and not UseParameterEstimation;
end;

function UseIBS: boolean;
begin
  result := frmMODFLOW.cbIBS.Checked and frmMODFLOW.cbUseIBS.Checked;
end;

function UseSUB: boolean;
begin
  result := frmMODFLOW.cbSUB.Checked and frmMODFLOW.cbUseSUB.Checked;
end;

function UseSWT: boolean;
begin
  result := frmMODFLOW.cbSWT.Checked and frmMODFLOW.cbUseSwt.Checked;
end;

function ExportIBSBudget: boolean;
begin
  result := UseIBS and frmModflow.cbFlowIBS.Checked
end;

function ExportSUBBudget: boolean;
begin
  result := UseSUB and frmModflow.cbFlowSUB.Checked
end;

function ExportSWTBudget: boolean;
begin
  result := UseSWT and frmModflow.cbFlowSWT.Checked
end;

function UseHYD: boolean;
begin
  result := frmMODFLOW.cbHYD.Checked and frmMODFLOW.cbHYDRetain.Checked;
end;

function UseCHD: boolean;
begin
  result := frmMODFLOW.cbCHD.Checked and frmMODFLOW.cbCHDRetain.Checked;
end;

function ExportCHD: boolean;
begin
  result := UseCHD and frmMODFLOW.cbExpCHD.Checked;
end;

function UseGWM: boolean;
begin
  result := (frmModflow.rbMODFLOW2000.Checked or frmModflow.rbMODFLOW2005.Checked)
    and frmModflow.cb_GWM.Checked
    and (frmModflow.rbRunGWM.Checked or frmModflow.rbCreateGWM.Checked);
end;

function ExportCombinedBudgetFile: boolean;
begin
  result := frmModflow.cbOneFlowFile.Checked and
    (ExportBCFBudget or
    ExportLPFBudget or
    ExportWELBudget or
    ExportRCHBudget or
    ExportDRNBudget or
    ExportRIVBudget or
    ExportEVTBudget or
    ExportGHBBudget or
    ExportSFRBudget1 or
    ExportFHBBudget or
    ExportDRTBudget or
    ExportETSBudget or
    ExportLakeBudget or
    ExportReservoirBudget or
    ExportSTRBudget1 or
    ExportIBSBudget or
    ExportDaflowBudget or
    ExportHUFBudget or
    ExportLakeBudget or
    ExportMNWBudget or
    ExportMnw2Budget or
    ExportSUBBudget);
end;

{ TNameFileWriter }

procedure TNameFileWriter.DeleteAFile(FileName: string);
begin
  FileName := GetCurrentDir + '\' + FileName;
  if FileExists(FileName) then
  begin
    DeleteFile(FileName);
  end;
end;

function TNameFileWriter.WriteYcintBatchFile(CurrentModelHandle: ANE_PTR;
  UseCalibration: boolean; Root: string): string;
var
  FileName: string;
  Path: string;
  ProjectOptions: TProjectOptions;
  GridLayerHandle: ANE_PTR;
  GridLayerName: string;
  Directory: ANE_STR;
  StringToEvaluate: string;
  STR: ANE_STR;
  NameFile: string;
begin
  FileName := GetCurrentDir + '\YCINT.BAT';
  result := FileName;
  AssignFile(FFile, FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      Path := frmMODFLOW.adeYcintPath.Text;
      NameFile := frmMODFLOW.adeFileName.Text + rsNam;

      Write(FFile, Path, ' ', NameFile);
      Writeln(FFile);
      if UseCalibration then
      begin
        GridLayerName := ModflowTypes.GetGridLayerType.WriteNewRoot;
        ProjectOptions := TProjectOptions.Create;
        try
          GridLayerHandle := ProjectOptions.GetLayerByName
            (CurrentModelHandle, GridLayerName);

          StringToEvaluate := 'GetMyDirectory()';

          GetMem(STR, Length(StringToEvaluate) + 1);
          try
            StrPCopy(STR, StringToEvaluate);
            ANE_EvaluateStringAtLayer(CurrentModelHandle, GridLayerHandle,
              kPIEString, STR, @Directory);
            ANE_ProcessEvents(CurrentModelHandle);
          finally
            FreeMem(STR);
          end;

          WriteLn(FFile, string(Directory), 'WaitForMe.exe');
          WriteLn(FFile, string(Directory), 'SelectChar.exe');

        finally
          ProjectOptions.Free;
        end;
      end
      else
      begin
        Writeln(FFile, 'Pause');
      end;

      Flush(FFile);

    end;
  finally
    CloseFile(FFile);
  end;
end;

function TNameFileWriter.WriteBealeBatchFile(CurrentModelHandle: ANE_PTR;
  UseCalibration: boolean; Root: string): string;
var
  FileName: string;
  Path: string;
  ProjectOptions: TProjectOptions;
  GridLayerHandle: ANE_PTR;
  GridLayerName: string;
  Directory: ANE_STR;
  StringToEvaluate: string;
  STR: ANE_STR;
  NameFile: string;
begin
  FileName := GetCurrentDir + '\BEALE.BAT';
  result := FileName;
  AssignFile(FFile, FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      Path := frmMODFLOW.adeBealePath.Text;
      NameFile := frmMODFLOW.adeFileName.Text + rsNam;

      Write(FFile, Path, ' ', NameFile);
      Writeln(FFile);
      if UseCalibration then
      begin
        GridLayerName := ModflowTypes.GetGridLayerType.WriteNewRoot;
        ProjectOptions := TProjectOptions.Create;
        try
          GridLayerHandle := ProjectOptions.GetLayerByName
            (CurrentModelHandle, GridLayerName);

          StringToEvaluate := 'GetMyDirectory()';

          GetMem(STR, Length(StringToEvaluate) + 1);
          try
            StrPCopy(STR, StringToEvaluate);
            ANE_EvaluateStringAtLayer(CurrentModelHandle, GridLayerHandle,
              kPIEString, STR, @Directory);
            ANE_ProcessEvents(CurrentModelHandle);
          finally
            FreeMem(STR);
          end;

          WriteLn(FFile, string(Directory), 'WaitForMe.exe');
          WriteLn(FFile, string(Directory), 'SelectChar.exe');

        finally
          ProjectOptions.Free;
        end;
      end
      else
      begin
        Writeln(FFile, 'Pause');
      end;

      Flush(FFile);

    end;
  finally
    CloseFile(FFile);
  end;
end;

function TNameFileWriter.WriteBatchFile(CurrentModelHandle: ANE_PTR;
  UseCalibration: boolean; Root: string): string;
var
  FileName: string;
  RunMOC3D: boolean;
  Path: string;
  ProjectOptions: TProjectOptions;
  GridLayerHandle: ANE_PTR;
  GridLayerName: string;
  Directory: ANE_STR;
  StringToEvaluate: string;
  STR: ANE_STR;
  RunSeaWat: boolean;
  RunGWM: boolean;
  RunMf2005: boolean;
begin

  RunMOC3D := frmModflow.cbUseSolute.Checked;
  RunSeaWat := frmModflow.rbCreateSeaWat.Checked
    or frmModflow.rbRunSeawat.Checked;
  RunGWM := frmModflow.rbRunGWM.Checked
    or frmModflow.rbCreateGWM.Checked;
  RunMf2005 := frmModflow.rbModflow2005.Checked;
  if RunGWM then
  begin
    FileName := GetCurrentDir + '\GWM.BAT';
  end
  else if RunSeaWat then
  begin
    FileName := GetCurrentDir + '\SEAWAT.BAT';
  end
  else if RunMOC3D then
  begin
    FileName := GetCurrentDir + '\MF2K_GWT.BAT';
  end
  else
  begin
    FileName := GetCurrentDir + '\MODFLOW.BAT';
  end;
  result := FileName;
  AssignFile(FFile, FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      if RunGWM then
      begin
        Path := frmMODFLOW.adeGWM.Text + ' ' + Root + rsNam;
      end
      else if RunSeaWat then
      begin
        Path := frmMODFLOW.adeSEAWAT.Text + ' ' + Root + rsNam;
      end
      else if RunMOC3D then
      begin
        Path := frmMODFLOW.adeMF2K_GWTPath.Text;
      end
      else if RunMf2005 then
      begin
        Path := frmMODFLOW.adeModflow2005.Text;
      end
      else
      begin
        Path := frmMODFLOW.adeModflow2000Path.Text;
      end;

      Write(FFile, Path);
      if RunMf2005 and not RunGWM then
      begin
        Writeln(FFile, ' ', Root, rsNam);
      end;

      if not RunMOC3D and not RunMf2005 then
      begin
        Write(FFile, ' /wait');
      end;
      Writeln(FFile);
      if not RunMOC3D and frmMODFLOW.cbParamEst.Checked
        and frmMODFLOW.cbResan.Checked then
      begin
        Writeln(FFile, frmMODFLOW.adeResanPath.Text, ' ', Root, rsNam);
      end;

      if UseCalibration then
      begin
        GridLayerName := ModflowTypes.GetGridLayerType.WriteNewRoot;
        ProjectOptions := TProjectOptions.Create;
        try
          GridLayerHandle := ProjectOptions.GetLayerByName
            (CurrentModelHandle, GridLayerName);

          StringToEvaluate := 'GetMyDirectory()';

          GetMem(STR, Length(StringToEvaluate) + 1);
          try
            StrPCopy(STR, StringToEvaluate);
            ANE_EvaluateStringAtLayer(CurrentModelHandle, GridLayerHandle,
              kPIEString, STR, @Directory);
            ANE_ProcessEvents(CurrentModelHandle);
          finally
            FreeMem(STR);
          end;

          WriteLn(FFile, string(Directory), 'WaitForMe.exe');
          WriteLn(FFile, string(Directory), 'SelectChar.exe');

        finally
          ProjectOptions.Free;
        end;
      end
      else
      begin
        if frmModflow.cbOpenOutputInNotepad.Checked then
        begin
          if frmModflow.rgMode.ItemIndex >= 4 then
          begin
            WriteLn(FFile, 'Start Notepad ', Root, rsGlobal);
          end;
          WriteLn(FFile, 'Start Notepad ', Root, rsList);
          if RunMOC3D then
          begin
            WriteLn(FFile, 'Start Notepad ', Root, rsOut);
          end;
        end;
        Writeln(FFile, 'Pause');
      end;

      Flush(FFile);

    end;
  finally
    CloseFile(FFile);
  end;
end;

procedure TNameFileWriter.WriteBFFile(root: string);
var
  FileName: string;
begin
  FileName := GetCurrentDir + '\modflow.bf';
  AssignFile(FFile, FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      WriteLn(FFile, Root + rsNam);
      Flush(FFile);
    end;
  finally
    CloseFile(FFile);
  end;
end;

procedure TNameFileWriter.WriteMOC3DNameFile(root: string; NumObs: integer);
var
  FileName: string;
  //  Index : integer;
  MocName: string;
  FileIndex: integer;
  FirstUnit: integer;
begin
  FileName := GetCurrentDir + '\' + Root + rsMOC3D;
  AssignFile(FFile, FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      WriteLn(FFile, 'CLST ', frmModflow.GetUnitNumber('CLST'), ' ', Root,
        rsOut);

      MocName := 'MOC ';
      case frmModflow.rgMOC3DSolver.ItemIndex of
        0:
          begin
            MocName := 'MOC ';
          end;
        1:
          begin
            MocName := 'MOCIMP ';
          end;
        2:
          begin
            MocName := 'ELLAM ';
          end;
        3:
          begin
            MocName := 'MOCWT ';
          end;
        4:
          begin
            MocName := 'MOCWTI ';
          end;
      else
        Assert(False);
      end;
      WriteLn(FFile, MocName, frmModflow.GetUnitNumber('MOC'), ' ', Root,
        rsMoc);
      if UseBFLX then
      begin
        WriteLn(FFile, 'BFLX ', frmModflow.GetUnitNumber('BFLX'), ' ', Root,
          rsBFLX);
      end;
      if UseIPDA then
      begin
        WriteLn(FFile, 'IPDA ', frmModflow.GetUnitNumber('IPDA'), ' ', Root,
          rsIPDA);
      end;
      if UseIPDL then
      begin
        WriteLn(FFile, 'IPDL ', frmModflow.GetUnitNumber('IPDL'), ' ', Root,
          rsIPDL);
      end;
      if UseCBDY then
      begin
        WriteLn(FFile, 'CBDY ', frmModflow.GetUnitNumber('CBDY'), ' ', Root,
          rsCBDY);
      end;
      if Use_SSTR then
      begin
        WriteLn(FFile, 'SSTR ', frmModflow.GetUnitNumber('SSTR'), ' ', Root,
          rsSSTR);
      end;
      if Use_PRTP then
      begin
        WriteLn(FFile, 'PRTP ', frmModflow.GetUnitNumber('PRTP'), ' ', Root,
          rsPRTP);
      end;



      if UsePTOB then
      begin
        WriteLn(FFile, 'PTOB ', frmModflow.GetUnitNumber('PTOB'), ' ', Root,
          rsPTOB);
        if ParticleObservationLocationsCount > 0 then
        begin
          FirstUnit := frmModflow.GetNUnitNumbers(kGWT_ParticleObsLocations,
            ParticleObservationLocationsCount);
          for FileIndex := 0 to ParticleObservationLocationsCount-1 do
          begin
            Writeln(FFile, 'DATA ', FirstUnit + FileIndex, ' ',
              Root, FileIndex+1, rsPTO);
          end;
        end;
        if MnwParticleObservationsCount > 0 then
        begin
          FirstUnit := frmModflow.GetNUnitNumbers(KGWT_MnwObsWells,
            MnwParticleObservationsCount);
          for FileIndex := 0 to MnwParticleObservationsCount-1 do
          begin
            Writeln(FFile, 'DATA ', FirstUnit + FileIndex, ' ',
              Root, FileIndex+1, rsMPTO);
          end;
        end;
      end;

      if frmModflow.cbMBRP.Enabled and frmModflow.cbMBRP.Checked then
      begin
        WriteLn(FFile, 'MBRP ', frmModflow.GetUnitNumber('MBRP'), ' ', Root,
          rsMBRP);
      end;

      if frmModflow.cbMBIT.Enabled and frmModflow.cbMBIT.Checked then
      begin
        WriteLn(FFile, 'MBIT ', frmModflow.GetUnitNumber('MBIT'), ' ', Root,
          rsMBIT);
      end;

      if frmModflow.cbCCBD.Enabled and frmModflow.cbCCBD.Checked then
      begin
        WriteLn(FFile, 'CCBD ', frmModflow.GetUnitNumber('CCBD'), ' ', Root,
          rsCCBD);
      end;

      if frmModflow.cbVBAL.Enabled and frmModflow.cbVBAL.Checked then
      begin
        WriteLn(FFile, 'VBAL ', frmModflow.GetUnitNumber('VBAL'), ' ', Root,
          rsVBAL);
      end;

      if UseRCH then
      begin
        WriteLn(FFile, 'CRCH ', frmModflow.GetUnitNumber('CRCH'), ' ', Root,
          rsCrc);
      end;
      case frmModflow.comboMOC3DConcFileType.ItemIndex of
        0:
          begin
          end;
        1:
          begin
            if frmModflow.rgMOC3DConcFormat.ItemIndex > 0 then
            begin
              WriteLn(FFile, 'CNCA ', frmModflow.GetUnitNumber('CNCA'), ' ',
                Root, rsCn2);
            end
            else
            begin
              WriteLn(FFile, 'CNCA ', frmModflow.GetUnitNumber('CNCA'), ' ',
                Root, rsCna);
            end;
          end;
        2:
          begin
            WriteLn(FFile, 'CNCB ', frmModflow.GetUnitNumber('CNCB'), ' ', Root,
              rsCnb);
          end;
        3:
          begin
            if frmModflow.rgMOC3DConcFormat.ItemIndex > 0 then
            begin
              WriteLn(FFile, 'CNCA ', frmModflow.GetUnitNumber('CNCA'), ' ',
                Root, rsCn2);
            end
            else
            begin
              WriteLn(FFile, 'CNCA ', frmModflow.GetUnitNumber('CNCA'), ' ',
                Root, rsCna);
            end;
            WriteLn(FFile, 'CNCB ', frmModflow.GetUnitNumber('CNCB'), ' ', Root,
              rsCnb);
          end;
      else
        Assert(False);
      end;
      case frmModflow.comboMOC3DVelFileType.ItemIndex of
        0:
          begin
          end;
        1:
          begin
            WriteLn(FFile, 'VELA ', frmModflow.GetUnitNumber('VELA'), ' ', Root,
              rsVla);
          end;
        2:
          begin
            WriteLn(FFile, 'VELB ', frmModflow.GetUnitNumber('VELB'), ' ', Root,
              rsVlb);
          end;
        3:
          begin
            WriteLn(FFile, 'VELA ', frmModflow.GetUnitNumber('VELA'), ' ', Root,
              rsVla);
            WriteLn(FFile, 'VELB ', frmModflow.GetUnitNumber('VELB'), ' ', Root,
              rsVlb);
          end;
      else
        Assert(False);
      end;
      if frmModflow.rgMOC3DSolver.ItemIndex <> 2 then
      begin
        case frmModflow.comboMOC3DPartFileType.ItemIndex of
          0:
            begin
            end;
          1:
            begin
              WriteLn(FFile, 'PRTA ', frmModflow.GetUnitNumber('PRTA'), ' ',
                Root, rsPta);
            end;
          2:
            begin
              WriteLn(FFile, 'PRTB ', frmModflow.GetUnitNumber('PRTB'), ' ',
                Root, rsPtb);
            end;
          3:
            begin
              WriteLn(FFile, 'PRTA ', frmModflow.GetUnitNumber('PRTA'), ' ',
                Root, rsPta);
              WriteLn(FFile, 'PRTB ', frmModflow.GetUnitNumber('PRTB'), ' ',
                Root, rsPtb);
            end;
        else
          Assert(False);
        end;
      end;
      if UseAge then
      begin
        WriteLn(FFile, 'AGE ', frmModflow.GetUnitNumber('AGE'), ' ', Root,
          rsAge);
      end;
      if UseDoublePorosity then
      begin
        WriteLn(FFile, 'DP ', frmModflow.GetUnitNumber('DP'), ' ', Root, rsDp);
      end;
      if UseSimpleReactions then
      begin
        WriteLn(FFile, 'DK ', frmModflow.GetUnitNumber('DK'), ' ', Root, rsDk);
      end;
      if UseHFB then
      begin
        WriteLn(FFile, 'CHFB ', frmModflow.GetUnitNumber('CHFB'), ' ', Root,
          rsCHFB);
      end;

      {if UseMNWO then
      begin
        WriteLn(FFile, 'MNWO ', frmModflow.GetUnitNumber('MNWO'), ' ', Root,
          rsMNWO);
        FirstUnit := frmModflow.GetNUnitNumbers(rsMNWO_Out,
          frmModflow.MultiNodeWellNames.Count);
        for FileIndex := 0 to frmModflow.MultiNodeWellNames.Count-1 do
        begin
          WriteLn(FFile, 'DATA ', FileIndex+FirstUnit, ' ',
            Root + '_' + frmModflow.MultiNodeWellNames[FileIndex], rsMNWO_Out);
        end;
      end; }

      if NumObs > 0 then
      begin
        WriteLn(FFile, 'OBS ', frmModflow.GetUnitNumber('GWT_OBS'), ' ', Root,
          rsMObs);
        if frmModflow.comboMOC3DSaveWell.ItemIndex > 0 then
        begin
          WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('OBA'), ' ', Root,
            rsOba);
        end
        else
        begin
          for FileIndex := 1 to NumObs do
          begin
            WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('OBA' +
              IntToStr(FileIndex)), ' ', Root, FileIndex, rsOba);
          end;

        end;
      end;

    end;
  finally
    CloseFile(FFile);
  end;
end;

procedure TNameFileWriter.WriteNameFile(Root: string; UzfWriter: TUzfWriter);
var
  FileName {, AFileName}: string;
  Index: integer;
  InitialHeadFileName: string;
  ErrorMessage: string;
  DAFGUnitNumber: integer;
  SUB_FileName: string;
  SwtOutputUnits: array [1..13] of integer;
//  IUHOBSV: Integer;
//  AString: string;
begin
  FileName := GetCurrentDir + '\' + Root + rsNam;
  AssignFile(FFile, FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      if ((frmModflow.rgMode.ItemIndex >= 4) or UseGWM)
        and (frmModflow.rbMODFLOW2000.Checked) then
      begin
        WriteLn(FFile, 'GLOBAL ', frmModflow.GetUnitNumber('GLOBAL'), ' ', Root,
          rsGlobal);
      end;
      WriteLn(FFile, 'LIST ', frmModflow.GetUnitNumber('LIST'), ' ', Root,
        rsList);
      WriteLn(FFile, 'DIS ', frmModflow.GetUnitNumber('DIS'), ' ', Root, rsDis);
      WriteLn(FFile, 'BAS6 ', frmModflow.GetUnitNumber('BAS6'), ' ', Root,
        rsBAS);
      WriteLn(FFile, 'OC ', frmModflow.GetUnitNumber('OC'), ' ', Root, rsOC);

      if UseMultipliers then
      begin
        WriteLn(FFile, 'MULT ', frmModflow.GetUnitNumber('MULT'), ' ', Root,
          rsMult);
      end;

      if UseZones then
      begin
        WriteLn(FFile, 'ZONE ', frmModflow.GetUnitNumber('ZONE'), ' ', Root,
          rsZone);
      end;

      if UseBCF then
      begin
        WriteLn(FFile, 'BCF6 ', frmModflow.GetUnitNumber('BCF6'), ' ', Root,
          rsBCF);
      end;

      if UseLPF then
      begin
        WriteLn(FFile, 'LPF ', frmModflow.GetUnitNumber('LPF'), ' ', Root,
          rsLPF);
      end;

      if UseHUF then
      begin
        WriteLn(FFile, 'HUF2 ', frmModflow.GetUnitNumber('HUF'), ' ', Root,
          rsHUF);
          if frmModflow.cbSaveHufHeads.Checked then
          begin
            case frmModflow.comboExportHead.ItemIndex of
              1:
                begin
                  WriteLn(FFile, 'DATA ',
                    frmModflow.GetUnitNumber('HHD'), ' ', Root, rsHHD);
                end;
              0,2:
                begin
                  WriteLn(FFile, 'DATA(BINARY) ',
                    frmModflow.GetUnitNumber('HBH'), ' ', Root, rsHBH);
                end;
            else Assert(False);
            end;
          end;

        {if frmModflow.comboExportHead.ItemIndex = 1 then
        begin
        end
        else
        begin
          AString := 'Warning: HUF heads will not be saved.  '
            + 'You must save formatted heads to save HUF heads.';
          frmProgress.reErrors.Lines.Add(AString);
          ErrorMessages.Add('');
          ErrorMessages.Add(AString);
        end;  }
      end;

      if UseLVDA then
      begin
        WriteLn(FFile, 'LVDA ', frmModflow.GetUnitNumber('LVDA'), ' ', Root,
          rsLVDA);
      end;

      if UseKDEP then
      begin
        WriteLn(FFile, 'KDEP ', frmModflow.GetUnitNumber('KDEP'), ' ', Root,
          rsKDEP);
      end;

      if UseHuf and frmModflow.cbSaveHufFlows.Checked then
      begin
        WriteLn(FFile, 'DATA(Binary) ', frmModflow.GetUnitNumber('HFLW'), ' ', Root,
          rsHFLW);
      end;

      if UseInitialHeads then
      begin
        WriteLn(FFile, 'DATA(BINARY) ',
          frmModflow.GetUnitNumber('InitialHeads'),
          ' ', frmModflow.edInitial.Text, ' OLD');
        InitialHeadFileName := GetCurrentDir + '\' + frmModflow.edInitial.Text;
        if not FileExists(InitialHeadFileName) then
        begin
          ErrorMessage := 'Error: the file "' + InitialHeadFileName
            + '", the file used for specifying initial heads, does not exist.';
          frmProgress.reErrors.Lines.Add(ErrorMessage);
          ErrorMessages.Add('');
          ErrorMessages.Add(ErrorMessage);
        end;
      end;

      if UseWEL then
      begin
        WriteLn(FFile, 'WEL ', frmModflow.GetUnitNumber('WEL'), ' ', Root,
          rsWEL);
      end;

      if UseRCH then
      begin
        WriteLn(FFile, 'RCH ', frmModflow.GetUnitNumber('RCH'), ' ', Root,
          rsRCH);
      end;

      if UseDRN then
      begin
        WriteLn(FFile, 'DRN ', frmModflow.GetUnitNumber('DRN'), ' ', Root,
          rsDRN);
      end;

      if UseDRT then
      begin
        WriteLn(FFile, 'DRT ', frmModflow.GetUnitNumber('DRT'), ' ', Root,
          rsDRT);
      end;

      if UseRIV then
      begin
        WriteLn(FFile, 'RIV ', frmModflow.GetUnitNumber('RIV'), ' ', Root,
          rsRIV);
      end;

      if UseEVT then
      begin
        WriteLn(FFile, 'EVT ', frmModflow.GetUnitNumber('EVT'), ' ', Root,
          rsEVT);
      end;

      if UseETS then
      begin
        WriteLn(FFile, 'ETS ', frmModflow.GetUnitNumber('ETS'), ' ', Root,
          rsETS);
      end;

      if UseGHB then
      begin
        WriteLn(FFile, 'GHB ', frmModflow.GetUnitNumber('GHB'), ' ', Root,
          rsGHB);
      end;

      if UseHFB then
      begin
        WriteLn(FFile, 'HFB6 ', frmModflow.GetUnitNumber('HFB6'), ' ', Root,
          rsHFB);
      end;

      if UseFHB then
      begin
        WriteLn(FFile, 'FHB ', frmModflow.GetUnitNumber('FHB'), ' ', Root,
          rsFHB);
      end;

      if UseSFR then
      begin
        WriteLn(FFile, 'SFR ', frmModflow.GetUnitNumber('SFR'), ' ', Root,
          rsSFR);
        {        if frmModflow.cbFlowSTR2.Checked then
                begin
                  WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('BS2Unit'), ' ', Root, rsBs2);
                end;   }

      end;

      if StreamUsed then
      begin
        WriteLn(FFile, 'STR ', frmModflow.GetUnitNumber('STR'), ' ', Root,
          rsSTR);

      end;
      if UseLak then
      begin
        WriteLn(FFile, 'LAK ', frmModflow.GetUnitNumber('LAK'), ' ', Root,
          rsLak);
      end;

      if UseReservoir then
      begin
        WriteLn(FFile, 'RES ', frmModflow.GetUnitNumber('RES'), ' ', Root,
          rsRes);
      end;

      if (StreamGageList.Count > 0) or (LakeGageList.Count > 0) then
      begin
        WriteLn(FFile, 'GAGE ', frmModflow.GetUnitNumber('GAGE'), ' ', Root,
          rsGage);
        for Index := 0 to StreamGageList.Count - 1 do
        begin
          WriteLn(FFile, 'DATA ', StreamUnitNumberList[Index], ' ', Root, Index+1,
            rsGageOut);
        end;
        for Index := 0 to LakeGageList.Count - 1 do
        begin
          WriteLn(FFile, 'DATA ', LakeUnitNumberList[Index], ' ', Root,
            Index+StreamGageList.Count+1, rsGageOut);
        end;
      end;

      if UseSIP then
      begin
        WriteLn(FFile, 'SIP ', frmModflow.GetUnitNumber('SIP'), ' ', Root,
          rsSIP);
      end;

      if UseSOR then
      begin
        WriteLn(FFile, 'SOR ', frmModflow.GetUnitNumber('SOR'), ' ', Root,
          rsSOR);
      end;

      if UsePCG2 then
      begin
        WriteLn(FFile, 'PCG ', frmModflow.GetUnitNumber('PCG'), ' ', Root,
          rsPCG);
      end;

      if UseDE4 then
      begin
        WriteLn(FFile, 'DE4 ', frmModflow.GetUnitNumber('DE4'), ' ', Root,
          rsDE4);
      end;

      if UseLMG then
      begin
        WriteLn(FFile, 'LMG ', frmModflow.GetUnitNumber('LMG'), ' ', Root,
          rsLMG);
      end;

      if UseGMG then
      begin
        WriteLn(FFile, 'GMG ', frmModflow.GetUnitNumber('GMG'), ' ', Root,
          rsGMG);
        if UseGMG_MaxHeadChangeOutput then
        begin
        WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('GMGMHC'), ' ', Root,
          rsGMGMHC);
        end;
      end;

      if UseHYD then
      begin
        WriteLn(FFile, 'HYD ', frmModflow.GetUnitNumber('HYD'), ' ', Root,
          rsHYD);
        WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('IHYDUN'), ' ',
          Root, rsHYO, ' REPLACE');
        DeleteAFile(Root + rsHYO);
      end;

      if UseIBS then
      begin
        WriteLn(FFile, 'IBS ', frmModflow.GetUnitNumber('IBS'), ' ', Root,
          rsIBS);
        WriteLn(FFile, 'DATA(BINARY) ',
          frmModflow.GetUnitNumber('IBSSubsidenceUnit'), ' ', Root, rsISS, ' REPLACE');
        WriteLn(FFile, 'DATA(BINARY) ',
          frmModflow.GetUnitNumber('IBSCompactionUnit'), ' ', Root, rsISC, ' REPLACE');
        WriteLn(FFile, 'DATA(BINARY) ',
          frmModflow.GetUnitNumber('IBSPreconsolidationHeadUnit'), ' ', Root,
          rsISH, ' REPLACE');
        DeleteAFile(Root + rsISS);
        DeleteAFile(Root + rsISC);
        DeleteAFile(Root + rsISH);
      end;

      if UseSUB then
      begin
        WriteLn(FFile, 'SUB ', frmModflow.GetUnitNumber('SUB'), ' ', Root,
          rsSUB);
        if frmModflow.cbSubSaveRestart.Checked then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('SubIDSAVE'),
            ' ', Root, rsSUBR, ' REPLACE');
          DeleteAFile(Root + rsSUBR);
        end;
        if frmModflow.cbSubUseRestart.Checked then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('SubIDREST'),
            ' ', ExtractShortPathName(frmModflow.framSubRestartFile.
            edFilePath.Text), ' OLD');
        end;

        if frmModflow.dgSubOutput.Enabled then
        begin
          for Index := 1 to frmModflow.dgSubOutFormat.RowCount -1 do
          begin
            SUB_FileName := Root + rsSUBON + IntToStr(Index);
            WriteLn(FFile, 'DATA(BINARY) ',
              frmModflow.GetUnitNumber('SUB_Iun' + IntToStr(Index)), ' ',
              SUB_FileName, ' REPLACE');
            DeleteAFile(SUB_FileName);
          end;
        end;
      end;

      if UseSWT then
      begin
        WriteLn(FFile, 'SWT ', frmModflow.GetUnitNumber('SWT'), ' ', Root,
          rsSWT);

        if frmModflow.rdgSwtOutput.Enabled then
        begin
          TSwtWriter.GetOutputUnits(SwtOutputUnits);
          for Index := 1 to 13 do
          begin
            if SwtOutputUnits[Index] <> 0 then
            begin
              WriteLn(FFile, 'DATA(BINARY) ', SwtOutputUnits[Index], ' ', Root,
                rsSWTOUT, Index, ' REPLACE');
            end;
          end;
        end;
      end;

      if UseCHD then
      begin
        WriteLn(FFile, 'CHD ', frmModflow.GetUnitNumber('CHD'), ' ', Root,
          rsCHD);
      end;

      if UseMNW then
      begin
        WriteLn(FFile, 'MNW1 ', frmModflow.GetUnitNumber('MNW1'), ' ', Root,
          rsMNW);
      end;
      if UseMNW2 then
      begin
        WriteLn(FFile, 'MNW2 ', frmModflow.GetUnitNumber('MNW2'), ' ', Root,
          rsMNW2);
      end;
      if UseMNWI then
      begin
        WriteLn(FFile, 'MNWI ', frmModflow.GetUnitNumber('MNWI'), ' ', Root,
          rsMNWI);
        if frmModflow.cbMnwiWel1flag.Checked then
        begin
          WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('WEL1flag'), ' ', Root,
            rsMnwiWel);
        end;
        if frmModflow.cbMnwiQsumFlag.Checked then
        begin
          WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('QSUMflag'), ' ', Root,
            rsMnwiQSum);
        end;
        if frmModflow.cbMnwiByNdFlag.Checked then
        begin
          WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('BYNDflag'), ' ', Root,
            rsMnwiQByNd);
        end;
        for Index := 0 to frmModflow.MonitoringWellNameFileLines.Count - 1 do
        begin
          WriteLn(FFile, frmModflow.MonitoringWellNameFileLines[Index]);
        end;
      end;

      if UseDaflow then
      begin
        WriteLn(FFile, 'DAF ', frmModflow.GetUnitNumber('DAF'), ' ', Root,
          rsDAF);
        DAFGUnitNumber := frmModflow.GetNUnitNumbers('DAFG',2);
        WriteLn(FFile, 'DAFG ', DAFGUnitNumber, ' ', Root, rsDAFG);
        WriteLn(FFile, 'DATA ', DAFGUnitNumber + 1, ' ', Root, rsDAFF);
      end;

      if UseUZF then
      begin
        WriteLn(FFile, 'UZF ', frmModflow.GetUnitNumber('UZF'), ' ', Root,
          rsUZF);
      end;


      if UseVariableDensityFlow then
      begin
        WriteLn(FFile, 'VDF ', frmModflow.GetUnitNumber('VDF'), ' ', Root,
          rsVDF);
      end;

      if UseViscosityPackage then
      begin
        WriteLn(FFile, 'VSC ', frmModflow.GetUnitNumber('VSC'), ' ', Root,
          rsVSC);
      end;

      if UseIntegeratedMassTransport then
      begin
        WriteMT3DInputFileNames(Root, True);
      end;


      if ExportObservations then
      begin
        WriteLn(FFile, 'OBS ', frmModflow.GetUnitNumber('OBS'), ' ', Root,
          rsObs);
      end;

      if UseHeadObservations then
      begin
        WriteLn(FFile, 'HOB ', frmModflow.GetUnitNumber('HOB'), ' ', Root,
          rsHob);
        WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('HOB_OUT'), ' ', Root,
          rsHob+'_out');
      end;

      if UseHeadFluxObservations then
      begin
        WriteLn(FFile, 'CHOB ', frmModflow.GetUnitNumber('CHOB'), ' ', Root,
          rsChob);
        WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('CHOB_OUT'), ' ', Root,
          rsChob+'_out');
      end;

      if UseDrainObservations then
      begin
        WriteLn(FFile, 'DROB ', frmModflow.GetUnitNumber('DROB'), ' ', Root,
          rsDrob);
        WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('DROB_OUT'), ' ', Root,
          rsDrob+'_out');
      end;

      if UseDrainReturnObservations then
      begin
        WriteLn(FFile, 'DTOB ', frmModflow.GetUnitNumber('DTOB'), ' ', Root,
          rsOdt);
      end;

      if UseGHBObservations then
      begin
        WriteLn(FFile, 'GBOB ', frmModflow.GetUnitNumber('GBOB'), ' ', Root,
          rsGbob);
        WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('GBOB_OUT'), ' ', Root,
          rsGbob+'_out');
      end;

      if UseRiverObservations then
      begin
        WriteLn(FFile, 'RVOB ', frmModflow.GetUnitNumber('RVOB'), ' ', Root,
          rsRvob);
        WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('RVOB_OUT'), ' ', Root,
          rsRvob+'_out');
      end;

      if StreamObservationsUsed then
      begin
        WriteLn(FFile, 'STOB ', frmModflow.GetUnitNumber('STOB'), ' ', Root,
          rsStob);
        WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('STOB_OUT'), ' ', Root,
          rsStob+'_out');
      end;

      if UseAdvectionObservations then
      begin
        WriteLn(FFile, 'ADV2 ', frmModflow.GetUnitNumber('ADV'), ' ', Root,
          rsOad);
        WriteLn(FFile, 'DATA  ', frmModflow.GetUnitNumber('ADV_Particles'), ' ',
          Root, rsPart);
      end;

      if UseMOC3D then
      begin
        WriteLn(FFile, 'GWT ', frmModflow.GetUnitNumber('GWT'), ' ', Root,
          rsMOC3D);
      end
      else
      begin
        WriteLn(FFile, '#GWT ', frmModflow.GetUnitNumber('GWT'), ' ', Root,
          rsMOC3D);
      end;

      if UseMt3dLinkInput then
      begin
        WriteLn(FFile, 'LMT6 ', frmModflow.GetUnitNumber('LMT6'), ' ', Root,
          rsLMT);
      end;

      if UseSensitivity then
      begin
        WriteLn(FFile, 'SEN ', frmModflow.GetUnitNumber('SEN'), ' ', Root,
          rsSen);
      end;

      if UseParameterEstimation then
      begin
        WriteLn(FFile, 'PES ', frmModflow.GetUnitNumber('PES'), ' ', Root,
          rsPes);
      end;

      if UseGWM then
      begin
        WriteLn(FFile, 'GWM ', frmModflow.GetUnitNumber('GWM'), ' ', Root,
          rsGWM);
        if frmModflow.cbGWMWFILE.Checked then
        begin
        WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('GWMWFILE'), ' ', Root,
          rsGWMWFILE);
        end;
      end;

      if ExportFormattedHeads then
      begin
        WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('FHD'), ' ', Root,
          rsFhd);
      end;

      if ExportBinaryHeads then
      begin
        WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('BHD'), ' ',
          Root, rsBhd, ' REPLACE');
        DeleteAFile(Root + rsBhd);
      end;

      if ExportFormattedDrawdown then
      begin
        WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('FDN'), ' ', Root,
          rsFdn);
      end;

      if ExportBinaryDrawdown then
      begin
        WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('BDN'), ' ',
          Root, rsBdn, ' REPLACE');
        DeleteAFile(Root + rsBdn);
      end;

      if UseUZF then
      begin
        Assert(UzfWRiter <> nil);
        for Index := 0 to UzfWRiter.GageColumnNumbers.Count -1 do
        begin
          WriteLn(FFile, 'DATA ', UzfWRiter.FirstGageUnitNumber + Index, ' ',
            Root, rsUzfo, Index+1, ' REPLACE');
          DeleteAFile(Root + rsUzfo + IntToStr(Index+1));
        end;
      end;


      if ExportCombinedBudgetFile then
      begin
        WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('BUD'), ' ',
          Root, rsBud, ' REPLACE');
        DeleteAFile(Root + rsBud);
      end
      else
      begin
        if ExportBCFBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('BUD'), ' ',
            Root, rsBud, ' REPLACE');
          DeleteAFile(Root + rsBud);
        end
        else if ExportLPFBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('BUD'), ' ',
            Root, rsBud, ' REPLACE');
          DeleteAFile(Root + rsBud);
        end
        else if ExportHUFBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('BUD'), ' ',
            Root, rsBud, ' REPLACE');
          DeleteAFile(Root + rsBud);
        end;

        if ExportWELBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('WELBUD'),
            ' ', Root, rsBwe, ' REPLACE');
          DeleteAFile(Root + rsBwe);
        end;
        if ExportRCHBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('RCHBUD'),
            ' ', Root, rsBrc, ' REPLACE');
          DeleteAFile(Root + rsBrc);
        end;
        if ExportDRNBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('DRNBUD'),
            ' ', Root, rsBdr, ' REPLACE');
          DeleteAFile(Root + rsBdr);
        end;
        if ExportDRTBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('DRTBUD'),
            ' ', Root, rsBdt, ' REPLACE');
          DeleteAFile(Root + rsBdt);
        end;
        if ExportRIVBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('RIVBUD'),
            ' ', Root, rsBri, ' REPLACE');
          DeleteAFile(Root + rsBri);
        end;
        if ExportEVTBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('EVTBUD'),
            ' ', Root, rsBev, ' REPLACE');
          DeleteAFile(Root + rsBev);
        end;
        if ExportETSBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('ETSBUD'),
            ' ', Root, rsBet, ' REPLACE');
          DeleteAFile(Root + rsBet);
        end;
        if ExportGHBBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('GHBBUD'),
            ' ', Root, rsBgh, ' REPLACE');
          DeleteAFile(Root + rsBgh);
        end;
        if ExportFHBBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('FHBBUD'),
            ' ', Root, rsBfh, ' REPLACE');
          DeleteAFile(Root + rsBfh);
        end;
        if ExportSFRBudget1 then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('BS1Unit'),
            ' ', Root, rsBsf1, ' REPLACE');
          DeleteAFile(Root + rsBsf1);
        end;

        if ExportSTRBudget1 then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('BSt1Unit'),
            ' ', Root, rsBst1, ' REPLACE');
          DeleteAFile(Root + rsBst1);
        end;

        if ExportLakeBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('LAKBUD'),
            ' ', Root, rsLakbdg, ' REPLACE');
          DeleteAFile(Root + rsLakbdg);
        end;
        if ExportReservoirBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('RESBUD'),
            ' ', Root, rsResbdg, ' REPLACE');
          DeleteAFile(Root + rsResbdg);
        end;
        if ExportIBSBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('IBSBUD'),
            ' ', Root, rsIBSB, ' REPLACE');
          DeleteAFile(Root + rsIBSB);
        end;

        if ExportSUBBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('SUBBUD'),
            ' ', Root, rsSUBB, ' REPLACE');
          DeleteAFile(Root + rsSUBB);
        end;

        if ExportSWTBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('SWTBUD'),
            ' ', Root, rsSWTB, ' REPLACE');
          DeleteAFile(Root + rsSWTB);
        end;

        if ExportMNWBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('MNWBUD'),
            ' ', Root, rsBMN, ' REPLACE');
          DeleteAFile(Root + rsBMN);
        end;

        if ExportMnw2Budget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('MNW2BUD'),
            ' ', Root, rsBMN2, ' REPLACE');
          DeleteAFile(Root + rsBMN2);
        end;

        if ExportDaflowBudget then
        begin
          WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('DAFLOWBUD'),
            ' ', Root, rsDAB, ' REPLACE');
          DeleteAFile(Root + rsDAB);
        end;
      end;

      if ExportSFRBudget2 then
      begin
        WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('BS2Unit'),
          ' ', Root, rsBsf2, ' REPLACE');
        DeleteAFile(Root + rsBsf2);
      end;

      if ExportSTRBudget2 then
      begin
        WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('BSt2Unit'),
          ' ', Root, rsBst2, ' REPLACE');
        DeleteAFile(Root + rsBst2);
      end;

      if ExportSensitivityBinaryfile then
      begin
        WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('SENBIN'), ' ',
          Root, rsSenb, ' REPLACE');
        DeleteAFile(Root + rsSenb);
      end;

      if ExportSensitivityAsciifile then
      begin
        WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('SENASCII'), ' ', Root,
          rsSena);
      end;
      Flush(FFile);
    end;
  finally
    CloseFile(FFile);
  end;
end;

procedure TNameFileWriter.WriteObservationFile(root: string);
var
  FileName: string;
  ISCALS: integer;
  OUTNAM: string;
begin
  if ExportObservations then
  begin
    FileName := GetCurrentDir + '\' + Root + rsObs;
    AssignFile(FFile, FileName);
    try
      if ContinueExport then
      begin
        Rewrite(FFile);
        if frmModflow.cbCreateObsOutput.Checked then
        begin
          OUTNAM := Root;
        end
        else
        begin
          OUTNAM := 'NONE'
        end;

        ISCALS := frmMODFLOW.comboObservationScaling.ItemIndex - 1;
        WriteLn(FFile, OUTNAM, ' ', ISCALS, ' ALLFILES');
        Flush(FFile);
      end;
    finally
      CloseFile(FFile);
    end;
  end;
end;

procedure TNameFileWriter.WriteMT3DInputFileNames(root: string;
  const IsSeaWat: boolean);
var
  SpeciesIndex: integer;
  SpeciesLetter: Char;
  NewRoot: string;
  ConfigurationUnitNumber: integer;
begin
  WriteLn(FFile, 'BTN ', frmModflow.GetUnitNumber('BTN'), ' ', Root, rsBTN);
  if frmModflow.cbADV.Checked then
  begin
    WriteLn(FFile, 'ADV ', frmModflow.GetUnitNumber('ADV'), ' ', Root,
      rsADV);
  end;
  if frmModflow.cbDSP.Checked then
  begin
    WriteLn(FFile, 'DSP ', frmModflow.GetUnitNumber('DSP'), ' ', Root,
      rsDSP);
  end;
  if frmModflow.cbSSM.Checked then
  begin
    WriteLn(FFile, 'SSM ', frmModflow.GetUnitNumber('SSM'), ' ', Root,
      rsSSM);
  end;
  if frmModflow.cbRCT.Checked then
  begin
    WriteLn(FFile, 'RCT ', frmModflow.GetUnitNumber('RCT'), ' ', Root,
      rsRCT);
  end;
  if frmModflow.cbGCG.Checked then
  begin
    WriteLn(FFile, 'GCG ', frmModflow.GetUnitNumber('GCG'), ' ', Root,
      rsGCG);
  end;
  if frmModflow.cbMt3dMultinodeWellOutput.Checked then
  begin
    WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('ISSGOUT'), ' ', Root,
      rsISGOUT);
  end;

  if frmModflow.cbTOB.Checked then
  begin
    WriteLn(FFile, 'TOB ', frmModflow.GetUnitNumber('TOB'), ' ', Root,
      rsTOB);
    if frmModflow.cb_inConcObs.Checked then
    begin
      WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('OCN'), ' ', Root,
        rsOCN);
    end;
    if frmModflow.cb_inFluxObs.Checked then
    begin
      WriteLn(FFile, 'DATA ', frmModflow.GetUnitNumber('MFX'), ' ', Root,
        rsMFX);
    end;
    if frmModflow.cb_inSaveObs.Checked then
    begin
      WriteLn(FFile, 'DATA(BINARY) ', frmModflow.GetUnitNumber('PST'), ' ', Root,
        rsPST);
    end;
  end;

  if IsSeaWat then
  begin
    // Unit number 199 must be used for the grid configuration file with SEAWAT.
    ConfigurationUnitNumber := 199;
  end
  else
  begin
    // Unit number 17 must be used for the grid configuration file with MT3DMS.
    ConfigurationUnitNumber := 17;
  end;

  WriteLn(FFile, 'DATA ', ConfigurationUnitNumber, ' ', Root, rsCNF);

  NewRoot := copy(Root, 1, 7);
  SpeciesLetter := Pred('A');
  for SpeciesIndex := 1 to StrToInt(frmModflow.adeMT3DNCOMP.Text) do
  begin
    Inc(SpeciesLetter);
    WriteLn(FFile, 'DATA(BINARY) ', 200 + SpeciesIndex, ' ',
      NewRoot + SpeciesLetter, rsUCN);
    WriteLn(FFile, 'DATA ', 400 + SpeciesIndex, ' ',
      NewRoot + SpeciesLetter, rsMTO);
    WriteLn(FFile, 'DATA ', 600 + SpeciesIndex, ' ',
      NewRoot + SpeciesLetter, rsMAS);
    DeleteAFile(NewRoot + SpeciesLetter + rsUCN);
    DeleteAFile(NewRoot + SpeciesLetter + rsMTO);
    DeleteAFile(NewRoot + SpeciesLetter + rsMAS);
  end;


end;

procedure TNameFileWriter.WriteMT3DNameFile(root: string);
var
  FileName: string;
begin
  FileName := GetCurrentDir + '\' + Root + rsMnm;
  AssignFile(FFile, FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      WriteDataReadFrom(FileName);

      WriteLn(FFile, 'LIST ', frmModflow.GetUnitNumber('MLS'), ' ', Root,
        rsMLS);

      WriteMT3DInputFileNames(Root, False);

      if frmModflow.comboMt3dFlowFormat.ItemIndex = 0 then
      begin
        WriteLn(FFile, 'FTL ', frmModflow.GetUnitNumber('FTL'), ' ', Root,
          rsFTL);
      end
      else
      begin
        WriteLn(FFile, 'FTL ', frmModflow.GetUnitNumber('FTL'), ' ', Root,
          rsFTL,
          ' Free');
      end;

    end;
  finally
    CloseFile(FFile);
  end;
end;

function TNameFileWriter.WriteMT3DBatchFile(CurrentModelHandle: ANE_PTR;
  UseCalibration: boolean; Root: string): string;
var
  FileName: string;
  //  RunMOC3D : boolean;
  Path: string;
  ProjectOptions: TProjectOptions;
  GridLayerHandle: ANE_PTR;
  GridLayerName: string;
  Directory: ANE_STR;
  StringToEvaluate: string;
  STR: ANE_STR;
begin
  FileName := GetCurrentDir + '\MT3DMS.BAT';
  result := FileName;
  AssignFile(FFile, FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      Path := frmMODFLOW.adeMT3DPath.Text;

      Writeln(FFile, Path, ' ', Root + rsMnm);

      if UseCalibration then
      begin
        GridLayerName := ModflowTypes.GetGridLayerType.WriteNewRoot;
        ProjectOptions := TProjectOptions.Create;
        try
          GridLayerHandle := ProjectOptions.GetLayerByName
            (CurrentModelHandle, GridLayerName);

          StringToEvaluate := 'GetMyDirectory()';

          GetMem(STR, Length(StringToEvaluate) + 1);
          try
            StrPCopy(STR, StringToEvaluate);
            ANE_EvaluateStringAtLayer(CurrentModelHandle, GridLayerHandle,
              kPIEString, STR, @Directory);
            ANE_ProcessEvents(CurrentModelHandle);
          finally
            FreeMem(STR);
          end;

          WriteLn(FFile, string(Directory), 'WaitForMe.exe');
          WriteLn(FFile, string(Directory), 'SelectChar.exe');

        finally
          ProjectOptions.Free;
        end;
      end
      else
      begin
        if frmModflow.cbOpenOutputInNotepad.Checked then
        begin
          WriteLn(FFile, 'Start Notepad ', Root, rsMLS);
        end;
        Writeln(FFile, 'Pause');
      end;
    end;
  finally
    CloseFile(FFile);
  end;
end;

procedure TNameFileWriter.WriteGWM_NameFile(root: string);
var
  FileName: string;
begin
  FileName := GetCurrentDir + '\' + Root + rsGWM;
  AssignFile(FFile, FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      WriteDataReadFrom(FileName);

      WriteLn(FFile, 'DECVAR ', Root, rsDECVAR);
      WriteLn(FFile, 'OBJFNC ', Root, rsOBJFNC);
      WriteLn(FFile, 'VARCON ', Root, rsVARCON);
      WriteLn(FFile, 'SUMCON ', Root, rsSUMCON);
      WriteLn(FFile, 'HEDCON ', Root, rsHEDCON);
      if UseGWM_STAVAR then
      begin
        WriteLn(FFile, 'STAVAR ', Root, rsSTAVAR);
      end;
      if frmModflow.cbSTR.Checked and frmModflow.cbSTRRetain.Checked then
      begin
        WriteLn(FFile, 'STRMCON ', Root, rsSTRCON);
      end;
      WriteLn(FFile, 'SOLN ', Root, rsSOLN);
    end;
  finally
    CloseFile(FFile);
  end;
end;

end.

