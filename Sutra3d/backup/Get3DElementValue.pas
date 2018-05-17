unit Get3DElementValue;

interface

uses Sysutils, classes, Dialogs, contnrs, OctTreeClass;

type
  TLocation3D = record
    X, Y, Z : double;
    Index : integer;
  end;
  PLocation3D = ^TLocation3D;

  TLoc3DArray = array of TLocation3D;

  TElementCorners = array[0..7] of integer;
  PElementCorners = ^TElementCorners;

  TPropertyToInterpolate = (piPressure, piConcentration);

  TElementInterpComponent = class(TComponent)
  private
    FElementCount: integer;
    FNodeCount: integer;
    ElementOctTree : TRbwOctTree;
    NodeOctTree : TRbwOctTree;
    XSearchDistance,YSearchDistance, ZSearchDistance : double;
    procedure SetElementCount(const Value: integer);
    procedure SetNodeCount(const Value: integer);
    procedure ReadMeshFromFile(Const InputFileName : string);
    procedure ReadRestartFile(const RestartFileName : string);
    procedure StoreData;
  public
    PressureValues : array of double;
    ConcentrationValues : array of double;
    Nodes : TLoc3DArray;
    Elements : array of TElementCorners;
    constructor Create(AOwner: TComponent); override;
    property ElementCount : integer read FElementCount write SetElementCount;
    property NodeCount : integer read FNodeCount write SetNodeCount;
    function GetInterpolatedValue(const X, Y, Z : double;
      const InterpProperty : TPropertyToInterpolate) : double;
    procedure ReadDataFromExternalFiles(const InputFileName,
      RestartFileName : string);
    Procedure Read(const Data : TStrings; var LineIndex : integer);
    procedure Write(const Data : TStrings);
  end;

implementation

uses IntListUnit, UtilityFunctions;

var
  TempX, TempY, TempZ : double;
  TempNodes  : TLoc3DArray;

function SortPointers(Item1, Item2: Pointer): Integer;
begin
  result := Integer(Item1) - Integer(Item2);
end;

function SortElements(Item1, Item2: Pointer): Integer;
var
  ElementPointer1, ElementPointer2 : PElementCorners;
  Element1, Element2 : TElementCorners;
//  ElementCenter1, ElementCenter2: TLocation3D;
  NodeIndex : integer;
  Distance1, Distance2, Temp : double;
  ANode : TLocation3D;
begin
  ElementPointer1 := Item1;
  ElementPointer2 := Item2;
  Element1 := ElementPointer1^;
  Element2 := ElementPointer2^;
  Distance1 := 0;
  Distance2 := 0;
  for NodeIndex := 0 to 7 do
  begin
    ANode := TempNodes[Element1[NodeIndex]];
    temp := Sqr(TempX - ANode.X) + Sqr(TempY - ANode.Y)
      + Sqr(TempZ - ANode.Z);
    if (NodeIndex = 0) or (temp < Distance1) then
    begin
      Distance1 := temp;
    end;
    ANode := TempNodes[Element2[NodeIndex]];
    temp := Sqr(TempX - ANode.X) + Sqr(TempY - ANode.Y)
      + Sqr(TempZ - ANode.Z);
    if (NodeIndex = 0) or (temp < Distance2) then
    begin
      Distance2 := temp;
    end;
  end;
  Distance1 := Distance1 - Distance2;
  if Distance1 < 0 then
  begin
    result := -1;
  end
  else if Distance1 > 0 then
  begin
    result := 1;
  end
  else
  begin
    result := 0;
  end;
end;


//procedure GetCoordinates(var X, Y , Z : double; var I : longint);
procedure GETCOORDINATES(var X, Y , Z : double; var I : longint);
  stdcall; external 'sutrareader.dll';

//procedure GetNodeNumber(var NodeNum, IElem, INode : longint);
procedure GETNODENUMBER(var NodeNum, IElem, INode : longint);
  stdcall; external 'sutrareader.dll';

procedure INITIALIZE(var NumNodes, NumElem, NPresB, NConcB, IERRORCODE: longint;
  InputFile : string; FileNameLength : longint);
  stdcall; external 'sutrareader.dll';

procedure CLOSE_FILE;
  stdcall; external 'sutrareader.dll';


procedure ITER3D(
  const NodeCoordinates: TLoc3DArray; // array of all node coordinates in the mesh
  const NodeIndicies : TElementCorners; // array of indicies of nodes defining a particular element
  const XK, YK, ZK : double;  // location for which XSI, ETA, ZETA and Inside are desired;
  out XSI, ETA, ZET : double; // transformed coordinates of XK, YK, an ZK
  out Inside : boolean); // True if search location is inside the element
const
  TOL = 0.001;
  Epsilon = 0.001;
var
  X1, X2, X3, X4, X5, X6, X7, X8 : double;
  Y1, Y2, Y3, Y4, Y5, Y6, Y7, Y8 : double;
  Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8 : double;
  AX, BX, CX, DX, EX, FX, GX, HX : double;
  AY, BY, CY, DY, EY, FY, GY, HY : double;
  AZ, BZ, CZ, DZ, EZ, FZ, GZ, HZ : double;
  XSI0, ETA0, ZET0 : double;
  F10,F20,F30,FP11,FP12,FP13,FP21,FP22,FP23,FP31,FP32,FP33 : double;
  S11,S12,S13,DETERM,CF12,CF34,CF43,CF56 : double;
  DETXSI,DETETA,DETZET,DELXSI,DELETA,DELZET : double;
  Converged : boolean;
  MinX, MaxX, MinY, MaxY, MinZ, MaxZ, temp : double;
  Index : integer;
  Count : integer;
begin
  MinX := NodeCoordinates[NodeIndicies[0]].X;
  MaxX := MinX;
  MinY := NodeCoordinates[NodeIndicies[0]].Y;
  MaxY := MinY;
  MinZ := NodeCoordinates[NodeIndicies[0]].Z;
  MaxZ := MinZ;

  for Index := 1 to 7 do
  begin
    temp := NodeCoordinates[NodeIndicies[Index]].X;
    if temp < MinX then
    begin
      MinX := temp;
    end;
    if temp > MaxX then
    begin
      MaxX := temp;
    end;
    temp := NodeCoordinates[NodeIndicies[Index]].Y;
    if temp < MinY then
    begin
      MinY := temp;
    end;
    if temp > MaxY then
    begin
      MaxY := temp;
    end;
    temp := NodeCoordinates[NodeIndicies[Index]].Z;
    if temp < MinZ then
    begin
      MinZ := temp;
    end;
    if temp > MaxZ then
    begin
      MaxZ := temp;
    end;
  end;

  if (XK < MinX) or (XK > MaxX) or (YK < MinY) or (YK > MaxY)
    or (ZK < MinZ) or (ZK > MaxZ) then
  begin
    Inside := False;
    Exit;
  end;



  X1 := NodeCoordinates[NodeIndicies[0]].X;
  X2 := NodeCoordinates[NodeIndicies[1]].X;
  X3 := NodeCoordinates[NodeIndicies[2]].X;
  X4 := NodeCoordinates[NodeIndicies[3]].X;
  X5 := NodeCoordinates[NodeIndicies[4]].X;
  X6 := NodeCoordinates[NodeIndicies[5]].X;
  X7 := NodeCoordinates[NodeIndicies[6]].X;
  X8 := NodeCoordinates[NodeIndicies[7]].X;

  Y1 := NodeCoordinates[NodeIndicies[0]].Y;
  Y2 := NodeCoordinates[NodeIndicies[1]].Y;
  Y3 := NodeCoordinates[NodeIndicies[2]].Y;
  Y4 := NodeCoordinates[NodeIndicies[3]].Y;
  Y5 := NodeCoordinates[NodeIndicies[4]].Y;
  Y6 := NodeCoordinates[NodeIndicies[5]].Y;
  Y7 := NodeCoordinates[NodeIndicies[6]].Y;
  Y8 := NodeCoordinates[NodeIndicies[7]].Y;

  Z1 := NodeCoordinates[NodeIndicies[0]].Z;
  Z2 := NodeCoordinates[NodeIndicies[1]].Z;
  Z3 := NodeCoordinates[NodeIndicies[2]].Z;
  Z4 := NodeCoordinates[NodeIndicies[3]].Z;
  Z5 := NodeCoordinates[NodeIndicies[4]].Z;
  Z6 := NodeCoordinates[NodeIndicies[5]].Z;
  Z7 := NodeCoordinates[NodeIndicies[6]].Z;
  Z8 := NodeCoordinates[NodeIndicies[7]].Z;

  AX := +X1+X2+X3+X4+X5+X6+X7+X8;
  BX := -X1+X2+X3-X4-X5+X6+X7-X8;
  CX := -X1-X2+X3+X4-X5-X6+X7+X8;
  DX := -X1-X2-X3-X4+X5+X6+X7+X8;
  EX := +X1-X2+X3-X4+X5-X6+X7-X8;
  FX := +X1-X2-X3+X4-X5+X6+X7-X8;
  GX := +X1+X2-X3-X4-X5-X6+X7+X8;
  HX := -X1+X2-X3+X4+X5-X6+X7-X8;

  AY := +Y1+Y2+Y3+Y4+Y5+Y6+Y7+Y8;
  BY := -Y1+Y2+Y3-Y4-Y5+Y6+Y7-Y8;
  CY := -Y1-Y2+Y3+Y4-Y5-Y6+Y7+Y8;
  DY := -Y1-Y2-Y3-Y4+Y5+Y6+Y7+Y8;
  EY := +Y1-Y2+Y3-Y4+Y5-Y6+Y7-Y8;
  FY := +Y1-Y2-Y3+Y4-Y5+Y6+Y7-Y8;
  GY := +Y1+Y2-Y3-Y4-Y5-Y6+Y7+Y8;
  HY := -Y1+Y2-Y3+Y4+Y5-Y6+Y7-Y8;

  AZ := +Z1+Z2+Z3+Z4+Z5+Z6+Z7+Z8;
  BZ := -Z1+Z2+Z3-Z4-Z5+Z6+Z7-Z8;
  CZ := -Z1-Z2+Z3+Z4-Z5-Z6+Z7+Z8;
  DZ := -Z1-Z2-Z3-Z4+Z5+Z6+Z7+Z8;
  EZ := +Z1-Z2+Z3-Z4+Z5-Z6+Z7-Z8;
  FZ := +Z1-Z2-Z3+Z4-Z5+Z6+Z7-Z8;
  GZ := +Z1+Z2-Z3-Z4-Z5-Z6+Z7+Z8;
  HZ := -Z1+Z2-Z3+Z4+Z5-Z6+Z7-Z8;

  XSI  := 0;
  ETA  := 0;
  ZET  := 0;

//  Converged := False;

  Count := 0;
  repeat
    Inc(Count);
    XSI0  := XSI;
    ETA0  := ETA;
    ZET0  := ZET;

    F10 := AX-8.*XK + BX*XSI0 + CX*ETA0 + DX*ZET0 + EX*XSI0*ETA0
       + FX*XSI0*ZET0 + GX*ETA0*ZET0 + HX*XSI0*ETA0*ZET0;
    F20 := AY-8.*YK + BY*XSI0 + CY*ETA0 + DY*ZET0 + EY*XSI0*ETA0
       + FY*XSI0*ZET0 + GY*ETA0*ZET0 + HY*XSI0*ETA0*ZET0;
    F30 := AZ-8.*ZK + BZ*XSI0 + CZ*ETA0 + DZ*ZET0 + EZ*XSI0*ETA0
       + FZ*XSI0*ZET0 + GZ*ETA0*ZET0 + HZ*XSI0*ETA0*ZET0;

    FP11 := BX + EX*ETA0 + FX*ZET0 + HX*ETA0*ZET0;
    FP12 := CX + EX*XSI0 + GX*ZET0 + HX*XSI0*ZET0;
    FP13 := DX + FX*XSI0 + GX*ETA0 + HX*XSI0*ETA0;

    FP21 := BY + EY*ETA0 + FY*ZET0 + HY*ETA0*ZET0;
    FP22 := CY + EY*XSI0 + GY*ZET0 + HY*XSI0*ZET0;
    FP23 := DY + FY*XSI0 + GY*ETA0 + HY*XSI0*ETA0;

    FP31 := BZ + EZ*ETA0 + FZ*ZET0 + HZ*ETA0*ZET0;
    FP32 := CZ + EZ*XSI0 + GZ*ZET0 + HZ*XSI0*ZET0;
    FP33 := DZ + FZ*XSI0 + GZ*ETA0 + HZ*XSI0*ETA0;

    S11 := (FP22*FP33) - (FP32*FP23);
    S12 := (FP21*FP33) - (FP31*FP23);
    S13 := (FP21*FP32) - (FP31*FP22);

    DETERM := (FP11*S11) - (FP12*S12) + (FP13*S13);

    CF12 := -F20*FP33 + F30*FP23;
    CF34 := -F20*FP32 + F30*FP22;
    CF43 :=  -(CF34);
    CF56 := -F30*FP21 + F20*FP31;

    DETXSI := -(F10*S11)   - (FP12*CF12) + (FP13*CF34);
    DETETA := (FP11*CF12)  +  (F10*S12)  + (FP13*CF56);
    DETZET := (FP11*CF43)  - (FP12*CF56) -  (F10*S13);

    DELXSI := DETXSI / DETERM;
    DELETA := DETETA / DETERM;
    DELZET := DETZET / DETERM;

    XSI := XSI0 + DELXSI;
    ETA := ETA0 + DELETA;
    ZET := ZET0 + DELZET;

    converged := ((Abs(DELXSI) < TOL) and (Abs(DELETA) < TOL)
      and (Abs(DELZET) < TOL))
      or ((XSI = XSI0) and (ETA = ETA0) or (ZET = ZET0));

    if converged then
    begin
      Inside := (Abs(XSI) < 1+Epsilon) and (Abs(ETA) < 1+Epsilon)
        and (Abs(ZET) < 1+Epsilon);
    end;

    If(Count > 100) then
    begin
      Inside := False;
      converged := True;
    end;

  until Converged;

end;

procedure Interpolate3D(
  const NodeCoordinates: TLoc3DArray; // array of all node coordinates in the mesh
  const NodeIndicies : TElementCorners; // array of indicies of nodes defining a particular element
  const XK, YK, ZK : double;
  const Values : array of double;
  Out Inside : boolean;
  Out InterpolatedValue : double);
  Const D8 = 0.125;
var
  XSI, ETA, ZET : double; // transformed coordinates of XK, YK, an ZK
  PXSI, SXSI, PETA, SETA, PZET, SZET : double;
  PHI1, PHI2, PHI3, PHI4, PHI5, PHI6, PHI7, PHI8 : double;
begin
  InterpolatedValue := 0;
  ITER3D(NodeCoordinates, NodeIndicies, XK, YK, ZK, XSI, ETA, ZET, Inside);
  if Inside then
  begin
    PXSI := 1.+XSI;
    SXSI := 1.-XSI;
    PETA := 1.+ETA;
    SETA := 1.-ETA;
    PZET := 1.+ZET;
    SZET := 1.-ZET;

    PHI1 := D8 * SXSI* SETA* SZET;
    PHI2 := D8 * PXSI* SETA* SZET;
    PHI3 := D8 * PXSI* PETA* SZET;
    PHI4 := D8 * SXSI* PETA* SZET;
    PHI5 := D8 * SXSI* SETA* PZET;
    PHI6 := D8 * PXSI* SETA* PZET;
    PHI7 := D8 * PXSI* PETA* PZET;
    PHI8 := D8 * SXSI* PETA* PZET;

  //.....The interpolated value of U is evaluated using equation 6.8
    InterpolatedValue :=
        Values[NodeIndicies[0]]*PHI1
      + Values[NodeIndicies[1]]*PHI2+
      + Values[NodeIndicies[2]]*PHI3+
      + Values[NodeIndicies[3]]*PHI4+
      + Values[NodeIndicies[4]]*PHI5+
      + Values[NodeIndicies[5]]*PHI6+
      + Values[NodeIndicies[6]]*PHI7+
      + Values[NodeIndicies[7]]*PHI8;
  end;
end;

{ TElementInterpComponent }


constructor TElementInterpComponent.Create(AOwner: TComponent);
begin
  inherited;
  ElementOctTree := TRbwOctTree.Create(self);
  NodeOctTree := TRbwOctTree.Create(self);
end;

function TElementInterpComponent.GetInterpolatedValue(const X, Y,
  Z: double; const InterpProperty: TPropertyToInterpolate): double;
var
  ElementArray : TOctPointInRegionArray;
  Inside : boolean;
  LocationIndex, ElementIndex, NodeIndex : integer;
  ElementPointer : PElementCorners;
  Element : TElementCorners;
  ElementArray2 : TOctPointArray;
  Distance2 : double;
  SumInvDist2, SumInvDist2TimesValue : double;
  NodePointer : PLocation3D;
  Node : TLocation3D;
  Count : integer;
  Block : T3DBlock;
  ElementList, ElementListTemp : TList;
  TempPointer : Pointer;
begin
  TempX := X;
  TempY := Y;
  TempZ := Z;

  NodeOctTree.FirstNearestPoint(TempX, TempY, TempZ, TempPointer);
  if (TempX = X) and (TempY = Y) and (TempZ = Z) then
  begin
    NodePointer := TempPointer;
    Node := NodePointer^;
    case InterpProperty of
      piPressure:
        begin
          Result := PressureValues[Node.Index];
        end;
      piConcentration:
        begin
          Result := ConcentrationValues[Node.Index];
        end;
    else Assert(False);
    end;
    Exit;
  end;


  Block.XMin := X - XSearchDistance;
  Block.XMax := X + XSearchDistance;
  Block.YMin := Y - YSearchDistance;
  Block.YMax := Y + YSearchDistance;
  Block.ZMin := Z - ZSearchDistance;
  Block.ZMax := Z + ZSearchDistance;
  ElementList := TList.Create;
  try
    ElementListTemp := TList.Create;
    try
      ElementOctTree.FindPointsInBlock(Block, ElementArray);
      ElementListTemp.Capacity := Length(ElementArray)*8;
      for LocationIndex := 0 to Length(ElementArray) -1 do
      begin
        for ElementIndex := 0 to Length(ElementArray[LocationIndex].Data) -1 do
        begin
          ElementPointer := ElementArray[LocationIndex].Data[ElementIndex];
          ElementListTemp.Add(ElementPointer);
        end;
      end;
      ElementListTemp.Sort(SortPointers);
      ElementList.Capacity := ElementListTemp.Count;
      if ElementListTemp.count > 0 then
      begin
        ElementList.Add(ElementListTemp[0]);
        for ElementIndex := 1 to ElementListTemp.count -1 do
        begin
          if ElementListTemp[ElementIndex] <> ElementListTemp[ElementIndex-1] then
          begin
            ElementList.Add(ElementListTemp[ElementIndex]);
          end;
        end;

      end;
    finally
      ElementListTemp.Free;
    end;

{    ElementOctTree.FindPointsInBlock(Block, ElementArray);
    ElementList.Capacity := Length(ElementArray)*8;
    for LocationIndex := 0 to Length(ElementArray) -1 do
    begin
      for ElementIndex := 0 to Length(ElementArray[LocationIndex].Data) -1 do
      begin
        ElementPointer := ElementArray[LocationIndex].Data[ElementIndex];
        if ElementList.IndexOf(ElementPointer) < 0 then
        begin
          ElementList.Add(ElementPointer);
        end;
      end;
    end; }
    TempX := X;
    TempY := Y;
    TempZ := Z;
    TempNodes := Nodes;
//    ElementList.Sort(SortElements);
    for ElementIndex := 0 to ElementList.Count -1 do
    begin
      ElementPointer := ElementList[ElementIndex];
      Element := ElementPointer^;
      case InterpProperty of
        piPressure:
          begin
            Interpolate3D(Nodes, Element, X, Y, Z, PressureValues, Inside, result);
          end;
        piConcentration:
          begin
            Interpolate3D(Nodes, Element, X, Y, Z, ConcentrationValues, Inside, result);
          end;
      else Assert(False);
      end;

      if Inside then Exit;
    end;

  finally
    ElementList.Free;
  end;
  NodeOctTree.FindNearestPoints(X, Y, Z, 4, ElementArray2);

  SumInvDist2 := 0;
  SumInvDist2TimesValue := 0;
  Count := 0;

  for LocationIndex := 0 to Length(ElementArray2) -1 do
  begin
    for NodeIndex := 0 to Length(ElementArray2[LocationIndex].Data) -1 do
    begin
      NodePointer := ElementArray2[LocationIndex].Data[NodeIndex];
      Node := NodePointer^;
      Distance2 := Sqr(X - Node.X) + Sqr(Y - Node.Y) + Sqr(Z - Node.Z);
      if Distance2 = 0 then
      begin
        case InterpProperty of
          piPressure:
            begin
              Result := PressureValues[Node.Index];
            end;
          piConcentration:
            begin
              Result := ConcentrationValues[Node.Index];
            end;
        else Assert(False);
        end;
        Exit;
      end;
      Distance2 := 1/Distance2;
      SumInvDist2 := SumInvDist2 + Distance2;
      case InterpProperty of
        piPressure:
          begin
            SumInvDist2TimesValue := SumInvDist2TimesValue
              + Distance2 * PressureValues[Node.Index];
          end;
        piConcentration:
          begin
            SumInvDist2TimesValue := SumInvDist2TimesValue
              + Distance2 * ConcentrationValues[Node.Index];
          end;
      else Assert(False);
      end;
      Inc(Count);
    end;
  end;

  if Count = 0 then
  begin
    result := 0
  end
  else
  begin
    result := SumInvDist2TimesValue/SumInvDist2
  end;
end;

procedure TElementInterpComponent.Read(const Data : TStrings; var LineIndex : integer);
var
//  BufferPointer : PChar;
//  MemoryStream : TMemoryStream;
//  ACount : integer;
  NodeIndex : integer;
  ElementIndex : integer;
  NodeLocation : TLocation3D;
  ElementCorner : TElementCorners;
//  ResultPtr : PChar;
//  SizeWritten : integer;
  Index : integer;
begin
  NodeCount := StrToInt(Data[LineIndex]);
  Inc(LineIndex);
  ElementCount := StrToInt(Data[LineIndex]);
  Inc(LineIndex);

  for NodeIndex := 0 to NodeCount -1 do
  begin
    NodeLocation.X := InternationalStrToFloat(Data[LineIndex]);
    Inc(LineIndex);
    NodeLocation.Y := InternationalStrToFloat(Data[LineIndex]);
    Inc(LineIndex);
    NodeLocation.Z := InternationalStrToFloat(Data[LineIndex]);
    Inc(LineIndex);
    NodeLocation.Index := NodeIndex;
    Nodes[NodeIndex] := NodeLocation;
  end;

  for ElementIndex := 0 to ElementCount -1 do
  begin
//    ElementCorner := Elements[ElementIndex];
    for NodeIndex := 0 to 7 do
    begin
//      Data.Add(IntToStr(ElementCorner[NodeIndex]));
      ElementCorner[NodeIndex] := StrToInt(Data[LineIndex]);
      Inc(LineIndex);
    end;
    Elements[ElementIndex] := ElementCorner;
  end;
  for Index := 0 to NodeCount -1 do
  begin
//    Data.Add(FloatToStr(PressureValues[Index]));
    PressureValues[Index] := InternationalStrToFloat(Data[LineIndex]);
    Inc(LineIndex);
  end;
  for Index := 0 to NodeCount -1 do
  begin
//    Data.Add(FloatToStr(ConcentrationValues[Index]));
    ConcentrationValues[Index] := InternationalStrToFloat(Data[LineIndex]);
    Inc(LineIndex);
  end;




{  GetMem(BufferPointer, Length(Buffer) + 1);
  try
    StrPCopy(BufferPointer, Buffer);
    MemoryStream := TMemoryStream.Create;
    try
      MemoryStream.Write(BufferPointer,Length(Buffer));
      MemoryStream.Position := 0;

    MemoryStream.Read(ACount, SizeOf(Integer));
    NodeCount := ACount;
    MemoryStream.Read(ACount, SizeOf(Integer));
    ElementCount := ACount;
    MemoryStream.Read(Nodes, SizeOf(TLocation3D)*NodeCount);
    MemoryStream.Read(Elements, SizeOf(TElementCorners)*ElementCount);
    MemoryStream.Read(PressureValues, SizeOf(double)*NodeCount);
    MemoryStream.Read(ConcentrationValues, SizeOf(double)*NodeCount);

    finally
      MemoryStream.Free;
    end;


  finally
    FreeMem(BufferPointer);
  end;       }
  StoreData;
end;

procedure TElementInterpComponent.ReadDataFromExternalFiles(
  const InputFileName, RestartFileName: string);
begin
  ReadMeshFromFile(InputFileName);
  ReadRestartFile(RestartFileName);
  StoreData;
end;

procedure TElementInterpComponent.ReadMeshFromFile(Const InputFileName : string);
var
  FileName : string;
  NumNodes, NumElem, IERRORCODE: longint;
  NodeIndex : integer;
  X, Y , Z : double;
  I : longint;
  ElementIndex : integer;
  NodeNum, IElem, NPresB, NConcB, INode : longint;
  TempDir : string;
begin
  TempDir := GetCurrentDir;
  try
    SetCurrentDir(ExtractFileDir(InputFileName));
    FileName := ExtractFileName(InputFileName);
    try
      //IERRORCODE := 0;
      INITIALIZE(NumNodes, NumElem, NPresB, NConcB, IERRORCODE, FileName, Length(FileName));
      if IERRORCODE <> 0 then
      begin
        Beep;
        ShowMessage('Error number ' + IntToStr(IERRORCODE)
          + ' when reading ' + InputFileName);
      end
      else
      begin
        NodeCount := NumNodes;
        for NodeIndex := 0 to NumNodes -1 do
        begin
          I := NodeIndex+1;
          GetCoordinates(X, Y, Z, I);
          Nodes[NodeIndex].X := X;
          Nodes[NodeIndex].Y := Y;
          Nodes[NodeIndex].Z := Z;
        end;
        ElementCount := NumElem;
        for ElementIndex := 0 to NumElem -1 do
        begin
          IElem := ElementIndex;
          for NodeIndex := 0 to 7 do
          begin
            INode := NodeIndex;
            GetNodeNumber(NodeNum, IElem, INode);
            Elements[ElementIndex,NodeIndex] := NodeNum;
          end;
        end;
      end;
    finally
      CLOSE_FILE;
    end;
  finally
    SetCurrentDir(TempDir);
  end;
end;

procedure TElementInterpComponent.ReadRestartFile(const RestartFileName: string);
const
  kNonuniform = '''NONUNIFORM''';
  kSpace = ' ';
  NumberLength = 21;
var
  RestartFile : TextFile;
  ALine : string;
  NodeIndex : integer;
  NumString : string;
begin
  Assert(FileExists(RestartFileName));
  AssignFile(RestartFile, RestartFileName);
  try
    Reset(RestartFile);
    Readln(RestartFile, ALine);
    Readln(RestartFile, ALine);
    Assert(kNonuniform = ALine);

    NodeIndex := 0;
    repeat
      Readln(RestartFile, ALine);
      if (kNonuniform = ALine) then break;

      while Length(ALine) > 0 do
      begin
        NumString := Trim(Copy(ALine, 1, NumberLength));
        ALine := Copy(ALine, NumberLength+1,MAXINT);
        Assert(NodeIndex < NodeCount);
        PressureValues[NodeIndex] := FortranStrToFloat(NumString);
        Inc(NodeIndex);
      end;

    until EOF(RestartFile);
    Assert(NodeIndex = NodeCount);

    NodeIndex := 0;
    repeat
      Readln(RestartFile, ALine);
      if (NodeIndex = NodeCount) then break;

//      ALine := Trim(ALine);
//      SpacePosition := Pos(kSpace, ALine);
      while Length(ALine) > 0 do
      begin
        NumString := Trim(Copy(ALine, 1, NumberLength));
        ALine := Copy(ALine, NumberLength+1,MAXINT);
//        NumString := Copy(ALine, 1, SpacePosition-1);
//        ALine := Trim(Copy(ALine, SpacePosition+1,MAXINT));
//        SpacePosition := Pos(kSpace, ALine);
        Assert(NodeIndex < NodeCount);
        ConcentrationValues[NodeIndex] := FortranStrToFloat(NumString);
        Inc(NodeIndex);
      end;
//      ConcentrationValues[NodeIndex] := FortranStrToFloat(ALine);
//      Inc(NodeIndex);

    until EOF(RestartFile);
    Assert(NodeIndex = NodeCount);
  finally
    CloseFile(RestartFile);
  end;
end;

procedure TElementInterpComponent.SetElementCount(const Value: integer);
begin
  FElementCount := Value;
  SetLength(Elements, Value);
end;

procedure TElementInterpComponent.SetNodeCount(const Value: integer);
var
  Index : integer;
begin
  SetLength(Nodes, Value);
  for Index := FNodeCount to Value -1 do
  begin
    Nodes[Index].Index := Index;
  end;
  FNodeCount := Value;
  SetLength(ConcentrationValues,NodeCount);
  SetLength(PressureValues,NodeCount);
end;



procedure TElementInterpComponent.StoreData;
var
  NodesListOfElements : TObjectList;
  ANode : TList;
  NodeIndex, ElementIndex : integer;
  NIndex : integer;
  MaxX, MinX : double;
  MaxY, MinY : double;
  MaxZ, MinZ : double;
  NodeLocation : TLocation3D;
  AnElement : TElementCorners;
  APointer : Pointer;
//  NIndex2 : integer;
//  NodeLocation1, NodeLocation2 : TLocation3D;
//  Distance : double;
begin
  XSearchDistance := 0;
  YSearchDistance := 0;
  ZSearchDistance := 0;
  NodesListOfElements := TObjectList.Create;
  try
    for NodeIndex := 0 to NodeCount -1 do
    begin
      NodesListOfElements.Add(TList.Create);
    end;

    for ElementIndex := 0 to ElementCount -1 do
    begin
      APointer := @Elements[ElementIndex];
      for NodeIndex := 0 to 7 do
      begin
        NIndex := Elements[ElementIndex,NodeIndex];
        ANode := NodesListOfElements[NIndex] as TList;
        ANode.Add(APointer);
      end;
      AnElement := Elements[ElementIndex];
      begin
        NodeLocation := Nodes[AnElement[0]];
        MaxX := NodeLocation.X;
        MinX := NodeLocation.X;
        MaxY := NodeLocation.Y;
        MinY := NodeLocation.Y;
        MaxZ := NodeLocation.Z;
        MinZ := NodeLocation.Z;
        for NIndex := 1 to 7 do
        begin
          NodeLocation := Nodes[AnElement[NIndex]];
          if NodeLocation.X > MaxX then
          begin
            MaxX := NodeLocation.X;
          end;
          if NodeLocation.X < MinX then
          begin
            MinX := NodeLocation.X;
          end;
          if NodeLocation.Y > MaxY then
          begin
            MaxY := NodeLocation.Y;
          end;
          if NodeLocation.Y < MinY then
          begin
            MinY := NodeLocation.Y;
          end;
          if NodeLocation.Z > MaxZ then
          begin
            MaxZ := NodeLocation.Z;
          end;
          if NodeLocation.Z < MinZ then
          begin
            MinZ := NodeLocation.Z;
          end;
        end;
        if MaxX - MinX > XSearchDistance then
        begin
          XSearchDistance := MaxX - MinX;
        end;
        if MaxY - MinY > YSearchDistance then
        begin
          YSearchDistance := MaxY - MinY;
        end;
        if MaxZ - MinZ > ZSearchDistance then
        begin
          ZSearchDistance := MaxZ - MinZ;
        end;

      end;
    end;

    XSearchDistance := XSearchDistance/2;
    YSearchDistance := YSearchDistance/2;
    ZSearchDistance := ZSearchDistance/2;

    NodeLocation := Nodes[0];
    MaxX := NodeLocation.X;
    MinX := NodeLocation.X;
    MaxY := NodeLocation.Y;
    MinY := NodeLocation.Y;
    MaxZ := NodeLocation.Z;
    MinZ := NodeLocation.Z;

    NodeLocation := Nodes[NodeCount-1];
    if NodeLocation.X > MaxX then
    begin
      MaxX := NodeLocation.X;
    end;
    if NodeLocation.X < MinX then
    begin
      MinX := NodeLocation.X;
    end;
    if NodeLocation.Y > MaxY then
    begin
      MaxY := NodeLocation.Y;
    end;
    if NodeLocation.Y < MinY then
    begin
      MinY := NodeLocation.Y;
    end;
    if NodeLocation.Z > MaxZ then
    begin
      MaxZ := NodeLocation.Z;
    end;
    if NodeLocation.Z < MinY then
    begin
      MinZ := NodeLocation.Z;
    end;

    for NodeIndex := 1 to 100 do
    begin
      NIndex := Random(NodeCount-1);
      NodeLocation := Nodes[NIndex];
      if NodeLocation.X > MaxX then
      begin
        MaxX := NodeLocation.X;
      end;
      if NodeLocation.X < MinX then
      begin
        MinX := NodeLocation.X;
      end;
      if NodeLocation.Y > MaxY then
      begin
        MaxY := NodeLocation.Y;
      end;
      if NodeLocation.Y < MinY then
      begin
        MinY := NodeLocation.Y;
      end;
      if NodeLocation.Z > MaxZ then
      begin
        MaxZ := NodeLocation.Z;
      end;
      if NodeLocation.Z < MinY then
      begin
        MinZ := NodeLocation.Z;
      end;
    end;

    ElementOctTree.Clear;
    ElementOctTree.XMax := MaxX;
    ElementOctTree.XMin := MinX;
    ElementOctTree.YMax := MaxY;
    ElementOctTree.YMin := MinY;
    ElementOctTree.ZMax := MaxZ;
    ElementOctTree.ZMin := MinZ;

    NodeOctTree.Clear;
    NodeOctTree.XMax := MaxX;
    NodeOctTree.XMin := MinX;
    NodeOctTree.YMax := MaxY;
    NodeOctTree.YMin := MinY;
    NodeOctTree.ZMax := MaxZ;
    NodeOctTree.ZMin := MinZ;

    for NodeIndex := 0 to NodeCount -1 do
    begin
      NodeLocation := Nodes[NodeIndex];
      APointer := @Nodes[NodeIndex];
      NodeOctTree.AddPoint(NodeLocation.X, NodeLocation.Y, NodeLocation.Z, APointer);
      ANode := NodesListOfElements[NodeIndex] as TList;
      for ElementIndex := 0 to ANode.Count -1 do
      begin
        ElementOctTree.AddPoint(NodeLocation.X, NodeLocation.Y,
          NodeLocation.Z, ANode[ElementIndex]);
      end;
    end;

  finally
    NodesListOfElements.Free;
  end;

end;

procedure TElementInterpComponent.Write(const Data : TStrings) ;
var
//  MemoryStream : TMemoryStream;
  NodeIndex : integer;
  ElementIndex : integer;
  NodeLocation : TLocation3D;
  ElementCorner : TElementCorners;
//  ResultPtr : PChar;
//  SizeWritten : integer;
  Index : integer;
begin
  Data.Add(Name);
  Data.Add(IntToStr(NodeCount));
  Data.Add(IntToStr(ElementCount));
  for NodeIndex := 0 to NodeCount -1 do
  begin
    NodeLocation := Nodes[NodeIndex];
    Data.Add(FloatToStr(NodeLocation.X));
    Data.Add(FloatToStr(NodeLocation.Y));
    Data.Add(FloatToStr(NodeLocation.Z));
  end;
  for ElementIndex := 0 to ElementCount -1 do
  begin
    ElementCorner := Elements[ElementIndex];
    for NodeIndex := 0 to 7 do
    begin
      Data.Add(IntToStr(ElementCorner[NodeIndex]));
    end;
  end;
  for Index := 0 to NodeCount -1 do
  begin
    Data.Add(FloatToStr(PressureValues[Index]));
  end;
  for Index := 0 to NodeCount -1 do
  begin
    Data.Add(FloatToStr(ConcentrationValues[Index]));
  end;


{  MemoryStream := TMemoryStream.Create;
  try
    MemoryStream.Write(NodeCount, SizeOf(Integer));
    MemoryStream.Write(ElementCount, SizeOf(Integer));
    MemoryStream.Write(Nodes, SizeOf(TLocation3D)*NodeCount);
    MemoryStream.Write(Elements, SizeOf(TElementCorners)*ElementCount);
    MemoryStream.Write(PressureValues, SizeOf(double)*NodeCount);
    MemoryStream.Write(ConcentrationValues, SizeOf(double)*NodeCount);

    MemoryStream.Position := 0;
    SetLength(result,MemoryStream.Size*SizeOf(Char)+1);// := (ResultPtr, MemoryStream.Size*SizeOf(Char)+1);
//    try
      for Index := 0 to MemoryStream.Size-1 do
      begin
        MemoryStream.Read(Result[Index+1],SizeOf(Char));
      end;

{      MemoryStream.Position := 0;
      SizeWritten := MemoryStream.Read(ResultPtr,MemoryStream.Size);
      Assert(SizeWritten = MemoryStream.Size);
      result := ResultPtr;
    finally
      FreeMem(ResultPtr);
    end;  }



{    for NodeIndex := 0 to NodeCount - 1 do
    begin
      NodeLocation := Nodes[NodeIndex];
      MemoryStream.Write(NodeLocation, SizeOf(TLocation3D));
    end;
    for ElementIndex := 0 to ElementCount -1 do
    begin
      ElementCorner := Elements[ElementIndex];
      MemoryStream.Write(ElementCorner, SizeOf(TElementCorners));
    end;  }

{  finally
    MemoryStream.Free;
  end; }

end;

end.
