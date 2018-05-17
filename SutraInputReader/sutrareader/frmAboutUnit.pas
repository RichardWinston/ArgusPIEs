unit frmAboutUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VersInfo, StdCtrls, Buttons, ExtCtrls, ASLink;

type
  TfrmAbout = class(TForm)
    VersionInfo1: TVersionInfo;
    Image1: TImage;
    Label1: TLabel;
    lblVersion: TLabel;
    BitBtn1: TBitBtn;
    ASLink1: TASLink;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.DFM}

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  lblVersion.Caption := VersionInfo1.FileVersion;
end;

end.
