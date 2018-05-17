{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
"http://www.w3.org/TR/REC-html40/loose.dtd">
<HTML><BODY BGCOLOR="#ffffff"><PRE>}

Unit Ads_DB;

{Copyright(c)1998 Advanced Delphi Systems

 Richard Maley
 Advanced Delphi Systems
 12613 Maidens Bower Drive
 Potomac, MD 20854 USA
 phone 301-840-1554
 maley@advdelphisys.com
 maley@compuserve.com
 maley@cpcug.org}

Interface

Uses
  SysUtils, StdCtrls, Dialogs, Forms, ExtCtrls,
  Messages, WinProcs, WinTypes, Buttons, Classes,
  DB, DBTables, Controls, Grids, {UtilKeys,} IniFiles, Graphics,
  ShellAPI, FileCtrl, wininet {$IFNDEF WIN32}, ToolHelp{$ENDIF};

Const RunOutsideIDE_ads        = True;
Const RunOutsideIDEDate_ads    = '12/31/99';
Const RunOutsideIDECompany_ads = 'Advanced Delphi Systems';
Const RunOutsideIDEPhone_ads   = 'Please purchase at (301) 840-1554';


{!~ Add source table to destination table}
Function AddTables(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable: string): Boolean;

{!~ Creates a new table from a Query.
 Complex joins can be output to a new table.}
Function CreateTableFromQuery(
            Query: TQuery;
            NewTableName,
            TableDatabaseName: String): Boolean;

{!~ Add source query to destination table}
Procedure DBAddQueryToTable(
      DataSet : TQuery;
      const
      DestDatabaseName,
      DestinationTable: string);

{!~ Add source table to destination table}
Function DBAddTables(
      const
      SourceDatabaseName,
      SourceTable,
      DestDatabaseName,
      DestinationTable: string): Boolean;

{!~ Copies Field A To Field B.}
function DBCopyFieldAToB(
            DatabaseName,
            TableName,
            SourceField,
            DestField: String): Boolean;

{!~ Copies SourceTable To DestTable.
If DestTable exists it is deleted}
Function DBCopyTable(
            SourceDatabaseName,
            SourceTable,
            DestDatabaseName,
            DestTable: String): Boolean;

{!~ Copies Table A To Table B.  If Table B exists it
is emptied}
Function DBCopyTableAToB(
            SourceDatabaseName,
            SourceTable,
            DestDatabaseName,
            DestTable: String): Boolean;

{!~ Copies a table from the source to the destination.
If the destination table exists the function will not
throw an error, the existing table will be replaced with the new
table.}
Function DBCopyTableToServer(
  SourceDatabaseName   : String;
  SourceTableName      : String;
  DestDatabaseName     : String;
  DestTableName        : String): Boolean;

{!~ Creates an empty table with indices by borrowing the structure
of a source table. Source and destination can be remote or local
tables.  If the destination table exists the function will not
throw an error, the existing table will be replaced with the new
table.}
Function DBCreateTableBorrowStr(
  SourceDatabaseName   : String;
  SourceTableName      : String;
  DestDatabaseName     : String;
  DestTableName        : String): Boolean;

{!~ Creates a new table from a Query.
 Complex joins can be output to a new table.}
Function DBCreateTableFromQuery(
            Query: TQuery;
            NewTableName,
            TableDatabaseName: String): Boolean;

{!~ Deletes A Table}
Function DBDeleteTable(const DatabaseName, TableName : string):Boolean;

{!~ Drops A Table}
Function DBDropTable(const DatabaseName, TableName : string):Boolean;

{!~ Empties a table of all records}
Function DBEmptyTable(
           const DatabaseName,
           TableName : string): Boolean;

{!~ Returns the field Name as a String.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason '' is returned.}
Function DBFieldNameByNo(
  DatabaseName  : String;
  TableName     : String;
  FieldNo       : Integer): String;

{!~ Returns Field Names shared by 2 tables as a string.
Fields are separated by commas with no trailing comma.}
Function DBFieldNamesCommonToString(
  DatabaseName1 : String;
  TableName1    : String;
  DatabaseName2 : String;
  TableName2    : String): String;

{!~ Copies Field Names shared by 2 tables to a TStrings object.
Returns true if successful.  If there
is an error, the DatabaseName doesn't exist, the table doesn't
exist or some other reason False is returned.  }
Function DBFieldNamesCommonToTStrings(
  DatabaseName1 : String;
  TableName1    : String;
  DatabaseName2 : String;
  TableName2    : String;
  Strings       : TStrings): Boolean;

{!~ Copies Table Field Names to a TStrings object, e.g.,
ListBox1.Items, Memo1.Lines.

Returns the true if successful.  If there
is an error, the DatabaseName doesn't exist, the table doesn't
exist or some other reason False is returned.  }
Function DBFieldNamesToTStrings(
  DatabaseName : String;
  TableName    : String;
  Strings      : TStrings): Boolean;

{!~ Returns the field Number as an integer.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason -1 is returned.}
Function DBFieldNo(DatabaseName, TableName, FieldName: String): Integer;

{!~ Returns the database field Size as an integer.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason 0 is returned.}
Function DBFieldSize(DatabaseName, TableName, FieldName: String): Integer;

{!~ Returns the database field type as a string.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason a null string is returned.}
Function DBFieldType(DatabaseName, TableName, FieldName: String): String;

{!~ Returns the database field type as a string.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason a null string is returned.}
Function DBFieldTypeByNo(DatabaseName, TableName: String; FieldNo: Integer): String;

{!~ Replace all the values in a field that match a
condition value with a new value}
procedure DBGlobalStringFieldChange(
  const DatabaseName,
  TableName,
  FieldName,
  NewValue : string);

{!~ Replace all the values in a field with a new value}
procedure DBGlobalStringFieldChangeWhere(
  const DatabaseName,
  TableName,
  FieldName,
  CurrentValue,
  NewValue : string);

{!~ Replace values in a field (NewValueField) with NewValue
based on a where condition in CurrentValueField with a value
of CurrentValue}
procedure DBGlobalStringFieldChangeWhere2(
  const DatabaseName,
  TableName,
  NewValueField,
  NewValue,
  CurrentValueField,
  CurrentValue: string);

{!~ Inserts matching fields in a destination table.
Source Table records are deleted if the record was inserted properly.
Records unsuccessfully inserted are retained and the problems recorded
in the ErrorField.}
Function DBInsertMatchingFields(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable,
           ErrorField: string): Boolean;

{!~ Copies Table Key Field Names to a TStrings object.
Returns the true if successful.  If there
is an error, the DatabaseName doesn't exist, the table doesn't
exist or some other reason False is returned.  }
Function DBKeyFieldNamesToTStrings(
  DatabaseName : String;
  TableName    : String;
  Strings      : TStrings): Boolean;

{!~ Presents a lookup Dialog to the user.  The selected
value is returned if the user presses OK and the Default
value is returned if the user presses Cancel unless the
TStringList is nil in which case a blank string is returned}
Function DBLookUpDialog(
  Const DataBaseName  : String;
  Const TableName     : String;
  Const FieldName     : String;
  Const SessionName   : String;
  Const DefaultValue  : String;
  const DialogCaption : string;
  const InputPrompt   : string;
  const DialogWidth   : Integer
  ): String;

{!~ Returns the median value for a column in a table
as type single}
Function DBMedianSingle(
      const DatabaseName,
      TableName,
      FieldName,
      WhereString
      : string): Single;

{!~ Moves SourceTable From SourceDatabaseName
 To DestDatabasename.  If a table exists
 with the same name at DestDatabaseName it
 is overwritten.}
Function DBMoveTable(
            SourceTable,
            SourceDatabaseName,
            DestDatabaseName: String): Boolean;

{!~ Returns the number of fields in a table}
Function DBNFields(DatabaseName, TableName: String): Integer;

{!~ Returns the next key value when the table keys are
numbers as strings, e.g., '   12' key would return
'   13'}
Function DBNextAlphaKey(DatabaseName, TableName, FieldName: String):String;

{!~ Returns the next key value when the table keys are
integers, e.g., 12 key would return 13}
Function DBNextInteger(
  DatabaseName,
  TableName,
  FieldName: String):LongInt;

{!~ ReKeys a Paradox Table to the first N fields}
Function DBParadoxCreateNKeys(
  DatabaseName : String;
  TableName    : String;
  NKeys        : Integer): Boolean;

{!~ ReNames a table}
Function DBReNameTable(
  DatabaseName,
  TableNameOld,
  TableNameNew: String): Boolean;

{!~ Applies BatchMode Types As Appropriate To
Source and Destination Tables}
Function DBRecordMove(
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestTable: String;
           BMode: TBatchMode): Boolean;

{!~ Returns True If The Tables Have Identical Structures, False Otherwise.
If 1 Local Table is involved then Indices are ignored!!!!!!}
Function DBSchemaSame(const
           DatabaseName1,
           Table1,
           DatabaseName2,
           Table2: string): Boolean;

{!~ Creates a new TSession object.}
{$IFDEF WIN32}
Function DBSessionCreateNew: TSession;
{$ENDIF WIN32}

{!~ Returns a value for use in a sql where clause with the
appropriate Quoting of the value based on its datatype.  If
an error occurs the original string value is returned unchanged}
Function DBSqlValueQuoted(
  const
  DatabaseName,
  TableName,
  FieldName,
  FieldValue: string): String;

{!~ Subtracts the records in the source
 table from the destination table}
Function DBSubtractTable(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable: string): Boolean;

{!~ Trims blank spaces from the Left of the string}
Function DBTrimBlanksLeft(
  DatabaseName : String;
  TableName    : String;
  FieldName    : String): Boolean;

{!~ Trims blank spaces from the right of the string}
Function DBTrimBlanksRight(
  DatabaseName : String;
  TableName    : String;
  FieldName    : String): Boolean;

{!~ Updates matching fields in a destination table.
Source Table records are deleted if the record was updated properly.
Records unsuccessfully updated are retained and the problems recorded
in the ErrorField.}
Function DBUpdateMatchingFields(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable,
           ErrorField: string;
           MsgPanel: TPanel;
           FilePath: String): Boolean;

{!~ Deletes A Table}
Function DeleteTable(const DatabaseName, TableName : string):Boolean;

{!~ Presents a lookup Dialog to the user.  The selected
value is returned if the user presses OK and the Default
value is returned if the user presses Cancel unless the
TStringList is nil in which case a blank string is returned}
Function DialogDBLookUp(
  Const DataBaseName  : String;
  Const TableName     : String;
  Const FieldName     : String;
  Const SessionName   : String;
  Const DefaultValue  : String;
  const DialogCaption : string;
  const InputPrompt   : string;
  const DialogWidth   : Integer
  ): String;

{!~ Presents a lookup Dialog to the user.  The selected
value is returned if the user presses OK and the Default
value is returned if the user presses Cancel unless the
TStringList is nil in which case a blank string is returned}
Function DialogLookup(
  const DialogCaption : string;
  const InputPrompt   : string;
  const DefaultValue  : string;
  const Values        : TStringList
  ): string;

{!~ Presents a lookup Dialog to the user.  The selected
value is returned if the user presses OK and the Default
value is returned if the user presses Cancel unless the
TStringList is nil in which case a blank string is returned}
Function DialogLookupDetail(
  Const DialogCaption   : string;
  Const InputPrompt     : string;
  Const DefaultValue    : string;
  Const Values          : TStringList;
  Const ButtonSpacing   : Integer;
  Const SpacerHeight    : Integer;
  Const TopBevelWidth   : Integer;
  Const PromptHeight    : Integer;
  Const FormHeight      : Integer;
  Const FormWidth       : Integer;
  Const Hint_OK         : string;
  Const Hint_Cancel     : string;
  Const Hint_ListBox    : string;
  Const ListSorted      : Boolean;
  Const AllowDuplicates : Boolean
  ): string;

{!~ Drops A Table}
Function DropTable(const DatabaseName, TableName : string):Boolean;

{!~ Empties a table of all records}
Function EmptyTable(
           const DatabaseName,
           TableName : string): Boolean;

{!~ Returns the meaning of the given result code.  Error codes are for
Delphi 1.0.}
function ErrorMeaning (ResultCode: Integer): string;

{!~ Returns the field Number as an integer.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason 0 is returned.}
Function FieldNo(DatabaseName, TableName, FieldName: String): Integer;

{!~ Returns the database field Size as an integer.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason 0 is returned.}
Function FieldSize(DatabaseName, TableName, FieldName: String): Integer;

{!~ Returns the database field type as a string.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason a null string is returned.}
Function FieldType(DatabaseName, TableName, FieldName: String): String;

{!~ Returns the database field type as a string.  If there
is an error a null string is returned.}
Function FieldTypeFromDataSet(DataSet: TDataSet; FieldName: String): String;

{!~ Tests whether a TDataSource is empty, i.e., has no records }
Function IsEmptyDataSource(DS: TDataSource): Boolean;

{!~ Tests whether a TQuery is empty, i.e., has no records }
Function IsEmptyTQuery(Query: TQuery): Boolean;

{!~ Tests whether a TTable is empty, i.e., has no records }
Function IsEmptyTTable(Table: TTable): Boolean;

{!~ Tests whether a table is empty, i.e., has no records }
Function IsEmptyTable(DatabaseName, TableName: String): Boolean;

{!~ Returns True If DatabaseName:TableName:FieldName Exists,
False Otherwise}
Function IsField(DatabaseName, TableName, FieldName: String): Boolean;

{!~ Returns True If DatabaseName:TableName:FieldName
 Exists and is Keyed, False Otherwise}
Function IsFieldKeyed(DatabaseName, TableName, FieldName: String): Boolean;

{!~ Returns True If The Record Exists, False Otherwise}
Function IsRecord(
  DatabaseName : String;
  TableName    : String;
  TableKeys    : TStringList;
  KeyValues    : TStringList): Boolean;

{!~ Returns True If The Tables Have Identical Structures, False Otherwise.
If 1 Local Table is involved then Indices are ignored!!!!!!}
Function IsSchemaSame(const
           DatabaseName1,
           Table1,
           DatabaseName2,
           Table2: string): Boolean;

{!~ Returns True If The Tables Have Identical Structures, False Otherwise.
If 1 Local Table is involved then Indices are ignored!!!!!!}
Function IsStructureSame(const
           DatabaseName1,
           Table1,
           DatabaseName2,
           Table2: string): Boolean;

{!~ Returns True If The Table Exists, False Otherwise.
This procedure needs to be improved.
Please give recommendations or new code.}
Function IsTable(DatabaseName, TableName: String): Boolean;

{!~ Returns True If DatabaseName:TableName
Exists and has a primary key, False Otherwise}
Function IsTableKeyed(DatabaseName, TableName: String): Boolean;

{!~ Presents a lookup Dialog to the user.  The selected
value is returned if the user presses OK and the Default
value is returned if the user presses Cancel unless the
TStringList is nil in which case a blank string is returned}
Function LookupDialog(
  const DialogCaption : string;
  const InputPrompt   : string;
  const DefaultValue  : string;
  const Values        : TStringList
  ): string;

{!~ Moves SourceTable From SourceDatabaseName
 To DestDatabasename.  If a table exists
 with the same name at DestDatabaseName it
 is overwritten.}
Function MoveTable(
            SourceTable,
            SourceDatabaseName,
            DestDatabaseName: String): Boolean;

{!~ Returns the number of fields in a table}
Function NFields(DatabaseName, TableName: String): Integer;

{!~ Subtracts the records in the source
 table from the destination table}
Function SubtractTable(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable: string): Boolean;

{!~ Add source table to destination table}
Function TableAdd(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable: string): Boolean;

{!~ Creates a new table from a Query.
 Complex joins can be output to a new table.}
Function TableCreateFromQuery(
            Query: TQuery;
            NewTableName,
            TableDatabaseName: String): Boolean;

{!~ Moves SourceTable From SourceDatabaseName
 To DestDatabasename.  If a table exists
 with the same name at DestDatabaseName it
 is overwritten.}
Function TableMove(
            SourceTable,
            SourceDatabaseName,
            DestDatabaseName: String): Boolean;

{!~ Subtracts the records in the source
 table from the destination table}
Function TableSubtract(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable: string): Boolean;

{!~ Returns the database field type as a string.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason a null string is returned.}
Function TypeField(DatabaseName, TableName, FieldName: String): String;

{!~ Returns the database field type as a string.  If there
is an error a null string is returned.}
Function TypeFieldFromDataSet(DataSet: TDataSet; FieldName: String): String;


Implementation

{Pads or truncates a String and Justifies Left if StrJustify=True}
Function StringPad(
  InputStr,
  FillChar: String;
  StrLen: Integer;
  StrJustify: Boolean): String;
Var
  TempFill: String;
  Counter : Integer;
Begin
  If Not (Length(InputStr) = StrLen) Then
  Begin
    If Length(InputStr) > StrLen Then
    Begin
      InputStr := Copy(InputStr,1,StrLen);
    End
    Else
    Begin
      TempFill := '';
      For Counter := 1 To StrLen-Length(InputStr) Do
      Begin
        TempFill := TempFill + FillChar;
      End;
      If StrJustify Then
      Begin
        {Left Justified}
        InputStr := InputStr + TempFill;
      End
      Else
      Begin
        {Right Justified}
        InputStr := TempFill + InputStr ;
      End;
    End;
  End;
  Result := InputStr;
End;

{Replaces all occurances of a character in a string
with a new character}
Function ReplaceCharInString(S,OldChar,NewChar :String): String;
Var
  NewString  : String;
  i          : Integer;
  L          : Integer;
  C          : String;
Begin
  Result     := '';
  NewString  := '';
  L          := Length(S);

  {If the string is empty then get out of here}
  If L = 0 Then Exit;

  {If the string doesn't have any occurances of the
  OldChar then get out of here}
  If Pos(UpperCase(OldChar),UpperCase(S)) = 0 Then
  Begin
    Result := S;
    Exit;
  End;

  For i := 1 To L Do
  Begin
    C := Copy(S,i,1);
    If UpperCase(C) = UpperCase(OldChar) Then
    Begin
      NewString := NewString + NewChar;
    End
    Else
    Begin
      NewString := NewString + C;
    End;
  End;
  Result     := NewString;
End;

{!~ Throws away all keys except 0-9,-,+,.}
Procedure KeyPressOnlyNumbers(Var Key: Char);
Begin
  Case Key Of
    '0': Exit;
    '1': Exit;
    '2': Exit;
    '3': Exit;
    '4': Exit;
    '5': Exit;
    '6': Exit;
    '7': Exit;
    '8': Exit;
    '9': Exit;
    '-': Exit;
    '+': Exit;
    '.': Exit;
    #8 : Exit; {Backspace}
  End;
  Key := #0;   {Throw the key away}
End;

{!~ Throws away all keys except 0-9}
Procedure KeyPressOnlyNumbersAbsolute(Var Key: Char);
Begin
  Case Key Of
    '0': Exit;
    '1': Exit;
    '2': Exit;
    '3': Exit;
    '4': Exit;
    '5': Exit;
    '6': Exit;
    '7': Exit;
    '8': Exit;
    '9': Exit;
    #8 : Exit; {Backspace}
  End;
  Key := #0;   {Throw the key away}
End;

{!~ Throws away all keys except a-z and A-Z}
Procedure KeyPressOnlyAToZ(Var Key: Char);
Begin
  Case Key Of
    'a': Exit;
    'b': Exit;
    'c': Exit;
    'd': Exit;
    'e': Exit;
    'f': Exit;
    'g': Exit;
    'h': Exit;
    'i': Exit;
    'j': Exit;
    'k': Exit;
    'l': Exit;
    'm': Exit;
    'n': Exit;
    'o': Exit;
    'p': Exit;
    'q': Exit;
    'r': Exit;
    's': Exit;
    't': Exit;
    'u': Exit;
    'v': Exit;
    'w': Exit;
    'x': Exit;
    'y': Exit;
    'z': Exit;
    'A': Exit;
    'B': Exit;
    'C': Exit;
    'D': Exit;
    'E': Exit;
    'F': Exit;
    'G': Exit;
    'H': Exit;
    'I': Exit;
    'J': Exit;
    'K': Exit;
    'L': Exit;
    'M': Exit;
    'N': Exit;
    'O': Exit;
    'P': Exit;
    'Q': Exit;
    'R': Exit;
    'S': Exit;
    'T': Exit;
    'U': Exit;
    'V': Exit;
    'W': Exit;
    'X': Exit;
    'Y': Exit;
    'Z': Exit;
    #8 : Exit; {Backspace}
  End;
  Key := #0;   {Throw the key away}
End;

{Increments the screen cursor to show progress}
procedure ProgressScreenCursor;
Begin
  If Screen.Cursor = crUpArrow Then
  Begin
    Screen.Cursor := crSizeNESW;
    Exit;
  End;
  If Screen.Cursor = crSizeNESW Then
  Begin
    Screen.Cursor := crSizeWE;
    Exit;
  End;
  If Screen.Cursor = crSizeWE Then
  Begin
    Screen.Cursor := crSizeNWSE;
    Exit;
  End;
  If Screen.Cursor = crSizeNWSE Then
  Begin
    Screen.Cursor := crSizeNS;
    Exit;
  End;

  If Screen.Cursor = crSizeNS Then
  Begin
    Screen.Cursor := crHSplit;
    Exit;
  End;

  If Screen.Cursor = crHSplit Then
  Begin
    Screen.Cursor := crSize;
    Exit;
  End;

  If Screen.Cursor = crSize Then
  Begin
    Screen.Cursor := crArrow;
    Exit;
  End;

  If Screen.Cursor = crArrow Then
  Begin
    Screen.Cursor := crUpArrow;
    Exit;
  End;
  Screen.Cursor := crUpArrow;
End;

Type
  TPanel_Cmp_Sec_ads = class(TPanel)
  Public
    procedure ResizeShadowLabel(Sender: TObject);
  End;

procedure TPanel_Cmp_Sec_ads.ResizeShadowLabel(
  Sender     : TObject);
Var
  PH, PW : Integer;
  LH, LW : Integer;
begin
  PH := TPanel(Sender).Height;
  PW := TPanel(Sender).Width;
  LH := TLabel(Controls[0]).Height;
  LW := TLabel(Controls[0]).Width;
  TLabel(Controls[0]).Top  := ((PH-LH) div 2)-3;
  TLabel(Controls[0]).Left := ((Pw-Lw) div 2)-3;
end;

Type
  TEditKeyFilter = Class(TEdit)
  Published
    {!~ Throws away all keys except 0-9,-,+,.}
    Procedure OnlyNumbers(Sender: TObject; var Key: Char);

    {!~ Throws away all keys except 0-9}
    Procedure OnlyNumbersAbsolute(Sender: TObject; var Key: Char);

    {!~ Throws away all keys except a-z and A-Z}
    Procedure OnlyAToZ(Sender: TObject; var Key: Char);

  End;

{!~ Throws away all keys except 0-9,-,+,.}
Procedure TEditKeyFilter.OnlyNumbers(Sender: TObject; var Key: Char);
Begin
  KeyPressOnlyNumbers(Key);
End;

{!~ Throws away all keys except 0-9}
Procedure TEditKeyFilter.OnlyNumbersAbsolute(Sender: TObject; var Key: Char);
Begin
  KeyPressOnlyNumbersAbsolute(Key);
End;

{!~ Throws away all keys except a-z and A-Z}
Procedure TEditKeyFilter.OnlyAToZ(Sender: TObject; var Key: Char);
Begin
  KeyPressOnlyAToZ(Key);
End;

{!~ Add source table to destination table}
Function AddTables(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable: string): Boolean;
Var
  BMode : TBatchMode;
Begin
  If IsTableKeyed(DestDatabaseName,DestinationTable) Then
  Begin
    If IsTableKeyed(SourceDatabaseName,SourceTable) Then
    Begin
      BMode := BatAppendUpdate;
    End
    Else
    Begin
      BMode := BatAppend;
    End;
  End
  Else
  Begin
    BMode := BatAppend;
  End;

  Result := DBRecordMove(SourceDatabaseName,SourceTable,
                         DestDatabaseName,DestinationTable,BMode);
End;

{!~ Creates a new table from a Query.
 Complex joins can be output to a new table.}
Function CreateTableFromQuery(
            Query: TQuery;
            NewTableName,
            TableDatabaseName: String): Boolean;
Begin
  Result := DBCreateTableFromQuery(Query,NewTableName,TableDatabaseName);
End;

{!~ Add source query to destination table}
Procedure DBAddQueryToTable(
      DataSet : TQuery;
      const
      DestDatabaseName,
      DestinationTable: string);
var
  DTable : TTable;
  BMove  : TBatchMove;
begin
  DTable := TTable.Create(nil);
  BMove  := TBatchMove.Create(nil);
  Try
    DataSet.Active         := True;
    DTable.DatabaseName    := DestDatabaseName;
    DTable.TableName       := DestinationTable;
    DTable.Active          := True;
    BMove.AbortOnKeyViol   := False;
    BMove.AbortOnProblem   := False;
    BMove.ChangedTableName := 'CTable';
    BMove.Destination      := DTable;
    BMove.KeyViolTableName := 'KTable';
    BMove.Mode             := batAppend;
    BMove.ProblemTableName := 'PTable';
    BMove.Source           := DataSet;
    BMove.Execute;
  Finally
    DTable.Active            := False;
    DTable.Free;
    BMove.Free;
  End;
End;

{!~ Add source table to destination table}
Function DBAddTables(
      const
      SourceDatabaseName,
      SourceTable,
      DestDatabaseName,
      DestinationTable: string): Boolean;
begin
  Result := AddTables(SourceDatabaseName,SourceTable,
                      DestDatabaseName,DestinationTable);
End;

{!~ Copies Field A To Field B.}
function DBCopyFieldAToB(
            DatabaseName,
            TableName,
            SourceField,
            DestField: String): Boolean;
var
  Query     : TQuery;
  CursorWas : TCursor;
  Sess      : TSession;
begin
  CursorWas         := Screen.Cursor;
  Sess              := DBSessionCreateNew;
  Sess.Active       := True;
  Query             := TQuery.Create(sess);
  Query.SessionName := Sess.SessionName;
  Sess.Active       := True;
  Query.Active      := False;
  Query.RequestLive := True;
  try
    Result := False;
    Query.DatabaseName := DatabaseName;
    Query.SQL.Clear;
    Query.SQL.Add('Select ');
    Query.SQL.Add(SourceField+',');
    Query.SQL.Add(DestField);
    Query.SQL.Add('From '+TableName);
    Query.Open;
    Query.First;
    While Not Query.EOF Do
    Begin
      ProgressScreenCursor;
      Try
        Query.Edit;
        Query.FieldByName(DestField).AsString :=
          Query.FieldByName(SourceField).AsString;
        Query.Post;
      Except
      End;
      Query.Next;
    End;
    Result := True;
  finally
    Query.Free;
    Screen.Cursor := CursorWas;
    Sess.Active   := False;
  end;
end;

{!~ Copies SourceTable To DestTable.
If DestTable exists it is deleted}
Function DBCopyTable(
            SourceDatabaseName,
            SourceTable,
            DestDatabaseName,
            DestTable: String): Boolean;
Begin
  Result := DBRecordMove(SourceDatabaseName,SourceTable,
                         DestDatabaseName,DestTable,batCopy);
End;

{!~ Copies Table A To Table B.  If Table B exists it
is emptied}
Function DBCopyTableAToB(
            SourceDatabaseName,
            SourceTable,
            DestDatabaseName,
            DestTable: String): Boolean;
begin
  Result :=
    DBCopyTable(
      SourceDatabaseName,
      SourceTable,
      DestDatabaseName,
      DestTable);
End;

{!~ Copies a table from the source to the destination.
If the destination table exists the function will not
throw an error, the existing table will be replaced with the new
table.}
Function DBCopyTableToServer(
  SourceDatabaseName   : String;
  SourceTableName      : String;
  DestDatabaseName     : String;
  DestTableName        : String): Boolean;
Begin
  Result := False;
  Try
    If DBCreateTableBorrowStr(
         SourceDatabaseName,
         SourceTableName,
         DestDatabaseName,
         DestTableName)
    Then
    Begin
      If  AddTables(
            SourceDatabaseName,
            SourceTableName,
            DestDatabaseName,
            DestTableName)
      Then
      Begin
        Result := True;
      End;
    End;
  Except
    On E : Exception Do
    Begin
      ShowMessage('DBCopyTableToServer Error: '+E.Message);
      Result := False;
    End;
  End;
End;
{!
This is a very powerfull migration utility.
It can be used to copy tables from and to any location.
The following example copies the DBDemos "Customer.db" table to
a Sybase client server database.

DBCopyTableToServer(
  'DBDemos',
  'Customer.Db',
  'SybaseDb',
  'Customer');
}

{!~ Creates an empty table with indices by borrowing the structure
of a source table. Source and destination can be remote or local
tables.  If the destination table exists the function will not
throw an error, the existing table will be replaced with the new
table.}
Function DBCreateTableBorrowStr(
  SourceDatabaseName   : String;
  SourceTableName      : String;
  DestDatabaseName     : String;
  DestTableName        : String): Boolean;
Var
  S             : TTable;
  D             : TTable;
  i,j           : Integer;
  IMax          : Integer;
  IndexName     : String;
  IndexFields   : String;
  IndexFields2  : String;
  Q             : TQuery;
  IDXO          : TIndexOptions;
Begin
  S := TTable.Create(nil);
  D := TTable.Create(nil);
  Try
    Try
      S.Active       := False;
      S.DatabaseName := SourceDatabaseName;
      S.TableName    := SourceTableName;
      S.TableType    := ttDefault;
      S.Active       := True;
      D.DatabaseName := DestDatabaseName;
      D.TableName    := DestTableName;
      D.TableType    := ttDefault;
      D.FieldDefs.Assign(S.FieldDefs);
      D.CreateTable;
      {Similar method could be used to create the indices}
      {D.IndexDefs.Assign(S.IndexDefs);}
      S.IndexDefs.Update;
      D.IndexDefs.Update;
      D.IndexDefs.Clear;
      D.IndexDefs.Update;
      For i := 0 To S.IndexDefs.Count - 1 Do
      Begin
        If Pos('.DB',UpperCase(DestTableName)) > 0 Then
        Begin
          {Paradox or DBase Tables}
          If S.IndexDefs.Items[i].Name = '' Then
          Begin
            If Pos('.DB',UpperCase(DestTableName)) = 0 Then
            Begin
              IndexName := DestTableName+IntToStr(i);
            End
            Else
            Begin
              IndexName := '';
            End;
          End
          Else
          Begin
            IndexName := DestTableName+IntToStr(i);
          End;
          IndexFields := S.IndexDefs.Items[i].Fields;
          D.AddIndex(IndexName,IndexFields,S.IndexDefs.Items[i].Options);
          D.IndexDefs.Update;
        End
        Else
        Begin
          {Non Local Tables}
          Q := TQuery.Create(nil);
          Try
            S.IndexDefs.Update;
            D.IndexDefs.Update;
            D.IndexDefs.Clear;
            D.IndexDefs.Update;
            IMax := S.IndexDefs.Count - 1;
            For j := 0 To IMax Do
            Begin
              Q. Active      := False;
              Q.DatabaseName := DestDatabaseName;
              IndexName      := DestTableName+IntToStr(i);
              IndexFields    := S.IndexDefs.Items[i].Fields;
              IndexFields2   :=
                ReplaceCharInString(IndexFields,';',',');
              Q.SQL.Clear;
              Q.SQL.Add('Create');
              If ixUnique in S.IndexDefs.Items[j].Options Then
              Begin
                Q.SQL.Add('Unique');
              End;
              If ixDescending in S.IndexDefs.Items[j].Options Then
              Begin
                Q.SQL.Add('Desc');
              End
              Else
              Begin
                Q.SQL.Add('Asc');
              End;
              Q.SQL.Add('Index');
              Q.SQL.Add(IndexName);
              Q.SQL.Add('On');
              Q.SQL.Add(DestTableName);
              Q.SQL.Add('(');
              Q.SQL.Add(IndexFields2);
              Q.SQL.Add(')');
              Try
                Q.ExecSql;
                D.IndexDefs.Update;
                D.AddIndex(IndexName,IndexFields,S.IndexDefs.Items[j].Options);
                D.IndexDefs.Update;
              Except
                On E : EDBEngineError Do
                Begin
                  If E.Message = 'Invalid array of index descriptors.' Then
                  Begin
                    Try
                      D.IndexDefs.Update;
                      D.DeleteIndex(IndexName);
                      D.IndexDefs.Update;
                    Except
                    End;
                  End
                  Else
                  Begin
                    Try
                      D.IndexDefs.Update;
                      IDXO := D.IndexDefs.Items[j].Options;
                    Except
                    End;
                    {Msg('DBCreateTableBorrowStr Error: '+E.Message);}
                  End;
                End;
              End;
            End;
            //i:= IMax;
          Finally
            Q.Free;
          End;
        End;
      End;
      S.Active       := False;
      Result := True;
    Finally
      S.Free;
      D.Free;
    End;
  Except
    On E : Exception Do
    Begin
      ShowMessage('DBCreateTableBorrowStr Error: '+E.Message);
      Result := False;
    End;
  End;
End;

{!~
This is a very powerful migration utility.
The function creates an empty table with indices by borrowing the
structure of a source table. Source and destination can be remote
or local tables.  If the destination table exists the function will not
throw an error, the existing table will be replaced with the new
table.

The following example creates an empty version of the DBDemos
"Customer.Db" table on a Sybase Client Server Database.

DBCreateTableBorrowStr(
  'DBDemos',
  'Customer.Db',
  'SybaseDb',
  'Customer');
}

{!~ Creates a new table from a Query.
 Complex joins can be output to a new table.}
Function DBCreateTableFromQuery(
            Query: TQuery;
            NewTableName,
            TableDatabaseName: String): Boolean;
var
  D         : TTable;
  ActiveWas : Boolean;
begin
  D := nil;
  try
    {The Source Table}
    ActiveWas      := Query.Active;
    Query.Active   := true;

    {Create The Destination Table}
    D              := TTable.Create(nil);
    D.Active       := False;
    D.DatabaseName := TableDatabaseName;
    D.TableName    := NewTableName;
    D.ReadOnly     := False;

    {Make the table copy}
    D.BatchMove(Query,batCopy);
    Query.Active := ActiveWas;
    Result := True;
  finally
    D.Free;
  end;
End;

{!~ Deletes A Table}
Function DBDeleteTable(const DatabaseName, TableName : string):Boolean;
Begin
  Try
    If Not IsTable(DatabaseName, TableName) Then
    Begin
      Result := False;
      Exit;
    End;
    Result := DBDropTable(DatabaseName, TableName);
  Except
    Result := False;
  End;
End;

{!~ Drops A Table}
Function DBDropTable(const DatabaseName, TableName : string):Boolean;
var Query : TQuery;
begin
  Result := False;
  If Not IsTable(DatabaseName, TableName) Then
  Begin
    Exit;
  End;
  Query := TQuery.Create(nil);
  try
    Query.DatabaseName := DatabaseName;
    Query.SQL.Clear;
    Query.SQL.Add('Drop Table ');
    If (Pos('.DB', UpperCase(TableName)) > 0) Or
       (Pos('.DBF',UpperCase(TableName)) > 0) Then
    Begin
      Query.Sql.Add('"'+TableName+'"');
    End
    Else
    Begin
      Query.Sql.Add(TableName);
    End;
    Result := True;
    Try
      Query.ExecSQL;
    Except
      Result := False;
    End;
  finally
    Query.Free;
  end;
end;

{!~ Empties a table of all records}
Function DBEmptyTable(
           const DatabaseName,
           TableName : string): Boolean;
var Query : TQuery;
begin
  Query := TQuery.Create(nil);
  try
    Query.DatabaseName := DatabaseName;
    Query.SQL.Clear;
    Query.SQL.Add('DELETE FROM '+TableName);
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

{!~ Returns the field Name as a String.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason '' is returned.}
Function DBFieldNameByNo(
  DatabaseName  : String;
  TableName     : String;
  FieldNo       : Integer): String;
Var
  Table      : TTable;
Begin
  Result := '';
  If Not IsTable(DatabaseName, TableName) Then Exit;
  If FieldNo < 0 Then Exit;
  If FieldNo >= DBNFields(DatabaseName, TableName) Then Exit;
  Table := TTable.Create(nil);
  Try
    Try
      Table.Active       := False;
      Table.DatabaseName := DatabaseName;
      Table.TableName    := TableName;
      Table.Active       := True;
      Result := Table.FieldDefs[FieldNo].Name;
    Except
    End;
  Finally
    Table.Free;
  End;
End;
{!~
Returns the field Name as a String.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason '' is returned.

The field number is zero based so the first column would
be 0, the 2nd column 1 etc.

This example returns "Company" as the name of the 2nd
column in the table. "1" is entered as the column
number because it is zero based.

  FieldName :=
    DBFieldNameByNo(
      'DBDemos',
      'Customer.Db',
      1);
}

{!~ Returns Field Names shared by 2 tables as a string.
Fields are separated by commas with no trailing comma.}
Function DBFieldNamesCommonToString(
  DatabaseName1 : String;
  TableName1    : String;
  DatabaseName2 : String;
  TableName2    : String): String;
Var
  List1 : TStringList;
  List2 : TStringList;
  i     : Integer;
  Suffix: String;
Begin
  Result := '';
  List1  := TStringList.Create();
  List2  := TStringList.Create();
  Try
    DBFieldNamesToTStrings(
      DatabaseName1,
      TableName1,
      List1);
    For i := 0 To List1.Count - 1 Do
    Begin
      List1[i] := UpperCase(List1[i]);
    End;
    DBFieldNamesToTStrings(
      DatabaseName2,
      TableName2,
      List2);
    For i := 0 To List2.Count - 1 Do
    Begin
      List2[i] := UpperCase(List2[i]);
    End;
    For i := 0 To List1.Count - 1 Do
    Begin
      If Result = '' Then
      Begin
        Suffix := '';
      End
      Else
      Begin
        Suffix := ', ';
      End;
      If List2.IndexOf(List1[i]) <> -1 Then
      Begin
        Result := Result + Suffix + List1[i];
      End;
    End;
  Finally
    List1.Free;
    List2.Free;
  End;
End;

{!~ Copies Field Names shared by 2 tables to a TStrings object.
Returns true if successful.  If there
is an error, the DatabaseName doesn't exist, the table doesn't
exist or some other reason False is returned.  }
Function DBFieldNamesCommonToTStrings(
  DatabaseName1 : String;
  TableName1    : String;
  DatabaseName2 : String;
  TableName2    : String;
  Strings       : TStrings): Boolean;
Var
  List1 : TStringList;
  List2 : TStringList;
  i     : Integer;
Begin
{  Result := False;}{zzz}
  List1  := TStringList.Create();
  List2  := TStringList.Create();
  Try
    Strings.Clear;
    DBFieldNamesToTStrings(
      DatabaseName1,
      TableName1,
      List1);
    For i := 0 To List1.Count - 1 Do
    Begin
      List1[i] := UpperCase(List1[i]);
    End;
    DBFieldNamesToTStrings(
      DatabaseName2,
      TableName2,
      List2);
    For i := 0 To List2.Count - 1 Do
    Begin
      List2[i] := UpperCase(List2[i]);
    End;
    For i := 0 To List1.Count - 1 Do
    Begin
      If List2.IndexOf(List1[i]) <> -1 Then
      Begin
        Strings.Add(List1[i]);
      End;
    End;
    Result := True;
  Finally
    List1.Free;
    List2.Free;
  End;
End;

{!~ Copies Table Field Names to a TStrings object, e.g.,

ListBox1.Items, Memo1.Lines.

Returns the true if successful.  If there
is an error, the DatabaseName doesn't exist, the table doesn't
exist or some other reason False is returned.  }
Function DBFieldNamesToTStrings(
  DatabaseName : String;
  TableName    : String;
  Strings      : TStrings): Boolean;
Var
  Table      : TTable;
  FieldNo    : Integer;
Begin
  Result := False;
  If Not IsTable(DatabaseName, TableName) Then Exit;
  Table := TTable.Create(nil);
  Try
    Try
      Table.Active       := False;
      Table.DatabaseName := DatabaseName;
      Table.TableName    := TableName;
      Table.Active       := True;
      Strings.Clear;
      For FieldNo := 0 To Table.FieldDefs.Count -1 Do
      Begin
        Strings.Add(Table.FieldDefs[FieldNo].Name);
      End;
      Result := True;
    Except
    End;
  Finally
    Table.Free;
  End;
End;
{!~ DBFieldNamesToTStrings copies Table Field Names to a TStrings object, e.g.,
ListBox1.Items, Memo1.Lines.

It returns true if successful, False otherwise.  If there
is an error, the DatabaseName doesn't exist, the table doesn't
exist or some other reason False is returned.

In this example the DBDemos "Customer.Db" table Field Names
populate a TStringList that is passed as a parameter to the
procedure.

Procedure TForm1.GetFieldNames(
  DatabaseName : String;
  TableName    : String;
  TSL          : TStrings);
Begin
  DBFieldNamesToTStrings(
    DatabaseName,
    TableName,
    TSL);
End;

Procedure TForm1.FormCreate(
Begin
  TSL := TStringList.Create();
  GetFieldNames(
    'DBDemos',
    'Customer.Db',
    TSL);
End;
}

{!~ Returns the field Number as an integer.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason -1 is returned.}
Function DBFieldNo(DatabaseName, TableName, FieldName: String): Integer;
Var
  Table      : TTable;
  FieldIndex : Integer;
  FieldNumber: Integer;
Begin
  Result := -1;
  If Not IsTable(DatabaseName, TableName) Then Exit;
  If Not IsField(DatabaseName, TableName, FieldName) Then Exit;
  Table := TTable.Create(nil);
  Try
    Try
      Table.Active       := False;
      Table.DatabaseName := DatabaseName;
      Table.TableName    := TableName;
      Table.Active       := True;
      FieldIndex         :=
        Table.FieldDefs.IndexOf(FieldName);
      FieldNumber        :=
        Table.FieldDefs[FieldIndex].FieldNo;
      Result := FieldNumber;
    Except
    End;
  Finally
    Table.Free;
  End;
End;

{!~ Returns the database field Size as an integer.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason 0 is returned.}
Function DBFieldSize(DatabaseName, TableName, FieldName: String): Integer;
Var
  Table      : TTable;
  FieldIndex : Integer;
  FieldSize  : Integer;
Begin
  Result := 0;
  If Not IsTable(DatabaseName, TableName) Then Exit;
  If Not IsField(DatabaseName, TableName, FieldName) Then Exit;
  Table := TTable.Create(nil);
  Try
    Try
      Table.Active       := False;
      Table.DatabaseName := DatabaseName;
      Table.TableName    := TableName;
      Table.Active       := True;
      FieldIndex         :=
        Table.FieldDefs.IndexOf(FieldName);
      FieldSize          :=
        Table.FieldDefs[FieldIndex].Size;
      Result := FieldSize;
    Except
    End;
  Finally
    Table.Free;
  End;
End;

{!~ Returns the database field type as a string.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason a null string is returned.}
Function DBFieldType(DatabaseName, TableName, FieldName: String): String;
Begin
  Result := TypeField(DatabaseName, TableName, FieldName);
End;

{!~ Returns the database field type as a string.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason a null string is returned.}
Function DBFieldTypeByNo(DatabaseName, TableName: String; FieldNo: Integer): String;
Var
  Table      : TTable;
  FieldIndex : Integer;
  FieldType  : TFieldType;
Begin
  Result := '';
  If Not IsTable(DatabaseName, TableName) Then Exit;
  Table := TTable.Create(nil);
  Try
    Try
      Table.Active       := False;
      Table.DatabaseName := DatabaseName;
      Table.TableName    := TableName;
      Table.Active       := True;
      FieldIndex         := FieldNo;
      Try
        FieldType          :=
          Table.FieldDefs[FieldIndex].DataType;
      Except
        FieldType        := ftUnknown;
      End;
      {TFieldType Possible values are
      ftUnknown, ftString, ftSmallint,
      ftInteger, ftWord, ftBoolean,
      ftFloat, ftCurrency, ftBCD, ftDate,
      ftTime, ftDateTime, ftBytes, ftVarBytes,
      ftBlob, ftMemo or ftGraphic}
      If FieldType=ftUnknown  Then Result := 'Unknown';
      If FieldType=ftString   Then Result := 'String';
      If FieldType=ftSmallInt Then Result := 'SmallInt';
      If FieldType=ftInteger  Then Result := 'Integer';
      If FieldType=ftWord     Then Result := 'Word';
      If FieldType=ftBoolean  Then Result := 'Boolean';
      If FieldType=ftFloat    Then Result := 'Float';
      If FieldType=ftCurrency Then Result := 'Currency';
      If FieldType=ftBCD      Then Result := 'BCD';
      If FieldType=ftDate     Then Result := 'Date';
      If FieldType=ftTime     Then Result := 'Time';
      If FieldType=ftDateTime Then Result := 'DateTime';
      If FieldType=ftBytes    Then Result := 'Bytes';
      If FieldType=ftVarBytes Then Result := 'VarBytes';
      If FieldType=ftBlob     Then Result := 'Blob';
      If FieldType=ftMemo     Then Result := 'Memo';
      If FieldType=ftGraphic  Then Result := 'Graphic';
    Except
    End;
  Finally
    Table.Free;
  End;
End;

{!~ Replace all the values in a field that match a
condition value with a new value}
procedure DBGlobalStringFieldChange(
  const DatabaseName,
  TableName,
  FieldName,
  NewValue : string);
begin
  DBGlobalStringFieldChangeWhere(
    DatabaseName,
    TableName,
    FieldName,
    '',
    NewValue);
End;

{!~ Replace all the values in a field with a new value}
procedure DBGlobalStringFieldChangeWhere(
  const DatabaseName,
  TableName,
  FieldName,
  CurrentValue,
  NewValue : string);
var
  Query : TQuery;
begin
  Query := TQuery.Create(nil);
  Try
    Query.Active       := False;
    Query.DatabaseName := DatabaseName;
    Query.RequestLive  := True;
    Query.RequestLive  := True;
    Query.Sql.Clear;
    Query.Sql.Add('UpDate');
    Query.Sql.Add('"'+TableName+'"');
    Query.Sql.Add('Set');
    Query.Sql.Add(
      '"'+TableName+'"."'+FieldName+'"'+
      ' = '+
      '"'+NewValue+'"');
    Query.Sql.Add('Where');
    Query.Sql.Add(
      '"'+TableName+'"."'+FieldName+'"'+
      ' <> '+
      '"'+NewValue+'"');
    If Not (CurrentValue = '') Then
    Begin
      Query.Sql.Add('And ');
      Query.Sql.Add(
        '"'+TableName+'"."'+FieldName+'"'+
        ' = '+
        '"'+CurrentValue+'"');
    End;
    Query.ExecSql;
    Query.Active := False;
  Finally
    Query.Free;
  End;
End;

{!~ Replace values in a field (NewValueField) with NewValue
based on a where condition in CurrentValueField with a value
of CurrentValue}
procedure DBGlobalStringFieldChangeWhere2(
  const DatabaseName,
  TableName,
  NewValueField,
  NewValue,
  CurrentValueField,
  CurrentValue: string);
var
  Query        : TQuery;
  CValueQuoted : String;
begin
  Query := TQuery.Create(nil);
  Try
    CValueQuoted := DBSqlValueQuoted(
                      DatabaseName,
                      TableName,
                      CurrentValueField,
                      CurrentValue);
    Query.Active       := False;
    Query.DatabaseName := DatabaseName;
    Query.RequestLive  := True;
    Query.RequestLive  := True;
    Query.Sql.Clear;
    Query.Sql.Add('UpDate');
    Query.Sql.Add('"'+TableName+'"');
    Query.Sql.Add('Set');
    Query.Sql.Add(
      '"'+TableName+'"."'+NewValueField+'"'+
      ' = '+
      '"'+NewValue+'"');

    If Not (CurrentValue = '') Then
    Begin
      Query.Sql.Add('Where');
      Query.Sql.Add(
        '"'+TableName+'"."'+CurrentValueField+'"'+
        ' = '+
        CValueQuoted);
    End;
    {Query.Sql.SaveToFile(ExtractFileNameNoExt(TableName)+'.sql');}
    Query.ExecSql;
    Query.Active := False;
  Finally
    Query.Free;
  End;
End;

{!~ Inserts matching fields in a destination table.
Source Table records are deleted if the record was inserted properly.
Records unsuccessfully inserted are retained and the problems recorded
in the ErrorField.}
Function DBInsertMatchingFields(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable,
           ErrorField: string): Boolean;
Var
  S              : TTable;
  T              : TTable;
  D              : TQuery;
  i,j,K          : Integer;
  Keys           : TStringList;
  KeyValues      : TStringList;
  CommonFields   : TStringList;
  {WhereAnd       : String;}{zzz}
  {CurField       : String;}{zzz}
 {CurValue_S     : String;}{zzz}
  {DFieldType     : String;}{zzz}
  EMessage       : String;
  ESuccess       : String;
Begin
  Result       := False;
  ESuccess     := 'Successful';
  S            := TTable.Create(nil);
  D            := TQuery.Create(nil);
  T            := TTable.Create(nil);
  Keys         := TStringList.Create();
  CommonFields := TStringList.Create();
  KeyValues    := TStringList.Create();
  Try
    Try
      D.Active       := False;
      D.DatabaseName := DestDatabaseName;

      DBKeyFieldNamesToTStrings(
        SourceDatabaseName,
        SourceTable,
        Keys);
      DBFieldNamesCommonToTStrings(
        SourceDatabaseName,
        SourceTable,
        DestDatabaseName,
        DestinationTable,
        CommonFields);

      S.Active := False;
      S.DatabaseName := SourceDatabaseName;
      S.TableName    := SourceTable;
      S.Active       := True;
      S.First;
      While Not S.EOF Do
      Begin
        Try

          {Capture the key field values}
          KeyValues.Clear;
          For j := 0 To Keys.Count - 1 Do
          Begin
            KeyValues.Add(S.FieldByName(Keys[j]).AsString);
          End;

          If IsRecord(
               DestDatabaseName,
               DestinationTable,
               Keys,
               KeyValues)
          Then
          Begin
            {The record already exists in the destination table}
            Try
              S.Edit;
              S.FieldByName(ErrorField).AsString :=
                'Error-Insert-Record already exists in destination table';
              S.Post;
            Except
            End;
            S.Next;
            Continue;
          End
          Else
          Begin
            {The record does not exist in the destination table}
            Try
              EMessage := ESuccess;
              S.Edit;
              S.FieldByName(ErrorField).AsString := EMessage;
              S.Post;
            Except
            End;
          End;
          Try
            T.Active       := False;
            T.DatabaseName := DestDatabaseName;
            T.TableName    := DestinationTable;
            T.Active       := True;
            T.Insert;
            For i := 0 To CommonFields.Count - 1 Do
            Begin
              T.FieldByName(CommonFields[i]).AsString :=
                S.FieldByName(CommonFields[i]).AsString;
            End;
            T.Post;
          Except
            If EMessage = ESuccess Then
            Begin
              EMessage := 'Error-Insert- Keys:';
              For K := 0 To Keys.Count -1 Do
              Begin
                EMessage := EMessage + Keys[K]+'='+S.FieldByName(Keys[K]).AsString+', ';
              End;
            End;
            Try
              S.Edit;
              S.FieldByName(ErrorField).AsString := EMessage;
              S.Post;
            Except
            End;
          End;
        Except
          If EMessage = ESuccess Then
          Begin
            EMessage := 'Error-Insert- Keys:';
            For K := 0 To Keys.Count -1 Do
            Begin
              EMessage := EMessage + Keys[K]+'='+S.FieldByName(Keys[K]).AsString+', ';
            End;
          End;
          Try
            S.Edit;
            S.FieldByName(ErrorField).AsString := EMessage;
            S.Post;
          Except
          End;
        End;
        S.Next;
      End;
      If Not IsField(SourceDatabaseName, SourceTable, ErrorField) Then
      Begin
        ShowMessage('Cannot delete records from '+
          SourceTable+' table because '+ErrorField+
          ' Field does not exist');
      End
      Else
      Begin
        D.Active       := False;
        D.RequestLive  := True;
        D.DatabaseName := SourceDatabaseName;
        D.Sql.Clear;
        D.Sql.Add('Delete From '+SourceTable);
        D.Sql.Add('Where');
        D.Sql.Add(ErrorField+' = "'+ESuccess+'"');
        D.ExecSql;
        D.Active := False;
      End;
      Result := True;
    Except
      If EMessage = ESuccess Then
      Begin
        EMessage := 'Error-Process Level- Keys:';
        For K := 0 To Keys.Count -1 Do
        Begin
          EMessage := EMessage + Keys[K]+'='+S.FieldByName(Keys[K]).AsString+', ';
        End;
      End
      Else
      Begin
        EMessage := EMessage + 'Process Error Also';
      End;
      Try
        S.Edit;
        S.FieldByName(ErrorField).AsString := EMessage;
        S.Post;
      Except
      End;
    End;
  Finally
    S.Free;
    D.Free;
    T.Free;
    Keys.Free;
    CommonFields.Free;
    KeyValues.Free;
  End;
End;

{!~ Copies Table Key Field Names to a TStrings object.
Returns the true if successful.  If there
is an error, the DatabaseName doesn't exist, the table doesn't
exist or some other reason False is returned.  }
Function DBKeyFieldNamesToTStrings(
  DatabaseName : String;
  TableName    : String;
  Strings      : TStrings): Boolean;
Var
  Table      : TTable;
  FieldNo    : Integer;
Begin
  Result := False;
  If Not IsTable(DatabaseName, TableName) Then Exit;
  Table := TTable.Create(nil);
  Try
    Try
      Table.Active       := False;
      Table.DatabaseName := DatabaseName;
      Table.TableName    := TableName;
      Table.Active       := True;
      Strings.Clear;
      For FieldNo := 0 To Table.FieldDefs.Count -1 Do
      Begin
        If IsFieldKeyed(
             DatabaseName,
             TableName,
             Table.FieldDefs[FieldNo].Name) Then
        Begin
          Strings.Add(Table.FieldDefs[FieldNo].Name);
        End;
      End;
      Result := True;
    Except
    End;
  Finally
    Table.Free;
  End;
End;

{!~ Presents a lookup Dialog to the user.  The selected
value is returned if the user presses OK and the Default
value is returned if the user presses Cancel unless the
TStringList is nil in which case a blank string is returned}
Function DBLookUpDialog(
  Const DataBaseName  : String;
  Const TableName     : String;
  Const FieldName     : String;
  Const SessionName   : String;
  Const DefaultValue  : String;
  const DialogCaption : string;
  const InputPrompt   : string;
  const DialogWidth   : Integer
  ): String;
Begin
  Result :=
    DialogDBLookUp(
      DataBaseName,
      TableName,
      FieldName,
      SessionName,
      DefaultValue,
      DialogCaption,
      InputPrompt,
      DialogWidth
      );
End;

{!~ Returns the median value for a column in a table
as type single}
Function DBMedianSingle(
      const DatabaseName,
      TableName,
      FieldName,
      WhereString
      : string): Single;
Var
  Query    : TQuery;
  NRecords : LongInt;
  NMedian  : LongInt;
  Value1   : Single;
  Value2   : Single;
Begin
  Query := TQuery.Create(nil);
  Try
    {Get the number of values}
    Query.Active := False;
    Query.DatabaseName := DatabaseName;
    Query.SQL.Clear;
    Query.SQL.Add('Select Count(*)');
    Query.SQL.Add('From');
    If (Pos('.DB', UpperCase(TableName)) > 0) Or
       (Pos('.DBF',UpperCase(TableName)) > 0) Then
    Begin
      Query.Sql.Add('"'+TableName+'"');
    End
    Else
    Begin
      Query.Sql.Add(TableName);
    End;
    Query.SQL.Add('Where');
    Query.SQL.Add(FieldName+' is not null');
    If Not (WhereString = '') Then
    Begin
      Query.SQL.Add('And');
      Query.SQL.Add(WhereString);
    End;
    Query.Active := True;
    NRecords := Query.Fields[0].AsInteger;
    NMedian  := NRecords div 2;

    {Get the median value}
    Query.Active := False;
    Query.DatabaseName := DatabaseName;
    Query.SQL.Clear;
    Query.SQL.Add('Select');
    Query.SQL.Add(FieldName);
    Query.SQL.Add('From');
    If (Pos('.DB', UpperCase(TableName)) > 0) Or
       (Pos('.DBF',UpperCase(TableName)) > 0) Then
    Begin
      Query.Sql.Add('"'+TableName+'"');
    End
    Else
    Begin
      Query.Sql.Add(TableName);
    End;
    Query.SQL.Add('Where');
    Query.SQL.Add(FieldName+' is not null');
    If Not (WhereString = '') Then
    Begin
      Query.SQL.Add('And');
      Query.SQL.Add(WhereString);
    End;
    Query.SQL.Add('Order By');
    Query.SQL.Add(FieldName);
    Query.Active := True;
    Query.First;

    If Odd(NRecords) Then
    Begin
      {Odd Number of records}
      Query.MoveBy(NMedian);
      Result := Query.FieldByName(FieldName).AsFloat;
    End
    Else
    Begin
      {Even Number of records}
      Query.MoveBy(NMedian-1);
      Value1 := Query.FieldByName(FieldName).AsFloat;
      Query.Next;
      Value2 := Query.FieldByName(FieldName).AsFloat;
      Result := (Value1+Value2)/2;
    End;
  Finally
    Query.Free;
  End;
End;

{!~ Moves SourceTable From SourceDatabaseName
 To DestDatabasename.  If a table exists
 with the same name at DestDatabaseName it
 is overwritten.}
Function DBMoveTable(
            SourceTable,
            SourceDatabaseName,
            DestDatabaseName: String): Boolean;
Begin
  Result := True;
  Try
    {First Copy The Source Table To The New Table}
    If Not DBCopyTable(
             SourceDatabaseName,
             SourceTable,
             DestDatabaseName,
             SourceTable) Then
    Begin
      Result := False;
      Exit;
    End;

    {Now Drop The Source Table}
    If Not DBDropTable(SourceDatabaseName, SourceTable) Then
    Begin
      Result := False;
      Exit;
    End;
  Except
    Result := False;
  End;
End;

{!~ Returns the number of fields in a table}
Function DBNFields(DatabaseName, TableName: String): Integer;
Begin
  Result := NFields(DatabaseName, TableName);
End;

{!~ Returns the next key value when the table keys are
numbers as strings, e.g., '   12' key would return
'   13'}
Function DBNextAlphaKey(DatabaseName, TableName, FieldName: String):String;
Var
  Query : TQuery;
  CurrentMax_S : String;
  CurrentLen_I : Integer;
  CurrentMax_I : LongInt;
  NewMax_S     : String;
  NewMax_I     : LongInt;
  Counter      : Integer;
Begin
  Result := '';
  Query := TQuery.Create(nil);
  Try
    Result       := '1';
    CurrentMax_S := '';
    CurrentMax_I := 0;
    CurrentLen_I := 0;
    NewMax_S     := '1';
    Query.DatabaseName := DatabaseName;
    Query.SQL.Clear;
    Query.SQL.Add('Select ');
    Query.SQL.Add('Max('+FieldName+')');
    Query.SQL.Add('From '+TableName);
    Query.Open;
    Try
      CurrentMax_S := Query.Fields[0].AsString;
    Except
    End;
    Try
      CurrentLen_I := Length(CurrentMax_S);
    Except
    End;
    Try
      CurrentMax_I := StrToInt(CurrentMax_S);
    Except
    End;
    NewMax_I := CurrentMax_I + 1;
    NewMax_S := IntToStr(NewMax_I);
    For Counter := 1 To CurrentLen_I Do
    Begin
      If Length(NewMax_S) >= CurrentLen_I Then Break;
      NewMax_S := ' '+NewMax_S;
    End;
    Result := NewMax_S;
  Finally
    Query.Free;
  End;
End;

{!~ Returns the next key value when the table keys are
integers, e.g., 12 key would return 13}
Function DBNextInteger(
  DatabaseName,
  TableName,
  FieldName: String):LongInt;
Var
  Query : TQuery;
  CurrentMax   : LongInt;
  NewMax       : LongInt;
Begin
  CurrentMax   := 0;
  Query := TQuery.Create(nil);
  Try
    Query.DatabaseName := DatabaseName;
    Query.SQL.Clear;
    Query.SQL.Add('Select ');
    Query.SQL.Add('Max('+FieldName+')');
    Query.SQL.Add('From ');
    If (Pos('.DB', UpperCase(TableName)) > 0) Or
       (Pos('.DBF',UpperCase(TableName)) > 0) Then
    Begin
      Query.Sql.Add('"'+TableName+'"');
    End
    Else
    Begin
      Query.Sql.Add(TableName);
    End;
    Query.Open;
    Try
      CurrentMax := Query.Fields[0].AsInteger;
    Except
    End;
    NewMax   := CurrentMax + 1;
    Result := NewMax;
  Finally
    Query.Free;
  End;
End;

{!~ ReKeys a Paradox Table to the first N fields}
Function DBParadoxCreateNKeys(
  DatabaseName : String;
  TableName    : String;
  NKeys        : Integer): Boolean;
Var
  T          : TTable;
  T2         : TTable;
  i          : Integer;
  TempDBName : String;
  TempTblNam : String;
  TempTblStub: String;
  KeysString : String;
Begin
  Result := False;
  {Select a temporary table name}
  TempTblStub := 'qrz';
  TempDBName  := DatabaseName;
  TempTblNam  := '';
  For i := 1 To 100 Do
  Begin
    TempTblNam := TempTblStub+StringPad(IntToStr(i),'0',3,False)+'.Db';
    If Not IsTable(TempDBName,TempTblNam) Then
    Begin
      Break;
    End
    Else
    Begin
      If i = 100 Then
      Begin
        DBDeleteTable(
          TempDBName,
          TempTblNam);
      End;
    End;
  End;
  T  := TTable.Create(nil);
  T2 := TTable.Create(nil);
  Try
    Try
      T.Active       := False;
      T.DatabaseName := DatabaseName;
      T.TableName    := TableName;
      T.Active       := True;

      T2.Active       := False;
      T2.DatabaseName := TempDBName;
      T2.TableName    := TempTblNam;
      T2.FieldDefs.Assign(T.FieldDefs);
      T2.IndexDefs.Clear;
      KeysString := '';

      For i := 0 To NKeys - 1 Do
      Begin
        If i > 0 Then
        Begin
          KeysString := KeysString + ';';
        End;
        KeysString :=
          KeysString +
          DBFieldNameByNo(
            DatabaseName,
            TableName,
            i);
      End;
      T2.IndexDefs.Add('',KeysString,[ixPrimary]);
      T2.CreateTable;
      T2.Active := False;
      T.Active        := False;
      AddTables(
        DatabaseName,
        TableName,
        TempDBName,
        TempTblNam);
      DBDeleteTable(DatabaseName,TableName);
      T2.Active      := True;
      T.DatabaseName := DatabaseName;
      T.TableName    := TableName;
      T.FieldDefs.Assign(T2.FieldDefs);
      T.IndexDefs.Clear;
      T.IndexDefs.Add('',KeysString,[ixPrimary]);
      T.CreateTable;
      T2.Active      := False;
      T.Active       := False;
      AddTables(
        TempDBName,
        TempTblNam,
        DatabaseName,
        TableName);
      DBDeleteTable(
        TempDBName,
        TempTblNam);
      Result := True;
    Except
      ShowMessage('Error in Function DBParadoxCreateNKeys');
    End;
  Finally
    T.Free;
    T2.Free;
  End;
End;

{!~ ReNames a table}
Function DBReNameTable(
  DatabaseName,
  TableNameOld,
  TableNameNew: String): Boolean;
Begin
  Result := True;
  Try
    If Not IsTable(DatabaseName, TableNameOld) Then
    Begin
      Result := False;
      Exit;
    End;

    {First Copy The Source Table To The New Table}
    If Not DBCopyTable(
             DatabaseName,
             TableNameOld,
             DatabaseName,
             TableNameNew) Then
    Begin
      Result := False;
      Exit;
    End;

    {Now Drop The Source Table}
    If Not DBDropTable(DatabaseName, TableNameOld) Then
    Begin
      Result := False;
      Exit;
    End;
  Except
    Result := False;
  End;
End;

{!~ Applies BatchMode Types As Appropriate To
Source and Destination Tables}
Function DBRecordMove(
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestTable: String;
           BMode: TBatchMode): Boolean;
var S : TTable;
    D : TTable;
    B : TBatchMove;
begin
  S := TTable.Create(nil);
  D := TTable.Create(nil);
  B := TBatchMove.Create(nil);
  try
    {Create The Source Table}
    S.Active       := False;
    S.DatabaseName := SourceDatabaseName;
    S.ReadOnly     := False;
    S.TableName    := SourceTable;
    S.Active := true;

    {Create The Destination Table}
    D.Active       := False;
    D.DatabaseName := DestDatabaseName;
    D.TableName    := DestTable;
    D.ReadOnly     := False;

    {Make the table copy}
    B.AbortOnKeyViol := False;
    B.AbortOnProblem := False;
    B.Destination    := D;
    B.Source         := S;
    B.Mode           := BMode;
    Try
      B.Execute;
    Except
    End;

    Result := True;
  finally
    S.Free;
    D.Free;
    B.Free;
  end;
End;

{!~ Returns True If The Tables Have Identical Structures, False Otherwise.
If 1 Local Table is involved then Indices are ignored!!!!!!}
Function DBSchemaSame(const
           DatabaseName1,
           Table1,
           DatabaseName2,
           Table2: string): Boolean;
Begin
  Result := IsStructureSame(DatabaseName1,Table1,DatabaseName2,Table2);
End;

{!~ Creates a new TSession object.}
{$IFDEF WIN32}
Function DBSessionCreateNew: TSession;
{$ENDIF WIN32}
{$IFDEF WIN32}
Var
  List : TStringList;
  Seed : String;
  i    : Integer;
  Ses  : String;
Begin
  Seed := 'Session';
  Ses  := Seed+'0';
  List := TStringList.Create;
  Try
    Sessions.GetSessionNames(List);
    For i := 0 To 1000 Do
    Begin
      Ses := Seed + IntToStr(i);
      If List.IndexOf(Ses) = -1 Then Break;
    End;
    Result := Sessions.OpenSession(Ses);
  Finally
    List.Free;
  End;
End;
{$ENDIF}

{!~ Returns a value for use in a sql where clause with the
appropriate Quoting of the value based on its datatype.  If
an error occurs the original string value is returned unchanged}
Function DBSqlValueQuoted(
  const
  DatabaseName,
  TableName,
  FieldName,
  FieldValue: string): String;
Var
  DataType : String;
Begin
  Result := FieldValue;
  Try
    DataType := DBFieldType(DatabaseName, TableName, FieldName);
    If
      (DataType = 'String')
      Or
      (DataType = 'DateTime')
      Or
      (DataType = 'Date')
      Or
      (DataType = 'Time')
    Then
    Begin
      If DataType <> 'String' Then
      Begin
        If FieldValue = '' Then
        Begin
          Result := ' null ';
        End
        Else
        Begin
          Result := '"'+FieldValue+'"';
        End;
      End
      Else
      Begin
        Result := '"'+FieldValue+'"';
      End;
    End
    Else
    Begin
      Result := FieldValue;
    End;
  Except
  End;
End;

{!~ Subtracts the records in the source
 table from the destination table}
Function DBSubtractTable(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable: string): Boolean;
Begin
  Result := SubtractTable(SourceDatabaseName,SourceTable,
                      DestDatabaseName,DestinationTable);
End;

{!~ Trims blank spaces from the Left of the string}
Function DBTrimBlanksLeft(
  DatabaseName : String;
  TableName    : String;
  FieldName    : String): Boolean;
Var
  Q : TQuery;
  S : String;
Begin
{  Result := False;}{zzz}
  Q := TQuery.Create(nil);
  Try
    Q.Active       := False;
    Q.DatabaseName := DatabaseName;
    Q.RequestLive  := True;
    Q.Sql.Clear;
    Q.Sql.Add('Select');
    Q.Sql.Add('*');
    Q.Sql.Add('From');
    Q.Sql.Add('"'+TableName+'"');
    Q.Active := True;
    Q.First;
    While Not Q.EOF Do
    Begin
      S := Q.FieldByName(FieldName).AsString;
      S := Trim(S);
      S := Trim(S);
      Q.Edit;
      Q.FieldByName(FieldName).AsString := S;
      Q.Post;
      Q.Next;
    End;
    Result := True;
  Finally
    Q.Free;
  End;
End;

{!~ Trims blank spaces from the right of the string}
Function DBTrimBlanksRight(
  DatabaseName : String;
  TableName    : String;
  FieldName    : String): Boolean;
Var
  Q : TQuery;
  S : String;
Begin
{  Result := False;}{zzz}
  Q := TQuery.Create(nil);
  Try
    Q.Active       := False;
    Q.DatabaseName := DatabaseName;
    Q.RequestLive  := True;
    Q.Sql.Clear;
    Q.Sql.Add('Select');
    Q.Sql.Add('*');
    Q.Sql.Add('From');
    Q.Sql.Add('"'+TableName+'"');
    Q.Active := True;
    Q.First;
    While Not Q.EOF Do
    Begin
      S := Q.FieldByName(FieldName).AsString;
      S := Trim(S);
      S := Trim(S);
      Q.Edit;
      Q.FieldByName(FieldName).AsString := S;
      Q.Post;
      Q.Next;
    End;
    Result := True;
  Finally
    Q.Free;
  End;
End;

{!~ Updates matching fields in a destination table.
Source Table records are deleted if the record was updated properly.
Records unsuccessfully updated are retained and the problems recorded
in the ErrorField.}
Function DBUpdateMatchingFields(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable,
           ErrorField: string;
           MsgPanel: TPanel;
           FilePath: String): Boolean;
Var
  S              : TTable;
  D              : TQuery;
  U              : TQuery;
  i,j,K,m        : Integer;

  Keys           : TStringList;
  KeysType       : TStringList;
  KeysQuotes     : TStringList;
  KeysSpaces     : TStringList;
  KeysWhere1     : TStringList;
  KeysUpdate1    : TStringList;
  KeysWhere2     : TStringList;
  KeyWhere1      : String;
  KeyWhere2      : String;
  KeyUpdate1     : String;
  NonKeys        : TStringList;
  NonKeysType    : TStringList;
  NonKeysQuotes  : TStringList;
  NonKeysSpaces  : TStringList;
  NonKeysStr     : TStringList;

  NonKeysString  : String;

  CommonFields   : TStringList;

  UpdateString   : String;
  WhereAnd       : String;
  CurField       : String;
  CurValue_S     : String;
  CurString      : String;
  CurStrings     : String;
  DFieldType     : String;
  EMessage       : String;
  ESuccess       : String;
  DFromString    : String;
  TimeLog        : TStringList;
  SetString      : String;
Begin
  ESuccess     := 'Successful';
  S            := TTable.Create(nil);
  D            := TQuery.Create(nil);
  U            := TQuery.Create(nil);
  Keys         := TStringList.Create();
  KeysSpaces   := TStringList.Create();
  KeysType     := TStringList.Create();
  KeysQuotes   := TStringList.Create();
  TimeLog      := TStringList.Create();
  CommonFields := TStringList.Create();
  NonKeys      := TStringList.Create();
  NonKeysQuotes:= TStringList.Create();
  NonKeysType  := TStringList.Create();
  NonKeysSpaces:= TStringList.Create();
  NonKeysStr   := TStringList.Create();
  KeysWhere1   := TStringList.Create();
  KeysUpdate1  := TStringList.Create();
  KeysWhere2   := TStringList.Create();
  NonKeysString:= '';
  SetString    := 'Set ';
  TimeLog.Clear;
  Try
    Try
      DBFieldNamesCommonToTStrings(
        SourceDatabaseName,
        SourceTable,
        DestDatabaseName,
        DestinationTable,
        CommonFields);
      For i := 0 To CommonFields.Count - 1 Do
      Begin
        CommonFields[i] := UpperCase(CommonFields[i]);
      End;
      D.Active       := False;
      D.DatabaseName := DestDatabaseName;
      U.Active       := False;
      U.DatabaseName := DestDatabaseName;
      UpdateString   := 'Update ';
      If Pos('.DB',UpperCase(DestinationTable)) > 0 Then
      Begin
        UpdateString := UpDateString + '"'+DestinationTable+'"';
      End
      Else
      Begin
        UpdateString := UpDateString + DestinationTable + '';
      End;
      DBKeyFieldNamesToTStrings(SourceDatabaseName,SourceTable,Keys);
      KeysSpaces.Clear;
      KeysType.Clear;
      KeysQuotes.Clear;

      For i := 0 To Keys.Count - 1 Do
      Begin
        Keys[i] := UpperCase(Keys[i]);
        If Pos(' ',Keys[i]) > 0 Then
        Begin
          KeysSpaces.Add('YES');
        End
        Else
        Begin
          KeysSpaces.Add('NO');
        End;
        DFieldType :=
          DBFieldType(
            SourceDatabaseName,
            SourceTable,
            Keys[i]);
        KeysType.Add(DFieldType);
        If
          (DFieldType = 'String')
          Or
          (DFieldType = 'DateTime')
          Or
          (DFieldType = 'Date')
          Or
          (DFieldType = 'Time')
        Then
        Begin
          KeysQuotes.Add('YES');
        End
        Else
        Begin
          KeysQuotes.Add('NO');
        End;
      End;
      NonKeys.Clear;
      NonKeysQuotes.Clear;
      NonKeysType.Clear;
      NonKeysSpaces.Clear;
      For i := 0 To CommonFields.Count - 1 Do
      Begin
        If Keys.IndexOf(CommonFields[i]) = -1 Then
        Begin
          NonKeys.Add(CommonFields[i]);
          DFieldType :=
            DBFieldType(
              SourceDatabaseName,
              SourceTable,
              CommonFields[i]);
          NonKeysType.Add(DFieldType);
          If
            (DFieldType = 'String')
            Or
            (DFieldType = 'DateTime')
            Or
            (DFieldType = 'Date')
            Or
            (DFieldType = 'Time')
          Then
          Begin
            NonKeysQuotes.Add('YES');
          End
          Else
          Begin
            NonKeysQuotes.Add('NO');
          End;
          If Pos(' ',CommonFields[i]) > 0 Then
          Begin
            NonKeysSpaces.Add('YES');
            NonKeysStr.Add('"'+CommonFields[i]+'"');
          End
          Else
          Begin
            NonKeysSpaces.Add('NO');
            NonKeysStr.Add(CommonFields[i]);
          End;
        End;
      End;
      S.Active := False;
      S.DatabaseName := SourceDatabaseName;
      S.TableName    := SourceTable;
      S.Active       := True;
      S.First;
      m := 0;

      NonKeysString := '';
      For i := 0 To NonKeysStr.Count - 1 Do
      Begin
        If i = (NonKeysStr.Count - 1) Then
        Begin
          NonKeysString := NonKeysString + 'a.'+NonKeysStr[i]+'' + ' ';
        End
        Else
        Begin
          NonKeysString := NonKeysString + 'a.'+NonKeysStr[i]+',' + ' ';
        End;
      End;
      DFromString := 'From ';
      If Pos('.DB',UpperCase(DestinationTable)) > 0 Then
      Begin
        DFromString := DFromString + '"'+DestinationTable+'" a';
      End
      Else
      Begin
        DFromString := DFromString + DestinationTable + ' a';
      End;
      WhereAnd := '';
      KeysWhere1.Clear;
      KeysWhere2.Clear;
      KeysUpdate1.Clear;
      For j := 0 To Keys.Count -1 Do
      Begin
        KeyWhere1 := '';
        KeyWhere2 := '';
        KeyUpdate1:= '';
        If WhereAnd <> '' Then KeyWhere1 := KeyWhere1 + WhereAnd;
        KeyWhere1 := KeyWhere1  + '(';
        KeyUpdate1:= KeyUpdate1 + '(';
        If KeysSpaces[j] = 'YES' Then
        Begin
          KeyWhere1  := KeyWhere1  + 'a."'+Keys[j]+'" = ';
          KeyUpdate1 := KeyUpdate1 +   '"'+Keys[j]+'" = ';
        End
        Else
        Begin
          KeyWhere1  := KeyWhere1  + 'a.'+Keys[j]+' = ';
          KeyUpdate1 := KeyUpdate1 +      Keys[j]+' = ';
        End;
        If KeysQuotes[j] = 'YES' Then
        Begin
          If KeysType[j] <> 'String' Then
          Begin
            {Do not add quotes here, wait till later}
          End
          Else
          Begin
            KeyWhere1 := KeyWhere1 +'"';
            KeyWhere2 := KeyWhere2 +'"';
            KeyUpdate1:= KeyUpdate1+'"';
          End;
        End
        Else
        Begin
          KeyWhere1 := KeyWhere1 +'';
          KeyWhere2 := KeyWhere2 +'';
          KeyUpdate1:= KeyUpdate1+'';
        End;
        KeyWhere2 := KeyWhere2 +')';
        KeysWhere1.Add(KeyWhere1);
        KeysWhere2.Add(KeyWhere2);
        KeysUpdate1.Add(KeyUpdate1);
        WhereAnd := 'And ';
      End;

      U.Sql.Clear;
      U.Sql.Add(UpdateString);
      U.Sql.Add('Temporary SetString');
      U.Sql.Add(DFromString);
      U.Sql.Add('Where');
      U.Sql.Add('Temporary Where String');

      While Not S.EOF Do
      Begin
        Try
          Inc(m);
          MsgPanel.Caption :=
            'Record '+
            StringPad(
              IntToStr(m),
              ' ',
              6,
              False);
          MsgPanel.Refresh;
          Try
            D.Active       := False;
            D.DatabaseName := DestDatabaseName;
            D.RequestLive  := False;
            D.Sql.Clear;
            D.Sql.Add('Select');
            D.Sql.Add(NonKeysString);
            D.Sql.Add(DFromString);
            D.Sql.Add('Where');

            For j := 0 To Keys.Count -1 Do
            Begin
              CurValue_S := S.FieldByName(Keys[j]).AsString;
              If (KeysQuotes[j] = 'YES') And (KeysType[j] <> 'String') Then
              Begin
                If CurValue_S = '' Then
                Begin
                  D.Sql.Add(
                    KeysWhere1[j]  +
                    ' null '       +
                    KeysWhere2[j]);
                End
                Else
                Begin
                  D.Sql.Add(
                    KeysWhere1[j]                   +
                    '"'                             +
                    CurValue_S                      +
                    '"'                             +
                    KeysWhere2[j]);
                End;
              End
              Else
              Begin
                D.Sql.Add(
                  KeysWhere1[j]                   +
                  CurValue_S                      +
                  KeysWhere2[j]);
              End;
            End;
            D.Active       := True;
            If Not (D.EOF And D.BOF) Then
            Begin
              EMessage := ESuccess;
              S.Edit;
              S.FieldByName(ErrorField).AsString := EMessage;
              S.Post;
            End
            Else
            Begin
              S.Edit;
              S.FieldByName(ErrorField).AsString := 'No Matching Record';
              S.Post;
              S.Next;
              Continue;
            End;
          Except
          End;
          U.Sql.Clear;
          U.Sql.Add(UpdateString);
          U.Sql.Add('Set');
          For i := 0 To NonKeys.Count - 1 Do
          Begin
            CurField        := NonKeys[i];
            Try
              With U Do
              Begin
                Active := False;
                SetString := CurField+' = ';
                CurValue_S := '';
                If NonKeysType[i] = 'Float' Then
                Begin
                  CurValue_S :=
                    FormatFloat(
                      '#0.0000000000',
                      S.FieldByName(CurField).AsFloat);
                End
                Else
                Begin
                  CurValue_S := S.FieldByName(CurField).AsString;
                End;
                If NonKeysQuotes[i] = 'YES' Then
                Begin
                  If NonKeysType[i] <> 'String' Then Begin
                    If CurValue_S = '' Then Begin
                      SetString := SetString + ' null ';
                    End Else Begin
                      SetString := SetString + '"'+CurValue_S+'"';
                    End;
                  End Else Begin
                    SetString := SetString + '"'+CurValue_S+'"';
                  End;
                End Else Begin
                  SetString := SetString + CurValue_S;
                End;
                SetString := SetString;
                If i <> (NonKeys.Count - 1) Then
                  SetString := SetString+',';
                Sql.Add(SetString);
              End;
            Except
              On E : Exception Do
              Begin
                If EMessage = ESuccess Then
                Begin
                  EMessage := 'Error-Field Level- Keys:';
                  For K := 0 To Keys.Count -1 Do
                  Begin
                    EMessage := EMessage + Keys[K]+'='+S.FieldByName(Keys[K]).AsString+', ';
                  End;
                  EMessage := EMessage + 'FIELDS: ';
                End;
                EMessage := {EMessage +} CurField+', ';
                EMessage := EMessage + E.Message;
                Try
                  S.Edit;
                  S.FieldByName(ErrorField).AsString := EMessage;
                  S.Post;
                Except
                End;
              End;
            End;
          End;

          CurStrings := '';
          WhereAnd := '';
          For j := 0 To Keys.Count -1 Do
          Begin
            CurStrings := CurStrings + WhereAnd;
            CurValue_S := S.FieldByName(Keys[j]).AsString;
            If (KeysQuotes[j] = 'YES') And (KeysType[j] <> 'String') Then
            Begin
              If CurValue_S = '' Then Begin
                CurString := KeysUpdate1[j]+' null '+KeysWhere2[j];
              End Else Begin
                CurString :=KeysUpdate1[j]+'"'+CurValue_S+'"'+KeysWhere2[j];
              End;
            End Else Begin
              CurString := KeysUpdate1[j]+CurValue_S+KeysWhere2[j];
            End;
            CurStrings := CurStrings + CurString + ' ';
            WhereAnd := ' And ';
          End;
          U.Sql.Add('Where');
          U.Sql.Add(CurStrings);
          U.ExecSql;
          U.Active := False;
        Except
          On E : Exception Do
          Begin
            Try
              S.Edit;
              S.FieldByName(ErrorField).AsString := E.Message;
              S.Post;
            Except
            End;
          End;
        End;
        S.Next;
      End;
      Try
        D.Active       := False;
        D.RequestLive  := True;
        D.DatabaseName := SourceDatabaseName;
        D.Sql.Clear;
        D.Sql.Add('Delete From '+SourceTable);
        D.Sql.Add('Where');
        D.Sql.Add(ErrorField+' = "'+ESuccess+'"');
        D.SQL.SaveToFile(FilePath+'Delete.Sql');
        D.ExecSql;
        D.Active := False;
      Except
        If Not IsField(SourceDatabaseName, SourceTable, ErrorField) Then
        Begin
          ShowMessage('Cannot delete records from '+
            SourceTable+' table because '+ErrorField+
            ' Field does not exist');
        End
        Else
        Begin
          ShowMessage('Error deleting source table records!');
        End;
      End;
    Except
      If EMessage = ESuccess Then
      Begin
        EMessage := 'Error-Process Level- Keys:';
        For K := 0 To Keys.Count -1 Do
        Begin
          EMessage := EMessage + Keys[K]+'='+S.FieldByName(Keys[K]).AsString+', ';
        End;
      End
      Else
      Begin
        EMessage := EMessage + 'Process Error Also';
      End;
      Try
        S.Edit;
        S.FieldByName(ErrorField).AsString := EMessage;
        S.Post;
      Except
      End;
    End;
  Finally
    S.Free;
    D.SQL.SaveToFile(FilePath+'Select.Sql');
    D.Free;
    U.SQL.SaveToFile(FilePath+'Update.Sql');
    U.Free;
    Keys.SaveToFile(FilePath+'Keys.Txt');
    Keys.Free;
    TimeLog.Free;
    CommonFields.SaveToFile(FilePath+'CommonFields.Txt');
    CommonFields.Free;
    NonKeys.SaveToFile(FilePath+'NonKeys.Txt');
    NonKeys.Free;
    NonKeysQuotes.SaveToFile(FilePath+'NonKeysQuotes.Txt');
    NonKeysQuotes.Free;
    NonKeysType.SaveToFile(FilePath+'NonKeysType.Txt');
    NonKeysType.Free;
    KeysSpaces.SaveToFile(FilePath+'KeysSpaces.Txt');
    KeysSpaces.Free;
    KeysType.SaveToFile(FilePath+'KeysType.Txt');
    KeysType.Free;
    KeysQuotes.SaveToFile(FilePath+'KeysQuotes.Txt');
    KeysQuotes.Free;
    NonKeysSpaces.SaveToFile(FilePath+'NonKeysSpaces.Txt');
    NonKeysSpaces.Free;
    NonKeysStr.SaveToFile(FilePath+'NonKeysStr.Txt');
    NonKeysStr.Free;
    KeysWhere1.SaveToFile(FilePath+'KeysWhere1.Txt');
    KeysWhere1.Free;
    KeysWhere2.SaveToFile(FilePath+'KeysWhere2.Txt');
    KeysWhere2.Free;
    KeysUpdate1.SaveToFile(FilePath+'KeysUpdate1.Txt');
    KeysUpdate1.Free;
  End;
End;

{!~ Deletes A Table}
Function DeleteTable(const DatabaseName, TableName : string):Boolean;
Begin
  Result := DBDropTable(DatabaseName, TableName);
End;

{!~ Presents a lookup Dialog to the user.  The selected
value is returned if the user presses OK and the Default
value is returned if the user presses Cancel unless the
TStringList is nil in which case a blank string is returned}
Function DialogDBLookUp(
  Const DataBaseName  : String;
  Const TableName     : String;
  Const FieldName     : String;
  Const SessionName   : String;
  Const DefaultValue  : String;
  const DialogCaption : string;
  const InputPrompt   : string;
  const DialogWidth   : Integer
  ): String;
Var
  Q      : TQuery;
  Values : TStringlist;
Begin
  Result := '';
  Q      := TQuery.Create(nil);
  Values := TStringlist.Create();
  Try
    Values.Clear;
    Values.Sorted     := True;
    Values.Duplicates := dupIgnore;
    Q.Active := False;
    Q.DatabaseName    := DatabaseName;
{$IFDEF WIN32}
    Q.SessionName     := SessionName;
{$ENDIF}
    Q.Sql.Clear;
    Q.Sql.Add('Select');
    Q.Sql.Add('Distinct');
    If Pos(' ',FieldName) > 0 Then
    Begin
      Q.Sql.Add('a."'+FieldName+'"');
    End
    Else
    Begin
      Q.Sql.Add('a.'+FieldName);
    End;
    Q.Sql.Add('From');
    If Pos('.DB',UpperCase(TableName)) > 0 Then
    Begin
      Q.Sql.Add('"'+TableName+'" a');
    End
    Else
    Begin
      Q.Sql.Add(TableName+' a');
    End;
    Q.Sql.Add('Order By');
    If Pos(' ',FieldName) > 0 Then
    Begin
      Q.Sql.Add('a."'+FieldName+'"');
    End
    Else
    Begin
      Q.Sql.Add('a.'+FieldName);
    End;
    Q.Active := True;
    If Not (Q.EOF And Q.BOF) Then
    Begin
      Q.First;
      While Not Q.EOF Do
      Begin
        Values.Add(Q.FieldByName(FieldName).AsString);
        Q.Next;
      End;
      Result :=
        DialogLookupDetail(
          DialogCaption,
          InputPrompt,
          DefaultValue,
          Values,        //TStringList
          5,             //Spacer Height
          5,             //Button Spacing
          2,             //BevelWidth
          25,            //PromptHeight
          300,           //FormHeight
          DialogWidth,   //FormWidth
          'Close dialog and return selected value.', //Hint_Cancel
          'Close dialog and make no changes.', //Hint_OK
          'Click an item to select it.',  //Hint_ListBox
          True, //ListSorted
          False //AllowDuplicates
          );
    End;
  Finally
    Q.Free;
    Values.Free;
  End;
End;

{!~ Presents a lookup Dialog to the user.  The selected
value is returned if the user presses OK and the Default
value is returned if the user presses Cancel unless the
TStringList is nil in which case a blank string is returned}
Function DialogLookup(
  const DialogCaption : string;
  const InputPrompt   : string;
  const DefaultValue  : string;
  const Values        : TStringList
  ): string;
Begin
  Result :=
  LookupDialog(
    DialogCaption,
    InputPrompt,
    DefaultValue,
    Values
    );
End;

{!~ Presents a lookup Dialog to the user.  The selected
value is returned if the user presses OK and the Default
value is returned if the user presses Cancel unless the
TStringList is nil in which case a blank string is returned}
Function DialogLookupDetail(
  Const DialogCaption   : string;
  Const InputPrompt     : string;
  Const DefaultValue    : string;
  Const Values          : TStringList;
  Const ButtonSpacing   : Integer;
  Const SpacerHeight    : Integer;
  Const TopBevelWidth   : Integer;
  Const PromptHeight    : Integer;
  Const FormHeight      : Integer;
  Const FormWidth       : Integer;
  Const Hint_OK         : string;
  Const Hint_Cancel     : string;
  Const Hint_ListBox    : string;
  Const ListSorted      : Boolean;
  Const AllowDuplicates : Boolean
  ): string;
Var
  Form         : TForm;
  Base_Panel   : TPanel;
  Base_Buttons : TPanel;
  Spacer       : TPanel;
  Base_Top     : TPanel;
  ButtonSlider : TPanel;
  ButtonSpacer : TPanel;
  Prompt       : TPanel;
  ListBox      : TListBox;
  ButtonCancelB: TPanel;
  ButtonOKB    : TPanel;
  Button_Cancel: TButton;
  Button_OK    : TButton;
  DefItemIndex : Integer;
  TempValues   : TStringList;
Begin
  Result     := DefaultValue;
  Form       := TForm.Create(Application);
  TempValues := TStringList.Create();
  Try
    TempValues.Sorted := ListSorted;
    TempValues.Clear;
    If AllowDuplicates Then
    Begin
      TempValues.Duplicates := dupAccept;
    End
    Else
    Begin
      TempValues.Duplicates := dupIgnore;
    End;
    If Values <> nil Then
    Begin
      TempValues.Assign(Values);
    End;
    With Form Do
    Begin
      Try
        Canvas.Font  := Font;
        BorderStyle  := bsSizeable;
        Caption      := DialogCaption;
        Height       := FormHeight;
        Width        := FormWidth;
        ShowHint     := True;
        Position     := poScreenCenter;
        BorderIcons  := [biMaximize];
        Base_Panel   := TPanel.Create(Form);
        With Base_Panel Do
        Begin
          Parent      := Form;
          Align       := alClient;
          Caption     := ' ';
          BorderWidth := 10;
          BorderStyle := bsNone;
          BevelOuter  := bvNone;
          BevelInner  := bvNone;
        End;
        Base_Buttons  := TPanel.Create(Form);
        With Base_Buttons Do
        Begin
          Parent      := Base_Panel;
          Align       := alBottom;
          Caption     := ' ';
          BorderWidth := 0;
          BorderStyle := bsNone;
          BevelOuter  := bvNone;
          BevelInner  := bvNone;
          Height      := 27;
        End;
        ButtonSlider  := TPanel.Create(Form);
        With ButtonSlider Do
        Begin
          Parent      := Base_Buttons;
          Align       := alClient;
          Caption     := ' ';
          BorderWidth := 0;
          BorderStyle := bsNone;
          BevelOuter  := bvNone;
          BevelInner  := bvNone;
        End;
        ButtonCancelB  := TPanel.Create(Form);
        With ButtonCancelB Do
        Begin
          Parent      := ButtonSlider;
          Align       := alRight;
          Caption     := ' ';
          BorderWidth := 0;
          BorderStyle := bsNone;
          BevelOuter  := bvNone;
          BevelInner  := bvNone;
          Width       := 75+ButtonSpacing;
        End;

        ButtonSpacer  := TPanel.Create(Form);
        With ButtonSpacer Do
        Begin
          Parent      := ButtonCancelB;
          Align       := alLeft;
          Caption     := ' ';
          BorderWidth := 0;
          BorderStyle := bsNone;
          BevelOuter  := bvNone;
          BevelInner  := bvNone;
          Width       := ButtonSpacing;
        End;

        ButtonOKB  := TPanel.Create(Form);
        With ButtonOKB Do
        Begin
          Parent      := ButtonSlider;
          Align       := alRight;
          Caption     := ' ';
          BorderWidth := 0;
          BorderStyle := bsNone;
          BevelOuter  := bvNone;
          BevelInner  := bvNone;
          Width       := 75;
        End;

        Spacer        := TPanel.Create(Form);
        With Spacer Do
        Begin
          Parent      := Base_Panel;
          Align       := alBottom;
          Caption     := ' ';
          BorderWidth := 0;
          BorderStyle := bsNone;
          BevelOuter  := bvNone;
          BevelInner  := bvNone;
          Height      := SpacerHeight;
        End;
        Base_Top      := TPanel.Create(Form);
        With Base_Top Do
        Begin
          Parent      := Base_Panel;
          Align       := alClient;
          Caption     := ' ';
          BorderWidth := 10;
          BorderStyle := bsNone;
          BevelOuter  := bvRaised;
          BevelInner  := bvNone;
          BevelWidth  := TopBevelWidth;
        End;
        Prompt        := TPanel.Create(Form);
        With Prompt Do
        Begin
          Parent   := Base_Top;
          Align       := alTop;
          Caption     := ' ';
          BorderWidth := 0;
          BorderStyle := bsNone;
          BevelOuter  := bvNone;
          BevelInner  := bvNone;
          Caption     := InputPrompt;
          Height      := PromptHeight;
          Alignment   := taCenter;
        End;

        Button_Cancel := TButton.Create(Form);
        With Button_Cancel Do
        Begin
          Parent      := ButtonCancelB;
          Caption     := 'Cancel';
          ModalResult := mrCancel;
          Default     := True;
          Align       := alClient;
          Hint        := Hint_Cancel;
        End;

        Button_OK := TButton.Create(Form);
        With Button_OK Do
        Begin
          Parent      := ButtonOKB;
          Caption     := 'OK';
          ModalResult := mrOK;
          Default     := False;
          Align       := alClient;
          Hint        := Hint_OK;
        End;
        ListBox := TListBox.Create(Form);
        With ListBox Do
        Begin
          Parent      := Base_Top;
          Align       := alClient;
          Hint        := Hint_ListBox;
          Sorted      := ListSorted;

          Focused;
          If TempValues <> nil Then
          Begin
            Items.Assign(TempValues);
            DefItemIndex := Items.IndexOf(DefaultValue);
            If DefItemIndex <> -1 Then
            Begin
              ItemIndex := DefItemIndex;
              Selected[DefItemIndex];
            End
            Else
            Begin
              Result    := '';
              ItemIndex := 0;
              Selected[0];
            End;
            IntegralHeight        := True;
            Button_OK.Default     := True;
            Button_Cancel.Default := False;
          End
          Else
          Begin
            Result := '';
          End;
        End;
        SetFocusedControl(ListBox);
        If ShowModal = mrOk Then
        Begin
          If ListBox.ItemIndex<>-1 Then
            Result := ListBox.Items[ListBox.ItemIndex];
        End;
      Finally
        Form.Free;
      End;
    End;
  Finally
    TempValues.Free;
  End;
End;

{!~ Drops A Table}
Function DropTable(const DatabaseName, TableName : string):Boolean;
Begin
  Result := DBDropTable(DatabaseName, TableName);
End;

{!~ Empties a table of all records}
Function EmptyTable(
           const DatabaseName,
           TableName : string): Boolean;
Begin
  Result := DBEmptyTable(DatabaseName, TableName);
End;

{!~ Returns the meaning of the given result code.  Error codes are for
Delphi 1.0.}
function ErrorMeaning (ResultCode: Integer): string;
const
  NumOfEntries = 108;
type
  ErrorEntry = record
    Code: Integer;
    Meaning: String;
  end;
  ErrorMeaningsArray = array [1..NumOfEntries] of ErrorEntry;
const
  MeaningsArray: ErrorMeaningsArray =
{DOS errors}
 ((Code:   1;  Meaning: 'Invalid DOS function number'),
  (Code:   2;  Meaning: 'File not found'),
  (Code:   3;  Meaning: 'Path not found'),
  (Code:   4;  Meaning: 'Too many open files'),
  (Code:   5;  Meaning: 'File access denied'),
  (Code:   6;  Meaning: 'Invalid file handle'),
  (Code:   7;  Meaning: 'Memory control blocks destroyed'),
  (Code:   8;  Meaning: 'Insufficient DOS memory'),
  (Code:   9;  Meaning: 'Invalid memory block address'),
  (Code:  10;  Meaning: 'Invalid DOS environment'),
  (Code:  11;  Meaning: 'Invalid format (DOS)'),
  (Code:  12;  Meaning: 'Invalid file access code'),
  (Code:  13;  Meaning: 'Invalid data (DOS)'),
  (Code:  15;  Meaning: 'Invalid drive number'),
  (Code:  16;  Meaning: 'Cannot remove current directory'),
  (Code:  17;  Meaning: 'Cannot rename across drives'),
  (Code:  18;  Meaning: 'No more files'),
  (Code:  19;  Meaning: 'Disk write-protected'),
  (Code:  20;  Meaning: 'Unknown unit (DOS)'),
  (Code:  21;  Meaning: 'Drive not ready'),
  (Code:  22;  Meaning: 'Unknown DOS command'),
  (Code:  23;  Meaning: 'CRC error'),
  (Code:  24;  Meaning: 'Bad request structure length'),
  (Code:  25;  Meaning: 'Seek error'),
  (Code:  26;  Meaning: 'Unknown media type'),
  (Code:  27;  Meaning: 'Disk sector not found'),
  (Code:  28;  Meaning: 'Out of paper'),
  (Code:  29;  Meaning: 'Write fault'),
  (Code:  30;  Meaning: 'Read fault'),
  (Code:  31;  Meaning: 'General failure'),
  (Code:  32;  Meaning: 'File sharing violation'),
  (Code:  33;  Meaning: 'File lock violation'),
  (Code:  34;  Meaning: 'Invalid disk change'),
  (Code:  35;  Meaning: 'File control block unavailable'),
  (Code:  36;  Meaning: 'Sharing buffer overflow'),
  (Code:  37;  Meaning: 'Code page mismatch'),
  (Code:  38;  Meaning: 'Error handling EOF'),
  (Code:  39;  Meaning: 'Handle disk full'),
  (Code:  50;  Meaning: 'Network request not supported'),
  (Code:  51;  Meaning: 'Remote computer not listening'),
  (Code:  52;  Meaning: 'Duplicate name on network'),
  (Code:  53;  Meaning: 'Network name not found'),
  (Code:  54;  Meaning: 'Network busy'),
  (Code:  55;  Meaning: 'Network device no longer exists'),
  (Code:  56;  Meaning: 'NetBIOS command limit exceeded'),
  (Code:  57;  Meaning: 'Network adaptor error'),
  (Code:  58;  Meaning: 'Incorrect network response'),
  (Code:  59;  Meaning: 'Unexpected network error'),
  (Code:  60;  Meaning: 'Incompatible remote adaptor'),
  (Code:  61;  Meaning: 'Print queue full'),
  (Code:  62;  Meaning: 'Not enough space for print file'),
  (Code:  63;  Meaning: 'Print file deleted'),
  (Code:  64;  Meaning: 'Network name deleted'),
  (Code:  65;  Meaning: 'Access denied'),
  (Code:  66;  Meaning: 'Network device type incorrect'),
  (Code:  67;  Meaning: 'Network name not found'),
  (Code:  68;  Meaning: 'Network name limit exceeded'),
  (Code:  69;  Meaning: 'NetBIOS session limit exceeded'),
  (Code:  70;  Meaning: 'Temporarily paused'),
  (Code:  71;  Meaning: 'Network request not accepted'),
  (Code:  72;  Meaning: 'Print/disk redirection paused'),
  (Code:  80;  Meaning: 'File already exists'),
  (Code:  82;  Meaning: 'Cannot make directory entry'),
  (Code:  83;  Meaning: 'Fail on interrupt 24'),
  (Code:  84;  Meaning: 'Too many redirections'),
  (Code:  85;  Meaning: 'Duplicate redirection'),
  (Code:  86;  Meaning: 'Invalid password'),
  (Code:  87;  Meaning: 'Invalid parameter'),
  (Code:  88;  Meaning: 'Network data fault'),
{I/O errors}
  (Code: 100;  Meaning: 'Disk read error'),
  (Code: 101;  Meaning: 'Disk write error'),
  (Code: 102;  Meaning: 'File not assigned'),
  (Code: 103;  Meaning: 'File not open'),
  (Code: 104;  Meaning: 'File not open for input'),
  (Code: 105;  Meaning: 'File not open for output'),
  (Code: 106;  Meaning: 'Invalid numeric format'),
{Critical errors (Real or protected mode only)}
  (Code: 150;  Meaning: 'Disk is write protected'),
  (Code: 151;  Meaning: 'Unknown unit'),
  (Code: 152;  Meaning: 'Drive not ready'),
  (Code: 153;  Meaning: 'Unknown DOS command'),
  (Code: 154;  Meaning: 'CRC error in data'),
  (Code: 155;  Meaning: 'Bad drive request struct length'),
  (Code: 156;  Meaning: 'Disk seek error'),
  (Code: 157;  Meaning: 'Unknown media type'),
  (Code: 158;  Meaning: 'Sector not found'),
  (Code: 159;  Meaning: 'Printer out of paper'),
  (Code: 160;  Meaning: 'Device write fault'),
  (Code: 161;  Meaning: 'Device read fault'),
  (Code: 162;  Meaning: 'Hardware failure'),
{Fatal errors}
  (Code: 200;  Meaning: 'Division by zero'),
  (Code: 201;  Meaning: 'Range check error'),
  (Code: 202;  Meaning: 'Stack overflow error'),
  (Code: 203;  Meaning: 'Heap overflow error'),
  (Code: 204;  Meaning: 'Invalid pointer operation'),
  (Code: 205;  Meaning: 'Floating point overflow'),
  (Code: 206;  Meaning: 'Floating point underflow'),
  (Code: 207;  Meaning: 'Invalid floating pt. operation'),
  (Code: 208;  Meaning: 'Overlay manager not installed'),
  (Code: 209;  Meaning: 'Overlay file read error'),
  (Code: 210;  Meaning: 'Object not initialised'),
  (Code: 211;  Meaning: 'Call to abstract method'),
  (Code: 212;  Meaning: 'Stream registration error'),
  (Code: 213;  Meaning: 'TCollection index out of range'),
  (Code: 214;  Meaning: 'TCollection overflow error'),
  (Code: 215;  Meaning: 'Arithmetic overflow error'),
  (Code: 216;  Meaning: 'General Protection Fault'),
  (Code: 217;  Meaning: 'Unhandled exception'),
  (Code: 219;  Meaning: 'Invalid typecast'));
var
  Low, High, Mid, Diff: Integer;
begin
  Low := 1;
  High := NumOfEntries;
  while Low <= High do
  begin
    Mid := (Low + High) div 2;
    Diff := MeaningsArray[Mid].Code - ResultCode;
    if Diff < 0 then Low  := Mid + 1 else
    if Diff > 0 then High := Mid - 1 else
    begin {found it}
      Result := MeaningsArray[Mid].Meaning;
      Exit;
    end;
  end; {while}
  Result := 'Error ' + IntToStr(ResultCode) +
                ' (meaning unknown)';
end;

{!~ Returns the field Number as an integer.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason 0 is returned.}
Function FieldNo(DatabaseName, TableName, FieldName: String): Integer;
Begin
  Result := DBFieldNo(DatabaseName, TableName, FieldName);
End;

{!~ Returns the database field Size as an integer.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason 0 is returned.}
Function FieldSize(DatabaseName, TableName, FieldName: String): Integer;
Begin
  Result := FieldSize(DatabaseName, TableName, FieldName);
End;

{!~ Returns the database field type as a string.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason a null string is returned.}
Function FieldType(DatabaseName, TableName, FieldName: String): String;
Begin
  Result := TypeField(DatabaseName, TableName, FieldName);
End;

{!~ Returns the database field type as a string.  If there
is an error a null string is returned.}
Function FieldTypeFromDataSet(DataSet: TDataSet; FieldName: String): String;
Begin
  Result := TypeFieldFromDataSet(DataSet, FieldName);
End;

{!~ Tests whether a TDataSource is empty, i.e., has no records }
Function IsEmptyDataSource(DS: TDataSource): Boolean;
Var
  IsError   : Boolean;
  BOF       : Boolean;
  EOF       : Boolean;
  ActiveWas : Boolean;
Begin
  ActiveWas := DS.DataSet.Active;
  IsError   := False;
  BOF       := False;
  EOF       := False;

  Try
    If Not DS.DataSet.Active Then DS.DataSet.Active := True;
    BOF := DS.DataSet.BOF;
    EOF := DS.DataSet.EOF;
  Except
    IsError := True
  End;

  If IsError Then
  Begin
    Result := False;
  End
  Else
  Begin
    If BOF And EOF Then
    Begin
      Result := True;
    End
    Else
    Begin
      Result := False;
    End;
  End;
  DS.DataSet.Active := ActiveWas;
End;

{!~ Tests whether a TQuery is empty, i.e., has no records }
Function IsEmptyTQuery(Query: TQuery): Boolean;
Var
  IsError   : Boolean;
  BOF       : Boolean;
  EOF       : Boolean;
  ActiveWas : Boolean;
Begin
  ActiveWas := Query.Active;
  IsError   := False;
  BOF       := False;
  EOF       := False;

  Try
    If Not Query.Active Then Query.Active := True;
    BOF := Query.BOF;
    EOF := Query.EOF;
  Except
    IsError := True
  End;

  If IsError Then
  Begin
    Result := False;
  End
  Else
  Begin
    If BOF And EOF Then
    Begin
      Result := True;
    End
    Else
    Begin
      Result := False;
    End;
  End;
  Query.Active := ActiveWas;
End;

{!~ Tests whether a TTable is empty, i.e., has no records }
Function IsEmptyTTable(Table: TTable): Boolean;
Var
  IsError   : Boolean;
  BOF       : Boolean;
  EOF       : Boolean;
  ActiveWas : Boolean;
Begin
  ActiveWas := Table.Active;
  IsError   := False;
  BOF       := False;
  EOF       := False;

  Try
    If Not Table.Active Then Table.Active := True;
    BOF := Table.BOF;
    EOF := Table.EOF;
  Except
    IsError := True
  End;

  If IsError Then
  Begin
    Result := False;
  End
  Else
  Begin
    If BOF And EOF Then
    Begin
      Result := True;
    End
    Else
    Begin
      Result := False;
    End;
  End;
  Table.Active := ActiveWas;
End;

{!~ Tests whether a table is empty, i.e., has no records }
Function IsEmptyTable(DatabaseName, TableName: String): Boolean;
Var
  Query   : TQuery;
  IsError : Boolean;
  BOF     : Boolean;
  EOF     : Boolean;
Begin
  IsError := False;
  BOF     := False;
  EOF     := False;
  Try
    Query := TQuery.Create(nil);
    Try
      Query.DatabaseName := DatabaseName;
      Query.Sql.Clear;
      Query.Sql.Add('Select *');
      Query.Sql.Add('From');

      If (Pos('.DB', UpperCase(TableName)) > 0)  Or
         (Pos('.DBF', UpperCase(TableName)) > 0) Then
      Begin
        Query.Sql.Add('"'+TableName+'"');
      End
      Else
      Begin
        Query.Sql.Add(TableName);
      End;
      Query.Active := True;
      Query.First;
      BOF := Query.BOF;
      EOF := Query.EOF;
    Except
      IsError := True
    End;
  Finally
    Query.Free;
  End;

  If IsError Then
  Begin
    Result := False;
  End
  Else
  Begin
    If BOF And EOF Then
    Begin
      Result := True;
    End
    Else
    Begin
      Result := False;
    End;
  End;
End;

{!~ Returns True If DatabaseName:TableName:FieldName Exists,
False Otherwise}
Function IsField(DatabaseName, TableName, FieldName: String): Boolean;
Var
  Query   : TQuery;
  T       : TTable;
  i       : Integer;
  UpperFN : String;
  TestFN  : String;
Begin
  Result  := False;
  UpperFN := UpperCase(FieldName);
  If Not IsTable(DatabaseName, TableName) Then Exit;
  Query := TQuery.Create(nil);
  T     := TTable.Create(nil);
  Try
    Try
      Query.DatabaseName := DatabaseName;
      Query.Sql.Clear;
      Query.Sql.Add('Select ');
      Query.Sql.Add('a.'+FieldName+' XYZ');
      Query.Sql.Add('From');
      If (Pos('.DB', UpperCase(TableName)) > 0) Or
         (Pos('.DBF',UpperCase(TableName)) > 0) Then
      Begin
        Query.Sql.Add('"'+TableName+'" a');
      End
      Else
      Begin
        Query.Sql.Add(TableName+' a');
      End;
      Query.Active := True;
      Result := True;
    Except
      Try
        T.Active       := False;
        T.DatabaseName := DatabaseName;
        T.TableName    := TableName;
        T.Active       := True;
        If T.FieldDefs.IndexOf(FieldName) > -1 Then
        Begin
          Result := True;
        End
        Else
        Begin
          For i := 0 To T.FieldDefs.Count -1 Do
          Begin
            TestFN := UpperCase(T.FieldDefs[i].Name);
            If TestFN = UpperFN Then
            Begin
              Result := True;
              Break;
            End;
          End;
        End;
        T.Active := False;
      Except
      End;
    End;
  Finally
    Query.Free;
    T.Free;
  End;
End;

{!~ Returns True If DatabaseName:TableName:FieldName
 Exists and is Keyed, False Otherwise}
Function IsFieldKeyed(DatabaseName, TableName, FieldName: String): Boolean;
Var
  Table      : TTable;
  FieldIndex : Integer;
  i          : Integer;
  KeyCount   : Integer;
  LocalTable : Boolean;
  ParadoxTbl : Boolean;
  DBaseTable : Boolean;
  TempString : String;
Begin
  Result := False;
  If Not IsTable(DatabaseName, TableName) Then Exit;
  If Not IsField(DatabaseName, TableName, FieldName) Then Exit;
  TempString := UpperCase(Copy(TableName,Length(TableName)-2,3));
  ParadoxTbl := (Pos('.DB',TempString) > 0);
  TempString := UpperCase(Copy(TableName,Length(TableName)-3,4));
  DBaseTable := (Pos('.DBF',TempString) > 0);
  LocalTable := (ParadoxTbl Or DBaseTable);
  Table := TTable.Create(nil);
  Try
    Try
      Table.DatabaseName := DatabaseName;
      Table.TableName    := TableName;
      Table.Active := True;
      KeyCount     := Table.IndexFieldCount;
      FieldIndex   := Table.FieldDefs.IndexOf(FieldName);

      If LocalTable Then
      Begin
        If ParadoxTbl Then
        Begin
          Result := (FieldIndex < KeyCount);
        End
        Else
        Begin
          Table.IndexDefs.UpDate;
          For i := 0 To Table.IndexDefs.Count-1 Do
          Begin
            {Need to check if FieldName is in the Expression listing}
            If Pos(UpperCase(FieldName),UpperCase(Table.IndexDefs[i].Expression))>0 Then
            Begin
              Result := True;
              Break;
            End;
            {Need to check if FieldName is in the Fields listing}
            If Pos(UpperCase(FieldName),UpperCase(Table.IndexDefs[i].Fields))>0 Then
            Begin
              Result := True;
              Break;
            End;
          End;
        End;
      End
      Else
      Begin
        If Table.
             FieldDefs[FieldIndex].
             Required
        Then
        Begin
          Result := True;
        End;
      End;
    Except
    End;
  Finally
    Table.Free;
  End;
End;

{!~ Returns True If The Record Exists, False Otherwise}
Function IsRecord(
  DatabaseName : String;
  TableName    : String;
  TableKeys    : TStringList;
  KeyValues    : TStringList): Boolean;
Var
  Q : TQuery;
  i : Integer;
Begin
  Q := TQuery.Create(nil);
  Try
    Q.Active := False;
    Q.DatabaseName := DatabaseName;
    Q.RequestLive  := True;
    Q.Sql.Clear;
    Q.Sql.Add('Select');
    For i := 0 To TableKeys.Count - 1 Do
    Begin
      If i = (TableKeys.Count - 1) Then
      Begin
        Q.Sql.Add(TableKeys[i]);
      End
      Else
      Begin
        Q.Sql.Add(TableKeys[i]+',');
      End;
    End;
    Q.Sql.Add('From');
    If Pos('.DB',UpperCase(TableName)) > 0 Then
    Begin
      Q.Sql.Add('"'+TableName+'" ');
    End
    Else
    Begin
      Q.Sql.Add(TableName);
    End;
    Q.Sql.Add('Where');
    For i := 0 To TableKeys.Count - 1 Do
    Begin
      If i <> 0 Then Q.Sql.Add('And');
      Q.Sql.Add(TableKeys[i]+' = '+
        DBSqlValueQuoted(DatabaseName,TableName,
          TableKeys[i],KeyValues[i]));
    End;
    Q.Active := True;
    Result   := Not IsEmptyTQuery(Q);
  Finally
    Q.Free;
  End;
End;

{!~ Returns True If The Tables Have Identical Structures, False Otherwise.
If 1 Local Table is involved then Indices are ignored!!!!!!}
Function IsSchemaSame(const
           DatabaseName1,
           Table1,
           DatabaseName2,
           Table2: string): Boolean;
Begin
  Result := IsStructureSame(DatabaseName1,Table1,DatabaseName2,Table2);
End;

{!~ Returns True If The Tables Have Identical Structures, False Otherwise.
If 1 Local Table is involved then Indices are ignored!!!!!!}
Function IsStructureSame(const
           DatabaseName1,
           Table1,
           DatabaseName2,
           Table2: string): Boolean;
Var
  T1      : TTable;
  T2      : TTable;
  i       : Integer;
  OneLocal : Boolean;
Begin
  Result := False;
  If Not IsTable(DatabaseName1, Table1) Then Exit;
  If Not IsTable(DatabaseName2, Table2) Then Exit;
  If (Pos('.DB',UpperCase(Table1)) > 0) Or
     (Pos('.DB',UpperCase(Table2)) > 0) Then
  Begin
    OneLocal := True;
  End
  Else
  Begin
    OneLocal := False;
  End;

  T1 := TTable.Create(nil);
  T2 := TTable.Create(nil);
  Try
    Try
      T1.Active       := False;
      T1.DatabaseName := DatabaseName1;
      T1.TableName    := Table1;
      T1.Active       := True;

      T2.Active       := False;
      T2.DatabaseName := DatabaseName2;
      T2.TableName    := Table2;
      T2.Active       := True;

      If T1.FieldDefs.Count <> T2.FieldDefs.Count Then
      Begin
        Result := False;
      End
      Else
      Begin
        Result := True;
        For i := 0 To T1.FieldDefs.Count-1 Do
        Begin
          If (T1.FieldDefs[i].DataType   <> T2.FieldDefs[i].DataType)   Or
             (T1.FieldDefs[i].FieldClass <> T2.FieldDefs[i].FieldClass) Or
             (T1.FieldDefs[i].FieldNo    <> T2.FieldDefs[i].FieldNo)    Or
             (UpperCase(T1.FieldDefs[i].Name)<>UpperCase(T2.FieldDefs[i].Name)) Or
             (T1.FieldDefs[i].Size       <> T2.FieldDefs[i].Size)       Then
          Begin
            Result := False;
            Break;
          End;
          If (T1.FieldDefs[i].Required   <> T2.FieldDefs[i].Required)   And
             (Not OneLocal)                                             Then
          Begin
            Result := False;
            Break;
          End;
        End;
      End;
    Except
    End;
  Finally
    T1.Free;
    T2.Free;
  End;
End;

{!~ Returns True If The Table Exists, False Otherwise.
This procedure needs to be improved.
Please give recommendations or new code.}
Function IsTable(DatabaseName, TableName: String): Boolean;
Var
  Query: TQuery;
Begin
  Result := False;
  Query := TQuery.Create(nil);
  Try
    Try
      Query.DatabaseName := DatabaseName;
      Query.Sql.Clear;
      Query.Sql.Add('Select *');
      Query.Sql.Add('From');
      If (Pos('.DB', UpperCase(TableName)) > 0) Or
         (Pos('.DBF',UpperCase(TableName)) > 0) Then
      Begin
        Query.Sql.Add('"'+TableName+'"');
      End
      Else
      Begin
        Query.Sql.Add(TableName);
      End;
      Query.Active := True;
      Result := True;
    Except
    End;
  Finally
    Query.Free;
  End;
End;

{!~ Returns True If DatabaseName:TableName
Exists and has a primary key, False Otherwise}
Function IsTableKeyed(DatabaseName, TableName: String): Boolean;
Var
  Table      : TTable;
  i          : Integer;
  IsKeyed    : Boolean;
Begin
  Result  := False;
  IsKeyed := False;
  If Not IsTable(DatabaseName, TableName) Then Exit;
  Table := TTable.Create(nil);
  Try
    Try
      Table.DatabaseName := DatabaseName;
      Table.TableName    := TableName;
      Table.Active       := True;
      For i := 0 To Table.FieldDefs.Count-1 Do
      Begin
         If Table.FieldDefs[i].Required Then
         Begin
           IsKeyed := True;
           Break;
         End;
      End;

      If IsKeyed Then
      Begin
        Result := True;
      End
      Else
      Begin
        Result := False;
        {Need to examine indexdefs}
        If (Pos('.DB', UpperCase(TableName)) > 0) Then
        Begin
          {Table is either Paradox or DBase}
          Table.IndexDefs.UpDate;
          If (Pos('.DBF', UpperCase(TableName)) > 0) Then
          Begin
            {Table is a DBase Table}
            If Table.IndexDefs.Count > 0 Then
            Begin
              Result := True;
            End;
          End
          Else
          Begin
            {Table is a Paradox Table}
            For i := 0 To Table.IndexDefs.Count-1 Do
            Begin
              If ixPrimary in Table.IndexDefs[i].Options Then
              Begin
                Result := True;
                Break;
              End;
            End;
          End;
        End
        Else
        Begin
          Result := False;
        End;
      End;
    Except
    End;
  Finally
    Table.Free;
  End;
End;

{!~ Presents a lookup Dialog to the user.  The selected
value is returned if the user presses OK and the Default
value is returned if the user presses Cancel unless the
TStringList is nil in which case a blank string is returned}
Function LookupDialog(
  const DialogCaption : string;
  const InputPrompt   : string;
  const DefaultValue  : string;
  const Values        : TStringList
  ): string;
Begin
  Result :=
    DialogLookupDetail(
      DialogCaption,
      InputPrompt,
      DefaultValue,
      Values,        //TStringList
      5,             //Spacer Height
      5,             //Button Spacing
      2,             //BevelWidth
      25,            //PromptHeight
      300,           //FormHeight
      200,           //FormWidth
      'Close dialog and return selected value.', //Hint_Cancel
      'Close dialog and make no changes.', //Hint_OK
      'Click an item to select it.',  //Hint_ListBox
      True, //ListSorted
      False //AllowDuplicates
      );
End;

{!~ Moves SourceTable From SourceDatabaseName
 To DestDatabasename.  If a table exists
 with the same name at DestDatabaseName it
 is overwritten.}
Function MoveTable(
            SourceTable,
            SourceDatabaseName,
            DestDatabaseName: String): Boolean;
Begin
  Result := DBMoveTable(SourceTable,SourceDatabaseName,DestDatabaseName);
End;

{!~ Returns the number of fields in a table}
Function NFields(DatabaseName, TableName: String): Integer;
Var
  Table      : TTable;
  FieldCount : Integer;
Begin
  Result := 0;
  Table := TTable.Create(nil);
  Try
    Try
      Table.Active       := False;
      Table.DatabaseName := DatabaseName;
      Table.TableName    := TableName;
      Table.Active       := True;
      FieldCount         := Table.FieldDefs.Count;
      Result             := FieldCount;
    Except
    End;
  Finally
    Table.Free;
  End;
End;

{!~ Subtracts the records in the source
 table from the destination table}
Function SubtractTable(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable: string): Boolean;
Begin
  Result := False;
  If (Not IsTableKeyed(DestDatabaseName,DestinationTable)) Or
     (Not IsTableKeyed(SourceDatabaseName,SourceTable))    Then
  Begin
    Exit;
  End;

  Result := DBRecordMove(SourceDatabaseName,SourceTable,
                         DestDatabaseName,DestinationTable,batDelete);
End;

{!~ Add source table to destination table}
Function TableAdd(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable: string): Boolean;
Begin
  Result := AddTables(SourceDatabaseName,SourceTable,
                      DestDatabaseName,DestinationTable);
End;

{!~ Creates a new table from a Query.
 Complex joins can be output to a new table.}
Function TableCreateFromQuery(
            Query: TQuery;
            NewTableName,
            TableDatabaseName: String): Boolean;
Begin
  Result := DBCreateTableFromQuery(Query,NewTableName,TableDatabaseName);
End;

{!~ Moves SourceTable From SourceDatabaseName
 To DestDatabasename.  If a table exists
 with the same name at DestDatabaseName it
 is overwritten.}
Function TableMove(
            SourceTable,
            SourceDatabaseName,
            DestDatabaseName: String): Boolean;
Begin
  Result := DBMoveTable(SourceTable,SourceDatabaseName,DestDatabaseName);
End;

{!~ Subtracts the records in the source
 table from the destination table}
Function TableSubtract(
           const
           SourceDatabaseName,
           SourceTable,
           DestDatabaseName,
           DestinationTable: string): Boolean;
Begin
  Result := SubtractTable(SourceDatabaseName,SourceTable,
                      DestDatabaseName,DestinationTable);
End;

{!~ Returns the database field type as a string.  If there
is an error, the table doesn't exist, the field doesn't
exist or some other reason a null string is returned.}
Function TypeField(DatabaseName, TableName, FieldName: String): String;
Var
  Table      : TTable;
  FieldIndex : Integer;
  FieldType  : TFieldType;
Begin
  Result := '';
  If Not IsTable(DatabaseName, TableName) Then Exit;
  If Not IsField(DatabaseName, TableName, FieldName) Then Exit;
  Table := TTable.Create(nil);
  Try
    Try
      Table.Active       := False;
      Table.DatabaseName := DatabaseName;
      Table.TableName    := TableName;
      Table.Active       := True;
      FieldIndex         :=
        Table.FieldDefs.IndexOf(FieldName);
      FieldType          :=
        Table.FieldDefs[FieldIndex].DataType;

      {TFieldType
      Possible Delphi 1.0 values are
      ftUnknown, ftString, ftSmallint,
      ftInteger, ftWord, ftBoolean,
      ftFloat, ftCurrency, ftBCD, ftDate,
      ftTime, ftDateTime, ftBytes, ftVarBytes,
      ftBlob, ftMemo or ftGraphic

      Additional Delphi 2.0 values are:
      ftAutoInc
      ftFmtMemo
      ftParadoxOle
      ftDBaseOle
      ftTypedBinary
      }
      If FieldType=ftUnknown  Then Result := 'Unknown';
      If FieldType=ftString   Then Result := 'String';
      If FieldType=ftSmallInt Then Result := 'SmallInt';
      If FieldType=ftInteger  Then Result := 'Integer';
      If FieldType=ftWord     Then Result := 'Word';
      If FieldType=ftBoolean  Then Result := 'Boolean';
      If FieldType=ftFloat    Then Result := 'Float';
      If FieldType=ftCurrency Then Result := 'Currency';
      If FieldType=ftBCD      Then Result := 'BCD';
      If FieldType=ftDate     Then Result := 'Date';
      If FieldType=ftTime     Then Result := 'Time';
      If FieldType=ftDateTime Then Result := 'DateTime';
      If FieldType=ftBytes    Then Result := 'Bytes';
      If FieldType=ftVarBytes Then Result := 'VarBytes';
      If FieldType=ftBlob     Then Result := 'Blob';
      If FieldType=ftMemo     Then Result := 'Memo';
      If FieldType=ftGraphic  Then Result := 'Graphic';
{$IFDEF WIN32}
      If FieldType=ftAutoInc      Then Result := 'AutoInc';
      If FieldType=ftFmtMemo      Then Result := 'FmtMemo';
      If FieldType=ftParadoxOle   Then Result := 'ParadoxOle';
      If FieldType=ftDBaseOle      Then Result := 'DBaseOle';
      If FieldType=ftTypedBinary  Then Result := 'TypedBinary';
{$ENDIF}
    Except
    End;
  Finally
    Table.Free;
  End;
End;

{!~ Returns the database field type as a string.  If there
is an error a null string is returned.}
Function TypeFieldFromDataSet(DataSet: TDataSet; FieldName: String): String;
Var
  FieldIndex : Integer;
  FieldType  : TFieldType;
Begin
  Try
    DataSet.Active     := True;
    FieldIndex         :=
      DataSet.FieldDefs.IndexOf(FieldName);
    FieldType          :=
      DataSet.FieldDefs[FieldIndex].DataType;
    {TFieldType Possible values are
    ftUnknown, ftString, ftSmallint,
    ftInteger, ftWord, ftBoolean,
    ftFloat, ftCurrency, ftBCD, ftDate,
    ftTime, ftDateTime, ftBytes, ftVarBytes,
    ftBlob, ftMemo or ftGraphic}
    If FieldType=ftUnknown  Then Result := 'Unknown';
    If FieldType=ftString   Then Result := 'String';
    If FieldType=ftSmallInt Then Result := 'SmallInt';
    If FieldType=ftInteger  Then Result := 'Integer';
    If FieldType=ftWord     Then Result := 'Word';
    If FieldType=ftBoolean  Then Result := 'Boolean';
    If FieldType=ftFloat    Then Result := 'Float';
    If FieldType=ftCurrency Then Result := 'Currency';
    If FieldType=ftBCD      Then Result := 'BCD';
    If FieldType=ftDate     Then Result := 'Date';
    If FieldType=ftTime     Then Result := 'Time';
    If FieldType=ftDateTime Then Result := 'DateTime';
    If FieldType=ftBytes    Then Result := 'Bytes';
    If FieldType=ftVarBytes Then Result := 'VarBytes';
    If FieldType=ftBlob     Then Result := 'Blob';
    If FieldType=ftMemo     Then Result := 'Memo';
    If FieldType=ftGraphic  Then Result := 'Graphic';
  Except
  End;
End;

End.
{</PRE></BODY></HTML>     }
