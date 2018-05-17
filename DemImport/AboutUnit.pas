unit AboutUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ASLink, ExtCtrls, verslab;

type
  TfrmAbout = class(TForm)
    Image1: TImage;
    ASLink1: TASLink;
    BitBtn1: TBitBtn;
    VersionLabel1: TVersionLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.DFM}

end.
