unit frmPreviewUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, IntListUnit, StdCtrls, CheckLst, DataGrid, Buttons, ExtCtrls,
  ComCtrls, ArgusDataEntry, ArgusFormUnit;

type
  TfrmPreview = class(TArgusForm)
    sgPreview: TDataGrid;
    Panel1: TPanel;
    btnNext: TBitBtn;
    btnBack: TBitBtn;
    btnCancel: TBitBtn;
    BitBtn1: TBitBtn;
    pnlInstructions: TPanel;
    lblInstructions: TLabel;
    StatusBar1: TStatusBar;
    adeMultiplier: TArgusDataEntry;
    lblMultiplier: TLabel;
    Timer1: TTimer;
    procedure sgPreview1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure sgPreviewDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgPreview2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCancelClick(Sender: TObject);
    procedure sgPreviewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sgPreviewSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure adeMultiplierEnter(Sender: TObject);
  private
    SeparatorPositions: TIntegerList;
    PreviewText: TStringList;
    Step: Integer;
    LabelWidth: integer;
    Adjusted: boolean;
    RequiredColCount: integer;
    RequiredRowCount: integer;
    procedure GeneratePositions;
    procedure AdjustCellWidths;
    procedure LabelColumns;
    procedure LabelRows;
    procedure ChangeStep;
    function TestValidity: boolean;
    procedure TryToFindBreaks;
    { Private declarations }
  public
    UnUsedColumns: TIntegerList;
    TimerCount: integer;
    procedure SetData(Input: TStrings; ColCount, RowCount: integer);
    { Public declarations }
  end;

var
  frmPreview: TfrmPreview;

implementation

uses Clipbrd;

{$R *.DFM}

//const DividerWidth = 1;

procedure TfrmPreview.sgPreview1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
  SelectWidth = 10;
var
  ACol, ARow: integer;
  Nearest: integer;
  RowIndex, ColIndex: integer;
  First, Last, Middle: integer;
  AString: string;
  ScrollBarPosition: integer;
begin
  TimerCount := 20;
  sgPreview.MouseToCell(X, Y, ACol, ARow);
  if (ARow = 0) and (ACol > 0) then
  begin
    GeneratePositions;
    ScrollBarPosition := sgPreview.LeftCol;
    X := X + SeparatorPositions[ScrollBarPosition - 1] - sgPreview.ColWidths[0]
      - sgPreview.GridLineWidth;
    Nearest := SeparatorPositions.Nearest(X);
    if Abs(SeparatorPositions[Nearest] - X) < SelectWidth then
    begin
      if (Nearest <> 0) and (Nearest <> SeparatorPositions.Count - 1) then
      begin
        SeparatorPositions.Delete(Nearest);
        for RowIndex := 1 to sgPreview.RowCount - 1 do
        begin
          sgPreview.Cells[Nearest, RowIndex] :=
            sgPreview.Cells[Nearest, RowIndex]
            + sgPreview.Cells[Nearest + 1, RowIndex];
        end;
        for ColIndex := Nearest + 1 to sgPreview.ColCount - 1 do
        begin
          sgPreview.Cols[ColIndex] := sgPreview.Cols[ColIndex + 1];
        end;
        sgPreview.ColCount := sgPreview.ColCount - 1;
      end;
    end
    else
    begin
      SeparatorPositions.Add(X);
      sgPreview.ColCount := sgPreview.ColCount + 1;
      for ColIndex := sgPreview.ColCount - 1 downto ACol + 2 do
      begin
        sgPreview.Cols[ColIndex] := sgPreview.Cols[ColIndex - 1];
      end;
      for RowIndex := 1 to sgPreview.RowCount - 1 do
      begin
        AString := sgPreview.Cells[ACol, RowIndex];
        First := 0;
        Last := Length(AString);
        if Last >= 1 then
        begin
          if Last = 1 then
          begin
            if sgPreview.Canvas.TextWidth(AString) / 2 + 2
              + SeparatorPositions[ACol] > X then
            begin
              sgPreview.Cells[ACol + 1, RowIndex] := AString;
              sgPreview.Cells[ACol, RowIndex] := '';
            end
            else
            begin
              sgPreview.Cells[ACol + 1, RowIndex] := '';
              sgPreview.Cells[ACol, RowIndex] := AString;
            end;
          end
          else
          begin
            while Last - First > 1 do
            begin
              Middle := (Last + First) div 2;
              if sgPreview.Canvas.TextWidth(Copy(AString, 1, Middle)) + 2
                + SeparatorPositions[ACol - 1] > X then
              begin
                Last := Middle;
              end
              else
              begin
                First := Middle;
              end;
            end;
            if sgPreview.Canvas.TextWidth(Copy(AString, 1, First))
              + sgPreview.Canvas.TextWidth(Copy(AString, First + 1, 1)) / 2
              + 2 + SeparatorPositions[ACol - 1] > X then
            begin
              sgPreview.Cells[ACol, RowIndex] := Copy(AString, 1, First);
              sgPreview.Cells[ACol + 1, RowIndex] := Copy(AString, First + 1,
                MAXINT);
            end
            else
            begin
              sgPreview.Cells[ACol, RowIndex] := Copy(AString, 1, First + 1);
              sgPreview.Cells[ACol + 1, RowIndex] := Copy(AString, First + 2,
                MAXINT);
            end;
          end;
        end;
      end;
    end;
    AdjustCellWidths;
    LabelColumns;
    sgPreview.LeftCol := ScrollBarPosition;
  end;
end;

procedure TfrmPreview.FormCreate(Sender: TObject);
begin
  SeparatorPositions := TIntegerList.Create;
  UnUsedColumns := TIntegerList.Create;
  PreviewText := TStringList.Create;
  Step := 0;
  Constraints.MinWidth := Width;
  LabelWidth := lblInstructions.Width;
  Adjusted := False;
end;

procedure TfrmPreview.FormDestroy(Sender: TObject);
begin
  SeparatorPositions.Free;
  UnUsedColumns.Free;
  PreviewText.Free;
end;

procedure TfrmPreview.GeneratePositions;
var
  Index: integer;
  NextValue: integer;
begin
  SeparatorPositions.Clear;
  NextValue := 0;
  SeparatorPositions.Add(NextValue);
  for Index := 1 to sgPreview.ColCount - 1 do
  begin
    NextValue := NextValue + sgPreview.ColWidths[Index] +
      sgPreview.GridLineWidth;
    SeparatorPositions.Add(NextValue);
  end;
  SeparatorPositions.Sort;
end;

procedure TfrmPreview.SetData(Input: TStrings; ColCount, RowCount: integer);
var
  Index: integer;
begin
  RequiredColCount := ColCount;
  RequiredRowCount := RowCount;
  sgPreview.ColCount := 2;
  PreviewText.Assign(Input);
  sgPreview.RowCount := PreviewText.Count + 1;
  for Index := 0 to PreviewText.Count - 1 do
  begin
    sgPreview.Cells[1, Index + 1] := PreviewText[Index];
  end;
  TryToFindBreaks;
  LabelColumns;
  LabelRows;
  AdjustCellWidths;
  sgPreview.Invalidate;
end;

procedure TfrmPreview.TryToFindBreaks;
const
  Separators = [' ', ',', #9];
var
  BreakPositions: TIntegerList;
  RowIndex, CharIndex: integer;
  MaxLength: integer;
  MaxLine: integer;
  ALine: string;
  BreakIndex: integer;
  EndBreak: integer;
  CellValue: string;
  NextBreak: integer;
  BI: integer;
begin
  if sgPreview.RowCount <= 1 then
    Exit;
  BreakPositions := TIntegerList.Create;
  try
    with sgPreview.Cols[1] do
    begin
      MaxLength := Length(Strings[1]);
      MaxLine := 1;
      for RowIndex := 2 to Count - 1 do
      begin
        if MaxLength < Length(Strings[RowIndex]) then
        begin
          MaxLength := Length(Strings[RowIndex]);
          MaxLine := RowIndex;
        end;
      end;
      ALine := Strings[MaxLine];
      for CharIndex := 1 to MaxLength do
      begin
        if ALine[CharIndex] in Separators then
        begin
          BreakPositions.Add(CharIndex);
        end;
      end;
      for RowIndex := 1 to Count - 1 do
      begin
        if RowIndex = MaxLine then
          Continue;
        ALine := Strings[RowIndex];
        for BreakIndex := BreakPositions.Count - 1 downto 0 do
        begin
          NextBreak := BreakPositions[BreakIndex];
          if (NextBreak <= Length(ALine))
            and not (ALine[BreakPositions[BreakIndex]] in Separators) then
          begin
            BreakPositions.Delete(BreakIndex);
          end;
        end;
      end;
      for BreakIndex := BreakPositions.Count - 1 downto 1 do
      begin
        if BreakPositions[BreakIndex] - BreakPositions[BreakIndex - 1] = 1 then
        begin
          BreakPositions.Delete(BreakIndex);
        end;
      end;
      if (BreakPositions.Count > 0) and (BreakPositions[0] = 1) then
      begin
        BreakPositions.Delete(0);
      end;
      if BreakPositions.Count = 0 then
        Exit;
      sgPreview.ColCount := BreakPositions.Count + 2;
      for RowIndex := 1 to Count - 1 do
      begin
        ALine := Strings[RowIndex];
        BI := 0;
        for BreakIndex := BreakPositions.Count - 1 downto 0 do
        begin
          BI := BreakIndex;
          NextBreak := BreakPositions[BreakIndex];
          if BreakIndex = BreakPositions.Count - 1 then
          begin
            CellValue :=
              Copy(Aline, NextBreak, MAXINT);
          end
          else
          begin
            CellValue :=
              Copy(Aline, NextBreak, EndBreak - NextBreak);
          end;
          sgPreview.Cells[BreakIndex + 2, RowIndex] := CellValue;
          EndBreak := NextBreak;
        end;
        sgPreview.Cells[BI + 2, RowIndex] :=
          Copy(Aline, 1, EndBreak - 1);
      end;
    end;
  finally
    BreakPositions.Free;
  end;
end;

procedure TfrmPreview.AdjustCellWidths;
var
  ColIndex, RowIndex: integer;
  NewWidth: integer;
  TestWidth: integer;
begin
  for ColIndex := 0 to sgPreview.ColCount - 1 do
  begin
    NewWidth := 0;
    for RowIndex := 0 to sgPreview.RowCount - 1 do
    begin
      TestWidth := sgPreview.Canvas.TextWidth(sgPreview.Cells[ColIndex,
        RowIndex]) + 4;
      if TestWidth > NewWidth then
      begin
        NewWidth := TestWidth;
      end;
    end;
    sgPreview.ColWidths[ColIndex] := NewWidth;
  end;
end;

procedure TfrmPreview.LabelColumns;
var
  ColIndex: integer;
  ColNumber: integer;
begin
  ColNumber := 1;
  for ColIndex := 1 to sgPreview.ColCount - 1 do
  begin
    if UnUsedColumns.IndexOf(ColIndex) < 0 then
    begin
      with sgPreview.Columns[ColIndex].Title do
      begin
        Caption := IntToStr(ColNumber);
        Alignment := taRightJustify;
      end;
      Inc(ColNumber);
    end
    else
    begin
      with sgPreview.Columns[ColIndex].Title do
      begin
        Caption := 'not used';
        Alignment := taRightJustify;
      end;
    end;
    sgPreview.Cells[ColIndex, 0] := sgPreview.Columns[ColIndex].Title.Caption;
  end;
end;

procedure TfrmPreview.btnNextClick(Sender: TObject);
begin
  Inc(Step);
  ChangeStep;
end;

procedure TfrmPreview.btnBackClick(Sender: TObject);
begin
  Dec(Step);
  ChangeStep;
end;

procedure TfrmPreview.ChangeStep;
begin
  case Step of
    0:
      begin
        adeMultiplier.Visible := False;
        lblMultiplier.Visible := False;
        btnBack.Enabled := False;
        btnNext.Caption := 'Next';
        sgPreview.OnMouseUp := sgPreview1MouseUp;
        lblInstructions.Caption :=
          'Click on the column headings of the table to add or remove a separator.';
      end;
    1:
      begin
        adeMultiplier.Visible := False;
        lblMultiplier.Visible := False;
        btnBack.Enabled := True;
        btnNext.Caption := 'Next';
        sgPreview.OnMouseUp := sgPreview2MouseUp;
        lblInstructions.Caption :=
          'Click on a column heading to indicate which columns should or should not be used.';
      end;
    2:
      begin
        if not TestValidity then
        begin
          ChangeStep;
          Exit;
        end;
        adeMultiplier.Visible := True;
        lblMultiplier.Visible := True;
        btnBack.Enabled := True;
        btnNext.Caption := 'Finish';
        sgPreview.OnMouseUp := nil;
        lblInstructions.Caption := 'Specify the Multiplier.';
      end;
    3:
      begin
        ModalResult := mrOK;
      end;
  else
    Assert(False);
  end;
  lblInstructions.Font.Style := [fsBold];
  TimerCount := 0;
  Timer1.Enabled := True;
end;

function TfrmPreview.TestValidity: boolean;
var
  ColIndex, RowIndex, Index: integer;
  Value: double;
  Code: integer;
  AString: string;
  Column: integer;
  ColumnCount: integer;
begin
  Column := 0;
  result := True;
  for ColIndex := 1 to sgPreview.ColCount - 1 do
  begin
    if UnUsedColumns.IndexOf(ColIndex) > -1 then
    begin
      Continue;
    end;
    Inc(Column);
    for RowIndex := 1 to sgPreview.RowCount - 1 do
    begin
      AString := Trim(sgPreview.Cells[ColIndex, RowIndex]);
      if AString = '' then
      begin
        Continue;
      end
      else
      begin
        Val(AString, Value, Code);
        if Code <> 0 then
        begin
          result := False;
          Beep;
          MessageDlg('The value"' + AString
            + '" in column = ' + IntToStr(Column)
            + '; row = ' + IntToStr(RowIndex + 1)
            + ' is invalid.  Please check it.', mtError, [mbOK], 0);
          Step := 0;
          Exit;
        end;
      end;
    end;
  end;
  for Index := UnUsedColumns.Count - 1 downto 0 do
  begin
    if UnUsedColumns[Index] >= sgPreview.ColCount then
    begin
      UnUsedColumns.Delete(Index);
    end
    else
    begin
      break;
    end;
  end;

  ColumnCount := sgPreview.ColCount - 1 - UnUsedColumns.Count;
  if ColumnCount < RequiredColCount then
  begin
    Beep;
    if MessageDlg('There are ' + IntToStr(ColumnCount)
      + ' columns in your data but the number required is '
      + IntToStr(RequiredColCount) + '.  Do you want to correct this by adding '
      + IntToStr(RequiredColCount - ColumnCount)
      + ' extra blank columns?', mtWarning, [mbYes, mbNo], 0) = mrYes then
    begin
      sgPreview.ColCount := sgPreview.ColCount + RequiredColCount - ColumnCount;
    end
    else
    begin
      Step := 0;
      Result := False;
      Exit;
    end;
  end;
  if ColumnCount > RequiredColCount then
  begin
    Beep;
    MessageDlg('There are ' + IntToStr(ColumnCount)
      + ' columns in your data but the number required is '
      + IntToStr(RequiredColCount) + '.  You should click on some column '
      + 'headings to indicate which ones should not be used.', mtError,
      [mbOK], 0);
    Step := 1;
    Result := False;
    Exit;
  end;
end;

procedure TfrmPreview.sgPreviewDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (ARow > 0) and (UnUsedColumns.IndexOf(ACol) > -1) then
  begin
    with sgPreview do
    begin
      with Canvas do
      begin
        Brush.Color := clBtnFace;
        FillRect(Rect);
        Pen.Color := clBlack;
        Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
      end;
    end;
  end;
end;

procedure TfrmPreview.sgPreview2MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: integer;
  Position: integer;
begin
  TimerCount := 20;
  sgPreview.MouseToCell(X, Y, ACol, ARow);
  Position := UnUsedColumns.IndexOf(ACol);
  if Position > -1 then
  begin
    UnUsedColumns.Delete(Position);
  end
  else
  begin
    UnUsedColumns.Add(ACol);
  end;
  UnUsedColumns.Sort;
  LabelColumns;
  AdjustCellWidths;
  sgPreview.Invalidate;
end;

procedure TfrmPreview.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPreview.sgPreviewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: integer;
  Index: integer;
  Column: integer;
begin
  sgPreview.MouseToCell(X, Y, ACol, ARow);
  Column := 0;
  for Index := 1 to ACol do
  begin
    if UnUsedColumns.IndexOf(Index) > -1 then
    begin
      Continue;
    end;
    Inc(Column);
  end;

  StatusBar1.SimpleText := 'Column = ' + IntToStr(Column) + '; Row = ' +
    IntToStr(ARow);
end;

procedure TfrmPreview.sgPreviewSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  CanSelect := False;
end;

procedure TfrmPreview.LabelRows;
var
  Index: integer;
begin
  for Index := 1 to sgPreview.RowCount - 1 do
  begin
    sgPreview.Cells[0, Index] := IntToStr(Index);
  end;
end;

procedure TfrmPreview.Timer1Timer(Sender: TObject);
begin
  if not Adjusted then
  begin
    Adjusted := True;
    AdjustCellWidths;
    Timer1.Enabled := False;
    Timer1.Interval := 500;
    Exit;
  end;
  Inc(TimerCount);
  if TimerCount >= 10 then
  begin
    Timer1.Enabled := False;
    lblInstructions.Font.Color := clBlack;
    lblInstructions.Font.Style := [];
    lblInstructions.Width := LabelWidth;
    lblInstructions.Left := (pnlInstructions.Width - lblInstructions.Width) div
      2;
    Exit;
  end;
  if Odd(TimerCount) then
  begin
    lblInstructions.Font.Color := clRed;
    lblInstructions.Width := LabelWidth;
    lblInstructions.Left := (pnlInstructions.Width - lblInstructions.Width) div
      2;
  end
  else
  begin
    lblInstructions.Font.Color := clBlack;
    lblInstructions.Width := LabelWidth;
    lblInstructions.Left := (pnlInstructions.Width - lblInstructions.Width) div
      2;
  end;
end;

procedure TfrmPreview.adeMultiplierEnter(Sender: TObject);
begin
  TimerCount := 20;
end;

end.

