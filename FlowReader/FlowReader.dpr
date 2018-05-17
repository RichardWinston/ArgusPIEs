program FlowReader;

uses
  Forms,
  frmFlowReader in 'frmFlowReader.pas' {frmCellFlows},
  IntListUnit in '..\shared\IntListUnit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCellFlows, frmCellFlows);
  Application.Run;
end.
