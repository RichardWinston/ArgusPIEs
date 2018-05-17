unit WriteModflowFilesUnit;

interface

uses Windows, SysUtils, Forms, Dialogs, ANEPIE;

// also used for writing MODFLOW-2005
procedure GWriteModflow2000(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure WriteModflowFiles(const CurrentModelHandle: ANE_PTR; Root: string);
function StreamUsed: boolean;
function StreamObservationsUsed: boolean;
procedure ExecuteBatchFile(FileName: string);
function MaybeUseGage: boolean;
function UseUzf: boolean;
function ElevationsNeeded: boolean;
function UseGWM_STAVAR: Boolean;

implementation

uses Variables, WriteModflowDiscretization, WriteMultiplierUnit,
  WriteModflowZonesUnit, WriteOutputControlUnit, WriteBCF_Unit,
  ProgressUnit, WriteLayerPropertyFlow, WriteRechargeUnit, WriteRiverUnit,
  InitializeBlockUnit, FreeBlockUnit, WriteEvapUnit, WriteWellUnit,
  PointInsideContourUnit, WriteDrainUnit, WriteGHBUnit, WriteSolversUnit,
  ModflowUnit, WriteHorizFlowBarriersUnit, WriteFHBUnit, WriteNameFileUnit,
  WriteGHBObservationsUnit, WriteDrainObservationsUnit,
  WriteRiverObservationsUnit, WriteHeadFluxObservationsUnit,
  WriteHeadObsUnit, WriteSensitivityUnit, WriteParamEstUnit,
  WriteAdvectionObservationsUnit, WriteLakesUnit, WriteReservoirUnit,
  ANE_LayerUnit, ArgusFormUnit, UnitNumbers, WriteGageUnit, WriteMoc3d,
  WriteStreamUnit, WriteStrUnit, WriteETSUnit, WriteDrainReturnUnit,
  WriteDrainReturnObservationsUnit, WriteIBSUnit, WriteHydmodUnit, WriteCHDUnit,
  WriteHUF_Unit, WriteMt3dLink, WriteMultiNodeWellUnit, WriteDaflow,
  WriteBFLX_Unit, WriteSubsidence, WriteVariableDensityFlow, WriteMT3DUnit,
  WriteIPDA, WriteIPDL, WriteCBDY, WriteGWM_DecisionVariables,
  WriteGWM_ObjectiveFunction, WriteGWM_SummaryConstraints, WriteSwtUnit,
  WriteGWM_HeadConstraints, WriteGWM_StreamConstraints, WriteGWM_Solution,
  WriteGwtParticleObservation, WriteUZF, WriteSeawatViscosity, WriteMNW2Unit,
  WriteGWM_StateVariables, WriteGWTConstantConc, WriteGWT_VBAL;

function LakeUsed: boolean;
begin
  result := frmModflow.cbLAK.Checked
    and frmModflow.cbLAKRetain.Checked;
end;

function ReservoirUsed: boolean;
begin
  result := frmModflow.cbRES.Checked
    and frmModflow.cbRESRetain.Checked;
end;

function UseUzf: boolean;
begin
  result := frmModflow.cbUZF.Checked
    and frmModflow.cbUzfRetain.Checked;
end;

function ExportDiscretization: boolean;
begin
  result := frmModflow.cbExpDIS.Checked;
end;

function ExportBasic: boolean;
begin
  result := frmModflow.cbExpBAS.Checked;
end;

function ExportMultiplier: boolean;
begin
  result := frmModflow.cbExpMULT.Checked and UseMultipliers;
end;

function ExportZone: boolean;
begin
  result := frmModflow.cbExpZONE.Checked and UseZones;
end;

function ExportOutputControl: boolean;
begin
  result := frmModflow.cbExpOC.Checked;
end;

function ExportLPF: boolean;
begin
  result := (frmModflow.rgFlowPackage.ItemIndex = 1)
    and frmModflow.cbExpLPF.Checked;
end;

function ExportHUF: boolean;
begin
  result := (frmModflow.rgFlowPackage.ItemIndex = 2)
    and frmModflow.cbExpHUF.Checked;
end;

function ExportMOC3D: boolean;
begin
  result := frmModflow.cbMOC3D.Checked
    and frmModflow.cbUseSolute.Checked;
end;

function ExportBCF: boolean;
begin
  result := (frmModflow.rgFlowPackage.ItemIndex = 0)
    and frmModflow.cbExpBCF.Checked;
end;

function ExportSolver: boolean;
begin
  Result := frmModflow.cbExpMatrix.Checked;
end;

function ExportRCH: boolean;
begin
  result := frmModflow.cbRCH.Checked
    and frmModflow.cbRCHRetain.Checked and frmModflow.cbExpRCH.Checked;
end;

function ExportEVT: boolean;
begin
  result := frmModflow.cbEVT.Checked
    and frmModflow.cbEVTRetain.Checked and frmModflow.cbExpEVT.Checked;
end;

function ExportETS: boolean;
begin
  result := frmModflow.cbETS.Checked
    and frmModflow.cbETSRetain.Checked and frmModflow.cbExpETS.Checked;
end;

function ExportRiv: boolean;
begin
  result := frmModflow.cbRIV.Checked
    and frmModflow.cbRIVRetain.Checked and frmModflow.cbExpRIV.Checked;
end;

function ExportSFR: boolean;
begin
  result := UseSFR and frmModflow.cbExpSfr.Checked;
end;

function ExportMNW: boolean;
begin
  result := UseMNW and frmModflow.cbExpMNW.Checked;
end;

function ExportMnw2: boolean;
begin
  result := UseMNW2 and frmModflow.cbExpMnw2.Checked;
end;

function ExportDaflow: boolean;
begin
  result := UseDaflow and frmModflow.cbExpDAFLOW.Checked;
end;

function ExportWEL: boolean;
begin
  result := frmModflow.cbWEL.Checked
    and frmModflow.cbWELRetain.Checked and frmModflow.cbExpWEL.Checked;
end;

function ExportDRN: boolean;
begin
  result := frmModflow.cbDRN.Checked
    and frmModflow.cbDRNRetain.Checked and frmModflow.cbExpDRN.Checked;
end;

function ExportDRT: boolean;
begin
  result := frmModflow.cbDRT.Checked
    and frmModflow.cbDRTRetain.Checked and frmModflow.cbExpDRT.Checked;
end;

function ExportGHB: boolean;
begin
  result := frmModflow.cbGHB.Checked
    and frmModflow.cbGHBRetain.Checked and frmModflow.cbExpGHB.Checked;
end;

function ExportHFB: boolean;
begin
  result := frmModflow.cbHFB.Checked
    and frmModflow.cbHFBRetain.Checked and frmModflow.cbExpHFB.Checked;
end;

function ExportFHB: boolean;
begin
  result := UseFHB and frmModflow.cbExpFHB.Checked;
end;

function ExportHYD: boolean;
begin
  result := UseHYD and frmModflow.cbExpHYD.Checked;
end;

function StreamUsed: boolean;
begin
  result := frmModflow.cbSTR.Checked
    and frmModflow.cbSTRRetain.Checked;
end;

function StreamObservationsUsed: boolean;
begin
  result := StreamUsed and UseObservations
    and frmModflow.cbStreamObservations.Checked
    and frmModflow.cbUseStreamObservations.Checked;
end;

function ExportLAK: boolean;
begin
  result := LakeUsed and frmModflow.cbExpLAK.Checked;
end;

function ExportRES: boolean;
begin
  result := ReservoirUsed and frmModflow.cbExpRES.Checked;
end;

function MaybeUseGage: boolean;
begin
  result :=
    (frmModflow.cbLAK.Checked and frmModflow.cbLAKRetain.Checked)
    or (frmModflow.cbSFR.Checked and frmModflow.cbSFRRetain.Checked);
end;

function ExportGage: boolean;
begin
  result := MaybeUseGage and frmModflow.cbExpGag.Checked;
end;

function ExportUzf: boolean;
begin
  result := UseUzf and frmModflow.cbExpUZF.Checked;
end;

function ExportGHBObs: boolean;
begin
  result := UseGHBObservations
    and frmModflow.cbGHB.Checked and frmModflow.cbGHBRetain.Checked
    and frmModflow.cbGBOB.Checked;
end;

function ExportDrainObs: boolean;
begin
  result := UseDrainObservations
    and frmModflow.cbDRN.Checked and frmModflow.cbDRNRetain.Checked
    and frmModflow.cbDROB.Checked;
end;

function ExportDrainReturnObs: boolean;
begin
  result := UseDrainReturnObservations
    and frmModflow.cbDRT.Checked and frmModflow.cbDRTRetain.Checked
    and frmModflow.cbDTOB.Checked;
end;

function ExportRiverObs: boolean;
begin
  result := UseRiverObservations
    and frmModflow.cbRIV.Checked and frmModflow.cbRIVRetain.Checked
    and frmModflow.cbRVOB.Checked;
end;

function ExportSpecHeadFluxObs: boolean;
begin
  result := UseHeadFluxObservations and frmModflow.cbCHOB.Checked;
end;

function ExportHeadObs: boolean;
begin
  result := UseHeadObservations
    and frmModflow.cbHOB.Checked;
end;

function ExportAdvectionObs: boolean;
begin
  result := UseAdvectionObservations and frmModflow.cbADOB.Checked;
end;

function ExportSensitivity: boolean;
begin
  result := frmModflow.cbSensitivity.Checked and frmModflow.cbSEN.Checked;
end;

function ExportParamEst: boolean;
begin
  result := frmModflow.cbParamEst.Checked and frmModflow.cbPESExport.Checked;
end;

function ExportStr: boolean;
begin
  result := StreamUsed and frmModflow.cbExpStr.Checked;
end;

function ExportStrObs: boolean;
begin
  result := StreamObservationsUsed and frmModflow.cbSTOB.Checked;
end;

function ExportIBS: boolean;
begin
  result := UseIBS and frmModflow.cbExpIBS.Checked;
end;

function ExportSub: boolean;
begin
  result := UseSub and frmModflow.cbExpSUB.Checked;
end;

function ExportSwt: boolean;
begin
  result := UseSwt and frmModflow.cbExpSWT.Checked;
end;

function ExportMt3dLinkInput: boolean;
begin
  result := UseMt3dLinkInput and frmModflow.cbFTI.Checked;
end;

function ExportBFLX: boolean;
begin
  result := UseBFLX and frmModflow.cbExpBFLX.Checked;
end;

function ExportIPDA: boolean;
begin
  result := UseIPDA and frmModflow.cbExpIPDA.Checked;
end;

function ExportIPDL: boolean;
begin
  result := UseIPDL and frmModflow.cbExpIPDA.Checked;
end;

function ExportCBDY: boolean;
begin
  result := UseCBDY and frmModflow.cbExpCBDY.Checked;
end;

function InitializeBasic: boolean;
begin
  result := (ExportBasic or LakeUsed or ReservoirUsed);
end;

function ExportGWM_DecVar: boolean;
begin
  result := UseGWM and frmModflow.cbGWM_DECVAR.Checked;
end;

function UseGWM_STAVAR: Boolean;
begin
  result := UseGWM and (frmModflow.cbGwmHeadVariables.Checked
    or frmModflow.cbGwmStreamVariables.Checked
    or (frmModflow.IsAnyTransient and (StrToInt(frmModflow.rdeGwmStorageStateVarCount.Output) >= 1)));
end;

function ExportGWM_STAVAR: boolean;
begin
  result := UseGWM_STAVAR and frmModflow.cbGWM_STAVAR.Checked
end;

function ExportGWM_OBJFNC: boolean;
begin
  result := UseGWM and frmModflow.cbGWM_OBJFNC.Checked;
end;

function ExportGWM_VARCON: boolean;
begin
  result := UseGWM and frmModflow.cbGWM_VARCON.Checked;
end;

function ExportGWM_SUMCON: boolean;
begin
  result := UseGWM and frmModflow.cbGWM_SUMCON.Checked;
end;

function ExportGWM_HEDCON: boolean;
begin
  result := UseGWM and frmModflow.cbGWM_HEDCON.Checked;
end;

function ExportGWM_STRMCON: boolean;
begin
  result := UseGWM and (StreamUsed or UseSFR) and frmModflow.cbGWM_STRMCON.Checked;
end;

function ExportGWM_SOLN: boolean;
begin
  result := UseGWM and frmModflow.cbGWM_SOLN.Checked;
end;

function ExportPTOB: boolean;
begin
  result := UsePTOB and frmModflow.cbExpPTOB.Checked;
end;

function ExportCCBD: Boolean;
begin
  Result := UseCCBD and frmModflow.cbExpCCBD.Checked;
end;

function ExportVBAL: Boolean;
begin
  Result := UseVBAL and frmModflow.cbExpVBAL.Checked;
end;

function ElevationsNeeded: boolean;
begin
  result := ExportRCH or ExportEVT or ExportRiv or ExportWEL or ExportDRN
    or ExportDRT or ExportBCF or ExportGHB or ExportFHB or ExportHeadObs
    or ExportLak or ExportDiscretization or ExportRiverObs or ExportDrainObs
    or ExportDrainReturnObs or ExportGHBObs or ExportStr or ExportStrObs
    or ExportETS or ExportCHD or ExportMNW or ExportDaflow or ExportRes
    or UseIntegeratedMassTransport
    or (ExportLPF and LakeUsed)
    or ((ExportLPF or ExportBCF or ExportHUF) and ReservoirUsed)
    or (UseCHD and ExportBFLX)
    or (UseCHD and ExportSpecHeadFluxObs)
    or (UseFHB and ExportBFLX) or (ExportGage and UseSFR) or ExportSFR
    or frmModflow.cbDeactivateIbound.Checked or ExportGWM_HEDCON
    or ExportGWM_STRMCON or ExportGWM_DecVar or ExportGWM_VARCON
    or ExportGWM_STAVAR
    or ExportMnw2;
end;

function NeedToInitilizeGrid: boolean;
begin
  result := ExportRiv or ExportWEL or ExportDRN
    or ExportDRT or ExportGHB or ExportHFB or ExportFHB or ExportGHBObs
    or ExportDrainObs or ExportDrainReturnObs or ExportRiverObs
    or ExportSpecHeadFluxObs or ExportHeadObs or ExportAdvectionObs
    or ExportLak or ExportSFR or frmModflow.cbMOC3D.Checked or ExportStr
    or ExportStrObs or ExportCHD or ExportRes or ExportMNW or ExportDaflow
    or ExportBFLX or UseIntegeratedMassTransport or ExportMnw2
    or (ExportLPF  and LakeUsed)
    or ((ExportLPF or ExportBCF or ExportHUF) and ReservoirUsed)
    or (UseCHD and ExportSpecHeadFluxObs)
    or ExportHYD or (ExportGage and UseSFR)
    or ExportGWM_HEDCON or ExportGWM_STRMCON or ExportGWM_DecVar
    or ExportGWM_VARCON or ExportGWM_STAVAR;
end;

procedure ExecuteBatchFile(FileName: string);
var
  StartupInfo: TStartupInfo;
  ProcessInformation: TProcessInformation;
begin
  with StartupInfo do
  begin
    cb := SizeOf(StartupInfo);
    lpReserved := nil;
    lpDesktop := nil;
    lpTitle := nil;
    dwX := 0;
    dwY := 0;
    dwXSize := 0;
    dwYSize := 0;
    dwXCountChars := 0;
    dwYCountChars := 0;
    dwFillAttribute := FOREGROUND_RED or FOREGROUND_GREEN or FOREGROUND_BLUE;
    dwFlags := 0;
    wShowWindow := SW_SHOWDEFAULT;
    cbReserved2 := 0;
    lpReserved2 := nil;
    hStdInput := 0;
    hStdOutput := 0;
    hStdError := 0;
  end;

  if not CreateProcess(nil, PChar(ExtractShortPathName(FileName)), nil, nil,
    False, CREATE_NEW_CONSOLE,
    {NORMAL_PRIORITY_CLASS,}nil, nil, StartupInfo, ProcessInformation) then
  begin
    RaiseLastOSError;
  end;

end;

procedure WriteYcintFiles(const CurrentModelHandle: ANE_PTR; Root: string);
var
  NameFileWriter: TNameFileWriter;
  BatchFileName: string;
begin
  NameFileWriter := TNameFileWriter.Create;
  try
    BatchFileName := NameFileWriter.WriteYcintBatchFile(CurrentModelHandle,
      frmModflow.cbCalibrate.Checked, Root);
  finally
    NameFileWriter.Free;
  end;
  ExecuteBatchFile(BatchFileName);
end;

procedure WriteBealeFiles(const CurrentModelHandle: ANE_PTR; Root: string);
var
  NameFileWriter: TNameFileWriter;
  BatchFileName: string;
begin
  NameFileWriter := TNameFileWriter.Create;
  try
    BatchFileName := NameFileWriter.WriteBealeBatchFile(CurrentModelHandle,
      frmModflow.cbCalibrate.Checked, Root);
  finally
    NameFileWriter.Free;
  end;
  ExecuteBatchFile(BatchFileName);
end;

procedure WriteModflowFiles(const CurrentModelHandle: ANE_PTR; Root: string);
var
  BatchFileName: string;
  NameFileWriter: TNameFileWriter;
  DiscretizationWriter: TDiscretizationWriter;
  MultiplierWriter: TMultiplierWriter;
  ZoneWriter: TZoneWriter;
  BasicPkgWriter: TBasicPkgWriter;
  OutputControlWriter: TOutputControlWriter;
  BCFWriter: TBCFWriter;
  Count: integer;
  LayerPropertyWriter: TLayerPropertyWriter;
  RechargeWriter: TRechargeWriter;
  EvapWriter: TEvapWriter;
  RiverWriter: TRiverPkgWriter;
  WellWriter: TWellPkgWriter;
  DrainWriter: TDrainPkgWriter;
  GHBPkgWriter: TGHBPkgWriter;
  SIP_Writer: TSIP_Writer;
  SOR_Writer: TSOR_Writer;
  PCG2_Writer: TPCG2_Writer;
  DE4_Writer: TDE4_Writer;
  HFBPkgWriter: THFBPkgWriter;
  FHBPkgWriter: TFHBPkgWriter;
  GHBObservationWriter: TGHBObservationWriter;
  DrainObservationWriter: TDrainObservationWriter;
  DrainReturnObservationWriter: TDrainReturnObservationWriter;
  RiverObservationWriter: TRiverObservationWriter;
  HeadFluxObservationWriter: THeadFluxObservationWriter;
  HeadObsWriter: THeadObsWriter;
  AdvObsWriter: TAdvectionObservationWriter;
  SensitivityWriter: TSensitivityWriter;
  ParamEstWriter: TParamEstWriter;
  LakeWriter: TLakeWriter;
  ReservoirWriter: TReservoirWriter;
  GageWriter: TGageWriter;
  StreamWriter: TStreamWriter;
  ErrorFileName: string;
  AString: string;
  MOC3D_Writer: TMOC3D_Writer;
  MOC3D_ObservationCount: integer;
  StrWriter: TStrWriter;
  EtsWriter: TEtsWriter;
  DrainReturnWriter: TDrainReturnPkgWriter;
  Lmd_Link_Writer: TLmd_Link_Writer;
  IBSWriter: TIBSWriter;
  HydmodWriter: THydmodWriter;
  ChdWriter: TCHDPkgWriter;
  HUF_Writer: THUF_Writer;
  LinkWriter: TMt3dLinkWriter;
  MNW_Writer: TMultiNodeWellWriter;
  Mnw2Writer: TMnw2Writer;
  DaflowWriter: TDaflowWriter;
  BFLX_Writer: TBFLX_Writer;
  SubWriter: TSubsidenceWriter;
  SwtWriter: TSwtWriter;
  VDF_Writer: TVariableDensityWriter;
  GMG_Writer: TGMG_Writer;
  IpdaWriter: TIpdaWriter;
  IpdlWriter: TIpdlWriter;
  GWT_CBDY_Writer: TGWT_CBDY_Writer;
  GWM_DecAndConstWriter: TWriteGWM_DecisionVariablesAndConstraintsWriter;
  GWM_ObjectiveFuncWriter: TGWM_ObjectiveFunctionWriter;
  SummaryConstraintsWriter: TSummaryConstraintsWriter;
  GWM_HeadConstraintsWriter: TGWM_HeadConstraintsWriter;
  StreamConstrainstWriter: TStreamConstrainstWriter;
  SolutionWriter: TSolutionWriter;
  ParticleObservationWriter: TGwtParticleObservationWriter;
  UzfWriter: TUzfWriter;
  ViscosityWriter: TSeawatViscosityWriter;
  GWM_StateVarWriter: TGWM_StateWriter;
  ConstConcWriter: TGwtConstConcWriter;
  VbalWriter: TGwtVBalWriter;
  procedure ExportHeadObservations(FlowWriter: TFlowWriter;
    BasicWriter: TBasicPkgWriter);
  begin
    if ContinueExport and ExportHeadObs then
    begin
      HeadObsWriter := THeadObsWriter.Create;
      try
        HeadObsWriter.WriteFile(CurrentModelHandle, Root, DiscretizationWriter,
          FlowWriter, BasicWriter);
      finally
        HeadObsWriter.Free;
      end;
      frmProgress.pbOverall.StepIt;
    end;
  end;
  procedure HandleException(E: Exception);
  begin
    ErrorMessages.Add('');
    ErrorMessages.Add(E.Message);
  end;
begin
  UzfWriter := nil;
  StrWriter := nil;
  try
    try
      ClearObservationNames;

      if not LakeUsed then
      begin
        InitializeLakeGages;
      end;
      if not UseSFR then
      begin
        InitializeStreamGages;
      end;

      ShowWarnings := frmModflow.cbShowWarnings.Checked;
      ContinueExport := True;
      DiscretizationWriter := TDiscretizationWriter.Create;
      LakeWriter := nil;
      ReservoirWriter := nil;
      RiverWriter := nil;
      WellWriter := nil;
      DrainWriter := nil;
      GHBPkgWriter := nil;
      BasicPkgWriter := nil;
      StreamWriter := nil;
      DrainReturnWriter := nil;
      ChdWriter := nil;
      FHBPkgWriter := nil;

      try
        Count := 2; // discretization, name file
        Inc(Count); // multiplier;
        Inc(Count); // zone;
        if ExportBasic then
        begin
          Inc(Count); // basic;
        end;
        if ExportOutputControl then
        begin
          Inc(Count); // output control;
        end;
        if ExportBCF or ExportLPF or ExportHUF then
        begin
          Inc(Count); // bcf or layer property flow;
        end;
        if ExportRCH then
        begin
          Inc(Count); // Recharge
        end;
        if ExportEVT then
        begin
          Inc(Count); // evapotranspiration
        end;
        if ExportETS then
        begin
          Inc(Count); // segmented evapotranspiration
        end;
        if NeedToInitilizeGrid then
        begin
          Inc(Count); // initialize grid
        end;
        if ExportRIV then
        begin
          Inc(Count); // river
        end;
        if ExportWEL then
        begin
          Inc(Count); // wells
        end;
        if ExportDRN then
        begin
          Inc(Count); // drains
        end;
        if ExportDRT then
        begin
          Inc(Count); // drains
        end;
        if ExportGHB then
        begin
          Inc(Count); // general-head boundaries
        end;
        if ExportHFB then
        begin
          Inc(Count); // horizontal flow boundaries
        end;
        if ExportFHB or (UseFHB and ExportBFLX) then
        begin
          Inc(Count); // Specified-Flow and Specified-Head package
        end;
        if ExportLAK then
        begin
          Inc(Count); // Lake package
        end;
        if ExportRES then
        begin
          Inc(Count); // RES package
        end;

        if ExportIBS then
        begin
          Inc(Count); // InterbedStorage package
        end;

        if ExportSub then
        begin
          Inc(Count); // Subsidence and Aquifer System Compaction package
        end;

        if ExportSwt then
        begin
          Inc(Count); // Subsidence and Aquifer System Compaction for Water Table Aquifers package
        end;

        if ExportSFR then
        begin
          Inc(Count); // Stream Flow Routing package
        end;

        if ExportSolver then
        begin
          Inc(Count); // solver
        end;
        if ExportGHBObs then
        begin
          Inc(Count); // General-head boundary observations
        end;
        if ExportDrainObs then
        begin
          Inc(Count); // Drain observations
        end;
        if ExportDrainReturnObs then
        begin
          Inc(Count); // Drain Return observations
        end;
        if ExportRiverObs then
        begin
          Inc(Count); // River observations
        end;
        if ExportSpecHeadFluxObs then
        begin
          Inc(Count); // Specified Head flux observations
        end;
        if ExportHeadObs then
        begin
          Inc(Count); //  Head observations
        end;
        if ExportAdvectionObs then
        begin
          Inc(Count); //  Advection observations
        end;

        if ExportStr then
        begin
          Inc(Count); //  stream
        end;

        if ExportStrObs then
        begin
          Inc(Count); //  stream observations
        end;

        if ExportHYD then
        begin
          Inc(Count); //  HYDMOD
        end;

        if ExportCHD or (UseCHD and ExportBFLX)
          or (UseCHD and ExportSpecHeadFluxObs) then
        begin
          Inc(Count); //  CHD package
        end;

        if ExportMNW then
        begin
          Inc(Count); //  MNW
        end;

        if ExportMnw2 then
        begin
          Inc(Count); //  MNW2
        end;

        if ExportDaflow then
        begin
          Inc(Count); //  Daflow
        end;

        if ExportVariableDensityFlow then
        begin
          Inc(Count); // SeaWat
        end;

        if ExportViscosity then
        begin
          Inc(Count); // SeaWat
        end;

        if ExportSensitivity then
        begin
          Inc(Count); //  sensitivities
        end;

        if ExportParamEst then
        begin
          Inc(Count); //  parameter estimation
        end;

        if ExportMt3dLinkInput then
        begin
          Inc(Count); //Link to MT3D.
        end;

        if ExportBFLX then
        begin
          Inc(Count);
        end;

        if ExportIPDA then
        begin
          Inc(Count);
        end;

        if ExportIPDL then
        begin
          Inc(Count);
        end;

        if ExportCBDY then
        begin
          Inc(Count);
        end;

        if ExportPTOB then
        begin
          Inc(Count);
        end;

        if ExportCCBD then
        begin
          Inc(Count);
        end;

        if ExportVBAL then
        begin
          Inc(Count);
        end;

        if UseIntegeratedMassTransport then
        begin
          UpdateCountMT3DMS(Count);
        end;

        if ShowWarnings and ElevationsNeeded then
        begin
          Inc(Count); //  check elevation errors
        end;

        if ExportGWM_STRMCON then
        begin
          Inc(Count);
        end;

        // check if you need to at least
        // evaluate TWriteGWM_DecisionVariablesAndConstraintsWriter
        if ExportGWM_DecVar or ExportGWM_VARCON or ExportGWM_SOLN then
        begin
          Inc(Count);
        end;

        // exporting both takes more time
        if ExportGWM_DecVar and ExportGWM_VARCON then
        begin
          Inc(Count);
        end;

        if ExportGWM_OBJFNC then
        begin
          Inc(Count);
        end;

        if ExportGWM_SUMCON then
        begin
          Inc(Count);
        end;

        if ExportGWM_HEDCON then
        begin
          Inc(Count);
        end;

        frmProgress.reErrors.Lines.Clear;
        frmProgress.pbOverall.Max := Count;
        frmProgress.Show;

        // assign unit numbers in same order as packages evaluated
        if UseMt3dLinkInput then
        begin
          TMt3dLinkWriter.AssignUnitNumbers;
        end;

        if frmModflow.cbSensitivity.Checked  then
        begin
          SensitivityWriter := TSensitivityWriter.Create;
          try
            SensitivityWriter.AssignUnitNumbers;
          finally
            SensitivityWriter.Free;
          end;
        end;

        if UseSub then
        begin
          TSubsidenceWriter.AssignUnitNumbers;
        end;

        if LakeUsed then
        begin
          TLakeWriter.AssignUnitNumbers(true);
        end;

        if ReservoirUsed then
        begin
          TReservoirWriter.AssignUnitNumbers(true);
        end;

        TBasicPkgWriter.AssignUnitNumbers;

        if frmModflow.rgFlowPackage.ItemIndex = 2 then
        begin
          THUF_Writer.AssignUnitNumbers;
        end
        else if frmModflow.rgFlowPackage.ItemIndex = 1 then
        begin
          TLayerPropertyWriter.AssignUnitNumbers;
        end
        else
        begin
          TBCFWriter.AssignUnitNumbers;
        end;

        if frmModflow.cbRCH.Checked
          and frmModflow.cbRCHRetain.Checked then
        begin
          TRechargeWriter.AssignUnitNumbers;
        end;

        if UseIBS then
        begin
          TIBSWriter.AssignUnitNumbers;
        end;

        if frmModflow.cbEVT.Checked
          and frmModflow.cbEVTRetain.Checked then
        begin
          TEvapWriter.AssignUnitNumbers;
        end;

        if frmModflow.cbETS.Checked
          and frmModflow.cbETSRetain.Checked then
        begin
          TEtsWriter.AssignUnitNumbers;
        end;

        if UseAdvectionObservations then
        begin
          TAdvectionObservationWriter.AssignUnitNumbers;
        end;

        TOutputControlWriter.AssignUnitNumbers;

        if (frmModflow.cbRIV.Checked
          and frmModflow.cbRIVRetain.Checked) then
        begin
          TRiverPkgWriter.AssignUnitNumbers;
        end;

        if frmModflow.cbWEL.Checked
            and frmModflow.cbWELRetain.Checked then
        begin
          TWellPkgWriter.AssignUnitNumbers;
        end;

        if frmModflow.cbDRN.Checked
            and frmModflow.cbDRNRetain.Checked then
        begin
          TDrainPkgWriter.AssignUnitNumbers;
        end;

        if frmModflow.cbDRT.Checked
            and frmModflow.cbDRTRetain.Checked then
        begin
          TDrainReturnPkgWriter.AssignUnitNumbers;
        end;

        if frmModflow.cbGHB.Checked
            and frmModflow.cbGHBRetain.Checked then
        begin
          TGHBPkgWriter.AssignUnitNumbers;
        end;

        if UseFHB then
        begin
          TFHBPkgWriter.AssignUnitNumbers;
        end;

        if StreamUsed then
        begin
          TStrWriter.AssignUnitNumbers;
        end;

        if UseHYD then
        begin
          THydmodWriter.AssignUnitNumbers;
        end;

        if UseSFR then
        begin
          TStreamWriter.AssignUnitNumbers;
        end;

        if UseMNW then
        begin
          TMultiNodeWellWriter.AssignUnitNumbers;
        end;

        if UseMnw2 then
        begin
          TMnw2Writer.AssignUnitNumbers;
        end;

        if UseDaflow then
        begin
          TDaflowWriter.AssignUnitNumbers;
        end;









        if ContinueExport and ExportMt3dLinkInput then
        begin
          LinkWriter := TMt3dLinkWriter.Create;
          try
            LinkWriter.WriteFile(Root);
          finally
            LinkWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportSensitivity then
        begin
          SensitivityWriter := TSensitivityWriter.Create;
          try
            SensitivityWriter.WriteFile(Root);
          finally
            SensitivityWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportParamEst then
        begin
          ParamEstWriter := TParamEstWriter.Create;
          try
            ParamEstWriter.WriteFile(Root);
          finally
            ParamEstWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        // Write discretization files or initialize values used in other packages
        if ContinueExport and ExportDiscretization then
        begin
          DiscretizationWriter.WriteModflowDiscretizationFile
            (CurrentModelHandle, Root);
        end
        else
        begin

          if ElevationsNeeded then
          begin
            DiscretizationWriter.InitializeButDontWrite(CurrentModelHandle);
          end
          else
          begin
            DiscretizationWriter.SetVariables(CurrentModelHandle);
          end;
        end;
        frmProgress.pbOverall.StepIt;

        if ContinueExport and NeedToInitilizeGrid then
        begin
          frmProgress.lblPackage.Caption := 'Initializing Grid';
          GInitializeBlock(CurrentModelHandle,
            PChar(ModflowTypes.GetGridLayerType.ANE_LayerName), 0);

          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportCBDY then
        begin
          frmProgress.lblPackage.Caption := 'GWT: CBDY Package';
          GWT_CBDY_Writer := TGWT_CBDY_Writer.Create;
          try
            GWT_CBDY_Writer.WriteFile(CurrentModelHandle, DiscretizationWriter,
              Root);
          finally
            GWT_CBDY_Writer.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;


        if ContinueExport and UseIntegeratedMassTransport then
        begin
          ExportMt3dmsInput(CurrentModelHandle, Root, DiscretizationWriter);
        end;

        ChdWriter := nil;
        if ContinueExport and (ExportCHD or
          (UseChd and (ExportSpecHeadFluxObs or ExportBFLX))) then
        begin
          ChdWriter := TCHDPkgWriter.Create;
          if ExportCHD then
          begin
            ChdWriter.WriteFile(CurrentModelHandle, Root, DiscretizationWriter);
          end
          else
          begin
            ChdWriter.Evaluate(CurrentModelHandle, DiscretizationWriter);
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportSub then
        begin
          SubWriter := TSubsidenceWriter.Create;
          try
            SubWriter.WriteFile(CurrentModelHandle, Root, DiscretizationWriter);
          finally
            SubWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportSwt then
        begin
          SwtWriter := TSwtWriter.Create;
          try
            SwtWriter.WriteFile(CurrentModelHandle, Root, DiscretizationWriter);
          finally
            SwtWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and (ExportMultiplier or ExportZone or ExportBasic
          or ExportLPF or ExportBCF or ExportRCH or ExportEVT or ExportHeadObs
          or ExportAdvectionObs or ExportMoc3D or ExportSFR or ExportETS
          or ExportIBS or frmModflow.cbMOC3D.Checked or ExportSFR or ExportHUF
          or ReservoirUsed or LakeUsed or ExportVariableDensityFlow
          or ExportIPDA or ExportIPDL or ExportViscosity
          or ExportSpecHeadFluxObs or ExportMnw2) then
        begin
          MultiplierWriter := TMultiplierWriter.Create;
          ZoneWriter := TZoneWriter.Create;
          try
            if ContinueExport and ExportMultiplier then
            begin
              MultiplierWriter.WriteFile(CurrentModelHandle, Root,
                DiscretizationWriter);
            end
            else
            begin
              MultiplierWriter.SetData(CurrentModelHandle, Root,
                DiscretizationWriter);
            end;
            frmProgress.pbOverall.StepIt;

            if ContinueExport and ExportZone then
            begin
              ZoneWriter.WriteFile(CurrentModelHandle, Root,
                DiscretizationWriter);
            end
            else
            begin
              ZoneWriter.EvaluateZones(CurrentModelHandle, Root,
                DiscretizationWriter);
            end;
            frmProgress.pbOverall.StepIt;

            if ContinueExport and (ExportBasic or ExportLPF or ExportBCF
              or ExportHUF or ExportRCH or ExportIBS
              or ExportEVT or ExportHeadObs or ExportAdvectionObs or LakeUsed
              or ReservoirUsed or ExportSpecHeadFluxObs
              or frmModflow.cbMOC3D.Checked
              or ExportETS or ExportSFR or ExportVariableDensityFlow
              or ExportIPDA or ExportViscosity or ExportMnw2) then
            begin
              BasicPkgWriter := TBasicPkgWriter.Create;

              if InitializeBasic then
              begin
                BasicPkgWriter.InitializeAll(CurrentModelHandle,
                  DiscretizationWriter);

                if ContinueExport and LakeUsed then
                begin
                  LakeWriter := TLakeWriter.Create;
                  if ExportLak then
                  begin
                    LakeWriter.WriteFile2000(CurrentModelHandle, Root,
                      DiscretizationWriter, BasicPkgWriter);
                  end
                  else if ExportBCF or ExportLPF or ExportSFR then
                  begin
                    LakeWriter.InitializeArrays(CurrentModelHandle,
                      DiscretizationWriter, BasicPkgWriter, True);
                  end;
                  frmProgress.pbOverall.StepIt;
                end;

                if ContinueExport and ReservoirUsed then
                begin
                  ReservoirWriter := TReservoirWriter.Create;
                  if ExportRES then
                  begin
                    ReservoirWriter.WriteFile2000(CurrentModelHandle, Root,
                      DiscretizationWriter, BasicPkgWriter);
                  end
                  else if ExportBCF or ExportLPF then
                  begin
                    ReservoirWriter.InitializeArrays(CurrentModelHandle,
                      DiscretizationWriter, BasicPkgWriter, True);
                  end;
                  frmProgress.pbOverall.StepIt;
                end;

                if ContinueExport and ExportBasic then
                begin
                  BasicPkgWriter.WriteFile(CurrentModelHandle, Root,
                    DiscretizationWriter);
                end;
              end
              else
              begin
                // Initialize IBOUND array
                BasicPkgWriter.InitializeButDontWrite
                  (CurrentModelHandle, DiscretizationWriter);
              end;
              frmProgress.pbOverall.StepIt;

              if ShowWarnings and ContinueExport and ElevationsNeeded then
              begin
                DiscretizationWriter.CheckElevations(BasicPkgWriter);
                frmProgress.pbOverall.StepIt;
              end;

              if ContinueExport and ExportIPDA then
              begin
                IpdaWriter := TIpdaWriter.Create;
                try
                  IpdaWriter.WriteFile(CurrentModelHandle,
                    DiscretizationWriter, BasicPkgWriter, Root);
                finally
                  IpdaWriter.Free;
                end;
                frmProgress.pbOverall.StepIt;
              end;

              if ContinueExport and ExportIPDL then
              begin
                IpdlWriter := TIpdlWriter.Create;
                try
                  IpdlWriter.WriteFile(CurrentModelHandle,
                    DiscretizationWriter, Root);
                finally
                  IpdlWriter.Free;
                end;
                frmProgress.pbOverall.StepIt;
              end;

              if ContinueExport then
              begin
                if (frmModflow.rgFlowPackage.ItemIndex = 2) then
                begin
                  if ExportHUF or ExportHeadObs then
                  begin
                    HUF_Writer := THUF_Writer.Create;
                    try
                      if ExportHUF then
                      begin
                        HUF_Writer.WriteFile(CurrentModelHandle, Root,
                          DiscretizationWriter, BasicPkgWriter, ZoneWriter,
                          MultiplierWriter, LakeWriter, ReservoirWriter);
                      end;
                      frmProgress.pbOverall.StepIt;
                      if ExportHeadObs then
                      begin
                        ExportHeadObservations(HUF_Writer, BasicPkgWriter);
                      end;
                    finally
                      HUF_Writer.Free;
                    end;
                  end;
                end
                else if (frmModflow.rgFlowPackage.ItemIndex = 1) then
                begin
                  if ExportLPF or ExportHeadObs then
                  begin
                    LayerPropertyWriter := TLayerPropertyWriter.Create;
                    try
                      if ExportLPF then
                      begin
                        LayerPropertyWriter.WriteFile(CurrentModelHandle,
                          Root, DiscretizationWriter, BasicPkgWriter,
                          ZoneWriter, MultiplierWriter, LakeWriter,
                          ReservoirWriter);
                      end
                      else
                      begin
                        if ExportHeadObs then
                        begin
                          LayerPropertyWriter.SetHK(CurrentModelHandle,
                            DiscretizationWriter, BasicPkgWriter, ZoneWriter,
                            MultiplierWriter)
                        end;
                      end;
                      frmProgress.pbOverall.StepIt;
                      if ExportHeadObs then
                      begin
                        ExportHeadObservations(LayerPropertyWriter,
                          BasicPkgWriter);
                      end;
                    finally
                      LayerPropertyWriter.Free;
                    end;
                  end;
                end
                else
                begin
                  if ExportBCF or ExportHeadObs then
                  begin
                    BCFWriter := TBCFWriter.Create;
                    try
                      if ExportBCF then
                      begin
                        BCFWriter.WriteFile(CurrentModelHandle, Root,
                          DiscretizationWriter, BasicPkgWriter, LakeWriter,
                          ReservoirWriter);
                      end
                      else
                      begin
                        if ExportHeadObs then
                        begin
                          BCFWriter.SetHY(CurrentModelHandle,
                            DiscretizationWriter, BasicPkgWriter);
                        end;
                      end;
                      frmProgress.pbOverall.StepIt;
                      if ExportHeadObs then
                      begin
                        ExportHeadObservations(BCFWriter, BasicPkgWriter);
                      end;
                    finally
                      BCFWriter.Free;
                    end;
                  end;
                end;
              end;

              if ContinueExport and ExportVariableDensityFlow then
              begin
                VDF_Writer := TVariableDensityWriter.Create;
                try
                  VDF_Writer.WriteFile(CurrentModelHandle, Root,
                    DiscretizationWriter, BasicPkgWriter);
                finally
                  VDF_Writer.Free;
                end;
                frmProgress.pbOverall.StepIt;
              end;

              if ContinueExport and ExportViscosity then
              begin
                ViscosityWriter := TSeawatViscosityWriter.Create;
                try
                  ViscosityWriter.WriteFile(CurrentModelHandle, Root,
                    DiscretizationWriter, BasicPkgWriter);
                finally
                  ViscosityWriter.Free;
                end;
                frmProgress.pbOverall.StepIt;
              end;

              if ContinueExport and ExportRCH then
              begin
                RechargeWriter := TRechargeWriter.Create;
                try
                  RechargeWriter.WriteFile(CurrentModelHandle, Root,
                    DiscretizationWriter, BasicPkgWriter);
                finally
                  RechargeWriter.Free;
                end;
                frmProgress.pbOverall.StepIt;
              end;

              if ContinueExport and ExportIBS then
              begin
                IBSWriter := TIBSWriter.Create;
                try
                  IBSWriter.WriteFile(CurrentModelHandle, Root,
                    DiscretizationWriter, BasicPkgWriter);
                finally
                  IBSWriter.Free;
                end;
                frmProgress.pbOverall.StepIt;
              end;

              if ContinueExport and ExportEVT then
              begin
                EvapWriter := TEvapWriter.Create;
                try
                  EvapWriter.WriteFile(CurrentModelHandle, Root,
                    DiscretizationWriter, BasicPkgWriter);
                finally
                  EvapWriter.Free;
                end;
                frmProgress.pbOverall.StepIt;
              end;

              if ContinueExport and ExportETS then
              begin
                EtsWriter := TEtsWriter.Create;
                try
                  EtsWriter.WriteFile(CurrentModelHandle, Root,
                    DiscretizationWriter, BasicPkgWriter);
                finally
                  EtsWriter.Free;
                end;
                frmProgress.pbOverall.StepIt;
              end;

              if ContinueExport and ExportAdvectionObs then
              begin
                AdvObsWriter := TAdvectionObservationWriter.Create;
                try
                  AdvObsWriter.WriteFile(CurrentModelHandle, Root,
                    DiscretizationWriter, BasicPkgWriter);
                finally
                  AdvObsWriter.Free;
                end;
                frmProgress.pbOverall.StepIt;
              end;

            end;
          finally
            MultiplierWriter.Free;
            ZoneWriter.Free;
          end;
        end;

        if ContinueExport and ExportSFR then
        begin
          if (LakeWriter = nil) and LakeUsed then
          begin
            LakeWriter := TLakeWriter.Create;
            LakeWriter.EvaluateLayer(True, BasicPkgWriter);
          end;

          StreamWriter := TStreamWriter.Create;
          StreamWriter.WriteFile(Root, DiscretizationWriter, LakeWriter);

          frmProgress.pbOverall.StepIt;
        end;



        if ContinueExport and ExportOutputControl then
        begin
          OutputControlWriter := TOutputControlWriter.Create;
          try
            OutputControlWriter.WriteFile(Root);
          finally
            OutputControlWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and (ExportRiv or ExportRiverObs) then
        begin
          RiverWriter := TRiverPkgWriter.Create;
          if ExportRiv then
          begin
            RiverWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter);
          end
          else
          begin
            RiverWriter.Evaluate(CurrentModelHandle, DiscretizationWriter);
          end;

          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportWEL then
        begin
          WellWriter := TWellPkgWriter.Create;
          WellWriter.WriteFile(CurrentModelHandle, Root, DiscretizationWriter);
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and (ExportDRN or ExportDrainObs) then
        begin
          DrainWriter := TDrainPkgWriter.Create;
          if ExportDRN then
          begin
            DrainWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter);
          end
          else
          begin
            DrainWriter.Evaluate(CurrentModelHandle, DiscretizationWriter);
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and (ExportDRT or ExportDrainReturnObs) then
        begin
          DrainReturnWriter := TDrainReturnPkgWriter.Create;
          if ExportDRT then
          begin
            DrainReturnWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter);
          end
          else
          begin
            DrainReturnWriter.Evaluate(CurrentModelHandle,
              DiscretizationWriter);
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and (ExportGHB or ExportGHBObs) then
        begin
          GHBPkgWriter := TGHBPkgWriter.Create;
          if ExportGHB then
          begin
            GHBPkgWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter);
          end
          else
          begin
            GHBPkgWriter.Evaluate(CurrentModelHandle, DiscretizationWriter);
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportHFB then
        begin
          HFBPkgWriter := THFBPkgWriter.Create;
          try
            HFBPkgWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter);

            if ExportMOC3D then
            begin
              HFBPkgWriter.WriteCHFB_File(CurrentModelHandle, Root);
            end;

          finally
            HFBPkgWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        FHBPkgWriter := nil;
        if ContinueExport and (ExportFHB or (UseFHB and ExportBFLX)) then
        begin
          FHBPkgWriter := TFHBPkgWriter.Create;
          if ExportFHB then
          begin
            FHBPkgWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter);
          end
          else
          begin
            FHBPkgWriter.Evaluate(CurrentModelHandle,
              DiscretizationWriter);
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and (ExportStr or ExportStrObs or ExportHYD
          or ExportGWM_STRMCON or ExportGWM_STAVAR) then
        begin
          StrWriter := TStrWriter.Create;
          try
            if ExportStr then
            begin
              StrWriter.WriteFile(Root, DiscretizationWriter);
              frmProgress.pbOverall.StepIt;
            end
            else if ExportStrObs or (ExportHYD and StreamUsed)
              or (ExportGWM_STRMCON and StreamUsed)
              or (ExportGWM_STAVAR and StreamUsed) then
            begin
              StrWriter.Evaluate(DiscretizationWriter);
            end;
            if ContinueExport and ExportStrObs then
            begin
              StrWriter.WriteObservationFile(Root);
              frmProgress.pbOverall.StepIt;
            end;

            if ContinueExport and ExportHYD then
            begin
              HydmodWriter := THydmodWriter.Create;
              try
                if StreamUsed then
                begin
                  HydmodWriter.WriteFile(CurrentModelHandle, Root,
                    DiscretizationWriter, StrWriter);
                end
                else
                begin
                  HydmodWriter.WriteFile(CurrentModelHandle, Root,
                    DiscretizationWriter, nil);
                end;
              finally
                HydmodWriter.Free;
              end;
              frmProgress.pbOverall.StepIt;
            end;

            if ContinueExport and ExportGWM_STRMCON then
            begin
              if (StreamWriter = nil) and UseSFR then
              begin
                StreamWriter := TStreamWriter.Create;
                StreamWriter.InitializeGages(DiscretizationWriter, LakeWriter);
              end;

              StreamConstrainstWriter := TStreamConstrainstWriter.Create;
              try
                StreamConstrainstWriter.WriteFile(CurrentModelHandle, Root,
                    DiscretizationWriter, StrWriter, StreamWriter);
              finally
                StreamConstrainstWriter.Free;
              end;
              frmProgress.pbOverall.StepIt;
            end;
          finally
//            StrWriter.Free;
          end;
        end;

        if ContinueExport and ExportGHBObs then
        begin
          GHBObservationWriter := TGHBObservationWriter.Create;
          try
            GHBObservationWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter, GHBPkgWriter, nil, nil);
          finally
            GHBObservationWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportDrainObs then
        begin
          DrainObservationWriter := TDrainObservationWriter.Create;
          try
            DrainObservationWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter, DrainWriter, nil, nil);
          finally
            DrainObservationWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportDrainReturnObs then
        begin
          DrainReturnObservationWriter := TDrainReturnObservationWriter.Create;
          try
            DrainReturnObservationWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter, DrainReturnWriter, nil, nil);
          finally
            DrainReturnObservationWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportRiverObs then
        begin
          RiverObservationWriter := TRiverObservationWriter.Create;
          try
            RiverObservationWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter, RiverWriter, nil, nil);
          finally
            RiverObservationWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportSpecHeadFluxObs then
        begin
          HeadFluxObservationWriter := THeadFluxObservationWriter.Create;
          try
            HeadFluxObservationWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter, nil, BasicPkgWriter, ChdWriter);
          finally
            HeadFluxObservationWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportBFLX then
        begin
          BFLX_Writer := TBFLX_Writer.Create(DiscretizationWriter,
            CurrentModelHandle);
          try
            BFLX_Writer.WriteFile(Root, DiscretizationWriter, ChdWriter,
              FHBPkgWriter);
          finally
            BFLX_Writer.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;


        if ContinueExport and ExportSolver then
        begin
          case frmModflow.rgSolMeth.ItemIndex of
            Ord(scSIP):
              begin
                SIP_Writer := TSIP_Writer.Create;
                try
                  SIP_Writer.WriteFile(Root);
                finally
                  SIP_Writer.Free;
                end;
              end;
            Ord(scDE4):
              begin
                DE4_Writer := TDE4_Writer.Create;
                try
                  DE4_Writer.WriteFile(Root);
                finally
                  DE4_Writer.Free;
                end;
              end;
            Ord(scPCG2):
              begin
                PCG2_Writer := TPCG2_Writer.Create;
                try
                  PCG2_Writer.WriteFile(Root);
                finally
                  PCG2_Writer.Free;
                end;
              end;
            Ord(scSOR):
              begin
                SOR_Writer := TSOR_Writer.Create;
                try
                  SOR_Writer.WriteFile(Root);
                finally
                  SOR_Writer.Free;
                end;
              end;
            Ord(scLMG):
              begin
                Lmd_Link_Writer := TLmd_Link_Writer.Create;
                try
                  Lmd_Link_Writer.WriteFile(Root);
                finally
                  Lmd_Link_Writer.Free;
                end;
              end;
            Ord(scGMG):
              begin
                GMG_Writer := TGMG_Writer.Create;
                try
                  GMG_Writer.WriteFile(Root);
                finally
                  GMG_Writer.Free;
                end;
              end;
          else
            begin
              if ShowWarnings then
              begin
                AString := 'Error: no solver selected.';
                frmProgress.reErrors.Lines.Add(AString);
                ErrorMessages.Add('');
                ErrorMessages.Add(AString);
              end;
            end;
          end;

          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportGage then
        begin
          if (LakeWriter = nil) and LakeUsed then
          begin
            LakeWriter := TLakeWriter.Create;
            LakeWriter.InitializeGages(CurrentModelHandle);
            if UseUzf then
            begin
              LakeWriter.EvaluateLayer(True, BasicPkgWriter);
            end;
          end;

          if (StreamWriter = nil) and UseSFR then
          begin
            StreamWriter := TStreamWriter.Create;
            StreamWriter.InitializeGages(DiscretizationWriter, LakeWriter);
          end;

          GageWriter := TGageWriter.Create;
          try
            GageWriter.WriteFile(Root);
          finally
            GageWriter.Free;
          end;
        end;

        if ContinueExport and UseUzf then
        begin
          if (LakeWriter = nil) and LakeUsed then
          begin
            LakeWriter := TLakeWriter.Create;
            LakeWriter.EvaluateLayer(True, BasicPkgWriter);
          end;
          if (StreamWriter = nil) and UseSFR then
          begin
            StreamWriter := TStreamWriter.Create;
            StreamWriter.Evaluate(DiscretizationWriter, LakeWriter);
          end;

          UzfWriter := TUzfWriter.Create;
          if ContinueExport then
          begin
            if ExportUzf then
            begin
              UzfWriter.WriteFile(CurrentModelHandle, Root,
                DiscretizationWriter, BasicPkgWriter, LakeWriter, StreamWriter)
            end
            else
            begin
              UzfWriter.EvaluateGages(DiscretizationWriter, BasicPkgWriter,
                LakeWriter, StreamWriter)
            end;

          end
        end;




        if ContinueExport and ExportMNW then
        begin
          MNW_Writer := TMultiNodeWellWriter.Create;
          try
            MNW_Writer.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter);
          finally
            MNW_Writer.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportMnw2 then
        begin
          Mnw2Writer := TMnw2Writer.Create;
          try
            Mnw2Writer.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter, BasicPkgWriter);
          finally
            Mnw2Writer.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportDaflow then
        begin
          DaflowWriter := TDaflowWriter.Create;
          try
            DaflowWriter.WriteFiles(Root, DiscretizationWriter);
          finally
            DaflowWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and frmModflow.cbMOC3D.Checked then
        begin
          MOC3D_Writer := TMOC3D_Writer.Create;
          try
            if ExportMoc3d then
            begin
              MOC3D_Writer.WriteFiles(Root, DiscretizationWriter,
                BasicPkgWriter);
            end
            else
            begin
              MOC3D_Writer.EvaluateObservations(DiscretizationWriter,
                BasicPkgWriter);
            end;
            MOC3D_ObservationCount := MOC3D_Writer.NumberOfObservations;
          finally
            MOC3D_Writer.Free;
          end;
        end;

        if ExportPTOB then
        begin
          ParticleObservationWriter := TGwtParticleObservationWriter.Create;
          try
            ParticleObservationWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter);
          finally
            ParticleObservationWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ExportCCBD then
        begin
          ConstConcWriter := TGwtConstConcWriter.Create;
          try
            ConstConcWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter);
          finally
            ConstConcWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ExportVBAL then
        begin
          VbalWriter := TGwtVBalWriter.Create;
          try
            VbalWriter.WriteFile(CurrentModelHandle, Root,
              DiscretizationWriter);
          finally
            VbalWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportGWM_STAVAR then
        begin
          if (StreamWriter = nil) and UseSFR then
          begin
            StreamWriter := TStreamWriter.Create;
            StreamWriter.Evaluate(DiscretizationWriter, LakeWriter);
          end;
          GWM_StateVarWriter := TGWM_StateWriter.Create;
          try
            GWM_StateVarWriter.WriteFile(CurrentModelHandle, Root,
                DiscretizationWriter, StreamWriter, StrWriter)
          finally
            GWM_StateVarWriter.Free;
          end;
        end;

        if ContinueExport and (ExportGWM_DecVar or ExportGWM_VARCON
          or ExportGWM_SOLN) then
        begin
          GWM_DecAndConstWriter :=
            TWriteGWM_DecisionVariablesAndConstraintsWriter.Create;
          try
            if ExportGWM_DecVar and ExportGWM_VARCON then
            begin
              GWM_DecAndConstWriter.WriteFiles(CurrentModelHandle, Root,
                DiscretizationWriter);
            end
            else if ExportGWM_DecVar or ExportGWM_VARCON then
            begin
              if ExportGWM_DecVar then
              begin
                GWM_DecAndConstWriter.WriteDecVarFile(CurrentModelHandle,
                  Root, DiscretizationWriter);
              end
              else
              begin
                GWM_DecAndConstWriter.WriteConstraintFile(CurrentModelHandle,
                  Root, DiscretizationWriter);
              end;
            end
            else
            begin
              GWM_DecAndConstWriter.PartialEvaluate(CurrentModelHandle,
                DiscretizationWriter);
            end;
            frmProgress.pbOverall.StepIt;

            if ContinueExport and ExportGWM_SOLN then
            begin
              SolutionWriter := TSolutionWriter.Create;
              try
                SolutionWriter.WriteFile(Root, GWM_DecAndConstWriter);
              finally
                SolutionWriter.Free;
              end;
            end;
            frmProgress.pbOverall.StepIt;

          finally
            GWM_DecAndConstWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportGWM_OBJFNC then
        begin
          GWM_ObjectiveFuncWriter := TGWM_ObjectiveFunctionWriter.Create;
          try
            GWM_ObjectiveFuncWriter.WriteFile(Root);
          finally
            GWM_ObjectiveFuncWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportGWM_SUMCON then
        begin
          SummaryConstraintsWriter := TSummaryConstraintsWriter.Create;
          try
            SummaryConstraintsWriter.WriteFile(Root);
          finally
            SummaryConstraintsWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport and ExportGWM_HEDCON then
        begin
          GWM_HeadConstraintsWriter := TGWM_HeadConstraintsWriter.Create;
          try
            GWM_HeadConstraintsWriter.WriteFile(CurrentModelHandle,
              Root, DiscretizationWriter);
          finally
            GWM_HeadConstraintsWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

        if ContinueExport then
        begin
          NameFileWriter := TNameFileWriter.Create;
          try
            NameFileWriter.WriteObservationFile(Root);
            NameFileWriter.WriteNameFile(Root, UzfWriter);
            NameFileWriter.WriteBFFile(Root);
            BatchFileName := NameFileWriter.WriteBatchFile(CurrentModelHandle,
              frmModflow.cbCalibrate.Checked, Root);

            if ExportMOC3D then
            begin
              NameFileWriter.WriteMOC3DNameFile(Root, MOC3D_ObservationCount);
            end;

            if UseGWM then
            begin
              NameFileWriter.WriteGWM_NameFile(Root);
            end;

          finally
            NameFileWriter.Free;
          end;
          frmProgress.pbOverall.StepIt;
        end;

      finally
        StrWriter.Free;
        DiscretizationWriter.Free;
        ChdWriter.Free;
        FHBPkgWriter.Free;
        GListFreeBlock;
        LakeWriter.Free;
        StreamWriter.Free;
        ReservoirWriter.Free;
        RiverWriter.Free;
        WellWriter.Free;
        DrainWriter.Free;
        DrainReturnWriter.Free;
        GHBPkgWriter.Free;
        BasicPkgWriter.Free;
        UzfWriter.Free;
        frmProgress.TestDuplicateObservationNames;

      end;

      if ContinueExport then
      begin
        if frmModflow.rbRun.Checked or frmModflow.rbRunSeawat.Checked
          or frmModflow.rbRunGWM.Checked then
        begin
          ExecuteBatchFile(BatchFileName);
        end;
      end;

    except
      on E: EInvalidType do
      begin
        HandleException(E);
        raise;
      end;
      on E: EInOutError do
      begin
        Beep;
        if (E.ErrorCode = 32) or (E.ErrorCode = 103) or (E.ErrorCode = 105) then
        begin
          MessageDlg('Error: sharing violation.  Attempt to create a file '
            + 'failed because the file is already open in another application '
            + 'that does not allow file sharing.', mtError, [mbOK], 0);
        end
        else if E.ErrorCode = 101 then
        begin
          MessageDlg('Error: Disk full.', mtError, [mbOK], 0);
        end
        else
        begin
          raise;
        end;

      end;
      on E: EStreamError do
      begin
        ErrorMessages.Add('');
        ErrorMessages.Add(E.Message);
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
      on E: Exception do
      begin
        ErrorMessages.Add('');
        ErrorMessages.Add('Unexpected Error: Contact PIE developer');
        ErrorMessages.Add(E.Message);
        raise
      end;
    end;
  finally
    if ShowWarnings and (ErrorMessages.Count > 0) then
    begin
      ErrorFileName := GetCurrentDir + '\' + Root + '.err';
      ShowMessage('Errors or warnings generated during export. Error Messages '
        + 'will be saved in ' + ErrorFileName + '.');
      ErrorMessages.SaveToFile(ErrorFileName);
    end;
    ErrorMessages.Clear;
    ShowWarnings := False;
    FreefrmProgress;
  end;
end;

procedure GWriteModflow2000(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_BOOL;
begin
  result := False;
  try
    if EditWindowOpen then
    begin
      MessageDlg('You can not export a ' +
        ' project if an edit box is open. Try again after'
        + ' correcting this problems.', mtError, [mbOK], 0);
    end
    else // if EditWindowOpen
    begin
      EditWindowOpen := True;
      try // try 1
        begin
          frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
            as ModflowTypes.GetModflowFormType;

          if frmMODFLOW.rbYcint.Checked then
          begin
            WriteYcintFiles(funHandle, frmModflow.adeFileName.Text);
          end
          else if frmMODFLOW.rbBeale.Checked then
          begin
            WriteBealeFiles(funHandle, frmModflow.adeFileName.Text);
          end
          else
          begin
            WriteModflowFiles(funHandle, frmModflow.adeFileName.Text);
          end;

          result := True;
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end; // try 1
    end; // if EditWindowOpen else
  except on E: Exception do
    begin
      result := False;
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

end.

