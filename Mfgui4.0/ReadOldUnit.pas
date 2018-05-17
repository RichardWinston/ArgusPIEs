unit ReadOldUnit;

interface

{ReadOldUnit defines a function that reads non-spatial data saved by versions
 1 and 2 of the USGS MODFLOW GUI.}

uses Windows, Classes, SysUtils, Dialogs, Stdctrls, ArgusDataEntry;

function IsOldFile(DataToRead : string) : boolean ;
function ReadInteger(var Source: String) : String;
function ReadFloat(var Source: String) : string;
function ReadBoolean(var Source: String) : Boolean;
function ReadString(var Source: String) : String;
Procedure CalculateFlag(ACombobox : TCombobox;
  AnArgusDataEntry : TArgusDataEntry; var DataToRead : string );

implementation

uses Variables, ModflowUnit, UtilityFunctions;

function ReadInteger(var Source: String) : String;
var
  Index : Integer;
  EndPosition : integer;
  SubString : string;
begin
  EndPosition := 1;
  for Index := 1 to Length(Source) do
  begin
    if Source[Index] = ' ' then
    begin
      EndPosition := Index;
      break;
    end;
  end;
  SubString := Copy(Source, 1, EndPosition -1);
  Source := Copy(Source, EndPosition +1, Length(Source));
  StrToInt(SubString);
  Result := SubString;
end;

function ReadFloat(var Source: String) : string;
var
  Index : Integer;
  EndPosition : integer;
  SubString : string;
  CommaSeparator : array[0..255] of Char;
  DecimalLocation : Integer;
begin
  EndPosition := 1;
  for Index := 1 to Length(Source) do
  begin
    if Source[Index] = ' ' then
    begin
      EndPosition := Index;
      break;
    end;
  end;
  SubString := Copy(Source, 1, EndPosition -1);
  Source := Copy(Source, EndPosition +1, Length(Source));

          GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SDECIMAL,@CommaSeparator,255);
          if String(CommaSeparator) = '.' then
          begin
            DecimalLocation := Pos(',',SubString);
            if DecimalLocation > 0 then
            begin
              SubString[DecimalLocation] := '.';
            end;
          end;
          if String(CommaSeparator) = ',' then
          begin
            DecimalLocation := Pos('.',SubString);
            if DecimalLocation > 0 then
            begin
              SubString[DecimalLocation] := ',';
            end;
          end;

  InternationalStrToFloat(SubString);
  Result := SubString;
end;

function ReadBoolean(var Source: String) : Boolean;
var
  Index : Integer;
  EndPosition : integer;
  SubString : string;
begin
  EndPosition := 1;
  for Index := 1 to Length(Source) do
  begin
    if Source[Index] = ' ' then
    begin
      EndPosition := Index;
      break;
    end;
  end;
  SubString := Copy(Source, 1, EndPosition -1);
  Source := Copy(Source, EndPosition +1, Length(Source));
  if not ((SubString = '1') or (SubString = '0')) then
  begin
    Raise EConvertError(SubString + ' is not a boolean.');
  end;
  Result := (SubString = '1');
end;

function ReadString(var Source: String) : String;
var
  EndPosition : integer;
  SubString : string;
begin
  EndPosition := StrToInt(ReadInteger(Source))+1;
  SubString := Copy(Source, 1, EndPosition -1);
  Source := Copy(Source, EndPosition +1, Length(Source));
  Result := SubString;
end;

Procedure CalculateFlag(ACombobox : TCombobox;
  AnArgusDataEntry : TArgusDataEntry; var DataToRead : string );
var
  AnInteger: Integer;
begin
      AnInteger := StrToInt(ReadInteger(DataToRead));
      if AnInteger = 0 then
        begin
          ACombobox.ItemIndex := 0
        end
      else if AnInteger = -1 then
        begin
          ACombobox.ItemIndex := 2
        end
      else
        begin
          ACombobox.ItemIndex := 1;
          AnArgusDataEntry.Text := IntToStr(AnInteger);
        end;
end;

function IsOldFile(DataToRead : string) : boolean ;
var
  VersionString : string;
  Version : integer;
  RowIndex : Integer;
  ABoolean : boolean;
//  AComboBox : TComboBox;
  AnInteger : Integer;
  EndUnit : integer;
  NumberOfTimes : integer;
  NumberOfUnits : integer;
  NumberOfParticles : integer;
  AFloat : double;
  AString : string;
begin
  VersionString := Copy(DataToRead,1,12);
  result := (Pos('USGS-MODFLOW',VersionString) > 0);
  if result then
  begin
    DataToRead := Copy(DataToRead,14,Length(DataToRead));
    Version := StrToInt(ReadInteger(DataToRead));
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
      NumberOfTimes := StrToInt(edNumPer.Text);
      For RowIndex := 1 to NumberOfTimes do
      begin
        dgTime.Cells[Ord(tdLength), RowIndex] := ReadFloat(DataToRead);
        dgTime.Cells[Ord(tdNumSteps), RowIndex] := ReadFloat(DataToRead);
        dgTime.Cells[Ord(tdMult), RowIndex] := ReadFloat(DataToRead);
        sgTimeSetEditText(frmMODFLOW,Ord(tdLength),RowIndex,
          dgTime.Cells[Ord(tdLength), RowIndex]);
      end;

      // Layer Parameters
      edNumUnitsEnter(edNumUnits);
      edNumUnits.Text := ReadInteger(DataToRead);
      edNumUnitsExit(edNumUnits);

//      For RowIndex := 1 to StrToInt(edNumUnits.Text) do
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
      end;
      dgGeolExit(nil);
//      sgcUnitsExit(nil);

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
      adeSIPPrint.Text := FloatToStr(Round(InternationalStrToFloat(ReadFloat(DataToRead))));

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
      {adePCGDamp.Text := } ReadInteger(DataToRead);

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

        BottomMOC3DSubGridDistance := InternationalStrToFloat(adeMOC3DRow1.Text);
        TopMOC3DSubGridDistance := InternationalStrToFloat(adeMOC3DRow2.Text);
        LeftMOC3DSubGridDistance := InternationalStrToFloat(adeMOC3DCol1.Text);
        RightMOC3DSubGridDistance := InternationalStrToFloat(adeMOC3DCol2.Text);

        RecalculateSubgrid := True;
 {         if cbMOC3D.Checked and RecalculateSubgrid then
        begin
          ShowMessage('You will need to select "PIEs|Edit Project Info" and '
            + 'then OK to update the MOC3D subgrid boundary');
        end;      }
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

        NumberOfParticles := StrToInt(edMOC3DInitParticles.Text);
        For RowIndex := 1 to NumberOfParticles do
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
        //MOCIMP

        if Length(DataToRead) > 0 then
        begin
          AString := ReadFloat(DataToRead);
          AFloat := InternationalStrToFloat(AString);
          if AFloat <> 0 then
          begin
            adeMOCTolerance.Text := AString;
          end;
          adeMOCWeightFactor.Text := ReadFloat(DataToRead);
          comboMOC3D_IDIREC.ItemIndex := StrToInt(ReadInteger(DataToRead))-1;
          if comboMOC3D_IDIREC.ItemIndex < 0 then
          begin
            comboMOC3D_IDIREC.ItemIndex := 0;
          end;

          adeMOCMaxIter.Text := ReadInteger(DataToRead);
          adeMOCNumIter.Text := ReadInteger(DataToRead);
        end;


      end;
      cbFlowClick(nil);

    end;
  end;
end;

end.
