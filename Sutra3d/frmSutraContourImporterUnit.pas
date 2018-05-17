unit frmSutraContourImporterUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, ComCtrls, Buttons, ExtCtrls, StringGrid3d, Spin,
  Grids, DataGrid, AnePIE, WriteContourUnit, PointContourUnit, RbwZoomBox,
  ANE_LayerUnit, OptionsUnit, RbwDataGrid4, IntListUnit;

type
  

  T1DIntArray = array of integer;
  T2DIntArray = array of array of integer;

  T1DPIENumberTypeArray = array of TPIENumberType;
  T2DPIENumberTypeArray = array of array of TPIENumberType;

  TImportPoint = class(TArgusPoint)
    constructor Create; override;
    class function GetZoomBox: TRBWZoomBox; override;
    destructor Destroy; override;
  end;

  TfrmSutraContourImporter = class(TfrmWriteContour)
    Panel1: TPanel;
    btnCancel: TBitBtn;
    btnNext: TBitBtn;
    seRowCount: TSpinEdit;
    lblRowCount: TLabel;
    btnReadContours: TButton;
    dg4Contours: TRbwDataGrid4;
    lblInstructions: TLabel;
    comboLayers: TComboBox;
    procedure sg3dUnindexedParametersSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure sg3dUnindexedParametersSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure FormCreate(Sender: TObject); override;
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnReadContoursClick(Sender: TObject);
    procedure dg4ContoursMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure seRowCountChange(Sender: TObject);
    procedure comboLayersChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject); override;
    procedure dg4ContoursSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure dg4ContoursSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  private
    ContourStarts: TIntegerList;
    SingleRowColumns: TIntegerList;
    Layer: T_ANE_InfoLayer;
    procedure AssignColumnLabelsAndTypes;
    procedure CreateContours;
    procedure SetUpParameterArrays(
      const LayerHandle : ANE_PTR;
      var UnIndedexIndexes: T1DIntArray;
      var IndexedIndexes: T2DIntArray;
      var FirstIndexedIndexes: T2DIntArray;
      var SecondIndexedIndexes: T2DIntArray);
    procedure SetUpNumberTypeArrays(const LayerHandle: ANE_PTR;
      var UnIndexedIndexes: T1DPIENumberTypeArray; var IndexedIndexes,
      FirstIndexedIndexes, SecondIndexedIndexes: T2DPIENumberTypeArray);
    procedure ClearContours;
    procedure AssignContourStarts;
    { Private declarations }
  public
    procedure GetData;
    { Public declarations }
  end;

procedure ImportSutraContours(aneHandle: ANE_PTR;
  const fileName: ANE_STR; layerHandle: ANE_PTR); cdecl;

var
  frmSutraContourImporter: TfrmSutraContourImporter;

implementation

uses Clipbrd, UtilityFunctions, frmSutraUnit, SLObservation;

{$R *.DFM}

{ TfrmContourImporter }

procedure TfrmSutraContourImporter.GetData;
  procedure AddClass(LayerClass: T_ANE_LayerClass);
  var
    LayerName: string;
    ALayer: T_ANE_InfoLayer;
  begin
    LayerName := LayerClass.ANE_LayerName;
    ALayer := frmSutra.SutraLayerStructure.UnIndexedLayers.GetLayerByName(LayerName)
      as T_ANE_InfoLayer;
    if ALayer <> nil then
    begin
      comboLayers.Items.AddObject(ALayer.WriteNewRoot, ALayer);
    end;
  end;
begin
  with frmSutra do
  begin
    AddClass(T2dUcodeHeadObservationLayer);
    AddClass(T2dUcodeConcentrationObservationLayer);
    AddClass(T2dUcodeFluxObservationLayer);
    AddClass(T2dUcodeSoluteFluxObservationLayer);
    AddClass(T2dUcodeSaturationObservationLayer);
    if comboLayers.Items.Count > 0 then
    begin
      comboLayers.ItemIndex := 0;
    end;
  end;
end;

procedure TfrmSutraContourImporter.sg3dUnindexedParametersSelectCell(
  Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
  DataGrid: TDataGrid;
  Param: T_ANE_LayerParam;
begin
  inherited;
  DataGrid := Sender as TDataGrid;
  Param := DataGrid.Objects[ACol, ARow] as T_ANE_LayerParam;
  if Param <> nil then
  begin
    if not (Param is TCustomStatFlag) then
    begin
      case Param.ValueType of
        pvString:
          begin
            DataGrid.Columns[ACol].PickList.Clear;
            DataGrid.Columns[ACol].Format := cfString;
            DataGrid.Columns[ACol].LimitToList := False;
          end;
        pvReal, pvInteger:
          begin
            DataGrid.Columns[ACol].PickList.Clear;
            DataGrid.Columns[ACol].Format := cfNumber;
            DataGrid.Columns[ACol].LimitToList := False;
          end;
        pvBoolean:
          begin
            DataGrid.Columns[ACol].PickList.Clear;
            DataGrid.Columns[ACol].PickList.Add('False');
            DataGrid.Columns[ACol].PickList.Add('True');
            DataGrid.Columns[ACol].Format := cfString;
            DataGrid.Columns[ACol].LimitToList := True;
          end;
      else
        Assert(False);
      end;
    end;
  end;
end;

procedure TfrmSutraContourImporter.sg3dUnindexedParametersSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: string);
var
  DataGrid: TDataGrid;
  Param: T_ANE_LayerParam;
  V: integer;
  Code: Integer;
  NewValue: string;
begin
  inherited;
  DataGrid := Sender as TDataGrid;
  Param := DataGrid.Objects[ACol, ARow] as T_ANE_LayerParam;
  if (ACol > 0) and (ARow > 0) and (Param <> nil)
    and (Param.ValueType = pvInteger) and (Value <> '')
    and not DataGrid.Columns[ACol].LimitToList then
  begin
    try
      StrToInt(Value);
    except on EConvertError do
      begin
        Val(Value, V, Code);
        if Code > 1 then
        begin
          NewValue := Copy(Value, 1, Code - 1);
        end
        else
        begin
          NewValue := '';
        end;
        Beep;
        DataGrid.Cells[ACol, ARow] := NewValue;
      end;
    end;
  end;
end;


procedure TfrmSutraContourImporter.AssignColumnLabelsAndTypes;
var
  ParamIndex: integer;
  Param: T_ANE_LayerParam;
  ParamColumn: integer;
  ColCount: integer;
  TimeList: T_ANE_IndexedParameterList;
  ColIndex: integer;
begin
  Layer := nil;
  SingleRowColumns.Clear;
  dg4Contours.RowCount := 2;
  if comboLayers.ItemIndex >= 0 then
  begin
    Layer := comboLayers.Items.Objects[comboLayers.ItemIndex] as T_ANE_InfoLayer;
  end;

  if Layer <> nil then
  begin
    Caption := 'Import SUTRA Contours from Spreadsheet: ' + Layer.WriteNewRoot;

    ColCount := 2 + Layer.ParamList.Count;
    for ColIndex := 2 to ColCount-1 do
    begin
      SingleRowColumns.Add(ColIndex);
    end;

    if Layer.IndexedParamList0.Count > 0 then
    begin
      TimeList := Layer.IndexedParamList0.Items[0];
      ColCount := + ColCount + TimeList.Count;
    end;
    if Layer.IndexedParamList1.Count > 0 then
    begin
      TimeList := Layer.IndexedParamList1.Items[0];
      ColCount := + ColCount + TimeList.Count;
    end;
    if Layer.IndexedParamList2.Count > 0 then
    begin
      TimeList := Layer.IndexedParamList2.Items[0];
      ColCount := + ColCount + TimeList.Count;
    end;
    dg4Contours.ColCount := ColCount;
    for ColIndex := 0 to dg4Contours.ColCount -1 do
    begin
      dg4Contours.Columns[ColIndex].AutoAdjustColWidths := True;
      dg4Contours.Columns[ColIndex].WordWrapCaptions := True;
      dg4Contours.Columns[ColIndex].CaptionAlignment := taCenter;
      dg4Contours.Columns[ColIndex].AutoAdjustRowHeights := True;
      dg4Contours.Columns[ColIndex].ComboUsed := False;
    end;
    dg4Contours.Cells[0,0] := 'X';
    dg4Contours.Cells[1,0] := 'Y';

    ParamColumn := 2;
    for ParamIndex := 0 to Layer.ParamList.Count - 1 do
    begin
      Param := Layer.ParamList.Items[ParamIndex] as T_ANE_LayerParam;
      ParamColumn := ParamIndex + 2;
      dg4Contours.Cells[ParamColumn, 0] := Param.WriteNewName;

      dg4Contours.Columns[ParamColumn].Format := rcf4Real;
      if Param is TCustomStatFlag then
      begin
        dg4Contours.Columns[ParamColumn].Format := rcf4String;
        dg4Contours.Columns[ParamColumn].PickList.Clear;
        dg4Contours.Columns[ParamColumn].PickList.Add('Variance (VAR)');
        dg4Contours.Columns[ParamColumn].PickList.Add('Standard Deviation (SD)');
        dg4Contours.Columns[ParamColumn].PickList.Add('Coefficient of Variation (CV)');
        dg4Contours.Columns[ParamColumn].PickList.Add('Weight (WT)');
        dg4Contours.Columns[ParamColumn].PickList.Add('Square Root of the weight (SQRWT)');
        dg4Contours.Cells[ParamColumn, 1] := 'Standard deviation (1)';
        dg4Contours.Columns[ParamColumn].LimitToList := True;
        dg4Contours.Columns[ParamColumn].ComboUsed := True;
      end
      else if Param is TCombineObs then
      begin
        dg4Contours.Columns[ParamColumn].Format := rcf4String;
        dg4Contours.Columns[ParamColumn].PickList.Clear;
        dg4Contours.Columns[ParamColumn].PickList.Add('None (0)');
        dg4Contours.Columns[ParamColumn].PickList.Add('Sum (1)');
        dg4Contours.Columns[ParamColumn].PickList.Add('Average (2)');
        dg4Contours.Columns[ParamColumn].PickList.Add('Line/Area/Volume Weighted Average (3)');
        dg4Contours.Cells[ParamColumn, 1] := dg4Contours.Columns[ParamColumn].PickList[0];
        dg4Contours.Columns[ParamColumn].LimitToList := True;
        dg4Contours.Columns[ParamColumn].ComboUsed := True;
      end
      else if Param.ValueType = pvBoolean then
      begin
        dg4Contours.Columns[ParamColumn].Format := rcf4Boolean;
      end
      else if Param.ValueType = pvString then
      begin
        dg4Contours.Columns[ParamColumn].Format := rcf4String;
      end
      else
      begin
        dg4Contours.Cells[ParamColumn, 1] := '';
      end;
      dg4Contours.Objects[ParamColumn, 0] := Param;
    end;
    Inc(ParamColumn);
    if Layer.IndexedParamList0.Count > 0 then
    begin
      TimeList := Layer.IndexedParamList0.Items[0];
      for ParamIndex := 0 to TimeList.Count - 1 do
      begin
        Param := TimeList.Items[ParamIndex] as T_ANE_LayerParam;

        with Param do
        begin
          dg4Contours.Cells[ParamIndex + ParamColumn, 0] := WriteSpecialBeginning + WriteName
            + WriteSpecialMiddle + WriteSpecialEnd
            + '[i] (1-' + IntToStr(Layer.IndexedParamList0.Count) + ')';
          dg4Contours.Columns[ParamIndex + ParamColumn].Format := rcf4Real;
        end;
      end;
      ParamColumn := ParamColumn + TimeList.Count;
    end;
    if Layer.IndexedParamList1.Count > 0 then
    begin
      TimeList := Layer.IndexedParamList1.Items[0];
      for ParamIndex := 0 to TimeList.Count - 1 do
      begin
        Param := TimeList.Items[ParamIndex] as T_ANE_LayerParam;

        with Param do
        begin
          dg4Contours.Cells[ParamIndex + ParamColumn, 0] := WriteSpecialBeginning + WriteName
            + WriteSpecialMiddle + WriteSpecialEnd
            + '[i] (1-' + IntToStr(Layer.IndexedParamList1.Count) + ')';
          dg4Contours.Columns[ParamIndex + ParamColumn].Format := rcf4Real;
        end;
      end;
      ParamColumn := ParamColumn + TimeList.Count;
    end;
    if Layer.IndexedParamList2.Count > 0 then
    begin
      TimeList := Layer.IndexedParamList2.Items[0];
      for ParamIndex := 0 to TimeList.Count - 1 do
      begin
        Param := TimeList.Items[ParamIndex] as T_ANE_LayerParam;

        with Param do
        begin
          dg4Contours.Cells[ParamIndex + ParamColumn, 0] := WriteSpecialBeginning + WriteName
            + WriteSpecialMiddle + WriteSpecialEnd
            + '[i] (1-' + IntToStr(Layer.IndexedParamList2.Count) + ')';
          dg4Contours.Columns[ParamIndex + ParamColumn].Format := rcf4Real;
        end;
      end;
    end;
  end;
  for ColIndex := 0 to dg4Contours.ColCount -1 do
  begin
    dg4Contours.Cells[ColIndex,1] := '';
    dg4Contours.Checked[ColIndex,1] := False;
  end;
end;


procedure TfrmSutraContourImporter.FormCreate(Sender: TObject);
//var
//  ParamIndex: integer;
//  Param: T_ANE_LayerParam;
//  ParamColumn: integer;
//  ColCount: integer;
//  TimeList: T_ANE_IndexedParameterList;
//  ColIndex: integer;
begin
  inherited;
  ContourStarts:= TIntegerList.Create;
  SingleRowColumns:= TIntegerList.Create;
  GetData;
  seRowCount.MaxValue := MAXINT;

  seRowCount.Value := 1;
  btnNext.Caption := 'Finish';

  AssignColumnLabelsAndTypes;
  AssignContourStarts;
end;

procedure ImportSutraContours(aneHandle: ANE_PTR;
  const fileName: ANE_STR; layerHandle: ANE_PTR); cdecl;
var
  Layer: T_ANE_InfoLayer;
  LayerOptions: TLayerOptions;
begin
  if EditWindowOpen then
  begin
    // Result := False
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True;
    try // try 1
      begin
        try // try 2
          begin
            frmSutra := TArgusForm.GetFormFromArgus(aneHandle)
              as TfrmSutra;

            Application.CreateForm(TfrmSutraContourImporter,
              frmSutraContourImporter);
            frmSutraContourImporter.CurrentModelHandle := aneHandle;

            try // try 3
              if frmSutraContourImporter.Layer = nil then
              begin
                Beep;
                MessageDlg('Sorry: There are no layers present that can '
                  + 'be used with this command.', mtInformation,
                  [mbOK], 0);
              end
              else
              begin
                if (frmSutraContourImporter.ShowModal = mrOK)
                  and (frmSutraContourImporter.ContourList.Count > 0) then
                begin
                  Layer := frmSutraContourImporter.Layer;
                  LayerOptions := TLayerOptions.Create(Layer.GetLayerHandle(
                    aneHandle));
                  try
                    LayerOptions.Text[aneHandle]
                      := frmSutraContourImporter.WriteContours
                  finally
                    LayerOptions.Free(aneHandle);
                  end;

                end;
              end;

            finally // try 3
              frmSutraContourImporter.Free;
            end; // try 3
          end; // try 2
        except on E: Exception do
          begin
            Beep;
            MessageDlg(E.Message, mtError, [mbOK], 0);
            // result := False;
          end;
        end // try 2
      end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

procedure TfrmSutraContourImporter.ClearContours;
var
  LayerOptions: TLayerOptions;
begin
  if ContourList.Count > 0 then
  begin
    LayerOptions :=
      TLayerOptions.Create(Layer.GetLayerHandle(CurrentModelHandle));
    try
      if (LayerOptions.NumObjects(CurrentModelHandle, pieContourObject) > 0) and
        (MessageDlg('Do you want to delete the contours already on the layer?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      begin
        LayerOptions.ClearLayer(CurrentModelHandle, False);
      end;
    finally
      LayerOptions.Free(CurrentModelHandle);
    end;
  end;
end;

procedure TfrmSutraContourImporter.btnNextClick(Sender: TObject);
begin
  inherited;
  CreateContours;
  ClearContours;
  ModalResult := mrOK;
end;

procedure TfrmSutraContourImporter.SetUpParameterArrays(
  const LayerHandle : ANE_PTR;
  var UnIndedexIndexes: T1DIntArray;
  var IndexedIndexes: T2DIntArray;
  var FirstIndexedIndexes: T2DIntArray;
  var SecondIndexedIndexes: T2DIntArray);
var
  ColIndex, RowIndex: integer;
  Param: T_ANE_LayerParam;
begin
  SetLength(UnIndedexIndexes, Layer.ParamList.Count);
  for ColIndex := 0 to Layer.ParamList.Count-1 do
  begin
    Param := Layer.ParamList[ColIndex] as T_ANE_LayerParam;
    UnIndedexIndexes[ColIndex] := Param.GetParameterIndex(
      CurrentModelHandle, False, LayerHandle);
  end;

  if Layer.IndexedParamList0.Count > 0 then
  begin
    SetLength(IndexedIndexes, Layer.IndexedParamList0[0].Count, Layer.IndexedParamList0.Count);
    for ColIndex := 0 to Layer.IndexedParamList0[0].Count - 1 do
    begin
      for RowIndex := 0 to Layer.IndexedParamList0.Count - 1 do
      begin
        Param := Layer.IndexedParamList0[RowIndex][ColIndex] as T_ANE_LayerParam;
        IndexedIndexes[ColIndex, RowIndex] := Param.GetParameterIndex(
          CurrentModelHandle, False, LayerHandle);
      end;
    end;
  end
  else
  begin
    SetLength(IndexedIndexes, 0, 0);
  end;

  if Layer.IndexedParamList1.Count > 0 then
  begin
    SetLength(FirstIndexedIndexes, Layer.IndexedParamList1[0].Count, Layer.IndexedParamList1.Count);
    for ColIndex := 0 to Layer.IndexedParamList1[0].Count - 1 do
    begin
      for RowIndex := 0 to Layer.IndexedParamList1.Count - 1 do
      begin
        Param := Layer.IndexedParamList1[RowIndex][ColIndex] as T_ANE_LayerParam;
        FirstIndexedIndexes[ColIndex, RowIndex] :=
          Param.GetParameterIndex(
          CurrentModelHandle, False, LayerHandle);
      end;
    end;
  end
  else
  begin
    SetLength(FirstIndexedIndexes, 0, 0);
  end;

  if Layer.IndexedParamList2.Count > 0 then
  begin
    SetLength(SecondIndexedIndexes, Layer.IndexedParamList2[0].Count, Layer.IndexedParamList2.Count);
    for ColIndex := 0 to Layer.IndexedParamList2[0].Count - 1 do
    begin
      for RowIndex := 0 to Layer.IndexedParamList2.Count - 1 do
      begin
        Param := Layer.IndexedParamList2[RowIndex][ColIndex] as T_ANE_LayerParam;
        SecondIndexedIndexes[ColIndex, RowIndex] :=
          Param.GetParameterIndex(
          CurrentModelHandle, False, LayerHandle);
      end;
    end;
  end
  else
  begin
    SetLength(SecondIndexedIndexes, 0, 0);
  end;
end;

procedure TfrmSutraContourImporter.CreateContours;
var
  Contour: TContour;
  Point: TImportPoint;
  ValueList: TStringList;
  LayerOptions: TLayerOptions;
  ParamCount: integer;
  UnIndedexIndexes: T1DIntArray;
  IndedexIndexes: T2DIntArray;
  FirstIndedexIndexes: T2DIntArray;
  SecondIndedexIndexes: T2DIntArray;
  ParamIndex: integer;
  ColIndex, RowIndex: integer;
  Value: string;
  EmptyLine : boolean;
  X, Y: double;
  ColStart, RowStart: integer;
  IntValue: integer;
  Param: T_ANE_LayerParam;
  procedure FinalizeContour;
  var
    ParamIndex: integer;
  begin
    Value := '';
    for ParamIndex := 0 to ValueList.Count - 1 do
    begin
      Value := Value + ValueList[ParamIndex] + #9;
    end;
    SetLength(Value, Length(Value) - 1);
    Contour.Value := Value;
    Contour.MakeDefaultHeading;
  end;
begin
  LayerOptions :=
    TLayerOptions.Create(Layer.GetLayerHandle(CurrentModelHandle));
  ValueList := TStringList.Create;
  try
    ParamCount := LayerOptions.NumParameters(CurrentModelHandle,
      pieContourLayerSubParam);

    SetUpParameterArrays(LayerOptions.LayerHandle, UnIndedexIndexes,
      IndedexIndexes, FirstIndedexIndexes, SecondIndedexIndexes);

    Contour := nil;
    RowStart := 0;
    for RowIndex := 1 to dg4Contours.RowCount -1 do
    begin
      EmptyLine := True;
      for ColIndex := 0 to dg4Contours.ColCount -1 do
      begin
        if (dg4Contours.Columns[ColIndex].Format <> rcf4Boolean)
          and (dg4Contours.Cells[ColIndex,RowIndex] <> '') then
        begin
          EmptyLine := False;
          break;
        end;
      end;
      if EmptyLine and (Contour <> nil) then
      begin
        FinalizeContour;
        Contour := nil;
      end;
      if EmptyLine then
      begin
        Continue;
      end;

      if Contour = nil then
      begin
        Contour := TContour.Create(TImportPoint, #9);
        ContourList.Add(Contour);
        Contour.OwnsPoints := True;
        Contour.PointsReady := True;
        RowStart := RowIndex;
        ValueList.Clear;
        ValueList.Capacity := ParamCount;
        for ParamIndex := 0 to ParamCount - 1 do
        begin
          ValueList.Add('0');
        end;
      end;
      try
        if (dg4Contours.Cells[0,RowIndex] <> '')
          and (dg4Contours.Cells[1,RowIndex] <> '') then
        begin
          X := InternationalStrToFloat(dg4Contours.Cells[0,RowIndex]);
          Y := InternationalStrToFloat(dg4Contours.Cells[1,RowIndex]);
          Point := TImportPoint.Create;
          Point.X := X;
          Point.Y := Y;
          Contour.AddPoint(Point);
        end;
      except on EConvertError do
        begin
        end;
      end;
      // unindexed parameters
      ColStart := 2;
      if RowIndex = RowStart then
      begin
        for ColIndex := ColStart to ColStart + Length(UnIndedexIndexes)-1 do
        begin
          ParamIndex := UnIndedexIndexes[ColIndex - ColStart];
          if dg4Contours.Columns[ColIndex].Format = rcf4Boolean then
          begin
            if dg4Contours.Checked[ColIndex,RowIndex] then
            begin
              ValueList[ParamIndex] := '1';
            end
            else
            begin
              ValueList[ParamIndex] := '0';
            end;
          end
          else if dg4Contours.Columns[ColIndex].ComboUsed then
          begin
            Param := dg4Contours.Objects[ColIndex, 0] as T_ANE_LayerParam;
            if Param is TCustomStatFlag then
            begin
              IntValue := dg4Contours.Columns[ColIndex].PickList.IndexOf(
                dg4Contours.Cells[ColIndex,RowIndex]) -1;
            end
            else
            begin
              Assert(Param is TCombineObs);
              IntValue := dg4Contours.Columns[ColIndex].PickList.IndexOf(
                dg4Contours.Cells[ColIndex,RowIndex]);
            end;

            ValueList[ParamIndex] := IntToStr(IntValue);
          end
          else
          begin
            ValueList[ParamIndex] := dg4Contours.Cells[ColIndex,RowIndex];
          end;
        end;
      end;
      // Indexed param0
      ColStart := ColStart + Length(UnIndedexIndexes);
      if Length(IndedexIndexes) > 0 then
      begin
        if RowIndex - RowStart < Length(IndedexIndexes[0]) then
        begin
          for ColIndex := ColStart to ColStart + Length(IndedexIndexes) -1 do
          begin
            ParamIndex := IndedexIndexes[ColIndex - ColStart, RowIndex - RowStart];
            ValueList[ParamIndex] := dg4Contours.Cells[ColIndex, RowIndex];
          end;
        end;
        ColStart := ColStart + Length(IndedexIndexes);
      end;

      if Length(FirstIndedexIndexes) > 0 then
      begin
        if RowIndex - RowStart < Length(FirstIndedexIndexes[0]) then
        begin
          for ColIndex := ColStart to ColStart + Length(FirstIndedexIndexes) -1 do
          begin
            ParamIndex := FirstIndedexIndexes[ColIndex - ColStart, RowIndex - RowStart];
            ValueList[ParamIndex] := dg4Contours.Cells[ColIndex, RowIndex];
          end;
        end;
      end;
      if Length(SecondIndedexIndexes) > 0 then
      begin
        if RowIndex - RowStart < Length(SecondIndedexIndexes[0]) then
        begin
          for ColIndex := ColStart to ColStart + Length(SecondIndedexIndexes) -1 do
          begin
            ParamIndex := SecondIndedexIndexes[ColIndex - ColStart, RowIndex - RowStart];
            ValueList[ParamIndex] := dg4Contours.Cells[ColIndex, RowIndex];
          end;
        end;
      end;
    end;
    if Contour <> nil then
    begin
      FinalizeContour;
    end;
  finally
    ValueList.Free;
    LayerOptions.Free(CurrentModelHandle)
  end;
end;

procedure TfrmSutraContourImporter.btnBackClick(Sender: TObject);
begin
  inherited;
end;

{ TImportPoint }

constructor TImportPoint.Create;
begin
  //  inherited;

end;

destructor TImportPoint.Destroy;
begin
  //  inherited;

end;

class function TImportPoint.GetZoomBox: TRBWZoomBox;
begin
  result := nil;
end;

procedure TfrmSutraContourImporter.SetUpNumberTypeArrays(
  const LayerHandle : ANE_PTR;
  var UnIndexedIndexes: T1DPIENumberTypeArray;
  var IndexedIndexes: T2DPIENumberTypeArray;
  var FirstIndexedIndexes: T2DPIENumberTypeArray;
  var SecondIndexedIndexes: T2DPIENumberTypeArray);
var
  ColIndex, RowIndex: integer;
  Param: T_ANE_LayerParam;
  ParameterOptions: TParameterOptions;
begin
  SetLength(UnIndexedIndexes, Layer.ParamList.Count);
  for ColIndex := 0 to Layer.ParamList.Count-1 do
  begin
    Param := Layer.ParamList[ColIndex] as T_ANE_LayerParam;

    ParameterOptions := TParameterOptions.Create(LayerHandle,
      Param.GetParameterIndex(CurrentModelHandle, False, LayerHandle));
    try
      UnIndexedIndexes[ColIndex] := ParameterOptions.NumberType[
        CurrentModelHandle];
    finally
      ParameterOptions.Free;
    end;
  end;

  if Layer.IndexedParamList0.Count > 0 then
  begin
    SetLength(IndexedIndexes, Layer.IndexedParamList0[0].Count, Layer.IndexedParamList0.Count);
    for ColIndex := 0 to Layer.IndexedParamList0[0].Count - 1 do
    begin
      for RowIndex := 0 to Layer.IndexedParamList0.Count - 1 do
      begin
        Param := Layer.IndexedParamList0[RowIndex][ColIndex] as T_ANE_LayerParam;

        ParameterOptions := TParameterOptions.Create(LayerHandle,
          Param.GetParameterIndex(CurrentModelHandle, False, LayerHandle));
        try
          IndexedIndexes[ColIndex, RowIndex] :=
            ParameterOptions.NumberType[CurrentModelHandle];
        finally
          ParameterOptions.Free;
        end;
      end;
    end;
  end
  else
  begin
    SetLength(IndexedIndexes, 0, 0);
  end;

  if Layer.IndexedParamList1.Count > 0 then
  begin
    SetLength(FirstIndexedIndexes, Layer.IndexedParamList1[0].Count, Layer.IndexedParamList1.Count);
    for ColIndex := 0 to Layer.IndexedParamList1[0].Count - 1 do
    begin
      for RowIndex := 0 to Layer.IndexedParamList1.Count - 1 do
      begin
        Param := Layer.IndexedParamList1[RowIndex][ColIndex] as T_ANE_LayerParam;

        ParameterOptions := TParameterOptions.Create(LayerHandle,
          Param.GetParameterIndex(CurrentModelHandle, False, LayerHandle));
        try
          FirstIndexedIndexes[ColIndex, RowIndex] :=
            ParameterOptions.NumberType[CurrentModelHandle];
        finally
          ParameterOptions.Free;
        end;
      end;
    end;
  end
  else
  begin
    SetLength(FirstIndexedIndexes, 0, 0);
  end;

  if Layer.IndexedParamList2.Count > 0 then
  begin
    SetLength(SecondIndexedIndexes, Layer.IndexedParamList2[0].Count, Layer.IndexedParamList2.Count);
    for ColIndex := 0 to Layer.IndexedParamList2[0].Count - 1 do
    begin
      for RowIndex := 0 to Layer.IndexedParamList2.Count - 1 do
      begin
        Param := Layer.IndexedParamList2[RowIndex][ColIndex] as T_ANE_LayerParam;

        ParameterOptions := TParameterOptions.Create(LayerHandle,
          Param.GetParameterIndex(CurrentModelHandle, False, LayerHandle));
        try
          SecondIndexedIndexes[ColIndex, RowIndex] :=
            ParameterOptions.NumberType[CurrentModelHandle];
        finally
          ParameterOptions.Free;
        end;
      end;
    end;
  end
  else
  begin
    SetLength(SecondIndexedIndexes, 0, 0);
  end;
end;

procedure TfrmSutraContourImporter.btnReadContoursClick(Sender: TObject);
var
  LayerOptions: TLayerOptions;
  ContourIndex: ANE_INT32;
  Contour: TContourObjectOptions;
  NodeIndex: ANE_INT32;
  X, Y: ANE_DOUBLE;
  Grid: TDataGrid;
  UnIndedexIndexes: T1DIntArray;
  IndedexIndexes: T2DIntArray;
  FirstIndedexIndexes: T2DIntArray;
  SecondIndedexIndexes: T2DIntArray;
  UnIndedexNumberTypeArray: T1DPIENumberTypeArray;
  IndexedNumberTypeArray: T2DPIENumberTypeArray;
  FirstIndexedNumberTypeArray: T2DPIENumberTypeArray;
  SecondIndexedNumberTypeArray: T2DPIENumberTypeArray;
  ColIndex, RowIndex: integer;
  IntValue: integer;
  RowStart: integer;
  RowEnd: integer;
  NodeCount: integer;
  CurrentRow: integer;
  ParamIndex: integer;
  Param: T_ANE_LayerParam;
  ColEnd: integer;
  TimeIndex: integer;
begin
  inherited;
  RowEnd := -1;
  dg4Contours.BeginUpdate;
  LayerOptions :=
    TLayerOptions.Create(Layer.GetOldLayerHandle(CurrentModelHandle));
  try
    if LayerOptions.NumObjects(CurrentModelHandle,
      pieContourObject) > 0 then
    begin
      SetUpParameterArrays(LayerOptions.LayerHandle, UnIndedexIndexes,
        IndedexIndexes, FirstIndedexIndexes, SecondIndedexIndexes);

      SetUpNumberTypeArrays(LayerOptions.LayerHandle, UnIndedexNumberTypeArray,
        IndexedNumberTypeArray, FirstIndexedNumberTypeArray,
        SecondIndexedNumberTypeArray);

      CurrentRow := 1;
      for ContourIndex := 0 to LayerOptions.NumObjects(CurrentModelHandle,
        pieContourObject) -1 do
      begin
        RowStart := RowEnd + 2;
        if RowStart > 1 then
        begin
          if RowStart >= dg4Contours.RowCount then
          begin
            dg4Contours.RowCount := dg4Contours.RowCount*2;
          end;
          for ColIndex := 0 to dg4Contours.ColCount -1 do
          begin
            dg4Contours.Cells[ColIndex,RowStart-1] := '';
            dg4Contours.Checked[ColIndex,RowStart-1] := False;
          end;
        end;

        Contour := TContourObjectOptions.Create(CurrentModelHandle,
          LayerOptions.LayerHandle, ContourIndex);
        try
          NodeCount := Contour.NumberOfNodes(CurrentModelHandle);
          for NodeIndex := 0 to NodeCount -1 do
          begin
            CurrentRow := NodeIndex+RowStart;
            if CurrentRow >= dg4Contours.RowCount then
            begin
              dg4Contours.RowCount := dg4Contours.RowCount*2;
            end;
            Contour.GetNthNodeLocation(CurrentModelHandle, X, Y, NodeIndex);
            dg4Contours.Cells[0, CurrentRow] := FloatToStr(X);
            dg4Contours.Cells[1, CurrentRow] := FloatToStr(Y);
          end;
          RowEnd := CurrentRow;

          CurrentRow := RowStart;
          for ParamIndex := 0 to Layer.ParamList.Count - 1 do
          begin
            ColIndex := ParamIndex + 2;
            case UnIndedexNumberTypeArray[ParamIndex] of
              pnBoolean:
                begin
                  dg4Contours.Checked[ColIndex, CurrentRow] :=
                    Contour.GetBoolParameter(CurrentModelHandle,
                    UnIndedexIndexes[ParamIndex]);
                end;
              pnInteger:
                begin
                  IntValue := Contour.GetIntegerParameter(CurrentModelHandle,
                    UnIndedexIndexes[ParamIndex]);
                  if dg4Contours.Columns[ColIndex].LimitToList then
                  begin
                    Param := dg4Contours.Objects[ColIndex,0] as T_ANE_LayerParam;
                    if Param is TCustomStatFlag then
                    begin
                      if (dg4Contours.Columns[ColIndex].PickList.Count > IntValue+1)
                        and (IntValue >= -1) then
                      begin
                        dg4Contours.Cells[ColIndex,CurrentRow] := dg4Contours.Columns[ColIndex].
                          PickList[IntValue+1];
                      end
                      else
                      begin
                        dg4Contours.Cells[ColIndex,CurrentRow] := dg4Contours.Columns[ColIndex].
                          PickList[1];
                      end;
                    end
                    else
                    begin
                      Assert(Param is TCombineObs);
                      if (dg4Contours.Columns[ColIndex].PickList.Count > IntValue)
                        and (IntValue >= 0) then
                      begin
                        dg4Contours.Cells[ColIndex,CurrentRow] := dg4Contours.Columns[ColIndex].
                          PickList[IntValue];
                      end
                      else
                      begin
                        dg4Contours.Cells[ColIndex,CurrentRow] := dg4Contours.Columns[ColIndex].
                          PickList[0];
                      end;
                    end;
                  end
                  else
                  begin
                    dg4Contours.Cells[ColIndex,CurrentRow] := IntToStr(IntValue);
                  end;
                end;
              pnFloat:
                begin
                  dg4Contours.Cells[ColIndex,CurrentRow] := FloatToStr(Contour.
                    GetFloatParameter(CurrentModelHandle,
                    UnIndedexIndexes[ParamIndex]));
                end;
              pnString:
                begin
                  dg4Contours.Cells[ColIndex,CurrentRow] := Contour.
                    GetStringParameter(CurrentModelHandle,
                    UnIndedexIndexes[ParamIndex]);
                end;
            else Assert(false);
            end;
          end;
          ColEnd := 2 + Layer.ParamList.Count;

          if Length(IndexedNumberTypeArray) > 0 then
          begin
            for TimeIndex := 0 to Length(IndexedNumberTypeArray[0]) - 1 do
            begin
              RowIndex := RowStart + TimeIndex;
              if RowIndex >= dg4Contours.RowCount then
              begin
                dg4Contours.RowCount := dg4Contours.RowCount*2;
              end;
              if RowIndex > RowEnd then
              begin
                RowEnd := RowIndex;
              end;
              for ParamIndex := 0 to Length(IndexedNumberTypeArray) - 1 do
              begin
                ColIndex := ParamIndex + ColEnd;
                case IndexedNumberTypeArray[ParamIndex,TimeIndex] of
                  pnBoolean:
                    begin
                      dg4Contours.Checked[ColIndex,RowIndex] :=
                        Contour.GetBoolParameter(CurrentModelHandle,
                        IndedexIndexes[ParamIndex,TimeIndex]);
                    end;
                  pnInteger:
                    begin
                      IntValue := Contour.GetIntegerParameter(CurrentModelHandle,
                        IndedexIndexes[ParamIndex,TimeIndex]);
                      if dg4Contours.Columns[ColIndex].LimitToList then
                      begin
                        if (dg4Contours.Columns[ColIndex].PickList.Count > IntValue+1)
                          and (IntValue >= -1) then
                        begin
                          dg4Contours.Cells[ColIndex,RowIndex] := dg4Contours.Columns[ColIndex].
                            PickList[IntValue+1];
                        end
                        else
                        begin
                          dg4Contours.Cells[ColIndex,RowIndex] := dg4Contours.Columns[ColIndex].
                            PickList[1];
                        end;
                      end
                      else
                      begin
                        dg4Contours.Cells[ColIndex,RowIndex] := IntToStr(IntValue);
                      end;
                    end;
                  pnFloat:
                    begin
                      dg4Contours.Cells[ColIndex,RowIndex] := FloatToStr(Contour.
                        GetFloatParameter(CurrentModelHandle,
                        IndedexIndexes[ParamIndex,TimeIndex]));
                    end;
                  pnString:
                    begin
                      dg4Contours.Cells[ColIndex,RowIndex] := Contour.
                        GetStringParameter(CurrentModelHandle,
                        IndedexIndexes[ParamIndex,TimeIndex]);
                    end;
                else Assert(false);
                end;
              end;
            end;

          end;

          ColEnd := ColEnd + Length(IndexedNumberTypeArray);

          if Length(FirstIndexedNumberTypeArray) > 0 then
          begin
            for TimeIndex := 0 to Length(FirstIndexedNumberTypeArray[0]) - 1 do
            begin
              RowIndex := RowStart + TimeIndex;
              if RowIndex >= dg4Contours.RowCount then
              begin
                dg4Contours.RowCount := dg4Contours.RowCount*2;
              end;
              if RowIndex > RowEnd then
              begin
                RowEnd := RowIndex;
              end;
              for ParamIndex := 0 to Length(FirstIndexedNumberTypeArray) - 1 do
              begin
                ColIndex := ParamIndex + ColEnd;
                case IndexedNumberTypeArray[ParamIndex,TimeIndex] of
                  pnBoolean:
                    begin
                      dg4Contours.Checked[ColIndex,RowIndex] :=
                        Contour.GetBoolParameter(CurrentModelHandle,
                        FirstIndedexIndexes[ParamIndex,TimeIndex]);
                    end;
                  pnInteger:
                    begin
                      IntValue := Contour.GetIntegerParameter(CurrentModelHandle,
                        FirstIndedexIndexes[ParamIndex,TimeIndex]);
                      if dg4Contours.Columns[ColIndex].LimitToList then
                      begin
                        if (dg4Contours.Columns[ColIndex].PickList.Count > IntValue+1)
                          and (IntValue >= -1) then
                        begin
                          dg4Contours.Cells[ColIndex,RowIndex] := dg4Contours.Columns[ColIndex].
                            PickList[IntValue+1];
                        end
                        else
                        begin
                          dg4Contours.Cells[ColIndex,RowIndex] := dg4Contours.Columns[ColIndex].
                            PickList[1];
                        end;
                      end
                      else
                      begin
                        dg4Contours.Cells[ColIndex,RowIndex] := IntToStr(IntValue);
                      end;
                    end;
                  pnFloat:
                    begin
                      dg4Contours.Cells[ColIndex,RowIndex] := FloatToStr(Contour.
                        GetFloatParameter(CurrentModelHandle,
                        FirstIndedexIndexes[ParamIndex,TimeIndex]));
                    end;
                  pnString:
                    begin
                      dg4Contours.Cells[ColIndex,RowIndex] := Contour.
                        GetStringParameter(CurrentModelHandle,
                        FirstIndedexIndexes[ParamIndex,TimeIndex]);
                    end;
                else Assert(false);
                end;
              end;
            end;
          end;
          ColEnd := ColEnd + Length(FirstIndexedNumberTypeArray);

          if Length(SecondIndexedNumberTypeArray) > 0 then
          begin
            for TimeIndex := 0 to Length(SecondIndexedNumberTypeArray[0]) - 1 do
            begin
              RowIndex := RowStart + TimeIndex;
              if RowIndex >= dg4Contours.RowCount then
              begin
                dg4Contours.RowCount := dg4Contours.RowCount*2;
              end;
              if RowIndex > RowEnd then
              begin
                RowEnd := RowIndex;
              end;
              for ParamIndex := 0 to Length(SecondIndexedNumberTypeArray) - 1 do
              begin
                ColIndex := ParamIndex + ColEnd;
                case SecondIndexedNumberTypeArray[ParamIndex,TimeIndex] of
                  pnBoolean:
                    begin
                      dg4Contours.Checked[ColIndex,RowIndex] :=
                        Contour.GetBoolParameter(CurrentModelHandle,
                        SecondIndedexIndexes[ParamIndex,TimeIndex]);
                    end;
                  pnInteger:
                    begin
                      IntValue := Contour.GetIntegerParameter(CurrentModelHandle,
                        SecondIndedexIndexes[ParamIndex,TimeIndex]);
                      if dg4Contours.Columns[ColIndex].LimitToList then
                      begin
                        if (dg4Contours.Columns[ColIndex].PickList.Count > IntValue+1)
                          and (IntValue >= -1) then
                        begin
                          dg4Contours.Cells[ColIndex,RowIndex] := dg4Contours.Columns[ColIndex].
                            PickList[IntValue+1];
                        end
                        else
                        begin
                          dg4Contours.Cells[ColIndex,RowIndex] := dg4Contours.Columns[ColIndex].
                            PickList[1];
                        end;
                      end
                      else
                      begin
                        dg4Contours.Cells[ColIndex,RowIndex] := IntToStr(IntValue);
                      end;
                    end;
                  pnFloat:
                    begin
                      dg4Contours.Cells[ColIndex,RowIndex] := FloatToStr(Contour.
                        GetFloatParameter(CurrentModelHandle,
                        SecondIndedexIndexes[ParamIndex,TimeIndex]));
                    end;
                  pnString:
                    begin
                      dg4Contours.Cells[ColIndex,RowIndex] := Contour.
                        GetStringParameter(CurrentModelHandle,
                        SecondIndedexIndexes[ParamIndex,TimeIndex]);
                    end;
                else Assert(false);
                end;
              end;
            end;
          end;
        finally
          Contour.Free;
        end;
      end;
    end;
  finally
    LayerOptions.Free(CurrentModelHandle);
    if RowEnd > 0 then
    begin
      dg4Contours.RowCount := RowEnd+1
    end;
    dg4Contours.EndUpdate;
    seRowCount.Value := dg4Contours.RowCount -1;
  end;
  AssignContourStarts;
end;

procedure TfrmSutraContourImporter.dg4ContoursMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if ([ssShift, ssCtrl] * Shift) = [] then
  begin
    dg4Contours.Options := dg4Contours.Options + [goEditing];
  end
  else
  begin
    dg4Contours.Options := dg4Contours.Options - [goEditing];
  end;
end;

procedure TfrmSutraContourImporter.seRowCountChange(Sender: TObject);
begin
  inherited;
  dg4Contours.RowCount := seRowCount.Value + 1;
  AssignContourStarts;
end;

procedure TfrmSutraContourImporter.comboLayersChange(Sender: TObject);
begin
  inherited;
  AssignColumnLabelsAndTypes;
end;

procedure TfrmSutraContourImporter.FormDestroy(Sender: TObject);
begin
  inherited;
  ContourStarts.Free;
  SingleRowColumns.Free;
end;

procedure TfrmSutraContourImporter.AssignContourStarts;
var
  RowIndex: integer;
  ColIndex: integer;
  EmptyRow: boolean;
begin
  ContourStarts.Clear;
  ContourStarts.Add(1);
  for RowIndex := 2 to dg4Contours.RowCount -2 do
  begin
    EmptyRow := True;
    for ColIndex := 0 to dg4Contours.ColCount -1 do
    begin
      EmptyRow := dg4Contours.Cells[ColIndex,RowIndex] = '';
      if not EmptyRow then
      begin
        Break;
      end;
    end;
    if EmptyRow then
    begin
//      for ColIndex := 0 to dg4Contours.ColCount -1 do
//      begin
//        EmptyRow := dg4Contours.Cells[ColIndex,RowIndex+1] = '';
//        if not EmptyRow then
//        begin
          ContourStarts.Add(RowIndex +1);
//          Break;
//        end;
//      end;
    end;
  end;

end;

procedure TfrmSutraContourImporter.dg4ContoursSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  if SingleRowColumns.IndexOf(ACol) >= 0 then
  begin
    if ContourStarts.IndexOf(ARow) < 0 then
    begin
      CanSelect := False;
    end;
  end;
//  if (ContourStarts.IndexOf(ARow-1) >= 0) then
//  begin
//    CanSelect := False;
//  end;
end;

procedure TfrmSutraContourImporter.dg4ContoursSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: String);
begin
  inherited;
  AssignContourStarts;
end;

end.

