unit ParamNamesAndTypes;

interface

uses AnePIE;

const   gpnPeriod : array [0..1] of PChar = ('Period', nil);
const   gpnUnit : array [0..1] of PChar = ('Unit', nil);
const   gpnNodeLayer : array [0..1] of PChar = ('NodeLayer', nil);
const   gpnNode : array [0..1] of PChar = ('Node', nil);
const   gpnElementLayer : array [0..1] of PChar = ('ElementLayer', nil);
const   gpnTime : array [0..1] of PChar = ('Time', nil);
const   gpnNumber : array [0..1] of PChar = ('Number', nil);

const   gOneIntegerTypes : array [0..1] of EPIENumberType = (kPIEInteger, 0);

const   gpnMFLayerNames : array [0..4] of PChar = ('Unit_Number', 'Unit_Top', 'Unit_Bottom', 'Elevation', nil);
const   gOneInteger3RealTypes : array [0..4] of EPIENumberType = (kPIEInteger, kPIEFloat, kPIEFloat, kPIEFloat, 0);

const   gpn2File : array [0..2] of PChar = ('Old_File_Name', 'New_File_Name', nil);
const   g2StringType : array [0..2] of EPIENumberType = (kPIEString, kPIEString, 0);



implementation

end.
