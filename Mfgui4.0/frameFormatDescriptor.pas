unit frameFormatDescriptor;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ArgusDataEntry;

type
  TframeFormat = class(TFrame)
    comboP: TComboBox;
    comboREdit: TComboBox;
    adeW: TArgusDataEntry;
    Label1: TLabel;
    adeD: TArgusDataEntry;
    lblResult: TLabel;
    procedure comboPChange(Sender: TObject);
    procedure adeDExit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure SetEnabled(Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    Function FortranFormat: string;
    { Public declarations }
  end;

implementation

{$R *.DFM}

{ TFrame1 }

constructor TframeFormat.Create(AOwner: TComponent);
begin
  inherited;
  comboP.ItemIndex := 1;
  comboREdit.ItemIndex := 2;
  comboPChange(nil)
end;

function TframeFormat.FortranFormat: string;
begin
  result := '''(10(1X'
    {$IFDEF MODFLOWBUGFIXED}
    + ','
    {$ENDIF}
    + comboP.Text + comboREdit.Text
    + adeW.Text + '.' + adeD.Text + '))'''
end;

procedure TframeFormat.comboPChange(Sender: TObject);
begin
  lblResult.Caption := FortranFormat;
end;

procedure TframeFormat.SetEnabled(Value: Boolean);
begin
  inherited;
  comboP.Enabled := Value;
  comboREdit.Enabled := Value;
  adeW.Enabled := Value;
  adeD.Enabled := Value;
  if Value then
  begin
    comboP.Color := clWindow;
    comboREdit.Color := clWindow;
  end
  else
  begin
    comboP.Color := clBtnFace;
    comboREdit.Color := clBtnFace;
  end;

end;

procedure TframeFormat.adeDExit(Sender: TObject);
var
  NewMin: integer;
begin
  NewMin := StrToInt(adeD.Text) + 7;
  if NewMin > StrToInt(adeW.Text) then
  begin
    adeW.Text := IntToStr(NewMin);
  end;
  adeW.Min := NewMin;
end;

end.
