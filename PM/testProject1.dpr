program testProject1;

uses
  Forms,
  test in 'test.pas' {Form1},
  framFilePathUnit in '..\shared\framFilePathUnit.pas' {framFilePath: TFrame};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
