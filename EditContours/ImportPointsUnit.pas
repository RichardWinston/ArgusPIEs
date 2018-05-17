unit ImportPointsUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, ASLink, StdCtrls, ArgusFormUnit, VersInfo, Spin,
  Grids, WriteContourUnit, Buttons, AnePIE { , EditUnit};

type
  TDataSource = (dsClipboard, dsFile);

  TfrmImportPoints = class(TfrmWriteContour)
    PageControl1: TPageControl;
    tabPointData: TTabSheet;
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
    sgContours: TStringGrid;
    odRead: TOpenDialog;
    Panel1: TPanel;
    Label1: TLabel;
    seContourCount: TSpinEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnPaste: TButton;
    rgDataFormat: TRadioGroup;
    btnFile: TButton;
    BitBtn1: TBitBtn;
    procedure seContourCountChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure btnFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure sgContoursColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure sgContoursRowMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure sgContoursMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    ContourTitles : TStringList;
    procedure ReadData(const DataSource: TDataSource);
    procedure StoreContourTitles;
    procedure AssignRowTitles;
  protected
    { Private declarations }
    procedure ReadValuesFromStringList(const AStringList: TStringList;
      const AStringGrid: TStringGrid; const ReadTabValues: boolean); override;
  public
    { Public declarations }
  end;

procedure GImportPointsPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;

implementation

{$R *.DFM}

uses Clipbrd, math, ANECB, OptionsUnit, PointContourUnit, frmEditUnit;

procedure GImportPointsPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  ImportText : string;
  LayerOptions : TLayerOptions;
  ParameterNames : TStringList;
  frmImportPoints: TfrmImportPoints;
  InternalLayerHandle : ANE_PTR;
  AString : ANE_STR;
  Layer : TLayerOptions;
begin
  try
    begin
      Application.CreateForm(TfrmImportPoints,frmImportPoints);
      Application.CreateForm(TfrmEditNew,frmEditNew);
      try
        frmImportPoints.CurrentModelHandle := aneHandle;
        InternalLayerHandle := frmImportPoints.GetLayerHandle;
        if InternalLayerHandle <> nil then
        begin
          LayerOptions := TLayerOptions.Create(InternalLayerHandle);
          ParameterNames := TStringList.Create;
          try
            LayerOptions.GetParameterNames(aneHandle,ParameterNames);
            ParameterNames.Insert(0,'Y');
            ParameterNames.Insert(0,'X');
            ParameterNames.Insert(0,'N');
            frmImportPoints.sgContours.ColCount := ParameterNames.Count;
            frmImportPoints.sgContours.Rows[0] := ParameterNames;
          finally
            LayerOptions.Free(aneHandle);
            ParameterNames.Free;
          end;
          frmImportPoints.StoreContourTitles;
          frmImportPoints.SetColumnWidths(frmImportPoints.sgContours);
          if frmImportPoints.ShowModal = mrOK then
          begin

            Layer := TLayerOptions.Create(InternalLayerHandle);
            try
              if (Layer.NumObjects(aneHandle,pieContourObject) > 0)
                and (MessageDlg('The layer to which you are importing the data '
                  + 'points already has some contours.  Do you want to erase them?',
                  mtInformation, [mbYes, mbNo], 0) = mrYes) then
              begin
                Layer.ClearLayer(aneHandle, False);
              end;
            finally
              Layer.Free(aneHandle);
            end;

            ImportText := frmImportPoints.WriteContours;

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
        FreeAndNil(frmImportPoints);
      end;
    end;
   except
     on Exception do
     begin
     end;
   end;
end;


procedure TfrmImportPoints.seContourCountChange(Sender: TObject);
var
  OldRowCount : integer;
  Index : integer;
begin
  OldRowCount := sgContours.RowCount;
  sgContours.RowCount := seContourCount.Value + 2;
  for Index := OldRowCount to sgContours.RowCount - 1 do
  begin
    sgContours.Cells[0,Index] := IntToStr(Index-1);
  end;
end;

procedure TfrmImportPoints.btnOKClick(Sender: TObject);
var
  RowIndex, ColIndex : integer;
  Point : TArgusPoint;
  Contour : TContour;
  Value, CellValue : String;
begin
  if not GridValuesOK(sgContours, 2, False) then
  begin
    ModalResult := mrNone;
    sgContours.SetFocus;
    Beep;
    MessageDlg('You must enter contour coordinates before closing this '
      + 'dialog box.', mtError, [mbOK], 0);
    Exit;
  end;
  for RowIndex := 2 to sgContours.RowCount -1 do
  begin
    Point := TLocalPoint.Create;
    try
      Point.x := StrToFloat(sgContours.Cells[1,RowIndex]);
      Point.y := StrToFloat(sgContours.Cells[2,RowIndex]);
    except on EConvertError do
      begin
        MessageDlg('On Row ' + IntToStr(RowIndex) +
          ', the X or Y coordinate can not be converted to a number.',
          mtError, [mbOK], 0);
        FreeAndNil(Point);
        raise;
      end;
    end;
    Contour := TLocalContour.Create(TLocalPoint);
    if ContourList = nil then
    begin
      ContourList := TList.Create;
    end;
    ContourList.Add(Contour);
    Contour.AddPoint(Point);
    Contour.PointsReady := True;

    Value := '';
    if sgContours.ColCount > 3 then
    begin
      Value := sgContours.Cells[3,RowIndex];
      if Value = '' then
      begin
        Value := '0';
      end;
      for ColIndex := 4 to sgContours.ColCount -1 do
      begin
        CellValue := sgContours.Cells[ColIndex,RowIndex];
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
    Contour.Heading.Add('1' + Char(9) + Value);
    Contour.Heading.Add('# X pos' + Char(9) + 'Y pos');
  end;
end;

procedure TfrmImportPoints.ReadData(Const DataSource : TDataSource);
var
  AStringList : TStringList;
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
    AStringList := TStringlist.Create;
    try
      LoadData;
      ReadValuesFromStringList(AStringList, sgContours,
        (rgDataFormat.ItemIndex = 0));
    finally
      AStringList.Free;
    end;
    SetColumnWidths(sgContours);
    seContourCount.Value := sgContours.RowCount -2;
  end;
end;

procedure TfrmImportPoints.btnPasteClick(Sender: TObject);
begin
  ReadData(dsClipboard);
  StoreContourTitles;
end;

procedure TfrmImportPoints.btnFileClick(Sender: TObject);
begin
  ReadData(dsFile);
  StoreContourTitles;
end;

procedure TfrmImportPoints.StoreContourTitles;
begin
  ContourTitles.Assign(sgContours.Rows[0]);
end;

procedure TfrmImportPoints.FormCreate(Sender: TObject);
begin
  inherited;
  VersionInfo1.FileName := DllName;
  lblVersion.Caption := VersionInfo1.FileVersion;
  sgContours.Cells[0,2] := '1';
  PageControl1.ActivePage := tabPointData;
  ContourTitles := TStringList.Create;
  StoreContourTitles;
end;


procedure TfrmImportPoints.FormDestroy(Sender: TObject);
begin
  inherited;
  ContourTitles.Free;
end;

procedure TfrmImportPoints.sgContoursColumnMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
begin
  inherited;
  sgContours.Rows[0].Assign(ContourTitles);
end;

procedure TfrmImportPoints.AssignRowTitles;
var
  Index : integer;
begin
  for Index := 1 to sgContours.RowCount -1 do
  begin
    sgContours.Cells[0,Index] := IntToStr(Index);
  end;
end;


procedure TfrmImportPoints.sgContoursRowMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
  inherited;
  AssignRowTitles;
end;

procedure TfrmImportPoints.ReadValuesFromStringList(const AStringList : TStringList;
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
  ReadArgusContoursTest : Boolean;
  AString : string;
begin
  ReadArgusContoursTest := rgDataFormat.ItemIndex = 2;
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
        if ValueStrings.Count + 3 > sgContours.ColCount then
        begin
          sgContours.ColCount := ValueStrings.Count + 3;
          AssignRowTitles;
        end;
        AContour.MakeOpenContour;
        for PointIndex := 0 to AContour.PointCount - 1 do
        begin
          APoint := AContour.PointValues[PointIndex];
          RowIndex := RowIndex + 1;
          if (RowIndex+1 > sgContours.RowCount) then
          begin
            sgContours.RowCount := RowIndex+1;
          end;
          sgContours.Cells[0,RowIndex] := IntToStr(RowIndex-1);
          sgContours.Cells[1,RowIndex] := FloatToStr(APoint.X);
          sgContours.Cells[2,RowIndex] := FloatToStr(APoint.Y);
          for ValueIndex := 0 to ValueStrings.Count -1 do
          begin
            sgContours.Cells[ValueIndex+3,RowIndex] :=
              ValueStrings[ValueIndex];
          end;
        end;
      end;
    finally
      ValueStrings.Free;
      KillContourList;
      seContourCount.Value := sgContours.RowCount -2;
    end;
  end
  else
  begin
    inherited;
  end;
end;

procedure TfrmImportPoints.sgContoursMouseMove(Sender: TObject;
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
