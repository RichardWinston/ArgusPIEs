unit frmMt3dFilesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ArgusFormUnit, Dialogs, StdCtrls, Buttons, framFilePathUnit, Grids,
  RbwDataGrid, ArgusDataEntry, ExtCtrls, CheckLst, Spin;

type
  TfrmMt3dFiles = class(TArgusForm)
    framFilePath2: TframFilePath;
    framFilePath1: TframFilePath;
    Panel2: TPanel;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    btnOK: TBitBtn;
    btnRead: TButton;
    clbDataSets: TCheckListBox;
    seLayer: TSpinEdit;
    Label1: TLabel;
    cbLogTransform: TCheckBox;
    procedure framFilePath1edFilePathChange(Sender: TObject);
    procedure framFilePath2edFilePathChange(Sender: TObject);
    procedure btnReadClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
  private
    FNCOL: integer;
    FNROW: integer;
    FNLAY: integer;
    function OpenFiles : boolean;
    procedure CloseFiles;
    procedure SetNLAY(const Value: integer);
    procedure ShowError(IERR: integer);

    { Private declarations }
  public
    Values : array of array of array of Double;
    DataSetNames : TStringList;
    property NROW : integer read FNROW write FNROW;
    property NCOL : integer read FNCOL write FNCOL;
    Property NLAY : integer read FNLAY write SetNLAY;
    { Public declarations }
  end;

var
  frmMt3dFiles: TfrmMt3dFiles;

implementation

{$R *.DFM}

uses Math, PostMODFLOW;

const
  IUCN : longint =10;
  ICNF : longint =11;

procedure pmopen(var ierror,iunit : longint; filename : string;
  var isnew : longbool; FileLength : longint); stdcall; external 'pm.dll';
procedure pmfopen(var ierror,iunit : longint; filename : string;
  var isnew : longbool; FileLength : longint); stdcall; external 'pm.dll';
procedure pmclose(var iunit: longint); stdcall; external 'pm.dll';
procedure pmget_value(var icol, irow, ilay, ierr : longint;
  var Value : single); stdcall; external 'pm.dll';
procedure pmread_nextarray(var IERR, NTRANS,KSTP,KPER: longint;
  var TIME : single); stdcall; external 'pm.dll';
procedure pm_deallocate; stdcall; external 'pm.dll';
procedure pm_initialize(var IERR: longint); stdcall; external 'pm.dll';

procedure TfrmMt3dFiles.framFilePath1edFilePathChange(Sender: TObject);
begin
  framFilePath1.edFilePathChange(Sender);
  btnRead.Enabled := FileExists(framFilePath1.edFilePath.Text)
    and FileExists(framFilePath2.edFilePath.Text);
end;

procedure TfrmMt3dFiles.framFilePath2edFilePathChange(Sender: TObject);
begin
  framFilePath2.edFilePathChange(Sender);
  btnRead.Enabled := FileExists(framFilePath1.edFilePath.Text)
    and FileExists(framFilePath2.edFilePath.Text);
end;

procedure TfrmMt3dFiles.CloseFiles;
var
  Iunit : longint;
begin
  Iunit := ICNF;
  pmclose(Iunit);
  Iunit := IUCN;
  pmclose(Iunit);
  pm_deallocate;
end;

procedure TfrmMt3dFiles.ShowError(IERR : integer);
var
  ErrorMessage : string;
begin
  case IERR of
    1: ErrorMessage := 'Not enough memory.';
    2: ErrorMessage := 'Data not found.';
    3: ErrorMessage := 'The number of columns or number of rows in the '
      + 'unformatted file and the model grid configuration file are NOT '
      + 'the same';
    4: ErrorMessage := 'Layer NOT found in unformatted file.';
    5: ErrorMessage := 'End of File.';
  else ErrorMessage := 'Unknown error.';
  end;
  MessageDlg(ErrorMessage, mtError, [mbOK], 0);
end;

function TfrmMt3dFiles.OpenFiles: boolean;
var
  ierror, Iunit1, Iunit2 : longint;
  filename : string;
  isnew : longbool;

begin
  result := fileExists(framFilePath1.edFilePath.Text) and
    fileExists(framFilePath2.edFilePath.Text);
  if not result then Exit;

  ierror := 0;
  Iunit1 := ICNF;
  filename := framFilePath1.edFilePath.Text;
  isnew := False;
  pmfopen(ierror,Iunit1, filename, isnew, Length(filename));
  result :=  ierror = 0;
  if not result then
  begin
    ShowError(ierror);
    Exit;
  end;

  Iunit2 := IUCN;
  filename := framFilePath2.edFilePath.Text;
  isnew := False;
  pmopen(ierror,Iunit2, filename, isnew, Length(filename));
  result :=  ierror = 0;
  if not result then
  begin
    ShowError(ierror);
    Exit;
  end;

  pm_initialize(ierror);
  result :=  ierror = 0;
  if not result then
  begin
    ShowError(ierror);
    Exit;
  end;
end;

procedure TfrmMt3dFiles.btnReadClick(Sender: TObject);
var
  ierror: longint;
  TIME : single;
  NTRANS,KSTP,KPER : longint;
begin
  btnOK.Enabled := False;
  clbDataSets.Items.Clear;
  try
    if OpenFiles then
    begin
      TIME  := 0;
      KSTP := 1;
      KPER := 1;
      NTRANS := 1;
      ierror := 0;

      while ierror = 0 do
      begin
        pmread_nextarray(ierror, NTRANS, KSTP, KPER, TIME);
        if not (ierror in [0,5]) then
        begin
          ShowError(ierror);
          Exit;
        end;

        if ierror = 0 then
        begin
          clbDataSets.Items.Add('Time ' + FloatToStr(TIME)
            + ' SP ' + IntToStr(KPER)
            + ' TS ' + IntToStr(KSTP)
            + ' Tran Step ' + IntToStr(NTRANS));

          Application.ProcessMessages;
        end;
      end;
      if clbDataSets.Items.Count > 0 then
      begin
        clbDataSets.Checked[clbDataSets.Items.Count-1] := True;
      end;

      btnOK.Enabled := True;
    end;
  finally
    CloseFiles
  end;
end;

procedure TfrmMt3dFiles.SetNLAY(const Value: integer);
begin
  FNLAY := Value;
  seLayer.MaxValue := Value;
end;

procedure TfrmMt3dFiles.btnOKClick(Sender: TObject);
var
  SelectedCount : integer;
  Layer : longint;
  Row : longint;
  Col : longint;
  DataSetIndex : integer;
  RowIndex, ColIndex : integer;
  ierror: longint;
  TIME : single;
  NTRANS,KSTP,KPER : longint;
  Value : single;
  SelectedIndex : integer;
  MinValue : double;
  FirstValueFound : boolean;
begin
  MinValue := 0;
  SelectedCount := 0;
  for DataSetIndex := 0 to clbDataSets.Items.Count -1 do
  begin
    if clbDataSets.Checked[DataSetIndex] then
    begin
      Inc(SelectedCount);
    end;
  end;
  if SelectedCount = 0 then
  begin
    ModalResult := mrCancel;
    Exit;
  end;
  SetLength(Values, SelectedCount, NCOL, NROW);

  Layer := seLayer.Value;

  try
    if OpenFiles then
    begin
      TIME  := 0;
      KSTP := 1;
      KPER := 1;
      NTRANS := 1;
      ierror := 0;

      SelectedIndex := -1;
      DataSetNames.Clear;
      for DataSetIndex := 0 to clbDataSets.Items.Count -1 do
      begin
        pmread_nextarray(ierror, NTRANS, KSTP, KPER, TIME);
        if ierror <> 0 then
        begin
          ModalResult := mrCancel;
          ShowError(ierror);
          Exit;
        end;
        if clbDataSets.Checked[DataSetIndex] then
        begin
          Inc(SelectedIndex);
          DataSetNames.Add('Concentration '
            + clbDataSets.Items[DataSetIndex]);
          FirstValueFound := False;
          for ColIndex := 0 to NCOL-1 do
          begin
            Col:=ColIndex + 1;
            for RowIndex := 0 to NROW-1 do
            begin
              Row := RowIndex + 1;
              pmget_value(Col, Row, Layer, ierror, Value);
              if ierror <> 0 then
              begin
                ModalResult := mrCancel;
                ShowError(ierror);
                Exit;
              end;
              Values[SelectedIndex,ColIndex,RowIndex] := Value;
              if cbLogTransform.Checked and MT3DMSConcActive(1, 1, 1, Value)
                and (Value > 0) then
              begin
                if FirstValueFound then
                begin
                  if (Value < MinValue) then
                  begin
                    MinValue := Value;
                  end;
                end
                else
                begin
                  MinValue := Value;
                  FirstValueFound := True;
                end;
              end;
            end;
          end;
          if cbLogTransform.Checked then
          begin
            MinValue := Log10(MinValue/10);
            for ColIndex := 0 to NCOL-1 do
            begin
              for RowIndex := 0 to NROW-1 do
              begin
                Value := Values[SelectedIndex,ColIndex,RowIndex];
                if MT3DMSConcActive(1, 1, 1, Value) then
                begin
                  if Value > 0 then
                  begin
                    Values[SelectedIndex,ColIndex,RowIndex] := Log10(Value);
                  end
                  else
                  begin
                    Values[SelectedIndex,ColIndex,RowIndex] := MinValue;
                  end;
                end
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    CloseFiles
  end;

end;

procedure TfrmMt3dFiles.FormCreate(Sender: TObject);
begin
  DataSetNames := TStringList.Create;
end;

procedure TfrmMt3dFiles.FormDestroy(Sender: TObject);
begin
  DataSetNames.Free;
end;

end.
