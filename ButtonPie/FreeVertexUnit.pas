unit FreeVertexUnit;

interface

uses Classes, SysUtils, ANEPIE;

procedure GListFreeVertex;

procedure GListFreeVertexMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses BlockListUnit, CellVertexUnit;

procedure GListFreeVertex;
var
  ListIndex, InnerListIndex : integer;
  AVertexList : TList;
  AReal : TReal;
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
end;

procedure GListFreeVertexMMFun (const refPtX : ANE_DOUBLE_PTR      ;
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
      GListFreeVertex;
{      For ListIndex := MainVertexList.Count -1 downto 0 do
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
      end;   }
//      result :=1;
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
