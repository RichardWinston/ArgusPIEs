unit ModflowMainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, ExtCtrls;

type
  TfrmMODFLOW = class(TForm)
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    tabProject: TTabSheet;
    GroupBox1: TGroupBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMODFLOW: TfrmMODFLOW;

implementation

{$R *.DFM}

end.
