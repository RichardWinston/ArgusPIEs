unit frmSamplePoints_Unit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Contnrs, ExtCtrls, Buttons, RealListUnit,
  Menus, ArgusFormUnit, AnePIE, WriteContourUnit, PointContourUnit,
  clipbrd, frmSampleUnit, QuadtreeClass;

type
  TfrmSamplePoints = class(TfrmSample)
    OpenDialog1: TOpenDialog;
    StatusBar1: TStatusBar;
    btrRead: TBitBtn;
    btnAbout: TButton;
    BitBtn1: TBitBtn;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    procedure FormCreate(Sender: TObject); override;
    procedure btnCancelClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Help2Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
  private
    CancelBitMap : boolean;
    procedure ReadData;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSamplePoints: TfrmSamplePoints;

type
  T3Point = array[0..3] of TPoint;
  T4Point = array[0..4] of TPoint;
  TDoubleArray = Array[0..MAXINT div 16] of double;
  PDoubleArray = ^TDoubleArray;
  TMatrix = Array[0..MAXINT div 8] of PDoubleArray;
  pMatrix = ^TMatrix;
  TParamNamesArray = array[0..MAXINT div 8] of ANE_STR;
  PParamNamesArray = ^TParamNamesArray;

procedure GSamplePoints(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;

implementation

{$R *.DFM}

uses frmAboutUnit, OptionsUnit, UtilityFunctions, frmDataPositionUnit,
  LayerNamePrompt, ANE_LayerUnit, ANECB, frmLayerNameUnit;

type
  TSample_DataLayer = class(T_ANE_DataLayer)
    class Function ANE_LayerName : string ; override;
    constructor Create(ALayerList : T_ANE_LayerList; Index: Integer
      {$IFDEF DEFAULTSOK} = -1 {$ENDIF}); override;
  end;


{Function FracToRainbow(Fraction : double) : TColor;
var
  Choice : integer;
begin
  Assert((Fraction>=0) and (Fraction<=1));
  fraction := Fraction*5;
  Choice := Trunc(fraction);
  fraction := Frac(fraction);
//  result := 0;
  case Choice of
    0:
      begin
        result := Round(Fraction*$FF)*$100 + $FF;       // R -> R+G
      end;
    1:
      begin
        result := $FF00 + Round((1-Fraction)*$FF);      // R+G -> G
      end;
    2:
      begin
        result := Round(Fraction*$FF)*$10000 + $FF00;  // G -> G+B
      end;
    3:
      begin
        result := $FF0000 + Round((1-Fraction)*$FF)*$100; // G+B -> B
      end;
    4:
      begin
        result := Round(Fraction*$FF) + $FF0000;          // B -> B+R
      end;
    5:
      begin
        result := $FF00FF;
      end;                                               // B+R
  else
    begin
      Assert(False);
      result := 0;
    end;
  end;
end;  }

procedure TfrmSamplePoints.ReadData;
var
  PointFile: TextFile;
  AString, ASubstring: string;
  Count : integer;
  ParamCount: integer;
  X, Y: Double;
  Parameters: TVDoubleArray;
  ParamIndex: integer;
  LineCount: integer;
  PIndex: Integer;
begin
  btrRead.Enabled := False;
  btnOK.Enabled := False;
  CancelBitMap := False;
  try
    ResetData;
    StatusBar1.SimpleText := 'Reading ' + OpenDialog1.FileName;
    AssignFile(PointFile, OpenDialog1.FileName);
    try
      Reset(PointFile);
      ReadLn(PointFile, AString);
      Count := 0;
      while Length(AString) > 0 do
      begin
        ReadCommaValuesString(AString, ASubstring);
        Inc(Count);
      end;
    finally
      CloseFile(PointFile);
    end;
    ParamCount := Count -2;
    if ParamCount <= 0 then
    begin
      Beep;
      MessageDlg(OpenDialog1.FileName + ' does not have any data values.',
        mtWarning, [mbOK], 0);
    end;
    SetLength(Parameters, ParamCount);
    LineCount := 0;
    try
      Reset(PointFile);
      while not EOF(PointFile) do
      begin
        if CancelBitMap then Exit;
        Application.ProcessMessages;

        ReadLn(PointFile, AString);
        if AString = '' then
        begin
          Continue;
        end;
        ReadCommaValuesString(AString, ASubstring);
        X := FortranStrToFloat(ASubstring);
        ReadCommaValuesString(AString, ASubstring);
        Y := FortranStrToFloat(ASubstring);

        if AString = '' then
        begin
          Continue;
        end;

        if EOF(PointFile) and (AString = '') then break;
        for ParamIndex := 0 to ParamCount -1 do
        begin
          ReadCommaValuesString(AString, ASubstring);
          Parameters[ParamIndex] := FortranStrToFloat(ASubstring);
          if AString = '' then
          begin
            for PIndex := ParamIndex+1 to ParamCount - 1 do
            begin
              Parameters[PIndex] := 0;
            end;
            break;
          end;
        end;
        SetValues(Parameters, X, Y);
        if EOF(PointFile) then break;


        Inc(LineCount);
        if (LineCount mod 1000) = 0 then
        begin
          StatusBar1.SimpleText := IntToStr(LineCount) + ' lines read.';
        end;
      end;
    finally
      CloseFile(PointFile);
    end;
  finally
    btrRead.Enabled := True;
    btnOK.Enabled := True;
    Beep;
    StatusBar1.SimpleText := 'Done reading ' + IntToStr(LineCount) + ' points';
  end;
end;

procedure TfrmSamplePoints.FormCreate(Sender: TObject);
var
  DllDirectory : string;
begin
  Constraints.MinWidth := Width;
  if GetDllDirectory(GetDLLName, DllDirectory) then
  begin
    Application.HelpFile := DllDirectory + '\Utility.chm';
  end;

end;

procedure TfrmSamplePoints.btnCancelClick(Sender: TObject);
begin
  CancelBitMap := True;
end;

procedure TfrmSamplePoints.Open1Click(Sender: TObject);
var
  ModalResult : integer;
begin
  Application.CreateForm(TfrmDataPosition, frmDataPosition);
  try
    frmDataPosition.HelpContext := HelpContext;
    if BlockList <> nil then
    begin
      frmDataPosition.PageControl1.ActivePage := frmDataPosition.tabGrid;
    end
    else
    begin
      frmDataPosition.PageControl1.ActivePage := frmDataPosition.tabMesh;
    end;
    ModalResult := frmDataPosition.ShowModal;
    if ModalResult = mrOK then
    begin
      if BlockList <> nil then
      begin
        MeshImportChoice := micNone;
        GridImportChoice := TGridImportChoice(frmDataPosition.rgGrid.ItemIndex+1);
      end
      else
      begin
        GridImportChoice := gicNone;
        MeshImportChoice := TMeshImportChoice(frmDataPosition.rgMesh.ItemIndex+1);
      end;
    end;

    if (ModalResult = mrOK) and OpenDialog1.Execute
      then
    begin
      ReadData;
    end;
  finally
    frmDataPosition.Free;
  end;

end;

procedure TfrmSamplePoints.About1Click(Sender: TObject);
begin
  ShowAbout
end;

procedure TfrmSamplePoints.Help2Click(Sender: TObject);
begin
  Application.HelpContext(900);
end;

procedure TfrmSamplePoints.btnOKClick(Sender: TObject);
var
  LayerHandle : ANE_PTR;
  Index : integer;
  ParameterIndex: integer;
  Block : TBlock;
  Node : TNode;
  Element : TElement;
  XValues, YValues : TRealList;
  Elevations: TList;
  LayerName : string;
  UserResponse : integer;
  posX : PDoubleArray;
  posY : PDoubleArray;
  dataParameters : pMatrix;
  paramNames : PParamNamesArray;
  numPoints, numDataParameters, NameIndex : integer;
  AName : string;
  Project : TProjectOptions;
  DEM_DataLayer : TSample_DataLayer;
  LayerTemplate : string;
  Values: TVDoubleArray;
  RealPoint: TRealPoint;
begin
  inherited;
  Values := nil;
  LayerName := TSample_DataLayer.ANE_LayerName;
  UserResponse := 0;
  Project := TProjectOptions.Create;
  try
    LayerHandle := Project.GetLayerByName(CurrentModelHandle,LayerName);
  finally
    Project.Free;
  end;

  if LayerHandle = nil then
  begin
    DEM_DataLayer := TSample_DataLayer.Create(nil, -1);
    try
      LayerTemplate := DEM_DataLayer.WriteLayer(CurrentModelHandle);
      LayerHandle := ANE_LayerAddByTemplate(CurrentModelHandle, PChar(LayerTemplate), nil);
    finally
      DEM_DataLayer.Free;
    end;
  end
  else
  begin
    if not GetValidLayerWithCancel(CurrentModelHandle, LayerHandle,
      TSample_DataLayer, LayerName, nil, UserResponse) then
    begin
      ModalResult := mrNone;
      Exit;
    end;
  end;

  if LayerHandle = nil then
  begin
    ModalResult := mrNone;
    Beep;
    MessageDlg('Error getting data layer.', mtError, [mbOK], 0);
    Exit;
  end
  else
  begin
    Elevations := TList.Create;
    XValues := TRealList.Create;
    YValues := TRealList.Create;
    try
      if BlockList <> nil then
      begin
        XValues.Capacity := BlockList.Count;
        YValues.Capacity := BlockList.Count;
        Elevations.Capacity := BlockList.Count;
        for Index := 0 to BlockList.Count -1 do
        begin
          Block := BlockList[Index] as TBlock;
          if Block.Count <> 0 then
          begin
            Elevations.Add(Block);
            XValues.Add(Block.X);
            YValues.Add(Block.Y);
          end;
        end;
      end
      else if NodeList <> nil then
      begin
        case MeshImportChoice of
          micClosestNode, micAverageNode, micHighestNode, micLowestNode:
            begin
              XValues.Capacity := NodeList.Count;
              YValues.Capacity := NodeList.Count;
              Elevations.Capacity := NodeList.Count;
              for Index := 0 to NodeList.Count -1 do
              begin
                Node := NodeList[Index] as TNode;
                if Node.Count <> 0 then
                begin
                  Elevations.Add(Node);
                  XValues.Add(Node.X);
                  YValues.Add(Node.Y);
                end;
              end;
            end;
          micClosestElement, micAverageElement, micHighestElement, micLowestElement:
            begin
              XValues.Capacity := ElementList.Count;
              YValues.Capacity := ElementList.Count;
              Elevations.Capacity := ElementList.Count;
              for Index := 0 to ElementList.Count -1 do
              begin
                Element := ElementList[Index] as TElement;
                if Element.Count <> 0 then
                begin
                  Elevations.Add(Element);
                  XValues.Add(Element.X);
                  YValues.Add(Element.Y);
                end;
              end;
            end;
        end;
      end;

      if Elevations.Count > 0 then
      begin
        RealPoint := Elevations[0];
        Values := RealPoint.Values;
        // Set numDataParameters
        numPoints := Elevations.Count;
        numDataParameters := Length(Values);

        // allocate memory for arrays to be passed to Argus ONE.
        GetMem(posX, numPoints*SizeOf(ANE_DOUBLE));
        GetMem(posY, numPoints*SizeOf(ANE_DOUBLE));
        GetMem(dataParameters, numDataParameters*SizeOf(pMatrix));
        GetMem(paramNames, numDataParameters*SizeOf(ANE_STR));
        try
          begin
            FOR Index := 0 TO numDataParameters-1 DO
              begin
                 GetMem(dataParameters[Index], numPoints*SizeOf(ANE_DOUBLE));
              end;

            // Fill name array.
            for NameIndex := 0 to numDataParameters -1 do
            begin
              assert(NameIndex < numDataParameters);
              AName := LayerName + IntToStr(NameIndex + 1);
              GetMem(paramNames^[NameIndex],(Length(AName) + 1));
              StrPCopy(paramNames^[NameIndex], AName);
            end;
            for Index := 0 to numPoints -1 do
            begin
              posX^[Index] := XValues[Index];
              posY^[Index] := YValues[Index];
              RealPoint := Elevations[Index];
              Values := RealPoint.Values;
              Assert(Length(Values) =  numDataParameters);
              for ParameterIndex := 0 to numDataParameters -1 do
              begin
                dataParameters[ParameterIndex]^[Index] := Values[ParameterIndex];
              end;

            end;
            ANE_DataLayerSetData(CurrentModelHandle ,
                          LayerHandle ,
                          numPoints, // :	  ANE_INT32   ;
                          @posX^, //:		  ANE_DOUBLE_PTR  ;
                          @posY^, // :	    ANE_DOUBLE_PTR   ;
                          numDataParameters, // : ANE_INT32     ;
                          @dataParameters^, // : ANE_DOUBLE_PTR_PTR  ;
                          @paramNames^  );


          end;
        finally
          begin
            // free memory of arrays passed to Argus ONE.
            FOR Index := numDataParameters-1 DOWNTO 0 DO
              begin
                assert(Index < numDataParameters);
                FreeMem(dataParameters[Index]);
                FreeMem(paramNames^[Index]);
              end;
            FreeMem(dataParameters  );
            FreeMem(posY);
            FreeMem(posX);
            FreeMem(paramNames);
          end;
        end;
      end;
    finally
      Elevations.Free;
      XValues.Free;
      YValues.Free;
    end;
  end;
end;

{ TSample_DataLayer }

class function TSample_DataLayer.ANE_LayerName: string;
begin
  result := 'Sampled_Data';
end;

constructor TSample_DataLayer.Create(ALayerList: T_ANE_LayerList;
  Index: Integer);
begin
  inherited;
  Interp := leQT_Nearest;
end;

procedure TfrmSamplePoints.btnAboutClick(Sender: TObject);
begin
  inherited;
  ShowAbout;
end;

procedure GSamplePoints(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  IsGridLayer : boolean;
  LayerName : string;
  LrResult : boolean;
  IsBlockCentered : boolean;
begin
  try
    Application.CreateForm(TfrmLayerName, frmLayerName);
    try
      frmLayerName.cbImportDemOutline.Visible := False;
      frmLayerName.CurrentModelHandle := aneHandle;
      frmLayerName.rgLayerTypeClick(nil);
      frmLayerName.HelpContext := 226;
      LrResult := frmLayerName.ShowModal = mrOK;
      IsGridLayer := frmLayerName.rgLayerType.ItemIndex = 0;
      LayerName := frmLayerName.comboLayerName.Text;
      IsBlockCentered := frmLayerName.rgGridType.ItemIndex = 0;
    finally
      frmLayerName.Free;
    end;

    if LrResult then
    begin
      if LayerName <> '' then
      begin
        Application.CreateForm(TfrmSamplePoints, frmSamplePoints);
        try
          frmSample := frmSamplePoints;
          frmSamplePoints.CurrentModelHandle := aneHandle;
          if IsGridLayer then
          begin
            if IsBlockCentered then
            begin
              frmSamplePoints.GetBlockCenteredGrid(LayerName);
            end
            else
            begin
              frmSamplePoints.GetNodeCenteredGrid(LayerName);
            end;
          end
          else
          begin
            frmSamplePoints.GetMeshWithName(LayerName);
          end;
          frmSamplePoints.ShowModal;
        finally
          frmSample := nil;
          frmSamplePoints.Free;
        end;
      end
      else
      begin
        Beep;
        MessageDlg('No layer was selected so no information will be imported.',
          mtInformation, [mbOK], 0);
      end;
    end;
  except on E : Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

end.
