unit functionUnit;

interface

uses Dialogs, SysUtils,

  AnePIE, FunctionPie;

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
  
procedure GPIEAbsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

implementation

uses ANECB;

const
  kMaxFunDesc = 20;

var

        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;

        gPIEAbsDesc : ANEPIEDesc;
        gPIEAbsFDesc :  FunctionPIEDesc;

const   gpnNumber : array [0..1] of PChar = ('Number', nil);
const   gOneFloatTypes : array [0..1] of EPIENumberType = (kPIEFloat, 0);

procedure GPIEAbsMMFun (const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				myHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
const
  LayerName : ANE_STR = 'QuadMesh';
var
  result : ANE_INT32;
  LayerHandle : ANE_PTR;
  ObjectHandle : ANE_PTR;
  ObjectCount : integer;
  X, Y : ANE_DOUBLE;
begin
  try
    // get the handle of 'New Layer';
    LayerHandle := ANE_LayerGetHandleByName(myHandle, LayerName);

    if LayerHandle = nil then
    begin
      result := -1;
      Beep;
      ShowMessage('Sorry, the layer "' + LayerName + '" does not exist');
    end
    else
    begin
      ObjectCount := ANE_LayerGetNumObjects(myHandle, LayerHandle,
        kPIEElementObject);

      Beep;
      ShowMessage('There are ' + IntToStr(ObjectCount) + ' elements on '
        + LayerName);

      ObjectHandle := ANE_LayerGetNthObjectHandle (myHandle,
         LayerHandle, kPIEElementObject, 1);

      if ObjectHandle = nil then
      begin
        result := -1;
        Beep;
        ShowMessage('Sorry, there is no elements on"' + LayerName
          + '" with the index "1"');
      end
      else
      begin

        result := ANE_ElementObjectGetNumNodes(myHandle,LayerHandle,
          ObjectHandle);

        Beep;
        ShowMessage('The number of nodes is ' + IntToStr(result));

        ANE_ElementObjectGetNthNodeLocation(myHandle,LayerHandle,
          ObjectHandle, 1, @x, @y);

        ShowMessage('The first node is at ' + FloatToStr(X) + ', '
          + FloatToStr(Y));
      end;
    end;

  except on E: Exception do
    begin
      Beep;
      result := -1;
      ShowMessage(E.Message);
    end;
  end;

//  result := Abs(param1);  // you could just have result := Abs(param1_ptr^)
  ANE_INT32_PTR(reply)^ := result;
end;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;

	gPIEAbsFDesc.name := 'Delphi_PIE_NodeCount';	        // name of function
	gPIEAbsFDesc.address := GPIEAbsMMFun;		// function address
	gPIEAbsFDesc.returnType := kPIEInteger;		// return value type
	gPIEAbsFDesc.numParams :=  0;			// number of parameters
	gPIEAbsFDesc.numOptParams := 0;			// number of optional parameters
	gPIEAbsFDesc.paramNames := nil;		// pointer to parameter names list
	gPIEAbsFDesc.paramTypes := nil;	// pointer to parameters types list

       	gPIEAbsDesc.name  := 'Delphi_PIE_NodeCount';		// name of PIE
	gPIEAbsDesc.PieType :=  kFunctionPIE;		// PIE type: PIE function
	gPIEAbsDesc.descriptor := @gPIEAbsFDesc;	// pointer to descriptor
	
        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gPIEAbsDesc;  // add descriptor to list
        Inc(numNames);	// increment number of names

	descriptors := @gFunDesc;

end;

end.
