unit FlowReaderUnit;

interface

uses Sysutils, classes, Dialogs, IntListUnit;

type
  TValues = array of array of array of array of single;
  // data set index, column, row, layer
  TBudgetProgram = (bpModflow96, bpModflow2000);

procedure ReadDataSetNames(FileName: string; const Names: TStrings;
  out NCOL, NROW, NLAY: longint; const BudgetProgram: TBudgetProgram);

procedure ReadValues(FileName: string; const ItemsToRead: TIntegerList;
  var Data: TValues; const BudgetProgram: TBudgetProgram);

implementation

uses ReadModflowArrayUnit;

//type
//  TText = array[0..15] of Char;

{procedure ReadArray(var TOTIM: single; var KSTP,KPER,IRESULT: longint; var TEXT: TText;
  TextLength: LongInt)
  stdcall; external 'ReadFlow.dll';

procedure OpenBudgetFile (var IRESULT,NC,NR,NL: longint; NAME: string;
  NameLength: longint);
  stdcall; external 'ReadFlow.dll';

procedure CloseBudgetFile;
  stdcall; external 'ReadFlow.dll';

procedure GetValue (var Layer,Row,Column: longint; var Value: single);
  stdcall; external 'ReadFlow.dll';  }

procedure ReadArray96(var TOTIM: single; var KSTP,KPER,IRESULT: longint; var TEXT: TModflowDesc;
  TextLength: LongInt)
  stdcall; external 'ReadFlow96.dll';

procedure OpenBudgetFile96 (var IRESULT,NC,NR,NL: longint; NAME: string;
  NameLength: longint);
  stdcall; external 'ReadFlow96.dll';

procedure CloseBudgetFile96;
  stdcall; external 'ReadFlow96.dll';

procedure GetValue96 (var Layer,Row,Column: longint; var Value: single);
  stdcall; external 'ReadFlow96.dll';

procedure ReadDataSetNames(FileName: string;
  const Names: TStrings; out NCOL, NROW, NLAY: longint;
  const BudgetProgram: TBudgetProgram);
var
  Dir: string;
  IRESULT: longint;
  AName: string;
  TEXT: TModflowDesc;
  KSTP,KPER: longint;
  CharIndex: integer;
  TotalTime: single;
  FFileStream : TFileStream;
  Precision: TModflowPrecision;
  PERTIM, TOTIM: TModflowDouble;
  A3DArray: T3DTModflowArray;
  DESC: TModflowDesc;
  HufFormat: Boolean;
begin
  Names.Clear;
  Dir := GetCurrentDir;
  try
    SetCurrentDir(ExtractFileDir(FileName));
    FileName := ExtractFileName(FileName);
    FFileStream := nil;
    try
      Precision := mpSingle;
      case BudgetProgram of
        bpModflow96:
          begin
            OpenBudgetFile96(IRESULT,NCOL, NROW, NLAY, FileName,Length(FileName));
          end;
        bpModflow2000:
          begin
            FFileStream := TFileStream.Create(FileName,
              fmOpenRead or fmShareDenyWrite);
            Precision := CheckBudgetPrecision(FFileStream, HufFormat);
            IRESULT := 0;
          end;
      else Assert(False);
      end;


      While IResult = 0 do
      begin
        TEXT := '                ';
      case BudgetProgram of
        bpModflow96:
          begin
            ReadArray96(TotalTime,KSTP,KPER,IRESULT, TEXT, Length(Text));
          end;
        bpModflow2000:
          begin
            case Precision of
              mpSingle:
                ReadModflowSinglePrecFluxArray(FFileStream, KSTP, KPER,
                  PERTIM, TOTIM, DESC, NCOL, NROW, NLAY, A3DArray, HufFormat, IRESULT);
              mpDouble:
                ReadModflowDoublePrecFluxArray(FFileStream, KSTP, KPER,
                  PERTIM, TOTIM, DESC, NCOL, NROW, NLAY, A3DArray, HufFormat, IRESULT);
            else Assert(False);
            end;
            TEXT := DESC;

//            ReadArray(TotalTime,KSTP,KPER,IRESULT, TEXT, Length(Text));
          end;
        else Assert(False);
      end;
        if IRESULT = 1 then
        begin
          Exit;
        end
        else if IRESULT = 2 then
        begin
          ShowMessage('Error, Empty budget file');
          Exit;
        end
        else if IRESULT <> 0 then
        begin
          ShowMessage('Unknown Eror');
          Exit;
        end
        else
        begin
          for CharIndex := 1 to 15 do
          begin
            if Text[CharIndex-1] <> ' '  then
            begin
              Text[CharIndex] := LowerCase(Text[CharIndex])[1];
            end;
          end;

          AName := Trim(TEXT) + ', Stress Period ' +
            IntToStr(KPER) + ', Time Step ' + IntToStr(KSTP);
          Names.Add(AName);
        end;
      end;
    finally
      case BudgetProgram of
        bpModflow96:
          begin
            CloseBudgetFile96;
          end;
        bpModflow2000:
          begin
            FFileStream.Free;
          end;
      else Assert(False);
      end;
    end;
  finally
    SetCurrentDir(Dir);
  end;
end;

procedure ReadValues(FileName: string; const ItemsToRead: TIntegerList;
  var Data: TValues; const BudgetProgram: TBudgetProgram);
var
  Dir: string;
  IRESULT: longint;
  TEXT: TModflowDesc;
  KSTP,KPER: longint;
  NCOL, NROW, NLAY: longint;
  DataSetIndex: integer;
  ItemIndex: integer;
  CurrentItem: integer;
  LayIndex, RowIndex, ColIndex: integer;
  Layer, Row, Column: longint;
  Value: single;
  TotalTime: single;
  FFileStream : TFileStream;
  Precision: TModflowPrecision;
  PERTIM, TOTIM: TModflowDouble;
  A3DArray: T3DTModflowArray;
  DESC: TModflowDesc;
  HufFormat: Boolean;
begin
  Assert(ItemsToRead.Count > 0);
  Dir := GetCurrentDir;
  try
    SetCurrentDir(ExtractFileDir(FileName));
    FileName := ExtractFileName(FileName);
    FFileStream := nil;
    try
      Precision := mpSingle;
      case BudgetProgram of
        bpModflow96:
          begin
            OpenBudgetFile96(IRESULT,NCOL, NROW, NLAY, FileName,Length(FileName));
          end;
        bpModflow2000:
          begin
            FFileStream := TFileStream.Create(FileName,
              fmOpenRead or fmShareDenyWrite);
            Precision := CheckBudgetPrecision(FFileStream, HufFormat);
            FFileStream.Read(KSTP, SizeOf(KSTP));
            FFileStream.Read(KPER, SizeOf(KPER));
            FFileStream.Read(DESC, SizeOf(DESC));
            FFileStream.Read(NCOL, SizeOf(NCOL));
            FFileStream.Read(NROW, SizeOf(NROW));
            FFileStream.Read(NLAY, SizeOf(NLAY));
            NLAY := Abs(NLAY);
            FFileStream.Position := 0;
            IRESULT := 0;
          end;
      else Assert(False);
      end;
      if IResult = 0 then
      begin
        SetLength(Data, ItemsToRead.Count, NCOL, NROW, NLAY);
      end;

      DataSetIndex := -1;
      ItemIndex := 0;
      CurrentItem := ItemsToRead[ItemIndex];
      While IResult = 0 do
      begin
        TEXT := '                ';
      case BudgetProgram of
        bpModflow96:
          begin
            ReadArray96(TotalTime,KSTP,KPER,IRESULT, TEXT, Length(Text));
          end;
        bpModflow2000:
          begin
            case Precision of
              mpSingle:
                ReadModflowSinglePrecFluxArray(FFileStream, KSTP, KPER,
                  PERTIM, TOTIM, DESC, NCOL, NROW, NLAY, A3DArray, HufFormat, IRESULT);
              mpDouble:
                ReadModflowDoublePrecFluxArray(FFileStream, KSTP, KPER,
                  PERTIM, TOTIM, DESC, NCOL, NROW, NLAY, A3DArray, HufFormat, IRESULT);
            else Assert(False);
            end;
            TEXT := DESC;
            NLAY := Abs(NLAY);
//            ReadArray(TotalTime,KSTP,KPER,IRESULT, TEXT, Length(Text));
          end;
      else Assert(False);
      end;
        if IRESULT = 1 then
        begin
          Exit;
        end
        else if IRESULT = 2 then
        begin
          ShowMessage('Error, Empty budget file');
          Exit;
        end
        else if IRESULT <> 0 then
        begin
          ShowMessage('Unknown Eror');
          Exit;
        end
        else
        begin
          Inc(DataSetIndex);
          if DataSetIndex = CurrentItem then
          begin
            for LayIndex := 1 to NLAY do
            begin
              for RowIndex := 1 to NROW do
              begin
                for ColIndex := 1 to NCOL do
                begin
                  Layer := LayIndex;
                  Row := RowIndex;
                  Column:= ColIndex;
                  case BudgetProgram of
                    bpModflow96:
                      begin
                        GetValue96 (Layer,Row,Column, Value);
                      end;
                    bpModflow2000:
                      begin
                        Value := A3DArray[Layer-1,Row-1,Column-1];
//                        GetValue (Layer,Row,Column, Value);
                      end;
                  else Assert(False);
                  end;
                  Data[ItemIndex, Column-1, Row-1, Layer-1] := Value;
                end;
              end;
            end;
            Inc(ItemIndex);
            if ItemIndex >= ItemsToRead.Count then
            begin
              Exit;
            end;
            CurrentItem := ItemsToRead[ItemIndex];
          end;
        end;
      end;
    finally
      case BudgetProgram of
        bpModflow96:
          begin
            CloseBudgetFile96;
          end;
        bpModflow2000:
          begin
            FFileStream.Free;
//            CloseBudgetFile;
          end;
      else Assert(False);
      end;
    end;
  finally
    SetCurrentDir(Dir);
  end;
end;


end.
