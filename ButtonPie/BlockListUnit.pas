unit BlockListUnit;

interface

uses Windows, {Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls,}
  Classes, SysUtils, Dialogs, // Windows,
  AnePIE {, FunctionPie}, UtilityFunctions;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

  TReal = Class (TObject)
    Value : double;
  end;

var
        GridAngle : ANE_DOUBLE;
        MainVertexList : TList;
        MainCellList : TList;
        RowList : TList;
        ColumnList : TList;
        GridImportOK : boolean = False;
        CrossRowCellsList : TList;
        CrossColumnCellsList : TList;
        RowMiddleList : TList;
        ColumnMiddleList : TList;
        ErrorCount : integer = 0;

function GAddVertex(myHandle : ANE_PTR;
  Information_Layer_Name : ANE_STR) : ANE_BOOL;
  
procedure GAddVertexMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;


implementation

uses
   ANECB, CellVertexUnit, CombinedListUnit, InitializeLists, OptionsUnit ;
// This returns true if there is already a cell in AList with the same row and column as
// ACell and the vertex currently being tested is part of the same line segment as
// the last vertex addded to the VertexList.
// SimilarCell is set to the cell that is at the same position as ACell.
Function SimilarCellInList (ACell : TCell; AList : Tlist;
         var SimilarCell : TCell; AVertex : TBL_Vertex) : boolean;
var
  ACellInList : TCell;
  i : integer;
  LastVertex : TBL_Vertex;
  SegmentDifference : double;
begin
  SimilarCell := nil;
  result := false;
  for i := 0 to AList.Count -1 do
  begin
     ACellInList := AList.Items[i];
     if (ACell.Column = ACellInList.Column) and (ACell.Row = ACellInList.Row) then
     begin
       if ACellInList.VertexList.Count > 0 then
       begin
         LastVertex := ACellInList.VertexList.Items[ACellInList.VertexList.Count-1];
         SegmentDifference := AVertex.Segment - LastVertex.Segment;
         if (SegmentDifference < 0.75) or
            ( (SegmentDifference < 1.1) and Odd(Round(LastVertex.Segment*2))
                                        and Odd(Round(AVertex.Segment*2)) ) then
         begin
           SimilarCell := ACellInList;
           result := True;
         end
       end;
     end;
  end;
end;

Function Sign (X : real) : integer;
begin
  if x >= 0
  then
    begin
      result := 1;
    end
  else
    begin
      result := -1;
    end;
end;

// gets the character used as a decimal separator in the local language.
function GetDecChar : Char;
VAR
  SelectedLCID : LCID;
  AString : string;
begin
  SelectedLCID := GetUserDefaultLCID;
  AString := GetLocaleStr(SelectedLCID, LOCALE_SDECIMAL, '.');
  result := AString[1];
end;

function LocalStrToFloat(const S: string): Extended;
var
  DecimalPosition : integer;
  DecimalChar : string;
  AString : string;
begin
  AString := S;
  DecimalChar := GetDecChar;
  if not (DecimalChar = '.') then
  begin
    DecimalPosition := Pos('.', S);
    if DecimalPosition > 0
    then
      begin
        AString := Copy(S, 1, DecimalPosition -1) + DecimalChar
          + Copy(S, DecimalPosition + 1, Length(S));
      end;
  end;
  result := StrToFloat(AString);
end;

// This tests whether there is a cell anywhere in the grid that intersects
// AVertex. If so, it creates a cell object and adds it to ACellList if no
// similar cell already exists and AddToCellList is true. A copy of AVertex
// is added to the VertexList
// of either the new cell or the existing cell at the same position as the new
// cell. If there is already a similar cell, the new cell is destroyed.
// Cells are added to the list in the order in which they occur along the segment.
// XSegmentDir, and YSegmentDir indicate the direction of the segment.
// This is needed to determine what to set as the row and column properties of
// the new cell.
function AddCellsIntersectingVertex(AVertex : TBL_Vertex ; ACellList : TList;
  XDir, YDir : integer; var RowAbove, RowBelow, ColumnAbove, ColumnBelow : integer ;
  XSegmentDir, YSegmentDir : integer;
  AddToCellList : Boolean) : Boolean;
const
  RoundError = 1e-13 ;
var
  MiddleRow, MiddleColumn : integer;
  ACell : TCell;
  SimilarCell : TCell;
  XSign, YSign : integer;
begin
  // initialize data
  result := False;
  RowAbove := RowList.Count ;
  RowBelow := 0;
  ColumnAbove := ColumnList.Count ;
  ColumnBelow := 0;
  XSign := Sign(AVertex.XPos);
  YSign := Sign(AVertex.YPos);
  // Determine the row above and below the current vertex.
  if ((AVertex.YPos = TReal(RowList.Items[0]).Value) or
     (YDir*AVertex.YPos / (1 - YSign * RoundError) + RoundError{} > YDir*TReal(RowList.Items[0]).Value )) and
     ((AVertex.YPos = TReal(RowList.Items[RowList.Count -1]).Value) or
           (YDir*AVertex.YPos * (1 - YSign * RoundError) - RoundError{} < YDir*TReal(RowList.Items[RowList.Count -1]).Value ))
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
  // Determine the column above and below the current vertex.

  if ((AVertex.XPos = TReal(ColumnList.Items[0]).Value) or
    (XDir*AVertex.XPos / (1 - XSign * RoundError) + RoundError{} > XDir*TReal(ColumnList.Items[0]).Value)) and
    ((AVertex.XPos = TReal(ColumnList.Items[ColumnList.Count -1]).Value) or
           (XDir*AVertex.XPos * (1 - XSign * RoundError) - RoundError{} < XDir*TReal(ColumnList.Items[ColumnList.Count -1]).Value))
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

  // Add cells if the vertex is inside the grid and AddToCellList is true.
  if AddToCellList and
    ((AVertex.YPos = TReal(RowList.Items[0]).Value) or
           (YDir*{SQR(}AVertex.YPos{)} / (1 - YSign * RoundError) + RoundError{} > YDir*TReal(RowList.Items[0]).Value                     {*AVertex.YPos})) and
    ((AVertex.YPos = TReal(RowList.Items[RowList.Count -1]).Value) or
           (YDir*{SQR(}AVertex.YPos{)} * (1 - YSign * RoundError) - RoundError{} < YDir*TReal(RowList.Items[RowList.Count -1]).Value      {*AVertex.YPos})) and
    ((AVertex.XPos = TReal(ColumnList.Items[0]).Value) or
           (XDir*{SQR(}AVertex.XPos{)} / (1 - XSign * RoundError) + RoundError{} > XDir*TReal(ColumnList.Items[0]).Value                  {*AVertex.XPos})) and
    ((AVertex.XPos = TReal(ColumnList.Items[ColumnList.Count -1]).Value) or
           (XDir*{SQR(}AVertex.XPos{)} * (1 - XSign * RoundError) - RoundError{} < XDir*TReal(ColumnList.Items[ColumnList.Count -1]).Value{*AVertex.XPos}))
           then
  begin
    ACell := TCell.Create;
    if  AVertex.TempRowVertex and (YSegmentDir = 1 )
    then
      begin
        ACell.Row := RowBelow;
      end
    else
      begin
        ACell.Row := RowAbove;
      end;
    if  AVertex.TempColumnVertex and (XSegmentDir = 1)
    then
      begin
        ACell.Column := ColumnBelow;
      end
    else
      begin
        ACell.Column := ColumnAbove;
      end;
    if not(ACell.Column = 0) and not (ACell.Row = 0)
      and (ACell.Column <> ColumnList.Count) and (ACell.Row <> RowList.Count)
    then
      begin
        if SimilarCellInList (ACell, ACellList, SimilarCell, AVertex)
        then
          begin
            SimilarCell.VertexList.Add(AVertex.CopyOfVertex);
            ACell.Free;
            result := True;
          end
        else
          begin
            ACell.VertexList.Add(AVertex.CopyOfVertex);
            ACellList.Add(ACell);
            result := True;
          end;
      end
    else
      begin
        ACell.Free;
      end;
    // if the vertex is on a row boundary create another cell on the other
    // side of the row boundary and add it to the list.
    if {(RowBelow > 0) and }
       (AVertex.YPos = TReal(RowList.Items[RowBelow]).Value)
       then
    begin
        ACell := TCell.Create;
        if AVertex.TempRowVertex and (YSegmentDir = 1 )
        then
          begin
            ACell.Row := RowAbove;
          end
        else
          begin
            ACell.Row := RowBelow;
          end;
        if  AVertex.TempColumnVertex and (XSegmentDir = 1)
        then
          begin
            ACell.Column := ColumnBelow;
          end
        else
          begin
            ACell.Column := ColumnAbove;
          end;
//        ACell.Column := ColumnAbove;
        if (ACell.Column <> 0) and (ACell.Row <> 0)
          and (ACell.Column <> ColumnList.Count) and (ACell.Row <> RowList.Count)
        then
          begin
            if {(ACell.Row = RowList.Count-1) or} SimilarCellInList(ACell, ACellList, SimilarCell, AVertex)
            then
              begin
                {if not ( ACell.Row = RowList.Count -1) then }
                begin
                  SimilarCell.VertexList.Add(AVertex.CopyOfVertex);
                end;
                ACell.Free;
                result := True;
              end
            else
              begin
                ACell.VertexList.Add(AVertex.CopyOfVertex);
                ACellList.Add(ACell);
                result := True;
              end;
          end
        else
          begin
            ACell.Free;
          end;

    end; // if (RowBelow > 0) and (AVertex.YPos = TReal(RowList.Items[RowBelow]).Value)  and not AVertex.TempRowVertex
    // if the vertex is on a column boundary, create another cell on the
    // other side of the column boundary and add it to the list.
    if {(ColumnBelow > 0) and }
       (AVertex.XPos = TReal(ColumnList.Items[ColumnBelow]).Value)
       then
    begin
        ACell := TCell.Create;
        if  AVertex.TempRowVertex and (YSegmentDir = 1 )
        then
          begin
            ACell.Row := RowBelow;
          end
        else
          begin
            ACell.Row := RowAbove;
          end;
//        ACell.Row := RowBelow;
       if AVertex.TempColumnVertex and (XSegmentDir = 1)
        then
          begin
            ACell.Column := ColumnAbove ;
          end
        else
          begin
            ACell.Column := ColumnBelow;
          end;
        if (ACell.Column <> 0) and (ACell.Row <> 0)
          and (ACell.Column <> ColumnList.Count) and (ACell.Row <> RowList.Count)
        then
          begin
            if {(ACell.Column = ColumnList.Count-1) or }
              SimilarCellInList (ACell, ACellList, SimilarCell, AVertex)
            then
              begin
                {if not (ACell.Column = ColumnList.Count-1) then}
                begin
                  SimilarCell.VertexList.Add(AVertex.CopyOfVertex);
                end;
                ACell.Free;
                result := True;
              end
            else
              begin
                ACell.VertexList.Add(AVertex.CopyOfVertex);
                ACellList.Add(ACell);
                result := True;
              end;
          end
        else
          begin
            ACell.Free;
          end;
    end; // if (ColumnBelow > 0) and (AVertex.XPos = TReal(ColumnList.Items[ColumnBelow]).Value) and not AVertex.TempColumnVertex
    // if the vertex is on the corner of four cells create another cell at the
    // position where one hasn't been created yet and add it to the list.
    if {(ColumnBelow > 0) and (RowBelow > 0) and  }
       (AVertex.XPos = TReal(ColumnList.Items[ColumnBelow]).Value)  and
       (AVertex.YPos = TReal(RowList.Items[RowBelow]).Value)
        then
    begin
        ACell := TCell.Create;
        if AVertex.TempRowVertex and (YSegmentDir = 1 )
        then
          begin
            ACell.Row := RowAbove;
          end
        else
          begin
            ACell.Row := RowBelow;
          end;
//        ACell.Row := RowBelow;
       if AVertex.TempColumnVertex and (XSegmentDir = 1)
        then
          begin
            ACell.Column := ColumnAbove ;
          end
        else
          begin
            ACell.Column := ColumnBelow;
          end;
//        ACell.Column := ColumnBelow;
        if (ACell.Column <> 0) and (ACell.Row <> 0)
          and (ACell.Column <> ColumnList.Count) and (ACell.Row <> RowList.Count)
        then
          begin
            if {(ACell.Column = ColumnList.Count-1) or (ACell.Row = RowList.Count-1)
               or} SimilarCellInList (ACell, ACellList, SimilarCell, AVertex)
            then
              begin
                {if not (ACell.Column = ColumnList.Count-1) and
                   not (ACell.Row = RowList.Count-1) then}
                begin
                  SimilarCell.VertexList.Add(AVertex.CopyOfVertex);
                end;
                ACell.Free;
                result := True;
              end
            else
              begin
                ACell.VertexList.Add(AVertex.CopyOfVertex);
                ACellList.Add(ACell);
                result := True;
              end;
          end
        else
          begin
            ACell.Free;
          end;
    end; // if (RowBelow > 0) and (AVertex.YPos = TReal(RowList.Items[RowBelow]).Value)
  end; // if vertex inside grid
end;

// This is the function used by the sort method of the temp vertex list
// if the X direction of the current line segement is positive.
function CompareVerticiesXDirPositive  (Item1, Item2: Pointer): Integer;
var
  FirstVertex, SecondVertex : TBL_Vertex;
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
  FirstVertex, SecondVertex : TBL_Vertex;
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
  FirstVertex, SecondVertex : TBL_Vertex;
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
  FirstVertex, SecondVertex : TBL_Vertex;
begin
    FirstVertex := Item1 ;
    SecondVertex := Item2 ;
    if FirstVertex.YPos > SecondVertex.YPos
    then result := -1
    else if FirstVertex.YPos = SecondVertex.YPos then result := 0
    else result := 1;
end;



// This function first frees up the cell list if it is filled. It then
// reads information from the layer indicated by InfoLayerHandle
// and add verticies to the Main Vertex list based on that information. It then
// fills the Cell list.
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
  AVertex, FirstVertex, SecondVertex, AnotherVertex : TBL_Vertex;
  XDir, YDir : integer;
  ACellList, AnotherCellList : TList;
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
  SegmentIndex : integer;
  BeginningCell, EndCell : TCell;
  CrossesRowIndex : integer;
  CurrentCrossCellList, CurrentCellList : TList;
  MaxY, MinY: double;
  CurrentCell : TCell;
  CrossesColumnIndex : integer;
  MaxX, MinX: double;
  startLoop, endLoop : integer;
  APosition : integer;
  MainVertexStart : integer;
  LastCellIndex : integer;
  LayerOptions : TLayerOptions;
  ContourIndex : ANE_INT32;
  ContourObject : TContourObjectOptions;
  NodeIndex : ANE_INT32;
  X, Y : ANE_DOUBLE;
  NumberOfNodes : integer;
begin
  try
    begin
      MainVertexStart := MainVertexList.Count;

      LayerOptions := TLayerOptions.Create(InfoLayerHandle);
      try
        for ContourIndex := 0 to LayerOptions.
          NumObjects(myHandle, pieContourObject) -1 do
        begin
          AVertexList := TList.Create;
          MainVertexList.Add(AVertexList);
          ContourObject := TContourObjectOptions.Create
            (myHandle,InfoLayerHandle,ContourIndex);
          try
            NumberOfNodes := ContourObject.NumberOfNodes(myHandle);
            for NodeIndex := 0 to NumberOfNodes -1 do
            begin
              ContourObject.GetNthNodeLocation(myHandle, X, Y, NodeIndex);
              AVertex := TBL_Vertex.Create;
              AVertex.XPos := X;
              AVertex.YPos := Y;
              AVertexList.Add(AVertex);
            end;
            if NumberOfNodes = 1 then
            begin
              AVertex := AVertex.CopyOfVertex;
              AVertexList.Add(AVertex);
            end;
          finally
            ContourObject.Free;
          end;
        end;
      finally
        LayerOptions.Free(myHandle);
      end;

      {
      // Read data from layer
      ANE_ExportTextFromOtherLayer(myHandle, InfoLayerHandle, @InfoText );
      InfoTextString := String(InfoText);
      //Copy data into stringlist
      InfoTextList := TStringList.Create;
      try
        InfoTextList.Text := InfoTextString;
            // Create list of verticies from stringlist
        For InfoListIndex := 0 to InfoTextList.Count -1 do
        begin
          if Pos('# X pos',InfoTextList.Strings[InfoListIndex]) > 0 then
          begin
            AVertexList := TList.Create;
            MainVertexList.Add(AVertexList);
            AString := InfoTextList.Strings[InfoListIndex -1];
            if Pos(Chr(09),AString) > 0 then
            begin
              AString := Copy(AString,1,Pos(Chr(09),AString)-1);
            end;
            NumVerticies := StrToInt(AString);
            AVertex := nil;
            For VertexIndex := InfoListIndex +1 to InfoListIndex + NumVerticies do
            begin
              AString := InfoTextList.Strings[VertexIndex];
              ThisX := Copy(AString,1,Pos(Chr(09),AString)-1);
              ThisY := Copy(AString,Pos(Chr(09),AString)+1,Length(AString));
              AVertex := TBL_Vertex.Create;
              AVertex.XPos := LocalStrToFloat(ThisX);
              AVertex.YPos := LocalStrToFloat(ThisY);
              AVertexList.Add(AVertex);
            end;
            if (NumVerticies = 1) and (AVertex <> nil) then
            begin
              AVertex := AVertex.CopyOfVertex;
              AVertexList.Add(AVertex);
            end;
          end;
        end;
      finally
        InfoTextList.Free;
      end;  }

      if GridAngle <> 0 then
      begin
        // Change vertex coordinates to coordinate system of rotated grid.
        for MainVertexListIndex := MainVertexStart to MainVertexList.Count -1 do
        begin
          AVertexList := MainVertexList.Items[MainVertexListIndex];
          For VertexIndex := 0 to AVertexList.Count - 1 do
          begin
            AVertex := AVertexList.Items[VertexIndex];
            RotatePointsToGrid(AVertex.XPos, AVertex.YPos, GridAngle);
            // Convert to polar coordinates

          end;
        end;
      end;

          // XDir and YDir indicate the direction of row and column numbering.
      if TReal(RowList.Items[0]).Value < TReal(RowList.Items[RowList.Count-1]).Value then
      begin
        YDir := 1
      end
      else
      begin
        YDir := -1
      end;
      if TReal(ColumnList.Items[0]).Value < TReal(ColumnList.Items[ColumnList.Count-1]).Value then
      begin
        XDir := 1
      end
      else
      begin
        XDir := -1
      end;
      // create cell list.
      for MainVertexListIndex := 0 to MainVertexList.Count -1 do
      begin
        AVertexList := MainVertexList.Items[MainVertexListIndex];
        ACellList := TList.Create;
        MainCellList.Add(ACellList);
        // Determine Cell (if any) in which the first point of the contour is located.
        if AVertexList.Count > 0 then
        begin
          // Determine the cell containin the beginning of the current segement and add it
          // to the cell list.
          FirstVertex := AVertexList.Items[0];  // FirstVertex is always the first vertex of the current segment.
          FirstVertex.TempRowVertex := False;
          FirstVertex.TempColumnVertex := False;
          FirstVertex.Segment := 0.5;
          // Add the cell(s) intersecting FirstVertex
          AddCellsIntersectingVertex(FirstVertex, ACellList, XDir, YDir,
                   RowAbove1, RowBelow1, ColumnAbove1, ColumnBelow1, 1, 1, True );
          For VertexIndex := 1 to AVertexList.Count - 1 do
          begin
            // FirstVertex is updated at the end of this loop.
            //
            //Determine cell containing the end of the current segment
            // but don't add that cell to the cell list yet.
            SecondVertex := AVertexList.Items[VertexIndex];
            SecondVertex.TempRowVertex := False;
            SecondVertex.TempColumnVertex := False;
            SecondVertex.Segment := VertexIndex + 0.5;
            AddCellsIntersectingVertex(SecondVertex, ACellList, XDir, YDir,
                     RowAbove2, RowBelow2, ColumnAbove2, ColumnBelow2, 1, 1,  False );

            // create additional verticies between the start and end points at
            // each row and column boundary between the start and end points.
            // StartRow, EndRow, StartColumn, and EndColumn indicate the locations
            // between which verticies must be created.
            if RowAbove2 > RowBelow1 then
            begin
              StartRow := RowAbove1;
              EndRow := RowBelow2;
            end
            else
            begin
              StartRow := RowAbove2;
              EndRow := RowBelow1;
            end;
            if ColumnAbove2 > ColumnBelow1 then
            begin
              StartColumn := ColumnAbove1;
              EndColumn := ColumnBelow2;
            end
            else
            begin
              StartColumn := ColumnAbove2;
              EndColumn := ColumnBelow1;
            end;
            // determine whether the direction of the current segment.
            XDist := SecondVertex.XPos - FirstVertex.XPos;
            YDist := SecondVertex.YPos - FirstVertex.YPos;

            // create a temporary vertex list to hold temporary verticies between the
            // the two end points of the current segment.
            TempVertexList := TList.Create;

            if not (Abs(XDist)+Abs(YDist) = 0) and not (Abs(XDist)/(Abs(XDist)+Abs(YDist)) < 3e-15) then
            begin
              For ColumnIndex := StartColumn to EndColumn  do
              begin
                AVertex := TBL_Vertex.Create;
                AVertex.XPos := TReal(ColumnList.Items[ColumnIndex]).Value;
                Avertex.YPos := FirstVertex.YPos + ((AVertex.XPos - FirstVertex.XPos)/XDist)*YDist;
                if (((AVertex.XPos - FirstVertex.XPos)/XDist) > 1)
                  or (((AVertex.XPos - FirstVertex.XPos)/XDist) < 0)
                  or ((AVertex.XPos = SecondVertex.XPos)
                    and (AVertex.YPos = SecondVertex.YPos)) then
                begin
                  Avertex.Free;
                end
                else
                begin
                  AVertex.TempRowVertex := False;
                  AVertex.TempColumnVertex := True;
                  AVertex.Segment := VertexIndex;
                  TempVertexList.Add(AVertex);
                end;
              end;
            end;
            if not (Abs(XDist)+Abs(YDist) = 0) and not (Abs(YDist)/(Abs(XDist)+Abs(YDist)) < 3e-15) then
            begin
              For RowIndex := StartRow to EndRow  do
              begin
                AVertex := TBL_Vertex.Create;
                AVertex.YPos := TReal(RowList.Items[RowIndex]).Value;
                Avertex.XPos := FirstVertex.XPos + ((AVertex.YPos - FirstVertex.YPos)/YDist)*XDist;
                if (((AVertex.YPos - FirstVertex.YPos)/YDist) > 1)
                  or (((AVertex.YPos - FirstVertex.YPos)/YDist) < 0)
                  or ((AVertex.XPos = SecondVertex.XPos)
                    and (AVertex.YPos = SecondVertex.YPos)) then
                begin
                  Avertex.Free;
                end
                else
                begin
                  AVertex.TempRowVertex := True;
                  AVertex.TempColumnVertex := False;
                  AVertex.Segment := VertexIndex;
                  TempVertexList.Add(AVertex);
                end;
              end;
            end;
            // sort the verticies so that they are added to the cells vertex list in the correct order.
            if not (Abs(XDist)+Abs(YDist) = 0) and not (Abs(XDist)/(Abs(XDist)+Abs(YDist)) < 3e-15) then
            begin
              if (XDist > 0) then
              begin
                TempVertexList.Sort(CompareVerticiesXDirPositive);
              end
              else
              begin
                TempVertexList.Sort(CompareVerticiesXDirNegative);
              end;
            end;
            if not (Abs(XDist)+Abs(YDist) = 0) and not (Abs(YDist)/(Abs(XDist)+Abs(YDist)) < 3e-15) then
            begin
              if (YDist > 0) then
              begin
                TempVertexList.Sort(CompareVerticiesYDirPositive);
              end
              else
              begin
                TempVertexList.Sort(CompareVerticiesYDirNegative);
              end;
            end;

            // set XSegmentDir and YSegmentDir to indicate to which
            // quadrant the current segment is directed.
            for TempVertexIndex := 0 to TempVertexList.Count -1 do
            begin
              AVertex := TempVertexList.Items[TempVertexIndex];
              if XDist = 0 then
              begin
                XSegmentDir := XDir;
              end
              else
              begin
                XSegmentDir := XDir*Round(XDist/Abs(XDist));
              end;
              if YDist = 0 then
              begin
                YSegmentDir := YDir;
              end
              else
              begin
                YSegmentDir := YDir*Round(YDist/Abs(YDist));
              end;

              // Add cells intersecting current vertex to cell list
              AddCellsIntersectingVertex(AVertex, ACellList, XDir, YDir,
                        RowAbove, RowBelow, ColumnAbove, ColumnBelow,
                        XSegmentDir, YSegmentDir, True );

              // free the temporary vertex. (If appropriate, a copy of the temporary
              // vertex has been added to the cells vertex list.
              AVertex.Free;
            end;
            // free the vertex list
            TempVertexList.Free;
            // add the cell containing the vertex at the endpoint of the
            // current segment to the cell list.
            AddCellsIntersectingVertex(SecondVertex, ACellList, XDir, YDir,
                     RowAbove2, RowBelow2, ColumnAbove2, ColumnBelow2, 1, 1, True );

            // update RowAbove1 etc so that you are ready for the next
            // segment
            RowAbove1 := RowAbove2;
            RowBelow1 := RowBelow2;
            ColumnAbove1 := ColumnAbove2;
            ColumnBelow1 := ColumnBelow2;
            FirstVertex := SecondVertex;
          end; //  For VertexIndex := 1 to AVertexList.Count - 1 do
        end; // if AVertexList.Count > 0 then


      end; // for MainVertexListIndex := 0 to MainVertexList.Count -1 do

      // Create the segement list for each cell.

      // loop through the main cell list extracting each celllist in turn
      for MainCellListIndex := 0 to MainCellList.Count -1 do
      begin
        ACellList := MainCellList.Items[MainCellListIndex];
        // loop through the each cell list extracting each cell in turn
        For CellIndex1 := ACellList.Count - 1 downto 0 do
        begin
          ACell := ACellList.Items[CellIndex1];
          if (ACell.VertexList.Count < 2) then
          begin
            ACell.Free;
            ACellList.Delete(CellIndex1);
          end
          else
          begin
            for vertexIndex := 1 to ACell.VertexList.Count-1 do
            begin
              // loop through verticies in cell and add to segment list if appropriate.
              AVertex := ACell.VertexList.Items[vertexIndex-1];
              AnotherVertex := ACell.VertexList.Items[vertexIndex];
              if (AnotherVertex.Segment - AVertex.Segment < 0.75) or
               ( (AnotherVertex.Segment - AVertex.Segment < 1.1) and
                  Odd(Round(AnotherVertex.Segment*2)) and
                  Odd(Round(AVertex.Segment*2)) ) then
              begin
                ACell.SegmentList.Add(AVertex);
              end;

            end; // for vertexIndex := 1 to ACell.VertexList.Count-1 do
{            if  (ACell.SumSegmentLength = 0) then
            begin
              ACell.Free;
              ACellList.Delete(CellIndex1);
            end;  }

          end;
        end; // For CellIndex1 := 0 to ACellList.Count - 1 do
      end; // for MainVertexListIndex := 0 to MainVertexList.Count -1 do

          // add all cells that are at different locations to the combined cell list.
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
              break;
            end;
          end; // For CellIndex2 := 0 to CombinedCellList.Count -1 do
          if not CellInList then
          begin
            CombinedCellList.Add(ACell);
          end;
        end; // For CellIndex1 := 0 to ACellList.Count - 1 do
      end; // for MainVertexListIndex := 0 to MainVertexList.Count -1 do

      // Add appropriate cells to the CrossRowCellsList;
      for MainCellListIndex := 0 to MainCellList.Count -1 do
      begin
        ACellList := MainCellList.Items[MainCellListIndex];
        AnotherCellList := TList.Create;
        CrossRowCellsList.Add(AnotherCellList);
        For CellIndex1 := 0 to ACellList.Count - 1 do
        begin
          ACell := ACellList.Items[CellIndex1];
          If ACell.LineCrossesRowMidline then
          begin
            AnotherCellList.Add(ACell);
          end;
        end; // For CellIndex1 := 0 to ACellList.Count - 1 do
      end; // for MainVertexListIndex := 0 to MainVertexList.Count -1 do

      // Find the locations between cross cells from which data should be taken
      // First find the end cell.
      for CrossesRowIndex := 0 to CrossRowCellsList.Count -1 do
      begin
        CurrentCellList := MainCellList.Items[CrossesRowIndex];
        CurrentCrossCellList := CrossRowCellsList.Items[CrossesRowIndex];
        if CurrentCrossCellList.Count > 0 then
        begin

          for CellIndex1 := 0 to CurrentCrossCellList.Count-1 do
          begin
            ACell := CurrentCrossCellList.Items[CellIndex1];
            if (CellIndex1 < CurrentCrossCellList.Count -1)
            // begin change 10/22/98
              or ((TBL_Vertex(TCell(CurrentCellList.Items[0]).VertexList[0]).XPos =
                 TBL_Vertex(TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                   VertexList[TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                     VertexList.count -1]).XPos)
                and
                (TBL_Vertex(TCell(CurrentCellList.Items[0]).VertexList[0]).YPos =
                 TBL_Vertex(TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                   VertexList[TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                     VertexList.count -1]).YPos)) then
            // end change 10/22/98

            begin
              // If the next crossover cell is on the same row as the
              // current crossover cell, find the maximum or minimum point
              // between them as the point at which to the cell to which
              // data will be applied.
              // Otherwise, find the location where the row changes.
              if (CellIndex1 < CurrentCrossCellList.Count -1) then
              begin
                AnotherCell := CurrentCrossCellList.Items[CellIndex1 + 1];
              end
              else
              begin
                AnotherCell := CurrentCrossCellList.Items[0];
              end;
              // begin old code
              //    AnotherCell := CurrentCrossCellList.Items[CellIndex1 + 1];
              // end change 10/22/98
              if AnotherCell.Row = ACell.Row then
                // find the maximum or minimum point
                // between them as the point at which to the cell to which
                // data will be applied.
                // Find the maximum point if the last vertex is above the
                // middle of the row.
                // Find the minimum point if the last vertex is below the
                // middle of the row.
              begin
                MaxY := ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count -1);
                EndCell := ACell;
                if MaxY > ACell.RowCenter then
                  // Find the maximum point if the last vertex is above the
                  // middle of the row.
                begin
                  StartLoop := CurrentCellList.IndexOf(ACell) + 1;
                  EndLoop := CurrentCellList.IndexOf(AnotherCell);
                  if EndLoop < StartLoop then
                  begin
                    EndLoop := CurrentCellList.Count -1;
                  end;
                  MaxY := ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count -1);
                  for CellIndex2 := StartLoop to EndLoop  do
                  begin
                    CurrentCell := CurrentCellList.Items[CellIndex2];
                    try
                      begin
                        if (CurrentCell.SegmentList.Count > 0)
                          and (CurrentCell.MaxY > MaxY) then
                        begin
                          EndCell := CurrentCell;
                          MaxY := CurrentCell.MaxY
                        end; // if CurrentCell.MaxY > MaxY then
                      end
                    except on ENoSegments do
                      begin
                      end;
                    end;
                  end; // for CellIndex2 := CurrentCellList.IndexOf(ACell) + 1 to
                       // CurrentCellList.IndexOf(AnotherCell) - 1 do
      // begin change 10/22/98
                  EndLoop := CurrentCellList.IndexOf(AnotherCell);
                  if EndLoop < StartLoop then
                  begin
                    StartLoop := 0;
                    for CellIndex2 := StartLoop to EndLoop  do
                    begin
                      CurrentCell := CurrentCellList.Items[CellIndex2];
                      try
                        begin
                          if (CurrentCell.SegmentList.Count > 0)
                            and (CurrentCell.MaxY > MaxY) then
                          begin
                            EndCell := CurrentCell;
                            MaxY := CurrentCell.MaxY
                          end; // if CurrentCell.MaxY > MaxY then
                        end;
                      except on ENoSegments do
                        begin
                        end;
                      end;
                    end; // for CellIndex2 := CurrentCellList.IndexOf(ACell) + 1 to
                         // CurrentCellList.IndexOf(AnotherCell) - 1 do
                  end;
      // end change 10/22/98
                end  // if MaxY > ACell.RowCenter
                else
                // Find the minimum point if the last vertex is below the
                // middle of the row.
                begin
                  StartLoop := CurrentCellList.IndexOf(ACell) + 1;
                  EndLoop := CurrentCellList.IndexOf(AnotherCell) -1;
                  if EndLoop < StartLoop then
                  begin
                    EndLoop := CurrentCellList.Count -1;
                  end;
                  MinY := ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count -1);
                  for CellIndex2 := StartLoop to EndLoop do
                  begin
                    CurrentCell := CurrentCellList.Items[CellIndex2];
                    try
                      begin
                        if (CurrentCell.SegmentList.Count > 0) and (CurrentCell.MinY < MinY) then
                        begin
                          EndCell := CurrentCell;
                          MinY := CurrentCell.MinY
                        end; // if CurrentCell.MinY > MinY then
                      end
                    except on ENoSegments do
                      begin
                      end;
                    end;
                  end;  //  for CellIndex2 := CurrentCellList.IndexOf(ACell) + 1 to
                        //  CurrentCellList.IndexOf(AnotherCell) - 1 do
                  EndLoop := CurrentCellList.IndexOf(AnotherCell) -1;
                  if EndLoop < StartLoop then
                  begin
                    StartLoop := 0;
                    for CellIndex2 := StartLoop to EndLoop do
                    begin
                      CurrentCell := CurrentCellList.Items[CellIndex2];
                      try
                        begin
                          if (CurrentCell.SegmentList.Count > 0) and (CurrentCell.MinY < MinY) then
                          begin
                            EndCell := CurrentCell;
                            MinY := CurrentCell.MinY
                          end; // if CurrentCell.MinY > MinY then
                        end
                      except on ENoSegments do
                        begin
                        end;
                      end;
                    end;  //  for CellIndex2 := CurrentCellList.IndexOf(ACell) + 1 to
                          //  CurrentCellList.IndexOf(AnotherCell) - 1 do
                  end;
                end;  // if MaxY > ACell.RowCenter


              end // if AnotherCell.Row = ACell.Row
              else
                // find the location where the row changes.
              begin
                StartLoop := CurrentCellList.IndexOf(ACell) + 1;
                EndLoop := CurrentCellList.IndexOf(AnotherCell) -1;
                EndCell := ACell;
                for CellIndex2 := StartLoop
                     to CurrentCellList.Count -1 do
                begin
                  EndCell := CurrentCellList.Items[CellIndex2];
                  if not (ACell.Row = EndCell.Row) and not (CellIndex2=0) then
                  begin
                    EndCell := CurrentCellList.Items[CellIndex2-1];
                    break;
                  end; // if not (ACell.Row = EndCell.Row) then
                end;  // for CellIndex2 := CurrentCellList.IndexOf(ACell) + 1
                      // to CurrentCellList.Count -1 do
                if (EndLoop < StartLoop) and (EndCell = ACell) then
                begin
                  for CellIndex2 := EndLoop downto 0 do
                  begin
                    EndCell := CurrentCellList.Items[CellIndex2];
                    if not (ACell.Row = EndCell.Row) then
                    begin
//                              if CellIndex2 = 0 then
                      if CellIndex2 = CurrentCellList.Count -1 then
                      begin
//                                EndCell := CurrentCellList.Items[CurrentCellList.Count -1];
//                                EndCell := CurrentCellList.Items[0];
                        EndCell := CurrentCellList.Items[CurrentCellList.Count -1];
                      end
                      else
                      begin
                        EndCell := CurrentCellList.Items[CellIndex2+1];
                      end;
                      break;
                    end; // if not (ACell.Row = EndCell.Row) then
                  end;  // for CellIndex2 := CurrentCellList.IndexOf(ACell) + 1
                        // to CurrentCellList.Count -1 do
                end;
              end; // if AnotherCell.Row = ACell.Row
            end
            else
            begin
              // find end cell if this is the last crossover cell.
              EndCell := CurrentCellList.Items[CurrentCellList.Count -1];
              if not (EndCell.Row = ACell.Row) then
              begin
                for CellIndex2 := CurrentCellList.IndexOf(EndCell) downto 0 do
                begin
                  AnotherCell := CurrentCellList.Items[CellIndex2];
                  if (AnotherCell.Row = ACell.Row) then
                  begin
                    EndCell := AnotherCell;
                    break;
                  end;  // if not (AnotherCell.Row = ACell.Row) then
                end;  // for CellIndex2 := AnotherCellList.IndexOf(ACell) downto 0 do
              end; // if not (EndCell.Row = ACell.Row) then
            end;
            ACell.RowEndCell := EndCell;
          end; // for CellIndex1 := 0 to CurrentCrossCellList.Count-1 do
        end;  // if AnotherCellList.Count > 0 then
      end;  // for CrossesRowIndex := 0 to CrossRowCellsList.Count -1 do

      // Now find the beginning cell.
      for CrossesRowIndex := 0 to CrossRowCellsList.Count -1 do
      begin
        CurrentCellList := MainCellList.Items[CrossesRowIndex];
        CurrentCrossCellList := CrossRowCellsList.Items[CrossesRowIndex];
        if CurrentCrossCellList.Count > 0 then
        begin
          // Find the first cell before the current cell from which we
          // should take data.
          if
            ((TBL_Vertex(TCell(CurrentCellList.Items[0]).VertexList[0]).XPos =
               TBL_Vertex(TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                 VertexList[TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                   VertexList.count -1]).XPos)
              and
              (TBL_Vertex(TCell(CurrentCellList.Items[0]).VertexList[0]).YPos =
               TBL_Vertex(TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                 VertexList[TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                   VertexList.count -1]).YPos)) then
          begin
            // figure out what to do with closed contour
            ACell := CurrentCrossCellList.Items[0];
            AnotherCell := CurrentCrossCellList.Items[CurrentCrossCellList.Count-1];
            if AnotherCell.Row = ACell.Row then
            begin
              ACell.RowBeginCell := AnotherCell.RowEndCell;
            end
            else
            begin
              LastCellIndex := CurrentCellList.IndexOf(AnotherCell.RowEndCell) + 1;
              if LastCellIndex >= CurrentCellList.Count then
              begin
                LastCellIndex := CurrentCellList.Count -1;
              end;
              ACell.RowBeginCell := CurrentCellList.Items[LastCellIndex];
            end;
//              end; //  for CellIndex1 := 1 to CurrentCrossCellList.Count-1 do
          end
          else
          begin
            BeginningCell := CurrentCellList.Items[0];
            ACell := CurrentCrossCellList.Items[0];
            if not (BeginningCell.Row = ACell.Row) then
            begin
              for CellIndex1 := CurrentCellList.IndexOf(ACell) downto 0 do
              begin
                AnotherCell := CurrentCellList.Items[CellIndex1];
                if not (AnotherCell.Row = ACell.Row) then
                begin
                  BeginningCell := CurrentCellList.Items[CellIndex1 + 1];
                  break;
                end;  // if not (AnotherCell.Row = ACell.Row) then
              end;  // for CellIndex1 := AnotherCellList.IndexOf(ACell) downto 0 do
            end; // if not (BeginningCell.Row = ACell.Row) then
            ACell.RowBeginCell := BeginningCell;
          end;

          for CellIndex1 := 1 to CurrentCrossCellList.Count-1 do
          begin
            ACell := CurrentCrossCellList.Items[CellIndex1];
            AnotherCell := CurrentCrossCellList.Items[CellIndex1 - 1];
            if AnotherCell.Row = ACell.Row then
            begin
              ACell.RowBeginCell := AnotherCell.RowEndCell;
            end
            else
            begin
              APosition := CurrentCellList.IndexOf(AnotherCell.RowEndCell) + 1;
              if APosition > CurrentCellList.Count -1 then
              begin
                APosition := 0;
              end;
              ACell.RowBeginCell := CurrentCellList.Items[APosition];
            end;
          end; //  for CellIndex1 := 1 to CurrentCrossCellList.Count-1 do
        end; // if CurrentCrossCellList.Count > 0 then
      end;  // for CrossesRowIndex := 0 to CrossRowCellsList.Count -1 do


      // Add appropriate cells to the CrossColumnCellsList;
      for MainCellListIndex := 0 to MainCellList.Count -1 do
      begin
        ACellList := MainCellList.Items[MainCellListIndex];
        AnotherCellList := TList.Create;
        CrossColumnCellsList.Add(AnotherCellList);
        For CellIndex1 := 0 to ACellList.Count - 1 do
        begin
          ACell := ACellList.Items[CellIndex1];
          If ACell.LineCrossesColumnMidline then
          begin
            AnotherCellList.Add(ACell);
          end;
        end; // For CellIndex1 := 0 to ACellList.Count - 1 do
      end; // for MainVertexListIndex := 0 to MainVertexList.Count -1 do


      // Find the locations between cross cells from which data should be taken
      // First find the end cell.
      for CrossesColumnIndex := 0 to CrossColumnCellsList.Count -1 do
      begin
        CurrentCellList := MainCellList.Items[CrossesColumnIndex];
        CurrentCrossCellList := CrossColumnCellsList.Items[CrossesColumnIndex];
        if CurrentCrossCellList.Count > 0 then
        begin

          for CellIndex1 := 0 to CurrentCrossCellList.Count-1 do
          begin
            ACell := CurrentCrossCellList.Items[CellIndex1];
            if (CellIndex1 < CurrentCrossCellList.Count -1)
            // begin change 10/22/98
              or ((TBL_Vertex(TCell(CurrentCellList.Items[0]).VertexList[0]).XPos =
                 TBL_Vertex(TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                   VertexList[TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                     VertexList.count -1]).XPos)
                and
                (TBL_Vertex(TCell(CurrentCellList.Items[0]).VertexList[0]).YPos =
                 TBL_Vertex(TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                   VertexList[TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                     VertexList.count -1]).YPos)) then
            // end change 10/22/98

            begin
              // If the next crossover cell is on the same Column as the
              // current crossover cell, find the maximum or minimum point
              // between them as the point at which to the cell to which
              // data will be applied.
              // Otherwise, find the location where the Column changes.
              // begin change 10/22/98
              if (CellIndex1 < CurrentCrossCellList.Count -1) then
              begin
                AnotherCell := CurrentCrossCellList.Items[CellIndex1 + 1];
              end
              else
              begin
                AnotherCell := CurrentCrossCellList.Items[0];
              end;
              // begin old code
              //    AnotherCell := CurrentCrossCellList.Items[CellIndex1 + 1];
              // end change 10/22/98
              if AnotherCell.Column = ACell.Column then
                // find the maximum or minimum point
                // between them as the point at which to the cell to which
                // data will be applied.
                // Find the maximum point if the last vertex is above the
                // middle of the Column.
                // Find the minimum point if the last vertex is below the
                // middle of the Column.
              begin
                MaxX := ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count -1);
                EndCell := ACell;
                if MaxX > ACell.ColumnCenter then
                  // Find the maximum point if the last vertex is above the
                  // middle of the Column.
                begin
                  StartLoop := CurrentCellList.IndexOf(ACell) + 1;
                  EndLoop := CurrentCellList.IndexOf(AnotherCell);
                  if EndLoop < StartLoop then
                  begin
                    EndLoop := CurrentCellList.Count -1;
                  end; // if EndLoop < StartLoop then
                  MaxX := ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count -1);
                  for CellIndex2 := StartLoop to EndLoop  do
                  begin
                    CurrentCell := CurrentCellList.Items[CellIndex2];
                    try
                      begin
                        if (CurrentCell.SegmentList.Count > 0)
                          and (CurrentCell.MaxX > MaxX) then
                        begin
                          EndCell := CurrentCell;
                          MaxX := CurrentCell.MaxX
                        end; // if CurrentCell.MaxX > MaxX then
                      end;
                    except on ENoSegments do
                      begin
                      end;
                    end;
                  end; // for CellIndex2 := CurrentCellList.IndexOf(ACell) + 1 to
                       // CurrentCellList.IndexOf(AnotherCell) - 1 do
      // begin change 10/22/98
                  EndLoop := CurrentCellList.IndexOf(AnotherCell);
                  if EndLoop < StartLoop then
                  begin
                    StartLoop := 0;
                    for CellIndex2 := StartLoop to EndLoop  do
                    begin
                      CurrentCell := CurrentCellList.Items[CellIndex2];
                      try
                        begin
                          if (CurrentCell.SegmentList.Count > 0)
                            and (CurrentCell.MaxX > MaxX) then
                          begin
                            EndCell := CurrentCell;
                            MaxX := CurrentCell.MaxX
                          end; // if CurrentCell.MaxX > MaxX then
                        end;
                      except on ENoSegments do
                        begin
                        end;
                      end;
                    end; // for CellIndex2 := CurrentCellList.IndexOf(ACell) + 1 to
                         // CurrentCellList.IndexOf(AnotherCell) - 1 do
                  end;
      // end change 10/22/98
                end  // if MaxX > ACell.ColumnCenter
                else
                  // Find the minimum point if the last vertex is below the
                  // middle of the Column.
                begin
                  StartLoop := CurrentCellList.IndexOf(ACell) + 1;
                  EndLoop := CurrentCellList.IndexOf(AnotherCell) -1;
                  if EndLoop < StartLoop then
                  begin
                    EndLoop := CurrentCellList.Count -1;
                  end;
                  MinX := ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count -1);
                  for CellIndex2 := StartLoop to EndLoop do
                  begin
                    CurrentCell := CurrentCellList.Items[CellIndex2];
                    try
                      begin
                        if (CurrentCell.SegmentList.Count > 0) and (CurrentCell.MinX < MinX) then
                        begin
                          EndCell := CurrentCell;
                          MinX := CurrentCell.MinX
                        end; // if CurrentCell.MinX > MinX then
                      end
                    except on ENoSegments do
                      begin
                      end;
                    end;
                  end;  //  for CellIndex2 := CurrentCellList.IndexOf(ACell) + 1 to
                        //  CurrentCellList.IndexOf(AnotherCell) - 1 do
                  EndLoop := CurrentCellList.IndexOf(AnotherCell) -1;
                  if EndLoop < StartLoop then
                  begin
                    StartLoop := 0;
                    for CellIndex2 := StartLoop to EndLoop do
                    begin
                      CurrentCell := CurrentCellList.Items[CellIndex2];
                      try
                        begin
                          if (CurrentCell.SegmentList.Count > 0) and (CurrentCell.MinX < MinX) then
                          begin
                            EndCell := CurrentCell;
                            MinX := CurrentCell.MinX
                          end; // if CurrentCell.MinX > MinX then
                        end
                      except on ENoSegments do
                        begin
                        end;
                      end;
                    end;  //  for CellIndex2 := CurrentCellList.IndexOf(ACell) + 1 to
                          //  CurrentCellList.IndexOf(AnotherCell) - 1 do
                  end;
                end;  // if MaxX > ACell.ColumnCenter


              end // if AnotherCell.Column = ACell.Column
              else
                // find the location where the Column changes.
              begin
                StartLoop := CurrentCellList.IndexOf(ACell) + 1;
                EndLoop := CurrentCellList.IndexOf(AnotherCell) -1;
                EndCell := ACell;
                for CellIndex2 := StartLoop
                     to CurrentCellList.Count -1 do
                begin
                  EndCell := CurrentCellList.Items[CellIndex2];
                  if not (ACell.Column = EndCell.Column) and not (CellIndex2=0) then
                  begin
                    EndCell := CurrentCellList.Items[CellIndex2-1];
                    break;
                  end; // if not (ACell.Column = EndCell.Column) then
                end;  // for CellIndex2 := CurrentCellList.IndexOf(ACell) + 1
                      // to CurrentCellList.Count -1 do
                if (EndLoop < StartLoop) and (EndCell = ACell) then
                begin
                  for CellIndex2 := EndLoop downto 0 do
                  begin
                    EndCell := CurrentCellList.Items[CellIndex2];
                    if not (ACell.Column = EndCell.Column) then
                    begin
                      if CellIndex2 = CurrentCellList.Count-1 then
                      begin
                        EndCell := CurrentCellList.Items[CurrentCellList.Count-1];
                      end
                      else
                      begin
                        EndCell := CurrentCellList.Items[CellIndex2+1];
                      end;
                      break;
                    end; // if not (ACell.Column = EndCell.Column) then
                  end;  // for CellIndex2 := CurrentCellList.IndexOf(ACell) + 1
                        // to CurrentCellList.Count -1 do
                end;
              end; // if AnotherCell.Column = ACell.Column
            end
            else
            begin
              // find end cell if this is the last crossover cell and the
              // contour is open
              EndCell := CurrentCellList.Items[CurrentCellList.Count -1];
              if not (EndCell.Column = ACell.Column) then
              begin
                for CellIndex2 := CurrentCellList.IndexOf(EndCell) downto 0 do
                begin
                  AnotherCell := CurrentCellList.Items[CellIndex2];
                  if (AnotherCell.Column = ACell.Column) then
                  begin
                    EndCell := AnotherCell;
                    break;
                  end;  // if not (AnotherCell.Column = ACell.Column) then
                end;  // for CellIndex2 := AnotherCellList.IndexOf(ACell) downto 0 do
              end; // if not (EndCell.Column = ACell.Column) then
            end;
            ACell.ColumnEndCell := EndCell;
          end; // for CellIndex1 := 0 to CurrentCrossCellList.Count-1 do
        end;  // if AnotherCellList.Count > 0 then
      end;  // for CrossesColumnIndex := 0 to CrossColumnCellsList.Count -1 do

      // Now find the beginning cell.
      for CrossesColumnIndex := 0 to CrossColumnCellsList.Count -1 do
      begin
        CurrentCellList := MainCellList.Items[CrossesColumnIndex];
        CurrentCrossCellList := CrossColumnCellsList.Items[CrossesColumnIndex];
        if CurrentCrossCellList.Count > 0 then
        begin
          // Find the first cell before the current cell from which we
          // should take data.


          // begin change 10/22/98
          if
            ((TBL_Vertex(TCell(CurrentCellList.Items[0]).VertexList[0]).XPos =
               TBL_Vertex(TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                 VertexList[TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                   VertexList.count -1]).XPos)
              and
              (TBL_Vertex(TCell(CurrentCellList.Items[0]).VertexList[0]).YPos =
               TBL_Vertex(TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                 VertexList[TCell(CurrentCellList.Items[CurrentCellList.Count -1]).
                   VertexList.count -1]).YPos)) then
          begin
            // figure out what to do with closed contour
            ACell := CurrentCrossCellList.Items[0];
            AnotherCell := CurrentCrossCellList.Items[CurrentCrossCellList.Count-1];
            if AnotherCell.Column = ACell.Column then
            begin
              ACell.ColumnBeginCell := AnotherCell.ColumnEndCell;
            end
            else
            begin
              LastCellIndex := CurrentCellList.IndexOf(AnotherCell.ColumnEndCell) + 1;
              if LastCellIndex >= CurrentCellList.Count then
              begin
                LastCellIndex := CurrentCellList.Count -1;
              end;
              ACell.ColumnBeginCell := CurrentCellList.Items[LastCellIndex];
            end;
//              end; //  for CellIndex1 := 1 to CurrentCrossCellList.Count-1 do
          end
          else
          begin
            BeginningCell := CurrentCellList.Items[0];
            ACell := CurrentCrossCellList.Items[0];
            if not (BeginningCell.Column = ACell.Column) then
            begin
              for CellIndex1 := CurrentCellList.IndexOf(ACell) downto 0 do
              begin
                AnotherCell := CurrentCellList.Items[CellIndex1];
                if not (AnotherCell.Column = ACell.Column) then
                begin
                  BeginningCell := CurrentCellList.Items[CellIndex1 + 1];
                  break;
                end;  // if not (AnotherCell.Column = ACell.Column) then
              end;  // for CellIndex1 := AnotherCellList.IndexOf(ACell) downto 0 do
            end; // if not (BeginningCell.Column = ACell.Column) then
            ACell.ColumnBeginCell := BeginningCell;
          end;
          // end change 10/22/98

          for CellIndex1 := 1 to CurrentCrossCellList.Count-1 do
          begin
            ACell := CurrentCrossCellList.Items[CellIndex1];
            AnotherCell := CurrentCrossCellList.Items[CellIndex1 - 1];
            if AnotherCell.Column = ACell.Column then
            begin
              ACell.ColumnBeginCell := AnotherCell.ColumnEndCell;
            end
            else
            begin
              APosition := CurrentCellList.IndexOf(AnotherCell.ColumnEndCell) + 1;
              if APosition > CurrentCellList.Count -1 then
              begin
                APosition := 0;
              end;
              ACell.ColumnBeginCell := CurrentCellList.Items[APosition];
            end;
          end; //  for CellIndex1 := 1 to CurrentCrossCellList.Count-1 do
        end; // if CurrentCrossCellList.Count > 0 then
      end;  // for CrossesColumnIndex := 0 to CrossColumnCellsList.Count -1 do

      result := True;
    end;
  Except on Exception do
    begin
//      result := 0;
        Inc(ErrorCount);
      result := False;
    end;
  end;

end;

function GAddVertex(myHandle : ANE_PTR;
  Information_Layer_Name : ANE_STR) : ANE_BOOL;
var
  InfoLayerHandle :ANE_PTR;
begin
  if GridImportOK then
  begin
    if (MainVertexList = nil) then
    begin
      MainVertexList := TList.Create;
    end;
    ClearAndInitializeAllButMainVertexLists;

    InfoLayerHandle := ANE_LayerGetHandleByName(myHandle, Information_Layer_Name );
    result := AddObjectsFromLayer(myHandle, InfoLayerHandle);
  end // if GridImportOK
  else
  begin
    result := False;
  end; // if GridImportOK

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
begin
  try
    begin
      param := @parameters^;
      param1 :=  param^[0];
      result := GAddVertex(myHandle, param1);

    end;
  Except on Exception do
    begin
      result := False;
      Inc(ErrorCount);
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

end.
