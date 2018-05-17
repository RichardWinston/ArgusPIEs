unit ProgramToRunUnit;

interface

{ProgramToRunUnit defines a enumerated set of values for determining which
 model should be run and a function that is used to determine if the user
 will be allowed to try and run a particular model. These may need to be
 changed in customized versions of the PIE.}

type ProgramToRun = (progMODFLOW, progMODPATH, progZONEBDGT);

function okToRun(AProgram : ProgramToRun) : boolean;

implementation

uses Variables;

function okToRun(AProgram : ProgramToRun) : boolean;
begin
  case AProgram of
    progMODFLOW: result := True;
    progMODPATH: result := frmMODFLOW.cbMODPATH.Checked;
    progZONEBDGT: result := frmMODFLOW.cbZonebudget.Checked;
  else ;
    result := False;
  end;

end;

end.
