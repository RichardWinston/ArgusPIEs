unit WriteSensitivityUnit;

interface

uses Sysutils, Forms, contnrs, WriteModflowDiscretization;

type
  TSensRecord = record
    Name : string[10];
    ISENS : integer;
    LN : integer;
    B : double;
    BL : double;
    BU : double;
    BSCAL : double;
  end;

  TSensList = class;

  TSensitivityWriter = class(TModflowWriter)
  private
    SensList : TSensList;
    Procedure AddNames;
    Procedure WriteDataSet1;
    Procedure WriteDataSet2;
    Procedure WriteDataSet3;
    procedure EvaluateDataSet1;
  public
    procedure WriteFile(Root: string);
    procedure AssignUnitNumbers;
  end;

  TSensObject = class(TObject)
    Sens : TSensRecord;
    procedure Write(SensitivityWriter : TSensitivityWriter);
  end;

  TSensList = class(TObjectList)
    function Add(ASensRecord: TSensRecord): Integer;
    function MXSEN : integer;
    procedure Write(SensitivityWriter : TSensitivityWriter);
  end;


implementation

uses WriteNameFileUnit, ProgressUnit, Variables, UnitNumbers, UtilityFunctions;

procedure TSensitivityWriter.AddNames;
var
  aSensRecord : TSensRecord;
  RowIndex : integer;
begin
  with frmModflow do
  begin
    for RowIndex := 1 to dgSensitivity.RowCount -1 do
    begin
      aSensRecord.Name := Trim(dgSensitivity.Cells[1,RowIndex]);
      if aSensRecord.Name <> '' then
      begin
        aSensRecord.ISENS := dgSensitivity.Columns[2].PickList.IndexOf(dgSensitivity.Cells[2,RowIndex]);
        aSensRecord.LN := dgSensitivity.Columns[3].PickList.IndexOf(dgSensitivity.Cells[3,RowIndex]);
        aSensRecord.B := InternationalStrToFloat(dgSensitivity.Cells[4,RowIndex]);
        aSensRecord.BL := InternationalStrToFloat(dgSensitivity.Cells[5,RowIndex]);
        aSensRecord.BU := InternationalStrToFloat(dgSensitivity.Cells[6,RowIndex]);
        aSensRecord.BSCAL := InternationalStrToFloat(dgSensitivity.Cells[7,RowIndex]);
        SensList.Add(aSensRecord);
      end;
    end;
  end;
end;

procedure TSensitivityWriter.AssignUnitNumbers;
begin
  EvaluateDataSet1;
  if ExportSensitivityBinaryfile then
  begin
    frmModflow.GetUnitNumber('SENBIN');
  end;
  if ExportSensitivityAsciifile then
  begin
    frmModflow.GetUnitNumber('SENASCII');
  end
end;

procedure TSensitivityWriter.EvaluateDataSet1;
var
  NPLIST, ISENALL, IUHEAD, MXSEN : integer;
begin
  SensList := TSensList.Create;
  try
    AddNames;


    NPLIST := SensList.Count;
    ISENALL := frmModflow.comboSensEst.ItemIndex -1;
    if ISENALL > 0 then
    begin
      MXSEN := NPLIST;
    end
    else
    begin
      MXSEN := SensList.MXSEN;
    end;
    if frmModflow.comboSensMemory.ItemIndex = 0 then
    begin
      IUHEAD := 0;
    end
    else
    begin
      IUHEAD := frmModflow.GetNUnitNumbers('SensitivityFiles',MXSEN)
    end;
  finally
    SensList.Free;
  end;
end;

procedure TSensitivityWriter.WriteDataSet1;
var
  NPLIST, ISENALL, IUHEAD, MXSEN : integer;
begin
  NPLIST := SensList.Count;
  ISENALL := frmModflow.comboSensEst.ItemIndex -1;
//  IUHEAD := frmModflow.comboSensMemory.ItemIndex;
  if ISENALL > 0 then
  begin
    MXSEN := NPLIST;
  end
  else
  begin
    MXSEN := SensList.MXSEN;
  end;
  if frmModflow.comboSensMemory.ItemIndex = 0 then
  begin
    IUHEAD := 0;
  end
  else
  begin
    IUHEAD := frmModflow.GetNUnitNumbers('SensitivityFiles',MXSEN)
  end;
  writeLn(FFile, NPLIST, ' ', ISENALL, ' ', IUHEAD, ' ', MXSEN);
end;

procedure TSensitivityWriter.WriteDataSet2;
var
  ISENS, ISENSU, ISENPU, ISENFM : integer;
begin
  ISENS := frmModflow.rgSensPrint.ItemIndex;
  if ExportSensitivityBinaryfile then
  begin
    ISENSU := frmModflow.GetUnitNumber('SENBIN');
  end
  else
  begin
    ISENSU := 0;
  end;

  if ExportSensitivityAsciifile then
  begin
    ISENPU := frmModflow.GetUnitNumber('SENASCII');
  end
  else
  begin
    ISENPU := 0;
  end;

  ISENFM := frmModflow.comboSensFormat.ItemIndex;

  writeLn(FFile, ISENS, ' ', ISENSU, ' ', ISENPU, ' ', ISENFM);
end;

procedure TSensitivityWriter.WriteDataSet3;
var
  ErrorMessage : string;
begin
  if SensList.Count > 0 then
  begin
    frmProgress.lblActivity.Caption := 'DataSet 3';
    frmProgress.pbActivity.Max := SensList.Count;
    frmProgress.pbActivity.Position := 0;
    SensList.Write(self);
  end
  else
  begin
    ErrorMessage := 'Error: no parameters were specified for use with the '
      + 'Sensitivity package.  You should either turn off the Sensitivity '
      + 'package or specify some parameters to use with it.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
  end;
end;

procedure TSensitivityWriter.WriteFile(Root: string);
var
  FileName : String;
begin
  frmProgress.lblPackage.Caption := 'Sensitivity';
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := 3;

  FileName := GetCurrentDir + '\' + Root + rsSen;
  AssignFile(FFile,FileName);
  SensList := TSensList.Create;
  try
    AddNames;
    Rewrite(FFile);

    if ContinueExport then
    begin
      WriteDataReadFrom(FileName);
      frmProgress.lblActivity.Caption := 'DataSet 1';
      WriteDataSet1;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;
    if ContinueExport then
    begin
      frmProgress.lblActivity.Caption := 'DataSet 2';
      WriteDataSet2;
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;
    if ContinueExport then
    begin
      WriteDataSet3;
      frmProgress.pbPackage.StepIt;
      Flush(FFile);
      Application.ProcessMessages;
    end;

  finally
    CloseFile(FFile);
    SensList.Free;
  end;
end;

{ TSensList }

function TSensList.Add(ASensRecord: TSensRecord): Integer;
var
  ASensObject : TSensObject;
begin
  ASensObject := TSensObject.Create;
  ASensObject.Sens := ASensRecord;
  result := inherited Add(ASensObject);
end;

function TSensList.MXSEN: integer;
var
  Index : integer;
  ASensObject : TSensObject;
begin
  result := 0;
  for Index := 0 to Count -1 do
  begin
    ASensObject := Items[Index] as TSensObject;
    if ASensObject.Sens.ISENS>0 then
    begin
      Inc(result);
    end;
  end;
end;

procedure TSensList.Write(SensitivityWriter: TSensitivityWriter);
var
  Index : integer;
  ASensObject : TSensObject;
begin
  for Index := 0 to Count -1 do
  begin
    if ContinueExport then
    begin
      ASensObject := Items[Index] as TSensObject;
      ASensObject.Write(SensitivityWriter);
      frmProgress.pbActivity.StepIt;
    end;
  end;
end;

{ TSensObject }

procedure TSensObject.Write(SensitivityWriter: TSensitivityWriter);
begin
  Writeln(SensitivityWriter.FFile, Sens.Name, ' ', Sens.ISENS, ' ', Sens.LN, ' ',
    SensitivityWriter.FreeFormattedReal(Sens.B),
    SensitivityWriter.FreeFormattedReal(Sens.BL),
    SensitivityWriter.FreeFormattedReal(Sens.BU),
    SensitivityWriter.FreeFormattedReal(Sens.BSCAL)
{    Format(' %.13e %.13e %.13e %.13e', [Sens.B, Sens.BL, Sens.BU, Sens.BSCAL])});
end;

end.
