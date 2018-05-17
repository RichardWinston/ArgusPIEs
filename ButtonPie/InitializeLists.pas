unit InitializeLists;

interface

Procedure ClearAndInitializeMainVertexList;
Procedure ClearAndInitializeMainCellList;
Procedure ClearAndInitializeCombinedCellList;
Procedure ClearAndInitializeCrossRowCellsList;
Procedure ClearAndInitializeCrossColumnCellsList;

Procedure ClearAndInitializeRowList;
Procedure ClearAndInitializeColumnList;
Procedure ClearAndInitializeRowMiddleList;
Procedure ClearAndInitializeColumnMiddleList;

Procedure ClearAndInitializeRowAndColumnLists;

Procedure ClearAndInitializeAllButMainVertexLists;
Procedure ClearAndInitializeMainLists;

implementation

uses BlockListUnit, CombinedListUnit, CellVertexUnit, Classes;

Procedure ClearAndInitializeMainVertexList;
var
  ListIndex, InnerListIndex : integer;
  AVertexList : TList;
  AVertex: TBL_Vertex;
//  ACellList : TList;
//  ACell : TCell;
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
end;

Procedure ClearAndInitializeMainCellList;
var
  ListIndex, InnerListIndex : integer;
//  AVertexList : TList;
//  AVertex: TVertex;
  ACellList : TList;
  ACell : TCell;
begin
          if (MainCellList = nil)
          then
            begin
              MainCellList := TList.Create;
//              ShowMessage('Created Main CellList');
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
end;

Procedure ClearAndInitializeCombinedCellList;
begin
          if (CombinedCellList = nil)
          then
            begin
              CombinedCellList := TList.Create;
            end
          else
            begin
              CombinedCellList.Clear;
            end;
end;

Procedure ClearAndInitializeCrossRowCellsList;
var
  ListIndex  : integer;
  ACellList : TList;
begin
      if CrossRowCellsList = nil
      then
        begin
          CrossRowCellsList := TList.Create;
        end
      else
        begin
          For ListIndex := CrossRowCellsList.Count -1 downto 0 do
          begin
            ACellList := CrossRowCellsList.Items[ListIndex];
            ACellList.Clear;
            ACellList.Free;
          end;
          CrossRowCellsList.Clear;
        end;
end;

Procedure ClearAndInitializeCrossColumnCellsList;
var
  ListIndex : integer;
  ACellList : TList;
begin
      if CrossColumnCellsList = nil
      then
        begin
          CrossColumnCellsList := TList.Create;
        end
      else
        begin
          For ListIndex := CrossColumnCellsList.Count -1 downto 0 do
          begin
            ACellList := CrossColumnCellsList.Items[ListIndex];
            ACellList.Clear;
            ACellList.Free;
          end;
          CrossColumnCellsList.Clear;
        end;
end;

Procedure ClearAndInitializeRowList;
var
  ListIndex  : integer;
  AReal : TReal;
begin
      if RowList = nil
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
end;

Procedure ClearAndInitializeColumnList;
var
  ListIndex : integer;
  AReal : TReal;
begin
      if ColumnList = nil
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
end;

Procedure ClearAndInitializeRowMiddleList;
var
  ListIndex  : integer;
  AReal : TReal;
begin
      if RowMiddleList = nil
      then
        begin
          RowMiddleList := TList.Create;
        end
      else
        begin
          For ListIndex := RowMiddleList.Count -1 downto 0 do
          begin
            AReal := RowMiddleList.Items[ListIndex];
            AReal.Free;
          end;
          RowMiddleList.Clear;
        end;
end;

Procedure ClearAndInitializeColumnMiddleList;
var
  ListIndex : integer;
  AReal : TReal;
begin
      if ColumnMiddleList = nil
      then
        begin
          ColumnMiddleList := TList.Create;
        end
      else
        begin
          For ListIndex := ColumnMiddleList.Count -1 downto 0 do
          begin
            AReal := ColumnMiddleList.Items[ListIndex];
            AReal.Free;
          end;
          ColumnMiddleList.Clear;
        end;
end;

Procedure ClearAndInitializeRowAndColumnLists;
begin
  ClearAndInitializeRowList;
  ClearAndInitializeColumnList;
  ClearAndInitializeRowMiddleList;
  ClearAndInitializeColumnMiddleList;
end;

Procedure ClearAndInitializeAllButMainVertexLists;
begin
  ClearAndInitializeCombinedCellList;
  ClearAndInitializeCrossRowCellsList;
  ClearAndInitializeCrossColumnCellsList;
  ClearAndInitializeMainCellList;

end;

Procedure ClearAndInitializeMainLists;
begin
  ClearAndInitializeMainVertexList;
  ClearAndInitializeAllButMainVertexLists;

end;

end.
