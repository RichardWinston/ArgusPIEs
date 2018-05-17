unit frmDistributeParticlesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, Buttons, ArgusDataEntry;

type
  TfrmDistributeParticles = class(TArgusForm)
    Label1: TLabel;
    adeRows: TArgusDataEntry;
    Label2: TLabel;
    adeCols: TArgusDataEntry;
    Label3: TLabel;
    adeLayers: TArgusDataEntry;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDistributeParticles: TfrmDistributeParticles;

implementation

{$R *.DFM}

end.
 