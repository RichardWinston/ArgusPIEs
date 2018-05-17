unit JoinUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Clipbrd, ComCtrls, ArgusFormUnit,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE ;

var
   gJoinContoursPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gJoinContoursPIEImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gDeClutterContoursPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gDeClutterContoursPIEImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

type
  TJoinContoursForm = class(TArgusForm)
    ProgressBar1: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
    function JoinStrings(AString : String; layerHandle : ANE_PTR) : string;
  end;

type
  TContour = class(TObject)
    Value : string;
    Heading : TStringlist;
    Points : TStringList;
    constructor Create;
    Destructor Destroy; override;
    Procedure FixValue(const aneHandle : ANE_PTR);
  end;

var
  JoinContoursForm: TJoinContoursForm;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GJoinContoursPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

implementation

{$R *.DFM}

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, OptionsUnit, DeclutterUnit, UtilityFunctions, ChooseLayerUnit;

//  kMaxFunDesc is the maximum number of PIE's in the dll
// global variables.
//var

//   gHelpPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
//   gHelpImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

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

function TJoinContoursForm.JoinStrings(AString : String; layerHandle : ANE_PTR) : string;
var
  ContourStringList : TStringList;
  ContourList : TList;
  Index, InnerIndex, HeadingIndex, ValueIndex : integer;
  AContour, AnotherContour : TContour;
  HeadingTest : boolean;
  JoinedContourTest : boolean;
  PointsIndex : integer;
  NoContoursFreed : boolean;
  Layer: TLayerOptions;
  Parameter: TParameterOptions;
  ParamTypes: array of TPIENumberType;
  Count: integer;
  TempValue: string;
  Values: TStringList;
  TabPos: integer;
begin
  Layer := TLayerOptions.Create(layerHandle);
  try
    Count := Layer.NumParameters(CurrentModelHandle, pieLayerSubParam);
    SetLength(ParamTypes, Count);
    for Index := 0 to Count -1 do
    begin
      Parameter := TParameterOptions.Create(layerHandle, Index);
      try
        ParamTypes[Index] := Parameter.NumberType[CurrentModelHandle];
      finally
        Parameter.Free;
      end;
    end;
  finally
    Layer.Free(CurrentModelHandle);
  end;


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
        TempValue := Copy(AContour.Value, Pos(Chr(9), AContour.Value)+ 1,
          MAXINT);
        Values := TStringList.Create;
        try
          TabPos := Pos(Chr(9), TempValue);
          While TabPos > 0 do
          begin
            Values.Add(Copy(TempValue, 1, TabPos -1));
            TempValue := Copy(TempValue, TabPos+1, MAXINT);
            TabPos := Pos(Chr(9), TempValue);
          end;
          Values.Add(TempValue);
          Assert(Count >= Values.Count);

          TempValue := '';
          for ValueIndex := 0 to Values.Count -1 do
          begin
            if ValueIndex > 0 then
            begin
              TempValue := TempValue + #9;
            end;

            if ParamTypes[ValueIndex] = pnString then
            begin
              TempValue := TempValue + '"' + Values[ValueIndex] + '"';
            end
            else
            begin
              TempValue := TempValue + Values[ValueIndex];
            end;
          end;
        finally
          Values.Free;
        end;

        AContour.Value := TempValue;

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

  {result := '';
  For index := 0 to ContourStringList.Count -1 do
  begin
    result := result + ContourStringList.strings[index] +  Chr(10);
  end;

  result := result +  Chr(10);     }
  result := GetArgusStr(ContourStringList) +  Chr(10);

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
      layerHandle := GetExistingLayerWithContours(aneHandle,
        [pieInformationLayer, pieDomainLayer]);

      if layerHandle <> nil then
      begin
        ANE_ExportTextFromOtherLayer(aneHandle, layerHandle, @InfoText );
        InfoTextString := String(InfoText);

        JoinContoursForm := TJoinContoursForm.Create(Application);
        JoinContoursForm.CurrentModelHandle := aneHandle;
        JoinContoursForm.Show;
        ImportText := JoinContoursForm.JoinStrings(InfoTextString, layerHandle);
        JoinContoursForm.Free;

        ANE_LayerClear(aneHandle , layerHandle, False );
        ANE_ImportTextToLayerByHandle(aneHandle, layerHandle, PChar(ImportText));
      end;

    end;
  except
    on E: Exception do
      begin
        Beep;
        MessageDlg(E.Message, mtError, [mbOK], 0);
      end;
   end;
end;

procedure GHelpPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  HelpDirectory : string;
begin
  if GetDllDirectory(GetDLLName, HelpDirectory) then
  begin
    Application.HelpFile := HelpDirectory + '\Utility.chm';
    Application.HelpCommand(HELP_FINDER, 0);
  end;
end;



procedure TContour.FixValue(const aneHandle: ANE_PTR);
var
  Delimiter: Char;
  Project: TProjectOptions;
  TabPos: integer;
  TempValue, AValue: string;
  ValueList: TStringList;
  ValueIndex: integer;
  V: double;
  E: integer;
begin
  // This procedure has been copied PointContourUnit.
  // Find out what Argus ONE is using to separate the individual values.
  Project := TProjectOptions.Create;
  try
    Delimiter := Project.ExportDelimiter[aneHandle];
  finally
    Project.Free;
  end;

  // Extract each parameter value and place it in ValueList
  TempValue := Value;
  ValueList := TStringList.Create;
  try
    TabPos := Pos(Delimiter, TempValue);
    while TabPos > 0 do
    begin
      AValue := Copy(TempValue, 1, TabPos -1);
      TempValue := Copy(TempValue, TabPos+1, MAXINT);
      ValueList.Add(AValue);
      TabPos := Pos(Delimiter, TempValue);
    end;
    if TempValue <> '' then
    begin
      ValueList.Add(TempValue);
    end;

    // put the updated paramter values in Value.
    TempValue := '';
    for ValueIndex := 0 to ValueList.Count -1 do
    begin
      AValue := ValueList[ValueIndex];
      // put string paramter values in quotes.
      if (AValue <> 'True') and (AValue <> 'False') then
      begin
        Val(AValue, V, E);
        if E <> 0 then
        begin
          AValue := '"' + AValue + '"';
        end;
      end;
      // Use of #9 rather than Delimiter is correct.
      TempValue := TempValue + #9 + AValue;
    end;
    // delete the #9 at the beginning of TempValue.
    Delete(TempValue, 1, 1);
    Value := TempValue;
  finally
    ValueList.Free;
  end;
end;

end.
