unit frmDataPositionUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TfrmDataPosition = class(TForm)
    PageControl1: TPageControl;
    Panel1: TPanel;
    tabGrid: TTabSheet;
    tabMesh: TTabSheet;
    rgGrid: TRadioGroup;
    rgMesh: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    btnAbout: TButton;
    procedure btnAboutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDataPosition: TfrmDataPosition;

implementation

uses frmAboutUnit;

{$R *.DFM}

procedure TfrmDataPosition.btnAboutClick(Sender: TObject);
begin
  inherited;
  ShowAbout;

end;

end.
