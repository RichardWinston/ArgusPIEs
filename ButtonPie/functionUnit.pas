unit functionUnit;

interface

uses {Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls,}
  Classes, SysUtils, Dialogs, // Windows,
  AnePIE, FunctionPie;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;
  ANE_BOOL_PTR = ^ANE_BOOL;

  TReal = Class (TObject)
    Value : double;
  end;

  TVertex = Class(TObject)
    XPos : double;
    YPos : double;
    Angle : double;
    Distance : Double;
    TempRowVertex : Boolean;
    TempColumnVertex : Boolean;
  end;

  TCell = Class(TObject)
    Row : integer;
    Column : integer;
  end;

var
        MainVertexList : TList;
        MainCellList : TList;
        RowList : TList;
        ColumnList : TList;
        CombinedCellList : TList;
        GridImportOK : boolean = False;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

procedure GInitializeBlockMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GInitializeVertexMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GAddVertexMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

{
procedure GListCreateMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
}

{
procedure GPIEAddToListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
}
{
procedure GPIEAddToRowListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
}
{
procedure GPIEAddToColumnListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
}
{
procedure GPIEGetFromListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
}
{
procedure GGetCountOfVertexListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
}
{
procedure GGetCountOfAVertexListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
}
procedure GGetCountOfCellListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GGetCountOfACellListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GGetCellRowMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GGetCellColumnMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GGetCountOfCombinedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GGetCellRowFromCombinedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GGetCellColumnFromCombinedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GListFreeVertexMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GListFreeBlockMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses
   ANECB;

const
  kMaxFunDesc = 20;

var
        GridAngle : ANE_DOUBLE;

        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

        gPIEInitializeBlockDesc  :  ANEPIEDesc;
        gPIEInitializeBlockFDesc :  FunctionPIEDesc;

        gPIEInitializeVertexDesc  :  ANEPIEDesc;
        gPIEInitializeVertexFDesc :  FunctionPIEDesc;

        gPIEAddVertexDesc  :  ANEPIEDesc;
        gPIEAddVertexFDesc :  FunctionPIEDesc;

{
        gPIECreateListDesc  :  ANEPIEDesc;
        gPIECreateListFDesc :  FunctionPIEDesc;
}
{
        gPIEAddDesc  :  ANEPIEDesc;
        gPIEAddFDesc :  FunctionPIEDesc;
}
{
        gPIEAddRowDesc  :  ANEPIEDesc;
        gPIEAddRowFDesc :  FunctionPIEDesc;
}
{
        gPIEAddColumnDesc  :  ANEPIEDesc;
        gPIEAddColumnFDesc :  FunctionPIEDesc;
}
{
        gPIEGetDesc  :  ANEPIEDesc;
        gPIEGetFDesc :  FunctionPIEDesc;
}
{
        gPIEGetRowDesc  :  ANEPIEDesc;
        gPIEGetRowFDesc :  FunctionPIEDesc;
}
{
        gPIEGetColumnDesc  :  ANEPIEDesc;
        gPIEGetColumnFDesc :  FunctionPIEDesc;
}
{
        gPIEGetVertexListsCountDesc  :  ANEPIEDesc;
        gPIEGetVertexListsCountFDesc :  FunctionPIEDesc;
}
{
        gPIEGetAVertexListCountDesc  :  ANEPIEDesc;
        gPIEGetAVertexListCountFDesc :  FunctionPIEDesc;
}
        gPIEGetCellListsCountDesc  :  ANEPIEDesc;
        gPIEGetCellListsCountFDesc :  FunctionPIEDesc;

        gPIEGetACellListCountDesc  :  ANEPIEDesc;
        gPIEGetACellListCountFDesc :  FunctionPIEDesc;

        gPIEGetACellRowDesc  :  ANEPIEDesc;
        gPIEGetACellRowFDesc :  FunctionPIEDesc;

        gPIEGetACellColumnDesc  :  ANEPIEDesc;
        gPIEGetACellColumnFDesc :  FunctionPIEDesc;

        gPIEGetCombinedListCountDesc  :  ANEPIEDesc;
        gPIEGetCombinedListCountFDesc :  FunctionPIEDesc;

        gPIEGetACombinedCellRowDesc  :  ANEPIEDesc;
        gPIEGetACombinedCellRowFDesc :  FunctionPIEDesc;

        gPIEGetACellCombinedColumnDesc  :  ANEPIEDesc;
        gPIEGetACellCombinedColumnFDesc :  FunctionPIEDesc;

        gPIEFreeListVertexDesc  :  ANEPIEDesc;
        gPIEFreeListVertexFDesc :  FunctionPIEDesc;

        gPIEFreeListBlockDesc  :  ANEPIEDesc;
        gPIEFreeListBlockFDesc :  FunctionPIEDesc;



const   gpnNumber : array [0..1] of PChar = ('Number', nil);
const   gpnRow : array [0..1] of PChar = ('RowPosition', nil);
const   gpnColumn : array [0..1] of PChar = ('ColumnPosition', nil);
const   gpnListIndex : array [0..1] of PChar = ('ListIndex', nil);
const   gOneFloatTypes : array [0..1] of EPIENumberType = (kPIEFloat, 0);
const   gOneIntegerTypes : array [0..1] of EPIENumberType = (kPIEInteger, 0);

const   gpnIndexValue : array [0..2] of PChar = ('ListIndex','Value', nil);
const   gIntegerDouble : array [0..2] of EPIENumberType = (kPIEInteger, kPIEFloat, 0);

const   gpn2Index : array [0..2] of PChar = ('ListIndex','Index', nil);
const   g2Integer : array [0..2] of EPIENumberType = (kPIEInteger, kPIEInteger, 0);

const   gpnGrid : array [0..1] of PChar = ('Grid_Layer_Name_as_String', nil);
const   gpnInfo : array [0..1] of PChar = ('Information_Layer_Name_as_String', nil);
const   g1String : array [0..1] of EPIENumberType = (kPIEString, 0);


const   gpnGridInfo : array [0..2] of PChar = ('Grid_Layer_Name_as_String','Information_Layer_Name_as_String', nil);
const   g2String : array [0..2] of EPIENumberType = (kPIEString, kPIEString, 0);

Function SimilarCellInList (ACell : TCell; AList : Tlist) : boolean;
var
  ACellInList : TCell;
  i : integer;
begin
  result := false;
  for i := 0 to AList.Count -1 do
  begin
     ACellInList := AList.Items[i];
     if (ACell.Column = ACellInList.Column) and (ACell.Row = ACellInList.Row) then
     begin
       result := True;
     end;
  end;
end;


Procedure AddCellsIntersectingVertex(AVertex : TVertex ; ACellList : TList;
  XDir, YDir : integer; var RowAbove, RowBelow, ColumnAbove, ColumnBelow : integer ;
  XSegmentDir, YSegmentDir : integer;
  AddToCellList : Boolean);
const
  RoundError = 1e-14 ;
var

  MiddleRow, MiddleColumn : integer;
  ACell : TCell;
begin
    RowAbove := RowList.Count -1;
    RowBelow := 0;
    ColumnAbove := ColumnList.Count -1;
    ColumnBelow := 0;
//    ShowMessage(FloatToStr(YDir*AVertex.YPos) + ', ' + FloatToStr(YDir*TReal(RowList.Items[RowList.Count -1]).Value)  + ', ' + FloatToStr(YDir*AVertex.YPos - YDir*TReal(RowList.Items[RowList.Count -1]).Value));
  if       (YDir*AVertex.YPos {/ (1 - RoundError)} > YDir*TReal(RowList.Items[0]).Value  ) and
           (YDir*AVertex.YPos {* (1 - RoundError)} < YDir*TReal(RowList.Items[RowList.Count -1]).Value)
  then
    begin
      While RowAbove - RowBelow > 1 do
      begin
        MiddleRow := Round((RowAbove + RowBelow)/2);
        if { not } (YDir*AVertex.YPos < YDir*TReal(RowList.Items[MiddleRow]).Value)
        then
          begin
            RowAbove := MiddleRow;
          end
        else
          begin
            RowBelow := MiddleRow;
          end;
      end; // While RowAbove - RowBelow > 1 do
    end
  else if (YDir*AVertex.YPos < YDir*TReal(RowList.Items[0]).Value)
  then
    begin
      RowAbove := 0;
    end
  else
    begin
      RowBelow := RowList.Count -1;;
    end;

  if       (XDir*AVertex.XPos {/ (1 - RoundError)} > XDir*TReal(ColumnList.Items[0]).Value) and
           (XDir*AVertex.XPos {* (1 - RoundError)} < XDir*TReal(ColumnList.Items[ColumnList.Count -1]).Value)
  then
    begin
      While ColumnAbove - ColumnBelow > 1 do
      begin
        MiddleColumn := Round((ColumnAbove + ColumnBelow)/2);
        if { not } (XDir*AVertex.XPos < XDir*TReal(ColumnList.Items[MiddleColumn]).Value)
        then
          begin
            ColumnAbove := MiddleColumn;
          end
        else
          begin
            ColumnBelow := MiddleColumn;
          end;
      end; // While ColumnAbove - ColumnBelow > 1 do
    end
  else if (XDir*AVertex.XPos < XDir*TReal(ColumnList.Items[0]).Value)
  then
    begin
      ColumnAbove := 0;
    end
  else
    begin
      ColumnBelow := ColumnList.Count -1;;
    end;

  if AddToCellList and
           (YDir*AVertex.YPos / (1 - RoundError){} > YDir*TReal(RowList.Items[0]).Value) and
           (YDir*AVertex.YPos * (1 - RoundError){} < YDir*TReal(RowList.Items[RowList.Count -1]).Value) and
           (XDir*AVertex.XPos / (1 - RoundError){} > XDir*TReal(ColumnList.Items[0]).Value) and
           (XDir*AVertex.XPos * (1 - RoundError){} < XDir*TReal(ColumnList.Items[ColumnList.Count -1]).Value)
           then
  begin
    ACell := TCell.Create;
    if not AVertex.TempRowVertex
    then
      begin
        ACell.Row := RowAbove;
      end
    else
      begin
      if (YSegmentDir = 1 )
      then
        begin
          ACell.Row := RowBelow;
        end
      else
        begin
          ACell.Row := RowAbove;
        end;
      end;
    if not AVertex.TempColumnVertex
    then
      begin
        ACell.Column := ColumnAbove;
      end
    else
      begin
      if (XSegmentDir = 1)
      then
        begin
          ACell.Column := ColumnBelow;
        end
      else
        begin
          ACell.Column := ColumnAbove;
        end;
      end;

    if SimilarCellInList (ACell, ACellList)
    then
      begin
//        ShowMessage('ACell Free: ' + IntToStr(ACell.Row));
        ACell.Free;
      end
    else
      begin
        ACellList.Add(ACell);
//        ShowMessage('ACell: ' + IntToStr(ACell.Row));
      end;
    if (RowBelow > 0) and
       (AVertex.YPos = TReal(RowList.Items[RowBelow]).Value)  and not AVertex.TempRowVertex
       then
    begin
        ACell := TCell.Create;
        ACell.Row := RowBelow;
        ACell.Column := ColumnAbove;
        if SimilarCellInList (ACell, ACellList)
        then
          begin
            ACell.Free
          end
        else
          begin
            ACellList.Add(ACell);
          end;
    end; // if (RowBelow > 0) and (AVertex.YPos = TReal(RowList.Items[RowBelow]).Value)  and not AVertex.TempRowVertex
    if (ColumnBelow > 0) and
       (AVertex.XPos = TReal(ColumnList.Items[ColumnBelow]).Value)  and not AVertex.TempColumnVertex
       then
    begin
        ACell := TCell.Create;
        ACell.Row := RowAbove;
        ACell.Column := ColumnBelow;
        if SimilarCellInList (ACell, ACellList)
        then
          begin
            ACell.Free
          end
        else
          begin
            ACellList.Add(ACell);
          end;
    end; // if (ColumnBelow > 0) and (AVertex.XPos = TReal(ColumnList.Items[ColumnBelow]).Value) and not AVertex.TempColumnVertex
    if (ColumnBelow > 0) and (RowBelow > 0) and
       (AVertex.XPos = TReal(ColumnList.Items[ColumnBelow]).Value)  and
       (AVertex.YPos = TReal(RowList.Items[RowBelow]).Value)
        and not AVertex.TempColumnVertex and not AVertex.TempRowVertex
        then
    begin
        ACell := TCell.Create;
        ACell.Row := RowBelow;
        ACell.Column := ColumnBelow;
        if SimilarCellInList (ACell, ACellList)
        then
          begin
            ACell.Free
          end
        else
          begin
            ACellList.Add(ACell);
          end;
    end; // if (RowBelow > 0) and (AVertex.YPos = TReal(RowList.Items[RowBelow]).Value)
  end; // if vertex inside grid
end;

// This is the function used by the sort method of the temp vertex list
// if the X direction of the current line segement is positive.
function CompareVerticiesXDirPositive  (Item1, Item2: Pointer): Integer;
var
  FirstVertex, SecondVertex : TVertex;
begin
    FirstVertex := Item1 ;
    SecondVertex := Item2 ;
    if FirstVertex.XPos < SecondVertex.XPos
    then result := -1
    else if FirstVertex.XPos = SecondVertex.XPos then result := 0
    else result := 1;
end;

// This is the function used by the sort method of the temp vertex list
// if the X direction of the current line segement is negative.
function CompareVerticiesXDirNegative  (Item1, Item2: Pointer): Integer;
var
  FirstVertex, SecondVertex : TVertex;
begin
    FirstVertex := Item1 ;
    SecondVertex := Item2 ;
    if FirstVertex.XPos > SecondVertex.XPos
    then result := -1
    else if FirstVertex.XPos = SecondVertex.XPos then result := 0
    else result := 1;
end;

// This is the function used by the sort method of the temp vertex list
// if the Y direction of the current line segement is positive.
function CompareVerticiesYDirPositive  (Item1, Item2: Pointer): Integer;
var
  FirstVertex, SecondVertex : TVertex;
begin
    FirstVertex := Item1 ;
    SecondVertex := Item2 ;
    if FirstVertex.YPos < SecondVertex.YPos
    then result := -1
    else if FirstVertex.YPos = SecondVertex.YPos then result := 0
    else result := 1;
end;

// This is the function used by the sort method of the temp vertex list
// if the Y direction of the current line segement is negative.
function CompareVerticiesYDirNegative  (Item1, Item2: Pointer): Integer;
var
  FirstVertex, SecondVertex : TVertex;
begin
    FirstVertex := Item1 ;
    SecondVertex := Item2 ;
    if FirstVertex.YPos > SecondVertex.YPos
    then result := -1
    else if FirstVertex.YPos = SecondVertex.YPos then result := 0
    else result := 1;
end;



procedure GInitializeBlockMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_INT32;
  param1 : ANE_STR;          // name of grid layer
  param : PParameter_array;
  GridLayerHandle :ANE_PTR;
  TextToEvaluate : ANE_STR ;
  NumRows : ANE_INT32;
  NumColumns : ANE_INT32;
  RowIndex, ColumnIndex : ANE_INT32;
  RowPosition, ColumnPosition : ANE_DOUBLE;
  AReal : TReal;
  AVertex : TVertex;
  AVertexList : TList;
  ACellList : TList;
  ACell : TCell;
  ListIndex, InnerListIndex : integer;
begin
  try
    begin
      result := 0;


      if (MainVertexList = nil)
      then
        begin
          MainVertexList := TList.Create;
        end
      else
        begin
          For ListIndex := MainVertexList.Count -1 downto 0 do
          begin
            AVertexList := MainVertexList.Items[ListIndex];
            For InnerListIndex := AVertexList.Count -1 downto 0 do
            begin
              AVertex := AVertexList.Items[InnerListIndex];
              AVertex.Free;
            end;
            AVertexList.Clear;
            AVertexList.Free;
          end;
          MainVertexList.Clear;
        end;
      if (RowList = nil)
      then
        begin
          RowList := TList.Create;
        end
      else
        begin
          For ListIndex := RowList.Count -1 downto 0 do
          begin
            AReal := RowList.Items[ListIndex];
            AReal.Free;
          end;
          RowList.Clear;
        end;
      if (ColumnList = nil)
      then
        begin
          ColumnList := TList.Create;
        end
      else
        begin
          For ListIndex := ColumnList.Count -1 downto 0 do
          begin
            AReal := ColumnList.Items[ListIndex];
            AReal.Free;
          end;
          ColumnList.Clear;
        end;
      if (MainCellList = nil)
      then
        begin
          MainCellList := TList.Create;
        end
      else
        begin
          For ListIndex := MainCellList.Count -1 downto 0 do
          begin
            ACellList := MainCellList.Items[ListIndex];
            For InnerListIndex := ACellList.Count -1 downto 0 do
            begin
              ACell := ACellList.Items[InnerListIndex];
              ACell.Free;
            end;
            ACellList.Clear;
            ACellList.Free;
          end;
          MainCellList.Clear;
        end;
      if (CombinedCellList = nil)
      then
        begin
          CombinedCellList := TList.Create;
        end
      else
        begin
        CombinedCellList.Clear;
        end;

      // Get Grid and information layer handles.
      param := @parameters^;
      param1 :=  param^[0];
      GridLayerHandle := ANE_LayerGetHandleByName(myHandle, param1 );

      GridImportOK := False;
          Try
            begin
              TextToEvaluate := 'If(IsNA(NumRows()), 0, NumRows())';
              ANE_EvaluateStringAtLayer(myHandle, GridLayerHandle,kPIEInteger,
              TextToEvaluate, @NumRows );
              TextToEvaluate := 'If(IsNA(NumColumns()), 0, NumColumns())';
              ANE_EvaluateStringAtLayer(myHandle, GridLayerHandle,kPIEInteger,
              TextToEvaluate, @NumColumns );
              if (NumRows = 0) or (NumColumns = 0)
              then
                begin
                  ShowMessage('There is no grid on layer ' + param1);
                  result := 0;
                end
              else
                begin
                  TextToEvaluate := 'If(IsNA(GridAngle()), 0, GridAngle())';
                  ANE_EvaluateStringAtLayer(myHandle, GridLayerHandle,
                       kPIEFloat,TextToEvaluate, @GridAngle );
                  for RowIndex := 0 to NumRows do
                  begin
                    TextToEvaluate := PChar('NthRowPos(' + IntToStr(RowIndex) + ')');
                    ANE_EvaluateStringAtLayer(myHandle, GridLayerHandle,
                         kPIEFloat,TextToEvaluate, @RowPosition );
                    AReal := TReal.Create;
                    AReal.Value := RowPosition;
                    RowList.Add(AReal);
                  end;
                  for ColumnIndex := 0 to NumColumns do
                  begin
                    TextToEvaluate := PChar('NthColumnPos(' + IntToStr(ColumnIndex) + ')');
                    ANE_EvaluateStringAtLayer(myHandle, GridLayerHandle,
                         kPIEFloat,TextToEvaluate, @ColumnPosition );
                    AReal := TReal.Create;
                    AReal.Value := ColumnPosition;
                    ColumnList.Add(AReal);
                  end;
                  GridImportOK := True;
                end;
            end;
          except on Exception do
            begin
              ShowMessage('Problem importing grid data from layer ' + param1);
              result := 0;
            end;
          end;
      result := 1;
    end;
  Except on Exception do
    begin
      MainVertexList.Free;
      RowList.Free;
      ColumnList.Free;
      result := 0;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;


function AddObjectsFromLayer(myHandle, InfoLayerHandle : ANE_PTR) : ANE_BOOL;
var
  InfoText : ANE_STR;
  InfoTextString : String;
  TextToEvaluate : ANE_STR ;
  InfoTextList : TStringList;
  InfoListIndex : Integer;
  AString : String;
  AVertexList : TList;
  NumVerticies : ANE_INT32;
  VertexIndex, TempVertexIndex : ANE_INT32;
  ThisX, ThisY : string;
  MainVertexListIndex : ANE_INT32;
  AVertex, FirstVertex, SecondVertex : TVertex;
  XDir, YDir : integer;
  ACellList : TList;
  RowAbove, RowBelow, ColumnAbove, ColumnBelow : integer;
  RowAbove1, RowBelow1, ColumnAbove1, ColumnBelow1 : integer;
  RowAbove2, RowBelow2, ColumnAbove2, ColumnBelow2 : integer;
  StartRow, EndRow, StartColumn, EndColumn : integer;
  XDist, YDist, Dist : double;
  TempVertexList : TList;
  RowIndex, ColumnIndex : ANE_INT32;
  XSegmentDir, YSegmentDir : integer;
  CellIndex1, CellIndex2 : integer;
  FirstCell, SecondCell : TCell;
  MainCellListIndex : integer;
  ACell, AnotherCell : TCell;
  CellInList : boolean ;
begin
  try
    begin
          ANE_ExportTextFromOtherLayer(myHandle, InfoLayerHandle, @InfoText );
          InfoTextString := String(InfoText);
          InfoTextList := TStringList.Create;
          While (Pos(Chr(10), InfoTextString) > 0) do
          begin
             AString := Copy(InfoTextString,1,Pos(Chr(10), InfoTextString) -1);
             InfoTextString := Copy(InfoTextString,Pos(Chr(10), InfoTextString)+1,
                               Length(InfoTextString));
             InfoTextList.Add(AString);
          end;
          For InfoListIndex := 0 to InfoTextList.Count -1 do
          begin
            if Pos('# X pos',InfoTextList.Strings[InfoListIndex]) > 0 then
            begin
              AVertexList := TList.Create;
              MainVertexList.Add(AVertexList);
              AString := InfoTextList.Strings[InfoListIndex -1];
              AString := Copy(AString,1,Pos(Chr(09),AString)-1);
              NumVerticies := StrToInt(AString);
              For VertexIndex := InfoListIndex +1 to InfoListIndex + NumVerticies do
              begin
                AString := InfoTextList.Strings[VertexIndex];
                ThisX := Copy(AString,1,Pos(Chr(09),AString)-1);
                ThisY := Copy(AString,Pos(Chr(09),AString)+1,Length(AString));
                AVertex := TVertex.Create;
                AVertex.XPos := StrToFloat(ThisX);
                AVertex.YPos := StrToFloat(ThisY);
                AVertexList.Add(AVertex);
              end;
            end;
          end;
          InfoTextList.Free;
          for MainVertexListIndex := 0 to MainVertexList.Count -1 do
          begin
            AVertexList := MainVertexList.Items[MainVertexListIndex];
            For VertexIndex := 0 to AVertexList.Count - 1 do
            begin
              AVertex := AVertexList.Items[VertexIndex];
              // Convert to polar coordinates
              if (AVertex.XPos = 0)
              then
                begin
                  AVertex.Distance := AVertex.YPos;
                  If AVertex.YPos > 0
                  then
                    begin
                      AVertex.Angle := Pi/2;
                    end
                  else
                    begin
                      AVertex.Angle := -Pi/2;
                    end;
                end
              else
                begin
                  AVertex.Distance := Sqrt(Sqr(AVertex.XPos) + Sqr(AVertex.YPos));
                  AVertex.Angle := ArcTan(AVertex.YPos/AVertex.XPos);
                  if AVertex.XPos < 0 then
                  begin
                    AVertex.Angle := AVertex.Angle - Pi ;
                  end;
                end;
              // Rotate by Grid Angle
              AVertex.Angle := AVertex.Angle - GridAngle;
              If AVertex.Angle < Pi then
              begin
                AVertex.Angle := AVertex.Angle + 2*Pi;
              end;
              // Convert rotated coordinates back to cartesian coordinates.
              AVertex.XPos := AVertex.Distance * Cos(AVertex.Angle);
              AVertex.YPos := AVertex.Distance * Sin(AVertex.Angle);
            end;
          end;

          // XDir and YDir indicate the direction of row and column numbering.
          if TReal(RowList.Items[0]).Value < TReal(RowList.Items[RowList.Count-1]).Value
          then
            begin
              YDir := 1
            end
          else
            begin
              YDir := -1
            end;
          if TReal(ColumnList.Items[0]).Value < TReal(ColumnList.Items[ColumnList.Count-1]).Value
          then
            begin
              XDir := 1
            end
          else
            begin
              XDir := -1
            end;

          for MainVertexListIndex := 0 to MainVertexList.Count -1 do
          begin
            AVertexList := MainVertexList.Items[MainVertexListIndex];
            ACellList := TList.Create;
            MainCellList.Add(ACellList);
            // Determine Cell (if any) in which the first point of the contour is located.
            if AVertexList.Count > 0 then
            begin
              FirstVertex := AVertexList.Items[0];
              FirstVertex.TempRowVertex := False;
              FirstVertex.TempColumnVertex := False;
              AddCellsIntersectingVertex(FirstVertex, ACellList, XDir, YDir,
                       RowAbove1, RowBelow1, ColumnAbove1, ColumnBelow1, 1, 1, True );
              For VertexIndex := 1 to AVertexList.Count - 1 do
              begin
                SecondVertex := AVertexList.Items[VertexIndex];
                SecondVertex.TempRowVertex := False;
                SecondVertex.TempColumnVertex := False;
                AddCellsIntersectingVertex(SecondVertex, ACellList, XDir, YDir,
                         RowAbove2, RowBelow2, ColumnAbove2, ColumnBelow2, 1, 1,  False );

                if RowAbove2 > RowBelow1
                then
                  begin
                    StartRow := RowAbove1;
                    EndRow := RowBelow2;
                  end
                else
                  begin
                    StartRow := RowAbove2;
                    EndRow := RowBelow1;
                  end;
                if ColumnAbove2 > ColumnBelow1
                then
                  begin
                    StartColumn := ColumnAbove1;
                    EndColumn := ColumnBelow2;
                  end
                else
                  begin
                    StartColumn := ColumnAbove2;
                    EndColumn := ColumnBelow1;
                  end;
                XDist := SecondVertex.XPos - FirstVertex.XPos;
                YDist := SecondVertex.YPos - FirstVertex.YPos;

                TempVertexList := TList.Create;

                if not (Abs(XDist)/(Abs(XDist)+Abs(YDist)) < 3e-15) then
                begin
                  For ColumnIndex := StartColumn to EndColumn  do
                  begin
                    AVertex := TVertex.Create;
                    AVertex.XPos := TReal(ColumnList.Items[ColumnIndex]).Value;

                    Avertex.YPos := FirstVertex.YPos + ((AVertex.XPos - FirstVertex.XPos)/XDist)*YDist;
                    AVertex.TempRowVertex := False;
                    AVertex.TempColumnVertex := True;
                    TempVertexList.Add(AVertex);
                  end;
                end;
                if not (Abs(YDist)/(Abs(XDist)+Abs(YDist)) < 3e-15) then
                begin
                  For RowIndex := StartRow to EndRow  do
                  begin
                    AVertex := TVertex.Create;
                    AVertex.YPos := TReal(RowList.Items[RowIndex]).Value;
                    Avertex.XPos := FirstVertex.XPos + ((AVertex.YPos - FirstVertex.YPos)/YDist)*XDist;
                    AVertex.TempRowVertex := True;
                    AVertex.TempColumnVertex := False;
                    TempVertexList.Add(AVertex);
                  end;
                end;
                if not (Abs(XDist)/(Abs(XDist)+Abs(YDist)) < 3e-15) then
                begin
                  if (XDist > 0)
                  then
                    begin
                      TempVertexList.Sort(CompareVerticiesXDirPositive);
                    end
                  else
                    begin
                      TempVertexList.Sort(CompareVerticiesXDirNegative);
                    end;
                end;
                if not (Abs(YDist)/(Abs(XDist)+Abs(YDist)) < 3e-15) then
                begin
                  if (YDist > 0)
                  then
                    begin
                      TempVertexList.Sort(CompareVerticiesYDirPositive);
                    end
                  else
                    begin
                      TempVertexList.Sort(CompareVerticiesYDirNegative);
                    end;
                end;
                for TempVertexIndex := 0 to TempVertexList.Count -1 do
                begin
                  AVertex := TempVertexList.Items[TempVertexIndex];
                  if XDist = 0
                  then
                    begin
                      XSegmentDir := XDir;
                    end
                  else
                    begin
                      XSegmentDir := XDir*Round(XDist/Abs(XDist));
                    end;
                  if YDist = 0
                  then
                    begin
                      YSegmentDir := YDir;
                    end
                  else
                    begin
                      YSegmentDir := YDir*Round(YDist/Abs(YDist));
                    end;

                  AddCellsIntersectingVertex(AVertex, ACellList, XDir, YDir,
                            RowAbove, RowBelow, ColumnAbove, ColumnBelow,
                            XSegmentDir, YSegmentDir, True );
                end;

                AddCellsIntersectingVertex(SecondVertex, ACellList, XDir, YDir,
                         RowAbove2, RowBelow2, ColumnAbove2, ColumnBelow2, 1, 1, True );


                RowAbove1 := RowAbove2;
                RowBelow1 := RowBelow2;
                ColumnAbove1 := ColumnAbove2;
                ColumnBelow1 := ColumnBelow2;
                FirstVertex := SecondVertex;
              end; //  For VertexIndex := 1 to AVertexList.Count - 1 do
            end; // if AVertexList.Count > 0 then
            CellIndex1 := 0;
            While CellIndex1 < ACellList.Count -1 do
            begin
              FirstCell := ACellList.Items[CellIndex1];
              CellIndex2 := ACellList.Count -1;
              While CellIndex2 > CellIndex1  do
              begin
                SecondCell := ACellList.Items[CellIndex2];
                if (FirstCell.Row = SecondCell.Row) and (FirstCell.Column = SecondCell.Column) then
                begin
                  ACellList.Delete(CellIndex2);
                  SecondCell.Free;
                end; //if (FirstCell.Row = SecondCell.Row) and (FirstCell.Column = SecondCell.Column) then
                Dec(CellIndex2);
              end; //While CellIndex2 > CellIndex1  do
              Inc(CellIndex1);
            end; //While CellIndex1 < ACellList.Count -1 do
            ACellList.Pack;
            ACellList.Capacity := ACellList.Count;
          end; // for MainVertexListIndex := 0 to MainVertexList.Count -1 do
          for MainCellListIndex := 0 to MainCellList.Count -1 do
          begin
            ACellList := MainCellList.Items[MainCellListIndex];
            For CellIndex1 := 0 to ACellList.Count - 1 do
            begin
              ACell := ACellList.Items[CellIndex1];
              CellInList := False;
              For CellIndex2 := 0 to CombinedCellList.Count -1 do
              begin
                AnotherCell := CombinedCellList.Items[CellIndex2];
                if (ACell.Row = AnotherCell.Row) and (ACell.Column = AnotherCell.Column) then
                begin
                  CellInList := True;
                end;
              end; // For CellIndex2 := 0 to CombinedCellList.Count -1 do
              if not CellInList then
              begin
                CombinedCellList.Add(ACell);
              end;
            end; // For CellIndex1 := 0 to ACellList.Count - 1 do
          end; // for MainVertexListIndex := 0 to MainVertexList.Count -1 do
          result := 1;
    end;
  Except on Exception do
    begin
      result := 0;
    end;
  end;

end;







procedure GInitializeVertexMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_BOOL;
//  param1 : ANE_STR;          // name of information layer.
//  param : PParameter_array;
//  InfoLayerHandle :ANE_PTR;
  ListIndex, InnerListIndex : integer;
  AVertexList : TList;
  AVertex: TVertex;
  ACellList : TList;
  ACell : TCell;


begin
  try
    begin
      if GridImportOK
      then
        begin
          if (MainVertexList = nil)
          then
            begin
              MainVertexList := TList.Create;
            end
          else
            begin
              For ListIndex := MainVertexList.Count -1 downto 0 do
              begin
                AVertexList := MainVertexList.Items[ListIndex];
                For InnerListIndex := AVertexList.Count -1 downto 0 do
                begin
                  AVertex := AVertexList.Items[InnerListIndex];
                  AVertex.Free;
                end;
                AVertexList.Clear;
                AVertexList.Free;
              end;
              MainVertexList.Clear;
            end;
          if (MainCellList = nil)
          then
            begin
              MainCellList := TList.Create;
            end
          else
            begin
              For ListIndex := MainCellList.Count -1 downto 0 do
              begin
                ACellList := MainCellList.Items[ListIndex];
                For InnerListIndex := ACellList.Count -1 downto 0 do
                begin
                  ACell := ACellList.Items[InnerListIndex];
                  ACell.Free;
                end;
                ACellList.Clear;
                ACellList.Free;
              end;
              MainCellList.Clear;
            end;
          if (CombinedCellList = nil)
          then
            begin
              CombinedCellList := TList.Create;
            end
          else
            begin
              CombinedCellList.Clear;
            end;

{
          param := @parameters^;
          param1 :=  param^[0];
          InfoLayerHandle := ANE_LayerGetHandleByName(myHandle, param1 );
}
          result := 1;


        end // if GridImportOK then
      else
        begin
          result := 0;
        end;


    end;
  Except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GAddVertexMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_BOOL;
  param1 : ANE_STR;          // name of information layer.
  param : PParameter_array;
  InfoLayerHandle :ANE_PTR;
  ListIndex, InnerListIndex : integer;
  ACellList : TList;
  ACell : TCell;


begin
  try
    begin
      if GridImportOK
      then
        begin
          if (MainVertexList = nil)
          then
            begin
              MainVertexList := TList.Create;
            end;
          if (MainCellList = nil)
          then
            begin
              MainCellList := TList.Create;
            end
          else
            begin
              For ListIndex := MainCellList.Count -1 downto 0 do
              begin
                ACellList := MainCellList.Items[ListIndex];
                For InnerListIndex := ACellList.Count -1 downto 0 do
                begin
                  ACell := ACellList.Items[InnerListIndex];
                  ACell.Free;
                end;
                ACellList.Clear;
                ACellList.Free;
              end;
              MainCellList.Clear;
            end;
          if (CombinedCellList = nil)
          then
            begin
              CombinedCellList := TList.Create;
            end
          else
            begin
              CombinedCellList.Clear;
            end;


          param := @parameters^;
          param1 :=  param^[0];
          InfoLayerHandle := ANE_LayerGetHandleByName(myHandle, param1 );
          result := AddObjectsFromLayer(myHandle, InfoLayerHandle);


        end // if GridImportOK
      else
        begin
          result := 0;
        end; // if GridImportOK


    end;
  Except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;



procedure GListCreateMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  AVertexList : TList;
  result : ANE_INT32;
begin
  try
    begin
      AVertexList := TList.Create;
      MainVertexList.Add(AVertexList);
      result := MainVertexList.Count -1;
    end;
  Except on Exception do
    begin
      AVertexList.Free;
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

{
procedure GPIEAddToListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AVertexList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List to which value will be added.
  param2_ptr : ANE_DOUBLE_PTR;
  param2 : ANE_DOUBLE;         // value to be added.
  result : ANE_INT32;           // position in list of item that was added.
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      AReal := TReal.Create;
      AReal.Value := param2;
      AVertexList := MainVertexList.Items[param1];
      AVertexList.Add(AReal);
      result := AVertexList.Count -1;
    end;
  except on Exception do
    begin
      AReal.Free;
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;
}

{
procedure GPIEAddToRowListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  param1_ptr : ANE_DOUBLE_PTR;
  param1 : ANE_DOUBLE;          // value to be added.
  result : ANE_INT32;           // position in list of item that was added.
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AReal := TReal.Create;
      AReal.Value := param1;
      RowList.Add(AReal);
      result := RowList.Count -1;
    end;
  except on Exception do
    begin
      AReal.Free;
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;
}

{
procedure GPIEAddToColumnListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  param1_ptr : ANE_DOUBLE_PTR;
  param1 : ANE_DOUBLE;          // value to be added.
  result : ANE_INT32;           // position in list of item that was added.
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AReal := TReal.Create;
      AReal.Value := param1;
      ColumnList.Add(AReal);
      result := ColumnList.Count -1;
    end;
  except on Exception do
    begin
      AReal.Free;
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;
}

{
procedure GPIEGetFromListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AVertexList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List containing item
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // position in list of item .
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
      AVertexList := MainVertexList.Items[param1];
      AReal := AVertexList.Items[param2];
      result := AReal.Value;
    end;
  except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;
}

{
procedure GPIEGetFromRowListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // position in list of item .
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AReal := RowList.Items[param1];
      result := AReal.Value;
    end;
  except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;
}

{
procedure GPIEGetFromColumnListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // position in list of item .
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AReal := ColumnList.Items[param1];
      result := AReal.Value;
    end;
  except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;
}

{
procedure GGetCountOfVertexListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
//  AVertexList : TList;
  result : ANE_INT32;
begin
  try
    begin
      if not (MainVertexList = nil)
      then
        begin
          result := MainVertexList.Count;
        end
      else
        begin
          result := 0;
        end;
    end;
  Except on Exception do
    begin
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;
}

{
procedure GGetCountOfAVertexListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
//  AVertexList : TList;
  result : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  param : PParameter_array;
  AList : TList;

begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      AList := MainVertexList[ListIndex];
      result := AList.Count;
    end;
  Except on Exception do
    begin
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;
}

procedure GGetCountOfCellListsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
begin
  try
    begin
      if not (MainCellList = nil)
      then
        begin
          result := MainCellList.Count;
        end
      else
        begin
          result := 0;
        end;
    end;
  Except on Exception do
    begin
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GGetCountOfACellListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  param : PParameter_array;
  AList : TList;

begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      AList := MainCellList[ListIndex];
      result := AList.Count;
    end;
  Except on Exception do
    begin
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GGetCellRowMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  CellIndex : ANE_INT32;          // position in list of item .
  param : PParameter_array;
  AList : TList;
  ACell : TCell;

begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      CellIndex :=  param2_ptr^;
      AList := MainCellList[ListIndex];
      ACell := AList[CellIndex];
      result := ACell.Row
    end;
  Except on Exception do
    begin
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GGetCellColumnMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  CellIndex : ANE_INT32;          // position in list of item .
  param : PParameter_array;
  AList : TList;
  ACell : TCell;

begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      CellIndex :=  param2_ptr^;
      AList := MainCellList[ListIndex];
      ACell := AList[CellIndex];
      result := ACell.Column;
    end;
  Except on Exception do
    begin
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GGetCountOfCombinedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;

begin
  try
    begin
      result := CombinedCellList.Count;
    end;
  Except on Exception do
    begin
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GGetCellRowFromCombinedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  CellIndex : ANE_INT32;          // position in list of item .
  param : PParameter_array;
  ACell : TCell;

begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      CellIndex :=  param1_ptr^;
      ACell := CombinedCellList[CellIndex];
      result := ACell.Row
    end;
  Except on Exception do
    begin
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GGetCellColumnFromCombinedListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
  param1_ptr : ANE_INT32_PTR;
  CellIndex : ANE_INT32;          // position in list of item .
  param : PParameter_array;
  ACell : TCell;

begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      CellIndex :=  param1_ptr^;
      ACell := CombinedCellList[CellIndex];
      result := ACell.Column
    end;
  Except on Exception do
    begin
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;





procedure GListFreeVertexMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_BOOL;
  ListIndex, InnerListIndex : integer;
  AVertexList : TList;
  AReal : TReal;
begin
  try
    begin
      For ListIndex := MainVertexList.Count -1 downto 0 do
      begin
        AVertexList := MainVertexList.Items[ListIndex];
        For InnerListIndex := AVertexList.Count -1 downto 0 do
        begin
          AReal := AVertexList.Items[InnerListIndex];
          AReal.Free;
        end;
        AVertexList.Clear;
        AVertexList.Free;
      end;
      MainVertexList.Clear;
      MainVertexList.Free;
      MainVertexList := nil;
      result :=1;
    end;
  Except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;



procedure GListFreeBlockMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_BOOL;
  ListIndex, InnerListIndex : integer;
  AVertexList : TList;
  AReal : TReal;
  AVertex : TVertex;
  ACellList : TList ;
  ACell : TCell;
begin
  try
    begin
      if not (RowList = nil) then
      begin
        For ListIndex := RowList.Count -1 downto 0 do
        begin
          AReal := RowList.Items[ListIndex];
          AReal.Free;
        end;
        RowList.Clear;
        RowList.Free;
        RowList := nil;
      end;
      if not (ColumnList = nil) then
      begin
        For ListIndex := ColumnList.Count -1 downto 0 do
        begin
          AReal := ColumnList.Items[ListIndex];
          AReal.Free;
        end;
        ColumnList.Clear;
        ColumnList.Free;
        ColumnList := nil;
      end;
      if not (MainVertexList = nil) then
      begin
        For ListIndex := MainVertexList.Count -1 downto 0 do
        begin
          AVertexList := MainVertexList.Items[ListIndex];
          For InnerListIndex := AVertexList.Count -1 downto 0 do
          begin
            AVertex := AVertexList.Items[InnerListIndex];
            AVertex.Free;
          end;
          AVertexList.Clear;
          AVertexList.Free;
        end;
        MainVertexList.Clear;
        MainVertexList.Free;
        MainVertexList := nil;
      end;
      if not (MainCellList = nil) then
      begin
        For ListIndex := MainCellList.Count -1 downto 0 do
        begin
          ACellList := MainCellList.Items[ListIndex];
          For InnerListIndex := ACellList.Count -1 downto 0 do
          begin
            ACell := ACellList.Items[InnerListIndex];
            ACell.Free;
          end;
          ACellList.Clear;
          ACellList.Free;
        end;
        MainCellList.Clear;
        MainCellList.Free;
        MainCellList := nil;
      end;
      if not (CombinedCellList = nil) then
      begin
        CombinedCellList.Clear;
        CombinedCellList.Free;
        CombinedCellList := nil;
      end;
      GridImportOK := False;
      result :=1;
    end;
  Except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;



procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
        {$ASSERTIONS OFF}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

	numNames := 0;

        // Initialize all lists.
	gPIEInitializeBlockFDesc.name := 'InitializeGridInformation';	// name of function
	gPIEInitializeBlockFDesc.address := GInitializeBlockMMFun;	// function address
	gPIEInitializeBlockFDesc.returnType := kPIEInteger;		// return value type
	gPIEInitializeBlockFDesc.numParams :=  1;			// number of parameters
	gPIEInitializeBlockFDesc.numOptParams := 0;			// number of optional parameters
	gPIEInitializeBlockFDesc.paramNames := @gpnGrid;		// pointer to parameter names list
	gPIEInitializeBlockFDesc.paramTypes := @g1String;	        // pointer to parameters types list
	gPIEInitializeBlockFDesc.functionFlags := 0;	                // options

       	gPIEInitializeBlockDesc.name  := 'InitializeGridInformation';	// name of PIE
	gPIEInitializeBlockDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEInitializeBlockDesc.descriptor := @gPIEInitializeBlockFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEInitializeBlockDesc;                  // add descriptor to list
        Inc(numNames);	                                                 // increment number of names


        // Initialize list of lists of verticies.
	gPIEInitializeVertexFDesc.name := 'InitializeVertexList';	// name of function
	gPIEInitializeVertexFDesc.address := GInitializeVertexMMFun;	// function address
	gPIEInitializeVertexFDesc.returnType := kPIEInteger;		// return value type
	gPIEInitializeVertexFDesc.numParams :=  0;			// number of parameters
	gPIEInitializeVertexFDesc.numOptParams := 0;			// number of optional parameters
	gPIEInitializeVertexFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEInitializeVertexFDesc.paramTypes := nil;	        // pointer to parameters types list

       	gPIEInitializeVertexDesc.name  := 'InitializeVertexList';	// name of PIE
	gPIEInitializeVertexDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEInitializeVertexDesc.descriptor := @gPIEInitializeVertexFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEInitializeVertexDesc;              // add descriptor to list
        Inc(numNames);	                                              // increment number of names


        // Add list of lists of verticies.
	gPIEAddVertexFDesc.name := 'AddVertexLayer';	        // name of function
	gPIEAddVertexFDesc.address := GAddVertexMMFun;	        // function address
	gPIEAddVertexFDesc.returnType := kPIEInteger;		// return value type
	gPIEAddVertexFDesc.numParams :=  1;			// number of parameters
	gPIEAddVertexFDesc.numOptParams := 0;			// number of optional parameters
	gPIEAddVertexFDesc.paramNames := @gpnInfo;		// pointer to parameter names list
	gPIEAddVertexFDesc.paramTypes := @g1String;	        // pointer to parameters types list

       	gPIEAddVertexDesc.name  := 'AddVertexLayer';	        // name of PIE
	gPIEAddVertexDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEAddVertexDesc.descriptor := @gPIEAddVertexFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAddVertexDesc;              // add descriptor to list
        Inc(numNames);	                                       // increment number of names

{
        // Create a new vertex list
	gPIECreateListFDesc.name := 'CreateNewVertexList';	// name of function
	gPIECreateListFDesc.address := GListCreateMMFun;	// function address
	gPIECreateListFDesc.returnType := kPIEInteger;		// return value type
	gPIECreateListFDesc.numParams :=  0;			// number of parameters
	gPIECreateListFDesc.numOptParams := 0;			// number of optional parameters
	gPIECreateListFDesc.paramNames := nil;		        // pointer to parameter names list
	gPIECreateListFDesc.paramTypes := nil;	                // pointer to parameters types list

       	gPIECreateListDesc.name  := 'CreateNewVertexList';	// name of PIE
	gPIECreateListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECreateListDesc.descriptor := @gPIECreateListFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECreateListDesc;              // add descriptor to list
        Inc(numNames);	                                        // increment number of names
}
{
        // Add Item to a vertex list
	gPIEAddFDesc.name := 'AddToVertexList';	                // name of function
	gPIEAddFDesc.address := GPIEAddToListMMFun;		// function address
	gPIEAddFDesc.returnType := kPIEInteger;		        // return value type
	gPIEAddFDesc.numParams :=  2;			        // number of parameters
	gPIEAddFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEAddFDesc.paramNames := @gpnIndexValue;		// pointer to parameter names list
	gPIEAddFDesc.paramTypes := @gIntegerDouble;	        // pointer to parameters types list

       	gPIEAddDesc.name  := 'AddToVertexList';		        // name of PIE
	gPIEAddDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEAddDesc.descriptor := @gPIEAddFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAddDesc;                     // add descriptor to list
        Inc(numNames);	                                        // increment number of names
}

{
        // Add Item to a Row list
	gPIEAddRowFDesc.name := 'AddToRowList';	                // name of function
	gPIEAddRowFDesc.address := GPIEAddToRowListMMFun;	// function address
	gPIEAddRowFDesc.returnType := kPIEInteger;		// return value type
	gPIEAddRowFDesc.numParams :=  1;			// number of parameters
	gPIEAddRowFDesc.numOptParams := 0;			// number of optional parameters
	gPIEAddRowFDesc.paramNames := @gpnRow;		        // pointer to parameter names list
	gPIEAddRowFDesc.paramTypes := @gOneFloatTypes;	        // pointer to parameters types list

       	gPIEAddRowDesc.name  := 'AddToRowList';		        // name of PIE
	gPIEAddRowDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEAddRowDesc.descriptor := @gPIEAddRowFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAddRowDesc;                  // add descriptor to list
        Inc(numNames);	                                        // increment number of names
}

{
        // Add Item to a Column list
	gPIEAddColumnFDesc.name := 'AddToColumnList';	         // name of function
	gPIEAddColumnFDesc.address := GPIEAddToColumnListMMFun;	 // function address
	gPIEAddColumnFDesc.returnType := kPIEInteger;		 // return value type
	gPIEAddColumnFDesc.numParams :=  1;			 // number of parameters
	gPIEAddColumnFDesc.numOptParams := 0;			 // number of optional parameters
	gPIEAddColumnFDesc.paramNames := @gpnColumn;		 // pointer to parameter names list
	gPIEAddColumnFDesc.paramTypes := @gOneFloatTypes;	 // pointer to parameters types list

       	gPIEAddColumnDesc.name  := 'AddToColumnList';		 // name of PIE
	gPIEAddColumnDesc.PieType :=  kFunctionPIE;		 // PIE type: PIE function
	gPIEAddColumnDesc.descriptor := @gPIEAddColumnFDesc;	 // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAddColumnDesc;                // add descriptor to list
        Inc(numNames);	                                         // increment number of names
}

{
        // Get Item From vertex list
	gPIEGetFDesc.name := 'GetFromVertexList';	        // name of function
	gPIEGetFDesc.address := GPIEGetFromListMMFun;		// function address
	gPIEGetFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetFDesc.numParams :=  2;			        // number of parameters
	gPIEGetFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetFDesc.paramNames := @gpn2Index;		        // pointer to parameter names list
	gPIEGetFDesc.paramTypes := @g2Integer;	                // pointer to parameters types list

       	gPIEGetDesc.name  := 'GetFromVertexList';		// name of PIE
	gPIEGetDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEGetDesc.descriptor := @gPIEGetFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetDesc;                     // add descriptor to list
        Inc(numNames);	                                        // increment number of names
}

{
        // Get Item From Row list
	gPIEGetRowFDesc.name := 'GetFromRowList';	                // name of function
	gPIEGetRowFDesc.address := GPIEGetFromRowListMMFun;		// function address
	gPIEGetRowFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetRowFDesc.numParams :=  1;			        // number of parameters
	gPIEGetRowFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetRowFDesc.paramNames := @gpnNumber;		        // pointer to parameter names list
	gPIEGetRowFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list

       	gPIEGetRowDesc.name  := 'GetFromRowList';		        // name of PIE
	gPIEGetRowDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEGetRowDesc.descriptor := @gPIEGetRowFDesc;	                // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetRowDesc;                          // add descriptor to list
        Inc(numNames);	                                                // increment number of names
}

{
        // Get Item From Column list
	gPIEGetColumnFDesc.name := 'GetFromColumnList';	                // name of function
	gPIEGetColumnFDesc.address := GPIEGetFromColumnListMMFun;	// function address
	gPIEGetColumnFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetColumnFDesc.numParams :=  1;			        // number of parameters
	gPIEGetColumnFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetColumnFDesc.paramNames := @gpnNumber;		        // pointer to parameter names list
	gPIEGetColumnFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list

       	gPIEGetColumnDesc.name  := 'GetFromColumnList';		        // name of PIE
	gPIEGetColumnDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEGetColumnDesc.descriptor := @gPIEGetColumnFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetColumnDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names
}
{
        // Get Count of vertex lists
	gPIEGetVertexListsCountFDesc.name := 'GetCountOfVertexLists';	        // name of function
	gPIEGetVertexListsCountFDesc.address := GGetCountOfVertexListsMMFun;	// function address
	gPIEGetVertexListsCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetVertexListsCountFDesc.numParams :=  0;			        // number of parameters
	gPIEGetVertexListsCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetVertexListsCountFDesc.paramNames := nil;		                // pointer to parameter names list
	gPIEGetVertexListsCountFDesc.paramTypes := nil;	                        // pointer to parameters types list

       	gPIEGetVertexListsCountDesc.name  := 'GetCountOfVertexLists';		        // name of PIE
	gPIEGetVertexListsCountDesc.PieType :=  kFunctionPIE;		                // PIE type: PIE function
	gPIEGetVertexListsCountDesc.descriptor := @gPIEGetVertexListsCountFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetVertexListsCountDesc;                             // add descriptor to list
        Inc(numNames);	                                                                // increment number of names
}
{
        // Get Count of a particular vertex list
	gPIEGetAVertexListCountFDesc.name := 'GetCountOfAVertexList';	        // name of function
	gPIEGetAVertexListCountFDesc.address := GGetCountOfAVertexListMMFun;	// function address
	gPIEGetAVertexListCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetAVertexListCountFDesc.numParams :=  1;			        // number of parameters
	gPIEGetAVertexListCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetAVertexListCountFDesc.paramNames := @gpnListIndex;		// pointer to parameter names list
	gPIEGetAVertexListCountFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list

       	gPIEGetAVertexListCountDesc.name  := 'GetCountOfVertexLists';		   // name of PIE
	gPIEGetAVertexListCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetAVertexListCountDesc.descriptor := @gPIEGetAVertexListCountFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetAVertexListCountDesc;                             // add descriptor to list
        Inc(numNames);	                                                                // increment number of names
}
        // Get Count of cell lists
	gPIEGetCellListsCountFDesc.name := 'GetCountOfCellLists';	        // name of function
	gPIEGetCellListsCountFDesc.address := GGetCountOfCellListsMMFun;	// function address
	gPIEGetCellListsCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetCellListsCountFDesc.numParams :=  0;			        // number of parameters
	gPIEGetCellListsCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetCellListsCountFDesc.paramNames := nil;		                // pointer to parameter names list
	gPIEGetCellListsCountFDesc.paramTypes := nil;	                        // pointer to parameters types list

       	gPIEGetCellListsCountDesc.name  := 'GetCountOfCellLists';		        // name of PIE
	gPIEGetCellListsCountDesc.PieType :=  kFunctionPIE;		                // PIE type: PIE function
	gPIEGetCellListsCountDesc.descriptor := @gPIEGetCellListsCountFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetCellListsCountDesc;                             // add descriptor to list
        Inc(numNames);	                                                                // increment number of names

        // Get Count of a particular cell list
	gPIEGetACellListCountFDesc.name := 'GetCountOfACellList';	        // name of function
	gPIEGetACellListCountFDesc.address := GGetCountOfACellListMMFun;	// function address
	gPIEGetACellListCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetACellListCountFDesc.numParams :=  1;			        // number of parameters
	gPIEGetACellListCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACellListCountFDesc.paramNames := @gpnListIndex;		// pointer to parameter names list
	gPIEGetACellListCountFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list

       	gPIEGetACellListCountDesc.name  := 'GetCountOfACellList';		   // name of PIE
	gPIEGetACellListCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACellListCountDesc.descriptor := @gPIEGetACellListCountFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACellListCountDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell Row from  a particular cell list
	gPIEGetACellRowFDesc.name := 'GetCellRow';	        // name of function
	gPIEGetACellRowFDesc.address := GGetCellRowMMFun;	// function address
	gPIEGetACellRowFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetACellRowFDesc.numParams :=  2;			        // number of parameters
	gPIEGetACellRowFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACellRowFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetACellRowFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list

       	gPIEGetACellRowDesc.name  := 'GetCellRow';		   // name of PIE
	gPIEGetACellRowDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACellRowDesc.descriptor := @gPIEGetACellRowFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACellRowDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell Column from  a particular cell list
	gPIEGetACellColumnFDesc.name := 'GetCellColumn';	        // name of function
	gPIEGetACellColumnFDesc.address := GGetCellColumnMMFun;	// function address
	gPIEGetACellColumnFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetACellColumnFDesc.numParams :=  2;			        // number of parameters
	gPIEGetACellColumnFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACellColumnFDesc.paramNames := @gpn2Index;		// pointer to parameter names list
	gPIEGetACellColumnFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list

       	gPIEGetACellColumnDesc.name  := 'GetCellColumn';		   // name of PIE
	gPIEGetACellColumnDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACellColumnDesc.descriptor := @gPIEGetACellColumnFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACellColumnDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get Count of combined cell list
	gPIEGetCombinedListCountFDesc.name := 'GetCountOfCombinedCellList';	        // name of function
	gPIEGetCombinedListCountFDesc.address := GGetCountOfCombinedListMMFun;	// function address
	gPIEGetCombinedListCountFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetCombinedListCountFDesc.numParams :=  0;			        // number of parameters
	gPIEGetCombinedListCountFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetCombinedListCountFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEGetCombinedListCountFDesc.paramTypes := nil;	        // pointer to parameters types list

       	gPIEGetCombinedListCountDesc.name  := 'GetCountOfCombinedCellList';		   // name of PIE
	gPIEGetCombinedListCountDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetCombinedListCountDesc.descriptor := @gPIEGetCombinedListCountFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetCombinedListCountDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell Row from combined cell list
	gPIEGetACombinedCellRowFDesc.name := 'GetCellRowFromCombinedList';	        // name of function
	gPIEGetACombinedCellRowFDesc.address := GGetCellRowFromCombinedListMMFun;	// function address
	gPIEGetACombinedCellRowFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetACombinedCellRowFDesc.numParams :=  1;			        // number of parameters
	gPIEGetACombinedCellRowFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACombinedCellRowFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEGetACombinedCellRowFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list

       	gPIEGetACombinedCellRowDesc.name  := 'GetCellRowFromCombinedList';		   // name of PIE
	gPIEGetACombinedCellRowDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACombinedCellRowDesc.descriptor := @gPIEGetACombinedCellRowFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACombinedCellRowDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        // Get a cell Column from combined cell list
	gPIEGetACellCombinedColumnFDesc.name := 'GetCellColumnFromCombinedList';	        // name of function
	gPIEGetACellCombinedColumnFDesc.address := GGetCellColumnFromCombinedListMMFun;	// function address
	gPIEGetACellCombinedColumnFDesc.returnType := kPIEInteger;		        // return value type
	gPIEGetACellCombinedColumnFDesc.numParams :=  1;			        // number of parameters
	gPIEGetACellCombinedColumnFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetACellCombinedColumnFDesc.paramNames := @gpnNumber;		// pointer to parameter names list
	gPIEGetACellCombinedColumnFDesc.paramTypes := @gOneIntegerTypes;	        // pointer to parameters types list

       	gPIEGetACellCombinedColumnDesc.name  := 'GetCellColumnFromCombinedList';		   // name of PIE
	gPIEGetACellCombinedColumnDesc.PieType :=  kFunctionPIE;		           // PIE type: PIE function
	gPIEGetACellCombinedColumnDesc.descriptor := @gPIEGetACellCombinedColumnFDesc;   // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetACellCombinedColumnDesc;                       // add descriptor to list
        Inc(numNames);	                                                // increment number of names

        //Free List of lists of verticies
	gPIEFreeListVertexFDesc.name := 'FreeVertexList';	        // name of function
	gPIEFreeListVertexFDesc.address := GListFreeVertexMMFun;	// function address
	gPIEFreeListVertexFDesc.returnType := kPIEInteger;		// return value type
	gPIEFreeListVertexFDesc.numParams :=  0;			// number of parameters
	gPIEFreeListVertexFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeListVertexFDesc.paramNames := nil;		        // pointer to parameter names list
	gPIEFreeListVertexFDesc.paramTypes := nil;	                // pointer to parameters types list

       	gPIEFreeListVertexDesc.name  := 'FreeVertexList';		// name of PIE
	gPIEFreeListVertexDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEFreeListVertexDesc.descriptor := @gPIEFreeListVertexFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeListVertexDesc;                  // add descriptor to list
        Inc(numNames);	                                                // increment number of names


        //Free All Lists
	gPIEFreeListBlockFDesc.name := 'FreeAllBlockLists';	                // name of function
	gPIEFreeListBlockFDesc.address := GListFreeBlockMMFun;	        // function address
	gPIEFreeListBlockFDesc.returnType := kPIEInteger;		// return value type
	gPIEFreeListBlockFDesc.numParams :=  0;			        // number of parameters
	gPIEFreeListBlockFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeListBlockFDesc.paramNames := nil;		        // pointer to parameter names list
	gPIEFreeListBlockFDesc.paramTypes := nil;	                // pointer to parameters types list

       	gPIEFreeListBlockDesc.name  := 'FreeAllBlockLists';		        // name of PIE
	gPIEFreeListBlockDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEFreeListBlockDesc.descriptor := @gPIEFreeListBlockFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeListBlockDesc;                   // add descriptor to list
        Inc(numNames);	                                                // increment number of names


	descriptors := @gFunDesc;

end;

end.
