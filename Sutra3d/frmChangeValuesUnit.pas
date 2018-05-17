unit frmChangeValuesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ARGUSFORMUNIT, StdCtrls, Buttons, ExtCtrls, CheckLst, ArgusDataEntry;

type
  TfrmChangeValues = class(TArgusForm)
    clbValuesToChange: TCheckListBox;
    Panel1: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure btnOKClick(Sender: TObject);
  private
    NewValues: TStringList;
    { Private declarations }
  public
    Procedure AddValueToChange(const Control: TArgusDataEntry;
      const ALabel: TLabel; const NewValue: string);
    function ShouldShow: boolean;
    { Public declarations }
  end;

var
  frmChangeValues: TfrmChangeValues;

implementation

uses UtilityFunctions;

{$R *.DFM}

procedure TfrmChangeValues.AddValueToChange(const Control: TArgusDataEntry;
  const ALabel: TLabel; const NewValue: string);
var
  ValuesDifferent: boolean;
begin
  if (Control.Text <> NewValue) then
  begin
    ValuesDifferent := False;
    case Control.DataType of
      dtReal:  
        begin
          ValuesDifferent := InternationalStrToFloat(Control.Text)
            <> InternationalStrToFloat(NewValue)
        end;
      dtInteger:
        begin
          ValuesDifferent := StrToInt(Control.Text)
            <> StrToInt(NewValue)
        end;
    else Assert(False);
    end;

    if ValuesDifferent then
    begin
      if Control.Enabled then
      begin
        clbValuesToChange.Items.AddObject('Change ' + Control.Text + ' to '
          + NewValue + ' for ' + ALabel.Caption, Control);
        NewValues.Add(NewValue);
        clbValuesToChange.Checked[clbValuesToChange.Items.Count -1] := True;
      end
      else
      begin
        Control.Text := NewValue
      end;
    end;
  end;
end;

procedure TfrmChangeValues.FormCreate(Sender: TObject);
begin
  inherited;
  NewValues := TStringList.Create;
end;

procedure TfrmChangeValues.FormDestroy(Sender: TObject);
begin
  NewValues.Free;
  inherited;
end;

function TfrmChangeValues.ShouldShow: boolean;
begin
  result := NewValues.Count > 0;
end;

procedure TfrmChangeValues.btnOKClick(Sender: TObject);
var
  Control: TArgusDataEntry;
  Index: integer;
begin
  inherited;
  for Index := 0 to clbValuesToChange.Items.Count -1 do
  begin
    if clbValuesToChange.Checked[Index] then
    begin
      Control := clbValuesToChange.Items.Objects[Index] as TArgusDataEntry;
      Control.Text := NewValues[Index];
    end;
  end;
end;

end.
