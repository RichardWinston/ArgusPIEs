unit frameOutputControlUnit;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, RbwDataGrid2, ExtCtrls, StdCtrls, ArgusDataEntry;

type
  TframeOutputControl = class(TFrame)
    pnlBottom: TPanel;
    rdgOutputControl: TRbwDataGrid2;
    adeOutControlCount: TArgusDataEntry;
    lblNumberOfRows: TLabel;
    procedure adeOutControlCountExit(Sender: TObject);
  private
    Function MaxPeriod: integer;
    function MaxTimeStep(const Period: integer): integer;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure Sort;
    // @name fills List with @link(TPeriodTimeStep)s.
    // The calling routine is responsible for freeing the
    // @link(TPeriodTimeStep)s.
    procedure FillPerStepList(const List: TList);
    { Public declarations }
  end;

  TPeriodTimeStep = class(TObject)
    Period: integer;
    TimeStep: integer;
  end;

implementation

uses contnrs, Variables, Math;

{$R *.DFM}

function SortPeriodTimes(Item1, Item2: Pointer): Integer;
var
  PT1, PT2: TPeriodTimeStep;
begin
  PT1 := Item1;
  PT2 := Item2;
  result := PT1.Period - PT2.Period;
  if result = 0 then
  begin
    result := PT1.TimeStep - PT2.TimeStep;
  end;
end;

{ TfrmOutputControl }

constructor TframeOutputControl.Create(AOwner: TComponent);
begin
  inherited;
  adeOutControlCount.Max := MAXINT;
  rdgOutputControl.Cells[0,0] := 'Stress Period';
  rdgOutputControl.Cells[1,0] := 'Time Step';
end;

procedure TframeOutputControl.adeOutControlCountExit(Sender: TObject);
begin
  rdgOutputControl.RowCount := Max(StrToInt(adeOutControlCount.Text) + 1, 2);
end;

procedure TframeOutputControl.Sort;
var
  List: TList;
  Index: integer;
  PT: TPeriodTimeStep;
begin
  List := TObjectList.Create;
  try
    FillPerStepList(List);

    if List.Count = 0 then
    begin
      adeOutControlCount.Text := '0';
      rdgOutputControl.RowCount := 2;
      rdgOutputControl.FixedRows := 1;
    end
    else
    begin
      adeOutControlCount.Text := IntToStr(List.Count);
      rdgOutputControl.RowCount := List.Count + 1;

      for Index := 0 to List.Count -1 do
      begin
        PT := List[Index];
        rdgOutputControl.Cells[0,Index+1] := IntToStr(PT.Period);
        rdgOutputControl.Cells[1,Index+1] := IntToStr(PT.TimeStep);
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TframeOutputControl.FillPerStepList(const List: TList);
var
  MaxPer: integer;
  Index: integer;
  Period, TimeStep: integer;
  PT: TPeriodTimeStep;
begin
  if StrToInt(adeOutControlCount.Text) = 0 then
  begin
    Exit;
  end;

  MaxPer := MaxPeriod;
  for Index := 1 to rdgOutputControl.RowCount -1 do
  begin
    Period := 0;
    if rdgOutputControl.Cells[0,Index] <> '' then
    begin
      try
        Period := StrToInt(rdgOutputControl.Cells[0,Index]);
        if (Period < 1) or (Period > MaxPer) then
        begin
          Continue;
        end;
      except on EConvertError do
        begin
          Continue;
        end;
      end;
    end
    else
    begin
      Continue;
    end;

    TimeStep := 1;
    if rdgOutputControl.Cells[1,Index] <> '' then
    begin
      try
        TimeStep := StrToInt(rdgOutputControl.Cells[1,Index]);
        if (TimeStep < 1) or (TimeStep > MaxTimeStep(Period)) then
        begin
          Continue;
        end;
      except on EConvertError do
        begin
          Continue;
        end;
      end;
    end
    else
    begin
      Continue;
    end;

    PT := TPeriodTimeStep.Create;
    PT.Period := Period;
    PT.TimeStep := TimeStep;

    List.Add(PT);
  end;

  List.Sort(SortPeriodTimes);
end;

function TframeOutputControl.MaxPeriod: integer;
begin
  result := frmModflow.dgTime.RowCount -1;
end;

function TframeOutputControl.MaxTimeStep(const Period: integer): integer;
begin
  result := StrToInt(frmModflow.dgTime.Cells[2,Period]);
end;

end.
