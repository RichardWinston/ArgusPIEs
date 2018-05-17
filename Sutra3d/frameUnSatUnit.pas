unit frameUnSatUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ArgusDataEntry, JvPageList, Grids,
  RbwDataGrid4, ExtCtrls, JvExControls;

type
  TframeUnsat = class(TFrame)
    JvPageListMain: TJvPageList;
    jvsp0None: TJvStandardPage;
    jvsp1VGEN: TJvStandardPage;
    lbl1SWRES: TLabel;
    ade1SWRES: TArgusDataEntry;
    lblVN: TLabel;
    ade1VN: TArgusDataEntry;
    jvsp2BCOR: TJvStandardPage;
    lbl1AA: TLabel;
    ade1AA: TArgusDataEntry;
    lbl2SWRES: TLabel;
    ade2SWRES: TArgusDataEntry;
    lbl2PENT: TLabel;
    ade2PENT: TArgusDataEntry;
    lbl2RLAMB: TLabel;
    ade2RLAMB: TArgusDataEntry;
    jvsp3PLIN: TJvStandardPage;
    lbl3SWRES: TLabel;
    ade3SWRES: TArgusDataEntry;
    lbl3PENT: TLabel;
    ade3PENT: TArgusDataEntry;
    lbl3PSWRES: TLabel;
    ade3PSWRES: TArgusDataEntry;
    jvsp4UDEF: TJvStandardPage;
    lbl4NSWPAR: TLabel;
    ade4NSWPAR: TArgusDataEntry;
    rdg4SWPAR: TRbwDataGrid4;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    GroupBox1: TGroupBox;
    procedure ade4NSWPARExit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure Loaded; override; 
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TframeUnsat.ade4NSWPARExit(Sender: TObject);
var
  AValue: integer;
  Index: integer;
begin
  if TryStrToInt(ade4NSWPAR.Text, AValue) then
  begin
    if AValue < 1 then
    begin
      AValue := 1;
    end;
    rdg4SWPAR.ColCount := AValue;
    for Index := 1 to rdg4SWPAR.ColCount -1 do
    begin
      rdg4SWPAR.Columns[Index] := rdg4SWPAR.Columns[0];
    end;
  end;
end;

procedure AdjustLabelPosition(ALabel: TLabel; AControl: TControl);
begin
  ALabel.Left := AControl.Left - ALabel.Width - 8;
end;

procedure TframeUnsat.Loaded;
begin
  inherited;
  AdjustLabelPosition(lbl4NSWPAR, ade4NSWPAR);

  AdjustLabelPosition(lbl3SWRES, ade3SWRES);
  AdjustLabelPosition(lbl3PSWRES, ade4NSWPAR);
  AdjustLabelPosition(lbl4NSWPAR, ade3PSWRES);

  AdjustLabelPosition(lbl2SWRES, ade2SWRES);
  AdjustLabelPosition(lbl2PENT, ade2PENT);
  AdjustLabelPosition(lbl2RLAMB, ade2RLAMB);

  AdjustLabelPosition(lbl1SWRES, ade1SWRES);
  AdjustLabelPosition(lbl1AA, ade1AA);
  AdjustLabelPosition(lblVN, ade1VN);
end;

end.
