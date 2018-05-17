unit PostSutraUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, frmSutraUnit, AnePIE, ANE_LayerUnit, IntListUnit;

type
  TListViewHeaders = (lvhTimeStep, lvhState, lvhTransType, lvhSaturation, lvhVelocity);

  TintegerArray = Array[0..32760] of LongInt;
  PIntegerArray = ^TintegerArray;
  TDoubleArray = Array[0..32760] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = Array[0..32760] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..32760] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;

  EUniformValues = Class(Exception);

  TfrmPostSutra = class(TForm)
    lvResult: TListView;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbOverlay: TCheckBox;
    OpenDialog1: TOpenDialog;
    procedure lvResultMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvResultColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    function ElementParameterCount: integer;
//    procedure SetNodeNames;
    procedure SetElementNames;
    procedure ChartPositions(NodeStatePositions, NodeTransportPostions,
      NodeSaturationPositions, ElementPositions: TIntegerList);
    function NodeSaturationParameterCount: integer;
    function NodeStateParameterCount: integer;
    function NodeTrasportedParameterCount: integer;
    procedure SetNodeSaturationNames;
    procedure SetNodeStateNames;
    procedure SetNodeTransportedNames;
    function NodeParameterCount: integer;
    procedure SetNodeNames;
    { Private declarations }
  protected
    function ExtractFileRoot(FileName: string): string;
    Procedure ReadD3Header(FileName : String{;
      var TransportType :TTransportType; var StateVariable: TStateVariableType});
    procedure ReadD4Header(FileName: String);
  public
    HeaderLineCount : integer;
    NumberOfNodes : ANE_INT32;
    NumberOfElements: ANE_INT32;
    TimeSteps : integer;
    FirstUp : boolean;
    NamesList : TStringList;
    TitlesList : TStringList;
    D3FileName, D4FileName : string;
    Procedure ReadHeaders(FileName : String);
    Procedure ReadAndSetArgusNodeData(var MinX, MinY, MaxX,
      MaxY : double; var DataLayerName : string;
      ADataLayerType: T_ANE_DataLayerClass; var dataLayerHandle : ANE_PTR;
      anehandle  : ANE_PTR; ALayerList : T_ANE_LayerList; var MinState, MaxState,
      MinTransport, MaxTransport, MinSaturation, MaxSaturation : double);
    procedure ReadAndSetArgusElementData(var MinX, MinY, MaxX,
      MaxY: double; var DataLayerName: string;
      ADataLayerType: T_ANE_DataLayerClass; var dataLayerHandle: ANE_PTR;
      anehandle: ANE_PTR; ALayerList: T_ANE_LayerList);
    function ChartCount : integer;
    { Public declarations }
  end;

procedure GSutraPostProcessingPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

var
  frmPostSutra: TfrmPostSutra;

implementation

{$R *.DFM}

uses GetListViewCellStringUnit, ArgusFormUnit, FixNameUnit,
  ANECB, LayerNamePrompt, SLDataLayer, WriteSutraPostProcessingUnit,
  SLMap;

ResourceString
  rsNoButYesOK = 'no';
  rsNoYesNotOK = 'NO';
  rsYes = 'YES';

var
  UserResponse : integer = 1;
  
procedure TfrmPostSutra.lvResultMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  CellString : String;
begin
  // Toggle the contents of the cell on which the user
  // clicked between Yes and No.
  if FirstUp then
  begin
    if X > lvResult.Column[0].Width then
    begin
      if GetListViewXYString(X, Y, lvResult, CellString) then
      begin
        if CellString = rsNoButYesOK then
        begin
          CellString := rsYes;
        end
        else
        begin
          CellString := rsNoButYesOK;
        end;
        SetListViewXYString(X, Y, lvResult, CellString);
      end;
    end;
  end;
  FirstUp := not FirstUp;
end;

procedure TfrmPostSutra.lvResultColumnClick(Sender: TObject;
  Column: TListColumn);
var
  Index : integer;
  RowIndex : integer;
  ColIndex : integer;
  AListItem : TListItem;
  AString : String;
begin
  // Toggle the contents of all cells in the column on which the user
  // clicked between Yes and No.
  for Index := 0 to lvResult.Columns.Count -1 do
  begin
    if lvResult.Column[Index] = Column then
    begin
      if Index > 0 then
      begin
        ColIndex := Index -1;
        AString := rsNoYesNotOK;
        for RowIndex := 0 to lvResult.Items.Count -1 do
        begin
          AListItem := lvResult.Items[RowIndex];
          if AListItem.SubItems[ColIndex] = rsNoButYesOK then
          begin
            AString := rsYes;
            break;
          end
          else if AListItem.SubItems[ColIndex] = rsYes then
          begin
            AString := rsNoButYesOK;
            break;
          end;
        end;
        if AString <> rsNoYesNotOK then
        begin
          for RowIndex := 0 to lvResult.Items.Count -1 do
          begin
            AListItem := lvResult.Items[RowIndex];
            if AListItem.SubItems[ColIndex] <> rsNoYesNotOK then
            begin
              AListItem.SubItems[ColIndex] := AString;
            end;
          end;
        end;
      end;
      break;
    end;
  end;
end;

procedure ReadSutraNodeLine(ANodeLine : string; var NodeNumber : integer;
  var Numbers: array of double);
Const Count = 5;
var
  AString : string;
  Position : integer;
  Index : Integer;
begin
  AString := Copy(ANodeLine, 1, 8);
  NodeNumber := StrToInt(AString);
  Position := 9;
  for Index := 0 to Count -1 do
  begin
    AString := Copy(ANodeLine, Position, 15);
    Inc(Position,15);
    Numbers[Index] := StrToFloat(AString);
  end;
end;

procedure ReadSutraElementLine(AnElementLine : string;
  var ElementNumber : integer; var Numbers: array of double);
Const Count = 4;
var
  AString : string;
  Position : integer;
  Index : Integer;
begin
  AString := Copy(AnElementLine, 1, 8);
  ElementNumber := StrToInt(AString);
  Position := 11;
  for Index := 0 to Count -1 do
  begin
    AString := Copy(AnElementLine, Position, 15);
    Inc(Position,15);
    Numbers[Index] := StrToFloat(AString);
  end;
end;

function GetStateVariableFromString(AString: string) : TStateVariableType;
begin
  if 'Press' = AString then
  begin
    result := svPressure
  end
  else
  begin
    result := svHead
  end;
end;

function GetTransportTypeFromString(AString: string) : TTransportType;
begin
  if 'Conc' = AString then
  begin
    result := ttSolute
  end
  else
  begin
    result := ttEnergy
  end;
end;

function DStrToFloat(AString : String): extended;
var
  Index :Integer;
begin
  for Index := 1 to Length(AString) do
  begin
    if (AString[Index] = 'D') or (AString[Index] = 'd') then
    begin
      AString[Index] := 'E';
    end;
  end;
  result := StrToFloat(AString);
end;

Procedure TfrmPostSutra.ReadD3Header(FileName : String);
var
  D3File : TextFile;
  AString : String;
  Index: Integer;
  AListItem : TListItem;
  Time : double;
  StateCalculated : boolean;
  TransportCalculated : boolean;
  TimeStep : integer;
  SubItemCount, SubItemsIndex : integer;

  TransportType :TTransportType;
  StateVariable: TStateVariableType  ;
//  LocalString : String;
begin
  if FileExists(FileName) then
  begin
    AssignFile(D3File,FileName);
    Reset(D3File);
    try
      HeaderLineCount := 0;

      // Read titles
      ReadLn(D3File,AString);
      Inc(HeaderLineCount);
      ReadLn(D3File,AString);
      Inc(HeaderLineCount);
      // Read nodewise or element wise results
      ReadLn(D3File,AString);
      Inc(HeaderLineCount);
      // ReadNumber of nodes
      ReadLn(D3File,AString);
      Inc(HeaderLineCount);
      AString := Trim(Copy(AString, 3, Pos('nodes',AString) -3));
      NumberOfNodes := StrToInt(AString);
      // ReadNumber of time steps
      ReadLn(D3File,AString);
      Inc(HeaderLineCount);
      AString := Trim(Copy(AString, 3, Pos('Time',AString) -3));
      TimeSteps := StrToInt(AString);
      // Skip line
      ReadLn(D3File,AString);
      Inc(HeaderLineCount);
      //  Get Transport type and State variable
      ReadLn(D3File,AString);
      Inc(HeaderLineCount);
      StateVariable := GetStateVariableFromString(Copy(AString, 22, 5));
      TransportType := GetTransportTypeFromString(Copy(AString, 28, 4));

      // set captions of the ListView
      if TransportType = ttEnergy then
      begin
        lvResult.Column[2].Caption := 'Temperature'
      end
      else
      begin
        lvResult.Column[2].Caption := 'Concentration'
      end;

      if StateVariable = svPressure then
      begin
        lvResult.Column[1].Caption := 'Pressure'
      end
      else
      begin
        lvResult.Column[1].Caption := 'Head'
      end;

      // read time step info.
      lvResult.Items.BeginUpdate;
      try
        for Index := 1 to TimeSteps do
        begin
          ReadLn(D3File,AString);
          Inc(HeaderLineCount);

          // read info for each time step.
          Time := DStrToFloat(Trim(Copy(AString,4,15)));
          StateCalculated := StrToInt(Trim(Copy(AString,22,1))) = 1;
          TransportCalculated := StrToInt(Trim(Copy(AString,28,1))) = 1;
          TimeStep := StrToInt(Trim(Copy(AString,29,6)));

          // add a new list item.
          AListItem := lvResult.Items.Add;

          // Set the time step of the new list item
          AListItem.Caption := IntToStr(TimeStep);

          // set the number of subitems
          SubItemCount := Ord(High(TListViewHeaders));
          for SubItemsIndex := 1 to SubItemCount do
          begin
            AListItem.SubItems.Add('rsNoYesNotOK');
          end;

          // set the text of the subitems for each data set
          SubItemsIndex := Ord(lvhState) -1;
          If StateCalculated then
          begin
            AListItem.SubItems[SubItemsIndex] := rsNoButYesOK;
          end
          else
          begin
            AListItem.SubItems[SubItemsIndex] := rsNoYesNotOK;
          end;

          SubItemsIndex := Ord(lvhTransType) -1;
          if TransportCalculated then
          begin
            AListItem.SubItems[SubItemsIndex] := rsNoButYesOK;
          end
          else
          begin
            AListItem.SubItems[SubItemsIndex] := rsNoYesNotOK;
          end;
          SubItemsIndex := Ord(lvhSaturation) -1;
          AListItem.SubItems[SubItemsIndex] := rsNoButYesOK;
  //        SubItemsIndex := Ord(lvhVelocity) -1;
  //        AListItem.SubItems[SubItemsIndex] := rsNoYesNotOK;
      end;
      finally
        lvResult.Items.EndUpdate;
      end;
    finally
      CloseFile(D3File);
    end;
  end;
end;

Procedure TfrmPostSutra.ReadD4Header(FileName : String);
var
  D4File : TextFile;
  AString : String;
  Index: Integer;
  AListItem : TListItem;
  SubItemsIndex : integer;
begin
  if FileExists(FileName) then
  begin
    AssignFile(D4File,FileName);
    Reset(D4File);
    try
//      HeaderLineCount := 0;

      // Read titles
      ReadLn(D4File,AString);
//      Inc(HeaderLineCount);
      ReadLn(D4File,AString);
//      Inc(HeaderLineCount);
      // Read nodewise or element wise results
      ReadLn(D4File,AString);
//      Inc(HeaderLineCount);
      // ReadNumber of elements
      ReadLn(D4File,AString);
//      Inc(HeaderLineCount);
      AString := Trim(Copy(AString, 3, Pos('elements',AString) -3));
      NumberOfElements := StrToInt(AString);
      for Index := 1 to TimeSteps do
      begin
        AListItem := lvResult.Items[Index-1];
        SubItemsIndex := Ord(lvhVelocity) -1;
        AListItem.SubItems[SubItemsIndex] := rsNoButYesOK;
      end;
    finally
      CloseFile(D4File);
    end;
  end;
end;

function TfrmPostSutra.ExtractFileRoot(FileName : string) : string;
var
  Extension, FileNameRoot, Directory : String;
  ExtensionLength : integer;
begin
  Directory := ExtractFileDir(FileName);
  FileNameRoot := ExtractFileName(FileName);
  Extension := ExtractFileExt(FileName);
  ExtensionLength := Length(Extension);
  if ExtensionLength > 0 then
  begin
    FileNameRoot := Copy(FileNameRoot,1,Length(FileNameRoot)
      - (ExtensionLength));
  end;
  result := Directory + '\' + FileNameRoot
end;

procedure TfrmPostSutra.ReadHeaders(FileName: String);
var
  RootName : string;
{  TransportType :TTransportType;
  StateVariable: TStateVariableType;}
begin
  RootName := ExtractFileRoot(FileName);
  D3FileName := RootName + '.d3';
  D4FileName := RootName + '.d4';
  ReadD3Header(D3FileName{, TransportType, StateVariable} );
  ReadD4Header(D4FileName);
end;

function ChartTypeString(ChartType : TChartType) : String;
begin
  case ChartType of
    ct3D:
      begin
        result := '3D Chart'
      end;
    ctVector:
      begin
        result := 'Arrows Chart'
      end;
    ctColor:
      begin
        result := 'Color Map Chart'
      end;
    ctContour:
      begin
        result := 'Contours Chart'
      end;
    ctPathLine:
      begin
        result := 'Path Lines Chart'
      end;
    ctCrosssection:
      begin
        result := 'CrossSection Chart'
      end;
  end;
end;

Procedure GetCalculateDelta(var CalculateDelta : boolean;
  var Min,Max,Delta : double; ChartType : TChartType; ChartTitleKeyWord : string;
  aneHandle, layerHandle : ANE_PTR);
var
  MapStringList, Names : TStringList;
  MapsText : String;
  LineIndex : integer;
  AString : string;
  ChartTypeIndex : TChartType;
  MapsObjectList : TList;
  AMapObject : TStringList;
  MapObjectIndex : integer;
  NameIndex : integer;
  AName : string;
  CorrectMapType : boolean;
  KeyWord : string;
begin
  CalculateDelta := True;
  Min := 0;
  Max := 100;
  Delta := 10;
  if (ChartType = ctContour) and (layerHandle <> nil) {or (ChartType = ctVector) or
     (ChartType = ct3D) {or (ChartType = ctPathLine)} then
  begin
    AMapObject := nil;
    MapStringList := TStringList.Create;
    Names := TStringList.Create;
    MapsObjectList := TList.Create;
    try
      for ChartTypeIndex := Low(TChartType) to High(TChartType) do
      begin
        Names.Add(ChartTypeString(ChartTypeIndex));

      end;
      Names.Add('Polygon');
      Names.Add('Text');
      Names.Add('Circle');
      Names.Add('Arc');

      ANE_ExportTextFromOtherLayer(aneHandle, layerHandle, @MapsText );
      MapStringList.Text := MapsText;
      for LineIndex := 0 to MapStringList.Count -1 do
      begin
        AString := MapStringList[LineIndex];
        for NameIndex := 0 to Names.Count -1 do
        begin
          AName := Names[NameIndex];
          if Pos(AName, AString) > 0 then
          begin
            if Pos(ChartTypeString(ChartType), AString) > 0 then
            begin
              AMapObject := TStringList.Create;
              MapsObjectList.Add(AMapObject);
              break;
            end
            else
            begin
              AMapObject := nil;
            end;

          end;
        end;
        if AMapObject <> nil then
        begin
          AMapObject.Add(AString);
        end;
      end;

      if MapsObjectList.Count > 0 then
      begin
        for MapObjectIndex := 0 to MapsObjectList.Count -1 do
        begin
          AMapObject := MapsObjectList[MapObjectIndex];
          CorrectMapType := False;
          for LineIndex := 0 to AMapObject.Count -1 do
          begin
            AString := AMapObject[LineIndex];
            if (Pos('Head Title', AString) > 0) and
              (Pos(ChartTitleKeyWord, AString) > 0) then
            begin
              CorrectMapType := True;
              break;
            end;
          end;
          if CorrectMapType then
          begin
            case ChartType of
              ctContour:
                begin
                  KeyWord := 'Calculate Values';
                end;
              {ctVector, ct3D:
                begin
                  KeyWord := 'Keep Ratio';
                end; }
              else
                begin
                  Assert(False);
                end;
            end;

            CalculateDelta := False;
            for LineIndex := 0 to AMapObject.Count -1 do
            begin
              AString := AMapObject[LineIndex];
              if (Pos(KeyWord, AString) > 0) then
              begin
                AString := Copy(AString, Pos(KeyWord, AString)
                  + Length(KeyWord) + 2, Length(AString));
                CalculateDelta := Trim(AString) = '1';
                break;
              end;
            end;
            
            if not CalculateDelta then
            begin
              for LineIndex := 0 to AMapObject.Count -1 do
              begin
                AString := AMapObject[LineIndex];
                KeyWord := 'Minimum Value';
                if (Pos(KeyWord, AString) > 0) then
                begin
                  AString := Copy(AString, Pos(KeyWord, AString)
                    + Length(KeyWord) + 2, Length(AString));
                  Min := StrToFloat(Trim(AString));
                end;
                KeyWord := 'Maximum Value';
                if (Pos(KeyWord, AString) > 0) then
                begin
                  AString := Copy(AString, Pos(KeyWord, AString)
                    + Length(KeyWord) + 2, Length(AString));
                  Max := StrToFloat(Trim(AString));
                end;
                KeyWord := 'Delta';
                if (Pos(KeyWord, AString) > 0) then
                begin
                  AString := Copy(AString, Pos(KeyWord, AString)
                    + Length(KeyWord) + 2, Length(AString));
                  Delta := StrToFloat(Trim(AString));
                end;
              end;
            end;
            break;
          end;

        end;
      end;

    finally
      MapStringList.Free;
      Names.Free;
      for MapObjectIndex := 0 to MapsObjectList.Count -1 do
      begin
        TStringList(MapsObjectList[MapObjectIndex]).Free;
      end;
      MapsObjectList.Free;
    end;
  end;

end;  

procedure GSutraPostProcessingPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;
var
  MinX, MinY, MaxX, MaxY : double;
  D3DataLayerName, D4DataLayerName : string;
  ErrorMessage : string;
  D3DataLayerHandle, D4DataLayerHandle : ANE_PTR;
  D3ItemsToPlot, D4ItemsToPlot : TIntegerList;
  Index : integer;
  MapLayerName : string;
  ChartCount : integer;
  NodeStatePositions, NodeTransportPostions,
    NodeSaturationPositions, ElementPositions : TIntegerList;
  CalculateDelta : boolean;
  Min,Max,Delta : double;
  PostLayerHandle : ANE_PTR;
  PostLayerName : string;
  UseExistingLayer : boolean;
  MinState, MaxState, MinTransport, MaxTransport,
    MinSaturation, MaxSaturation : double;
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
              frmSutra := TArgusForm.GetFormFromArgus(aneHandle)
                as TfrmSutra;

              frmPostSutra :=
                TfrmPostSutra.Create(Application);

              if frmPostSutra.OpenDialog1.Execute then
              begin
                frmPostSutra.ReadHeaders(frmPostSutra.OpenDialog1.FileName);
                if frmPostSutra.ShowModal = mrOk then
                begin
                  ChartCount := frmPostSutra.ChartCount;
                  NodeStatePositions := TIntegerList.Create;
                  NodeTransportPostions := TIntegerList.Create;
                  NodeSaturationPositions := TIntegerList.Create;
                  ElementPositions := TIntegerList.Create;
                  try
                    frmPostSutra.ChartPositions(NodeStatePositions,
                      NodeTransportPostions, NodeSaturationPositions,
                      ElementPositions);

                    D3DataLayerName := TSutraD3DataLayer.ANE_LayerName;
                    D3DataLayerHandle := nil;

                    frmPostSutra.ReadAndSetArgusNodeData(MinX, MinY, MaxX, MaxY,
                      D3DataLayerName, TSutraD3DataLayer, D3DataLayerHandle,
                      anehandle, frmSutra.SutraLayerStructure.UnIndexedLayers,
                      MinState, MaxState, MinTransport, MaxTransport,
                      MinSaturation, MaxSaturation);

                    D4DataLayerName := TSutraD4DataLayer.ANE_LayerName;
                    D4DataLayerHandle := nil;

                    frmPostSutra.ReadAndSetArgusElementData(MinX, MinY, MaxX,
                      MaxY, D4DataLayerName, TSutraD4DataLayer,
                      D4DataLayerHandle, anehandle,
                      frmSutra.SutraLayerStructure.UnIndexedLayers); 

                    PostLayerName := TSutraPostMapLayer.ANE_LayerName;
                    PostLayerHandle := ANE_LayerGetHandleByName(aneHandle,
                      PChar(PostLayerName) );

                    UseExistingLayer := False;
                    if D3DataLayerHandle <> nil then
                    begin
                      D3ItemsToPlot := TIntegerList.Create;
                      try
                        if frmPostSutra.NodeStateParameterCount > 0 then
                        begin
                          for Index := 0 to
                            frmPostSutra.NodeStateParameterCount -1 do
                          begin
                            D3ItemsToPlot.Add(Index);
                          end;
                          frmPostSutra.SetNodeStateNames;

                          GetCalculateDelta(CalculateDelta, Min,Max,Delta,
                            ctContour, frmPostSutra.lvResult.Column
                              [Ord(lvhState)].Caption, aneHandle,
                              PostLayerHandle);

                          if CalculateDelta then
                          begin
                            CalculateDelta := False;
                            Min := MinState;
                            Max := MaxState;
                            If Max = Min then Max := Min + 1;
                            Delta := (Max -Min)/10;
                            {MinState, MaxState, MinTransport, MaxTransport,
                            MinSaturation, MaxSaturation}
                          end;

                          WriteSutraPostProcessing(aneHandle, frmPostSutra.NamesList,
                            frmPostSutra.TitlesList,
                            D3ItemsToPlot, ctContour, D3DataLayerName,
                            TSutraPostMapLayer, MinX, MinY, MaxX, MaxY,
                            frmSutra.SutraLayerStructure.UnIndexedLayers, False,
                            MapLayerName, ChartCount, NodeStatePositions,
                            CalculateDelta, Min,Max,Delta);  

                        end;

                        if frmPostSutra.NodeTrasportedParameterCount > 0 then
                        begin
                          D3ItemsToPlot.Clear;

                          for Index := 0 to
                            frmPostSutra.NodeTrasportedParameterCount -1 do
                          begin
                            D3ItemsToPlot.Add(Index);
                          end;
                          UseExistingLayer := frmPostSutra.NodeStateParameterCount > 0;

                          frmPostSutra.SetNodeTransportedNames;

                          GetCalculateDelta(CalculateDelta, Min,Max,Delta,
                            ctContour, frmPostSutra.lvResult.Column
                              [Ord(lvhTransType)].Caption, aneHandle,
                              PostLayerHandle);

                          if CalculateDelta then
                          begin
                            CalculateDelta := False;
                            Min := MinTransport;
                            Max := MaxTransport;
                            If Max = Min then Max := Min + 1;
                            Delta := (Max -Min)/10;
                            {MinState, MaxState, MinTransport, MaxTransport,
                            MinSaturation, MaxSaturation}
                          end;

                          WriteSutraPostProcessing(aneHandle, frmPostSutra.NamesList,
                            frmPostSutra.TitlesList,
                            D3ItemsToPlot, ctContour, D3DataLayerName,
                            TSutraPostMapLayer, MinX, MinY, MaxX, MaxY,
                            frmSutra.SutraLayerStructure.UnIndexedLayers,
                            UseExistingLayer, MapLayerName, ChartCount,
                            NodeTransportPostions, CalculateDelta, Min,Max,Delta);

                        end;

                        if frmPostSutra.NodeSaturationParameterCount > 0 then
                        begin
                          D3ItemsToPlot.Clear;

                          for Index := 0 to
                            frmPostSutra.NodeSaturationParameterCount -1 do
                          begin
                            D3ItemsToPlot.Add(Index);
                          end;
                          UseExistingLayer := UseExistingLayer or
                            (frmPostSutra.NodeTrasportedParameterCount > 0);

                          frmPostSutra.SetNodeSaturationNames;

                          GetCalculateDelta(CalculateDelta, Min,Max,Delta,
                            ctContour, frmPostSutra.lvResult.Column
                              [Ord(lvhSaturation)].Caption, aneHandle,
                              PostLayerHandle);

                          if CalculateDelta then
                          begin
                            CalculateDelta := False;
                            Min := MinSaturation;
                            Max := MaxSaturation;
                            If Max = Min then Max := Min + 1;
                            Delta := (Max -Min)/10;
                            {MinState, MaxState, MinTransport, MaxTransport,
                            MinSaturation, MaxSaturation}
                          end;

                          WriteSutraPostProcessing(aneHandle, frmPostSutra.NamesList,
                            frmPostSutra.TitlesList,
                            D3ItemsToPlot, ctContour, D3DataLayerName,
                            TSutraPostMapLayer, MinX, MinY, MaxX, MaxY,
                            frmSutra.SutraLayerStructure.UnIndexedLayers,
                            UseExistingLayer, MapLayerName, ChartCount,
                            NodeSaturationPositions, CalculateDelta, Min,Max,Delta);
                        end;
                      finally
                        D3ItemsToPlot.Free;
                      end;

                    end;

                    if D4DataLayerHandle <> nil then
                    begin
                      D4ItemsToPlot := TIntegerList.Create;
                      try
                        for Index := 0 to
                          frmPostSutra.ElementParameterCount -1 do
                        begin
                          D4ItemsToPlot.Add(Index);
                        end;

                        UseExistingLayer := UseExistingLayer or
                          (frmPostSutra.NodeStateParameterCount > 0) or
                          (frmPostSutra.NodeTrasportedParameterCount > 0) or
                          (frmPostSutra.NodeSaturationParameterCount > 0);

                        frmPostSutra.SetElementNames;

                        GetCalculateDelta(CalculateDelta, Min,Max,Delta,
                          ctVector, frmPostSutra.lvResult.Column
                            [Ord(lvhVelocity)].Caption, aneHandle,
                            PostLayerHandle);

                        WriteSutraPostProcessing(aneHandle, frmPostSutra.NamesList,
                          frmPostSutra.TitlesList,
                          D4ItemsToPlot, ctVector, D4DataLayerName,
                          TSutraPostMapLayer, MinX, MinY, MaxX, MaxY,
                          frmSutra.SutraLayerStructure.UnIndexedLayers,
                          UseExistingLayer, MapLayerName, ChartCount,
                          ElementPositions, CalculateDelta, Min,Max,Delta);
                      finally
                        D4ItemsToPlot.Free;
                      end;

                    end;
                  finally
                    NodeStatePositions.Free;
                    NodeTransportPostions.Free;
                    NodeSaturationPositions.Free;
                    ElementPositions.Free;
                  end;

                end;
              end;
//              frmMODFLOWPostProcessing.CurrentModelHandle := aneHandle;

            end; // try 2
          except
            on E: EOutOfMemory do
            begin
              Beep;
              MessageDlg(E.Message,mtError,[mbOK],0);
            end;
            on E: EUniformValues do
            begin
              Beep;
              MessageDlg(E.Message,mtError,[mbOK],0);
            end;
            On E: Exception do
            begin
{              if frmSutra.PIEDeveloper = '' then
              begin   }
                ErrorMessage := 'The following error occurred in the Sutra post-processing PIE. "'
                  + E.Message + '" Contact '
                  + 'PIE Developer for assistance.';
{              end
              else
              begin
                ErrorMessage := 'The following error occurred in post-processing PIE. "'
                  + E.Message + '" Contact '
                  + 'PIE Developer (' + frmSutra.PIEDeveloper
                  + ') for assistance.';
              end; }
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

function TfrmPostSutra.NodeParameterCount : integer;
var
  Index : integer;
  AListItem : TListItem;
begin
  result := 0;
  for Index := 0 to lvResult.Items.Count -1 do
  begin
    AListItem := lvResult.Items[Index];
    if AListItem.SubItems[Ord(lvhState) -1] = rsYes then
    begin
      Inc(result);
    end;
    if AListItem.SubItems[Ord(lvhTransType) -1] = rsYes then
    begin
      Inc(result);
    end;
    if AListItem.SubItems[Ord(lvhSaturation) -1] = rsYes then
    begin
      Inc(result);
    end;
  end;
end;

function TfrmPostSutra.NodeStateParameterCount : integer;
var
  Index : integer;
  AListItem : TListItem;
begin
  result := 0;
  for Index := 0 to lvResult.Items.Count -1 do
  begin
    AListItem := lvResult.Items[Index];
    if AListItem.SubItems[Ord(lvhState) -1] = rsYes then
    begin
      Inc(result);
    end;
  end;
end;

function TfrmPostSutra.NodeTrasportedParameterCount : integer;
var
  Index : integer;
  AListItem : TListItem;
begin
  result := 0;
  for Index := 0 to lvResult.Items.Count -1 do
  begin
    AListItem := lvResult.Items[Index];
    if AListItem.SubItems[Ord(lvhTransType) -1] = rsYes then
    begin
      Inc(result);
    end;
  end;
end;

function TfrmPostSutra.NodeSaturationParameterCount : integer;
var
  Index : integer;
  AListItem : TListItem;
begin
  result := 0;
  for Index := 0 to lvResult.Items.Count -1 do
  begin
    AListItem := lvResult.Items[Index];
    if AListItem.SubItems[Ord(lvhSaturation) -1] = rsYes then
    begin
      Inc(result);
    end;
  end;
end;

function TfrmPostSutra.ElementParameterCount : integer;
var
  Index : integer;
  AListItem : TListItem;
begin
  result := 0;
  for Index := 0 to lvResult.Items.Count -1 do
  begin
    AListItem := lvResult.Items[Index];
    if AListItem.SubItems[Ord(lvhVelocity) -1] = rsYes then
    begin
      Inc(result);
    end;
  end;
  result := result * 2;
end;

Procedure TfrmPostSutra.SetNodeNames;
var
  Index : integer;
  AListItem : TListItem;
begin
  NamesList.Clear;
  for Index := 0 to lvResult.Items.Count -1 do
  begin
    AListItem := lvResult.Items[Index];
    if AListItem.SubItems[Ord(lvhState) -1] = rsYes then
    begin
      NamesList.Add(FixArgusName('Period ' + AListItem.Caption + ' '
        + lvResult.Column[Ord(lvhState)].Caption));
    end;
    if AListItem.SubItems[Ord(lvhTransType) -1] = rsYes then
    begin
      NamesList.Add(FixArgusName('Period ' + AListItem.Caption + ' '
        + lvResult.Column[Ord(lvhTransType)].Caption));
    end;
    if AListItem.SubItems[Ord(lvhSaturation) -1] = rsYes then
    begin
      NamesList.Add(FixArgusName('Period ' + AListItem.Caption + ' '
        + lvResult.Column[Ord(lvhSaturation)].Caption));
    end;
  end;
  TitlesList.Assign(NamesList);
end; 

Procedure TfrmPostSutra.SetNodeStateNames;
var
  Index : integer;
  AListItem : TListItem;
begin
  NamesList.Clear;
  for Index := 0 to lvResult.Items.Count -1 do
  begin
    AListItem := lvResult.Items[Index];
    if AListItem.SubItems[Ord(lvhState) -1] = rsYes then
    begin
      NamesList.Add(FixArgusName('Period ' + AListItem.Caption + ' '
        + lvResult.Column[Ord(lvhState)].Caption));
    end;
  end;
  TitlesList.Assign(NamesList);
end;

Procedure TfrmPostSutra.SetNodeTransportedNames;
var
  Index : integer;
  AListItem : TListItem;
begin
  NamesList.Clear;
  for Index := 0 to lvResult.Items.Count -1 do
  begin
    AListItem := lvResult.Items[Index];
    if AListItem.SubItems[Ord(lvhTransType) -1] = rsYes then
    begin
      NamesList.Add(FixArgusName('Period ' + AListItem.Caption + ' '
        + lvResult.Column[Ord(lvhTransType)].Caption));
    end;
  end;
  TitlesList.Assign(NamesList);
end;

Procedure TfrmPostSutra.SetNodeSaturationNames;
var
  Index : integer;
  AListItem : TListItem;
begin
  NamesList.Clear;
  for Index := 0 to lvResult.Items.Count -1 do
  begin
    AListItem := lvResult.Items[Index];
    if AListItem.SubItems[Ord(lvhSaturation) -1] = rsYes then
    begin
      NamesList.Add(FixArgusName('Period ' + AListItem.Caption + ' '
        + lvResult.Column[Ord(lvhSaturation)].Caption));
    end;
  end;
  TitlesList.Assign(NamesList);
end;

Procedure TfrmPostSutra.SetElementNames;
var
  Index : integer;
  AListItem : TListItem;
begin
  NamesList.Clear;
  TitlesList.Clear;
  for Index := 0 to lvResult.Items.Count -1 do
  begin
    AListItem := lvResult.Items[Index];
    if AListItem.SubItems[Ord(lvhVelocity) -1] = rsYes then
    begin
      NamesList.Add(FixArgusName('Period ' + AListItem.Caption + ' X '
        + lvResult.Column[Ord(lvhVelocity)].Caption));
      NamesList.Add(FixArgusName('Period ' + AListItem.Caption + ' Y '
        + lvResult.Column[Ord(lvhVelocity)].Caption));
      TitlesList.Add(FixArgusName('Period ' + AListItem.Caption + ' '
        + lvResult.Column[Ord(lvhVelocity)].Caption));
    end;
  end;
end;

procedure TfrmPostSutra.FormCreate(Sender: TObject);
begin
  FirstUp := True;
  NamesList := TStringList.Create;
  TitlesList := TStringList.Create;
end;

{procedure TfrmPostSutra.SetSutraNodeData;
var
//  NodeNumberArray : T3DIntegerList;
//  FirstNodeList, SecondNodeList, ThirdNodeList : TIntegerList;
//  A3DRealList : T3DRealList;
  XIndex, YIndex, ZIndex : Integer;
  numDataParameters  : ANE_INT32;
  numPoints : ANE_INT32;
  i : Integer;
  j : Integer;
  posX : PDoubleArray;
  posY : PDoubleArray;
  dataParameters : pMatrix;
  paramNames : PParamNamesArray;
  k : double;
  numTriangles :		ANE_INT32   ;
  node0 :			PIntegerArray  ;
  node1 :			PIntegerArray  ;
  node2 :			PIntegerArray  ;
  NameIndex : integer;
  triangleIndex : Integer;
  gridLayerHandle : ANE_PTR;
  Angle, CosAngle, SinAngle : double;
  DelX, DelY : double;
  ADataLayer : T_ANE_DataLayer;
  MiniMaxIndex : integer;
  DataLayerTemplate : string;
  PreviousLayerHandle : ANE_PTR;
  DataLayerIndex : integer;
  minValue, maxValue, temp : double;
  dataLayerHandle : ANE_PTR;
begin
  dataLayerHandle := nil;
end; }


procedure TfrmPostSutra.FormDestroy(Sender: TObject);
begin
  NamesList.Free;
  TitlesList.Free;
end;

procedure TfrmPostSutra.ReadAndSetArgusNodeData(var MinX, MinY, MaxX,
  MaxY : double; var DataLayerName : string;
  ADataLayerType: T_ANE_DataLayerClass; var dataLayerHandle : ANE_PTR;
  anehandle  : ANE_PTR; ALayerList : T_ANE_LayerList; var MinState, MaxState,
  MinTransport, MaxTransport, MinSaturation, MaxSaturation : double);
var
  XIndex, YIndex, ZIndex : Integer;
  numDataParameters  : ANE_INT32;
//  posX : PDoubleArray;
//  posY : PDoubleArray;
  posX : array of ANE_DOUBLE;
  posY : array of ANE_DOUBLE;
//  dataParameters : pMatrix;
  dataParameters : array of array of ANE_DOUBLE;
//  paramNames : PParamNamesArray;
  paramNames : array of ANE_STR;
  k : double;
  numTriangles :		ANE_INT32   ;
  NameIndex : integer;
  triangleIndex : Integer;
  gridLayerHandle : ANE_PTR;
  Angle, CosAngle, SinAngle : double;
  DelX, DelY : double;
  ADataLayer : T_ANE_DataLayer;
  MiniMaxIndex : integer;
  DataLayerTemplate : string;
  PreviousLayerHandle : ANE_PTR;
  DataLayerIndex : integer;
  minValue, maxValue, temp : double;
  D3File : TextFile;
  Index : integer;
  AString : string;
  TimeStepIndex : integer;
  DataSetIndex1, DataSetIndex2, DataSetIndex3 : integer;
  AListItem : TListItem;
  NodeIndex : integer;
  NodeNumber : integer;
  Numbers: array [0..4] of double;
  SetData1, SetData2, SetData3 : boolean;
  DataSetIndex : integer;
  LastDataSet : integer;
  FirstState, FirstTransport, FirstSaturation : boolean;
  ANE_LayerTemplate : ANE_STR;
//  AName : ANE_STR;
//  ParamNamesSize : integer;
{  posXptr : ANE_DOUBLE_PTR;
  posYptr : ANE_DOUBLE_PTR;
  dataParametersPtr : ANE_DOUBLE_PTR_PTR;
  ParamNamesPtr : ANE_STR_PTR;  }
begin
  numDataParameters := NodeParameterCount;

  if numDataParameters > 0 then
  begin
    FirstState := True;
    FirstTransport := True;
    FirstSaturation := True;
    // allocate memory for arrays to be passed to Argus ONE.
//    GetMem(posX, NumberOfNodes*SizeOf(double));
//    GetMem(posY, NumberOfNodes*SizeOf(double));
    SetLength(posX, NumberOfNodes);
    SetLength(posY, NumberOfNodes);
//    GetMem(dataParameters, numDataParameters*SizeOf(PDoubleArray));
    SetLength(dataParameters, numDataParameters,NumberOfNodes);
//    GetMem(paramNames, numDataParameters*SizeOf(ANE_STR));
    SetLength(paramNames, numDataParameters);
{    FOR DataSetIndex := 0 TO numDataParameters-1 DO
    begin
       GetMem(dataParameters^[DataSetIndex], NumberOfNodes*SizeOf(DOUBLE));
    end;  }
    SetNodeNames;
{    FOR NameIndex := 0 TO numDataParameters-1 DO
    begin
       GetMem(paramNames^[NameIndex], (1+Length(NamesList[NameIndex]))*SizeOf(Char));
    end;  }
{    try
      begin    }

        // Fill name array.
        for NameIndex := 0 to NamesList.Count -1 do
        begin
//          assert(NameIndex < numDataParameters);
//          StrPCopy(paramNames^[NameIndex], NamesList.Strings[NameIndex]);
//          paramNames^[NameIndex] := PChar(NamesList.Strings[NameIndex]);
          paramNames[NameIndex] := PChar(NamesList.Strings[NameIndex]);
        end;

        if FileExists(D3FileName) then
        begin
          AssignFile(D3File,D3FileName);
          Reset(D3File);
          try
            for Index := 0 to HeaderLineCount-1 do
            begin
              ReadLn(D3File,AString);
            end;
            DataSetIndex1 := -1;
            DataSetIndex2 := -1;
            DataSetIndex3 := -1;
            LastDataSet := -1;
            for TimeStepIndex := 0 to lvResult.Items.Count -1 do
            begin
              AListItem := lvResult.Items[TimeStepIndex];
              SetData1 := AListItem.SubItems[Ord(lvhState) -1] = rsYes;
              if SetData1 then
              begin
                DataSetIndex1 := LastDataSet + 1;
                LastDataSet := DataSetIndex1;
              end;

              SetData2 := AListItem.SubItems[Ord(lvhTransType) -1] = rsYes;
              if SetData2 then
              begin
                DataSetIndex2 := LastDataSet + 1;
                LastDataSet := DataSetIndex2;
              end;

              SetData3 := AListItem.SubItems[Ord(lvhSaturation) -1] = rsYes;
              if SetData3 then
              begin
                DataSetIndex3 := LastDataSet + 1;
                LastDataSet := DataSetIndex3;
              end;

              for Index := 1 to 3 do
              begin
                ReadLn(D3File,AString);
              end;
              for NodeIndex := 0 to NumberOfNodes -1 do
              begin
                ReadLn(D3File,AString);
                ReadSutraNodeLine(AString, NodeNumber, Numbers);
                if SetData1 then
                begin
                  if DataSetIndex1 = 0 then
                  begin
                    posX[NodeIndex] := Numbers[0];
                    posY[NodeIndex] := Numbers[1];
                  end;
//                  assert(NodeIndex < NumberOfNodes);
//                  assert(DataSetIndex1 < numDataParameters);
                  dataParameters[DataSetIndex1,NodeIndex] := Numbers[2];
                  if FirstState then
                  begin
                    FirstState := False;
                    MinState := Numbers[2];
                    MaxState := Numbers[2];
                  end
                  else
                  begin
                    if Numbers[2] < MinState then
                    begin
                      MinState := Numbers[2];
                    end;
                    if Numbers[2] > MaxState then
                    begin
                      MaxState := Numbers[2];
                    end;
                  end;
                end;

                if SetData2 then
                begin
                  if DataSetIndex2 = 0 then
                  begin
                    posX[NodeIndex] := Numbers[0];
                    posY[NodeIndex] := Numbers[1];
                  end;
//                  assert(NodeIndex < NumberOfNodes);
//                  assert(DataSetIndex2 < numDataParameters);
                  dataParameters[DataSetIndex2,NodeIndex] := Numbers[3];
                  if FirstTransport then
                  begin
                    FirstTransport := False;
                    MinTransport := Numbers[3];
                    MaxTransport := Numbers[3];
                  end
                  else
                  begin
                    if Numbers[3] < MinTransport then
                    begin
                      MinTransport := Numbers[3];
                    end;
                    if Numbers[3] > MaxTransport then
                    begin
                      MaxTransport := Numbers[3];
                    end;
                  end;
                end;

                if SetData3 then
                begin
                  if DataSetIndex3 = 0 then
                  begin
                    posX[NodeIndex] := Numbers[0];
                    posY[NodeIndex] := Numbers[1];
                  end;
//                  assert(NodeIndex < NumberOfNodes);
//                  assert(DataSetIndex3 < numDataParameters);
                  dataParameters[DataSetIndex3,NodeIndex] := Numbers[4];
                  if FirstSaturation then
                  begin
                    FirstSaturation := False;
                    MinSaturation := Numbers[4];
                    MaxSaturation := Numbers[4];
                  end
                  else
                  begin
                    if Numbers[4] < MinSaturation then
                    begin
                      MinSaturation := Numbers[4];
                    end;
                    if Numbers[4] > MaxSaturation then
                    begin
                      MaxSaturation := Numbers[4];
                    end;
                  end;
                end;
              end;
              ReadLn(D3File,AString);
            end;

            // test for uniform values. Abort if values are uniform to
            // prevent Argus ONE from crashing.
            for DataSetIndex := 0 to numDataParameters -1 do
            begin
              minValue := 0;
              maxValue := 0;
              if NumberOfNodes > 0 then
              begin
//                assert(DataSetIndex < numDataParameters);
                minValue := dataParameters[DataSetIndex,0];
                maxValue := dataParameters[DataSetIndex,0];
              end;
              for NodeIndex := 0 to NumberOfNodes - 1 do
              begin
//                assert(DataSetIndex < numDataParameters);
//                assert(NodeIndex < NumberOfNodes);
                temp := dataParameters[DataSetIndex,NodeIndex];
                if minValue > temp then
                begin
                  minValue := temp;
                end; // if minValue > temp then
                if maxValue < temp then
                begin
                  maxValue := temp;
                end; // if maxValue < temp then
              end; // for i := 0 to numpoints -1 do
              if (minValue = maxValue) then
              begin
                raise EUniformValues.Create('Aborting: data values '
                  + 'are uniform for data set "' + NamesList[DataSetIndex] + '".');
              end;
            end; // for J := 0 to numDataParameters - 1 do


            MinX := 0;
            MinY := 0;
            MaxX := 0;
            MaxY := 0;

            if numDataParameters > 0
            then
              begin
                MinX := posX[0];
                MinY := posY[0];
                MaxX := posX[0];
                MaxY := posY[0];
              end;

            for MiniMaxIndex := 0 to NumberOfNodes -1 do
            begin
//              assert (MiniMaxIndex < NumberOfNodes);
              if posX[MiniMaxIndex] < MinX
              then
              begin
                MinX := posX[MiniMaxIndex]
              end
              else if posX[MiniMaxIndex] > MaxX
              then
              begin
                MaxX := posX[MiniMaxIndex]
              end;

              if posY[MiniMaxIndex] < MinY
              then
              begin
                MinY := posY[MiniMaxIndex]
              end
              else if posY[MiniMaxIndex] > MaxY
              then
              begin
                MaxY := posY[MiniMaxIndex]
              end;
            end;
            DataLayerName := ADataLayerType.ANE_LayerName ;
            dataLayerHandle := ANE_LayerGetHandleByName(anehandle,
              PChar(DataLayerName)  );

            if (dataLayerHandle = nil)
            then
              begin
                ADataLayer := ADataLayerType.Create(ALayerList, -1);
                try
                  DataLayerTemplate := ADataLayer.WriteLayer(anehandle);
                  PreviousLayerHandle := nil; // if the previous layer is not
                  // set to nil there is an access violation if the new data
                  // layer is not the last layer.
                  DataLayerName := ADataLayer.WriteSpecialBeginning
                          + ADataLayer.WriteNewRoot
                          + ADataLayer.WriteSpecialMiddle
                          + ADataLayer.WriteIndex
                          + ADataLayer.WriteSpecialEnd;
                  GetMem(ANE_LayerTemplate, Length(DataLayerTemplate) + 1);
                  try
                    StrPCopy(ANE_LayerTemplate, DataLayerTemplate);
                    dataLayerHandle := ANE_LayerAddByTemplate(anehandle,
                       ANE_LayerTemplate, PreviousLayerHandle );
                  finally
                    FreeMem(ANE_LayerTemplate);
                  end;
                finally
                  ADataLayer.Free;
                end;
              end
            else
              begin
                GetValidLayer(anehandle, dataLayerHandle, ADataLayerType,
                  DataLayerName, ALayerList, UserResponse);

              end;
            if dataLayerHandle = nil
            then
              begin
                Beep;
                ShowMessage('Error creating data layer');
              end
            else
              begin
{                  posXptr := @posX[0];
                  posYptr := @posY[0];
                  dataParametersPtr := @dataParameters[0];
                  ParamNamesPtr := @paramNames[0];  }
                  // the access violation would occur here.
                  ANE_DataLayerSetData(aneHandle ,
                                dataLayerHandle ,
                                NumberOfNodes, // :	  ANE_INT32   ;
                                @posX[0], //:		  ANE_DOUBLE_PTR  ;
                                @posY[0], // :	    ANE_DOUBLE_PTR   ;
                                numDataParameters, // : ANE_INT32     ;
                                @dataParameters[0], // : ANE_DOUBLE_PTR_PTR  ;
                                @paramNames[0]  );
              end; // if dataLayerHandle = nil else
          finally
            CloseFile(D3File);
          end;


        end;

{      end;
    finally
      begin   }
        // free memory of arrays passed to Argus ONE.
{        FOR NameIndex := numDataParameters-1 DOWNTO 0 DO
        begin
          assert(NameIndex < numDataParameters);
          FreeMem(paramNames^[NameIndex]{, NumberOfNodes*SizeOf(DOUBLE)}{);
        end;
{        FOR DataSetIndex := numDataParameters-1 DOWNTO 0 DO
        begin
          assert(DataSetIndex < numDataParameters);
//          FreeMem(dataParameters^[DataSetIndex]{, NumberOfNodes*SizeOf(DOUBLE)}{);}
//        end;
//        FreeMem(dataParameters{, numDataParameters*SizeOf(PDoubleArray)});
//        FreeMem(posY{, NumberOfNodes*SizeOf(double)});
//        FreeMem(posX{, NumberOfNodes*SizeOf(double)});
//        FreeMem(paramNames{, numDataParameters*SizeOf(ANE_STR)});
{      end;
    end; }
  end;
end;

procedure TfrmPostSutra.ReadAndSetArgusElementData(var MinX, MinY, MaxX,
  MaxY : double; var DataLayerName : string;
  ADataLayerType: T_ANE_DataLayerClass; var dataLayerHandle : ANE_PTR;
  anehandle  : ANE_PTR; ALayerList : T_ANE_LayerList);
var
  XIndex, YIndex, ZIndex : Integer;
  numDataParameters  : ANE_INT32;
  posX : PDoubleArray;
  posY : PDoubleArray;
  dataParameters : pMatrix;
  paramNames : PParamNamesArray;
  k : double;
  numTriangles :		ANE_INT32   ;
  NameIndex : integer;
//  triangleIndex : Integer;
  gridLayerHandle : ANE_PTR;
  Angle, CosAngle, SinAngle : double;
  DelX, DelY : double;
  ADataLayer : T_ANE_DataLayer;
  MiniMaxIndex : integer;
  DataLayerTemplate : string;
  PreviousLayerHandle : ANE_PTR;
  DataLayerIndex : integer;
  minValue, maxValue, temp : double;
  D4File : TextFile;
  Index : integer;
  AString : string;
  TimeStepIndex : integer;
  DataSetIndex1, DataSetIndex2 : integer;
  AListItem : TListItem;
  ElementIndex : integer;
  NodeNumber : integer;
  Numbers: array [0..3] of double;
  SetData1  : boolean;
  DataSetIndex : integer;
  LastDataSet : integer;
begin
  numDataParameters := ElementParameterCount;

  if numDataParameters > 0 then
  begin
    // allocate memory for arrays to be passed to Argus ONE.
    GetMem(posX, NumberOfElements*SizeOf(double));
    GetMem(posY, NumberOfElements*SizeOf(double));
    GetMem(dataParameters, numDataParameters*SizeOf(pMatrix));
    GetMem(paramNames, numDataParameters*SizeOf(ANE_STR));
    try
      begin
        FOR DataSetIndex := 0 TO numDataParameters-1 DO
          begin
             GetMem(dataParameters[DataSetIndex], NumberOfElements*SizeOf(DOUBLE));
          end;

        // Fill name array.
        SetElementNames;
        for NameIndex := 0 to NamesList.Count -1 do
        begin
          assert(NameIndex < numDataParameters);
          paramNames^[NameIndex]
            := PChar(NamesList[NameIndex]);
        end;

        if FileExists(D4FileName) then
        begin
          AssignFile(D4File,D4FileName);
          Reset(D4File);
          try
            for Index := 0 to HeaderLineCount-1 do
            begin
              ReadLn(D4File,AString);
            end;
            DataSetIndex1 := -1;
            DataSetIndex2 := -1;
  //          LastDataSet := -1;
            for TimeStepIndex := 0 to lvResult.Items.Count -1 do
            begin
              AListItem := lvResult.Items[TimeStepIndex];
              SetData1 := AListItem.SubItems[Ord(lvhVelocity) -1] = rsYes;
              if SetData1 then
              begin
                DataSetIndex1 := DataSetIndex2 + 1;
                DataSetIndex2 := DataSetIndex1 + 1;
              end;

              for Index := 1 to 3 do
              begin
                ReadLn(D4File,AString);
              end;
              for ElementIndex := 0 to NumberOfElements -1 do
              begin
                ReadLn(D4File,AString);
                ReadSutraElementLine(AString, NodeNumber, Numbers);
                if SetData1 then
                begin
                  if DataSetIndex1 = 0 then
                  begin
                    posX^[ElementIndex] := Numbers[0];
                    posY^[ElementIndex] := Numbers[1];
                  end;
                  assert(ElementIndex < NumberOfElements);
                  assert(DataSetIndex1 < numDataParameters);
                  assert(DataSetIndex2 < numDataParameters);
                  dataParameters[DataSetIndex1]^[ElementIndex] := Numbers[2];
                  dataParameters[DataSetIndex2]^[ElementIndex] := Numbers[3];
                end;

              end;
              ReadLn(D4File,AString);
            end;

            // test for uniform values. Abort if values are uniform to
            // prevent Argus ONE from crashing.
            for DataSetIndex := 0 to numDataParameters -1 do
            begin
              minValue := 0;
              maxValue := 0;
              if NumberOfElements > 0 then
              begin
                minValue := dataParameters[DataSetIndex]^[0];
                maxValue := dataParameters[DataSetIndex]^[0];
              end;
              for ElementIndex := 0 to NumberOfElements - 1 do
              begin
                temp := dataParameters[DataSetIndex]^[ElementIndex];
                if minValue > temp then
                begin
                  minValue := temp;
                end; // if minValue > temp then
                if maxValue < temp then
                begin
                  maxValue := temp;
                end; // if maxValue < temp then
              end; // for i := 0 to numpoints -1 do
              if (minValue = maxValue) then
              begin
                raise EUniformValues.Create('Aborting: data values '
                  + 'are uniform for data set ' + NamesList[DataSetIndex] + '".');
              end;
            end; // for J := 0 to numDataParameters - 1 do


            MinX := 0;
            MinY := 0;
            MaxX := 0;
            MaxY := 0;

            if numDataParameters > 0
            then
              begin
                MinX := posX^[0];
                MinY := posY^[0];
                MaxX := posX^[0];
                MaxY := posY^[0];
              end;

            for MiniMaxIndex := 0 to NumberOfElements -1 do
            begin
              if posX^[MiniMaxIndex] < MinX
              then
              begin
                assert (MiniMaxIndex < NumberOfElements);
                MinX := posX^[MiniMaxIndex]
              end
              else if posX^[MiniMaxIndex] > MaxX
              then
              begin
                assert (MiniMaxIndex < NumberOfElements);
                MaxX := posX^[MiniMaxIndex]
              end;

              if posY^[MiniMaxIndex] < MinY
              then
              begin
                assert (MiniMaxIndex < NumberOfElements);
                MinY := posY^[MiniMaxIndex]
              end
              else if posY^[MiniMaxIndex] > MaxY
              then
              begin
                assert (MiniMaxIndex < NumberOfElements);
                MaxY := posY^[MiniMaxIndex]
              end;
            end;
            DataLayerName := ADataLayerType.ANE_LayerName ;
            dataLayerHandle := ANE_LayerGetHandleByName(anehandle,
              PChar(DataLayerName)  );

            if (dataLayerHandle = nil)
            then
              begin
                ADataLayer := ADataLayerType.Create(ALayerList, -1);
                try
                  DataLayerTemplate := ADataLayer.WriteLayer(anehandle);
                  PreviousLayerHandle := nil; // if the previous layer is not
                  // set to nil there is an access violation if the new data
                  // layer is not the last layer.
                  DataLayerName := ADataLayer.WriteSpecialBeginning
                          + ADataLayer.WriteNewRoot
                          + ADataLayer.WriteSpecialMiddle
                          + ADataLayer.WriteIndex
                          + ADataLayer.WriteSpecialEnd;
                  dataLayerHandle := ANE_LayerAddByTemplate(anehandle,
                     PChar(DataLayerTemplate),
                     PreviousLayerHandle );
                finally
                  ADataLayer.Free;
                end;
              end
            else
              begin
                GetValidLayer(anehandle, dataLayerHandle, ADataLayerType,
                  DataLayerName, ALayerList, UserResponse);

              end;
            if dataLayerHandle = nil
            then
              begin
                Beep;
                ShowMessage('Error creating data layer');
              end
            else
              begin
                  // the access violation would occur here.
                  ANE_DataLayerSetData(aneHandle ,
                                dataLayerHandle ,
                                NumberOfElements, // :	  ANE_INT32   ;
                                @posX^, //:		  ANE_DOUBLE_PTR  ;
                                @posY^, // :	    ANE_DOUBLE_PTR   ;
                                numDataParameters, // : ANE_INT32     ;
                                @dataParameters^, // : ANE_DOUBLE_PTR_PTR  ;
                                @paramNames^  );
              end; // if dataLayerHandle = nil else
          finally
            CloseFile(D4File);
          end;


        end;

      end;
    finally
      begin
        // free memory of arrays passed to Argus ONE.
        FOR DataSetIndex := numDataParameters-1 DOWNTO 0 DO
          begin
            assert(DataSetIndex < numDataParameters);
            FreeMem(dataParameters[DataSetIndex]);
          end;
        FreeMem(dataParameters  );
        FreeMem(posY, NumberOfElements*SizeOf(double));
        FreeMem(posX, NumberOfElements*SizeOf(double));
        FreeMem(paramNames, numDataParameters*SizeOf(ANE_STR));
      end;
    end;
  end;
end;

function TfrmPostSutra.ChartCount: integer;
var
  Index : integer;
  AListItem : TListItem;
begin
  result := 0;
  for Index := 0 to frmPostSutra.lvResult.Items.Count -1 do
  begin
    AListItem := frmPostSutra.lvResult.Items[Index];
    if cbOverlay.Checked then
    begin
      if (AListItem.SubItems[Ord(lvhState) -1] = rsYes) or
         (AListItem.SubItems[Ord(lvhTransType) -1] = rsYes) or
         (AListItem.SubItems[Ord(lvhSaturation) -1] = rsYes) or
         (AListItem.SubItems[Ord(lvhVelocity) -1] = rsYes) then
      begin
        Inc(Result);
      end;
    end
    else
    begin
      if (AListItem.SubItems[Ord(lvhState) -1] = rsYes) then
      begin
        Inc(Result);
      end;

      if (AListItem.SubItems[Ord(lvhTransType) -1] = rsYes) then
      begin
        Inc(Result);
      end;

      if (AListItem.SubItems[Ord(lvhSaturation) -1] = rsYes) then
      begin
        Inc(Result);
      end;
      
      if (AListItem.SubItems[Ord(lvhVelocity) -1] = rsYes) then
      begin
        Inc(Result);
      end;
    end;
  end;
end;

procedure TfrmPostSutra.ChartPositions(NodeStatePositions, NodeTransportPostions,
      NodeSaturationPositions, ElementPositions
  : TIntegerList);
var
  Index : integer;
  AListItem : TListItem;
  Position : integer;
begin
  Position := -1;
  for Index := 0 to frmPostSutra.lvResult.Items.Count -1 do
  begin
    AListItem := frmPostSutra.lvResult.Items[Index];
    if cbOverlay.Checked then
    begin
      if (AListItem.SubItems[Ord(lvhState) -1] = rsYes) or
         (AListItem.SubItems[Ord(lvhTransType) -1] = rsYes) or
         (AListItem.SubItems[Ord(lvhSaturation) -1] = rsYes) or
         (AListItem.SubItems[Ord(lvhVelocity) -1] = rsYes) then
      begin
        Inc(Position);
      end;
      
      if (AListItem.SubItems[Ord(lvhState) -1] = rsYes) then
      begin
        NodeStatePositions.Add(Position);
      end;

      if (AListItem.SubItems[Ord(lvhTransType) -1] = rsYes) then
      begin
        NodeTransportPostions.Add(Position);
      end;

      if (AListItem.SubItems[Ord(lvhSaturation) -1] = rsYes) then
      begin
        NodeSaturationPositions.Add(Position);
      end;

      if (AListItem.SubItems[Ord(lvhVelocity) -1] = rsYes) then
      begin
        ElementPositions.Add(Position);
      end;
    end
    else
    begin
      if (AListItem.SubItems[Ord(lvhState) -1] = rsYes) then
      begin
        Inc(Position);
        NodeStatePositions.Add(Position);
      end;

      if (AListItem.SubItems[Ord(lvhTransType) -1] = rsYes) then
      begin
        Inc(Position);
        NodeTransportPostions.Add(Position);
      end;

      if (AListItem.SubItems[Ord(lvhSaturation) -1] = rsYes) then
      begin
        Inc(Position);
        NodeSaturationPositions.Add(Position);
      end;

      if (AListItem.SubItems[Ord(lvhVelocity) -1] = rsYes) then
      begin
        Inc(Position);
        ElementPositions.Add(Position);
      end;
    end;
  end;
end;

end.
