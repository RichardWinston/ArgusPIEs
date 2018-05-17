unit MOC3DGridFunctions;

interface

{MOC3DGridFunctions defines PIE functions that define the edges of the
 MOC3D subgrid.}

uses SysUtils, AnePIE, Dialogs;

procedure GetMocRow1 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMocRow2 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMocCol1 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GetMocCol2 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

function fMOCROW1(funHandle : ANE_PTR; layerHandle : ANE_PTR;
  NumRows : ANE_INT32) : ANE_INT32;
function fMOCROW2(funHandle : ANE_PTR; layerHandle : ANE_PTR;
  NumRows : ANE_INT32) : ANE_INT32;
function fMOCCOL1(funHandle : ANE_PTR; layerHandle : ANE_PTR;
  NumColumns : ANE_INT32) : ANE_INT32;
function fMOCCOL2(funHandle : ANE_PTR; layerHandle : ANE_PTR;
  NumColumns : ANE_INT32) : ANE_INT32;

implementation

uses ANECB, Variables, ModflowUnit, ParamArrayUnit,
  ANE_LayerUnit, ArgusFormUnit, ContourListUnit, UtilityFunctions, RunUnit;


var
  MinX, MinY, MaxX, MaxY : double;
  ContoursChanged : boolean;
  OldGridAngle : ANE_DOUBLE;
  OldContours : string;
  PreviousResult : boolean;
  PreviousMOCROW1,PreviousMOCROW2,PreviousMOCCOL1,PreviousMOCCOL2 : integer;
  Frozen : ANE_BOOL;

function GetTransportGridContours : boolean;
var
  TransportGridContours : TContourList;
  layerHandle : ANE_PTR;
  InfoText : ANE_STR;
  InfoTextString : String;
  AContour : TContour;
  APoint : TZoomPoint;
  ContourIndex, PointIndex : integer;
  FirstPointFound : boolean;
  GridAngle : ANE_DOUBLE;
  X, Y : double;
begin
// begin bug demonstration.
// If these lines are included Argus ONE will crash. These lines are not
// needed for the function to get the result and have no effect except to
// make Argus ONE crash.
{   layerHandle := ANE_LayerGetHandleByName(frmMODFLOW.CurrentModelHandle,
     PChar(ModflowTypes.GetMOCTransSubGridLayerType.ANE_LayerName ));

   StringToEvaluate := 'IsLayerEmpty()';

   ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
           layerHandle, kPIEBoolean, PChar(StringToEvaluate),@ABoolean );

  result := ABoolean;  }
// end bug demonstration.

      GetGridAngle(frmMODFLOW.CurrentModelHandle,
        ModflowTypes.GetGridLayerType.ANE_LayerName,layerHandle,GridAngle);

      layerHandle := ANE_LayerGetHandleByName(frmMODFLOW.CurrentModelHandle,
        PChar(ModflowTypes.GetMOCTransSubGridLayerType.ANE_LayerName ));

      if layerHandle = nil then
      begin
        result := False;
      end
      else
      begin

        ANE_ExportTextFromOtherLayer(frmMODFLOW.CurrentModelHandle, layerHandle,
          @InfoText );
        InfoTextString := String(InfoText);

        ContoursChanged := (InfoTextString <> OldContours)
          or (OldGridAngle <> GridAngle);
        OldContours := InfoTextString;
        OldGridAngle := GridAngle;

        if not ContoursChanged then
        begin
          result := PreviousResult;
        end
        else
        begin
          TransportGridContours := TContourList.Create;
          try
            APoint := nil;
            FirstPointFound := False;
            TransportGridContours.ReadContours(InfoTextString);
            for ContourIndex := 0 to TransportGridContours.Count -1 do
            begin
              AContour := TransportGridContours.Items[ContourIndex];
              For PointIndex := 0 to AContour.Count -1 do
              begin
                APoint := AContour.PointValues[PointIndex];
                FirstPointFound := True;
                break;
              end;
              if FirstPointFound then break;
            end;
            if APoint = nil then
            begin
              result := False;
            end
            else
            begin
              result := True;
              X := APoint.X;
              Y := APoint.Y;
              RotatePointsToGrid( X, Y, GridAngle );
              MinX := X;
              MinY := Y;
              MaxX := X;
              MaxY := Y;
              for ContourIndex := 0 to TransportGridContours.Count -1 do
              begin
                AContour := TransportGridContours.Items[ContourIndex];
                For PointIndex := 0 to AContour.Count -1 do
                begin
                  APoint := AContour.PointValues[PointIndex];
                  X := APoint.X;
                  Y := APoint.Y;
                  RotatePointsToGrid( X, Y, GridAngle );
                  If MaxX < X then MaxX := X;
                  If MaxY < Y then MaxY := Y;
                  If MinX > X then MinX := X;
                  If MinY > Y then MinY := Y;
                end;
              end;
            end;
          finally
            TransportGridContours.Free;
          end;
        end;
      end;
      PreviousResult := result;

end;

function GetRowPosition(layerHandle: ANE_PTR; RowIndex : Integer) : double;
var
  StringtoEvaluate : string;
begin

      StringtoEvaluate := 'NthRowPos(' + IntToStr(RowIndex) + ')' ;

      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
             kPIEFloat, PChar(StringtoEvaluate), @result );

end;

function GetColumnPosition(layerHandle: ANE_PTR; ColumnIndex : Integer) : double;
var
  StringtoEvaluate : string;
begin
      StringtoEvaluate := 'NthColumnPos(' + IntToStr(ColumnIndex) + ')' ;

      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
             kPIEFloat, PChar(StringtoEvaluate), @result );
end;

function fMOCROW1(funHandle : ANE_PTR; layerHandle : ANE_PTR;
  NumRows : ANE_INT32) : ANE_INT32;
var
  RowPosition, AnotherRowPosition : ANE_DOUBLE;
  distanceFromEdge : ANE_DOUBLE;
  EdgeOfGrid : ANE_DOUBLE;
  StringtoEvaluate : string;
  FirstRow, LastRow, CurrentRow, LowerRow : integer;
  FirstRowPosition, LastRowPosition : double;
  PreviousOK : boolean;

begin
  if not GetTransportGridContours then
  begin
    result := 1;
  end
  else
  begin
    StringtoEvaluate := 'NthRowPos(' + IntToStr(NumRows) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @AnotherRowPosition );

    StringtoEvaluate := 'NthRowPos(' + IntToStr(0) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @RowPosition );

    EdgeOfGrid := RowPosition;

    if AnotherRowPosition > RowPosition then
    begin
      distanceFromEdge := MinY -RowPosition;
    end
    else
    begin
      distanceFromEdge := RowPosition - MaxY;
    end;

    if distanceFromEdge < 0 then
    begin
      result := 1;
    end
    else
    begin
      if PreviousMOCROW1 = 0 then
      begin
        PreviousOK := False;
      end
      else
      begin
        RowPosition := GetRowPosition(layerHandle, PreviousMOCROW1-1);
        If abs(RowPosition-EdgeOfGrid) - distanceFromEdge > 0 then
        begin
          AnotherRowPosition := GetRowPosition(layerHandle, PreviousMOCROW1-2);
          PreviousOK := not (abs(AnotherRowPosition-EdgeOfGrid) - distanceFromEdge > 0);
          LowerRow := PreviousMOCROW1-1;
        end
        else
        begin
          AnotherRowPosition := GetRowPosition(layerHandle, PreviousMOCROW1);
          PreviousOK := (abs(AnotherRowPosition-EdgeOfGrid) - distanceFromEdge > 0);
          LowerRow := PreviousMOCROW1;
        end;
      end;


      if PreviousOK then
      begin
        If abs((RowPosition+AnotherRowPosition)/2-EdgeOfGrid)
          - distanceFromEdge > 0 then
        begin
          result := LowerRow;
        end
        else
        begin
          result := LowerRow+1;
        end;
      end
      else
      begin
        FirstRow := 0;
        LastRow := NumRows;
        While LastRow - FirstRow > 1 do
        begin
          CurrentRow := Round((LastRow + FirstRow)/2);
          RowPosition := GetRowPosition(layerHandle, CurrentRow);
          If abs(RowPosition-EdgeOfGrid) - distanceFromEdge > 0 then
          begin
            LastRow := CurrentRow;
          end
          else
          begin
            FirstRow := CurrentRow;
          end;
        end;
        FirstRowPosition := GetRowPosition(layerHandle, FirstRow);
        LastRowPosition := GetRowPosition(layerHandle, LastRow);
        If abs((FirstRowPosition+LastRowPosition)/2-EdgeOfGrid)
          - distanceFromEdge > 0 then
        begin
          result := FirstRow+1;
        end
        else
        begin
          result := LastRow+1;
        end;
      end;
    end;
  end;
  PreviousMOCROW1 := result;
end;


procedure GetMocRow1 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  NumRows : ANE_INT32;
  layerHandle : ANE_PTR;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param2_ptr : ANE_INT32_PTR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  Row, Column : ANE_INT32;
begin
  if Exporting then
  begin
    result := PreviousMOCROW1;
  end
  else if EditWindowOpen then
  begin
    MessageDlg('You can not export a project or evaluate the' +
    ' MOC3D subgrid if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
        as ModflowTypes.GetModflowFormType;

      layerHandle := ANE_LayerGetHandleByName(frmMODFLOW.CurrentModelHandle,
        PChar(ModflowTypes.GetGridLayerType.ANE_LayerName) ) ;

      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
               kPIEInteger, 'NumRows()', @NumRows );

      Frozen := False;
      param := @parameters^;
      if numParams > 0 then
      begin
        param1_ptr :=  param^[0];
        Column :=  param1_ptr^;
        if numParams > 1 then
        begin
          param2_ptr :=  param^[1];
          Row :=  param2_ptr^;
          Frozen := not ((Row = 1) or (Row = NumRows)) or (Column <> 1)
        end
      end
      else
      begin
        Frozen := False;
      end;

      if Frozen and not (PreviousMOCROW1 = 0) then
      begin
        result := PreviousMOCROW1
      end
      else
      begin
        result := fMOCROW1(funHandle,layerHandle, NumRows);
      end;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_INT32_PTR(reply)^ := result;
end;

function fMOCROW2(funHandle : ANE_PTR; layerHandle : ANE_PTR;
  NumRows : ANE_INT32) : ANE_INT32;
var
  RowPosition, AnotherRowPosition : ANE_DOUBLE;
  EdgeOfGrid : ANE_DOUBLE;
  distanceFromEdge : ANE_DOUBLE;
  StringtoEvaluate : string;
  FirstRow, LastRow, CurrentRow, LowerRow : integer;
  FirstRowPosition, LastRowPosition : double;
  PreviousOK : boolean;
begin
  if not GetTransportGridContours then
  begin
    result := NumRows;
  end
  else
  begin
    StringtoEvaluate := 'NthRowPos(' + IntToStr(0) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @AnotherRowPosition );

    StringtoEvaluate := 'NthRowPos(' + IntToStr(NumRows) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @RowPosition );

    EdgeOfGrid := RowPosition;

    if RowPosition > AnotherRowPosition then
    begin
      distanceFromEdge := RowPosition - MaxY;
    end
    else
    begin
      distanceFromEdge := MinY - RowPosition;
    end;

    if distanceFromEdge < 0 then
    begin
      result := NumRows;
    end
    else
    begin
      if PreviousMOCROW2 = 0 then
      begin
        PreviousOK := False;
      end
      else
      begin
        RowPosition := GetRowPosition(layerHandle, PreviousMOCROW2);
        If abs(RowPosition-EdgeOfGrid) - distanceFromEdge > 0 then
        begin
          AnotherRowPosition := GetRowPosition(layerHandle, PreviousMOCROW2+1);
          PreviousOK := not (abs(AnotherRowPosition-EdgeOfGrid) - distanceFromEdge > 0);
          LowerRow := PreviousMOCROW2+1;
        end
        else
        begin
          AnotherRowPosition := GetRowPosition(layerHandle, PreviousMOCROW2-1);
          PreviousOK := (abs(AnotherRowPosition-EdgeOfGrid) - distanceFromEdge > 0);
          LowerRow := PreviousMOCROW2;
        end;
      end;


      if PreviousOK then
      begin
        If abs((RowPosition+AnotherRowPosition)/2-EdgeOfGrid)
          - distanceFromEdge > 0 then
        begin
          result := LowerRow;
        end
        else
        begin
          result := LowerRow-1;
        end;
      end
      else
      begin
        FirstRow := 0;
        LastRow := NumRows;
        While LastRow - FirstRow > 1 do
        begin
          CurrentRow := Round((LastRow + FirstRow)/2);
          RowPosition := GetRowPosition(layerHandle, CurrentRow);
          If abs(RowPosition-EdgeOfGrid) - distanceFromEdge > 0 then
          begin
            FirstRow := CurrentRow;
          end
          else
          begin
            LastRow := CurrentRow;
          end;
        end;
        FirstRowPosition := GetRowPosition(layerHandle, FirstRow);
        LastRowPosition := GetRowPosition(layerHandle, LastRow);
        If abs((FirstRowPosition+LastRowPosition)/2-EdgeOfGrid)
          - distanceFromEdge > 0 then
        begin
          result := FirstRow+1;
        end
        else
        begin
          result := FirstRow;
        end;
      end;
    end;
  end;
  PreviousMOCROW2 := result;
end;


procedure GetMocRow2 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  NumRows : ANE_INT32;
  layerHandle : ANE_PTR;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;  
  param2_ptr : ANE_INT32_PTR;
  Row, Column : ANE_INT32;
begin
  if Exporting then
  begin
    result := PreviousMOCROW2;
  end
  else if EditWindowOpen then
  begin
    MessageDlg('You can not export a project or evaluate the' +
    ' MOC3D subgrid if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
        as ModflowTypes.GetModflowFormType;

      layerHandle := ANE_LayerGetHandleByName(frmMODFLOW.CurrentModelHandle,
        PChar(ModflowTypes.GetGridLayerType.ANE_LayerName) ) ;

      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
               kPIEInteger, 'NumRows()', @NumRows );

      Frozen := False;
      param := @parameters^;
      if numParams > 0 then
      begin
        param1_ptr :=  param^[0];
        Column :=  param1_ptr^;
        if numParams > 1 then
        begin
          param2_ptr :=  param^[1];
          Row :=  param2_ptr^;
          Frozen := not ((Row = PreviousMOCROW1) or (Row = 1) or (Row = NumRows)) or (Column <> 1)
        end
      end
      else
      begin
        Frozen := False;
      end;
      if Frozen and not (PreviousMOCROW2 = 0) then
      begin
        result := PreviousMOCROW2;
      end
      else
      begin
        result := fMOCROW2(funHandle, layerHandle, NumRows);
      end;

      ANE_INT32_PTR(reply)^ := result;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
end;

function fMOCCOL1(funHandle : ANE_PTR; layerHandle : ANE_PTR;
  NumColumns : ANE_INT32) : ANE_INT32;
var
  ColPosition, AnotherColumn : ANE_DOUBLE;
  EdgeOfGrid : ANE_DOUBLE;
  StringtoEvaluate : string;
  distanceFromEdge : ANE_DOUBLE;
  FirstColumn, LastColumn, CurrentColumn, LowerColumn : integer;
  FirstColumnPosition, LastColumnPosition, AnotherColPosition : double;
  PreviousOK : boolean;
begin
  if not GetTransportGridContours then
  begin
    result := 1;
  end
  else
  begin

    StringtoEvaluate := 'NthColumnPos(' + IntToStr(NumColumns) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @AnotherColumn );

    StringtoEvaluate := 'NthColumnPos(' + IntToStr(0) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @ColPosition );

    EdgeOfGrid := ColPosition;

    If AnotherColumn > ColPosition then
    begin
      distanceFromEdge := MinX - ColPosition;
    end
    else
    begin
      distanceFromEdge := ColPosition - MaxX;
    end;

    if distanceFromEdge < 0 then
    begin
      result := 1;
    end
    else
    begin
      if PreviousMOCCOL1 = 0 then
      begin
        PreviousOK := False;
      end
      else
      begin
        ColPosition := GetColumnPosition(layerHandle, PreviousMOCCOL1-1);
        If abs(ColPosition-EdgeOfGrid) - distanceFromEdge > 0 then
        begin
          AnotherColPosition := GetColumnPosition(layerHandle, PreviousMOCCOL1-2);
          PreviousOK := not (abs(AnotherColPosition-EdgeOfGrid) - distanceFromEdge > 0);
          LowerColumn := PreviousMOCCOL1-1;
        end
        else
        begin
          AnotherColPosition := GetColumnPosition(layerHandle, PreviousMOCCOL1);
          PreviousOK := (abs(AnotherColPosition-EdgeOfGrid) - distanceFromEdge > 0);
          LowerColumn := PreviousMOCCOL1;
        end;
      end;


      if PreviousOK then
      begin
        If abs((ColPosition+AnotherColPosition)/2-EdgeOfGrid)
          - distanceFromEdge > 0 then
        begin
          result := LowerColumn;
        end
        else
        begin
          result := LowerColumn+1;
        end;
      end
      else
      begin
        FirstColumn := 0;
        LastColumn := NumColumns;
        While LastColumn - FirstColumn > 1 do
        begin
          CurrentColumn := Round((LastColumn + FirstColumn)/2);
          ColPosition := GetColumnPosition(layerHandle, CurrentColumn);
          If abs(ColPosition-EdgeOfGrid) - distanceFromEdge > 0 then
          begin
            LastColumn := CurrentColumn;
          end
          else
          begin
            FirstColumn := CurrentColumn;
          end;
        end;
        FirstColumnPosition := GetColumnPosition(layerHandle, FirstColumn);
        LastColumnPosition := GetColumnPosition(layerHandle, LastColumn);
        If abs((FirstColumnPosition+LastColumnPosition)/2-EdgeOfGrid)
          - distanceFromEdge > 0 then
        begin
          result := FirstColumn+1;
        end
        else
        begin
          result := LastColumn+1;
        end;
      end;
    end;
  end;
  PreviousMOCCOL1 := result;
end;

procedure GetMocCol1 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  NumColumns, NumRows : ANE_INT32;
  layerHandle : ANE_PTR;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  Row, Column : ANE_INT32;
begin
  if Exporting then
  begin
    result := PreviousMOCCOL1;
  end
  else if EditWindowOpen then
  begin
    MessageDlg('You can not export a project or evaluate the' +
    ' MOC3D subgrid if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
        as ModflowTypes.GetModflowFormType;

      layerHandle := ANE_LayerGetHandleByName(frmMODFLOW.CurrentModelHandle,
        PChar(ModflowTypes.GetGridLayerType.ANE_LayerName) ) ;

      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
               kPIEInteger, 'NumRows()', @NumRows );

          ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
                   kPIEInteger, 'NumColumns()', @NumColumns );

      Frozen := False;
      param := @parameters^;
      if numParams > 0 then
      begin
        param1_ptr :=  param^[0];
        Column :=  param1_ptr^;
        if numParams > 1 then
        begin
          param2_ptr :=  param^[1];
          Row :=  param2_ptr^;
          Frozen := not ((Row = PreviousMOCROW1) or (Row = 1) or (Row = NumRows) or (Row = PreviousMOCROW2) )
            or not ((Column = 1) or (Column = NumColumns))
        end
      end
      else
      begin
        Frozen := False;
      end;
      if Frozen and not (PreviousMOCCol1 = 0) then
      begin
        result := PreviousMOCCol1;
      end
      else
      begin
        result := fMOCCOL1(funHandle, layerHandle, NumColumns);
      end;

    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_INT32_PTR(reply)^ := result;
end;

function fMOCCOL2(funHandle : ANE_PTR; layerHandle : ANE_PTR;
  NumColumns : ANE_INT32) : ANE_INT32;
var
  ColPosition, AnotherColumn : ANE_DOUBLE;
  EdgeOfGrid : ANE_DOUBLE;
  StringtoEvaluate : string;
  distanceFromEdge : ANE_DOUBLE;
  FirstColumn, LastColumn, CurrentColumn, LowerColumn : integer;
  FirstColumnPosition, LastColumnPosition, AnotherColPosition : double;
  PreviousOK : boolean;
begin
  if not GetTransportGridContours then
  begin
    result := NumColumns;
  end
  else
  begin
    StringtoEvaluate := 'NthColumnPos(' + IntToStr(0) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @AnotherColumn );

    StringtoEvaluate := 'NthColumnPos(' + IntToStr(NumColumns) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @ColPosition );

    EdgeOfGrid := ColPosition;

    if ColPosition > AnotherColumn then
    begin
      distanceFromEdge := ColPosition - MaxX;
    end
    else
    begin
      distanceFromEdge := MinX - ColPosition;
    end;

    if distanceFromEdge < 0 then
    begin
      result := NumColumns;
    end
    else
    begin
      if PreviousMOCCOL2 = 0 then
      begin
        PreviousOK := False;
      end
      else
      begin
        ColPosition := GetColumnPosition(layerHandle, PreviousMOCCOL2);
        If abs(ColPosition-EdgeOfGrid) - distanceFromEdge > 0 then
        begin
          AnotherColPosition := GetColumnPosition(layerHandle, PreviousMOCCOL2+1);
          PreviousOK := not (abs(AnotherColPosition-EdgeOfGrid) - distanceFromEdge > 0);
          LowerColumn := PreviousMOCCOL2+1;
        end
        else
        begin
          AnotherColPosition := GetColumnPosition(layerHandle, PreviousMOCCOL2-1);
          PreviousOK := (abs(AnotherColPosition-EdgeOfGrid) - distanceFromEdge > 0);
          LowerColumn := PreviousMOCCOL2;
        end;
      end;


      if PreviousOK then
      begin
        If abs((ColPosition+AnotherColPosition)/2-EdgeOfGrid)
          - distanceFromEdge > 0 then
        begin
          result := LowerColumn;
        end
        else
        begin
          result := LowerColumn-1;
        end;
      end
      else
      begin
        FirstColumn := 0;
        LastColumn := NumColumns;
        While LastColumn - FirstColumn > 1 do
        begin
          CurrentColumn := Round((LastColumn + FirstColumn)/2);
          ColPosition := GetColumnPosition(layerHandle, CurrentColumn);
          If abs(ColPosition-EdgeOfGrid) - distanceFromEdge > 0 then
          begin
            FirstColumn := CurrentColumn;
          end
          else
          begin
            LastColumn := CurrentColumn;
          end;
        end;
        FirstColumnPosition := GetColumnPosition(layerHandle, FirstColumn);
        LastColumnPosition := GetColumnPosition(layerHandle, LastColumn);
        If abs((FirstColumnPosition+LastColumnPosition)/2-EdgeOfGrid)
          - distanceFromEdge > 0 then
        begin
          result := FirstColumn+1;
        end
        else
        begin
          result := FirstColumn;
        end;
      end;
    end;
  end;
  PreviousMOCCOL2 := result;
end;

procedure GetMocCol2 (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				funHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  Result : ANE_INT32;
  NumColumns, NumRows : ANE_INT32;
  layerHandle : ANE_PTR;
  param : PParameter_array;
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR;
  Row, Column : ANE_INT32;
begin
  if Exporting then
  begin
    result := PreviousMOCCOL2;
  end
  else if EditWindowOpen then
  begin
    MessageDlg('You can not export a project or evaluate the' +
    ' MOC3D subgrid if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
        as ModflowTypes.GetModflowFormType;

      layerHandle := ANE_LayerGetHandleByName(frmMODFLOW.CurrentModelHandle,
        PChar(ModflowTypes.GetGridLayerType.ANE_LayerName) ) ;

      ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
               kPIEInteger, 'NumRows()', @NumRows );

        ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
                 kPIEInteger, 'NumColumns()', @NumColumns );

      Frozen := False;
      param := @parameters^;
      if numParams > 0 then
      begin
        param1_ptr :=  param^[0];
        Column :=  param1_ptr^;
        if numParams > 1 then
        begin
          param2_ptr :=  param^[1];
          Row :=  param2_ptr^;
          Frozen := not ((Row = PreviousMOCROW1) or (Row = 1) or (Row = NumRows) or (Row = PreviousMOCROW2))
            or not ((Column = PreviousMOCCol1) or (Column = 1) or (Column = NumColumns))
        end
      end
      else
      begin
        Frozen := False;
      end;
      if Frozen and not (PreviousMOCCol2 = 0) then
      begin
        result := PreviousMOCCol2;
      end
      else
      begin
        result := fMOCCOL2(funHandle, layerHandle, NumColumns);
      end;
    end;
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else
  ANE_INT32_PTR(reply)^ := result;
end;

initialization
begin
  OldContours := '';
  OldGridAngle := 0;
  PreviousResult := False;
end;

end.
