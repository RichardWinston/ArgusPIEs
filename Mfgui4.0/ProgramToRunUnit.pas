unit ProgramToRunUnit;

interface

{ProgramToRunUnit defines a enumerated set of values for determining which
 model should be run and a function that is used to determine if the user
 will be allowed to try and run a particular model. These may need to be
 changed in customized versions of the PIE.}

type TProgramToRun = (progMODFLOW, progMODPATH, progZONEBDGT, progYCINT,
  progBEALE, progMT3D, progSEAWAT, progGWM);

function okToRun(AProgram : TProgramToRun) : boolean;

implementation

uses Variables;

function okToRun(AProgram : TProgramToRun) : boolean;
begin
  case AProgram of
    progMODFLOW: result := True;
    progMODPATH: result := frmMODFLOW.cbMODPATH.Checked;
    progZONEBDGT: result := frmMODFLOW.cbZonebudget.Checked;
    progYCINT : result := frmMODFLOW.cbYcint.Checked
      and frmMODFLOW.cbYcint.Enabled;
    progBEALE : result := frmMODFLOW.cbBeale.Checked
      and frmMODFLOW.cbBeale.Enabled;
    progMT3D : result := frmMODFLOW.rbMODFLOW2000.Checked
      and frmMODFLOW.cbMT3D.Checked;
    progSEAWAT: result := frmMODFLOW.cbSeaWat.Checked
      and frmMODFLOW.rbMODFLOW2000.Checked;
    progGWM: result := frmMODFLOW.cb_GWM.Checked
      and (frmMODFLOW.rbMODFLOW2000.Checked or frmMODFLOW.rbMODFLOW2005.Checked);
  else
    result := False;
    Assert(False);
  end;

end;

end.
