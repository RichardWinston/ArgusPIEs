unit ImportContoursUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, ArgusFormUnit, Spin,
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
    sgContourCoordinates: TStringGrid;
    odRead: TOpenDialog;
    Panel1: TPanel;
    Label1: TLabel;
    seContourCount: TSpinEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    rgCoordinateDataFormat: TRadioGroup;
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
    rgParameterDataFormat: TRadioGroup;
    BitBtn4: TBitBtn;
    Memo1: TMemo;
    btnPaste: TBitBtn;
    btnFile: TBitBtn;
    btnPasteClipParameter: TBitBtn;
    btnFileParameter: TBitBtn;
    cbPasteinSelectedRow: TCheckBox;
    cbRowImportCoordinates: TCheckBox;
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
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rgParameterDataFormatClick(Sender: TObject);
    procedure rgCoordinateDataFormatClick(Sender: TObject);
  protected
    procedure ReadValuesFromStringList(const AStringList: TStringList;
      const AStringGrid: TStringGrid; const ReadTabValues: boolean); override;
  private
    CoordinateTitles : TStringList;
    ParameterTitles : TStringlist;
    ReadIntoRow: boolean;
    procedure ReadData(const DataSource: TDataSource;
      const DataType : TDataType);
    procedure CopyCoordinateTitles;
    procedure CopyParameterTitles;
    procedure AssignCoordinateRowTitles;
    procedure AssignParameterRowTitles;
    procedure Paste(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

procedure GImportContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;

implementation

{$R *.DFM}

uses Clipbrd, Math, ANECB, OptionsUnit, PointContourUnit,
  frmEditUnit, QuadtreeClass, contnrs, UtilityFunctions;

procedure GImportContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  ImportText : string;
  LayerOptions : TLayerOptions;
  ParameterNames : TStringList;
  frmImportContours: TfrmImportContours;
  InternalLayerHandle : ANE_PTR;
  AString : ANE_STR;
  Contour, TempContour: TContourObjectOptions;
  CellString: string;
  BoolValue: boolean;
  IntValue: integer;
  FloatValue: double;
  QuadTree: TRbwQuadTree;
  ContourList: TObjectList;
  X, Y: double;
  TempList: TList;
  ContourIndex : integer;
  ParameterIndex: integer;
  CanOverride: array of Boolean;
  ParameterTypes: array of TPIENumberType;
  ParamCount: integer;
  Layer : TLayerOptions;
  Parameter : TParameterOptions;
  Data: TPointerArray;
  TempIndex: integer;
  NodeIndex: integer;
  WarningShown: boolean;
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
            ParamCount := ParameterNames.Count;
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

            Layer := TLayerOptions.Create(InternalLayerHandle);
            try
              if (Layer.NumObjects(aneHandle, pieContourObject) > 0)
                and (MessageDlg('The layer to which you are importing the '
                + 'contours already has some contours.  Do you want to erase them?',
                mtInformation, [mbYes, mbNo], 0) = mrYes) then
              begin
                Layer.ClearLayer(aneHandle, False);
              end;

              ImportText := frmImportContours.WriteContours;

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
              TempList := TList.Create;
              try
                for ContourIndex := 0 to Layer.NumObjects(aneHandle, pieContourObject) -1 do
                begin
                  Contour := TContourObjectOptions.Create(aneHandle,
                    InternalLayerHandle, ContourIndex);
                  ContourList.Add(Contour);
                  Contour.GetNthNodeLocation(aneHandle, X, Y, 0);
                  QuadTree.AddPoint(X, Y, Contour);
                end;

                for ContourIndex := 2 to frmImportContours.sgContourCoordinates.RowCount -1 do
                begin
                  X := InternationalStrToFloat(frmImportContours.sgContourCoordinates.Cells[1,ContourIndex]);
                  Y := InternationalStrToFloat(frmImportContours.sgContourCoordinates.Cells[2,ContourIndex]);

                  QuadTree.FindClosestPointsData(X, Y, Data);
                  Contour := nil;
                  if Length(Data) >= 1 then
                  begin
                    if Length(Data) = 1 then
                    begin
                      Contour := Data[0];
                    end
                    else
                    begin
                      TempList.Clear;
                      for TempIndex := 0 to Length(Data)-1 do
                      begin
                        TempList.Add(Data[TempIndex]);
                      end;
                      for TempIndex := TempList.Count -1 downto 0 do
                      begin
                        TempContour := TempList[TempIndex];
                        for NodeIndex := 1 to (frmImportContours.sgContourCoordinates.ColCount -1) div 2 do
                        begin
                          if (frmImportContours.sgContourCoordinates.
                            Cells[NodeIndex*2-1,ContourIndex] = '') or (frmImportContours.sgContourCoordinates.
                            Cells[NodeIndex*2,ContourIndex] = '') then
                          begin
                            if TempContour.NumberOfNodes(aneHandle) <> NodeIndex-1 then
                            begin
                              TempList.Delete(TempIndex);
                            end;
                            break;
                          end;
                        end;
                      end;
                      if TempList.Count >= 1 then
                      begin
                        Contour := TempList[0];
                        if TempList.Count > 1 then
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
                    end;
                  end;

                  if Contour <> nil then
                  begin
                    for ParameterIndex := 0 to ParamCount -1 do
                    begin
                      CellString := trim(frmImportContours.sgParameters.
                        Cells[ParameterIndex + 1,
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
                TempList.Free;
              end;
            finally
              Layer.Free(aneHandle);
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
  Value : String;
  PointIndex : integer;
  XString, YString : String;
  Separator : char;
  ProjectOptions : TProjectOptions;
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
  ProjectOptions := TProjectOptions.Create;
  try
    Separator := ProjectOptions.CopyDelimiter[CurrentModelHandle]
  finally
    ProjectOptions.Free;
  end;

  for RowIndex := 2 to sgContourCoordinates.RowCount -1 do
  begin
    Contour := TLocalContour.Create(TLocalPoint, Separator);
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
      {for ColIndex := 2 to sgParameters.ColCount -1 do
      begin
        CellValue := sgParameters.Cells[ColIndex,RowIndex];
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
      end;}
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

procedure TfrmImportContours.Paste(Sender: TObject);
var
  DataType : TDataType;
begin
  DataType := dtCoordinates;
  if Sender = btnPaste then
  begin
    DataType := dtCoordinates;
  end
  else if (Sender = btnPasteClipParameter) then
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

procedure TfrmImportContours.btnPasteClick(Sender: TObject);
begin
  if Sender = btnPasteClipParameter then
  begin
    ReadIntoRow := cbPasteinSelectedRow.Checked and cbPasteinSelectedRow.Enabled;
  end
  else
  begin
    ReadIntoRow := cbRowImportCoordinates.Checked and cbRowImportCoordinates.Enabled;
  end;

  Paste(Sender);
end;

procedure TfrmImportContours.btnFileClick(Sender: TObject);
var
  DataType : TDataType;
begin
  DataType := dtCoordinates;
  if Sender = btnFile then
  begin
    DataType := dtCoordinates;
    ReadIntoRow := cbRowImportCoordinates.Checked and cbRowImportCoordinates.Enabled;
  end
  else if Sender = btnFileParameter then
  begin
    DataType := dtValues;
    ReadIntoRow := cbPasteinSelectedRow.Checked and cbPasteinSelectedRow.Enabled;
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
  lblVersion.Caption := FileVersion(DllName);
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
  Memo1.Lines.Add('Winston, R.B., 2001, Programs for Simplifying the '
    + 'Analysis of Geographic Information in U.S. Geological Survey '
    + 'Ground-Water Models: U.S. Geological Survey Open-File Report 01-392, '
    + '67 p.');
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
  Separator : char;
  ProjectOptions : TProjectOptions;
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
    ProjectOptions := TProjectOptions.Create;
    try
      Separator := ProjectOptions.CopyDelimiter[CurrentModelHandle]
    finally
      ProjectOptions.Free;
    end;
    ValueStrings := TStringList.Create;
    try
      ReadArgusContours(AStringList.Text, TLocalContour, TLocalPoint, Separator);
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
          If (Pos(Separator,Value) > 0) then
          begin
            ReadTabValuesString(Value, AValue, Separator);
            while (Pos(Separator,Value) > 0) do
            begin
              ReadTabValuesString(Value, AValue, Separator);
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
    if ReadIntoRow then
    begin
      ReadValuesFromStringListIntoRow(AStringList, AStringGrid, ReadTabValues);
    end
    else
    begin
      inherited;
    end;
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

procedure TfrmImportContours.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Delimiters: TSysCharSet;
  Grid: TStringGrid;
  DelimiterIndex: integer;
  ClipBoardText: TStringList;
begin
  inherited;
  if (ActiveControl = sgContourCoordinates)
    or (ActiveControl = sgParameters) then
  begin
    if (ssCtrl in Shift) and ((Key = Ord('V')) or (Key = Ord('v')))
      and Clipboard.HasFormat(CF_TEXT) then
    begin
      Grid := ActiveControl as TStringGrid;
      if Grid = sgContourCoordinates then
      begin
        DelimiterIndex := rgCoordinateDataFormat.ItemIndex;
      end
      else
      begin
        DelimiterIndex := rgParameterDataFormat.ItemIndex;
      end;

      case DelimiterIndex of
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
      else Assert(False);
      end;

      Screen.Cursor := crHourGlass;
      ClipBoardText := TStringList.Create;
      try
        ClipBoardText.Text := Clipboard.AsText;
        if Grid = sgParameters then
        begin
          PasteInStringGrid(ClipBoardText, Grid, Delimiters, True,
            cbPasteinSelectedRow.Checked and cbPasteinSelectedRow.Enabled);
        end
        else
        begin
          PasteInStringGrid(ClipBoardText, Grid, Delimiters, True, False);
        end;

        seContourCount.Value := Grid.RowCount-2;
        sePointCount.Value := sgContourCoordinates.ColCount div 2;
      finally
        ClipBoardText.Free;
        Screen.Cursor := crDefault;
      end;
    end;
  end;
end;

procedure TfrmImportContours.rgParameterDataFormatClick(Sender: TObject);
begin
  inherited;
  cbPasteinSelectedRow.Enabled := rgParameterDataFormat.ItemIndex <> 2;
end;

procedure TfrmImportContours.rgCoordinateDataFormatClick(Sender: TObject);
begin
  inherited;
  cbRowImportCoordinates.Enabled := rgCoordinateDataFormat.ItemIndex <> 2;
end;

end.
