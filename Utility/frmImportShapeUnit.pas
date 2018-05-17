unit frmImportShapeUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WriteContourUnit, XBase1, Grids, ReadShapeFileUnit, IntListUnit,
  RbwDataGrid2, PointContourUnit, RBWZoomBox, StdCtrls, Buttons, ExtCtrls,
  AnePIE, ComCtrls, OptionsUnit, ArgusDataEntry, jpeg, Spin,
  CoordinateConversionUnit, frmSampleUnit, QuadtreeClass;

type
  TDoubleArray = array[0..MAXINT div 16] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = array[0..MAXINT div 8] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..MAXINT div 8] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;

  TImportShapePoint = class(TArgusPoint)
    procedure Draw; override;
    class function GetZoomBox: TRBWZoomBox; override;
    constructor Create; override;
  end;

  TShapeContour = class(TContour)
    procedure Draw; override;
  end;

  TfrmImportShape = class(TfrmSample)
    ShapeDataBase: TXBase;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    btnNext: TBitBtn;
    BitBtn2: TBitBtn;
    pcMain: TPageControl;
    tabImportWhat: TTabSheet;
    dgFields: TRbwDataGrid2;
    tabImportTo: TTabSheet;
    gbLayerType: TGroupBox;
    rbInformationLayer: TRadioButton;
    lblData: TLabel;
    rbDataLayer: TRadioButton;
    rbMapsLayer: TRadioButton;
    lblInformation: TLabel;
    Label1: TLabel;
    gbImportTo: TGroupBox;
    rbNewLayer: TRadioButton;
    edNewLayerName: TEdit;
    lblLayerName: TLabel;
    rbExistingLayer: TRadioButton;
    comboExistingLayer: TComboBox;
    tabCoordinateConvesion: TTabSheet;
    cbCoordinateConversion: TCheckBox;
    StatusBar1: TStatusBar;
    Image1: TImage;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    seZoneNumber: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    btnBack: TBitBtn;
    comboEllipsoid: TComboBox;
    Label4: TLabel;
    btnAll: TButton;
    btnNone: TButton;
    btnToggle: TButton;
    tabSample: TTabSheet;
    pcSample: TPageControl;
    tabGrid: TTabSheet;
    rgGrid: TRadioGroup;
    tabMesh: TTabSheet;
    rgMesh: TRadioGroup;
    Panel2: TPanel;
    cbSample: TCheckBox;
    comboLayerName: TComboBox;
    Label5: TLabel;
    rgGridType: TRadioGroup;
    btnHelp: TBitBtn;
    lblCoordinates: TLabel;
    Label6: TLabel;
    lblError: TLabel;
    Panel3: TPanel;
    cbImportXY: TCheckBox;
    procedure FormCreate(Sender: TObject); override;
    procedure btnNextClick(Sender: TObject);
    procedure rbNewOrExistingLayerClick(Sender: TObject);
    procedure rbLayerTypeClick(Sender: TObject);
    procedure edNewLayerNameChange(Sender: TObject);
    procedure comboExistingLayerChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject); override;
    procedure dgFieldsStateChange(Sender: TObject; ACol, ARow: Integer;
      const Value: TCheckBoxState);
    procedure dgFieldsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure cbCoordinateConversionClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnBackClick(Sender: TObject);
    procedure comboEllipsoidChange(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure btnNoneClick(Sender: TObject);
    procedure btnToggleClick(Sender: TObject);
    procedure cbSampleClick(Sender: TObject);
    procedure comboLayerNameChange(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure cbImportXYClick(Sender: TObject);
  private
    GeometryFile: TShapeGeometryFile;
    ValidFields: TStringList;
    ValidIndicies: TIntegerList;
    FieldTypes: array of TRbwColumnFormat2;
    GeometryFileName: string;
    ShapeIndexFileName: string;
    DataBaseFileName: string;
    InfoLayerParamNames: TStringList;
    ParamTypes: array of TPIENumberType;
    procedure EnableNext;
    procedure GetFileNames;
    procedure GetFields;
    procedure SetData;
    procedure CreateContours;
    function CreateNewLayer: ANE_PTR;
    procedure SetDataLayersData;
    procedure GetLayerParameters(const Row: integer);
    function LatLongToPoint(Long, Lat: double): TPoint;
    function LatLongToUTM_Zone(const LongitudeDegrees, Latitude: double):
      integer;
    function SimpleLongToUTM_Zone(const LongitudeDegrees: double): integer;
    procedure SampleData;
    procedure UpDateProgressBar(Sender: TObject; FractionDone: double);
    { Private declarations }
  public
    FilesOK: boolean;
    procedure GetLayers;
    constructor CreateWithHandle(AOwner: TComponent; aneHandle: ANE_PTR);
    { Public declarations }
  end;

procedure GImportShapePIE(aneHandle: ANE_PTR; const fileName: ANE_STR;
  layerHandle: ANE_PTR); cdecl;

var
  frmImportShape: TfrmImportShape;

implementation

uses UtilityFunctions, ANECB, ANE_LayerUnit, Math,
  FixNameUnit, RealListUnit, ExportProgressUnit;

{$R *.DFM}

{ TfrmImportShape }

procedure TfrmImportShape.GetFileNames;
var
  NewLayerName: string;
begin
  inherited;
  FilesOK := False;
  try
    if OpenDialog1.Execute then
    begin
      GeometryFileName := OpenDialog1.FileName;
      ShapeIndexFileName := ChangeFileExt(GeometryFileName, '.shx');
      DataBaseFileName := ChangeFileExt(GeometryFileName, '.dbf');
      if not FileExists(GeometryFileName) then
      begin
        Beep;
        MessageDlg('The ".shp" file "' + GeometryFileName + '" does not exist.',
          mtError, [mbOK], 0);
        Exit;
      end;
      if not FileExists(DataBaseFileName) then
      begin
        Beep;
        if MessageDlg('The ".dbf" file "' + DataBaseFileName
          + '" does not exist.  Do you want to just import the geometry '
          + 'of the shapes in the Shapefile',
          mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        begin
          Exit;
        end;
        DataBaseFileName := '';
      end;
      FilesOK := True;

      if FileShapeType(GeometryFileName) in [stPoint, stMultipoint,
        stPointZ, stMultipointZ, stPointM, stMultipointM] then
      begin
        rbDataLayer.Checked := True;
      end
      else
      begin
        rbInformationLayer.Checked := True;
      end;


      NewLayerName:= ChangeFileExt(ExtractFileName(GeometryFileName), '');
      edNewLayerName.Text := NewLayerName;
    end;
  finally
    if not FilesOK then
    begin
      Close;
    end;
  end;
end;

procedure TfrmImportShape.CreateContours;
var
  ContourString: string;
  Index: integer;
  ShapeObject: TShapeObject;
  Contour: TShapeContour;
  PointIndex: integer;
  DataSetIndex: integer;
  DataSetName: string;
  Value: string;
  MultipleParts: boolean;
  Point: TImportShapePoint;
  FieldType: TRbwColumnFormat2;
  LayerHandle: ANE_PTR;
  Project: TProjectOptions;
  Values: TStringList;
  NumParams: integer;
  ValueIndex: integer;
  Layer: TLayerOptions;
  CentralMeridian: double;
  X, Y: double;
  CentralMeridianDegrees: double;
  ClearLayer: boolean;
  PartIndex: integer;
  LastPoint: integer;
  LastPart: integer;
  FirstPoint: integer;
  VIndex: integer;
  MaxContoursToWrite: integer;
  PriorX, PriorY, PostX, PostY: double;
  DeltaX, DeltaY, TotalLength: double;
  procedure RetrieveXY(Index: integer; Out X, Y: double);
  begin
    if cbCoordinateConversion.Checked then
    begin
      X := ShapeObject.Points[Index].X;
      Y := ShapeObject.Points[Index].Y;
      if X > CentralMeridianDegrees + 180 then
      begin
        X := X - 360;
      end
      else if X < CentralMeridianDegrees - 180 then
      begin
        X := X + 360;
      end;

      ConvertToUTM(Y / 180 * Pi, X / 180 * Pi,
        CentralMeridian, X, Y);
    end
    else
    begin
      X := ShapeObject.Points[Index].X;
      Y := ShapeObject.Points[Index].Y;
    end;
  end;
begin
  ClearLayer := False;
  if rbExistingLayer.Checked then
  begin
    Project := TProjectOptions.Create;
    try
      LayerHandle := Project.GetLayerByName(CurrentModelHandle,
        comboExistingLayer.Text);
      Layer := TLayerOptions.Create(LayerHandle);
      try
        if Layer.NumObjects(CurrentModelHandle, pieContourObject) > 0 then
        begin
          ClearLayer := MessageDlg('Do you want to delete all contours on '
            + comboExistingLayer.Text + '?', mtInformation,
            [mbYes, mbNo], 0) = mrYes;
        end;
      finally
        Layer.Free(CurrentModelHandle);
      end;
    finally
      Project.Free;
    end;
  end;

  CentralMeridian := 0;
  CentralMeridianDegrees := 0;
  if cbCoordinateConversion.Checked then
  begin
    CentralMeridianDegrees := seZoneNumber.Value * 6 - 183;
    CentralMeridian := CentralMeridianDegrees / 180 * Pi;
  end;

  Values := TStringList.Create;
  try
    if rbInformationLayer.Checked
      and rbExistingLayer.Checked
      and (InfoLayerParamNames.Count > 0) then
    begin
      NumParams := InfoLayerParamNames.Count;
    end
    else
    begin
      NumParams := ValidFields.Count;
    end;

    MultipleParts := false;
    ContourList.Capacity := GeometryFile.Count;
    frmExportProgress := TfrmExportProgress.Create(nil);
    Enabled := False;
    try
      frmExportProgress.Caption := 'Processing Shapes';
      frmExportProgress.ProgressBar1.Max := GeometryFile.Count;
      frmExportProgress.Show;
      for Index := 0 to GeometryFile.Count - 1 do
      begin
        LastPart := 1;
        ShapeObject := GeometryFile[Index];
        if ShapeObject.NumParts >= 2 then
        begin
          if not MultipleParts then
          begin
            Beep;
            MessageDlg('Warning: this Shapefile contains shapes with '
              + 'multiple parts. Each part will be imported as a separate'
              + 'contour.  Some such contours may represent holes in the '
              + 'shapes.  You may need to delete contours that represent '
              + 'holes.', mtWarning, [mbOK], 0);
            MultipleParts := True;
          end;
          LastPart := ShapeObject.NumParts;
        end;
        for PartIndex := 0 to LastPart -1 do
        begin
          if PartIndex = LastPart -1 then
          begin
            LastPoint:= ShapeObject.NumPoints;
          end
          else
          begin
            LastPoint := ShapeObject.Parts[PartIndex+1];
          end;
          if PartIndex = 0 then
          begin
            FirstPoint := 0;
          end
          else
          begin
            FirstPoint := ShapeObject.Parts[PartIndex];
          end;

          Values.Clear;
          Values.Capacity := NumParams;
          for VIndex := 0 to NumParams - 1 do
          begin
            Values.Add(kNA);
          end;


          Application.ProcessMessages;
          Contour := TShapeContour.Create(TImportShapePoint, #9);
          ContourList.Add(Contour);
          if cbImportXY.Checked then
          begin
            Contour.FPoints.Capacity := 1;
          end
          else
          begin
            Contour.FPoints.Capacity := ShapeObject.NumPoints;
          end;
          try
            for PointIndex := FirstPoint to LastPoint - 1 do
            begin
              if cbImportXY.Checked and (PointIndex > FirstPoint) then
              begin
                Contour := TShapeContour.Create(TImportShapePoint, #9);
                ContourList.Add(Contour);
              end;

              Point := TImportShapePoint.Create;
              RetrieveXY(PointIndex, X, Y);
              Point.X := X;
              Point.Y := Y;

              Contour.FPoints.Add(Point);
              if cbImportXY.Checked then
              begin
                if PointIndex > FirstPoint then
                begin
                  RetrieveXY(PointIndex-1, PriorX, PriorY);
                end
                else
                begin
                  RetrieveXY(PointIndex, PriorX, PriorY);
                end;
                if PointIndex < LastPoint-1 then
                begin
                  RetrieveXY(PointIndex+1, PostX, PostY);
                end
                else
                begin
                  RetrieveXY(PointIndex, PostX, PostY);
                end;
                DeltaX := PostX-PriorX;
                DeltaY := PostY-PriorY;
                TotalLength := Sqrt(Sqr(DeltaX) + Sqr(DeltaY));
                if TotalLength > 0 then
                begin
                  DeltaX := DeltaX/TotalLength;
                  DeltaY := DeltaY/TotalLength;
                end;

                Contour.Value := InternationalFloatToStr(DeltaX)
                  + #9 + InternationalFloatToStr(DeltaY);
                Contour.MakeDefaultHeading;
              end;

            end;
            for ValueIndex := 0 to Values.Count - 1 do
            begin
              Values[ValueIndex] := kNA;
            end;

//            for DataSetIndex := 1 to dgFields.RowCount - 1 do
            for DataSetIndex := 1 to ValidFields.Count do
            begin
              if dgFields.Checked[1, DataSetIndex] then
              begin
                DataSetName := dgFields.Cells[0, DataSetIndex];
                FieldType := FieldTypes[DataSetIndex - 1];

                case FieldType of
                  rcf2Integer:
                    begin
                      if rbInformationLayer.Checked
                        and rbExistingLayer.Checked
                        and (InfoLayerParamNames.Count > 0) then
                      begin
                        ValueIndex := InfoLayerParamNames.
                          IndexOf(dgFields.Cells[2, DataSetIndex]);
                        Values[ValueIndex] := IntToStr(
                          ShapeDataBase.GetFieldInt(DataSetName))
                      end
                      else
                      begin
                        Values[DataSetIndex - 1] := IntToStr(
                          ShapeDataBase.GetFieldInt(DataSetName))
                      end;
                    end;
                  rcf2Real:
                    begin
                      if rbInformationLayer.Checked
                        and rbExistingLayer.Checked
                        and (InfoLayerParamNames.Count > 0) then
                      begin
                        ValueIndex := InfoLayerParamNames.
                          IndexOf(dgFields.Cells[2, DataSetIndex]);
                        Values[ValueIndex] := InternationalFloatToStr(
                          ShapeDataBase.GetFieldNum(DataSetName))
                      end
                      else
                      begin
                        // Mar 3, 2014
                        // TXBase.GetFieldNum changed to support
                        // records with length >= 256.
                        Values[DataSetIndex - 1] := InternationalFloatToStr(
                          ShapeDataBase.GetFieldNum(DataSetName))
                      end;
                    end;
                  rcf2Boolean:
                    begin
                      Value :=
                        ShapeDataBase.GetFieldStr(DataSetName);
                      if (Value = 'Y') or (Value = 'y')
                        or (Value = 'T') or (Value = 't') then
                      begin
                        if rbInformationLayer.Checked
                          and rbExistingLayer.Checked
                          and (InfoLayerParamNames.Count > 0) then
                        begin
                          ValueIndex := InfoLayerParamNames.
                            IndexOf(dgFields.Cells[2, DataSetIndex]);
                          Values[ValueIndex] := 'True';
                        end
                        else
                        begin
                          Values[DataSetIndex - 1] := 'True';
                        end;
                      end
                      else
                      begin
                        if rbInformationLayer.Checked
                          and rbExistingLayer.Checked
                          and (InfoLayerParamNames.Count > 0) then
                        begin
                          ValueIndex := InfoLayerParamNames.
                            IndexOf(dgFields.Cells[2, DataSetIndex]);
                          Values[ValueIndex] := 'False';
                        end
                        else
                        begin
                          Values[DataSetIndex - 1] := 'False';
                        end;
                      end;
                    end;
                  rcf2String:
                    begin
                      if rbInformationLayer.Checked
                        and rbExistingLayer.Checked
                        and (InfoLayerParamNames.Count > 0) then
                      begin
                        ValueIndex := InfoLayerParamNames.
                          IndexOf(dgFields.Cells[2, DataSetIndex]);
                        Values[ValueIndex] := '"'
                          + Trim(ShapeDataBase.GetFieldStr(DataSetName)) + '"';
                      end
                      else
                      begin
                        Values[DataSetIndex - 1] := '"'
                          + ShapeDataBase.GetFieldStr(DataSetName) + '"';
                      end;
                    end;
                else
                  Assert(False);
                end;
              end;
            end;
            for ValueIndex := Values.Count - 1 downto 0 do
            begin
              if Values[ValueIndex] = kNa then
              begin
                Values.Delete(ValueIndex);
              end
              else
              begin
                if not rbNewLayer.Checked then
                begin
                  break;
                end;
              end;
            end;

            for ValueIndex := 0 to Values.Count - 1 do
            begin
              Contour.Value := Contour.Value + Values[ValueIndex] + #9;
            end;

            if (Length(Contour.Value) > 0)
              and (Contour.Value[Length(Contour.Value)] = #9) then
            begin
              SetLength(Contour.Value, Length(Contour.Value) - 1);
            end;
            Contour.MakeDefaultHeading;

          except
            begin
              ContourList.Remove(Contour);
              Contour.Free;
            end;
          end;
        end;
        ShapeDataBase.GotoNext;
        frmExportProgress.ProgressBar1.StepIt;
        Application.ProcessMessages;
      end;
    finally
      frmExportProgress.Free;
      Enabled := True;
    end;
    Application.ProcessMessages;

    if rbNewLayer.Checked then
    begin
      LayerHandle := CreateNewLayer;
    end
    else if rbExistingLayer.Checked then
    begin
      Project := TProjectOptions.Create;
      try
        LayerHandle := Project.GetLayerByName(CurrentModelHandle,
          comboExistingLayer.Text);

        if ClearLayer then
        begin
          ANE_LayerClear(CurrentModelHandle, LayerHandle, False);
        end;
        if rbInformationLayer.Checked then
        begin
          Layer := TLayerOptions.Create(LayerHandle);
          try
            Layer.AllowIntersection[CurrentModelHandle] := True;
          finally
            Layer.Free(CurrentModelHandle);
          end;
        end;
      finally
        Project.Free;
      end;
    end
    else
    begin
      LayerHandle := nil;
      Assert(False);
    end;

    frmExportProgress := TfrmExportProgress.Create(nil);
    Enabled := False;
    try
      frmExportProgress.Caption := 'Importing Shapes';
      MaxContoursToWrite := Max(ContourList.Count div 20, 500);
      MaxContoursToWrite := Min(MaxContoursToWrite, 50000);
      frmExportProgress.ProgressBar1.Max := (ContourList.Count div MaxContoursToWrite) + 1;
      frmExportProgress.Show;
      while ContourList.Count > 0 do
      begin
        ContourString := WriteContours(MaxContoursToWrite);
        ANE_ImportTextToLayerByHandle(CurrentModelHandle, LayerHandle,
          PChar(ContourString));
        frmExportProgress.ProgressBar1.StepIt;
        frmExportProgress.SetFocus;
        Application.ProcessMessages;
      end;
    finally
      frmExportProgress.Free;
      Enabled := True;
    end;
    Application.ProcessMessages;


  finally
    Values.Free;
  end;
end;

procedure TfrmImportShape.SetData;
begin
  Screen.Cursor := crHourGlass;
  try
    Hide;
    if rbInformationLayer.Checked or rbMapsLayer.Checked then
    begin
      CreateContours;
    end
    else
    begin
      if cbSample.Checked then
      begin
        SampleData;
      end
      else
      begin
        SetDataLayersData;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmImportShape.EnableNext;
var
  ShouldEnable: boolean;
  LayerNames: TStringList;
  Project: TProjectOptions;
  Index: integer;
begin
  ShouldEnable := False;
  case pcMain.ActivePageIndex of
    0:
      begin
        ShouldEnable := (rbDataLayer.Checked or rbInformationLayer.Checked
          or rbMapsLayer.Checked)
          and (rbNewLayer.Checked or rbExistingLayer.Checked);
        if ShouldEnable then
        begin
          if rbNewLayer.Checked then
          begin
            ShouldEnable := edNewLayerName.Text <> '';
            if ShouldEnable then
            begin
              LayerNames := TStringList.Create;
              Project := TProjectOptions.Create;
              try
                Project.LayerNames(CurrentModelHandle,
                  [pieAnyLayer], LayerNames);
                LayerNames.Text := LowerCase(LayerNames.Text);
                ShouldEnable := LayerNames.IndexOf(
                  LowerCase(FixArgusName(edNewLayerName.Text))) < 0;
                if not ShouldEnable then
                begin
                  lblError.Caption := 'Error: this layer already exists.';
                end;
              finally
                LayerNames.Free;
                Project.Free;
              end;
            end
            else
            begin
              lblError.Caption := 'Specify a layer name';
            end;
          end
          else
          begin
            ShouldEnable := comboExistingLayer.ItemIndex >= 0;
          end;
        end;
      end;
    1:
      begin
        ShouldEnable := True;
      end;
    2:
      begin
        ShouldEnable := not cbSample.Checked or (comboLayerName.ItemIndex >= 0);
      end;
    3:
      begin
//        for Index := 1 to dgFields.RowCount - 1 do
        for Index := 1 to ValidFields.Count do
        begin
          if dgFields.Checked[1, Index] then
          begin
            ShouldEnable := True;
            break;
          end;
        end;
      end;
  else
    Assert(False);
  end;
  lblError.Visible := not ShouldEnable and rbNewLayer.Checked;
  btnNext.Enabled := ShouldEnable;
end;

procedure TfrmImportShape.GetFields;
var
  OkTypes: set of TFieldType;
  FilesOK: boolean;
  Index: integer;
  Layer: TLayerOptions;
  ParamIndex: ANE_INT32;
  Param: TParameterOptions;
  ParamType: TPIENumberType;
  ParamCount: integer;
begin
  FilesOK := False;
  frmExportProgress:= TfrmExportProgress.Create(nil);
  try
    frmExportProgress.CurrentModelHandle := CurrentModelHandle;
    if GeometryFile = nil then
    begin
      GeometryFile := TShapeGeometryFile.Create;
      frmExportProgress.Caption := 'Reading Shapefile';
      frmExportProgress.ProgressBar1.Max := 1000;
      frmExportProgress.ProgressBar1.Position := 0;
      frmExportProgress.Show;
      try
        Enabled := False;
        GeometryFile.OnProgress := UpDateProgressBar;
        GeometryFile.ReadFromFile(GeometryFileName, ShapeIndexFileName);
      finally
        frmExportProgress.Hide;
        Enabled := True;
      end;
    end;
    if (DataBaseFileName <> '') then
    begin
      if rbDataLayer.Checked then
      begin
        OkTypes := [xbfNumber];
      end
      else if rbInformationLayer.Checked or rbMapsLayer.Checked then
      begin
        OkTypes := [xbfChar, xbfNumber, xbfLogic];
        if rbInformationLayer.Checked and rbExistingLayer.Checked then
        begin
          OkTypes := [];
          Layer := TLayerOptions.CreateWithName(comboExistingLayer.Text,
            CurrentModelHandle);
          try
            ParamCount := Layer.NumParameters(CurrentModelHandle,
              pieContourLayerSubParam);
            InfoLayerParamNames.Clear;
            InfoLayerParamNames.Capacity := ParamCount;
            SetLength(ParamTypes, ParamCount);
            for ParamIndex := 0 to ParamCount - 1 do
            begin
              Param := TParameterOptions.Create(Layer.LayerHandle, ParamIndex);
              try
                InfoLayerParamNames.Add(Param.Name[CurrentModelHandle]);
                ParamType := Param.NumberType[CurrentModelHandle];
                ParamTypes[ParamIndex] := ParamType;
                case ParamType of
                  pnBoolean:
                    begin
                      OkTypes := OkTypes + [xbfLogic];
                    end;
                  pnInteger, pnFloat:
                    begin
                      OkTypes := OkTypes + [xbfNumber];
                    end;
                  pnString:
                    begin
                      OkTypes := OkTypes + [xbfChar];
                    end;
                else
                  Assert(False);
                end;
              finally
                Param.Free;
              end;
            end;
          finally
            Layer.Free(CurrentModelHandle);
          end;
        end;
      end
      else
      begin
        Assert(False);
      end;

      ShapeDataBase.FileName := DataBaseFileName;
      ShapeDataBase.Active := True;
      ShapeDataBase.GotoBOF;
      for Index := 1 to ShapeDataBase.FieldCount do
      begin
        if ShapeDataBase.GetFieldType(Index)
          in OkTypes then
        begin
          ValidIndicies.Add(Index);
          ValidFields.Add(ShapeDataBase.GetFieldName(Index))
        end;
      end;
      if (ValidFields.Count = 0) and (MessageDlg('None of the fields in "'
        + DataBaseFileName
        + '" can be imported.  Do you want to just import the geometry '
        + 'of the shapes in the Shapefile',
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then
      begin
        Close;
        Exit;
      end;
      SetLength(FieldTypes, ValidIndicies.Count);
      for Index := 0 to ValidIndicies.Count - 1 do
      begin
        case ShapeDataBase.GetFieldType(ValidIndicies[Index]) of
          xbfChar:
            begin
              FieldTypes[Index] := rcf2String;
            end;
          xbfNumber:
            begin
              if (ShapeDataBase.GetFieldDecimals(ValidIndicies[Index]) = 0)
                and rbInformationLayer.Checked then
              begin
                FieldTypes[Index] := rcf2Integer;
              end
              else
              begin
                FieldTypes[Index] := rcf2Real;
              end;
            end;
          xbfLogic:
            begin
              FieldTypes[Index] := rcf2Boolean;
            end;
        else
          Assert(False);
        end;
      end;
      if ValidFields.Count > 0 then
      begin
        dgFields.RowCount := ValidFields.Count + 1;
        dgFields.Enabled := True;
        btnAll.Enabled := True;
        btnNone.Enabled := True;
        btnToggle.Enabled := True;
        dgFields.ColorSelectedRow := True;
        dgFields.Color := clWindow;
      end
      else
      begin
        dgFields.RowCount := 2;
        dgFields.Enabled := False;
        btnAll.Enabled := False;
        btnNone.Enabled := False;
        btnToggle.Enabled := False;
        dgFields.ColorSelectedRow := False;
        dgFields.Color := clBtnFace;
      end;

      for Index := 0 to ValidFields.Count - 1 do
      begin
        dgFields.Cells[0, Index + 1] := ValidFields[Index];
      end;
      FilesOK := True;
    end
    else
    begin
      if rbMapsLayer.Checked then
      begin
        FilesOK := True;
      end;
    end;
//    if dgFields.RowCount > 1 then
    {if dgFields.RowCount > 1 then
    begin
      dgFields.FixedRows := 1;
    end; }

  finally
    frmExportProgress.Free;
    if not FilesOK then
    begin
      Close;
    end;
  end;
end;

function TfrmImportShape.CreateNewLayer: ANE_PTR;
var
  NewLayer: T_ANE_MapsLayer;
  NewDataOrMapsLayer: T_ANE_InfoLayer;
  LayerTemplate: string;
  ParamType: TRbwColumnFormat2;
  ParamIndex: integer;
  ParamName: string;
  AParam: T_ANE_NamedLayerParam;
  Layer: TLayerOptions;
  ParamPresent: boolean;
begin
  if rbDataLayer.Checked then
  begin
    NewDataOrMapsLayer := T_ANE_NamedDataLayer.Create(
      edNewLayerName.Text, nil, -1);
    try
      NewDataOrMapsLayer.Lock := [];
      NewDataOrMapsLayer.Interp := leQT_Nearest;
      LayerTemplate := NewDataOrMapsLayer.WriteLayer(CurrentModelHandle);
      result := ANE_LayerAddByTemplate(CurrentModelHandle,
        PChar(LayerTemplate), nil);
    finally
      NewDataOrMapsLayer.Free;
    end;
  end
  else if rbInformationLayer.Checked then
  begin
    NewDataOrMapsLayer := T_ANE_NamedInfoLayer.Create(
      edNewLayerName.Text, nil, -1);
    try
      NewDataOrMapsLayer.Lock := [];
      NewDataOrMapsLayer.Visible := False;
      ParamPresent := False;
//      for ParamIndex := 1 to dgFields.RowCount - 1 do
      for ParamIndex := 1 to ValidFields.Count do
      begin
        if dgFields.Checked[1, ParamIndex] then
        begin
          ParamPresent := True;
          ParamName := dgFields.Cells[0, ParamIndex];
          AParam := T_ANE_NamedLayerParam.Create(ParamName,
            NewDataOrMapsLayer.ParamList, -1);
          AParam.Lock := [];
          ParamType := FieldTypes[ParamIndex - 1];
          case ParamType of
            rcf2Real:
              begin
                AParam.ValueType := pvReal;
              end;
            rcf2Integer:
              begin
                AParam.ValueType := pvInteger;
              end;
            rcf2Boolean:
              begin
                AParam.ValueType := pvBoolean;
              end;
            rcf2String:
              begin
                AParam.ValueType := pvString;
              end;
          else
            Assert(False);
          end;

        end;
      end;
      if cbImportXY.Checked then
      begin
        ParamPresent := True;

        ParamName := 'Delta_X';
        AParam := T_ANE_NamedLayerParam.Create(ParamName,
          NewDataOrMapsLayer.ParamList, -1);
        AParam.Lock := [];
        AParam.ValueType := pvReal;

        ParamName := 'Delta_Y';
        AParam := T_ANE_NamedLayerParam.Create(ParamName,
          NewDataOrMapsLayer.ParamList, -1);
        AParam.Lock := [];
        AParam.ValueType := pvReal;
      end;


      if not ParamPresent then
      begin
        ParamName := edNewLayerName.Text;
        AParam := T_ANE_NamedLayerParam.Create(ParamName,
          NewDataOrMapsLayer.ParamList, -1);
        AParam.Lock := [];
        AParam.ValueType := pvReal;
      end;

      LayerTemplate := NewDataOrMapsLayer.WriteLayer(CurrentModelHandle);
      result := ANE_LayerAddByTemplate(CurrentModelHandle,
        PChar(LayerTemplate), nil);
      //ANE_ProcessEvents(CurrentModelHandle);

      Layer := TLayerOptions.Create(result);
      try
        Layer.AllowIntersection[CurrentModelHandle] := True;
      finally
        Layer.Free(CurrentModelHandle);
      end;

    finally
      NewDataOrMapsLayer.Free;
    end;
  end
  else if rbMapsLayer.Checked then
  begin
    NewLayer := T_ANE_NamedMapLayer.Create(
      edNewLayerName.Text, nil, -1);
    try
      NewLayer.Lock := [];
      LayerTemplate := NewLayer.WriteLayer(CurrentModelHandle);
      result := ANE_LayerAddByTemplate(CurrentModelHandle,
        PChar(LayerTemplate), nil);
    finally
      NewLayer.Free;
    end;
  end
  else
  begin
    result := nil;
    Assert(False);
  end;
end;

procedure TfrmImportShape.SampleData;
var
  IsGridLayer: boolean;
  LayerName: string;
  IsBlockCentered: boolean;
  Parameters: TVDoubleArray;
  CentralMeridian: double;
  CentralMeridianDegrees: double;
  ParameterNames: TStringList;
  Index: integer;
  PointCount: integer;
  XList, YLIst: TRealList;
  ValueIndex: integer;
  PointIndex: integer;
  ShapeObject: TShapeObject;
  ShapeIndex: integer;
  X, Y: double;
  Block: TBlock;
  Node: TNode;
  Element: TElement;
  LocationCount: integer;
  posX: PDoubleArray;
  posY: PDoubleArray;
  dataParameters: pMatrix;
  paramNames: PParamNamesArray;
  NameIndex: integer;
  AName: string;
  LayerHandle: ANE_PTR;
  Project: TProjectOptions;
  ParameterIndex: integer;
begin
  Assert(cbSample.Checked);
  IsGridLayer := pcSample.ActivePage = tabGrid;
  LayerName := comboLayerName.Text;
  IsBlockCentered := rgGridType.ItemIndex = 0;
  if IsGridLayer then
  begin
    if IsBlockCentered then
    begin
      GetBlockCenteredGrid(LayerName);
    end
    else
    begin
      GetNodeCenteredGrid(LayerName);
    end;
  end
  else
  begin
    Assert(pcSample.ActivePage = tabMesh);
    GetMeshWithName(LayerName);
  end;
  if BlockList <> nil then
  begin
    MeshImportChoice := micNone;
    GridImportChoice := TGridImportChoice(rgGrid.ItemIndex + 1);
  end
  else
  begin
    GridImportChoice := gicNone;
    MeshImportChoice := TMeshImportChoice(rgMesh.ItemIndex + 1);
  end;
  CentralMeridian := 0;
  CentralMeridianDegrees := 0;
  if cbCoordinateConversion.Checked then
  begin
    CentralMeridianDegrees := seZoneNumber.Value * 6 - 183;
    CentralMeridian := CentralMeridianDegrees / 180 * Pi;
  end;
  ResetData;
  ParameterNames := TStringList.Create;
  try
//    for Index := 1 to dgFields.RowCount - 1 do
    for Index := 1 to ValidFields.Count do
    begin
      if dgFields.Checked[1, Index] then
      begin
        ParameterNames.Add(dgFields.Cells[0, Index]);
      end;

    end;
    if ParameterNames.Count = 0 then
    begin
      Beep;
      MessageDlg('No fields have been selected', mtError, [mbOK], 0);
      Exit;
    end;

    PointCount := 0;

    SetLength(Parameters, ParameterNames.Count);

    frmExportProgress := TfrmExportProgress.Create(nil);
    Enabled := False;
    try
      frmExportProgress.Caption := 'Processing Shapes';
      frmExportProgress.ProgressBar1.Max := GeometryFile.Count;
      frmExportProgress.Show;
      for ShapeIndex := 0 to GeometryFile.Count - 1 do
      begin
        ShapeObject := GeometryFile[ShapeIndex];

        for ValueIndex := 0 to ParameterNames.Count - 1 do
        begin
          Parameters[ValueIndex] :=
            ShapeDataBase.GetFieldNum(ParameterNames[ValueIndex]);
        end;

        for PointIndex := 0 to ShapeObject.NumPoints - 1 do
        begin
          if cbCoordinateConversion.Checked then
          begin
            X := ShapeObject.Points[PointIndex].X;
            Y := ShapeObject.Points[PointIndex].Y;
            if X > CentralMeridianDegrees + 180 then
            begin
              X := X - 360;
            end
            else if X < CentralMeridianDegrees - 180 then
            begin
              X := X + 360;
            end;
            ConvertToUTM(Y / 180 * Pi, X / 180 * Pi,
              CentralMeridian, X, Y);
          end
          else
          begin
            X := ShapeObject.Points[PointIndex].X;
            Y := ShapeObject.Points[PointIndex].Y;
          end;
          SetValues(Parameters, X, Y);
        end;
        ShapeDataBase.GotoNext;
        frmExportProgress.ProgressBar1.StepIt;
        Application.ProcessMessages;
      end;
    finally
      frmExportProgress.Free;
      Enabled := True;
    end;
    LocationCount := 0;
    if BlockList <> nil then
    begin
      for Index := 0 to BlockList.Count - 1 do
      begin
        Block := BlockList[Index] as TBlock;
        if Block.Count <> 0 then
        begin
          Inc(LocationCount);
        end;
      end;
    end
    else if NodeList <> nil then
    begin
      case MeshImportChoice of
        micClosestNode, micAverageNode, micHighestNode, micLowestNode:
          begin
            for Index := 0 to NodeList.Count - 1 do
            begin
              Node := NodeList[Index] as TNode;
              if Node.Count <> 0 then
              begin
                Inc(LocationCount);
              end;
            end;
          end;
        micClosestElement, micAverageElement, micHighestElement,
          micLowestElement:
          begin
            for Index := 0 to ElementList.Count - 1 do
            begin
              Element := ElementList[Index] as TElement;
              if Element.Count <> 0 then
              begin
                Inc(LocationCount);
              end;
            end;
          end;
      end;
    end;

    if LocationCount > 0 then
    begin
      // allocate memory for arrays to be passed to Argus ONE.
      GetMem(posX, LocationCount * SizeOf(ANE_DOUBLE));
      GetMem(posY, LocationCount * SizeOf(ANE_DOUBLE));
      GetMem(dataParameters, ParameterNames.Count * SizeOf(pMatrix));
      GetMem(paramNames, ParameterNames.Count * SizeOf(ANE_STR));
      try
        for Index := 0 to ParameterNames.Count - 1 do
        begin
          GetMem(dataParameters[Index], LocationCount * SizeOf(ANE_DOUBLE));
        end;

        // Fill name array.
        for NameIndex := 0 to ParameterNames.Count - 1 do
        begin
          assert(NameIndex < ParameterNames.Count);
          AName := ParameterNames[NameIndex];
          GetMem(paramNames^[NameIndex], (Length(AName) + 1));
          StrPCopy(paramNames^[NameIndex], AName);
        end;

        LocationCount := 0;
        if BlockList <> nil then
        begin
          for Index := 0 to BlockList.Count - 1 do
          begin
            Block := BlockList[Index] as TBlock;
            if Block.Count <> 0 then
            begin
              posX^[LocationCount] := Block.X;
              posY^[LocationCount] := Block.Y;
              for ParameterIndex := 0 to ParameterNames.Count -1 do
              begin
                dataParameters[ParameterIndex]^[LocationCount] :=
                  Block.Values[ParameterIndex];
              end;
              Inc(LocationCount);
            end;
          end;
        end
        else if NodeList <> nil then
        begin
          case MeshImportChoice of
            micClosestNode, micAverageNode, micHighestNode, micLowestNode:
              begin
                for Index := 0 to NodeList.Count - 1 do
                begin
                  Node := NodeList[Index] as TNode;
                  if Node.Count <> 0 then
                  begin
                    posX^[LocationCount] := Node.X;
                    posY^[LocationCount] := Node.Y;
                    for ParameterIndex := 0 to ParameterNames.Count -1 do
                    begin
                      dataParameters[ParameterIndex]^[LocationCount] :=
                        Node.Values[ParameterIndex];
                    end;
                    Inc(LocationCount);
                  end;
                end;
              end;
            micClosestElement, micAverageElement, micHighestElement,
              micLowestElement:
              begin
                for Index := 0 to ElementList.Count - 1 do
                begin
                  Element := ElementList[Index] as TElement;
                  if Element.Count <> 0 then
                  begin
                    posX^[LocationCount] := Element.X;
                    posY^[LocationCount] := Element.Y;
                    for ParameterIndex := 0 to ParameterNames.Count -1 do
                    begin
                      dataParameters[ParameterIndex]^[LocationCount] :=
                        Element.Values[ParameterIndex];
                    end;
                    Inc(LocationCount);
                  end;
                end;
              end;
          end;
        end;

        if rbNewLayer.Checked then
        begin
          LayerHandle := CreateNewLayer;
        end
        else if rbExistingLayer.Checked then
        begin
          Project := TProjectOptions.Create;
          try
            LayerHandle := Project.GetLayerByName(CurrentModelHandle,
              comboExistingLayer.Text);
          finally
            Project.Free;
          end;
        end
        else
        begin
          LayerHandle := nil;
          Assert(False);
        end;

        ANE_DataLayerSetData(CurrentModelHandle,
          LayerHandle,
          LocationCount, // :	  ANE_INT32   ;
          @posX^, //:		  ANE_DOUBLE_PTR  ;
          @posY^, // :	    ANE_DOUBLE_PTR   ;
          ParameterNames.Count, // : ANE_INT32     ;
          @dataParameters^, // : ANE_DOUBLE_PTR_PTR  ;
          @paramNames^);

      finally
        begin
          // free memory of arrays passed to Argus ONE.
          for Index := ParameterNames.Count - 1 downto 0 do
          begin
            assert(Index < ParameterNames.Count);
            FreeMem(dataParameters[Index]);
            FreeMem(paramNames^[Index]);
          end;
          FreeMem(dataParameters);
          FreeMem(posY);
          FreeMem(posX);
          FreeMem(paramNames);
        end;
      end;
    end;
  finally
    ParameterNames.Free;
  end;
end;

procedure TfrmImportShape.SetDataLayersData;
var
  Values: pMatrix;
  PosX, PosY: PDoubleArray;
  Names: PParamNamesArray;
  NameIndex, ValueIndex: integer;
  AName: string;
  PointCount: integer;
  ShapeObject: TShapeObject;
  Index: integer;
  ParameterNames: TStringList;
  ShapeIndex: integer;
  PointIndex: integer;
  LocationIndex: integer;
  CurrentValues: array of double;
  LayerHandle: ANE_PTR;
  Project: TProjectOptions;
  CentralMeridian: double;
  X, Y: double;
  CentralMeridianDegrees: double;
  PriorX, PriorY, PostX, PostY: double;
  DeltaX, DeltaY, TotalLength: double;
  procedure RetrieveXY(Index: integer; out X, Y: double);
  begin
    if cbCoordinateConversion.Checked then
    begin
      X := ShapeObject.Points[Index].X;
      Y := ShapeObject.Points[Index].Y;
      if X > CentralMeridianDegrees + 180 then
      begin
        X := X - 360;
      end
      else if X < CentralMeridianDegrees - 180 then
      begin
        X := X + 360;
      end;
      ConvertToUTM(Y / 180 * Pi, X / 180 * Pi,
        CentralMeridian, X, Y);
    end
    else
    begin
      X := ShapeObject.Points[Index].X;
      Y := ShapeObject.Points[Index].Y;
    end;
  end;
begin
  inherited;
  CentralMeridian := 0;
  CentralMeridianDegrees := 0;
  if cbCoordinateConversion.Checked then
  begin
    CentralMeridianDegrees := seZoneNumber.Value * 6 - 183;
    CentralMeridian := CentralMeridianDegrees / 180 * Pi;
  end;
  ParameterNames := TStringList.Create;
  try
//    for Index := 1 to dgFields.RowCount - 1 do
    for Index := 1 to ValidFields.Count do
    begin
      if dgFields.Checked[1, Index] then
      begin
        ParameterNames.Add(dgFields.Cells[0, Index]);
      end;

    end;
    if cbImportXY.Checked then
    begin
      ParameterNames.Add('Delta_X');
      ParameterNames.Add('Delta_Y');
    end;

    if ParameterNames.Count = 0 then
    begin
      Beep;
      MessageDlg('No fields have been selected', mtError, [mbOK], 0);
      Exit;
    end;

    PointCount := 0;
    for Index := 0 to GeometryFile.Count - 1 do
    begin
      ShapeObject := GeometryFile[Index];
      PointCount := PointCount + ShapeObject.NumPoints;
    end;
    posX := nil;
    posY := nil;
    Values := nil;
    Names := nil;
    try
      SetLength(CurrentValues, ParameterNames.Count);
      GetMem(posX, PointCount * SizeOf(double));
      GetMem(posY, PointCount * SizeOf(double));
      GetMem(Values, ParameterNames.Count * SizeOf(pMatrix));
      GetMem(Names, ParameterNames.Count * SizeOf(ANE_STR));
      try
        for NameIndex := 0 to ParameterNames.Count - 1 do
        begin
          Values^[NameIndex] := nil;
        end;

        for NameIndex := 0 to ParameterNames.Count - 1 do
        begin
          GetMem(Values[NameIndex], PointCount * SizeOf(DOUBLE));
        end;

        for NameIndex := 0 to ParameterNames.Count - 1 do
        begin
          AName := ParameterNames[NameIndex];
          GetMem(Names^[NameIndex], (Length(AName) + 1));
          StrPCopy(Names^[NameIndex], AName);
        end;

        LocationIndex := -1;
        frmExportProgress := TfrmExportProgress.Create(nil);
        Enabled := False;
        try
          frmExportProgress.Caption := 'Processing Shapes';
          frmExportProgress.ProgressBar1.Max := GeometryFile.Count;
          frmExportProgress.Show;

          for ShapeIndex := 0 to GeometryFile.Count - 1 do
          begin
            ShapeObject := GeometryFile[ShapeIndex];

            if not cbImportXY.Checked then
            begin
              for ValueIndex := 0 to ParameterNames.Count - 1 do
              begin
                CurrentValues[ValueIndex] :=
                  ShapeDataBase.GetFieldNum(ParameterNames[ValueIndex]);
              end;
            end;


            for PointIndex := 0 to ShapeObject.NumPoints - 1 do
            begin
              if cbImportXY.Checked then
              begin
                if PointIndex > 0 then
                begin
                  RetrieveXY(PointIndex-1,PriorX,PriorY);
                end
                else
                begin
                  RetrieveXY(PointIndex,PriorX,PriorY);
                end;
                if PointIndex < ShapeObject.NumPoints - 1 then
                begin
                  RetrieveXY(PointIndex+1,PostX,PostY);
                end
                else
                begin
                  RetrieveXY(PointIndex,PostX,PostY);
                end;
                DeltaX := PostX-PriorX;
                DeltaY := PostY-PriorY;
                TotalLength := Sqrt(Sqr(DeltaX) + Sqr(DeltaY));
                if TotalLength > 0 then
                begin
                  DeltaX := DeltaX/TotalLength;
                  DeltaY := DeltaY/TotalLength;
                end;
                CurrentValues[0] := DeltaX;
                CurrentValues[1] := DeltaY;
              end;

              Inc(LocationIndex);
              RetrieveXY(PointIndex,X,Y);
              PosX^[LocationIndex] := X;
              PosY^[LocationIndex] := Y;
              for ValueIndex := 0 to ParameterNames.Count - 1 do
              begin
                Values[ValueIndex]^[LocationIndex] := CurrentValues[ValueIndex];
              end;

            end;
            ShapeDataBase.GotoNext;
            frmExportProgress.ProgressBar1.StepIt;
            Application.ProcessMessages;
          end;
        finally
          frmExportProgress.Free;
          Enabled := True;
        end;
        Application.ProcessMessages;

        if rbNewLayer.Checked then
        begin
          LayerHandle := CreateNewLayer;
        end
        else if rbExistingLayer.Checked then
        begin
          Project := TProjectOptions.Create;
          try
            LayerHandle := Project.GetLayerByName(CurrentModelHandle,
              comboExistingLayer.Text);
          finally
            Project.Free;
          end;
        end
        else
        begin
          LayerHandle := nil;
          Assert(False);
        end;

        ANE_DataLayerSetData(CurrentModelHandle,
          LayerHandle,
          PointCount,
          @PosX^,
          @PosY^,
          ParameterNames.Count,
          @Values^,
          @Names^);

      finally
        for NameIndex := ParameterNames.Count - 1 downto 0 do
        begin
          FreeMem(Values[NameIndex]);
          FreeMem(Names^[NameIndex]);
        end;
      end;
    finally
      FreeMem(posY);
      FreeMem(posX);
      FreeMem(Values);
      FreeMem(Names);
    end;
  finally
    ParameterNames.Free;
  end;
  Beep;
  MessageDlg('It is possible that some data points are outside the visible '
    + 'area of the model.  To see them, you may need to resize your model.  '
    + 'One easy way to do this is to select the "Special|Scale to Fit" menu '
    + 'item.',
    mtInformation, [mbOK], 0);
end;

procedure TfrmImportShape.GetLayerParameters(const Row: integer);
var
  Names: TStringList;
  Index: integer;
  FieldType: TRbwColumnFormat2;
begin
  if csCustomPaint in dgFields.ControlState then Exit;
  if rbExistingLayer.Checked and rbInformationLayer.Checked then
  begin
    FieldType := FieldTypes[Row - 1];
    Names := TStringList.Create;
    try
      for Index := 0 to InfoLayerParamNames.Count - 1 do
      begin
        case FieldType of
          rcf2String:
            begin
              if ParamTypes[Index] = pnString then
              begin
                Names.Add(InfoLayerParamNames[Index]);
              end;
            end;
          rcf2Integer:
            begin
              if ParamTypes[Index] = pnInteger then
              begin
                Names.Add(InfoLayerParamNames[Index]);
              end;
            end;
          rcf2Real:
            begin
              if ParamTypes[Index] in [pnInteger, pnFloat] then
              begin
                Names.Add(InfoLayerParamNames[Index]);
              end;
            end;
          rcf2Boolean:
            begin
              if ParamTypes[Index] = pnBoolean then
              begin
                Names.Add(InfoLayerParamNames[Index]);
              end;
            end;
        else
          Assert(False);
        end;

      end;

      dgFields.Columns[2].PickList := Names;
    finally
      Names.Free;
    end;
  end;
end;

function TfrmImportShape.LatLongToUTM_Zone(
  const LongitudeDegrees, Latitude: double): integer;
begin
  if (Latitude >= 56) and (Latitude <= 64)
    and (LongitudeDegrees >= 0) and (LongitudeDegrees <= 12) then
  begin
    if LongitudeDegrees >= 3 then
    begin
      result := 32
    end
    else
    begin
      result := 31
    end;
  end
  else if (Latitude >= 72) and (Latitude <= 84)
    and (LongitudeDegrees >= 0) and (LongitudeDegrees <= 42) then
  begin
    if LongitudeDegrees <= 9 then
    begin
      result := 31;
    end
    else if LongitudeDegrees <= 21 then
    begin
      result := 33;
    end
    else if LongitudeDegrees <= 33 then
    begin
      result := 35;
    end
    else
    begin
      result := 37;
    end;
  end
  else
  begin
    result := SimpleLongToUTM_Zone(LongitudeDegrees);
  end;
end;

procedure TfrmImportShape.UpDateProgressBar(Sender: TObject;
  FractionDone: double);
begin
  frmExportProgress.ProgressBar1.Position := Round(FractionDone * 1000);
  Application.ProcessMessages;
end;

constructor TfrmImportShape.CreateWithHandle(AOwner: TComponent;
  aneHandle: ANE_PTR);
begin
  CurrentModelHandle := aneHandle;
  Create(AOwner);
end;

{ TImportShapePoint }

constructor TImportShapePoint.Create;
begin
  // don't call inherited;
end;

procedure TImportShapePoint.Draw;
begin
  // do nothing
end;

class function TImportShapePoint.GetZoomBox: TRBWZoomBox;
begin
  result := nil;
end;

procedure TfrmImportShape.GetLayers;
var
  LayerNames: TStringList;
  ProjectOptions: TProjectOptions;
  Index: integer;
  Layer: TLayerOptions;
  ObjectCount: integer;
begin
  LayerNames := TStringList.Create;
  ProjectOptions := TProjectOptions.Create;
  try
    ProjectOptions.LayerNames(CurrentModelHandle,
      [pieTriMeshLayer, pieQuadMeshLayer, pieGridLayer], LayerNames);
    for Index := LayerNames.Count - 1 downto 0 do
    begin
      Layer := TLayerOptions.CreateWithName(LayerNames[Index],
        CurrentModelHandle);
      try
        if Layer.LayerType[CurrentModelHandle] = pieGridLayer then
        begin
          ObjectCount := Layer.NumObjects(CurrentModelHandle, pieBlockObject);
        end
        else
        begin
          ObjectCount := Layer.NumObjects(CurrentModelHandle, pieElementObject);
        end;
        if ObjectCount = 0 then
        begin
          LayerNames.Delete(Index);
        end;
      finally
        Layer.Free(CurrentModelHandle);
      end;
    end;
    comboLayerName.Items := LayerNames;
    if LayerNames.Count > 0 then
    begin
      comboLayerName.ItemIndex := 0;
      comboLayerNameChange(nil);
    end;
  finally
    LayerNames.Free;
    ProjectOptions.Free;
  end;
end;

procedure TfrmImportShape.FormCreate(Sender: TObject);
begin
  inherited;
  Randomize;
  comboEllipsoid.ItemIndex := 2;
  comboEllipsoidChange(nil);
  pcMain.ActivePageIndex := 0;
  ValidFields := TStringList.Create;
  ValidIndicies := TIntegerList.Create;
  InfoLayerParamNames := TStringList.Create;
  GetFileNames;
  dgFields.Cells[0, 0] := 'Field name';
  dgFields.Cells[1, 0] := 'Import';
  dgFields.Cells[2, 0] := 'Parameter name';
  dgFields.RowCount := 2;
  pcMainChange(nil);
end;

procedure TfrmImportShape.btnNextClick(Sender: TObject);
begin
  inherited;
  case pcMain.ActivePageIndex of
    0:
      begin
        GetFields;
        pcMain.ActivePageIndex := 1;
      end;
    1:
      begin
        if rbDataLayer.Checked and (comboLayerName.Items.Count > 0) then
        begin
          pcMain.ActivePageIndex := 2;
        end
        else
        begin
          pcMain.ActivePageIndex := 3;
        end;
      end;
    2:
      begin
        pcMain.ActivePageIndex := 3;
      end;
    3:
      begin
        SetData;
        Close;
      end;
  else
    Assert(False);
  end;
  btnBack.Enabled := pcMain.ActivePageIndex > 0;
  if pcMain.ActivePageIndex = pcMain.PageCount - 1 then
  begin
    btnNext.Caption := 'Finish';
  end
  else
  begin
    btnNext.Caption := 'Next';
  end;
  btnAll.Visible := pcMain.ActivePageIndex = pcMain.PageCount - 1;
  btnNone.Visible := btnAll.Visible;
  btnToggle.Visible := btnAll.Visible;
  pcMainChange(nil);
end;

{ TShapeContour }

procedure TShapeContour.Draw;
begin
  // do nothing.
end;

procedure GImportShapePIE(aneHandle: ANE_PTR; const fileName: ANE_STR;
  layerHandle: ANE_PTR); cdecl;
begin
  frmImportShape := TfrmImportShape.CreateWithHandle(nil, aneHandle);
  try
    frmSample := frmImportShape;
    if frmImportShape.FilesOK then
    begin
//      frmImportShape.CurrentModelHandle := aneHandle;
      frmImportShape.GetLayers;
      frmImportShape.ShowModal;
    end;
  finally
    frmSample := nil;
    frmImportShape.Free;
  end;
end;

procedure TfrmImportShape.rbNewOrExistingLayerClick(Sender: TObject);
begin
  inherited;
  if rbNewLayer.Checked then
  begin
    edNewLayerName.Enabled := True;
    edNewLayerName.Color := clWindow;
    comboExistingLayer.Enabled := False;
    comboExistingLayer.Color := clBtnFace;
  end
  else
  begin
    edNewLayerName.Enabled := False;
    edNewLayerName.Color := clBtnFace;
    comboExistingLayer.Enabled := True;
    comboExistingLayer.Color := clWindow;
    if (comboExistingLayer.Text = '')
      and (comboExistingLayer.Items.Count > 0) then
    begin
      comboExistingLayer.ItemIndex := 0;
    end;
  end;
  EnableNext;
end;

procedure TfrmImportShape.rbLayerTypeClick(Sender: TObject);
var
  Project: TProjectOptions;
  LayerType: TPIELayerTypes;
begin
  inherited;
  if rbDataLayer.Checked then
  begin
    LayerType := [pieDataLayer]
  end
  else if rbInformationLayer.Checked then
  begin
    LayerType := [pieInformationLayer]
  end
  else if rbMapsLayer.Checked then
  begin
    LayerType := [pieMapsLayer]
  end
  else
  begin
    Assert(False);
  end;

  comboExistingLayer.Items.Clear;
  Project := TProjectOptions.Create;
  try
    Project.LayerNames(self.CurrentModelHandle, LayerType,
      comboExistingLayer.Items);
  finally
    Project.Free;
  end;

  comboExistingLayer.ItemIndex := -1;

  EnableNext;
end;

procedure TfrmImportShape.edNewLayerNameChange(Sender: TObject);
begin
  inherited;
  EnableNext;
end;

procedure TfrmImportShape.comboExistingLayerChange(Sender: TObject);
begin
  inherited;
  EnableNext;
end;

procedure TfrmImportShape.FormDestroy(Sender: TObject);
begin
  inherited;
  GeometryFile.Free;
  ValidFields.Free;
  ValidIndicies.Free;
  InfoLayerParamNames.Free;
end;

procedure TfrmImportShape.dgFieldsStateChange(Sender: TObject; ACol,
  ARow: Integer; const Value: TCheckBoxState);
begin
  inherited;
  if (Value = cbChecked) and rbExistingLayer.Checked
    and rbInformationLayer.Checked
    and (dgFields.Cells[2, ARow] = '') then
  begin
    GetLayerParameters(ARow);
    if dgFields.Columns[2].PickList.Count > 0 then
    begin
      dgFields.Cells[2, ARow] := dgFields.Columns[2].PickList[0];
    end
    else
    begin
      dgFields.Checked[ACol, ARow] := False;
      Beep;
      MessageDlg('Sorry. No parameters on this layer match the type of '
        + 'this field.', mtInformation, [mbOK], 0);
    end;
  end;
end;

procedure TfrmImportShape.dgFieldsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  if ACol = 2 then
  begin
    CanSelect := rbInformationLayer.Checked and rbExistingLayer.Checked
      and dgFields.Checked[1, ARow];
    if CanSelect then
    begin
      GetLayerParameters(ARow);
    end
  end;
end;

function TfrmImportShape.SimpleLongToUTM_Zone(const LongitudeDegrees: double):
  integer;
begin
  result := Floor(LongitudeDegrees / 6) + 31;
  if result > 60 then
  begin
    result := result - 60
  end;
end;

procedure TfrmImportShape.cbCoordinateConversionClick(Sender: TObject);
var
  ShapeObject: TShapeObject;
  Index: integer;
  AName: string;
  Shape: TShape;
  Component: TComponent;
  ShapePoint: TShapePoint;
  Point: TPoint;
  Zone: integer;
  Error: boolean;
begin
  inherited;
  Error := False;
  seZoneNumber.Enabled := cbCoordinateConversion.Checked;
  comboEllipsoid.Enabled := cbCoordinateConversion.Checked;
  if comboEllipsoid.Enabled then
  begin
    comboEllipsoid.Color := clWindow;
  end
  else
  begin
    comboEllipsoid.Color := clBtnFace;
  end;

  if cbCoordinateConversion.Checked and (GeometryFile.Count > 0) then
  begin
    ShapeObject := GeometryFile[0];
    if ShapeObject.NumPoints > 0 then
    begin
      lblCoordinates.Caption := 'Coordinates of first point = ('
        + FloatToStr(ShapeObject.Points[0].X) + ', '
        + FloatToStr(ShapeObject.Points[0].Y) + ').';
      Zone := LatLongToUTM_Zone(ShapeObject.Points[0].X,
        ShapeObject.Points[0].Y);
      seZoneNumber.Value := Zone;
    end;

    for Index := 1 to 10 do
    begin
      AName := 'Shape' + IntToStr(Index);
      Component := self.FindComponent(AName);
      Shape := Component as TShape;
      ShapeObject := GeometryFile[Random(GeometryFile.Count)];
      if ShapeObject.NumPoints > 0 then
      begin
        ShapePoint := ShapeObject.Points[0];
        if (ShapePoint.X < -360) or (ShapePoint.X > 360)
          or (ShapePoint.Y > 84) or (ShapePoint.Y < -80) then
        begin
          Shape.Visible := False;
          Error := True;
        end
        else
        begin
          Point := LatLongToPoint(ShapePoint.X, ShapePoint.Y);
          // X is from 29 to 708.
          // Y is from 43 to 382.
          Error := Error or
            (Point.X < 29) or (Point.X > 708) or
            (Point.Y < 43) or (Point.Y > 382);

          Shape.Left := Point.x - (Shape.Width div 2) + Image1.Left;
          Shape.Top := Point.Y - (Shape.Height div 2) + Image1.Top;
          Shape.Visible := True;
        end;
      end
      else
      begin
        Shape.Visible := False;
      end;
    end;
    if Error then
    begin
      Beep;
      MessageDlg('One or more of your data points appear to has invalid '
        + 'coordinates. Coordinate conversion can not be performed on this '
        + 'Shapefile.', mtWarning, [mbOK], 0);
      cbCoordinateConversion.Checked := False;
    end;

  end
  else
  begin
    for Index := 1 to 10 do
    begin
      AName := 'Shape' + IntToStr(Index);
      Component := self.FindComponent(AName);
      Shape := Component as TShape;
      Shape.Visible := False;
    end;
  end;
end;

function TfrmImportShape.LatLongToPoint(Long, Lat: double): TPoint;
begin
  if Long > 180 then
  begin
    Long := Long - 360;
  end
  else if Long < -180 then
  begin
    Long := Long + 360;
  end;
  // X is from 29 to 708.
  result.x := Round((Long + 180) / 360 * (679 - 29) + 29);
  // Y is from 43 to 382
  result.y := Round(((-Lat) + 84) / 164 * (339 - 43) + 43);
end;

procedure TfrmImportShape.Image1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Lat, Long: double;
  Point: TPoint;
  Zone: integer;
  {
29, 339
679, 43
  }
begin
  inherited;
  if (X >= 29) and (X <= 679) and (Y >= 43) and (Y <= 339) then
  begin
    Long := (X - 29) / (679 - 29) * 360 - 180;
    Lat := -((Y - 43) / (339 - 43) * 164 - 84);
    Point := LatLongToPoint(Long, Lat);
    Zone := LatLongToUTM_Zone(Long, Lat);
    StatusBar1.SimpleText := '(X,Y) = ('
      + FloatToStr(Long) + ', ' + FloatToStr(Lat) + '); Zone = '
      + IntToStr(Zone);
  end
  else
  begin
    StatusBar1.SimpleText := '';
  end;

end;

procedure TfrmImportShape.btnBackClick(Sender: TObject);
begin
  inherited;
  case pcMain.ActivePageIndex of
    0:
      begin
      Assert(False);
      end;
    1,2:
      begin
        pcMain.ActivePageIndex := pcMain.ActivePageIndex - 1;
      end;
    3:
      begin
        if rbDataLayer.Checked and (comboLayerName.Items.Count > 0) then
        begin
          pcMain.ActivePageIndex := 2;
        end
        else
        begin
          pcMain.ActivePageIndex := 1;
        end;
      end;
  else
    Assert(False);
  end;


  btnBack.Enabled := pcMain.ActivePageIndex > 0;
  btnNext.Caption := 'Next';
  btnAll.Visible := pcMain.ActivePageIndex = pcMain.PageCount - 1;
  btnNone.Visible := btnAll.Visible;
  btnToggle.Visible := btnAll.Visible;
  pcMainChange(nil);
end;

procedure TfrmImportShape.comboEllipsoidChange(Sender: TObject);
begin
  inherited;
  case comboEllipsoid.ItemIndex of
    0:
      begin
        Ellipsoid := Airy1830;
      end;
    1:
      begin
        Ellipsoid := Bessel1841;
      end;
    2:
      begin
        Ellipsoid := Clarke1866;
      end;
    3:
      begin
        Ellipsoid := Clarke1880;
      end;
    4:
      begin
        Ellipsoid := Everest1830;
      end;
    5:
      begin
        Ellipsoid := Fischer1960;
      end;
    6:
      begin
        Ellipsoid := Fischer1968;
      end;
    7:
      begin
        Ellipsoid := GRS67_1967;
      end;
    8:
      begin
        Ellipsoid := GRS75_1975;
      end;
    9:
      begin
        Ellipsoid := GRS80_1980;
      end;
    10:
      begin
        Ellipsoid := Hough1956;
      end;
    11:
      begin
        Ellipsoid := International1924;
      end;
    12:
      begin
        Ellipsoid := Krassowsky1940;
      end;
    13:
      begin
        Ellipsoid := SouthAmerican1969;
      end;
    14:
      begin
        Ellipsoid := WGS60_1960;
      end;
    15:
      begin
        Ellipsoid := WGS66_1966;
      end;
    16:
      begin
        Ellipsoid := WGS72_1972;
      end;
    17:
      begin
        Ellipsoid := WGS84;
      end;
  else
    Assert(False);
  end;

end;

procedure TfrmImportShape.btnAllClick(Sender: TObject);
var
  Index: integer;
begin
  inherited;
  for Index := 1 to dgFields.RowCount - 1 do
//  for Index := 1 to dgFields.RowCount - 1 do
  begin
    dgFields.Checked[1, Index] := True;
  end;
  dgFields.Invalidate;
end;

procedure TfrmImportShape.btnNoneClick(Sender: TObject);
var
  Index: integer;
begin
  inherited;
//  for Index := 1 to dgFields.RowCount - 1 do
  for Index := 1 to dgFields.RowCount - 1 do
  begin
    dgFields.Checked[1, Index] := False;
  end;
  dgFields.Invalidate;
end;

procedure TfrmImportShape.btnToggleClick(Sender: TObject);
var
  Index: integer;
begin
  inherited;
//  for Index := 1 to dgFields.RowCount - 1 do
  for Index := 1 to dgFields.RowCount - 1 do
  begin
    dgFields.Checked[1, Index] := not dgFields.Checked[1, Index];
  end;
  dgFields.Invalidate;
end;

procedure TfrmImportShape.cbSampleClick(Sender: TObject);
begin
  inherited;
  comboLayerName.Enabled := cbSample.Checked;
  if comboLayerName.Enabled then
  begin
    comboLayerName.Color := clWindow;
    comboLayerNameChange(nil);
  end
  else
  begin
    comboLayerName.Color := clBtnFace;
    pcSample.ActivePageIndex := -1;
  end;
  EnableNext;
end;

procedure TfrmImportShape.comboLayerNameChange(Sender: TObject);
var
  Layer: TLayerOptions;
begin
  inherited;
  if (comboLayerName.ItemIndex >= 0) and comboLayerName.Enabled then
  begin
    Layer := TLayerOptions.CreateWithName(comboLayerName.Text,
      CurrentModelHandle);
    try
      if Layer.LayerType[CurrentModelHandle] = pieGridLayer then
      begin
        pcSample.ActivePage := tabGrid;
      end
      else
      begin
        pcSample.ActivePage := tabMesh;
      end;
    finally
      Layer.Free(CurrentModelHandle);
    end;
  end
  else
  begin
    pcSample.ActivePageIndex := -1;
  end;

  EnableNext;
end;

procedure TfrmImportShape.pcMainChange(Sender: TObject);
begin
  inherited;
  HelpContext := pcMain.ActivePage.HelpContext;
end;

procedure TfrmImportShape.cbImportXYClick(Sender: TObject);
var
  Index: integer;
begin
  inherited;
  dgFields.Enabled := not cbImportXY.Checked;
  if not dgFields.Enabled then
  begin
    for Index := 1 to dgFields.RowCount-1 do
    begin
      dgFields.Checked[1,Index] := False;
    end;
  end;
end;

end.

