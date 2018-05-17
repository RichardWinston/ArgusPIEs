unit WriteContourUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, grids, AnePIE, PointContourUnit;

type
  EUnmatchedQuote = Class(Exception);

  TfrmWriteContour = class(TArgusForm)
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean; 
  private
    { Private declarations }
  protected
    procedure AssignHelpFile(FileName: string);
    procedure ReadValuesFromStringList(const AStringList : TStringList;
      const AStringGrid : TStringGrid; const ReadTabValues : boolean); virtual;
    function GridValuesOK(
  const AStringGrid: TStringGrid; MaxColumn : integer = 2;
    CheckAllColumns : boolean = True): boolean;
  public
    ContourList : TList;
    procedure KillContourList;
    function WriteContours: string;
    procedure ReadArgusData(const ADataString: String;
      const ContourType : TContourClass;
      const AnArgusPointClass: TArgusPointClass); virtual;
    function IsArgusContours(ContourStringList: TStringList) : boolean; virtual;
    procedure ReadArgusContours(const AString : String;
      const ContourType : TContourClass;
      const AnArgusPointClass: TArgusPointClass); virtual;
    procedure SetColumnWidths(const AStringGrid: TStringGrid);
    function GetLayerHandle : ANE_PTR;
    { Public declarations }
  end;

procedure ReadTabValuesString(var AString, ASubstring : string);

var
  frmWriteContour: TfrmWriteContour;

implementation

{$R *.DFM}

uses {EditUnit,} UtilityFunctions, OptionsUnit, ChooseLayerUnit, ANE_LayerUnit,
  ANECB;

procedure ReadCommaValuesString(var AString, ASubstring : string);
var
  CharIndex : integer;
  BeginIndex, EndIndex : integer;
  NextDoubleQuote, NextSingleQuote, NextQuote : integer;
  NextComma, NextSpace, NextTab : integer;
begin
  BeginIndex := 1;
  for CharIndex := 1 to Length(AString) do
  begin
    BeginIndex := CharIndex;
    if not ((AString[CharIndex] = Chr(9)) or
            (AString[CharIndex] = ' ') or
            (AString[CharIndex] = ',')) then
    begin
      break;
    end;
  end;
  if Length(AString) < BeginIndex then
  begin
    if (AString[BeginIndex] = '"') or (AString[BeginIndex] = '''') then
    begin
      AString := Copy(AString, BeginIndex + 1, Length(AString));
      NextDoubleQuote := Pos('"',AString);
      NextSingleQuote := Pos('''',AString);
      NextQuote := 0;
      if NextDoubleQuote > 0 then
      begin
        NextQuote := NextDoubleQuote;
      end;
      if NextSingleQuote > 0 then
      begin
        if (NextQuote = 0) or (NextSingleQuote < NextQuote) then
        begin
          NextQuote := NextSingleQuote;
        end;
      end;
      if NextQuote > 0 then
      begin
        ASubstring := Copy(AString,0,NextQuote-1);
        AString := Copy(AString, NextQuote+1, Length(AString));
      end
      else
      begin
        raise EUnmatchedQuote.Create('Unmatched Quote');
      end;
    end
    else
    begin
      AString := Copy(AString,BeginIndex,Length(AString));
      NextComma := Pos(',',AString);
      NextSpace := Pos(' ',AString);
      NextTab := Pos(Chr(9),AString);
      EndIndex := Length(AString)+1;
      if (NextComma > 0) and (NextComma < EndIndex) then
      begin
        EndIndex := NextComma;
      end;
      if (NextSpace > 0) and (NextSpace < EndIndex) then
      begin
        EndIndex := NextSpace;
      end;
      if (NextTab > 0) and (NextTab < EndIndex) then
      begin
        EndIndex := NextTab;
      end;
      ASubstring := Copy(AString,0,EndIndex-1);
      AString := Copy(AString,EndIndex+1,Length(AString));
    end;
  end;
end;

procedure ReadTabValuesString(var AString, ASubstring : string);
var
  BeginIndex : integer;
begin
  BeginIndex := Pos(Chr(9),AString);
  if BeginIndex = 0 then
  begin
    ASubstring := AString;
    AString := '';
  end
  else
  begin
    ASubstring := Copy(AString,0,BeginIndex-1);
    if Length(ASubstring) > 0 then
    begin
      while ASubstring[1] = '"' do
      begin
        ASubstring := Copy(ASubstring,2,Length(ASubstring));
      end;
    end;
    if Length(ASubstring) > 0 then
    begin
      while ASubstring[Length(ASubstring)] = '"' do
      begin
        ASubstring := Copy(ASubstring,1,Length(ASubstring)-1);
      end;
    end;
    AString := Copy(AString,BeginIndex+1,Length(AString));
  end;
end;



function TfrmWriteContour.WriteContours: string;
var
  ContourStringList : TStringList;
  Index : integer;
  AContour : TContour;
  InnerIndex : integer;
begin
  ContourStringList := TStringList.Create;
  ContourStringList.Text := '';
  For index := 0 to ContourList.Count -1 do
  begin
    AContour := ContourList.Items[index];
    AContour.PointsToStrings;
    AContour.PointStrings.Add('');
    for InnerIndex := 0 to AContour.Heading.Count -1 do
    begin
        ContourStringList.Add(AContour.Heading[InnerIndex]);
    end;
    for InnerIndex := 0 to AContour.PointStrings.Count -1 do
    begin
      ContourStringList.Add(AContour.PointStrings[InnerIndex]);
    end;

//    ContourStringList.Text := ContourStringList.Text + AContour.Heading.Text + AContour.PointStrings.Text;
  end;

  result := '';
  For index := 0 to ContourStringList.Count -1 do
  begin
    result := result + ContourStringList.strings[index] + Chr(10);
  end;

  result := result + Chr(10);

  ContourStringList.Free;

end;

procedure TfrmWriteContour.FormCreate(Sender: TObject);
begin
  inherited;
  if ContourList = nil then
  begin
    ContourList := TList.Create;
  end;

end;

procedure TfrmWriteContour.KillContourList;
var
  Index : integer;
  AContour : TContour;
begin
  if ContourList <> nil then
  begin
    for index := ContourList.Count -1 downto 0 do
    begin
      AContour := ContourList.Items[index];
      AContour.Free;
    end;
    FreeAndNil(ContourList);
  end;
end;

procedure TfrmWriteContour.FormDestroy(Sender: TObject);
begin
  KillContourList;

  inherited;
end;

procedure TfrmWriteContour.ReadValuesFromStringList(const AStringList : TStringList;
  const AStringGrid : TStringGrid; const ReadTabValues : boolean);
var
  Index : integer;
  ColIndex : integer;
  AString , ASubstring : string;
  StrLength : integer;
  Titles : TStringList;
begin
    Titles := TStringList.Create;
    try

      for Index := AStringList.Count -1 downto 0 do
      begin
        AString := AStringList[Index];
        StrLength := Length(AString);
        if (StrLength = 0) or ((StrLength > 0) and (AString[1] = '#')) then
        begin
          if StrLength > 0 then
          begin
            AString := Copy(AString,2,Length(AString));
            Titles.Insert(0,AString);
          end;
          AStringList.Delete(Index);
        end;
      end;

      AStringGrid.RowCount := AStringList.Count + 2;

{      for ColIndex := 1 to AStringGrid.ColCount -1 do
      begin
        if AStringGrid.Cells[ColIndex, 1] = '' then
        begin
          AStringGrid.Cells[ColIndex, 1] := '';
        end;
      end; }
      for Index := 0 to Titles.Count -1 do
      begin
        ColIndex := 1;
        AString := Titles[Index];
        while Length(AString) > 0 do
        begin
          if AStringGrid.ColCount < ColIndex + 1 then
          begin
            AStringGrid.ColCount := ColIndex + 1;
          end;
          if ReadTabValues then
          begin
            ReadTabValuesString(AString, ASubstring);
          end
          else
          begin
            ReadCommaValuesString(AString, ASubstring);
          end;
          AStringGrid.Cells[ColIndex, 1] := Trim(AStringGrid.Cells[ColIndex, 1]
            + ' ' + ASubstring);
          if Assigned(AStringGrid.OnSetEditText) then
          begin
            AStringGrid.OnSetEditText(AStringGrid,ColIndex, 1, AStringGrid.Cells[ColIndex, 1]);
          end;
          Inc(ColIndex);
        end;
      end;
    finally
      Titles.Free;
    end;
    for Index := 0 to AStringList.Count -1 do
    begin
      ColIndex := 1;
      AString := AStringList[Index];
      AStringGrid.cells[0,Index + 2] := IntToStr(Index + 1);
      while Length(AString) > 0 do
      begin
        if AStringGrid.ColCount < ColIndex + 1 then
        begin
          AStringGrid.ColCount := ColIndex + 1;
        end;
        if ReadTabValues then
        begin
          ReadTabValuesString(AString, ASubstring);
        end
        else
        begin
          ReadCommaValuesString(AString, ASubstring);
        end;
        AStringGrid.Cells[ColIndex, Index + 2] := ASubstring;
        if Assigned(AStringGrid.OnSetEditText) then
        begin
          AStringGrid.OnSetEditText(AStringGrid,ColIndex, Index + 2, ASubstring);
        end;
        Inc(ColIndex);
      end;
    end;
    for ColIndex := 1 to AStringGrid.ColCount -1 do
    begin
      if AStringGrid.Cells[ColIndex, 1] = '' then
      begin
        AStringGrid.Cells[ColIndex, 1] := 'Imported Parameter ' + IntToStr(ColIndex);
        if Assigned(AStringGrid.OnSetEditText) then
        begin
          AStringGrid.OnSetEditText(AStringGrid,ColIndex, 1, AStringGrid.Cells[ColIndex, 1]);
        end;
      end;
    end;

end;

procedure TfrmWriteContour.SetColumnWidths(const AStringGrid : TStringGrid);
var
  ColIndex, RowIndex, ColWidth, tempColWidth : integer;
begin
  for ColIndex := 0 to AStringGrid.ColCount -1  do
  begin
    ColWidth := AStringGrid.ColWidths[ColIndex];
    for RowIndex := 0 to AStringGrid.RowCount -1 do
    begin
      tempColWidth := AStringGrid.Canvas.TextWidth
        (AStringGrid.Cells[ColIndex,RowIndex])+ 20;
      if tempColWidth > ColWidth then
      begin
        ColWidth := tempColWidth;
      end;
    end;
    AStringGrid.ColWidths[ColIndex] := ColWidth;
  end;
end;

procedure TfrmWriteContour.AssignHelpFile(FileName : string);
var
    DllDirectory : String;
begin
  // called by FormHelp

  // This procedure assigns the proper help file to the application.
  // It may be overridden in descendent classes.
  if GetDllDirectory(DLLName, DllDirectory )
  then
    begin
      HelpFile := DllDirectory + '\' + FileName; // MODFLOW.hlp';
    end
  else
    begin
      Beep;
      ShowMessage(DLLName + ' not found.');
    end;
end;

function TfrmWriteContour.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  inherited;
  AssignHelpFile('EditContours.hlp');
  result := True;
end;

procedure TfrmWriteContour.ReadArgusContours(const AString : String;
      const ContourType : TContourClass;
      const AnArgusPointClass: TArgusPointClass);
var
  ContourStringList : TStringList;
  Index : integer;
  AContour : TContour;
  HeadingTest : boolean;
begin
  ContourStringList := TStringList.Create;
  try
    ContourList := TList.Create;
    ContourStringList.Text := AString;
    AContour := nil;
    HeadingTest := False;
    For Index := 0 to ContourStringList.Count -1 do
    begin
      if ContourStringList.Strings[Index] = '' then
      begin
        HeadingTest := False;
      end;
      if not HeadingTest and (Pos('#', ContourStringList.Strings[Index]) > 0) then
      begin
        AContour := ContourType.Create(AnArgusPointClass);
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
              AContour.PointStrings.Add(ContourStringList.Strings[Index]);
            end;
          end;
        if Pos('# X pos', ContourStringList.Strings[Index]) > 0 then
        begin
          HeadingTest := False;
        end;
      end;
    end;
    For index := 0 to ContourList.Count -1 do
    begin
      AContour := ContourList.Items[index];
      if not AContour.PointsReady then
      begin
        AContour.StringsToPoints;
      end;
      if AContour.FPoints.Count > 1 then
      begin
        if (AContour.PointValues[0].X = AContour.PointValues[AContour.FPoints.Count-1].X) and
           (AContour.PointValues[0].y = AContour.PointValues[AContour.FPoints.Count-1].y) then
        begin
          TArgusPoint(AContour.FPoints.Items[AContour.FPoints.Count-1]).Free;
          AContour.FPoints.Items[AContour.FPoints.Count-1] := AContour.FPoints.Items[0];
        end;
      end;
    end;

  finally
    ContourStringList.Free;
  end;

end;

procedure TfrmWriteContour.ReadArgusData(const ADataString: String;
      const ContourType : TContourClass;
      const AnArgusPointClass: TArgusPointClass);
var
  ContourStringList : TStringList;
  Index : integer;
  AContour : TContour;
//  Value : String;
  TabPosition : integer;
  ADataPointString : String;
  X, Y : double;
  APoint : TArgusPoint;

begin
  ContourStringList := TStringList.Create;
  try
    if ContourList = nil then
    begin
      ContourList := TList.Create;
    end;
    ContourStringList.Text := ADataString;
    For Index := 2 to ContourStringList.Count -1 do
    begin
      ADataPointString := ContourStringList[Index];
      if ADataPointString <> '' then
      begin
        AContour := ContourType.Create(AnArgusPointClass);
        ContourList.Add(AContour);

        TabPosition := Pos(Chr(9), ADataPointString);
        X := InternationalStrToFloat(Copy(ADataPointString,1,TabPosition-1));
        ADataPointString := Copy(ADataPointString, TabPosition+1, Length(ADataPointString));

        TabPosition := Pos(Chr(9), ADataPointString);
        Y := InternationalStrToFloat(Copy(ADataPointString,1,TabPosition-1));
        ADataPointString := Copy(ADataPointString, TabPosition+1, Length(ADataPointString));

        AContour.Heading.Add('## Name:');
        AContour.Heading.Add('## Icon:0');
        AContour.Heading.Add('# Points Count' + Chr(9) + 'Value');
        AContour.Heading.Add('1' + Chr(9) + ADataPointString);
        AContour.Heading.Add('# X pos' + Chr(9) + 'Y pos');

        APoint := AnArgusPointClass.Create;
        APoint.X := X;
        APoint.Y := Y;
        AContour.FPoints.Add(APoint);
      end;

    end;
  finally

  ContourStringList.Free;
  end;

end;

function TfrmWriteContour.IsArgusContours(ContourStringList: TStringList): boolean;
const
  InnerLimit = 3;
var
  Index, InnerIndex : integer;
  Limit : integer;
  Headings : array[0..InnerLimit] of string;
  AString : string;
begin
  result := False;
  Headings[0] := '## Name';
  Headings[1] := '## Icon';
  Headings[2] := '# Points Count';
  Headings[3] := '# X pos';
  if ContourStringList.Count > 10 then
  begin
    Limit := 10;
  end
  else
  begin
    Limit := ContourStringList.Count - 1;
  end;
  for Index := 0 to Limit do
  begin
    AString := ContourStringList[Index];
    for InnerIndex := 0 to InnerLimit do
    begin
      if Pos(Headings[InnerIndex], AString) > 0 then
      begin
        result := True;
        Exit;
      end;
    end;
  end;

end;

function TfrmWriteContour.GetLayerHandle: ANE_PTR;
var
  LayerNames : TStringList;
  Project : TProjectOptions;
  NamedInfoLayer : T_ANE_NamedInfoLayer;
  LayerTemplate : string;
  ParamIndex : integer;
  ParamName : string;
  AParam : T_ANE_NamedLayerParam;
  ParamType : integer;
  ANE_LayerTemplate : ANE_STR;
begin
  result := nil;
  LayerNames := TStringList.Create;
  Project := TProjectOptions.Create;
  Application.CreateForm(TfrmChooseLayer, frmChooseLayer);
  try
    frmChooseLayer.ModelHandle := CurrentModelHandle;
    Project.LayerNames(CurrentModelHandle, [pieInformationLayer,pieMapsLayer,
      pieDomainLayer],LayerNames);
    frmChooseLayer.comboLayerNames.Items := LayerNames;
    if LayerNames.Count > 0 then
    begin
      frmChooseLayer.comboLayerNames.ItemIndex := 0;
    end
    else
    begin
      frmChooseLayer.cbNewLayer.Checked := true;
    end;
    if (frmChooseLayer.ShowModal = mrOK) and (frmChooseLayer.comboLayerNames.Text <> '') then
    begin
      if frmChooseLayer.cbNewLayer.Checked then
      begin
        NamedInfoLayer := T_ANE_NamedInfoLayer.Create(frmChooseLayer.comboLayerNames.Text, nil, -1);
        try
          NamedInfoLayer.Lock := [];
          for ParamIndex := 1 to frmChooseLayer.dgParameters.RowCount -1 do
          begin
            ParamName := frmChooseLayer.dgParameters.Cells[0,ParamIndex];
            if ParamName <> '' then
            begin
              AParam := T_ANE_NamedLayerParam.Create(ParamName,NamedInfoLayer.ParamList,-1);
              AParam.Lock := [];
              ParamType := frmChooseLayer.dgParameters.Columns[1].Picklist.IndexOf(frmChooseLayer.dgParameters.Cells[1,ParamIndex]);
              case ParamType of
                0:
                  begin
                    AParam.ValueType := pvReal;
                  end;
                1:
                  begin
                    AParam.ValueType := pvInteger;
                  end;
                2:
                  begin
                    AParam.ValueType := pvBoolean;
                  end;
                3:
                  begin
                    AParam.ValueType := pvString;
                  end;
              else Assert(False);
              end;

            end;
          end;
          LayerTemplate := NamedInfoLayer.WriteLayer(CurrentModelHandle);
          GetMem(ANE_LayerTemplate, Length(LayerTemplate) + 1);
          try
            StrPCopy(ANE_LayerTemplate, LayerTemplate);
            result := ANE_LayerAddByTemplate(CurrentModelHandle,
              ANE_LayerTemplate, nil);
          finally
            FreeMem(ANE_LayerTemplate);
          end;
        finally
          NamedInfoLayer.Free;
        end;
      end
      else
      begin
        result := Project.GetLayerByName(CurrentModelHandle,frmChooseLayer.comboLayerNames.Text)
      end;
    end;
  finally
    LayerNames.Free;
    Project.Free;
    frmChooseLayer.Free;
    frmChooseLayer := nil;
  end;

end;

function TfrmWriteContour.GridValuesOK(
  const AStringGrid: TStringGrid; MaxColumn : integer = 2;
    CheckAllColumns : boolean = True): boolean;
var
  ColIndex, RowIndex : integer ;
begin
  if CheckAllColumns then
  begin
    MaxColumn := AStringGrid.ColCount -1;
  end;
  result := True;
  for ColIndex := AStringGrid.FixedCols to MaxColumn do
  begin
    for RowIndex := AStringGrid.FixedRows
      to AStringGrid.RowCount -1 do
    begin
      if AStringGrid.Cells[ColIndex,RowIndex] = '' then
      begin
        result := False;
        Exit;
      end;
    end;
  end;
end;

end.
