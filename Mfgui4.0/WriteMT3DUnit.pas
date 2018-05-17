unit WriteMT3DUnit;

interface

uses Sysutils, Dialogs, AnePIE, WriteModflowDiscretization;

procedure GWriteMT3DMS (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

Procedure UpdateCountMT3DMS(var Count: integer);

Procedure ExportMt3dmsInput(const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter);

implementation

uses ANE_LayerUnit, Variables, WriteMT3D_Advection, WriteMT3D_Basic,
  WriteMT3D_Chem, WriteMT3D_Dispersion, WriteMT3D_GCG, WriteMT3D_SSM,
  ArgusFormUnit, ProgressUnit, WriteModflowFilesUnit, WriteNameFileUnit,
  InitializeBlockUnit, FreeBlockUnit, WriteMT3D_TOB;

function DisWriterNeeded : boolean;
begin
  result := frmModflow.cbExportMT3DBTN.Checked
    or (frmModflow.cbDSP.Checked and frmModflow.cbExportMT3DDSP.Checked)
    or (frmModflow.cbSSM.Checked and frmModflow.cbExportMT3DSSM.Checked)
    or (frmModflow.cbRCT.Checked and frmModflow.cbExportMT3DRCT.Checked);
end;

Procedure UpdateCountMT3DMS(var Count: integer);
begin
  if frmModflow.cbExportMT3DBTN.Checked then
  begin
    Inc(Count);
  end;
  if frmModflow.cbADV.Checked and frmModflow.cbExportMT3DADV.Checked then
  begin
    Inc(Count);
  end;
  if frmModflow.cbDSP.Checked and frmModflow.cbExportMT3DDSP.Checked then
  begin
    Inc(Count);
  end;
  if frmModflow.cbSSM.Checked and frmModflow.cbExportMT3DSSM.Checked then
  begin
    Inc(Count);
  end;
  if frmModflow.cbRCT.Checked and frmModflow.cbExportMT3DRCT.Checked then
  begin
    Inc(Count);
  end;
  if frmModflow.cbGCG.Checked and frmModflow.cbExportMT3DGCG.Checked then
  begin
    Inc(Count);
  end;
end;

Procedure ExportMt3dmsInput(const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter);
var
  Mt3dBasic : TMt3dBasicWriter;
  Advection : TMT3D_AdvectionWriter;
  Dispersion : TMt3dDispersionWriter;
  Sources : TMt3dSSMWriter;
  Reaction : TMt3dChemWriter;
  GCG : TMt3dGCG_Writer;
  TransObs: TMt3dTobWriter;
begin
  if not ContinueExport then Exit;
  if frmModflow.cbExportMT3DBTN.Checked then
  begin
    frmProgress.lblPackage.Caption := 'Basic Transport';
    Mt3dBasic := TMt3dBasicWriter.Create;
    try
      Mt3dBasic.WriteFile(CurrentModelHandle, Root, Discretization);
    finally
      Mt3dBasic.Free;
    end;
    frmProgress.pbOverall.StepIt;
  end;

  if not ContinueExport then Exit;
  if frmModflow.cbADV.Checked and frmModflow.cbExportMT3DADV.Checked then
  begin
    frmProgress.lblPackage.Caption := 'Advection';
    Advection := TMT3D_AdvectionWriter.Create;
    try
      Advection.WriteFile(Root);
    finally
      Advection.Free;
    end;
    frmProgress.pbOverall.StepIt;
  end;

  if not ContinueExport then Exit;
  if frmModflow.cbDSP.Checked and frmModflow.cbExportMT3DDSP.Checked then
  begin
    frmProgress.lblPackage.Caption := 'Dispersion';
    Dispersion := TMt3dDispersionWriter.Create;
    try
      Dispersion.WriteFile(CurrentModelHandle, Root, Discretization);
    finally
      Dispersion.Free;
    end;
    frmProgress.pbOverall.StepIt;
  end;

  if not ContinueExport then Exit;
  if frmModflow.cbSSM.Checked and frmModflow.cbExportMT3DSSM.Checked then
  begin
    frmProgress.lblPackage.Caption := 'Source and Sink Mixing';
    Sources := TMt3dSSMWriter.Create;
    try
      Sources.WriteFile(CurrentModelHandle, Root, Discretization);
    finally
      Sources.Free;
    end;
    frmProgress.pbOverall.StepIt;
  end;

  if not ContinueExport then Exit;
  if frmModflow.cbRCT.Checked and frmModflow.cbExportMT3DRCT.Checked then
  begin
    frmProgress.lblPackage.Caption := 'Reaction';
    Reaction := TMt3dChemWriter.Create;
    try
      Reaction.WriteFile(CurrentModelHandle, Root, Discretization);
    finally
      Reaction.Free;
    end;
    frmProgress.pbOverall.StepIt;
  end;

  if not ContinueExport then Exit;
  if frmModflow.cbTOB.Checked then
  begin
    frmProgress.lblPackage.Caption := 'Transport Observations';
    TransObs := TMt3dTobWriter.Create;
    try
      TransObs.WriteFile(CurrentModelHandle, Root, Discretization);
    finally
      TransObs.Free;
    end;
    frmProgress.pbOverall.StepIt;
  end;

  if not ContinueExport then Exit;
  if frmModflow.cbGCG.Checked and frmModflow.cbExportMT3DGCG.Checked then
  begin
    frmProgress.lblPackage.Caption := 'Generalized Conjugate Gradient';
    GCG := TMt3dGCG_Writer.Create;
    try
      GCG.WriteFile(Root);
    finally
      GCG.Free;
    end;
    frmProgress.pbOverall.StepIt;
  end;
end;

Procedure WriteMT3DFiles(const CurrentModelHandle: ANE_PTR; Root: string);
var
  Discretization: TDiscretizationWriter;
  NameFileWriter : TNameFileWriter;
  BatchFileName : string;
  Count : integer;
  ErrorFileName : string;
begin
  ContinueExport := True;
  Count := 0;
  if DisWriterNeeded then
  begin
    Inc(Count,2);
  end;

  UpdateCountMT3DMS(Count);

  Discretization := nil;
  try
    frmProgress.reErrors.Lines.Clear;
    frmProgress.pbOverall.Max := Count;
    frmProgress.Show;

    if DisWriterNeeded then
    begin
      if not ContinueExport then Exit;
      frmProgress.lblPackage.Caption := 'Initializing Grid';
      GInitializeBlock(CurrentModelHandle,
        PChar(ModflowTypes.GetGridLayerType.ANE_LayerName), 0);
      frmProgress.pbOverall.StepIt;

      frmProgress.lblPackage.Caption := 'Initializing Discretization';
      Discretization := TDiscretizationWriter.Create;
      Discretization.InitializeButDontWrite(CurrentModelHandle);
      frmProgress.pbOverall.StepIt;
    end;

    ExportMt3dmsInput(CurrentModelHandle, Root, Discretization);

    {if not ContinueExport then Exit;
    if frmModflow.cbExportMT3DBTN.Checked then
    begin
      frmProgress.lblPackage.Caption := 'Basic Transport';
      Mt3dBasic := TMt3dBasicWriter.Create;
      try
        Mt3dBasic.WriteFile(CurrentModelHandle, Root, Discretization);
      finally
        Mt3dBasic.Free;
      end;
      frmProgress.pbOverall.StepIt;
    end;

    if not ContinueExport then Exit;
    if frmModflow.cbADV.Checked and frmModflow.cbExportMT3DADV.Checked then
    begin
      frmProgress.lblPackage.Caption := 'Advection';
      Advection := TMT3D_AdvectionWriter.Create;
      try
        Advection.WriteFile(Root);
      finally
        Advection.Free;
      end;
      frmProgress.pbOverall.StepIt;
    end;

    if not ContinueExport then Exit;
    if frmModflow.cbDSP.Checked and frmModflow.cbExportMT3DDSP.Checked then
    begin
      frmProgress.lblPackage.Caption := 'Dispersion';
      Dispersion := TMt3dDispersionWriter.Create;
      try
        Dispersion.WriteFile(CurrentModelHandle, Root, Discretization);
      finally
        Dispersion.Free;
      end;
      frmProgress.pbOverall.StepIt;
    end;

    if not ContinueExport then Exit;
    if frmModflow.cbSSM.Checked and frmModflow.cbExportMT3DSSM.Checked then
    begin
      frmProgress.lblPackage.Caption := 'Source and Sink Mixing';
      Sources := TMt3dSSMWriter.Create;
      try
        Sources.WriteFile(CurrentModelHandle, Root, Discretization);
      finally
        Sources.Free;
      end;
      frmProgress.pbOverall.StepIt;
    end;

    if not ContinueExport then Exit;
    if frmModflow.cbRCT.Checked and frmModflow.cbExportMT3DRCT.Checked then
    begin
      frmProgress.lblPackage.Caption := 'Reaction';
      Reaction := TMt3dChemWriter.Create;
      try
        Reaction.WriteFile(CurrentModelHandle, Root, Discretization);
      finally
        Reaction.Free;
      end;
      frmProgress.pbOverall.StepIt;
    end;

    if not ContinueExport then Exit;
    if frmModflow.cbGCG.Checked and frmModflow.cbExportMT3DGCG.Checked then
    begin
      frmProgress.lblPackage.Caption := 'Generalized Conjugate Gradient';
      GCG := TMt3dGCG_Writer.Create;
      try
        GCG.WriteFile(Root);
      finally
        GCG.Free;
      end;
      frmProgress.pbOverall.StepIt;
    end;   }

    if not ContinueExport then Exit;
    frmProgress.lblPackage.Caption := 'Name File';
    NameFileWriter := TNameFileWriter.Create;
    try
      NameFileWriter.WriteMT3DNameFile(Root);
      BatchFileName := NameFileWriter.WriteMT3DBatchFile(CurrentModelHandle,
        frmModflow.cbCalibrate.Checked, Root);
    finally
      NameFileWriter.Free;
    end;
    frmProgress.pbOverall.StepIt;

    if not ContinueExport then Exit;
    if frmModflow.rbRunMT3D.Checked then
    begin
      ExecuteBatchFile(BatchFileName);
    end;

  finally
    Discretization.Free;
    GListFreeBlock;
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

procedure GWriteMT3DMS (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_BOOL;
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
      EditWindowOpen := True ;
      try  // try 1
      begin
        frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
          as ModflowTypes.GetModflowFormType;

        WriteMT3DFiles(funHandle, frmModflow.adeFileName.Text);

        result := True;
      end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end; // try 1
    end; // if EditWindowOpen else
  Except on E : Exception do
    begin
      result := False;
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

end.
