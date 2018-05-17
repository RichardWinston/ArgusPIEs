unit ReadMt3dArrayUnit;

interface

uses
  Classes, ReadModflowArrayUnit;

function CheckMt3dArrayPrecision(AFile: TFileStream): TModflowPrecision;

procedure ReadMt3dAsciiRealArray(F: TFileVariable; var NTRANS, KSTP, KPER: Integer;
  var TOTIM: TModflowDouble; var DESC: TModflowDesc2;
  var NCOL, NROW, ILAY: Integer; var AnArray: TModflowDoubleArray);

procedure ReadSinglePrecisionMt3dBinaryRealArray(AFile: TFileStream;
  var NTRANS, KSTP, KPER: Integer;
  var TOTIM: TModflowDouble; var DESC: TModflowDesc;
  var NCOL, NROW, ILAY: Integer; var AnArray: TModflowDoubleArray);

procedure ReadDoublePrecisionMt3dBinaryRealArray(AFile: TFileStream;
  var NTRANS, KSTP, KPER: Integer;
  var TOTIM: TModflowDouble; var DESC: TModflowDesc;
  var NCOL, NROW, ILAY: Integer; var AnArray: TModflowDoubleArray);
  
implementation

function CheckMt3dArrayPrecision(AFile: TFileStream): TModflowPrecision;
var
  KSTP, KPER, NTRANS: Integer;
  TOTIM: TModflowFloat;
  DESC: TModflowDesc;
  Description : string;
  TOTIM_Double: TModflowDouble;
  function ValidDescription: boolean;
  begin
    result := (Description = 'CONCENTRATION   ');
  end;
begin
  Assert(AFile.Position = 0);
  AFile.Read(NTRANS, SizeOf(NTRANS));
  AFile.Read(KSTP, SizeOf(KSTP));
  AFile.Read(KPER, SizeOf(KPER));
  AFile.Read(TOTIM, SizeOf(TOTIM));
  AFile.Read(DESC, SizeOf(DESC));
  Description := DESC;
  if ValidDescription then
  begin
    result := mpSingle;
  end
  else
  begin
    result := mpDouble;
  end;
  AFile.Position := 0;
  AFile.Read(NTRANS, SizeOf(NTRANS));
  AFile.Read(KSTP, SizeOf(KSTP));
  AFile.Read(KPER, SizeOf(KPER));
  AFile.Read(TOTIM_Double, SizeOf(TOTIM_Double));
  AFile.Read(DESC, SizeOf(DESC));
  Description := DESC;
  case result of
    mpSingle: Assert(not ValidDescription);
    mpDouble: Assert(ValidDescription);
  end;
  AFile.Position := 0;
end;

procedure ReadMt3dAsciiRealArray(F: TFileVariable; var NTRANS, KSTP, KPER: Integer;
  var TOTIM: TModflowDouble; var DESC: TModflowDesc2;
  var NCOL, NROW, ILAY: Integer; var AnArray: TModflowDoubleArray);
var
  ColIndex: Integer;
  RowIndex: Integer;
begin
  Read(F.AFile, NTRANS);
  Read(F.AFile, KSTP);
  Read(F.AFile, KPER);
  Read(F.AFile, TOTIM);
  Read(F.AFile, DESC);
  Read(F.AFile, NCOL);
  Read(F.AFile, NROW);
  Read(F.AFile, ILAY);
  ReadLn(F.AFile);
  SetLength(AnArray, NROW, NCOL);
  for RowIndex := 0 to NROW - 1 do
  begin
    for ColIndex := 0 to NCOL - 1 do
    begin
      Read(F.AFile, AnArray[RowIndex, ColIndex]);
    end;
  end;
  ReadLn(F.AFile);
end;

procedure ReadSinglePrecisionMt3dBinaryRealArray(AFile: TFileStream;
  var NTRANS, KSTP, KPER: Integer;
  var TOTIM: TModflowDouble; var DESC: TModflowDesc;
  var NCOL, NROW, ILAY: Integer; var AnArray: TModflowDoubleArray);
var
  ColIndex: Integer;
  RowIndex: Integer;
  AValue: TModflowFloat;
begin
  AFile.Read(NTRANS, SizeOf(NTRANS));
  AFile.Read(KSTP, SizeOf(KSTP));
  AFile.Read(KPER, SizeOf(KPER));

  AFile.Read(AValue, SizeOf(TModflowFloat));
  TOTIM := AValue;
  AFile.Read(DESC, SizeOf(DESC));
  AFile.Read(NCOL, SizeOf(NCOL));
  AFile.Read(NROW, SizeOf(NROW));
  AFile.Read(ILAY, SizeOf(ILAY));
  SetLength(AnArray, NROW, NCOL);
  for RowIndex := 0 to NROW - 1 do
  begin
    for ColIndex := 0 to NCOL - 1 do
    begin
      AFile.Read(AValue, SizeOf(TModflowFloat));
      AnArray[RowIndex, ColIndex] := AValue;
    end;
  end;
end;

procedure ReadDoublePrecisionMt3dBinaryRealArray(AFile: TFileStream;
  var NTRANS, KSTP, KPER: Integer;
  var TOTIM: TModflowDouble; var DESC: TModflowDesc;
  var NCOL, NROW, ILAY: Integer; var AnArray: TModflowDoubleArray);
var
  ColIndex: Integer;
  RowIndex: Integer;
begin
  AFile.Read(NTRANS, SizeOf(NTRANS));
  AFile.Read(KSTP, SizeOf(KSTP));
  AFile.Read(KPER, SizeOf(KPER));
  AFile.Read(TOTIM, SizeOf(TModflowDouble));
  AFile.Read(DESC, SizeOf(DESC));
  AFile.Read(NCOL, SizeOf(NCOL));
  AFile.Read(NROW, SizeOf(NROW));
  AFile.Read(ILAY, SizeOf(ILAY));
  SetLength(AnArray, NROW, NCOL);
  for RowIndex := 0 to NROW - 1 do
  begin
    for ColIndex := 0 to NCOL - 1 do
    begin
      AFile.Read(AnArray[RowIndex, ColIndex], SizeOf(TModflowDouble));
    end;
  end;
end;

end.
