unit ReadOldICSUnit;

interface

uses Sysutils, Dialogs, AnePIE;

procedure ReadOldICS2(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure ReadOldICS3(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
                                
implementation

uses ParamArrayUnit, frmSutraUnit, ANE_LayerUnit, ArgusFormUnit;

procedure ReadOldICS2(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  FileName : ANE_STR;
  RestartFileName : string;
  F : TextFile;
  RestartFile : TextFile;
  Index : integer;
  Line : string;
  Limit : integer;
  param2_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  NN : ANE_INT32;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := False;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try // try 1
      param := @parameters^;
      FileName :=  param^[0];
  //    RestartFileName :=  param^[1];
      param2_ptr :=  param^[1];
      NN :=  param2_ptr^;

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;
      RestartFileName := frmSutra.edRestartFile.Text;


      if FileExists(RestartFileName) then
      begin

        AssignFile(F, GetCurrentDir + '\' + String(FileName));
        Rewrite(F);
        try
          WriteLn(F, '''NONUNIFORM''');

          AssignFile(RestartFile, RestartFileName);
          try // try 2
            Reset(RestartFile);
            ReadLn(RestartFile);
            ReadLn(RestartFile);
            Limit := (NN - 1) div 4 + 1;
            result := True;
            for Index := 0 to Limit -1 do
            begin
              ReadLn(RestartFile, Line);
              WriteLn(F, Line);
              if EOF(RestartFile) then
              begin
                result := False;
                Beep;
                MessageDlg('The end of the restart file, '
                  + RestartFileName
                  + ', was reached before reading all the data required '
                  + 'for data set 2 of the initial conditions file.',
                  mtError, [mbOK], 0);
                break;
              end;
            end;
          finally
            CloseFile(RestartFile);
          end;
        finally
          CloseFile(F);
        end;
      end
      else
      begin
        result := False;
        Beep;
        MessageDlg('Error creating ICS2 file: The file "'
          + RestartFileName + '" does not exist.',
          mtError, [mbOK], 0);
      end;

    finally
      EditWindowOpen := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure ReadOldICS3(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_BOOL;
  param : PParameter_array;
  FileName : ANE_STR;
  RestartFileName : string;
  F : TextFile;
  RestartFile : TextFile;
  Index : integer;
  Line : string;
  Limit : integer;
  param2_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  NN : ANE_INT32;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
    Result := False;
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try
      param := @parameters^;
      FileName :=  param^[0];
//      RestartFileName :=  param^[1];
      param2_ptr :=  param^[1];
      NN :=  param2_ptr^;

      frmSutra := TArgusForm.GetFormFromArgus(funHandle)
        as TfrmSutra;
      RestartFileName := frmSutra.edRestartFile.Text;

      if FileExists(RestartFileName) then
      begin
        AssignFile(F, GetCurrentDir + '\' + String(FileName));
        Rewrite(F);
        try
          WriteLn(F, '''NONUNIFORM''');

          AssignFile(RestartFile, RestartFileName);
          try
            Reset(RestartFile);
            ReadLn(RestartFile);
            ReadLn(RestartFile);
            Limit := (NN - 1) div 4 + 1;
            result := True;
            for Index := 0 to Limit -1 do
            begin
              ReadLn(RestartFile);
            end;
            ReadLn(RestartFile);
            result := True;
            for Index := 0 to Limit -1 do
            begin
              ReadLn(RestartFile, Line);
              WriteLn(F, Line);
              if EOF(RestartFile) then
              begin
                result := False;
                Beep;
                MessageDlg('The end of the restart file, '
                  + RestartFileName
                  + ', was reached before reading all the data required '
                  + 'for data set 3 of the initial conditions file.',
                  mtError, [mbOK], 0);
                break;
              end;
            end;
          finally
            CloseFile(RestartFile);
          end;
        finally
          CloseFile(F);
        end;
      end
      else
      begin
        result := False;
        Beep;
        MessageDlg('Error creating ICS3 file: The file "'
          + RestartFileName + '" does not exist.',
          mtError, [mbOK], 0);
      end;
    finally
      EditWindowOpen := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

end.
