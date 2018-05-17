unit RenameUnit;

interface

uses AnePIE, SysUtils, Dialogs ;

procedure GPIERenameFilesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses TimeFunctionsUnit, ANECB;

procedure GPIERenameFilesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  File1 : ANE_STR;
  File2 : ANE_STR;
  result : ANE_BOOL;
  param : PParameter_array;
  Directory : String;
  index : integer;
//  FirstFileList, SecondFileList : TStringList;
  FirstFilePath, SecondFilePath : string;
//  AFile : String;
begin
  result := False;
  try
    begin
      try
        begin
          param := @parameters^;
          File1 :=  param^[0];
          File2 :=  param^[1];
          Directory := '0';
          For Index := 1 to 10 do
          begin
            Directory := Directory + Directory;
          end;
          ANE_DirectoryGetCurrent(myHandle,  PChar(Directory), Length(Directory) );
          Directory := Trim(Directory);
          FirstFilePath := Directory + String(File1);
          SecondFilePath := Directory + String(File2);
          if FileExists(FirstFilePath) and FileExists(SecondFilePath) then
          begin
            DeleteFile(SecondFilePath);
          end;
          if FileExists(FirstFilePath) then
          begin
            result := RenameFile(FirstFilePath, SecondFilePath)
          end
          else
          begin
            result := false;
          end;

          if not result then
          begin
                  MessageDlg('Unable to rename ' + FirstFilePath
                  + ' to ' + SecondFilePath + '.', mtError, [mbOK], 0);
          end;
        end
      Except on Exception do
        begin
              MessageDlg('Unknown Error while renaming file in HST3D GUI PIE.',
                mtError, [mbOK], 0);
        end;
      end;
    end;
  finally
    begin
              ANE_BOOL_PTR(reply)^ := result;
    end;
  end;

end;

end.
 