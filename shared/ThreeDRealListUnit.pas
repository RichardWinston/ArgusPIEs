unit ThreeDRealListUnit;

interface

uses Classes;

type
  T3DRealList = class(TObject)
  // T3DRealList is similar to a three dimensional array of doubles
  // except that its dimensions can be determined at run time.
    private
      FValues : array of array of array of double;
      FMaxX : integer;
      FMaxY : Integer;
      FMaxZ : integer;
      FCached: Boolean;
      FTempFileName: string;
      procedure SetItem (X, Y, Z : integer; const AReal : double);
      function GetItem (X, Y, Z : integer): double;
      procedure Restore;
    public
      constructor Create(MaximumX, MaximumY, MaximumZ : integer);
      destructor Destroy; Override;
      procedure Cache;
      class procedure Error(const Msg: string; Data: Integer); virtual;
      Property Items[X, Y, Z : integer] : double  read GetItem write SetItem;
      property XCount : integer read FMaxX;
      property YCount : integer read FMaxY;
      property ZCount : integer read FMaxZ;
    end;

implementation

uses
  Windows, TempFiles, SysUtils, ZLib;

procedure T3DRealList.Cache;
var
  FileStream: TFileStream;
  XIndex: Integer;
  YIndex: Integer;
  ZIndex: Integer;
  CompStream: TCompressionStream;
begin
  if FTempFileName = '' then
  begin
    FTempFileName := TempFileName;
    FileStream := TFileStream.Create(FTempFileName, fmCreate or fmShareDenyWrite);
    CompStream := TCompressionStream.Create(clDefault, FileStream);
    try
      for XIndex := 0 to XCount - 1 do
      begin
        for YIndex := 0 to YCount - 1 do
        begin
          for ZIndex := 0 to ZCount - 1 do
          begin
            CompStream.Write(FValues[XIndex, YIndex, ZIndex], SizeOf(Double));
          end;
        end;
      end;
    finally
      CompStream.Free;
      FileStream.Free;
    end;
    FCached := True;
    SetLength(FValues, 0, 0, 0);
  end;
end;

constructor T3DRealList.Create(MaximumX, MaximumY, MaximumZ : integer);
begin
  FMaxX := MaximumX;
  FMaxY := MaximumY;
  FMaxZ := MaximumZ;
  SetLength(FValues, FMaxX, FMaxY, FMaxZ);
end;

destructor T3DRealList.Destroy;
begin
  if FileExists(FTempFileName) then
  begin
    DeleteFile(FTempFileName);
  end;
  inherited;
end;

class procedure T3DRealList.Error(const Msg: string; Data: Integer);
begin
  TList.Error(Msg, Data);
end;

procedure T3DRealList.SetItem (X, Y, Z : integer; const  AReal : double);
begin
  if (X > FMaxX -1) or (Y > FMaxY -1) or (Z > FMaxZ -1)
     or (X < 0) or (Y < 0) or (Z < 0)  then
  begin
    raise EListError.Create('X, Y, or Z is out of bounds in a T3DRealList');
  end;
  FValues[X, Y, Z] := AReal;
end;

function T3DRealList.GetItem (X, Y, Z : integer): double;
begin
  if (X > FMaxX -1) or (Y > FMaxY -1) or (Z > FMaxZ -1)
     or (X < 0) or (Y < 0) or (Z < 0)  then
  begin
    raise EListError.Create('X, Y, or Z is out of bounds in a T3DRealList');
  end;
  Restore;
  result := FValues[X, Y, Z];
end;

procedure T3DRealList.Restore;
var
  FileStream: TFileStream;
  XIndex: Integer;
  YIndex: Integer;
  ZIndex: Integer;
  Decomp: TDecompressionStream;
begin
  if FCached then
  begin
    Assert(FTempFileName <> '');
    Assert(FileExists(FTempFileName));
    SetLength(FValues, FMaxX, FMaxY, FMaxZ);
    FileStream := TFileStream.Create(FTempFileName, fmOpenRead or fmShareDenyWrite);
    Decomp := TDecompressionStream.Create(FileStream);
    try
      for XIndex := 0 to XCount - 1 do
      begin
        for YIndex := 0 to YCount - 1 do
        begin
          for ZIndex := 0 to ZCount - 1 do
          begin
            Decomp.Read(FValues[XIndex, YIndex, ZIndex], SizeOf(Double));
          end;
        end;
      end;
    finally
      Decomp.Free;
      FileStream.Free;
    end;
    FCached := False;
  end;
end;

end.
