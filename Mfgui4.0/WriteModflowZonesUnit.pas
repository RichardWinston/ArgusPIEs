unit WriteModflowZonesUnit;

interface

uses Windows, Sysutils, Classes, Forms, ANEPIE, WriteModflowDiscretization;

type
  TZoneWriter = class(TModflowWriter)
  private
    FZoneCount : integer;
    FZoneArray: array of array of array of Integer;
    FTempFileName: string;
    FCachedZoneArrayIndex: integer;
    FCachedArray: array of array of integer;
//    ZoneArray : array of array of array of Integer;
    Procedure WriteDataSet1(Discretization: TDiscretizationWriter);
    procedure WriteZoneName(RowIndex : integer);
    procedure WriteZoneArray(CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter; ZoneArrayIndex : integer);
    procedure SetArraySize(Discretization : TDiscretizationWriter);
    procedure SetZoneCount;
    function SetZoneName (RowIndex : integer) : String;
    procedure SetZoneArray(CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter; ZoneArrayIndex : integer);
    function GetZoneArrayValue(Col, Row, ZoneArrayIndex: integer): Integer;
    procedure SetZoneArrayValue(Col, Row, ZoneArrayIndex: integer;
      const Value: Integer);
    procedure CacheZoneArray;
  public
    ZoneNames : TStringList;
    property ZoneArray[Col, Row, ZoneArrayIndex: integer]: Integer
      read GetZoneArrayValue write SetZoneArrayValue;
    property ZoneCount : integer read FZoneCount;
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
    procedure EvaluateZones(const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
    Constructor Create;
    Destructor Destroy; override;
  end;

implementation

uses Variables, OptionsUnit, ProgressUnit, WriteNameFileUnit, ZLib, TempFiles;

{ TZoneWriter }

procedure TZoneWriter.CacheZoneArray;
var
  TempFile: TFileStream;
  Compressor: TCompressionStream;
  ZoneCount: integer;
  Index: Integer;
  Columns: Integer;
  Rows: Integer;
  ColIndex: Integer;
  RowIndex: Integer;
  AValue: integer;
begin
  FTempFileName := TempFileName;
  TempFile := TFileStream.Create(FTempFileName, fmCreate or fmShareDenyWrite,
    0);
  Compressor := TCompressionStream.Create(clDefault, TempFile);
  try
    TempFile.Position := 0;

    ZoneCount := Length(FZoneArray);
    Compressor.Write(ZoneCount, SizeOf(ZoneCount));
    if ZoneCount > 0 then
    begin
      Columns := Length(FZoneArray[0]);
      Rows := Length(FZoneArray[0, 0]);
      Compressor.Write(Columns, SizeOf(Columns));
      Compressor.Write(Rows, SizeOf(Rows));
      for Index := 0 to Length(FZoneArray) - 1 do
      begin
        for ColIndex := 0 to Columns - 1 do
        begin
          for RowIndex := 0 to Rows - 1 do
          begin
            AValue := FZoneArray[Index, ColIndex, RowIndex];
            Compressor.Write(AValue, SizeOf(AValue));
          end;
        end;
      end;
    end;
    SetLength(FZoneArray, 0);
  finally
    Compressor.Free;
    TempFile.Free;
  end;
end;

constructor TZoneWriter.Create;
begin
  FCachedZoneArrayIndex := -1;
  ZoneNames := TStringList.Create;
end;

destructor TZoneWriter.Destroy;
begin
  if FileExists(FTempFileName) then
  begin
    DeleteFile(FTempFileName);
  end;
  ZoneNames.Free;
  inherited;
end;

procedure TZoneWriter.EvaluateZones(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization: TDiscretizationWriter);
var
  RowIndex : integer;
begin

  frmProgress.lblPackage.Caption := 'Zone Package';
  frmProgress.pbPackage.Position := 0;
  frmProgress.pbPackage.Max := frmMODFLOW.sgZoneArrays.RowCount -1;
  Application.ProcessMessages;

  SetZoneCount;
  SetArraySize(Discretization);
  frmProgress.pbPackage.Max := frmMODFLOW.sgZoneArrays.RowCount;

  for RowIndex := 1 to frmMODFLOW.sgZoneArrays.RowCount -1 do
  begin
    Application.ProcessMessages;
    if not ContinueExport then break;

    SetZoneName(RowIndex);
    SetZoneArray(CurrentModelHandle, Discretization, RowIndex);

    frmProgress.pbPackage.StepIt;
  end;
  CacheZoneArray;

  frmProgress.pbPackage.StepIt;
  Application.ProcessMessages;

end;

function TZoneWriter.GetZoneArrayValue(Col, Row,
  ZoneArrayIndex: integer): Integer;
var
  TempFile: TFileStream;
  DecompressionStream: TDecompressionStream;
  Index: Integer;
  Columns: Integer;
  Rows: Integer;
  ColIndex: Integer;
  RowIndex: Integer;
  AValue: Integer;
  ZoneCount: integer;
begin
  if ZoneArrayIndex = FCachedZoneArrayIndex then
  begin
    result := FCachedArray[Col, Row];
  end
  else
  begin
    if (Length(FZoneArray) = 0) and (FTempFileName <> '') then
    begin
      FCachedZoneArrayIndex := ZoneArrayIndex;
      TempFile := TFileStream.Create(FTempFileName,
        fmOpenRead or fmShareDenyWrite, 0);
      DecompressionStream := TDecompressionStream.Create(TempFile);
      try
        DecompressionStream.Read(ZoneCount, SizeOf(ZoneCount));
        DecompressionStream.Read(Columns, SizeOf(Columns));
        DecompressionStream.Read(Rows, SizeOf(Rows));
        Assert(ZoneArrayIndex < ZoneCount);
        SetLength(FCachedArray, Columns, Rows);
        for Index := 0 to ZoneArrayIndex-1 do
        begin
          for ColIndex := 0 to Columns - 1 do
          begin
            for RowIndex := 0 to Rows - 1 do
            begin
              DecompressionStream.Read(AValue, SizeOf(AValue));
            end;
          end;
        end;

        for ColIndex := 0 to Columns - 1 do
        begin
          for RowIndex := 0 to Rows - 1 do
          begin
            DecompressionStream.Read(AValue, SizeOf(AValue));
            FCachedArray[ColIndex, RowIndex] := AValue;
          end;
        end;
        result := FCachedArray[Col, Row];

//        for ColIndex := 0 to Col - 1 do
//        begin
//          for RowIndex := 0 to Rows - 1 do
//          begin
//            DecompressionStream.Read(AValue, SizeOf(AValue));
//          end;
//        end;
//        for RowIndex := 0 to Row do
//        begin
//          DecompressionStream.Read(AValue, SizeOf(AValue));
//        end;
//        result := AValue;
      finally
        DecompressionStream.Free;
        TempFile.Free;
      end;
    end
    else
    begin
      result := FZoneArray[ZoneArrayIndex, Col, Row];
    end;
  end;
end;

procedure TZoneWriter.SetArraySize(Discretization: TDiscretizationWriter);
begin
  SetLength(FZoneArray, ZoneCount, Discretization.NCOL, Discretization.NROW);
end;

procedure TZoneWriter.SetZoneArray(CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; ZoneArrayIndex: integer);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  ColIndex, RowIndex : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
begin
  frmProgress.lblActivity.Caption := 'evaluating zone arrays';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;
  Application.ProcessMessages;

  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFGridZoneParamType.WriteParamName
      + IntToStr(ZoneArrayIndex);
    ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);

    for RowIndex := 0 to Discretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to Discretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        BlockIndex := Discretization.BlockIndex(RowIndex, ColIndex);
        ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
          Discretization.GridLayerHandle, BlockIndex);
        try
          ZoneArray[ColIndex,RowIndex,ZoneArrayIndex-1]
            := ABlock.GetIntegerParameter(CurrentModelHandle, ParameterIndex)
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

procedure TZoneWriter.SetZoneArrayValue(Col, Row, ZoneArrayIndex: integer;
  const Value: Integer);
begin
  FZoneArray[ZoneArrayIndex, Col, Row] := Value;
end;

procedure TZoneWriter.SetZoneCount;
begin
  FZoneCount := frmMODFLOW.sgZoneArrays.RowCount -1
end;


function TZoneWriter.SetZoneName(RowIndex: integer): String;
begin
  result := frmMODFLOW.sgZoneArrays.Cells[1,RowIndex];
  ZoneNames.Add(result);
end;

procedure TZoneWriter.WriteDataSet1(Discretization: TDiscretizationWriter);
var
  ErrorString: string;
begin
  SetZoneCount;
  SetArraySize(Discretization);
  if FZoneCount > 500 then
  begin
    ErrorString := 'Warning: you have more than 500 zone arrays.';
    ErrorMessages.Add(ErrorString);
    frmProgress.reErrors.Lines.Add(ErrorString);

    ErrorString := 'The standard version of MODFLOW is limited to '
      + '500 zone arrays.';
    ErrorMessages.Add(ErrorString);
    frmProgress.reErrors.Lines.Add(ErrorString);
  end;
  WriteLn(FFile, FZoneCount);
end;

procedure TZoneWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter);
var
  FileName : String;
  RowIndex : integer;
begin

    frmProgress.lblPackage.Caption := 'Zone Package';
    frmProgress.pbPackage.Position := 0;
    frmProgress.pbPackage.Max := 2 * (frmMODFLOW.sgZoneArrays.RowCount -1);
    Application.ProcessMessages;

    FileName := GetCurrentDir + '\' + Root + rsZone;
    AssignFile(FFile,FileName);
    try
      Rewrite(FFile);
      WriteDataReadFrom(FileName);
      WriteDataSet1(Discretization);
      frmProgress.pbPackage.Max := frmMODFLOW.sgZoneArrays.RowCount;

      for RowIndex := 1 to frmMODFLOW.sgZoneArrays.RowCount -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

        WriteZoneName(RowIndex);
        WriteZoneArray(CurrentModelHandle,
          Discretization, RowIndex);

        Flush(FFile);
        frmProgress.pbPackage.StepIt;
      end;

    finally
      CloseFile(FFile);
    end;
    CacheZoneArray;

    frmProgress.pbPackage.StepIt;
    Application.ProcessMessages;

end;

procedure TZoneWriter.WriteZoneArray(CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; ZoneArrayIndex: integer);
var
  ColIndex, RowIndex : integer;
begin
  SetZoneArray(CurrentModelHandle, Discretization, ZoneArrayIndex);
  frmProgress.lblActivity.Caption := 'writing zone arrays';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;
  Application.ProcessMessages;

    WriteU2DINTHeader;
    for RowIndex := 0 to Discretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for ColIndex := 0 to Discretization.NCOL -1 do
      begin
        Application.ProcessMessages;
        if not ContinueExport then break;

          Write(FFile,
            ZoneArray[ColIndex,RowIndex,ZoneArrayIndex-1],
            ' ');

        frmProgress.pbActivity.StepIt;
      end;
      WriteLn(FFile);
    end;
end;

procedure TZoneWriter.WriteZoneName(RowIndex: integer);
var
  Name : string;
begin
  Name := SetZoneName(RowIndex);
  WriteLN(FFile, Name);
end;

end.
