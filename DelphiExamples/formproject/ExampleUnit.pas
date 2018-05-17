unit ExampleUnit;

// Save TD32 information and used Turbo debugger to debug.
// (Project|Options|Linker|Include TD32 debug information)
// Start Turbo Debugger32
// Click F3 and enter the name of your dll.
// Start Argus ONE.
// After Argus ONE has started, attach to ArgusONE.dll.
// From the File menu change to the directory with the source code of the PIE.
// Click F3 and double click on your dll
// Click F3 again and load the source files.
// You can now set breakpoints in the dll.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,

  ProjectPIE, AnePIE;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

function GDisplayProjectForm (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

type
  TExampleForm = class(TForm)
    Label1: TLabel;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExampleForm: TExampleForm;

implementation

{$R *.DFM}

const
  kMaxPIEDesc = 20;

var
gSimpleProjectPDesc : ProjectPIEDesc ;
gSimpleProjectDesc : ANEPIEDesc ;

gPIEDesc : Array [0..kMaxPIEDesc-1] of ^ANEPIEDesc;



function GDisplayProjectForm (Handle : ANE_PTR ; rPIEHandle :  ANE_PTR_PTR ;
         rLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;
var
  ExampleForm  : TExampleForm ;
begin

  Try
    ExampleForm := TExampleForm.Create(Application);
    ExampleForm.ShowModal;
  finally
    ExampleForm.Free;

  end;

  {Because we aren't actually creating a new project here, the
  result is 0 (= False for an ANE_BOOL). If we did create a project
  the result should be 1 (= True for an ANE_BOOL).}

  result := 0;

end; { GSimpleExportTemplate }

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;

	gSimpleProjectPDesc.version := PROJECT_PIE_VERSION;
	gSimpleProjectPDesc.name := 'Display a Delphi Form';
	gSimpleProjectPDesc.projectFlags := 0;
	gSimpleProjectPDesc.createNewProc := GDisplayProjectForm;
	gSimpleProjectPDesc.editProjectProc := nil;
	gSimpleProjectPDesc.cleanProjectProc := nil;
	gSimpleProjectPDesc.saveProc := nil;
	gSimpleProjectPDesc.loadProc := nil;

	gSimpleProjectDesc.name  := 'Display a Delphi Form';
	gSimpleProjectDesc.PieType :=  kProjectPIE;
	gSimpleProjectDesc.descriptor := @gSimpleProjectPDesc;

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert(numNames < kMaxPIEDesc);
	gPIEDesc[numNames] := @gSimpleProjectDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	descriptors := @gPIEDesc;

end;

end.
