unit DecayConstCalculator;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ArgusDataEntry;

type
  TfrmDecayConstCalculator = class(TForm)
    adeHalfLife: TArgusDataEntry;
    adeProductionTerm: TArgusDataEntry;
    Label76: TLabel;
    Label72: TLabel;
    comboHalfLifeTimeUnits: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    lblSec: TLabel;
    lblMin: TLabel;
    lblHours: TLabel;
    lblDays: TLabel;
    lblWeeks: TLabel;
    lblMonths: TLabel;
    lblYears: TLabel;
    procedure adeHalfLifeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure GetData(DecayCoefficient : double);
    { Public declarations }
  end;

var
  frmDecayConstCalculator: TfrmDecayConstCalculator;

implementation

{$R *.DFM}

procedure TfrmDecayConstCalculator.adeHalfLifeChange(Sender: TObject);
var
  TimeFactor : double;
  HalfLife : double;
  Value : double;
begin
  inherited;
  if not (csLoading in ComponentState) then
  begin
    if (adeHalfLife.Text = '0') or (adeHalfLife.Text = '')
      or (adeHalfLife.Text = '-') or (adeHalfLife.Text = '+')
      or (StrToFloat(adeHalfLife.Text) = 0) then
    begin
      adeProductionTerm.Text := '0';
      lblSec.Caption := 'half life = 0 seconds';
      lblMin.Caption := 'half life = 0 minutes';
      lblHours.Caption := 'half life = 0 hours';
      lblDays.Caption := 'half life = 0 days';
      lblWeeks.Caption := 'half life = 0 weeks';
      lblMonths.Caption := 'half life = 0 months';
      lblYears.Caption := 'half life = 0 years';
    end
    else
    begin
      TimeFactor := 1;
      case comboHalfLifeTimeUnits.ItemIndex of
        0: TimeFactor := 1;  // seconds
        1: TimeFactor := 60;  // minutes
        2: TimeFactor := 3600;  // hours
        3: TimeFactor := 3600*24;  // days
        4: TimeFactor := 3600*24*7;  // weeks
        5: TimeFactor := 3600*24*365.25/12;  // months
        6: TimeFactor := 3600*24*365.25;  // years
      else Assert(False);
      end;
      HalfLife := TimeFactor * StrToFloat(adeHalfLife.Text);
      adeProductionTerm.Text := FloatToStr(ln(2)/HalfLife);

      Value := HalfLife;
      lblSec.Caption := 'half life = ' + FloatToStr(Value) + ' second';
      if Value <> 1 then
      begin
        lblSec.Caption := lblSec.Caption + 's';
      end;

      Value := HalfLife/60;
      lblMin.Caption := 'half life = ' + FloatToStr(Value) + ' minute';
      if Value <> 1 then
      begin
        lblMin.Caption := lblMin.Caption + 's';
      end;

      Value := HalfLife/3600;
      lblHours.Caption := 'half life = ' + FloatToStr(Value) + ' hour';
      if Value <> 1 then
      begin
        lblHours.Caption := lblHours.Caption + 's';
      end;

      Value := HalfLife/3600/24;
      lblDays.Caption := 'half life = ' + FloatToStr(Value) + ' day';
      if Value <> 1 then
      begin
        lblDays.Caption := lblDays.Caption + 's';
      end;

      Value := HalfLife/3600/24/7;
      lblWeeks.Caption := 'half life = ' + FloatToStr(Value) + ' week';
      if Value <> 1 then
      begin
        lblWeeks.Caption := lblWeeks.Caption + 's';
      end;

      Value := HalfLife/3600/24/365.25*12;
      lblMonths.Caption := 'half life = ' + FloatToStr(Value) + ' month';
      if Value <> 1 then
      begin
        lblMonths.Caption := lblMonths.Caption + 's';
      end;

      Value := HalfLife/3600/24/365.25;
      lblYears.Caption := 'half life = ' + FloatToStr(Value) + ' year';
      if Value <> 1 then
      begin
        lblYears.Caption := lblYears.Caption + 's';
      end;

    end;
  end;
end;

procedure TfrmDecayConstCalculator.FormCreate(Sender: TObject);
begin
  comboHalfLifeTimeUnits.ItemIndex := 0;
end;

procedure TfrmDecayConstCalculator.GetData(DecayCoefficient: double);
begin
  if DecayCoefficient = 0 then
  begin
    adeHalfLife.Text := '0';
  end
  else
  begin
    adeHalfLife.Text := FloatToStr(ln(2)/DecayCoefficient);
  end
end;

end.
