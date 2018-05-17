unit frameMnw2PumpUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Grids, RbwDataGrid4, Spin, StdCtrls, ArgusDataEntry;

type
  TPumpColumns = (pcN, pcLift, pcQ);

  TframeMnw2Pump = class(TFrame)
    Label1: TLabel;
    edPumpName: TEdit;
    Label5: TLabel;
    adeLiftQ0: TArgusDataEntry;
    Label6: TLabel;
    adeLiftQMax: TArgusDataEntry;
    Label7: TLabel;
    adeHWtol: TArgusDataEntry;
    sePumpCap: TSpinEdit;
    Label8: TLabel;
    rdgLiftQ_Table: TRbwDataGrid4;
    procedure rdgLiftQ_TableEndUpdate(Sender: TObject);
    procedure sePumpCapChange(Sender: TObject);
    procedure edPumpNameChange(Sender: TObject);
  private
    FOnPumpNameChanged: TNotifyEvent;
  protected
    procedure SetEnabled(Value: boolean); override;
    { Private declarations }
  public
    property OnPumpNameChanged: TNotifyEvent read FOnPumpNameChanged write FOnPumpNameChanged;
    constructor Create(AOwner: TComponent); override;
    property Enabled: boolean read GetEnabled write SetEnabled;
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TframeMnw2Pump }

constructor TframeMnw2Pump.Create(AOwner: TComponent);
begin
  inherited;
  rdgLiftQ_Table.Cells[Ord(pcN),0] := 'n';
  rdgLiftQ_Table.Cells[Ord(pcLift),0] := 'LIFTn';
  rdgLiftQ_Table.Cells[Ord(pcQ),0] := 'Qn';
  rdgLiftQ_Table.Cells[Ord(pcN),1] := '1';
end;

procedure TframeMnw2Pump.edPumpNameChange(Sender: TObject);
begin
  if Assigned(OnPumpNameChanged) then
  begin
    OnPumpNameChanged(self);
  end;
end;

procedure TframeMnw2Pump.rdgLiftQ_TableEndUpdate(Sender: TObject);
begin
  sePumpCap.Value := rdgLiftQ_Table.RowCount -1;
end;

procedure TframeMnw2Pump.sePumpCapChange(Sender: TObject);
var
  Index: Integer;
begin
  rdgLiftQ_Table.RowCount := sePumpCap.Value + 1;
  for Index := 1 to rdgLiftQ_Table.RowCount - 1 do
  begin
    rdgLiftQ_Table.Cells[Ord(pcN),Index] := IntToStr(Index);
  end;
end;

procedure TframeMnw2Pump.SetEnabled(Value: boolean);
begin
  inherited SetEnabled(Value);
  edPumpName.Enabled := Value;
  adeLiftQ0.Enabled := Value;
  adeLiftQMax.Enabled := Value;
  adeHWtol.Enabled := Value;
  rdgLiftQ_Table.Enabled := Value;
  sePumpCap.Enabled := Value;
end;

end.
