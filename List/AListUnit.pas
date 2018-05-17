unit AListUnit;

interface

uses
  Classes, SysUtils,
  AnePIE, FunctionPie;

type
  TPIEArray = Array[0..32760] of ANEPIEDesc;
  PPIEArray = ^TPIEArray;
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;
//  ANE_BOOL_PTR = ^ANE_BOOL;

  TReal = Class (TObject)
    Value : double;
  end;

  TSingle = class(TObject)
    Value : single;
  end;

  T3DList = Class(TList)
    MaxX : integer;
    MaxY : integer;
    MaxZ : integer;
    constructor Create(AMaxX, AMaxY, AMaxZ : integer);
  end;

var
  MainList : TList;
  Main3DList : TList;
  ErrorCount : integer = 0;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

procedure GListInitializeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GListCreateMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIESetListSizeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEGetListCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEFreeListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEAddToListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEGetFromListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIESetListItemMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIERemoveListItemMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIESortListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEEliminateDuplicatesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEIndexOfMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GListFreeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function ListPosition(const Strings: TStrings; const Item: string): Integer;
                                
implementation

uses ThreeDFunctions, CheckPIEVersionFunction, UtilityFunctions, RealListUnit,
  NamedStringLists, OptionsUnit, CoordinateLists;

const
  kMaxFunDesc = 56;

var
  NamedList: TStringList;

        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;
//        gFunDesc : PPIEArray;

        gPIEInitializeListDesc  :  ANEPIEDesc;
        gPIEInitializeListFDesc :  FunctionPIEDesc;

        gPIECreateListDesc  :  ANEPIEDesc;
        gPIECreateListFDesc :  FunctionPIEDesc;

        gPIECreate3DListDesc  :  ANEPIEDesc;
        gPIECreate3DListFDesc :  FunctionPIEDesc;

        gPIESetListSizeDesc  :  ANEPIEDesc;
        gPIESetListSizeFDesc :  FunctionPIEDesc;

        gPIEGetListCountDesc  :  ANEPIEDesc;
        gPIEGetListCountFDesc :  FunctionPIEDesc;

        gPIEFreeAListDesc  :  ANEPIEDesc;
        gPIEFreeAListFDesc :  FunctionPIEDesc;

        gPIEFreeA3DListDesc  :  ANEPIEDesc;
        gPIEFreeA3DListFDesc :  FunctionPIEDesc;

        gPIEAddDesc  :  ANEPIEDesc;
        gPIEAddFDesc :  FunctionPIEDesc;

        gPIEGetDesc  :  ANEPIEDesc;
        gPIEGetFDesc :  FunctionPIEDesc;

        gPIEGet3DListItemDesc  :  ANEPIEDesc;
        gPIEGet3DListItemFDesc :  FunctionPIEDesc;

        gPIEGetOneBased3DListItemDesc  :  ANEPIEDesc;
        gPIEGetOneBased3DListItemFDesc :  FunctionPIEDesc;

        gPIESetListItemDesc  :  ANEPIEDesc;
        gPIESetListItemFDesc :  FunctionPIEDesc;

        gPIESet3DListItemDesc  :  ANEPIEDesc;
        gPIESet3DListItemFDesc :  FunctionPIEDesc;

        gPIESetOneBased3DListItemDesc  :  ANEPIEDesc;
        gPIESetOneBased3DListItemFDesc :  FunctionPIEDesc;

        gPIERemoveListItemDesc  :  ANEPIEDesc;
        gPIERemoveListItemFDesc :  FunctionPIEDesc;

        gPIESortListDesc  :  ANEPIEDesc;
        gPIESortListFDesc :  FunctionPIEDesc;

        gPIEEliminateDuplicatesDesc  :  ANEPIEDesc;
        gPIEEliminateDuplicatesFDesc :  FunctionPIEDesc;

        gPIEIndexOfDesc  :  ANEPIEDesc;
        gPIEIndexOfFDesc :  FunctionPIEDesc;

        gPIEUnsortedIndexOfDesc  :  ANEPIEDesc;
        gPIEUnsortedIndexOfFDesc :  FunctionPIEDesc;

        gPIEFreeListDesc  :  ANEPIEDesc;
        gPIEFreeListFDesc :  FunctionPIEDesc;

        gPIEReset3DListDesc  :  ANEPIEDesc;
        gPIEReset3DListFDesc :  FunctionPIEDesc;

        gPIEGetErrorCountDesc  :  ANEPIEDesc;
        gPIEGetErrorCountFDesc :  FunctionPIEDesc;

        gPIEAdd3DListDesc  :  ANEPIEDesc;
        gPIEAdd3DListFDesc :  FunctionPIEDesc;

        gPIESubtract3DListDesc  :  ANEPIEDesc;
        gPIESubtract3DListFDesc :  FunctionPIEDesc;

        gPIEMultiply3DListDesc  :  ANEPIEDesc;
        gPIEMultiply3DListFDesc :  FunctionPIEDesc;

        gPIEDivide3DListDesc  :  ANEPIEDesc;
        gPIEDivide3DListFDesc :  FunctionPIEDesc;

        gPIEMultiply3DListByConstantDesc  :  ANEPIEDesc;
        gPIEMultiply3DListByConstantFDesc :  FunctionPIEDesc;

        gPIEInvert3DListDesc  :  ANEPIEDesc;
        gPIEInvert3DListFDesc :  FunctionPIEDesc;

        gPIECheckUniformSinglePrecisionDesc  :  ANEPIEDesc;
        gPIECheckUniformSinglePrecisionFDesc :  FunctionPIEDesc;

        gPIEAddToNamedListDesc  :  ANEPIEDesc;
        gPIEAddToNamedListFDesc :  FunctionPIEDesc;

        gPIESetNamedItemDesc  :  ANEPIEDesc;
        gPIESetNamedItemFDesc :  FunctionPIEDesc;

        gPIENamedListCountDesc  :  ANEPIEDesc;
        gPIENamedListCountFDesc :  FunctionPIEDesc;

        gPIEGetFromNamedListDesc  :  ANEPIEDesc;
        gPIEGetFromNamedListFDesc :  FunctionPIEDesc;

        gPIEFreeNamedListDesc  :  ANEPIEDesc;
        gPIEFreeNamedListFDesc :  FunctionPIEDesc;

        gPIEGetNumberOfNamedListsDesc  :  ANEPIEDesc;
        gPIEGetNumberOfNamedListsFDesc :  FunctionPIEDesc;

        gPIEGetNameOfListDesc  :  ANEPIEDesc;
        gPIEGetNameOfListFDesc :  FunctionPIEDesc;

        gPIEFreeNamedListsDesc  :  ANEPIEDesc;
        gPIEFreeNamedListsFDesc :  FunctionPIEDesc;



        gPIEAddToNamedStringListDesc  :  ANEPIEDesc;
        gPIEAddToNamedStringListFDesc :  FunctionPIEDesc;

        gPIENamedStringListCountDesc  :  ANEPIEDesc;
        gPIENamedStringListCountFDesc :  FunctionPIEDesc;

        gPIEGetFromNamedStringListDesc  :  ANEPIEDesc;
        gPIEGetFromNamedStringListFDesc :  FunctionPIEDesc;

        gPIEFreeNamedStringListDesc  :  ANEPIEDesc;
        gPIEFreeNamedStringListFDesc :  FunctionPIEDesc;

        gPIEGetNumberOfNamedStringListsDesc  :  ANEPIEDesc;
        gPIEGetNumberOfNamedStringListsFDesc :  FunctionPIEDesc;

        gPIEGetNameOfStringListDesc  :  ANEPIEDesc;
        gPIEGetNameOfStringListFDesc :  FunctionPIEDesc;

        gPIEFreeNamedStringListsDesc  :  ANEPIEDesc;
        gPIEFreeNamedStringListsFDesc :  FunctionPIEDesc;

        gPIEPositionInNamedStringListsDesc  :  ANEPIEDesc;
        gPIEPositionInNamedStringListsFDesc :  FunctionPIEDesc;

        gPIEEvalContourParamDesc  :  ANEPIEDesc;
        gPIEEvalContourParamFDesc :  FunctionPIEDesc;

        // coordinate list functions
        gPIEFreeNamedCoordinateListsDesc  :  ANEPIEDesc;
        gPIEFreeNamedCoordinateListsFDesc :  FunctionPIEDesc;

        gPIEAddToNamedCoordinateListDesc  :  ANEPIEDesc;
        gPIEAddToNamedCoordinateListFDesc :  FunctionPIEDesc;

        gPIEFreeNamedCoordinateListDesc  :  ANEPIEDesc;
        gPIEFreeNamedCoordinateListFDesc :  FunctionPIEDesc;

        gPIEGetXFromNamedCoordinateListDesc  :  ANEPIEDesc;
        gPIEGetXFromNamedCoordinateListFDesc :  FunctionPIEDesc;

        gPIEGetYFromNamedCoordinateListDesc  :  ANEPIEDesc;
        gPIEGetYFromNamedCoordinateListFDesc :  FunctionPIEDesc;

        gPIEGetNamedCoordinateListCountDesc  :  ANEPIEDesc;
        gPIEGetNamedCoordinateListCountFDesc :  FunctionPIEDesc;

        gPIEGetNameOfCoordinateListDesc  :  ANEPIEDesc;
        gPIEGetNameOfCoordinateListFDesc :  FunctionPIEDesc;

        gPIEGetNumberOfNamedCoordinateListsDesc  :  ANEPIEDesc;
        gPIEGetNumberOfNamedCoordinateListsFDesc :  FunctionPIEDesc;

        gPIEGetPositionInCoordinateListDesc  :  ANEPIEDesc;
        gPIEGetPositionInCoordinateListFDesc :  FunctionPIEDesc;




const   gpnNumber : array [0..1] of PChar = ('Number', nil);
const   gpnListIndex : array [0..1] of PChar = ('ListIndex', nil);
const   gOneIntegerTypes : array [0..1] of EPIENumberType = (kPIEInteger, 0);

const   gpnIndexValue : array [0..2] of PChar = ('ListIndex','Value', nil);
const   gIntegerDouble : array [0..2] of EPIENumberType = (kPIEInteger, kPIEFloat, 0);

const   gpn2Index : array [0..2] of PChar = ('ListIndex','Index', nil);
const   gpnIndexSize : array [0..2] of PChar = ('ListIndex','Size', nil);
const   g2Integer : array [0..2] of EPIENumberType = (kPIEInteger, kPIEInteger, 0);

const   gpn2IndexValue : array [0..3] of PChar = ('ListIndex','Index','Value', nil);
const   gpn2ListIndexesValue : array [0..3] of PChar = ('ListIndex','ResultListIndex','Value', nil);
const   g2IntegerValue : array [0..3] of EPIENumberType = (kPIEInteger, kPIEInteger,kPIEFloat, 0);

const   gpn3Max : array [0..3] of PChar = ('Maximum_X','Maximum_Y','Maximum_Z', nil);
const   gpn3Lists : array [0..3] of PChar = ('FirstListIndex','SecondListIndex','ResultListIndex', nil);
const   g3Integer : array [0..3] of EPIENumberType = (kPIEInteger, kPIEInteger,kPIEInteger, 0);

const   gpn4Index : array [0..4] of PChar = ('ListIndex','X_Index','Y_Index','Z_Index', nil);
const   g4Integer : array [0..4] of EPIENumberType = (kPIEInteger, kPIEInteger, kPIEInteger, kPIEInteger, 0);

const   gpn4IndexValue : array [0..5] of PChar = ('ListIndex','X_Index','Y_Index','Z_Index','Value',  nil);
const   g4IntegerFloat : array [0..5] of EPIENumberType = (kPIEInteger, kPIEInteger, kPIEInteger, kPIEInteger,kPIEFloat, 0);

const   gpnNameNumber : array [0..2] of PChar = ('Name', 'Number', nil);
const   g1String1FloatTypes : array [0..2] of EPIENumberType = (kPIEString, kPIEFloat, 0);

const   gpnNamePosition : array [0..2] of PChar = ('Name', 'Position', nil);
const   g1String1IntegerTypes : array [0..2] of EPIENumberType = (kPIEString, kPIEInteger, 0);

const   gpnNamePositionValue : array [0..3] of PChar = ('Name', 'Position', 'Value', nil);
const   g1String1Integer1RealTypes : array [0..3] of EPIENumberType = (kPIEString, kPIEInteger, kPIEFloat, 0);

const   gpnName : array [0..1] of PChar = ('Name', nil);
const   g1StringTypes : array [0..1] of EPIENumberType = (kPIEString, 0);

const   gpnNameString : array [0..2] of PChar = ('Name', 'String', nil);
const   gpnLayerContourindexParameter : array [0..3] of PChar = ('Layer', 'ContourIndex', 'Parameter', nil);
const   g2StringTypes : array [0..2] of EPIENumberType = (kPIEString, kPIEString, 0);
const   gStringIntegerStringTypes : array [0..3] of EPIENumberType = (kPIEString, kPIEInteger, kPIEString, 0);
const   gpnNameXY : array [0..3] of PChar = ('Name', 'X', 'Y', nil);
const   gStringDoubleDoubleTypes : array [0..3] of EPIENumberType = (kPIEString, kPIEFloat, kPIEFloat, 0);

function ListPosition(const Strings: TStrings; const Item: string): Integer;
begin
  for Result := 0 to Strings.Count - 1 do
    if Strings[result] = Item then Exit;
  Result := -1;
end;

function Sort  (Item1, Item2: Pointer): Integer;
var
  FirstItem, SecondItem : TReal;
begin
    FirstItem := Item1 ;
    SecondItem := Item2 ;
    if FirstItem.Value < SecondItem.Value
    then result := -1
    else if FirstItem.Value = SecondItem.Value then result := 0
    else result := 1;
end;

constructor T3DList.Create(AMaxX, AMaxY, AMaxZ : integer);
var
  Index : integer;
  AReal : TReal;
begin
  inherited Create;
  MaxX := AMaxX;
  MaxY := AMaxY;
  MaxZ := AMaxZ;
  For Index := 0 to MaxX * MaxY * MaxZ -1 do
  begin
    AReal := TReal.Create;
    AReal.Value := 0;
    Add(AReal);
  end;
end;

function Initialize : ANE_INT32;
begin
  try
    begin
      if (MainList = nil)
      then
        begin
          MainList := TList.Create;
          result :=1;
        end
      else
        begin
          result :=-1;
        end;
    end;
  Except on Exception do
    begin
      MainList.Free;
      MainList := nil;
      result := 0;
      Inc(ErrorCount);
    end;
  end;
end;

function Initialize3D : ANE_INT32;
begin
  try
    begin
      if (Main3DList = nil)
      then
        begin
          Main3DList := TList.Create;
          result :=1;
        end
      else
        begin
          result :=-1;
        end;
    end;
  Except on Exception do
    begin
      Main3DList.Free;
      Main3DList := nil;
      result := 0;
      Inc(ErrorCount);
    end;
  end;
end;

{Procedure GPIECheckVersionMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  param3_ptr : ANE_INT32_PTR;
  param4_ptr : ANE_INT32_PTR;
  FirstDigit, SecondDigit, ThirdDigit,FouthDigit : integer;
  result : ANE_BOOL;
  param : PParameter_array;
  VersionInfo1: TVersionInfo;
  VersionString : String;
  currentDigit : integer;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      FirstDigit :=  param1_ptr^;
      param2_ptr :=  param^[1];
      SecondDigit :=  param2_ptr^;
      param3_ptr :=  param^[2];
      ThirdDigit :=  param3_ptr^;
      param4_ptr :=  param^[3];
      FouthDigit :=  param4_ptr^;
      VersionInfo1 := TVersionInfo.Create(Application);
      try
        VersionInfo1.FileName := GetDLLName;
        VersionString := VersionInfo1.FileVersion;
        currentDigit := StrToInt(Copy(VersionString,1,Pos('.',VersionString)-1));
        result := (currentDigit >= FirstDigit);
        if (currentDigit = FirstDigit) then
        begin
          VersionString := Copy(VersionString,Pos('.',VersionString)+1, Length(VersionString));
          currentDigit := StrToInt(Copy(VersionString,1,Pos('.',VersionString)-1));
          result := (currentDigit >= SecondDigit);
          if (currentDigit = SecondDigit) then
          begin
            VersionString := Copy(VersionString,Pos('.',VersionString)+1, Length(VersionString));
            currentDigit := StrToInt(Copy(VersionString,1,Pos('.',VersionString)-1));
            result := (currentDigit >= ThirdDigit);
            if (currentDigit = ThirdDigit) then
            begin
              VersionString := Copy(VersionString,Pos('.',VersionString)+1, Length(VersionString));
              currentDigit := StrToInt(VersionString);
              result := (currentDigit >= FouthDigit);
            end;
          end;
        end;
      finally
        VersionInfo1.Free;
      end;
    end;
  except on Exception do
    begin
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;

end;  }
procedure GListInitializeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_BOOL;
begin
  ErrorCount:= 0;
  try
    begin
      if not (Initialize = 0) and not (Initialize3D = 0)
      then
        begin
          result := True;
        end
      else
        begin
          result := False;
        end;
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GListCreateMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AList : TList;
  result : ANE_INT32;
begin
  AList := TList.Create;
  try
    begin
      MainList.Add(AList);
      result := MainList.Count -1;
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      AList.Free;
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure G3DListCreateMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  A3DList : T3DList;
  result : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List to which value will be added.
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;         // value to be added.
  param3_ptr : ANE_INT32_PTR;
  param3 : ANE_INT32;         // value to be added.
  param : PParameter_array;
begin
//  result := -1;
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      param3_ptr :=  param^[2];
      param3 :=  param3_ptr^;
      A3DList := T3DList.Create(param1,param2,param3) ;
      try
        begin
          Main3DList.Add(A3DList);
          result := Main3DList.Count -1;
        end;
      Except on Exception do
        begin
          Inc(ErrorCount);
          A3DList.Free;
//          A3DList := nil;
          result := -1;
        end;
      end;
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GPIEAddToListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List to which value will be added.
  param2_ptr : ANE_DOUBLE_PTR;
  param2 : ANE_DOUBLE;         // value to be added.
  result : ANE_INT32;           // position in list of item that was added.
  param : PParameter_array;
begin
  AReal := TReal.Create;
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      AReal.Value := param2;
      AList := MainList.Items[param1];
      AList.Add(AReal);
      result := AList.Count -1;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      AReal.Free;
//      AReal := nil;
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GPIEGetNumberOfNamedLists (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;           // position in list of item that was added.
begin
  try
    begin
      if NamedList = nil then
      begin
        result := 0;
      end
      else
      begin
        result := NamedList.Count
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GPIEAddToNamedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AList : TRealList;
  param1 : ANE_STR;          // Index of List to which value will be added.
  param2_ptr : ANE_DOUBLE_PTR;
  param2 : ANE_DOUBLE;         // value to be added.
  result : ANE_INT32;           // position in list of item that was added.
  param : PParameter_array;
  Position: integer;
begin
  try
    begin
      param := @parameters^;
      param1 :=  param^[0];
//      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;

      if NamedList = nil then
      begin
        NamedList := TStringList.Create;
      end;

      Position := ListPosition(NamedList, param1);
      if Position < 0 then
      begin
        AList := TRealList.Create;
        NamedList.AddObject(param1, AList);
      end
      else
      begin
        AList := NamedList.Objects[Position] as TRealList;
      end;

      AList.Add(param2);
      result := AList.Count;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

var
  NameOfList: string;

procedure GPIEGetNameOfList (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;
  result : ANE_STR;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;

      if NamedList = nil then
      begin
        Inc(ErrorCount);
        NameOfList := '';
      end
      else
      begin
        NameOfList := NamedList[param1];
      end;
      result := PChar(NameOfList);
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := '';
    end;
  end;
  ANE_STR_PTR(reply)^ := result;
end;


procedure GPIESetListSizeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List to which value will be added.
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;         // size of List.
  result : ANE_BOOL;           // true if succeeded.
  param : PParameter_array;
  ListIndex : integer;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      AList := MainList.Items[param1];
      For ListIndex := AList.Count to param2-1 do
      begin
        AReal := TReal.Create;
        AReal.Value := 0;
        AList.Add(AReal);
      end;
      result := True;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIEGetListCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AList := MainList.Items[param1];
      result := AList.Count;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GPIEGetNamedListCount (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AList : TRealList;
  param1 : ANE_STR;          // Index of List  containing value
  result : ANE_INT32;
  param : PParameter_array;
  Position: integer;
begin
  try
    begin
      if NamedList = nil then
      begin
        result := 0;
        Inc(ErrorCount);
      end
      else
      begin
        param := @parameters^;
        param1 :=  param^[0];

        Position := ListPosition(NamedList, param1);
        if Position < 0 then
        begin
          result := 0;
          Inc(ErrorCount);
        end
        else
        begin
          AList := NamedList.Objects[Position] as TRealList;
          result := AList.Count;
        end;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GPIEFreeListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  result : ANE_BOOL;
  param : PParameter_array;
  ListIndex : integer;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AList := MainList.Items[param1];
      For ListIndex := AList.Count -1 downto 0 do
      begin
        AReal := AList.Items[ListIndex];
        AReal.Free;
      end;
      AList.Clear;
      result := True;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIEFreeNamedList (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1 : ANE_STR;
  result : ANE_BOOL;
  param : PParameter_array;
  Position: integer;
begin
  try
    begin
      if NamedList = nil then
      begin
        result := False;
//        Inc(ErrorCount);
      end
      else
      begin
        param := @parameters^;
        param1 :=  param^[0];

        Position := ListPosition(NamedList, param1);
        if Position < 0 then
        begin
          result := False;
          Inc(ErrorCount);
        end
        else
        begin
          NamedList.Objects[Position].Free;
          NamedList.Delete(Position);
          result := True;
        end;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;


procedure GPIEFree3DListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  A3DList : T3DList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  result : ANE_BOOL;
  param : PParameter_array;
  ListIndex : integer;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      A3DList := Main3DList.Items[param1];
      For ListIndex := A3DList.Count -1 downto 0 do
      begin
        AReal := A3DList.Items[ListIndex];
        AReal.Free;
      end;
      A3DList.Clear;
      result := True;
      A3DList.MaxX := 0;
      A3DList.MaxY := 0;
      A3DList.MaxZ := 0;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIEReset3DListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  A3DList : T3DList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  result : ANE_BOOL;
  param : PParameter_array;
  ListIndex : integer;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      A3DList := Main3DList.Items[param1];
      For ListIndex := A3DList.Count -1 downto 0 do
      begin
        AReal := A3DList.Items[ListIndex];
        AReal.Value := 0;
      end;
      result := True;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIEGetFromListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // position in list of item
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      AList := MainList.Items[param1];
      AReal := AList.Items[param2];
      result := AReal.Value;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GPIEGetFromNamedList (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AList : TRealList;
  param1 : ANE_STR;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // position in list of item
  result : ANE_DOUBLE;
  param : PParameter_array;
  Position: integer;
begin
  try
    begin
      if NamedList = nil then
      begin
        result := 0;
        Inc(ErrorCount);
      end
      else
      begin
        param := @parameters^;
        param1 :=  param^[0];
        param2_ptr :=  param^[1];
        param2 :=  param2_ptr^;

        Position := ListPosition(NamedList, param1);
        if Position < 0 then
        begin
          result := 0;
          Inc(ErrorCount);
        end
        else
        begin
          AList := NamedList.Objects[Position] as TRealList;
          result := AList[param2]
        end;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GPIEGetFrom3DListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  A3DList : T3DList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // X position in list of item
  param3_ptr : ANE_INT32_PTR;
  param3 : ANE_INT32;          // Y position in list of item
  param4_ptr : ANE_INT32_PTR;
  param4 : ANE_INT32;          // Z position in list of item
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      param3_ptr :=  param^[2];
      param3 :=  param3_ptr^;
      param4_ptr :=  param^[3];
      param4 :=  param4_ptr^;
      A3DList := Main3DList.Items[param1];
      if (param2 < 0) or (param2 > A3DList.MaxX -1) or
         (param3 < 0) or (param3 > A3DList.MaxY -1) or
         (param4 < 0) or (param4 > A3DList.MaxZ -1)
      then
        begin
          result := 0;
          Inc(ErrorCount);
        end
      else
        begin
          AReal := A3DList.Items[param4 * A3DList.MaxY * A3DList.MaxX + param3 * A3DList.MaxX + param2];
          result := AReal.Value;
        end;

    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GPIEGetFromOneBased3DListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  A3DList : T3DList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // X position in list of item
  param3_ptr : ANE_INT32_PTR;
  param3 : ANE_INT32;          // Y position in list of item
  param4_ptr : ANE_INT32_PTR;
  param4 : ANE_INT32;          // Z position in list of item
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^ -1;
      param3_ptr :=  param^[2];
      param3 :=  param3_ptr^ -1;
      param4_ptr :=  param^[3];
      param4 :=  param4_ptr^ -1;
      A3DList := Main3DList.Items[param1];
      if (param2 < 0) or (param2 > A3DList.MaxX -1) or
         (param3 < 0) or (param3 > A3DList.MaxY -1) or
         (param4 < 0) or (param4 > A3DList.MaxZ -1)
      then
        begin
          result := 0;
          Inc(ErrorCount);
        end
      else
        begin
          AReal := A3DList.Items[param4 * A3DList.MaxY * A3DList.MaxX + param3 * A3DList.MaxX + param2];
          result := AReal.Value;
        end;

    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GPIESetListItemMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // position in list of item
  param3_ptr : ANE_DOUBLE_PTR;
  param3 : ANE_DOUBLE;          // position in list of item
  result : ANE_BOOL;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      param3_ptr :=  param^[2];
      param3 :=  param3_ptr^;
      AList := MainList.Items[param1];
      AReal := AList.Items[param2];
      AReal.Value := param3;
      result := True;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;


procedure GPIESetNamedListItemMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
{var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // position in list of item
  param3_ptr : ANE_DOUBLE_PTR;
  param3 : ANE_DOUBLE;          // position in list of item
  result : ANE_BOOL;
  param : PParameter_array;
begin  }
var
  AList : TRealList;
  param1 : ANE_STR;
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;
  param3_ptr : ANE_DOUBLE_PTR;
  param3 : ANE_DOUBLE;
  result : ANE_BOOL;
  param : PParameter_array;
  Position: integer;
begin
  result := False;
  try
    begin
      param := @parameters^;
      param1 :=  param^[0];
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      param3_ptr :=  param^[2];
      param3 :=  param3_ptr^;

      if NamedList = nil then
      begin
        NamedList := TStringList.Create;
      end;

      Position := ListPosition(NamedList, param1);
      if Position < 0 then
      begin
        AList := TRealList.Create;
        NamedList.AddObject(param1, AList);
      end
      else
      begin
        AList := NamedList.Objects[Position] as TRealList;
      end;
      While param2 > AList.Count-1 do
      begin
        AList.Add(0);
      end;
      AList[param2] := param3;

      result := True;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;

{ try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      param3_ptr :=  param^[2];
      param3 :=  param3_ptr^;
      AList := MainList.Items[param1];
      AReal := AList.Items[param2];
      AReal.Value := param3;
      result := True;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;  }
end;



procedure GPIESet3DListItemMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  A3DList : T3DList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // X position in list of item
  param3_ptr : ANE_INT32_PTR;
  param3 : ANE_INT32;          // Y position in list of item
  param4_ptr : ANE_INT32_PTR;
  param4 : ANE_INT32;          // Z position in list of item
  param5_ptr : ANE_DOUBLE_PTR;
  param5 : ANE_DOUBLE;          // value of item to be set.
  result : ANE_BOOL;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      param3_ptr :=  param^[2];
      param3 :=  param3_ptr^;
      param4_ptr :=  param^[3];
      param4 :=  param4_ptr^;
      param5_ptr :=  param^[4];
      param5 :=  param5_ptr^;
      A3DList := Main3DList.Items[param1];
      if (param2 < 0) or (param2 > A3DList.MaxX -1) or
         (param3 < 0) or (param3 > A3DList.MaxY -1) or
         (param4 < 0) or (param4 > A3DList.MaxZ -1)
      then
        begin
          result := False;
          Inc(ErrorCount);
        end
      else
        begin
          AReal := A3DList.Items[param4 * A3DList.MaxY * A3DList.MaxX + param3 * A3DList.MaxX + param2];
          AReal.Value := param5;
          result := True;
        end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIESetOneBased3DListItemMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  A3DList : T3DList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // X position in list of item
  param3_ptr : ANE_INT32_PTR;
  param3 : ANE_INT32;          // Y position in list of item
  param4_ptr : ANE_INT32_PTR;
  param4 : ANE_INT32;          // Z position in list of item
  param5_ptr : ANE_DOUBLE_PTR;
  param5 : ANE_DOUBLE;          // value of item to be set.
  result : ANE_BOOL;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^ -1;
      param3_ptr :=  param^[2];
      param3 :=  param3_ptr^ -1;
      param4_ptr :=  param^[3];
      param4 :=  param4_ptr^ -1;
      param5_ptr :=  param^[4];
      param5 :=  param5_ptr^;
      A3DList := Main3DList.Items[param1];
      if (param2 < 0) or (param2 > A3DList.MaxX -1) or
         (param3 < 0) or (param3 > A3DList.MaxY -1) or
         (param4 < 0) or (param4 > A3DList.MaxZ -1)
      then
        begin
          result := False;
          Inc(ErrorCount);
        end
      else
        begin
          AReal := A3DList.Items[param4 * A3DList.MaxY * A3DList.MaxX + param3 * A3DList.MaxX + param2];
          AReal.Value := param5;
          result := True;
        end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIERemoveListItemMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // position in list of item
  ItemToRemove : integer ;
  result : ANE_BOOL;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AList := MainList.Items[param1];
      if (numParams > 1 )
      then
        begin
          param2_ptr :=  param^[1];
          param2 :=  param2_ptr^;
        end
      else
        begin
          param2 := AList.Count -1;
        end;
      AReal := AList.Items[param2];
      ItemToRemove := param2;
      AList.Delete(ItemToRemove);
      AReal.Free;
      result := True;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIESortListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  result : ANE_BOOL;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AList := MainList.Items[param1];
      AList.Sort(Sort);
      result := True;
    end;
  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := False;
      end;
  end;
  ANE_BOOL_PTR(reply)^ := result;

end;

procedure GPIEEliminateDuplicatesMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  result : ANE_BOOL;
  param : PParameter_array;
  ItemIndex : integer;
  AReal, AnotherReal : TReal;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AList := MainList.Items[param1];
      for ItemIndex := AList.Count -1 downto 1 do
      begin
        AReal := AList.Items[ItemIndex];
        AnotherReal := AList.Items[ItemIndex-1];
        if AReal.Value = AnotherReal.Value then
        begin
          AList.Delete(ItemIndex);
          AReal.Free;
        end;
      end;
      AList.Pack;
      if AList.Count > 0 then
      begin
        AList.Capacity := AList.Count;
      end;
      result := True;
    end;
  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := False;
      end;
  end;
  ANE_BOOL_PTR(reply)^ := result;

end;

procedure GPIEIndexOfMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  ARealBelow, ARealAbove, ARealMiddle : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_DOUBLE_PTR;
  param2 : ANE_DOUBLE;          // item for which the index is to be found.
  result : ANE_INT32;
  param : PParameter_array;
  below, above, middle : ANE_INT32;
  AValue : ANE_DOUBLE;
  Index : integer;
begin
  result := -1;
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      AList := MainList.Items[param1];
      below := 0;
      above := AList.Count -1;
      AValue := param2;
      if AList.Count > 0 then
      begin
        ARealBelow := AList.Items[below];
        if AValue > ARealBelow.Value
        then
          begin
            while above - below > 1 do
            begin
              middle := Round((above + below)/2);
              ARealMiddle := AList.Items[middle];
              if ARealMiddle.Value > AValue
              then
                begin
                  above := middle;
                end
              else
                begin
                  below := middle;
                end;
            end;
            ARealBelow := AList.Items[below];
            if ARealBelow.Value = AValue
            then
              begin
                result := below;
              end
            else
              begin
                ARealAbove := AList.Items[above];
                if ARealAbove.Value > param2
                then
                  begin
                    result := below;
                  end
                else
                  begin
                    result := above;
                  end;
              end;
          end
        else
          begin
            result := 0;
          end;
        for Index := result downto 1 do
        begin
          ARealAbove := AList.Items[Index];
          ARealBelow := AList.Items[Index -1];
          if ARealAbove.Value = ARealBelow.Value
          then
            begin
              result := Index -1;
            end
          else
            begin
              break;
            end;

        end;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GPIEUnsortedIndexOfMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_DOUBLE_PTR;
  param2 : ANE_DOUBLE;          // item for which the index is to be found.
  result : ANE_INT32;
  param : PParameter_array;
//  below, above, middle : ANE_INT32;
  AValue : ANE_DOUBLE;
  Index : integer;
begin
  result := -1;
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      AList := MainList.Items[param1];
      AValue := param2;
      for Index := 0 to AList.Count -1 do
      begin
        AReal := AList.Items[Index];
        if AReal.Value = AValue then
        begin
          result := Index ;
          break;
        end;
      end;

    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

Procedure Terminate ;
var
//  result : ANE_INT32;
  ListIndex, InnerListIndex : integer;
  AList : TList;
  AReal : TReal;
  A3DList : T3DList;
begin
  try
    begin
      if MainList <> nil then
      begin
        For ListIndex := MainList.Count -1 downto 0 do
        begin
          AList := MainList.Items[ListIndex];
          if not (AList = nil) then
          begin
            For InnerListIndex := AList.Count -1 downto 0 do
            begin
              AReal := AList.Items[InnerListIndex];
              AReal.Free;
            end;
            AList.Clear;
            AList.Free;
          end;
        end;
        MainList.Clear;
        MainList.Free;
        MainList := nil;
      end;
      if Main3DList <> nil then
      begin
        For ListIndex := Main3DList.Count -1 downto 0 do
        begin
          A3DList := Main3DList.Items[ListIndex];
          if not (A3DList = nil) then
          begin
            For InnerListIndex := A3DList.Count -1 downto 0 do
            begin
              AReal := A3DList.Items[InnerListIndex];
              AReal.Free;
            end;
            A3DList.Clear;
            A3DList.Free;
          end;
        end;
        Main3DList.Clear;
        Main3DList.Free;
        Main3DList := nil;
      end;
      if NamedList <> nil then
      begin
        for ListIndex := NamedList.Count -1 downto 0 do
        begin
          NamedList.Objects[ListIndex].Free;
        end;
        NamedList.Free;
        NamedList := nil;
      end;
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
    end;
  end;
end;

procedure GListFreeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_BOOL;
  ListIndex, InnerListIndex : integer;
  AList : TList;
  AReal : TReal;
  A3DList : T3DList;
begin
  try
    begin
      if MainList <> nil then
      begin
        For ListIndex := MainList.Count -1 downto 0 do
        begin
          AList := MainList.Items[ListIndex];
          if AList <> nil then
          begin
            For InnerListIndex := AList.Count -1 downto 0 do
            begin
              AReal := AList.Items[InnerListIndex];
              AReal.Free;
            end;
            AList.Clear;
            AList.Free;
          end;
        end;
        MainList.Clear;
      end;
      if Main3DList <> nil then
      begin
        For ListIndex := Main3DList.Count -1 downto 0 do
        begin
          A3DList := Main3DList.Items[ListIndex];
          if A3DList <> nil then
          begin
            For InnerListIndex := A3DList.Count -1 downto 0 do
            begin
              AReal := A3DList.Items[InnerListIndex];
              AReal.Free;
            end;
            A3DList.Clear;
            A3DList.Free;
          end;
        end;
        Main3DList.Clear;
      end;
      if NamedList <> nil then
      begin
        for ListIndex := NamedList.Count -1 downto 0 do
        begin
          NamedList.Objects[ListIndex].Free;
        end;
        NamedList.Clear;
      end;
      ClearNamedStringLists;
      ClearNamedCoordinateLists;

      ErrorCount := 0;
      result := True;
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GListFreeNamedLists (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_BOOL;
  ListIndex : integer;
begin
  try
    begin
      if NamedList <> nil then
      begin
        for ListIndex := NamedList.Count -1 downto 0 do
        begin
          NamedList.Objects[ListIndex].Free;
        end;
        NamedList.Clear;
      end;
      result := True;
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GListErrorCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_INT32;
begin
  result := ErrorCount;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GPIECheckUniformSingleMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  result : ANE_BOOL;
  param : PParameter_array;
  ItemIndex : integer;
  AReal, AnotherReal : TReal;
  ASingle, AnotherSingle : TSingle;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AList := MainList.Items[param1];
      result := True;
      if AList.Count > 1 then
      begin
        ASingle := TSingle.Create;
        AnotherSingle := TSingle.Create;
        try
          begin
            AReal := AList.Items[0];
            ASingle.Value := AReal.Value;
            for ItemIndex := 1 to AList.Count -1 do
            begin
              AnotherReal := AList.Items[ItemIndex];
              AnotherSingle.Value := AnotherReal.Value;
              if ASingle.Value <> AnotherSingle.Value then
              begin
                result := False ;
                break;
              end;
            end;
          end;
        finally
          begin
            ASingle.Free;
            AnotherSingle.Free;
          end;
        end;
      end;
    end;
  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := False;
      end;
  end;
  ANE_BOOL_PTR(reply)^ := result;

end;

procedure G3EvaluateRealContourParamMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Layer: TLayerOptions;
  param1: ANE_STR; // Index of List to which value will be added.
  param3: ANE_STR; // value to be added.
  param: PParameter_array;
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // Index of List  containing value
  Contour: TContourObjectOptions;
  ParamIndex: ANE_INT32;
  result : ANE_DOUBLE;
begin
  param := @parameters^;
  param1 := param^[0];
  param2_ptr := param^[1];
  param2 := param2_ptr^;
  param3 := param^[2];
  try
    Layer := TLayerOptions.CreateWithName(string(param1), myHandle);
    try
      ParamIndex := Layer.GetParameterIndex(myHandle, param3);
      Contour := TContourObjectOptions.Create(myHandle, Layer.LayerHandle, param2);
      try
        result := Contour.GetFloatParameter(myHandle, ParamIndex);
      finally
        Contour.Free;
      end;

    finally
      Layer.Free(myHandle);
    end;

  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := 0;
      end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
const
  PIEvendor : ANE_STR = '';
  PIEproduct : ANE_STR = '';
  PIEcategory  : ANE_STR = '';
  PIEneededProject : ANE_STR = '';
//  ModelPrefix = '';
  ModelPrefix = 'MODFLOW_';
//  ModelPrefix = 'SUTRA_';
var
  Options : EFunctionPIEFlags;
begin

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

	numNames := 0;

        if ShowHiddenFunctions then
        begin
          Options := 0;                      // Option to use for development work
        end
        else
        begin
          Options := kFunctionIsHidden;        // Hide all functions from regular users to keep them from being misused.
        end;

        // Initialize PIE : no longer needed
	gPIEInitializeListFDesc.version := FUNCTION_PIE_VERSION;	 // Function PIE Version
	gPIEInitializeListFDesc.name := PChar(ModelPrefix + 'L_Initialize');	                // name of function
	gPIEInitializeListFDesc.address := GListInitializeMMFun;	// function address
	gPIEInitializeListFDesc.returnType := kPIEBoolean;		// return value type
	gPIEInitializeListFDesc.numParams :=  0;			// number of parameters
	gPIEInitializeListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEInitializeListFDesc.paramNames := nil;		        // pointer to parameter names list
	gPIEInitializeListFDesc.paramTypes := nil;	                // pointer to parameters types list
	gPIEInitializeListFDesc.functionFlags := kFunctionIsHidden;	        // function options
        gPIEInitializeListFDesc.category := PIEcategory;
        gPIEInitializeListFDesc.neededProject := PIEneededProject;

       	gPIEInitializeListDesc.name  :=PChar(ModelPrefix + 'L_Initialize');		        // name of PIE
	gPIEInitializeListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEInitializeListDesc.descriptor := @gPIEInitializeListFDesc;	// pointer to descriptor
        gPIEInitializeListDesc.version := ANE_PIE_VERSION;
        gPIEInitializeListDesc.vendor  := PIEvendor;
        gPIEInitializeListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEInitializeListDesc;          // add descriptor to list
        Inc(numNames);	                                        // increment number of names


        // Create a new list
	gPIECreateListFDesc.version := FUNCTION_PIE_VERSION;	// Function PIE Version
	gPIECreateListFDesc.name :=PChar(ModelPrefix + 'L_CreateNewList');	        // name of function
	gPIECreateListFDesc.address := GListCreateMMFun;	// function address
	gPIECreateListFDesc.returnType := kPIEInteger;		// return value type
	gPIECreateListFDesc.numParams :=  0;			// number of parameters
	gPIECreateListFDesc.numOptParams := 0;			// number of optional parameters
	gPIECreateListFDesc.paramNames := nil;		        // pointer to parameter names list
	gPIECreateListFDesc.paramTypes := nil;	                // pointer to parameters types list
	gPIECreateListFDesc.functionFlags := Options;	        // function options
        gPIECreateListFDesc.category := PIEcategory;
        gPIECreateListFDesc.neededProject := PIEneededProject;

       	gPIECreateListDesc.name  :=PChar(ModelPrefix + 'L_CreateNewList');		// name of PIE
	gPIECreateListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECreateListDesc.descriptor := @gPIECreateListFDesc;	// pointer to descriptor
        gPIECreateListDesc.version := ANE_PIE_VERSION;
        gPIECreateListDesc.vendor  := PIEvendor;
        gPIECreateListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECreateListDesc;              // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Set list size
	gPIESetListSizeFDesc.version := FUNCTION_PIE_VERSION;	  // Function PIE Version
	gPIESetListSizeFDesc.name :=PChar(ModelPrefix + 'L_SetListSize');	          // name of function
	gPIESetListSizeFDesc.address := GPIESetListSizeMMFun;	  // function address
	gPIESetListSizeFDesc.returnType := kPIEBoolean;		  // return value type
	gPIESetListSizeFDesc.numParams :=  2;			  // number of parameters
	gPIESetListSizeFDesc.numOptParams := 0;			  // number of optional parameters
	gPIESetListSizeFDesc.paramNames := @gpnIndexSize;         // pointer to parameter names list
	gPIESetListSizeFDesc.paramTypes := @g2Integer;	          // pointer to parameters types list
	gPIESetListSizeFDesc.functionFlags := Options;	          // function options
        gPIESetListSizeFDesc.category := PIEcategory;
        gPIESetListSizeFDesc.neededProject := PIEneededProject;

       	gPIESetListSizeDesc.name  :=PChar(ModelPrefix + 'L_SetListSize');		  // name of PIE
	gPIESetListSizeDesc.PieType :=  kFunctionPIE;		  // PIE type: PIE function
	gPIESetListSizeDesc.descriptor := @gPIESetListSizeFDesc;  // pointer to descriptor
        gPIESetListSizeDesc.version := ANE_PIE_VERSION;
        gPIESetListSizeDesc.vendor  := PIEvendor;
        gPIESetListSizeDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESetListSizeDesc;               // add descriptor to list
        Inc(numNames);	                                          // increment number of names

        // Get list size
	gPIEGetListCountFDesc.version := FUNCTION_PIE_VERSION;	     // Function PIE Version
	gPIEGetListCountFDesc.name :=PChar(ModelPrefix + 'L_GetListSize');	             // name of function
	gPIEGetListCountFDesc.address := GPIEGetListCountMMFun;	     // function address
	gPIEGetListCountFDesc.returnType := kPIEInteger;	     // return value type
	gPIEGetListCountFDesc.numParams :=  1;			     // number of parameters
	gPIEGetListCountFDesc.numOptParams := 0;		     // number of optional parameters
	gPIEGetListCountFDesc.paramNames := @gpnListIndex;	     // pointer to parameter names list
	gPIEGetListCountFDesc.paramTypes := @gOneIntegerTypes;	     // pointer to parameters types list
	gPIEGetListCountFDesc.functionFlags := Options;	             // function options
        gPIEGetListCountFDesc.category := PIEcategory;
        gPIEGetListCountFDesc.neededProject := PIEneededProject;

       	gPIEGetListCountDesc.name  :=PChar(ModelPrefix + 'L_GetListSize');		     // name of PIE
	gPIEGetListCountDesc.PieType :=  kFunctionPIE;		     // PIE type: PIE function
	gPIEGetListCountDesc.descriptor := @gPIEGetListCountFDesc;   // pointer to descriptor
        gPIEGetListCountDesc.version := ANE_PIE_VERSION;
        gPIEGetListCountDesc.vendor  := PIEvendor;
        gPIEGetListCountDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetListCountDesc;                 // add descriptor to list
        Inc(numNames);	                                             // increment number of names

        // free a new list
	gPIEFreeAListFDesc.version := FUNCTION_PIE_VERSION;	     // Function PIE Version
	gPIEFreeAListFDesc.name :=PChar(ModelPrefix + 'L_FreeAList');	             // name of function
	gPIEFreeAListFDesc.address := GPIEFreeListMMFun ;	     // function address
	gPIEFreeAListFDesc.returnType := kPIEBoolean;		     // return value type
	gPIEFreeAListFDesc.numParams :=  1;			     // number of parameters
	gPIEFreeAListFDesc.numOptParams := 0;			     // number of optional parameters
	gPIEFreeAListFDesc.paramNames := @gpnListIndex;		     // pointer to parameter names list
	gPIEFreeAListFDesc.paramTypes := @gOneIntegerTypes;	     // pointer to parameters types list
	gPIEFreeAListFDesc.functionFlags := Options;	             // function options
        gPIEFreeAListFDesc.category := PIEcategory;
        gPIEFreeAListFDesc.neededProject := PIEneededProject;

       	gPIEFreeAListDesc  .name  :=PChar(ModelPrefix + 'L_FreeAList');		     // name of PIE
	gPIEFreeAListDesc  .PieType :=  kFunctionPIE;		     // PIE type: PIE function
	gPIEFreeAListDesc  .descriptor := @gPIEFreeAListFDesc;	     // pointer to descriptor
        gPIEFreeAListDesc.version := ANE_PIE_VERSION;
        gPIEFreeAListDesc.vendor  := PIEvendor;
        gPIEFreeAListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeAListDesc  ;             // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Add Item to a list
	gPIEAddFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEAddFDesc.name :=PChar(ModelPrefix + 'L_AddToList');	                // name of function
	gPIEAddFDesc.address := GPIEAddToListMMFun;		// function address
	gPIEAddFDesc.returnType := kPIEInteger;		        // return value type
	gPIEAddFDesc.numParams :=  2;			        // number of parameters
	gPIEAddFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEAddFDesc.paramNames := @gpnIndexValue;		// pointer to parameter names list
	gPIEAddFDesc.paramTypes := @gIntegerDouble;	        // pointer to parameters types list
	gPIEAddFDesc.functionFlags := Options;	                // function options
        gPIEAddFDesc.category := PIEcategory;
        gPIEAddFDesc.neededProject := PIEneededProject;

       	gPIEAddDesc.name  :=PChar(ModelPrefix + 'L_AddToList');		        // name of PIE
	gPIEAddDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEAddDesc.descriptor := @gPIEAddFDesc;	        // pointer to descriptor
        gPIEAddDesc.version := ANE_PIE_VERSION;
        gPIEAddDesc.vendor  := PIEvendor;
        gPIEAddDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAddDesc;                     // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Get Item From list
	gPIEGetFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetFDesc.name :=PChar(ModelPrefix + 'L_GetFromList');	                // name of function
	gPIEGetFDesc.address := GPIEGetFromListMMFun;		// function address
	gPIEGetFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetFDesc.numParams :=  2;			        // number of parameters
	gPIEGetFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetFDesc.paramNames := @gpn2Index;		        // pointer to parameter names list
	gPIEGetFDesc.paramTypes := @g2Integer;	                // pointer to parameters types list
	gPIEGetFDesc.functionFlags := Options;	                // function options
        gPIEGetFDesc.category := PIEcategory;
        gPIEGetFDesc.neededProject := PIEneededProject;

       	gPIEGetDesc.name  :=PChar(ModelPrefix + 'L_GetFromList');		        // name of PIE
	gPIEGetDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEGetDesc.descriptor := @gPIEGetFDesc;	        // pointer to descriptor
        gPIEGetDesc.version := ANE_PIE_VERSION;
        gPIEGetDesc.vendor  := PIEvendor;
        gPIEGetDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetDesc;                     // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Set List Item
	gPIESetListItemFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIESetListItemFDesc.name :=PChar(ModelPrefix + 'L_SetListItem');	                // name of function
	gPIESetListItemFDesc.address := GPIESetListItemMMFun;		// function address
	gPIESetListItemFDesc.returnType := kPIEBoolean;		        // return value type
	gPIESetListItemFDesc.numParams :=  3;			        // number of parameters
	gPIESetListItemFDesc.numOptParams := 0;			        // number of optional parameters
	gPIESetListItemFDesc.paramNames := @gpn2IndexValue;		// pointer to parameter names list
	gPIESetListItemFDesc.paramTypes := @g2IntegerValue;	        // pointer to parameters types list
	gPIESetListItemFDesc.functionFlags := Options;	                // function options
        gPIESetListItemFDesc.category := PIEcategory;
        gPIESetListItemFDesc.neededProject := PIEneededProject;

       	gPIESetListItemDesc.name  :=PChar(ModelPrefix + 'L_SetListItem');		        // name of PIE
	gPIESetListItemDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIESetListItemDesc.descriptor := @gPIESetListItemFDesc;	// pointer to descriptor
        gPIESetListItemDesc.version := ANE_PIE_VERSION;
        gPIESetListItemDesc.vendor  := PIEvendor;
        gPIESetListItemDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESetListItemDesc;                     // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Remove List Item
	gPIERemoveListItemFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIERemoveListItemFDesc.name :=PChar(ModelPrefix + 'L_DeleteListItem');	                // name of function
	gPIERemoveListItemFDesc.address := GPIERemoveListItemMMFun;		// function address
	gPIERemoveListItemFDesc.returnType := kPIEBoolean;		        // return value type
	gPIERemoveListItemFDesc.numParams :=  1;			        // number of parameters
	gPIERemoveListItemFDesc.numOptParams := 1;			        // number of optional parameters
	gPIERemoveListItemFDesc.paramNames := @gpn2Index;		        // pointer to parameter names list
	gPIERemoveListItemFDesc.paramTypes := @g2Integer;	                // pointer to parameters types list
	gPIERemoveListItemFDesc.functionFlags := Options;	                // function options
        gPIERemoveListItemFDesc.category := PIEcategory;
        gPIERemoveListItemFDesc.neededProject := PIEneededProject;

       	gPIERemoveListItemDesc.name  :=PChar(ModelPrefix + 'L_DeleteListItem');		        // name of PIE
	gPIERemoveListItemDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIERemoveListItemDesc.descriptor := @gPIERemoveListItemFDesc;	        // pointer to descriptor
        gPIERemoveListItemDesc.version := ANE_PIE_VERSION;
        gPIERemoveListItemDesc.vendor  := PIEvendor;
        gPIERemoveListItemDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIERemoveListItemDesc;                          // add descriptor to list
        Inc(numNames);	                                                        // increment number of names

        // Sort List
	gPIESortListFDesc.version := FUNCTION_PIE_VERSION;	// Function PIE Version
	gPIESortListFDesc.name :=PChar(ModelPrefix + 'L_SortList');	                // name of function
	gPIESortListFDesc.address := GPIESortListMMFun;		// function address
	gPIESortListFDesc.returnType := kPIEBoolean;		// return value type
	gPIESortListFDesc.numParams :=  1;			// number of parameters
	gPIESortListFDesc.numOptParams := 0;			// number of optional parameters
	gPIESortListFDesc.paramNames := @gpnListIndex;		// pointer to parameter names list
	gPIESortListFDesc.paramTypes := @gOneIntegerTypes;	// pointer to parameters types list
	gPIESortListFDesc.functionFlags := Options;	        // function options
        gPIESortListFDesc.category := PIEcategory;
        gPIESortListFDesc.neededProject := PIEneededProject;

       	gPIESortListDesc.name  :=PChar(ModelPrefix + 'L_SortList');		        // name of PIE
	gPIESortListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIESortListDesc.descriptor := @gPIESortListFDesc;	// pointer to descriptor
        gPIESortListDesc.version := ANE_PIE_VERSION;
        gPIESortListDesc.vendor  := PIEvendor;
        gPIESortListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESortListDesc;                // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Eliminate Duplicates From List
	gPIEEliminateDuplicatesFDesc.version := FUNCTION_PIE_VERSION;	          // Function PIE Version
	gPIEEliminateDuplicatesFDesc.name :=PChar(ModelPrefix + 'L_EliminateDuplicates');	          // name of function
	gPIEEliminateDuplicatesFDesc.address := GPIEEliminateDuplicatesMMFun ;	  // function address
	gPIEEliminateDuplicatesFDesc.returnType := kPIEBoolean;		          // return value type
	gPIEEliminateDuplicatesFDesc.numParams :=  1;			          // number of parameters
	gPIEEliminateDuplicatesFDesc.numOptParams := 0;			          // number of optional parameters
	gPIEEliminateDuplicatesFDesc.paramNames := @gpnListIndex;		  // pointer to parameter names list
	gPIEEliminateDuplicatesFDesc.paramTypes := @gOneIntegerTypes;	          // pointer to parameters types list
	gPIEEliminateDuplicatesFDesc.functionFlags := Options;	                  // function options
        gPIEEliminateDuplicatesFDesc.category := PIEcategory;
        gPIEEliminateDuplicatesFDesc.neededProject := PIEneededProject;

       	gPIEEliminateDuplicatesDesc.name  :=PChar(ModelPrefix + 'L_EliminateDuplicates');		  // name of PIE
	gPIEEliminateDuplicatesDesc.PieType :=  kFunctionPIE;		          // PIE type: PIE function
	gPIEEliminateDuplicatesDesc.descriptor := @gPIEEliminateDuplicatesFDesc;  // pointer to descriptor
        gPIEEliminateDuplicatesDesc.version := ANE_PIE_VERSION;
        gPIEEliminateDuplicatesDesc.vendor  := PIEvendor;
        gPIEEliminateDuplicatesDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEEliminateDuplicatesDesc;     // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Get Index of an Item
	gPIEIndexOfFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEIndexOfFDesc.name :=PChar(ModelPrefix + 'L_IndexOf');	                // name of function
	gPIEIndexOfFDesc.address := GPIEIndexOfMMFun ;		// function address
	gPIEIndexOfFDesc.returnType := kPIEInteger;		        // return value type
	gPIEIndexOfFDesc.numParams :=  2;			        // number of parameters
	gPIEIndexOfFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEIndexOfFDesc.paramNames := @gpnIndexValue;		// pointer to parameter names list
	gPIEIndexOfFDesc.paramTypes := @gIntegerDouble;	        // pointer to parameters types list
	gPIEIndexOfFDesc.functionFlags := Options;	                // function options
        gPIEIndexOfFDesc.category := PIEcategory;
        gPIEIndexOfFDesc.neededProject := PIEneededProject;

       	gPIEIndexOfDesc.name  :=PChar(ModelPrefix + 'L_IndexOf');		        // name of PIE
	gPIEIndexOfDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEIndexOfDesc.descriptor := @gPIEIndexOfFDesc;	// pointer to descriptor
        gPIEIndexOfDesc.version := ANE_PIE_VERSION;
        gPIEIndexOfDesc.vendor  := PIEvendor;
        gPIEIndexOfDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEIndexOfDesc;                     // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get Index of an Item from an unsorted list
	gPIEUnsortedIndexOfFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEUnsortedIndexOfFDesc.name :=PChar(ModelPrefix + 'L_UnsortedIndexOf');	                // name of function
	gPIEUnsortedIndexOfFDesc.address := GPIEUnsortedIndexOfMMFun ;		// function address
	gPIEUnsortedIndexOfFDesc.returnType := kPIEInteger;		        // return value type
	gPIEUnsortedIndexOfFDesc.numParams :=  2;			        // number of parameters
	gPIEUnsortedIndexOfFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEUnsortedIndexOfFDesc.paramNames := @gpnIndexValue;		// pointer to parameter names list
	gPIEUnsortedIndexOfFDesc.paramTypes := @gIntegerDouble;	        // pointer to parameters types list
	gPIEUnsortedIndexOfFDesc.functionFlags := Options;	                // function options
        gPIEUnsortedIndexOfFDesc.category := PIEcategory;
        gPIEUnsortedIndexOfFDesc.neededProject := PIEneededProject;

       	gPIEUnsortedIndexOfDesc.name  :=PChar(ModelPrefix + 'L_UnsortedIndexOf');		        // name of PIE
	gPIEUnsortedIndexOfDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEUnsortedIndexOfDesc.descriptor := @gPIEUnsortedIndexOfFDesc;	// pointer to descriptor
        gPIEUnsortedIndexOfDesc.version := ANE_PIE_VERSION;
        gPIEUnsortedIndexOfDesc.vendor  := PIEvendor;
        gPIEUnsortedIndexOfDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEUnsortedIndexOfDesc;                     // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        //Free List all lists
	gPIEFreeListFDesc.version := FUNCTION_PIE_VERSION;	// Function PIE Version
	gPIEFreeListFDesc.name :=PChar(ModelPrefix + 'L_FreeAllLists');	        // name of function
	gPIEFreeListFDesc.address := GListFreeMMFun;	        // function address
	gPIEFreeListFDesc.returnType := kPIEBoolean;		// return value type
	gPIEFreeListFDesc.numParams :=  0;			// number of parameters
	gPIEFreeListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeListFDesc.paramNames := nil;		        // pointer to parameter names list
	gPIEFreeListFDesc.paramTypes := nil;	                // pointer to parameters types list
	gPIEFreeListFDesc.functionFlags := Options;	        // function options
        gPIEFreeListFDesc.category := PIEcategory;
        gPIEFreeListFDesc.neededProject := PIEneededProject;

       	gPIEFreeListDesc.name  :=PChar(ModelPrefix + 'L_FreeAllLists');		// name of PIE
	gPIEFreeListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEFreeListDesc.descriptor := @gPIEFreeListFDesc;	// pointer to descriptor
        gPIEFreeListDesc.version := ANE_PIE_VERSION;
        gPIEFreeListDesc.vendor  := PIEvendor;
        gPIEFreeListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeListDesc;                // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        //------------------------- 3D List functions

        // Create a 3D List
	gPIECreate3DListFDesc.version := FUNCTION_PIE_VERSION;	// Function PIE Version
	gPIECreate3DListFDesc.name :=PChar(ModelPrefix + 'L_CreateNew3DList');	        // name of function
	gPIECreate3DListFDesc.address := G3DListCreateMMFun;	// function address
	gPIECreate3DListFDesc.returnType := kPIEInteger;		// return value type
	gPIECreate3DListFDesc.numParams :=  3;			// number of parameters
	gPIECreate3DListFDesc.numOptParams := 0;			// number of optional parameters
	gPIECreate3DListFDesc.paramNames := @gpn3Max;		        // pointer to parameter names list
	gPIECreate3DListFDesc.paramTypes := @g3Integer;	                // pointer to parameters types list
	gPIECreate3DListFDesc.functionFlags := Options;	        // function options
        gPIECreate3DListFDesc.category := PIEcategory;
        gPIECreate3DListFDesc.neededProject := PIEneededProject;

       	gPIECreate3DListDesc.name  :=PChar(ModelPrefix + 'L_CreateNew3DList');		// name of PIE
	gPIECreate3DListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECreate3DListDesc.descriptor := @gPIECreate3DListFDesc;	// pointer to descriptor
        gPIECreate3DListDesc.version := ANE_PIE_VERSION;
        gPIECreate3DListDesc.vendor  := PIEvendor;
        gPIECreate3DListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECreate3DListDesc;              // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Free all items in a 3D List;
	gPIEFreeA3DListFDesc.version := FUNCTION_PIE_VERSION;	     // Function PIE Version
	gPIEFreeA3DListFDesc.name :=PChar(ModelPrefix + 'L_FreeA3DList');	             // name of function
	gPIEFreeA3DListFDesc.address := GPIEFree3DListMMFun ;	     // function address
	gPIEFreeA3DListFDesc.returnType := kPIEBoolean;		     // return value type
	gPIEFreeA3DListFDesc.numParams :=  1;			     // number of parameters
	gPIEFreeA3DListFDesc.numOptParams := 0;			     // number of optional parameters
	gPIEFreeA3DListFDesc.paramNames := @gpnListIndex;		     // pointer to parameter names list
	gPIEFreeA3DListFDesc.paramTypes := @gOneIntegerTypes;	     // pointer to parameters types list
	gPIEFreeA3DListFDesc.functionFlags := Options;	             // function options
        gPIEFreeA3DListFDesc.category := PIEcategory;
        gPIEFreeA3DListFDesc.neededProject := PIEneededProject;

       	gPIEFreeA3DListDesc.name  :=PChar(ModelPrefix + 'L_FreeA3DList');		     // name of PIE
	gPIEFreeA3DListDesc.PieType :=  kFunctionPIE;		     // PIE type: PIE function
	gPIEFreeA3DListDesc.descriptor := @gPIEFreeA3DListFDesc;	     // pointer to descriptor
        gPIEFreeA3DListDesc.version := ANE_PIE_VERSION;
        gPIEFreeA3DListDesc.vendor  := PIEvendor;
        gPIEFreeA3DListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeA3DListDesc  ;             // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Get Item From 3D list
	gPIEGet3DListItemFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGet3DListItemFDesc.name :=PChar(ModelPrefix + 'L_GetFrom3DList');	                // name of function
	gPIEGet3DListItemFDesc.address := GPIEGetFrom3DListMMFun;		// function address
	gPIEGet3DListItemFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGet3DListItemFDesc.numParams :=  4;			        // number of parameters
	gPIEGet3DListItemFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGet3DListItemFDesc.paramNames := @gpn4Index;		        // pointer to parameter names list
	gPIEGet3DListItemFDesc.paramTypes := @g4Integer;	                // pointer to parameters types list
	gPIEGet3DListItemFDesc.functionFlags := Options;	                // function options
        gPIEGet3DListItemFDesc.category := PIEcategory;
        gPIEGet3DListItemFDesc.neededProject := PIEneededProject;

       	gPIEGet3DListItemDesc.name  :=PChar(ModelPrefix + 'L_GetFrom3DList');		        // name of PIE
	gPIEGet3DListItemDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEGet3DListItemDesc.descriptor := @gPIEGet3DListItemFDesc;	        // pointer to descriptor
        gPIEGet3DListItemDesc.version := ANE_PIE_VERSION;
        gPIEGet3DListItemDesc.vendor  := PIEvendor;
        gPIEGet3DListItemDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGet3DListItemDesc;                     // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Get Item From One-based 3D list
	gPIEGetOneBased3DListItemFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIEGetOneBased3DListItemFDesc.name :=PChar(ModelPrefix + 'L_GetFromOneBased3DList');	                // name of function
	gPIEGetOneBased3DListItemFDesc.address := GPIEGetFromOneBased3DListMMFun;		// function address
	gPIEGetOneBased3DListItemFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetOneBased3DListItemFDesc.numParams :=  4;			        // number of parameters
	gPIEGetOneBased3DListItemFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetOneBased3DListItemFDesc.paramNames := @gpn4Index;		        // pointer to parameter names list
	gPIEGetOneBased3DListItemFDesc.paramTypes := @g4Integer;	                // pointer to parameters types list
	gPIEGetOneBased3DListItemFDesc.functionFlags := Options;	                // function options
        gPIEGetOneBased3DListItemFDesc.category := PIEcategory;
        gPIEGetOneBased3DListItemFDesc.neededProject := PIEneededProject;

       	gPIEGetOneBased3DListItemDesc.name  :=PChar(ModelPrefix + 'L_GetFromOneBased3DList');		        // name of PIE
	gPIEGetOneBased3DListItemDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEGetOneBased3DListItemDesc.descriptor := @gPIEGetOneBased3DListItemFDesc;	        // pointer to descriptor
        gPIEGetOneBased3DListItemDesc.version := ANE_PIE_VERSION;
        gPIEGetOneBased3DListItemDesc.vendor  := PIEvendor;
        gPIEGetOneBased3DListItemDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetOneBased3DListItemDesc;                     // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Set 3D List Item
	gPIESet3DListItemFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIESet3DListItemFDesc.name :=PChar(ModelPrefix + 'L_Set3DListItem');	                // name of function
	gPIESet3DListItemFDesc.address := GPIESet3DListItemMMFun;		// function address
	gPIESet3DListItemFDesc.returnType := kPIEBoolean;		        // return value type
	gPIESet3DListItemFDesc.numParams :=  5;			        // number of parameters
	gPIESet3DListItemFDesc.numOptParams := 0;			        // number of optional parameters
	gPIESet3DListItemFDesc.paramNames := @gpn4IndexValue;		// pointer to parameter names list
	gPIESet3DListItemFDesc.paramTypes := @g4IntegerFloat;	        // pointer to parameters types list
	gPIESet3DListItemFDesc.functionFlags := Options;	                // function options
        gPIESet3DListItemFDesc.category := PIEcategory;
        gPIESet3DListItemFDesc.neededProject := PIEneededProject;

       	gPIESet3DListItemDesc.name  :=PChar(ModelPrefix + 'L_Set3DListItem');		        // name of PIE
	gPIESet3DListItemDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIESet3DListItemDesc.descriptor := @gPIESet3DListItemFDesc;	// pointer to descriptor
        gPIESet3DListItemDesc.version := ANE_PIE_VERSION;
        gPIESet3DListItemDesc.vendor  := PIEvendor;
        gPIESet3DListItemDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESet3DListItemDesc;                     // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Set One-Based 3D List Item
	gPIESetOneBased3DListItemFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIESetOneBased3DListItemFDesc.name :=PChar(ModelPrefix + 'L_SetOneBased3DListItem');	                // name of function
	gPIESetOneBased3DListItemFDesc.address := GPIESetOneBased3DListItemMMFun;		// function address
	gPIESetOneBased3DListItemFDesc.returnType := kPIEBoolean;		        // return value type
	gPIESetOneBased3DListItemFDesc.numParams :=  5;			        // number of parameters
	gPIESetOneBased3DListItemFDesc.numOptParams := 0;			        // number of optional parameters
	gPIESetOneBased3DListItemFDesc.paramNames := @gpn4IndexValue;		// pointer to parameter names list
	gPIESetOneBased3DListItemFDesc.paramTypes := @g4IntegerFloat;	        // pointer to parameters types list
	gPIESetOneBased3DListItemFDesc.functionFlags := Options;	                // function options
        gPIESetOneBased3DListItemFDesc.category := PIEcategory;
        gPIESetOneBased3DListItemFDesc.neededProject := PIEneededProject;

       	gPIESetOneBased3DListItemDesc.name  :=PChar(ModelPrefix + 'L_SetOneBased3DListItem');		        // name of PIE
	gPIESetOneBased3DListItemDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIESetOneBased3DListItemDesc.descriptor := @gPIESetOneBased3DListItemFDesc;	// pointer to descriptor
        gPIESetOneBased3DListItemDesc.version := ANE_PIE_VERSION;
        gPIESetOneBased3DListItemDesc.vendor  := PIEvendor;
        gPIESetOneBased3DListItemDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESetOneBased3DListItemDesc;                     // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Set all items in a 3D List to 0;
	gPIEReset3DListFDesc.version := FUNCTION_PIE_VERSION;	     // Function PIE Version
	gPIEReset3DListFDesc.name :=PChar(ModelPrefix + 'L_ResetA3DList');	             // name of function
	gPIEReset3DListFDesc.address := GPIEReset3DListMMFun ;	     // function address
	gPIEReset3DListFDesc.returnType := kPIEBoolean;		     // return value type
	gPIEReset3DListFDesc.numParams :=  1;			     // number of parameters
	gPIEReset3DListFDesc.numOptParams := 0;			     // number of optional parameters
	gPIEReset3DListFDesc.paramNames := @gpnListIndex;		     // pointer to parameter names list
	gPIEReset3DListFDesc.paramTypes := @gOneIntegerTypes;	     // pointer to parameters types list
	gPIEReset3DListFDesc.functionFlags := Options;	             // function options
        gPIEReset3DListFDesc.category := PIEcategory;
        gPIEReset3DListFDesc.neededProject := PIEneededProject;

       	gPIEReset3DListDesc.name  :=PChar(ModelPrefix + 'L_ResetA3DList');		     // name of PIE
	gPIEReset3DListDesc.PieType :=  kFunctionPIE;		     // PIE type: PIE function
	gPIEReset3DListDesc.descriptor := @gPIEReset3DListFDesc;	     // pointer to descriptor
        gPIEReset3DListDesc.version := ANE_PIE_VERSION;
        gPIEReset3DListDesc.vendor  := PIEvendor;
        gPIEReset3DListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEReset3DListDesc  ;             // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // get a count of the errors that have occurred
	gPIEGetErrorCountFDesc.version := FUNCTION_PIE_VERSION;	     // Function PIE Version
	gPIEGetErrorCountFDesc.name :=PChar(ModelPrefix + 'L_GetErrorCount');	             // name of function
	gPIEGetErrorCountFDesc.address := GListErrorCountMMFun ;	     // function address
	gPIEGetErrorCountFDesc.returnType := kPIEInteger;		     // return value type
	gPIEGetErrorCountFDesc.numParams :=  0;			     // number of parameters
	gPIEGetErrorCountFDesc.numOptParams := 0;			     // number of optional parameters
	gPIEGetErrorCountFDesc.paramNames := nil;		     // pointer to parameter names list
	gPIEGetErrorCountFDesc.paramTypes := nil;	     // pointer to parameters types list
	gPIEGetErrorCountFDesc.functionFlags := Options;	             // function options
        gPIEGetErrorCountFDesc.category := PIEcategory;
        gPIEGetErrorCountFDesc.neededProject := PIEneededProject;

       	gPIEGetErrorCountDesc.name  :=PChar(ModelPrefix + 'L_GetErrorCount');		     // name of PIE
	gPIEGetErrorCountDesc.PieType :=  kFunctionPIE;		     // PIE type: PIE function
	gPIEGetErrorCountDesc.descriptor := @gPIEGetErrorCountFDesc;	     // pointer to descriptor
        gPIEGetErrorCountDesc.version := ANE_PIE_VERSION;
        gPIEGetErrorCountDesc.vendor  := PIEvendor;
        gPIEGetErrorCountDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetErrorCountDesc  ;             // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Add two 3d Lists
	gPIEAdd3DListFDesc.version := FUNCTION_PIE_VERSION;	     // Function PIE Version
	gPIEAdd3DListFDesc.name :=PChar(ModelPrefix + 'L_Add3DLists');	             // name of function
	gPIEAdd3DListFDesc.address := GPIEAdd3DListsMMFun ;	     // function address
	gPIEAdd3DListFDesc.returnType := kPIEBoolean;		     // return value type
	gPIEAdd3DListFDesc.numParams :=  3;			     // number of parameters
	gPIEAdd3DListFDesc.numOptParams := 0;			     // number of optional parameters
	gPIEAdd3DListFDesc.paramNames := @gpn3Lists;		     // pointer to parameter names list
	gPIEAdd3DListFDesc.paramTypes := @g3Integer;	     // pointer to parameters types list
	gPIEAdd3DListFDesc.functionFlags := Options;	             // function options
        gPIEAdd3DListFDesc.category := PIEcategory;
        gPIEAdd3DListFDesc.neededProject := PIEneededProject;

       	gPIEAdd3DListDesc.name  :=PChar(ModelPrefix + 'L_Add3DLists');		     // name of PIE
	gPIEAdd3DListDesc.PieType :=  kFunctionPIE;		     // PIE type: PIE function
	gPIEAdd3DListDesc.descriptor := @gPIEAdd3DListFDesc;	     // pointer to descriptor
        gPIEAdd3DListDesc.version := ANE_PIE_VERSION;
        gPIEAdd3DListDesc.vendor  := PIEvendor;
        gPIEAdd3DListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAdd3DListDesc  ;             // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // subtract second 3d list from first 3d list
	gPIESubtract3DListFDesc.version := FUNCTION_PIE_VERSION;	     // Function PIE Version
	gPIESubtract3DListFDesc.name :=PChar(ModelPrefix + 'L_Subtract3DLists');	             // name of function
	gPIESubtract3DListFDesc.address := GPIESubtract3DListsMMFun ;	     // function address
	gPIESubtract3DListFDesc.returnType := kPIEBoolean;		     // return value type
	gPIESubtract3DListFDesc.numParams :=  3;			     // number of parameters
	gPIESubtract3DListFDesc.numOptParams := 0;			     // number of optional parameters
	gPIESubtract3DListFDesc.paramNames := @gpn3Lists;		     // pointer to parameter names list
	gPIESubtract3DListFDesc.paramTypes := @g3Integer;	     // pointer to parameters types list
	gPIESubtract3DListFDesc.functionFlags := Options;	             // function options
        gPIESubtract3DListFDesc.category := PIEcategory;
        gPIESubtract3DListFDesc.neededProject := PIEneededProject;

       	gPIESubtract3DListDesc.name  :=PChar(ModelPrefix + 'L_Subtract3DLists');		     // name of PIE
	gPIESubtract3DListDesc.PieType :=  kFunctionPIE;		     // PIE type: PIE function
	gPIESubtract3DListDesc.descriptor := @gPIESubtract3DListFDesc;	     // pointer to descriptor
        gPIESubtract3DListDesc.version := ANE_PIE_VERSION;
        gPIESubtract3DListDesc.vendor  := PIEvendor;
        gPIESubtract3DListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESubtract3DListDesc  ;             // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // multiply two 3d Lists
	gPIEMultiply3DListFDesc.version := FUNCTION_PIE_VERSION;	     // Function PIE Version
	gPIEMultiply3DListFDesc.name :=PChar(ModelPrefix + 'L_Multiply3DLists');	             // name of function
	gPIEMultiply3DListFDesc.address := GPIEMultiply3DListsMMFun ;	     // function address
	gPIEMultiply3DListFDesc.returnType := kPIEBoolean;		     // return value type
	gPIEMultiply3DListFDesc.numParams :=  3;			     // number of parameters
	gPIEMultiply3DListFDesc.numOptParams := 0;			     // number of optional parameters
	gPIEMultiply3DListFDesc.paramNames := @gpn3Lists;		     // pointer to parameter names list
	gPIEMultiply3DListFDesc.paramTypes := @g3Integer;	     // pointer to parameters types list
	gPIEMultiply3DListFDesc.functionFlags := Options;	             // function options
        gPIEMultiply3DListFDesc.category := PIEcategory;
        gPIEMultiply3DListFDesc.neededProject := PIEneededProject;

       	gPIEMultiply3DListDesc.name  :=PChar(ModelPrefix + 'L_Multiply3DLists');		     // name of PIE
	gPIEMultiply3DListDesc.PieType :=  kFunctionPIE;		     // PIE type: PIE function
	gPIEMultiply3DListDesc.descriptor := @gPIEMultiply3DListFDesc;	     // pointer to descriptor
        gPIEMultiply3DListDesc.version := ANE_PIE_VERSION;
        gPIEMultiply3DListDesc.vendor  := PIEvendor;
        gPIEMultiply3DListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEMultiply3DListDesc  ;             // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // divide first 3d list by the second 3d list
	gPIEDivide3DListFDesc.version := FUNCTION_PIE_VERSION;	     // Function PIE Version
	gPIEDivide3DListFDesc.name :=PChar(ModelPrefix + 'L_Divide3DLists');	             // name of function
	gPIEDivide3DListFDesc.address := GPIEDivide3DListsMMFun ;	     // function address
	gPIEDivide3DListFDesc.returnType := kPIEBoolean;		     // return value type
	gPIEDivide3DListFDesc.numParams :=  3;			     // number of parameters
	gPIEDivide3DListFDesc.numOptParams := 0;			     // number of optional parameters
	gPIEDivide3DListFDesc.paramNames := @gpn3Lists;		     // pointer to parameter names list
	gPIEDivide3DListFDesc.paramTypes := @g3Integer;	     // pointer to parameters types list
	gPIEDivide3DListFDesc.functionFlags := Options;	             // function options
        gPIEDivide3DListFDesc.category := PIEcategory;
        gPIEDivide3DListFDesc.neededProject := PIEneededProject;

       	gPIEDivide3DListDesc.name  :=PChar(ModelPrefix + 'L_Divide3DLists');		     // name of PIE
	gPIEDivide3DListDesc.PieType :=  kFunctionPIE;		     // PIE type: PIE function
	gPIEDivide3DListDesc.descriptor := @gPIEDivide3DListFDesc;	     // pointer to descriptor
        gPIEDivide3DListDesc.version := ANE_PIE_VERSION;
        gPIEDivide3DListDesc.vendor  := PIEvendor;
        gPIEDivide3DListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEDivide3DListDesc  ;             // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // multiply 3d list by a constant
	gPIEMultiply3DListByConstantFDesc.version := FUNCTION_PIE_VERSION;	     // Function PIE Version
	gPIEMultiply3DListByConstantFDesc.name :=PChar(ModelPrefix + 'L_Multipy3DByConstant');	             // name of function
	gPIEMultiply3DListByConstantFDesc.address := GPIEMultiply3DListByConstantMMFun ;	     // function address
	gPIEMultiply3DListByConstantFDesc.returnType := kPIEBoolean;		     // return value type
	gPIEMultiply3DListByConstantFDesc.numParams :=  3;			     // number of parameters
	gPIEMultiply3DListByConstantFDesc.numOptParams := 0;			     // number of optional parameters
	gPIEMultiply3DListByConstantFDesc.paramNames := @gpn2ListIndexesValue;		     // pointer to parameter names list
	gPIEMultiply3DListByConstantFDesc.paramTypes := @g2IntegerValue;	     // pointer to parameters types list
	gPIEMultiply3DListByConstantFDesc.functionFlags := Options;	             // function options
        gPIEMultiply3DListByConstantFDesc.category := PIEcategory;
        gPIEMultiply3DListByConstantFDesc.neededProject := PIEneededProject;

       	gPIEMultiply3DListByConstantDesc.name  :=PChar(ModelPrefix + 'L_Multipy3DByConstant');		     // name of PIE
	gPIEMultiply3DListByConstantDesc.PieType :=  kFunctionPIE;		     // PIE type: PIE function
	gPIEMultiply3DListByConstantDesc.descriptor := @gPIEMultiply3DListByConstantFDesc;	     // pointer to descriptor
        gPIEMultiply3DListByConstantDesc.version := ANE_PIE_VERSION;
        gPIEMultiply3DListByConstantDesc.vendor  := PIEvendor;
        gPIEMultiply3DListByConstantDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEMultiply3DListByConstantDesc  ;             // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // invert each element in a 3d List
	gPIEInvert3DListFDesc.version := FUNCTION_PIE_VERSION;	     // Function PIE Version
	gPIEInvert3DListFDesc.name :=PChar(ModelPrefix + 'L_Invert3DListMembers');	             // name of function
	gPIEInvert3DListFDesc.address := GPIEInvert3DListMMFun ;	     // function address
	gPIEInvert3DListFDesc.returnType := kPIEBoolean;		     // return value type
	gPIEInvert3DListFDesc.numParams :=  2;			     // number of parameters
	gPIEInvert3DListFDesc.numOptParams := 0;			     // number of optional parameters
	gPIEInvert3DListFDesc.paramNames := @gpn2ListIndexesValue;		     // pointer to parameter names list
	gPIEInvert3DListFDesc.paramTypes := @g2IntegerValue;	     // pointer to parameters types list
	gPIEInvert3DListFDesc.functionFlags := Options;	             // function options
        gPIEInvert3DListFDesc.category := PIEcategory;
        gPIEInvert3DListFDesc.neededProject := PIEneededProject;

       	gPIEInvert3DListDesc.name  :=PChar(ModelPrefix + 'L_Invert3DListMembers');		     // name of PIE
	gPIEInvert3DListDesc.PieType :=  kFunctionPIE;		     // PIE type: PIE function
	gPIEInvert3DListDesc.descriptor := @gPIEInvert3DListFDesc;	     // pointer to descriptor
        gPIEInvert3DListDesc.version := ANE_PIE_VERSION;
        gPIEInvert3DListDesc.vendor  := PIEvendor;
        gPIEInvert3DListDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEInvert3DListDesc  ;             // add descriptor to list
        Inc(numNames);	                                        // increment number of names


        // Check that values are uniform when reduced to single precision
	gPIECheckUniformSinglePrecisionFDesc.version := FUNCTION_PIE_VERSION;	          // Function PIE Version
	gPIECheckUniformSinglePrecisionFDesc.name :=PChar(ModelPrefix + 'L_IsSingPrecUniform');	          // name of function
	gPIECheckUniformSinglePrecisionFDesc.address := GPIECheckUniformSingleMMFun ;	  // function address
	gPIECheckUniformSinglePrecisionFDesc.returnType := kPIEBoolean;		          // return value type
	gPIECheckUniformSinglePrecisionFDesc.numParams :=  1;			          // number of parameters
	gPIECheckUniformSinglePrecisionFDesc.numOptParams := 0;			          // number of optional parameters
	gPIECheckUniformSinglePrecisionFDesc.paramNames := @gpnListIndex;		  // pointer to parameter names list
	gPIECheckUniformSinglePrecisionFDesc.paramTypes := @gOneIntegerTypes;	          // pointer to parameters types list
	gPIECheckUniformSinglePrecisionFDesc.functionFlags := Options;	                  // function options
        gPIECheckUniformSinglePrecisionFDesc.category := PIEcategory;
        gPIECheckUniformSinglePrecisionFDesc.neededProject := PIEneededProject;

       	gPIECheckUniformSinglePrecisionDesc.name  :=PChar(ModelPrefix + 'L_IsSingPrecUniform');		  // name of PIE
	gPIECheckUniformSinglePrecisionDesc.PieType :=  kFunctionPIE;		          // PIE type: PIE function
	gPIECheckUniformSinglePrecisionDesc.descriptor := @gPIECheckUniformSinglePrecisionFDesc;  // pointer to descriptor
        gPIECheckUniformSinglePrecisionDesc.version := ANE_PIE_VERSION;
        gPIECheckUniformSinglePrecisionDesc.vendor  := PIEvendor;
        gPIECheckUniformSinglePrecisionDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECheckUniformSinglePrecisionDesc;     // add descriptor to list
        Inc(numNames);	                                        // increment number of names

	gPIECheckVersionFDesc.name := PChar(ModelPrefix + 'L_CheckVersion');	        // name of function
	gPIECheckVersionFDesc.address := GPIECheckVersionMMFun;		// function address
	gPIECheckVersionFDesc.returnType := kPIEBoolean;		// return value type
	gPIECheckVersionFDesc.numParams :=  4;			// number of parameters
	gPIECheckVersionFDesc.numOptParams := 0;			// number of optional parameters
	gPIECheckVersionFDesc.paramNames := @gpnFourDigit;		// pointer to parameter names list
	gPIECheckVersionFDesc.paramTypes := @gFourIntegerTypes;	// pointer to parameters types list
        gPIECheckVersionFDesc.version := FUNCTION_PIE_VERSION;
        gPIECheckVersionFDesc.functionFlags := Options;
        gPIECheckVersionFDesc.category := PIEcategory;
        gPIECheckVersionFDesc.neededProject := PIEneededProject;

       	gPIECheckVersionDesc.name  := PChar(ModelPrefix + 'L_CheckVersion');		// name of PIE
	gPIECheckVersionDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECheckVersionDesc.descriptor := @gPIECheckVersionFDesc;	// pointer to descriptor
        gPIECheckVersionDesc.version := ANE_PIE_VERSION;
        gPIECheckVersionDesc.vendor := PIEvendor;
        gPIECheckVersionDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECheckVersionDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names









	gPIEAddToNamedListFDesc.name := PChar(ModelPrefix + 'L_AddToNamedList');	        // name of function
	gPIEAddToNamedListFDesc.address := GPIEAddToNamedListMMFun ;		// function address
	gPIEAddToNamedListFDesc.returnType := kPIEInteger;		// return value type
	gPIEAddToNamedListFDesc.numParams :=  2;			// number of parameters
	gPIEAddToNamedListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEAddToNamedListFDesc.paramNames := @gpnNameNumber ;		// pointer to parameter names list
	gPIEAddToNamedListFDesc.paramTypes := @g1String1FloatTypes ;	// pointer to parameters types list
        gPIEAddToNamedListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEAddToNamedListFDesc.functionFlags := Options;
        gPIEAddToNamedListFDesc.category := PIEcategory;
        gPIEAddToNamedListFDesc.neededProject := PIEneededProject;

       	gPIEAddToNamedListDesc.name  := PChar(ModelPrefix + 'L_AddToNamedList');		// name of PIE
	gPIEAddToNamedListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEAddToNamedListDesc.descriptor := @gPIEAddToNamedListFDesc;	// pointer to descriptor
        gPIEAddToNamedListDesc.version := ANE_PIE_VERSION;
        gPIEAddToNamedListDesc.vendor := PIEvendor;
        gPIEAddToNamedListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAddToNamedListDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEGetFromNamedListFDesc.name := PChar(ModelPrefix + 'L_GetFromNamedList');	        // name of function
	gPIEGetFromNamedListFDesc.address := GPIEGetFromNamedList  ;		// function address
	gPIEGetFromNamedListFDesc.returnType := kPIEFloat;		// return value type
	gPIEGetFromNamedListFDesc.numParams :=  2;			// number of parameters
	gPIEGetFromNamedListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetFromNamedListFDesc.paramNames := @gpnNamePosition  ;		// pointer to parameter names list
	gPIEGetFromNamedListFDesc.paramTypes := @g1String1IntegerTypes  ;	// pointer to parameters types list
        gPIEGetFromNamedListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEGetFromNamedListFDesc.functionFlags := Options;
        gPIEGetFromNamedListFDesc.category := PIEcategory;
        gPIEGetFromNamedListFDesc.neededProject := PIEneededProject;

       	gPIEGetFromNamedListDesc.name  := PChar(ModelPrefix + 'L_GetFromNamedList');		// name of PIE
	gPIEGetFromNamedListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetFromNamedListDesc.descriptor := @gPIEGetFromNamedListFDesc ;	// pointer to descriptor
        gPIEGetFromNamedListDesc.version := ANE_PIE_VERSION;
        gPIEGetFromNamedListDesc.vendor := PIEvendor;
        gPIEGetFromNamedListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetFromNamedListDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names



        // Set named List Item
	gPIESetNamedItemFDesc.version := FUNCTION_PIE_VERSION;	        // Function PIE Version
	gPIESetNamedItemFDesc.name :=PChar(ModelPrefix + 'L_SetNamedListItem');	                // name of function
	gPIESetNamedItemFDesc.address := GPIESetNamedListItemMMFun;		// function address
	gPIESetNamedItemFDesc.returnType := kPIEBoolean;		        // return value type
	gPIESetNamedItemFDesc.numParams :=  3;			        // number of parameters
	gPIESetNamedItemFDesc.numOptParams := 0;			        // number of optional parameters
	gPIESetNamedItemFDesc.paramNames := @gpnNamePositionValue;		// pointer to parameter names list
	gPIESetNamedItemFDesc.paramTypes := @g1String1Integer1RealTypes;	        // pointer to parameters types list
	gPIESetNamedItemFDesc.functionFlags := Options;	                // function options
        gPIESetNamedItemFDesc.category := PIEcategory;
        gPIESetNamedItemFDesc.neededProject := PIEneededProject;

       	gPIESetNamedItemDesc.name  :=PChar(ModelPrefix + 'L_SetNamedListItem');		        // name of PIE
	gPIESetNamedItemDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIESetNamedItemDesc.descriptor := @gPIESetNamedItemFDesc;	// pointer to descriptor
        gPIESetNamedItemDesc.version := ANE_PIE_VERSION;
        gPIESetNamedItemDesc.vendor  := PIEvendor;
        gPIESetNamedItemDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESetNamedItemDesc;                     // add descriptor to list
        Inc(numNames);	                                                // increment number of names






	gPIENamedListCountFDesc.name := PChar(ModelPrefix + 'L_GetNamedListCount');	        // name of function
	gPIENamedListCountFDesc.address := GPIEGetNamedListCount   ;		// function address
	gPIENamedListCountFDesc.returnType := kPIEInteger;		// return value type
	gPIENamedListCountFDesc.numParams :=  1;			// number of parameters
	gPIENamedListCountFDesc.numOptParams := 0;			// number of optional parameters
	gPIENamedListCountFDesc.paramNames := @gpnName   ;		// pointer to parameter names list
	gPIENamedListCountFDesc.paramTypes := @g1StringTypes   ;	// pointer to parameters types list
        gPIENamedListCountFDesc.version := FUNCTION_PIE_VERSION;
        gPIENamedListCountFDesc.functionFlags := Options;
        gPIENamedListCountFDesc.category := PIEcategory;
        gPIENamedListCountFDesc.neededProject := PIEneededProject;

       	gPIENamedListCountDesc.name  := PChar(ModelPrefix + 'L_GetNamedListCount');		// name of PIE
	gPIENamedListCountDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIENamedListCountDesc.descriptor := @gPIENamedListCountFDesc ;	// pointer to descriptor
        gPIENamedListCountDesc.version := ANE_PIE_VERSION;
        gPIENamedListCountDesc.vendor := PIEvendor;
        gPIENamedListCountDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIENamedListCountDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEFreeNamedListFDesc.name := PChar(ModelPrefix + 'L_FreeNamedList');	        // name of function
	gPIEFreeNamedListFDesc.address := GPIEFreeNamedList   ;		// function address
	gPIEFreeNamedListFDesc.returnType := kPIEBoolean;		// return value type
	gPIEFreeNamedListFDesc.numParams :=  1;			// number of parameters
	gPIEFreeNamedListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeNamedListFDesc.paramNames := @gpnName   ;		// pointer to parameter names list
	gPIEFreeNamedListFDesc.paramTypes := @g1StringTypes   ;	// pointer to parameters types list
        gPIEFreeNamedListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEFreeNamedListFDesc.functionFlags := Options;
        gPIEFreeNamedListFDesc.category := PIEcategory;
        gPIEFreeNamedListFDesc.neededProject := PIEneededProject;

       	gPIEFreeNamedListDesc.name  := PChar(ModelPrefix + 'L_FreeNamedList');		// name of PIE
	gPIEFreeNamedListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEFreeNamedListDesc.descriptor := @gPIEFreeNamedListFDesc ;	// pointer to descriptor
        gPIEFreeNamedListDesc.version := ANE_PIE_VERSION;
        gPIEFreeNamedListDesc.vendor := PIEvendor;
        gPIEFreeNamedListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeNamedListDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEGetNumberOfNamedListsFDesc.name := PChar(ModelPrefix + 'L_GetNumberOfNamedLists');	        // name of function
	gPIEGetNumberOfNamedListsFDesc.address := GPIEGetNumberOfNamedLists   ;		// function address
	gPIEGetNumberOfNamedListsFDesc.returnType := kPIEInteger;		// return value type
	gPIEGetNumberOfNamedListsFDesc.numParams :=  0;			// number of parameters
	gPIEGetNumberOfNamedListsFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetNumberOfNamedListsFDesc.paramNames := @gpnName   ;		// pointer to parameter names list
	gPIEGetNumberOfNamedListsFDesc.paramTypes := @g1StringTypes   ;	// pointer to parameters types list
        gPIEGetNumberOfNamedListsFDesc.version := FUNCTION_PIE_VERSION;
        gPIEGetNumberOfNamedListsFDesc.functionFlags := Options;
        gPIEGetNumberOfNamedListsFDesc.category := PIEcategory;
        gPIEGetNumberOfNamedListsFDesc.neededProject := PIEneededProject;

       	gPIEGetNumberOfNamedListsDesc.name  := PChar(ModelPrefix + 'L_GetNumberOfNamedLists');		// name of PIE
	gPIEGetNumberOfNamedListsDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetNumberOfNamedListsDesc.descriptor := @gPIEGetNumberOfNamedListsFDesc  ;	// pointer to descriptor
        gPIEGetNumberOfNamedListsDesc.version := ANE_PIE_VERSION;
        gPIEGetNumberOfNamedListsDesc.vendor := PIEvendor;
        gPIEGetNumberOfNamedListsDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetNumberOfNamedListsDesc    ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEGetNameOfListFDesc.name := PChar(ModelPrefix + 'L_GetNameOfList');	        // name of function
	gPIEGetNameOfListFDesc.address := GPIEGetNameOfList   ;		// function address
	gPIEGetNameOfListFDesc.returnType := kPIEString;		// return value type
	gPIEGetNameOfListFDesc.numParams :=  1;			// number of parameters
	gPIEGetNameOfListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetNameOfListFDesc.paramNames := @gpnListIndex   ;		// pointer to parameter names list
	gPIEGetNameOfListFDesc.paramTypes := @gOneIntegerTypes   ;	// pointer to parameters types list
        gPIEGetNameOfListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEGetNameOfListFDesc.functionFlags := Options;
        gPIEGetNameOfListFDesc.category := PIEcategory;
        gPIEGetNameOfListFDesc.neededProject := PIEneededProject;

       	gPIEGetNameOfListDesc.name  := PChar(ModelPrefix + 'L_GetNameOfList');		// name of PIE
	gPIEGetNameOfListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetNameOfListDesc.descriptor := @gPIEGetNameOfListFDesc  ;	// pointer to descriptor
        gPIEGetNameOfListDesc.version := ANE_PIE_VERSION;
        gPIEGetNameOfListDesc.vendor := PIEvendor;
        gPIEGetNameOfListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetNameOfListDesc    ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEFreeNamedListsFDesc.name := PChar(ModelPrefix + 'L_FreeNamedLists');	        // name of function
	gPIEFreeNamedListsFDesc.address := GListFreeNamedLists   ;		// function address
	gPIEFreeNamedListsFDesc.returnType := kPIEBoolean;		// return value type
	gPIEFreeNamedListsFDesc.numParams :=  0;			// number of parameters
	gPIEFreeNamedListsFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeNamedListsFDesc.paramNames := @gpnListIndex   ;		// pointer to parameter names list
	gPIEFreeNamedListsFDesc.paramTypes := @gOneIntegerTypes   ;	// pointer to parameters types list
        gPIEFreeNamedListsFDesc.version := FUNCTION_PIE_VERSION;
        gPIEFreeNamedListsFDesc.functionFlags := Options;
        gPIEFreeNamedListsFDesc.category := PIEcategory;
        gPIEFreeNamedListsFDesc.neededProject := PIEneededProject;

       	gPIEFreeNamedListsDesc.name  := PChar(ModelPrefix + 'L_FreeNamedLists');		// name of PIE
	gPIEFreeNamedListsDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEFreeNamedListsDesc.descriptor := @gPIEFreeNamedListsFDesc   ;	// pointer to descriptor
        gPIEFreeNamedListsDesc.version := ANE_PIE_VERSION;
        gPIEFreeNamedListsDesc.vendor := PIEvendor;
        gPIEFreeNamedListsDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeNamedListsDesc      ;  // add descriptor to list
        Inc(numNames);	// increment number of names











	gPIEAddToNamedStringListFDesc.name := PChar(ModelPrefix + 'L_AddToNamedStringList');	        // name of function
	gPIEAddToNamedStringListFDesc.address := GPIEAddToNamedStringListMMFun ;		// function address
	gPIEAddToNamedStringListFDesc.returnType := kPIEInteger;		// return value type
	gPIEAddToNamedStringListFDesc.numParams :=  2;			// number of parameters
	gPIEAddToNamedStringListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEAddToNamedStringListFDesc.paramNames := @gpnNameString ;		// pointer to parameter names StringList
	gPIEAddToNamedStringListFDesc.paramTypes := @g2StringTypes ;	// pointer to parameters types list
        gPIEAddToNamedStringListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEAddToNamedStringListFDesc.functionFlags := Options;
        gPIEAddToNamedStringListFDesc.category := PIEcategory;
        gPIEAddToNamedStringListFDesc.neededProject := PIEneededProject;

       	gPIEAddToNamedStringListDesc.name  := PChar(ModelPrefix + 'L_AddToNamedStringList');		// name of PIE
	gPIEAddToNamedStringListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEAddToNamedStringListDesc.descriptor := @gPIEAddToNamedStringListFDesc;	// pointer to descriptor
        gPIEAddToNamedStringListDesc.version := ANE_PIE_VERSION;
        gPIEAddToNamedStringListDesc.vendor := PIEvendor;
        gPIEAddToNamedStringListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAddToNamedStringListDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEGetFromNamedStringListFDesc.name := PChar(ModelPrefix + 'L_GetFromNamedStringList');	        // name of function
	gPIEGetFromNamedStringListFDesc.address := GPIEGetFromNamedStringList  ;		// function address
	gPIEGetFromNamedStringListFDesc.returnType := kPIEString;		// return value type
	gPIEGetFromNamedStringListFDesc.numParams :=  2;			// number of parameters
	gPIEGetFromNamedStringListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetFromNamedStringListFDesc.paramNames := @gpnNamePosition  ;		// pointer to parameter names list
	gPIEGetFromNamedStringListFDesc.paramTypes := @g1String1IntegerTypes  ;	// pointer to parameters types list
        gPIEGetFromNamedStringListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEGetFromNamedStringListFDesc.functionFlags := Options;
        gPIEGetFromNamedStringListFDesc.category := PIEcategory;
        gPIEGetFromNamedStringListFDesc.neededProject := PIEneededProject;

       	gPIEGetFromNamedStringListDesc.name  := PChar(ModelPrefix + 'L_GetFromNamedStringList');		// name of PIE
	gPIEGetFromNamedStringListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetFromNamedStringListDesc.descriptor := @gPIEGetFromNamedStringListFDesc ;	// pointer to descriptor
        gPIEGetFromNamedStringListDesc.version := ANE_PIE_VERSION;
        gPIEGetFromNamedStringListDesc.vendor := PIEvendor;
        gPIEGetFromNamedStringListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetFromNamedStringListDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIENamedStringListCountFDesc.name := PChar(ModelPrefix + 'L_GetNamedStringListCount');	        // name of function
	gPIENamedStringListCountFDesc.address := GPIEGetNamedStringListCount   ;		// function address
	gPIENamedStringListCountFDesc.returnType := kPIEInteger;		// return value type
	gPIENamedStringListCountFDesc.numParams :=  1;			// number of parameters
	gPIENamedStringListCountFDesc.numOptParams := 0;			// number of optional parameters
	gPIENamedStringListCountFDesc.paramNames := @gpnName   ;		// pointer to parameter names list
	gPIENamedStringListCountFDesc.paramTypes := @g1StringTypes   ;	// pointer to parameters types list
        gPIENamedStringListCountFDesc.version := FUNCTION_PIE_VERSION;
        gPIENamedStringListCountFDesc.functionFlags := Options;
        gPIENamedStringListCountFDesc.category := PIEcategory;
        gPIENamedStringListCountFDesc.neededProject := PIEneededProject;

       	gPIENamedStringListCountDesc.name  := PChar(ModelPrefix + 'L_GetNamedStringListCount');		// name of PIE
	gPIENamedStringListCountDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIENamedStringListCountDesc.descriptor := @gPIENamedStringListCountFDesc ;	// pointer to descriptor
        gPIENamedStringListCountDesc.version := ANE_PIE_VERSION;
        gPIENamedStringListCountDesc.vendor := PIEvendor;
        gPIENamedStringListCountDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIENamedStringListCountDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEFreeNamedStringListFDesc.name := PChar(ModelPrefix + 'L_FreeNamedStringList');	        // name of function
	gPIEFreeNamedStringListFDesc.address := GPIEFreeNamedStringList   ;		// function address
	gPIEFreeNamedStringListFDesc.returnType := kPIEBoolean;		// return value type
	gPIEFreeNamedStringListFDesc.numParams :=  1;			// number of parameters
	gPIEFreeNamedStringListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeNamedStringListFDesc.paramNames := @gpnName   ;		// pointer to parameter names list
	gPIEFreeNamedStringListFDesc.paramTypes := @g1StringTypes   ;	// pointer to parameters types list
        gPIEFreeNamedStringListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEFreeNamedStringListFDesc.functionFlags := Options;
        gPIEFreeNamedStringListFDesc.category := PIEcategory;
        gPIEFreeNamedStringListFDesc.neededProject := PIEneededProject;

       	gPIEFreeNamedStringListDesc.name  := PChar(ModelPrefix + 'L_FreeNamedStringList');		// name of PIE
	gPIEFreeNamedStringListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEFreeNamedStringListDesc.descriptor := @gPIEFreeNamedStringListFDesc ;	// pointer to descriptor
        gPIEFreeNamedStringListDesc.version := ANE_PIE_VERSION;
        gPIEFreeNamedStringListDesc.vendor := PIEvendor;
        gPIEFreeNamedStringListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeNamedStringListDesc  ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEGetNumberOfNamedStringListsFDesc.name := PChar(ModelPrefix + 'L_GetNumberOfNamedStringLists');	        // name of function
	gPIEGetNumberOfNamedStringListsFDesc.address := GPIEGetNumberOfNamedStringLists   ;		// function address
	gPIEGetNumberOfNamedStringListsFDesc.returnType := kPIEInteger;		// return value type
	gPIEGetNumberOfNamedStringListsFDesc.numParams :=  0;			// number of parameters
	gPIEGetNumberOfNamedStringListsFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetNumberOfNamedStringListsFDesc.paramNames := @gpnName   ;		// pointer to parameter names list
	gPIEGetNumberOfNamedStringListsFDesc.paramTypes := @g1StringTypes   ;	// pointer to parameters types list
        gPIEGetNumberOfNamedStringListsFDesc.version := FUNCTION_PIE_VERSION;
        gPIEGetNumberOfNamedStringListsFDesc.functionFlags := Options;
        gPIEGetNumberOfNamedStringListsFDesc.category := PIEcategory;
        gPIEGetNumberOfNamedStringListsFDesc.neededProject := PIEneededProject;

       	gPIEGetNumberOfNamedStringListsDesc.name  := PChar(ModelPrefix + 'L_GetNumberOfNamedStringLists');		// name of PIE
	gPIEGetNumberOfNamedStringListsDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetNumberOfNamedStringListsDesc.descriptor := @gPIEGetNumberOfNamedStringListsFDesc  ;	// pointer to descriptor
        gPIEGetNumberOfNamedStringListsDesc.version := ANE_PIE_VERSION;
        gPIEGetNumberOfNamedStringListsDesc.vendor := PIEvendor;
        gPIEGetNumberOfNamedStringListsDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetNumberOfNamedStringListsDesc    ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEGetNameOfStringListFDesc.name := PChar(ModelPrefix + 'L_GetNameOfStringList');	        // name of function
	gPIEGetNameOfStringListFDesc.address := GPIEGetNameOfStringList   ;		// function address
	gPIEGetNameOfStringListFDesc.returnType := kPIEString;		// return value type
	gPIEGetNameOfStringListFDesc.numParams :=  1;			// number of parameters
	gPIEGetNameOfStringListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetNameOfStringListFDesc.paramNames := @gpnListIndex   ;		// pointer to parameter names list
	gPIEGetNameOfStringListFDesc.paramTypes := @gOneIntegerTypes   ;	// pointer to parameters types list
        gPIEGetNameOfStringListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEGetNameOfStringListFDesc.functionFlags := Options;
        gPIEGetNameOfStringListFDesc.category := PIEcategory;
        gPIEGetNameOfStringListFDesc.neededProject := PIEneededProject;

       	gPIEGetNameOfStringListDesc.name  := PChar(ModelPrefix + 'L_GetNameOfStringList');		// name of PIE
	gPIEGetNameOfStringListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetNameOfStringListDesc.descriptor := @gPIEGetNameOfStringListFDesc  ;	// pointer to descriptor
        gPIEGetNameOfStringListDesc.version := ANE_PIE_VERSION;
        gPIEGetNameOfStringListDesc.vendor := PIEvendor;
        gPIEGetNameOfStringListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetNameOfStringListDesc    ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEFreeNamedStringListsFDesc.name := PChar(ModelPrefix + 'L_FreeNamedStringLists');	        // name of function
	gPIEFreeNamedStringListsFDesc.address := GListFreeNamedStringLists   ;		// function address
	gPIEFreeNamedStringListsFDesc.returnType := kPIEBoolean;		// return value type
	gPIEFreeNamedStringListsFDesc.numParams :=  0;			// number of parameters
	gPIEFreeNamedStringListsFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeNamedStringListsFDesc.paramNames := @gpnListIndex   ;		// pointer to parameter names list
	gPIEFreeNamedStringListsFDesc.paramTypes := @gOneIntegerTypes   ;	// pointer to parameters types list
        gPIEFreeNamedStringListsFDesc.version := FUNCTION_PIE_VERSION;
        gPIEFreeNamedStringListsFDesc.functionFlags := Options;
        gPIEFreeNamedStringListsFDesc.category := PIEcategory;
        gPIEFreeNamedStringListsFDesc.neededProject := PIEneededProject;

       	gPIEFreeNamedStringListsDesc.name  := PChar(ModelPrefix + 'L_FreeNamedStringLists');		// name of PIE
	gPIEFreeNamedStringListsDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEFreeNamedStringListsDesc.descriptor := @gPIEFreeNamedStringListsFDesc   ;	// pointer to descriptor
        gPIEFreeNamedStringListsDesc.version := ANE_PIE_VERSION;
        gPIEFreeNamedStringListsDesc.vendor := PIEvendor;
        gPIEFreeNamedStringListsDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeNamedStringListsDesc      ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEPositionInNamedStringListsFDesc.name := PChar(ModelPrefix + 'L_PositionInNamedStringList');	        // name of function
	gPIEPositionInNamedStringListsFDesc.address := GPIEGetPositionInStringList   ;		// function address
	gPIEPositionInNamedStringListsFDesc.returnType := kPIEInteger;		// return value type
	gPIEPositionInNamedStringListsFDesc.numParams :=  2;			// number of parameters
	gPIEPositionInNamedStringListsFDesc.numOptParams := 0;			// number of optional parameters
	gPIEPositionInNamedStringListsFDesc.paramNames := @gpnNameString   ;		// pointer to parameter names list
	gPIEPositionInNamedStringListsFDesc.paramTypes := @g2StringTypes   ;	// pointer to parameters types list
        gPIEPositionInNamedStringListsFDesc.version := FUNCTION_PIE_VERSION;
        gPIEPositionInNamedStringListsFDesc.functionFlags := Options;
        gPIEPositionInNamedStringListsFDesc.category := PIEcategory;
        gPIEPositionInNamedStringListsFDesc.neededProject := PIEneededProject;

       	gPIEPositionInNamedStringListsDesc.name  := PChar(ModelPrefix + 'L_PositionInNamedStringList');		// name of PIE
	gPIEPositionInNamedStringListsDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEPositionInNamedStringListsDesc.descriptor := @gPIEPositionInNamedStringListsFDesc   ;	// pointer to descriptor
        gPIEPositionInNamedStringListsDesc.version := ANE_PIE_VERSION;
        gPIEPositionInNamedStringListsDesc.vendor := PIEvendor;
        gPIEPositionInNamedStringListsDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEPositionInNamedStringListsDesc      ;  // add descriptor to list
        Inc(numNames);	// increment number of names


	gPIEEvalContourParamFDesc.name := PChar(ModelPrefix + 'L_EvaluateRealContourParam');	        // name of function
	gPIEEvalContourParamFDesc.address := G3EvaluateRealContourParamMMFun   ;		// function address
	gPIEEvalContourParamFDesc.returnType := kPIEFloat;		// return value type
	gPIEEvalContourParamFDesc.numParams :=  3;			// number of parameters
	gPIEEvalContourParamFDesc.numOptParams := 0;			// number of optional parameters
	gPIEEvalContourParamFDesc.paramNames := @gpnLayerContourindexParameter   ;		// pointer to parameter names list
	gPIEEvalContourParamFDesc.paramTypes := @gStringIntegerStringTypes   ;	// pointer to parameters types list
        gPIEEvalContourParamFDesc.version := FUNCTION_PIE_VERSION;
        gPIEEvalContourParamFDesc.functionFlags := Options;
        gPIEEvalContourParamFDesc.category := PIEcategory;
        gPIEEvalContourParamFDesc.neededProject := PIEneededProject;

       	gPIEEvalContourParamDesc.name  := PChar(ModelPrefix + 'L_EvaluateRealContourParam');		// name of PIE
	gPIEEvalContourParamDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEEvalContourParamDesc.descriptor := @gPIEEvalContourParamFDesc   ;	// pointer to descriptor
        gPIEEvalContourParamDesc.version := ANE_PIE_VERSION;
        gPIEEvalContourParamDesc.vendor := PIEvendor;
        gPIEEvalContourParamDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEEvalContourParamDesc      ;  // add descriptor to list
        Inc(numNames);	// increment number of names


        // coordinate list functions
        //------------------------- 3D List functions

        // Create a 3D List
	gPIEFreeNamedCoordinateListsFDesc.version := FUNCTION_PIE_VERSION;	// Function PIE Version
	gPIEFreeNamedCoordinateListsFDesc.name :=PChar(ModelPrefix + 'L_FreeNamedCoordinateLists');	        // name of function
	gPIEFreeNamedCoordinateListsFDesc.address := GListFreeNamedCoordinateLists;	// function address
	gPIEFreeNamedCoordinateListsFDesc.returnType := kPIEBoolean;		// return value type
	gPIEFreeNamedCoordinateListsFDesc.numParams :=  0;			// number of parameters
	gPIEFreeNamedCoordinateListsFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeNamedCoordinateListsFDesc.paramNames := nil;		        // pointer to parameter names list
	gPIEFreeNamedCoordinateListsFDesc.paramTypes := nil;	                // pointer to parameters types list
	gPIEFreeNamedCoordinateListsFDesc.functionFlags := Options;	        // function options
        gPIEFreeNamedCoordinateListsFDesc.category := PIEcategory;
        gPIEFreeNamedCoordinateListsFDesc.neededProject := PIEneededProject;

       	gPIEFreeNamedCoordinateListsDesc.name  :=PChar(ModelPrefix + 'L_FreeNamedCoordinateLists');		// name of PIE
	gPIEFreeNamedCoordinateListsDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEFreeNamedCoordinateListsDesc.descriptor := @gPIEFreeNamedCoordinateListsFDesc;	// pointer to descriptor
        gPIEFreeNamedCoordinateListsDesc.version := ANE_PIE_VERSION;
        gPIEFreeNamedCoordinateListsDesc.vendor  := PIEvendor;
        gPIEFreeNamedCoordinateListsDesc.product  := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeNamedCoordinateListsDesc;              // add descriptor to list
        Inc(numNames);	                                        // increment number of names


	gPIEAddToNamedCoordinateListFDesc.name := PChar(ModelPrefix + 'L_AddToNamedCoordinateList');	        // name of function
	gPIEAddToNamedCoordinateListFDesc.address := GPIEAddToNamedCoordinateListMMFun   ;		// function address
	gPIEAddToNamedCoordinateListFDesc.returnType := kPIEInteger;		// return value type
	gPIEAddToNamedCoordinateListFDesc.numParams :=  3;			// number of parameters
	gPIEAddToNamedCoordinateListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEAddToNamedCoordinateListFDesc.paramNames := @gpnNameXY   ;		// pointer to parameter names list
	gPIEAddToNamedCoordinateListFDesc.paramTypes := @gStringDoubleDoubleTypes   ;	// pointer to parameters types list
        gPIEAddToNamedCoordinateListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEAddToNamedCoordinateListFDesc.functionFlags := Options;
        gPIEAddToNamedCoordinateListFDesc.category := PIEcategory;
        gPIEAddToNamedCoordinateListFDesc.neededProject := PIEneededProject;

       	gPIEAddToNamedCoordinateListDesc.name  := PChar(ModelPrefix + 'L_AddToNamedCoordinateList');		// name of PIE
	gPIEAddToNamedCoordinateListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEAddToNamedCoordinateListDesc.descriptor := @gPIEAddToNamedCoordinateListFDesc   ;	// pointer to descriptor
        gPIEAddToNamedCoordinateListDesc.version := ANE_PIE_VERSION;
        gPIEAddToNamedCoordinateListDesc.vendor := PIEvendor;
        gPIEAddToNamedCoordinateListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAddToNamedCoordinateListDesc      ;  // add descriptor to list
        Inc(numNames);	// increment number of names

	gPIEFreeNamedCoordinateListFDesc.name := PChar(ModelPrefix + 'L_FreeNamedCoordinateList');	        // name of function
	gPIEFreeNamedCoordinateListFDesc.address := GPIEFreeNamedCoordinateList   ;		// function address
	gPIEFreeNamedCoordinateListFDesc.returnType := kPIEBoolean;		// return value type
	gPIEFreeNamedCoordinateListFDesc.numParams :=  1;			// number of parameters
	gPIEFreeNamedCoordinateListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeNamedCoordinateListFDesc.paramNames := @gpnName   ;		// pointer to parameter names list
	gPIEFreeNamedCoordinateListFDesc.paramTypes := @g1StringTypes   ;	// pointer to parameters types list
        gPIEFreeNamedCoordinateListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEFreeNamedCoordinateListFDesc.functionFlags := Options;
        gPIEFreeNamedCoordinateListFDesc.category := PIEcategory;
        gPIEFreeNamedCoordinateListFDesc.neededProject := PIEneededProject;

       	gPIEFreeNamedCoordinateListDesc.name  := PChar(ModelPrefix + 'L_FreeNamedCoordinateList');		// name of PIE
	gPIEFreeNamedCoordinateListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEFreeNamedCoordinateListDesc.descriptor := @gPIEFreeNamedCoordinateListFDesc   ;	// pointer to descriptor
        gPIEFreeNamedCoordinateListDesc.version := ANE_PIE_VERSION;
        gPIEFreeNamedCoordinateListDesc.vendor := PIEvendor;
        gPIEFreeNamedCoordinateListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeNamedCoordinateListDesc      ;  // add descriptor to list
        Inc(numNames);	// increment number of names


	gPIEGetXFromNamedCoordinateListFDesc.name := PChar(ModelPrefix + 'L_GetXFromNamedCoordinateList');	        // name of function
	gPIEGetXFromNamedCoordinateListFDesc.address := GPIEGetXFromNamedCoordinateList   ;		// function address
	gPIEGetXFromNamedCoordinateListFDesc.returnType := kPIEFloat;		// return value type
	gPIEGetXFromNamedCoordinateListFDesc.numParams :=  2;			// number of parameters
	gPIEGetXFromNamedCoordinateListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetXFromNamedCoordinateListFDesc.paramNames := @gpnNamePosition   ;		// pointer to parameter names list
	gPIEGetXFromNamedCoordinateListFDesc.paramTypes := @g1String1IntegerTypes   ;	// pointer to parameters types list
        gPIEGetXFromNamedCoordinateListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEGetXFromNamedCoordinateListFDesc.functionFlags := Options;
        gPIEGetXFromNamedCoordinateListFDesc.category := PIEcategory;
        gPIEGetXFromNamedCoordinateListFDesc.neededProject := PIEneededProject;

       	gPIEGetXFromNamedCoordinateListDesc.name  := PChar(ModelPrefix + 'L_GetXFromNamedCoordinateList');		// name of PIE
	gPIEGetXFromNamedCoordinateListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetXFromNamedCoordinateListDesc.descriptor := @gPIEGetXFromNamedCoordinateListFDesc   ;	// pointer to descriptor
        gPIEGetXFromNamedCoordinateListDesc.version := ANE_PIE_VERSION;
        gPIEGetXFromNamedCoordinateListDesc.vendor := PIEvendor;
        gPIEGetXFromNamedCoordinateListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetXFromNamedCoordinateListDesc      ;  // add descriptor to list
        Inc(numNames);	// increment number of names


	gPIEGetYFromNamedCoordinateListFDesc.name := PChar(ModelPrefix + 'L_GetYFromNamedCoordinateList');	        // name of function
	gPIEGetYFromNamedCoordinateListFDesc.address := GPIEGetYFromNamedCoordinateList   ;		// function address
	gPIEGetYFromNamedCoordinateListFDesc.returnType := kPIEFloat;		// return value type
	gPIEGetYFromNamedCoordinateListFDesc.numParams :=  2;			// number of parameters
	gPIEGetYFromNamedCoordinateListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetYFromNamedCoordinateListFDesc.paramNames := @gpnNamePosition   ;		// pointer to parameter names list
	gPIEGetYFromNamedCoordinateListFDesc.paramTypes := @g1String1IntegerTypes   ;	// pointer to parameters types list
        gPIEGetYFromNamedCoordinateListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEGetYFromNamedCoordinateListFDesc.functionFlags := Options;
        gPIEGetYFromNamedCoordinateListFDesc.category := PIEcategory;
        gPIEGetYFromNamedCoordinateListFDesc.neededProject := PIEneededProject;

       	gPIEGetYFromNamedCoordinateListDesc.name  := PChar(ModelPrefix + 'L_GetYFromNamedCoordinateList');		// name of PIE
	gPIEGetYFromNamedCoordinateListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetYFromNamedCoordinateListDesc.descriptor := @gPIEGetYFromNamedCoordinateListFDesc   ;	// pointer to descriptor
        gPIEGetYFromNamedCoordinateListDesc.version := ANE_PIE_VERSION;
        gPIEGetYFromNamedCoordinateListDesc.vendor := PIEvendor;
        gPIEGetYFromNamedCoordinateListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetYFromNamedCoordinateListDesc      ;  // add descriptor to list
        Inc(numNames);	// increment number of names


	gPIEGetNamedCoordinateListCountFDesc.name := PChar(ModelPrefix + 'L_GetNamedCoordinateListCount');	        // name of function
	gPIEGetNamedCoordinateListCountFDesc.address := GPIEGetNamedCoordinateListCount   ;		// function address
	gPIEGetNamedCoordinateListCountFDesc.returnType := kPIEInteger;		// return value type
	gPIEGetNamedCoordinateListCountFDesc.numParams :=  1;			// number of parameters
	gPIEGetNamedCoordinateListCountFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetNamedCoordinateListCountFDesc.paramNames := @gpnName   ;		// pointer to parameter names list
	gPIEGetNamedCoordinateListCountFDesc.paramTypes := @g1StringTypes   ;	// pointer to parameters types list
        gPIEGetNamedCoordinateListCountFDesc.version := FUNCTION_PIE_VERSION;
        gPIEGetNamedCoordinateListCountFDesc.functionFlags := Options;
        gPIEGetNamedCoordinateListCountFDesc.category := PIEcategory;
        gPIEGetNamedCoordinateListCountFDesc.neededProject := PIEneededProject;

       	gPIEGetNamedCoordinateListCountDesc.name  := PChar(ModelPrefix + 'L_GetNamedCoordinateListCount');		// name of PIE
	gPIEGetNamedCoordinateListCountDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetNamedCoordinateListCountDesc.descriptor := @gPIEGetNamedCoordinateListCountFDesc   ;	// pointer to descriptor
        gPIEGetNamedCoordinateListCountDesc.version := ANE_PIE_VERSION;
        gPIEGetNamedCoordinateListCountDesc.vendor := PIEvendor;
        gPIEGetNamedCoordinateListCountDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetNamedCoordinateListCountDesc      ;  // add descriptor to list
        Inc(numNames);	// increment number of names


	gPIEGetNameOfCoordinateListFDesc.name := PChar(ModelPrefix + 'L_GetNameOfCoordinateList');	        // name of function
	gPIEGetNameOfCoordinateListFDesc.address := GPIEGetNameOfCoordinateList   ;		// function address
	gPIEGetNameOfCoordinateListFDesc.returnType := kPIEString;		// return value type
	gPIEGetNameOfCoordinateListFDesc.numParams :=  1;			// number of parameters
	gPIEGetNameOfCoordinateListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetNameOfCoordinateListFDesc.paramNames := @gpnListIndex   ;		// pointer to parameter names list
	gPIEGetNameOfCoordinateListFDesc.paramTypes := @gOneIntegerTypes   ;	// pointer to parameters types list
        gPIEGetNameOfCoordinateListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEGetNameOfCoordinateListFDesc.functionFlags := Options;
        gPIEGetNameOfCoordinateListFDesc.category := PIEcategory;
        gPIEGetNameOfCoordinateListFDesc.neededProject := PIEneededProject;

       	gPIEGetNameOfCoordinateListDesc.name  := PChar(ModelPrefix + 'L_GetNameOfCoordinateList');		// name of PIE
	gPIEGetNameOfCoordinateListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetNameOfCoordinateListDesc.descriptor := @gPIEGetNameOfCoordinateListFDesc   ;	// pointer to descriptor
        gPIEGetNameOfCoordinateListDesc.version := ANE_PIE_VERSION;
        gPIEGetNameOfCoordinateListDesc.vendor := PIEvendor;
        gPIEGetNameOfCoordinateListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetNameOfCoordinateListDesc      ;  // add descriptor to list
        Inc(numNames);	// increment number of names


	gPIEGetNumberOfNamedCoordinateListsFDesc.name := PChar(ModelPrefix + 'L_GetNumberOfNamedCoordinateLists');	        // name of function
	gPIEGetNumberOfNamedCoordinateListsFDesc.address := GPIEGetNumberOfNamedCoordinateLists   ;		// function address
	gPIEGetNumberOfNamedCoordinateListsFDesc.returnType := kPIEInteger;		// return value type
	gPIEGetNumberOfNamedCoordinateListsFDesc.numParams :=  0;			// number of parameters
	gPIEGetNumberOfNamedCoordinateListsFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetNumberOfNamedCoordinateListsFDesc.paramNames := nil   ;		// pointer to parameter names list
	gPIEGetNumberOfNamedCoordinateListsFDesc.paramTypes := nil   ;	// pointer to parameters types list
        gPIEGetNumberOfNamedCoordinateListsFDesc.version := FUNCTION_PIE_VERSION;
        gPIEGetNumberOfNamedCoordinateListsFDesc.functionFlags := Options;
        gPIEGetNumberOfNamedCoordinateListsFDesc.category := PIEcategory;
        gPIEGetNumberOfNamedCoordinateListsFDesc.neededProject := PIEneededProject;

       	gPIEGetNumberOfNamedCoordinateListsDesc.name  := PChar(ModelPrefix + 'L_GetNumberOfNamedCoordinateLists');		// name of PIE
	gPIEGetNumberOfNamedCoordinateListsDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetNumberOfNamedCoordinateListsDesc.descriptor := @gPIEGetNumberOfNamedCoordinateListsFDesc   ;	// pointer to descriptor
        gPIEGetNumberOfNamedCoordinateListsDesc.version := ANE_PIE_VERSION;
        gPIEGetNumberOfNamedCoordinateListsDesc.vendor := PIEvendor;
        gPIEGetNumberOfNamedCoordinateListsDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetNumberOfNamedCoordinateListsDesc      ;  // add descriptor to list
        Inc(numNames);	// increment number of names


	gPIEGetPositionInCoordinateListFDesc.name := PChar(ModelPrefix + 'L_GetPositionInCoordinateList');	        // name of function
	gPIEGetPositionInCoordinateListFDesc.address := GPIEGetPositionInCoordinateList   ;		// function address
	gPIEGetPositionInCoordinateListFDesc.returnType := kPIEInteger;		// return value type
	gPIEGetPositionInCoordinateListFDesc.numParams :=  3;			// number of parameters
	gPIEGetPositionInCoordinateListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetPositionInCoordinateListFDesc.paramNames := @gpnNameXY   ;		// pointer to parameter names list
	gPIEGetPositionInCoordinateListFDesc.paramTypes := @gStringDoubleDoubleTypes   ;	// pointer to parameters types list
        gPIEGetPositionInCoordinateListFDesc.version := FUNCTION_PIE_VERSION;
        gPIEGetPositionInCoordinateListFDesc.functionFlags := Options;
        gPIEGetPositionInCoordinateListFDesc.category := PIEcategory;
        gPIEGetPositionInCoordinateListFDesc.neededProject := PIEneededProject;

       	gPIEGetPositionInCoordinateListDesc.name  := PChar(ModelPrefix + 'L_GetPositionInCoordinateList');		// name of PIE
	gPIEGetPositionInCoordinateListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetPositionInCoordinateListDesc.descriptor := @gPIEGetPositionInCoordinateListFDesc   ;	// pointer to descriptor
        gPIEGetPositionInCoordinateListDesc.version := ANE_PIE_VERSION;
        gPIEGetPositionInCoordinateListDesc.vendor := PIEvendor;
        gPIEGetPositionInCoordinateListDesc.product := PIEproduct;

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetPositionInCoordinateListDesc      ;  // add descriptor to list
        Inc(numNames);	// increment number of names







	descriptors := @gFunDesc;


end;


initialization
begin
     Initialize;
     Initialize3D;
end;

finalization
begin
  Terminate;
end;


end.
