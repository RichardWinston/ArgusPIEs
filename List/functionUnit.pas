unit functionUnit;

interface

uses
  Classes, SysUtils,
  AnePIE, FunctionPie;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;
  ANE_BOOL_PTR = ^ANE_BOOL;

  TReal = Class (TObject)
    Value : double;
  end;

var
        MainList : TList;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

{
procedure GInitializeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
}
procedure GListCreateMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIESetListSizeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEGetListCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEFreeListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEAddToListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIEGetFromListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIESetListItemMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GPIERemoveListItemMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GListFreeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
implementation

const
  kMaxFunDesc = 20;

var

        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

{
        gPIEInitializeDesc  :  ANEPIEDesc;
        gPIEInitializeFDesc :  FunctionPIEDesc;
}

        gPIECreateListDesc  :  ANEPIEDesc;
        gPIECreateListFDesc :  FunctionPIEDesc;

        gPIESetListSizeDesc  :  ANEPIEDesc;
        gPIESetListSizeFDesc :  FunctionPIEDesc;

        gPIEGetListCountDesc  :  ANEPIEDesc;
        gPIEGetListCountFDesc :  FunctionPIEDesc;

        gPIEFreeAListDesc  :  ANEPIEDesc;
        gPIEFreeAListFDesc :  FunctionPIEDesc;

        gPIEAddDesc  :  ANEPIEDesc;
        gPIEAddFDesc :  FunctionPIEDesc;

        gPIEGetDesc  :  ANEPIEDesc;
        gPIEGetFDesc :  FunctionPIEDesc;

        gPIESetListItemDesc  :  ANEPIEDesc;
        gPIESetListItemFDesc :  FunctionPIEDesc;

        gPIERemoveListItemDesc  :  ANEPIEDesc;
        gPIERemoveListItemFDesc :  FunctionPIEDesc;

        gPIEFreeListDesc  :  ANEPIEDesc;
        gPIEFreeListFDesc :  FunctionPIEDesc;



const   gpnNumber : array [0..1] of PChar = ('Number', nil);
const   gpnListIndex : array [0..1] of PChar = ('ListIndex', nil);
const   gOneIntegerTypes : array [0..1] of EPIENumberType = (kPIEInteger, 0);

const   gpnIndexValue : array [0..2] of PChar = ('ListIndex','Value', nil);
const   gIntegerDouble : array [0..2] of EPIENumberType = (kPIEInteger, kPIEFloat, 0);

const   gpn2Index : array [0..2] of PChar = ('ListIndex','Index', nil);
const   gpnIndexSize : array [0..2] of PChar = ('ListIndex','Size', nil);
const   g2Integer : array [0..2] of EPIENumberType = (kPIEInteger, kPIEInteger, 0);

const   gpn2IndexValue : array [0..3] of PChar = ('ListIndex','Index','Value', nil);
const   g2IntegerValue : array [0..3] of EPIENumberType = (kPIEInteger, kPIEInteger,kPIEFloat, 0);

function Initialize : ANE_BOOL;
//var
//  result : ANE_BOOL;
begin
  try
    begin
      if (MainList = nil)
      then
        begin
          MainList := TList.Create;
          result :=1;
        end
      else
        begin
          result :=-1;
        end;
    end;
  Except on Exception do
    begin
      MainList.Free;
      result := 0;
    end;
  end;
end;

{
procedure GInitializeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_BOOL;
begin
  result := Initialize;
  ANE_BOOL_PTR(reply)^ := result;
end;
}

procedure GListCreateMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  AList : TList;
  result : ANE_INT32;
begin
  try
    begin
      AList := TList.Create;
      MainList.Add(AList);
      result := MainList.Count -1;
    end;
  Except on Exception do
    begin
      AList.Free;
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GPIEAddToListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List to which value will be added.
  param2_ptr : ANE_DOUBLE_PTR;
  param2 : ANE_DOUBLE;         // value to be added.
  result : ANE_INT32;           // position in list of item that was added.
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      AReal := TReal.Create;
      AReal.Value := param2;
      AList := MainList.Items[param1];
      AList.Add(AReal);
      result := AList.Count -1;
    end;
  except on Exception do
    begin
      AReal.Free;
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GPIESetListSizeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List to which value will be added.
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;         // size of List.
  result : ANE_BOOL;           // true if succeeded.
  param : PParameter_array;
  ListIndex : integer;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      AList := MainList.Items[param1];
      For ListIndex := AList.Count to param2-1 do
      begin
        AReal := TReal.Create;
        AReal.Value := 0;
        AList.Add(AReal);
      end;
      result := 1;
    end;
  except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIEGetListCountMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  result : ANE_INT32;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AList := MainList.Items[param1];
      result := AList.Count;
    end;
  except on Exception do
    begin
      result := -1;
    end;
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GPIEFreeListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  result : ANE_BOOL;
  param : PParameter_array;
  ListIndex : integer;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AList := MainList.Items[param1];
      For ListIndex := AList.Count -1 downto 0 do
      begin
        AReal := AList.Items[ListIndex];
        AReal.Free;
      end;
      AList.Clear;
//      AList.Capacity := AList.Count;
      result := 1;
    end;
  except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIEGetFromListMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // position in list of item
  result : ANE_DOUBLE;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      AList := MainList.Items[param1];
      AReal := AList.Items[param2];
      result := AReal.Value;
    end;
  except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_DOUBLE_PTR(reply)^ := result;
end;

procedure GPIESetListItemMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // position in list of item
  param3_ptr : ANE_DOUBLE_PTR;
  param3 : ANE_DOUBLE;          // position in list of item
  result : ANE_BOOL;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      param2_ptr :=  param^[1];
      param2 :=  param2_ptr^;
      param3_ptr :=  param^[2];
      param3 :=  param3_ptr^;
      AList := MainList.Items[param1];
      AReal := AList.Items[param2];
      AReal.Value := param3;
      result := 1;
    end;
  except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GPIERemoveListItemMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  AReal : TReal;
  AList : TList;
  param1_ptr : ANE_INT32_PTR;
  param1 : ANE_INT32;          // Index of List  containing value
  param2_ptr : ANE_INT32_PTR;
  param2 : ANE_INT32;          // position in list of item
  ItemToRemove : integer ;
  result : ANE_BOOL;
  param : PParameter_array;
begin
  try
    begin
      param := @parameters^;
      param1_ptr :=  param^[0];
      param1 :=  param1_ptr^;
      AList := MainList.Items[param1];
      if (numParams > 1 )
      then
        begin
          param2_ptr :=  param^[1];
          param2 :=  param2_ptr^;
        end
      else
        begin
          param2 := AList.Count -1;
        end;
      AReal := AList.Items[param2];
      ItemToRemove := param2;
      AList.Delete(ItemToRemove);
      AReal.Free;
      result := 1;
    end;
  except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;

procedure GListFreeMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

var
  result : ANE_BOOL;
  ListIndex, InnerListIndex : integer;
  AList : TList;
  AReal : TReal;
begin
  try
    begin
      if not (MainList = nil) then
      begin
        For ListIndex := MainList.Count -1 downto 0 do
        begin
          AList := MainList.Items[ListIndex];
          if not (AList = nil) then
          begin
            For InnerListIndex := AList.Count -1 downto 0 do
            begin
              AReal := AList.Items[InnerListIndex];
              AReal.Free;
            end;
            AList.Clear;
            AList.Free;
          end;
        end;
        MainList.Clear;
        MainList.Free;
        MainList := nil;
      end;
      result := Initialize;
    end;
  Except on Exception do
    begin
      result := 0;
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;
end;



procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin
        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

        Initialize;

	numNames := 0;
{
        // Initialize list of lists.
	gPIEInitializeFDesc.name := 'InitializeList';	        // name of function
	gPIEInitializeFDesc.address := GInitializeMMFun;	// function address
	gPIEInitializeFDesc.returnType := kPIEBoolean;		// return value type
	gPIEInitializeFDesc.numParams :=  0;			// number of parameters
	gPIEInitializeFDesc.numOptParams := 0;			// number of optional parameters
	gPIEInitializeFDesc.paramNames := nil;		        // pointer to parameter names list
	gPIEInitializeFDesc.paramTypes := nil;	                // pointer to parameters types list

       	gPIEInitializeDesc.name  := 'InitializeList';		// name of PIE
	gPIEInitializeDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEInitializeDesc.descriptor := @gPIEInitializeFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEInitializeDesc;              // add descriptor to list
        Inc(numNames);	                                        // increment number of names
}

        // Create a new list
	gPIECreateListFDesc.name := 'CreateNewList';	        // name of function
	gPIECreateListFDesc.address := GListCreateMMFun;	// function address
	gPIECreateListFDesc.returnType := kPIEInteger;		// return value type
	gPIECreateListFDesc.numParams :=  0;			// number of parameters
	gPIECreateListFDesc.numOptParams := 0;			// number of optional parameters
	gPIECreateListFDesc.paramNames := nil;		        // pointer to parameter names list
	gPIECreateListFDesc.paramTypes := nil;	                // pointer to parameters types list

       	gPIECreateListDesc.name  := 'CreateNewList';		// name of PIE
	gPIECreateListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIECreateListDesc.descriptor := @gPIECreateListFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIECreateListDesc;              // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Set list size
	gPIESetListSizeFDesc.name := 'SetListSize';	        // name of function
	gPIESetListSizeFDesc.address := GPIESetListSizeMMFun;	// function address
	gPIESetListSizeFDesc.returnType := kPIEBoolean;		// return value type
	gPIESetListSizeFDesc.numParams :=  2;			// number of parameters
	gPIESetListSizeFDesc.numOptParams := 0;			// number of optional parameters
	gPIESetListSizeFDesc.paramNames := @gpnIndexSize;       // pointer to parameter names list
	gPIESetListSizeFDesc.paramTypes := @g2Integer;	        // pointer to parameters types list

       	gPIESetListSizeDesc.name  := 'SetListSize';		// name of PIE
	gPIESetListSizeDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIESetListSizeDesc.descriptor := @gPIESetListSizeFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESetListSizeDesc;              // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Get list size
	gPIEGetListCountFDesc.name := 'GetListSize';	        // name of function
	gPIEGetListCountFDesc.address := GPIEGetListCountMMFun;	// function address
	gPIEGetListCountFDesc.returnType := kPIEInteger;		// return value type
	gPIEGetListCountFDesc.numParams :=  1;			// number of parameters
	gPIEGetListCountFDesc.numOptParams := 0;			// number of optional parameters
	gPIEGetListCountFDesc.paramNames := @gpnListIndex;		        // pointer to parameter names list
	gPIEGetListCountFDesc.paramTypes := @gOneIntegerTypes;	                // pointer to parameters types list

       	gPIEGetListCountDesc.name  := 'GetListSize';		// name of PIE
	gPIEGetListCountDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEGetListCountDesc.descriptor := @gPIEGetListCountFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetListCountDesc;              // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // free a new list
	gPIEFreeAListFDesc.name := 'FreeAList';	        // name of function
	gPIEFreeAListFDesc.address := GPIEFreeListMMFun ;	// function address
	gPIEFreeAListFDesc.returnType := kPIEBoolean;		// return value type
	gPIEFreeAListFDesc.numParams :=  1;			// number of parameters
	gPIEFreeAListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeAListFDesc.paramNames := @gpnListIndex;		        // pointer to parameter names list
	gPIEFreeAListFDesc.paramTypes := @gOneIntegerTypes;	                // pointer to parameters types list

       	gPIEFreeAListDesc  .name  := 'FreeAList';		// name of PIE
	gPIEFreeAListDesc  .PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEFreeAListDesc  .descriptor := @gPIEFreeAListFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeAListDesc  ;              // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Add Item to a list
	gPIEAddFDesc.name := 'AddToList';	                // name of function
	gPIEAddFDesc.address := GPIEAddToListMMFun;		// function address
	gPIEAddFDesc.returnType := kPIEInteger;		        // return value type
	gPIEAddFDesc.numParams :=  2;			        // number of parameters
	gPIEAddFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEAddFDesc.paramNames := @gpnIndexValue;		// pointer to parameter names list
	gPIEAddFDesc.paramTypes := @gIntegerDouble;	        // pointer to parameters types list

       	gPIEAddDesc.name  := 'AddToList';		        // name of PIE
	gPIEAddDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEAddDesc.descriptor := @gPIEAddFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAddDesc;                     // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Get Item From list
	gPIEGetFDesc.name := 'GetFromList';	                // name of function
	gPIEGetFDesc.address := GPIEGetFromListMMFun;		// function address
	gPIEGetFDesc.returnType := kPIEFloat;		        // return value type
	gPIEGetFDesc.numParams :=  2;			        // number of parameters
	gPIEGetFDesc.numOptParams := 0;			        // number of optional parameters
	gPIEGetFDesc.paramNames := @gpn2Index;		        // pointer to parameter names list
	gPIEGetFDesc.paramTypes := @g2Integer;	                // pointer to parameters types list

       	gPIEGetDesc.name  := 'GetFromList';		        // name of PIE
	gPIEGetDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIEGetDesc.descriptor := @gPIEGetFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEGetDesc;                     // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Set List Item
	gPIESetListItemFDesc.name := 'SetListItem';	                // name of function
	gPIESetListItemFDesc.address := GPIESetListItemMMFun;		// function address
	gPIESetListItemFDesc.returnType := kPIEBoolean;		        // return value type
	gPIESetListItemFDesc.numParams :=  3;			        // number of parameters
	gPIESetListItemFDesc.numOptParams := 0;			        // number of optional parameters
	gPIESetListItemFDesc.paramNames := @gpn2IndexValue;		        // pointer to parameter names list
	gPIESetListItemFDesc.paramTypes := @g2IntegerValue;	                // pointer to parameters types list

       	gPIESetListItemDesc.name  := 'SetListItem';		        // name of PIE
	gPIESetListItemDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIESetListItemDesc.descriptor := @gPIESetListItemFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIESetListItemDesc;                     // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        // Remove List Item
	gPIERemoveListItemFDesc.name := 'DeleteListItem';	                // name of function
	gPIERemoveListItemFDesc.address := GPIERemoveListItemMMFun;		// function address
	gPIERemoveListItemFDesc.returnType := kPIEBoolean;		        // return value type
	gPIERemoveListItemFDesc.numParams :=  1;			        // number of parameters
	gPIERemoveListItemFDesc.numOptParams := 1;			        // number of optional parameters
	gPIERemoveListItemFDesc.paramNames := @gpn2Index;		        // pointer to parameter names list
	gPIERemoveListItemFDesc.paramTypes := @g2Integer;	                // pointer to parameters types list

       	gPIERemoveListItemDesc.name  := 'DeleteListItem';		        // name of PIE
	gPIERemoveListItemDesc.PieType :=  kFunctionPIE;		        // PIE type: PIE function
	gPIERemoveListItemDesc.descriptor := @gPIERemoveListItemFDesc;	        // pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIERemoveListItemDesc;                     // add descriptor to list
        Inc(numNames);	                                        // increment number of names

        //Free List of lists
	gPIEFreeListFDesc.name := 'FreeAllLists';	                // name of function
	gPIEFreeListFDesc.address := GListFreeMMFun;	        // function address
	gPIEFreeListFDesc.returnType := kPIEBoolean;		// return value type
	gPIEFreeListFDesc.numParams :=  0;			// number of parameters
	gPIEFreeListFDesc.numOptParams := 0;			// number of optional parameters
	gPIEFreeListFDesc.paramNames := nil;		        // pointer to parameter names list
	gPIEFreeListFDesc.paramTypes := nil;	                // pointer to parameters types list

       	gPIEFreeListDesc.name  := 'FreeAllLists';		        // name of PIE
	gPIEFreeListDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEFreeListDesc.descriptor := @gPIEFreeListFDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEFreeListDesc;                // add descriptor to list
        Inc(numNames);	                                        // increment number of names


	descriptors := @gFunDesc;

end;

end.
