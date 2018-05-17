unit WriteModflowDiscretization;

interface

uses Sysutils,classes,contnrs, Forms, ANEPIE, IntListUnit, RealListUnit,
  CopyArrayUnit;

type
  EInvalidParameterValue = Class(Exception);
  EInvalidParameterName = Class(Exception);
  TPostionArray = array of double;
  TLayerArray = array of integer;

  TSetArrayMember = procedure(Col, Row, UnitIndex : integer;
    Value : double) of object;

  TStressPeriodRecord = record
    PERLEN : double;
    NSTP : integer;
    TSMULT : double;
    Transient : boolean;
  end;

  TDiscretizationWriter = class;

  TBasicPkgWriter = class;

  TModflowWriter = class(TObject)
  protected
    procedure GetLayers(const UnitIndex: integer;
      var ModflowLayers: TLayerArray);
    procedure WriteDataReadFrom(FileName: string);
    procedure WriteComment(Comment : string);
    Procedure WriteU2DRELHeader(const Comment: string = '');
    Procedure WriteU2DINTHeader(const Comment: string = '');
    procedure SetUnitDoubleArray(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter; SetArray: TSetArrayMember;
      ParameterRoot : String; BasicPkg : TBasicPkgWriter);
    class Function FortranDecimal(NumberString : string) : string;
  public
    FFile : TextFile;
    class function IPRN_Real: integer;
    class function IPRN_Integer: integer;
    class function FreeFormattedReal(const Value : double) : string;
    class function FixedFormattedInteger(const Value,
      Width: integer): string;
    class function FixedFormattedReal(const Value : double;
      const Width : integer) : string;
  end;

  TDiscretizationWriter = class(TModflowWriter)
  private
    RowsReversed, ColsReversed : boolean;
    StressPeriods : array of TStressPeriodRecord;
    MaxColumn, MinColumn, MaxRow, MinRow : double;
    GridAngle: ANE_DOUBLE;
    procedure SetElevationArraySize;
    procedure WriteDataSet1;
    procedure WriteDataSet2;
    procedure WriteDELC(const CurrentModelHandle: ANE_PTR);
    procedure WriteDELR(const CurrentModelHandle: ANE_PTR);
    procedure WriteTOP(const CurrentModelHandle: ANE_PTR);
    procedure WriteBottom(const CurrentModelHandle: ANE_PTR);
    procedure SetTOP(const CurrentModelHandle: ANE_PTR);
    procedure SetBottom(const CurrentModelHandle: ANE_PTR;
      ParameterIndicies : TIntegerList);
    procedure WriteStressPeriods;
    procedure SetTransient;
    Procedure EvaluateStressPeriods;
    procedure EvaluateDELC(const CurrentModelHandle: ANE_PTR);
    procedure EvaluateDELR(const CurrentModelHandle: ANE_PTR);
    procedure CheckSimulatedUnits;
    procedure EvaluateCornerCoordinates(const CurrentModelHandle: ANE_PTR);
{    procedure GetPeriodAndOffset(Time: double; var StressPeriod: integer;
      var TimeOffSet: double);}
  public
    NPER, NLAY, NROW, NCOL, NUNITS : ANE_INT32;
    GridLayerHandle : ANE_PTR;
    // indexed by Col, Row, GeoUnit_number
    Elevations : array of array of array of ANE_DOUBLE;
    Thicknesses : array of array of array of ANE_DOUBLE;
    Transient : boolean;
    DELC : array of ANE_DOUBLE;
    DELR : array of ANE_DOUBLE;
    procedure CheckElevations(Basic: TBasicPkgWriter);
    procedure WriteModflowDiscretizationFile(
      const CurrentModelHandle: ANE_PTR; Root: string);
    Procedure InitializeButDontWrite(const CurrentModelHandle: ANE_PTR);
    procedure SetVariables(const CurrentModelHandle: ANE_PTR);
    function BlockIndex(RowIndex, ColIndex : integer) : integer;
    function ColNumber(ColIndex : integer) : integer;
    function RowNumber(RowIndex : integer) : integer;
    function ElevationToLayer(Column, Row : integer;
      const Elevation : double) : integer;
    function ElevationToUnit(Column, Row : integer;
      const Elevation : double) : integer;
    procedure GetColRow(var X, Y: ANE_Double; var Col,
      Row: Integer; Const GridAngle, RotatedOriginX, RotatedOriginY : double;
      const ColPostions, RowPostions : TPostionArray);
  end;

  TMT3DCellRecord = record
    Layer : integer;
    Row : integer;
    Column : integer;
    MT3DConcentrations : T2DDoubleArray;
  end;

  TMT3DCell = class(TObject)
    Cell : TMT3DCellRecord;
    procedure WriteMT3DConcentrations(const StressPeriod: integer;
      const Lines : TStrings);
  end;

  TMT3DCellList = class(TObjectList)
    function Add(ACell : TMT3DCellRecord) : integer; overload;
    function GetCellByLocation(Layer, Row, Column: integer): TMT3DCell;
  end;

  TListWriter = class(TModflowWriter)
  protected
    Function DefaultValue(Expression : String) : string;
    procedure AddVertexLayer(const CurrentModelHandle: ANE_PTR; LayerName : string);
  end;

  TBasicPkgWriter = class(TListWriter)
  private
    Procedure WriteOptions;
    procedure WriteHnoflo;
    Procedure SetArraySizes(Discretization : TDiscretizationWriter);
    Procedure SetIboundArraySize(Discretization : TDiscretizationWriter);
    procedure SetIboundArray(CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure SetMT3DConcentrations(CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure SetStrtArray(CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure WriteIboundArray(CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure WriteStrtArray(CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure SetStrt(Col, Row, UnitIndex : integer; Value : double);
    procedure CheckStartingHeads(Discretization: TDiscretizationWriter);
    procedure UpdateMFIBOUND(Discretization: TDiscretizationWriter);
  public
    IFACE: array of array of array of INTEGER;
    IBOUND : array of array of array of ANE_INT32;
    MFIBOUND : array of array of array of ANE_INT32;
    MT3DCellList : TMT3DCellList; //[NCOL, NROW, NUNITS, Stressperiod, Species];
    STRT : array of array of array of ANE_DOUBLE;
//    MOC3DConcentration : array of array of array of ANE_DOUBLE;
    CellUsed : array of array of boolean;
    Moc3DConcentrations : TRealList;
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
    Procedure InitializeButDontWrite(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure InitializeAll(const CurrentModelHandle: ANE_PTR;
      Discretization: TDiscretizationWriter);
    constructor Create;
    destructor Destroy; override;
    Procedure InitializeMT3DConcentrations(const CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter);
    procedure WriteMT3DConcentrations(const StressPeriod : integer;
      const Lines : TStrings);
    class procedure AssignUnitNumbers;
  end;

  TBoundaryCell = Class(TObject)
    GroupNumber : integer;
    Constructor Create(AGroupNumber : integer);
  end;

  TCustomBoundaryWriter = class(TListWriter)
  public
    function BoundaryUsed(Layer, Row, Column : integer): boolean; virtual;
      abstract;
  end;

  TCustomBoundaryWriterWithObservations = class(TCustomBoundaryWriter)
  public
    Procedure FillBoundaryList(Layer, Row, Column : integer;
      BoundaryList : TObjectList); virtual; abstract;
  end;

var
  MinSingle : single;

implementation

uses ModflowUnit, Variables, UtilityFunctions, OptionsUnit, ProgressUnit,
  InitializeVertexUnit, BlockListUnit, WriteNameFileUnit, UnitNumbers,
  GetCellUnit, WriteCHDUnit, WriteModflowFilesUnit, ReadModflowArrayUnit, Math;

procedure InitializeMinSingle;
var
  value, NewValue : single;
begin
  value := 1;
  NewValue := 1/2;
  while (Value <> NewValue) do
  begin
    value := NewValue;
    NewValue := NewValue / 2;
    if NewValue = 0 then
    begin
      break;
    end;
  end;
  MinSingle := value;
end;


Procedure TDiscretizationWriter.SetVariables(const CurrentModelHandle : ANE_PTR);
var
  MinX, MaxX, MinY, MaxY : ANE_DOUBLE;
  GridLayer : TLayerOptions;
  AString : string;
begin
  GetGrid(CurrentModelHandle,
    ModflowTypes.GetGridLayerType.WriteNewRoot,
    GridLayerHandle, NROW, NCOL,
    MinX, MaxX, MinY, MaxY, GridAngle);
  NLAY := frmMODFLOW.MODFLOWLayerCount;
  if ShowWarnings and (NLAY = 0) then
  begin
      AString := 'Error: No Geologic units are simulated.';
      frmProgress.reErrors.Lines.Add(AString);
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);
  end;
  NUNITS := StrToInt(frmMODFLOW.edNumUnits.Text);
  NPER := StrToInt(frmMODFLOW.edNumPer.Text);
  SetTransient;
  GridLayer := TLayerOptions.Create(GridLayerHandle);
  try
    RowsReversed := GridLayer.GridReverseYDirection[CurrentModelHandle];
    ColsReversed := GridLayer.GridReverseXDirection[CurrentModelHandle];
  finally
    GridLayer.Free(CurrentModelHandle);
  end;
  EvaluateStressPeriods;

  if ContinueExport then
  begin
    EvaluateDELR(CurrentModelHandle);
    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    EvaluateDELC(CurrentModelHandle);
    Application.ProcessMessages;
  end;
  if ContinueExport then
  begin
    SetElevationArraySize;
    Application.ProcessMessages;
  end;

end;


Procedure TDiscretizationWriter.WriteDataSet1;
var
  ITMUNI, LENUNI : integer;
begin
  NPER := StrToInt(frmMODFLOW.edNumPer.Text);
  ITMUNI := frmMODFLOW.comboTimeUnits.ItemIndex;
  LENUNI := frmMODFLOW.comboLengthUnits.ItemIndex;
  WriteLn(FFile, NLAY, ' ', NROW, ' ', NCOL, ' ',
    NPER, ' ', ITMUNI, ' ', LENUNI);
end;

procedure TDiscretizationWriter.WriteDataSet2;
var
  UnitIndex, LayerIndex : integer;
begin
  with frmMODFLOW do
  begin
    for UnitIndex := 1 to dgGeol.RowCount -1 do
    begin
      if dgGeol.Cells[Ord(nuiSim), UnitIndex] =
        dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
        for LayerIndex := 1 to StrToInt(dgGeol.
          Cells[Ord(nuiVertDisc), UnitIndex]) -1 do
        begin
          Write(FFile, 0, ' ');
        end;
        if (UnitIndex < dgGeol.RowCount -1) and
          (dgGeol.Cells[Ord(nuiSim), UnitIndex+1] =
            dgGeol.Columns[Ord(nuiSim)].PickList[0]) then
        begin
          Writeln(FFile, 1, ' ');
        end
        else
        begin
          Writeln(FFile, 0, ' ');
        end;
      end;
    end;
  end;

end;

Procedure TDiscretizationWriter.EvaluateDELR(const CurrentModelHandle : ANE_PTR);
const
  MaxRatio = 1.5;
  MinRatio = 1/1.5;
var
  ColumnIndex : integer;
  StringToEvaluate : String;
  ColStr : String;
  Width, OldWidth : double;
  ZeroWidthErrors, RatioErrors : TStringList;
  Ratio : double;
  AString : string;
begin
  OldWidth := 0;
  SetLength(DELR,NCOL);
  ZeroWidthErrors := TStringList.Create;
  RatioErrors := TStringList.Create;
  try
    frmProgress.lblActivity.Caption := 'Evaluating DELR';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := NCOL;

    for ColumnIndex := 0 to NCOL-1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      ColStr := IntToStr(ColumnIndex);
      StringToEvaluate := 'Abs(NthColumnPos('
        + ColStr
        + '+1)-NthColumnPos('
        + ColStr
        + '))';
      Width := EvalDoubleByLayerHandle(CurrentModelHandle, GridLayerHandle,
          StringToEvaluate);
      DELR[ColumnIndex] := Width;
      if ShowWarnings then
      begin
        if ColumnIndex = 0 then
        begin
          MaxColumn := Width;
          MinColumn := Width;
        end
        else
        begin
          if Width>MaxColumn then
          begin
            MaxColumn := Width;
          end;
          if Width<MinColumn then
          begin
            MinColumn := Width;
          end;
        end;
        if Width = 0 then
        begin
          ZeroWidthErrors.Add(Format('[%d]', [ColumnIndex + 1]));
        end
        else
        begin
        if ColumnIndex > 0 then
        begin
          if OldWidth <> 0 then
          begin
            Ratio := Width/OldWidth;
            if (Ratio > MaxRatio) or (Ratio < MinRatio) then
            begin
              RatioErrors.Add(Format('[%d, %d]', [ColumnIndex, ColumnIndex+1]));
            end;
          end;
        end;
        end;
        OldWidth := Width;
      end;

      frmProgress.pbActivity.StepIt;
    end;
    if ZeroWidthErrors.Count > 0 then
    begin
      AString := 'Error: Column Widths = 0.';
      frmProgress.reErrors.Lines.Add(AString);
      AString := AString + ' [Column]';
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(ZeroWidthErrors);
    end;
    if RatioErrors.Count > 0 then
    begin
      AString := 'Warning: Ratio of adjacent column widths exceeds recommended maximum of 1.5.';
      frmProgress.reErrors.Lines.Add(AString);
      AString := AString + ' [Column, Column]';
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(RatioErrors);
    end;
  finally
    ZeroWidthErrors.Free;
    RatioErrors.Free;
  end;
end;


Procedure TDiscretizationWriter.WriteDELR(const CurrentModelHandle : ANE_PTR);
const
  MaxRatio = 1.5;
  MinRatio = 1/1.5;
var
  ColumnIndex : integer;
//  StringToEvaluate : String;
//  ColStr : String;
//  Width, OldWidth : double;
//  ZeroWidthErrors, RatioErrors : TStringList;
//  Ratio : double;
//  AString : string;
begin
//  EvaluateDELR(CurrentModelHandle);
  frmProgress.lblActivity.Caption := 'Exporting DELR';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := NCOL;

  Writeln(FFile, 'INTERNAL 1.0 (FREE)    1');
  for ColumnIndex := 0 to NCOL-1 do
  begin
    Application.ProcessMessages;
    if not ContinueExport then break;

    Writeln(FFile, DELR[ColumnIndex], ' ');

    frmProgress.pbActivity.StepIt;
  end;
end;

Procedure TDiscretizationWriter.EvaluateDELC(const CurrentModelHandle : ANE_PTR);
const
  MaxRatio = 1.5;
  MinRatio = 1/1.5;
var
  RowIndex : integer;
  StringToEvaluate : String;
  RowStr : String;
  Width, OldWidth : double;
  ZeroWidthErrors, RatioErrors : TStringList;
  Ratio : double;
  AString : string;
begin
  OldWidth := 0;
  SetLength(DELC,NROW);
  ZeroWidthErrors := TStringList.Create;
  RatioErrors := TStringList.Create;
  try
    frmProgress.lblActivity.Caption := 'Evaluating DELC';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := NROW;

    for RowIndex := 0 to NROW-1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      RowStr := IntToStr(RowIndex);
      StringToEvaluate := 'Abs(NthRowPos('
        + RowStr
        + '+1)-NthRowPos('
        + RowStr
        + '))';
      Width := EvalDoubleByLayerHandle(CurrentModelHandle, GridLayerHandle,
          StringToEvaluate);
      DELC[RowIndex] := Width;
      if ShowWarnings then
      begin
        if RowIndex = 0 then
        begin
          MaxRow := Width;
          MinRow := Width;
        end
        else
        begin
          if Width>MaxRow then
          begin
            MaxRow := Width;
          end;
          if Width<MinRow then
          begin
            MinRow := Width;
          end;
        end;
        if Width = 0 then
        begin
          ZeroWidthErrors.Add(Format('[%d]', [RowIndex + 1]));
        end
        else
        begin
        if RowIndex > 0 then
        begin
          if OldWidth <> 0 then
          begin
            Ratio := Width/OldWidth;
            if (Ratio > MaxRatio) or (Ratio < MinRatio) then
            begin
              RatioErrors.Add(Format('[%d, %d]', [RowIndex, RowIndex+1]));
            end;
          end;
        end;
        end;
        OldWidth := Width;
      end;

      frmProgress.pbActivity.StepIt;
    end;
    if ZeroWidthErrors.Count > 0 then
    begin
      AString := 'Error: Row Widths = 0.';
      frmProgress.reErrors.Lines.Add(AString);
      AString := AString + ' [Row]';
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(ZeroWidthErrors);
    end;
    if RatioErrors.Count > 0 then
    begin
      AString := 'Warning: Ratio of adjacent row widths exceeds recommended maximum of 1.5.';
      frmProgress.reErrors.Lines.Add(AString);
      AString := AString + ' [Row, Row]';
      ErrorMessages.Add('');
      ErrorMessages.Add(AString);
      ErrorMessages.AddStrings(RatioErrors);
    end;
    if ShowWarnings then
    begin
      If MaxRow/MinColumn > 10 then
      begin
        AString := 'Warning: Ratio of row height to column width exceeds the recommended maximum of 10.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);
      end;
      If MaxColumn/MinRow > 10 then
      begin
        AString := 'Warning: Ratio of column width to row height exceeds the recommended maximum of 10.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);
      end;
    end;
  finally
    ZeroWidthErrors.Free;
    RatioErrors.Free;
  end;
end;

Procedure TDiscretizationWriter.WriteDELC(const CurrentModelHandle : ANE_PTR);
var
  RowIndex : integer;
//  StringToEvaluate : String;
//  RowStr : String;
//  Width, OldWidth : double;
//  ZeroWidthErrors, RatioErrors : TStringList;
//  Ratio : double;
//  AString : string;
begin
//  EvaluateDELC(CurrentModelHandle);

  frmProgress.lblActivity.Caption := 'Exporting DELC';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := NROW;

  Writeln(FFile, 'INTERNAL 1.0 (FREE)    1');
  for RowIndex := 0 to NROW-1 do
  begin
    Application.ProcessMessages;
    if not ContinueExport then break;

//    Width := DELC[RowIndex];
    Writeln(FFile, DELC[RowIndex], ' ');

    frmProgress.pbActivity.StepIt;
  end;

end;

Procedure TDiscretizationWriter.SetTOP(const CurrentModelHandle : ANE_PTR);
var
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  ParameterIndex : ANE_INT16;
  ParameterName : string;
begin
  frmProgress.lblActivity.Caption := 'Evaluating elevation of the top of Unit1';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := NROW*NCOL;

  GridLayer := TLayerOptions.Create(GridLayerHandle);
  ParameterName := ModflowTypes.GetMFGridTopElevParamType.WriteParamName + '1';
  ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);
  try
    for RowIndex := 0 to NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        BlockIndex := self.BlockIndex(RowIndex, ColIndex);
        ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
          GridLayerHandle, BlockIndex);
        try
          Elevations[ColIndex,RowIndex,0] :=
            ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex);
        finally
          ABlock.Free;
        end;

        frmProgress.pbActivity.StepIt;
      end;
    end;
  finally
    GridLayer.Free(CurrentModelHandle);
  end;
end;


Procedure TDiscretizationWriter.WriteTOP(const CurrentModelHandle : ANE_PTR);
var
  ColIndex, RowIndex : integer;
begin
  SetTOP(CurrentModelHandle);

  frmProgress.pbPackage.StepIt;
  frmProgress.lblActivity.Caption := 'writing top of layer 1';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := NROW*NCOL;

  WriteU2DRELHeader;
  for RowIndex := 0 to NROW -1 do
  begin
    Application.ProcessMessages;
    if not ContinueExport then break;

    for ColIndex := 0 to NCOL -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      Write(FFile,
        Elevations[ColIndex,RowIndex,0],
        ' ');

      frmProgress.pbActivity.StepIt;
    end;
    WriteLn(FFile);
  end;
end;

Procedure TDiscretizationWriter.WriteBottom(const CurrentModelHandle : ANE_PTR);
var
  ColIndex, RowIndex : integer;
  UnitIndex : Integer;
  ParameterIndicies : TIntegerList;
  DiscretizationIndex : integer;
  Discretization : integer;
  AValue : Single;
//  Count : integer;
begin
  ParameterIndicies := TIntegerList.Create;
  try
    SetBottom(CurrentModelHandle, ParameterIndicies);
    frmProgress.pbPackage.StepIt;

    Discretization := 0;
    for UnitIndex := 1 to NUNITS do
    begin
      Discretization := Discretization
        + frmMODFLOW.DiscretizationCount(UnitIndex);
    end;

    frmProgress.lblActivity.Caption := 'writing bottoms of layers';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := NROW*NCOL*Discretization;

    for UnitIndex := 1 to NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      Discretization := frmMODFLOW.DiscretizationCount(UnitIndex);
      for DiscretizationIndex := 1 to Discretization do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        WriteU2DRELHeader;
        for RowIndex := 0 to NROW -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;

          for ColIndex := 0 to NCOL -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

            AValue := (Elevations[ColIndex,RowIndex,UnitIndex-1]
                - DiscretizationIndex*(Thicknesses[ColIndex,RowIndex,UnitIndex-1]/Discretization));

            Write(FFile, Format('%g ', [AValue]){, ' '});

            frmProgress.pbActivity.StepIt;
          end;
          WriteLn(FFile);
        end;

      end;


    end;

  finally
    ParameterIndicies.Free;
  end;
end;

Procedure TDiscretizationWriter.SetBottom(const CurrentModelHandle : ANE_PTR;
  ParameterIndicies : TIntegerList);
var
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ADouble : ANE_DOUBLE;
  UnitIndex : Integer;
begin

  frmProgress.lblActivity.Caption := 'evaluating bottoms of geologic units';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := NROW*NCOL*NUNITS;

  GridLayer := TLayerOptions.Create(GridLayerHandle);
  try
    for UnitIndex := 1 to NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      ParameterName := ModflowTypes.GetMFGridBottomElevParamType.WriteParamName
        + IntToStr(UnitIndex);
      ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);
      ParameterIndicies.Add(ParameterIndex);
    end;

    for RowIndex := 0 to NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        BlockIndex := self.BlockIndex(RowIndex, ColIndex);
        ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
          GridLayerHandle, BlockIndex);
        try
          for UnitIndex := 1 to NUNITS do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

            ParameterIndex := ParameterIndicies[UnitIndex-1];
            ADouble := ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex);
            Elevations[ColIndex,RowIndex,UnitIndex] := ADouble;
            Thicknesses[ColIndex,RowIndex,UnitIndex-1] := Elevations[ColIndex,RowIndex,UnitIndex-1] - ADouble;

            frmProgress.pbActivity.StepIt;
          end;


        finally
          ABlock.Free;
        end;
      end;
    end;

  finally
    GridLayer.Free(CurrentModelHandle);
  end;
end;

Procedure TDiscretizationWriter.SetElevationArraySize;
begin
  NUNITS := StrToInt(frmMODFLOW.edNumUnits.Text);
  if ElevationsNeeded then
  begin
    SetLength(Elevations, NCOL, NROW, NUNITS+1);
    SetLength(Thicknesses, NCOL, NROW, NUNITS);
  end;
end;

Procedure TDiscretizationWriter.WriteModflowDiscretizationFile(const CurrentModelHandle : ANE_PTR; Root : string);
var
  FileName : String;
begin
  CheckSimulatedUnits;
  frmProgress.lblPackage.Caption := 'Discretization';
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := 8;

  FileName := GetCurrentDir + '\' + Root + rsDis;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);
    if ContinueExport then
    begin
      WriteDataReadFrom(FileName);
      SetVariables(CurrentModelHandle);

      EvaluateCornerCoordinates(CurrentModelHandle);

      WriteDataSet1;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      WriteDataSet2;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      WriteDELR(CurrentModelHandle);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      WriteDELC(CurrentModelHandle);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      SetElevationArraySize;
      // frmProgress.pbPackage.StepIt executed once within WriteTOP;
      WriteTOP(CurrentModelHandle);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      // frmProgress.pbPackage.StepIt executed once within WriteBottom;
      WriteBottom(CurrentModelHandle);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      WriteStressPeriods;
      Flush(FFile);
      Application.ProcessMessages;
    end;
  finally
    CloseFile(FFile);
  end;

end;

procedure TDiscretizationWriter.InitializeButDontWrite(
  const CurrentModelHandle: ANE_PTR);
var
  ParameterIndicies : TIntegerList;
begin
  frmProgress.lblPackage.Caption := 'Evaluating Elevations';
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := 4;

  ParameterIndicies := TIntegerList.Create;
  try
    if not ContinueExport then Exit;
    SetVariables(CurrentModelHandle);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;

    if not ContinueExport then Exit;
    EvaluateDELR(CurrentModelHandle);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;

    if not ContinueExport then Exit;
    SetTOP(CurrentModelHandle);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;

    if not ContinueExport then Exit;
    SetBottom(CurrentModelHandle, ParameterIndicies);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;

  finally
    ParameterIndicies.Free;
  end;

end;

procedure TDiscretizationWriter.SetTransient;
var
  Index : integer;
begin
  frmProgress.lblActivity.Caption := 'evaluating stress periods';
  Transient := False;
  with frmMODFLOW do
  begin
    for Index := 1 to dgTime.RowCount -1 do
    begin
      if dgTime.Cells[Ord(tdSsTr),Index] =
        dgTime.Columns[Ord(tdSsTr)].PickList[0] then
      begin
        Transient := True;
        break;
      end

    end;
  end;

end;
{procedure TDiscretizationWriter.GetPeriodAndOffset( Time : double;
  var StressPeriod: integer; var TimeOffSet: double);
const
  Epsilon = 9e-8;
var
  Index : integer;
  OldLength, NewLength : double;
begin
  OldLength := 0;
  for Index := 0 to NPER -1 do
  begin
    NewLength := OldLength + StressPeriods[Index].PERLEN;
    if NewLength > Time then
    begin
      StressPeriod := Index + 1;
      TimeOffSet := Time - OldLength;
      if TimeOffSet < 0 then
      begin
        TimeOffSet := 0;
      end;
      if TimeOffSet > StressPeriods[Index].PERLEN*(1-Epsilon) then
      begin
        TimeOffSet := StressPeriods[Index].PERLEN*(1-Epsilon) ;
      end;
      Exit;
    end;
    OldLength := NewLength;
  end;
  StressPeriod := NPER;
  TimeOffSet := StressPeriods[NPER-1].PERLEN*(1-Epsilon);
end;    }

procedure TDiscretizationWriter.WriteStressPeriods;
var
  SsTr : String;
  Index : integer;
  StressPeriod : TStressPeriodRecord;
begin
  EvaluateStressPeriods;
  frmProgress.lblActivity.Caption := 'writing stress periods';
  with frmMODFLOW do
  begin
    for Index := 0 to NPER -1 do
    begin
      StressPeriod := StressPeriods[Index];
      if StressPeriod.Transient then
      begin
        SsTr := 'TR';
      end
      else
      begin
        SsTr := 'SS';
      end;
      WriteLn(FFile, FreeFormattedReal(StressPeriod.PERLEN),
                     StressPeriod.NSTP, ' ',
                     FreeFormattedReal(StressPeriod.TSMULT),
                     SsTr);

    end;
  end;

end;

{ TModflowWriter }

class function TModflowWriter.IPRN_Integer: integer;
begin
  if frmModflow.cbPrintArrays.Checked then
  begin
    result := 5;
  end
  else
  begin
    result := -1;
  end;
end;

procedure TModflowWriter.WriteU2DINTHeader(const Comment: string = '');
begin
  Writeln(FFile, 'INTERNAL 1 (FREE)    ', IPRN_Integer, ' ', Comment);
end;

class function TModflowWriter.IPRN_Real: integer;
begin
  if frmModflow.cbPrintArrays.Checked then
  begin
    result := 12;
  end
  else
  begin
    result := -1;
  end;
end;

procedure TModflowWriter.WriteU2DRELHeader(const Comment: string = '');
begin
  Writeln(FFile, 'INTERNAL 1.0 (FREE)   ', IPRN_Real, ' ', Comment);
end;

procedure TModflowWriter.SetUnitDoubleArray(const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; SetArray : TSetArrayMember;
  ParameterRoot : String; BasicPkg : TBasicPkgWriter);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
begin
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW
    * Discretization.NCOL * Discretization.NUNITS;

  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      if frmMODFLOW.Simulated(UnitIndex) then
      begin
        ParameterName := ParameterRoot + IntToStr(UnitIndex);
        ParameterIndex := GridLayer.GetParameterIndex(
          CurrentModelHandle,ParameterName);

        for RowIndex := 0 to Discretization.NROW -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;

          for ColIndex := 0 to Discretization.NCOL -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

            if BasicPkg.IBOUND[ColIndex,RowIndex,UnitIndex-1] = 0 then
            begin
              SetArray(ColIndex, RowIndex, UnitIndex-1, 0);
            end
            else
            begin
              BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
              ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                Discretization.GridLayerHandle, BlockIndex);
              try
                SetArray(ColIndex, RowIndex, UnitIndex-1,
                 ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex));
              finally
                ABlock.Free;
              end;
            end;

            frmProgress.pbActivity.StepIt;
          end;
        end;
      end;
    end;

  finally
    GridLayer.Free(CurrentModelHandle);
  end;
end;


function TDiscretizationWriter.BlockIndex(RowIndex,
  ColIndex: integer): integer;
var
  ErrorString : string;
begin
  if not ((ColIndex >= 0) and (ColIndex < NCOL) and (RowIndex >= 0)
    and (RowIndex < NROW)) then
  begin
    ErrorString := 'Illegal row or column number in '
      + 'TDiscretizationWriter.BlockIndex.';
    raise Exception.Create(ErrorString);
  end;
  if ColsReversed then
  begin
    ColIndex := NCOL - ColIndex -1;
  end;
  if RowsReversed then
  begin
    RowIndex := NROW - RowIndex -1;
  end;
  result := RowIndex* NCOL + ColIndex;
end;

procedure TModflowWriter.WriteDataReadFrom(FileName: string);

begin
  WriteComment('Data read from ' + FileName);
  WriteComment('File generated on ' + DateTimeToStr(Now));
end;

procedure TModflowWriter.WriteComment(Comment: string);
begin
  WriteLn(FFile, '# ', Comment);
end;

class function TModflowWriter.FreeFormattedReal(const Value: double): string;
begin
  result := FortranDecimal(Format('%.13e ', [Value]));
end;

class function TModflowWriter.FixedFormattedReal(const Value: double;
  const Width: integer): string;
var
  Index : integer;
  PadIndex : integer;
begin
  for Index := Width downto 1 do
  begin
    result := Format(' %.*g', [Index, Value]);
    if Length(result) <= Width then
    begin
      for PadIndex := 0 to Width - Length(result) -1 do
      begin
        result := ' ' + result;
      end;
      break;
    end;
  end;
  result := FortranDecimal(result);
end;

class function TModflowWriter.FixedFormattedInteger(const Value: Integer;
  const Width: integer): string;
var
  Index : integer;
  PadIndex : integer;
begin
  for Index := Width downto 1 do
  begin
    result := Format(' %.*d', [Index, Value]);
    if Value < 0 then
    begin
      while (Length(result) > 3) and (result[3] = '0') do
      begin
        Delete(result, 3, 1);
      end;
    end
    else
    begin
      while (Length(result) > 2) and (result[2] = '0') do
      begin
        Delete(result, 2, 1);
      end;
    end;


    if Length(result) <= Width then
    begin
      for PadIndex := 0 to Width - Length(result) -1 do
      begin
        result := ' ' + result;
      end;
      break;
    end;
  end;
//  result := FortranDecimal(result);
end;

class function TModflowWriter.FortranDecimal(NumberString: string): string;
var
  Position : integer;
begin
  result := NumberString;
  if DecimalSeparator <> '.' then
  begin
    Position := Pos(DecimalSeparator,result);
    While Position > 0 do
    begin
      result[Position] := '.';
      Position := Pos(DecimalSeparator,result);
    end;
  end;
end;

procedure TModflowWriter.GetLayers(
  const UnitIndex: integer; var ModflowLayers: TLayerArray);
var
  LayerAbove, LayersPerUnit: integer;
  LayerIndex: integer;
begin
  LayerAbove    := frmModflow.MODFLOWLayersAboveCount(UnitIndex);
  LayersPerUnit := frmMODFLOW.DiscretizationCount(UnitIndex);
  SetLength(ModflowLayers, LayersPerUnit);
  for LayerIndex := 1 to LayersPerUnit do
  begin
    ModflowLayers[LayerIndex - 1] := LayerIndex + LayerAbove;
  end;
end;



{ TBasicPkgWriter }


procedure TBasicPkgWriter.InitializeButDontWrite(
  const CurrentModelHandle: ANE_PTR; Discretization : TDiscretizationWriter);
begin
  frmProgress.lblPackage.Caption := 'Basic';
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := 1;
  SetIboundArraySize(Discretization);
  SetIboundArray(CurrentModelHandle, Discretization);
  frmProgress.pbPackage.StepIt;
end;

procedure TBasicPkgWriter.SetArraySizes(Discretization : TDiscretizationWriter);
begin
  SetIboundArraySize(Discretization);
  with Discretization do
  begin
    SetLength(STRT, NCOL, NROW, NUNITS);
  end;
end;

procedure TBasicPkgWriter.SetIboundArray(CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
var
  ParameterIndex, ConcentrationIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
  AValue : integer;
  LayersPerUnit : array of integer;
  LayerIndex : integer;
  MFLayer : integer;
  Concentration : double;
  LayerCount: integer;
begin
  LayerCount := 0;
  for UnitIndex := 1 to Discretization.NUNITS do
  begin
    if frmMODFLOW.Simulated(UnitIndex) then
    begin
      LayerCount := LayerCount + frmModflow.DiscretizationCount(UnitIndex);
    end;
  end;

  frmProgress.lblActivity.Caption := 'evaluating IBOUND arrays';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
    * (Discretization.NLAY+LayerCount+1);
  Application.ProcessMessages;

  for RowIndex := 0 to Discretization.NROW -1 do
  begin
    for ColIndex := 0 to Discretization.NCOL -1 do
    begin
      CellUsed[ColIndex,RowIndex] := False;
      frmProgress.pbActivity.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then Exit;
    end;
  end;

  ConcentrationIndex := -1;
  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      if frmMODFLOW.Simulated(UnitIndex) then
      begin
        ParameterName := ModflowTypes.GetMFIBoundGridParamType.WriteParamName
          + IntToStr(UnitIndex);
        ParameterIndex := GridLayer.GetParameterIndex
          (CurrentModelHandle,ParameterName);
        if frmModflow.cbMOC3D.Checked then
        begin
          ParameterName := ModflowTypes.GetMFGridMOCPrescribedConcParamType.
            WriteParamName + IntToStr(UnitIndex);
          ConcentrationIndex := GridLayer.GetParameterIndex
            (CurrentModelHandle,ParameterName);
        end;

        for RowIndex := 0 to Discretization.NROW -1 do
        begin
          for ColIndex := 0 to Discretization.NCOL -1 do
          begin
            BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
            ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
              Discretization.GridLayerHandle, BlockIndex);
            try
              AValue := ABlock.GetIntegerParameter
                (CurrentModelHandle, ParameterIndex);
              IBOUND[ColIndex, RowIndex, UnitIndex-1] := AValue;
              CellUsed[ColIndex, RowIndex] := (AValue<>0) or
                CellUsed[ColIndex, RowIndex];
              if (AValue < 0) and frmModflow.cbMOC3D.Checked then
              begin
                Concentration := ABlock.GetFloatParameter
                  (CurrentModelHandle,ConcentrationIndex);
                AValue := Moc3DConcentrations.IndexOf(Concentration);
                if AValue = -1 then
                begin
                  AValue := Moc3DConcentrations.Add(Concentration);
                end;
                IBOUND[ColIndex, RowIndex, UnitIndex-1] := -(AValue+1);
              end;
            finally
              ABlock.Free;
            end;
            frmProgress.pbActivity.StepIt;
            Application.ProcessMessages;
            if not ContinueExport then Exit;
          end;
        end;
      end;
    end;

  finally
    GridLayer.Free(CurrentModelHandle);
  end;

  SetLength(LayersPerUnit, Discretization.NUNITS);
  for UnitIndex := 0 to Discretization.NUNITS-1 do
  begin
    LayersPerUnit[UnitIndex] := frmModflow.DiscretizationCount(UnitIndex+1);
  end;

  MFLayer := -1;
  for UnitIndex := 0 to Discretization.NUNITS-1 do
  begin
    if frmMODFLOW.Simulated(UnitIndex+1) then
    begin
      for LayerIndex := 0 to LayersPerUnit[UnitIndex]-1 do
      begin
        Inc(MFLayer);
        for RowIndex := 0 to Discretization.NROW -1 do
        begin
          for ColIndex := 0 to Discretization.NCOL -1 do
          begin
            MFIBOUND[ColIndex,RowIndex,MFLayer]
              := IBOUND[ColIndex,RowIndex,UnitIndex];
            frmProgress.pbActivity.StepIt;
            Application.ProcessMessages;
            if not ContinueExport then Exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure TBasicPkgWriter.SetIboundArraySize(
  Discretization: TDiscretizationWriter);
begin
  with Discretization do
  begin
    SetLength(IBOUND, NCOL, NROW, NUNITS);
    SetLength(CellUsed, NCOL, NROW);
    SetLength(MFIBOUND, NCOL, NROW, NLAY);
    if frmModflow.cbBFLX.Checked then
    begin
      SetLength(IFACE, NCOL, NROW, NLAY);
    end;
    if frmModflow.cbMOC3D.Checked then
    begin
      Moc3DConcentrations.Clear;
    end;
  end;
end;

procedure TBasicPkgWriter.SetStrt(Col, Row, UnitIndex: integer;
  Value: double);
begin
  STRT[Col, Row, UnitIndex] := Value;
end;

procedure TBasicPkgWriter.UpdateMFIBOUND(Discretization: TDiscretizationWriter);
var
  MFLayer: integer;
  UnitTop, UnitBottom: Double;
  LayersPerUnit: integer;
  UnitIndex, LayerIndex, RowIndex, ColIndex: integer;
  Bottom: double;
begin
  MFLayer := -1;
  for UnitIndex := 0 to Discretization.NUNITS-1 do
  begin
    if frmMODFLOW.Simulated(UnitIndex+1) then
    begin
      LayersPerUnit := frmModflow.DiscretizationCount(UnitIndex+1);
      for LayerIndex := 0 to LayersPerUnit-1 do
      begin
        Inc(MFLayer);
        for RowIndex := 0 to Discretization.NROW -1 do
        begin
          for ColIndex := 0 to Discretization.NCOL -1 do
          begin
            if MFIBOUND[ColIndex,RowIndex,MFLayer] < 0 then
            begin
              UnitBottom := Discretization.Elevations[ColIndex, RowIndex, UnitIndex+1];
              if LayersPerUnit = 1 then
              begin
                Bottom := UnitBottom;
              end
              else
              begin
                UnitTop := Discretization.Elevations[ColIndex, RowIndex, UnitIndex];
                Bottom := UnitTop - (UnitTop-UnitBottom)/LayersPerUnit*(LayerIndex+1);
              end;
              if STRT[ColIndex, RowIndex, UnitIndex] <= Bottom then
              begin
                MFIBOUND[ColIndex,RowIndex,MFLayer] := 0;
              end;
            end;
            frmProgress.pbActivity.StepIt;
            Application.ProcessMessages;
            if not ContinueExport then Exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure TBasicPkgWriter.SetStrtArray(CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
begin
  frmProgress.lblActivity.Caption := 'evaluating starting heads';
  frmProgress.pbActivity.Position := 0;
  Application.ProcessMessages;

  SetUnitDoubleArray(CurrentModelHandle, Discretization,
    SetStrt, ModflowTypes.GetMFGridInitialHeadParamType.WriteParamName, self);
end;

procedure TBasicPkgWriter.InitializeAll(
  const CurrentModelHandle: ANE_PTR; Discretization: TDiscretizationWriter);
{var
  FileName : String; }
begin
  frmProgress.lblPackage.Caption := 'Basic';
  frmProgress.pbPackage.Position := 0;
  if frmModflow.cbDeactivateIbound.Checked then
  begin
    frmProgress.pbPackage.Max := 3;
  end
  else
  begin
    frmProgress.pbPackage.Max := 2;
  end;

  SetArraySizes(Discretization);

  if ContinueExport then
  begin
    SetIboundArray(CurrentModelHandle, Discretization);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;

  if ContinueExport then
  begin
    SetStrtArray(CurrentModelHandle, Discretization);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;

  if ContinueExport and frmModflow.cbDeactivateIbound.Checked then
  begin
    UpdateMFIBOUND(Discretization);
    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;
  end;
end;
procedure TBasicPkgWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter);
var
  FileName : String;
begin
  frmProgress.lblPackage.Caption := 'Basic';
  frmProgress.pbPackage.Position := 0;
  If ShowWarnings then
  begin
    frmProgress.pbPackage.Max := 3;
  end
  else
  begin
    frmProgress.pbPackage.Max := 2;
  end;

  FileName := GetCurrentDir + '\' + Root + rsBAS;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);

    WriteComment(frmModflow.adeTitle1.Text);
    WriteComment(frmModflow.adeTitle2.Text);
    WriteDataReadFrom(FileName);
    WriteOptions;
//    SetArraySizes(Discretization);

{    if ContinueExport then
    begin
      SetIboundArray(CurrentModelHandle, Discretization);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;   }

    if ContinueExport then
    begin
      WriteIboundArray(CurrentModelHandle, Discretization);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;

    if ContinueExport then
    begin
      WriteHnoflo;
    end;

{    if ContinueExport then
    begin
      SetStrtArray(CurrentModelHandle, Discretization);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;   }

    if ContinueExport then
    begin
      WriteStrtArray(CurrentModelHandle, Discretization);
      frmProgress.pbPackage.StepIt;
      Flush(FFile);
      Application.ProcessMessages;
    end;

    if ContinueExport and ShowWarnings and ElevationsNeeded then
    begin
      CheckStartingHeads(Discretization);
      frmProgress.pbPackage.StepIt;
      Application.ProcessMessages;
    end;
  finally
    CloseFile(FFile);
  end;
end;

procedure TBasicPkgWriter.WriteHnoflo;
begin
  Writeln(FFile, InternationalStrToFloat(frmMODFLOW.adeHNOFLO.Text));
end;

procedure TBasicPkgWriter.WriteIboundArray(CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
var
  ColIndex, RowIndex : integer;
//  DiscretizationIndex : integer;
  UnitIndex : integer;
begin
  frmProgress.lblActivity.Caption := 'writing IBOUND arrays';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
    * Discretization.NLAY;
  Application.ProcessMessages;


//  for UnitIndex := 1 to Discretization.NUNITS do
  for UnitIndex := 0 to Discretization.NLAY-1 do
  begin
    Application.ProcessMessages;
    if not ContinueExport then break;

//    if frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
//      frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1] then
//    begin
//      for DiscretizationIndex := 1
//        to StrToInt(frmMODFLOW.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]) do
//      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        WriteU2DINTHeader;
        for RowIndex := 0 to Discretization.NROW -1 do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;

          for ColIndex := 0 to Discretization.NCOL -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

//            Write(FFile, IBOUND[ColIndex, RowIndex, UnitIndex-1], ' ');
            Write(FFile, MFIBOUND[ColIndex, RowIndex, UnitIndex], ' ');

            frmProgress.pbActivity.StepIt;
          end;
          WriteLn(FFile);
        end;
//      end;

//    end;
  end;
end;

procedure TBasicPkgWriter.WriteOptions;
begin
  Write(FFile, 'FREE');
  if frmModflow.cbCHTOCH.Checked then
  begin
    Write(FFile, ', CHTOCH');
  end;
  if frmModflow.cbShowProgress.Checked then
  begin
    Write(FFile, ', SHOWPROGRESS');
  end;
  if frmModflow.cbPrintTime.Checked then
  begin
    Write(FFile, ', PRINTTIME');
  end;

  Writeln(FFile);
end;

procedure TBasicPkgWriter.WriteStrtArray(CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
var
  UnitIndex : integer;
  DiscretizationIndex : integer;
  ColIndex, RowIndex : integer;
  UnitNumber : integer;
  StressPeriod: Integer;
  TimeStep: Integer;
  InitialHeadFileName: string;
  ErrorMessage: string;
  AFileStream: TFileStream;
  APrecision: TModflowPrecision;
  KSTP: Integer;
  KPER: Integer;
  PERTIM: TModflowDouble;
  TOTIM: TModflowDouble;
  DESC: TModflowDesc;
  NCOL: Integer;
  NROW: Integer;
  ILAY: Integer;
  AnArray: TModflowDoubleArray;
  LayerIndex: Integer;
begin
  if UseInitialHeads then
  begin
    UnitNumber := frmModflow.GetUnitNumber('InitialHeads');
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      if frmMODFLOW.Simulated(UnitIndex) then
      begin
        for DiscretizationIndex := 1
          to frmMODFLOW.DiscretizationCount(UnitIndex) do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;
          Writeln(FFile, 'EXTERNAL ', UnitNumber, ' 1. (BINARY) 2');
        end;
      end;
    end;
  end
  else if frmModflow.cbInitial.Checked
    and (frmModflow.comboBinaryInitialHeadChoice.ItemIndex = 1) then
  begin
    frmProgress.lblActivity.Caption := 'writing starting heads';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
      * Discretization.NLAY;
    Application.ProcessMessages;

    InitialHeadFileName := GetCurrentDir + '\' + frmModflow.edInitial.Text;
    if not FileExists(InitialHeadFileName) then
    begin
      ErrorMessage := 'Error: the file "' + InitialHeadFileName
        + '", the file used for specifying initial heads, does not exist.';
      frmProgress.reErrors.Lines.Add(ErrorMessage);
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);
      Exit;
    end;

    StressPeriod := StrToInt(frmModflow.adeModflowBinaryStressPeriod.Text);
    TimeStep := StrToInt(frmModflow.adeModflowBinaryTimeStepChoice.Text);
    KPER := -1;
    KSTP := -1;
    AFileStream := TFileStream.Create(InitialHeadFileName, fmOpenRead or fmShareCompat);
    try
      APrecision := CheckArrayPrecision(AFileStream);
      While AFileStream.Position < AFileStream.Size do
      begin
        case APrecision of
          mpSingle:
            begin
              ReadSinglePrecisionModflowBinaryRealArray(AFileStream, KSTP,
                KPER, PERTIM, TOTIM, DESC, NCOL, NROW, ILAY, AnArray);
            end;
          mpDouble:
            begin
              ReadDoublePrecisionModflowBinaryRealArray(AFileStream, KSTP,
                KPER, PERTIM, TOTIM, DESC, NCOL, NROW, ILAY, AnArray);
            end;
          else Assert(False);
        end;
        if (StressPeriod = KPER) and (KSTP = TimeStep) then
        begin
          break;
        end;
      end;

      if (StressPeriod <> KPER) or (KSTP <> TimeStep) then
      begin
        ErrorMessage := 'Error: the specified stress period and time step '
          + 'were not found in the file "' + InitialHeadFileName
          + '".';
        frmProgress.reErrors.Lines.Add(ErrorMessage);
        ErrorMessages.Add('');
        ErrorMessages.Add(ErrorMessage);
        Exit;
      end;

      LayerIndex := 0;
      for UnitIndex := 1 to Discretization.NUNITS do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        if frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
          frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1] then
        begin
          for DiscretizationIndex := 1
            to StrToInt(frmMODFLOW.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]) do
          begin
            Inc(LayerIndex);
            if LayerIndex <> ILAY then
            begin
              ErrorMessage := 'Error: Data for layer ' + IntToStr(LayerIndex)
                + ' in the specified stress period and time step '
                + 'were not found in the file "' + InitialHeadFileName
                + '".';
              frmProgress.reErrors.Lines.Add(ErrorMessage);
              ErrorMessages.Add('');
              ErrorMessages.Add(ErrorMessage);
              Exit;
            end;

            if (Discretization.NROW <> NROW) or (Discretization.NCOL <> NCOL) then
            begin
              ErrorMessage := 'Error: The number of rows or columns '
                + 'in the file "' + InitialHeadFileName
                + '" do not match the number in the model.';
              frmProgress.reErrors.Lines.Add(ErrorMessage);
              ErrorMessages.Add('');
              ErrorMessages.Add(ErrorMessage);
              Exit;
            end;

            Application.ProcessMessages;
            if not ContinueExport then break;

            WriteU2DRELHeader;
            for RowIndex := 0 to Discretization.NROW -1 do
            begin
              Application.ProcessMessages;
              if not ContinueExport then break;

              for ColIndex := 0 to Discretization.NCOL -1 do
              begin
                Application.ProcessMessages;
                if not ContinueExport then break;

                Write(FFile, AnArray[RowIndex, ColIndex], ' ');

                frmProgress.pbActivity.StepIt;
              end;
              WriteLn(FFile);
            end;

            if AFileStream.Position < AFileStream.Size then
            begin
              case APrecision of
                mpSingle:
                  begin
                    ReadSinglePrecisionModflowBinaryRealArray(AFileStream, KSTP,
                      KPER, PERTIM, TOTIM, DESC, NCOL, NROW, ILAY, AnArray);
                  end;
                mpDouble:
                  begin
                    ReadDoublePrecisionModflowBinaryRealArray(AFileStream, KSTP,
                      KPER, PERTIM, TOTIM, DESC, NCOL, NROW, ILAY, AnArray);
                  end;
                else Assert(False);
              end;
            end;
          end;
        end;
      end
    finally
      AFileStream.Free;
    end;
  end
  else     
  begin
    frmProgress.lblActivity.Caption := 'writing starting heads';
    frmProgress.pbActivity.Position := 0;
    frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
      * Discretization.NLAY;
    Application.ProcessMessages;

    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      if frmMODFLOW.dgGeol.Cells[Ord(nuiSim),UnitIndex] =
        frmMODFLOW.dgGeol.Columns[Ord(nuiSim)].PickList[1] then
      begin
        for DiscretizationIndex := 1
          to StrToInt(frmMODFLOW.dgGeol.Cells[Ord(nuiVertDisc),UnitIndex]) do
        begin
          Application.ProcessMessages;
          if not ContinueExport then break;

          WriteU2DRELHeader;
          for RowIndex := 0 to Discretization.NROW -1 do
          begin
            Application.ProcessMessages;
            if not ContinueExport then break;

            for ColIndex := 0 to Discretization.NCOL -1 do
            begin
              Application.ProcessMessages;
              if not ContinueExport then break;

              Write(FFile, STRT[ColIndex, RowIndex, UnitIndex-1], ' ');

              frmProgress.pbActivity.StepIt;
            end;
            WriteLn(FFile);
          end;
        end;
      end;
    end;
  end;
end;

procedure TBasicPkgWriter.CheckStartingHeads(
  Discretization: TDiscretizationWriter);
var
  UnitIndex, ColIndex, RowIndex : integer;
  ErrorStringList : TStringList;
  AString : string;
begin
  if ShowWarnings then
  begin
    ErrorStringList := TStringList.Create;
    try
      frmProgress.lblActivity.Caption := 'checking starting heads';
      frmProgress.pbActivity.Position := 0;
      With Discretization do
      begin
        frmProgress.pbActivity.Max := NROW * NCOL * NUNITS;
        for UnitIndex := 0 to NUNITS -1 do
        begin
          for ColIndex := 0 to NCOL -1 do
          begin
            for RowIndex := 0 to NROW -1 do
            begin
              if (IBOUND[ColIndex, RowIndex, UnitIndex] <> 0) and
                (STRT[ColIndex, RowIndex, UnitIndex]
                < Elevations[ColIndex, RowIndex, UnitIndex+1]) then
              begin
                ErrorStringList.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
              end;
              frmProgress.pbActivity.StepIt;
              Application.ProcessMessages;
              If not ContinueExport then Exit;
            end;
          end;
          if ErrorStringList.Count > 0 then
          begin
            AString := 'Warning: Initial head < bottom elevation in Unit '
               + IntToStr(UnitIndex + 1) + '.';
            frmProgress.reErrors.Lines.Add(AString);
            AString := AString + ' [Col,Row]';
            ErrorMessages.Add('');
            ErrorMessages.Add(AString);
            ErrorMessages.AddStrings(ErrorStringList);
          end;
          ErrorStringList.Clear;
        end;
      end;
    finally
      ErrorStringList.Free;
    end;

  end;
end;

constructor TBasicPkgWriter.Create;
begin
  inherited;
  Moc3DConcentrations := TRealList.Create;
  MT3DCellList := TMT3DCellList.Create;
end;

destructor TBasicPkgWriter.Destroy;
begin
  Moc3DConcentrations.Free;
  MT3DCellList.Free;
  inherited;

end;

procedure TBasicPkgWriter.SetMT3DConcentrations(
  CurrentModelHandle: ANE_PTR; Discretization: TDiscretizationWriter);
var
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
  PrescribedHeadLayer : TLayerOptions;
  UnitIndex : integer;
  MFLayer : integer;
  MT3DSpeciesIndicies : array of array of ANE_INT32; // [Stressperiod, Species]
  MT3DSpeciesNames : array of array of string; // [Stressperiod, Species]
  StressPeriodCount, SpeciesCount: integer;
  StressPeriodIndex, SpeciesIndex : integer;
  LayerName : string;
  CellRecord : TMT3DCellRecord;
  X, Y : ANE_DOUBLE;
  Expression : string;
  MFLayerIndex : integer;
  Contour : TContourObjectOptions;
  ContourIndex : integer;
  Cell : TMT3DCell;
  ContourCount : integer;
  CellIndex : integer;
  Index1, Index2 : integer;
begin
  frmProgress.lblActivity.Caption := 'evaluating MT3D Concentration arrays';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL
    * (Discretization.NLAY+1);
  Application.ProcessMessages;

  StressPeriodCount := frmModflow.dgTime.RowCount -1;
  SpeciesCount := StrToInt(frmModflow.adeMT3DNCOMP.Text);
  SetLength(MT3DSpeciesIndicies,StressPeriodCount, SpeciesCount);
  SetLength(MT3DSpeciesNames,StressPeriodCount, SpeciesCount);
  SetLength(CellRecord.MT3DConcentrations,StressPeriodCount, SpeciesCount);

  for StressPeriodIndex := 1 to StressPeriodCount do
  begin
    for SpeciesIndex := 1 to SpeciesCount do
    begin
      case SpeciesIndex of
        1:
          begin
            ParameterName := ModflowTypes.GetMT3DConcentrationParamClassType.ANE_ParamName;
          end;
        2:
          begin
            ParameterName := ModflowTypes.GetMT3DConc2ParamClassType.ANE_ParamName;
          end;
        3:
          begin
            ParameterName := ModflowTypes.GetMT3DConc3ParamClassType.ANE_ParamName;
          end;
        4:
          begin
            ParameterName := ModflowTypes.GetMT3DConc4ParamClassType.ANE_ParamName;
          end;
        5:
          begin
            ParameterName := ModflowTypes.GetMT3DConc5ParamClassType.ANE_ParamName;
          end;
      else Assert(False);
      end;
      ParameterName := ParameterName + IntToStr(StressPeriodIndex);
      MT3DSpeciesNames[StressPeriodIndex-1,SpeciesIndex-1] := ParameterName;
    end;
  end;



  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    MFLayer := 0;
    for UnitIndex := 1 to Discretization.NUNITS do
    begin
      if frmMODFLOW.Simulated(UnitIndex) then
      begin
        LayerName := ModflowTypes.GetPrescribedHeadLayerType.ANE_LayerName
          + IntToStr(UnitIndex);
        PrescribedHeadLayer := TLayerOptions.CreateWithName(LayerName, CurrentModelHandle);
        try
          for StressPeriodIndex := 0 to StressPeriodCount -1 do
          begin
            for SpeciesIndex := 0 to SpeciesCount -1 do
            begin
              ParameterName := MT3DSpeciesNames[StressPeriodIndex,SpeciesIndex];
              MT3DSpeciesIndicies[StressPeriodIndex,SpeciesIndex] :=
                PrescribedHeadLayer.GetParameterIndex(CurrentModelHandle,ParameterName);
              Assert(MT3DSpeciesIndicies[StressPeriodIndex,SpeciesIndex] >= 0);
            end;
          end;

          for RowIndex := 0 to Discretization.NROW -1 do
          begin
            for ColIndex := 0 to Discretization.NCOL -1 do
            begin
                if IBOUND[ColIndex, RowIndex, UnitIndex-1] < 0 then
                begin
                  CellRecord.Column := ColIndex+1;
                  CellRecord.Row := RowIndex+1;
                  BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
                  ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
                    Discretization.GridLayerHandle, BlockIndex);
                  try
                    ABlock.GetCenter(CurrentModelHandle, X, Y);
                  finally
                    ABlock.Free;
                  end;
                  for StressPeriodIndex := 0 to StressPeriodCount -1 do
                  begin
                    for SpeciesIndex := 0 to SpeciesCount -1 do
                    begin
                      ParameterName := MT3DSpeciesNames[StressPeriodIndex,SpeciesIndex];
                      Expression := LayerName + '.' + ParameterName;

                      CellRecord.MT3DConcentrations[StressPeriodIndex,SpeciesIndex]
                        := GridLayer.RealValueAtXY(CurrentModelHandle, X, Y, Expression);

                    end;
                  end;
                  for MFLayerIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
                  begin
                    CellRecord.Layer := MFLayer + MFLayerIndex;
                    if MFIBOUND[ColIndex, RowIndex, CellRecord.Layer-1] < 0 then
                    begin
                      MT3DCellList.Add(CellRecord);
                    end;
                  end;

                end;
              frmProgress.pbActivity.StepIt;
            end;
          end;

          AddVertexLayer(CurrentModelHandle, LayerName);
          ContourCount := PrescribedHeadLayer.NumObjects(CurrentModelHandle,pieContourObject);
          if ContourCount > 0 then
          begin
            // closed contours
            for ContourIndex := 0 to ContourCount-1 do
            begin
              frmProgress.pbActivity.StepIt;
              if not ContinueExport then break;
              Application.ProcessMessages;
              Contour := TContourObjectOptions.Create
                (CurrentModelHandle,PrescribedHeadLayer.LayerHandle,ContourIndex);
              try
                if Contour.ContourType(CurrentModelHandle) = ctClosed then
                begin
                  for StressPeriodIndex := 0 to StressPeriodCount -1 do
                  begin
                    for SpeciesIndex := 0 to SpeciesCount -1 do
                    begin
                      CellRecord.MT3DConcentrations[StressPeriodIndex,SpeciesIndex]
                        := Contour.GetFloatParameter(CurrentModelHandle,
                        MT3DSpeciesIndicies[StressPeriodIndex,SpeciesIndex]);
                    end;
                  end;

                  for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    CellRecord.Row := GGetCellRow(ContourIndex, CellIndex);
                    CellRecord.Column := GGetCellColumn(ContourIndex, CellIndex);
                    for MFLayerIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
                    begin
                      CellRecord.Layer := MFLayer + MFLayerIndex;
                      Cell := MT3DCellList.GetCellByLocation(CellRecord.Layer, CellRecord.Row, CellRecord.Column);
                      if Cell <> nil then
                      begin
                        Copy2DDoubleArray(CellRecord.MT3DConcentrations,
                          Cell.Cell.MT3DConcentrations);
{                        for Index1 := 0 to Length(CellRecord.MT3DConcentrations)-1 do
                        begin
                          for Index2 := 0 to Length(CellRecord.MT3DConcentrations[0])-1 do
                          begin
                            Cell.Cell.MT3DConcentrations[Index1,Index2]
                              := CellRecord.MT3DConcentrations[Index1,Index2];
                          end;
                        end;   }
                      end;
                    end;
                  end;
                end;
              finally
                Contour.Free;
              end;
            end;
            // open contours
            for ContourIndex := 0 to ContourCount-1 do
            begin
              frmProgress.pbActivity.StepIt;
              if not ContinueExport then break;
              Application.ProcessMessages;
              Contour := TContourObjectOptions.Create
                (CurrentModelHandle,PrescribedHeadLayer.LayerHandle,ContourIndex);
              try
                if Contour.ContourType(CurrentModelHandle) = ctOpen then
                begin
                  for StressPeriodIndex := 0 to StressPeriodCount -1 do
                  begin
                    for SpeciesIndex := 0 to SpeciesCount -1 do
                    begin
                      CellRecord.MT3DConcentrations[StressPeriodIndex,SpeciesIndex]
                        := Contour.GetFloatParameter(CurrentModelHandle,
                        MT3DSpeciesIndicies[StressPeriodIndex,SpeciesIndex]);
                    end;
                  end;

                  for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    CellRecord.Row := GGetCellRow(ContourIndex, CellIndex);
                    CellRecord.Column := GGetCellColumn(ContourIndex, CellIndex);
                    for MFLayerIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
                    begin
                      CellRecord.Layer := MFLayer + MFLayerIndex;
                      Cell := MT3DCellList.GetCellByLocation(CellRecord.Layer, CellRecord.Row, CellRecord.Column);
                      if Cell <> nil then
                      begin
                        Copy2DDoubleArray(CellRecord.MT3DConcentrations,
                          Cell.Cell.MT3DConcentrations);
{                        for Index1 := 0 to Length(CellRecord.MT3DConcentrations)-1 do
                        begin
                          for Index2 := 0 to Length(CellRecord.MT3DConcentrations[0])-1 do
                          begin
                            Cell.Cell.MT3DConcentrations[Index1,Index2]
                              := CellRecord.MT3DConcentrations[Index1,Index2];
                          end;
                        end; }
                      end;
                    end;
                  end;

                end;
              finally
                Contour.Free;
              end;
            end;
            // point contours
            for ContourIndex := 0 to ContourCount-1 do
            begin
              frmProgress.pbActivity.StepIt;
              if not ContinueExport then break;
              Application.ProcessMessages;
              Contour := TContourObjectOptions.Create
                (CurrentModelHandle,PrescribedHeadLayer.LayerHandle,ContourIndex);
              try
                if Contour.ContourType(CurrentModelHandle) = ctPoint then
                begin
                  for StressPeriodIndex := 0 to StressPeriodCount -1 do
                  begin
                    for SpeciesIndex := 0 to SpeciesCount -1 do
                    begin
                      CellRecord.MT3DConcentrations[StressPeriodIndex,SpeciesIndex]
                        := Contour.GetFloatParameter(CurrentModelHandle,
                        MT3DSpeciesIndicies[StressPeriodIndex,SpeciesIndex]);
                    end;
                  end;

                  for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
                  begin
                    if not ContinueExport then break;
                    Application.ProcessMessages;
                    CellRecord.Row := GGetCellRow(ContourIndex, CellIndex);
                    CellRecord.Column := GGetCellColumn(ContourIndex, CellIndex);
                    for MFLayerIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
                    begin
                      CellRecord.Layer := MFLayer + MFLayerIndex;
                      Cell := MT3DCellList.GetCellByLocation(CellRecord.Layer, CellRecord.Row, CellRecord.Column);
                      if Cell <> nil then
                      begin
                        Copy2DDoubleArray(CellRecord.MT3DConcentrations,
                          Cell.Cell.MT3DConcentrations);
{                        for Index1 := 0 to Length(CellRecord.MT3DConcentrations)-1 do
                        begin
                          for Index2 := 0 to Length(CellRecord.MT3DConcentrations[0])-1 do
                          begin
                            Cell.Cell.MT3DConcentrations[Index1,Index2]
                              := CellRecord.MT3DConcentrations[Index1,Index2];
                          end;
                        end; }
                      end;
                    end;
                  end;

                end;
              finally
                Contour.Free;
              end;
            end;
          end;


          MFLayer := MFLayer + frmMODFLOW.DiscretizationCount(UnitIndex);
        finally
          PrescribedHeadLayer.Free(CurrentModelHandle);
        end;

      end;
    end;
  finally
    GridLayer.Free(CurrentModelHandle);
  end;

end;

procedure TBasicPkgWriter.InitializeMT3DConcentrations(
  const CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter);
begin
  InitializeButDontWrite(CurrentModelHandle, Discretization);
  SetMT3DConcentrations(CurrentModelHandle, Discretization);
end;

procedure TBasicPkgWriter.WriteMT3DConcentrations(
  const StressPeriod: integer; const Lines: TStrings);
var
  Index : integer;
  Cell : TMT3DCell;
begin
  for Index := 0 to MT3DCellList.Count -1 do
  begin
    Cell := MT3DCellList[Index] as TMT3DCell;
    Cell.WriteMT3DConcentrations(StressPeriod, Lines);
  end;
end;

{ TListWriter }

procedure TListWriter.AddVertexLayer(const CurrentModelHandle: ANE_PTR;
  LayerName: string);
begin
  GInitializeVertex;
  GAddVertex(CurrentModelHandle, PChar(LayerName));
end;

function TListWriter.DefaultValue(Expression: String): string;
begin
  result := 'DefaultValue(' + Expression + ')'
end;

procedure TDiscretizationWriter.EvaluateStressPeriods;
var
//  PERLEN : Double;
//  NSTP : integer;
//  TSMULT : double;
//  SsTr : String;
  Index : integer;
begin
  frmProgress.lblActivity.Caption := 'evaluating stress periods';
  with frmMODFLOW do
  begin
    SetLength(StressPeriods, dgTime.RowCount -1);
    Transient := False;
    for Index := 1 to dgTime.RowCount -1 do
    begin
      StressPeriods[Index-1].PERLEN := InternationalStrToFloat(dgTime.Cells[Ord(tdLength),Index]);
      StressPeriods[Index-1].NSTP := StrToInt(dgTime.Cells[Ord(tdNumSteps),Index]);
      StressPeriods[Index-1].TSMULT := InternationalStrToFloat(dgTime.Cells[Ord(tdMult),Index]);
      if dgTime.Cells[Ord(tdSsTr),Index] =
        dgTime.Columns[Ord(tdSsTr)].PickList[0] then
      begin
        StressPeriods[Index-1].Transient := True;
        Transient := True;
      end
      else
      begin
        StressPeriods[Index-1].Transient := False;
      end;
    end;
  end;

end;

function TDiscretizationWriter.ColNumber(ColIndex: integer): integer;
var
  ErrorString : string;
begin
  if not ((ColIndex >= 0) and (ColIndex < NCOL)) then
  begin
    ErrorString := 'Illegal column number in '
      + 'TDiscretizationWriter.ColNumber.';
    raise Exception.Create(ErrorString);
  end;
  if ColsReversed then
  begin
    result := NCOL - ColIndex;
  end
  else
  begin
    result := ColIndex + 1;
  end;
end;

function TDiscretizationWriter.RowNumber(RowIndex: integer): integer;
var
  ErrorString : string;
begin
  if not ((RowIndex >= 0) and (RowIndex < NROW)) then
  begin
    ErrorString := 'Illegal row number in '
      + 'TDiscretizationWriter.RowNumber.';
    raise Exception.Create(ErrorString);
  end;
  if RowsReversed then
  begin
    result := NROW - RowIndex;
  end
  else
  begin
    result := RowIndex + 1;
  end;
end;

procedure TDiscretizationWriter.CheckElevations(Basic: TBasicPkgWriter);
var
  UnitIndex, ColIndex, RowIndex : integer;
  ErrorStringList : TStringList;
  AString : string;
begin
  if ShowWarnings then
  begin
    frmProgress.lblPackage.Caption := 'Discretization';
    ErrorStringList := TStringList.Create;
    try
      frmProgress.lblActivity.Caption := 'checking elevations';
      frmProgress.pbActivity.Position := 0;
      frmProgress.pbActivity.Max := NROW * NCOL * NUNITS;
      With Basic do
      begin
        for UnitIndex := 0 to NUNITS -1 do
        begin
          for ColIndex := 0 to NCOL -1 do
          begin
            for RowIndex := 0 to NROW -1 do
            begin
              if (IBOUND[ColIndex, RowIndex, UnitIndex] <> 0) and
                (Elevations[ColIndex, RowIndex, UnitIndex]
                <= Elevations[ColIndex, RowIndex, UnitIndex+1]) then
              begin
                ErrorStringList.Add(Format('[%d, %d]', [ColIndex+1,RowIndex+1]));
              end;
              frmProgress.pbActivity.StepIt;
              Application.ProcessMessages;
              if not ContinueExport then Exit;
            end;
          end;
          if ErrorStringList.Count > 0 then
          begin
            AString := 'Warning: top of Unit ' + IntToStr(UnitIndex + 1) +  '<= bottom of Unit in Unit '
               + IntToStr(UnitIndex + 1) + '.';
            frmProgress.reErrors.Lines.Add(AString);
            AString := AString + ' [Col,Row]';
            ErrorMessages.Add('');
            ErrorMessages.Add(AString);
            ErrorMessages.AddStrings(ErrorStringList);
          end;
          ErrorStringList.Clear;
        end;
      end;
    finally
      ErrorStringList.Free;
    end;

  end;
end;

{ TBoundaryCell }

constructor TBoundaryCell.Create(AGroupNumber: integer);
begin
  inherited Create;
  GroupNumber := AGroupNumber;
end;

function TDiscretizationWriter.ElevationToLayer(Column, Row: integer;
  const Elevation: double): integer;
var
  UnitIndex, DisIndex : integer;
  Top, Bottom : double;
  UnitTop, UnitBottom : double;
  Count : integer;
begin
  Assert((Column > 0) and (Column <= NCOL));
  Assert((Row > 0) and (Row <= NROW));
  Dec(Column);
  Dec(Row);
  Top := Elevations[Column,Row,0];
  if Elevation >= Top then
  begin
    Result := 1;
    Exit;
  end;
  Bottom := Elevations[Column,Row,NUNITS];
  if Elevation <= Bottom then
  begin
    Result := frmModflow.MODFLOWLayerCount;
    Exit;
  end;
  result := 1;
  for UnitIndex := 1 to NUNITS do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      UnitTop := Elevations[Column,Row,UnitIndex-1];
      if Elevation > UnitTop then
      begin
        Exit;
      end;
      UnitBottom := Elevations[Column,Row,UnitIndex];
      if Elevation < UnitBottom then
      begin
        result := result + frmModflow.DiscretizationCount(UnitIndex)
      end
      else
      begin
        Count := frmModflow.DiscretizationCount(UnitIndex);
        for DisIndex := 1 to Count do
        begin
          Top := UnitTop - ((DisIndex-1)/Count)*(UnitTop-UnitBottom);
          Bottom := UnitTop - (DisIndex/Count)*(UnitTop-UnitBottom);
          if (Top >= Elevation) and (Elevation >= Bottom) then
          begin
            Exit;
          end
          else
          begin
            result := result + 1;
          end;
        end;
      end;
    end;
  end;
end;

procedure TDiscretizationWriter.GetColRow(var X, Y: ANE_Double; var Col,
  Row: Integer; Const GridAngle, RotatedOriginX, RotatedOriginY : double;
  const ColPostions, RowPostions : TPostionArray);
var
  X1, Y1 : double;
//  OriginX, OriginY : double;
//  Index : integer;
  Above, Below, Middle : double;
  AboveIndex, BelowIndex, MiddleIndex : integer;
  procedure GetColOrRow(const Position : ANE_Double;
    const Postions : TPostionArray; var ColOrRow : integer);
  begin
    BelowIndex := 0;
    AboveIndex := Length(Postions) - 1;
    Below := 0;
    Above := Postions[AboveIndex];
    if (Position < Below) or (Position > Above) then
    begin
      ColOrRow := 0;
    end
    else if (Position = Below) then
    begin
      ColOrRow := 1;
    end
    else
    begin
      While (AboveIndex - BelowIndex) > 1 do
      begin
        MiddleIndex := (AboveIndex + BelowIndex) div 2;
        Middle := Postions[MiddleIndex];
        if Middle > Position then
        begin
          AboveIndex := MiddleIndex;
        end
        else
        begin
          BelowIndex := MiddleIndex;
        end;
      end;
      ColOrRow := BelowIndex + 1;
    end;
  end;
begin
  X1 := X;
  Y1 := Y;
  RotatePointsToGrid(X1, Y1, GridAngle);
  X := X1 - RotatedOriginX;
  Y := Y1 - RotatedOriginY;

  GetColOrRow(X, ColPostions, Col);
  GetColOrRow(Y, RowPostions, Row);
end;

procedure TDiscretizationWriter.EvaluateCornerCoordinates(const CurrentModelHandle: ANE_PTR);
var
  StringToEvaluate: string;
  Y0: ANE_DOUBLE;
  YMax: ANE_DOUBLE;
  X0: ANE_DOUBLE;
  XMax: ANE_DOUBLE;
  XTopLeft: double;
  YTopLeft: double;
  XBottomLeft: double;
  YBottomLeft: double;
  XTopRight: Double;
  YTopRight: Double;
  XBottomRight: Double;
  YBottomRight: Double;
  Procedure GetRealCoord(Col, Row: double; out X, Y: double);
  var
    OriginAngle: double;
    distance: double;
  begin
    distance := Sqrt(Sqr(Col) + Sqr(Row));
    OriginAngle := ArcTan2(Row,Col);
    X := distance*Cos(GridAngle+OriginAngle);
    Y := distance*sin(GridAngle+OriginAngle);
  end;
begin
  StringToEvaluate := 'Abs(NthRowPos(0))';
  Y0 := EvalDoubleByLayerHandle(CurrentModelHandle,
    GridLayerHandle, StringToEvaluate);
  StringToEvaluate := 'Abs(NthRowPos(' + IntToStr(NROW) + '))';
  YMax := EvalDoubleByLayerHandle(CurrentModelHandle, GridLayerHandle,
    StringToEvaluate);

  StringToEvaluate := 'Abs(NthColumnPos(0))';
  X0 := EvalDoubleByLayerHandle(CurrentModelHandle, GridLayerHandle,
    StringToEvaluate);
  StringToEvaluate := 'Abs(NthColumnPos(' + IntToStr(NCOL) + '))';
  XMax := EvalDoubleByLayerHandle(CurrentModelHandle, GridLayerHandle,
    StringToEvaluate);

  GetRealCoord(X0, Y0, XTopLeft, YTopLeft);
  GetRealCoord(XMax, Y0, XTopRight, YTopRight);
  GetRealCoord(X0, YMax, XBottomLeft, YBottomLeft);
  GetRealCoord(XMax, YMax, XBottomRight, YBottomRight);

  WriteComment('Top left corner coordinates: ('
    + InternationalFloatToStr(XTopLeft) + ', ' + InternationalFloatToStr(YTopLeft));
  WriteComment('Top right corner coordinates: ('
    + InternationalFloatToStr(XTopRight) + ', ' + InternationalFloatToStr(YTopRight));
  WriteComment('Bottom bottom corner coordinates: ('
    + InternationalFloatToStr(XBottomLeft) + ', ' + InternationalFloatToStr(YBottomLeft));
  WriteComment('Bottom bottom corner coordinates: ('
    + InternationalFloatToStr(XBottomRight) + ', ' + InternationalFloatToStr(YBottomRight));
  WriteComment('Grid angle (counterclockwise in degrees) : '
    + InternationalFloatToStr(GridAngle*180/Pi));
end;

{ TMT3DCellList }

function TMT3DCellList.Add(ACell: TMT3DCellRecord): integer;
var
  Cell : TMT3DCell;
//  Index1, Index2 : integer;
begin
  Cell := GetCellByLocation(ACell.Layer, ACell.Row, ACell.Column);
  if Cell = nil then
  begin
    Cell := TMT3DCell.Create;
    Cell.Cell.Layer := ACell.Layer;
    Cell.Cell.Row := ACell.Row;
    Cell.Cell.Column := ACell.Column;

    result := inherited Add(Cell);
  end
  else
  begin
    result := IndexOf(Cell);
  end;

  Copy2DDoubleArray(ACell.MT3DConcentrations, Cell.Cell.MT3DConcentrations);
//  Cell.Cell := ACell;
{  for Index1 := 0 to Length(ACell.MT3DConcentrations)-1 do
  begin
    for Index2 := 0 to Length(ACell.MT3DConcentrations[0])-1 do
    begin
      Cell.Cell.MT3DConcentrations[Index1,Index2]
        := ACell.MT3DConcentrations[Index1,Index2];
    end;

  end; }
end;

function TMT3DCellList.GetCellByLocation(Layer, Row,
  Column: integer): TMT3DCell;
var
  Index : integer;
  Cell : TMT3DCell;
begin
  result := nil;
  for Index := 0 to Count -1 do
  begin
    Cell := Items[Index] as TMT3DCell;
    if (Cell.Cell.Layer = Layer)
      and (Cell.Cell.Row = Row)
      and (Cell.Cell.Column = Column) then
    begin
      result := Cell;
      Exit;
    end;
  end;
end;

{ TMT3DCell }

procedure TMT3DCell.WriteMT3DConcentrations(const StressPeriod: integer;
  const Lines: TStrings);
var
  ALine : string;
  SpeciesIndex : integer;
begin
  Assert((Length(Cell.MT3DConcentrations) >=StressPeriod)
    and (Length(Cell.MT3DConcentrations[StressPeriod-1]) >=1));

  ALine := TModflowWriter.FixedFormattedInteger(Cell.Layer, 10)
    + TModflowWriter.FixedFormattedInteger(Cell.Row, 10)
    + TModflowWriter.FixedFormattedInteger(Cell.Column, 10)
    + TModflowWriter.FixedFormattedReal(Cell.MT3DConcentrations[StressPeriod-1,0], 10)
    + TModflowWriter.FixedFormattedInteger(1, 10) + ' ';
  for SpeciesIndex := 0 to Length(Cell.MT3DConcentrations[StressPeriod-1])-1 do
  begin
    ALine := ALine + TModflowWriter.FreeFormattedReal
      (Cell.MT3DConcentrations[StressPeriod-1,SpeciesIndex]);
  end;
  Lines.Add(ALine);
end;

procedure TDiscretizationWriter.CheckSimulatedUnits;
var
  ErrorMessage: string;
begin
  with frmModflow do
  begin
    if not Simulated(1) or not Simulated(dgGeol.RowCount -1) then
    begin
      ErrorMessage := 'Error: The uppermost and lowermost geologic units must be '
        + 'simulated.  If you don''t need one of those units to be simulated, '
        + 'you should delete it.';
      ErrorMessages.Add('');
      ErrorMessages.Add(ErrorMessage);
      frmProgress.reErrors.Lines.Add(ErrorMessage);
    end;
  end;
end;

function TDiscretizationWriter.ElevationToUnit(Column, Row: integer;
  const Elevation: double): integer;
var
  UnitIndex : integer;
  Top, Bottom : double;
  UnitTop, UnitBottom : double;
begin
  Assert((Column > 0) and (Column <= NCOL));
  Assert((Row > 0) and (Row <= NROW));
  Dec(Column);
  Dec(Row);
  Top := Elevations[Column,Row,0];
  if Elevation >= Top then
  begin
    Result := 1;
    Exit;
  end;
  Bottom := Elevations[Column,Row,NUNITS];
  if Elevation <= Bottom then
  begin
    Result := NUNITS;
    Exit;
  end;
  result := 1;
  for UnitIndex := 1 to NUNITS do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin
      UnitTop := Elevations[Column,Row,UnitIndex-1];
      if Elevation > UnitTop then
      begin
        Exit;
      end;
      UnitBottom := Elevations[Column,Row,UnitIndex];
      if Elevation < UnitBottom then
      begin
        result := result + 1;
      end
      else
      begin
        result := UnitIndex;
        Exit;
      end;
    end;
  end;
end;

class procedure TBasicPkgWriter.AssignUnitNumbers;
begin
  if UseInitialHeads then
  begin
    frmModflow.GetUnitNumber('InitialHeads');
  end;
end;

Initialization
  InitializeMinSingle;

end.
