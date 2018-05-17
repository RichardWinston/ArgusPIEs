unit ProjectPIE;

//*==============================================================================
//
//	File: ProjectPIE.h
//
//	Argus Open Numerical Environments - Plug In Extension, Release 1.1
//
//	Copyright © 1996-98 Argus Holdings Ltd.  All rights reserved.
//
//		THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF Argus Holdings Ltd..
//		The copyright notice above does not evidence any
//		actual or intended publication of such source code
//
//==============================================================================
//
// Update information:
//	09/10/96 - Version 2. Return type added for PIEProjectNew and PIEProjectEdit to
//							allow cancel
//
//	01/10/99 - Version 3. Add Object Info Dialog (OID) function
//
//==============================================================================*/

interface

uses AnePIE;

const PROJECT_PIE_VERSION = 3;

type
  PIEProjectNew   = function (aneHandle : ANE_PTR ;
    rPIEHandle :  ANE_PTR_PTR ;
    returnLayerTemplate : ANE_STR_PTR  ) : ANE_BOOL ; cdecl;

  PIEProjectEdit  = function (aneHandle : ANE_PTR ;
    PIEHandle  :  ANE_PTR  ) : ANE_BOOL ; cdecl;

  PIEProjectClean = procedure (aneHandle : ANE_PTR ;
    PIEHandle  :  ANE_PTR  ); cdecl;

  PIEProjectSave  = procedure (aneHandle : ANE_PTR ; PIEHandle  :  ANE_PTR  ;
    rSaveInfo : ANE_STR_PTR ); cdecl;

  PIEProjectLoad  = procedure (aneHandle : ANE_PTR ;
    rPIEHandle :  ANE_PTR_PTR ; const LoadInfo : ANE_STR ); cdecl;

  PIEProjectOIDFun = function(aneHandle : ANE_PTR ; PIEHandle  :  ANE_PTR;
    request : ANE_INT32; layer : ANE_PTR; paramType : EPIEParameterType;
    numParametrs : ANE_INT32; parameters : ANE_INT32_PTR;
    curParamIndex: ANE_INT32; numSelectedObjects : ANE_INT32 ;
    selectedObjects : ANE_PTR_PTR; curObjectIndex : ANE_INT32;
    ptr : ANE_PTR_PTR) : ANE_INT32;  cdecl;

// OID function:
//
//  to customize the Object Info Dialog, provide an OID function in the Project PIE Descriptor.
//
//	OID Function fields:
//		ANE_PTR aneHandle: the usual ANE handle used for callback functions.
//		ANE_PTR PIEHandle: a handle to Project PIE data storage, the same handle PIEProjectNew returned.
//		ANE_INT32 request: the current request, one of EProjectPIEOID as defined  below.
//		ANE_PTR layer: the current layer.
//		EPIEParameterType paramType: The current parameter type (node, block, etc.)
//		ANE_INT32 numParametrs: number of parameters associated with info-dialog box
//		ANE_INT32* parameters: an array of parameter indices.
//		ANE_INT32 curParamIndex: the index into 'parameters' array of the current selected parameter.
//		ANE_INT32 numSelectedObjects: number of selected objects.
//		ANE_PTR* selectedObjects: an array of pointers to the selected objects.
//		ANE_INT32 curObjectIndex: the index into 'selectedObjects' array of the current object.
//		ANE_PTR* ptr: a generic pointer used to comunicate with Argus ONE (see below).
//
//	this function will be called once BEFORE the dialog is shown with the request 'kOIDWhatToDo'
//	the PIE can leave ANE to display the dialog without any change (by replying 'kOIDDoNormal').
//	the PIE can display it's own dialog and return ANE 'kOIDDoNothing' causing ANE to skip the dialog
//	altogether. or the PIE can request to add a button, by giving in 'ptr' a pointer to a null
//	terminated string. reply with 'kOIDDoAddButtonConstString' if the string is a static one, or with
//	'kOIDDoAddButtonDynString' if you wnat ANE to discard the string using ANE_MemDelete.
//	
//	whenever the dialog is about to display information pertainning a new object, a 'kOIDShouldHiliteButton'
//	request is issued. your oidProc should reply with 'true' in order to enable the PIE button,
//	or 'false' in order to dissable it.
//
//	when the user clicks the button, your oidProc is called again, this time with 'kOIDButton' request.
//
//	before closing the dialog you'll get a chance for some cleanup when a 'kOIDCleanup' request is
//	issued. 'ptr' will point to an ANE_BOOL telling whether the user replyed OK ('true') or
//	cancel ('false').

const  kProjectDisplaysDialog	  	= $1  ;
const  kProjectShouldSave	     	= $2  ;
const  kProjectCanEdit		  	= $4  ;
const  kProjectShouldClean	     	= $8  ;
const  kCallEditAfterNewProject	     	= $10 ;

type EProjectPIEFlags = integer;

type EProjectPIEOID = (
  kOIDWhatToDo,			     // ANE asks the PIE how to handle user double-click on object
  	kOIDDoNormal,		             // PIE answers, behave normally, I'm not interested
  	kOIDDoNothing,		             // PIE answers, do nothing more, I already handled everything (displayed dialog, modified objects' values, etc.)
  	kOIDDoAddButtonConstString,          // PIE answers, add a button. button title is given in 'ptr' as a const null-terminated string
  	kOIDDoAddButtonDynString,            // PIE answers, add a button. button title is given in 'ptr' as a heap allocated null-terminated string. ANE will call ANE_MemDelete to deallocate string at the end

  kOIDShouldHiliteButton,		     // ANE asks the PIE whether to hilite or deactivate the PIE button,
  				     // reply 'true' to enable ot 'false' to dimm the button.
  				     // this request will be issued when the user travels back an forth between selected objects

  kOIDButton,			     // after receiving 'kOIDDoAddButton...', ANE will call the function with this request whenever the user clicks the button

  kOIDCleanup			     // cleanup before closing the dialog box
);


ProjectPIEDesc = record
    version            :    ANE_INT32		     ;
    name               :    ANE_STR		     ;
    projectFlags       :    EProjectPIEFlags         ;
    createNewProc      :    PIEProjectNew	     ;
    editProjectProc    :    PIEProjectEdit	     ;
    cleanProjectProc   :    PIEProjectClean	     ;
    saveProc           :    PIEProjectSave	     ;
    loadProc           :    PIEProjectLoad	     ;
    oidProc            :    PIEProjectOIDFun         ;
end;

implementation

end.
