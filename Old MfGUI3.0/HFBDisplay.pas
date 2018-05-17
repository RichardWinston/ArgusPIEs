unit HFBDisplay;

interface

{ HFBDisplay is used to define a form for displaying the locations of
 horizontal-flow barriers. Note: PaintBox1 is likely to be changed to
 a different component in a future version of the PIE.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ArgusDataEntry, ExtCtrls, AnePIE, Buttons, ComCtrls;

type
  TfrmHFBDisplay = class(TForm)
    Panel1: TPanel;
    adeHFBLayer: TArgusDataEntry;
    Label1: TLabel;
    btnDisplay: TButton;
    bitbtnClose: TBitBtn;
    StatusBar1: TStatusBar;
    PaintBox1: TPaintBox;
    btnHelp: TBitBtn;
    cbXPos: TCheckBox;
    cbYPos: TCheckBox;
    procedure FormCreate(Sender: TObject); virtual;
    procedure btnDisplayClick(Sender: TObject); virtual;
    procedure FormDestroy(Sender: TObject); virtual;
    procedure PaintBox1Paint(Sender: TObject); virtual;
    procedure MouseMoved(Sender: TObject; Shift: TShiftState; X,
      Y: Integer); virtual;
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean; virtual;
    procedure cbXPosClick(Sender: TObject); virtual;
    procedure cbYPosClick(Sender: TObject); virtual;
  private
    { Private declarations }
  public
    CellPairList : TList;
    // CellPairList is a list of TCellPair's that define the positions
    // of the horizontal flow barriers.
    ColumnsList : TList;
    // ColumnList is a list of column positions
    RowsList : TList;
    // RowsList is a list of row positions
    Multiplier: double;
    // Multiplier is a number that can be multiplied by a real world coordinate
    // to get a screen coordinate.
    ColumnOrderPositive: boolean;
    // ColumnOrderPositive is set to true if the column numbers increase from
    // left to right.
    RowOrderPositive: boolean;
    // RowOrderPositive is set to true if the row numbers increase from
    // bottom to top.
    MaxRowPosition: integer;
    // MaxRowPosition is the screen coordinate of the last row.
    MinRowPosition: integer;
    // MinRowPosition is the screen coordinate of the first row.
    MaxColPosition: integer;
    // MaxColPosition is the screen coordinate of the last column.
    MinColPosition: integer;
    // MinColPosition is the screen coordinate of the first column.
    MinCol: double;
    // MinCol is the lowest column position in real world coordinates
    MaxCol: double;
    // MaxCol is the highest column position in real world coordinates
    MinRow: double;
    // MinCol is the lowest row position in real world coordinates
    MaxRow: double;
    // MinCol is the highest row position in real world coordinates
    NumRows, NumColumns : integer;
    // NumRows and NumColumns are the number of rows and number of columns
    // respectively in the grid.
    GridDataAvailable: boolean;
    // GridDataAvailable is set to true if the user has created a grid.
    XDirPositive , YDirPositive : boolean;
    // XDirPositive and  YDirPositive if the cooridinate sytem increase
    // to the right and upward.
    CurrentModelHandle : ANE_PTR;
    function Position(const DataPosition, MinimumPosition : double;
      Reverse : boolean) : integer; virtual;
    // This function returns a screen coordinate. DataPosition is the
    // value in real world units of the number to be plotted.
    //  MinimumPosition is the minimum value of all the values in the
    // data set that contains DataPosition. If Reverse is true, the
    // coordinate system for the real world coordinates is reversed.
    function ColumnPosition(const DataPosition: double): integer; virtual;
    // ColumnPosition returns the x screen-coordinate of a column at
    // DataPosition;
    function RowPosition(const DataPosition: double): integer; virtual;
    // RowPosition returns the y screen-coordinate of a row at
    // DataPosition;
    { Public declarations }
    procedure AssignHelpFile(FileName : string); virtual;
  end;

Type
  TCellPair = Class(TObject)
    Col1 : Integer;
    Row1 : integer;
    Col2 : integer;
    Row2 : integer;
  public
    procedure DrawBoundary;
    
  end;

  TPosition = Class(TObject)
    Position : double;
  end;

var
  frmHFBDisplay: TfrmHFBDisplay;

const
  Margin = 20;

procedure GDisplayHFBPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

implementation

{$R *.DFM}

uses Variables, ANECB, ANE_LayerUnit, ArgusFormUnit, UtilityFunctions,
     ModflowUnit, OptionsUnit;

procedure GDisplayHFBPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;
begin
  // Check that another model doesn't have a dialog box open. If it does,
  // prevent this one from openning because that would corrupt the data
  // for the other model.
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
              // get teh model information
              frmMODFLOW := TArgusForm.GetFormFromArgus(aneHandle)
                as ModflowTypes.GetModflowFormType;
              // check if horizontal flow barriers are used.
              if frmMODFLOW.cbHFB.Checked then
              begin
                // create the form for displaying horizontal-flow barriers
                // data
                frmHFBDisplay := TfrmHFBDisplay.Create(Application);
                try // try 3
                  begin
                    frmHFBDisplay.CurrentModelHandle := aneHandle;
                    // show the form for displaying horizontal-flow barriers
                    // if there is a grid in the model.
                    if frmHFBDisplay.GridDataAvailable then
                    begin
                      frmHFBDisplay.ShowModal;
                    end;
                  end; // try 3
                finally // try 3
                  begin
                    // destroy the form for displaying horizontal-flow barriers.
                    frmHFBDisplay.Free;
                    frmHFBDisplay := nil;
                  end;
                end; // try 3
              end
              else
              begin
                // tell user why this won't work now.
                Beep;
                ShowMessage('Horizontal Flow Barriers are not used '
                  + 'in this model');
              end;
            end; // try 2
          except on E: Exception do
            begin
              Beep;
              MessageDlg(E.Message, mtError, [mbOK], 0);
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

function TfrmHFBDisplay.Position(const DataPosition, MinimumPosition : double;
  Reverse : boolean) : integer;
var LocalMultiplier : double;
begin
  // called by ColumnPosition;
  // called by RowPosition
  // called by PaintBox1Paint

  // This function returns a screen coordinate. DataPosition is the
  // value in real world units of the number to be plotted.
  //  MinimumPosition is the minimum value of all the values in the
  // data set that contains DataPosition. If Reverse is true, the
  // coordinate system for the real world coordinates is reversed.
  if Reverse then LocalMultiplier := -Multiplier
    else LocalMultiplier := Multiplier;
  result := Round((DataPosition - MinimumPosition)*LocalMultiplier) + Margin;
end;

procedure TfrmHFBDisplay.FormCreate(Sender: TObject);
var
  layerHandle : ANE_PTR;
  StringToEvaluate : string;
  Success : boolean;
  RowIndex, ColumnIndex : integer;
  ARow, AColumn : double;
  APosition : TPosition;
{$IFDEF Argus5}
  LayerOptions : TLayerOptions;
{$ENDIF}
begin
  // triggering event frmHFBDisplay.OnCreate

  // assume no grid is available until the grid data has been read.
  GridDataAvailable := False;
  // prevent the user from entering a value larger than the number of units.
  adeHFBLayer.Max := StrToInt(frmMODFLOW.edNumUnits.Text);

  // creat lists of columns, rows, and cell positions.
  CellPairList := TList.Create;
  ColumnsList := TList.Create;
  RowsList := TList.Create;

  // get the grid layer handle.
  layerHandle := ANE_LayerGetHandleByName(frmMODFLOW.CurrentModelHandle,
    PChar(ModflowTypes.GetGridLayerType.ANE_LayerName) ) ;

  // get the number of rows.
  StringToEvaluate := 'NumRows()';

  ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
    kPIEInteger, PChar(StringToEvaluate), @NumRows );

  // get the number of columns.
  StringToEvaluate := 'NumColumns()';

  ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
    kPIEInteger, PChar(StringToEvaluate), @NumColumns );

  // test that a grid exists.
  Success := (NumRows > 0) and (NumColumns > 0);

  if not Success then
  begin
    Beep;
    ShowMessage('No grid has been created');
  end;

  if Success then
  begin
    // loop over the rows
    for RowIndex := 0 to NumRows do
    begin
      // get the row positions
      StringToEvaluate := 'NthRowPos(' + IntToStr(RowIndex) + ')';

      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
        kPIEFloat, PChar(StringToEvaluate), @ARow );

      // save the row positions.
      APosition := TPosition.Create;
      APosition.Position := ARow;
      RowsList.Add(APosition);
    end;

    // loop over the columns
    for ColumnIndex := 0 to NumColumns do
    begin
      // get the column positions
      StringToEvaluate := 'NthColumnPos(' + IntToStr(ColumnIndex) + ')';

      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
        kPIEFloat, PChar(StringToEvaluate), @AColumn );

      // save the column positions.
      APosition := TPosition.Create;
      APosition.Position := AColumn;
      ColumnsList.Add(APosition);
    end;

    // the grid data has been read.
    GridDataAvailable := True;

{$IFDEF Argus5}
       LayerOptions := TLayerOptions.Create(frmMODFLOW.CurrentModelHandle,
         layerHandle);
       try
         begin
           XDirPositive := LayerOptions.CoordXRight;
           YDirPositive := LayerOptions.CoordYUp;
         end;
       finally
         begin
           LayerOptions.Free;
         end;
       end;
{$ELSE}
    XDirPositive := cbXPos.checked;
    YDirPositive := cbYPos.checked;
    cbXPos.Visible := True;
    cbYPos.Visible := True;
{$ENDIF}
{  ABoolean := True;

  layerHandle := ANE_LayerGetHandleByName(frmMODFLOW.CurrentModelHandle,
    PChar(ModflowTypes.GetMFHFBLayerType.ANE_LayerName + '1') ) ;

  ANE_LayerPropertySet(frmMODFLOW.CurrentModelHandle,
         layerHandle,  'Allow Intersection',
         kPIEBoolean, @ABoolean);    }

  end;


end;

procedure TfrmHFBDisplay.btnDisplayClick(Sender: TObject);
var
  layerHandle : ANE_PTR;
  StringToEvaluate : string;
  SuccessInt : integer;
  SuccessBool : boolean;
  Success : boolean;
  ObjectCount : integer;
  ObjectIndex : integer;
  CellCount : integer;
  CellIndex : integer;
  Row1, Row2, Column1, Column2 : integer;
  ACellPair : TCellPair;
  Index : integer;
begin
  // triggering event btnDisplay.OnClick

  //
  if (CellPairList = nil) then
  begin
    // create the list of cell pairs if it doesn't aready exist.
    CellPairList := TList.Create;
  end
  else
  begin
    // get rid of everything in the cell-pair list if it does exist.
    for Index := CellPairList.Count -1 downto 0 do
    begin
      TCellPair(CellPairList.Items[Index]).Free;
    end;
    CellPairList.Clear;
  end;

  // get the grid layer handle.
  layerHandle := ANE_LayerGetHandleByName(frmMODFLOW.CurrentModelHandle,
    PChar(ModflowTypes.GetGridLayerType.ANE_LayerName) ) ;

  // in BlockList, initialize the grid information.
  StringToEvaluate := 'MODFLOW_BL_InitializeGridInformation("MODFLOW FD Grid")';

  ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
    kPIEInteger, PChar(StringToEvaluate), @SuccessInt );

  // check that operation succeeded.
  Success := (SuccessInt = 1);
  if not Success then
  begin
    Beep;
    ShowMessage('Unable to Initialize grid information');
  end;

  SuccessBool := False;
  if Success then
  begin
    // clear data in vertex list if there is any in it.
    StringToEvaluate := 'MODFLOW_BL_ReInitializeVertexList()';

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
      kPIEBoolean, PChar(StringToEvaluate), @SuccessBool );

  // check that operation succeeded.
    if not SuccessBool then
    begin
      Beep;
      ShowMessage('Unable to Initialize vertex list');
    end;
  end;

  // check that operation succeeded.
  Success := Success and SuccessBool ;

  if Success then
  begin
    // add data for HFB layer.
    StringToEvaluate := 'MODFLOW_BL_AddVertexLayer("' +
      ModflowTypes.GetMFHFBLayerType.ANE_LayerName + adeHFBLayer.Text
      + '")';

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
      kPIEBoolean, PChar(StringToEvaluate), @SuccessBool );

    // check that operation succeeded.
    if not SuccessBool then
    begin
      Beep;
      ShowMessage('Unable process layer ' +
        ModflowTypes.GetMFHFBLayerType.ANE_LayerName + adeHFBLayer.Text);
    end;

  end;

  Success := Success and SuccessBool;

  if Success then
  begin
    // get number of objects on the layer.
    StringToEvaluate := 'MODFLOW_BL_GetCountOfCellLists()';

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
     kPIEInteger, PChar(StringToEvaluate), @ObjectCount );

     if ObjectCount < 1 then
     begin
       Beep;
       ShowMessage('No barriers on this layer.');
     end;

  end;

  Success := Success and (ObjectCount > 0);
  if Success then
  begin
    // loop over objects on layer.
    for ObjectIndex := 0 to ObjectCount -1 do
    begin
      // get number of horizontal-flow barriers that cross columns.
      StringToEvaluate := 'MODFLOW_BL_GetCountOfACrossColumnList('
        + IntToStr(ObjectIndex) + ')';

      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
        kPIEInteger, PChar(StringToEvaluate), @CellCount );

      for CellIndex := 0 to CellCount -1 do
      begin
        // get the row number of one of the HFB cells.
        StringToEvaluate := 'MODFLOW_BL_GetCrossColumnRow('+ IntToStr(ObjectIndex)
          + ', ' + IntToStr(CellIndex) + ')';

        ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
          kPIEInteger, PChar(StringToEvaluate), @Row1 );

        // get the row number of the other HFB cells.
        StringToEvaluate := 'MODFLOW_BL_GetCrossColumnNeighborRow('+ IntToStr(ObjectIndex) + ', '
          + IntToStr(CellIndex) + ')';

        ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
          kPIEInteger, PChar(StringToEvaluate), @Row2 );

        // get the column number of the HFB cells.
        StringToEvaluate := 'MODFLOW_BL_GetCrossColumnColumn('+ IntToStr(ObjectIndex) + ', '
          + IntToStr(CellIndex) + ')';

        ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
          kPIEInteger, PChar(StringToEvaluate), @Column1 );

        Column2 := Column1;

        // check that both cells lie within the grid.
        if not ((Column1 < 1) or (Column1 > NumColumns) or
                (Column2 < 1) or (Column2 > NumColumns) or
                (Row1 < 1) or (Row1 > NumRows) or
                (Row2 < 1) or (Row2 > NumRows)) then
        begin
          // add a pair of cells that define a Horizontal flow varrier
          // to the cellpairlist
          ACellPair := TCellPair.Create;
          ACellPair.Col1 := Column1;
          ACellPair.Col2 := Column2;
          ACellPair.Row1 := Row1;
          ACellPair.Row2 := Row2;
          CellPairList.Add(ACellPair);
        end;

      end;


      // get number of horizontal-flow barriers that cross rows.
      StringToEvaluate := 'MODFLOW_BL_GetCountOfACrossRowList('+ IntToStr(ObjectIndex) + ')';

      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
        kPIEInteger, PChar(StringToEvaluate), @CellCount );

      for CellIndex := 0 to CellCount -1 do
      begin
        // get the row numbers of one of the HFB cells.
        StringToEvaluate := 'MODFLOW_BL_GetCrossRowRow('+ IntToStr(ObjectIndex) + ', '
          + IntToStr(CellIndex) + ')';

        ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
          kPIEInteger, PChar(StringToEvaluate), @Row1 );

        Row2 := Row1;

        // get the column number of one of the HFB cells.
        StringToEvaluate := 'MODFLOW_BL_GetCrossRowColumn('+ IntToStr(ObjectIndex) + ', '
          + IntToStr(CellIndex) + ')';

        ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
          kPIEInteger, PChar(StringToEvaluate), @Column1 );

        // get the column number of the other HFB cells.
        StringToEvaluate := 'MODFLOW_BL_GetCrossRowNeighborColumn('+ IntToStr(ObjectIndex) + ', '
          + IntToStr(CellIndex) + ')';

        ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
          kPIEInteger, PChar(StringToEvaluate), @Column2 );

        // check that both cells lie within the grid.
        if not ((Column1 < 1) or (Column1 > NumColumns) or
                (Column2 < 1) or (Column2 > NumColumns) or
                (Row1 < 1) or (Row1 > NumRows) or
                (Row2 < 1) or (Row2 > NumRows)) then
        begin
          // add a pair of cells that define a Horizontal flow varrier
          // to the cellpairlist
          ACellPair := TCellPair.Create;
          ACellPair.Col1 := Column1;
          ACellPair.Col2 := Column2;
          ACellPair.Row1 := Row1;
          ACellPair.Row2 := Row2;
          CellPairList.Add(ACellPair);
        end;

      end;

    end;

  end;

  // free memory in BlockList.
  StringToEvaluate := 'MODFLOW_BL_FreeAllBlockLists()';

  ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
    kPIEBoolean, PChar(StringToEvaluate), @SuccessBool );

  // refresh image.
  PaintBox1.Invalidate;
end;

procedure TfrmHFBDisplay.FormDestroy(Sender: TObject);
var
  Index : integer;
begin
  // triggering event frmHFBDisplay.OnDestroy

  // get rid of CellPairList, ColumnsList, and RowsList
  if not (CellPairList = nil) then
  begin
    for Index := CellPairList.Count -1 downto 0 do
    begin
      TCellPair(CellPairList.Items[Index]).Free;
    end;
  end;
  CellPairList.Free;

  for Index := ColumnsList.Count -1 downto 0 do
  begin
      TPosition(ColumnsList.Items[Index]).Free;
  end;
  ColumnsList.Free;

  for Index := RowsList.Count -1 downto 0 do
  begin
      TPosition(RowsList.Items[Index]).Free;
  end;
  RowsList.Free;

end;

function TfrmHFBDisplay.ColumnPosition(
  const DataPosition: double): integer;
var
  Reverse : boolean;
begin
  // called by PaintBox1Paint
  // called by DrawBoundary

  // ColumnPosition returns the x screen-coordinate of a column at
  // DataPosition;
  Reverse := not ColumnOrderPositive;
  if not XDirPositive then
  begin
    Reverse := not Reverse;
  end;
  if XDirPositive or not ColumnOrderPositive then
  begin
    result := Position(DataPosition, MinCol, Reverse);
  end
  else
  begin
    result := Position(DataPosition, MaxCol, Reverse);
  end;
  if not ColumnOrderPositive then
  begin
    result := MaxColPosition - result + Margin;
  end;

end;

function TfrmHFBDisplay.RowPosition(const DataPosition: double): integer;
var
  Reverse : boolean;
begin
  // called by PaintBox1Paint
  // called by DrawBoundary

  // RowPosition returns the y screen-coordinate of a row at
  // DataPosition;
  Reverse := not RowOrderPositive;
  if not YDirPositive then
  begin
    Reverse := not Reverse;
  end;
  if YDirPositive or RowOrderPositive then
  begin
    result := Position(DataPosition, MinRow, Reverse);
  end
  else
  begin
    result := Position(DataPosition, MaxRow, Reverse);
  end;  
  if RowOrderPositive then
  begin
    result := MaxRowPosition - result + Margin;
  end;
end;

procedure TfrmHFBDisplay.PaintBox1Paint(Sender: TObject);
var
  PlotAreaWidth, PlotAreaHeight : integer;
  GridWidth, GridHeight : double;
  ColIndex, RowIndex : integer;
  APosition : integer;
  CellPairIndex : Integer;
  Reverse : boolean;
  function Minimum(Num1, Num2 : double) : double;
  begin
    if Num1 < Num2 then result := Num1 else result := Num2;
  end;
begin
  // triggering event Paintbox1.OnPaint

  try
    begin
      if GridDataAvailable then
      begin
        // get the dimensions of the area available for plotting
        PlotAreaWidth := PaintBox1.ClientWidth - 2*Margin;
        PlotAreaHeight := PaintBox1.ClientHeight - 2*Margin;
        // get the positions of the edges of the grid.
        MinCol := TPosition(ColumnsList.Items[0]).Position;
        MaxCol := TPosition(ColumnsList.Items[ColumnsList.Count -1]).Position;
        MinRow := TPosition(RowsList.Items[0]).Position;
        MaxRow := TPosition(RowsList.Items[RowsList.Count -1]).Position;
        // test for reversed grid
        ColumnOrderPositive := (MaxCol > MinCol);
        RowOrderPositive := (MaxRow > MinRow);
        // get the grid dimensions.
        GridWidth := MaxCol - MinCol;
        GridHeight := MaxRow - MinRow;
        // determine conversion factor for transforming real-world coordinates
        // screen coordinates.
        Multiplier := Minimum(Abs(PlotAreaWidth/GridWidth),
          Abs(PlotAreaHeight/GridHeight));

        // Get the screen coordinates of the edges of the grid.
        Reverse := not ColumnOrderPositive;
        if not XDirPositive then
        begin
          Reverse := not Reverse
        end;
        if XDirPositive then
        begin
          MinColPosition := Position(MinCol, MinCol, Reverse);
          MaxColPosition := Position(MaxCol, MinCol, Reverse);
        end
        else
        begin
          MinColPosition := Position(MinCol, MaxCol, Reverse);
          MaxColPosition := Position(MaxCol, MaxCol, Reverse);
        end;

        Reverse := not RowOrderPositive;
        if not YDirPositive then
        begin
          Reverse := not Reverse
        end;
        if YDirPositive then
        begin
          MinRowPosition := Position(MinRow, MinRow, Reverse);
          MaxRowPosition := Position(MaxRow, MinRow, Reverse);
        end
        else
        begin
          MinRowPosition := Position(MinRow, MaxRow, Reverse);
          MaxRowPosition := Position(MaxRow, MaxRow, Reverse);
        end;

        // draw the grid.
        For ColIndex := 0 to ColumnsList.Count -1 do
        begin
          APosition := ColumnPosition(TPosition(ColumnsList.Items[ColIndex]).Position);
          PaintBox1.Canvas.MoveTo(APosition, MinRowPosition);
          PaintBox1.Canvas.LineTo(APosition, MaxRowPosition);
        end;
        For RowIndex := 0 to RowsList.Count -1 do
        begin
          APosition := RowPosition(TPosition(RowsList.Items[RowIndex]).Position);
          PaintBox1.Canvas.MoveTo(MinColPosition, APosition);
          PaintBox1.Canvas.LineTo(MaxColPosition, APosition);
        end;

        // draw the horizontal flow barriers.
        For CellPairIndex := 0 to CellPairList.Count -1 do
        begin
            TCellPair(CellPairList.Items[CellPairIndex]).DrawBoundary;
        end;

        // clear the status bar.
        StatusBar1.SimpleText := '';

      end; // if GridDataAvailable then

      // keep Argus ONE looking pretty.
      ANE_ProcessEvents(frmModflow.CurrentModelHandle);

    end;
  except on EConvertError do
    begin
      // show error message.
      StatusBar1.SimpleText := 'Error displaying grid';
    end;
  end;


end;

procedure TCellPair.DrawBoundary;
var
  Pen: TPen;
  FirstX, SecondX, FirstY, SecondY : double;
  FirstXPosition, SecondXPosition, FirstYPosition, SecondYPosition : Integer;
  Procedure MinimumFirst(var Num1, Num2 : integer);
  // MinimumFirst ensures that Num1 <= Num2 by exchanging them if Num1 > Num2
  var
    temp : integer;
  begin
    if Num1 > Num2 then
    begin
      temp := Num1;
      Num1 := Num2;
      Num2 := temp;
    end;
  end;
begin
  // This procedure draws the boundaries between HFB cells in red.

  // make Col1 <= Col2 and Row1 <= Row2
  MinimumFirst(Col1, Col2);
  MinimumFirst(Row1, Row2);

  // Get the X-real-world-coordinates of the two ends of the line
  // definining the boundary between the two HFB cells.
  if Col1 = Col2
  then
    begin
      FirstX := TPosition(frmHFBDisplay.ColumnsList.Items[Col1-1]).Position;
      SecondX := TPosition(frmHFBDisplay.ColumnsList.Items[Col1]).Position;
    end
  else
    begin
      FirstX := TPosition(frmHFBDisplay.ColumnsList.Items[Col2-1]).Position;
      SecondX := FirstX;
    end;
  // Get the Y-real-world-coordinates of the two ends of the line
  // definining the boundary between the two HFB cells.
  if Row1 = Row2
  then
    begin
      FirstY := TPosition(frmHFBDisplay.RowsList.Items[Row1-1]).Position;
      SecondY := TPosition(frmHFBDisplay.RowsList.Items[Row1]).Position;
    end
  else
    begin
      FirstY := TPosition(frmHFBDisplay.RowsList.Items[Row2-1]).Position;
      SecondY := FirstY;
    end;
  // convert real-world coordinates to screen coordinates.
  FirstXPosition := frmHFBDisplay.ColumnPosition(FirstX);
  SecondXPosition := frmHFBDisplay.ColumnPosition(SecondX);
  FirstYPosition := frmHFBDisplay.RowPosition(FirstY);
  SecondYPosition := frmHFBDisplay.RowPosition(SecondY);

  // create a pen to save the current value of the canvas pen
  Pen := TPen.Create;
  try
    begin
      // save the current values of the canvas pen
      Pen.Assign(frmHFBDisplay.PaintBox1.Canvas.Pen);

      // assign new values to the canvas pen.
      frmHFBDisplay.PaintBox1.Canvas.Pen.Color := clRed;
      frmHFBDisplay.PaintBox1.Canvas.Pen.Width := 3;

      // draw the line between the two HFB cells.
      frmHFBDisplay.PaintBox1.Canvas.MoveTo(FirstXPosition,FirstYPosition);
      frmHFBDisplay.PaintBox1.Canvas.LineTo(SecondXPosition,SecondYPosition);

      // restore the canvas pen.
      frmHFBDisplay.PaintBox1.Canvas.Pen := Pen;
    end;
  finally
    begin
      // get rid the temporary pen.
      Pen.Free;

    end;
  end;
end;

procedure TfrmHFBDisplay.MouseMoved(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  // triggering event Panel1.OnMouseMove
  // triggering event Paintbox1.OnMouseMove
  // triggering event StatusBar1.OnMouseMove
  // triggering event frmHFBDisplay.OnMouseMove

  // keep Argus ONE looking pretty.
  ANE_ProcessEvents(frmModflow.CurrentModelHandle);

end;

function TfrmHFBDisplay.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  // triggering events: frmHFBDisplay.OnHelp;

  // This assigns the help file every time Help is called from frmMODFLOW.
  // AssignHelpFile is a virtual function that can be overridden by
  // descendents to assign a different help file for controls not present
  // in TfrmMODFLOW.
  AssignHelpFile('MODFLOW.hlp');
  result := True;


end;

procedure TfrmHFBDisplay.AssignHelpFile(FileName : string);
var
    DllDirectory : String;
begin
  // called by FormHelp

  // This procedure assigns the proper help file to the application.
  // It may be overridden in descendent classes.
  if GetDllDirectory(DLLName, DllDirectory )
  then
    begin
      HelpFile := DllDirectory + '\' + FileName; // MODFLOW.hlp';
    end
  else
    begin
      Beep;
      ShowMessage(DLLName + ' not found.');
    end;
end;

procedure TfrmHFBDisplay.cbXPosClick(Sender: TObject);
begin
  XDirPositive := cbXPos.checked;
  PaintBox1.Invalidate;
end;

procedure TfrmHFBDisplay.cbYPosClick(Sender: TObject);
begin
  YDirPositive := cbYPos.checked;
  PaintBox1.Invalidate;
end;

end.






