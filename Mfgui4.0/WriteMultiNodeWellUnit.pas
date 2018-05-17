{@name is used to create the input files for the MNW version 1 package.

@Seealso(WriteMNW2Unit)}

unit WriteMultiNodeWellUnit;

interface

uses Sysutils, Forms, Classes, contnrs, AnePIE, OptionsUnit,
  WriteModflowDiscretization;

type
  TSteadyParamIndicies = record
    SiteIndex: ANE_INT16;
    FirstIndex: ANE_INT16;
    LastIndex: ANE_INT16;
    OverridenFirstIndex: ANE_INT16;
    OverridenLastIndex: ANE_INT16;
    FirstUnitIndex: ANE_INT16;
    LastUnitIndex: ANE_INT16;
    RadiusIndex: ANE_INT16;
    LimitingElevationIndex: ANE_INT16;
    DrawdownFlagIndex: ANE_INT16;
    ReferenceElevationIndex: ANE_INT16;
    GroupIdentifierIndex: ANE_INT16;
    InactivationIndex: ANE_INT16;
    ReactivationIndex: ANE_INT16;
    CCutIndex: ANE_INT16;
    PumpingLimitsIndex: ANE_INT16;
    SkinIndex: ANE_INT16;
    CoefficientIndex: ANE_INT16;
    IsObservationIndex: ANE_INT16;
    ObsFlagIndex: ANE_INT16;
    MT3D_Indicies: array of ANE_INT16;
  end;

  TTransientIndicies = record
    StressIndex: ANE_INT16;
    ActiveIndex: ANE_INT16;
    RadiusIndex: ANE_INT16;
    LimitingElevationIndex: ANE_INT16;
    DrawdownFlagIndex: ANE_INT16;
    ReferenceElevationIndex: ANE_INT16;
    GroupIdentifierIndex: ANE_INT16;
    InactivationIndex: ANE_INT16;
    ReactivationIndex: ANE_INT16;
    CCutIndex: ANE_INT16;
    PumpingLimitsIndex: ANE_INT16;
    SkinIndex: ANE_INT16;
    CoefficientIndex: ANE_INT16;
    MT3D_Indicies: array of ANE_INT16;
  end;

  TMNW_Location = record
    FirstLayer: integer;
    LastLayer: integer;
    FirstUnit: integer;
    LastUnit: integer;
    Row: integer;
    Column: integer;
  end;

  TMNW_Properties = record
    FirstElevation: double;
    LastElevation: double;
    OverridenFirstElevation: boolean;
    OverridenLastElevation: boolean;
    Stress: double;
    IsActive: boolean;
    WaterQuality: double;
    Radius: double;
    Skin: double;
    Coefficient: double;
    LimitingWaterLevel: double;
    ReferenceElevation: double;
    DrawDownFlag: boolean;
    GroupID: integer;
    AbsolutePumpingRate: boolean;
    InactivationRate: double;
    ReactivationRate: double;
    PumpingLimts: boolean;
    Site: string;
    ObsFlag: integer;
    FirstCell: boolean;
    MT3DConcentrations: array of double;
  end;

  TMultiNodeWellWriter = class(TListWriter)
  private
    ModelHandle: ANE_PTR;
    Dis: TDiscretizationWriter;
    MNW_Layer: TLayerOptions;
    SteadyIndicies: TSteadyParamIndicies;
    TransientIndicies: array of TTransientIndicies;
    WaterQualityParameterNames: TStringList;
    TimeList: TObjectList;
    MNW_Root: string;
    WaterQualityList: TList;
    TransientTime: boolean;
    ObservationErrors: TStringList;
    function AllSteady: boolean;
    procedure InitializeWaterQuality;
    function GetSteadyIndicies: TSteadyParamIndicies;
    function GetTransientIndicies(const StressPeriod: integer):
      TTransientIndicies;
    procedure EvaluateDataSets4and5;
    procedure EvaluateContour(ContourIndex: integer);
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteUnnumberedB;
    procedure WriteDataSet3a;
    procedure WriteDataSet3b;
    procedure WriteDataSet3c;
    procedure WriteDataSets4and5;
//    procedure WriteObservationsDataSet1;
//    procedure WriteObservationsDataSet2;
    procedure EvaluateInternal(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Evaluate(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
    procedure WriteFile(const CurrentModelHandle: ANE_PTR;
      Root: string; Discretization: TDiscretizationWriter);
    procedure WriteMT3DConcentrations(const StressPeriod: integer;
      const Lines: TStrings);
    class procedure AssignUnitNumbers;
  end;

  TMNW_Cell = class(TObject)
  private
    Col: integer;
    Row: integer;
    Layer: integer;
    Properties: TMNW_Properties;
    procedure WriteCell(const Writer: TMultiNodeWellWriter);
    procedure WriteMT3DConcentrations(const Lines : TStrings);
  end;

  TMNW_CellList = class(TObjectList)
  private
    function Add(Col, Row, Layer: integer; Properties: TMNW_Properties):
      integer;
    procedure WriteStressPeriod(const Writer: TMultiNodeWellWriter);
    procedure WriteMT3DConcentrations(const Lines: TStrings);
  end;

  TObsFlag = class(TObject)
    ObsFlag: integer;
  end;


implementation

uses UtilityFunctions, Variables, ModflowUnit, GetCellUnit, ProgressUnit,
  WriteNameFileUnit;

{ TMultiNodeWellWriter }

function TMultiNodeWellWriter.AllSteady: boolean;
begin
  result := frmModflow.comboMNW_Steady.ItemIndex = 0
end;

constructor TMultiNodeWellWriter.Create;
begin
  inherited;
  TimeList := TObjectList.Create;
  WaterQualityParameterNames := TStringList.Create;
  WaterQualityList := TList.Create;
  ObservationErrors:= TStringList.Create;
end;

destructor TMultiNodeWellWriter.Destroy;
var
  Index: integer;
  WaterQualityLayer: TLayerOptions;
begin
  TimeList.Free;
  WaterQualityParameterNames.Free;
  for Index := 0 to WaterQualityList.Count - 1 do
  begin
    WaterQualityLayer := WaterQualityList[Index];
    WaterQualityLayer.Free(ModelHandle);
  end;
  WaterQualityList.Free;
  ObservationErrors.Free;
  inherited;
end;

procedure TMultiNodeWellWriter.WriteMT3DConcentrations(
  const StressPeriod: integer; const Lines: TStrings);
var
  CellList : TMNW_CellList;
begin
  CellList := TimeList[StressPeriod-1] as TMNW_CellList;
  CellList.WriteMT3DConcentrations(Lines);
end;

procedure TMultiNodeWellWriter.EvaluateContour(
  ContourIndex: integer);
var
  MNW_Properties: TMNW_Properties;
  Locations: array of TMNW_Location;
  CellCount: integer;
  Contour: TContourObjectOptions;
  CellIndex: integer;
  X, Y: ANE_DOUBLE;
  FirstString, LastString: string;
  BlockIndex: integer;
  Block: TBlockObjectOptions;
  TempLayer: integer;
  TimeIndex: integer;
  TranIndicies: TTransientIndicies;
  Column, Row, Layer: integer;
  CellList: TMNW_CellList;
  WaterQualityLayer: TLayerOptions;
  ParamName: string;
  UnitIndex: integer;
  MinLayer, MaxLayer: integer;
  TimesUsed: integer;
  ConcCount: integer;
  MnwSite: string;
  ObsFlag: TObsFlag;
begin
  FirstString := ModflowTypes.GetMFMNW_FirstElevationParamClassType.
    ANE_ParamName;
  LastString := ModflowTypes.GetMFMNW_LastElevationParamClassType.ANE_ParamName;
  CellCount := GGetCountOfACellList(ContourIndex);

  ConcCount := 0;
  if frmModflow.cbMT3D.Checked then
  begin
    ConcCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
  end;
  SetLength(MNW_Properties.MT3DConcentrations, ConcCount);

  if CellCount > 0 then
  begin
    MNW_Properties.FirstCell := True;
    SetLength(Locations, CellCount);
    for CellIndex := 0 to CellCount - 1 do
    begin
      Locations[CellIndex].Row := GGetCellRow(ContourIndex, CellIndex);
      Locations[CellIndex].Column := GGetCellColumn(ContourIndex, CellIndex);
    end;

    Contour := TContourObjectOptions.Create(ModelHandle, MNW_Layer.LayerHandle,
      ContourIndex);
    try
      if Contour.ContourType(ModelHandle) <> ctClosed then
      begin
        MNW_Properties.Site := Trim(Contour.GetStringParameter(
          ModelHandle, SteadyIndicies.SiteIndex));
        MNW_Properties.Site :=   StringReplace(MNW_Properties.Site, ' ', '_',
          [rfReplaceAll]);

        {if (SteadyIndicies.IsObservationIndex >= 0) and
          (Contour.GetBoolParameter(ModelHandle,
          SteadyIndicies.IsObservationIndex)) then
        begin
          if (MNW_Properties.Site = '') then
          begin
            ObservationErrors.Add(IntToStr(Locations[0].Row) + ', '
              + IntToStr(Locations[0].Column));
          end
          else
          begin
            if SteadyIndicies.ObsFlagIndex >= 0 then
            begin
              MNW_Properties.ObsFlag := Contour.GetIntegerParameter(
                ModelHandle, SteadyIndicies.ObsFlagIndex);
            end
            else
            begin
              MNW_Properties.ObsFlag := -1;
            end;

            // a maximum of 11 characters is allowed.
            MnwSite := Copy(MNW_Properties.Site,1,11);
            if frmModflow.MultiNodeWellNames.IndexOf(MnwSite) < 0 then
            begin
              ObsFlag := TObsFlag.Create;
              ObsFlag.ObsFlag := MNW_Properties.ObsFlag;

              frmModflow.MultiNodeWellNames.AddObject(MnwSite, ObsFlag);
            end;
          end;
        end; }

        MNW_Properties.OverridenFirstElevation := Contour.GetBoolParameter(
          ModelHandle, SteadyIndicies.OverridenFirstIndex);
        MNW_Properties.OverridenLastElevation := Contour.GetBoolParameter(
          ModelHandle, SteadyIndicies.OverridenLastIndex);

        if MNW_Properties.OverridenFirstElevation then
        begin
          MNW_Properties.FirstElevation := Contour.GetFloatParameter(
            ModelHandle, SteadyIndicies.FirstIndex);
        end;
        if MNW_Properties.OverridenLastElevation then
        begin
          MNW_Properties.LastElevation := Contour.GetFloatParameter(
            ModelHandle, SteadyIndicies.LastIndex);
        end;

        for CellIndex := 0 to CellCount - 1 do
        begin
          if not MNW_Properties.OverridenFirstElevation
            or not MNW_Properties.OverridenLastElevation then
          begin
            BlockIndex := Dis.BlockIndex(Locations[CellIndex].Row - 1,
              Locations[CellIndex].Column - 1);
            Block := TBlockObjectOptions.Create(ModelHandle,
              Dis.GridLayerHandle, BlockIndex);
            try
              Block.GetCenter(ModelHandle, X, Y);
            finally
              Block.Free;
            end;

            if not MNW_Properties.OverridenFirstElevation then
            begin
              MNW_Properties.FirstElevation := MNW_Layer.RealValueAtXY(
                ModelHandle, X, Y, FirstString);
            end;
            if not MNW_Properties.OverridenLastElevation then
            begin
              MNW_Properties.LastElevation := MNW_Layer.RealValueAtXY(
                ModelHandle, X, Y, LastString);
            end;
          end;
          Locations[CellIndex].FirstLayer := Dis.ElevationToLayer(
            Locations[CellIndex].Column, Locations[CellIndex].Row,
            MNW_Properties.FirstElevation);
          Locations[CellIndex].LastLayer := Dis.ElevationToLayer(
            Locations[CellIndex].Column, Locations[CellIndex].Row,
            MNW_Properties.LastElevation);
          if Locations[CellIndex].FirstLayer > Locations[CellIndex].LastLayer
            then
          begin
            TempLayer := Locations[CellIndex].FirstLayer;
            Locations[CellIndex].FirstLayer := Locations[CellIndex].LastLayer;
            Locations[CellIndex].LastLayer := TempLayer;
          end;
          Locations[CellIndex].FirstUnit := Dis.ElevationToUnit(
            Locations[CellIndex].Column, Locations[CellIndex].Row,
            MNW_Properties.FirstElevation);
          Locations[CellIndex].LastUnit := Dis.ElevationToUnit(
            Locations[CellIndex].Column, Locations[CellIndex].Row,
            MNW_Properties.LastElevation);
          if Locations[CellIndex].FirstUnit > Locations[CellIndex].LastUnit then
          begin
            TempLayer := Locations[CellIndex].FirstUnit;
            Locations[CellIndex].FirstUnit := Locations[CellIndex].LastUnit;
            Locations[CellIndex].LastUnit := TempLayer;
          end;
        end;

        if SteadyIndicies.RadiusIndex >= 0 then
        begin
          MNW_Properties.Radius := Contour.GetFloatParameter(
            ModelHandle, SteadyIndicies.RadiusIndex);
        end;
        if SteadyIndicies.LimitingElevationIndex >= 0 then
        begin
          MNW_Properties.LimitingWaterLevel := Contour.GetFloatParameter(
            ModelHandle, SteadyIndicies.LimitingElevationIndex);
        end;
        if SteadyIndicies.DrawdownFlagIndex >= 0 then
        begin
          MNW_Properties.DrawDownFlag := Contour.GetBoolParameter(
            ModelHandle, SteadyIndicies.DrawdownFlagIndex);
        end;
        if SteadyIndicies.ReferenceElevationIndex >= 0 then
        begin
          MNW_Properties.ReferenceElevation := Contour.GetFloatParameter(
            ModelHandle, SteadyIndicies.ReferenceElevationIndex);
        end;
        if SteadyIndicies.GroupIdentifierIndex >= 0 then
        begin
          MNW_Properties.GroupID := Contour.GetIntegerParameter(
            ModelHandle, SteadyIndicies.GroupIdentifierIndex);
        end;

        if SteadyIndicies.PumpingLimitsIndex >= 0 then
        begin
          MNW_Properties.PumpingLimts := Contour.GetBoolParameter(
            ModelHandle, SteadyIndicies.PumpingLimitsIndex);
          if MNW_Properties.PumpingLimts then
          begin
            Assert(SteadyIndicies.InactivationIndex >= 0);
            MNW_Properties.InactivationRate := Contour.GetFloatParameter(
              ModelHandle, SteadyIndicies.InactivationIndex);

            Assert(SteadyIndicies.ReactivationIndex >= 0);
            MNW_Properties.ReactivationRate := Contour.GetFloatParameter(
              ModelHandle, SteadyIndicies.ReactivationIndex);

            Assert(SteadyIndicies.CCutIndex >= 0);
            MNW_Properties.AbsolutePumpingRate := Contour.GetBoolParameter(
              ModelHandle, SteadyIndicies.CCutIndex);
          end;
        end;
        if SteadyIndicies.SkinIndex >= 0 then
        begin
          MNW_Properties.Skin := Contour.GetFloatParameter(
            ModelHandle, SteadyIndicies.SkinIndex);
        end;
        if SteadyIndicies.CoefficientIndex >= 0 then
        begin
          MNW_Properties.Coefficient := Contour.GetFloatParameter(
            ModelHandle, SteadyIndicies.CoefficientIndex);
        end
        else
        begin
          MNW_Properties.Coefficient := 0;
        end;

        if AllSteady then
        begin
          TimesUsed := 1;
        end
        else
        begin
          TimesUsed := Dis.NPER;
        end;

        if ConcCount >= 1 then
        begin
          if SteadyIndicies.MT3D_Indicies[0] >= 0 then
          begin
            MNW_Properties.MT3DConcentrations[0] := Contour.GetFloatParameter(
              ModelHandle, SteadyIndicies.MT3D_Indicies[0]);
          end
          else
          begin
            MNW_Properties.MT3DConcentrations[0] := 0;
          end;
        end;
        if ConcCount >= 2 then
        begin
          if SteadyIndicies.MT3D_Indicies[1] >= 0 then
          begin
            MNW_Properties.MT3DConcentrations[1] := Contour.GetFloatParameter(
              ModelHandle, SteadyIndicies.MT3D_Indicies[1]);
          end
          else
          begin
            MNW_Properties.MT3DConcentrations[1] := 0;
          end;
        end;
        if ConcCount >= 3 then
        begin
          if SteadyIndicies.MT3D_Indicies[2] >= 0 then
          begin
            MNW_Properties.MT3DConcentrations[2] := Contour.GetFloatParameter(
              ModelHandle, SteadyIndicies.MT3D_Indicies[2]);
          end
          else
          begin
            MNW_Properties.MT3DConcentrations[2] := 0;
          end;
        end;
        if ConcCount >= 4 then
        begin
          if SteadyIndicies.MT3D_Indicies[3] >= 0 then
          begin
            MNW_Properties.MT3DConcentrations[3] := Contour.GetFloatParameter(
              ModelHandle, SteadyIndicies.MT3D_Indicies[3]);
          end
          else
          begin
            MNW_Properties.MT3DConcentrations[3] := 0;
          end;
        end;
        if ConcCount >= 5 then
        begin
          if SteadyIndicies.MT3D_Indicies[4] >= 0 then
          begin
            MNW_Properties.MT3DConcentrations[4] := Contour.GetFloatParameter(
              ModelHandle, SteadyIndicies.MT3D_Indicies[4]);
          end
          else
          begin
            MNW_Properties.MT3DConcentrations[4] := 0;
          end;
        end;

        for TimeIndex := 0 to TimesUsed - 1 do
        begin
          MNW_Properties.FirstCell := True;
          TranIndicies := TransientIndicies[TimeIndex];
          CellList := TimeList[TimeIndex] as TMNW_CellList;
          MNW_Properties.IsActive := Contour.GetBoolParameter(
            ModelHandle, TranIndicies.ActiveIndex);
          if MNW_Properties.IsActive then
          begin
            MNW_Properties.Stress := Contour.GetFloatParameter(
              ModelHandle, TranIndicies.StressIndex);

            Assert((TranIndicies.RadiusIndex >= 0)
              or (SteadyIndicies.RadiusIndex >= 0));
            if TranIndicies.RadiusIndex >= 0 then
            begin
              MNW_Properties.Radius := Contour.GetFloatParameter(
                ModelHandle, TranIndicies.RadiusIndex);
            end;

            Assert((TranIndicies.LimitingElevationIndex >= 0)
              or (SteadyIndicies.LimitingElevationIndex >= 0));
            if TranIndicies.LimitingElevationIndex >= 0 then
            begin
              MNW_Properties.LimitingWaterLevel := Contour.GetFloatParameter(
                ModelHandle, TranIndicies.LimitingElevationIndex);
            end;

            Assert((TranIndicies.DrawdownFlagIndex >= 0)
              or (SteadyIndicies.DrawdownFlagIndex >= 0));
            if TranIndicies.DrawdownFlagIndex >= 0 then
            begin
              MNW_Properties.DrawDownFlag := Contour.GetBoolParameter(
                ModelHandle, TranIndicies.DrawdownFlagIndex);
            end;

            Assert((TranIndicies.ReferenceElevationIndex >= 0)
              or (SteadyIndicies.ReferenceElevationIndex >= 0));
            if TranIndicies.ReferenceElevationIndex >= 0 then
            begin
              MNW_Properties.ReferenceElevation := Contour.GetFloatParameter(
                ModelHandle, TranIndicies.ReferenceElevationIndex);
            end;

            Assert((TranIndicies.GroupIdentifierIndex >= 0)
              or (SteadyIndicies.GroupIdentifierIndex >= 0));
            if TranIndicies.GroupIdentifierIndex >= 0 then
            begin
              MNW_Properties.GroupID := Contour.GetIntegerParameter(
                ModelHandle, TranIndicies.GroupIdentifierIndex);
            end;

            Assert((TranIndicies.PumpingLimitsIndex >= 0)
              or (SteadyIndicies.PumpingLimitsIndex >= 0));
            if TranIndicies.PumpingLimitsIndex >= 0 then
            begin
              MNW_Properties.PumpingLimts := Contour.GetBoolParameter(
                ModelHandle, TranIndicies.PumpingLimitsIndex);
              if MNW_Properties.PumpingLimts then
              begin
                Assert(TranIndicies.InactivationIndex >= 0);
                MNW_Properties.InactivationRate := Contour.GetFloatParameter(
                  ModelHandle, TranIndicies.InactivationIndex);

                Assert(TranIndicies.ReactivationIndex >= 0);
                MNW_Properties.ReactivationRate := Contour.GetFloatParameter(
                  ModelHandle, TranIndicies.ReactivationIndex);

                Assert(TranIndicies.CCutIndex >= 0);
                MNW_Properties.AbsolutePumpingRate := Contour.GetBoolParameter(
                  ModelHandle, TranIndicies.CCutIndex);
              end;
            end;

            Assert((TranIndicies.SkinIndex >= 0)
              or (SteadyIndicies.SkinIndex >= 0));
            if TranIndicies.SkinIndex >= 0 then
            begin
              MNW_Properties.Skin := Contour.GetFloatParameter(
                ModelHandle, TranIndicies.SkinIndex);
            end;

            // Coefficient is not required to be specified.
            if TranIndicies.CoefficientIndex >= 0 then
            begin
              MNW_Properties.Coefficient := Contour.GetFloatParameter(
                ModelHandle, TranIndicies.CoefficientIndex);
            end;

            if ConcCount >= 1 then
            begin
              Assert((TranIndicies.MT3D_Indicies[0] >= 0)
                or (SteadyIndicies.MT3D_Indicies[0] >= 0));
              if TranIndicies.MT3D_Indicies[0] >= 0 then
              begin
                MNW_Properties.MT3DConcentrations[0] := Contour.GetFloatParameter(
                  ModelHandle, TranIndicies.MT3D_Indicies[0]);
              end;
            end;
            if ConcCount >= 2 then
            begin
              Assert((TranIndicies.MT3D_Indicies[1] >= 0)
                or (SteadyIndicies.MT3D_Indicies[1] >= 0));
              if TranIndicies.MT3D_Indicies[1] >= 0 then
              begin
                MNW_Properties.MT3DConcentrations[1] := Contour.GetFloatParameter(
                  ModelHandle, TranIndicies.MT3D_Indicies[1]);
              end;
            end;
            if ConcCount >= 3 then
            begin
              Assert((TranIndicies.MT3D_Indicies[2] >= 0)
                or (SteadyIndicies.MT3D_Indicies[2] >= 0));
              if TranIndicies.MT3D_Indicies[2] >= 0 then
              begin
                MNW_Properties.MT3DConcentrations[2] := Contour.GetFloatParameter(
                  ModelHandle, TranIndicies.MT3D_Indicies[2]);
              end;
            end;
            if ConcCount >= 4 then
            begin
              Assert((TranIndicies.MT3D_Indicies[3] >= 0)
                or (SteadyIndicies.MT3D_Indicies[3] >= 0));
              if TranIndicies.MT3D_Indicies[3] >= 0 then
              begin
                MNW_Properties.MT3DConcentrations[3] := Contour.GetFloatParameter(
                  ModelHandle, TranIndicies.MT3D_Indicies[3]);
              end;
            end;
            if ConcCount >= 5 then
            begin
              Assert((TranIndicies.MT3D_Indicies[4] >= 0)
                or (SteadyIndicies.MT3D_Indicies[4] >= 0));
              if TranIndicies.MT3D_Indicies[4] >= 0 then
              begin
                MNW_Properties.MT3DConcentrations[4] := Contour.GetFloatParameter(
                  ModelHandle, TranIndicies.MT3D_Indicies[4]);
              end;
            end;


            // now store values for all cells.
            for CellIndex := 0 to CellCount - 1 do
            begin
              Column := Locations[CellIndex].Column;
              Row := Locations[CellIndex].Row;

              BlockIndex := Dis.BlockIndex(Row - 1, Column - 1);
              Block := TBlockObjectOptions.Create(ModelHandle,
                Dis.GridLayerHandle, BlockIndex);
              try
                Block.GetCenter(ModelHandle, X, Y);
              finally
                Block.Free;
              end;

              if TransientTime then
              begin
                ParamName := WaterQualityParameterNames[TimeIndex];
              end
              else
              begin
                ParamName := WaterQualityParameterNames[0];
              end;

              //              MinLayer := 0;
              MaxLayer := 0;
              for UnitIndex := 1 to Locations[CellIndex].LastUnit do
              begin
                if frmModflow.Simulated(UnitIndex) then
                begin
                  MinLayer := MaxLayer + 1;
                  MaxLayer := MaxLayer +
                    frmModflow.DiscretizationCount(UnitIndex);
                  if UnitIndex >= Locations[CellIndex].FirstUnit then
                  begin
                    WaterQualityLayer := WaterQualityList[UnitIndex - 1];
                    MNW_Properties.WaterQuality :=
                      WaterQualityLayer.RealValueAtXY(
                      ModelHandle, X, Y, ParamName);
                    for Layer := MinLayer to MaxLayer do
                    begin
                      if (Layer >= Locations[CellIndex].FirstLayer) and
                        (Layer <= Locations[CellIndex].LastLayer) then
                      begin
                        // store values;
                        CellList.Add(Column, Row, Layer, MNW_Properties);

                        // Flag remaining cells that they aren't the first cell.
                        MNW_Properties.FirstCell := False;
                      end;
                    end;

                  end;
                end;

              end;

              {
              for Layer := Locations[CellIndex].FirstLayer to
                  Locations[CellIndex].LastLayer do
                begin
                  WaterQualityLayer := WaterQualityList[Layer-1];

                  MNW_Properties.WaterQuality := WaterQualityLayer.RealValueAtXY(
                    ModelHandle, X, Y, ParamName);

                  // store values;
                  CellList.Add(Column, Row, Layer, MNW_Properties);

                  // Flag remaining cells that they aren't the first cell.
                  MNW_Properties.FirstCell := False;
                end;
              }
            end;
          end;
        end;
      end;
    finally
      Contour.Free;
    end;
  end;
end;

procedure TMultiNodeWellWriter.EvaluateDataSets4and5;
var
  LayerName: string;
  LayerHandle: ANE_PTR;
  ProjectOptions: TProjectOptions;
  ContourCount: integer;
  TimeIndex: integer;
  ContourIndex: integer;
begin
  InitializeWaterQuality;
  frmModflow.ClearMultiNodeWellNames;
  ProjectOptions := TProjectOptions.Create;
  try
    LayerName := ModflowTypes.GetMFMNW_LayerType.WriteNewRoot;
    AddVertexLayer(ModelHandle, LayerName);
    frmProgress.pbPackage.StepIt;
    LayerHandle := ProjectOptions.GetLayerByName(ModelHandle, LayerName);
    MNW_Layer := TLayerOptions.Create(LayerHandle);
    try
      ContourCount := MNW_Layer.NumObjects(ModelHandle,
        pieContourObject);
      if ContourCount > 0 then
      begin
        frmProgress.pbActivity.Position := 0;
        frmProgress.pbActivity.Max := ContourCount;
        SteadyIndicies := GetSteadyIndicies;
        if AllSteady then
        begin
          SetLength(TransientIndicies, 1);
        end
        else
        begin
          SetLength(TransientIndicies, Dis.NPER);
        end;

        for TimeIndex := 1 to Length(TransientIndicies) do
        begin
          TransientIndicies[TimeIndex - 1] := GetTransientIndicies(TimeIndex);
        end;

        for ContourIndex := 0 to ContourCount - 1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then
            Exit;
          EvaluateContour(ContourIndex);
          frmProgress.pbActivity.StepIt;
        end;
      end;
    finally
      MNW_Layer.Free(ModelHandle);
      MNW_Layer := nil;
    end;
  finally
    ProjectOptions.Free;
  end;
end;

function TMultiNodeWellWriter.GetSteadyIndicies: TSteadyParamIndicies;
var
  ConcCount: integer;
begin
  result.SiteIndex := MNW_Layer.GetParameterIndex(ModelHandle, ModflowTypes.
    GetMFMNW_SiteParamClassType.ANE_ParamName);
  Assert(result.SiteIndex >= 0);

  result.FirstIndex := MNW_Layer.GetParameterIndex(ModelHandle, ModflowTypes.
    GetMFMNW_FirstElevationParamClassType.ANE_ParamName);
  Assert(result.FirstIndex >= 0);

  result.LastIndex := MNW_Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFMNW_LastElevationParamClassType.ANE_ParamName);
  Assert(result.LastIndex >= 0);

  result.OverridenFirstIndex := MNW_Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFMNW_OverriddenFirstParamClassType.ANE_ParamName);
  Assert(result.OverridenFirstIndex >= 0);

  result.OverridenLastIndex := MNW_Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFMNW_OverriddenLastParamClassType.ANE_ParamName);
  Assert(result.OverridenLastIndex >= 0);

  result.FirstUnitIndex := MNW_Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFMNW_FirstUnitParamClassType.ANE_ParamName);
  Assert(result.FirstUnitIndex >= 0);

  result.LastUnitIndex := MNW_Layer.GetParameterIndex(ModelHandle,
    ModflowTypes.GetMFMNW_LastUnitParamClassType.ANE_ParamName);
  Assert(result.LastUnitIndex >= 0);

  with frmModflow do
  begin
    with clbMNW_TimeVaryingParameters do
    begin
      if AllSteady or not Checked[Ord(mnwWellRadius)] then
      begin
        result.RadiusIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_RadiusParamClassType.ANE_ParamName);
        Assert(result.RadiusIndex >= 0);
      end
      else
      begin
        result.RadiusIndex := -1;
      end;
      if AllSteady or not Checked[Ord(mnwGroupID)] then
      begin
        result.GroupIdentifierIndex :=
          MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_GroupIndentifierParamClassType.ANE_ParamName);
        Assert(result.GroupIdentifierIndex >= 0);
      end
      else
      begin
        result.GroupIdentifierIndex := -1;
      end;
      if AllSteady or not Checked[Ord(mnwDrawdownFlag)] then
      begin
        result.DrawdownFlagIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_DrawdownFlagParamClassType.ANE_ParamName);
        Assert(result.DrawdownFlagIndex >= 0);
      end
      else
      begin
        result.DrawdownFlagIndex := -1;
      end;
      if AllSteady or not Checked[Ord(mnwRefElev)] then
      begin
        result.ReferenceElevationIndex :=
          MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_ReferenceElevationParamClassType.ANE_ParamName);
        Assert(result.ReferenceElevationIndex >= 0);
      end
      else
      begin
        result.ReferenceElevationIndex := -1;
      end;
      if AllSteady or not Checked[Ord(mnwLimitingElevation)] then
      begin
        result.LimitingElevationIndex :=
          MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_LimitingElevationParamClassType.ANE_ParamName);
        Assert(result.LimitingElevationIndex >= 0);
      end
      else
      begin
        result.LimitingElevationIndex := -1;
      end;
      if AllSteady or not Checked[Ord(mnwPumpingLimits)] then
      begin
        result.InactivationIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_InactivationPumpingRateParamClassType.
          ANE_ParamName);
        Assert(result.InactivationIndex >= 0);

        result.ReactivationIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_ReactivationPumpingRateParamClassType.
          ANE_ParamName);
        Assert(result.ReactivationIndex >= 0);

        result.CCutIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_AbsolutePumpingRatesParamClassType.
          ANE_ParamName);
        Assert(result.CCutIndex >= 0);

        result.PumpingLimitsIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_PumpingLimitsParamClassType.
          ANE_ParamName);
        Assert(result.PumpingLimitsIndex >= 0);
      end
      else
      begin
        result.InactivationIndex := -1;
        result.ReactivationIndex := -1;
        result.PumpingLimitsIndex := -1;
      end;
      if AllSteady or not Checked[Ord(mnwSkin)] then
      begin
        result.SkinIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_SkinParamClassType.ANE_ParamName);
        Assert(result.SkinIndex >= 0);
      end
      else
      begin
        result.SkinIndex := -1;
      end;
      if (combMNW_LossType.ItemIndex = 2) and (AllSteady or not
        Checked[Ord(mnwCoefficient)]) then
      begin
        result.CoefficientIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_CoefficientParamClassType.ANE_ParamName);
        Assert(result.CoefficientIndex >= 0);
      end
      else
      begin
        result.CoefficientIndex := -1;
      end;
      if cbMT3D.Checked then
      begin
        ConcCount := StrToInt(adeMT3DNCOMP.Text);
        SetLength(result.MT3D_Indicies, ConcCount);
        if (ConcCount >= 1) then
        begin
          if (AllSteady or not Checked[Ord(mnwMt3dConc1)]) then
          begin
            result.MT3D_Indicies[0] := MNW_Layer.GetParameterIndex(ModelHandle,
              ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName);
            Assert(result.MT3D_Indicies[0] >= 0);
          end
          else
          begin
            result.MT3D_Indicies[0] := -1;
          end;
        end;
        if (ConcCount >= 2) then
        begin
          if (AllSteady or not Checked[Ord(mnwMt3dConc2)]) then
          begin
            result.MT3D_Indicies[1] := MNW_Layer.GetParameterIndex(ModelHandle,
              ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName);
            Assert(result.MT3D_Indicies[1] >= 0);
          end
          else
          begin
            result.MT3D_Indicies[1] := -1;
          end;
        end;
        if (ConcCount >= 3) then
        begin
          if (AllSteady or not Checked[Ord(mnwMt3dConc3)]) then
          begin
            result.MT3D_Indicies[2] := MNW_Layer.GetParameterIndex(ModelHandle,
              ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName);
            Assert(result.MT3D_Indicies[2] >= 0);
          end
          else
          begin
            result.MT3D_Indicies[2] := -1;
          end;
        end;
        if (ConcCount >= 4) then
        begin
          if (AllSteady or not Checked[Ord(mnwMt3dConc4)]) then
          begin
            result.MT3D_Indicies[3] := MNW_Layer.GetParameterIndex(ModelHandle,
              ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName);
            Assert(result.MT3D_Indicies[3] >= 0);
          end
          else
          begin
            result.MT3D_Indicies[3] := -1;
          end;
        end;
        if (ConcCount >= 5) then
        begin
          if (AllSteady or not Checked[Ord(mnwMt3dConc5)]) then
          begin
            result.MT3D_Indicies[4] := MNW_Layer.GetParameterIndex(ModelHandle,
              ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName);
            Assert(result.MT3D_Indicies[4] >= 0);
          end
          else
          begin
            result.MT3D_Indicies[4] := -1;
          end;
        end;
      end;

    end;
//    if cbMOC3D.Checked and (comboMnwObservations.ItemIndex >= 1) then
//    begin
//      result.IsObservationIndex := MNW_Layer.GetParameterIndex(ModelHandle,
//        ModflowTypes.GetMFIsObservationParamType.ANE_ParamName);
//      Assert(result.IsObservationIndex >= 0);
//    end
//    else
//    begin
      result.IsObservationIndex := -1;
//    end;

//    if cbMOC3D.Checked and (comboMnwObservations.ItemIndex = 1) then
//    begin
//      result.ObsFlagIndex := MNW_Layer.GetParameterIndex(ModelHandle,
//        ModflowTypes.GetMFMNW_OutputFlagParamType.ANE_ParamName);
//      Assert(result.ObsFlagIndex >= 0);
//    end
//    else
//    begin
      result.ObsFlagIndex := -1;
//    end;
  end;
end;

function TMultiNodeWellWriter.GetTransientIndicies(const StressPeriod: integer):
  TTransientIndicies;
var
  StressString: string;
  ConcCount: integer;
begin
//  ConcCount := 0;
  StressString := IntToStr(StressPeriod);

  result.StressIndex := MNW_Layer.GetParameterIndex(ModelHandle, ModflowTypes.
    GetMFMNW_StressParamClassType.ANE_ParamName + StressString);
  Assert(result.StressIndex >= 0);
  result.ActiveIndex := MNW_Layer.GetParameterIndex(ModelHandle, ModflowTypes.
    GetMFMNW_ActiveParamClassType.ANE_ParamName + StressString);
  Assert(result.ActiveIndex >= 0);

  with frmModflow do
  begin
    with clbMNW_TimeVaryingParameters do
    begin
      if not AllSteady and Checked[Ord(mnwWellRadius)] then
      begin
        result.RadiusIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_RadiusParamClassType.ANE_ParamName +
          StressString);
        Assert(result.RadiusIndex >= 0);
      end
      else
      begin
        result.RadiusIndex := -1;
      end;
      if not AllSteady and Checked[Ord(mnwGroupID)] then
      begin
        result.GroupIdentifierIndex :=
          MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_GroupIndentifierParamClassType.ANE_ParamName +
          StressString);
        Assert(result.GroupIdentifierIndex >= 0);
      end
      else
      begin
        result.GroupIdentifierIndex := -1;
      end;
      if not AllSteady and Checked[Ord(mnwDrawdownFlag)] then
      begin
        result.DrawdownFlagIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_DrawdownFlagParamClassType.ANE_ParamName +
          StressString);
        Assert(result.DrawdownFlagIndex >= 0);
      end
      else
      begin
        result.DrawdownFlagIndex := -1;
      end;
      if not AllSteady and Checked[Ord(mnwRefElev)] then
      begin
        result.ReferenceElevationIndex :=
          MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_ReferenceElevationParamClassType.ANE_ParamName +
          StressString);
        Assert(result.ReferenceElevationIndex >= 0);
      end
      else
      begin
        result.ReferenceElevationIndex := -1;
      end;
      if not AllSteady and Checked[Ord(mnwLimitingElevation)] then
      begin
        result.LimitingElevationIndex :=
          MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_LimitingElevationParamClassType.ANE_ParamName +
          StressString);
        Assert(result.LimitingElevationIndex >= 0);
      end
      else
      begin
        result.LimitingElevationIndex := -1;
      end;
      if not AllSteady and Checked[Ord(mnwPumpingLimits)] then
      begin
        result.InactivationIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_InactivationPumpingRateParamClassType.
          ANE_ParamName + StressString);
        Assert(result.InactivationIndex >= 0);

        result.ReactivationIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_ReactivationPumpingRateParamClassType.
          ANE_ParamName + StressString);
        Assert(result.ReactivationIndex >= 0);

        result.CCutIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_AbsolutePumpingRatesParamClassType.
          ANE_ParamName + StressString);
        Assert(result.CCutIndex >= 0);

        result.PumpingLimitsIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_PumpingLimitsParamClassType.
          ANE_ParamName + StressString);
        Assert(result.PumpingLimitsIndex >= 0);
      end
      else
      begin
        result.InactivationIndex := -1;
        result.ReactivationIndex := -1;
        result.PumpingLimitsIndex := -1;
      end;
      if not AllSteady and Checked[Ord(mnwSkin)] then
      begin
        result.SkinIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_SkinParamClassType.ANE_ParamName +
          StressString);
        Assert(result.SkinIndex >= 0);
      end
      else
      begin
        result.SkinIndex := -1;
      end;
      if (combMNW_LossType.ItemIndex = 2) and (not AllSteady and
        Checked[Ord(mnwCoefficient)]) then
      begin
        result.CoefficientIndex := MNW_Layer.GetParameterIndex(ModelHandle,
          ModflowTypes.GetMFMNW_CoefficientParamClassType.ANE_ParamName +
          StressString);
        Assert(result.CoefficientIndex >= 0);
      end
      else
      begin
        result.CoefficientIndex := -1;
      end;
      if cbMT3D.Checked then
      begin
        ConcCount := StrToInt(adeMT3DNCOMP.Text);
        SetLength(result.MT3D_Indicies, ConcCount);
        if (ConcCount >= 1) then
        begin
          if (not AllSteady and Checked[Ord(mnwMt3dConc1)]) then
          begin
            result.MT3D_Indicies[0] := MNW_Layer.GetParameterIndex(ModelHandle,
              ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName
              + StressString);
            Assert(result.MT3D_Indicies[0] >= 0);
          end
          else
          begin
            result.MT3D_Indicies[0] := -1;
          end;
        end;
        if (ConcCount >= 2) then
        begin
          if (not AllSteady and Checked[Ord(mnwMt3dConc2)]) then
          begin
            result.MT3D_Indicies[1] := MNW_Layer.GetParameterIndex(ModelHandle,
              ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName
              + StressString);
            Assert(result.MT3D_Indicies[1] >= 0);
          end
          else
          begin
            result.MT3D_Indicies[1] := -1;
          end;
        end;
        if (ConcCount >= 3) then
        begin
          if (not AllSteady and Checked[Ord(mnwMt3dConc3)]) then
          begin
            result.MT3D_Indicies[2] := MNW_Layer.GetParameterIndex(ModelHandle,
              ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName
              + StressString);
            Assert(result.MT3D_Indicies[2] >= 0);
          end
          else
          begin
            result.MT3D_Indicies[2] := -1;
          end;
        end;
        if (ConcCount >= 4) then
        begin
          if (not AllSteady and Checked[Ord(mnwMt3dConc4)]) then
          begin
            result.MT3D_Indicies[3] := MNW_Layer.GetParameterIndex(ModelHandle,
              ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName
              + StressString);
            Assert(result.MT3D_Indicies[3] >= 0);
          end
          else
          begin
            result.MT3D_Indicies[3] := -1;
          end;
        end;
        if (ConcCount >= 5) then
        begin
          if (not AllSteady and Checked[Ord(mnwMt3dConc5)]) then
          begin
            result.MT3D_Indicies[4] := MNW_Layer.GetParameterIndex(ModelHandle,
              ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName
              + StressString);
            Assert(result.MT3D_Indicies[4] >= 0);
          end
          else
          begin
            result.MT3D_Indicies[4] := -1;
          end;
        end;
      end;
    end;
  end;
end;

procedure TMultiNodeWellWriter.InitializeWaterQuality;
var
  TimeCount: integer;
  LayerIndex: integer;
  TimeIndex: integer;
  WaterQualityLayer: TLayerOptions;
begin
  // First dimension = geologic units.
  // Second dimension = time.
  TransientTime := (frmModflow.comboMNW_Steady.ItemIndex = 1) and
    frmModflow.clbMNW_TimeVaryingParameters.Checked[Ord(mnwWaterQuality)];
  if TransientTime then
  begin
    TimeCount := frmModflow.dgTime.RowCount - 1;
  end
  else
  begin
    TimeCount := 1;
  end;
  for LayerIndex := 1 to frmModflow.dgGeol.RowCount - 1 do
  begin
    WaterQualityLayer := TLayerOptions.CreateWithName(
      ModflowTypes.GetMFMNW_WaterQualityLayerType.ANE_LayerName
      + IntToStr(LayerIndex), ModelHandle);

    WaterQualityList.Add(WaterQualityLayer);
  end;
  if TransientTime then
  begin
    for TimeIndex := 1 to TimeCount do
    begin
      WaterQualityParameterNames.Add(ModflowTypes.
        GetMFMNW_WaterQualityParamClassType.ANE_ParamName
        + IntToStr(TimeIndex));
    end;
  end
  else
  begin
    WaterQualityParameterNames.Add(ModflowTypes.
      GetMFMNW_WaterQualityParamClassType.ANE_ParamName);
  end;
end;

procedure TMultiNodeWellWriter.WriteDataSet1;
var
  MXMNW: integer;
  IWL2CB: integer;
  IWELPT: integer;
  kspref: integer;
  TimeIndex: integer;
  CellList: TMNW_CellList;
begin
  MXMNW := 0;
  for TimeIndex := 0 to TimeList.Count - 1 do
  begin
    CellList := TimeList[TimeIndex] as TMNW_CellList;
    if CellList.Count > MXMNW then
    begin
      MXMNW := CellList.Count;
    end;
  end;
  if frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbMNW_PrintFlows.Checked then
    begin
//      IWL2CB := -1;
      IWL2CB := -frmModflow.GetUnitNumber('BUD');
    end
    else
    begin
      IWL2CB := frmModflow.GetUnitNumber('BUD');
    end;
  end
  else
  begin
    if frmModflow.cbMNW_PrintFlows.Checked then
    begin
      IWL2CB := -1;
    end
    else if frmModflow.cbFlowMNW.Checked then
    begin
      IWL2CB := frmModflow.GetUnitNumber('MNWBUD');
    end
    else
    begin
      IWL2CB := 0;
    end;
  end;
  IWELPT := 0;
  kspref := StrToInt(frmModflow.adeMNW_RefStressPer.Text);
  WriteLn(FFile, MXMNW, ' ', IWL2CB, ' ', IWELPT, ' ', 'Reference SP = ',
    kspref);
end;

procedure TMultiNodeWellWriter.WriteDataSet2;
var
  PlosMNW: double;
begin
  case frmModflow.combMNW_LossType.ItemIndex of
    0:
      begin
        WriteLn(FFile, 'SKIN');
      end;
    1:
      begin
        WriteLn(FFile, 'LINEAR');
      end;
    2:
      begin
        PlosMNW := InternationalStrToFloat(frmModflow.adeMNW_PLoss.Text);
        WriteLn(FFile, 'NONLINEAR ', FreeFormattedReal(PlosMNW));
      end;
  else
    Assert(False);
  end;
end;

procedure TMultiNodeWellWriter.WriteDataSet3a;
var
  iunw1: integer;
  FileName: string;
begin
  if frmModflow.cbMNW_WellOutput.Checked then
  begin
    FileName := MNW_Root + rsWL1;
    iunw1 := frmModflow.GetUnitNumber('iunw1');
    writeln(FFile, 'FILE:', FileName, '  WEL1:', iunw1);
  end;
end;

procedure TMultiNodeWellWriter.WriteDataSet3b;
var
  iunby: integer;
  FileName: string;
  ALLTIME: string;
begin
  if frmModflow.cbMNW_WriteFlows.Checked then
  begin
    FileName := MNW_Root + rsBYN;
    iunby := frmModflow.GetUnitNumber('iunby');
    if frmModflow.cbMNW_Alltime.Checked then
    begin
      ALLTIME := 'ALLTIME';
    end
    else
    begin
      ALLTIME := '';
    end;
    writeln(FFile, 'FILE:', FileName, '  BYNODE:', iunby, ' ', ALLTIME);
  end;
end;

procedure TMultiNodeWellWriter.WriteDataSet3c;
var
  iunqs: integer;
  FileName: string;
  ALLTIME: string;
begin
  if frmModflow.cbMNW_WriteFlows.Checked then
  begin
    FileName := MNW_Root + rsQSU;
    iunqs := frmModflow.GetUnitNumber('iunqs');
    if frmModflow.cbMNW_Alltime.Checked then
    begin
      ALLTIME := 'ALLTIME';
    end
    else
    begin
      ALLTIME := '';
    end;
    writeln(FFile, 'FILE:', FileName, '  QSUM:', iunqs, ' ', ALLTIME);
  end;
end;

procedure TMultiNodeWellWriter.WriteDataSets4and5;
var
  TimeIndex: integer;
  CellList: TMNW_CellList;
begin
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := TimeList.Count;
  for TimeIndex := 0 to TimeList.Count - 1 do
  begin
    frmProgress.lblActivity.Caption := 'Writing stress period ' +
      IntToStr(TimeIndex + 1);
    Application.ProcessMessages;
    if not ContinueExport then
      Exit;
    if (TimeIndex > 0) and AllSteady then
    begin
      writeln(FFile, -1);
    end
    else
    begin
      CellList := TimeList.Items[TimeIndex] as TMNW_CellList;
      CellList.WriteStressPeriod(self);
      frmProgress.pbActivity.StepIt;
    end;

  end;
end;

procedure TMultiNodeWellWriter.Evaluate(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
begin
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := 2;

  EvaluateInternal(CurrentModelHandle, Discretization);
end;

procedure TMultiNodeWellWriter.EvaluateInternal(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
var
  Index: integer;
begin
  ObservationErrors.Clear;
  ModelHandle := CurrentModelHandle;
  Dis := Discretization;
  for Index := 1 to Dis.NPER do
  begin
    TimeList.Add(TMNW_CellList.Create);
  end;

  frmProgress.lblPackage.Caption := 'Multi-Node Well (MNW)';
  frmProgress.lblActivity.Caption := 'Evaluating Multi-Node Wells';

  Application.ProcessMessages;
  if ContinueExport then
  begin
    EvaluateDataSets4and5;
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;
end;

procedure TMultiNodeWellWriter.WriteFile(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization: TDiscretizationWriter);
var
//  Index: integer;
  FileName: string;
  ErrorString: string;
begin
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := 3;

  EvaluateInternal(CurrentModelHandle, Discretization);

  MNW_Root := Root;
  // write MNW file
  if ContinueExport then
  begin
    frmProgress.lblActivity.Caption := 'Writing data sets 1-3';
    FileName := GetCurrentDir + '\' + Root + rsMNW;
    AssignFile(FFile, FileName);
    try
      Application.ProcessMessages;
      if ContinueExport then
      begin
        Rewrite(FFile);
        WriteDataSet1;
        WriteDataSet2;
        WriteUnnumberedB;
        WriteDataSet3a;
        WriteDataSet3b;
        WriteDataSet3c;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSets4and5;
        frmProgress.pbPackage.StepIt;
      end;
    finally
      CloseFile(FFile);
    end;
  end;

  // write MNWO file
  {if ContinueExport then
  begin
    if frmModflow.cbMOC3D.Checked and
      (frmModflow.comboMnwObservations.ItemIndex >= 1)
      and (frmModflow.MultiNodeWellNames.Count > 0) then
    begin
      frmProgress.lblPackage.Caption := 'Multi-Node Well Observations (MNWo)';
      frmProgress.lblActivity.Caption := 'Writing Multi-Node Wells Observations';
      FileName := GetCurrentDir + '\' + Root + rsMNWO;
      AssignFile(FFile, FileName);
      try
        Application.ProcessMessages;
        if ContinueExport then
        begin
          Rewrite(FFile);
          WriteObservationsDataSet1;
          WriteObservationsDataSet2;
        end;
      finally
        CloseFile(FFile);
      end;
    end;
  end;}

  if ObservationErrors.Count > 0 then
  begin
    ErrorString := 'Warning: One or more Multi-Node Well Observations are for '
      + 'wells where "Site" has not been specified.  '
      + 'These observations will be ignored.';
    frmProgress.reErrors.Lines.Add(ErrorString);

    ErrorMessages.Add('');
    ErrorMessages.Add(ErrorString);
    ErrorMessages.Add('Row, Column');
    ErrorMessages.AddStrings(ObservationErrors);
  end;


end;

{procedure TMultiNodeWellWriter.WriteObservationsDataSet1;
var
  MNWOBS: integer;
begin
  MNWOBS := frmModflow.MultiNodeWellNames.Count;
  WriteLn(FFile, MNWOBS);
end;

procedure TMultiNodeWellWriter.WriteObservationsDataSet2;
var
  Index: integer;
  FirstUnit: integer;
  MNWsite: string;
  UNIT_Number: integer;
  MNWOflag : integer;
  ObsFlag: TObsFlag;
begin
  FirstUnit := frmModflow.GetNUnitNumbers(rsMNWO_Out,
    frmModflow.MultiNodeWellNames.Count);
  MNWOflag := frmModflow.comboMnwObservations.ItemIndex -2;
  for Index := 0 to frmModflow.MultiNodeWellNames.Count -1 do
  begin
    MNWsite := frmModflow.MultiNodeWellNames[Index];
    UNIT_Number := FirstUnit + Index;
    if frmModflow.comboMnwObservations.ItemIndex = 1 then
    begin
      ObsFlag := frmModflow.MultiNodeWellNames.Objects[Index] as TObsFlag;
      MNWOflag := ObsFlag.ObsFlag;
    end;
    Assert(MNWOflag in [0,1,2,3]);
    WriteLn(FFile, MNWsite, ' ', UNIT_Number, ' ', MNWOflag);
  end;
end;        }

class procedure TMultiNodeWellWriter.AssignUnitNumbers;
begin
  if frmModflow.cbOneFlowFile.Checked then
  begin
    if frmModflow.cbMNW_PrintFlows.Checked then
    begin
      frmModflow.GetUnitNumber('BUD');
    end
    else
    begin
      frmModflow.GetUnitNumber('BUD');
    end;
  end
  else
  begin
    if frmModflow.cbMNW_PrintFlows.Checked then
    begin
      //
    end
    else if frmModflow.cbFlowMNW.Checked then
    begin
      frmModflow.GetUnitNumber('MNWBUD');
    end;
  end;
  if frmModflow.cbMNW_WellOutput.Checked then
  begin
    frmModflow.GetUnitNumber('iunw1');
  end;
  if frmModflow.cbMNW_WriteFlows.Checked then
  begin
    frmModflow.GetUnitNumber('iunby');
  end;
  if frmModflow.cbMNW_WriteFlows.Checked then
  begin
    frmModflow.GetUnitNumber('iunqs');
  end;
end;

procedure TMultiNodeWellWriter.WriteUnnumberedB;
begin
  WriteLn(FFile, 'FILEPREFIX:');
end;

{ TMNW_Cell }

procedure TMNW_Cell.WriteCell(const Writer: TMultiNodeWellWriter);
var
  MN: string;
  DD: string;
  CP: string;
  QCUT: string;
  Site: string;
  Rate: string;
begin
  if Properties.DrawDownFlag then
  begin
    DD := 'DD ';
  end
  else
  begin
    DD := '';
  end;
  if Properties.Coefficient = 0 then
  begin
    CP := ''
  end
  else
  begin
    CP := 'Cp: ' + Writer.FreeFormattedReal(Properties.Coefficient);
  end;
  if Properties.Site = '' then
  begin
    Site := '';
  end
  else
  begin
    Site := 'SITE:' + Properties.Site;
  end;

  if Properties.PumpingLimts then
  begin
    if Properties.AbsolutePumpingRate then
    begin
      QCUT := 'QCUT ';
    end
    else
    begin
      QCUT := 'Q-%CUT ';
    end;
    QCUT := QCUT
      + Writer.FreeFormattedReal(Properties.InactivationRate)
      + Writer.FreeFormattedReal(Properties.ReactivationRate);
  end
  else
  begin
    QCUT := '';
  end;
  if Properties.FirstCell then
  begin
    MN := '';
    Rate := Writer.FreeFormattedReal(Properties.Stress)
  end
  else
  begin
    MN := 'MN ';
    Rate := '0. ';
    QCUT := '';
  end;
  if Properties.Stress = 0 then
  begin
    QCUT := '';
  end;

  Writeln(Writer.FFile,
    Layer, ' ',
    Row, ' ',
    Col, ' ',
    Rate,
    MN,
    Writer.FreeFormattedReal(Properties.WaterQuality),
    Writer.FreeFormattedReal(Properties.Radius),
    Writer.FreeFormattedReal(Properties.Skin),
    Writer.FreeFormattedReal(Properties.LimitingWaterLevel),
    Writer.FreeFormattedReal(Properties.ReferenceElevation),
    DD,
    Properties.GroupID, ' ',
    CP,
    QCUT,
    Site);
end;

procedure TMNW_Cell.WriteMT3DConcentrations(const Lines: TStrings);
var
  ALine : string;
  SpeciesIndex : integer;
begin
  ALine := TModflowWriter.FixedFormattedInteger(Layer, 10)
    + TModflowWriter.FixedFormattedInteger(Row, 10)
    + TModflowWriter.FixedFormattedInteger(Col, 10)
    + TModflowWriter.FixedFormattedReal(Properties.MT3DConcentrations[0], 10)
    + TModflowWriter.FixedFormattedInteger(27, 10) + ' ';
  if Length(Properties.MT3DConcentrations) >= 2 then
  begin
    for SpeciesIndex := 0 to Length(Properties.MT3DConcentrations)-1 do
    begin
      ALine := ALine + TModflowWriter.FreeFormattedReal
        (Properties.MT3DConcentrations[SpeciesIndex]);
    end;
  end;
  Lines.Add(ALine);
end;

{ TMNW_CellList }

function TMNW_CellList.Add(Col, Row, Layer: integer;
  Properties: TMNW_Properties): integer;
var
  ACell: TMNW_Cell;
begin
  ACell := TMNW_Cell.Create;
  result := inherited Add(ACell);
  ACell.Col := Col;
  ACell.Row := Row;
  ACell.Layer := Layer;
  ACell.Properties := Properties;
  SetLength(ACell.Properties.MT3DConcentrations,
    Length(Properties.MT3DConcentrations))
end;

procedure TMNW_CellList.WriteMT3DConcentrations(const Lines: TStrings);
var
  Index : integer;
  ACell : TMNW_Cell;
begin
  for Index := 0 to Count -1 do
  begin
    ACell := Items[Index] as TMNW_Cell;
    ACell.WriteMT3DConcentrations(Lines);
  end;
end;

procedure TMNW_CellList.WriteStressPeriod(
  const Writer: TMultiNodeWellWriter);
var
  Index: integer;
  ACell: TMNW_Cell;
begin
  // data set 4
  writeln(Writer.FFile, Count);
  // data set 5
  for Index := 0 to Count - 1 do
  begin
    ACell := Items[Index] as TMNW_Cell;
    ACell.WriteCell(Writer);
  end;
end;

end.

