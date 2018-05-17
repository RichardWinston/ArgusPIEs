unit frmTimeConverterUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ArgusDataEntry;

type
  TfrmTimeConverter = class(TForm)
    adeInput: TArgusDataEntry;
    Label1: TLabel;
    Label2: TLabel;
    comboTimeUnits: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    adeOutput: TArgusDataEntry;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    lblSeconds: TLabel;
    lblMinutes: TLabel;
    lblHours: TLabel;
    lblDays: TLabel;
    lblMonths: TLabel;
    lblYears: TLabel;
    procedure adeInputChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure adeOutputChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//function ConvertTimeString(InputString : string) : string;

var
  frmTimeConverter: TfrmTimeConverter;

implementation

{$R *.DFM}

function ConvertTimeString(InputString : string) : string;
begin
  Application.CreateForm(TfrmTimeConverter,frmTimeConverter);
  try
    frmTimeConverter.adeInput.Text := InputString;
    frmTimeConverter.adeOutput.Text := InputString;
    frmTimeConverter.adeOutputChange(nil);
    if frmTimeConverter.ShowModal = mrOK then
    begin
      result := frmTimeConverter.adeOutput.Text
    end
    else
    begin
      result := InputString;
    end;
  finally
    frmTimeConverter.Free;
  end;

end;

procedure TfrmTimeConverter.adeInputChange(Sender: TObject);
var
  Input, Output : double;
begin
  if not (csLoading in ComponentState) then
  begin
    if adeInput.Text <> '' then
    begin
      try
        Input := StrToFloat(adeInput.Text);
        Output := Input;
        case comboTimeUnits.ItemIndex of
          0: // sec
            begin
              Output := Input;
            end;
          1: // min
            begin
              Output := Input*60;
            end;
          2: // hours
            begin
              Output := Input*3600;
            end;
          3: // days
            begin
              Output := Input*3600*24;
            end;
          4: // months
            begin
              Output := Input*3600*24*365.25/12;
            end;
          5: // years
            begin
              Output := Input*3600*24*365.25;
            end;
        else Assert(False);
        end;
        adeOutput.Text := FloatToStr(Output);
      except on EConvertError do
        begin
        end;
      end;

    end;
  end;
end;

procedure TfrmTimeConverter.FormCreate(Sender: TObject);
begin
  comboTimeUnits.ItemIndex := 0;
end;

procedure TfrmTimeConverter.adeOutputChange(Sender: TObject);
var
  Input, Output : double;
begin
  if not (csLoading in ComponentState) then
  begin
    if adeOutput.Text <> '' then
    begin
      Input := StrToFloat(adeOutput.Text);
      Output := Input;
      lblSeconds.Caption := '= ' + adeOutput.Text + ' second';
      if Output <> 1 then
      begin
        lblSeconds.Caption := lblSeconds.Caption + 's';
      end;

      Output := Input/60;
      lblMinutes.Caption := '= ' + FloatToStr(Output) + ' minute';
      if Output <> 1 then
      begin
        lblMinutes.Caption := lblMinutes.Caption + 's';
      end;

      Output := Input/3600;
      lblHours.Caption := '= ' + FloatToStr(Output) + ' hour';
      if Output <> 1 then
      begin
        lblHours.Caption := lblHours.Caption + 's';
      end;

      Output := Input/3600/24;
      lblDays.Caption := '= ' + FloatToStr(Output) + ' day';
      if Output <> 1 then
      begin
        lblDays.Caption := lblDays.Caption + 's';
      end;

      Output := Input/3600/24/365.25*12;
      lblMonths.Caption := '= ' + FloatToStr(Output) + ' month';
      if Output <> 1 then
      begin
        lblMonths.Caption := lblMonths.Caption + 's';
      end;

      Output := Input/3600/24/365.25;
      lblYears.Caption := '= ' + FloatToStr(Output) + ' year';
      if Output <> 1 then
      begin
        lblYears.Caption := lblYears.Caption + 's';
      end;

    end;
  end;
end;

end.
