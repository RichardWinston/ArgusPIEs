unit PostSutraUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, contnrs, frmSutraUnit, AnePIE, ANE_LayerUnit,
  IntListUnit;

type
  TListViewHeaders = (lvhTimeStep, lvhState, lvhTransType, lvhSaturation, lvhVelocity);

  TintegerArray = Array[0..(MAXINT) div 8 -1] of LongInt;
  PIntegerArray = ^TintegerArray;
  TDoubleArray = Array[0..(MAXINT) div 8 -1] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = Array[0..(MAXINT) div 8 -1] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..(MAXINT) div 8 -1] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;

  EUniformValues = Class(Exception);

  TTriangulationRecord = record
    Node1, Node2, Node3 : integer;
  end;

  TTriangulationObject = class(TObject)
    Triangulation : TTriangulationRecord;
  end;

  TTriangulationList = Class(TObjectList)
  private
    procedure SetItem(Index : integer; const Triangulation : TTriangulationRecord);
    function GetItem(Index : integer) : TTriangulationRecord;
  public
    function Add(Triangulation : TTriangulationRecord) : integer;
    property Items[Index : integer] : TTriangulationRecord read GetItem write SetItem;
  end;

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
    function GetLastTimeRow: integer;
    { Private declarations }
  protected
    function ExtractFileRoot(FileName: string): string;
    Procedure ReadNodeFileHeader(FileName : String);
    procedure ReadElementFileHeader(FileName: String);
  public
    NodeHeaderLineCount : integer;
    ElementHeaderLineCount : integer;
    NumberOfNodes : ANE_INT32;
    NumberOfElements: ANE_INT32;
    FirstUp : boolean;
    NamesList : TStringList;
    TitlesList : TStringList;
    NodeFileName, ElementFileName : string;
    function ReadHeaders(FileName: String) : string;
    Procedure ReadAndSetArgusNodeData(var MinX, MinY, MaxX,
      MaxY : double; var DataLayerName : string;
      ADataLayerType: T_ANE_DataLayerClass; var dataLayerHandle : ANE_PTR;
      anehandle  : ANE_PTR; ALayerList : T_ANE_LayerList; var MinState, MaxState,
      MinTransport, MaxTransport, MinSaturation, MaxSaturation : double;
      TriangulationList : TTriangulationList);
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

procedure ReadIncidence(FileRoot : string; TriangulationList : TTriangulationList);

implementation

{$R *.DFM}

uses GetListViewCellStringUnit, ArgusFormUnit, FixNameUnit,
  ANECB, LayerNamePrompt, SLDataLayer, WriteSutraPostProcessingUnit,
  SLMap, UtilityFunctions;

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
        if CellString <> rsNoYesNotOK then
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

function fixNumber(AString : String) : string;
var
  SignPosition : integer;
  SignChar : string;
  TempString : string;
begin
  SignPosition := Pos('-',AString);
  if SignPosition = 0 then
  begin
    SignPosition := Pos('+',AString);
  end;
  if SignPosition = 0 then
  begin
    result := AString;
  end
  else
  begin
    if SignPosition = 1 then
    begin
      SignChar := AString[1];
      TempString := Copy(AString,2,Length(AString));
    end
    else
    begin
      SignChar := '';
      TempString := AString;
    end;
    SignPosition := Pos('-',TempString);
    if SignPosition = 0 then
    begin
      SignPosition := Pos('+',TempString);
    end;
    if SignPosition = 0 then
    begin
      result := AString;
    end
    else
    begin
      Dec(SignPosition);
      if (TempString[SignPosition] = 'e') or (TempString[SignPosition] = 'E')
      then
      begin
        result := AString;
      end
      else
      begin
        result := SignChar + Copy(TempString,1,SignPosition) + 'E'
          + Copy(TempString,SignPosition+1,Length(TempString));
      end;
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
  if frmSutra.cbNodeElementNumbers.Checked then
  begin
    AString := Copy(ANodeLine, 1, 9);
    NodeNumber := StrToInt(Trim(AString));
    Position := 10;
  end
  else
  begin
    Position := 2;
  end;
  for Index := 0 to Count -1 do
  begin
    AString := Copy(ANodeLine, Position, 15);
    Inc(Position,15);
    Numbers[Index] := InternationalStrToFloat(fixNumber(Trim(AString)));
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
  if frmSutra.cbNodeElementNumbers.Checked then
  begin
    AString := Copy(AnElementLine, 1, 9);
    ElementNumber := StrToInt(Trim(AString));
    Position := 12;
  end
  else
  begin
    Position := 2;
    Inc(ElementNumber);
  end;
  for Index := 0 to Count -1 do
  begin
    AString := Copy(AnElementLine, Position, 15);
    Inc(Position,15);
    Numbers[Index] := InternationalStrToFloat(fixNumber(Trim(AString)));
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
//  Index :Integer;
  DPosition : integer;
begin
  DPosition := Pos('D',AString);
  if DPosition = 0 then
  begin
    DPosition := Pos('d',AString);
  end;
  if DPosition > 0 then
  begin
    AString[DPosition] := 'E';
  end;
{  for Index := 1 to Length(AString) do
  begin
    if (AString[Index] = 'D') or (AString[Index] = 'd') then
    begin
      AString[Index] := 'E';
    end;
  end;  }
  result := StrToFloat(AString);
end;

Procedure TfrmPostSutra.ReadNodeFileHeader(FileName : String);
var
  NodeFile : TextFile;
  AString : String;
  Index: Integer;
  AListItem : TListItem;
//  Time : double;
  StateCalculated : boolean;
  TransportCalculated : boolean;
  TimeStep : integer;
  SubItemCount, SubItemsIndex : integer;

  TransportType :TTransportType;
  StateVariable: TStateVariableType  ;
  TimeSteps : integer;
//  LocalString : String;
begin
  if FileExists(FileName) then
  begin
    AssignFile(NodeFile,FileName);
    Reset(NodeFile);
    try
      NodeHeaderLineCount := 0;

      // Read titles
      ReadLn(NodeFile,AString);
      Inc(NodeHeaderLineCount);
      ReadLn(NodeFile,AString);
      Inc(NodeHeaderLineCount);
      // Read nodewise or element wise results
      ReadLn(NodeFile,AString);
      Inc(NodeHeaderLineCount);
      // ReadNumber of nodes
      ReadLn(NodeFile,AString);
      Inc(NodeHeaderLineCount);
      AString := Trim(Copy(AString, Pos('MESH',AString)+4, Length(AString)));
      AString := Trim(Copy(AString, 1, Pos('Nodes',AString)-1));
      if Pos('=',AString) > 0 then
      begin
        AString := Trim(Copy(AString, Pos('=',AString)+1, Length(AString)));
      end;
      NumberOfNodes := StrToInt(AString);

      // ReadNumber of time steps
      ReadLn(NodeFile,AString);
      Inc(NodeHeaderLineCount);
      ReadLn(NodeFile,AString);
      Inc(NodeHeaderLineCount);
      ReadLn(NodeFile,AString);
      Inc(NodeHeaderLineCount);
      AString := Trim(Copy(AString, Pos('RESULTS',AString)+7, Length(AString)));
      AString := Trim(Copy(AString, 1, Pos('Time',AString)-1));
      TimeSteps := StrToInt(AString);

      // Skip lines
      ReadLn(NodeFile,AString);
      Inc(NodeHeaderLineCount);
      ReadLn(NodeFile,AString);
      Inc(NodeHeaderLineCount);
      ReadLn(NodeFile,AString);
      Inc(NodeHeaderLineCount);

      //  Get Transport type and State variable
      ReadLn(NodeFile,AString);
      Inc(NodeHeaderLineCount);
//      {$IFDEF SUTRA21}
      StateVariable := GetStateVariableFromString(Copy(AString, 44, 5));
      TransportType := GetTransportTypeFromString(Copy(AString, 59, 4));
//      {$ELSE}
//      StateVariable := GetStateVariableFromString(Copy(AString, 39, 5));
//      TransportType := GetTransportTypeFromString(Copy(AString, 54, 4));
//      {$ENDIF}

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

      ReadLn(NodeFile,AString);
      Inc(NodeHeaderLineCount);

      // read time step info.
      lvResult.Items.BeginUpdate;
      try
        for Index := 1 to TimeSteps do
        begin
          ReadLn(NodeFile,AString);
          Inc(NodeHeaderLineCount);

          // read info for each time step.
//          Time := DStrToFloat(Trim(Copy(AString,19,13)));
//          {$IFDEF SUTRA21}
          StateCalculated := Copy(AString,41,1) = 'Y';
          TransportCalculated := Copy(AString,56,1) = 'Y';
          TimeStep := StrToInt(Trim(Copy(AString,11,8)));
//          {$ELSE}
//          StateCalculated := Copy(AString,36,1) = 'Y';
//          TransportCalculated := Copy(AString,51,1) = 'Y';
//          TimeStep := StrToInt(Trim(Copy(AString,7,8)));
//          {$ENDIF}

          // add a new list item.
          AListItem := lvResult.Items.Add;

          // Set the time step of the new list item
          AListItem.Caption := IntToStr(TimeStep);

          // set the number of subitems
          SubItemCount := Ord(High(TListViewHeaders));
          for SubItemsIndex := 1 to SubItemCount do
          begin
            AListItem.SubItems.Add(rsNoYesNotOK);
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
      end;
      finally
        lvResult.Items.EndUpdate;
      end;
    finally
      CloseFile(NodeFile);
    end;
  end;
end;

Procedure TfrmPostSutra.ReadElementFileHeader(FileName : String);
var
  ElementFile : TextFile;
  AString : String;
  Index: Integer;
  AListItem : TListItem;
  SubItemsIndex : integer;
  TimeSteps : integer;
  TimeStep, CurrentTimeStep : integer;
  SubItemCount: integer;
//  Time : double;
//  FoundItem : boolean;
  function FindItem : TListItem;
  var
    first, last, middle : integer;
    SubItemsIndex : integer;
    CurrentListItem : TListItem;
    NewItem : boolean;
//    lvhSubItemIndex : TListViewHeaders;
    SubItemCount : integer;
  begin
    NewItem := False;
    first := 0;
    last := lvResult.Items.Count -1;
    CurrentListItem := lvResult.Items[first];
    CurrentTimeStep := StrToInt(CurrentListItem.Caption);
    if CurrentTimeStep > TimeStep then
    begin
      result := lvResult.Items.Insert(first);
      NewItem := True;
    end
    else if CurrentTimeStep = TimeStep then
    begin
      result := CurrentListItem;
    end
    else
    begin
      CurrentListItem := lvResult.Items[last];
      CurrentTimeStep := StrToInt(CurrentListItem.Caption);
      if CurrentTimeStep < TimeStep then
      begin
        result := lvResult.Items.Add;
        NewItem := True;
      end
      else if CurrentTimeStep = TimeStep then
      begin
        result := CurrentListItem;
      end
      else
      begin
        while (last - first) > 1 do
        begin
          middle := (last + first) div 2;
          CurrentListItem := lvResult.Items[middle];
          CurrentTimeStep := StrToInt(CurrentListItem.Caption);
          if CurrentTimeStep = TimeStep then
          begin
            result := CurrentListItem;
            Exit;
          end
          else if CurrentTimeStep > TimeStep
          then
          begin
            last := middle;
          end
          else
          begin
            first := middle;
          end;
        end;
        result := lvResult.Items.Insert(last);
        NewItem := True;
      end;
    end;
    if NewItem then
    begin
      result.Caption := IntToStr(TimeStep);
      SubItemCount := Ord(High(TListViewHeaders));
      for SubItemsIndex := 1 to SubItemCount do
      begin
        result.SubItems.Add(rsNoYesNotOK);
      end;
    end;
  end;
begin
  if FileExists(FileName) then
  begin
    AssignFile(ElementFile,FileName);
    Reset(ElementFile);
    try
      ElementHeaderLineCount := 0;

      // Read titles
      ReadLn(ElementFile,AString);
      Inc(ElementHeaderLineCount);
      ReadLn(ElementFile,AString);
      Inc(ElementHeaderLineCount);
      // Read nodewise or element wise results
      ReadLn(ElementFile,AString);
      Inc(ElementHeaderLineCount);
      // ReadNumber of elements
      ReadLn(ElementFile,AString);
      Inc(ElementHeaderLineCount);

      AString := Trim(Copy(AString, Pos('MESH',AString)+4, Length(AString)));
//      {$IFDEF SUTRA21}
      AString := Trim(Copy(AString, 1, Pos('Elems',AString)-1));
//      {$ELSE}
//      AString := Trim(Copy(AString, 1, Pos('Elements',AString)-1));
//      {$endif}
      if Pos('=',AString) > 0 then
      begin
        AString := Trim(Copy(AString, Pos('=',AString)+1, Length(AString)));
      end;
      NumberOfElements := StrToInt(AString);


      // ReadNumber of time steps
      ReadLn(ElementFile,AString);
      Inc(ElementHeaderLineCount);
      ReadLn(ElementFile,AString);
      Inc(ElementHeaderLineCount);
      ReadLn(ElementFile,AString);
      Inc(ElementHeaderLineCount);
      AString := Trim(Copy(AString, Pos('RESULTS',AString)+7, Length(AString)));
      AString := Trim(Copy(AString, 1, Pos('Time',AString)-1));
      TimeSteps := StrToInt(AString);

      // Skip lines
      ReadLn(ElementFile,AString);
      Inc(ElementHeaderLineCount);
      ReadLn(ElementFile,AString);
      Inc(ElementHeaderLineCount);
      ReadLn(ElementFile,AString);
      Inc(ElementHeaderLineCount);
      ReadLn(ElementFile,AString);
      Inc(ElementHeaderLineCount);
      ReadLn(ElementFile,AString);
      Inc(ElementHeaderLineCount);

      for Index := 0 to lvResult.Items.Count -1 do
      begin
        AListItem := lvResult.Items[Index];
        SubItemsIndex := Ord(lvhVelocity) -1;
        AListItem.SubItems[SubItemsIndex] := rsNoYesNotOK;
      end;

      // read time step info.
      lvResult.Items.BeginUpdate;
      try
        for Index := 1 to TimeSteps do
        begin
          ReadLn(ElementFile,AString);
          Inc(ElementHeaderLineCount);

          // read info for each time step.
//          Time := DStrToFloat(Trim(Copy(AString,19,13)));
//          {$IFDEF SUTRA21}
          TimeStep := StrToInt(Trim(Copy(AString,11,8)));
//          {$ELSE}
//          TimeStep := StrToInt(Trim(Copy(AString,7,8)));
//          {$ENDIF}

          if (lvResult.Items.Count > Index-1) then
          begin
            AListItem := lvResult.Items[Index-1];
          end
          else
          begin
            // add a new list item.
            AListItem := lvResult.Items.Add;

            // Set the time step of the new list item
            AListItem.Caption := IntToStr(TimeStep);

            // set the number of subitems
            SubItemCount := Ord(High(TListViewHeaders));
            for SubItemsIndex := 1 to SubItemCount do
            begin
              AListItem.SubItems.Add(rsNoYesNotOK);
            end;
          end;


          if StrToInt(AListItem.Caption) = TimeStep then
          begin
            SubItemsIndex := Ord(lvhVelocity) -1;
            AListItem.SubItems[SubItemsIndex] := rsNoButYesOK;
          end
          else
          begin
            AListItem := FindItem;
            Assert(AListItem <> nil);
            SubItemsIndex := Ord(lvhVelocity) -1;
            AListItem.SubItems[SubItemsIndex] := rsNoButYesOK;
          end;
      end;
      finally
        lvResult.Items.EndUpdate;
      end;


    finally
      CloseFile(ElementFile);
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

function TfrmPostSutra.ReadHeaders(FileName: String) : string;
var
  RootName : string;
begin
  RootName := ExtractFileRoot(FileName);
  NodeFileName := RootName + '.nod';
  ElementFileName := RootName + '.ele';
  ReadNodeFileHeader(NodeFileName );
  ReadElementFileHeader(ElementFileName);
  result := RootName;
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
  MapsTestPChar : ANE_Str;
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
  if (ChartType = ctContour) and (layerHandle <> nil) then
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

      ANE_ExportTextFromOtherLayer(aneHandle, layerHandle, @MapsTestPChar );
      MapsText := String(MapsText);
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
  NodeDataLayerName, ElementDataLayerName : string;
  ErrorMessage : string;
  NodeDataLayerHandle, ElementDataLayerHandle : ANE_PTR;
  NodeItemsToPlot, ElementItemsToPlot : TIntegerList;
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
  StringToWrite : String;
  maplayerhandle : ANE_PTR;
  DrawAxes : boolean;
  InpFileRoot : string;
  TriangulationList : TTriangulationList;
  AString : ANE_STR;
//  ANE_LayerNameStr : ANE_STR;
//  Buffer : ANE_STR;
begin
  if EditWindowOpen
  then
  begin
    Beep;
    MessageDlg('You can not perform post-processing while exporting a ' +
    ' project or if an edit box is open.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
//      begin
      try  // try 2
//        begin
        DrawAxes := True;
        frmSutra := TArgusForm.GetFormFromArgus(aneHandle)
          as TfrmSutra;

        if frmSutra.Is3D then
        begin
          Beep;
          MessageDlg('SUTRA Post-processing in the SUTRA GUI is only '
            + 'available for two-dimensional models.', mtInformation,
            [mbOK], 0);
        end
        else
        begin



  {              Beep;
          If MessageDlg('Argus may crash during postprocessing. You should'
            + ' save your work before continuing. Are you ready to continue?',
            mtWarning, [mbYes, mbNo], 0) = mrYes then   }
  //            begin
          frmPostSutra :=
            TfrmPostSutra.Create(Application);
          try

            frmPostSutra.OpenDialog1.FileName
              := GetCurrentDir
              + frmPostSutra.ExtractFileRoot(frmSutra.edRoot.Text) + '.nod';
            if frmPostSutra.OpenDialog1.Execute then
            begin
              InpFileRoot := frmPostSutra.ReadHeaders(frmPostSutra.OpenDialog1.FileName);
              TriangulationList := TTriangulationList.Create;
              try
                ReadIncidence(InpFileRoot, TriangulationList);
                if frmPostSutra.ShowModal = mrOk then
                begin
                  StringToWrite := '*';
                  ChartCount := frmPostSutra.ChartCount;
                  NodeStatePositions := TIntegerList.Create;
                  NodeTransportPostions := TIntegerList.Create;
                  NodeSaturationPositions := TIntegerList.Create;
                  ElementPositions := TIntegerList.Create;
                  try
                    frmPostSutra.ChartPositions(NodeStatePositions,
                      NodeTransportPostions, NodeSaturationPositions,
                      ElementPositions);

                    NodeDataLayerName := TSutraNodeDataLayer.ANE_LayerName;
                    NodeDataLayerHandle := nil;

                    frmPostSutra.ReadAndSetArgusNodeData(MinX, MinY, MaxX, MaxY,
                      NodeDataLayerName, TSutraNodeDataLayer, NodeDataLayerHandle,
                      anehandle, frmSutra.SutraLayerStructure.PostProcessingLayers,
                      MinState, MaxState, MinTransport, MaxTransport,
                      MinSaturation, MaxSaturation, TriangulationList);

                    ElementDataLayerName := TSutraElementDataLayer.ANE_LayerName;
                    ElementDataLayerHandle := nil;

                    frmPostSutra.ReadAndSetArgusElementData(MinX, MinY, MaxX,
                      MaxY, ElementDataLayerName, TSutraElementDataLayer,
                      ElementDataLayerHandle, anehandle,
                      frmSutra.SutraLayerStructure.PostProcessingLayers);

                    PostLayerName := TSutraPostMapLayer.ANE_LayerName;
                    PostLayerHandle := GetLayerHandle(aneHandle, PostLayerName);
  {                  GetMem(ANE_LayerNameStr, Length(PostLayerName) + 1);
                    try
                      StrPCopy(ANE_LayerNameStr,PostLayerName);
                      PostLayerHandle := GetLayerByName(aneHandle, ANE_LayerNameStr);
                    finally
                      FreeMem(ANE_LayerNameStr);
                    end;  }
  //                  PostLayerHandle := ANE_LayerGetHandleByName(aneHandle,
  //                    PChar(PostLayerName) );

                    UseExistingLayer := False;
                    if NodeDataLayerHandle <> nil then
                    begin
                      NodeItemsToPlot := TIntegerList.Create;
                      try
                        if frmPostSutra.NodeStateParameterCount > 0 then
                        begin
                          for Index := 0 to
                            frmPostSutra.NodeStateParameterCount -1 do
                          begin
                            NodeItemsToPlot.Add(Index);
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

    {$IFDEF debug}
    //    ShowMessage('A');
    {$ENDIF}
                          StringToWrite := StringToWrite +
                          WriteSutraPostProcessing(aneHandle, frmPostSutra.NamesList,
                            frmPostSutra.TitlesList,
                            NodeItemsToPlot, ctContour, NodeDataLayerName,
                            TSutraPostMapLayer, MinX, MinY, MaxX, MaxY,
                            frmSutra.SutraLayerStructure.PostProcessingLayers, False,
                            MapLayerName, ChartCount, NodeStatePositions,
                            CalculateDelta, Min,Max,Delta,maplayerhandle,
                            DrawAxes);
                          DrawAxes := not frmPostSutra.cbOverlay.Checked;
    {$IFDEF debug}
    //    ShowMessage('B');
    {$ENDIF}

                        end;

                        if frmPostSutra.NodeTrasportedParameterCount > 0 then
                        begin
                          NodeItemsToPlot.Clear;

                          for Index := 0 to
                            frmPostSutra.NodeTrasportedParameterCount -1 do
                          begin
                            NodeItemsToPlot.Add(Index);
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
                          end;
    {$IFDEF debug}
    //    ShowMessage('C');
    {$ENDIF}
                          StringToWrite := StringToWrite +
                          WriteSutraPostProcessing(aneHandle, frmPostSutra.NamesList,
                            frmPostSutra.TitlesList,
                            NodeItemsToPlot, ctContour, NodeDataLayerName,
                            TSutraPostMapLayer, MinX, MinY, MaxX, MaxY,
                            frmSutra.SutraLayerStructure.PostProcessingLayers,
                            UseExistingLayer, MapLayerName, ChartCount,
                            NodeTransportPostions, CalculateDelta, Min,Max,
                            Delta,maplayerhandle, DrawAxes);
                          DrawAxes := not frmPostSutra.cbOverlay.Checked;
    {$IFDEF debug}
    //    ShowMessage('D');
    {$ENDIF}

                        end;

                        if frmPostSutra.NodeSaturationParameterCount > 0 then
                        begin
                          NodeItemsToPlot.Clear;

                          for Index := 0 to
                            frmPostSutra.NodeSaturationParameterCount -1 do
                          begin
                            NodeItemsToPlot.Add(Index);
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
                          end;

    {$IFDEF debug}
    //    ShowMessage('E');
    {$ENDIF}
                          StringToWrite := StringToWrite +
                          WriteSutraPostProcessing(aneHandle, frmPostSutra.NamesList,
                            frmPostSutra.TitlesList,
                            NodeItemsToPlot, ctContour, NodeDataLayerName,
                            TSutraPostMapLayer, MinX, MinY, MaxX, MaxY,
                            frmSutra.SutraLayerStructure.PostProcessingLayers,
                            UseExistingLayer, MapLayerName, ChartCount,
                            NodeSaturationPositions, CalculateDelta, Min,Max,
                            Delta,maplayerhandle, DrawAxes);
                          DrawAxes := not frmPostSutra.cbOverlay.Checked;
    {$IFDEF debug}
    //    ShowMessage('F');
    {$ENDIF}
                        end;
                      finally
                        NodeItemsToPlot.Free;
                      end;

                    end;


                    if ElementDataLayerHandle <> nil then
                    begin
                      ElementItemsToPlot := TIntegerList.Create;
                      try
                        for Index := 0 to
                          frmPostSutra.ElementParameterCount -1 do
                        begin
                          ElementItemsToPlot.Add(Index);
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

    {$IFDEF debug}
    //    ShowMessage('G');
    {$ENDIF}
                        StringToWrite := StringToWrite +
                        WriteSutraPostProcessing(aneHandle, frmPostSutra.NamesList,
                          frmPostSutra.TitlesList,
                          ElementItemsToPlot, ctVector, ElementDataLayerName,
                          TSutraPostMapLayer, MinX, MinY, MaxX, MaxY,
                          frmSutra.SutraLayerStructure.PostProcessingLayers,
                          UseExistingLayer, MapLayerName, ChartCount,
                          ElementPositions, CalculateDelta, Min,Max,Delta,
                          maplayerhandle, DrawAxes);
    //                          DrawAxes := not frmPostSutra.cbOverlay.Checked;
    {$IFDEF debug}
    //    ShowMessage('H');
    {$ENDIF}
                      finally
                        ElementItemsToPlot.Free;
                      end;

                    end;
                  finally
                    NodeStatePositions.Free;
                    NodeTransportPostions.Free;
                    NodeSaturationPositions.Free;
                    ElementPositions.Free;
                  end;
                  if (StringToWrite <> '*') and (maplayerhandle <> nil) then
                  begin
    {$IFDEF debug}
    ShowMessage('This is just before ANE_ImportTextToLayerByHandle');
    {$ENDIF}
                  GetMem(AString, Length(StringToWrite) + 1);
                  try
                    StrPCopy(AString, StringToWrite);

                    ANE_ImportTextToLayerByHandle(aneHandle , maplayerhandle,
                      AString);
                  finally
                    FreeMem(AString);
                  end;
    {$IFDEF debug}
    ShowMessage('This is just after ANE_ImportTextToLayerByHandle');
    {$ENDIF}

    {                      Buffer := ANE_MemAlloc(aneHandle, (Length(StringToWrite) + 801)*SizeOf(Char));
                    StrPCopy(Buffer, StringToWrite);
                    ANE_ImportTextToLayerByHandle(aneHandle , maplayerhandle,
                      Buffer);
                    ANE_MemDelete(aneHandle,Buffer);  }
                  end;
                end;
              finally
                TriangulationList.Free;
              end;

            end;
          finally
            frmPostSutra.Free;
          end;
        end;
//            end;

//        end; // try 2
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
          ErrorMessage :=
//                IntToStr(ErrorIndex) + ' ' +
            'The following error occurred in the '
            + 'SUTRA post-processing PIE. "'
            + E.Message + '" Contact PIE Developer';

          if frmSutra.PIEDeveloper <> '' then
          begin
            ErrorMessage := ErrorMessage + ' (' + frmSutra.PIEDeveloper + ')';
          end;
          ErrorMessage := ErrorMessage + ' for assistance.';
          Beep;
          MessageDlg(ErrorMessage,mtError,[mbOK],0);
            // result := False;
        end;
      end  // try 2
//      end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

function TfrmPostSutra.GetLastTimeRow: integer;
var
  Index : integer;
  AListItem : TListItem;
begin
  result := -1;
  for Index := 0 to lvResult.Items.Count -1 do
  begin
    AListItem := lvResult.Items[Index];
    if AListItem.SubItems[Ord(lvhState) -1] = rsYes then
    begin
      result := Index;
    end;
    if AListItem.SubItems[Ord(lvhTransType) -1] = rsYes then
    begin
      result := Index;
    end;
    if AListItem.SubItems[Ord(lvhSaturation) -1] = rsYes then
    begin
      result := Index;
    end;
    if AListItem.SubItems[Ord(lvhVelocity) -1] = rsYes then
    begin
      result := Index;
    end;
  end;
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


procedure TfrmPostSutra.FormDestroy(Sender: TObject);
begin
  NamesList.Free;
  TitlesList.Free;
end;

procedure TfrmPostSutra.ReadAndSetArgusNodeData(var MinX, MinY, MaxX,
  MaxY : double; var DataLayerName : string;
  ADataLayerType: T_ANE_DataLayerClass; var dataLayerHandle : ANE_PTR;
  anehandle  : ANE_PTR; ALayerList : T_ANE_LayerList; var MinState, MaxState,
  MinTransport, MaxTransport, MinSaturation, MaxSaturation : double;
  TriangulationList : TTriangulationList);
var
  numDataParameters  : ANE_INT32;
  posX : PDoubleArray;
  posY : PDoubleArray;
  node0 : PIntegerArray;
  node1 : PIntegerArray;
  node2 : PIntegerArray;
  dataParameters : pMatrix;
  paramNames : PParamNamesArray;
  NameIndex : integer;
  ADataLayer : T_ANE_DataLayer;
  MiniMaxIndex : integer;
  DataLayerTemplate : string;
  PreviousLayerHandle : ANE_PTR;
  minValue, maxValue, temp : double;
  NodeFile : TextFile;
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
  numTriangles : ANE_INT32   ;
  triangleIndex : integer;
  Triangulation : TTriangulationRecord;
  AName : string;
  ANE_LayerTemplate : ANE_STR;
  ANE_LayerNameStr : ANE_STR;
  ErrorFound : boolean;
begin
  numDataParameters := NodeParameterCount;

  if numDataParameters > 0 then
  begin
    FirstState := True;
    FirstTransport := True;
    FirstSaturation := True;
    // allocate memory for arrays to be passed to Argus ONE.
    GetMem(posX, NumberOfNodes*SizeOf(ANE_DOUBLE));
//    posX := ANE_MemAlloc(frmSutra.CurrentModelHandle, NumberOfNodes*SizeOf(ANE_DOUBLE) );
    assert(posX<>nil);
    GetMem(posY, NumberOfNodes*SizeOf(ANE_DOUBLE));
//    posY := ANE_MemAlloc(frmSutra.CurrentModelHandle, NumberOfNodes*SizeOf(ANE_DOUBLE) );
    assert(posY<>nil);

    numTriangles := TriangulationList.Count;
    if numTriangles > 0 then
    begin
      GetMem(node0, numTriangles*SizeOf(ANE_INT32));
      assert(node0<>nil);
      GetMem(node1, numTriangles*SizeOf(ANE_INT32));
      assert(node1<>nil);
      GetMem(node2, numTriangles*SizeOf(ANE_INT32));
      assert(node2<>nil);
    end
    else
    begin
      node0 := nil;
      node1 := nil;
      node2 := nil;
    end;


    GetMem(dataParameters, numDataParameters*SizeOf(pMatrix));
//    dataParameters := ANE_MemAlloc(frmSutra.CurrentModelHandle, numDataParameters*SizeOf(ANE_DOUBLE_PTR) );
    assert(dataParameters<>nil);
    GetMem(paramNames, (numDataParameters)*SizeOf(ANE_STR));
//    paramNames := ANE_MemAlloc(frmSutra.CurrentModelHandle, numDataParameters*SizeOf(ANE_STR) );
    assert(paramNames<>nil);
    FOR DataSetIndex := 0 TO numDataParameters-1 DO
    begin
      Assert(DataSetIndex<numDataParameters);
      GetMem(dataParameters^[DataSetIndex], NumberOfNodes*SizeOf(ANE_DOUBLE));
//      dataParameters^[DataSetIndex] := ANE_MemAlloc(frmSutra.CurrentModelHandle, NumberOfNodes*SizeOf(ANE_DOUBLE) );
      assert(dataParameters^[DataSetIndex]<>nil);
    end;
    SetNodeNames;
    Assert(NamesList.Count = numDataParameters);
{    FOR NameIndex := 0 TO numDataParameters-1 DO
    begin
      GetMem(paramNames^[NameIndex], (Length(NamesList[NameIndex]) + 1)*SizeOf(Char));
//      dataParameters^[DataSetIndex] := ANE_MemAlloc(frmSutra.CurrentModelHandle, NumberOfNodes*SizeOf(ANE_DOUBLE) );
      assert(paramNames^[NameIndex]<>nil);
    end;  }
    for NameIndex := 0 to NamesList.Count -1 do
    begin
      assert(NameIndex < numDataParameters);
      AName := NamesList[NameIndex];
      GetMem(paramNames^[NameIndex],(Length(AName) + 1));
      StrPCopy(paramNames^[NameIndex], AName);
//      paramNames^[NameIndex] := {StrNew} (PChar(NamesList[NameIndex]));
    end;
//    paramNames^[numDataParameters] := nil;
    try
      begin
        for triangleIndex := 0 to numTriangles -1 do
        begin
          Triangulation := TriangulationList.Items[triangleIndex];
          Node0^[triangleIndex] := Triangulation.Node1;
          Node1^[triangleIndex] := Triangulation.Node2;
          Node2^[triangleIndex] := Triangulation.Node3;
        end;

        FOR DataSetIndex := 0 TO numDataParameters-1 DO
        begin
          Assert(DataSetIndex<numDataParameters);
          for NodeIndex := 0 to NumberOfNodes -1 do
          begin
            Assert(NodeIndex<NumberOfNodes);
            dataParameters^[DataSetIndex]^[NodeIndex] := 0;
          end;
        end;
{$IFDEF debug}
//  ShowMessage('Node Data 1');
{$ENDIF}

        // Fill name array.
{        for NameIndex := 0 to NamesList.Count -1 do
        begin
          assert(NameIndex < numDataParameters);
          strPCopy(paramNames^[NameIndex],NamesList[NameIndex]);
//          paramNames^[NameIndex] := PChar(NamesList[NameIndex]);
        end;  }
{$IFDEF debug}
//  ShowMessage('Node Data 2');
{$ENDIF}

        if FileExists(NodeFileName) then
        begin
          AssignFile(NodeFile,NodeFileName);
          Reset(NodeFile);
          try
            for Index := 0 to NodeHeaderLineCount-1 do
            begin
              ReadLn(NodeFile,AString);
            end;
            DataSetIndex1 := -1;
            DataSetIndex2 := -1;
            DataSetIndex3 := -1;
            LastDataSet := -1;
            ErrorFound := False;
            for TimeStepIndex := 0 to GetLastTimeRow do
            begin
              if ErrorFound then break;
              AListItem := lvResult.Items[TimeStepIndex];
              if AListItem.SubItems[Ord(lvhState) -1] <> rsNoYesNotOK then
              begin
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

                for Index := 1 to 5 do
                begin
                  ReadLn(NodeFile,AString);
                  if Pos('RUN TERMINATED DUE TO ERROR', AString) > 0 then
                  begin
                    ErrorFound := True;
                    Beep;
                    MessageDlg('SUTRA terminated due to an error. '
                      + 'Check SUTRA output files for more information',
                      mtError, [mbOK], 0);
                    break;
                  end;
                end;
                if ErrorFound then break;
                for NodeIndex := 0 to NumberOfNodes -1 do
                begin
                  ReadLn(NodeFile,AString);
                  if AString = '' then
                  begin
                    Beep;
                    MessageDlg('Error reading Node Number '
                      + IntToStr(NodeIndex + 1)
                      + ' in time step '
                      + AListItem.Caption, mtError, [mbOK], 0);
                    ErrorFound := True;
                    break;
                  end;

                  ReadSutraNodeLine(AString, NodeNumber, Numbers);
                  if SetData1 then
                  begin
                    assert(NodeIndex < NumberOfNodes);
                    if DataSetIndex1 = 0 then
                    begin
                      posX^[NodeIndex] := Numbers[0];
                      posY^[NodeIndex] := Numbers[1];
                    end;
                    assert(DataSetIndex1 < numDataParameters);
                    dataParameters^[DataSetIndex1]^[NodeIndex] := Numbers[2];
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
                    assert(NodeIndex < NumberOfNodes);
                    if DataSetIndex2 = 0 then
                    begin
                      posX^[NodeIndex] := Numbers[0];
                      posY^[NodeIndex] := Numbers[1];
                    end;
                    assert(DataSetIndex2 < numDataParameters);
                    dataParameters^[DataSetIndex2]^[NodeIndex] := Numbers[3];
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
                    assert(NodeIndex < NumberOfNodes);
                    if DataSetIndex3 = 0 then
                    begin
                      posX^[NodeIndex] := Numbers[0];
                      posY^[NodeIndex] := Numbers[1];
                    end;
                    assert(DataSetIndex3 < numDataParameters);
                    dataParameters^[DataSetIndex3]^[NodeIndex] := Numbers[4];
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
              end;
            end;
{$IFDEF debug}
//  ShowMessage('Node Data 4');
{$ENDIF}

            // test for uniform values. Abort if values are uniform to
            // prevent Argus ONE from crashing.
            for DataSetIndex := 0 to numDataParameters -1 do
            begin
              minValue := 0;
              maxValue := 0;
              if NumberOfNodes > 0 then
              begin
                assert(DataSetIndex < numDataParameters);
                Assert(0<NumberOfNodes);
                minValue := dataParameters^[DataSetIndex]^[0];
                maxValue := dataParameters^[DataSetIndex]^[0];
              end;
              for NodeIndex := 0 to NumberOfNodes - 1 do
              begin
                assert(DataSetIndex < numDataParameters);
                assert(NodeIndex < NumberOfNodes);
                temp := dataParameters^[DataSetIndex]^[NodeIndex];
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
{$IFDEF debug}
//  ShowMessage('Node Data 5');
{$ENDIF}


            MinX := 0;
            MinY := 0;
            MaxX := 0;
            MaxY := 0;

            if numDataParameters > 0
            then
              begin
                assert (0 < NumberOfNodes);
                MinX := posX^[0];
                MinY := posY^[0];
                MaxX := posX^[0];
                MaxY := posY^[0];
              end;

            for MiniMaxIndex := 0 to NumberOfNodes -1 do
            begin
              assert (MiniMaxIndex < NumberOfNodes);
              if posX^[MiniMaxIndex] < MinX
              then
              begin
                MinX := posX^[MiniMaxIndex]
              end
              else if posX^[MiniMaxIndex] > MaxX
              then
              begin
                MaxX := posX^[MiniMaxIndex]
              end;

              if posY^[MiniMaxIndex] < MinY
              then
              begin
                MinY := posY^[MiniMaxIndex]
              end
              else if posY^[MiniMaxIndex] > MaxY
              then
              begin
                MaxY := posY^[MiniMaxIndex]
              end;
            end;
            DataLayerName := ADataLayerType.ANE_LayerName ;
{$IFDEF debug}
//  ShowMessage('Node Data 6');
{$ENDIF}

            dataLayerHandle := GetLayerHandle(aneHandle, DataLayerName);
{            GetMem(ANE_LayerNameStr, Length(DataLayerName) + 1);
            try
              StrPCopy(ANE_LayerNameStr,DataLayerName);
              dataLayerHandle := GetLayerByName(aneHandle, ANE_LayerNameStr);
            finally
              FreeMem(ANE_LayerNameStr);
            end; }
//            dataLayerHandle := ANE_LayerGetHandleByName(anehandle,
//              PChar(DataLayerName)  );

            if (dataLayerHandle = nil)
            then
              begin
                ADataLayer := ADataLayerType.Create(ALayerList, -1);
                try
                  DataLayerTemplate := ADataLayer.WriteLayer(anehandle);
                  PreviousLayerHandle := nil;
                  // if the previous layer is not
                  // set to nil there is an access violation if the new data
                  // layer is not the last layer.
                  DataLayerName := ADataLayer.WriteSpecialBeginning
                          + ADataLayer.WriteNewRoot
                          + ADataLayer.WriteSpecialMiddle
                          + ADataLayer.WriteIndex
                          + ADataLayer.WriteSpecialEnd;
{$IFDEF debug}
//  ShowMessage('Node Data 7');
{$ENDIF}
                  GetMem(ANE_LayerTemplate, Length(DataLayerTemplate) + 1);
                  try
                    StrPCopy(ANE_LayerTemplate, DataLayerTemplate);
                    dataLayerHandle := ANE_LayerAddByTemplate(anehandle,
                       ANE_LayerTemplate, PreviousLayerHandle );
                  finally
                    FreeMem(ANE_LayerTemplate);
                  end;
{$IFDEF debug}
//  ShowMessage('Node Data 8');
{$ENDIF}
                finally
                  ADataLayer.Free;
                end;
              end
            else
              begin
{$IFDEF debug}
  ShowMessage('Node Data 9');
{$ENDIF}
                GetValidLayer(anehandle, dataLayerHandle, ADataLayerType,
                  DataLayerName, ALayerList, UserResponse);
{$IFDEF debug}
  ShowMessage('Node Data 10');
{$ENDIF}

              end;
            if dataLayerHandle = nil
            then
              begin
                Beep;
                ShowMessage('Error creating data layer');
              end
            else
              begin
                if numTriangles = 0 then
                begin
                  ANE_DataLayerSetData(aneHandle ,
                                dataLayerHandle ,
                                NumberOfNodes,
                                @posX^,
                                @posY^,
                                numDataParameters,
                                @dataParameters^,
                                @paramNames^  );
                end
                else
                begin


                  // access violations sometimes occur here.
{                  ANE_DataLayerSetData(aneHandle ,
                                dataLayerHandle ,
                                NumberOfNodes,
                                @(posX^[0]),
                                @(posY^[0]),
                                numDataParameters,
                                @(dataParameters^[0]),
                                @(paramNames^[0])  );   }

                  ANE_DataLayerSetTriangulatedData(aneHandle,
                                dataLayerHandle,
                                NumberOfNodes,
				@posX^,
                                @posY^,
				numTriangles,
				@node0^,
				@node1^,
				@node2^,
				numDataParameters,
                                @dataParameters^,
                                @paramNames^  );

                end;

              end; // if dataLayerHandle = nil else
          finally
            CloseFile(NodeFile);
          end;


        end;

      end;
    finally
      begin
        // free memory of arrays passed to Argus ONE.
{        for NameIndex := NamesList.Count -1 downto 0 do
        begin
          assert(NameIndex < numDataParameters);
          strDispose(paramNames^[NameIndex]);
        end;  }
{        FOR NameIndex := numDataParameters-1 DOWNTO 0 DO
        begin
          assert(NameIndex < numDataParameters);
          FreeMem(paramNames^[NameIndex]);
        end;         }
        FOR DataSetIndex := numDataParameters-1 DOWNTO 0 DO
        begin
          assert(DataSetIndex < numDataParameters);
          FreeMem(dataParameters^[DataSetIndex]{, NumberOfNodes*SizeOf(ANE_DOUBLE)});
//          ANE_MemDelete(frmSutra.CurrentModelHandle, dataParameters^[DataSetIndex] );
          FreeMem(paramNames^[DataSetIndex]{, NumberOfNodes*SizeOf(ANE_DOUBLE)});
        end;
        FreeMem(dataParameters{, numDataParameters*SizeOf(pMatrix)});
//        ANE_MemDelete(frmSutra.CurrentModelHandle, dataParameters );
        FreeMem(posY{, NumberOfNodes*SizeOf(ANE_DOUBLE)});
//        ANE_MemDelete(frmSutra.CurrentModelHandle, posY );
        FreeMem(posX {, NumberOfNodes*SizeOf(ANE_DOUBLE)});
//        ANE_MemDelete(frmSutra.CurrentModelHandle, posX );
        FreeMem(node0{, NumberOfNodes*SizeOf(ANE_DOUBLE)});
        FreeMem(node1{, NumberOfNodes*SizeOf(ANE_DOUBLE)});
        FreeMem(node2{, NumberOfNodes*SizeOf(ANE_DOUBLE)});
        FreeMem(paramNames {, numDataParameters*SizeOf(ANE_STR)});
//        ANE_MemDelete(frmSutra.CurrentModelHandle, paramNames );
      end;
    end;
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
  gridLayerHandle : ANE_PTR;
  Angle, CosAngle, SinAngle : double;
  DelX, DelY : double;
  ADataLayer : T_ANE_DataLayer;
  MiniMaxIndex : integer;
  DataLayerTemplate : string;
  PreviousLayerHandle : ANE_PTR;
  DataLayerIndex : integer;
  minValue, maxValue, temp : double;
  ElementFile : TextFile;
  Index : integer;
  AString : string;
  TimeStepIndex : integer;
  DataSetIndex1, DataSetIndex2 : integer;
  AListItem : TListItem;
  ElementIndex : integer;
  ElementNumber : integer;
  Numbers: array [0..3] of double;
  SetData1  : boolean;
  DataSetIndex : integer;
  LastDataSet : integer;
  ANE_LayerTemplate : ANE_STR;
  ANE_LayerNameStr : ANE_STR;
  ErrorFound : boolean;
begin
  numDataParameters := ElementParameterCount;

  if numDataParameters > 0 then
  begin
    // allocate memory for arrays to be passed to Argus ONE.
    GetMem(posX, NumberOfElements*SizeOf(ANE_DOUBLE));
    assert(posX<>nil);
    GetMem(posY, NumberOfElements*SizeOf(ANE_DOUBLE));
    assert(posY<>nil);
    GetMem(dataParameters, numDataParameters*SizeOf(pMatrix));
    assert(dataParameters<>nil);
    GetMem(paramNames, (numDataParameters)*SizeOf(ANE_STR));
    assert(paramNames<>nil);
    try
      begin
        FOR DataSetIndex := 0 TO numDataParameters-1 DO
        begin
          Assert(DataSetIndex<numDataParameters);
          GetMem(dataParameters^[DataSetIndex], NumberOfElements*SizeOf(ANE_DOUBLE));
          assert(dataParameters^[DataSetIndex]<>nil);
        end;

        // Fill name array.
        SetElementNames;
        Assert(NamesList.Count = numDataParameters);
        for NameIndex := 0 to NamesList.Count -1 do
        begin
          assert(NameIndex < numDataParameters);
          GetMem(paramNames^[NameIndex], Length(NamesList[NameIndex]) + 1);
//          strPCopy(paramNames^[NameIndex],NamesList[NameIndex]);
//            paramNames^[NameIndex] := PChar(NamesList[NameIndex]);

        end;

{        for NameIndex := 0 to NamesList.Count -1 do
        begin
          assert(NameIndex < numDataParameters);
          paramNames^[NameIndex] := (PChar(NamesList[NameIndex]));
        end;   }
//        paramNames^[numDataParameters] := nil;
        try
          FOR DataSetIndex := 0 TO numDataParameters-1 DO
          begin
            Assert(DataSetIndex<numDataParameters);
            for ElementIndex := 0 to NumberOfElements -1 do
            begin
              dataParameters^[DataSetIndex]^[ElementIndex] := 1e-10;
            end;
          end;

          for NameIndex := 0 to NamesList.Count -1 do
          begin
            assert(NameIndex < numDataParameters);
//            GetMem(paramNames^[NameIndex], Length(NamesList[NameIndex]) + 1);
            strPCopy(paramNames^[NameIndex],NamesList[NameIndex]);
//            paramNames^[NameIndex] := PChar(NamesList[NameIndex]);

          end;

          if FileExists(ElementFileName) then
          begin
            AssignFile(ElementFile,ElementFileName);
            Reset(ElementFile);
            try
              for Index := 0 to ElementHeaderLineCount-1 do
              begin
                ReadLn(ElementFile,AString);
              end;
              DataSetIndex1 := -1;
              DataSetIndex2 := -1;
              ErrorFound := False;
              for TimeStepIndex := 0 to GetLastTimeRow do
              begin
                if ErrorFound then break;
                AListItem := lvResult.Items[TimeStepIndex];
                if AListItem.SubItems[Ord(lvhVelocity) -1] <> rsNoYesNotOK then
                begin
                  SetData1 := AListItem.SubItems[Ord(lvhVelocity) -1] = rsYes;
                  if SetData1 then
                  begin
                    DataSetIndex1 := DataSetIndex2 + 1;
                    DataSetIndex2 := DataSetIndex1 + 1;
                  end;

                  for Index := 1 to 5 do
                  begin
                    ReadLn(ElementFile,AString);
                    if Pos('RUN TERMINATED DUE TO ERROR', AString) > 0 then
                    begin
                      ErrorFound := True;
                      Beep;
                      MessageDlg('SUTRA terminated due to an error. '
                        + 'Check SUTRA output files for more information',
                        mtError, [mbOK], 0);
                      break;
                    end;
                  end;
                  If ErrorFound then Break;
                  ElementNumber := 0;
                  for ElementIndex := 0 to NumberOfElements -1 do
                  begin
                    ReadLn(ElementFile,AString);
                    if AString = '' then
                    begin
                      Beep;
                      MessageDlg('Error reading Element Number '
                        + IntToStr(ElementIndex + 1)
                        + ' in time step '
                        + AListItem.Caption, mtError, [mbOK], 0);
                      ErrorFound := True;
                      break;
                    end;
                    ReadSutraElementLine(AString, ElementNumber, Numbers);
                    if SetData1 then
                    begin
                      assert(ElementIndex < NumberOfElements);
                      if DataSetIndex1 = 0 then
                      begin
                        posX^[ElementIndex] := Numbers[0];
                        posY^[ElementIndex] := Numbers[1];
                      end;
                      assert(DataSetIndex1 < numDataParameters);
                      assert(DataSetIndex2 < numDataParameters);
                      dataParameters^[DataSetIndex1]^[ElementIndex] := Numbers[2];
                      dataParameters^[DataSetIndex2]^[ElementIndex] := Numbers[3];
                    end;

                  end;
                end;
              end;

              // test for uniform values. Abort if values are uniform to
              // prevent Argus ONE from crashing.
              for DataSetIndex := 0 to numDataParameters -1 do
              begin
                minValue := 0;
                maxValue := 0;
                if NumberOfElements > 0 then
                begin
                  Assert(DataSetIndex<numDataParameters);
                  Assert(0<NumberOfElements);
                  minValue := dataParameters^[DataSetIndex]^[0];
                  maxValue := dataParameters^[DataSetIndex]^[0];
                end;
                for ElementIndex := 0 to NumberOfElements - 1 do
                begin
                  assert(DataSetIndex < numDataParameters);
                  Assert(ElementIndex<NumberOfElements);
                  temp := dataParameters^[DataSetIndex]^[ElementIndex];
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
                  assert(0 < NumberOfElements);
                  MinX := posX^[0];
                  MinY := posY^[0];
                  MaxX := posX^[0];
                  MaxY := posY^[0];
                end;

              for MiniMaxIndex := 0 to NumberOfElements -1 do
              begin
                assert(MiniMaxIndex < NumberOfElements);
                if posX^[MiniMaxIndex] < MinX
                then
                begin
                  MinX := posX^[MiniMaxIndex]
                end
                else if posX^[MiniMaxIndex] > MaxX
                then
                begin
                  MaxX := posX^[MiniMaxIndex]
                end;

                if posY^[MiniMaxIndex] < MinY
                then
                begin
                  MinY := posY^[MiniMaxIndex]
                end
                else if posY^[MiniMaxIndex] > MaxY
                then
                begin
                  MaxY := posY^[MiniMaxIndex]
                end;
              end;
              DataLayerName := ADataLayerType.ANE_LayerName ;
              dataLayerHandle := GetLayerHandle(aneHandle, DataLayerName);
{              GetMem(ANE_LayerNameStr, Length(DataLayerName) + 1);
              try
                StrPCopy(ANE_LayerNameStr,DataLayerName);
                dataLayerHandle := GetLayerByName(aneHandle, ANE_LayerNameStr);
              finally
                FreeMem(ANE_LayerNameStr);
              end;
              dataLayerHandle := ANE_LayerGetHandleByName(anehandle,
                PChar(DataLayerName)  ); }

              if (dataLayerHandle = nil)
              then
                begin
                  ADataLayer := ADataLayerType.Create(ALayerList, -1);
                  try
                    DataLayerTemplate := ADataLayer.WriteLayer(anehandle);
                    PreviousLayerHandle := nil;
                    // if the previous layer is not
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
                    // access violation sometimes occur here.
                    ANE_DataLayerSetData(aneHandle ,
                                  dataLayerHandle ,
                                  NumberOfElements,
                                  @posX^,
                                  @posY^,
                                  numDataParameters,
                                  @dataParameters^,
                                  @paramNames^  );
                end; // if dataLayerHandle = nil else
            finally
              CloseFile(ElementFile);
            end;


          end;
        finally
          FOR DataSetIndex := numDataParameters-1 DOWNTO 0 DO
          begin
            assert(DataSetIndex < numDataParameters);
            FreeMem(dataParameters^[DataSetIndex] {, NumberOfElements*SizeOf(ANE_DOUBLE)});
            FreeMem(paramNames^[DataSetIndex] {, NumberOfElements*SizeOf(ANE_DOUBLE)});
          end;
{          for NameIndex := NamesList.Count -1 downto 0 do
          begin
            assert(NameIndex < numDataParameters);
            strDispose(paramNames^[NameIndex]);
          end; }
        end;

      end;
    finally
      begin
        // free memory of arrays passed to Argus ONE.
        FreeMem(dataParameters {, numDataParameters*SizeOf(pMatrix)}  );
        FreeMem(posY {, NumberOfElements*SizeOf(ANE_DOUBLE)});
        FreeMem(posX {, NumberOfElements*SizeOf(ANE_DOUBLE)});
        FreeMem(paramNames {, numDataParameters*SizeOf(ANE_STR)});
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

procedure ReadIncidence(FileRoot : string; TriangulationList : TTriangulationList);
var
  InpFile : TextFile;
  FileName : string;
  ALine : string;
  ElementNumber, Node1, Node2, Node3, Node4 : integer;
  Triangulation: TTriangulationRecord;
begin
  FileName := FileRoot + '.inp';
  TriangulationList.Clear;
  if FileExists(FileName) then
  begin
    AssignFile(InpFile,FileName);
    try
      Reset(InpFile);
      While Not EOF(InpFile) do
      begin
        ReadLn(InpFile,ALine);
        ALine := UpperCase(ALine);
        if Pos('INCIDENCE',ALine) > 0 then
        begin
          break;
        end;
      end;
      While Not EOF(InpFile) do
      begin
        Read(InpFile,ElementNumber, Node1, Node2, Node3, Node4);
        ReadLn(InpFile);
//        if not EOF(InpFile) then
        begin
//          Dec(ElementNumber);
          Dec(Node1);
          Dec(Node2);
          Dec(Node3);
          Dec(Node4);

          Triangulation.Node1 := Node1;
          Triangulation.Node2 := Node2;
          Triangulation.Node3 := Node3;
          TriangulationList.Add(Triangulation);

          Triangulation.Node1 := Node3;
          Triangulation.Node2 := Node4;
          Triangulation.Node3 := Node1;
          TriangulationList.Add(Triangulation);

        end;
      end;

    finally
      CloseFile(InpFile);
    end;
  end;

end;

{ TTriangulationList }

function TTriangulationList.Add(
  Triangulation: TTriangulationRecord): integer;
var
  TriangulationObject : TTriangulationObject;
begin
  TriangulationObject := TTriangulationObject.Create;
  TriangulationObject.Triangulation := Triangulation;
  result := inherited Add(TriangulationObject);
end;

function TTriangulationList.GetItem(Index: integer): TTriangulationRecord;
var
  TriangulationObject : TTriangulationObject;
begin
  TriangulationObject := inherited Items[Index] as TTriangulationObject;
  result := TriangulationObject.Triangulation;
end;

procedure TTriangulationList.SetItem(Index: integer;
  const Triangulation: TTriangulationRecord);
var
  TriangulationObject : TTriangulationObject;
begin
  TriangulationObject := inherited Items[Index] as TTriangulationObject;
  TriangulationObject.Triangulation := Triangulation;
end;

end.
