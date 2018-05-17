unit MOC3DGridFunctions;

interface

{MOC3DGridFunctions defines PIE functions that define the edges of the
 MOC3D subgrid.}

uses SysUtils, Classes, AnePIE, Dialogs;

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
  ANE_LayerUnit, ArgusFormUnit, ContourListUnit, UtilityFunctions, RunUnit,
  OptionsUnit, RealListUnit;


var
  MinX, MinY, MaxX, MaxY : double;
  PreviousResult : boolean;
  PreviousMOCROW1,PreviousMOCROW2,PreviousMOCCOL1,PreviousMOCCOL2 : integer;
  Frozen : ANE_BOOL;

function GetTransportGridContours : boolean;
var
  layerHandle, GridLayerHandle : ANE_PTR;
  ContourIndex : ANE_INT32;
  GridAngle : ANE_DOUBLE;
  X, Y : ANE_DOUBLE;
  SubgridLayerOptions : TLayerOptions;
  Contourcount : integer;
  AContour : TContourObjectOptions;
  XLocations, YLocations : TRealList;
  NodeIndex : ANE_INT32;
  LayerName : String;
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


  XLocations := nil;
  YLocations := nil;
  try
    LayerName := ModflowTypes.GetMOCTransSubGridLayerType.WriteNewRoot;
    layerHandle := GetLayerHandle(frmMODFLOW.CurrentModelHandle,LayerName);

    if layerHandle = nil then
    begin
      result := False;
    end
    else
    begin
      GetGridAngle(frmMODFLOW.CurrentModelHandle,
        ModflowTypes.GetGridLayerType.ANE_LayerName,GridLayerHandle,GridAngle);

      SubgridLayerOptions := TLayerOptions.Create(layerHandle);
      try
        Contourcount := SubgridLayerOptions.NumObjects
          (frmMODFLOW.CurrentModelHandle, pieContourObject);
        if Contourcount = 0 then
        begin
          result := False;
          Exit;
        end
        else
        begin
          XLocations := TRealList.Create;
          YLocations := TRealList.Create;
          for ContourIndex := 0 to Contourcount -1 do
          begin
            AContour := TContourObjectOptions.Create
              (frmMODFLOW.CurrentModelHandle, layerHandle, ContourIndex);
            try
              for NodeIndex := 0 to AContour.
                NumberOfNodes(frmMODFLOW.CurrentModelHandle) -1 do
              begin
                AContour.GetNthNodeLocation(frmMODFLOW.CurrentModelHandle,
                  X, Y, NodeIndex);
                XLocations.Add(X);
                YLocations.Add(Y);
              end;
            finally
              AContour.Free;
            end;
          end;
        end;
      finally
        SubgridLayerOptions.Free(frmMODFLOW.CurrentModelHandle);
      end;

      result := True;
      Assert((XLocations.Count > 0) and (YLocations.Count > 0)
        and (XLocations.Count = YLocations.Count));
      if GridAngle <> 0 then
      begin
        For NodeIndex := 0 to XLocations.Count -1 do
        begin
          X := XLocations[NodeIndex];
          Y := YLocations[NodeIndex];
          RotatePointsToGrid( X, Y, GridAngle );
          XLocations[NodeIndex] := X;
          YLocations[NodeIndex] := Y;
        end;
      end;
      MinX := XLocations[0];
      MinY := YLocations[0];
      MaxX := MinX;
      MaxY := MinY;
      For NodeIndex := 1 to XLocations.Count -1 do
      begin
        X := XLocations[NodeIndex];
        Y := YLocations[NodeIndex];
        If MaxX < X then MaxX := X;
        If MaxY < Y then MaxY := Y;
        If MinX > X then MinX := X;
        If MinY > Y then MinY := Y;
      end;

    end;
    PreviousResult := result;
  finally
    XLocations.Free;
    YLocations.Free;
  end;
end;

function GetRowPosition(layerHandle: ANE_PTR; RowIndex : Integer) : double;
var
  StringtoEvaluate : string;
  STR : ANE_STR;
begin
  StringtoEvaluate := 'NthRowPos(' + IntToStr(RowIndex) + ')' ;

  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, STR, @result );
    ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
  finally
    FreeMem(STR);
  end;
end;

function GetColumnPosition(layerHandle: ANE_PTR; ColumnIndex : Integer) : double;
var
  StringtoEvaluate : string;
  STR : ANE_STR;
begin
  StringtoEvaluate := 'NthColumnPos(' + IntToStr(ColumnIndex) + ')' ;

  GetMem(STR, Length(StringToEvaluate) + 1);
  try
    StrPCopy(STR,StringToEvaluate);
    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, STR, @result );
    ANE_ProcessEvents(frmMODFLOW.CurrentModelHandle);
  finally
    FreeMem(STR);
  end;
end;

function fMOCROW1(funHandle : ANE_PTR; layerHandle : ANE_PTR;
  NumRows : ANE_INT32) : ANE_INT32;
var
  RowPosition, AnotherRowPosition : ANE_DOUBLE;
  distanceFromEdge : ANE_DOUBLE;
  EdgeOfGrid : ANE_DOUBLE;
  FirstRow, LastRow, CurrentRow, LowerRow : integer;
  FirstRowPosition, LastRowPosition : double;
  PreviousOK : boolean;
begin
  result := 1;
  if not GetTransportGridContours then
  begin
    result := 1;
  end
  else
  begin
    LowerRow := -1;
    AnotherRowPosition := GetRowPosition(layerHandle,NumRows);

    RowPosition := GetRowPosition(layerHandle,0);

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
  param1_ptr : ANE_INT32_PTR;
  param2_ptr : ANE_INT32_PTR; 
  Row, Column : ANE_INT32;
  LayerName : string;
begin
  result := PreviousMOCROW1;
  try
    if Exporting then
    begin
      result := PreviousMOCROW1;
    end
    else if EditWindowOpen then
    begin
      Beep;
  {    MessageDlg('You can not export a project or evaluate the' +
      ' solute-transport subgrid if an edit box is open. Try again after'
      + ' correcting this problems.', mtError, [mbOK], 0); }
    end
    else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try  // try 1
      begin

        frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
          as ModflowTypes.GetModflowFormType;

        LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
        try
          layerHandle := GetLayerHandle(frmMODFLOW.CurrentModelHandle,LayerName);
        except
          Exit;
        end;

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
  finally
    ANE_INT32_PTR(reply)^ := result;
  end
end;

function fMOCROW2(funHandle : ANE_PTR; layerHandle : ANE_PTR;
  NumRows : ANE_INT32) : ANE_INT32;
var
  RowPosition, AnotherRowPosition : ANE_DOUBLE;
  EdgeOfGrid : ANE_DOUBLE;
  distanceFromEdge : ANE_DOUBLE;
//  StringtoEvaluate : string;
  FirstRow, LastRow, CurrentRow, LowerRow : integer;
  FirstRowPosition, LastRowPosition : double;
  PreviousOK : boolean;
begin
  result := NumRows;
  if not GetTransportGridContours then
  begin
    result := NumRows;
  end
  else
  begin
    LowerRow := -1;
{    StringtoEvaluate := 'NthRowPos(' + IntToStr(0) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @AnotherRowPosition ); }
    AnotherRowPosition := GetRowPosition(layerHandle,0);

{    StringtoEvaluate := 'NthRowPos(' + IntToStr(NumRows) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @RowPosition ); }
    RowPosition := GetRowPosition(layerHandle,NumRows);

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
  LayerName : string;
begin
  result := PreviousMOCROW2;
  try
    if Exporting then
    begin
      result := PreviousMOCROW2;
    end
    else if EditWindowOpen then
    begin
      Beep;
  {    MessageDlg('You can not export a project or evaluate the' +
      ' solute-transport subgrid if an edit box is open. Try again after'
      + ' correcting this problems.', mtError, [mbOK], 0);}
    end
    else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try  // try 1
      begin

        frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
          as ModflowTypes.GetModflowFormType;

        LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
        try
          layerHandle := GetLayerHandle(frmMODFLOW.CurrentModelHandle,LayerName);
        except
          Exit;
        end;
        layerHandle := GetLayerHandle(frmMODFLOW.CurrentModelHandle,LayerName);

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


      end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end; // try 1
    end; // if EditWindowOpen else
  finally
    ANE_INT32_PTR(reply)^ := result;
  end;
end;

function fMOCCOL1(funHandle : ANE_PTR; layerHandle : ANE_PTR;
  NumColumns : ANE_INT32) : ANE_INT32;
var
  ColPosition, AnotherColumn : ANE_DOUBLE;
  EdgeOfGrid : ANE_DOUBLE;
//  StringtoEvaluate : string;
  distanceFromEdge : ANE_DOUBLE;
  FirstColumn, LastColumn, CurrentColumn, LowerColumn : integer;
  FirstColumnPosition, LastColumnPosition, AnotherColPosition : double;
  PreviousOK : boolean;
begin
  result := 1;
  if not GetTransportGridContours then
  begin
    result := 1;
  end
  else
  begin
    LowerColumn := -1;
    AnotherColPosition := -1;

{    StringtoEvaluate := 'NthColumnPos(' + IntToStr(NumColumns) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @AnotherColumn );}

    AnotherColumn := GetColumnPosition(layerHandle,NumColumns);

{    StringtoEvaluate := 'NthColumnPos(' + IntToStr(0) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @ColPosition ); }

    ColPosition := GetColumnPosition(layerHandle,0);

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
  LayerName : string;
begin
  result := PreviousMOCCOL1;
  try
    if Exporting then
    begin
      result := PreviousMOCCOL1;
    end
    else if EditWindowOpen then
    begin
      Beep;
  {    MessageDlg('You can not export a project or evaluate the' +
      ' solute-transport subgrid if an edit box is open. Try again after'
      + ' correcting this problems.', mtError, [mbOK], 0);}
    end
    else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try  // try 1
      begin

        frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
          as ModflowTypes.GetModflowFormType;

        LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
        try
          layerHandle := GetLayerHandle(frmMODFLOW.CurrentModelHandle,LayerName);
        except
          Exit;
        end;

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
  finally
    ANE_INT32_PTR(reply)^ := result;
  end;
end;

function fMOCCOL2(funHandle : ANE_PTR; layerHandle : ANE_PTR;
  NumColumns : ANE_INT32) : ANE_INT32;
var
  ColPosition, AnotherColumn : ANE_DOUBLE;
  EdgeOfGrid : ANE_DOUBLE;
//  StringtoEvaluate : string;
  distanceFromEdge : ANE_DOUBLE;
  FirstColumn, LastColumn, CurrentColumn, LowerColumn : integer;
  FirstColumnPosition, LastColumnPosition, AnotherColPosition : double;
  PreviousOK : boolean;
begin
  result := NumColumns;
  if not GetTransportGridContours then
  begin
    result := NumColumns;
  end
  else
  begin
    LowerColumn := -1;
    AnotherColPosition := -1;
{    StringtoEvaluate := 'NthColumnPos(' + IntToStr(0) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @AnotherColumn );}
    AnotherColumn := GetColumnPosition(layerHandle,0);

{    StringtoEvaluate := 'NthColumnPos(' + IntToStr(NumColumns) + ')' ;

    ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle, layerHandle ,
           kPIEFloat, PChar(StringtoEvaluate), @ColPosition ); }
    ColPosition := GetColumnPosition(layerHandle,NumColumns);

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
  LayerName : string;
begin
  result := PreviousMOCCOL2;
  try
    if Exporting then
    begin
      result := PreviousMOCCOL2;
    end
    else if EditWindowOpen then
    begin
      Beep;
  {    MessageDlg('You can not export a project or evaluate the' +
      ' solute-transport subgrid if an edit box is open. Try again after'
      + ' correcting this problems.', mtError, [mbOK], 0);}
    end
    else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try  // try 1
      begin

        frmMODFLOW := TArgusForm.GetFormFromArgus(funHandle)
          as ModflowTypes.GetModflowFormType;

        LayerName := ModflowTypes.GetGridLayerType.ANE_LayerName;
        try
          layerHandle := GetLayerHandle(frmMODFLOW.CurrentModelHandle,LayerName);
        except
          Exit;
        end;

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
  finally
    ANE_INT32_PTR(reply)^ := result;
  end;
end;

initialization
begin
//  OldContours := '';
//  OldGridAngle := 0;
  PreviousResult := False;
end;

end.
