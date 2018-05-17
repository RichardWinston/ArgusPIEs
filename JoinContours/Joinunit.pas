unit JoinUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Clipbrd, ComCtrls,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE ;

type
  TJoinContoursForm = class(TForm)
    ProgressBar1: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
    function JoinStrings(AString : String) : string;
  end;

type
  TContour = class(TObject)
    Value : string;
    Heading : TStringlist;
    Points : TStringList;
    constructor Create;
    Destructor Destroy; override;
  end;

var
  JoinContoursForm: TJoinContoursForm;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

procedure GJoinContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

implementation

{$R *.DFM}

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, DeclutterUnit, UtilityFunctions;

//  kMaxFunDesc is the maximum number of PIE's in the dll
const kMaxFunDesc = 3;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts

   gJoinContoursPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gJoinContoursPIEImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gDeClutterContoursPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gDeClutterContoursPIEImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gHelpPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gHelpImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

constructor TContour.Create;
begin
    inherited;
    Heading := TStringlist.Create;
    Points := TStringList.Create;
end;

destructor TContour.Destroy;
begin
  Heading.Free;
  Points.Free;
  Inherited;
end;

function TJoinContoursForm.JoinStrings(AString : String) : string;
var
  ContourStringList : TStringList;
  ContourList : TList;
  Index, InnerIndex, HeadingIndex : integer;
  AContour, AnotherContour : TContour;
  HeadingTest : boolean;
  JoinedContourTest : boolean;
  PointsIndex : integer;
  NoContoursFreed : boolean;
begin
  ContourStringList := TStringList.Create;
  ContourList := TList.Create;
  ContourStringList.Text := AString;
  AContour := nil;
  HeadingTest := True;
  ProgressBar1.StepIt;
  For Index := 0 to ContourStringList.Count -1 do
  begin
    if Pos('## Name:', ContourStringList.Strings[Index]) > 0 then
    begin
      AContour := TContour.Create;
      ContourList.Add(AContour);
      HeadingTest := True;
    end;
    if not (AContour = nil) then
    begin
      if HeadingTest
      then
        begin
          AContour.Heading.Add(ContourStringList.Strings[Index]);
        end
      else
        begin
          if not (ContourStringList.Strings[Index] = '') then
          begin
            AContour.Points.Add(ContourStringList.Strings[Index]);
          end;
        end;
      if Pos('# X pos', ContourStringList.Strings[Index]) > 0 then
      begin
        HeadingTest := False;
      end;
    end;
  end;
  ProgressBar1.StepIt;
  For index := 0 to ContourList.Count -1 do
  begin
    AContour := ContourList.Items[index];
    for HeadingIndex := 0 to AContour.Heading.Count -1 do
    begin
      if Pos('# Points Count', AContour.Heading.Strings[HeadingIndex]) > 0 then
      begin
        AContour.Value := AContour.Heading.Strings[HeadingIndex + 1];
        AContour.Value := Copy(AContour.Value, Pos(Chr(9), AContour.Value)+ 1,
                          Length(AContour.Value));
        break;
      end;
    end;
  end;

  ProgressBar1.StepIt;
  repeat
    NoContoursFreed := True;
    if ContourList.Count > 1 then
    begin
      AContour := ContourList.Items[ContourList.Count -1];
      While ContourList.IndexOf(AContour) > 0 do
      begin
        index := ContourList.IndexOf(AContour)-1;
        For InnerIndex := index downto 0 do
        begin
          AnotherContour := ContourList.Items[InnerIndex];
          if AContour.Value = AnotherContour.Value then
          begin
            JoinedContourTest := False;

            if AContour.Points.Strings[0] = AnotherContour.Points.Strings[0] then
            begin
                JoinedContourTest := True;
                for PointsIndex := 1 to AnotherContour.Points.Count -1 do
                begin
                  AContour.Points.Insert(0,AnotherContour.Points.Strings[PointsIndex]);
                end;
            end;

            if not JoinedContourTest then
            begin
              if AContour.Points.Strings[0] =
                 AnotherContour.Points.Strings[AnotherContour.Points.Count -1] then
              begin
                  JoinedContourTest := True;
                  for PointsIndex := AnotherContour.Points.Count -2 downto 0 do
                  begin
                    AContour.Points.Insert(0,AnotherContour.Points.Strings[PointsIndex]);
                  end;
              end;
            end;

            if not JoinedContourTest then
            begin
              if AContour.Points.Strings[AContour.Points.Count -1] =
                 AnotherContour.Points.Strings[0] then
              begin
                  JoinedContourTest := True;
                  for PointsIndex := 1 to AnotherContour.Points.Count -1 do
                  begin
                    AContour.Points.Add(AnotherContour.Points.Strings[PointsIndex]);
                  end;
              end;
            end;

            if not JoinedContourTest then
            begin
              if AContour.Points.Strings[AContour.Points.Count -1] =
                 AnotherContour.Points.Strings[AnotherContour.Points.Count -1] then
              begin
                  JoinedContourTest := True;
                  for PointsIndex := AnotherContour.Points.Count -2 downto 0 do
                  begin
                    AContour.Points.Add(AnotherContour.Points.Strings[PointsIndex]);
                  end;
              end;
            end;

            if JoinedContourTest then
            begin
              ContourList.Remove(AnotherContour);
              AnotherContour.Free;
              NoContoursFreed := False;
            end;

          end;
        end;
        index := ContourList.IndexOf(AContour)-1;
        if Index > -1 then
        begin
          AContour := ContourList.Items[index];
        end;
      end;
    end;
  until NoContoursFreed ;


  ProgressBar1.StepIt;
  For index := 0 to ContourList.Count -1 do
  begin
    AContour := ContourList.Items[index];
    for HeadingIndex := 0 to AContour.Heading.Count -1 do
    begin
      if Pos('# Points Count', AContour.Heading.Strings[HeadingIndex]) > 0 then
      begin
        AContour.Heading.Strings[HeadingIndex + 1] :=
           IntToStr(AContour.Points.Count) + Chr(9) + AContour.Value;
        break;
      end;
    end;
  end;

  ProgressBar1.StepIt;
  ContourStringList.Text := '';
  For index := 0 to ContourList.Count -1 do
  begin
    AContour := ContourList.Items[index];
    AContour.Points.Add('');
    ContourStringList.Text := ContourStringList.Text + AContour.Heading.Text + AContour.Points.Text;
  end;

  result := '';
  For index := 0 to ContourStringList.Count -1 do
  begin
    result := result + ContourStringList.strings[index] + {Chr(13) +} Chr(10);
  end;

  result := result + {Chr(13) +} Chr(10);

  ProgressBar1.StepIt;
  ContourStringList.Free;
  for index := ContourList.Count -1 downto 0 do
  begin
    AContour := ContourList.Items[index];
    AContour.Free;
  end;
  ContourList.Free;

end;

procedure GJoinContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  InfoText : ANE_STR;
  InfoTextString : String;
  ImportText : string;
begin
  try
    begin
          ANE_ExportTextFromOtherLayer(aneHandle, layerHandle, @InfoText );
          InfoTextString := String(InfoText);

          JoinContoursForm := TJoinContoursForm.Create(Application);
          JoinContoursForm.Show;
          ImportText := JoinContoursForm.JoinStrings(InfoTextString);
          JoinContoursForm.Free;

          ANE_LayerClear(aneHandle , layerHandle, False );
          ANE_ImportTextToLayerByHandle(aneHandle, layerHandle, PChar(ImportText));

    end;
   except
     on Exception do
        begin
        end;
   end;
end;

procedure GHelpPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  HelpDirectory : string;
begin
  if GetDllDirectory('JoinContoursPie.dll', HelpDirectory) then
  begin
    Application.HelpFile := HelpDirectory + '\JoinContours.hlp';
    Application.HelpCommand(HELP_FINDER, 0);
  end;
end;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

	numNames := 0;
	gJoinContoursPIEImportPIEDesc.version := IMPORT_PIE_VERSION;
	gJoinContoursPIEImportPIEDesc.name := 'Join Contours';   // name of project
	gJoinContoursPIEImportPIEDesc.importFlags := kImportFromLayer;
 	gJoinContoursPIEImportPIEDesc.fromLayerTypes := kPIEInformationLayer  {* was kPIETriMeshLayer*/};
 	gJoinContoursPIEImportPIEDesc.toLayerTypes := kPIEInformationLayer  {* was kPIETriMeshLayer*/};
 	gJoinContoursPIEImportPIEDesc.doImportProc := @GJoinContoursPIE;// address of Post Processing Function function

	// prepare PIE descriptor for Example Delphi PIE
	gJoinContoursPIEDesc.name := 'Join Contours';      // PIE name
	gJoinContoursPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gJoinContoursPIEDesc.descriptor := @gJoinContoursPIEImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gJoinContoursPIEDesc;
        Inc(numNames);	// add descriptor to list


	gDeClutterContoursPIEImportPIEDesc.version := IMPORT_PIE_VERSION;
	gDeClutterContoursPIEImportPIEDesc.name := 'Declutter Contours';   // name of project
	gDeClutterContoursPIEImportPIEDesc.importFlags := kImportFromLayer;
 	gDeClutterContoursPIEImportPIEDesc.fromLayerTypes := kPIEInformationLayer  {* was kPIETriMeshLayer*/};
 	gDeClutterContoursPIEImportPIEDesc.toLayerTypes := kPIEInformationLayer  {* was kPIETriMeshLayer*/};
 	gDeClutterContoursPIEImportPIEDesc.doImportProc := @GDeclutterContoursPIE;// address of Post Processing Function function

	// prepare PIE descriptor for Example Delphi PIE
	gDeClutterContoursPIEDesc.name := 'Declutter Contours';      // PIE name
	gDeClutterContoursPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gDeClutterContoursPIEDesc.descriptor := @gDeClutterContoursPIEImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gDeClutterContoursPIEDesc;
        Inc(numNames);	// add descriptor to list

	gHelpImportPIEDesc.version := IMPORT_PIE_VERSION;
	gHelpImportPIEDesc.name := 'Declutter/Join Contours Help';   // name of project
	gHelpImportPIEDesc.importFlags := kImportAllwaysVisible;
 	gHelpImportPIEDesc.fromLayerTypes := kPIEAnyLayer  {* was kPIETriMeshLayer*/};
 	gHelpImportPIEDesc.toLayerTypes := kPIEAnyLayer  {* was kPIETriMeshLayer*/};
 	gHelpImportPIEDesc.doImportProc := @GHelpPIE;// address of Post Processing Function function

	// prepare PIE descriptor for Example Delphi PIE
	gHelpPIEDesc.name := 'Declutter/Join Contours Help';      // PIE name
	gHelpPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gHelpPIEDesc.descriptor := @gHelpImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gHelpPIEDesc;
        Inc(numNames);	// add descriptor to list

	descriptors := @gFunDesc;
end;

end.
