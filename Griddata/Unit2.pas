unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DataGrid, StdCtrls, Spin, ComCtrls, StringGrid3d, AnePIE, IntListUnit,
  ArgusFormUnit, ANE_LayerUnit, Buttons;

type
  TintegerArray = Array[0..MAXINT div 8] of LongInt;
  PIntegerArray = ^TintegerArray;
  TDoubleArray = Array[0..MAXINT div 16] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = Array[0..MAXINT div 8] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..MAXINT div 8] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;

type
  TArgusForm2 = class(TArgusForm)
    Label4: TLabel;
    edDataLayerName: TEdit;
    Label5: TLabel;
    btnOK: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure seDataSetsChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    Count : integer;
    NCOL, NROW : ANE_INT32;
    GridLayerHandle : ANE_PTR;
    MinX, MaxX, MinY, MaxY, GridAngle : ANE_DOUBLE;
    RowsReversed, ColsReversed : boolean;
    NodeNumberArray : array of array of integer;
    procedure GetCellCenters(var posX, posY: PDoubleArray);
    function CellCount: integer;
    function BlockIndex(RowIndex, ColIndex: integer): integer;
    procedure GetThisGrid;
    function IsCellActive(XIndex, YIndex: integer): boolean;
    function GetTriangles(var node0, node1, node2: PIntegerArray) : integer;
    procedure GetData(var dataParameters: pMatrix);
    procedure GetNames(var paramNames: PParamNamesArray);
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
  ArgusForm2: TArgusForm2;

implementation

uses OptionsUnit, UtilityFunctions;

{$R *.DFM}

procedure TArgusForm2.FormCreate(Sender: TObject);
var
  Index : integer;
  ADataGrid : TDataGrid;
  ColIndex : integer;
  ATabSheet : TTabSheet;
begin
  sgNames.Cells[0,0] := 'Parameter names';
  seDataSetsChange(Sender);

end;

procedure TArgusForm2.seDataSetsChange(Sender: TObject);
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
      ADataGrid.RowCount := seRows.Value + 1;
      ADataGrid.ColCount := seColumns.Value + 1;
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
    for Index := seDataSets.Value -1 downto dg3dData.GridCount do
    begin
      dg3dData.RemoveGrid(Index);
    end;
  end;
end;

Function TArgusForm2.CellCount : integer;
var
  RowIndex, ColIndex : integer;
  ADataGrid : TDataGrid;
  Count : integer;
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
          Inc(result);
          NodeNumberArray[ColIndex-1, RowIndex-1] := result-1;
        end
        else
        begin
          NodeNumberArray[ColIndex-1, RowIndex-1] := -1;
        end;
      end;
    end;
  end;
end;

function TArgusForm2.BlockIndex(RowIndex,
  ColIndex: integer): integer;
begin
  Assert(ColIndex >= 0);
  Assert(ColIndex < NCOL);
  Assert(RowIndex >= 0);
  Assert(RowIndex < NROW);
  if ColsReversed then
  begin
    ColIndex := NCOL - ColIndex -1;
  end;
  if RowsReversed then
  begin
    RowIndex := NROW - RowIndex -1;
  end;
  result := RowIndex* NCOL + ColIndex;
end;

procedure TArgusForm2.GetThisGrid;
begin
  GetGrid(CurrentModelHandle, edGridLayerName.Text, GridLayerHandle,
    NRow, NCol, MinX, MaxX, MinY, MaxY, GridAngle);
end;

procedure TArgusForm2.GetCellCenters(var posX, posY : PDoubleArray);
var
  RowIndex, ColIndex : integer;
  ADataGrid : TDataGrid;
  ABlock : TBlockObjectOptions;
  Position : integer;
  X, Y: ANE_DOUBLE;
  GridLayer : TLayerOptions;
begin
  GetThisGrid(CurrentModelHandle);
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

    Position := 0;
    for RowIndex := 1 to ADataGrid.RowCount -1 do
    begin
      for ColIndex := 1 to ADataGrid.ColCount -1 do
      begin
        if Trim(ADataGrid.Cells[ColIndex,RowIndex]) <> '' then
        begin
          ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
            GridLayerHandle, BlockIndex(RowIndex - 1, ColIndex -1));

          ABlock.GetCenter(CurrentModelHandle, X, Y);

          posX^[Position] := X;
          posY^[Position] := Y;

          Inc(Position);
        end;
      end;
    end;
  end;

end;

function TArgusForm2.IsCellActive(XIndex, YIndex : integer) : boolean;
begin
  result := NodeNumberArray[XIndex, YIndex] <> -1
end;

function TArgusForm2.GetTriangles(var node0, node1, node2 : PIntegerArray) : integer;
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
    for XIndex := 0 to NCOL -1 do
    begin
      For YIndex := 0 to NROW -1 do
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

procedure TArgusForm2.GetData(var dataParameters : pMatrix);
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
    for ColIndex := 0 to NCOL -1 do
    begin
      for RowIndex := 1 to NROW -1 do
      begin
        if IsCellActive(ColIndex,RowIndex) then
        begin
          assert(DataSetIndex < numDataParameters);
          assert(PointIndex < Count);
          dataParameters[DataSetIndex]^[PointIndex] :=
            StrToFloat(ADataGrid.Cells[ColIndex+1,RowIndex+1]);
          Inc(PointIndex);
        end;
      end;
    end;
  end;
end;

procedure TArgusForm2.GetNames(var paramNames : PParamNamesArray);
var
  NameIndex : integer;
  numDataParameters : integer;
begin
  numDataParameters := seDataSets.Value;
  GetMem(paramNames, numDataParameters*SizeOf(ANE_STR));
  for NameIndex := 1 to sgNames.RowCount -1 do
  begin
    Assert(NameIndex-1 < numDataParameters);
    paramNames^[NameIndex-1] := PChar(sgNames.Cells[0,NameIndex]);
  end;
end;


{ TThisDataLayer }

class function TThisDataLayer.ANE_LayerName: string;
begin
  result := ArgusForm2.edDataLayerName.Text;
end;

procedure GGridDataPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;
begin
  ArgusForm2 := TArgusForm2.Create(Application);
  try
    ArgusForm2.CurrentModelHandle := aneHandle;
    ArgusForm2.ShowModal
  finally
    ArgusForm2.Free;
  end;

end;

procedure TArgusForm2.btnOKClick(Sender: TObject);
var
  dataLayerHandle :	ANE_PTR ;
    numPoints :		ANE_INT32   ;
    posX :			ANE_DOUBLE_PTR ;
    posY :			ANE_DOUBLE_PTR ;
    numTriangles :		ANE_INT32   ;
    node0 :			ANE_INT32_PTR  ;
    node1 :			ANE_INT32_PTR  ;
    node2 :			ANE_INT32_PTR  ;
    numDataParameters :	ANE_INT32   ;
    dataParameters :	ANE_DOUBLE_PTR_PTR;
    paramNames :		ANE_STR_PTR;
    UserResponse : integer
    DataParametersIndex : integer;
begin
  inherited;

  try
    GetCellCenters(var posX, posY);
    numPoints := Count;

    try
      numTriangles := self.GetTriangles(node0,node1,node2);

      numDataParameters := seDataSets.Value;

      try
        GetData(dataParameters);

        GetValidLayer(CurrentModelHandle, dataLayerHandle,
          TThisDataLayer, TThisDataLayer.ANE_LayerName,
          nil, UserResponse);

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

  finally
    FreeMem(posY);
    FreeMem(posX);
  end;

end;

end.
