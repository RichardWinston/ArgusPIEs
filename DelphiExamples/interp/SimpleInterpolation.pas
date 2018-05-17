unit SimpleInterpolation;

// Save TD32 information and used Turbo debugger to debug.
// Click F3 and enter the name of your dll.
// After Argus ONE has started attach to ArgusONE.dll.
// From the File menu change to the directory with the source code of the PIE.
// Click F3 and double click on your dll
// Click F3 again and loadthe source files.
// You can now set breakpoints in the dll.

interface
// We need to use the appropriate units. In this example, we have an interpolation
// PIE so we need to use InterpolationPIE.pas. All PIE's use AnePIE.
uses
  Dialogs,

  InterpolationPIE, AnePIE;

Type
  TDoubleArray = array[0..32760] of double;
  PDoubleArray = ^TDoubleArray;

  TDataStorage = Class(Tobject)
    Count : integer;
    Data : PDoubleArray;
    Constructor Create(ACount : integer);
    Destructor Destroy; override;
  end;
  TDataStorageRec = record
    Data : TDataStorage;
  end;
  PDataStorage = ^TDataStorageRec;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

procedure GSimplePreInterpolateProc(aneHandle : ANE_PTR;
          var  rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
          xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;

procedure GSimpleInterpolateProc(aneHandle : ANE_PTR;
          pieHandle : ANE_PTR;
          x,  y :ANE_DOUBLE; {var} rResult : ANE_DOUBLE_PTR) ; cdecl;

procedure GSimpleInterpolateCleanProc(aneHandle : ANE_PTR;
          pieHandle : ANE_PTR) ; cdecl;

implementation

const
  kMaxFunDesc = 20;

var

	gSimpleInterpolateIDesc : InterpolationPIEDesc ;
	gSimpleInterpolateDesc : ANEPIEDesc ;
        gFunDesc : Array [0..kMaxFunDesc-1] of ^ANEPIEDesc;


procedure GSimplePreInterpolateProc(aneHandle : ANE_PTR;
                   var rPIEHandle : ANE_PTR_PTR;  numPoints : ANE_INT32 ;
                     xCoords,  yCoords, values : ANE_DOUBLE_PTR) ; cdecl;
{*************************************************************************
**************************************************************************
**
** This function is where 'Pre-Interploate' extension works, that is where the preperation of
** interpolation happens.
**
** The imput parameters are:
**	aneHandler - a handle that you pass to Argus Numerical Environmets API
**	numPoints - number of given data points to interpolate from
**	x	- an array of the x coordiantes of the given data points
**	y	- an array of the y coordinates of the given data points
**	values 	- an array of values of the interpolation points
**
** The output parameters are:
**	aneHandle - a handle to be passed by ArgsuNE to the Interpolate procedure
** and to the Clean procedure
**************************************************************************
*************************************************************************}
var
  i : integer;
  x, y, val : PDoubleArray ;
//  data : PDoubleArray;
  Data : TDataStorage;
  DataStorage : PDataStorage;
begin
{  // In effect, "data" is an array whose dimensions are determined at runtime.
  GetMem(data, (1+3*numPoints)*sizeof(double));
  data^[0] := numPoints;
  x := @xCoords^;
  y := @yCoords^;
  val := @values^;
  for i := 0 to numPoints -1 do
  begin
    data^[i*3+1] := x[i];
    data^[i*3+2] := y[i];
    data^[i*3+3] := val[i];
  end;

  rPIEHandle := @data^; }

  Data := TDataStorage.Create(numPoints);
  GetMem(DataStorage, SizeOf(TDataStorageRec));
  DataStorage^.Data := Data;
  x := @xCoords^;
  y := @yCoords^;
  val := @values^;
  for i := 0 to numPoints -1 do
  begin
    Data.data^[i*3] := x[i];
    Data.data^[i*3+1] := y[i];
    Data.data^[i*3+2] := val[i];
  end;

//  rPIEHandle^ := @DataStorage^;
//  rPIEHandle^ := DataStorage^;
{  rPIEHandle^ := @DataStorage;
  rPIEHandle^ := DataStorage;
  rPIEHandle^ := @Data;
  rPIEHandle^ := Data; }
  rPIEHandle := @DataStorage^;
end;

procedure GSimpleInterpolateProc(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR;
                     x,  y :ANE_DOUBLE; {var} rResult : ANE_DOUBLE_PTR) ; cdecl;
{*************************************************************************
**************************************************************************
**
** This function is where 'Interploate' extension works.
**
** The imput parameters are:
**	aneHandler - a handle that you pass to Argus Numerical Environmets API
**	rPIEHandle - a handle returned by the PreInterpolate function
**	x	- the x coordinate of the point to be interpolated
**	y	- the y coordinat of the point to be interpolated
**
** The output parameters are:
**	result - a pointer to where the result of interpolation should be placed.
**************************************************************************
*************************************************************************/}
var
  i : integer;
  minDistanceSqr :	double  ;
  distanceSqr :	double ;
  curX, curY :	double;
  lastVal :	double ;
//  numPoints : integer;
//  data : PDoubleArray;
  Data : PDataStorage;
begin
{
  data := pieHandle;
  lastVal := 0;
  minDistanceSqr := -1.0;
  numPoints := Round(data^[0]);

  for i := 0 to  numPoints -1 do
  begin
  	curX := data^[i*3+1];
  	curY := data^[i*3+2];
  	distanceSqr := Sqr(x-curX) + Sqr(y-curY);
  	if (minDistanceSqr < 0.0) or (minDistanceSqr > distanceSqr) then
        begin
  		minDistanceSqr := distanceSqr;
  		lastVal := data^[i*3+3];
        end;
  end;

  rResult^ := lastVal;
  }
  data := pieHandle;
  lastVal := 0;
  minDistanceSqr := -1.0;
//  numPoints := Round(data^[0]);

  for i := 0 to  Data^.data.Count -1 do
  begin
  	curX := Data^.data.data^[i*3];
  	curY := Data^.data.data^[i*3+1];
  	distanceSqr := Sqr(x-curX) + Sqr(y-curY);
  	if (minDistanceSqr < 0.0) or (minDistanceSqr > distanceSqr) then
        begin
  		minDistanceSqr := distanceSqr;
  		lastVal := Data^.data.data^[i*3+2];
        end;
  end;

  rResult^ := lastVal;

end;

procedure GSimpleInterpolateCleanProc(aneHandle : ANE_PTR;
                    pieHandle : ANE_PTR) ; cdecl;
{*************************************************************************
**************************************************************************
**
** This function should clean any memory allocated by the PreInterpolate function
**
** The imput parameters are:
**	aneHandler - a handle that you pass to Argus Numerical Environmets API
**	pieHandle - a handle returned by the PreInterpolate function
**************************************************************************
*************************************************************************}
var
//  numPoints : integer;
//  data : PDoubleArray;
  Data : PDataStorage;
begin
{
  data := pieHandle;
  numPoints := Round(data[0]);
  FreeMem (data, (1+3*numPoints)*sizeof(double));
  }
  data := pieHandle;
  Data^.Data.Free;
  FreeMem(Data);
end;

procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
begin

	numNames := 0;

	gSimpleInterpolateIDesc.version := INTERPOLATION_PIE_VERSION;
	gSimpleInterpolateIDesc.name := 'Delphi SimpleInterpolate';
	gSimpleInterpolateIDesc.interpolationFlags := (kInterpolationCallPre or kInterpolationShouldClean);
	gSimpleInterpolateIDesc.preProc := GSimplePreInterpolateProc;
	gSimpleInterpolateIDesc.evalProc := GSimpleInterpolateProc;
	gSimpleInterpolateIDesc.cleanProc := GSimpleInterpolateCleanProc;

	gSimpleInterpolateDesc.name  := 'Delphi SimpleInterpolate';
	gSimpleInterpolateDesc.PieType :=  kInterpolationPIE;
	gSimpleInterpolateDesc.descriptor := @gSimpleInterpolateIDesc;

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}
	Assert (numNames < kMaxFunDesc) ;
	gFunDesc[numNames] := @gSimpleInterpolateDesc;
        Inc(numNames);	// add descriptor to list

	descriptors := @gFunDesc;

end;

{ TDataStorage }

constructor TDataStorage.Create(ACount: integer);
begin
  inherited Create;
  Count := ACount;
  GetMem(data, (3*Count)*sizeof(double));
end;

destructor TDataStorage.Destroy;
begin
  FreeMem(Data);
  inherited;
end;

end.
