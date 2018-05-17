unit WriteMoc3d;

interface

uses SysUtils, Forms, contnrs, WriteModflowDiscretization;

type
  TMoc3dObservationRecord = record
    Layer, Row, Column : integer;
  end;

  T2DDynamicArray = array of array of double;

  TObservationList = class;

  TMOC3D_Writer = class(TListWriter)
  private
    NPTPND : integer;
    FirstMoc3dUnit, LastMoc3dUnit : integer;
    DisWriter : TDiscretizationWriter;
    BasWriter : TBasicPkgWriter;
    ISROW1, ISROW2, ISCOL1, ISCOL2 : integer;
    ISLAY1, ISLAY2 : integer;
    NODISP : integer;
    ObservationList : TObservationList;
    IDPTIM : integer;
    IDPFO : integer;
    IDPZO : integer;
    IDKRF, IDKTIM, IDKFO, IDKFS, IDKZO, IDKZS : integer;
    procedure WriteDataSets1and2;
    procedure WriteDataSet3;
    procedure WriteDataSet4;
    procedure WriteDataSet5;
    procedure WriteDataSet5A;
    procedure WriteDataSet5B;
    procedure WriteDataSet6;
    procedure WriteDataSet7;
    procedure WriteDataSet7_1;
    procedure WriteDataSet7_2;
    procedure WriteDataSet8;
    procedure WriteDataSet9;
    procedure WriteDataSet10;
    procedure WriteDataSet11;
    procedure WriteDataSet12;
    procedure WriteDataSet13;
    procedure WriteDataSet14;
    procedure WriteDataSet15;
    procedure WriteDataSet16;
    procedure WriteDataSet17;
    procedure WriteDataSet18;
    Procedure CheckGrid(FirstRow, LastRow, FirstCol, LastCol : integer);
    function MocUsed: boolean;
    function EllamUsed : boolean;
    function MocimpUsed : boolean;
    procedure WriteMainFile(const Root: string);
    procedure WriteRechargeConcentrationFile(const Root: string);
    procedure WriteMOC3DObservations(const Root : string);
    Procedure WriteINCRCH(const StressPeriod : integer);
    Procedure WriteCRECH(const StressPeriod : integer);
    procedure WriteAgeFile(const Root: string);
    procedure WriteDoublePorosityFile(const Root: string);
    procedure WriteDP_DataSet1;
    procedure WriteDP_DataSets2and3;
    procedure WriteDP_DataSets4to6;
    procedure WriteLayerParameter(const LayerName,
      ParameterName : string; LayersPerUnit : integer; Comment: string = '');
    procedure SetLayerParameter(const LayerName,
      ParameterName : string; Dynamic2D_Array : pointer);
    Procedure WriteArray(Dynamic2D_Array : pointer; Comment: string = '');
    procedure WriteSimpleReactionsFile(const Root: string);
    procedure WriteSR_DataSet1;
    procedure WriteSR_DataSet2;
    procedure WriteSR_DataSets3to6;
    procedure EvaluateDataSet3;
    function MocwtiUsed: boolean;
    function MocwtUsed: boolean;
    procedure WriteStartingStressPeriodFile(const Root: string);
    procedure WritePRTP_File(const Root: string);

//    Procedure EvaluateObservations;
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure WriteFiles(const Root : string;
      const DiscretizationWriter : TDiscretizationWriter;
      const BasicPkgWriter : TBasicPkgWriter);
    function NumberOfObservations : integer;
    Procedure EvaluateObservations(const DiscretizationWriter :
      TDiscretizationWriter; const BasicPkgWriter : TBasicPkgWriter);
  end;

  TMoc3dObservation = Class(TObject)
  private
    Observation : TMoc3dObservationRecord;
    procedure WriteObservation(MOC3D_Writer : TMOC3D_Writer; Index : integer);
    procedure WriteObservationWithUnitNumber(MOC3D_Writer : TMOC3D_Writer; UnitNumber : integer);
  end;

  TObservationList = Class(TObjectList)
    function Add(ObservationRecord : TMoc3dObservationRecord) : integer; overload;
    procedure Write(MOC3D_Writer : TMOC3D_Writer);
  end;


implementation

uses AnePIE, ANECB, WriteNameFileUnit, ProgressUnit, UtilityFunctions, Variables,
  MOC3DGridFunctions, ModflowUnit, OptionsUnit, GetCellUnit;

{ MOC3D_Writer }

procedure TMOC3D_Writer.CheckGrid(FirstRow, LastRow, FirstCol, LastCol : integer);
var
  Index : integer;
  Width, Width2 : single;
  errorFound : boolean;
  AString : string;
begin
  if not EllamUsed then
  begin
    errorFound := False;
    Dec(FirstRow);
    Dec(LastRow);
    Dec(FirstCol);
    Dec(LastCol);
    Width := DisWriter.DELC[FirstRow];
    for Index := FirstRow + 1 to LastRow do
    begin
      Width2 := DisWriter.DELC[Index];
      if Width2 <> Width then
      begin
        errorFound := True;
        AString := 'Error: Row Widths are not uniform.';
        frmProgress.reErrors.Lines.Add(AString);
        ErrorMessages.Add('');
        ErrorMessages.Add(AString);
        AString := 'The width of Row ' + IntToStr(Index)
          + ' is ' + FloatToStr(Width) + '.';
        ErrorMessages.Add(AString);
        AString := 'The width of Row ' + IntToStr(Index + 1)
          + ' is ' + FloatToStr(Width2) + '.';
        ErrorMessages.Add(AString);
        break;
      end;
    end;
    if not errorFound then
    begin
      Width := DisWriter.DELR[FirstCol];
      for Index := FirstCol + 1 to LastCol do
      begin
        Width2 := DisWriter.DELR[Index];
        if Width2 <> Width then
        begin
          errorFound := True;
          AString := 'Error: Column Widths are not uniform.';
          frmProgress.reErrors.Lines.Add(AString);
          ErrorMessages.Add('');
          ErrorMessages.Add(AString);
          AString := 'The width of Column ' + IntToStr(Index)
            + ' is ' + FloatToStr(Width) + '.';
          ErrorMessages.Add(AString);
          AString := 'The width of Column ' + IntToStr(Index + 1)
            + ' is ' + FloatToStr(Width2) + '.';
          ErrorMessages.Add(AString);
          break;
        end;
      end;
    end;
  end;

end;

function TMOC3D_Writer.MocUsed: boolean;
begin
  result := (frmModflow.rgMOC3DSolver.ItemIndex = 0);
end;

function TMOC3D_Writer.MocimpUsed: boolean;
begin
  result := (frmModflow.rgMOC3DSolver.ItemIndex = 1);
end;

function TMOC3D_Writer.EllamUsed: boolean;
begin
  result := frmModflow.rgMOC3DSolver.ItemIndex = 2;
end;

function TMOC3D_Writer.MocwtUsed: boolean;
begin
  result := (frmModflow.rgMOC3DSolver.ItemIndex = 3);
end;

function TMOC3D_Writer.MocwtiUsed: boolean;
begin
  result := (frmModflow.rgMOC3DSolver.ItemIndex = 4);
end;

procedure TMOC3D_Writer.WriteDataSet10;
var
  UnitIndex, DisIndex : integer;
  CINT : array of array of double;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ColCount, RowCount : integer;
  Block : TBlockObjectOptions;
  ModelHandle, GridLayerHandle : ANE_PTR;
//  Value : ANE_DOUBLE;
  ParameterIndex : ANE_INT16;
  ParameterName : String;
  GridLayer : TLayerOptions;
  Col, Row : integer;
begin
  ModelHandle := frmModflow.CurrentModelHandle;
  GridLayerHandle := DisWriter.GridLayerHandle;
  ColCount := ISCOL2 - ISCOL1 + 1;
  RowCount := ISROW2 - ISROW1 + 1;
  SetLength(CINT,ColCount,RowCount);
  GridLayer := TLayerOptions.Create(GridLayerHandle);
  try
    for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
    begin
      if frmMODFLOW.Simulated(UnitIndex) then
      begin
        ParameterName := ModflowTypes.GetMFMOCInitialConcParamType.
          ANE_ParamName + IntToStr(UnitIndex);
        ParameterIndex := GridLayer.GetParameterIndex(ModelHandle,ParameterName);
        Row := -1;
        for RowIndex := ISROW1 to ISROW2 do
        begin
          Inc(Row);
          Col := -1;
          for ColIndex := ISCOL1 to ISCOL2 do
          begin
            Inc(Col);
            BlockIndex := DisWriter.BlockIndex(RowIndex-1,ColIndex-1);
            Block := TBlockObjectOptions.Create(ModelHandle,GridLayerHandle,
              BlockIndex);
            try
            CINT[Col,Row] := Block.
              GetFloatParameter(ModelHandle,ParameterIndex);
            finally
              Block.Free;
            end;
          end;
        end;
        for DisIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
        begin
          WriteU2DRELHeader(' # data set 10 CINT');
          for RowIndex := 0 to RowCount-1 do
          begin
            for ColIndex := 0 to ColCount-1 do
            begin
              Write(FFile,FreeFormattedReal(CINT[ColIndex,RowIndex]));
            end;
            WriteLn(FFile);
          end;

        end;
      end;
    end;
  finally
    GridLayer.Free(ModelHandle);
  end;
end;

procedure TMOC3D_Writer.WriteDataSet11;
var
  UnitIndex, DivIndex : integer;
  TopUnit, BottomUnit : integer;
  Value : double;
  ExtraTop, ExtraBottom : boolean;
  SubGrid : boolean;
  LoopBegin, LoopEnd : integer;
begin
  if frmMODFLOW.cbCBDY.Checked then
  begin
    Exit;
  end;

  SubGrid := (ISROW1 > 1) or (ISROW2 < DisWriter.NROW)
    or (ISCOL1 > 1) or (ISCOL2 < DisWriter.NCOL);

  TopUnit := StrToInt(frmMODFLOW.adeMOC3DLay1.Text);
  LoopBegin := TopUnit;
  ExtraTop := False;
  if TopUnit > 1 then
  begin
    TopUnit := TopUnit -1;
    ExtraTop := True;
  end;

  BottomUnit := StrToInt(frmMODFLOW.adeMOC3DLay2.Text);
  if BottomUnit = -1 then
  begin
    BottomUnit := frmModflow.UnitCount;
  end;
  LoopEnd := BottomUnit;
  ExtraBottom := False;
  if BottomUnit < frmModflow.UnitCount then
  begin
    BottomUnit := BottomUnit + 1;
    ExtraBottom := True;
  end;

  if SubGrid or ExtraTop or ExtraBottom then
  begin
    WriteU2DRELHeader(' # data set 11 CINFL');
    if SubGrid then
    begin
      for UnitIndex := LoopBegin to LoopEnd do
      begin
        if frmMODFLOW.Simulated(UnitIndex) then
        begin
          Value := InternationalStrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells
            [Ord(trdConc),UnitIndex]);
          for DivIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
          begin
            WriteLn(FFile, FreeFormattedReal(Value));
          end;
        end;
      end;
    end;
    if ExtraTop then
    begin
//      for UnitIndex := TopUnit downto 1 do
//      begin
//        if frmMODFLOW.Simulated(UnitIndex) then
//        begin
          Value := InternationalStrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells
            [Ord(trdConc),TopUnit]);
          WriteLn(FFile, FreeFormattedReal(Value));
//          Break;
//        end;
//      end;
    end;
    if ExtraBottom then
    begin
{      for UnitIndex := BottomUnit to frmModflow.UnitCount do
      begin
        if frmMODFLOW.Simulated(UnitIndex) then
        begin      }
          Value := InternationalStrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells
            [Ord(trdConc),BottomUnit]);
          WriteLn(FFile, FreeFormattedReal(Value));
{          Break;
        end;
      end;  }
    end;
  end;

end;

procedure TMOC3D_Writer.WriteDataSet12;
var
  NZONES : integer;
  IZONE : integer;
  ZONCON : double;
  Index : integer;
begin
  NZONES := BasWriter.Moc3DConcentrations.Count;
  writeln(FFile, NZONES, ' # data set 12 NZONES');
  if NZONES > 0 then
  begin
    for Index := 0 to NZONES - 1 do
    begin
      IZONE := -(Index + 1);
      ZONCON := BasWriter.Moc3DConcentrations[Index];
      writeLn(FFile, IZONE, ' ', FreeFormattedReal(ZONCON), ' # data set 12 IZONE    ZONCON');
    end;

  end;
end;

procedure TMOC3D_Writer.WriteDataSet13;
var
  UnitIndex : integer;
  DisIndex : integer;
  IGENPT : array of array of integer;
  BlockIndex : ANE_INT32;
  ColCount, RowCount : integer;
  Block : TBlockObjectOptions;
  Col, Row : integer;
  ParameterName : string;
  ParameterIndex : ANE_INT16;
  ModelHandle, GridLayerHandle : ANE_PTR;
  GridLayer : TLayerOptions;
  ColIndex, RowIndex : integer;
begin
  if MocUsed or MocimpUsed then
  begin
    ModelHandle := frmModflow.CurrentModelHandle;
    GridLayerHandle := DisWriter.GridLayerHandle;
    ColCount := ISCOL2 - ISCOL1 + 1;
    RowCount := ISROW2 - ISROW1 + 1;
    GridLayer := TLayerOptions.Create(GridLayerHandle);
    try
      SetLength(IGENPT, ColCount, RowCount);
      for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
      begin
        if frmModflow.Simulated(UnitIndex) then
        begin
          ParameterName := ModflowTypes.GetMFGridMOCParticleRegenParamType.
            ANE_ParamName + IntToStr(UnitIndex);
          ParameterIndex := GridLayer.GetParameterIndex(ModelHandle,ParameterName);
          Row := -1;
          for RowIndex := ISROW1 to ISROW2 do
          begin
            Inc(Row);
            Col := -1;
            for ColIndex := ISCOL1 to ISCOL2 do
            begin
              Inc(Col);
              BlockIndex := DisWriter.BlockIndex(RowIndex-1,ColIndex-1);
              Block := TBlockObjectOptions.Create(ModelHandle,GridLayerHandle,
                BlockIndex);
              try
                IGENPT[Col,Row] := Block.
                  GetIntegerParameter(ModelHandle,ParameterIndex);
              finally
                Block.Free;
              end;
            end;
          end;
          for DisIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
          begin
            WriteU2DINTHeader(' # data set 13 IGENPT');
            for RowIndex := 0 to RowCount-1 do
            begin
              for ColIndex := 0 to ColCount-1 do
              begin
                Write(FFile, IGENPT[ColIndex,RowIndex], ' ');
              end;
              WriteLn(FFile);
            end;
          end;
        end;
      end;
    finally
      GridLayer.Free(ModelHandle);
    end;
  end;
end;

procedure TMOC3D_Writer.WriteDataSet14;
var
  UnitIndex : Integer;
  ALONG : double;
  DivIndex : integer;
begin
  if NODISP <> 1 then
  begin
    WriteU2DRELHeader(' # data set 14 ALONG');
    for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
    begin
      if frmMODFLOW.Simulated(UnitIndex) then
      begin
        ALONG := InternationalStrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells[Ord(trdLong),UnitIndex]);
        for DivIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
        begin
          WriteLn(FFile, FreeFormattedReal(ALONG));
        end;
      end;
    end;
  end;
end;

procedure TMOC3D_Writer.WriteDataSet15;
var
  UnitIndex : Integer;
  ATRANH : double;
  DivIndex : integer;
begin
  if NODISP <> 1 then
  begin
    WriteU2DRELHeader(' # data set 15 ATRANH');
    for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
    begin
      if frmMODFLOW.Simulated(UnitIndex) then
      begin
        ATRANH := InternationalStrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells[Ord(trdTranHor),UnitIndex]);
        for DivIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
        begin
          WriteLn(FFile, FreeFormattedReal(ATRANH));
        end;
      end;
    end;
  end;
end;

procedure TMOC3D_Writer.WriteDataSet16;
var
  UnitIndex : Integer;
  ATRANV : double;
  DivIndex : integer;
begin
  if NODISP <> 1 then
  begin
    WriteU2DRELHeader(' # data set 16 ATRANV');
    for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
    begin
      if frmMODFLOW.Simulated(UnitIndex) then
      begin
        ATRANV := InternationalStrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells[Ord(trdTranVer),UnitIndex]);
        for DivIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
        begin
          WriteLn(FFile, FreeFormattedReal(ATRANV));
        end;
      end;
    end;
  end;
end;

procedure TMOC3D_Writer.WriteDataSet17;
var
  UnitIndex : Integer;
  RF : double;
  DivIndex : integer;
begin
  WriteU2DRELHeader(' # data set 17 RF');
  for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
  begin
    if frmMODFLOW.Simulated(UnitIndex) then
    begin
      RF := InternationalStrToFloat(frmMODFLOW.sgMOC3DTransParam.Cells[Ord(trdRetard),UnitIndex]);
      for DivIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
      begin
        WriteLn(FFile, FreeFormattedReal(RF));
      end;
    end;
  end;
end;

procedure TMOC3D_Writer.WriteDataSet18;
var
  POR : array of array of double;
  ColCount : integer;
  RowCount : integer;
  Value : double;
  Col, Row : integer;
  ModelHandle, GridLayerHandle : ANE_PTR;
  GridLayer : TLayerOptions;
  UnitIndex : integer;
  ParameterName : string;
  ParameterIndex : ANE_INT16;
  RowIndex, ColIndex : integer;
  BlockIndex : ANE_INT32;
  Block : TBlockObjectOptions;
  DivIndex : integer;
begin
  ModelHandle := frmModflow.CurrentModelHandle;
  GridLayerHandle := DisWriter.GridLayerHandle;
  ColCount := ISCOL2 - ISCOL1 + 1;
  RowCount := ISROW2 - ISROW1 + 1;
  GridLayer := TLayerOptions.Create(GridLayerHandle);
  try

    SetLength(POR, ColCount, RowCount);
    for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
    begin
      if frmMODFLOW.Simulated(UnitIndex) then
      begin
        ParameterName := ModflowTypes.GetMFGridMOCPorosityParamType.
          ANE_ParamName + IntToStr(UnitIndex);
        ParameterIndex := GridLayer.GetParameterIndex(ModelHandle,ParameterName);
        Row := -1;
        for RowIndex := ISROW1 to ISROW2 do
        begin
          Inc(Row);
          Col := -1;
          for ColIndex := ISCOL1 to ISCOL2 do
          begin
            Inc(Col);
            BlockIndex := DisWriter.BlockIndex(RowIndex-1,ColIndex-1);
            Block := TBlockObjectOptions.Create(ModelHandle,GridLayerHandle,
              BlockIndex);
            try
              POR[Col,Row] := Block.
                GetFloatParameter(ModelHandle,ParameterIndex);
            finally
              Block.Free;
            end;
          end;
        end;
        for DivIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
        begin
          WriteU2DRELHeader(' # data set 18 POR');
          for Row := 0 to RowCount - 1 do
          begin
            for Col := 0 to ColCount - 1 do
            begin
              Value:= POR[Col,Row];
              Write(FFile, FreeFormattedReal(Value));
            end;
            WriteLn(FFile);
          end;

        end;
      end;
    end;
  finally
    GridLayer.Free(ModelHandle);
  end;


end;

procedure TMOC3D_Writer.EvaluateDataSet3;
var
  layerHandle : ANE_PTR;
  NRow, NCol : ANE_INT32;
  ModelHandle : ANE_PTR;
  Layername : string;
begin
  ModelHandle := frmMODFLOW.CurrentModelHandle;

  Layername := ModflowTypes.GetGridLayerType.ANE_LayerName;
  layerHandle := GetLayerHandle(ModelHandle,Layername);

  GetNumRowsCols(ModelHandle, LayerHandle, NRow, NCol);

  FirstMoc3dUnit := StrToInt(frmMODFLOW.adeMOC3DLay1.Text);
  LastMoc3dUnit := StrToInt(frmMODFLOW.adeMOC3DLay2.Text);
  if LastMoc3dUnit = -1 then
  begin
    LastMoc3dUnit := StrToInt(frmMODFLOW.edNumUnits.Text);
  end;

  ISROW1 := fMOCROW1(ModelHandle,layerHandle,NRow);
  ISROW2 := fMOCROW2(ModelHandle,layerHandle,NRow);
  ISCOL1 := fMOCCOL1(ModelHandle,layerHandle,NCol);
  ISCOL2 := fMOCCOL2(ModelHandle,layerHandle,NCol);
  ISLAY1 := FirstMoc3dUnit;

  if ISLAY1 > 1 then
  begin
    ISLAY1 := frmModflow.MODFLOWLayersAboveCount(ISLAY1) + 1;
  end;

  ISLAY2 := StrToInt(frmMODFLOW.adeMOC3DLay2.Text);
  if ISLAY2 = -1 then
  begin
    ISLAY2 := frmModflow.MODFLOWLayerCount;
  end
  else
  begin
    ISLAY2 := frmModflow.MODFLOWLayersAboveCount(ISLAY2)
      + frmModflow.DiscretizationCount(ISLAY2);
  end;

end;

procedure TMOC3D_Writer.WriteDataSet3;
{var
  layerHandle : ANE_PTR;
  NRow, NCol : ANE_INT32;
  
  ModelHandle : ANE_PTR;
  Layername : string;  }
begin
  EvaluateDataSet3;
{  ModelHandle := frmMODFLOW.CurrentModelHandle;

  Layername := ModflowTypes.GetGridLayerType.ANE_LayerName;
  layerHandle := GetLayerHandle(ModelHandle,Layername);

  GetNumRowsCols(ModelHandle, LayerHandle, NRow, NCol);

  FirstMoc3dUnit := StrToInt(frmMODFLOW.adeMOC3DLay1.Text);
  LastMoc3dUnit := StrToInt(frmMODFLOW.adeMOC3DLay2.Text);
  if LastMoc3dUnit = -1 then
  begin
    LastMoc3dUnit := StrToInt(frmMODFLOW.edNumUnits.Text);
  end;

  ISROW1 := fMOCROW1(ModelHandle,layerHandle,NRow);
  ISROW2 := fMOCROW2(ModelHandle,layerHandle,NRow);
  ISCOL1 := fMOCCOL1(ModelHandle,layerHandle,NCol);
  ISCOL2 := fMOCCOL2(ModelHandle,layerHandle,NCol);
  ISLAY1 := FirstMoc3dUnit;

  if ISLAY1 > 1 then
  begin
    ISLAY1 := frmModflow.MODFLOWLayersAboveCount(ISLAY1);
  end;

  ISLAY2 := StrToInt(frmMODFLOW.adeMOC3DLay2.Text);
  if ISLAY2 = -1 then
  begin
    ISLAY2 := frmModflow.MODFLOWLayerCount;
  end
  else
  begin
    ISLAY2 := frmModflow.MODFLOWLayersAboveCount(ISLAY2)
      + frmModflow.DiscretizationCount(ISLAY2);
  end;  }

  WriteLn(FFile, ISLAY1, ' ', ISLAY2, ' ',
                 ISROW1, ' ', ISROW2, ' ',
                 ISCOL1, ' ', ISCOL2, ' # data set 3 ISLAY1   ISLAY2   ISROW1   ISROW2   ISCOL1   ISCOL2');

  CheckGrid(ISROW1, ISROW2, ISCOL1, ISCOL2);

end;

procedure TMOC3D_Writer.WriteDataSet4;
var
  DECAY, DIFFUS : double;
begin
  if frmModflow.cbMOC3DNoDisp.Checked then
  begin
    NODISP := 1;
  end
  else
  begin
    NODISP := 0;
  end;
  DECAY := InternationalStrToFloat(frmModflow.adeMOC3DDecay.Text);
  DIFFUS := InternationalStrToFloat(frmModflow.adeMOC3DDiffus.Text);

  WriteLn(FFile, NODISP, ' ', FreeFormattedReal(DECAY),
    FreeFormattedReal(DIFFUS), ' # data set 4 NODISP    DECAY    DIFFUS');
end;

procedure TMOC3D_Writer.WriteDataSet5;
begin
  if not EllamUsed then
  begin
    WriteDataSet5A;
  end
  else
  begin
    WriteDataSet5B;
  end;
end;

procedure TMOC3D_Writer.WriteDataSet5A;
var
  NPMAX: integer;
  Warning: string;
begin
  if not EllamUsed and
    ((frmModflow.comboSpecifyParticles.ItemIndex = 0)
    or not frmModflow.comboSpecifyParticles.Enabled) then
  begin
    NPMAX := StrToInt(frmModflow.adeMOC3DMaxParticles.Text);
    if frmModflow.cbCustomParticle.Checked then
    begin
      NPTPND := -StrToInt(frmModflow.edMOC3DInitParticles.Text);
    end
    else
    begin
      NPTPND := StrToInt(frmModflow.edMOC3DInitParticles.Text);
    end;
    WriteLn(FFile, NPMAX, ' ', NPTPND, ' # data set 5a NPMAX    NPTPND');

    if NPTPND = 1 then
    begin
      Warning := 'Warning: NPTPND (the number of particles per cell in GWT) '
      + '= 1.  To obtain reliable results, NPTPND usually needs to be larger '
      + 'than 1.';
      ErrorMessages.Add('');
      ErrorMessages.Add(Warning);
      frmProgress.reErrors.Lines.Add(Warning);
    end;
  end;
end;

procedure TMOC3D_Writer.WriteDataSet5B;
var
  NSCEXP, NSREXP, NSLEXP, NTEXP : integer;
begin
  if EllamUsed then
  begin
    with frmModflow do
    begin
      NSCEXP := StrToInt(adeEllamColumnExp.Text);
      NSREXP := StrToInt(adeEllamRowExp.Text);
      NSLEXP := StrToInt(adeEllamLayerExp.Text);
      NTEXP := StrToInt(adeEllamTimeExp.Text);
    end;

    WriteLn(FFile, NSCEXP, ' ', NSREXP, ' ', NSLEXP, ' ', NTEXP, ' # data set 5b NSCEXP    NSREXP    NSLEXP    NTEXP');
  end;
end;

procedure TMOC3D_Writer.WriteDataSet6;
var
  ParticleIndex : integer;
  PNEWL, PNEWR, PNEWC : double;
begin
  if not EllamUsed and ((frmModflow.comboSpecifyParticles.ItemIndex = 0)
    or not frmModflow.comboSpecifyParticles.Enabled)
    and (NPTPND < 0) then
  begin
    for ParticleIndex := 1 to -NPTPND do
    begin
      PNEWL := InternationalStrToFloat(frmMODFLOW.sgMOC3DParticles.
        Cells[Ord(pdLayer) ,ParticleIndex]);
      PNEWR := InternationalStrToFloat(frmMODFLOW.sgMOC3DParticles.
        Cells[Ord(pdRow) ,ParticleIndex]);
      PNEWC := InternationalStrToFloat(frmMODFLOW.sgMOC3DParticles.
        Cells[Ord(pdColumn) ,ParticleIndex]);
      WriteLn(FFile, FreeFormattedReal(PNEWL), FreeFormattedReal(PNEWR),
        FreeFormattedReal(PNEWC), ' # data set 6 PNEWL    PNEWR    PNEWC');
    end;
  end;
end;

procedure TMOC3D_Writer.WriteDataSet7;
var
  CELDIS, FZERO: double;
  INTRPL : integer;
begin
  with frmModflow do
  begin
    CELDIS := InternationalStrToFloat(adeMOC3DMaxFrac.Text);
    if EllamUsed then
    begin
      WriteLn(FFile, CELDIS);
    end
    else
    begin
      FZERO := InternationalStrToFloat(adeMOC3DLimitActiveCells.Text);
      INTRPL := comboMOC3DInterp.ItemIndex + 1;
      WriteLn(FFile, FreeFormattedReal(CELDIS), FreeFormattedReal(FZERO), INTRPL,
        ' # data set 7 CELDIS    {FZERO}    {INTRPL}');
    end
  end;
end;

procedure TMOC3D_Writer.WriteDataSet7_1;
var
  FDTMTH, EPSSLV : double;
  NCXIT, IDIREC, MAXIT : integer;
begin
  if MocimpUsed or MocwtiUsed then
  begin
    with frmModflow do
    begin
      FDTMTH := InternationalStrToFloat(adeMOCWeightFactor.Text);
      NCXIT  := StrToInt(adeMOCNumIter.Text);
      IDIREC := comboMOC3D_IDIREC.ItemIndex + 1;
      EPSSLV := InternationalStrToFloat(adeMOCTolerance.Text);
      MAXIT  := StrToInt(adeMOCMaxIter.Text);
      WriteLn(FFile, FreeFormattedReal(FDTMTH), NCXIT, ' ', IDIREC, ' ',
        FreeFormattedReal(EPSSLV), MAXIT, ' # data set 7.1 CELDIS    {FZERO}    {INTRPL}');
    end;
  end;
end;

procedure TMOC3D_Writer.WriteDataSet7_2;
var
  REMCRIT, GENCRIT: double;
  IRAND, ISRCFIX: integer;
begin
  if MocwtUsed or MocwtiUsed then
  begin
    with frmModflow do
    begin
      REMCRIT := InternationalStrToFloat(adeREMCRIT.Text);
      GENCRIT := InternationalStrToFloat(adeGENCRIT.Text);
      IRAND := comboIRAND.ItemIndex;
      if IRAND > 1 then
      begin
        IRAND := StrToInt(adeIRAND.Text);
      end;
      if cbISRCFIX.Checked then
      begin
        ISRCFIX := 1;
      end
      else
      begin
        ISRCFIX := 0;
      end;

      WriteLn(FFile, FreeFormattedReal(REMCRIT), FreeFormattedReal(GENCRIT),
        IRAND, ' ', ISRCFIX, ' # data set 7.2 REMCRIT	GENCRIT    IRAND    ISRCFIX');
    end;
  end;
end;

procedure TMOC3D_Writer.WriteDataSet8;
var
  NPNTCL, ICONFM, NPNTVL, IVELFM, NPNTDL, IDSPFM, NPNTPL : integer;
begin
  with frmModflow do
  begin
    NPNTCL := comboMOC3DConcFreq.ItemIndex;
    if NPNTCL < 3 then
    begin
      NPNTCL := NPNTCL - 2;
    end
    else
    begin
      NPNTCL := StrToInt(adeMOC3DConcFreq.Text);
    end;
    if rgMOC3DConcFormat.Enabled and (rgMOC3DConcFormat.ItemIndex > 0) then
    begin
      ICONFM := -1;
    end
    else
    begin
      ICONFM := 0;
    end;
    NPNTVL := comboMOC3DVelFreq.ItemIndex;
    if NPNTVL < 2 then
    begin
      NPNTVL := NPNTVL - 1;
    end
    else
    begin
      NPNTVL := StrToInt(adeMOC3DVelFreq.Text);
    end;
    IVELFM := 0;
    NPNTDL := comboMOC3DDispFreq.ItemIndex;
    if NPNTDL < 3 then
    begin
      NPNTDL := NPNTDL - 2;
    end
    else
    begin
      NPNTDL := StrToInt(adeMOC3DDispFreq.Text);
    end;
    IDSPFM := 0;
    if not comboMOC3DPartFileType.Enabled or (comboMOC3DPartFileType.ItemIndex = 0)
    then
    begin
      NPNTPL := 0;
    end
    else
    begin
      NPNTPL := comboMOC3DPartFreq.ItemIndex;
      if NPNTPL < 3 then
      begin
        NPNTPL := NPNTPL - 2;
      end
      else
      begin
        NPNTPL := StrToInt(adeMOC3DPartFreq.Text);
      end;
    end;
    WriteLn(FFile, NPNTCL, ' ', ICONFM, ' ', NPNTVL, ' ', IVELFM, ' ',
                   NPNTDL, ' ', IDSPFM, ' ', NPNTPL, ' # data set 8 NPNTCL  ICONFM  NPNTVL  IVELFM  NPNTDL  IDSPFM  {NPNTPL}');

  end;
end;

procedure TMOC3D_Writer.WriteDataSet9;
var
  CNOFLO : double;
begin
  CNOFLO := InternationalStrToFloat(frmModflow.adeMOC3DCnoflow.Text);
  WriteLn(FFile, FreeFormattedReal(CNOFLO), ' # data set 9 CNOFLO');
end;

procedure TMOC3D_Writer.WriteDataSets1and2;
begin
  WriteLn(FFile, frmModflow.adeTitle1.Text);
  WriteLn(FFile, frmModflow.adeTitle2.Text);
end;

procedure TMOC3D_Writer.WriteMainFile(const Root: string);
var
  FileName : String;
begin
  if frmModflow.cbExpCONC.Checked then
  begin
    FileName := GetCurrentDir + '\' + Root + rsMoc;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      if ContinueExport then
      begin
        WriteDataSets1and2;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet3;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet4;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet5;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet6;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet7;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet7_1;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet7_2;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet8;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet9;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet10;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet11;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet12;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet13;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet14;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet15;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet16;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet17;
        Application.ProcessMessages;
      end;
      if ContinueExport then
      begin
        WriteDataSet18;
        Application.ProcessMessages;
      end;

    finally
      CloseFile(FFile);
    end;
  end
  else
  begin
    EvaluateDataSet3;
  end;
end;

procedure TMOC3D_Writer.WriteRechargeConcentrationFile(const Root: string);
var
  FileName : String;
  StressPeriod : integer;
begin
  if frmModflow.cbRCH.Checked then
  begin
    FileName := GetCurrentDir + '\' + Root + rsCrc;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      for StressPeriod := 1 to frmModflow.dgTime.RowCount -1 do
      begin
        if ContinueExport then
        begin
          WriteINCRCH(StressPeriod);
          Application.ProcessMessages;
        end;
      end;

    finally
      CloseFile(FFile);
    end;
  end;
end;

procedure TMOC3D_Writer.WriteFiles(const Root: string;
  const DiscretizationWriter : TDiscretizationWriter;
  const BasicPkgWriter : TBasicPkgWriter);
begin
  frmProgress.lblPackage.Caption := 'MF2K_GWT';
  Application.ProcessMessages;

  DisWriter := DiscretizationWriter;
  BasWriter := BasicPkgWriter;
  Assert((DisWriter <> nil) and (BasWriter <> nil));

  frmProgress.lblActivity.Caption := 'Main file';
  Application.ProcessMessages;
  WriteMainFile(Root);

  frmProgress.lblActivity.Caption := 'Recharge Concentration';
  Application.ProcessMessages;
  WriteRechargeConcentrationFile(Root);

  frmProgress.lblActivity.Caption := 'Obsservations';
  Application.ProcessMessages;
  WriteMOC3DObservations(Root);

  frmProgress.lblActivity.Caption := 'Age File';
  Application.ProcessMessages;
  WriteAgeFile(Root);

  frmProgress.lblActivity.Caption := 'Double Porosity File';
  Application.ProcessMessages;
  WriteDoublePorosityFile(Root);

  frmProgress.lblActivity.Caption := 'Simple Reactions File';
  Application.ProcessMessages;
  WriteSimpleReactionsFile(Root);

  frmProgress.lblActivity.Caption := 'Starting Stress Period File';
  Application.ProcessMessages;
  WriteStartingStressPeriodFile(Root);

  frmProgress.lblActivity.Caption := 'PRTP File';
  Application.ProcessMessages;
  WritePRTP_File(Root);
end;

procedure TMOC3D_Writer.WriteCRECH(const StressPeriod: integer);
var
  CRECH : array of array of double;
  ColCount : integer;
  RowCount : integer;
  Value : double;
  Col, Row : integer;
  ModelHandle, GridLayerHandle : ANE_PTR;
//  GridLayer : TLayerOptions;
//  UnitIndex : integer;
  ParameterName : string;
//  ParameterIndex : ANE_INT16;
  RowIndex, ColIndex : integer;
  BlockIndex : ANE_INT32;
  Block : TBlockObjectOptions;
//  DivIndex : integer;
  RechargeLayerName : string;
  RechargeConcLayer : TLayerOptions;
  X, Y : ANE_DOUBLE;
  AValue : double;
begin
  ModelHandle := frmModflow.CurrentModelHandle;
  GridLayerHandle := DisWriter.GridLayerHandle;
  RechargeLayerName := ModflowTypes.GetMOCRechargeConcLayerType.ANE_LayerName;

  ColCount := ISCOL2 - ISCOL1 + 1;
  RowCount := ISROW2 - ISROW1 + 1;
//  GridLayer := TLayerOptions.Create(GridLayerHandle);
  RechargeConcLayer := TLayerOptions.
    CreateWithName(RechargeLayerName,ModelHandle);
  try
    SetLength(CRECH, ColCount, RowCount);
{    for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
    begin
      if frmMODFLOW.Simulated(UnitIndex) then
      begin    }
        ParameterName := ModflowTypes.GetMFRechConcParamType.
          ANE_ParamName + IntToStr(StressPeriod);
//        ParameterIndex := GridLayer.GetParameterIndex(ModelHandle,ParameterName);
        Row := -1;
        for RowIndex := ISROW1 to ISROW2 do
        begin
          Inc(Row);
          Col := -1;
          for ColIndex := ISCOL1 to ISCOL2 do
          begin
            Inc(Col);
            BlockIndex := DisWriter.BlockIndex(RowIndex-1,ColIndex-1);
            Block := TBlockObjectOptions.Create(ModelHandle,GridLayerHandle,
              BlockIndex);
            try
            Block.GetCenter(ModelHandle, X, Y);
            AValue := RechargeConcLayer.RealValueAtXY(ModelHandle, X, Y,ParameterName);
            CRECH[Col,Row] := AValue;
            finally
              Block.Free;
            end;
          end;
        end;
//        for DivIndex := 1 to frmMODFLOW.DiscretizationCount(UnitIndex) do
//        begin
          WriteU2DRELHeader;
          for Row := 0 to RowCount - 1 do
          begin
            for Col := 0 to ColCount - 1 do
            begin
              Value:= CRECH[Col,Row];
              Write(FFile, FreeFormattedReal(Value));
            end;
            WriteLn(FFile);
          end;

//        end;
{      end;
    end;   }
  finally
//    GridLayer.Free(ModelHandle);
    RechargeConcLayer.Free(ModelHandle);
  end;
end;

procedure TMOC3D_Writer.WriteLayerParameter(const LayerName,
  ParameterName : string; LayersPerUnit : integer; Comment: string = '');
var
  Values : array of array of double;
  LayerIndex : integer;
  ColCount, RowCount : integer;
begin
  ColCount := ISCOL2 - ISCOL1 + 1;
  RowCount := ISROW2 - ISROW1 + 1;
  SetLength(Values, ColCount, RowCount);
  SetLayerParameter(LayerName, ParameterName, Values);

  for LayerIndex := 1 to LayersPerUnit do
  begin
    WriteArray(Values, Comment);
  end;
end;

procedure TMOC3D_Writer.WriteINCRCH(const StressPeriod: integer);
var
  INCRCH : integer;
begin
  if StressPeriod = 1 then
  begin
    INCRCH := 0;
  end
  else
  begin
    INCRCH := -frmModflow.comboMOC3DReadRech.ItemIndex;
  end;
  WriteLn(FFile, INCRCH);
  If INCRCH >= 0 then
  begin
    WriteCRECH(StressPeriod);
  end;
end;

procedure TMOC3D_Writer.WriteMOC3DObservations(const Root: string);
var
  FileName  : string;
begin
  if frmModflow.cbExpOBS.Checked then
  begin
    FileName := GetCurrentDir + '\' + Root + rsMObs;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      EvaluateObservations(DisWriter, BasWriter);
      ObservationList.Write(self);
    finally
      CloseFile(FFile);
    end;
  end;
end;

procedure TMOC3D_Writer.EvaluateObservations(const DiscretizationWriter :
      TDiscretizationWriter; const BasicPkgWriter : TBasicPkgWriter);
var
  LayerName : string;
  ObservationLayer : TLayerOptions;
  ObservationElevationIndicies : array[1..MaxObsWellParameters] of ANE_INT32;
  IsObservationIndicies : array[1..MaxObsWellParameters] of ANE_INT32;
  Elevation : array[1..MaxObsWellParameters] of ANE_DOUBLE;
  IsObservation : array[1..MaxObsWellParameters] of ANE_BOOL;
  ParameterIndex : integer;
  ParameterName : string;
  ContourCount : ANE_INT32;
  ContourIndex : ANE_INT32;
  AContour : TContourObjectOptions;
  ObservationRecord : TMoc3dObservationRecord;
  CellIndex : integer;
  AnElevation : double;
begin
  frmProgress.lblPackage.Caption := 'MF2K_GWT';

  DisWriter := DiscretizationWriter;
  BasWriter := BasicPkgWriter;
  Assert((DisWriter <> nil) and (BasWriter <> nil));

  ObservationList.Clear;
  LayerName := ModflowTypes.GetMOCObsWellLayerType.WriteNewRoot;
  AddVertexLayer(frmModflow.CurrentModelHandle,LayerName);
  ObservationLayer := TLayerOptions.CreateWithName(LayerName,frmModflow.CurrentModelHandle);
  try
    for ParameterIndex := 1 to MaxObsWellParameters do
    begin
      ParameterName := ModflowTypes.GetMFMOCObsElevParamType.ANE_ParamName
        + IntToStr(ParameterIndex);
      ObservationElevationIndicies[ParameterIndex] := ObservationLayer.
        GetParameterIndex(frmModflow.CurrentModelHandle,ParameterName);

      ParameterName := ModflowTypes.GetMFMOC_IsObservationParamType.
        ANE_ParamName + IntToStr(ParameterIndex);
      IsObservationIndicies[ParameterIndex] := ObservationLayer.
        GetParameterIndex(frmModflow.CurrentModelHandle,ParameterName);
    end;
    ContourCount := ObservationLayer.NumObjects(frmModflow.CurrentModelHandle,
      pieContourObject);
    for ContourIndex := 0 to ContourCount-1 do
    begin
      AContour := TContourObjectOptions.Create(frmModflow.CurrentModelHandle,
        ObservationLayer.LayerHandle, ContourIndex);
      try
        for ParameterIndex := 1 to MaxObsWellParameters do
        begin
          IsObservation[ParameterIndex] := AContour.
            GetBoolParameter(frmModflow.CurrentModelHandle,
            IsObservationIndicies[ParameterIndex]);
          if IsObservation[ParameterIndex] then
          begin
            Elevation[ParameterIndex] := AContour.
              GetFloatParameter(frmModflow.CurrentModelHandle,
              ObservationElevationIndicies[ParameterIndex]);
          end;
        end;

        for CellIndex := 0 to GGetCountOfACellList(ContourIndex) -1 do
        begin
          ObservationRecord.Row := GGetCellRow(ContourIndex, CellIndex);
          ObservationRecord.Column := GGetCellColumn(ContourIndex, CellIndex);
          for ParameterIndex := 1 to MaxObsWellParameters do
          begin
            if IsObservation[ParameterIndex] then
            begin
              AnElevation := Elevation[ParameterIndex];
              ObservationRecord.Layer := DisWriter.ElevationToLayer
                (ObservationRecord.Column, ObservationRecord.Row, AnElevation);
              ObservationList.Add(ObservationRecord);
            end;
          end;
        end;

      finally
        AContour.Free;
      end;

    end;


  finally
    ObservationLayer.Free(frmModflow.CurrentModelHandle);
  end;


end;

{ TMoc3dObservation }

procedure TMoc3dObservation.WriteObservation(
  MOC3D_Writer: TMOC3D_Writer; Index : integer);
var
  UnitNumber : integer;
  FileExtension : string;
begin
  Assert(Index > 0);
  FileExtension := 'OBA' + IntToStr(Index);
  UnitNumber := frmModflow.GetUnitNumber(FileExtension);
  WriteObservationWithUnitNumber(MOC3D_Writer,UnitNumber);
end;

procedure TMoc3dObservation.WriteObservationWithUnitNumber(
  MOC3D_Writer: TMOC3D_Writer; UnitNumber: integer);
begin
  WriteLn(MOC3D_Writer.FFile, Observation.Layer, ' ', Observation.Row, ' ',
    Observation.Column, ' ', UnitNumber);
end;

{ TObservationList }

function TObservationList.Add(
  ObservationRecord: TMoc3dObservationRecord): integer;
var
  ObservatonObject : TMoc3dObservation;
  Index : integer;
begin
  for Index := 0 to Count -1 do
  begin
    ObservatonObject := Items[Index] as TMoc3dObservation;
    With ObservatonObject do
    begin
    if (Observation.Layer = ObservationRecord.Layer) and
       (Observation.Row = ObservationRecord.Row) and
       (Observation.Column = ObservationRecord.Column) then
       begin
         result := Index;
         Exit;
       end;
    end;
  end;

  ObservatonObject := TMoc3dObservation.Create;
  result := Add(ObservatonObject);
  ObservatonObject.Observation := ObservationRecord;
end;

procedure TObservationList.Write(MOC3D_Writer: TMOC3D_Writer);
var
  UnitNumber : integer;
  Index : integer;
  Moc3dObservation : TMoc3dObservation;
begin
  if frmModflow.comboMOC3DSaveWell.ItemIndex > 0 then
  begin
    UnitNumber := frmModflow.GetUnitNumber('OBA');
    WriteLn(MOC3D_Writer.FFile,Count, ' ',1);
    for Index := 0 to Count -1 do
    begin
      Moc3dObservation := Items[Index] as TMoc3dObservation;
      Moc3dObservation.WriteObservationWithUnitNumber(MOC3D_Writer,UnitNumber);
    end;
  end
  else
  begin
    WriteLn(MOC3D_Writer.FFile,Count, ' ',0);
    for Index := 0 to Count -1 do
    begin
      Moc3dObservation := Items[Index] as TMoc3dObservation;
      Moc3dObservation.WriteObservation(MOC3D_Writer,Index+1);
    end;
  end;

end;

constructor TMOC3D_Writer.Create;
begin
  inherited;
  ObservationList := TObservationList.Create;
end;

destructor TMOC3D_Writer.Destroy;
begin
  ObservationList.Free;
  inherited;
end;

function TMOC3D_Writer.NumberOfObservations: integer;
begin
  result := ObservationList.Count;
end;

procedure TMOC3D_Writer.WriteAgeFile(const Root: string);
var
  FileName : String;
  AGER8 : double;
begin
  if frmModflow.cbAge.Checked then
  begin
    FileName := GetCurrentDir + '\' + Root + rsAge;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      AGER8 := InternationalStrToFloat(frmModflow.adeAge.Text);
      WriteLn(FFile,AGER8);

    finally
      CloseFile(FFile);
    end;
  end;
end;

procedure TMOC3D_Writer.WriteDoublePorosityFile(const Root: string);
var
  FileName : String;
begin
  if frmModflow.cbDualPorosity.Checked
    and frmModflow.cbUseDualPorosity.Checked  then
  begin
    FileName := GetCurrentDir + '\' + Root + rsDp;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDP_DataSet1;
      WriteDP_DataSets2and3;
      WriteDP_DataSets4to6;
    finally
      CloseFile(FFile);
    end;
  end;
end;

procedure TMOC3D_Writer.WriteDP_DataSet1;
var
  IDPPS : integer;
begin
  with frmModflow do
  begin
    if cbIDPFO.Checked then
    begin
      IDPFO := 1;
    end
    else
    begin
      IDPFO := 0;
    end;

    if cbIDPZO.Checked then
    begin
      IDPZO := 1;
    end
    else
    begin
      IDPZO := 0;
    end;

    if cbIDPTIM_Decay.Checked or cbIDPTIM_Growth.Checked then
    begin
      IDPTIM := 1;
    end
    else
    begin
      IDPTIM := 0;
    end;

    IDPPS := comboDualPOutOption.ItemIndex + 1;

  end;
  writeLn(FFile, IDPFO, ' ', IDPZO, ' ', IDPTIM, ' ', IDPPS);
end;

procedure TMOC3D_Writer.WriteDP_DataSets2and3;
var
  UnitIndex : integer;
  DivIndex : integer;
//  ModelHandle, GridLayerHandle : ANE_PTR;
//  RowIndex, ColIndex : integer;
//  BlockIndex : ANE_INT32;
//  Block : TBlockObjectOptions;
//  X, Y : ANE_DOUBLE;
//  Conc,Porosity : ANE_DOUBLE;
  Concentrations : array of array of double;
  PorosityValues : array of array of double;
  ColCount : integer;
  RowCount : integer;
//  Row : integer;
//  Col : integer;
  ConcLayerName : string;
  PorosityLayerName : string;
  ConcParameterName : string;
  PorosityParameterName : string;
//  ImmobInitConcLayer : TLayerOptions;
//  ImmobPorosityLayer : TLayerOptions;
begin
//  ModelHandle := frmModflow.CurrentModelHandle;
//  GridLayerHandle := DisWriter.GridLayerHandle;

  ColCount := ISCOL2 - ISCOL1 + 1;
  RowCount := ISROW2 - ISROW1 + 1;
  SetLength(Concentrations, ColCount, RowCount);
  SetLength(PorosityValues, ColCount, RowCount);

  for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
  begin
    if frmModflow.Simulated(UnitIndex) then
    begin

      ConcLayerName := ModflowTypes.GetMFMOCImInitConcLayerType.ANE_LayerName
        + IntToStr(UnitIndex);
{      ImmobInitConcLayer := TLayerOptions.
        CreateWithName(LayerName,ModelHandle);   }

      PorosityLayerName := ModflowTypes.GetMFMOCImPorosityLayerType.ANE_LayerName
        + IntToStr(UnitIndex);
{      ImmobPorosityLayer := TLayerOptions.
        CreateWithName(LayerName,ModelHandle); }

      ConcParameterName := ModflowTypes.GetMFMOCImInitConcParamType.ANE_ParamName + IntToStr(UnitIndex);
      PorosityParameterName := ModflowTypes.GetMFMOCImPorosityParamType.ANE_ParamName + IntToStr(UnitIndex);

      SetLayerParameter(ConcLayerName, ConcParameterName, Concentrations);
      SetLayerParameter(PorosityLayerName, PorosityParameterName, PorosityValues);

{      Row := -1;
      for RowIndex := ISROW1 to ISROW2 do
      begin
        Inc(Row);
        Col := -1;
        for ColIndex := ISCOL1 to ISCOL2 do
        begin
          Inc(Col);
          BlockIndex := DisWriter.BlockIndex(RowIndex-1,ColIndex-1);
          Block := TBlockObjectOptions.Create(ModelHandle,GridLayerHandle,
            BlockIndex);
          try
            Block.GetCenter(ModelHandle, X, Y);
            Conc := ImmobInitConcLayer.RealValueAtXY(ModelHandle, X, Y,ConcParameterName);
            Porosity := ImmobPorosityLayer.RealValueAtXY(ModelHandle, X, Y,PorosityParameterName);
            Concentrations[Col,Row] := Conc;
            PorosityValues[Col,Row] := Porosity;
          finally
            Block.Free;
          end;
        end;
      end;}
      for DivIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
      begin
        WriteArray(Concentrations);
        WriteArray(PorosityValues);
{        WriteU2DRELHeader;
        for Row := 0 to RowCount -1 do
        begin
          for Col := 0 to ColCount-1 do
          begin
            Conc := Concentrations[Col,Row];
            Write(FFile, FreeFormattedReal(Conc));
          end;
          WriteLn(FFile);
        end;

        WriteU2DRELHeader;
        for Row := 0 to RowCount -1 do
        begin
          for Col := 0 to ColCount-1 do
          begin
            Porosity := PorosityValues[Col,Row];
            Write(FFile, FreeFormattedReal(Porosity));
          end;
          WriteLn(FFile);
        end; }
      end;

    end;
  end;

end;

procedure TMOC3D_Writer.WriteDP_DataSets4to6;
var
  StressPeriod : integer;
  ImmobExchangeCoeff : array of array of double;
  ImmobDecayCoeff : array of array of double;
  ImmobGrowthRate : array of array of double;
  ImmobExchangeCoeffLayerName : string;
  ImmobDecayCoeffLayerName : string;
  ImmobGrowthRateLayerName : string;
  ImmobExchangeCoeffParameterName : string;
  ImmobDecayCoeffParameterName : string;
  ImmobGrowthRateParameterName : string;
  ImmobExchangeCoeffParameterRoot : string;
  ImmobDecayCoeffParameterRoot : string;
  ImmobGrowthRateParameterRoot : string;
  ColCount, RowCount : integer;
  procedure WriteArrays;
  var
    UnitIndex, DivIndex : integer;
  begin
    for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        ImmobExchangeCoeffLayerName := ModflowTypes.
          GetMFMOCLinExchCoefLayerType.ANE_LayerName + IntToStr(UnitIndex);
        ImmobDecayCoeffLayerName := ModflowTypes.
          GetMFMOCDecayCoefLayerType.ANE_LayerName + IntToStr(UnitIndex);
        ImmobGrowthRateLayerName := ModflowTypes.
          GetMFMOCGrowthLayerType.ANE_LayerName + IntToStr(UnitIndex);

        if (StressPeriod = 1) or frmModflow.cbIDPTIM_LinExch.Checked then
        begin
          SetLayerParameter(ImmobExchangeCoeffLayerName,
            ImmobExchangeCoeffParameterName, ImmobExchangeCoeff);
        end;

        if IDPFO = 1 then
        begin
          if (StressPeriod = 1) or frmModflow.cbIDPTIM_Decay.Checked then
          begin
            SetLayerParameter(ImmobDecayCoeffLayerName,
              ImmobDecayCoeffParameterName, ImmobDecayCoeff);
          end;
        end;

        if IDPZO = 1 then
        begin
          if (StressPeriod = 1) or frmModflow.cbIDPTIM_Growth.Checked then
          begin
            SetLayerParameter(ImmobGrowthRateLayerName,
              ImmobGrowthRateParameterName, ImmobGrowthRate);
          end;
        end;

        for DivIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
        begin
          WriteArray(ImmobExchangeCoeff);
          if IDPFO = 1 then
          begin
            WriteArray(ImmobDecayCoeff);
          end;

          if IDPZO = 1 then
          begin
            WriteArray(ImmobGrowthRate);
          end;
        end;

      end;
    end;
  end;
begin
  ColCount := ISCOL2 - ISCOL1 + 1;
  RowCount := ISROW2 - ISROW1 + 1;
  SetLength(ImmobExchangeCoeff, ColCount, RowCount);
  SetLength(ImmobDecayCoeff, ColCount, RowCount);
  SetLength(ImmobGrowthRate, ColCount, RowCount);

  ImmobExchangeCoeffParameterRoot := ModflowTypes.
    GetMFMOCLinExchCoefParamType.ANE_ParamName;
  ImmobDecayCoeffParameterRoot := ModflowTypes.
    GetMFMOCDecayCoefParamType.ANE_ParamName;
  ImmobGrowthRateParameterRoot := ModflowTypes.
    GetMFMOCGrowthParamType.ANE_ParamName;
  if IDPTIM = 1 then
  begin
    for StressPeriod := 1 to frmModflow.dgTime.RowCount -1 do
    begin
      if frmModflow.cbIDPTIM_LinExch.Checked then
      begin
        ImmobExchangeCoeffParameterName := ImmobExchangeCoeffParameterRoot
          + IntToStr(StressPeriod);
      end
      else
      begin
        ImmobExchangeCoeffParameterName := ImmobExchangeCoeffParameterRoot;
      end;

      if frmModflow.cbIDPTIM_Decay.Checked then
      begin
        ImmobDecayCoeffParameterName := ImmobDecayCoeffParameterRoot
          + IntToStr(StressPeriod);
      end
      else
      begin
        ImmobDecayCoeffParameterName := ImmobDecayCoeffParameterRoot;
      end;

      if frmModflow.cbIDPTIM_Growth.Checked then
      begin
        ImmobGrowthRateParameterName := ImmobGrowthRateParameterRoot
          + IntToStr(StressPeriod);
      end
      else
      begin
        ImmobGrowthRateParameterName := ImmobGrowthRateParameterRoot;
      end;

      WriteArrays;
    end;
  end
  else
  begin
      ImmobExchangeCoeffParameterName := ImmobExchangeCoeffParameterRoot;
      ImmobDecayCoeffParameterName := ImmobDecayCoeffParameterRoot;
      ImmobGrowthRateParameterName := ImmobGrowthRateParameterRoot;

      StressPeriod := 1;
      WriteArrays;
  end;
end;

procedure TMOC3D_Writer.SetLayerParameter(const LayerName,
  ParameterName: string; Dynamic2D_Array: pointer);
var
  ModelHandle, GridLayerHandle : ANE_PTR;
  RowIndex, ColIndex : integer;
  BlockIndex : ANE_INT32;
  Block : TBlockObjectOptions;
  Layer : TLayerOptions;
  X, Y : ANE_DOUBLE;
  AValue : ANE_DOUBLE;
  Values : array of array of double;
  ColCount : integer;
  RowCount : integer;
  Row : integer;
  Col : integer;
begin
  Values := Dynamic2D_Array;
  ModelHandle := frmModflow.CurrentModelHandle;
  GridLayerHandle := DisWriter.GridLayerHandle;

  ColCount := ISCOL2 - ISCOL1 + 1;
  RowCount := ISROW2 - ISROW1 + 1;
  Assert(Length(Values) = ColCount);
  if ColCount > 0 then
  begin
    Assert(Length(Values[0]) = RowCount);
  end;
//  SetLength(Values, ColCount, RowCount);

  Layer := TLayerOptions.
    CreateWithName(LayerName,ModelHandle);
  try
    Row := -1;
    for RowIndex := ISROW1 to ISROW2 do
    begin
      Inc(Row);
      Col := -1;
      for ColIndex := ISCOL1 to ISCOL2 do
      begin
        Inc(Col);
        BlockIndex := DisWriter.BlockIndex(RowIndex-1,ColIndex-1);
        Block := TBlockObjectOptions.Create(ModelHandle,GridLayerHandle,
          BlockIndex);
        try
          Block.GetCenter(ModelHandle, X, Y);
          AValue := Layer.RealValueAtXY(ModelHandle, X, Y,ParameterName);
          Values[Col,Row] := AValue;
        finally
          Block.Free;
        end;
      end;
    end;
{    for LayerIndex := 1 to LayersPerUnit do
    begin
      WriteU2DRELHeader;
      for Row := 0 to RowCount -1 do
      begin
        for Col := 0 to ColCount-1 do
        begin
          AValue := Values[Col,Row];
          Write(FFile, FreeFormattedReal(AValue));
        end;
        WriteLn(FFile);
      end;
    end; }
  finally
    Layer.Free(ModelHandle);
  end;
end;

procedure TMOC3D_Writer.WriteArray(Dynamic2D_Array: pointer; Comment: string = '');
var
  AValue : ANE_DOUBLE;
  Values : array of array of double;
  ColCount : integer;
  RowCount : integer;
  Row : integer;
  Col : integer;
begin
  Values := Dynamic2D_Array;

  ColCount := ISCOL2 - ISCOL1 + 1;
  RowCount := ISROW2 - ISROW1 + 1;

  Assert(Length(Values) = ColCount);
  if ColCount > 0 then
  begin
    Assert(Length(Values[0]) = RowCount);
  end;

  WriteU2DRELHeader(Comment);
  for Row := 0 to RowCount -1 do
  begin
    for Col := 0 to ColCount-1 do
    begin
      AValue := Values[Col,Row];
      Write(FFile, FreeFormattedReal(AValue));
    end;
    WriteLn(FFile);
  end;
end;

procedure TMOC3D_Writer.WriteSimpleReactionsFile(const Root: string);
var
  FileName : String;
begin
  if frmModflow.cbSimpleReactions.Checked
    and frmModflow.cbUseSimpleReactions.Checked then
  begin
    FileName := GetCurrentDir + '\' + Root + rsDk;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteSR_DataSet1;
      WriteSR_DataSet2;
      WriteSR_DataSets3to6;
    finally
      CloseFile(FFile);
    end;
  end;
end;

procedure TMOC3D_Writer.WriteSR_DataSet1;
begin
  with frmModflow do
  begin
    if cbIDKRF.Checked then
    begin
      IDKRF := 1;
    end
    else
    begin
      IDKRF := 0;
    end;

    if cbIDKTIM_DisDecay.Checked
      or cbIDKTIM_SorbDecay.Checked
      or cbIDKTIM_DisGrowth.Checked
      or cbIDKTIM_SorbGrowth.Checked then
    begin
      IDKTIM := 1;
    end
    else
    begin
      IDKTIM := 0;
    end;

    if cbIDKFO.Checked then
    begin
      IDKFO := 1;
    end
    else
    begin
      IDKFO := 0;
    end;

    if cbIDKFS.Checked then
    begin
      IDKFS := 1;
    end
    else
    begin
      IDKFS := 0;
    end;

    if cbIDKZO.Checked then
    begin
      IDKZO := 1;
    end
    else
    begin
      IDKZO := 0;
    end;

    if cbIDKZS.Checked then
    begin
      IDKZS := 1;
    end
    else
    begin
      IDKZS := 0;
    end;
  end;
  WriteLn(FFile, IDKRF, ' ', IDKTIM, ' ', IDKFO, ' ',
                 IDKFS, ' ', IDKZO, ' ', IDKZS);

end;

procedure TMOC3D_Writer.WriteSR_DataSet2;
var
  UnitIndex : integer;
  LayerName, ParameterName : string;
begin
  if IDKRF = 1 then
  begin
    for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        LayerName := ModflowTypes.GetMFMOCRetardationLayerType.ANE_LayerName
          + IntToStr(UnitIndex);
        ParameterName := ModflowTypes.
          GetMFMOCRetardationParamType.ANE_ParamName + IntToStr(UnitIndex);
        WriteLayerParameter(LayerName,ParameterName,frmModflow.
          DiscretizationCount(UnitIndex), 'DKRF');
      end;
    end;
  end;
end;

procedure TMOC3D_Writer.WriteSR_DataSets3to6;
var
  StressPeriod : integer;
  DecayCoefLayerName : string;
  DecayCoefParameterName : string;
  SorbedDecayCoefLayerName : string;
  SorbedDecayCoefParameterName : string;
  GrowthRateLayerName : string;
  GrowthRateParameterName : string;
  SorbedGrowthRateLayerName : string;
  SorbedGrowthRateParameterName : string;

  DecayCoefParameterRoot : string;
  SorbedDecayCoefParameterRoot : string;
  GrowthRateParameterRoot : string;
  SorbedGrowthRateParameterRoot : string;
  TimeString : string;
  DecayCoef : array of T2DDynamicArray;
  SorbedDecayCoef : array of T2DDynamicArray;
  GrowthRate : array of T2DDynamicArray;
  SorbedGrowthRate : array of T2DDynamicArray;
  UnitCount : integer;
  UnitI : integer;
  ColCount, RowCount : integer;
  procedure WriteArrays;
  var
    UnitIndex, DivIndex : integer;
  begin
    UnitI := -1;
    for UnitIndex := FirstMoc3dUnit to LastMoc3dUnit do
    begin
      if frmModflow.Simulated(UnitIndex) then
      begin
        Inc(UnitI);

        DecayCoefLayerName := ModflowTypes.
          GetMFMOCDisDecayCoefLayerType.ANE_LayerName + IntToStr(UnitIndex);
        SorbedDecayCoefLayerName := ModflowTypes.
          GetMFMOCSorbDecayCoefLayerType.ANE_LayerName + IntToStr(UnitIndex);
        GrowthRateLayerName := ModflowTypes.
          GetMFMOCDisGrowthLayerType.ANE_LayerName + IntToStr(UnitIndex);
        SorbedGrowthRateLayerName := ModflowTypes.
          GetMFMOCSorbGrowthLayerType.ANE_LayerName + IntToStr(UnitIndex);

        if (StressPeriod = 1) or frmModflow.cbIDKTIM_DisDecay.Checked then
        begin
          if IDKFO = 1 then
          begin
            SetLength(DecayCoef[UnitI], ColCount, RowCount);
            SetLayerParameter(DecayCoefLayerName,
              DecayCoefParameterName, DecayCoef[UnitI]);
          end;
        end;
        if (StressPeriod = 1) or frmModflow.cbIDKTIM_DisGrowth.Checked then
        begin
          if IDKZO = 1 then
          begin
            SetLength(GrowthRate[UnitI], ColCount, RowCount);
            SetLayerParameter(GrowthRateLayerName,
              GrowthRateParameterName, GrowthRate[UnitI]);
          end;
        end;
        if (StressPeriod = 1) or frmModflow.cbIDKTIM_SorbDecay.Checked then
        begin
          if IDKFS = 1 then
          begin
            SetLength(SorbedDecayCoef[UnitI], ColCount, RowCount);
            SetLayerParameter(SorbedDecayCoefLayerName,
              SorbedDecayCoefParameterName, SorbedDecayCoef[UnitI]);
          end;
        end;
        if (StressPeriod = 1) or frmModflow.cbIDKTIM_SorbGrowth.Checked then
        begin
          if IDKZS = 1 then
          begin
            SetLength(SorbedGrowthRate[UnitI], ColCount, RowCount);
            SetLayerParameter(SorbedGrowthRateLayerName,
              SorbedGrowthRateParameterName, SorbedGrowthRate[UnitI]);
          end;
        end;

        for DivIndex := 1 to frmModflow.DiscretizationCount(UnitIndex) do
        begin
          if IDKFO = 1 then
          begin
            WriteArray(DecayCoef[UnitI], 'DKFO');
          end;
          if IDKFS = 1 then
          begin
            WriteArray(SorbedDecayCoef[UnitI], 'DKFS');
          end;
          if IDKZO = 1 then
          begin
            WriteArray(GrowthRate[UnitI], 'DKZO');
          end;
          if IDKZS = 1 then
          begin
            WriteArray(SorbedGrowthRate[UnitI], 'DKZS');
          end;
        end;


      end;

    end;
  end;
begin
  UnitCount := LastMoc3dUnit - FirstMoc3dUnit + 1;
  ColCount := ISCOL2 - ISCOL1 + 1;
  RowCount := ISROW2 - ISROW1 + 1;
  SetLength(DecayCoef,UnitCount);
  SetLength(SorbedDecayCoef,UnitCount);
  SetLength(GrowthRate,UnitCount);
  SetLength(SorbedGrowthRate,UnitCount);

  DecayCoefParameterRoot := ModflowTypes.
    GetMFMOCDisDecayCoefParamType.ANE_ParamName;

  SorbedDecayCoefParameterRoot := ModflowTypes.
    GetMFMOCSorbDecayCoefParamType.ANE_ParamName;

  GrowthRateParameterRoot := ModflowTypes.
    GetMFMOCDisGrowthParamType.ANE_ParamName;

  SorbedGrowthRateParameterRoot := ModflowTypes.
    GetMFMOCSorbGrowthParamType.ANE_ParamName;
  if IDKTIM = 1 then
  begin
    for StressPeriod := 1 to frmModflow.dgTime.RowCount -1 do
    begin
      TimeString := IntToStr(StressPeriod);

      if frmModflow.cbIDKTIM_DisDecay.Checked then
      begin
        DecayCoefParameterName := DecayCoefParameterRoot + TimeString;
      end
      else
      begin
        DecayCoefParameterName := DecayCoefParameterRoot;
      end;

      if frmModflow.cbIDKTIM_DisGrowth.Checked then
      begin
        GrowthRateParameterName := GrowthRateParameterRoot + TimeString;
      end
      else
      begin
        GrowthRateParameterName := GrowthRateParameterRoot;
      end;

      if frmModflow.cbIDKTIM_SorbDecay.Checked then
      begin
        SorbedDecayCoefParameterName := SorbedDecayCoefParameterRoot + TimeString;
      end
      else
      begin
        SorbedDecayCoefParameterName := SorbedDecayCoefParameterRoot;
      end;

      if frmModflow.cbIDKTIM_SorbGrowth.Checked then
      begin
        SorbedGrowthRateParameterName := SorbedGrowthRateParameterRoot + TimeString;
      end
      else
      begin
        SorbedGrowthRateParameterName := SorbedGrowthRateParameterRoot;
      end;
      WriteArrays;
    end;
  end
  else
  begin
    DecayCoefParameterName := DecayCoefParameterRoot;
    GrowthRateParameterName := GrowthRateParameterRoot;
    SorbedDecayCoefParameterName := SorbedDecayCoefParameterRoot;
    SorbedGrowthRateParameterName := SorbedGrowthRateParameterRoot;
    StressPeriod := 1;
    WriteArrays
  end;

end;

procedure TMOC3D_Writer.WriteStartingStressPeriodFile(const Root: string);
var
  IPERGWT: integer;
  FileName: string;
begin
  IPERGWT := StrToInt(frmModflow.adeStartTransportStressPeriod.Text);
  if IPERGWT > 1 then
  begin
    FileName := GetCurrentDir + '\' + Root + rsSSTR;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteLn(FFile, IPERGWT);
    finally
      CloseFile(FFile);
    end;
  end;

end;

procedure TMOC3D_Writer.WritePRTP_File(const Root: string);
var
  FileName: string;
begin
  if frmModflow.cbAdjustParticleLocations.Enabled
    and frmModflow.cbAdjustParticleLocations.Checked then
  begin
    FileName := GetCurrentDir + '\' + Root + rsPRTP;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      // The file must exist but it can be empty.
    finally
      CloseFile(FFile);
    end;
  end;
end;

end.
