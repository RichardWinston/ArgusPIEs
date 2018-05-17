unit QuadtreeClass;
//*******************************************************
// Quadtree class.
//*******************************************************

interface

uses Windows, Graphics, sysutils, Classes, contnrs;

const MAX_QTREE_NODES = 100;

type
  TNorthOrSouth = (North, South);
  TEastOrWest = (East, West);

  TQPoint = record
    X: double;
    Y: double;
    Data : Integer;
  end;

  TExpandDirection = (edNorth, edSouth, edEast, edWest);

// TDestroyDataProcedure is used in TQuadTree.Create for the
// DestroyDataProcedure parameter;
// If DestroyDataProcedure is not equal to nil, it is used to destroy a datum
// added via TQuadTree.AddPoint.
// (In other words, if DestroyDataProcedure <> nil, the TQuadTree owns the data.)
//  TDestroyDataProcedure = procedure(Data : Pointer);

  EQTreeError = Class(Exception);

  TQtreeNode = class(TObject)
  protected
//    FDestroyProcedure : TDestroyDataProcedure;
    Children               : array [TNorthOrSouth, TEastOrWest] of TQtreeNode;
    Xmin, Xmax, Ymin, Ymax : double;
    Pts                    : array of TQPoint;
    NumPts                 : Integer;
    procedure AddPoint(X, Y : double; Data : integer);
    procedure CheckNearbyLeaves(exclude : TQtreeNode;
      var best_leaf : TQtreeNode; X, Y : double; var best_i : integer;
      var best_dist2, best_dist : double);
    constructor Create(x_min, x_max, y_min, y_max : double{; DestroyDataProcedure : TDestroyDataProcedure});
    procedure ExpandBounds(XY : double; ExpandDirection : TExpandDirection);
    procedure FindPoint(var X, Y : double; var Data : integer);
    function LocateLeaf(X, Y : double; Siblings : TStack) : TQtreeNode;
    procedure NearPointInLeaf(X, Y : double; var best_i : integer;
      var best_dist2 : double);
    function Xmid : double;
    function Ymid : double;
  public
    destructor Destroy; override;
  end;

  TQuadTree = class(TObject)
    private
      FQTreeNode : TQtreeNode;
      function GetXMax : double;
      function GetXMin : double;
      function GetYMax : double;
      function GetYMin : double;
      procedure SetXMax(const AValue : double);
      procedure SetXMin(const AValue : double);
      procedure SetYMax(const AValue : double);
      procedure SetYMin(const AValue : double);
    public
      procedure AddPoint(X, Y : double; Data : Integer);
      constructor Create(x_min, x_max, y_min, y_max : double{;
        DestroyDataProcedure : TDestroyDataProcedure});
      destructor Destroy; override;
      procedure NearestPoint(var X, Y : double; var Data : integer);
      function NearestPointsData(X, Y : double) : integer;
      // Setting Xmax, XMin, Ymax, and Ymin can increase the bounds specified in Create but not decrease them.
      Property Xmax : double read GetXMax write SetXMax;
      Property XMin : double read GetXMin write SetXMin;
      Property Ymax : double read GetYMax write SetYMax;
      Property Ymin : double read GetYMin write SetYMin;
  end;

implementation

// Create and initialize the node.
constructor TQtreeNode.Create(x_min, x_max, y_min, y_max : double{;
  DestroyDataProcedure : TDestroyDataProcedure});
var
    ns : TNorthOrSouth;
    ew : TEastOrWest;
begin
    inherited Create;
    if not ((x_min <= x_max) and (y_min <= y_max)) then
    begin
      raise EQTreeError.Create('Error: attempt to create a TQtreeNode with '
        + 'an invalid range.');
    end;
    Xmin := x_min;
    Xmax := x_max;
    Ymin := y_min;
    Ymax := y_max;
//    FDestroyProcedure := DestroyDataProcedure;

    for ns := North to South do
    begin
      for ew := East to West do
      begin
        Children[ns, ew] := nil;
      end;

    end;
    NumPts := 0;

    // Allocate space for the points.
    SetLength(Pts, MAX_QTREE_NODES);
end;

// Free all children.
destructor TQtreeNode.Destroy;
var
    ns : TNorthOrSouth;
    ew : TEastOrWest;
  Index : integer;
begin
    // If we have no children, free the point memory.
    if (Children[North, West] = nil) then
    begin
{      if Assigned(FDestroyProcedure) then
      begin
        for Index := 0 to NumPts-1 do
        begin
          FDestroyProcedure(Pts[Index].Data);
        end;
      end;    }
      SetLength(Pts, 0);
    end
    else 
    begin
        // Otherwise free the children.
        for ns := North to South do
            for ew := East to West do
                Children[ns, ew].Free;
        // The Point memory doesn't have to be freed because it was freed when the children were created;
    end;

    inherited Destroy;
end;

procedure TQtreeNode.AddPoint(X, Y : double; Data : integer);
var
    xmidLocal, ymidLocal : double; 
  i : integer;
    ns            : TNorthOrSouth;
    ew            : TEastOrWest;
  AQuadNode, Child : TQtreeNode;
  Index : integer;
  APoint : TQPoint;
begin
    // If the point is outside the range of the TQtreeNode, expand the TQtreeNode to encompass it.
    if X < Xmin then ExpandBounds(X, edWest);
    if X > Xmax then ExpandBounds(X, edEast);
    if Y < Ymin then ExpandBounds(Y, edSouth);
    if Y > Ymax then ExpandBounds(Y, edNorth);
    
    AQuadNode := self;
    // See if the node belongs in a child.
    While (AQuadNode.NumPts >= MAX_QTREE_NODES) do

    begin
        xmidLocal := AQuadNode.Xmid;
        ymidLocal := AQuadNode.Ymid;

        // See if we need to create new children.
        if (AQuadNode.Children[North, West] = nil) then
        begin
            // Split the node into four children.
            AQuadNode.Children[North, West] := TQtreeNode.Create
              (AQuadNode.Xmin, xmidLocal, ymidLocal, AQuadNode.Ymax{,
              FDestroyProcedure});
            AQuadNode.Children[North, East] := TQtreeNode.Create
              (xmidLocal, AQuadNode.Xmax, ymidLocal, AQuadNode.Ymax{,
              FDestroyProcedure});
            AQuadNode.Children[South, West] := TQtreeNode.Create
              (AQuadNode.Xmin, xmidLocal, AQuadNode.Ymin, ymidLocal{,
              FDestroyProcedure});
            AQuadNode.Children[South, East] := TQtreeNode.Create
              (xmidLocal, AQuadNode.Xmax, AQuadNode.Ymin, ymidLocal{,
              FDestroyProcedure});

            // Move the old points into the new children.
            for i := 0 to AQuadNode.NumPts-1 do
            begin
              APoint := AQuadNode.Pts[i];
              if (APoint.Y <= ymidLocal) then
                  ns := South
              else
                  ns := North;
              if (APoint.X <= xmidLocal) then
                  ew := West
              else
                  ew := East;
              Child := AQuadNode.Children[ns, ew];
              Child.Pts[Child.NumPts] := APoint;
              Child.NumPts := Child.NumPts + 1;
            end; // End moving points to the new children.

            // Free point memory.
            SetLength(Pts, 0);
            // Note that we do not reset NumPts so later
            // points are also placed in the children.

        end; // End creating new children.

        // Add the point to the correct child.
        if (Y <= ymidLocal) then
            ns := South
        else
            ns := North;
        if (X <= xmidLocal) then
            ew := West
        else
            ew := East;
        AQuadNode := AQuadNode.Children[ns, ew];
    end;

    // don't add duplicate point.
    for Index := 0 to AQuadNode.NumPts -1 do
    begin
      if (AQuadNode.Pts[Index].X = X) and (AQuadNode.Pts[Index].Y = Y) then
      begin
        // if required, destroy data for duplicate point.
{        if Assigned(FDestroyProcedure) then
        begin
          FDestroyProcedure(Data);
        end;  }
        // Quit without adding point.
        Exit;
      end;
    end;

    // Place the point in this node.
    AQuadNode.Pts[AQuadNode.NumPts].X    := X;
    AQuadNode.Pts[AQuadNode.NumPts].Y    := Y;
    AQuadNode.Pts[AQuadNode.NumPts].Data := Data;
    AQuadNode.NumPts := AQuadNode.NumPts + 1;
end;


// Find the point closest to the given coordinates.
procedure TQtreeNode.FindPoint(var X, Y : double; var Data : integer);
var
    best_dist2, best_dist : double;
    best_i     : Integer;
    leaf, Aleaf                   : TQtreeNode;
    Siblings : TStack;
begin
    // See which leaf contains the point.
    Siblings := TStack.Create;
    try

      leaf := LocateLeaf(X, Y, Siblings);

      // Find the closest point within the leaf.
      leaf.NearPointInLeaf(X, Y, best_i, best_dist2);

      if best_i < 0 then
      begin
        while Siblings.Count > 0 do
        begin
          Aleaf := Siblings.Pop;
          leaf := Aleaf.LocateLeaf(X, Y, Siblings);

          // Find the closest point within the leaf.
          leaf.NearPointInLeaf(X, Y, best_i, best_dist2);
          if best_i >= 0 then
          begin
            Break;
          end;
        end;
      end;


      best_dist := Sqrt(best_dist2);
      // Check nearby leaves for closer points.
      CheckNearbyLeaves(leaf, leaf, X, Y, best_i, best_dist2, best_dist);

      Assert(best_i >= 0);
      X    := leaf.Pts[best_i].X;
      Y    := leaf.Pts[best_i].Y;
      Data := leaf.Pts[best_i].Data;

    finally
      Siblings.Free;
    end;

end;

// See what leaf contains the point.
function TQtreeNode.LocateLeaf(X, Y : double; Siblings : TStack) : TQtreeNode;
var
//    xmidLocal, ymidLocal : double;
    ns, nsi         : TNorthOrSouth;
    ew, ewi         : TEastOrWest;
begin
    Result := Self;
    {if (Result.Children[North, West] = nil) then
    begin
        // This node has no children. It must be the node.
        exit;
    end; }

    // Search the appropriate child.
  while result.Children[North, West] <> nil do
  begin
    if (Y <= result.ymid) then
        ns := South
    else
        ns := North;
    if (X <= result.xmid) then
        ew := West
    else
        ew := East;

    for nsi := North to South do
    begin
      for ewi := East to West do
      begin
        if (nsi <> ns) or (ewi <> ew) then
        begin
          Siblings.Push(result.Children[nsi, ewi]);
        end;
      end;
    end;


    Result := result.Children[ns, ew];
  end;
end;

// Return the index of the point closest to the given
// coordinates in this leaf.
procedure TQtreeNode.NearPointInLeaf(X, Y : double; var best_i : Integer;
  var best_dist2 : double);
var
    i             : Longint;
    dist2 : double; 
    dx, dy : double;
begin
    // If there are no points in the node, do nothing.
    best_dist2 := 0;
    best_i := -1;

    if NumPts > 0 then
    begin
      dx := X - Pts[0].X;
      dy := Y - Pts[0].Y;
      best_dist2 := dx * dx + dy * dy;
      best_i := 0;

      for i := 1 to NumPts-1 do
      begin
        dx := X - Pts[i].X;
        dy := Y - Pts[i].Y;
        dist2 := dx * dx + dy * dy;
        if (best_dist2 > dist2) then
        begin
          best_i := i;
          best_dist2 := dist2;
        end;
      end;
    end;
end;

// Check nearby leaves to see if there is a better point.
procedure TQtreeNode.CheckNearbyLeaves(exclude : TQtreeNode;
  var best_leaf : TQtreeNode; X, Y : double; var best_i : integer;
  var best_dist2, best_dist : double);
var
  xmidLocal, ymidLocal : double;
  i : Integer; 
  dist2 : double;
begin
    // If we are excluding this leaf, do nothing.
    if (exclude = Self) then exit;

    // If this is a leaf node, look for close nodes.
    if (Children[North, West] = nil) then
    begin
        NearPointInLeaf(X, Y, i, dist2);
        // Use the closest point in this leaf if
        // 1. there is at least one point in this leaf (i > -1) and either
        // 2. the closest point in this leaf is closer to the search point than
        //    the point that was already found (best_dist2 > dist2) or
        // 3. no point has been found yet (best_i < 0).
        if (i > -1) and ((best_dist2 > dist2) or (best_i < 0)) then
        begin
            best_dist2 := dist2;
            best_dist := Sqrt(best_dist2);
            best_leaf := Self;
            best_i := i;
        end;
    end
    else
    begin
        // Examine children that lie within best_dist
        // of the point.
        xmidLocal := Xmid;
        ymidLocal := Ymid;
//        best_dist := Sqrt(best_dist2);
        if (best_i < 0) or (X - best_dist <= xmidLocal) then
        begin
            // The West children may be close enough.
            // See if the SouthWest child is close enough.
            if (Y - best_dist <= ymidLocal) or (best_i < 0) Then
                Children[South, West].CheckNearbyLeaves(
                    exclude, best_leaf, X, Y, best_i,
                    best_dist2, best_dist);

        end; // End the West children may be close enough.
        if (best_i < 0) or (X - best_dist <= xmidLocal) then
        begin
            // The West children may be close enough.
            // See if the NorthWest child is close enough.
            if (Y + best_dist > ymidLocal) or (best_i < 0) Then
                Children[North, West].CheckNearbyLeaves(
                    exclude, best_leaf, X, Y, best_i,
                    best_dist2, best_dist);

        end; // End the West children may be close enough.

        if (best_i < 0) or (X + best_dist > xmidLocal) then
        begin
            // The East children may be close enough.
            // See if the SouthEast child is close enough.
            if (Y - best_dist <= ymidLocal) or (best_i < 0) Then
                Children[South, East].CheckNearbyLeaves(
                    exclude, best_leaf, X, Y, best_i,
                    best_dist2, best_dist);
        end;

        if (best_i < 0) or (X + best_dist > xmidLocal) then
        begin
            // The East children may be close enough.
            // See if the NorthEast child is close enough.
            if (Y + best_dist > ymidLocal) or (best_i < 0) Then
                Children[North, East].CheckNearbyLeaves(
                    exclude, best_leaf, X, Y, best_i,
                    best_dist2, best_dist);
        end; // End the East children may be close enough.
    end; // End if a leaf ... else check children ...
end;

procedure TQtreeNode.ExpandBounds(XY : double; ExpandDirection : TExpandDirection);
begin
  case ExpandDirection of
    edNorth:
      begin
        Ymax := XY;
        if Children[North, East] <> nil then
        begin
          Children[North, East].ExpandBounds(XY, ExpandDirection);
          Children[North, West].ExpandBounds(XY, ExpandDirection);
        end; 
      end; 
    edSouth: 
      begin
        Ymin := XY;
        if Children[North, East] <> nil then
        begin
          Children[South, East].ExpandBounds(XY, ExpandDirection);
          Children[South, West].ExpandBounds(XY, ExpandDirection);
        end; 
      end; 
    edEast: 
      begin
        Xmax := XY;
        if Children[North, East] <> nil then
        begin
          Children[North, East].ExpandBounds(XY, ExpandDirection);
          Children[South, East].ExpandBounds(XY, ExpandDirection);
        end; 
      end;
    edWest:
      begin
        Xmin := XY;
        if Children[North, East] <> nil then
        begin
          Children[North, West].ExpandBounds(XY, ExpandDirection);
          Children[South, West].ExpandBounds(XY, ExpandDirection);
        end; 
      end; 
  end; 
end;

function TQtreeNode.Xmid : double;
begin
  if Children[North, West] = nil then
  begin
    result := (XMax + XMin) / 2
  end
  else
  begin
    result := Children[North, West].XMax;
  end;
end;

function TQtreeNode.Ymid : double;
begin
  if Children[North, East] = nil then
  begin
    result := (YMax + YMin) / 2
  end
  else
  begin
    result := Children[North, East].YMin;
  end;
end;

{ TQuadTree }

function TQuadTree.GetXMax : double;
begin
  result := FQTreeNode.XMax;
end;

function TQuadTree.GetXMin : double;
begin
  result := FQTreeNode.XMin;
end;

function TQuadTree.GetYMax : double;
begin
  result := FQTreeNode.YMax;
end;

function TQuadTree.GetYMin : double;
begin
  result := FQTreeNode.YMin;
end;


procedure TQuadTree.SetXMax(const AValue : double);
begin
  if (AValue < XMax) then
  begin
    raise EQTreeError.Create('Error: The maximum X value can not be decreased; '
      + 'only increased.');
  end;
  FQTreeNode.ExpandBounds(AValue, edWest);
end;

procedure TQuadTree.SetXMin(const AValue : double);
begin
  if (AValue > XMin) then
  begin
    raise EQTreeError.Create('Error: The minimum X value can not be increased; '
      + 'only decreased.');
  end;
  FQTreeNode.ExpandBounds(AValue, edEast);
end;

procedure TQuadTree.SetYMax(const AValue : double);
begin
  if (AValue < YMax) then
  begin
    raise EQTreeError.Create('Error: The maximum Y value can not be decreased; '
      + 'only increased.');
  end;
  FQTreeNode.ExpandBounds(AValue, edNorth);
end;

procedure TQuadTree.SetYMin(const AValue : double);
begin
  if (AValue > YMin) then
  begin
    raise EQTreeError.Create('Error: The minimum Y value can not be increased; '
      + 'only decreased.');
  end;
  FQTreeNode.ExpandBounds(AValue, edSouth);
end;

procedure TQuadTree.AddPoint(X, Y : double; Data : Integer);
begin
  FQTreeNode.AddPoint(X, Y, Data );
end;

constructor TQuadTree.Create(x_min, x_max, y_min, y_max : double{;
  DestroyDataProcedure : TDestroyDataProcedure});
begin
  inherited Create;
  FQTreeNode := TQTreeNode.Create(x_min, x_max, y_min, y_max{, DestroyDataProcedure});
end;

destructor TQuadTree.Destroy;
begin
  FQTreeNode.Free;
  inherited;
end;

function TQuadTree.NearestPointsData(X, Y : double) : integer;
begin
  if FQTreeNode.NumPts > 0 then
  begin
    NearestPoint(X, Y, result);
  end
  else
  begin
    result := -1;
  end;
end;

procedure TQuadTree.NearestPoint(var X, Y : double; var Data : integer);
begin
  if FQTreeNode.NumPts > 0 then
  begin
    If X > FQTreeNode.XMax then FQTreeNode.XMax := X;
    If X < FQTreeNode.XMin then FQTreeNode.XMin := X;
    If Y > FQTreeNode.YMax then FQTreeNode.YMax := Y;
    If Y < FQTreeNode.YMin then FQTreeNode.YMin := Y;
    FQTreeNode.FindPoint(X, Y, Data);
  end
  else
  begin
    raise EQTreeError.Create('Error: No data points in QuadTree.');
  end;
end;

end.
