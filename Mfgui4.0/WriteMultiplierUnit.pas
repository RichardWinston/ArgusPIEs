unit WriteMultiplierUnit;

interface

uses Windows, Sysutils, Classes, Forms, ANEPIE, WriteModflowDiscretization;

const FunctionSymbols : array[0..3] of char = ('+', '-', '*', '/');

type
  TMultiplierWriter = class(TModflowWriter)
  private
    FCount : integer;
    FMultipliers: array of array of array of double;
    FTempFileName: string;
    FCachedMultIndex: integer;
    FCachedArray: array of array of double;
    procedure SetCount;
    Procedure WriteDataSet1(Discretization: TDiscretizationWriter);
    procedure SetArraySize(Discretization : TDiscretizationWriter);
    function SetName(RowIndex : integer) : string;
    procedure WriteMultName(RowIndex : integer);
    function SetMultFunction(RowIndex : integer;
      Discretization: TDiscretizationWriter) : string;
    procedure WriteMultFunction(RowIndex : integer;
      Discretization: TDiscretizationWriter);
    function SetMultConstant(Row: integer;
      Discretization: TDiscretizationWriter): double;
    procedure WriteMultConstant(RowIndex : integer;
      Discretization : TDiscretizationWriter);
    procedure SetMultArray(CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter; MultiplierArrayIndex, RowIndex : integer);
    procedure WriteMultArray(CurrentModelHandle: ANE_PTR;
      Discretization : TDiscretizationWriter; MultiplierArrayIndex, RowIndex : integer);
    function GetMultiplier(Col, Row, MultIndex: integer): double;
    procedure SetMultiplier(Col, Row, MultIndex: integer; const Value: double);
    procedure CacheMultiplier;
  public
    Names : TStringList;
    property Multipliers[Col, Row, MultIndex: integer]: double
      read GetMultiplier write SetMultiplier;
    property Count : integer read FCount;
    procedure WriteFile(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
    procedure SetData(
      const CurrentModelHandle: ANE_PTR; Root: string;
      Discretization : TDiscretizationWriter);
    Constructor Create;
    Destructor Destroy; override;
  end;

implementation

uses Variables, OptionsUnit, ProgressUnit, WriteNameFileUnit, UtilityFunctions, 
  TempFiles, ZLib;

{ TMultiplierWriter }

constructor TMultiplierWriter.Create;
begin
  inherited;
  FCachedMultIndex := -1;
  Names := TStringList.Create;
end;

destructor TMultiplierWriter.Destroy;
begin
  if FileExists(FTempFileName) then
  begin
    DeleteFile(FTempFileName);
  end;
  Names.Free;
  inherited;
end;

procedure TMultiplierWriter.CacheMultiplier;
var
  TempFile: TFileStream;
  Compressor: TCompressionStream;
  MultCount: integer;
  Index: Integer;
  Columns: Integer;
  Rows: Integer;
  ColIndex: Integer;
  RowIndex: Integer;
  AValue: Double;
begin
  FTempFileName := TempFileName;
  TempFile := TFileStream.Create(FTempFileName, fmCreate or fmShareDenyWrite,
    0);
  Compressor := TCompressionStream.Create(clDefault, TempFile);
  try
    TempFile.Position := 0;

    MultCount := Length(FMultipliers);
    Compressor.Write(MultCount, SizeOf(MultCount));
    for Index := 0 to Length(FMultipliers) - 1 do
    begin
      Columns := Length(FMultipliers[Index]);
      Rows := Length(FMultipliers[Index, 0]);
      Compressor.Write(Columns, SizeOf(Columns));
      Compressor.Write(Rows, SizeOf(Rows));
      for ColIndex := 0 to Columns - 1 do
      begin
        for RowIndex := 0 to Rows - 1 do
        begin
          AValue := FMultipliers[Index, ColIndex, RowIndex];
          Compressor.Write(AValue, SizeOf(AValue));
        end;
      end;
    end;
    SetLength(FMultipliers, 0);
  finally
    Compressor.Free;
    TempFile.Free;
  end;
end;

function TMultiplierWriter.GetMultiplier(Col, Row, MultIndex: integer): double;
var
  TempFile: TFileStream;
  DecompressionStream: TDecompressionStream;
  MultCount: integer;
  Index: Integer;
  Columns, Rows: integer;
  ColIndex: Integer;
  RowIndex: Integer;
  AValue: double;
begin
  if MultIndex = FCachedMultIndex then
  begin
    if (Length(FCachedArray) = 1) and (Length(FCachedArray[0]) = 1) then
    begin
      result := FCachedArray[0, 0];
    end
    else
    begin
      result := FCachedArray[Col, Row];
    end;
  end
  else
  begin
    if (Length(FMultipliers) = 0) and (FTempFileName <> '') then
    begin
      FCachedMultIndex := MultIndex;
      TempFile := TFileStream.Create(FTempFileName,
        fmOpenRead or fmShareDenyWrite, 0);
      DecompressionStream := TDecompressionStream.Create(TempFile);
      try
        DecompressionStream.Read(MultCount, SizeOf(MultCount));
        Assert(MultIndex < MultCount);
        for Index := 0 to MultIndex-1 do
        begin
          DecompressionStream.Read(Columns, SizeOf(Columns));
          DecompressionStream.Read(Rows, SizeOf(Rows));
          for ColIndex := 0 to Columns - 1 do
          begin
            for RowIndex := 0 to Rows - 1 do
            begin
              DecompressionStream.Read(AValue, SizeOf(AValue));
            end;
          end;
        end;
        DecompressionStream.Read(Columns, SizeOf(Columns));
        DecompressionStream.Read(Rows, SizeOf(Rows));
        SetLength(FCachedArray, Columns, Rows);

        for ColIndex := 0 to Columns - 1 do
        begin
          for RowIndex := 0 to Rows - 1 do
          begin
            DecompressionStream.Read(AValue, SizeOf(AValue));
            FCachedArray[ColIndex, RowIndex] := AValue;
          end;
        end;
        if (Length(FCachedArray) = 1) and (Length(FCachedArray[0]) = 1) then
        begin
          result := FCachedArray[0, 0];
        end
        else
        begin
          result := FCachedArray[Col, Row];
        end;

//        if (Columns = 1) and (Rows = 1) then
//        begin
//          DecompressionStream.Read(AValue, SizeOf(AValue));
//        end
//        else
//        begin
//          for ColIndex := 0 to Col - 1 do
//          begin
//            for RowIndex := 0 to Rows - 1 do
//            begin
//              DecompressionStream.Read(AValue, SizeOf(AValue));
//            end;
//          end;
//          for RowIndex := 0 to Row do
//          begin
//            DecompressionStream.Read(AValue, SizeOf(AValue));
//          end;
//        end;
//        result := AValue;
      finally
        DecompressionStream.Free;
        TempFile.Free;
      end;
    end

    else if (Length(FMultipliers[MultIndex]) = 1) and (Length(FMultipliers[MultIndex, 0]) = 1) then
    begin
      result := FMultipliers[MultIndex, 0, 0];
    end
    else
    begin
      result := FMultipliers[MultIndex, Col, Row];
    end;
  end;
end;

procedure TMultiplierWriter.SetArraySize(
  Discretization: TDiscretizationWriter);
begin
//  SetLength(FMultipliers, Count, Discretization.NCOL, Discretization.NROW);
  SetLength(FMultipliers, Count);
end;

procedure TMultiplierWriter.SetCount;
begin
  FCount := frmMODFLOW.dgMultiplier.RowCount -1;
end;

procedure TMultiplierWriter.SetData(const CurrentModelHandle: ANE_PTR;
  Root: string; Discretization: TDiscretizationWriter);
var
//  FileName : String;
  RowIndex : integer;
  MultiplierArrayIndex : integer;
  Count : integer;
begin
  frmProgress.lblPackage.Caption := 'Multiplier Package';
  Application.ProcessMessages;

{  FileName := GetCurrentDir + '\' + Root + rsMult;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile); }
    SetCount;
    SetArraySize(Discretization);

    MultiplierArrayIndex := 0;

    Count := 0;
    for RowIndex := 1 to frmMODFLOW.dgMultiplier.RowCount -1 do
    begin
      if frmMODFLOW.dgMultiplier.Cells[2,RowIndex] =
        frmMODFLOW.dgMultiplier.Columns[2].PickList[0] then
      begin
        Inc(Count);
      end;
    end;
    frmProgress.pbPackage.Max := Count;
    frmProgress.pbPackage.Position := 0;

    for RowIndex := 1 to frmMODFLOW.dgMultiplier.RowCount -1 do
    begin
      SetName(RowIndex);
      if frmMODFLOW.dgMultiplier.Cells[2,RowIndex] =
        frmMODFLOW.dgMultiplier.Columns[2].PickList[1] then
      begin
        SetMultFunction(RowIndex, Discretization);
      end
      else if frmMODFLOW.dgMultiplier.Cells[2,RowIndex] =
        frmMODFLOW.dgMultiplier.Columns[2].PickList[2] then
      begin
        SetMultConstant(RowIndex, Discretization);
      end
      else
      begin
        Inc(MultiplierArrayIndex);
        SetMultArray(CurrentModelHandle,
          Discretization, MultiplierArrayIndex, RowIndex);
        frmProgress.pbPackage.StepIt;
      end;
    end;
    CacheMultiplier;

{  finally
    CloseFile(FFile);
  end;}
end;

procedure TMultiplierWriter.SetMultArray(CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; MultiplierArrayIndex, RowIndex: integer);
var
  ParameterIndex : ANE_INT16;
  ParameterName : string;
  Col, Row : integer;
  BlockIndex : ANE_INT32;
  ABlock : TBlockObjectOptions;
  GridLayer : TLayerOptions;
begin

  SetLength(FMultipliers[RowIndex-1], Discretization.NCOL, Discretization.NROW); 
  frmProgress.lblActivity.Caption := 'evaluating multiplier array';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;
  Application.ProcessMessages;


  GridLayer := TLayerOptions.Create(Discretization.GridLayerHandle);
  try
    ParameterName := ModflowTypes.GetMFGridMultiplierParamType.WriteParamName
      + IntToStr(MultiplierArrayIndex);
    ParameterIndex := GridLayer.GetParameterIndex(CurrentModelHandle,ParameterName);

//    WriteU2DRELHeader;
    for Row := 0 to Discretization.NROW -1 do
    begin
      Application.ProcessMessages;
      if not ContinueExport then break;

      for Col := 0 to Discretization.NCOL -1 do
      begin
        frmProgress.pbActivity.StepIt;
        Application.ProcessMessages;
        if not ContinueExport then break;

        BlockIndex := Discretization.BlockIndex(Row, Col);
        ABlock := TBlockObjectOptions.Create(CurrentModelHandle,
          Discretization.GridLayerHandle, BlockIndex);
        try
          Multipliers[Col,Row,RowIndex-1] :=
            ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex);
{          Write(FFile,
            ABlock.GetFloatParameter(CurrentModelHandle, ParameterIndex),
            ' ');  }
        finally
          ABlock.Free;
        end;

      end;
//      WriteLn(FFile);
    end;
  finally
    GridLayer.Free(CurrentModelHandle);
  end;

end;

function TMultiplierWriter.SetMultConstant(Row: integer;
  Discretization: TDiscretizationWriter): double;
//var
//  RowIndex, ColIndex : integer;
begin
  SetLength(FMultipliers[Row-1], 1, 1);
  result := InternationalStrToFloat(frmMODFLOW.dgMultiplier.Cells[3,Row]);
//  for ColIndex := 0 to Discretization.NCOL -1 do
//  begin
//    for RowIndex := 0 to Discretization.NROW -1 do
//    begin
      Multipliers[0,0,Row-1] := result;
//    end;
//  end;

end;

function TMultiplierWriter.SetMultFunction(RowIndex: integer;
  Discretization: TDiscretizationWriter): string;
  function SymbolPosition(AString : string; var Operation : integer) : integer;
    var
    Index : integer;
    Symbol : char;
    Position : integer;
  begin
    result := 0;
    for Index := Ord(Low(FunctionSymbols)) to Ord(High(FunctionSymbols)) do
    begin
      Symbol := FunctionSymbols[Index];
      Position := Pos(Symbol,AString);
      if (Position > 0) and ((Result = 0) or (Position < Result)) then
      begin
        result := Position;
        Operation := Index;
      end;
    end;
  end;
  procedure SetArray(AName : string);
  var
    MultIndex : integer;
    Row, Column : integer;
  begin
    MultIndex := Names.IndexOf(AName);
    if MultIndex > -1 then
    begin
      for Column := 0 to Discretization.NCOL -1 do
      begin
        for Row := 0 to Discretization.NROW -1 do
        begin
          Multipliers[Column,Row,RowIndex-1] := Multipliers[Column,Row,MultIndex];
        end;
      end;
    end;
  end;
  procedure PerformOperation(AName : string; Operation : integer);
  var
    MultIndex : integer;
    Row, Column : integer;
  begin
    MultIndex := Names.IndexOf(AName);
    if MultIndex > -1 then
    begin
      for Column := 0 to Discretization.NCOL -1 do
      begin
        for Row := 0 to Discretization.NROW -1 do
        begin
          case Operation of
            0: // ('+', '-', '*', '/')
              begin
                Multipliers[Column,Row,RowIndex-1] :=
                  Multipliers[Column,Row,RowIndex-1]
                  + Multipliers[Column,Row,MultIndex];
              end;
            1:
              begin
                Multipliers[Column,Row,RowIndex-1] :=
                  Multipliers[Column,Row,RowIndex-1]
                  - Multipliers[Column,Row,MultIndex];
              end;
            2:
              begin
                Multipliers[Column,Row,RowIndex-1] :=
                  Multipliers[Column,Row,RowIndex-1]
                  * Multipliers[Column,Row,MultIndex];
              end;
            3:
              begin
                if Multipliers[Column,Row,MultIndex] = 0 then
                begin
                  Multipliers[Column,Row,RowIndex-1] := 0;
                end
                else
                begin
                Multipliers[Column,Row,RowIndex-1] :=
                  Multipliers[Column,Row,RowIndex-1]
                  / Multipliers[Column,Row,MultIndex];
                end;
              end;
          end;
        end;
      end;
    end;
  end;
var
  AName, formula : string;
  Position : integer;
  Operation, OldOperation : integer;
//  MultIndex : integer;
//  Row, Column : integer;
begin
  SetLength(FMultipliers[RowIndex-1], Discretization.NCOL, Discretization.NROW);
  result :=  frmMODFLOW.dgMultiplier.Cells[3,RowIndex];
  formula := result;
  Position := SymbolPosition(formula, Operation);
  if Position > 0 then
  begin
    OldOperation := Operation;
    AName := UpperCase(Trim(Copy(formula,1,Position-1)));
    SetArray(AName);
    formula := Copy(Formula,Position+1,Length(formula));
    Position := SymbolPosition(formula, Operation);
    While Position > 0 do
    begin
      AName := UpperCase(Trim(Copy(formula,1,Position-1)));
      PerformOperation(AName, OldOperation);
      formula := Copy(Formula,Position+1,Length(formula));
      Position := SymbolPosition(formula, Operation);
      OldOperation := Operation;
    end;
    AName := UpperCase(Trim(Formula));
    PerformOperation(AName, OldOperation);
  end
  else
  begin
    AName := UpperCase(Trim(formula));
    SetArray(AName);
  end;
end;

procedure TMultiplierWriter.SetMultiplier(Col, Row, MultIndex: integer;
  const Value: double);
begin
  FMultipliers[MultIndex, Col, Row] := Value;
end;

function TMultiplierWriter.SetName(RowIndex: integer): string;
begin
  result := UpperCase(frmMODFLOW.dgMultiplier.Cells[1,RowIndex]);
  Names.Add(result);
end;

procedure TMultiplierWriter.WriteDataSet1(Discretization: TDiscretizationWriter);
var
  ErrorString: string;
begin
  SetCount;
  SetArraySize(Discretization);
  if Count > 500 then
  begin
    ErrorString := 'Warning: you have more than 500 multiplier arrays.';
    ErrorMessages.Add(ErrorString);
    frmProgress.reErrors.Lines.Add(ErrorString);

    ErrorString := 'The standard version of MODFLOW is limited to '
      + '500 multiplier arrays.';
    ErrorMessages.Add(ErrorString);
    frmProgress.reErrors.Lines.Add(ErrorString);
  end;
  WriteLn(FFile, Count);
end;

procedure TMultiplierWriter.WriteFile(
  const CurrentModelHandle: ANE_PTR; Root: string;
  Discretization: TDiscretizationWriter);
var
  FileName : String;
  RowIndex : integer;
  MultiplierArrayIndex : integer;
  Count : integer;
begin
  frmProgress.lblPackage.Caption := 'Multiplier Package';
  Application.ProcessMessages;

  FileName := GetCurrentDir + '\' + Root + rsMult;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);
    WriteDataReadFrom(FileName);
    WriteDataSet1(Discretization);
    MultiplierArrayIndex := 0;

    Count := 0;
    for RowIndex := 1 to frmMODFLOW.dgMultiplier.RowCount -1 do
    begin
      if frmMODFLOW.dgMultiplier.Cells[2,RowIndex] =
        frmMODFLOW.dgMultiplier.Columns[2].PickList[0] then
      begin
        Inc(Count);
      end;
    end;
    frmProgress.pbPackage.Max := Count*2;

    for RowIndex := 1 to frmMODFLOW.dgMultiplier.RowCount -1 do
    begin
      WriteMultName(RowIndex);
      if frmMODFLOW.dgMultiplier.Cells[2,RowIndex] =
        frmMODFLOW.dgMultiplier.Columns[2].PickList[1] then
      begin
        WriteMultFunction(RowIndex, Discretization);
      end
      else if frmMODFLOW.dgMultiplier.Cells[2,RowIndex] =
        frmMODFLOW.dgMultiplier.Columns[2].PickList[2] then
      begin
        WriteMultConstant(RowIndex, Discretization);
      end
      else
      begin
        Inc(MultiplierArrayIndex);
        WriteMultArray(CurrentModelHandle,
          Discretization, MultiplierArrayIndex, RowIndex);
        Flush(FFile);
        frmProgress.pbPackage.StepIt;
      end;
    end;

  finally
    CloseFile(FFile);
    CacheMultiplier;
  end;
end;

procedure TMultiplierWriter.WriteMultArray(CurrentModelHandle: ANE_PTR;
  Discretization: TDiscretizationWriter; MultiplierArrayIndex, RowIndex: integer);
var
  Col, Row : integer;
  Mult : double;
begin
  SetMultArray(CurrentModelHandle, Discretization, MultiplierArrayIndex, RowIndex);

  frmProgress.lblActivity.Caption := 'writing multiplier array';
  frmProgress.pbActivity.Position := 0;
  frmProgress.pbActivity.Max := Discretization.NROW * Discretization.NCOL;
  Application.ProcessMessages;

  try
    begin
      Mult := InternationalStrToFloat(frmModflow.dgMultiplier.Cells[3,RowIndex]);
      Writeln(FFile, 'INTERNAL ', FreeFormattedReal(Mult), ' (FREE)   ',
        IPRN_Real);
    end;
  except on EConvertError do
    begin
      WriteU2DRELHeader;
    end;
  end;


  for Row := 0 to Discretization.NROW -1 do
  begin
    Application.ProcessMessages;
    if not ContinueExport then break;

    for Col := 0 to Discretization.NCOL -1 do
    begin
      frmProgress.pbActivity.StepIt;
      Application.ProcessMessages;
      if not ContinueExport then break;

      Write(FFile,
        Multipliers[Col,Row,RowIndex-1],
        ' ');

    end;
    WriteLn(FFile);
  end;
end;

procedure TMultiplierWriter.WriteMultConstant(RowIndex: integer;
  Discretization : TDiscretizationWriter);
begin
  WriteLn(FFile, 'CONSTANT ', FreeFormattedReal(SetMultConstant(RowIndex, Discretization)));
end;

procedure TMultiplierWriter.WriteMultFunction(RowIndex: integer;
      Discretization: TDiscretizationWriter);
begin
  WriteLn(FFile, SetMultFunction(RowIndex, Discretization));
end;

procedure TMultiplierWriter.WriteMultName(RowIndex: integer);
begin
  Write(FFile, SetName(RowIndex));
  if frmMODFLOW.dgMultiplier.Cells[2,RowIndex] =
    frmMODFLOW.dgMultiplier.Columns[2].PickList[1] then
  begin
    WriteLN(FFile, ' FUNCTION');
  end
  else
  begin
    WriteLN(FFile);
  end;
end;

end.
