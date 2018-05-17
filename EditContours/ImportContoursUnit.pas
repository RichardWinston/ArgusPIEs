unit ImportContoursUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, ArgusFormUnit, VersInfo, Spin,
  Grids, WriteContourUnit, Buttons, AnePIE, ASLink;

type
  TDataSource = (dsClipboard, dsFile);
  TDataType = (dtCoordinates, dtValues);

  TfrmImportContours = class(TfrmWriteContour)
    PageControl1: TPageControl;
    tabXY: TTabSheet;
    tabAbout: TTabSheet;
    Image1: TImage;
    lblSupport: TLabel;
    aslMail: TASLink;
    aslRbwinst: TASLink;
    aslMfGUI: TASLink;
    lblArgus: TLabel;
    aslArgusemail: TASLink;
    aslArgusWeb: TASLink;
    lblTel: TLabel;
    lblFileVersionCaption: TLabel;
    lblVersion: TLabel;
    VersionInfo1: TVersionInfo;
    VersionInfo2: TVersionInfo;
    sgContourCoordinates: TStringGrid;
    odRead: TOpenDialog;
    Panel1: TPanel;
    Label1: TLabel;
    seContourCount: TSpinEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnPaste: TButton;
    rgCoordinateDataFormat: TRadioGroup;
    btnFile: TButton;
    BitBtn1: TBitBtn;
    sePointCount: TSpinEdit;
    Label2: TLabel;
    tabParameters: TTabSheet;
    sgParameters: TStringGrid;
    Panel2: TPanel;
    Label3: TLabel;
    seContourCount2: TSpinEdit;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    btnPasteClipParameter: TButton;
    rgParameterDataFormat: TRadioGroup;
    btnFileParameter: TButton;
    BitBtn4: TBitBtn;
    procedure seContourCountChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure btnFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure sePointCountChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject); override;
    procedure sgContourCoordinatesColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure sgContourCoordinatesRowMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure sgParametersRowMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure sgContourCoordinatesMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
  protected
    procedure ReadValuesFromStringList(const AStringList: TStringList;
      const AStringGrid: TStringGrid; const ReadTabValues: boolean); override;
  private
    CoordinateTitles : TStringList;
    ParameterTitles : TStringlist;
    procedure ReadData(const DataSource: TDataSource;
      const DataType : TDataType);
    procedure CopyCoordinateTitles;
    procedure CopyParameterTitles;
    procedure AssignCoordinateRowTitles;
    procedure AssignParameterRowTitles;
    { Private declarations }
  public
    { Public declarations }
  end;

procedure GImportContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;

implementation

{$R *.DFM}

uses Clipbrd, Math, ANECB, OptionsUnit, {EditUnit,} PointContourUnit,
  frmEditUnit;

procedure GImportContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  ImportText : string;
  LayerOptions : TLayerOptions;
  ParameterNames : TStringList;
  frmImportContours: TfrmImportContours;
  InternalLayerHandle : ANE_PTR;
  AString : ANE_STR;
begin
  try
    begin
      Application.CreateForm(TfrmImportContours,frmImportContours);
      Application.CreateForm(TfrmEditNew,frmEditNew);
      try
        frmImportContours.CurrentModelHandle := aneHandle;
        InternalLayerHandle := frmImportContours.GetLayerHandle;
        if InternalLayerHandle <> nil then
        begin
          LayerOptions := TLayerOptions.Create(InternalLayerHandle);
          ParameterNames := TStringList.Create;
          try
            LayerOptions.GetParameterNames(aneHandle,ParameterNames);
            ParameterNames.Insert(0,'N');
            frmImportContours.sgParameters.ColCount := ParameterNames.Count;
            frmImportContours.sgParameters.Rows[0] := ParameterNames;
          finally
            LayerOptions.Free(aneHandle);
            ParameterNames.Free;
          end;

          frmImportContours.CopyParameterTitles;
          frmImportContours.SetColumnWidths(frmImportContours.sgParameters);
          if frmImportContours.ShowModal = mrOK then
          begin
            ImportText := frmImportContours.WriteContours;

            GetMem(AString, Length(ImportText) + 1);
            try
              StrPCopy(AString, ImportText);
              ANE_ImportTextToLayerByHandle(aneHandle, InternalLayerHandle,
                AString);
            finally
              FreeMem(AString);
            end;
          end;
        end;
      finally
        FreeAndNil(frmEditNew);
        FreeAndNil(frmImportContours);
      end;
    end;
   except
     on Exception do
     begin
     end;
   end;
end;


procedure TfrmImportContours.seContourCountChange(Sender: TObject);
var
//  OldRowCount : integer;
  Index : integer;
begin
  if Sender = seContourCount2 then
  begin
    seContourCount.Value := seContourCount2.Value;
  end
  else
  begin
    seContourCount2.Value := seContourCount.Value;
  end;
//  OldRowCount := sgContourCoordinates.RowCount;
  sgContourCoordinates.RowCount := seContourCount.Value + 2;
  sgParameters.RowCount := seContourCount.Value + 2;
  for Index := 2 to sgContourCoordinates.RowCount - 1 do
  begin
    sgContourCoordinates.Cells[0,Index] := IntToStr(Index-1);
    sgParameters.Cells[0,Index] := IntToStr(Index-1);
  end;
end;


procedure TfrmImportContours.btnOKClick(Sender: TObject);
var
  RowIndex, ColIndex : integer;
  Point : TArgusPoint;
  Contour : TContour;
  Value, CellValue : String;
  PointIndex : integer;
  XString, YString : String;
begin
  if not GridValuesOK(sgContourCoordinates, 2, False) then
  begin
    ModalResult := mrNone;
    PageControl1.ActivePage := tabXY;
    sgContourCoordinates.SetFocus;
    Beep;
    MessageDlg('You must enter contour coordinates before closing this '
      + 'dialog box.', mtError, [mbOK], 0);
    Exit;
  end;
  for RowIndex := 2 to sgContourCoordinates.RowCount -1 do
  begin
    Contour := TLocalContour.Create(TLocalPoint);
    if ContourList = nil then
    begin
      ContourList := TList.Create;
    end;
    ContourList.Add(Contour);
    for PointIndex := 0 to (sgContourCoordinates.ColCount - 1) div 2 - 1 do
    begin
      ColIndex := PointIndex * 2 + 1;
      XString := sgContourCoordinates.Cells[ColIndex,RowIndex];
      YString := sgContourCoordinates.Cells[ColIndex+1,RowIndex];
      if (XString <> '') and (YString <> '') then
      begin
        Point := TLocalPoint.Create;
        try
          Point.x := StrToFloat(XString);
          Point.y := StrToFloat(YString);
        except on EConvertError do
          begin
            MessageDlg('On Row ' + IntToStr(RowIndex) +
              ', the X or Y coordinate can not be converted to a number '
              + 'for Point ' + IntToStr(PointIndex) + '.',
              mtError, [mbOK], 0);
            FreeAndNil(Point);
            raise;
          end;
        end;
        Contour.AddPoint(Point);
      end
      else
      begin
        break;
      end;
    end;
    Contour.PointsReady := True;
    Value := '';
    if sgParameters.ColCount > 1 then
    begin
      Value := sgParameters.Cells[1,RowIndex];
      if Value = '' then
      begin
        Value := '0';
      end;
      for ColIndex := 2 to sgParameters.ColCount -1 do
      begin
        CellValue := sgParameters.Cells[ColIndex,RowIndex];
        if CellValue = '' then
        begin
          CellValue := '0';
        end;
        Value := Value + Char(9) + CellValue;
      end;
    end;
    Contour.Value := Value;
    Contour.Heading.Add('## Name:');
    Contour.Heading.Add('## Icon:0');
    Contour.Heading.Add('# Points Count' + Char(9) + 'Value');
    Contour.Heading.Add(IntToStr(Contour.PointCount) + Char(9) + Value);
    Contour.Heading.Add('# X pos' + Char(9) + 'Y pos');
  end;
end;

procedure TfrmImportContours.ReadData(Const DataSource : TDataSource;
  const DataType : TDataType);
var
  AStringList : TStringList;
  AStringGrid : TStringGrid;
  ReadTabValues : boolean;
  Function ValidSource : boolean;
  begin
    result := False;
    case DataSource of
      dsClipboard:
        begin
          result := Clipboard.HasFormat(CF_TEXT);
        end;
      dsFile:
        begin
          result := odRead.Execute;
        end;
    else Assert(False);
    end;
  end;
  Procedure LoadData;
  begin
    case DataSource of
      dsClipboard:
        begin
          AStringList.Text := Clipboard.AsText;
        end;
      dsFile:
        begin
          AStringList.LoadFromFile(odRead.FileName);
        end;
    else Assert(False);
    end;
  end;
begin
  if ValidSource then
  begin
    AStringGrid := sgContourCoordinates;
    ReadTabValues := True;
    case DataType of
      dtCoordinates:
        begin
          AStringGrid := sgContourCoordinates;
          ReadTabValues := (rgCoordinateDataFormat.ItemIndex = 0);
        end;
      dtValues:
        begin
          AStringGrid := sgParameters;
          ReadTabValues := (rgParameterDataFormat.ItemIndex = 0);
        end;
    else Assert(False);
    end;

    AStringList := TStringlist.Create;
    try
      LoadData;
      ReadValuesFromStringList(AStringList, AStringGrid,
        ReadTabValues);
    finally
      AStringList.Free;
    end;
    SetColumnWidths(AStringGrid);
    seContourCount.Value := AStringGrid.RowCount -2;
    seContourCountChange(seContourCount);
    if DataType = dtCoordinates then
    begin
      sePointCount.Value := (AStringGrid.ColCount -1) div 2;
      sePointCountChange(sePointCount);
    end;
  end;
end;

procedure TfrmImportContours.btnPasteClick(Sender: TObject);
var
  DataType : TDataType;
begin
  DataType := dtCoordinates;
  if Sender = btnPaste then
  begin
    DataType := dtCoordinates;
  end
  else if Sender = btnPasteClipParameter then
  begin
    DataType := dtValues;
  end
  else
  begin
    Assert(False);
  end;

  ReadData(dsClipboard, DataType);
  case DataType of
    dtCoordinates :
      begin
        CopyCoordinateTitles;
      end;
    dtValues :
      begin
        CopyParameterTitles;
        if sgParameters.ColCount > 1 then
        begin
          sgParameters.FixedCols := 1;
        end;
      end;
    else Assert(False);
  end;

end;

procedure TfrmImportContours.btnFileClick(Sender: TObject);
var
  DataType : TDataType;
begin
  DataType := dtCoordinates;
  if Sender = btnFile then
  begin
    DataType := dtCoordinates;
  end
  else if Sender = btnFileParameter then
  begin
    DataType := dtValues;
  end
  else
  begin
    Assert(False);
  end;

  ReadData(dsFile, DataType);

  case DataType of
    dtCoordinates :
      begin
        CopyCoordinateTitles;
      end;
    dtValues :
      begin
        CopyParameterTitles;
      end;
    else Assert(False);
  end;
  
end;

procedure TfrmImportContours.CopyCoordinateTitles;
begin
  CoordinateTitles.Assign(sgContourCoordinates.Rows[0]);
end;

procedure TfrmImportContours.CopyParameterTitles;
begin
  ParameterTitles.Assign(sgParameters.Rows[0]);
end;

procedure TfrmImportContours.FormCreate(Sender: TObject);
begin
  inherited;
  VersionInfo1.FileName := DllName;
  lblVersion.Caption := VersionInfo1.FileVersion;
  sgContourCoordinates.Cells[0,0] := 'N';
  sgContourCoordinates.Cells[1,0] := 'X1';
  sgContourCoordinates.Cells[2,0] := 'Y1';
  sgContourCoordinates.Cells[0,2] := '1';
  sgParameters.Cells[0,2] := '1';
  PageControl1.ActivePage := tabXY;
  CoordinateTitles := TStringList.Create;
  ParameterTitles := TStringlist.Create;
  CopyCoordinateTitles;
  CopyParameterTitles;
end;


procedure TfrmImportContours.sePointCountChange(Sender: TObject);
var
//  OldColCount : integer;
  Index : integer;
  N : integer;
  Prefix : string;
begin
  inherited;
//  OldColCount := sgContourCoordinates.ColCount;
  sgContourCoordinates.ColCount := sePointCount.Value * 2 + 1;
  for Index := 1 to sgContourCoordinates.ColCount -1 do
  begin
    if Odd(Index) then
    begin
      N := (Index -1) div 2 + 1;
      Prefix := 'X';
    end
    else
    begin
      N := Index div 2;
      Prefix := 'Y';
    end;
    sgContourCoordinates.Cells[Index,0] := Prefix+ IntToStr(N);
  end;
  CopyCoordinateTitles;
end;

procedure TfrmImportContours.FormDestroy(Sender: TObject);
begin
  inherited;
  CoordinateTitles.Free;
  ParameterTitles.Free;
end;

procedure TfrmImportContours.sgContourCoordinatesColumnMoved(
  Sender: TObject; FromIndex, ToIndex: Integer);
begin
  inherited;
  if Sender = sgContourCoordinates then
  begin
    sgContourCoordinates.Rows[0].Assign(CoordinateTitles);
  end
  else if Sender = sgParameters then
  begin
    sgParameters.Rows[0].Assign(ParameterTitles);
  end
  else
  begin
    Assert(False);
  end;
end;

procedure TfrmImportContours.AssignParameterRowTitles;
var
  Index : integer;
begin
  for Index := 1 to sgParameters.RowCount -1 do
  begin
    sgParameters.Cells[0,Index] := IntToStr(Index);
  end;
end;

procedure TfrmImportContours.AssignCoordinateRowTitles;
var
  Index : integer;
begin
  for Index := 1 to sgContourCoordinates.RowCount -1 do
  begin
    sgContourCoordinates.Cells[0,Index] := IntToStr(Index);
  end;
end;

procedure TfrmImportContours.sgContourCoordinatesRowMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
var
  AStringList: TStringList;
//  LowerIndex, UpperIndex : integer;
  Row : integer;
begin
  inherited;
  AssignCoordinateRowTitles;
  AStringList := TStringList.Create;
  try
    AStringList.Assign(sgParameters.Rows[FromIndex]);
    if ToIndex > FromIndex then
    begin
      for Row := FromIndex + 1 to ToIndex do
      begin
        sgParameters.Rows[Row-1].Assign(sgParameters.Rows[Row]);
      end;
    end
    else
    begin
      for Row := FromIndex  downto ToIndex + 1 do
      begin
        sgParameters.Rows[Row].Assign(sgParameters.Rows[Row-1]);
      end;
    end;
    sgParameters.Rows[ToIndex].Assign(AStringList);
  finally
    AStringList.Free;
  end;
  AssignParameterRowTitles;
end;

procedure TfrmImportContours.sgParametersRowMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
var
  AStringList: TStringList;
  Row : integer;
begin
  inherited;
  AssignParameterRowTitles;
  AStringList := TStringList.Create;
  try
    AStringList.Assign(sgContourCoordinates.Rows[FromIndex]);
    if ToIndex > FromIndex then
    begin
      for Row := FromIndex + 1 to ToIndex do
      begin
        sgContourCoordinates.Rows[Row-1].Assign(sgContourCoordinates.Rows[Row]);
      end;
    end
    else
    begin
      for Row := FromIndex  downto ToIndex + 1 do
      begin
        sgContourCoordinates.Rows[Row].Assign(sgContourCoordinates.Rows[Row-1]);
      end;
    end;
    sgContourCoordinates.Rows[ToIndex].Assign(AStringList);
  finally
    AStringList.Free;
  end;
  AssignCoordinateRowTitles;
end;

procedure TfrmImportContours.ReadValuesFromStringList(const AStringList : TStringList;
  const AStringGrid : TStringGrid; const ReadTabValues : boolean);
var
  Index : integer;
  AContour : TContour;
  PointIndex, HeadingIndex, ValueIndex : integer;
  Value : string;
  ValueFound :boolean;
  ValueStrings : TStringList;
  AValue : string;
  APoint : TArgusPoint;
  RowIndex : integer;
  ReadArgusContoursTest : boolean;
  AString : string;
begin
  ReadArgusContoursTest := False;
  if AStringGrid = sgContourCoordinates then
  begin
    ReadArgusContoursTest := rgCoordinateDataFormat.ItemIndex = 2
  end
  else if AStringGrid = sgParameters then
  begin
    ReadArgusContoursTest := rgParameterDataFormat.ItemIndex = 2
  end
  else
  begin
    Assert(False);
  end;
  if not ReadArgusContoursTest then
  begin
    for Index := 0 to min(AStringList.Count -1,10) do
    begin
      AString := AStringList[Index];
      if (Pos('# Points Count',AString) = 1)
        or (Pos('# X pos',AString) = 1) then
      begin
        ReadArgusContoursTest := True;
        Break;
      end;
    end;
  end;
  if ReadArgusContoursTest then
  begin
    ValueStrings := TStringList.Create;
    try
      ReadArgusContours(AStringList.Text, TLocalContour, TLocalPoint);
      RowIndex := 1;
      for Index := 0 to ContourList.Count -1 do
      begin
        AContour := ContourList[Index];
        ValueFound := False;
        for HeadingIndex := 0 to AContour.Heading.Count -1 do
        begin
          Value := AContour.Heading[HeadingIndex];
          if Pos('# Points',Value) > 0 then
          begin
            if HeadingIndex + 1 < AContour.Heading.Count -1 then
            begin
              Value := AContour.Heading[HeadingIndex + 1];
              ValueFound := True;
            end;
            break;
          end;
        end;
        ValueStrings.Clear;
        if ValueFound then
        begin
          If (Pos(Char(9),Value) > 0) then
          begin
            ReadTabValuesString(Value, AValue);
            while (Pos(Char(9),Value) > 0) do
            begin
              ReadTabValuesString(Value, AValue);
              ValueStrings.Add(AValue);
            end;
            ValueStrings.Add(Value);
          end;
        end;
        if ValueStrings.Count + 1 > sgParameters.ColCount then
        begin
          sgParameters.ColCount := ValueStrings.Count + 1;
          AssignParameterRowTitles;
        end;
        RowIndex := RowIndex + 1;
        if (RowIndex+1 > sgContourCoordinates.RowCount) then
        begin
          sgContourCoordinates.RowCount := RowIndex+1;
          sgParameters.RowCount := RowIndex+1;
        end;
        for ValueIndex := 0 to ValueStrings.Count -1 do
        begin
          sgParameters.Cells[ValueIndex+1,RowIndex] :=
            ValueStrings[ValueIndex];
        end;
        if AContour.PointCount*2+1 > sgContourCoordinates.ColCount then
        begin
          sgContourCoordinates.ColCount := AContour.PointCount*2+1;
        end;
        sgContourCoordinates.Cells[0,RowIndex] := IntToStr(RowIndex);
        sgParameters.Cells[0,RowIndex] := IntToStr(RowIndex);
        for PointIndex := 0 to AContour.PointCount - 1 do
        begin
          APoint := AContour.PointValues[PointIndex];
          sgContourCoordinates.Cells[PointIndex*2+1,RowIndex] := FloatToStr(APoint.X);
          sgContourCoordinates.Cells[PointIndex*2+2,RowIndex] := FloatToStr(APoint.Y);
        end;
      end;
    finally
      ValueStrings.Free;
      KillContourList;
    end;
  end
  else
  begin
    inherited;
  end;
end;

procedure TfrmImportContours.sgContourCoordinatesMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow : integer;
  StringGrid : TStringGrid;
begin
  inherited;
  if Sender is TStringGrid then
  begin
    StringGrid := TStringGrid(Sender);
    StringGrid.MouseToCell(X, Y, ACol, ARow);
    if (ACol >-1) and (ARow > -1)
      and ((ACol < StringGrid.FixedCols)
      or (ARow < StringGrid.FixedRows)) then
    begin
      StringGrid.Cursor := crHandPoint;
    end
    else
    begin
      StringGrid.Cursor := crDefault;
    end;
  end;
end;

end.
