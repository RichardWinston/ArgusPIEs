unit ReadOldSutra;

interface

uses Classes, SysUtils, Dialogs, Stdctrls, ArgusDataEntry;

function IsOldFile(DataToRead : string) : boolean ;
function ReadInteger(var Source: String) : String;
function ReadFloat(var Source: String) : string;
function ReadBoolean(var Source: String) : Boolean;
function ReadString(var Source: String) : String;
Procedure CalculateFlag(ACombobox : TCombobox;
  AnArgusDataEntry : TArgusDataEntry; var DataToRead : string );

implementation

{$ASSERTIONS ON}

uses  frmSutraUnit;


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
  StrToFloat(SubString);
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
  Source := Copy(Source, EndPosition , Length(Source));
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
begin
  VersionString := Copy(DataToRead,1,10);
  result := (Pos('USGS-SUTRA',VersionString) > 0);
  if result then
  begin
    DataToRead := Copy(DataToRead,12,Length(DataToRead));
    Version := StrToInt(ReadInteger(DataToRead));
    with frmSutra do
    begin
      if ReadBoolean(DataToRead) then // default condition
      begin
         rbGeneral.Checked := True;
        {rbSpecific.Checked := True;
        rbAreal.Checked := True;
        rbSat.Checked := True;
        rbSoluteConstDens.Checked := True;
        rbUserSpecifiedThickness.Checked := True;
        rgMeshType.ItemIndex := 1; }
      end
      else
      begin
        // flow conditions
        if StrToInt(ReadInteger(DataToRead)) = 0 then
        begin
          rbSat.Checked := True;
        end
        else
        begin
          rbSatUnsat.Checked := True;
        end;

        // mesh design
        rgMeshType.ItemIndex := StrToInt(ReadInteger(DataToRead));

        if StrToInt(ReadInteger(DataToRead)) = 0 then // type of model
        begin
          rbUserSpecifiedThickness.Checked := True;
        end
        else
        begin
          rbCylindrical.Checked := True;
        end;

        if StrToInt(ReadInteger(DataToRead)) = 0 then // type of model
        begin
          rbAreal.Checked := True;
        end
        else
        begin
          rbCrossSection.Checked := True;
        end;

        case StrToInt(ReadInteger(DataToRead)) of
          0:
            begin
              rbSoluteVarDens.Checked := True;
            end;
          1:
            begin
              rbSoluteConstDens.Checked := True;
            end;
          2:
            begin
              rbEnergy.Checked := True;
            end;
        else
          begin
            Assert(False);
          end;
        end;


      end;  // if ReadBoolean(DataToRead) then // default condition

      // Pane1;
      // NTOBS
      ReadInteger(DataToRead);

      // SIMULA
//      comboSIMULA.Text := ReadString(DataToRead);
      comboSIMULA.ItemIndex := comboSIMULA.Items.IndexOf(ReadString(DataToRead));
      Assert(comboSIMULA.ItemIndex > -1);

      // Title1
      edTitle1.Text := ReadString(DataToRead);

      // Title2
      if version > 2 then
      begin
        edTitle2.Text := ReadString(DataToRead);
      end
      else
      begin
        edTitle1.Text := ''
      end;

      // Pane2
      // GNUP
      adeGNUP.Text := ReadFloat(DataToRead);

      // GNUu
      adeGNUU.Text := ReadFloat(DataToRead);

      // IREAD
      comboIREAD.ItemIndex := StrToInt(ReadInteger(DataToRead));

      // ISSFLO
      comboISSFLO.ItemIndex := StrToInt(ReadInteger(DataToRead));

      // ISSTRA
      comboISSTRA.ItemIndex := StrToInt(ReadInteger(DataToRead));

      // ISTORE
      adeISTORE.Text := ReadInteger(DataToRead);

      // IUNSAT
      comboIUNSAT.ItemIndex := StrToInt(ReadInteger(DataToRead));

      // UP
      adeFracUpstreamWeight.Text := ReadFloat(DataToRead);

      // Pane 3
      // DELT
      adeDELT.Text := ReadFloat(DataToRead);

      // DTMAX
      adeDTMAX.Text := ReadFloat(DataToRead);

      // ITCYC
      adeITCYC.Text := ReadInteger(DataToRead);

      // ITMAX
      adeITMAX.Text := ReadInteger(DataToRead);

      // NPCYC
      adeNPCYC.Text := ReadInteger(DataToRead);

      // NUCYC
      adeNUCYC.Text := ReadInteger(DataToRead);

      // DTMULT
      adeDTMULT.Text := ReadFloat(DataToRead);

      // TMAX
      adeTMAX.Text := ReadFloat(DataToRead);

      // Pane 4
      // KBUDG
      cbKBUDG.Checked := ReadBoolean(DataToRead);

      // KELMNT
      cbKELMNT.Checked := ReadBoolean(DataToRead);

      // KINCID
      cbKINCID.Checked := ReadBoolean(DataToRead);

      // KNODAL
      cbKNODAL.Checked := ReadBoolean(DataToRead);

      // KPLOTP
      ReadBoolean(DataToRead);

      // KPLOTU
      ReadBoolean(DataToRead);

      // KVEL
      cbKVEL.Checked := ReadBoolean(DataToRead);

      // NPRINT
      adeNPRINT.Text := ReadInteger(DataToRead);

      // Pane 5
      // ITRMAX
      adeITRMAX.Text := ReadInteger(DataToRead);
      if StrToInt(adeITRMAX.Text) = 1 then
      begin
        rbNonIterative.Checked;
      end
      else
      begin
        rbIterative.Checked;
      end;

      // RPMAX
      adeRPMAX.Text := ReadInteger(DataToRead);

      // RUMAX
      adeRUMAX.Text := ReadInteger(DataToRead);

      // Pane 6
      // COMPFL
      adeCOMPFL.Text := ReadFloat(DataToRead);

      // CW
      adeCW.Text := ReadFloat(DataToRead);

      // DRWDU
      adeDRWDU.Text := ReadFloat(DataToRead);

      // RHOW0
      adeRHOW0.Text := ReadFloat(DataToRead);

      // SIGMAW
      adeSIGMAW.Text := ReadFloat(DataToRead);

      // URHOW0
      adeURHOW0.Text := ReadFloat(DataToRead);

      // VISC0
      adeVISC0.Text := ReadFloat(DataToRead);

      // Pane 7
      // ADSMOD
//      comboADSMOD.Text := Trim(ReadString(DataToRead));
      comboADSMOD.ItemIndex := comboADSMOD.Items.IndexOf(Trim(ReadString(DataToRead)));
      Assert(comboADSMOD.ItemIndex > -1);

      // CHI1
      adeCHI1.Text := ReadFloat(DataToRead);

      // CHI2
      adeCHI2.Text := ReadFloat(DataToRead);

      // COMPMA
      adeCOMPMA.Text := ReadFloat(DataToRead);

      // CS
      adeCS.Text := ReadFloat(DataToRead);

      // RHOS
      adeRHOS.Text := ReadFloat(DataToRead);

      // SIGMAS
      adeSIGMAS.Text := ReadFloat(DataToRead);

      // Pane 8
      // GRAVX
      adeGRAVX.Text := ReadFloat(DataToRead);

      // GRAVY
      adeGRAVY.Text := ReadFloat(DataToRead);

      // PRODF0
      adePRODF0.Text := ReadFloat(DataToRead);

      // PRODF1
      adePRODF1.Text := ReadFloat(DataToRead);

      // PRODS0
      adePRODS0.Text := ReadFloat(DataToRead);

      // PRODS1
      adePRODS1.Text := ReadFloat(DataToRead);

      // Pane 9
      // IDIREC
      ReadInteger(DataToRead);

      // NCHAPI
      ReadInteger(DataToRead);

      // NCHAPL
      ReadInteger(DataToRead);

      // NLINPI
      ReadInteger(DataToRead);

      // PBASE
      ReadFloat(DataToRead);

      // UBASE
      ReadFloat(DataToRead);

      // Pane 10
      // NOBCYC
      adeNOBCYC.Text := ReadInteger(DataToRead);

      // TSART
      adeTSART.Text := ReadFloat(DataToRead);

    end;
  end;
end;

end.
