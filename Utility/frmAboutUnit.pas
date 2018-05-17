unit frmAboutUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ASLink, StdCtrls, ExtCtrls, Buttons;

type
  TfrmAbout = class(TForm)
    ImageLogo: TImage;
    lblName: TLabel;
    ASLinkEmail: TASLink;
    Label1: TLabel;
    lblVersion: TLabel;
    ASLinkWebPage: TASLink;
    btnOK: TBitBtn;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAbout;

var
  frmAbout: TfrmAbout;

implementation

uses
  JvVersionInfo, ArgusFormUnit;

{$R *.DFM}

function FileVersion(const FileName: string): string;
var
  VerInfo: TJvVersionInfo;
begin
  VerInfo := TJvVersionInfo.Create(FileName);
  try
    result := VerInfo.FileVersion;
  finally
    VerInfo.Free;
  end;
end;


procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  lblVersion.Caption := FileVersion(DllName);
  Memo1.Lines.Add('Winston, R.B., 2001, Programs for Simplifying the '
    + 'Analysis of Geographic Information in U.S. Geological Survey '
    + 'Ground-Water Models: U.S. Geological Survey Open-File Report 01-392, '
    + '67 p.');
end;

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure ShowAbout;
begin
  Application.CreateForm(TfrmAbout, frmAbout);
  try
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;
end;

end.
