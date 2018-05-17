unit DefaultValueFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ArgusDataEntry;

type
  TFrmDefaultValue = class(TFrame)
    Button1: TButton;
    adePermAngleXY: TArgusDataEntry;
    lblPermAngleXY: TLabel;
  private
    FClassName : string;
    { Private declarations }
  public
    { Public declarations }
  published
    property ClassName : string read FClassName write FClassName;
  end;

procedure Register;

implementation

{$R *.DFM}

procedure Register;
begin
  RegisterComponents('Argus', [TFrmDefaultValue]);
end;



end.
