unit ReadOldMT3D;

interface

{ReadOldMT3D defines a function that reads non-spatial data saved by the
 Argus MODFLOW/MT3D PIE. The data related to MT3D is discarded.}

uses Stdctrls, SysUtils, Dialogs;

function IsOldMT3DFile(DataToRead : string) : boolean ;

implementation

uses ReadOldUnit, Variables, ModflowUnit;

function IsOldMT3DFile(DataToRead : string) : boolean ;
var
  VersionString : string;
  Version : integer;
  ArgusVersion : integer;
  RowIndex : Integer;
  ABoolean : boolean;
  AnInteger : Integer;
  EndUnit : integer;
  NumberOfUnits : integer;
begin
  VersionString := Copy(DataToRead,1,12);
  result := (Pos('ArgusMODFLOW',VersionString) > 0);
  if result then
  begin
    DataToRead := Copy(DataToRead,14,Length(DataToRead));
    Version := StrToInt(ReadInteger(DataToRead));
    ArgusVersion := StrToInt(ReadInteger(DataToRead));
    with frmMODFLOW do
    begin
      if Version > 1 then
      begin
        adeFileName.Text := ReadString(DataToRead)
      end;
      // Stress periods Parameters
      edNumPerEnter(edNumPer);
      edNumPer.Text := ReadInteger(DataToRead);
      edNumPerExit(edNumPer);
      For RowIndex := 1 to StrToInt(edNumPer.Text) do
      begin
        sgTime.Cells[Ord(tdLength), RowIndex] := ReadFloat(DataToRead);
        sgTime.Cells[Ord(tdNumSteps), RowIndex] := ReadFloat(DataToRead);
        sgTime.Cells[Ord(tdMult), RowIndex] := ReadFloat(DataToRead);
        sgTimeSetEditText(frmMODFLOW,Ord(tdLength),RowIndex,
          sgTime.Cells[Ord(tdLength), RowIndex]);
        if ArgusVersion > 0 then
        begin
          {sgMT3DTime.Cells[Ord(tdmStepSize),RowIndex] :=} ReadFloat(DataToRead);
          {sgMT3DTime.Cells[Ord(tdmMaxSteps),RowIndex] :=} ReadInteger(DataToRead);
          if ReadInteger(DataToRead) = '1' then
          begin
            {sgMT3DTime.Cells[Ord(tdmCalculated),RowIndex] := 'Yes'}
          end
          else
          begin
            {sgMT3DTime.Cells[Ord(tdmCalculated),RowIndex] := 'No' }
          end;
        end;
      end;

      // Layer Parameters
      edNumUnitsEnter(edNumUnits);
      edNumUnits.Text := ReadInteger(DataToRead);
      edNumUnitsExit(edNumUnits);

      NumberOfUnits := StrToInt(edNumUnits.Text);
      For RowIndex := 1 to NumberOfUnits  do
      begin
//        sgcUnits.Cells[Ord(udName), RowIndex] := ReadString(DataToRead);
//        dtabGeol.CellSet.Item[RowIndex, Ord(uiName)].Value := ReadString(DataToRead);
        dgGeol.Cells[Ord(nuiName), RowIndex] := ReadString(DataToRead);
        ABoolean := ReadBoolean(DataToRead);
        if ABoolean
        then
          begin
//            sgcUnits.Cells[Ord(udSim), RowIndex] := 'No';
//            dtabGeol.CellSet.Item[RowIndex, Ord(uiSim)].Value  := 'Yes';
            dgGeol.Cells[Ord(nuiSim), RowIndex]
              := dgGeol.Columns[Ord(nuiSim)].Picklist.Strings[1];
          end
        else
          begin
//            sgcUnits.Cells[Ord(udSim), RowIndex] := 'Yes'
//            dtabGeol.CellSet.Item[RowIndex, Ord(uiSim)].Value  := 'No';
            dgGeol.Cells[Ord(nuiSim), RowIndex]
              := dgGeol.Columns[Ord(nuiSim)].Picklist.Strings[0];
          end;
//        sgUnitsSelectCell(nil, Ord(udSim), RowIndex, ABoolean);

//        AComboBox := sgcUnits.Objects[Ord(udTrans), RowIndex] as TComboBox;
//        AComboBox.ItemIndex := StrToInt(ReadInteger(DataToRead));
//        dtabGeol.CellSet.Item[RowIndex, Ord(uiTrans)].Value := StrToInt(ReadInteger(DataToRead));

        dgGeol.Cells[Ord(nuiTrans),RowIndex] :=
            dgGeol.Columns[Ord(nuiTrans)].Picklist.
            Strings[StrToInt(ReadInteger(DataToRead))];

        AnInteger := StrToInt(ReadInteger(DataToRead));
//        AComboBox := sgcUnits.Objects[Ord(udType), RowIndex] as TComboBox;
        if AnInteger = 0
        then
          begin
//           AComboBox.ItemIndex := AnInteger;
//           dtabGeol.CellSet.Item[RowIndex, Ord(uiType)].Value := 'Confined (0)';
           dgGeol.Cells[Ord(nuiType),RowIndex]
             := dgGeol.Columns[Ord(nuiType)].Picklist.Strings[0];
          end
        else if AnInteger = 1
        then
          begin
//           AComboBox.ItemIndex := AnInteger;
//           dtabGeol.CellSet.Item[RowIndex, Ord(uiType)].Value := 'Unconfined (1)';
           dgGeol.Cells[Ord(nuiType),RowIndex]
             := dgGeol.Columns[Ord(nuiType)].Picklist.Strings[1];
          end
        else
          begin
//           AComboBox.ItemIndex := 2;
//           dtabGeol.CellSet.Item[RowIndex, Ord(uiType)].Value := 'Convertible (3)';
           dgGeol.Cells[Ord(nuiType),RowIndex]
             := dgGeol.Columns[Ord(nuiType)].Picklist.Strings[3];
          end;

//        sgcUnits.Cells[Ord(udAnis), RowIndex] := ReadFloat(DataToRead);
//        dtabGeol.CellSet.Item[RowIndex, Ord(uiAnis)].Value := ReadFloat(DataToRead);
        dgGeol.Cells[Ord(nuiAnis),RowIndex] := ReadFloat(DataToRead);

//        sgcUnits.Cells[Ord(udVertDisc), RowIndex] := ReadInteger(DataToRead);
//        dtabGeol.CellSet.Item[RowIndex, Ord(uiVertDisc)].Value := ReadInteger(DataToRead);
        dgGeol.Cells[Ord(nuiVertDisc),RowIndex] := ReadInteger(DataToRead);

        if ArgusVersion > 0 then
        begin
            {sgDispersion.Cells[Ord(ddmHorDisp),RowIndex] :=} ReadFloat(DataToRead);
            {sgDispersion.Cells[Ord(ddmVertDisp),RowIndex] :=} ReadFloat(DataToRead);
            {sgDispersion.Cells[Ord(ddmMolDiffCoef),RowIndex] :=} ReadFloat(DataToRead);
            {sgReaction.Cells[Ord(rdmBulkDensity),RowIndex] :=} ReadFloat(DataToRead);;
            {sgReaction.Cells[Ord(rdmSorpConst1),RowIndex] :=} ReadFloat(DataToRead);;
            {sgReaction.Cells[Ord(rdmSorpConst2),RowIndex] :=} ReadFloat(DataToRead);;
            {sgReaction.Cells[Ord(rdmRateConstDiss),RowIndex] :=} ReadFloat(DataToRead);;
            {sgReaction.Cells[Ord(rdmRateConstSorp),RowIndex] :=} ReadFloat(DataToRead);;

        end;
      end;
//      sgcUnitsExit(nil);
      dgGeolExit(nil);


	// Project Parameters
      edProjectName.Text := ReadString(DataToRead);
      edDate.Text := ReadString(DataToRead);
      memoDescription.Lines.Add(ReadString(DataToRead));

      // FIL Parameters

      cbRCH.Checked := ReadBoolean(DataToRead);
      cbRCHClick(nil);
      cbRIV.Checked := ReadBoolean(DataToRead);
      cbRIVClick(nil);
      cbWEL.Checked := ReadBoolean(DataToRead);
      cbWELClick(nil);
      cbDRN.Checked := ReadBoolean(DataToRead);
      cbDRNClick(nil);
      cbGHB.Checked := ReadBoolean(DataToRead);
      cbGHBClick(nil);
      cbEVT.Checked := ReadBoolean(DataToRead);
      cbEVTClick(nil);
      rgSolMeth.ItemIndex := StrToInt(ReadInteger(DataToRead));
      if rgSolMeth.ItemIndex = 1 then
      begin
        rgSolMeth.ItemIndex := 2;
      end
      else if rgSolMeth.ItemIndex = 2 then
      begin
        rgSolMeth.ItemIndex := 1;
      end;
      rgSolMethClick(nil);

      if Version > 1
      then
        begin
          cbMOC3D.Checked := ReadBoolean(DataToRead);
          ReadInteger(DataToRead);
        end
      else
        begin
          cbMOC3D.Checked := False;
        end;
      cbMOC3DClick(nil);

      comboExportHead.ItemIndex := StrToInt(ReadInteger(DataToRead));
      comboExportHeadChange(nil);
      comboExportDrawdown.ItemIndex := StrToInt(ReadInteger(DataToRead));
      comboExportDrawdownChange(nil);

      cbFlowRiv.Checked := ReadBoolean(DataToRead);
      cbFlowRCH.Checked := ReadBoolean(DataToRead);
      cbFlowWel.Checked := ReadBoolean(DataToRead);
      cbFlowDrn.Checked := ReadBoolean(DataToRead);
      cbFlowEVT.Checked := ReadBoolean(DataToRead);
      cbFlowGHB.Checked := ReadBoolean(DataToRead);

      cbOneFlowFile.Checked := ReadBoolean(DataToRead);

      if ArgusVersion > 0
      then
        begin
          cbMOC3D.Checked := ReadBoolean(DataToRead);
          cbMOC3DClick(nil);
          {cbMT3D.Checked :=} ReadBoolean(DataToRead);
          {cbMT3DClick(nil);}
        end
      else
        begin
          {cbMT3D.Checked := False;
          cbMT3DClick(nil);}
        end;

      // BAS Parameters
      adeTitle1.Text := ReadString(DataToRead);
      adeTitle2.Text := ReadString(DataToRead);
      comboTimeUnits.ItemIndex := StrToInt(ReadInteger(DataToRead));

      if ReadString(DataToRead) = 'FREE'
      then
        begin
//          adeMiscOption.ItemIndex := 0;
          cbCHTOCH.Checked := False;
        end
      else
        begin
//          adeMiscOption.ItemIndex := 1;
          cbCHTOCH.Checked := True;
        end;
      comboIAPART.ItemIndex := StrToInt(ReadInteger(DataToRead));
      comboISTRT.ItemIndex := StrToInt(ReadInteger(DataToRead));
      adeHNOFLO.Text := ReadFloat(DataToRead);

      // OC Parameters

      cbFlowBudget.Checked := ReadBoolean(DataToRead);

      CalculateFlag(comboHeadPrintFreq, adeHeadPrintFreq, DataToRead );
      comboHeadPrintFreqChange(nil);
      CalculateFlag(comboDrawdownPrintFreq, adeDrawdownPrintFreq, DataToRead );
      comboDrawdownPrintFreqChange(nil);
      CalculateFlag(comboBudPrintFreq, adeBudPrintFreq, DataToRead );
      comboBudPrintFreqChange(nil);
      CalculateFlag(comboHeadExportFreq, adeHeadExportFreq, DataToRead );
      comboHeadExportFreqChange(nil);
      CalculateFlag(comboDrawdownExportFreq, adeDrawdownExportFreq, DataToRead );
      comboDrawdownExportFreqChange(nil);
      CalculateFlag(comboBudExportFreq, adeBudExportFreq, DataToRead );
      comboBudExportFreqChange(nil);

      // BCF Parameters
      comboSteady.ItemIndex := StrToInt(ReadInteger(DataToRead));
      cbFlowBCF.Checked := ReadBoolean(DataToRead);
      cbFlowClick(nil);
      adeHDRY.Text := ReadFloat(DataToRead);
      comboWetCap.ItemIndex := StrToInt(ReadInteger(DataToRead));
      comboWetCapChange(nil);
      adeWettingFact.Text := ReadFloat(DataToRead);
      adeWetIterations.Text := ReadInteger(DataToRead);
      comboWetEq.ItemIndex := StrToInt(ReadInteger(DataToRead));

      // RCH Parameters

      comboRchOpt.ItemIndex := StrToInt(ReadInteger(DataToRead))-1;
      comboRchSteady.ItemIndex := StrToInt(ReadInteger(DataToRead));

      // RIV Parameters
      comboRivSteady.ItemIndex := StrToInt(ReadInteger(DataToRead));

      // WEL Parameters
      comboWelSteady.ItemIndex := StrToInt(ReadInteger(DataToRead));

      // DRN Parameters
      comboDrnSteady.ItemIndex := StrToInt(ReadInteger(DataToRead));

      // EVT Parameters
      comboEvtSteady.ItemIndex := StrToInt(ReadInteger(DataToRead));
      comboEvtOption.ItemIndex := StrToInt(ReadInteger(DataToRead))-1;

      // GHB Parameters
      comboGhbSteady.ItemIndex := StrToInt(ReadInteger(DataToRead));

      if ArgusVersion > 2
      then
        begin
          comboCustomize.ItemIndex := StrToInt(ReadInteger(DataToRead));
          if comboCustomize.ItemIndex = -1 then
          begin
            comboCustomize.ItemIndex := 2;
          end;
        end
      else
        begin
          comboCustomize.ItemIndex := 0;
        end;


      // SOR Parameters
      adeSORMaxIter.Text := ReadInteger(DataToRead);
      adeSORAccl.Text := ReadFloat(DataToRead);
      adeSORConv.Text := ReadFloat(DataToRead);
      adeSORPri.Text := ReadInteger(DataToRead);

      // SIP Parameters
      adeSIPMaxIter.Text := ReadInteger(DataToRead);
      adeSIPNumParam.Text := ReadInteger(DataToRead);
      adeSIPAcclParam.Text := ReadFloat(DataToRead);
      adeSIPConv.Text := ReadFloat(DataToRead);
      comboSIPIterSeed.ItemIndex := StrToInt(ReadInteger(DataToRead));
      adeSIPIterSeed.Text := ReadFloat(DataToRead);
      adeSIPPrint.Text := FloatToStr(Round(StrToFloat(ReadFloat(DataToRead))));

      // PCG Parameters
      adePCGMaxOuter.Text := ReadInteger(DataToRead);
      adePCGMaxInner.Text := ReadInteger(DataToRead);
      comboPCGPrecondMeth.ItemIndex := StrToInt(ReadInteger(DataToRead))-1;
      adePCGMaxHeadChange.Text := ReadFloat(DataToRead);
      adePCGMaxResChange.Text := ReadFloat(DataToRead);
      adePCGRelax.Text := ReadFloat(DataToRead);
      comboPCGEigenValue.ItemIndex := StrToInt(ReadInteger(DataToRead))-1;
      adePCGPrintInt.Text := ReadInteger(DataToRead);
      comboPCGPrint.ItemIndex := StrToInt(ReadInteger(DataToRead));
      if ArgusVersion>1
      then
        begin
          adePCGDamp.Text := ReadFloat(DataToRead);
        end
      else
        begin
          adePCGDamp.Text := ReadInteger(DataToRead);
        end;

      // DE4 Parameters
      adeDE4MaxIter.Text := ReadInteger(DataToRead);
      adeDE4MaxUp.Text := ReadInteger(DataToRead);
      adeDE4MaxLow.Text := ReadInteger(DataToRead);
      adeDE4Band.Text := ReadInteger(DataToRead);
      comboDE4Freq.ItemIndex := StrToInt(ReadInteger(DataToRead))-1;
      comboDE4Print.ItemIndex := StrToInt(ReadInteger(DataToRead));
      adeDE4Accl.Text := ReadFloat(DataToRead);
      adeDE4Conv.Text := ReadFloat(DataToRead);
      adeDE4TimeStep.Text := ReadInteger(DataToRead);

      // MOC3D Parameters
      if Version > 1 then
      begin
        adeMOC3DLay1.Text := ReadInteger(DataToRead);
        adeMOC3DLay2.Text := ReadInteger(DataToRead);
        adeMOC3DRow1.Text := ReadInteger(DataToRead);
        adeMOC3DRow2.Text := ReadInteger(DataToRead);
        adeMOC3DCol1.Text := ReadInteger(DataToRead);
        adeMOC3DCol2.Text := ReadInteger(DataToRead);
        BottomMOC3DSubGridDistance := StrToFloat(adeMOC3DRow1.Text);
        TopMOC3DSubGridDistance := StrToFloat(adeMOC3DRow2.Text);
        LeftMOC3DSubGridDistance := StrToFloat(adeMOC3DCol1.Text);
        RightMOC3DSubGridDistance := StrToFloat(adeMOC3DCol2.Text);
        RecalculateSubgrid := True;
{        if cbMOC3D.Checked and RecalculateSubgrid then
        begin
          ShowMessage('You will need to select "PIEs|Edit Project Info" and '
            + 'then OK to update the MOC3D subgrid boundary');
        end;   }
        cbMOC3DNoDisp.Checked := ReadBoolean(DataToRead);
        adeMOC3DDecay.Text := ReadFloat(DataToRead);
        adeMOC3DDiffus.Text := ReadFloat(DataToRead);
        comboMOC3DInterp.ItemIndex := StrToInt(ReadInteger(DataToRead));
        adeMOC3DCnoflow.Text := ReadFloat(DataToRead);
        comboMOC3DReadRech.ItemIndex := -StrToInt(ReadInteger(DataToRead));
        comboMOC3DSaveWell.ItemIndex := StrToInt(ReadInteger(DataToRead));

        adeMOC3DMaxParticles.Text := ReadInteger(DataToRead);
        adeMOC3DMaxFrac.Text := ReadFloat(DataToRead);
        adeMOC3DLimitActiveCells.Text := ReadFloat(DataToRead);
        cbCustomParticle.Checked := ReadBoolean(DataToRead);
        cbCustomParticleClick(nil);
        edMOC3DInitParticles.Text := ReadInteger(DataToRead);

        For RowIndex := 1 to StrToInt(edMOC3DInitParticles.Text) do
        begin
          sgMOC3DParticles.Cells[Ord(pdLayer), RowIndex]
            := ReadFloat(DataToRead);
          sgMOC3DParticles.Cells[Ord(pdRow), RowIndex]
            := ReadFloat(DataToRead);
          sgMOC3DParticles.Cells[Ord(pdColumn), RowIndex]
            := ReadFloat(DataToRead);
        end;

        comboMOC3DConcFileType.ItemIndex := StrToInt(ReadInteger(DataToRead));
        comboMOC3DConcFreq.ItemIndex := StrToInt(ReadInteger(DataToRead));
        adeMOC3DConcFreq.Text := ReadInteger(DataToRead);
        comboMOC3DVelFileType.ItemIndex := StrToInt(ReadInteger(DataToRead));
        comboMOC3DVelFreq.ItemIndex := StrToInt(ReadInteger(DataToRead));
        adeMOC3DVelFreq.Text := ReadInteger(DataToRead);
        comboMOC3DDispFreq.ItemIndex := StrToInt(ReadInteger(DataToRead));
        adeMOC3DDispFreq.Text := ReadInteger(DataToRead);
        comboMOC3DPartFileType.ItemIndex := StrToInt(ReadInteger(DataToRead));
        comboMOC3DPartFreq.ItemIndex := StrToInt(ReadInteger(DataToRead));
        adeMOC3DPartFreq.Text := ReadInteger(DataToRead);

        EndUnit := StrToInt(ReadInteger(DataToRead)) + StrToInt(adeMOC3DLay1.Text) -1;  // moc number of units
        adeMOCNumLayers.Text := IntToStr(EndUnit);
        ReadFloat(DataToRead);    // MOC_CINFLBefore
        ReadFloat(DataToRead);    // MOC_CINFLAfter    


        For RowIndex := StrToInt(adeMOC3DLay1.Text) to EndUnit do
        begin
          sgMOC3DTransParam.Cells[Ord(trdLong), RowIndex]
            := ReadFloat(DataToRead);
          sgMOC3DTransParam.Cells[Ord(trdTranHor), RowIndex]
            := ReadFloat(DataToRead);
          sgMOC3DTransParam.Cells[Ord(trdTranVer), RowIndex]
            := ReadFloat(DataToRead);
          sgMOC3DTransParam.Cells[Ord(trdRetard), RowIndex]
            := ReadFloat(DataToRead);
          sgMOC3DTransParam.Cells[Ord(trdConc), RowIndex]
            := ReadFloat(DataToRead);
        end;

        // MT3D

//        if ArgusVersion > 0 then
//        begin
//          // MT3D Parameters
//
//          //MT3D Basic Package Parameters
//
//          {adeMT3DInactive.Text :=} ReadFloat(DataToRead);
//          {DTO} ReadFloat(DataToRead);
//          {adeMT3DHeading1.Text :=} ReadString(DataToRead);
//          {adeMT3DHeading2.Text :=} ReadString(DataToRead);
//          {edMT3DLength.Text :=} ReadString(DataToRead);
//          {edMT3DMass.Text :=} ReadString(DataToRead);
//          {MT3D_Basic_MXSTRN} ReadInteger(DataToRead);
//          {cbADV.Checked :=} ReadBoolean(DataToRead);
//          {cbADVClick(nil);}
//          {cbDSP.Checked :=} ReadBoolean(DataToRead);
//          {cbDSPClick(nil);}
//          {DTO_Calculated} ReadBoolean(DataToRead);
//          {cbRCT.Checked :=} ReadBoolean(DataToRead);
//          {cbRCTClick(nil);}
//          {cbSSM.Checked :=} ReadBoolean(DataToRead);
//
//          //MT3D Advection Package Parameters
//
//          {adeMT3DNeglSize.Text :=} ReadFloat(DataToRead);
//          {adeMT3DMaxParticleCount.Text :=} ReadInteger(DataToRead);
//          {adeMT3DInitPartLarge.Text :=} ReadInteger(DataToRead);
//          {adeMT3DInitPartSmall.Text :=} ReadInteger(DataToRead);
//          {adeMT3DMaxPartPerCell.Text :=} ReadInteger(DataToRead);
//          {adeMT3DMinPartPerCell.Text :=} ReadInteger(DataToRead);
//          {adeMT3DMaxParticleMovement.Text :=} ReadFloat(DataToRead);
//          {adeMT3DParticleMult.Text :=} ReadFloat(DataToRead);
//          {adeMT3DConcWeight.Text :=} ReadFloat(DataToRead);
//          {comboMT3DParticleTrackingAlg.ItemIndex :=} StrToInt(ReadInteger(DataToRead));
//          {comboMT3DAdvSolScheme.ItemIndex :=} StrToInt(ReadInteger(DataToRead));
//          {comboMT3DAdvSolSchemeChange(nil);
//          {comboMT3DInitPartPlace.ItemIndex := }StrToInt(ReadInteger(DataToRead));
//          {comboMT3DInitPartPlaceChange(nil);
//          {adeMT3DSinkParticleCount.Text := }ReadInteger(DataToRead);
//          {adeMT3DCritRelConcGrad.Text := }ReadFloat(DataToRead);
//          {comboMT3DInterpMeth.ItemIndex := }StrToInt(ReadInteger(DataToRead));
//          {comboMT3DInitPartSinkChoice.ItemIndex := }StrToInt(ReadInteger(DataToRead));
//          {comboMT3DInitPartSinkChoiceChange(nil);
//          {adeMT3DParticlePlaneCount.Text := }ReadInteger(DataToRead);
//          {adeMT3DSinkParticlePlaneCount.Text := }ReadInteger(DataToRead);
//
//          //MT3D Dispersion Parameters
//
//          //MT3D Chemical Reaction Parameters
//
//          {comboMT3DIREACT.ItemIndex := StrToInt(ReadInteger(DataToRead));}
//          {comboMT3DIREACTChange(nil);
//          {comboMT3DIsotherm.ItemIndex :=} StrToInt(ReadInteger(DataToRead));
//          {comboMT3DIsothermChange(nil);}
//
//          //MT3D Print Parameters
//
//          {cbCheckMass.Checked :=} ReadBoolean(DataToRead);
//          {cbPrintConc.Checked :=} ReadBoolean(DataToRead);
//          {cbPrintConcClick(nil);
//          {cbPrintDispCoef.Checked :=} ReadBoolean(DataToRead);
//          {cbPrintDispCoefClick(nil);
//          {cbPrintNumParticles.Checked :=} ReadBoolean(DataToRead);
//          {cbPrintNumParticlesClick(nil);
//          {cbPrintRetardation.Checked :=} ReadBoolean(DataToRead);
//          {cbPrintRetardationClick(nil);
//          {cbSaveConcAndDisc.Checked :=} ReadBoolean(DataToRead);
//          {comboPrintoutFormat.ItemIndex :=} StrToInt(ReadInteger(DataToRead));
//          {comboResultsPrinted.ItemIndex :=} StrToInt(ReadInteger(DataToRead));
//          {comboResultsPrintedChange(nil);
//          {adeResultsPrintedN.Text :=} ReadInteger(DataToRead);
//          {comboConcentrationFormat.ItemIndex :=} StrToInt(ReadInteger(DataToRead));
//          {comboDispersionFormat.ItemIndex :=} StrToInt(ReadInteger(DataToRead));
//          {comboParticlePrintFormat.ItemIndex :=} StrToInt(ReadInteger(DataToRead));
//          {comboRetardationFormat.ItemIndex :=} StrToInt(ReadInteger(DataToRead));
//          {adeResultsPrintedN.Text :=}RowCount := StrToInt(ReadInteger(DataToRead));
//          {sgPrintoutTimes.RowCount := StrToInt(adeResultsPrintedN.Text)+1;}
//          for RowIndex := 1 to RowCount do
//          begin
//            {sgPrintoutTimes.Cells[Ord(ptmTime),RowIndex] :=} ReadFloat(DataToRead);
//          end;
//
//          //MT3D Response File parameters
//          {cbPrintLinkFile.Checked :=} ReadBoolean(DataToRead);
//
//        end;

        //MOCIMP

{        if Length(DataToRead) > 0 then
        begin
          adeMOCTolerance.Text := ReadFloat(DataToRead);
          adeMOCWeightFactor.Text := ReadFloat(DataToRead);
          adeMOCDirInd.Text := ReadInteger(DataToRead);
          adeMOCMaxIter.Text := ReadInteger(DataToRead);
          adeMOCNumIter.Text := ReadInteger(DataToRead);
        end;         }


      end;
      cbFlowClick(nil);

    end;
  end;
end;

end.
