unit ModflowHelp;

interface

{ModflowHelp defines a PIE function that displays the help file for the
 MODFLOW GUI when called from the PIEs menu in Argus ONE.}

uses AnePIE, Forms, Windows;

procedure ShowModflowHelp(aneHandle : ANE_PTR;
                  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;

implementation

uses UtilityFunctions, ModflowUnit, Variables, ArgusFormUnit, HH, HH_FUNCS;

procedure ShowModflowHelp(aneHandle : ANE_PTR;
                  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
//var
//  HelpFileDirectory : string;
begin
  InitializeHTMLHELP;
    
//  GetDllDirectory(DLLName, HelpFileDirectory);

//  Application.HelpFile := HelpFileDirectory  + '\' + rsHelpFileName;
  Application.HelpCommand(Help_Context, 10);
end;

end.
