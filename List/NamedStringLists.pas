unit NamedStringLists;

interface

uses
  Classes, SysUtils, AnePIE;

procedure GListFreeNamedStringLists(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEAddToNamedStringListMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEFreeNamedStringList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEGetFromNamedStringList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEGetNamedStringListCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEGetNameOfStringList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEGetNumberOfNamedStringLists(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEGetPositionInStringList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure ClearNamedStringLists;

implementation

uses AListUnit;

var
  NamedStringList: TStringList;

procedure ClearNamedStringLists;
var
  ListIndex: integer;
begin
  if NamedStringList <> nil then
  begin
    for ListIndex := NamedStringList.Count - 1 downto 0 do
    begin
      NamedStringList.Objects[ListIndex].Free;
    end;
    NamedStringList.Clear;
  end;
end;

procedure GListFreeNamedStringLists(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

var
  result: ANE_BOOL;
begin
  try
    begin
      ClearNamedStringLists;
      result := True;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure Terminate;
var
  ListIndex: integer;
begin
  try
    begin
      if NamedStringList <> nil then
      begin
        for ListIndex := NamedStringList.Count - 1 downto 0 do
        begin
          NamedStringList.Objects[ListIndex].Free;
        end;
        NamedStringList.Free;
        NamedStringList := nil;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
    end;
  end;
end;

procedure GPIEAddToNamedStringListMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  AList: TStringList;
  param1: ANE_STR; // name of List to which value will be added.
  param2: ANE_STR; // value to be added.
  result: ANE_INT32; // position in list of item that was added.
  param: PParameter_array;
  Position: integer;
begin
  try
    begin
      param := @parameters^;
      param1 := param^[0];
      param2 := param^[1];

      if NamedStringList = nil then
      begin
        NamedStringList := TStringList.Create;
      end;

      Position := ListPosition(NamedStringList, param1);
      if Position < 0 then
      begin
        AList := TStringList.Create;
        NamedStringList.AddObject(param1, AList);
      end
      else
      begin
        AList := NamedStringList.Objects[Position] as TStringList;
      end;

      AList.Add(param2);
      result := AList.Count;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GPIEFreeNamedStringList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  param1: ANE_STR;
  result: ANE_BOOL;
  param: PParameter_array;
  Position: integer;
begin
  try
    begin
      if NamedStringList = nil then
      begin
        result := False;
//        Inc(ErrorCount);
      end
      else
      begin
        param := @parameters^;
        param1 := param^[0];

        Position := ListPosition(NamedStringList, param1);
        if Position < 0 then
        begin
          result := False;
          Inc(ErrorCount);
        end
        else
        begin
          NamedStringList.Objects[Position].Free;
          NamedStringList.Delete(Position);
          result := True;
        end;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := False;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

var
  ValueInList: string;

procedure GPIEGetFromNamedStringList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  AList: TStringList;
  param1: ANE_STR; // name of List  containing value
  param2_ptr: ANE_INT32_PTR;
  param2: ANE_INT32; // position in list of item
  result: ANE_STR;
  param: PParameter_array;
  Position: integer;
begin
  try
    begin
      if NamedStringList = nil then
      begin
        ValueInList := '';
        Inc(ErrorCount);
      end
      else
      begin
        param := @parameters^;
        param1 := param^[0];
        param2_ptr := param^[1];
        param2 := param2_ptr^;

        Position := ListPosition(NamedStringList, param1);
        if Position < 0 then
        begin
          ValueInList := '';
          Inc(ErrorCount);
        end
        else
        begin
          AList := NamedStringList.Objects[Position] as TStringList;
          ValueInList := AList[param2]
        end;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      ValueInList := '';
    end;
  end;
  result := PChar(ValueInList);
  ANE_STR_PTR(reply)^ := result;
end;

procedure GPIEGetNamedStringListCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  AList: TStringList;
  param1: ANE_STR; // Index of List  containing value
  result: ANE_INT32;
  param: PParameter_array;
  Position: integer;
begin
  try
    begin
      if NamedStringList = nil then
      begin
        result := 0;
        Inc(ErrorCount);
      end
      else
      begin
        param := @parameters^;
        param1 := param^[0];

        Position := ListPosition(NamedStringList, param1);
        if Position < 0 then
        begin
          result := 0;
          Inc(ErrorCount);
        end
        else
        begin
          AList := NamedStringList.Objects[Position] as TStringList;
          result := AList.Count;
        end;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

var
  NameOfStringList: string;

procedure GPIEGetNameOfStringList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  param1_ptr: ANE_INT32_PTR;
  param1: ANE_INT32;
  result: ANE_STR;
  param: PParameter_array;
begin
  try
    begin
      if NamedStringList = nil then
      begin
        Inc(ErrorCount);
        NameOfStringList := '';
      end
      else
      begin
        param := @parameters^;
        param1_ptr := param^[0];
        param1 := param1_ptr^;

        NameOfStringList := NamedStringList[param1];
      end;
      result := PChar(NameOfStringList);
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := '';
    end;
  end;
  ANE_STR_PTR(reply)^ := result;
end;

procedure GPIEGetNumberOfNamedStringLists(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_INT32; // position in list of item that was added.
begin
  try
    begin
      if NamedStringList = nil then
      begin
        result := 0;
      end
      else
      begin
        result := NamedStringList.Count
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GPIEGetPositionInStringList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  AList: TStringList;
  param1: ANE_STR; // Index of List to which value will be added.
  param2: ANE_STR; // value to be added.
  result: ANE_INT32; // position in list of item that was added.
  param: PParameter_array;
  Position: integer;
begin
  result := -1;
  try
    try
      begin
        if NamedStringList = nil then
        begin
          Exit;
        end;

        param := @parameters^;
        param1 := param^[0];
        param2 := param^[1];

        Position := ListPosition(NamedStringList, param1);
        if Position < 0 then
        begin
          Exit;
        end
        else
        begin
          AList := NamedStringList.Objects[Position] as TStringList;
        end;

        result := AList.IndexOf(param2);
      end;
    except on Exception do
      begin
        Inc(ErrorCount);
        result := -1;
      end;
    end;
  finally
    ANE_INT32_PTR(reply)^ := result;
  end;
end;

initialization

finalization
  Terminate;

end.

