unit DecayCalculator;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, StdCtrls, ArgusDataEntry, Buttons;

type
  TfrmDecayCalculator = class(TArgusForm)
    adeHalfLife: TArgusDataEntry;
    lblHalfLine: TLabel;
    comboHalfLifeTimeUnits: TComboBox;
    adeProductionTerm: TArgusDataEntry;
    lblProductionTerm: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure adeHalfLifeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
  private
    { Private declarations }
  public
    Procedure GetData;
    { Public declarations }
  end;

var
  frmDecayCalculator: TfrmDecayCalculator;

implementation

uses Variables, UtilityFunctions;

{$R *.DFM}

procedure TfrmDecayCalculator.adeHalfLifeChange(Sender: TObject);
var
  TimeFactor1, TimeFactor2 : double;
  HalfLife : double;
begin
  inherited;
  if not (csLoading in ComponentState) then
  begin
    if (adeHalfLife.Text = '0') or (adeHalfLife.Text = '')
      or (adeHalfLife.Text = '+') or (adeHalfLife.Text = '-')
      or (InternationalStrToFloat(adeHalfLife.Text) = 0) then
    begin
      adeProductionTerm.Text := '0';
    end
    else
    begin
      TimeFactor1 := 1;
      TimeFactor2 := 1;
      case comboHalfLifeTimeUnits.ItemIndex of
        0: TimeFactor1 := 1;  // seconds
        1: TimeFactor1 := 60;  // minutes
        2: TimeFactor1 := 3600;  // hours
        3: TimeFactor1 := 3600*24;  // days
        4: TimeFactor1 := 3600*24*7;  // weeks
        5: TimeFactor1 := 3600*24*365.25/12;  // months
        6: TimeFactor1 := 3600*24*365.25;  // years
      else Assert(False);
      end;
      case frmModflow.comboTimeUnits.ItemIndex of
        0: TimeFactor2 := 1;  // Undefined
        1: TimeFactor2 := 1;  // Seconds
        2: TimeFactor2 := 60;  // minutes
        3: TimeFactor2 := 3600;  // hours
        4: TimeFactor2 := 3600*24;  // days
        5: TimeFactor2 := 3600*24*365.25;  // years
      else Assert(False);
      end;
      HalfLife := TimeFactor1/TimeFactor2 * InternationalStrToFloat(adeHalfLife.Text);
      adeProductionTerm.Text := FloatToStr(ln(2)/HalfLife);
    end;
  end;
end;

procedure TfrmDecayCalculator.GetData;
var
//  TimeFactor1, TimeFactor2 : double;
//  HalfLife : double;
  Text : string;
begin
  case frmMODFLOW.comboTimeUnits.ItemIndex of
    0:
      begin
        lblProductionTerm.Caption := 'First order decay rate (s^-1)';
        comboHalfLifeTimeUnits.ItemIndex := 0;
      end;
    1:
      begin
        lblProductionTerm.Caption := 'First order decay rate (s^-1)';
        comboHalfLifeTimeUnits.ItemIndex := 0;
      end;
    2:
      begin
        lblProductionTerm.Caption := 'First order decay rate (min^-1)';
        comboHalfLifeTimeUnits.ItemIndex := 1;
      end;
    3:
      begin
        lblProductionTerm.Caption := 'First order decay rate (hr^-1)';
        comboHalfLifeTimeUnits.ItemIndex := 2;
      end;
    4:
      begin
        lblProductionTerm.Caption := 'First order decay rate (day^-1)';
        comboHalfLifeTimeUnits.ItemIndex := 3;
      end;
    5:
      begin
        lblProductionTerm.Caption := 'First order decay rate (yr^-1)';
        comboHalfLifeTimeUnits.ItemIndex := 6;
      end;
  else
      begin
        lblProductionTerm.Caption := 'First order decay rate (s^-1)';
        comboHalfLifeTimeUnits.ItemIndex := 0;
      end;
  end;
  Text := frmMODFLOW.adeMOC3DDecay.Text;
  if (Text = '0') or (Text = '')
    or (InternationalStrToFloat(Text) = 0) then
  begin
    adeHalfLife.Text := '0';
  end
  else
  begin
    adeHalfLife.Text := FloatToStr(ln(2)/InternationalStrToFloat(Text));
  end;
end;

procedure TfrmDecayCalculator.FormCreate(Sender: TObject);
begin
  comboHalfLifeTimeUnits.ItemIndex := 0;
end;

end.
