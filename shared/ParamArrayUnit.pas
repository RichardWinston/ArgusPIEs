unit ParamArrayUnit;

interface

{ParamArrayUnit defines the array of parameters used in PIE functions.}

type
  TParameter_array = array[0..MAXINT div 8] of pointer;
  PParameter_array = ^TParameter_array;

implementation

end.
