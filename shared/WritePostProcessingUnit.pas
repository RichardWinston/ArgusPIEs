unit WritePostProcessingUnit;

interface

{WritePostProcessingUnit defines a procedure for creating postprocessing
 charts in Argus ONE}

uses Classes, IntListUnit, SysUtils, AnePIE, Controls, ANE_LayerUnit;

Type TChartType = (ct3D, ctVector, ctColor,
                   ctContour, ctPathLine, ctCrosssection);


function WritePostProcessing(aneHandle : ANE_PTR; NamesList : TStringList;
          ItemsToPlot: TIntegerList;
          ChartType : TChartType; dataLayerName : string;
          AMapLayerType : T_ANE_MapsLayerClass ;
          MinX, MinY, MaxX, MaxY : double; PostProcLayerList : T_ANE_LayerList;
          LayerIndex: integer; const DeletedValues: TIntegerList): boolean;

// WritePostProcessing creates a postprocessing chart on the the AMapLayerType.

// aneHandle is the handle of the current model in Argus ONE.

// NamesList is a list of the parameter names on the data layer for the
// postprocessing charts that will be created. Not all the parameter names
// need to represent actual parameters because only those whose indicies
// are in ItemsToPlot will be plotted.

// ItemsToPlot is a list of the indicies of the items in NamesList to plot.
// For example, if ItemsToPlot contains 2, 4, and 6, the items in NamesList
// whose indicies were 2, 4, and 6 would be plotted.

// ChartType indicates the type of chart to create. At present the Pathline
// chart type is not supported.

// dataLayerName is the name of the data layer that contains the data that
// will be used for the postprocessing charts.

// AMapLayerType is a T_ANE_MapsLayer or one of its descendents.
// The postprocessing charts will be drawn on this layer.
// if the layer does not exist, it will be created.

// MinX, MinY, MaxX, MaxY are the minimum and maximum X and Y coordinates
// of the data points in the source layer in Argus ONE.

// PostProcLayerList is a T_ANE_LayerList that will hold the AMapLayerType;

implementation

uses dialogs, ANECB, FixNameUnit, LayerNamePrompt, UtilityFunctions;

var
  UserResponse : integer = 1;

type
  EBadParamName = Class(Exception);


Function Bool2String(OverlaySource : boolean) : string ;
begin
  if OverlaySource
  then
    begin
      result := '1';
    end
  else
    begin
      result := '0';
    end;
end;

function WriteContourChart(ParameterName, dataLayerName : string ;
         MinX, MinY, XExtent, YExtent : double;
         OverlaySource : boolean ): string;
begin
  result :=
    'Contours Chart:' + Chr(10) +
    '{' + Chr(10) +
    Chr(9) + 'SOURCE LAYER: "' + dataLayerName + '"' + Chr(10) +
    Chr(9) + 'BOUND RECT:' + Chr(10) +
    Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + 'Origin:' + Chr(10) +
    Chr(9) + Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'x: ' + InternationalFloatToStr(MinX) + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'y: ' + InternationalFloatToStr(MinY) + Chr(10) +
    Chr(9) + Chr(9) + '}' + Chr(10) +
    Chr(9) + Chr(9) + 'Extent:' + Chr(10) +
    Chr(9) + Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'x: ' + InternationalFloatToStr(XExtent) + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'y: ' + InternationalFloatToStr(YExtent) + Chr(10) +
    Chr(9) + Chr(9) + '}' + Chr(10) +
    Chr(9) + '}' + Chr(10) +
    Chr(9) + 'Value: "' + ParameterName + '"' + Chr(10) +
    Chr(9) + 'Show Head Title: 1' + Chr(10) +
    Chr(9) + 'Head Title: "' + ParameterName + '"' + Chr(10) +
    Chr(9) + 'Overlay Source Data: ' + Bool2String(OverlaySource) + Chr(10) +
    '}' + Chr(10);
end;


function Write3DChart(ParameterName, dataLayerName : string ;
         MinX, MinY, XExtent, YExtent : double ;
         OverlaySource : boolean ): string ;
begin
result :=
   '3D Chart:' + Chr(10) +
    Chr(9) + '{' + Chr(10) +
    Chr(9) + 'Color: "0"' + Chr(10) +
    Chr(9) + 'SOURCE LAYER: "' + dataLayerName + '"' + Chr(10) +
    Chr(9) + 'BOUND RECT:' + Chr(10) +
    Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + 'Origin:' + Chr(10) +
    Chr(9) + Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'x: ' + InternationalFloatToStr(MinX) + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'y: ' + InternationalFloatToStr(MinY) + Chr(10) +
    Chr(9) + Chr(9) + '}' + Chr(10) +
    Chr(9) + Chr(9) + 'Extent:' + Chr(10) +
    Chr(9) + Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'x: ' + InternationalFloatToStr(XExtent) + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'y: ' + InternationalFloatToStr(YExtent) + Chr(10) +
    Chr(9) + Chr(9) + '}' + Chr(10) +
    Chr(9) + '}' + Chr(10) +
    Chr(9) + 'Show Legend: 1' + Chr(10) +
    Chr(9) + 'Draw Axes: 1' + Chr(10) +
    Chr(9) + 'Show Head Title: 1' + Chr(10) +
    Chr(9) + 'Head Title: "' + ParameterName + '"' + Chr(10) +
    Chr(9) + 'Show Axes Titles: 0' + Chr(10) +
    Chr(9) + 'Keep Ratio: 1' + Chr(10) +
    Chr(9) + 'Parameter: "' + ParameterName + '"' + Chr(10) +
    Chr(9) + 'Top Color Value: "' + ParameterName + '"' + Chr(10) +
    Chr(9) + 'Matrix: { Cell11:0.925416578398323 Cell12: -0.163175911166535 Cell13: 0.342020143325669 Cell14: 0' + Chr(10) +
    Chr(9) + 'Cell21:0.378522306369792 Cell22: 0.440969610529883 Cell23: -0.813797681349374 Cell24: 0' + Chr(10) +
    Chr(9) + 'Cell31:-0.0180283112362973 Cell32: 0.882564119259385 Cell33: 0.469846310392954 Cell34: 0' + Chr(10) +
    Chr(9) + 'Cell41:0 Cell42: 0 Cell43: 0 Cell44: 1' + Chr(10) +
    Chr(9) + '}' + Chr(10) +
    Chr(9) + 'Show Color: 1' + Chr(10) +
    Chr(9) + 'Add Shading: 1' + Chr(10) +
    '}' + Chr(10);

end;

function WriteColorChart(ParameterName, dataLayerName : string ;
         MinX, MinY, XExtent, YExtent : double;
         OverlaySource : boolean ): string ;
begin

result :=
    'Color Map Chart' + Chr(10) +
    Chr(9) + '{' + Chr(10) +
    Chr(9) + 'Color: "0"' + Chr(10) +
    Chr(9) + 'SOURCE LAYER: "' + dataLayerName + '"' + Chr(10) +
    Chr(9) + 'BOUND RECT:' + Chr(10) +
    Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + 'Origin:' + Chr(10) +
    Chr(9) + Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'x: ' + InternationalFloatToStr(MinX) + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'y: ' + InternationalFloatToStr(MinY) + Chr(10) +
    Chr(9) + Chr(9) + '}' + Chr(10) +
    Chr(9) + Chr(9) + 'Extent:' + Chr(10) +
    Chr(9) + Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'x: ' + InternationalFloatToStr(XExtent) + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'y: ' + InternationalFloatToStr(YExtent) + Chr(10) +
    Chr(9) + Chr(9) + '}' + Chr(10) +
    Chr(9) + '}' + Chr(10) +
    Chr(9) + 'Overlay Source Data: ' + Bool2String(OverlaySource) + Chr(10) +
    Chr(9) + 'Show Legend: 1' + Chr(10) +
    Chr(9) + 'Draw Axes: 1' + Chr(10) +
    Chr(9) + 'Show Head Title: 1' + Chr(10) +
    Chr(9) + 'Head Title: "' + ParameterName + '"' + Chr(10) +
    Chr(9) + 'Show Axes Titles: 0' + Chr(10) +
    Chr(9) + 'Keep Ratio: 1' + Chr(10) +
    Chr(9) + 'Value: "' + ParameterName + '"' + Chr(10) +
    '}' + Chr(10);
end;

function WriteCrossSectionChart(ParameterName, dataLayerName : string ;
         MinX, MinY, XExtent, YExtent : double;
         OverlaySource : boolean ;
         LineXMin, LineXMax, LineY : double ): string ;
begin
result :=
    'CrossSection Chart' + Chr(10) +
    Chr(9) + '{' + Chr(10) +
    Chr(9) + 'Color: "0"' + Chr(10) +
    Chr(9) + 'SOURCE LAYER: "' + dataLayerName + '"' + Chr(10) +
    Chr(9) + 'BOUND RECT:' + Chr(10) +
    Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + 'Origin:' + Chr(10) +
    Chr(9) + Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'x: ' + InternationalFloatToStr(MinX) + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'y: ' + InternationalFloatToStr(MinY) + Chr(10) +
    Chr(9) + Chr(9) + '}' + Chr(10) +
    Chr(9) + Chr(9) + 'Extent:' + Chr(10) +
    Chr(9) + Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'x: ' + InternationalFloatToStr(XExtent) + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'y: ' + InternationalFloatToStr(YExtent) + Chr(10) +
    Chr(9) + Chr(9) + '}' + Chr(10) +
    Chr(9) + '}' + Chr(10) +
    Chr(9) + 'Show Legend: 1' + Chr(10) +
    Chr(9) + 'Draw Axes: 1' + Chr(10) +
    Chr(9) + 'Show Head Title: 1' + Chr(10) +
    Chr(9) + 'Head Title: "' + ParameterName + '"' + Chr(10) +
    Chr(9) + 'Show Axes Titles: 0' + Chr(10) +
    Chr(9) + 'Keep Ratio: 1' + Chr(10) +
    Chr(9) + 'Parameter: "' + ParameterName + '"' + Chr(10) +
    Chr(9) + 'Polygon: {' + Chr(10) +
    Chr(9) + 'Vertex:' + Chr(10) +
    Chr(9) + '{' + Chr(10) +
    Chr(9) +  Chr(9) + 'x: ' + InternationalFloatToStr(LineXMin) + Chr(10) +
    Chr(9) +  Chr(9) + 'y: ' + InternationalFloatToStr(LineY) + Chr(10) +
    Chr(9) + '}' + Chr(10) +
    Chr(9) + 'Vertex:' + Chr(10) +
    Chr(9) + '{' + Chr(10) +
    Chr(9) +  Chr(9) + 'x: ' + InternationalFloatToStr(LineXMax) + Chr(10) +
    Chr(9) +  Chr(9) + 'y: ' + InternationalFloatToStr(LineY) + Chr(10) +
    Chr(9) + '}' + Chr(10) +
    Chr(9) + 'Use Color: 1' + Chr(10) +
    '}' + Chr(10);

end;

function WriteVectorChart(ParameterName, SecondParameterName,
         dataLayerName : string ;
         MinX, MinY, XExtent, YExtent : double;
         OverlaySource : boolean ): string;
begin
  result :=
   'Arrows Chart:' + Chr(10) +
    Chr(9) + '{' + Chr(10) +
    Chr(9) + 'Color: "0"' + Chr(10) +
    Chr(9) + 'SOURCE LAYER: "' + dataLayerName + '"' + Chr(10) +
    Chr(9) + 'BOUND RECT:' + Chr(10) +
    Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + 'Origin:' + Chr(10) +
    Chr(9) + Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'x: ' + InternationalFloatToStr(MinX) + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'y: ' + InternationalFloatToStr(MinY) + Chr(10) +
    Chr(9) + Chr(9) + '}' + Chr(10) +
    Chr(9) + Chr(9) + 'Extent:' + Chr(10) +
    Chr(9) + Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'x: ' + InternationalFloatToStr(XExtent) + Chr(10) +
    Chr(9) + Chr(9) + Chr(9) + 'y: ' + InternationalFloatToStr(YExtent) + Chr(10) +
    Chr(9) + Chr(9) + '}' + Chr(10) +
    Chr(9) + '}' + Chr(10) +
    Chr(9) + 'Overlay Source Data: ' + Bool2String(OverlaySource) + Chr(10) +
    Chr(9) + 'Show Legend: 1' + Chr(10) +
    Chr(9) + 'Draw Axes: 1' + Chr(10) +
    Chr(9) + 'Show Head Title: 1' + Chr(10) +
    Chr(9) + 'Head Title: "' + ParameterName + ' ' + SecondParameterName + '"' + Chr(10) +
    Chr(9) + 'Show Axes Titles: 0' + Chr(10) +
    Chr(9) + 'Keep Ratio: 1' + Chr(10) +
    Chr(9) + 'X Value: "' + ParameterName + '"' + Chr(10) +
    Chr(9) + 'Y Value: "' + SecondParameterName + '"' + Chr(10) +
    Chr(9) + 'Color By Length: 1' + Chr(10) +
    Chr(9) + 'Thickness: 2' + Chr(10) +
    '}' + Chr(10);

end;

function WritePostProcessing(aneHandle : ANE_PTR; NamesList : TStringList;
          ItemsToPlot: TIntegerList;
          ChartType : TChartType; dataLayerName : string;
          AMapLayerType : T_ANE_MapsLayerClass ;
          MinX, MinY, MaxX, MaxY : double; PostProcLayerList : T_ANE_LayerList;
          LayerIndex: integer; const DeletedValues: TIntegerList): boolean;
var
  OverlaySource : boolean; // determine whether the map should overlay the data points.
  ChartRows, ChartColumns : integer;
  RowIndex, ColumnIndex : Integer;
  DataSetIndex : Integer;
  ChartWidth, ChartHeight : double;
  ChartXMin, ChartYMin : double;
  StringToWrite : string ;
  ParameterName, SecondParameterName : string;
  maplayerhandle, dataLayerHandle : ANE_PTR;
  A_MapsLayer : T_ANE_MapsLayer;
  ChartCount : integer;
  MapLayerName : string;
  OldMapLayerName : string;
  AString : ANE_STR;
  LayerTemplate : string;
  ANE_LayerTemplate : ANE_STR;
  NamePos : integer;
begin
  result := True;
  if (ChartType = ctVector) and not ((ItemsToPlot.Count mod 2) = 0) then
  begin
    Beep;
    ShowMessage('You must select pairs of items for vector plots.');
  end
  else
  begin
    if (ChartType = ctVector) then
    begin
      ChartCount := Round(ItemsToPlot.Count/2);
    end
    else
    begin
      ChartCount := ItemsToPlot.Count;
    end;
    OverlaySource := (ChartCount = 1);
    if OverlaySource then
    begin
      ChartRows := 1;
      ChartColumns := 1;
    end
    else
    begin
      ChartRows := Trunc(Sqrt(ChartCount));
      if Trunc(ChartCount/ChartRows) = ChartCount/ChartRows then
      begin
        ChartColumns := Trunc(ChartCount/ChartRows);
      end
      else
      begin
        ChartColumns := Trunc(ChartCount/ChartRows) + 1;
      end
    end;
    ChartWidth  := (MaxX - MinX)/ChartColumns;
    ChartHeight := (MaxY - MinY)/ChartRows;
    if (ChartWidth = 0) and (ChartHeight = 0) then
    begin
      ChartHeight := 1;
      ChartWidth := 1;
    end
    else if (ChartWidth = 0) then
    begin
      ChartWidth := ChartHeight;
    end
    else if (ChartHeight = 0) then
    begin
      ChartHeight := ChartWidth;
    end;
    DataSetIndex := 0;
    StringToWrite := '*' + Chr(10);
    For RowIndex := 0 to ChartRows -1 do
    begin
      ChartYMin := MinY + RowIndex * ChartHeight;
      For ColumnIndex := 0 to ChartColumns -1 do
      begin
        if DeletedValues.IndexOf(DataSetIndex) < 0 then
        begin
          if ((DataSetIndex < ChartCount*2) and (ChartType = ctVector))
            or ((DataSetIndex < ChartCount) and (ChartType <> ctVector)) then

          begin
            ParameterName := NamesList.Strings[ItemsToPlot.items[DataSetIndex]];
            if not (ParameterName = FixArgusName(ParameterName)) then
            begin
              raise EBadParamName.Create(ParameterName +
                ' is not a valid name for and ArgusONE parameter.');
            end;

            if (ChartType = ctVector) then
            begin
              SecondParameterName := NamesList.Strings[ItemsToPlot.items[DataSetIndex+1]];
              if not (SecondParameterName = FixArgusName(SecondParameterName)) then
              begin
                raise EBadParamName.Create(ParameterName +
                  ' is not a valid name for and ArgusONE parameter.');
              end;
            end;
            ChartXMin := MinX + ColumnIndex * ChartWidth;
            case ChartType of
              ct3D:
                begin
                  StringToWrite := StringToWrite +
                    Write3DChart(ParameterName, dataLayerName ,
                      ChartXMin, ChartYMin, ChartWidth*0.9, ChartHeight*0.9,
                      OverlaySource  );
                end;
              ctVector:
                begin
                  StringToWrite := StringToWrite +
                     WriteVectorChart(ParameterName,
                     SecondParameterName, dataLayerName,
                     ChartXMin, ChartYMin, ChartWidth*0.9, ChartHeight*0.9,
                      OverlaySource  );
                end;
              ctColor:
                begin
                  StringToWrite := StringToWrite +
                    WriteColorChart(ParameterName, dataLayerName ,
                      ChartXMin, ChartYMin, ChartWidth*0.9, ChartHeight*0.9,
                      OverlaySource  );
                end;
              ctContour:
                begin
                  StringToWrite := StringToWrite +
                    WriteContourChart(ParameterName, dataLayerName ,
                      ChartXMin, ChartYMin, ChartWidth*0.9, ChartHeight*0.9,
                      OverlaySource  );
                end;
              ctPathLine :
                begin
                end;
              ctCrosssection :
                begin
                  StringToWrite := StringToWrite +
                    WriteCrossSectionChart(ParameterName, dataLayerName,
                    ChartXMin, ChartYMin, ChartWidth*0.9, ChartHeight*0.9,
                    OverlaySource, MinX, MaxX, MinY + ChartHeight/2);
                end;
            end;
          end
          else
          begin
            break;
          end;

        end;


        Inc(DataSetIndex);
        if (ChartType = ctVector) then
        begin
          Inc(DataSetIndex);
        end;
      end;
    end;
  //  maplayerhandle := nil;
    MapLayerName := AMapLayerType.WriteNewRoot;
    if LayerIndex >= 0 then
    begin
      MapLayerName := MapLayerName + IntToStr(LayerIndex+1);
    end;
    maplayerhandle := GetLayerHandle(aneHandle,MapLayerName);
    if maplayerhandle = nil then

    begin
      dataLayerHandle := GetLayerHandle(anehandle, dataLayerName);
      if not (dataLayerHandle = nil) then
      begin
        A_MapsLayer := AMapLayerType.Create( PostProcLayerList, -1);
        A_MapsLayer.Lock := [];
        MapLayerName := A_MapsLayer.WriteSpecialBeginning
                + A_MapsLayer.WriteNewRoot
                + A_MapsLayer.WriteSpecialMiddle
                + A_MapsLayer.WriteIndex
                + A_MapsLayer.WriteSpecialEnd;
        LayerTemplate := A_MapsLayer.WriteLayer(aneHandle);
        if LayerIndex >= 0 then
        begin
          NamePos := Pos(MapLayerName, LayerTemplate);
          if NamePos > 0 then
          begin
            System.Insert(IntToStr(LayerIndex+1), LayerTemplate, NamePos+Length(MapLayerName));
            MapLayerName := MapLayerName + IntToStr(LayerIndex+1);
          end;
        end;
        GetMem(ANE_LayerTemplate, Length(LayerTemplate) + 1);
        try
          StrPCopy(ANE_LayerTemplate, LayerTemplate);
          maplayerhandle := ANE_LayerAddByTemplate(aneHandle ,
                   ANE_LayerTemplate, dataLayerHandle  );
          ANE_ProcessEvents(aneHandle);
        finally
          FreeMem(ANE_LayerTemplate);
        end;
        A_MapsLayer.Free;
      end;

    end
    else
    begin
      OldMapLayerName := MapLayerName;
      GetValidLayer(aneHandle,maplayerhandle,AMapLayerType,MapLayerName,
        PostProcLayerList, UserResponse, MapLayerName, True);
      if (OldMapLayerName = MapLayerName) and (maplayerhandle <> nil) then
      begin
        ANE_LayerClear(aneHandle, maplayerhandle, False )
      end;
    end;
    if maplayerhandle = nil then
    begin
      result:= False;
      Beep;
      ShowMessage('No postprocessing layer available');
    end
    else
    begin
      Try
        begin
           GetMem(AString, Length(StringToWrite) + 1);
           try
             StrPCopy(AString, StringToWrite);

              ANE_ImportTextToLayerByHandle(aneHandle , maplayerhandle,
                AString);
              ANE_ProcessEvents(aneHandle);
           finally
             FreeMem(AString);
           end;
        end
      except On E: Exception do
        begin
          Beep;
          MessageDlg('The following error occurred while creating Chart. "'
           + E.Message + '"', mtError, [mbOK],0);
        end
      end;
    end;
  end; // if (ChartType = ctVector) and not ((ItemsToPlot.Count mod 2) = 0) else
end;

end.
