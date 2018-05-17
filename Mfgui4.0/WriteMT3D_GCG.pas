unit WriteMT3D_GCG;

interface

uses Sysutils, WriteMT3D_Basic;

type
  TMt3dGCG_Writer = class(TMT3DCustomWriter)
  private
    procedure WriteDataSet1;
    procedure WriteDataSet2;
  public
    procedure WriteFile(const Root: string);
  end;


implementation

uses UtilityFunctions, Variables, WriteNameFileUnit;

{ TMt3dGCG_Writer }

procedure TMt3dGCG_Writer.WriteDataSet1;
var
  MXITER, ITER1, ISOLVE, NCRS: integer;
begin
  MXITER := StrToInt(frmModflow.adeMT3D_MaxIterations.Text);
  ITER1 := StrToInt(frmModflow.adeMT3D_MaxInnerIterations.Text);
  ISOLVE := frmModflow.comboMT3D_Preconditioner.ItemIndex + 1;
  if frmModflow.cbMT3D_Tensor.Checked then
  begin
    NCRS := 1;
  end
  else
  begin
    NCRS := 0;
  end;
  WriteLn(FFile, MXITER, ' ', ITER1, ' ', ISOLVE, ' ', NCRS);
end;

procedure TMt3dGCG_Writer.WriteDataSet2;
var
  ACCL, CCLOSE : double;
  IPRGCG : integer;
begin
  ACCL := InternationalStrToFloat(frmModflow.adeMT3D_Relax.Text);
  CCLOSE := InternationalStrToFloat(frmModflow.adeMT3D_Converge.Text);
  IPRGCG := StrToInt(frmModflow.adeMT3D_PrintOut.Text);
  writeLn(FFile, FreeFormattedReal(ACCL), FreeFormattedReal(CCLOSE), IPRGCG);
end;

procedure TMt3dGCG_Writer.WriteFile(const Root: string);
var
  FileName : string;
begin
  FileName := GetCurrentDir + '\' + Root + rsGCG;
  AssignFile(FFile,FileName);
  try
    Rewrite(FFile);
    WriteDataSet1;
    WriteDataSet2;
  finally
    CloseFile(FFile);
  end;
end;

end.
