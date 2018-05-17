unit ANECB;

//{==============================================================================
//
//	File: ANECB.h
//
//	Argus Numerical Environments - Plug In Extension, Release 1.1
//
//	Copyright © 1996-98 Argus Holdings Ltd.  All rights reserved.
//
//		THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF Argus Holdings Ltd..
//		The copyright notice above does not evidence any
//		actual or intended publication of such source code
//
//==============================================================================}
//
// Update information:
//	16/09/97		Use 'const' in std types (ANE_CPTR, etc.)
//	22/10/97		Add ANE_Layer/ParameterPropertyGet/Set functions and comments
//
//==============================================================================*/

interface

uses
  AnePIE;


{In cases where the functions or procedures have been translated to Object
Pascal but not tested, the function declarations have been commented out
and are followed by the original C++ declarations. It would be wise to check
that the translations are correct before relying on the translated functions.
The original comments from C++ are copied after the C++ declaration. In some
cases a function with a pointer return type is described as returning "0".
The Object Pascal equivalent in such cases is "nil".}

{ Basic calls }
{==========}




procedure ANE_GetVersion(const aneHandle : ANE_PTR ; major : ANE_INT32_PTR ;
   minor : ANE_INT32_PTR ; update : ANE_INT32_PTR ; versionBuf : ANE_STR ;
   bufLen : ANE_INT32 );
          cdecl; external 'ANECB.dll' name 'ANE_GetVersion';

{void ANE_GetVersion(ANE_CPTR aneHandle, ANE_INT32* major, ANE_INT32* minor,
  ANE_INT32* update, ANE_STR versionBuf, ANE_INT32 bufLen);}
	{ get version information for the ArgusNE application }


function ANE_GetLastError(const  handle : ANE_PTR) : ANE_STR;
          cdecl; external 'ANECB.dll' name 'ANE_GetLastError';

{ANE_CSTR ANE_GetLastError(ANE_CPTR handle);
	/* returns a pointer to a string that holds the last error from a PIE callback */
	/* this pointer must used immediately, since it is volatile in nature */ }


procedure ANE_GetPIEProjectHandle(const aneHandle : ANE_PTR ;
          pieHandle : ANE_PTR_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_GetPIEProjectHandle';

{void ANE_GetPIEProjectHandle(ANE_CPTR aneHandle, ANE_PTR* pieHandle);}
	{ get a pointer to the private information of the current document's Project }

procedure ANE_ProcessEvents(const aneHandle : ANE_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_ProcessEvents';

{void ANE_ProcessEvents(ANE_CPTR aneHandle);}
	{ give a chance to ArgusNE and the rest of the system to handle user events }

{function ANE_GetWindowHandle(const aneHandle : ANE_PTR ): ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_GetWindowHandle';}
// the return value should be treated as a constant.

{ANE_CPTR ANE_GetWindowHandle(ANE_CPTR aneHandle);}
{	/* return the MS Windows handle to project's window */}

procedure ANE_MakeDirty(const aneHandle : ANE_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_MakeDirty';

{void ANE_MakeDirty(ANE_CPTR aneHandle);}
	{ mark that the document was touched (turn on Save menu etc. ) }

{procedure ANE_InvalidateCache(const handle : ANE_PTR ;
          const layerHandle : ANE_PTR);
          cdecl; external 'ANECB.dll' name 'ANE_InvalidateCache';}
{void ANE_InvalidateCache(ANE_CPTR aneHandle, ANE_CPTR layerHandle);}
{	/* Clears cache of all objects in layer (or allayers, if layer=nil) */
	/* When the user works in a 'Manual Calculation' mode, object values' */
	/* are saved within an internal chace, until a 'Calculate Now' command */
	/* is issued. */
	/* Call this function before you begin extracting object values */
	/* if you want to be sure that the values you get are freshly */
	/* calculated and not old, invalid, cached data */}

{function ANE_IsPIEActivated(const handle : ANE_PTR ; const pieName ANE_STR): ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_IsPIEActivated';}
{ANE_BOOL ANE_IsPIEActivated(ANE_CPTR aneHandle, ANE_CSTR pieName);}
{	/* returns true if the user has activated the PIE pieName*/}

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

procedure ANE_MemDelete(const handle : ANE_PTR ; aPtr : ANE_PTR );
          cdecl; external 'ANECB.dll' name 'ANE_MemDelete';

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
	{ pop a dialog to the user, allowing selection of a directory. return
          true if directory was
		selected, false if directory was not selected. If directory
                was selected, a null terminated string is returned in buf }
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
	{ pop a dialog to the user, allowing selection of a file. return true
          if a file was
		selected, false if no file was selected. If file was selected,
                a null terminated string is returned in buf }
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
	{ pop a dialog to the user, allowing selection of a file. return true
          if a file was
		selected, false if no file was selected. If file was selected,
                a null terminated string is returned in buf ,
		The default extenstion of the file is defined by extensionMask,
                and described by extensionCaption.
		macType is used to select the files on the macintosh,
                where extensions don't apply }


procedure ANE_DirectorySetCurrent(const handle : ANE_PTR ;
          const currentDirectory : ANE_STR );
          cdecl; external 'ANECB.dll' name 'ANE_DirectorySetCurrent';

{void ANE_DirectorySetCurrent(ANE_CPTR handle, ANE_CSTR currentDirectory);}
	{ set the current directory }


procedure ANE_DirectoryGetCurrent(const handle : ANE_PTR ; buf : ANE_STR ;
          bufLen : ANE_INT32 );
          cdecl; external 'ANECB.dll' name 'ANE_DirectoryGetCurrent';

{void ANE_DirectoryGetCurrent(ANE_CPTR handle, ANE_STR buf, ANE_INT32 bufLen);}
	{ return the name of the directory }


{ Layer Handling callbacks }
{===================}

function ANE_LayerGetCurrent(const handle : ANE_PTR) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetCurrent';

// the return value of the function should be treated as a constant.

{ANE_CPTR ANE_LayerGetCurrent(ANE_CPTR handle);}
	{/* return a handle to the current layer. */}


procedure ANE_LayerSetCurrent(const handle : ANE_PTR; const layer : ANE_PTR);
          cdecl; external 'ANECB.dll' name 'ANE_LayerSetCurrent';


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

{function ANE_LayerGetHandleByIndex(const handle : ANE_PTR ; index : ANE_INT32);
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetHandleByIndex';}
{ANE_CPTR ANE_LayerGetHandleByIndex(ANE_CPTR handle, ANE_INT32 index);}
{	/* return a handle for the nth layer, 0 if no layer */}

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
//	*			Name: "<name>"			   | Name of layer. Default: ""
//	*			Units: "<units>"		   | Units name for layer. Default: ""
//	*			Type: "<type>"			   | Type of layer, one of: Information, Domain, Grid, Mesh, QuadMesh, Maps. Default: Information
//	*			Visible: <visible>		   | Is layer initially visible, one of: True, False. Default: True
//	*			Interpretation Method: <type>	   | (Information layers ONLY) Type of interpretation method, one of: Nearest, Exact, Interpolate, or an interpolation PIE name. Default: Nearest
//	*			Interpolation PIE: <pie>	   | (Data layers ONLY) Name of interpretation PIE. Default: ""
//	*			Domain Layer: "<layer>"		   | (Grid, Mesh layers ONLY) Name of a layer to serve as domain outline. Default: Name of first Domain layer
//	*			Density Layer: "<layer>"	   | (Grid, Mesh layers ONLY) Name of a layer to serve as density outline. Default: Name of first Information layer
//	*			Lock: "<lock>"			   | Lock status of layer, example: "Lock Name, Lock all parameters". Default: ""
//	*			Reverse Grid X Direction: "Yes"/"No"	| (Grid layers only) Control grid direction. Default: "No"
//	*			Reverse Grid Y Direction: "Yes"/"No"	| (Grid layers only) Control grid direction. Default: "No"
//	*			Grid Block Centered: "Yes"/"No"		| (Grid layers only) Control grid type. Default: "Yes"
//	*
//	*			<tags-list>			   | Optional list of layer tags definitions (see below)
//	*
//	*			<parameters-list>		   | List of layer's parameters definitions (see ANE_LayerAddParametersByTemplate function)
//	*		}
//	*
//	*		Tag Definition Template syntax:
//	*		-------------------------------
//	*
//	*		Tag:
//	*		{
//	*			Name: "<name>"			  | Name of tag. Default: ""
//	*			Value: "<value>"		  | Value of tag. Default: ""
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
//	/* parse a Layer Definition Language template containing only parameters,
//         and add them to 'atLayerHandle'.
//			New parameters will be added after 'afterParameter',
//			if 'afterParameter' is -1, the parameters will be added
//                      at the beginning of paramer list (befor the first parameter),
//			if afterParameter is greater than the number of parameters,
//                      the paremeters will be added to the end of the parmeters list.
//			You can use MAXINT to add parameters to the end of the
//                      list, regradless of the number of parameters in the layer.
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

function ANE_PropertySet(const handle : ANE_PTR; const propertyName : ANE_STR;
         valueType : EPIENumberType; const value : ANE_PTR): ANE_BOOL;
         cdecl; external 'ANECB.dll' name 'ANE_PropertySet';

{
ANE_BOOL ANE_PropertySet(ANE_CPTR handle, ANE_CSTR propertyName, enum EPIENumberType valueType, ANE_CPTR value);
	/* set the given property of the document or application

	* Property Name			Type					Description
	* -------------			----					-----------
	* MinAngle			kPIEFloat		Set the document's preference	for min element angle
	* MaxAngle			kPIEFloat		Set the document's preference	for max element angle

	* ExportDelimiter		kPIEString		Set the document's preference	for the delimiter at contour export

	* ExportSelectionOnly		kPIEBoolean		Set the document's preference	to export selection only
	* ExportTitles			kPIEBoolean		Set the document's preference	to export titles
	* ExportParameters		kPIEBoolean		Set the document's preference	to export parameters
	* ExportWrap			kPIEInteger		Set the document's preference	for wrap value for export
	* ExportSeparator		kPIEString		Set the document's preference	for separator used at export

	* ElemLinePrefix		kPIEString		Set the document's preference	for export element line prefix
	* NodeLinePrefix		kPIEString		Set the document's preference	for export node line prefix

	* CopyDelimiter			kPIEString		Set the document's preference	for the delimiter at contour copy
	* CopyName			kPIEBoolean		Set the document's preference	for copying contour name
	* CopyParameters		kPIEBoolean		Set the document's preference	for copying contour parameters
	* CopyIcon			kPIEBoolean		Set the document's preference	for copying contour icon

	* IncludeDiagonal		kPIEBoolean		Set the document's preference	for includeing diagonal in BW calculation
	* ChangeLayerLock		kPIEBoolean		Set the document's preference	for letting change layer locks
	* ArcSpliceAngle		kPIEFloat		Set the document's preference	for splice angle when copying arcs

	* MeshWithWells			kPIEBoolean		Set the document's preference	for considering point objects while meshing
	* SmallSegmentAffectDensity	kPIEBoolean		Set the document's preference	for meshing option
	* NumSmoothIterations		kPIEInteger		Set the document's preference	for smooth operations after meshing
	* MaxEdgeGrowth			kPIEInteger		Set the document's preference	for edge growth at meshing.
	*																		Value should be in the range 1..5
	* DensityGrowthRate		kPIEInteger		Set the document's preference	for density growth rate at meshing
	*																		Value should be in the range 1..5
	* C2CDistanceAffectDensity	kPIEBoolean		Set the document's preference	for contour-contour affect density during meshing
	* C2CThreshold			kPIEInteger		Set the document's preference	for value of contour-contour effect
	*																					Value should be in the range 1..5
	* C2WDistanceAffectDensity	kPIEBoolean		Set the document's preference	for contour-well affect density during meshing
	* C2WThreshold			kPIEInteger		Set the document's preference	for value of contour-well effect
	*																					Value should be in the range 1..5
	* W2WDistanceAffectDensity	kPIEBoolean		Set the document's preference	for well-well affect density during meshing
	* W2WThreshold			kPIEInteger		Set the document's preference	for value of well-well effect
	*																	Value should be in the range 1..5
	* RemovePoints			kPIEBoolean		Set the document's preference	for removing vertices on streight lines during meshing
	* EnhancedCleanup		kPIEBoolean		Set the document's preference	for enhanced cleanup after quadri. meshing
	* QuadriClear			kPIEBoolean		Set the document's preference	for clearing tri. after quadri. meshing

	* AGGInactive			kPIEBoolean		Set the document's preference	for block incativing after gridding
	*																0: by block center  1: by entire block
	* AllowRotatedGrid		kPIEBoolean		Set the document's preference	to allow rotated grid at gridding


	*/
}
function ANE_PropertyGet(const handle : ANE_PTR; const propertyName : ANE_STR;
  valueType : EPIENumberType ;const value :ANE_PTR) : ANE_BOOL ;
         cdecl; external 'ANECB.dll' name 'ANE_PropertyGet';

{ANE_BOOL ANE_PropertyGet(ANE_CPTR handle, ANE_CSTR propertyName, enum EPIENumberType valueType, ANE_CPTR value);
	/* get the given property of the document or application

	* Property Name				Type					Description
	* ProjectName			 kPIEString		Get the project Name
	* -------------				----					-----------
				-- Same as PropertySet ---

	*/   }


function ANE_LayerPropertySet(const handle : ANE_PTR;
         const layerHandle : ANE_PTR; const propertyName :ANE_STR;
         valueType : EPIENumberType; const value : ANE_PTR ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerPropertySet';

{ANE_BOOL ANE_LayerPropertySet(ANE_CPTR handle, ANE_CPTR layerHandle,
         ANE_CSTR propertyName, enum EPIENumberType valueType, ANE_CPTR value);}
{	/* set the given property of the layer

	* Property Name				Type			Description
	* -------------				----			-----------
	*			-- Contour Layer ONLY ---
	* Allow Intersection	                kPIEBoolean	Set the layer's allow intersection flag
                                ---- Grid Layer ONLY ----
        * GridReverseXDirection                 kPIEBoolean    Set to True to make the grid dircetion reversed in the X direction
        * GridReverseYDirection                 kPIEBoolean    Set to True to make the grid dircetion reversed in the Y direction

	*/
}


function ANE_LayerPropertyGet(const handle : ANE_PTR;
         const layerHandle : ANE_PTR; const propertyName : ANE_STR;
         valueType : EPIENumberType; const value : ANE_PTR) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerPropertyGet';

{ANE_BOOL ANE_LayerPropertyGet(ANE_CPTR handle, ANE_CPTR layerHandle,
         ANE_CSTR propertyName, enum EPIENumberType valueType, ANE_CPTR value);}
{	/* get the given property of the layer

	* Property Name		Type		    Description
	* -------------		----		    -----------
	* CoordXRight		kPIEBoolean	    Returns 'true' (1) if the X coordinate increases to the right
	* CoordYUp		kPIEBoolean	    Returns 'true' (1) if the X coordinate increases in the up direction
	* CoordUnits		kPIEString	    Returns coordinates' units name, e.g. "Km"
	* CoordScale		kPIEFloat	    Returns coordinates' scale factor
	* CoordXYRatio		kPIEFloat	    Returns the ratio of X to Y coordinates
        * GridReverseXDirection kPIEBoolean         Returns True if the Grid is reversed in the X direction
        * GridReverseYDirection kPIEBoolean         Returns True if the Grid is reversed in the Y direction
				-- Contour Layer ONLY ---
	* Allow Intersection	kPIEBoolean	    Get the layer's allow intersection flag


	*/
}


function ANE_LayerParameterPropertySet (const handle : ANE_PTR;
         parameterIndex : ANE_INT32; const layerHandle : ANE_PTR;
         const propertyName : ANE_STR; valueType : EPIENumberType;
         const value : ANE_PTR ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerParameterPropertySet';

{ANE_BOOL ANE_LayerParameterPropertySet(ANE_CPTR handle,
         ANE_INT32 parameterIndex, ANE_CPTR layerHandle,
         ANE_CSTR propertyName, enum EPIENumberType valueType, ANE_CPTR value);}
{	/* set the given property of the parameter

	* Property Name	   	Type	     	Description
	* -------------	   	----	     	-----------
	* Name		   	kPIEString   	Set parameter Name
	* Units		   	kPIEString   	Set parameter Units
	* Expr		   	kPIEString   	Set parameter default value expression
	* Lock		   	kPIEString   	Set parameter lock bits, e.g. "Lock Name, Dont Override, Inhibit Delete"
	* +Lock		   	kPIEString   	ADD parameter lock bits
	* -Lock		   	kPIEString   	REMOVE parameter lock bits

	*/
}


function ANE_LayerParameterPropertyGet(const handle : ANE_PTR;
         parameterIndex :ANE_INT32; const layerHandle : ANE_PTR;
         const propertyName : ANE_STR; valueType : EPIENumberType;
         const value : ANE_PTR) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerParameterPropertyGet';

{ANE_BOOL ANE_LayerParameterPropertyGet(ANE_CPTR handle,
          ANE_INT32 parameterIndex,
         ANE_CPTR layerHandle, ANE_CSTR propertyName,
         enum EPIENumberType valueType, ANE_CPTR value);}
{	/* get the given property of the parameter

	* Property Name		Type			Description
	* -------------		----			-----------
	* Name			kPIEString		Returns parameter Name
	* Units			kPIEString		Returns parameter Units
	* Expr			kPIEString		Returns parameter default value expression
	* Lock			kPIEString		Returns parameter lock bits, e.g. "Lock Name, Dont Override, Inhibit Delete"
	* Type			kPIEInteger		Returns parameter number type as enum EPIENumberType
	* TypeStr		kPIEString		Returns parameter number type as string, e.g. "String", "Float", etc.
	* ParamType		kPIEInteger		Returns parameter type as enum EPIEParameterType

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
		if it is a geographic layer that other layer is using.
                Return TRUE if a layer was removed}


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


function ANE_LayerGetNamesByType(const handle : ANE_PTR ;
         requestedTypes : EPIELayerType ) : ANE_STR_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetNamesByType';

// the ANE_STR's to which the return value of function points should be treated
// as constants

{ANE_CSTR* ANE_LayerGetNamesByType(ANE_CPTR handle, enum EPIELayerType requestedTypes);}
	{ get the names of all layers of a given type. The memory pointer returned by this
		function must be released using ANE_MemDelete. }


function ANE_LayerGetNumObjects(const handle : ANE_PTR;
         const layerHandle : ANE_PTR; objectType : EPIEObjectType) : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetNumObjects';

{ANE_INT32 ANE_LayerGetNumObjects(ANE_CPTR handle, ANE_CPTR layerHandle, enum EPIEObjectType objectType);}
{	/* returns the number of objects of type objectType in a specific layer */}


function ANE_LayerGetNthObjectHandle (const handle : ANE_PTR;
         const layerHandle : ANE_PTR; objectType : EPIEObjectType;
         objectIndex : ANE_INT32) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetNthObjectHandle';

// the return value of the function should be treated as a constant.
{ANE_CPTR ANE_LayerGetNthObjectHandle(ANE_CPTR handle, ANE_CPTR layerHandle,
  enum EPIEObjectType objectType, ANE_INT32 objectIndex);}
{	/* returns a handle to the nth object in a specific layer.
           0 <= objectIndex <= numObjects-1 */}

{
function ANE_LayerSetObjectInfo (const handle : ANE_PTR;
         const layerHandle : ANE_PTR; objectType : EPIEObjectType;
         const AnObject ANE_PTR:
         numValues : ANE_INT16; valuesTypes : EPIENumberType_PTR;
         valuesIndices : ANE_INT16_PTR; values : ANE_PTR_PTR) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerSetObjectInfo';
}
// "object" changed to "AnObject" to avoid conflict with Object Pascal keyword "object".

// the members of values should be treated as constants.
{ANE_BOOL ANE_LayerSetObjectInfo(ANE_CPTR handle, ANE_CPTR layerHandle,
         enum EPIEObjectType objectType,ANE_CPTR object, ANE_INT16 numValues,
         enum EPIENumberType* valuesTypes, ANE_INT16* valuesIndices, ANE_CPTR* values);}
{	/* Set the values of an object in a layer.

		Input:
			layerHandle - the target layer,
                          layerHandle=nil denotes current layer
			numValues - number of values to be set for the object
			valuesTypes - an array of length numValues,
                          where each element represents the type of the value
			valuesIndices	- an array of length numValues,
                          where each element holds the index of the parameter
                          to get the value
			values - an array of pointers to data values. value[i]
                          is a pointer to a value of type valuesTypes[i]
                          to be places in parameter valuesIndices[i]

		Return Value:
			if the function succeeds, it returns true.
			it if fails, it returns false. for more information about the error, call ANE_GetLastError()
	*/
}



function ANE_LayerGetObjectInfo(const handle : ANE_PTR;
         const layerHandle : ANE_PTR; objectType : EPIEObjectType;
         const AnObject : ANE_PTR;
         numValues : ANE_INT16; valuesTypes : EPIENumberType_PTR;
         valuesIndices : ANE_INT16_PTR; values : ANE_PTR_PTR): ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetObjectInfo';

// "object" changed to "AnObject" to avoid conflict with Object Pascal keyword "object".

{ANE_BOOL ANE_LayerGetObjectInfo(ANE_CPTR handle, ANE_CPTR layerHandle,
  enum EPIEObjectType objectType, ANE_CPTR object, ANE_INT16 numValues,
  enum EPIENumberType* valuesTypes, ANE_INT16* valuesIndices, ANE_CPTR* values);
	/* Get the values of an object in a layer.

		Input:
			layerHandle - the target layer,
                          layerHandle=nil denotes current layer
			numValues - number of values to be set for the object
			valuesTypes - an array of length numValues,
                          where each element represents the type of the value
			valuesIndices	- an array of length numValues,
                          where each element holds the index of the parameter
                          to get the value
			values - an array of pointers to data values.
                          value[i] is a pointer to a value of type
                          valuesTypes[i] to be filled with the value from
                          parameter valuesIndices[i]

		Return Value:
			if the function succeeds, it fills in the proper data
                          and returns true.
			it if fails, it returns false. for more information
                          about the error, call ANE_GetLastError()
	*/
}


function ANE_LayerGetType (const handle : ANE_PTR;
         const layerHandle : ANE_PTR) : EPIELayerType;
          cdecl; external 'ANECB.dll' name 'ANE_LayerGetType';

{enum EPIELayerType ANE_LayerGetType(ANE_CPTR handle, ANE_CPTR layerHandle);}
{/* return the type of the layer */}


//* Mesh Layer functions */
//*======================*/

//* NOTE: Make sure the objects you are sending these */
//* functions are REALLY node objects! */


procedure ANE_NodeObjectGetLocation(const handle : ANE_PTR;
         const layerHandle : ANE_PTR; const nodeObject : ANE_PTR;
         x : ANE_DOUBLE_PTR; y : ANE_DOUBLE_PTR);
          cdecl; external 'ANECB.dll' name 'ANE_NodeObjectGetLocation';

{void ANE_NodeObjectGetLocation(ANE_CPTR handle, ANE_CPTR layerHandle,
  ANE_CPTR nodeObject, ANE_DOUBLE* x, ANE_DOUBLE* y);}
{	/* puts in x and y the coordinates of the node object */
	/* 'nodeObject' is the reply of ANE_LayerGetNthObjectHandle() */}

//* NOTE: Make sure the objects you are sending these */
//* functions are REALLY element objects! */


function ANE_ElementObjectGetNumNodes(const handle : ANE_PTR;
         const layerHandle : ANE_PTR; const elementObject : ANE_PTR) : ANE_INT32
          cdecl; external 'ANECB.dll' name 'ANE_ElementObjectGetNumNodes';

{ANE_INT32 ANE_ElementObjectGetNumNodes(ANE_CPTR handle, ANE_CPTR layerHandle,
  ANE_CPTR elementObject);}
{	/* returns the number of nodes of element object */
	/* 'elementObject' is the reply of ANE_LayerGetNthObjectHandle() */}

procedure ANE_ElementObjectGetNthNodeLocation(const handle : ANE_PTR;
         const layerHandle : ANE_PTR; const elementObject : ANE_PTR;
         n : ANE_INT32; x : ANE_DOUBLE_PTR; y : ANE_DOUBLE_PTR);
          cdecl; external 'ANECB.dll' name 'ANE_ElementObjectGetNthNodeLocation';

{void ANE_ElementObjectGetNthNodeLocation(ANE_CPTR handle, ANE_CPTR layerHandle,
  ANE_CPTR elementObject, ANE_INT32 n, ANE_DOUBLE* x, ANE_DOUBLE* y);}
{	/* puts in x and y the coordinates of the n'th node of element object */
	/* 'elementObject' is the reply of ANE_LayerGetNthObjectHandle() */}


//* Grid Layer functions */
//*======================*/


procedure ANE_BlockObjectGetLocation(const handle : ANE_PTR;
         const layerHandle : ANE_PTR; const blockObject : ANE_PTR;
         x : ANE_DOUBLE_PTR; y : ANE_DOUBLE_PTR);
          cdecl; external 'ANECB.dll' name 'ANE_BlockObjectGetLocation';

{void ANE_BlockObjectGetLocation(ANE_CPTR handle, ANE_CPTR layerHandle,
  ANE_CPTR blockObject, ANE_DOUBLE* x, ANE_DOUBLE* y);}
{	/* puts in x and y the coordinates of the block object */
	/* NOTE: x and y should point to an ARRAY of 4 doubles! */
	/* 'blockObject' is the reply of ANE_LayerGetNthObjectHandle() */}


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





{ Data Layer functions }
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
		The first parameter of point i is dataParameters[0][i],
		the second: dataParameters[1][i], etc.
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

//* NOTE: Make sure the objects you are sending these */
//* functions are REALLY data point objects! */

{
procedure ANE_DataPointObjectGetLocation(const handle : ANE_PTR;
         const layerHandle : ANE_PTR; const dataObject : ANE_PTR;
         x : ANE_DOUBLE_PTR; y : ANE_DOUBLE_PTR);
          cdecl; external 'ANECB.dll' name 'ANE_DataPointObjectGetLocation';
}
{void ANE_DataPointObjectGetLocation(ANE_CPTR handle, ANE_CPTR layerHandle,
  ANE_CPTR dataObject, ANE_DOUBLE* x, ANE_DOUBLE* y);}
{	/* puts in x and y the coordinates of the data point object */
	/* 'dataObject' is the reply of ANE_LayerGetNthObjectHandle() */}



//* Contour object handling functions */
//*===================================*/

//* NOTE: Make sure the objects you are sending these */
//* functions are REALLY a contour objects! */

function ANE_ContourObjectGetNumVertices(const handle : ANE_PTR; const layerHandle : ANE_PTR;
  const contourObject : ANE_PTR) : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_ContourObjectGetNumVertices';


{
ANE_INT32 ANE_ContourObjectGetNumVertices(ANE_CPTR handle, ANE_CPTR layerHandle, ANE_CPTR contourObject);
	/* returns the number of vertices in contour object */
	/* 'contourObject' is the reply of ANE_LayerGetNthObjectHandle() */
}


procedure ANE_ContourObjectGetNthVertexLocation(const handle : ANE_PTR;
  const layerHandle : ANE_PTR; const contourObject : ANE_PTR;
  n : ANE_INT32; x : ANE_DOUBLE_PTR; y: ANE_DOUBLE_PTR)
          cdecl; external 'ANECB.dll' name 'ANE_ContourObjectGetNthVertexLocation';


{void ANE_ContourObjectGetNthVertexLocation(ANE_CPTR handle,
  ANE_CPTR layerHandle, ANE_CPTR contourObject,
  ANE_INT32 n, ANE_DOUBLE* x, ANE_DOUBLE* y);}
{	/* puts in x and y the coordinates of the n'th vertex of contour object */
	/* 'contourObject' is the reply of ANE_LayerGetNthObjectHandle() */}

//* Picture object handling functions */
//*===================================*/

//* NOTE: Make sure the objects you are sending these */
//* functions are REALLY picture objects! */

{
function ANE_PictureObjectGetType(const handle : ANE_PTR;
  const layerHandle : ANE_PTR; const pictObject : ANE_PTR) : EPIEObjectType;
          cdecl; external 'ANECB.dll' name 'ANE_PictureObjectGetType';
}
{enum EPIEObjectType ANE_PictureObjectGetType(ANE_CPTR handle,
  ANE_CPTR layerHandle, ANE_CPTR pictObject);}
{	/* return the type of object*/}

{
function ANE_PictureContourObjectGetNumVertices(const handle : ANE_PTR;
  const layerHandle : ANE_PTR; const pictObject : ANE_PTR) : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_PictureContourObjectGetNumVertices';
}
{ANE_INT32 ANE_PictureContourObjectGetNumVertices(ANE_CPTR handle,
  ANE_CPTR layerHandle, ANE_CPTR pictObject);}
{/* returns the number of vertices in contour pict object */
	/* 'pictObject' is the reply of ANE_LayerGetNthObjectHandle() */
	/* make sure ANE_PictureObjectGetType returned kPIEPictPolygonObject
        for 'pictObject'!*/}

{
procedure ANE_PictureContourObjectGetNthVertexLocation(const handle : ANE_PTR;
  const layerHandle : ANE_PTR; const pictObject : ANE_PTR; n : ANE_INT32;
  x : ANE_DOUBLE_PTR; y: ANE_DOUBLE_PTR);
          cdecl; external 'ANECB.dll' name 'ANE_PictureContourObjectGetNthVertexLocation';
}
{void ANE_PictureContourObjectGetNthVertexLocation(ANE_CPTR handle,
  ANE_CPTR layerHandle, ANE_CPTR pictObject, ANE_INT32 n, ANE_DOUBLE* x,
  ANE_DOUBLE* y);}
{	/* puts in x and y the coordinates of the n'th vertex of contour pict object */
	/* 'pictObject' is the reply of ANE_LayerGetNthObjectHandle() */
	/* make sure ANE_PictureObjectGetType returned kPIEPictPolygonObject for 'pictObject'!*/}


{ User Interface functions }
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


function ANE_UserMessageOkCancel(const handle : ANE_PTR ;
         const prompt : ANE_STR ) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_UserMessageOkCancel';

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


function ANE_UserSelectItem(const handle : ANE_PTR ; items : ANE_STR_PTR ;
         const title : ANE_STR ; const prompt : ANE_STR ) : ANE_INT32;
          cdecl; external 'ANECB.dll' name 'ANE_UserSelectItem';
// the members of "items" should be treated as constants by Argus ONE.

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

{"type" changed to "NumberType" to avoid conflict with Object Pascal keyword "type".}
{"string" changed to "StringToEvaluate" to avoid conflict with Object Pascal keyword "string".}

function ANE_ParseExpression(const handle : ANE_PTR ;
   const layerHandle : ANE_PTR ; NumberType : EPIENumberType ;
   const StringToEvaluate : ANE_STR ) : ANE_PTR;
          cdecl; external 'ANECB.dll' name 'ANE_ParseExpression';
// the result of ANE_ParseExpression should be treated as a constant.
{ANE_CPTR ANE_ParseExpression(ANE_CPTR handle, ANE_CPTR layerHandle,
  enum EPIENumberType type, ANE_CSTR string);}
{	/* parses 'string' that is supposed to yield value of type 'type',
           use the evaluation centext
	   of layer pointed by 'layerHandle' the returned pointer can be used
           with
	   ANE_EvaluateParsedStringAtPos, and MUST be freed with
           ANE_FreeParsedExpression when finished  */}


procedure ANE_EvaluateParsedExpressionAtPos(const handle : ANE_PTR ;
  const parsedExpression : ANE_PTR ; x : ANE_DOUBLE_PTR; y: ANE_DOUBLE_PTR;
  result : ANE_PTR);
          cdecl; external 'ANECB.dll' name 'ANE_EvaluateParsedExpressionAtPos';

{void ANE_EvaluateParsedExpressionAtPos(ANE_CPTR handle,
  ANE_CPTR parsedExpression, ANE_DOUBLE* x, ANE_DOUBLE* y, ANE_PTR result);}
{	/* evaluate a parsed expression at location (x, y).
        the result will be stored into 'result' */}

procedure ANE_FreeParsedExpression(const handle : ANE_PTR ;
  const parsedExpression : ANE_PTR);
          cdecl; external 'ANECB.dll' name 'ANE_FreeParsedExpression';
{void ANE_FreeParsedExpression(ANE_CPTR handle, ANE_CPTR parsedExpression);}
{	/* free the memory occupied by the parsed expression */}


//* Progress Bar handling*/
//*======================*/

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
function ANE_ProgressSet (const handle : ANE_PTR; value : ANE_INT32): ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_ProgressSet';
}
{ANE_BOOL ANE_ProgressSet(ANE_CPTR handle, ANE_INT32 value);}
{	/* set the current position of the progress bar to value */}

{
function ANE_ProgressSetTitle(const handle : ANE_PTR; const title : ANE_STR): ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_ProgressSetTitle';
}
{ANE_BOOL ANE_ProgressSetTitle(ANE_CPTR handle, ANE_CSTR title);}
{	/* set the progress bar title */}


{
function ANE_ProgressAdvance(const handle : ANE_PTR) : ANE_BOOL;
          cdecl; external 'ANECB.dll' name 'ANE_ProgressSet';
}          
{ANE_BOOL ANE_ProgressAdvance(ANE_CPTR handle);}
{	/* increments a progress bar of type barbershop */}

implementation



end.


