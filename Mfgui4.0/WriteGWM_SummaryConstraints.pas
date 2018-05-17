unit WriteGWM_SummaryConstraints;

interface

uses SysUtils, Forms, WriteModflowDiscretization;

type
  TSummaryConstraintsWriter = class(TModflowWriter)
  private
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet3b(const NameIndex: integer);
  public
    procedure WriteFile(const Root: string);
  end;

implementation

uses Variables, WriteGWM_DecisionVariables, ModflowUnit, DataGrid,
  UtilityFunctions, ProgressUnit, WriteNameFileUnit;

{ TSummaryConstraintsWriter }

procedure TSummaryConstraintsWriter.WriteDataSet1;
const
  IPRN = 1;
begin
  writeln(FFile, IPRN);
end;

procedure TSummaryConstraintsWriter.WriteDataSet2;
var
  SMCNUM: integer;
begin
  if frmModflow.frameGWM_CombinedConstraints.dgVariables.Enabled then
  begin
    SMCNUM := frmModflow.frameGWM_CombinedConstraints.dgVariables.RowCount -1;
  end
  else
  begin
    SMCNUM := 0;
  end;
  writeln(FFile, SMCNUM);
end;

procedure TSummaryConstraintsWriter.WriteDataSet3;
var
  NameIndex: integer;
  SMCNAME: string;
  NTERMS: integer;
  SMCN_TYPE: string;
  RHS: double;
  TypeIndex: integer;
begin
  with frmModflow.frameGWM_CombinedConstraints.dgVariables do
  begin
    if Enabled then
    begin
      for NameIndex := 1 to RowCount -1 do
      begin
        SMCNAME := FixGWM_Name(Cells[Ord(gscName), NameIndex]);
        NTERMS := StrToInt(Cells[Ord(gscCount), NameIndex]);
        TypeIndex := Columns[Ord(gscType)].PickList.IndexOf(
          Cells[Ord(gscType), NameIndex]);
        case TypeIndex of
          0:
            begin
              SMCN_TYPE := 'LE';
            end;
          1:
            begin
              SMCN_TYPE := 'GE';
            end;
          2:
            begin
              SMCN_TYPE := 'EQ';
            end;
        else Assert(False);
        end;
        RHS := InternationalStrToFloat(Cells[Ord(gscRightHandSide), NameIndex]);
        // Write data set 3a
        WriteLn(FFile, SMCNAME, ' ', NTERMS, ' ', SMCN_TYPE, ' ', RHS);
        // Write data set 3b
        WriteDataSet3b(NameIndex-1);
      end;
    end;
  end;
end;

procedure TSummaryConstraintsWriter.WriteDataSet3b(
  const NameIndex: integer);
var
  Grid: TDataGrid;
  RowIndex: integer;
  GVNAME: string;
  GVCOEFF: double;
begin
  Grid := frmModflow.dg3dCombinedConstraints.Grids[NameIndex];
  for RowIndex := 1 to Grid.RowCount -1 do
  begin
    GVNAME := FixGWM_Name(Grid.Cells[0,RowIndex]);
    GVCOEFF := InternationalStrToFloat(Grid.Cells[1, RowIndex]);
    WriteLn(FFile, '     ', GVNAME, ' ', GVCOEFF);
  end;
end;

procedure TSummaryConstraintsWriter.WriteFile(const Root: string);
var
  FileName: string;
begin
  if ContinueExport then
  begin
    FileName := GetCurrentDir + '\' + Root + rsSUMCON;
    AssignFile(FFile, FileName);
    try
      if ContinueExport then
      begin
        Rewrite(FFile);
        if ContinueExport then
        begin
          WriteDataReadFrom(FileName);
          WriteDataSet1;
          Application.ProcessMessages;
        end;
        if ContinueExport then
        begin
          WriteDataSet2;
          Application.ProcessMessages;
        end;
        if ContinueExport then
        begin
          WriteDataSet3;
          Application.ProcessMessages;
        end;
      end;
    finally
      CloseFile(FFile);
    end;
    Application.ProcessMessages;
  end;
end;

end.
