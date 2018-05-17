unit mpathplotUnit;

interface

{mpathplotUnit defines the form used to import and preview MODPATH data.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ArgusFormUnit, StdCtrls, ExtCtrls, ArgusDataEntry, clipbrd, AnePIE, Buttons,
  ComCtrls, Grids, DataGrid;

type
  TMPathDataType = (dtPathlines, dtEndpoints, dtTimeSeries);
  TEndpointSummary = (esZone, esNParticles, esPercentParticles, esMaxTravTime,
    esMinTravTime, esMeanTravTime, esMedianTravTime, esStDTravTime, esMeanDist,
    esMeanVelocity, esMaxVelocity, esMinVelocity, esStDVelocity);

  TEndParticleSummary = class(TObject)
    TravelDistance : double;
    TravelTime : double;
    function Velocity : double;
  end;

  TEndSummaryItem = class(TObject)
    Zone : integer;
    ParticleSummaryList : TList;
    Constructor Create;
    Destructor Destroy; override;
    function GetValue(ValueType : TEndpointSummary) : string;
  end;

  TPlotLine = class(TList)
    Index : integer;
    procedure Draw; virtual;
    procedure WriteArgusString (ArgusString : TStringList;
      ADataType: TMPathDataType; WriteStartPosition : boolean);
  end;

  TfrmMPathPlot = class(TArgusForm)
    OpenDialog1: TOpenDialog;
    pnlBottom: TPanel;
    btnRead: TButton;
    btnMPathHelp: TBitBtn;
    btnMPathCancel: TBitBtn;
    btnMPathOK: TBitBtn;
    rgDataType: TRadioGroup;
    PageContModpath: TPageControl;
    tabPreview: TTabSheet;
    TabEndPoints: TTabSheet;
    PaintBox1: TPaintBox;
    DataGrid1: TDataGrid;
    pnlEndPoint: TPanel;
    rgEndpointSummary: TRadioGroup;
    rgPlotLocation: TRadioGroup;
    procedure btnReadClick(Sender: TObject); virtual;
    procedure FormCreate(Sender: TObject); override;
    procedure PaintBox1Paint(Sender: TObject); virtual;
    procedure rgDataTypeClick(Sender: TObject); virtual;
    procedure rgEndpointSummaryClick(Sender: TObject); virtual;
    procedure PageContModpathChange(Sender: TObject);
  private
    ReadingData: boolean;
//    procedure ReadPathLines;
    { Private declarations }
  public
//    procedure ClearPathLines;
//    CurrentModelHandle : ANE_PTR;
    MPathPlotLayerHandle  : ANE_PTR;
    procedure ReadData(ADataType: TMPathDataType); virtual;
    procedure SummarizeEndpoints; virtual;
    function GetZoneSummary(AZone: integer): TEndSummaryItem; virtual;
    function AppHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean; virtual;
    function GetPlotLine(Particle: integer): TPlotLine; virtual;
    Procedure WriteArgusStrings; virtual;
{    procedure AssignHelpFile(FileName : string) ; virtual;
    Procedure Moved (var Message: TWMWINDOWPOSCHANGED);
      message WM_WINDOWPOSCHANGED; }
    { Public declarations }
  end;

  TPosition = Class(TObject)
    X, Y, Z {, Time} : double;
    Row, Column, Layer : integer;
    // Endpoints
    StartingX, StartingY, StartingZ : double;
    EndingLayer : integer;
    EndingTime : double;
    StartingZone, EndingZone : integer;
    ReleaseTime : double;
    function Distance : double;
    function TravelTime : double;
  end;

  TPathLineList = Class(TList)
    procedure WriteArgusString(ArgusString : TStringList;
      ADataType: TMPathDataType; CurrentModelHandle : ANE_PTR;
      WriteStartPosition : boolean);
  end;

function CompareLists(Item1, Item2: Pointer): Integer;

var
  frmMPathPlot: TfrmMPathPlot;
  MaxX, MaxY, MinX, MinY : double;
  Multiplier : double;
  PathLinesList : TPathLineList;
  DataTypeIndex : integer = 0;
  EndSummaryList : TList;

procedure ReadModpath (aneHandle : ANE_PTR;
          const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;

var
  comboMPATHOutModeHelpContext: integer;

implementation

{$R *.DFM}

uses ANE_LayerUnit, UtilityFunctions, Variables, ANECB,
  LayerNamePrompt, ExportProgressUnit, ModflowUnit, RunUnit,
  ConserveResourcesUnit, JclFileUtils;


const
  Border = 20;

procedure ReadModpath (aneHandle : ANE_PTR;
          const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
var
  ModpathLayerHandle : ANE_PTR;
  ModpathLayer : T_ANE_MapsLayer;
  Template : String;
  ABoolean : Boolean;
  ModpathLayerName : string;
  UserResponse : integer;
  ErrorMessage : string;
  ANE_LayerTemplate : ANE_STR;
begin
  Exporting := True;
  Try
  if EditWindowOpen
  then
    begin
      // Result := False
    end
  else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      Application.CreateForm(TfrmMPathPlot,frmMPathPlot);
//      frmMPathPlot:= TfrmMPathPlot.Create(Application);

      try  // try 1
        begin
          frmMPathPlot.CurrentModelHandle := aneHandle;
          try  // try 2
            begin
              frmMODFLOW := TArgusForm.GetFormFromArgus(aneHandle)
                as ModflowTypes.GetModflowFormType;
              frmMPathPlot.CurrentModelHandle := aneHandle;
              if frmMPathPlot.ShowModal = mrOK then
              begin
                ANE_ProcessEvents(aneHandle);
                case frmMPathPlot.rgDataType.ItemIndex of
                  0,2:
                    begin
                      ModpathLayerName := ModflowTypes.GetMODPATHPostLayerType.ANE_LayerName;
                    end;
                  1:
                    begin
                      ModpathLayerName := ModflowTypes.GetMFMODPATHPostEndLayerType.ANE_LayerName;
                    end;
                  else
                    begin
                      Assert(False);
                    end;
                end;
                ModpathLayerHandle := GetLayerHandle(aneHandle,ModpathLayerName);
                if ModpathLayerHandle = nil then
                begin
                  ModpathLayer := nil;
                  case frmMPathPlot.rgDataType.ItemIndex of
                    0,2:
                      begin
                        frmMODFLOW.MFLayerStructure.PostProcessingLayers.AddOrRemoveLayer
                          (ModflowTypes.GetMODPATHPostLayerType , True);
                        ModpathLayer := frmMODFLOW.MFLayerStructure.
                          PostProcessingLayers.GetLayerByName
                          (ModflowTypes.GetMODPATHPostLayerType.ANE_LayerName);
                      end;
                    1:
                      begin
                        frmMODFLOW.MFLayerStructure.PostProcessingLayers.AddOrRemoveLayer
                          (ModflowTypes.GetMFMODPATHPostEndLayerType , True);
                        ModpathLayer := frmMODFLOW.MFLayerStructure.
                          PostProcessingLayers.GetLayerByName
                          (ModflowTypes.GetMFMODPATHPostEndLayerType.ANE_LayerName);
                      end;
                    else
                      begin
                        Assert(False);
                      end;
                  end;


                  Template := (ModpathLayer as ModflowTypes.
                    GetMODPATHPostLayerType).WriteLayer(aneHandle);

                  GetMem(ANE_LayerTemplate, Length(Template) + 1);
                  try
                    StrPCopy(ANE_LayerTemplate, Template);
                    ModpathLayerHandle :=ANE_LayerAddByTemplate(aneHandle,
                      ANE_LayerTemplate,nil );
                    ANE_ProcessEvents(aneHandle);
                  finally
                    FreeMem(ANE_LayerTemplate);
                  end;

{                    ShowMessage('The PIE can only place contours on layers '
                      + 'that already exist. The PIE will create a layer now '
                      + 'The next time you try to add MODPATH pathlines, '
                      + 'choose to place the contours on an existing layer.'); }
                end
                else // if ModpathLayerHandle = nil then
                begin
                  case frmMPathPlot.rgDataType.ItemIndex of
                    0,2:
                      begin
                        ModpathLayerName := ModflowTypes.GetMODPATHPostLayerType.ANE_LayerName;

                        UserResponse := 1;

                        GetValidLayer(aneHandle, ModpathLayerHandle,
                          ModflowTypes.GetMODPATHPostLayerType,
                          ModpathLayerName,
                          frmMODFLOW.MFLayerStructure.PostProcessingLayers,
                          UserResponse, '', True);

                      end;
                    1:
                      begin
                        ModpathLayerName := ModflowTypes.GetMFMODPATHPostEndLayerType.ANE_LayerName;

                        UserResponse := 1;

                        GetValidLayer(aneHandle, ModpathLayerHandle,
                          ModflowTypes.GetMFMODPATHPostEndLayerType,
                          ModpathLayerName,
                          frmMODFLOW.MFLayerStructure.PostProcessingLayers,
                          UserResponse, '', True);

                      end;
                    else
                      begin
                        Assert(False);
                      end;
                  end;

                  If UserResponse = 0 then
                  begin
                    ANE_LayerClear(aneHandle, ModpathLayerHandle, False);
                  end
                  else
                  begin
{                    ShowMessage('The PIE can only place contours on layers '
                      + 'that already exist. The PIE will create a layer now '
                      + 'The next time you try to add MODPATH pathlines, '
                      + 'choose to place the contours on an existing layer.');}
                  end;
                end; // if ModpathLayerHandle = nil then

                ABoolean := True;

                ANE_LayerPropertySet(aneHandle, ModpathLayerHandle,
                  'Allow Intersection', kPIEBoolean, @ABoolean);

                frmMPathPlot.MPathPlotLayerHandle := ModpathLayerHandle;
                ABoolean := True;

                frmMPathPlot.WriteArgusStrings;

              end; // if frmMPathPlot.ShowModal = mrOK then
            end; // try 2
          except on E: Exception do
            begin
              ErrorMessage := 'The following error occurred in the MODPATH '
                + 'post processing PIE. "' + E.Message + '" Contact PIE Developer ';
              if rsDeveloper <> '' then
              begin
                ErrorMessage := ErrorMessage + '(' + rsDeveloper + ') ';
              end;
              ErrorMessage := ErrorMessage + 'for assistance.';
              Beep;
              MessageDlg(ErrorMessage, mtError, [mbOK], 0);
                // result := False;
            end;
          end  // try 2
        end;
      finally
        begin
          EditWindowOpen := False;
          frmMPathPlot.Free;
        end;
      end; // try 1
    end; // if EditWindowOpen else
  finally
    Exporting := False;
  end;
end;

procedure ClearEndSummaryList;
var
  SummaryIndex : integer;
begin
  for SummaryIndex := EndSummaryList.Count -1 downto 0 do
  begin
    TEndSummaryItem(EndSummaryList[SummaryIndex]).Free;
  end;
  EndSummaryList.Clear;
end;

procedure ClearPathLines;
var
  OuterIndex, InnerIndex : integer;
  AList : TPlotLine;
  APosition : TPosition;
begin
  for OuterIndex := PathLinesList.Count -1 downto 0 do
  begin
    AList := PathLinesList[OuterIndex];
    for InnerIndex := AList.Count -1 downto 0 do
    begin
      APosition := AList[InnerIndex];
      APosition.Free;
    end;
    AList.Free;
  end;
  PathLinesList.Clear;
end;

procedure RotatePoints(Var X, Y: double; Angle : double);
var
  PointDistance, PointAngle : double;
begin
  PointDistance := Sqrt(Sqr(X) + Sqr(Y));
  if X = 0 then
  begin
    if Y > 0 then
    begin
      PointAngle := Pi/2;
    end
    else
    begin
      PointAngle := -Pi/2;
    end;
  end
  else
  begin
    PointAngle := ArcTan(Y/X);
    if X < 0 then
    begin
      PointAngle := PointAngle + Pi;
    end;
    if PointAngle > 2*Pi then
    begin
      PointAngle := PointAngle - 2*Pi;
    end;
  end;
  PointAngle := PointAngle + Angle;
  X := Cos(PointAngle)* PointDistance;
  Y := Sin(PointAngle)* PointDistance;
end;

procedure TfrmMPathPlot.btnReadClick(Sender: TObject);
begin
  ReadingData := True;
  try
    case rgDataType.ItemIndex of
      0:
        begin
          ReadData(dtPathlines);;
        end;
      1:
        begin
          ReadData(dtEndpoints);
          SummarizeEndpoints;
        end;
      2:
        begin
          ReadData(dtTimeSeries);;
        end;
      else
        begin
          Assert(False);
        end;
    end;
  finally
    ReadingData := False;
  end;

end;

function TfrmMPathPlot.GetZoneSummary(AZone : integer) : TEndSummaryItem;
var
  Index : integer;
  AnEndSummaryItem : TEndSummaryItem;
begin
  result := nil;
  for Index := 0 to EndSummaryList.Count -1 do
  begin
    AnEndSummaryItem := EndSummaryList[Index];
    if AnEndSummaryItem.Zone = AZone then
    begin
      result := AnEndSummaryItem;
      break;
    end;
  end;
end;

procedure TfrmMPathPlot.SummarizeEndpoints;
var
  PlotLineIndex, PositionIndex : integer;
  APlotLine : TPlotLine;
  APosition : TPosition;
  AnEndSummaryItem : TEndSummaryItem;
  ParticleSummary : TEndParticleSummary;
  SummaryIndex : integer;
  SummaryData : TEndpointSummary;
  NewRowCount : integer;
  AZone : integer;
begin
{  for SummaryIndex := EndSummaryList.Count -1 downto 0 do
  begin
    TEndSummaryItem(EndSummaryList[SummaryIndex]).Free;
  end;
  EndSummaryList.Clear};
  ClearEndSummaryList;
  for PlotLineIndex := 0 to PathLinesList.Count -1 do
  begin
    APlotLine := PathLinesList[PlotLineIndex];
    for PositionIndex := 0 to APlotLine.Count -1 do
    begin
      APosition := APlotLine[PositionIndex];
      if rgEndpointSummary.ItemIndex = 0 then
      begin
        AZone := APosition.StartingZone;
      end
      else
      begin
        AZone := APosition.EndingZone;
      end;
      AnEndSummaryItem := GetZoneSummary(AZone);
      if AnEndSummaryItem = nil then
      begin
        AnEndSummaryItem := TEndSummaryItem.Create;
        AnEndSummaryItem.Zone := AZone;
        EndSummaryList.Add(AnEndSummaryItem);
      end;
      ParticleSummary := TEndParticleSummary.Create;
      AnEndSummaryItem.ParticleSummaryList.Add(ParticleSummary);
      ParticleSummary.TravelDistance := APosition.Distance;
      ParticleSummary.TravelTime := APosition.TravelTime;
    end;
  end;
  NewRowCount := EndSummaryList.Count + 1;
  if NewRowCount = 1 then
  begin
    NewRowCount := 2;
  end;
  if DataGrid1.RowCountMin < NewRowCount then
  begin
    DataGrid1.RowCountMin := NewRowCount;
  end;
  DataGrid1.RowCount := NewRowCount;
  for SummaryIndex := 0 to EndSummaryList.Count -1 do
  begin
    AnEndSummaryItem := EndSummaryList[SummaryIndex];
    for SummaryData := Low(TEndpointSummary) to High(TEndpointSummary) do
    begin
      DataGrid1.Cells[Ord(SummaryData),SummaryIndex +1] :=
        AnEndSummaryItem.GetValue(SummaryData);
    end;
  end;
end;

{procedure TfrmMPathPlot.ReadPathLines;
var
  AFile : TextFile;
  S : string;
  ParticleIndex : integer;
  X, Y, LocalZ, Z, Time : double;
  J, I, K, TS: integer;
  APlotLine : TPlotLine;
  AddNewPoint : boolean;
  APosition : TPosition;
  OuterIndex, InnerIndex : integer;
  FirstPointFound : boolean;
  XMultiplier, YMultiplier : double;
  CompactFormat : boolean;
  NRow, NCol : integer;
  GridMinX, GridMaxX, GridMinY, GridMaxY : double;
  GridAngle : double;
  LayerHandle : ANE_PTR;
  AStringlist : TStringList;
  LineCount : integer;
  Capacity : integer;
  temp : double;
  GridXReversed, GridYReversed : boolean;
begin
  try
    FirstPointFound := False;
    APosition := nil;
    If OpenDialog1.Execute then
    begin
      AStringlist := TStringList.Create;
      try
        AStringlist.LoadFromFile(OpenDialog1.FileName);
        LineCount := AStringlist.Count;
      finally
        AStringlist.Free;
      end;

      ClearPathLines;
      AssignFile(AFile, OpenDialog1.FileName);   // File selected in dialog box
      Screen.Cursor := crHourGlass;
      Reset(AFile);
      frmExportProgress:= TfrmExportProgress.Create(Application);
      frmExportProgress.Caption := 'Reading Data';
      frmExportProgress.ProgressBar1.Max := LineCount;
      frmExportProgress.Show;
      try
        Readln(AFile, S);                          // Read the first line out of the file
        CompactFormat := (Pos('compact', LowerCase(S)) > 0);
        GetGrid(frmMPathPlot.CurrentModelHandle,
          ModflowTypes.GetGridLayerType.ANE_LayerName,LayerHandle,
           NRow, NCol, GridMinX, GridMaxX, GridMinY, GridMaxY, GridAngle);
        GridXReversed := False;
        if GridMaxX < GridMinX then
        begin
          GridXReversed := True;
        end;
        GridYReversed := False;
        if GridMaxY < GridMinY then
        begin
          GridYReversed := True;
        end;
        while not Eof(AFile)  do
        begin
          frmExportProgress.ProgressBar1.StepIt;
          if CompactFormat then
          begin
            Read(AFile, ParticleIndex, X, Y, LocalZ, Z, Time, J, TS);
            K := Trunc(J/(NRow*NCol))+1;
            J := J-(K-1)*(NRow*NCol);
            I:= Trunc(J/NCol) + 1;
            J := J - (I-1)*NCol;
          end
          else
          begin
            Read(AFile, ParticleIndex, X, Y, LocalZ, Z, Time, J, I, K, TS);
          end;
          Application.ProcessMessages;
          if not Eof(AFile) then
          begin
            APlotLine := GetPlotLine(ParticleIndex);
            If APlotLine = nil then
            begin
              APlotLine := TPlotLine.Create;
              APlotLine.Index := ParticleIndex;
              PathLinesList.Add(APlotLine);
            end;
            AddNewPoint := True;
            if APlotLine.Count = 10 then
            begin
              Capacity := Round(LineCount/PathLinesList.Count);
              if Capacity > APlotLine.Capacity then
              begin
                APlotLine.Capacity := Capacity;
              end;
            end;
            if APlotLine.Count > 0 then
            begin
              APosition := APlotLine[APlotLine.Count -1];
              if (APosition.X = X) and (APosition.Y = Y) then
              begin
                AddNewPoint := False;
              end;
            end;
            if AddNewPoint then
            begin
              If GridXReversed then
              begin
                X := X + GridMaxX;
              end
              else
              begin
                X := X + GridMinX;
              end;
              If GridYReversed then
              begin
                Y := Y + GridMaxY;
              end
              else
              begin
                Y := Y + GridMinY;
              end;
              if GridAngle <> 0 then
              begin
                RotatePoints(X, Y, GridAngle);
              end;
              if (APosition = nil) or (APosition.X <> X) or (APosition.Y <> Y) then
              begin
                APosition := TPosition.Create;
                APosition.X := X;
                APosition.Y := Y;
                APosition.Z := Z;
                APosition.Time := Time;
                APosition.Layer := K;
                APlotLine.Add(APosition);
              end;
            end;
          end;
        end;
        if PathLinesList.Count > 0 then
        begin
          For OuterIndex := 0 to PathLinesList.Count -1 do
          begin
            APlotLine := PathLinesList[OuterIndex];
            If APlotLine.Count > 0 then
            begin
              For InnerIndex := 0 to APlotLine.Count -1 do
              begin
                APosition := APlotLine[InnerIndex];
                If FirstPointFound then
                begin
                  if APosition.X > MaxX then MaxX := APosition.X;
                  if APosition.X < MinX then MinX := APosition.X;
                  if APosition.Y > MaxY then MaxY := APosition.Y;
                  if APosition.Y < MinY then MinY := APosition.Y;
                end
                else
                begin
                  FirstPointFound := True;
                  MaxX := APosition.X;
                  MaxY := APosition.Y;
                  MinX := APosition.X;
                  MinY := APosition.Y;
                end;
              end;
            end;
          end;
        end;
        if FirstPointFound then
        begin
          XMultiplier := (PaintBox1.Width - 2*Border)/(MaxX - MinX);
          YMultiplier := (PaintBox1.Height- 2*Border)/(MaxY - MinY);
          If XMultiplier > YMultiplier then
          begin
            Multiplier := YMultiplier;
          end
          else
          begin
            Multiplier := XMultiplier;
          end;
        end;
      finally
        CloseFile(AFile);
        frmExportProgress.Free;
        Screen.Cursor := crDefault;
        PaintBox1.Invalidate;
      end;

    end;
  except on EInOutError do
    begin
      Beep;
      MessageDlg('Error reading file; This error may be caused by attempting '
        + 'to read a binary file or a file that is not a pathline file', mtError,
        [mbOK, mbHelp], 1060);
    end;
  end;
end;   }

procedure TfrmMPathPlot.ReadData(ADataType: TMPathDataType);
var
  AFile : TextFile;
  S : string;
  TimeSeriesIndex, ParticleIndex : integer;
  ZoneCode, StartingZoneCode: integer;
  X, Y, LocalZ, Z, Time : double;
  StartingX, StartingY, StartingZ, ReleaseTime : double;
  J, I, K, TS: integer;
  StartingJ, StartingI, StartingK, ReleaseTS: integer;
  TerminationCode : integer;
  APlotLine : TPlotLine;
  AddNewPoint : boolean;
  APosition : TPosition;
  OuterIndex, InnerIndex : integer;
  FirstPointFound : boolean;
  XMultiplier, YMultiplier : double;
  CompactFormat : boolean;
  NRow, NCol : integer;
  GridMinX, GridMaxX, GridMinY, GridMaxY : double;
  GridAngle : double;
  LayerHandle : ANE_PTR;
  AStringlist : TStringList;
  LineCount : integer;
  Capacity : integer;
  temp : double;
  GridXReversed, GridYReversed : boolean;
  Divisor : double;
  NewContour : boolean;
  FileTypeName : string;
  AString: string;
  LineLength: integer;
  Size: integer;
  Index: integer;
begin
  try
    FirstPointFound := False;
    APosition := nil;
    OpenDialog1.InitialDir := GetCurrentDir;
    If OpenDialog1.Execute then
    begin
      {AssignFile(AFile, OpenDialog1.FileName);   { File selected in dialog box }
      {Reset(AFile);
      try
{        LineLength := 0;
        // skip header line.
        ReadLn(AFile, AString);
        for Index := 1 to 10 do
        begin
          if not EOF(AFile) then
          begin
            ReadLn(AFile, AString);
            if not EOF(AFile) then
            begin
              LineLength := LineLength + Length(AString);
            end;
          end;
        end;
        LineLength := LineLength div 10;
        if LineLength <0 then
        begin
          LineLength := 1;
        end;  }
//        LineCount := FileSize(AFile);
        {if Size <= 0 then
        begin
          Size := MaxInt;
        end;

        LineCount := Size div LineLength;  }
      {finally
        CloseFile(AFile);
      end; }

      {AStringlist := TStringList.Create;
      try
        try
        AStringlist.LoadFromFile(OpenDialog1.FileName);
        LineCount := AStringlist.Count;
        except on EOutOfMemory do
          begin
            LineCount := MAXINT;
          end
        end;
      finally
        AStringlist.Free;
      end;}

      ClearPathLines;
      AssignFile(AFile, OpenDialog1.FileName);   { File selected in dialog box }
      Screen.Cursor := crHourGlass;
      Reset(AFile);
      Application.CreateForm(TfrmExportProgress,frmExportProgress);
      try
//      frmExportProgress:= TfrmExportProgress.Create(Application);
        frmExportProgress.CurrentModelHandle := CurrentModelHandle;
        frmExportProgress.Caption := 'Reading Data';
        // Not sure this will work. LineCount probably overestimates
        // the actual number of lines but that is OK.
        // LineCount := FileSize(AFile);
        LineCount := FileGetSize(OpenDialog1.FileName) div 80;
        If LineCount < 0 then
        begin
          LineCount := MAXINT div 80;
        end;
        Assert(LineCount >= 0);

        frmExportProgress.ProgressBar1.Max := LineCount;
        frmExportProgress.Show;
        Readln(AFile, S);                          { Read the first line out of the file }
        CompactFormat := (Pos('compact', LowerCase(S)) > 0);
        GetGrid(frmMPathPlot.CurrentModelHandle,
          ModflowTypes.GetGridLayerType.ANE_LayerName,LayerHandle,
           NRow, NCol, GridMinX, GridMaxX, GridMinY, GridMaxY, GridAngle);
        GridXReversed := False;
        if GridMaxX < GridMinX then
        begin
          GridXReversed := True;
        end;
        GridYReversed := False;
        if GridMaxY < GridMinY then
        begin
          GridYReversed := True;
        end;
        ParticleIndex := 0;
        while not Eof(AFile)  do
        begin
          Inc(ParticleIndex);
          frmExportProgress.ProgressBar1.StepIt;
          StartingK := 0;
          StartingI := 0;
          StartingJ := 0;
          Z := 0;
          Time := 0;
          I := 0;
          J := 0;
          K := 0;

          case ADataType of
            dtPathLines:
              begin
                if CompactFormat then
                begin
                  Read(AFile, ParticleIndex, X, Y, LocalZ, Z, Time, J, TS);
                  K := Trunc(J/(NRow*NCol))+1;
                  J := J-(K-1)*(NRow*NCol);
                  I:= Trunc(J/NCol) + 1;
                  J := J - (I-1)*NCol;
                end
                else
                begin
                  Read(AFile, ParticleIndex, X, Y, LocalZ, Z, Time, J, I, K, TS);
                end;
              end;
            dtEndPoints:
              begin
                if CompactFormat then
                begin
                  Read(AFile, ZoneCode, J, X, Y, LocalZ, Time,
                    StartingX, StartingY, StartingZ, StartingJ,
                    StartingZoneCode, ReleaseTS, TerminationCode, ReleaseTime);
                  K := Trunc(J/(NRow*NCol))+1;
                  J := J-(K-1)*(NRow*NCol);
                  I:= Trunc(J/NCol) + 1;
                  J := J - (I-1)*NCol;

                  StartingK := Trunc(StartingJ/(NRow*NCol))+1;
                  StartingJ := StartingJ-(StartingK-1)*(NRow*NCol);
                  StartingI:= Trunc(StartingJ/NCol) + 1;
                  StartingJ := StartingJ - (StartingI-1)*NCol;
                end
                else
                begin
                  Read(AFile, ZoneCode, J, I, K, X, Y, Z, LocalZ, Time,
                    StartingX, StartingY, StartingZ, StartingJ, StartingI, StartingK,
                    StartingZoneCode, ReleaseTS, TerminationCode, ReleaseTime);
                end;
              end;
            dtTimeSeries:
              begin
                if CompactFormat then
                begin
                  Read(AFile, TimeSeriesIndex, ParticleIndex, J,
                    X, Y, Z, LocalZ, Time, TS);
                  K := Trunc(J/(NRow*NCol))+1;
                  J := J-(K-1)*(NRow*NCol);
                  I:= Trunc(J/NCol) + 1;
                  J := J - (I-1)*NCol;
                end
                else
                begin
                  Read(AFile, TimeSeriesIndex, ParticleIndex, J, I, K, X, Y, Z, LocalZ, Time, TS);
                end;
              end;
          end;
          Application.ProcessMessages;
          if not Eof(AFile) then
          begin
            NewContour := False;
            APlotLine := GetPlotLine(ParticleIndex);
            If APlotLine = nil then
            begin
              APlotLine := TPlotLine.Create;
              APlotLine.Index := ParticleIndex;
              if PathLinesList.Capacity = PathLinesList.Count then
              begin
                PathLinesList.Capacity := Round(PathLinesList.Capacity*1.5);
              end;
              PathLinesList.Add(APlotLine);
              NewContour := True;
            end;
            AddNewPoint := True;
            if APlotLine.Count = 10 then
            begin
              Capacity := Round(LineCount/PathLinesList.Count);
              if Capacity > APlotLine.Capacity then
              begin
                APlotLine.Capacity := Capacity;
              end;
            end;
            if APlotLine.Count > 0 then
            begin
              APosition := APlotLine[APlotLine.Count -1];
              if (APosition.X = X) and (APosition.Y = Y) then
              begin
                AddNewPoint := False;
              end;
            end;
            if AddNewPoint then
            begin
              If GridXReversed then
              begin
                X := X + GridMaxX;
                StartingX := StartingX + GridMaxX;
              end
              else
              begin
                X := X + GridMinX;
                StartingX := StartingX + GridMinX;
              end;
              If GridYReversed then
              begin
                Y := Y + GridMaxY;
                StartingY := StartingY + GridMaxY;
              end
              else
              begin
                Y := Y + GridMinY;
                StartingY := StartingY + GridMinY;
              end;
              if GridAngle <> 0 then
              begin
                RotatePoints(X, Y, GridAngle);
                RotatePoints(StartingX, StartingY, GridAngle);
              end;
              if (APosition = nil) or (APosition.X <> X) or (APosition.Y <> Y)
                or (ADataType = dtEndPoints) or NewContour then
              begin
                APosition := TPosition.Create;
                NewContour := False;
                APosition.X := X;
                APosition.Y := Y;
                APosition.Z := Z;
                APosition.ReleaseTime := Time;
                APosition.EndingTime := Time;
                Case ADataType of
                  dtPathlines, dtTimeSeries:
                    begin
                      APosition.Layer := K;
                      APosition.Column := J;
                      APosition.Row := I;
                    end;
                  dtEndpoints:
                    begin
                      APosition.StartingX := StartingX;
                      APosition.StartingY := StartingY;
                      APosition.StartingZ := StartingZ;
                      APosition.ReleaseTime := ReleaseTime;
                      APosition.Layer := StartingK;
                      APosition.Row := StartingI;
                      APosition.Column := StartingJ;
                      APosition.EndingLayer := K;
                      APosition.EndingTime := Time;
                      APosition.StartingZone := StartingZoneCode;
                      APosition.EndingZone  := ZoneCode;
                    end;
                  else
                    begin
                      Assert(False);
                    end;
                end;
                if APlotLine.Count = APlotLine.Capacity then
                begin
                  APlotLine.Capacity := Round(APlotLine.Capacity * 1.5);
                end;

                APlotLine.Add(APosition);
              end
              else
              begin
                      APosition.EndingTime := Time;
              end;
            end;
{            if NewContour then
            begin
              ShowMessage( IntToStr(ParticleIndex));
            end;  }
          end;
        end;
        if PathLinesList.Count > 0 then
        begin
          For OuterIndex := 0 to PathLinesList.Count -1 do
          begin
            APlotLine := PathLinesList[OuterIndex];
            If APlotLine.Count > 0 then
            begin
              For InnerIndex := 0 to APlotLine.Count -1 do
              begin
                APosition := APlotLine[InnerIndex];
                If FirstPointFound then
                begin
                  if APosition.X > MaxX then MaxX := APosition.X;
                  if APosition.X < MinX then MinX := APosition.X;
                  if APosition.Y > MaxY then MaxY := APosition.Y;
                  if APosition.Y < MinY then MinY := APosition.Y;
                end
                else
                begin
                  FirstPointFound := True;
                  MaxX := APosition.X;
                  MaxY := APosition.Y;
                  MinX := APosition.X;
                  MinY := APosition.Y;
                end;
              end;
            end;
          end;
        end;
        if FirstPointFound then
        begin
          Divisor := MaxX - MinX;
          if Divisor = 0 then
          begin
            XMultiplier := (PaintBox1.Width - 2*Border);
          end
          else
          begin
            XMultiplier := (PaintBox1.Width - 2*Border)/(MaxX - MinX);
          end;

          Divisor := MaxY - MinY;
          if Divisor = 0 then
          begin
            YMultiplier := (PaintBox1.Height- 2*Border);
          end
          else
          begin
            YMultiplier := (PaintBox1.Height- 2*Border)/(MaxY - MinY);
          end;
          If XMultiplier > YMultiplier then
          begin
            Multiplier := YMultiplier;
          end
          else
          begin
            Multiplier := XMultiplier;
          end;
        end;
      finally
        CloseFile(AFile);
        frmExportProgress.Free;
        Screen.Cursor := crDefault;
        PaintBox1.Invalidate;
      end;

    end;
  except on EInOutError do
    begin
      Beep;
      FileTypeName := 'unknown';
      case ADataType of
        dtPathlines:
          begin
            FileTypeName := 'pathline';
          end;
        dtEndpoints:
          begin
            FileTypeName := 'endpoint';
          end;
        dtTimeSeries:
          begin
            FileTypeName := 'time series';
          end;
      else Assert(False);
      end;

      MessageDlg('Error reading file; This error may be caused by attempting '
        + 'to read a binary file or a file that is not a '
        + FileTypeName
        + ' file', mtError,
        [mbOK, mbHelp], comboMPATHOutModeHelpContext);
    end;
  end;
end;


function CompareLists(Item1, Item2: Pointer): Integer;
var
  List1, List2 : TPlotLine;
begin
  List1 := TPlotLine(Item1);
  List2 := TPlotLine(Item2);
  Result := List1.Index - List2.Index;
  if Result <> 0 then
  begin
    Result := Round(Result/Abs(Result));
  end;
end;

procedure TfrmMPathPlot.FormCreate(Sender: TObject);
begin
  ReadingData := False;
  PaintBox1.Canvas.Pen.Color := clBlack;
  AssignHelpFile('MODFLOW.chm');
  Application.OnHelp := AppHelp;
  PageContModpath.ActivePage := tabPreview;
  rgDataType.ItemIndex := DataTypeIndex;
//  rgDataTypeClick(nil);
  if rgDataType.ItemIndex = 1 then
  begin
    SummarizeEndpoints;
  end;
  FreeFormResources(self);
end;

function TfrmMPathPlot.GetPlotLine(Particle: integer): TPlotLine;
var
  LowerIndex, UpperIndex, MiddleIndex : integer;
  ALine, AnotherLine, MiddleLine : TPlotLine;
begin
  result := nil;
  if Particle-1 < PathLinesList.Count then
  begin
    result := PathLinesList[Particle-1];
    if result.Index <> Particle then
    begin
      result := nil;
    end;
  end;
  if result = nil then
  begin
    if PathLinesList.Count > 0 then
    begin
      LowerIndex := 0;
      ALine := PathLinesList[LowerIndex];
      if ALine.Index = Particle then
      begin
        result := ALine;
      end
      else
      begin
        UpperIndex := PathLinesList.Count -1;
        AnotherLine := PathLinesList[UpperIndex];

        if AnotherLine.Index = Particle then
        begin
          result := AnotherLine;
        end
        else
        begin
          While (UpperIndex - LowerIndex > 1) do
          begin
            MiddleIndex := Round((UpperIndex + LowerIndex)/2);
            MiddleLine := PathLinesList[MiddleIndex];
            if MiddleLine.Index = Particle then
            begin
              result := MiddleLine;
              break;
            end
            else
            begin
              if MiddleLine.Index < Particle then
              begin
                LowerIndex := MiddleIndex;
              end
              else
              begin
                UpperIndex := MiddleIndex;
              end;
            end;
          end;

        end;
      end;
    end;
  end;

end;

{ TPlotLine }

procedure TPlotLine.Draw;
Var
  XPosition, YPosition : Integer;
  APosition : TPosition;
  Index : integer;
  AColor : TColor;
begin
  if Count > 0 then
  begin
    APosition := Items[0];
    XPosition := Round((APosition.X-MinX)*Multiplier) + Border;
    YPosition := Round((MaxY-APosition.Y)*Multiplier) + Border;
    frmMPathPlot.PaintBox1.Canvas.MoveTo(XPosition,YPosition);
    For Index := 0 to Count - 1 do
    begin
      APosition := Items[Index];
      XPosition := Round((APosition.X-MinX)*Multiplier) + Border;
      YPosition := Round((MaxY-APosition.Y)*Multiplier) + Border;
      frmMPathPlot.PaintBox1.Canvas.LineTo(XPosition,YPosition);
    end;
    if Count = 1 then
    begin
      AColor := frmMPathPlot.PaintBox1.Canvas.Brush.Color;
      frmMPathPlot.PaintBox1.Canvas.Brush.Color := clBlack;
      frmMPathPlot.PaintBox1.Canvas.Rectangle
        (XPosition-2,YPosition-2,XPosition+2,YPosition+2);
      frmMPathPlot.PaintBox1.Canvas.Brush.Color := AColor;
    end;
  end;

end;

procedure TfrmMPathPlot.PaintBox1Paint(Sender: TObject);
var
  Index : integer;
  APlotLine : TPlotLine;
  StartTime, EndTime: TDateTime;
begin
  if ReadingData then Exit;
  StartTime := Now;
  for Index := 0 to PathLinesList.Count -1 do
  begin
    APlotLine := PathLinesList[Index];
    APlotLine.Draw;
    EndTime := Now;
    if (EndTime - StartTime)*24*3600 > 2 then
    begin
      Exit;
    end;
  end;


end;


procedure TPlotLine.WriteArgusString (ArgusString : TStringList;
  ADataType: TMPathDataType; WriteStartPosition : boolean);
var
  Index : integer;
  APosition : TPosition;
  AString : string;
  OldDecSeparator: Char;
//  ArgusString: TStringList;
begin
    OldDecSeparator := DecimalSeparator;
    try
      DecimalSeparator := '.';
      ArgusString.Add('## Name:');
      ArgusString.Add('## Icon:0');
      ArgusString.Add('# Points Count' + Chr(9) + 'Value');
      AString := IntToStr(Count) + Chr(9);

      if Count > 0 then
      begin
        APosition := Items[0];
        AString := AString + IntToStr(APosition.Layer) + Chr(9);
        AString := AString + InternationalFloatToStr(APosition.ReleaseTime) + Chr(9);

        Case ADataType of
          dtPathlines, dtTimeSeries:
            begin
              APosition := Items[Count -1];
              AString := AString + IntToStr(APosition.Layer) + Chr(9);
              AString := AString + InternationalFloatToStr(APosition.EndingTime) + Chr(9);
              APosition := Items[0];
            end;
          dtEndPoints:
            begin
              AString := AString + IntToStr(APosition.EndingLayer) + Chr(9);
              AString := AString + InternationalFloatToStr(APosition.EndingTime) + Chr(9);

              AString := AString + IntToStr(APosition.Column) + Chr(9);
              AString := AString + IntToStr(APosition.Row) + Chr(9);

              AString := AString + InternationalFloatToStr(APosition.StartingX) + Chr(9);
              AString := AString + InternationalFloatToStr(APosition.StartingY) + Chr(9);
              AString := AString + InternationalFloatToStr(APosition.StartingZ) + Chr(9);
              AString := AString + InternationalFloatToStr(APosition.X) + Chr(9);
              AString := AString + InternationalFloatToStr(APosition.Y) + Chr(9);
              AString := AString + InternationalFloatToStr(APosition.Z) + Chr(9);


              AString := AString + IntToStr(APosition.StartingZone) + Chr(9);
              AString := AString + IntToStr(APosition.EndingZone) + Chr(9);
            end;
          else
            begin
              Assert(False);
            end;
        end;
        AString := AString + IntToStr(APosition.Column) + Chr(9);
        AString := AString + IntToStr(APosition.Row) + Chr(9);
        ArgusString.Add(AString);
      //  ArgusString.Add(IntToStr(Count) + Chr(9) + '1');
        ArgusString.Add('# X pos + Chr(9) + Y pos');
        For Index := 0 to Count - 1 do
        begin
          APosition := Items[Index];
          if WriteStartPosition then
          begin
            ArgusString.Add(InternationalFloatToStr(APosition.StartingX) + Chr(9) + InternationalFloatToStr(APosition.StartingY));
          end
          else
          begin
            ArgusString.Add(InternationalFloatToStr(APosition.X) + Chr(9) + InternationalFloatToStr(APosition.Y));
          end;
        end;
      end;

    finally
      DecimalSeparator := OldDecSeparator;
    end;
end;

{ TPathLineList }

procedure TPathLineList.WriteArgusString(ArgusString : TStringList;
  ADataType: TMPathDataType; CurrentModelHandle : ANE_PTR;
  WriteStartPosition : boolean);
var
  Index : Integer;
  APlotLine : TPlotLine;
  AString : string;
  ANE_String : ANE_STR;
begin
  // The following code plots contours in 5000 line chunks as a compromise
  // between slow redraws in Argus ONE after each set of contours is plotted
  // and slow string manipulation as the size of "AString" becomes large.
  If Count > 0 then
  begin
    Application.CreateForm(TfrmExportProgress,frmExportProgress);
//    frmExportProgress := TfrmExportProgress.Create(Application);
    try
      frmExportProgress.CurrentModelHandle := CurrentModelHandle;
      frmExportProgress.Caption := 'Plotting data';
      frmExportProgress.Show;
      frmExportProgress.ProgressBar1.Position := 0;
      frmExportProgress.ProgressBar1.Max := Count;
      ArgusString.Clear;
      For Index := 0 to Count -1 do
      begin
        APlotLine := Items[Index];
        APlotLine.WriteArgusString(ArgusString, ADataType, WriteStartPosition);
        if ArgusString.Count < 5000 then
        begin
          ArgusString.Add('');
        end
        else
        begin
          AString := GetArgusStr(ArgusString);
          {AString := '';
          For InnerIndex := 0 to ArgusString.Count -1 do
          begin
            AString := AString + ArgusString.strings[InnerIndex] + Chr(10);
          end; }

          GetMem(ANE_String, Length(AString) + 1);
          try
            StrPCopy(ANE_String, AString);
            ANE_ImportTextToLayerByHandle(frmMPathPlot.CurrentModelHandle ,
              frmMPathPlot.MPathPlotLayerHandle, ANE_String);
            ANE_ProcessEvents(frmMPathPlot.CurrentModelHandle);
          finally
            FreeMem(ANE_String);
          end;

          ArgusString.Clear;
        end;

        frmExportProgress.ProgressBar1.StepIt;
      end;
      if ArgusString.Count > 0 then
      begin
        if ArgusString.Strings[ArgusString.Count -1] = '' then
        begin
          ArgusString.Delete(ArgusString.Count -1);
        end;
        AString := GetArgusStr(ArgusString);
        {AString := '';
        For InnerIndex := 0 to ArgusString.Count -1 do
        begin
          AString := AString + ArgusString.strings[InnerIndex] + Chr(10);
        end; }

        GetMem(ANE_String, Length(AString) + 1);
        try
          StrPCopy(ANE_String, AString);
          ANE_ImportTextToLayerByHandle(frmMPathPlot.CurrentModelHandle ,
            frmMPathPlot.MPathPlotLayerHandle, ANE_String);
          ANE_ProcessEvents(frmMPathPlot.CurrentModelHandle);
        finally
          FreeMem(ANE_String);
        end;

        ArgusString.Clear;
      end;
    finally
      frmExportProgress.Free;
    end;
  end;

end;

procedure TfrmMPathPlot.WriteArgusStrings;
var
  ArgusString : TStringList;
  ADataType: TMPathDataType;
  WriteStartLocation : boolean;
begin
  Screen.Cursor := crHourGlass;
  ADataType := dtPathLines;
  case rgDataType.ItemIndex of
    0:
      begin
        ADataType := dtPathLines;
      end;
    1:
      begin
        ADataType := dtEndPoints;
      end;
    2:
      begin
        ADataType := dtTimeSeries;
      end;
    else
      begin
        Assert(False);
      end;
  end;
  WriteStartLocation := (rgDataType.ItemIndex = 1)
    and (rgPlotLocation.ItemIndex = 0);
  ArgusString := TStringList.Create;
  try
    PathLinesList.WriteArgusString(ArgusString, ADataType, CurrentModelHandle,
      WriteStartLocation);
  finally
    Screen.Cursor := crDefault;
    ArgusString.Free;
  end;

end;

function TfrmMPathPlot.AppHelp(Command: Word; Data: Longint;
  var CallHelp: Boolean): Boolean;
var
  DllDirectory : String;
begin
  if GetDllDirectory(DLLName, DllDirectory ) then
  begin
    Application.HelpFile := DllDirectory + '\' + 'MODFLOW.chm';
  end;
  CallHelp := True;
  result := True;
end;

procedure TfrmMPathPlot.rgDataTypeClick(Sender: TObject);
begin
  rgPlotLocation.Enabled := rgDataType.ItemIndex = 1;
  if DataTypeIndex <> rgDataType.ItemIndex then
  begin
    DataTypeIndex := rgDataType.ItemIndex;
    ClearPathLines;
    Paintbox1.Invalidate;
  end;
  case rgDataType.ItemIndex of
    0:
      begin
        OpenDialog1.Filter := 'Pathlines (*.lin)|*.lin|All Files (*.*)|*.*';
        TabEndPoints.TabVisible := False;
      end;
    1:
      begin
        OpenDialog1.Filter := 'Endpoints (*.end)|*.end|All Files (*.*)|*.*';
        TabEndPoints.TabVisible := True;
      end;
    2:
      begin
        OpenDialog1.Filter := 'Time Series (*.tse)|*.tse|All Files (*.*)|*.*';
        TabEndPoints.TabVisible := False;
      end;
    else
      begin
        Assert(False);
      end;
  end;

end;

{ TEndParticleSummary }

function TEndParticleSummary.Velocity: double;
begin
  if TravelTime = 0 then
  begin
    result := 0;
  end
  else
  begin
    result := TravelDistance/TravelTime;
  end;
end;

{ TEndSummaryItem }

constructor TEndSummaryItem.Create;
begin
  inherited;
  ParticleSummaryList := TList.Create;
end;

destructor TEndSummaryItem.Destroy;
var
  Index : Integer;
begin
  for Index := 0 to ParticleSummaryList.Count -1 do
  begin
    TEndParticleSummary(ParticleSummaryList[Index]).Free;
  end;
  ParticleSummaryList.Free;
  inherited;
end;

function SortParticleSummariesByTime(Item1, Item2: Pointer): Integer;
var
  AnEndParticleSummary : TEndParticleSummary;
  AnotherEndParticleSummary : TEndParticleSummary;
begin
  AnEndParticleSummary := Item1;
  AnotherEndParticleSummary := Item2;
  if AnEndParticleSummary.TravelTime < AnotherEndParticleSummary.TravelTime then
  begin
    result := -1;
  end
  else if AnEndParticleSummary.TravelTime = AnotherEndParticleSummary.TravelTime then
  begin
    result := 0;
  end
  else
  begin
    result := 1;
  end;
end;


function TEndSummaryItem.GetValue(ValueType: TEndpointSummary): string;
var
  Index : integer;
  TotalParticles : integer;
  AnEndSummaryItem : TEndSummaryItem;
  ATravelTime, AnotherTravelTime : double;
  AnEndParticleSummary : TEndParticleSummary;
  TravTimeSqrd, SumTravTime : double;
  ADistance : double;
  AVelocity, AnotherVelocity : double;
  VelocitySqrd, SumVelocity : double;
begin
  case ValueType of
    esZone:
      begin
        result := IntToStr(Zone);
      end;
    esNParticles:
      begin
        result := IntToStr(ParticleSummaryList.Count);
      end;
    esPercentParticles:
      begin
        TotalParticles := 0;
        for Index := 0 to EndSummaryList.Count -1 do
        begin
          AnEndSummaryItem := EndSummaryList[Index];
          TotalParticles := TotalParticles + AnEndSummaryItem.ParticleSummaryList.Count;
        end;
        if TotalParticles = 0 then
        begin
          result := 'Not available';
        end
        else
        begin
          result := FloatToStrF(100* ParticleSummaryList.Count/TotalParticles,ffNumber,15,15);
        end;
      end;
    esMaxTravTime:
      begin
        ATravelTime := 0;
        if ParticleSummaryList.Count > 0 then
        begin
          for Index := 0 to ParticleSummaryList.Count -1 do
          begin
            AnEndParticleSummary := ParticleSummaryList[Index];
            AnotherTravelTime  := AnEndParticleSummary.TravelTime;
            if AnotherTravelTime > ATravelTime then
            begin
              ATravelTime := AnotherTravelTime;
            end;
          end;
        end;
        result := FloatToStrF(ATravelTime,ffNumber,15,15);
      end;
    esMinTravTime:
      begin
        ATravelTime := 0;
        if ParticleSummaryList.Count > 0 then
        begin
          AnEndParticleSummary := ParticleSummaryList[0];
          ATravelTime  := AnEndParticleSummary.TravelTime;
          for Index := 1 to ParticleSummaryList.Count -1 do
          begin
            AnEndParticleSummary := ParticleSummaryList[Index];
            AnotherTravelTime  := AnEndParticleSummary.TravelTime;
            if AnotherTravelTime < ATravelTime then
            begin
              ATravelTime := AnotherTravelTime;
            end;
          end;
        end;
        result := FloatToStrF(ATravelTime,ffNumber,15,15);
      end;
    esMeanTravTime:
      begin
        ATravelTime := 0;
        if ParticleSummaryList.Count > 0 then
        begin
          for Index := 0 to ParticleSummaryList.Count -1 do
          begin
            AnEndParticleSummary := ParticleSummaryList[Index];
            ATravelTime  := ATravelTime + AnEndParticleSummary.TravelTime;
          end;
          result := FloatToStrF(ATravelTime/ParticleSummaryList.Count,ffNumber,15,15);
        end
        else
        begin
          result := 'Not available';
        end;
      end;
    esMedianTravTime:
      begin
        ParticleSummaryList.Sort(SortParticleSummariesByTime);
        Index := ParticleSummaryList.Count div 2;
        if ParticleSummaryList.Count > 0 then
        begin
          if Odd(ParticleSummaryList.Count) then
          begin
            AnEndParticleSummary := ParticleSummaryList[Index];
            ATravelTime  := AnEndParticleSummary.TravelTime;
          end
          else
          begin
            AnEndParticleSummary := ParticleSummaryList[Index];
            ATravelTime  := AnEndParticleSummary.TravelTime;
            AnEndParticleSummary := ParticleSummaryList[Index-1];
            ATravelTime  := (ATravelTime + AnEndParticleSummary.TravelTime)/2;
          end;
          result := FloatToStrF(ATravelTime,ffNumber,15,15);
        end
        else
        begin
          result := 'Not available';
        end;
      end;
    esStDTravTime:
      begin
        TravTimeSqrd := 0;
        SumTravTime := 0;
//        ATravelTime := 0;
        if ParticleSummaryList.Count > 0 then
        begin
          for Index := 0 to ParticleSummaryList.Count -1 do
          begin
            AnEndParticleSummary := ParticleSummaryList[Index];
            ATravelTime  := AnEndParticleSummary.TravelTime;
            SumTravTime := SumTravTime + ATravelTime;
            TravTimeSqrd := TravTimeSqrd + Sqr(ATravelTime);
          end;
          result := FloatToStrF(Sqrt((TravTimeSqrd
            - Sqr(SumTravTime/ParticleSummaryList.Count))
            /(ParticleSummaryList.Count-1)),ffNumber,15,15);
        end
        else
        begin
          result := 'Not available';
        end;
      end;
    esMeanDist:
      begin
        ADistance := 0;
        if ParticleSummaryList.Count > 0 then
        begin
          for Index := 0 to ParticleSummaryList.Count -1 do
          begin
            AnEndParticleSummary := ParticleSummaryList[Index];
            ADistance  := ADistance + AnEndParticleSummary.TravelDistance;
          end;
          result := FloatToStrF(ADistance/ParticleSummaryList.Count,ffNumber,15,15);
        end
        else
        begin
          result := 'Not available';
        end;
      end;
    esMeanVelocity:
      begin
        AVelocity := 0;
        if ParticleSummaryList.Count > 0 then
        begin
          for Index := 0 to ParticleSummaryList.Count -1 do
          begin
            AnEndParticleSummary := ParticleSummaryList[Index];
            AVelocity  := AVelocity + AnEndParticleSummary.Velocity;
          end;
          result := FloatToStrF(AVelocity/ParticleSummaryList.Count,ffNumber,15,15);
        end
        else
        begin
          result := 'Not available';
        end;
      end;
    esMaxVelocity:
      begin
        AVelocity := 0;
        if ParticleSummaryList.Count > 0 then
        begin
          for Index := 0 to ParticleSummaryList.Count -1 do
          begin
            AnEndParticleSummary := ParticleSummaryList[Index];
            AnotherVelocity  := AnEndParticleSummary.Velocity;
            if AnotherVelocity > AVelocity then
            begin
              AVelocity := AnotherVelocity;
            end;
          end;
        end;
        result := FloatToStrF(AVelocity,ffNumber,15,15);
      end;
    esMinVelocity:
      begin
        AVelocity := 0;
        if ParticleSummaryList.Count > 0 then
        begin
          AnEndParticleSummary := ParticleSummaryList[0];
          AVelocity  := AnEndParticleSummary.Velocity;
          for Index := 1 to ParticleSummaryList.Count -1 do
          begin
            AnEndParticleSummary := ParticleSummaryList[Index];
            AnotherVelocity  := AnEndParticleSummary.Velocity;
            if AnotherVelocity < AVelocity then
            begin
              AVelocity := AnotherVelocity;
            end;
          end;
        end;
        result := FloatToStrF(AVelocity,ffNumber,15,15);
      end;
    esStDVelocity:
      begin
        VelocitySqrd := 0;
        SumVelocity := 0;
//        AVelocity := 0;
        if ParticleSummaryList.Count > 0 then
        begin
          for Index := 0 to ParticleSummaryList.Count -1 do
          begin
            AnEndParticleSummary := ParticleSummaryList[Index];
            AVelocity  := AnEndParticleSummary.Velocity;
            SumVelocity := SumVelocity + AVelocity;
            VelocitySqrd := VelocitySqrd + Sqr(AVelocity);
          end;
          result := FloatToStrF(Sqrt((VelocitySqrd
            - Sqr(SumVelocity/ParticleSummaryList.Count))
            /(ParticleSummaryList.Count-1)),ffNumber,15,15);
        end
        else
        begin
          result := 'Not available';
        end;
      end;
  end;

end;

{ TPosition }

function TPosition.Distance: double;
begin
  result := Sqrt(Sqr(StartingX - X) + Sqr(StartingY - Y));
end;

function TPosition.TravelTime: double;
begin
  result := Time;// - ReleaseTime;
end;


procedure TfrmMPathPlot.rgEndpointSummaryClick(Sender: TObject);
begin
  SummarizeEndpoints;
end;

{procedure TfrmMPathPlot.Moved(var Message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  if CurrentModelHandle <> nil then
  begin
    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;  }

procedure TfrmMPathPlot.PageContModpathChange(Sender: TObject);
begin
  FreePageControlResources(PageContModpath, Handle);
end;

initialization
begin
  PathLinesList := TPathLineList.Create;
  EndSummaryList := TList.Create;
end;

finalization
begin
  ClearPathLines;
  PathLinesList.Free;
  ClearEndSummaryList;
  EndSummaryList.Free;
end;

end.
