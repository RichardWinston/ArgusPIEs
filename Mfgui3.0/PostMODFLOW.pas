unit PostMODFLOW;

interface

{PostMODFLOW defines the form used to select which data will be plotted
 during post-processing. It also has functions that determine whether
 a particle data point should be imported.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ThreeDGriddedDataStorageUnit, Buttons, RzLstBox,
  RzChkLst, RealListUnit, ArgusDataEntry, IntListUnit, ExtCtrls, AnePIE;

type
  TfrmMODFLOWPostProcessing = class(TForm)
    rzclDataSets: TRzCheckList;
    Panel1: TPanel;
    rgChartType: TRadioGroup;
    Label1: TLabel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    btnHelp: TBitBtn;
    comboLayerNumber: TComboBox;
    cbImpInactive: TCheckBox;
    cbImpDry: TCheckBox;
    procedure FormCreate(Sender: TObject); virtual;
    procedure FormDestroy(Sender: TObject); virtual;
    procedure btnOKClick(Sender: TObject); virtual;
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean; virtual;
    procedure FormShow(Sender: TObject); virtual;
  private
    { Private declarations }
  public
    DataSets : TIntegerList;
    XCoordList : TRealList;
    YCoordList : TRealList;
    ZCoordList : TRealList;
    Data : T3DGridStorage;
    CurrentModelHandle : ANE_PTR;
    procedure ActivateOptions;
    procedure AssignHelpFile(FileName : string) ; virtual;
    Procedure Moved (var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED;
    { Public declarations }
  end;

type
  EInvalidGridSize = Class(Exception);

function MODFLOWActive(X, Y, Z : Integer; DataValue : double) : boolean;
function MOC3DConcActive(X, Y, Z : Integer; DataValue : double) : boolean;
function MOC3DVelActive(X, Y, Z : Integer; DataValue : double) : boolean;

implementation

{$R *.DFM}

uses Variables, ModflowUnit, ThreeDRealListUnit, ANECB, ANE_LayerUnit,
     ArgusFormUnit, MFPostProc, WritePostProcessingUnit,
     UtilityFunctions, SelectPostFile;

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
    HNOFLO := StrToFloat(frmMODFLOW.adeHNOFLO.Text);
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
    HDRY := StrToFloat(frmMODFLOW.adeHDRY.Text);
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
    CNOFLO := StrToFloat(frmMODFLOW.adeMOC3DCnoflow.Text);
    if not ((DataValue + CNOFLO) = 0)
      and (Abs((DataValue - CNOFLO)/(DataValue + CNOFLO)) < RoundError) then
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
end;

procedure TfrmMODFLOWPostProcessing.ActivateOptions;
begin
  cbImpInactive.Enabled := frmSelectPostFile.rgSourceType.ItemIndex < 2;
  cbImpDry.Enabled := frmSelectPostFile.rgSourceType.ItemIndex < 1;
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
  // triggering event btnOK.OnClick
  OK := True;
  Count := 0;
  if (frmSelectPostFile.rgSourceType.ItemIndex = 2)then
  begin
    For Index := 0 to rzclDataSets.Items.Count -1 do
    begin
      if rzclDataSets.ItemState[ Index] = cbChecked
      then
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
    For Index := 0 to rzclDataSets.Items.Count -1 do
    begin
      if rzclDataSets.ItemState[ Index] = cbChecked
      then
        begin
          DataSets.Add(Index);
//          Inc(Count);
        end;
    end;
  end;

end;

procedure TfrmMODFLOWPostProcessing.AssignHelpFile(FileName : string);
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

function TfrmMODFLOWPostProcessing.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin

  // This assigns the help file every time Help is called from frmMODFLOW.
  // AssignHelpFile is a virtual function that can be overridden by
  // descendents to assign a different help file for controls not present
  // in TfrmMODFLOW.
  AssignHelpFile('MODFLOW.hlp');
  result := True;

end;

procedure TfrmMODFLOWPostProcessing.FormShow(Sender: TObject);
begin
  ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
end;

procedure TfrmMODFLOWPostProcessing.Moved(
  var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

end.
