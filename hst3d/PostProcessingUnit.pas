unit PostProcessingUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, vcf1, ExtCtrls, ThreeDIntListUnit, RealListUnit,
  ThreeDRealListUnit, ComCtrls, ArgusDataEntry, ShellAPI,
  ThreeDGriddedDataStorageUnit, Buttons, IntListUnit, AxCtrls, CheckLst,
  StringGrid3d, Grids, Math;

type
  TfrmPostProcessingForm = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    tabDataChoice: TTabSheet;
    ScrollBox1: TScrollBox;
    rgDataSet: TRadioGroup;
    tabBoundary: TTabSheet;
    tabGrid: TTabSheet;
    tabData: TTabSheet;
    OpenDialog1: TOpenDialog;
    Panel3: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    lblWhich: TLabel;
    btnReadData: TButton;
    btnSave: TButton;
    rgPlotDirection: TRadioGroup;
    adeWhich: TArgusDataEntry;
    rgPlotType: TRadioGroup;
    btnOK: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    clbDataSet: TCheckListBox;
    sg3dBoundary: TRBWStringGrid3d;
    sgGrid: TStringGrid;
    sg3dData: TRBWStringGrid3d;
    SaveDialog1: TSaveDialog;
    procedure btnReadDataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rgDataSetClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure rgPlotDirectionClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure adeWhichExceededBounds(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateHeadings;
  public
    { Public declarations }
    NX, NY, NZ: Integer;
    BoundList: T3DIntegerList;
    XCoordList, YCoordList, ZCoordList: TRealList;
    ListOfDataGrids: T3DGridStorage;
    FirstDataSet: boolean;
    DataSets: TIntegerList;
  end;

var
  frmPostProcessingForm: TfrmPostProcessingForm;

implementation

{$R *.DFM}

uses ShowHelpUnit, HST3D_PIE_Unit, PostProcessingPIEUnit;

procedure ReadPMap1(Sender: TObject);
var
  TitleLine1, TitleLine2, Options: string;
  PMap1: TextFile;
  NXY, NXYZ: integer;
  XIndex, YIndex, ZIndex, Index: Integer;
  BoundCond: integer;
  Coordinate: double;
  Header1, Header2, Dummy: string;
  DataValue: double;
  ADataGrid: T3DRealList;
  AGrid: TStringGrid;
  Opened: boolean;
  ALine: string;
  function GetNextValue: double;
  var
    BlankPos: integer;
    ResultString: string;
    CharIndex: integer;
  begin
    if ALine = '' then
    begin
      Readln(PMap1, ALine);
      ALine := Trim(ALine);
    end;
    BlankPos := Pos(' ', ALine);
    if BlankPos = 0 then
    begin
      ResultString := ALine;
      ALine := '';
    end
    else
    begin
      ResultString := Copy(ALine, 1,BlankPos-1);
      ALine := Trim(Copy(ALine, BlankPos, MAXINT));
    end;
    for CharIndex := Length(ResultString) downto 2 do
    begin
      if (ResultString[CharIndex] = '-') or (ResultString[CharIndex] = '+') then
      begin
        if ResultString[CharIndex-1] <> 'E' then
        begin
          Insert('E',ResultString,CharIndex);
        end;
        break;
      end;
    end;
    result := InternationalStrToFloat(ResultString);
  end;
begin
  ALine := '';
  Opened := False;
  try
    begin
      with frmPostProcessingForm do
      begin
        if OpenDialog1.Execute then
        begin
          Opened := True;
          Screen.Cursor := crHourGlass;
          AssignFile(PMap1, OpenDialog1.Filename);
          Reset(PMap1);
          if not Eof(PMap1) then
          begin
            Readln(PMap1, TitleLine1);
          end;
          if not Eof(PMap1) then
          begin
            Readln(PMap1, TitleLine2);
          end;
          if not Eof(PMap1) then
          begin
            Readln(PMap1, Options);
          end;
          if not Eof(PMap1) then
          begin
            Read(PMap1, NX);
          end;
          if not Eof(PMap1) then
          begin
            Read(PMap1, NY);
          end;
          if not Eof(PMap1) then
          begin
            Read(PMap1, NZ);
          end;
          if not Eof(PMap1) then
          begin
            BoundList.Free;
            BoundList := T3DIntegerList.Create(NX,
              NY, NZ);
          end;
          if not Eof(PMap1) then
          begin
            Read(PMap1, NXY);
          end;
          if not Eof(PMap1) then
          begin
            Read(PMap1, NXYZ);
          end;
          sg3dBoundary.GridColCount := NX + 1;
          sg3dBoundary.GridRowCount := NY + 1;
          sg3dBoundary.GridCount := NZ;

          sgGrid.RowCount := MaxIntValue([NX, NY, NZ]) + 1;

          sg3dData.GridColCount := NX + 1;
          sg3dData.GridRowCount := NY + 1;
          sg3dData.GridCount := NZ;
          UpdateHeadings;

          for ZIndex := 0 to NZ - 1 do
          begin
            AGrid := sg3dBoundary.Grids[ZIndex];
            for YIndex := 0 to NY - 1 do
            begin
              for XIndex := 0 to NX - 1 do
              begin
                if not Eof(PMap1) then
                begin
                  Read(PMap1, BoundCond);
                  AGrid.Cells[XIndex + 1, YIndex + 1] := IntToStr(BoundCond);
                  BoundList.Items[XIndex, YIndex, ZIndex] := BoundCond;
                end;
              end;
            end;
          end;

          for Index := 1 to NX do
          begin
            if not Eof(PMap1) then
            begin
              Read(PMap1, Coordinate);
              if FirstDataSet then
              begin
                XCoordList.Add(Coordinate);
                sgGrid.Cells[1, Index] := FloatToStr(Coordinate);
              end;
            end;
          end;
          for Index := 1 to NY do
          begin
            if not Eof(PMap1) then
            begin
              Read(PMap1, Coordinate);
              if FirstDataSet then
              begin
                YCoordList.Add(Coordinate);
                sgGrid.Cells[2, Index] := FloatToStr(Coordinate);
              end;
            end;
          end;
          for Index := 1 to NZ do
          begin
            if not Eof(PMap1) then
            begin
              Read(PMap1, Coordinate);
              if FirstDataSet then
              begin
                ZCoordList.Add(Coordinate);
                sgGrid.Cells[3, Index] := FloatToStr(Coordinate);
              end;
            end;
          end;
          FirstDataSet := False;
          while not Eof(PMap1) do
          begin
            if not Eof(PMap1) then
            begin
              Readln(PMap1, Dummy);
            end
            else
            begin
              break;
            end;
            if not (Trim(Dummy) = '') then
            begin
              Header2 := Dummy;
            end
            else
            begin
              Header2 := '';
              if not Eof(PMap1) then
              begin
                Readln(PMap1, Header2);
              end
              else
              begin
                break;
              end;
            end;

            if Pos('time', LowerCase(Header2)) > 0 then
            begin
              Header1 := Header2;
            end;
            if not Eof(PMap1) and (Pos('time', LowerCase(Header2)) > 0) then
            begin
              Readln(PMap1, Header2);
            end;
            if not Eof(PMap1) then
            begin
              if not (Pos('Free surface', Header2) > 0) then
              begin
                rgDataSet.Items.Add(Trim(Header1) + ' ' + Trim(Header2));
                rgDataSet.Height := (rgDataSet.Items.Count + 1) * 15;
                clbDataSet.Items.Add
                  (rgDataSet.Items[rgDataSet.Items.Count - 1]);
              end;
            end;
            if Pos('Free surface', Header2) > 0 then
            begin
              for YIndex := 1 to NY do
              begin
                for XIndex := 1 to NX do
                begin
                  if not Eof(PMap1) then
                  begin
                    DataValue := GetNextValue;
                    // Read(PMap1, DataValue);
                  end;
                end;
              end;
            end
            else
            begin
              ADataGrid := T3DRealList.Create(NX, NY, NZ);
              ListOfDataGrids.Add(ADataGrid, Trim(Header1) + ' '
                + Trim(Header2));
              for ZIndex := 0 to NZ - 1 do
              begin
                for YIndex := 0 to NY - 1 do
                begin
                  for XIndex := 0 to NX - 1 do
                  begin
                    if not Eof(PMap1) or (ALine <> '') then
                    begin
                      DataValue := GetNextValue;
                      // Read(PMap1, DataValue);
                      // Read Fails on values like 9.659900-122.
                      // It expects 9.659900E-122 instead.
                      // (The "E" is missing.)

                      ADataGrid.Items[XIndex, YIndex, ZIndex]
                        := DataValue;
                    end;
                  end;
                end;
              end;
            end;

          end;
          CloseFile(PMap1);
        end;
      end;
    end;
  finally
    begin
      with frmPostProcessingForm do
      begin
        if Opened then
        begin
          sg3dBoundary.GridColCount := NX + 1;
          sg3dBoundary.GridRowCount := NY + 1;
          sg3dBoundary.GridCount := NZ;
          sg3dData.GridColCount := NX + 1;
          sg3dData.GridRowCount := NY + 1;
          sg3dData.GridCount := NZ;
          sgGrid.RowCount := MaxIntValue([NX, NY, NZ]) + 1;
          UpdateHeadings;
          rgPlotDirectionClick(Sender);
        end;
        Screen.Cursor := crDefault;
      end;
    end;
  end;
end;

procedure TfrmPostProcessingForm.btnReadDataClick(Sender: TObject);
begin
  OpenDialog1.FileName := '';
  ReadPMap1(Sender);
  tabBoundary.TabVisible := True;
  tabGrid.TabVisible := True;
end;

procedure TfrmPostProcessingForm.FormCreate(Sender: TObject);
begin
  NX := 256;
  NY := 16384;
  NZ := 256;
  BoundList := nil;
  //  XCoordList := nil;
  //  YCoordList := nil;
  //  ZCoordList := nil;
  ListOfDataGrids := nil;
  ListOfDataGrids := T3DGridStorage.Create;
  PageControl1.ActivePage := tabDataChoice;
  XCoordList := TRealList.Create;
  YCoordList := TRealList.Create;
  ZCoordList := TRealList.Create;
  DataSets := TIntegerList.Create;
  FirstDataSet := True;
  if PIE_Data.HST3DForm.cbObsElev.Checked then
  begin
    rgPlotDirection.Items.Add('Obs. Elev.');
  end;
end;

procedure TfrmPostProcessingForm.FormDestroy(Sender: TObject);
begin
  BoundList.Free;
  XCoordList.Free;
  YCoordList.Free;
  ZCoordList.Free;
  DataSets.Free;
  {  for Index := ListOfDataGrids.Count -1 downto 0 do
    begin
      ADataGrid := ListOfDataGrids.Items[Index];
      ADataGrid.Free;
    end;
    ListOfDataGrids.Clear;  }
  ListOfDataGrids.Free;

end;

procedure TfrmPostProcessingForm.rgDataSetClick(Sender: TObject);
var
  ADataGrid: T3DRealList;
  XIndex, YIndex, ZIndex: Integer;
  DataValue: double;
  AGrid: TStringGrid;
begin
  Screen.Cursor := crHourGlass;
  //  Application.ProcessMessages;
  ADataGrid := ListOfDataGrids.Items[rgDataSet.ItemIndex];
  sg3dData.GridColCount := ADataGrid.XCount + 1;
  sg3dData.GridRowCount := ADataGrid.YCount + 1;
  sg3dData.GridCount := ADataGrid.ZCount;
  for ZIndex := 1 to ADataGrid.ZCount do
  begin
    //    F1BookData.Sheet := ZIndex ;
    AGrid := sg3dData.Grids[ZIndex - 1];
    for YIndex := 1 to ADataGrid.YCount do
    begin
      for XIndex := 1 to ADataGrid.XCount do
      begin
        DataValue := ADataGrid.Items[XIndex - 1, YIndex - 1, ZIndex - 1];
        //          F1BookData.SetSelection( YIndex, XIndex, YIndex, XIndex);
        //          F1BookData.Entry := FloatToStr(DataValue);
        AGrid.Cells[XIndex, YIndex] := FloatToStr(DataValue);
      end;
    end;
  end;
  sg3dBoundary.GridColCount := ADataGrid.XCount + 1;
  sg3dBoundary.GridRowCount := ADataGrid.YCount + 1;
  sg3dBoundary.GridCount := ADataGrid.ZCount;
  //  F1BookBoundary.MaxCol := ADataGrid.XCount;
  //  F1BookBoundary.MaxRow := ADataGrid.YCount;
  //  F1BookBoundary.NumSheets := ADataGrid.ZCount;
  //  F1BookData.MaxCol := ADataGrid.XCount;
  //  F1BookData.MaxRow := ADataGrid.YCount;
  //  F1BookData.NumSheets := ADataGrid.ZCount;
  tabData.TabVisible := True;
  //  F1BookData.Sheet := 1;
  sg3dData.ActivePageIndex := 0;

  Screen.Cursor := crDefault;

end;

procedure TfrmPostProcessingForm.PageControl1Change(Sender: TObject);
begin
  if (PageControl1.ActivePage = tabDataChoice) or (rgDataSet.Items.Count = 0)
    then
  begin
    btnSave.Enabled := False;
  end
  else
  begin
    if (PageControl1.ActivePage = tabData) and (rgDataSet.ItemIndex = -1) then
    begin
      btnSave.Enabled := False;
    end
    else
    begin
      btnSave.Enabled := True;
    end;
  end;
  if (PageControl1.ActivePage = tabDataChoice) then
  begin
    btnSave.Caption := 'Save';
  end
  else if (PageControl1.ActivePage = tabBoundary) then
  begin
    btnSave.Caption := 'Save Boundary Conditions';
  end
  else if (PageControl1.ActivePage = tabGrid) then
  begin
    btnSave.Caption := 'Save Grid Configuration';
  end
  else
  begin
    btnSave.Caption := 'Save Data';
  end
end;

procedure TfrmPostProcessingForm.FormResize(Sender: TObject);
begin
  ScrollBox1.Height := Round(tabDataChoice.ClientRect.Bottom / 2);
  rgDataSet.Width := Round(ScrollBox1.ClientRect.Right - 10);
  //  RzCLDataSet.Width := Round(tabDataChoice.ClientRect.Right-10);
end;

procedure TfrmPostProcessingForm.rgPlotDirectionClick(Sender: TObject);
begin
  adeWhich.Enabled := True;
  lblWhich.Enabled := True;
  case rgPlotDirection.ItemIndex of
    0:
      begin
        adeWhich.Max := NX;
        lblWhich.Caption := 'Which Column';
      end;
    1:
      begin
        adeWhich.Max := NY;
        lblWhich.Caption := 'Which Row';
      end;
    2:
      begin
        adeWhich.Max := NZ;
        lblWhich.Caption := 'Which Layer';
      end;
    3:
      begin
        adeWhich.Enabled := False;
        lblWhich.Enabled := False;
      end;
  end;

end;

procedure TfrmPostProcessingForm.btnSaveClick(Sender: TObject);
var
  name: Widestring;
  filetype: smallint;
  AGrid: TStringGrid;
  AStringList: TStringList;
  ColIndex, RowIndex: integer;
  AString: string;
begin
  if SaveDialog1.Execute then
  begin
    if PageControl1.ActivePage = tabBoundary then
    begin
      AGrid := sg3dBoundary.Grids[sg3dBoundary.ActivePageIndex];
    end
    else if PageControl1.ActivePage = tabGrid then
    begin
      AGrid := sgGrid;
    end
    else if PageControl1.ActivePage = tabData then
    begin
      AGrid := sg3dData.Grids[sg3dData.ActivePageIndex];
    end;
    AStringList := TStringList.Create;
    try
      for RowIndex := 0 to AGrid.RowCount - 1 do
      begin
        AString := '';
        for ColIndex := 0 to AGrid.ColCount - 1 do
        begin
          if ColIndex > 0 then
          begin
            AString := AString + #9;

          end;
          AString := AString + AGrid.Cells[ColIndex, RowIndex];

        end;
        AStringList.Add(AString);
      end;
      AStringList.SaveToFile(SaveDialog1.FileName);
    finally
      AStringList.Free;
    end;

  end;

  {  name := '';
    if PageControl1.ActivePage = tabBoundary
    then
      begin
        F1BookBoundary.SaveFileDlg ('Save', name, filetype);
        if not (name = '') then
        begin
          F1BookBoundary.Write(name, filetype);
        end;
      end
    else if PageControl1.ActivePage = tabGrid
    then
      begin
        F1BookGrid.SaveFileDlg ('Save', name, filetype);
        if not (name = '') then
        begin
          F1BookGrid.Write(name, filetype);
        end;
      end
    else
      begin
        F1BookData.SaveFileDlg ('Save', name, filetype);
        if not (name = '') then
        begin
          F1BookData.Write(name, filetype);
        end;
      end;    }
end;

procedure TfrmPostProcessingForm.btnOKClick(Sender: TObject);
var
  index: integer;
begin
  {  For Index := 0 to RzCLDataSet.Items.Count -1 do
    begin
      if RzCLDataSet.ItemState[ Index] = cbChecked then
      begin
        DataSets.Add(Index);
      end;
    end;   }
  for Index := 0 to clbDataSet.Items.Count - 1 do
  begin
    if clbDataSet.State[Index] = cbChecked then
    begin
      DataSets.Add(Index);
    end;
  end;

end;

procedure TfrmPostProcessingForm.BitBtn1Click(Sender: TObject);
begin
  ShowSpecificHTMLHelp('postproc.htm');
end;

procedure TfrmPostProcessingForm.adeWhichExceededBounds(Sender: TObject);
begin
  adeWhich.SetFocus;
end;

procedure TfrmPostProcessingForm.UpdateHeadings;
var
  GridIndex, Index: integer;
  AGrid: TStringGrid;
begin
  for GridIndex := 0 to sg3dBoundary.GridCount - 1 do
  begin
    sg3dBoundary.Pages[GridIndex].Caption := 'Layer ' + IntToStr(GridIndex + 1);
    AGrid := sg3dBoundary.Grids[GridIndex];
    for Index := 1 to AGrid.ColCount - 1 do
    begin
      AGrid.Cells[Index, 0] := 'Col ' + IntToStr(Index);
    end;
    for Index := 1 to AGrid.RowCount - 1 do
    begin
      AGrid.Cells[0, Index] := 'Row ' + IntToStr(Index);
    end;
  end;
  for GridIndex := 0 to sg3dData.GridCount - 1 do
  begin
    sg3dData.Pages[GridIndex].Caption := 'Layer ' + IntToStr(GridIndex + 1);
    AGrid := sg3dData.Grids[GridIndex];
    for Index := 1 to AGrid.ColCount - 1 do
    begin
      AGrid.Cells[Index, 0] := 'Col ' + IntToStr(Index);
    end;
    for Index := 1 to AGrid.RowCount - 1 do
    begin
      AGrid.Cells[0, Index] := 'Row ' + IntToStr(Index);
    end;
  end;
  sgGrid.Cells[1, 0] := 'X';
  sgGrid.Cells[2, 0] := 'Y';
  sgGrid.Cells[3, 0] := 'Z';
end;

end.

