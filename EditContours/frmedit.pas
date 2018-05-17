unit frmEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frmZoomUnit, ComCtrls, StdCtrls, Buttons, ExtCtrls, RBWZoomBox;

type
  TfrmEditNew = class(TfrmZoom)
    BitBtn1: TBitBtn;
    StatusBar1: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TLocalPoint = class(TArgusPoint)
    procedure Draw; override;
    class Function GetZoomBox : TRBWZoomBox; override;
  end;

  TLocalContour = class(TContour)
    Procedure Draw; override;
  end;


var
  frmEditNew: TfrmEditNew;

implementation

{$R *.DFM}

end.
