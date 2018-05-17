unit frameIceSatUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Grids, RbwDataGrid4, StdCtrls, ArgusDataEntry, JvPageList,
  JvExControls, ExtCtrls;

type
  TframeIceSat = class(TFrame)
    JvPageListMain: TJvPageList;
    jvsp0None: TJvStandardPage;
    jvsp1EXPO: TJvStandardPage;
    lbl1SWRESI: TLabel;
    lblW: TLabel;
    ade1SWRESI: TArgusDataEntry;
    ade1W: TArgusDataEntry;
    jvsp2PLIN: TJvStandardPage;
    lbl2SWRESI: TLabel;
    lbl2TSWRESI: TLabel;
    ade2SWRESI: TArgusDataEntry;
    ade2TSWRESI: TArgusDataEntry;
    jvsp3UDEF: TJvStandardPage;
    lbl3NSIPAR: TLabel;
    ade3NSIPAR: TArgusDataEntry;
    rdg3SIPAR: TRbwDataGrid4;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    procedure ade3NSIPARExit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure Loaded; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TframeIceSat.ade3NSIPARExit(Sender: TObject);
var
  AValue: integer;
  Index: integer;
begin
  if TryStrToInt(ade3NSIPAR.Text, AValue) then
  begin
    if AValue < 1 then
    begin
      AValue := 1;
    end;
    rdg3SIPAR.ColCount := AValue;
    for Index := 1 to rdg3SIPAR.ColCount -1 do
    begin
      rdg3SIPAR.Columns[Index] := rdg3SIPAR.Columns[0];
    end;
  end;
end;

procedure AdjustLabelPosition(ALabel: TLabel; AControl: TControl);
begin
  ALabel.Left := AControl.Left - ALabel.Width - 8;
end;

procedure TframeIceSat.Loaded;
begin
  inherited;
  AdjustLabelPosition(lbl1SWRESI, ade1SWRESI);
  AdjustLabelPosition(lblW, ade1W);

  AdjustLabelPosition(lbl2SWRESI, ade2SWRESI);
  AdjustLabelPosition(lbl2TSWRESI, ade2TSWRESI);

  AdjustLabelPosition(lbl3NSIPAR, ade3NSIPAR);
end;

end.
