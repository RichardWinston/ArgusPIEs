unit WriteAdvectionObservationsUnit;

interface

uses Sysutils, Forms, StdCtrls, grids, Classes, contnrs, AnePIE,
  WriteModflowDiscretization, OptionsUnit;

type
  TAdvectionObservationWriter = class;

  TLocation = record
    Layer : integer;
    Row : integer;
    Column : integer;
    LayerOffset : double;
    RowOffset : double;
    ColumnOffset : double;
    GroupNumber : integer;
  end;

  TAdvObservation = record
    Location : TLocation;
    Name : String[12];
    XStat : double;
    YStat : double;
    ZStat : double;
    XStatFlag : integer;
    YStatFlag : integer;
    ZStatFlag : integer;
    Time : double;
    PlotSymbol : integer;
    XObservationIndex : integer;
    YObservationIndex : integer;
    ZObservationIndex : integer;
  end;

  TObservationParamIndicies = record
    Name : ANE_INT16;
    XObservationNumber : ANE_INT16;
    YObservationNumber : ANE_INT16;
    ZObservationNumber : ANE_INT16;
    ElevIndex : ANE_INT16;
    LayerIndex : ANE_INT16;
    GroupNumberIndex : ANE_INT16;
    XStatistic : ANE_INT16;
    YStatistic : ANE_INT16;
    ZStatistic : ANE_INT16;
    XStatFlag : ANE_INT16;
    YStatFlag : ANE_INT16;
    ZStatFlag : ANE_INT16;
    PlotSymbol : ANE_INT16;
    Time : ANE_INT16;
    IsObservationIndex : ANE_INT16;
    IsPredictionIndex : ANE_INT16;
  end;

  TStartParamIndicies = record
    ElevIndex : ANE_INT16;
    LayerIndex : ANE_INT16;
    GroupNumberIndex : ANE_INT16;
  end;

  TAdvObservationObject = class(TObject)
    Location : TAdvObservation;
    procedure Write(Writer : TAdvectionObservationWriter;
      const StatErrors: TStringList);
  end;

  TObservationList = Class(TObjectList)
    function Add(AnObservation: TAdvObservation): Integer;
    procedure Write(Writer : TAdvectionObservationWriter;
      const StatErrors: TStringList);
    procedure Sort;
  end;

  TObservationSet = class(TObject)
    Location : TLocation;
    ObservationList : TObservationList;
    Constructor Create;
    Destructor Destroy; override;
    procedure Write(Writer : TAdvectionObservationWriter;
      const StatErrors: TStringList);
  end;

  TObservationSetList = Class(TObjectList)
    CurrentObsSetIndex : integer;
    CurrentObsIndex : integer;
    DimensionIndex : integer;
    function Add(ALocation: TLocation): Integer; overload;
    function Add(AnAdvLocation: TAdvObservation): Integer; overload;
    procedure Write(Writer : TAdvectionObservationWriter;
      const StatErrors: TStringList);
    function GetSetByIndex(ObservationGroupNumber : integer) : TObservationSet;
    function GetNextStat : double;
    procedure Sort;
  end;

  TAdvectionObservationWriter = class(TListWriter)
  private
    NLOC : integer;
    ModelHandle : ANE_PTR;
    StartErrors, ObservationErrors : integer;
    ObservationList : TObservationSetList;
    {ReverseObservationIndicies,} ObservationIndicies : array of integer;
    ObservationStatistics : array of double;
    UsePredictions : boolean;
    StartPointErrors: TStringList;
    Procedure EvaluatePorosity(Discretization : TDiscretizationWriter;
      BasicWriter: TBasicPkgWriter);
    procedure WritePorosityUnit(Discretization : TDiscretizationWriter; UnitIndex : integer);
    procedure SetArraySize(Discretization : TDiscretizationWriter);
    procedure WriteDataSet1;
    Procedure WriteDataSets3and4;
    procedure WriteDataSets5to7(Discretization: TDiscretizationWriter);
    procedure SetObservationIndicies(UseX, UseY, UseZ : boolean);
//    function GetObservationIndex(Index: integer): integer;
    procedure AddStartLayer(LayerIndex: integer);
    procedure EvaluateStartLayers(BasicWriter: TBasicPkgWriter);
    procedure GetAStartContourProperties(LayerHandle: ANE_PTR;
      ContourIndex: ANE_INT32; ParamIndicies: TStartParamIndicies;
      BasicWriter: TBasicPkgWriter);
    procedure GetStartContourProperties(Layer: TLayerOptions;
      BasicWriter: TBasicPkgWriter);
    function StartLayerCount: integer;
    function StartLayerName(LayerIndex: integer): string;
    function GetStartParamIndicies(
      Layer: TLayerOptions): TStartParamIndicies;
    procedure AddObservationLayer(LayerIndex: integer);
    function ObservationLayerName(LayerIndex: integer): string;
    procedure GetAnObservationContourProperties(LayerHandle: ANE_PTR;
      ContourIndex: ANE_INT32; ParamIndicies: TObservationParamIndicies;
      {Discretization: TDiscretizationWriter;} BasicWriter: TBasicPkgWriter);
    procedure GetObservationContourProperties(Layer: TLayerOptions;
      BasicWriter: TBasicPkgWriter);
    function GetObservationParamIndicies(
      Layer: TLayerOptions): TObservationParamIndicies;
    function ObservationLayerCount: integer;
    procedure EvaluateObservationLayers(BasicWriter: TBasicPkgWriter);
    procedure WritePorosity(Discretization: TDiscretizationWriter);
    function FormatF(ADouble : double) : String;
//    function FormatF5(ADouble : double) : String;
//    function FormatF10(ADouble : double) : String;
    procedure WriteDataSet2(Discretization : TDiscretizationWriter;
      BasicWriter: TBasicPkgWriter);
  public
    Porosity : array of array of array of double;
    procedure WriteFile(const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter; BasicWriter: TBasicPkgWriter);
    constructor Create;
    destructor Destroy; override;
    class procedure AssignUnitNumbers;
  end;

implementation

uses WriteNameFileUnit, ProgressUnit, Variables, GetCellUnit, GetCellVertexUnit,
  GridUnit, UnitNumbers, UtilityFunctions, FixNameUnit, DataGrid;

function SortObservations(Item1, Item2: Pointer): Integer;
var
  Obs1, Obs2 : TAdvObservationObject;
  difference : double;
begin
  Obs1 := Item1;
  Obs2 := Item2;
  difference := Obs1.Location.Time - Obs2.Location.Time;
  if difference > 0 then
  begin
    result := 1;
  end
  else if difference < 0 then
  begin
    result := 1;
  end
  else
  begin
    result := 0;
  end;
end;


{ TObservationSetList }

function TObservationSetList.Add(ALocation: TLocation): Integer;
var
  AnObservationSet: TObservationSet;
begin
  AnObservationSet := TObservationSet.Create;
  AnObservationSet.Location := ALocation;
  result := inherited Add(AnObservationSet);
end;

function TObservationSetList.Add(AnAdvLocation: TAdvObservation): Integer;
var
  AnObservationSet : TObservationSet;
begin
  AnObservationSet := GetSetByIndex(AnAdvLocation.Location.GroupNumber);
  result := IndexOf(AnObservationSet);
  if AnObservationSet <> nil then
  begin
    AnObservationSet.ObservationList.Add(AnAdvLocation);
  end;
end;

function TObservationSetList.GetNextStat: double;
var
  AnObservationSet : TObservationSet;
  AnObservationObject : TAdvObservationObject;
begin
  Inc(DimensionIndex);
  if DimensionIndex = 3 then
  begin
    Inc(CurrentObsIndex);
    DimensionIndex := 0;
  end;

  AnObservationSet := Items[CurrentObsSetIndex] as TObservationSet;
  if CurrentObsIndex = AnObservationSet.ObservationList.Count then
  begin
    Inc(CurrentObsSetIndex);
    AnObservationSet := Items[CurrentObsSetIndex] as TObservationSet;
    CurrentObsIndex := 0;
  end;

  AnObservationObject := AnObservationSet.ObservationList[CurrentObsIndex]
    as TAdvObservationObject;

  result := 0;
  case DimensionIndex of
    0:
      begin
        result := AnObservationObject.Location.XStat;
      end;
    1:
      begin
        result := AnObservationObject.Location.YStat;
      end;
    2:
      begin
        result := AnObservationObject.Location.ZStat;
      end;
  else Assert(False);
  end;



end;

function TObservationSetList.GetSetByIndex(
  ObservationGroupNumber: integer): TObservationSet;
var
  Index : integer;
  AnObservationSet : TObservationSet;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    AnObservationSet := Items[Index] as TObservationSet;
    if AnObservationSet.Location.GroupNumber = ObservationGroupNumber then
    begin
      result := AnObservationSet;
      Exit;
    end;
  end;
end;

procedure TObservationSetList.Sort;
var
  Index : integer;
  AnObservationSet : TObservationSet;
begin
  for Index := 0 to Count-1 do
  begin
    AnObservationSet := Items[Index] as TObservationSet;
    AnObservationSet.ObservationList.Sort;
  end;
end;

procedure TObservationSetList.Write(Writer: TAdvectionObservationWriter;
  const StatErrors: TStringList);
var
  Index : integer;
  AnObservationSet : TObservationSet;
begin
  for Index := 0 to Count-1 do
  begin
    AnObservationSet := Items[Index] as TObservationSet;
    AnObservationSet.Write(Writer, StatErrors);
  end;
end;

{ TObservationList }

function TObservationList.Add(AnObservation: TAdvObservation): Integer;
var
  AnObservationObject : TAdvObservationObject;
begin
  AnObservationObject := TAdvObservationObject.Create;
  AnObservationObject.Location := AnObservation;
  result := inherited Add(AnObservationObject);
end;

procedure TObservationList.Sort;
begin
  Inherited Sort(SortObservations);
end;

procedure TObservationList.Write(Writer: TAdvectionObservationWriter;
  const StatErrors: TStringList);
var
  Index : integer;
  AnObservationObject : TAdvObservationObject;
  ErrorMessage : string;
begin
  if Count = 0 then
  begin
    ErrorMessage := 'Error: no observations were specified for use with the '
      + 'Advection Observations package'
      + '.  You should either turn off the '
      + 'Advection Observations package'
      + ' or specify some observations to use with it.';
    ErrorMessages.Add(ErrorMessage);
    frmProgress.reErrors.Lines.Add(ErrorMessage);
  end;
  for Index := 0 to Count-1 do
  begin
    AnObservationObject := Items[Index] as TAdvObservationObject;
    AnObservationObject.Write(Writer, StatErrors);
  end;
end;

{ TObservationSet }

constructor TObservationSet.Create;
begin
  inherited;
  ObservationList := TObservationList.Create;
end;

destructor TObservationSet.Destroy;
begin
  ObservationList.Free;
  inherited;
end;

procedure TObservationSet.Write(Writer: TAdvectionObservationWriter;
  const StatErrors: TStringList);
//var
//  AFile : TextFile;
begin
//  AFile := Writer.FFile;
  // Data set 3
  Writeln(Writer.FFile, ObservationList.Count, ' ',
    Location.Layer, ' ',
    Location.Row, ' ',
    Location.Column, ' ',
    Writer.FreeFormattedReal(Location.LayerOffset),
    Writer.FreeFormattedReal(Location.RowOffset),
    Writer.FreeFormattedReal(Location.ColumnOffset));
{  Writeln(Writer.FFile, Format('%5u%5u%5u%5u%5s%5s%5s', [ObservationList.Count,
    Location.Layer, Location.Row, Location.Column,
    Writer.FormatF5(Location.LayerOffset), Writer.FormatF5(Location.RowOffset),
    Writer.FormatF5(Location.ColumnOffset)])); }
{  Writer.FormatF5(Location.LayerOffset);
  Writer.FormatF5(Location.RowOffset);
  Writer.FormatF5(Location.ColumnOffset);
  Writeln(Writer.FFile);}

  // data set 4
  ObservationList.Write(Writer, StatErrors);
end;

{ TAdvObservationObject }

procedure TAdvObservationObject.Write(Writer: TAdvectionObservationWriter;
  const StatErrors: TStringList);
var
  AName : string;
  Position : integer;
begin
  AName := Trim(Location.Name);
  Position := Pos(' ', AName);
  while (Position > 0) do
  begin
    AName[Position] := '_';
    Position := Pos(' ', AName);
  end;
  AddObservationName(AName);
  AName := '''' + AName + ''' ';

  if (Location.XStat <= 0) or (Location.YStat <= 0) or (Location.ZStat <= 0) then
  begin
    StatErrors.Add(AName + ', ' + IntToStr(Location.Location.Column)
      + ', ' + IntToStr(Location.Location.Row)
      + ', ' + IntToStr(Location.Location.Layer));
  end;

  // data set 4
  Writeln(Writer.FFile, AName,
    Location.Location.Layer, ' ',
    Location.Location.Row, ' ',
    Location.Location.Column, ' ',
    Writer.FreeFormattedReal(Location.Location.LayerOffset),
    Writer.FreeFormattedReal(Location.Location.RowOffset),
    Writer.FreeFormattedReal(Location.Location.ColumnOffset),
    Writer.FreeFormattedReal(Location.XStat),
    Location.XStatFlag, ' ',
    Writer.FreeFormattedReal(Location.YStat),
    Location.YStatFlag, ' ',
    Writer.FreeFormattedReal(Location.ZStat),
    Location.ZStatFlag, ' ',
    Writer.FreeFormattedReal(Location.Time),
    Location.PlotSymbol
    );
{  FormatString := '%4s %5u%5u%5u%5s%5s%5s%5s%3u%5s%3u%5s%3u%10s%5u';
  Writeln(Writer.FFile, Format(FormatString,
    [Location.Name,
     Location.Location.Layer,
     Location.Location.Row,
     Location.Location.Column,
     Writer.FormatF5(Location.Location.LayerOffset),
     Writer.FormatF5(Location.Location.RowOffset),
     Writer.FormatF5(Location.Location.ColumnOffset),
     Writer.FormatF5(Location.XStat),
     Location.XStatFlag,
     Writer.FormatF5(Location.YStat),
     Location.YStatFlag,
     Writer.FormatF5(Location.ZStat),
     Location.ZStatFlag,
     Writer.FormatF10(Location.Time),
     Location.PlotSymbol
    ]));   }
{  Writer.FormatF5(Location.Location.LayerOffset);
  Writer.WriteF5(Location.Location.RowOffset);
  Writer.WriteF5(Location.Location.ColumnOffset);
  Writer.WriteF5(Location.XStat);
  Write(Writer.FFile, Format('%5u', [Location.XStatFlag]));
  Writer.FormatF5(Location.YStat);
  Write(Writer.FFile, Format('%5u', [Location.YStatFlag]));
  Writer.FormatF5(Location.ZStat);
  Write(Writer.FFile, Format('%5u', [Location.ZStatFlag]));
  if Location.Time < 0 then
  begin
    Write(Writer.FFile, Format(' %8f', [Location.Time]));
  end
  else
  begin
    Write(Writer.FFile, Format(' %9f', [Location.Time]));
  end;
  Writeln(Writer.FFile, Format('%5u', [Location.PlotSymbol])); }

{  Writeln(Writer.FFile, Format('%4s %5u%5u%5u %4f %4f %4f %4f%5u %4f%5u %4f%5u %9f%5u',
    [Location.Name, Location.Location.Layer, Location.Location.Row,
     Location.Location.Column, Location.Location.LayerOffset,
     Location.Location.RowOffset, Location.Location.ColumnOffset,
     Location.XStat, Location.XStatFlag, Location.YStat, Location.YStatFlag,
     Location.ZStat, Location.ZStatFlag, Location.Time, Location.PlotSymbol])); }
end;

{ TAdvectionObservationWriter }

procedure TAdvectionObservationWriter.EvaluatePorosity
  (Discretization : TDiscretizationWriter; BasicWriter: TBasicPkgWriter);
var
  UnitIndex, ColIndex, RowIndex : integer;
  GridLayer : TLayerOptions;
  ParameterName : string;
  ParameterIndex : ANE_INT16;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  AValue : ANE_DOUBLE;
begin
  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
//      if frmMODFLOW.Simulated(UnitIndex) then
//      begin
        ParameterName := ModflowTypes.GetMFGridMOCPorosityParamType.WriteParamName
          + IntToStr(UnitIndex);
        ParameterIndex := GridLayer.GetParameterIndex(ModelHandle,ParameterName);
        for RowIndex := 0 to Discretization.NROW -1 do
        begin
          for ColIndex := 0 to Discretization.NCOL -1 do
          begin
{            if BasicWriter.IBOUND[ColIndex, RowIndex, UnitIndex -1] = 0 then
            begin
              Porosity[ColIndex, RowIndex, UnitIndex-1] := 0;
            end
            else
            begin  }
              BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
              ABlock := TBlockObjectOptions.Create(ModelHandle,
                Discretization.GridLayerHandle, BlockIndex);
              try
                AValue := ABlock.GetFloatParameter
                  (ModelHandle, ParameterIndex);
                Porosity[ColIndex, RowIndex, UnitIndex-1] := AValue;
              finally
                ABlock.Free;
              end;
//            end;
            frmProgress.pbActivity.StepIt;
          end;
        end;
//      end;
    end;
  finally
    GridLayer.Free(ModelHandle);
  end;


end;

procedure TAdvectionObservationWriter.SetArraySize(
  Discretization: TDiscretizationWriter);
begin
  SetLength(Porosity, Discretization.NCOL, Discretization.NROW,
    Discretization.NUNITS);
  SetLength(ObservationIndicies,NLOC);
end;

procedure TAdvectionObservationWriter.WriteDataSet1;
var
  NPTH, IOUTADV, KTFLG, KTREV {, NCLAY} : integer;
  ADVSTP, FSNK  : double;
  Index : integer;
  AnObservationSet: TObservationSet;
begin
  NPTH := ObservationList.Count;
  NLOC := 0;
  for Index := 0 to ObservationList.Count -1 do
  begin
    AnObservationSet := ObservationList.Items[Index] as TObservationSet;
    NLOC := NLOC + AnObservationSet.ObservationList.Count;
  end;
  IOUTADV :=  frmModflow.GetUnitNumber('ADV_Particles');
  KTFLG := frmModflow.rgAdvObsDisplacementOption.ItemIndex + 1;
  if frmModflow.rgPartDisp.ItemIndex = 0 then
  begin
    KTREV:= 1;
  end
  else
  begin
    KTREV:= -1;
  end;
  ADVSTP := InternationalStrToFloat(frmMODFLOW.adeAdvstp.Text);
  if frmMODFLOW.cbAdvObsPartDischarge.Checked then
  begin
    FSNK := -1;
  end
  else
  begin
    FSNK := InternationalStrToFloat(frmMODFLOW.adeAdvObsDischargeLimit.Text);
  end;

  WriteLn(FFile, NPTH, ' ', NLOC, ' ', IOUTADV, ' ', KTFLG, ' ', KTREV, ' ',
    FreeFormattedReal(ADVSTP), FreeFormattedReal(FSNK));
end;

procedure TAdvectionObservationWriter.WriteDataSets3and4;
var
  StatErrors: TStringList;
  ErrorMessage: string;
begin
  StatErrors := TStringList.Create;
  try
    ObservationList.Write(self, StatErrors);
    if StatErrors.Count > 0 then
    begin
      ErrorMessages.Add('');

      ErrorMessage :=
        'Error: XStat, YStat or ZStat were less than or equal to '
        + 'zero for one or more Advection Observations.';
      ErrorMessages.Add(ErrorMessage);
      frmProgress.reErrors.Lines.Add(ErrorMessage);

      ErrorMessage := '(Observation Name, Column, Row, Layer)';
      ErrorMessages.Add(ErrorMessage);

      ErrorMessages.AddStrings(StatErrors);
    end;

  finally
    StatErrors.Free;
  end;
end;

procedure TAdvectionObservationWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter; BasicWriter: TBasicPkgWriter);
var
  FileName : string;
  ErrorMessage : string;
begin
  ModelHandle := CurrentModelHandle;
  ObservationList := TObservationSetList.Create;
  try
    if ContinueExport then
    begin
      frmProgress.lblPackage.Caption := 'Advection Observations';
      UsePredictions := frmModflow.UsePredictions;
      EvaluateStartLayers(BasicWriter);
      EvaluateObservationLayers(BasicWriter);
      SetArraySize(Discretization);
      FileName := GetCurrentDir + '\' + Root + rsOad;
      AssignFile(FFile,FileName);
      try
        Rewrite(FFile);
        WriteDataReadFrom(FileName);
        WriteDataSet1;
        // data set 2
        WriteDataSet2(Discretization, BasicWriter);
        WriteDataSets3and4;
        WriteDataSets5to7(Discretization);
      finally
        CloseFile(FFile);
      end;
      if StartErrors > 0 then
      begin
        ErrorMessage := 'Warning: ' + IntToStr(StartErrors) + ' contours for '
          + 'the beginning '
          + 'points of advections observation are open or closed contours.  '
          + 'These contours will be ignored.';
        frmProgress.reErrors.Lines.Add(ErrorMessage);
        ErrorMessages.Add(ErrorMessage);
      end;
      if ObservationErrors > 0 then
      begin
        ErrorMessage := 'Warning: ' + IntToStr(ObservationErrors) + ' contours for '
          + 'the observation '
          + 'points of advections observation are open or closed contours.  '
          + 'These contours will be ignored.';
        frmProgress.reErrors.Lines.Add(ErrorMessage);
        ErrorMessages.Add(ErrorMessage);
      end;




    end;
  finally
    ObservationList.Free;
  end;
end;

procedure TAdvectionObservationWriter.WriteDataSet2(
  Discretization : TDiscretizationWriter; BasicWriter: TBasicPkgWriter);
var
  NPADV, IPFLG: integer;
  ParameterIndex: integer;
  PARNAM, PARTYP: String;
  Parval: double;
  NCLU: integer;
  typeIndex: integer;
  ClusterIndex: integer;
  Grid: TDataGrid;
  LayerIndex: integer;
  Mltarr, Zonarr: string;
  UnitIndex: integer;
  IZ: integer;
  Zones: string;
  ZoneIndex: integer;
  LayersAbove: integer;
  NumberOfClusterUnits: integer;
begin
  NPADV := StrToInt(frmModflow.adeADVParamCount.Text);
  if NPADV = 0 then
  begin
    EvaluatePorosity(Discretization, BasicWriter);
    WritePorosity(Discretization);
  end
  else
  begin
    IPFLG := 12;
    WriteLn(FFile, 'PARAMETER ', NPADV, ' ', IPFLG);
    for ParameterIndex := 1 to frmModflow.dgADVParameters.RowCount -1 do
    begin
      PARNAM := frmModflow.dgADVParameters.Cells[0,ParameterIndex];
      typeIndex := frmModflow.dgADVParameters.Columns[1].PickList.IndexOf(
        frmModflow.dgADVParameters.Cells[1,ParameterIndex]);
      Assert(typeIndex in [0, 1]);
      case typeIndex of
        0:
          begin
            PARTYP := 'PRST';
          end;
        1:
          begin
            PARTYP := 'PRCB';
          end;
      else
          begin
            PARTYP := 'None';
            Assert(False);
          end;
      end;
      Parval := InternationalStrToFloat(frmModflow.dgADVParameters.
        Cells[2,ParameterIndex]);
      NumberOfClusterUnits := StrToInt(frmModflow.dgADVParameters.
        Cells[3,ParameterIndex]);
        
      NCLU := 0;
      Grid := frmModflow.dg3dADVParameterClusters.Grids[ParameterIndex-1];
      for ClusterIndex := 1 to NumberOfClusterUnits do
      begin
        UnitIndex := StrToInt(Grid.Cells[0,ClusterIndex]);
        if frmModflow.Simulated(UnitIndex) then
        begin
          NCLU := NCLU + frmModflow.DiscretizationCount(UnitIndex);
        end
        else
        begin
          Inc(NCLU);
        end;

      end;
//      NCLU := StrToInt(frmModflow.dgADVParameters.
//        Cells[3,ParameterIndex]);
      WriteLn(FFile, PARNAM, ' ', PARTYP, ' ', FreeFormattedReal(Parval), NCLU);

      for ClusterIndex := 1 to NumberOfClusterUnits do
      begin
        Mltarr := Grid.Cells[1,ClusterIndex];
        Zonarr := Grid.Cells[2,ClusterIndex];
        UnitIndex := StrToInt(Grid.Cells[0,ClusterIndex]);
        Zones := '';
        for ZoneIndex := 3 to Grid.ColCount -1 do
        begin
          if Grid.Cells[ZoneIndex, ClusterIndex] <> '' then
          begin
            try
              IZ := StrToInt(Grid.Cells[ZoneIndex, ClusterIndex]);
              Zones := Zones + ' ' + IntToStr(IZ);
            except on EConvertError do
              Continue;
            end;
          end;
        end;
        Zones := Trim(Zones);
        LayersAbove := frmModflow.MODFLOWLayersAboveCount(UnitIndex);
        if frmModflow.Simulated(UnitIndex) then
        begin
          Assert(typeIndex = 0);
          for LayerIndex := LayersAbove + 1 to LayersAbove +
            frmModflow.DiscretizationCount(UnitIndex) do
          begin
            WriteLn(FFile, LayerIndex, ' ', Mltarr, ' ', Zonarr, ' ', Zones);
          end;
        end
        else
        begin
          Assert(typeIndex = 1);
          WriteLn(FFile, LayersAbove, ' ', Mltarr, ' ', Zonarr, ' ', Zones);
        end;
      end;
    end;
  end;
end;

procedure TAdvectionObservationWriter.WritePorosity
  (Discretization : TDiscretizationWriter);
var
  UnitIndex : integer;
  DivIndex: integer;

begin
  for UnitIndex := 1 to Discretization.NUNITS do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      for DivIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
      begin
        WritePorosityUnit(Discretization, UnitIndex);
      end;
    end
    else
    begin
      WritePorosityUnit(Discretization, UnitIndex);
    end;
  end;
end;

procedure TAdvectionObservationWriter.WritePorosityUnit
  (Discretization : TDiscretizationWriter; UnitIndex : integer);
var
  RowIndex, ColIndex : integer;
begin
  WriteU2DRELHeader;
  for RowIndex := 0 to Discretization.NROW -1 do
  begin
    Application.ProcessMessages;
    if not ContinueExport then break;

    for ColIndex := 0 to Discretization.NCOL -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      Write(FFile,
        Porosity[ColIndex,RowIndex,UnitIndex-1],
        ' ');

      frmProgress.pbActivity.StepIt;
    end;
    WriteLn(FFile);
  end;
end;

procedure TAdvectionObservationWriter.WriteDataSets5to7(Discretization: TDiscretizationWriter);
//Const
//  WriteFormat = ' %.13e';
//  FMTIN = '(FREE)';
//  FMTIN = '(F20.0)';
var
  RowIndex, ColIndex, Row, Col : integer;
  ObsCol, ObsRow : integer;
  AStringGrid : TStringGrid;
  IOWTQAD, IPRN : integer;
  FMTIN : string;
  Dimensions : integer;
  UseX, UseY, UseZ : boolean;
  Statistic : double;
  IsX, IsY, IsZ : boolean;
  remainder : integer;
  WTQ : array of array of double;
  ObsIndex :integer;
  ObsNumber : integer;

begin
  UseX := Discretization.NCOL > 1;
  UseY := Discretization.NROW > 1;
  UseZ := Discretization.NLay > 1;
  Dimensions := 0;
  if UseX then
  begin
    Inc(Dimensions);
  end;
  if UseY then
  begin
    Inc(Dimensions);
  end;
  if UseZ then
  begin
    Inc(Dimensions);
  end;



  // data set 5
  if frmModflow.cbSpecifyAdvCovariances.Checked then
  begin
    IOWTQAD := 1;
  end
  else
  begin
    IOWTQAD := 0;
  end;
  IPRN := frmModflow.comboAdvObsPrintFormats.ItemIndex + 1;
  WriteLn(FFile, Format('%5u', [IOWTQAD]));

  // data set 6
  if (IOWTQAD > 0) then
  begin
    FMTIN := '(' + IntToStr(NLOC*Dimensions) + 'F20.0)';
    WriteLn(FFile, Format('%20s%5u', [FMTIN, IPRN]));
    // data set 7
    frmProgress.pbActivity.Max := Sqr(NLOC*Dimensions);
    frmProgress.pbActivity.Position := 0;
    frmProgress.lblActivity.Caption := 'Writing variance-covariance matrix';
    Application.ProcessMessages;

    ObservationList.DimensionIndex := -1;
    ObservationList.CurrentObsSetIndex := 0;
    ObservationList.CurrentObsIndex := 0;

    SetObservationIndicies(UseX, UseY, UseZ);

    SetLength(WTQ, NLOC*Dimensions, NLOC*Dimensions);
    for ColIndex := 0 to NLOC*Dimensions-1 do
    begin
      for RowIndex := 0 to NLOC*Dimensions-1 do
      begin
        WTQ[ColIndex,RowIndex] := 0;
      end;
    end;

    ObsNumber := 0;
    for ObsIndex := 0 to NLOC*3-1 do
    begin
      remainder := ObsIndex mod NLOC;
      case remainder of
        0:
          begin
            If UseX then
            begin
              Statistic := ObservationStatistics[ObsNumber];
              WTQ[ObsNumber,ObsNumber] := Statistic;
              Inc(ObsNumber);
            end;
          end;
        1:
          begin
            If UseY then
            begin
              Statistic := ObservationStatistics[ObsNumber];
              WTQ[ObsNumber,ObsNumber] := Statistic;
              Inc(ObsNumber);
            end;
          end;
        2:
          begin
            If UseZ then
            begin
              Statistic := ObservationStatistics[ObsNumber];
              WTQ[ObsNumber,ObsNumber] := Statistic;
              Inc(ObsNumber);
            end;
          end;
      else Assert(False);
      end;
    end;


    AStringGrid := frmModflow.dgAdvObsBoundCovariances;

    ObsCol := 0;
    for ColIndex := 0 to NLOC*3-1 do
    begin
      remainder := ColIndex mod NLOC;
      IsX := Remainder = 0;
      IsY := Remainder = 1;
      IsZ := Remainder = 2;
      if (IsX and UseX) or (IsY and UseY) or (IsZ and UseZ) then
      begin
        Col := ObservationIndicies[ObsCol];
        if (Col > 0) and (Col < AStringGrid.ColCount) then
        begin

          ObsRow := 0;
          for RowIndex := 0 to NLOC*3-1 do
          begin
            remainder := RowIndex mod NLOC;
            IsX := Remainder = 0;
            IsY := Remainder = 1;
            IsZ := Remainder = 2;
            if (IsX and UseX) or (IsY and UseY) or (IsZ and UseZ) then
            begin
              Row := ObservationIndicies[ObsRow];
              if (Row > 0) and (Row < AStringGrid.ColCount) then
              begin
                WTQ[ObsCol,ObsRow] := InternationalStrToFloat(AStringGrid.Cells[Col,Row]);
              end;
              Inc(ObsRow);
            end;
          end;

        end;
        Inc(ObsCol);
      end;
    end;

    for ColIndex := 0 to NLOC*Dimensions-1 do
    begin
      Write(FFile, ' ');
      If ContinueExport then
      begin
        for RowIndex := 0 to NLOC*Dimensions-1 do
        begin
          If ContinueExport then
          begin
            Write(FFile, FreeFormattedReal(WTQ[ColIndex,RowIndex]));
          end;
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;
        end;
        WriteLn(FFile);
      end;
    end;


{    for ColIndex := 1 to NLOC*3 do
    begin
      Write(FFile, ' ');
      If ContinueExport then
      begin
        remainder := ColIndex mod NLOC;
        IsX := Remainder = 1;
        IsY := Remainder = 2;
        IsZ := Remainder = 0;

        Col := GetObservationIndex(ColIndex);
        Statistic := GetObservationStatistic(ColIndex);
        for RowIndex := 1 to NLOC*3 do
        begin
          If ContinueExport then
          begin
            Row := GetObservationIndex(RowIndex);
            if (Col < 1) or (Row < 1)
              or (Col > AStringGrid.ColCount-1)
              or (Row > AStringGrid.RowCount-1) then
            begin
              if ColIndex = RowIndex then
              begin
                Write(FFile, FreeFormattedReal(1.0));
              end
              else
              begin
                Write(FFile, FreeFormattedReal(0.0));
              end;
            end
            else
            begin
              Write(FFile, FreeFormattedReal(InternationalStrToFloat(AStringGrid.Cells[Col,Row])));
            end;
            frmProgress.pbActivity.StepIt;
            Application.ProcessMessages;
          end;
        end;
      end;
      WriteLn(FFile);
    end;}
  end;
  frmProgress.pbPackage.StepIt;
end;

procedure TAdvectionObservationWriter.SetObservationIndicies(UseX, UseY, UseZ : boolean);
var
  GroupIndex, ObservationIndex : integer;
  AnObservationSet: TObservationSet;
  AnObservationObject : TAdvObservationObject;
  ObsIndex : integer;
//  remainder : integer;
//  ReverseIndex : integer;
  Dimensions : integer;
begin
  Dimensions := 0;
  if UseX then
  begin
    Inc(Dimensions);
  end;
  if UseY then
  begin
    Inc(Dimensions);
  end;
  if UseZ then
  begin
    Inc(Dimensions);
  end;

  ObsIndex := 0;
  SetLength(ObservationIndicies, NLOC*Dimensions);
  SetLength(ObservationStatistics, NLOC*Dimensions);
//  SetLength(ReverseObservationIndicies, NLOC*Dimensions);

  for GroupIndex := 0 to ObservationList.Count -1 do
  begin
    AnObservationSet := ObservationList.Items[GroupIndex] as TObservationSet;
    for ObservationIndex := 0 to AnObservationSet.ObservationList.Count -1 do
    begin
      AnObservationObject := AnObservationSet.ObservationList.
        Items[ObservationIndex] as TAdvObservationObject;

      if UseX then
      begin
        ObservationIndicies[ObsIndex] := AnObservationObject.Location.XObservationIndex;
        ObservationStatistics[ObsIndex] := AnObservationObject.Location.XStat;
        Inc(ObsIndex);
      end;

      if UseY then
      begin
        ObservationIndicies[ObsIndex] := AnObservationObject.Location.YObservationIndex;
        ObservationStatistics[ObsIndex] := AnObservationObject.Location.YStat;
        Inc(ObsIndex);
      end;

      if UseZ then
      begin
        ObservationIndicies[ObsIndex] := AnObservationObject.Location.ZObservationIndex;
        ObservationStatistics[ObsIndex] := AnObservationObject.Location.ZStat;
        Inc(ObsIndex);
      end;
    end;
  end;

{  ObsIndex := 0;
  for ObservationIndex := 0 to NLOC*3-1 do
  begin
    remainder := ObservationIndex mod NLOC;
    ReverseIndex := ObservationIndicies[ObservationIndex];
    case remainder of
      0:
        begin
          if UseX then
          begin
            ReverseObservationIndicies[ObsIndex] := ReverseIndex;
            Inc(ObsIndex);
          end;
        end;
      1:
        begin
          if UseY then
          begin
            ReverseObservationIndicies[ObsIndex] := ReverseIndex;
            Inc(ObsIndex);
          end;
        end;
      2:
        begin
          if UseZ then
          begin
            ReverseObservationIndicies[ObsIndex] := ReverseIndex;
            Inc(ObsIndex);
          end;
        end;
    else Assert(False);
    end;

  end;  }

end;

{function TAdvectionObservationWriter.GetObservationStatistic(
  Index: integer): double;
begin
  result := ObservationStatistics[Index-1];
end;  }

{function TAdvectionObservationWriter.GetObservationIndex(
  Index: integer): integer;
{var
  TimeIndex : integer;}
{begin
  result := ObservationIndicies[Index-1];
{  for TimeIndex := 0 to NTT2-1 do
  begin
    if ObservationIndicies[TimeIndex] = Index then
    begin
      result := TimeIndex +1;
      break;
    end;
  end;  }
//end;

procedure TAdvectionObservationWriter.EvaluateStartLayers
  (BasicWriter: TBasicPkgWriter);
var
  LayerIndex : integer;
  LayerName : String;
  Layer : TLayerOptions;
begin
  for LayerIndex := 1 to StartLayerCount do
  begin
    if frmModflow.clbAdvObsStartPoints.State[LayerIndex-1] = cbChecked then
    begin
      AddStartLayer(LayerIndex);
      LayerName := StartLayerName(LayerIndex);
      Layer := TLayerOptions.CreateWithName(LayerName, ModelHandle);
      try
        GetStartContourProperties(Layer, BasicWriter);
      finally
        Layer.Free(ModelHandle);
      end;
    end;
  end;
end;

procedure TAdvectionObservationWriter.EvaluateObservationLayers
  (BasicWriter: TBasicPkgWriter);
var
  LayerIndex : integer;
  LayerName : String;
  Layer : TLayerOptions;
  ErrorMessage: string;
begin
  StartPointErrors.Clear;
  for LayerIndex := 1 to ObservationLayerCount do
  begin
    if frmModflow.clbAdvObs.State[LayerIndex-1] = cbChecked then
    begin
      AddObservationLayer(LayerIndex);
      LayerName := ObservationLayerName(LayerIndex);
      Layer := TLayerOptions.CreateWithName(LayerName, ModelHandle);
      try
        GetObservationContourProperties(Layer, BasicWriter);
      finally
        Layer.Free(ModelHandle);
      end;

    end;
  end;
  ObservationList.Sort;
  if StartPointErrors.Count > 0 then
  begin
    ErrorMessage := 'Error: One or more Advection Observation points does '
      + 'not have a corresponding starting point.';
    frmProgress.reErrors.Lines.Add(ErrorMessage);
    ErrorMessages.Add(ErrorMessage);
    ErrorMessage := 'Check the following "' + ModflowTypes.
      GetMFAdvObsGroupNumberParamType.ANE_ParamName
      + '" parameters and specify '
      + 'starting points for each of them.';
    ErrorMessages.Add(ErrorMessage);
    ErrorMessages.AddStrings(StartPointErrors);
  end;

end;

function TAdvectionObservationWriter.StartLayerCount: integer;
begin
  result := StrToInt(frmModflow.adeAdvectObsStartLayerCount.Text);
end;

function TAdvectionObservationWriter.ObservationLayerCount: integer;
begin
  result := StrToInt(frmModflow.adeAdvectObsLayerCount.Text);
end;

procedure TAdvectionObservationWriter.AddStartLayer(LayerIndex: integer);
begin
  AddVertexLayer(ModelHandle, StartLayerName(LayerIndex));
end;

procedure TAdvectionObservationWriter.AddObservationLayer(LayerIndex: integer);
begin
  AddVertexLayer(ModelHandle, ObservationLayerName(LayerIndex));
end;

function TAdvectionObservationWriter.StartLayerName(LayerIndex: integer): string;
begin
  result := ModflowTypes.GetMFAdvectionObservationsStartingLayerType.WriteNewRoot +
    IntToStr(LayerIndex);
end;

function TAdvectionObservationWriter.ObservationLayerName(LayerIndex: integer): string;
begin
  result := ModflowTypes.GetMFAdvectionObservationsLayerType.WriteNewRoot +
    IntToStr(LayerIndex);
end;

procedure TAdvectionObservationWriter.GetStartContourProperties(Layer : TLayerOptions;
  BasicWriter: TBasicPkgWriter);
var
  ContourIndex : integer;
  ParamIndicies : TStartParamIndicies;
//  TimeIndex : integer;
//  TimeIndicies : TimeParameterList;
//  WeightIndicies : TIntegerList;
begin
  ParamIndicies := GetStartParamIndicies(Layer);
  for ContourIndex := 0 to Layer.NumObjects(ModelHandle, pieContourObject) -1 do
  begin
    GetAStartContourProperties(Layer.LayerHandle,ContourIndex,ParamIndicies,
      BasicWriter);
  end;
end;

procedure TAdvectionObservationWriter.GetObservationContourProperties(Layer : TLayerOptions;
  BasicWriter: TBasicPkgWriter);
var
  ContourIndex : integer;
  ParamIndicies : TObservationParamIndicies;
//  TimeIndex : integer;
//  TimeIndicies : TimeParameterList;
//  WeightIndicies : TIntegerList;
begin
  ParamIndicies := GetObservationParamIndicies(Layer);
  for ContourIndex := 0 to Layer.NumObjects(ModelHandle, pieContourObject) -1 do
  begin
    GetAnObservationContourProperties(Layer.LayerHandle,ContourIndex,
      ParamIndicies, BasicWriter);
  end;
end;

procedure TAdvectionObservationWriter.GetAStartContourProperties(LayerHandle : ANE_PTR;
  ContourIndex : ANE_INT32; ParamIndicies : TStartParamIndicies;
  BasicWriter: TBasicPkgWriter);
var
  Contour : TContourObjectOptions;
  StartLocation : TLocation;
  Elevation : double;
  BlockIndex : integer;
  X, Y : double;
  Below, Above : double;
  LayerTop, LayerBottom : double;
  UnitIndex : integer;
  UnitTop, UnitBottom : double;
  DisIndex, DisCount : integer;
  TopLayerName, BottomLayerName : string;
  TopLayer, BottomLayer : TLayerOptions;
{ procedure Exchange(var Value1, Value2 : double);
  var
    Temp : Double;
  begin
    Temp := Value1;
    Value1 := Value2;
    Value2 := Temp;
  end;  }
begin
  Contour := TContourObjectOptions.Create(ModelHandle, LayerHandle, ContourIndex);
  try
    if Contour.ContourType(ModelHandle) <> ctPoint then
    begin
      Inc(StartErrors);
    end
    else
    begin
      StartLocation.Layer := Contour.GetIntegerParameter(ModelHandle,
        ParamIndicies.LayerIndex);
      StartLocation.GroupNumber := Contour.GetIntegerParameter(ModelHandle,
        ParamIndicies.GroupNumberIndex);
      Elevation := Contour.GetFloatParameter(ModelHandle,
        ParamIndicies.ElevIndex);

      for BlockIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
      begin
        StartLocation.Row := GGetCellRow(ContourIndex,BlockIndex);
        StartLocation.Column := GGetCellColumn(ContourIndex,BlockIndex);
        if GGetCellVertexCount(ContourIndex,BlockIndex) > 0 then
        begin
          X := GGetCellVertexXPos(ContourIndex, BlockIndex, 0);
          Y := GGetCellVertexYPos(ContourIndex, BlockIndex, 0);

          Below := GGetColumnBoundaryPosition(StartLocation.Column-1);
          Above := GGetColumnBoundaryPosition(StartLocation.Column);
{          if Below > Above then
          begin
            Exchange(Below, Above);
          end;           }
          StartLocation.ColumnOffset := (X - (Below + Above)/2)/(Above - Below);

          Below := GGetRowBoundaryPosition(StartLocation.Row-1);
          Above := GGetRowBoundaryPosition(StartLocation.Row);
{         if Below > Above then
          begin
            Exchange(Below, Above);
          end;     }
          StartLocation.RowOffset := (Y - (Below + Above)/2)/(Above - Below);


          UnitIndex := frmModflow.GetUnitIndex(StartLocation.Layer);
          DisCount := frmModflow.DiscretizationCount(UnitIndex);

          Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);

          TopLayerName := ModflowTypes.GetMFTopElevLayerType.ANE_LayerName
            + IntToStr(UnitIndex);
          BottomLayerName := ModflowTypes.GetBottomElevLayerType.ANE_LayerName
            + IntToStr(UnitIndex);

          TopLayer := TLayerOptions.CreateWithName(TopLayerName, ModelHandle);
          BottomLayer := TLayerOptions.CreateWithName(BottomLayerName, ModelHandle);
          try
            UnitTop := TopLayer.RealValueAtXY(ModelHandle, X, Y, TopLayerName);
            UnitBottom := BottomLayer.RealValueAtXY(ModelHandle, X, Y, BottomLayerName);
          finally
            TopLayer.Free(ModelHandle);
            BottomLayer.Free(ModelHandle);
          end;

{          UnitTop := Discretization.Elevations[StartLocation.Column-1,
            StartLocation.Row-1, UnitIndex-1];
          UnitBottom := Discretization.Elevations[StartLocation.Column-1,
            StartLocation.Row-1, UnitIndex]; }
          if DisCount > 1 then
          begin
            DisIndex := frmModflow.GetDiscretizationIndex(UnitIndex, StartLocation.Layer);
            LayerTop := UnitTop - (UnitTop - UnitBottom) * (DisIndex-1)/DisCount;
            LayerBottom := UnitTop - (UnitTop - UnitBottom) * DisIndex/DisCount;
          end
          else
          begin
            LayerTop := UnitTop;
            LayerBottom := UnitBottom;
          end;
          if Elevation > LayerTop then
          begin
            Elevation := LayerTop;
          end;
          if Elevation < LayerBottom then
          begin
            Elevation := LayerBottom;
          end;
          StartLocation.LayerOffset := (Elevation - (LayerBottom + LayerTop)/2)
            /(LayerTop - LayerBottom);
          ObservationList.Add(StartLocation);
        end;
      end;

    end;
  finally
    Contour.Free;
  end;

end;

procedure TAdvectionObservationWriter.GetAnObservationContourProperties
  (LayerHandle : ANE_PTR; ContourIndex : ANE_INT32;
  ParamIndicies : TObservationParamIndicies;
  {Discretization : TDiscretizationWriter;}
  BasicWriter: TBasicPkgWriter);
var
  Contour : TContourObjectOptions;
  Observation : TAdvObservation;
  Elevation : double;
  BlockIndex : integer;
  X, Y : double;
  Below, Above : double;
  LayerTop, LayerBottom : double;
  UnitIndex : integer;
  UnitTop, UnitBottom : double;
  DisIndex, DisCount : integer;
  TopLayerName, BottomLayerName : string;
  TopLayer, BottomLayer : TLayerOptions;
  UseTime : boolean;
//  TopParamIndex, BottomParamIndex : ANE_INT16;
{ procedure Exchange(var Value1, Value2 : double);
  var
    Temp : Double;
  begin
    Temp := Value1;
    Value1 := Value2;
    Value2 := Temp;
  end;  }
begin
  Contour := TContourObjectOptions.Create(ModelHandle, LayerHandle, ContourIndex);
  try
    if Contour.ContourType(ModelHandle) <> ctPoint then
    begin
      Inc(ObservationErrors);
    end
    else
    begin

      if UsePredictions then
      begin
        UseTime := Contour.GetBoolParameter (ModelHandle,
          ParamIndicies.IsPredictionIndex);
      end
      else
      begin
        UseTime := Contour.GetBoolParameter (ModelHandle,
          ParamIndicies.IsObservationIndex);
      end;
      if UseTime then
      begin

        Observation.Location.Layer := Contour.GetIntegerParameter(ModelHandle,
          ParamIndicies.LayerIndex);
        Observation.Location.GroupNumber := Contour.GetIntegerParameter(ModelHandle,
          ParamIndicies.GroupNumberIndex);
        Observation.Name := Contour.GetStringParameter(ModelHandle,
          ParamIndicies.Name);
        Observation.XStat := Contour.GetFloatParameter(ModelHandle,
          ParamIndicies.XStatistic);
        Observation.YStat := Contour.GetFloatParameter(ModelHandle,
          ParamIndicies.YStatistic);
        Observation.ZStat := Contour.GetFloatParameter(ModelHandle,
          ParamIndicies.ZStatistic);
        Observation.XStatFlag := Contour.GetIntegerParameter(ModelHandle,
          ParamIndicies.XStatFlag);
        Observation.YStatFlag := Contour.GetIntegerParameter(ModelHandle,
          ParamIndicies.YStatFlag);
        Observation.ZStatFlag := Contour.GetIntegerParameter(ModelHandle,
          ParamIndicies.ZStatFlag);
        Observation.Time := Contour.GetFloatParameter(ModelHandle,
          ParamIndicies.Time);
        Observation.PlotSymbol := Contour.GetIntegerParameter(ModelHandle,
          ParamIndicies.PlotSymbol);

        if frmModflow.cbSpecifyAdvCovariances.Checked then
        begin
          Observation.XObservationIndex := Contour.GetIntegerParameter(ModelHandle,
          ParamIndicies.XObservationNumber);
          Observation.YObservationIndex := Contour.GetIntegerParameter(ModelHandle,
          ParamIndicies.YObservationNumber);
          Observation.ZObservationIndex := Contour.GetIntegerParameter(ModelHandle,
          ParamIndicies.ZObservationNumber);
        end
        else
        begin
          Observation.XObservationIndex := 0;
          Observation.YObservationIndex := 0;
          Observation.ZObservationIndex := 0;
        end;

        Elevation := Contour.GetFloatParameter(ModelHandle,
          ParamIndicies.ElevIndex);

        for BlockIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
        begin
          Observation.Location.Row := GGetCellRow(ContourIndex,BlockIndex);
          Observation.Location.Column := GGetCellColumn(ContourIndex,BlockIndex);
          if GGetCellVertexCount(ContourIndex,BlockIndex) > 0 then
          begin
            X := GGetCellVertexXPos(ContourIndex, BlockIndex, 0);
            Y := GGetCellVertexYPos(ContourIndex, BlockIndex, 0);

            Below := GGetColumnBoundaryPosition(Observation.Location.Column-1);
            Above := GGetColumnBoundaryPosition(Observation.Location.Column);
  {          if Below > Above then
            begin
              Exchange(Below, Above);
            end;   }
            Observation.Location.ColumnOffset := (X - (Below + Above)/2)/(Above - Below);

            Below := GGetRowBoundaryPosition(Observation.Location.Row-1);
            Above := GGetRowBoundaryPosition(Observation.Location.Row);
  {          if Below > Above then
            begin
              Exchange(Below, Above);
            end;    }
            Observation.Location.RowOffset := (Y - (Below + Above)/2)/(Above - Below);


            UnitIndex := frmModflow.GetUnitIndex(Observation.Location.Layer);
            DisCount := frmModflow.DiscretizationCount(UnitIndex);

            Contour.GetNthNodeLocation(ModelHandle, X, Y, 0);

            TopLayerName := ModflowTypes.GetMFTopElevLayerType.ANE_LayerName
              + IntToStr(UnitIndex);
            BottomLayerName := ModflowTypes.GetBottomElevLayerType.ANE_LayerName
              + IntToStr(UnitIndex);

            TopLayer := TLayerOptions.CreateWithName(TopLayerName, ModelHandle);
            BottomLayer := TLayerOptions.CreateWithName(BottomLayerName, ModelHandle);
            try
              UnitTop := TopLayer.RealValueAtXY(ModelHandle, X, Y, TopLayerName);
              UnitBottom := BottomLayer.RealValueAtXY(ModelHandle, X, Y, BottomLayerName);
            finally
              TopLayer.Free(ModelHandle);
              BottomLayer.Free(ModelHandle);
            end;

  {          UnitTop := Discretization.Elevations[Observation.Location.Column-1,
              Observation.Location.Row-1, UnitIndex-1];
            UnitBottom := Discretization.Elevations[Observation.Location.Column-1,
              Observation.Location.Row-1, UnitIndex];  }
            if DisCount > 1 then
            begin
              DisIndex := frmModflow.GetDiscretizationIndex(UnitIndex, Observation.Location.Layer);
              LayerTop := UnitTop - (UnitTop - UnitBottom) * (DisIndex-1)/DisCount;
              LayerBottom := UnitTop - (UnitTop - UnitBottom) * DisIndex/DisCount;
            end
            else
            begin
              LayerTop := UnitTop;
              LayerBottom := UnitBottom;
            end;
            if Elevation > LayerTop then
            begin
              Elevation := LayerTop;
            end;
            if Elevation < LayerBottom then
            begin
              Elevation := LayerBottom;
            end;
            Observation.Location.LayerOffset := (Elevation - (LayerBottom + LayerTop)/2)
              /(LayerTop - LayerBottom);
            if ObservationList.Add(Observation) < 0 then
            begin
              StartPointErrors.Add(IntToStr(Observation.Location.GroupNumber));
            end;
          end;
        end;
      end;

    end;
  finally
    Contour.Free;
  end;

end;

function TAdvectionObservationWriter.GetStartParamIndicies(Layer : TLayerOptions): TStartParamIndicies;
begin
  result.ElevIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvObsElevParamType.WriteParamName);
  result.LayerIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvObsLayerParamType.WriteParamName);
  result.GroupNumberIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvObsGroupNumberParamType.WriteParamName);
end;

function TAdvectionObservationWriter.GetObservationParamIndicies(Layer : TLayerOptions): TObservationParamIndicies;
begin
  result.ElevIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvObsElevParamType.WriteParamName);
  result.LayerIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvObsLayerParamType.WriteParamName);
  result.GroupNumberIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvObsGroupNumberParamType.WriteParamName);

  result.Name := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvObsNameParamType.WriteParamName);

  if frmModflow.cbSpecifyAdvCovariances.Checked then
  begin
    result.XObservationNumber := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMFXObsNumberParamType.WriteParamName);
    result.YObservationNumber := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMFYObsNumberParamType.WriteParamName);
    result.ZObservationNumber := Layer.GetParameterIndex(ModelHandle,
      ModflowTypes.GetMFZObsNumberParamType.WriteParamName);
  end
  else
  begin
    result.XObservationNumber := -1;
    result.YObservationNumber := -1;
    result.ZObservationNumber := -1;
  end;

  result.XStatistic := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvXStatisticParamType.WriteParamName);
  result.YStatistic := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvYStatisticParamType.WriteParamName);
  result.ZStatistic := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvZStatisticParamType.WriteParamName);
  result.XStatFlag := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvObsXStatFlagParamType.WriteParamName);
  result.YStatFlag := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvObsYStatFlagParamType.WriteParamName);
  result.ZStatFlag := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFAdvObsZStatFlagParamType.WriteParamName);
  result.PlotSymbol := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFPlotSymbolParamType.WriteParamName);
  result.Time := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFTimeParamType.WriteParamName);
  result.IsObservationIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFIsObservationParamType.WriteParamName);
  result.IsPredictionIndex := Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFIsPredictionParamType.WriteParamName);
end;


//function TAdvectionObservationWriter.FormatF5(ADouble: double) : string;
//begin
//  result := copy(FormatF(ADouble), 1, 5);;
//end;
//
//function TAdvectionObservationWriter.FormatF10(ADouble: double): String;
//begin
//  result := copy(FormatF(ADouble), 1, 10);;
//end;

function TAdvectionObservationWriter.FormatF(ADouble: double): String;
var
  AString : String;
//  EPos : integer;
begin
  AString := InternationalFloatToStr(ADouble);
{  if (Pos('.', AString) = 0) and (Pos('E', AString) = 0)
    and (Pos('e', AString) = 0) then
  begin
    AString := AString + '.';
  end; }

  if ADouble < 0 then
  begin
    Assert(Length(AString)>2);
    if AString[2] = '0' then
    begin
      AString := '-' + Copy(AString, 3, Length(AString));
    end;
  end
  else
  begin
    if (Length(AString) > 1) and (AString[1] = '0') then
    begin
      AString := Copy(AString, 2, Length(AString));
    end;
  end;
  result := AString;
//  AString := copy(AString, 1, 5);
end;

constructor TAdvectionObservationWriter.Create;
begin
  inherited;
  StartErrors := 0;
  ObservationErrors := 0 ;
  StartPointErrors:= TStringList.Create;
end;

destructor TAdvectionObservationWriter.Destroy;
begin
  inherited;
  StartPointErrors.Free;
end;

class procedure TAdvectionObservationWriter.AssignUnitNumbers;
begin
  frmModflow.GetUnitNumber('ADV_Particles');
end;

end.
