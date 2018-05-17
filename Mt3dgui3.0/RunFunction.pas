unit RunFunction;

interface

uses AnePIE, Forms, Controls, sysutils, Dialogs;

procedure RunMT3DPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;

implementation

uses RunUnit, ANECB, Variables, ModflowUnit, ProgramToRunUnit;

procedure RunMT3DPIE(aneHandle : ANE_PTR;
   returnTemplate : ANE_STR_PTR) ; cdecl;
begin
  aProgram := progMT3D;
  RunPIE(aneHandle, '');
  returnTemplate^ := Template;


{  Template := nil;
  Try
    begin
//      CurrentModelHandle := aneHandle;
      ANE_GetPIEProjectHandle(aneHandle, @frmMODFLOW );
      frmMODFLOW.CurrentModelHandle := aneHandle;
      frmRun := ModflowTypes.GetRunModflowType.Create(application);
      try
        begin
          if frmRun.ShowModal = mrOK then
          begin
              frmRun.Cursor := crHourGlass;
              try
                begin
                  if frmRun.rbRun.Checked or frmRun.rbCreate.Checked
                  then
                  begin
                    if frmRun.rgMODFLOWVersion.ItemIndex = 1
                    then
                    begin
                      MetFileName := 'MODFLOW.met';
                    end
                    else
                    begin
                      MetFileName := 'MODFLOW88.met';
                    end;
                  end
                  else
                  begin
                    MetFileName := 'MT3D.met';
                  end;
                  Template := frmMODFLOW.ProcessTemplate(DLLName, MetFileName, '', nil);
                end
              finally
                begin
                  frmRun.Cursor := crDefault;
                end;
              end;
          end;
        end;
      finally
        begin
          frmRun.Free
        end;
      end;

    end
  except on Exception do
    begin
      MessageDlg('Unknown error during processing of export template.', mtError, [mbOK], 0);
      Template := nil;
    end;
  end;
  returnTemplate^ := Template;  }
end;

end.
 