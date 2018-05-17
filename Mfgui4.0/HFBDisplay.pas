unit HFBDisplay;

interface

{ HFBDisplay is used to define a form for displaying the locations of
 horizontal-flow barriers. Note: PaintBox1 is likely to be changed to
 a different component in a future version of the PIE.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, StdCtrls, ArgusDataEntry, ExtCtrls, AnePIE, Buttons, ComCtrls,
  RBWZoomBox, contnrs, Rbw95Button;

type
  TfrmHFBDisplay = class(TArgusForm)
    Panel1: TPanel;
    adeHFBLayer: TArgusDataEntry;
    Label1: TLabel;
    btnDisplay: TButton;
    bitbtnClose: TBitBtn;
    btnHelp: TBitBtn;
    cbXPos: TCheckBox;
    cbYPos: TCheckBox;
    zbHFB_Display: TRBWZoomBox;
    sbZoomIn: TSpeedButton;
    sbZoomOut: TSpeedButton;
    sbPan: TSpeedButton;
    SaveDialog1: TSaveDialog;
    btnSave: TRbw95Button;
    btnPrint: TButton;
    PrinterSetupDialog1: TPrinterSetupDialog;
    PrintDialog1: TPrintDialog;
    procedure FormCreate(Sender: TObject); override;
    procedure btnDisplayClick(Sender: TObject); virtual;
    procedure FormDestroy(Sender: TObject); override;
    procedure MouseMoved(Sender: TObject; Shift: TShiftState; X,
      Y: Integer); virtual;
    procedure cbXPosClick(Sender: TObject); virtual;
    procedure cbYPosClick(Sender: TObject); virtual;
    procedure zbHFB_DisplayPaint(Sender: TObject);
    procedure sbZoomInClick(Sender: TObject);
    procedure sbZoomOutClick(Sender: TObject);
    procedure sbPanClick(Sender: TObject);
    procedure zbHFB_DisplayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zbHFB_DisplayMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure zbHFB_DisplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SaveDialog1TypeChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    MaxX, MinX : double;
    MaxY, MinY : double;
    procedure FillColumnsPointsList;
    procedure FillRowPointsList;
    procedure FillGridLists;
    procedure DrawFigure(const Canvas: TCanvas; const Scale: integer = 1);
    { Private declarations }
  public
    CellPairList : TList;
    // CellPairList is a list of TCellPair's that define the positions
    // of the horizontal flow barriers.
    ColumnsList : TList;
    // ColumnList is a list of column positions
    RowsList : TList;
    // RowsList is a list of row positions
    ColumnPointsList : TObjectList;
    RowPointList : TObjectList;
    BarrierList : TObjectList;
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
//    procedure AssignHelpFile(FileName : string); virtual;
  end;

Type
  TCellPair = Class(TObject)
    Col1 : Integer;
    Row1 : integer;
    Col2 : integer;
    Row2 : integer;
    ZoomPoint1 : TRBWZoomPoint;
    ZoomPoint2 : TRBWZoomPoint;
    FZoomBox : TRBWZoomBox;
  public
    procedure DrawBoundary(MinX, MinY, MaxX, MaxY : double;
      XPositive, YPositive : boolean; Const Canvas: TCanvas; const Scale: integer = 1);
    Constructor Create(ZoomBox : TRBWZoomBox);
    Destructor Destroy; override;
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

uses Variables, ANECB, ANE_LayerUnit, UtilityFunctions,
     ModflowUnit, OptionsUnit, RunUnit, Printers, math;

procedure GDisplayHFBPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;
begin
  Exporting := True;
  Try
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
                Application.CreateForm(TfrmHFBDisplay,frmHFBDisplay);
//                frmHFBDisplay := TfrmHFBDisplay.Create(Application);
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
  finally
    Exporting := False;
  end;
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
  STR : ANE_STR;
  LayerName : string;
{$IFDEF Argus5}
  LayerOptions : TLayerOptions;
{$ENDIF}
begin
  // triggering event frmHFBDisplay.OnCreate
  ColumnPointsList := TObjectList.Create;
  RowPointList := TObjectList.Create;
  BarrierList := TObjectList.Create;

  // assume no grid is available until the grid data has been read.
  GridDataAvailable := False;
  // prevent the user from entering a value larger than the number of units.
  adeHFBLayer.Max := StrToInt(frmMODFLOW.edNumUnits.Text);

  // creat lists of columns, rows, and cell positions.
  CellPairList := TList.Create;
  ColumnsList := TList.Create;
  RowsList := TList.Create;

  // get the grid layer handle.
  LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
  layerHandle := GetLayerHandle(frmMODFLOW.CurrentModelHandle,LayerName);

  // get the number of rows.
  StringToEvaluate := 'NumRows()';

  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
      kPIEInteger, STR, @NumRows );
    ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
  finally
    FreeMem(STR);
  end;

  // get the number of columns.
  StringToEvaluate := 'NumColumns()';

  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
      kPIEInteger, STR, @NumColumns );
    ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
  finally
    FreeMem(STR);
  end;

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

      GetMem(STR, Length(StringToEvaluate) + 1);
      try
        StrPCopy(STR,StringToEvaluate);
        ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
          kPIEFloat, STR, @ARow );
        ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
      finally
        FreeMem(STR);
      end;

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

      GetMem(STR, Length(StringToEvaluate) + 1);
      try
        StrPCopy(STR,StringToEvaluate);
        ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
          kPIEFloat, STR, @AColumn );
        ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
      finally
        FreeMem(STR);
      end;

      // save the column positions.
      APosition := TPosition.Create;
      APosition.Position := AColumn;
      ColumnsList.Add(APosition);
    end;

    // the grid data has been read.
    GridDataAvailable := True;

{$IFDEF Argus5}
       LayerOptions := TLayerOptions.Create(layerHandle);
       try
         begin
           XDirPositive := not LayerOptions.GridReverseXDirection[frmMODFLOW.CurrentModelHandle];
           YDirPositive := not LayerOptions.GridReverseYDirection[frmMODFLOW.CurrentModelHandle];
         end;
       finally
         begin
           LayerOptions.Free(frmMODFLOW.CurrentModelHandle);
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
    FillGridLists;

  end;
end;

procedure TfrmHFBDisplay.FillGridLists;
begin
  FillRowPointsList;
  FillColumnsPointsList;
  zbHFB_Display.ZoomOut
end;

procedure TfrmHFBDisplay.FillRowPointsList;
var
  APosition : TPosition;
  StartPosition, EndPosition : double;
  RowIndex : integer;
  AZoomPoint : TRBWZoomPoint;
  Y : double;
begin
  RowPointList.Clear;
  if XDirPositive then
  begin
    APosition := ColumnsList[0];
  end
  else
  begin
    APosition := ColumnsList[ColumnsList.Count -1];
//    APosition := ColumnsList[0];
  end;
//  APosition := ColumnsList[0];
  StartPosition := APosition.Position;
  if XDirPositive then
  begin
    APosition := ColumnsList[ColumnsList.Count -1];
  end
  else
  begin
    APosition := ColumnsList[0];
//    APosition := ColumnsList[ColumnsList.Count -1];
  end;
  EndPosition := APosition.Position;

//  APosition := RowsList[RowsList.Count -1];
//  MaxY := APosition.Position;
  APosition := RowsList[0];
//  MaxY := MaxY - APosition.Position;
  MaxY := APosition.Position;
  APosition := RowsList[RowsList.Count -1];
  MinY := APosition.Position;

  for RowIndex := 0 to RowsList.Count -1 do
  begin
    APosition := RowsList[RowIndex];
    if not YDirPositive then
    begin
      Y := APosition.Position;
    end
    else
    begin
      Y := MaxY - APosition.Position + MinY;
    end;

    AZoomPoint := TRBWZoomPoint.Create(zbHFB_Display);
    AZoomPoint.X := StartPosition;
    AZoomPoint.Y := Y;
    RowPointList.Add(AZoomPoint);

    AZoomPoint := TRBWZoomPoint.Create(zbHFB_Display);
    AZoomPoint.X := EndPosition;
    AZoomPoint.Y := Y;
    RowPointList.Add(AZoomPoint);
  end;
end;

procedure TfrmHFBDisplay.FillColumnsPointsList;
var
  APosition : TPosition;
  StartPosition, EndPosition : double;
  ColumnIndex : integer;
  AZoomPoint : TRBWZoomPoint;
  X : double;
begin
  ColumnPointsList.Clear;
  if YDirPositive then
  begin
    APosition := RowsList[0];
  end
  else
  begin
    APosition := RowsList[RowsList.Count -1];
//    APosition := RowsList[0];
  end;
//  APosition := ColumnsList[0];
  StartPosition := APosition.Position;
  if YDirPositive then
  begin
    APosition := RowsList[RowsList.Count -1];
  end
  else
  begin
    APosition := RowsList[0];
//    APosition := RowsList[RowsList.Count -1];
  end;
  EndPosition := APosition.Position;

//  APosition := ColumnsList[ColumnsList.Count -1];
//  MaxX := APosition.Position;
  APosition := ColumnsList[0];
//  MaxX := MaxX - APosition.Position;
  MaxX := APosition.Position;
  APosition := ColumnsList[ColumnsList.Count -1];
  MinX := APosition.Position;

  for ColumnIndex := 0 to ColumnsList.Count -1 do
  begin
    APosition := ColumnsList[ColumnIndex];
    if {not} XDirPositive then
    begin
      X := APosition.Position;
    end
    else
    begin
      X := MaxX - APosition.Position + MinX;
    end;

    AZoomPoint := TRBWZoomPoint.Create(zbHFB_Display);
    AZoomPoint.X := X;
    AZoomPoint.Y := StartPosition;
    ColumnPointsList.Add(AZoomPoint);

    AZoomPoint := TRBWZoomPoint.Create(zbHFB_Display);
    AZoomPoint.X := X;
    AZoomPoint.Y := EndPosition;
    ColumnPointsList.Add(AZoomPoint);
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
  STR : ANE_STR;
  LayerName : string;
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
  LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
  layerHandle := GetLayerHandle(frmMODFLOW.CurrentModelHandle,LayerName);

  // in BlockList, initialize the grid information.
  StringToEvaluate := 'MODFLOW_BL_InitializeGridInformation("MODFLOW FD Grid")';

  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
      kPIEInteger, STR, @SuccessInt );
    ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
  finally
    FreeMem(STR);
  end;

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

    GetMem(STR, Length(StringToEvaluate) + 1);
    try
      StrPCopy(STR,StringToEvaluate);
      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
        kPIEBoolean, STR, @SuccessBool );
    ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
    finally
      FreeMem(STR);
    end;

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

    GetMem(STR, Length(StringToEvaluate) + 1);
    try
      StrPCopy(STR,StringToEvaluate);
      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
        kPIEBoolean, STR, @SuccessBool );
      ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
    finally
      FreeMem(STR);
    end;

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

    GetMem(STR, Length(StringToEvaluate) + 1);
    try
      StrPCopy(STR,StringToEvaluate);
      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
        kPIEInteger, STR, @ObjectCount );
      ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
    finally
      FreeMem(STR);
    end;

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

      GetMem(STR, Length(StringToEvaluate) + 1);
      try
        StrPCopy(STR,StringToEvaluate);
        ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
          kPIEInteger, STR, @CellCount );
        ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
      finally
        FreeMem(STR);
      end;

      for CellIndex := 0 to CellCount -1 do
      begin
        // get the row number of one of the HFB cells.
        StringToEvaluate := 'MODFLOW_BL_GetCrossColumnRow('+ IntToStr(ObjectIndex)
          + ', ' + IntToStr(CellIndex) + ')';

        GetMem(STR, Length(StringToEvaluate) + 1);
        try
          StrPCopy(STR,StringToEvaluate);
          ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
            kPIEInteger, STR, @Row1 );
          ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
        finally
          FreeMem(STR);
        end;

        // get the row number of the other HFB cells.
        StringToEvaluate := 'MODFLOW_BL_GetCrossColumnNeighborRow('+ IntToStr(ObjectIndex) + ', '
          + IntToStr(CellIndex) + ')';

        GetMem(STR, Length(StringToEvaluate) + 1);
        try
          StrPCopy(STR,StringToEvaluate);
          ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
            kPIEInteger, STR, @Row2 );
          ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
        finally
          FreeMem(STR);
        end;

        // get the column number of the HFB cells.
        StringToEvaluate := 'MODFLOW_BL_GetCrossColumnColumn('+ IntToStr(ObjectIndex) + ', '
          + IntToStr(CellIndex) + ')';

        GetMem(STR, Length(StringToEvaluate) + 1);
        try
          StrPCopy(STR,StringToEvaluate);
          ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
            kPIEInteger, STR, @Column1 );
          ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
        finally
          FreeMem(STR);
        end;

        Column2 := Column1;

        // check that both cells lie within the grid.
        if not ((Column1 < 1) or (Column1 > NumColumns) or
                (Column2 < 1) or (Column2 > NumColumns) or
                (Row1 < 1) or (Row1 > NumRows) or
                (Row2 < 1) or (Row2 > NumRows)) then
        begin
          // add a pair of cells that define a Horizontal flow varrier
          // to the cellpairlist
          ACellPair := TCellPair.Create(zbHFB_Display);
          ACellPair.Col1 := Column1;
          ACellPair.Col2 := Column2;
          ACellPair.Row1 := Row1;
          ACellPair.Row2 := Row2;
          CellPairList.Add(ACellPair);
        end;

      end;


      // get number of horizontal-flow barriers that cross rows.
      StringToEvaluate := 'MODFLOW_BL_GetCountOfACrossRowList('+ IntToStr(ObjectIndex) + ')';

      GetMem(STR, Length(StringToEvaluate) + 1);
      try
        StrPCopy(STR,StringToEvaluate);
        ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
          kPIEInteger, STR, @CellCount );
        ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
      finally
        FreeMem(STR);
      end;

      for CellIndex := 0 to CellCount -1 do
      begin
        // get the row numbers of one of the HFB cells.
        StringToEvaluate := 'MODFLOW_BL_GetCrossRowRow('+ IntToStr(ObjectIndex) + ', '
          + IntToStr(CellIndex) + ')';

        GetMem(STR, Length(StringToEvaluate) + 1);
        try
          StrPCopy(STR,StringToEvaluate);
          ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
            kPIEInteger, STR, @Row1 );
          ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
        finally
          FreeMem(STR);
        end;

        Row2 := Row1;

        // get the column number of one of the HFB cells.
        StringToEvaluate := 'MODFLOW_BL_GetCrossRowColumn('+ IntToStr(ObjectIndex) + ', '
          + IntToStr(CellIndex) + ')';

        GetMem(STR, Length(StringToEvaluate) + 1);
        try
          StrPCopy(STR,StringToEvaluate);
          ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
            kPIEInteger, STR, @Column1 );
          ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
        finally
          FreeMem(STR);
        end;

        // get the column number of the other HFB cells.
        StringToEvaluate := 'MODFLOW_BL_GetCrossRowNeighborColumn('+ IntToStr(ObjectIndex) + ', '
          + IntToStr(CellIndex) + ')';

        GetMem(STR, Length(StringToEvaluate) + 1);
        try
          StrPCopy(STR,StringToEvaluate);
          ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
            kPIEInteger, STR, @Column2 );
          ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
        finally
          FreeMem(STR);
        end;

        // check that both cells lie within the grid.
        if not ((Column1 < 1) or (Column1 > NumColumns) or
                (Column2 < 1) or (Column2 > NumColumns) or
                (Row1 < 1) or (Row1 > NumRows) or
                (Row2 < 1) or (Row2 > NumRows)) then
        begin
          // add a pair of cells that define a Horizontal flow varrier
          // to the cellpairlist
          ACellPair := TCellPair.Create(zbHFB_Display);
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

  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
      kPIEBoolean, STR, @SuccessBool );
    ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
  finally
    FreeMem(STR);
  end;

  // refresh image.
  zbHFB_Display.Invalidate;
end;

procedure TfrmHFBDisplay.FormDestroy(Sender: TObject);
var
  Index : integer;
begin
  // triggering event frmHFBDisplay.OnDestroy
  ColumnPointsList.Free;
  RowPointList.Free;
  BarrierList.Free;
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
  if {not} YDirPositive then
  begin
    Reverse := not Reverse;
  end;
  if not YDirPositive or RowOrderPositive then
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



constructor TCellPair.Create(ZoomBox: TRBWZoomBox);
begin
  inherited Create;
  FZoomBox := ZoomBox;
  ZoomPoint1 := TRBWZoomPoint.Create(ZoomBox);
  ZoomPoint2 := TRBWZoomPoint.Create(ZoomBox);
end;

destructor TCellPair.Destroy;
begin
  ZoomPoint1.Free;
  ZoomPoint2.Free;
  inherited;
end;

procedure TCellPair.DrawBoundary(MinX, MinY, MaxX, MaxY : double;
  XPositive, YPositive : boolean; Const Canvas: TCanvas; const Scale: integer = 1);
var
  Pen: TPen;
  FirstX, SecondX, FirstY, SecondY : double;
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

  if XPositive then
  begin
    ZoomPoint1.X := FirstX;
    ZoomPoint2.X := SecondX;
  end
  else
  begin
    ZoomPoint1.X := MaxX - FirstX + MinX;
    ZoomPoint2.X := MaxX - SecondX + MinX;
  end;
  if not YPositive then
  begin
    ZoomPoint1.Y := FirstY;
    ZoomPoint2.Y := SecondY;
  end
  else
  begin
    ZoomPoint1.Y := MaxY - FirstY + MinY;
    ZoomPoint2.Y := MaxY - SecondY + MinY;
  end;

  // create a pen to save the current value of the canvas pen
  Pen := TPen.Create;
  try
    begin
      // save the current values of the canvas pen
      Pen.Assign(Canvas.Pen);

      // assign new values to the canvas pen.
      Canvas.Pen.Color := clRed;
      Canvas.Pen.Width := 3*Scale;

      // draw the line between the two HFB cells.
      Canvas.MoveTo(ZoomPoint1.XCoord*Scale,ZoomPoint1.YCoord*Scale);
      Canvas.LineTo(ZoomPoint2.XCoord*Scale,ZoomPoint2.YCoord*Scale);

      // restore the canvas pen.
      Canvas.Pen := Pen;
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
  // triggering event zbHFB_Display.OnMouseMove
  // triggering event frmHFBDisplay.OnMouseMove

  // keep Argus ONE looking pretty.
  ANE_ProcessEvents(frmModflow.CurrentModelHandle);

end;

procedure TfrmHFBDisplay.cbXPosClick(Sender: TObject);
begin
  XDirPositive := cbXPos.checked;
  FillGridLists;
end;

procedure TfrmHFBDisplay.cbYPosClick(Sender: TObject);
begin
  YDirPositive := cbYPos.checked;
  FillGridLists;
end;

procedure TfrmHFBDisplay.DrawFigure(const Canvas : TCanvas; const Scale: integer = 1);
var
  Index : integer;
  StartZoomPoint, EndZoomPoint : TRBWZoomPoint;
  CellPairIndex : integer;
begin
  // triggering event zbHFB_Display.OnPaint
  if GridDataAvailable then
  begin

    for Index := 0 to (ColumnPointsList.Count div 2) -1 do
    begin
      StartZoomPoint := ColumnPointsList[Index*2] as TRBWZoomPoint;
      EndZoomPoint := ColumnPointsList[Index*2 + 1] as TRBWZoomPoint;
      with Canvas do
      begin
        MoveTo(StartZoomPoint.XCoord*Scale, StartZoomPoint.YCoord*Scale);
        LineTo(EndZoomPoint.XCoord*Scale, EndZoomPoint.YCoord*Scale);
      end;
    end;
    for Index := 0 to (RowPointList.Count div 2) -1 do
    begin
      StartZoomPoint := RowPointList[Index*2] as TRBWZoomPoint;
      EndZoomPoint := RowPointList[Index*2 + 1] as TRBWZoomPoint;
      with Canvas do
      begin
        MoveTo(StartZoomPoint.XCoord*Scale, StartZoomPoint.YCoord*Scale);
        LineTo(EndZoomPoint.XCoord*Scale, EndZoomPoint.YCoord*Scale);
      end;
    end;
    // draw the horizontal flow barriers.
    For CellPairIndex := 0 to CellPairList.Count -1 do
    begin
      TCellPair(CellPairList.Items[CellPairIndex]).DrawBoundary
        (MinX, MinY, MaxX, MaxY, XDirPositive, YDirPositive, Canvas, Scale);
    end;

  end; // if GridDataAvailable then

  // keep Argus ONE looking pretty.
  ANE_ProcessEvents(frmModflow.CurrentModelHandle);

end;

procedure TfrmHFBDisplay.zbHFB_DisplayPaint(Sender: TObject);
begin
  DrawFigure(zbHFB_Display.PBCanvas);
  // triggering event zbHFB_Display.OnPaint
end;

procedure TfrmHFBDisplay.sbZoomInClick(Sender: TObject);
begin
  inherited;
  if sbZoomIn.Down then
  begin
    zbHFB_Display.Cursor := crCross;
    zbHFB_Display.PBCursor := crCross;
    zbHFB_Display.SCursor := crCross;
  end;

end;

procedure TfrmHFBDisplay.sbZoomOutClick(Sender: TObject);
begin
  inherited;
  if sbZoomOut.Down then
  begin
    zbHFB_Display.ZoomOut;
    zbHFB_Display.Cursor := crDefault;
    zbHFB_Display.PBCursor := crDefault;
    zbHFB_Display.SCursor :=  crDefault;
    sbPan.Enabled := False;
    sbZoomOut.Down := False;
  end;
end;

procedure TfrmHFBDisplay.sbPanClick(Sender: TObject);
begin
  inherited;
  if sbPan.Down then
  begin
    zbHFB_Display.Cursor := crHandPoint;
    zbHFB_Display.PBCursor := crHandPoint;
    zbHFB_Display.SCursor :=  crHandPoint;
  end
  else
  begin
    zbHFB_Display.Cursor := crDefault;
    zbHFB_Display.PBCursor := crDefault;
    zbHFB_Display.SCursor :=  crDefault;
  end;

end;

procedure TfrmHFBDisplay.zbHFB_DisplayMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if sbZoomIn.Down then
  begin
    zbHFB_Display.BeginZoom(X,Y)
  end
  else if sbPan.Down then
  begin
    zbHFB_Display.BeginPan;
  end;
end;

procedure TfrmHFBDisplay.zbHFB_DisplayMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if sbZoomIn.Down then
  begin
    zbHFB_Display.ContinueZoom(X,Y);
  end;
  MouseMoved(Sender,Shift,X, Y);
end;

procedure TfrmHFBDisplay.zbHFB_DisplayMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if sbZoomIn.Down then
  begin
    zbHFB_Display.FinishZoom(X,Y);
    sbZoomIn.Down := False;
    sbPan.Enabled := True;
  end
  else if sbPan.Down then
  begin
    zbHFB_Display.EndPan;
  end;

end;

procedure TfrmHFBDisplay.SaveDialog1TypeChange(Sender: TObject);
begin
  inherited;
  case SaveDialog1.FilterIndex of
    1:
      begin
        SaveDialog1.DefaultExt := 'emf';
      end;
    2:
      begin
        SaveDialog1.DefaultExt := 'wmf';
      end;
    3:
      begin
        SaveDialog1.DefaultExt := 'bmp';
      end;
  else Assert(False);
  end;

end;

procedure TfrmHFBDisplay.btnSaveClick(Sender: TObject);
var
  MetaFile : TMetafile;
  BitMap : TBitMap;
  MetaFileCanvas : TMetaFileCanvas;
begin
  inherited;
  if SaveDialog1.Execute then
  begin
    case SaveDialog1.FilterIndex of
      1,2:
        begin
          MetaFile := TMetafile.Create;
          try
            MetaFile.Enhanced := SaveDialog1.FilterIndex = 1;
            MetaFile.Height := zbHFB_Display.PBHeight;
            MetaFile.Width := zbHFB_Display.PBWidth;
            MetaFileCanvas := TMetaFileCanvas.CreateWithComment(MetaFile, 0,
              'MODFLOW GUI', 'Horizontal Flow Barrier locations');
            try
              DrawFigure(MetaFileCanvas);
            finally
              MetaFileCanvas.Free;
            end;
            MetaFile.SaveToFile(SaveDialog1.FileName);
          finally
            MetaFile.Free;
          end;
        end;
      3:
        begin
          BitMap := TBitMap.Create;
          try
            BitMap.Height := zbHFB_Display.PBHeight;
            BitMap.Width := zbHFB_Display.PBWidth;
            DrawFigure(BitMap.Canvas);
            BitMap.SaveToFile(SaveDialog1.FileName);
          finally
            BitMap.Free;
          end;

        end;
    else Assert(False);
    end;

  end;

end;

procedure TfrmHFBDisplay.btnPrintClick(Sender: TObject);
begin
  inherited;
  if PrinterSetupDialog1.Execute and PrintDialog1.Execute then
  begin
    Printer.BeginDoc;
    DrawFigure(Printer.Canvas, Min(Printer.PageWidth div zbHFB_Display.PBWidth,
      Printer.PageHeight div zbHFB_Display.PBHeight));
    Printer.EndDoc;
  end;

end;

end.
