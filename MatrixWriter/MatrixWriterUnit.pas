unit MatrixWriterUnit;

interface

uses sysutils, AnePIE, ANECB, ParamArrayUnit, OptionsUnit;

procedure InitializeMatrix(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;

procedure WriteRealMatrix(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;

procedure WriteParameterRealMatrix(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;

procedure WriteIntegerMatrix(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;

procedure WriteParameterIntegerMatrix(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;

procedure FreeMatrix(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;

implementation

type
  TStringValue = function(RowIndex,ColIndex : integer) : string of object;

  TMatrixWriter = Class(TObject)
  private
    CurrentModelHandle : ANE_PTR;
    GridLayerHandle : ANE_PTR;
    RowsReversed, ColsReversed: boolean;
    NCOL, NROW : ANE_INT32;
    ParameterIndex: ANE_INT16;
    StringToEvaluate, ISNumberStringToEvaluate : string;
    CellCenters : array of array of array of ANE_DOUBLE;
    GridLayer : TLayerOptions;
    Procedure GetGrid;
    function BlockIndex(RowIndex, ColIndex: integer): integer;
    procedure SetArraySize;
    procedure GetNumRowsCols;
    Constructor Create(ModelHandle, LayerHandle : ANE_PTR);
    Procedure GetCellCenters;
    function EvalIntegerByLayerHandle(StringToEvaluate: string): ANE_INT32;
    Procedure WriteRealMatrix(ModelHandle: ANE_PTR;
      AStringToEvaluate, FileName : string);
    Procedure WriteParameterRealMatrix(ModelHandle: ANE_PTR;
      FileName : string); overload;
    Procedure WriteParameterRealMatrix(ModelHandle: ANE_PTR;
      ParameterName : String; FileName : string); overload;
    Procedure WriteIntegerMatrix(ModelHandle: ANE_PTR;
      AStringToEvaluate, FileName : string);
    Procedure WriteParameterIntegerMatrix(ModelHandle: ANE_PTR;
      FileName : string); overload;
    Procedure WriteParameterIntegerMatrix(ModelHandle: ANE_PTR;
      ParameterName : String; FileName : string); overload;
    Procedure WriteMatrix(ModelHandle: ANE_PTR; FileName: string;
      AFunction : TStringValue);
    function EvaluateRealString(RowIndex,ColIndex : integer) : string;
    function EvaluateRealParameter(RowIndex,ColIndex : integer) : string;
    function EvaluateIntegerString(RowIndex,ColIndex : integer) : string;
    function EvaluateIntegerParameter(RowIndex,ColIndex : integer) : string;
  end;

var
  FMatrixWriter : TMatrixWriter;
  FilePath  : string;
  Directory : String;



function MatrixWriter(ModelHandle, GridLayerHandle : ANE_PTR) : TMatrixWriter;
begin
  if FMatrixWriter = nil then
  begin
    FMatrixWriter := TMatrixWriter.Create(ModelHandle, GridLayerHandle);
  end;
  result := FMatrixWriter;
end;

procedure FreeMatrixWriter;
begin
  FMatrixWriter.Free;
  FMatrixWriter := nil;
end;

{ TMatrixWriter }

procedure TMatrixWriter.GetGrid;
var
  GridLayer : TLayerOptions;
begin
  GridLayer := TLayerOptions.Create(GridLayerHandle);
  try
    RowsReversed := GridLayer.GridReverseYDirection[CurrentModelHandle];
    ColsReversed := GridLayer.GridReverseXDirection[CurrentModelHandle];
  finally
    GridLayer.Free(CurrentModelHandle);
  end;
end;

function TMatrixWriter.BlockIndex(RowIndex,
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

procedure TMatrixWriter.SetArraySize;
begin
  GetNumRowsCols;
  SetLength(CellCenters, 2, NROW, NCOL);
end;

Function TMatrixWriter.EvalIntegerByLayerHandle(StringToEvaluate : string)
  : ANE_INT32;
var
  STR : ANE_STR;
begin
  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR, StringToEvaluate);
    ANE_EvaluateStringAtLayer(CurrentModelHandle,GridLayerHandle,kPIEInteger,
       STR,@result );
  finally
    FreeMem(STR);
  end;
end;


Procedure TMatrixWriter.GetNumRowsCols;
var
  StringToEvaluate : PChar;  
begin
  StringToEvaluate := 'NumRows()';
  NRow := EvalIntegerByLayerHandle(StringToEvaluate);

  StringToEvaluate := 'NumColumns()';
  NCol := EvalIntegerByLayerHandle(StringToEvaluate);
end;

constructor TMatrixWriter.Create(ModelHandle, LayerHandle: ANE_PTR);
begin
  inherited Create;
  CurrentModelHandle := ModelHandle;
  GridLayerHandle := LayerHandle;
  GetGrid;
  SetArraySize;
  GetCellCenters;
end;

procedure TMatrixWriter.GetCellCenters;
var
  ColIndex, RowIndex : integer;
  ThisBlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  X, Y : ANE_DOUBLE;
begin
  for RowIndex := 0 to NROW -1 do
  begin
    for ColIndex := 0 to NCOL -1 do
    begin
      ThisBlockIndex := BlockIndex(RowIndex, ColIndex);
      ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
        GridLayerHandle, ThisBlockIndex);
      try
        ABlock.GetCenter(CurrentModelHandle, X, Y);
        CellCenters[0,RowIndex,ColIndex] := X;
        CellCenters[1,RowIndex,ColIndex] := Y;
      finally
        ABlock.Free;
      end;
    end;
  end;
end;

procedure TMatrixWriter.WriteRealMatrix(ModelHandle: ANE_PTR;
  AStringToEvaluate, FileName : string);
begin
  CurrentModelHandle := ModelHandle;
  StringToEvaluate := AStringToEvaluate;
  ISNumberStringToEvaluate := 'If(IsNumber(' + StringToEvaluate + '), 1, 0)';
  GridLayer := TLayerOptions.Create(GridLayerHandle);
  try
    WriteMatrix(ModelHandle,FileName,EvaluateRealString);
  finally
    GridLayer.Free(CurrentModelHandle);
  end;
end;


procedure TMatrixWriter.WriteParameterRealMatrix(ModelHandle: ANE_PTR;
  FileName: string);
begin
  CurrentModelHandle := ModelHandle;
  WriteMatrix(ModelHandle, FileName,EvaluateRealParameter);
end;

procedure TMatrixWriter.WriteParameterRealMatrix(ModelHandle: ANE_PTR;
  ParameterName, FileName: string);
var
  GridLayer : TLayerOptions;
begin
  GridLayer := TLayerOptions.Create(GridLayerHandle);
  try
    ParameterIndex := GridLayer.GetParameterIndex(ModelHandle,ParameterName);
    WriteParameterRealMatrix(ModelHandle,FileName);
  finally
    GridLayer.Free(ModelHandle);
  end;
end;

procedure TMatrixWriter.WriteMatrix(ModelHandle: ANE_PTR; FileName: string;
      AFunction : TStringValue);
var
  ColIndex, RowIndex : integer;
  Value : string;
  Count : integer;
  AFile : TextFile;
begin
  CurrentModelHandle := ModelHandle;
  AssignFile(AFile,FileName);
  try
    Rewrite(AFile);
    Count := 0;
    for RowIndex := 0 to NROW -1 do
    begin
      for ColIndex := 0 to NCOL -1 do
      begin
        Value := AFunction(RowIndex,ColIndex);
        Write(AFile, Value);

        Inc(Count);
        if Count = 5 then
        begin
          WriteLn(AFile);
          Count := 0;
        end;
      end;
    end;
    if Count <> 0 then
    begin
      WriteLn(AFile);
    end;
  finally
    CloseFile(AFile);
  end;
end;

function TMatrixWriter.EvaluateRealParameter(RowIndex,
  ColIndex: integer): string;
var
  Value : ANE_DOUBLE;
  ThisBlockIndex : integer;
  ABlock : TBlockObjectOptions;
begin
  ThisBlockIndex := BlockIndex(RowIndex, ColIndex);
  ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
    GridLayerHandle,ThisBlockIndex);
  try
    Value := ABlock.GetFloatParameter(CurrentModelHandle,ParameterIndex);
    result := Format(' %.13e', [Value]);
  finally
    ABlock.Free;
  end;

end;

function TMatrixWriter.EvaluateRealString(RowIndex, ColIndex: integer): string;
var
  X, Y : ANE_DOUBLE;
  Value : ANE_DOUBLE;
begin
  X := CellCenters[0,RowIndex,ColIndex];
  Y := CellCenters[1,RowIndex,ColIndex];
  if GridLayer.IntValueAtXY(CurrentModelHandle,X,Y,ISNumberStringToEvaluate) = 1 then
  begin
    Value := GridLayer.RealValueAtXY(CurrentModelHandle,X,Y,
      StringToEvaluate);
    result := Format(' %.13e', [Value]);
  end
  else
  begin
    result :=  ' NaN';
  end;

end;

procedure TMatrixWriter.WriteIntegerMatrix(ModelHandle: ANE_PTR;
  AStringToEvaluate, FileName: string);
begin
  CurrentModelHandle := ModelHandle;
  StringToEvaluate := AStringToEvaluate;
  ISNumberStringToEvaluate := 'If(IsNumber(' + StringToEvaluate + '), 1, 0)';
  GridLayer := TLayerOptions.Create(GridLayerHandle);
  try
    WriteMatrix(ModelHandle,FileName,EvaluateIntegerString);
  finally
    GridLayer.Free(CurrentModelHandle);
  end;
end;

procedure TMatrixWriter.WriteParameterIntegerMatrix(ModelHandle: ANE_PTR;
  FileName: string);
begin
  CurrentModelHandle := ModelHandle;
  WriteMatrix(ModelHandle, FileName,EvaluateIntegerParameter);
end;

procedure TMatrixWriter.WriteParameterIntegerMatrix(ModelHandle: ANE_PTR;
  ParameterName, FileName: string);
begin
  GridLayer := TLayerOptions.Create(GridLayerHandle);
  try
    ParameterIndex := GridLayer.GetParameterIndex(ModelHandle,ParameterName);
    WriteParameterIntegerMatrix(ModelHandle,FileName);
  finally
    GridLayer.Free(ModelHandle);
  end;
end;

function TMatrixWriter.EvaluateIntegerParameter(RowIndex,
  ColIndex: integer): string;
var
  Value : ANE_INT32;
  ThisBlockIndex : integer;
  ABlock : TBlockObjectOptions;
begin
  ThisBlockIndex := BlockIndex(RowIndex, ColIndex);
  ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
    GridLayerHandle,ThisBlockIndex);
  try
    Value := ABlock.GetIntegerParameter(CurrentModelHandle,ParameterIndex);
    result := Format(' %d', [Value]);
  finally
    ABlock.Free;
  end;
end;

function TMatrixWriter.EvaluateIntegerString(RowIndex,
  ColIndex: integer): string;
var
  X, Y : ANE_DOUBLE;
  Value : ANE_INT32;
begin
  X := CellCenters[0,RowIndex,ColIndex];
  Y := CellCenters[1,RowIndex,ColIndex];
  if GridLayer.IntValueAtXY(CurrentModelHandle,X,Y,ISNumberStringToEvaluate) = 1 then
  begin
    Value := GridLayer.IntValueAtXY(CurrentModelHandle,X,Y,
      StringToEvaluate);
    result := Format(' %d', [Value]);
  end
  else
  begin
    result :=  ' NaN';
  end;

end;

procedure InitializeMatrix(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
var
  LayerName : ANE_STR;
  result : ANE_BOOL;
  param : PParameter_array;
  LayerHandle : ANE_PTR;
begin
  try
    param := @parameters^;
    LayerName :=  param^[0];

    LayerHandle := ANE_LayerGetHandleByName(funHandle, LayerName);

    MatrixWriter(funHandle,LayerHandle);

    result := True;
  except on Exception do
    begin
      result := False;
    end;
  end;

  ANE_BOOL_PTR(reply)^ := result;
end;

procedure WriteRealMatrix(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
var
  StringToEvaluate : ANE_STR;
  result : ANE_BOOL;
  param : PParameter_array;
  FileName : ANE_STR;
begin
  try
    param := @parameters^;
    StringToEvaluate :=  param^[0];
    FileName := param^[1];
    FilePath := Directory + String(FileName);

    if FMatrixWriter = nil then
    begin
      result := False;
    end
    else
    begin
      result := True;
      FMatrixWriter.WriteRealMatrix(funHandle, String(StringToEvaluate),FilePath);
    end

  except on Exception do
    begin
      result := False;
    end;
  end;

  ANE_BOOL_PTR(reply)^ := result;
end;

procedure WriteParameterRealMatrix(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
var
  ParameterName : ANE_STR;
  result : ANE_BOOL;
  param : PParameter_array;
  FileName : ANE_STR;
begin
  try
    param := @parameters^;
    ParameterName :=  param^[0];
    FileName := param^[1];
    FilePath := Directory + String(FileName);

    if FMatrixWriter = nil then
    begin
      result := False;
    end
    else
    begin
      result := True;
      FMatrixWriter.WriteParameterRealMatrix(funHandle, String(ParameterName),FilePath);
    end

  except on Exception do
    begin
      result := False;
    end;
  end;

  ANE_BOOL_PTR(reply)^ := result;
end;

procedure WriteIntegerMatrix(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
var
  StringToEvaluate : ANE_STR;
  result : ANE_BOOL;
  param : PParameter_array;
  FileName : ANE_STR;
begin
  try
    param := @parameters^;
    StringToEvaluate :=  param^[0];
    FileName := param^[1];
    FilePath := Directory + String(FileName);

    if FMatrixWriter = nil then
    begin
      result := False;
    end
    else
    begin
      result := True;
      FMatrixWriter.WriteIntegerMatrix(funHandle, String(StringToEvaluate),FilePath);
    end

  except on Exception do
    begin
      result := False;
    end;
  end;

  ANE_BOOL_PTR(reply)^ := result;
end;

procedure WriteParameterIntegerMatrix(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
var
  ParameterName : ANE_STR;
  result : ANE_BOOL;
  param : PParameter_array;
  FileName : ANE_STR;
begin
  try
    param := @parameters^;
    ParameterName :=  param^[0];
    FileName := param^[1];
    FilePath := Directory + String(FileName);

    if FMatrixWriter = nil then
    begin
      result := False;
    end
    else
    begin
      result := True;
      FMatrixWriter.WriteParameterIntegerMatrix(funHandle, String(ParameterName),FilePath);
    end

  except on Exception do
    begin
      result := False;
    end;
  end;

  ANE_BOOL_PTR(reply)^ := result;
end;

procedure FreeMatrix(const refPtX : ANE_DOUBLE_PTR;
  const refPtY : ANE_DOUBLE_PTR; numParams : ANE_INT16;
  const parameters : ANE_PTR_PTR; funHandle : ANE_PTR; reply : ANE_PTR); cdecl;
var
  result : ANE_BOOL;
begin
  try
    FreeMatrixWriter;

    result := True;
  except on Exception do
    begin
      result := False;
    end;
  end;

  ANE_BOOL_PTR(reply)^ := result;
end;

initialization

finalization
  FMatrixWriter.Free;

end.
