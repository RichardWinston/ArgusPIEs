unit PostMODFLOWPieUnit;

interface

{PostMODFLOWPieUnit defines the procedure that is called when postprocessing
 MODFLOW or MOC3D files.}

uses AnePIE, classes, SysUtils, Forms, Controls, Dialogs ;

procedure GPostProcessingPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;


implementation

uses
    ThreeDRealListUnit, ANECB, ANE_LayerUnit,
     ArgusFormUnit, MFPostProc, WritePostProcessingUnit,
     ThreeDGriddedDataStorageUnit, RealListUnit, IntListUnit,
     Variables, ModflowUnit, PostMODFLOW, UtilityFunctions;



procedure GPostProcessingPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;
var
  NameIndex : integer;
  APlotDirection : TPlotDirection;
  XCoordList, YCoordList, ZCoordList : TRealList;
  DataSets : TIntegerList;
  PostProcessingLayers : T_ANE_LayerList;
  PlaneToUse : integer;
  dataLayerHandle : ANE_PTR ;
  MinX, MinY, MaxX, MaxY : double;
  CheckCellActive : TCheckCellActive;
  aDataLayerClass : T_ANE_DataLayerClass;
  ChartType : TChartType;
  Names : TStringList;
  aChartLayerType : T_ANE_MapsLayerClass ;
  DataLayerName : string;
  XIndex, YIndex, ZIndex, DataSetIndex : integer;
  XVelocities : T3DRealList;
  YVelocities : T3DRealList;
  AnXVelocity, AYVelocity : double;
  GridMinX, GridMaxX, GridMinY, GridMaxY, GridAngle : double;
  GridLayerHandle : ANE_PTR ;
  SwitchDirection : boolean;
  NRow, NCol: ANE_INT32;
  ErrorMessage : string;
//  RowDirectionPositive, ColDirectionPositive : Boolean;
begin
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

              frmMODFLOWPostProcessing :=
                ModflowTypes.GetPostModflowType.Create(Application);
              frmMODFLOWPostProcessing.CurrentModelHandle := aneHandle;



              frmSelectPostFile :=
                ModflowTypes.GetSelectPostFileType.Create(Application);
              frmSelectPostFile.CurrentModelHandle := aneHandle;

              GetGridDirection (aneHandle,
                ModflowTypes.GetGridLayerType.ANE_LayerName,
                frmSelectPostFile.YPositive, frmSelectPostFile.XPositive);

//              frmSelectPostFile.XPositive := ColDirectionPositive;
//              frmSelectPostFile.cbY.Checked := RowDirectionPositive;

              try // try 3
                begin
                  if frmSelectPostFile.ShowModal = mrOK then
                  begin
                    frmMODFLOWPostProcessing.ActivateOptions;
                    try  //try 3.5

                      ANE_ProcessEvents(aneHandle);
                      if frmMODFLOWPostProcessing.ShowModal = mrOK then
                      begin
                        ANE_ProcessEvents(aneHandle);
                        APlotDirection := ptXY;
                        XCoordList := frmMODFLOWPostProcessing.XCoordList;
                        YCoordList := frmMODFLOWPostProcessing.YCoordList;
                        ZCoordList := frmMODFLOWPostProcessing.ZCoordList;
                        DataSets :=  frmMODFLOWPostProcessing.DataSets;
                        PostProcessingLayers := frmMODFLOW.MFLayerStructure.PostProcessingLayers;
                        with frmMODFLOWPostProcessing do
                        begin
                          for NameIndex := 0 to Data.Count -1 do
                          begin
                            // set names of data sets
                            Data.Names[NameIndex] :=
                              Data.Names[NameIndex] +
                              ' ' + ' Layer ' +
                              ' ' + comboLayerNumber.Text;
                          end;
                          PlaneToUse := StrToInt(comboLayerNumber.Text)-1;
                          aDataLayerClass := TMFPostProcessDataLayer;
                          CheckCellActive := MODFLOWActive;
                          aChartLayerType := TMFPostProcessChartLayer;
                          Case frmSelectPostFile.rgSourceType.ItemIndex of
                            0: // MODFLOW (Head and Drawdown)
                              begin
                                CheckCellActive := MODFLOWActive;
                                aDataLayerClass := TMFPostProcessDataLayer;
                                aChartLayerType := TMFPostProcessChartLayer;
                              end;
                            1: // MOC3D (Concentrations)
                              begin
                                CheckCellActive := MOC3DConcActive;
                                aDataLayerClass := TMOCPostProcessDataLayer;
                                aChartLayerType := TMocPostProcessChartLayer;
                              end;
                            2: // MOC3D (Velocities)
                              begin
                                CheckCellActive := MOC3DVelActive;
                                aDataLayerClass := TMOCPostProcessDataLayer;
                                aChartLayerType := TMocPostProcessChartLayer;

  {                              GetGridAngle(frmMODFLOW.CurrentModelHandle,
                                  ModflowTypes.GetGridLayerType.ANE_LayerName,
                                  GridLayerHandle,GridAngle); }

                                GetGrid(frmMODFLOW.CurrentModelHandle,
                                  ModflowTypes.GetGridLayerType.ANE_LayerName,
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
                                if GridAngle <> 0 then
                                begin
                                  For DataSetIndex := 0 to Trunc(DataSets.Count/2)-1 do
                                  begin
                                    XVelocities := frmMODFLOWPostProcessing.Data.
                                      Items[DataSets.Items[DataSetIndex*2]];
                                    YVelocities := frmMODFLOWPostProcessing.Data.
                                      Items[DataSets.Items[DataSetIndex*2+1]];
                                    for ZIndex := 0 to XVelocities.ZCount-1 do
                                    begin
                                      For YIndex := 0 to XVelocities.YCount-1 do
                                      begin
                                        For XIndex := 0 to XVelocities.XCount-1 do
                                        begin
                                          AnXVelocity := XVelocities.Items[XIndex,YIndex,ZIndex];
                                          AYVelocity  := YVelocities.Items[XIndex,YIndex,ZIndex];
                                          RotatePointsFromGrid(AnXVelocity,AYVelocity,GridAngle);
                                          if SwitchDirection then
                                          begin
                                            AnXVelocity := -AnXVelocity;
                                            AYVelocity  := -AYVelocity;
                                          end;
                                          XVelocities.Items[XIndex,YIndex,ZIndex] := AnXVelocity ;
                                          YVelocities.Items[XIndex,YIndex,ZIndex] := AYVelocity  ;
                                        end;
                                      end;
                                    end;
                                  end;
                                end;
                              end;
                          end;
                        end;
                        frmMODFLOWPostProcessing.Data.SetArgusData(DataSets,
                          APlotDirection, PlaneToUse, CheckCellActive,
                          aneHandle, aDataLayerClass, ModflowTypes.GetGridLayerType.ANE_LayerName,
                          XCoordList, YCoordList, ZCoordList,
                          PostProcessingLayers, dataLayerHandle,
                          MinX, MinY, MaxX, MaxY, DataLayerName);
                        if not (dataLayerHandle = nil) then
                        begin
                          if (MinX = MaxX) and (MinY = MaxY)
                          then
                            begin
                              Beep;
                              ShowMessage('Chart Error: All the points in the model may be dry.');
                            end
                          else
                            begin
                              // set chart type
                              ChartType := ctContour;
                              case frmMODFLOWPostProcessing.rgChartType.ItemIndex of
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
                              end; // case frmPostProcessingForm.rgPlotType.ItemIndex of
                              if frmSelectPostFile.rgSourceType.ItemIndex = 2 then
                              begin
                                ChartType := ctVector;
                              end;
                              // get list of names
                              Names := frmMODFLOWPostProcessing.Data.NameList;
                              try  // try 4
                                begin
                                  // create post processing chart
                                  WritePostProcessing(aneHandle,  Names, DataSets,
                                      ChartType, DataLayerName,
                                      aChartLayerType,
                                      MinX, MinY, MaxX, MaxY,
                                      frmMODFLOW.MFLayerStructure.PostProcessingLayers );
                                end; // try 4
                              finally // try 4
                                begin
                                  Names.free;
  //                                Names := nil;
                                end;
                              end  // try 4 finally
                            end;

                        end; // if not (dataLayerHandle = nil) then
                      end; //  if frmMODFLOWPostProcessing.ShowModal = mrOK then
                    finally // try 3.5
                      frmMODFLOWPostProcessing.Free;
                    end;

                  end; //  if frmSelectPostFile.ShowModal = mrOK then
                end; // try 3
              finally // try 3
                begin
                  frmSelectPostFile.Free;
//                  frmMODFLOWPostProcessing.Free;
                end;
              end; // try 3
            end; // try 2
          except
            on EUniformValues do
            begin
              Beep;
              MessageDlg('Error: Data values are uniform. '
                + 'Postprocessing Aborted.',mtError,[mbOK],0);
            end;
            on E: EOutOfMemory do
            begin
              MessageDlg(E.Message,mtError,[mbOK],0);
            end;
            On E: Exception do
            begin
              if frmMODFLOW.PIEDeveloper = '' then
              begin
                ErrorMessage := 'The following error occurred in post-processing PIE. "'
                  + E.Message + '" Contact '
                  + 'PIE Developer for assistance.';
              end
              else
              begin
                ErrorMessage := 'The following error occurred in post-processing PIE. "'
                  + E.Message + '" Contact '
                  + 'PIE Developer (' + frmMODFLOW.PIEDeveloper
                  + ') for assistance.';
              end;
              Beep;
              MessageDlg(ErrorMessage,mtError,[mbOK],0);
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
end;

end.
 