unit InitializeLists;

interface

uses RealListUnit;

procedure ClearAndInitializeMainVertexList;
procedure ClearAndInitializeMainCellList;
procedure ClearAndInitializeCombinedCellList;
procedure ClearAndInitializeCrossRowCellsList;
procedure ClearAndInitializeCrossColumnCellsList;

procedure ClearAndInitializeRowList;
procedure ClearAndInitializeColumnList;
procedure ClearAndInitializeRowMiddleList;
procedure ClearAndInitializeColumnMiddleList;

procedure ClearAndInitializeRowAndColumnLists;

procedure ClearAndInitializeAllButMainVertexLists;
procedure ClearAndInitializeMainLists;


implementation

uses BlockListUnit, CombinedListUnit, CellVertexUnit, Classes;

procedure ClearAndInitializeContourLengths;
begin
  if ContourLengths = nil then
  begin
    ContourLengths := TRealList.Create;
  end
  else
  begin
    ContourLengths.Clear;
  end;
end;

procedure ClearAndInitializeMainOutsideCellsList;
var
  ListIndex, InnerListIndex: integer;
  ACellList: TList;
  ACell: TCell;
begin
  if (MainOutSideCellsList = nil) then
  begin
    MainOutSideCellsList := TList.Create;
  end
  else
  begin
    for ListIndex := MainOutSideCellsList.Count - 1 downto 0 do
    begin
      ACellList := MainOutSideCellsList.Items[ListIndex];
      for InnerListIndex := ACellList.Count - 1 downto 0 do
      begin
        ACell := ACellList.Items[InnerListIndex];
        ACell.Free;
      end;
      ACellList.Clear;
      ACellList.Free;
    end;
    MainOutSideCellsList.Clear;
  end;
end;

procedure ClearAndInitializeMainVertexList;
var
  ListIndex, InnerListIndex: integer;
  AVertexList: TList;
  AVertex: TBL_Vertex;
begin
  if (MainVertexList = nil) then
  begin
    MainVertexList := TList.Create;
  end
  else
  begin
    for ListIndex := MainVertexList.Count - 1 downto 0 do
    begin
      AVertexList := MainVertexList.Items[ListIndex];
      for InnerListIndex := AVertexList.Count - 1 downto 0 do
      begin
        AVertex := AVertexList.Items[InnerListIndex];
        AVertex.Free;
      end;
      AVertexList.Clear;
      AVertexList.Free;
    end;
    MainVertexList.Clear;
  end;
end;

procedure ClearAndInitializeMainCellList;
var
  ListIndex, InnerListIndex: integer;
  ACellList: TList;
  ACell: TCell;
begin
  if (MainCellList = nil) then
  begin
    MainCellList := TList.Create;
  end
  else
  begin
    for ListIndex := MainCellList.Count - 1 downto 0 do
    begin
      ACellList := MainCellList.Items[ListIndex];
      for InnerListIndex := ACellList.Count - 1 downto 0 do
      begin
        ACell := ACellList.Items[InnerListIndex];
        ACell.Free;
      end;
      ACellList.Clear;
      ACellList.Free;
    end;
    MainCellList.Clear;
  end;
end;

procedure ClearAndInitializeCombinedCellList;
begin
  if (CombinedCellList = nil) then
  begin
    CombinedCellList := TList.Create;
  end
  else
  begin
    CombinedCellList.Clear;
  end;
end;

procedure ClearAndInitializeCrossRowCellsList;
var
  ListIndex: integer;
  ACellList: TList;
begin
  if CrossRowCellsList = nil then
  begin
    CrossRowCellsList := TList.Create;
  end
  else
  begin
    for ListIndex := CrossRowCellsList.Count - 1 downto 0 do
    begin
      ACellList := CrossRowCellsList.Items[ListIndex];
      ACellList.Clear;
      ACellList.Free;
    end;
    CrossRowCellsList.Clear;
  end;
end;

procedure ClearAndInitializeCrossColumnCellsList;
var
  ListIndex: integer;
  ACellList: TList;
begin
  if CrossColumnCellsList = nil then
  begin
    CrossColumnCellsList := TList.Create;
  end
  else
  begin
    for ListIndex := CrossColumnCellsList.Count - 1 downto 0 do
    begin
      ACellList := CrossColumnCellsList.Items[ListIndex];
      ACellList.Clear;
      ACellList.Free;
    end;
    CrossColumnCellsList.Clear;
  end;
end;

procedure ClearAndInitializeRowList;
begin
  if RowList = nil then
  begin
    RowList := TRealList.Create;
  end
  else
  begin
    RowList.Clear;
  end;
end;

procedure ClearAndInitializeColumnList;
begin
  if ColumnList = nil then
  begin
    ColumnList := TRealList.Create;
  end
  else
  begin
    ColumnList.Clear;
  end;
end;

procedure ClearAndInitializeRowMiddleList;
begin
  if RowMiddleList = nil then
  begin
    RowMiddleList := TRealList.Create;
  end
  else
  begin
    RowMiddleList.Clear;
  end;
end;

procedure ClearAndInitializeColumnMiddleList;
begin
  if ColumnMiddleList = nil then
  begin
    ColumnMiddleList := TRealList.Create;
  end
  else
  begin
    ColumnMiddleList.Clear;
  end;
end;

procedure ClearAndInitializeRowAndColumnLists;
begin
  ClearAndInitializeRowList;
  ClearAndInitializeColumnList;
  ClearAndInitializeRowMiddleList;
  ClearAndInitializeColumnMiddleList;
end;

procedure ClearAndInitializeAllButMainVertexLists;
begin
  ClearAndInitializeCombinedCellList;
  ClearAndInitializeCrossRowCellsList;
  ClearAndInitializeCrossColumnCellsList;
  ClearAndInitializeMainCellList;
  ClearAndInitializeMainOutsideCellsList;
  ClearAndInitializeContourLengths;
end;

procedure ClearAndInitializeMainLists;
begin
  ClearAndInitializeMainVertexList;
  ClearAndInitializeAllButMainVertexLists;
end;

end.

