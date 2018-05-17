unit PointInsideContourUnit;

interface

uses ANEPIE, SysUtils, Classes, Math;

function GContourArea(ListIndex: integer): double;

function GPointInsideContour(ListToUse: ANE_INT32; X, Y: ANE_DOUBLE): boolean;

procedure GPointInsideContourMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GContourTypeMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
  
function GContourIntersectCell(ListToUse, Column, Row: ANE_INT32): double;
function GContourIntersectCellRemainder(Column, Row: ANE_INT32): double;

procedure SetAreaValues;
procedure ResetAreaValues;

implementation

uses BlockListUnit, CellVertexUnit, SegmentUnit, VertexUnit, GridUnit,
  UtilityFunctions;

type
  TAreaValues = class(TObject)
  private
    FirstLimit: integer;
    SecondLimit: integer;
    ThirdLimit: integer;
    Values: array of array of array of double;
    procedure CheckLimits(const X, Y, Z: integer);
    function GetItems(const X, Y, Z: integer): double;
    procedure SetItems(const X, Y, Z: integer; const Value: double);
  published
    procedure SetValuesLength(const Size1, Size2, Size3: integer);
  public
    property Items[const X, Y, Z: integer]: double read GetItems write SetItems;
      default;
  end;

var
  //  AreaValues: array of array of array of double;
  AreaValues: TAreaValues;

procedure SetAreaValuesSize(ContourCount, ColumnCount, RowCount: integer);
begin
  AreaValues.SetValuesLength(ContourCount + 1, ColumnCount, RowCount);
  //  SetLength(AreaValues, ContourCount + 1, ColumnCount, RowCount);
end;

procedure ResetAreaValues;
begin
  SetAreaValuesSize(-1, 0, 0);
end;

function ContourArea(AVertexList: TList): double;
var
  VertexIndex: integer;
  AVertex, AnotherVertex: TBL_Vertex;
begin
  result := 0;
  if (AVertexList.Count < 3) then
  begin
    Exit;
  end;
  AVertex := AVertexList.Items[0];
  AnotherVertex := AVertexList.Items[AVertexList.Count - 1];
  if (AVertex.XPos <> AnotherVertex.XPos) or
    (AVertex.YPos <> AnotherVertex.YPos) then
  begin
    Exit;
  end;

  for VertexIndex := 0 to AVertexList.Count - 2 do
  begin
    AVertex := AVertexList.Items[VertexIndex];
    AnotherVertex := AVertexList.Items[VertexIndex + 1];
    result := result + AVertex.XPos * AnotherVertex.YPos
      - AVertex.YPos * AnotherVertex.XPos;
  end;
  result := Abs(result / 2);
end;

function PointInside(X, Y: ANE_DOUBLE; AVertexList: TList): boolean;
var
  VertexIndex: integer;
  AVertex, AnotherVertex: TBL_Vertex;
begin // based on CACM 112
  if AVertexList.Count < 4 then
  begin
    result := false;
    Exit;
  end;
  AVertex := AVertexList.Items[0];
  AnotherVertex := AVertexList.Items[AVertexList.Count - 1];
  if (AVertex.XPos <> AnotherVertex.XPos) or
    (AVertex.YPos <> AnotherVertex.YPos) then
  begin
    result := False;
    Exit;
  end;

  if AVertexList is TEncloseList then
  begin
    result := TEncloseList(AVertexList).IsInside(X, Y);
  end
  else
  begin
    result := true;
    for VertexIndex := 0 to AVertexList.Count - 2 do
    begin
      AVertex := AVertexList.Items[VertexIndex];
      AnotherVertex := AVertexList.Items[VertexIndex + 1];
      if ((Y <= AVertex.YPos) = (Y > AnotherVertex.YPos)) and
        (X - AVertex.XPos - (Y - AVertex.YPos) *
        (AnotherVertex.XPos - AVertex.XPos) /
        (AnotherVertex.YPos - AVertex.YPos) < 0) then
      begin
        result := not result;
      end;
    end;
    result := not result;
  end;
end;

function ContourArea2(ListIndex: integer): double;
var
  Index, InnerIndex: integer;
  AVertexList, AnotherVertexList, ThirdVertexList: TList;
  InnerList: TList;
//  Vertex1, Vertex2: TBL_Vertex;
  AddList: Boolean;
  V1, V2, V3: TBL_Vertex;
  v4, v5, v6: TBL_Vertex;
begin
  AVertexList := MainVertexList.Items[ListIndex];
  result := ContourArea(AVertexList);
  InnerList := TList.Create;
  try
    for Index := 0 to MainVertexList.Count - 1 do
    begin
      if Index <> ListIndex then
      begin
        AnotherVertexList := MainVertexList[Index];
        V1 := AnotherVertexList[0];
        V2 := AnotherVertexList[AnotherVertexList.Count -1];
        V3 := AnotherVertexList[AnotherVertexList.Count div 2];
        if PointInside(V1.XPos, V1.YPos, AVertexList)
          and PointInside(V2.XPos, V2.YPos, AVertexList)
          and PointInside(V3.XPos, V3.YPos, AVertexList) then
        begin
          AddList := True;
          for InnerIndex := InnerList.Count - 1 downto 0 do
          begin
            ThirdVertexList := InnerList[InnerIndex];
            if PointInside(V1.XPos, V1.YPos, ThirdVertexList)
              and PointInside(V2.XPos, V2.YPos, ThirdVertexList)
              and PointInside(V3.XPos, V3.YPos, ThirdVertexList) then
            begin
              AddList := False;
              break;
            end;
            v4 := ThirdVertexList[0];
            v5 := ThirdVertexList[ThirdVertexList.Count -1];
            v6 := ThirdVertexList[ThirdVertexList.Count div 2];
            if PointInside(v4.XPos, v4.YPos, AnotherVertexList)
              and PointInside(v5.XPos, v5.YPos, AnotherVertexList)
              and PointInside(v6.XPos, v6.YPos, AnotherVertexList) then
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

    for Index := 0 to InnerList.Count - 1 do
    begin
      AnotherVertexList := InnerList[Index];
      result := result - ContourArea(AnotherVertexList);
    end;
  finally
    InnerList.Free;
  end;
end;

function GContourArea(ListIndex: integer): double;
begin
  result := ContourArea2(ListIndex);
end;

function AddVerticiesOnEdge(AVertexList: TList; ASegment: TSegment;
  MaxLocation, MinLocation: TBL_Vertex): boolean;
var
  Index: integer;
  IntersectVertex: TVertex;
  EdgeSegment: TSegment;
  FirstVertex, SecondVertex: TVertex;
  V1, V2, V3: TBL_Vertex;
  HighX, HighY, LowX, LowY: double;
  Inside: boolean;
  Higher, Lower: double;
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
    EdgeSegment := TSegment.Create(FirstVertex, SecondVertex);
    try
      for Index := AVertexList.Count - 1 downto 1 do
      begin
        V1 := AVertexList[Index];
        V2 := AVertexList[Index - 1];
        EdgeSegment.FirstVertex.X := V1.XPos;
        EdgeSegment.FirstVertex.Y := V1.YPos;
        EdgeSegment.SecondVertex.X := V2.XPos;
        EdgeSegment.SecondVertex.Y := V2.YPos;
        try
          if ASegment.Intersection(EdgeSegment, IntersectVertex) then
          begin
            V3 := TBL_Vertex.Create;
            V3.XPos := IntersectVertex.X;
            V3.YPos := IntersectVertex.Y;
            AVertexList.Insert(Index, V3);
            // The line SEGMENTS intersect so set result to true.
            result := True;
          end
          else if ASegment.IsVertical then
          begin
            if not EdgeSegment.IsVertical then
            begin
              Higher := Max(EdgeSegment.FirstVertex.X, EdgeSegment.SecondVertex.X);
              Lower := Min(EdgeSegment.FirstVertex.X, EdgeSegment.SecondVertex.X);
              if (Higher >= ASegment.FirstVertex.X) and (ASegment.FirstVertex.X >= Lower) then
              begin
                V3 := TBL_Vertex.Create;
                V3.XPos := IntersectVertex.X;
                V3.YPos := IntersectVertex.Y;
                AVertexList.Insert(Index, V3);
                // The Edge segment intersects the line
                // defined by ASegment but does not intersect
                // ASegment itself so the result is not set.
              end;
            end;
          end
          else if ASegment.IsHorizontal then
          begin
            if not EdgeSegment.IsHorizontal then
            begin
              Higher := Max(EdgeSegment.FirstVertex.Y, EdgeSegment.SecondVertex.Y);
              Lower := Min(EdgeSegment.FirstVertex.Y, EdgeSegment.SecondVertex.Y);
              if (Higher >= ASegment.FirstVertex.Y) and (ASegment.FirstVertex.Y >= Lower) then
              begin
                V3 := TBL_Vertex.Create;
                V3.XPos := IntersectVertex.X;
                V3.YPos := IntersectVertex.Y;
                AVertexList.Insert(Index, V3);
                // The Edge segment intersects the line
                // defined by ASegment but does not intersect
                // ASegment itself so the result is not set.
              end;
            end;
          end
          else
          begin
            Assert(False);
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

function AddVerticiesOnEdges(AVertexList: TList;
  LeftEdge, RightEdge, TopEdge, BottomEdge: double;
  Max, Min: TBL_Vertex): boolean;
var
  TopLeft, TopRight, BottomLeft, BottomRight: TVertex;
  LeftSeg, RightSeg, TopSeg, BotSeg: TSegment;
begin
  TopLeft := TVertex.Create;
  TopRight := TVertex.Create;
  BottomLeft := TVertex.Create;
  BottomRight := TVertex.Create;
  try
    TopLeft.X := LeftEdge;
    TopRight.X := RightEdge;
    BottomLeft.X := LeftEdge;
    BottomRight.X := RightEdge;
    TopLeft.Y := TopEdge;
    TopRight.Y := TopEdge;
    BottomLeft.Y := BottomEdge;
    BottomRight.Y := BottomEdge;
    LeftSeg := TSegment.Create(TopLeft, BottomLeft);
    RightSeg := TSegment.Create(TopRight, BottomRight);
    TopSeg := TSegment.Create(TopLeft, TopRight);
    BotSeg := TSegment.Create(BottomRight, BottomLeft);
    try
      result := AddVerticiesOnEdge(AVertexList, LeftSeg, Max, Min);
      result := AddVerticiesOnEdge(AVertexList, RightSeg, Max, Min) or result;
      result := AddVerticiesOnEdge(AVertexList, TopSeg, Max, Min) or result;
      result := AddVerticiesOnEdge(AVertexList, BotSeg, Max, Min) or result;
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

function GetContourAreaInCell(Column, Row: ANE_INT32;
  AVertexList: TList; MinX, MaxX, MinY, MaxY: double): ANE_DOUBLE;
var
  LeftEdge, RightEdge, TopEdge, BottomEdge: double;
  VerticiesInCell: TList;
  Index: integer;
  AVertex, AnotherVertex: TBL_Vertex;
  Temp: double;
  CellCorners: TList;
  Max, Min: TBL_Vertex;
begin
  result := 0;
  RightEdge := ColumnList[Column];
  LeftEdge := ColumnList[Column - 1];
  if LeftEdge > RightEdge then
  begin
    Temp := LeftEdge;
    LeftEdge := RightEdge;
    RightEdge := Temp;
  end;
  if (LeftEdge > MaxX) or (RightEdge < MinX) then
  begin
    Exit;
  end;
  TopEdge := RowList[Row];
  BottomEdge := RowList[Row - 1];
  if BottomEdge > TopEdge then
  begin
    Temp := BottomEdge;
    BottomEdge := TopEdge;
    TopEdge := Temp;
  end;
  if (BottomEdge > MaxY) or (TopEdge < MinY) then
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
    for Index := 0 to AVertexList.Count - 1 do
    begin
      AVertex := AVertexList[Index];
      AVertex := AVertex.CopyOfVertex;
      VerticiesInCell.Add(AVertex);
    end;
    if not AddVerticiesOnEdges(VerticiesInCell,
      LeftEdge, RightEdge, TopEdge, BottomEdge, Max, Min) then
    begin
      if not PointInside(LeftEdge, TopEdge, VerticiesInCell) then
      begin
        CellCorners := TList.Create;
        try
          AVertex := TBL_Vertex.Create;
          AVertex.XPos := LeftEdge;
          AVertex.YPos := TopEdge;
          CellCorners.Add(AVertex);

          AVertex := TBL_Vertex.Create;
          AVertex.XPos := RightEdge;
          AVertex.YPos := TopEdge;
          CellCorners.Add(AVertex);

          AVertex := TBL_Vertex.Create;
          AVertex.XPos := RightEdge;
          AVertex.YPos := BottomEdge;
          CellCorners.Add(AVertex);

          AVertex := TBL_Vertex.Create;
          AVertex.XPos := LeftEdge;
          AVertex.YPos := BottomEdge;
          CellCorners.Add(AVertex);

          AVertex := TBL_Vertex.Create;
          AVertex.XPos := LeftEdge;
          AVertex.YPos := TopEdge;
          CellCorners.Add(AVertex);

          AVertex := VerticiesInCell[0];
          if not PointInside(AVertex.XPos, AVertex.YPos, CellCorners) then
          begin
            result := 0;
            Exit;
          end;
        finally
          for Index := 0 to CellCorners.Count - 1 do
          begin
            TBL_Vertex(CellCorners[Index]).Free;
          end;

          CellCorners.Free;
        end;
      end;
    end;
    for Index := 0 to VerticiesInCell.Count - 1 do
    begin
      AVertex := VerticiesInCell[Index];
      if AVertex.YPos > TopEdge then
      begin
        AVertex.YPos := TopEdge
      end
      else if AVertex.YPos < BottomEdge then
      begin
        AVertex.YPos := BottomEdge
      end;
      if AVertex.XPos > RightEdge then
      begin
        AVertex.XPos := RightEdge
      end
      else if AVertex.XPos < LeftEdge then
      begin
        AVertex.XPos := LeftEdge
      end;
    end;
    for Index := VerticiesInCell.Count - 1 downto 1 do
    begin
      AVertex := VerticiesInCell[Index];
      AnotherVertex := VerticiesInCell[Index - 1];
      if (AVertex.XPos = AnotherVertex.XPos)
        and (AVertex.YPos = AnotherVertex.YPos) then
      begin
        VerticiesInCell.Delete(Index);
        AVertex.Free;
      end;
    end;

    result := ContourArea(VerticiesInCell);
  finally
    for Index := VerticiesInCell.Count - 1 downto 0 do
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
  ListIndex, InnerListIndex, ThirdListIndex: integer;
  AVertexList, AnotherVertexList, ThirdVertexList: TList;
  Column, Row: integer;
  AVertex: TBL_Vertex;
  InnerContours: TList;
  ContoursDeleted: boolean;
  Position: integer;
  ColumnCount, RowCount: integer;
  MinXPos, MaxXPos, MinYPos, MaxYPos: double;
  Index: integer;
  //  Inside : boolean;
begin
  ColumnCount := GGetColumnBoundaryCount - 1;
  RowCount := GGetRowBoundaryCount - 1;
  SetAreaValuesSize(MainVertexList.Count, ColumnCount, RowCount);
  for Column := 1 to ColumnCount do
  begin
    for Row := 1 to RowCount do
    begin
      AreaValues[0, Column - 1, Row - 1] := GGetCellArea(Column, Row);
    end;
  end;
  for ListIndex := 0 to MainVertexList.Count - 1 do
  begin
    AVertexList := MainVertexList[ListIndex];
    MaxXPos := 0;
    MaxYPos := 0;
    MinXPos := 0;
    MinYPos := 0;
    for Index := 0 to AVertexList.Count - 1 do
    begin
      AVertex := AVertexList[Index];
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
        AreaValues[ListIndex + 1, Column - 1, Row - 1] := GetContourAreaInCell
          (Column, Row, AVertexList, MinXPos, MaxXPos, MinYPos, MaxYPos);
      end;
    end;
  end;

  InnerContours := TList.Create;
  try

    for ListIndex := 0 to MainVertexList.Count - 1 do
    begin
      InnerContours.Clear;
      AVertexList := MainVertexList[ListIndex];
      for InnerListIndex := 0 to MainVertexList.Count - 1 do
      begin
        if InnerListIndex <> ListIndex then
        begin
          AnotherVertexList := MainVertexList[InnerListIndex];
          if AnotherVertexList.Count > 0 then
          begin
            AVertex := AnotherVertexList[0];
            if PointInside(AVertex.XPos, AVertex.YPos, AVertexList) then
            begin
              InnerContours.Add(AnotherVertexList)
            end;
          end;
        end;
      end;
      repeat
        ContoursDeleted := False;
        for InnerListIndex := InnerContours.Count - 1 downto 0 do
        begin
          AnotherVertexList := InnerContours[InnerListIndex];
          for ThirdListIndex := InnerContours.Count - 1 downto 0 do
          begin
            if (InnerListIndex <> ThirdListIndex) then
            begin
              ThirdVertexList := InnerContours[ThirdListIndex];
              AVertex := ThirdVertexList[0];
              if PointInside(AVertex.XPos, AVertex.YPos, AnotherVertexList) then
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
      for InnerListIndex := 0 to InnerContours.Count - 1 do
      begin
        AnotherVertexList := InnerContours[InnerListIndex];
        Position := MainVertexList.IndexOf(AnotherVertexList) + 1;
        for Column := 0 to ColumnCount - 1 do
        begin
          for Row := 0 to RowCount - 1 do
          begin
            if AreaValues[ListIndex + 1, Column, Row] > 0 then
            begin
              AreaValues[ListIndex + 1, Column, Row] :=
                AreaValues[ListIndex + 1, Column, Row]
                - AreaValues[Position, Column, Row];
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
    for Column := 0 to ColumnCount - 1 do
    begin
      for Row := 0 to RowCount - 1 do
      begin
        AreaValues[0, Column, Row] :=
          AreaValues[0, Column, Row]
          - AreaValues[ListIndex, Column, Row];
      end;
    end;
  end;
end;

function GContourIntersectCellRemainder(Column, Row: ANE_INT32): double;
begin
  result := AreaValues[0, Column - 1, Row - 1];
end;

function GContourIntersectCell(ListToUse, Column, Row: ANE_INT32): double;
begin
  result := AreaValues[ListToUse + 1, Column - 1, Row - 1];
end;

function GPointInsideContour(ListToUse: ANE_INT32; X, Y: ANE_DOUBLE): boolean;
var
  AVertexList, AnotherVertexList: TList;
  AVertex, AnotherVertex: TBL_Vertex;
  ListIndex: integer;
begin
  AVertexList := MainVertexList.Items[ListToUse];
  if AVertexList.Count < 3 then
  begin
    result := False;
  end // if AVertexList.Count < 3
  else
  begin
    AVertex := AVertexList.Items[0];
    AnotherVertex := AVertexList.Items[AVertexList.Count - 1];
    if not ((AVertex.XPos = AnotherVertex.XPos) and (AVertex.YPos =
      AnotherVertex.YPos)) then
    begin
      // contour is an open contour.
      result := False;
    end // if not ((AVertex.XPos = AnotherVertex.XPos) and (AVertex.YPos = AnotherVertex.YPos))
    else
    begin
      result := PointInside(X, Y, AVertexList);
      if result then
      begin
        for ListIndex := 0 to MainVertexList.Count - 1 do
        begin
          if ListIndex <> ListToUse then
          begin
            AnotherVertexList := MainVertexList[ListIndex];
            AVertex := AnotherVertexList[0];
            if PointInside(AVertex.XPos, AVertex.YPos, AVertexList) then
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
  end; // if AVertexList.Count < 3 else
end;

procedure GPointInsideContourMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

var
  result: ANE_BOOL;
  param: PParameter_array;
  param1_ptr: ANE_INT32_PTR;
  ListToUse: ANE_INT32;
  param2_ptr: ANE_DOUBLE_PTR;
  X: ANE_DOUBLE;
  param3_ptr: ANE_DOUBLE_PTR;
  Y: ANE_DOUBLE;
  param4_ptr: ANE_BOOL_PTR;
  RotatePoints: ANE_BOOL;
begin
  try
    begin
      param := @parameters^;
      param1_ptr := param^[0];
      ListToUse := param1_ptr^;
      param2_ptr := param^[1];
      X := param2_ptr^;
      param3_ptr := param^[2];
      Y := param3_ptr^;
      if numParams > 3 then
      begin
        param4_ptr := param^[3];
        RotatePoints := param4_ptr^;
      end
      else
      begin
        RotatePoints := False;
      end;
      if RotatePoints then
      begin
        RotatePointsToGrid(X, Y, GridAngle);
      end;
      result := GPointInsideContour(ListToUse, X, Y);
    end // try
  except
    on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;

  ANE_BOOL_PTR(reply)^ := result;
end;

function GContourType(ListToUse: ANE_INT32): integer;
var
  AVertexList: TList;
  AVertex, AnotherVertex: TBL_Vertex;
begin
  AVertexList := MainVertexList.Items[ListToUse];
  if AVertexList.Count = 0 then
  begin
    result := 0;
  end
  else
  if AVertexList.Count = 1 then
  begin
    result := 1;
  end
  else
  begin
    AVertex := AVertexList.Items[0];
    AnotherVertex := AVertexList.Items[AVertexList.Count - 1];
    if not ((AVertex.XPos = AnotherVertex.XPos) and (AVertex.YPos =
      AnotherVertex.YPos)) then
    begin
      // contour is an open contour.
      result := 2;
    end
    else if AVertexList.Count = 2 then
    begin
      result := 1;
    end
    else
    begin
      result := 3;
    end;
  end;
end;

procedure GContourTypeMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_INT32;
  param: PParameter_array;
  param1_ptr: ANE_INT32_PTR;
  ListToUse: ANE_INT32;
begin
  try
    begin
      param := @parameters^;
      param1_ptr := param^[0];
      ListToUse := param1_ptr^;
      result := GContourType(ListToUse);
    end // try
  except
    on Exception do
    begin
      Inc(ErrorCount);
      result := 0;
    end;
  end;

  ANE_INT32_PTR(reply)^ := result;
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
  result := Values[X, Y, Z];
end;

procedure TAreaValues.SetItems(const X, Y, Z: integer;
  const Value: double);
begin
  CheckLimits(X, Y, Z);
  Values[X, Y, Z] := Value;
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
  AreaValues.SetValuesLength(0, 0, 0);

finalization
  begin
    ResetAreaValues;
    AreaValues.Free;
  end;

end.

