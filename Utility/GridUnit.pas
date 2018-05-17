unit GridUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DataGrid, StdCtrls, Spin, ComCtrls, StringGrid3d, AnePIE, IntListUnit,
  ArgusFormUnit, ANE_LayerUnit, Buttons, ExtCtrls, Clipbrd, Math, addbtn95,
  Rbw95Button, siComboBox;

type
  TintegerArray = Array[0..MAXINT div 8] of LongInt;
  PIntegerArray = ^TintegerArray;
  TDoubleArray = Array[0..MAXINT div 16] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = Array[0..MAXINT div 8] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..MAXINT div 8] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;


{  TintegerArray = Array[0..32760] of LongInt;
  PIntegerArray = ^TintegerArray;
  TDoubleArray = Array[0..32760] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = Array[0..32760] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..32760] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;  }

  EUnmatchedQuote = Class(Exception);

  TfrmGrid = class(TArgusForm)
    Panel6: TPanel;
    Panel1: TPanel;
    sgNames: TStringGrid;
    Panel2: TPanel;
    Label5: TLabel;
    Label1: TLabel;
    seDataSets: TSpinEdit;
    Splitter1: TSplitter;
    Panel3: TPanel;
    dgIgnore: TDataGrid;
    Panel4: TPanel;
    Label6: TLabel;
    seIgnore: TSpinEdit;
    Panel7: TPanel;
    Panel5: TPanel;
    rgDataFormat: TRadioGroup;
    BitBtn2: TBitBtn;
    btnOK: TBitBtn;
    dg3dData: TRBWDataGrid3d;
    Splitter2: TSplitter;
    BitBtn1: TBitBtn;
    cb95MultipleLines: TCheckBox95;
    OpenDialog1: TOpenDialog;
    cbSeparateLayers: TCheckBox95;
    btnAbout: TButton;
    btnPaste: TBitBtn;
    WrapBtn1: TBitBtn;
    comboDataLayerName: TsiComboBox;
    procedure FormCreate(Sender: TObject); override;
    procedure seDataSetsChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure seIgnoreChange(Sender: TObject);
    procedure sgNamesSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure dg3dDataSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure btnFileClick(Sender: TObject);
    procedure cbSeparateLayersClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure comboDataLayerNameChange(Sender: TObject);
  private
    Count : integer;
    NCOL, NROW : ANE_INT32;
    GridLayerHandle : ANE_PTR;
//    MinX, MaxX, MinY, MaxY, GridAngle : ANE_DOUBLE;
    RowsReversed, ColsReversed : boolean;
    NodeNumberArray : array of array of integer;
    ErrorCount : integer;
    TempLayerName : string;
    function GetCellCenters(var posX, posY : PDoubleArray) : boolean;
    function CellCount: integer;
    function BlockIndex(RowIndex, ColIndex: integer): integer;
    procedure GetThisGrid;
    function IsCellActive(XIndex, YIndex: integer): boolean;
    function GetTriangles(var node0, node1, node2: PIntegerArray) : integer;
    procedure GetData(var dataParameters: pMatrix);
    procedure GetNames(var paramNames: PParamNamesArray);
    procedure ReadCommaValuesString(var AString, ASubstring: string);
    procedure ReadTabValuesString(var AString, ASubstring: string);
    procedure ReadValuesFromStringList(AStringList: TStringList;
      ADataGrid: TDataGrid; ACol: integer = 1; ARow: integer = 1);
    procedure SetColumnWidths(ADataGrid: TDataGrid);
    function Initialize: boolean;
    function ParameterNamesOK: boolean;
    procedure GetAName(var paramNames: PParamNamesArray;
      const NameIndex: integer);
    procedure GetADataSet(var dataParameters: pMatrix;
      const DataSetIndex: integer);
    function GetACellCount(const DataSetIndex: integer): integer;
    procedure SetDataInOneLayer;
    procedure SetDataInMultipleLayers;
    function GetCellCentersForADataSet(var posX, posY: PDoubleArray;
      const DataSetIndex: integer): boolean;
    function DataOK: boolean;
    function IgnoreValuesOK: boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

  TThisDataLayer = class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
  end;

procedure GGridDataPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

var
  frmGrid: TfrmGrid;

implementation

uses OptionsUnit, UtilityFunctions, LayerNamePrompt, ANECB, FixNameUnit, ChooseLayerUnit,
  frmAboutUnit, frmPreviewUnit;

{$R *.DFM}

procedure TfrmGrid.FormCreate(Sender: TObject);
begin
  sgNames.Cells[0,0] := 'Parameter names';
  ErrorCount := 0;
end;

procedure TfrmGrid.seDataSetsChange(Sender: TObject);
var
  Index : integer;
  ADataGrid : TDataGrid;
  ColIndex : integer;
  ATabSheet : TTabSheet;
  AColumn : TColumn;
  RowIndex : integer;
begin
  sgNames.RowCount := seDataSets.Value + 1;
  if seDataSets.Value > dg3dData.GridCount then
  begin
    for Index := dg3dData.GridCount to seDataSets.Value -1 do
    begin
      sgNames.Cells[0,Index + 1] := 'A Name' + IntToStr(Index + 1);
      dg3dData.AddGrid;
      ADataGrid := dg3dData.Grids[Index];
      ATabSheet := dg3dData.Pages[Index];
      ATabSheet.Caption := sgNames.Cells[0,Index+1];
      for ColIndex := 1 to ADataGrid.ColCount -1 do
      begin
        AColumn := ADataGrid.Columns[ColIndex];
        AColumn.Format := cfNumber;
        AColumn.Title.Caption := IntToStr(ColIndex);
      end;
      for RowIndex := 1 to ADataGrid.RowCount -1 do
      begin
        ADataGrid.Cells[0,RowIndex] := IntToStr(RowIndex);
      end;
    end;
  end
  else
  begin
    for Index := dg3dData.GridCount-1 downto seDataSets.Value  do
    begin
      dg3dData.RemoveGrid(Index);
    end;
  end;
  dg3dData.ActivePageIndex := seDataSets.Value-1;
end;

Function TfrmGrid.GetACellCount(Const DataSetIndex : integer) : integer;
var
  RowIndex, ColIndex : integer;
  ADataGrid : TDataGrid;
  IgnoreIndex : Integer;
  AValue, TestValue : double;
  IgnoreValue : boolean;
begin
  result := 0;
  SetLength(NodeNumberArray, NCOL, NROW);

  if dg3dData.GridCount > DataSetIndex then
  begin
    ADataGrid := dg3dData.Grids[DataSetIndex];
    for RowIndex := 1 to ADataGrid.RowCount -1 do
    begin
      for ColIndex := 1 to ADataGrid.ColCount -1 do
      begin
        if Trim(ADataGrid.Cells[ColIndex,RowIndex]) <> '' then
        begin
          IgnoreValue := False;
          AValue := StrToFloat(Trim(ADataGrid.Cells[ColIndex,RowIndex]));
          for IgnoreIndex := 1 to seIgnore.Value do
          begin
            TestValue := StrToFloat(Trim(dgIgnore.Cells[0,IgnoreIndex]));
            IgnoreValue := (AValue = TestValue);
            if IgnoreValue then
            begin
              break;
            end;
          end;
          if IgnoreValue then
          begin
            NodeNumberArray[ColIndex-1, RowIndex-1] := -1;
          end
          else
          begin
            Inc(result);
            NodeNumberArray[ColIndex-1, RowIndex-1] := result-1;
          end;
        end
        else
        begin
          NodeNumberArray[ColIndex-1, RowIndex-1] := -1;
        end;
      end;
    end;
  end;
end;

Function TfrmGrid.CellCount : integer;
var
  RowIndex, ColIndex : integer;
  ADataGrid : TDataGrid;
  IgnoreIndex : Integer;
  AValue, TestValue : double;
  IgnoreValue : boolean;
begin
  result := 0;
  SetLength(NodeNumberArray, NCOL, NROW);

  if dg3dData.GridCount > 0 then
  begin
    ADataGrid := dg3dData.Grids[0];
    for RowIndex := 1 to ADataGrid.RowCount -1 do
    begin
      for ColIndex := 1 to ADataGrid.ColCount -1 do
      begin
        if Trim(ADataGrid.Cells[ColIndex,RowIndex]) <> '' then
        begin
          IgnoreValue := False;
          AValue := StrToFloat(Trim(ADataGrid.Cells[ColIndex,RowIndex]));
          for IgnoreIndex := 1 to seIgnore.Value do
          begin
            TestValue := StrToFloat(Trim(dgIgnore.Cells[0,IgnoreIndex]));
            IgnoreValue := (AValue = TestValue);
            if IgnoreValue then
            begin
              break;
            end;
          end;
          if IgnoreValue then
          begin
            NodeNumberArray[ColIndex-1, RowIndex-1] := -1;
          end
          else
          begin
            Inc(result);
            NodeNumberArray[ColIndex-1, RowIndex-1] := result-1;
          end;
        end
        else
        begin
          NodeNumberArray[ColIndex-1, RowIndex-1] := -1;
        end;
      end;
    end;
  end;
end;

function TfrmGrid.BlockIndex(RowIndex,
  ColIndex: integer): integer;
begin
  Assert(ColIndex >= 0);
  Assert(ColIndex < NCOL);
  Assert(RowIndex >= 0);
  Assert(RowIndex < NROW);
  if ColsReversed then
  begin
    ColIndex := NCOL - ColIndex -1 ;
  end;
  if RowsReversed then
  begin
    RowIndex := NROW - RowIndex -1;
  end;
  result := RowIndex* NCOL + ColIndex;
  Assert((result>=0) and (result <= NCOL*NROW-1));
end;

procedure TfrmGrid.GetThisGrid;
begin
  GetNumRowsCols(CurrentModelHandle, GridLayerHandle, NRow, NCol);
//  GetGrid(CurrentModelHandle, edGridLayerName.Text, GridLayerHandle,
//    NRow, NCol, MinX, MaxX, MinY, MaxY, GridAngle);
end;

function TfrmGrid.GetCellCentersForADataSet(var posX, posY : PDoubleArray;
  const DataSetIndex : integer) : boolean;
var
  RowIndex, ColIndex : integer;
  ADataGrid : TDataGrid;
  ABlock : TBlockObjectOptions;
  Position : integer;
  X, Y: ANE_DOUBLE;
  GridLayer : TLayerOptions;
begin
  result := false;
  GetThisGrid;
  Count := GetACellCount(DataSetIndex);
  if Count > 0 then
  begin
    GridLayer := TLayerOptions.Create(GridLayerHandle);
    try
      RowsReversed := GridLayer.GridReverseYDirection[CurrentModelHandle];
      ColsReversed := GridLayer.GridReverseXDirection[CurrentModelHandle];
    finally
      GridLayer.Free(CurrentModelHandle);
    end;

    ADataGrid := dg3dData.Grids[DataSetIndex];

    GetMem(posX, Count*SizeOf(double));
    GetMem(posY, Count*SizeOf(double));
    result := True;

    Position := 0;
    for RowIndex := 1 to ADataGrid.RowCount -1 do
    begin
      for ColIndex := 1 to ADataGrid.ColCount -1 do
      begin
        if (NodeNumberArray[ColIndex-1, RowIndex-1] <> -1) then
        begin
          try
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              GridLayerHandle, BlockIndex(RowIndex -1, ColIndex -1));

            ABlock.GetCenter(CurrentModelHandle, X, Y);

            posX^[Position] := X;
            posY^[Position] := Y;

            Inc(Position);
          finally
            FreeAndNil(ABlock);
          end;
        end;
      end;
    end;
  end;

end;


function TfrmGrid.GetCellCenters(var posX, posY : PDoubleArray) : boolean;
var
  RowIndex, ColIndex : integer;
  ADataGrid : TDataGrid;
  ABlock : TBlockObjectOptions;
  Position : integer;
  X, Y: ANE_DOUBLE;
  GridLayer : TLayerOptions;
begin
  result := false;
  GetThisGrid;
  Count := CellCount;
  if Count > 0 then
  begin
    GridLayer := TLayerOptions.Create(GridLayerHandle);
    try
      RowsReversed := GridLayer.GridReverseYDirection[CurrentModelHandle];
      ColsReversed := GridLayer.GridReverseXDirection[CurrentModelHandle];
    finally
      GridLayer.Free(CurrentModelHandle);
    end;

    ADataGrid := dg3dData.Grids[0];

    GetMem(posX, Count*SizeOf(double));
    GetMem(posY, Count*SizeOf(double));
    result := True;

    Position := 0;
    for RowIndex := 1 to ADataGrid.RowCount -1 do
    begin
      for ColIndex := 1 to ADataGrid.ColCount -1 do
      begin
        if (NodeNumberArray[ColIndex-1, RowIndex-1] <> -1) then
        begin
          try
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              GridLayerHandle, BlockIndex(RowIndex -1, ColIndex -1));

            ABlock.GetCenter(CurrentModelHandle, X, Y);

            posX^[Position] := X;
            posY^[Position] := Y;

            Inc(Position);
          finally
            FreeAndNil(ABlock);
          end;
        end;
      end;
    end;
  end;

end;

function TfrmGrid.IsCellActive(XIndex, YIndex : integer) : boolean;
begin
  result := NodeNumberArray[XIndex, YIndex] <> -1
end;

function TfrmGrid.GetTriangles(var node0, node1, node2 : PIntegerArray) : integer;
var
  XIndex,YIndex : integer;
  FirstNodeList, SecondNodeList, ThirdNodeList : TIntegerList;
  triangleIndex : integer;
  numTriangles : integer;
begin
  FirstNodeList := TIntegerList.Create;
  SecondNodeList := TIntegerList.Create;
  ThirdNodeList := TIntegerList.Create;
  try
    For YIndex := 0 to NROW -1 do
    begin
      for XIndex := 0 to NCOL -1 do
      begin
        if IsCellActive(XIndex, YIndex)
        then
          begin
            if (XIndex > 0) and (YIndex < NROW -1)
               and not IsCellActive(XIndex-1, YIndex)
               and IsCellActive(XIndex-1, YIndex+1)
               and IsCellActive(XIndex, YIndex+ 1)
            then
              begin
                  //   +---+
                  //    \  |
                  //     \ |
                  //      \|
                  //      (*)
                FirstNodeList.Add(NodeNumberArray[XIndex,YIndex]);
                SecondNodeList.Add(NodeNumberArray[XIndex,YIndex+1]);
                ThirdNodeList.Add(NodeNumberArray[XIndex-1,YIndex+1]);
              end;

            if (XIndex < NCOL -1)
               and (YIndex < NROW -1)
               and  IsCellActive(XIndex+1, YIndex+ 1)
            then
              begin
                if IsCellActive(XIndex+1, YIndex)
                then
                  begin
                     //           +
                     //          /|
                     //         / |
                     //        /  |
                     //      (*)--+                                                                   
                    FirstNodeList.Add(NodeNumberArray[XIndex,YIndex]);
                    SecondNodeList.Add(NodeNumberArray[XIndex+1,YIndex]);
                    ThirdNodeList.Add(NodeNumberArray[XIndex+1,YIndex+1]);
                  end;
                if IsCellActive(XIndex, YIndex+1)
                then
                  begin
                     //       +---+
                     //       |  /
                     //       | /
                     //       |/
                     //      (*)
                    FirstNodeList.Add(NodeNumberArray[XIndex,YIndex]);
                    SecondNodeList.Add(NodeNumberArray[XIndex+1,YIndex+1]);
                    ThirdNodeList.Add(NodeNumberArray[XIndex,YIndex+1]);
                  end;
              end // if (XIndex < A3DRealList.XCount -1)
                   // and (YIndex < A3DRealList.YCount -1)
                   // and  IsCellActive(XIndex+1, YIndex+ 1,
                   // ZIndex,
                   //  DataSets.First, CheckifActive)
            else if (XIndex < NCOL -1)
                    and (YIndex < NROW -1)
                    and IsCellActive(XIndex+1, YIndex) and
                    IsCellActive(XIndex, YIndex+ 1)
            then
              begin
                  //       +
                  //       |\
                  //       | \
                  //       |  \
                  //      (*)--+
                    FirstNodeList.Add(NodeNumberArray[XIndex,YIndex]);
                    SecondNodeList.Add(NodeNumberArray[XIndex+1,YIndex]);
                    ThirdNodeList.Add(NodeNumberArray[XIndex,YIndex+1]);
              end; // else if IsCellActive(XIndex+1, YIndex,
                   // ZIndex,
                   //       DataSets.First, CheckifActive) and
                   // IsCellActive(XIndex, YIndex+ 1, ZIndex,
                   //       DataSets.First, CheckifActive)
          end; // IsCellActive(XIndex, YIndex, ZIndex,
               // DataSets.First,
              //  CheckifActive)
      end; // For YIndex := 0 to A3DRealList.YCount -1 do
    end;  // for XIndex := 0 to A3DRealList.XCount -1 do

    numTriangles := FirstNodeList.Count;
    result := numTriangles;

    GetMem(node0, numTriangles*SizeOf(longInt));
    GetMem(node1, numTriangles*SizeOf(longInt));
    GetMem(node2, numTriangles*SizeOf(longInt));

    for triangleIndex := 0 to numTriangles -1 do
    begin
      assert(triangleIndex<numTriangles);
      node0^[triangleIndex] := FirstNodeList.Items[triangleIndex];
      node1^[triangleIndex] := SecondNodeList.Items[triangleIndex];
      node2^[triangleIndex] := ThirdNodeList.Items[triangleIndex];
    end;

  finally
    FirstNodeList.Free;
    SecondNodeList.Free;
    ThirdNodeList.Free;
  end;
end;

procedure TfrmGrid.GetADataSet(var dataParameters : pMatrix;
  const DataSetIndex : integer);
const
  numDataParameters = 1;
var
  RowIndex, ColIndex : integer;
  ADataGrid : TDataGrid;
  PointIndex : integer;
begin
  GetMem(dataParameters, numDataParameters*SizeOf(pMatrix));
  GetMem(dataParameters[0], Count*SizeOf(DOUBLE));
  ADataGrid := dg3dData.Grids[DataSetIndex];
  PointIndex := 0;
  for RowIndex := 0 to NROW -1 do
  begin
    for ColIndex := 0 to NCOL -1 do
    begin
      if IsCellActive(ColIndex,RowIndex) then
      begin
        assert(PointIndex < Count);
        try
          dataParameters[0]^[PointIndex] :=
            StrToFloat(ADataGrid.Cells[ColIndex+1,RowIndex+1]);
        Except on EConvertError do
          begin
            dataParameters[0]^[PointIndex] := 0;
            Inc(ErrorCount);
          end;
        end;
        Inc(PointIndex);
      end;
    end;
  end;
end;

procedure TfrmGrid.GetData(var dataParameters : pMatrix);
var
  numDataParameters : Integer;
  DataSetIndex : integer;
  RowIndex, ColIndex : integer;
  ADataGrid : TDataGrid;
  PointIndex : integer;
begin
  numDataParameters := seDataSets.Value;
  GetMem(dataParameters, numDataParameters*SizeOf(pMatrix));
  FOR DataSetIndex := 0 TO numDataParameters-1 DO
  begin
    GetMem(dataParameters[DataSetIndex], Count*SizeOf(DOUBLE));
  end;
  FOR DataSetIndex := 0 TO numDataParameters-1 DO
  begin
    ADataGrid := dg3dData.Grids[DataSetIndex];
    PointIndex := 0;
    for RowIndex := 0 to NROW -1 do
    begin
      for ColIndex := 0 to NCOL -1 do
      begin
        if IsCellActive(ColIndex,RowIndex) then
        begin
          assert(DataSetIndex < numDataParameters);
          assert(PointIndex < Count);
          try
            dataParameters[DataSetIndex]^[PointIndex] :=
              StrToFloat(ADataGrid.Cells[ColIndex+1,RowIndex+1]);
          Except on EConvertError do
            begin
              dataParameters[DataSetIndex]^[PointIndex] := 0;
              Inc(ErrorCount);
            end;
          end;
          Inc(PointIndex);
        end;
      end;
    end;
  end;
end;

procedure TfrmGrid.GetAName(var paramNames : PParamNamesArray;
  Const NameIndex : integer);
const
  numDataParameters = 1;
var
  AName : string;
begin
  GetMem(paramNames, numDataParameters*SizeOf(ANE_STR));
  AName := FixArgusName(sgNames.Cells[0,NameIndex]);
  GetMem(paramNames^[0],(Length(AName) + 1));
  StrPCopy(paramNames^[0], AName);
end;

procedure TfrmGrid.GetNames(var paramNames : PParamNamesArray);
var
  NameIndex : integer;
  numDataParameters : integer;
  AName : string;
begin
  numDataParameters := seDataSets.Value;
  GetMem(paramNames, numDataParameters*SizeOf(ANE_STR));
  for NameIndex := 1 to sgNames.RowCount -1 do
  begin
    Assert(NameIndex-1 < numDataParameters);
    AName := FixArgusName(sgNames.Cells[0,NameIndex]);
    GetMem(paramNames^[NameIndex-1],(Length(AName) + 1));
    StrPCopy(paramNames^[NameIndex-1], AName);
  end;
end;


{ TThisDataLayer }

class function TThisDataLayer.ANE_LayerName: string;
begin
  if frmGrid.cbSeparateLayers.Checked then
  begin
    result := frmGrid.TempLayerName;
  end
  else
  begin
    result := FixArgusName(frmGrid.comboDataLayerName.Text);
  end;


end;

procedure GGridDataPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;
begin
  layerHandle :=  GetExistingLayer(aneHandle, [pieGridLayer]);
  frmGrid := TfrmGrid.Create(Application);
  try
    frmGrid.CurrentModelHandle := aneHandle;
    frmGrid.GridLayerHandle := layerHandle;
    if frmGrid.Initialize then
    begin
      frmGrid.ShowModal
    end
    else
    begin
      Beep;
      MessageDlg('You must create a grid before importing gridded data.',
        mtError,[mbOK,mbHelp],20);
    end;
  finally
    frmGrid.Free;
  end;

end;

procedure TfrmGrid.SetDataInMultipleLayers;
var
  dataLayerHandle :	ANE_PTR ;
  numPoints :		ANE_INT32   ;
  posX :			PDoubleArray ;
  posY :			PDoubleArray ;
  numTriangles :		ANE_INT32   ;
  node0 :			PIntegerArray  ;
  node1 :			PIntegerArray  ;
  node2 :			PIntegerArray  ;
  numDataParameters :	ANE_INT32   ;
  NameIndex : integer;
  dataParameters :	pMatrix;
  paramNames :		PParamNamesArray;
  UserResponse : integer;
//  DataParametersIndex : integer;
//  LayerName : string;
  ALayer : TThisDataLayer;
  LayerTemplate : string;
  CreateLayer : boolean;
  ErrorMessage: string;
  FreeCoordinates : boolean;
  ANE_LayerTemplate : ANE_STR;
begin
  inherited;

  for NameIndex := 1 to sgNames.RowCount -1 do
  begin
{    paramNames := nil;
    try
      GetAName(paramNames, NameIndex);
    finally
      FreeMem(paramNames^[0]);
      FreeMem(paramNames);
    end; }

    dataParameters := nil;
    paramNames := nil;
    posX := nil;
    posY := nil;
    node0 := nil;
    node1 := nil;
    node2 := nil;

    FreeCoordinates := False;
    try
      FreeCoordinates := GetCellCentersForADataSet(posX, posY,NameIndex-1);
      numPoints := Count;

      if FreeCoordinates then
      begin
        try
          numTriangles := GetTriangles(node0,node1,node2);

          numDataParameters := 1;

          try
            ErrorCount := 0;
            GetADataSet(dataParameters, NameIndex-1);
            try
              if ErrorCount > 0 then
              begin
                if ErrorCount = 1 then
                begin
                  ErrorMessage := 'One cell did not contain a valid number.  '
                  + 'It has been converted to a 0.'
                end
                else
                begin
                  ErrorMessage := IntToStr(ErrorCount) + ' cells did not contain '
                  + 'valid numbers.  They have been converted to 0''s.'
                end;
                Beep;
                MessageDlg(ErrorMessage, mtWarning, [mbOK], 0);
              end;

              GetAName(paramNames, NameIndex);


              TempLayerName := String(paramNames^[0]);

//              TThisDataLayer.ANE_LayerName;
              dataLayerHandle := GetLayerHandle(CurrentModelHandle,TempLayerName);

              CreateLayer := True;
              if dataLayerHandle = nil then
              begin
                ALayer := TThisDataLayer.Create(nil,-1);
                try
                  LayerTemplate := ALayer.WriteLayer(CurrentModelHandle);
                  GetMem(ANE_LayerTemplate, Length(LayerTemplate) + 1);
                  try
                    StrPCopy(ANE_LayerTemplate, LayerTemplate);
                    dataLayerHandle := ANE_LayerAddByTemplate(CurrentModelHandle,
                       ANE_LayerTemplate, nil );
                  finally
                    FreeMem(ANE_LayerTemplate);
                  end;

                finally
                  ALayer.Free;
                end;

              end
              else
              begin
                CreateLayer := GetValidLayerWithCancel(CurrentModelHandle, dataLayerHandle,
                  TThisDataLayer, TempLayerName, nil, UserResponse);
              end;

              if CreateLayer then
              begin
                ANE_DataLayerSetTriangulatedData(CurrentModelHandle ,
                  dataLayerHandle,
                  numPoints,
                  @posX^,
                  @posY^,
                  numTriangles,
                  @node0^,
                  @node1^,
                  @node2^,
                  numDataParameters,
                  @dataParameters^,
                  @paramNames^);
              end;
            finally
              FreeMem(paramNames^[0]);
              FreeMem(paramNames);
            end;
          finally
            FreeMem(dataParameters[0]);
            FreeMem(dataParameters  );
          end;
        finally
          FreeMem(node0);
          FreeMem(node1);
          FreeMem(node2);
        end;
      end;
    finally
      if FreeCoordinates then
      begin
        FreeMem(posY);
        FreeMem(posX);
      end;
    end;
  end;

end;

procedure TfrmGrid.SetDataInOneLayer;
var
  dataLayerHandle :	ANE_PTR ;
  numPoints :		ANE_INT32   ;
  posX :			PDoubleArray ;
  posY :			PDoubleArray ;
  numTriangles :		ANE_INT32   ;
  node0 :			PIntegerArray  ;
  node1 :			PIntegerArray  ;
  node2 :			PIntegerArray  ;
  numDataParameters :	ANE_INT32   ;
  NameIndex : integer;
  dataParameters :	pMatrix;
  paramNames :		PParamNamesArray;
  UserResponse : integer;
  DataParametersIndex : integer;
  LayerName : string;
  ALayer : TThisDataLayer;
  LayerTemplate : string;
  CreateLayer : boolean;
  ErrorMessage: string;
  FreeCoordinates : boolean;
  ANE_LayerTemplate : ANE_STR;
begin
  inherited;


  paramNames := nil;
  dataParameters := nil;

  FreeCoordinates := False;
  try
    FreeCoordinates := GetCellCenters(posX, posY);
    numPoints := Count;

    if FreeCoordinates then
    begin
      try
        numTriangles := GetTriangles(node0,node1,node2);

        numDataParameters := seDataSets.Value;

        try
          ErrorCount := 0;
          GetData(dataParameters);
          try
            if ErrorCount > 0 then
            begin
              if ErrorCount = 1 then
              begin
                ErrorMessage := 'One cell did not contain a valid number.  '
                + 'It has been converted to a 0.'
              end
              else
              begin
                ErrorMessage := IntToStr(ErrorCount) + ' cells did not contain '
                + 'valid numbers.  They have been converted to 0''s.'
              end;
              Beep;
              MessageDlg(ErrorMessage, mtWarning, [mbOK], 0);
            end;

            GetNames(paramNames);

            LayerName := TThisDataLayer.ANE_LayerName;
            dataLayerHandle := GetLayerHandle(CurrentModelHandle,LayerName);

            CreateLayer := True;
            if dataLayerHandle = nil then
            begin
              ALayer := TThisDataLayer.Create(nil,-1);
              try
                LayerTemplate := ALayer.WriteLayer(CurrentModelHandle);
                GetMem(ANE_LayerTemplate, Length(LayerTemplate) + 1);
                try
                  StrPCopy(ANE_LayerTemplate, LayerTemplate);
                  dataLayerHandle := ANE_LayerAddByTemplate(CurrentModelHandle,
                     ANE_LayerTemplate, nil );
                finally
                  FreeMem(ANE_LayerTemplate);
                end;

              finally
                ALayer.Free;
              end;

            end
            else
            begin
              CreateLayer := GetValidLayerWithCancel(CurrentModelHandle, dataLayerHandle,
                TThisDataLayer, LayerName, nil, UserResponse);
            end;

            if CreateLayer then
            begin
              ANE_DataLayerSetTriangulatedData(CurrentModelHandle ,
                dataLayerHandle,
                numPoints,
                @posX^,
                @posY^,
                numTriangles,
                @node0^,
                @node1^,
                @node2^,
                numDataParameters,
                @dataParameters^,
                @paramNames^);
            end;

          finally
            for NameIndex := 0 to numDataParameters -1 do
            begin
              FreeMem(paramNames^[NameIndex]);
            end;

            FreeMem(paramNames, numDataParameters*SizeOf(ANE_STR));
          end;

        finally
          FOR DataParametersIndex := numDataParameters-1 DOWNTO 0 DO
          begin
            assert(DataParametersIndex < numDataParameters);
            FreeMem(dataParameters[DataParametersIndex]);
          end;
          FreeMem(dataParameters  );

        end;

      finally
        FreeMem(node0);
        FreeMem(node1);
        FreeMem(node2);
      end;
    end;

  finally
    if FreeCoordinates then
    begin
      FreeMem(posY);
      FreeMem(posX);
    end;
  end;

end;

procedure TfrmGrid.btnOKClick(Sender: TObject);
var
  dataLayerHandle :	ANE_PTR ;
  numPoints :		ANE_INT32   ;
  posX :			PDoubleArray ;
  posY :			PDoubleArray ;
  numTriangles :		ANE_INT32   ;
  node0 :			PIntegerArray  ;
  node1 :			PIntegerArray  ;
  node2 :			PIntegerArray  ;
  numDataParameters :	ANE_INT32   ;
  NameIndex : integer;
  dataParameters :	pMatrix;
  paramNames :		PParamNamesArray;
  UserResponse : integer;
  DataParametersIndex : integer;
  LayerName : string;
  ALayer : TThisDataLayer;
  LayerTemplate : string;
  CreateLayer : boolean;
  ErrorMessage: string;
  FreeCoordinates : boolean;
  ANE_LayerTemplate : ANE_STR;
begin
  inherited;

  if not ParameterNamesOK then
  begin
    ModalResult := mrNone;
    sgNames.SetFocus;
    Exit;
  end;

  if not DataOK then
  begin
    ModalResult := mrNone;
    dg3dData.SetFocus;
    Exit;
  end;

  if not IgnoreValuesOK then
  begin
    Beep;
    ModalResult := mrNone;
    dgIgnore.SetFocus;
    Exit;
  end;

  if cbSeparateLayers.Checked then
  begin
    SetDataInMultipleLayers;
  end
  else
  begin
    SetDataInOneLayer
  end;
  Exit;

  FreeCoordinates := False;
  try
    FreeCoordinates := GetCellCenters(posX, posY);
    numPoints := Count;

    if FreeCoordinates then
    begin
      try
        numTriangles := GetTriangles(node0,node1,node2);

        numDataParameters := seDataSets.Value;

        try
          try
            GetNames(paramNames);

            GetData(dataParameters);
            if ErrorCount > 0 then
            begin
              if ErrorCount = 1 then
              begin
                ErrorMessage := 'One cell did not contain a valid number.  '
                + 'It has been converted to a 0.'
              end
              else
              begin
                ErrorMessage := IntToStr(ErrorCount) + ' cells did not contain '
                + 'valid numbers.  They have been converted to 0''s.'
              end;
              Beep;
              MessageDlg(ErrorMessage, mtWarning, [mbOK], 0);
            end;



            LayerName := TThisDataLayer.ANE_LayerName;
            dataLayerHandle := GetLayerHandle(CurrentModelHandle,LayerName);

            CreateLayer := True;
            if dataLayerHandle = nil then
            begin
              ALayer := TThisDataLayer.Create(nil,-1);
              try
                LayerTemplate := ALayer.WriteLayer(CurrentModelHandle);
                GetMem(ANE_LayerTemplate, Length(LayerTemplate) + 1);
                try
                  StrPCopy(ANE_LayerTemplate, LayerTemplate);
                  dataLayerHandle := ANE_LayerAddByTemplate(CurrentModelHandle,
                     ANE_LayerTemplate, nil );
                finally
                  FreeMem(ANE_LayerTemplate);
                end;

              finally
                ALayer.Free;
              end;

            end
            else
            begin
              CreateLayer := GetValidLayerWithCancel(CurrentModelHandle, dataLayerHandle,
                TThisDataLayer, LayerName, nil, UserResponse);
            end;

            if CreateLayer then
            begin
              ANE_DataLayerSetTriangulatedData(CurrentModelHandle ,
                dataLayerHandle,
                numPoints,
                @posX^,
                @posY^,
                numTriangles,
                @node0^,
                @node1^,
                @node2^,
                numDataParameters,
                @dataParameters^,
                @paramNames^);
            end;

          finally
            for NameIndex := 0 to numDataParameters -1 do
            begin
              FreeMem(paramNames^[NameIndex]);
            end;

            FreeMem(paramNames, numDataParameters*SizeOf(ANE_STR));

          end;

        finally
          FOR DataParametersIndex := numDataParameters-1 DOWNTO 0 DO
            begin
              assert(DataParametersIndex < numDataParameters);
              FreeMem(dataParameters[DataParametersIndex]);
            end;
          FreeMem(dataParameters  );

        end;

      finally
        FreeMem(node0);
        FreeMem(node1);
        FreeMem(node2);
      end;
    end;

  finally
    if FreeCoordinates then
    begin
      FreeMem(posY);
      FreeMem(posX);
    end;
  end;

end;

function TfrmGrid.Initialize : boolean;
var
  Project : TProjectOptions;
  Width, Index, temp : integer;
begin
  GetThisGrid;
  result := (NROW > 0) and (NCOL > 0);
  if not Result then Exit;
  dg3dData.GridRowCount := NROW + 1;
  dg3dData.GridColCount := NCOL + 1;
  seDataSetsChange(seDataSets);
  Project := TProjectOptions.Create;
  try
    Project.LayerNames(CurrentModelHandle, [pieDataLayer],
      comboDataLayerName.Items);
    Width := comboDataLayerName.Width;
    for Index := 0 to comboDataLayerName.Items.Count -1 do
    begin
      temp := Canvas.TextWidth(comboDataLayerName.Items[Index]) + 50;
      if temp > Width then
      begin
        Width:= Temp;
      end;
    end;
    comboDataLayerName.CWX := Width - comboDataLayerName.Width;
  finally
    Project.Free;
  end;

end;

procedure TfrmGrid.btnPasteClick(Sender: TObject);
var
  AStringList : TStringlist;
  ADataGrid : TDataGrid;
begin
  inherited;
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    ADataGrid := dg3dData.Grids[dg3dData.ActivePageIndex];
    AStringList := TStringlist.Create;
    try
      AStringList.Text := Clipboard.AsText;
      ReadValuesFromStringList(AStringList, ADataGrid);
    finally
      AStringList.Free;
    end;
    SetColumnWidths(ADataGrid);
  end;

end;

procedure TfrmGrid.ReadValuesFromStringList(AStringList : TStringList;
  ADataGrid : TDataGrid; ACol: integer = 1; ARow: integer = 1);
var
  Index : integer;
  ColIndex, RowIndex : integer;
  AString , ASubstring : string;
  StrLength : integer;
  ValidData : boolean;
  ColIndexPreview, RowIndexPreview : integer;
  ReachedEndOfRow : boolean;
  V : double;
  Code : integer;
  Multiplier : double;
begin
  // Delete comments and empty lines.
  for Index := AStringList.Count -1 downto 0 do
  begin
    AString := AStringList[Index];
    StrLength := Length(AString);
    if (StrLength = 0) or ((StrLength > 0) and (AString[1] = '#')) then
    begin
      AStringList.Delete(Index);
    end;
  end;
  if rgDataFormat.ItemIndex = 2 then
  begin
    if not cb95MultipleLines.Checked and (AStringList.Count + 1 <> ADataGrid.RowCount) then
    begin
      Beep;
      MessageDlg('Error: You''re data has ' + IntToStr(AStringList.Count)
        + ' rows but the grid in you''re Argus ONE project has '
        + IntToStr(ADataGrid.RowCount -1) + ' rows.', mtError, [mbOK], 0);
      Exit;
    end;
    Application.CreateForm(TfrmPreview, frmPreview);
    try
      frmPreview.SetData(AStringList, ADataGrid.ColCount-1, ADataGrid.RowCount-1);
      repeat
        ValidData := True;
        if frmPreview.ShowModal = mrOK then
        begin
          if not cb95MultipleLines.Checked and (ADataGrid.RowCount <> frmPreview.sgPreview.RowCount) then
          begin
            ValidData := False;
            Beep;
            MessageDlg('Error: You''re data has ' + IntToStr(frmPreview.sgPreview.RowCount-1)
              + ' rows but the grid in you''re Argus ONE project has '
              + IntToStr(ADataGrid.RowCount -1) + ' rows.', mtError, [mbOK], 0);
            Continue;
          end;
          if not cb95MultipleLines.Checked and (ADataGrid.ColCount <> frmPreview.sgPreview.ColCount
            - frmPreview.UnUsedColumns.Count) then
          begin
            ValidData := False;
            Beep;
            MessageDlg('Error: You''re data has ' + IntToStr(frmPreview.sgPreview.ColCount -1
            - frmPreview.UnUsedColumns.Count)
              + ' columns but the grid in you''re Argus ONE project has '
              + IntToStr(ADataGrid.ColCount -1) + ' columns.', mtError, [mbOK], 0);
            Continue;
          end;
          Multiplier := InternationalStrToFloat(frmPreview.adeMultiplier.Text);
          ColIndex := 0;
          if cb95MultipleLines.Checked then
          begin
            ColIndexPreview := 0;
            RowIndexPreview := 0;
            ReachedEndOfRow := False;
            for RowIndex := ARow to ADataGrid.RowCount -1 do
            begin
              if not ReachedEndOfRow then
              begin
                Inc(RowIndexPreview);
              end;
              for ColIndex := ACol to ADataGrid.ColCount -1 do
              begin
                Inc(ColIndexPreview);
                ReachedEndOfRow := ColIndexPreview = frmPreview.sgPreview.ColCount-1;
                if ColIndexPreview = frmPreview.sgPreview.ColCount then
                begin
                  ColIndexPreview := ACol;
                  Inc(RowIndexPreview);
                end;

                AString := Trim(frmPreview.sgPreview.Cells[ColIndexPreview,RowIndexPreview]);
                if AString = '' then
                begin
                  ADataGrid.Cells[ColIndex,RowIndex] := '0';
                end
                else
                begin
                  Val(AString, V, Code);
                  if Code = 0 then
                  begin
                    ADataGrid.Cells[ColIndex,RowIndex] := FloatToStr(Multiplier * V);
                  end
                  else
                  begin
                    ValidData := False;
                    Beep;
                    MessageDlg('Error: You''re data is misaligned.  '
                      + 'Please check column = ' + IntToStr(ColIndexPreview+1)
                      +  ', row = ' + IntToStr(RowIndex), mtError, [mbOK], 0);
                    break;
                  end;
                end;
              end;
            end;
          end
          else
          begin
            for ColIndexPreview := 1 to frmPreview.sgPreview.ColCount -1 do
            begin
              if not ValidData then break;
              if frmPreview.UnUsedColumns.IndexOf(ColIndexPreview) > -1 then
              begin
                Continue;
              end;
              Inc(ColIndex);
              for RowIndex := ARow to frmPreview.sgPreview.RowCount -1 do
              begin
                AString := Trim(frmPreview.sgPreview.Cells[ColIndexPreview,RowIndex]);
                if AString = '' then
                begin
                  ADataGrid.Cells[ColIndex,RowIndex] := '0';
                end
                else
                begin
                  Val(AString, V, Code);
                  if Code = 0 then
                  begin
                    ADataGrid.Cells[ColIndex,RowIndex] := FloatToStr(Multiplier * V);
                  end
                  else
                  begin
                    ValidData := False;
                    Beep;
                    MessageDlg('Error: You''re data is misaligned.  '
                      + 'Please check column = ' + IntToStr(ColIndexPreview+1)
                      +  ', row = ' + IntToStr(RowIndex), mtError, [mbOK], 0);
                    break;
                  end;
                end;
              end;
            end;
          end;
        end;
      until ValidData;

    finally
      frmPreview.Free;
    end;
    Exit;
  end;

  if cb95MultipleLines.Checked then
  begin
    RowIndex := ARow;
    ColIndex := ACol;
    Index := 0;
    while (Index < AStringList.Count) and (RowIndex < ADataGrid.RowCount)
      and (ColIndex < ADataGrid.ColCount) do
    begin
      AString := AStringList[Index];
      while (Length(AString) > 0) do
      begin
        if rgDataFormat.ItemIndex = 0 then
        begin
          ReadTabValuesString(AString, ASubstring);
        end
        else
        begin
          ReadCommaValuesString(AString, ASubstring);
        end;
        if Length(Trim(ASubstring)) > 0 then
        begin
          ADataGrid.Cells[ColIndex, RowIndex] := ASubstring;
          Inc(ColIndex);
          if ColIndex >= ADataGrid.ColCount then
          begin
            ColIndex := 1;
            Inc(RowIndex);
          end;
        end;
      end;
      Inc(Index);
    end;
  end
  else
  begin
    for Index := 0 to Min((AStringList.Count -1),ADataGrid.RowCount-2) do
    begin
      AString := AStringList[Index];
      ColIndex := ACol;
      while (Length(AString) > 0) and (ADataGrid.ColCount > ColIndex) do
      begin

        if rgDataFormat.ItemIndex = 0 then
        begin
          ReadTabValuesString(AString, ASubstring);
        end
        else
        begin
          ReadCommaValuesString(AString, ASubstring);
        end;
        ADataGrid.Cells[ColIndex, Index + 1+ ARow -1] := ASubstring;
        Inc(ColIndex);
      end;
    end;
  end;
end;

procedure TfrmGrid.ReadTabValuesString(var AString, ASubstring : string);
var
  BeginIndex : integer;
begin
    BeginIndex := Pos(Chr(9),AString);
    if BeginIndex = 0
    then
    begin
      ASubstring := AString;
      AString := '';
    end
    else if BeginIndex = 1 then
    begin
      ASubstring := '';
      AString := Copy(AString,2,Length(AString));
    end
    else
    begin
      ASubstring := Copy(AString,1,BeginIndex-1);
      while ASubstring[1] = '"' do
      begin
        ASubstring := Copy(ASubstring,2,Length(ASubstring));
      end;
      while ASubstring[Length(ASubstring)] = '"' do
      begin
        ASubstring := Copy(ASubstring,1,Length(ASubstring)-1);
      end;
      AString := Copy(AString,BeginIndex+1,Length(AString));
    end;
end;

procedure TfrmGrid.ReadCommaValuesString(var AString, ASubstring : string);
var
  CharIndex : integer;
  BeginIndex, EndIndex : integer;
  NextDoubleQuote, NextSingleQuote, NextQuote : integer;
  NextComma, NextSpace, NextTab : integer;
begin
  BeginIndex := 1;
  for CharIndex := 1 to Length(AString) do
  begin
    BeginIndex := CharIndex;
    if not ((AString[CharIndex] = Chr(9)) or
            (AString[CharIndex] = ' ') or
            (AString[CharIndex] = ',')) then
    begin
      break;
    end;
  end;
  if (AString[BeginIndex] = '"') or (AString[BeginIndex] = '''') then
  begin
    AString := Copy(AString, BeginIndex + 1, Length(AString));
    NextDoubleQuote := Pos('"',AString);
    NextSingleQuote := Pos('''',AString);
    NextQuote := 0;
    if NextDoubleQuote > 0 then
    begin
      NextQuote := NextDoubleQuote;
    end;
    if NextSingleQuote > 0 then
    begin
      if (NextQuote = 0) or (NextSingleQuote < NextQuote) then
      begin
        NextQuote := NextSingleQuote;
      end;
    end;
    if NextQuote > 0
    then
      begin
        ASubstring := Copy(AString,0,NextQuote-1);
        AString := Copy(AString, NextQuote+1, Length(AString));
      end
    else
      begin
        raise EUnmatchedQuote.Create('Unmatched Quote');
      end;
  end
  else
  begin
    AString := Copy(AString,BeginIndex,Length(AString));
    NextComma := Pos(',',AString);
    NextSpace := Pos(' ',AString);
    NextTab := Pos(Chr(9),AString);
    EndIndex := Length(AString)+1;
    if (NextComma > 0) and (NextComma < EndIndex) then
    begin
      EndIndex := NextComma;
    end;
    if (NextSpace > 0) and (NextSpace < EndIndex) then
    begin
      EndIndex := NextSpace;
    end;
    if (NextTab > 0) and (NextTab < EndIndex) then
    begin
      EndIndex := NextTab;
    end;
    ASubstring := Copy(AString,1,EndIndex-1);
    AString := Copy(AString,EndIndex+1,Length(AString));
  end;
end;

procedure TfrmGrid.SetColumnWidths(ADataGrid : TDataGrid);
var
  ColIndex, RowIndex, ColWidth, tempColWidth : integer;
begin
  for ColIndex := 0 to ADataGrid.ColCount -1  do
  begin
    ColWidth := ADataGrid.ColWidths[ColIndex];
    for RowIndex := 0 to ADataGrid.RowCount -1 do
    begin
      tempColWidth := ADataGrid.Canvas.TextWidth
        (ADataGrid.Cells[ColIndex,RowIndex])+ 20;
      if tempColWidth > ColWidth then
      begin
        ColWidth := tempColWidth;
      end;
    end;
    ADataGrid.ColWidths[ColIndex] := ColWidth;
  end;
end;

procedure TfrmGrid.seIgnoreChange(Sender: TObject);
begin
  inherited;
  if seIgnore.Value < 1 then
  begin
    dgIgnore.RowCount := 2;
    dgIgnore.Enabled := False;
    dgIgnore.Color := clBtnFace;
  end
  else
  begin
    dgIgnore.RowCount := seIgnore.Value + 1;
    dgIgnore.Enabled := True;
    dgIgnore.Color := clWindow;
  end;
end;

procedure TfrmGrid.sgNamesSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
Var
  ATab : TTabSheet;
begin
  inherited;
  ATab := dg3dData.Pages[ARow-1];
  ATab.Caption := Value;
end;

function TfrmGrid.ParameterNamesOK: boolean;
var
  Index : integer;
  AStringList : TStringList;
  AString : string;
begin
  result := True;
  if seDataSets.Value = 1 then Exit;
  AStringList := TStringList.Create;
  try
    for Index := 1 to sgNames.RowCount -1 do
    begin
      AString := UpperCase(sgNames.Cells[0,Index]);
      if AStringList.IndexOf(AString) > -1 then
      begin
        result := False;
        Beep;
        MessageDlg('All parameter names must be unique but '
          + AString + ' is repeated.', mtError, [mbOK,mbHelp], sgNames.HelpContext);
        Exit;
      end;
      AStringList.Add(AString);
    end;
  finally
    AStringList.Free;
  end;

end;

function TfrmGrid.IgnoreValuesOK: boolean;
var
  Index : integer;
begin
  result := True;
  for Index := 1 to seIgnore.Value do
  begin
    try
      StrToFloat(dgIgnore.Cells[0,Index]);
    except on EConvertError do
      begin
        result := False;
        Exit;
      end;
    end;


  end;

end;

function TfrmGrid.DataOK: boolean;
var
  GridIndex, RowIndex, ColIndex : integer;
  AGrid : TDataGrid;
begin
  result := True;
  for GridIndex := 0 to dg3dData.PageCount -1 do
  begin
    AGrid := dg3dData.Grids[GridIndex];
    With AGrid do
    begin
      for RowIndex := 1 to RowCount -1 do
      begin
        for ColIndex := 1 to ColCount -1 do
        begin
          try
            StrToFloat(Cells[ColIndex,RowIndex]);
          except on EConvertError do
            begin
              result := False;
              dg3dData.ActivePageIndex := GridIndex;
              Beep;
              MessageDlg('The value in column = '
                + IntToStr(ColIndex)
                + ', row = '
                + IntToStr(RowIndex)
                + ' is invalid.', mtError, [mbOK], 0);
              Exit;
            end;
          end;

        end;
      end;
    end;
  end;
end;


procedure TfrmGrid.dg3dDataSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  AStringList : TStringlist;
  ADataGrid : TDataGrid;
begin
  inherited;
  try
    StrToFloat(Value)
  except on EConvertError do
    begin
      ADataGrid := dg3dData.Grids[dg3dData.ActivePageIndex];
      AStringList := TStringlist.Create;
      try
        AStringList.Text := Value;
        ReadValuesFromStringList(AStringList, ADataGrid, ACol, ARow);
      finally
        AStringList.Free;
      end;
      SetColumnWidths(ADataGrid);
    end;
  end;

end;

procedure TfrmGrid.btnFileClick(Sender: TObject);
var
  PageIndex, FileIndex : integer;
  AStringList : TStringList;
  ADataGrid : TDataGrid;
  FileName : string;
begin
  inherited;
  if OpenDialog1.Execute then
  begin
    AStringList := TStringList.Create;
    try
      if dg3dData.ActivePageIndex + OpenDialog1.Files.Count > seDataSets.Value then
      begin
        seDataSets.Value := dg3dData.ActivePageIndex + OpenDialog1.Files.Count;
        seDataSetsChange(seDataSets);
      end;
      PageIndex := dg3dData.ActivePageIndex-1;
      for FileIndex := 0 to OpenDialog1.Files.Count -1 do
      begin
        Inc(PageIndex);
        FileName := OpenDialog1.Files[FileIndex];
        AStringList.LoadFromFile(FileName);
        FileName := ExtractFileName(FileName);
        sgNames.Cells[0,PageIndex + 1] := FileName;
        sgNamesSetEditText(sgNames,0,PageIndex + 1,FileName);
        ADataGrid := dg3dData.Grids[PageIndex];
        ReadValuesFromStringList(AStringList, ADataGrid);
      end;
    finally
      AStringList.Free;
    end;
  end;
end;

procedure TfrmGrid.cbSeparateLayersClick(Sender: TObject);
begin
  inherited;
  comboDataLayerName.Enabled := not cbSeparateLayers.Checked;
  if cbSeparateLayers.Checked then
  begin
    sgNames.Cells[0,0] := 'Layer names';
  end
  else
  begin
    sgNames.Cells[0,0] := 'Parameter names';
  end;

end;

procedure TfrmGrid.btnAboutClick(Sender: TObject);
begin
  inherited;
  ShowAbout;

end;

procedure TfrmGrid.comboDataLayerNameChange(Sender: TObject);
var
  Project : TProjectOptions;
  LayerHandle : ANE_PTR;
  ParameterNames : TStringList;
  Layer : TLayerOptions;
  Index : integer;
begin
  inherited;
  if comboDataLayerName.Text <> '' then
  begin
    Project := TProjectOptions.Create;
    try
      LayerHandle := Project.GetLayerByName(CurrentModelHandle, comboDataLayerName.Text);
      if LayerHandle <> nil then
      begin
        Layer := TLayerOptions.Create(LayerHandle);
        ParameterNames := TStringList.Create;
        try
          Layer.GetParameterNames(CurrentModelHandle, ParameterNames);
          if ParameterNames.Count > 0 then
          begin
            seDataSets.Value := ParameterNames.Count;
            seDataSetsChange(nil);
            for Index := 0 to ParameterNames.Count-1  do
            begin
              sgNames.Cells[0,Index+1] := ParameterNames[Index];
              sgNamesSetEditText(sgNames,0,Index+1,ParameterNames[Index]);
            end;
          end;
        finally
          ParameterNames.Free;
          Layer.Free(CurrentModelHandle);
        end;
      end;
    finally
      Project.Free;
    end;
  end;
end;

end.
