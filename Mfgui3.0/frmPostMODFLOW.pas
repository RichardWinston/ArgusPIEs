unit frmPostMODFLOW;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ThreeDGriddedDataStorageUnit, AnePIE;

type
  TfrmMODFLOWPostProcessing = class(TForm)
    OpenDialog1: TOpenDialog;
    btnOpenDataSet: TButton;
    procedure btnOpenDataSetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    DataSets : T3DGridStorage;
    { Public declarations }
  end;

type
  EInvalidGridSize = Class(Exception);

var
  frmMODFLOWPostProcessing: TfrmMODFLOWPostProcessing;

procedure GPostProcessingPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

implementation

{$R *.DFM}

uses ModflowUnit, ThreeDRealListUnit, ANECB, MFGrid, ANE_LayerUnit,
     ArgusFormUnit, MainFormUnit;

procedure GPostProcessingPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

begin
  if EditWindowOpen
  then
    begin
      // Result := False
    end
  else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try  // try 1
        begin
          try  // try 2
            begin
              frmMODFLOW := TArgusForm.GetFormFromArgus(aneHandle) as TfrmMODFLOW;

            end; // try 2
          except on Exception do
            begin
                // result := False;
            end;
          end  // try 2
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end; // try 1
    end; // if EditWindowOpen else
end;

procedure TfrmMODFLOWPostProcessing.btnOpenDataSetClick(Sender: TObject);
var
  OutputFile : TextFile;
  ALine : string;
   KSTP : integer;
   KPER : integer;
   PERTIM : double;
   TOTIM : double;
   TEXT: string;
   NCOL : integer;
   NROW : integer;
   ILAY : integer;
   FMTOUT: string;
   LayerIndex, RowIndex, ColumnIndex : integer;
   DataValue : double;
   ADataSet : T3DRealList;
   NumRows, NumColumns : ANE_INT32;
   layerHandle : ANE_PTR;
   Name : string;
begin
  if OpenDialog1.Execute then
  begin
    AssignFile(OutputFile, OpenDialog1.Filename);
    Reset(OutputFile);
    try // try 1
      begin
        while not Eof(OutputFile) do
        begin
          layerHandle := ANE_LayerGetHandleByName(frmMODFLOW.CurrentModelHandle,
            PChar(kMFGrid) ) ;

          ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
            kPIEInteger, 'NumRows()', @NumRows );

          ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
            kPIEInteger, 'NumColumns()', @NumColumns );

          ADataSet := T3DRealList.Create(NumColumns, NumRows, StrToInt(frmMODFLOW.edNumUnits.Text));

          for LayerIndex := 0 to StrToInt(frmMODFLOW.edNumUnits.Text)-1 do
          begin
            Readln(OutputFile, ALine);
            KSTP := StrToInt(Copy(ALine,2,5));
            KPER := StrToInt(Copy(ALine,7,5));
            PERTIM := StrToFloat(Copy(ALine,12,15));
            TOTIM := StrToFloat(Copy(ALine,27,15));
            TEXT := Copy(ALine,43,16);
            NCOL := StrToInt(Copy(ALine,59,6));
            NROW := StrToInt(Copy(ALine,65,6));
            ILAY := StrToInt(Copy(ALine,71,6));
            FMTOUT := Copy(ALine,72,20);
            if not ((NCOL = NumColumns) and (NROW = NumRows))then
            begin
              raise EInvalidGridSize.Create('Incorrect number of columns or rows');
            end; // if not ((NCOL = NumColumns) and (NROW = NumRows))then

            For RowIndex := 0 to NROW-1 do
            begin
              For ColumnIndex := 0 to NCOL-1 do
              begin
                if not Eof(OutputFile) then
                begin
                  Read(OutputFile, DataValue);
                  ADataSet.Items[ColumnIndex, RowIndex, LayerIndex] := DataValue;
                end;
              end; // For ColumnIndex := 0 to NCOL-1 do
            end; // For RowIndex := 0 to NROW-1 do
          end; //  for LayerIndex := 0 to StrToInt(frmMODFLOW.edNumUnits.Text)-1 do

          Name := Trim(TEXT) + ' Per. ' + IntToStr(KPER) + ' TS ' + IntToStr(KSTP);
          DataSets.Add(ADataSet, Name);

        end;  // while not Eof(OutputFile) do
      end; // try 1
    finally
      begin
            CloseFile(OutputFile);
      end;
    end; // try 1 finally
  end; // if OpenDialog1.Execute then
end;

procedure TfrmMODFLOWPostProcessing.FormCreate(Sender: TObject);
begin
  DataSets := T3DGridStorage.Create;
end;

procedure TfrmMODFLOWPostProcessing.FormDestroy(Sender: TObject);
begin
  DataSets.Free;
end;

end.
