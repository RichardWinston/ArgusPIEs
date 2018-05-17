unit SelectPostFile;

interface

{SelectPostFile defines the form displayed when someone wants to import
 data from a model for visualization. It also has functions for reading the
 data.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ExtCtrls, Buttons, ThreeDRealListUnit, AnePIE;

type
  TfrmSelectPostFile = class (TForm)
    rgSourceType : TRadioGroup;
    BitBtn1      : TBitBtn;
    OpenDialog1  : TOpenDialog;
    BitBtn3      : TBitBtn;
    btnSelect    : TButton;
    procedure rgSourceTypeClick (Sender: TObject); virtual;
    procedure BitBtn2Click (Sender: TObject); virtual;
    function FormHelp (Command: Word; Data: Integer; var CallHelp: Boolean) :
      Boolean; virtual;
    procedure FormCreate (Sender: TObject); virtual;
  private
    procedure ReadMatrix (var ALine, TEXT, FMTOUT, direction: string; var KSTP,
      KPER, NCOL, NROW, ILAY, KS, IMOV, 
    StartRow, EndRow, StartColumn, EndColumn: integer; LayerIndex: Integer; var
      PERTIM, TOTIM, SUMTCH, DataValue: double; var NumRows, NumColumns: LongInt; var
      ADataSet: T3DRealList; ReverseValue: boolean); virtual;

    //   KPER : integer;
    //   PERTIM : double;
    //   TOTIM : double;
    //   : string;
    //   NCOL : integer;
    //   NROW : integer;
    //   ILAY : integer;
    //   FMTOUT: string;
    //   KS, IMOV : integer;
    //   SUMTCH : double;
    //    : string;
    //   LayerIndex, RowIndex, ColumnIndex : integer;
    //   StartRow, EndRow, StartColumn, EndColumn : integer;
    //   DataValue : double;
    //   ADataSet : T3DRealList
    { Private declarations }
    public
      CurrentModelHandle : ANE_PTR;
      XPositive, YPositive : boolean;
      procedure AssignHelpFile (FileName: string);
        virtual;
      Procedure Moved (var Message: TWMWINDOWPOSCHANGED);
        message WM_WINDOWPOSCHANGED;
    { Public declarations }
  end;

{var
  frmSelectPostFile: TfrmSelectPostFile;  }
implementation

uses
  ModflowUnit, PostMODFLOW, Variables, ANECB, MOC3DGridFunctions,
    UtilityFunctions, ArgusFormUnit;

var
  MFFile : TextFile;

{$R *.DFM}

procedure TfrmSelectPostFile.AssignHelpFile (FileName: string);
var
  DllDirectory : String;
begin
  // called by FormHelp
  // This procedure assigns the proper help file to the application.
  // It may be overridden in descendent classes.
  if GetDllDirectory (DLLName, DllDirectory) then
  begin
    HelpFile := DllDirectory + '\' + FileName // MODFLOW.hlp';
  end
  else
  begin
    Beep;
    ShowMessage (DLLName + ' not found.')
  end;
end;



procedure TfrmSelectPostFile.rgSourceTypeClick (Sender: TObject);
begin
  // triggering event rgSourceType.OnClick
  case rgSourceType.ItemIndex of
  0: // MODFLOW (Head and Drawdown)
    begin
      OpenDialog1.Filter := 'Formatted Head (*.FHD)' +
        '|*.FHD|Formatted Drawdown (*.FDN)|*.FDN|All Files (*.*)|*.*';
      frmMODFLOWPostProcessing.rgChartType.Enabled := True;
//      cbX.Enabled := False;
//      cbY.Enabled := False
    end;
  1: // MOC3D (Concentrations)
    begin
      OpenDialog1.Filter := 'MOC3D Concentrations (*.CNA)' +
        '|*.CNA|All Files (*.*)|*.*';
      frmMODFLOWPostProcessing.rgChartType.Enabled := True;
//      cbX.Enabled := False;
//      cbY.Enabled := False
    end;
  2: // MOC3D (Velocities)
    begin
      OpenDialog1.Filter := 'MOC3D Velocities (*.VLA)' +
        '|*.VLA|All Files (*.*)|*.*';
      frmMODFLOWPostProcessing.rgChartType.Enabled := False;
//      cbX.Enabled := True;
//      cbY.Enabled := True
    end;
  end
end;



procedure ReadMODFLOWHeader (var KSTP, KPER, NCOL, NROW, ILAY: integer; var
  PERTIM, TOTIM: double; var TEXT, FMTOUT: string; ALine: string);
begin
  // called by btnOpenDataSetClick;
  try
    KSTP := StrToInt (Copy (ALine, 2, 5))
  except
    on EConvertError do
      KSTP := -1
  end;

  try
    KPER := StrToInt (Copy (ALine, 7, 5))
  except
    on EConvertError do
      KPER := -1
  end;

  try
    PERTIM := StrToFloat (Copy (ALine, 12, 15))
  except
    on EConvertError do
      PERTIM := -1
  end;

  try
    TOTIM := StrToFloat (Copy (ALine, 27, 15))
  except
    on EConvertError do
      TOTIM := -1
  end;

  TEXT := Copy (ALine, 43, 16);

  try
    NCOL := StrToInt (Copy (ALine, 59, 6))
  except
    on EConvertError do
      NCOL := -1
  end;

  try
    NROW := StrToInt (Copy (ALine, 65, 6))
  except
    on EConvertError do
      NROW := -1
  end;

  try
    ILAY := StrToInt (Copy (ALine, 71, 6))
  except
    on EConvertError do
      ILAY := -1
  end;

  FMTOUT := Copy (ALine, 72, 20)
end;



procedure ReadMOC3DConcentrationHeader (var KS, IMOV, KSTP, KPER: integer; var
  SUMTCH: double; ALine: string);
begin
  // called by btnOpenDataSetClick;
  try
    KS := StrToInt (Copy (ALine, 42, 4))
  except
    on EConvertError do
      KS := -1
  end;

  try
    IMOV := StrToInt (Copy (ALine, 53, 5))
  except
    on EConvertError do
      IMOV := -1
  end;

  try
    KSTP := StrToInt (Copy (ALine, 65, 5))
  except
    on EConvertError do
      KSTP := -1
  end;

  try
    KPER := StrToInt (Copy (ALine, 77, 5))
  except
    on EConvertError do
      KPER := -1
  end;

  try
    SUMTCH := StrToFloat (Copy (ALine, 91, 10))
  except
    on EConvertError do
      SUMTCH := -1
  end
end;



procedure ReadMOC3DVeolocityHeader (var direction: string; var KS, KSTP, KPER:
  integer; var TOTIM: double; ALine: string);
begin
  // called by btnOpenDataSetClick;
  direction := Trim (Copy (ALine, 8, 8));

  try
    KS := StrToInt (Copy (ALine, 54, 4))
  except
    on EConvertError do
      KS := -1
  end;

  try
    KSTP := StrToInt (Copy (ALine, 65, 5))
  except
    on EConvertError do
      KSTP := -1
  end;

  try
    KPER := StrToInt (Copy (ALine, 77, 5))
  except
    on EConvertError do
      KPER := -1
  end;

  try
    TOTIM := StrToFloat (Copy (ALine, 90, 15))
  except
    on EConvertError do
      TOTIM := -1
  end
end;



procedure TfrmSelectPostFile.ReadMatrix (var ALine, TEXT, FMTOUT, direction:
  string; var KSTP, KPER, NCOL, NROW, ILAY, KS, IMOV, StartRow, EndRow,
  StartColumn, EndColumn: integer; LayerIndex: Integer; var PERTIM, TOTIM,
  SUMTCH, DataValue: double; var NumRows, NumColumns: LongInt; var ADataSet:
  T3DRealList; ReverseValue: boolean);
var
  RowIndex,
  ColumnIndex : integer;
begin
  case rgSourceType.ItemIndex of
  0: // MODFLOW (Head and Drawdown)
     ReadMODFLOWHeader (KSTP, KPER, NCOL, NROW, ILAY,
       PERTIM, TOTIM, TEXT, FMTOUT, ALine);
  1: // MOC3D (Concentrations)
     ReadMOC3DConcentrationHeader (KS, IMOV, KSTP, KPER, SUMTCH, ALine);
  2: // MOC3D (Velocities)
    ReadMOC3DVeolocityHeader (direction, KS, KSTP, KPER, TOTIM, ALine);
  end;
  if (rgSourceType.ItemIndex = 0)
      and
     not ((NCOL = NumColumns)
           and
          (NROW = NumRows)) then
    raise EInvalidGridSize.Create ('Incorrect number of columns or rows'); // if not ((NCOL = NumColumns) and (NROW = NumRows))then
  for RowIndex := 0 to EndRow - StartRow - 1 do
  begin
    for ColumnIndex := 0 to EndColumn - StartColumn - 1 do
    begin
        if not Eof (MFFile) then
        begin
          Read (MFFile, DataValue);
          if ReverseValue then
          begin
            DataValue := -DataValue;
          end;
          ADataSet.Items[ColumnIndex, RowIndex, LayerIndex] := DataValue;
        end
    end;// For ColumnIndex := 0 to NCOL-1 do
  end; // For RowIndex := 0 to NROW-1 do
  Readln (MFFile, ALine);
  if (ALine = '')
      and
     not Eof (MFFile) then
    Readln (MFFile, ALine)
end;


procedure TfrmSelectPostFile.BitBtn2Click (Sender: TObject);
var
  //  MFFile : TextFile;
  ALine            : string;
  KSTP             : integer;
  KPER             : integer;
  PERTIM           : double;
  TOTIM            : double;
  TEXT             : string;
  NCOL             : integer;
  NROW             : integer;
  ILAY             : integer;
  FMTOUT           : string;
  LayerIndex, RowIndex, ColumnIndex      : integer;
  DataValue        : double;
  ADataSet,RowSet,LayerSet         : T3DRealList;
  NumRows,NumColumns       : ANE_INT32;
  layerHandle      : ANE_PTR;
  Name,RowName,LayerName        : string;
  StringtoEvaluate : string;
  RowPosition      : ANE_DOUBLE;
  ColumnPosition   : ANE_DOUBLE;
  Layer            : double;
  KS,IMOV             : integer;
  SUMTCH           : double;
  direction,RowDirection,LayerDirection   : string;
  StartRow,EndRow,StartColumn,EndColumn        : integer;
  StartLayer,EndLayer : integer;
  Index : Integer;
  ReverseX : boolean;
  ReverseY : boolean;
begin
  // triggering event btnOpenDataSet.OnClick

  try
    if OpenDialog1.Execute then
    begin
      if rgSourceType.ItemIndex = 2 then
        begin
          ReverseX := not YPositive;//not cbY.Checked;
          ReverseY := not XPositive;//not cbX.Checked
        end
      else
        begin
          ReverseX := False;
          ReverseY := False
        end;
      AssignFile (MFFile, OpenDialog1.Filename);
      Screen.Cursor := crHourGlass;
      try // try 1
        begin
          Reset (MFFile);
          layerHandle := ANE_LayerGetHandleByName
            (frmMODFLOW.CurrentModelHandle,
            PChar(ModflowTypes.GetGridLayerType.ANE_LayerName));

          ANE_EvaluateStringAtLayer (frmMODFLOW.CurrentModelHandle,
            layerHandle, kPIEInteger, 'NumRows()', @NumRows);

          ANE_EvaluateStringAtLayer (frmMODFLOW.CurrentModelHandle,
            layerHandle, kPIEInteger, 'NumColumns()', @NumColumns);

          if rgSourceType.ItemIndex = 0 then
            begin
              StartRow := 0;
              EndRow := NumRows;
              StartColumn := 0;
              EndColumn := NumColumns;
              StartLayer := 1;
              EndLayer := frmMODFLOW.MODFLOWLayerCount;
            end
          else
            begin
              StartRow := fMOCROW1 (frmMODFLOW.CurrentModelHandle,
                layerHandle, NumRows) - 1;
              EndRow := fMOCROW2 (frmMODFLOW.CurrentModelHandle, layerHandle
                , NumRows);
              StartColumn := fMOCCOL1 (frmMODFLOW.CurrentModelHandle,
                layerHandle, NumColumns) - 1;
              EndColumn := fMOCCOL2 (frmMODFLOW.CurrentModelHandle,
                layerHandle, NumColumns);
              StartLayer := 1;
              EndLayer := frmMODFLOW.MOC3DLayerCount;
            end;

          //            frmMODFLOWPostProcessing.adeLayerNumber.Max := EndLayer;
          frmMODFLOWPostProcessing.comboLayerNumber.Items.Clear;
          for Index := 1 to Endlayer do
            frmMODFLOWPostProcessing.comboLayerNumber.Items.Add (IntToStr (Index));
          frmMODFLOWPostProcessing.comboLayerNumber.ItemIndex := 0;

          for RowIndex := StartRow to EndRow do
          begin
            StringtoEvaluate := 'NthRowPos(' + IntToStr (RowIndex) + ')';

            ANE_EvaluateStringAtLayer (frmMODFLOW.CurrentModelHandle,
              layerHandle, kPIEFloat, PChar (StringtoEvaluate),
              @RowPosition);

            frmMODFLOWPostProcessing.YCoordList.Add (RowPosition)
          end;

          for RowIndex := frmMODFLOWPostProcessing.YCoordList.Count - 1
            downto 1 do
          begin
            frmMODFLOWPostProcessing.YCoordList.Items[RowIndex] :=
                (frmMODFLOWPostProcessing.YCoordList.Items[RowIndex] +
                frmMODFLOWPostProcessing.YCoordList.Items[RowIndex-1]) / 2;
          end;
          frmMODFLOWPostProcessing.YCoordList.Delete (0);

          for ColumnIndex := StartColumn to EndColumn do
            begin
              StringtoEvaluate := 'NthColumnPos(' + IntToStr (ColumnIndex) + ')';

              ANE_EvaluateStringAtLayer (frmMODFLOW.CurrentModelHandle,
                layerHandle, kPIEFloat, PChar (StringtoEvaluate),
                @ColumnPosition);

              frmMODFLOWPostProcessing.XCoordList.Add (ColumnPosition)
            end;

          for ColumnIndex := frmMODFLOWPostProcessing.XCoordList.Count - 1
            downto 1 do
          begin
            frmMODFLOWPostProcessing.XCoordList.Items[ColumnIndex]
              := (frmMODFLOWPostProcessing.XCoordList.Items[ColumnIndex] +
              frmMODFLOWPostProcessing.XCoordList.Items[ColumnIndex-1]) / 2;
          end;
          frmMODFLOWPostProcessing.XCoordList.Delete (0);

          // Create Dummy Layer positions.
          for LayerIndex := StartLayer to EndLayer do
          begin
            Layer := LayerIndex;
            frmMODFLOWPostProcessing.ZCoordList.Add (Layer)
          end;
          Readln (MFFile, ALine);
          while not Eof (MFFile) do
            begin
              ADataSet := T3DRealList.Create
                (frmMODFLOWPostProcessing.XCoordList.Count,
                 frmMODFLOWPostProcessing.YCoordList.Count,
                 EndLayer - StartLayer + 1);

              if rgSourceType.ItemIndex = 2 then
                begin
                  RowSet := T3DRealList.Create
                    (frmMODFLOWPostProcessing.XCoordList.Count,
                     frmMODFLOWPostProcessing.YCoordList.Count,
                     EndLayer - StartLayer + 1);

                  LayerSet := T3DRealList.Create
                    (frmMODFLOWPostProcessing.XCoordList.Count,
                     frmMODFLOWPostProcessing.YCoordList.Count,
                     EndLayer - StartLayer + 1)
                end;

              for LayerIndex := StartLayer - 1 to EndLayer - 1 do
                begin
                  ReadMatrix (ALine, TEXT, FMTOUT, direction, KSTP, KPER,
                    NCOL, NROW, ILAY, KS, IMOV, StartRow, EndRow,
                    StartColumn, EndColumn, LayerIndex, PERTIM, TOTIM,
                    SUMTCH, DataValue, NumRows, NumColumns, ADataSet,
                    ReverseX);

                  if rgSourceType.ItemIndex = 2 then
                    begin
                      ReadMatrix (ALine, TEXT, FMTOUT, Rowdirection, KSTP,
                        KPER, NCOL, NROW, ILAY, KS, IMOV, StartRow, EndRow,
                        StartColumn, EndColumn, LayerIndex, PERTIM, TOTIM,
                        SUMTCH, DataValue, NumRows, NumColumns, RowSet,
                        ReverseY);

                      ReadMatrix (ALine, TEXT, FMTOUT, Layerdirection, KSTP,
                        KPER, NCOL, NROW, ILAY, KS, IMOV, StartRow, EndRow,
                        StartColumn, EndColumn, LayerIndex, PERTIM, TOTIM,
                        SUMTCH, DataValue, NumRows, NumColumns, LayerSet,
                        False)
                    end
                end; //  for LayerIndex := 0 to StrToInt(frmMODFLOW.edNumUnits.Text)-1 do
              case rgSourceType.ItemIndex of
              0: // MODFLOW (Head and Drawdown)
                  Name := Trim (TEXT) + ' Per ' + IntToStr (KPER) + ' TS ' +
                    IntToStr (KSTP) + ' Time ' + FloatToStr (TOTIM);
              1: // MOC3D (Concentrations)
                  Name := 'Concentration, Per ' + IntToStr (KPER) + ' TS ' +
                    IntToStr (KSTP) + ' TrS ' + IntToStr (IMOV) + ' Time: '
                    + FloatToStr (SUMTCH);
              2: // MOC3D (Velocities)
                begin
                  Name := direction + ' Velocity ' + ' Per ' + IntToStr (KPER)
                    + ' TS ' + IntToStr (KSTP) + ' Time ' + FloatToStr (TOTIM);

                  RowName := Rowdirection + ' Velocity ' + ' Per ' +
                    IntToStr (KPER) + ' TS ' + IntToStr (KSTP) + ' Time ' +
                    FloatToStr (TOTIM);

                  LayerName := Layerdirection + ' Velocity ' + ' Per ' +
                    IntToStr (KPER) + ' TS ' + IntToStr (KSTP) + ' Time ' +
                    FloatToStr (TOTIM)
                end;
              end;

              frmMODFLOWPostProcessing.Data.Add (ADataSet, Name);
              frmMODFLOWPostProcessing.rzclDataSets.Items.Add (Name);

              if rgSourceType.ItemIndex = 2 then
                begin
                  frmMODFLOWPostProcessing.Data.Add (RowSet, RowName);
                  frmMODFLOWPostProcessing.rzclDataSets.Items.Add (RowName);

                  frmMODFLOWPostProcessing.Data.Add (LayerSet, LayerName);
                  frmMODFLOWPostProcessing.rzclDataSets.Items.Add (LayerName)
                end
            end
          // while not Eof(OutputFile) do

        end// try 1
      finally
        begin
          CloseFile (MFFile);
          Screen.Cursor := crDefault;
          if frmMODFLOWPostProcessing.rzclDataSets.Items.Count > 0 then
          begin
            ModalResult := mrOK;
            if rgSourceType.ItemIndex = 2 then
            begin
              if frmMODFLOWPostProcessing.rzclDataSets.Items.Count > 2
                then
                begin
                  frmMODFLOWPostProcessing.rzclDataSets.ItemChecked
                    [frmMODFLOWPostProcessing.rzclDataSets.Items.Count - 2]
                    := True;
                  frmMODFLOWPostProcessing.rzclDataSets.ItemChecked
                    [frmMODFLOWPostProcessing.rzclDataSets.Items.Count - 3]
                    := True
                end
            end
            else
            begin
              frmMODFLOWPostProcessing.rzclDataSets.ItemChecked
                [frmMODFLOWPostProcessing.rzclDataSets.Items.Count - 1]
                := True
            end;
          end
          else
          begin
            ModalResult := mrCancel;
            Beep;
            MessageDlg('No data could be read from file', mtError, [mbOK], 0);
          end;
        end
      end
      // try 1 finally

    end // if OpenDialog1.Execute then

  except
    on E: EInvalidGridSize do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
        ModalResult := mrCancel
      end;
    on E: Exception do
      begin
        Beep;
        MessageDlg ('Error reading file. "' + E.Message
          + '" Please make sure that the file was '
          + 'created by the current model.', mtError, [mbOK], 0);
        ModalResult := mrCancel
      end;
  end
end;


function TfrmSelectPostFile.FormHelp (Command: Word; Data: Integer; var CallHelp
  : Boolean) : Boolean;
begin
  // triggering events: frmSelectPostFile.OnHelp;
  // This assigns the help file every time Help is called from frmMODFLOW.

  // AssignHelpFile is a virtual function that can be overridden by
  // descendents to assign a different help file for controls not present
  // in TfrmMODFLOW.
  AssignHelpFile ('MODFLOW.hlp');
  result := True
end;


procedure TfrmSelectPostFile.FormCreate (Sender: TObject);
begin
  ClientHeight := btnSelect.Top + btnSelect.Height + 4;
  ClientWidth := btnSelect.Left + btnSelect.Width + 4
end;
{sc-----------------------------------------------------------------------
  Name:       TfrmSelectPostFile.FormCreate
  Parameters:
     Sender
  Returns:
     -
  Cyclometric Complexity: 1               ,   0 comments in 2 lines = 0%

  Purpose:
   (please describe the routine's purpose here, then add an empty line)

  Date     Coder    CRC Comment
  02/19/99 Tiemann  A0  Initial version!                                 
-----------------------------------------------------------------------sc}


procedure TfrmSelectPostFile.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

end.
