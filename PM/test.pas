unit test;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  framFilePathUnit, StdCtrls, Spin, CheckLst;

type
  TForm1 = class(TForm)
    framFilePath1: TframFilePath;
    framFilePath2: TframFilePath;
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    CheckListBox1: TCheckListBox;
    procedure Button1Click(Sender: TObject);
  private

    function OpenFiles : boolean;
    procedure CloseFiles;
    { Private declarations }
  public
    { Public declarations }
  end;

const
  IUCN : longint =10;
  ICNF : longint =11;
var
  Form1: TForm1;


implementation

{$R *.DFM}

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

procedure TForm1.Button1Click(Sender: TObject);
var
  ierror: longint;
  TIME0 : single;
  NT0, KS0, KP0 : longint;
  var icol, irow, ilay : longint;
  var Value : single;
begin
  try
    if OpenFiles then
    begin
      TIME0  := 0;
      NT0 := 1;
      KS0 := 1;
      KP0 := 1;
      ierror := 0;
      icol := 5;
      irow := 5;
      ilay := 1;

      while ierror = 0 do
      begin
        pmread_nextarray(ierror, NT0, KS0, KP0, TIME0);
//      pmread_array(ierror, TIME0, NT0, KS0, KP0);
        if ierror = 0 then
        begin
          CheckListBox1.Items.Add('Time = ' + FloatToStr(TIME0)
            + '; Stress Period = ' + IntToStr(KP0)
            + '; Time Step = ' + IntToStr(KS0)
            + '; Transport Step = ' + IntToStr(NT0));

          pmget_value(icol, irow, ilay, ierror, Value);
          if ierror = 0 then
          begin
            Memo1.Lines.Add('Value = ' + FloatToStr(Value));
          end;
          Application.ProcessMessages;
        end;
//        ShowMessage('OK');
      end;
    end;
  finally
    CloseFiles
  end;
end;

procedure TForm1.CloseFiles;
var
  Iunit : longint;
begin
  Iunit := ICNF;
  pmclose(Iunit);
  Iunit := IUCN;
  pmclose(Iunit);
  pm_deallocate;
end;

function TForm1.OpenFiles: boolean;
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
  if not result then Exit;

  Iunit2 := IUCN;
  filename := framFilePath2.edFilePath.Text;
  isnew := False;
  pmopen(ierror,Iunit2, filename, isnew, Length(filename));
  result :=  ierror = 0;
  if not result then Exit;

  pm_initialize(ierror);
  result :=  ierror = 0;
end;

end.
