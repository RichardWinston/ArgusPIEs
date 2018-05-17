unit frmDataEditUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, RBWZoomBox, Grids, DataGrid, ComCtrls, Buttons, ToolWin,
  StdCtrls, ExtCtrls, contnrs, ANEPie, OptionsUnit, frmDataValuesUnit,
  ASLink, VersInfo, Spin, Math, WriteContourUnit, PointContourUnit;

type
  TDataSource = (dsClipboard, dsFile);
  TDataType = (dtCoordinates, dtValues);

type
  TDoubleArray = Array[0..MAXINT div 16] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = Array[0..MAXINT div 8] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..MAXINT div 8] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;

  TSelectZoomPoint = class(TRBWZoomPoint)
  private
    Selected : boolean;
    Procedure Select(XInt, YInt : integer);
  end;

  TfrmDataEdit = class(TfrmWriteContour)
    pcMain: TPageControl;
    tabGraphical: TTabSheet;
    tabTable: TTabSheet;
    dgDataPoints: TDataGrid;
    zbDataPoints: TRBWZoomBox;
    StatusBar1: TStatusBar;
    tabAbout: TTabSheet;
    Image1: TImage;
    ASLink1: TASLink;
    Label1: TLabel;
    VersionInfo1: TVersionInfo;
    Panel1: TPanel;
    btnOK: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    BitBtnOK2: TBitBtn;
    BitBtn3: TBitBtn;
    Panel5: TPanel;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    odRead: TOpenDialog;
    sbFileOpen: TSpeedButton;
    sbPaste: TSpeedButton;
    sbSelect: TSpeedButton;
    sbZoomIn: TSpeedButton;
    sbZoomExtents: TSpeedButton;
    sbPan: TSpeedButton;
    sbAdd: TSpeedButton;
    sbDelete: TSpeedButton;
    seContourCount: TSpinEdit;
    Label2: TLabel;
    rgDataFormat: TRadioGroup;
    Label3: TLabel;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    sbZoomOut: TSpeedButton;
    sbZoom: TSpeedButton;
    procedure zbDataPointsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zbDataPointsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure zbDataPointsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbZoomExtentsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure zbDataPointsPaint(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure dgDataPointsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure sbSelectClick(Sender: TObject);
    procedure sbZoomInClick(Sender: TObject);
    procedure sbPanClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure zbDataPointsResize(Sender: TObject);
    procedure dgDataPointsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure seContourCountChange(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure dgDataPointsColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure dgDataPointsRowMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure sbFileOpenClick(Sender: TObject);
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure sbZoomClick(Sender: TObject);
    procedure sbZoomOutClick(Sender: TObject);
  private
    { Private declarations }
    ParameterNames : TStringList;
    DataLayer : TLayerOptions;
    ContourLayer : TLayerOptions;
    DataValues : TObjectList;
    ZoomPoints : TObjectList;
    SelectedPoint : TSelectZoomPoint;
    SelectedDataValue : TDataValues;
    SelectedIndex : integer;
    ContourLayerHandle : ANE_PTR;
    CurrentPosition : TRBWZoomPoint;
    ContourTitles : TStringList;
    function SetDataRows: boolean;
    function SetDataColumns(IsContourLayer : boolean) : boolean;
    procedure SelectPoint(X, Y: Integer);
    procedure Add(X, Y: integer);
    function Edit: boolean;
    procedure Delete(X, Y: integer);
    procedure SetStatusBarCaption(X, Y: Integer);
    function SetContourDataRows: boolean;
    procedure ReadData(const DataSource: TDataSource);
    procedure StoreContourTitles;
    procedure SelectByIndex(const Index: integer);
    procedure DeleteSelectedPoint;
    procedure AddNoChange(X, Y: integer);
    procedure SetAllValues;
    function ReadArgusContoursTest(
      const AStringList: TStringList): boolean;
  protected
    procedure ReadValuesFromStringList(const AStringList: TStringList;
      const AStringGrid: TStringGrid; const ReadTabValues: boolean); override;
  public
    OK : boolean;
    MinX, MinY, MaxX, MaxY : double;
    LayerHandle : ANE_PTR;
    Procedure GetData(ADataLayerHandle : ANE_PTR);
    procedure GetContourData(AContourLayerHandle: ANE_PTR);
    { Public declarations }
  end;

  TLocalPoint = class(TArgusPoint)
    Procedure Draw; override;
    class Function GetZoomBox : TRBWZoomBox; override;
  end;

  TLocalContour = class(TContour)
    Procedure Draw; override;
  end;

var
  frmDataEdit: TfrmDataEdit;

implementation

{$R *.DFM}

uses Clipbrd, ANECB, UtilityFunctions;

procedure TfrmDataEdit.zbDataPointsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if sbZoom.Down then
  begin
    zbDataPoints.Cursor := crCross;
    zbDataPoints.PBCursor := crCross;
    zbDataPoints.SCursor := crCross;
    zbDataPoints.BeginZoom(X,Y);
  end
  else if sbPan.Down then
  begin
{    zbDataPoints.Cursor := crHandPoint;
    zbDataPoints.PBCursor := crHandPoint;
    zbDataPoints.SCursor :=  crHandPoint;  }
    zbDataPoints.BeginPan;
  end;
end;

procedure TfrmDataEdit.SetStatusBarCaption(X,Y: Integer);
begin
  CurrentPosition.XCoord := X;
  CurrentPosition.YCoord := Y;
  StatusBar1.SimpleText := Format('X: %g; Y: %g', [CurrentPosition.X, CurrentPosition.Y]);
end;

procedure TfrmDataEdit.zbDataPointsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  SetStatusBarCaption(X, Y);
  if sbZoom.Down then
  begin
    zbDataPoints.ContinueZoom(X, Y);
  end;
end;

procedure TfrmDataEdit.SelectByIndex(const Index : integer);
var
  ZoomPoint : TSelectZoomPoint;
begin
  ZoomPoint := ZoomPoints[Index] as TSelectZoomPoint;
  ZoomPoint.Selected := True;
  if SelectedPoint <> nil then
  begin
    SelectedPoint.Selected := False;
  end;
  SelectedPoint := ZoomPoint;
  SelectedDataValue := DataValues[Index] as TDataValues;
  SelectedIndex := Index;
end;

procedure TfrmDataEdit.SelectPoint(X, Y: Integer);
var
  Index : integer;
  ZoomPoint : TSelectZoomPoint;
begin
  for Index := 0 to ZoomPoints.Count -1 do
  begin
    ZoomPoint := ZoomPoints[Index] as TSelectZoomPoint;
    ZoomPoint.Select(X,Y);
    if ZoomPoint.Selected then
    begin
      SelectByIndex(Index);
{      if SelectedPoint <> nil then
      begin
        SelectedPoint.Selected := False;
      end;
      SelectedPoint := ZoomPoint;
      SelectedDataValue := DataValues[Index] as TDataValues;
      SelectedIndex := Index; }
      Exit;
    end;
  end;
  SelectedPoint := nil;
  SelectedDataValue := nil;
end;

function TfrmDataEdit.Edit : boolean;
var
  ColIndex : integer;
begin
  result := SelectedDataValue.Edit(ParameterNames);
  if result then
  begin
    SelectedPoint.X := SelectedDataValue.X;
    SelectedPoint.Y := SelectedDataValue.Y;
    dgDataPoints.Cells[1,SelectedIndex+2] := FloatToStr(SelectedDataValue.X);
    dgDataPoints.Cells[2,SelectedIndex+2] := FloatToStr(SelectedDataValue.Y);
    for ColIndex := 3 to dgDataPoints.ColCount -1 do
    begin
      dgDataPoints.Cells[ColIndex,SelectedIndex+2] :=
        FloatToStr(SelectedDataValue.Values[ColIndex-3]);
    end;
  end;
  zbDataPoints.Invalidate;
end;

procedure TfrmDataEdit.zbDataPointsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if sbZoom.Down then
  begin
    zbDataPoints.FinishZoom(X,Y);
    sbZoom.Down := False;
    sbPan.Enabled := True;
  end
  else if sbSelect.Down then
  begin
    SelectPoint(X, Y);
    if SelectedDataValue <> nil then
    begin
      Edit;
    end;
  end
  else if sbPan.Down then
  begin
    zbDataPoints.EndPan;
  end
  else if sbAdd.Down then
  begin
    Add(X,Y);
  end
  else if sbDelete.Down then
  begin
    Delete(X,Y);
  end;

end;

procedure TfrmDataEdit.sbZoomExtentsClick(Sender: TObject);
var
  APoint : TSelectZoomPoint;
begin
  inherited;
  if ZoomPoints.Count > 0 then
  begin
    APoint := ZoomPoints[0] as TSelectZoomPoint;
    CurrentPosition.X := APoint.X;
    CurrentPosition.Y := APoint.Y;
  end;
  zbDataPoints.ZoomOut;
  sbSelect.Down := True;
  sbSelectClick(Sender);
  sbPan.Enabled := False;
end;

function TfrmDataEdit.SetDataColumns(IsContourLayer : boolean) : boolean;
var
  Index : integer;
  AColumn : TColumn;
begin
  try
    if IsContourLayer then
    begin
      ContourLayer.GetParameterNames(CurrentModelHandle,ParameterNames);
    end
    else
    begin
      DataLayer.GetParameterNames(CurrentModelHandle,ParameterNames);
    end;
    result := ParameterNames.Count > 0;
    If not result then
    begin
      Beep;
      MessageDlg('The data layer has no parameters', mtError, [mbOK], 0);
      Exit;
    end;
    dgDataPoints.ColCount := ParameterNames.Count + 3;
    for Index := 0 to ParameterNames.Count -1 do
    begin
      AColumn := dgDataPoints.Columns[Index+3];
      dgDataPoints.Cells[Index+3,0] := ParameterNames[Index];
//      AColumn.Title.Caption := ParameterNames[Index];
      AColumn.Format := cfNumber;
    end;
    StoreContourTitles;
    dgDataPoints.Rows[1] := ContourTitles;
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
      Result := False;
    end;
  end;
end;

procedure TfrmDataEdit.GetData(ADataLayerHandle : ANE_PTR);
var
  Index, Count: integer;
begin
  OK := False;
  LayerHandle := ADataLayerHandle;
  DataLayer := TLayerOptions.Create(ADataLayerHandle);
  try
    Ok := SetDataColumns(False);
    if not OK then Exit;
    Ok := SetDataRows;
    if not OK then Exit;
    Count := 0;
    for Index := 2 to dgDataPoints.RowCount -1 do
    begin
      Inc(Count);
      dgDataPoints.Cells[0,Index] := IntToStr(Count);
    end;

  finally
    DataLayer.Free(CurrentModelHandle);
    DataLayer := nil;
  end;
  zbDataPoints.ZoomOut;
  OK := True;
end;

procedure TfrmDataEdit.GetContourData(AContourLayerHandle : ANE_PTR);
begin
  OK := False;
  LayerHandle := AContourLayerHandle;
  ContourLayerHandle := AContourLayerHandle;
  ContourLayer := TLayerOptions.Create(AContourLayerHandle);
  try
    Ok := SetDataColumns(True);
    if not OK then Exit;
    Ok := SetContourDataRows;
    if not OK then Exit;
  finally
    ContourLayer.Free(CurrentModelHandle);
    ContourLayer := nil;
  end;
  OK := True;
end;

procedure TfrmDataEdit.FormCreate(Sender: TObject);
begin
  inherited;
  ContourTitles := TStringList.Create;
  OK := True;
  DataLayer := nil;
  SelectedPoint := nil;
  SelectedDataValue := nil;
  CurrentPosition := TRBWZoomPoint.Create(zbDataPoints);
  ParameterNames := TStringList.Create;
  DataValues := TObjectList.Create;
  ZoomPoints := TObjectList.Create;
  pcMain.ActivePage := tabGraphical;
  Constraints.MinWidth := Width;
  VersionInfo1.FileName := GetDLLName;
  Label1.Caption := 'Version: ' + VersionInfo1.FileVersion;
  dgDataPoints.Cells[1,0] := 'X';
  dgDataPoints.Cells[2,0] := 'Y';
end;

procedure TfrmDataEdit.FormDestroy(Sender: TObject);
begin
  inherited;
  ContourTitles.Free;
  ParameterNames.Free;
  DataValues.Free;
  ZoomPoints.Free;
  CurrentPosition.Free;
end;

function TfrmDataEdit.SetDataRows : boolean;
var
  ColIndex, RowIndex, ParamIndex, ObjectIndex : integer;
  DataObject : TDataObjectOptions;
  Value : double;
  X, Y : ANE_DOUBLE;
  ADataValues : TDataValues;
  AZoomPoint : TSelectZoomPoint;
  ObjectCount : integer;
begin
  result := True;
  MinX := 0;
  MinY := 0;
  MaxX := 0;
  MaxY := 0;
  try
    ObjectCount := DataLayer.NumObjects(CurrentModelHandle, pieDataPointObject);
    dgDataPoints.RowCount := ObjectCount + 2;
    if dgDataPoints.RowCount < 3 then
    begin
      Beep;
      MessageDlg('The data layer has no data points', mtWarning, [mbOK], 0);
      Exit;
    end;
    for RowIndex := 2 to dgDataPoints.RowCount -1 do
    begin
      ObjectIndex := RowIndex - 2;

      ADataValues := TDataValues.Create{(ObjectIndex)};
      DataValues.Add(ADataValues);

      DataObject := TDataObjectOptions.Create(CurrentModelHandle,
        DataLayer.LayerHandle, ObjectIndex);
      try
        DataObject.GetLocation(CurrentModelHandle, X, Y);
        if RowIndex = 2 then
        begin
          MinX := X;
          MinY := Y;
          MaxX := X;
          MaxY := Y;
        end
        else
        begin
          if X > MaxX then MaxX := X;
          if X < MinX then MinX := X;
          if Y > MaxY then MaxY := Y;
          if Y < MinY then MinY := Y;
        end;
        dgDataPoints.Cells[1,RowIndex] := FloatToStr(X);
        dgDataPoints.Cells[2,RowIndex] := FloatToStr(Y);
        ADataValues.X := X;
        ADataValues.Y := Y;

        AZoomPoint := TSelectZoomPoint.Create(zbDataPoints);
        AZoomPoint.X := X;
        AZoomPoint.Y := Y;
        ZoomPoints.Add(AZoomPoint);

        for ColIndex := 3 to dgDataPoints.ColCount -1 do
        begin
          ParamIndex := ColIndex -3;
          Value := DataObject.GetFloatParameter(CurrentModelHandle,ParamIndex);
          dgDataPoints.Cells[ColIndex,RowIndex] := FloatToStr(Value);
          ADataValues.Values.Add(Value);
        end;
      finally
        DataObject.Free;
      end;

    end;
    seContourCount.Value := ObjectCount;
    sbZoomOutClick(nil);
  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
      Result := False;
    end;
  end;

end;

function TfrmDataEdit.SetContourDataRows : boolean;
var
  ColIndex, ParamIndex, ObjectIndex : ANE_INT32;
  ContourObject : TContourObjectOptions;
  Value : double;
  X, Y : ANE_DOUBLE;
  ADataValues : TDataValues;
  ObjectCount : integer;
  NodeCount, NodeIndex : ANE_INT32;
  LayerName : string;
  Values : array of ANE_DOUBLE;
  Types : array of TPIENumberType;
  Param : TParameterOptions;
begin
  result := True;
  MinX := 0;
  MinY := 0;
  MaxX := 0;
  MaxY := 0;
  try
    LayerName := ContourLayer.Name[CurrentModelHandle] + '.';
    ContourLayer.ClearParsedExpressions(CurrentModelHandle);
    ObjectCount := ContourLayer.NumObjects(CurrentModelHandle,
      pieContourObject);
//    dgDataPoints.RowCount := ObjectCount + 1;
    if ObjectCount < 1 then
    begin
      Beep;
      MessageDlg('The information layer has no contours', mtWarning, [mbOK], 0);
      Exit;
    end;

{    for ColIndex := 2 to dgDataPoints.ColCount -1 do
    begin
      ParameterNames.Add(dgDataPoints.Columns[ColIndex].Title.Caption)
    end;  }

    SetLength(Values, ParameterNames.Count);
    SetLength(Types, ParameterNames.Count);

    for ParamIndex := 0 to ParameterNames.Count -1 do
    begin
      Param := TParameterOptions.Create(ContourLayer.LayerHandle,ParamIndex);
      try
        Types[ParamIndex] := Param.NumberType[CurrentModelHandle];
      finally
        Param.Free;
      end;

    end;

    for ObjectIndex := 0 to ObjectCount -1 do
    begin
      ContourObject := TContourObjectOptions.Create(CurrentModelHandle,
        ContourLayer.LayerHandle, ObjectIndex);
      try
        for ParamIndex := 0 to ParameterNames.Count -1 do
        begin
          case Types[ParamIndex] of
            pnBoolean:
             begin
               if ContourObject.GetBoolParameter
                 (CurrentModelHandle,ParamIndex) then
               begin
                 Values[ParamIndex] := 1;
               end
               else
               begin
                 Values[ParamIndex] := 0;
               end;
             end;
            pnInteger:
             begin
               Values[ParamIndex] := ContourObject.GetIntegerParameter
                 (CurrentModelHandle,ParamIndex);
             end;
            pnFloat:
             begin
               Values[ParamIndex] := ContourObject.GetFloatParameter
                 (CurrentModelHandle,ParamIndex);
             end;
            pnString:
             begin
               try
                 Values[ParamIndex] := StrToFloat(ContourObject.
                   GetStringParameter(CurrentModelHandle,ParamIndex));
               except on EConvertError do
                 begin
                   Values[ParamIndex] := 0;
                 end;
               end;
             end;
            pnNA:
             begin
               Values[ParamIndex] := 0;
             end;
          else Assert(False);
          end;

        end;

        NodeCount := ContourObject.NumberOfNodes(CurrentModelHandle);
        for NodeIndex := 0 to NodeCount -1 do
        begin
          ContourObject.GetNthNodeLocation(CurrentModelHandle,X,Y,NodeIndex);
          ADataValues := TDataValues.Create;
          DataValues.Add(ADataValues);
          if (NodeIndex = 0) and (ObjectIndex = 0) then
          begin
            MinX := X;
            MinY := Y;
            MaxX := X;
            MaxY := Y;
          end
          else
          begin
            if X > MaxX then MaxX := X;
            if X < MinX then MinX := X;
            if Y > MaxY then MaxY := Y;
            if Y < MinY then MinY := Y;
          end;
//          dgDataPoints.Cells[0,RowIndex] := FloatToStr(X);
//          dgDataPoints.Cells[1,RowIndex] := FloatToStr(Y);
          ADataValues.X := X;
          ADataValues.Y := Y;
          for ColIndex := 3 to dgDataPoints.ColCount -1 do
          begin
            ParamIndex := ColIndex -3;
            Value := Values[ParamIndex];
            ADataValues.Values.Add(Value);
          end;
        end;
      finally
        ContourObject.Free;
      end;
    end;

  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
      Result := False;
    end;
  end;

end;

procedure TfrmDataEdit.zbDataPointsPaint(Sender: TObject);
var
  Index : integer;
  ZoomPoint : TSelectZoomPoint;
begin
  inherited;
  for Index := 0 to ZoomPoints.Count -1 do
  begin
    ZoomPoint := ZoomPoints[Index] as TSelectZoomPoint;
    with ZoomPoint do
    begin
      if Selected then
      begin
        zbDataPoints.PBCanvas.Brush.Style := bsClear;
      end
      else
      begin
        zbDataPoints.PBCanvas.Brush.Color := clBlack;
        zbDataPoints.PBCanvas.Brush.Style := bsSolid;
      end;
      zbDataPoints.PBCanvas.Rectangle(XCoord-2,YCoord-2,XCoord+2,YCoord+2);
    end;
  end;

end;

procedure TfrmDataEdit.btnOKClick(Sender: TObject);
var
  DataValue : TDataValues;
  Values : pMatrix;
  PosX, PosY : PDoubleArray;
  Names : PParamNamesArray;
  NameIndex, ValueIndex : integer;
  ShowWarning : boolean;
  AName : string;
begin
  inherited;
  ShowWarning := False;
  posX := nil;
  posY := nil;
  Values := nil;
  Names := nil;
  try
    begin
      GetMem(posX, DataValues.Count*SizeOf(double));
      GetMem(posY, DataValues.Count*SizeOf(double));
      GetMem(Values, ParameterNames.Count*SizeOf(pMatrix));
      GetMem(Names, ParameterNames.Count*SizeOf(ANE_STR));
      try
        begin
          FOR NameIndex := 0 TO ParameterNames.Count-1 DO
          begin
            Values^[NameIndex] := nil;
          end;

          FOR NameIndex := 0 TO ParameterNames.Count-1 DO
          begin
            GetMem(Values[NameIndex], DataValues.Count*SizeOf(DOUBLE));
          end;

          for NameIndex := 0 to ParameterNames.Count -1 do
          begin
            AName := ParameterNames[NameIndex];
            GetMem(Names^[NameIndex],(Length(AName) + 1));
            StrPCopy(Names^[NameIndex], AName);
//            Names^[NameIndex] := PChar(ParameterNames[NameIndex]);
          end;

          for ValueIndex := 0 to DataValues.Count -1 do
          begin
            DataValue := DataValues[ValueIndex] as TDataValues;
            If (DataValue.X > MaxX) or (DataValue.X < MinX)
              or (DataValue.Y > MaxY) or (DataValue.Y < MinY)
              then ShowWarning := True;

            PosX^[ValueIndex] := DataValue.X;
            PosY^[ValueIndex] := DataValue.Y;
            for NameIndex := 0 to ParameterNames.Count -1 do
            begin
              Values[NameIndex]^[ValueIndex] := DataValue.Values[NameIndex];
            end;
          end;

          ANE_DataLayerSetData(CurrentModelHandle,
            LayerHandle,
            DataValues.Count,
            @PosX^,
            @PosY^,
            ParameterNames.Count,
            @Values^,
            @Names^);

        end;
      finally
        begin
          FOR NameIndex := ParameterNames.Count-1 DOWNTO 0 DO
          begin
            FreeMem(Values[NameIndex]);
          end;
        end;
      end;
    end
  finally
    begin
      FreeMem(Values  );
      FreeMem(posY);
      FreeMem(posX);
      FreeMem(Names);
    end;
  end;
  if ShowWarning then
  begin
    Beep;
    MessageDlg('It is possible that some data points are outside the visible '
      + 'area of the model.  To see them, you may need to resize your model.  '
      + 'One easy way to do this is to select the "Special|Scale to Fit" menu '
      + 'item.',
      mtInformation, [mbOK], 0);
  end;
end;

procedure TfrmDataEdit.dgDataPointsSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  DataValue : TDataValues;
  DoubleValue : double;
  ZoomPoint : TRBWZoomPoint;
begin
  inherited;
  if (ACol >= dgDataPoints.FixedCols) and (ARow >= dgDataPoints.FixedRows) then
  begin
    if (Value <> '') and (Value <> '-') and (Value <> '+') then
    begin
      DoubleValue := StrToFloat(Value);
    end
    else
    begin
      DoubleValue := 0;
    end;
    DataValue := DataValues[ARow-2] as TDataValues;
    ZoomPoint := ZoomPoints[ARow-2] as TRBWZoomPoint;
    if (ACol > 2) and (DataValue.Values.Count > ACol-3) then
    begin
      DataValue.Values[ACol-3] := DoubleValue;
    end
    else if ACol = 1 then
    begin
      DataValue.X := DoubleValue;
      ZoomPoint.X := DoubleValue;
    end
    else if ACol = 2 then
    begin
      DataValue.Y := DoubleValue;
      ZoomPoint.Y := DoubleValue;
    end;
  end;
end;

procedure TfrmDataEdit.AddNoChange(X,Y : integer);
var
  ZoomPoint : TSelectZoomPoint;
  DataValue : TDataValues;
  Row : integer;
  ColIndex : integer;
begin
  ZoomPoint := TSelectZoomPoint.Create(zbDataPoints);
  ZoomPoint.XCoord := X;
  ZoomPoint.YCoord := Y;
  ZoomPoints.Add(ZoomPoint);

  Row := dgDataPoints.RowCount;
  dgDataPoints.RowCount := Row + 1;
  dgDataPoints.FixedRows := 2;
  dgDataPoints.Cells[0,Row] := IntToStr(Row-1);
  dgDataPoints.Cells[1,Row] := FloatToStr(ZoomPoint.X);
  dgDataPoints.Cells[2,Row] := FloatToStr(ZoomPoint.Y);
  for ColIndex := 2 to dgDataPoints.ColCount -1 do
  begin
    dgDataPoints.Cells[ColIndex,Row] := '0';
  end;

  DataValue := TDataValues.Create;
  DataValue.Modified := True;
  DataValue.X := ZoomPoint.X;
  DataValue.Y := ZoomPoint.Y;
  DataValue.Values.Count := ParameterNames.Count;
  DataValues.Add(DataValue);

  SelectedDataValue := DataValue;
  SelectedPoint := ZoomPoint;
  SelectedIndex := Row -2;
end;

procedure TfrmDataEdit.Add(X,Y : integer);
{var
  ZoomPoint : TSelectZoomPoint;
  DataValue : TDataValues;
  Row : integer;
  ColIndex : integer; }
begin
  AddNoChange(X,Y);
{  ZoomPoint := TSelectZoomPoint.Create(zbDataPoints);
  ZoomPoint.XCoord := X;
  ZoomPoint.YCoord := Y;
  ZoomPoints.Add(ZoomPoint);

  Row := dgDataPoints.RowCount;
  dgDataPoints.RowCount := Row + 1;
  dgDataPoints.FixedRows := 2;
  dgDataPoints.Cells[0,Row] := FloatToStr(ZoomPoint.X);
  dgDataPoints.Cells[1,Row] := FloatToStr(ZoomPoint.Y);
  for ColIndex := 2 to dgDataPoints.ColCount -1 do
  begin
    dgDataPoints.Cells[ColIndex,Row] := '0';
  end;

  DataValue := TDataValues.Create;
  DataValue.Modified := True;
  DataValue.X := ZoomPoint.X;
  DataValue.Y := ZoomPoint.Y;
  DataValue.Values.Count := ParameterNames.Count;
  DataValues.Add(DataValue);

  SelectedDataValue := DataValue;
  SelectedPoint := ZoomPoint;
  SelectedIndex := Row -2;   }
  if not Edit then
  begin
    SelectedDataValue := nil;
    SelectedPoint := nil;
    DataValues.Delete(SelectedIndex);
    ZoomPoints.Delete(SelectedIndex);
//    ZoomPoint.Free;
//    DataValue.Free;
    dgDataPoints.RowCount := dgDataPoints.RowCount - 1;
    Exit;
  end;
  seContourCount.Value := seContourCount.Value + 1;
//  DataValue.Edit(ParameterNames);
end;
{ TSelectZoomPoint }

procedure TSelectZoomPoint.Select(XInt, YInt: integer);
const
  Epsilon = 4;
begin
  Selected := (XCoord + Epsilon > XInt) and (XInt > XCoord - Epsilon) and
    (YCoord + Epsilon > YInt) and (YInt > YCoord - Epsilon)
end;

procedure TfrmDataEdit.sbSelectClick(Sender: TObject);
begin
  inherited;
  if  sbSelect.Down or sbAdd.Down or sbDelete.Down then
  begin
    zbDataPoints.Cursor := crDefault;
    zbDataPoints.PBCursor := crDefault;
    zbDataPoints.SCursor := crDefault;
  end;

end;

procedure TfrmDataEdit.sbZoomInClick(Sender: TObject);
begin
  inherited;
  zbDataPoints.ZoomBy(2);
  sbZoomExtents.Enabled := True;
  sbPan.Enabled := True;
{  if sbZoomIn.Down then
  begin
    zbDataPoints.Cursor := crCross;
    zbDataPoints.PBCursor := crCross;
    zbDataPoints.SCursor := crCross;
  end;  }

end;

procedure TfrmDataEdit.sbPanClick(Sender: TObject);
begin
  inherited;
  if sbPan.Down then
  begin
    zbDataPoints.Cursor := crHandPoint;
    zbDataPoints.PBCursor := crHandPoint;
    zbDataPoints.SCursor :=  crHandPoint;
  end
  else
  begin
    zbDataPoints.Cursor := crDefault;
    zbDataPoints.PBCursor := crDefault;
    zbDataPoints.SCursor :=  crDefault;
  end;

end;

procedure TfrmDataEdit.FormShow(Sender: TObject);
begin
  inherited;
  SetColumnWidths(dgDataPoints);
end;

procedure TfrmDataEdit.DeleteSelectedPoint;
begin
  if SelectedDataValue <> nil then
  begin
    DataValues.Delete(SelectedIndex);
    ZoomPoints.Delete(SelectedIndex);
    if dgDataPoints.RowCount = 2 then
    begin
      dgDataPoints.FixedRows := 0;
    end;
    dgDataPoints.DeleteRow(SelectedIndex+2);
    SelectedDataValue := nil;
    SelectedPoint := nil;
    SelectedIndex := -1;
    zbDataPoints.Invalidate;
  end;
end;

procedure TfrmDataEdit.Delete(X, Y: integer);
begin
  SelectPoint(X, Y);
  DeleteSelectedPoint;
  seContourCount.Value := seContourCount.Value -1
{  if SelectedDataValue <> nil then
  begin
    DataValues.Delete(SelectedIndex);
    ZoomPoints.Delete(SelectedIndex);
    if dgDataPoints.RowCount = 2 then
    begin
      dgDataPoints.FixedRows := 0;
    end;
    dgDataPoints.DeleteRow(SelectedIndex+2);
    zbDataPoints.Invalidate;
  end;  }
end;

procedure TfrmDataEdit.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  StatusBar1.SimpleText := '';
end;

procedure TfrmDataEdit.zbDataPointsResize(Sender: TObject);
begin
  inherited;
  sbPan.Enabled := True;
end;

procedure TfrmDataEdit.dgDataPointsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = 9) and (dgDataPoints.Col = dgDataPoints.ColCount -1)
    and (dgDataPoints.Row = dgDataPoints.RowCount -1)then
  begin
    BitBtnOK2.SetFocus
  end;
end;
procedure TfrmDataEdit.seContourCountChange(Sender: TObject);
var
//  OldRowCount : integer;
  Index : integer;
  NewRowCount : integer;
begin
  inherited;
//  OldRowCount := sgContourCoordinates.RowCount;
  NewRowCount := seContourCount.Value + 2;
  if NewRowCount > dgDataPoints.RowCount then
  begin
    for Index := dgDataPoints.RowCount + 1 to NewRowCount do
    begin
      AddNoChange(zbDataPoints.XCoord(0),zbDataPoints.YCoord(0));
    end;
  end
  else
  begin
    for Index := dgDataPoints.RowCount -1 downto NewRowCount  do
    begin
      SelectByIndex(ZoomPoints.Count -1);
      DeleteSelectedPoint;
    end;
  end;
  dgDataPoints.Enabled := seContourCount.Value > 0;
{  dgDataPoints.RowCount := seContourCount.Value + 2;
  for Index := 2 to dgDataPoints.RowCount - 1 do
  begin
    dgDataPoints.Cells[0,Index] := IntToStr(Index-1);
  end;   }
end;

procedure TfrmDataEdit.ReadData(Const DataSource : TDataSource);
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
      ReadValuesFromStringList(AStringList, dgDataPoints,
        (rgDataFormat.ItemIndex = 0));
    finally
      AStringList.Free;
    end;
    SetColumnWidths(dgDataPoints);
    seContourCount.Value := dgDataPoints.RowCount -2;
  end;
end;

procedure TfrmDataEdit.btnPasteClick(Sender: TObject);
begin
  inherited;
  ReadData(dsClipboard);
  StoreContourTitles;

end;

procedure TfrmDataEdit.StoreContourTitles;
begin
  ContourTitles.Assign(dgDataPoints.Rows[0]);
end;

procedure TfrmDataEdit.dgDataPointsColumnMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
  inherited;
  dgDataPoints.Rows[0].Assign(ContourTitles);
  SetAllValues;
end;

procedure TfrmDataEdit.SetAllValues;
var
  ColIndex, RowIndex : integer;
begin
  for ColIndex := dgDataPoints.FixedCols to dgDataPoints.ColCount -1 do
  begin
    for RowIndex := dgDataPoints.FixedRows to dgDataPoints.RowCount -1 do
    begin
      dgDataPointsSetEditText(dgDataPoints,ColIndex,RowIndex,
        dgDataPoints.Cells[ColIndex,RowIndex]);
    end;
  end;
end;

procedure TfrmDataEdit.dgDataPointsRowMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
  inherited;
  SetAllValues;
end;

function TfrmDataEdit.ReadArgusContoursTest
  (const AStringList : TStringList) : boolean;
var
  index : integer;
  AString : string;
begin
  result := rgDataFormat.ItemIndex = 2;
  if not result then
  begin
    for Index := 0 to min(AStringList.Count -1,10) do
    begin
      AString := AStringList[Index];
      if (Pos('# Points Count',AString) = 1)
        or (Pos('# X pos',AString) = 1) then
      begin
        result := True;
        Break;
      end;
    end;
  end;
end;

procedure TfrmDataEdit.ReadValuesFromStringList(const AStringList : TStringList;
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
  function DataCount : integer;
  var
    Index, StrLength : integer;
    AString : string;
  begin
    result := AStringList.Count;
    for Index := AStringList.Count -1 downto 0 do
    begin
      AString := AStringList[Index];
      StrLength := Length(AString);
      if (StrLength = 0) or ((StrLength > 0) and (AString[1] = '#')) then
      begin
        Dec(Result);
      end;
    end;
  end;
begin
  if ReadArgusContoursTest(AStringList) then
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
        if ValueStrings.Count + 3 > AStringGrid.ColCount then
        begin
          AStringGrid.ColCount := ValueStrings.Count + 3;
//          AssignRowTitles;
        end;
        AContour.MakeOpenContour;
        for PointIndex := 0 to AContour.PointCount - 1 do
        begin
          APoint := AContour.PointValues[PointIndex];
          RowIndex := RowIndex + 1;
          if (RowIndex+1 > AStringGrid.RowCount) then
          begin
            AddNoChange(0,0);
//            AStringGrid.RowCount := RowIndex+1;
          end;
          AStringGrid.Cells[0,RowIndex] := IntToStr(RowIndex-1);
          if Assigned(AStringGrid.OnSetEditText) then
          begin
            AStringGrid.OnSetEditText(AStringGrid,0,RowIndex,AStringGrid.Cells[0,RowIndex]);
          end;
          AStringGrid.Cells[1,RowIndex] := FloatToStr(APoint.X);
          if Assigned(AStringGrid.OnSetEditText) then
          begin
            AStringGrid.OnSetEditText(AStringGrid,1,RowIndex,AStringGrid.Cells[1,RowIndex]);
          end;
          AStringGrid.Cells[2,RowIndex] := FloatToStr(APoint.Y);
          if Assigned(AStringGrid.OnSetEditText) then
          begin
            AStringGrid.OnSetEditText(AStringGrid,2,RowIndex,AStringGrid.Cells[2,RowIndex]);
          end;
          for ValueIndex := 0 to ValueStrings.Count -1 do
          begin
            AStringGrid.Cells[ValueIndex+3,RowIndex] :=
              ValueStrings[ValueIndex];
            if Assigned(AStringGrid.OnSetEditText) then
            begin
              AStringGrid.OnSetEditText(AStringGrid,ValueIndex+3,RowIndex,AStringGrid.Cells[ValueIndex+3,RowIndex]);
            end;
          end;
        end;
      end;
    finally
      ValueStrings.Free;
      KillContourList;
      seContourCount.Value := AStringGrid.RowCount -2;
    end;
  end
  else
  begin
    seContourCount.Value := DataCount;
    inherited;
  end;
end;
{ TLocalPoint }

procedure TLocalPoint.Draw;
begin

end;

class function TLocalPoint.GetZoomBox: TRBWZoomBox;
begin
result := frmDataEdit.zbDataPoints;
end;

{ TLocalContour }

procedure TLocalContour.Draw;
begin

end;

procedure TfrmDataEdit.sbFileOpenClick(Sender: TObject);
begin
  inherited;
  ReadData(dsFile);
  StoreContourTitles;

end;

function TfrmDataEdit.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  inherited FormHelp(Command, Data, CallHelp);
  AssignHelpFile('EditDataLayer.hlp');
  result := True;

end;

procedure TfrmDataEdit.sbZoomClick(Sender: TObject);
begin
  inherited;
  if sbZoom.Down then
  begin
    zbDataPoints.PBCursor := crCross;
    zbDataPoints.Cursor := crCross;
    zbDataPoints.SCursor := crCross;
  end
  else
  begin
    zbDataPoints.PBCursor := crDefault;
    zbDataPoints.Cursor := crDefault;
    zbDataPoints.SCursor := crDefault;
  end;
end;

procedure TfrmDataEdit.sbZoomOutClick(Sender: TObject);
begin
  inherited;
  zbDataPoints.ZoomBy(0.5);
end;

end.
