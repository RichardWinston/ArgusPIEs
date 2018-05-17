unit PostMODFLOWPieUnit;

interface

{
PostMODFLOWPieUnit defines the procedure that is called when postprocessing
MODFLOW or MOC3D/GWT files.
}

uses AnePIE, classes, SysUtils, Forms, Controls, Dialogs;

procedure GPostProcessingPIE(aneHandle: ANE_PTR; const fileName: ANE_STR;
  layerHandle: ANE_PTR); cdecl;

implementation

uses
  ThreeDRealListUnit, ANECB, ANE_LayerUnit,
  ArgusFormUnit, MFPostProc, WritePostProcessingUnit,
  ThreeDGriddedDataStorageUnit, RealListUnit, IntListUnit,
  Variables, ModflowUnit, PostMODFLOW, UtilityFunctions, SelectPostFile;

procedure GPostProcessingPIE(aneHandle: ANE_PTR; const fileName: ANE_STR;
  layerHandle: ANE_PTR); cdecl;
var
  NameIndex: integer;
  APlotDirection: TPlotDirection;
  XCoordList, YCoordList, ZCoordList: TRealList;
  DataSets: TIntegerList;
  PostProcessingLayers: T_ANE_LayerList;
  PlaneToUse: integer;
  dataLayerHandle: ANE_PTR;
  MinX, MinY, MaxX, MaxY: double;
  CheckCellActive: TCheckCellActive;
  aDataLayerClass: T_ANE_DataLayerClass;
  ChartType: TChartType;
  Names: TStringList;
  aChartLayerType: T_ANE_MapsLayerClass;
  DataLayerName: string;
  XIndex, YIndex, ZIndex, DataSetIndex: integer;
  XVelocities: T3DRealList;
  YVelocities: T3DRealList;
  AnXVelocity, AYVelocity: double;
  GridMinX, GridMaxX, GridMinY, GridMaxY, GridAngle: double;
  GridLayerHandle: ANE_PTR;
  SwitchDirection: boolean;
  NRow, NCol: ANE_INT32;
  ErrorMessage: string;
  IsMT3D: boolean;
  LayerIndex: integer;
  TempNames: TStringList;
  DeletedValues: TIntegerList;
  Warning: string;
  DeleteIndex: integer;
  Switched: boolean;
  //  RowDirectionPositive, ColDirectionPositive : Boolean;
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
            frmMODFLOW := TArgusForm.GetFormFromArgus(aneHandle)
              as ModflowTypes.GetModflowFormType;
            Application.CreateForm(ModflowTypes.GetPostModflowType,
              frmMODFLOWPostProcessing);
            try // try 3
              begin
                frmMODFLOWPostProcessing.CurrentModelHandle := aneHandle;

                Application.CreateForm(ModflowTypes.GetSelectPostFileType,
                  frmSelectPostFile);

                try //try 3.5

                  frmSelectPostFile.CurrentModelHandle := aneHandle;

                  GetGridDirection(aneHandle,
                    ModflowTypes.GetGridLayerType.ANE_LayerName,
                    frmSelectPostFile.YPositive, frmSelectPostFile.XPositive);

                  if frmSelectPostFile.ShowModal = mrOK then
                  begin
                    IsMT3D := TModflowOutputFileType(frmSelectPostFile.
                      rgSourceType.ItemIndex) = mofMt3dmsConcentration;
                    frmMODFLOWPostProcessing.ActivateOptions;

                    ANE_ProcessEvents(aneHandle);
                    if frmMODFLOWPostProcessing.ShowModal = mrOK then
                    begin
                      ANE_ProcessEvents(aneHandle);
                      APlotDirection := ptXY;
                      XCoordList := frmMODFLOWPostProcessing.XCoordList;
                      YCoordList := frmMODFLOWPostProcessing.YCoordList;
                      ZCoordList := frmMODFLOWPostProcessing.ZCoordList;
                      DataSets := frmMODFLOWPostProcessing.DataSets;
                      PostProcessingLayers :=
                        frmMODFLOW.MFLayerStructure.PostProcessingLayers;

                      Switched := False;
                      TempNames := frmMODFLOWPostProcessing.Data.NameList;
                      try
                        for LayerIndex := 0 to frmMODFLOWPostProcessing.
                          clLayerNumber.Items.Count - 1 do
                        begin
                          if frmMODFLOWPostProcessing.clLayerNumber.Checked[
                            LayerIndex] then
                          begin
                            with frmMODFLOWPostProcessing do
                            begin
                              if IsMT3D then
                              begin
                                PlaneToUse := 0;
                              end
                              else
                              begin
                                PlaneToUse := LayerIndex;
                              end;
                              for NameIndex := 0 to Data.Count - 1 do
                              begin
                                // set names of data sets
                                if frmMODFLOWPostProcessing.clLayerNumber.Items[
                                  LayerIndex] = StrWaterTable then
                                begin
                                  Data.Names[NameIndex] :=
                                    TempNames[NameIndex] +
                                    ' ' +
                                    frmMODFLOWPostProcessing.clLayerNumber.Items[
                                    LayerIndex];
                                end
                                else
                                begin
                                  Data.Names[NameIndex] :=
                                    TempNames[NameIndex] +
                                    ' Layer ' +
                                    frmMODFLOWPostProcessing.clLayerNumber.Items[
                                    LayerIndex];
                                end;
                              end;

                              aDataLayerClass := TMFPostProcessDataLayer;
                              CheckCellActive := MODFLOWActive;
                              aChartLayerType := TMFPostProcessChartLayer;
                              case TModflowOutputFileType(frmSelectPostFile.
                                rgSourceType.ItemIndex) of
                                mofFormattedHeadAndDrawdown,
                                  mofBinaryHeadAndDrawdownOldFormat,
                                  mofBinaryHeadAndDrawdownNewFormat: // MODFLOW (Head and Drawdown)
                                  begin
                                    CheckCellActive := MODFLOWActive;
                                    aDataLayerClass := TMFPostProcessDataLayer;
                                    aChartLayerType := TMFPostProcessChartLayer;
                                  end;
                                mofGWT_Concentration: // MOC3D (Concentrations)
                                  begin
                                    CheckCellActive := MOC3DConcActive;
                                    aDataLayerClass := TMOCPostProcessDataLayer;
                                    aChartLayerType :=
                                      TMocPostProcessChartLayer;
                                  end;
                                mofMt3dmsConcentration: // MT3DMS (Concentrations)
                                  begin
                                    CheckCellActive := MT3DMSConcActive;
                                    aDataLayerClass :=
                                      TMT3DPostProcessDataLayer;
                                    aChartLayerType :=
                                      TMT3DPostProcessChartLayer;
                                  end;
                                mofGWT_Velocity: // MOC3D (Velocities)
                                  begin
                                    CheckCellActive := MOC3DVelActive;
                                    aDataLayerClass := TMOCPostProcessDataLayer;
                                    aChartLayerType :=
                                      TMocPostProcessChartLayer;

                                    GetGrid(frmMODFLOW.CurrentModelHandle,
                                      ModflowTypes.GetGridLayerType.
                                      ANE_LayerName,
                                      GridLayerHandle, NRow, NCol,
                                      GridMinX, GridMaxX, GridMinY, GridMaxY,
                                      GridAngle);

                                    SwitchDirection := False;
                                    if GridMinX > GridMaxX then
                                    begin
                                      SwitchDirection := not SwitchDirection;
                                    end;
                                    if GridMinY > GridMaxY then
                                    begin
                                      SwitchDirection := not SwitchDirection;
                                    end;
                                    if not Switched and
                                      ((GridAngle <> 0) or SwitchDirection) then
                                    begin
                                      for DataSetIndex := 0 to
                                        Trunc(DataSets.Count / 2) - 1 do
                                      begin
                                        XVelocities :=
                                          frmMODFLOWPostProcessing.Data.
                                          Items[DataSets.Items[DataSetIndex *
                                          2]];
                                        YVelocities :=
                                          frmMODFLOWPostProcessing.Data.
                                          Items[DataSets.Items[DataSetIndex * 2
                                          + 1]];
                                        for ZIndex := 0 to XVelocities.ZCount-1
                                          do
                                        begin
                                          for YIndex := 0 to XVelocities.YCount
                                            - 1 do
                                          begin
                                            for XIndex := 0 to XVelocities.
                                              XCount - 1 do
                                            begin
                                              AnXVelocity :=
                                                XVelocities.Items[XIndex,
                                                  YIndex,
                                                ZIndex];
                                              AYVelocity :=
                                                YVelocities.Items[XIndex,
                                                  YIndex,
                                                ZIndex];
                                              if GridAngle <> 0 then
                                              begin
                                                RotatePointsFromGrid(
                                                  AnXVelocity, AYVelocity,
                                                  GridAngle);
                                              end;
                                              if SwitchDirection then
                                              begin
                                                AnXVelocity := -AnXVelocity;
                                                AYVelocity := -AYVelocity;
                                              end;
                                              XVelocities.Items[XIndex, YIndex,
                                                ZIndex] := AnXVelocity;
                                              YVelocities.Items[XIndex, YIndex,
                                                ZIndex] := AYVelocity;
                                            end;
                                          end;
                                        end;
                                      end;
                                      Switched := True;
                                    end;
                                  end;
                              end;
                            end;
                            try
                            frmMODFLOWPostProcessing.Data.SetArgusData(DataSets,
                              APlotDirection, PlaneToUse, CheckCellActive,
                              aneHandle, aDataLayerClass,
                              ModflowTypes.GetGridLayerType.ANE_LayerName,
                              XCoordList, YCoordList, ZCoordList,
                              PostProcessingLayers, dataLayerHandle,
                              MinX, MinY, MaxX, MaxY, DataLayerName,
                              DeletedValues);
                            if (dataLayerHandle = nil) then
                            begin
                              Exit;
                            end
                            else
                            begin
                              if DeletedValues.Count > 0 then
                              begin
                                Warning := 'In layer ' +
                                  frmMODFLOWPostProcessing.clLayerNumber.Items[
                                  LayerIndex] + ', the following data sets were'
                                  + ' uniform and will not be graphed.  '#13#10;
                                for DeleteIndex := 0 to DeletedValues.Count -1 do
                                begin
                                  Warning := Warning + TempNames[DeletedValues[DeleteIndex]]
                                    + #13#10;
                                end;
                                Beep;
                                MessageDlg(Warning, mtInformation, [mbOK], 0);
                              end;

                              if (MinX = MaxX) and (MinY = MaxY) then
                              begin
                                Beep;
                                ShowMessage('Chart Error: All the points in '
                                  + 'the model may be dry.');
                              end
                              else
                              begin
                                // set chart type
                                ChartType := ctContour;
                                case
                                  frmMODFLOWPostProcessing.rgChartType.ItemIndex
                                  of
                                  0:
                                    begin
                                      ChartType := ct3D;
                                    end;
                                  1:
                                    begin
                                      ChartType := ctColor;
                                    end;
                                  2:
                                    begin
                                      ChartType := ctContour;
                                    end;
                                  3:
                                    begin
                                      ChartType := ctCrosssection;
                                    end;
                                end; // case frmPostProcessingForm.
                                //        rgPlotType.ItemIndex of
                                if TModflowOutputFileType(frmSelectPostFile.
                                  rgSourceType.ItemIndex) = mofGWT_Velocity then
                                begin
                                  ChartType := ctVector;
                                end;
                                // get list of names
                                Names := frmMODFLOWPostProcessing.Data.NameList;
                                try // try 4
                                  begin
                                    // create post processing chart
                                    if not WritePostProcessing(aneHandle, Names,
                                      DataSets, ChartType, DataLayerName,
                                      aChartLayerType, MinX, MinY, MaxX, MaxY,
                                      frmMODFLOW.MFLayerStructure.
                                      PostProcessingLayers, PlaneToUse,
                                      DeletedValues) then
                                      Exit;
                                  end; // try 4
                                finally // try 4
                                  begin
                                    Names.free;
                                  end;
                                end // try 4 finally
                              end;
                            end; // if not (dataLayerHandle = nil) then
                            finally
                              DeletedValues.Free;
                            end;
                          end;
                        end;
                      finally
                        TempNames.Free;
                      end;
                    end; //  if frmMODFLOWPostProcessing.ShowModal = mrOK then
                  end; //  if frmSelectPostFile.ShowModal = mrOK then
                finally // try 3.5
                  frmSelectPostFile.Free;
                end;
              end; // try 3
            finally // try 3
              begin
                frmMODFLOWPostProcessing.Free;
              end;
            end; // try 3
          end; // try 2
        except
          on EUniformValues do
          begin
            Beep;
            MessageDlg('Error: Data values are uniform. '
              + 'Postprocessing Aborted.', mtError, [mbOK], 0);
          end;
          on E: EOutOfMemory do
          begin
            MessageDlg(E.Message, mtError, [mbOK], 0);
          end;
          on E: Exception do
          begin
            if frmMODFLOW.PIEDeveloper = '' then
            begin
              ErrorMessage := 'The following error occurred in '
                + 'post-processing PIE. "'
                + E.Message + '" Contact '
                + 'PIE Developer for assistance.';
            end
            else
            begin
              ErrorMessage := 'The following error occurred in '
                + 'post-processing PIE. "'
                + E.Message + '" Contact '
                + 'PIE Developer (' + frmMODFLOW.PIEDeveloper
                + ') for assistance.';
            end;
            Beep;
            MessageDlg(ErrorMessage, mtError, [mbOK], 0);
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

end.

