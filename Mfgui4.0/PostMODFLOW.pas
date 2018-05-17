unit PostMODFLOW;

interface

{PostMODFLOW defines the form used to select which data will be plotted
 during post-processing. It also has functions that determine whether
 a particle data point should be imported.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, StdCtrls, ThreeDGriddedDataStorageUnit, Buttons,
  RealListUnit, ArgusDataEntry, IntListUnit, ExtCtrls, AnePIE, CheckLst,
  FlowReaderUnit;

type
  TfrmMODFLOWPostProcessing = class(TArgusForm)
    Panel1: TPanel;
    rgChartType: TRadioGroup;
    Label1: TLabel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    btnHelp: TBitBtn;
    cbImpInactive: TCheckBox;
    cbImpDry: TCheckBox;
    clDataSets: TCheckListBox;
    clLayerNumber: TCheckListBox;
    spl1: TSplitter;
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure btnOKClick(Sender: TObject); virtual;
    procedure FormShow(Sender: TObject); virtual;
  private
    { Private declarations }
  public
    DataSets : TIntegerList;
    XCoordList : TRealList;
    YCoordList : TRealList;
    ZCoordList : TRealList;
    Data : T3DGridStorage;
    BudgetFile: boolean;
    BudgetFileName: string;
    BudgetProgram: TBudgetProgram;
    procedure ActivateOptions;
    procedure ReadBudgetData;
    { Public declarations }
  end;

type
  EInvalidGridSize = Class(Exception);

function ModflowActiveValue(DataValue : double) : boolean;
function MODFLOWActive(X, Y, Z : Integer; DataValue : double) : boolean;
function MOC3DConcActive(X, Y, Z : Integer; DataValue : double) : boolean;
function MOC3DVelActive(X, Y, Z : Integer; DataValue : double) : boolean;
function MT3DMSConcActive(X, Y, Z : Integer; DataValue : double) : boolean;

implementation

{$R *.DFM}

uses Variables, ModflowUnit, ThreeDRealListUnit, ANECB, ANE_LayerUnit,
     MFPostProc, WritePostProcessingUnit,
     UtilityFunctions, SelectPostFile;

function ModflowActiveValue(DataValue : double) : boolean;
const
  RoundError = 1e-6;
var
  HNOFLO : double;
  HDRY : double;
  Denominator : double;
begin
  result := True;

  HNOFLO := InternationalStrToFloat(frmMODFLOW.adeHNOFLO.Text);
  Denominator := DataValue + HNOFLO;
  if Denominator = 0 then
  begin
    Denominator := RoundError;
  end;
  if (Abs((DataValue - HNOFLO)/Denominator) < RoundError) then
  begin
    result := False;
  end;

  HDRY := InternationalStrToFloat(frmMODFLOW.adeHDRY.Text);
  Denominator := DataValue + HDRY;
  if Denominator = 0 then
  begin
    Denominator := RoundError;
  end;
  if (Abs((DataValue - HDRY)/Denominator) < RoundError) then
  begin
    result := False;
  end;

end;

function MODFLOWActive(X, Y, Z : Integer; DataValue : double) : boolean;
const
  RoundError = 1e-6;
var
  HNOFLO : double;
  HDRY : double;
  Denominator : double;
begin
  // called by GPostProcessingPIE
  result := True;

  if not frmMODFLOWPostProcessing.cbImpInactive.Checked then
  begin
    HNOFLO := InternationalStrToFloat(frmMODFLOW.adeHNOFLO.Text);
    Denominator := DataValue + HNOFLO;
    if Denominator = 0 then
    begin
      Denominator := RoundError;
    end;
    if (Abs((DataValue - HNOFLO)/Denominator) < RoundError) then
    begin
      result := False;
    end;
  end;

  if not frmMODFLOWPostProcessing.cbImpDry.Checked then
  begin
    HDRY := InternationalStrToFloat(frmMODFLOW.adeHDRY.Text);
    Denominator := DataValue + HDRY;
    if Denominator = 0 then
    begin
      Denominator := RoundError;
    end;
    if (Abs((DataValue - HDRY)/Denominator) < RoundError) then
    begin
      result := False;
    end;
  end;
end;

function MOC3DConcActive(X, Y, Z : Integer; DataValue : double) : boolean;
const
  RoundError = 1e-6;
var
  CNOFLO : double;
begin
  // called by GPostProcessingPIE
  result := True;
  if not frmMODFLOWPostProcessing.cbImpInactive.Checked then
  begin
    CNOFLO := InternationalStrToFloat(frmMODFLOW.adeMOC3DCnoflow.Text);
    if not ((DataValue + CNOFLO) = 0)
      and (Abs((DataValue - CNOFLO)/(DataValue + CNOFLO)) < RoundError) then
    begin
      result := False;
    end;
  end;
end;

function MT3DMSConcActive(X, Y, Z : Integer; DataValue : double) : boolean;
const
  RoundError = 1e-6;
  CDRY = 1E30;
var
  CINCACT : double;
begin
  // called by GPostProcessingPIE
  result := True;
  if not frmMODFLOWPostProcessing.cbImpInactive.Checked then
  begin
    CINCACT := InternationalStrToFloat(frmMODFLOW.adeMT3DInactive.Text);
    if (DataValue = CINCACT) or (DataValue = CDRY)
      or (Abs((DataValue - CINCACT)/(DataValue + CINCACT)) < RoundError) 
      or (Abs((DataValue - CDRY)/(DataValue + CDRY)) < RoundError) then
    begin
      result := False;
    end;
  end;
end;


function MOC3DVelActive(X, Y, Z : Integer; DataValue : double) : boolean;
begin
  // called by GPostProcessingPIE
  result := True;
end;

procedure TfrmMODFLOWPostProcessing.FormCreate(Sender: TObject);
begin
  // triggering event frmMODFLOWPostProcessing.OnCreate
  Data := T3DGridStorage.Create;
  XCoordList := TRealList.Create;
  YCoordList := TRealList.Create;
  ZCoordList := TRealList.Create;
  DataSets := TIntegerList.Create;
  BudgetFile := False;
end;

procedure TfrmMODFLOWPostProcessing.ActivateOptions;
begin
  cbImpInactive.Enabled :=
    TModflowOutputFileType(frmSelectPostFile.rgSourceType.ItemIndex)
    in [mofFormattedHeadAndDrawdown, mofGWT_Concentration];
  cbImpDry.Enabled :=
    TModflowOutputFileType(frmSelectPostFile.rgSourceType.ItemIndex) =
    mofFormattedHeadAndDrawdown;
end;

procedure TfrmMODFLOWPostProcessing.FormDestroy(Sender: TObject);
begin
  // triggering event frmMODFLOWPostProcessing.OnDestroy
  Data.Free;
  XCoordList.Free ;
  YCoordList.Free ;
  ZCoordList.Free;
  DataSets.Free;
end;

procedure TfrmMODFLOWPostProcessing.btnOKClick(Sender: TObject);
var
  Index : integer;
  Count : integer;
  OK : boolean;
begin
  if BudgetFile then
  begin
    ReadBudgetData;
    Exit;
  end;

  // triggering event btnOK.OnClick
  OK := True;
  Count := 0;
  if TModflowOutputFileType(frmSelectPostFile.rgSourceType.ItemIndex) =
    mofGWT_Velocity then
  begin
    For Index := 0 to clDataSets.Items.Count -1 do
    begin
      if clDataSets.Checked[ Index] then
      begin
        Inc(Count);
      end;
    end;
    if Odd(Count) then
    begin
      Beep;
      MessageDlg('You must select pairs of data sets to create velocity plots.'
        , mtError, [mbOK], 0);
      ModalResult := mrNone;
      OK := False;
    end;
  end;
  if OK then
  begin
    For Index := 0 to clDataSets.Items.Count -1 do
    begin
      if clDataSets.Checked[ Index] then
      begin
        DataSets.Add(Index);
      end;
    end;
  end;

end;

procedure TfrmMODFLOWPostProcessing.FormShow(Sender: TObject);
begin
  ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
end;

procedure TfrmMODFLOWPostProcessing.ReadBudgetData;
var
  SelectedItems: TIntegerList;
  ItemIndex: integer;
  BudgetData: TValues;
  NCol, NRow, NLay: Integer;
  ColIndex, RowIndex, LayIndex: integer;
  Names: TStringList;
  Name: string;
  ADataSet: T3DRealList;
begin
  SelectedItems := TIntegerList.Create;
  Names := TStringList.Create;
  try
    for ItemIndex := 0 to clDataSets.Items.Count -1 do
    begin
      if clDataSets.Checked[ItemIndex] then
      begin
        SelectedItems.Add(ItemIndex);
        Names.Add(clDataSets.Items[ItemIndex]);
      end;
    end;
    if SelectedItems.Count > 0 then
    begin
      ReadValues(BudgetFileName, SelectedItems, BudgetData, BudgetProgram);
      Assert(Length(BudgetData) = SelectedItems.Count);
      NCol := XCoordList.Count;
      NROW := YCoordList.Count;
      NLay := ZCoordList.Count;
      Assert(Length(BudgetData[0]) = NCol);
      Assert(Length(BudgetData[0,0]) = NROW);
      Assert(Length(BudgetData[0,0,0]) = NLay);
      for ItemIndex := 0 to SelectedItems.Count-1 do
      begin
        Name := Names[ItemIndex];
        ADataSet := T3DRealList.Create
          (XCoordList.Count, YCoordList.Count, ZCoordList.Count);
        for ColIndex := 0 to NCol -1 do
        begin
          for RowIndex := 0 to NRow -1 do
          begin
            for LayIndex := 0 to NLay -1 do
            begin
              ADataSet.Items[ColIndex, RowIndex, LayIndex] :=
                BudgetData[ItemIndex, ColIndex, RowIndex, LayIndex];
            end;
          end;
        end;
        Data.Add(ADataSet, Name);
        DataSets.Add(ItemIndex);
      end;
    end;
  finally
    SelectedItems.Free;
    Names.Free;
  end;
end;

end.
