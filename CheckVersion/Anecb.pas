unit ANECB;

//{==============================================================================
//
//	File: ANECB.h
//
//	Argus Numerical Environments - Plug In Extension, Release 1.0
//
//	Copyright © 1998 Argus Holdings Ltd.  All rights reserved.
//
//		THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF Argus Holdings Ltd..
//		The copyright notice above does not evidence any
//		actual or intended publication of such source code
//
//==============================================================================}

interface

uses
  AnePIE;


{In cases where the functions or procedures have been translated to Object
Pascal but not tested, the function declarations have been commented out
and are followed by the original C++ declarations. It would be wise to check
that the translations are correct before relying on the translated functions.
The original comments from C++ are copied after the C++ declaration. In some
cases a function with a pointer return type is described as returning "0" under
certain circumstances. The Object Pascal equivalent in such cases is "nil".}

{ Basic calls }
{==========}




procedure ANE_GetVersion(const aneHandle : ANE_PTR ; major : ANE_INT32_PTR ;
  minor : ANE_INT32_PTR ; update : ANE_INT32_PTR ; versionBuf : ANE_STR ;
  bufLen : ANE_INT32 );
          cdecl; external 'ANECB.dll' name 'ANE_GetVersion';

{void ANE_GetVersion(ANE_PTR aneHandle, int* major, int* minor, int* update,
  char* versionBuf, int bufLen);}
	{ get version information for the ArgusNE application }


procedure ANE_GetPIEProjectHandle(aneHandle : ANE_PTR ; pieHandle : ANE_PTR_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_GetPIEProjectHandle';

{void ANE_GetPIEProjectHandle(ANE_PTR aneHandle, ANE_PTR* pieHandle);}
	{ get a pointer to the private information of the current document's Project }

procedure ANE_ProcessEvents(aneHandle : ANE_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_ProcessEvents';

{void ANE_ProcessEvents(ANE_PTR aneHandle);}
	{ give a chance to ArgusNE and the rest of the system to handle user events }


procedure ANE_MakeDirty(aneHandle : ANE_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_MakeDirty';

{void ANE_MakeDirty(ANE_PTR aneHandle);}
	{ mark that the document was touched (turn on Save menu etc. ) }

procedure ANE_ImportTextToLayer(handle : ANE_PTR ;  textToImport : ANE_STR);
          cdecl; external 'ANECB.dll' name 'ANE_ImportTextToLayer';
	{ calls the current layer to import the text in 'textToImport' as an import file }

procedure ANE_ExportTextFromOtherLayer(handle : ANE_PTR ; layerHandle : ANE_PTR ;
          textExported : ANE_STR_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_ExportTextFromOtherLayer';

{void ANE_ExportTextFromOtherLayer(ANE_PTR handle, ANE_PTR layerHandle, ANE_STR* textExported);}
	{ calls the layer pointed by 'layerHandle' to export it's information into 'textExported' pointer }

{ Memory allocation functions }

{
function ANE_MemAlloc(handle : ANE_PTR ; size : ANE_INT32 ) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_MemAlloc';
}
{ANE_PTR ANE_MemAlloc(ANE_PTR handle, ANE_INT32 size);}
	{ allocate size bytes of memory }

{In the following declaration "ptr" has been changed to "aPtr" to avoid
confusion with the Ptr function.}
{
procedure ANE_MemDelete(handle : ANE_PTR ; aPtr : ANE_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_MemDelete';
}
{void ANE_MemDelete(ANE_PTR handle, ANE_PTR ptr);}
	{ delete chunk of memory }


{ Protection functions }
{================}
{
procedure ANE_ProtGetRegCode(handle : ANE_PTR ; regCodeBuf : ANE_STR ; bufLen : ANE_INT32 );
          cdecl; external 'ANECB.dll' name 'ANE_ProtGetRegCode';
}
{void ANE_ProtGetRegCode(ANE_PTR handle, ANE_STR regCodeBuf, ANE_INT32 bufLen);}
	{ return into regCodeBuf min(regcode length, bufLen-1) characters of the RegCode }

{
procedure ANE_ProtGetUniqueID(handle : ANE_PTR ; uniqueIDBuf : ANE_STR ; bufLen : ANE_INT32 );
          cdecl; external 'ANECB.dll' name 'ANE_ProtGetUniqueID';
}
{void ANE_ProtGetUniqueID(ANE_PTR handle, ANE_STR uniqueIDBuf, ANE_INT32 bufLen);}
	{ return into uniqueIDBuf min(unique id  length, bufLen-1) characters of the Worksstation Unique ID }

{ Directory and file functions }

{
function ANE_DirectoryGet(handle : ANE_PTR ; caption : ANE_STR ;
         path : ANE_STR ; dirBuf : ANE_STR ; bufLen : ANE_INT32 ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_DirectoryGet';
}
{ANE_BOOL ANE_DirectoryGet(ANE_PTR handle, ANE_STR caption, ANE_STR path, ANE_STR dirBuf, ANE_INT32 bufLen);}
	{ pop a dialog to the user, allowing selection of a directory. return true if directory was
		selected, false if directory was not selected. If directory was selected, a null terminated string is returned in buf }
{
function ANE_FileGet(handle : ANE_PTR ; caption : ANE_STR ; path : ANE_STR ;
         defName : ANE_STR ; forExport : ANE_BOOL ; dirBuf : ANE_STR ;
         bufLen : ANE_INT32 ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_FileGet';
}
{ANE_BOOL ANE_FileGet(ANE_PTR handle, ANE_STR caption, ANE_STR path, ANE_STR defName, ANE_BOOL forExport, ANE_STR dirBuf, ANE_INT32 bufLen);}
	{ pop a dialog to the user, allowing selection of a file. return true if a file was
		selected, false if no file was selected. If file was selected, a null terminated string is returned in buf }
{
function ANE_FileGetEx(handle : ANE_PTR ; caption : ANE_STR ; path : ANE_STR ;
         defName : ANE_STR ; forExport : ANE_BOOL ; dirBuf : ANE_STR ;
         bufLen : ANE_INT32 ; extensionMask : ANE_STR ; extensionCaption : ANE_STR ;
         macType : ANE_INT32 ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_FileGetEx';
}
{ANE_BOOL ANE_FileGetEx(ANE_PTR handle, ANE_STR caption, ANE_STR path, ANE_STR defName, ANE_BOOL forExport, ANE_STR dirBuf, ANE_INT32 bufLen, ANE_STR extensionMask, ANE_STR extensionCaption, ANE_INT32 macType);}
	{ pop a dialog to the user, allowing selection of a file. return true if a file was
		selected, false if no file was selected. If file was selected, a null terminated string is returned in buf ,
		The default extenstion of the file is defined by extensionMask, and described by extensionCaption.
		macType is used to select the files on the macintosh, where extensions don't apply }

{
procedure ANE_DirectorySetCurrent(handle : ANE_PTR ; currentDirectory : ANE_STR );
          cdecl; external 'ANECB.dll' name 'ANE_DirectorySetCurrent';
}
{void ANE_DirectorySetCurrent(ANE_PTR handle, ANE_STR currentDirectory);}
	{ set the current directory }


procedure ANE_DirectoryGetCurrent(handle : ANE_PTR ; buf : ANE_STR ; bufLen : ANE_INT32 );
          cdecl; external 'ANECB.dll' name 'ANE_DirectoryGetCurrent';

{void ANE_DirectoryGetCurrent(ANE_PTR handle, ANE_STR buf, ANE_INT32 bufLen);}
	{ return the name of the directory }


{ Layer Handling callbacks }
{===================}


function ANE_LayerGetHandleByName(handle : ANE_PTR ; name : ANE_STR ) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetHandleByName';

{ANE_PTR ANE_LayerGetHandleByName(ANE_PTR handle, ANE_STR name);}
	{ return a handle for the layer with the name 'name', nil if no layer with that name }


function ANE_LayerAddByTemplate(handle : ANE_PTR ; layerTemplate : ANE_STR ;
         afterLayerHandle : ANE_PTR ) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_LayerAddByTemplate';

{ANE_PTR ANE_LayerAddByTemplate(ANE_PTR handle, ANE_STR layerTemplate, ANE_PTR afterLayerHandle);}
	{ parse a Layer Definition Language template, and adds a layer.
			New layers will be added after 'afterLayerHandle',
                        if 'afterLayerHandle' is zero, new layers will be added at the end of the layers list.
			If a layers were added, return the handle to the first added layer.
			If parsing failed, returns nil }


procedure ANE_LayerAddParametersByTemplate(handle : ANE_PTR ;
          atLayerHandle : ANE_PTR ; paramsTemplate : ANE_STR ;
          afterParameter : ANE_INT32 );
          cdecl; external 'ANECB.dll' name 'ANE_LayerAddParametersByTemplate';

{void ANE_LayerAddParametersByTemplate(ANE_PTR handle, ANE_PTR atLayerHandle, ANE_STR paramsTemplate, ANE_INT32 afterParameter);}
	{ parse a Layer Definition Language template containing only parameters, and addthem to 'atLayerHandle'.
			New parameters will be added after 'afterParameter', if 'afterParameter' is negative,
			new parameters will be added at the end of the parameters list. }


function ANE_LayerClear(handle : ANE_PTR ; layerHandle : ANE_PTR ;
         selectedOnly : ANE_BOOL ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerClear';

{ANE_BOOL ANE_LayerClear(ANE_PTR handle,  ANE_PTR layerHandle, ANE_BOOL selectedOnly);}
	{ clear all objects in the specified layer. Returns true if there were objects in
		the layer, return false if no objects were cleared.}


function ANE_LayerRemove(handle : ANE_PTR ; layerHandle : ANE_PTR ;
         forceRemoval : ANE_BOOL ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerRemove';

{ANE_BOOL ANE_LayerRemove(ANE_PTR handle, ANE_PTR layerHandle, ANE_BOOL forceRemoval);}
	{ remove the specified layer. If forceRemoval is TRUE, remove the layer even
		if it is a geographic layer that other layer is using. Return TRUE if a layer was removed}


function ANE_LayerRename(aneHandle : ANE_PTR ; layerHandle : ANE_PTR ;
         newName : ANE_STR ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerRename';

{ANE_BOOL ANE_LayerRename(ANE_PTR aneHandle, ANE_PTR layerHandle, ANE_STR newName);}
	{ if the layer is renamed, return TRUE}


function ANE_LayerGetNumParameters(aneHandle : ANE_PTR ; layerHandle : ANE_PTR ;
          parameterType : EPIEParameterType ) : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetNumParameters';

{ANE_INT32 ANE_LayerGetNumParameters(ANE_PTR aneHandle, ANE_PTR layerHandle, enum EPIEParameterType parameterType);}
	{ return the number of parameter of the layer}


function ANE_LayerGetParameterByName(aneHandle : ANE_PTR ;
         layerHandle : ANE_PTR ; parameterName : ANE_STR ) : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetParameterByName';

{ANE_INT32 ANE_LayerGetParameterByName(ANE_PTR aneHandle, ANE_PTR layerHandle, ANE_STR parameterName);}
	{ return the index of the parameter with the given  layer, return -1}


function ANE_LayerRemoveParameter(aneHandle : ANE_PTR ; layerHandle : ANE_PTR ;
         parameterIndex : ANE_INT32 ; forceRemoval : ANE_BOOL ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerRemoveParameter';

{ANE_BOOL ANE_LayerRemoveParameter(ANE_PTR aneHandle, ANE_PTR layerHandle, ANE_INT32 parameterIndex, ANE_BOOL forceRemoval);}
	{ remove the specified parameter. If forceRemoval is TRUE, remove the parameter even
		if is is used by other layers. Return TRUE if a parameter was removed}


function ANE_LayerRenameParameter(aneHandle : ANE_PTR ; layerHandle : ANE_PTR ;
         parameterIndex : ANE_INT32 ; newParameterName : ANE_STR ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerRenameParameter';

{ANE_BOOL ANE_LayerRenameParameter(ANE_PTR aneHandle, ANE_PTR layerHandle, ANE_INT32 parameterIndex, ANE_STR newParameterName);}
	{ if the parameter was renamed, return TRUE}


procedure ANE_LayerSetParameterExpression(aneHandle : ANE_PTR ;
          layerHandle : ANE_PTR ; parameterIndex : ANE_INT32 ;
          newParameterExpression : ANE_STR );
          cdecl; external 'ANECB.dll' name 'ANE_LayerSetParameterExpression';

{void ANE_LayerSetParameterExpression(ANE_PTR aneHandle, ANE_PTR layerHandle, ANE_INT32 parameterIndex, ANE_STR newParameterExpression);}
	{ set the parameter's expression}


procedure ANE_ImportTextToLayerByHandle(handle : ANE_PTR ; layerHandle : ANE_PTR ;
          textToImport : ANE_STR );
          cdecl; external 'ANECB.dll' name 'ANE_ImportTextToLayerByHandle';

{void ANE_ImportTextToLayerByHandle(ANE_PTR handle, ANE_PTR layerHandle, ANE_STR textToImport);}
	{ calls a layer to import the text in 'textToImport' as an import file }

{
function ANE_LayerGetNamesByType(handle : ANE_PTR ;
         requestedTypes : EPIELayerType ) : ANE_STR_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetNamesByType';
}
{ANE_STR* ANE_LayerGetNamesByType(ANE_PTR handle, enum EPIELayerType requestedTypes);}
	{ get the names of all layers of a given type. The memory pointer returned by this
		functio must be released using ANE_MemDelete. }




{ Data Layer Callbacks }
{===================}

procedure ANE_DataLayerSetData(handle : ANE_PTR ;
	      dataLayerHandle :	  ANE_PTR ;
	      numPoints :	  ANE_INT32   ;
	      posX :		  ANE_DOUBLE_PTR  ;
	      posY :		  ANE_DOUBLE_PTR   ;
	      numDataParameters : ANE_INT32     ;
	      dataParameters :	  ANE_DOUBLE_PTR_PTR  ;
	      paramNames :	  ANE_STR_PTR     );
          cdecl; external 'ANECB.dll' name 'ANE_DataLayerSetData';

{void ANE_DataLayerSetData(ANE_PTR 		handle,
			  ANE_PTR 		dataLayerHandle,
			  ANE_INT32		numPoints,
			  ANE_DOUBLE*		posX,
			  ANE_DOUBLE*		posY,
			  ANE_INT32		numDataParameters,
			  ANE_DOUBLE**		dataParameters,
			  ANE_STR*		paramNames);     }

	{ Set scattered data in a data layer.
		There are numPoints points of data.
		Point i is at location posX[i] posy[i].

		Each point has numDataParameters data items attached to it.
		the first parameter of point i is dataParameters[p][i]
	}


procedure ANE_DataLayerSetTriangulatedData(	handle :     		ANE_PTR     ;
						dataLayerHandle :	ANE_PTR     ;
						numPoints :		ANE_INT32   ;
						posX :			ANE_DOUBLE_PTR ;
						posY :			ANE_DOUBLE_PTR ;
						numTriangles :		ANE_INT32   ;
						node0 :			ANE_INT32_PTR  ;
						node1 :			ANE_INT32_PTR  ;
						node2 :			ANE_INT32_PTR  ;
						numDataParameters :	ANE_INT32   ;
						dataParameters :	ANE_DOUBLE_PTR_PTR;
						paramNames :		ANE_STR_PTR  );
          cdecl; external 'ANECB.dll' name 'ANE_DataLayerSetTriangulatedData';

{void ANE_DataLayerSetTriangulatedData(ANE_PTR 		handle,
						ANE_PTR 		dataLayerHandle,
						ANE_INT32		numPoints,
						ANE_DOUBLE*		posX,
						ANE_DOUBLE*		posY,
						ANE_INT32 		numTriangles,
						ANE_INT32*		node0,
						ANE_INT32*		node1,
						ANE_INT32*		node2,
						ANE_INT32		numDataParameters,
						ANE_DOUBLE**	dataParameters,
						ANE_STR*			paramNames);}

	{ Set triangulated data in a data layer.
		There are numPoints points of data.
		Point i is at location posX[i] posy[i].
		
		Each point has numDataParameters data items attached to it.
		The first parameter of point i is dataParameters[p][i]
		
		The triangulation information is defined by node0, node1, node2.
		There are numTriangles triangle.
		Triangle j has three vertices: node0[j] node1[j] and node2[j], each of the is
		an index to a point, that is between 0 and numPoints-1.

		if paramNames is NULL, parameters get the namee "Imported Parameter 1" etc.
		if paramNames is not NULL, parameters get the names paramNames[i]
	}


{ User Interface Callbacks }
{===================}
{"message" renamed "MessageToDisplay" to avoid conflict with the Object Pascal
  standard directive "message".}
{
procedure ANE_UserMessageOk(handle : ANE_PTR ; MessageToDisplay : ANE_STR );
          cdecl; external 'ANECB.dll' name 'ANE_UserMessageOk';
}
{void ANE_UserMessageOk(ANE_PTR handle, ANE_STR message);}
	{ displays a dialog box with the message and an OK button }

{
function ANE_UserMessageOkCancel(handle : ANE_PTR ; prompt : ANE_STR ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_UserMessageOkCancel';
}
{ANE_BOOL ANE_UserMessageOkCancel(ANE_PTR handle, ANE_STR prompt);}
	{ displays a dialog box with the prompt, and two buttons: Ok and Cancel.
        returns true if the user selected Ok and false if the user selected cancel }
{
function ANE_UserMesageYesNoCancel(handle : ANE_PTR ; prompt : ANE_STR ) : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_UserMesageYesNoCancel';
}
{ANE_INT32 ANE_UserMesageYesNoCancel(ANE_PTR handle, ANE_STR prompt);}
	{ displays a dialog box with the prompt and three buttons: Yes, No and Cancel.
		returns 1 for Yes
			2 for No
			3 for Cancel
	}

{
function ANE_UserSelectItem(handle : ANE_PTR ; items : ANE_STR_PTR ;
         title : ANE_STR ; prompt : ANE_STR ) : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_UserSelectItem';
}
{ANE_INT32 ANE_UserSelectItem(ANE_PTR handle, ANE_STR* items, ANE_STR title, ANE_STR prompt);}
	{ displays a dialog box with a list of items. items is an array of pointers to char,
	terminated by a null pointer.
	The message window will have title as its title, and prompt as the prompt message to the user
	return index of item (0 for first, 1 for second, etc.), or -1 if no item was selected.}

{
function ANE_UserSelectMultipleItems(handle : ANE_PTR ; items : ANE_PTR_PTR ;
         title : ANE_STR ; prompt : ANE_STR ; returnNumSelected : ANE_INT32_PTR ;
         returnSelectedItems : ANE_INT32_PTR_PTR ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_UserSelectMultipleItems';
}
{ANE_BOOL ANE_UserSelectMultipleItems(ANE_PTR handle, ANE_STR* items, ANE_STR title, ANE_STR prompt, ANE_INT32* returnNumSelected, ANE_INT32** returnSelectedItems);}
	{ displays a dialog box with a list of items. items is an array of pointers to char,
	terminated by a null pointer.
	The message window will have title as its title, and prompt as the prompt message to the user

	the function returns true if the user pressed the Ok button
	the function returns false if the user pressed the Cancel button, or closed the window

	if the function returns true, the integer pointed by returnNumSelected is set to the number of selected items
	in addition, the pointer to integet pointed by returnSelectedItems is set to a pointer to array of indices of the selected items.
	it is the caller function responsibility to free the memory allocated, by calling ANE_MemDelete(aneHande, *returnSelectedItems)

	}

{ "type" changed to "PIEtype" to avoid conflict with the Object Pascal reserved word "type".
  "string" changed to StringToEvaluate to avoid conflict with the Object Pascal reserved word "string".
  "enum" not included in declaration of PIEtype because the Object Pascal enumeration type
  is not compatable with the C++ enumeration type.}

procedure ANE_EvaluateStringAtLayer(handle : ANE_PTR ; layerHandle : ANE_PTR ;
           PIEtype : EPIENumberType ; StringToEvaluate : ANE_STR ; result : ANE_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_EvaluateStringAtLayer';

{void ANE_EvaluateStringAtLayer(ANE_PTR handle, ANE_PTR layerHandle, enum EPIENumberType type,
         ANE_STR string, ANE_PTR result);}
	{ evaluates 'string' to yield value of type 'type', use the evaluation centext
	of layer pointed by 'layerHandle' the result will be stored into 'result' }


implementation



end.


{==============================================================================
//	End File: ANECB.h
//==============================================================================}

