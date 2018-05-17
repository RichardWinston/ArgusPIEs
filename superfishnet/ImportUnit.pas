unit ImportUnit;

// Save TD32 information and used Turbo debugger to debug.
// Click F3 and enter the name of your dll.
// After Argus ONE has started attach to ArgusONE.dll.
// From the File menu change to the directory with the source code of the PIE.
// Click F3 and double click on your dll
// Click F3 again and loadthe source files.
// You can now set breakpoints in the dll.

interface

uses
  SysUtils, Dialogs, Classes, Forms,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE, NodeElementUnit, BoundaryContourUnit ;

// You must use the cdecl calling convention for all functions that will be
// called by Argus ONE or calls back to Argus ONE.
procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;

procedure GSuperFishnetPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, OptionsUnit, frmUnitN, ParamNamesAndTypes, FunctionPIE,
ParamArrayUnit, UtilityFunctions;


//  kMaxFunDesc is the maximum number of PIE's in the dll
const kMaxFunDesc = 5;

// global variables.
var
   gFunDesc : array [0..kMaxFunDesc-1] of ANEPIEDescPtr;   // list of PIE descriptors for all parts
   gDelphiPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gDelphiPIEImportPIEDesc : ImportPIEDesc;                // ImportPIE descriptor

   gSetCountPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gSetCountFunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

   gGetXCountPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gGetXCountFunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

   gGetYCountPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gGetYCountFunctionPIEDesc : FunctionPIEDesc;                // Function PIE descriptor

   gAdjustMeshPIEDesc  : ANEPIEDesc;	                   // PIE descriptor
   gAdjustMeshImportPIEDesc : ImportPIEDesc;           // Function PIE descriptor

   XCount, YCount : ANE_INT32;

const
    MeshLayerName = 'SUTRA Mesh';
    FishNetName = 'FishNet Mesh Layout';
    FluidSourcesName = 'Sources of Fluid';
    SoluteSourcesName = 'Sources of Solute';
    EnergySourcesName = 'Sources of Energy';
    XElementName = 'elements_in_x';
    YElementName = 'elements_in_y';
    SpecifiedHeadName = 'Specified Hydraulic Head';
    SpecifiedPressureName = 'Specified Pressure';
    SpecifiedConcentrationName = 'Specified Concentration';
    SpecifiedTemperatureName = 'Specified Temperature';

function GetN(var MultipleUnits : Boolean) : String;
begin
  frmUnitNumber := TfrmUnitNumber.Create(Application);
  try
    frmUnitNumber.ShowModal;
    result := frmUnitNumber.N(MultipleUnits);
  finally
    frmUnitNumber.Free;
  end;
end;

function GetSutraMeshHandles(aneHandle : ANE_PTR;
  var SutraMeshHandle : ANE_PTR;  N : String) : boolean;
var
  ANE_LayerNameStr : ANE_STR;
  LayerName : string;
begin
  LayerName := (MeshLayerName + N);
  SutraMeshHandle := GetLayerHandle(aneHandle, LayerName);
//  SutraMeshHandle := ANE_LayerGetHandleByName(aneHandle,
//         PChar(MeshLayerName + N));
  result := (SutraMeshHandle <> nil);

  if not result then
  begin
    Beep;
    MessageDlg(MeshLayerName + N +' not found!', mtError, [mbOK], 0);
  end;
end;


function GetSutraBasicHandles(aneHandle : ANE_PTR; var SutraMeshHandle,
  FishNetLayoutHandle : ANE_PTR;  N : String) : boolean;
var
  LayerName : string;
  ANE_LayerNameStr : ANE_STR;
begin
    result := GetSutraMeshHandles(aneHandle, SutraMeshHandle, N );

    if result then
    begin
      LayerName := (FishNetName + N);
      FishNetLayoutHandle := GetLayerHandle(aneHandle, LayerName);
{      GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
      try
        StrPCopy(ANE_LayerNameStr,LayerName);
  SutraMeshHandle := GetLayerHandle(aneHandle, LayerName);
        FishNetLayoutHandle := GetLayerByName(aneHandle, ANE_LayerNameStr);
      finally
        FreeMem(ANE_LayerNameStr);
      end;  }
//      FishNetLayoutHandle := ANE_LayerGetHandleByName(aneHandle,
//             PChar(FishNetName + N));

      result := (FishNetLayoutHandle <> nil);

      if not result then
      begin
        Beep;
        MessageDlg(FishNetName + N + ' not found!', mtError, [mbOK], 0);
      end;
    end;
end;

function GetSourceHandles(aneHandle : ANE_PTR;
  var FluidSourcesHandle,
  SoluteEnergySourceHandle, HeadPressureHandle, ConcTempHandle : ANE_PTR;
  N, NodeSurface : String) : boolean;
var
  LayerName : string;
begin

    LayerName := (FluidSourcesName + NodeSurface + N);
    FluidSourcesHandle := GetLayerHandle(aneHandle, LayerName);
{    GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
    try
      StrPCopy(ANE_LayerNameStr,LayerName);
      FluidSourcesHandle := GetLayerByName(aneHandle, ANE_LayerNameStr);
    finally
      FreeMem(ANE_LayerNameStr);
    end; }
//    FluidSourcesHandle := ANE_LayerGetHandleByName(aneHandle,
//           PChar(FluidSourcesName + NodeSurface + N));


    result := (FluidSourcesHandle <> nil);

    if not result then
    begin
      Beep;
      MessageDlg(FluidSourcesName+ NodeSurface + N + ' not found!', mtError, [mbOK], 0);
    end;

    if result then
    begin
      LayerName := (SoluteSourcesName + NodeSurface + N);
      SoluteEnergySourceHandle := GetLayerHandle(aneHandle, LayerName);
{      GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
      try
        StrPCopy(ANE_LayerNameStr,LayerName);
        SoluteEnergySourceHandle := GetLayerByName(aneHandle, ANE_LayerNameStr);
      finally
        FreeMem(ANE_LayerNameStr);
      end;  }
//      SoluteEnergySourceHandle := ANE_LayerGetHandleByName(aneHandle,
//             PChar(SoluteSourcesName + NodeSurface + N));

      if SoluteEnergySourceHandle = nil then
      begin
        LayerName := (EnergySourcesName + NodeSurface + N);
        SoluteEnergySourceHandle := GetLayerHandle(aneHandle, LayerName);
{        GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
        try
          StrPCopy(ANE_LayerNameStr,LayerName);
          SoluteEnergySourceHandle := GetLayerByName(aneHandle, ANE_LayerNameStr);
        finally
          FreeMem(ANE_LayerNameStr);
        end;  }
//        SoluteEnergySourceHandle := ANE_LayerGetHandleByName(aneHandle,
//               PChar(EnergySourcesName + NodeSurface + N));
      end;

      result := (SoluteEnergySourceHandle <> nil);

      if not result then
      begin
        Beep;
        MessageDlg(SoluteSourcesName + NodeSurface + N + ' and ' + EnergySourcesName + NodeSurface + N
          + ' not found!', mtError, [mbOK], 0);
      end;
    end;

    if result then
    begin
      LayerName := (SpecifiedHeadName + NodeSurface + N);
      HeadPressureHandle := GetLayerHandle(aneHandle, LayerName);
{      GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
      try
        StrPCopy(ANE_LayerNameStr,LayerName);
        HeadPressureHandle := GetLayerByName(aneHandle, ANE_LayerNameStr);
      finally
        FreeMem(ANE_LayerNameStr);
      end; }
//      HeadPressureHandle := ANE_LayerGetHandleByName(aneHandle,
//             PChar(SpecifiedHeadName + NodeSurface + N));

      if HeadPressureHandle = nil then
      begin
        LayerName := (SpecifiedPressureName + NodeSurface + N);
        HeadPressureHandle := GetLayerHandle(aneHandle, LayerName);
{        GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
        try
          StrPCopy(ANE_LayerNameStr,LayerName);
          HeadPressureHandle := GetLayerByName(aneHandle, ANE_LayerNameStr);
        finally
          FreeMem(ANE_LayerNameStr);
        end; }
//        HeadPressureHandle := ANE_LayerGetHandleByName(aneHandle,
//               PChar(SpecifiedPressureName + NodeSurface + N));
      end;

      result := (HeadPressureHandle <> nil);

      if not result then
      begin
        Beep;
        MessageDlg(SpecifiedHeadName + NodeSurface + N + ' and ' + SpecifiedPressureName + NodeSurface + N
          + ' not found!', mtError, [mbOK], 0);
      end;
    end;

    if result then
    begin
      LayerName := (SpecifiedConcentrationName + NodeSurface + N);
      ConcTempHandle := GetLayerHandle(aneHandle, LayerName);
{      GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
      try
        StrPCopy(ANE_LayerNameStr,LayerName);
        ConcTempHandle := GetLayerByName(aneHandle, ANE_LayerNameStr);
      finally
        FreeMem(ANE_LayerNameStr);
      end;       }
//      ConcTempHandle := ANE_LayerGetHandleByName(aneHandle,
//             PChar(SpecifiedConcentrationName + NodeSurface + N));

      if ConcTempHandle = nil then
      begin
        LayerName := (SpecifiedTemperatureName + NodeSurface + N);
        ConcTempHandle := GetLayerHandle(aneHandle, LayerName);
{        GetMem(ANE_LayerNameStr, Length(LayerName) + 1);
        try
          StrPCopy(ANE_LayerNameStr,LayerName);
          ConcTempHandle := GetLayerByName(aneHandle, ANE_LayerNameStr);
        finally
          FreeMem(ANE_LayerNameStr);
        end;  }
//        ConcTempHandle := ANE_LayerGetHandleByName(aneHandle,
//               PChar(SpecifiedTemperatureName + NodeSurface + N));
      end;

      result := (ConcTempHandle <> nil);

      if not result then
      begin
        Beep;
        MessageDlg(SpecifiedConcentrationName + NodeSurface + N + ' and ' + SpecifiedTemperatureName + NodeSurface + N
          + ' not found!', mtError, [mbOK], 0);
      end;
    end;


end;

function GetParamIndicies(aneHandle : ANE_PTR; FishNetLayoutHandle : ANE_PTR;
  var XElementIndex, YElementIndex : integer; N : String) : boolean;
begin
    XElementIndex := UGetParameterIndex(aneHandle,
         FishNetLayoutHandle, XElementName);
    result := (XElementIndex > -1);
    if not result then
    begin
      Beep;
      MessageDlg(XElementName + ' not found on ' + FishNetName + N + '!', mtError, [mbOK], 0);
    end;

    if result then
    begin
      YElementIndex := UGetParameterIndex(aneHandle,
           FishNetLayoutHandle, YElementName);
      result := (YElementIndex > -1);
      if not result then
      begin
        Beep;
        MessageDlg(YElementName + ' not found on ' + FishNetName + N + '!', mtError, [mbOK], 0);
      end;
    end;
end;

function GetFishnetString(aneHandle, FishNetLayoutHandle : ANE_PTR;
  var LayoutString : string; N : String) : boolean;
var
  LayoutText : ANE_STR;
begin
  ANE_ExportTextFromOtherLayer(aneHandle, FishNetLayoutHandle, @LayoutText );
  LayoutString := String(LayoutText);
  result := (LayoutString <> '');

  if not result then
  begin
    Beep;
    MessageDlg('No contours found on ' + FishNetName + N + '!', mtError, [mbOK], 0);
  end;
end;

procedure GetSourcesStrings(aneHandle, FluidSourcesHandle,
  SoluteEnergySourceHandle, HeadPressureHandle, ConcTempHandle : ANE_PTR;
  var FluidSources, SoluteEnergySources, PressureHead, TempConc : string);
var
  FluidSourcesANESTR, SoluteEnergySourcesANESTR, PressureHeadANESTR,
    TempConcANESTR : ANE_STR;
begin
    ANE_ExportTextFromOtherLayer(aneHandle, FluidSourcesHandle, @FluidSourcesANESTR );
    FluidSources := String(FluidSourcesANESTR);

    ANE_ExportTextFromOtherLayer(aneHandle, SoluteEnergySourceHandle, @SoluteEnergySourcesANESTR );
    SoluteEnergySources := String(SoluteEnergySourcesANESTR);


    ANE_ExportTextFromOtherLayer(aneHandle, HeadPressureHandle, @PressureHeadANESTR );
    PressureHead := String(PressureHeadANESTR);

    ANE_ExportTextFromOtherLayer(aneHandle, ConcTempHandle, @TempConcANESTR );
    TempConc := String(TempConcANESTR);

end;

procedure AdjustMesh(aneHandle : ANE_PTR; FluidSourcesStringList : TStringList;
  AMesh : TMesh);
var
  AList : TList;
  ProjectOptions : TProjectOptions;
  UpperCriticalAngle, LowerCriticalAngle: ANE_DOUBLE;
  Index : integer;
  ABoundary : TBoundaryContour;
begin
  if FluidSourcesStringList.Count > 0 then
  begin
    AList := TList.Create;
    try
      ProjectOptions := TProjectOptions.Create;
      try
        LowerCriticalAngle := ProjectOptions.MinAngle[aneHandle];
        UpperCriticalAngle := ProjectOptions.MaxAngle[aneHandle];
      finally
        ProjectOptions.Free;
      end;

      CreateBoundaryContours(FluidSourcesStringList, AList);
      for Index := 0 to AList.Count -1 do
      begin
        ABoundary := AList[Index];
        AMesh.AdjustMesh(ABoundary, UpperCriticalAngle, LowerCriticalAngle );
      end;
    finally
      for Index := 0 to AList.Count -1 do
      begin
        ABoundary := AList[Index];
        ABoundary.Free;
      end;
      AList.Free;
    end;
  end;
end;

procedure GAdjustMesh(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  SutraMeshHandle , FluidSourcesHandle,
    SoluteEnergySourceHandle, HeadPressureHandle, ConcTempHandle : ANE_PTR;
  OK : boolean;
  LayoutString : String;
  XElementIndex, YElementIndex : integer;
  FishnetContours : TStringList;
  AMesh : TMesh;
  FluidSources : string;
  SoluteEnergySources : string;
  MeshStringList : TStringList;
  ImportText : string;
  PressureHead : string;
  TempConc : string;
  N : string;
  NodeSurface : string;
  MultipleUnits : Boolean;
  LowerLimit, UpperLimit : integer;
  NIndex : integer;
  SourcesStringList, CurrentSourceStringList : TStringList;
  MeshLayerOptions : TLayerOptions;
  ProjectOptions : TProjectOptions;
  MeshString : string;
  AString : ANE_STR;
begin
  N := GetN(MultipleUnits);

  if N = '' then
  begin
    NodeSurface := '';
  end
  else
  begin
    NodeSurface := ' Node Surface';
  end;

  try
    if MultipleUnits then
    begin
      OK := GetSutraMeshHandles(aneHandle, SutraMeshHandle, '');
    end
    else
    begin
      OK := GetSutraMeshHandles(aneHandle, SutraMeshHandle, N);
    end;

    if OK then
    begin
      ProjectOptions := TProjectOptions.Create;
      MeshLayerOptions := TLayerOptions.Create(SutraMeshHandle);
      try
        ProjectOptions.ExportParameters[aneHandle] := False;
        ProjectOptions.ExportDelimiter[aneHandle] := ' ';
        ProjectOptions.ElemLinePrefix[aneHandle] := 'E';
        ProjectOptions.NodeLinePrefix[aneHandle] := 'N';
        MeshString := MeshLayerOptions.Text[aneHandle];
        AMesh := TMesh.Create;

        try
          AMesh.CreateMesh(MeshString);

          UpperLimit := StrToInt(N);
          if MultipleUnits then
          begin
            LowerLimit := 1;
          end
          else
          begin
            LowerLimit := UpperLimit;
          end;
          SourcesStringList := TStringList.Create;
          CurrentSourceStringList := TStringList.Create;
          try
            for NIndex := LowerLimit to UpperLimit do
            begin
              if OK then
              begin
                OK := GetSourceHandles(aneHandle,
                  FluidSourcesHandle, SoluteEnergySourceHandle, HeadPressureHandle,
                  ConcTempHandle, IntToStr(NIndex), NodeSurface);

              end;

              if OK then
              begin
                GetSourcesStrings(aneHandle, FluidSourcesHandle,
                  SoluteEnergySourceHandle, HeadPressureHandle, ConcTempHandle,
                  FluidSources, SoluteEnergySources, PressureHead, TempConc);

                CurrentSourceStringList.Text := FluidSources;
                if (SourcesStringList.Count > 0)
                  and (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.Add('');
                end;
                if (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.AddStrings(CurrentSourceStringList)
                end;

                CurrentSourceStringList.Text := SoluteEnergySources;
                if (SourcesStringList.Count > 0)
                  and (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.Add('');
                end;
                if (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.AddStrings(CurrentSourceStringList)
                end;

                CurrentSourceStringList.Text := PressureHead;
                if (SourcesStringList.Count > 0)
                  and (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.Add('');
                end;
                if (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.AddStrings(CurrentSourceStringList)
                end;

                CurrentSourceStringList.Text := TempConc;
                if (SourcesStringList.Count > 0)
                  and (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.Add('');
                end;
                if (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.AddStrings(CurrentSourceStringList)
                end;
              end;

            end;
            if OK then
            begin
              AdjustMesh(aneHandle, SourcesStringList, AMesh);
              MeshStringList := TStringList.Create;
              try
                MeshLayerOptions.ClearLayer(aneHandle, False);
                AMesh.WriteMesh(MeshStringList);
                ImportText := MeshStringList.Text;
                ShowMessage(ImportText);
                GetMem(AString, Length(ImportText) + 1);
                try
                  StrPCopy(AString, ImportText);

                  ANE_ImportTextToLayer(aneHandle, AString);
                finally
                  FreeMem(AString);
                end;
              finally
                MeshStringList.Free;
              end;
            end;
          finally
            SourcesStringList.Free;
            CurrentSourceStringList.Free;
          end;


        finally
          AMesh.Free
        end;
      finally
        ProjectOptions.Free;
        MeshLayerOptions.Free(aneHandle);
      end;
    end;

  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;


end;


procedure GSuperFishnetPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;
var
  SutraMeshHandle , FishNetLayoutHandle, FluidSourcesHandle,
    SoluteEnergySourceHandle, HeadPressureHandle, ConcTempHandle : ANE_PTR;
  OK : boolean;
  LayoutString : String;
  XElementIndex, YElementIndex : integer;
  FishnetContours : TStringList;
  Fishnet : TFishnet;
  FluidSources : string;
  SoluteEnergySources : string;
  MeshStringList : TStringList;
  ImportText : string;
  PressureHead : string;
  TempConc : string;
  N : string;
  NodeSurface : string;
  MultipleUnits : Boolean;
  LowerLimit, UpperLimit : integer;
  NIndex : integer;
  SourcesStringList, CurrentSourceStringList : TStringList;
  AString : ANE_STR;
begin
  N := GetN(MultipleUnits);

  if N = '' then
  begin
    NodeSurface := '';
  end
  else
  begin
    NodeSurface := ' Node Surface';
  end;

  try
    if MultipleUnits then
    begin
      OK := GetSutraBasicHandles(aneHandle, SutraMeshHandle,
        FishNetLayoutHandle,  '');
    end
    else
    begin
      OK := GetSutraBasicHandles(aneHandle, SutraMeshHandle,
        FishNetLayoutHandle,  N);
    end;

    if OK then
    begin
      OK := GetParamIndicies(aneHandle, FishNetLayoutHandle,
        XElementIndex, YElementIndex, N);
    end;

    if OK then
    begin
      if MultipleUnits then
      begin
        OK := GetFishnetString(aneHandle, FishNetLayoutHandle, LayoutString, '');
      end
      else
      begin
        OK := GetFishnetString(aneHandle, FishNetLayoutHandle, LayoutString, N);
      end;

    end;

    if OK then
    begin
      FishnetContours := TStringList.Create;

      try
        FishnetContours.Text := LayoutString;

        Fishnet := TFishnet.Create(FishnetContours,XElementIndex,YElementIndex);
        try
          Fishnet.CreateMesh;

          UpperLimit := StrToInt(N);
          if MultipleUnits then
          begin
            LowerLimit := 1;
          end
          else
          begin
            LowerLimit := UpperLimit;
          end;
          SourcesStringList := TStringList.Create;
          CurrentSourceStringList := TStringList.Create;
          try
            for NIndex := LowerLimit to UpperLimit do
            begin
              if OK then
              begin
                OK := GetSourceHandles(aneHandle,
                  FluidSourcesHandle, SoluteEnergySourceHandle, HeadPressureHandle,
                  ConcTempHandle, IntToStr(NIndex), NodeSurface);

              end;

              if OK then
              begin
                GetSourcesStrings(aneHandle, FluidSourcesHandle,
                  SoluteEnergySourceHandle, HeadPressureHandle, ConcTempHandle,
                  FluidSources, SoluteEnergySources, PressureHead, TempConc);

                CurrentSourceStringList.Text := FluidSources;
                if (SourcesStringList.Count > 0)
                  and (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.Add('');
                end;
                if (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.AddStrings(CurrentSourceStringList)
                end;

                CurrentSourceStringList.Text := SoluteEnergySources;
                if (SourcesStringList.Count > 0)
                  and (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.Add('');
                end;
                if (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.AddStrings(CurrentSourceStringList)
                end;

                CurrentSourceStringList.Text := PressureHead;
                if (SourcesStringList.Count > 0)
                  and (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.Add('');
                end;
                if (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.AddStrings(CurrentSourceStringList)
                end;

                CurrentSourceStringList.Text := TempConc;
                if (SourcesStringList.Count > 0)
                  and (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.Add('');
                end;
                if (CurrentSourceStringList.Count > 0) then
                begin
                  SourcesStringList.AddStrings(CurrentSourceStringList)
                end;
              end;

            end;
            if OK then
            begin
              AdjustMesh(aneHandle, SourcesStringList, Fishnet);
              MeshStringList := TStringList.Create;
              try
                Fishnet.WriteMesh(MeshStringList);
                ImportText := MeshStringList.Text;
                GetMem(AString, Length(ImportText) + 1);
                try
                  StrPCopy(AString, ImportText);

                  ANE_ImportTextToLayer(aneHandle, AString);
                finally
                  FreeMem(AString);
                end;
              finally
                MeshStringList.Free;
              end;
            end;
          finally
            SourcesStringList.Free;
            CurrentSourceStringList.Free;
          end;


        finally
          Fishnet.Free
        end;
      finally
        FishnetContours.Free;
      end;
    end;

  except on E: Exception do
    begin
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;

end;

procedure GGetXCount(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				aneHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
begin
  if XCount < YCount then
  begin
    result := XCount
  end
  else
  begin
    result := YCount
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GGetYCount(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				aneHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  result : ANE_INT32;
begin
  if XCount >= YCount then
  begin
    result := XCount
  end
  else
  begin
    result := YCount
  end;
  ANE_INT32_PTR(reply)^ := result;
end;

procedure GSetCounts(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				aneHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
var
  SutraMeshHandle , FishNetLayoutHandle : ANE_PTR;
  OK : boolean;
  LayoutString : String;
  XElementIndex, YElementIndex : integer;
  FishnetContours : TStringList;
  Fishnet : TFishnet;
  N : string;
  result : ANE_BOOL;
  ANE_N : ANE_STR;  // ANE_DOUBLE_PTR is the same as ^ANE_DOUBLE
  param : PParameter_array;
begin
  result := True;

  param := @parameters^;
  ANE_N :=  param^[0];

  N := String(ANE_N);
//  NodeSurface := ' Node Surface';

  try
    OK := GetSutraBasicHandles(aneHandle, SutraMeshHandle,
      FishNetLayoutHandle,  N);

{    if OK then
    begin
      OK := GetSourceHandles(aneHandle,
        FluidSourcesHandle, SoluteEnergySourceHandle, HeadPressureHandle,
        ConcTempHandle, N, NodeSurface);

    end;  }

    if OK then
    begin
      OK := GetParamIndicies(aneHandle, FishNetLayoutHandle,
        XElementIndex, YElementIndex, N);
    end;

    if OK then
    begin
      OK := GetFishnetString(aneHandle, FishNetLayoutHandle, LayoutString, N);

    end;

{    if OK then
    begin
      GetSourcesStrings(aneHandle, FluidSourcesHandle,
        SoluteEnergySourceHandle, HeadPressureHandle, ConcTempHandle,
        FluidSources, SoluteEnergySources, PressureHead, TempConc);
    end; }

    if OK then
    begin
      FishnetContours := TStringList.Create;
//      FluidSourcesStringList := TStringList.Create;
{      SoluteEnergyStringList := TStringList.Create;
      PressureHeadStringList := TStringList.Create;
      TempConcStringList := TStringList.Create; }

      try
        FishnetContours.Text := LayoutString;
//        FluidSourcesStringList.Text := '';
{        SoluteEnergyStringList.Text := SoluteEnergySources;
        PressureHeadStringList.Text := PressureHead;
        TempConcStringList.Text := TempConc;
        if SoluteEnergyStringList.Count > 0 then
        begin
          FluidSourcesStringList.Add('');
          FluidSourcesStringList.AddStrings(SoluteEnergyStringList);
        end;
        if PressureHeadStringList.Count > 0 then
        begin
          FluidSourcesStringList.Add('');
          FluidSourcesStringList.AddStrings(PressureHeadStringList);
        end;
        if TempConcStringList.Count > 0 then
        begin
          FluidSourcesStringList.Add('');
          FluidSourcesStringList.AddStrings(TempConcStringList);
        end;  }
        Fishnet := TFishnet.Create(FishnetContours,XElementIndex,YElementIndex);
        try
          XCount := Fishnet.ColumnNodeCount;
          YCount := Fishnet.RowNodeCount;
{          Fishnet.CreateMesh;
          AdjustMesh(aneHandle, FluidSourcesStringList, Fishnet);
          MeshStringList := TStringList.Create;
          try
            Fishnet.WriteMesh(MeshStringList);
            ImportText := MeshStringList.Text;
            ANE_ImportTextToLayer(aneHandle, PChar(ImportText));
          finally
            MeshStringList.Free;
          end;  }

        finally
          Fishnet.Free
        end;
      finally
        FishnetContours.Free;
{        FluidSourcesStringList.Free;
        SoluteEnergyStringList.Free;
        PressureHeadStringList.Free;
        TempConcStringList.Free;   }
      end;

    end;


  except on E: Exception do
    begin
      result := False;
      Beep;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  ANE_BOOL_PTR(reply)^ := result;

end;


procedure GetANEFunctions( var numNames : ANE_INT32;
          var descriptors : ANEPIEDescPtr ); cdecl;
var
  UsualOptions : EFunctionPIEFlags;
begin
//  UsualOptions := kFunctionNeedsProject and kFunctionIsHidden;
  UsualOptions := kFunctionNeedsProject;

        {$ASSERTIONS ON}
        {Assertions are a debugging tool. They should be turned off
        in the final version. They are useful for "Just-in-time" debugging
        with Turbo-Debugger 32. See Delphi help for more information.}

	numNames := 0;
	gDelphiPIEImportPIEDesc.version := IMPORT_PIE_VERSION;
	gDelphiPIEImportPIEDesc.name := 'Super Fishnet Pie';   // name of project
	gDelphiPIEImportPIEDesc.importFlags := kImportNeedsProject;
 	gDelphiPIEImportPIEDesc.toLayerTypes := (kPIEQuadMeshLayer) {* was kPIETriMeshLayer*/};
 	gDelphiPIEImportPIEDesc.fromLayerTypes := (kPIEQuadMeshLayer) {* was kPIETriMeshLayer*/};
 	gDelphiPIEImportPIEDesc.doImportProc := @GSuperFishnetPIE;// address of Post Processing Function function
        gDelphiPIEImportPIEDesc.neededProject := 'SUTRA';

	gDelphiPIEDesc.name := 'Super Fishnet Pie';      // PIE name
	gDelphiPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gDelphiPIEDesc.descriptor := @gDelphiPIEImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gDelphiPIEDesc;
        Inc(numNames);	// add descriptor to list

	gSetCountFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
	gSetCountFunctionPIEDesc.functionFlags := UsualOptions;
	gSetCountFunctionPIEDesc.name := 'Sutra_SetFishNetMeshCount';
 	gSetCountFunctionPIEDesc.address := @GSetCounts;
 	gSetCountFunctionPIEDesc.returnType := kPIEBoolean;
 	gSetCountFunctionPIEDesc.numParams := 1;
 	gSetCountFunctionPIEDesc.numOptParams := 0;
 	gSetCountFunctionPIEDesc.paramNames := @gpnUnit;
 	gSetCountFunctionPIEDesc.paramTypes := @gOneStringTypes;
        gSetCountFunctionPIEDesc.neededProject := 'SUTRA';

	gSetCountPIEDesc.name := 'Sutra_SetFishNetMeshCount';      // PIE name
	gSetCountPIEDesc.PieType := kFunctionPIE;
	gSetCountPIEDesc.descriptor := @gSetCountFunctionPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gSetCountPIEDesc;
        Inc(numNames);	// add descriptor to list

	gGetXCountFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
	gGetXCountFunctionPIEDesc.functionFlags := UsualOptions;
	gGetXCountFunctionPIEDesc.name := 'Sutra_GetMeshXCount';
 	gGetXCountFunctionPIEDesc.address := @GGetXCount;
 	gGetXCountFunctionPIEDesc.returnType := kPIEInteger;
 	gGetXCountFunctionPIEDesc.numParams := 0;
 	gGetXCountFunctionPIEDesc.numOptParams := 0;
 	gGetXCountFunctionPIEDesc.paramNames := nil;
 	gGetXCountFunctionPIEDesc.paramTypes := nil;
        gGetXCountFunctionPIEDesc.neededProject := 'SUTRA';

	gGetXCountPIEDesc.name := 'Sutra_GetMeshXCount';      // PIE name
	gGetXCountPIEDesc.PieType := kFunctionPIE;
	gGetXCountPIEDesc.descriptor := @gGetXCountFunctionPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gGetXCountPIEDesc;
        Inc(numNames);	// add descriptor to list

	gGetYCountFunctionPIEDesc.version := FUNCTION_PIE_VERSION;
	gGetYCountFunctionPIEDesc.functionFlags := UsualOptions;
	gGetYCountFunctionPIEDesc.name := 'Sutra_GetMeshYCount';
 	gGetYCountFunctionPIEDesc.address := @GGetYCount;
 	gGetYCountFunctionPIEDesc.returnType := kPIEInteger;
 	gGetYCountFunctionPIEDesc.numParams := 0;
 	gGetYCountFunctionPIEDesc.numOptParams := 0;
 	gGetYCountFunctionPIEDesc.paramNames := nil;
 	gGetYCountFunctionPIEDesc.paramTypes := nil;
        gGetYCountFunctionPIEDesc.neededProject := 'SUTRA';

	gGetYCountPIEDesc.name := 'Sutra_GetMeshYCount';      // PIE name
	gGetYCountPIEDesc.PieType := kFunctionPIE;
	gGetYCountPIEDesc.descriptor := @gGetYCountFunctionPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gGetYCountPIEDesc;
        Inc(numNames);	// add descriptor to list

	gAdjustMeshImportPIEDesc.version := IMPORT_PIE_VERSION;
	gAdjustMeshImportPIEDesc.name := 'Adjust_Mesh';   // name of project
	gAdjustMeshImportPIEDesc.importFlags := kImportNeedsProject or kImportAllwaysVisible;
 	gAdjustMeshImportPIEDesc.toLayerTypes := (kPIEQuadMeshLayer) {* was kPIETriMeshLayer*/};
 	gAdjustMeshImportPIEDesc.fromLayerTypes := (kPIEQuadMeshLayer) {* was kPIETriMeshLayer*/};
 	gAdjustMeshImportPIEDesc.doImportProc := @GAdjustMesh;// address of Post Processing Function function
        gAdjustMeshImportPIEDesc.neededProject := 'SUTRA';

	gAdjustMeshPIEDesc.name := 'Adjust_Mesh';      // PIE name
	gAdjustMeshPIEDesc.PieType := kImportPIE;                   // PIE type: project PIE
	gAdjustMeshPIEDesc.descriptor := @gAdjustMeshImportPIEDesc;	// pointer to descriptor

	Assert (numNames < kMaxFunDesc) ;
        gFunDesc[numNames] := @gAdjustMeshPIEDesc;
        Inc(numNames);	// add descriptor to list




	descriptors := @gFunDesc;
end;



end.
