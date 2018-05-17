unit PolyhedronDataBaseUnit;

interface

uses
  SysUtils, Windows, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, PBFolderDialog, BDE, mDataBas, mQuery,
  mTable;

type
  EInvalidDatabase = class(Exception);

  TDataModulePolyhedron = class(TDataModule)
    DataSourcePointLocations: TDataSource;
    DataSourcePolyhedronLocations: TDataSource;

    DataSourcePolyhedronConnections: TDataSource;
    DataSourcePolyhedronBox: TDataSource;

    DataSourcePolyhedronBminBmax: TDataSource;
    mDataBaseSutraPolyhedrons: TmDataBase;
    mTablePointLocations: TmTable;
    mTablePolyhedronLocations: TmTable;
    mTablePolyhedronConnections: TmTable;
    mTablePolyhedronBox: TmTable;
    mTablePolyhedronBminBmax: TmTable;
    mTablePointLocationsNodeNumber: TIntegerField;
    mTablePointLocationsPolyhedronRadius: TFloatField;
    mTablePolyhedronLocationsID: TIntegerField;
    mTablePolyhedronLocationsNodeNumber: TIntegerField;
    mTablePolyhedronLocationsPosition: TIntegerField;
    mTablePolyhedronLocationsX: TFloatField;
    mTablePolyhedronLocationsY: TFloatField;
    mTablePolyhedronLocationsZ: TFloatField;
    mTablePolyhedronConnectionsID: TIntegerField;
    mTablePolyhedronConnectionsNodeNumber: TIntegerField;
    mTablePolyhedronConnectionsPosition: TIntegerField;
    mTablePolyhedronConnectionsFirst: TIntegerField;
    mTablePolyhedronConnectionsSecond: TIntegerField;
    mTablePolyhedronConnectionsThird: TIntegerField;
    mTablePolyhedronBoxID: TIntegerField;
    mTablePolyhedronBoxNodeNumber: TIntegerField;
    mTablePolyhedronBoxFace: TIntegerField;
    mTablePolyhedronBoxDimension: TIntegerField;
    mTablePolyhedronBoxMin: TFloatField;
    mTablePolyhedronBoxMax: TFloatField;
    mTablePolyhedronBminBmaxID: TIntegerField;
    mTablePolyhedronBminBmaxNodeNumber: TIntegerField;
    mTablePolyhedronBminBmaxDimension: TIntegerField;
    mTablePolyhedronBminBmaxMin: TFloatField;
    mTablePolyhedronBminBmaxMax: TFloatField;
  private
//    procedure DeleteDataBase(const ATable: TmTable);
    DataBaseRoot : string;
    procedure OpenTable(const ATable: TmTable);
    function DataBaseName : string;
    procedure NewDataBase;
    procedure DeleteDataBases;
    { private declarations }
  public
//    procedure AssignTableRoots(const TableRoot: string);
    procedure AssignDataBases(const DataBase: string);
    procedure CloseDataBases;
    procedure OpenDataBases;
//    procedure SelectDataBaseFolder(const TableRoot: string);
    { public declarations }
  end;

var
  DataModulePolyhedron: TDataModulePolyhedron;

implementation

{$R *.DFM}

uses FileCtrl;

resourcestring
  rsPolyhedronFile = 'Polyhedron.mdb';
  rsPointLocations = 'PointLocations';
  rsPolyhedronLocations = 'PolyhedronLocations';
  rsPolyhedronConnections = 'PolyhedronConnections';
  rsPolyhedronBox = 'PolyhedronBox';
  rsPolyhedronBminBmax = 'PolyhedronBminBmax';

var DLLName : string;


function GetDllFullPath(FileName :string ; var FullPath : String) : boolean ;
var
  AHandle : HWND;
  ModuleFileName : array[0..255] of char;
begin
  FullPath := '';
  AHandle := GetModuleHandle(PChar(FileName))  ;
  if AHandle = 0 then
  begin
    Result := False;
  end
  else
  begin
    if (GetModuleFileName(AHandle, @ModuleFileName[0],
       SizeOf(ModuleFileName)) > 0) then
    begin
      FullPath := ModuleFileName;
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;
end;
function GetDllDirectory(FileName :string ;
  var DllDirectory : String) : boolean ;
begin
  result :=  GetDllFullPath(FileName ,  DllDirectory );
  DllDirectory := ExtractFileDir(DllDirectory);
end;

function GetDLLName : string;
var
    FileCheck: array[0..255] of char;
begin
          GetModuleFileName(HInstance, Filecheck, 255);
          result := String(Filecheck)
end;


{procedure TDataModulePolyhedron.AssignTableRoots(const TableRoot : string);
  procedure AssignRoot(const ATable : TmTable; const EndName : string);
  begin
    ATable.Close;
    ATable.TableName := TableRoot + EndName;
  end;
begin
    AssignRoot(mTablePointLocations, rsPointLocations);
{    AssignRoot(TablePolyhedronLocations, rsPolyhedronLocations);
    AssignRoot(TablePolyhedronConnections, rsPolyhedronConnections);
    AssignRoot(TablePolyhedronBox, rsPolyhedronBox);
    AssignRoot(TablePolyhedronBminBmax, rsPolyhedronBminBmax);}
//end;

procedure TDataModulePolyhedron.AssignDataBases(const DataBase : string);
{  procedure AssignDataBase(const ATable : TmTable);
  begin
    ATable.Close;
    ATable.DatabaseName := DataBase;
  end;  }
var
  DBFFile : string;
begin
  DataBaseRoot := DataBase;
{  if (Session.FindDatabase(DataBase) <> nil)
    or DirectoryExists(DataBase) then
  begin  }
    DBFFile := DataBaseName;
//    if FileExists(DBFFile) then
//    begin
      mDataBaseSutraPolyhedrons.DriverCompletion :=  sdNoPrompt;
      mDataBaseSutraPolyhedrons.Params.Add('DBQ=' + DBFFile);
//    end;
//    mDataBaseSutraPolyhedrons.Params.Add(
//    AssignDataBase(mTablePointLocations);
{    AssignDataBase(TablePolyhedronLocations);
    AssignDataBase(TablePolyhedronConnections);
    AssignDataBase(TablePolyhedronBox);
    AssignDataBase(TablePolyhedronBminBmax);  }

{  end
  else
  begin
    raise EInvalidDatabase.Create(DataBase + ' does not exist');
  end;  }
end;

procedure TDataModulePolyhedron.OpenDataBases;
var
  DBFFile : string;
begin
  DBFFile := DataBaseName ;
//  mDataBaseSutraPolyhedrons.Params.Add('DBQ=' + DBFFile);
  if FileExists(DBFFile) then
  begin
    if MessageDlg('Have the locations of any of the nodes changed '
      + 'since the node locations were last stored?', mtInformation,
      [mbYes, mbNo], 0) = mrYes then
    begin
      DeleteDataBases;
      NewDataBase;
    end;
  end
  else
  begin
    NewDataBase;
  end;
  OpenTable(mTablePointLocations);
  OpenTable(mTablePolyhedronLocations);
  OpenTable(mTablePolyhedronConnections);
  OpenTable(mTablePolyhedronBox);
  OpenTable(mTablePolyhedronBminBmax);
end;

Procedure TDataModulePolyhedron.OpenTable(const ATable : TmTable);
begin
  ATable.Open;
end;

{procedure TDataModulePolyhedron.DeleteDataBase(const ATable : TmTable);
begin
//  if ATable.Exists then
//  begin
//    ATable.DeleteTable;
//  end;
end; }

procedure TDataModulePolyhedron.CloseDataBases;
begin
  mTablePointLocations.Close;
  mTablePolyhedronLocations.Close;
  mTablePolyhedronConnections.Close;
  mTablePolyhedronBox.Close;
  mTablePolyhedronBminBmax.Close;
end;

{procedure TDataModulePolyhedron.SelectDataBaseFolder(const TableRoot: string);
begin
  PBFolderDialog1.Folder := GetCurrentDir;
  if PBFolderDialog1.Execute then
  begin
//    AssignTableRoots(TableRoot);
    AssignDataBases(PBFolderDialog1.SelectedFolder)
  end;
end;  }

procedure TDataModulePolyhedron.DeleteDataBases;
var
  AName : string;
begin
  AName := DataBaseName;
  if FileExists(AName) then
  begin
    SysUtils.DeleteFile(AName);  
  end;
//  DeleteDataBase(mTablePointLocations);
{  DeleteDataBase(TablePolyhedronLocations);
  DeleteDataBase(TablePolyhedronConnections);
  DeleteDataBase(TablePolyhedronBox);
  DeleteDataBase(TablePolyhedronBminBmax); }

end;

function TDataModulePolyhedron.DataBaseName: string;
begin
  result := GetCurrentDir + '\' + DataBaseRoot + rsPolyhedronFile;
end;

procedure TDataModulePolyhedron.NewDataBase;
var
  DllDirectory : string;
  FileName : string;
  NewFileName : string;
begin
  if GetDllDirectory(DLLName, DllDirectory) then
  begin
    FileName := DllDirectory + '\' + rsPolyhedronFile;
    if FileExists(FileName) then
    begin
      NewFileName := DataBaseName;
      CopyFile(LPCTSTR(FileName), LPCTSTR(NewFileName), False);
    end
    else
    begin
      raise EInvalidDatabase.Create(FileName + ' not found.');
    end;
  end
  else
  begin
    raise EInvalidDatabase.Create(DllDirectory + '\ not found.');
  end;
end;
Initialization
begin
  // get the name of the current DLL.
  DLLName := GetDLLName;
end;


end.
