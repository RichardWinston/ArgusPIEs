unit WriteGageUnit;

interface

uses SysUtils, Forms, Dialogs, IntListUnit, AnePIE;

  Type TGageWriter = Class(TObject)
  private
    FFile : TextFile;
    procedure WriteDataSet1;
    Procedure WriteDataSet2;
  public
    procedure WriteFile(Root: string);
  end;

Procedure InitializeStreamGages;
Procedure InitializeLakeGages;

procedure GResetGages (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GGageCount (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GGageUnitNumber (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GWriteGages (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  StreamGageList : TIntegerList;
  LakeGageList : TIntegerList;

  StreamReachList : TIntegerList;

  StreamUnitNumberList : TIntegerList;
  LakeUnitNumberList : TIntegerList;

  StreamGageOutputTypeList : TIntegerList;
  LakeGageOutputTypeList : TIntegerList;

implementation

uses ParamArrayUnit, ProgressUnit, WriteNameFileUnit, UnitNumbers;

Procedure InitializeStreamGages;
begin
  StreamGageList.Clear;
  StreamReachList.Clear;
  StreamUnitNumberList.Clear;
  StreamGageOutputTypeList.Clear;
end;

Procedure InitializeLakeGages;
begin
  LakeGageList.Clear;
  LakeUnitNumberList.Clear;
  LakeGageOutputTypeList.Clear;
end;

procedure TGageWriter.WriteDataSet1;
begin
  WriteLn(FFile, StreamGageList.Count + LakeGageList.Count)
end;

procedure TGageWriter.WriteDataSet2;
var
  Index : integer;
  UnitNumber : integer;
  GageNumber : integer;
  ReachIndex : integer;
  OUTTYPE : integer;
begin
  ReachIndex := 0;
  for Index := 0 to StreamGageList.Count -1 do
  begin
    UnitNumber := GetNextUnitNumber;
    GageNumber := StreamGageList[Index];
    OUTTYPE := StreamGageOutputTypeList[Index];
    if GageNumber > 0 then
    begin
      WriteLn(FFile, GageNumber, ' ', StreamReachList[ReachIndex], ' ',
        UnitNumber, ' ', OUTTYPE);
      Inc(ReachIndex);
    end
    else
    begin
      WriteLn(FFile, GageNumber, ' ', -UnitNumber, ' ', OUTTYPE);
    end;
    StreamUnitNumberList.Add(UnitNumber);
  end;
  for Index := 0 to LakeGageList.Count -1 do
  begin
    UnitNumber := GetNextUnitNumber;
    GageNumber := LakeGageList[Index];
    OUTTYPE := LakeGageOutputTypeList[Index];
    if GageNumber > 0 then
    begin
      WriteLn(FFile, GageNumber, ' ', StreamReachList[ReachIndex], ' ',
        UnitNumber, ' ', OUTTYPE);
      Inc(ReachIndex);
    end
    else
    begin
      WriteLn(FFile, GageNumber, ' ', -UnitNumber, ' ', OUTTYPE);
    end;
    LakeUnitNumberList.Add(UnitNumber);
  end;
end;

Procedure TGageWriter.WriteFile(Root : string);
var
  FileName : String;
begin
  if (StreamGageList.Count > 0) or (LakeGageList.Count > 0) then
  begin
    frmProgress.lblPackage.Caption := 'Gage';

    FileName := GetCurrentDir + '\' + Root + rsGage;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      if ContinueExport then
      begin
        WriteDataSet1;
        Application.ProcessMessages;
      end;

      if ContinueExport then
      begin
        WriteDataSet2;
        Application.ProcessMessages;
      end;

    finally
      CloseFile(FFile);
    end;
  end;
end;

procedure GResetGages (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
begin
  InitializeStreamGages;
  InitializeLakeGages;
  ANE_BOOL_PTR(reply)^ := True;
end;

procedure GGageCount (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
begin
  result := StreamUnitNumberList.Count + LakeUnitNumberList.Count;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GGageUnitNumber (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  param : PParameter_array;
  param1Ptr : ANE_INT32_PTR;
  Index : ANE_INT32;
begin
  result := -1;
  try
    try
      param := @parameters^;
      param1Ptr :=  param^[0];
      Index := param1Ptr^;
      if Index < StreamUnitNumberList.Count then
      begin
        result := StreamUnitNumberList[Index];
      end
      else
      begin
        result := LakeUnitNumberList[Index-StreamUnitNumberList.Count];
      end;
    except on E : Exception do
      begin
        Result := -1;
        Beep;
        MessageDlg(E.message, mtError, [mbOK], 0);
      end;
    end;
  finally
    ANE_INT32_PTR(reply)^ := result;
  end;
end;

procedure GWriteGages (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_BOOL;
  param : PParameter_array;
  Root : ANE_STR;
  GageWriter : TGageWriter;
begin
  result := False;
  try
    try
      param := @parameters^;
      Root :=  param^[0];

      GageWriter := TGageWriter.Create;
      try
        GageWriter.WriteFile(String(Root));
      finally
        GageWriter.Free;
      end;

      Result := True;
    except on E : Exception do
      begin
        Result := False;
        Beep;
        MessageDlg(E.message, mtError, [mbOK], 0);
      end;
    end;

  finally
    ANE_BOOL_PTR(reply)^ := result;
  end;

end;

initialization
  StreamGageList := TIntegerList.Create;
  StreamReachList := TIntegerList.Create;
  StreamUnitNumberList := TIntegerList.Create;
  StreamGageOutputTypeList := TIntegerList.Create;

  LakeGageList := TIntegerList.Create;
  LakeUnitNumberList := TIntegerList.Create;
  LakeGageOutputTypeList := TIntegerList.Create;

finalization
  StreamGageList.Free;
  StreamReachList.Free;
  StreamUnitNumberList.Free;
  StreamGageOutputTypeList.Free;

  LakeGageList.Free;
  LakeUnitNumberList.Free;
  LakeGageOutputTypeList.Free;

end.
