unit AnePIE;

interface

const ANE_PIE_VERSION = 2;

type
    ANE_INT32 = LongInt;
    ANE_INT16 = Smallint;
    ANE_BOOL = LongBool;
    ANE_DOUBLE = double ;
    ANE_STR = PChar;
// typedef const char *ANE_CSTR;
// there is no exact Object Pascal equivalent to ANE_CSTR. However,
// you can use "const ANE_STR" to achieve the same effect except where
// the ANE_CSTR is the result of a function.
    ANE_PTR = Pointer;
// typedef const void *ANE_CPTR;
// there is no exact Object Pascal equivalent to ANE_CPTR. However,
// you can use "const ANE_PTR" to achieve the same effect except where
// the ANE_CPTR is the result of a function.
    GenericPIECall = procedure  ; cdecl;

    ANE_INT32_PTR = ^ANE_INT32 ;
    ANE_STR_PTR = ^ANE_STR;
    ANE_PTR_PTR = ^ANE_PTR;
    ANE_BOOL_PTR = ^ANE_BOOL;
    ANE_DOUBLE_PTR = ^ANE_DOUBLE;
    ANE_DOUBLE_PTR_PTR = ^ANE_DOUBLE_PTR;
    ANE_INT32_PTR_PTR = ^ANE_INT32_PTR ;
    ANE_INT16_PTR = ^ANE_INT16;
{
typedef void (*GenericPIECall)();	/* generic PIE function call */
}

type ANEPointRec = record
       x : ANE_DOUBLE;
       y : ANE_DOUBLE;
     end;

var ANE_POINT : ANEPointRec;

type ANE_POINT_PTR = ^ANEPointRec;
// typedef const struct ANEPointRec * ANE_POINT_CPTR;
// there is no exact Object Pascal equivalent to ANE_POINT_CPTR. However,
// you can use "const ANE_POINT_PTR" to achieve the same effect except where
// the ANE_POINT_CPTR is the result of a function.

const    kFunctionPIE	       = $0001;		{/* type of PIE function */}
const    kImportPIE	       = $0002;
const    kRenumberPIE	       = $0004;
const    kExportTemplatePIE    = $0008;
const    kProjectPIE	       = $0010;
const    kInterpolationPIE     = $0020;
// the closest equivalent of EPIEType in Object Pascal is integer but
// only the predefined values of kFunctionPIE to kInterpolationPIE should be
// used. You can use "or" with them to select multiple values.
Type EPIEType = LongInt;

Type  EPIENumberType = longint;
      EPIENumberType_PTR = ^EPIENumberType ;
const    kPIEBoolean  = $0010;
const    kPIEInteger  = $0020;
const    kPIEFloat    = $0030;
const    kPIEString   = $1040;
const    kPIENA       = $0032;
// the closest equivalent of EPIENumberType in Object Pascal is integer but
// only the predefined values of kPIEBoolean to kPIENA should be
// used. You can use "or" with them to select multiple values.
//Type  EPIENumberType = Smallint;

const    kPIEContourObject      = $0001;
const    kPIEBlockObject        = $0002;
const    kPIEElementObject      = $0004;
const    kPIENodeObject         = $0008;
const    kPIEPictObject         = $0010;
Type  EPIEObjectType = LongInt;
// the closest equivalent of EPIEObjectType in Object Pascal is integer but
// only the predefined values of kPIEContourObject to kPIEPictObject should be
// used. You can use "or" with them to select multiple values.

const     kPIETriMeshLayer      = $1  ;
const     kPIEQuadMeshLayer     = $2  ;
const     kPIEInformationLayer	= $4  ;
const     kPIEGridLayer		= $8  ;
const     kPIEDataLayer		= $10 ;
const     kPIEMapsLayer	        = $20 ;
const     kPIEDomainLayer	= $40 ;
const     kPIEAnyLayer	        = $ffff;	{/* since version 2 */}
// the closest equivalent of EPIELayerType in Object Pascal is integer but
// only the predefined values of kPIETriMeshLayer to kPIEAnyLayer should be
// used. You can use "or" with them to select multiple values.
Type  EPIELayerType = LongInt;

const     kPIENullSubParam	      = $0000;
const     kPIELayerSubParam	      = $0010;
const     kPIEMeshLayerSubParam	      = $0011;
const     kPIEGridLayerSubParam	      = $0012;
const     kPIEContourLayerSubParam    = $0013;
const     kPIEPictLayerSubParam	      = $0014;
const     kPIEElemSubParam	      = $0020;
const     kPIENodeSubParam	      = $0040;
const     kPIEBlockSubParam	      = $0080;
const     kPIEVertexSubParam	      = $0100;
const     kPIEGeneralSubParam	      = $7FFF;
// the closest equivalent of EPIEParameterType in Object Pascal is integer but
// only the predefined values of kPIENullSubParam to kPIEGeneralSubParam should be
// used. You can use "or" with them to select multiple values.
Type  EPIEParameterType = LongInt;

 ANEPIEDesc = record
    version    : ANE_INT32   ;
    vendor    : ANE_STR	     ;
    product   : ANE_STR	     ;
    name      : ANE_STR	     ;
    PieType    : EPIEType    ;
    descriptor : ANE_PTR     ;
 end;

 Type ANEPIEDescPtr = ^ANEPIEDesc ;
 Type ANEPIEDescPtrPtr = ^ANEPIEDescPtr ;
 Type ANEPIEDescPtrPtrPtr = ^ANEPIEDescPtrPtr ;

//#ifdef __cplusplus
//extern "C" {
//typedef void (*GetANEFunctionsPtr)(ANE_INT32& numNames, ANEPIEDesc**& descriptors);
//}
//#else
//typedef void (*GetANEFunctionsPtr)(ANE_INT32* numNames, struct ANEPIEDesc*** descriptors);
//#endif


 type GetANEFunctionsPtr = procedure ( numNames : ANE_INT32_PTR;
  var descriptors :  ANEPIEDescPtrPtrPtr); cdecl;


implementation

end.
