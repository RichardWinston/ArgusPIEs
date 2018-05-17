unit QuadMeshUnit;

interface

uses Sysutils, Classes, AnePIE;

Type
  ENodeCreateError = Class(Exception);
  EElementCreateError = Class(Exception);
  EMeshCreateError = class(Exception);

  TCustomMeshSubObject = class(TObject)
     Values : TStringList;
     Owner : TList;
     Constructor Create(AnOwner : TList);
     Destructor Destroy ; override;
     function Number : integer;
   end;

   TNode = class(TCustomMeshSubObject)
     X, Y : ANE_DOUBLE;
     Constructor Create(AnOwner : TList; AString : string);
   end;

   TQuadElement = class(TCustomMeshSubObject)
     Nodes : array[0..3] of integer;
     Constructor Create(AnOwner : TList; AString : string);
   end;

   TQuadMesh = Class(TObject)
     NumElem :integer;
     NumNodes :integer;
     NumNodeParam :integer;
     NumElemParam :integer;
     NodeList : TList;
     ElementList : TList;
     constructor Create;
     Destructor Destroy; override;
   end;

function GetNextString(var AString : string) : string;

implementation

uses GetANEFunctonsUnit;

function GetNextString(var AString : string) : string;
var
  DelimPos : integer;
begin
  AString := Trim(AString);
  DelimPos := Pos(ExportDelimiter, AString);
  result := Copy(AString, 1, DelimPos -1);
  AString := Copy(AString, DelimPos + 1, Length(AString));
end;

{ TCustomMeshSubObject }

constructor TCustomMeshSubObject.Create(AnOwner: TList);
begin
  inherited Create;
  Values := TStringList.Create;
  Owner := AnOwner;
  Owner.Add(self);
end;

destructor TCustomMeshSubObject.Destroy;
begin
  Values.Free;
  inherited;
end;

function TCustomMeshSubObject.Number: integer;
begin
  result := Owner.IndexOf(self) + 1;
end;

{ TNode }

constructor TNode.Create(AnOwner: TList; AString: string);
var
  AnotherString : String;
begin
  inherited Create(AnOwner);
  AnotherString := GetNextString(AString);
  if AnotherString <> NodeLinePrefix then
  begin
    raise ENodeCreateError.Create('String does not represent a node.');
  end;
  AnotherString := GetNextString(AString);
  if StrToInt(AnotherString) <> Number then
  begin
    raise ENodeCreateError.Create('Node number invalid.');
  end;
  X := StrToFloat(GetNextString(AString));
  Y := StrToFloat(GetNextString(AString));
  while Pos(ExportDelimiter, AString) > 0 do
  begin
    Values.Add(GetNextString(AString));
  end;
  if AString <> '' then
  begin
    Values.Add(Trim(AString));
  end;
end;

{ TQuadElement }

constructor TQuadElement.Create(AnOwner: TList; AString: string);
var
  AnotherString : String;
begin
  inherited Create(AnOwner);
  AnotherString := GetNextString(AString);
  if AnotherString <> ElemLinePrefix then
  begin
    raise EElementCreateError.Create('String does not represent an element.');
  end;
  AnotherString := GetNextString(AString);
  if StrToInt(AnotherString) <> Number then
  begin
    raise EElementCreateError.Create('Element number invalid.');
  end;
  Nodes[0] := StrToInt(GetNextString(AString));
  Nodes[1] := StrToInt(GetNextString(AString));
  Nodes[2] := StrToInt(GetNextString(AString));
  Nodes[3] := StrToInt(GetNextString(AString));
  while Pos(ExportDelimiter, AString) > 0 do
  begin
    Values.Add(GetNextString(AString));
  end;
  if AString <> '' then
  begin
    Values.Add(Trim(AString));
  end;
end;

{ TQuadMesh }

constructor TQuadMesh.Create;
begin
  ElementList := TList.create;
  NodeList := TList.Create;
end;

destructor TQuadMesh.Destroy;
var
  Index : integer;
begin
  inherited;
  for Index := ElementList.Count -1 downto 0 do
  begin
    TQuadElement(ElementList[Index]).Free;
  end;
  ElementList.Free;

  for Index := NodeList.Count -1 downto 0 do
  begin
    TNode(NodeList[Index]).Free;
  end;
  NodeList.Free;

end;

end.
