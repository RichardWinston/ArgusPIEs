unit ParamNamesAndTypes;

interface

{ParamNamesAndTypes defines parameter names and parameter types for use in
 PIE functions.}

uses AnePIE;

// names
const   gpnPeriod : array [0..1] of PChar = ('Period', nil);
const   gpnUnit : array [0..1] of PChar = ('Unit', nil);
const   gpnNodeLayer : array [0..1] of PChar = ('NodeLayer', nil);
const   gpnNode : array [0..1] of PChar = ('Node', nil);
const   gpnNodeExpression : array [0..2] of PChar = ('Node', 'Expression', nil);
const   gpnElement : array [0..1] of PChar = ('Element', nil);
const   gpnElementExpression : array [0..2] of PChar = ('Element',  'Expression', nil);
const   gpnExpression : array [0..1] of PChar = ('Expression', nil);
const   gpnElementLayer : array [0..1] of PChar = ('ElementLayer', nil);
const   gpnTime : array [0..1] of PChar = ('Time', nil);
const   gpnNumber : array [0..1] of PChar = ('Number', nil);
const   gpnModflowLayerNames : array [0..4] of PChar = ('Unit', 'Top_Elevation',
  'Bottom_Elevation', 'Elevation', nil);
const   gpnTimeIndex : array [0..1] of PChar = ('Time_Index', nil);
const   gpnZone : array [0..1] of PChar = ('ZoneIndex', nil);
const   gpnFrozen : array [0..1] of PChar = ('Frozen', nil);
const   gpnColumnRow : array [0..2] of PChar = ('Column','Row', nil);
const   gpnElementLayerName : array [0..1] of PChar = ('ElementLayerName', nil);
const   gpnLayerParam : array [0..3] of PChar = ('ElementLayerName', 'ParameterName', 'FileName', nil);
const   gpnLayerParamNode : array [0..4] of PChar = ('ElementLayerName', 'ParameterName', 'Node', 'FileName', nil);
const   gpnLayerParamElem : array [0..4] of PChar = ('ElementLayerName', 'ParameterName', 'Element', 'FileName', nil);
const   gpnContourOverride : array [0..2] of PChar = ('ContourIndex', 'IsOverridden', nil);
const   gpnElementNode : array [0..2] of PChar = ('Element', 'Node', nil);
const   gpnLayerParameterNode : array [0..2] of PChar = ('Mesh_Layer', 'Parameter', 'Node_Number');
const   gpnFile : array [0..1] of PChar = ('File', nil);
const   gpnElevation : array [0..1] of PChar = ('Elevation', nil);
const   gpnColRowLayer : array [0..3] of PChar = ('Column', 'Row', 'Layer', nil);
const   gpnEvalstring : array [0..1] of PChar = ('StringToEvaluate', nil);
const   gpnGridlayer : array [0..1] of PChar = ('GridLayerName', nil);
const   gpnParameter : array [0..1] of PChar = ('ParameterName', nil);
const   gpnEvalstringFile : array [0..2] of PChar = ('StringToEvaluate', 'FileName', nil);
const   gpnParameterFile : array [0..2] of PChar = ('ParameterName', 'FileName', nil);
const   gpnGageFile : array [0..1] of PChar = ('Gage', nil);
const   gpnFileType : array [0..1] of PChar = ('File_Type', nil);
const   gpnRootType : array [0..1] of PChar = ('Root', nil);
const   gpnFileFileNN : array [0..3] of PChar = ('File', 'RestartFile', 'NN', nil);
const   gpnFileNN : array [0..2] of PChar = ('File', 'NN', nil);
const   gpnParameterNumber : array [0..1] of PChar = ('Parameter_Number', nil);
const   gpnMeshLayer : array [0..0] of PChar = ('Mesh_Layer');
const   gpnInformationLayer : array [0..0] of PChar = ('Information_Layer');
const   gpnContour : array [0..1] of PChar = ('ContourIndex', nil);
const   gpnContourNode : array [0..2] of PChar = ('ContourIndex', 'NodeIndex', nil);
const   gpnMapHeadingDipDipDirection : array [0..3] of PChar =
  ('Map_Heading_Degrees_Clockwise_from_North', 'Dip_Degrees',
  'Dip_Direction_Degrees_Clockwise_from_North', nil);
const   gpnAngle1Angle2Fraction : array [0..3] of PChar =
  ('First_Angle_In_Degrees', 'Second_Angle_In_Degrees',
  'Fraction_of_First_Angle', nil);
const   gpnParameterNumberXY : array [0..3] of PChar = ('Parameter_Number', 'X', 'Y', nil);


const   gOneIntegerTypes : array [0..1] of EPIENumberType = (kPIEInteger, 0);
const   gOneDoubleTypes : array [0..1] of EPIENumberType = (kPIEFloat, 0);
const   g1Integer3RealTypes : array [0..4] of EPIENumberType =
  (kPIEInteger, kPIEFloat, kPIEFloat, kPIEFloat, 0);
const   g1Integer2RealTypes : array [0..3] of EPIENumberType =
  (kPIEInteger, kPIEFloat, kPIEFloat, 0);
const   gOneBooleanTypes : array [0..1] of EPIENumberType = (kPIEBoolean, 0);
const   gTwoIntegerTypes : array [0..2] of EPIENumberType = (kPIEInteger, kPIEInteger, 0);
const   gOneStringTypes  : array [0..1] of EPIENumberType = (kPIEString, 0);
const   g2StringTypes  : array [0..2] of EPIENumberType = (kPIEString, kPIEString, 0);
const   g1String1IntegerTypes  : array [0..2] of EPIENumberType = (kPIEString, kPIEInteger, 0);
const   g2String1IntegerTypes  : array [0..3] of EPIENumberType = (kPIEString, kPIEString, kPIEInteger, 0);
const   g3StringTypes  : array [0..3] of EPIENumberType = (kPIEString, kPIEString, kPIEString, 0);
const   gOneIntegerStringTypes : array [0..2] of EPIENumberType = (kPIEInteger, kPIEString, 0);
const   gOneIntegerBoolTypes : array [0..2] of EPIENumberType = (kPIEInteger, kPIEBoolean, 0);
const   gThreeIntegerTypes : array [0..3] of EPIENumberType = (kPIEInteger, kPIEInteger, kPIEInteger, 0);
const   g2String2IntegerTypes  : array [0..4] of EPIENumberType = (kPIEString, kPIEString, kPIEInteger, kPIEInteger, 0);
const   gThreeDoubleTypes : array [0..3] of EPIENumberType = (kPIEFloat, kPIEFloat, kPIEFloat, 0);

implementation

end.
