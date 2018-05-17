unit functionUnit;

interface

uses

  Windows, AnePIE, Forms, Dialogs, SysUtils, classes, FunctionPie ;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

procedure GPIEJoinFilesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  Counter : integer;
  FirstFilePath, SecondFilePath : string;

implementation

uses ANECB, CheckPIEVersionFunction, ParamNamesAndTypes, frmTimerUnit,
  UtilityFunctions;

const
  kMaxFunDesc = 21;

var

        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

        gPIEJoinFilesDesc : ANEPIEDesc;
        gPIEJoinFilesFDesc :  FunctionPIEDesc;

        gPIEDeleteFileDesc : ANEPIEDesc;
        gPIEDeleteFileFDesc :  FunctionPIEDesc;

        gPIERenameFileDesc : ANEPIEDesc;
        gPIERenameFileFDesc :  FunctionPIEDesc;

        gPIESplitFileDesc : ANEPIEDesc;
        gPIESplitFileFDesc :  FunctionPIEDesc;

        gPIEIntToCharDesc : ANEPIEDesc;
        gPIEIntToCharFDesc :  FunctionPIEDesc;

        gPIECopyLinesDesc : ANEPIEDesc;
        gPIECopyLinesFDesc :  FunctionPIEDesc;

const   gpn3Files : array [0..3] of PChar = ('First_File', 'Second_File',
                    'Result_File', nil);
const   g3StringTypes : array [0..3] of EPIENumberType = (kPIEString,
                        kPIEString, kPIEString, 0);

const   gpnSearch : array [0..6] of PChar = ('Input_File', 'First_File',
                    'Search_String', 'Second_File',  'Search_String',
                    'Third_File', nil);
const   g30StringTypes : array [0..60] of EPIENumberType = (
        kPIEString, kPIEString, kPIEString, kPIEString, kPIEString, kPIEString,
        kPIEString, kPIEString, kPIEString, kPIEString, kPIEString, kPIEString,
        kPIEString, kPIEString, kPIEString, kPIEString, kPIEString, kPIEString,
        kPIEString, kPIEString, kPIEString, kPIEString, kPIEString, kPIEString,
        kPIEString, kPIEString, kPIEString, kPIEString, kPIEString, kPIEString,
        kPIEString, kPIEString, kPIEString, kPIEString, kPIEString, kPIEString,
        kPIEString, kPIEString, kPIEString, kPIEString, kPIEString, kPIEString,
        kPIEString, kPIEString, kPIEString, kPIEString, kPIEString, kPIEString,
        kPIEString, kPIEString, kPIEString, kPIEString, kPIEString, kPIEString,
        kPIEString, kPIEString, kPIEString, kPIEString, kPIEString, kPIEString,
        0);


const   gpn1File : array [0..1] of PChar = ('File_Name', nil);
const   g1StringType : array [0..1] of EPIENumberType = (kPIEString,  0);

const   gpn2File : array [0..2] of PChar = ('Old_File_Name',
                   'New_File_Name', nil);
const   g2StringType : array [0..2] of EPIENumberType = (kPIEString,
                       kPIEString, 0);

const   gpn2FileCount : array [0..4] of PChar = ('Old_File_Name',
                   'New_File_Name', 'Line_Count', 'Is_Local_File', nil);
const   g2String1IntegerType : array [0..4] of EPIENumberType = (kPIEString,
                       kPIEString, kPIEInteger, kPIEBoolean, 0);

procedure GPIEJoinFilesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  File1 : ANE_STR;
  File2 : ANE_STR;
  ResultFile : ANE_STR;
  result : ANE_BOOL;
  param : PParameter_array;
  Directory : String;
  index : integer;
  SecondFileList : TStringList;
  FirstFilePath, SecondFilePath, ResultFilePath : string;
  F: TextFile;
begin
  result := False;
  try
    begin
      try
        begin
          param := @parameters^;
          File1 :=  param^[0];
          File2 :=  param^[1];
          ResultFile :=  param^[2];
          Directory := GetCurrentDir + '\';
          FirstFilePath := Directory + String(File1);
          SecondFilePath := Directory + String(File2);
          ResultFilePath := Directory + String(ResultFile);
          if FileExists(FirstFilePath) and FileExists(SecondFilePath)
          then
            begin
              SecondFileList := TStringList.Create;
              try
                SecondFileList.LoadFromFile(SecondFilePath);
                if (FirstFilePath <> ResultFilePath) then
                begin
                  if not CopyFile(LPCTSTR(FirstFilePath),LPCTSTR(ResultFilePath),
                    False) then
                  begin
                    RaiseLastWin32Error;
                  end;
                end;
                AssignFile(F, ResultFilePath);
                try
                  begin
                    Append(F);
                    for index := 0 to SecondFileList.Count -1 do
                    begin
                      WriteLn(F, SecondFileList[Index]);
                    end;
                  end;
                finally
                  begin
                    // Make sure data is written to disk
                    Flush(F);
                    CloseFile(F);
                  end;
                end;
              finally
                SecondFileList.Free;
              end;

              result := True;
            end
          else if FileExists(FirstFilePath) then
            begin
              if FirstFilePath <> ResultFilePath then
              begin
                if not CopyFile(LPCTSTR(FirstFilePath),LPCTSTR(ResultFilePath),
                  False) then;
                begin
                  RaiseLastWin32Error;
                end;
              end;
              result := True;
            end
          else if FileExists(SecondFilePath) then
            begin
              if SecondFilePath <> ResultFilePath then
              begin
                if not CopyFile(LPCTSTR(SecondFilePath),LPCTSTR(ResultFilePath),
                  False) then
                begin
                  RaiseLastWin32Error;
                end;
              end;
              result := True;
            end
          else
            begin
              SecondFileList := TStringList.Create;
              try
                SecondFileList.SaveToFile(ResultFilePath);
              finally
                SecondFileList.Free;
              end;
              result := True;
            end;
          if not result then
          begin
            MessageDlg('Unable to create ' + ResultFilePath + '.',
              mtError, [mbOK], 0);
          end;
        end
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
        end;
      end;
    end;
  finally
    begin
      ANE_BOOL_PTR(reply)^ := result;
    end;
  end;

end;

procedure GPIEDeleteFileMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  File1 : ANE_STR;
  result : ANE_BOOL;
  param : PParameter_array;
  Directory : String;
  FirstFilePath  : string;
begin
  result := False;
  try
    begin
      try
        begin
          param := @parameters^;
          File1 :=  param^[0];
          Directory := GetCurrentDir + '\';

          FirstFilePath := Directory + String(File1);
          result := DeleteFile(FirstFilePath);
        end;
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
        end;
      end;
    end;
  finally
    begin
              ANE_BOOL_PTR(reply)^ := result;
    end;
  end;
end;

procedure GPIERenameFileMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
//  FirstFilePath, SecondFilePath : string;
  frmTimer: TfrmTimer;
begin
  result := False;
  try
    begin
      try
        begin
          param := @parameters^;
          File1 :=  param^[0];
          File2 :=  param^[1];
          Directory := GetCurrentDir + '\';
          FirstFilePath := Directory + String(File1);
          SecondFilePath := Directory + String(File2);
          if FirstFilePath = SecondFilePath then
          begin
            result := True;
          end
          else
          begin
            if FileExists(SecondFilePath) then
            begin
              DeleteFile(SecondFilePath);
            end;
            result := RenameFile(FirstFilePath, SecondFilePath);
            if not result then
            begin

              frmTimer := TfrmTimer.Create(nil);
//              frmTimer.Show;
              try
                Counter := 0;
                while Counter < 100 do
                begin
                  Application.ProcessMessages;
                  // Counter is incremented in TfrmTimer.Timer1Timer
                end;

              finally
                frmTimer.Free;
              end;
              if Counter <> 1000 then
              begin
                Beep;
                MessageDlg('Error renaming file ' + FirstFilePath
                  + ' to ' + SecondFilePath +' in Join_Files PIE.',
                  mtError, [mbOK], 0);
              end;
            end;
          end;
        end;
      Except on E: Exception do
        begin
          MessageDlg(E.Message, mtError, [mbOK], 0);
        end;
      end;
    end;
  finally
    begin
              ANE_BOOL_PTR(reply)^ := result;
    end;
  end;
end;

{
Function GetTempFile : String;
var
  TempPath : Array [0..MAX_PATH -1] of Char;
  TempFileName : Array [0..MAX_PATH -1] of Char;
begin
  GetTempPath(MAX_PATH, TempPath);
  GetTempFileName(TempPath, '', 0, TempFileName);
  result := String(TempFileName);
end;
}

procedure GPIECopyLinesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  File1 : ANE_STR;
  File2 : ANE_STR;
  param : PParameter_array;
  result : ANE_BOOL;
  param3_ptr : ANE_INT32_PTR;
  param4_ptr : ANE_BOOL_PTR;
  Count : ANE_INT32;
  Directory : String;
  InputFilePath : String;
  OutputFilePath : String;
  InputFile, OutputFile: TextFile;
  Index : integer;
  ALine : string;
  UseLocalDirectory : boolean;
begin
  result := False;
  try
    begin
      try
        begin
          param := @parameters^;
          File1 :=  param^[0];
          File2 :=  param^[1];
          param3_ptr :=  param^[2];
          Count :=  param3_ptr^;
          if numParams = 4 then
          begin
            param4_ptr :=  param^[3];
            UseLocalDirectory :=  param4_ptr^;
          end
          else
          begin
            UseLocalDirectory := True;
          end;

          Directory := GetCurrentDir + '\';
          InputFilePath := String(File1);
          if UseLocalDirectory then
          begin
            InputFilePath := Directory + InputFilePath
          end;
          OutputFilePath := Directory + String(File2);

          if FileExists(InputFilePath) then

          begin
            AssignFile(InputFile, InputFilePath);
            AssignFile(OutputFile, OutputFilePath);

            try
              begin
                Reset(InputFile);
                ReWrite(OutputFile);

                for Index := 0 to Count -1 do
                begin
                  ReadLn(InputFile, ALine);
                  WriteLn(OutputFile, ALine);

                end;
                 result := True;
              end;
            finally
              begin
                CloseFile(InputFile);
                Flush(OutputFile);
                CloseFile(OutputFile);
              end;
            end;
          end;

        end;
      Except on E: Exception do
        begin
          MessageDlg(E.Message, mtError, [mbOK], 0);
        end;
      end;
    end;
  finally
    begin
      ANE_BOOL_PTR(reply)^ := result;
    end;
  end;
end;

procedure GPIESplitFileMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  File1 : ANE_STR;
  File2 : ANE_STR;
  File3 : ANE_STR;
  Search : ANE_STR;
  SearchString : String;
  result : ANE_BOOL;
  param : PParameter_array;
  Directory : String;
  InputFilePath, FirstFilePath, SecondFilePath : string;
  InputFile, FirstFile, ResultFile: TextFile;
  StringFound : boolean;
  ALine : string;
  SearchTermCount, Parameter, SearchIndex : integer;
begin
  result := False;
  try
    begin
      try
        begin
          SearchTermCount := (numParams -2) div 2;
          param := @parameters^;
          File1 :=  param^[0];
          File2 :=  param^[1];
          Search := param^[2];
          File3 :=  param^[3];
          SearchString :=  String(Search);

          Directory := GetCurrentDir + '\';
          InputFilePath := Directory + String(File1);
          FirstFilePath := Directory + String(File2);
          SecondFilePath := Directory + String(File3);

          if FileExists(InputFilePath)
          then
            begin
              AssignFile(InputFile, InputFilePath);
              AssignFile(FirstFile, FirstFilePath);

              try
                begin
                  Reset(InputFile);
                  ReWrite(FirstFile);

                  StringFound := False;
                  While not EOF(InputFile) and not StringFound do
                  begin
                    ReadLn(InputFile, ALine);
                    if Pos(SearchString,ALine) = 1 then
                    begin
                      StringFound := True;
                    end
                    else
                    begin
                      WriteLn(FirstFile, ALine);
                    end;
                  end;

                  for SearchIndex := 1 to SearchTermCount -1 do
                  begin
                    AssignFile(ResultFile, SecondFilePath);
                    Parameter := SearchIndex*2 + 2;
                    Search := param^[Parameter];
                    File3 :=  param^[Parameter+1];
                    SearchString :=  String(Search);
                    SecondFilePath := Directory + String(File3);
                    try

                      ReWrite(ResultFile);
                      WriteLn(ResultFile, ALine);
                      StringFound := False;
                      While not EOF(InputFile) and not StringFound do
                      begin
                        ReadLn(InputFile, ALine);
                        if Pos(SearchString,ALine) = 1 then
                        begin
                          StringFound := True;
                        end
                        else
                        begin
                          WriteLn(ResultFile, ALine);
                        end;
                      end;
                    finally
                      Flush(ResultFile);
                      CloseFile(ResultFile);
                    end;

                  end;

                  AssignFile(ResultFile, SecondFilePath);
                  ReWrite(ResultFile);
                  WriteLn(ResultFile, ALine);

                  While not EOF(InputFile) do
                  begin
                    ReadLn(InputFile, ALine);
                    WriteLn(ResultFile, ALine);
                  end;

                  result := True;
                end;
              finally
                begin
                  CloseFile(InputFile);
                  Flush(FirstFile);
                  CloseFile(FirstFile);
                  Flush(ResultFile);
                  CloseFile(ResultFile);
                end;
              end;
            end;
          if not result then
          begin
            Beep;
            MessageDlg('Unable to split ' + InputFilePath + '.',
              mtError, [mbOK], 0);
          end;
        end
      Except on E: Exception do
        begin
          MessageDlg(E.Message, mtError, [mbOK], 0);
        end;
      end;
    end;
  finally
    begin
      ANE_BOOL_PTR(reply)^ := result;
    end;
  end;

end;

procedure GPIEInt2CharMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  result : ANE_STR;
  param : PParameter_array;
  ResultString : string;
  FirstDiget, SecondDigit : integer;
begin
  result := '';
  try
    begin
      try
        begin
          param := @parameters^;
          param1_ptr :=  param^[0];
          param1 :=  param1_ptr^;
          if param1 < 10 then
          begin
            ResultString := IntToStr(param1);
          end
          else
          begin
            param1 := param1 -10;
            if param1 < 26 then
            begin
              ResultString := Char(65+param1);
            end
            else
            begin
              FirstDiget := param1 div 26;
              SecondDigit := param1 mod 26;
              if FirstDiget < 10 then
              begin
                ResultString := IntToStr(FirstDiget);
              end
              else
              begin
                FirstDiget := FirstDiget -10;
                ResultString := Char(65+FirstDiget);
              end;

              if SecondDigit < 10 then
              begin
                ResultString := ResultString + IntToStr(SecondDigit);
              end
              else
              begin
                SecondDigit := SecondDigit -10;
                ResultString := ResultString + Char(65+SecondDigit);
              end;
            end;
          end;
          result := PChar(ResultString);
        end;
      Except on E: Exception do
        begin
          Beep;
          MessageDlg(E.Message, mtError, [mbOK], 0);
        end;
      end;
    end;
  finally
    begin
      ANE_STR_PTR(reply)^ := result;
    end;
  end;
end;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
const
  ModelPrefix = '';
//  ModelPrefix = 'MODFLOW_';
//  ModelPrefix = 'SUTRA_';
var
  Options : EFunctionPIEFlags;
begin

	numNames := 0;

        if ShowHiddenFunctions then
        begin
          Options := 0;                      // Option to use for development work
        end
        else
        begin
          Options := kFunctionIsHidden;    // Hide all functions from regular users to keep them from being misused.
        end;    


        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

        gPIEJoinFilesFDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
	gPIEJoinFilesFDesc.name :=PChar(ModelPrefix + 'Join_Files');	        // name of function
	gPIEJoinFilesFDesc.address := GPIEJoinFilesMMFun;		// function address
	gPIEJoinFilesFDesc.returnType := kPIEBoolean;		// returns True if it succeeds and False if it fails
	gPIEJoinFilesFDesc.numParams :=  3;			// number of parameters
	gPIEJoinFilesFDesc.numOptParams := 0;			// number of optional parameters
	gPIEJoinFilesFDesc.paramNames := @gpn3Files;		// pointer to parameter names list
	gPIEJoinFilesFDesc.paramTypes := @g3StringTypes;	// pointer to parameters types list
	gPIEJoinFilesFDesc.functionFlags := Options;	        // function options

       	gPIEJoinFilesDesc.name  :=PChar(ModelPrefix + 'Join_Files');		// name of PIE
	gPIEJoinFilesDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEJoinFilesDesc.descriptor := @gPIEJoinFilesFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEJoinFilesDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	descriptors := @gFunDesc;

        gPIEDeleteFileFDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
	gPIEDeleteFileFDesc.name :=PChar(ModelPrefix + 'Delete_File');	        // name of function
	gPIEDeleteFileFDesc.address := GPIEDeleteFileMMFun;		// function address
	gPIEDeleteFileFDesc.returnType := kPIEBoolean;		// returns True if it succeeds and False if it fails
	gPIEDeleteFileFDesc.numParams :=  1;			// number of parameters
	gPIEDeleteFileFDesc.numOptParams := 0;			// number of optional parameters
	gPIEDeleteFileFDesc.paramNames := @gpn1File;		// pointer to parameter names list
	gPIEDeleteFileFDesc.paramTypes := @g1StringType;	// pointer to parameters types list
	gPIEDeleteFileFDesc.functionFlags := Options;	        // function options

       	gPIEDeleteFileDesc.name  :=PChar(ModelPrefix + 'Delete_File');		// name of PIE
	gPIEDeleteFileDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEDeleteFileDesc.descriptor := @gPIEDeleteFileFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEDeleteFileDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	descriptors := @gFunDesc;

        gPIERenameFileFDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
	gPIERenameFileFDesc.name :=PChar(ModelPrefix + 'Rename_File');	        // name of function
	gPIERenameFileFDesc.address := GPIERenameFileMMFun;		// function address
	gPIERenameFileFDesc.returnType := kPIEBoolean;		// returns True if it succeeds and False if it fails
	gPIERenameFileFDesc.numParams :=  2;			// number of parameters
	gPIERenameFileFDesc.numOptParams := 0;			// number of optional parameters
	gPIERenameFileFDesc.paramNames := @gpn2File;		// pointer to parameter names list
	gPIERenameFileFDesc.paramTypes := @g2StringType;	// pointer to parameters types list
	gPIERenameFileFDesc.functionFlags := Options;	        // function options

       	gPIERenameFileDesc.name  :=PChar(ModelPrefix + 'Rename_File');		// name of PIE
	gPIERenameFileDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIERenameFileDesc.descriptor := @gPIERenameFileFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIERenameFileDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names


        // Split Files
        gPIESplitFileFDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
	gPIESplitFileFDesc.name :=PChar(ModelPrefix + 'Split_File');	        // name of function
	gPIESplitFileFDesc.address := GPIESplitFileMMFun;		// function address
	gPIESplitFileFDesc.returnType := kPIEBoolean;		// returns True if it succeeds and False if it fails
	gPIESplitFileFDesc.numParams :=  4;			// number of parameters
	gPIESplitFileFDesc.numOptParams := 56;			// number of optional parameters
	gPIESplitFileFDesc.paramNames := @gpnSearch;		// pointer to parameter names list
	gPIESplitFileFDesc.paramTypes := @g30StringTypes;	// pointer to parameters types list
	gPIESplitFileFDesc.functionFlags := Options;	        // function options

       	gPIESplitFileDesc.name  :=PChar(ModelPrefix + 'Split_File');		// name of PIE
	gPIESplitFileDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIESplitFileDesc.descriptor := @gPIESplitFileFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESplitFileDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

        // Integer to string
        gPIEIntToCharFDesc.version := FUNCTION_PIE_VERSION;       // Function PIE verions
	gPIEIntToCharFDesc.name :=PChar(ModelPrefix + 'Int2Str');	        // name of function
	gPIEIntToCharFDesc.address := GPIEInt2CharMMFun;		// function address
	gPIEIntToCharFDesc.returnType := kPIEString;		// returns True if it succeeds and False if it fails
	gPIEIntToCharFDesc.numParams :=  1;			// number of parameters
	gPIEIntToCharFDesc.numOptParams := 0;			// number of optional parameters
	gPIEIntToCharFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEIntToCharFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gPIEIntToCharFDesc.functionFlags := Options;	        // function options

       	gPIEIntToCharDesc.name  :=PChar(ModelPrefix + 'Int2Str');		// name of PIE
	gPIEIntToCharDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEIntToCharDesc.descriptor := @gPIEIntToCharFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEIntToCharDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names


	gPIECheckVersionFDesc.name := PChar(ModelPrefix + 'JF_CheckVersion');	        // name of function
	gPIECheckVersionFDesc.address := GPIECheckVersionMMFun;		// function address
	gPIECheckVersionFDesc.returnType := kPIEBoolean;		// return value type
	gPIECheckVersionFDesc.numParams :=  4;			// number of parameters
	gPIECheckVersionFDesc.numOptParams := 0;			// number of optional parameters
	gPIECheckVersionFDesc.paramNames := @gpnFourDigit;		// pointer to parameter names list
	gPIECheckVersionFDesc.paramTypes := @gFourIntegerTypes;	// pointer to parameters types list
        gPIECheckVersionFDesc.version := FUNCTION_PIE_VERSION;
        gPIECheckVersionFDesc.functionFlags := Options;

       	gPIECheckVersionDesc.name  := PChar(ModelPrefix + 'JF_CheckVersion');		// name of PIE
	gPIECheckVersionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;	// pointer to descriptor
        gPIECheckVersionDesc.version := ANE_PIE_VERSION;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECheckVersionDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIECopyLinesFDesc.name := PChar(ModelPrefix + 'JF_CopyLines');	        // name of function
	gPIECopyLinesFDesc.address := GPIECopyLinesMMFun;		// function address
	gPIECopyLinesFDesc.returnType := kPIEBoolean;		// return value type
	gPIECopyLinesFDesc.numParams :=  3;			// number of parameters
	gPIECopyLinesFDesc.numOptParams := 1;			// number of optional parameters
	gPIECopyLinesFDesc.paramNames := @gpn2FileCount;		// pointer to parameter names list
	gPIECopyLinesFDesc.paramTypes := @g2String1IntegerType;	// pointer to parameters types list
        gPIECopyLinesFDesc.version := FUNCTION_PIE_VERSION;
        gPIECopyLinesFDesc.functionFlags := Options;

       	gPIECopyLinesDesc.name  := PChar(ModelPrefix + 'JF_CopyLines');		// name of PIE
	gPIECopyLinesDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECopyLinesDesc.descriptor := @gPIECopyLinesFDesc;	// pointer to descriptor
        gPIECopyLinesDesc.version := ANE_PIE_VERSION;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECopyLinesDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names



	descriptors := @gFunDesc;

end;

end.
