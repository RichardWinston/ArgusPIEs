unit PieFunctionsUnit;

interface

uses sysutils, Classes, Dialogs, AnePIE;

procedure GNumUnits(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GNumTimes(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure RunExample (aneHandle : ANE_PTR;
                    returnTemplate : ANE_STR_PTR) ; cdecl;
                                
implementation

uses MainForm, ANE_LayerUnit, UtilityFunctions, ArgusFormUnit;

var
  Template : ANE_STR;
  Exporting : boolean;

procedure GNumUnits(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
begin
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

      frmMain := TfrmMain.GetFormFromArgus(funHandle) as TfrmMain;

      result := frmMain.NumberOfGeologicUnits ;
      ANE_INT32_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure GNumTimes(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
begin
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

      frmMain := TfrmMain.GetFormFromArgus(funHandle) as TfrmMain;

      result := frmMain.NumberOfTimes ;
      ANE_INT32_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure RunPIE(aneHandle : ANE_PTR;  WarningMessage : string) ; cdecl;
const
  LastTemplate = 'LastTemplate.met';
var
  MetFileName : string;
  LastTemplatePath : string;
  TemplateStringList : TStringList;
  {$IFDEF Argus5} {This only works with Argus 5}
  ProjectOptions : TProjectOptions;
  {$ENDIF}
begin
  // Check that another model doesn't have a dialog box open. If it does,
  // prevent this one from openning because that would corrupt the data
  // for the other model.
  Template := nil;
  if EditWindowOpen
  then
  begin
    // Result := False
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    // make sure the project options used in exporting data are set correctly.
    {$IFDEF Argus5} {This only works with Argus 5}
    ProjectOptions := TProjectOptions.Create(aneHandle);
    try
      ProjectOptions.ExportWrap := 0;
      ProjectOptions.ExportSeparator := ' ';
    finally
      ProjectOptions.Free;
    end;
    {$ENDIF}
    try  // try 1
      begin
        Try
          begin
            frmMain := TfrmMain.GetFormFromArgus(aneHandle) as TfrmMain;
            TemplateStringList := TStringList.Create;
            try
              MetFileName := 'Example.met';
              Template := frmMain.ProcessTemplate(DLLName,
                MetFileName, '', nil, TemplateStringList);
              GetDllDirectory(DLLName, LastTemplatePath) ;
              LastTemplatePath := LastTemplatePath + '\' + LastTemplate;
              try
                TemplateStringList.SaveToFile(LastTemplatePath);
              Except
                on E : EInOutError do
                begin
                  MessageDlg('Error saving ' + LastTemplate
                    + ' because "' + SysErrorMessage(E.ErrorCode)
                    + '". ' + LastTemplate
                    + 'is used only for debugging so this is not a '
                    + 'fatal error.',
                    mtWarning, [mbOK], 0);
                end;
                On E : Exception do
                begin
                    MessageDlg(E.Message, MtError, [mbOK], 0);
                end;
              end
            finally
              TemplateStringList.Free;
            end;
          end
        except on E: Exception do
          begin
            Beep;
            MessageDlg('The following error occured while processing export template. "'
             + E.Message + '"', mtError, [mbOK], 0);
            Template := nil;
          end;
        end;
      end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
//  returnTemplate^ := Template;
end;

procedure RunExample (aneHandle : ANE_PTR;
                    returnTemplate : ANE_STR_PTR) ; cdecl;
begin
  Exporting := True;
  try
    RunPIE(aneHandle, '');
    returnTemplate^ := Template;
  finally
    Exporting := False;
  end;
end;

end.
