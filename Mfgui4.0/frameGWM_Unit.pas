unit frameGWM_Unit;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, RbwDataGrid2, ArgusDataEntry, ExtCtrls;

type
  TframeGWM = class(TFrame)
    pnlBottom: TPanel;
    adeDecisionVariableCount: TArgusDataEntry;
    btnAdd: TButton;
    dgVariables: TRbwDataGrid2;
    btnInsert: TButton;
    btnDelete: TButton;
    lblDecisionVariableCount: TLabel;
    procedure adeDecisionVariableCountExit(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TframeGWM.adeDecisionVariableCountExit(Sender: TObject);
var
  NewNumberOfVariables: integer;
  OldRowCount: integer;
  ColIndex, RowIndex: integer;
begin
  NewNumberOfVariables := StrToInt(adeDecisionVariableCount.Text);
  dgVariables.Enabled := NewNumberOfVariables >= 1;
  btnDelete.Enabled := dgVariables.Enabled;
  if NewNumberOfVariables < 1 then
  begin
    NewNumberOfVariables := 1;
  end;
  OldRowCount := dgVariables.RowCount;
  dgVariables.RowCount := NewNumberOfVariables + 1;
  for RowIndex := OldRowCount to NewNumberOfVariables do
  begin
    if RowIndex = 1 then
    begin
      Continue;
    end;
    for ColIndex := 0 to dgVariables.ColCount -1 do
    begin
      if dgVariables.Columns[ColIndex].Format = rcf2Boolean then
      begin
        dgVariables.CheckState[ColIndex, RowIndex] :=
          dgVariables.CheckState[ColIndex, RowIndex -1];
      end
      else
      begin
        dgVariables.Cells[ColIndex, RowIndex] :=
          dgVariables.Cells[ColIndex, RowIndex-1];
      end;
    end;
  end;
end;

procedure TframeGWM.btnAddClick(Sender: TObject);
var
  NewNumberOfVariables: integer;
begin
  NewNumberOfVariables := StrToInt(adeDecisionVariableCount.Text) + 1;
  adeDecisionVariableCount.Text := IntToStr(NewNumberOfVariables);
  adeDecisionVariableCountExit(nil);
end;

procedure TframeGWM.btnDeleteClick(Sender: TObject);
var
  RowToDelete: integer;
  NewNumberOfVariables: integer;
begin
  RowToDelete := dgVariables.SelectedRow;
  if RowToDelete >= 1 then
  begin
    if dgVariables.RowCount > 2 then
    begin
      dgVariables.DeleteRow(RowToDelete);
    end;
    NewNumberOfVariables := StrToInt(adeDecisionVariableCount.Text) - 1;
    adeDecisionVariableCount.Text := IntToStr(NewNumberOfVariables);
    adeDecisionVariableCountExit(nil);
  end;
end;

procedure TframeGWM.btnInsertClick(Sender: TObject);
var
  RowToInsert: integer;
  RowIndex: integer;
  ColIndex: integer;
begin
  RowToInsert := dgVariables.SelectedRow;
  if RowToInsert >= 1 then
  begin
    btnAddClick(nil);
    for RowIndex := dgVariables.RowCount -1 downto RowToInsert + 1 do
    begin
      if RowIndex = 1 then
      begin
        Continue;
      end;
      for ColIndex := 0 to dgVariables.ColCount -1 do
      begin
        if dgVariables.Columns[ColIndex].Format = rcf2Boolean then
        begin
          dgVariables.CheckState[ColIndex, RowIndex] :=
            dgVariables.CheckState[ColIndex, RowIndex -1];
        end
        else
        begin
          dgVariables.Cells[ColIndex, RowIndex] :=
            dgVariables.Cells[ColIndex, RowIndex-1];
        end;
      end;
    end;
  end;

end;

constructor TframeGWM.Create(AOwner: TComponent);
begin
  inherited;
  dgVariables.Cells[0,0] := 'Name';
  dgVariables.Cells[1,0] := 'Type';
end;

end.
