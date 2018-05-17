unit AnePIE;

interface

const ANE_PIE_VERSION = 2;

type
    ANE_INT32 = LongInt;
    ANE_INT16 = Smallint;
    ANE_BOOL = LongBool;
    ANE_DOUBLE = double ;
    ANE_STR = PChar;
    ANE_PTR = Pointer;
    GenericPIECall = procedure  ; cdecl;

    ANE_INT32_PTR = ^ANE_INT32 ;
    ANE_INT16_PTR = ^ANE_INT16 ;
    ANE_STR_PTR = ^ANE_STR;
    ANE_PTR_PTR = ^ANE_PTR;
    ANE_BOOL_PTR = ^ANE_BOOL;
    ANE_DOUBLE_PTR = ^ANE_DOUBLE;
    ANE_DOUBLE_PTR_PTR = ^ANE_DOUBLE_PTR;
    ANE_INT32_PTR_PTR = ^ANE_INT32_PTR ;


type
 ANEPointRec = record
   x: ANE_DOUBLE;
   y: ANE_DOUBLE;
 end;

type ANE_POINT_PTR = ^ANEPointRec;

{
typedef void (*GenericPIECall)();	/* generic PIE function call */
 }



const    kFunctionPIE	        = $0001;		{/* type of PIE function */}
const    kImportPIE		= $0002;
const    kRenumberPIE	        = $0004;
const    kExportTemplatePIE	= $0008;
const    kProjectPIE		= $0010;
const    kInterpolationPIE	= $0020;
//const EPIEType : set of  kFunctionPIE..kInterpolationPIE = [kFunctionPIE, kImportPIE, kRenumberPIE, kExportTemplatePIE, kProjectPIE, kInterpolationPIE];
Type EPIEType = integer;

const    kPIEBoolean = $0010;
const    kPIEInteger = $0020;
const    kPIEFloat   = $0030;
const    kPIEString  = $1040;
const    kPIENA	     = $0032;

//const EPIENumberType : set of  kPIEBoolean..kPIEString = [kPIEBoolean, kPIEInteger, kPIEFloat, kPIEString];
Type  EPIENumberType = integer;
      EPIENumberType_PTR = ^EPIENumberType ;

const    kPIEContourObject		= $0001;
const    kPIEBlockObject			= $0002;
const    kPIEElementObject		= $0004;
const    kPIENodeObject			= $0008;
const    kPIEPictObject			= $0010;

Type  EPIEObjectType = integer;
      EPIEObjectType_PTR = ^EPIEObjectType ;



const     kPIETriMeshLayer      = $1  ;
const     kPIEQuadMeshLayer     = $2  ;
const     kPIEInformationLayer	= $4  ;
const     kPIEGridLayer		= $8  ;
const     kPIEDataLayer		= $10 ;
const     kPIEMapsLayer	        = $20 ;
const     kPIEDomainLayer	= $40 ;
const     kPIEAnyLayer	        = $ffff;	{/* since version 2 */}
//const EPIELayerType : set of  kPIETriMeshLayer..kPIEAnyLayer = [kPIETriMeshLayer, kPIEQuadMeshLayer, kPIEInformationLayer, kPIEGridLayer, kPIEDataLayer, kPIEMapsLayer, kPIEDomainLayer, kPIEAnyLayer];
Type  EPIELayerType = integer;

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
//const EPIEParameterType : set of  kPIENullSubParam..kPIEGeneralSubParam = [ kPIENullSubParam, kPIELayerSubParam, kPIEMeshLayerSubParam, kPIEGridLayerSubParam, kPIEContourLayerSubParam, kPIEPictLayerSubParam, kPIEElemSubParam, kPIENodeSubParam, kPIEBlockSubParam, kPIEVertexSubParam, kPIEGeneralSubParam];
Type  EPIEParameterType = integer;

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
