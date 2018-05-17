unit framHUF_Unit;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DataGrid, ArgusDataEntry, ExtCtrls;

type
  THUFProp = (hufName, hufHorzAniso, hufVertAniso);
  
  TframHUF = class(TFrame)
    gbHUF: TGroupBox;
    Panel1: TPanel;
    lblHufUnitCount: TLabel;
    adeHufUnitCount: TArgusDataEntry;
    btnAdd: TButton;
    btnInsertUnit: TButton;
    btnDeleteUnit: TButton;
    dgHufUnits: TDataGrid;
    procedure btnDeleteUnitClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure adeHufUnitCountExit(Sender: TObject);
    procedure btnInsertUnitClick(Sender: TObject);
    procedure dgHufUnitsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure dgHufUnitsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure dgHufUnitsExit(Sender: TObject);
    procedure dgHufUnitsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  private
    FEnab: boolean;
    GeoText : string;
    procedure SetEnab(const Value: boolean);
    { Private declarations }
  public
    GeologyRow : integer;
    procedure InitializeGrid;
    property Enab : boolean read FEnab write SetEnab;
    { Public declarations }
  end;

implementation

uses MF_HUF, UtilityFunctions, FixNameUnit;

{$R *.DFM}

procedure TframHUF.btnDeleteUnitClick(Sender: TObject);
Var
  CurrentRow : integer;
//  RowIndex, ColIndex : integer;
  Layer : THUFLayer;
begin
  CurrentRow := GeologyRow;
  if CurrentRow > dgHufUnits.RowCount -1 then
  begin
    CurrentRow := dgHufUnits.RowCount -1
  end;

  // If a row is selected , proceed
  if CurrentRow >= 0 then
  begin
    // Delete the layer associated with the row that was just removed.
    Layer := dgHufUnits.Objects[0,CurrentRow] as THUFLayer;
    if Layer <> nil then
    begin
      Layer.Delete;
    end;

    // remove the currently selected row
    dgHufUnits.DeleteRow(CurrentRow);

    // Change the number of units to the correct number.
    adeHufUnitCount.Text := IntToStr(dgHufUnits.RowCount -1);

    // Disable the delete button if there is only one HUF unit left.
    // Otherwise, enable it.
    btnDeleteUnit.Enabled := Enab and (dgHufUnits.RowCount > 2);

    // update the selected row.
    if GeologyRow > dgHufUnits.RowCount-1 then
    begin
      GeologyRow := dgHufUnits.RowCount-1;
    end;
  end;

end;

procedure TframHUF.btnAddClick(Sender: TObject);
begin
  adeHufUnitCount.Text := IntToStr(StrToInt(adeHufUnitCount.Text) + 1);
  adeHufUnitCountExit(Sender);
end;

procedure TframHUF.adeHufUnitCountExit(Sender: TObject);
begin
  dgHufUnits.RowCount := StrToInt(adeHufUnitCount.Text)+1;
  InitializeGrid;
  btnDeleteUnit.Enabled := Enab and (dgHufUnits.RowCount > 2);
end;

procedure TframHUF.btnInsertUnitClick(Sender: TObject);
var
  CurrentRow : integer;
  RowIndex, ColIndex : integer;
//  PositionToInsert : integer;
begin
  btnAddClick(Sender);

  CurrentRow := GeologyRow;
  for RowIndex := dgHufUnits.RowCount -2 downto CurrentRow do
  begin
    // copy data to latter row.
    for ColIndex := 0 to dgHufUnits.ColCount -1 do
    begin
      dgHufUnits.Cells[ColIndex,RowIndex +1] := dgHufUnits.Cells[ColIndex,RowIndex];
    end;
    dgHufUnits.Objects[0,RowIndex +1] := dgHufUnits.Objects[0,RowIndex];
  end;
  dgHufUnits.Cells[0,CurrentRow] := '';
  InitializeGrid;

end;

procedure TframHUF.InitializeGrid;
const
  kHUF_Root = 'HUF';
var
  RowIndex, ColIndex : integer;
  Names : TStringList;
  NewName : string;
  NameIndex : integer;
  Layer : THUFLayer;
begin
  Names := TStringList.Create;
  try
    for RowIndex := 1 to dgHufUnits.RowCount -1 do
    begin
      for ColIndex := 0 to dgHufUnits.ColCount -1 do
      begin
        if dgHufUnits.Cells[ColIndex,RowIndex] = '' then
        begin
          if ColIndex >= 1 then
          begin
            dgHufUnits.Cells[ColIndex,RowIndex] := '1';
          end
          else
          begin
            Names.Assign(dgHufUnits.Cols[0]);
            NewName := kHUF_Root + IntToStr(RowIndex);
            if Names.IndexOf(NewName) >= 0 then
            begin
              NameIndex := 1;
              NewName := kHUF_Root + IntToStr(NameIndex);
              while Names.IndexOf(NewName) >= 0 do
              begin
                Inc(NameIndex);
                NewName := kHUF_Root + IntToStr(NameIndex);
              end;
            end;
            dgHufUnits.Cells[ColIndex,RowIndex] := NewName;
          end;
        end;
      end;
      Layer := dgHufUnits.Objects[0,RowIndex] as THUFLayer;
      if Layer <> nil then
      begin
        Layer.Rename(dgHufUnits.Cells[0,RowIndex]);
      end;
    end;
  finally
    Names.Free;
  end;
end;

procedure TframHUF.dgHufUnitsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if Sender = dgHufUnits then
  begin
    if GeologyRow <> ARow then
    begin
      GeologyRow := ARow ;
      dgHufUnits.Invalidate;
    end;
  end;
  GeoText := dgHufUnits.Cells[ACol, ARow];
end;

procedure TframHUF.dgHufUnitsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (ARow > 0) then
  begin
    if not Enab then
    begin
      dgHufUnits.Canvas.Brush.Color := clBtnFace;
    end
    else if (ARow = GeologyRow) then
    begin
      dgHufUnits.Canvas.Brush.Color := clAqua;
    end
    else
    begin
      dgHufUnits.Canvas.Brush.Color := clWindow;
    end;
    // set the font color
    dgHufUnits.Canvas.Font.Color := clBlack;
    // draw the text
    dgHufUnits.Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,dgHufUnits.Cells[ACol,ARow]);
    // draw the right and lower cell boundaries in black.
    dgHufUnits.Canvas.Pen.Color := clBlack;
    dgHufUnits.Canvas.MoveTo(Rect.Right,Rect.Top);
    dgHufUnits.Canvas.LineTo(Rect.Right,Rect.Bottom);
    dgHufUnits.Canvas.LineTo(Rect.Left,Rect.Bottom);
  end;
end;

procedure TframHUF.dgHufUnitsExit(Sender: TObject);
begin
  InitializeGrid;
end;

procedure TframHUF.dgHufUnitsSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  Layer : THUFLayer;
  RealValue : double;
  NewName : string;
begin
  if (ARow > 0) then
  begin
    if (ACol = 0) then
    begin
      NewName := FixArgusName(Value);
      if NewName <> Value then
      begin
        Beep;
        dgHufUnits.Cells[ACol, ARow] := NewName;
      end;

      Layer := dgHufUnits.Objects[ACol,ARow] as THUFLayer;
      if Layer <> nil then
      begin
        Layer.Rename(NewName);
      end;
    end
    else
    begin
      if Value <> '' then
      begin
        try
          RealValue := InternationalStrToFloat(Value);
          if RealValue < 0 then
          begin
            Beep;
            dgHufUnits.Cells[ACol,ARow] := GeoText;
          end
          else
          begin
            GeoText := Value;
          end;
        except on EConvertError do
          begin
            Beep;
            dgHufUnits.Cells[ACol,ARow] := GeoText;
          end;
        end;
      end;
    end;
  end;
end;

procedure TframHUF.SetEnab(const Value: boolean);
begin
  FEnab := Value;
  adeHufUnitCount.Enabled := Value;
  if Value then
  begin
    dgHufUnits.Enabled := True;
    dgHufUnits.Color := clWindow;
  end
  else
  begin
    dgHufUnits.Enabled := False;
    dgHufUnits.Color := clBtnFace;
  end;
  btnDeleteUnit.Enabled := Value and (dgHufUnits.RowCount > 2);
  btnInsertUnit.Enabled := Value;
  btnAdd.Enabled := Value;
end;

end.
