unit CoordinateLists;

interface

uses
  Classes, SysUtils, AnePIE;

procedure GListFreeNamedCoordinateLists(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEAddToNamedCoordinateListMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEFreeNamedCoordinateList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEGetXFromNamedCoordinateList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEGetYFromNamedCoordinateList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEGetNamedCoordinateListCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEGetNameOfCoordinateList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEGetNumberOfNamedCoordinateLists(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure GPIEGetPositionInCoordinateList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

procedure ClearNamedCoordinateLists;

implementation

uses contnrs, AListUnit;

type
  TCoordinate = class(TObject)
    X: double;
    Y: double;
  end;

var
  NamedCoordinateList: TStringList;

procedure ClearNamedCoordinateLists;
var
  ListIndex: integer;
begin
  if NamedCoordinateList <> nil then
  begin
    for ListIndex := NamedCoordinateList.Count - 1 downto 0 do
    begin
      NamedCoordinateList.Objects[ListIndex].Free;
    end;
    NamedCoordinateList.Clear;
  end;
end;

procedure GListFreeNamedCoordinateLists(const refPtX: ANE_DOUBLE_PTR;
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
      ClearNamedCoordinateLists;
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
begin
  try
    begin
      ClearNamedCoordinateLists;
      FreeAndNil(NamedCoordinateList);
{      if NamedCoordinateList <> nil then
      begin
        for ListIndex := NamedCoordinateList.Count - 1 downto 0 do
        begin
          NamedCoordinateList.Objects[ListIndex].Free;
        end;
        NamedCoordinateList.Free;
        NamedCoordinateList := nil;
      end;}
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
    end;
  end;
end;

procedure GPIEAddToNamedCoordinateListMMFun(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  AList: TList;
  param1: ANE_STR; // name of List to which value will be added.
  param2: ANE_DOUBLE_PTR; // X value to be added.
  param3: ANE_DOUBLE_PTR; // Y value to be added.
  result: ANE_INT32; // position in list of item that was added.
  param: PParameter_array;
  Position: integer;
  X: ANE_DOUBLE;
  Y: ANE_DOUBLE;
  ACoordinate: TCoordinate;
begin
  try
    begin
      param := @parameters^;
      param1 := param^[0];
      param2 := param^[1];
      param3 := param^[2];
      X := param2^;
      Y := param3^;

      if NamedCoordinateList = nil then
      begin
        NamedCoordinateList := TStringList.Create;
      end;

      Position := ListPosition(NamedCoordinateList, param1);
      if Position < 0 then
      begin
        AList := TObjectList.Create;
        NamedCoordinateList.AddObject(param1, AList);
      end
      else
      begin
        AList := NamedCoordinateList.Objects[Position] as TList;
      end;

      ACoordinate := TCoordinate.Create;
      ACoordinate.X := X;
      ACoordinate.Y := Y;

      AList.Add(ACoordinate);
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

procedure GPIEFreeNamedCoordinateList(const refPtX: ANE_DOUBLE_PTR;
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
      if NamedCoordinateList = nil then
      begin
        result := False;
//        Inc(ErrorCount);
      end
      else
      begin
        param := @parameters^;
        param1 := param^[0];

        Position := ListPosition(NamedCoordinateList, param1);
        if Position < 0 then
        begin
          result := False;
          Inc(ErrorCount);
        end
        else
        begin
          NamedCoordinateList.Objects[Position].Free;
          NamedCoordinateList.Delete(Position);
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

//var
//  ValueInList: string;

procedure GPIEGetXFromNamedCoordinateList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  AList: TList;
  param1: ANE_STR; // name of List  containing value
  param2_ptr: ANE_INT32_PTR;
  param2: ANE_INT32; // position in list of item
  result: ANE_DOUBLE;
  param: PParameter_array;
  Position: integer;
  ACoordinate: TCoordinate;
begin
  result := 0;
  try
    begin
      if NamedCoordinateList = nil then
      begin
//        ValueInList := '';
        Inc(ErrorCount);
      end
      else
      begin
        param := @parameters^;
        param1 := param^[0];
        param2_ptr := param^[1];
        param2 := param2_ptr^;

        Position := ListPosition(NamedCoordinateList, param1);
        if Position < 0 then
        begin
//          ValueInList := '';
          Inc(ErrorCount);
        end
        else
        begin
          AList := NamedCoordinateList.Objects[Position] as TList;
          ACoordinate := AList[param2];
          result := ACoordinate.X;
        end;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
//      ValueInList := '';
    end;
  end;
//  result := PChar(ValueInList);
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GPIEGetYFromNamedCoordinateList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var  
  AList: TList;
  param1: ANE_STR; // name of List  containing value
  param2_ptr: ANE_INT32_PTR;
  param2: ANE_INT32; // position in list of item
  result: ANE_DOUBLE;
  param: PParameter_array;
  Position: integer;
  ACoordinate: TCoordinate;
begin
  result := 0;
  try
    begin
      if NamedCoordinateList = nil then
      begin
//        ValueInList := '';
        Inc(ErrorCount);
      end
      else
      begin
        param := @parameters^;
        param1 := param^[0];
        param2_ptr := param^[1];
        param2 := param2_ptr^;

        Position := ListPosition(NamedCoordinateList, param1);
        if Position < 0 then
        begin
//          ValueInList := '';
          Inc(ErrorCount);
        end
        else
        begin
          AList := NamedCoordinateList.Objects[Position] as TList;
          ACoordinate := AList[param2];
          result := ACoordinate.Y;
        end;
      end;
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
//      ValueInList := '';
    end;
  end;
//  result := PChar(ValueInList);
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GPIEGetNamedCoordinateListCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  AList: TList;
  param1: ANE_STR; // Index of List  containing value
  result: ANE_INT32;
  param: PParameter_array;
  Position: integer;
begin
  try
    begin
      if NamedCoordinateList = nil then
      begin
        result := 0;
        Inc(ErrorCount);
      end
      else
      begin
        param := @parameters^;
        param1 := param^[0];

        Position := ListPosition(NamedCoordinateList, param1);
        if Position < 0 then
        begin
          result := 0;
          Inc(ErrorCount);
        end
        else
        begin
          AList := NamedCoordinateList.Objects[Position] as TList;
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
  NameOfCoordinateList: string;

procedure GPIEGetNameOfCoordinateList(const refPtX: ANE_DOUBLE_PTR;
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
      if NamedCoordinateList = nil then
      begin
        Inc(ErrorCount);
        NameOfCoordinateList := '';
      end
      else
      begin
        param := @parameters^;
        param1_ptr := param^[0];
        param1 := param1_ptr^;

        NameOfCoordinateList := NamedCoordinateList[param1];
      end;
      result := PChar(NameOfCoordinateList);
    end;
  except on Exception do
    begin
      Inc(ErrorCount);
      result := '';
    end;
  end;
  ANE_STR_PTR(reply)^ := result;
end;

procedure GPIEGetNumberOfNamedCoordinateLists(const refPtX: ANE_DOUBLE_PTR;
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
      if NamedCoordinateList = nil then
      begin
        result := 0;
      end
      else
      begin
        result := NamedCoordinateList.Count
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

procedure GPIEGetPositionInCoordinateList(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  myHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  AList: TList;
  param1: ANE_STR; // Index of List to which value will be added.
  param2: ANE_DOUBLE_PTR; // value to be checked.
  param3: ANE_DOUBLE_PTR; // value to be checked.
  result: ANE_INT32; // position in list of item that was added.
  param: PParameter_array;
  Position: integer;
  X, Y: ANE_DOUBLE;
  Index: integer;
  ACoordinate: TCoordinate;
begin
  result := -1;
  try
    try
      begin
        if NamedCoordinateList = nil then
        begin
          Exit;
        end;

        param := @parameters^;
        param1 := param^[0];
        param2 := param^[1];
        param3 := param^[2];
        X := param2^;
        Y := param3^;

        Position := ListPosition(NamedCoordinateList, param1);
        if Position < 0 then
        begin
          Exit;
        end
        else
        begin
          AList := NamedCoordinateList.Objects[Position] as TList;
        end;

        for Index := 0 to AList.Count -1 do
        begin
          ACoordinate := AList[Index];
          if (ACoordinate.X = X) and (ACoordinate.Y = Y) then
          begin
            result := Index;
            Exit;
          end;
        end;
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
