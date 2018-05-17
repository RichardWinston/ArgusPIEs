{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
"http://www.w3.org/TR/REC-html40/loose.dtd">
<HTML><BODY BGCOLOR="#ffffff"><PRE>   }

Unit Ads_Misc;

{Copyright(c)1998 Advanced Delphi Systems

 Richard Maley
 Advanced Delphi Systems
 12613 Maidens Bower Drive
 Potomac, MD 20854 USA
 phone 301-840-1554
 maley@advdelphisys.com
 maley@compuserve.com
 maley@cpcug.org}

Interface

Uses
  SysUtils, StdCtrls, ExtCtrls, Ads_Strg, WinProcs, WinTypes, Dialogs,
  Forms;

Const RunOutsideIDE_ads        = True;
Const RunOutsideIDEDate_ads    = '12/1/98';
Const RunOutsideIDECompany_ads = 'Advanced Delphi Systems';
Const RunOutsideIDEPhone_ads   = 'Please purchase at (301) 840-1554';


{!~ Checks whether Delphi is Running and
issues a message if the user doesn't have
the right to use the component}
procedure DelphiCheck(CanRunOutSide: Boolean);

{!~ Checks whether Delphi is Running and
issues a message if the user doesn't have
the right to use the component}
procedure DelphiChecker(
  CanRunOutSide   : Boolean;
  ComponentName   : String;
  OwnerName       : String;
  PurchaseMessage : String;
  ActivateDate    : String);

{!~ Returns True if delphi is running, False otherwise}
Function DelphiIsRunning: Boolean;

{!~ Returns True if Delphi is currently running}
Function IsDelphiRunning: Boolean;

{!~ Allows the programmer to simulate
a keyboard press of a virtual key.
Only one key at a time.}
Function KeySend(VirtualKey: Word): Boolean;

{!~ Presents a Message Dialog}
procedure Msg(Msg: String);

{!~ Implements final resize tuning}
Procedure ReSizeTuner(ComponentName : String);

{!~ Allows the programmer to simulate
a keyboard press of a virtual key.
Only one key at a time.}
Function SendKey(VirtualKey: Word): Boolean;

{!~ Returns the Windows User ID.}
Function UserIDFromWindows: string;

{!~ Populates a listbox with the executable's version information}
Function VersionInformation(
  ListBox : TListBox): Boolean;

Implementation

Type
  TPanel_Cmp_Sec_ads = class(TPanel)
  Public
    procedure ResizeShadowLabel(Sender: TObject);
  End;

procedure TPanel_Cmp_Sec_ads.ResizeShadowLabel(
  Sender     : TObject);
Var
  PH, PW : Integer;
  LH, LW : Integer;
begin
  PH := TPanel(Sender).Height;
  PW := TPanel(Sender).Width;
  LH := TLabel(Controls[0]).Height;
  LW := TLabel(Controls[0]).Width;
  TLabel(Controls[0]).Top  := ((PH-LH) div 2)-3;
  TLabel(Controls[0]).Left := ((Pw-Lw) div 2)-3;
end;

Type
  TEditKeyFilter = Class(TEdit)
  Published
    {!~ Throws away all keys except 0-9,-,+,.}
    Procedure OnlyNumbers(Sender: TObject; var Key: Char);

    {!~ Throws away all keys except 0-9}
    Procedure OnlyNumbersAbsolute(Sender: TObject; var Key: Char);

    {!~ Throws away all keys except a-z and A-Z}
    Procedure OnlyAToZ(Sender: TObject; var Key: Char);

  End;

{$ifndef WIN32}
procedure Keybd_Event; far; external 'USER' index 289;

procedure PostVirtualKeyEvent(vk: Word; fUp: Bool);
var
  AXReg, BXReg: WordRec;
const
  ButtonUp: array[False..True] of Byte = (0, $80);
begin
  AXReg.Hi := ButtonUp[fUp];
  AXReg.Lo := vk;
  BXReg.Hi := 0; { not an extended scan code }
  BXReg.Lo := MapVirtualKey(vk, 0);
  { Special processing for the PrintScreen key. If scan code }
  { is set to 1 it copies entire screen. If set to 0 it }
  { copies active window. We'll just set it to 0 for now }
  if AXReg.Lo = vk_SnapShot then
    BXReg.Lo := 0;
  asm
    mov ax, AXReg
    mov bx, BXReg
    call Keybd_Event
  end;
end;
{$else}
procedure PostVirtualKeyEvent(vk: Word; fUp: Bool);
const
  ButtonUp: array[False..True] of Byte = (0, KEYEVENTF_KEYUP);
var
  ScanCode: Byte;
begin
  if vk <> vk_SnapShot then
    ScanCode := MapVirtualKey(vk, 0)
  else
    { Special processing for the PrintScreen key. If scan code }
    { is set to 1 it copies entire screen. If set to 0 it }
    { copies active window. We'll just set it to 0 for now }
    ScanCode := 0;
  Keybd_Event(vk, ScanCode, ButtonUp[fUp], 0);
end;
{$endif}



{!~ Throws away all keys except 0-9,-,+,.}
Procedure TEditKeyFilter.OnlyNumbers(Sender: TObject; var Key: Char);
Begin
  KeyPressOnlyNumbers(Key);
End;

{!~ Throws away all keys except 0-9}
Procedure TEditKeyFilter.OnlyNumbersAbsolute(Sender: TObject; var Key: Char);
Begin
  KeyPressOnlyNumbersAbsolute(Key);
End;

{!~ Throws away all keys except a-z and A-Z}
Procedure TEditKeyFilter.OnlyAToZ(Sender: TObject; var Key: Char);
Begin
  KeyPressOnlyAToZ(Key);
End;
{!~ Checks whether Delphi is Running and
issues a message if the user doesn't have
the right to use the component}
procedure DelphiCheck(CanRunOutSide: Boolean);
var WindHand : THandle;
    wcnPChar : array[0..32] of char;
    ClName   : array[0..32] of char;
Begin
  If CanRunOutSide Then Exit;
  StrPLCopy(wcnPChar,'TApplication',13);
  {$IFDEF WIN32}
  StrPLCopy(ClName,'Delphi 2.0',11);
  {$ELSE}
  StrPLCopy(ClName,'Delphi',7);
  {$ENDIF}
  WindHand := FindWindow(wcnPChar,ClName);
  If WindHand = 0 Then
  Begin
    MessageDlg(
      'The T*_ads component belongs to Advanced Delphi Systems!',
      mtInformation,
      [mbOk], 0);
    MessageDlg(
      'Please purchase at (301)840-1554',
      mtInformation,
      [mbOk], 0);
  End;
End;

{!~ Checks whether Delphi is Running and
issues a message if the user doesn't have
the right to use the component}
procedure DelphiChecker(
  CanRunOutSide   : Boolean;
  ComponentName   : String;
  OwnerName       : String;
  PurchaseMessage : String;
  ActivateDate    : String);
var WindHand : THandle;
    wcnPChar : array[0..32] of char;
    ClName   : array[0..32] of char;
Begin
  If CanRunOutSide Then Exit;
  StrPLCopy(wcnPChar,'TApplication',13);
  {$IFDEF WIN32}
  StrPLCopy(ClName,'Delphi 2.0',11);
  {$ELSE}
  StrPLCopy(ClName,'Delphi',7);
  {$ENDIF}
  WindHand := FindWindow(wcnPChar,ClName);
  If WindHand = 0 Then
  Begin
    If Date > StrToDate(ActivateDate) Then
    Begin
      MessageDlg(
        ComponentName+' belongs to '+OwnerName+'!',
        mtInformation,
        [mbOk], 0);
      MessageDlg(
        PurchaseMessage,
        mtInformation,
        [mbOk], 0);
    End;
  End;
End;

{!~ Returns True if delphi is running, False otherwise}
Function DelphiIsRunning: Boolean;
var WindHand : THandle;
    wcnPChar : array[0..32] of char;
    ClName   : array[0..32] of char;
Begin
  StrPLCopy(wcnPChar,'TApplication',13);
{$IFDEF WIN32}
  StrPLCopy(ClName,'Delphi 2.0',11);
{$ELSE}
  StrPLCopy(ClName,'Delphi',7);
{$ENDIF}
  WindHand := FindWindow(wcnPChar,ClName);
  If WindHand = 0 Then
  Begin
    Result := false;
  End
  Else
  Begin
    Result := True;
  End;
End;

{!~ Returns True if Delphi is currently running}
Function IsDelphiRunning: Boolean;
Begin
  Result := DelphiIsRunning;
End;

{!~ Allows the programmer to simulate
a keyboard press of a virtual key.
Only one key at a time.}
Function KeySend(VirtualKey: Word): Boolean;
Begin
  Result := SendKey(VirtualKey);
End;
(*
This example moves the current cell in the stringgrid down 1
when the button is pressed.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ads_Sendkey;

type
  TForm1 = class(TForm)
    Button1: TButton;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ActiveControl := StringGrid1;
  KeySend(VK_Down);
end;

end.
*)

{!~ Presents a Message Dialog}
procedure Msg(Msg: String);
Begin
  MessageDlg(
    Msg,
    mtInformation,
    [mbOk], 0);
End;

{!~ Implements final resize tuning}
Procedure ReSizeTuner(ComponentName : String);
Begin
  DelphiChecker(
    RunOutsideIDE_ads,
    ComponentName,
    RunOutsideIDECompany_ads,
    RunOutsideIDEPhone_ads,
    RunOutsideIDEDate_ads);
End;

{!~ Allows the programmer to simulate
a keyboard press of a virtual key.
Only one key at a time.}
Function SendKey(VirtualKey: Word): Boolean;
Begin
  Try
    PostVirtualKeyEvent(VirtualKey,False);
    PostVirtualKeyEvent(VirtualKey,True);
    Result := True;
  Except
    Result := False;
  End;
End;
(*
This example moves the current cell in the stringgrid down 1
when the button is pressed.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ads_Sendkey;

type
  TForm1 = class(TForm)
    Button1: TButton;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ActiveControl := StringGrid1;
  SendKey(VK_Down);
end;

end.
*)

{!~ Returns the Windows User ID.}
Function UserIDFromWindows: string;
Var
  UserName    : string;
  UserNameLen : Dword;
Begin
  UserNameLen := 255;
  SetLength(userName, UserNameLen);
  If GetUserName(PChar(UserName), UserNameLen) Then
    Result := Copy(UserName,1,UserNameLen - 1)
  Else
    Result := 'Unknown';
End;

{!~ Populates a listbox with the executable's version information}
Function VersionInformation(
  ListBox : TListBox): Boolean;
const
  InfoNum = 11;
  InfoStr : array [1..InfoNum] of String =
    ('CompanyName', 'FileDescription', 'FileVersion', 'InternalName',
     'LegalCopyright', 'LegalTradeMarks', 'OriginalFilename',
     'ProductName', 'ProductVersion', 'Comments', 'Author');
  LabelStr : array [1..InfoNum] of String =
    ('Company Name', 'Description', 'File Version', 'Internal Name',
     'Copyright', 'TradeMarks', 'Original File Name',
     'Product Name', 'Product Version', 'Comments', 'Author');
var
  S         : String;
  n, Len    : DWord;
  i         : Integer;
  Buf       : PChar;
  Value     : PChar;
begin
  Try
    S := Application.ExeName;
    ListBox.Items.Clear;
    ListBox.Sorted := True;
    ListBox.Font.Name := 'Courier New';
    n := GetFileVersionInfoSize(LPTSTR(S),n);
    If n > 0 Then
    Begin
      Buf := AllocMem(n);
      ListBox.Items.Add(StringPad('Size',' ',20,True)+' = '+IntToStr(n));
      GetFileVersionInfo(PChar(S),0,n,Buf);
      For i:=1 To InfoNum Do
      Begin
        If VerQueryValue(Buf,PChar('StringFileInfo\040904E4\'+
                                   InfoStr[i]),Pointer(Value),Len) Then
        Begin
          //Value := PChar(Trim(Value));
          If Length(Value) > 0 Then
          Begin
            ListBox.Items.Add(StringPad(labelStr[i],' ',20,True)+' = '+Value);
          End;
        End;
      End;
      FreeMem(Buf,n);
    End
    Else
    Begin
      ListBox.Items.Add('No FileVersionInfo found');
    End;
    Result := True;
  Except
    Result := False;
  End;
End;

End.
{</PRE></BODY></HTML>    }
