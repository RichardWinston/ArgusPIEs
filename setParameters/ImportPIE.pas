unit ImportPIE;

//==============================================================================
//
//	File: ImportPIE.pas
//
//	Copyright © 1993-96 Argus Holdings Ltd.  All rights reserved.
//
//==============================================================================
//
// Version Information:
//	12/11/96 - version 2. Add kImportAllwaysVisible.
//
//============================================================================*/

interface

uses AnePIE;

const IMPORT_PIE_VERSION = 2;

// #ifdef __cplusplus
// extern "C" {
// #endif
// typedef void (*PIEImportProc)(ANE_PTR aneHandle, const ANE_STR fileName, ANE_PTR layerHandle);
// #ifdef __cplusplus
// }
// #endif

type
    PIEImportProc = procedure (aneHandle : ANE_PTR;
                  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;

const     kImportFromFile                = $1 ;
const     kImportFromLayer               = $2 ;
const     kImportNeedsProject            = $4 ;
const     kImportAllwaysVisible          = $8 ;
Type EImportPIEFlags = integer;

ImportPIEDesc = record
   	version  :		 ANE_INT32             ;
	name  :		         ANE_STR               ;
	importFlags :		  EImportPIEFlags  ;
        toLayerTypes :	          EPIELayerType    ;
        fromLayerTypes :	  EPIELayerType    ;
	doImportProc :		 PIEImportProc         ;
	neededProject :		 ANE_STR               ;
  end;

implementation

end.
