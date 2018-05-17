unit frmDataValuesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    RealListUnit, StdCtrls, Buttons, ExtCtrls, Grids, DataGrid, ArgusFormUnit,
    AnePIE, OptionsUnit, ArgusDataEntry;

type
  TDataValues = class(TObject)
  private
//    FObjectIndex : ANE_INT32;
    FX, FY : ANE_DOUBLE;
    Procedure SetX (const AValue : ANE_DOUBLE);
    Procedure SetY (const AValue : ANE_DOUBLE);
  public
    Modified : boolean;
    Values : TRealList;
    constructor Create{(ObjectIndex : ANE_INT32)};
    Destructor Destroy; override;
    function Edit(Names: TStrings) : boolean;
    property X : ANE_DOUBLE read FX Write SetX;
    property Y : ANE_DOUBLE read FY Write SetY;
  end;

  TfrmDataValues = class(TArgusForm)
    dgValues: TDataGrid;
    Panel1: TPanel;
    btnOK: TBitBtn;
    btCancel: TBitBtn;
    Panel2: TPanel;
    lblX: TLabel;
    lblY: TLabel;
    adeX: TArgusDataEntry;
    adeY: TArgusDataEntry;
    procedure dgValuesSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormCreate(Sender: TObject); override;
    procedure adeXExit(Sender: TObject);
    procedure adeYExit(Sender: TObject);
    procedure dgValuesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    DataModified : boolean;
    DataValues : TDataValues;
    { Private declarations }
  public
    { Public declarations }
  end;

procedure SetColumnWidths(DataGrid : TDataGrid);

var
  frmDataValues : TfrmDataValues;

implementation

{$R *.DFM}

{ TDataValues }

procedure SetColumnWidths(DataGrid : TDataGrid);
var
  ColIndex, RowIndex, Width, TempWidth : integer;
begin
  for ColIndex := 0 to DataGrid.ColCount -1 do
  begin
    Width := DataGrid.Canvas.TextWidth(DataGrid.Columns[ColIndex].Title.Caption);
    for RowIndex := 1 to DataGrid.RowCount -1 do
    begin
      TempWidth := DataGrid.Canvas.TextWidth(DataGrid.Cells[ColIndex,RowIndex]);
      if TempWidth > Width then
      begin
        Width := TempWidth;
      end;
    end;

    DataGrid.ColWidths[ColIndex] := Width + 10;
  end;

end;


constructor TDataValues.Create{(ObjectIndex : ANE_INT32)};
begin
//  FObjectIndex := ObjectIndex;
  Values := TRealList.Create;
  Modified := False;
end;

destructor TDataValues.Destroy;
begin
  Values.Free;
end;

function TDataValues.Edit(Names: TStrings) : boolean;
var
//  frmDataValues : TfrmDataValues;
  Index : integer;
  TempRealList : TRealList;
  TempX, TempY : double;
begin
  result := False;
  Assert(Values.Count = Names.Count);

  try
    Application.CreateForm(TfrmDataValues, frmDataValues);
    With frmDataValues do
    begin
      DataValues := self;
      adeX.Text := FloatToStr(X);
      adeY.Text := FloatToStr(Y);
      dgValues.RowCount := Values.Count + 1;
      for Index := 1 to dgValues.RowCount - 1 do
      begin
        dgValues.Cells[0,Index] := Names[Index-1];
        dgValues.Cells[1,Index] := FloatToStr(Values[Index-1]);
      end;
      SetColumnWidths(frmDataValues.dgValues);
      TempRealList := TRealList.Create;
      try
        TempX := X;
        TempY := Y;
        TempRealList.Assign(Values);
        if frmDataValues.showModal = mrOK then
        begin
          result := frmDataValues.DataModified or Modified;
        end
        else
        begin
          Values.assign(TempRealList);
          X := TempX;
          Y := TempY;
        end;
      finally
        TempRealList.Free;
      end;
    end;
  finally
    FreeAndNil(frmDataValues);
//    frmDataValues.Free;
  end;
end;

procedure TfrmDataValues.dgValuesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  if Value <> '' then
  begin
    DataValues.Values[ARow-1] := StrToFloat(Value);
    DataModified := True;
  end;
end;




procedure TfrmDataValues.FormCreate(Sender: TObject);
begin
  inherited;
  Constraints.MinWidth := Width;
  DataModified := False;
end;

procedure TfrmDataValues.adeXExit(Sender: TObject);
begin
  inherited;
  DataValues.X := StrToFloat(adeX.Output);
  DataModified := True;
end;

procedure TfrmDataValues.adeYExit(Sender: TObject);
begin
  inherited;
  DataValues.Y := StrToFloat(adeY.Output);
  DataModified := True;
end;

procedure TfrmDataValues.dgValuesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = 9) and (dgValues.Col = dgValues.ColCount -1)
    and (dgValues.Row = dgValues.RowCount -1)then
  begin
    btnOK.SetFocus
  end;

end;

procedure TDataValues.SetX(const AValue: ANE_DOUBLE);
begin
  FX := AValue;
//  if FX > frmDataEdit.MaxX then frmDataEdit.ShowWarning := True;
//  if FX < frmDataEdit.MinX then frmDataEdit.ShowWarning := True;
end;

procedure TDataValues.SetY(const AValue: ANE_DOUBLE);
begin
  FY := AValue;
//  if FY > frmDataEdit.MaxY then frmDataEdit.ShowWarning := True;
//  if FY < frmDataEdit.MinY then frmDataEdit.ShowWarning := True;
end;


end.
