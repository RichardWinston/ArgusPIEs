unit CrossRowUnit;

interface

uses ANEPIE, Classes, SysUtils;

function GGetCountOfCrossRowLists: ANE_INT32;

procedure GGetCountOfCrossRowListsMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetCountOfACrossRowList(ListIndex: ANE_INT32): ANE_INT32;

procedure GGetCountOfACrossRowListMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetCrossRowRow(ListIndex, CellIndex: ANE_INT32): ANE_INT32;

procedure GGetCrossRowRowMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetCrossRowColumn(ListIndex, CellIndex: ANE_INT32): ANE_INT32;

procedure GGetCrossRowColumnMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetCrossRowNeighborColumn(ListIndex, CellIndex: ANE_INT32): ANE_INT32;

procedure GGetCrossRowNeighborColumnMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetCrossRowCompositeY(ListIndex, CellIndex: ANE_INT32): ANE_DOUBLE;

procedure GGetCrossRowCompositeYMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetSumCrossRowCompositeY(ListIndex: ANE_INT32): ANE_DOUBLE;

procedure GGetSumCrossRowCompositeYMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetCrossRowCompositeLength(ListIndex, CellIndex: ANE_INT32):
  ANE_DOUBLE;

procedure GGetCrossRowCompositeLengthMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

implementation

uses BlockListUnit, CellVertexUnit;

function GGetCountOfCrossRowLists: ANE_INT32;
begin
  if not (CrossRowCellsList = nil) then
  begin
    result := CrossRowCellsList.Count;
  end
  else
  begin
    result := 0;
  end;
end;

procedure GGetCountOfCrossRowListsMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_INT32;
begin
  try
    begin
      result := GGetCountOfCrossRowLists;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCountOfACrossRowList(ListIndex: ANE_INT32): ANE_INT32;
var
  AList: TList;
begin
  AList := CrossRowCellsList[ListIndex];
  result := AList.Count;
end;

procedure GGetCountOfACrossRowListMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_INT32;
  param1_ptr: ANE_INT32_PTR;
  ListIndex: ANE_INT32; // position in list of item .
  param: PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr := param^[0];
      ListIndex := param1_ptr^;
      result := GGetCountOfACrossRowList(ListIndex);
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCrossRowRow(ListIndex, CellIndex: ANE_INT32): ANE_INT32;
var
  AList: TList;
  ACell: TCell;
begin
  AList := CrossRowCellsList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.Row;
end;

procedure GGetCrossRowRowMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_INT32;
  param1_ptr: ANE_INT32_PTR;
  param2_ptr: ANE_INT32_PTR;
  ListIndex: ANE_INT32; // position in list of item .
  CellIndex: ANE_INT32; // position in list of item .
  param: PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr := param^[0];
      ListIndex := param1_ptr^;
      param2_ptr := param^[1];
      CellIndex := param2_ptr^;
      result := GGetCrossRowRow(ListIndex, CellIndex);
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCrossRowColumn(ListIndex, CellIndex: ANE_INT32): ANE_INT32;
var
  AList: TList;
  ACell: TCell;

begin
  AList := CrossRowCellsList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.Column;
end;

procedure GGetCrossRowColumnMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_INT32;
  param1_ptr: ANE_INT32_PTR;
  param2_ptr: ANE_INT32_PTR;
  ListIndex: ANE_INT32; // position in list of item .
  CellIndex: ANE_INT32; // position in list of item .
  param: PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr := param^[0];
      ListIndex := param1_ptr^;
      param2_ptr := param^[1];
      CellIndex := param2_ptr^;
      result := GGetCrossRowColumn(ListIndex, CellIndex);
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCrossRowNeighborColumn(ListIndex, CellIndex: ANE_INT32): ANE_INT32;
const
  RoundError = 1E-10;
var
  AList: TList;
  ACell: TCell;
  AverageVertex: ANE_DOUBLE;
  CellCenter: ANE_DOUBLE;
  NonReversedGrid: boolean;
  FirstColumn, LastColumn: double;
begin
  FirstColumn := ColumnList[0];
  LastColumn := ColumnList[ColumnList.Count - 1];
  NonReversedGrid := (LastColumn > FirstColumn);
  AList := CrossRowCellsList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.Column;
  AverageVertex := (ACell.SegmentFirstVertexXPos(0) +
    ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count - 1)) / 2;
  CellCenter := ACell.ColumnCenter;
  if Abs((AverageVertex - CellCenter)
    / (Abs(AverageVertex) + Abs(CellCenter) + RoundError)) < RoundError then
  begin
    if (ACell.SegmentFirstVertexYPos(0) +
      ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count - 1)) / 2 >
        ACell.RowCenter then
    begin
      if (ACell.SegmentFirstVertexXPos(0) >
        ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count - 1))
        and (ACell.SegmentFirstVertexYPos(0) >
        ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count - 1))
        or
        (ACell.SegmentFirstVertexXPos(0) <
        ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count - 1))
        and (ACell.SegmentFirstVertexYPos(0) <
        ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count - 1)) then

      begin
        if NonReversedGrid then
        begin
          Dec(result);
        end
        else
        begin
          Inc(result);
        end;
      end
      else
      begin
        if NonReversedGrid then
        begin
          Inc(result);
        end
        else
        begin
          Dec(result);
        end;
      end;
    end
    else
    begin
      if (ACell.SegmentFirstVertexXPos(0) >
        ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count - 1))
        and (ACell.SegmentFirstVertexYPos(0) >
        ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count - 1))
        or
        (ACell.SegmentFirstVertexXPos(0) <
        ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count - 1))
        and (ACell.SegmentFirstVertexYPos(0) <
        ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count - 1)) then
      begin
        if NonReversedGrid then
        begin
          Inc(result);
        end
        else
        begin
          Dec(result);
        end;
      end
      else
      begin
        if NonReversedGrid then
        begin
          Dec(result);
        end
        else
        begin
          Inc(result);
        end;
      end;
    end;
  end
  else if AverageVertex > CellCenter then
  begin
    if NonReversedGrid then
    begin
      Inc(result);
    end
    else
    begin
      Dec(result);
    end;
  end
  else
  begin
    if NonReversedGrid then
    begin
      Dec(result);
    end
    else
    begin
      Inc(result);
    end;
  end;

end;

procedure GGetCrossRowNeighborColumnMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_INT32;
  param1_ptr: ANE_INT32_PTR;
  param2_ptr: ANE_INT32_PTR;
  ListIndex: ANE_INT32;
  CellIndex: ANE_INT32;
  param: PParameter_array;
begin
  try
    begin

      {      FirstColumn := ColumnList.Items[0];
            LastColumn :=  ColumnList.Items[ColumnList.Count -1];
            NonReversedGrid := (LastColumn.Value > FirstColumn.Value); }
      param := @parameters^;
      param1_ptr := param^[0];
      ListIndex := param1_ptr^;
      param2_ptr := param^[1];
      CellIndex := param2_ptr^;
      result := GGetCrossRowNeighborColumn(ListIndex, CellIndex);
      {      AList := CrossRowCellsList[ListIndex];
            ACell := AList[CellIndex];
            result := ACell.Column;
      //      LeftPosition := TReal(ColumnList.Items[result]).Value;
      //      RightPosition := TReal(ColumnList.Items[result+1]).Value;
            AverageVertex := (ACell.SegmentFirstVertexXPos(0) +
              ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count-1))/2;
            CellCenter := ACell.ColumnCenter;
            if Abs((AverageVertex - CellCenter)
              /(Abs(AverageVertex) + Abs(CellCenter) + RoundError)) < RoundError
            then
              begin
                if (ACell.SegmentFirstVertexYPos(0) +
                  ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count-1))/2 > ACell.RowCenter
                then
                  begin
                        if (ACell.SegmentFirstVertexXPos(0) >
                             ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count-1))
                             and (ACell.SegmentFirstVertexYPos(0) >
                             ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count-1))
                          or
                            (ACell.SegmentFirstVertexXPos(0) <
                             ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count-1))
                             and (ACell.SegmentFirstVertexYPos(0) <
                             ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count-1))
                        then
                          begin
                            if NonReversedGrid
                            then
                              begin
                                Dec(result);
                              end
                            else
                              begin
                                Inc(result);
                              end;
                          end
                        else
                          begin
                            if NonReversedGrid
                            then
                              begin
                                Inc(result);
                              end
                            else
                              begin
                                Dec(result);
                              end;
                          end;
                      end
                    else
                      begin
                        if (ACell.SegmentFirstVertexXPos(0) >
                             ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count-1))
                             and (ACell.SegmentFirstVertexYPos(0) >
                             ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count-1))
                          or
                            (ACell.SegmentFirstVertexXPos(0) <
                             ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count-1))
                             and (ACell.SegmentFirstVertexYPos(0) <
                             ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count-1))
                        then
                          begin
                            if NonReversedGrid
                            then
                              begin
                                Inc(result);
                              end
                            else
                              begin
                                Dec(result);
                              end;
                          end
                        else
                          begin
                            if NonReversedGrid
                            then
                              begin
                                Dec(result);
                              end
                            else
                              begin
                                Inc(result);
                              end;
                          end;
                      end;
              end
            else if AverageVertex > CellCenter
            then
              begin
                            if NonReversedGrid
                            then
                              begin
                                Inc(result);
                              end
                            else
                              begin
                                Dec(result);
                              end;
              end
            else
              begin
                            if NonReversedGrid
                            then
                              begin
                                Dec(result);
                              end
                            else
                              begin
                                Inc(result);
                              end;
              end;
            }
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCrossRowCompositeY(ListIndex, CellIndex: ANE_INT32): ANE_DOUBLE;
var
  AList: TList;
  ACell: TCell;
begin
  AList := CrossRowCellsList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.CompositeY;
end;

procedure GGetCrossRowCompositeYMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_DOUBLE;
  param1_ptr: ANE_INT32_PTR;
  param2_ptr: ANE_INT32_PTR;
  ListIndex: ANE_INT32; // position in list of item .
  CellIndex: ANE_INT32; // position in list of item .
  param: PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr := param^[0];
      ListIndex := param1_ptr^;
      param2_ptr := param^[1];
      CellIndex := param2_ptr^;
      result := GGetCrossRowCompositeY(ListIndex, CellIndex);
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetSumCrossRowCompositeY(ListIndex: ANE_INT32): ANE_DOUBLE;
var
  CellIndex: ANE_INT32; // position in list of item .
  AList: TList;
  ACell: TCell;

begin
  AList := CrossColumnCellsList[ListIndex];
  result := 0;
  for CellIndex := 0 to AList.Count - 1 do
  begin
    ACell := AList[CellIndex];
    result := result + ACell.CompositeY;
  end;
end;

procedure GGetSumCrossRowCompositeYMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_DOUBLE;
  param1_ptr: ANE_INT32_PTR;
  ListIndex: ANE_INT32; // position in list of item .
  param: PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr := param^[0];
      ListIndex := param1_ptr^;
      result := GGetSumCrossRowCompositeY(ListIndex);

    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetCrossRowCompositeLength(ListIndex, CellIndex: ANE_INT32):
  ANE_DOUBLE;
var
  ACrossRowList: TList;
  ACellList: TList;
  ACell: TCell;
  BeginCellIndex, EndCellIndex: Integer;
  AnotherCell: TCell;
  AnotherCellIndex: integer;
  StartX, EndX: ANE_DOUBLE;
  SegmentIndex: integer;
  StartVertexIndex, EndVertexIndex: integer;
  TempIndex : integer;
begin
  ACrossRowList := CrossRowCellsList[ListIndex];
  ACell := ACrossRowList[CellIndex];
  ACellList := MainCellList[ListIndex];

  result := 0;
  BeginCellIndex := ACellList.IndexOf(ACell.RowBeginCell);
  EndCellIndex := ACellList.IndexOf(ACell.RowEndCell);
  if EndCellIndex >= BeginCellIndex then
  begin
    for AnotherCellIndex := BeginCellIndex to EndCellIndex do
    begin
      AnotherCell := ACellList[AnotherCellIndex];
      StartVertexIndex := -1;
      if AnotherCellIndex = BeginCellIndex then
      begin
        // get starting x
        if AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count - 1)
          > AnotherCell.ColumnCenter then
        begin
          StartX := AnotherCell.MinX;
        end
        else
        begin
          StartX := AnotherCell.MaxX;
        end;
        if not (AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count
          - 1)
          = StartX) then
        begin
          for SegmentIndex := AnotherCell.SegmentList.Count - 1 downto 0 do
          begin
            if AnotherCell.SegmentFirstVertexXPos(SegmentIndex) = StartX then
            begin
              StartVertexIndex := SegmentIndex;
              break;
            end;
          end;
        end;
      end;
      EndVertexIndex := AnotherCell.SegmentList.Count;
      if AnotherCellIndex = EndCellIndex then
      begin
        if AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count - 1)
          > AnotherCell.ColumnCenter then
        begin
          EndX := AnotherCell.MaxX;
        end
        else
        begin
          EndX := AnotherCell.MinX;
        end;
        for SegmentIndex := 0 to AnotherCell.SegmentList.Count - 1 do
        begin
          if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = EndX then
          begin
            EndVertexIndex := SegmentIndex;
            break;
          end;
        end;
      end;
      if not (StartVertexIndex = -1) or not (EndVertexIndex =
        AnotherCell.SegmentList.Count) then
      begin
        if StartVertexIndex = -1 then
        begin
          StartVertexIndex := 0;
        end;
        if EndVertexIndex = AnotherCell.SegmentList.Count then
        begin
          EndVertexIndex := AnotherCell.SegmentList.Count - 1;
        end;
        if StartVertexIndex > EndVertexIndex then
        begin
          TempIndex := StartVertexIndex;
          StartVertexIndex := EndVertexIndex;
          EndVertexIndex := TempIndex;
        end;
        for SegmentIndex := StartVertexIndex to EndVertexIndex do
        begin
          result := result + AnotherCell.SegmentLength(SegmentIndex)
        end;
      end
      else
      begin
        result := result + AnotherCell.SumSegmentLength;
      end;
    end;
  end
  else
  begin
    for AnotherCellIndex := 0 to BeginCellIndex do
    begin
      AnotherCell := ACellList[AnotherCellIndex];
      StartVertexIndex := -1;
      if AnotherCellIndex = BeginCellIndex then
      begin
        // get starting x
        if AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count - 1)
          > AnotherCell.ColumnCenter then
        begin
          StartX := AnotherCell.MinX;
        end
        else
        begin
          StartX := AnotherCell.MaxX;
        end;
        if not (AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count
          - 1) = StartX) then
        begin
          for SegmentIndex := AnotherCell.SegmentList.Count - 1 downto 0 do
          begin
            if AnotherCell.SegmentFirstVertexXPos(SegmentIndex) = StartX then
            begin
              StartVertexIndex := SegmentIndex;
              break;
            end;
          end;
        end;
      end;
      EndVertexIndex := AnotherCell.SegmentList.Count;
      if AnotherCellIndex = EndCellIndex then
      begin
        if AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count - 1)
          > AnotherCell.ColumnCenter then
        begin
          EndX := AnotherCell.MaxX;
        end
        else
        begin
          EndX := AnotherCell.MinX;
        end;
        for SegmentIndex := 0 to AnotherCell.SegmentList.Count - 1 do
        begin
          if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = EndX then
          begin
            EndVertexIndex := SegmentIndex;
            break;
          end;
        end;
      end;
      if not (StartVertexIndex = -1) or not (EndVertexIndex =
        AnotherCell.SegmentList.Count) then
      begin
        if StartVertexIndex = -1 then
        begin
          StartVertexIndex := 0;
        end;
        if EndVertexIndex = AnotherCell.SegmentList.Count then
        begin
          EndVertexIndex := AnotherCell.SegmentList.Count - 1;
        end;
        for SegmentIndex := StartVertexIndex to EndVertexIndex do
        begin
          result := result + AnotherCell.SegmentLength(SegmentIndex)
        end;
      end
      else
      begin
        result := result + AnotherCell.SumSegmentLength;
      end;
    end;

    for AnotherCellIndex := EndCellIndex to ACellList.Count - 1 do
    begin
      AnotherCell := ACellList[AnotherCellIndex];
      StartVertexIndex := -1;
      if AnotherCellIndex = BeginCellIndex then
      begin
        // get starting x
        if AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count - 1)
          > AnotherCell.ColumnCenter then
        begin
          StartX := AnotherCell.MinX;
        end
        else
        begin
          StartX := AnotherCell.MaxX;
        end;
        if not (AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count
          - 1) = StartX) then
        begin
          for SegmentIndex := AnotherCell.SegmentList.Count - 1 downto 0 do
          begin
            if AnotherCell.SegmentFirstVertexXPos(SegmentIndex) = StartX then
            begin
              StartVertexIndex := SegmentIndex;
              break;
            end;
          end;
        end;
      end;
      EndVertexIndex := AnotherCell.SegmentList.Count;
      if AnotherCellIndex = EndCellIndex then
      begin
        if AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count - 1)
          > AnotherCell.ColumnCenter then
        begin
          EndX := AnotherCell.MaxX;
        end
        else
        begin
          EndX := AnotherCell.MinX;
        end;
        for SegmentIndex := 0 to AnotherCell.SegmentList.Count - 1 do
        begin
          if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = EndX then
          begin
            EndVertexIndex := SegmentIndex;
            break;
          end;
        end;
      end;
      if not (StartVertexIndex = -1) or not (EndVertexIndex =
        AnotherCell.SegmentList.Count) then
      begin
        if StartVertexIndex = -1 then
        begin
          StartVertexIndex := 0;
        end;
        if EndVertexIndex = AnotherCell.SegmentList.Count then
        begin
          EndVertexIndex := AnotherCell.SegmentList.Count - 1;
        end;
        for SegmentIndex := StartVertexIndex to EndVertexIndex do
        begin
          result := result + AnotherCell.SegmentLength(SegmentIndex)
        end;
      end
      else
      begin
        result := result + AnotherCell.SumSegmentLength;
      end;
    end;
  end;

end;

procedure GGetCrossRowCompositeLengthMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_DOUBLE;
  param1_ptr: ANE_INT32_PTR;
  param2_ptr: ANE_INT32_PTR;
  ListIndex: ANE_INT32; // position in list of item .
  CellIndex: ANE_INT32; // position in list of item .
  param: PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr := param^[0];
      ListIndex := param1_ptr^;
      param2_ptr := param^[1];
      CellIndex := param2_ptr^;
      result := GGetCrossRowCompositeLength(ListIndex, CellIndex);
      {      ACrossRowList := CrossRowCellsList[ListIndex];
            ACell := ACrossRowList[CellIndex];
            ACellList := MainCellList[ListIndex];

            result := 0;
            BeginCellIndex := ACellList.IndexOf(ACell.RowBeginCell);
            EndCellIndex := ACellList.IndexOf(ACell.RowEndCell);
            if EndCellIndex > BeginCellIndex
            then
            begin
              for AnotherCellIndex := BeginCellIndex to EndCellIndex do
              begin
                AnotherCell := ACellList[AnotherCellIndex];
                StartVertexIndex := -1 ;
                if AnotherCellIndex = BeginCellIndex then
                begin
                  // get starting x
                  if AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count -1)
                     > AnotherCell.ColumnCenter
                  then
                    begin
                      StartX := AnotherCell.MinX;
                    end
                  else
                    begin
                      StartX := AnotherCell.MaxX;
                    end;
                  if not (AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count -1)
                    = StartX) then
                  begin
                    For SegmentIndex := AnotherCell.SegmentList.Count -1 downto 0 do
                    begin
                      if AnotherCell.SegmentFirstVertexXPos(SegmentIndex) = StartX then
                        begin
                          StartVertexIndex := SegmentIndex;
                          break;
                        end;
                    end;
                  end;
                end;
                EndVertexIndex := AnotherCell.SegmentList.Count ;
                if AnotherCellIndex = EndCellIndex then
                begin
                  if AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count -1) > AnotherCell.ColumnCenter
                  then
                    begin
                      EndX := AnotherCell.MaxX;
                    end
                  else
                    begin
                      EndX := AnotherCell.MinX;
                    end;
                  For SegmentIndex := 0 to AnotherCell.SegmentList.Count -1 do
                  begin
                    if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = EndX then
                      begin
                        EndVertexIndex := SegmentIndex;
                        break;
                      end;
                  end;
                end;
                if not (StartVertexIndex = -1) or not (EndVertexIndex = AnotherCell.SegmentList.Count)
                then
                  begin
                    if StartVertexIndex = -1 then
                    begin
                      StartVertexIndex := 0;
                    end;
                    if EndVertexIndex = AnotherCell.SegmentList.Count
                    then
                      begin
                        EndVertexIndex := AnotherCell.SegmentList.Count-1;
                      end;
                    for SegmentIndex := StartVertexIndex to EndVertexIndex do
                    begin
                      result := result + AnotherCell.SegmentLength(SegmentIndex)
                    end;
                  end
                else
                  begin
                    result := result + AnotherCell.SumSegmentLength;
                  end;
              end;
            end
            else
            begin
              for AnotherCellIndex := 0 to BeginCellIndex do
              begin
                AnotherCell := ACellList[AnotherCellIndex];
                StartVertexIndex := -1 ;
                if AnotherCellIndex = BeginCellIndex then
                begin
                  // get starting x
                  if AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count -1) > AnotherCell.ColumnCenter
                  then
                    begin
                      StartX := AnotherCell.MinX;
                    end
                  else
                    begin
                      StartX := AnotherCell.MaxX;
                    end;
                  if not (AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count -1) = StartX) then
                  begin
                    For SegmentIndex := AnotherCell.SegmentList.Count -1 downto 0 do
                    begin
                      if AnotherCell.SegmentFirstVertexXPos(SegmentIndex) = StartX then
                        begin
                          StartVertexIndex := SegmentIndex;
                          break;
                        end;
                    end;
                  end;
                end;
                EndVertexIndex := AnotherCell.SegmentList.Count ;
                if AnotherCellIndex = EndCellIndex then
                begin
                  if AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count -1) > AnotherCell.ColumnCenter
                  then
                    begin
                      EndX := AnotherCell.MaxX;
                    end
                  else
                    begin
                      EndX := AnotherCell.MinX;
                    end;
                  For SegmentIndex := 0 to AnotherCell.SegmentList.Count -1 do
                  begin
                    if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = EndX then
                      begin
                        EndVertexIndex := SegmentIndex;
                        break;
                      end;
                  end;
                end;
                if not (StartVertexIndex = -1) or not (EndVertexIndex = AnotherCell.SegmentList.Count)
                then
                  begin
                    if StartVertexIndex = -1 then
                    begin
                      StartVertexIndex := 0;
                    end;
                    if EndVertexIndex = AnotherCell.SegmentList.Count
                    then
                      begin
                        EndVertexIndex := AnotherCell.SegmentList.Count-1;
                      end;
                    for SegmentIndex := StartVertexIndex to EndVertexIndex do
                    begin
                      result := result + AnotherCell.SegmentLength(SegmentIndex)
                    end;
                  end
                else
                  begin
                    result := result + AnotherCell.SumSegmentLength;
                  end;
              end;

              for AnotherCellIndex := EndCellIndex to ACellList.Count -1 do
              begin
                AnotherCell := ACellList[AnotherCellIndex];
                StartVertexIndex := -1 ;
                if AnotherCellIndex = BeginCellIndex then
                begin
                  // get starting x
                  if AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count -1) > AnotherCell.ColumnCenter
                  then
                    begin
                      StartX := AnotherCell.MinX;
                    end
                  else
                    begin
                      StartX := AnotherCell.MaxX;
                    end;
                  if not (AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count -1) = StartX) then
                  begin
                    For SegmentIndex := AnotherCell.SegmentList.Count -1 downto 0 do
                    begin
                      if AnotherCell.SegmentFirstVertexXPos(SegmentIndex) = StartX then
                        begin
                          StartVertexIndex := SegmentIndex;
                          break;
                        end;
                    end;
                  end;
                end;
                EndVertexIndex := AnotherCell.SegmentList.Count ;
                if AnotherCellIndex = EndCellIndex then
                begin
                  if AnotherCell.SegmentSecondVertexXPos(AnotherCell.SegmentList.Count -1) > AnotherCell.ColumnCenter
                  then
                    begin
                      EndX := AnotherCell.MaxX;
                    end
                  else
                    begin
                      EndX := AnotherCell.MinX;
                    end;
                  For SegmentIndex := 0 to AnotherCell.SegmentList.Count -1 do
                  begin
                    if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = EndX then
                      begin
                        EndVertexIndex := SegmentIndex;
                        break;
                      end;
                  end;
                end;
                if not (StartVertexIndex = -1) or not (EndVertexIndex = AnotherCell.SegmentList.Count)
                then
                  begin
                    if StartVertexIndex = -1 then
                    begin
                      StartVertexIndex := 0;
                    end;
                    if EndVertexIndex = AnotherCell.SegmentList.Count
                    then
                      begin
                        EndVertexIndex := AnotherCell.SegmentList.Count-1;
                      end;
                    for SegmentIndex := StartVertexIndex to EndVertexIndex do
                    begin
                      result := result + AnotherCell.SegmentLength(SegmentIndex)
                    end;
                  end
                else
                  begin
                    result := result + AnotherCell.SumSegmentLength;
                  end;
              end;
            end;}

    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

end.

