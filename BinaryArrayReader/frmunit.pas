unit frmUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, VersInfo, ASLink, ExtCtrls, Buttons;

type
  String16 = String[32];

  EInvalidData = class(Exception);

  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    VersionInfo1: TVersionInfo;
    Label1: TLabel;
    Image1: TImage;
    ASLink1: TASLink;
    Label2: TLabel;
    rgFileType: TRadioGroup;
    BitBtn1: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgFileTypeClick(Sender: TObject);
  private
    procedure MyOpen1(UnitNumber: Integer; var ierror: Integer);
    procedure ReadData;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure  lrxclose(
  var iunit : LongInt
  ); stdcall; external 'ReaArr.dll';

procedure  lrxopen(
  var ierror,iunit : LongInt;
  filename : string;
  filenameLength : LongInt
  ); stdcall; external 'ReaArr.dll';

procedure  lrfopen(
  var ierror,iunit : LongInt;
  filename : string;
  filenameLength : LongInt
  ); stdcall; external 'ReaArr.dll';

procedure  ReadMe(
  var INUNIT,iorror, KSTP,KPER : LongInt;
  var PERTIM,TOTIM : single;
  var NCOL,NROW,ILAY : LongInt;
  var Text : String16;
  TextLength : LongInt
  ); stdcall; external 'ReaArr.dll';

procedure  ReadMeFormatted(
  var INUNIT,iorror, KSTP,KPER : LongInt;
  var PERTIM,TOTIM : single;
  var NCOL,NROW,ILAY : LongInt;
  var Text : String16;
  TextLength : LongInt
  ); stdcall; external 'ReaArr.dll';

procedure  FreeMe; stdcall; external 'ReaArr.dll';

procedure  GETVALUE(
  var AVALUE : single;
  var NCOL,NROW: LongInt
  ); stdcall; external 'ReaArr.dll';

procedure TForm1.MyOpen1(UnitNumber :Longint; var ierror : Longint);
var
  fileName : string;
  filenameLength : LongInt;
begin
  fileName := '''' + OpenDialog1.FileName + '''';
  filenameLength  := Length(fileName);
  if rgFileType.ItemIndex = 0 then
  begin
    lrxopen(ierror,UnitNumber, OpenDialog1.FileName, filenameLength);
  end
  else
  begin
    lrfopen(ierror,UnitNumber, OpenDialog1.FileName, filenameLength);
  end;
end;

procedure TForm1.ReadData;
const
  InUnit : LongInt = 10;
var
  ierror: LongInt;
  KSTP,KPER : LongInt;
  PERTIM,TOTIM : single;
  NCOL,NROW,ILAY,Col,Row : LongInt;
  AValue : Single;
  Text : String16;
  ThisColumn, ThisRow : integer;
  Title : string;
  AFile : TextFile;
begin
  ierror := 0;
  OpenDialog1.FileName := '';
  SaveDialog1.FileName := '';
  if OpenDialog1.Execute and SaveDialog1.Execute then
  begin
    if OpenDialog1.FileName = SaveDialog1.FileName then
    begin
      Beep;
      MessageDlg('Error: file names must be different', mtError, [mbOK], 0);
      Exit;
    end;
    AssignFile(AFile,SaveDialog1.FileName);
    try
      Rewrite(AFile);
      MyOpen1(InUnit, ierror);
      if ierror = 0 then
      begin
        try
          try
            repeat
              Text := '                ';
              if rgFileType.ItemIndex = 0 then
              begin
                ReadMe(InUnit,ierror, KSTP,KPER,
                  PERTIM,TOTIM,NCOL,NROW,ILAY,Text, Length(Text));
              end
              else
              begin
                ReadMeFormatted(InUnit,ierror, KSTP,KPER,
                  PERTIM,TOTIM,NCOL,NROW,ILAY,Text, Length(Text));
              end;
              if ierror = 0 then
              begin
                SetLength(Text,16);
                Title := Trim(Text)
                  + '; Stress Period: ' + IntToStr(KPER)
                  + '; Time Step: ' + IntToStr(KSTP)
                  + '; Period Time: ' + FloatToStr(PERTIM)
                  + '; Total Time: ' + FloatToStr(TOTIM)
                  + '; Number of Columns: ' + IntToStr(NCOL)
                  + '; Number of Rows: ' + IntToStr(NROW)
                  + '; Layer: ' + IntToStr(ILAY);
                WriteLn(AFile,Title);

                for Row := 1 to NROW do
                begin
                  ThisRow := Row;
                  for Col := 1 to NCOL do
                  begin
                    ThisColumn := Col;
                    GetValue(AValue,ThisColumn,ThisRow);
                    if Col > 1 then
                    begin
                      Write(Afile, Chr(9));
                    end;
                    Write(Afile, AValue);
                  end;
                  Writeln(Afile);
                end;
              end;
            until ierror <> 0;
            if ierror > 0 then
            begin
              Beep;
              raise EInvalidData.Create('Error reading data file.  '
                + 'The file may not be a file of the correct type or it may '
                + 'be corrupt.');
            end;
          finally
            FreeMe;
          end;
        finally
          lrxclose(InUnit)
        end;
      end;
    finally
      CloseFile(AFile);
    end;
    Beep;
    ShowMessage('Done')


  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ReadData;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Label1.Caption := 'Version: ' + VersionInfo1.FileVersion;
end;

procedure TForm1.rgFileTypeClick(Sender: TObject);
begin
  if rgFileType.ItemIndex = 0 then
  begin
    OpenDialog1.Filter := 'binary files|*bhd;*bdn;*.isc;*.ish;*.iss|All Files|*.*';
  end
  else
  begin
    OpenDialog1.Filter := 'ascii files|*fhd;*fdn|All Files|*.*';
  end;
end;

end.
