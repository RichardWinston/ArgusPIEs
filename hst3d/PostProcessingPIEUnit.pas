unit PostProcessingPIEUnit;

interface

uses Controls, AnePIE, SysUtils, classes, Dialogs, Forms, StdCtrls;

procedure GPostProcessingPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

function GTimeSeriesPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR): ANE_BOOL; cdecl;

function InternationalStrToFloat(AString : string) : extended;

implementation

uses ANECB, HST3D_PIE_Unit, ThreeDIntListUnit, ThreeDRealListUnit, RealListUnit,
     ThreeDGriddedDataStorageUnit, HST3DGridLayer, IntListUnit, ANE_LayerUnit,
     WritePostProcessingUnit, PostProcessingUnit, HST3DPostProcessingLayers,
     TimeSeriesChart, EvaluateExpression, HST3DObservationElevations,
     ParseContourUnit;

function InternationalStrToFloat(AString : string) : extended;
var
  Index : integer;
begin
  if DecimalSeparator <> '.' then
  begin
    Index := Pos('.',AString);
    if Index > 0 then
    begin
      AString[Index] := DecimalSeparator
    end;
  end;
  result := StrToFloat(AString);
end;

function  CellIsActive(X, Y, Z : Integer; DataValue : double) : boolean;
begin
  result := not (frmPostProcessingForm.BoundList.Items[X, Y, Z] = -1);
end;

function GetCellIndex(APosition : double; CellBoundaries : TRealList) : integer;
  var
  CurrentCellIndex : Integer;
  UpperBoundary, LowerBoundary : double;
begin
  if APosition > CellBoundaries.Items[0] then
  begin
    result := 0;
  end
  else if APosition < CellBoundaries.Items[CellBoundaries.Count -1] then
  begin
    result := CellBoundaries.Count -1
  end
  else
  begin
    UpperBoundary := CellBoundaries.Items[0];
    result := 0;
    for CurrentCellIndex := 1 to CellBoundaries.Count -1 do
    begin
      LowerBoundary := CellBoundaries.Items[CurrentCellIndex];
      if (UpperBoundary >= APosition) and (APosition >= LowerBoundary) then
      begin
        result := CurrentCellIndex -1;
        break;
      end
      else
      begin
        UpperBoundary := LowerBoundary;
      end;
    end;

  end;
  result := CellBoundaries.Count - result -1;
end;

Procedure GetCellBoundaries(CellBoundaries : TRealList);
var
  Limit, CellIndex : integer;
begin
  Limit := StrToInt(PIE_DATA.HST3DForm.edNumLayers.Text);
  for CellIndex := 1 to Limit do
  begin
    CellBoundaries.Add(PIE_DATA.HST3DForm.CellTopElevation(CellIndex));
  end;
  CellBoundaries.Add(PIE_DATA.HST3DForm.CellBottomElevation(Limit));
end;

function ReadObservElevSurface(A3DGridStorage: T3DGridStorage; BoundList : T3DIntegerList) : T3DGridStorage;
var
//  aneHandle : ANE_Ptr;
  layerHandle : ANE_Ptr;
  InfoText : ANE_STR ;
//  InfoTextString : string;
  AStringList :TStringList;
//  InfoTextPtr : ANE_STR_PTR;
  NumRows, NumCol : ANE_INT32;
  MainGridNumRows, MainGridNumCol : ANE_INT32;
  StringToEvaluate : string;
  A3DIntegerList : T3DIntegerList;
  ParamIndex : integer;
  RowIndex, ColumnIndex, CharIndex, RowStart, RowEnd : integer;
  ALine : String;
  ANumberString : String ;
  RowNumber : integer;
  CellBoundaries : TRealList;
//  CellIndex : integer;
//  Limit : integer;
  DataSetIndex : integer;
  A3DRealList, New3DRealList : T3DRealList;
  OK : boolean;
begin
  OK := True;
  result := nil;
  layerHandle := ANE_LayerGetHandleByName(PIE_DATA.HST3DForm.CurrentModelHandle,
     PChar(THST3DGridLayer.ANE_LayerName) );
  if layerHandle = nil then
  begin
    MessageDlg( THST3DGridLayer.ANE_LayerName + ' not found.', mtError, [mbOK], 0);
    OK := False;
  end;
  If OK then
  begin
    StringToEvaluate := 'NumRows()';

    ANE_EvaluateStringAtLayer(PIE_Data.HST3DForm.CurrentModelHandle, layerHandle,
        kPIEInteger, PChar(StringToEvaluate), @MainGridNumRows);

    StringToEvaluate := 'NumColumns()';

    ANE_EvaluateStringAtLayer(PIE_Data.HST3DForm.CurrentModelHandle, layerHandle,
        kPIEInteger, PChar(StringToEvaluate), @MainGridNumCol);

    if (MainGridNumRows <= 0) or (MainGridNumCol <= 0) then
    begin
      MessageDlg('No grid on ' + THST3DGridLayer.ANE_LayerName, mtError, [mbOK], 0);
      OK := False;
    end
  end;
  if OK then
  begin
    layerHandle := ANE_LayerGetHandleByName(PIE_DATA.HST3DForm.CurrentModelHandle,
       PChar(THST3DNodeGridLayer.ANE_LayerName) );
    if layerHandle = nil then
    begin
      MessageDlg( THST3DNodeGridLayer.ANE_LayerName + ' not found.', mtError, [mbOK], 0);
      OK := False;
    end;
  end;
  If OK then
  begin
    StringToEvaluate := 'NumRows()';

    ANE_EvaluateStringAtLayer(PIE_Data.HST3DForm.CurrentModelHandle, layerHandle,
        kPIEInteger, PChar(StringToEvaluate), @NumRows);

    StringToEvaluate := 'NumColumns()';

    ANE_EvaluateStringAtLayer(PIE_Data.HST3DForm.CurrentModelHandle, layerHandle,
        kPIEInteger, PChar(StringToEvaluate), @NumCol);

    if (NumRows <= 0) or (NumCol <= 0) then
    begin
      MessageDlg('No grid on ' + THST3DNodeGridLayer.ANE_LayerName, mtError, [mbOK], 0);
      OK := False;
    end
  end;
  If OK then
  begin
    if (NumRows <> MainGridNumRows + 1) or  (NumCol <> MainGridNumCol + 1) then
    begin
      MessageDlg('Grids on ' + THST3DNodeGridLayer.ANE_LayerName + ' and '
        + THST3DGridLayer.ANE_LayerName + ' do not match.', mtError, [mbOK], 0);
      OK := False;
    end;
  end;
  If OK then
  begin
    ParamIndex := ANE_LayerGetParameterByName(PIE_Data.HST3DForm.CurrentModelHandle,
       layerHandle, PChar(TObsElevGridParameter.ANE_ParamName));
    if ParamIndex < 0 then
    begin
      MessageDlg(TObsElevGridParameter.ANE_ParamName + ' not found on '
        + THST3DNodeGridLayer.ANE_LayerName, mtError, [mbOK], 0);
      OK := False;
    end
  end;
  If OK then
  begin

    ANE_ExportTextFromOtherLayer(PIE_DATA.HST3DForm.CurrentModelHandle,
      layerHandle, @InfoText );

    AStringList := TStringList.Create;
    A3DIntegerList := T3DIntegerList.Create(NumCol, NumRows, 1);
    CellBoundaries := TRealList.Create;
    try
      begin
        AStringList.Text := String(InfoText);

        GetCellBoundaries(CellBoundaries);
{        Limit := StrToInt(PIE_DATA.HST3DForm.edNumLayers.Text);
        for CellIndex := 1 to Limit do
        begin
          CellBoundaries.Add(PIE_DATA.HST3DForm.CellTopElevation(CellIndex));
        end;
        CellBoundaries.Add(PIE_DATA.HST3DForm.CellBottomElevation(Limit)); }

        RowStart := NumRows + NumCol + (ParamIndex +1) * NumRows + 1;
        RowEnd := RowStart + NumRows -1;
        RowNumber := 0;
        for RowIndex := RowStart  to RowEnd do
        begin
          ALine := AStringList.Strings[RowIndex];
          CharIndex := 1;
          While ALine[CharIndex] = ' ' do
          begin
            Inc(CharIndex);
          end;
          for ColumnIndex := 0 to NumCol -1 do
          begin
            ANumberString := '';
            While (CharIndex <= Length(ALine)) and (ALine[CharIndex] <> ' ') do
            begin
              ANumberString := ANumberString + ALine[CharIndex];
              Inc(CharIndex);
            end;
            While (CharIndex <= Length(ALine)) and (ALine[CharIndex] = ' ') do
            begin
              Inc(CharIndex);
            end;
            A3DIntegerList.Items[ColumnIndex,RowNumber,0] :=
              GetCellIndex(StrToFloat(ANumberString), CellBoundaries);
          end;
          Inc(RowNumber)
        end;
        result := T3DGridStorage.Create;
        for DataSetIndex := 0 to A3DGridStorage.Count -1 do
        begin
          A3DRealList := A3DGridStorage.Items[DataSetIndex];
          New3DRealList := T3DRealList.Create(NumCol, NumRows, 1);
          result.Add(New3DRealList, A3DGridStorage.Names[DataSetIndex]);
          For ColumnIndex := 0 to NumCol-1 do
          begin
            For RowIndex := 0 to NumRows-1 do
            begin
              New3DRealList.Items[ColumnIndex,RowIndex,0] :=
                A3DRealList.Items[ColumnIndex,RowIndex,
                  A3DIntegerList.Items[ColumnIndex,RowIndex,0]];
              BoundList.Items[ColumnIndex,RowIndex,0] :=
                BoundList.Items[ColumnIndex,RowIndex,
                  A3DIntegerList.Items[ColumnIndex,RowIndex,0]];
            end;
          end;
        end;


//            Showmessage(AStringList.Strings[0]);
//            Showmessage(AStringList.Strings[1]);
      end;
    finally
      begin
        AStringList.Free;
        A3DIntegerList.Free;
        CellBoundaries.Free;
      end;
    end;
  end;

end;


procedure GPostProcessingPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;
var
  APlotDirection : TPlotDirection;
  dataLayerHandle : ANE_PTR ;
  XCoordList, YCoordList, ZCoordList : TRealList;
  DataSets : TIntegerList;
  PostProcessingLayers : T_ANE_LayerList;
  NameIndex : integer;
  MinX, MinY, MaxX, MaxY : double;
  Names : TStringList;
  ChartType : TChartType;
  PlaneToUse : integer;
  A3DGridStorage : T3DGridStorage;
  DataLayerName : string;
begin
  if EditWindowOpen // only one project can have an edit window open at at time.
  then
    begin
//      result := False;
    end
  else
    begin
      // set EditWindowOpen to prevent other projects from opening a window
      EditWindowOpen := True;
      try
        begin
          Try
            begin
        //    get the private data of the project
              ANE_GetPIEProjectHandle(aneHandle, @PIE_Data );
              // set the current model handle
              PIE_Data.HST3DForm.CurrentModelHandle := aneHandle;
              // create post processing form
              frmPostProcessingForm := TfrmPostProcessingForm.Create(Application);
              try
                begin
                  // show post processing form; user reads data during this step
                  if frmPostProcessingForm.ShowModal = mrOK
                  then
                    begin
                      // set the plot direction
                      APlotDirection := ptXY;
                      case frmPostProcessingForm.rgPlotDirection.ItemIndex of
                        0:
                          begin
                            APlotDirection := ptYZ; //, ptXZ, ptYZ
                          end;
                        1:
                          begin
                            APlotDirection := ptXZ; //, ptXZ, ptYZ
                          end;
                        2, 3:
                          begin
                            APlotDirection := ptXY; //, ptXZ, ptYZ
                          end;
                      end;
                      // get locations of data points.
                      XCoordList := frmPostProcessingForm.XCoordList;
                      YCoordList := frmPostProcessingForm.YCoordList;
                      ZCoordList := frmPostProcessingForm.ZCoordList ;
                      // get indicies to data to be plotted
                      DataSets := frmPostProcessingForm.DataSets;
                      
                      if frmPostProcessingForm.rgPlotDirection.ItemIndex = 3 then
                      begin
                        // get proper data set for user defined surface
                        A3DGridStorage := ReadObservElevSurface
                          (frmPostProcessingForm.ListOfDataGrids,
                          frmPostProcessingForm.BoundList);
//                        DataSets := ReadObservationElevations(frmPostProcessingForm.DataSets);
                        frmPostProcessingForm.ListOfDataGrids.Free;
                        frmPostProcessingForm.ListOfDataGrids := A3DGridStorage;
                        frmPostProcessingForm.ZCoordList.Free;
                        ZCoordList := TRealList.Create;
                        frmPostProcessingForm.ZCoordList := ZCoordList;
                        ZCoordList.Add(0);
//                        Assert(False);
                      end;
                      // get layer list for layers to hold postprocessing charts and data
                      if frmPostProcessingForm.ListOfDataGrids <> nil then
                      begin
                        PostProcessingLayers
                          := PIE_Data.HST3DForm.LayerStructure.PostProcessingLayers;

                        with frmPostProcessingForm do
                        begin
                          for NameIndex := 0 to ListOfDataGrids.Count -1 do
                          begin
                            // set names of data sets
                            ListOfDataGrids.Names[NameIndex] :=
                              ListOfDataGrids.Names[NameIndex] +
                              ' ' + rgPlotDirection.Items[rgPlotDirection.ItemIndex];

                              if frmPostProcessingForm.rgPlotDirection.ItemIndex <> 3 then
                              begin
                                ListOfDataGrids.Names[NameIndex] :=
                                  ListOfDataGrids.Names[NameIndex] +
                                  ' ' + adeWhich.Text;
                              end;
                          end;
                        end;
                        if (frmPostProcessingForm.rgPlotDirection.ItemIndex = 3)
                        then
                          begin
                            PlaneToUse := 0;
                          end
                        else if (frmPostProcessingForm.rgPlotDirection.ItemIndex = 2)
                        then    // plot along a layer
                          begin
                            // planes are numbered in reverse order and thus must be reversed
                            PlaneToUse := StrToInt(PIE_Data.HST3DForm.edNumLayers.Text)-
                              (StrToInt(frmPostProcessingForm.adeWhich.Text)-1);
                          end
                        else  // plot along a row or column
                          begin
                            // planes are numbered in normal order
                            PlaneToUse := StrToInt(frmPostProcessingForm.adeWhich.Text)-1;
                          end;

                        // write data to data layer.
                        DataLayerName := THST3DPostProcessDataLayer.ANE_LayerName;

                        frmPostProcessingForm.ListOfDataGrids.SetArgusData
                          (DataSets, APlotDirection,
                          PlaneToUse, CellIsActive,
                          aneHandle, THST3DPostProcessDataLayer, kGridLayer,
                          XCoordList,
                          YCoordList,
                          ZCoordList,
                          PostProcessingLayers,
                          dataLayerHandle,
                          MinX, MinY, MaxX, MaxY, DataLayerName );
                        // test if data layer created
                        if not (dataLayerHandle = nil) then
                        begin
                           // set chart type
                           ChartType := ctContour;
                           case frmPostProcessingForm.rgPlotType.ItemIndex of
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
                           end;
                           // get list of names
                           Names := frmPostProcessingForm.ListOfDataGrids.NameList;
                           try
                             begin
                               // create post processing chart
                               WritePostProcessing(aneHandle,  Names, DataSets,
                                   ChartType, DataLayerName,
                                   THST3DPostProcessChartLayer,
                                   MinX, MinY, MaxX, MaxY,
                                   PIE_Data.HST3DForm.LayerStructure.PostProcessingLayers );
                             end;
                           finally
                             begin
                               Names.free;
//                               Names := nil;
                             end;
                           end

                      end;
                      end;
                    end;
                end;
              finally
                begin
                  frmPostProcessingForm.Free;
                end;
              end;
            end;
          except
            on EOutOfMemory do
              begin
                MessageDlg('Out of memory', mtError, [mbOK], 0);
              end;
            on E: Exception do
            begin
              MessageDlg('Error in Postprocessing PIE. (' + E.Message 
                + ') Is the PIE installed correctly?', mtError, [mbOK], 0);
            end;
{            begin
              ShowMessage('Error in Postprocessing PIE. '
                + 'Is the PIE installed correctly?');
            end;  }
          end;
        end;
      finally
        begin
          // allow other windows to be opened.
          EditWindowOpen := False;
        end;
      end;
    end;

end;

function GTimeSeriesPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR): ANE_BOOL; cdecl;
var
//  APlotDirection : TPlotDirection;
//  dataLayerHandle : ANE_PTR ;
//  {XCoordList, YCoordList,} ZCoordList : TRealList;
//  DataSets : TIntegerList;
//  PostProcessingLayers : T_ANE_LayerList;
//  NameIndex : integer;
//  MinX, MinY, MaxX, MaxY : double;
//  Names : TStringList;
//  ChartType : TChartType;
//  PlaneToUse : integer;
//  A3DGridStorage : T3DGridStorage;
  CellBoundaries : TRealList;
  GridLayerHandle : ANE_PTR;
  StringToEvaluate : string;
  OK : boolean;
  OuterLimit, InnerLimit : integer;
  ContourIndex, CellIndex : integer;
  ColumnIndex, RowIndex : integer;
  ContourList : TContourList;
  ParamIndex, Param : integer;
  ObsLayerHandle : ANE_PTR ;
  ParamIndexList : TIntegerList;
  ElevationString : string;
  Elevation : double;
  AContour : TContour;
  LayerIndex : integer;
  Index : integer;
  ALine : string;
  AGridPosition : TGridPosition;
  ErrorStep : integer;
  LayerEmpty : integer;
begin
//  ErrorStep := 0;
  result := False;
//  ErrorStep := 1;
  if EditWindowOpen // only one project can have an edit window open at at time.
  then
    begin
//      result := False;
    end
  else
    begin
      // set EditWindowOpen to prevent other projects from opening a window
//      ErrorStep := 2;
      EditWindowOpen := True;
//      ErrorStep := 3;
      try
        begin
          ErrorStep := 4;
          Try
            begin
        //    get the private data of the project
              ErrorStep := 5;
              ANE_GetPIEProjectHandle(aneHandle, @PIE_Data );
              ErrorStep := 6;
              // set the current model handle
              PIE_Data.HST3DForm.CurrentModelHandle := aneHandle;
              ErrorStep := 7;
              // create post processing form
              frmPostProcessingForm := TfrmPostProcessingForm.Create(Application);
              ErrorStep := 8;
              try
                begin
                  ErrorStep := 9;
                  // show post processing form; user reads data during this step
                  frmPostProcessingForm.btnReadDataClick(nil);
                  ErrorStep := 10;
                  if frmPostProcessingForm.rgDataSet.Items.Count > 0 then
                  begin
                    ErrorStep := 11;
                    frmTimeSeries:= TfrmTimeSeries.Create(Application);
                    ErrorStep := 12;
                    CellBoundaries := TRealList.Create;
                    ErrorStep := 13;
                    ContourList := TContourList.Create;
                    ErrorStep := 14;
                    ParamIndexList := TIntegerList.Create;
                    ErrorStep := 15;
                    try
                      begin
                        ErrorStep := 16;
                        for Index := 0 to frmPostProcessingForm.rgDataSet.Items.Count -1 do
                        begin
                          ErrorStep := 17;
                          ALine := frmPostProcessingForm.rgDataSet.Items[Index];
                          ErrorStep := 18;
                          ALine := Trim(Copy(ALine, Pos(')',ALine) + 1, Length(ALine)));
                          ErrorStep := 19;
                          If frmTimeSeries.rgDataTypes.Items.IndexOf(ALine)< 0 then
                          begin
                            ErrorStep := 20;
                            frmTimeSeries.rgDataTypes.Items.Add(ALine);
                            ErrorStep := 21;
                          end;
                          ErrorStep := 22;
                        end;
                        ErrorStep := 23;
                        frmTimeSeries.rgDataTypes.Height := (frmTimeSeries.rgDataTypes.Items.Count+1) * 15;
                        ErrorStep := 24;
                        frmTimeSeries.rgDataTypes.ItemIndex := 0;
                        ErrorStep := 25;
                        GetCellBoundaries(CellBoundaries);
                        ErrorStep := 26;
                        GridLayerHandle := ANE_LayerGetHandleByName(PIE_DATA.HST3DForm.CurrentModelHandle,
                             PChar(THST3DGridLayer.ANE_LayerName) );
                        ErrorStep := 27;

                        OK := (EvalInteger('NumRows()', aneHandle, GridLayerHandle) > 0)
                            and
                           (EvalInteger('NumColumns()', aneHandle,
                            GridLayerHandle) > 0);
                        ErrorStep := 28;
                        if not OK then
                        begin
                          ErrorStep := 29;
                          MessageDlg('No grid on HST3D Grid layer.', mtError, [mbOK], 0);
                          ErrorStep := 30;
                        end;
                        ErrorStep := 31;
                        try
                          begin
                            ErrorStep := 32;
                            if OK then
                            begin
                              ErrorStep := 33;
                              OK := EvalBoolean(
                                 'BL_InitializeGridInformation("HST3D Grid",1)',
                                 aneHandle, GridLayerHandle);
                              ErrorStep := 34;
                              if not OK then
                              begin
                                 ErrorStep := 35;
                                 MessageDlg('HST3D Grid failed to initialize.', mtError, [mbOK], 0);
                                 ErrorStep := 36;
                              end;
                              ErrorStep := 37;
                            end;
                            ErrorStep := 38;
                            If OK then
                            begin
                              ErrorStep := 39;
{                              StringToEvaluate := '!IsLayerEmpty(' + TObsPointsLayer.ANE_Name +
                                '.' + TObsElevParam1.ANE_Name + ')'; }

                              StringToEvaluate := 'If(IsNumber(IsLayerEmpty(' + TObsPointsLayer.ANE_LayerName +
                                '.' + TObsElevParam1.ANE_ParamName + ')), IsLayerEmpty(' + TObsPointsLayer.ANE_LayerName +
                                '.' + TObsElevParam1.ANE_ParamName + '), 2)';

                              ErrorStep := 391;
                              LayerEmpty := EvalInteger(StringToEvaluate,aneHandle, GridLayerHandle);
                              ErrorStep := 392;

                              OK := not (LayerEmpty = 1);
{                                If(IsNumber(IsLayerEmpty()), IsLayerEmpty(Observation Points.Observation Elevation1), 2)}
                              ErrorStep := 40;

//                              OK := EvalBoolean(StringToEvaluate,aneHandle, GridLayerHandle);
//                              ErrorStep := 41;
                              if not OK then
                              begin
                                ErrorStep := 42;
                                MessageDlg('No contours on ' +
                                  TObsPointsLayer.ANE_LayerName + ' layer', mtError,
                                  [mbOK], 0);
                                ErrorStep := 43;
                              end;
                              if LayerEmpty = 2 then
                              begin
                                ErrorStep := 431;
                                MessageDlg('Unable to evaluate "IsLayerEmpty()". ', mtWarning,
                                  [mbOK], 0);
                                ErrorStep := 432;
                              end;

                              ErrorStep := 44;
                            end;
                            ErrorStep := 45;
                            If OK then
                            begin
                              ErrorStep := 46;
                              StringToEvaluate := 'BL_AddVertexLayer("'
                                + TObsPointsLayer.ANE_LayerName + '")';

                              ErrorStep := 47;
                              OK := EvalBoolean(StringToEvaluate,aneHandle, GridLayerHandle);
                              ErrorStep := 48;
                              if not OK then
                              begin
                                ErrorStep := 49;
                                MessageDlg('Error evaluating ' +
                                  TObsPointsLayer.ANE_LayerName + ' layer', mtError,
                                  [mbOK], 0);
                                ErrorStep := 50;
                              end;
                              ErrorStep := 51;
                            end;
                            ErrorStep := 52;
                            If OK then
                            begin
                              ErrorStep := 53;
                              ObsLayerHandle := ANE_LayerGetHandleByName(
                                PIE_DATA.HST3DForm.CurrentModelHandle,
                                PChar(TObsPointsLayer.ANE_LayerName) );
                              ErrorStep := 54;

                              ContourList.ReadContoursFromLayer(aneHandle, ObsLayerHandle);
                              ErrorStep := 55;

                              ParamIndex := 1;
                              ErrorStep := 56;
                              Param := 0;
                              ErrorStep := 57;
                              while ParamIndex > -1 do
                              begin
                                ErrorStep := 58;
                                Inc(Param);
                                ErrorStep := 59;
                                StringToEvaluate := kObservationElev + IntToStr(Param);
                                ErrorStep := 60;

                                ParamIndex := ANE_LayerGetParameterByName(aneHandle,
                                         ObsLayerHandle, PChar( StringToEvaluate));
                                ErrorStep := 61;
                                if ParamIndex > -1 then
                                begin
                                  ErrorStep := 62;
                                  ParamIndexList.Add(ParamIndex);
                                  ErrorStep := 63;
                                end;
                                ErrorStep := 64;
                              end;
                              ErrorStep := 65;


                              StringToEvaluate := 'BL_GetCountOfCellLists() - 1';
                              ErrorStep := 66;

                              OuterLimit := EvalInteger(StringToEvaluate,aneHandle, GridLayerHandle);
                              ErrorStep := 67;
                              For ContourIndex := 0 to OuterLimit do
                              begin
                                ErrorStep := 68;
                                AContour := ContourList.Contours[ContourIndex];
                                ErrorStep := 69;

                                StringToEvaluate := 'BL_GetCountOfACellList('
                                  + IntToStr(ContourIndex) + ') - 1';
                                ErrorStep := 70;

                                InnerLimit := EvalInteger(StringToEvaluate,aneHandle, GridLayerHandle);
                                ErrorStep := 71;

                                for CellIndex := 0 to InnerLimit do
                                begin
                                  ErrorStep := 72;
                                  StringToEvaluate := 'BL_GetCellColumn(' + IntToStr(ContourIndex)
                                    + ',' + IntToStr(CellIndex) + ') - 1';
                                  ErrorStep := 73;

                                  ColumnIndex := EvalInteger(StringToEvaluate,aneHandle, GridLayerHandle);
                                  ErrorStep := 74;

                                  StringToEvaluate := 'BL_GetCellRow(' + IntToStr(ContourIndex)
                                    + ',' + IntToStr(CellIndex) + ') - 1';
                                  ErrorStep := 75;

                                  RowIndex := EvalInteger(StringToEvaluate,aneHandle, GridLayerHandle);
                                  ErrorStep := 76;

                                  for ParamIndex := 0 to ParamIndexList.Count -1 do
                                  begin
                                    ErrorStep := 77;
                                    Param := ParamIndexList.Items[ParamIndex];
                                    ErrorStep := 78;
                                    ElevationString := AContour.Values[Param];
                                    ErrorStep := 79;

                                    if not (ElevationString = '$N/A') then
                                    begin
                                      ErrorStep := 80;
                                      Elevation := InternationalStrToFloat(ElevationString);
                                      ErrorStep := 81;
                                      LayerIndex := GetCellIndex(Elevation, CellBoundaries);
                                      ErrorStep := 82;

                                      AGridPosition := TGridPosition.Create;
                                      ErrorStep := 83;
                                      AGridPosition.Row := RowIndex;
                                      ErrorStep := 84;
                                      AGridPosition.Column := ColumnIndex;
                                      ErrorStep := 85;
                                      AGridPosition.Layer := LayerIndex;
                                      ErrorStep := 86;

                                      frmTimeSeries.GridPositionList.Add( AGridPosition);
                                      ErrorStep := 87;

                                      frmTimeSeries.clbDataSets.Items.Add(
                                        'Column: ' + IntToStr(ColumnIndex) +
                                        '; Row: ' + IntToStr(RowIndex) +
                                        '; Elevation: ' + ElevationString);
//                                      frmTimeSeries.rzclDataSets.Items.Add(
//                                        'Column: ' + IntToStr(ColumnIndex) +
//                                        '; Row: ' + IntToStr(RowIndex) +
//                                        '; Elevation: ' + ElevationString);
                                      ErrorStep := 88;
                                    end; // if not (ElevationString = '$N/A') then
                                    ErrorStep := 89;

                                  end; //  for ParamIndex := 0 to ParamIndexList.Count -1 do
                                  ErrorStep := 90;
                                end;  //  for CellIndex := 0 to InnerLimit do
                                ErrorStep := 91;
                              end; // For ContourIndex := 0 to OuterLimit do
                              ErrorStep := 92;
      {                        if not OK then
                              begin
                                MessageDlg('No contours on ' +
                                  TObsPointsLayer.ANE_Name + ' layer', mtError,
                                  [mbOK], 0);
                              end; }
                            end; // If OK then
                            ErrorStep := 93;
                            if OK then
                            begin
                              ErrorStep := 94;
                              for Index := 0 to frmTimeSeries.clbDataSets.Items.Count -1 do
//                              for Index := 0 to frmTimeSeries.rzclDataSets.Items.Count -1 do
                              begin
                                ErrorStep := 95;
                                frmTimeSeries.clbDataSets.State[Index] := cbChecked;
//                                frmTimeSeries.rzclDataSets.ItemState[Index] := cbChecked;
                                ErrorStep := 96;
                              end;
                              ErrorStep := 97;
                              frmTimeSeries.rgDataTypesClick(nil);
                              ErrorStep := 98;
                              frmTimeSeries.ShowModal;
                              ErrorStep := 99;
                            end;
                            ErrorStep := 100;
                          end;  // try
                        finally
                          begin
                              StringToEvaluate := 'BL_FreeAllBlockLists()';

                              OK := EvalBoolean(StringToEvaluate,aneHandle, GridLayerHandle);
                              if not OK then
                              begin
                                MessageDlg('Error freeing blocklists.', mtError,
                                  [mbOK], 0);
                              end
                          end;
                        end;

                      end
                    finally
                      begin
                        CellBoundaries.Free;
                        ContourList.Free;
                        ParamIndexList.Free;
                        frmTimeSeries.Free;
                      end;
                    end;
                  end;
                  ErrorStep := 112;
{                  if frmPostProcessingForm.ShowModal = mrOK
                  then
                    begin
                      // set the plot direction
                      APlotDirection := ptXY;
                      case frmPostProcessingForm.rgPlotDirection.ItemIndex of
                        0:
                          begin
                            APlotDirection := ptYZ; //, ptXZ, ptYZ
                          end;
                        1:
                          begin
                            APlotDirection := ptXZ; //, ptXZ, ptYZ
                          end;
                        2, 3:
                          begin
                            APlotDirection := ptXY; //, ptXZ, ptYZ
                          end;
                      end;
                      // get locations of data points.
                      XCoordList := frmPostProcessingForm.XCoordList;
                      YCoordList := frmPostProcessingForm.YCoordList;
                      ZCoordList := frmPostProcessingForm.ZCoordList ;
                      // get indicies to data to be plotted
                      DataSets := frmPostProcessingForm.DataSets;

                      if frmPostProcessingForm.rgPlotDirection.ItemIndex = 3 then
                      begin
                        // get proper data set for user defined surface
                        A3DGridStorage := ReadObservElevSurface
                          (frmPostProcessingForm.ListOfDataGrids);
//                        DataSets := ReadObservationElevations(frmPostProcessingForm.DataSets);
                        frmPostProcessingForm.ListOfDataGrids.Free;
                        frmPostProcessingForm.ListOfDataGrids := A3DGridStorage;
                        frmPostProcessingForm.ZCoordList.Free;
                        ZCoordList := TRealList.Create;
                        frmPostProcessingForm.ZCoordList := ZCoordList;
                        ZCoordList.Add(0);
//                        Assert(False);
                      end;
                      // get layer list for layers to hold postprocessing charts and data
                      PostProcessingLayers
                        := PIE_Data.HST3DForm.LayerStructure.PostProcessingLayers;

                      with frmPostProcessingForm do
                      begin
                        for NameIndex := 0 to ListOfDataGrids.Count -1 do
                        begin
                          // set names of data sets
                          ListOfDataGrids.Names[NameIndex] :=
                            ListOfDataGrids.Names[NameIndex] +
                            ' ' + rgPlotDirection.Items[rgPlotDirection.ItemIndex];

                            if frmPostProcessingForm.rgPlotDirection.ItemIndex <> 3 then
                            begin
                              ListOfDataGrids.Names[NameIndex] :=
                                ListOfDataGrids.Names[NameIndex] +
                                ' ' + adeWhich.Text;
                            end;
                        end;
                      end;
                      if (frmPostProcessingForm.rgPlotDirection.ItemIndex = 3)
                      then
                        begin
                          PlaneToUse := 0;
                        end
                      else if (frmPostProcessingForm.rgPlotDirection.ItemIndex = 2)
                      then    // plot along a layer
                        begin
                          // planes are numbered in reverse order and thus must be reversed
                          PlaneToUse := StrToInt(PIE_Data.HST3DForm.edNumLayers.Text)-
                            (StrToInt(frmPostProcessingForm.adeWhich.Text)-1);
                        end
                      else  // plot along a row or column
                        begin
                          // planes are numbered in normal order
                          PlaneToUse := StrToInt(frmPostProcessingForm.adeWhich.Text)-1;
                        end;

                      // write data to data layer.
                      frmPostProcessingForm.ListOfDataGrids.SetArgusData
                        (DataSets, APlotDirection,
                        PlaneToUse, CellIsActive,
                        aneHandle, THST3DPostProcessDataLayer, kGridLayer,
                        XCoordList,
                        YCoordList,
                        ZCoordList,
                        PostProcessingLayers,
                        dataLayerHandle,
                        MinX, MinY, MaxX, MaxY );
                      // test if data layer created
                      if not (dataLayerHandle = nil) then
                      begin
                         // set chart type
                         ChartType := ctContour;
                         case frmPostProcessingForm.rgPlotType.ItemIndex of
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
                         end;
                         // get list of names
                         Names := frmPostProcessingForm.ListOfDataGrids.NameList;
                         try
                           begin
                             // create post processing chart
                             WritePostProcessing(aneHandle,  Names, DataSets,
                                 ChartType, THST3DPostProcessDataLayer.ANE_Name,
                                 THST3DPostProcessChartLayer,
                                 MinX, MinY, MaxX, MaxY,
                                 PIE_Data.HST3DForm.LayerStructure.PostProcessingLayers );
                           end;
                         finally
                           begin
                             Names.free;
                             Names := nil;
                           end;
                         end

                      end;
                    end;}
                end;
              finally
                begin
                  frmPostProcessingForm.Free;
                end;
              end;
            end;
          except
            on E: EOutOfMemory do
            begin
              MessageDlg('"' + E.Message + '" ' + 'Out of memory. Step: ' + IntToStr(ErrorStep), mtError, [mbOK], 0);
            end;
            on E: EOutOfResources do
            begin
              MessageDlg('"' + E.Message + '" ' + 'Out of resources. Step: ' + IntToStr(ErrorStep), mtError, [mbOK], 0);
            end;
            on E: EAccessViolation do
            begin
              MessageDlg('"' + E.Message + '" ' + 'Access Violation. Step: ' + IntToStr(ErrorStep), mtError, [mbOK], 0);
            end;
            on E: EFOpenError do
            begin
              MessageDlg('"' + E.Message + '" ' + 'Error opening file. Step: ' + IntToStr(ErrorStep), mtError, [mbOK], 0);
            end;
            on E: EConvertError do
            begin
              MessageDlg('"' + E.Message + '" ' + 'Conversion Error. Step: ' + IntToStr(ErrorStep), mtError, [mbOK], 0);
            end;
            on E: EOverflow do
            begin
              MessageDlg('"' + E.Message + '" ' + 'Math Error: overflow. Step: ' + IntToStr(ErrorStep), mtError, [mbOK], 0);
            end;
            on E: EUnderflow do
            begin
              MessageDlg('"' + E.Message + '" ' + 'Math Error: underflow. Step: ' + IntToStr(ErrorStep), mtError, [mbOK], 0);
            end;
            on E: EZeroDivide do
            begin
              MessageDlg('"' + E.Message + '" ' + 'Math Error: divide by zero. Step: ' + IntToStr(ErrorStep), mtError, [mbOK], 0);
            end;
            on E: EStringListError do
            begin
              MessageDlg('"' + E.Message + '" ' + 'String List Error. Step: ' + IntToStr(ErrorStep), mtError, [mbOK], 0);
            end;
            on E: Exception do
            begin
              MessageDlg('"' + E.Message + '" ' + 'Error in Postprocessing PIE. Step: ' + IntToStr(ErrorStep), mtError, [mbOK], 0);
            end;
          end;
        end;
      finally
        begin
          // allow other windows to be opened.
          EditWindowOpen := False;
        end;
      end;
    end;

end;


end.
