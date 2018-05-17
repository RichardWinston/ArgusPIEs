unit ExportTemplatePIE;

//==============================================================================
// 
//	File: ExportTemplatePIE.pas
//
//
//	Argus Numerical Environments - Plug In Extension, Release 1.0
// 
//	Copyright © 1996 Argus Holdings Ltd.  All rights reserved.
//
// THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF Argus Holdings Ltd..
// The copyright notice above does not evidence any
// actual or intended publication of such source code
//============================================================================*/

interface

uses AnePIE;

type
    PIEExportGetTemplate = procedure (aneHandle : ANE_PTR;
                    returnTemplate : ANE_STR_PTR) ; cdecl;

    PIEExportCallBack = procedure ( aneHandle: ANE_PTR); cdecl;

const       kExportDontShowParamDialog = $1;
const       kExportDontShowFileDialog =  $2;
const       kExportCallPreExport = $4;
const       kExportCallPostExport = $8;
const       kExportDontGetTemplate = $10;
const       kExportNeedsProject		= $20;

type   EExportTemplateFlags = integer;

ExportTemplatePIEDesc = record

     version		:       ANE_INT32                       ;
     name		:       ANE_STR                         ;
     exportType		:       {enum} EPIELayerType              ;
     exportFlags	:	{enum} EExportTemplateFlags       ;
     getTemplateProc	:	PIEExportGetTemplate            ;
     preExportProc	:	PIEExportCallBack               ;
     postExportProc	:	PIEExportCallBack               ;
     neededProject	:	ANE_STR                         ;
end;
 { FunctionPIEDesc }


implementation

end.
