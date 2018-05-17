unit ParamArrayUnit;

interface

{ParamArrayUnit defines the array of parameters used in PIE functions.}

type
  TParameter_array = array[0..32760] of pointer;
  PParameter_array = ^TParameter_array;

implementation

end.
