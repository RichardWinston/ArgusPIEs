unit Variables;

interface

{Variables defines the most important global variables in the PIE. It also
 creates an instance of TModflowTypesClass.}

uses GetTypesUnit, ModflowUnit, RunUnit, PostMODFLOW, SelectPostFile,
  WellDataUnit, WarningsUnit;

// It is possible to customize the MODFLOW PIE by deriving new classes from
// the existing classes and changing this file.

// To do this:
// 1. Derive a new Edit Project Info dialog box from TfrmMODFLOW
//    and replace the declaration of frmMODFLOW in this file with the
//    new class. If other forms need to be changed, make the changes
//    by deriving from the existing forms.
// 2. Add new components and event handlers as needed on your form derived
//    TfrmMODFLOW. Avoid using the default names for components. Such names may
//    conflict with the names of components added to the PIE later.
// 3. On your new form, either make Image1 invisible or load a new image
//    into it to distinguish your customized PIE from the PIE maintained
//    by the USGS.
// 4. Derive new classes from the existing classes to define new layers
//    and parameters.
// 5. If you need to change the existing layers or parameters do the following:
//      A. Derive a new class from the class that needs to be changed
//      B. derive a new class from TModflowTypesClass
//      C. In the class created in step B,
//         override the function that returned the type of the class you have
//         changed in step A so that it returns your class.
//      D. Change the declaration of ModflowTypes to be your class derived
//         from ModflowTypes in step B.
//      E. Change the initialization section of this file to create
//         ModflowTypes as the new type.
// 6. Provide a new GetANEFunctionsUnit with any new PIE descriptors you
//    require. Don't change GetMODFLOWFunctions unless you absolutely
//    have to. Instead, it is better to write your own similar function
//    in a separate unit and just add those functions that aren't already
//    present in GetMODFLOWFunctions.
// 7. Change "rsDeveloper" in this file to give yourself as developer.
// 8. For new controls, I suggest using help context numbers >= 20000
//    to distinguish them from help in the USGS version of the PIE
//    You can override the AssignHelpFile functions to put your help
//    in a separate file from that used by the USGS version of the PIE. 
// 9. In general, the only files you should need to change are
//    MFGUI_30.dpr, GetANEFunctionsUnit.pas, ProgramToRunUnit,
//    CustomizedPieFunctions and this file.
//    Other changes should normally be done in new files.

// If you follow these guidelines, your customized version can be updated
// easily when new functionality is added to the PIE maintained by the USGS.
// All you will have to do is replace any old files with new ones from the PIE
// maintained by the USGS except for MFGUI_30.dpr,
// GetANEFunctionsUnit.pas and this file.
// You will also have to update kMaxPIEDesc in GetANEFunctionsUnit.pas to
// reflect the new number of functions and you may have to modify your
// version of MFGUI_30.dpr to include units not present in the old
// version of the PIE.

const
  MaxObsWellParameters = 5;

resourcestring
  rsDeveloper = 'USGS: Richard B. Winston, rbwinst@usgs.gov';
  rsHelpFileName = 'MODFLOW.chm';

{type
  TProjectRecord = record
    MainForm : TfrmMODFLOW;
  end;

  PProjectRecord = ^TProjectRecord;  }

var
  ModflowTypes : TModflowTypesClass;
  frmMODFLOW: TfrmMODFLOW;
  frmRun: TfrmRun;
  frmMODFLOWPostProcessing: TfrmMODFLOWPostProcessing;
  frmSelectPostFile: TfrmSelectPostFile;
  frmWellData: TfrmWellData;
  frmWarnings: TfrmWarnings;

function LengthUnit: string;
function TimeUnit: string;
function MT3DMassUnit: string;

implementation

function LengthUnit: string;
begin
  result := frmModflow.LengthUnit;
end;

function TimeUnit: string;
begin
  result := frmModflow.TimeUnit;
end;

function MT3DMassUnit: string;
begin
  result := frmModflow.MT3DMassUnit;
end;

initialization
begin
  ModflowTypes := TModflowTypesClass.Create;
end;

finalization
begin
  ModflowTypes.Free;
end;

end.
