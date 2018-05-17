unit ImportUnit;

// Save TD32 information and used Turbo debugger to debug.
// Click F3 and enter the name of your dll.
// After Argus ONE has started attach to ArgusONE.dll.
// From the File menu change to the directory with the source code of the PIE.
// Click F3 and double click on your dll
// Click F3 again and loadthe source files.
// You can now set breakpoints in the dll.

interface

uses
  SysUtils, Dialogs,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE ;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

procedure GDelphiPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, ContourListUnit;


//  kMaxFunDesc is the maximum number of PIE's in the dll
const kMaxFunDesc = 1;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts
   gDelphiPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gDelphiPIEImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor


// This reads an integer from the begining of a string and returns
//the integer and the string with the integer removed.
// This procedure is untested.
Procedure ReadIntFromString(var AString : string; var AnInteger : Longint);
var
  i : integer;
  AChar : char;
  IntString : string;
begin
  for i := 1 to Length(AString) do
    begin
      AChar := AString[1];
      case AChar of
       '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.' :
         begin
           break;
         end;
       else
         begin
           AString := Copy(AString, 2, Length(AString) );
         end;
      end;
    end;
  for i := 1 to Length(AString) do
    begin
      AChar := AString[i];
      case AChar of
       '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.' :
         begin
           Continue;
         end;
       else
         begin
           IntString := Copy(AString, 1, i-1 );
           try
             AnInteger := StrToInt(IntString);
           except
             on EConvertError do
               begin
                 ShowMessage('Error Converting "' + IntString +
                                    '" to an integer');
                 AnInteger := 0;
                 break;
               end;
           end;
           AString := Copy(AString, i, Length(AString) );
           break;
         end;
      end;
    end

end;

// This reads an double from the begining of a string and returns
// the double and the string with the double removed.
Procedure ReadDoubleFromString(var AString : string; var ADouble : double);
var
  i : integer;
  AChar : char;
  FloatString : string;
begin
  for i := 1 to Length(AString) do
    begin
      AChar := AString[1];
      case AChar of
       '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', 'E', 'e' :
         begin
           break;
         end;
       else
         begin
           AString := Copy(AString, 2, Length(AString) );
         end;
      end;
    end;
  for i := 1 to Length(AString) do
    begin
      AChar := AString[i];
      case AChar of
       '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', 'E', 'e' :
         begin
           Continue;
         end;
       else
         begin
           FloatString := Copy(AString, 1, i-1 );
           try
             ADouble := StrToFloat(FloatString);
           except
             on EConvertError do
               begin
                 ShowMessage('Error Converting "' + FloatString +
                                    '" to an double');
                 ADouble := 0;
                 break;
               end;
           end;
           AString := Copy(AString, i, Length(AString) );
           break;
         end;
      end;
    end

end;


// import data from a text file.
procedure GDelphiPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
{*************************************************************************
**************************************************************************
**
** This function is where 'Import' extension works.
**
** The imput parameters are:
**	aneHandler - a handle that you pass to Argus Numerical Environmets API
**	fileName  - the file name of the file selected by the user (if you asked one)
**	layerHandle - (for future use) the handle of the layer selected by the user 
**			this handle will be used to get information from this layer
**
** This function is very simple:
** It reads three numbers from a text file and treats them as the description of
** a circle, It then calculates the position of a circle (polygon actually)
** and calls the function ANE_ImportTextToLayer(aneHandle, imp) to place those points
** on the layer.
**	aneHandle is the first parameter transfered to this function
**	imp is the import string
**
** Where to go from here?
** 
**  Many options are available, including displaying a dilaog and using
** the parameter from the dialog to create informatin, or even creating random
** infromation, without using any data, either from user, or from a file.
**************************************************************************
*************************************************************************}

var
//  ImportFile : Text;
//  ALine : string;
//  centerx, centery, radius : double;
//  numPoints : integer;
//  i : integer;
//  angle, X, Y : double;
//ImportText : string;
  ContourANE_STR : ANE_STR;
  ContourList : TContourList;
  Index : integer;
  AContour : TContour;
begin
  ANE_ExportTextFromOtherLayer(aneHandle, layerHandle, @ContourANE_STR );
  ContourList := TContourList.Create;
  try
    ContourList.ReadContours(String(ContourANE_STR));
  finally
    for Index := ContourList.Count -1 downto 0 do
    begin
      AContour := ContourList[Index];
      AContour.Free;
    end;

    ContourList.Free;
  end;

{   AssignFile(ImportFile, String(fileName));
   Reset(ImportFile);
   Readln(ImportFile, ALine);
   ReadDoubleFromString(ALine, centerx);
   ReadDoubleFromString(ALine, centery);
   ReadDoubleFromString(ALine, radius);
   numPoints := 20;
   // Chr(13) is a carraige return
   // Chr(10) is a new-line character
   // Both are required at the end of each line
   ImportText := IntToStr(numPoints +1) + ' ' + FloatToStr(Pi*Sqr(radius))
              + Chr(13) + Chr(10);
   for i := 0 to numPoints do
     begin
       angle := 2*Pi*i/numPoints;
       X := centerx + radius * Cos(angle);
       Y := centery + radius * Sin(angle);
       ImportText := ImportText + FloatToStr(X) + ' ' + FloatToStr(Y)
                  + Chr(13) + Chr(10);
     end;
   ImportText := ImportText + Chr(13) + Chr(10) ;
   ANE_ImportTextToLayer(aneHandle, PChar(ImportText)); }
end;



procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;
	gDelphiPIEImportPIEDesc.version := IMPORT_PIE_VERSION;
	gDelphiPIEImportPIEDesc.name := 'Contour2Direction';   // name of project
	gDelphiPIEImportPIEDesc.importFlags := kImportFromLayer;
 	gDelphiPIEImportPIEDesc.toLayerTypes := kPIEDataLayer {* was kPIETriMeshLayer*/};
 	gDelphiPIEImportPIEDesc.fromLayerTypes := kPIEInformationLayer {* was kPIETriMeshLayer*/};
 	gDelphiPIEImportPIEDesc.doImportProc := @GDelphiPIE;// address of Post Processing Function function

	//
	// prepare PIE descriptor for Example Delphi PIE

	gDelphiPIEDesc.name := 'Contour2Direction';      // PIE name
	gDelphiPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gDelphiPIEDesc.descriptor := @gDelphiPIEImportPIEDesc;	// pointer to descriptor

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gDelphiPIEDesc;
        Inc(numNames);	// add descriptor to list

	descriptors := @gFunDesc;
end;



end.
 