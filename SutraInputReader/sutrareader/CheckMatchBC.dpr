program CheckMatchBC;

uses
  Forms,
  frmCompareBoundariesUnit in 'frmCompareBoundariesUnit.pas' {frmCompareBoundaries},
  frmAboutUnit in 'frmAboutUnit.pas' {frmAbout};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCompareBoundaries, frmCompareBoundaries);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
