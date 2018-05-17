unit frmPolyhedronChoiceUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, addbtn95, Buttons;

type
  TfrmPolyhedronChoice = class(TForm)
    gbPolyhedron: TGroupBox;
    rbMemory: TRadioButton95;
    rbStore: TRadioButton95;
    rbRead: TRadioButton95;
    rbCompute: TRadioButton95;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPolyhedronChoice: TfrmPolyhedronChoice;

implementation

{$R *.DFM}

end.
