unit ImportPointsUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, ASLink, StdCtrls, ArgusFormUnit, Spin,
  Grids, WriteContourUnit, Buttons, AnePIE, siComboBox { , EditUnit};

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
    sgContours: TStringGrid;
    odRead: TOpenDialog;
    Panel1: TPanel;
    Label1: TLabel;
    seContourCount: TSpinEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    rgDataFormat: TRadioGroup;
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    btnPaste: TBitBtn;
    btnFile: TBitBtn;
    rgCoordinates: TRadioGroup;
    lblGrid: TLabel;
    comboGrid: TsiComboBox;
    cbPasteinSelectedRow: TCheckBox;
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
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rgCoordinatesClick(Sender: TObject);
    procedure rgDataFormatClick(Sender: TObject);
  private
    ContourTitles: TStringList;
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

procedure GImportPointsPIE(aneHandle: ANE_PTR; const fileName: ANE_STR;
  layerHandle: ANE_PTR); cdecl;

implementation

{$R *.DFM}

uses Clipbrd, math, ANECB, OptionsUnit, PointContourUnit, frmEditUnit,
  QuadtreeClass, contnrs, UtilityFunctions;

procedure GImportPointsPIE(aneHandle: ANE_PTR; const fileName: ANE_STR;
  layerHandle: ANE_PTR); cdecl;
var
  ImportText: string;
  LayerOptions: TLayerOptions;
  ParameterNames: TStringList;
  frmImportPoints: TfrmImportPoints;
  InternalLayerHandle: ANE_PTR;
  AString: ANE_STR;
  Layer: TLayerOptions;
  ParamCount: integer;
  ParameterIndex, ContourIndex: ANE_INT32;
  ParameterTypes: array of TPIENumberType;
  Parameter: TParameterOptions;
  CanOverride: array of Boolean;
  StartIndex: integer;
  Contour: TContourObjectOptions;
  CellString: string;
  BoolValue: boolean;
  IntValue: integer;
  FloatValue: double;
  QuadTree: TRbwQuadTree;
  ContourList: TObjectList;
  Data: TPointerArray;
  WarningShown: boolean;
  Project: TProjectOptions;
  GridLayers: TStringList;
  AGridLayer: TLayerOptions;
  GridIndex: integer;
  GridLayer: TLayerOptions;
  Col, Row: integer;
  NCOL, NROW: ANE_INT32;
  RowsReversed, ColsReversed: boolean;
  BlockIndex: integer;
  Block: TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  Index: integer;
begin
  try
    begin
      Application.CreateForm(TfrmImportPoints, frmImportPoints);
      Application.CreateForm(TfrmEditNew, frmEditNew);
      try
        frmImportPoints.CurrentModelHandle := aneHandle;
        InternalLayerHandle := frmImportPoints.GetLayerHandle;
        if InternalLayerHandle <> nil then
        begin
          LayerOptions := TLayerOptions.Create(InternalLayerHandle);
          ParameterNames := TStringList.Create;
          try
            LayerOptions.GetParameterNames(aneHandle, ParameterNames);
            ParamCount := ParameterNames.Count;
            ParameterNames.Insert(0, 'Y');
            ParameterNames.Insert(0, 'X');
            ParameterNames.Insert(0, 'N');
            frmImportPoints.sgContours.ColCount := ParameterNames.Count;
            frmImportPoints.sgContours.Rows[0] := ParameterNames;
          finally
            LayerOptions.Free(aneHandle);
            ParameterNames.Free;
          end;
          frmImportPoints.StoreContourTitles;
          frmImportPoints.SetColumnWidths(frmImportPoints.sgContours);

          // get a list of the grid layers that have blocks.
          Project := TProjectOptions.Create;
          try
            GridLayers := TStringList.Create;
            try
              Project.LayerNames(aneHandle, [pieGridLayer], GridLayers);
              for GridIndex := GridLayers.Count -1 downto 0 do
              begin
                AGridLayer := TLayerOptions.CreateWithName(GridLayers[GridIndex], aneHandle);
                try
                  if AGridLayer.NumObjects(aneHandle, pieBlockObject) <= 0 then
                  begin
                    GridLayers.Delete(GridIndex);
                  end;
                finally
                  AGridLayer.Free(aneHandle);
                end;
              end;
              frmImportPoints.comboGrid.Items := GridLayers;
              if GridLayers.Count > 0 then
              begin
                frmImportPoints.comboGrid.ItemIndex := 0;
              end
              else
              begin
                frmImportPoints.rgCoordinates.Visible := False;
                frmImportPoints.comboGrid.Visible := False;
                frmImportPoints.lblGrid.Visible := False;
              end;
            finally
              GridLayers.Free;
            end;
          finally
            Project.Free;
          end;

          if frmImportPoints.ShowModal = mrOK then
          begin
            GridLayer := nil;
            try
              if frmImportPoints.rgCoordinates.ItemIndex = 1 then
              begin
                if frmImportPoints.comboGrid.Text = '' then
                begin
                  raise Exception.Create('No grid layer has been selected.');
                end;

                GridLayer := TLayerOptions.CreateWithName(frmImportPoints.comboGrid.Text,
                  aneHandle);
                GetNumRowsCols(aneHandle, GridLayer.LayerHandle, NROW, NCOL);
                RowsReversed := GridLayer.GridReverseYDirection[aneHandle];
                ColsReversed := GridLayer.GridReverseXDirection[aneHandle];
              end
              else
              begin
                GridLayer := nil;
                NCOL := 0;
                NROW := 0;
                RowsReversed := False;
                ColsReversed := False;
              end;

            Layer := TLayerOptions.Create(InternalLayerHandle);
            try
              if (Layer.NumObjects(aneHandle, pieContourObject) > 0)
                and (MessageDlg('The layer to which you are importing the data '
                + 'points already has some contours.  Do you want to erase them?',
                mtInformation, [mbYes, mbNo], 0) = mrYes) then
              begin
                Layer.ClearLayer(aneHandle, False);
              end;

              StartIndex := Layer.NumObjects(aneHandle, pieContourObject);
              ImportText := frmImportPoints.WriteContours;

              GetMem(AString, Length(ImportText) + 1);
              try
                StrPCopy(AString, ImportText);
                ANE_ImportTextToLayerByHandle(aneHandle, InternalLayerHandle,
                  AString);
              finally
                FreeMem(AString);
              end;
              // Import parameter values.
              SetLength(ParameterTypes, ParamCount);
              SetLength(CanOverride, ParamCount);
              for ParameterIndex := 0 to ParamCount -1 do
              begin
                Parameter := TParameterOptions.Create(InternalLayerHandle,
                  ParameterIndex);
                try
                  ParameterTypes[ParameterIndex]
                    := Parameter.NumberType[aneHandle];
                  CanOverride[ParameterIndex] :=
                    not (plDont_Override in Parameter.LockSet[aneHandle]);
                finally
                  Parameter.Free;
                end;
              end;

              WarningShown := False;
              QuadTree := TRbwQuadTree.Create(nil);
              ContourList := TObjectList.Create;
              try
                for ContourIndex := 0 to Layer.NumObjects(aneHandle, pieContourObject) -1 do
                begin
                  Contour := TContourObjectOptions.Create(aneHandle,
                    InternalLayerHandle, ContourIndex);
                  ContourList.Add(Contour);
                  Contour.GetNthNodeLocation(aneHandle, X, Y, 0);
                  QuadTree.AddPoint(X, Y, Contour);
                end;

                for ContourIndex := 2 to frmImportPoints.sgContours.RowCount -1 do
                begin

                  if frmImportPoints.rgCoordinates.ItemIndex = 1 then
                  begin
                    Col := StrToInt(frmImportPoints.sgContours.Cells[1, ContourIndex]);
                    Row := StrToInt(frmImportPoints.sgContours.Cells[2, ContourIndex]);
                    BlockIndex := GetBlockIndex(Row, Col, NROW, NCOL,
                      RowsReversed, ColsReversed);
                    Block := TBlockObjectOptions.Create(aneHandle,
                      GridLayer.LayerHandle, BlockIndex);
                    try
                      Block.GetCenter(aneHandle, X, Y);
                    finally
                      Block.Free;
                    end;
                  end
                  else
                  begin
                    X := StrToFloat(frmImportPoints.sgContours.Cells[1,ContourIndex]);
                    Y := StrToFloat(frmImportPoints.sgContours.Cells[2,ContourIndex]);
                  end;

                  QuadTree.FindClosestPointsData(X, Y, Data);

                  Contour := nil;
                  if Length(Data) >= 1 then
                  begin
                    Contour := Data[0];
                    if Length(Data) > 1 then
                    begin
                      if not WarningShown then
                      begin
                        Beep;
                        if MessageDlg('Warning: Because some contours have '
                          + 'identical first coordinates, the data for '
                          + 'those contours may not be imported '
                          + 'correctly.  Do you wish to continue?',
                          mtWarning, [mbYes, mbNo], 0) = mrNo then
                        begin
                          Exit;
                        end;
                      end;
                      WarningShown := True;
                    end;
                  end;

                  if Contour <> nil then
                  begin
                    for ParameterIndex := 0 to ParamCount -1 do
                    begin
                      CellString := trim(frmImportPoints.sgContours.Cells[ParameterIndex + 3,
                        ContourIndex]);
                      if CanOverride[ParameterIndex] and
                        (CellString <> '') then
                      begin
                        case ParameterTypes[ParameterIndex] of
                          pnBoolean:
                            begin
                              if LowerCase(CellString) = 'true' then
                              begin
                                BoolValue := True;
                              end
                              else if LowerCase(CellString) = 'false' then
                              begin
                                BoolValue := False
                              end
                              else
                              begin
                                try
                                  BoolValue := StrToFloat(CellString) <> 0;
                                except on EConvertError do
                                  begin
                                    BoolValue := False;
                                  end;
                                end;
                              end;
                              Contour.SetBoolParameter(aneHandle,
                                ParameterIndex, BoolValue);
                            end;
                          pnInteger:
                            begin
                              try
                                IntValue := StrToInt(CellString);
                              except on EConvertError do
                                begin
                                  IntValue := 0;
                                end;
                              end;
                              Contour.SetIntegerParameter(aneHandle,
                                ParameterIndex, IntValue);
                            end;
                          pnFloat:
                            begin
                              try
                                FloatValue := StrToFloat(CellString);
                              except on EConvertError do
                                begin
                                  FloatValue := 0;
                                end;
                              end;
                              Contour.SetFloatParameter(aneHandle,
                                ParameterIndex, FloatValue);
                            end;
                          pnString:
                            begin
                              Contour.SetStringParameter(aneHandle,
                                ParameterIndex, CellString);
                            end;
                          pnNA:
                            begin
                            end;
                        else Assert(False)
                        end;
                      end;
                    end;
                  end;
                end;
              finally
                QuadTree.Free;
                ContourList.Free;
              end;
            finally
              Layer.Free(aneHandle);
            end;
            finally
              GridLayer.Free(aneHandle);
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
  OldRowCount: integer;
  Index: integer;
begin
  OldRowCount := sgContours.RowCount;
  sgContours.RowCount := seContourCount.Value + 2;
  for Index := OldRowCount to sgContours.RowCount - 1 do
  begin
    sgContours.Cells[0, Index] := IntToStr(Index - 1);
  end;
end;

procedure TfrmImportPoints.btnOKClick(Sender: TObject);
var
  RowIndex: integer;
  Point: TArgusPoint;
  Contour: TContour;
  Value: string;
  ProjectOptions: TProjectOptions;
  Separator: char;
  GridLayer: TLayerOptions;
  Col, Row: integer;
  NCOL, NROW: ANE_INT32;
  RowsReversed, ColsReversed: boolean;
  BlockIndex: integer;
  Block: TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
  Index: integer;
begin
  try
    GridLayer := nil;
    try
      if rgCoordinates.ItemIndex = 1 then
      begin
        if comboGrid.Text = '' then
        begin
          raise Exception.Create('No grid layer has been selected.');
        end;

        GridLayer := TLayerOptions.CreateWithName(comboGrid.Text,
          CurrentModelHandle);
        GetNumRowsCols(CurrentModelHandle, GridLayer.LayerHandle, NROW, NCOL);
        RowsReversed := GridLayer.GridReverseYDirection[CurrentModelHandle];
        ColsReversed := GridLayer.GridReverseXDirection[CurrentModelHandle];
      end
      else
      begin
        GridLayer := nil;
        NCOL := 0;
        NROW := 0;
        RowsReversed := False;
        ColsReversed := False;
      end;

      if not GridValuesOK(sgContours, 2, False) then
      begin
        ModalResult := mrNone;
        sgContours.SetFocus;
        Beep;
        MessageDlg('You must enter contour coordinates before closing this '
          + 'dialog box.', mtError, [mbOK], 0);
        Exit;
      end;
      ProjectOptions := TProjectOptions.Create;
      try
        Separator := ProjectOptions.CopyDelimiter[CurrentModelHandle]
      finally
        ProjectOptions.Free;
      end;
      for RowIndex := 2 to sgContours.RowCount - 1 do
      begin
        Point := TLocalPoint.Create;
        try
          if rgCoordinates.ItemIndex = 1 then
          begin
            Col := StrToInt(sgContours.Cells[1, RowIndex]);
            Row := StrToInt(sgContours.Cells[2, RowIndex]);

            BlockIndex := GetBlockIndex(Row, Col, NROW, NCOL,
              RowsReversed, ColsReversed);
            Block := TBlockObjectOptions.Create(CurrentModelHandle,
              GridLayer.LayerHandle, BlockIndex);
            try
              Block.GetCenter(CurrentModelHandle, X, Y);
              Point.x := X;
              Point.y := Y;
            finally
              Block.Free;
            end;
          end
          else
          begin
            Point.x := StrToFloat(sgContours.Cells[1, RowIndex]);
            Point.y := StrToFloat(sgContours.Cells[2, RowIndex]);
          end;
        except
          on EConvertError do
          begin
            MessageDlg('On Row ' + IntToStr(RowIndex) +
              ', the X or Y coordinate can not be converted to a number.',
              mtError, [mbOK], 0);
            raise;
          end;
          On Exception do
          begin
            FreeAndNil(Point);
            raise;
          end
        end;
        Contour := TLocalContour.Create(TLocalPoint, Separator);
        if ContourList = nil then
        begin
          ContourList := TList.Create;
        end;
        ContourList.Add(Contour);
        Contour.AddPoint(Point);
        Contour.PointsReady := True;

        Value := '';
        {if sgContours.ColCount > 3 then
        begin
          Value := sgContours.Cells[3, RowIndex];
          if Value = '' then
          begin
            Value := '0';
          end;
          for ColIndex := 4 to sgContours.ColCount - 1 do
          begin
            CellValue := sgContours.Cells[ColIndex, RowIndex];
            if CellValue = '' then
            begin
              CellValue := '0';
            end;
            for CharIndex := 1 to Length(CellValue) do
            begin
              if CellValue[CharIndex] = ' ' then
              begin
                CellValue[CharIndex] := '_';
              end;
            end;

            Value := Value + Char(9) + CellValue;
          end;
        end;  }
        Contour.Value := Value;
        Contour.Heading.Add('## Name:');
        Contour.Heading.Add('## Icon:0');
        Contour.Heading.Add('# Points Count' + Char(9) + 'Value');
        Contour.Heading.Add('1' + Char(9) + Value);
        Contour.Heading.Add('# X pos' + Char(9) + 'Y pos');
      end;
    finally
      GridLayer.Free(CurrentModelHandle);
    end;
    ModalResult := mrOK;
  except
    for Index := 0 to ContourList.Count -1 do
    begin
      TLocalContour(ContourList[Index]).Free;
    end;
    ContourList.Clear;
    raise;
  end;
end;

procedure TfrmImportPoints.ReadData(const DataSource: TDataSource);
var
  AStringList: TStringList;
  function ValidSource: boolean;
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
    else
      Assert(False);
    end;
  end;
  procedure LoadData;
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
    else
      Assert(False);
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
    seContourCount.Value := sgContours.RowCount - 2;
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
  lblVersion.Caption := FileVersion(DllName);
  sgContours.Cells[0, 2] := '1';
  PageControl1.ActivePage := tabPointData;
  ContourTitles := TStringList.Create;
  StoreContourTitles;
  Memo1.Lines.Add('Winston, R.B., 2001, Programs for Simplifying the '
    + 'Analysis of Geographic Information in U.S. Geological Survey '
    + 'Ground-Water Models: U.S. Geological Survey Open-File Report 01-392, '
    + '67 p.');
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
  Index: integer;
begin
  for Index := 1 to sgContours.RowCount - 1 do
  begin
    sgContours.Cells[0, Index] := IntToStr(Index);
  end;
end;

procedure TfrmImportPoints.sgContoursRowMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
  inherited;
  AssignRowTitles;
end;

procedure TfrmImportPoints.ReadValuesFromStringList(const AStringList:
  TStringList;
  const AStringGrid: TStringGrid; const ReadTabValues: boolean);
var
  Index: integer;
  AContour: TContour;
  PointIndex, HeadingIndex, ValueIndex: integer;
  Value: string;
  ValueFound: boolean;
  ValueStrings: TStringList;
  AValue: string;
  APoint: TArgusPoint;
  RowIndex: integer;
  ReadArgusContoursTest: Boolean;
  AString: string;
  ProjectOptions: TProjectOptions;
  Separator: char;
begin
  ReadArgusContoursTest := rgDataFormat.ItemIndex = 2;
  if not ReadArgusContoursTest then
  begin
    for Index := 0 to min(AStringList.Count - 1, 10) do
    begin
      AString := AStringList[Index];
      if (Pos('# Points Count', AString) = 1)
        or (Pos('# X pos', AString) = 1) then
      begin
        ReadArgusContoursTest := True;
        Break;
      end;
    end;
  end;
  if ReadArgusContoursTest then
  begin
    ProjectOptions := TProjectOptions.Create;
    try
      Separator := ProjectOptions.CopyDelimiter[CurrentModelHandle]
    finally
      ProjectOptions.Free;
    end;

    ValueStrings := TStringList.Create;
    try
      ReadArgusContours(AStringList.Text, TLocalContour, TLocalPoint,
        Separator);
      RowIndex := 1;
      for Index := 0 to ContourList.Count - 1 do
      begin
        AContour := ContourList[Index];
        ValueFound := False;
        for HeadingIndex := 0 to AContour.Heading.Count - 1 do
        begin
          Value := AContour.Heading[HeadingIndex];
          if Pos('# Points', Value) > 0 then
          begin
            if HeadingIndex + 1 < AContour.Heading.Count - 1 then
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
          if (Pos(Separator, Value) > 0) then
          begin
            ReadTabValuesString(Value, AValue, Separator);
            while (Pos(Separator, Value) > 0) do
            begin
              ReadTabValuesString(Value, AValue, Separator);
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
          if (RowIndex + 1 > sgContours.RowCount) then
          begin
            sgContours.RowCount := RowIndex + 1;
          end;
          sgContours.Cells[0, RowIndex] := IntToStr(RowIndex - 1);
          sgContours.Cells[1, RowIndex] := FloatToStr(APoint.X);
          sgContours.Cells[2, RowIndex] := FloatToStr(APoint.Y);
          for ValueIndex := 0 to ValueStrings.Count - 1 do
          begin
            sgContours.Cells[ValueIndex + 3, RowIndex] :=
              ValueStrings[ValueIndex];
          end;
        end;
      end;
    finally
      ValueStrings.Free;
      KillContourList;
      seContourCount.Value := sgContours.RowCount - 2;
    end;
  end
  else
  begin
    if cbPasteinSelectedRow.Checked then
    begin
      ReadValuesFromStringListIntoRow(AStringList, AStringGrid, ReadTabValues);
    end
    else
    begin
      inherited;
    end;
  end;
end;

procedure TfrmImportPoints.sgContoursMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: integer;
  StringGrid: TStringGrid;
begin
  inherited;
  if Sender is TStringGrid then
  begin
    StringGrid := TStringGrid(Sender);
    StringGrid.MouseToCell(X, Y, ACol, ARow);
    if (ACol > -1) and (ARow > -1)
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

procedure TfrmImportPoints.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Delimiters: TSysCharSet;
  Grid: TStringGrid;
  ClipBoardText: TStringList;
begin
  inherited;
  if (ActiveControl = sgContours) then
  begin
    if (ssCtrl in Shift) and ((Key = Ord('V')) or (Key = Ord('v')))
      and Clipboard.HasFormat(CF_TEXT) then
    begin
      Grid := ActiveControl as TStringGrid;

      case rgDataFormat.ItemIndex of
        0:
          begin
            Delimiters := [#9];
          end;
        1:
          begin
            Delimiters := [#9, ',', ' '];
          end;
        2:
          begin
            Exit;
          end;
      else
        Assert(False);
      end;

      Screen.Cursor := crHourGlass;
      ClipBoardText := TStringList.Create;
      try
        ClipBoardText.Text := Clipboard.AsText;
        PasteInStringGrid(ClipBoardText, Grid, Delimiters, True,
          cbPasteinSelectedRow.Checked);

        seContourCount.Value := Grid.RowCount - 2;
      finally
        ClipBoardText.Free;
        Screen.Cursor := crDefault;
      end;
    end;
  end;
end;

procedure TfrmImportPoints.rgCoordinatesClick(Sender: TObject);
begin
  inherited;
  case rgCoordinates.ItemIndex of
    0:
      begin
        sgContours.Cells[1,0] := 'X';
        sgContours.Cells[2,0] := 'Y';
        comboGrid.Enabled := False;
        lblGrid.Enabled := False;
      end;
    1:
      begin
        sgContours.Cells[1,0] := 'Col';
        sgContours.Cells[2,0] := 'Row';
        comboGrid.Enabled := True;
        lblGrid.Enabled := True;
      end;
  else Assert(False);
  end;
end;

procedure TfrmImportPoints.rgDataFormatClick(Sender: TObject);
begin
  inherited;
  cbPasteinSelectedRow.Enabled := rgDataFormat.ItemIndex <> 2;
end;

end.

