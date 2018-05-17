unit WriteSolversUnit;

interface

uses Sysutils, Forms, WriteModflowDiscretization;

type
  TSIP_Writer = Class(TModflowWriter)
  public
    procedure WriteFile(Root : string);
  end;

  TSOR_Writer = Class(TModflowWriter)
  public
    procedure WriteFile(Root : string);
  end;

  TPCG2_Writer = Class(TModflowWriter)
  public
    procedure WriteFile(Root : string);
  end;

  TDE4_Writer = Class(TModflowWriter)
  public
    procedure WriteFile(Root : string);
  end;

  TLmd_Link_Writer = Class(TModflowWriter)
  public
    procedure WriteFile(Root : string);
  end;

  TGMG_Writer = class(TModflowWriter)
  public
    procedure WriteFile(Root : string);
  end;


implementation

Uses Variables, WriteNameFileUnit, ProgressUnit, UtilityFunctions;

{ TSIP_Writer }

procedure TSIP_Writer.WriteFile(Root: string);
var
  MXITER, NPARM, ILPCALC, IPRSIP : integer;
  ACCL, HCLOSE, WSEED : double;
  FileName : string;
begin
  FileName := GetCurrentDir + '\' + Root + rsSIP;
  AssignFile(FFile,FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      frmProgress.lblPackage.Caption := 'Writing SIP information';
      frmProgress.lblActivity.Caption := '';
      frmProgress.pbPackage.Max := 1;
      frmProgress.pbPackage.Position := 0;
      Application.ProcessMessages;
      with frmMODFLOW do
      begin
        MXITER := StrToInt(adeSIPMaxIter.Text);
        NPARM := StrToInt(adeSIPNumParam.Text);
        ACCL := InternationalStrToFloat(adeSIPAcclParam.Text);
        HCLOSE := InternationalStrToFloat(adeSIPConv.Text);
        ILPCALC := comboSIPIterSeed.ItemIndex;
        WSEED := InternationalStrToFloat(adeSIPIterSeed.Text);
        IPRSIP := StrToInt(adeSIPPrint.Text);
      end;

      WriteLn(FFile, MXITER, ' ',NPARM);
      WriteLn(FFile, ACCL, ' ',HCLOSE, ' ',ILPCALC, ' ',WSEED, ' ',IPRSIP);

      frmProgress.pbPackage.StepIt;
      Flush(FFile);
      Application.ProcessMessages;
    end;
  finally
    CloseFile(FFile);
  end;

  Application.ProcessMessages;

end;

{ TSOR_Writer }

procedure TSOR_Writer.WriteFile(Root: string);
var
  MXITER, IPRSOR : integer;
  ACCL, HCLOSE : double;
  FileName : string;
begin
  FileName := GetCurrentDir + '\' + Root + rsSOR;
  AssignFile(FFile,FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      frmProgress.lblPackage.Caption := 'Writing SOR information';
      frmProgress.lblActivity.Caption := '';
      frmProgress.pbPackage.Max := 1;
      frmProgress.pbPackage.Position := 0;
      Application.ProcessMessages;
      with frmMODFLOW do
      begin
        MXITER := StrToInt(adeSORMaxIter.Text);
        ACCL := InternationalStrToFloat(adeSORAccl.Text);
        HCLOSE := InternationalStrToFloat(adeSORConv.Text);
        IPRSOR := StrToInt(adeSORPri.Text);
      end;

      WriteLn(FFile, MXITER);
      WriteLn(FFile, ACCL, ' ',HCLOSE, ' ',IPRSOR);

      frmProgress.pbPackage.StepIt;
      Flush(FFile);
      Application.ProcessMessages;
    end;
  finally
    CloseFile(FFile);
  end;

  Application.ProcessMessages;

end;

{ TPCG2_Writer }

procedure TPCG2_Writer.WriteFile(Root: string);
var
  MXITER, ITER1, NPCOND, NBPOL, IPRPCG, MUTPCG : integer;
  HCLOSE, RCLOSE, RELAX, DAMP : double;
  FileName : string;
begin
  FileName := GetCurrentDir + '\' + Root + rsPCG;
  AssignFile(FFile,FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      frmProgress.lblPackage.Caption := 'Writing PCG information';
      frmProgress.lblActivity.Caption := '';
      frmProgress.pbPackage.Max := 1;
      frmProgress.pbPackage.Position := 0;
      Application.ProcessMessages;
      with frmMODFLOW do
      begin
        MXITER := StrToInt(adePCGMaxOuter.Text);
        ITER1 := StrToInt(adePCGMaxInner.Text);
        NPCOND := comboPCGPrecondMeth.ItemIndex + 1;

        HCLOSE := InternationalStrToFloat(adePCGMaxHeadChange.Text);
        RCLOSE := InternationalStrToFloat(adePCGMaxResChange.Text);
        RELAX := InternationalStrToFloat(adePCGRelax.Text);
        NBPOL := comboPCGEigenValue.ItemIndex + 1;
        IPRPCG := StrToInt(adePCGPrintInt.Text);
        MUTPCG := comboPCGPrint.ItemIndex;
        DAMP := InternationalStrToFloat(adePCGDamp.Text);
      end;

      WriteLn(FFile, MXITER, ' ', ITER1, ' ', NPCOND);
      WriteLn(FFile, HCLOSE, ' ', RCLOSE, ' ', RELAX, ' ', NBPOL, ' ', IPRPCG,
        ' ', MUTPCG, ' ', DAMP);

      frmProgress.pbPackage.StepIt;
      Flush(FFile);
      Application.ProcessMessages;
    end;
  finally
    CloseFile(FFile);
  end;

  Application.ProcessMessages;

end;

{ TDE4_Writer }

procedure TDE4_Writer.WriteFile(Root: string);
var
  ITMX, MXUP, MXLOW, MXBW, IFREQ, MUTD4, IPRD4 : integer;
  ACCL, HCLOSE : double;
  FileName : string;
begin
  FileName := GetCurrentDir + '\' + Root + rsDE4;
  AssignFile(FFile,FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      frmProgress.lblPackage.Caption := 'Writing DE4 information';
      frmProgress.lblActivity.Caption := '';
      frmProgress.pbPackage.Max := 1;
      frmProgress.pbPackage.Position := 0;
      Application.ProcessMessages;
      with frmMODFLOW do
      begin
        ITMX := StrToInt(adeDE4MaxIter.Text);
        MXUP := StrToInt(adeDE4MaxUp.Text);
        MXLOW := StrToInt(adeDE4MaxLow.Text);
        MXBW := StrToInt(adeDE4Band.Text);

        IFREQ := comboDE4Freq.ItemIndex + 1;
        MUTD4 := comboDE4Print.ItemIndex;
        ACCL := InternationalStrToFloat(adeDE4Accl.Text);
        HCLOSE := InternationalStrToFloat(adeDE4Conv.Text);
        IPRD4 := StrToInt(adeDE4TimeStep.Text);
      end;

      WriteLn(FFILE, ITMX, ' ', MXUP, ' ', MXLOW, ' ', MXBW);
      WriteLn(FFILE, IFREQ, ' ', MUTD4, ' ', ACCL, ' ', HCLOSE, ' ', IPRD4);

      frmProgress.pbPackage.StepIt;
      Flush(FFile);
      Application.ProcessMessages;
    end;
  finally
    CloseFile(FFile);
  end;

  Application.ProcessMessages;

end;

{ TLmd_Link_Writer }

procedure TLmd_Link_Writer.WriteFile(Root: string);
var
  STOR1, STOR2, STOR3, BCLOSE, DAMP, DUP, DLOW : double;
  ICG, MXITER, MXCYC, IOUTAMG : integer;
  FileName : string;
begin
  IOUTAMG := -1;
  FileName := GetCurrentDir + '\' + Root + rsLMG;
  AssignFile(FFile,FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      frmProgress.lblPackage.Caption := 'Writing LMG information';
      frmProgress.lblActivity.Caption := '';
      frmProgress.pbPackage.Max := 1;
      frmProgress.pbPackage.Position := 0;
      Application.ProcessMessages;
      with frmMODFLOW do
      begin
        STOR1 := InternationalStrToFloat(adeAMG_Stor1.Text);
        STOR2 := InternationalStrToFloat(adeAMG_Stor2.Text);
        STOR3 := InternationalStrToFloat(adeAMG_Stor3.Text);
        if cbAMG_ICG.Checked then
        begin
          ICG := 1;
        end
        else
        begin
          ICG := 0;
        end;
        MXITER := StrToInt(ade_AMG_MXITER.Text);
        MXCYC := StrToInt(ade_AMG_MXCYC.Text);
        BCLOSE := InternationalStrToFloat(ade_AMG_BCLOSE.Text);
        if combo_AMG_DampingMethod.ItemIndex = 0 then
        begin
          DAMP := InternationalStrToFloat(ade_AMG_DAMP.Text);
        end
        else
        begin
          DAMP := -combo_AMG_DampingMethod.ItemIndex
        end;
        if rb_AMG_IOUTAMG_0.Checked then
        begin
          IOUTAMG := 0;
        end
        else if rb_AMG_IOUTAMG_1.Checked then
        begin
          IOUTAMG := 1;
        end
        else if rb_AMG_IOUTAMG_2.Checked then
        begin
          IOUTAMG := 2;
        end
        else if rb_AMG_IOUTAMG_3.Checked then
        begin
          IOUTAMG := 3;
        end
        else
        begin
          Assert(False);
        end;
        DUP := InternationalStrToFloat(ade_AMG_DUP.Text);
        DLOW := InternationalStrToFloat(ade_AMG_DLOW.Text);
      end;

      WriteLn(FFILE, STOR1, ' ', STOR2, ' ', STOR3, ' ', ICG);
      WriteLn(FFILE, MXITER, ' ', MXCYC, ' ', BCLOSE, ' ', DAMP, ' ', IOUTAMG);
      if DAMP = -2 then
      begin
        WriteLn(FFILE, DUP, ' ', DLOW);
      end;

      frmProgress.pbPackage.StepIt;
      Flush(FFile);
      Application.ProcessMessages;
    end;
  finally
    CloseFile(FFile);
  end;

  Application.ProcessMessages;

end;

{ TGMG_Writer }

procedure TGMG_Writer.WriteFile(Root: string);
var
  RCLOSE: double;
  IITER: integer;
  HCLOSE: double;
  MXITER: integer;
  DAMP: double;
  IADAMP: integer;
  IOUTGMG: integer;
  ISM: integer;
  ISC: integer;
  RELAX: double;
  IUNITMHC: Integer;
  FileName: string;
  DLOW, DUP, CHGLIMIT: double;
begin
  with frmMODFLOW do
  begin
    RCLOSE := InternationalStrToFloat(adeGmgRclose.Text);
    HCLOSE := InternationalStrToFloat(adeGmgHclose.Text);
    DAMP := InternationalStrToFloat(adeGmgDamp.Text);
    RELAX := InternationalStrToFloat(adeGmgRelax.Text);

    IITER := StrToInt(adeGmgIiter.Text);
    MXITER := StrToInt(adeGmgMxiter.Text);

    IADAMP := comboGmgIadamp.ItemIndex;
    IOUTGMG := comboGmgIoutgmg.ItemIndex;
    ISM := comboGmgIsm.ItemIndex;
    ISC := comboGmgIsc.ItemIndex;

    if cbGMG_IUNITMHC.Checked then
    begin
      IUNITMHC := frmModflow.GetUnitNumber('GMGMHC');
    end
    else
    begin
      IUNITMHC := 0;
    end;

    if IADAMP = 2 then
    begin
      DUP := InternationalStrToFloat(adeGMG_DUP.Text);
      DLOW := InternationalStrToFloat(adeGMG_DLOW.Text);
      CHGLIMIT := InternationalStrToFloat(adeGMG_CHGLIMIT.Text);
    end
    else
    begin
      DUP := 0;
      DLOW := 0;
      CHGLIMIT := 0;
    end;


  end;
  FileName := GetCurrentDir + '\' + Root + rsGMG;
  AssignFile(FFile,FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      frmProgress.lblPackage.Caption := 'Writing GMG information';
      frmProgress.lblActivity.Caption := '';
      frmProgress.pbPackage.Max := 1;
      frmProgress.pbPackage.Position := 0;
      Application.ProcessMessages;

      Writeln(FFile, RCLOSE, ' ', IITER, ' ', HCLOSE, ' ', MXITER);
      Writeln(FFile, DAMP, ' ', IADAMP, ' ', IOUTGMG, ' ', IUNITMHC);

      Write(FFile, ISM, ' ', ISC);
      if IADAMP = 2 then
      begin
        Write(FFile, ' ', DUP, ' ', DLOW, ' ', CHGLIMIT);
      end;
      Writeln(FFile);
      if ISC = 4 then
      begin
        Writeln(FFile, RELAX);
      end;

      frmProgress.pbPackage.StepIt;
      Flush(FFile);
      Application.ProcessMessages;
    end;
  finally
    CloseFile(FFile);
  end;

  Application.ProcessMessages;
end;

end.
