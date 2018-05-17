unit WriteGWM_ObjectiveFunction;

interface

uses SysUtils, Forms, Contnrs, frameGWM_Unit, WriteModflowDiscretization;

type
  TNameValue = class(TObject)
    Name: string;
    Value: double;
  end;

  TGWM_ObjectiveFunctionWriter = class;

  TNameValueList = class(TObjectList)
  private
    function GetItem(const Index: integer): TNameValue;
    procedure SetItem(const Index: integer; const Value: TNameValue);
  public
    function Add(const Item: TNameValue): integer; overload;
    function Add(const Name: string; const Value : double): integer; overload;
    property Items[const Index: integer]: TNameValue read GetItem
      Write SetItem; default;
    procedure Evaluate(const AFrame: TframeGWM);
    procedure Write(const Writer: TGWM_ObjectiveFunctionWriter);
  end;

  TGWM_ObjectiveFunctionWriter = class(TModflowWriter)
  private
    FlowVariables: TNameValueList;
    ExternalVariables: TNameValueList;
    BinaryVariables: TNameValueList;
    StateVariables: TNameValueList;
    procedure EvaluateDataSet4;
    procedure EvaluateDataSet5;
    procedure EvaluateDataSet6;
    procedure EvaluateDataSet7;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5;
    procedure WriteDataSet6;
    procedure WriteDataSet7;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteFile(const Root: string);
  end;

implementation

uses UtilityFunctions, Variables, WriteGWM_DecisionVariables, WriteNameFileUnit,
  ProgressUnit;

{ TGWM_ObjectiveFunctionWritere }

constructor TGWM_ObjectiveFunctionWriter.Create;
begin
  inherited Create;
  FlowVariables := TNameValueList.Create;
  ExternalVariables := TNameValueList.Create;
  BinaryVariables := TNameValueList.Create;
  StateVariables := TNameValueList.Create;
end;

destructor TGWM_ObjectiveFunctionWriter.Destroy;
begin
  StateVariables.Free;
  BinaryVariables.Free;
  ExternalVariables.Free;
  FlowVariables.Free;
  inherited;
end;

procedure TGWM_ObjectiveFunctionWriter.EvaluateDataSet4;
begin
  FlowVariables.Evaluate(frmModflow.frameGWM_FlowObjective);
end;

procedure TGWM_ObjectiveFunctionWriter.EvaluateDataSet5;
begin
  ExternalVariables.Evaluate(frmModflow.frameGWM_ExternalObjective);
end;

procedure TGWM_ObjectiveFunctionWriter.EvaluateDataSet6;
begin
  BinaryVariables.Evaluate(frmModflow.frameGWM_BinaryObjective);
end;

procedure TGWM_ObjectiveFunctionWriter.EvaluateDataSet7;
begin
  StateVariables.Evaluate(frmModflow.frameGWM_StateObjective);
end;

procedure TGWM_ObjectiveFunctionWriter.WriteDataSet1;
const
  IPRN = 1;
begin
  WriteLn(FFile, IPRN);
end;

procedure TGWM_ObjectiveFunctionWriter.WriteDataSet2;
var
  OBJTYP: string;
  FNTYP: string;
begin
  case frmModflow.comboGWM_Objective.ItemIndex of
    0:
      begin
        OBJTYP := 'MAX';
      end;
    1:
      begin
        OBJTYP := 'MIN';
      end;
    else Assert(False);
  end;
  case frmModflow.comboGWM_ObjectiveType.ItemIndex of
    0:
      begin
        FNTYP := 'WSDV';
      end;
    1:
      begin
        FNTYP := 'USDV';
      end;
    2:
      begin
        FNTYP := 'MSDV';
      end;
    else Assert(False);
  end;
  WriteLn(FFile, OBJTYP, ' ', FNTYP);
end;

{ TNameValueList }

function TNameValueList.Add(const Name: string;
  const Value: double): integer;
var
  Item: TNameValue;
begin
  Item := TNameValue.Create;
  Item.Name := Name;
  Item.Value := Value;
  result := Add(Item);
end;

function TNameValueList.Add(const Item: TNameValue): integer;
begin
  result := inherited Add(Item);
end;

procedure TNameValueList.Evaluate(const AFrame: TframeGWM);
var
  Index: integer;
  AName: string;
  Value: double;
begin
  if not AFrame.dgVariables.Enabled then Exit;
  for Index := 1 to AFrame.dgVariables.RowCount -1 do
  begin
    AName := FixGWM_Name(AFrame.dgVariables.Cells[0, Index]);
    Value := InternationalStrToFloat(AFrame.dgVariables.Cells[1, Index]);
    Add(AName, Value);
  end;
end;

function TNameValueList.GetItem(const Index: integer): TNameValue;
begin
  result := inherited Items[Index] as TNameValue
end;

procedure TNameValueList.SetItem(const Index: integer;
  const Value: TNameValue);
begin
  inherited Items[Index] := Value;
end;

procedure TNameValueList.Write(const Writer: TGWM_ObjectiveFunctionWriter);
var
  Index: integer;
  Item: TNameValue;
begin
  for Index := 0 to Count -1 do
  begin
    Item := Items[Index];
    WriteLn(Writer.FFile, Item.Name, ' ', Item.Value);
  end;
end;

procedure TGWM_ObjectiveFunctionWriter.WriteDataSet3;
var
  NFVOBJ, NEVOBJ, NBVOBJ, NSVOBJ: integer;
begin
  NFVOBJ := FlowVariables.Count;
  NEVOBJ :=  ExternalVariables.Count;
  NBVOBJ :=  BinaryVariables.Count;
  NSVOBJ :=  StateVariables.Count;
  WriteLn(FFile, NFVOBJ, ' ', NEVOBJ, ' ', NBVOBJ, ' ', NSVOBJ);
end;

procedure TGWM_ObjectiveFunctionWriter.WriteDataSet4;
begin
  FlowVariables.Write(self);
end;

procedure TGWM_ObjectiveFunctionWriter.WriteDataSet5;
begin
  ExternalVariables.Write(self);
end;

procedure TGWM_ObjectiveFunctionWriter.WriteDataSet6;
begin
  BinaryVariables.Write(self);
end;

procedure TGWM_ObjectiveFunctionWriter.WriteDataSet7;
begin
  StateVariables.Write(self);
end;

procedure TGWM_ObjectiveFunctionWriter.WriteFile(const Root: string);
var
  FileName: string;
begin
  frmProgress.lblPackage.Caption := 'GWM Objective Function';
  frmProgress.pbPackage.Position := 0;
  Application.ProcessMessages;

  if ContinueExport then
  begin
    EvaluateDataSet4;
  end;

  if ContinueExport then
  begin
    EvaluateDataSet5;
  end;

  if ContinueExport then
  begin
    EvaluateDataSet6;
  end;

  if ContinueExport then
  begin
    EvaluateDataSet7;
  end;

  if ContinueExport then
  begin

    FileName := GetCurrentDir + '\' + Root + rsOBJFNC;
    AssignFile(FFile,FileName);
    try
      if ContinueExport then
      begin
        Rewrite(FFile);
        WriteDataReadFrom(FileName);
        frmProgress.lblActivity.Caption := 'Writing Data Set 1';
        WriteDataSet1;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        frmProgress.lblActivity.Caption := 'Writing Data Set 2';
        WriteDataSet2;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        frmProgress.lblActivity.Caption := 'Writing Data Set 3';
        WriteDataSet3;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        frmProgress.lblActivity.Caption := 'Writing Data Set 4';
        WriteDataSet4;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        frmProgress.lblActivity.Caption := 'Writing Data Set 5';
        WriteDataSet5;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        frmProgress.lblActivity.Caption := 'Writing Data Set 6';
        WriteDataSet6;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        frmProgress.lblActivity.Caption := 'Writing Data Set 7';
        WriteDataSet7;
        frmProgress.pbPackage.StepIt;
        Application.ProcessMessages;
      end;
    finally
      CloseFile(FFile);
    end;

    Application.ProcessMessages;
  end;
end;

end.
