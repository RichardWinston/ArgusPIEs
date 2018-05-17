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



{
procedure ANE_GetVersion(const aneHandle : ANE_PTR ; major : ANE_INT32_PTR ;
   minor : ANE_INT32_PTR ; update : ANE_INT32_PTR ; versionBuf : ANE_STR ;
   bufLen : ANE_INT32 );
          cdecl; external 'ANECB.dll' name 'ANE_GetVersion';
}
{void ANE_GetVersion(ANE_CPTR aneHandle, ANE_INT32* major, ANE_INT32* minor,
  ANE_INT32* update, ANE_STR versionBuf, ANE_INT32 bufLen);}
	{ get version information for the ArgusNE application }


procedure ANE_GetPIEProjectHandle(const aneHandle : ANE_PTR ;
          pieHandle : ANE_PTR_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_GetPIEProjectHandle';

{void ANE_GetPIEProjectHandle(ANE_CPTR aneHandle, ANE_PTR* pieHandle);}
	{ get a pointer to the private information of the current document's Project }

procedure ANE_ProcessEvents(const aneHandle : ANE_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_ProcessEvents';

{void ANE_ProcessEvents(ANE_CPTR aneHandle);}
	{ give a chance to ArgusNE and the rest of the system to handle user events }


procedure ANE_MakeDirty(const aneHandle : ANE_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_MakeDirty';

{void ANE_MakeDirty(ANE_CPTR aneHandle);}
	{ mark that the document was touched (turn on Save menu etc. ) }

procedure ANE_ImportTextToLayer(const handle : ANE_PTR ;
          textToImport : ANE_STR);
          cdecl; external 'ANECB.dll' name 'ANE_ImportTextToLayer';

{void ANE_ImportTextToLayer(ANE_CPTR handle, ANE_STR textToImport);}
	{ calls the current layer to import the text in 'textToImport' as an
        import file }

procedure ANE_ExportTextFromOtherLayer(const handle : ANE_PTR ;
          const layerHandle : ANE_PTR ;
          textExported : ANE_STR_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_ExportTextFromOtherLayer';

{void ANE_ExportTextFromOtherLayer(ANE_CPTR handle, ANE_CPTR layerHandle,
      ANE_STR* textExported);}
	{ calls the layer pointed by 'layerHandle' to export it's information into 'textExported' pointer }

{ Memory allocation functions }

{
function ANE_MemAlloc(const handle : ANE_PTR ; size : ANE_INT32 ) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_MemAlloc';
}
{ANE_PTR ANE_MemAlloc(ANE_CPTR handle, ANE_INT32 size);}
	{ allocate size bytes of memory }

{In the following declaration "ptr" has been changed to "aPtr" to avoid
confusion with the Ptr function.}
{
procedure ANE_MemDelete(const handle : ANE_PTR ; aPtr : ANE_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_MemDelete';
}
{void ANE_MemDelete(ANE_CPTR handle, ANE_PTR ptr);}
	{ delete chunk of memory }


{ Protection functions }
{================}
{
procedure ANE_ProtGetRegCode(const handle : ANE_PTR ; regCodeBuf : ANE_STR ;
          bufLen : ANE_INT32 );
          cdecl; external 'ANECB.dll' name 'ANE_ProtGetRegCode';
}
{void ANE_ProtGetRegCode(ANE_CPTR handle, ANE_STR regCodeBuf, ANE_INT32 bufLen);}
	{ return into regCodeBuf min(regcode length, bufLen-1) characters of
          the RegCode }

{
procedure ANE_ProtGetUniqueID(const handle : ANE_PTR ; uniqueIDBuf : ANE_STR ;
          bufLen : ANE_INT32 );
          cdecl; external 'ANECB.dll' name 'ANE_ProtGetUniqueID';
}
{void ANE_ProtGetUniqueID(ANE_CPTR handle, ANE_STR uniqueIDBuf, ANE_INT32 bufLen);}
	{ return into uniqueIDBuf min(unique id  length, bufLen-1) characters of the Worksstation Unique ID }

{ Directory and file functions }

{
function ANE_DirectoryGet(const handle : ANE_PTR ; const caption : ANE_STR ;
         const path : ANE_STR ; dirBuf : ANE_STR ; bufLen : ANE_INT32 )
         : ANE_BOOL;
         cdecl; external 'ANECB.dll' name 'ANE_DirectoryGet';
}
{ANE_BOOL ANE_DirectoryGet(ANE_CPTR handle, ANE_CSTR caption, ANE_CSTR path,
          ANE_STR dirBuf, ANE_INT32 bufLen);}
	{ pop a dialog to the user, allowing selection of a directory. return true if directory was
		selected, false if directory was not selected. If directory was selected, a null terminated string is returned in buf }
{
function ANE_FileGet(const handle : ANE_PTR ; const caption : ANE_STR ;
         const path : ANE_STR ;
         const defName : ANE_STR ; forExport : ANE_BOOL ; dirBuf : ANE_STR ;
         bufLen : ANE_INT32 ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_FileGet';
}
{ANE_BOOL ANE_FileGet(ANE_CPTR handle, ANE_CSTR caption, ANE_CSTR path,
          ANE_CSTR defName, ANE_BOOL forExport, ANE_STR dirBuf,
          ANE_INT32 bufLen);}
	{ pop a dialog to the user, allowing selection of a file. return true if a file was
		selected, false if no file was selected. If file was selected, a null terminated string is returned in buf }
{
function ANE_FileGetEx(const handle : ANE_PTR ; const caption : ANE_STR ;
         const path : ANE_STR ;
         const defName : ANE_STR ; forExport : ANE_BOOL ; dirBuf : ANE_STR ;
         bufLen : ANE_INT32 ; extensionMask : ANE_STR ; extensionCaption : ANE_STR ;
         macType : ANE_INT32 ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_FileGetEx';
}
{ANE_BOOL ANE_FileGetEx(ANE_CPTR handle, ANE_CSTR caption, ANE_CSTR path,
          ANE_CSTR defName, ANE_BOOL forExport, ANE_STR dirBuf,
          ANE_INT32 bufLen, ANE_STR extensionMask, ANE_STR extensionCaption,
          ANE_INT32 macType);}
	{ pop a dialog to the user, allowing selection of a file. return true if a file was
		selected, false if no file was selected. If file was selected, a null terminated string is returned in buf ,
		The default extenstion of the file is defined by extensionMask, and described by extensionCaption.
		macType is used to select the files on the macintosh, where extensions don't apply }

{
procedure ANE_DirectorySetCurrent(const handle : ANE_PTR ;
          const currentDirectory : ANE_STR );
          cdecl; external 'ANECB.dll' name 'ANE_DirectorySetCurrent';
}
{void ANE_DirectorySetCurrent(ANE_CPTR handle, ANE_CSTR currentDirectory);}
	{ set the current directory }


procedure ANE_DirectoryGetCurrent(const handle : ANE_PTR ; buf : ANE_STR ;
          bufLen : ANE_INT32 );
          cdecl; external 'ANECB.dll' name 'ANE_DirectoryGetCurrent';

{void ANE_DirectoryGetCurrent(ANE_CPTR handle, ANE_STR buf, ANE_INT32 bufLen);}
	{ return the name of the directory }


{ Layer Handling callbacks }
{===================}
{
function ANE_LayerGetCurrent(const handle : ANE_PTR) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetCurrent';
}
// the return value of the function should be treated as a constant.

{ANE_CPTR ANE_LayerGetCurrent(ANE_CPTR handle);}
	{/* return a handle to the current layer. */}

{
procedure ANE_LayerSetCurrent(const handle : ANE_PTR; const layer : ANE_PTR);
          cdecl; external 'ANECB.dll' name 'ANE_LayerSetCurrent';
}

{void ANE_LayerSetCurrent(ANE_CPTR handle, ANE_CPTR layer);}
	{/* set the active layer to layer. */}

{
procedure ANE_LayerGetUniqueName(const handle : ANE_PTR ;
          const seedName : ANE_STR; bufLen : ANE_INT32; nameBuf : ANE_STR);
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetUniqueName';
}
{void ANE_LayerGetUniqueName(ANE_CPTR handle, ANE_CSTR seedName,
      ANE_INT32 bufLen, ANE_STR nameBuf);}
	{/* create a unique name for a new layer, that is also valid. */}

function ANE_LayerGetHandleByName(const handle : ANE_PTR ;
         const name : ANE_STR ) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetHandleByName';
// the return value of the function should be treated as a constant.

{ANE_CPTR ANE_LayerGetHandleByName(ANE_CPTR handle, ANE_CSTR name);}
	{ return a handle for the layer with the name 'name',
          nil if no layer with that name }

function ANE_LayerAddByTemplate(const handle : ANE_PTR ;
         const layerTemplate : ANE_STR ;
         const afterLayerHandle : ANE_PTR ) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_LayerAddByTemplate';
// the return value of the function should be treated as a constant.

{ANE_CPTR ANE_LayerAddByTemplate(ANE_CPTR handle, ANE_CSTR layerTemplate,
          ANE_CPTR afterLayerHandle);}
//	/* parse a Layer Definition Language template, and adds a layer.
//			New layers will be added after 'afterLayerHandle', if 'afterLayerHandle' is nil,
//			new layers will be added at the end of the layers list.
//			If a layers were added, return the handle to the first added layer.
//			If parsing failed, returns nil
//
//	*		Layer Definition Template syntax:
//	*		---------------------------------
//	*
//	*		Layer:
//	*		{
//	*			Name: "<name>"							| Name of layer. Default: ""
//	*			Units: "<units>"						| Units name for layer. Default: ""
//	*			Type: "<type>"							| Type of layer, one of: Information, Domain, Grid, Mesh, QuadMesh, Maps. Default: Information
//	*			Visible: <visible>						| Is layer initially visible, one of: True, False. Default: True
//	*			Interpretation Method: <type>					| (Information layers ONLY) Type of interpretation method, one of: Nearest, Exact, Interpolate, or an interpolation PIE name. Default: Nearest
//	*			Interpolation PIE: <pie>					| (Data layers ONLY) Name of interpretation PIE. Default: ""
//	*			Domain Layer: "<layer>"						| (Grid, Mesh layers ONLY) Name of a layer to serve as domain outline. Default: Name of first Domain layer
//	*			Density Layer: "<layer>"					| (Grid, Mesh layers ONLY) Name of a layer to serve as density outline. Default: Name of first Information layer
//	*			Lock: "<lock>"							| Lock status of layer, example: "Lock Name, Lock all parameters". Default: ""
//	*
//	*			<tags-list>							| Optional list of layer tags definitions (see below)
//	*
//	*			<parameters-list>						| List of layer's parameters definitions (see ANE_LayerAddParametersByTemplate function)
//	*		}
//	*
//	*		Tag Definition Template syntax:
//	*		-------------------------------
//	*
//	*		Tag:
//	*		{
//	*			Name: "<name>"							| Name of tag. Default: ""
//	*			Value: "<value>"						| Value of tag. Default: ""
//	*		}
//	*
//	*/
//

procedure ANE_LayerAddParametersByTemplate(const handle : ANE_PTR ;
          const atLayerHandle : ANE_PTR ; const paramsTemplate : ANE_STR ;
          afterParameter : ANE_INT32 );
          cdecl; external 'ANECB.dll' name 'ANE_LayerAddParametersByTemplate';

{void ANE_LayerAddParametersByTemplate(ANE_CPTR handle, ANE_CPTR atLayerHandle,
      ANE_CSTR paramsTemplate, ANE_INT32 afterParameter);}
//	/* parse a Layer Definition Language template containing only parameters, and addthem to 'atLayerHandle'.
//			New parameters will be added after 'afterParameter',
//			if 'afterParameter' is -1, the parameters will be added at the beginning of paramer list (befor the first parameter),
//			if afterParameter is greater than the number of parameters, the paremeters will be added to the end of the parmeters list.
//			You can use MAXINT to add parameters to the end of the list, regradless of the number of parameters in the layer.
//
//	*		Parameter Definition Template syntax:
//	*		-------------------------------------
//	*
//	*		Parameter:
//	*		{
//	*			Name: "<name>"			| Name of parameter. Default: ""
//	*			Units: "<units>"		| Units name for parameter. Default: ""
//	*			Value Type: <type>		| Type of value, one of: Integer, Real, Boolean, String. Default: Real
//	*			Value: "<expr>"			| Expression to evaluate parameter default value. Default: "0"
//	*			Parameter Type: <type>		| Type of parameter, one of: Layer, Node, Element, Block. Default: Layer
//	*			Lock: "<lock>"			| Lock status of parameter, example: "Lock Name, Dont Override, Inhibit Delete". Default: ""
//	*
//	*			<tags-list>			| Optional list of parameter tags definitions (see below)
//	*		}
//	*
//	*		Tag Definition Template syntax:
//	*		-------------------------------
//	*
//	*		Tag:
//	*		{
//	*			Name: "<name>"			| Name of tag. Default: ""
//	*			Value: "<value>"		| Value of tag. Default: ""
//	*		}
//	*
//	*/

{
function ANE_LayerPropertySet(const handle : ANE_PTR;
         const layerHandle : ANE_PTR; const propertyName :ANE_CSTR;
         valueType : EPIENumberType; const value : ANE_PTR ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerPropertySet';
}
{ANE_BOOL ANE_LayerPropertySet(ANE_CPTR handle, ANE_CPTR layerHandle,
         ANE_CSTR propertyName, enum EPIENumberType valueType, ANE_CPTR value);}
{	/* set the given property of the layer

	* Property Name				Type			Description
	* -------------				----			-----------
	*			-- Contour Layer ONLY ---
	* Allow Intersection	Bool			Set the layer's allow intersection flag

	*/
}

{
function ANE_LayerPropertyGet(const handle : ANE_PTR;
         const layerHandle : ANE_PTR; const propertyName : ANE_STR;
         valueType : EPIENumberType; const value : ANE_PTR) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerPropertyGet';
}
{ANE_BOOL ANE_LayerPropertyGet(ANE_CPTR handle, ANE_CPTR layerHandle,
         ANE_CSTR propertyName, enum EPIENumberType valueType, ANE_CPTR value);}
{	/* get the given property of the layer

	* Property Name				Type			Description
	* -------------				----			-----------
	* CoordXRight				Bool			Returns 'true' (1) if the X coordinate increases to the right
	* CoordYUp				Bool			Returns 'true' (1) if the X coordinate increases in the up direction
	* CoordUnits				String		Returns coordinates' units name, e.g. "Km"
	* CoordScale				Double		Returns coordinates' scale factor
	* CoordXYRatio				Double		Returns the ratio of X to Y coordinates

	*/
}

{
function ANE_LayerParameterPropertySet (const handle : ANE_PTR;
         parameterIndex : ANE_INT32; const layerHandle : ANE_PTR;
         const propertyName : ANE_STR; valueType : EPIENumberType;
         const value : ANE_PTR ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerParameterPropertySet';
}
{ANE_BOOL ANE_LayerParameterPropertySet(ANE_CPTR handle,
         ANE_INT32 parameterIndex, ANE_CPTR layerHandle,
         ANE_CSTR propertyName, enum EPIENumberType valueType, ANE_CPTR value); }
{	/* set the given property of the parameter

	* Property Name				Type			Description
	* -------------				----			-----------
	* Name					String		Set parameter Name
	* Units					String		Set parameter Units
	* Expr					String		Set parameter default value expression
	* Lock					String		Set parameter lock bits, e.g. "Lock Name, Dont Override, Inhibit Delete"
	* +Lock					String		ADD parameter lock bits
	* -Lock					String		REMOVE parameter lock bits

	*/
}

{
function ANE_LayerParameterPropertyGet(const handle : ANE_PTR;
         parameterIndex :ANE_INT32; const layerHandle ; ANE_PTR;
         const propertyName : ANE_STR; valueType : EPIENumberType;
         const value : ANE_PTR) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerParameterPropertyGet';
}
{ANE_BOOL ANE_LayerParameterPropertyGet(ANE_CPTR handle,
          ANE_INT32 parameterIndex,
         ANE_CPTR layerHandle, ANE_CSTR propertyName,
         enum EPIENumberType valueType, ANE_CPTR value);}
{	/* get the given property of the parameter

	* Property Name		Type			Description
	* -------------		----			-----------
	* Name			String		Returns parameter Name
	* Units			String		Returns parameter Units
	* Expr			String		Returns parameter default value expression
	* Lock			String		Returns parameter lock bits, e.g. "Lock Name, Dont Override, Inhibit Delete"

	*/
}


function ANE_LayerClear(const handle : ANE_PTR ;const layerHandle : ANE_PTR ;
         selectedOnly : ANE_BOOL ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerClear';

{ANE_BOOL ANE_LayerClear(ANE_CPTR handle,  ANE_CPTR layerHandle, ANE_BOOL selectedOnly);}
	{ clear all objects in the specified layer. Returns true if there were objects in
		the layer, return false if no objects were cleared.}


function ANE_LayerRemove(const handle : ANE_PTR ; const layerHandle : ANE_PTR ;
         forceRemoval : ANE_BOOL ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerRemove';

{ANE_BOOL ANE_LayerRemove(ANE_CPTR handle, ANE_CPTR layerHandle, ANE_BOOL forceRemoval);}
	{ remove the specified layer. If forceRemoval is TRUE, remove the layer even
		if it is a geographic layer that other layer is using. Return TRUE if a layer was removed}


function ANE_LayerRename(const aneHandle : ANE_PTR; const layerHandle : ANE_PTR;
         const newName : ANE_STR ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerRename';

{ANE_BOOL ANE_LayerRename(ANE_CPTR aneHandle, ANE_CPTR layerHandle, ANE_CSTR newName);}
	{ if the layer is renamed, return TRUE}


function ANE_LayerGetNumParameters(const aneHandle : ANE_PTR ;
         const layerHandle : ANE_PTR ;
          parameterType : EPIEParameterType ) : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetNumParameters';

{ANE_INT32 ANE_LayerGetNumParameters(ANE_CPTR aneHandle, ANE_CPTR layerHandle,
           enum EPIEParameterType parameterType);}
	{ return the number of parameter of the layer}


function ANE_LayerGetParameterByName(const aneHandle : ANE_PTR ;
         const layerHandle : ANE_PTR; const parameterName : ANE_STR)
         : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetParameterByName';

{ANE_INT32 ANE_LayerGetParameterByName(ANE_CPTR aneHandle, ANE_CPTR layerHandle, ANE_CSTR parameterName);}
	{ return the index of the parameter with the given  layer, return -1}


function ANE_LayerRemoveParameter(const aneHandle : ANE_PTR ;
         const layerHandle : ANE_PTR ;
         parameterIndex : ANE_INT32 ; forceRemoval : ANE_BOOL ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerRemoveParameter';

{ANE_BOOL ANE_LayerRemoveParameter(ANE_CPTR aneHandle, ANE_CPTR layerHandle,
          ANE_INT32 parameterIndex, ANE_BOOL forceRemoval);}
	{ remove the specified parameter. If forceRemoval is TRUE, remove the parameter even
		if is is used by other layers. Return TRUE if a parameter was removed}


function ANE_LayerRenameParameter(const aneHandle : ANE_PTR ;
         const layerHandle : ANE_PTR ;
         parameterIndex : ANE_INT32 ; const newParameterName : ANE_STR )
         : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerRenameParameter';

{ANE_BOOL ANE_LayerRenameParameter(ANE_CPTR aneHandle, ANE_CPTR layerHandle,
          ANE_INT32 parameterIndex, ANE_CSTR newParameterName);}
	{ if the parameter was renamed, return TRUE}


procedure ANE_LayerSetParameterExpression(const aneHandle : ANE_PTR ;
          const layerHandle : ANE_PTR ; parameterIndex : ANE_INT32 ;
          const newParameterExpression : ANE_STR );
          cdecl; external 'ANECB.dll' name 'ANE_LayerSetParameterExpression';

{void ANE_LayerSetParameterExpression(ANE_CPTR aneHandle, ANE_CPTR layerHandle,
      ANE_INT32 parameterIndex, ANE_CSTR newParameterExpression);}
	{ set the parameter's expression}


procedure ANE_ImportTextToLayerByHandle(const handle : ANE_PTR ;
          const layerHandle : ANE_PTR ;
          const textToImport : ANE_STR );
          cdecl; external 'ANECB.dll' name 'ANE_ImportTextToLayerByHandle';

{void ANE_ImportTextToLayerByHandle(ANE_CPTR handle, ANE_CPTR layerHandle, ANE_CSTR textToImport);}
	{ calls a layer to import the text in 'textToImport' as an import file }

{
function ANE_LayerGetNamesByType(const handle : ANE_PTR ;
         requestedTypes : EPIELayerType ) : ANE_STR_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetNamesByType';
}
// the ANE_STR's to which the return value of function points should be treated
// as constants

{ANE_CSTR* ANE_LayerGetNamesByType(ANE_CPTR handle, enum EPIELayerType requestedTypes);}
	{ get the names of all layers of a given type. The memory pointer returned by this
		function must be released using ANE_MemDelete. }

{
function ANE_LayerGetNumObjects(const handle : ANE_PTR;
         const layerHandle : ANE_PTR; objectType : EPIEObjectType) : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetNumObjects';
}
{ANE_INT32 ANE_LayerGetNumObjects(ANE_CPTR handle, ANE_CPTR layerHandle, enum EPIEObjectType objectType);}
{	/* returns the number of objects of type objectType in a specific layer */}

{
function ANE_LayerGetNthObjectHandle (const handle : ANE_PTR;
         const layerHandle : ANE_PTR; objectType : EPIEObjectType) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetNthObjectHandle';
}
// the return value of the function should be treated as a constant.
{ANE_CPTR ANE_LayerGetNthObjectHandle(ANE_CPTR handle, ANE_CPTR layerHandle, enum EPIEObjectType objectType, ANE_INT32 objectIndex);}
{	/* returns a handle to the nth object in a specific layer.  0 <= objectIndex <= numObjects-1 */}

{
function ANE_LayerSetObjectInfo (const handle : ANE_PTR;
         const layerHandle : ANE_PTR; objectType : EPIEObjectType;
         numValues : ANE_INT16; valuesTypes : EPIENumberType_PTR;
         valuesIndices : ANE_INT16_PTR; values : ANE_PTR_PTR) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerSetObjectInfo';
}
// the members of values should be treated as constants.
{ANE_BOOL ANE_LayerSetObjectInfo(ANE_CPTR handle, ANE_CPTR layerHandle,
         enum EPIEObjectType objectType,ANE_CPTR object, ANE_INT16 numValues,
         enum EPIENumberType* valuesTypes, ANE_INT16* valuesIndices, ANE_CPTR* values);}
{	/* Set the values of an object in a layer.

		Input:
			numValues - number of values to be set for the object
			valuesTypes - an array of length numValues, where each element represents the type of the value
			valuesIndices	- an array of length numValues, where each element holds the index of the parameter to get the value
			values - an array of pointers to data values. value[i] is a pointer to a value of type valuesTypes[i] to be places in parameter valuesIndices[i]

		Return Value:
			if the function succeeds, it returns true.
			it if fails, it returns false. for more information about the error, call ANE_GetLastError()
	*/
}

{
function ANE_LayerGetType (const handle : ANE_PTR;
         const layerHandle : ANE_PTR) : EPIELayerType;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetType';
}
{enum EPIELayerType ANE_LayerGetType(ANE_CPTR handle, ANE_CPTR layerHandle);}
{/* return the type of the layer */}


//* Maps Layer Callbacks */
//*===================*/

{
function ANE_MapsLayerAddPolygon (const handle : ANE_PTR;
         const layerHandle : ANE_PTR; numPoints : ANE_INT32;
         const points : ANE_POINT_PTR) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_MapsLayerAddPolygon';
}
// the return value of the function should be treated as a constant.

{ANE_CPTR ANE_MapsLayerAddPolygon(ANE_CPTR handle, ANE_CPTR layerHandle,
         ANE_INT32 numPoints, ANE_POINT_CPTR points);}

{	/* create a new polygon object in a maps layer.

		Input:
			numPoints - number of points in the contours
			points - an array of points of length numPoints

		Return Value:
			if the function succeeds, a handle to the new contour is returned.
			if the function fails, the function returns 0. for more information about the error, call ANE_GetLastError()
	*/
}


//* Information Layer Callbacks */
//*===================*/

{
function ANE_InfoLayerAddContour (const handle : ANE_PTR;
         const layerHandle : ANE_PTR; numPoints : ANE_INT32;
         const points : ANE_POINT_PTR) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_InfoLayerAddContour';
}

{ANE_CPTR ANE_InfoLayerAddContour(ANE_CPTR handle, ANE_CPTR layerHandle,
         ANE_INT32 numPoints, ANE_POINT_CPTR points);}
{
	/* create a new contour object in an information layer.

		Input:
			numPoints - number of points in the contours
			points - an array of points of length numPoints

		Return Value:
			if the function succeeds, a handle to the new contour is returned.
			if the function fails, the function returns 0. for more information about the error, call ANE_GetLastError()
	*/
}





{ Data Layer Callbacks }
{===================}

procedure ANE_DataLayerSetData(const handle : ANE_PTR ;
	      const dataLayerHandle :	  ANE_PTR ;
	      numPoints :	  ANE_INT32   ;
	      posX :		  ANE_DOUBLE_PTR  ;
	      posY :		  ANE_DOUBLE_PTR   ;
	      numDataParameters : ANE_INT32     ;
	      dataParameters :	  ANE_DOUBLE_PTR_PTR  ;
	      paramNames :	  ANE_STR_PTR     );
          cdecl; external 'ANECB.dll' name 'ANE_DataLayerSetData';
// the ANE_STR's in paramNames should be treated as constants by Argus ONE

{void ANE_DataLayerSetData(ANE_CPTR 		handle, 
						ANE_CPTR 		dataLayerHandle, 
						ANE_INT32		numPoints,
						ANE_DOUBLE*		posX,
						ANE_DOUBLE*		posY,
						ANE_INT32		numDataParameters,
						ANE_DOUBLE**	dataParameters,
						ANE_CSTR*			paramNames);     }

	{ Set scattered data in a data layer.
		There are numPoints points of data.
		Point i is at location posX[i] posy[i].

		Each point has numDataParameters data items attached to it.
		the first parameter of point i is dataParameters[p][i]
	}


procedure ANE_DataLayerSetTriangulatedData(	const handle :     		ANE_PTR     ;
						const dataLayerHandle :	ANE_PTR     ;
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
// the ANE_STR's in paramNames should be treated as constants by Argus ONE

{void ANE_DataLayerSetTriangulatedData(ANE_CPTR 		handle,
						ANE_CPTR 		dataLayerHandle,
						ANE_INT32		numPoints,
						ANE_DOUBLE*		posX,
						ANE_DOUBLE*		posY,
						ANE_INT32 		numTriangles,
						ANE_INT32*		node0,
						ANE_INT32*		node1,
						ANE_INT32*		node2,
						ANE_INT32		numDataParameters,
						ANE_DOUBLE**	dataParameters,
						ANE_CSTR*			paramNames);}

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
procedure ANE_UserMessageOk(const handle : ANE_PTR ;
          const MessageToDisplay : ANE_STR );
          cdecl; external 'ANECB.dll' name 'ANE_UserMessageOk';
}
{void ANE_UserMessageOk(ANE_CPTR handle, ANE_CSTR message);}
	{ displays a dialog box with the message and an OK button }

{
function ANE_UserMessageOkCancel(const handle : ANE_PTR ;
         const prompt : ANE_STR ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_UserMessageOkCancel';
}
{ANE_BOOL ANE_UserMessageOkCancel(ANE_CPTR handle, ANE_CSTR prompt);}
	{ displays a dialog box with the prompt, and two buttons: Ok and Cancel.
        returns true if the user selected Ok and false if the user selected cancel }
{
function ANE_UserMesageYesNoCancel(const handle : ANE_PTR ;
         const prompt : ANE_STR ) : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_UserMesageYesNoCancel';
}
{ANE_INT32 ANE_UserMessageYesNoCancel(ANE_CPTR handle, ANE_CSTR prompt);}
	{ displays a dialog box with the prompt and three buttons: Yes, No and Cancel.
		returns 1 for Yes
			2 for No
			3 for Cancel
	}

{
function ANE_UserSelectItem(const handle : ANE_PTR ; items : ANE_STR_PTR ;
         const title : ANE_STR ; const prompt : ANE_STR ) : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_UserSelectItem';
// the members of items should be treated as constants by Argus ONE.
}
{ANE_INT32 ANE_UserSelectItem(ANE_CPTR handle, ANE_CSTR* items, ANE_CSTR title, ANE_CSTR prompt);}
	{ displays a dialog box with a list of items. items is an array of pointers to char,
	terminated by a null pointer.
	The message window will have title as its title, and prompt as the prompt message to the user
	return index of item (0 for first, 1 for second, etc.), or -1 if no item was selected.}

{
function ANE_UserSelectMultipleItems(const handle : ANE_PTR ; items : ANE_PTR_PTR ;
         const title : ANE_STR ; const prompt : ANE_STR ;
         returnNumSelected : ANE_INT32_PTR ;
         returnSelectedItems : ANE_INT32_PTR_PTR ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_UserSelectMultipleItems';
// the members of items should be treated as constants by Argus ONE.
}
{ANE_BOOL ANE_UserSelectMultipleItems(ANE_CPTR handle, ANE_CSTR* items,
          ANE_CSTR title, ANE_CSTR prompt, ANE_INT32* returnNumSelected,
          ANE_INT32** returnSelectedItems);}
	{ displays a dialog box with a list of items. items is an array of pointers to char,
	terminated by a null pointer.
	The message window will have title as its title, and prompt as the prompt message to the user

	the function returns true if the user pressed the Ok button
	the function returns false if the user pressed the Cancel button, or closed the window

	if the function returns true, the integer pointed by returnNumSelected is set to the number of selected items
	in addition, the pointer to integet pointed by returnSelectedItems is set to a pointer to array of indices of the selected items.
	it is the caller function responsibility to free the memory allocated, by calling ANE_MemDelete(aneHande, *returnSelectedItems)

	}

{ "type" changed to "PIEtype" to avoid conflict with the Object Pascal
  reserved word "type". "string" changed to StringToEvaluate to avoid
  conflict with the Object Pascal reserved word "string".
  "enum" not included in declaration of PIEtype because the Object Pascal
  enumeration type is not compatable with the C++ enumeration type.}

procedure ANE_EvaluateStringAtLayer(const handle : ANE_PTR ;
          const layerHandle : ANE_PTR ;
           PIEtype : EPIENumberType ; const StringToEvaluate : ANE_STR ;
           result : ANE_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_EvaluateStringAtLayer';

{void ANE_EvaluateStringAtLayer(ANE_CPTR handle, ANE_CPTR layerHandle,
      enum EPIENumberType type, ANE_CSTR string, ANE_PTR result);}
	{ evaluates 'string' to yield value of type 'type', use the evaluation centext
	of layer pointed by 'layerHandle' the result will be stored into 'result' }


{ "begin" changed to "beginNum" to avoid conflict with the Object Pascal
  reserved word "begin". "end" changed to "endNum" to avoid conflict with the
  Object Pascal reserved word "end".}
{
procedure ANE_ProgressStart(const handle : ANE_PTR ; beginNum : ANE_INT32;
          endNum : ANE_INT32 ; const caption : ANE_CSTR);
          cdecl; external 'ANECB.dll' name 'ANE_ProgressStart';
}
{void ANE_ProgressStart(ANE_CPTR handle, ANE_INT32 begin, ANE_INT32 end, ANE_CSTR caption);}
{	/* starts a progress bar, ranging from begin to end, with the title caption.

		 if (begin >= end) then the progress will be barbershop type.
	*/
}

{
procedure ANE_ProgressEnd(const handle : ANE_PTR);
          cdecl; external 'ANECB.dll' name 'ANE_ProgressEnd';
}
{void ANE_ProgressEnd(ANE_CPTR handle);}
{	/* ends a progress bar. */}

{
function ANE_ProgressSet (const handle : ANE_PTR; value : ANE_INT32): ANE_BOOL
          cdecl; external 'ANECB.dll' name 'ANE_ProgressSet';
}
{ANE_BOOL ANE_ProgressSet(ANE_CPTR handle, ANE_INT32 value);}
{	/* set the current position of the progress bar to value */}

{
function ANE_ProgressAdvance(const handle : ANE_PTR) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_ProgressSet';
}          
{ANE_BOOL ANE_ProgressAdvance(ANE_CPTR handle);}
{	/* increments a progress bar of type barbershop */}



implementation



end.

