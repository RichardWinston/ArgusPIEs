unit NumberStream;

interface

uses S_Stream, SolidGeom, doublePolyhedronUnit;

type
  TNumberStream = class(TS_BufferStream)
  public
    Function ReadDouble : double;
    Function ReadExtended : extended;
    function ReadInteger : integer;
    function ReadPointD : TPointd;
    function ReadPointI : TPointi;
    procedure WriteDouble(const Value : double);
    procedure WriteExtended(const Value : extended);
    procedure WriteInteger(const Value : Integer);
    procedure WritePointD(const Value : TPointd);
    procedure WritePointI(const Value : TPointi);
  end;

implementation

{ TNumberStream }

function TNumberStream.ReadDouble: double;
begin
  ReadBuffer(result, SizeOf(double));
end;

function TNumberStream.ReadExtended: extended;
begin
  ReadBuffer(result, SizeOf(extended));
end;

function TNumberStream.ReadInteger: integer;
begin
  ReadBuffer(result, SizeOf(integer));
end;

function TNumberStream.ReadPointD: TPointd;
begin
  ReadBuffer(result, SizeOf(TPointd));
end;

function TNumberStream.ReadPointI: TPointi;
begin
  ReadBuffer(result, SizeOf(TPointi));
end;

procedure TNumberStream.WriteDouble(const Value: double);
begin
  WriteBuffer(Value, SizeOf(double));
end;

procedure TNumberStream.WriteExtended(const Value: extended);
begin
  WriteBuffer(Value, SizeOf(extended));
end;

procedure TNumberStream.WriteInteger(const Value: Integer);
begin
  WriteBuffer(Value, SizeOf(Integer));
end;

procedure TNumberStream.WritePointD(const Value: TPointd);
begin
  WriteBuffer(Value, SizeOf(TPointd));
end;

procedure TNumberStream.WritePointI(const Value: TPointi);
begin
  WriteBuffer(Value, SizeOf(TPointi));
end;

end.
