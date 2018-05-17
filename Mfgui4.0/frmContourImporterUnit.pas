unit frmContourImporterUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, ComCtrls, Buttons, ExtCtrls, StringGrid3d, Spin,
  Grids, DataGrid, AnePIE, WriteContourUnit, PointContourUnit, RbwZoomBox;

type
  TImportPoint = class(TArgusPoint)
    Constructor Create; override; 
    class Function GetZoomBox : TRBWZoomBox; override;
    Destructor Destroy; override;
  end;


  TfrmContourImporter = class(TfrmWriteContour)
    Panel1: TPanel;
    btnCancel: TBitBtn;
    btnBack: TBitBtn;
    btnNext: TBitBtn;
    pcWizard: TPageControl;
    tabSelectLayers: TTabSheet;
    tabLayerParameters: TTabSheet;
    comboLayer: TComboBox;
    Label1: TLabel;
    Panel3: TPanel;
    dg3dCoordinates: TRBWDataGrid3d;
    Panel4: TPanel;
    Label3: TLabel;
    sePointCount: TSpinEdit;
    Panel5: TPanel;
    seContourCount: TSpinEdit;
    lblContourCount: TLabel;
    Panel2: TPanel;
    sg3dTimeParameters: TRBWDataGrid3d;
    dg3dParmGroup1: TRBWDataGrid3d;
    seContourSelect: TSpinEdit;
    lblContourSelect: TLabel;
    sg3dUnindexedParameters: TRBWDataGrid3d;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Label2: TLabel;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    procedure dg3dCoordinatesChange(Sender: TObject);
    procedure sePointCountChange(Sender: TObject);
    procedure seContourCountChange(Sender: TObject);
    procedure sg3dUnindexedParametersSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure sg3dUnindexedParametersSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure FormCreate(Sender: TObject); override;
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure comboLayerChange(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure seContourSelectChange(Sender: TObject);
  private
    procedure InitializedUnindexedParameters(Grid: TDataGrid);
    procedure InitializedTimeParameters(Grid: TDataGrid);
    procedure CreateContours;
    procedure InitializedParamGroup1(Grid: TDataGrid);
    { Private declarations }
  public
    procedure GetData;
    { Public declarations }
  end;

procedure ImportModflowContours(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;

var
  frmContourImporter: TfrmContourImporter;

implementation

uses Variables, ANE_LayerUnit, RunUnit, Clipbrd, UtilityFunctions,
  OptionsUnit, IntListUnit, ModflowUnit;

{$R *.DFM}

{ TfrmContourImporter }

procedure TfrmContourImporter.GetData;
var
  NumUnits: integer;
  UnitIndex: integer;
  LayerName: string;
  GeoUnit: T_ANE_IndexedLayerList;
  UnitNumber: string;
  ObservationList : T_ANE_IndexedLayerList;
  Layer: T_ANE_MapsLayer;
  LayerIndex: integer;
begin
  with frmMODFLOW do
  begin
    with ModflowTypes do
    begin

      if cbRCH.Checked then
      begin
        LayerName := GetRechargeLayerType.ANE_LayerName;
        comboLayer.Items.AddObject(LayerName,
          MFLayerStructure.UnIndexedLayers.GetLayerByName(LayerName));
      end;
      if cbRCH.Checked and (cbMOC3D.Checked or
        (cbMT3D.Checked and cbSSM.Checked)) then
      begin
        LayerName := GetMOCRechargeConcLayerType.ANE_LayerName;
        comboLayer.Items.AddObject(LayerName,
          MFLayerStructure.UnIndexedLayers.GetLayerByName(LayerName));
      end;
      if cbEVT.Checked then
      begin
        LayerName := GetETLayerType.ANE_LayerName;
        comboLayer.Items.AddObject(LayerName,
          MFLayerStructure.UnIndexedLayers.GetLayerByName(LayerName));
      end;
{      if cbETS.Checked then
      begin
        LayerName := GetMFSegmentedETLayerType.ANE_LayerName;
        comboLayer.Items.AddObject(LayerName,
          MFLayerStructure.UnIndexedLayers.GetLayerByName(LayerName));
      end;}

      if cbRES.Checked then
      begin
        LayerName := GetMFReservoirLayerType.ANE_LayerName;
        comboLayer.Items.AddObject(LayerName,
          MFLayerStructure.UnIndexedLayers.GetLayerByName(LayerName));
      end;

      if cbLAK.Checked then
      begin
        LayerName := GetMFLakeLayerType.ANE_LayerName;
        comboLayer.Items.AddObject(LayerName,
          MFLayerStructure.UnIndexedLayers.GetLayerByName(LayerName));
      end;

      if cbObservations.Checked then
      begin
        if cbHeadObservations.Checked then
        begin
          ObservationList := MFLayerStructure.FirstListsOfIndexedLayers.Items
            [Ord(lgHeadObservations)];

          for LayerIndex := 0 to ObservationList.Count -1 do
          begin
            Layer := ObservationList.Items[LayerIndex];
            with Layer do
            begin
              LayerName := WriteSpecialBeginning + WriteLayerRoot
                + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd;
            end;
            comboLayer.Items.AddObject(LayerName,Layer);
          end;
        end;

        if cbWeightedHeadObservations.Checked then
        begin
          ObservationList := MFLayerStructure.FirstListsOfIndexedLayers.Items
            [Ord(lgWeightedHeadObservations)];

          for LayerIndex := 0 to ObservationList.Count -1 do
          begin
            Layer := ObservationList.Items[LayerIndex];
            with Layer do
            begin
              LayerName := WriteSpecialBeginning + WriteLayerRoot
                + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd;
            end;
            comboLayer.Items.AddObject(LayerName,Layer);
          end;
        end;

        if cbHeadFluxObservations.Checked then
        begin
          ObservationList := MFLayerStructure.FirstListsOfIndexedLayers.Items
            [Ord(lgSpecifiedHead)];

          for LayerIndex := 0 to ObservationList.Count -1 do
          begin
            Layer := ObservationList.Items[LayerIndex];
            with Layer do
            begin
              LayerName := WriteSpecialBeginning + WriteLayerRoot
                + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd;
            end;
            comboLayer.Items.AddObject(LayerName,Layer);
          end;
        end;

{        if cbAdvObs.Checked then
        begin
          ObservationList := MFLayerStructure.FirstListsOfIndexedLayers.Items
            [Ord(lgAdvectionObservation)];

          for LayerIndex := 0 to ObservationList.Count -1 do
          begin
            Layer := ObservationList.Items[LayerIndex];
            with Layer do
            begin
              LayerName := WriteSpecialBeginning + WriteLayerRoot
                + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd;
            end;
            comboLayer.Items.AddObject(LayerName,Layer);
          end;
        end; }

        if cbGHBObservations.Checked then
        begin
          ObservationList := MFLayerStructure.FirstListsOfIndexedLayers.Items
            [Ord(lgGHBFlux)];

          for LayerIndex := 0 to ObservationList.Count -1 do
          begin
            Layer := ObservationList.Items[LayerIndex];
            with Layer do
            begin
              LayerName := WriteSpecialBeginning + WriteLayerRoot
                + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd;
            end;
            comboLayer.Items.AddObject(LayerName,Layer);
          end;
        end;

        if cbDRNObservations.Checked then
        begin
          ObservationList := MFLayerStructure.FirstListsOfIndexedLayers.Items
            [Ord(lgDrainFlux)];

          for LayerIndex := 0 to ObservationList.Count -1 do
          begin
            Layer := ObservationList.Items[LayerIndex];
            with Layer do
            begin
              LayerName := WriteSpecialBeginning + WriteLayerRoot
                + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd;
            end;
            comboLayer.Items.AddObject(LayerName,Layer);
          end;
        end;

        if cbRIVObservations.Checked then
        begin
          ObservationList := MFLayerStructure.FirstListsOfIndexedLayers.Items
            [Ord(lgRiverFlux)];

          for LayerIndex := 0 to ObservationList.Count -1 do
          begin
            Layer := ObservationList.Items[LayerIndex];
            with Layer do
            begin
              LayerName := WriteSpecialBeginning + WriteLayerRoot
                + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd;
            end;
            comboLayer.Items.AddObject(LayerName,Layer);
          end;
        end;

        if cbDRTObservations.Checked then
        begin
          ObservationList := MFLayerStructure.FirstListsOfIndexedLayers.Items
            [Ord(lgDrainReturnFlux)];

          for LayerIndex := 0 to ObservationList.Count -1 do
          begin
            Layer := ObservationList.Items[LayerIndex];
            with Layer do
            begin
              LayerName := WriteSpecialBeginning + WriteLayerRoot
                + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd;
            end;
            comboLayer.Items.AddObject(LayerName,Layer);
          end;
        end;

      end;



      if cbMOC3D.Checked then
      begin
        LayerName := GetMOCObsWellLayerType.ANE_LayerName;
        comboLayer.Items.AddObject(LayerName,
          MFLayerStructure.UnIndexedLayers.GetLayerByName(LayerName));
      end;

      NumUnits := dgGeol.RowCount -1;
      for UnitIndex := 1 to NumUnits do
      begin
        GeoUnit := MFLayerStructure.ListsOfIndexedLayers.
          GetNonDeletedIndLayerListByIndex(UnitIndex-1);

        if GeoUnit <> nil then
        begin
          UnitNumber := IntToStr(UnitIndex);
          if cbWel.Checked then
          begin
            LayerName := GetMFWellLayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));

            LayerName := GetMFLineWellLayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));

            if cbUseAreaWells.Checked then
            begin
              LayerName := GetMFAreaWellLayerType.ANE_LayerName;
              comboLayer.Items.AddObject(LayerName + UnitNumber,
                GeoUnit.GetLayerByName(LayerName));
            end;
          end;

          if cbRIV.Checked then
          begin
            LayerName := GetMFPointRiverLayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));

            LayerName := GetMFLineRiverLayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));

            if cbUseAreaRivers.Checked then
            begin
              LayerName := GetMFAreaRiverLayerType.ANE_LayerName;
              comboLayer.Items.AddObject(LayerName + UnitNumber,
                GeoUnit.GetLayerByName(LayerName));
            end;
          end;

          if cbDRN.Checked then
          begin
            LayerName := GetMFPointDrainLayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));

            LayerName := GetLineDrainLayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));

            if cbUseAreaDrains.Checked then
            begin
              LayerName := GetAreaDrainLayerType.ANE_LayerName;
              comboLayer.Items.AddObject(LayerName + UnitNumber,
                GeoUnit.GetLayerByName(LayerName));
            end;
          end;

          if cbDRT.Checked then
          begin
            LayerName := GetMFPointDrainReturnLayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));

            LayerName := GetMFLineDrainReturnLayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));

            if cbUseAreaDrainReturns.Checked then
            begin
              LayerName := GetMFAreaDrainReturnLayerType.ANE_LayerName;
              comboLayer.Items.AddObject(LayerName + UnitNumber,
                GeoUnit.GetLayerByName(LayerName));
            end;
          end;

          if cbGHB.Checked then
          begin
            LayerName := GetPointGHBLayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));

            LayerName := GetPointGHBLayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));

            if cbUseAreaGHBs.Checked then
            begin
              LayerName := GetAreaGHBLayerType.ANE_LayerName;
              comboLayer.Items.AddObject(LayerName + UnitNumber,
                GeoUnit.GetLayerByName(LayerName));
            end;
          end;

{          if cbSTR.Checked then
          begin
            LayerName := GetMFStreamLayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));
          end;   }

          if cbSFR.Checked then
          begin
            LayerName := GetMF2KSimpleStreamLayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));

            if cbSFRCalcFlow.Checked then
            begin
              LayerName := GetMF2K8PointChannelStreamLayerType.ANE_LayerName;
              comboLayer.Items.AddObject(LayerName + UnitNumber,
                GeoUnit.GetLayerByName(LayerName));

              LayerName := GetMF2KFormulaStreamLayerType.ANE_LayerName;
              comboLayer.Items.AddObject(LayerName + UnitNumber,
                GeoUnit.GetLayerByName(LayerName));

              LayerName := GetMF2KTableStreamLayerType.ANE_LayerName;
              comboLayer.Items.AddObject(LayerName + UnitNumber,
                GeoUnit.GetLayerByName(LayerName));
            end;
          end;

          if cbCHD.Checked then
          begin
            LayerName := GetMFPointLineCHD_LayerType.ANE_LayerName;
            comboLayer.Items.AddObject(LayerName + UnitNumber,
              GeoUnit.GetLayerByName(LayerName));
            if cbUseAreaCHD.Checked then
            begin
              LayerName := GetMFAreaCHD_LayerType.ANE_LayerName;
              comboLayer.Items.AddObject(LayerName + UnitNumber,
                GeoUnit.GetLayerByName(LayerName));
            end;
          end;

        end;
      end;
    end;
  end;
end;

procedure TfrmContourImporter.dg3dCoordinatesChange(Sender: TObject);
begin
  inherited;
  if dg3dCoordinates.ActivePageIndex >= 0 then
  begin
    sePointCount.Value := dg3dCoordinates.Grids[dg3dCoordinates.
      ActivePageIndex].RowCount -1;
  end;
end;

procedure TfrmContourImporter.sePointCountChange(Sender: TObject);
var
  Grid: TDataGrid;
begin
  inherited;
  if dg3dCoordinates.ActivePageIndex >= 0 then
  begin
    Grid := dg3dCoordinates.Grids[dg3dCoordinates.ActivePageIndex];
    Grid.RowCount := sePointCount.Value + 1;
  end;

end;

procedure TfrmContourImporter.seContourCountChange(Sender: TObject);
var
  NewNumberOfPages: integer;
  OldNumberOfPages: integer;
  PageIndex: integer;
  Grid: TDataGrid;
begin
  inherited;
  NewNumberOfPages := seContourCount.Value;
  OldNumberOfPages := dg3dCoordinates.PageCount;
  seContourSelect.MaxValue := seContourCount.Value;
  
  if NewNumberOfPages <> OldNumberOfPages then
  begin
    dg3dCoordinates.GridCount := NewNumberOfPages;
    sg3dUnindexedParameters.GridCount := NewNumberOfPages;
    sg3dTimeParameters.GridCount := NewNumberOfPages;
    dg3dParmGroup1.GridCount := NewNumberOfPages;
    if NewNumberOfPages < OldNumberOfPages then
    begin
      seContourSelect.Value := seContourCount.Value;
    end
    else
    begin
      for PageIndex := OldNumberOfPages to NewNumberOfPages -1 do
      begin
        Grid := dg3dCoordinates.Grids[PageIndex];
        Grid.Columns[0].Format := cfNumber;
        Grid.Columns[1].Format := cfNumber;
        Grid.Cells[0,0] := 'X';
        Grid.Cells[1,0] := 'Y';
        Grid.Cells[0,1] := '0';
        Grid.Cells[1,1] := '0';
        dg3dCoordinates.Pages[PageIndex].Caption := 'Contour '
          + IntToStr(PageIndex+1);
        dg3dCoordinates.Pages[PageIndex].TabVisible := False;

        Grid := sg3dUnindexedParameters.Grids[PageIndex];
        Grid.Cells[0,0] := 'Parameter';
        Grid.Cells[0,1] := 'Value';
        Grid.Canvas.Font := Grid.Font;
        Grid.ColWidths[0] := Grid.Canvas.TextWidth(Grid.Cells[0,0])+ 10;
//        sg3dUnindexedParameters.Pages[PageIndex].Caption := 'Contour '
//          + IntToStr(PageIndex+1);
        sg3dUnindexedParameters.Pages[PageIndex].TabVisible := False;
        InitializedUnindexedParameters(Grid);

        Grid := sg3dTimeParameters.Grids[PageIndex];
//        sg3dTimeParameters.Pages[PageIndex].Caption := 'Contour '
//          + IntToStr(PageIndex+1);
        sg3dTimeParameters.Pages[PageIndex].TabVisible := False;
        InitializedTimeParameters(Grid);

        Grid := dg3dParmGroup1.Grids[PageIndex];
//        dg3dParmGroup1.Pages[PageIndex].Caption := 'Contour '
//          + IntToStr(PageIndex+1);
        dg3dParmGroup1.Pages[PageIndex].TabVisible := False;
        InitializedParamGroup1(Grid);
      end;
      if NewNumberOfPages > 0 then
      begin
        Grid := sg3dUnindexedParameters.Grids[0];
        sg3dUnindexedParameters.Visible := Grid.ColCount > 1;

        Grid := sg3dTimeParameters.Grids[0];
        sg3dTimeParameters.Visible :=
          (Grid.RowCount > 1) and (Grid.ColCount > 1);

        Grid := dg3dParmGroup1.Grids[0];
        dg3dParmGroup1.Visible :=
          (Grid.RowCount > 1) and (Grid.ColCount > 1);

        if not dg3dParmGroup1.Visible then
        begin
          sg3dTimeParameters.Align := alClient;
          if not sg3dTimeParameters.Visible then
          begin
            sg3dUnindexedParameters.Align := alClient;
          end;
        end;

        Splitter2.Visible := dg3dParmGroup1.Visible
          and sg3dTimeParameters.Visible;

        Splitter1.Visible := sg3dUnindexedParameters.Visible
          and (dg3dParmGroup1.Visible or sg3dTimeParameters.Visible)

      end;
    end;
    seContourSelectChange(nil);
  end;
end;

procedure TfrmContourImporter.InitializedUnindexedParameters(Grid: TDataGrid);
var
  Layer : T_ANE_InfoLayer;
  ParamIndex: integer;
  Param: T_ANE_LayerParam;
begin
  Layer := comboLayer.Items.Objects[comboLayer.ItemIndex] as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Grid.Canvas.Font := Grid.Font;
    Grid.ScrollBars := ssBoth;
    Grid.ColCount := Layer.ParamList.Count+1;
    for ParamIndex := 0 to Layer.ParamList.Count -1 do
    begin
      Param := Layer.ParamList.Items[ParamIndex] as T_ANE_LayerParam;
      Grid.Cells[ParamIndex+1,0] := Param.WriteNewName;

      Grid.ColWidths[ParamIndex+1] := Grid.Canvas.TextWidth(Grid.Cells[ParamIndex+1,0])+ 10;

      if Param.ValueType = pvBoolean then
      begin
        Grid.Cells[ParamIndex+1,1] := 'False';
      end
      else
      begin
        Grid.Cells[ParamIndex+1,1] := '0';
      end;
      Grid.Objects[ParamIndex+1,1] := Param;
    end;
  end;
end;

procedure TfrmContourImporter.InitializedTimeParameters(Grid: TDataGrid);
var
  Layer : T_ANE_InfoLayer;
  TimeIndex: integer;
  ParamIndex: integer;
  Param: T_ANE_LayerParam;
  TimeList: T_ANE_IndexedParameterList;
  NewWidth, Temp: integer;
begin
  Layer := comboLayer.Items.Objects[comboLayer.ItemIndex] as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Grid.Canvas.Font := Grid.Font;
    Grid.RowCount := Layer.IndexedParamList2.Count + 1;
    NewWidth := 0;
    for TimeIndex := 1 to Grid.RowCount -1 do
    begin
      Grid.Cells[0,TimeIndex] := IntToStr(TimeIndex);
      temp := Grid.Canvas.TextWidth(Grid.Cells[0,TimeIndex])+ 10;
      if Temp > NewWidth then
      begin
        NewWidth := Temp;
      end;
    end;
    if NewWidth > Grid.ColWidths[0] then
    begin
      Grid.ColWidths[0] := NewWidth;
    end;

    if Layer.IndexedParamList2.Count > 0 then
    begin
      TimeList := Layer.IndexedParamList2.Items[0];
      Grid.ColCount := TimeList.Count + 1;
      for ParamIndex := 0 to TimeList.Count -1 do
      begin
        Param := TimeList.Items[ParamIndex] as T_ANE_LayerParam;

        with Param do
        begin
          Grid.Cells[ParamIndex+1,0] := WriteSpecialBeginning + WriteName
            + WriteSpecialMiddle + WriteSpecialEnd;
          NewWidth := Grid.Canvas.TextWidth(Grid.Cells[ParamIndex+1,0])+ 10;
          if NewWidth > Grid.ColWidths[ParamIndex+1] then
          begin
            Grid.ColWidths[ParamIndex+1] := NewWidth;
          end;
        end;
      end;
    end;

    for TimeIndex := 0 to Layer.IndexedParamList2.Count -1 do
    begin
      TimeList := Layer.IndexedParamList2.Items[TimeIndex];
      for ParamIndex := 0 to TimeList.Count -1 do
      begin
        Param := TimeList.Items[ParamIndex] as T_ANE_LayerParam;
        if Param.ValueType = pvBoolean then
        begin
          Grid.Cells[ParamIndex+1,TimeIndex+1] := 'False';
        end
        else
        begin
          Grid.Cells[ParamIndex+1,TimeIndex+1] := '0';
        end;
        Grid.Objects[ParamIndex+1,TimeIndex+1] := Param;
      end;
    end;
  end;
end;

procedure TfrmContourImporter.InitializedParamGroup1(Grid: TDataGrid);
var
  Layer : T_ANE_InfoLayer;
  TimeIndex: integer;
  ParamIndex: integer;
  Param: T_ANE_LayerParam;
  TimeList: T_ANE_IndexedParameterList;
  NewWidth, Temp: integer;
begin
  Layer := comboLayer.Items.Objects[comboLayer.ItemIndex] as T_ANE_InfoLayer;
  if Layer <> nil then
  begin
    Grid.Canvas.Font := Font;
    Grid.RowCount := Layer.IndexedParamList1.Count + 1;
    NewWidth := 0;
    for TimeIndex := 1 to Grid.RowCount -1 do
    begin
      Grid.Cells[0,TimeIndex] := IntToStr(TimeIndex);
      Grid.Canvas.Font := Font;
      temp := Grid.Canvas.TextWidth(Grid.Cells[0,TimeIndex])+ 10;
      if Temp > NewWidth then
      begin
        NewWidth := Temp;
      end;
    end;
    if NewWidth > Grid.ColWidths[0] then
    begin
      Grid.ColWidths[0] := NewWidth;
    end;

    if Layer.IndexedParamList1.Count > 0 then
    begin
      TimeList := Layer.IndexedParamList1.Items[0];
      Grid.ColCount := TimeList.Count + 1;
      for ParamIndex := 0 to TimeList.Count -1 do
      begin
        Param := TimeList.Items[ParamIndex] as T_ANE_LayerParam;

        with Param do
        begin
          Grid.Cells[ParamIndex+1,0] := WriteSpecialBeginning + WriteName
            + WriteSpecialMiddle + WriteSpecialEnd;
          NewWidth := Grid.Canvas.TextWidth(Grid.Cells[ParamIndex+1,0])+ 10;
          if NewWidth > Grid.ColWidths[ParamIndex+1] then
          begin
            Grid.ColWidths[ParamIndex+1] := NewWidth;
          end;
        end;
      end;
    end;

    for TimeIndex := 0 to Layer.IndexedParamList1.Count -1 do
    begin
      TimeList := Layer.IndexedParamList1.Items[TimeIndex];
      for ParamIndex := 0 to TimeList.Count -1 do
      begin
        Param := TimeList.Items[ParamIndex] as T_ANE_LayerParam;
        if Param.ValueType = pvBoolean then
        begin
          Grid.Cells[ParamIndex+1,TimeIndex+1] := 'False';
        end
        else
        begin
          Grid.Cells[ParamIndex+1,TimeIndex+1] := '0';
        end;
        Grid.Objects[ParamIndex+1,TimeIndex+1] := Param;
      end;
    end;
  end;
end;

procedure TfrmContourImporter.sg3dUnindexedParametersSelectCell(
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
    else Assert(False);
    end;

  end;
end;

procedure TfrmContourImporter.sg3dUnindexedParametersSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: String);
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
    and (Param.ValueType = pvInteger) and (Value <> '') then
  begin
    try
      StrToInt(Value);
    except on EConvertError do
      begin
        Val(Value, V, Code);
        if Code > 1 then
        begin
          NewValue := Copy(Value, 1, Code-1);
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

procedure TfrmContourImporter.FormCreate(Sender: TObject);
begin
  inherited;
  pcWizard.ActivePageIndex := 0;
  GetData;
  seContourCount.MaxValue := MAXINT;
  seContourSelect.MaxValue := 1;
  sePointCount.MaxValue := MAXINT;
end;

procedure ImportModflowContours(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
var
  Layer : T_ANE_InfoLayer;
  LayerOptions: TLayerOptions;
begin
  Exporting := True;
  Try
  if EditWindowOpen
  then
    begin
      // Result := False
    end
  else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try  // try 1
        begin
          try  // try 2
            begin
              frmMODFLOW := TArgusForm.GetFormFromArgus(aneHandle)
                as ModflowTypes.GetModflowFormType;

              Application.CreateForm(TfrmContourImporter,frmContourImporter);
              frmContourImporter.CurrentModelHandle := aneHandle;

              try // try 3
                if frmContourImporter.comboLayer.Items.Count = 0 then
                begin
                  Beep;
                  MessageDlg('Sorry: There are no layers present that can '
                    + 'be used with this command.', mtInformation,
                    [mbOK], 0);
                end
                else
                begin
                  if frmContourImporter.ShowModal = mrOK then
                  begin
                    Layer := frmContourImporter.comboLayer.Items.Objects[
                      frmContourImporter.comboLayer.ItemIndex]
                      as T_ANE_InfoLayer;
                    LayerOptions:= TLayerOptions.Create(Layer.GetLayerHandle(
                      aneHandle));
                    try
                      LayerOptions.Text[aneHandle]
                        := frmContourImporter.WriteContours
                    finally
                      LayerOptions.Free(aneHandle);
                    end;

                  end;
                end;

              finally // try 3
                frmContourImporter.Free;
              end; // try 3
            end; // try 2
          except on E: Exception do
            begin
              Beep;
              MessageDlg(E.Message, mtError, [mbOK], 0);
                // result := False;
            end;
          end  // try 2
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end; // try 1
    end; // if EditWindowOpen else
  finally
    Exporting := False;
  end;
end;

procedure TfrmContourImporter.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Delimiters: TSysCharSet;
  Grid: TStringGrid;
  ClipBoardText: TStringList;
  isCoordinates: boolean;
begin
  inherited;
  if (ActiveControl is TStringGrid) then
  begin
    if (ssCtrl in Shift) and ((Key = Ord('V')) or (Key = Ord('v')))
      and Clipboard.HasFormat(CF_TEXT) then
    begin
      Grid := ActiveControl as TStringGrid;

      Delimiters := [#9, ',', ' '];

      Screen.Cursor := crHourGlass;
      ClipBoardText := TStringList.Create;
      try
        ClipBoardText.Text := Clipboard.AsText;
        isCoordinates := Grid = dg3dCoordinates.Grids[
          dg3dCoordinates.ActivePageIndex];
        PasteInStringGrid(ClipBoardText, Grid, Delimiters, isCoordinates, False);
        if isCoordinates then
        begin
          sePointCount.Value := Grid.RowCount-1;
        end;
      finally
        ClipBoardText.Free;
        Screen.Cursor := crDefault;
      end;
    end;
  end;

end;

procedure TfrmContourImporter.comboLayerChange(Sender: TObject);
begin
  inherited;
  btnNext.Enabled := True;
  sePointCount.Value := 1;
  seContourCount.Value := 0;
  Caption := 'Import MODFLOW Contours from Spreadsheet: ' +
    comboLayer.Text;
end;

procedure TfrmContourImporter.btnNextClick(Sender: TObject);
begin
  inherited;
  if pcWizard.ActivePageIndex = 0 then
  begin
    btnBack.Enabled := True;
    seContourCount.Visible := True;
    lblContourCount.Visible := True;
    seContourSelect.Visible := True;
    lblContourSelect.Visible := True;
    if seContourCount.Value = 0 then
    begin
      seContourCount.Value := 1;
      seContourSelect.Value := 1;
    end;
    dg3dCoordinates.ActivePageIndex := 0;
    sg3dUnindexedParameters.ActivePageIndex := 0;
    sg3dTimeParameters.ActivePageIndex := 0;
    dg3dParmGroup1.ActivePageIndex:= 0;
    btnNext.Caption := 'Finish';
    pcWizard.ActivePageIndex := 1;
  end
  else
  begin
    CreateContours;
    ModalResult := mrOK;
  end;
end;

procedure TfrmContourImporter.CreateContours;
var
  ContourIndex: integer;
  Contour: TContour;
  PointIndex: integer;
  Grid : TDataGrid;
  Point: TImportPoint;
  ValueList: TStringList;
  Layer : T_ANE_InfoLayer;
  LayerOptions: TLayerOptions;
  ParamCount: integer;
  UnIndedexIndexes : array of Integer;
  IndedexIndexes : array of array of Integer;
  FirstIndedexIndexes : array of array of Integer;
  ParamIndex: integer;
  ColIndex, RowIndex: integer;
  Param: T_ANE_LayerParam;
  Value: string;
begin
  if seContourCount.Value > 0 then
  begin
    Layer := comboLayer.Items.Objects[comboLayer.ItemIndex] as T_ANE_InfoLayer;
    LayerOptions:= TLayerOptions.Create(Layer.GetLayerHandle(CurrentModelHandle));
    ValueList := TStringList.Create;
    try
      ParamCount := LayerOptions.NumParameters(CurrentModelHandle,
        pieContourLayerSubParam);
      for ParamIndex := 0 to ParamCount-1 do
      begin
        ValueList.Add('0');
      end;


      Grid := sg3dUnindexedParameters.Grids[0];
      SetLength(UnIndedexIndexes, Grid.ColCount -1);
      for ColIndex := 1 to Grid.ColCount -1 do
      begin
        Param := Grid.Objects[ColIndex,1] as T_ANE_LayerParam;
        UnIndedexIndexes[ColIndex-1] := Param.GetParameterIndex(
          CurrentModelHandle, False, LayerOptions.LayerHandle);
      end;

      Grid := sg3dTimeParameters.Grids[0];
      SetLength(IndedexIndexes, Grid.ColCount -1, Grid.RowCount -1);
      for ColIndex := 1 to Grid.ColCount -1 do
      begin
        for RowIndex := 1 to Grid.RowCount -1 do
        begin
          Param := Grid.Objects[ColIndex,RowIndex] as T_ANE_LayerParam;
          IndedexIndexes[ColIndex-1,RowIndex-1] := Param.GetParameterIndex(
            CurrentModelHandle, False, LayerOptions.LayerHandle);
        end;
      end;

      Grid := dg3dParmGroup1.Grids[0];
      SetLength(FirstIndedexIndexes, Grid.ColCount -1, Grid.RowCount -1);
      for ColIndex := 1 to Grid.ColCount -1 do
      begin
        for RowIndex := 1 to Grid.RowCount -1 do
        begin
          Param := Grid.Objects[ColIndex,RowIndex] as T_ANE_LayerParam;
          FirstIndedexIndexes[ColIndex-1,RowIndex-1] := Param.GetParameterIndex(
            CurrentModelHandle, False, LayerOptions.LayerHandle);
        end;
      end;


      for ContourIndex := 0 to seContourCount.Value -1 do
      begin
        Contour := TContour.Create(TImportPoint, #9);
        ContourList.Add(Contour);
        Contour.OwnsPoints := True;
        Contour.PointsReady := True;
        Grid := dg3dCoordinates.Grids[ContourIndex];
        for PointIndex := 1 to Grid.RowCount -1 do
        begin
          Point := TImportPoint.Create;
          try
            Point.X := InternationalStrToFloat(Grid.Cells[0,PointIndex]);
          except On EConvertError do
            begin
              Point.X := 0;
            end;
          end;
          try
            Point.Y := InternationalStrToFloat(Grid.Cells[1,PointIndex]);
          except On EConvertError do
            begin
              Point.Y := 0;
            end;
          end;
          Contour.AddPoint(Point);
        end;

        Grid := sg3dUnindexedParameters.Grids[ContourIndex];
        for ColIndex := 1 to Grid.ColCount -1 do
        begin
          ParamIndex := UnIndedexIndexes[ColIndex-1];
          ValueList[ParamIndex] := Grid.Cells[ColIndex,1];
        end;

        Grid := sg3dTimeParameters.Grids[ContourIndex];
        for ColIndex := 1 to Grid.ColCount -1 do
        begin
          for RowIndex := 1 to Grid.RowCount -1 do
          begin
            ParamIndex := IndedexIndexes[ColIndex-1,RowIndex-1];
            ValueList[ParamIndex] := Grid.Cells[ColIndex,RowIndex];
          end;
        end;

        Grid := dg3dParmGroup1.Grids[ContourIndex];
        for ColIndex := 1 to Grid.ColCount -1 do
        begin
          for RowIndex := 1 to Grid.RowCount -1 do
          begin
            ParamIndex := FirstIndedexIndexes[ColIndex-1,RowIndex-1];
            ValueList[ParamIndex] := Grid.Cells[ColIndex,RowIndex];
          end;
        end;

        Value := '';
        for ParamIndex := 0 to ValueList.Count -1 do
        begin
          Value := Value + ValueList[ParamIndex] + #9;
        end;
        SetLength(Value, Length(Value)-1);
        Contour.Value := Value;
        Contour.FixValue(CurrentModelHandle);
        Contour.MakeDefaultHeading;
      end;

    finally
      ValueList.Free;
      LayerOptions.Free(CurrentModelHandle)
    end;
  end;
end;

procedure TfrmContourImporter.btnBackClick(Sender: TObject);
begin
  inherited;
  btnNext.Caption := 'Next';
  seContourCount.Visible := False;
  lblContourCount.Visible := False;
  seContourSelect.Visible := False;
  lblContourSelect.Visible := False;
  btnBack.Enabled := False;
  pcWizard.ActivePageIndex := 0;
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

procedure TfrmContourImporter.seContourSelectChange(Sender: TObject);
begin
  inherited;
  if seContourSelect.Value = 0 then seContourSelect.Value := 1;
  dg3dCoordinates.ActivePageIndex := seContourSelect.Value -1;
  sg3dUnindexedParameters.ActivePageIndex := seContourSelect.Value -1;
  sg3dTimeParameters.ActivePageIndex := seContourSelect.Value -1;
  dg3dParmGroup1.ActivePageIndex := seContourSelect.Value -1;
  dg3dCoordinatesChange(nil);
end;

end.
