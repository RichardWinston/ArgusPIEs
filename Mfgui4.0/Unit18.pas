unit Unit18;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;

type
  TForm18 = class(TForm)
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    StringGrid1: TStringGrid;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form18: TForm18;

implementation

uses
  ReadMt3dArrayUnit, ReadModflowArrayUnit;

{$R *.dfm}

procedure TForm18.Button1Click(Sender: TObject);
var
  AFileStream: TFileStream;
  APrecision: TModflowPrecision;
  NTRANS: Integer;
  KSTP: Integer;
  KPER: Integer;
  TOTIM: TModflowDouble;
  DESC: TModflowDesc;
  NCOL: Integer;
  NROW: Integer;
  ILAY: Integer;
  AnArray: TModflowDoubleArray;
  RowIndex: Integer;
  ColIndex: Integer;
begin
  if OpenDialog1.Execute then
  begin
    AFileStream := TFileStream.Create(OpenDialog1.FileName, fmOpenRead or fmShareCompat);
    try
      APrecision := CheckMt3dArrayPrecision(AFileStream);
      While AFileStream.Position < AFileStream.Size do
      begin
        case APrecision of
          mpSingle:
            begin
              ReadSinglePrecisionMt3dBinaryRealArray(AFileStream, NTRANS, KSTP,
                KPER, TOTIM, DESC, NCOL, NROW, ILAY, AnArray);
            end;
          mpDouble:
            begin
              ReadDoublePrecisionMt3dBinaryRealArray(AFileStream, NTRANS, KSTP,
                KPER, TOTIM, DESC, NCOL, NROW, ILAY, AnArray);
            end;
          else Assert(False);
        end;
      end;
      Label1.Caption := 'Period: ' + IntToStr(KPER) + '; Step: ' + IntToStr(KSTP) + '; Transport Step: ' + IntToStr(NTRANS);
      StringGrid1.RowCount := NROW;
      StringGrid1.ColCount := NCOL;
      for RowIndex := 0 to NROW - 1 do
      begin
        for ColIndex := 0 to NCOL - 1 do
        begin
          StringGrid1.Cells[ColIndex, RowIndex] := FloatToStr(AnArray[RowIndex, ColIndex]);
        end;
      end;
    finally
      AFileStream.Free;
    end;
  end;
end;

end.
