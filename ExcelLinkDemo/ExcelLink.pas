unit ExcelLink;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Strset, Buttons, AnePIE;

type
  TfrmExcelLink = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function GetGridValue(SpreadSheetName, ActiveSheet: string; Row,
      Col: integer): double;
    function GetCachedGridValue(SpreadSheetName, ActiveSheet: string; Row,
      Col: integer): double;
    function GetContourValue(SpreadSheetName, ActiveSheet,
      ContourName: string; NameCol, Col: integer; var LastRow : integer;
      ContourNames : TStringList): double;
    function GetCachedContourValue(SpreadSheetName, ActiveSheet,
      ContourName: string; NameCol, Col: integer): double;
    { Private declarations }
  public
    ExcelInstance : Variant;
    SpreadsheetName : string;
    GridSheet : string;
    ContourSheet : string;
    ContourNameColumn : string;
    GridSpreadSheetNames : TStringList;
    ContourSpreadSheetNames : TStringList;
    { Public declarations }
  end;

  TReal = Class(TObject)
    Value : double;
  end;

var
  frmExcelLink: TfrmExcelLink;

procedure GPIEGridValueMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEContourValueMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
                                
implementation

{$R *.DFM}

uses ads_excel, ComObj, ParamArrayUnit, ANECB;


procedure TfrmExcelLink.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Edit1.Text := OpenDialog1.FileName;
  end;

end;

procedure TfrmExcelLink.FormDestroy(Sender: TObject);
var
  SpreadSheetIndex, SheetIndex : integer;
  SheetNames, ContourNames : TStringList;
  RowList, ColumnList : TList;
  RowIndex, ColumnIndex, ContourIndex : integer;
  AReal : TReal;
begin
  if not VarIsEmpty(ExcelInstance) then
  begin
    ExcelInstance.DisplayAlerts := False;
    ExcelInstance.Quit;
  end;
  for SpreadSheetIndex := 0 to GridSpreadSheetNames.Count -1 do
  begin
    if GridSpreadSheetNames.Objects[SpreadSheetIndex] <> nil then
    begin
      SheetNames := GridSpreadSheetNames.Objects[SpreadSheetIndex]
        as TStringList;
      for SheetIndex := 0 to SheetNames.Count -1 do
      begin
        if SheetNames.Objects[SpreadSheetIndex] <> nil then
        begin
          RowList := SheetNames.Objects[SpreadSheetIndex] as TList;
          for RowIndex := 0 to RowList.Count -1 do
          begin
            if RowList[RowIndex] <> nil then
            begin
              ColumnList := RowList[RowIndex];
              for ColumnIndex := 0 to ColumnList.Count -1 do
              begin
                if ColumnList[ColumnIndex] <> nil then
                begin
                  AReal := ColumnList[ColumnIndex];
                  AReal.Free;
                end;
              end;
              ColumnList.Free;
            end;
          end;
          RowList.Free;
        end;
      end;
      SheetNames.Free;
    end;
  end;
  GridSpreadSheetNames.Free;

  for SpreadSheetIndex := 0 to ContourSpreadSheetNames.Count -1 do
  begin
    if ContourSpreadSheetNames.Objects[SpreadSheetIndex] <> nil then
    begin
      SheetNames := ContourSpreadSheetNames.Objects[SpreadSheetIndex]
        as TStringList;
      for SheetIndex := 0 to SheetNames.Count -1 do
      begin
        if SheetNames.Objects[SheetIndex] <> nil then
        begin
          ContourNames := SheetNames.Objects[SheetIndex] as TStringList;
          for ContourIndex := 0 to ContourNames.Count -1 do
          begin
            if ContourNames.Objects[ContourIndex] <> nil then
            begin
              ColumnList := ContourNames.Objects[ContourIndex] as TList;
              for ColumnIndex := 0 to ColumnList.Count -1 do
              begin
                if ColumnList[ColumnIndex] <> nil then
                begin
                  AReal := ColumnList[ColumnIndex];
                  AReal.Free;
                end;
              end;
              ColumnList.Free;
            end;
          end;
          ContourNames.Free;
        end;
      end;
      SheetNames.Free;
    end;
  end;
  ContourSpreadSheetNames.Free;
end;

procedure TfrmExcelLink.Edit1Change(Sender: TObject);
begin
  SpreadsheetName := Edit1.Text;

end;

procedure TfrmExcelLink.Edit2Change(Sender: TObject);
begin
  GridSheet := Edit2.Text;
end;

procedure TfrmExcelLink.Edit3Change(Sender: TObject);
begin
  ContourSheet := Edit3.Text;
end;

procedure TfrmExcelLink.Edit4Change(Sender: TObject);
begin
  ContourNameColumn := Edit4.Text;
end;


function TfrmExcelLink.GetCachedGridValue(SpreadSheetName, ActiveSheet: string;
  Row, Col : integer) : double;
var
  Sheetnames : TStringList;
  ColList, RowList : TList;
  SpreadSheetIndex, SheetIndex : Integer;
  AReal : TReal;
begin
  SpreadSheetIndex := GridSpreadSheetNames.IndexOf(SpreadSheetName);
  if SpreadSheetIndex > -1 then
  begin
    Sheetnames := GridSpreadSheetNames.Objects[SpreadSheetIndex] as TStringList;
  end
  else
  begin
    Sheetnames := TStringList.Create;
    GridSpreadSheetNames.AddObject(SpreadSheetName, Sheetnames);
  end;

  SheetIndex := Sheetnames.IndexOf(ActiveSheet);
  if SheetIndex > -1 then
  begin
    RowList := Sheetnames.Objects[SheetIndex] as TList;
  end
  else
  begin
    RowList := TList.Create;
    Sheetnames.AddObject(ActiveSheet,RowList);
  end;

  if RowList.Count < Row  then
  begin
    RowList.Count := Row;
  end;
  if RowList[Row-1] <> nil then
  begin
    ColList := RowList[Row-1];
  end
  else
  begin
    ColList := TList.Create;
    RowList[Row-1] := ColList;
  end;
  if ColList.Count < Col then
  begin
    ColList.Count := Col
  end;
  if ColList[Col-1] <> nil then
  begin
    AReal := ColList[Col-1];
  end
  else
  begin
    AReal := TReal.Create;
    ColList[Col-1] := AReal;
    try
      AReal.Value := GetGridValue(SpreadSheetName, ActiveSheet, Row, Col);
    except on EConvertError do
      begin
        AReal.Value := 0;
      end
    end;
  end;
  result := AReal.Value;
end;

function TfrmExcelLink.GetGridValue(SpreadSheetName, ActiveSheet : string;
  Row, Col : integer) : double;
var
  FileOpen : boolean;
  AWorkBook : variant;
  Index : integer;
begin
  if VarIsEmpty(ExcelInstance) then
  begin
    ExcelInstance := CreateOleObject('Excel.Application');
  end;
  FileOpen := False;
  if (ExcelInstance.WorkBooks.Count > 0) then
  begin
    FileOpen := (ExcelInstance.ActiveWorkbook.FullName = SpreadSheetName);
    if FileOpen then
    begin
    AWorkBook := ExcelInstance.ActiveWorkbook;
    end
    else
    begin
      for Index := 0 to ExcelInstance.WorkBooks.Count -1 do
      begin
        FileOpen := ExcelInstance.WorkBooks[Index].FullName = SpreadSheetName;
        if FileOpen then
        begin
          ExcelInstance.ActiveWorkbook := ExcelInstance.WorkBooks[Index];
          break;
        end
      end;
    end;
  end;
  if not FileOpen then
  begin
    ExcelOpenFile(ExcelInstance, SpreadSheetName);
    AWorkBook := ExcelInstance.ActiveWorkbook;
  end;
  ExcelSelectSheetByName(ExcelInstance, ActiveSheet);
  Result := StrToFloat(Trim(ExcelGetCellValue(ExcelInstance,Row,Col)));
  AWorkBook.Saved := True;
end;

function TfrmExcelLink.GetCachedContourValue(SpreadSheetName, ActiveSheet,
  ContourName : string; NameCol, Col : integer ) : double;
var
  ContourNames : TStringList;
  SpreadSheetIndex,SheetIndex,ContourIndex : integer;
  Sheetnames : TStringList;
  ColList : TList;
  AReal : TReal;
  LastRow : integer;
begin
  SpreadSheetIndex := ContourSpreadSheetNames.IndexOf(SpreadSheetName);
  if SpreadSheetIndex > -1 then
  begin
    Sheetnames := ContourSpreadSheetNames.Objects[SpreadSheetIndex]
      as TStringList;
  end
  else
  begin
    Sheetnames := TStringList.Create;
    ContourSpreadSheetNames.AddObject(SpreadSheetName, Sheetnames);
  end;
  
  SheetIndex := Sheetnames.IndexOf(ActiveSheet);
  if SheetIndex > -1 then
  begin
    ContourNames := Sheetnames.Objects[SheetIndex] as TStringList;
  end
  else
  begin
    ContourNames := TStringList.Create;
    Sheetnames.AddObject(ActiveSheet,ContourNames);
  end;

  ContourIndex := ContourNames.IndexOf(ContourName);
  if ContourIndex > -1 then
  begin
    ColList := ContourNames.Objects[ContourIndex] as TList;
  end
  else
  begin
    ColList := TList.Create;
    ContourNames.AddObject(ContourName,ColList);
  end;

  if ColList.Count < Col then
  begin
    ColList.Count := Col
  end;
  if ColList[Col-1] <> nil then
  begin
    AReal := ColList[Col-1];
  end
  else
  begin
    AReal := TReal.Create;
    AReal.Value := GetContourValue(SpreadSheetName, ActiveSheet,
      ContourName, NameCol, Col, LastRow, ContourNames);
    ColList[Col-1] := AReal;
    if ContourNames.Capacity < LastRow then
    begin
      ContourNames.Capacity := LastRow
    end;
  end;
  result := AReal.Value;
end;

function TfrmExcelLink.GetContourValue(SpreadSheetName, ActiveSheet,
  ContourName : string; NameCol, Col : integer; var LastRow : integer;
  ContourNames : TStringList) : double;
var
  FileOpen : boolean;
  AWorkBook : Variant;
  Index, RowIndex : integer;
  AReal : TReal;
  AName : string;
  ContourIndex : integer;
  ColList : TList;
begin
  result := 0;
  if VarIsEmpty(ExcelInstance) then
  begin
    ExcelInstance := CreateOleObject('Excel.Application');
  end;
  FileOpen := False;
  if (ExcelInstance.WorkBooks.Count > 0) then
  begin
    FileOpen := (ExcelInstance.ActiveWorkbook.FullName = SpreadSheetName);
    if FileOpen then
    begin
    AWorkBook := ExcelInstance.ActiveWorkbook;
    end
    else
    begin
      for Index := 0 to ExcelInstance.WorkBooks.Count -1 do
      begin
        FileOpen := ExcelInstance.WorkBooks[Index].FullName = SpreadSheetName;
        if FileOpen then
        begin
          ExcelInstance.ActiveWorkbook := ExcelInstance.WorkBooks[Index];
          break;
        end
      end;
    end;
  end;
  if not FileOpen then
  begin
    ExcelOpenFile(ExcelInstance, SpreadSheetName);
    AWorkBook := ExcelInstance.ActiveWorkbook;
  end;
  ExcelSelectSheetByName(ExcelInstance, ActiveSheet);
  ExcelSelectCell(ExcelInstance,1,NameCol);
  LastRow := ExcelLastRow(ExcelInstance);
  if ContourNames.Capacity < LastRow then
  begin
    ContourNames.Capacity := LastRow;
  end;
  for RowIndex := 1 to LastRow do
  begin
    AName := ExcelGetCellValue(ExcelInstance,RowIndex,NameCol);

    ContourIndex := ContourNames.IndexOf(AName);
    if ContourIndex > -1 then
    begin
      ColList := ContourNames.Objects[ContourIndex] as TList;
    end
    else
    begin
      ColList := TList.Create;
      ContourNames.AddObject(ContourName,ColList);
    end;

    if ColList.Count < Col then
    begin
      ColList.Count := Col
    end;

    if ColList[Col-1] <> nil then
    begin
      AReal := ColList[Col-1];
    end
    else
    begin
      AReal := TReal.Create;
      ColList[Col-1] := AReal;
      try
        AReal.Value := StrToFloat(Trim(
          ExcelGetCellValue(ExcelInstance,RowIndex,Col)));
      except on EConvertError do
        begin
          AReal.Value := 0;
        end;
      end;
    end;

    if AName = ContourName then
    begin
      Result := AReal.Value;
    end;
  end;

  AWorkBook.Saved := True;
end;

procedure GPIEGridValueMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_STR;
  param2_ptr : ANE_STR;
  param3_ptr : ANE_INT32_PTR;
  param4_ptr : ANE_INT32_PTR;
  result : ANE_DOUBLE;
  param : PParameter_array;
  SpreadSheetName : String;
  ActiveSheet : string;
  Row, Col : integer;
  firstCol, firstRow : integer;
begin
  try
    begin
      result := 0;
      ANE_GetPIEProjectHandle(myHandle, @frmExcelLink );
      param := @parameters^;
      param1_ptr :=  param^[0];
      SpreadSheetName := Trim(String(param1_ptr));
      if FileExists(SpreadSheetName) then
      begin
        param2_ptr :=  param^[1];
        ActiveSheet := Trim(String(param2_ptr));
        param3_ptr :=  param^[2];
        Col :=  param3_ptr^;
        param4_ptr :=  param^[3];
        Row :=  param4_ptr^;
        result := frmExcelLink.GetCachedGridValue(SpreadSheetName,
          ActiveSheet, Row, Col);
      end;
    end
  except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GPIEContourValueMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  param1_ptr : ANE_STR;
  param2_ptr : ANE_STR;
  param3_ptr : ANE_STR;
  param4_ptr : ANE_INT32_PTR;
  param5_ptr : ANE_INT32_PTR;
  result : ANE_DOUBLE;
  param : PParameter_array;
  SpreadSheetName : String;
  ActiveSheet : string;
  ContourName : string;
  NameCol, Col : integer;
  firstCol, firstRow : integer;
begin
  try
    begin
      result := 0;
      ANE_GetPIEProjectHandle(myHandle, @frmExcelLink );
      param := @parameters^;
      param1_ptr :=  param^[0];
      SpreadSheetName := Trim(String(param1_ptr));
      if FileExists(SpreadSheetName) then
      begin
        param2_ptr :=  param^[1];
        ActiveSheet := Trim(String(param2_ptr));
        param3_ptr :=  param^[2];
        ContourName :=  Trim(String(param3_ptr));
        param4_ptr :=  param^[3];
        NameCol :=  param4_ptr^;
        param5_ptr :=  param^[4];
        Col :=  param5_ptr^;
        result := frmExcelLink.GetCachedContourValue(SpreadSheetName, ActiveSheet,
          ContourName, NameCol, Col ) ;
      end;
    end
  except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure TfrmExcelLink.FormCreate(Sender: TObject);
begin
  GridSpreadSheetNames := TStringList.Create;
  ContourSpreadSheetNames := TStringList.Create;
end;

end.
