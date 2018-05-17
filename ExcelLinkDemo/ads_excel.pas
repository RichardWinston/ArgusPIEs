{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
"http://www.w3.org/TR/REC-html40/loose.dtd">
<HTML><BODY BGCOLOR="#ffffff"><PRE>  }

unit ads_excel;

(*Copyright(c)1998 Advanced Delphi Systems

 Richard Maley
 Advanced Delphi Systems
 12613 Maidens Bower Drive
 Potomac, MD 20854 USA
 phone 301-840-1554
 maley@advdelphisys.com
 maley@compuserve.com
 maley@cpcug.org

 This unit contains many functions and procedures for
 controlling Excel spreadsheets. The code has been
 tested against Excel versions 7.0 and 8.0 and only those.
 Additionally the code is very sensitive to the
 differences in ole control of these two Excel versions.
 If you find errors or better ways of accomplishing some
 of these tasks please let me know so that I can improve
 the code and pass the benefits on to others.

 Thank you,

 Richard Maley
*)

interface

uses
  Dialogs, Messages, SysUtils, Grids, {Cmp_Sec,} ComObj, Ads_Misc;

  {!~Add a blank WorkSheet}
  Function ExcelAddWorkSheet(Excel : Variant): Boolean;

  {!~Close Excel}
  Function ExcelClose(Excel : Variant; SaveAll: Boolean): Boolean;

  {!~Returns the Column String Value from its integer equilavent.}
  Function ExcelColIntToStr(ColNum: Integer): ShortString;

  {!~Returns the Column Integer Value from its Alpha equilavent.}
  Function ExcelColStrToInt(ColStr: ShortString): Integer;

  {!~Close All Workbooks.  All workbooks can be saved or not.}
  Function ExcelCloseWorkBooks(Excel : Variant; SaveAll: Boolean): Boolean;

  {!~Copies a range of Excel Cells to a Delphi StringGrid.  If successful
  True is returned, False otherwise.  If SizeStringGridToFit is True
  then the StringGrid is resized to be exactly the correct dimensions to
  receive the input Excel cells, otherwise the StringGrid is not resized.
  If ClearStringGridFirst is true then any cells outside the input range
  are cleared, otherwise existing values are retained.  Please not that the
  Excel cell coordinates are "1" based and the Delphi StringGrid coordinates
  are zero based.}
  Function ExcelCopyToStringGrid(
    Excel                 : Variant;
    ExcelFirstRow         : Integer;
    ExcelFirstCol         : Integer;
    ExcelLastRow          : Integer;
    ExcelLastCol          : Integer;
    StringGrid            : TStringGrid;
    StringGridFirstRow    : Integer;
    StringGridFirstCol    : Integer;
    {Make the StringGrid the same size as the input range}
    SizeStringGridToFit   : Boolean;
    {cells outside input range in StringGrid are cleared}
    ClearStringGridFirst  : Boolean
    ): Boolean;

  {!~Delete a WorkSheet by Name}
  Function ExcelDeleteWorkSheet(
    Excel     : Variant;
    SheetName : ShortString): Boolean;

  {!~Moves the cursor to the last row and column}
  Function ExcelEnd(Excel : Variant): Boolean;

  {!~Finds A value and moves the cursor there.
  If the value is not found then the cursor does not move.
  If nothing is found then false is returned, True otherwise.}
  Function ExcelFind(
    Excel       : Variant;
    FindString  : ShortString): Boolean;

  {!~Finds A value in a range and moves the cursor there.
  If the value is not found then the cursor does not move.
  If nothing is found then false is returned, True otherwise.}
  Function ExcelFindInRange(
    Excel       : Variant;
    FindString  : ShortString;
    TopRow      : Integer;
    LeftCol     : Integer;
    LastRow     : Integer;
    LastCol     : Integer): Boolean;

  {!~Finds A value in a range and moves the cursor there.  If the value is
  not found then the cursor does not move.  If nothing is found then
  false is returned, True otherwise.  The search directions can be defined.
  If you want row searches to go from left to right then SearchRight should
  be set to true, False otherwise.  If you want column searches to go from
  top to bottom then SearchDown should be set to true, false otherwise.
  If RowsFirst is set to true then all the columns in a complete row will be
  searched.}
  Function ExcelFindValue(
    Excel       : Variant;
    FindString  : ShortString;
    TopRow      : Integer;
    LeftCol     : Integer;
    LastRow     : Integer;
    LastCol     : Integer;
    SearchRight : Boolean;
    SearchDown  : Boolean;
    RowsFirst   : Boolean
    ): Boolean;

  {!~Returns The First Col}
  Function ExcelFirstCol(Excel : Variant): Integer;

  {!~Returns The First Row}
  Function ExcelFirstRow(Excel : Variant): Integer;

  {!~Returns the name of the currently active worksheet
  as a shortstring}
  Function ExcelGetActiveSheetName(Excel : Variant): ShortString;

  {!~Gets the formula in a cell.}
  Function ExcelGetCellFormula(
    Excel         : Variant;
    RowNum, ColNum: Integer): ShortString;

  {!~Returns the contents of a cell as a shortstring}
  Function ExcelGetCellValue(Excel : Variant; RowNum, ColNum: Integer): ShortString;

  {!~Returns the the current column}
  Function ExcelGetCol(Excel : Variant): Integer;

  {!~Returns the the current row}
  Function ExcelGetRow(Excel : Variant): Integer;

  {!~Moves the cursor to the last column}
  Function ExcelGoToLastCol(Excel : Variant): Boolean;

  {!~Moves the cursor to the last row}
  Function ExcelGoToLastRow(Excel : Variant): Boolean;

  {!~Moves the cursor to the Leftmost Column}
  Function ExcelGoToLeftmostCol(Excel : Variant): Boolean;

  {!~Moves the cursor to the Top row}
  Function ExcelGoToTopRow(Excel : Variant): Boolean;

  {!~Moves the cursor to Home position, i.e., A1}
  Function ExcelHome(Excel : Variant): Boolean;

  {!~Returns The Last Column}
  Function ExcelLastCol(Excel : Variant): Integer;

  {!~Returns The Last Row}
  Function ExcelLastRow(Excel : Variant): Integer;

  {!~Open the file you want to work within Excel.  If you want to
  take advantage of optional parameters then you should use
  ExcelOpenFileComplex}
  Function ExcelOpenFile(Excel : Variant; FileName : String): Boolean;

  {!~Open the file you want to work within Excel.  If you want to
  take advantage of optional parameters then you should use
  ExcelOpenFileComplex}
  Function ExcelOpenFileComplex(
    Excel        : Variant;
    FileName     : String;
    UpdateLinks  : Integer;
    ReadOnly     : Boolean;
    Format       : Integer;
    Password     : ShortString): Boolean;

  {!~Saves the range on the currently active sheet
  to to values only.}
  Function ExcelPasteValuesOnly(
    Excel         : Variant;
    ExcelFirstRow : Integer;
    ExcelFirstCol : Integer;
    ExcelLastRow  : Integer;
    ExcelLastCol  : Integer): Boolean;

  {!~Renames a worksheet.}
  Function ExcelRenameSheet(
    Excel         : Variant;
    OldName       : ShortString;
    NewName       : ShortString): Boolean;

  {!~Saves the range on the currently active sheet
  to a DBase 4 table.}
  Function ExcelSaveAsDBase4(
    Excel         : Variant;
    ExcelFirstRow : Integer;
    ExcelFirstCol : Integer;
    ExcelLastRow  : Integer;
    ExcelLastCol  : Integer;
    OutFilePath   : ShortString;
    OutFileName   : ShortString): Boolean;

  {!~Saves the range on the currently active sheet
  to a text file.}
  Function ExcelSaveAsText(
    Excel         : Variant;
    ExcelFirstRow : Integer;
    ExcelFirstCol : Integer;
    ExcelLastRow  : Integer;
    ExcelLastCol  : Integer;
    OutFilePath   : ShortString;
    OutFileName   : ShortString): Boolean;

  {!~Selects a range on the currently active sheet.  From the
  current cursor position a block is selected down and to the right.
  The block proceeds down until an empty row is encountered.  The
  block proceeds right until an empty column is encountered.}
  Function ExcelSelectBlock(
      Excel    : Variant;
      FirstRow : Integer;
      FirstCol : Integer): Boolean;

  {!~Selects a range on the currently active sheet.  From the
  current cursor position a block is selected that contains
  the currently active cell.  The block proceeds in each
  direction until an empty row or column is encountered.}
  Function ExcelSelectBlockWhole(Excel: Variant): Boolean;

  {!~Selects a cell on the currently active sheet}
  Function ExcelSelectCell(Excel : Variant; RowNum, ColNum: Integer): Boolean;

  {!~Selects a range on the currently active sheet}
  Function ExcelSelectRange(
    Excel    : Variant;
    FirstRow : Integer;
    FirstCol : Integer;
    LastRow  : Integer;
    LastCol  : Integer): Boolean;

  {!~Selects an Excel Sheet By Name}
  Function ExcelSelectSheetByName(Excel : Variant; SheetName: String): Boolean;

  {!~Sets the formula in a cell.  Remember to include the equals sign "=".
  If the function fails False is returned, True otherwise.}
  Function ExcelSetCellFormula(
    Excel         : Variant;
    FormulaString : ShortString;
    RowNum, ColNum: Integer): Boolean;

  {!~Sets the contents of a cell as a shortstring}
  Function ExcelSetCellValue(
    Excel : Variant;
    RowNum, ColNum: Integer;
    Value : ShortString): Boolean;

  {!~Sets a Column Width on the currently active sheet}
  Function ExcelSetColumnWidth(
    Excel      : Variant;
    ColNum     : Integer;
    ColumnWidth: Integer): Boolean;

  {!~Set Excel Visibility}
  Function ExcelSetVisible(
    Excel : Variant;
    IsVisible: Boolean): Boolean;

  {!~Saves the range on the currently active sheet
  to values only.}
  Function ExcelValuesOnly(
    Excel         : Variant;
    ExcelFirstRow : Integer;
    ExcelFirstCol : Integer;
    ExcelLastRow  : Integer;
    ExcelLastCol  : Integer): Boolean;

  {!~Returns the Excel Version as a ShortString.}
  Function ExcelVersion(Excel: Variant): ShortString;

  Function IsBlockColSide(
    Excel : Variant;
    RowNum: Integer;
    ColNum: Integer): Boolean; Forward;
    
  Function IsBlockRowSide(
    Excel : Variant;
    RowNum: Integer;
    ColNum: Integer): Boolean; Forward;


implementation

uses Ads_DB;

type
  //Declare the constants used by Excel
  SourceType = (xlConsolidation, xlDatabase, xlExternal, xlPivotTable);
  Orientation = (xlHidden, xlRowField, xlColumnField, xlPageField, xlDataField);
  RangeEnd = (NoValue, xlToLeft, xlToRight, xlUp, xlDown);
  ExcelPasteType = (xlAllExceptBorders,xlNotes,xlFormats,xlValues,xlFormulas,xlAll);

  {CAUTION!!! THESE OUTPUTS ARE ALL GARBLED!  YOU SELECT xlDBF3 AND EXCEL
  OUTPUTS A xlCSV.}
  FileFormat = (xlAddIn, xlCSV, xlCSVMac, xlCSVMSDOS, xlCSVWindows, xlDBF2,
                xlDBF3, xlDBF4, xlDIF, xlExcel2, xlExcel3, xlExcel4,
                xlExcel4Workbook, xlIntlAddIn, xlIntlMacro, xlNormal,
                xlSYLK, xlTemplate, xlText, xlTextMac, xlTextMSDOS,
                xlTextWindows, xlTextPrinter, xlWK1, xlWK3, xlWKS,
                xlWQ1, xlWK3FM3, xlWK1FMT, xlWK1ALL);

{Add a blank WorkSheet}
Function ExcelAddWorkSheet(Excel : Variant): Boolean;
Begin
  Result := True;
  Try
    Excel.Worksheets.Add;
  Except
    MessageDlg('Unable to add a new worksheet', mtError, [mbOK], 0);
    Result := False;
  End;
End;

{Sets Excel Visibility}
Function ExcelSetVisible(Excel : Variant;IsVisible: Boolean): Boolean;
Begin
  Result := True;
  Try
    Excel.Visible := IsVisible;
  Except
    MessageDlg('Unable to Excel Visibility', mtError, [mbOK], 0);
    Result := False;
  End;
End;

{Close Excel}
Function ExcelClose(Excel : Variant; SaveAll: Boolean): Boolean;
Begin
  Result := True;
  Try
    ExcelCloseWorkBooks(Excel, SaveAll);
    Excel.Quit;
  Except
    MessageDlg('Unable to Close Excel', mtError, [mbOK], 0);
    Result := False;
  End;
End;

{Close All Workbooks.  All workbooks can be saved or not.}
Function ExcelCloseWorkBooks(Excel : Variant; SaveAll: Boolean): Boolean;
var
  loop: byte;
Begin
  Result := True;
  Try
    For loop := 1 to Excel.Workbooks.Count Do
      Excel.Workbooks[1].Close[SaveAll];
  Except
    Result := False;
  End;
End;

{Selects an Excel Sheet By Name}
Function ExcelSelectSheetByName(Excel : Variant; SheetName: String): Boolean;
Begin
  Result := True;
  Try
    Excel.Sheets[SheetName].Select;
  Except
    Result := False;
  End;
End;

{Selects a cell on the currently active sheet}
Function ExcelSelectCell(Excel : Variant; RowNum, ColNum: Integer): Boolean;
Begin
  Result := True;
  Try
    Excel.ActiveSheet.Cells[RowNum, ColNum].Select;
  Except
    Result := False;
  End;
End;

{Returns the contents of a cell as a shortstring}
Function ExcelGetCellValue(Excel : Variant; RowNum, ColNum: Integer): ShortString;
Begin
  Result := '';
  Try
    Result := Excel.Cells[RowNum, ColNum].Value;
  Except
    Result := '';
  End;
End;

{Returns the the current row}
Function ExcelGetRow(Excel : Variant): Integer;
Begin
  Result := 1;
  Try
    Result := Excel.ActiveCell.Row;
  Except
    Result := 1;
  End;
End;

{Returns the the current column}
Function ExcelGetCol(Excel : Variant): Integer;
Begin
  Result := 1;
  Try
    Result := Excel.ActiveCell.Column;
  Except
    Result := 1;
  End;
End;

{Moves the cursor to the last column}
Function ExcelGoToLastCol(Excel : Variant): Boolean;
Begin
  Result := True;
  Try
    Excel.Selection.End[xlToRight].Select;
  Except
    Result := False;
  End;
End;

{Moves the cursor to the last row}
Function ExcelGoToLastRow(Excel : Variant): Boolean;
Begin
  Result := True;
  Try
    Excel.Selection.End[xlDown].Select;
  Except
    Result := False;
  End;
End;

{Moves the cursor to the Top row}
Function ExcelGoToTopRow(Excel : Variant): Boolean;
Begin
  Result := True;
  Try
    Excel.Selection.End[xlUp].Select;
  Except
    Result := False;
  End;
End;

{Moves the cursor to the Leftmost Column}
Function ExcelGoToLeftmostCol(Excel : Variant): Boolean;
Begin
  Result := True;
  Try
    Excel.Selection.End[xlToLeft].Select;
  Except
    Result := False;
  End;
End;

{Moves the cursor to Home position}
Function ExcelHome(Excel : Variant): Boolean;
Begin
  Result := True;
  Try
    Excel.ActiveSheet.Cells[1,1].Select;
  Except
    Result := False;
  End;
End;

{Moves the cursor to the last row and column}
Function ExcelEnd(Excel : Variant): Boolean;
Begin
  Result := True;
  Try
    Excel.Selection.End[xlDown].Select;
    Excel.Selection.End[xlToRight].Select;
  Except
    Result := False;
  End;
End;

{Returns The Last Column}
Function ExcelLastCol(Excel : Variant): Integer;
Var
  CurRow : Integer;
  CurCol : Integer;
Begin
  Result := 1;
  Try
    CurRow := Excel.ActiveCell.Row;
    CurCol := Excel.ActiveCell.Column;
    Result := CurCol;
    Excel.Selection.End[xlToRight].Select;
    Result := Excel.ActiveCell.Column;
    Excel.ActiveSheet.Cells[CurRow, CurCol].Select;
  Except
  End;
End;

{Returns The Last Row}
Function ExcelLastRow(Excel : Variant): Integer;
Var
  CurRow : Integer;
  CurCol : Integer;
Begin
  Result := 1;
  Try
    CurRow := Excel.ActiveCell.Row;
    CurCol := Excel.ActiveCell.Column;
    Result := CurRow;
    Excel.Selection.End[xlDown].Select;
    Result := Excel.ActiveCell.Row;
    Excel.ActiveSheet.Cells[CurRow, CurCol].Select;
  Except
  End;
End;

{Returns The First Row}
Function ExcelFirstRow(Excel : Variant): Integer;
Var
  CurRow : Integer;
  CurCol : Integer;
Begin
  Result := 1;
  Try
    CurRow := Excel.ActiveCell.Row;
    CurCol := Excel.ActiveCell.Column;
    Result := CurRow;
    Excel.Selection.End[xlUp].Select;
    Result := Excel.ActiveCell.Row;
    Excel.ActiveSheet.Cells[CurRow, CurCol].Select;
  Except
  End;
End;

{Returns The First Col}
Function ExcelFirstCol(Excel : Variant): Integer;
Var
  CurRow : Integer;
  CurCol : Integer;
Begin
  Result := 1;
  Try
    CurRow := Excel.ActiveCell.Row;
    CurCol := Excel.ActiveCell.Column;
    Result := CurRow;
    Excel.Selection.End[xlToLeft].Select;
    Result := Excel.ActiveCell.Column;
    Excel.ActiveSheet.Cells[CurRow, CurCol].Select;
  Except
  End;
End;

{Finds A value in a range and moves the cursor there.  If the value is
not found then the cursor does not move.  If nothing is found then
false is returned, True otherwise.}
Function ExcelFindValue(
  Excel       : Variant;
  FindString  : ShortString;
  TopRow      : Integer;
  LeftCol     : Integer;
  LastRow     : Integer;
  LastCol     : Integer;
  SearchRight : Boolean;
  SearchDown  : Boolean;
  RowsFirst   : Boolean
  ): Boolean;
Var
  CurRow    : Integer;
  CurCol    : Integer;
  TopRowN   : Integer;
  LeftColN  : Integer;
  LastRowN  : Integer;
  LastColN  : Integer;
  ColLoop   : Integer;
  RowLoop   : Integer;
  CellValue : ShortString;
  FoundRow  : Integer;
  FoundCol  : Integer;
  Found     : Boolean;
Begin
  Result := False;
  Try
    Found      := False;
    FindString := UpperCase(FindString);
    CurRow     := Excel.ActiveCell.Row;
    CurCol     := Excel.ActiveCell.Column;
    FoundRow   := CurRow;
    FoundCol   := CurCol;

    If SearchRight Then
    Begin
      LeftColN := LeftCol;
      LastColN := LastCol;
    End
    Else
    Begin
      LeftColN := LastCol;
      LastColN := LeftCol;
    End;

    If SearchDown Then
    Begin
      TopRowN  := TopRow;
      LastRowN := LastRow;
    End
    Else
    Begin
      TopRowN  := LastRow;
      LastRowN := TopRow;
    End;

    If RowsFirst Then
    Begin
      For ColLoop := LeftColN To LastColN Do
      Begin
        For RowLoop := TopRowN To LastRowN Do
        Begin
          CellValue := ExcelGetCellValue(Excel,RowLoop, ColLoop);
          If UpperCase(CellValue) = FindString Then
          Begin
            FoundRow := RowLoop;
            FoundCol := ColLoop;
            Found    := True;
            Break;
          End;
        End;
        If Found Then Break;
      End;
    End
    Else
    Begin
      For RowLoop := TopRowN To LastRowN Do
      Begin
        For ColLoop := LeftColN To LastColN Do
        Begin
          CellValue := ExcelGetCellValue(Excel,RowLoop, ColLoop);
          If UpperCase(CellValue) = FindString Then
          Begin
            FoundRow := RowLoop;
            FoundCol := ColLoop;
            Found    := True;
            Break;
          End;
        End;
        If Found Then Break;
      End;
    End;
    Excel.Cells[FoundRow, FoundCol].Activate;
    Result := Found;
  Except
    Result := False;
  End;
End;

{Finds A value in a range and moves the cursor there.  If the value is
not found then the cursor does not move.  If nothing is found then
false is returned, True otherwise.}
Function ExcelFindInRange(
  Excel       : Variant;
  FindString  : ShortString;
  TopRow      : Integer;
  LeftCol     : Integer;
  LastRow     : Integer;
  LastCol     : Integer): Boolean;
Begin
  Result :=
    ExcelFindValue(
      Excel,
      FindString,
      TopRow,
      LeftCol,
      LastRow,
      LastCol,
      True,
      True,
      True);
End;

{Finds A value and moves the cursor there.  If the value is
not found then the cursor does not move.  If nothing is found then
false is returned, True otherwise.}
Function ExcelFind(
  Excel       : Variant;
  FindString  : ShortString): Boolean;
Begin
  Result :=
    ExcelFindInRange(
      Excel,
      FindString,
      ExcelFirstRow(Excel),
      ExcelFirstCol(Excel),
      ExcelLastRow(Excel),
      ExcelLastCol(Excel));
End;

{!~Copies a range of Excel Cells to a Delphi StringGrid.  If successful
True is returned, False otherwise.  If SizeStringGridToFit is True
then the StringGrid is resized to be exactly the correct dimensions to
receive the input Excel cells, otherwise the StringGrid is not resized.
If ClearStringGridFirst is true then any cells outside the input range
are cleared, otherwise existing values are retained.  Please not that the
Excel cell coordinates are "1" based and the Delphi StringGrid coordinates
are zero based.}
Function ExcelCopyToStringGrid(
  Excel                 : Variant;
  ExcelFirstRow         : Integer;
  ExcelFirstCol         : Integer;
  ExcelLastRow          : Integer;
  ExcelLastCol          : Integer;
  StringGrid            : TStringGrid;
  StringGridFirstRow    : Integer;
  StringGridFirstCol    : Integer;
  SizeStringGridToFit   : Boolean; {Make the StringGrid the same size as the input range}
  ClearStringGridFirst  : Boolean  {cells outside input range in StringGrid are cleared}
  ): Boolean;
Var
  C,R : Integer;
Begin
  Result := False;
  If ExcelLastCol < ExcelFirstCol Then Exit;
  If ExcelLastRow < ExcelFirstRow Then Exit;
  If (ExcelFirstRow < 1) Or (ExcelFirstRow > 255)   Then Exit;
  If (ExcelFirstCol < 1) Or (ExcelFirstCol > 30000) Then Exit;
  If (ExcelLastRow  < 1) Or (ExcelLastRow > 255)    Then Exit;
  If (ExcelLastCol  < 1) Or (ExcelLastCol > 30000)  Then Exit;
  If StringGrid = nil   Then Exit;
  If SizeStringGridToFit Then
  Begin
    StringGrid.ColCount := ExcelLastCol - ExcelFirstCol + StringGridFirstCol + 1;
    StringGrid.RowCount := ExcelLastRow - ExcelFirstRow + StringGridFirstRow + 1;
  End;
  If ClearStringGridFirst Then
  Begin
    C := StringGrid.ColCount;
    R := StringGrid.RowCount;
    StringGrid.ColCount := 1;
    StringGrid.RowCount := 1;
    StringGrid.Cells[0,0] := '';
    StringGrid.ColCount := C;
    StringGrid.RowCount := R;
  End;

  Result := True;
  For R := ExcelFirstRow To ExcelLastRow Do
  Begin
    For C := ExcelFirstCol To ExcelLastCol Do
    Begin
      Try
        StringGrid.Cells[
          C - ExcelFirstCol + StringGridFirstCol,
          R - ExcelFirstRow + StringGridFirstRow] :=
            Excel.Cells[R, C];
      Except
        Result := False;
      End;
    End;
  End;
End;

{!~Sets the formula in a cell.  Remember to include the equals sign "=".
If the function fails False is returned, True otherwise.}
Function ExcelSetCellFormula(
  Excel         : Variant;
  FormulaString : ShortString;
  RowNum, ColNum: Integer): Boolean;
Begin
  Result := True;
  Try
    Excel.
      ActiveSheet.
        Cells[RowNum, ColNum].
          Formula := FormulaString;
  Except
    Result := False;
  End;
End;

{!~Returns the Column String Value from its integer equilavent.}
Function ExcelColIntToStr(ColNum: Integer): ShortString;
Var
  ColStr    : ShortString;
  Multiplier: Integer;
  Remainder : Integer;
Begin
  Result := '';
  If ColNum < 1   Then Exit;
  If ColNum > 256 Then Exit;
  Multiplier := ColNum div 26;
  Remainder  := ColNum Mod 26;
  If ColNum <= 26 Then
  Begin
    ColStr[1] := ' ';
    If Remainder = 0 Then
    Begin
      ColStr[2] := 'Z';
    End
    Else
    Begin
      ColStr[2] := Chr(Remainder+64);
    End;
  End
  Else
  Begin
    If Remainder = 0 Then
    Begin
      If Multiplier = 1 Then
      Begin
        ColStr[1] := ' ';
        ColStr[2] := 'Z';
      End
      Else
      Begin
        ColStr[1] := Chr(Multiplier+64-1);
        ColStr[2] := 'Z';
      End;
    End
    Else
    Begin
      ColStr[1] := Chr(Multiplier+64);
      ColStr[2] := Chr(Remainder+64);
    End;
  End;
  If ColStr[1] = ' ' Then
  Begin
    Result := Result + ColStr[2];
  End
  Else
  Begin
    Result := Result + ColStr[1] + ColStr[2];
  End;
  Result := Result;
End;

{!~Returns the Column Integer Value from its Alpha equilavent.}
Function ExcelColStrToInt(ColStr: ShortString): Integer;
Var
  ColStrNew  : ShortString;
  i          : Integer;
  RetVal     : Integer;
  Multiplier : Integer;
  Remainder  : Integer;
Begin
  RetVal := 1;
  Result := RetVal;
  ColStrNew := '';
  For i := 1 To Length(ColStr) Do
  Begin
    If ((Ord(ColStr[i]) >=  65)  And
       ( Ord(ColStr[i]) <=  90)) Or
       ((Ord(ColStr[i]) >=  97)  And
       ( Ord(ColStr[i]) <= 122)) Then
    Begin
      ColStrNew := ColStrNew + UpperCase(ColStr[i]);
    End;
  End;
  If Length(ColStrNew) < 1 Then Exit;
  If Length(ColStrNew) < 2 Then
  Begin
    RetVal := Ord(ColStrNew[1])-64;
  End
  Else
  Begin
    Multiplier := Ord(ColStrNew[1])-64;
    Remainder  := Ord(ColStrNew[2])-64;
    Retval     := (Multiplier * 26) + Remainder;
  End;
  Result := RetVal;
End;

{!~Sets the contents of a cell as a shortstring}
Function ExcelSetCellValue(
  Excel : Variant;
  RowNum, ColNum: Integer;
  Value : ShortString): Boolean;
Begin
  Result   := False;
  Try
    Excel.Cells[RowNum, ColNum].Value := Value;
    Result := True;
  Except
    Result := False;
  End;
End;

{!~Open the file you want to work within Excel.  If you want to
take advantage of optional parameters then you should use
ExcelOpenFileComplex}
Function ExcelOpenFile(Excel : Variant; FileName : String): Boolean;
Begin
  Result := True;
  try
    //Open the database that we want to work with
    Excel.Workbooks.Open[FileName];
  except
    MessageDlg('Unable to locate '+FileName, mtError, [mbOK], 0);
    Result := False;
  end;
End;

{!~Open the file you want to work within Excel.

Excel
  The OLEObject passed as an argument.

FileName
  Required. Specifies the filename of the workbook to open.

UpdateLinks
  Specifies how links in the file are updated. If this
  argument is omitted, the user is prompted to determine
  how to update links. Otherwise, this argument is one of
  the values shown in the following table.
  Value	Meaning
  0	No updates
  1	Updates external but not remote references
  2	Updates remote but not external references
  3	Updates both remote and external references

  If Microsoft Excel is opening a file in the WKS, WK1, or
  WK3 format and the updateLinks argument is 2, Microsoft
  Excel generates charts from the graphs attached to the file.
  If the argument is 0, no charts are created.

ReadOnly
  If True, the workbook is opened in read-only mode.

Format
  If Microsoft Excel is opening a text file, this argument
  specifies the delimiter character, as shown in the following
  table. If this argument is omitted, the current delimiter
  is used.

  Value	Delimiter
  1	Tabs
  2	Commas
  3	Spaces
  4	Semicolons
  5	Nothing
  6	Custom character, see the delimiter argument.

Password
  A string containing the password required to open a
  protected workbook. If omitted and the workbook requires
  a password, the user is prompted for the password.
}

Function ExcelOpenFileComplex(
  Excel        : Variant;
  FileName     : String;
  UpdateLinks  : Integer;
  ReadOnly     : Boolean;
  Format       : Integer;
  Password     : ShortString): Boolean;
Begin
  Result := True;
  try
    //Open the database that we want to work with
    Excel.
      Workbooks.
        Open[
          FileName,
          UpdateLinks,
          ReadOnly,
          Format,
          Password];
  except
    MessageDlg('Unable to locate '+FileName, mtError, [mbOK], 0);
    Result := False;
  end;
End;

{!~Saves the range on the currently active sheet
to a DBase 4 table.}
Function ExcelSaveAsDBase4(
  Excel         : Variant;
  ExcelFirstRow : Integer;
  ExcelFirstCol : Integer;
  ExcelLastRow  : Integer;
  ExcelLastCol  : Integer;
  OutFilePath   : ShortString;
  OutFileName   : ShortString): Boolean;
{
OutFileFormat: Use one of the following
xlAddIn      xlExcel3         xlTextMSDOS
xlCSV        xlExcel4         xlTextWindows
xlCSVMac     xlExcel4Workbook xlTextPrinter
xlCSVMSDOS   xlIntlAddIn      xlWK1
xlCSVWindows xlIntlMacro      xlWK3
xlDBF2       xlNormal         xlWKS
xlDBF3       xlSYLK           xlWQ1
xlDBF4       xlTemplate       xlWK3FM3
xlDIF        xlText           xlWK1FMT
xlExcel2     xlTextMac        xlWK1ALL
}
Begin
  Result := False;
  Try
    If IsTable(
         OutFilePath,
         OutFileName+'.dbf')
    Then
    Begin
      If Not DBDeleteTable(
               OutFilePath,
               OutFileName+'.dbf')
      Then
      Begin
        Msg('Could not delete the '+
             OutFilePath+OutFileName+'.dbf'+' Table');
        Msg('Process Aborted');
        Exit;
      End;
    End;
    If ExcelVersion(Excel) = '8.0' Then
    Begin
      ExcelSelectCell(Excel,ExcelFirstRow,ExcelFirstCol);
      ExcelSelectBlockWhole(Excel);
      //Excel.SendKeys('^+{END}');
    End
    Else
    Begin
      Excel.
        Range(
          ExcelColIntToStr(ExcelFirstCol)+
          IntToStr(ExcelFirstRow)+
          ':'+
          ExcelColIntToStr(ExcelLastCol)+
          IntToStr(ExcelLastRow)
              ).
          Select;
    End;
{
  FileFormat = (xlAddIn, xlCSV, xlCSVMac, xlCSVMSDOS, xlCSVWindows, xlDBF2,
                xlDBF3, xlDBF4, xlDIF, xlExcel2, xlExcel3, xlExcel4,
                xlExcel4Workbook, xlIntlAddIn, xlIntlMacro, xlNormal,
                xlSYLK, xlTemplate, xlText, xlTextMac, xlTextMSDOS,
                xlTextWindows, xlTextPrinter, xlWK1, xlWK3, xlWKS,
                xlWQ1, xlWK3FM3, xlWK1FMT, xlWK1ALL);
}
{
    //CHECKING OUT THE GARBLED OUTPUT
    //  Produces an *.xls
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'02',xlCSV);

    //  Produces an *.txt
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'04',xlCSVMSDOS);

    //  Produces nothing
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'05',xlCSVWindows);

    //  Produces nothing
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'06',xlDBF2);

    //  Produces an *.txt
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'07',xlDBF3);

    //  Produces an *.dbf
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'08',xlDBF4);
    //  Produces an *.dbf
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'09',xlDIF);
    //  Produces an *.dif
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'10',xlExcel2);
    //  Produces an *.slk
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'11',xlExcel3);
    //  Produces an *.dbf
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'12',xlExcel4);
}
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName,xlExcel4);
    Result := True;
  Except
    Result := False;
  End;
End;

{!~Saves the range on the currently active sheet
to a text file.}
Function ExcelSaveAsText(
  Excel         : Variant;
  ExcelFirstRow : Integer;
  ExcelFirstCol : Integer;
  ExcelLastRow  : Integer;
  ExcelLastCol  : Integer;
  OutFilePath   : ShortString;
  OutFileName   : ShortString): Boolean;
{
OutFileFormat: Use one of the following
xlAddIn      xlExcel3         xlTextMSDOS
xlCSV        xlExcel4         xlTextWindows
xlCSVMac     xlExcel4Workbook xlTextPrinter
xlCSVMSDOS   xlIntlAddIn      xlWK1
xlCSVWindows xlIntlMacro      xlWK3
xlDBF2       xlNormal         xlWKS
xlDBF3       xlSYLK           xlWQ1
xlDBF4       xlTemplate       xlWK3FM3
xlDIF        xlText           xlWK1FMT
xlExcel2     xlTextMac        xlWK1ALL
}
Var
  FullOutName : String;
Begin
  Result := False;
  Try
    If OutFilePath <> '' Then
    Begin
      If Not (Copy(OutFilePath,Length(OutFilePath),1) = '\') Then
      Begin
        OutFilePath := OutFilePath + '\';
      End;
    End;
    FullOutName := OutFilePath + OutFileName;
    If FileExists(FullOutName) Then DeleteFile(FullOutName);

    If ExcelVersion(Excel) = '8.0' Then
    Begin
      ExcelSelectCell(Excel,ExcelFirstRow,ExcelFirstCol);
      ExcelSelectBlockWhole(Excel);
      //Excel.SendKeys('^+{END}');
    End
    Else
    Begin
      Excel.
        Range(
          ExcelColIntToStr(ExcelFirstCol)+
          IntToStr(ExcelFirstRow)+
          ':'+
          ExcelColIntToStr(ExcelLastCol)+
          IntToStr(ExcelLastRow)
              ).
          Select;
    End;
{
  FileFormat = (xlAddIn, xlCSV, xlCSVMac, xlCSVMSDOS, xlCSVWindows, xlDBF2,
                xlDBF3, xlDBF4, xlDIF, xlExcel2, xlExcel3, xlExcel4,
                xlExcel4Workbook, xlIntlAddIn, xlIntlMacro, xlNormal,
                xlSYLK, xlTemplate, xlText, xlTextMac, xlTextMSDOS,
                xlTextWindows, xlTextPrinter, xlWK1, xlWK3, xlWKS,
                xlWQ1, xlWK3FM3, xlWK1FMT, xlWK1ALL);
}
(*
    //CHECKING OUT THE GARBLED OUTPUT
    //  Produces an *.xls
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'02',xlCSV);
*)
    //  Produces an *.txt
//    Excel.
//      ActiveSheet.
//      SaveAs(
//        FullOutName,xlCSVMSDOS);
(*
    //  Produces nothing
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'05',xlCSVWindows);

    //  Produces nothing
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'06',xlDBF2);

    //  Produces an *.txt comma separated
    Excel.
      ActiveSheet.
      SaveAs(
        FullOutName,xlDBF3);
*)
    //  Produces an *.txt 
    Excel.
      ActiveSheet.
      SaveAs(
        FullOutName,xlTextMSDOS);
(*
    //  Produces an *.dbf
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'08',xlDBF4);
    //  Produces an *.dbf
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'09',xlDIF);
    //  Produces an *.dif
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'10',xlExcel2);
    //  Produces an *.slk
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'11',xlExcel3);
    //  Produces an *.dbf
    Excel.
      ActiveSheet.
      SaveAs(
        OutFilePath+OutFileName+'12',xlExcel4);

*)
    Result := True;
  Except
    Result := False;
  End;
End;



{!~Saves the range on the currently active sheet
to to values only.}
Function ExcelPasteValuesOnly(
  Excel         : Variant;
  ExcelFirstRow : Integer;
  ExcelFirstCol : Integer;
  ExcelLastRow  : Integer;
  ExcelLastCol  : Integer): Boolean;
Var
  RangeString : ShortString;
  SheetName   : ShortString;
  SheetTemp   : ShortString;
Begin
  Result := True;
  try
    If ExcelVersion(Excel) = '8.0' Then
    Begin
      If Not ExcelSelectRange(
               Excel,
               ExcelFirstRow,
               ExcelFirstCol,
               ExcelLastRow,
               ExcelLastCol)
      Then
      Begin
        Result := False;
        Msg('Unable to select the range to paste as values.');
        Exit;
      End;
      Excel.Selection.Copy;
      Excel.Selection.PasteSpecial(xlValues);
      Excel.Application.CutCopyMode := False;
    End
    Else
    Begin
      Excel.Range(
        ExcelColIntToStr(ExcelFirstCol)+IntToStr(ExcelFirstRow)+
        ':'+
        ExcelColIntToStr(ExcelLastCol)+IntToStr(ExcelLastRow)).Select;
      Excel.Selection.Copy;
      Excel.Selection.PasteSpecial(xlValues);
      Excel.Application.CutCopyMode := False;
      Excel.Selection.Replace('#N/A','0');
    End;
  except
    Msg('Unable to paste range as values');
    Result := False;
  end;
End;

{!~Sets a Column Width on the currently active sheet}
Function ExcelSetColumnWidth(Excel : Variant; ColNum, ColumnWidth: Integer): Boolean;
Var
  RowWas : Integer;
  ColWas : Integer;
Begin
  Result := False;
  Try
    RowWas := ExcelGetRow(Excel);
    ColWas := ExcelGetCol(Excel);
    ExcelSelectCell(Excel,1,ColNum);
    Excel.Selection.ColumnWidth := ColumnWidth;
    ExcelSelectCell(Excel,RowWas,ColWas);
    Result := True;
  Except
    Result := False;
  End;
End;

{!~Selects a range on the currently active sheet}
Function ExcelSelectRange(
    Excel    : Variant;
    FirstRow : Integer;
    FirstCol : Integer;
    LastRow  : Integer;
    LastCol  : Integer): Boolean;
Var
  r,c : Integer;
  RowString : ShortString;
  ColString : ShortString;
Begin
  Result := False;
  Try
    If FirstRow <   1 Then Exit;
    If FirstCol <   1 Then Exit;
    If LastRow  <   1 Then Exit;
    If LastCol  <   1 Then Exit;
    If FirstCol > 255 Then Exit;
    If LastCol  > 255 Then Exit;

    If Not ExcelSelectCell(
             Excel,
             FirstRow,
             FirstCol)
    Then
    Begin
      Exit;
    End;
    {Check for strange number combinations}
    If FirstRow = LastRow Then
    Begin
      {Don't need to do anything}
    End
    Else
    Begin
      If FirstRow < LastRow Then
      Begin
        For r := FirstRow To LastRow - 1 Do
        Begin
          Excel.SendKeys('+{DOWN}');
        End;
      End
      Else
      Begin
        For r := LastRow To FirstRow - 1 Do
        Begin
          Excel.SendKeys('+{UP}');
        End;
      End;
    End;
    If FirstCol = LastCol Then
    Begin
      {Don't need to do anything}
    End
    Else
    Begin
      If FirstCol < LastCol Then
      Begin
        For c := FirstCol To LastCol - 1 Do
        Begin
          Excel.SendKeys('+{RIGHT}');
        End;
      End
      Else
      Begin
        For c := LastCol To FirstCol - 1 Do
        Begin
          Excel.SendKeys('+{LEFT}');
        End;
      End;
    End;
    Result := True;
  Except
    Result := False;
  End;
End;

{!~Selects a range on the currently active sheet.  From the
current cursor position a block is selected down and to the right.
The block proceeds down until an empty row is encountered.  The
block proceeds right until an empty column is encountered.}
Function ExcelSelectBlock(
    Excel    : Variant;
    FirstRow : Integer;
    FirstCol : Integer): Boolean;
Begin
  Result := False;
  Try
    ExcelSelectCell(Excel,FirstRow,FirstCol);
    Excel.SendKeys('+{END}+{RIGHT}');
    Excel.SendKeys('+{END}+{DOWN}');
    Result := True;
  Except
    Result := False;
  End;
End;

{!~Selects a range on the currently active sheet.  From the
current cursor position a block is selected that contains
the currently active cell.  The block proceeds in each
direction until an empty row or column is encountered.}
Function ExcelSelectBlockWhole(Excel: Variant): Boolean;
Var
  FirstRow : Integer;
  FirstCol : Integer;
  LastRow  : Integer;
  LastCol  : Integer;
  RowWas   : Integer;
  ColWas   : Integer;
Begin
  Result   := False;
  Try
    RowWas   := ExcelGetRow(Excel);
    ColWas   := ExcelGetCol(Excel);

    {If the base cell is on a side of the block, the block
    will not be created properly.}

    {View From Original Cell}
    FirstRow := ExcelFirstRow(Excel);
    FirstCol := ExcelFirstCol(Excel);
    LastRow  := ExcelLastRow(Excel);
    LastCol  := ExcelLastCol(Excel);
    If (Not IsBlockColSide(Excel,RowWas,ColWas)) And
       (Not IsBlockRowSide(Excel,RowWas,ColWas)) Then
    Begin
      {Cell is not on a side of the block}
      ExcelSelectCell(Excel,FirstRow,FirstCol);
      Excel.SendKeys('+{END}+{RIGHT}');
      Excel.SendKeys('+{END}+{DOWN}');
      Result := True;
      Exit;
    End;
    {Row Only problem}
    If (Not IsBlockColSide(Excel,RowWas,ColWas)) And
       (IsBlockRowSide(Excel,RowWas,ColWas)) Then
    Begin
      {DEFAULT TO ASSUMING SELECTED CELLS ARE NEAR TOP LEFT AND
      BLOCK IS TOWARD BOTTOM RIGHT}
      ExcelSelectCell(Excel,RowWas,FirstCol);
      Excel.SendKeys('+{END}+{RIGHT}');
      Excel.SendKeys('+{END}+{DOWN}');
      Result := True;
      Exit;
    End;
    {Column Only problem}
    If (IsBlockColSide(Excel,RowWas,ColWas)) And
       (Not IsBlockRowSide(Excel,RowWas,ColWas)) Then
    Begin
      {DEFAULT TO ASSUMING SELECTED CELLS ARE NEAR TOP LEFT AND
      BLOCK IS TOWARD BOTTOM RIGHT}
      ExcelSelectCell(Excel,FirstRow,ColWas);
      Excel.SendKeys('+{END}+{RIGHT}');
      Excel.SendKeys('+{END}+{DOWN}');
      Result := True;
      Exit;
    End;
    {DEFAULT TO ASSUMING SELECTED CELLS ARE NEAR TOP LEFT AND
    BLOCK IS TOWARD BOTTOM RIGHT}
    ExcelSelectCell(Excel,RowWas,ColWas);
    Excel.SendKeys('+{END}+{RIGHT}');
    Excel.SendKeys('+{END}+{DOWN}');
    Result := True;
  Except
    Result := False;
  End;
End;

Function IsBlockColSide(Excel : Variant; RowNum, ColNum: Integer): Boolean;
Var
  RowWas            : Integer;
  ColWas            : Integer;
  CellFirstSide     : Integer;
  CellLastSide      : Integer;
  FirstSideLastSide : Integer;
  LastSideFirstSide : Integer;
Begin
  ExcelSelectCell(Excel,RowNum,ColNum);
  CellFirstSide := ExcelFirstCol(Excel);
  CellLastSide  := ExcelLastCol(Excel);
  ExcelSelectCell(Excel,RowNum,CellFirstSide);
  FirstSideLastSide := ExcelLastCol(Excel);
  ExcelSelectCell(Excel,RowNum,CellLastSide);
  LastSideFirstSide := ExcelFirstCol(Excel);
  ExcelSelectCell(Excel,RowNum,ColNum);
  If (LastSideFirstSide = ColNum) Or
     (FirstSideLastSide = ColNum) Then
  Begin
    Result := True;
  End
  Else
  Begin
    Result := False;
  End;
End;

Function IsBlockRowSide(Excel : Variant; RowNum, ColNum: Integer): Boolean;
Var
  RowWas            : Integer;
  ColWas            : Integer;
  CellFirstSide     : Integer;
  CellLastSide      : Integer;
  FirstSideLastSide : Integer;
  LastSideFirstSide : Integer;
Begin
  ExcelSelectCell(Excel,RowNum,ColNum);
  CellFirstSide := ExcelFirstRow(Excel);
  CellLastSide  := ExcelLastRow(Excel);
  ExcelSelectCell(Excel,CellFirstSide,ColNum);
  FirstSideLastSide := ExcelLastRow(Excel);
  ExcelSelectCell(Excel,CellLastSide,ColNum);
  LastSideFirstSide := ExcelFirstRow(Excel);
  ExcelSelectCell(Excel,RowNum,ColNum);
  If (LastSideFirstSide = RowNum) Or
     (FirstSideLastSide = RowNum) Then
  Begin
    Result := True;
  End
  Else
  Begin
    Result := False;
  End;
End;

{!~Renames a worksheet.}
Function ExcelRenameSheet(
  Excel         : Variant;
  OldName       : ShortString;
  NewName       : ShortString): Boolean;
Begin
  Result := False;
  Try
    Excel.Sheets(OldName).Name := NewName;
    Result := True;
  Except
    Result := False;
  End;
End;

{!~Delete a WorkSheet by Name}
Function ExcelDeleteWorkSheet(
  Excel     : Variant;
  SheetName : ShortString): Boolean;
Begin
  Result := False;
  Try
    If Not ExcelSelectSheetByName(Excel,SheetName) Then
    Begin
      Msg('Could not select the '+SheetName+' WorkSheet');
      Exit;
    End;
    Excel.ActiveWindow.SelectedSheets.Delete;
    Result := True;
  Finally
    Result := False;
  End;
End;

{!~Returns the name of the currently active worksheet
as a shortstring}
Function ExcelGetActiveSheetName(Excel : Variant): ShortString;
Begin
  Result := '';
  Try
    Result := Excel.ActiveSheet.Name;
  Except
    Result := '';
  End;
End;

{!~Saves the range on the currently active sheet
to values only.}
Function ExcelValuesOnly(
  Excel         : Variant;
  ExcelFirstRow : Integer;
  ExcelFirstCol : Integer;
  ExcelLastRow  : Integer;
  ExcelLastCol  : Integer): Boolean;
Var
  r,c : Integer;
  s   : ShortString;
Begin
  Result := False;
  Try
    If ExcelVersion(Excel) = '8.0' Then
    Begin
      For r := ExcelFirstRow To ExcelLastRow Do
      Begin
        For c := ExcelFirstCol To ExcelLastCol Do
        Begin
          s := Excel.Cells[r,c].Value;
          Excel.Cells[r, c].Value := s;
        End;
      End;
    End
    Else
    Begin
      ExcelPasteValuesOnly(
        Excel,
        ExcelFirstRow,
        ExcelFirstCol,
        ExcelLastRow,
        ExcelLastCol);
    End;
    Result := True;;
  Except
    Result := False;
  End;
End;

{!~Gets the formula in a cell.}
Function ExcelGetCellFormula(
  Excel         : Variant;
  RowNum, ColNum: Integer): ShortString;
Begin
  Result := ' ';
  Try
    Result := Excel.
                ActiveSheet.
                Cells[RowNum, ColNum].
                Formula;
  Except
    Result := ' ';
  End;
End;

{!~Returns the Excel Version as a ShortString.}
Function ExcelVersion(Excel: Variant): ShortString;
Var
  Version : ShortString;
Begin
  Result := '';
  Try
    Version := Excel.Version;
    Result := Version;
  Except
    Result := '';
  End;
End;

Initialization
  DelphiChecker(
    RunOutsideIDE_ads,
    'Advanced Delphi Systems Code',
    RunOutsideIDECompany_ads,
    RunOutsideIDEPhone_ads,
    RunOutsideIDEDate_ads);
End.
{</PRE></BODY></HTML>}
