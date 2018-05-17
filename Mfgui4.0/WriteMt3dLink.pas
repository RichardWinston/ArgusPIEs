unit WriteMt3dLink;

interface

uses Sysutils, WriteModflowDiscretization, WriteNameFileUnit;

type
  TMt3dLinkWriter = class(TModflowWriter)
  public
    procedure WriteFile(const Root : string);
    class procedure AssignUnitNumbers;
  end;

implementation

uses ProgressUnit, Variables;

{ TMt3dLinkWriter }

class procedure TMt3dLinkWriter.AssignUnitNumbers;
begin
  frmModflow.GetUnitNumber('FTL')
end;

procedure TMt3dLinkWriter.WriteFile(const Root: string);
var
  FileName : string;
begin
  FileName := GetCurrentDir + '\' + Root + rsLMT;
  AssignFile(FFile,FileName);
  try
    if ContinueExport then
    begin
      Rewrite(FFile);
      WriteDataReadFrom(FileName);

      Writeln(FFile, 'OUTPUT_FILE_NAME ' + Root + rsFTL);
      Writeln(FFile, 'OUTPUT_FILE_UNIT ', frmModflow.GetUnitNumber('FTL'));
      Writeln(FFile, 'OUTPUT_FILE_HEADER Extended');
      if frmModflow.comboMt3dFlowFormat.ItemIndex = 0 then
      begin
        Writeln(FFile, 'OUTPUT_FILE_FORMAT Unformatted');
      end
      else
      begin
        Writeln(FFile, 'OUTPUT_FILE_FORMAT Formatted');
      end;


    end;
  finally
    CloseFile(FFile);
  end;

end;

end.
