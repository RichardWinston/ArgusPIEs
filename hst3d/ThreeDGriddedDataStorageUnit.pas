unit ThreeDGriddedDataStorageUnit;

interface

uses Classes, ThreeDRealListUnit, FixNameUnit, IntListUnit, AnePIE, ANECB,
     SysUtils, RealListUnit, ThreeDIntListUnit, ANE_LayerUnit, Dialogs, Forms;

type
  EInvalidArraySize = Class(Exception);
  EUniformValues = Class(Exception);

type
  TintegerArray = Array[0..MAXINT div 8] of LongInt;
  PIntegerArray = ^TintegerArray;
  TDoubleArray = Array[0..MAXINT div 16] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = Array[0..MAXINT div 16] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..1] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;

type TCheckCellActive = function(X, Y, Z : Integer; DataValue : double)
  : boolean;
// TCheckCellActive should return true if a cell is active and
// thus should be plotted.
// TCheckCellActive should return false if a cell is inactive and
// thus should not be plotted.
// If multiple data sets will be plotted, TCheckCellActive will only
// be called for the first data set.

Type TPlotDirection = (ptXY, ptXZ, ptYZ);
// TPlotDirection determines the direction for plotting

type
  T3DGridStorage = Class(TObject)
  // T3DGridStorage is meant for storing a series of T3DRealList's each of
  // which represent a set of output data from a model.
  // Most of T3DGridStorage's properties and methods are similar to those
  // of TList except that it stores T3DRealList's instead of pointers.
  // T3DGridStorage can write data to an Argus ONE data layer using the
  // SetArgusData procedure.
  private
    FList : TList;
    // FList is a list of T3DRealList
    FNameList : TStringList;
    // FNameList is a list of names for the T3DRealList's in FList
    function GetDataSet(Index : Integer) : T3DRealList;
    procedure SetDataSet(Index : Integer;  A3DRealList : T3DRealList);
    function GetCount : integer;
    function GetCapacity : integer;
    procedure SetCapacity(ACapacity : Integer);
    function GetName(Index : Integer) : String;
    procedure SetName(Index : Integer; AName : String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(A3DRealList : T3DRealList; AName : string);
    procedure Clear;
    procedure Delete(Index: Integer);
    class procedure Error(const Msg: string; Data: Integer); virtual;
    procedure Exchange(Index1, Index2: Integer );
    function First: T3DRealList;
    function IndexOf(Item: T3DRealList): Integer;
    procedure Insert(Index: Integer; A3DRealList: T3DRealList; AName : string);
    function IsCellActive(X, Y, Z, DataSetIndex : Integer;
             CheckifActive : TCheckCellActive) : boolean;
    // IsCellActive returns the value of CheckifActive using the
    // data at X, Y, Z, in the data set indicated by DataSetIndex
    function Last: T3DRealList;
    procedure Move(CurIndex, NewIndex: Integer );
    procedure Pack;
    function Remove(Item: T3DRealList): Integer;
    procedure SetArgusData(DataSets : TIntegerList;
              APlotDirection : TPlotDirection;
              PlaneIndex : integer; CheckifActive : TCheckCellActive;
              anehandle : ANE_PTR; ADataLayerType: T_ANE_DataLayerClass;
              GridLayerName : string;
              XCoordinateList, YCoordinateList, ZCoordinateList : TRealList;
              ALayerList : T_ANE_LayerList; var dataLayerHandle : ANE_PTR;
              var MinX, MinY, MaxX, MaxY : double; var DataLayerName : string);
    // SetArgusData exports the data of selected data sets to Argus ONE
    // data layers.

    // DataSets is a list of the indicies of the data sets to be plotted.
    // For example if DataSets contains 1, 3, and 5, the T3DRealList's whose
    // indicies are 1, 3, and 5 would be the source of data for the data layer.

    // APlotDirection indicates whether the data should be plotted on the
    // XY, XZ, or YZ plane.

    // PlaneIndex indicates which cross section of the T3DRealList's to plot
    // For example if APlotDirection is XY and PlaneIndex = 2, the data to
    // be plotted would be a horizontal cross section through the T3DRealList's
    // at a Z-index of 2.

    // CheckifActive is a function that can be used to determine whether
    // a particular data set should be plotted or not. Any point for which
    // CheckifActive returns True will be plotted. CheckifActive is only tested
    // in the first data set that is plotted.

    // anehandle is the current model handle for Argus ONE.

    // ADataLayerType is a T_ANE_DataLayer class or one of its descendents.
    // This is the layer on which the data will be plotted.
    // If the layer does not already exist, it will be created.

    // GridLayerName is the name of the grid layer for the data. It is used
    // to determine the grid angle.

    // XCoordinateList, YCoordinateList, and ZCoordinateList are lists of
    // coordinates in the X, Y and Z directions respectively for the data.
    // Note that this assumes that this is a regular grid (as in HST3D).
    // In MODFLOW, the actual Z coordinates may not be the same for all layers
    // and thus this method would be inappropriate for drawing vertical cross
    // sections.

    // ALayerList is the layer list that will hold the ADataLayerType once it
    // is created.

    // dataLayerHandle is the handle of the new data layer that is created.
    // in SetArgusData.
    
    // MinX, MinY, MaxX, MaxY are the minimum and maximum X and Y cooridinates
    // of the data points in Argus ONE. These values are determined within
    // SetArgusData.
    Function NameList : TStringList;
    // NameList creates a new TStringList that is a copy of the names
    // of the data sets in FNameList. The resulting stringlist is not owned
    // by the T3DGridStorage so you must free this TStringList yourself.
    property Capacity : integer read GetCapacity write SetCapacity;
    Property Count : Integer read GetCount;
    property Items[Index : Integer] : T3DRealList
      read GetDataSet write SetDataSet;
    Property Names[Index : Integer] : string read GetName write SetName;
    // The Names property is used to accesses the names of individual data
    // sets.
  end;



implementation

uses LayerNamePrompt;

var
  UserResponse : integer = 1;


constructor T3DGridStorage.Create;
begin
  FList := TList.Create;
  FNameList := TStringList.Create;
end;

destructor T3DGridStorage.Destroy;
var
  index : integer;
  A3DRealList : T3DRealList;
begin
  for Index := FList.Count -1 downto 0 do
  begin
    A3DRealList := FList.Items[Index];
    A3DRealList.Free;
  end;
  FList.Clear;
  FList.Free;
  FNameList.Free;
end;

function T3DGridStorage.GetDataSet(Index : Integer) : T3DRealList;
begin
  result := FList.Items[Index];
end;

procedure T3DGridStorage.SetDataSet(Index : Integer;
   A3DRealList : T3DRealList);
var
  Stored3DRealList : T3DRealList;
begin
  Stored3DRealList := FList.Items[Index];
  if not (Stored3DRealList = A3DRealList) then
  begin
    if (Stored3DRealList.XCount = A3DRealList.XCount) and
       (Stored3DRealList.YCount = A3DRealList.YCount) and
       (Stored3DRealList.ZCount = A3DRealList.ZCount)
    then
       begin
         Stored3DRealList.Free;
         FList.Items[Index] := A3DRealList;
       end
    else
       begin
         raise EInvalidArraySize.Create('Error setting a T3DRealList in a ' +
               'T3DGridStorage because of invalid dimensions');
       end;
  end;
end;

procedure T3DGridStorage.Add(A3DRealList : T3DRealList; AName : string);
var
  Stored3DRealList : T3DRealList;
begin
  if FList.Count >0
  then
    begin
      Stored3DRealList := FList.Items[0];
      if (Stored3DRealList.XCount = A3DRealList.XCount) and
         (Stored3DRealList.YCount = A3DRealList.YCount) and
         (Stored3DRealList.ZCount = A3DRealList.ZCount)
      then
        begin
          FList.Add(A3DRealList);
          FNameList.Add('_');
          Names[FNameList.Count -1] := AName;
        end
      else
        begin
          raise EInvalidArraySize.Create('Error adding a T3DRealList to ' +
                'T3DGridStorage because of invalid dimensions');
        end;
    end
  else
    begin
      FList.Add(A3DRealList);
      FNameList.Add('_');
      Names[FNameList.Count -1] := AName;
    end;
end;

procedure T3DGridStorage.Clear;
begin
  FList.Clear;
end;

procedure T3DGridStorage.Delete(Index: Integer);
begin
  FList.Delete(Index);
  FNameList.Delete(Index);
end;

class procedure T3DGridStorage.Error(const Msg: string; Data: Integer);
begin
  TList.Error(Msg, Data);
end;

procedure T3DGridStorage.Exchange(Index1, Index2: Integer );
begin
  FList.Exchange(Index1, Index2);
  FNameList.Exchange(Index1, Index2);
end;

function T3DGridStorage.First: T3DRealList;
begin
  result := FList.First
end;

function T3DGridStorage.IndexOf(Item: T3DRealList): Integer;
begin
  result := FList.IndexOf(Item);
end;

procedure T3DGridStorage.Insert(Index: Integer; A3DRealList: T3DRealList;
  AName : string);
var
  Stored3DRealList : T3DRealList;
begin
  if FList.Count >0
  then
    begin
      Stored3DRealList := FList.Items[0];
      if (Stored3DRealList.XCount = A3DRealList.XCount) and
         (Stored3DRealList.YCount = A3DRealList.YCount) and
         (Stored3DRealList.ZCount = A3DRealList.ZCount)
      then
        begin
          FList.Insert(Index, A3DRealList);
          FNameList.Insert(Index, '_');
          Names[Index] := AName;
        end
      else
        begin
          raise EInvalidArraySize.Create('Error inserting a T3DRealList into ' +
                'T3DGridStorage because of invalid dimensions');
        end;
    end
  else
    begin
      FList.Insert(Index, A3DRealList);
      FNameList.Insert(Index, '_');
      Names[Index] := AName;
    end;


end;

function T3DGridStorage.Last: T3DRealList;
begin
  result := FList.Last
end;

procedure T3DGridStorage.Move(CurIndex, NewIndex: Integer );
begin
  FList.Move(CurIndex, NewIndex);
  FNameList.Move(CurIndex, NewIndex);
end;

procedure T3DGridStorage.Pack;
begin
  FList.Pack;
end;

function T3DGridStorage.Remove(Item: T3DRealList): Integer;
var
  Index : integer;
begin
  Index := FList.IndexOf(Item);
  FNameList.Delete(Index);
  result := FList.Remove(Item);
end;

function T3DGridStorage.GetCount : integer;
begin
  result := FList.Count;
end;

function T3DGridStorage.GetCapacity : integer;
begin
  result := FList.Capacity;
end;

procedure T3DGridStorage.SetCapacity(ACapacity : Integer);
begin
  FList.Capacity := ACapacity;
end;

function T3DGridStorage.GetName(Index : Integer) : String;
begin
  result := FNameList.Strings[Index];
end;

procedure T3DGridStorage.SetName(Index : Integer; AName : String);
begin
  if not (FNameList.Strings[Index] = AName) then
  begin
    // the FixArgusName function is in FixNameUnit
    FNameList.Strings[Index] := FixArgusName(AName);
  end;

end;

function T3DGridStorage.IsCellActive(X, Y, Z, DataSetIndex : Integer;
  CheckifActive : TCheckCellActive) : boolean;
begin
  result := CheckifActive(X, Y, Z, Items[DataSetIndex].Items[X, Y, Z]);
end;

Function T3DGridStorage.NameList : TStringList;
begin
  Result := TStringList.Create;
  Result.Assign(FNameList);
end;


procedure T3DGridStorage.SetArgusData(DataSets : TIntegerList;
          APlotDirection : TPlotDirection; PlaneIndex : integer;
          CheckifActive : TCheckCellActive ; anehandle  : ANE_PTR;
          ADataLayerType: T_ANE_DataLayerClass; GridLayerName : string;
          XCoordinateList, YCoordinateList, ZCoordinateList : TRealList;
          ALayerList : T_ANE_LayerList; var dataLayerHandle : ANE_PTR;
          var MinX, MinY, MaxX, MaxY : double; var DataLayerName : string);
var
  NodeNumberArray : T3DIntegerList;
  FirstNodeList, SecondNodeList, ThirdNodeList : TIntegerList;
  A3DRealList : T3DRealList;
  XIndex, YIndex, ZIndex : Integer;
  numDataParameters  : ANE_INT32;
  numPoints : ANE_INT32;
  i : Integer;
  j : Integer;
  posX : PDoubleArray;
  posY : PDoubleArray;
  dataParameters : pMatrix;
  paramNames : PParamNamesArray;
  k : double;
  numTriangles :		ANE_INT32   ;
  node0 :			PIntegerArray  ;
  node1 :			PIntegerArray  ;
  node2 :			PIntegerArray  ;
  NameIndex : integer;
  triangleIndex : Integer;
  gridLayerHandle : ANE_PTR;
  Angle, CosAngle, SinAngle : double;
  DelX, DelY : double;
  ADataLayer : T_ANE_DataLayer;
  MiniMaxIndex : integer;
  DataLayerTemplate : string;
  PreviousLayerHandle : ANE_PTR;
  DataLayerIndex : integer;
  minValue, maxValue, temp : double;
begin
  // Create Lists to hold the node numbers and the nodes on the corners
  // of the triangles.
  dataLayerHandle := nil;
  if DataSets.Count > 0 then
  begin
    FirstNodeList := TIntegerList.Create;
    SecondNodeList := TIntegerList.Create;
    ThirdNodeList := TIntegerList.Create;
    NodeNumberArray := nil;
    try
      begin
        // Check that dimensions are correct.
        A3DRealList := Items[DataSets.First];
        if not (A3DRealList.XCount = XCoordinateList.Count) or
           not (A3DRealList.YCount = YCoordinateList.Count) or
           not (A3DRealList.ZCount = ZCoordinateList.Count) then
        begin
          raise EInvalidArraySize.Create('Coordinate Lists differ in size from '
                 + 'the dimensions of the data set.');
        end;
        try
          begin
            NodeNumberArray := T3DIntegerList.Create(A3DRealList.XCount,
                           A3DRealList.YCount, A3DRealList.ZCount);
            numPoints := 0;

            // Fill Node List with node numbers. A "-1" indicates
            // that a node is inactive.
            // Also count number of points.
            case APlotDirection of
              ptXY:
                begin
                  ZIndex := PlaneIndex;
                  for XIndex := 0 to A3DRealList.XCount -1 do
                  begin
                    For YIndex := 0 to A3DRealList.YCount -1 do
                    begin
                      if IsCellActive(XIndex, YIndex, ZIndex, DataSets.First,
                            CheckifActive)
                      then
                        begin
                          NodeNumberArray.Items[XIndex,YIndex,ZIndex]
                            := numPoints;
                          Inc(numPoints);
                        end
                      else
                        begin
                          NodeNumberArray.Items[XIndex,YIndex,ZIndex] := -1;
                        end; // IsCellActive(XIndex, YIndex, ZIndex,
                             // DataSets.First,
                            //  CheckifActive)
                    end; // For YIndex := 0 to A3DRealList.YCount -1 do
                  end;  // for XIndex := 0 to A3DRealList.XCount -1 do
                end; // ptXY:

              ptXZ:
                begin
                  YIndex := PlaneIndex;
                  for XIndex := 0 to A3DRealList.XCount -1 do
                  begin
                    For ZIndex := 0 to A3DRealList.ZCount -1 do
                    begin
                      if IsCellActive(XIndex, YIndex, ZIndex, DataSets.First,
                            CheckifActive)
                      then
                        begin
                          NodeNumberArray.Items[XIndex,YIndex,ZIndex]
                            := numPoints;
                          Inc(numPoints);
                        end
                      else
                        begin
                          NodeNumberArray.Items[XIndex,YIndex,ZIndex] := -1;
                        end; // if IsCellActive(XIndex, YIndex, ZIndex,
                             // DataSets.First,
                            //  CheckifActive)
                    end;  // For ZIndex := 0 to A3DRealList.ZCount -1 do
                  end;  //  for XIndex := 0 to A3DRealList.XCount -1 do
                end; // ptXZ:

              ptYZ:
                begin
                  XIndex := PlaneIndex;
                  for YIndex := 0 to A3DRealList.YCount -1 do
                  begin
                    For ZIndex := 0 to A3DRealList.ZCount -1 do
                    begin
                      if IsCellActive(XIndex, YIndex, ZIndex, DataSets.First,
                            CheckifActive)
                      then
                        begin
                          NodeNumberArray.Items[XIndex,YIndex,ZIndex]
                            := numPoints;
                          Inc(numPoints);
                        end
                      else
                        begin
                          NodeNumberArray.Items[XIndex,YIndex,ZIndex] := -1;
                        end; // IsCellActive(XIndex, YIndex, ZIndex,
                             // DataSets.First,
                            //    CheckifActive)
                    end; // For ZIndex := 0 to A3DRealList.ZCount -1 do
                  end; // for YIndex := 0 to A3DRealList.YCount -1 do
                end; //  ptYZ:
            end;  //  case APlotType of



            // Fill lists of triangle node numbers.
            case APlotDirection of
              ptXY:
                begin
                  ZIndex := PlaneIndex;
                  for XIndex := 0 to A3DRealList.XCount -1 do
                  begin
                    For YIndex := 0 to A3DRealList.YCount -1 do
                    begin
                      if IsCellActive(XIndex, YIndex, ZIndex, DataSets.First,
                            CheckifActive)
                      then
                        begin
                          if (XIndex > 0) and (YIndex < A3DRealList.YCount -1)
                             and not IsCellActive(XIndex-1, YIndex, ZIndex,
                                 DataSets.First, CheckifActive)
                             and IsCellActive(XIndex-1, YIndex+1, ZIndex,
                                 DataSets.First, CheckifActive)
                             and IsCellActive(XIndex, YIndex+ 1, ZIndex,
                                 DataSets.First, CheckifActive)
                          then
                            begin
                                //   +---+
                                //    \  |
                                //     \ |
                                //      \|
                                //      (*)
                              FirstNodeList.Add(NodeNumberArray.Items
                                [XIndex,YIndex,ZIndex]);
                              SecondNodeList.Add(NodeNumberArray.Items
                                [XIndex,YIndex+1,ZIndex]);
                              ThirdNodeList.Add(NodeNumberArray.Items
                                [XIndex-1,YIndex+1,ZIndex]);
                            end;

                          if (XIndex < A3DRealList.XCount -1)
                             and (YIndex < A3DRealList.YCount -1)
                             and  IsCellActive(XIndex+1, YIndex+ 1, ZIndex,
                                 DataSets.First, CheckifActive)
                          then
                            begin
                              if IsCellActive(XIndex+1, YIndex, ZIndex,
                                 DataSets.First, CheckifActive)
                              then
                                begin
                                   //           +
                                   //          /|
                                   //         / |
                                   //        /  |
                                   //      (*)--+                                                                   
                                  FirstNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex]);
                                  SecondNodeList.Add(NodeNumberArray.Items
                                    [XIndex+1,YIndex,ZIndex]);
                                  ThirdNodeList.Add(NodeNumberArray.Items
                                    [XIndex+1,YIndex+1,ZIndex]);
                                end;
                              if IsCellActive(XIndex, YIndex+1, ZIndex,
                                 DataSets.First, CheckifActive)
                              then
                                begin
                                   //       +---+
                                   //       |  /
                                   //       | /
                                   //       |/
                                   //      (*)
                                  FirstNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex]);
                                  SecondNodeList.Add(NodeNumberArray.Items
                                    [XIndex+1,YIndex+1,ZIndex]);
                                  ThirdNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex+1,ZIndex]);
                                end;
                            end // if (XIndex < A3DRealList.XCount -1)
                                 // and (YIndex < A3DRealList.YCount -1)
                                 // and  IsCellActive(XIndex+1, YIndex+ 1,
                                 // ZIndex,
                                 //  DataSets.First, CheckifActive)
                          else if (XIndex < A3DRealList.XCount -1)
                                  and (YIndex < A3DRealList.YCount -1)
                                  and IsCellActive(XIndex+1, YIndex, ZIndex,
                                        DataSets.First, CheckifActive) and
                                  IsCellActive(XIndex, YIndex+ 1, ZIndex,
                                        DataSets.First, CheckifActive)
                          then
                            begin
                                //       +
                                //       |\
                                //       | \
                                //       |  \
                                //      (*)--+
                                  FirstNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex]);
                                  SecondNodeList.Add(NodeNumberArray.Items
                                    [XIndex+1,YIndex,ZIndex]);
                                  ThirdNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex+1,ZIndex]);
                            end; // else if IsCellActive(XIndex+1, YIndex,
                                 // ZIndex,
                                 //       DataSets.First, CheckifActive) and
                                 // IsCellActive(XIndex, YIndex+ 1, ZIndex,
                                 //       DataSets.First, CheckifActive)
                        end; // IsCellActive(XIndex, YIndex, ZIndex,
                             // DataSets.First,
                            //  CheckifActive)
                    end; // For YIndex := 0 to A3DRealList.YCount -1 do
                  end;  // for XIndex := 0 to A3DRealList.XCount -1 do
                end; // ptXY:

              ptXZ:
                begin
                  YIndex := PlaneIndex;
                  for XIndex := 0 to A3DRealList.XCount -1 do
                  begin
                    For ZIndex := 0 to A3DRealList.ZCount -1 do
                    begin
                      if IsCellActive(XIndex, YIndex, ZIndex, DataSets.First,
                            CheckifActive)
                      then
                        begin
                          if (XIndex > 0) and (ZIndex < A3DRealList.ZCount -1)
                             and not IsCellActive(XIndex-1, YIndex, ZIndex,
                                 DataSets.First, CheckifActive)
                             and IsCellActive(XIndex-1, YIndex, ZIndex+1,
                                 DataSets.First, CheckifActive)
                             and IsCellActive(XIndex, YIndex, ZIndex+ 1,
                                 DataSets.First, CheckifActive)
                          then
                            begin
                               //   +---+
                               //    \  |
                               //     \ |
                               //      \|
                               //      (*)
                              FirstNodeList.Add(NodeNumberArray.Items
                                [XIndex,YIndex,ZIndex]);
                              SecondNodeList.Add(NodeNumberArray.Items
                                [XIndex,YIndex,ZIndex+1]);
                              ThirdNodeList.Add(NodeNumberArray.Items
                                [XIndex-1,YIndex,ZIndex+1]);
                            end;

                          if (XIndex < A3DRealList.XCount -1)
                             and (ZIndex < A3DRealList.ZCount -1)
                             and  IsCellActive(XIndex+1, YIndex, ZIndex+ 1,
                                 DataSets.First, CheckifActive)
                          then
                            begin
                              if IsCellActive(XIndex+1, YIndex, ZIndex,
                                 DataSets.First, CheckifActive)
                              then
                                begin
                                   //           +
                                   //          /|
                                   //         / |
                                   //        /  |
                                   //      (*)--+
                                  FirstNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex]);
                                  SecondNodeList.Add(NodeNumberArray.Items
                                    [XIndex+1,YIndex,ZIndex]);
                                  ThirdNodeList.Add(NodeNumberArray.Items
                                    [XIndex+1,YIndex,ZIndex+1]);
                                end;  //  if IsCellActive(XIndex+1, YIndex,
                                      // ZIndex,
                                      //     DataSets.First, CheckifActive)
                              if IsCellActive(XIndex, YIndex, ZIndex+1,
                                 DataSets.First, CheckifActive)
                              then
                                begin
                                  //       +---+
                                  //       |  /
                                  //       | /
                                  //       |/
                                  //      (*)
                                  FirstNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex]);
                                  SecondNodeList.Add(NodeNumberArray.Items
                                    [XIndex+1,YIndex,ZIndex+1]);
                                  ThirdNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex+1]);
                                end;  // if IsCellActive(XIndex, YIndex,
                                      // ZIndex+1,
                                      //    DataSets.First, CheckifActive)

                            end // if (XIndex < A3DRealList.XCount -1)
                                 // and (YIndex < A3DRealList.YCount -1)
                                 // and  IsCellActive(XIndex+1, YIndex+ 1,
                                 // ZIndex,
                                 //  DataSets.First, CheckifActive)
                          else if (XIndex < A3DRealList.XCount -1)
                             and (ZIndex < A3DRealList.ZCount -1)
                             and IsCellActive(XIndex+1, YIndex, ZIndex,
                                        DataSets.First, CheckifActive) and
                                  IsCellActive(XIndex, YIndex, ZIndex+ 1,
                                        DataSets.First, CheckifActive)
                          then
                            begin
                                 //       +
                                 //       |\
                                 //       | \
                                 //       |  \
                                 //      (*)--+
                                  FirstNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex]);
                                  SecondNodeList.Add(NodeNumberArray.Items
                                    [XIndex+1,YIndex,ZIndex]);
                                  ThirdNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex+1]);
                            end; //  else if IsCellActive(XIndex+1, YIndex,
                                 //     ZIndex,
                                 //     DataSets.First, CheckifActive) and
                                 //     IsCellActive(XIndex, YIndex, ZIndex+ 1,
                                 //     DataSets.First, CheckifActive)
                        end; // if IsCellActive(XIndex, YIndex, ZIndex,
                             // DataSets.First,
                            //  CheckifActive)
                    end;  // For ZIndex := 0 to A3DRealList.ZCount -1 do
                  end;  //  for XIndex := 0 to A3DRealList.XCount -1 do
                end; // ptXZ:

              ptYZ:
                begin
                  XIndex := PlaneIndex;
                  for YIndex := 0 to A3DRealList.YCount -1 do
                  begin
                    For ZIndex := 0 to A3DRealList.ZCount -1 do
                    begin
                      if IsCellActive(XIndex, YIndex, ZIndex, DataSets.First,
                            CheckifActive)
                      then
                        begin
                          if (YIndex > 0) and (ZIndex < A3DRealList.ZCount -1)
                             and not IsCellActive(XIndex, YIndex-1, ZIndex,
                                 DataSets.First, CheckifActive)
                             and IsCellActive(XIndex, YIndex-1, ZIndex+1,
                                 DataSets.First, CheckifActive)
                             and IsCellActive(XIndex, YIndex, ZIndex+ 1,
                                 DataSets.First, CheckifActive)
                          then
                            begin
                              //   +---+
                              //    \  |
                              //     \ |
                              //      \|
                              //      (*)
                              FirstNodeList.Add(NodeNumberArray.Items
                                [XIndex,YIndex,ZIndex]);
                              SecondNodeList.Add(NodeNumberArray.Items
                                [XIndex,YIndex,ZIndex+1]);
                              ThirdNodeList.Add(NodeNumberArray.Items
                                [XIndex,YIndex-1,ZIndex+1]);
                            end;

                          if (YIndex < A3DRealList.YCount -1)
                             and (ZIndex < A3DRealList.ZCount -1)
                             and  IsCellActive(XIndex, YIndex+1, ZIndex+ 1,
                                 DataSets.First, CheckifActive)
                          then
                            begin
                              if IsCellActive(XIndex, YIndex+1, ZIndex,
                                 DataSets.First, CheckifActive)
                              then
                                begin
                                  //           +
                                  //          /|
                                  //         / |
                                  //        /  |
                                  //      (*)--+
                                  FirstNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex]);
                                  SecondNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex+1,ZIndex]);
                                  ThirdNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex+1,ZIndex+1]);
                                end; //  if IsCellActive(XIndex, YIndex+1,
                                     //  ZIndex,
                                     //     DataSets.First, CheckifActive)
                              if IsCellActive(XIndex, YIndex, ZIndex+1,
                                 DataSets.First, CheckifActive)
                              then
                                begin
                                  //       +---+
                                  //       |  /
                                  //       | /
                                  //       |/
                                  //      (*)
                                  FirstNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex]);
                                  SecondNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex+1,ZIndex+1]);
                                  ThirdNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex+1]);
                                end; // if IsCellActive(XIndex, YIndex,ZIndex+1,
                                     //    DataSets.First, CheckifActive)

                            end //    if (YIndex < A3DRealList.YCount -1)
                                 //      and (ZIndex < A3DRealList.ZCount -1)
                                 //      and  IsCellActive(XIndex, YIndex+1,
                                 //       ZIndex+ 1,
                                 //          DataSets.First, CheckifActive)
                          else if (YIndex < A3DRealList.YCount -1)
                             and (ZIndex < A3DRealList.ZCount -1)
                             and IsCellActive(XIndex, YIndex+1, ZIndex,
                                        DataSets.First, CheckifActive) and
                                  IsCellActive(XIndex, YIndex, ZIndex+ 1,
                                        DataSets.First, CheckifActive)
                          then
                            begin
                                //       +
                                //       |\
                                //       | \
                                //       |  \
                                //      (*)--+
                                  FirstNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex]);
                                  SecondNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex+1,ZIndex]);
                                  ThirdNodeList.Add(NodeNumberArray.Items
                                    [XIndex,YIndex,ZIndex+1]);
                            end; //  else if IsCellActive(XIndex, YIndex+1,
                                 // ZIndex,
                                 //   DataSets.First, CheckifActive) and
                                 //   IsCellActive(XIndex, YIndex, ZIndex+ 1,
                                 //   DataSets.First, CheckifActive)
                        end; // IsCellActive(XIndex, YIndex, ZIndex,
                             // DataSets.First,
                            //    CheckifActive)
                    end; // For ZIndex := 0 to A3DRealList.ZCount -1 do
                  end; // for YIndex := 0 to A3DRealList.YCount -1 do
                end; //  ptYZ:
            end; // case APlotType of

            // Set numTriangles and numDataParameters
            numTriangles := FirstNodeList.Count;
            numDataParameters := DataSets.Count;

            // allocate memory for arrays to be passed to Argus ONE.
            GetMem(posX, numPoints*SizeOf(double));
            GetMem(posY, numPoints*SizeOf(double));
            GetMem(dataParameters, numDataParameters*SizeOf(pMatrix));
            GetMem(node0, numTriangles*SizeOf(longInt));
            GetMem(node1, numTriangles*SizeOf(longInt));
            GetMem(node2, numTriangles*SizeOf(longInt));
            GetMem(paramNames, numDataParameters*SizeOf(ANE_STR));
            try
              begin
                FOR j := 0 TO numDataParameters-1 DO
                  begin
                     GetMem(dataParameters[j], numPoints*SizeOf(DOUBLE));
                  end;

                // Fill name array.
                for NameIndex := 0 to DataSets.Count -1 do
                begin
                  assert(NameIndex < numDataParameters);
                  paramNames^[NameIndex]
                    := PChar(FNameList.Strings[DataSets.items[NameIndex]]);
                end;

                // Fill NodeArrays
                for triangleIndex := 0 to FirstNodeList.Count -1 do
                begin
                  assert(triangleIndex<numTriangles);
                  node0^[triangleIndex] := FirstNodeList.Items[triangleIndex];
                  node1^[triangleIndex] := SecondNodeList.Items[triangleIndex];
                  node2^[triangleIndex] := ThirdNodeList.Items[triangleIndex];
                end;

                // Fill array of data values
                FOR j := 0 TO numDataParameters - 1 DO  // number of parameters
                BEGIN
                  A3DRealList := Items[DataSets.Items[j]];
                  i := 0;
                  case APlotDirection of
                    ptXY:
                      begin
                        ZIndex := PlaneIndex;
                        for XIndex := 0 to A3DRealList.XCount -1 do
                        begin
                          For YIndex := 0 to A3DRealList.YCount -1 do
                          begin
                            if IsCellActive(XIndex, YIndex, ZIndex,
                                  DataSets.First, CheckifActive)
                            then
                              begin
                                assert(i < numpoints);
                                assert(j < numDataParameters);
                                dataParameters[j]^[i]
                                  := A3DRealList.Items[XIndex,YIndex,ZIndex];
                                Inc(i);
                              end; // IsCellActive(XIndex, YIndex, ZIndex,
                                   // DataSets.First,
                                  //  CheckifActive)
                          end; // For YIndex := 0 to A3DRealList.YCount -1 do
                        end;  // for XIndex := 0 to A3DRealList.XCount -1 do
                      end; // ptXY:

                    ptXZ:
                      begin
                        YIndex := PlaneIndex;
                        for XIndex := 0 to A3DRealList.XCount -1 do
                        begin
                          For ZIndex := 0 to A3DRealList.ZCount -1 do
                          begin
                            if IsCellActive(XIndex, YIndex, ZIndex,
                                 DataSets.First, CheckifActive)
                            then
                              begin
                                assert(i < numpoints);
                                assert(j < numDataParameters);
                                dataParameters[j]^[i]
                                  := A3DRealList.Items[XIndex,YIndex,ZIndex];
                                Inc(i);
                              end; // if IsCellActive(XIndex, YIndex, ZIndex,
                                   // DataSets.First,
                                  //  CheckifActive)
                          end;  // For ZIndex := 0 to A3DRealList.ZCount -1 do
                        end;  //  for XIndex := 0 to A3DRealList.XCount -1 do
                      end; // ptXZ:

                    ptYZ:
                      begin
                        XIndex := PlaneIndex;
                        for YIndex := 0 to A3DRealList.YCount -1 do
                        begin
                          For ZIndex := 0 to A3DRealList.ZCount -1 do
                          begin
                            if IsCellActive(XIndex, YIndex, ZIndex,
                                 DataSets.First, CheckifActive)
                            then
                              begin
                                assert(i < numpoints);
                                assert(j < numDataParameters);
                                dataParameters[j]^[i]
                                  := A3DRealList.Items[XIndex,YIndex,ZIndex];
                                Inc(i);
                              end; // IsCellActive(XIndex, YIndex, ZIndex,
                                   // DataSets.First,
                                  //    CheckifActive)
                          end; // For ZIndex := 0 to A3DRealList.ZCount -1 do
                        end; // for YIndex := 0 to A3DRealList.YCount -1 do
                      end; //  ptYZ:
                  end;  //  case APlotType of
                END; // FOR j := 0 TO numDataParameters - 1 DO

                // test for uniform values. Abort if values are uniform to
                // prevent Argus ONE from crashing.
                for J := 0 to numDataParameters - 1 do
                begin
                  minValue := 0;
                  maxValue := 0;
                  if numpoints > 0 then
                  begin
                    minValue := dataParameters[j]^[0];
                    maxValue := dataParameters[j]^[0];
                  end;
                  for i := 1 to numpoints -1 do
                  begin
                    temp := dataParameters[j]^[i];
                    if minValue > temp then
                    begin
                      minValue := temp;
                    end; // if minValue > temp then
                    if maxValue < temp then
                    begin
                      maxValue := temp;
                    end; // if maxValue < temp then
                  end; // for i := 0 to numpoints -1 do
                  if (minValue = maxValue) then
                  begin
                    raise EUniformValues.Create('Aborting: data values '
                      + 'are uniform for data set ' + IntToStr(J+1));
                  end;
                end; // for J := 0 to numDataParameters - 1 do



                // Fill arrays of coordinate locations
                i := 0;
                case APlotDirection of
                  ptXY:
                    begin
                      // Get grid layer handle.
                      gridLayerHandle
                        := ANE_LayerGetHandleByName(anehandle,
                            PChar(GridLayerName)  );

                      // Get grid angle
                      ANE_EvaluateStringAtLayer(aneHandle, gridLayerHandle,
                          kPIEFloat,
                          'If(IsNA(GridAngle()), 0.0, GridAngle())', @Angle);
                      CosAngle := Cos(Angle);
                      SinAngle := Sin(Angle);

                      ZIndex := PlaneIndex;
                      for XIndex := 0 to A3DRealList.XCount -1 do
                      begin
                        For YIndex := 0 to A3DRealList.YCount -1 do
                        begin
                          if IsCellActive(XIndex, YIndex, ZIndex,
                                DataSets.First, CheckifActive)
                          then
                            begin
                              assert(i< numpoints);
                              if Angle = 0
                              then
                                begin
                                  posX^[i] := XCoordinateList.Items[XIndex];
                                  posY^[i] := YCoordinateList.Items[YIndex];
                                end
                              else
                                begin
                                  posX^[i]
                                    := XCoordinateList.Items[XIndex]*CosAngle -
                                       YCoordinateList.Items[YIndex]*SinAngle;

                                  posY^[i]
                                    := XCoordinateList.Items[XIndex]*SinAngle +
                                       YCoordinateList.Items[YIndex]*CosAngle;

                                end;
                              Inc(i);
                            end; // IsCellActive(XIndex, YIndex, ZIndex,
                                 // DataSets.First,
                                //  CheckifActive)
                        end; // For YIndex := 0 to A3DRealList.YCount -1 do
                      end;  // for XIndex := 0 to A3DRealList.XCount -1 do
                    end; // ptXY:

                  ptXZ:
                    begin
                      YIndex := PlaneIndex;
                      for XIndex := 0 to A3DRealList.XCount -1 do
                      begin
                        For ZIndex := 0 to A3DRealList.ZCount -1 do
                        begin
                          if IsCellActive(XIndex, YIndex, ZIndex,
                               DataSets.First, CheckifActive)
                          then
                            begin
                                  assert(i< numpoints);
                                  posX^[i] := XCoordinateList.Items[XIndex];
                                  posY^[i] := ZCoordinateList.Items[ZIndex];
                              Inc(i);
                            end; // if IsCellActive(XIndex, YIndex, ZIndex,
                                //  DataSets.First, CheckifActive)
                        end;  // For ZIndex := 0 to A3DRealList.ZCount -1 do
                      end;  //  for XIndex := 0 to A3DRealList.XCount -1 do
                    end; // ptXZ:

                  ptYZ:
                    begin
                      XIndex := PlaneIndex;
                      for YIndex := 0 to A3DRealList.YCount -1 do
                      begin
                        For ZIndex := 0 to A3DRealList.ZCount -1 do
                        begin
                          if IsCellActive(XIndex, YIndex, ZIndex,
                               DataSets.First, CheckifActive)
                          then
                            begin
                                  assert(i< numpoints);
                                  posX^[i] := YCoordinateList.Items[YIndex];
                                  posY^[i] := ZCoordinateList.Items[ZIndex];
                              Inc(i);
                            end; // IsCellActive(XIndex, YIndex, ZIndex,
                                //   DataSets.First, CheckifActive)
                        end; // For ZIndex := 0 to A3DRealList.ZCount -1 do
                      end; // for YIndex := 0 to A3DRealList.YCount -1 do
                    end; //  ptYZ:
                end;  //  case APlotType of

                MinX := 0;
                MinY := 0;
                MaxX := 0;
                MaxY := 0;

                if numpoints > 0
                then
                  begin
                    MinX := posX^[0];
                    MinY := posY^[0];
                    MaxX := posX^[0];
                    MaxY := posY^[0];
                  end;

                for MiniMaxIndex := 0 to numpoints -1 do
                begin
                        if posX^[MiniMaxIndex] < MinX
                        then
                          begin
                            assert (MiniMaxIndex < numpoints);
                            MinX := posX^[MiniMaxIndex]
                          end
                        else if posX^[MiniMaxIndex] > MaxX
                        then
                          begin
                            assert (MiniMaxIndex < numpoints);
                            MaxX := posX^[MiniMaxIndex]
                          end;

                        if posY^[MiniMaxIndex] < MinY
                        then
                          begin
                            assert (MiniMaxIndex < numpoints);
                            MinY := posY^[MiniMaxIndex]
                          end
                        else if posY^[MiniMaxIndex] > MaxY
                        then
                          begin
                            assert (MiniMaxIndex < numpoints);
                            MaxY := posY^[MiniMaxIndex]
                          end;
                end;
                DataLayerName := ADataLayerType.ANE_LayerName ;
                dataLayerHandle := ANE_LayerGetHandleByName(anehandle,
                  PChar(DataLayerName)  );

                if (dataLayerHandle = nil)
                then
                  begin
                    ADataLayer := ADataLayerType.Create(ALayerList, -1);
                    try
                      DataLayerTemplate := ADataLayer.WriteLayer(anehandle);
                      PreviousLayerHandle := nil; // if the previous layer is not
                      // set to nil there is an access violation if the new data
                      // layer is not the last layer.
                      DataLayerName := ADataLayer.WriteSpecialBeginning
                              + ADataLayer.ANE_LayerName
                              + ADataLayer.WriteSpecialMiddle
                              + ADataLayer.WriteIndex
                              + ADataLayer.WriteSpecialEnd;
                      dataLayerHandle := ANE_LayerAddByTemplate(anehandle,
                         PChar(DataLayerTemplate),
                         PreviousLayerHandle );
                    finally
                      ADataLayer.Free;
                    end;
                  end
                else
                  begin
                    GetValidLayer(anehandle, dataLayerHandle, ADataLayerType,
                      DataLayerName, ALayerList, UserResponse);
                    {DataLayerIndex := 0;
                    while dataLayerHandle <> nil do
                    begin
                      Inc( DataLayerIndex);
                      DataLayerName := ADataLayerType.ANE_LayerName +
                        IntToStr(DataLayerIndex) ;
                      dataLayerHandle := ANE_LayerGetHandleByName(anehandle,
                        PChar(DataLayerName)  );
                    end;
                    frmLayerNamePrompt := TfrmLayerNamePrompt.Create(Application);
                    try
                      frmLayerNamePrompt.lblLayerName.Caption := ADataLayerType.ANE_LayerName;
                      frmLayerNamePrompt.EdNewName.Text
                        := ADataLayerType.ANE_LayerName + IntToStr(DataLayerIndex);
                      frmLayerNamePrompt.ShowModal;
                      if frmLayerNamePrompt.rgAnswer.ItemIndex = 0 then
                      begin
                        DataLayerName := ADataLayerType.ANE_LayerName ;
                        dataLayerHandle := ANE_LayerGetHandleByName(anehandle,
                          PChar(DataLayerName)  );
                      end
                      else
                      begin
                        DataLayerName
                          := FixArgusName(frmLayerNamePrompt.EdNewName.Text);
                        dataLayerHandle := ANE_LayerGetHandleByName(anehandle,
                          PChar(FixArgusName(frmLayerNamePrompt.EdNewName.Text)));
                        if dataLayerHandle = nil then
                        begin
                          ADataLayer := ADataLayerType.Create(ALayerList, -1);
                          try
                            ADataLayer.DataIndex := DataLayerIndex;
                            DataLayerTemplate := ADataLayer.WriteLayer(anehandle);
                            PreviousLayerHandle := nil; // if the previous layer is not
                            // set to nil there is an access violation if the new data
                            // layer is not the last layer.
                            dataLayerHandle := ANE_LayerAddByTemplate(anehandle,
                               PChar(DataLayerTemplate),
                               PreviousLayerHandle );
                            if (ADataLayer.WriteSpecialBeginning
                              + ADataLayer.ANE_LayerName
                              + ADataLayer.WriteSpecialMiddle
                              + ADataLayer.WriteIndex
                              + ADataLayer.WriteSpecialEnd
                              <> FixArgusName(frmLayerNamePrompt.EdNewName.Text)) then
                            begin
                              ANE_LayerRename(anehandle, dataLayerHandle,
                                PChar(FixArgusName(frmLayerNamePrompt.EdNewName.Text)));
                            end;

                          finally
                            ADataLayer.Free;
                          end;
                        end;
                      end;


                    finally
                      frmLayerNamePrompt.Free;

                    end;}

                  end;
                if dataLayerHandle = nil
                then
                  begin
                    Beep;
                    ShowMessage('Error creating data layer');
                  end
                else
                  begin
                      // the access violation would occur here.
                      ANE_DataLayerSetTriangulatedData(aneHandle ,
                                    dataLayerHandle ,
                                    numPoints, // :	  ANE_INT32   ;
                                    @posX^, //:		  ANE_DOUBLE_PTR  ;
                                    @posY^, // :	    ANE_DOUBLE_PTR   ;
                                    numTriangles, //:	  ANE_INT32   ;
                                    @node0^, //:	  	ANE_INT32_PTR  ;
                                    @node1^, //:	  	ANE_INT32_PTR  ;
                                    @node2^, //:	  	ANE_INT32_PTR  ;
                                    numDataParameters, // : ANE_INT32     ;
                                    @dataParameters^, // : ANE_DOUBLE_PTR_PTR  ;
                                    @paramNames^  );
                  end; // if dataLayerHandle = nil else

              end;
            finally
              begin
                // free memory of arrays passed to Argus ONE.
                FOR j := numDataParameters-1 DOWNTO 0 DO
                  begin
                    assert(j < numDataParameters);
                    FreeMem(dataParameters[j]);
                  end;
                FreeMem(dataParameters  );
                FreeMem(posY, numPoints*SizeOf(double));
                FreeMem(posX, numPoints*SizeOf(double));
                FreeMem(node0, numTriangles*SizeOf(longInt));
                FreeMem(node1, numTriangles*SizeOf(longInt));
                FreeMem(node2, numTriangles*SizeOf(longInt));
                FreeMem(paramNames, numDataParameters*SizeOf(ANE_STR));
              end;
            end;


          end
        finally
          begin
            // Free NodeNumberArray
            NodeNumberArray.Free;
          end;
        end;


      end;
    finally
      begin
        // Free Node Lists.
        FirstNodeList.Free;
        SecondNodeList.Free;
        ThirdNodeList.Free;
      end;
    end;
  end;

end;

end.
