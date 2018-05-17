unit GetANEFunctionsUnit;

interface

uses
//  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
//  StdCtrls, ComCtrls, Clipbrd,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE {, ImportPIE, ExtCtrls, Buttons, ArgusDataEntry, WriteContourUnit,
     PointContourUnit} ;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

implementation

uses {ANECB,} InterpolationPIE, TriangulationUnit;

const
  kMaxFunDesc = 1;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts

   gTriangulationPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gTriangulationInterpolatePIEDesc : InterpolationPIEDesc;                // ImportPIE descriptor



procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
//var
////  UsualOptions : EFunctionPIEFlags;
//  FileName : string;
begin
  {$ASSERTIONS ON}
  {Assertions are a debugging tool. They should be turned off
  in the final version. They are useful for "Just-in-time" debugging
  with Turbo-Debugger 32. See Delphi help for more information.}

{  FileName := GetDLLName;
  GetDllDirectory(FileName, FileName);
  FileName := FileName + '\Utility.Hlp';
  Application.HelpFile := FileName;  }

//  UsualOptions := 0;

  numNames := 0;

  gTriangulationInterpolatePIEDesc.version := INTERPOLATION_PIE_VERSION;
  gTriangulationInterpolatePIEDesc.name := 'DelaunayTriangulation';
  gTriangulationInterpolatePIEDesc.interpolationFlags := kInterpolationCallPre or kInterpolationShouldClean;
  gTriangulationInterpolatePIEDesc.preProc := @InitializeTriangulation;//InitializeQTN5;		// function address
  gTriangulationInterpolatePIEDesc.evalProc := @EvaluateTriangulation;		// return value type
  gTriangulationInterpolatePIEDesc.cleanProc :=  @FreeTriangulation;			// number of parameters
  gTriangulationInterpolatePIEDesc.neededProject := nil;	// pointer to parameters types list

  gTriangulationPIEDesc.name  := 'DelaunayTriangulation';		// name of PIE
  gTriangulationPIEDesc.PieType :=  kInterpolationPIE;		// PIE type: PIE function
  gTriangulationPIEDesc.descriptor := @gTriangulationInterpolatePIEDesc ;	// pointer to descriptor

  Assert (numNames < kMaxFunDesc) ;
  gFunDesc[numNames] := @gTriangulationPIEDesc  ;  // add descriptor to list
  Inc(numNames);	// increment number of names

  descriptors := @gFunDesc;

//  Application.HelpFile
end;


end.
