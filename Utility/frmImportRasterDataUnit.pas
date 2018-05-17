unit frmImportRasterDataUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, Buttons, AnePIE, ComCtrls, ExtCtrls, frmSampleUnit,
  QuadtreeClass, OptionsUnit;

// http://webhelp.esri.com/arcgisdesktop/9.1/index.cfm?id=886&pid=885&topicname=ASCII%20to%20Raster%20(Conversion)


  { TODO : try importing from format specified in
http://gi.leica-geosystems.com/support/files/faq/erdas7xfiles.pdf or
http://www2.erdas.com/SupportSite/documentation/files/erdas7xfiles.pdf }

type
  TXYValue = record
    X: ANE_DOUBLE;
    Y: ANE_DOUBLE;
    Value: ANE_DOUBLE;
  end;

  TfrmImportRasterData = class(TfrmSample)
    odRasterFileDialog: TOpenDialog;
    pcFilter: TPageControl;
    tabGrid: TTabSheet;
    rgGrid: TRadioGroup;
    tabMesh: TTabSheet;
    rgMesh: TRadioGroup;
    Panel1: TPanel;
    comboGridOrMeshLayer: TComboBox;
    Label4: TLabel;
    comboParameterNames: TComboBox;
    Label2: TLabel;
    comboLayers: TComboBox;
    Label1: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    edFileName: TEdit;
    Progress: TProgressBar;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    btnBrowse: TBitBtn;
    rgGridType: TRadioGroup;
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure comboLayersChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure comboGridOrMeshLayerChange(Sender: TObject);
    procedure edFileNameChange(Sender: TObject);
    procedure rgGridTypeClick(Sender: TObject);
  private
    LayerHandle: ANE_PTR;
    DataFile: TextFile;
    NumberOfColumns, NumberOfRows: integer;
    XCorner: double;
    YCorner: double;
    CellSize: double;
    IgnoreValue: double;
    ImportValues: array of TXYValue;
    ImportAllCount: integer;
//    DataValues: array of array of double;
//    UsedValues: array of array of boolean;
    procedure GetDataLayerNames;
    procedure GetParameterNames;
    constructor CreateWithHandle(AOwner: TComponent; aneHandle: ANE_PTR);
    function SetData: boolean;
    function TestFileName: boolean;
    function SetLayerHandle: boolean;
    function HandleFile: boolean;
    function ReadHeader(var ShouldReadNoDataValue: boolean): boolean;
    function ReadData: boolean;
    function ImportData: boolean;
    function TestParameterName: boolean;
    procedure GetGridAndMeshLayerNames;
    procedure SetGridOrMeshLayer;
    function GetGridOrMesh: boolean;
    function GetGridOrMeshLayerType: TPIELayerType;
    { Private declarations }
  public
    { Public declarations }
  end;

  String14 = string[14];

procedure GImportRasterDataPIE(aneHandle: ANE_PTR; const fileName: ANE_STR;
  layerHandle: ANE_PTR); cdecl;

var
  ShouldShow: boolean;
  frmImportRasterData: TfrmImportRasterData;

implementation

uses ANE_LayerUnit, ANECB, UtilityFunctions, RealListUnit;

{$R *.DFM}

type
  TDoubleArray = array[0..MAXINT div 16] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = array[0..MAXINT div 8] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..MAXINT div 8] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;


procedure TfrmImportRasterData.btnBrowseClick(Sender: TObject);
begin
  inherited;
  if odRasterFileDialog.Execute then
  begin
    edFileName.Text := odRasterFileDialog.FileName;
  end;
end;

procedure TfrmImportRasterData.GetDataLayerNames;
var
  Project: TProjectOptions;
  LayerNames: TStringList;
begin
  Project := TProjectOptions.Create;
  LayerNames := TStringList.Create;
  try
    Project.LayerNames(CurrentModelHandle, [pieDataLayer], LayerNames);
    comboLayers.Items := LayerNames;
    if comboLayers.Items.Count > 0 then
    begin
      comboLayers.ItemIndex := 0;
      GetParameterNames;
    end;
  finally
    Project.Free;
    LayerNames.Free
  end;
end;

function TfrmImportRasterData.GetGridOrMeshLayerType: TPIELayerType;
var
  Project: TProjectOptions;
  LayerHandle: ANE_PTR;
  Layer : TLayerOptions;
begin
  result := pieAnyLayer;
  Project := TProjectOptions.Create;
  try
    LayerHandle := Project.GetLayerByName(CurrentModelHandle,
      comboGridOrMeshLayer.Text);
    if LayerHandle <> nil then
    begin
      Layer := TLayerOptions.Create(LayerHandle);
      try
        result := Layer.LayerType[CurrentModelHandle];
        Assert(result in [pieTriMeshLayer,pieQuadMeshLayer,pieGridLayer]);
      finally
        Layer.Free(CurrentModelHandle);
      end;
    end;
  finally
    Project.Free;
  end;
end;

procedure TfrmImportRasterData.SetGridOrMeshLayer;
begin
  case GetGridOrMeshLayerType of
    pieTriMeshLayer,pieQuadMeshLayer:
      begin
        pcFilter.ActivePage := tabMesh;
      end;
    pieGridLayer:
      begin
        pcFilter.ActivePage := tabGrid;
      end;
  else
    begin
      Assert(False);
    end;
  end;
end;

procedure TfrmImportRasterData.GetGridAndMeshLayerNames;
var
  Project: TProjectOptions;
  LayerNames: TStringList;
  Index: integer;
  Layer: TLayerOptions;
  ControlIndex: Integer;
begin
  Project := TProjectOptions.Create;
  LayerNames := TStringList.Create;
  try
    Project.LayerNames(CurrentModelHandle,
      [pieTriMeshLayer,pieQuadMeshLayer, pieGridLayer], LayerNames);
    for Index := LayerNames.Count -1 downto 0 do
    begin
      Layer := TLayerOptions.CreateWithName(LayerNames[Index],
        CurrentModelHandle);
      try
        case Layer.LayerType[CurrentModelHandle] of
          pieTriMeshLayer,pieQuadMeshLayer:
            begin
              if (Layer.NumObjects(CurrentModelHandle,pieElementObject) <= 0)
                or (Layer.NumObjects(CurrentModelHandle,pieNodeObject) <= 0) then
              begin
                LayerNames.Delete(Index);
              end;
            end;
          pieGridLayer:
            begin
              if (Layer.NumObjects(CurrentModelHandle,pieBlockObject) <= 0) then
              begin
                LayerNames.Delete(Index);
              end;
            end;
        else
          begin
            Assert(False);
          end;
        end;
      finally
        Layer.Free(CurrentModelHandle);
      end;
    end;

    comboGridOrMeshLayer.Items := LayerNames;
    if comboGridOrMeshLayer.Items.Count > 0 then
    begin
      comboGridOrMeshLayer.ItemIndex := 0;
      SetGridOrMeshLayer;
    end
    else
    begin
      Beep;
      MessageDlg('Because neither a mesh nor grid is present, your only option '
        + 'will be to import all the data in the raster file.',
        mtInformation, [mbOK], 0);
//      MessageDlg('Error, A grid or mesh must be present to import raster data',
//        mtError, [mbOK], 0);
      pcFilter.ActivePage := tabMesh;
      for ControlIndex := 0 to rgMesh.ControlCount - 2 do
      begin
        rgMesh.Controls[ControlIndex].Enabled := False;
      end;
      rgMesh.ItemIndex := rgMesh.Items.Count -1;
//      ShouldShow := False;
    end;
  finally
    Project.Free;
    LayerNames.Free
  end;
end;

procedure TfrmImportRasterData.FormCreate(Sender: TObject);
begin
  inherited;
  ShouldShow := True;
  GetDataLayerNames;
  GetGridAndMeshLayerNames;
end;

procedure TfrmImportRasterData.GetParameterNames;
var
  Layer: TLayerOptions;
  Project: TProjectOptions;
  LayerHandle: ANE_PTR;
  Names: TStringList;
begin
  Project := TProjectOptions.Create;
  try
    LayerHandle := Project.GetLayerByName(CurrentModelHandle, comboLayers.Text);
    if LayerHandle <> nil then
    begin
      Layer := TLayerOptions.Create(LayerHandle);
      Names := TStringList.Create;
      try
        Layer.GetParameterNames(CurrentModelHandle,Names);
        if Names.Count > 0 then
        begin
          comboParameterNames.Items := Names;
          comboParameterNames.ItemIndex := 0;
        end;
      finally
        Names.Free;
        Layer.Free(CurrentModelHandle);
      end;
    end;
  finally
    Project.Free;
  end;
end;

procedure TfrmImportRasterData.comboLayersChange(Sender: TObject);
begin
  inherited;
  GetParameterNames;
end;

procedure GImportRasterDataPIE(aneHandle: ANE_PTR; const fileName: ANE_STR;
  layerHandle: ANE_PTR); cdecl;
begin
  frmImportRasterData := TfrmImportRasterData.CreateWithHandle(nil, aneHandle);
  try
    if ShouldShow then
    begin
      frmImportRasterData.ShowModal;
    end;
  finally
    frmImportRasterData.Free;
  end;
end;

constructor TfrmImportRasterData.CreateWithHandle(AOwner: TComponent;
  aneHandle: ANE_PTR);
begin
  CurrentModelHandle := aneHandle;
  Create(AOwner);
end;

function TfrmImportRasterData.TestFileName: boolean;
begin
  result := True;
  if not FileExists(edFileName.Text) then
  begin
    Beep;
    MessageDlg('Error: file does not exist.', mtError, [mbOK], 0);
    result := False;
  end;
end;

function TfrmImportRasterData.SetLayerHandle: boolean;
var
  Project: TProjectOptions;
  LayerOptions: TLayerOptions;
  DataLayer : T_ANE_NamedDataLayer;
  LayerTemplate : String;
  ANE_LayerTemplate : ANE_STR;
begin
  result := True;
  Project := TProjectOptions.Create;
  try
    LayerHandle := Project.GetLayerByName(CurrentModelHandle,comboLayers.text);
    if LayerHandle = nil then
    begin
      DataLayer := T_ANE_NamedDataLayer.Create(comboLayers.text, nil , -1);
      try
        LayerTemplate := DataLayer.WriteLayer(CurrentModelHandle);
        GetMem(ANE_LayerTemplate, Length(LayerTemplate) + 1);
        try
          StrPCopy(ANE_LayerTemplate, LayerTemplate);
          LayerHandle := ANE_LayerAddByTemplate(CurrentModelHandle,
            ANE_LayerTemplate,nil);
        finally
          FreeMem(ANE_LayerTemplate);
        end;
      finally
        DataLayer.Free;
      end;
    end
    else
    begin
      LayerOptions := TLayerOptions.Create(LayerHandle);
      try
        result := LayerOptions.LayerType[CurrentModelHandle] = pieDataLayer;
        if not result then
        begin
          Beep;
          MessageDlg(comboLayers.text +
            ' already exist but it is not a data layer.', mtError,
            [mbOK], 0);
        end;
      finally
        LayerOptions.Free(CurrentModelHandle);
      end;
    end;
  finally
    Project.Free;
  end;
end;

function TfrmImportRasterData.ReadHeader(var ShouldReadNoDataValue: boolean): boolean;
var
//  LabelString: String14;
  ErrorString: string;
  Splitter: TStringList;
  ALine: string;
  function ReadFloat(OKText: array of string; out Value: Double): boolean;
  var
    TextIndex: Integer;
    TextOK: Boolean;
  begin
    result := False;
    ReadLn(DataFile, ALine);
    Splitter.DelimitedText := ALine;
    if Splitter.Count <> 2 then
    begin
      Beep;
      MessageDlg(ErrorString, mtError, [mbOK], 0);
      Exit;
    end;

    TextOK := False;
    for TextIndex := 0 to Length(OKText) - 1 do
    begin
      TextOK := LowerCase(Trim(Splitter[0])) = OKText[TextIndex];
      if TextOK then
      begin
        Break;
      end;
    end;
    if not TextOK then
    begin
      Beep;
      MessageDlg(ErrorString, mtError, [mbOK], 0);
      Exit;
    end;


    try
      Value := FortranStrToFloat(Splitter[1]);
    except on E: Exception do
      begin
        Beep;
        MessageDlg(ErrorString, mtError, [mbOK], 0);
        Exit;
      end;
    end;
    result := True;
  end;
begin
  result := False;
  try
    Splitter:= TStringList.Create;
    try
      Splitter.Delimiter := ' ';
      ErrorString := 'Error reading number of columns';
      ReadLn(DataFile, ALine);
      Splitter.DelimitedText := ALine;
      if Splitter.Count <> 2 then
      begin
        Beep;
        MessageDlg(ErrorString, mtError, [mbOK], 0);
        Exit;
      end;

//      ReadLn(DataFile, LabelString, NumberOfColumns);
      if LowerCase(Trim(Splitter[0])) <> 'ncols' then
      begin
        Beep;
        MessageDlg(ErrorString, mtError, [mbOK], 0);
        Exit;
      end;

      if not TryStrToInt(Splitter[1], NumberOfColumns) then
      begin
        Beep;
        MessageDlg(ErrorString, mtError, [mbOK], 0);
        Exit;
      end;


      ErrorString := 'Error reading number of rows';
      ReadLn(DataFile, ALine);
      Splitter.DelimitedText := ALine;
      if Splitter.Count <> 2 then
      begin
        Beep;
        MessageDlg(ErrorString, mtError, [mbOK], 0);
        Exit;
      end;

      if LowerCase(Trim(Splitter[0])) <> 'nrows' then
      begin
        Beep;
        MessageDlg(ErrorString, mtError, [mbOK], 0);
        Exit;
      end;

      if not TryStrToInt(Splitter[1], NumberOfRows) then
      begin
        Beep;
        MessageDlg(ErrorString, mtError, [mbOK], 0);
        Exit;
      end;

//      ReadLn(DataFile, LabelString, NumberOfRows);
//      if LowerCase(Trim(LabelString)) <> 'nrows' then
//      begin
//        Beep;
//        MessageDlg(ErrorString, mtError, [mbOK], 0);
//        Exit;
//      end;

      ErrorString := 'Error reading X[1,1] corner';

      if not ReadFloat(['xllcorner', 'xllcenter'], XCorner) then
      begin
        Exit;
      end;

//      ReadLn(DataFile, ALine);
//      Splitter.DelimitedText := ALine;
//      if Splitter.Count <> 2 then
//      begin
//        Beep;
//        MessageDlg(ErrorString, mtError, [mbOK], 0);
//        Exit;
//      end;
//
//      if (LowerCase(Trim(Splitter[0])) <> 'xllcorner')
//       and (LowerCase(Trim(Splitter[0])) <> 'xllcorner') then
//      begin
//        Beep;
//        MessageDlg(ErrorString, mtError, [mbOK], 0);
//        Exit;
//      end;
//
//      try
//        XCorner := FortranStrToFloat(Splitter[1]);
//      except on E: Exception do
//        begin
//          Beep;
//          MessageDlg(ErrorString, mtError, [mbOK], 0);
//          Exit;
//        end;
//      end;

//      if not TryStrToInt(Splitter[1], NumberOfRows) then
//      begin
//      end;


//      ReadLn(DataFile, LabelString, XCorner);
//      if (LowerCase(Trim(LabelString)) <> 'xllcorner') and
//        (LowerCase(Trim(LabelString)) <> 'xllcenter') then
//      begin
//        Beep;
//        MessageDlg(ErrorString, mtError, [mbOK], 0);
//        Exit;
//      end;

      ErrorString := 'Error reading Y[1,1] corner';

      if not ReadFloat(['yllcorner', 'yllcenter'], YCorner) then
      begin
        Exit;
      end;

//      ReadLn(DataFile, LabelString, YCorner);
//      if (LowerCase(Trim(LabelString)) <> 'yllcorner')
//        and (LowerCase(Trim(LabelString)) <> 'yllcenter') then
//      begin
//        Beep;
//        MessageDlg(ErrorString, mtError, [mbOK], 0);
//        Exit;
//      end;

      ErrorString := 'Error reading cell size';


      if not ReadFloat(['cellsize'], CellSize) then
      begin
        Exit;
      end;


//      ReadLn(DataFile, LabelString, CellSize);
//      if LowerCase(Trim(LabelString)) <> 'cellsize' then
//      begin
//        Beep;
//        MessageDlg(ErrorString, mtError, [mbOK], 0);
//        Exit;
//      end;

      if ShouldReadNoDataValue then
      begin
        if not ReadFloat(['nodata_value'], IgnoreValue) then
        begin
          Exit;
        end;
//        ReadLn(DataFile, LabelString, IgnoreValue);
//        if LowerCase(Trim(LabelString)) <> 'nodata_value' then
//        begin
//          ShouldReadNoDataValue := False;
//        end;
      end
      else
      begin
        IgnoreValue := -9999;
      end;
    finally
      Splitter.Free;
    end;          

    result := True;
  except
    Beep;
    MessageDlg(ErrorString, mtError, [mbOK], 0);
    raise;
  end;
end;

function TfrmImportRasterData.ReadData: boolean;
var
  RowIndex, ColIndex: integer;
  Value: double;
  Values: TVDoubleArray;
  X, Y: double;
  YOrigin: double;
  ImportAll: Boolean;
begin
  result := True;

  if BlockList <> nil then
  begin
    MeshImportChoice := micNone;
    GridImportChoice := TGridImportChoice(rgGrid.ItemIndex+1);
  end
  else
  begin
    GridImportChoice := gicNone;
    MeshImportChoice := TMeshImportChoice(rgMesh.ItemIndex+1);
  end;
  SetLength(Values, 1);

  YOrigin := YCorner + CellSize*NumberOfRows;

  try
    ImportAll := False;
    if BlockList <> nil then
    begin
      ImportAll := GridImportChoice = gicAll;
    end
    else // if NodeList <> nil then
    begin
      ImportAll := MeshImportChoice = micAll;
    end;
    if ImportAll then
    begin
      SetLength(ImportValues, NumberOfColumns* NumberOfRows);
      ImportAllCount := 0;
//      SetLength(UsedValues, NumberOfColumns, NumberOfRows);
    end;
    Progress.Max := NumberOfRows;
    for RowIndex := 0 to NumberOfRows -1 do
    begin
      for ColIndex := 0 to NumberOfColumns-1 do
      begin
        Read(DataFile, Value);

        if (Value = IgnoreValue) then
        begin
          Continue;
        end;

        Values[0] := Value;
        X := ColIndex * CellSize + XCorner + CellSize/2;
        Y := YOrigin - RowIndex * CellSize - CellSize/2;

        SetValues(Values, X, Y);


        if ImportAll then
        begin
          ImportValues[ImportAllCount].X := X;
          ImportValues[ImportAllCount].Y := Y;
          ImportValues[ImportAllCount].Value := Value;
          Inc(ImportAllCount);
        end;
      end;
      Progress.StepIt;
      Application.ProcessMessages;
    end;
  except
    Beep;
    MessageDlg('Error reading data', mtError, [mbOK], 0);
    result := False;
  end;
end;

function TfrmImportRasterData.ImportData: boolean;
var
//  Values: pMatrix;
  PosX, PosY: PDoubleArray;
  Names: PParamNamesArray;
  ValueCount: integer;
  ColIndex, RowIndex: integer;
  DataValue: double;
  X, Y: double;
  Elevations : TList;
  XValues, YValues : TRealList;
  Index: integer;
  Block: TBlock;
  Node: TNode;
  Element: TElement;
  RealPoint: TRealPoint;
  numPoints: integer;
  numDataParameters: integer;
  dataParameters : pMatrix;
  paramNames : PParamNamesArray;
  NameIndex: integer;
  AName: string;
  ParameterIndex: integer;
  Values: TVDoubleArray;
  ImportAll: Boolean;
begin
  Values := nil;
  result := False;

  ImportAll := False;
  Elevations := TList.Create;
  XValues := TRealList.Create;
  YValues := TRealList.Create;
  try
    if BlockList <> nil then
    begin
      if GridImportChoice = gicAll then
      begin
        ImportAll := True;
      end
      else
      begin
        XValues.Capacity := BlockList.Count;
        YValues.Capacity := BlockList.Count;
        Elevations.Capacity := BlockList.Count;
        for Index := 0 to BlockList.Count -1 do
        begin
          Block := BlockList[Index] as TBlock;
          if Block.Count <> 0 then
          begin
            Elevations.Add(Block);
            XValues.Add(Block.X);
            YValues.Add(Block.Y);
          end;
        end;
      end;
    end
    else // if NodeList <> nil then
    begin
      if MeshImportChoice = micAll then
      begin
        ImportAll := True;
      end
      else
      begin
        case MeshImportChoice of
          micClosestNode, micAverageNode, micHighestNode, micLowestNode:
            begin
              XValues.Capacity := NodeList.Count;
              YValues.Capacity := NodeList.Count;
              Elevations.Capacity := NodeList.Count;
              for Index := 0 to NodeList.Count -1 do
              begin
                Node := NodeList[Index] as TNode;
                if Node.Count <> 0 then
                begin
                  Elevations.Add(Node);
                  XValues.Add(Node.X);
                  YValues.Add(Node.Y);
                end;
              end;
            end;
          micClosestElement, micAverageElement, micHighestElement, micLowestElement:
            begin
              XValues.Capacity := ElementList.Count;
              YValues.Capacity := ElementList.Count;
              Elevations.Capacity := ElementList.Count;
              for Index := 0 to ElementList.Count -1 do
              begin
                Element := ElementList[Index] as TElement;
                if Element.Count <> 0 then
                begin
                  Elevations.Add(Element);
                  XValues.Add(Element.X);
                  YValues.Add(Element.Y);
                end;
              end;
            end;
        end;
      end;
    end;

    if ImportAll then
    begin
      numPoints := ImportAllCount;
      numDataParameters := 1;
      // allocate memory for arrays to be passed to Argus ONE.
      GetMem(posX, numPoints*SizeOf(ANE_DOUBLE));
      GetMem(posY, numPoints*SizeOf(ANE_DOUBLE));
      GetMem(dataParameters, numDataParameters*SizeOf(pMatrix));
      GetMem(paramNames, numDataParameters*SizeOf(ANE_STR));
      try
        begin
          FOR Index := 0 TO numDataParameters-1 DO
            begin
               GetMem(dataParameters[Index], numPoints*SizeOf(ANE_DOUBLE));
            end;

          // Fill name array.
          AName := comboParameterNames.Text;
          GetMem(paramNames^[0],(Length(AName) + 1));
          StrPCopy(paramNames^[0], AName);
          for Index := 0 to numPoints -1 do
          begin
            posX^[Index] := ImportValues[Index].X;
            posY^[Index] := ImportValues[Index].Y;
            dataParameters[0]^[Index] := ImportValues[Index].Value;;
          end;
          ANE_DataLayerSetData(CurrentModelHandle ,
                        LayerHandle ,
                        numPoints, // :	  ANE_INT32   ;
                        @posX^, //:		  ANE_DOUBLE_PTR  ;
                        @posY^, // :	    ANE_DOUBLE_PTR   ;
                        numDataParameters, // : ANE_INT32     ;
                        @dataParameters^, // : ANE_DOUBLE_PTR_PTR  ;
                        @paramNames^  );
          result := True;
        end;
      finally
        // free memory of arrays passed to Argus ONE.
        FOR Index := numDataParameters-1 DOWNTO 0 DO
        begin
          assert(Index < numDataParameters);
          FreeMem(dataParameters[Index]);
          FreeMem(paramNames^[Index]);
        end;
        FreeMem(dataParameters  );
        FreeMem(posY);
        FreeMem(posX);
        FreeMem(paramNames);
      end;
    end
    else
    begin
      if Elevations.Count > 0 then
      begin
        RealPoint := Elevations[0];
        Values := RealPoint.Values;
        // Set numDataParameters
        numPoints := Elevations.Count;
        numDataParameters := Length(Values);

        // allocate memory for arrays to be passed to Argus ONE.
        GetMem(posX, numPoints*SizeOf(ANE_DOUBLE));
        GetMem(posY, numPoints*SizeOf(ANE_DOUBLE));
        GetMem(dataParameters, numDataParameters*SizeOf(pMatrix));
        GetMem(paramNames, numDataParameters*SizeOf(ANE_STR));
        try
          begin
            FOR Index := 0 TO numDataParameters-1 DO
              begin
                 GetMem(dataParameters[Index], numPoints*SizeOf(ANE_DOUBLE));
              end;

            // Fill name array.
            AName := comboParameterNames.Text;
            GetMem(paramNames^[0],(Length(AName) + 1));
            StrPCopy(paramNames^[0], AName);
            for Index := 0 to numPoints -1 do
            begin
              posX^[Index] := XValues[Index];
              posY^[Index] := YValues[Index];
              RealPoint := Elevations[Index];
              Values := RealPoint.Values;
              Assert(Length(Values) =  numDataParameters);
              for ParameterIndex := 0 to numDataParameters -1 do
              begin
                dataParameters[ParameterIndex]^[Index] := Values[ParameterIndex];
              end;

            end;
            ANE_DataLayerSetData(CurrentModelHandle ,
                          LayerHandle ,
                          numPoints, // :	  ANE_INT32   ;
                          @posX^, //:		  ANE_DOUBLE_PTR  ;
                          @posY^, // :	    ANE_DOUBLE_PTR   ;
                          numDataParameters, // : ANE_INT32     ;
                          @dataParameters^, // : ANE_DOUBLE_PTR_PTR  ;
                          @paramNames^  );
            result := True;


          end;
        finally
          begin
            // free memory of arrays passed to Argus ONE.
            FOR Index := numDataParameters-1 DOWNTO 0 DO
              begin
                assert(Index < numDataParameters);
                FreeMem(dataParameters[Index]);
                FreeMem(paramNames^[Index]);
              end;
            FreeMem(dataParameters  );
            FreeMem(posY);
            FreeMem(posX);
            FreeMem(paramNames);
          end;
        end;
      end
      else
      begin
        Beep;
        MessageDlg('None of the data points are inside the grid.',
          mtError, [mbOK], 0);
      end;
    end;
  finally
    Elevations.Free;
    XValues.Free;
    YValues.Free;
  end;

end;

function TfrmImportRasterData.HandleFile: boolean;
var
  ShouldReadHeader: boolean;
begin
  try
    ShouldReadHeader := True;
    AssignFile(DataFile, edFileName.Text);
    try
      Reset(DataFile);
      result := ReadHeader(ShouldReadHeader);
      if not result then Exit;
    finally
      CloseFile(DataFile);
    end;
    AssignFile(DataFile, edFileName.Text);
    try
      Reset(DataFile);
      result := ReadHeader(ShouldReadHeader) and ReadData and ImportData;
    finally
      CloseFile(DataFile);
    end;
  except
    raise;
  end;
end;

function TfrmImportRasterData.TestParameterName: boolean;
begin
  if comboParameterNames.text = '' then
  begin
    comboParameterNames.text := comboLayers.Text;
  end;
  result := comboParameterNames.text <> '';
  if not result then
  begin
    Beep;
    MessageDlg('Error, no parameter name is specified.', mtError, [mbOK], 0);
  end;
end;

function TfrmImportRasterData.GetGridOrMesh: boolean;
begin
  result := True;
  if comboGridOrMeshLayer.Text = '' then
  begin

  end
  else
  begin
    case GetGridOrMeshLayerType of
      pieTriMeshLayer,pieQuadMeshLayer:
        begin
          GetMeshWithName(comboGridOrMeshLayer.Text);
        end;
      pieGridLayer:
        begin
          case rgGridType.ItemIndex of
            0:
              begin
                GetBlockCenteredGrid(comboGridOrMeshLayer.Text);
              end;
            1:
              begin
                GetNodeCenteredGrid(comboGridOrMeshLayer.Text);
              end;
          else
            begin
              Result := False;
              Beep;
              MessageDlg('Error: Grid type has not been specified',
                mtError, [mbOK], 0);
            end;
          end;
        end;
    else
      begin
        Assert(False);
      end;
    end;
  end;
end;

function TfrmImportRasterData.SetData: boolean;
begin
  result := TestFileName
    and SetLayerHandle
    and TestParameterName
    and GetGridOrMesh
    and HandleFile;
end;

procedure TfrmImportRasterData.BitBtn1Click(Sender: TObject);
begin
  inherited;
  if SetData then
  begin
    ModalResult := mrOK;
  end;
end;

procedure TfrmImportRasterData.comboGridOrMeshLayerChange(Sender: TObject);
begin
  inherited;
  SetGridOrMeshLayer;
end;


procedure TfrmImportRasterData.edFileNameChange(Sender: TObject);
begin
  inherited;
  if FileExists(edFileName.Text) then
  begin
    edFileName.Color := clWindow;
  end;

end;

procedure TfrmImportRasterData.rgGridTypeClick(Sender: TObject);
begin
  inherited;
  if rgGridType.ItemIndex >= 0 then
  begin
    rgGridType.Color := clBtnFace;
  end;

end;

end.
