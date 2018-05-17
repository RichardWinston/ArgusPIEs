unit frmSutraPostUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  TfrmPostSutra = class(TForm)
    ListView1: TListView;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbOverlay: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPostSutra: TfrmPostSutra;

implementation

{$R *.DFM}

end.
