unit GetListViewCellStringUnit;

interface

uses Windows, Comctrls, Math;

function MouseToListViewCell(X, Y: Integer; var Col,Row : integer;
  ListView: TListView) : boolean;

function GetListViewXYString(X, Y: Integer; ListView: TListView;
  var CellString: string): boolean;

function SetListViewXYString(X, Y: Integer; ListView: TListView;
  CellString: string): boolean;

implementation

function MouseToListViewCell(X, Y: Integer; var Col,Row : integer;
  ListView: TListView) : boolean;
var
  ListItemIndex, ColumnIndex : integer;
  AListItem : TListItem;
  ARect : TRect;
  Width : integer;
  EndColumn : integer;
begin
  result := False;
  for ListItemIndex := 0 to ListView.Items.Count -1 do
  begin
    AListItem := ListView.Items[ListItemIndex];
    ARect := AListItem.DisplayRect(drBounds);
    if (ARect.Top <= Y) and (ARect.Bottom >= Y) then
    begin
      if ListView.Columns.Count > 0 then
      begin
        Width := ListView.Column[0].Width;
        if (Width >= X) then
        begin
          Result := True;
          Col := 0;
          Row := ListItemIndex;
        end
        else
        begin
          EndColumn := Min(AListItem.SubItems.Count, ListView.Columns.Count-1);
          for ColumnIndex := 1 to EndColumn do
          begin
            Width := Width + ListView.Column[ColumnIndex].Width;
            if (Width >= X) then
            begin
              Result := True;
              Col := ColumnIndex;
              Row := ListItemIndex;
              break;
            end;
          end;
        end;
      end;
      break;
    end;
  end;
end;

function GetListViewXYString(X, Y: Integer; ListView: TListView;
  var CellString: string): boolean;
  // This function returns true if the cell in ListView at X,Y has
  // its contents defined. Otherwise it returns false. CellString
  // is set to the string in the cell at X,Y if the function returns
  // True.
var
  AListItem : TListItem;
  Col, Row : integer;
begin
  result := MouseToListViewCell(X, Y, Col, Row, ListView);
  if result then
  begin
    AListItem := ListView.Items[Row];
    if Col = 0 then
    begin
      CellString := AListItem.Caption;
    end
    else
    begin
      CellString := AListItem.SubItems[Col -1];
    end
  end;
{  for ListItemIndex := 0 to ListView.Items.Count -1 do
  begin
    AListItem := ListView.Items[ListItemIndex];
    ARect := AListItem.DisplayRect(drBounds);
    if (ARect.Top <= Y) and (ARect.Bottom >= Y) then
    begin
      if ListView.Columns.Count > 0 then
      begin
        Width := ListView.Columns[0].Width;
        if (Width >= X) then
        begin
          Result := True;
          CellString := AListItem.Caption;
        end
        else
        begin
          EndColumn := Min(AListItem.SubItems.Count, ListView.Columns.Count-1);
          for ColumnIndex := 1 to EndColumn do
          begin
            Width := Width + ListView.Columns[ColumnIndex].Width;
            if (Width >= X) then
            begin
              Result := True;
              CellString := AListItem.SubItems[ColumnIndex -1];
              break;
            end;
          end;
        end;
      end;
      break;
    end;
  end; }
end;

function SetListViewXYString(X, Y: Integer; ListView: TListView;
  CellString: string): boolean;
  // This function returns true if the cell in ListView at X,Y has
  // its contents defined. Otherwise it returns false. the string
  // in the cell at X,Y  is set to CellString if the function returns
  // True.
var
  AListItem : TListItem;
  Col, Row : integer;
begin
  result := MouseToListViewCell(X, Y, Col, Row, ListView);
  if result then
  begin
    AListItem := ListView.Items[Row];
    if Col = 0 then
    begin
      AListItem.Caption := CellString;
    end
    else
    begin
      AListItem.SubItems[Col -1] := CellString;
    end
  end;
{  result := False;
  for ListItemIndex := 0 to ListView.Items.Count -1 do
  begin
    AListItem := ListView.Items[ListItemIndex];
    ARect := AListItem.DisplayRect(drBounds);
    if (ARect.Top <= Y) and (ARect.Bottom >= Y) then
    begin
      if ListView.Columns.Count > 0 then
      begin
        Width := ListView.Columns[0].Width;
        if (Width >= X) then
        begin
          Result := True;
          AListItem.Caption := CellString;
        end
        else
        begin
          EndColumn := Min(AListItem.SubItems.Count, ListView.Columns.Count-1);
          for ColumnIndex := 1 to EndColumn do
          begin
            Width := Width + ListView.Columns[ColumnIndex].Width;
            if (Width >= X) then
            begin
              Result := True;
              AListItem.SubItems[ColumnIndex -1] := CellString;
              break;
            end;
          end;
        end;
      end;
      break;
    end;
  end;  }
end;

end.
 