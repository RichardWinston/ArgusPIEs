unit ANE_LayerUnit;

interface

// ANE_LayerUnit provides class-based methods for handling layers and
// parameters in Argus ONE. The classes defined here are not generally
// used directly but instead serve as ancestors to more specialized
// descendents.

uses Classes, SysUtils, Dialogs, Forms, Controls, contnrs,
     AnePIE, ANECB, OptionsUnit ;

Var
  EditWindowOpen : boolean = False;
{
Use EditWindowOpen to protect global variables.
For example when openning a form directly from Argus ONE,
do something like this.

begin
  if EditWindowOpen
  then
    begin
      Result := False ;
    end
  else
    begin
      EditWindowOpen := True ;
      try
        begin
          // Do what you need to do with the form.
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end; // try
    end; // if EditWindowOpen else
end;
}

ResourceString
  kDomOut = 'Domain Outline';
  kDensity = 'Density';
  kMaps = 'Maps';
  kNA = '$N/A';

type

// The following exception classes are used in controlling what objects may be
// used in the creation of an object.

EInvalidParameterListOwner = class(Exception);
// If you try to create a T_ANE_ParameterList and the owner is neither
// a T_ANE_Layer  nor a T_ANE_ListOfIndexedParameterLists, then
// EInvalidParameterListOwner will be raised

EInvalidLayerListOwner = class(Exception);
// If you try to create a T_ANE_LayerList and the owner is neither
// a TLayerStructure  nor a T_ANE_ListOfIndexedLayerLists, then
// EInvalidLayerListOwner will be raised

EInvalidParameter = class(Exception) ;
// If you attempt to create a parameter and the Ane_ParamName of the parameter
// does not occur in ParameterOrder but the number of items in ParameterOrder
// is greater than 0, EInvalidParameter will be raised

EInvalidLayer = class(Exception);
// If you attempt to create a layer and the Ane_LayerName of the layer
// does not occur in LayerOrder but the number of items in LayerOrder
// is greater than 0, EInvalidLayer will be raised

EInvalidName = Class(Exception);
// If you attemp to add or insert a string into a TTestStringList in which
// that string already occurs, EInvalidName will be raised

ELayerNotFound = class(exception);
// if you attempt to add a parameter to a layer that does not exist,
// ELayerNotFound will be raised

EInvalidParameterList = class(Exception);
// if you attempt to move a parameter to a parameter list of a different layer
// EInvalidParameterList is raised.

TLayerLockValues = (llName, llUnits, llType, llInfo, llEvalAlg, llAll_Params,
                            llInhibit_Delete);

TLayerLock = set of TLayerLockValues;
// TLayerLock controls which layer characteristics will be locked when an
// Argus ONE layer is created.

// llName: The name of the layer will be locked and the user will not be able
//         to edit the name without unlocking it.
// llUnits: The units of the layer will be locked and the user will not be able
//         to edit the units without unlocking them.
// llType: The layer type will be locked and the user will not be able
//         to edit the layer type without unlocking it.
// llInfo: The layer tags will be locked and the user will not be able
//         to edit the layer tags without unlocking them.
// llEvalAlg: The interpretation method of the layer will be locked and the
//         user will not be able to change the interpretation method without
//         unlocking it.
// llAll_Params: All parameters of the layer will be locked.
// llInhibit_Delete: The user will not be able to delete the layer without
//         unlocking it.

TLayerParameterType = (lptLayer);
TGridParameterType = (gptLayer, gptBlock);
TMeshParameterType = (mptLayer, mptElement, mptNode);
// These three enumerated types are used to control whether a particular
// parameter is a layer, block, element of node parameter.

TParameterValueType = ( pvString, pvReal, pvInteger, pvBoolean);
TDataParameterValueType = (dpvReal);
// These two enumberated types determine what sort of data may be used
// for a particular parameter.

Const
  StandardLayerLock : TLayerLock = [llName, llType, llInhibit_Delete];
  StandardParameterLock : TParamLock = [plName, plType, plInhibit_Delete];
// By default, all new layers and parameters will have the properties
// specified in StandardLayerLock and StandardParameterLock locked.

type
  TStatus = (sNormal, sNew, sDeleted, sWritten);
// TStatus is used in adding and removing layers and parameters. When the user
// has indicated that a layer or parameter should be removed, its status
// should
// be changed to sDeleted (using the Delete) procedure. However, the layer is
// not actually freed until the OK procedure of TLayerStructure is called.
// If the Cancel procedure is called instead of the the OK procedure, Layers
// and
// parameters that had been "deleted" will be returned to normal status.
// Similarly when the user indicates that a layer or parameter is should be
// created, it is assigned a status of sNew. Only when the OK procedure is
// called
// is Argus ONE told to create the layer or parameter. If the Cancel procedure
// is called instead of the OK procedure all layers and parameters objects
// with
// a status of sNew will be destroyed and the status of deleted layers is
// changed back to sNormal. It is not normally neccessary to set the
// status of a parameter directly though it may be necessesary to check it.

type TLayerEvaluationType = (leNearest, leExact, leInterpolate, leScan2d,
  leNN2D, leInvDistSq, le624Noxzyz, le624, leQT_Nearest, leQT_Mean5,
  leQT_Mean20, leQT_InvDistSq5, leQT_InvDistSq20, leQT_NearestA100,
  leQT_Mean5A100, leQT_Mean20A100, leQT_InvDistSq5A100, leQT_InvDistSq20A100);
// TLayerEvaluationType is used to specify whether a layer should
// use the Nearest, Exact, or Interpolate methods.
// (If additional methods are defined by new Interpolation PIEs this type
// will need to updated to reflect those new PIEs and other changes will need
// to be made where TLayerEvaluationType is used.

// The following are forward declarations of classes to allow them to be
// used as properties in other classes.
T_ANE_Param = class;
T_ANE_ParameterList = class;
T_ANE_IndexedParameterList = class;
T_ANE_ListOfIndexedParameterLists = class;
T_ANE_MapsLayer = class;
T_ANE_Layer = class;
T_ANE_DataLayer = class;
TIndexedInfoLayer = class;
T_ANE_LayerList = class;
T_ANE_ListOfIndexedLayerLists = class;
TLayerStructure = class;

// The following are meta classes defined so that class types may be used as
// parameter arguements.
T_ANE_ParamClass = class of T_ANE_Param;
T_ANE_LayerClass = class of T_ANE_Layer;
T_ANE_MapsLayerClass = class of T_ANE_MapsLayer;
T_ANE_DataLayerClass = class of T_ANE_DataLayer;
TIndexedInfoLayerClass = class of TIndexedInfoLayer;
T_ANE_IndexedParameterListClass = class of T_ANE_IndexedParameterList;

TTestStringList = Class(TStringList)
  // TTestStringList is a string list that raises an EInvalidName exception if
  // a duplicate is added to or inserted in the list.  Unlike TStringList, a
  // TTestStringList need not be sorted to raise an exception.
  public
    function Add(const S: string): Integer; override;
    // Add and Insert will raise an EInvalidName exception if S is already
    // in the TTestStringList.
    // Otherwise Add and Insert are the same as in TStringList.
    procedure Insert(Index: Integer; const S: string); override;
    // Add and Insert will raise an EInvalidName exception if S is already
    // in the TTestStringList.
    // Otherwise Add and Insert are the same as in TStringList.
  end;

T_ANE_Param = class(TObject)
// T_ANE_Param is the base class for all other Argus ONE parameter classes.
// Because it has abstract functions, only parameters derived from T_ANE_Param
// may actually be used.
  private
    SetUnits : boolean;
    FStatus : TStatus;
    FSetExpressionNow: boolean;
    FOldRoot : string;
    FOldName : string;
    FLock : TParamLock;
    OldLock : TParamLock;
    FNeedToUpdateParamName: boolean;
//    FUnits: string; // see TStatus.
    function WriteLock(const CurrentModelHandle : ANE_PTR) : string;
    // WriteLock calls EvaluateLock and then writes a string representing
    // the characteristics of the parameter that are locked.
    procedure FreeByStatus(AStatus : TStatus);
    // FreeByStatus will destroy the parameter if that calls it if the status
    // of the paramter is the same as AStatus. FreeByStatus is called by the
    // TLayerStructure.OK procedure to destroy deleted parameters. It is also
    // called by the TLayerStructure.Cancel procedure to destroy new parameters.

    // If the Name property of the parameter is equal to AName, DeleteByName
    // will call the Delete procedure.
//    procedure DeleteByName(AName : string);
    // GetParentLayerHandle returns the handle of the T_ANE_Layer that
    // (indirectly)
    // owns the parameter.
//    function GetParentLayerHandle: ANE_PTR;
    // This returns the index used by Argus ONE to identify the position
    // of the parameter in the list of parameters.
    function RemoveParameter(const CurrentModelHandle : ANE_PTR;
      const LayerHandle : ANE_PTR) : ANE_BOOL;
    // RemoveParameter instructs Argus ONE to remove the parameter.
    function RenameParameter(const CurrentModelHandle : ANE_PTR;
      const LayerHandle : ANE_PTR) : ANE_BOOL;
    // RenameIndexedParameter changes the name of a parameter owned by a
    // T_ANE_IndexedParameterList
    function GetPreviousParameter : T_ANE_Param;
    // GetPreviousParameter returns the parameter after which the current
    // parameter should be added in Argus ONE.
    procedure AddNewParameter(const CurrentModelHandle : ANE_PTR;
      const LayerHandle : ANE_PTR);
    // AddNewParameter adds a new parameter in Argus ONE.
    procedure SetExpression(const CurrentModelHandle : ANE_PTR;
      const LayerHandle : ANE_PTR);
    // SetExpression sets the expression of a parameter if SetValue
    // and SetExpressionNow are True.
    // It should only be called after all parameters that should be added or
    // deleted from Argus ONE have been added or deleted.
    procedure FixParam(const CurrentModelHandle, LayerHandle: ANE_PTR);
    procedure SetParameterUnits(const CurrentModelHandle,
      LayerHandle: ANE_PTR; UseOldIndex : Boolean);
    function WriteCurrentName : string;
    procedure SetLock(Value : TParamLock);
    procedure UpdateOldName;
    procedure DontNeedToUpdateParamName;
  protected
    function WriteValueType : string;  virtual; abstract;
    // WriteValueType writes a string representation of the type of value
    // of the parameter. Most parameters can be strings, integers, reals, or
    // booleans but data parameters can only be reals.
    function WriteParameterType : string; virtual;
    // WriteParameterType writes a string representation of the parameter
    // type. Most parameters can only be layer parameters. Grid parameters
    // can be either layer or block parameters. Mesh parameters can be
    // either layer, element, or node parameters.
    function SetArgusLock(const CurrentModelHandle,
      LayerHandle: ANE_PTR): ANE_BOOL; virtual;
    function LockString(const CurrentModelHandle: ANE_PTR;
      ALock : TParamLock): string; virtual;
    procedure RestoreLock; virtual;
  public
    // Lock determines which parameter properties are locked.
    // default = StandardParameterLock.
    ParameterList : T_ANE_ParameterList;
    // ParameterList is the T_ANE_ParameterList (or T_ANE_ParameterList
    // descendent) that owns the parameter. It is automatically set when
    // the parameter is created and should not normally be changed.
    SetValue : boolean;
    // if SetValue is True, the expression for a parameter will be set
    // automatically when the TLayerStructure OK procedure is called.
    // The actual value that will be set will be determined by the Value
    // function. SetValue is false by default. Mesh and Grid parameters are
    // the ones most likely to need to have their expressions set in the
    // OK procedure.
    ParameterType : TLayerParameterType;
    // ParameterType indicates whether the parameter is a layer, node
    // element or block parameter. The declaration of ParameterType
    // is overridden in Mesh and Grid parameters.
    constructor Create(AParameterList : T_ANE_ParameterList;
      Index : Integer = -1);
      virtual;
    // Create creates a parameter. AParameterList is the Parameterlist that
    // owns the new parameter. Index is the position within the parameter list
    // of the new parameter. If the position indicated by Index is invalid,
    // the parameter will be added at the end of the list. Thus using an
    // Index less than 0 results in the parameter being added to the end of the
    // list. By itself, creating a parameter does not instruct Argus ONE to
    // add the layer. That is done in the TLayerStructure.OK procedure which
    // calls the AddNewParameter procedure.
    class Function ANE_ParamName : string ; virtual;
    // ANE_ParamName is (usually) related to the name of the parameter passed to
    // Argus ONE.
    // However, if the parameter belongs to a T_ANE_IndexedParameterList,
    // the name of the parameter passed to Argus ONE will also include
    // the Index or OldIndex of the T_ANE_IndexedParameterList. The WriteName
    // or the WriteIndex and WriteOldIndex
    // functions may be overridden to change the name of a parameter used by
    // Argus ONE without changing the name used in the PIE.
    // see also: WriteSpecialBeginning, WriteSpecialMiddle, and
    // WriteSpecialEnd
    Destructor Destroy; override; // Destroys the parameter.
    // Destroy destroys the parameter.
    function Value : string; virtual;
    // Value is used to set the expression of value of a parameter. By default
    // Value returns '0'. Value will need to be overridden by most mesh and
    // grid parameters.
    function WriteOldIndex : string; virtual;
    // WriteOldIndex returns as string representation of the OldIndex of
    // the T_ANE_IndexedParameterList that owns the parameter if it is
    // owned by a T_ANE_IndexedParameterList. Otherwise it returns ''
    // If WriteOldIndex is overidden, WriteIndex must also be overidden;
    function WriteIndex : string; virtual;
    // WriteIndex returns as string representation of the Index of
    // the T_ANE_IndexedParameterList that owns the parameter if it is
    // owned by a T_ANE_IndexedParameterList. Otherwise it returns ''
    // If WriteIndex is overidden, WriteOldIndex must also be overidden;
    function WritePar(const aneHandle : ANE_PTR) : string; virtual;
    // WritePar returns a string representation of all the Parameter properties
    // that can be passed to Argus ONE to create the parameter in Argus ONE.
    procedure Delete;  virtual;
    // Delete will destroy the parameter that calls it if its status is SNew.
    // Otherwise, it will change the parameter status to sDeleted.
    procedure UnDelete;  virtual;
    // Undelete will change the status of a parameter from sDeleted to sNormal.
    function GetParentLayer : T_ANE_Layer;
    // GetParentLayer returns the T_ANE_Layer that owns the T_ANE_ParameterList
    // that owns the parameter. It is called by GetParentLayerHandle.
    function WriteName : string ; virtual;
    // returns the "root" of the name of the parameter in Argus ONE. By default
    // this is the "Name" of the parameter. WriteName may be overridden to
    // specify some other name to use in Argus ONE.
    // see also WriteIndex, WriteSpecialBeginning, WriteSpecialMiddle, and
    // WriteSpecialEnd
    function WriteSpecialBeginning : String ; virtual;
    // WriteSpecialBeginning is a rarely used
    // function that can be used to modify the name assigned to a parameter
    // by adding a string before the WriteName.
    function WriteSpecialMiddle : String ; virtual;
    // WriteSpecialMiddle is a rarely used
    // function that can be used to modify the name assigned to a parameter
    // by adding a string between WriteName and the index.
    function WriteSpecialEnd : String ; virtual;
    // WriteSpecialEnd is a rarely used
    // function that can be used to modify the name assigned to a parameter
    // by adding a string after the index.
    property SetExpressionNow : boolean read FSetExpressionNow write FSetExpressionNow;
    // SetSetExpressionNow is used to force Argus ONE to set an expression
    // during TLayerStructure.OK.
    function Units : string; virtual;
    // Units - the units of the parameter.
    class function WriteParamName : string; virtual;
    property Status : TStatus read FStatus ;
    procedure Move (ParamList : T_ANE_ParameterList; Index : integer = -1);
    // Move removes a parameter from its current parameter list and puts it
    // in a new parameter list. It must be a parameter list of the same layer.
    function WriteNewName : string; virtual;
    property Lock : TParamLock read FLock Write SetLock ;
    function EvaluateLock: TParamLock; virtual;
    property OldName : string read FOldName;
    function GetParameterIndex(const CurrentModelHandle : ANE_PTR;
      UseOldIndex : Boolean; const LayerHandle : ANE_PTR) : ANE_INT32;
    procedure NeedToUpdateParamName;
  end;

T_ANE_DataParam = class(T_ANE_Param)
  // Use T_ANE_DataParam for parameters on data layers.
  private
    ValueType : TDataParameterValueType;
    // This is the type of data in the data parameter. At present,
    // data parameters must always be real numbers.
  protected
    function WriteValueType : string; override;
    // returns a string indicating the type of data in the data parameter.
    // At present, data parameters must always be real numbers.
  public
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1 ); override;
    // see T_ANE_Param
  end;

T_ANE_NamedDataParam = class(T_ANE_DataParam)
  private
    FName : string;
  public
    constructor Create(Name : string; AParameterList : T_ANE_ParameterList;
    Index : Integer = -1); reintroduce; virtual;
    function WriteName : string ; override;
  end;

T_ANE_LayerParam = class(T_ANE_Param)
  // use T_ANE_LayerParam on information layers
  protected
    function WriteValueType : string; override;
    // returns a string indicating the type of data in the layer parameter.
    // At present, Layer parameters may be strings, integers, reals, or booleans.
  public
    ValueType : TParameterValueType;
    // This is the type of data in the layer parameter. At present,
    // layer parameters may be strings, integers, reals, or booleans.
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
    // see T_ANE_Param
  end;

T_ANE_NamedLayerParam = class(T_ANE_LayerParam)
  protected
    FName : string;
  public
    constructor Create(Name : string; AParameterList : T_ANE_ParameterList;
    Index : Integer = -1); reintroduce; virtual;
    function WriteName : string ; override;
  end;

T_ANE_ParentIndexLayerParam = class(T_ANE_LayerParam)
//  private
//    function GetUnits: string;
//    function Units: string;
  // use T_ANE_ParentIndexLayerParam for information layer parameters that
  // should have the same index as their parent layer rather than the index
  // of their own parameterlist's position within a list of indexed parameter
  // lists.
//  published
//    procedure SetUnits(const Value: string); override;
  public
    function WriteName : string; override;
    // WriteName will write the parent layer's ANE_LayerName
    function WriteIndex : string; override;
    // WriteIndex will write the parent layer's index. It is used in
    // renaming parameters within Argus ONE when the index has changed.
    Function WriteOldIndex : string; override;
    // WriteOldIndex will write the parent layer's oldindex. It is used in
    // renaming parameters within Argus ONE when the index has changed.
    function Units : string; override;
    // Units will write the parent layer's Units
  end;

T_ANE_MeshParam = class(T_ANE_LayerParam)
  // use T_ANE_LayerParam on tri-mesh and quad-mesh layers
  protected
    function WriteParameterType : string; override;
    // writes a string indicating the parameter type. At present, mesh
    // parameters
    // may be layer, node, or element parameters.
  public
    ParameterType : TMeshParameterType;
    // This is the type of parameter. At present, mesh parameters
    // may be layer, node, or element parameters.
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
    // see T_ANE_Param; the default values of mesh parameters are locked.
  end;

T_ANE_GridParam = class(T_ANE_LayerParam)
  // use T_ANE_LayerParam on grid layers
  protected
    function WriteParameterType : string; override;
    // writes a string indicating the parameter type. At present, grid
    // parameters
    // may be layer, or block parameters.
  public
    ParameterType : TGridParameterType;
    // This is the type of parameter. At present, grid parameters
    // may be layer, or block parameters.
    constructor Create(AParameterList : T_ANE_ParameterList; Index : Integer
      = -1); override;
    // see T_ANE_Param; the default values of grid parameters are locked.
  end;

T_ANE_NamedGridParam = class(T_ANE_GridParam)
  private
    FName : string;
  public
    constructor Create(Name : string; AParameterList : T_ANE_ParameterList;
      Index : Integer = -1); reintroduce; virtual;
    function WriteName : string ; override;
  end;

T_ANE_MapsLayer = class(TObject)
// T_ANE_MapsLayer is the base object for all Argus ONE layer objects.
// T_ANE_MapsLayer can not have any parameters. It may be used for Map Layers.
  private
    FStatus : TStatus;
    // See TStatus
    SetUnits : boolean;
    LayerType : string;
    // LayerType is a string used to indicate what type of layer is being
    // created in Argus ONE. The value of LayerType is set in "Create" in
    // T_ANE_MapsLayer and its descendents.
    FOldRoot : string;
    FNeedToUpdateParamName : boolean;
    function WriteLock(const CurrentModelHandle : ANE_PTR) : string;
    // WriteLock writes a string representing the characteristics of the
    // layer that are locked.
    function RemoveLayer(const CurrentModelHandle : ANE_PTR) : ANE_BOOL;
    // RemoveLayer removes the layer from Argus ONE
    function RenameLayer(const CurrentModelHandle : ANE_PTR) : ANE_BOOL;
    // RenameIndexedLayer changes the name of the layer in Argus ONE from
    // Name + OldIndex to Name + NewIndex.
    procedure AddMultipleNewLayers(const CurrentModelHandle: ANE_PTR;
       var LayerTemplate: String;  var PreviousLayer: T_ANE_MapsLayer);
    procedure NeedToUpdateParamName;
  protected
    function WriteDomDens : string; virtual;
    // WriteDomDens returns ''. It is overriden in T_ANE_TriMeshLayer
    function WriteInterpPie : string; virtual;
    function WriteInterpMethod : string; virtual;
    // WriteInterpMethod returns ''. It is overriden in T_ANE_InfoLayer
    function WriteParameters(const CurrentModelHandle : ANE_PTR) : string; virtual;
    // WriteParameters returns ''. It is overriden in T_ANE_Layer
    procedure SetParametersStatus(AStatus : TStatus); virtual;
    // SetParametersStatus does nothing. It is overridden in T_ANE_Layer
    procedure FreeByStatus(AStatus : TStatus); virtual;
    // FreeByStatus will destroy all layers whose Status is equal to AStatus.
    procedure UpdateParameterIndicies; virtual;
    // UpdateParameterIndicies does nothing. It is overridden in T_ANE_Layer
    procedure UpdateOldParameterIndicies; virtual;
    // UpdateOldParameterIndicies does nothing. It is overridden in T_ANE_Layer
    procedure RemoveDeletedParameters(const CurrentModelHandle: ANE_PTR); virtual;
    // RemoveDeletedParameters does nothing. It is overridden in T_ANE_Layer.
    procedure RenameIndexedParameters(const CurrentModelHandle: ANE_PTR); virtual;
    // RenameIndexedParameters does nothing. It is overridden in T_ANE_Layer.
    procedure SetNewParametersToNormal; virtual;
    // SetNewParametersToNormal does nothing. It is overridden in T_ANE_Layer.
    procedure ArrangeParameters; virtual;
    // ArrangeParameters does nothing. It is overridden in T_ANE_Layer.
    procedure SetExpressions(const CurrentModelHandle: ANE_PTR); virtual;
    // SetExpressions does nothing. It is overridden in T_ANE_Layer.
    function WriteTemplate : string; virtual;
    // WriteTemplate does nothing. It is overridden in T_ANE_TriMeshLayer
    // WriteTemplate does nothing. It is overridden in T_ANE_GridLayer
    function WriteReverseGridX(const CurrentModelHandle : ANE_PTR) : string; virtual;
    // WriteTemplate does nothing. It is overridden in T_ANE_GridLayer
    function WriteReverseGridY(const CurrentModelHandle : ANE_PTR) : string; virtual;
    function WriteGridBlockCentered(const CurrentModelHandle : ANE_PTR) : string; virtual;
    procedure SetNewParametersToWritten; virtual;
    procedure SetWrittenParametersToNormal; virtual;
    procedure SetParamLock(const CurrentModelHandle: ANE_PTR); virtual;
    procedure RestoreParamLock; virtual;
    procedure UpdateOldName; virtual;
    procedure DontNeedToUpdateParamName; virtual;
  public
    Visible : boolean;
    // determines whether or not a layer is visible. Default is
    // true (= layer is visible).
    LayerList : T_ANE_LayerList;
    // LayerList the the layer list the owns the layer. LayerList is set when a
    // layer is created and should not normally be changed.
    Lock : TLayerLock;
    // Lock indicates which characteristics of the layer are locked.
    // default = StandardLayerLock.
    DataIndex : Integer;
    procedure AddNewParameters(const CurrentModelHandle: ANE_PTR); virtual;
    // AddNewParameters does nothing. It is overridden in T_ANE_Layer.
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      = -1); virtual;
    // Create creates a layer. ALayerList is the T_ANE_LayerList that
    // owns the new layer. Index is the position within the T_ANE_LayerList
    // of the new layer. If the position indicated by Index is invalid,
    // the layer will be added at the end of the list. Thus using an
    // Index less than 0 results in the layer being added to the end of the
    // list. By itself, creating a layer does not instruct Argus ONE to
    // add the layer. That is done in the TLayerStructure.OK procedure which
    // calls the AddNewLayer procedure.
    destructor Destroy; override;
    // destroys the layer.
    function Units : string; virtual;
    // the units of the layer.
    function WriteOldIndex : string; virtual;
    // WriteOldIndex returns as string representation of the OldIndex of
    // the T_ANE_IndexedLayerList that owns the parameter if it is
    // owned by a T_ANE_IndexedLayerList. Otherwise it returns ''
    function WriteIndex : string; virtual;
    // if the layer is owned by a T_ANE_IndexedLayerList, WriteIndex returns
    // a string represntation of the Index of that T_ANE_IndexedLayerList.
    // Otherwise it returns ''.
    function WriteLayer(const CurrentModelHandle : ANE_PTR) : string; virtual;
    // WriteLayer returns a string that can be passed to Argus ONE to create a
    // layer.
    procedure Delete; virtual;
    // if the status of a layer is sNew, calling delete will call the layer.
    // Otherwise, it will change the status of the layer to sDeleted.
    function GetPreviousLayer : T_ANE_MapsLayer; virtual;
    // GetPreviousLayer returns the layer after which it is appropriate to
    // add this layer.
    function GetLayerHandle(const CurrentModelHandle : ANE_PTR): ANE_PTR; virtual;
    // GetLayerHandle gets the handle of the layer.
    procedure UnDelete; virtual;
    // Undelete will change the status of a layer from sDeleted to sNormal.
    procedure DeleteByName(AName : string); virtual;
    // DeleteByName will call Delete is Name equals AName
    procedure CreateParamterList1; virtual;
    // CreateParamterList1 does nothing. Override to create an indexed parameter
    // list that will be added to IndexedParamList1 in T_ANE_Layer
    procedure CreateParamterList2; virtual;
    // CreateParamterList2 does nothing. Override to create an indexed parameter
    // list that will be added to IndexedParamList2 in T_ANE_Layer
    class Function ANE_LayerName : string ; virtual;
    // ANE_LayerName is related to the name of the layer used in Argus ONE. If
    // the layer is owned by a T_ANE_IndexedLayerList, the name in Argus ONE
    // will be ANE_Name plus either the Index or OldIndex of the
    // T_ANE_IndexedLayerList.
    function WriteSpecialBeginning: String; virtual;
      // WriteSpecialBeginning is a string that is part of the layer name.
      // it occurs before ANE_LayerName
    function WriteSpecialEnd: String;       virtual;
      // WriteSpecialEnd is a string that is part of the layer name.
      // it occurs after the layer index (if any).
    function WriteSpecialMiddle: String;    virtual;
      // WriteSpecialMiddle is a string that is part of the layer name.
      // it occurs between the ANE_LayerName and the layer index (if any).
    property Status : TStatus read FStatus;
      // This is used to determine if a layer is new, deleted, or normal
    function FixLayer(const CurrentModelHandle : ANE_PTR): ANE_PTR; virtual;
      // Calling FixLayer will check if a layer exists in Argus ONE. If it
      // doesn't, the status of the layer will be changed to new.
    class function WriteNewRoot : string; virtual;
    function WriteLayerRoot: string; virtual;
    function WriteOldRoot : string; virtual;
    property OldRoot : string read WriteOldRoot;
    function GetOldLayerHandle(const CurrentModelHandle: ANE_PTR): ANE_PTR;
  end;

T_ANE_GroupLayer = class(T_ANE_MapsLayer)
// T_ANE_GroupLayer may be used for group layers.
  public
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      = -1); override;
    // see T_ANE_MapsLayer
    class Function ANE_LayerName : string ; override;
    // see T_ANE_MapsLayer
  end;

T_ANE_NamedGroupLayer = class(T_ANE_GroupLayer)
  private
    FName : String;
  public
    constructor Create(LayerName: string; ALayerList : T_ANE_LayerList;
      Index: Integer = -1); reintroduce; virtual;
    function WriteLayerRoot: string; override;
  end;


T_ANE_Layer = class(T_ANE_MapsLayer)
// T_ANE_Layer is the base class for layers with parameters. No actual
// T_ANE_Layer should be created. Instead, use descendent of T_ANE_Layer.
  private
    Procedure AddParameterNeg1ListToList(ParameterListIndex : integer ;
      List : TList);
    Procedure AddParameter0ListToList(ParameterListIndex : integer ;
      List : TList);
    Procedure AddParameter1ListToList(ParameterListIndex : integer ;
      List : TList);
    // calls AddParameterListToList of IndexedParamList1
    Procedure AddParameter2ListToList(ParameterListIndex : integer ;
      List : TList);
    // calls AddParameterListToList of IndexedParamList2
    procedure SetParameterUnits(const CurrentModelHandle: ANE_PTR;
      const UseOldIndex: boolean);
    // sets the units, if appropriate, of all parameters in the layer
    procedure SetAllParamUnits;
    procedure SetParamUnits(AParameterType: T_ANE_ParamClass;
      ParameterName: string);
  protected
    function WriteParameters(const CurrentModelHandle : ANE_PTR) : string; override;
    // WriteParameters writes a string representing all the parameters
    // owned (indirectly) by the layer.
    procedure SetParametersStatus(AStatus : TStatus); override;
    // SetParametersStatus sets the Status of all the parameters owned
    // (indirectly) by the layer to AStatus.
    procedure FreeByStatus(AStatus : TStatus); override;
    // FreeByStatus calls the inherited FreeByStatus if Status equals AStatus.
    // Otherwise it calls FreeByStatus of ParamList, IndexedParamList1 and
    // IndexedParamList2.
    procedure UpdateParameterIndicies; override;
    // UpdateParameterIndicies changes the Index properties of all the
    // T_ANE_IndexedParameterList owned (indirectly) by the layer to the
    // position of the T_ANE_IndexedParameterList in the
    // T_ANE_ListOfIndexedParameterLists
    procedure UpdateOldParameterIndicies; override;
    // UpdateOldParameterIndicies changes the OldIndex properties of all the
    // T_ANE_IndexedParameterList owned (indirectly) by the layer to be the
    // same as the Index properties of those T_ANE_IndexedParameterList's.
    procedure RemoveDeletedParameters(const CurrentModelHandle: ANE_PTR); override;
    // RemoveDeletedParameters instructs Argus ONE to remove all parameters
    // (indirectly) owned by the layer whose Status is sDeleted.
    procedure RenameIndexedParameters(const CurrentModelHandle: ANE_PTR); override;
    // RenameIndexedParameters changes the names of all indexed parameters
    // in the layer from Name + OldIndex to Name + Index.
    procedure SetNewParametersToNormal; override;
    // SetNewParametersToNormal changes the status of all parameters from
    // sNew to sNormal.
    procedure ArrangeParameters; override;
    // ArrangeParameters ensures that all Parameters owned by the layer
    // are in the correct order. ArrangeParameters should be called before
    // adding parameters.
    procedure SetExpressions(const CurrentModelHandle: ANE_PTR); override;
    // SetExpressions sets the expressions of all parameters owned by the
    // layer in which SetValue and SetExpressionNow are true.
    procedure SetNewParametersToWritten; override;
    procedure SetWrittenParametersToNormal; override;
    procedure SetParamLock(const CurrentModelHandle: ANE_PTR); override;
    procedure RestoreParamLock; override;
    procedure UpdateOldName; override;
    procedure DontNeedToUpdateParamName; override;
  public
    ParamList : T_ANE_ParameterList;
    // ParamList is a list of un-indexed parameters in the layer.
    IndexedParamListNeg1 : T_ANE_ListOfIndexedParameterLists;
    IndexedParamList0 : T_ANE_ListOfIndexedParameterLists;
    IndexedParamList1 : T_ANE_ListOfIndexedParameterLists;
    // IndexedParamList1 is a list of indexed parameters in the layer.
    // Use IndexedParamList1 for parameters related to geologic units.
    IndexedParamList2 : T_ANE_ListOfIndexedParameterLists;
    // IndexedParamList2 is a list of indexed parameters in the layer.
    // Use IndexedParamList2 for parameters related to time.
    RenameAllParameters : boolean;
    procedure AddNewParameters(const CurrentModelHandle: ANE_PTR); override;
    // AddNewParameters instructs Argus ONE to adds all parameters in the
    // layer whose status is sNew.
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      = -1); override;
    // see T_ANE_MapsLayer
    destructor Destroy; override;
    // Destroy destroys the layer.
    procedure AddOrRemoveUnIndexedParameter(AParameterType : T_ANE_ParamClass;
           ParameterShouldBePresent : boolean);  virtual;
    // AddOrRemoveUnIndexedParameter will add or remove a parameter of type
    // AParameterType in ParamList depending on the value of
    // ParameterShouldBePresent
    procedure AddOrRemoveIndexedParameterNeg1(AParameterType : T_ANE_ParamClass;
           ParameterShouldBePresent : boolean);  virtual;
    procedure AddOrRemoveIndexedParameter0(AParameterType : T_ANE_ParamClass;
           ParameterShouldBePresent : boolean);  virtual;
    procedure AddOrRemoveIndexedParameter1(AParameterType : T_ANE_ParamClass;
           ParameterShouldBePresent : boolean);  virtual;
    // AddOrRemoveIndexedParameter1 will add or remove a parameter of type
    // AParameterType in IndexedParamList1 depending on the value of
    // ParameterShouldBePresent
    procedure AddOrRemoveIndexedParameter2(AParameterType : T_ANE_ParamClass;
           ParameterShouldBePresent : boolean);  virtual;
    // AddOrRemoveIndexedParameter2 will add or remove a parameter of type
    // AParameterType in IndexedParamList2 depending on the value of
    // ParameterShouldBePresent
    class Function ANE_LayerName : string ; override;
    // see T_ANE_MapsLayer
    function FixLayer(const CurrentModelHandle: ANE_PTR): ANE_PTR; override;
    // calls AddParameterListToList of IndexedParamList2
    procedure SetUnIndexedExpressionNow(AParameterType : T_ANE_ParamClass;
          ParameterName : string; ShouldSetExpressionNow : boolean);  virtual;
    procedure SetIndexedNeg1ExpressionNow(AParameterType: T_ANE_ParamClass;
      ParameterName: string; ShouldSetExpressionNow: boolean);  virtual;
    procedure SetIndexed0ExpressionNow(AParameterType: T_ANE_ParamClass;
      ParameterName: string; ShouldSetExpressionNow: boolean);  virtual;
    procedure SetIndexed1ExpressionNow(AParameterType: T_ANE_ParamClass;
      ParameterName: string; ShouldSetExpressionNow: boolean);  virtual;
    procedure SetIndexed2ExpressionNow(AParameterType: T_ANE_ParamClass;
      ParameterName: string; ShouldSetExpressionNow: boolean);  virtual;
    procedure MoveIndParam2ToParam(ParamType: T_ANE_ParamClass);
    procedure MoveParamToIndParam2(ParamType: T_ANE_ParamClass);
    procedure UpdateUnIndexedParamName(AParameterType: T_ANE_ParamClass);
    procedure UpdateIndexedParameterNeg1ParamName(AParameterType: T_ANE_ParamClass);
    procedure UpdateIndexedParameter0ParamName(AParameterType: T_ANE_ParamClass);
    procedure UpdateIndexedParameter1ParamName(AParameterType: T_ANE_ParamClass);
    procedure UpdateIndexedParameter2ParamName(AParameterType: T_ANE_ParamClass);
  end;

T_ANE_InfoLayer = class(T_ANE_Layer)
// T_ANE_InfoLayer is used for information layers.
  protected
    function WriteInterpMethod : string; override;
    // WriteInterpMethod returns a string that can be used in the parameter
    // template sent to Argus ONE to indicate the interpretation method.
    function WriteInterpPie : string; override;
  public
    Interp : TLayerEvaluationType;
    // Interp represents the interpretation method of the layer.
    // At present Interp may be leNearest, leExact, or leInterpolate.
    constructor Create(ALayerList : T_ANE_LayerList;
      Index: Integer = -1); override;
    // see T_ANE_MapsLayer
    class Function ANE_LayerName : string ; override;
    // see T_ANE_MapsLayer
  end;

T_ANE_NamedInfoLayer = class(T_ANE_InfoLayer)
  protected
    FName : String;
  public
    constructor Create(LayerName: string; ALayerList : T_ANE_LayerList;
      Index: Integer = -1); reintroduce; virtual;
    function WriteLayerRoot: string; override;
  end;

T_ANE_NamedMapLayer = class(T_ANE_MapsLayer)
  protected
    FName : String;
  public
    constructor Create(LayerName: string; ALayerList : T_ANE_LayerList;
      Index: Integer = -1); reintroduce; virtual;
    function WriteLayerRoot: string; override;
  end;

TIndexedInfoLayer = class(T_ANE_InfoLayer)
// TIndexedInfoLayer is used for information layers in T_ANE_IndexedLayerList
// where the desired index is the position of the layer in the list rather
// than the index of the T_ANE_IndexedLayerList.
  private
    FOldIndex  : integer;
  public
    function WriteIndex : string; override;
    function WriteOldIndex : string; override;
    function WriteLayer(const CurrentModelHandle : ANE_PTR) : string; override;
    procedure SetOldIndex;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      = -1); override;
  end;

T_ANE_DomainOutlineLayer = class(T_ANE_InfoLayer)
// T_ANE_DomainOutlineLayer is used for domain outline layers.
  public
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      = -1); override;
    // see T_ANE_MapsLayer
    class Function ANE_LayerName : string ; override;
    // see T_ANE_MapsLayer
    function Units : string; override;
    // the units of the layer.
  end;

T_ANE_NamedDomainOutlineLayer = class(T_ANE_DomainOutlineLayer)
  private
    FName : String;
  public
    constructor Create(LayerName: string; ALayerList : T_ANE_LayerList;
      Index: Integer = -1); reintroduce; virtual;
    function WriteLayerRoot: string; override;
  end;

T_ANE_DensityLayer = class(T_ANE_InfoLayer)
  // T_ANE_DensityLayer is used for density layers.
  public
    class Function ANE_LayerName : string ; override;
    // see T_ANE_MapsLayer
    function Units : string; override;
    // the units of the layer.
  end;

T_ANE_DataLayer = class(T_ANE_InfoLayer)
// T_ANE_DataLayer is used for data layers.
  public
    // Data layers should not override "WriteSpecialBeginning" or
    // "WriteSpecialMiddle".
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      = -1); override;
    // see T_ANE_MapsLayer
    class Function ANE_LayerName : string ; override;
    // see T_ANE_MapsLayer
    function Units : string; override;
    // the units of the layer.
//    Function WriteSpecialEnd : string ; override;
  end;

T_ANE_NamedDataLayer = class(T_ANE_DataLayer)
  private
    FName : String;
  public
    constructor Create(LayerName: string; ALayerList : T_ANE_LayerList;
      Index: Integer = -1); reintroduce; virtual;
    function WriteLayerRoot: string; override;
  end;

T_ANE_TriMeshLayer = class(T_ANE_Layer)
// T_ANE_TriMeshLayer is used for TriMesh layers.
  protected
    function WriteDomDens : string; override;
    // WriteDomDens returns a string that can be used in the parameter
    // template sent to Argus ONE to Domain and Density layers for the
    // T_ANE_TriMeshLayer.
    function WriteTemplate : string; override;
    // WriteTemplate writes the template in a mesh or grid layer.
  public
    DomainLayer : string;
    // DomainLayer is the name of the Domain layer of the T_ANE_TriMeshLayer.
    DensityLayer: string;
    // DensityLayer is the name of the Density layer of the T_ANE_TriMeshLayer.
    Template : TStringList;
    // Template can be used to hold an Argus ONE template that can be used
    // to export the mesh or grid by template. This is probably not the
    // export template of the model.
    //
    // You can load an Argus ONE template into a memo at design time and then
    // use Template.Assign to get the data into the Template StringList.
    // You need to set the wordwrap property of the memo to false and you
    // will probably need to make an explicit call to the handle property of
    // the memo before calling Template.Assign.
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      = -1); override;
    // see T_ANE_MapsLayer
    destructor Destroy; override;
    // see T_ANE_MapsLayer
    class Function ANE_LayerName : string ; override;
    // see T_ANE_MapsLayer

  end;

T_ANE_QuadMeshLayer = class(T_ANE_TriMeshLayer)
// T_ANE_QuadMeshLayer is used for QuadMesh layers.
  public
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      = -1); override;
    // see T_ANE_MapsLayer
    class Function ANE_LayerName : string ; override;
    // see T_ANE_MapsLayer
  end;

T_ANE_GridLayer = class(T_ANE_TriMeshLayer)
// T_ANE_GridLayer is used for Grid layers.
    public
    XGridDirectionReversed : Boolean;
    YGridDirectionReversed : Boolean;
    BlockCenteredGrid : boolean;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      = -1); override;
    // see T_ANE_MapsLayer
    class Function ANE_LayerName : string ; override;
    // see T_ANE_MapsLayer
    function WriteGridBlockCentered(const CurrentModelHandle : ANE_PTR) : string; override;
    function WriteReverseGridX(const CurrentModelHandle : ANE_PTR) : string; override;
    // WriteTemplate does nothing. It is overridden in T_ANE_GridLayer
    function WriteReverseGridY(const CurrentModelHandle : ANE_PTR) : string; override;
    // WriteTemplate does nothing. It is overridden in T_ANE_GridLayer
  end;

T_ANE_NamedGridLayer = class(T_ANE_GridLayer)
  private
    FName : String;
  public
    constructor Create(LayerName: string; ALayerList : T_ANE_LayerList;
      Index: Integer = -1); reintroduce; virtual;
    function WriteLayerRoot: string; override;
  end;

T_ANE_ParameterList = class(TObject)
  // T_ANE_ParameterList holds a list of parameters
  private
    FList : TList;
    // FList is the Tlist in T_ANE_ParameterList that actually holds the
    // parameters
    Owner : TObject;
    // Owner is the object that is responsible for Freeing the
    // T_ANE_ParameterList. It must be either a T_ANE_Layer or a
    // T_ANE_ListOfIndexedParameterLists.
    Sorted : Boolean;
    // Sorted indicates whether the items in FList have been sorted.
    FNeedToUpdateParamName: boolean;
    function WriteParameters(const CurrentModelHandle : ANE_PTR) : string;
    // WriteParameters returns a string representing all the parameters
    // in the T_ANE_ParameterList that may be passed to Argus ONE.
    procedure SetStatus(AStatus : TStatus);
    // SetStatus sets the status of the T_ANE_ParameterList and all the
    // parameters in it to AStatus.
    function GetCount : integer;
    // used in Count property of T_ANE_ParameterList
    procedure SetNewParametersToWritten;
    procedure SetWrittenParametersToNormal;
    procedure RestoreLock;
    procedure UpdateOldName;
    procedure NeedToUpdateParamName;
    procedure DontNeedToUpdateParamName;
  protected
    procedure FreeByStatus(AStatus : TStatus); virtual;
    // FreeByStatus frees all the parameters in the T_ANE_ParameterList
    // whose status is AStatus.
    procedure RemoveDeletedParameters(const CurrentModelHandle :ANE_PTR;
      const LayerHandle : ANE_PTR);  virtual;
    // RemoveDeletedParameters instructs Argus ONE to remove all parameters
    // whose status is sDeleted.
    function GetPreviousParameter(AParam : T_ANE_Param): T_ANE_Param;  virtual;
    // GetPreviousParameter returns the parameter in the parameters list
    // after which it is appropriate to add AParam. If there is no such
    // parameter, GetPreviousParameter returns nil.
    procedure AddNewParameters(const CurrentModelHandle :ANE_PTR;
      const LayerHandle : ANE_PTR);  virtual;
    // AddNewParameters instructs Argus ONE to add a parameter whose
    // status is sNew
    procedure SetNewParametersToNormal;  virtual;
    // SetNewParametersToNormal changes the status of all parameters in the
    // T_ANE_ParameterList from sNew to sNormal.
    procedure ArrangeParameters;  virtual;
    // ArrangeParameters arranges the parameters in the order specified in
    // the ParameterOrder property.
    procedure SetExpressions(const CurrentModelHandle :ANE_PTR;
      const LayerHandle : ANE_PTR);  virtual;
    // SetExpressions calls the SetExpression procedure of all the parameters
    // in the T_ANE_ParameterList.
    function GetItem(Index : Integer) : T_ANE_Param;  virtual;
    // used in Items property of T_ANE_ParameterList
    procedure FixParam(const CurrentModelHandle, LayerHandle: ANE_PTR);  virtual;
    // checks whether all the parameters in a parameter list exists and sets
    // their status to New if they don't exist but should.
    procedure SetParameterUnits(const CurrentModelHandle,
      LayerHandle: ANE_PTR; const UseOldIndex: boolean);  virtual;
    procedure SetParamUnits(AParameterType: T_ANE_ParamClass;
      ParameterName: string);  virtual;
        // Sets the units of all parameters in parameter list in Argus ONE.
    procedure SetAllParamUnits;  virtual;
    // SetAllParamUnits sets SetUnits of all parameters to true.
    procedure RenameParameters(const CurrentModelHandle,
      LayerHandle: ANE_PTR; RenameAllParameters: boolean); virtual;
    procedure SetLock(const CurrentModelHandle, LayerHandle: ANE_PTR); virtual;
  public
    Status : TStatus;
    // see TStatus
    ParameterOrder : TTestStringList;
    // ParameterOrder is a list of the names of the parameters that can be in
    // the T_ANE_ParameterList. The order of the names in ParameterOrder
    // will be the order in which the parameters in the T_ANE_ParameterList
    // will appear in Argus ONE.
    constructor Create(AnOwner : TObject);
    // Create, creates the T_ANE_ParameterList AnOwner must be either a
    // T_ANE_Layer or a T_ANE_ListOfIndexedParameterLists.
    destructor Destroy; override;
    // Destroy destroys the T_ANE_ParameterList.
    function First: T_ANE_Param;  virtual;
    // see TList
    function IndexOf(Item: T_ANE_Param): Integer;  virtual;
    // see TList
    function Last: T_ANE_Param;  virtual;
    // see TList
    function GetParameterByName(AName : string) : T_ANE_Param;  virtual;
    // GetParameterByName returns the first paramter in the T_ANE_ParameterList
    // whose name equals AName. If there is no such parameter, it returns nil.
    procedure UnDeleteSelf;
    procedure DeleteSelf;  virtual;
    // DeleteSelf sets the status of the T_ANE_ParameterList to sDeleted and
    // calls the Delete procedure of all the parameters in the
    // T_ANE_ParameterList.
    procedure AddOrRemoveParameter(AParameterType : T_ANE_ParamClass;
          ParameterName : string; ParameterShouldBePresent : boolean);  virtual;
    // If ParameterShouldBePresent is true and a parameter of type
    // AParameterType with
    // the name ParameterName is not already present in the parameter list,
    // it will be created and added to the end of the parameter list.
    //
    // If ParameterShouldBePresent is false and a parameter of type
    // AParameterType with
    // the name ParameterName is present in the parameter list,
    // it will be deleted.
    procedure SetExpressionNow(AParameterType : T_ANE_ParamClass;
          ParameterName : string; ShouldSetExpressionNow : boolean);  virtual;
    Property Items[Index : integer]: T_ANE_Param  read GetItem; default;
    // See TList
    Property Count : Integer  read GetCount  {write SetCount} ;
    // See TList
    function ParentLayer: T_ANE_Layer;
  end;

T_ANE_IndexedParameterList = class(T_ANE_ParameterList)
  // T_ANE_ListOfIndexedParameterLists holds a list of parameters. It is owned
  // by a T_ANE_ListOfIndexedParameterLists. The position of the
  // T_ANE_IndexedParameterList within the T_ANE_ListOfIndexedParameterLists
  // determines the index assigned to the T_ANE_IndexedParameterList's
  // parameters within Argus ONE
  private
    FIndex : integer;
    // Index is used to hold the new index of all the parameters in the
    // T_ANE_IndexedParameterList.
    FOldIndex : integer;
    // OldIndex is used to hold the old index of all the parameters in the
    // T_ANE_IndexedParameterList. OldIndex is the index after the name
    // of the parameter in Argus ONE. When indexed parameters are added
    // or removed, the indicies in Argus ONE have to be changed from
    // OldIndex to Index.
    FRenameAllParameters : boolean;
  protected
    procedure FreeByStatus(AStatus : TStatus); override;
    // if the Status of a T_ANE_IndexedParameterList is equal to AStatus,
    // FreeByStatus will remove the T_ANE_IndexedParameterList from its
    // T_ANE_ListOfIndexedParameterLists and free itself. Otherwise it
    // will call the inherited FreeByStatus.
    procedure RenameParameters(const CurrentModelHandle,
      LayerHandle : ANE_PTR; RenameAllParameters : boolean); override;
    // RenameIndexedParameters Instruct Argus One to change the names of the
    // parameters in the T_ANE_IndexedParameterList from
    // Name + OldIndex to Name + Index.
  public
    property Index : Integer read FIndex;
    property OldIndex : Integer read FOldIndex;
    constructor Create(AnOwner :T_ANE_ListOfIndexedParameterLists;
      Position: Integer = -1); Virtual;
    // see T_ANE_ParameterList; Index controls the positions of the new
    // T_ANE_IndexedParameterList in AnOwner
    destructor Destroy; override;
    // Destroy removes the T_ANE_IndexedParameterList from its Owner
    // and destroys it.
    function GetIndex : integer;  virtual;
    // GetIndex returns the position of the indexed parameter list within
    // the list of Indexed parameter lists.
  end;

T_ANE_ListOfIndexedParameterLists = class(TObject)
  // T_ANE_ListOfIndexedParameterLists holds a list of
  // T_ANE_IndexedParameterList's. The position of the
  // T_ANE_IndexedParameterList within the T_ANE_ListOfIndexedParameterLists
  // determines the index assigned to the T_ANE_IndexedParameterList's
  // parameters within Argus ONE
  private
    FList : TList;
    // FList is the TList within T_ANE_ListOfIndexedParameterLists that actually
    // holds the T_ANE_IndexedParameterList's.
    Owner : T_ANE_Layer;
    // Owner is the layer that is responsible for freeing the
    // T_ANE_ListOfIndexedParameterLists
    FNeedToUpdateParamName: boolean;
    function WriteParameters(const CurrentModelHandle : ANE_PTR) : string;
    // WriteParameters returns a string that can be passed to Argus ONE
    // describing all the layers indirectly owned by the
    // T_ANE_ListOfIndexedParameterLists.
    procedure SetStatus(AStatus : TStatus);
    // SetStatus calls the SetStatus procedure of all the
    // T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
    procedure FreeByStatus(AStatus : TStatus);
    // FreeByStatus calls the FreeByStatus procedure of all the
    // T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
//    procedure DeleteByName(AName : string);
    // DeleteByName calls the DeleteByName procedure of all the
    // T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
    procedure UpdateIndicies;
    // UpdateIndicies calls the UpdateIndicies procedure of all the
    // T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
    procedure UpdateOldIndicies;
    // UpdateOldIndicies calls the UpdateOldIndicies procedure of all the
    // T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
    procedure RemoveDeletedParameters(const CurrentModelHandle : ANE_PTR;
      const LayerHandle : ANE_PTR);
    // RemoveDeletedParameters calls the RemoveDeletedParameters procedure
    // of all the
    // T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
    procedure RenameParameters(const CurrentModelHandle, LayerHandle : ANE_PTR;
      RenameAllParameters : boolean);
    // RenameIndexedParameters calls the RenameIndexedParameters procedure
    // of all the
    // T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
    function GetPreviousParameter
      (AnIndexedParameterList : T_ANE_IndexedParameterList ;
      AParam : T_ANE_Param): T_ANE_Param;
    // GetPreviousParameter returns the parameter prior to AParam after which
    // AParam may be added. AnIndexedParameterList is the
    // T_ANE_IndexedParameterList containing AParam. If there is no
    // appropriate parameter, GetPreviousParameter returns nil.
    procedure AddNewParameters(const CurrentModelHandle : ANE_PTR;
      const LayerHandle : ANE_PTR);
    // AddNewParameters calls the AddNewParameters procedure of all the
    // T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
    procedure SetNewParametersToNormal;
    // SetNewParametersToNormal calls the SetNewParametersToNormal procedure
    // of all the
    // T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
    procedure ArrangeParameters;
    // ArrangeParameters calls the ArrangeParameters procedure of all the
    // T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
    procedure SetExpressions(const CurrentModelHandle : ANE_PTR;
      const LayerHandle : ANE_PTR);
    // SetExpressions calls the SetExpressions procedure of all the
    // T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
    function GetItem(Index : Integer) : T_ANE_IndexedParameterList;
    // Used by the Items property
//    Procedure SetItem(Index : Integer;
//      AnIndexedParameterList : T_ANE_IndexedParameterList) ;
    function GetCount : integer;
    // used by the Count property.
//    procedure SetCount(ACount : integer);
    Procedure AddParameterListToList(ParameterListIndex : integer ;
      List : TList);
    // AddParameterListToList determines the Indexed parameter list whose
    // position within the T_ANE_ListOfIndexedParameterLists would be
    // ParameterListIndex if all "deleted" parameters were removed from the
    // list.
    // It adds that Indexed parameter list to List
    procedure FixParam(const CurrentModelHandle, LayerHandle: ANE_PTR);
    procedure SetParameterUnits(const CurrentModelHandle,
      LayerHandle: ANE_PTR; const UseOldIndex: boolean);
    procedure SetAllParamUnits;
    procedure SetParamUnits(AParameterType: T_ANE_ParamClass;
      ParameterName: string);
    procedure SetNewParametersToWritten;
    procedure SetWrittenParametersToNormal;
    procedure RestoreLock;
    procedure UpdateOldName;
    procedure NeedToUpdateParamName;
    procedure DontNeedToUpdateParamName;
  protected
    procedure SetLock(const CurrentModelHandle, LayerHandle: ANE_PTR); virtual;
  public
    constructor Create(AnOwner : T_ANE_Layer);
    // Create creates the T_ANE_ListOfIndexedParameterLists and sets
    // the Owner to AnOwner.
    destructor Destroy; override;
    // Destroy destroys the T_ANE_ListOfIndexedParameterLists
//    function Add(Item: T_ANE_IndexedParameterList): Integer;
    // see TList
    function First: T_ANE_IndexedParameterList;  virtual;
    // see TList
    function IndexOf(Item: T_ANE_IndexedParameterList): Integer;  virtual;
    // see TList
//    procedure Insert(Index: Integer; Item: T_ANE_IndexedParameterList);
    // see TList
    function Last: T_ANE_IndexedParameterList;  virtual;
    // see TList
//    function Remove(Item: T_ANE_IndexedParameterList): Integer;
    // see TList
    function GetNonDeletedIndParameterListByIndex
         (Index : integer) : T_ANE_IndexedParameterList;  virtual;
    // GetNonDeletedIndParameterListByIndex returns the
    // T_ANE_IndexedParameterList whose position in the list would be
    // Index if all the deleted T_ANE_IndexedParameterList's were
    // removed from it.
    function GetNonDeletedIndParameterListIndexByIndex
         (Index : integer) : integer;  virtual;
    // GetNonDeletedIndParameterListIndexByIndex returns the
    // position in the list of the T_ANE_IndexedParameterList whose postion
    // would be Index if all the deleted T_ANE_IndexedParameterList's were
    // removed from it.
    procedure SetExpressionNow(AParameterType : T_ANE_ParamClass;
          ParameterName : string; ShouldSetExpressionNow : boolean);  virtual;
    Property Items[Index : integer] : T_ANE_IndexedParameterList
      read GetItem  {write SetItem }; default;
    // see TList
    Property Count : Integer  read GetCount  {write SetCount} ;
    // see TList
  end;

T_ANE_LayerList = class(TObject)
  private
    FList : TList;
    // FList is the TList within the T_ANE_LayerList that actually
    // holds the list of layers.
    FStatus : TStatus;
    // See TStatus
    FOwner : TObject;
    // Owner is the Object responsible for freeing the T_ANE_LayerList.
    Sorted : boolean;
    // Sorted indicates whether the items in FList have been put in order.
    FNeedToUpdateParamName: boolean;
    function WriteLayers(const CurrentModelHandle : ANE_PTR) : string;
    // WriteLayers returns a string that can be used in a layer template
    // sent to Argus ONE to create layers.
    procedure SetLayersStatus(AStatus : TStatus);
    // SetLayersStatus sets the Status of all the layers in the T_ANE_LayerList
    // to AStatus. SetLayersStatus does not affect the Status of the parameters
    // by any of the Layers.
    procedure SetParametersStatus(AStatus : TStatus);
    // SetParametersStatus sets the Status of all the parameters of all the
    // layers in the T_ANE_LayerList to AStatus.
    procedure SetStatus(AStatus : TStatus);
    // SetStatus sets the Status of all the layers and all their parameters
    // to AStatus.
    procedure UpdateParameterIndicies;
    // UpdateParameterIndicies calls the UpdateParameterIndicies procedure of
    // all the layers in the T_ANE_LayerList.
    procedure UpdateOldParameterIndicies;
    // UpdateOldParameterIndicies calls the UpdateOldParameterIndicies
    // procedure of all the layers in the T_ANE_LayerList.
    procedure RemoveDeletedLayers(const CurrentModelHandle :ANE_PTR);
    // RemoveDeletedLayers calls the RemoveLayer procedure of all
    // the layers in the T_ANE_LayerList whose Status is sDeleted.
    procedure RemoveDeletedParameters(const CurrentModelHandle : ANE_PTR);
    // RemoveDeletedParameters calls the RemoveDeletedParameters procedure
    // of all the layers in the T_ANE_LayerList.
    procedure RenameIndexedParameters(const CurrentModelHandle : ANE_PTR);
    // RenameIndexedParameters calls the RenameIndexedParameters procedure
    // of all the layers in the T_ANE_LayerList.
    procedure AddNewParameters(const CurrentModelHandle : ANE_PTR);
    // AddNewParameters calls the AddNewParameters procedure of all
    // the layers in the T_ANE_LayerList.
    function GetPreviousLayer(ALayer : T_ANE_MapsLayer) : T_ANE_MapsLayer;
    // GetPreviousLayer returns the layer after which it is appropriate to
    // add ALayer in Argus ONE.
//    procedure AddNewLayers(const CurrentModelHandle :ANE_PTR);
    // AddNewLayers calls the AddNewLayer procedure of all
    // the layers in the T_ANE_LayerList.
    procedure ArrangeParameters;
    // ArrangeParameters calls the ArrangeParameters procedure of all
    // the layers in the T_ANE_LayerList.
    procedure ArrangeLayers;
    // ArrangeLayers arranges the layers in the order specified in LayerOrder
    procedure SetExpressions(const CurrentModelHandle : ANE_PTR);
    // SetExpressions calls the SetExpressions procedure of all
    // the layers in the T_ANE_LayerList.
    function GetItem(Index : Integer) : T_ANE_MapsLayer;
    // used by the Items property
//    Procedure SetItem(Index : Integer;
//      AMapsLayer : T_ANE_MapsLayer) ;
    function GetCount : integer;
    // used gby the Count property
//    procedure SetCount(ACount : integer);
    Procedure AddParameterNeg1ListToList(ParameterListIndex : integer ;
      List : TList);
    Procedure AddParameter0ListToList(ParameterListIndex : integer ;
      List : TList);
    Procedure AddParameter1ListToList(ParameterListIndex : integer ;
      List : TList);
    // calls AddParameter1ListToList for all the layers in the layer list.
    Procedure AddParameter2ListToList(ParameterListIndex : integer ;
      List : TList);
    // calls AddParameter2ListToList for all the layers in the layer list.
    procedure FixLayers(const CurrentModelHandle: ANE_PTR);
    procedure SetParameterUnits(const CurrentModelHandle: ANE_PTR;
      const UseOldIndex: boolean);
    procedure RenameLayers(const CurrentModelHandle: ANE_PTR);
    procedure AddMultipleNewLayers(const CurrentModelHandle: ANE_PTR;
       var LayerTemplate: String;  var PreviousLayer: T_ANE_MapsLayer);
    procedure SetWrittenParametersToNormal;
    procedure RestoreParamLock;
    procedure UpdateOldName;
    // RenameIndexedLayers Instruct Argus One to change the names of the
    // parameters in the T_ANE_IndexedLayerList from
    // Name + OldIndex to Name + Index.
    procedure NeedToUpdateParamName;
    procedure DontNeedToUpdateParamName;
  protected
    procedure FreeByStatus(AStatus : TStatus); virtual;
    // FreeByStatus calls the FreeByStatus procedure of all
    // the layers in the T_ANE_LayerList.
    procedure SetParamLock(const CurrentModelHandle: ANE_PTR); virtual;
  public
    LayerOrder : TTestStringList;
    // LayerOrder is a list of all the names of all the layers that can be
    // in the T_ANE_LayerList. The order of the names in LayerOrder will be
    // the order in which the layers will appear in Argus ONE.
    constructor Create(AnOwner : TObject);
    // Creates the layer list.
    destructor Destroy; override;
    // Destroys the layer list and all its layers, parameters and other
    // owned objects.
//    function Add(Item: T_ANE_MapsLayer): Integer;
    // see TList
    function First: T_ANE_MapsLayer;  virtual;
    // see TList
    function IndexOf(Item: T_ANE_MapsLayer): Integer;  virtual;
    // see TList
//    procedure Insert(Index: Integer; Item: T_ANE_MapsLayer);
    // see TList
    function Last: T_ANE_MapsLayer;  virtual;
    // see TList
//    function Remove(Item: T_ANE_MapsLayer): Integer;
    // see TList
    function GetLayerByName(AName : string) : T_ANE_MapsLayer;  virtual;
    // GetLayerByName returns the first layer in the T_ANE_LayerList
    // whose Name equals AName.
    procedure DeleteSelf;  virtual;
    // DeleteSelf sets the Status of the T_ANE_LayerList to sDeleted
//    procedure DeleteLayersByName(AName : string);
    // DeleteLayersByName calls the DeleteByName procedure of all
    // the layers in the T_ANE_LayerList.
    procedure UnDeleteSelf; virtual;
    // Sets the status of the T_ANE_LayerList to sNormal.
    procedure AddOrRemoveUnIndexedParameter
          (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
           ParameterShouldBePresent : boolean);  virtual;
    // AddOrRemoveUnIndexedParameter gets a layer of the type ALayerType
    // Then if ParameterShouldBePresent is true and the layers Unindexed
    // parameters does not include a parameter of AParameterType, a parameter
    // of that type will be added to the unindexed parameters.
    // if ParameterShouldBePresent is false and the layers Unindexed
    // parameters does include a parameter of AParameterType, it will be
    // deleted.
    procedure AddOrRemoveIndexedParameter0(ALayerType: T_ANE_LayerClass;
      AParameterType: T_ANE_ParamClass; ParameterShouldBePresent: boolean);
    procedure AddOrRemoveIndexedParameter1
          (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
            ParameterShouldBePresent : boolean);  virtual;
    // AddOrRemoveUnIndexedParameter gets a layer of the type ALayerType
    // Then if ParameterShouldBePresent is true and the layers
    // IndexedParameters1 does not include a parameter of AParameterType,
    // a parameter
    // of that type will be added to the IndexedParameters1.
    // if ParameterShouldBePresent is false and the layers IndexedParameters1
    //  does include a parameter of AParameterType, it will be
    // deleted.
    procedure AddOrRemoveIndexedParameter2
          (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
            ParameterShouldBePresent : boolean);  virtual;
    // AddOrRemoveUnIndexedParameter gets a layer of the type ALayerType
    // Then if ParameterShouldBePresent is true and the layers
    // IndexedParameters2 does not include a parameter of AParameterType,
    // a parameter
    // of that type will be added to the IndexedParameters2.
    // if ParameterShouldBePresent is false and the layers IndexedParameters2
    //  does include a parameter of AParameterType, it will be
    // deleted.
    procedure AddOrRemoveLayer(ALayerType : T_ANE_MapsLayerClass;
           LayerShouldBePresent : boolean);  virtual;
    // If LayerShouldBePresent is true and a layer of ALayerType is not present
    // in the layer list, it will be created and added to the layer list.
    // If LayerShouldBePresent is false and a layer of ALayerType is present
    // in the layer list, it will be deleted.
    Property Items[Index : integer] : T_ANE_MapsLayer
      read GetItem  {write SetItem };
    // See TList
    Property Count : Integer  read GetCount  {write SetCount} ;
    // See TList
    Procedure MakeIndexedListNeg1(ALayerType: T_ANE_LayerClass;
       AnIndexedParameterType : T_ANE_IndexedParameterListClass;
        Position : integer = -1);  virtual;
    Procedure MakeIndexedList0(ALayerType: T_ANE_LayerClass;
       AnIndexedParameterType : T_ANE_IndexedParameterListClass;
        Position : integer = -1);  virtual;
    Procedure MakeIndexedList1(ALayerType: T_ANE_LayerClass;
       AnIndexedParameterType : T_ANE_IndexedParameterListClass;
        Position : integer = -1);  virtual;
    // MakeIndexedList1 will retrieve a a layer of ALayerType and will
    // add will create a parameter of AnIndexedParameterType in
    // IndexedParamList1 of that layer.
    Procedure MakeIndexedList2(ALayerType: T_ANE_LayerClass;
       AnIndexedParameterType : T_ANE_IndexedParameterListClass;
       Position : integer = -1);  virtual;
    // MakeIndexedList1 will retrieve a a layer of ALayerType and will
    // add will create a parameter of AnIndexedParameterType in
    // IndexedParamList2 of that layer.
    property Owner : TObject read FOwner;
    procedure SetUnIndexedExpressionNow(ALayerType : T_ANE_LayerClass;
      AParameterType : T_ANE_ParamClass; ParameterName : string;
      ShouldSetExpressionNow : boolean); virtual;
    procedure SetIndexed1ExpressionNow(ALayerType : T_ANE_LayerClass;
      AParameterType : T_ANE_ParamClass; ParameterName : string;
      ShouldSetExpressionNow : boolean); virtual;
    procedure SetIndexed2ExpressionNow(ALayerType : T_ANE_LayerClass;
      AParameterType : T_ANE_ParamClass; ParameterName : string;
      ShouldSetExpressionNow : boolean);virtual;
    procedure SetAllParamUnits;  virtual;
    procedure SetParamUnits(AParameterType: T_ANE_ParamClass;
      ParameterName, LayerName: string); virtual;
    procedure MoveIndParam2ToParam(ParamType : T_ANE_ParamClass;
      ALayerType : T_ANE_LayerClass);
    procedure MoveParamToIndParam2(ParamType : T_ANE_ParamClass;
      ALayerType : T_ANE_LayerClass);
    procedure Exchange(Index1, Index2: Integer);
    function GetNonDeletedLayerByIndex(Index: integer): T_ANE_MapsLayer;
//    function GetNonDeletedIndexOf(ALayer : T_ANE_MapsLayer) : integer;
    Property Status : TStatus read FStatus;
    function NonDeletedIndexOf(const ALayer: T_ANE_MapsLayer): integer;
    procedure UpdateUnIndexedParamName(ALayerType: T_ANE_LayerClass;
      AParameterType: T_ANE_ParamClass);
    procedure UpdateIndexedParameterNeg1ParamName(ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
    procedure UpdateIndexedParameter0ParamName(ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
    procedure UpdateIndexedParameter1ParamName(ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
    procedure UpdateIndexedParameter2ParamName(ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
  end;

T_ANE_IndexedLayerList = class(T_ANE_LayerList)
  private
    FIndex : integer;
    // Index is used to hold the new index of all the layers in the
    // T_ANE_IndexedLayerList.
    FOldIndex :integer;
    // OldIndex is used to hold the old index of all the layers in the
    // T_ANE_IndexedLayerList. OldIndex is the index after the name
    // of the layers in Argus ONE. When indexed layers are added
    // or removed, the indicies in Argus ONE have to be changed from
    // OldIndex to Index.
    procedure RenameLayers(const CurrentModelHandle: ANE_PTR;
      RenameAllLayers : boolean);
    // if the Status of a T_ANE_IndexedLayerList is equal to AStatus,
    // FreeByStatus free itself. Otherwise it
    // will call the inherited FreeByStatus.
  protected
    procedure FreeByStatus(AStatus : TStatus); override;
  public
    Name : string;
    RenameAllLayers : boolean;
    // Name is used to retrieve T_ANE_IndexedLayerList by name.
    constructor Create(AnOwner : T_ANE_ListOfIndexedLayerLists;
      Position: Integer = -1); virtual;
    // Create creates the T_ANE_IndexedLayerList
    destructor Destroy; override;
    // Destroy will remove the T_ANE_IndexedLayerList from its
    // T_ANE_ListOfIndexedLayerLists and call the inherited destroy.
    Property Index : integer read FIndex;
    Property OldIndex : integer read FOldIndex;
    function NonDeletedLayerCount : integer;
  end;

T_TypedIndexedLayerList = class(T_ANE_IndexedLayerList)
  private
    FLayerType: T_ANE_MapsLayerClass;
    function GetTypedCount : integer;
    procedure SetTypedCount(const Value: integer);
  public
    constructor Create(ALayerType : T_ANE_MapsLayerClass;
      AnOwner : T_ANE_ListOfIndexedLayerLists;
      Position: Integer = -1 ); reintroduce; virtual;
    // Create creates the T_TypedIndexedLayerList
    property LayerType : T_ANE_MapsLayerClass read FLayerType;
    Property TypedCount : integer read GetTypedCount write SetTypedCount;
    function LayerIndex(const Layer : T_ANE_MapsLayer) : string;
  end;

T_ANE_ListOfIndexedLayerLists = class(TObject)
  private
    FList : TList;
    // FList is the TList in T_ANE_ListOfIndexedLayerLists that actually
    // holds the T_ANE_IndexedLayerList's
    FOwner : TLayerStructure;
    // Owner is the Layer structure responsible for freeing the
    // T_ANE_ListOfIndexedLayerLists
    FNeedToUpdateParamName: boolean;
    function WriteLayers(const CurrentModelHandle : ANE_PTR) : string;
    // WriteLayers returns a string that can be used as a layer template
    // to instruct Argus ONE to create all the layers (indirectly) owned by
    // the  T_ANE_ListOfIndexedLayerLists.
    procedure SetLayersStatus(AStatus : TStatus);
    // SetLayersStatus calls the SetLayersStatus procedure of all the
    // T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists and
    // sets the status of all the T_ANE_IndexedLayerList to AStatus.
    procedure SetParametersStatus(AStatus : TStatus);
    // SetParametersStatus calls the SetParametersStatus procedure of all the
    // T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure SetStatus(AStatus : TStatus);
    // SetStatus calls SetLayersStatus and SetParametersStatus
    procedure FreeByStatus(AStatus : TStatus);
    // FreeByStatus calls the FreeByStatus procedure of all the
    // T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
//    procedure DeleteParametersByName(AName : string);
    // DeleteParametersByName calls the DeleteParametersByName procedure of
    // all the T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure UpdateLayerIndicies;
    // UpdateLayerIndicies calls the UpdateLayerIndicies procedure of all the
    // T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure UpdateParameterIndicies;
    // UpdateParameterIndicies calls the UpdateParameterIndicies procedure
    // of all the T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure UpdateIndicies;
    // UpdateIndicies calls UpdateLayerIndicies and UpdateParameterIndicies.
    procedure UpdateOldLayerIndicies;
    // UpdateOldLayerIndicies calls the UpdateOldLayerIndicies procedure
    // of all the T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure UpdateOldParameterIndicies;
    // UpdateOldParameterIndicies calls the UpdateOldParameterIndicies procedure
    // of all the T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure UpdateOldIndicies;
    // UpdateOldIndicies calls UpdateOldLayerIndicies and
    // UpdateOldParameterIndicies.
    procedure RemoveDeletedLayers(const CurrentModelHandle : ANE_PTR);
    // RemoveDeletedLayers calls the RemoveDeletedLayers procedure of all the
    // T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure RenameLayers(const CurrentModelHandle : ANE_PTR;
      RenameAllLayers : boolean);
    // RenameIndexedLayers calls the RenameIndexedLayers procedure of all the
    // T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure RemoveDeletedParameters(const CurrentModelHandle : ANE_PTR);
    // RemoveDeletedParameters calls the RemoveDeletedParameters procedure
    // of all the T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure RenameIndexedParameters(const CurrentModelHandle : ANE_PTR);
    // RenameIndexedParameters calls the RenameIndexedParameters procedure
    // of all the T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure AddNewParameters(const CurrentModelHandle : ANE_PTR);
    // AddNewParameters calls the AddNewParameters procedure of all the
    // T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    function GetPreviousLayer
      (AnIndexedLayerList : T_ANE_IndexedLayerList ;
      ALayer : T_ANE_MapsLayer): T_ANE_MapsLayer;
    // GetPreviousLayer returns the layer indirectly owned by the
    // T_ANE_ListOfIndexedLayerLists prior to ALayer after which it is
    // appropriate to add ALayer. AnIndexedLayerList is the
    // T_ANE_IndexedLayerList containing ALayer.
//    procedure AddNewLayers(const CurrentModelHandle : ANE_PTR);
    // AddNewLayers calls the AddNewLayers procedure of all the
    // T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure ArrangeParameters;
    // ArrangeParameters calls the ArrangeParameters procedure of all the
    // T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure ArrangeLayers;
    // ArrangeLayers calls the ArrangeLayers procedure of all the
    // T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    procedure SetExpressions(const CurrentModelHandle : ANE_PTR);
    // SetExpressions calls the SetExpressions procedure of all the
    // T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
    function GetItem(Index : Integer)  : T_ANE_IndexedLayerList;
    // used by the Items property
//    Procedure SetItem(Index : Integer;
//      AnIndexedLayerList : T_ANE_IndexedLayerList) ;
    function GetCount : integer;
    // used by the Count property
//    procedure SetCount(ACount : integer);
    Procedure AddParameterNeg1ListToList(ParameterListIndex : integer ;
      List : TList);
    Procedure AddParameter0ListToList(ParameterListIndex : integer ;
      List : TList);
    Procedure AddParameter1ListToList(ParameterListIndex : integer ;
      List : TList);
    // calls AddParameter1ListToList of every T_ANE_IndexedLayerList
    // in the T_ANE_ListOfIndexedLayerLists
    Procedure AddParameter2ListToList(ParameterListIndex : integer ;
      List : TList);
    procedure FixLayers(const CurrentModelHandle: ANE_PTR);
    procedure SetParameterUnits(const CurrentModelHandle: ANE_PTR;
      const UseOldIndex: boolean);
    procedure AddMultipleNewLayers(const CurrentModelHandle: ANE_PTR;
       var LayerTemplate: String;  var PreviousLayer: T_ANE_MapsLayer);
    procedure SetWrittenParametersToNormal;
    procedure RestoreParamLock;
    procedure UpdateOldName;
    // calls AddParameter2ListToList of every T_ANE_IndexedLayerList
    // in the T_ANE_ListOfIndexedLayerLists
    procedure NeedToUpdateParamName;
    procedure DontNeedToUpdateParamName;
  protected
    procedure SetParamLock(const CurrentModelHandle: ANE_PTR); virtual;
  public
    constructor Create(AnOwner : TLayerStructure);
    // Creates the T_ANE_ListOfIndexedLayerLists
    destructor Destroy; override;
    // Destroys the T_ANE_ListOfIndexedLayerLists
//    function Add(Item: T_ANE_IndexedLayerList): Integer;
    // see TList
    function First: T_ANE_IndexedLayerList;  virtual;
    // see TList
    function IndexOf(Item: T_ANE_IndexedLayerList): Integer; virtual;
    // see TList
//    procedure Insert(Index: Integer; Item: T_ANE_IndexedLayerList);
    // see TList
    function Last: T_ANE_IndexedLayerList; virtual;
    // see TList
//    function Remove(Item: T_ANE_IndexedLayerList): Integer;
    // see TList
    function GetIndexedLayerListByName(AName : string) : T_ANE_IndexedLayerList; virtual;
    // GetIndexedLayerListByName returns the first T_ANE_IndexedLayerList in
    // the T_ANE_ListOfIndexedLayerLists whose Name is AName.
    function GetNonDeletedIndLayerListByIndex(Index : integer) :
      T_ANE_IndexedLayerList; virtual;
    // GetNonDeletedIndLayerListByIndex returns the
    // position in the list of the T_ANE_IndexedLayerList whose postion
    // would be Index if all the deleted T_ANE_IndexedLayerList's were
    // removed from it.
    function GetNonDeletedIndLayerListIndexByIndex
         (Index : integer) : integer; virtual;
    // GetNonDeletedIndLayerListIndexByIndex returns the
    // position in the list of the T_ANE_IndexedLayerList whose postion
    // would be Index if all the deleted T_ANE_IndexedLayerList's were
    // removed from it.
//    procedure DeleteLayersByName(AName : string);
    // DeleteLayersByName calls the DeleteLayersByName procedure of all the
    // T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.

    procedure AddOrRemoveUnIndexedParameter
          (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
           ParameterShouldBePresent : boolean); virtual;
    // calls AddOrRemoveUnIndexedParameter of every T_ANE_IndexedLayerList
    // in the T_ANE_ListOfIndexedLayerLists
    procedure AddOrRemoveIndexedParameter0(ALayerType: T_ANE_LayerClass;
      AParameterType: T_ANE_ParamClass; ParameterShouldBePresent: boolean);
    procedure AddOrRemoveIndexedParameter1
          (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
           ParameterShouldBePresent : boolean); virtual;
    // calls AddOrRemoveIndexedParameter1 of every T_ANE_IndexedLayerList
    // in the T_ANE_ListOfIndexedLayerLists
    procedure AddOrRemoveIndexedParameter2
          (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
           ParameterShouldBePresent : boolean); virtual;
    // calls AddOrRemoveIndexedParameter2 of every T_ANE_IndexedLayerList
    // in the T_ANE_ListOfIndexedLayerLists
    procedure AddOrRemoveLayer(ALayerType : T_ANE_MapsLayerClass;
           LayerShouldBePresent : boolean); virtual;
    // calls AddOrRemoveLayer of every T_ANE_IndexedLayerList
    // in the T_ANE_ListOfIndexedLayerLists
    Property Items[Index : integer] : T_ANE_IndexedLayerList
      read GetItem  {write SetItem };
    // See TList
    Property Count : Integer  read GetCount  {write SetCount} ;
    // See TList
    Procedure MakeIndexedList0(
      ALayerType: T_ANE_LayerClass;
      AnIndexedParameterType : T_ANE_IndexedParameterListClass;
      Position : integer = -1); virtual;
    // calls MakeIndexedList0 of every T_ANE_IndexedLayerList
    // in the T_ANE_ListOfIndexedLayerLists
    Procedure MakeIndexedList1(
      ALayerType: T_ANE_LayerClass;
      AnIndexedParameterType : T_ANE_IndexedParameterListClass;
      Position : integer = -1); virtual;
    // calls MakeIndexedList1 of every T_ANE_IndexedLayerList
    // in the T_ANE_ListOfIndexedLayerLists
    Procedure MakeIndexedList2(
      ALayerType: T_ANE_LayerClass;
      AnIndexedParameterType : T_ANE_IndexedParameterListClass;
      Position : integer = -1); virtual;
    // calls MakeIndexedList2 of every T_ANE_IndexedLayerList
    // in the T_ANE_ListOfIndexedLayerLists
    Property Owner : TLayerStructure read FOwner;
    procedure SetUnIndexedExpressionNow(ALayerType : T_ANE_LayerClass;
      AParameterType : T_ANE_ParamClass; ParameterName : string;
      ShouldSetExpressionNow : boolean); virtual;
    procedure SetIndexed1ExpressionNow(ALayerType : T_ANE_LayerClass;
      AParameterType : T_ANE_ParamClass; ParameterName : string;
      ShouldSetExpressionNow : boolean); virtual;
    procedure SetIndexed2ExpressionNow(ALayerType : T_ANE_LayerClass;
      AParameterType : T_ANE_ParamClass; ParameterName : string;
      ShouldSetExpressionNow : boolean); virtual;
    procedure SetAllParamUnits; virtual;
    procedure SetParamUnits(AParameterType: T_ANE_ParamClass;
      ParameterName, LayerName: string); virtual;
    procedure MoveIndParam2ToParam(ParamType: T_ANE_ParamClass;
      ALayerType: T_ANE_LayerClass);
    procedure MoveParamToIndParam2(ParamType: T_ANE_ParamClass;
      ALayerType: T_ANE_LayerClass);
    procedure UpdateUnIndexedParamName(ALayerType: T_ANE_LayerClass;
      AParameterType: T_ANE_ParamClass);
    procedure UpdateIndexedParameterNeg1ParamName(ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
    procedure UpdateIndexedParameter0ParamName(ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
    procedure UpdateIndexedParameter1ParamName(ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
    procedure UpdateIndexedParameter2ParamName(ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
  end;

TLayerStructure = class(TObject)
  // TLayerStructure contains all the layers and parameters in the
  // Argus ONE layer structure. It has methods for handling the
  // addition and removal of layers and parameters.
  private
//    procedure SetLayersStatus(AStatus : TStatus);
    // SetLayersStatus calls the SetLayersStatus procedures of
    // UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
    // resulting in all layers in the TLayerStructure being assigned a
    // Status of AStatus.
//    procedure SetParametersStatus(AStatus : TStatus);
    // SetParametersStatus calls the SetParametersStatus procedures of
    // UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
    // resulting in all parameters in all the layers in the TLayerStructure
    // being assigned a Status of AStatus.
//    procedure DeleteLayersByName(AName : string);
    // DeleteLayersByName calls the DeleteLayersByName procedures of
    // UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
    // resulting in a call to the DeleteByName procedure of all layers in
    // the TLayerStructure. Any layer whose Name equals AName will be Freed
    // if its status is sNew. Otherwise, its Status will be changed to
    // sDeleted.
//    procedure DeleteParametersByName(AName : string);
    // DeleteParametersByName calls the DeleteParametersByName procedures of
    // UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
    // resulting in a call to the DeleteByName procedure of all the parameters
    // in all the layers in
    // the TLayerStructure. Any parameter whose Name equals AName will be Freed
    // if its status is sNew. Otherwise, its Status will be changed to
    // sDeleted.
//    procedure UpdateParameterIndicies;
    // UpdateParameterIndicies is called after all the deleted parameters have
    // been removed from Argus ONE. This is in preparation for renaming the
    // remaining indexed parameters.
//    procedure UpdateOldParameterIndicies;
    // UpdateOldParameterIndicies is called after all the indexed parameters
    // have had their names updated. UpdateOldParameterIndicies results in the
    // OldIndex's of all the T_ANE_IndexedParameterList's being set equal to
    // the Index of those T_ANE_IndexedParameterList.
    procedure RemoveDeletedLayers(const CurrentModelHandle : ANE_PTR);
    // RemoveDeletedLayers calls the RemoveDeletedLayers procedures of
    // UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
    // resulting in a call to the RemoveLayer procedure of all layers in
    // the TLayerStructure whose Status is sDeleted. This instructs Argus
    // ONE to remove all such layers.
    procedure RenameLayers(const CurrentModelHandle : ANE_PTR);
    // RenameIndexedLayers calls the RenameIndexedLayers procedure of
    // ListsOfIndexedLayers resulting in all indexed layers in the layer
    // structure having their names updated following removal of deleted layers.
    procedure RemoveDeletedParameters(const CurrentModelHandle : ANE_PTR);
    // RemoveDeletedParameters instructs Argus ONE to remove all parameters
    // whose Status is sDeleted.
    procedure RenameIndexedParameters(const CurrentModelHandle : ANE_PTR);
    // RenameIndexedParameters instructs Argus ONE to rename indexed parameters
    // whose indicies have changed.
    procedure AddNewParameters(const CurrentModelHandle : ANE_PTR);
    // AddNewParameters instructs Argus ONE to add all parameters whose Status
    // is sNew
//    procedure AddNewLayers(const CurrentModelHandle : ANE_PTR);
    // AddNewLayers instructs Argus ONE to add all layers whose Status
    // is sNew
    procedure ArrangeParameters;
    // ArrangeParameters calls the ArrangeParameters procedures of
    // UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
    // resulting in all parameters being arranged in the order specified in
    // the ParameterOrder StringList.
    procedure ArrangeLayers;
    // ArrangeLayers calls the ArrangeLayers procedures of
    // UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
    // resulting in all parameters being arranged in the order specified in
    // the LayerOrder StringList.
    Procedure TestNames;
    procedure FixLayers(const CurrentModelHandle: ANE_PTR);
    procedure SetParameterUnits(const CurrentModelHandle: ANE_PTR;
      const UseOldIndex: boolean);
    procedure AddMultipleNewLayers(const CurrentModelHandle : ANE_PTR);
    procedure SetWrittenParametersToNormal;
    procedure RestoreParamLock;
    procedure DontNeedToUpdateParamName;
    // TestNames tests that all parameters in each layer and all layers in the
    // layer structure will have unique names.
  protected
    procedure SetParamLock(const CurrentModelHandle: ANE_PTR); virtual;
  public
    UnIndexedLayers0 : T_ANE_LayerList;
    ZerothListsOfIndexedLayers : T_ANE_ListOfIndexedLayerLists;
    UnIndexedLayers : T_ANE_LayerList;
    UnIndexedLayers2 : T_ANE_LayerList;
    UnIndexedLayers3 : T_ANE_LayerList;
    // UnIndexedLayers is a list of the Unindexed layers, such as Domain
    // Outline, that will appear at the beginning of the layer structure.
    FirstListsOfIndexedLayers : T_ANE_ListOfIndexedLayerLists;
    IntermediateUnIndexedLayers : T_ANE_LayerList;
    ListsOfIndexedLayers : T_ANE_ListOfIndexedLayerLists;
    // ListsOfIndexedLayers is for indexed layers. These are usually related
    // to specific geological units. ListsOfIndexedLayers does not itself hold
    // layer objects but instead holds a list of layer objects that all
    // will be assigned the same index.
    PostProcessingLayers : T_ANE_LayerList;
    // PostProcessingLayers is a list of Unindexed layers, such as
    // postprocessing layers, that will appear at the end of the layer structure.
    RenameAllLayers : boolean ;
    constructor Create;
    // Create creates the layer structure in the PIE but does not instruct Argus
    // ONE to create a related set of layers.
    Destructor Destroy; override;
    // Destroy destroys the layer structure in the PIE and everything in it
    // including all layers, parameters, etc.
    function WriteLayers(const CurrentModelHandle : ANE_PTR) : string; virtual;
    // WriteLayers writes a string that can be passed to Argus ONE as a layer
    // structure template. (You must cast it to a PChar first.)
    procedure SetStatus(AStatus : TStatus); virtual;
    // Call SetStatus to set the status of everything to sNormal after passing
    // a layerstructure template to Argus ONE.
    // SetStatus sets the Status of all layers, parameters, etc. to AStatus.
    procedure FreeByStatus(AStatus : TStatus); virtual;
    // FreeByStatus calls the FreeByStatus procedures of
    // UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
    // resulting in the Freeing of all layers and parameters in all the layers
    // in the TLayerStructure that have a Status of AStatus.
    procedure SetExpressions(const CurrentModelHandle : ANE_PTR);
    // SetExpressions calls the SetExpressions procedures of
    // UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
    // resulting in the resetting of the expressions of all parameters in
    // which SetValue and SetExpressionNow are True. This is usually
    // the case only for Grid or Mesh parameters.
    procedure UpdateIndicies; virtual;
    // Update Indicies should be called in the Create procedure of any
    // descendent of TLayerStructure after all layers in the layer structure
    // have been added. UpdateIndicies sets the Index's in all
    // T_ANE_IndexedLayerList's and T_ANE_IndexedParameterList's in the
    // TLayerStructure to one larger
    // than their position in their T_ANE_ListOfIndexedLayerLists and
    // T_ANE_ListOfIndexedParameterLists respectively.
    procedure UpdateOldIndicies; virtual;
    // UpdateOldIndicies should be called in the Create procedure
    // of any descendent of TLayerStructure after calling UpdateIndicies
    // UpdateOldIndicies sets the OldIndex equal to the Index in all
    // T_ANE_IndexedLayerList's and T_ANE_IndexedParameterList's in the
    // TLayerStructure.
    Procedure AddParameterNeg1ListToList(ParameterListIndex : integer ;
      List : TList); virtual;
    Procedure AddParameter0ListToList(ParameterListIndex : integer ;
      List : TList); virtual;
    Procedure AddParameter1ListToList(ParameterListIndex : integer ;
      List : TList); virtual;
    // AddParameter1ListToList calls AddParameter1ListToList of
    // UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers.
    Procedure AddParameter2ListToList(ParameterListIndex : integer ;
      List : TList); virtual;
    // AddParameter2ListToList calls AddParameter2ListToList of
    // UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers.
    function MakeParameter1Lists(ParameterCount : integer) : TList ; virtual;
    // MakeParameter1Lists creates a TList and then
    // cyles from 0 to ParameterCount -1. On each cycle it creates another
    // TList which is Added to the result-TList.
    // It then calls AddParameter1ListToList.
    function MakeParameter2Lists(ParameterCount : integer) : TList ; virtual;
    // MakeParameter1Lists creates a TList and then
    // cyles from 0 to ParameterCount -1. On each cycle it creates another
    // TList which is Added to the result-TList.
    // It then calls AddParameter2ListToList.
{    procedure SetUnIndexedExpressionNow(ALayerType : T_ANE_LayerClass;
      AParameterType : T_ANE_ParamClass; ParameterName : string;
      ShouldSetExpressionNow : boolean);
    procedure SetIndexed1ExpressionNow(ALayerType : T_ANE_LayerClass;
      AParameterType : T_ANE_ParamClass; ParameterName : string;
      ShouldSetExpressionNow : boolean);
    procedure SetIndexed2ExpressionNow(ALayerType : T_ANE_LayerClass;
      AParameterType : T_ANE_ParamClass; ParameterName : string;
      ShouldSetExpressionNow : boolean); }
    procedure SetAllParamUnits; virtual;
    procedure Cancel; virtual;
    // Call Cancel when the user has choosen to cancel all changes made to
    // the layer structure.
    // Cancel Frees all layers and parameters whose Status's are sNew, sets
    // the Status's of all remaining layers and parameters to sNormal
    // and calls UpdateIndicies and UpdateOldIndicies.
    procedure OK(const CurrentModelHandle : ANE_PTR); virtual;
    // Call OK when the user has choosen to accept all changes to the layer
    // structure.
    // OK instructs Argus ONE to remove any layer or parameter whose Status
    // is sDeleted. The remaining indexed layers and parameters are renamed
    // to reflect what they should be in the final layer structure. Then new
    // layers and parameters are added to Argus ONE and the expressions of
    // parameters will be updated in any parameter in which SetValue is True.
    // The layer structure in the PIE is updated to reflect the changes made in
    // Argus ONE. This involves freeing deleted layers and parameters and
    // calling UpdateIndicies and UpdateOldIndicies when appropriate. Finally
    // the status of everything is set to sNormal. This last step may be
    // redundant because the status of each layer and parameter is updated
    // to sNormal when Argus ONE is instructed to create it.
    procedure UpdateOldName;
  end;


implementation

uses UtilityFunctions, CheckVersionFunction, FixNameUnit;

// WriteString puts quote marks around AString if AString contains
// a blank space.
function WriteString(AString : string) : string;
begin
  if Pos(' ', AString) > 0
  then
    begin
      Result := '"' + AString + '"';
    end
  else
    begin
      Result := AString ;
    end;
end;

// WriteBool returns 'Yes' if ABool is True and 'No' if ABool is False.
function WriteBool(ABool : boolean) : string;
begin
  if ABool
  then
    begin
      Result := 'Yes';
    end
  else
    begin
      Result := 'No';
    end;
end;
{ TTestStringList }
function TTestStringList.Add(const S: string): Integer;
begin
  if IndexOf(S) = -1
  then
    begin
      result := inherited Add(S);
    end
  else
    begin
      raise EInvalidName.Create('Invalid Name: ' + S + '; '
        + 'Contact PIE developer for assistance.');
    end;
end;

procedure TTestStringList.Insert(Index: Integer; const S: string);
begin
  if IndexOf(S) = -1
  then
    begin
      inherited Insert(Index, S)
    end
  else
    begin
      raise EInvalidName.Create('Invalid Name:' + S +'; '
        + 'Contact PIE developer for assistance.' );
    end;
end;


//-------------------------------------------------------------------------
{ T_ANE_Param }

// Create a parameter and add or insert it in AParameterList.
constructor T_ANE_Param.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer = -1);
begin
  inherited Create;
//  Name := 'New Parameter';
//  Units := '';
  SetUnits := False;
  FStatus := sNew;
  SetExpressionNow := False;
  ParameterList := AParameterList;
  SetValue := False;
  Lock := StandardParameterLock;
  if (Index < 0) or (Index > ParameterList.FList.Count-1)
  then
    begin
      ParameterList.FList.Add(self);
    end
  else
    begin
      ParameterList.FList.Insert(Index, self);
    end;
  ParameterList.Sorted := False;
  ParameterType := lptLayer;
  FOldRoot := WriteName;
  FOldName := WriteCurrentName;
  if (AParameterList.ParameterOrder.Count > 0) and
     (AParameterList.ParameterOrder.IndexOf(Ane_ParamName) = -1)
  then
    begin
      raise EInvalidParameter.Create(Ane_ParamName
        + ' is an invalid parameter; '
        + 'Contact PIE developer for assistance.');
    end;
end;

class Function T_ANE_Param.Ane_ParamName : string ;
begin
  result := 'New Parameter';
end;

function T_ANE_Param.Units : string;
begin
  result := ''
end; 

{procedure T_ANE_Param.SetUnits(const Value: string);
begin
  FUnits := Value;
end; }


destructor T_ANE_Param.Destroy;
begin
  ParameterList.FList.Remove(self);
  inherited Destroy;
end;

// Value is used to set the expression of value of a parameter. By default
// Value returns '0'. Value will need to be overridden by most mesh and
// grid parameters.
function T_ANE_Param.Value : string; //override to set value;
begin
  result := '0';
end;


// WriteIndex returns as string representation of the Index of
// the T_ANE_IndexedParameterList that owns the parameter if it is
// owned by a T_ANE_IndexedParameterList. Otherwise it returns ''
function T_ANE_Param.WriteIndex : string;
var
  IndexedParameterList : T_ANE_IndexedParameterList;
begin
  if ParameterList is T_ANE_IndexedParameterList
  then
    begin
      IndexedParameterList := ParameterList as T_ANE_IndexedParameterList;
      result := IntToStr(IndexedParameterList.Index)
    end
  else
    begin
      result := ''
    end;
end;

// WriteOldIndex returns as string representation of the OldIndex of
// the T_ANE_IndexedParameterList that owns the parameter if it is
// owned by a T_ANE_IndexedParameterList. Otherwise it returns ''
function T_ANE_Param.WriteOldIndex : string;
var
  IndexedParameterList : T_ANE_IndexedParameterList;
begin
  if ParameterList is T_ANE_IndexedParameterList
  then
    begin
      IndexedParameterList := ParameterList as T_ANE_IndexedParameterList;
      result := IntToStr(IndexedParameterList.OldIndex)
    end
  else
    begin
      result := ''
    end;
end;

{procedure T_ANE_Param.SetSetExpressionNow(const Value: boolean);
begin
  FSetExpressionNow := Value;
end;  }

procedure T_ANE_Param.SetParameterUnits(const CurrentModelHandle,
  LayerHandle: ANE_PTR; UseOldIndex : Boolean);
var
  parameterIndex : ANE_INT32;
  Value : ANE_STR;
begin
  if SetUnits then
  begin
    parameterIndex := GetParameterIndex(CurrentModelHandle, UseOldIndex, LayerHandle);
    Value := PChar(Units);
    ANE_LayerParameterPropertySet (CurrentModelHandle, parameterIndex,
      LayerHandle, PChar('Units'), kPIEString, Value);
    SetUnits := False;
  end;
end;

function T_ANE_Param.LockString(const CurrentModelHandle : ANE_PTR;
  ALock : TParamLock) : string;
var
  // First_Lock is used to determine if a comma needs to be present before
  // the next item in the list of characteristics to be locked.
  First_Lock : Boolean;
  Dummy : string;
begin
  result := '';
  if (ALock = []) then
  begin
//    result := '';
    Exit;
  end;
  First_Lock := True;
//  result := '"';
  if plName in ALock then
  begin
    result := result +  'Lock Name';
    First_Lock := False;
  end;
  if plUnits in ALock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Units';
    First_Lock := False;
  end;
  if plType in ALock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Type';
    First_Lock := False;
  end;
  if plInfo in ALock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Info';
    First_Lock := False;
  end;
  if plDef_Val in ALock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Def Val';
    First_Lock := False;
  end;
  if plDont_Override in ALock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Dont Override';
    First_Lock := False;
  end;
  if plInhibit_Delete in ALock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Inhibit Delete';
    First_Lock := False;
  end;
  if (plKind in ALock) and CheckArgusVersion(CurrentModelHandle,4,2,0,'d',Dummy) then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Kind';
    First_Lock := False;
  end;
  if (plDontEvalColor in ALock) and CheckArgusVersion(CurrentModelHandle,4,2,0,'g',Dummy) then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Dont Eval Color';
//    First_Lock := False;
  end;
//  result := result + '"'
end;

// WriteLock calls EvaluateLock and then writes a string representing
// the characteristics of the parameter that are locked.
function T_ANE_Param.WriteLock(const CurrentModelHandle : ANE_PTR) : string;
begin
  {$IFDEF Argus5}
  Lock := EvaluateLock;
  {$ENDIF}
  if (Lock = []) then
  begin
    result := '';
  end
  else
  begin
    result := Chr(9) + Chr(9) + 'Lock: "'
    + LockString(CurrentModelHandle, Lock)
    + '"' + Chr(10);
  end;

  OldLock := Lock;
end;

// WriteParameterType writes a string representation of the parameter
// type. Most parameters can only be layer parameters. Grid parameters
// can be either layer or block parameters. Mesh parameters can be
// either layer, element, or node parameters.
function T_ANE_Param.WriteParameterType : string;
begin
  result := '';
  case ParameterType of
    lptLayer :
      begin
        result := 'Layer';
      end;
  end;
end;

// WritePar returns a string representation of all the Parameter properties
// that can be passed to Argus ONE to create the parameter in Argus ONE.
function T_ANE_Param.WritePar(const aneHandle : ANE_PTR) : string;
var
  ValueString : String;
  CharIndex : integer;
begin
  FOldRoot := WriteName;
  SetUnits := False;
{
Chr(9) is a tab character.

Chr(10) is the new-line character.
}
  ValueString := Value;
  for CharIndex := Length(ValueString) downto 1 do
  begin
    if ValueString[CharIndex] = '"' then
    begin
      ValueString := Copy(ValueString,1,CharIndex-1) + '\'
        + Copy(ValueString,CharIndex,Length(ValueString))
    end;
  end;


  result :=
    Chr(9) + 'Parameter: ' + Chr(10) +
    Chr(9) + '{' + Chr(10) +
    Chr(9) + Chr(9) + 'Name: "' + WriteCurrentName + '"' + Chr(10) +
    Chr(9) + Chr(9) + 'Units: "' + Units + '"' + Chr(10) +
    Chr(9) + Chr(9) + 'Value Type: ' + WriteValueType + Chr(10) +
    Chr(9) + Chr(9) + 'Value: "' + ValueString + '"' + Chr(10) +
    Chr(9) + Chr(9) + 'Parameter Type: ' + WriteParameterType + Chr(10) +
    WriteLock(aneHandle) +
    Chr(9) + '}' + Chr(10);

  FOldName := WriteCurrentName;
end;

// Delete will destroy the parameter that calls it if its status is SNew.
// Otherwise, it will change the parameter status to sDeleted.
Procedure T_ANE_Param.Delete;
begin
  Case Status of
    sNew:
      begin
        Free;
//        self := nil;
      end;
    else
      begin
        FStatus := sDeleted;
      end;
  end;
end;

// Undelete will change the status of a parameter from sDeleted to sNormal.
Procedure T_ANE_Param.UnDelete;
begin
  case Status of
    sDeleted:
      begin
        FStatus := sNormal;
      end;
  end;
end;

// FreeByStatus will destroy the parameter if that calls it if the status
// of the paramter is the same as AStatus. FreeByStatus is called by the
// TLayerStructure.OK procedure to destroy deleted parameters. It is also
// called by the TLayerStructure.Cancel procedure to destroy new parameters.
procedure T_ANE_Param.FreebyStatus(AStatus : TStatus);
begin
  if Status = AStatus then
  begin
    Free;
  end;
end;

// If the Name property of the parameter is equal to AName, DeleteByName
// will call the Delete procedure.
{
procedure T_ANE_Param.DeleteByName(AName : string);
begin
  if Name = AName then
  begin
    Delete;
  end
end;
}

// GetParentLayer returns the T_ANE_Layer that owns the T_ANE_ParameterList
// that owns the parameter. It is called by GetParentLayerHandle.
function T_ANE_Param.GetParentLayer : T_ANE_Layer;
var
  AListOfIndexedParameterLists : T_ANE_ListOfIndexedParameterLists;
begin
  if ParameterList.Owner is T_ANE_Layer
  then
    begin
      result := ParameterList.Owner as T_ANE_Layer;
    end
  else if ParameterList.Owner is T_ANE_ListOfIndexedParameterLists
  then
    begin
      AListOfIndexedParameterLists :=
        ParameterList.Owner as T_ANE_ListOfIndexedParameterLists;
      result := AListOfIndexedParameterLists.Owner;
    end
  else // this branch should never be called.
    begin
      result := nil;
    end;
end;

// GetParentLayerHandle returns the handle of the T_ANE_Layer that (indirectly)
// owns the parameter.
{
function T_ANE_Param.GetParentLayerHandle: ANE_PTR;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  if not(ParentLayer = nil)
  then
    begin
      result := ParentLayer.GetLayerHandle;
    end
  else // this branch should never be called.
    begin
      result := nil;
    end;
end;
}
// This returns the index used by Argus ONE to identify the position
// of the parameter in the list of parameters.
function T_ANE_Param.GetParameterIndex(const CurrentModelHandle : ANE_PTR;
  UseOldIndex : Boolean; const LayerHandle : ANE_PTR) : ANE_INT32;
var
//  LayerHandle : ANE_PTR;
  ParameterName : string;
//  ANE_ParameterName : ANE_STR;
begin
//  LayerHandle := GetParentLayerHandle;
  if LayerHandle = nil
  then
  begin
    result := -1
  end
  else
  begin
    if UseOldIndex
    then
    begin
      ParameterName := FOldName
    end
    else
    begin
      ParameterName := WriteCurrentName;
    end;
    result := ANE_LayerGetParameterByName(CurrentModelHandle,
           LayerHandle, PChar(ParameterName) );
    if (result < 0) and not UseOldIndex then
    begin
      // this may occur if the layer and parameter have the same name.
      ParameterName := WriteNewName;
      result := ANE_LayerGetParameterByName(CurrentModelHandle,
             LayerHandle, PChar(ParameterName) );
    end;
  end;
end;

// RemoveParameter instructs Argus ONE to remove the parameter.
function T_ANE_Param.RemoveParameter(const CurrentModelHandle : ANE_PTR;
  const LayerHandle : ANE_PTR) : ANE_BOOL;
var
//  LayerHandle : ANE_PTR;
  ParameterIndex : ANE_INT32;
begin
//  LayerHandle := GetParentLayerHandle;
  if LayerHandle = nil
  then
    begin
      result := False;
    end
  else
    begin
        // "True" in GetParameterIndex indicates that OldIndex rather than
        // Index is used in getting the Parameter Index.
      ParameterIndex := GetParameterIndex(CurrentModelHandle, True,
        LayerHandle);
      if ParameterIndex = -1
      then
        begin
          result := False;
        end
      else
        begin
          result := ANE_LayerRemoveParameter(CurrentModelHandle, LayerHandle,
                   ParameterIndex, True );
        end;
    end;
end;


// RenameIndexedParameter changes the name of a parameter owned by a
// T_ANE_IndexedParameterList
function T_ANE_Param.RenameParameter(const CurrentModelHandle : ANE_PTR;
  const LayerHandle : ANE_PTR) : ANE_BOOL;
var
//  LayerHandle : ANE_PTR;
  ParameterIndex : ANE_INT32;
  NewParameterName : string;
begin
//  ProcessEvents(CurrentModelHandle);
  NewParameterName := WriteNewName;
  if (((WriteIndex = WriteOldIndex) and (FOldRoot = WriteName))
    or (Status <> sNormal)) and (NewParameterName = FOldName) then
  begin
    result := False;
  end
  else
  begin
    if (LayerHandle = nil) then
    begin
      result := False;
    end
    else
    begin
      // "True" in GetParameterIndex indicates that OldIndex rather than
      // Index is used in getting the Parameter Index.
      ParameterIndex := GetParameterIndex(CurrentModelHandle, True,
        LayerHandle);
      if ParameterIndex = -1 then
      begin
        result := False;
      end
      else
      begin
        result := URenameParameter(CurrentModelHandle,
                 LayerHandle, ParameterIndex, NewParameterName ) ;
        SetExpressionNow := True;
        FOldRoot := WriteName;
        FOldName := NewParameterName;
      end;
    end;
  end;
  FNeedToUpdateParamName := False;
end;

function T_ANE_Param.SetArgusLock(const CurrentModelHandle : ANE_PTR;
  const LayerHandle : ANE_PTR) : ANE_BOOL;
var
//  LayerHandle : ANE_PTR;
  ParameterIndex : ANE_INT32;
//  NewParameterName : string;
//  ANE_ParameterName : ANE_STR;
  AParam : TParameterOptions;
  TempLock : TParamLock;
  ALock : TParamLockValues;
  ALockString : string;
begin
//  ProcessEvents(CurrentModelHandle);
//  NewParameterName := WriteNewName;
  Lock := EvaluateLock;
  if (Status = sNew) or (Status = sDeleted) or (LayerHandle = nil) or (Lock = OldLock) then
  begin
      result := False;
  end
  else
  begin
    ParameterIndex := GetParameterIndex(CurrentModelHandle, False, LayerHandle);
    if ParameterIndex = -1 then
    begin
      result := False;
    end
    else
    begin
//      result := False;
      AParam := TParameterOptions.Create(LayerHandle,ParameterIndex);

      TempLock := [];
      for ALock := Low(TParamLockValues) to High(TParamLockValues) do
      begin
        if (ALock in Lock) and not (ALock in OldLock) then
        begin
          TempLock := TempLock + [ALock];
        end;
      end;
      ALockString := LockString(CurrentModelHandle, TempLock);
      if ALockString <> '' then
      begin
        AParam.PlusLock[CurrentModelHandle] := ALockString;
      end;

      TempLock := [];
      for ALock := Low(TParamLockValues) to High(TParamLockValues) do
      begin
        if not (ALock in Lock) and (ALock in OldLock) then
        begin
          TempLock := TempLock + [ALock];
        end;
      end;
      ALockString := LockString(CurrentModelHandle, TempLock);
      if ALockString <> '' then
      begin
        AParam.MinusLock[CurrentModelHandle] := ALockString;
      end;
      result := True;

    end;
  end;
  OldLock := Lock;
end;

// GetPreviousParameter returns the parameter after which the current
// parameter should be added in Argus ONE.
function T_ANE_Param.GetPreviousParameter : T_ANE_Param;
var
  AnIndexedParameterList : T_ANE_IndexedParameterList ;
  AListOfIndexedParameterLists : T_ANE_ListOfIndexedParameterLists;
  ALayer : T_ANE_Layer;
begin
  if ParameterList is T_ANE_IndexedParameterList
  then
    begin
      AnIndexedParameterList := ParameterList as T_ANE_IndexedParameterList;
      AListOfIndexedParameterLists := AnIndexedParameterList.Owner
         as T_ANE_ListOfIndexedParameterLists;
      result := AListOfIndexedParameterLists.GetPreviousParameter
         (AnIndexedParameterList, self);
      if result = nil then
      begin
        ALayer := AListOfIndexedParameterLists.Owner;
        if AListOfIndexedParameterLists = ALayer.IndexedParamList2
        then
          begin
            result := ALayer.IndexedParamList1.GetPreviousParameter
              (AnIndexedParameterList, self);
            if result = nil then
            begin
              result := ALayer.IndexedParamList0.GetPreviousParameter
                (AnIndexedParameterList, self);
              if result = nil then
              begin
                result := ALayer.IndexedParamListNeg1.GetPreviousParameter
                  (AnIndexedParameterList, self);
                if result = nil then
                begin
                  result := ALayer.ParamList.GetPreviousParameter(self);
                end;
              end;
            end;
          end
        else if AListOfIndexedParameterLists = ALayer.IndexedParamList1
        then
          begin
            result := ALayer.IndexedParamList0.GetPreviousParameter
              (AnIndexedParameterList, self);
            if result = nil then
            begin
              result := ALayer.IndexedParamListNeg1.GetPreviousParameter
                (AnIndexedParameterList, self);
              if result = nil then
              begin
                result := ALayer.ParamList.GetPreviousParameter(self);
              end;
            end;
          end
        else if AListOfIndexedParameterLists = ALayer.IndexedParamList0
        then
          begin
            result := ALayer.IndexedParamListNeg1.GetPreviousParameter
              (AnIndexedParameterList, self);
            if result = nil then
            begin
              result := ALayer.ParamList.GetPreviousParameter(self);
            end;
          end
        else if AListOfIndexedParameterLists = ALayer.IndexedParamListNeg1
        then
          begin
            result := ALayer.ParamList.GetPreviousParameter(self);
          end
        else
          begin
            result := ALayer.ParamList.GetPreviousParameter(self);
          end;
      end;
    end
  else
    begin
      result := ParameterList.GetPreviousParameter(self);
    end;
end;

// AddNewParameter adds a new parameter in Argus ONE.
procedure T_ANE_Param.AddNewParameter(const CurrentModelHandle : ANE_PTR;
  const LayerHandle : ANE_PTR);
var
  PreviousParameter : T_ANE_Param;
  PreviousParameterIndex : integer;
//  LayerHandle : ANE_PTR;
  ParameterTemplate : string;
  ANE_ParameterTemplate : ANE_STR;
begin
//  ProcessEvents(CurrentModelHandle );
  if Status = sNew then
  begin
    PreviousParameter := GetPreviousParameter;
    if PreviousParameter = nil
    then
      begin
        PreviousParameterIndex := -1;
      end
    else
      begin
        // "False" in GetParameterIndex indicates that Index rather than
        // OldIndex is used in getting the Parameter Index.
        PreviousParameterIndex := PreviousParameter.GetParameterIndex
          (CurrentModelHandle, False, LayerHandle);
      end;
//    LayerHandle := GetParentLayerHandle;
    ParameterTemplate :=  WritePar(CurrentModelHandle);
//    ANE_ParameterTemplate := PChar(ParameterTemplate);
    GetMem(ANE_ParameterTemplate, Length(ParameterTemplate) + 1);
    try
      StrPCopy(ANE_ParameterTemplate, ParameterTemplate);
      ANE_LayerAddParametersByTemplate(CurrentModelHandle, LayerHandle,
        ANE_ParameterTemplate, PreviousParameterIndex );
      ANE_ProcessEvents(CurrentModelHandle);
    finally
      FreeMem(ANE_ParameterTemplate);
    end;
    OldLock := Lock;

    FOldName := WriteCurrentName;
    FStatus := sNormal;
  end;
end;

// SetExpression sets the expression of a parameter if SetValue
// and SetExpressionNow are True.
// It should only be called after all parameters that should be added or
// deleted from Argus ONE have been added or deleted.
procedure T_ANE_Param.SetExpression(const CurrentModelHandle : ANE_PTR;
  const LayerHandle : ANE_PTR);
var
//  ALayer : T_ANE_Layer;
//  LayerHandle : ANE_PTR;
  parameterIndex : ANE_INT32;
  NewParameterExpression : string;
begin
  if SetValue and SetExpressionNow then
  begin
    // "False" in GetParameterIndex indicates that Index rather than
    // OldIndex is used in getting the Parameter Index.
    parameterIndex := GetParameterIndex(CurrentModelHandle, False, LayerHandle);
    NewParameterExpression := Value;
    USetParameterExpression(CurrentModelHandle, LayerHandle,
       parameterIndex, NewParameterExpression );
    SetExpressionNow := False;
  end;
end;

procedure T_ANE_Param.UpdateOldName;
begin
  FOldName := WriteCurrentName;
end;

procedure T_ANE_Param.FixParam(const CurrentModelHandle, LayerHandle : ANE_PTR);
begin
  If (Status = sNormal) and
//    (GetParameterIndex(CurrentModelHandle, True, LayerHandle) < 0) and
    (GetParameterIndex(CurrentModelHandle, False, LayerHandle) < 0) then
  begin
    FStatus := sNew;
  end;
  FOldName := WriteCurrentName;
end;

// returns the name of the parameter in Argus ONE. By default this is
// the "Name" of the parameter. WriteName may be overridden to specify
// something else to use as the name in Argus ONE.
function T_ANE_Param.WriteName : string ;
begin
  result := WriteParamName;
end;

function T_ANE_Param.WriteSpecialBeginning : String ;
begin
  result := '';
end;

function T_ANE_Param.WriteSpecialMiddle : String ;
begin
  result := '';
end;

function T_ANE_Param.WriteSpecialEnd : String ;
begin
  result := '';
end;

class function T_ANE_Param.WriteParamName: string;
begin
  result := ANE_ParamName;
end;

procedure T_ANE_Param.Move(ParamList: T_ANE_ParameterList;
  Index: integer);
var
  NewParentLayer : T_ANE_Layer;
begin
  if (ParamList.Owner is T_ANE_ListOfIndexedParameterLists)
  then
  begin
    NewParentLayer := T_ANE_ListOfIndexedParameterLists(ParamList.Owner).Owner as T_ANE_Layer;
  end
  else
  begin
    NewParentLayer := ParamList.Owner as T_ANE_Layer;
  end;
  if GetParentLayer <> NewParentLayer then
  begin
    raise EInvalidParameterList.Create('Error while attempting to move '
      + 'parameter to a different layer.');
  end;
  ParameterList.FList.Remove(self);
  ParameterList := ParamList;
  if (Index < 0) or (Index > ParameterList.FList.Count-1)
  then
    begin
      ParameterList.FList.Add(self);
    end
  else
    begin
      ParameterList.FList.Insert(Index, self);
    end;
  ParameterList.Sorted := False;
  if (ParamList.ParameterOrder.Count > 0) and
     (ParamList.ParameterOrder.IndexOf(self.Ane_ParamName) = -1)
  then
    begin
      raise EInvalidParameter.Create('Invalid Parameter; '
        + 'Contact PIE developer for assistance.');
    end;
  NewParentLayer.RenameAllParameters := True;
  if ParameterList is T_ANE_IndexedParameterList then
  begin
    T_ANE_IndexedParameterList(ParameterList).FRenameAllParameters := True;
  end;
end;

function T_ANE_Param.WriteCurrentName: string;
begin
  result := WriteSpecialBeginning + FOldRoot
    + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd;
end;

function T_ANE_Param.WriteNewName: string;
begin
  result := WriteSpecialBeginning + WriteName
    + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd;
end;

//-------------------------------------------------------------------------
{ T_ANE_DataParam }

// see T_ANE_Param
constructor T_ANE_DataParam.Create(AParameterList : T_ANE_ParameterList;
            Index : Integer = -1);
begin
  inherited Create(AParameterList, Index);
  ParameterType := lptLayer;
  ValueType := dpvReal;
end;

// returns a string indicating the type of data in the data parameter.
// At present, data parameters must always be real numbers.
function T_ANE_DataParam.WriteValueType : string;
begin
  result := '';
  case ValueType of
    dpvReal :
      begin
        result := 'Real';
      end;
  end;
end;

//-------------------------------------------------------------------------
{ T_ANE_LayerParam }

// see T_ANE_Param
constructor T_ANE_LayerParam.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer = -1);
begin
  inherited Create(AParameterList, Index);
  ValueType := pvReal;
end;

// returns a string indicating the type of data in the layer parameter.
// At present, ayer parameters may be strings, integers, reals, or booleans.
function T_ANE_LayerParam.WriteValueType : string;
begin
  result := '';
  case ValueType of
    pvString :
      begin
        result := 'String';
      end;
    pvReal :
      begin
        result := 'Real';
      end;
    pvInteger :
      begin
        result := 'Integer';
      end;
    pvBoolean :
      begin
        result := 'Boolean';
      end;
  end;
end;

//-------------------------------------------------------------------------
{ T_ANE_ParentIndexLayerParam }

// Write Name will write the ParentLayer's ANE_Name + the parent layer's index;
function T_ANE_ParentIndexLayerParam.WriteName : string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.WriteLayerRoot ;
end;

function T_ANE_ParentIndexLayerParam.WriteIndex : string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.WriteIndex ;
end;

Function T_ANE_ParentIndexLayerParam.WriteOldIndex : string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.WriteOldIndex ;
end;

function T_ANE_ParentIndexLayerParam.Units : string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.Units ;
end;

{function T_ANE_ParentIndexLayerParam.GetUnits: string;
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  result := ParentLayer.Units ;
end; }

{procedure T_ANE_ParentIndexLayerParam.SetUnits(const Value: string);
var
  ParentLayer : T_ANE_Layer;
begin
  ParentLayer := GetParentLayer;
  ParentLayer.Units :=  Value;
end;}

//-------------------------------------------------------------------------
{ T_ANE_MeshParam }

// see T_ANE_Param; the default values of mesh parameters are locked.
constructor T_ANE_MeshParam.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer = -1);
begin
  inherited Create(AParameterList, Index);
  ParameterType := mptElement;
  Lock := Lock + [plDef_Val, plKind];
  SetValue := True;
end;

// writes a string indicating the parameter type. At present, mesh parameters
// may be layer, node, or element parameters.
function T_ANE_MeshParam.WriteParameterType : string;
begin
  result := '';
  case ParameterType of
    mptLayer :
      begin
        result := 'Layer';
      end;
    mptElement :
      begin
        result := 'Element';
      end;
    mptNode :
      begin
        result := 'Node';
      end;
  end;
end;

//-------------------------------------------------------------------------
{ T_ANE_GridParam }

// see T_ANE_Param; the default values of grid parameters are locked.
constructor T_ANE_GridParam.Create(AParameterList : T_ANE_ParameterList;
  Index : Integer = -1);
begin
  inherited Create(AParameterList, Index);
  ParameterType := gptBlock;
  Lock := Lock + [plDef_Val, plKind];
  SetValue := True;
end;



// writes a string indicating the parameter type. At present, grid parameters
// may be layer, or block parameters.
function T_ANE_GridParam.WriteParameterType : string;
begin
  result := '';
  case ParameterType of
    gptLayer :
      begin
        result := 'Layer';
      end;
    gptBlock :
      begin
        result := 'Block';
      end;
  end;
end;

//-------------------------------------------------------------------------
{ T_ANE_MapsLayer }

// T_ANE_MapsLayer is the base object for all Argus ONE layer objects.
// T_ANE_MapsLayer can not have any parameters. It may be used for Map Layers.

// Create creates a layer. ALayerList is the T_ANE_LayerList that
// owns the new layer. Index is the position within the T_ANE_LayerList
// of the new layer. If the position indicated by Index is invalid,
// the layer will be added at the end of the list. Thus using an
// Index less than 0 results in the layer being added to the end of the
// list. By itself, creating a layer does not instruct Argus ONE to
// add the layer. That is done in the TLayerStructure.OK procedure which
// calls the AddNewLayer procedure.
constructor T_ANE_MapsLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer = -1) ;
begin
  inherited Create;
//  Name := kMaps;
//  Units := '';
  SetUnits := False;
  LayerType := 'Maps';
  Visible := True;
  FStatus := sNew;
  LayerList := ALayerList;
  Lock := StandardLayerLock;
  FOldRoot := WriteLayerRoot;
  if LayerList <> nil then
  begin
    if (Index < 0) or (Index > LayerList.Count-1) then
    begin
      LayerList.FList.Add(self);
    end
    else
    begin
      LayerList.FList.Insert(Index, self);
    end;
    LayerList.Sorted := False;
    if (ALayerList.LayerOrder.Count > 0) and (ALayerList.LayerOrder.IndexOf
      (ANE_LayerName) = -1) then
    begin
      raise EInvalidLayer.Create('Invalid Layer; '
       + 'Contact PIE developer for assistance.');
    end;
  end;
end ;

class Function T_ANE_MapsLayer.ANE_LayerName : string ;
begin
  result := 'Maps';
end;

// destroys the layer.
destructor T_ANE_MapsLayer.Destroy;
begin
  if LayerList <> nil then
  begin
    LayerList.FList.Remove(self);
  end;
  inherited Destroy;
end;

function T_ANE_MapsLayer.Units : string;
begin
  result := '';
end; 

{procedure T_ANE_MapsLayer.SetUnits(const Value: string);
begin
  FUnits := Value;
end;}

function T_ANE_MapsLayer.WriteTemplate : string;
begin
  result := '';
end;

function T_ANE_MapsLayer.FixLayer(const CurrentModelHandle: ANE_PTR) : ANE_PTR;
begin
  result := GetLayerHandle(CurrentModelHandle);
  if (result = nil) and (Status = sNormal) then
  begin
    FStatus := sNew;
  end
end;



// WriteLayer returns a string that can be passed to Argus ONE to create a
// layer.
function T_ANE_MapsLayer.WriteLayer(const CurrentModelHandle : ANE_PTR) : string;
begin
  FOldRoot := WriteLayerRoot;
  SetUnits := False;
{
Chr(9) is a tab character.
Chr(10) is the new-line character.
}

// WriteInterpMethod, WriteDomDens, and WriteParameters return '' in
// T_ANE_MapsLayer but these functions are overridden in some descendents
// to return other values as appropriate.
  result :=
    'Layer:' + Chr(10) +
    '{' + Chr(10) +
    Chr(9) + 'Name: "' + WriteSpecialBeginning + WriteLayerRoot
      + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd + '"' + Chr(10) +
    Chr(9) + 'Units: "' + Units + '"' + Chr(10) +
    Chr(9) + 'Type: "' + LayerType + '"' + Chr(10) +
    Chr(9) + 'Visible: ' + WriteBool(Visible) + Chr(10) +
    WriteInterpMethod +
    WriteInterpPie +
    WriteReverseGridX(CurrentModelHandle) +
    WriteReverseGridY(CurrentModelHandle) +
    WriteGridBlockCentered(CurrentModelHandle) +
    WriteDomDens +
    WriteLock(CurrentModelHandle) +
    Chr(9) + '' + Chr(10) +
    WriteParameters(CurrentModelHandle) +
    WriteTemplate  +
    '}' + Chr(10);
end;

// if the layer is owned by a T_ANE_IndexedLayerList, WriteIndex returns
// a string represntation of the Index of that T_ANE_IndexedLayerList.
// Otherwise it returns ''.
function T_ANE_MapsLayer.WriteIndex : string;
var
  IndexedLayerList : T_ANE_IndexedLayerList;
begin
  if LayerList is T_ANE_IndexedLayerList
  then
    begin
      IndexedLayerList := LayerList as T_ANE_IndexedLayerList;
      result := IntToStr(IndexedLayerList.Index)
    end
  else
    begin
      result := ''
    end;
end;

// WriteOldIndex returns as string representation of the OldIndex of
// the T_ANE_IndexedLayerList that owns the parameter if it is
// owned by a T_ANE_IndexedLayerList. Otherwise it returns ''
function T_ANE_MapsLayer.WriteOldIndex : string;
var
  IndexedLayerList : T_ANE_IndexedLayerList;
begin
  if LayerList is T_ANE_IndexedLayerList
  then
    begin
      IndexedLayerList := LayerList as T_ANE_IndexedLayerList;
      result := IntToStr(IndexedLayerList.OldIndex)
    end
  else
    begin
      result := ''
    end;
end;

// WriteDomDens returns ''. It is overriden in T_ANE_TriMeshLayer
function T_ANE_MapsLayer.WriteDomDens : string;
begin
  result := '';
end;

function T_ANE_MapsLayer.WriteReverseGridX(const CurrentModelHandle : ANE_PTR)
  : string;
begin
  result := '';
end;

function T_ANE_MapsLayer.WriteReverseGridY(const CurrentModelHandle : ANE_PTR)
  : string;
begin
  result := '';
end;

// WriteLock writes a string representing the characteristics of the
// layer that are locked.
function T_ANE_MapsLayer.WriteLock(const CurrentModelHandle : ANE_PTR) : string;
var
  // First_Lock is used to determine if a comma needs to be present before
  // the next item in the list of characteristics to be locked.
  First_Lock : Boolean;
  Dummy : string;
begin
  First_Lock := True;
  result := '';
  if Lock = []
  then
    begin
      result := '';
      Exit;
    end
  else
    begin
      result := Chr(9) + 'Lock: "';
    end;
  if llName in Lock then
  begin
    result := result +  'Lock Name';
    First_Lock := False;
  end;
  if llUnits in Lock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Units';
    First_Lock := False;
  end;
  if llType in Lock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Type';
    First_Lock := False;
  end;
  if llInfo in Lock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock Info';
    First_Lock := False;
  end;
  if llEvalAlg in Lock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    if CheckArgusVersion(CurrentModelHandle,4,2,0,'d',Dummy) then
    begin
      result := result +  'Lock Interp. Method';
    end
    else
    begin
      result := result +  'Lock Eval Alg';
    end;
    First_Lock := False;
  end;
  if llAll_Params in Lock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Lock All Params';
    First_Lock := False;
  end;
  if llInhibit_Delete in Lock then
  begin
    if not First_Lock then
    begin
      result := result + ', ';
    end;
    result := result +  'Inhibit Delete';
//    First_Lock := False;
  end;
  if not (Lock = []) then
  begin
    result := result + '"' + Chr(10);
  end;

end;


// WriteInterpMethod returns ''. It is overriden in T_ANE_InfoLayer
function T_ANE_MapsLayer.WriteInterpMethod : string;
begin
  result := '';
end;

// WriteParameters returns ''. It is overriden in T_ANE_Layer
function T_ANE_MapsLayer.WriteParameters(const CurrentModelHandle : ANE_PTR) : string;
begin
  result := '';
end;

// SetParametersStatus does nothing. It is overridden in T_ANE_Layer
procedure T_ANE_MapsLayer.SetParametersStatus(AStatus : TStatus);
begin
end;

// if the status of a layer is sNew, calling delete will call the layer.
// Otherwise, it will change the status of the layer to sDeleted.
Procedure T_ANE_MapsLayer.Delete;
begin
  case Status of
    sNew:
      begin
        Free;
//        self := nil;
      end;
    else
      begin
        FStatus := sDeleted;
      end;
  end;
end;

// Undelete will change the status of a layer from sDeleted to sNormal.
Procedure T_ANE_MapsLayer.UnDelete;
begin
  case Status of
    sDeleted:
      begin
        FStatus := sNormal;
      end;
  end;
end;

// FreeByStatus will destroy all layers whose Status is equal to AStatus.
procedure T_ANE_MapsLayer.FreebyStatus(AStatus : TStatus);
begin
  if Status = AStatus then
  begin
    Free;
  end;
end;

// DeleteByName will call Delete is Name equals AName

procedure T_ANE_MapsLayer.DeleteByName(AName : string);
begin
  if ANE_LayerName = AName then
  begin
    Delete;
  end
end;


// DeleteParametersByName does nothing. It is overridden in T_ANE_Layer
{
procedure T_ANE_MapsLayer.DeleteParametersByName(AName : string);
begin
end;
}

// UpdateParameterIndicies does nothing. It is overridden in T_ANE_Layer
procedure T_ANE_MapsLayer.UpdateParameterIndicies;
begin
end;

// UpdateOldParameterIndicies does nothing. It is overridden in T_ANE_Layer
procedure T_ANE_MapsLayer.UpdateOldParameterIndicies;
begin
end;

function T_ANE_MapsLayer.GetOldLayerHandle(const CurrentModelHandle : ANE_PTR) : ANE_PTR;
var
  LayerName : string;
begin
  if CurrentModelHandle = nil then
  begin
    result := nil;
  end
  else
  begin
    LayerName := WriteSpecialBeginning + WriteOldRoot
        + WriteSpecialMiddle + WriteOldIndex + WriteSpecialEnd;
    result := UtilityFunctions.GetLayerHandle(CurrentModelHandle,LayerName);
  end;
end;

// GetLayerHandle gets the handle of the layer.
function T_ANE_MapsLayer.GetLayerHandle(const CurrentModelHandle : ANE_PTR) : ANE_PTR;
var
  LayerName : string;
begin
  if CurrentModelHandle = nil then
  begin
    result := nil;
  end
  else
  begin
    LayerName := WriteSpecialBeginning + WriteLayerRoot
        + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd;
    result := UtilityFunctions.GetLayerHandle(CurrentModelHandle,LayerName);
//    ANE_ProcessEvents(CurrentModelHandle);
  end;
end;

// RemoveLayer removes the layer from Argus ONE
function T_ANE_MapsLayer.RemoveLayer(const CurrentModelHandle : ANE_PTR) : ANE_BOOL;
var
  LayerHandle : ANE_PTR;
begin
//  ProcessEvents(CurrentModelHandle );
  LayerHandle := GetOldLayerHandle(CurrentModelHandle);
  if (LayerHandle = nil) then
  begin
    result := False;
  end
  else
  begin
    result := ANE_LayerRemove(CurrentModelHandle, LayerHandle, True );
  end;
end;

// RenameIndexedLayer changes the name of the layer in Argus ONE from
// Name + OldIndex to Name + NewIndex.
function T_ANE_MapsLayer.RenameLayer(const CurrentModelHandle : ANE_PTR)
  : ANE_BOOL;
var
  LayerHandle : ANE_PTR;
  NewLayerName : string;
//  ANE_LayerNameStr : ANE_STR;
begin
//  ProcessEvents(CurrentModelHandle );
//  if (WriteIndex = WriteOldIndex) and (Status <> sNormal)
  if ((WriteIndex = WriteOldIndex) and (FOldRoot = WriteLayerRoot))
    or (Status <> sNormal) then
  begin
      result := False;
  end
  else
  begin
    LayerHandle := GetOldLayerHandle(CurrentModelHandle);
    if (LayerHandle = nil) then
    begin
      result := False;
    end
    else
    begin
      NewLayerName := WriteSpecialBeginning + WriteLayerRoot
        + WriteSpecialMiddle + WriteIndex + WriteSpecialEnd;
//          ANE_LayerNameStr := PChar(NewLayerName);
      result := ULayerRename(CurrentModelHandle, LayerHandle,
        NewLayerName );
      FOldRoot := WriteLayerRoot;
    end;
  end;
end;

// RemoveDeletedParameters does nothing. It is overridden in T_ANE_Layer.
procedure T_ANE_MapsLayer.RemoveDeletedParameters;
begin
end;

// RenameIndexedParameters does nothing. It is overridden in T_ANE_Layer.
procedure T_ANE_MapsLayer.RenameIndexedParameters;
begin
end;

// AddNewParameters does nothing. It is overridden in T_ANE_Layer.
procedure T_ANE_MapsLayer.AddNewParameters;
begin
end;

// GetPreviousLayer returns the layer after which it is appropriate to
// add this layer.
function T_ANE_MapsLayer.GetPreviousLayer : T_ANE_MapsLayer;
var
  AnIndexedLayerList : T_ANE_IndexedLayerList ;
  AListOfIndexedLayerLists : T_ANE_ListOfIndexedLayerLists;
  ALayerStructure : TLayerStructure;
  LS : TObject;
  ListOfLists: TList;
  Start: Integer;
  ListIndex: integer;
  LocalLayerList : T_ANE_LayerList;
  LocalListOfIndexedLayerLists : T_ANE_ListOfIndexedLayerLists;
begin
  if LayerList = nil then
  begin
    result := nil;
  end
  else
  begin
    if LayerList is T_ANE_IndexedLayerList then
    begin
      AnIndexedLayerList := LayerList as T_ANE_IndexedLayerList;
      AListOfIndexedLayerLists := AnIndexedLayerList.Owner
        as T_ANE_ListOfIndexedLayerLists;
      result := AListOfIndexedLayerLists.GetPreviousLayer
        (AnIndexedLayerList, self);
    end
    else
    begin
      result := LayerList.GetPreviousLayer(self);
    end;

    if result = nil then
    begin
      ListOfLists := TList.Create;
      try
        if LayerList is T_ANE_IndexedLayerList then
        begin
          AnIndexedLayerList := LayerList as T_ANE_IndexedLayerList;
          AListOfIndexedLayerLists := AnIndexedLayerList.Owner
            as T_ANE_ListOfIndexedLayerLists;
          ALayerStructure := AListOfIndexedLayerLists.Owner;
        end
        else
        begin
          AListOfIndexedLayerLists := nil;
          ALayerStructure := LayerList.Owner as TLayerStructure;
        end;
        Assert(ALayerStructure <> nil);

        ListOfLists.Add(ALayerStructure.UnIndexedLayers0);
        ListOfLists.Add(ALayerStructure.ZerothListsOfIndexedLayers);
        ListOfLists.Add(ALayerStructure.UnIndexedLayers);
        ListOfLists.Add(ALayerStructure.UnIndexedLayers2);
        ListOfLists.Add(ALayerStructure.UnIndexedLayers3);
        ListOfLists.Add(ALayerStructure.FirstListsOfIndexedLayers);
        ListOfLists.Add(ALayerStructure.IntermediateUnIndexedLayers);
        ListOfLists.Add(ALayerStructure.ListsOfIndexedLayers);
        ListOfLists.Add(ALayerStructure.PostProcessingLayers);


        Start := ListOfLists.IndexOf(LayerList);
        if Start < 0 then
        begin
          Start := ListOfLists.IndexOf(AListOfIndexedLayerLists);
        end;
        Assert(Start >= 0);
        Dec(Start);
        for ListIndex := Start downto 0 do
        begin
          LS := ListOfLists[ListIndex];
          if LS is T_ANE_LayerList then
          begin
            LocalLayerList := T_ANE_LayerList(LS);
            result := LocalLayerList.GetPreviousLayer(self);
            if result <> nil then
            begin
              Exit;
            end;
          end
          else if Ls is T_ANE_ListOfIndexedLayerLists then
          begin
            LocalListOfIndexedLayerLists := T_ANE_ListOfIndexedLayerLists(LS);
            if LocalListOfIndexedLayerLists.Count > 0 then
            begin
              result := LocalListOfIndexedLayerLists.GetPreviousLayer
                (LocalListOfIndexedLayerLists.Last, self);
              if result <> nil then
              begin
                Exit;
              end;
            end;
          end
          else
          begin
            Assert(False);
          end;
        end;
      finally
        ListOfLists.Free;
      end;
    end;
  end;
end;

// AddNewLayer instructs Argus ONE to add the layer if its Status is sNew.
{procedure T_ANE_MapsLayer.AddNewLayer(const CurrentModelHandle : ANE_PTR);
var
  ANE_LayerTemplate : ANE_STR ;
  LayerTemplate : string;
  PreviousLayer : T_ANE_MapsLayer;
  PreviousLayerHandle : ANE_PTR;
begin
//  ProcessEvents(CurrentModelHandle );
  if Status = sNew then
  begin
    LayerTemplate := WriteLayer(CurrentModelHandle);
    ANE_LayerTemplate := PChar(LayerTemplate);
    PreviousLayer := GetPreviousLayer;
    if PreviousLayer = nil
    then
      begin
          PreviousLayerHandle := nil;
      end
    else
      begin
          PreviousLayerHandle := PreviousLayer.GetLayerHandle
            (CurrentModelHandle);
      end;
    ANE_LayerAddByTemplate(CurrentModelHandle, ANE_LayerTemplate,
           PreviousLayerHandle );
    FStatus := sNormal;
    SetNewParametersToNormal;
  end;
end; }

procedure T_ANE_MapsLayer.AddMultipleNewLayers
  (const CurrentModelHandle : ANE_PTR;  var LayerTemplate : String;
   var PreviousLayer : T_ANE_MapsLayer);
var
  ANE_LayerTemplate : ANE_STR ;
  NewLayerTemplate : string;
  NewPreviousLayer : T_ANE_MapsLayer;
  PreviousLayerHandle : ANE_PTR;
  ALayerStructure : TLayerStructure;
  ListOfLayerLists : T_ANE_ListOfIndexedLayerLists;
begin
//  ProcessEvents(CurrentModelHandle );
  if Status = sNew then
  begin
    NewLayerTemplate := WriteLayer(CurrentModelHandle);
    NewPreviousLayer := GetPreviousLayer;
    if NewPreviousLayer = PreviousLayer then
    begin
      LayerTemplate := LayerTemplate + NewLayerTemplate;
      FStatus := sWritten;
      SetNewParametersToWritten;
    end
    else
    begin
      if LayerTemplate <> '' then
      begin
        if PreviousLayer = nil then
        begin
          PreviousLayerHandle := nil;
        end
        else
        begin
          PreviousLayerHandle := PreviousLayer.GetLayerHandle
            (CurrentModelHandle);
        end;
//        ANE_LayerTemplate := PChar(LayerTemplate);
        GetMem(ANE_LayerTemplate, Length(LayerTemplate) + 1);
        try
          StrPCopy(ANE_LayerTemplate, LayerTemplate);
          ANE_LayerAddByTemplate(CurrentModelHandle, ANE_LayerTemplate,
               PreviousLayerHandle );
          ANE_ProcessEvents(CurrentModelHandle);
        finally
          FreeMem(ANE_LayerTemplate);
        end;
        ALayerStructure := nil;
        if LayerList.Owner is TLayerStructure then
        begin
          ALayerStructure := TLayerStructure(LayerList.Owner);
        end
        else if LayerList.Owner is T_ANE_ListOfIndexedLayerLists then
        begin
          ListOfLayerLists := T_ANE_ListOfIndexedLayerLists(LayerList.Owner);
          ALayerStructure := ListOfLayerLists.Owner;
        end
        else
        begin
          Assert(False);
        end;
        ALayerStructure.SetWrittenParametersToNormal;
      end;
      LayerTemplate := NewLayerTemplate;
      PreviousLayer  := NewPreviousLayer;
      FStatus := sWritten;
      SetNewParametersToWritten;
    end;
  end;
end;

// SetNewParametersToNormal does nothing. It is overridden in T_ANE_Layer.
procedure T_ANE_MapsLayer.SetNewParametersToNormal;
begin
end;

procedure T_ANE_MapsLayer.SetNewParametersToWritten;
begin
end;

procedure T_ANE_MapsLayer.SetWrittenParametersToNormal;
begin
end;


// ArrangeParameters does nothing. It is overridden in T_ANE_Layer.
procedure T_ANE_MapsLayer.ArrangeParameters;
begin
end;

// SetExpressions does nothing. It is overridden in T_ANE_Layer.
procedure T_ANE_MapsLayer.SetExpressions;
begin
end;

// CreateParamterList1 does nothing. Override to create an indexed parameter
// list that will be added to IndexedParamList1 in T_ANE_Layer
procedure T_ANE_MapsLayer.CreateParamterList1;
begin
end;

// CreateParamterList2 does nothing. Override to create an indexed parameter
// list that will be added to IndexedParamList2 in T_ANE_Layer
procedure T_ANE_MapsLayer.CreateParamterList2;
begin
end;

function T_ANE_MapsLayer.WriteSpecialBeginning : String ;
begin
  result := '';
end;

function T_ANE_MapsLayer.WriteSpecialMiddle : String ;
begin
  result := '';
end;

function T_ANE_MapsLayer.WriteSpecialEnd: string;
begin
  if DataIndex = 0 then
  begin
    result := ''
  end
  else
  begin
    result := IntToStr(DataIndex);
  end;

end;

class function T_ANE_MapsLayer.WriteNewRoot: string;
begin
  result := ANE_LayerName;
end;

function T_ANE_MapsLayer.WriteOldRoot: string;
begin
  result := FOldRoot;
end;


//-------------------------------------------------------------------------
{ T_ANE_GroupLayer }

// T_ANE_GroupLayer may be used for group layers.

// see T_ANE_MapsLayer
constructor T_ANE_GroupLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer = -1) ;
begin
  inherited Create( ALayerList, Index);
//  Name := 'New Group Layer';
  LayerType := 'Group';
end ;

class Function T_ANE_GroupLayer.ANE_LayerName : string ;
begin
  result := 'New Group Layer';
end;

//-------------------------------------------------------------------------
{ T_ANE_Layer }

// T_ANE_Layer is the base class for layers with parameters. No actual
// T_ANE_Layer should be created. Instead, use descendent of T_ANE_Layer.

// see T_ANE_MapsLayer
constructor T_ANE_Layer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer = -1) ;
begin
  inherited Create( ALayerList,Index);
  RenameAllParameters := False;
  ParamList := T_ANE_ParameterList.Create(self);
  IndexedParamListNeg1 := T_ANE_ListOfIndexedParameterLists.Create(self);
  IndexedParamList0 := T_ANE_ListOfIndexedParameterLists.Create(self);
  IndexedParamList1 := T_ANE_ListOfIndexedParameterLists.Create(self);
  IndexedParamList2 := T_ANE_ListOfIndexedParameterLists.Create(self);
//  Name := 'New Layer';
//  Units := 'Units';
  LayerType := 'Information';
end ;

class Function T_ANE_Layer.ANE_LayerName : string ;
begin
  result := 'New Layer';
end;

// Destroy destroys the layer.
destructor T_ANE_Layer.Destroy;
begin
  ParamList.Free;
  IndexedParamListNeg1.Free;
  IndexedParamList0.Free;
  IndexedParamList1.Free;
  IndexedParamList2.Free;
{  ParamList := nil;
  IndexedParamListNeg1 := nil;
  IndexedParamList0 := nil;
  IndexedParamList1 := nil;
  IndexedParamList2 := nil; }
  inherited Destroy;
//  self := nil;
end;

// WriteParameters writes a string representing all the parameters
// owned (indirectly) by the layer.
function T_ANE_Layer.WriteParameters(const CurrentModelHandle : ANE_PTR) : string;
begin
  result := ParamList.WriteParameters(CurrentModelHandle)
         + IndexedParamListNeg1.WriteParameters(CurrentModelHandle)
         + IndexedParamList0.WriteParameters(CurrentModelHandle)
         + IndexedParamList1.WriteParameters(CurrentModelHandle)
         + IndexedParamList2.WriteParameters(CurrentModelHandle) ;
end;

procedure T_ANE_Layer.SetParameterUnits(const CurrentModelHandle : ANE_PTR;
  const UseOldIndex: boolean);
var
  LayerHandle: ANE_PTR;
begin
  if UseOldIndex then
  begin
    LayerHandle := GetOldLayerHandle(CurrentModelHandle);
  end
  else
  begin
    LayerHandle := GetLayerHandle(CurrentModelHandle);
  end;
  ParamList.SetParameterUnits(CurrentModelHandle, LayerHandle, UseOldIndex);
  IndexedParamListNeg1.SetParameterUnits(CurrentModelHandle, LayerHandle, UseOldIndex);
  IndexedParamList0.SetParameterUnits(CurrentModelHandle, LayerHandle, UseOldIndex);
  IndexedParamList1.SetParameterUnits(CurrentModelHandle, LayerHandle, UseOldIndex);
  IndexedParamList2.SetParameterUnits(CurrentModelHandle, LayerHandle, UseOldIndex);
end;

// SetParametersStatus sets the Status of all the parameters owned
// (indirectly) by the layer to AStatus.
procedure T_ANE_Layer.SetParametersStatus(AStatus : TStatus);
begin
  ParamList.SetStatus(AStatus);
  IndexedParamListNeg1.SetStatus(AStatus);
  IndexedParamList0.SetStatus(AStatus);
  IndexedParamList1.SetStatus(AStatus);
  IndexedParamList2.SetStatus(AStatus);
end;

// FreeByStatus calls the inherited FreeByStatus if Status equals AStatus.
// Otherwise it calls FreeByStatus of ParamList, IndexedParamList1 and
// IndexedParamList2.
procedure T_ANE_Layer.FreeByStatus(AStatus : TStatus);
begin
  if Status = AStatus
  then
    begin
      inherited FreeByStatus(AStatus);
    end
  else
    begin
      ParamList.FreeByStatus(AStatus);
      IndexedParamListNeg1.FreeByStatus(AStatus);
      IndexedParamList0.FreeByStatus(AStatus);
      IndexedParamList1.FreeByStatus(AStatus);
      IndexedParamList2.FreeByStatus(AStatus);
    end;
end;

// DeleteParametersByName calls the DeleteByName procedure of ParamList,
// IndexedParamList1 and IndexedParamList2.
{
procedure T_ANE_Layer.DeleteParametersByName(AName : string);
begin
  ParamList.DeleteByName(AName);
  IndexedParamList1.DeleteByName(AName);
  IndexedParamList2.DeleteByName(AName);
end;
}

// UpdateParameterIndicies changes the Index properties of all the
// T_ANE_IndexedParameterList owned (indirectly) by the layer to the
// position of the T_ANE_IndexedParameterList in the
// T_ANE_ListOfIndexedParameterLists
procedure T_ANE_Layer.UpdateParameterIndicies;
begin
  IndexedParamListNeg1.UpdateIndicies;
  IndexedParamList0.UpdateIndicies;
  IndexedParamList1.UpdateIndicies;
  IndexedParamList2.UpdateIndicies;
end;

// UpdateOldParameterIndicies changes the OldIndex properties of all the
// T_ANE_IndexedParameterList owned (indirectly) by the layer to be the
// same as the Index properties of those T_ANE_IndexedParameterList's.
procedure T_ANE_Layer.UpdateOldParameterIndicies;
begin
  IndexedParamListNeg1.UpdateOldIndicies;
  IndexedParamList0.UpdateOldIndicies;
  IndexedParamList1.UpdateOldIndicies;
  IndexedParamList2.UpdateOldIndicies;
end;

// RemoveDeletedParameters instructs Argus ONE to remove all parameters
// (indirectly) owned by the layer whose Status is sDeleted.
procedure T_ANE_Layer.RemoveDeletedParameters(const CurrentModelHandle: ANE_PTR);
var
  LayerHandle : ANE_PTR;
begin
  LayerHandle := GetOldLayerHandle(CurrentModelHandle);
  ParamList.RemoveDeletedParameters(CurrentModelHandle, LayerHandle);
  IndexedParamListNeg1.RemoveDeletedParameters(CurrentModelHandle, LayerHandle );
  IndexedParamList0.RemoveDeletedParameters(CurrentModelHandle, LayerHandle );
  IndexedParamList1.RemoveDeletedParameters(CurrentModelHandle, LayerHandle );
  IndexedParamList2.RemoveDeletedParameters(CurrentModelHandle, LayerHandle );
end;

// RenameIndexedParameters changes the names of all indexed parameters
// in the layer from Name + OldIndex to Name + Index.
procedure T_ANE_Layer.RenameIndexedParameters(const CurrentModelHandle: ANE_PTR);
var
  LayerHandle : ANE_PTR;
begin
  LayerHandle := GetOldLayerHandle(CurrentModelHandle);
  if RenameAllParameters or FNeedToUpdateParamName then
  begin
    ParamList.RenameParameters(CurrentModelHandle, LayerHandle, RenameAllParameters);
  end ;

  IndexedParamListNeg1.RenameParameters(CurrentModelHandle, LayerHandle, RenameAllParameters);
  IndexedParamList0.RenameParameters(CurrentModelHandle, LayerHandle, RenameAllParameters);
  IndexedParamList1.RenameParameters(CurrentModelHandle, LayerHandle, RenameAllParameters);
  IndexedParamList2.RenameParameters(CurrentModelHandle, LayerHandle, RenameAllParameters);
  FNeedToUpdateParamName := False;
end;

// AddNewParameters instructs Argus ONE to adds all parameters in the
// layer whose status is sNew.
procedure T_ANE_Layer.AddNewParameters(const CurrentModelHandle: ANE_PTR);
var
  LayerHandle : ANE_PTR;
begin
  LayerHandle := GetLayerHandle(CurrentModelHandle);
  ParamList.AddNewParameters(CurrentModelHandle, LayerHandle);
  IndexedParamListNeg1.AddNewParameters(CurrentModelHandle, LayerHandle);
  IndexedParamList0.AddNewParameters(CurrentModelHandle, LayerHandle);
  IndexedParamList1.AddNewParameters(CurrentModelHandle, LayerHandle);
  IndexedParamList2.AddNewParameters(CurrentModelHandle, LayerHandle);
end;

procedure T_ANE_Layer.SetParamLock(const CurrentModelHandle: ANE_PTR);
var
  LayerHandle : ANE_PTR;
begin
  LayerHandle := GetLayerHandle(CurrentModelHandle);
  ParamList.SetLock(CurrentModelHandle, LayerHandle);
  IndexedParamListNeg1.SetLock(CurrentModelHandle, LayerHandle);
  IndexedParamList0.SetLock(CurrentModelHandle, LayerHandle);
  IndexedParamList1.SetLock(CurrentModelHandle, LayerHandle);
  IndexedParamList2.SetLock(CurrentModelHandle, LayerHandle);
end;


procedure T_ANE_Layer.RestoreParamLock;
begin
  ParamList.RestoreLock;
  IndexedParamListNeg1.RestoreLock;
  IndexedParamList0.RestoreLock;
  IndexedParamList1.RestoreLock;
  IndexedParamList2.RestoreLock;
end;

procedure T_ANE_Layer.SetAllParamUnits;
begin
  ParamList.SetAllParamUnits;
  IndexedParamListNeg1.SetAllParamUnits;
  IndexedParamList0.SetAllParamUnits;
  IndexedParamList1.SetAllParamUnits;
  IndexedParamList2.SetAllParamUnits;
end;

procedure T_ANE_Layer.SetParamUnits(AParameterType: T_ANE_ParamClass;
      ParameterName: string);
begin
  ParamList.SetParamUnits(AParameterType, ParameterName);
  IndexedParamListNeg1.SetParamUnits(AParameterType, ParameterName);
  IndexedParamList0.SetParamUnits(AParameterType, ParameterName);
  IndexedParamList1.SetParamUnits(AParameterType, ParameterName);
  IndexedParamList2.SetParamUnits(AParameterType, ParameterName);
end;

// SetNewParametersToNormal changes the status of all parameters from
// sNew to sNormal.
procedure T_ANE_Layer.SetNewParametersToNormal;
begin
  ParamList.SetNewParametersToNormal;
  IndexedParamListNeg1.SetNewParametersToNormal;
  IndexedParamList0.SetNewParametersToNormal;
  IndexedParamList1.SetNewParametersToNormal;
  IndexedParamList2.SetNewParametersToNormal;
end;

procedure T_ANE_Layer.SetNewParametersToWritten;
begin
  ParamList.SetNewParametersToWritten;
  IndexedParamListNeg1.SetNewParametersToWritten;
  IndexedParamList0.SetNewParametersToWritten;
  IndexedParamList1.SetNewParametersToWritten;
  IndexedParamList2.SetNewParametersToWritten;
end;

procedure T_ANE_Layer.SetWrittenParametersToNormal;
begin
  ParamList.SetWrittenParametersToNormal;
  IndexedParamListNeg1.SetWrittenParametersToNormal;
  IndexedParamList0.SetWrittenParametersToNormal;
  IndexedParamList1.SetWrittenParametersToNormal;
  IndexedParamList2.SetWrittenParametersToNormal;
end;

// ArrangeParameters ensures that all Parameters owned by the layer
// are in the correct order. ArrangeParameters should be called before
// adding parameters.
procedure T_ANE_Layer.ArrangeParameters;
begin
  ParamList.ArrangeParameters;
  IndexedParamListNeg1.ArrangeParameters;
  IndexedParamList0.ArrangeParameters;
  IndexedParamList1.ArrangeParameters;
  IndexedParamList2.ArrangeParameters;
end;

// SetExpressions sets the expressions of all parameters owned by the
// layer in which SetValue and SetExpressionNow is true.
procedure T_ANE_Layer.SetExpressions(const CurrentModelHandle: ANE_PTR);
var
  LayerHandle : ANE_PTR;
begin
  LayerHandle := GetLayerHandle(CurrentModelHandle);
  ParamList.SetExpressions(CurrentModelHandle, LayerHandle);
  IndexedParamListNeg1.SetExpressions(CurrentModelHandle, LayerHandle);
  IndexedParamList0.SetExpressions(CurrentModelHandle, LayerHandle);
  IndexedParamList1.SetExpressions(CurrentModelHandle, LayerHandle);
  IndexedParamList2.SetExpressions(CurrentModelHandle, LayerHandle);
end;

procedure T_ANE_Layer.AddOrRemoveUnIndexedParameter
  (AParameterType : T_ANE_ParamClass; ParameterShouldBePresent : boolean);
var
  An_ANE_Param : T_ANE_Param;
begin
  An_ANE_Param :=
           ParamList.GetParameterByName(AParameterType.ANE_ParamName)
           as AParameterType;
  if ParameterShouldBePresent then
  begin
    if (An_ANE_Param = nil) then
    begin
      AParameterType.Create( ParamList, -1) ;
    end
    else
    begin
      An_ANE_Param.UnDelete
    end;
  end
  else //if ParameterShouldBePresent
  begin
    if not ( An_ANE_Param = nil) then
    begin
      An_ANE_Param.Delete;
    end;
  end; //if ParameterShouldBePresent else
end;

procedure T_ANE_Layer.AddOrRemoveIndexedParameter1
  (AParameterType : T_ANE_ParamClass; ParameterShouldBePresent : boolean);
var
  Index : integer;
  An_ANE_Param : T_ANE_Param;
  An_ANE_IndexedParameterList : T_ANE_IndexedParameterList;
begin
  for Index := 0 to IndexedParamList1.Count -1 do
  begin
    An_ANE_IndexedParameterList := IndexedParamList1.Items[Index];

    An_ANE_Param :=
             An_ANE_IndexedParameterList.GetParameterByName
               (AParameterType.ANE_ParamName) as AParameterType;
    if ParameterShouldBePresent then
    begin
      if (An_ANE_Param = nil) then
      begin
        AParameterType.Create(An_ANE_IndexedParameterList, -1) ;
      end
      else
      begin
        An_ANE_Param.UnDelete
      end;
    end
    else //if ParameterShouldBePresent
    begin
      if not ( An_ANE_Param = nil) then
      begin
        An_ANE_Param.Delete;
      end;
    end; //if ParameterShouldBePresent else
  end;
end;

procedure T_ANE_Layer.AddOrRemoveIndexedParameter2
  (AParameterType : T_ANE_ParamClass; ParameterShouldBePresent : boolean);
var
  Index : integer;
  An_ANE_Param : T_ANE_Param;
  An_ANE_IndexedParameterList : T_ANE_IndexedParameterList;
begin
  for Index := 0 to IndexedParamList2.Count -1 do
  begin
    An_ANE_IndexedParameterList := IndexedParamList2.Items[Index];

    An_ANE_Param :=
             An_ANE_IndexedParameterList.GetParameterByName
               (AParameterType.ANE_ParamName) as AParameterType;
    if ParameterShouldBePresent then
    begin
      if (An_ANE_Param = nil) then
      begin
        AParameterType.Create(An_ANE_IndexedParameterList, -1) ;
      end
      else
      begin
        An_ANE_Param.UnDelete
      end;
    end
    else //if ParameterShouldBePresent
    begin
      if not ( An_ANE_Param = nil) then
      begin
        An_ANE_Param.Delete;
      end;
    end; //if ParameterShouldBePresent else
  end;
end;

Procedure T_ANE_Layer.AddParameter1ListToList(ParameterListIndex : integer ;
  List : TList);
begin
  IndexedParamList1.AddParameterListToList(ParameterListIndex, List );
end;

Procedure T_ANE_Layer.AddParameter2ListToList(ParameterListIndex : integer ;
  List : TList);
begin
  IndexedParamList2.AddParameterListToList(ParameterListIndex, List );
end;

procedure T_ANE_Layer.UpdateOldName;
begin
  ParamList.UpdateOldName;
  IndexedParamListNeg1.UpdateOldName;
  IndexedParamList0.UpdateOldName;
  IndexedParamList1.UpdateOldName;
  IndexedParamList2.UpdateOldName;
end;


function T_ANE_Layer.FixLayer(const CurrentModelHandle: ANE_PTR): ANE_PTR;
begin
  result := Inherited FixLayer(CurrentModelHandle);
  if Status = sNormal then
  begin
    ParamList.FixParam(CurrentModelHandle,result);
    IndexedParamListNeg1.FixParam(CurrentModelHandle,result);
    IndexedParamList0.FixParam(CurrentModelHandle,result);
    IndexedParamList1.FixParam(CurrentModelHandle,result);
    IndexedParamList2.FixParam(CurrentModelHandle,result);
  end;
end;

procedure T_ANE_Layer.SetUnIndexedExpressionNow(AParameterType: T_ANE_ParamClass;
  ParameterName: string; ShouldSetExpressionNow: boolean);
begin
  ParamList.SetExpressionNow(AParameterType, ParameterName,
    ShouldSetExpressionNow);
end;

procedure T_ANE_Layer.SetIndexed1ExpressionNow(AParameterType: T_ANE_ParamClass;
  ParameterName: string; ShouldSetExpressionNow: boolean);
begin
  IndexedParamList1.SetExpressionNow(AParameterType, ParameterName,
    ShouldSetExpressionNow);
end;

procedure T_ANE_Layer.SetIndexed2ExpressionNow(AParameterType: T_ANE_ParamClass;
  ParameterName: string; ShouldSetExpressionNow: boolean);
begin
  IndexedParamList2.SetExpressionNow(AParameterType, ParameterName,
    ShouldSetExpressionNow);
end;

procedure T_ANE_Layer.MoveIndParam2ToParam(ParamType: T_ANE_ParamClass);
var
  AParam : T_ANE_Param;
  AParamList : T_ANE_IndexedParameterList;
begin
  AParamList := IndexedParamList2.GetNonDeletedIndParameterListByIndex(0);
  AParam := AParamList.GetParameterByName(ParamType.ANE_ParamName);
  if AParam = nil then
  begin
//    ParamType.Create(ParamList,-1);
  end
  else
  begin
    AParam.Move(ParamList);
  end;

end;

procedure T_ANE_Layer.MoveParamToIndParam2(ParamType: T_ANE_ParamClass);
var
  AParam : T_ANE_Param;
  AParamList : T_ANE_IndexedParameterList;
begin
  AParam := ParamList.GetParameterByName(ParamType.ANE_ParamName);
  if AParam <> nil then
  begin
    AParamList := IndexedParamList2.GetNonDeletedIndParameterListByIndex(0);
    AParam.Move(AParamList);
  end;
end;


//-------------------------------------------------------------------------
{ T_ANE_InfoLayer }

// T_ANE_InfoLayer is used for information layers.

// see T_ANE_MapsLayer
constructor T_ANE_InfoLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer = -1) ;
begin
  inherited Create( ALayerList, Index);
//  Name := 'New Information Layer';
  Interp := leNearest;
end ;

class Function T_ANE_InfoLayer.ANE_LayerName : string ;
begin
  result := 'New Information Layer';
end;

// WriteInterpMethod returns a string that can be used in the parameter
// template sent to Argus ONE to indicate the interpretation method.
function T_ANE_InfoLayer.WriteInterpMethod : string;
begin
  result := Chr(9) + 'Interpretation Method: ';
  case Interp of
    leNearest :
      begin
        result := result + 'Nearest';
      end;
    leExact :
      begin
        result := result + 'Exact';
      end;
    else
      begin
        result := result + 'Interpolate';
      end;
  end;
  result := result + Chr(10);
end;

//-------------------------------------------------------------------------
{ T_ANE_DomainOutlineLayer }

// T_ANE_DomainOutlineLayer is used for domain outline layers.

// see T_ANE_MapsLayer
constructor T_ANE_DomainOutlineLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer = -1) ;
begin
  inherited Create(ALayerList, Index);
  LayerType := 'Domain';
end ;

class Function T_ANE_DomainOutlineLayer.ANE_LayerName : string ;
begin
  result := kDomOut;
end;

function T_ANE_DomainOutlineLayer.Units : string;
begin
  result := 'Density';
end;

//-------------------------------------------------------------------------
{ T_ANE_DensityLayer }

// T_ANE_DensityLayer is used for density layers.

// see T_ANE_MapsLayer
{
constructor T_ANE_DensityLayer.Create(Index: Integer;
  ALayerList : T_ANE_LayerList) ;
begin
  inherited Create(Index, ALayerList);
//  Name := kDensity;
//  Units := '';
end ;
}

class Function T_ANE_DensityLayer.ANE_LayerName : string ;
begin
  result := kDensity;
end;

{constructor T_ANE_DensityLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Units := '';
end;  }

function T_ANE_DensityLayer.Units : string;
begin
  result := '';
end; 

//-------------------------------------------------------------------------
{ T_ANE_DataLayer }

// T_ANE_DataLayer is used for data layers.

// see T_ANE_MapsLayer
constructor T_ANE_DataLayer.Create(ALayerList : T_ANE_LayerList; Index: Integer
  = -1);
begin
  inherited Create(ALayerList, Index);
  LayerType := 'Data';
  Lock := [];
  Visible := False;
  Interp := leInterpolate;
end ;

class Function T_ANE_DataLayer.ANE_LayerName : string ;
begin
  result := 'Data';
end;

function T_ANE_DataLayer.Units : string;
begin
  result := '';
end;

//-------------------------------------------------------------------------
{ T_ANE_TriMeshLayer }

// T_ANE_TriMeshLayer is used for TriMesh layers.

// see T_ANE_MapsLayer
constructor T_ANE_TriMeshLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer = -1) ;
begin
  inherited Create( ALayerList, Index);
  Template := TStringList.Create;
  LayerType := 'Mesh';
  DomainLayer := kDomOut;
  DensityLayer:= kDensity;
end ;

destructor T_ANE_TriMeshLayer.Destroy;
begin
  Template.Free;
  inherited;
end;

class Function T_ANE_TriMeshLayer.ANE_LayerName : string ;
begin
  result := 'TriMesh';
end;

// WriteDomDens returns a string that can be used in the parameter
// template sent to Argus ONE to Domain and Density layers for the
// T_ANE_TriMeshLayer.
function T_ANE_TriMeshLayer.WriteDomDens : string;
begin
  result :=
  Chr(9) + 'Domain Layer: "' + DomainLayer + '"' + Chr(10) +
  Chr(9) + 'Density Layer: "' + DensityLayer + '"' + Chr(10);
end;

function T_ANE_TriMeshLayer.WriteTemplate : string;
var
  StringIndex, CharIndex : Integer;
  AString : String;
  QuotePosition : integer;
begin
  if (Template.Count = 0)
  then
    begin
      result := ''
    end
  else
    begin
      result := Chr(10) + Chr(9) + 'Template: '
        + Chr(10) + Chr(9) + '{' + Chr(10) ;
      for StringIndex := 0 to Template.Count -1 do
      begin
        AString := Template.Strings[StringIndex];
        QuotePosition := Pos('"', AString);
        if QuotePosition > 0 then
        begin
          for CharIndex := Length(AString) downto QuotePosition do
          begin
            if Copy(AString, CharIndex, 1) = '"' then
            begin
              AString := Copy(AString, 0, CharIndex -1) + '\"'
                + Copy(AString, CharIndex +1, Length(AString));
            end;
          end;
        end;
        result := result + Chr(9) + Chr(9) + 'Line: "'
          + AString + '"' + Chr(10);
      end;
      result := result + Chr(9) + '}' + Chr(10) ;
    end;
end;

//-------------------------------------------------------------------------
{ T_ANE_QuadMeshLayer }

// T_ANE_QuadMeshLayer is used for QuadMesh layers.

// see T_ANE_MapsLayer
constructor T_ANE_QuadMeshLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer = -1);
begin
  inherited Create(ALayerList, Index);
  LayerType := 'QuadMesh';
end ;

class Function T_ANE_QuadMeshLayer.ANE_LayerName : string ;
begin
  result := 'QuadMesh';
end;

//-------------------------------------------------------------------------
{ T_ANE_GridLayer }

// T_ANE_GridLayer is used for Grid layers.

// see T_ANE_MapsLayer
constructor T_ANE_GridLayer.Create(ALayerList : T_ANE_LayerList;
  Index: Integer = -1) ;
begin
  inherited Create(ALayerList, Index);
  LayerType := 'Grid';
  BlockCenteredGrid := True;
end ;

class Function T_ANE_GridLayer.ANE_LayerName : string ;
begin
  result := 'Grid';
end;

function T_ANE_GridLayer.WriteReverseGridX(
  const CurrentModelHandle: ANE_PTR): string;
var
  Dummy : string;
begin
  if CheckArgusVersion(CurrentModelHandle,4,2,0,'e',Dummy) then
  begin
    result := Chr(9) + 'Reverse Grid X Direction: ';
    if XGridDirectionReversed then
    begin
      Result := result + 'Yes' + Chr(10);
    end
    else
    begin
      Result := result + 'No' + Chr(10);
    end;
  end
  else
  begin
    result := '';
  end;
end;

function T_ANE_GridLayer.WriteReverseGridY(
  const CurrentModelHandle: ANE_PTR): string;
var
  Dummy : string;
begin
  if CheckArgusVersion(CurrentModelHandle,4,2,0,'e',Dummy) then
  begin
    result := Chr(9) + 'Reverse Grid Y Direction: ';
    if YGridDirectionReversed then
    begin
      Result := result + 'Yes' + Chr(10);
    end
    else
    begin
      Result := result + 'No' + Chr(10);
    end;
  end
  else
  begin
    result := '';
  end;
end;

//-------------------------------------------------------------------------
{ T_ANE_ParameterList }

// Create, creates the T_ANE_ParameterList AnOwner must be either a
// T_ANE_Layer or a T_ANE_ListOfIndexedParameterLists.
constructor T_ANE_ParameterList.Create(AnOwner : TObject);
begin
  inherited Create;
  FList := TList.Create;
  if not ((AnOwner is T_ANE_Layer)
     or (AnOwner is T_ANE_ListOfIndexedParameterLists))
  then
    begin
      raise EInvalidParameterListOwner.Create('Invalid Parameter List Owner; '
        + 'Contact Pie Developer for assistance.');
    end;
  Sorted := True;
  ParameterOrder := TTestStringList.Create;
  Status := sNew;
  Owner := AnOwner;
end;

// Destroy destroys the T_ANE_ParameterList.
destructor T_ANE_ParameterList.Destroy;
var
  AParam : T_ANE_Param;
  i : integer;
begin
  for i := FList.Count -1 downto 0 do
  begin
    AParam := FList.Items[i];
    AParam.Free;
//    AParam := nil;
  end;
  FList.Free;
  ParameterOrder.Free;
  inherited Destroy;
//  self := nil;
end;

// see TList
{
function T_ANE_ParameterList.Add(Item: T_ANE_Param): Integer;
begin
  if Item.ParameterList = self
  then
    begin
      result := FList.Add(Item);
    end
  else
    begin
      Item.Free;
//      result := -1;
      raise EInvalidParameterList.Create('Incorrect Parameterlist');
    end;
end;
}

// see TList
function T_ANE_ParameterList.First: T_ANE_Param;
begin
  result := FList.First;
end;

// see TList
function T_ANE_ParameterList.IndexOf(Item: T_ANE_Param): Integer;
begin
  result := FList.IndexOf(Item);
end;

// see TList
{
procedure T_ANE_ParameterList.Insert(Index: Integer; Item: T_ANE_Param);
begin
  if Item.ParameterList = self
  then
    begin
      FList.Insert(Index, Item);
    end
  else
    begin
      Item.Free;
      raise EInvalidParameterList.Create('Incorrect Parameterlist');
    end;
end;
}

// see TList
function T_ANE_ParameterList.Last: T_ANE_Param;
begin
  result := FList.Last;
end;

{
// see TList
function T_ANE_ParameterList.Remove(Item: T_ANE_Param): Integer;
begin
  result := FList.Remove(Item);
end;
}

// WriteParameters returns a string representing all the parameters
// in the T_ANE_ParameterList that may be passed to Argus ONE.
function T_ANE_ParameterList.WriteParameters
  (const CurrentModelHandle : ANE_PTR) : string;
var
  AParam : T_ANE_Param;
  i : integer;
begin
  result := '';
  for i := 0 to FList.Count -1 do
  begin
    AParam := FList.Items[i];
    result := result + AParam.WritePar(CurrentModelHandle);
  end;
end;

procedure T_ANE_ParameterList.RestoreLock;
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  for ParamIndex := 0 to FList.Count -1 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    AT_ANE_Param.RestoreLock;
  end;
end;

// SetStatus sets the status of the T_ANE_ParameterList and all the
// parameters in it to AStatus.
procedure T_ANE_ParameterList.SetStatus(AStatus : TStatus);
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  Status := AStatus;
  for ParamIndex := 0 to FList.Count -1 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    AT_ANE_Param.FStatus := AStatus;
    AT_ANE_Param.SetExpressionNow := False;
    AT_ANE_Param.FOldRoot := AT_ANE_Param.WriteName;
  end;
end;

// FreeByStatus frees all the parameters in the T_ANE_ParameterList
// whose status is AStatus.
procedure T_ANE_ParameterList.FreeByStatus(AStatus : TStatus);
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  if Status = AStatus then
  begin
    Free;
  end
  else
  begin
    for ParamIndex := FList.Count -1 downto 0 do
    begin
      AT_ANE_Param := FList.Items[ParamIndex];
      AT_ANE_Param.FreeByStatus(AStatus);
    end;
  end;
end;

// DeleteByName calls the DeleteByName procedure of all the parameters
// in the T_ANE_ParameterList
{
procedure T_ANE_ParameterList.DeleteByName(AName : string);
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  for ParamIndex := Count -1 downto 0 do
  begin
    AT_ANE_Param := Items[ParamIndex];
    AT_ANE_Param.DeleteByName(AName);
  end;
end;
}

// RemoveDeletedParameters instructs Argus ONE to remove all parameters
// whose status is sDeleted.
procedure T_ANE_ParameterList.RemoveDeletedParameters
  (const CurrentModelHandle :ANE_PTR; const LayerHandle : ANE_PTR);
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  for ParamIndex := FList.Count -1 downto 0 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    if (AT_ANE_Param.Status = sDeleted) or (Status = sDeleted) then
    begin
      AT_ANE_Param.RemoveParameter(CurrentModelHandle, LayerHandle );
      AT_ANE_Param.Free;
    end
  end;
end;

procedure T_ANE_ParameterList.SetParameterUnits
  (const CurrentModelHandle, LayerHandle : ANE_PTR; Const UseOldIndex : boolean);
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  for ParamIndex := FList.Count -1 downto 0 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    AT_ANE_Param.SetParameterUnits(CurrentModelHandle, LayerHandle, UseOldIndex );
  end;
end;


// GetPreviousParameter returns the parameter in the parameters list
// after which it is appropriate to add AParam. If there is no such
// parameter, GetPreviousParameter returns nil.
function T_ANE_ParameterList.GetPreviousParameter
  (AParam : T_ANE_Param): T_ANE_Param;
Var
  StartParameter : integer;
  ParamIndex : integer;
  AParamInList : T_ANE_Param;
begin
  result := nil;
  StartParameter := IndexOf(AParam);
  if StartParameter = -1
  then
    begin
      StartParameter := FList.Count -1;
    end
  else
    begin
      StartParameter := StartParameter -1;
    end;
  for ParamIndex := StartParameter downto 0 do
  begin
    AParamInList := FList.Items[ParamIndex];
    if (AParamInList.Status = sNormal) then
    begin
      result := AParamInList;
      break;
    end
  end;
end;

// AddNewParameters instructs Argus ONE to add a parameter whose
// status is sNew
procedure T_ANE_ParameterList.AddNewParameters(const CurrentModelHandle :ANE_PTR;
  const LayerHandle : ANE_PTR);
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  for ParamIndex := 0 to FList.Count -1 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    if AT_ANE_Param.Status = sNew then
    begin
      AT_ANE_Param.AddNewParameter(CurrentModelHandle, LayerHandle );
    end;
  end;
end;

procedure T_ANE_ParameterList.SetLock(const CurrentModelHandle :ANE_PTR;
  const LayerHandle : ANE_PTR);
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  for ParamIndex := 0 to FList.Count -1 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    if AT_ANE_Param.Status = sNormal then
    begin
      AT_ANE_Param.SetArgusLock(CurrentModelHandle, LayerHandle );
    end;
  end;
end;

// SetNewParametersToNormal changes the status of all parameters in the
// T_ANE_ParameterList from sNew to sNormal.
procedure T_ANE_ParameterList.SetNewParametersToNormal;
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  for ParamIndex := 0 to FList.Count -1 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    if AT_ANE_Param.Status = sNew then
    begin
      AT_ANE_Param.FStatus := sNormal;
    end;
  end;
  self.Status := sNormal;
end;

procedure T_ANE_ParameterList.SetNewParametersToWritten;
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  for ParamIndex := 0 to FList.Count -1 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    if AT_ANE_Param.Status = sNew then
    begin
      AT_ANE_Param.FStatus := sWritten;
    end;
  end;
  self.Status := sWritten;
end;

procedure T_ANE_ParameterList.SetWrittenParametersToNormal;
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  for ParamIndex := 0 to FList.Count -1 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    if AT_ANE_Param.Status = sWritten then
    begin
      AT_ANE_Param.FStatus := sNormal;
    end;
  end;
  self.Status := sNormal;
end;

// ArrangeParameters arranges the parameters in the order specified in
// the ParameterOrder property.
procedure T_ANE_ParameterList.ArrangeParameters;
var
  ParamIndex{, ParamNameIndex} : integer;
//  ParameterPosition : integer;
  AT_ANE_Param : T_ANE_Param;
  SortedList : TList;
begin
  if not Sorted and (FList.Count >1) and (ParameterOrder.Count > 1) then
  begin
    SortedList := TList.Create;
    SortedList.Count := ParameterOrder.Count;
    For ParamIndex := 0 to FList.Count - 1 do
    begin
      AT_ANE_Param := FList[ParamIndex];
      SortedList.Items[ParameterOrder.IndexOf(AT_ANE_Param.ANE_ParamName)]
        := AT_ANE_Param;
    end;
    SortedList.Pack;
    FList.Free;
    FList := SortedList;
  end;
{  ParameterPosition := 0;
  for ParamNameIndex := 0 to ParameterOrder.Count -1 do
  begin
    if ParameterPosition > FList.Count -1 then
    begin
      break;
    end;
    AT_ANE_Param := FList.Items[ParameterPosition];
    if (AT_ANE_Param.ANE_ParamName = ParameterOrder.Strings[ParamNameIndex])
    then
      begin
            Inc (ParameterPosition);
      end
    else
      begin
        for ParamIndex := ParameterPosition + 1 to FList.Count -1 do
        begin
          AT_ANE_Param := FList.Items[ParamIndex];
          if (AT_ANE_Param.ANE_ParamName
                = ParameterOrder.Strings[ParamNameIndex])
             and not (ParamIndex = ParameterPosition) then
          begin
            FList.Exchange(ParamIndex, ParameterPosition);
            Inc (ParameterPosition);
            break;
          end;
        end;
      end
  end; }
end;

// SetExpressions calls the SetExpression procedure of all the parameters
// in the T_ANE_ParameterList.
procedure T_ANE_ParameterList.SetExpressions(const CurrentModelHandle :ANE_PTR;
  const LayerHandle : ANE_PTR);
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  for ParamIndex := 0 to FList.Count -1 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    if AT_ANE_Param.Status = sNormal then
    begin
      AT_ANE_Param.SetExpression(CurrentModelHandle, LayerHandle );
    end;
  end;
end;

procedure T_ANE_ParameterList.UpdateOldName;
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  for ParamIndex := 0 to FList.Count -1 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    AT_ANE_Param.UpdateOldName;
  end;
end;

procedure T_ANE_ParameterList.FixParam(const CurrentModelHandle,
  LayerHandle : ANE_PTR);
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  for ParamIndex := 0 to FList.Count -1 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    AT_ANE_Param.FixParam(CurrentModelHandle,  LayerHandle);
  end;
end;

// GetParameterByName returns the first paramter in the T_ANE_ParameterList
// whose name equals AName. If there is no such parameter, it returns nil.
function T_ANE_ParameterList.GetParameterByName(AName : string) : T_ANE_Param;
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  result := nil;
  for ParamIndex := 0 to FList.Count -1 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    if  AT_ANE_Param.ANE_ParamName = AName then
    begin
      result := AT_ANE_Param;
      break;
    end;
  end;
end;

procedure T_ANE_ParameterList.UnDeleteSelf;
begin
  case Status of
    sDeleted:
      begin
        Status := sNormal;
      end;
  end;
end;

// DeleteSelf sets the status of the T_ANE_ParameterList to sDeleted and
// calls the Delete procedure of all the parameters in the
// T_ANE_ParameterList.
procedure T_ANE_ParameterList.DeleteSelf;
begin
  Case Status of
    sNew:
      begin
        Free;
//        self := nil;
      end;
    else
      begin
        Status := sDeleted;
      end;
  end;
{  Status := sDeleted;
  for ParamIndex := FList.Count -1 downto 0 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    AT_ANE_Param.Delete;
  end;  }
end;

procedure T_ANE_ParameterList.SetAllParamUnits;
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
//  Status := sDeleted;
  for ParamIndex := FList.Count -1 downto 0 do
  begin
    AT_ANE_Param := FList.Items[ParamIndex];
    AT_ANE_Param.SetUnits := True;
  end;
end;

procedure T_ANE_ParameterList.SetParamUnits
  (AParameterType : T_ANE_ParamClass; ParameterName : string);
var
  An_ANE_Param : T_ANE_Param;
begin
   An_ANE_Param := GetParameterByName(ParameterName)
     as AParameterType;
   if An_ANE_Param <> nil then
   begin
     An_ANE_Param.SetUnits := True;
   end;
end;


procedure T_ANE_ParameterList.AddOrRemoveParameter
  (AParameterType : T_ANE_ParamClass; ParameterName : string;
   ParameterShouldBePresent : boolean);
var
  An_ANE_Param : T_ANE_Param;
begin
   An_ANE_Param := GetParameterByName(ParameterName)
            as AParameterType;
   if ParameterShouldBePresent
     then
       begin
         if (An_ANE_Param = nil)
         then
           begin
             AParameterType.Create(self, -1) ;
           end
         else
           begin
             An_ANE_Param.UnDelete
           end;
       end
     else //if ParameterShouldBePresent
       begin
         if not ( An_ANE_Param = nil) then
         begin
           An_ANE_Param.Delete;
         end;
       end; //if ParameterShouldBePresent else

end;

function T_ANE_ParameterList.GetItem(Index : Integer) : T_ANE_Param;
begin
  result := FList.Items[Index]
end;

{
Procedure T_ANE_ParameterList.SetItem(Index : Integer;
  AParameter : T_ANE_Param) ;
begin
  FList.Items[Index] := AParameter;
end;
}

function T_ANE_ParameterList.GetCount : integer;
begin
  result := FList.Count;
end;

{
procedure T_ANE_ParameterList.SetCount(ACount : integer);
begin
  FList.Count := ACount;
end;
}

procedure T_ANE_ParameterList.SetExpressionNow(
  AParameterType: T_ANE_ParamClass; ParameterName: string;
  ShouldSetExpressionNow: boolean);
var
  An_ANE_Param : T_ANE_Param;
begin
   An_ANE_Param := GetParameterByName(ParameterName)
            as AParameterType;
   if (An_ANE_Param <> nil) then
   begin
     An_ANE_Param.SetExpressionNow := ShouldSetExpressionNow;
   end;

end;

procedure T_ANE_ParameterList.RenameParameters
  (const CurrentModelHandle, LayerHandle : ANE_PTR;
  RenameAllParameters : boolean);
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  if RenameAllParameters or FNeedToUpdateParamName then
  begin
    // first rename those whose new index will be larger than
    // their old index starting with the last parameter.
    for ParamIndex := FList.Count -1 downto 0 do
    begin
      AT_ANE_Param := FList.Items[ParamIndex];
      if (AT_ANE_Param.Status = sNormal) then
      begin
        if RenameAllParameters or AT_ANE_Param.FNeedToUpdateParamName then
        begin
          AT_ANE_Param.RenameParameter(CurrentModelHandle, LayerHandle );
        end;
      end
    end;
    FNeedToUpdateParamName := False;
  end;
end;

//-------------------------------------------------------------------------
{ T_ANE_IndexedParameterList }

// see T_ANE_ParameterList; Index controls the positions of the new
// T_ANE_IndexedParameterList in AnOwner
constructor T_ANE_IndexedParameterList.Create(
  AnOwner:T_ANE_ListOfIndexedParameterLists; Position: Integer = -1);
var
  ParamListIndex : integer;
begin
  inherited Create(AnOwner);
  FRenameAllParameters := False;
  if (Position < 0) or (Position > AnOwner.Count-1) then
  begin
    AnOwner.FList.Add(self);
    Position := AnOwner.FList.Count -1;
  end
  else
  begin
    AnOwner.FList.Insert(Position, self);
  end;
  FIndex := 0;
  For ParamListIndex := 0 to Position do
  begin
    if T_ANE_Param(AnOwner.FList[ParamListIndex]).Status <> sDeleted then
    begin
      Inc(FIndex);
    end;
  end;
  FOldIndex := FIndex;
end;

// Destroy removes the T_ANE_IndexedParameterList from its Owner
// and destroys it.
destructor T_ANE_IndexedParameterList.Destroy;
var
  List : T_ANE_ListOfIndexedParameterLists;
begin
  List := Owner as T_ANE_ListOfIndexedParameterLists;
  List.FList.Remove(self);
  inherited Destroy;
end;


// if the Status of a T_ANE_IndexedParameterList is equal to AStatus,
// FreeByStatus will remove the T_ANE_IndexedParameterList from its
// T_ANE_ListOfIndexedParameterLists and free itself. Otherwise it
// will call the inherited FreeByStatus.
procedure T_ANE_IndexedParameterList.FreeByStatus(AStatus : TStatus);
begin
  if Status = AStatus then
  begin
     Free;
  end
  else
  begin
    inherited FreeByStatus(AStatus);
  end;
end;

// RenameIndexedParameters Instruct Argus One to change the names of the
// parameters in the T_ANE_IndexedParameterList from
// Name + OldIndex to Name + Index.
procedure T_ANE_IndexedParameterList.RenameParameters
  (const CurrentModelHandle, LayerHandle : ANE_PTR;
  RenameAllParameters : boolean);
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  if (Index <> OldIndex) or RenameAllParameters or FNeedToUpdateParamName then
  begin
    // first rename those whose new index will be larger than
    // their old index starting with the last parameter.
    for ParamIndex := FList.Count -1 downto 0 do
    begin
      AT_ANE_Param := FList.Items[ParamIndex];
      if (AT_ANE_Param.Status = sNormal) then
      begin
        if (Index > OldIndex) then
        begin
          AT_ANE_Param.RenameParameter(CurrentModelHandle, LayerHandle );
        end;
      end
    end;

    // next  rename those whose new index will be smaller than
    // their old index starting with the first parameter.
    for ParamIndex := 0 to FList.Count -1 do
    begin
      AT_ANE_Param := FList.Items[ParamIndex];
      if (AT_ANE_Param.Status = sNormal) then
      begin
        if RenameAllParameters or (Index < OldIndex) or
          AT_ANE_Param.FNeedToUpdateParamName then
        begin
          AT_ANE_Param.RenameParameter(CurrentModelHandle, LayerHandle );
        end;
      end
    end;
  end;
  FNeedToUpdateParamName := False;
end;

function T_ANE_IndexedParameterList.GetIndex : integer;
var
  AListOfIndexedParameterLists : T_ANE_ListOfIndexedParameterLists;
begin
  AListOfIndexedParameterLists := Owner as T_ANE_ListOfIndexedParameterLists;
  result := AListOfIndexedParameterLists.IndexOf(self);
end;

//-------------------------------------------------------------------------
{ T_ANE_ListOfIndexedParameterLists }

// Create creates the T_ANE_ListOfIndexedParameterLists and sets
// the Owner to AnOwner.

constructor T_ANE_ListOfIndexedParameterLists.Create(AnOwner : T_ANE_Layer);
begin
  inherited Create;
  Owner := AnOwner;
  FList := TList.Create;
end;

// Destroy destroys the T_ANE_ListOfIndexedParameterLists
destructor T_ANE_ListOfIndexedParameterLists.Destroy;
var
  AParamList : T_ANE_IndexedParameterList;
  i : integer;
begin
  for i := FList.Count -1 downto 0 do
  begin
    AParamList := FList.Items[i];
    AParamList.Free;
  end;
  FList.Free;
  inherited Destroy;
end;

// see TList
{
function T_ANE_ListOfIndexedParameterLists.Add
  (Item: T_ANE_IndexedParameterList): Integer;
begin
  result := FList.Add(Item);
end;
}

// see TList
function T_ANE_ListOfIndexedParameterLists.First: T_ANE_IndexedParameterList;
begin
  result := FList.First;
end;

// see TList
function T_ANE_ListOfIndexedParameterLists.IndexOf
  (Item: T_ANE_IndexedParameterList): Integer;
begin
  result := FList.IndexOf(Item);
end;

// see TList
{
procedure T_ANE_ListOfIndexedParameterLists.Insert
  (Index: Integer; Item: T_ANE_IndexedParameterList);
begin
  FList.Insert(Index, Item);
end;
}

// see TList
function T_ANE_ListOfIndexedParameterLists.Last: T_ANE_IndexedParameterList;
begin
  result := FList.Last;
end;

// see TList
{
function T_ANE_ListOfIndexedParameterLists.Remove
  (Item: T_ANE_IndexedParameterList): Integer;
begin
  result := FList.Remove(Item);
end;
}

// WriteParameters returns a string that can be passed to Argus ONE
// describing all the layers indirectly owned by the
// T_ANE_ListOfIndexedParameterLists.
function T_ANE_ListOfIndexedParameterLists.WriteParameters
  (const CurrentModelHandle : ANE_PTR) : string;
var
  AParamList : T_ANE_IndexedParameterList;
  i : integer;
begin
  result := '';
  for i := 0 to FList.Count -1 do
  begin
    AParamList := Items[i];
    result := result + AParamList.WriteParameters(CurrentModelHandle);
  end;
end;

// SetStatus calls the SetStatus procedure of all the
// T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
procedure T_ANE_ListOfIndexedParameterLists.SetStatus(AStatus : TStatus);
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.SetStatus(AStatus);
  end;
end;

// FreeByStatus calls the FreeByStatus procedure of all the
// T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
procedure T_ANE_ListOfIndexedParameterLists.FreeByStatus(AStatus : TStatus);
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := Count -1 downto 0 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.FreeByStatus(AStatus);
  end;
end;

// DeleteByName calls the DeleteByName procedure of all the
// T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
{
procedure T_ANE_ListOfIndexedParameterLists.DeleteByName(AName : string);
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := Count -1 downto 0 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.DeleteByName(AName);
  end;
end;
}

// UpdateIndicies calls the UpdateIndicies procedure of all the
// T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
procedure T_ANE_ListOfIndexedParameterLists.UpdateIndicies;
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := Count -1 downto 0 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.FIndex := ParamListIndex + 1;
  end;
end;

// UpdateOldIndicies calls the UpdateOldIndicies procedure of all the
// T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
procedure T_ANE_ListOfIndexedParameterLists.UpdateOldIndicies;
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := Count -1 downto 0 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.FOldIndex := AParamList.Index;
  end;
end;

// RemoveDeletedParameters calls the RemoveDeletedParameters procedure of all
// the T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
procedure T_ANE_ListOfIndexedParameterLists.RemoveDeletedParameters
  (const CurrentModelHandle : ANE_PTR; const LayerHandle : ANE_PTR);
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := Count -1 downto 0 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.RemoveDeletedParameters(CurrentModelHandle, LayerHandle );
  end;
end;

// RenameIndexedParameters calls the RenameIndexedParameters procedure of all
// the T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
procedure T_ANE_ListOfIndexedParameterLists.RenameParameters
  (const CurrentModelHandle, LayerHandle : ANE_PTR;
  RenameAllParameters : boolean);
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := Count -1 downto 0 do
  begin
    AParamList := Items[ParamListIndex];
    if ((AParamList.Status = sNormal)
      and (AParamList.Index > AParamList.OldIndex)) then
    begin
      AParamList.RenameParameters(CurrentModelHandle, LayerHandle,
        RenameAllParameters);
    end;
  end;
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    if (AParamList.Status = sNormal)
      and RenameAllParameters or (AParamList.Index < AParamList.OldIndex)
      then
    begin
      AParamList.RenameParameters(CurrentModelHandle, LayerHandle,
        RenameAllParameters);
    end;
  end;
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    if AParamList.FRenameAllParameters or AParamList.FNeedToUpdateParamName  then
    begin
      AParamList.RenameParameters(CurrentModelHandle, LayerHandle,
        RenameAllParameters);
      AParamList.FRenameAllParameters := False;
    end;
  end;
  FNeedToUpdateParamName := False;
end;

// GetPreviousParameter returns the parameter prior to AParam after which
// AParam may be added. AnIndexedParameterList is the
// T_ANE_IndexedParameterList containing AParam. If there is no
// appropriate parameter, GetPreviousParameter returns nil.
function T_ANE_ListOfIndexedParameterLists.GetPreviousParameter
      (AnIndexedParameterList : T_ANE_IndexedParameterList ;
      AParam : T_ANE_Param): T_ANE_Param;
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
  StartPosition : integer;
begin
  StartPosition := IndexOf(AnIndexedParameterList);
  result := nil;
  if StartPosition < 0 then
  begin
    StartPosition := Count -1;
  end;

  for ParamListIndex := StartPosition downto 0 do
  begin
    AParamList := Items[ParamListIndex];
    if not (AParamList.Status = sDeleted) then
    begin
      result := AParamList.GetPreviousParameter(AParam);
      if not (result = nil) then
      begin
        break;
      end;
    end;
  end;
end;

// AddNewParameters calls the AddNewParameters procedure of all the
// T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
procedure T_ANE_ListOfIndexedParameterLists.AddNewParameters
  (const CurrentModelHandle : ANE_PTR; const LayerHandle : ANE_PTR);
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
 for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.AddNewParameters(CurrentModelHandle, LayerHandle );
  end;
end;

procedure T_ANE_ListOfIndexedParameterLists.SetLock
  (const CurrentModelHandle : ANE_PTR; const LayerHandle : ANE_PTR);
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
 for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.SetLock(CurrentModelHandle, LayerHandle );
  end;
end;

procedure T_ANE_ListOfIndexedParameterLists.RestoreLock;
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
 for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.RestoreLock;
  end;
end;

// SetNewParametersToNormal calls the SetNewParametersToNormal procedure of all
// the T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
procedure T_ANE_ListOfIndexedParameterLists.SetNewParametersToNormal;
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.SetNewParametersToNormal;
  end;
end;

procedure T_ANE_ListOfIndexedParameterLists.SetNewParametersToWritten;
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.SetNewParametersToWritten;
  end;
end;


procedure T_ANE_ListOfIndexedParameterLists.SetWrittenParametersToNormal;
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.SetWrittenParametersToNormal;
  end;
end;


procedure T_ANE_ListOfIndexedParameterLists.SetAllParamUnits;
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.SetAllParamUnits;
  end;
end;

procedure T_ANE_ListOfIndexedParameterLists.SetParamUnits(AParameterType: T_ANE_ParamClass;
      ParameterName: string);
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.SetParamUnits(AParameterType, ParameterName);
  end;
end;

// ArrangeParameters calls the ArrangeParameters procedure of all the
// T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
procedure T_ANE_ListOfIndexedParameterLists.ArrangeParameters;
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.ArrangeParameters;
  end;
end;

// SetExpressions calls the SetExpressions procedure of all the
// T_ANE_IndexedParameterList in the T_ANE_ListOfIndexedParameterLists.
procedure T_ANE_ListOfIndexedParameterLists.SetExpressions
  (const CurrentModelHandle : ANE_PTR; const LayerHandle : ANE_PTR);
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.SetExpressions(CurrentModelHandle, LayerHandle);
  end;
end;

procedure T_ANE_ListOfIndexedParameterLists.SetParameterUnits
  (const CurrentModelHandle, LayerHandle : ANE_PTR; Const UseOldIndex : boolean);
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.SetParameterUnits(CurrentModelHandle, LayerHandle, UseOldIndex);
  end;
end;


// GetNonDeletedIndParameterListByIndex returns the
// T_ANE_IndexedParameterList whose position in the list would be
// Index if all the deleted T_ANE_IndexedParameterList's were
// removed from it.
function T_ANE_ListOfIndexedParameterLists.GetNonDeletedIndParameterListByIndex
         (Index : integer) : T_ANE_IndexedParameterList;
var
  AParameterList : T_ANE_IndexedParameterList;
  ParameterListIndex : integer;
  NonDeletedCount : integer;
begin
  result := nil;
  NonDeletedCount := -1;
  for ParameterListIndex := 0 to Count -1 do
  begin
    AParameterList := Items[ParameterListIndex];
    if not (AParameterList.Status = sDeleted)
    then
      begin
        Inc(NonDeletedCount);
      end;
    if NonDeletedCount = Index then
    begin
      result := AParameterList;
      break;
    end;
  end;
end;

// GetNonDeletedIndParameterListIndexByIndex returns the
// position in the list of the T_ANE_IndexedParameterList whose postion
// would be Index if all the deleted T_ANE_IndexedParameterList's were
// removed from it.
function T_ANE_ListOfIndexedParameterLists.
  GetNonDeletedIndParameterListIndexByIndex(Index : integer) : integer;
var
  AParameterList : T_ANE_IndexedParameterList;
  ParameterListIndex : integer;
  NonDeletedCount : integer;
begin
  result := -1;
  NonDeletedCount := -1;
  for ParameterListIndex := 0 to Count -1 do
  begin
    AParameterList := Items[ParameterListIndex];
    if not (AParameterList.Status = sDeleted)
    then
      begin
        Inc(NonDeletedCount);
      end;
    if NonDeletedCount = Index then
    begin
      result := ParameterListIndex;
      break;
    end;
  end;
end;

function T_ANE_ListOfIndexedParameterLists.GetItem(Index : Integer)
  : T_ANE_IndexedParameterList;
begin
  result := FList.Items[Index]
end;

{
Procedure T_ANE_ListOfIndexedParameterLists.SetItem(Index : Integer;
  AnIndexedParameterList : T_ANE_IndexedParameterList) ;
begin
  FList.Items[Index] := AnIndexedParameterList;
end;
}

function T_ANE_ListOfIndexedParameterLists.GetCount : integer;
begin
  result := FList.Count;
end;

{
procedure T_ANE_ListOfIndexedParameterLists.SetCount(ACount : integer);
begin
  FList.Count := ACount;
end;
}

Procedure T_ANE_ListOfIndexedParameterLists.AddParameterListToList
  (ParameterListIndex : integer ; List : TList);
begin
  if ParameterListIndex < Count then
  begin
    List.Add(GetNonDeletedIndParameterListByIndex(ParameterListIndex));
  end;
end;

procedure T_ANE_ListOfIndexedParameterLists.UpdateOldName;
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.UpdateOldName;
  end;
end;


procedure T_ANE_ListOfIndexedParameterLists.FixParam(const CurrentModelHandle,
  LayerHandle: ANE_PTR);
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.FixParam(CurrentModelHandle, LayerHandle);
  end;
end;

procedure T_ANE_ListOfIndexedParameterLists.SetExpressionNow(
  AParameterType: T_ANE_ParamClass; ParameterName: string;
  ShouldSetExpressionNow: boolean);
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  for ParamListIndex := 0 to Count -1 do
  begin
    AParamList := Items[ParamListIndex];
    AParamList.SetExpressionNow(AParameterType, ParameterName, ShouldSetExpressionNow);
  end;
end;


//-------------------------------------------------------------------------
procedure T_ANE_ListOfIndexedParameterLists.NeedToUpdateParamName;
begin
  if not FNeedToUpdateParamName then
  begin
    FNeedToUpdateParamName := True;
    Owner.NeedToUpdateParamName;
  end;
end;

procedure T_ANE_ListOfIndexedParameterLists.DontNeedToUpdateParamName;
var
  AParamList : T_ANE_IndexedParameterList;
  ParamListIndex : integer;
begin
  if FNeedToUpdateParamName then
  begin
    FNeedToUpdateParamName := False;
    for ParamListIndex := 0 to Count -1 do
    begin
      AParamList := Items[ParamListIndex];
      AParamList.DontNeedToUpdateParamName;
    end;
  end;
end;

{ T_ANE_LayerList }

constructor T_ANE_LayerList.Create(AnOwner : TObject);
begin
  inherited Create;
  FList := TList.Create;
  if not ((AnOwner is TLayerStructure)
     or (AnOwner is T_ANE_ListOfIndexedLayerLists)) then
  begin
    raise EInvalidLayerListOwner.Create('Invalid Layer List Owner; '
     + 'Contact PIE developer for assistance.');
  end;
  Sorted := True;
  LayerOrder := TTestStringList.Create;
  FStatus := sNew;
  FOwner := AnOwner;
end;

destructor T_ANE_LayerList.Destroy;
var
  ALayer : T_ANE_MapsLayer;
  i : integer;
begin
  for i := FList.Count -1 downto 0 do
  begin
    ALayer := FList.Items[i];
    ALayer.Free;
  end;
  FList.Free;
  LayerOrder.Free;
  inherited Destroy;
end;

// see TList
{
function T_ANE_LayerList.Add(Item: T_ANE_MapsLayer): Integer;
begin
  if Item.LayerList = self
  then
    begin
      result := FList.Add(Item);
    end
  else
    begin
      Item.Free;
      raise EInvalidLayerList.Create('Incorrect Layerlist');
      result := -1;
    end;
end;
}

// see TList
function T_ANE_LayerList.First: T_ANE_MapsLayer;
begin
  result := FList.First;
end;

// see TList
function T_ANE_LayerList.IndexOf(Item: T_ANE_MapsLayer): Integer;
begin
  result := FList.IndexOf(Item);
end;

// see TList
{
procedure T_ANE_LayerList.Insert(Index: Integer; Item: T_ANE_MapsLayer);
begin
  if Item.LayerList = self
  then
    begin
      FList.Insert(Index, Item);
    end
  else
    begin
      Item.Free;
      raise EInvalidLayerList.Create('Incorrect Layerlist');
    end;
end;
}

// see TList
function T_ANE_LayerList.Last: T_ANE_MapsLayer;
begin
  result := FList.Last;
end;

// see TList
{
function T_ANE_LayerList.Remove(Item: T_ANE_MapsLayer): Integer;
begin
  result := FList.Remove(Item);
end;
}

// WriteLayers returns a string that can be used in a layer template
// sent to Argus ONE to create layers.
function T_ANE_LayerList.WriteLayers(const CurrentModelHandle : ANE_PTR)
  : string;
var
  ALayer : T_ANE_MapsLayer;
  i : integer;
begin
  result := '';
  for i := 0 to Count -1 do
  begin
    ALayer := Items[i];
    result := result + ALayer.WriteLayer(CurrentModelHandle);
  end;
end;

// SetLayersStatus sets the Status of all the layers in the T_ANE_LayerList
// to AStatus. SetLayersStatus does not affect the Status of the parameters
// by any of the Layers.
procedure T_ANE_LayerList.SetLayersStatus(AStatus : TStatus);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  FStatus := AStatus;
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.FStatus := AStatus;
    ALayer.FOldRoot := ALayer.WriteLayerRoot;
  end;
end;

// SetParametersStatus sets the Status of all the parameters of all the
// layers in the T_ANE_LayerList to AStatus.
procedure T_ANE_LayerList.SetParametersStatus(AStatus : TStatus);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.SetParametersStatus(AStatus);
  end;
end;

procedure T_ANE_LayerList.SetParameterUnits(const CurrentModelHandle : ANE_PTR;
  const UseOldIndex: boolean);
var
  ALayer : T_ANE_MapsLayer;
  AParamLayer : T_ANE_Layer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    if ALayer is T_ANE_Layer then
    begin
      AParamLayer := T_ANE_Layer(ALayer);
      AParamLayer.SetParameterUnits(CurrentModelHandle,UseOldIndex);
    end;
  end;
end;

procedure T_ANE_LayerList.SetAllParamUnits;
var
  ALayer : T_ANE_MapsLayer;
  AParamLayer : T_ANE_Layer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    if ALayer is T_ANE_Layer then
    begin
      AParamLayer := T_ANE_Layer(ALayer);
      AParamLayer.SetAllParamUnits;
    end;
  end;
end;

procedure T_ANE_LayerList.SetParamUnits(AParameterType: T_ANE_ParamClass;
      ParameterName, LayerName: string);
var
  AnInfoLayer : T_ANE_InfoLayer;
//  LayerIndex : integer;
begin
  AnInfoLayer := GetLayerByName(LayerName) as T_ANE_InfoLayer;
  if AnInfoLayer <> nil then
  begin
    AnInfoLayer.SetParamUnits(AParameterType, ParameterName);
  end;
end;

// SetStatus sets the Status of all the layers and all their parameters
// to AStatus.
procedure T_ANE_LayerList.SetStatus(AStatus : TStatus);
begin
  SetLayersStatus(AStatus);
  SetParametersStatus(AStatus);
  FStatus := AStatus;
end;

// FreeByStatus calls the FreeByStatus procedure of all
// the layers in the T_ANE_LayerList.
procedure T_ANE_LayerList.FreeByStatus(AStatus : TStatus);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := Count -1 downto 0 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.FreeByStatus(AStatus);
  end;
end;

// DeleteLayersByName calls the DeleteByName procedure of all
// the layers in the T_ANE_LayerList.
{
procedure T_ANE_LayerList.DeleteLayersByName(AName : string);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := Count -1 downto 0 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.DeleteByName(AName);
  end;
end;
}

// DeleteParametersByName calls the DeleteParametersByName procedure of all
// the layers in the T_ANE_LayerList.
{procedure T_ANE_LayerList.DeleteParametersByName(AName : string);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := Count -1 downto 0 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.DeleteParametersByName(AName);
  end;
end;
}

// UpdateParameterIndicies calls the UpdateParameterIndicies procedure of all
// the layers in the T_ANE_LayerList.
procedure T_ANE_LayerList.UpdateParameterIndicies;
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := Count -1 downto 0 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.UpdateParameterIndicies;
  end;
end;

// UpdateOldParameterIndicies calls the UpdateOldParameterIndicies procedure of
// all the layers in the T_ANE_LayerList.
procedure T_ANE_LayerList.UpdateOldParameterIndicies;
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := Count -1 downto 0 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.UpdateOldParameterIndicies;
  end;
end;

// RemoveDeletedLayers calls the RemoveLayer procedure of all
// the layers in the T_ANE_LayerList whose Status is sDeleted.
procedure T_ANE_LayerList.RemoveDeletedLayers
  (const CurrentModelHandle :ANE_PTR);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := Count -1 downto 0 do
  begin
    ALayer := Items[LayerIndex];
    if (Status = sDeleted) or (ALayer.Status = sDeleted) then
    begin
      ALayer.RemoveLayer(CurrentModelHandle);
      ALayer.Free;
    end
  end;
end;

// RemoveDeletedParameters calls the RemoveDeletedParameters procedure of all
// the layers in the T_ANE_LayerList.
procedure T_ANE_LayerList.RemoveDeletedParameters
  (const CurrentModelHandle : ANE_PTR);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := Count -1 downto 0 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.RemoveDeletedParameters(CurrentModelHandle);
  end;
end;

// RenameIndexedParameters calls the RenameIndexedParameters procedure of all
// the layers in the T_ANE_LayerList.
procedure T_ANE_LayerList.RenameIndexedParameters
  (const CurrentModelHandle : ANE_PTR);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := Count -1 downto 0 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.RenameIndexedParameters(CurrentModelHandle);
  end;
  FNeedToUpdateParamName := False;
end;

// AddNewParameters calls the AddNewParameters procedure of all
// the layers in the T_ANE_LayerList.
procedure T_ANE_LayerList.AddNewParameters(const CurrentModelHandle : ANE_PTR);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.AddNewParameters(CurrentModelHandle);
  end;
end;

procedure T_ANE_LayerList.SetParamLock(const CurrentModelHandle : ANE_PTR);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.SetParamLock(CurrentModelHandle);
  end;
end;

procedure T_ANE_LayerList.RestoreParamLock;
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.RestoreParamLock;
  end;
end;

// GetPreviousLayer returns the layer after which it is appropriate to
// add ALayer in Argus ONE.
function T_ANE_LayerList.GetPreviousLayer(ALayer : T_ANE_MapsLayer)
  : T_ANE_MapsLayer;
Var
  StartLayer : integer;
  LayerIndex : integer;
  ALayerInList : T_ANE_MapsLayer;
begin
  result := nil;
  StartLayer := IndexOf(ALayer);
  if StartLayer = -1 then
  begin
    StartLayer := Count -1;
  end
  else
  begin
    StartLayer := StartLayer -1;
  end;
  for LayerIndex := StartLayer downto 0 do
  begin
    ALayerInList := Items[LayerIndex];
    if (ALayerInList.Status = sNormal) then
    begin
      result := ALayerInList;
      break;
    end
  end;
end;

// AddNewLayers calls the AddNewLayer procedure of all
// the layers in the T_ANE_LayerList.
{procedure T_ANE_LayerList.AddNewLayers(const CurrentModelHandle :ANE_PTR);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.AddNewLayer(CurrentModelHandle);
  end;
end; }

procedure T_ANE_LayerList.AddMultipleNewLayers
  (const CurrentModelHandle : ANE_PTR; var LayerTemplate : String;
   var PreviousLayer : T_ANE_MapsLayer);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.AddMultipleNewLayers( CurrentModelHandle, LayerTemplate,
      PreviousLayer);
  end;
end;

procedure T_ANE_LayerList.SetWrittenParametersToNormal;
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.SetWrittenParametersToNormal;
  end;
end;


// ArrangeParameters calls the ArrangeParameters procedure of all
// the layers in the T_ANE_LayerList.
procedure T_ANE_LayerList.ArrangeParameters;
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.ArrangeParameters;
  end;
end;

// ArrangeLayers arranges the layers in the order specified in LayerOrder
procedure T_ANE_LayerList.ArrangeLayers;
var
  LayerIndex{, LayerNameIndex} : integer;
//  LayerPosition : integer;
  ALayer : T_ANE_MapsLayer;
  SortedList : TList;
begin
  if not Sorted and (FList.Count >1) and (LayerOrder.Count > 1) then
  begin
    SortedList := TList.Create;
    SortedList.Count := LayerOrder.Count;
    For LayerIndex := 0 to FList.Count - 1 do
    begin
      ALayer := FList[LayerIndex];
      SortedList.Items[LayerOrder.IndexOf(ALayer.ANE_LayerName)]
        := ALayer;
    end;
    SortedList.Pack;
    FList.Free;
    FList := SortedList;
  end;
end;

// SetExpressions calls the SetExpressions procedure of all
// the layers in the T_ANE_LayerList.
procedure T_ANE_LayerList.SetExpressions(const CurrentModelHandle : ANE_PTR);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.SetExpressions(CurrentModelHandle);
  end;
end;

// GetLayerByName returns the first layer in the T_ANE_LayerList
// whose Name equals AName.
function T_ANE_LayerList.GetLayerByName(AName : string) : T_ANE_MapsLayer;
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  result := nil;
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    if ALayer.ANE_LayerName = AName then
    begin
      result := ALayer;
      break;
    end;
  end;
end;

// DeleteSelf sets the Status of the T_ANE_LayerList to sDeleted
procedure T_ANE_LayerList.DeleteSelf;
begin
  FStatus := sDeleted;
end;

procedure T_ANE_LayerList.UnDeleteSelf;
begin
  FStatus := sNormal;
end;

procedure T_ANE_LayerList.AddOrRemoveUnIndexedParameter
  (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
  ParameterShouldBePresent : boolean);
var
  An_ANE_Layer : T_ANE_Layer;
begin
  An_ANE_Layer := GetLayerByName(ALayerType.ANE_LayerName) as ALayerType;
  if (An_ANE_Layer = nil) and ParameterShouldBePresent
    and (Status <> sDeleted) then
  begin
    raise ELayerNotFound.Create(ALayerType.ANE_LayerName + ' does not exist. '
      + 'Contact PIE developer for assistance.');
  end;
  if An_ANE_Layer <> nil then
  begin
    An_ANE_Layer.AddOrRemoveUnIndexedParameter(AParameterType,
      ParameterShouldBePresent);
  end;
end;

procedure T_ANE_LayerList.AddOrRemoveIndexedParameter0
  (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
  ParameterShouldBePresent : boolean);
var
  An_ANE_Layer : T_ANE_Layer;
begin
  An_ANE_Layer := GetLayerByName(ALayerType.ANE_LayerName) as ALayerType;
  if (An_ANE_Layer = nil) and ParameterShouldBePresent
    and (Status <> sDeleted)  then
  begin
    raise ELayerNotFound.Create(ALayerType.ANE_LayerName + ' does not exist. '
      + 'Contact PIE developer for assistance.');
  end;
  if not (An_ANE_Layer = nil) then
  begin
    An_ANE_Layer.AddOrRemoveIndexedParameter0(AParameterType,
      ParameterShouldBePresent);
  end;
end;

procedure T_ANE_LayerList.AddOrRemoveIndexedParameter1
  (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
  ParameterShouldBePresent : boolean);
var
  An_ANE_Layer : T_ANE_Layer;
begin
  An_ANE_Layer := GetLayerByName(ALayerType.ANE_LayerName) as ALayerType;
  if (An_ANE_Layer = nil) and ParameterShouldBePresent
    and (Status <> sDeleted)  then
  begin
    raise ELayerNotFound.Create(ALayerType.ANE_LayerName + ' does not exist. '
      + 'Contact PIE developer for assistance.');
  end;
  if not (An_ANE_Layer = nil) then
  begin
    An_ANE_Layer.AddOrRemoveIndexedParameter1(AParameterType,
      ParameterShouldBePresent);
  end;
end;

procedure T_ANE_LayerList.AddOrRemoveIndexedParameter2
  (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
  ParameterShouldBePresent : boolean);
var
  An_ANE_Layer : T_ANE_Layer;
begin
  An_ANE_Layer := GetLayerByName(ALayerType.ANE_LayerName) as ALayerType;
  if (An_ANE_Layer = nil) and ParameterShouldBePresent
    and (Status <> sDeleted) then
  begin
    raise ELayerNotFound.Create(ALayerType.ANE_LayerName + ' does not exist. '
      + 'Contact PIE developer for assistance.');
  end;
  if (An_ANE_Layer <> nil) then
  begin
    An_ANE_Layer.AddOrRemoveIndexedParameter2(AParameterType,
      ParameterShouldBePresent);
  end;
end;

procedure T_ANE_LayerList.AddOrRemoveLayer(ALayerType : T_ANE_MapsLayerClass;
  LayerShouldBePresent : boolean);
var
  AMapsLayer : T_ANE_MapsLayer;
begin
   AMapsLayer := GetLayerByName(ALayerType.ANE_LayerName) as ALayerType;
   if LayerShouldBePresent
     then
       begin
         if (AMapsLayer = nil)
         then
           begin
             ALayerType.Create( self, -1) ;
           end
         else
           begin
             AMapsLayer.UnDelete
           end;
       end
     else //if LayerShouldBePresent
       begin
         if not ( AMapsLayer = nil) then
         begin
           AMapsLayer.Delete;
         end;
       end; //if LayerShouldBePresent else

end;

function T_ANE_LayerList.GetItem(Index : Integer)
  : T_ANE_MapsLayer;
begin
  result := FList.Items[Index]
end;

{
Procedure T_ANE_LayerList.SetItem(Index : Integer;
  AMapsLayer : T_ANE_MapsLayer) ;
begin
  FList.Items[Index] := AMapsLayer;
end;
}

function T_ANE_LayerList.GetCount : integer;
begin
  result := FList.Count;
end;

{
procedure T_ANE_LayerList.SetCount(ACount : integer);
begin
  FList.Count := ACount;
end;
}

Procedure T_ANE_LayerList.AddParameter1ListToList(ParameterListIndex : integer ;
  List : TList);
var
  ALayer : T_ANE_Layer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    if Items[LayerIndex] is T_ANE_Layer then
    begin
      ALayer := T_ANE_Layer(Items[LayerIndex]);
      ALayer.AddParameter1ListToList(ParameterListIndex, List )
    end;
  end;
end;

Procedure T_ANE_LayerList.AddParameter2ListToList(ParameterListIndex : integer ;
  List : TList);
var
  ALayer : T_ANE_Layer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    if Items[LayerIndex] is T_ANE_Layer then
    begin
      ALayer := T_ANE_Layer(Items[LayerIndex]);
      ALayer.AddParameter2ListToList(ParameterListIndex, List )
    end;
  end;
end;

procedure T_ANE_LayerList.UpdateOldName;
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.UpdateOldName;
  end;
end;


Procedure T_ANE_LayerList.FixLayers(const CurrentModelHandle: ANE_PTR);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    ALayer.FixLayer(CurrentModelHandle);
  end;
end;

Procedure T_ANE_LayerList.MakeIndexedList1(ALayerType: T_ANE_LayerClass;
  AnIndexedParameterType : T_ANE_IndexedParameterListClass;
  Position : integer = -1);
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetLayerByName(ALayerType.ANE_LayerName) as ALayerType;
  AnIndexedParameterType.Create( ALayer.IndexedParamList1, Position);
end;

Procedure T_ANE_LayerList.MakeIndexedList2(ALayerType: T_ANE_LayerClass;
  AnIndexedParameterType : T_ANE_IndexedParameterListClass;
  Position : integer = -1);
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetLayerByName(ALayerType.ANE_LayerName) as ALayerType;
  AnIndexedParameterType.Create( ALayer.IndexedParamList2, Position);
end;

procedure T_ANE_LayerList.SetUnIndexedExpressionNow(ALayerType: T_ANE_LayerClass;
  AParameterType: T_ANE_ParamClass; ParameterName: string;
  ShouldSetExpressionNow: boolean);
var
  An_ANE_Layer : T_ANE_Layer;
begin
  An_ANE_Layer := GetLayerByName(ALayerType.ANE_LayerName) as ALayerType;
  if (An_ANE_Layer <> nil) then
  begin
    An_ANE_Layer.SetUnIndexedExpressionNow(AParameterType, ParameterName,
      ShouldSetExpressionNow);
  end;
end;

procedure T_ANE_LayerList.SetIndexed1ExpressionNow(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass;
  ParameterName: string; ShouldSetExpressionNow: boolean);
var
  An_ANE_Layer : T_ANE_Layer;
begin
  An_ANE_Layer := GetLayerByName(ALayerType.ANE_LayerName) as ALayerType;
  if (An_ANE_Layer <> nil) then
  begin
    An_ANE_Layer.SetIndexed1ExpressionNow(AParameterType, ParameterName,
      ShouldSetExpressionNow);
  end;
end;

procedure T_ANE_LayerList.SetIndexed2ExpressionNow(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass;
  ParameterName: string; ShouldSetExpressionNow: boolean);
var
  An_ANE_Layer : T_ANE_Layer;
begin
  An_ANE_Layer := GetLayerByName(ALayerType.ANE_LayerName) as ALayerType;
  if (An_ANE_Layer <> nil) then
  begin
    An_ANE_Layer.SetIndexed2ExpressionNow(AParameterType, ParameterName,
      ShouldSetExpressionNow);
  end;
end;

procedure T_ANE_LayerList.RenameLayers
  (const CurrentModelHandle :ANE_PTR);
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
begin
{  if not (Index = OldIndex) then
  begin    }
    for LayerIndex := 0 to Count -1 do
    begin
      ALayer := Items[LayerIndex];
//      if (ALayer.Status = sNormal) then
//      begin
        ALayer.RenameLayer(CurrentModelHandle);
//      end
    end;
//  end;
//  FOldIndex := Index;
end;

procedure T_ANE_LayerList.MoveIndParam2ToParam(ParamType: T_ANE_ParamClass;
  ALayerType: T_ANE_LayerClass);
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetLayerByName(ALayerType.ANE_LayerName) as T_ANE_Layer;

  if ALayer <> nil then
  begin
    ALayer.MoveIndParam2ToParam(ParamType)
  end;

end;

procedure T_ANE_LayerList.MoveParamToIndParam2(ParamType: T_ANE_ParamClass;
  ALayerType: T_ANE_LayerClass);
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetLayerByName(ALayerType.ANE_LayerName) as T_ANE_Layer;

  if ALayer <> nil then
  begin
    ALayer.MoveParamToIndParam2(ParamType);
  end;
end;

//-------------------------------------------------------------------------
procedure T_ANE_LayerList.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;

procedure T_ANE_LayerList.MakeIndexedList0(ALayerType: T_ANE_LayerClass;
  AnIndexedParameterType: T_ANE_IndexedParameterListClass;
  Position: integer);
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetLayerByName(ALayerType.ANE_LayerName) as ALayerType;
  AnIndexedParameterType.Create( ALayer.IndexedParamList0, Position);
end;

procedure T_ANE_LayerList.MakeIndexedListNeg1(ALayerType: T_ANE_LayerClass;
  AnIndexedParameterType: T_ANE_IndexedParameterListClass;
  Position: integer);
var
  ALayer : T_ANE_Layer;
begin
  ALayer := GetLayerByName(ALayerType.ANE_LayerName) as ALayerType;
  AnIndexedParameterType.Create( ALayer.IndexedParamListNeg1, Position);
end;

procedure T_ANE_LayerList.AddParameter0ListToList(
  ParameterListIndex: integer; List: TList);
var
  ALayer : T_ANE_Layer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    if Items[LayerIndex] is T_ANE_Layer then
    begin
      ALayer := T_ANE_Layer(Items[LayerIndex]);
      ALayer.AddParameter0ListToList(ParameterListIndex, List )
    end;
  end;
end;

procedure T_ANE_LayerList.AddParameterNeg1ListToList(
  ParameterListIndex: integer; List: TList);
var
  ALayer : T_ANE_Layer;
  LayerIndex : integer;
begin
  for LayerIndex := 0 to Count -1 do
  begin
    if Items[LayerIndex] is T_ANE_Layer then
    begin
      ALayer := T_ANE_Layer(Items[LayerIndex]);
      ALayer.AddParameterNeg1ListToList(ParameterListIndex, List )
    end;
  end;
end;

{function T_ANE_LayerList.GetNonDeletedIndexOf(
  ALayer: T_ANE_MapsLayer): integer;
var
  EndPosition : integer;
  Index : integer;
  AnotherLayer : T_ANE_MapsLayer;
begin
  result := -1;
  if ALayer.Status = sDeleted then
  begin
    Exit;
  end;
  EndPosition  := IndexOf(ALayer);
  if EndPosition = -1 then
  begin
    EndPosition := Count-1;
  end;
  for Index := 0 to EndPosition do
  begin
    AnotherLayer := Items[Index];
    if AnotherLayer.Status <> sDeleted then
    begin
      Inc(Result);
    end;
  end;

end;  }

function T_ANE_LayerList.GetNonDeletedLayerByIndex
         (Index : integer) : T_ANE_MapsLayer;
var
  ALayer : T_ANE_MapsLayer;
  LayerIndex : integer;
  NonDeletedCount : integer;
begin
  result := nil;
  NonDeletedCount := -1;
  for LayerIndex := 0 to Count -1 do
  begin
    ALayer := Items[LayerIndex];
    if not (ALayer.Status = sDeleted) then
    begin
      Inc(NonDeletedCount);
    end;
    if NonDeletedCount = Index then
    begin
      result := ALayer;
      break;
    end;
  end;
end;


function T_ANE_LayerList.NonDeletedIndexOf(
  const ALayer: T_ANE_MapsLayer): integer;
var
  EndIndex: integer;
  Index: integer;
  OtherLayer: T_ANE_MapsLayer;
begin
  result := -1;
  if ALayer.Status = sDeleted then
  begin
    Exit;
  end
  else
  begin
    EndIndex := IndexOf(ALayer);
    for Index := 0 to EndIndex do
    begin
      OtherLayer := Items[Index];
      if not (OtherLayer.Status = sDeleted) then
      begin
        Inc(result);
      end;
    end;
  end;
end;

procedure T_ANE_LayerList.NeedToUpdateParamName;
begin
  if not FNeedToUpdateParamName then
  begin
    FNeedToUpdateParamName := True;
    if Owner is T_ANE_ListOfIndexedLayerLists then
    begin
      T_ANE_ListOfIndexedLayerLists(Owner).NeedToUpdateParamName;
    end;
  end;
end;

procedure T_ANE_LayerList.UpdateUnIndexedParamName(ALayerType: T_ANE_LayerClass;
  AParameterType: T_ANE_ParamClass);
var
  An_ANE_Layer : T_ANE_InfoLayer;
begin
  An_ANE_Layer := GetLayerByName(ALayerType.ANE_LayerName) as T_ANE_InfoLayer;
  if (An_ANE_Layer <> nil) then
  begin
    An_ANE_Layer.UpdateUnIndexedParamName(AParameterType);
  end;
end;

procedure T_ANE_LayerList.UpdateIndexedParameter0ParamName(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
var
  An_ANE_Layer : T_ANE_InfoLayer;
begin
  An_ANE_Layer := GetLayerByName(ALayerType.ANE_LayerName) as T_ANE_InfoLayer;
  if (An_ANE_Layer <> nil) then
  begin
    An_ANE_Layer.UpdateIndexedParameter0ParamName(AParameterType);
  end;
end;

procedure T_ANE_LayerList.UpdateIndexedParameter1ParamName(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
var
  An_ANE_Layer : T_ANE_InfoLayer;
begin
  An_ANE_Layer := GetLayerByName(ALayerType.ANE_LayerName) as T_ANE_InfoLayer;
  if (An_ANE_Layer <> nil) then
  begin
    An_ANE_Layer.UpdateIndexedParameter1ParamName(AParameterType);
  end;
end;

procedure T_ANE_LayerList.UpdateIndexedParameter2ParamName(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
var
  An_ANE_Layer : T_ANE_InfoLayer;
begin
  An_ANE_Layer := GetLayerByName(ALayerType.ANE_LayerName) as T_ANE_InfoLayer;
  if (An_ANE_Layer <> nil) then
  begin
    An_ANE_Layer.UpdateIndexedParameter2ParamName(AParameterType);
  end;
end;

procedure T_ANE_LayerList.UpdateIndexedParameterNeg1ParamName(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
var
  An_ANE_Layer : T_ANE_InfoLayer;
begin
  An_ANE_Layer := GetLayerByName(ALayerType.ANE_LayerName) as T_ANE_InfoLayer;
  if (An_ANE_Layer <> nil) then
  begin
    An_ANE_Layer.UpdateIndexedParameterNeg1ParamName(AParameterType);
  end;
end;

procedure T_ANE_LayerList.DontNeedToUpdateParamName;
var
  LayerIndex: integer;
  ALayer: T_ANE_Layer;
begin
  if FNeedToUpdateParamName then
  begin
    FNeedToUpdateParamName := False;
    for LayerIndex := 0 to Count -1 do
    begin
      if Items[LayerIndex] is T_ANE_Layer then
      begin
        ALayer := T_ANE_Layer(Items[LayerIndex]);
        ALayer.DontNeedToUpdateParamName
      end;
    end;
  end;
end;

{ T_ANE_IndexedLayerList }

procedure T_ANE_IndexedLayerList.RenameLayers
  (const CurrentModelHandle :ANE_PTR; RenameAllLayers : boolean);
begin
  if RenameAllLayers or self.RenameAllLayers or (Index <> OldIndex) then
  begin
    inherited RenameLayers(CurrentModelHandle);
    FOldIndex := Index;
  end;
end;


// Create creates the T_ANE_IndexedLayerList
constructor T_ANE_IndexedLayerList.Create(
  AnOwner : T_ANE_ListOfIndexedLayerLists; Position: Integer = -1);
var
  LayerListIndex : integer;
begin
  inherited Create(AnOwner);
  RenameAllLayers := False;
  if (Position < 0) or (Position > AnOwner.Count-1)
  then
    begin
      AnOwner.FList.Add(self);
      Position := AnOwner.FList.Count -1;
    end
  else
    begin
      AnOwner.FList.Insert(Position, self);
    end;
  FIndex := 0;
  For LayerListIndex := 0 to Position do
  begin
    if T_ANE_MapsLayer(AnOwner.FList[LayerListIndex]).Status <> sDeleted then
    begin
      Inc(FIndex);
    end;
  end;
  FOldIndex := FIndex;
end;

// Destroy will remove the T_ANE_IndexedLayerList from its
// T_ANE_ListOfIndexedLayerLists and call the inherited destroy.
destructor T_ANE_IndexedLayerList.Destroy;
var
  List : T_ANE_ListOfIndexedLayerLists;
begin
  List := Owner as T_ANE_ListOfIndexedLayerLists;
  List.FList.Remove(self);
  inherited Destroy;
end;

// if the Status of a T_ANE_IndexedLayerList is equal to AStatus,
// FreeByStatus free itself. Otherwise it
// will call the inherited FreeByStatus.
procedure T_ANE_IndexedLayerList.FreeByStatus(AStatus : TStatus);
begin
  if Status = AStatus then
  begin
     Free;
  end
  else
  begin
    inherited FreeByStatus(AStatus);
  end;
end;

// RenameIndexedLayers Instruct Argus One to change the names of the
// parameters in the T_ANE_IndexedLayerList from
// Name + OldIndex to Name + Index.

//-------------------------------------------------------------------------
function T_ANE_IndexedLayerList.NonDeletedLayerCount: integer;
var
  Index : integer;
  ALayer : T_ANE_MapsLayer;
begin
  result := 0;
  for Index := 0 to Count -1 do
  begin
    ALayer := Items[Index];
    if ALayer.Status <> sDeleted then
    begin
      Inc(result);
    end;
  end;
end;  

{ T_ANE_ListOfIndexedLayerLists }

constructor T_ANE_ListOfIndexedLayerLists.Create(AnOwner : TLayerStructure);
begin
  inherited Create;
  FOwner := AnOwner;
  FList := TList.Create;
end;


destructor T_ANE_ListOfIndexedLayerLists.Destroy;
var
  AnIndexedLayerList : T_ANE_IndexedLayerList;
  i : integer;
begin
  for i := FList.Count -1 downto 0 do
  begin
    AnIndexedLayerList := FList.Items[i];
    AnIndexedLayerList.Free;
  end;
  FList.Free;
  inherited Destroy;
end;

// see TList
{
function T_ANE_ListOfIndexedLayerLists.Add
  (Item: T_ANE_IndexedLayerList): Integer;
begin
  result := FList.Add(Item);
end;
}

// see TList
function T_ANE_ListOfIndexedLayerLists.First: T_ANE_IndexedLayerList;
begin
  result := FList.First;
end;

// see TList
function T_ANE_ListOfIndexedLayerLists.IndexOf
  (Item: T_ANE_IndexedLayerList): Integer;
begin
  result := FList.IndexOf(Item);
end;

// see TList
{
procedure T_ANE_ListOfIndexedLayerLists.Insert(Index: Integer;
  Item: T_ANE_IndexedLayerList);
begin
  FList.Insert(Index, Item);
end;
}

// see TList
function T_ANE_ListOfIndexedLayerLists.Last: T_ANE_IndexedLayerList;
begin
  result := FList.Last;
end;

// see TList
{
function T_ANE_ListOfIndexedLayerLists.Remove
  (Item: T_ANE_IndexedLayerList): Integer;
begin
  result := FList.Remove(Item);
end;
}

// WriteLayers returns a string that can be used as a layer template
// to instruct Argus ONE to create all the layers (indirectly) owned by
// the  T_ANE_ListOfIndexedLayerLists.
function T_ANE_ListOfIndexedLayerLists.WriteLayers
  (const CurrentModelHandle : ANE_PTR) : string;
var
  AnIndexedLayerList : T_ANE_IndexedLayerList;
  i : integer;
begin
  result := '';
  for i := 0 to Count -1 do
  begin
    AnIndexedLayerList := Items[i];
    result := result + AnIndexedLayerList.WriteLayers(CurrentModelHandle);
  end;
end;

// SetLayersStatus calls the SetLayersStatus procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists and
// sets the status of all the T_ANE_IndexedLayerList to AStatus.
procedure T_ANE_ListOfIndexedLayerLists.SetLayersStatus(AStatus : TStatus);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.SetLayersStatus(AStatus);
    ALayerList.FStatus := AStatus;
  end;
end;

// SetParametersStatus calls the SetParametersStatus procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.SetParametersStatus(AStatus : TStatus);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.SetParametersStatus(AStatus);
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.SetParameterUnits(const CurrentModelHandle : ANE_PTR;
  const UseOldIndex: boolean);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.SetParameterUnits(CurrentModelHandle, UseOldIndex);
  end;
end;


// SetStatus calls SetLayersStatus and SetParametersStatus
procedure T_ANE_ListOfIndexedLayerLists.SetStatus(AStatus : TStatus);
begin
  SetLayersStatus(AStatus);
  SetParametersStatus(AStatus);
end;

// FreeByStatus calls the FreeByStatus procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.FreeByStatus(AStatus : TStatus);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := Count -1 downto 0 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.FreeByStatus(AStatus);
  end;
end;

// DeleteLayersByName calls the DeleteLayersByName procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
{
procedure T_ANE_ListOfIndexedLayerLists.DeleteLayersByName(AName : string);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := Count -1 downto 0 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.DeleteLayersByName(AName);
  end;
end;
}

// DeleteParametersByName calls the DeleteParametersByName procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
{
procedure T_ANE_ListOfIndexedLayerLists.DeleteParametersByName(AName : string);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := Count -1 downto 0 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.DeleteParametersByName(AName);
  end;
end;
}

// UpdateLayerIndicies calls the UpdateLayerIndicies procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.UpdateLayerIndicies;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := Count -1 downto 0 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.FIndex := LayerListIndex + 1;
  end;
end;

// UpdateParameterIndicies calls the UpdateParameterIndicies procedure of all
// the T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.UpdateParameterIndicies;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := Count -1 downto 0 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.UpdateParameterIndicies;
  end;
end;

// UpdateIndicies calls UpdateLayerIndicies and UpdateParameterIndicies.
procedure T_ANE_ListOfIndexedLayerLists.UpdateIndicies;
begin
  UpdateLayerIndicies;
  UpdateParameterIndicies;
end;

// UpdateOldLayerIndicies calls the UpdateOldLayerIndicies procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.UpdateOldLayerIndicies;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := Count -1 downto 0 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.FOldIndex := ALayerList.Index;
  end;
end;

// UpdateOldParameterIndicies calls the UpdateOldParameterIndicies procedure of
// all the T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.UpdateOldParameterIndicies;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := Count -1 downto 0 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.UpdateOldParameterIndicies;
  end;
end;

// UpdateOldIndicies calls UpdateOldLayerIndicies and
// UpdateOldParameterIndicies.
procedure T_ANE_ListOfIndexedLayerLists.UpdateOldIndicies;
begin
  UpdateOldLayerIndicies;
  UpdateOldParameterIndicies;
end;

// RemoveDeletedLayers calls the RemoveDeletedLayers procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.RemoveDeletedLayers
  (const CurrentModelHandle : ANE_PTR);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := Count -1 downto 0 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.RemoveDeletedLayers(CurrentModelHandle);
  end;
end;

// RenameIndexedLayers calls the RenameIndexedLayers procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.RenameLayers
  (const CurrentModelHandle : ANE_PTR; RenameAllLayers : boolean);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := Count -1 downto  0 do
  begin
    ALayerList := Items[LayerListIndex];
    if ALayerList.Index > ALayerList.OldIndex then
    begin
      ALayerList.RenameLayers(CurrentModelHandle, RenameAllLayers );
    end;
  end;
  for LayerListIndex :=  0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
{    if ALayerList.Index < ALayerList.OldIndex then
    begin   }
      ALayerList.RenameLayers(CurrentModelHandle, RenameAllLayers );
//    end;
  end;
end;

// GetIndexedLayerListByName returns the first T_ANE_IndexedLayerList in
// the T_ANE_ListOfIndexedLayerLists whose Name is AName.
function T_ANE_ListOfIndexedLayerLists.GetIndexedLayerListByName(AName : string)
          : T_ANE_IndexedLayerList;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  result := nil;
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    if (ALayerList.Name = AName) and not (ALayerList.Status = sDeleted) then
    begin
      result := ALayerList;
      break;
    end;
  end;
end;

// RemoveDeletedParameters calls the RemoveDeletedParameters procedure of all
// the T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.RemoveDeletedParameters
  (const CurrentModelHandle : ANE_PTR);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.RemoveDeletedParameters(CurrentModelHandle);
  end;
end;

// RenameIndexedParameters calls the RenameIndexedParameters procedure of all
// the T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.RenameIndexedParameters
  (const CurrentModelHandle : ANE_PTR);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.RenameIndexedParameters(CurrentModelHandle);
  end;
  FNeedToUpdateParamName := False;
end;

// AddNewParameters calls the AddNewParameters procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.AddNewParameters
  (const CurrentModelHandle : ANE_PTR);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.AddNewParameters(CurrentModelHandle)
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.SetParamLock
  (const CurrentModelHandle : ANE_PTR);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.SetParamLock(CurrentModelHandle)
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.RestoreParamLock;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.RestoreParamLock;
  end;
end;

// GetPreviousLayer returns the layer indirectly owned by the
// T_ANE_ListOfIndexedLayerLists prior to ALayer after which it is
// appropriate to add ALayer. AnIndexedLayerList is the
// T_ANE_IndexedLayerList containing ALayer.
function T_ANE_ListOfIndexedLayerLists.GetPreviousLayer
      (AnIndexedLayerList : T_ANE_IndexedLayerList ;
      ALayer : T_ANE_MapsLayer): T_ANE_MapsLayer;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
  StartPosition : integer;
begin
  StartPosition := IndexOf(AnIndexedLayerList);
  result := nil;
  if (StartPosition = -1) then
  begin
    StartPosition := Count -1;
  end;
  for LayerListIndex := StartPosition downto 0 do
  begin
    ALayerList := Items[LayerListIndex];
//    if ALayerList.Status = sNormal then
//    begin
      result := ALayerList.GetPreviousLayer(ALayer);
      if not (result = nil) then
      begin
        break;
      end;
//    end;
  end;
end;

// AddNewLayers calls the AddNewLayers procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
{procedure T_ANE_ListOfIndexedLayerLists.AddNewLayers
  (const CurrentModelHandle : ANE_PTR);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.AddNewLayers(CurrentModelHandle);
  end;
end; }

procedure T_ANE_ListOfIndexedLayerLists.AddMultipleNewLayers
  (const CurrentModelHandle : ANE_PTR; var  LayerTemplate : String;
   var PreviousLayer : T_ANE_MapsLayer);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.AddMultipleNewLayers( CurrentModelHandle, LayerTemplate,
      PreviousLayer);
  end;
end;


procedure T_ANE_ListOfIndexedLayerLists.SetWrittenParametersToNormal;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.SetWrittenParametersToNormal;
  end;
end;


// ArrangeParameters calls the ArrangeParameters procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.ArrangeParameters;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.ArrangeParameters;
  end;
end;

// ArrangeLayers calls the ArrangeLayers procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.ArrangeLayers;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.ArrangeLayers;
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.SetAllParamUnits;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.SetAllParamUnits;
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.SetParamUnits(AParameterType: T_ANE_ParamClass;
      ParameterName, LayerName: string);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.SetParamUnits(AParameterType, ParameterName, LayerName);
  end;
end;

// SetExpressions calls the SetExpressions procedure of all the
// T_ANE_IndexedLayerList's in the T_ANE_ListOfIndexedLayerLists.
procedure T_ANE_ListOfIndexedLayerLists.SetExpressions
  (const CurrentModelHandle : ANE_PTR);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.SetExpressions(CurrentModelHandle);
  end;
end;

// GetNonDeletedIndLayerListByIndex returns the
// position in the list of the T_ANE_IndexedLayerList whose postion
// would be Index if all the deleted T_ANE_IndexedLayerList's were
// removed from it.
function T_ANE_ListOfIndexedLayerLists.GetNonDeletedIndLayerListByIndex
         (Index : integer) : T_ANE_IndexedLayerList;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
  NonDeletedCount : integer;
begin
  result := nil;
  NonDeletedCount := -1;
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    if not (ALayerList.Status = sDeleted) then
    begin
      Inc(NonDeletedCount);
    end;
    if NonDeletedCount = Index then
    begin
      result := ALayerList;
      break;
    end;
  end;
end;

// GetNonDeletedIndLayerListIndexByIndex returns the
// position in the list of the T_ANE_IndexedLayerList whose postion
// would be Index if all the deleted T_ANE_IndexedLayerList's were
// removed from it.
function T_ANE_ListOfIndexedLayerLists.GetNonDeletedIndLayerListIndexByIndex
         (Index : integer) : integer;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
  NonDeletedCount : integer;
begin
  result := -1;
  NonDeletedCount := -1;
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    if not (ALayerList.Status = sDeleted) then
    begin
      Inc(NonDeletedCount);
    end;
    if NonDeletedCount = Index then
    begin
      result := LayerListIndex;
      break;
    end;
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.AddOrRemoveUnIndexedParameter
      (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
       ParameterShouldBePresent : boolean);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.AddOrRemoveUnIndexedParameter
      (ALayerType , AParameterType ,
       ParameterShouldBePresent );
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.AddOrRemoveIndexedParameter0
      (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
       ParameterShouldBePresent : boolean);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.AddOrRemoveIndexedParameter0
      (ALayerType , AParameterType ,
        ParameterShouldBePresent );
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.AddOrRemoveIndexedParameter1
      (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
       ParameterShouldBePresent : boolean);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.AddOrRemoveIndexedParameter1
      (ALayerType , AParameterType ,
        ParameterShouldBePresent );
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.AddOrRemoveIndexedParameter2
      (ALayerType : T_ANE_LayerClass; AParameterType : T_ANE_ParamClass;
       ParameterShouldBePresent : boolean);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.AddOrRemoveIndexedParameter2
      (ALayerType , AParameterType ,
       ParameterShouldBePresent );
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.AddOrRemoveLayer
  (ALayerType : T_ANE_MapsLayerClass;
           LayerShouldBePresent : boolean);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.AddOrRemoveLayer(ALayerType ,
           LayerShouldBePresent );
  end;
end;

function T_ANE_ListOfIndexedLayerLists.GetItem
  (Index : Integer)  : T_ANE_IndexedLayerList;
begin
  result := FList.Items[Index]
end;

{
Procedure T_ANE_ListOfIndexedLayerLists.SetItem(Index : Integer;
  AnIndexedLayerList : T_ANE_IndexedLayerList) ;
begin
  FList.Items[Index] := AnIndexedLayerList;
end;
}

function T_ANE_ListOfIndexedLayerLists.GetCount : integer;
begin
  result := FList.Count;
end;

{
procedure T_ANE_ListOfIndexedLayerLists.SetCount(ACount : integer);
begin
  FList.Count := ACount;
end;
}

Procedure T_ANE_ListOfIndexedLayerLists.AddParameter1ListToList
  (ParameterListIndex : integer ;  List : TList);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.AddParameter1ListToList(ParameterListIndex, List) ;
  end;
end;

Procedure T_ANE_ListOfIndexedLayerLists.AddParameter2ListToList
  (ParameterListIndex : integer ; List : TList);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.AddParameter2ListToList(ParameterListIndex, List) ;
  end;
end;

Procedure T_ANE_ListOfIndexedLayerLists.UpdateOldName;
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.UpdateOldName;
  end;
end;


Procedure T_ANE_ListOfIndexedLayerLists.FixLayers
  (const CurrentModelHandle: ANE_PTR);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.FixLayers(CurrentModelHandle);
  end;
end;

Procedure T_ANE_ListOfIndexedLayerLists.MakeIndexedList1(
   ALayerType: T_ANE_LayerClass;
   AnIndexedParameterType : T_ANE_IndexedParameterListClass;
   Position : integer = -1);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.MakeIndexedList1( ALayerType, AnIndexedParameterType, Position);
  end;
end;

Procedure T_ANE_ListOfIndexedLayerLists.MakeIndexedList2(
   ALayerType: T_ANE_LayerClass;
   AnIndexedParameterType : T_ANE_IndexedParameterListClass;
   Position : integer = -1);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.MakeIndexedList2( ALayerType, AnIndexedParameterType, Position);
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.SetUnIndexedExpressionNow(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass;
  ParameterName: string; ShouldSetExpressionNow: boolean);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.SetUnIndexedExpressionNow(ALayerType, AParameterType,
      ParameterName, ShouldSetExpressionNow);
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.SetIndexed1ExpressionNow(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass;
  ParameterName: string; ShouldSetExpressionNow: boolean);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.SetIndexed1ExpressionNow(ALayerType, AParameterType,
      ParameterName, ShouldSetExpressionNow);
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.SetIndexed2ExpressionNow(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass;
  ParameterName: string; ShouldSetExpressionNow: boolean);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.SetIndexed2ExpressionNow(ALayerType, AParameterType,
      ParameterName, ShouldSetExpressionNow);
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.MoveIndParam2ToParam(
  ParamType: T_ANE_ParamClass; ALayerType: T_ANE_LayerClass);
var
  Index : integer;
  ALayerList : T_ANE_IndexedLayerList;
begin
  for Index := 0 to Count -1 do
  begin
    ALayerList := FList[Index];
    ALayerList.MoveIndParam2ToParam(ParamType,ALayerType);
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.MoveParamToIndParam2(
  ParamType: T_ANE_ParamClass; ALayerType: T_ANE_LayerClass);
var
  Index : integer;
  ALayerList : T_ANE_IndexedLayerList;
begin
  for Index := 0 to Count -1 do
  begin
    ALayerList := FList[Index];
    ALayerList.MoveParamToIndParam2(ParamType,ALayerType);
  end;
end;

//-------------------------------------------------------------------------
{ TLayerStructure }

// Create creates the layer structure in the PIE but does not instruct Argus
// ONE to create a related set of layers.
constructor TLayerStructure.Create;
begin
  inherited Create;
  RenameAllLayers := False;
  UnIndexedLayers0 := T_ANE_LayerList.Create(self);
  ZerothListsOfIndexedLayers := T_ANE_ListOfIndexedLayerLists.Create(self);
  IntermediateUnIndexedLayers := T_ANE_LayerList.Create(self);
  UnIndexedLayers := T_ANE_LayerList.Create(self);
  UnIndexedLayers2 := T_ANE_LayerList.Create(self);
  UnIndexedLayers3 := T_ANE_LayerList.Create(self);
  FirstListsOfIndexedLayers := T_ANE_ListOfIndexedLayerLists.Create(self);
  ListsOfIndexedLayers := T_ANE_ListOfIndexedLayerLists.Create(self);
  PostProcessingLayers := T_ANE_LayerList.Create(self);
end;

// Destroy destroys the layer structure in the PIE and everything in it
// including all layers, parameters, etc.
destructor TLayerStructure.Destroy;
begin
  UnIndexedLayers0.Free;
  ZerothListsOfIndexedLayers.Free;
  IntermediateUnIndexedLayers.Free;
  UnIndexedLayers.Free;
  UnIndexedLayers2.Free;
  UnIndexedLayers3.Free;
  FirstListsOfIndexedLayers.Free;
  ListsOfIndexedLayers.Free;
  PostProcessingLayers.Free;
  inherited Destroy;
//  self := nil;
end;

// WriteLayers writes a string that can be passed to Argus ONE as a layer
// structure template. (You must cast it to a PChar first.)
function TLayerStructure.WriteLayers(const CurrentModelHandle : ANE_PTR)
  : string;
begin
  FreeByStatus(sDeleted);
  UpdateIndicies;
  UpdateOldIndicies;
  ArrangeLayers;
  ArrangeParameters;
  result :=
    UnIndexedLayers0.WriteLayers(CurrentModelHandle) +
    ZerothListsOfIndexedLayers.WriteLayers(CurrentModelHandle) +
    UnIndexedLayers.WriteLayers(CurrentModelHandle) +
    UnIndexedLayers2.WriteLayers(CurrentModelHandle) +
    UnIndexedLayers3.WriteLayers(CurrentModelHandle) +
    FirstListsOfIndexedLayers.WriteLayers(CurrentModelHandle) +
    IntermediateUnIndexedLayers.WriteLayers(CurrentModelHandle) +
    ListsOfIndexedLayers.WriteLayers(CurrentModelHandle) +
    PostProcessingLayers.WriteLayers(CurrentModelHandle);
end;

// SetLayersStatus calls the SetLayersStatus procedures of
// UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
// resulting in all layers in the TLayerStructure being assigned a
// Status of AStatus.
{
procedure TLayerStructure.SetLayersStatus(AStatus : TStatus);
begin
  UnIndexedLayers.SetLayersStatus(AStatus);
  ListsOfIndexedLayers.SetLayersStatus(AStatus);
  PostProcessingLayers.SetLayersStatus(AStatus);
end;
}

// SetParametersStatus calls the SetParametersStatus procedures of
// UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
// resulting in all parameters in all the layers in the TLayerStructure
// being assigned a Status of AStatus.
{
procedure TLayerStructure.SetParametersStatus(AStatus : TStatus);
begin
  UnIndexedLayers.SetParametersStatus(AStatus);
  ListsOfIndexedLayers.SetParametersStatus(AStatus);
  PostProcessingLayers.SetParametersStatus(AStatus);
end;
}

// Call SetStatus to set the status of everything to sNormal after passing
// a layerstructure template to Argus ONE.
// SetStatus sets the Status of all layers, parameters, etc. to AStatus.
procedure TLayerStructure.SetStatus(AStatus : TStatus);
begin
  UnIndexedLayers0.SetStatus(AStatus);
  ZerothListsOfIndexedLayers.SetStatus(AStatus);
  IntermediateUnIndexedLayers.SetStatus(AStatus);
  UnIndexedLayers.SetStatus(AStatus);
  UnIndexedLayers2.SetStatus(AStatus);
  UnIndexedLayers3.SetStatus(AStatus);
  FirstListsOfIndexedLayers.SetStatus(AStatus);
  ListsOfIndexedLayers.SetStatus(AStatus);
  PostProcessingLayers.SetStatus(AStatus);
end;

// FreeByStatus calls the FreeByStatus procedures of
// UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
// resulting in the Freeing of all layers and parameters in all the layers
// in the TLayerStructure that have a Status of AStatus.
procedure TLayerStructure.FreeByStatus(AStatus : TStatus);
begin
  UnIndexedLayers0.FreeByStatus(AStatus);
  ZerothListsOfIndexedLayers.FreeByStatus(AStatus);
  IntermediateUnIndexedLayers.FreeByStatus(AStatus);
  UnIndexedLayers.FreeByStatus(AStatus);
  UnIndexedLayers2.FreeByStatus(AStatus);
  UnIndexedLayers3.FreeByStatus(AStatus);
  FirstListsOfIndexedLayers.FreeByStatus(AStatus);
  ListsOfIndexedLayers.FreeByStatus(AStatus);
  PostProcessingLayers.FreeByStatus(AStatus);
end;

// DeleteLayersByName calls the DeleteLayersByName procedures of
// UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
// resulting in a call to the DeleteByName procedure of all layers in
// the TLayerStructure. Any layer whose Name equals AName will be Freed
// if its status is sNew. Otherwise, its Status will be changed to
// sDeleted.
{
procedure TLayerStructure.DeleteLayersByName(AName : string);
begin
  UnIndexedLayers.DeleteLayersByName(AName);
  ListsOfIndexedLayers.DeleteLayersByName(AName);
  PostProcessingLayers.DeleteLayersByName(AName);
end;
}

// DeleteParametersByName calls the DeleteParametersByName procedures of
// UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
// resulting in a call to the DeleteByName procedure of all the parameters
// in all the layers in
// the TLayerStructure. Any parameter whose Name equals AName will be Freed
// if its status is sNew. Otherwise, its Status will be changed to
// sDeleted.
{
procedure TLayerStructure.DeleteParametersByName(AName : string);
begin
  UnIndexedLayers.DeleteParametersByName(AName);
  ListsOfIndexedLayers.DeleteParametersByName(AName);
  PostProcessingLayers.DeleteParametersByName(AName);
end;
}

// UpdateParameterIndicies is called after all the deleted parameters have
// been removed from Argus ONE. This is in preparation for renaming the
// remaining indexed parameters.
{
procedure TLayerStructure.UpdateParameterIndicies;
begin
  UnIndexedLayers.UpdateParameterIndicies;
  ListsOfIndexedLayers.UpdateParameterIndicies;
  PostProcessingLayers.UpdateParameterIndicies;
end;
}

// Update Indicies should be called in the Create procedure of any descendent
// of TLayerStructure after all layers in the layer structure have been added.
// UpdateIndicies sets the Index's in all
// T_ANE_IndexedLayerList's and T_ANE_IndexedParameterList's in the
// TLayerStructure to one larger
// than their position in their T_ANE_ListOfIndexedLayerLists and
// T_ANE_ListOfIndexedParameterLists respectively.
procedure TLayerStructure.UpdateIndicies;
begin
  UnIndexedLayers0.UpdateParameterIndicies;
  ZerothListsOfIndexedLayers.UpdateIndicies;
  IntermediateUnIndexedLayers.UpdateParameterIndicies;
  UnIndexedLayers.UpdateParameterIndicies;
  UnIndexedLayers2.UpdateParameterIndicies;
  UnIndexedLayers3.UpdateParameterIndicies;
  FirstListsOfIndexedLayers.UpdateIndicies;
  ListsOfIndexedLayers.UpdateIndicies;
  PostProcessingLayers.UpdateParameterIndicies;
end;

// UpdateOldParameterIndicies is called after all the indexed parameters
// have had their names updated. UpdateOldParameterIndicies results in the
// OldIndex's of all the T_ANE_IndexedParameterList's being set equal to
// the Index of those T_ANE_IndexedParameterList.
{
procedure TLayerStructure.UpdateOldParameterIndicies;
begin
  UnIndexedLayers.UpdateOldParameterIndicies;
  ListsOfIndexedLayers.UpdateOldParameterIndicies;
  PostProcessingLayers.UpdateOldParameterIndicies;
end;
}

// UpdateOldIndicies should be called in the Create procedure
// of any descendent of TLayerStructure after calling UpdateIndicies
// UpdateOldIndicies sets the OldIndex equal to the Index in all
// T_ANE_IndexedLayerList's and T_ANE_IndexedParameterList's in the
// TLayerStructure.
procedure TLayerStructure.UpdateOldIndicies;
begin
  UnIndexedLayers0.UpdateOldParameterIndicies;
  ZerothListsOfIndexedLayers.UpdateOldIndicies;
  IntermediateUnIndexedLayers.UpdateOldParameterIndicies;
  UnIndexedLayers.UpdateOldParameterIndicies;
  UnIndexedLayers2.UpdateOldParameterIndicies;
  UnIndexedLayers3.UpdateOldParameterIndicies;
  FirstListsOfIndexedLayers.UpdateOldIndicies;
  ListsOfIndexedLayers.UpdateOldIndicies;
  PostProcessingLayers.UpdateOldParameterIndicies;
end;

// RemoveDeletedLayers calls the RemoveDeletedLayers procedures of
// UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
// resulting in a call to the RemoveLayer procedure of all layers in
// the TLayerStructure whose Status is sDeleted. This instructs Argus
// ONE to remove all such layers.
procedure TLayerStructure.RemoveDeletedLayers
  (const CurrentModelHandle : ANE_PTR);
begin
  UnIndexedLayers0.RemoveDeletedLayers(CurrentModelHandle);
  ZerothListsOfIndexedLayers.RemoveDeletedLayers(CurrentModelHandle);
  IntermediateUnIndexedLayers.RemoveDeletedLayers(CurrentModelHandle);
  UnIndexedLayers.RemoveDeletedLayers(CurrentModelHandle);
  UnIndexedLayers2.RemoveDeletedLayers(CurrentModelHandle);
  UnIndexedLayers3.RemoveDeletedLayers(CurrentModelHandle);
  FirstListsOfIndexedLayers.RemoveDeletedLayers(CurrentModelHandle);
  ListsOfIndexedLayers.RemoveDeletedLayers(CurrentModelHandle);
  PostProcessingLayers.RemoveDeletedLayers(CurrentModelHandle);
end;

// RenameIndexedLayers calls the RenameIndexedLayers procedure of
// ListsOfIndexedLayers resulting in all indexed layers in the layer
// structure having their names updated following removal of deleted layers.
procedure TLayerStructure.RenameLayers
  (const CurrentModelHandle : ANE_PTR);
begin
  if RenameAllLayers then
  begin
    UnindexedLayers0.RenameLayers(CurrentModelHandle);
  end;
  ZerothListsOfIndexedLayers.RenameLayers(CurrentModelHandle, RenameAllLayers);
  if RenameAllLayers then
  begin
    IntermediateUnIndexedLayers.RenameLayers(CurrentModelHandle);
    UnindexedLayers.RenameLayers(CurrentModelHandle);
    UnindexedLayers2.RenameLayers(CurrentModelHandle);
    UnindexedLayers3.RenameLayers(CurrentModelHandle);
  end;
  FirstListsOfIndexedLayers.RenameLayers(CurrentModelHandle, RenameAllLayers);
  ListsOfIndexedLayers.RenameLayers(CurrentModelHandle, RenameAllLayers);
  if RenameAllLayers then
  begin
    PostProcessingLayers.RenameLayers(CurrentModelHandle);
  end;
end;

// RemoveDeletedParameters instructs Argus ONE to remove all parameters
// whose Status is sDeleted.
procedure TLayerStructure.RemoveDeletedParameters
  (const CurrentModelHandle : ANE_PTR);
begin
  UnIndexedLayers0.RemoveDeletedParameters(CurrentModelHandle);
  ZerothListsOfIndexedLayers.RemoveDeletedParameters(CurrentModelHandle);
  IntermediateUnIndexedLayers.RemoveDeletedParameters(CurrentModelHandle);
  UnIndexedLayers.RemoveDeletedParameters(CurrentModelHandle);
  UnIndexedLayers2.RemoveDeletedParameters(CurrentModelHandle);
  UnIndexedLayers3.RemoveDeletedParameters(CurrentModelHandle);
  FirstListsOfIndexedLayers.RemoveDeletedParameters(CurrentModelHandle);
  ListsOfIndexedLayers.RemoveDeletedParameters(CurrentModelHandle);
  PostProcessingLayers.RemoveDeletedParameters(CurrentModelHandle);
end;

procedure TLayerStructure.DontNeedToUpdateParamName;
begin
  UnIndexedLayers0.DontNeedToUpdateParamName;
  ZerothListsOfIndexedLayers.DontNeedToUpdateParamName;
  IntermediateUnIndexedLayers.DontNeedToUpdateParamName;
  UnIndexedLayers.DontNeedToUpdateParamName;
  UnIndexedLayers2.DontNeedToUpdateParamName;
  UnIndexedLayers3.DontNeedToUpdateParamName;
  FirstListsOfIndexedLayers.DontNeedToUpdateParamName;
  ListsOfIndexedLayers.DontNeedToUpdateParamName;
  PostProcessingLayers.DontNeedToUpdateParamName;
end;

// RenameIndexedParameters instructs Argus ONE to rename indexed parameters
// whose indicies have changed.
procedure TLayerStructure.RenameIndexedParameters
  (const CurrentModelHandle : ANE_PTR);
begin
  UnIndexedLayers0.RenameIndexedParameters(CurrentModelHandle);
  ZerothListsOfIndexedLayers.RenameIndexedParameters(CurrentModelHandle);
  IntermediateUnIndexedLayers.RenameIndexedParameters(CurrentModelHandle);
  UnIndexedLayers.RenameIndexedParameters(CurrentModelHandle);
  UnIndexedLayers2.RenameIndexedParameters(CurrentModelHandle);
  UnIndexedLayers3.RenameIndexedParameters(CurrentModelHandle);
  FirstListsOfIndexedLayers.RenameIndexedParameters(CurrentModelHandle);
  ListsOfIndexedLayers.RenameIndexedParameters(CurrentModelHandle);
  PostProcessingLayers.RenameIndexedParameters(CurrentModelHandle);
end;

// AddNewParameters instructs Argus ONE to add all parameters whose Status
// is sNew
procedure TLayerStructure.AddNewParameters(const CurrentModelHandle : ANE_PTR);
begin
  UnIndexedLayers0.AddNewParameters(CurrentModelHandle);
  ZerothListsOfIndexedLayers.AddNewParameters(CurrentModelHandle);
  IntermediateUnIndexedLayers.AddNewParameters(CurrentModelHandle);
  UnIndexedLayers.AddNewParameters(CurrentModelHandle);
  UnIndexedLayers2.AddNewParameters(CurrentModelHandle);
  UnIndexedLayers3.AddNewParameters(CurrentModelHandle);
  FirstListsOfIndexedLayers.AddNewParameters(CurrentModelHandle);
  ListsOfIndexedLayers.AddNewParameters(CurrentModelHandle);
  PostProcessingLayers.AddNewParameters(CurrentModelHandle);
end;

procedure TLayerStructure.RestoreParamLock;
begin
  UnIndexedLayers0.RestoreParamLock;
  ZerothListsOfIndexedLayers.RestoreParamLock;
  IntermediateUnIndexedLayers.RestoreParamLock;
  UnIndexedLayers.RestoreParamLock;
  UnIndexedLayers2.RestoreParamLock;
  UnIndexedLayers3.RestoreParamLock;
  FirstListsOfIndexedLayers.RestoreParamLock;
  ListsOfIndexedLayers.RestoreParamLock;
  PostProcessingLayers.RestoreParamLock;
end;

procedure TLayerStructure.SetParamLock(const CurrentModelHandle : ANE_PTR);
begin
  UnIndexedLayers0.SetParamLock(CurrentModelHandle);
  ZerothListsOfIndexedLayers.SetParamLock(CurrentModelHandle);
  IntermediateUnIndexedLayers.SetParamLock(CurrentModelHandle);
  UnIndexedLayers.SetParamLock(CurrentModelHandle);
  UnIndexedLayers2.SetParamLock(CurrentModelHandle);
  UnIndexedLayers3.SetParamLock(CurrentModelHandle);
  FirstListsOfIndexedLayers.SetParamLock(CurrentModelHandle);
  ListsOfIndexedLayers.SetParamLock(CurrentModelHandle);
  PostProcessingLayers.SetParamLock(CurrentModelHandle);
end;

// AddNewLayers instructs Argus ONE to add all layers whose Status
// is sNew
{procedure TLayerStructure.AddNewLayers(const CurrentModelHandle : ANE_PTR);
begin
  UnIndexedLayers.AddNewLayers(CurrentModelHandle);
  FirstListsOfIndexedLayers.AddNewLayers(CurrentModelHandle);
  ListsOfIndexedLayers.AddNewLayers(CurrentModelHandle);
  PostProcessingLayers.AddNewLayers(CurrentModelHandle);
end; }

procedure TLayerStructure.AddMultipleNewLayers(const CurrentModelHandle : ANE_PTR);
var
  LayerTemplate : String;
  PreviousLayer : T_ANE_MapsLayer;
  PreviousLayerHandle : ANE_PTR;
  ANE_LayerTemplate : ANE_STR;
begin
  LayerTemplate := '';
  PreviousLayer := nil;
  UnIndexedLayers0.AddMultipleNewLayers( CurrentModelHandle, LayerTemplate,
      PreviousLayer);
  ZerothListsOfIndexedLayers.AddMultipleNewLayers( CurrentModelHandle, LayerTemplate,
      PreviousLayer);
  UnIndexedLayers.AddMultipleNewLayers( CurrentModelHandle, LayerTemplate,
      PreviousLayer);
  UnIndexedLayers2.AddMultipleNewLayers( CurrentModelHandle, LayerTemplate,
      PreviousLayer);
  UnIndexedLayers3.AddMultipleNewLayers( CurrentModelHandle, LayerTemplate,
      PreviousLayer);
  FirstListsOfIndexedLayers.AddMultipleNewLayers( CurrentModelHandle, LayerTemplate,
      PreviousLayer);
  IntermediateUnIndexedLayers.AddMultipleNewLayers( CurrentModelHandle, LayerTemplate,
      PreviousLayer);
  ListsOfIndexedLayers.AddMultipleNewLayers( CurrentModelHandle, LayerTemplate,
      PreviousLayer);
  PostProcessingLayers.AddMultipleNewLayers( CurrentModelHandle, LayerTemplate,
      PreviousLayer);

  if LayerTemplate <> '' then
  begin
    if PreviousLayer = nil
    then
    begin
      PreviousLayerHandle := nil;
    end
    else
    begin
      PreviousLayerHandle := PreviousLayer.GetLayerHandle
        (CurrentModelHandle);
    end;

//    ANE_LayerTemplate := PChar(LayerTemplate);
    GetMem(ANE_LayerTemplate, Length(LayerTemplate) + 1);
    try
      StrPCopy(ANE_LayerTemplate, LayerTemplate);
      ANE_LayerAddByTemplate(CurrentModelHandle, ANE_LayerTemplate,
           PreviousLayerHandle );
      ANE_ProcessEvents(CurrentModelHandle);
    finally
      FreeMem(ANE_LayerTemplate);
    end;
  end;

end;


procedure TLayerStructure.SetWrittenParametersToNormal;
begin
  UnIndexedLayers0.SetWrittenParametersToNormal;
  ZerothListsOfIndexedLayers.SetWrittenParametersToNormal;
  IntermediateUnIndexedLayers.SetWrittenParametersToNormal;
  UnIndexedLayers.SetWrittenParametersToNormal;
  UnIndexedLayers2.SetWrittenParametersToNormal;
  UnIndexedLayers3.SetWrittenParametersToNormal;
  FirstListsOfIndexedLayers.SetWrittenParametersToNormal;
  ListsOfIndexedLayers.SetWrittenParametersToNormal;
  PostProcessingLayers.SetWrittenParametersToNormal;
end;

// ArrangeParameters calls the ArrangeParameters procedures of
// UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
// resulting in all parameters being arranged in the order specified in
// the ParameterOrder StringList.
procedure TLayerStructure.ArrangeParameters;
begin
  UnIndexedLayers0.ArrangeParameters;
  ZerothListsOfIndexedLayers.ArrangeParameters;
  IntermediateUnIndexedLayers.ArrangeParameters;
  UnIndexedLayers.ArrangeParameters;
  UnIndexedLayers2.ArrangeParameters;
  UnIndexedLayers3.ArrangeParameters;
  FirstListsOfIndexedLayers.ArrangeParameters;
  ListsOfIndexedLayers.ArrangeParameters;
  PostProcessingLayers.ArrangeParameters;
end;

// ArrangeLayers calls the ArrangeLayers procedures of
// UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
// resulting in all parameters being arranged in the order specified in
// the LayerOrder StringList.
procedure TLayerStructure.ArrangeLayers;
begin
  UnIndexedLayers0.ArrangeLayers;
  ZerothListsOfIndexedLayers.ArrangeLayers;
  IntermediateUnIndexedLayers.ArrangeLayers;
  UnIndexedLayers.ArrangeLayers;
  UnIndexedLayers2.ArrangeLayers;
  UnIndexedLayers3.ArrangeLayers;
  FirstListsOfIndexedLayers.ArrangeLayers;
  ListsOfIndexedLayers.ArrangeLayers;
  PostProcessingLayers.ArrangeLayers;
end;

// SetExpressions calls the SetExpressions procedures of
// UnIndexedLayers, ListsOfIndexedLayers, and PostProcessingLayers
// resulting in the resetting of the expressions of all parameters in
// which SetValue is True. This is usually only the case for Grid
// or Mesh parameters.
procedure TLayerStructure.SetExpressions(const CurrentModelHandle : ANE_PTR);
begin
  UnIndexedLayers0.SetExpressions(CurrentModelHandle);
  ZerothListsOfIndexedLayers.SetExpressions(CurrentModelHandle);
  IntermediateUnIndexedLayers.SetExpressions(CurrentModelHandle);
  UnIndexedLayers.SetExpressions(CurrentModelHandle);
  UnIndexedLayers2.SetExpressions(CurrentModelHandle);
  UnIndexedLayers3.SetExpressions(CurrentModelHandle);
  FirstListsOfIndexedLayers.SetExpressions(CurrentModelHandle);
  ListsOfIndexedLayers.SetExpressions(CurrentModelHandle);
  PostProcessingLayers.SetExpressions(CurrentModelHandle);
end;

procedure TLayerStructure.SetParameterUnits(const CurrentModelHandle : ANE_PTR;
  const UseOldIndex: boolean);
begin
  UnIndexedLayers0.SetParameterUnits(CurrentModelHandle , UseOldIndex );
  ZerothListsOfIndexedLayers.SetParameterUnits(CurrentModelHandle , UseOldIndex );
  IntermediateUnIndexedLayers.SetParameterUnits(CurrentModelHandle , UseOldIndex );
  UnIndexedLayers.SetParameterUnits(CurrentModelHandle , UseOldIndex );
  UnIndexedLayers2.SetParameterUnits(CurrentModelHandle , UseOldIndex );
  UnIndexedLayers3.SetParameterUnits(CurrentModelHandle , UseOldIndex );
  FirstListsOfIndexedLayers.SetParameterUnits(CurrentModelHandle , UseOldIndex );
  ListsOfIndexedLayers.SetParameterUnits(CurrentModelHandle , UseOldIndex );
  PostProcessingLayers.SetParameterUnits(CurrentModelHandle , UseOldIndex );
end;


Procedure TLayerStructure.AddParameter1ListToList(ParameterListIndex : integer ;
  List : TList);
begin
  UnIndexedLayers0.AddParameter1ListToList(ParameterListIndex , List );
  ZerothListsOfIndexedLayers.AddParameter1ListToList(ParameterListIndex , List );
  IntermediateUnIndexedLayers.AddParameter1ListToList(ParameterListIndex , List );
  UnIndexedLayers.AddParameter1ListToList(ParameterListIndex , List );
  UnIndexedLayers2.AddParameter1ListToList(ParameterListIndex , List );
  UnIndexedLayers3.AddParameter1ListToList(ParameterListIndex , List );
  FirstListsOfIndexedLayers.AddParameter1ListToList(ParameterListIndex , List );
  ListsOfIndexedLayers.AddParameter1ListToList(ParameterListIndex , List );
  PostProcessingLayers.AddParameter1ListToList(ParameterListIndex , List );
end;

Procedure TLayerStructure.AddParameter2ListToList(ParameterListIndex : integer ;
  List : TList);
begin
  UnIndexedLayers0.AddParameter2ListToList(ParameterListIndex , List );
  ZerothListsOfIndexedLayers.AddParameter2ListToList(ParameterListIndex , List );
  IntermediateUnIndexedLayers.AddParameter2ListToList(ParameterListIndex , List );
  UnIndexedLayers.AddParameter2ListToList(ParameterListIndex , List );
  UnIndexedLayers2.AddParameter2ListToList(ParameterListIndex , List );
  UnIndexedLayers3.AddParameter2ListToList(ParameterListIndex , List );
  FirstListsOfIndexedLayers.AddParameter2ListToList(ParameterListIndex , List );
  ListsOfIndexedLayers.AddParameter2ListToList(ParameterListIndex , List );
  PostProcessingLayers.AddParameter2ListToList(ParameterListIndex , List );
end;

procedure TLayerStructure.UpdateOldName;
begin
  UnIndexedLayers0.UpdateOldName;
  ZerothListsOfIndexedLayers.UpdateOldName;
  IntermediateUnIndexedLayers.UpdateOldName;
  UnIndexedLayers.UpdateOldName;
  UnIndexedLayers2.UpdateOldName;
  UnIndexedLayers3.UpdateOldName;
  FirstListsOfIndexedLayers.UpdateOldName;
  ListsOfIndexedLayers.UpdateOldName;
  PostProcessingLayers.UpdateOldName;
end;


procedure TLayerStructure.FixLayers(const CurrentModelHandle: ANE_PTR);
begin
  UnIndexedLayers0.FixLayers(CurrentModelHandle);
  ZerothListsOfIndexedLayers.FixLayers(CurrentModelHandle);
  IntermediateUnIndexedLayers.FixLayers(CurrentModelHandle);
  UnIndexedLayers.FixLayers(CurrentModelHandle);
  UnIndexedLayers2.FixLayers(CurrentModelHandle);
  UnIndexedLayers3.FixLayers(CurrentModelHandle);
  FirstListsOfIndexedLayers.FixLayers(CurrentModelHandle );
  ListsOfIndexedLayers.FixLayers(CurrentModelHandle );
  PostProcessingLayers.FixLayers(CurrentModelHandle );
end;

function TLayerStructure.MakeParameter1Lists(ParameterCount : integer): TList ;
var
  AListOfParameters : TList;
  ParameterIndex : integer;
begin
  Result := TList.Create;
  for ParameterIndex := 0 to ParameterCount -1 do
  begin
    AListOfParameters := TList.Create;
    result.Add(AListOfParameters);
    AddParameter1ListToList(ParameterIndex, AListOfParameters);
  end;
end;

function TLayerStructure.MakeParameter2Lists(ParameterCount : integer): TList ;
var
  AListOfParameters : TList;
  ParameterIndex : integer;
begin
  Result := TList.Create;
  for ParameterIndex := 0 to ParameterCount -1 do
  begin
    AListOfParameters := TList.Create;
    result.Add(AListOfParameters);
    AddParameter2ListToList(ParameterIndex, AListOfParameters);
  end;
end;

procedure TLayerStructure.SetAllParamUnits;
begin
  UnIndexedLayers0.SetAllParamUnits;
  ZerothListsOfIndexedLayers.SetAllParamUnits;
  IntermediateUnIndexedLayers.SetAllParamUnits;
  UnIndexedLayers.SetAllParamUnits;
  UnIndexedLayers2.SetAllParamUnits;
  UnIndexedLayers3.SetAllParamUnits;
  FirstListsOfIndexedLayers.SetAllParamUnits;
  ListsOfIndexedLayers.SetAllParamUnits;
  PostProcessingLayers.SetAllParamUnits;
end;


// TestNames tests that all parameters in each layer and all layers in the
// layer structure will have unique names.
Procedure TLayerStructure.TestNames;
var
  ParameterNames, LayerNames : TTestStringList;
  LayerListIndex, LayerIndex, ParameterListIndex, ParameterIndex : integer;
  AMapLayer : T_ANE_MapsLayer;
  ALayer : T_ANE_Layer;
  AnIndexedParameterList : T_ANE_IndexedParameterList;
  AnIndexedLayerList : T_ANE_IndexedLayerList;
  UnIndexedList: TList;
  IndexedList: TList;
  GroupIndex: integer;
  LayerList:  T_ANE_LayerList;
  ParameterGroupList: TList;
  ParamGroupIndex: integer;
  ParamGroup: T_ANE_ListOfIndexedParameterLists;
  AnANE_ListOfIndexedLayerLists: T_ANE_ListOfIndexedLayerLists;
  LayerName: string;
begin
  ParameterNames := TTestStringList.Create;
  LayerNames := TTestStringList.Create;
  UnIndexedList := TList.Create;
  IndexedList := TList.Create;
  ParameterGroupList := TList.Create;
  try
    begin
      UnIndexedList.Add(UnindexedLayers0);
      UnIndexedList.Add(UnindexedLayers);
      UnIndexedList.Add(UnIndexedLayers2);
      UnIndexedList.Add(UnIndexedLayers3);
      UnIndexedList.Add(IntermediateUnIndexedLayers);
      UnIndexedList.Add(PostProcessingLayers);

      IndexedList.Add(ZerothListsOfIndexedLayers);
      IndexedList.Add(FirstListsOfIndexedLayers);
      IndexedList.Add(ListsOfIndexedLayers);

      for GroupIndex := 0 to UnIndexedList.Count -1 do
      begin
        LayerList := UnIndexedList[GroupIndex];
        for LayerIndex := 0 to LayerList.Count -1 do
        begin
          AMapLayer := LayerList.Items[LayerIndex] as T_ANE_MapsLayer;
          LayerName := AMapLayer.WriteLayerRoot + AMapLayer.WriteIndex;
          LayerNames.Add(LayerName);
          if AMapLayer is T_ANE_Layer then
          begin
            try
              ALayer := T_ANE_Layer(AMapLayer);
              for ParameterIndex := 0 to ALayer.ParamList.Count -1 do
              begin
                ParameterNames.Add
                  (T_ANE_Param(ALayer.ParamList.Items[ParameterIndex]).
                     WriteSpecialBeginning +
                   T_ANE_Param(ALayer.ParamList.Items[ParameterIndex]).WriteName +
                   T_ANE_Param(ALayer.ParamList.Items[ParameterIndex]).
                     WriteSpecialMiddle +
                   T_ANE_Param(ALayer.ParamList.Items[ParameterIndex]).WriteIndex +
                   T_ANE_Param(ALayer.ParamList.Items[ParameterIndex]).
                     WriteSpecialEnd);
              end;
              ParameterGroupList.Clear;
              ParameterGroupList.Capacity := 4;
              ParameterGroupList.Add(ALayer.IndexedParamListNeg1);
              ParameterGroupList.Add(ALayer.IndexedParamList0);
              ParameterGroupList.Add(ALayer.IndexedParamList1);
              ParameterGroupList.Add(ALayer.IndexedParamList2);
              for ParamGroupIndex := 0 to ParameterGroupList.Count -1 do
              begin
                ParamGroup := ParameterGroupList[ParamGroupIndex];
                for ParameterListIndex := 0 to ParamGroup.Count -1 do
                begin
                  AnIndexedParameterList := T_ANE_IndexedParameterList
                    (ParamGroup.Items[ParameterListIndex]);
                  for ParameterIndex := 0 to AnIndexedParameterList.Count -1 do
                  begin
                    ParameterNames.Add
                    (T_ANE_Param(AnIndexedParameterList.Items[ParameterIndex]).
                       WriteSpecialBeginning +
                     T_ANE_Param(AnIndexedParameterList.Items[ParameterIndex]).
                       WriteName +
                     T_ANE_Param(AnIndexedParameterList.Items[ParameterIndex]).
                       WriteSpecialMiddle +
                     T_ANE_Param(AnIndexedParameterList.Items[ParameterIndex]).
                       WriteIndex +
                     T_ANE_Param(AnIndexedParameterList.Items[ParameterIndex]).
                       WriteSpecialEnd);
                  end;
                end;
              end;
            except on E: EInvalidName do
              begin
                raise EInvalidName.Create('In "' + LayerName + '":'
                  + E.Message);
              end;
            end;
            ParameterNames.Clear;

          end;
        end;
      end;

      for GroupIndex := 0 to IndexedList.Count -1 do
      begin
        AnANE_ListOfIndexedLayerLists := IndexedList[GroupIndex];
        for LayerListIndex := 0 to AnANE_ListOfIndexedLayerLists.Count -1 do
        begin
          AnIndexedLayerList := (AnANE_ListOfIndexedLayerLists.Items
            [LayerListIndex]) as T_ANE_IndexedLayerList;
          for LayerIndex := 0 to AnIndexedLayerList.Count -1 do
          begin
            AMapLayer := AnIndexedLayerList.Items[LayerIndex] as T_ANE_MapsLayer;
            LayerName := AMapLayer.WriteLayerRoot + AMapLayer.WriteIndex;
            LayerNames.Add(LayerName);
            if AMapLayer is T_ANE_Layer then
            begin
              try
              ALayer := T_ANE_Layer(AMapLayer);
              for ParameterIndex := 0 to ALayer.ParamList.Count -1 do
              begin
                ParameterNames.Add
                  (T_ANE_Param(ALayer.ParamList.Items[ParameterIndex]).
                     WriteSpecialBeginning +
                   T_ANE_Param(ALayer.ParamList.Items[ParameterIndex]).WriteName +
                   T_ANE_Param(ALayer.ParamList.Items[ParameterIndex]).
                     WriteSpecialMiddle +
                   T_ANE_Param(ALayer.ParamList.Items[ParameterIndex]).WriteIndex +
                   T_ANE_Param(ALayer.ParamList.Items[ParameterIndex]).
                     WriteSpecialEnd);
              end;
              ParameterGroupList.Clear;
              ParameterGroupList.Capacity := 4;
              ParameterGroupList.Add(ALayer.IndexedParamListNeg1);
              ParameterGroupList.Add(ALayer.IndexedParamList0);
              ParameterGroupList.Add(ALayer.IndexedParamList1);
              ParameterGroupList.Add(ALayer.IndexedParamList2);
              for ParamGroupIndex := 0 to ParameterGroupList.Count -1 do
              begin
                ParamGroup := ParameterGroupList[ParamGroupIndex];
                for ParameterListIndex := 0 to ParamGroup.Count -1 do
                begin
                  AnIndexedParameterList := T_ANE_IndexedParameterList
                    (ParamGroup.Items[ParameterListIndex]);
                  for ParameterIndex := 0 to AnIndexedParameterList.Count -1 do
                  begin
                    ParameterNames.Add
                    (T_ANE_Param(AnIndexedParameterList.Items[ParameterIndex]).
                       WriteSpecialBeginning +
                     T_ANE_Param(AnIndexedParameterList.Items[ParameterIndex]).
                       WriteName +
                     T_ANE_Param(AnIndexedParameterList.Items[ParameterIndex]).
                       WriteSpecialMiddle +
                     T_ANE_Param(AnIndexedParameterList.Items[ParameterIndex]).
                       WriteIndex +
                     T_ANE_Param(AnIndexedParameterList.Items[ParameterIndex]).
                       WriteSpecialEnd);
                  end;
                end;
              end;
              ParameterNames.Clear;
              except On E: EInvalidName do
                begin
                  raise EInvalidName.Create('In "' + LayerName + '": '
                    + E.Message);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    ParameterNames.Free;
    LayerNames.Free;
    UnIndexedList.Free;
    IndexedList.Free;
    ParameterGroupList.Free;
  end;

end;


// Call Cancel when the user has choosen to cancel all changes made to
// the layer structure.
// Cancel Frees all layers and parameters whose Status's are sNew, sets
// the Status's of all remaining layers and parameters to sNormal
// and calls UpdateIndicies and UpdateOldIndicies.
procedure TLayerStructure.Cancel;
begin
  FreeByStatus(sNew);
  SetStatus(sNormal);
  UpdateIndicies;
  UpdateOldIndicies;
  RestoreParamLock;
  DontNeedToUpdateParamName;
end;

// Call OK when the user has choosen to accept all changes to the layer
// structure.
// OK instructs Argus ONE to remove any layer or parameter whose Status
// is sDeleted. The remaining indexed layers and parameters are renamed
// to reflect what they should be in the final layer structure. Then new
// layers and parameters are added to Argus ONE and the expressions of
// parameters will be updated in any parameter in which SetValue is True.
// The layer structure in the PIE is updated to reflect the changes made in
// Argus ONE. This involves freeing deleted layers and parameters and
// calling UpdateIndicies and UpdateOldIndicies when appropriate. Finally
// the status of everything is set to sNormal. This last step may be
// redundant because the status of each layer and parameter is updated
// to sNormal when Argus ONE is instructed to create it.
procedure TLayerStructure.OK(const CurrentModelHandle : ANE_PTR);
begin
  Screen.Cursor := crHourGlass;
  try
    RemoveDeletedLayers(CurrentModelHandle);
//    ANE_ProcessEvents(CurrentModelHandle);
    RemoveDeletedParameters(CurrentModelHandle);
    ANE_ProcessEvents(CurrentModelHandle);
    FreeByStatus(sDeleted);
    UpdateIndicies;
    RenameIndexedParameters(CurrentModelHandle);
    ANE_ProcessEvents(CurrentModelHandle);

    RenameLayers(CurrentModelHandle);
    ANE_ProcessEvents(CurrentModelHandle);

    UpdateOldIndicies;
    ArrangeLayers;
    ArrangeParameters;
    FixLayers(CurrentModelHandle);

//    AddNewLayers(CurrentModelHandle);
    AddMultipleNewLayers(CurrentModelHandle);
    SetWrittenParametersToNormal;

    ANE_ProcessEvents(CurrentModelHandle);
    AddNewParameters(CurrentModelHandle);
    ANE_ProcessEvents(CurrentModelHandle);
    TestNames;
    SetExpressions(CurrentModelHandle);
    ANE_ProcessEvents(CurrentModelHandle);
    SetParameterUnits(CurrentModelHandle, False);

    {$IFDEF Argus5}
    try
      SetParamLock(CurrentModelHandle);
    except on EArgusPropertyError do
      begin
      end;
    end;
    {$ENDIF}
    
    SetStatus(sNormal); // this may be redundant;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function T_ANE_MapsLayer.WriteLayerRoot: string;
begin
  result := WriteNewRoot;
end;

procedure T_ANE_Layer.AddParameter0ListToList(ParameterListIndex: integer;
  List: TList);
begin
  IndexedParamList0.AddParameterListToList(ParameterListIndex, List );
end;

procedure T_ANE_Layer.AddOrRemoveIndexedParameter0(
  AParameterType: T_ANE_ParamClass; ParameterShouldBePresent: boolean);
var
  Index : integer;
  An_ANE_Param : T_ANE_Param;
  An_ANE_IndexedParameterList : T_ANE_IndexedParameterList;
begin
  for Index := 0 to IndexedParamList0.Count -1 do
  begin
    An_ANE_IndexedParameterList := IndexedParamList0.Items[Index];

    An_ANE_Param :=
             An_ANE_IndexedParameterList.GetParameterByName
               (AParameterType.ANE_ParamName) as AParameterType;
    if ParameterShouldBePresent then
    begin
      if (An_ANE_Param = nil) then
      begin
        AParameterType.Create(An_ANE_IndexedParameterList, -1) ;
      end
      else
      begin
        An_ANE_Param.UnDelete
      end;
    end
    else //if ParameterShouldBePresent
    begin
      if not ( An_ANE_Param = nil) then
      begin
        An_ANE_Param.Delete;
      end;
    end; //if ParameterShouldBePresent else
  end;
end;

procedure T_ANE_Layer.SetIndexed0ExpressionNow(
  AParameterType: T_ANE_ParamClass; ParameterName: string;
  ShouldSetExpressionNow: boolean);
begin
  IndexedParamList0.SetExpressionNow(AParameterType, ParameterName,
    ShouldSetExpressionNow);
end;

procedure T_ANE_Layer.AddOrRemoveIndexedParameterNeg1(
  AParameterType: T_ANE_ParamClass; ParameterShouldBePresent: boolean);
var
  Index : integer;
  An_ANE_Param : T_ANE_Param;
  An_ANE_IndexedParameterList : T_ANE_IndexedParameterList;
begin
  for Index := 0 to IndexedParamListNeg1.Count -1 do
  begin
    An_ANE_IndexedParameterList := IndexedParamListNeg1.Items[Index];

    An_ANE_Param :=
             An_ANE_IndexedParameterList.GetParameterByName
               (AParameterType.ANE_ParamName) as AParameterType;
    if ParameterShouldBePresent then
    begin
      if (An_ANE_Param = nil) then
      begin
        AParameterType.Create(An_ANE_IndexedParameterList, -1) ;
      end
      else
      begin
        An_ANE_Param.UnDelete
      end;
    end
    else //if ParameterShouldBePresent
    begin
      if not ( An_ANE_Param = nil) then
      begin
        An_ANE_Param.Delete;
      end;
    end; //if ParameterShouldBePresent else
  end;
end;

procedure T_ANE_Layer.AddParameterNeg1ListToList(
  ParameterListIndex: integer; List: TList);
begin
  IndexedParamListNeg1.AddParameterListToList(ParameterListIndex, List );
end;

procedure T_ANE_Layer.SetIndexedNeg1ExpressionNow(
  AParameterType: T_ANE_ParamClass; ParameterName: string;
  ShouldSetExpressionNow: boolean);
begin
  IndexedParamListNeg1.SetExpressionNow(AParameterType, ParameterName,
    ShouldSetExpressionNow);
end;

procedure T_ANE_ListOfIndexedLayerLists.AddParameter0ListToList(
  ParameterListIndex: integer; List: TList);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.AddParameter0ListToList(ParameterListIndex, List) ;
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.AddParameterNeg1ListToList(
  ParameterListIndex: integer; List: TList);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.AddParameterNeg1ListToList(ParameterListIndex, List) ;
  end;
end;

procedure TLayerStructure.AddParameter0ListToList(
  ParameterListIndex: integer; List: TList);
begin
  UnIndexedLayers0.AddParameter0ListToList(ParameterListIndex , List );
  ZerothListsOfIndexedLayers.AddParameter0ListToList(ParameterListIndex , List );
  IntermediateUnIndexedLayers.AddParameter0ListToList(ParameterListIndex , List );
  UnIndexedLayers.AddParameter0ListToList(ParameterListIndex , List );
  UnIndexedLayers2.AddParameter0ListToList(ParameterListIndex , List );
  UnIndexedLayers3.AddParameter0ListToList(ParameterListIndex , List );
  FirstListsOfIndexedLayers.AddParameter0ListToList(ParameterListIndex , List );
  ListsOfIndexedLayers.AddParameter0ListToList(ParameterListIndex , List );
  PostProcessingLayers.AddParameter0ListToList(ParameterListIndex , List );
end;

procedure TLayerStructure.AddParameterNeg1ListToList(
  ParameterListIndex: integer; List: TList);
begin
  UnIndexedLayers0.AddParameterNeg1ListToList(ParameterListIndex , List );
  ZerothListsOfIndexedLayers.AddParameterNeg1ListToList(ParameterListIndex , List );
  IntermediateUnIndexedLayers.AddParameterNeg1ListToList(ParameterListIndex , List );
  UnIndexedLayers.AddParameterNeg1ListToList(ParameterListIndex , List );
  UnIndexedLayers2.AddParameterNeg1ListToList(ParameterListIndex , List );
  UnIndexedLayers3.AddParameterNeg1ListToList(ParameterListIndex , List );
  FirstListsOfIndexedLayers.AddParameterNeg1ListToList(ParameterListIndex , List );
  ListsOfIndexedLayers.AddParameterNeg1ListToList(ParameterListIndex , List );
  PostProcessingLayers.AddParameterNeg1ListToList(ParameterListIndex , List );
end;

procedure T_ANE_ListOfIndexedLayerLists.MakeIndexedList0(
  ALayerType: T_ANE_LayerClass;
  AnIndexedParameterType: T_ANE_IndexedParameterListClass;
  Position: integer);
var
  ALayerList : T_ANE_IndexedLayerList;
  LayerListIndex : integer;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.MakeIndexedList0( ALayerType, AnIndexedParameterType, Position);
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.NeedToUpdateParamName;
begin
  FNeedToUpdateParamName := True;
end;

procedure T_ANE_ListOfIndexedLayerLists.UpdateUnIndexedParamName(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
var
  LayerListIndex: integer;
  ALayerList: T_ANE_IndexedLayerList;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.UpdateUnIndexedParamName
      (ALayerType , AParameterType);
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.UpdateIndexedParameter0ParamName(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
var
  LayerListIndex: integer;
  ALayerList: T_ANE_IndexedLayerList;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.UpdateIndexedParameter0ParamName
      (ALayerType , AParameterType);
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.UpdateIndexedParameter1ParamName(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
var
  LayerListIndex: integer;
  ALayerList: T_ANE_IndexedLayerList;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.UpdateIndexedParameter1ParamName
      (ALayerType , AParameterType);
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.UpdateIndexedParameter2ParamName(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
var
  LayerListIndex: integer;
  ALayerList: T_ANE_IndexedLayerList;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.UpdateIndexedParameter2ParamName
      (ALayerType , AParameterType);
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.UpdateIndexedParameterNeg1ParamName(
  ALayerType: T_ANE_LayerClass; AParameterType: T_ANE_ParamClass);
var
  LayerListIndex: integer;
  ALayerList: T_ANE_IndexedLayerList;
begin
  for LayerListIndex := 0 to Count -1 do
  begin
    ALayerList := Items[LayerListIndex];
    ALayerList.UpdateIndexedParameterNeg1ParamName
      (ALayerType , AParameterType);
  end;
end;

procedure T_ANE_ListOfIndexedLayerLists.DontNeedToUpdateParamName;
var
  LayerListIndex: integer;
  ALayerList: T_ANE_IndexedLayerList;
begin
  if FNeedToUpdateParamName then
  begin
    FNeedToUpdateParamName := False;
    for LayerListIndex := 0 to Count -1 do
    begin
      ALayerList := Items[LayerListIndex];
      ALayerList.DontNeedToUpdateParamName;
    end;
  end;
end;

{ TIndexedInfoLayer }

constructor TIndexedInfoLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  SetOldIndex;
end;

procedure TIndexedInfoLayer.SetOldIndex;
var
  IndexedLayerList : T_ANE_IndexedLayerList;
  Position, TempResult : integer;
  LayerIndex : integer;
  ALayer : T_ANE_MapsLayer;
begin
  if LayerList is T_ANE_IndexedLayerList
  then
    begin
      if Status = sDeleted then
      begin
        FOldIndex := -1;
      end
      else
      begin
        IndexedLayerList := LayerList as T_ANE_IndexedLayerList;
        Position := IndexedLayerList.IndexOf(self);
        TempResult := -1;
        for LayerIndex := 0 to Position do
        begin
          ALayer := IndexedLayerList.Items[LayerIndex];
          if ALayer.Status <> sDeleted then
          begin
            Inc(TempResult);
          end;
        end;
        FOldIndex := TempResult;
      end;
    end
  else
    begin
      FOldIndex := -1;
    end;
end;

function TIndexedInfoLayer.WriteIndex: string;
var
  IndexedLayerList : T_ANE_IndexedLayerList;
  Position, TempResult : integer;
  LayerIndex : integer;
  ALayer : T_ANE_MapsLayer;
begin
  if LayerList is T_ANE_IndexedLayerList
  then
    begin
      if Status = sDeleted then
      begin
        result := '-1'
      end
      else
      begin
        IndexedLayerList := LayerList as T_ANE_IndexedLayerList;
        Position := IndexedLayerList.IndexOf(self);
        TempResult := 0;
        for LayerIndex := 0 to Position do
        begin
          ALayer := IndexedLayerList.Items[LayerIndex];
          if ALayer.Status <> sDeleted then
          begin
            Inc(TempResult);
          end;
        end;
        result := IntToStr(TempResult);
      end;
    end
  else
    begin
      result := ''
    end;
end;

function TIndexedInfoLayer.WriteLayer(
  const CurrentModelHandle: ANE_PTR): string;
begin
  result := inherited WriteLayer(CurrentModelHandle);
  FOldIndex := LayerList.IndexOf(self);
end;

function TIndexedInfoLayer.WriteOldIndex: string;
begin
  result := IntToStr(FOldIndex+1);
end;

procedure T_ANE_MapsLayer.SetParamLock(const CurrentModelHandle: ANE_PTR);
begin
  // do nothing. No parameters in Maps Layers
end;

procedure T_ANE_Param.SetLock(Value: TParamLock);
begin
  FLock := Value;
  if Status = sNew then
  begin
    OldLock := Lock;
  end;
end;

function T_ANE_Param.EvaluateLock : TParamLock;
begin
  result := Lock;
end;

procedure T_ANE_Param.RestoreLock;
begin
  FLock := OldLock;
end;

procedure T_ANE_MapsLayer.RestoreParamLock;
begin

end;

function T_ANE_InfoLayer.WriteInterpPie: string;
begin
  result := inherited WriteInterpPie;
  if (Interp <> leNearest) and (Interp <> leExact)
    and (Interp <> leInterpolate) then
  begin
    result := Chr(9) + 'Interpolation PIE: ';
    case Interp of
      leScan2d :
        begin
          result := result + 'SCANN2D/v1';
        end;
      leNN2D :
        begin
          result := result + 'NN2D';
        end;
      leInvDistSq :
        begin
          result := result + 'InvDistSq';
        end;
      le624Noxzyz :
        begin
          result := result + '"624 Interpolation (no zxzy)"';
        end;
      le624 :
        begin
          result := result + '"624 Interpolation"';
        end;
      leQT_Nearest:
        begin
          result := result + '"QT_Nearest"';
        end;
      leQT_Mean5:
        begin
          result := result + '"QT_Mean of 5 Nearest"';
        end;
      leQT_Mean20:
        begin
          result := result + '"QT_Mean of 20 Nearest"';
        end;
      leQT_InvDistSq5:
        begin
          result := result + '"QT_Inv Dist Sq of 5 Nearest"';
        end;
      leQT_InvDistSq20:
        begin
          result := result + '"QT_Inv Dist Sq of 20 Nearest"';
        end;
      leQT_NearestA100:
        begin
          result := result + '"QT_Nearest (Anis = 100)"';
        end;
      leQT_Mean5A100:
        begin
          result := result + '"QT_Mean of 5 Nearest (Anis = 100)"';
        end;
      leQT_Mean20A100:
        begin
          result := result + '"QT_Mean of 20 Nearest (Anis = 100)"';
        end;
      leQT_InvDistSq5A100:
        begin
          result := result + '"QT_Inv Dist Sq of 5 Nearest (Anis = 100)"';
        end;
      leQT_InvDistSq20A100:
        begin
          result := result + '"QT_Inv Dist Sq of 20 Nearest (Anis = 100)"';
        end;
    end;
    result := result + Chr(10);
  end;
end;

function T_ANE_MapsLayer.WriteInterpPie: string;
begin
  result := '';
end;

{ T_ANE_NamedDataLayer }

constructor T_ANE_NamedDataLayer.Create(LayerName: string;
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited Create(ALayerList, Index);
  FName := FixArgusName(LayerName);
end;

function T_ANE_NamedDataLayer.WriteLayerRoot: string;
begin
  result := FName;
end;

{ T_ANE_NamedDataParam }

constructor T_ANE_NamedDataParam.Create(Name: string;
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited Create(AParameterList, Index);
  FName := FixArgusName(Name);
end;

function T_ANE_NamedDataParam.WriteName: string;
begin
  result := FName;
end;

{ T_ANE_NamedInfoLayer }

constructor T_ANE_NamedInfoLayer.Create(LayerName: string;
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited Create(ALayerList, Index);
  FName := FixArgusName(LayerName);
end;

function T_ANE_NamedInfoLayer.WriteLayerRoot: string;
begin
  result := FName;
end;

{ T_ANE_NamedLayerParam }

constructor T_ANE_NamedLayerParam.Create(Name: string;
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited Create(AParameterList, Index);
  FName := FixArgusName(Name);
end;

function T_ANE_NamedLayerParam.WriteName: string;
begin
  result := FName;
end;

{ T_ANE_NamedGroupLayer }

constructor T_ANE_NamedGroupLayer.Create(LayerName: string;
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited Create(ALayerList, Index);
  FName := FixArgusName(LayerName);
end;

function T_ANE_NamedGroupLayer.WriteLayerRoot: string;
begin
  result := FName;
end;

{ T_ANE_NamedGridLayer }

constructor T_ANE_NamedGridLayer.Create(LayerName: string;
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited Create(ALayerList,Index);
  FName := FixArgusName(LayerName);
end;

function T_ANE_NamedGridLayer.WriteLayerRoot: string;
begin
  result := FName;
end;

{ T_ANE_NamedGridParam }

constructor T_ANE_NamedGridParam.Create(Name: string;
  AParameterList: T_ANE_ParameterList; Index: Integer);
begin
  inherited Create(AParameterList,Index);
  FName := FixArgusName(Name);
end;

function T_ANE_NamedGridParam.WriteName: string;
begin
  result := FName;
end;

{ T_ANE_NamedDomainOutlineLayer }

constructor T_ANE_NamedDomainOutlineLayer.Create(LayerName: string;
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited Create(ALayerList, Index);
  FName := FixArgusName(LayerName);
end;

function T_ANE_NamedDomainOutlineLayer.WriteLayerRoot: string;
begin
  result := FName;
end;

{ T_TypedIndexedLayerList }

constructor T_TypedIndexedLayerList.Create(
  ALayerType: T_ANE_MapsLayerClass; AnOwner: T_ANE_ListOfIndexedLayerLists;
  Position: Integer = -1);
begin
  inherited Create(AnOwner, Position);
  FLayerType := ALayerType;
end;


function T_TypedIndexedLayerList.GetTypedCount: integer;
var
  Index : integer;
  ALayer : T_ANE_MapsLayer;
begin
  result := 0;
  for Index := 0 to Count -1 do
  begin
    ALayer := Items[Index];
    if ALayer is FLayerType then
    begin
      Inc(Result);
    end;
  end;
end;

function T_TypedIndexedLayerList.LayerIndex(
  const Layer: T_ANE_MapsLayer): string;
var
  LayerCount : integer;
  Index : integer;
  ALayer: T_ANE_MapsLayer;
begin
  result := '';
  if Layer is LayerType then
  begin
    result := '0';
    LayerCount := 0;
    for Index := 0 to Count -1 do
    begin
      ALayer := Items[Index];
      if ALayer is LayerType then
      begin
        Inc(LayerCount);
        if Layer = ALayer then
        begin
          result := IntToStr(LayerCount);
          Exit;
        end;
      end;
    end;
  end;
end;

procedure T_TypedIndexedLayerList.SetTypedCount(const Value: integer);
var
  CurrentCount : integer;
  Index : integer;
  ALayer : T_ANE_MapsLayer;
  NewValue : integer;
begin
  CurrentCount := TypedCount;
  NewValue := Value;
  if NewValue < 0 then
  begin
    NewValue := 0;
  end;

  if NewValue > CurrentCount then
  begin
    for Index := 1 to NewValue - CurrentCount do
    begin
      FLayerType.Create(self,-1);
    end;
  end
  else if NewValue < CurrentCount then
  begin
    for Index := Count -1 downto 0 do
    begin
      ALayer := Items[Index];
      if ALayer is FLayerType then
      begin
        ALayer.Delete;
        Dec(CurrentCount);
        if NewValue = CurrentCount then
        begin
          Exit;
        end;
      end;
    end;
  end;
end;

function T_ANE_MapsLayer.WriteGridBlockCentered(
  const CurrentModelHandle: ANE_PTR): string;
begin
  result := '';
end;

function T_ANE_GridLayer.WriteGridBlockCentered(
  const CurrentModelHandle: ANE_PTR): string;
begin
  if BlockCenteredGrid then
  begin
    result := inherited WriteGridBlockCentered(CurrentModelHandle);
  end
  else
  begin
    result := Chr(9) + 'Grid Block Centered: "No"' + Chr(10);
  end;

end;

procedure T_ANE_MapsLayer.UpdateOldName;
begin

end;

function T_ANE_ParameterList.ParentLayer: T_ANE_Layer;
var
  AListOfIndexedParameterLists: T_ANE_ListOfIndexedParameterLists;
begin
  if Owner is T_ANE_Layer
  then
    begin
      result := Owner as T_ANE_Layer;
    end
  else if Owner is T_ANE_ListOfIndexedParameterLists
  then
    begin
      AListOfIndexedParameterLists :=
        Owner as T_ANE_ListOfIndexedParameterLists;
      result := AListOfIndexedParameterLists.Owner;
    end
  else // this branch should never be called.
    begin
      result := nil;
    end;
end;

procedure T_ANE_Param.NeedToUpdateParamName;
begin
  if not FNeedToUpdateParamName then
  begin
    FNeedToUpdateParamName := True;
    ParameterList.NeedToUpdateParamName;
  end;
end;

procedure T_ANE_MapsLayer.NeedToUpdateParamName;
begin
  if not FNeedToUpdateParamName then
  begin
    FNeedToUpdateParamName := True;
    LayerList.NeedToUpdateParamName;
  end;
end;

procedure T_ANE_ParameterList.NeedToUpdateParamName;
begin
  if not FNeedToUpdateParamName then
  begin
    FNeedToUpdateParamName := True;
    if Owner is T_ANE_Layer then
    begin
      T_ANE_Layer(Owner).NeedToUpdateParamName;
    end
    else if Owner is T_ANE_ListOfIndexedParameterLists then
    begin
      T_ANE_ListOfIndexedParameterLists(Owner).NeedToUpdateParamName;
    end
    else // this branch should never be called.
    begin
      Assert(False);
    end;
  end;
end;

procedure T_ANE_Layer.UpdateUnIndexedParamName(AParameterType: T_ANE_ParamClass);
var
  An_ANE_Param : T_ANE_Param;
begin
  An_ANE_Param :=
           ParamList.GetParameterByName(AParameterType.ANE_ParamName)
           as AParameterType;
  if An_ANE_Param <> nil then
  begin
    An_ANE_Param.NeedToUpdateParamName;
  end;
end;

procedure T_ANE_Layer.UpdateIndexedParameterNeg1ParamName(
  AParameterType: T_ANE_ParamClass);
var
  Index : integer;
  An_ANE_Param : T_ANE_Param;
  An_ANE_IndexedParameterList : T_ANE_IndexedParameterList;
begin
  for Index := 0 to IndexedParamListNeg1.Count -1 do
  begin
    An_ANE_IndexedParameterList := IndexedParamListNeg1.Items[Index];

    An_ANE_Param :=
             An_ANE_IndexedParameterList.GetParameterByName
               (AParameterType.ANE_ParamName) as AParameterType;
    if (An_ANE_Param <> nil) then
    begin
      An_ANE_Param.NeedToUpdateParamName;
    end;
  end;
end;

procedure T_ANE_Layer.UpdateIndexedParameter0ParamName(
  AParameterType: T_ANE_ParamClass);
var
  Index : integer;
  An_ANE_Param : T_ANE_Param;
  An_ANE_IndexedParameterList : T_ANE_IndexedParameterList;
begin
  for Index := 0 to IndexedParamList0.Count -1 do
  begin
    An_ANE_IndexedParameterList := IndexedParamList0.Items[Index];

    An_ANE_Param :=
             An_ANE_IndexedParameterList.GetParameterByName
               (AParameterType.ANE_ParamName) as AParameterType;
    if (An_ANE_Param <> nil) then
    begin
      An_ANE_Param.NeedToUpdateParamName;
    end;
  end;
end;

procedure T_ANE_Layer.UpdateIndexedParameter1ParamName(
  AParameterType: T_ANE_ParamClass);
var
  Index : integer;
  An_ANE_Param : T_ANE_Param;
  An_ANE_IndexedParameterList : T_ANE_IndexedParameterList;
begin
  for Index := 0 to IndexedParamList1.Count -1 do
  begin
    An_ANE_IndexedParameterList := IndexedParamList1.Items[Index];

    An_ANE_Param :=
             An_ANE_IndexedParameterList.GetParameterByName
               (AParameterType.ANE_ParamName) as AParameterType;
    if (An_ANE_Param <> nil) then
    begin
      An_ANE_Param.NeedToUpdateParamName;
    end;
  end;
end;

procedure T_ANE_Layer.UpdateIndexedParameter2ParamName(
  AParameterType: T_ANE_ParamClass);
var
  Index : integer;
  An_ANE_Param : T_ANE_Param;
  An_ANE_IndexedParameterList : T_ANE_IndexedParameterList;
begin
  for Index := 0 to IndexedParamList2.Count -1 do
  begin
    An_ANE_IndexedParameterList := IndexedParamList2.Items[Index];

    An_ANE_Param :=
             An_ANE_IndexedParameterList.GetParameterByName
               (AParameterType.ANE_ParamName) as AParameterType;
    if (An_ANE_Param <> nil) then
    begin
      An_ANE_Param.NeedToUpdateParamName;
    end;
  end;
end;

procedure T_ANE_MapsLayer.DontNeedToUpdateParamName;
begin
  FNeedToUpdateParamName := False;
end;

procedure T_ANE_Layer.DontNeedToUpdateParamName;
begin
  if FNeedToUpdateParamName then
  begin
    inherited;
    ParamList.DontNeedToUpdateParamName;
    IndexedParamListNeg1.DontNeedToUpdateParamName;
    IndexedParamList0.DontNeedToUpdateParamName;
    IndexedParamList1.DontNeedToUpdateParamName;
    IndexedParamList2.DontNeedToUpdateParamName;
  end;
end;

procedure T_ANE_ParameterList.DontNeedToUpdateParamName;
var
  AT_ANE_Param : T_ANE_Param;
  ParamIndex : integer;
begin
  if FNeedToUpdateParamName then
  begin
    FNeedToUpdateParamName := False;
    for ParamIndex := 0 to FList.Count -1 do
    begin
      AT_ANE_Param := FList.Items[ParamIndex];
      AT_ANE_Param.DontNeedToUpdateParamName;
    end;
  end;
end;

procedure T_ANE_Param.DontNeedToUpdateParamName;
begin
  FNeedToUpdateParamName := False;
end;

{ T_ANE_NamedMapLayer }

constructor T_ANE_NamedMapLayer.Create(LayerName: string;
  ALayerList: T_ANE_LayerList; Index: Integer);
begin
  inherited Create(ALayerList, Index);
  FName := FixArgusName(LayerName);
end;

function T_ANE_NamedMapLayer.WriteLayerRoot: string;
begin
  result := FName;
end;

end.
