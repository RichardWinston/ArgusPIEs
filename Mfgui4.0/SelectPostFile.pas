unit SelectPostFile;

interface

{SelectPostFile defines the form displayed when someone wants to import
 data from a model for visualization. It also has functions for reading the
 data.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, StdCtrls, ExtCtrls, Buttons, ThreeDRealListUnit, AnePIE;

type
  String16 = string[32];

  EInvalidData = class(Exception);

  TModflowOutputFileType =
    (mofFormattedHeadAndDrawdown,
    mofGWT_Concentration,
    mofGWT_Velocity,
    mofScaledSensitivity,
    mofBinaryHeadAndDrawdownOldFormat,
    mofBinaryIBS_Output,
    mofBinaryHeadAndDrawdownNewFormat,
    mofHUF_Formatted,
    mofMt3dmsConcentration,
    mofBinaryBudgetOldFormat,
    mofBinaryBudgetNewFormat,
    mofSUB_Subsidence,
    mofSUB_CompactionByModelLayer,
    mofSUB_CompactionByInterbedSystem,
    mofSUB_VerticalDisplacementByModelLayer,
    mofSUB_CriticalHeadForNoDelayInterbeds,
    mofSUB_CriticalHeadForelayInterbeds,
    mofHUF_Binary,
    mofSWT_CompactionByInterbedSystem,
    mofSWT_PreconsolidationStressByModelLayer,
    mofSWT_DeltaPreconsolidationStressByModelLayer,
    mofSWT_GeostaticStressByModelLayer,
    mofSWT_DeltaGeostaticStressByModelLayer,
    mofSWT_EffectiveStressByModelLayer,
    mofSWT_DeltaEffectiveStressByModelLayer,
    mofSWT_VoidRatioByInterbedSystem,
    mofSWT_ThickComprSedByInterbedSystem,
    mofSWT_LayerCentElevByModelLayer);

  TfrmSelectPostFile = class(TArgusForm)
    rgSourceType: TRadioGroup;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn3: TBitBtn;
    BitBtn1: TBitBtn;
    btnSelect: TButton;
    procedure rgSourceTypeClick(Sender: TObject); virtual;
    procedure btnSelectClick(Sender: TObject); virtual;
  private
    IBS_Layers: array of integer;
    procedure ReadMatrix(var ALine, TEXT, FMTOUT, direction: string; var KSTP,
      KPER, NCOL, NROW, ILAY, KS, IMOV, StartRow, EndRow, StartColumn,
      EndColumn: integer; LayerIndex: Integer;
      var PERTIM, TOTIM, SUMTCH, DataValue: double; var NumRows,
      NumColumns: LongInt; var ADataSet: T3DRealList; ReverseValue: boolean);
      virtual;
    procedure ReadSensitivityHeader(var KSTP, KPER, ILAY: integer;
      var ALine, ParameterName: string);
    procedure ReadSensitivityMatrix(var ALine: string; var KSTP, KPER,
      ILAY: integer; StartRow, EndRow, StartColumn, EndColumn,
      LayerIndex: Integer; var ADataSet: T3DRealList;
      var ParameterName: string);
    procedure ReadData(RowCount, ColCount, LayerCount: integer;
      WaterTableOK: boolean);
    procedure MyOpen1(UnitNumber: Integer; var ierror: Integer);
    procedure ReadMT3DMS;
    function NewBinaryFormat: boolean;
    procedure ReadBudget;
    procedure ReadModflowData(RowCount, ColCount, LayerCount: integer;
      FileStream: TFileStream);
    procedure AssignWaterTable(ADataSet: T3DRealList);

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
    //      CurrentModelHandle : ANE_PTR;
    XPositive, YPositive: boolean;
    {      procedure AssignHelpFile (FileName: string);
            virtual;
          Procedure Moved (var Message: TWMWINDOWPOSCHANGED);
            message WM_WINDOWPOSCHANGED;   }
        { Public declarations }
  end;

  {var
    frmSelectPostFile: TfrmSelectPostFile;  }

var
  comboSensFormatHelpContext: integer;

resourcestring
  StrWaterTable = 'Water Table';

implementation

uses
  ModflowUnit, PostMODFLOW, Variables, ANECB, MOC3DGridFunctions,
  UtilityFunctions, WriteNameFileUnit, frmMt3dFilesUnit, FlowReaderUnit,
  ReadModflowArrayUnit;

var
  MFFile: TextFile;

{$R *.DFM}

procedure lrxclose(
  var iunit: LongInt
  ); stdcall; external 'ReaArr.dll';

procedure lrxopen(
  var ierror, iunit: LongInt;
  filename: string;
  filenameLength: LongInt
  ); stdcall; external 'ReaArr.dll';

procedure ReadMe(
  var INUNIT, iorror, KSTP, KPER: LongInt;
  var PERTIM, TOTIM: single;
  var NCOL, NROW, ILAY: LongInt;
  var Text: String16;
  TextLength: LongInt
  ); stdcall; external 'ReaArr.dll';

procedure FreeMe; stdcall; external 'ReaArr.dll';

procedure GETVALUE(
  var AVALUE: single;
  var NCOL, NROW: LongInt
  ); stdcall; external 'ReaArr.dll';

procedure lrxclose2(
  var iunit: LongInt
  ); stdcall; external 'ReaArr2.dll';

procedure lrxopen2(
  var ierror, iunit: LongInt;
  filename: string;
  filenameLength: LongInt
  ); stdcall; external 'ReaArr2.dll';

procedure ReadMe2(
  var INUNIT, iorror, KSTP, KPER: LongInt;
  var PERTIM, TOTIM: single;
  var NCOL, NROW, ILAY: LongInt;
  var Text: String16;
  TextLength: LongInt
  ); stdcall; external 'ReaArr2.dll';

procedure FreeMe2; stdcall; external 'ReaArr2.dll';

procedure GETVALUE2(
  var AVALUE: single;
  var NCOL, NROW: LongInt
  ); stdcall; external 'ReaArr2.dll';

procedure TfrmSelectPostFile.rgSourceTypeClick(Sender: TObject);
begin
  // triggering event rgSourceType.OnClick
  case TModflowOutputFileType(rgSourceType.ItemIndex) of
    mofFormattedHeadAndDrawdown: // MODFLOW (Head and Drawdown)
      begin
        OpenDialog1.Filter := 'Formatted Head and Drawdown (*.FHD;*.FDN)|'
          + '*.FHD;*.FDN|Formatted Head (*.FHD)|*.FHD|Formatted Drawdown (*.FDN)|'
          + '*.FDN|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofGWT_Concentration: // MOC3D (Concentrations)
      begin
        if frmMODFLOW.rbMODFLOW2000.Checked or frmModflow.rbModflow2005.Checked then
        begin
          OpenDialog1.Filter := 'MF2K_GWT Concentrations (*.CNA)' +
            '|*.CNA|All Files (*.*)|*.*';
        end
        else
        begin
          OpenDialog1.Filter := 'MOC3D Concentrations (*.CNA)' +
            '|*.CNA|All Files (*.*)|*.*';
        end;
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofGWT_Velocity: // MOC3D (Velocities)
      begin
        if frmMODFLOW.rbMODFLOW2000.Checked or frmModflow.rbModflow2005.Checked then
        begin
          OpenDialog1.Filter := 'MF2K_GWT Velocities (*.VLA)' +
            '|*.VLA|All Files (*.*)|*.*';
        end
        else
        begin
          OpenDialog1.Filter := 'MOC3D Velocities (*.VLA)' +
            '|*.VLA|All Files (*.*)|*.*';
        end;
        frmMODFLOWPostProcessing.rgChartType.Enabled := False;
      end;
    mofScaledSensitivity: // 1% scaled senstiviteis
      begin
        OpenDialog1.Filter := 'Scaled Sensitivities (*' + rsSena + ')' +
          '|*' + rsSena + '|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofBinaryHeadAndDrawdownOldFormat, mofBinaryHeadAndDrawdownNewFormat:
      begin
        OpenDialog1.Filter := 'Binary Head and Drawdown (*.BHD;*.BDN)|'
          + '*.BHD;*.BDN|Binary Head (*.BHD)|*.BHD|Binary Drawdown (*.BDN)|'
          + '*.BDN|'
          + 'All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofBinaryIBS_Output:
      begin
        OpenDialog1.Filter :=
          'All IBS files (*.isc,*.ish,*.iss)|*.isc;*.ish;*.iss|'
          + 'Compaction files (*.isc)|*.isc|'
          + 'Critical head files (*.ish)|*.ish|'
          + 'Subsidence files (*.iss)|*.iss|'
          + 'All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofHUF_Formatted:
      begin
        OpenDialog1.Filter :=
          'Hydrogeologic Unit flow package formatted head files (*.hhd)|*.hhd|'
          + 'All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofHUF_Binary:
      begin
        OpenDialog1.Filter :=
          'Hydrogeologic Unit flow package formatted head files (*.hbh)|*.hbh|'
          + 'All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofMt3dmsConcentration:
      begin
        // do nothing for MT3DMS or budget.
      end;
    mofBinaryBudgetOldFormat, mofBinaryBudgetNewFormat:
      begin
        OpenDialog1.Filter := 'Budget files (*.bud)|*.bud|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
        frmMODFLOWPostProcessing.cbImpDry.Enabled := False;
        frmMODFLOWPostProcessing.cbImpInactive.Enabled := False;
      end;
    mofSUB_Subsidence:
      begin
        OpenDialog1.Filter := 'Subsidence File (*.subo1, *.swt_out1)|*.subo1;*.swt_out1|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSUB_CompactionByModelLayer:
      begin
        OpenDialog1.Filter := 'Compaction by Model Layer File (*.subo2, *.swt_out2)|*.subo2;*.swt_out2|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSUB_CompactionByInterbedSystem:
      begin
        OpenDialog1.Filter := 'Compaction by Interbed File (*.subo3)|*.subo3|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSUB_VerticalDisplacementByModelLayer:
      begin
        OpenDialog1.Filter := 'Vertical Displacement File (*.subo4, *.swt_out4)|*.subo4;*.swt_out4|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSUB_CriticalHeadForNoDelayInterbeds:
      begin
        OpenDialog1.Filter := 'Critical Head (no-delay( File (*.subo5)|*.subo5|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSUB_CriticalHeadForelayInterbeds:
      begin
        OpenDialog1.Filter := 'Critical Head (Delay( File (*.subo6)|*.subo6|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSWT_CompactionByInterbedSystem:
      begin
        OpenDialog1.Filter := 'Compaction by Interbed File (*.swt_out3)|*.swt_out3|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSWT_PreconsolidationStressByModelLayer:
      begin
        OpenDialog1.Filter := 'Preconsolidation Stress File (*.swt_out5)|*.swt_out5|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSWT_DeltaPreconsolidationStressByModelLayer:
      begin
        OpenDialog1.Filter := 'Change in Preconsolidation Stress File (*.swt_out6)|*.swt_out6|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSWT_GeostaticStressByModelLayer:
      begin
        OpenDialog1.Filter := 'Geostatic Stress File (*.swt_out7)|*.swt_out7|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSWT_DeltaGeostaticStressByModelLayer:
      begin
        OpenDialog1.Filter := 'Change in Geostatic Stress File (*.swt_out8)|*.swt_out8|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSWT_EffectiveStressByModelLayer:
      begin
        OpenDialog1.Filter := 'Effective Stress File (*.swt_out9)|*.swt_out9|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSWT_DeltaEffectiveStressByModelLayer:
      begin
        OpenDialog1.Filter := 'Change in Effective Stress File (*.swt_out10)|*.swt_out10|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSWT_VoidRatioByInterbedSystem:
      begin
        OpenDialog1.Filter := 'Void Ratio File (*.swt_out11)|*.swt_out11|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSWT_ThickComprSedByInterbedSystem:
      begin
        OpenDialog1.Filter := 'Thickness of Compressible Sediments File (*.swt_out12)|*.swt_out12|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
    mofSWT_LayerCentElevByModelLayer:
      begin
        OpenDialog1.Filter := 'Layer-Center Elevation File (*.swt_out13)|*.swt_out13|All Files (*.*)|*.*';
        frmMODFLOWPostProcessing.rgChartType.Enabled := True;
      end;
  else
    Assert(False);
  end
end;

function GetStringBetween(var AString: string; Before, After: string): string;
var
  Position: integer;
begin
  result := AString;
  if Before <> '' then
  begin
    result := Copy(AString,
      Pos(Before, AString) + Length(Before),
      Length(AString));
    AString := result;
  end;

  if After <> '' then
  begin
    Position := Pos(After, result) - 1;
    if Position = -1 then
    begin
      Position := Length(result);
    end;
    result := Copy(result, 1, Position);
    AString := Copy(AString, Length(result) + 1, Length(AString));
  end;

  result := Trim(result);
  AString := Trim(AString);
end;

procedure ReadMODFLOW2000Header(var KSTP, KPER, NCOL, NROW, ILAY: integer; var
  PERTIM, TOTIM: double; var TEXT, FMTOUT: string; ALine: string);
begin
  TEXT := GetStringBetween(ALine, '', ';');
  KPER := StrToInt(GetStringBetween(ALine, 'Stress Period:', ';'));
  KSTP := StrToInt(GetStringBetween(ALine, 'Time Step:', ';'));
  PERTIM := InternationalStrToFloat(GetStringBetween(ALine, 'Period Time:',
    ';'));
  TOTIM := InternationalStrToFloat(GetStringBetween(ALine, 'Total Time:', ';'));
  NCOL := StrToInt(GetStringBetween(ALine, 'Number of Columns:', ';'));
  NROW := StrToInt(GetStringBetween(ALine, 'Number of Rows:', ';'));
  ILAY := StrToInt(GetStringBetween(ALine, 'Layer:', ''));
end;

procedure ReadMODFLOWHeader(var KSTP, KPER, NCOL, NROW, ILAY: integer; var
  PERTIM, TOTIM: double; var TEXT, FMTOUT: string; ALine: string);
begin
  // called by btnOpenDataSetClick;
  if Pos(';', ALine) > 0 then
  begin
    ReadMODFLOW2000Header(KSTP, KPER, NCOL, NROW, ILAY, PERTIM, TOTIM, TEXT,
      FMTOUT, ALine);
  end
  else
  begin
    try
      KSTP := StrToInt(Copy(ALine, 2, 5))
    except
      on EConvertError do
        KSTP := -1
    end;

    try
      KPER := StrToInt(Copy(ALine, 7, 5))
    except
      on EConvertError do
        KPER := -1
    end;

    try
      PERTIM := InternationalStrToFloat(Copy(ALine, 12, 15))
    except
      on EConvertError do
        PERTIM := -1
    end;

    try
      TOTIM := InternationalStrToFloat(Copy(ALine, 27, 15))
    except
      on EConvertError do
        TOTIM := -1
    end;

    TEXT := Copy(ALine, 43, 16);

    try
      NCOL := StrToInt(Copy(ALine, 59, 6))
    except
      on EConvertError do
        NCOL := -1
    end;

    try
      NROW := StrToInt(Copy(ALine, 65, 6))
    except
      on EConvertError do
        NROW := -1
    end;

    try
      ILAY := StrToInt(Copy(ALine, 71, 6))
    except
      on EConvertError do
        ILAY := -1
    end;

    FMTOUT := Copy(ALine, 77, 20)
  end;
end;

procedure ReadDoublePorosityLayer(var KS: integer; ALine: string);
begin
  try
    KS := StrToInt(Copy(ALine, 14, 13))
  except
    on EConvertError do
      KS := -1
  end;
end;

function ReadMOC3DConcentrationHeader(var KS, IMOV, KSTP, KPER: integer; var
  SUMTCH: double; ALine: string): boolean;
begin
  // called by btnOpenDataSetClick;
  result := Pos('DOUBLE POROSITY', ALine) > 0;
  if result then
  begin
    KS := -1;
  end
  else
  begin
    try
      KS := StrToInt(Copy(ALine, 42, 4))
    except
      on EConvertError do
        KS := -1
    end;
  end;

  if result then
  begin
    try
      IMOV := StrToInt(Copy(ALine, 59, 5))
    except
      on EConvertError do
        IMOV := -1
    end;
  end
  else
  begin
    try
      IMOV := StrToInt(Copy(ALine, 53, 5))
    except
      on EConvertError do
        IMOV := -1
    end;
  end;

  if result then
  begin
    try
      KSTP := StrToInt(Copy(ALine, 71, 5))
    except
      on EConvertError do
        KSTP := -1
    end;
  end
  else
  begin
    try
      KSTP := StrToInt(Copy(ALine, 65, 5))
    except
      on EConvertError do
        KSTP := -1
    end;
  end;

  if result then
  begin
    try
      KPER := StrToInt(Copy(ALine, 83, 5))
    except
      on EConvertError do
        KPER := -1
    end;
  end
  else
  begin
    try
      KPER := StrToInt(Copy(ALine, 77, 5))
    except
      on EConvertError do
        KPER := -1
    end;
  end;

  if result then
  begin
    try
      SUMTCH := InternationalStrToFloat(Copy(ALine, 97, 10))
    except
      on EConvertError do
        SUMTCH := -1
    end;
  end
  else
  begin
    try
      SUMTCH := InternationalStrToFloat(Copy(ALine, 91, 10))
    except
      on EConvertError do
        SUMTCH := -1
    end
  end;

end;

procedure ReadMOC3DVeolocityHeader(var direction: string; var KS, KSTP, KPER:
  integer; var TOTIM: double; ALine: string);
begin
  // called by btnOpenDataSetClick;
  direction := Trim(Copy(ALine, 8, 8));

  try
    KS := StrToInt(Copy(ALine, 54, 4))
  except
    on EConvertError do
      KS := -1
  end;

  try
    KSTP := StrToInt(Copy(ALine, 65, 5))
  except
    on EConvertError do
      KSTP := -1
  end;

  try
    KPER := StrToInt(Copy(ALine, 77, 5))
  except
    on EConvertError do
      KPER := -1
  end;

  try
    TOTIM := InternationalStrToFloat(Copy(ALine, 90, 15))
  except
    on EConvertError do
      TOTIM := -1
  end
end;

procedure TfrmSelectPostFile.ReadSensitivityMatrix(var ALine: string;
  var KSTP, KPER, ILAY: integer; StartRow, EndRow, StartColumn, EndColumn,
  LayerIndex: Integer; var ADataSet: T3DRealList; var ParameterName: string);
var
  RowIndex,
    ColumnIndex: integer;
  RowNumber: integer;
  DataValue: double;
  BadLine: string;
begin
  ReadSensitivityHeader(KSTP, KPER, ILAY, ALine, ParameterName);

  for RowIndex := 0 to EndRow - StartRow - 1 do
  begin
    Read(MFFile, RowNumber);
    for ColumnIndex := 0 to EndColumn - StartColumn - 1 do
    begin
      if not Eof(MFFile) then
      begin
        try
          Read(MFFile, DataValue);
        except on Exception do
          begin
            ReadLn(MFFile, BadLine);
            AssignHelpFile('MODFLOW.chm');
            Application.HelpFile := HelpFile;
            MessageDlg('Error reading parameter ' + ParameterName
              + ' in stress period ' + IntToStr(KPER)
              + ', time step ' + IntToStr(KSTP)
              + ', layer ' + IntToStr(ILAY)
              + ', row ' + IntToStr(RowNumber)
              + ', column ' + IntToStr(ColumnIndex + 1)
              + '. Check that the format you have used to print the'
              + ' sensitivities can print them properly.',
              mtError, [mbOK, mbHelp], comboSensFormatHelpContext);
            raise;
          end;
        end;
        ADataSet.Items[ColumnIndex, RowIndex, LayerIndex] := DataValue;
      end
    end; // For ColumnIndex := 0 to NCOL-1 do
  end; // For RowIndex := 0 to NROW-1 do

  Readln(MFFile, ALine);
  if (ALine = '') and not Eof(MFFile) then
  begin
    Readln(MFFile, ALine)
  end;

end;

procedure TfrmSelectPostFile.ReadSensitivityHeader(var KSTP, KPER, ILAY:
  integer;
  var ALine, ParameterName: string);
var
  priorLine: string;
  BeforePos, AfterPos: integer;
  SearchString: string;
  Found: boolean;

begin
  // Get and parse the header line
  Found := False;
  while not Found do
  begin
    if Eof(MFFile) then
    begin
      raise Exception.Create('Error reading 1% Sensitivity file');
    end;

    Readln(MFFile, ALine);
    if Pos('-------------', ALine) > 0 then
    begin
      SearchString := 'SENS. IN LAYER';
      BeforePos := 1;
      AfterPos := Pos(SearchString, priorLine);
      ParameterName := Trim(Copy(priorLine, BeforePos, AfterPos - 1));

      BeforePos := AfterPos + Length(SearchString);
      SearchString := 'AT END OF TIME STEP';
      AfterPos := Pos(SearchString, priorLine);
      ILAY := StrToInt(Trim(Copy(priorLine, BeforePos, AfterPos - BeforePos)));

      BeforePos := AfterPos + Length(SearchString);
      SearchString := 'IN STRESS PERIOD';
      AfterPos := Pos(SearchString, priorLine);
      KSTP := StrToInt(Trim(Copy(priorLine, BeforePos, AfterPos - BeforePos)));

      BeforePos := AfterPos + Length(SearchString);
      AfterPos := Length(priorLine);
      KPER := StrToInt(Trim(Copy(priorLine, BeforePos, AfterPos)));

      Found := True;
    end
    else
    begin
      priorLine := ALine;
    end;
  end;
  Found := False;

  // skip lines up to beginning of data.
  while not Found do
  begin
    Readln(MFFile, ALine);
    if Pos('...........', ALine) > 0 then
    begin
      Found := True;
    end;
  end;
end;

procedure TfrmSelectPostFile.ReadMatrix(var ALine, TEXT, FMTOUT, direction:
  string; var KSTP, KPER, NCOL, NROW, ILAY, KS, IMOV, StartRow, EndRow,
  StartColumn, EndColumn: integer; LayerIndex: Integer; var PERTIM, TOTIM,
  SUMTCH, DataValue: double; var NumRows, NumColumns: LongInt; var ADataSet:
  T3DRealList; ReverseValue: boolean);
var
  RowIndex,
    ColumnIndex: integer;
  MOC3DConcentration: boolean;
  Splitter: TStringList;
  FileLine: string;
  SplitIndex: integer;
begin
  Splitter := TStringList.Create;
  try
    SplitIndex := 0;
    Splitter.Delimiter := ' ';
    case TModflowOutputFileType(rgSourceType.ItemIndex) of
      mofFormattedHeadAndDrawdown, mofHUF_Formatted: // MODFLOW (Head and Drawdown)
        begin
          ReadMODFLOWHeader(KSTP, KPER, NCOL, NROW, ILAY,
            PERTIM, TOTIM, TEXT, FMTOUT, ALine);
          //      result := False;
        end;
      mofGWT_Concentration: // MOC3D (Concentrations)
        begin
          MOC3DConcentration := ReadMOC3DConcentrationHeader(KS, IMOV, KSTP, KPER,
            SUMTCH, ALine);
          if MOC3DConcentration then
          begin
            Readln(MFFile, ALine);
            ReadDoublePorosityLayer(KS, ALine);
          end;
        end;
      mofGWT_Velocity: // MOC3D (Velocities)
        begin
          ReadMOC3DVeolocityHeader(direction, KS, KSTP, KPER, TOTIM, ALine);
          //      result := False;
        end;
    else
      begin
        Assert(False);
      end;
    end;
    if (TModflowOutputFileType(rgSourceType.ItemIndex)
      = mofFormattedHeadAndDrawdown)
      and not ((NCOL = NumColumns)
      and (NROW = NumRows)) then
      raise EInvalidGridSize.Create('Incorrect number of columns or rows');
        // if not ((NCOL = NumColumns) and (NROW = NumRows))then
    for RowIndex := 0 to EndRow - StartRow - 1 do
    begin
      for ColumnIndex := 0 to EndColumn - StartColumn - 1 do
      begin
        if not Eof(MFFile) then
        begin
          if (Splitter.Count = 0) or (SplitIndex >= Splitter.Count) then
          begin
            Readln(MFFile, FileLine);
            Splitter.DelimitedText := FileLine;
            SplitIndex := 0;
          end;
//          Read(MFFile, DataValue);
          DataValue := FortranStrToFloat(Splitter[SplitIndex]);
          Inc(SplitIndex);
          if ReverseValue then
          begin
            DataValue := -DataValue;
          end;
          ADataSet.Items[ColumnIndex, RowIndex, LayerIndex] := DataValue;
        end
      end; // For ColumnIndex := 0 to NCOL-1 do
    end; // For RowIndex := 0 to NROW-1 do
    if LayerIndex = ADataSet.ZCount-1 then
    begin
      ADataSet.Cache;
    end;
    Readln(MFFile, ALine);
    if (ALine = '')
      and
      not Eof(MFFile) then
      Readln(MFFile, ALine)
  finally
    Splitter.Free;
  end;
end;

procedure TfrmSelectPostFile.ReadBudget;
var
  NCOL, NROW, NLAY: ANE_INT32;
  LayerName: string;
  layerHandle: ANE_PTR;
  StartRow, EndRow, StartColumn, EndColumn: integer;
  RowIndex, ColumnIndex: integer;
  StringtoEvaluate: string;
  STR: ANE_STR;
  RowPosition: ANE_DOUBLE;
  ColumnPosition: ANE_DOUBLE;
  LayerIndex: integer;
  FileName: string;
  FileNROW, FileNCOL, FileNLAY : longint;
  ABudgetProgram: TBudgetProgram;
begin
  // Get grid.
  LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
  LayerHandle := GetLayerHandle(CurrentModelHandle, LayerName);
  GetNumRowsCols(CurrentModelHandle, LayerHandle, NROW, NCOL);
  NLAY := frmMODFLOW.MODFLOWLayerCount;

  StartRow := 0;
  EndRow := NROW;
  StartColumn := 0;
  EndColumn := NCOL;

  for RowIndex := StartRow to EndRow do
  begin
    StringtoEvaluate := 'NthRowPos(' + IntToStr(RowIndex) + ')';

    GetMem(STR, Length(StringToEvaluate) + 1);
    try
      StrPCopy(STR, StringToEvaluate);
      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
        layerHandle, kPIEFloat, STR,
        @RowPosition);
      ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
    finally
      FreeMem(STR);
    end;

    frmMODFLOWPostProcessing.YCoordList.Add(RowPosition)
  end;

  for RowIndex := frmMODFLOWPostProcessing.YCoordList.Count - 1
    downto 1 do
  begin
    frmMODFLOWPostProcessing.YCoordList.Items[RowIndex] :=
      (frmMODFLOWPostProcessing.YCoordList.Items[RowIndex] +
      frmMODFLOWPostProcessing.YCoordList.Items[RowIndex - 1]) / 2;
  end;
  frmMODFLOWPostProcessing.YCoordList.Delete(0);

  for ColumnIndex := StartColumn to EndColumn do
  begin
    StringtoEvaluate := 'NthColumnPos(' + IntToStr(ColumnIndex) + ')';

    GetMem(STR, Length(StringToEvaluate) + 1);
    try
      StrPCopy(STR, StringToEvaluate);
      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
        layerHandle, kPIEFloat, STR,
        @ColumnPosition);
      ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
    finally
      FreeMem(STR);
    end;

    frmMODFLOWPostProcessing.XCoordList.Add(ColumnPosition)
  end;

  for ColumnIndex := frmMODFLOWPostProcessing.XCoordList.Count - 1
    downto 1 do
  begin
    frmMODFLOWPostProcessing.XCoordList.Items[ColumnIndex]
      := (frmMODFLOWPostProcessing.XCoordList.Items[ColumnIndex] +
      frmMODFLOWPostProcessing.XCoordList.Items[ColumnIndex - 1]) / 2;
  end;
  frmMODFLOWPostProcessing.XCoordList.Delete(0);

  for LayerIndex := 1 to NLAY do
  begin
    frmMODFLOWPostProcessing.ZCoordList.Add(LayerIndex);
    frmMODFLOWPostProcessing.clLayerNumber.Items.Add(IntToStr(LayerIndex));
  end;
  frmMODFLOWPostProcessing.clLayerNumber.Checked[0] := True;

  if OpenDialog1.Execute then
  begin
    FileName := OpenDialog1.FileName;
  end
  else
  begin
    Exit;
  end;
  ABudgetProgram := bpModflow2000;
  case TModflowOutputFileType(rgSourceType.ItemIndex) of
    mofBinaryBudgetOldFormat:
      begin
        ABudgetProgram := bpModflow96;
      end;
    mofBinaryBudgetNewFormat:
      begin
        ABudgetProgram := bpModflow2000;
      end;
  else Assert(False);
  end;
  frmMODFLOWPostProcessing.BudgetProgram := ABudgetProgram;

  ReadDataSetNames(FileName, frmMODFLOWPostProcessing.clDataSets.Items,
    FileNCOL, FileNROW, FileNLAY, ABudgetProgram);
  if (FileNCOL <> NCOL) or (FileNROW <> NROW) or (Abs(FileNLAY) <> NLAY) then
  begin
    Beep;
    MessageDlg('Error: The number of columns, rows, or layers in the budget '
      + 'file does not match the number in the model.', mtError, [mbOK], 0);
    Exit;
  end;

  if frmMODFLOWPostProcessing.clDataSets.Items.Count = 0 then
  begin
    Exit;
  end;
  frmMODFLOWPostProcessing.clDataSets.Checked[
    frmMODFLOWPostProcessing.clDataSets.Items.Count-1] := True;

  frmMODFLOWPostProcessing.BudgetFile := True;
  frmMODFLOWPostProcessing.BudgetFileName := FileName;
  ModalResult := mrOK;
end;

procedure TfrmSelectPostFile.ReadMT3DMS;
var
  NCOL, NROW, NLAY: ANE_INT32;
  LayerName: string;
  layerHandle: ANE_PTR;
  StartRow, EndRow, StartColumn, EndColumn: integer;
  RowIndex, ColumnIndex: integer;
  StringtoEvaluate: string;
  STR: ANE_STR;
  RowPosition: ANE_DOUBLE;
  ColumnPosition: ANE_DOUBLE;
  ADataSet: T3DRealList;
  DataSetIndex: integer;
  Name: string;
begin
  // Get grid.
  LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
  LayerHandle := GetLayerHandle(CurrentModelHandle, LayerName);
  GetNumRowsCols(CurrentModelHandle, LayerHandle, NROW, NCOL);
  NLAY := frmMODFLOW.MODFLOWLayerCount;

  StartRow := 0;
  EndRow := NROW;
  StartColumn := 0;
  EndColumn := NCOL;

  for RowIndex := StartRow to EndRow do
  begin
    StringtoEvaluate := 'NthRowPos(' + IntToStr(RowIndex) + ')';

    GetMem(STR, Length(StringToEvaluate) + 1);
    try
      StrPCopy(STR, StringToEvaluate);
      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
        layerHandle, kPIEFloat, STR,
        @RowPosition);
      ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
    finally
      FreeMem(STR);
    end;

    frmMODFLOWPostProcessing.YCoordList.Add(RowPosition)
  end;

  for RowIndex := frmMODFLOWPostProcessing.YCoordList.Count - 1
    downto 1 do
  begin
    frmMODFLOWPostProcessing.YCoordList.Items[RowIndex] :=
      (frmMODFLOWPostProcessing.YCoordList.Items[RowIndex] +
      frmMODFLOWPostProcessing.YCoordList.Items[RowIndex - 1]) / 2;
  end;
  frmMODFLOWPostProcessing.YCoordList.Delete(0);

  for ColumnIndex := StartColumn to EndColumn do
  begin
    StringtoEvaluate := 'NthColumnPos(' + IntToStr(ColumnIndex) + ')';

    GetMem(STR, Length(StringToEvaluate) + 1);
    try
      StrPCopy(STR, StringToEvaluate);
      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
        layerHandle, kPIEFloat, STR,
        @ColumnPosition);
      ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
    finally
      FreeMem(STR);
    end;

    frmMODFLOWPostProcessing.XCoordList.Add(ColumnPosition)
  end;

  for ColumnIndex := frmMODFLOWPostProcessing.XCoordList.Count - 1
    downto 1 do
  begin
    frmMODFLOWPostProcessing.XCoordList.Items[ColumnIndex]
      := (frmMODFLOWPostProcessing.XCoordList.Items[ColumnIndex] +
      frmMODFLOWPostProcessing.XCoordList.Items[ColumnIndex - 1]) / 2;
  end;
  frmMODFLOWPostProcessing.XCoordList.Delete(0);

  frmMODFLOWPostProcessing.ZCoordList.Add(1);

  // Get data values.
  Application.CreateForm(TfrmMt3dFiles, frmMt3dFiles);
  try
    frmMt3dFiles.CurrentModelHandle := CurrentModelHandle;
    frmMt3dFiles.NROW := NROW;
    frmMt3dFiles.NCOL := NCOL;
    frmMt3dFiles.NLAY := NLAY;
    if frmMt3dFiles.ShowModal = mrOK then
    begin
      for DataSetIndex := 0 to frmMt3dFiles.DataSetNames.Count - 1 do
      begin
        Name := frmMt3dFiles.DataSetNames[DataSetIndex];
        ADataSet := T3DRealList.Create
          (frmMODFLOWPostProcessing.XCoordList.Count,
          frmMODFLOWPostProcessing.YCoordList.Count, 1);

        try
          for RowIndex := 0 to NROW - 1 do
          begin
            for ColumnIndex := 0 to NCOL - 1 do
            begin
              ADataSet.Items[ColumnIndex, RowIndex, 0] :=
                frmMt3dFiles.Values[DataSetIndex, ColumnIndex, RowIndex];
            end; // For ColumnIndex := 0 to NCOL-1 do
          end; // For RowIndex := 0 to NROW-1 do
          ADataSet.Cache;
        except
          ADataSet.Free;
          raise;
        end;
        frmMODFLOWPostProcessing.Data.Add(ADataSet, Name);
        frmMODFLOWPostProcessing.clDataSets.Items.Add(Name);
        frmMODFLOWPostProcessing.clDataSets.Checked[DataSetIndex] := True;

      end;
      frmMODFLOWPostProcessing.clLayerNumber.Items.Clear;
      frmMODFLOWPostProcessing.clLayerNumber.Items.Add
        (IntToStr(frmMt3dFiles.seLayer.Value));
      frmMODFLOWPostProcessing.clLayerNumber.Checked[0] := True;
      ;
    end;
  finally
    frmMt3dFiles.Free;
  end;

  if frmMODFLOWPostProcessing.clDataSets.Items.Count > 0 then
  begin
    ModalResult := mrOK;
  end;

end;

procedure TfrmSelectPostFile.btnSelectClick(Sender: TObject);
var
  //  MFFile : TextFile;
  ALine: string;
  KSTP: integer;
  KPER: integer;
  PERTIM: double;
  TOTIM: double;
  TEXT: string;
  NCOL: integer;
  NROW: integer;
  ILAY: integer;
  FMTOUT: string;
  LayerIndex, RowIndex, ColumnIndex: integer;
  DataValue: double;
  ADataSet, RowSet, LayerSet, DoublePorositySet: T3DRealList;
  NumRows, NumColumns: ANE_INT32;
  layerHandle: ANE_PTR;
  Name, RowName, LayerName, DoublePorosityName: string;
  StringtoEvaluate: string;
  RowPosition: ANE_DOUBLE;
  ColumnPosition: ANE_DOUBLE;
  Layer: double;
  KS, IMOV: integer;
  SUMTCH: double;
  direction, RowDirection, LayerDirection: string;
  StartRow, EndRow, StartColumn, EndColumn: integer;
  StartLayer, EndLayer: integer;
  Index, IBSIndex: Integer;
  ReverseX: boolean;
  ReverseY: boolean;
  ParameterName: string;
  UnitIndex, DisIndex: integer;
  FileOpened: boolean;
  STR: ANE_STR;
  FileStream: TFileStream;
  WaterTableOK: Boolean;
  FileExt: string;
  ColIndex: Integer;
//  ANE_LayerName: ANE_STR;
begin
  // triggering event btnOpenDataSet.OnClick
  try
    // Special procedures are used for reading MF2000 budget files and
    // MT3DMS files.
    if TModflowOutputFileType(rgSourceType.ItemIndex) in
      [mofBinaryBudgetOldFormat, mofBinaryBudgetNewFormat] then
    begin
      ReadBudget;
      Exit;
    end
    else if TModflowOutputFileType(rgSourceType.ItemIndex) =
      mofMt3dmsConcentration then
    begin
      ReadMT3DMS;
      Exit;
    end;
    // Select the file to read.
    OpenDialog1.InitialDir := GetCurrentDir;
    if OpenDialog1.Execute then
    begin
      // test that the file is valid.
      If not FileExists(OpenDialog1.FileName) then
      begin
        Beep;
        MessageDlg(OpenDialog1.FileName + ' does not exist.', mtError,
          [mbOK], 0);
        Exit;
      end;
      if TModflowOutputFileType(rgSourceType.ItemIndex)
        in [mofBinaryIBS_Output,
        mofBinaryHeadAndDrawdownNewFormat,
        mofSUB_Subsidence, mofSUB_CompactionByModelLayer,
        mofSUB_CompactionByInterbedSystem,
        mofSUB_VerticalDisplacementByModelLayer,
        mofSUB_CriticalHeadForNoDelayInterbeds,
        mofSUB_CriticalHeadForelayInterbeds,
        mofSWT_CompactionByInterbedSystem,
        mofSWT_PreconsolidationStressByModelLayer,
        mofSWT_DeltaPreconsolidationStressByModelLayer,
        mofSWT_GeostaticStressByModelLayer,
        mofSWT_DeltaGeostaticStressByModelLayer,
        mofSWT_EffectiveStressByModelLayer,
        mofSWT_DeltaEffectiveStressByModelLayer,
        mofSWT_VoidRatioByInterbedSystem,
        mofSWT_ThickComprSedByInterbedSystem,
        mofSWT_LayerCentElevByModelLayer] then
      begin
        // MODFLOW (Binary IBS Files)
        // MODFLOW (Binary  Head and Drawdown) (MODFLOW-2000 v.1.2 or later)
        // MODFLOW SUB or SWT Packages Subsidence
        // MODFLOW SUB or SWT Packages Compaction by Model Layer
        // MODFLOW SUB Package Compaction by Interbed System
        // MODFLOW SUB Package Vertical Displacement by Model Layer
        // MODFLOW SUB Package Critical Head for No-delay Interbeds
        // MODFLOW SUB Package Critical Head for Delay Interbeds
        // MODFLOW SWT Package Compaction by Interbed System

        // For binary files, test that the file size is greater than 0.
        AssignFile(MFFile, OpenDialog1.Filename);
        try
          Reset(MFFile);
          if FileSize(MFFile) <= 0 then
          begin
            Beep;
            MessageDlg(OpenDialog1.FileName + ' contains no data.', mtWarning,
              [mbOK], 0);
            Exit;
          end;
        finally
          CloseFile(MFFile);
        end;
      end;
      // special handling for velocities.
      if TModflowOutputFileType(rgSourceType.ItemIndex) = mofGWT_Velocity then
      begin
        ReverseX := not YPositive;
        ReverseY := not XPositive;
      end
      else
      begin
        ReverseX := False;
        ReverseY := False
      end;
      // Open the file if it is a text file.
      FileOpened := False;
      if TModflowOutputFileType(rgSourceType.ItemIndex) in
        [mofFormattedHeadAndDrawdown, mofGWT_Concentration, mofGWT_Velocity,
        mofScaledSensitivity, mofHUF_Formatted, mofMt3dmsConcentration,
        mofBinaryBudgetOldFormat, mofBinaryBudgetNewFormat] then
      begin
        AssignFile(MFFile, OpenDialog1.Filename);
        FileOpened := True;
      end;

      FileStream := nil;
      if TModflowOutputFileType(rgSourceType.ItemIndex) in
        [mofSWT_GeostaticStressByModelLayer,
        mofSWT_DeltaGeostaticStressByModelLayer,
        mofSWT_EffectiveStressByModelLayer,
        mofSWT_DeltaEffectiveStressByModelLayer,
        mofSWT_VoidRatioByInterbedSystem,
        mofSWT_ThickComprSedByInterbedSystem,
        mofSWT_LayerCentElevByModelLayer] then
      begin
        FileStream := TFileStream.Create(OpenDialog1.Filename,
          fmOpenRead or fmShareDenyWrite);
      end;

      Screen.Cursor := crHourGlass;
      try // try 1
        begin
          if FileOpened then
          begin
            Reset(MFFile);
          end;
          // Get the size of the grid and the number of layers of data.
          LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
          LayerHandle := GetLayerHandle(frmMODFLOW.CurrentModelHandle,
            LayerName);

          ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
            layerHandle, kPIEInteger, 'NumRows()', @NumRows);

          ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
            layerHandle, kPIEInteger, 'NumColumns()', @NumColumns);

          EndLayer := -1;
          StartLayer := -1;
          case TModflowOutputFileType(rgSourceType.ItemIndex) of
            mofFormattedHeadAndDrawdown,
            mofScaledSensitivity,
            mofBinaryHeadAndDrawdownOldFormat,
            mofBinaryHeadAndDrawdownNewFormat,
            mofSUB_CompactionByModelLayer,
            mofSUB_VerticalDisplacementByModelLayer,
            mofSWT_PreconsolidationStressByModelLayer,
            mofSWT_DeltaPreconsolidationStressByModelLayer,
            mofSWT_GeostaticStressByModelLayer,
            mofSWT_DeltaGeostaticStressByModelLayer,
            mofSWT_EffectiveStressByModelLayer,
            mofSWT_DeltaEffectiveStressByModelLayer,
            mofSWT_LayerCentElevByModelLayer:
            begin
              // Formatted head and drawdown
              // scaled sensitivities
              // binary head and drawdown ( <= MF2k 1.2)
              // binary head and drawdown ( > MF2k 1.2)
              // compaction by model layer
              // vertical displacement by model layer
              StartRow := 0;
              EndRow := NumRows;
              StartColumn := 0;
              EndColumn := NumColumns;
              StartLayer := 1;
              EndLayer := frmMODFLOW.MODFLOWLayerCount;
            end;
            mofGWT_Concentration, mofGWT_Velocity:
            begin
              // MOC3D or GWT concentrations and velocities
              StartRow := fMOCROW1(frmMODFLOW.CurrentModelHandle,
                layerHandle, NumRows) - 1;
              EndRow := fMOCROW2(frmMODFLOW.CurrentModelHandle, layerHandle
                , NumRows);
              StartColumn := fMOCCOL1(frmMODFLOW.CurrentModelHandle,
                layerHandle, NumColumns) - 1;
              EndColumn := fMOCCOL2(frmMODFLOW.CurrentModelHandle,
                layerHandle, NumColumns);
              StartLayer := 1;
              EndLayer := frmMODFLOW.MOC3DLayerCount;
            end;
            mofBinaryIBS_Output:
            begin
              // binary IBS files
              StartRow := 0;
              EndRow := NumRows;
              StartColumn := 0;
              EndColumn := NumColumns;
              StartLayer := 1;
              EndLayer := frmMODFLOW.IBSLayerCount;
            end;
            mofHUF_Formatted, mofHUF_Binary:
            begin
              // HUF formatted head file
              StartRow := 0;
              EndRow := NumRows;
              StartColumn := 0;
              EndColumn := NumColumns;
              StartLayer := 1;
              EndLayer := frmMODFLOW.framHUF1.dgHufUnits.RowCount - 1;
            end;
            mofSUB_Subsidence:
            begin
              // Subsidence
              StartRow := 0;
              EndRow := NumRows;
              StartColumn := 0;
              EndColumn := NumColumns;
              StartLayer := 1;
              EndLayer := 1;
            end;
            mofSUB_CompactionByInterbedSystem:
            begin
              // compaction by interbed system
              StartRow := 0;
              EndRow := NumRows;
              StartColumn := 0;
              EndColumn := NumColumns;
              StartLayer := 1;
              EndLayer := frmMODFLOW.SubNDB + frmMODFLOW.SubNNDB;
            end;
            mofSUB_CriticalHeadForNoDelayInterbeds:
            begin
              // critical head for no-delay interbeds
              StartRow := 0;
              EndRow := NumRows;
              StartColumn := 0;
              EndColumn := NumColumns;
              StartLayer := 1;
              EndLayer := frmMODFLOW.SubNNDB;
            end;
            mofSUB_CriticalHeadForelayInterbeds:
            begin
              // critical head for delay interbeds
              StartRow := 0;
              EndRow := NumRows;
              StartColumn := 0;
              EndColumn := NumColumns;
              StartLayer := 1;
              EndLayer := frmMODFLOW.SubNDB;
            end;
            mofSWT_CompactionByInterbedSystem,
              mofSWT_VoidRatioByInterbedSystem,
              mofSWT_ThickComprSedByInterbedSystem:
            begin
              // compaction by interbed system
              StartRow := 0;
              EndRow := NumRows;
              StartColumn := 0;
              EndColumn := NumColumns;
              StartLayer := 1;
              EndLayer := frmMODFLOW.NSYSTM;
            end;
            else Assert(False)
          end;

          frmMODFLOWPostProcessing.clLayerNumber.Items.Clear;
          if TModflowOutputFileType(rgSourceType.ItemIndex) =
            mofBinaryIBS_Output then
          begin
            // special handling for IBS package
            // Display the layers that have IBS layers in them.
            SetLength(IBS_Layers, frmModflow.MODFLOWLayerCount);
            Index := 0;
            IBSIndex := 0;
            for UnitIndex := 1 to frmModflow.dgGeol.RowCount - 1 do
            begin
              if frmModflow.Simulated(UnitIndex) then
              begin
                for DisIndex := 1 to StrToInt(frmModflow.dgGeol.Cells
                  [Ord(nuiVertDisc), UnitIndex]) do
                begin
                  Inc(Index);
                  if (frmModflow.dgIBS.Columns[1].Picklist.IndexOf
                    (frmModflow.dgIBS.Cells[1, UnitIndex]) = 1) then
                  begin
                    Inc(IBSIndex);
                    frmMODFLOWPostProcessing.clLayerNumber.Items.Add(IntToStr(Index));
                  end;
                  IBS_Layers[Index - 1] := IBSIndex - 1;
                end;
              end;
            end;
          end
          else
          begin
            for Index := 1 to Endlayer do
            begin
              frmMODFLOWPostProcessing.clLayerNumber.Items.Add(IntToStr(Index));
            end;
          end;
          WaterTableOK := rgSourceType.ItemIndex in [0, 4, 6];
          if WaterTableOK then
          begin
            FileExt := LowerCase(ExtractFileExt(OpenDialog1.Filename));
            WaterTableOK := (FileExt = '.fhd') or (FileExt = '.bhd');
          end;
          if WaterTableOK then
          begin
            frmMODFLOWPostProcessing.clLayerNumber.Items.Add(StrWaterTable);
          end;
          frmMODFLOWPostProcessing.clLayerNumber.Checked[0] := True;

          // Get the centers of the rows and columns.
          for RowIndex := StartRow to EndRow do
          begin
            StringtoEvaluate := 'NthRowPos(' + IntToStr(RowIndex) + ')';

            GetMem(STR, Length(StringToEvaluate) + 1);
            try
              StrPCopy(STR, StringToEvaluate);
              ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
                layerHandle, kPIEFloat, STR,
                @RowPosition);
              ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
            finally
              FreeMem(STR);
            end;

            frmMODFLOWPostProcessing.YCoordList.Add(RowPosition)
          end;

          for RowIndex := frmMODFLOWPostProcessing.YCoordList.Count - 1
            downto 1 do
          begin
            frmMODFLOWPostProcessing.YCoordList.Items[RowIndex] :=
              (frmMODFLOWPostProcessing.YCoordList.Items[RowIndex] +
              frmMODFLOWPostProcessing.YCoordList.Items[RowIndex - 1]) / 2;
          end;
          frmMODFLOWPostProcessing.YCoordList.Delete(0);

          for ColumnIndex := StartColumn to EndColumn do
          begin
            StringtoEvaluate := 'NthColumnPos(' + IntToStr(ColumnIndex) + ')';

            GetMem(STR, Length(StringToEvaluate) + 1);
            try
              StrPCopy(STR, StringToEvaluate);
              ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
                layerHandle, kPIEFloat, STR,
                @ColumnPosition);
              ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
            finally
              FreeMem(STR);
            end;

            frmMODFLOWPostProcessing.XCoordList.Add(ColumnPosition)
          end;

          for ColumnIndex := frmMODFLOWPostProcessing.XCoordList.Count - 1
            downto 1 do
          begin
            frmMODFLOWPostProcessing.XCoordList.Items[ColumnIndex]
              := (frmMODFLOWPostProcessing.XCoordList.Items[ColumnIndex] +
              frmMODFLOWPostProcessing.XCoordList.Items[ColumnIndex - 1]) / 2;
          end;
          frmMODFLOWPostProcessing.XCoordList.Delete(0);

          // Create Dummy Layer positions.
          for LayerIndex := StartLayer to EndLayer do
          begin
            Layer := LayerIndex;
            frmMODFLOWPostProcessing.ZCoordList.Add(Layer)
          end;
          if WaterTableOK then
          begin
            frmMODFLOWPostProcessing.ZCoordList.Add(EndLayer+1)
          end;
          if TModflowOutputFileType(rgSourceType.ItemIndex) in
            [mofFormattedHeadAndDrawdown,
            mofGWT_Concentration,
            mofGWT_Velocity,
            mofScaledSensitivity,
            mofHUF_Formatted,
            mofMt3dmsConcentration,
            mofBinaryBudgetOldFormat,
            mofBinaryBudgetNewFormat] then
          begin
            // read data from text files.
            Readln(MFFile, ALine);
            while not Eof(MFFile) do
            begin
              if WaterTableOK then
              begin
                ADataSet := T3DRealList.Create
                  (frmMODFLOWPostProcessing.XCoordList.Count,
                  frmMODFLOWPostProcessing.YCoordList.Count,
                  EndLayer - StartLayer + 2);
              end
              else
              begin
                ADataSet := T3DRealList.Create
                  (frmMODFLOWPostProcessing.XCoordList.Count,
                  frmMODFLOWPostProcessing.YCoordList.Count,
                  EndLayer - StartLayer + 1);
              end;

              if (TModflowOutputFileType(rgSourceType.ItemIndex) =
                mofGWT_Concentration)
                and frmModflow.cbDualPorosity.Checked
                and frmModflow.cbUseDualPorosity.Checked then
              begin
                // MOC3D or GWT dual porosity used.
                DoublePorositySet := T3DRealList.Create
                  (frmMODFLOWPostProcessing.XCoordList.Count,
                  frmMODFLOWPostProcessing.YCoordList.Count,
                  EndLayer - StartLayer + 1);
              end;

              if TModflowOutputFileType(rgSourceType.ItemIndex) =
                mofGWT_Velocity then
              begin
                // MOC3D or GWT velocities
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
                if TModflowOutputFileType(rgSourceType.ItemIndex)
                  in [mofFormattedHeadAndDrawdown,
                  mofGWT_Concentration,
                  mofGWT_Velocity,
                  mofHUF_Formatted,
                  mofMt3dmsConcentration,
                  mofBinaryBudgetOldFormat,
                  mofBinaryBudgetNewFormat,
                  mofSUB_Subsidence,
                  mofSUB_CompactionByModelLayer,
                  mofSUB_CompactionByInterbedSystem,
                  mofSUB_VerticalDisplacementByModelLayer,
                  mofSUB_CriticalHeadForNoDelayInterbeds,
                  mofSUB_CriticalHeadForelayInterbeds,
                  mofSWT_CompactionByInterbedSystem,
                  mofSWT_PreconsolidationStressByModelLayer,
                  mofSWT_DeltaPreconsolidationStressByModelLayer,
                  mofSWT_GeostaticStressByModelLayer,
                  mofSWT_DeltaGeostaticStressByModelLayer,
                  mofSWT_EffectiveStressByModelLayer,
                  mofSWT_DeltaEffectiveStressByModelLayer,
                  mofSWT_VoidRatioByInterbedSystem,
                  mofSWT_ThickComprSedByInterbedSystem,
                  mofSWT_LayerCentElevByModelLayer] then
                begin
                  ReadMatrix(ALine, TEXT, FMTOUT, direction, KSTP, KPER,
                    NCOL, NROW, ILAY, KS, IMOV, StartRow, EndRow,
                    StartColumn, EndColumn, LayerIndex, PERTIM, TOTIM,
                    SUMTCH, DataValue, NumRows, NumColumns, ADataSet,
                    ReverseX);

                  if TModflowOutputFileType(rgSourceType.ItemIndex) =
                    mofGWT_Velocity then
                  begin
                    ReadMatrix(ALine, TEXT, FMTOUT, Rowdirection, KSTP,
                      KPER, NCOL, NROW, ILAY, KS, IMOV, StartRow, EndRow,
                      StartColumn, EndColumn, LayerIndex, PERTIM, TOTIM,
                      SUMTCH, DataValue, NumRows, NumColumns, RowSet,
                      ReverseY);

                    ReadMatrix(ALine, TEXT, FMTOUT, Layerdirection, KSTP,
                      KPER, NCOL, NROW, ILAY, KS, IMOV, StartRow, EndRow,
                      StartColumn, EndColumn, LayerIndex, PERTIM, TOTIM,
                      SUMTCH, DataValue, NumRows, NumColumns, LayerSet,
                      False)
                  end;
                end
                else
                begin
                  ReadSensitivityMatrix(ALine, KSTP, KPER, ILAY, StartRow,
                    EndRow, StartColumn, EndColumn, LayerIndex, ADataSet,
                    ParameterName);
                end;
              end; //  for LayerIndex := StartLayer - 1 to EndLayer - 1

              if WaterTableOK then
              begin
                AssignWaterTable(ADataSet);
//                for RowIndex := 0 to ADataSet.YCount - 1 do
//                begin
//                  for ColIndex := 0 to ADataSet.XCount - 1 do
//                  begin
//                    ADataSet.Items[ColIndex, RowIndex, ADataSet.ZCount-1]
//                      := ADataSet.Items[ColIndex, RowIndex,0];
//                  end;
//                end;
//                for LayerIndex := 1 to ADataSet.ZCount - 2 do
//                begin
//                  for RowIndex := 0 to ADataSet.YCount - 1 do
//                  begin
//                    for ColIndex := 0 to ADataSet.XCount - 1 do
//                    begin
//                      if not ModflowActiveValue(
//                        ADataSet.Items[ColIndex, RowIndex, ADataSet.ZCount-1]) then
//                      begin
//                        ADataSet.Items[ColIndex, RowIndex, ADataSet.ZCount-1]
//                          := ADataSet.Items[ColIndex, RowIndex,LayerIndex];
//                      end;
//                    end;
//                  end;
//                end;
              end;

              if (TModflowOutputFileType(rgSourceType.ItemIndex) =
                mofGWT_Concentration)
                and frmModflow.cbDualPorosity.Checked
                and frmModflow.cbUseDualPorosity.Checked
                and (frmModflow.comboDualPOutOption.ItemIndex > 0) then
              begin
                for LayerIndex := StartLayer - 1 to EndLayer - 1 do
                begin
                  ReadMatrix(ALine, TEXT, FMTOUT, Rowdirection, KSTP,
                    KPER, NCOL, NROW, ILAY, KS, IMOV, StartRow, EndRow,
                    StartColumn, EndColumn, LayerIndex, PERTIM, TOTIM,
                    SUMTCH, DataValue, NumRows, NumColumns, DoublePorositySet,
                    ReverseY)
                end; //  for LayerIndex := StartLayer - 1 to EndLayer - 1
              end;
              case TModflowOutputFileType(rgSourceType.ItemIndex) of
                mofFormattedHeadAndDrawdown, mofHUF_Formatted: // MODFLOW (Head and Drawdown)
                  begin
                    Name := Trim(TEXT) + ' Per ' + IntToStr(KPER) + ' TS ' +
                      IntToStr(KSTP) + ' Time ' + InternationalFloatToStr(TOTIM);
                  end;
                mofGWT_Concentration: // MOC3D (Concentrations)
                  begin
                    Name := 'Concentration, Per ' + IntToStr(KPER) + ' TS ' +
                      IntToStr(KSTP) + ' TrS ' + IntToStr(IMOV) + ' Time: '
                      + InternationalFloatToStr(SUMTCH);
                    if (TModflowOutputFileType(rgSourceType.ItemIndex) =
                      mofGWT_Concentration)
                      and frmModflow.cbDualPorosity.Checked
                      and frmModflow.cbUseDualPorosity.Checked then
                    begin
                      DoublePorosityName := 'Double Porosity Concentration, Per '
                        + IntToStr(KPER) + ' TS ' +
                        IntToStr(KSTP) + ' TrS ' + IntToStr(IMOV) + ' Time: '
                        + InternationalFloatToStr(SUMTCH);
                    end;
                  end;
                mofGWT_Velocity: // MOC3D (Velocities)
                  begin
                    Name := direction + ' Velocity ' + ' Per ' + IntToStr(KPER)
                      + ' TS ' + IntToStr(KSTP) + ' Time ' + InternationalFloatToStr(TOTIM);

                    RowName := Rowdirection + ' Velocity ' + ' Per ' +
                      IntToStr(KPER) + ' TS ' + IntToStr(KSTP) + ' Time ' +
                      InternationalFloatToStr(TOTIM);

                    LayerName := Layerdirection + ' Velocity ' + ' Per ' +
                      IntToStr(KPER) + ' TS ' + IntToStr(KSTP) + ' Time ' +
                      InternationalFloatToStr(TOTIM)
                  end;
                mofScaledSensitivity: // 1% Sensitivity
                  begin
                    Name := ParameterName
                      + ' Per ' + IntToStr(KPER)
                      + ' TS ' + IntToStr(KSTP);
                  end;
              end;

              frmMODFLOWPostProcessing.Data.Add(ADataSet, Name);
              frmMODFLOWPostProcessing.clDataSets.Items.Add(Name);

              if (TModflowOutputFileType(rgSourceType.ItemIndex) =
                mofGWT_Concentration)
                and frmModflow.cbDualPorosity.Checked
                and frmModflow.cbUseDualPorosity.Checked then
              begin
                frmMODFLOWPostProcessing.Data.Add(DoublePorositySet,
                  DoublePorosityName);
                frmMODFLOWPostProcessing.clDataSets.Items.Add(DoublePorosityName);
              end;
              if TModflowOutputFileType(rgSourceType.ItemIndex) =
                mofGWT_Velocity then
              begin
                frmMODFLOWPostProcessing.Data.Add(RowSet, RowName);
                frmMODFLOWPostProcessing.clDataSets.Items.Add(RowName);

                frmMODFLOWPostProcessing.Data.Add(LayerSet, LayerName);
                frmMODFLOWPostProcessing.clDataSets.Items.Add(LayerName)
              end
            end
              // while not Eof(OutputFile) do
          end
          else if TModflowOutputFileType(rgSourceType.ItemIndex) in
            [mofSWT_GeostaticStressByModelLayer,
            mofSWT_DeltaGeostaticStressByModelLayer,
            mofSWT_EffectiveStressByModelLayer,
            mofSWT_DeltaEffectiveStressByModelLayer,
            mofSWT_VoidRatioByInterbedSystem,
            mofSWT_ThickComprSedByInterbedSystem,
            mofSWT_LayerCentElevByModelLayer] then
          begin
            ReadModflowData(NumRows, NumColumns, EndLayer, FileStream)
          end
          else
          begin
            // read data from binary files.
            Assert( rgSourceType.ItemIndex > -1);
            ReadData(NumRows, NumColumns, EndLayer, WaterTableOK);
          end;
        end // try 1
      finally
        begin
          FileStream.Free;
          if FileOpened then
          begin
            CloseFile(MFFile);
          end;
          Screen.Cursor := crDefault;
          if frmMODFLOWPostProcessing.clDataSets.Items.Count > 0 then
          begin
            ModalResult := mrOK;
            if TModflowOutputFileType(rgSourceType.ItemIndex) =
              mofGWT_Velocity then
            begin
              if frmMODFLOWPostProcessing.clDataSets.Items.Count > 2 then
              begin
                frmMODFLOWPostProcessing.clDataSets.Checked
                  [frmMODFLOWPostProcessing.clDataSets.Items.Count - 2]
                  := True;
                frmMODFLOWPostProcessing.clDataSets.Checked
                  [frmMODFLOWPostProcessing.clDataSets.Items.Count - 3]
                  := True
              end
            end
            else
            begin
              frmMODFLOWPostProcessing.clDataSets.Checked
                [frmMODFLOWPostProcessing.clDataSets.Items.Count - 1]
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
      MessageDlg('Error reading file. "' + E.Message
        + '" Please make sure that the file was '
        + 'created by the current model.', mtError, [mbOK], 0);
      ModalResult := mrCancel
    end;
  end
end;

function TfrmSelectPostFile.NewBinaryFormat: boolean;
begin
  result := TModflowOutputFileType(rgSourceType.ItemIndex) in [
    mofBinaryHeadAndDrawdownNewFormat,
    mofSUB_Subsidence,
    mofSUB_CompactionByModelLayer,
    mofSUB_CompactionByInterbedSystem,
    mofSUB_VerticalDisplacementByModelLayer,
    mofSUB_CriticalHeadForNoDelayInterbeds,
    mofSUB_CriticalHeadForelayInterbeds,
    mofHUF_Binary,
    mofSWT_CompactionByInterbedSystem,
    mofSWT_PreconsolidationStressByModelLayer,
    mofSWT_DeltaPreconsolidationStressByModelLayer,
    mofSWT_GeostaticStressByModelLayer,
    mofSWT_DeltaGeostaticStressByModelLayer,
    mofSWT_EffectiveStressByModelLayer,
    mofSWT_DeltaEffectiveStressByModelLayer,
    mofSWT_VoidRatioByInterbedSystem,
    mofSWT_ThickComprSedByInterbedSystem,
    mofSWT_LayerCentElevByModelLayer];
  if TModflowOutputFileType(rgSourceType.ItemIndex) = mofBinaryIBS_Output then
  begin
    result := frmModflow.rbMODFLOW2000.Checked or frmModflow.rbModflow2005.Checked;
  end;
end;

procedure TfrmSelectPostFile.MyOpen1(UnitNumber: Longint; var ierror: Longint);
var
  fileName: string;
  filenameLength: LongInt;
begin
  //  fileName := '''' + OpenDialog1.FileName + '''';
  fileName := OpenDialog1.FileName;
  filenameLength := Length(fileName);
  if NewBinaryFormat then
  begin
    lrxopen2(ierror, UnitNumber, fileName, filenameLength);
  end
  else
  begin
    lrxopen(ierror, UnitNumber, fileName, filenameLength);
  end;

end;

procedure TfrmSelectPostFile.ReadModflowData(RowCount, ColCount, LayerCount: integer;
  FileStream: TFileStream);
var
  Precision: TModflowPrecision;
  AFileSize: Int64;
  KSTP: Integer;
  KPER: Integer;
  PERTIM: TModflowDouble;
  TOTIM: TModflowDouble;
  DESC: TModflowDesc;
  NCOL: Integer;
  NROW: Integer;
  ILAY: Integer;
  AnArray: TModflowDoubleArray;
  Title: string;
  ADataSet: T3DRealList;
  Col: Integer;
  Row: Integer;
begin
  Assert(FileStream <> nil);
  Precision := CheckArrayPrecision(FileStream);
  AFileSize := FileStream.Size;
  ADataSet := nil;
  while FileStream.Position < AFileSize do
  begin
    case Precision of
      mpSingle:
        begin
          ReadSinglePrecisionModflowBinaryRealArray(FileStream, KSTP, KPER,
            PERTIM, TOTIM, DESC, NCOL, NROW, ILAY, AnArray);
        end;
      mpDouble:
        begin
          ReadDoublePrecisionModflowBinaryRealArray(FileStream, KSTP, KPER,
            PERTIM, TOTIM, DESC, NCOL, NROW, ILAY, AnArray);
        end
      else Assert(False);
    end;
    if (NCOL <> ColCount) or (NROW <> RowCount) then
    begin
      raise EInvalidData.Create(Format('Error reading data file.  '
        + 'The file has a different number of rows or columns than '
        + 'the current model.  The current model has %d rows and %d '
        + 'columns.  The model in the file has %d rows and %d '
        + 'columns.', [RowCount, ColCount, NROW, NCOL]));
    end;
    Title := Trim(DESC) + '; Stress Period: ' + IntToStr(KPER)
      + '; Time Step: ' + IntToStr(KSTP) + '; Time: '
      + InternationalFloatToStr(TOTIM);

    if ILAY = 1 then
    begin
      ADataSet := T3DRealList.Create(NCOL, NRow, LayerCount);
      frmMODFLOWPostProcessing.Data.Add(ADataSet, Title);
      //              frmMODFLOWPostProcessing.rzclDataSets.Items.Add (Title)
      frmMODFLOWPostProcessing.clDataSets.Items.Add(Title)
    end;

    for Col := 0 to NCOL-1 do
    begin
      for Row := 0 to NROW-1 do
      begin
        ADataSet.Items[Col, Row, ILay - 1] := AnArray[Row, Col];
      end;
    end;
  end;
  
end;

procedure TfrmSelectPostFile.AssignWaterTable(ADataSet: T3DRealList);
var
  RowIndex: Integer;
  ColIndex: Integer;
  LayerIndex: Integer;
begin
  for RowIndex := 0 to ADataSet.YCount - 1 do
  begin
    for ColIndex := 0 to ADataSet.XCount - 1 do
    begin
      ADataSet.Items[ColIndex, RowIndex, ADataSet.ZCount - 1] := ADataSet.Items[ColIndex, RowIndex, 0];
    end;
  end;
  for LayerIndex := 1 to ADataSet.ZCount - 2 do
  begin
    for RowIndex := 0 to ADataSet.YCount - 1 do
    begin
      for ColIndex := 0 to ADataSet.XCount - 1 do
      begin
        if not ModflowActiveValue(ADataSet.Items[ColIndex, RowIndex, ADataSet.ZCount - 1]) then
        begin
          ADataSet.Items[ColIndex, RowIndex, ADataSet.ZCount - 1] := ADataSet.Items[ColIndex, RowIndex, LayerIndex];
        end;
      end;
    end;
  end;
  ADataSet.Cache;
end;

procedure TfrmSelectPostFile.ReadData(RowCount, ColCount, LayerCount: integer;
  WaterTableOK: boolean);
var
  InUnit: LongInt;
  ierror: LongInt;
  KSTP, KPER: LongInt;
  PERTIM, TOTIM: single;
  NCOL, NROW, ILAY, Col, Row: LongInt;
  AValue: Single;
  Text: String16;
  ThisColumn, ThisRow: integer;
  Layer: integer;
  ADataSet: T3DRealList;
  Title: string;
begin
  InUnit := 10;
  ADataSet := nil;
  ierror := 0;
  MyOpen1(InUnit, ierror);
  if ierror = 0 then
  begin
    try
      try
        Layer := 0;
        repeat
          Text := '                ';

          Inc(Layer);
          if Layer > LayerCount then
          begin
            Layer := 1;
          end;
          if NewBinaryFormat then
          begin
            ReadMe2(InUnit, ierror, KSTP, KPER,
              PERTIM, TOTIM, NCOL, NROW, ILAY, Text, Length(Text));
          end
          else
          begin
            ReadMe(InUnit, ierror, KSTP, KPER,
              PERTIM, TOTIM, NCOL, NROW, ILAY, Text, Length(Text));
          end;

          if (NCOL <> ColCount) or (NROW <> RowCount) then
          begin
            raise EInvalidData.Create(Format('Error reading data file.  '
              + 'The file has a different number of rows or columns than '
              + 'the current model.  The current model has %d rows and %d '
              + 'columns.  The model in the file has %d rows and %d '
              + 'columns.', [RowCount, ColCount, NROW, NCOL]));
          end;
          if ierror = 0 then
          begin
            SetLength(Text, 16);
            Title := Trim(Text) + '; Stress Period: ' + IntToStr(KPER)
              + '; Time Step: ' + IntToStr(KSTP) + '; Time: '
              + InternationalFloatToStr(TOTIM);

            if Layer = 1 then
            begin
              if WaterTableOK then
              begin
                ADataSet := T3DRealList.Create(NCOL, NRow, LayerCount+1);
              end
              else
              begin
                ADataSet := T3DRealList.Create(NCOL, NRow, LayerCount);
              end;
              frmMODFLOWPostProcessing.Data.Add(ADataSet, Title);
              //              frmMODFLOWPostProcessing.rzclDataSets.Items.Add (Title)
              frmMODFLOWPostProcessing.clDataSets.Items.Add(Title)
            end;
            for Col := 1 to NCOL do
            begin
              ThisColumn := Col;
              for Row := 1 to NROW do
              begin
                ThisRow := Row;
                if NewBinaryFormat then
                begin
                  GetValue2(AValue, ThisColumn, ThisRow);
                end
                else
                begin
                  GetValue(AValue, ThisColumn, ThisRow);
                end;
                if TModflowOutputFileType(rgSourceType.ItemIndex) =
                  mofBinaryIBS_Output then
                begin
                  ADataSet.Items[Col - 1, Row - 1, IBS_Layers[ILay - 1]] :=
                    AValue;
                end
                else
                begin
                  ADataSet.Items[Col - 1, Row - 1, ILay - 1] := AValue;
                end;

              end;
            end;
            if Layer = LayerCount then
            begin
              if WaterTableOK then
              begin
                AssignWaterTable(ADataSet);
              end
              else
              begin
                ADataSet.Cache;
              end;
            end;
          end;
        until ierror <> 0;
        if ierror > 0 then
        begin
          raise EInvalidData.Create('Error reading data file.  '
            + 'The file may not be a file of the correct type or it may '
            + 'be corrupt.');
        end;
      finally
        if NewBinaryFormat then
        begin
          FreeMe2;
        end
        else
        begin
          FreeMe;
        end;
      end;
    finally
      if NewBinaryFormat then
      begin
        lrxclose2(InUnit)
      end
      else
      begin
        lrxclose(InUnit)
      end;
    end;
  end
  else
  begin
    raise EInvalidData.Create('Error opening file');
  end;
end;

end.

