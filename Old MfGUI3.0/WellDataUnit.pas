unit WellDataUnit;

interface

{WellDataUnit defines the form used when importing well data into a model and
 the PIE function used to import the data.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Clipbrd, StdCtrls, Grids, ArgusDataEntry, Buttons, ExtCtrls, AnePIE;

type
  EUnmatchedQuote = Class(Exception);

  TfrmWellData = class(TForm)
    sgWellData: TStringGrid;
    pnlBottom: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnPaste: TButton;
    adeWellCount: TArgusDataEntry;
    lblWell: TLabel;
    sdChooseFile: TSaveDialog;
    btnHelp: TBitBtn;
    btnFile: TButton;
    odRead: TOpenDialog;
    lblUnit: TLabel;
    adeUnit: TArgusDataEntry;
    rgDataFormat: TRadioGroup;
    cbMultUnits: TCheckBox;
    procedure btnPasteClick(Sender: TObject); virtual;
    procedure FormCreate(Sender: TObject); virtual;
    procedure adeStressPeriodCountExit(Sender: TObject); virtual;
    procedure adeWellCountExit(Sender: TObject); virtual;
    procedure btnOKClick(Sender: TObject); virtual;
    procedure FormDestroy(Sender: TObject); virtual;
    procedure btnFileClick(Sender: TObject);virtual;
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean; virtual;
    procedure cbMultUnitsClick(Sender: TObject); virtual;
  private
    { Private declarations }
  public
    AStringList : TStringList;
    HeadersStringList : TStringList;
    CurrentLayerHandle : ANE_PTR;
    CurrentModelHandle : ANE_PTR;
    procedure ReadValuesFromStringList(AStringList: TStringList); virtual;
    procedure SetColumnWidths; virtual;
    procedure WriteWellHeaders; virtual;
    procedure MakeContour(Row: integer; AStringList: TStringList);  virtual;
    procedure AssignHelpFile(FileName: string); virtual;
    Procedure Moved (var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED;
    { Public declarations }
  end;


procedure ImportWells(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;

implementation

{$R *.DFM}

uses Variables, ANE_LayerUnit, ArgusFormUnit, ANECB, UtilityFunctions,
  ModflowUnit, ExportProgressUnit;

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
    if NextQuote > 0
    then
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

procedure ReadTabValuesString(var AString, ASubstring : string);
var
  BeginIndex : integer;
begin
    BeginIndex := Pos(Chr(9),AString);
    if BeginIndex = 0
    then
      begin
        ASubstring := AString;
        AString := '';
      end
    else
      begin
        ASubstring := Copy(AString,0,BeginIndex-1);
        while ASubstring[1] = '"' do
        begin
          ASubstring := Copy(ASubstring,2,Length(ASubstring));
        end;
        while ASubstring[Length(ASubstring)] = '"' do
        begin
          ASubstring := Copy(ASubstring,1,Length(ASubstring)-1);
        end;
        AString := Copy(AString,BeginIndex+1,Length(AString));
      end;
end;

procedure TfrmWellData.SetColumnWidths;
var
  ColIndex, RowIndex, ColWidth, tempColWidth : integer;
begin
  for ColIndex := 0 to sgWellData.ColCount -1  do
  begin
    ColWidth := sgWellData.ColWidths[ColIndex];
    for RowIndex := 0 to sgWellData.RowCount -1 do
    begin
      tempColWidth := sgWellData.Canvas.TextWidth
        (sgWellData.Cells[ColIndex,RowIndex])+ 8;
      if tempColWidth > ColWidth then
      begin
        ColWidth := tempColWidth;
      end;
    end;
    sgWellData.ColWidths[ColIndex] := ColWidth;
  end;
end;

procedure TfrmWellData.ReadValuesFromStringList(AStringList : TStringList);
var
  Index : integer;
  ColIndex : integer;
  AString , ASubstring : string;
begin
  for Index := AStringList.Count -1 downto 0 do
  begin
    if AStringList[Index][1] = '#' then
    begin
      AStringList.Delete(Index);
    end;
  end;
  sgWellData.RowCount := AStringList.Count + 1;
  for Index := 0 to AStringList.Count -1 do
  begin
    ColIndex := 0;
    AString := AStringList[Index];
    while Length(AString) > 0 do
    begin
      if sgWellData.ColCount < ColIndex + 1 then
      begin
        sgWellData.ColCount := ColIndex + 1;
      end;
      if rgDataFormat.ItemIndex = 0
      then
        begin
          ReadTabValuesString(AString, ASubstring);
        end
      else
        begin
          ReadCommaValuesString(AString, ASubstring);
        end;
      sgWellData.Cells[ColIndex, Index + 1] := ASubstring;
      Inc(ColIndex);
    end;
  end;
end;

procedure TfrmWellData.btnPasteClick(Sender: TObject);
var
  AStringList : TStringlist;
begin
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    AStringList := TStringlist.Create;
    try
      AStringList.Text := Clipboard.AsText;
      ReadValuesFromStringList(AStringList);
    finally
      AStringList.Free;
    end;
    WriteWellHeaders;
    SetColumnWidths;
    adeWellCount.Text := IntToStr(sgWellData.RowCount -1);
//    adeStressPeriodCount.Text := IntToStr(sgWellData.ColCount -5);
  end;

end;

procedure TfrmWellData.WriteWellHeaders;
var
  Index : integer;
//  PeriodIndex : integer;
  Count : integer;
  UnitOffset : integer;
begin
  UnitOffset := 0;
  if cbMultUnits.Checked then
  begin
    UnitOffset := 1;
    sgWellData.Cells[0,0] := 'Unit';
  end;

  sgWellData.Cells[UnitOffset + 0,0] := 'Name';
  sgWellData.Cells[UnitOffset + 1,0] := 'X';
  sgWellData.Cells[UnitOffset + 2,0] := 'Y';
  sgWellData.Cells[UnitOffset + 3,0] := ModflowTypes.GetMFWellTopParamType.ANE_ParamName;
  sgWellData.Cells[UnitOffset + 4,0] := ModflowTypes.GetMFWellBottomParamType.ANE_ParamName;
  Count := HeadersStringList.Count;
  for Index := 0 to sgWellData.ColCount -1 do
  begin
    sgWellData.Cells[Index + UnitOffset + 5,0] := HeadersStringList[Index mod Count]
      + IntToStr((Index div Count) + 1);
  end;

end;

procedure TfrmWellData.FormCreate(Sender: TObject);
begin
  HeadersStringList := TStringList.Create;
  HeadersStringList.Add(ModflowTypes.GetMFWellStressParamType.ANE_ParamName);
  if frmModflow.cbMOC3D.Checked then
  begin
    HeadersStringList.Add(ModflowTypes.
      GetMFConcentrationParamType.ANE_ParamName);
  end;
  if frmModflow.cbMODPATH.Checked then
  begin
    HeadersStringList.Add(ModflowTypes.GetMFIFACEParamType.ANE_ParamName);
  end;
  WriteWellHeaders;
  SetColumnWidths;
  Constraints.MinWidth := Width;
  adeUnit.Max := StrToInt(frmModflow.edNumUnits.Text);
end;

procedure TfrmWellData.adeStressPeriodCountExit(Sender: TObject);
var
  Count : integer;
  UnitOffset : integer;
begin
  Count := 1;
  if frmModflow.cbMOC3D.Checked then
  begin
    Inc(Count);
  end;
  if frmModflow.cbMODPATH.Checked then
  begin
    Inc(Count);
  end;
  UnitOffset := 0;
  if cbMultUnits.Checked then
  begin
    UnitOffset := 1;
  end;
  sgWellData.ColCount := StrToInt(frmModflow.edNumPer.Text)*Count + 5
    + UnitOffset;
  WriteWellHeaders;
end;

procedure TfrmWellData.adeWellCountExit(Sender: TObject);
begin
  sgWellData.RowCount := StrToInt(adeWellCount.Text) + 1;
end;

procedure TfrmWellData.MakeContour(Row : integer; AStringList : TStringList);
var
  Value : string;
  ColIndex : integer;
  ValueStringList : TStringList;
  ValIndex : integer;
  ValCount : Integer;
  WellName : string;
  UnitOffset : integer;
begin
  ValueStringList := TStringList.Create;
  try
    if cbMultUnits.Checked then
    begin
      WellName := sgWellData.Cells[1,Row];
      UnitOffset := 1;
    end
    else
    begin
      WellName := sgWellData.Cells[0,Row];
      UnitOffset := 0;
    end;
    AStringList.Add('## Name:' + WellName + Chr(10) + '## Icon:3');
//    AStringList.Add('## Icon:3');
    AStringList.Add('# Points Count' + Chr(9) + 'Value');

    ValCount := {4 ;}ANE_LayerGetNumParameters(frmModflow.CurrentModelHandle,
      CurrentLayerHandle, kPIEContourLayerSubParam );
    for ValIndex := 0 to ValCount -1 do
    begin
      ValueStringList.Add(kNA);
    end;

    ColIndex := UnitOffset + 3;
    While (ColIndex < sgWellData.ColCount)
      and (sgWellData.Cells[ColIndex,Row] <> '') do
    begin
      ValIndex := ANE_LayerGetParameterByName(frmModflow.CurrentModelHandle,
         CurrentLayerHandle, PChar(sgWellData.Cells[ColIndex,0]));  
      if ValIndex > -1 then
      begin
        if ValIndex >= ValueStringList.Count then
        begin
        end
        else
        begin
          ValueStringList[ValIndex] := sgWellData.Cells[ColIndex,Row];
        end;
      end;
      Inc(ColIndex)
    end;

    Value := '1';
    for ValIndex := 0 to ValueStringList.Count -1 do
    begin
      Value := Value + Chr(9) + ValueStringList[ValIndex];
    end;
    
    AStringList.Add(Value);
    AStringList.Add('# X pos' + Chr(9) + 'Y pos');
    AStringList.Add(sgWellData.Cells[UnitOffset+1,Row] + Chr(9)
      + sgWellData.Cells[UnitOffset+2,Row]);

  finally
    ValueStringList.Free
  end;

end;

procedure TfrmWellData.btnOKClick(Sender: TObject);
var
  ContourIndex : integer;
  WellLayerName : string;
  UnitIndex : integer;
  StringToImport : string;
  NUnits : integer;
begin
  Screen.Cursor := crHourGlass;
  frmExportProgress := TfrmExportProgress.Create(Application);
  try
    begin
      frmExportProgress.CurrentModelHandle := CurrentModelHandle;
      frmExportProgress.Show;
      if cbMultUnits.Checked then
      begin
        NUnits := StrToInt(frmModflow.edNumUnits.Text);
        frmExportProgress.ProgressBar1.Max := NUnits * (sgWellData.RowCount + 1);
        AStringList := TStringList.Create;
        for UnitIndex := 1 to NUnits do
        begin
          WellLayerName := ModflowTypes.GetMFWellLayerType.ANE_LayerName
            + IntToStr(UnitIndex);
          CurrentLayerHandle := ANE_LayerGetHandleByName(frmMODFLOW.CurrentModelHandle,
            PChar(WellLayerName));
          AStringList.Clear;
          frmExportProgress.Caption := 'Creating Contours for Unit ' + IntToStr(UnitIndex);
          frmExportProgress.BringToFront;
          for ContourIndex := 1 to sgWellData.RowCount -1 do
          begin
            frmExportProgress.ProgressBar1.StepIt;
            if StrToInt(sgWellData.Cells[0,ContourIndex]) = UnitIndex then
            begin
              MakeContour(ContourIndex, AStringList);
            end;
          end;
          frmExportProgress.Caption := 'Exporting Contours for Unit '
            + IntToStr(UnitIndex) + '. (This  takes a while.)';
          frmExportProgress.ProgressBar1.StepIt;
          if AStringList.Count > 0 then
          begin
            StringToImport := AStringList.Text;
            ANE_ImportTextToLayerByHandle(frmMODFLOW.CurrentModelHandle,
              CurrentLayerHandle, PChar(StringToImport));
          end;
        end;
      end
      else
      begin
        frmExportProgress.ProgressBar1.Max := sgWellData.RowCount + 1;
        WellLayerName := ModflowTypes.GetMFWellLayerType.ANE_LayerName
          + Trim(frmWellData.adeUnit.Text);
        CurrentLayerHandle := ANE_LayerGetHandleByName(frmMODFLOW.CurrentModelHandle,
          PChar(WellLayerName));
        AStringList := TStringList.Create;
        frmExportProgress.Caption := 'Creating Contours';
        for ContourIndex := 1 to sgWellData.RowCount -1 do
        begin
          frmExportProgress.ProgressBar1.StepIt;
          MakeContour(ContourIndex, AStringList);
        end;
        frmExportProgress.Caption := 'Exporting Contours. (This  takes a while.)';
        frmExportProgress.ProgressBar1.StepIt;
        StringToImport := frmWellData.AStringList.Text;
        ANE_ImportTextToLayerByHandle(frmMODFLOW.CurrentModelHandle,
          frmWellData.CurrentLayerHandle, PChar(StringToImport));
      end;
  end;
  finally
    begin
      Screen.Cursor := crDefault;
      frmExportProgress.Free;
    end;
  end;


end;

procedure TfrmWellData.FormDestroy(Sender: TObject);
begin
  AStringList.Free;
end;

procedure TfrmWellData.btnFileClick(Sender: TObject);
var
  AStringList : TStringList;
begin

  if odRead.Execute then
  begin
    AStringList := TStringList.Create;
    try
      begin
        AStringList.LoadFromFile(odRead.FileName);
        ReadValuesFromStringList(AStringList);
      end
    finally
      begin
        AStringList.Free;
      end;
    end;
    WriteWellHeaders;
    SetColumnWidths;
    adeWellCount.Text := IntToStr(sgWellData.RowCount -1);
  end;
end;

function TfrmWellData.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  // triggering events: TfrmWellData.OnHelp;

  // This assigns the help file every time Help is called from frmMODFLOW.
  // AssignHelpFile is a virtual function that can be overridden by
  // descendents to assign a different help file for controls not present
  // in TfrmMODFLOW.
  AssignHelpFile('MODFLOW.hlp');
  result := True;

end;

procedure TfrmWellData.AssignHelpFile(FileName : string);
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

procedure ImportWells(aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
begin
  if EditWindowOpen
  then
    begin
      // Result := False
    end
  else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try  // try 1
        begin
          try  // try 2
            begin
              frmMODFLOW := TArgusForm.GetFormFromArgus(aneHandle)
                as ModflowTypes.GetModflowFormType;
              if frmMODFLOW.cbWEL.Checked then
              begin
                frmWellData :=
                  ModflowTypes.GetWellDataFormType.Create(Application);
                frmWellData.CurrentModelHandle := aneHandle;

                frmWellData.adeStressPeriodCountExit(nil);
                try // try 3
                  frmWellData.ShowModal;
                finally // try 3
                  frmWellData.Free;
                end; // try 3
              end
              else
              begin
                Beep;
                MessageDlg('The Well Package has not been selected',
                  mtError, [mbOK], 0);
              end;
            end; // try 2
          except on E: Exception do
            begin
              Beep;
              MessageDlg(E.Message, mtError, [mbOK], 0);
                // result := False;
            end;
          end  // try 2
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end; // try 1
    end; // if EditWindowOpen else
end;

procedure TfrmWellData.cbMultUnitsClick(Sender: TObject);
begin
  adeUnit.Enabled := not cbMultUnits.Checked;
  adeStressPeriodCountExit(Sender);
  WriteWellHeaders;
  SetColumnWidths;
end;

procedure TfrmWellData.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

end.
