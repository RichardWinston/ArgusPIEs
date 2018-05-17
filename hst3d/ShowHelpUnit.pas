unit ShowHelpUnit;

interface

uses AnePIE, classes, windows;

procedure ShowHST3DHelp(aneHandle : ANE_PTR;
          const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;

procedure ShowSpecificHTMLHelp(HtmlPage : string);

implementation

uses SysUtils, forms, ShellAPI,  HST3D_PIE_Unit, ANECB ;

procedure ShowHST3DHelp(aneHandle : ANE_PTR;
          const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
var
  HelpfileName : string;
  filepath : string;
begin
      filepath := ExtractFileDir(Application.ExeName);
      filepath := LowerCase(filepath);
      if Pos('datfiles', filepath) > 0 then
      begin
        filepath := Copy(filepath, 1, Pos('datfiles', filepath) -1);
      end;
      filepath := filepath + '\ArgusHelp\HST3D_Help';
      HelpfileName := filepath + '\hst3d_pie.htm';
      ShellExecute(Application.Handle, nil,
        PChar(HelpfileName), '', PChar(filepath), SW_SHOWNORMAL);
end;

procedure ShowSpecificHTMLHelp(HtmlPage : string);
var
  fileName : string;
  filepath : string;
  Html : TStringList;

begin
  Html := TStringList.Create;
  Try
    begin

      Html.Add('<FRAMESET cols="20%,*">');
      Html.Add('   <FRAME src="hst3d_text/side.htm">');
      Html.Add('   <FRAME src="hst3d_text/' + HtmlPage + '" name="main">');
      Html.Add('<NOFRAMES>');
      Html.Add('<a href="hst3d_text/'  + HtmlPage
        + '">Go to non-frames version</a>');
      Html.Add('</NOFRAMES>');
      Html.Add('</FRAMESET>');

      filepath := ExtractFileDir(Application.ExeName);
      filepath := LowerCase(filepath);
      if Pos('datfiles', filepath) > 0 then
      begin
        filepath := Copy(filepath, 1, Pos('datfiles', filepath) -1);
      end;
      filepath := filepath + '\ArgusHelp\HST3D_Help';
      Filename := filepath + '\lasthelp.htm';
      Html.SaveToFile(Filename);
      
      ShellExecute(Application.Handle, nil,
        PChar(FileName), '', PChar(filepath), SW_SHOWNORMAL);
    end;
  finally
    begin
      Html.Free;
    end;
  end;

end;


end.
 