unit FreeBlockUnit;

interface

uses Classes, SysUtils, ANEPIE;

procedure GListFreeBlock;

procedure GListFreeBlockMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses BlockListUnit, CellVertexUnit, CombinedListUnit, PointInsideContourUnit;

procedure GListFreeBlock;
var
  ListIndex, InnerListIndex : integer;
  AVertexList : TList;
  AReal : TReal;
  AVertex : TBL_Vertex;
  ACellList : TList ;
  ACell : TCell;
begin
  if not (RowList = nil) then
  begin
    For ListIndex := RowList.Count -1 downto 0 do
    begin
      AReal := RowList.Items[ListIndex];
      AReal.Free;
    end;
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
      AVertexList.Free;
    end;
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
      ACellList.Free;
    end;
    MainCellList.Free;
    MainCellList := nil;
  end;
{      if not (MainParameterList = nil) then
  begin
    For ListIndex := MainParameterList.Count -1 downto 0 do
    begin
      ARealList := MainParameterList.Items[ListIndex];
      For InnerListIndex := ARealList.Count -1 downto 0 do
      begin
        AReal := ARealList.Items[InnerListIndex];
        AReal.Free;
      end;
      ARealList.Clear;
      ARealList.Free;
    end;
    MainParameterList.Clear;
    MainParameterList.Free;
    MainParameterList := nil;
  end;          }
  if not (CombinedCellList = nil) then
  begin
    CombinedCellList.Free;
    CombinedCellList := nil;
  end;
  if not (CrossRowCellsList = nil) then
  begin
    For ListIndex := CrossRowCellsList.Count -1 downto 0 do
    begin
      ACellList := CrossRowCellsList.Items[ListIndex];
      ACellList.Free;
    end;
    CrossRowCellsList.Free;
    CrossRowCellsList := nil;
  end;
  if not (CrossColumnCellsList = nil)then
  begin
    For ListIndex := CrossColumnCellsList.Count -1 downto 0 do
    begin
      ACellList := CrossColumnCellsList.Items[ListIndex];
      ACellList.Free;
    end;
    CrossColumnCellsList.Free;
    CrossColumnCellsList := nil;
  end;

  ResetAreaValues;

  GridImportOK := False;
end;

procedure GListFreeBlockMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_BOOL;
begin
  try
    begin
      GListFreeBlock;
      result :=True;
    end;
  Except on Exception do
    begin
//      result := 0;
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

end.
