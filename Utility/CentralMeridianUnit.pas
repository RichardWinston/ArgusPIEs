unit CentralMeridianUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfrmCentralMeridian = class(TForm)
    rgCentralMeridians: TRadioGroup;
    Panel1: TPanel;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure rgCentralMeridiansClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCentralMeridian: TfrmCentralMeridian;

implementation

{$R *.DFM}

procedure TfrmCentralMeridian.rgCentralMeridiansClick(Sender: TObject);
begin
  BitBtn1.Enabled := True;
end;

end.
