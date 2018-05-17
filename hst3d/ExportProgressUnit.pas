unit ExportProgressUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls;

type
  TfrmExportProgress = class(TForm)
    ProgressBar1: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmExportProgress: TfrmExportProgress;

implementation

{$R *.DFM}

end.
