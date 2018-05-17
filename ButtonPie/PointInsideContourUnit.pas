unit PointInsideContourUnit;

interface

uses ANEPIE, SysUtils, Classes, Math;

function GContourArea(ListIndex : integer) : double;

function GPointInsideContour(ListToUse : ANE_INT32; X, Y : ANE_DOUBLE) : boolean;

procedure GPointInsideContourMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function GContourIntersectCell(ListToUse, Column, Row : ANE_INT32) : double;
function GContourIntersectCellRemainder(Column, Row : ANE_INT32) : double;

procedure SetAreaValues;
procedure ResetAreaValues;

implementation

uses BlockListUnit, CellVertexUnit, SegmentUnit, VertexUnit, GridUnit;

type TAreaValues = class(TObject)
  private
    FirstLimit : integer;
    SecondLimit : integer;
    ThirdLimit : integer;
    Values : array of array of array of double;
    procedure CheckLimits(const X, Y, Z: integer);
    function GetItems(const X, Y, Z: integer): double;
    procedure SetItems(const X, Y, Z: integer; const Value: double);
  published
    procedure SetValuesLength(const Size1, Size2, Size3 : integer);
  public
    property Items[const X, Y, Z : integer] : double read GetItems write SetItems; default;
  end;



var
//  AreaValues: array of array of array of double;
  AreaValues: TAreaValues;

Procedure SetAreaValuesSize(ContourCount, ColumnCount, RowCount : integer);
begin
  AreaValues.SetValuesLength(ContourCount + 1, ColumnCount, RowCount);
//  SetLength(AreaValues, ContourCount + 1, ColumnCount, RowCount);
end;

procedure ResetAreaValues;
begin
  SetAreaValuesSize(-1,0,0);
end;

function ContourArea(AVertexList : TList) : double;
var
  VertexIndex : integer;
  AVertex, AnotherVertex : TBL_Vertex;
begin
  result := 0;
  if (AVertexList.Count < 3) then
  begin
    Exit;
  end;
  AVertex := AVertexList.Items[0];
  AnotherVertex := AVertexList.Items[AVertexList.Count -1];
  if (AVertex.XPos <> AnotherVertex.XPos) or
    (AVertex.YPos <> AnotherVertex.YPos) then
  begin
    Exit;
  end;

  For VertexIndex := 0 to AVertexList.Count -2 do
  begin
    AVertex := AVertexList.Items[VertexIndex];
    AnotherVertex := AVertexList.Items[VertexIndex+1];
    result := result + AVertex.XPos*AnotherVertex.YPos
      - AVertex.YPos*AnotherVertex.XPos;
  end;
  result := Abs(result/2);
end;

function PointInside(X, Y  : ANE_DOUBLE; AVertexList : TList) : boolean;
var
  VertexIndex : integer;
  AVertex, AnotherVertex : TBL_Vertex;
begin   // based on CACM 112
  if AVertexList.Count < 4 then
  begin
    result := false;
    Exit;
  end;
  AVertex := AVertexList.Items[0];
  AnotherVertex := AVertexList.Items[AVertexList.Count -1];
  if (AVertex.XPos <> AnotherVertex.XPos) or
    (AVertex.YPos <> AnotherVertex.YPos) then
  begin
    result := False;
    Exit;
  end;

  result := true;
  For VertexIndex := 0 to AVertexList.Count -2 do
  begin
    AVertex := AVertexList.Items[VertexIndex];
    AnotherVertex := AVertexList.Items[VertexIndex+1];
    if ((Y <= AVertex.YPos) = (Y > AnotherVertex.YPos)) and
       (X - AVertex.XPos - (Y - AVertex.YPos) *
         (AnotherVertex.XPos - AVertex.XPos)/
         (AnotherVertex.YPos - AVertex.YPos) < 0) then
      begin
        result := not result;
      end;
  end;
  result := not result;
end;

function ContourArea2(ListIndex : integer) : double;
var
  Index, InnerIndex : integer;
  AVertexList, AnotherVertexList, ThirdVertexList : TList;
  InnerList : TList;
  Vertex1, Vertex2 : TBL_Vertex;
  AddList : Boolean;
begin
  AVertexList := MainVertexList.Items[ListIndex];
  result := ContourArea(AVertexList);
  InnerList := TList.Create;
  try
    for Index := 0 to MainVertexList.Count -1 do
    begin
      if Index <> ListIndex then
      begin
        AnotherVertexList := MainVertexList[Index];
        Vertex1 := AnotherVertexList[0];
        if PointInside(Vertex1.XPos, Vertex1.YPos, AVertexList) then
        begin
          AddList := True;
          for InnerIndex := InnerList.Count-1 downto 0 do
          begin
            ThirdVertexList := InnerList[InnerIndex];
            if PointInside(Vertex1.XPos, Vertex1.YPos, ThirdVertexList) then
            begin
              AddList := False;
              break;
            end;
            Vertex2 := ThirdVertexList[0];
            if PointInside(Vertex2.XPos, Vertex2.YPos, AnotherVertexList) then
            begin
              InnerList.Delete(InnerIndex);
            end;
          end;
          if AddList then
          begin
            InnerList.Add(AnotherVertexList);
          end;
        end;
      end;
    end;

    for Index := 0 to InnerList.Count -1 do
    begin
      AnotherVertexList := InnerList[Index];
      result := result - ContourArea(AnotherVertexList);
    end;
  finally
    InnerList.Free;
  end;
end;

function GContourArea(ListIndex : integer) : double;
begin
  result := ContourArea2(ListIndex);
end;

function AddVerticiesOnEdge(AVertexList : TList; ASegment : TSegment;
  MaxLocation, MinLocation : TBL_Vertex): boolean;
var
  Index : integer;
  IntersectVertex : TVertex;
  EdgeSegment : TSegment;
  FirstVertex, SecondVertex : TVertex;
  V1, V2, V3 : TBL_Vertex;
  HighX, HighY, LowX, LowY : double;
  Inside : boolean;
begin
  result := False;
  HighX := Max(ASegment.FirstVertex.X, ASegment.SecondVertex.X);
  LowX := Min(ASegment.FirstVertex.X, ASegment.SecondVertex.X);
  Inside := (MaxLocation.XPos >= LowX) and (MinLocation.XPos <= HighX);
  if Inside then
  begin
    HighY := Max(ASegment.FirstVertex.Y, ASegment.SecondVertex.Y);
    LowY := Min(ASegment.FirstVertex.Y, ASegment.SecondVertex.Y);
    Inside := (MaxLocation.YPos >= LowY) and (MinLocation.YPos <= HighY);
  end;
  if Inside then
  begin
    FirstVertex := TVertex.Create;
    SecondVertex := TVertex.Create;
    IntersectVertex := TVertex.Create;
    EdgeSegment := TSegment.Create(FirstVertex,SecondVertex);
    try
      for Index := AVertexList.Count -1 downto 1 do
      begin
        V1 := AVertexList[Index];
        V2 := AVertexList[Index-1];
        EdgeSegment.FirstVertex.X := V1.XPos;
        EdgeSegment.FirstVertex.Y := V1.YPos;
        EdgeSegment.SecondVertex.X := V2.XPos;
        EdgeSegment.SecondVertex.Y := V2.YPos;
        try
          if ASegment.Intersection(EdgeSegment,IntersectVertex) then
          begin
            V3 := TBL_Vertex.Create;
            V3.XPos := IntersectVertex.X;
            V3.YPos := IntersectVertex.Y;
            AVertexList.Insert(Index,V3);
            result := True;
          end;
        finally
        end;
      end;
    finally
      FirstVertex.Free;
      SecondVertex.Free;
      IntersectVertex.Free;
      EdgeSegment.Free;
    end;
  end;
end;

function AddVerticiesOnEdges(AVertexList : TList;
  LeftEdge, RightEdge, TopEdge, BottomEdge : TReal;
  Max, Min : TBL_Vertex) : boolean;
var
  TopLeft, TopRight, BottomLeft, BottomRight : TVertex;
  LeftSeg, RightSeg, TopSeg, BotSeg : TSegment;
begin
  TopLeft := TVertex.Create;
  TopRight := TVertex.Create;
  BottomLeft := TVertex.Create;
  BottomRight := TVertex.Create;
  try
    TopLeft.X := LeftEdge.Value;
    TopRight.X := RightEdge.Value;
    BottomLeft.X := LeftEdge.Value;
    BottomRight.X := RightEdge.Value;
    TopLeft.Y := TopEdge.Value;
    TopRight.Y := TopEdge.Value;
    BottomLeft.Y := BottomEdge.Value;
    BottomRight.Y := BottomEdge.Value;
    LeftSeg := TSegment.Create(TopLeft,BottomLeft);
    RightSeg := TSegment.Create(TopRight,BottomRight);
    TopSeg := TSegment.Create(TopLeft,TopRight);
    BotSeg := TSegment.Create(BottomRight,BottomLeft);
    try
      result := AddVerticiesOnEdge(AVertexList, LeftSeg, Max, Min);
      result := AddVerticiesOnEdge(AVertexList, RightSeg, Max, Min) or result;
      result := AddVerticiesOnEdge(AVertexList, TopSeg, Max, Min)   or result;
      result := AddVerticiesOnEdge(AVertexList, BotSeg, Max, Min)   or result;
    finally
      LeftSeg.Free;
      RightSeg.Free;
      TopSeg.Free;
      BotSeg.Free;
    end;

  finally
    TopLeft.Free;
    TopRight.Free;
    BottomLeft.Free;
    BottomRight.Free;
  end;

end;

function GetContourAreaInCell (Column, Row : ANE_INT32;
  AVertexList : TList; MinX, MaxX, MinY, MaxY : double): ANE_DOUBLE;
var
  LeftEdge, RightEdge, TopEdge, BottomEdge : TReal;
  VerticiesInCell : TList;
  Index : integer;
  AVertex, AnotherVertex : TBL_Vertex;
  Temp : TReal;
  CellCorners : TList;
  Max, Min : TBL_Vertex;
begin
  result := 0;
  RightEdge := ColumnList.Items[Column];
  LeftEdge := ColumnList.Items[Column-1];
  if LeftEdge.Value > RightEdge.Value then
  begin
    Temp := LeftEdge;
    LeftEdge := RightEdge;
    RightEdge := Temp;
  end;
  if (LeftEdge.Value > MaxX) or (RightEdge.Value < MinX) then
  begin
    Exit;
  end;
  TopEdge := RowList.Items[Row];
  BottomEdge := RowList.Items[Row-1];
  if BottomEdge.Value > TopEdge.Value then
  begin
    Temp := BottomEdge;
    BottomEdge := TopEdge;
    TopEdge := Temp;
  end;
  if (BottomEdge.Value > MaxY) or (TopEdge.Value < MinY) then
  begin
    Exit;
  end;
  VerticiesInCell := TList.Create;
  Max := TBL_Vertex.Create;
  Min := TBL_Vertex.Create;
  try
    Min.XPos := MinX;
    Min.YPos := MinY;
    Max.XPos := MaxX;
    Max.YPos := MaxY;
    for Index := 0 to AVertexList.Count -1 do
    begin
      AVertex := AVertexList[Index];
      AVertex := AVertex.CopyOfVertex;
      VerticiesInCell.Add(AVertex);
{      if Index = 0 then
      begin
        Max.XPos := AVertex.XPos;
        Max.YPos := AVertex.YPos;
        Min.XPos := AVertex.XPos;
        Min.YPos := AVertex.YPos;
      end
      else
      begin
        if AVertex.XPos > Max.XPos then
        begin
          Max.XPos := AVertex.XPos;
        end;
        if AVertex.YPos > Max.YPos then
        begin
          Max.YPos := AVertex.YPos;
        end;
        if AVertex.XPos < Min.XPos then
        begin
          Min.XPos := AVertex.XPos;
        end;
        if AVertex.YPos < Min.YPos then
        begin
          Min.YPos := AVertex.YPos;
        end;
      end; }
    end;
    if not AddVerticiesOnEdges(VerticiesInCell,
      LeftEdge, RightEdge, TopEdge, BottomEdge, Max, Min) then
    begin
      if not PointInside(LeftEdge.Value, TopEdge.Value, VerticiesInCell) then
      begin
        CellCorners := TList.Create;
        try
          AVertex := TBL_Vertex.Create;
          AVertex.XPos := LeftEdge.Value;
          AVertex.YPos := TopEdge.Value;
          CellCorners.Add(AVertex);

          AVertex := TBL_Vertex.Create;
          AVertex.XPos := RightEdge.Value;
          AVertex.YPos := TopEdge.Value;
          CellCorners.Add(AVertex);

          AVertex := TBL_Vertex.Create;
          AVertex.XPos := RightEdge.Value;
          AVertex.YPos := BottomEdge.Value;
          CellCorners.Add(AVertex);

          AVertex := TBL_Vertex.Create;
          AVertex.XPos := LeftEdge.Value;
          AVertex.YPos := BottomEdge.Value;
          CellCorners.Add(AVertex);

          AVertex := TBL_Vertex.Create;
          AVertex.XPos := LeftEdge.Value;
          AVertex.YPos := TopEdge.Value;
          CellCorners.Add(AVertex);

          AVertex := VerticiesInCell[0];
          if not PointInside(AVertex.XPos, AVertex.YPos, CellCorners) then
          begin
            result := 0;
            Exit;
          end;
        finally
          for Index := 0 to CellCorners.Count -1 do
          begin
            TBL_Vertex(CellCorners[Index]).Free;
          end;

          CellCorners.Free;
        end;
      end;
    end;
    for Index := 0 to VerticiesInCell.Count -1 do
    begin
      AVertex := VerticiesInCell[Index];
      if AVertex.YPos > TopEdge.Value then
      begin
        AVertex.YPos := TopEdge.Value
      end
      else if AVertex.YPos < BottomEdge.Value then
      begin
        AVertex.YPos := BottomEdge.Value
      end;
      if AVertex.XPos > RightEdge.Value then
      begin
        AVertex.XPos := RightEdge.Value
      end
      else if AVertex.XPos < LeftEdge.Value then
      begin
        AVertex.XPos := LeftEdge.Value
      end;
    end;
    for Index := VerticiesInCell.Count -1 downto 1 do
    begin
      AVertex := VerticiesInCell[Index];
      AnotherVertex := VerticiesInCell[Index-1];
      if (AVertex.XPos = AnotherVertex.XPos)
        and (AVertex.YPos = AnotherVertex.YPos) then
      begin
        VerticiesInCell.Delete(Index);
        AVertex.Free;
      end;
    end;

    result := ContourArea(VerticiesInCell);
  finally
    for Index := VerticiesInCell.Count -1 downto 0 do
    begin
      AVertex := VerticiesInCell[Index];
      AVertex.Free;
    end;
    VerticiesInCell.Free;
    Max.Free;
    Min.Free;
  end;

end;

procedure SetAreaValues;
var
  ListIndex, InnerListIndex, ThirdListIndex : integer;
  AVertexList, AnotherVertexList, ThirdVertexList : TList;
  Column, Row : integer;
  AVertex : TBL_Vertex;
  InnerContours : TList;
  ContoursDeleted : boolean;
  Position : integer;
  ColumnCount, RowCount : integer;
  MinXPos, MaxXPos, MinYPos, MaxYPos : double;
  Index : integer;
//  Inside : boolean;
begin
  ColumnCount := GGetColumnBoundaryCount -1;
  RowCount := GGetRowBoundaryCount -1;
  SetAreaValuesSize(MainVertexList.Count, ColumnCount, RowCount);
  for Column := 1 to ColumnCount do
  begin
    for Row := 1 to RowCount do
    begin
      AreaValues[0,Column-1,Row-1] := GGetCellArea (Column, Row);
    end;
  end;
{  for ListIndex := 1 to MainVertexList.Count do
  begin
    for Column := 0 to ColumnCount-1 do
    begin
      for Row := 0 to RowCount-1 do
      begin
        AreaValues[ListIndex,Column,Row] := 0;
      end;
    end;
  end;  }
  for ListIndex := 0 to MainVertexList.Count- 1 do
  begin
    AVertexList := MainVertexList[ListIndex];
    MaxXPos := 0;
    MaxYPos := 0;
    MinXPos := 0;
    MinYPos := 0;
    for Index := 0 to AVertexList.Count -1 do
    begin
      AVertex := AVertexList[Index];
//      AVertex := AVertex.CopyOfVertex;
//      VerticiesInCell.Add(AVertex);
      if Index = 0 then
      begin
        MaxXPos := AVertex.XPos;
        MaxYPos := AVertex.YPos;
        MinXPos := AVertex.XPos;
        MinYPos := AVertex.YPos;
      end
      else
      begin
        if AVertex.XPos > MaxXPos then
        begin
          MaxXPos := AVertex.XPos;
        end;
        if AVertex.YPos > MaxYPos then
        begin
          MaxYPos := AVertex.YPos;
        end;
        if AVertex.XPos < MinXPos then
        begin
          MinXPos := AVertex.XPos;
        end;
        if AVertex.YPos < MinYPos then
        begin
          MinYPos := AVertex.YPos;
        end;
      end;
    end;

    for Column := 1 to ColumnCount do
    begin
      for Row := 1 to RowCount do
      begin
        AreaValues[ListIndex+1,Column-1,Row-1] := GetContourAreaInCell
          (Column, Row, AVertexList, MinXPos, MaxXPos, MinYPos, MaxYPos);
      end;
    end;
  end;

  InnerContours := TList.Create;
  try

    for ListIndex := 0 to MainVertexList.Count- 1 do
    begin
      InnerContours.Clear;
      AVertexList := MainVertexList[ListIndex];
      for InnerListIndex := 0 to MainVertexList.Count- 1 do
      begin
        if InnerListIndex <> ListIndex then
        begin
          AnotherVertexList := MainVertexList[InnerListIndex];
          if AnotherVertexList.Count > 0 then
          begin
            AVertex := AnotherVertexList[0];
            if PointInside(AVertex.XPos, AVertex.YPos , AVertexList) then
            begin
              InnerContours.Add(AnotherVertexList)
            end;
          end;
        end;
      end;
      repeat
        ContoursDeleted := False;
        for InnerListIndex := InnerContours.Count- 1 downto 0 do
        begin
          AnotherVertexList := InnerContours[InnerListIndex];
          for ThirdListIndex := InnerContours.Count- 1 downto 0 do
          begin
            if (InnerListIndex <> ThirdListIndex) then
            begin
              ThirdVertexList := InnerContours[ThirdListIndex];
              AVertex := ThirdVertexList[0];
              if PointInside(AVertex.XPos, AVertex.YPos , AnotherVertexList) then
              begin
                InnerContours.Delete(ThirdListIndex);
                ContoursDeleted := True;
                if ThirdListIndex < InnerListIndex then
                begin
                  break;
                end;
              end;
            end;
          end;
          if ContoursDeleted then
          begin
            break;
          end;
        end;
      until not ContoursDeleted;
      for InnerListIndex := 0 to InnerContours.Count -1 do
      begin
        AnotherVertexList := InnerContours[InnerListIndex];
        Position := MainVertexList.IndexOf(AnotherVertexList) + 1;
        for Column := 0 to ColumnCount-1 do
        begin
          for Row := 0 to RowCount-1 do
          begin
            if AreaValues[ListIndex+1,Column,Row] > 0 then
            begin
              AreaValues[ListIndex+1,Column,Row] :=
                AreaValues[ListIndex+1,Column,Row]
                - AreaValues[Position,Column,Row];
            end;
          end;
        end;
      end;
    end;
  finally
    InnerContours.Free;
  end;


  for ListIndex := 1 to MainVertexList.Count do
  begin
    for Column := 0 to ColumnCount-1 do
    begin
      for Row := 0 to RowCount-1 do
      begin
          AreaValues[0,Column,Row] :=
            AreaValues[0,Column,Row]
            - AreaValues[ListIndex,Column,Row];
      end;
    end;
  end;
end;


function GContourIntersectCellRemainder(Column, Row : ANE_INT32) : double;
begin
  result := AreaValues[0,Column-1,Row-1];
end;

function GContourIntersectCell(ListToUse, Column, Row : ANE_INT32) : double;
{var
  AVertexList, AnotherVertexList : TList;
  AVertex, AnotherVertex : TBL_Vertex;
  ListIndex : integer; }
begin
  result := AreaValues[ListToUse+1,Column-1,Row-1];
{  AVertexList := MainVertexList.Items[ListToUse];
  if AVertexList.Count < 3
  then
  begin
    result := 0;
  end  // if AVertexList.Count < 3
  else
  begin
    AVertex := AVertexList.Items[0];
    AnotherVertex := AVertexList.Items[AVertexList.Count-1];
    if (AVertex.XPos <> AnotherVertex.XPos)
      or (AVertex.YPos <> AnotherVertex.YPos) then
    begin
      // contour is an open contour.
      result := 0;
    end // if not ((AVertex.XPos = AnotherVertex.XPos) and (AVertex.YPos = AnotherVertex.YPos))
    else
    begin
      result := GetContourAreaInCell (Column, Row, AVertexList);
      if result > 0 then
      begin
        for ListIndex := 0 to MainVertexList.Count -1 do
        begin
          if ListIndex <> ListToUse then
          begin
            AnotherVertexList := MainVertexList[ListIndex];
            AVertex := AnotherVertexList[0];
            if PointInside(AVertex.XPos, AVertex.YPos , AVertexList) then
            begin
              result := result -
                GetContourAreaInCell (Column, Row, AnotherVertexList)
            end;
          end;
        end;
      end;
    end; // if not ((AVertex.XPos = AnotherVertex.XPos) and (AVertex.YPos = AnotherVertex.YPos)) else
  end;  // if AVertexList.Count < 3 else}
end;

function GPointInsideContour(ListToUse : ANE_INT32; X, Y : ANE_DOUBLE) : boolean;
var
  AVertexList, AnotherVertexList : TList;
  AVertex, AnotherVertex : TBL_Vertex;
  ListIndex : integer;
begin
      AVertexList := MainVertexList.Items[ListToUse];
      if AVertexList.Count < 3
      then
        begin
          result := False;
        end  // if AVertexList.Count < 3
      else
        begin
          AVertex := AVertexList.Items[0];
          AnotherVertex := AVertexList.Items[AVertexList.Count-1];
          if not ((AVertex.XPos = AnotherVertex.XPos) and (AVertex.YPos = AnotherVertex.YPos))
          then
            begin
              // contour is an open contour.
              result := False;
            end // if not ((AVertex.XPos = AnotherVertex.XPos) and (AVertex.YPos = AnotherVertex.YPos))
          else
            begin
              result := PointInside(X, Y , AVertexList);
              if result then
              begin
                for ListIndex := 0 to MainVertexList.Count -1 do
                begin
                  if ListIndex <> ListToUse then
                  begin
                    AnotherVertexList := MainVertexList[ListIndex];
                    AVertex := AnotherVertexList[0];
                    if PointInside(AVertex.XPos, AVertex.YPos , AVertexList) then
                    begin
                      if PointInside(X, Y, AnotherVertexList) then
                      begin
                        result := False;
                        break;
                      end;
                    end;
                  end;
                end;
              end;


            end; // if not ((AVertex.XPos = AnotherVertex.XPos) and (AVertex.YPos = AnotherVertex.YPos)) else
        end;  // if AVertexList.Count < 3 else
end;

procedure GPointInsideContourMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_BOOL;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  ListToUse : ANE_INT32;
  param2_ptr : ANE_DOUBLE_PTR;
  X : ANE_DOUBLE;
  param3_ptr : ANE_DOUBLE_PTR;
  Y : ANE_DOUBLE;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListToUse :=  param1_ptr^;
      param2_ptr :=  param^[1];
      X :=  param2_ptr^;
      param3_ptr :=  param^[2];
      Y :=  param3_ptr^;
      result := GPointInsideContour(ListToUse, X, Y);
    end  // try
  except
    on Exception do
      begin
        Inc(ErrorCount);
        result := False;
      end;
  end;

  ANE_BOOL_PTR(reply)^ := result;
end;

{ TAreaValues }

procedure TAreaValues.CheckLimits(const X, Y, Z: integer);
begin
  Assert(X >= 0);
  Assert(X < FirstLimit);
  Assert(Y >= 0);
  Assert(Y < SecondLimit);
  Assert(Z >= 0);
  Assert(Z < ThirdLimit);
end;

function TAreaValues.GetItems(const X, Y, Z: integer): double;
begin
  CheckLimits(X, Y, Z);
  result := Values[X,Y,Z];
end;

procedure TAreaValues.SetItems(const X, Y, Z: integer;
  const Value: double);
begin
  CheckLimits(X, Y, Z);
  Values[X,Y,Z] := Value;
end;

procedure TAreaValues.SetValuesLength(const Size1, Size2, Size3: integer);
begin
  SetLength(Values, Size1, Size2, Size3);
  FirstLimit := Size1;
  SecondLimit := Size2;
  ThirdLimit := Size3;
end;

initialization
  AreaValues := TAreaValues.Create;
  AreaValues.SetValuesLength(0,0,0);

finalization
begin
  ResetAreaValues;
  AreaValues.Free;
end;

end.
