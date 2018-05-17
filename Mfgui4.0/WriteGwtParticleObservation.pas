unit WriteGwtParticleObservation;

interface

uses SysUtils, Forms, Classes, contnrs, AnePIE, WriteModflowDiscretization;

type
  TParticleLocation = class(TObject)
    Layer: integer;
    Row: integer;
    Column: integer;
  end;

  TLocationList = class(TObject)
  private
    List: TList;
    function GetCount: integer;
    function GetItems(const Index: integer): TParticleLocation;
  public
    procedure Add(const Layer, Row, Column: integer);
    procedure Clear;
    property Count: integer read GetCount;
    Constructor Create;
    Destructor Destroy; override;
    property Items[const Index: integer]: TParticleLocation read GetItems; default;
  end;

  TGwtParticleObservationWriter = class(TModflowWriter)
  private
    ModelHandle: ANE_PTR;
    Locations: TLocationList;
    Disc: TDiscretizationWriter;
    Wells: TStringList;
    procedure EvaluateLocations;
    procedure EvaluateWells;
    Procedure WriteDataSet1;
    Procedure WriteDataSet2;
    Procedure WriteDataSet3;
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure WriteFile(const CurrentModelHandle: ANE_PTR;
      Root: string; Discretization: TDiscretizationWriter);
  end;

var
  ParticleObservationLocationsCount: integer;
  MnwParticleObservationsCount: integer;

Const
  kGWT_ParticleObsLocations = 'GWT_ParticleObservationLocations';
  KGWT_MnwObsWells = 'GWT_MNW_ParticleObservations';

implementation

uses Variables, OptionsUnit, WriteNameFileUnit, ProgressUnit;

{ TLocationList }

procedure TLocationList.Add(const Layer, Row, Column: integer);
var
  Location: TParticleLocation;
begin
  Location := TParticleLocation.Create;
  List.Add(Location);
  Location.Layer := Layer;
  Location.Row := Row;
  Location.Column := Column;
end;

procedure TLocationList.Clear;
begin
  List.Clear;
end;

constructor TLocationList.Create;
begin
  List := TObjectList.Create;
end;

destructor TLocationList.Destroy;
begin
  List.Free;
  inherited;
end;

function TLocationList.GetCount: integer;
begin
  result := List.Count;
end;

function TLocationList.GetItems(const Index: integer): TParticleLocation;
begin
  result := List[Index];
end;

{ TGwtParticleObservationWriter }

constructor TGwtParticleObservationWriter.Create;
begin
  Locations:= TLocationList.Create;
  Wells:= TStringList.Create;
end;

destructor TGwtParticleObservationWriter.Destroy;
begin
  Locations.Free;
  Wells.Free;
  inherited;
end;

procedure TGwtParticleObservationWriter.EvaluateLocations;
var
//  ModflowLayer: integer;
  PriorLayer: integer;
  Row: integer;
  Column: integer;
  UnitIndex: integer;
  LayerIndex : integer;
  Block: TBlockObjectOptions;
  BlockIndex: ANE_INT32;
  GridLayer: TLayerOptions;
  ParamIndex: ANE_INT32;
begin
  frmProgress.lblActivity.Caption := 'Evaluating Particle Observation Locations';
  Application.ProcessMessages;
  frmProgress.pbActivity.Max := Disc.NCOL * Disc.NROW;
  ParticleObservationLocationsCount := 0;
  Locations.Clear;
  PriorLayer := 0;
  GridLayer := TLayerOptions.CreateWithName(
    ModflowTypes.GetGridLayerType.ANE_LayerName, ModelHandle);
  try
    for UnitIndex := 1 to frmModflow.UnitCount do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        ParamIndex := GridLayer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFGridMocParticleObservationParamType.ANE_ParamName
          + IntToStr(UnitIndex));
        Assert(ParamIndex >= 0);
        frmProgress.pbActivity.Position := 0;
        for Column := 0 to Disc.NCOL -1 do
        begin
          for Row := 0 to Disc.NROW -1 do
          begin
            BlockIndex := Disc.BlockIndex(Row, Column);
            Block := TBlockObjectOptions.Create(
              ModelHandle, GridLayer.LayerHandle, BlockIndex);
            try
              if Block.GetFloatParameter(ModelHandle, ParamIndex) > 0 then
              begin
                for LayerIndex := 1 to
                  frmModflow.DiscretizationCount(UnitIndex) do
                begin
                  Locations.Add(PriorLayer + LayerIndex, Row+1, Column+1);
                end;
              end;
            finally
              Block.Free;
            end;
            frmProgress.pbActivity.StepIt;
            Application.ProcessMessages;
            if not ContinueExport then
            begin
              Exit;
            end;

          end;
        end;
        PriorLayer := PriorLayer + frmModflow.DiscretizationCount(UnitIndex);
      end;
      frmProgress.pbPackage.StepIt;
    end;
  finally
    GridLayer.Free(ModelHandle);
  end;
  ParticleObservationLocationsCount := Locations.Count;
end;

procedure TGwtParticleObservationWriter.EvaluateWells;
var
  Layer: TLayerOptions;
  ContourIndex: integer;
  IsObsIndex, SiteNameIndex: ANE_INT32;
  Contour: TContourObjectOptions;
  Count: integer;
  SiteName: string;
begin
  MnwParticleObservationsCount := 0;
  if frmModflow.cbMNW2.Checked and frmModflow.cbUseMnw2.Checked then
  begin
    frmProgress.lblActivity.Caption := 'Evaluating MNW Particle Observations';
    frmProgress.pbActivity.Position := 0;
    if (frmModflow.rgMnw2WellType.ItemIndex in [0,2]) then
    begin

      Layer := TLayerOptions.CreateWithName(
        ModflowTypes.GetMFMNW2_VerticalWellLayerType.ANE_LayerName, ModelHandle);
      try
        IsObsIndex := Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_IsPTOB_ObservationParamType.ANE_ParamName);
        Assert(IsObsIndex >= 0);

        SiteNameIndex := Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMF_MNW2_WellIdParamType.ANE_ParamName);
        Assert(SiteNameIndex >= 0);
        Count := Layer.NumObjects(ModelHandle, pieContourObject);
        frmProgress.pbActivity.Max := Count;

        for ContourIndex := 0 to Count -1 do
        begin
          Contour := TContourObjectOptions.Create(ModelHandle, Layer.LayerHandle,
            ContourIndex);
          try
            if Contour.GetBoolParameter(ModelHandle, IsObsIndex) then
            begin
              SiteName := Contour.GetStringParameter(ModelHandle,SiteNameIndex);
              if SiteName <> '' then
              begin
                SiteName := StringReplace(SiteName,' ', '_', [rfReplaceAll]);
                SiteName := Copy(SiteName,1,20);
                Wells.Add(SiteName);
              end;
            end;
          finally
            Contour.Free;
          end;
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;
          if not ContinueExport then
          begin
            Exit;
          end;
        end;
      finally
        Layer.Free(ModelHandle);
      end;
    end;
    if (frmModflow.rgMnw2WellType.ItemIndex in [1,2]) then
    begin

      Layer := TLayerOptions.CreateWithName(
        ModflowTypes.GetMFMNW2_GeneralWellLayerType.ANE_LayerName, ModelHandle);
      try
        IsObsIndex := Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_IsPTOB_ObservationParamType.ANE_ParamName);
        Assert(IsObsIndex >= 0);

        SiteNameIndex := Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMF_MNW2_WellIdParamType.ANE_ParamName);
        Assert(SiteNameIndex >= 0);
        Count := Layer.NumObjects(ModelHandle, pieContourObject);
        frmProgress.pbActivity.Max := Count;

        for ContourIndex := 0 to Count -1 do
        begin
          Contour := TContourObjectOptions.Create(ModelHandle, Layer.LayerHandle,
            ContourIndex);
          try
            if Contour.GetBoolParameter(ModelHandle, IsObsIndex) then
            begin
              SiteName := Contour.GetStringParameter(ModelHandle,SiteNameIndex);
              if SiteName <> '' then
              begin
                SiteName := StringReplace(SiteName,' ', '_', [rfReplaceAll]);
                SiteName := Copy(SiteName,1,20);
                Wells.Add(SiteName);
              end;
            end;
          finally
            Contour.Free;
          end;
          frmProgress.pbActivity.StepIt;
          Application.ProcessMessages;
          if not ContinueExport then
          begin
            Exit;
          end;
        end;
      finally
        Layer.Free(ModelHandle);
      end;
    end;
    frmProgress.pbPackage.StepIt;
  end;
  MnwParticleObservationsCount := Wells.Count;
end;

procedure TGwtParticleObservationWriter.WriteDataSet1;
var
  NUMPTOB: integer;
  NUMPTOB_MNW: integer;
begin
  NUMPTOB := Locations.Count;
  NUMPTOB_MNW := Wells.Count;
  Writeln(FFile, NUMPTOB, ' ', NUMPTOB_MNW);
end;

procedure TGwtParticleObservationWriter.WriteDataSet2;
var
  Index: integer;
  FirstUnit: integer;
  Location: TParticleLocation;
begin
  if Locations.Count > 0 then
  begin
    frmProgress.lblActivity.Caption := 'Writing Particle Observation Locations';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Locations.Count;
    FirstUnit := frmModflow.GetNUnitNumbers(kGWT_ParticleObsLocations,
      Locations.Count);
    for Index := 0 to Locations.Count -1 do
    begin
      Location := Locations[Index];
      WriteLn(FFile, Location.Layer, ' ', Location.Row, ' ',
        Location.Column, ' ', FirstUnit + Index);
      frmProgress.pbActivity.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then
      begin
        Exit;
      end;
    end;
  end;
  frmProgress.pbPackage.StepIt;
end;

procedure TGwtParticleObservationWriter.WriteDataSet3;
var
  Index: integer;
  FirstUnit: integer;
//  Location: TParticleLocation;
begin
  if Wells.Count > 0 then
  begin
    frmProgress.lblActivity.Caption :=
      'Writing Multi-Node Particle Observation Site Names';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Wells.Count;
    FirstUnit := frmModflow.GetNUnitNumbers(KGWT_MnwObsWells,
      Wells.Count);
    for Index := 0 to Wells.Count -1 do
    begin
      WriteLn(FFile, '"', Wells[Index], '" ',
        FirstUnit + Index);
      frmProgress.pbActivity.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then
      begin
        Exit;
      end;
    end;
    frmProgress.pbPackage.StepIt;
  end;
end;

procedure TGwtParticleObservationWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter);
var
  ProgressMax: integer;
  FileName: string;
begin
  frmProgress.lblPackage.Caption := 'Particle Observations';
  ModelHandle := CurrentModelHandle;
  Disc := Discretization;
  ProgressMax := frmModflow.UnitCount + 1;
  if frmModflow.cbMNW2.Checked and frmModflow.cbUseMnw2.Checked then
  begin
    ProgressMax := ProgressMax + 2;
  end;
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := ProgressMax;
  EvaluateLocations;
  Application.ProcessMessages;
  if not ContinueExport then
  begin
    Exit;
  end;
  EvaluateWells;
  if not ContinueExport then
  begin
    Exit;
  end;
  FileName := GetCurrentDir + '\' + Root + rsPTOB;
  AssignFile(FFile, FileName);
  try
    Rewrite(FFile);
    WriteDataSet1;
    if not ContinueExport then
    begin
      Exit;
    end;
    WriteDataSet2;
    if not ContinueExport then
    begin
      Exit;
    end;
    WriteDataSet3;
  finally
    CloseFile(FFile);
  end;
end;

end.
