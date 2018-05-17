unit WriteIPDL;

interface

uses SysUtils, Forms, contnrs, AnePIE, WriteModflowDiscretization, OptionsUnit;

type
  TParticleIndicies = record
    LayerCountName: string;
    RowCountName: string;
    ColCountName: string;
    LayerCountIndex: ANE_INT16;
    RowCountIndex: ANE_INT16;
    ColCountIndex: ANE_INT16;
  end;

  TParticleRecord = record
    Lay: integer;
    Row: integer;
    Col: integer;
    LayCount: integer;
    RowCount: integer;
    ColCount: integer;
  end;

  TIpdlWriter = class;

  TParticleList = class(TObjectList)
    function Add(Particles: TParticleRecord): integer; overload;
    procedure EliminateExtras(const LayCount, RowCount, ColCount: integer);
    procedure Write(const Writer: TIpdlWriter);
  end;

  TIpdlWriter = class(TListWriter)
  private
    ModelHandle: ANE_PTR;
    DisWriter: TDiscretizationWriter;
    ParticleList: TParticleList;
    NPTLAY, NPTROW, NPTCOL: integer;
    procedure GetParamIndicies(out ParticleIndicies: TParticleIndicies;
      const ParticleLayer: TLayerOptions);
    procedure EvaluateLayer(const UnitIndex: integer;
      const ProjectOptions: TProjectOptions);
    procedure Evaluate;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteFile(const CurrentModelHandle: ANE_PTR;
      const Discretization: TDiscretizationWriter; const Root: string);
  end;

  TInitialParticles = class(TObject)
  private
    Particles: TParticleRecord;
    procedure WriteParticles(const Writer: TIpdlWriter);
    function UseItem(const LayCount, RowCount, ColCount: integer): boolean;
  end;

implementation

uses Variables, ProgressUnit, GetCellUnit, PointInsideContourUnit,
  WriteNameFileUnit;

{ TIpdlWriter }

constructor TIpdlWriter.Create;
begin
  inherited;
  ParticleList := TParticleList.Create;
end;

destructor TIpdlWriter.Destroy;
begin
  ParticleList.Free;
  inherited;
end;

procedure TIpdlWriter.Evaluate;
var
  FirstMoc3dUnit, LastMoc3dUnit : integer;
  UnitIndex: integer;
  ProjectOptions: TProjectOptions;
begin
  frmProgress.lblActivity.Caption := 'Evaluating IDPL Package';

  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := 3;

  NPTLAY := StrToInt(frmModflow.adeNPTLAY.Text);
  NPTROW := StrToInt(frmModflow.adeNPTROW.Text);
  NPTCOL := StrToInt(frmModflow.adeNPTCOL.Text);
  FirstMoc3dUnit := StrToInt(frmMODFLOW.adeMOC3DLay1.Text);
  LastMoc3dUnit := StrToInt(frmMODFLOW.adeMOC3DLay2.Text);
  if LastMoc3dUnit = -1 then
  begin
    LastMoc3dUnit := StrToInt(frmMODFLOW.edNumUnits.Text);
  end;

  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := LastMoc3dUnit-FirstMoc3dUnit+1;

  ProjectOptions := TProjectOptions.Create;
  try
    for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
    begin
      frmProgress.lblActivity.Caption := 'Evaluating Unit ' + IntToStr(UnitIndex);
      EvaluateLayer(UnitIndex, ProjectOptions);
      frmProgress.pbActivity.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then Exit;
    end;
  finally
    ProjectOptions.Free;
  end;
  frmProgress.pbPackage.StepIt;
  Application.ProcessMessages;
  if not ContinueExport then Exit;

  frmProgress.lblActivity.Caption := 'Eliminating Duplicates';
  ParticleList.EliminateExtras(NPTLAY, NPTROW, NPTCOL);
  frmProgress.pbPackage.StepIt;
  Application.ProcessMessages;
end;

procedure TIpdlWriter.EvaluateLayer(const UnitIndex: integer;
  const ProjectOptions: TProjectOptions);
var
  LayerName: string;
  LayerHandle: ANE_PTR;
  ContourCount: integer;
  ParticleLayer: TLayerOptions;
  ParticleIndicies: TParticleIndicies;
  ContourIndex: integer;
  Contour: TContourObjectOptions;
  CellIndex: integer;
  Particle: TParticleRecord;
  TopLayer, BottomLayer: integer;
  LayerIndex: integer;
  ColIndex, RowIndex: integer;
  ContourIntersectArea: double;
begin
  TopLayer := frmModflow.MODFLOWLayersAboveCount(UnitIndex) + 1;
  BottomLayer := frmModflow.MODFLOWLayersAboveCount(UnitIndex)
    + frmModflow.DiscretizationCount(UnitIndex);

  LayerName := ModflowTypes.GetMOCInitialParticlePlacementLayerType.
    WriteNewRoot + IntToStr(UnitIndex);
  AddVertexLayer(ModelHandle, LayerName);
  SetAreaValues;
  LayerHandle := ProjectOptions.GetLayerByName(ModelHandle, LayerName);
  ParticleLayer := TLayerOptions.Create(LayerHandle);
  try
    ContourCount := ParticleLayer.NumObjects(ModelHandle, pieContourObject);
    if ContourCount > 0 then
    begin
      GetParamIndicies(ParticleIndicies, ParticleLayer);
    end;

    frmProgress.pbActivity.Max := ContourCount;
    for ContourIndex := 0 to ContourCount - 1 do
    begin
      frmProgress.pbActivity.StepIt;
      if not ContinueExport then
        break;
      Application.ProcessMessages;
      Contour := TContourObjectOptions.Create
        (ModelHandle, LayerHandle, ContourIndex);

      try
        Particle.LayCount := Contour.GetIntegerParameter(ModelHandle,
          ParticleIndicies.LayerCountIndex);
        Particle.RowCount := Contour.GetIntegerParameter(ModelHandle,
          ParticleIndicies.RowCountIndex);
        Particle.ColCount := Contour.GetIntegerParameter(ModelHandle,
          ParticleIndicies.ColCountIndex);

        if (Particle.LayCount = NPTLAY)
          and (Particle.RowCount = NPTROW)
          and (Particle.ColCount = NPTCOL) then
        begin
          Continue;
        end;

        for CellIndex := 0 to GGetCountOfACellList(ContourIndex) - 1 do
        begin
          if not ContinueExport then
            break;
          Application.ProcessMessages;
          Particle.Row := GGetCellRow(ContourIndex, CellIndex);
          Particle.Col := GGetCellColumn(ContourIndex, CellIndex);
          for LayerIndex := TopLayer to BottomLayer do
          begin
            Particle.Lay := LayerIndex;
            ParticleList.Add(Particle);
          end;
        end;

        if Contour.ContourType(ModelHandle) = ctClosed then
        begin
          for ColIndex := 1 to DisWriter.NCOL do
          begin
            if not ContinueExport then
              break;
            Application.ProcessMessages;
            for RowIndex := 1 to DisWriter.NROW do
            begin
              if not ContinueExport then
                break;
              Application.ProcessMessages;

              ContourIntersectArea := GContourIntersectCell(ContourIndex,
                ColIndex, RowIndex);
              if ContourIntersectArea > 0 then
              begin
                Particle.Row := RowIndex;
                Particle.Col := ColIndex;
                for LayerIndex := TopLayer to BottomLayer do
                begin
                  Particle.Lay := LayerIndex;
                  ParticleList.Add(Particle);
                end;
              end;
            end;
          end;
        end;
      finally
        Contour.Free;
      end;
    end;
  finally
    ParticleLayer.Free(ModelHandle);
  end;
end;

procedure TIpdlWriter.GetParamIndicies(
  out ParticleIndicies: TParticleIndicies;
  const ParticleLayer: TLayerOptions);
begin
  ParticleIndicies.LayerCountName := ModflowTypes.
    GetMFLayerCountParamType.ANE_ParamName;
  ParticleIndicies.LayerCountIndex := ParticleLayer.GetParameterIndex(
    ModelHandle, ParticleIndicies.LayerCountName);

  ParticleIndicies.RowCountName := ModflowTypes.
    GetMFRowCountParamType.ANE_ParamName;
  ParticleIndicies.RowCountIndex := ParticleLayer.GetParameterIndex(
    ModelHandle, ParticleIndicies.RowCountName);

  ParticleIndicies.ColCountName := ModflowTypes.
    GetMFColumnCountParamType.ANE_ParamName;
  ParticleIndicies.ColCountIndex := ParticleLayer.GetParameterIndex(
    ModelHandle, ParticleIndicies.ColCountName);
end;

procedure TIpdlWriter.WriteDataSet1;
var
  NPTLIST: integer;
  NPMAX: integer;
begin
  NPTLIST := ParticleList.Count;
  NPMAX := StrToInt(frmModflow.adeMOC3DMaxParticles.Text);
  Writeln(FFile, NPTLAY, ' ', NPTROW, ' ', NPTCOL, ' ', NPTLIST, ' ', NPMAX);
end;

procedure TIpdlWriter.WriteDataSet2;
begin
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := ParticleList.Count;
  frmProgress.lblActivity.Caption := 'Writing';
  ParticleList.Write(self);
  frmProgress.pbPackage.StepIt;
end;

procedure TIpdlWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  const Discretization: TDiscretizationWriter; const Root: string);
var
  FileName: string;
begin
  frmProgress.lblPackage.Caption := 'IDPL Package';
  ModelHandle := CurrentModelHandle;
  DisWriter := Discretization;
  FileName := GetCurrentDir + '\' + Root + rsIPDL;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);
    WriteDataReadFrom(FileName);

    Evaluate;

    if ContinueExport then
    begin
      WriteDataSet1;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      WriteDataSet2;
    end;
  finally
    CloseFile(FFile);
  end;
end;

{ TInitialParticles }

function TInitialParticles.UseItem(const LayCount, RowCount,
  ColCount: integer): boolean;
begin
  result := (LayCount <> Particles.LayCount)
    or (RowCount <> Particles.RowCount)
    or (ColCount <> Particles.ColCount);
end;

procedure TInitialParticles.WriteParticles(const Writer: TIpdlWriter);
begin
  if Particles.LayCount < 0 then
  begin
    WriteLn(Writer.FFile,
      Particles.Lay, ' ',
      Particles.Row, ' ',
      Particles.Col, ' ',
      Particles.LayCount);
  end
  else
  begin
    WriteLn(Writer.FFile,
      Particles.Lay, ' ',
      Particles.Row, ' ',
      Particles.Col, ' ',
      Particles.LayCount, ' ',
      Particles.RowCount, ' ',
      Particles.ColCount);
  end;
end;

{ TParticleList }

function TParticleList.Add(Particles: TParticleRecord): integer;
var
  AParticleObject: TInitialParticles;
  Index: integer;
begin
  for Index := 0 to Count - 1 do
  begin
    AParticleObject := Items[Index] as TInitialParticles;
    if (AParticleObject.Particles.Lay = Particles.Lay)
      and (AParticleObject.Particles.Row = Particles.Row)
      and (AParticleObject.Particles.Col = Particles.Col) then
    begin
      if Particles.LayCount < 0 then
      begin
        if Particles.LayCount < AParticleObject.Particles.LayCount then
        begin
          AParticleObject.Particles.LayCount := Particles.LayCount
        end;
      end
      else
      begin
        if (AParticleObject.Particles.LayCount > 0)
          and (AParticleObject.Particles.LayCount < Particles.LayCount) then
        begin
          AParticleObject.Particles.LayCount := Particles.LayCount;
        end;
      end;
      if AParticleObject.Particles.RowCount < Particles.RowCount then
      begin
        AParticleObject.Particles.RowCount := Particles.RowCount;
      end;
      if AParticleObject.Particles.ColCount < Particles.ColCount then
      begin
        AParticleObject.Particles.ColCount := Particles.ColCount;
      end;
      result := Index;
      Exit;
    end;
  end;

  AParticleObject := TInitialParticles.Create;
  result := Add(AParticleObject);
  AParticleObject.Particles := Particles;
end;

procedure TParticleList.EliminateExtras(const LayCount, RowCount,
  ColCount: integer);
var
  Index: integer;
  AParticleObject: TInitialParticles;
begin
  for Index := Count -1 downto 0 do
  begin
    AParticleObject := Items[Index] as TInitialParticles;
    if not AParticleObject.UseItem(LayCount, RowCount, ColCount) then
    begin
      Delete(Index);
    end;
  end;
end;

procedure TParticleList.Write(const Writer: TIpdlWriter);
var
  Index: integer;
  AParticleObject: TInitialParticles;
begin
  for Index := 0 to Count -1 do
  begin
    AParticleObject := Items[Index] as TInitialParticles;
    AParticleObject.WriteParticles(Writer);
    frmProgress.pbActivity.StepIt;
    Application.ProcessMessages;
    if not ContinueExport then Exit;
  end;
end;

end.

