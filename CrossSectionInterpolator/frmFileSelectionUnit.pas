unit frmFileSelectionUnit;

interface

uses
  Windows, Messages, SysUtils,
  {$IFDEF VER190}
  Variants,
  {$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, ARGUSFORMUNIT, ExtCtrls, Grids, RbwDataGrid2, Buttons, StdCtrls,
  XBase1;

type
  TfrmFileSelection = class(TArgusForm)
    Panel1: TPanel;
    btnDelete: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    rdg2FileNames: TRbwDataGrid2;
    btnSelect: TButton;
    OpenDialog1: TOpenDialog;
    XBase1: TXBase;
    procedure FormDestroy(Sender: TObject); override;
    procedure rdg2FileNamesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure rdg2FileNamesSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure FormCreate(Sender: TObject); override;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
  private
    SelectedField: boolean;
    procedure AddAShapeFile(FileName: string; Row: Integer);
    procedure DeleteARow(Row: Integer);
    { Private declarations }
  public
    procedure ModelComponentName(AStringList: TStringList); override;
    { Public declarations }
  end;

var
  frmFileSelection: TfrmFileSelection;

implementation

{$R *.dfm}

procedure TfrmFileSelection.btnSelectClick(Sender: TObject);
var
  Index: integer;
  FirstRow: integer;
  NewWidth: integer;
  Files: TStringList;
begin
  inherited;
  if OpenDialog1.Execute then
  begin
    for Index := rdg2FileNames.RowCount -1 downto 1 do
    begin
      if rdg2FileNames.Cells[0,Index] = '' then
      begin
        if rdg2FileNames.RowCount > 2 then
        begin
          DeleteARow(Index);
        end;
      end;
    end;
    FirstRow := rdg2FileNames.RowCount;
    for Index := 1 to rdg2FileNames.RowCount -1 do
    begin
      if rdg2FileNames.Cells[0,Index] = '' then
      begin
        FirstRow := Index;
        Break;
      end;
    end;
    rdg2FileNames.RowCount := FirstRow + OpenDialog1.Files.Count;
    Files := TStringList.Create;
    try
      Files.AddStrings(OpenDialog1.Files);
      Files.Sort;
      for Index := 0 to Files.Count -1 do
      begin
        AddAShapeFile(Files[Index], Index + FirstRow);
      end;
    finally
      Files.Free;
    end;
  end;
  NewWidth := rdg2FileNames.ColWidths[0] + rdg2FileNames.ColWidths[1]
    + rdg2FileNames.ColWidths[2] + 16;
  if NewWidth > Width then
  begin
    Width := NewWidth;
  end;
end;

procedure TfrmFileSelection.AddAShapeFile(FileName: string; Row: Integer);
var
  Fields: TStringList;
  DataBaseFile: string;
  FieldIndex: Integer;
  FieldType: TFieldType;
  FieldName: string;
  AnObject: TObject;
  FoundField: boolean;
begin
  rdg2FileNames.Cells[0, Row] := FileName;
  rdg2FileNames.Cells[1, Row] := ChangeFileExt(ExtractFileName(FileName), '');
  Fields := TStringList.Create;
  AnObject := rdg2FileNames.Objects[2,Row];
  AnObject.Free;
  rdg2FileNames.Objects[2,Row] := Fields;
  DataBaseFile := ChangeFileExt(FileName, '.dbf');
  FoundField := False;
  if FileExists(DataBaseFile) then
  begin
    XBase1.FileName := DataBaseFile;
    XBase1.Active := True;
    try
      for FieldIndex := 1 to XBase1.FieldCount do
      begin
        FieldType := XBase1.GetFieldType(FieldIndex);
        if FieldType in [xbfChar, xbfNumber] then
        begin
          FieldName := XBase1.GetFieldName(FieldIndex);
          Fields.Add(FieldName);
          if not FoundField and (FieldType = xbfChar) then
          begin
            FoundField := True;
            rdg2FileNames.Cells[2, Row] := FieldName;
          end;
        end;
      end;
    finally
      XBase1.Active := False;
    end;
  end;
end;

procedure TfrmFileSelection.DeleteARow(Row: Integer);
var
  AnObject: TObject;
begin
  begin
    AnObject := rdg2FileNames.Objects[2, Row];
    AnObject.Free;
    if rdg2FileNames.RowCount > 2 then
    begin
      rdg2FileNames.DeleteRow(Row);
    end
    else
    begin
      rdg2FileNames.Cells[0,Row] := '';
      rdg2FileNames.Cells[1,Row] := '';
      rdg2FileNames.Cells[2,Row] := '';
      rdg2FileNames.Objects[2,Row] := nil;
      rdg2FileNames.Columns[2].PickList.Clear;
    end;

  end;
end;

procedure TfrmFileSelection.btnDeleteClick(Sender: TObject);
begin
  inherited;
  if (rdg2FileNames.Row > 0)
    and (rdg2FileNames.Row < rdg2FileNames.RowCount) then
  begin
    DeleteARow(rdg2FileNames.Row);
  end;
end;

procedure TfrmFileSelection.FormCreate(Sender: TObject);
begin
  inherited;
  SelectedField := False;
  rdg2FileNames.Cells[0,0] := 'Cross Section File';
  rdg2FileNames.Cells[1,0] := 'Cross Section Name';
  rdg2FileNames.Cells[2,0] := 'Field to Identify a Surface';
end;

procedure TfrmFileSelection.rdg2FileNamesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  Index: integer;
  Fields: TStringList;
begin
  inherited;
  if not SelectedField and (ACol = 2) and (ARow > 0) and (rdg2FileNames.RowCount > 2) then
  begin
    if MessageDlg('Do you want to use the same field for '
      + 'the other cross sections?', mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      for Index := 1 to rdg2FileNames.RowCount -1 do
      begin
        if Index = ARow then
        begin
          Continue;
        end;
        Fields := rdg2FileNames.Objects[2, Index] as TStringList;
        if Fields <> nil then
        begin
          if Fields.IndexOf(Value) >= 0 then
          begin
            rdg2FileNames.Cells[2,Index] := Value;
          end;
        end;
      end;
    end;
    SelectedField := True;
  end;
end;

procedure TfrmFileSelection.rdg2FileNamesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  if (ACol = 2) and (ARow > 0) and (rdg2FileNames.Objects[ACol,ARow] <> nil) then
  begin
    rdg2FileNames.Columns[ACol].PickList :=
      rdg2FileNames.Objects[ACol,ARow] as TStringList;
  end;
end;

procedure TfrmFileSelection.ModelComponentName(AStringList: TStringList);
begin
  // do nothing.
end;

procedure TfrmFileSelection.FormDestroy(Sender: TObject);
var
  Index: integer;
begin
  inherited;
  for Index := 1 to rdg2FileNames.RowCount -1 do
  begin
    rdg2FileNames.Objects[2,Index].Free;
  end;
end;

end.
