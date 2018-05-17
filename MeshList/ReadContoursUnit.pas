unit ReadContoursUnit;

interface

uses SysUtils, AnePIE, Classes, PlaneGeom;

type
  {
    @name respresents the points in an Argus ONE contour.
  }
  TContour = class(TObject)
  private
    // @name holds the locations of the nodes in the contour.
    FPoints: TPointArray;
    // @name returns the number of nodes in the contour.
    function GetCount: integer;
    function GetPoints(const Index: integer): TRealPoint;
  public
    // @name represents the point in the contour.
    property Points[const Index: integer]: TRealPoint read GetPoints;
    // @name gives the number of nodes in the contour.
    property Count: integer read GetCount;
  end;

  // @name represents the contours on an Argus ONE layer.
  TContourList = class(TObject)
  private
    // @name holds the contours.  Although declared as TList, it is
    // instantiated as a TObjectList.
    FContours: TList;
    // @name returns the capacity of @Link(FContours).
    function GetCapacity: integer;
    // @name sets the capacity of @Link(FContours);
    procedure SetCapacity(const Value: integer);
    // @name adds a @Link(TContour) to @Link(FContours).
    procedure Add(const Contour: TContour);
    // @name returns the number of contours in @Link(FContours);
    function GetCount: integer;
    // @name returns the contour in @Link(FContours) at the position indicated
    // by Index.
    function GetContours(const Index: integer): TContour;
    // Use @name to get or set the capacity of @Link(FContours).
    property Capacity: integer read GetCapacity write SetCapacity;
  public
    // @name clears @Link(FContours) and destroys all the contours it contains.
    procedure Clear;
    // @name creates an instance of @Link(TContourList).
    constructor Create;
    // @name destroys the current @Link(TContourList).  Do not call @name directly.
    // Call Free instead.
    destructor Destroy; override;
    // @name is the number of contours held by the @Link(TContourList).
    property Count: integer read GetCount;
    // @name is used to get the contour in the @Link(TContourList)
    // at the position indicated by Index.
    property Contours[const Index: integer]: TContour read GetContours; default;
  end;

procedure ReadContours(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

//procedure ClearContours(const refPtX: ANE_DOUBLE_PTR;
//  const refPtY: ANE_DOUBLE_PTR;
//  numParams: ANE_INT16;
//  const parameters: ANE_PTR_PTR;
//  funHandle: ANE_PTR;
//  reply: ANE_PTR); cdecl;

procedure ContourCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;

var
  ContourList: TContourList;

implementation

uses contnrs, ANECB, ParamArrayUnit, OptionsUnit, ContourIntersection,
  ReadMeshUnit;

procedure ReadContours(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  LayerName: ANE_STR;
  param: PParameter_array;
  LayerHandle: ANE_PTR;
  result: ANE_BOOL;
  Layer: TLayerOptions;
  ContourIndex: integer;
  Contour: TContour;
  ContourOptions: TContourObjectOptions;
  PointIndex: integer;
begin
  result := False;
  try
    try
      if numParams < 1 then
      begin
        Inc(ErrorCount);
        Exit;
      end;
      param := @parameters^;
      LayerName := param^[0];
      LayerHandle := ANE_LayerGetHandleByName(funHandle, LayerName);
      if LayerHandle = nil then
      begin
        Inc(ErrorCount);
        Exit;
      end;

      Layer := TLayerOptions.Create(LayerHandle);
      try
        ContourList.Capacity := Layer.NumObjects(funHandle, pieContourObject);

        for ContourIndex := 0 to ContourList.Capacity - 1 do
        begin
          Contour := TContour.Create;
          ContourList.Add(Contour);
          ContourOptions := TContourObjectOptions.Create(funHandle,
            LayerHandle, ContourIndex);
          try
            SetLength(Contour.FPoints, ContourOptions.NumberOfNodes(funHandle));

            for PointIndex := 0 to Length(Contour.FPoints) - 1 do
            begin
              ContourOptions.GetNthNodeLocation(funHandle,
                Contour.FPoints[PointIndex].X, Contour.FPoints[PointIndex].Y,
                PointIndex);
            end;
          finally
            ContourOptions.Free;
          end;
        end;
      finally
        Layer.Free(funHandle);
      end;

      IntersectWithCells;

      result := true;
    except
      Inc(ErrorCount);
      result := False;
    end;
  finally
    ANE_BOOL_PTR(reply)^ := result;
  end;
end;

//procedure ClearContours(const refPtX: ANE_DOUBLE_PTR;
//  const refPtY: ANE_DOUBLE_PTR;
//  numParams: ANE_INT16;
//  const parameters: ANE_PTR_PTR;
//  funHandle: ANE_PTR;
//  reply: ANE_PTR); cdecl;
//var
//  result: ANE_BOOL;
//begin
//  result := False;
//  try
//    try
//      ContourList.Clear;
//      ClearIntersectLists;
//
//      result := True;
//    except
//      Inc(ErrorCount);
//      result := False;
//    end;
//  finally
//    ANE_BOOL_PTR(reply)^ := result;
//  end;
//end;

procedure ContourCount(const refPtX: ANE_DOUBLE_PTR;
  const refPtY: ANE_DOUBLE_PTR;
  numParams: ANE_INT16;
  const parameters: ANE_PTR_PTR;
  funHandle: ANE_PTR;
  reply: ANE_PTR); cdecl;
var
  result: ANE_INT32;
begin
  result := -1;
  try
    try
      result := ContourList.Count;
    except
      Inc(ErrorCount);
    end;
  finally
    ANE_INT32_PTR(reply)^ := result;
  end;
end;

{ TContour }

function TContour.GetCount: integer;
begin
  result := Length(FPoints);
end;

function TContour.GetPoints(const Index: integer): TRealPoint;
begin
  result := FPoints[Index]
end;

{ TContourList }

procedure TContourList.Add(const Contour: TContour);
begin
  FContours.Add(Contour);
end;

procedure TContourList.Clear;
begin
  FContours.Clear;
end;

constructor TContourList.Create;
begin
  FContours := TObjectList.Create;
end;

destructor TContourList.Destroy;
begin
  FContours.Free;
  inherited;
end;

function TContourList.GetCapacity: integer;
begin
  result := FContours.Capacity;
end;

function TContourList.GetContours(const Index: integer): TContour;
begin
  result := FContours[Index];
end;

function TContourList.GetCount: integer;
begin
  result := FContours.Count;
end;

procedure TContourList.SetCapacity(const Value: integer);
begin
  FContours.Capacity := Value;
end;

initialization
  ContourList := TContourList.Create;

finalization
  ContourList.Free;

end.

