unit UtilityFunctions;

interface

{UtilityFunctions defines a number of commonly used functions that are
 called from a variety of different units.}

uses Windows, Messages, SysUtils, Classes, stdctrls, Graphics, AnePIE;

function GetLayerHandle(const funHandle : ANE_PTR; const LayerName : string) : ANE_PTR;

function UGetParameterIndex(const aneHandle : ANE_PTR;
  const layerHandle : ANE_PTR; const parameterName : String): ANE_INT32;

function ULayerRename(const aneHandle : ANE_PTR; const layerHandle : ANE_PTR;
         const newName : string ) : ANE_BOOL;

function URenameParameter(const aneHandle : ANE_PTR;
  const layerHandle : ANE_PTR; const parameterIndex : ANE_INT32;
  const newParameterName : String): ANE_BOOL;

procedure USetParameterExpression(const aneHandle: ANE_PTR;
  const layerHandle: ANE_PTR; const parameterIndex: ANE_INT32;
  const newParameterExpression: string);

function GetDllFullPath(FileName :string ; var FullPath : String) : boolean ;
// GetDllFullPath is used to determine the full file path of a running dll
//  at runtime.
//  FileName is the name of the dll file without the path.
//  FullPath is the name of the dll file with the path.
//  GetDllFullPath returns true if the function succeeds.
// The full path may be up to 1024 characters in length.

function GetDllDirectory(FileName :string ;
  var DllDirectory : String) : boolean ;
// GetDllDirectory is used to determine the directory containing a running dll
//  at runtime.
//  FileName is the name of the dll file without the path.
//  DllDirectory is the name of the directory containing the dll with
//   no terminating slash.
//  GetDllDirectory returns true if the function succeeds.
// The directory name may be up to 1024 characters in length minus
//  (the length of the file name plus one).

function GetDLLName : string;
// GetDLLName returns the name of the DLL that calls it.

Function EvalIntegerByLayerHandle(const aneHandle, LayerHandle : ANE_PTR;
         StringToEvaluate : string) : integer;

Function EvalIntegerByLayerName(const aneHandle : ANE_PTR;
         const LayerName : string; var LayerHandle : ANE_PTR;
         StringToEvaluate : string) : integer;

Function EvalDoubleByLayerHandle(const aneHandle, LayerHandle : ANE_PTR;
         StringToEvaluate : string) : ANE_DOUBLE;

Function EvalDoubleByLayerName(const aneHandle : ANE_PTR;
         const LayerName : string; var LayerHandle : ANE_PTR;
         StringToEvaluate : string) : ANE_DOUBLE;

Procedure GetNumRowsCols(const CurrentModelHandle : ANE_PTR;
  const LayerName : string; var NRow, NCol : ANE_INT32); overload;

Procedure GetNumRowsCols(const CurrentModelHandle, LayerHandle : ANE_PTR;
  var NRow, NCol : ANE_INT32); overload;

procedure GetGridWithLayerHandle(const CurrentModelHandle : ANE_PTR;
  const LayerHandle : ANE_PTR; var NRow, NCol : ANE_INT32;
  var MinX, MaxX, MinY, MaxY, GridAngle : ANE_DOUBLE);

procedure GetGrid(const CurrentModelHandle : ANE_PTR; const LayerName : string;
  var LayerHandle : ANE_PTR; var NRow, NCol : ANE_INT32;
  var MinX, MaxX, MinY, MaxY, GridAngle : ANE_DOUBLE);

Procedure GetGridDirection (const CurrentModelHandle : ANE_PTR;
  const LayerName : string;
  Var RowDirectionPositive, ColDirectionPositive : Boolean);

Procedure GetGridAngle(const CurrentModelHandle : ANE_PTR;
  const LayerName : string; var LayerHandle : ANE_PTR ;
  var GridAngle : ANE_DOUBLE);

procedure RotatePointsToGrid(var X, Y : double; GridAngle : double);
// Transform the locations of X and Y so that they are in the same
// coordinate system as the grid.

procedure RotatePointsFromGrid(var X, Y : double; GridAngle : double);
// Transform the locations of X and Y from the grid coordinate system to the
// model coordinate system .

function InternationalStrToFloat(Value : string) : extended;
function InternationalFloatToStr(Value : extended) : string;
Function FracToRainbow(Fraction : double) : TColor;
function ShowHiddenFunctions: boolean;
function FortranStrToFloat(AString : string) : double;

function GetBlockIndex(RowIndex, ColIndex: integer; const NROW, NCOL: integer;
  const RowsReversed, ColsReversed: boolean): integer;
// RowIndex and ColIndex are the row and column numbers of the block
// 1 <= RowIndex <= NROW
// 1 <= ColIndex <= NCOL
// RowsReversed and ColsReversed tell whether the row and/or column numbering
// is reversed.

// procedure SetComboDropDownWidth(ComboBox: TComboBox; Width: Integer = -1);

function GetArgusStr(const List: TStrings): string;

// (X,Y) indicates the location of a point.
//  XCoord and YCoord contain the X and Y coordinates of a series of points
// that define a closed polygon.
// IsClosed should be set to true if the first and last points in
// XCoord and YCoord are the same.
// IsClosed should be set to False if the first and last points in
// XCoord and YCoord are different but the final edge of the polygon
// should be defined by a line connecting the first and last points.
// PointInside returns true if (X,Y) are inside the polygon.
function PointInside(const X, Y: double; XCoord: array of double;
  YCoord: array of Double; const IsClosed: boolean): boolean;

function Distance(const X1, Y1, X2, Y2: double): double; overload;
function Distance(const X1, Y1, Z1, X2, Y2, Z2: double): double; overload;

function Interpolate(const Lower, Upper, Fraction: double): double;

function AppDataFolderPath(Handle: HWnd): string;
function DllAppDirectory(Handle: HWnd; DLLName: string): string;
procedure CreateDirectoryAndParents(DirName: string);

implementation

uses ShlObj, FileCtrl, ANECB;

procedure USetParameterExpression(const aneHandle: ANE_PTR;
  const layerHandle: ANE_PTR; const parameterIndex: ANE_INT32;
  const newParameterExpression: string);
var
  NewExpression_Str : ANE_STR;
begin
  GetMem(NewExpression_Str, Length(newParameterExpression) + 1);
  try
    StrPCopy(NewExpression_Str,newParameterExpression);
    ANE_LayerSetParameterExpression(aneHandle, layerHandle, parameterIndex,
      NewExpression_Str);
    ANE_ProcessEvents(aneHandle);
  finally
    FreeMem(NewExpression_Str);
  end;
end;

function URenameParameter(const aneHandle : ANE_PTR;
  const layerHandle : ANE_PTR; const parameterIndex : ANE_INT32;
  const newParameterName : String): ANE_BOOL;
var
  NewName_Str : ANE_STR;
begin
  GetMem(NewName_Str, Length(newParameterName) + 1);
  try
    StrPCopy(NewName_Str,newParameterName);
    result := ANE_LayerRenameParameter(aneHandle, layerHandle, parameterIndex,
      NewName_Str);
    ANE_ProcessEvents(aneHandle);
  finally
    FreeMem(NewName_Str);
  end;
end;


function ULayerRename(const aneHandle : ANE_PTR; const layerHandle : ANE_PTR;
         const newName : string ) : ANE_BOOL;
var
  NewName_Str : ANE_STR;
begin
  GetMem(NewName_Str, Length(newName) + 1);
  try
    StrPCopy(NewName_Str,newName);
    result := ANE_LayerRename(aneHandle, layerHandle, NewName_Str);
    ANE_ProcessEvents(aneHandle);
  finally
    FreeMem(NewName_Str);
  end;
end;

function UGetParameterIndex(const aneHandle : ANE_PTR;
  const layerHandle : ANE_PTR; const parameterName : String): ANE_INT32;
var
  ANE_ParameterNameStr : ANE_STR;
begin
  GetMem(ANE_ParameterNameStr, Length(parameterName) + 1);
  try
    StrPCopy(ANE_ParameterNameStr,parameterName);
    result := ANE_LayerGetParameterByName(aneHandle, layerHandle,
      ANE_ParameterNameStr);
    ANE_ProcessEvents(aneHandle);
  finally
    FreeMem(ANE_ParameterNameStr);
  end;
end;

function GetLayerHandle(const funHandle : ANE_PTR; const LayerName : string) : ANE_PTR;
var
  ANE_LayerNameStr : ANE_STR;
begin
  GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
  try
    StrPCopy(ANE_LayerNameStr,LayerName);
    result := ANE_LayerGetHandleByName(funHandle, ANE_LayerNameStr);
    ANE_ProcessEvents(funHandle);
  finally
    FreeMem(ANE_LayerNameStr);
  end;
end;
{
Procedure ProcessEvents(CurrentModelHandle : ANE_PTR);
begin
  ANE_ProcessEvents(CurrentModelHandle);
end;
}

// GetDllFullPath attempts to retrieve the full path of a dll given only its
// file name.  It returns True if it suceeds and false if it fails.
// The path of the dll is returned through the variable FullPath.
function GetDllFullPath(FileName :string ; var FullPath : String) : boolean ;
var
  AHandle : HWND;
  ModuleFileName : array[0..255] of char;
begin
  FullPath := '';
  AHandle := GetModuleHandle(PChar(FileName))  ;
  if AHandle = 0 then
  begin
    Result := False;
  end
  else
  begin
    if (GetModuleFileName(AHandle, @ModuleFileName[0],
       SizeOf(ModuleFileName)) > 0) then
    begin
      FullPath := ModuleFileName;
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;
end;
{function GetDllFullPath(FileName :string ; var FullPath : String) : boolean ;
var
  Index : integer;
   buf : PChar ;
   bufLen : Integer;
   AString : string;
   AHandle : HWND;
begin
      FullPath := '';
      AHandle := GetModuleHandle(PChar(FileName))  ;
      if AHandle = 0
      then
        begin
          Result := False;
        end
      else
        begin
          AString := '1';
          For Index := 1 to 10 do
          begin
            AString := AString + AString;
          end;
          buf := PChar(AString);
          bufLen := Length(AString);
          if (GetModuleFileName(AHandle, buf, bufLen) > 0)
          then
            begin
              FullPath := String(buf);
              Result := True;
            end
          else
            begin
              Result := False;
            end;
        end;

end;}

function GetDllDirectory(FileName :string ;
  var DllDirectory : String) : boolean ;
begin
  result :=  GetDllFullPath(FileName ,  DllDirectory );
  DllDirectory := ExtractFileDir(DllDirectory);
end;

function GetDLLName : string;
var
    FileCheck: array[0..255] of char;
begin
  GetModuleFileName(HInstance, Filecheck, 255);
  result := String(Filecheck)
end;

Function EvalIntegerByLayerHandle(const aneHandle, LayerHandle : ANE_PTR;
         StringToEvaluate : string) : ANE_INT32;
var
  STR : ANE_STR;
begin
  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(aneHandle,LayerHandle,kPIEInteger,
       STR,@result );
    ANE_ProcessEvents(aneHandle);
  finally
    FreeMem(STR);
  end;
end;

Function EvalIntegerByLayerName(const aneHandle : ANE_PTR;
         const LayerName : string; var LayerHandle : ANE_PTR;
         StringToEvaluate : string) : ANE_INT32;
begin
  LayerHandle := GetLayerHandle(anehandle, LayerName);
  result := EvalIntegerByLayerHandle(aneHandle, LayerHandle, StringToEvaluate);
end;

Function EvalDoubleByLayerHandle(const aneHandle, LayerHandle : ANE_PTR;
         StringToEvaluate : string) : ANE_DOUBLE;
var
  STR : ANE_STR;
begin
  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(aneHandle,LayerHandle,kPIEFloat,
       STR,@result );
    ANE_ProcessEvents(aneHandle);
  finally
    FreeMem(STR);
  end;
end;

Function EvalDoubleByLayerName(const aneHandle : ANE_PTR;
         const LayerName : string; var LayerHandle : ANE_PTR;
         StringToEvaluate : string) : ANE_DOUBLE;
begin
  LayerHandle := GetLayerHandle(anehandle, LayerName);
  result := EvalDoubleByLayerHandle(aneHandle, LayerHandle, StringToEvaluate);
end;

{Procedure GetNumRowsCols(const CurrentModelHandle, ANE_PTR;
  const LayerName : string; var NRow, NCol : ANE_INT32);
//var
//  LayerHandle : ANE_PTR;
begin
//  LayerHandle := GetLayerHandle(CurrentModelHandle, LayerName);
//  GetNumRowsCols(CurrentModelHandle, LayerHandle, NRow, NCol);
end; }

Procedure GetNumRowsCols(const CurrentModelHandle : ANE_PTR;
  const LayerName : string; var NRow, NCol : ANE_INT32);
var
  LayerHandle : ANE_PTR;
begin
  LayerHandle := GetLayerHandle(CurrentModelHandle, LayerName);
  GetNumRowsCols(CurrentModelHandle, LayerHandle, NRow, NCol);
end;


Procedure GetNumRowsCols(const CurrentModelHandle, LayerHandle : ANE_PTR;
  var NRow, NCol : ANE_INT32); 
var
  StringToEvaluate : PChar;  
begin
  StringToEvaluate := 'NumRows()';
  NRow := EvalIntegerByLayerHandle(CurrentModelHandle, LayerHandle,
    StringToEvaluate);

  StringToEvaluate := 'NumColumns()';
  NCol := EvalIntegerByLayerHandle(CurrentModelHandle, LayerHandle,
    StringToEvaluate);
end;

procedure GetGridWithLayerHandle(const CurrentModelHandle : ANE_PTR;
  const LayerHandle : ANE_PTR; var NRow, NCol : ANE_INT32;
  var MinX, MaxX, MinY, MaxY, GridAngle : ANE_DOUBLE);
var
  StringToEvaluate : string;
begin
  StringToEvaluate := 'NumRows()';
  NRow := EvalIntegerByLayerHandle(CurrentModelHandle,
    LayerHandle,StringToEvaluate);

  StringToEvaluate := 'NumColumns()';
  NCol := EvalIntegerByLayerHandle(CurrentModelHandle,
    LayerHandle,StringToEvaluate);

  StringtoEvaluate := 'NthColumnPos(0)' ;
  MinX := EvalDoubleByLayerHandle(CurrentModelHandle,
    LayerHandle,StringToEvaluate);

  StringtoEvaluate := 'NthColumnPos(' + IntToStr(NCol) + ')' ;
  MaxX := EvalDoubleByLayerHandle(CurrentModelHandle,
    LayerHandle,StringToEvaluate);

  StringtoEvaluate := 'NthRowPos(0)' ;
  MinY := EvalDoubleByLayerHandle(CurrentModelHandle,
    LayerHandle,StringToEvaluate);

  StringtoEvaluate := 'NthRowPos(' + IntToStr(NRow) + ')' ;
  MaxY := EvalDoubleByLayerHandle(CurrentModelHandle,
    LayerHandle,StringToEvaluate);

  StringtoEvaluate := 'If(IsNA(GridAngle()), 0.0, GridAngle())';
  GridAngle := EvalDoubleByLayerHandle(CurrentModelHandle,
    LayerHandle,StringToEvaluate);

end;

procedure GetGrid(const CurrentModelHandle : ANE_PTR; const LayerName : string;
  var LayerHandle : ANE_PTR; var NRow, NCol : ANE_INT32;
  var MinX, MaxX, MinY, MaxY, GridAngle : ANE_DOUBLE);
begin
  LayerHandle := GetLayerHandle(CurrentModelHandle, LayerName);
  GetGridWithLayerHandle(CurrentModelHandle, LayerHandle, NRow, NCol,
    MinX, MaxX, MinY, MaxY, GridAngle);
end;

Procedure GetGridDirection (const CurrentModelHandle : ANE_PTR;
  const LayerName : string;
  Var RowDirectionPositive, ColDirectionPositive : Boolean);
var
  LayerHandle : ANE_PTR;
  NRow, NCol : ANE_INT32;
  MinX, MaxX, MinY, MaxY, GridAngle : ANE_DOUBLE;
begin
  GetGrid(CurrentModelHandle, LayerName, LayerHandle, NRow, NCol,
    MinX, MaxX, MinY, MaxY, GridAngle);

  RowDirectionPositive := (MaxY > MinY);
  ColDirectionPositive := (MaxX > MinX);
end;

Procedure GetGridAngle(const CurrentModelHandle : ANE_PTR;
  const LayerName : string; var LayerHandle : ANE_PTR ;
  var GridAngle : ANE_DOUBLE);
var
  StringtoEvaluate : String;

begin
  StringtoEvaluate := 'If(IsNA(GridAngle()), 0.0, GridAngle())';
  GridAngle := EvalDoubleByLayerName(CurrentModelHandle,LayerName,
    LayerHandle,StringToEvaluate);

end;

procedure RotatePointsToGrid(var X, Y : double; GridAngle: double );
var
  PointDistance, PointAngle : double;
begin
  If GridAngle = 0 then Exit;
  if (X = 0) then
  begin
    PointDistance := Y;
    If Y > 0 then
    begin
      PointAngle := -Pi/2;
    end
    else
    begin
      PointAngle := Pi/2;
    end;
  end
  else
  begin
    PointDistance := Sqrt(Sqr(X) + Sqr(Y));
    PointAngle := ArcTan(Y/X);
    if X < 0 then
    begin
      PointAngle := PointAngle - Pi ;
    end;
  end;
  // Rotate by Grid Angle
  PointAngle := PointAngle - GridAngle;
  If PointAngle < Pi then
  begin
    PointAngle := PointAngle + 2*Pi;
  end;
  // Convert rotated coordinates back to cartesian coordinates.
  X := PointDistance * Cos(PointAngle);
  Y := PointDistance * Sin(PointAngle);

end;

procedure RotatePointsFromGrid(var X, Y : double; GridAngle : double);
begin
  if GridAngle = 0 then Exit;
  GridAngle := - GridAngle;
  RotatePointsToGrid(X,Y,GridAngle);
end;

function InternationalFloatToStr(Value : extended) : string;
var
  DecPos : integer;
begin
  result := FloatToStr(Value);
  if DecimalSeparator <> '.' then
  begin
    DecPos := Pos(DecimalSeparator,result);
    if DecPos > 0 then
    begin
      result[DecPos] := '.';
    end;
  end;
end;

function InternationalStrToFloat(Value : string) : extended;
var
  DecimalLocation : integer;
  CommaSeparator : array[0..255] of Char;
begin

  GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SDECIMAL,@CommaSeparator,255);
  if String(CommaSeparator) = '.' then
  begin
    DecimalLocation := Pos(',',Value);
    if DecimalLocation > 0 then
    begin
      Value[DecimalLocation] := '.';
    end;
  end;
  if String(CommaSeparator) = ',' then
  begin
    DecimalLocation := Pos('.',Value);
    if DecimalLocation > 0 then
    begin
      Value[DecimalLocation] := ',';
    end;
  end;

{  DecimalPosition := Pos(',',Value);
  if DecimalPosition > 0 then
  begin
    Value[DecimalPosition] := '.';
  end; }
  Result := StrToFloat(Value);
end;

Function FracToRainbow(Fraction : double) : TColor;
var
  Choice : integer;
begin
  Assert((Fraction>=0) and (Fraction<=1));
  fraction := Fraction*4;
  Choice := Trunc(fraction);
  fraction := Frac(fraction);
  result := 0;
  case Choice of
    0:
      begin
        result := Round(Fraction*$FF)*$100 + $FF;       // R -> R+G
      end;
    1:
      begin
        result := $FF00 + Round((1-Fraction)*$FF);      // R+G -> G
      end;
    2:
      begin
        result := Round(Fraction*$FF)*$10000 + $FF00;  // G -> G+B
      end;
    3:
      begin
        result := $FF0000 + Round((1-Fraction)*$FF)*$100; // G+B -> B
      end;
    4:
      begin
        result := Round(Fraction*$FF) + $FF0000;          // B -> B+R
      end;
    5:
      begin
        result := $FF00FF;
      end;                                               // B+R
  else Assert(False);
  end;
end;

function ShowHiddenFunctions: boolean;
var
  IniFileName : string;
  Extension : string;
  IniFile : TStringList;
begin
  result := false;
  GetDllFullPath(GetDLLName, IniFileName);
  Extension := ExtractFileExt(IniFileName);
  SetLength(IniFileName, Length(IniFileName) - Length(Extension));
  IniFileName := IniFileName + '.ini';
  if FileExists(IniFileName) then
  begin
    IniFile := TStringList.Create;
    try
      IniFile.LoadFromFile(IniFileName);
      if IniFile.Count > 0 then
      begin
        result := UpperCase(Trim(IniFile[0])) = 'SHOW';
      end;
    finally
      IniFile.Free;
    end;
  end;
end;


{
By  Simon Carter

The following function will reset the width of the dropdown listbox within a combobox.

It takes 2 parameters (1 optional).

ComboBox is the TComboBox whos dropdown width is to be changed.
Width is an optional parameter specifying the width of the drop down list.  If
the width is less than the width of the ComboBox then this parameter will be ignored and the width
will be set to the longest string in the combobox.
}

{procedure SetComboDropDownWidth(ComboBox: TComboBox; Width: Integer = -1);
var 
  I, TextLen: Longint; 
  lf: LOGFONT; 
  f: HFONT; 
begin 
  if Width < ComboBox.Width then begin 
    FillChar(lf,SizeOf(lf),0); 
    StrPCopy(lf.lfFaceName, ComboBox.Font.Name); 
    lf.lfHeight := ComboBox.Font.Height; 
    lf.lfWeight := FW_NORMAL; 
    if fsBold in ComboBox.Font.Style then 
      lf.lfWeight := lf.lfWeight or FW_BOLD; 

    f := CreateFontIndirect(lf); 
    if (f <> 0) then 
    begin 
      try 
        ComboBox.Canvas.Handle := GetDC(ComboBox.Handle); 
        SelectObject(ComboBox.Canvas.Handle,f); 
        try 
          for I := 0 to ComboBox.Items.Count -1 do begin 
            TextLen := ComboBox.Canvas.TextWidth(ComboBox.Items[I]); 
            if TextLen > Width then
              Width := TextLen; 
          end; 
          (* Standard ComboBox drawing is Rect.Left + 2, 
          adding the extra spacing offsets this *) 
          Inc(Width, GetSystemMetrics(SM_CYVTHUMB) + 
            GetSystemMetrics(SM_CXVSCROLL)); 
        finally 
          ReleaseDC(ComboBox.Handle, ComboBox.Canvas.Handle); 
        end; 
      finally 
        DeleteObject(f); 
      end; 
    end; 
  end; 
  SendMessage(ComboBox.Handle, CB_SETDROPPEDWIDTH, Width, 0); 
end; }

function FortranStrToFloat(AString : string) : double;
var
  DPos : integer;
  Sub : string;
begin
  AString := Trim(AString);
  DPos := Pos('d', AString);
  if DPos > 0 then
  begin
    AString[DPos] := 'e';
  end;
  DPos := Pos('D', AString);
  if DPos > 0 then
  begin
    AString[DPos] := 'E';
  end;
  if DecimalSeparator <> '.' then
  begin
    DPos := Pos('.', AString);
    if DPos > 0 then
    begin
      AString[DPos] := DecimalSeparator;
    end;
  end;
  Sub := Copy(AString, 2, Length(AString));
  DPos := Pos('+', Sub);
  if DPos > 0 then
  begin
    if (AString[DPos] <> 'e') and (AString[DPos] <> 'E') then
    begin
      AString := Copy(AString, 1, DPos) + 'E' + Copy(AString, DPos + 1, Length(AString))
    end;
  end;
  DPos := Pos('-', Sub);
  if DPos > 0 then
  begin
    if (AString[DPos] <> 'e') and (AString[DPos] <> 'E') then
    begin
      AString := Copy(AString, 1, DPos) + 'E' + Copy(AString, DPos + 1, Length(AString))
    end;
  end;
  result := StrToFloat(AString);
end;

function GetBlockIndex(RowIndex, ColIndex: integer; const NROW, NCOL: integer;
  const RowsReversed, ColsReversed: boolean): integer;
var
  ErrorString : string;
begin
  if not ((ColIndex > 0) and (ColIndex <= NCOL) and (RowIndex > 0)
    and (RowIndex <= NROW)) then
  begin
    ErrorString := 'Illegal row or column number.';
    raise Exception.Create(ErrorString);
  end;
  ColIndex := ColIndex -1;
  RowIndex := RowIndex -1;
  if ColsReversed then
  begin
    ColIndex := NCOL - ColIndex -1;
  end;
  if RowsReversed then
  begin
    RowIndex := NROW - RowIndex -1;
  end;
  result := RowIndex* NCOL + ColIndex;
end;

function GetArgusStr(const List: TStrings): string;
var
  I, L, Size, Count: Integer;
  P: PChar;
  S: string;
  NilIndex: integer;
begin
  Count := List.Count;
  Size := 0;
  for I := 0 to Count - 1 do
  begin
    Inc(Size, Length(List[I]) + 1);
  end;
  SetString(Result, nil, Size);
  P := Pointer(Result);
  for I := 0 to Count - 1 do
  begin
    S := List[I];
    NilIndex := Pos(Char(0),S);
    while NilIndex > 0 do
    begin
      S[NilIndex] := ' ';
      NilIndex := Pos(Char(0),S);
    end;
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, L);
      Inc(P, L);
    end;
    P^ := #10;
    Inc(P);
  end;
end;

function PointInside(const X, Y: double; XCoord: array of double;
  YCoord: array of Double; const IsClosed: boolean): boolean;
var
  VertexIndex: integer;
  AnX, AnotherX: double;
  AY, AnotherY: double;
  Count: integer;
begin // based on CACM 112
  Count := Length(XCoord);
  Assert(Length(YCoord) = Count);
  if IsClosed then
  begin
    if Count < 4 then
    begin
      result := false;
      Exit;
    end;
    AnX := XCoord[0];
    AY := YCoord[0];
    AnotherX := XCoord[Count-1];
    AnotherY := YCoord[Count-1];
    if (AnX <> AnotherX) or
      (AY <> AnotherY) then
    begin
      result := False;
      Exit;
    end;
  end
  else
  begin
    if Count < 3 then
    begin
      result := false;
      Exit;
    end;
  end;

  result := true;
  for VertexIndex := 0 to Count - 2 do
  begin
    AnX := XCoord[VertexIndex];
    AY := YCoord[VertexIndex];
    AnotherX := XCoord[VertexIndex+1];
    AnotherY := YCoord[VertexIndex+1];

    if ((Y <= AY) = (Y > AnotherY)) and
      (X - AnX - (Y - AY) *
      (AnotherX - AnX) /
      (AnotherY - AY) < 0) then
    begin
      result := not result;
    end;
  end;

  if not IsClosed then
  begin
    AnX := XCoord[Count-1];
    AY := YCoord[Count-1];
    AnotherX := XCoord[0];
    AnotherY := YCoord[0];

    if ((Y <= AY) = (Y > AnotherY)) and
      (X - AnX - (Y - AY) *
      (AnotherX - AnX) /
      (AnotherY - AY) < 0) then
    begin
      result := not result;
    end;
  end;
  result := not result;
end;

function Distance(const X1, Y1, X2, Y2: double): double; overload;
begin
  result := Sqrt(Sqr(X1-X2) + Sqr(Y1-Y2));
end;

function Distance(const X1, Y1, Z1, X2, Y2, Z2: double): double; overload;
begin
  result := Sqrt(Sqr(X1-X2) + Sqr(Y1-Y2) + Sqr(Z1-Z2));
end;

function Interpolate(const Lower, Upper, Fraction: double): double;
begin
  result := (1- Fraction)* Lower + Fraction * Upper;
end;

const
  CSIDL_COMMON_APPDATA = $0023;
  // CSIDL_APPDATA replaces "All Users" with the user's logon name.
  CSIDL_APPDATA = $001A;

function AppDataFolderPath(Handle: HWnd): string;
Var
  S :String;
  recIDL : TItemIDList;
  ppIDL : PItemIDList;
  Res :Integer;
begin

  result := '';
  ppIDL := Addr( recIDL );
  Res := SHGetSpecialFolderLocation( Handle, CSIDL_APPDATA, ppIDL );
  If Res = NO_ERROR Then
  Begin
    SetLength( S, MAX_PATH );
    If SHGetPathFromIDList( ppIDL, PChar(S)) Then
    begin
      result := String( PChar(S) );
    end
    else
    begin
      RaiseLastWin32Error;
    end
  End
  else
  begin
      RaiseLastWin32Error;
  end;
end;

function DllAppDirectory(Handle: HWnd; DLLName: string): string;
begin
  DLLName := ChangeFileExt(DLLName, '');
  DLLName := ExtractFileName(DLLName);
  result := AppDataFolderPath(Handle) + '\WRDAPP\' + DLLName;
end;

procedure CreateDirectoryAndParents(DirName: string);
var
  Parents: TStringList;
  Index: integer;
  function ParentDir(const DirName: string): string;
  var
    Index: integer;
  begin
    result := '';
    for Index := Length(DirName) downto 1 do
    begin
      if DirName[Index] = '\' then
      begin
        result := Copy(DirName, 1, Index-1);
        Exit;
      end;
    end;
  end;
begin
  Parents := TStringList.Create;
  try
    while (not DirectoryExists(DirName)) and (DirName <> '') do
    begin
      Parents.Add(DirName);
      DirName := ParentDir(DirName);
    end;
    for Index := Parents.Count -1 downto 0 do
    begin
      if not CreateDir(Parents[Index]) then RaiseLastWin32Error;
    end;
  finally
    Parents.Free;
  end;

end;

end.
