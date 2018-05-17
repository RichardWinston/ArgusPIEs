unit ProgramToRunUnit;

interface

type ProgramToRun = (progMODFLOW, progMODPATH, progZONEBDGT, progMT3D);

function okToRun(AProgram : ProgramToRun) : boolean;

implementation

uses Variables;

function okToRun(AProgram : ProgramToRun) : boolean;
begin
  case AProgram of
    progMODFLOW: result := True;
    progMODPATH: result := frmMODFLOW.cbMODPATH.Checked;
    progZONEBDGT: result := frmMODFLOW.cbZonebudget.Checked;
    progMT3D: result := frmMODFLOW.cbMT3D.Checked;
    else result := False;
  end;

end;

end.
