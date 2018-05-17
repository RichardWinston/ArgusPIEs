unit GetFractionUnit;

interface

uses ANEPIE, BlockListUnit, CellVertexUnit, Classes, SysUtils;

function GGetLineLength(ListIndex : ANE_INT32) : ANE_DOUBLE;

function GGetFractionOfLine(ListIndex, CellIndex : ANE_INT32) : ANE_DOUBLE;

procedure GGetFractionOfLineMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

function GGetLineLength(ListIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
  Index : Integer;
begin
  AList := MainCellList[ListIndex];
  result := 0;
  for Index := 0 to AList.Count -1 do
  begin
    ACell := AList[Index];
    result := result + ACell.SumSegmentLength;
  end;
end;

function GGetFractionOfLine(ListIndex, CellIndex : ANE_INT32) : ANE_DOUBLE;
var
  AList : TList;
  ACell : TCell;
  Index : Integer;
  TotalLength : double;

begin
  AList := MainCellList[ListIndex];
  if CellIndex = 0 then
  begin
    result := 0;
  end
  else if (CellIndex = AList.Count -1) then
  begin
    result := 1;
  end
  else
  begin

    result := 0;
    for Index := 0 to CellIndex -1 do
    begin
      ACell := AList[Index];
      result := result + ACell.SumSegmentLength;
    end;
    ACell := AList[CellIndex];
    result := result + ACell.SumSegmentLength/2;

    TotalLength := GGetLineLength(ListIndex);
{    for Index := 0 to AList.Count -1 do
    begin
      ACell := AList[Index];
      TotalLength := TotalLength + ACell.SumSegmentLength;
    end;   }

    If not (TotalLength = 0)
    then
    begin
      result := result/TotalLength;
    end
    else
    begin
      result := 0;
    end;
  end;

end;

procedure GGetFractionOfLineMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_DOUBLE;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  ListIndex : ANE_INT32;          // position in list of item .
  CellIndex : ANE_INT32;          // position in list of item .
  param : PParameter_array;

begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      ListIndex :=  param1_ptr^;
      param2_ptr :=  param^[1];
      CellIndex :=  param2_ptr^;
      result := GGetFractionOfLine(ListIndex, CellIndex );
{      AList := MainCellList[ListIndex];
      if CellIndex = 0 then
        begin
              result := 0;
        end
      else if (CellIndex = AList.Count -1) then
        begin
              result := 1;
        end
      else
        begin

          result := 0;
          for Index := 0 to CellIndex -1 do
          begin
            ACell := AList[Index];
            result := result + ACell.SumSegmentLength;
          end;
          ACell := AList[CellIndex];
          result := result + ACell.SumSegmentLength/2;

          TotalLength := 0;
          for Index := 0 to AList.Count -1 do
          begin
            ACell := AList[Index];
            TotalLength := TotalLength + ACell.SumSegmentLength;
          end;

          If not (TotalLength = 0)
          then
            begin
              result := result/TotalLength;
            end
          else
            begin
              result := 0;
            end;
        end;

   //   result := AVertex.XPos;

      }
    end;
  Except on Exception do
    begin
      Inc(ErrorCount);
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

end.
