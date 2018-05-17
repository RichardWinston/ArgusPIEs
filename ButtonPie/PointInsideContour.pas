unit PointInsideContour;

interface

uses ANEPIE, SysUtils, Classes;

procedure GPointInsideContourMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;


implementation

uses BlockListUnit, CellVertexUnit;

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
  ListIndex : ANE_INT32;
  param2_ptr : ANE_INT32_PTR;
  X : ANE_INT32;
  param3_ptr : ANE_INT32_PTR;
  Y : ANE_INT32;
  AVertexList : TList;
  VertexIndex : integer;
  AVertex, AnotherVertex : TVertex;
  YBelow : integer;
  LowerX, HigherX : double;
  YOnLine : double;

begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      X :=  param2_ptr^;
      param3_ptr :=  param^[2];
      Y :=  param3_ptr^;
      AVertexList := MainVertexList.Items[ListIndex];
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
              result := False;
            end // if not ((AVertex.XPos = AnotherVertex.XPos) and (AVertex.YPos = AnotherVertex.YPos))
          else
            begin
              YBelow := 0;
              For VertexIndex := 1 to AVertexList.Count -1 do
              begin
                AVertex := AVertexList.Items[VertexIndex-1];
                AnotherVertex := AVertexList.Items[VertexIndex];
                if AVertex.XPos < AnotherVertex.XPos
                then
                  begin
                    LowerX := AVertex.XPos;
                    HigherX := AnotherVertex.XPos;
                  end // if AVertex.XPos < AnotherVertex.XPos
                else
                  begin
                    HigherX := AVertex.XPos;
                    LowerX := AnotherVertex.XPos;
                  end; // if AVertex.XPos < AnotherVertex.XPos else
                if (X < HigherX) and not (X < LowerX) and not (LowerX = HigherX)
                then
                  begin
                    YOnLine := (X - AVertex.XPos)/(AnotherVertex.XPos - AVertex.XPos) *
                       (AnotherVertex.YPos - AVertex.YPos) + AnotherVertex.YPos;
                    if YOnLine > Y then
                    begin
                      Inc(YBelow);
                    end;  // YOnLine > Y then
                  end; //  if (X < HigherX) and not (X < LowerX) and not (LowerX = HigherX)
              end; // For VertexIndex := 1 to AVertexList.Count -1 do
              result := Odd(YBelow);
            end; // if not ((AVertex.XPos = AnotherVertex.XPos) and (AVertex.YPos = AnotherVertex.YPos)) else
        end;  // if AVertexList.Count < 3 else
    end  // try
  except
    on Exception do
      begin
        result := False;
      end;
  end;

  ANE_BOOL_PTR(reply)^ := result;
end;

end.
