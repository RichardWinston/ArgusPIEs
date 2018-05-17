unit frameRegionParamsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, frameIceSatUnit, frameUnSatUnit, framePermUnit, ExtCtrls;

type
  TframeRegionParams = class(TFrame)
    frameRelativePermeability: TframePerm;
    frameUnsat: TframeUnsat;
    frameIceSat: TframeIceSat;
    pnlCaption: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
