unit SuperfishUnit;

// Save TD32 information and used Turbo debugger to debug.
// Click F3 and enter the name of your dll.
// After Argus ONE has started attach to ArgusONE.dll.
// From the File menu change to the directory with the source code of the PIE.
// Click F3 and double click on your dll
// Click F3 again and loadthe source files.
// You can now set breakpoints in the dll.

interface

uses
  SysUtils, Controls, Dialogs, Classes, Forms,

// We need to use the appropriate units. In this example, we have an import
// PIE so we need to use ImportPIE.pas. All PIE's use AnePIE.
   AnePIE, ImportPIE, NodeElementUnit, BoundaryContourUnit ;



procedure GAdjustMesh(aneHandle : ANE_PTR; const  fileName : ANE_STR;
          layerHandle : ANE_PTR); cdecl;


procedure GSuperFishnetPIE(aneHandle : ANE_PTR; const  fileName : ANE_STR;
                               layerHandle : ANE_PTR); cdecl;

procedure GGetXCount(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				aneHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GGetYCount(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				aneHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;

procedure GSetCounts(const refPtX : ANE_DOUBLE_PTR      ;
				const refPtY : ANE_DOUBLE_PTR     ;
				numParams : ANE_INT16          ;
				const parameters : ANE_PTR_PTR ;
				aneHandle : ANE_PTR            ;
				reply : ANE_PTR		       	); cdecl;
                               
implementation

{We use ANECB in this case because we use the ANE_ImportTextToLayer procedure.}

uses ANECB, OptionsUnit, frmSutraUnit, ParamNamesAndTypes, FunctionPIE,
  ParamArrayUnit, ANE_LayerUnit, ArgusFormUnit, SLGroupLayers;

// global variables.
var
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

function GetN(var MultipleUnits : Boolean; var MeshN : string) : String;
begin
  result := frmSutra.N(MultipleUnits, MeshN);
end;

function GetSutraMeshHandles(aneHandle : ANE_PTR;
  var SutraMeshHandle : ANE_PTR;  N : String) : boolean;
begin
  SutraMeshHandle := ANE_LayerGetHandleByName(aneHandle,
         PChar(MeshLayerName + N));
  result := (SutraMeshHandle <> nil);

  if not result then
  begin
    Beep;
    MessageDlg(MeshLayerName + N +' not found!', mtError, [mbOK], 0);
  end;
end;


function GetSutraBasicHandles(aneHandle : ANE_PTR; var SutraMeshHandle,
  FishNetLayoutHandle : ANE_PTR;  N : String) : boolean;
begin
    result := GetSutraMeshHandles(aneHandle, SutraMeshHandle, N );

    if result then
    begin
      FishNetLayoutHandle := ANE_LayerGetHandleByName(aneHandle,
             PChar(FishNetName + N));

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
begin

    FluidSourcesHandle := ANE_LayerGetHandleByName(aneHandle,
           PChar(FluidSourcesName + NodeSurface + N));


    result := (FluidSourcesHandle <> nil);

    if not result then
    begin
      Beep;
      MessageDlg(FluidSourcesName+ NodeSurface + N + ' not found!', mtError, [mbOK], 0);
    end;

    if result then
    begin
      SoluteEnergySourceHandle := ANE_LayerGetHandleByName(aneHandle,
             PChar(SoluteSourcesName + NodeSurface + N));

      if SoluteEnergySourceHandle = nil then
      begin
        SoluteEnergySourceHandle := ANE_LayerGetHandleByName(aneHandle,
               PChar(EnergySourcesName + NodeSurface + N));
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
      HeadPressureHandle := ANE_LayerGetHandleByName(aneHandle,
             PChar(SpecifiedHeadName + NodeSurface + N));

      if HeadPressureHandle = nil then
      begin
        HeadPressureHandle := ANE_LayerGetHandleByName(aneHandle,
               PChar(SpecifiedPressureName + NodeSurface + N));
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
      ConcTempHandle := ANE_LayerGetHandleByName(aneHandle,
             PChar(SpecifiedConcentrationName + NodeSurface + N));

      if ConcTempHandle = nil then
      begin
        ConcTempHandle := ANE_LayerGetHandleByName(aneHandle,
               PChar(SpecifiedTemperatureName + NodeSurface + N));
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
    XElementIndex := ANE_LayerGetParameterByName(aneHandle,
         FishNetLayoutHandle, PChar(XElementName));
    result := (XElementIndex > -1);
    if not result then
    begin
      Beep;
      MessageDlg(XElementName + ' not found on ' + FishNetName + N + '!', mtError, [mbOK], 0);
    end;

    if result then
    begin
      YElementIndex := ANE_LayerGetParameterByName(aneHandle,
           FishNetLayoutHandle, PChar(YElementName));
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
        try
          LowerCriticalAngle := ProjectOptions.MinAngle[aneHandle];
        Except on EArgusPropertyError do
          LowerCriticalAngle := 22.5;
        end;
        try
          UpperCriticalAngle := ProjectOptions.MaxAngle[aneHandle];
        Except on EArgusPropertyError do
          UpperCriticalAngle := 165;
        end;
      finally
        ProjectOptions.Free;
      end;

      CreateBoundaryContours(FluidSourcesStringList, AList);
      for Index := 0 to AList.Count -1 do
      begin
        ABoundary := AList[Index];
        AMesh.AdjustMesh(ABoundary, UpperCriticalAngle, LowerCriticalAngle )
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
//  LayoutString : String;
//  XElementIndex, YElementIndex : integer;
//  FishnetContours : TStringList;
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
  MeshN : String;
  ThisN : string;
  AString : ANE_STR;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      try
        frmSutra := TArgusForm.GetFormFromArgus(aneHandle)
          as TfrmSutra;

        N := GetN(MultipleUnits, MeshN);

        if N = '' then
        begin
          NodeSurface := '';
        end
        else
        begin
          NodeSurface := ' ' + TSutraNodeSurfaceGroupLayer.WriteNewRoot;
        end;

        OK := GetSutraMeshHandles(aneHandle, SutraMeshHandle, MeshN);

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

              if N = '' then
              begin
                UpperLimit := 1;
              end
              else
              begin
                UpperLimit := StrToInt(N);
              end;
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
                    if N = '' then
                    begin
                      ThisN := '';
                    end
                    else
                    begin
                      ThisN := IntToStr(NIndex)
                    end;
                    OK := GetSourceHandles(aneHandle,
                      FluidSourcesHandle, SoluteEnergySourceHandle, HeadPressureHandle,
                      ConcTempHandle, ThisN, NodeSurface);

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
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else


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
  MeshN : String;
  NString : String;
  NeedToAdjustMesh : boolean;
  AString : ANE_STR;
begin
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      try
        frmSutra := TArgusForm.GetFormFromArgus(aneHandle)
          as TfrmSutra;

        NeedToAdjustMesh := MessageDlg('Do you wish to make the mesh conform '
          + 'to point and open contours that define sources?', mtInformation,
          [mbYes, mbNo], 0)= mrYes;

        N := GetN(MultipleUnits, MeshN);

        if N = '' then
        begin
          NodeSurface := '';
        end
        else
        begin
          NodeSurface := ' ' + TSutraNodeSurfaceGroupLayer.WriteNewRoot;
        end;

        OK := GetSutraBasicHandles(aneHandle, SutraMeshHandle,
          FishNetLayoutHandle, MeshN);

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

              if N <> '' then
              begin
                UpperLimit := StrToInt(N);
              end
              else
              begin
                UpperLimit := 1;
              end;
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
                if NeedToAdjustMesh then
                begin
                  for NIndex := LowerLimit to UpperLimit do
                  begin
                    if N = '' then
                    begin
                      NString := '';
                    end
                    else
                    begin
                      NString := IntToStr(NIndex);
                    end;



                    if OK then
                    begin
                      OK := GetSourceHandles(aneHandle,
                        FluidSourcesHandle, SoluteEnergySourceHandle, HeadPressureHandle,
                        ConcTempHandle, NString, NodeSurface);

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
                end;
                if OK then
                begin
                  if NeedToAdjustMesh then
                  begin
                    AdjustMesh(aneHandle, SourcesStringList, Fishnet);
                  end;
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
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else

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
  if EditWindowOpen then
  begin
    MessageDlg('You can not export a ' +
    ' project if an edit box is open. Try again after'
    + ' correcting this problems.', mtError, [mbOK], 0);
  end
  else // if EditWindowOpen
  begin
    EditWindowOpen := True ;
    try  // try 1
    begin

      frmSutra := TArgusForm.GetFormFromArgus(aneHandle)
        as TfrmSutra;

      result := True;

      param := @parameters^;
      ANE_N :=  param^[0];

      N := String(ANE_N);

      try
        OK := GetSutraBasicHandles(aneHandle, SutraMeshHandle,
          FishNetLayoutHandle,  N);


        if OK then
        begin
          OK := GetParamIndicies(aneHandle, FishNetLayoutHandle,
            XElementIndex, YElementIndex, N);
        end;

        if OK then
        begin
          OK := GetFishnetString(aneHandle, FishNetLayoutHandle, LayoutString, N);

        end;

        if OK then
        begin
          FishnetContours := TStringList.Create;
          try
            FishnetContours.Text := LayoutString;

            Fishnet := TFishnet.Create(FishnetContours,XElementIndex,YElementIndex);
            try
              XCount := Fishnet.ColumnNodeCount;
              YCount := Fishnet.RowNodeCount;

            finally
              Fishnet.Free
            end;
          finally
            FishnetContours.Free;
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
    finally
      begin
        EditWindowOpen := False;
      end;
    end; // try 1
  end; // if EditWindowOpen else

end;





end.
