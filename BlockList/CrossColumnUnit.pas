unit CrossColumnUnit;

interface

uses ANEPIE, Classes, SysUtils;

function GGetCountOfCrossColumnLists: ANE_INT32;

procedure GGetCountOfCrossColumnListsMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetCountOfACrossColumnList(ListIndex: ANE_INT32): ANE_INT32;

procedure GGetCountOfACrossColumnListMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetCrossColumnRow(ListIndex, CellIndex: ANE_INT32): ANE_INT32;

procedure GGetCrossColumnRowMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetCrossColumnNeighborRow(ListIndex, CellIndex: ANE_INT32): ANE_INT32;

procedure GGetCrossColumnNeighborRowMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetCrossColumnColumn(ListIndex, CellIndex: ANE_INT32): ANE_INT32;

procedure GGetCrossColumnColumnMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetCrossColumnCompositeX(ListIndex, CellIndex: ANE_INT32): ANE_DOUBLE;

procedure GGetCrossColumnCompositeXMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetSumCrossColumnCompositeX(ListIndex: ANE_INT32): ANE_DOUBLE;

procedure GGetSumCrossColumnCompositeXMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

function GGetCrossColumnCompositeLength(ListIndex, CellIndex: ANE_INT32):
  ANE_DOUBLE;

procedure GGetCrossColumnCompositeLengthMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

implementation

uses BlockListUnit, CellVertexUnit;

function GGetCountOfCrossColumnLists: ANE_INT32;
begin
  if not (CrossColumnCellsList = nil) then
  begin
    result := CrossColumnCellsList.Count;
  end
  else
  begin
    result := 0;
    Inc(ErrorCount);
  end;
end;

procedure GGetCountOfCrossColumnListsMMFun(const refPtX: ANE_DOUBLE_PTR;
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
      result := GGetCountOfCrossColumnLists;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCountOfACrossColumnList(ListIndex: ANE_INT32): ANE_INT32;
var
  AList: TList;
begin
  AList := CrossColumnCellsList[ListIndex];
  result := AList.Count;
end;

procedure GGetCountOfACrossColumnListMMFun(const refPtX: ANE_DOUBLE_PTR;
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
      result := GGetCountOfACrossColumnList(ListIndex);
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCrossColumnRow(ListIndex, CellIndex: ANE_INT32): ANE_INT32;
var
  AList: TList;
  ACell: TCell;
begin
  AList := CrossColumnCellsList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.Row;
end;

procedure GGetCrossColumnRowMMFun(const refPtX: ANE_DOUBLE_PTR;
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
      result := GGetCrossColumnRow(ListIndex, CellIndex);
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCrossColumnNeighborRow(ListIndex, CellIndex: ANE_INT32): ANE_INT32;
const
  RoundError = 1E-10;
var
  AList: TList;
  ACell: TCell;
  AverageVertex: ANE_DOUBLE;
  CellCenter: ANE_DOUBLE;
  NonReversedGrid: boolean;
  FirstRow, LastRow: double;
begin
  FirstRow := RowList[0];
  LastRow := RowList[RowList.Count - 1];
  NonReversedGrid := (LastRow > FirstRow);
  AList := CrossColumnCellsList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.Row;
  AverageVertex := (ACell.SegmentFirstVertexYPos(0) +
    ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count - 1)) / 2;
  CellCenter := ACell.RowCenter;
  if Abs((AverageVertex - CellCenter)
    / (Abs(AverageVertex) + Abs(CellCenter) + RoundError)) < RoundError then
  begin
    if (ACell.SegmentFirstVertexXPos(0) +
      ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count - 1)) / 2 >
        ACell.ColumnCenter then
    begin
      if ((ACell.SegmentFirstVertexXPos(0) >
        ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count - 1))
        and (ACell.SegmentFirstVertexYPos(0) >
        ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count - 1)))
        or
        ((ACell.SegmentFirstVertexXPos(0) <
        ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count - 1))
        and (ACell.SegmentFirstVertexYPos(0) <
        ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count - 1)))
        {              then
                      begin
                        if (ACell.SegmentFirstVertexYPos(0) +
                          ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count-1))/2 > ACell.RowCenter} then
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
      if ((ACell.SegmentFirstVertexXPos(0) >
        ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count - 1))
        and (ACell.SegmentFirstVertexYPos(0) >
        ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count - 1)))
        or
        ((ACell.SegmentFirstVertexXPos(0) <
        ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count - 1))
        and (ACell.SegmentFirstVertexYPos(0) <
        ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count - 1))) then
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
    {            end
              else
                begin
                  if (ACell.SegmentFirstVertexXPos(0) +
                    ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count-1))/2 > ACell.RowCenter
                  then
                    begin
                      Dec(result);
                    end
                  else
                    begin
                      Inc(result);
                    end;
                end;  }
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

procedure GGetCrossColumnNeighborRowMMFun(const refPtX: ANE_DOUBLE_PTR;
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
      {      FirstRow := RowList.Items[0];
            LastRow :=  RowList.Items[RowList.Count -1];
            NonReversedGrid := (LastRow.Value > FirstRow.Value);  }
      param := @parameters^;
      param1_ptr := param^[0];
      ListIndex := param1_ptr^;
      param2_ptr := param^[1];
      CellIndex := param2_ptr^;
      result := GGetCrossColumnNeighborRow(ListIndex, CellIndex);
      {      AList := CrossColumnCellsList[ListIndex];
            ACell := AList[CellIndex];
            result := ACell.Row;
            AverageVertex := (ACell.SegmentFirstVertexYPos(0) +
              ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count-1))/2;
            CellCenter := ACell.RowCenter;
      //      FirstVertex := ACell.SegmentList.Items[0];
      //      LastVertex := ACell.SegmentList.Items[ACell.SegmentList.Count -1];
            if Abs((AverageVertex - CellCenter)
              /(Abs(AverageVertex) + Abs(CellCenter) + RoundError)) < RoundError
            then
              begin
                if (ACell.SegmentFirstVertexXPos(0) +
                  ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count-1))/2 > ACell.ColumnCenter
                then
                  begin
                    if ((ACell.SegmentFirstVertexXPos(0) >
                         ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count-1))
                         and  (ACell.SegmentFirstVertexYPos(0) >
                           ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count-1)))
                      or
                        ((ACell.SegmentFirstVertexXPos(0) <
                         ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count-1))
                         and  (ACell.SegmentFirstVertexYPos(0) <
                           ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count-1)))
      {              then
                      begin
                        if (ACell.SegmentFirstVertexYPos(0) +
                          ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count-1))/2 > ACell.RowCenter}
      {                  then
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
                    if ((ACell.SegmentFirstVertexXPos(0) >
                         ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count-1))
                         and  (ACell.SegmentFirstVertexYPos(0) >
                           ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count-1)))
                      or
                        ((ACell.SegmentFirstVertexXPos(0) <
                         ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count-1))
                         and  (ACell.SegmentFirstVertexYPos(0) <
                           ACell.SegmentSecondVertexYPos(ACell.SegmentList.Count-1)))
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
      {            end
                else
                  begin
                    if (ACell.SegmentFirstVertexXPos(0) +
                      ACell.SegmentSecondVertexXPos(ACell.SegmentList.Count-1))/2 > ACell.RowCenter
                    then
                      begin
                        Dec(result);
                      end
                    else
                      begin
                        Inc(result);
                      end;
                  end;  }
      {        end
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
              end;  }

    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCrossColumnColumn(ListIndex, CellIndex: ANE_INT32): ANE_INT32;
var
  AList: TList;
  ACell: TCell;
begin
  AList := CrossColumnCellsList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.Column;
end;

procedure GGetCrossColumnColumnMMFun(const refPtX: ANE_DOUBLE_PTR;
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
      result := GGetCrossColumnColumn(ListIndex, CellIndex);
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

function GGetCrossColumnCompositeX(ListIndex, CellIndex: ANE_INT32): ANE_DOUBLE;
var
  AList: TList;
  ACell: TCell;
begin
  AList := CrossColumnCellsList[ListIndex];
  ACell := AList[CellIndex];
  result := ACell.CompositeX;
end;

procedure GGetCrossColumnCompositeXMMFun(const refPtX: ANE_DOUBLE_PTR;
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
      result := GGetCrossColumnCompositeX(ListIndex, CellIndex);
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetSumCrossColumnCompositeX(ListIndex: ANE_INT32): ANE_DOUBLE;
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
    result := result + ACell.CompositeX;
  end;

end;

procedure GGetSumCrossColumnCompositeXMMFun(const refPtX: ANE_DOUBLE_PTR;
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
      result := GGetSumCrossColumnCompositeX(ListIndex);

    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

function GGetCrossColumnCompositeLength(ListIndex, CellIndex: ANE_INT32):
  ANE_DOUBLE;
var
  CrossColList: TList;
  ACellList: TList;
  ACell: TCell;
  BeginCellIndex, EndCellIndex: Integer;
  AnotherCell: TCell;
  AnotherCellIndex: integer;
  StartY, EndY: ANE_DOUBLE;
  SegmentIndex: integer;
  StartVertexIndex, EndVertexIndex: integer;
  TempIndex: integer;
begin
  CrossColList := CrossColumnCellsList[ListIndex];
  ACell := CrossColList[CellIndex];
  ACellList := MainCellList[ListIndex];
  result := 0;

  BeginCellIndex := ACellList.IndexOf(ACell.ColumnBeginCell);
  EndCellIndex := ACellList.IndexOf(ACell.ColumnEndCell);
  if EndCellIndex >= BeginCellIndex then
  begin
    for AnotherCellIndex := BeginCellIndex to EndCellIndex do
    begin
      AnotherCell := ACellList[AnotherCellIndex];
      StartVertexIndex := -1;
      if AnotherCellIndex = BeginCellIndex then
      begin
        // get starting Y
        if AnotherCell.SegmentSecondVertexYPos
          (AnotherCell.SegmentList.Count - 1) > AnotherCell.RowCenter then
        begin
          StartY := AnotherCell.MinY;
        end
        else
        begin
          StartY := AnotherCell.MaxY;
        end;
        if not (AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count
          - 1) = StartY) then
        begin
          for SegmentIndex := AnotherCell.SegmentList.Count - 1 downto 0 do
          begin
            if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = StartY then
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
        if AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count - 1)
          > AnotherCell.RowCenter then
        begin
          EndY := AnotherCell.MaxY;
        end
        else
        begin
          EndY := AnotherCell.MinY;
        end;
        for SegmentIndex := 0 to AnotherCell.SegmentList.Count - 1 do
        begin
          if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = EndY then
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
        if AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count - 1)
          > AnotherCell.RowCenter then
        begin
          StartY := AnotherCell.MinY;
        end
        else
        begin
          StartY := AnotherCell.MaxY;
        end;
        if not (AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count
          - 1) = StartY) then
        begin
          for SegmentIndex := AnotherCell.SegmentList.Count - 1 downto 0 do
          begin
            if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = StartY then
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
        if AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count - 1)
          > AnotherCell.RowCenter then
        begin
          EndY := AnotherCell.MaxY;
        end
        else
        begin
          EndY := AnotherCell.MinY;
        end;
        for SegmentIndex := 0 to AnotherCell.SegmentList.Count - 1 do
        begin
          if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = EndY then
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
        if AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count - 1)
          > AnotherCell.RowCenter then
        begin
          StartY := AnotherCell.MinY;
        end
        else
        begin
          StartY := AnotherCell.MaxY;
        end;
        if not (AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count
          - 1) = StartY) then
        begin
          for SegmentIndex := AnotherCell.SegmentList.Count - 1 downto 0 do
          begin
            if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = StartY then
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
        if AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count - 1)
          > AnotherCell.RowCenter then
        begin
          EndY := AnotherCell.MaxY;
        end
        else
        begin
          EndY := AnotherCell.MinY;
        end;
        for SegmentIndex := 0 to AnotherCell.SegmentList.Count - 1 do
        begin
          if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = EndY then
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

procedure GGetCrossColumnCompositeLengthMMFun(const refPtX: ANE_DOUBLE_PTR;
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

      result := GGetCrossColumnCompositeLength(ListIndex, CellIndex);

      {      CrossColList := CrossColumnCellsList[ListIndex];
            ACell := CrossColList[CellIndex];
            ACellList := MainCellList[ListIndex];
            result := 0;

            BeginCellIndex := ACellList.IndexOf(ACell.ColumnBeginCell);
            EndCellIndex := ACellList.IndexOf(ACell.ColumnEndCell);
            if EndCellIndex > BeginCellIndex then
            begin
              for AnotherCellIndex := BeginCellIndex to EndCellIndex do
              begin
                AnotherCell := ACellList[AnotherCellIndex];
                StartVertexIndex := -1 ;
                if AnotherCellIndex = BeginCellIndex then
                begin
                  // get starting x
                  if AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count -1) > AnotherCell.RowCenter
                  then
                    begin
                      StartX := AnotherCell.MinY;
                    end
                  else
                    begin
                      StartX := AnotherCell.MaxY;
                    end;
                  if not (AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count -1) = StartX) then
                  begin
                    For SegmentIndex := AnotherCell.SegmentList.Count -1 downto 0 do
                    begin
                      if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = StartX then
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
                  if AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count -1) > AnotherCell.RowCenter
                  then
                    begin
                      EndX := AnotherCell.MaxY;
                    end
                  else
                    begin
                      EndX := AnotherCell.MinY;
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
                  if AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count -1) > AnotherCell.RowCenter
                  then
                    begin
                      StartX := AnotherCell.MinY;
                    end
                  else
                    begin
                      StartX := AnotherCell.MaxY;
                    end;
                  if not (AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count -1) = StartX) then
                  begin
                    For SegmentIndex := AnotherCell.SegmentList.Count -1 downto 0 do
                    begin
                      if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = StartX then
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
                  if AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count -1) > AnotherCell.RowCenter
                  then
                    begin
                      EndX := AnotherCell.MaxY;
                    end
                  else
                    begin
                      EndX := AnotherCell.MinY;
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
                  if AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count -1) > AnotherCell.RowCenter
                  then
                    begin
                      StartX := AnotherCell.MinY;
                    end
                  else
                    begin
                      StartX := AnotherCell.MaxY;
                    end;
                  if not (AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count -1) = StartX) then
                  begin
                    For SegmentIndex := AnotherCell.SegmentList.Count -1 downto 0 do
                    begin
                      if AnotherCell.SegmentFirstVertexYPos(SegmentIndex) = StartX then
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
                  if AnotherCell.SegmentSecondVertexYPos(AnotherCell.SegmentList.Count -1) > AnotherCell.RowCenter
                  then
                    begin
                      EndX := AnotherCell.MaxY;
                    end
                  else
                    begin
                      EndX := AnotherCell.MinY;
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
            end;  }

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

