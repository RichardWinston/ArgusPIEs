unit WriteSutraPostProcessingUnit;

interface

{WritePostProcessingUnit defines a procedure for creating postprocessing
 charts in Argus ONE}

uses Classes, IntListUnit, SysUtils, AnePIE, Controls, ANE_LayerUnit;

Type TChartType = (ct3D, ctVector, ctColor,
                   ctContour, ctPathLine, ctCrosssection);


function WriteSutraPostProcessing(aneHandle : ANE_PTR; NamesList,
          TitlesList : TStringList;
          ItemsToPlot: TIntegerList;
          ChartType : TChartType; dataLayerName : string;
          AMapLayerType : T_ANE_MapsLayerClass ;
          MinX, MinY, MaxX, MaxY : double; PostProcLayerList : T_ANE_LayerList;
          UseExistingMapLayer : boolean; var MapLayerName : string;
          ChartCount : integer; ChartPositions: TIntegerList;
          CalculateDelta : boolean; Min,Max,Delta : double;
          var maplayerhandle : ANE_PTR; DrawAxes : boolean; DataIndex: integer = 0) : string ;

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
  StringToWrite : string ;


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
         OverlaySource : boolean; Title : String;
         CalculateDelta : boolean; Min,Max,Delta : double; DrawAxes : boolean): string;
begin
  result :=
    'Contours Chart:' + {Chr(10) +}
    '{' + {Chr(10) +}
    {Chr(9) +} 'Color: "0"' + Chr(10) +
    {Chr(9) +} 'Source Layer: "' + dataLayerName + '"' + Chr(10) +
    {Chr(9) +} 'Bound Rect:' + {Chr(10) +}
    {Chr(9) +} ' { ' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} 'Origin:' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} ' { ' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'x: ' + InternationalFloatToStr(MinX) + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'y: ' + InternationalFloatToStr(MinY) + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} {Chr(9) +} 'Extent:' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} '{' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'x: ' + InternationalFloatToStr(XExtent) + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'y: ' + InternationalFloatToStr(YExtent) + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} '}' + {Chr(10) +}
    {Chr(9) +} '}' + Chr(10) +

    {Chr(9) +} 'Show Legend: 1' + Chr(10) +
    {Chr(9) +} 'Draw Axes: ' + Bool2String(DrawAxes) + Chr(10) +
    {Chr(9) +} 'Draw Bounding Box: 0' + Chr(10) +
    {Chr(9) +} 'Show Head Title: 1' + Chr(10) +
    {Chr(9) +} 'Head Title: "' + Title + '"' + Chr(10) +

    {Chr(9) +} 'Show Axes Titles: 0' + Chr(10) +
    {Chr(9) +} 'Keep Ratio: 1' + Chr(10) +

    {Chr(9) +} 'Value: "' + ParameterName + '"' + Chr(10) +

    {Chr(9) +} 'Contouring Algorithm: LINEAR' + Chr(10) +
    {Chr(9) +} 'Show Color: 1' + Chr(10) +
    {Chr(9) +} 'Thickness: 2' + Chr(10) +
    {Chr(9) +} 'Show Head Title: 1' + Chr(10) +
    {Chr(9) +} 'Overlay Source Data: ' + Bool2String(OverlaySource) + Chr(10) +
    {Chr(9) +} 'Show Values: 0' + Chr(10);

    if CalculateDelta then
    begin
      result := result
        + {Chr(9) +} 'Calculate Values: 1' + Chr(10);
    end
    else
    begin
      result := result
        + {Chr(9) +} 'Calculate Values: 0' + Chr(10)
        + {Chr(9) +} 'Minimum Value: ' + InternationalFloatToStr(Min)  + Chr(10)
        + {Chr(9) +} 'Maximum Value: ' + InternationalFloatToStr(Max)  + Chr(10)
        + {Chr(9) +} 'Delta: ' + InternationalFloatToStr(Delta)  + Chr(10);
    end;  

    result := result +'}' + Chr(10);
end;


function Write3DChart(ParameterName, dataLayerName : string ;
         MinX, MinY, XExtent, YExtent : double ;
         OverlaySource : boolean; Title : String; DrawAxes : boolean ): string ;
begin
result :=
   '3D Chart:' + {Chr(10) +}
    {Chr(9) +} '{' + {Chr(10) +}
    {Chr(9) +} 'Color: "0"' + Chr(10) +
    {Chr(9) +} 'Source Layer: "' + dataLayerName + '"' + Chr(10) +
    {Chr(9) +} 'Bound Rect:' + Chr(10) +
    {Chr(9) +} '{' + Chr(10) +
    {Chr(9) +} {Chr(9) +} 'Origin:' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} ' { ' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'x: ' + InternationalFloatToStr(MinX) + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'y: ' + InternationalFloatToStr(MinY) + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} '}' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} 'Extent:' + Chr(10) +
    {Chr(9) +} {Chr(9) +} '{' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'x: ' + InternationalFloatToStr(XExtent) + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'y: ' + InternationalFloatToStr(YExtent) + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} '}' + {Chr(10) +}
    {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} 'Show Legend: 1' + Chr(10) +
    {Chr(9) +} 'Draw Axes: ' + Bool2String(DrawAxes) + Chr(10) +
    {Chr(9) +} 'Draw Bounding Box: 0' + Chr(10) +
    {Chr(9) +} 'Show Head Title: 1' + Chr(10) +
    {Chr(9) +} 'Head Title: "' + Title + '"' + Chr(10) +
    {Chr(9) +} 'Show Axes Titles: 0' + Chr(10) +
    {Chr(9) +} 'Keep Ratio: 1' + Chr(10) +
    {Chr(9) +} 'Parameter: "' + ParameterName + '"' + Chr(10) +
    {Chr(9) +} 'Top Color Value: "' + ParameterName + '"' + Chr(10) +
    {Chr(9) +} 'Matrix: { Cell11:0.925416578398323 Cell12: -0.163175911166535 Cell13: 0.342020143325669 Cell14: 0' + Chr(10) +
    {Chr(9) +} 'Cell21:0.378522306369792 Cell22: 0.440969610529883 Cell23: -0.813797681349374 Cell24: 0' + Chr(10) +
    {Chr(9) +} 'Cell31:-0.0180283112362973 Cell32: 0.882564119259385 Cell33: 0.469846310392954 Cell34: 0' + Chr(10) +
    {Chr(9) +} 'Cell41:0 Cell42: 0 Cell43: 0 Cell44: 1' + Chr(10) +
    {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} 'Show Color: 1' + Chr(10) +
    {Chr(9) +} 'Add Shading: 1' + Chr(10) +
    '}' + Chr(10);

end;

function WriteColorChart(ParameterName, dataLayerName : string ;
         MinX, MinY, XExtent, YExtent : double;
         OverlaySource : boolean; Title : String; DrawAxes : boolean): string ;
begin

result :=
    'Color Map Chart' + {Chr(10) +}
    {Chr(9) +} '{' + {Chr(10) +}
    {Chr(9) +} 'Color: "0"' + Chr(10) +
    {Chr(9) +} 'Source Layer: "' + dataLayerName + '"' + Chr(10) +
    {Chr(9) +} 'Bound Rect:' + Chr(10) +
    {Chr(9) +} '{' + Chr(10) +
    {Chr(9) +} {Chr(9) +} 'Origin:' + Chr(10) +
    {Chr(9) +} {Chr(9) +} '{' + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'x: ' + InternationalFloatToStr(MinX) + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'y: ' + InternationalFloatToStr(MinY) + Chr(10) +
    {Chr(9) +} {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} {Chr(9) +} 'Extent:' + Chr(10) +
    {Chr(9) +} {Chr(9) +} '{' + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'x: ' + InternationalFloatToStr(XExtent) + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'y: ' + InternationalFloatToStr(YExtent) + Chr(10) +
    {Chr(9) +} {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} 'Overlay Source Data: ' + Bool2String(OverlaySource) + Chr(10) +
    {Chr(9) +} 'Show Legend: 1' + Chr(10) +
    {Chr(9) +} 'Draw Axes: ' + Bool2String(DrawAxes) + Chr(10) +
    {Chr(9) +} 'Draw Bounding Box: 0' + Chr(10) +
    {Chr(9) +} 'Show Head Title: 1' + Chr(10) +
    {Chr(9) +} 'Head Title: "' + Title + '"' + Chr(10) +
    {Chr(9) +} 'Show Axes Titles: 0' + Chr(10) +
    {Chr(9) +} 'Keep Ratio: 1' + Chr(10) +
    {Chr(9) +} 'Value: "' + ParameterName + '"' + Chr(10) +
    '}' + Chr(10);
end;

function WriteCrossSectionChart(ParameterName, dataLayerName : string ;
         MinX, MinY, XExtent, YExtent : double;
         OverlaySource : boolean ;
         LineXMin, LineXMax, LineY : double; Title : String; DrawAxes : boolean): string ;
begin
result :=
    'CrossSection Chart' + {Chr(10) +}
    {Chr(9) +} '{' + {Chr(10) +}
    {Chr(9) +} 'Color: "0"' + Chr(10) +
    {Chr(9) +} 'Source Layer: "' + dataLayerName + '"' + Chr(10) +
    {Chr(9) +} 'Bound Rect:' + Chr(10) +
    {Chr(9) +} '{' + Chr(10) +
    {Chr(9) +} {Chr(9) +} 'Origin:' + Chr(10) +
    {Chr(9) +} {Chr(9) +} '{' + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'x: ' + InternationalFloatToStr(MinX) + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'y: ' + InternationalFloatToStr(MinY) + Chr(10) +
    {Chr(9) +} {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} {Chr(9) +} 'Extent:' + Chr(10) +
    {Chr(9) +} {Chr(9) +} '{' + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'x: ' + InternationalFloatToStr(XExtent) + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'y: ' + InternationalFloatToStr(YExtent) + Chr(10) +
    {Chr(9) +} {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} 'Show Legend: 1' + Chr(10) +
    {Chr(9) +} 'Draw Axes: ' + Bool2String(DrawAxes) + Chr(10) +
    {Chr(9) +} 'Draw Bounding Box: 0' + Chr(10) +
    {Chr(9) +} 'Show Head Title: 1' + Chr(10) +
    {Chr(9) +} 'Head Title: "' + Title + '"' + Chr(10) +
    {Chr(9) +} 'Show Axes Titles: 0' + Chr(10) +
    {Chr(9) +} 'Keep Ratio: 1' + Chr(10) +
    {Chr(9) +} 'Parameter: "' + ParameterName + '"' + Chr(10) +
    {Chr(9) +} 'Polygon: {' + Chr(10) +
    {Chr(9) +} 'Vertex:' + Chr(10) +
    {Chr(9) +} '{' + Chr(10) +
    {Chr(9) +}  {Chr(9) +} 'x: ' + InternationalFloatToStr(LineXMin) + Chr(10) +
    {Chr(9) +}  {Chr(9) +} 'y: ' + InternationalFloatToStr(LineY) + Chr(10) +
    {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} 'Vertex:' + Chr(10) +
    {Chr(9) +} '{' + Chr(10) +
    {Chr(9) +}  {Chr(9) +} 'x: ' + InternationalFloatToStr(LineXMax) + Chr(10) +
    {Chr(9) +}  {Chr(9) +} 'y: ' + InternationalFloatToStr(LineY) + Chr(10) +
    {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} 'Use Color: 1' + Chr(10) +
    '}' + Chr(10);

end;

function WriteVectorChart(ParameterName, SecondParameterName,
         dataLayerName : string ;
         MinX, MinY, XExtent, YExtent : double;
         OverlaySource : boolean; Title : String; DrawAxes : boolean): string;
begin
  result :=
   'Arrows Chart:' + {Chr(10) +}
    {Chr(9) +} '{' + {Chr(10) +}
    {Chr(9) +} 'Color: "0"' + Chr(10) +
    {Chr(9) +} 'Source Layer: "' + dataLayerName + '"' + Chr(10) +
    {Chr(9) +} 'Bound Rect:' + {Chr(10) +}
    {Chr(9) +} ' { ' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} 'Origin:' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} ' { ' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'x: ' + InternationalFloatToStr(MinX) + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'y: ' + InternationalFloatToStr(MinY) + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} {Chr(9) +} 'Extent:' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} '{' + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'x: ' + InternationalFloatToStr(XExtent) + Chr(10) +
    {Chr(9) +} {Chr(9) +} {Chr(9) +} 'y: ' + InternationalFloatToStr(YExtent) + {Chr(10) +}
    {Chr(9) +} {Chr(9) +} '}' + {Chr(10) +}
    {Chr(9) +} '}' + Chr(10) +
    {Chr(9) +} 'Overlay Source Data: ' + Bool2String(OverlaySource) + Chr(10) +
    {Chr(9) +} 'Show Legend: 1' + Chr(10) +
    {Chr(9) +} 'Draw Axes: ' + Bool2String(DrawAxes) + Chr(10) +
    {Chr(9) +} 'Draw Bounding Box: 0' + Chr(10) +
    {Chr(9) +} 'Show Head Title: 1' + Chr(10) +
    {Chr(9) +} 'Head Title: "' + Title + '"' + Chr(10) +
    {Chr(9) +} 'Show Axes Titles: 0' + Chr(10) +
    {Chr(9) +} 'Keep Ratio: 1' + Chr(10) +
    {Chr(9) +} 'X Value: "' + ParameterName + '"' + Chr(10) +
    {Chr(9) +} 'Y Value: "' + SecondParameterName + '"' + Chr(10) +
    {Chr(9) +} 'Color By Length: 0' + Chr(10) +
    {Chr(9) +} 'Thickness: 1' + Chr(10) +
    '}' + Chr(10);

end;

function WriteSutraPostProcessing(aneHandle : ANE_PTR; NamesList,
          TitlesList : TStringList;
          ItemsToPlot: TIntegerList;
          ChartType : TChartType; dataLayerName : string;
          AMapLayerType : T_ANE_MapsLayerClass ;
          MinX, MinY, MaxX, MaxY : double; PostProcLayerList : T_ANE_LayerList;
          UseExistingMapLayer : boolean; var MapLayerName : string;
          ChartCount : integer; ChartPositions: TIntegerList;
          CalculateDelta : boolean; Min,Max,Delta : double;
          var maplayerhandle : ANE_PTR; DrawAxes : boolean; DataIndex: integer = 0) : string;
var
  OverlaySource : boolean; // determine whether the map should overlay the data points.
  ChartRows, ChartColumns : integer;
  RowIndex, ColumnIndex : Integer;
  DataSetIndex : Integer;
  ChartWidth, ChartHeight : double;
  ChartXMin, ChartYMin : double;
  ParameterName, SecondParameterName : string;
  {maplayerhandle,} dataLayerHandle : ANE_PTR;
  A_MapsLayer : T_ANE_MapsLayer;
  ChartIndex : integer;
  Title: String;
  Template : string;
  ANE_LayerTemplate : ANE_STR;
begin
  if (ChartType = ctVector) and not ((ItemsToPlot.Count mod 2) = 0) then
  begin
    Beep;
    ShowMessage('You must select pairs of items for vector plots.');
  end
  else
  begin
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
    StringToWrite := '';
    While (DataSetIndex < ItemsToPlot.Count) do
    begin
      if (ChartType = ctVector) then
      begin
        ChartIndex := ChartPositions.Items[DataSetIndex div 2];
        Title := TitlesList[ItemsToPlot.items[DataSetIndex] div 2];
      end
      else
      begin
        ChartIndex := ChartPositions.Items[DataSetIndex];
        Title := TitlesList[ItemsToPlot.items[DataSetIndex]];
      end;
      RowIndex := ChartIndex mod ChartRows;
      ColumnIndex := ChartIndex div ChartRows;
      ChartYMin := MinY + RowIndex * ChartHeight;
      ChartXMin := MinX + ColumnIndex * ChartWidth;

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
      if not DrawAxes then
      begin
        Title := '';
      end;
      case ChartType of
         ct3D:
           begin
             StringToWrite := StringToWrite +
               Write3DChart(ParameterName, dataLayerName ,
                 ChartXMin, ChartYMin, ChartWidth*0.9, ChartHeight*0.9,
                 OverlaySource, Title, DrawAxes);
           end;
         ctVector:
           begin
             StringToWrite := StringToWrite +
                WriteVectorChart(ParameterName,
                SecondParameterName, dataLayerName,
                ChartXMin, ChartYMin, ChartWidth*0.9, ChartHeight*0.9,
                 OverlaySource, Title, DrawAxes);
           end;
         ctColor:
           begin
             StringToWrite := StringToWrite +
               WriteColorChart(ParameterName, dataLayerName ,
                 ChartXMin, ChartYMin, ChartWidth*0.9, ChartHeight*0.9,
                 OverlaySource, Title, DrawAxes);
           end;
         ctContour:
           begin
             StringToWrite := StringToWrite +
               WriteContourChart(ParameterName, dataLayerName ,
                 ChartXMin, ChartYMin, ChartWidth*0.9, ChartHeight*0.9,
                 OverlaySource, Title,CalculateDelta, Min,Max,Delta,
                 DrawAxes);
           end;
         ctPathLine :
           begin
           end;
         ctCrosssection :
           begin
             StringToWrite := StringToWrite +
               WriteCrossSectionChart(ParameterName, dataLayerName,
               ChartXMin, ChartYMin, ChartWidth*0.9, ChartHeight*0.9,
               OverlaySource, MinX, MaxX, MinY + ChartHeight/2, Title,
               DrawAxes);
           end;
      end;

      Inc(DataSetIndex);
      if (ChartType = ctVector) then
      begin
        Inc(DataSetIndex);
      end;
    end;
//    if not UseExistingMapLayer then
//    begin
//      MapLayerName := AMapLayerType.ANE_LayerName;
//    end;
    maplayerhandle := GetLayerHandle(aneHandle, MapLayerName);
    if maplayerhandle = nil then
    begin
      dataLayerHandle := GetLayerHandle(aneHandle, dataLayerName);
      if not (dataLayerHandle = nil) then
      begin
        A_MapsLayer := AMapLayerType.Create( PostProcLayerList, -1);
        A_MapsLayer.DataIndex := DataIndex;

        A_MapsLayer.Lock := [];
        Template := A_MapsLayer.WriteLayer(aneHandle);
        GetMem(ANE_LayerTemplate, Length(Template) + 1);
        try
          StrPCopy(ANE_LayerTemplate, Template);
          maplayerhandle := ANE_LayerAddByTemplate(aneHandle ,
                   ANE_LayerTemplate, dataLayerHandle  );
        finally
          FreeMem(ANE_LayerTemplate);
        end;
        A_MapsLayer.Free;
      end;
    end
    else
    begin
      if not UseExistingMapLayer then
      begin

        GetValidLayer(aneHandle,maplayerhandle,AMapLayerType,MapLayerName,
          PostProcLayerList, UserResponse);
        if AMapLayerType.ANE_LayerName = MapLayerName then
        begin
          ANE_LayerClear(aneHandle, maplayerhandle, False );
        end;
      end;
    end;
    if maplayerhandle = nil then
    begin
      Beep;
      ShowMessage('Error creating postprocessing layer');
    end
    else
    begin
      Try
        begin
          result := StringToWrite;
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
