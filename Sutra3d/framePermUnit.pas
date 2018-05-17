unit framePermUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Grids, RbwDataGrid4, StdCtrls, ArgusDataEntry, JvPageList,
  JvExControls, ExtCtrls, JvgGroupBox;

type
  TframePerm = class(TFrame)
    JvPageListMain: TJvPageList;
    jvsp0None: TJvStandardPage;
    jvsp1VGEN: TJvStandardPage;
    lbl1SWRES: TLabel;
    lblVN: TLabel;
    ade1SWRES: TArgusDataEntry;
    ade1VN: TArgusDataEntry;
    jvsp2BCOR: TJvStandardPage;
    lbl2PENT: TLabel;
    lbl2RLAMB: TLabel;
    ade2PENT: TArgusDataEntry;
    ade2RLAMB: TArgusDataEntry;
    jvsp3PLIN: TJvStandardPage;
    lbl3SWRES: TLabel;
    lbl3RKRES: TLabel;
    ade3SWRES: TArgusDataEntry;
    ade3RKRES: TArgusDataEntry;
    jvsp5UDEF: TJvStandardPage;
    lbl5NRKPAR: TLabel;
    ade5NRKPAR: TArgusDataEntry;
    rdg5RKPAR: TRbwDataGrid4;
    jvsp4IMPE: TJvStandardPage;
    lbl4OMPOR: TLabel;
    ade4OMPOR: TArgusDataEntry;
    lbl4RKRES: TLabel;
    ade4RKRES: TArgusDataEntry;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    procedure ade5NRKPARExit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure Loaded; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TframePerm.ade5NRKPARExit(Sender: TObject);
var
  AValue: integer;
  Index: integer;
begin
  if TryStrToInt(ade5NRKPAR.Text, AValue) then
  begin
    if AValue < 1 then
    begin
      AValue := 1;
    end;
    rdg5RKPAR.ColCount := AValue;
    for Index := 1 to rdg5RKPAR.ColCount -1 do
    begin
      rdg5RKPAR.Columns[Index] := rdg5RKPAR.Columns[0];
    end;
  end;
end;

procedure AdjustLabelPosition(ALabel: TLabel; AControl: TControl);
begin
  ALabel.Left := AControl.Left - ALabel.Width - 8;
end;

procedure TframePerm.Loaded;
begin
  inherited;
  AdjustLabelPosition(lbl1SWRES, ade1SWRES);
  AdjustLabelPosition(lblVN, ade1VN);

  AdjustLabelPosition(lbl2PENT, ade2PENT);
  AdjustLabelPosition(lbl2RLAMB, ade2RLAMB);

  AdjustLabelPosition(lbl3SWRES, ade3SWRES);
  AdjustLabelPosition(lbl3RKRES, ade3RKRES);

  AdjustLabelPosition(lbl4OMPOR, ade4OMPOR);
  AdjustLabelPosition(lbl4RKRES, ade4RKRES);

  AdjustLabelPosition(lbl5NRKPAR, ade5NRKPAR);
end;

end.
