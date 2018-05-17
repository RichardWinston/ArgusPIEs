unit PostMT3DPieUnit;

interface

uses
  Sysutils, Dialogs, ShellAPI, Windows, AnePIE, Forms, classes;

procedure GPostMT3DPIE (aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;

implementation

uses
  ANE_LayerUnit, Variables, ArgusFormUnit, MFGrid,
  ANECB, UtilityFunctions, ThreeDGriddedDataStorageUnit, MT3DPostProc,
  IntListUnit, WritePostProcessingUnit, FixNameUnit, UtilityFunctionsMT3D,
  ModflowUnit, LayerNamePrompt;

const chartTypes : Array[0..4] of PChar = ('Contour Map', 'Color Map',
      '3D Surface', 'Cross Section', nil);

procedure GPostMT3DPIE (aneHandle : ANE_PTR;
  const  fileName : ANE_STR;  layerHandle : ANE_PTR) ; cdecl;
var
  gridLayerHandle : ANE_PTR;
  GridAngle :ANE_DOUBLE ;
  XOffSet, YOffSet : ANE_DOUBLE;
  StringToEvaluate : string;
  X1, Y1 : ANE_DOUBLE;
  XDir, YDir : integer;
  XLast, YLast : ANE_DOUBLE;
  HNOFLO, HDRY : string;
  MT3DPostParameters : string;
  PostProcessingUtilityPath : string;
  DllDirectory : string;
  CommandLine : string;
  StartUpInfo : TStartUpInfo;
  ProcessInfo : TProcessInformation;
  ECP : DWORD;
  numElements, numNodes, numNodeParams : ANE_INT32;
  numElementParams : Longint	;
  MT3DFile : TextFile;
  posX : PDoubleArray;
  posY : PDoubleArray;
  dataParameters : pMatrix;
  paramNames : PParamNamesArray;
  node0 :			PIntegerArray  ;
  node1 :			PIntegerArray  ;
  node2 :			PIntegerArray  ;
  j : integer;
  NodeIndex, ParamIndex, ElementIndex : integer;
  NodeNum : longint;
  X, Y : double;
  ElNum, iNode1, iNode2, iNode3 : ANE_INT32;
  Conc : ANE_DOUBLE ;
  ParamNameFile : TextFile;
  ParamNamePath : string;
  ParamNameIndex : integer;
  AName : string;
  aDataLayer : TMT3DDataLayer;
  DataLayerTemplate, MapLayerTemplate : string;
  dataLayerHandle, PreviousLayerHandle, mapLayerHandle  : ANE_PTR;
  AMT3DPostProcessChartLayer : TMT3DPostProcessChartLayer;
  ChartType : integer;
  NamesList : TStringList;
  AChartType : TChartType;
  ItemsToPlot: TIntegerList;
  dataLayerName : string;
  AMapLayerType : T_ANE_MapsLayerClass ;
  MinX, MinY, MaxX, MaxY : double;
  PostProcLayerList : T_ANE_LayerList;
  UserResponse: integer;
  ANE_LayerTemplate : ANE_STR;
  MapLayerName : string;
  ANE_LayerName : ANE_STR;
begin
  if EditWindowOpen
  then
    begin
      // Result := False
    end
  else // if EditWindowOpen
    begin
      EditWindowOpen := True ;
      try  // try 1
        begin
          try  // try 2
            begin
              // Update form and current model handle
              frmMODFLOW := TArgusForm.GetFormFromArgus(aneHandle)
                as ModflowTypes.GetModflowFormType;
              // get the grid angle and the grid layer handle
              GridAngle := GetGridAngle(frmMODFLOW.CurrentModelHandle,
                TMFGridLayer.ANE_LayerName, gridLayerHandle ) ;

              // determine the position of the first row and column relative
              // to the global coordinate system.
              StringToEvaluate := 'If(IsNA(NthColumnPos(0)), 0.0, NthColumnPos(0))';
              ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
                gridLayerHandle, kPIEFloat, PChar(StringToEvaluate), @XOffSet);

              StringToEvaluate := 'If(IsNA(NthRowPos(0)), 0.0, NthRowPos(0))';
              ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
                gridLayerHandle, kPIEFloat, PChar(StringToEvaluate), @YOffSet);

              // determine whether either the grid direction is negative in
	      // either the x or y direction.

              StringToEvaluate := 'If(IsNA(NthColumnPos(1)), 0.0, NthColumnPos(1))';
              ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
                gridLayerHandle, kPIEFloat, PChar(StringToEvaluate), @X1);

              StringToEvaluate := 'If(IsNA(NthRowPos(1)), 0.0, NthRowPos(1))';
              ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
                gridLayerHandle, kPIEFloat, PChar(StringToEvaluate), @Y1);

              // set XDir to indicate whether the grid direction is positive in
              // the x dimension (XDir = 0)
              // or negative (XDir = 1)
              // if the grid direction is negative set XOffset equal to the
              // left edge of the grid.
              if (X1 > XOffSet)
              then
                begin
                  XDir := 0;
                end
              else
                begin
                  XDir := 1;

                  StringToEvaluate :=
                    'If(IsNA(NthColumnPos(NumColumns())), 0, NthColumnWidth(NumColumns()))';

                  ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
                    gridLayerHandle, kPIEFloat, PChar(StringToEvaluate), @XLast);


                  XOffSet := XLast;
                end;

              // set YDir to indicate whether the grid direction is positive
              // in the y dimension (YDir = 0)
              // or negative (YDir = 1)
              // if the grid direction is negative set YOffset equal to the
              // bottom edge of the grid.
              if (Y1 > YOffSet)
              then
                begin
                  YDir := 0;
                end
              else
                begin
                  YDir := 1;

                  StringToEvaluate :=
                    'If(IsNA(NthRowPos(NumRows())), 0, NthRowPos(NumRows()))';

                  ANE_EvaluateStringAtLayer(frmMODFLOW.CurrentModelHandle,
                    gridLayerHandle, kPIEFloat, PChar(StringToEvaluate), @YLast);


                  YOffSet := YLast;
                end;

              // get other parameters used by post processor.
              HNOFLO := frmMODFLOW.adeHNOFLO.Text;
              if frmMODFLOW.comboWetCap.ItemIndex = 0
              then
                begin
                  HDRY := HNOFLO;
                end
              else
                begin
                  HDRY := frmMODFLOW.adeHDRY.Text;
                end;

              MT3DPostParameters
                := FloatToStr(XOffSet) + ' '
                + FloatToStr(YOffSet) + ' '
                + FloatToStr(gridAngle) + ' '
                + HNOFLO + ' '
                + HDRY + ' '
                + IntToStr(XDir) + ' '
                + IntToStr(YDir);

                if not GetDllDirectory(DLLName, DllDirectory )
                then
                  begin
                    ShowMessage(DLLName + ' not found.');
                  end
                else
                  begin
                    PostProcessingUtilityPath := DllDirectory + '\PostMT3D.exe';
                    if not FileExists(PostProcessingUtilityPath)
                    then
                      begin
                        ShowMessage(PostProcessingUtilityPath + ' not found.');
                      end
                    else
                      begin
{                        ShellExecute(frmMODFLOW.Handle, nil,
                          PChar(PostProcessingUtilityPath),
                          PChar(MT3DPostParameters), PChar(DllDirectory),
                          SW_SHOWNORMAL);  }
                        with StartupInfo do
                        begin
                          cb := SizeOf(TStartupInfo);
                          dwFlags := STARTF_USESHOWWINDOW;
                          wShowWindow := sw_shownormal;
                        end;
                        if CreateProcess(nil, PChar(PostProcessingUtilityPath
                          + ' ' + MT3DPostParameters),
                          nil, nil, False, NORMAL_PRIORITY_CLASS, nil, nil,
                          StartupInfo, ProcessInfo)
                        then
                          begin
                            repeat
                              Application.ProcessMessages;
                              GetExitCodeProcess(ProcessInfo.hProcess, ECP);

                            until (ECP <> STILL_ACTIVE) or Application.Terminated;
                            CloseHandle(ProcessInfo.hProcess);
                            AssignFile(MT3DFile, DllDirectory + '\LastExp.exp');
                            try // try 2.5
                              begin
                                    Reset(MT3DFile);
                                    Read(MT3DFile, numElements, numNodes,
                                      numElementParams, numNodeParams);

                                    // allocate memory for arrays to be passed to Argus ONE.
                                    GetMem(posX, numNodes*SizeOf(double));
                                    GetMem(posY, numNodes*SizeOf(double));
                                    GetMem(dataParameters, numNodeParams*SizeOf(pMatrix));
                                    GetMem(node0, numElements*SizeOf(longInt));
                                    GetMem(node1, numElements*SizeOf(longInt));
                                    GetMem(node2, numElements*SizeOf(longInt));
                                    GetMem(paramNames, numNodeParams*SizeOf(ANE_STR));
                                    FOR j := 0 TO numNodeParams-1 DO
                                    begin
                                       GetMem(dataParameters[j], numNodes*SizeOf(DOUBLE));
                                    end;
                                    NamesList := TStringList.Create;
                                    ItemsToPlot:= TIntegerList.Create;
                                    try // try 3
                                      begin
                                        for NodeIndex := 0 to numNodes -1 do
                                        begin
                                          Read(MT3DFile, NodeNum, X, Y);
                                          if NodeIndex = 0 then
                                            begin
                                              MinX := X;
                                              MaxX := X;
                                              MinY := Y;
                                              MaxY := Y;
                                            end
                                          else
                                            begin
                                              if X < MinX then
                                              begin
                                                MinX := X
                                              end;
                                              if X > MaxX then
                                              begin
                                                MaxX := X
                                              end;
                                              if Y < MinY then
                                              begin
                                                MinY := Y
                                              end;
                                              if Y > MaxY then
                                              begin
                                                MaxY := Y
                                              end;
                                            end;
                                          posX^[NodeIndex] := X;
                                          posY^[NodeIndex] := Y;
                                          for ParamIndex := 0 to numNodeParams -1 do
                                          begin
                                            Read(MT3DFile, Conc);
                                            dataParameters[ParamIndex]^[NodeIndex] := Conc;
                                          end;
                                        end;
                                        for ElementIndex := 0 to numElements -1 do
                                        begin
                                          Read(MT3DFile, ElNum, iNode1, iNode2, iNode3);
                                          node0^[ElementIndex] := iNode1;
                                          node1^[ElementIndex] := iNode2;
                                          node2^[ElementIndex] := iNode3;
                                        end;
                                        ParamNamePath := DllDirectory + '\SelTimes.txt';
                                        if not FileExists(ParamNamePath)
                                        then
                                          begin
                                            ShowMessage(ParamNamePath + ' not found.');
                                          end
                                        else
                                          begin
                                            AssignFile(ParamNameFile, ParamNamePath);
                                            try  // Try 3.5
                                              begin
                                                Reset(ParamNameFile);

                                                for ParamNameIndex := 0 to numNodeParams -1 do
                                                begin
                                                  ReadLn(ParamNameFile, AName);
                                                  AName := FixArgusName(AName);
                                                  // need to free this memory
//                                                  GetMem(paramNames[ParamNameIndex], (Length(AName) + 1)*SizeOf(Char));
//                                                  StrCopy(paramNames^[ParamNameIndex], PChar(AName));
                                                  paramNames^[ParamNameIndex] := PChar(AName);

                                                  NamesList.Add(AName);
                                                  ItemsToPlot.Add(ParamNameIndex);
                                                end;
                                                try  // try 4
                                                  begin
                                                    DataLayerName := ModflowTypes.GetMT3DDataLayerType.ANE_LayerName;
                                                    dataLayerHandle := GetLayerHandle(anehandle,DataLayerName);
{                                                    GetMem(ANE_LayerName, Length(DataLayerName) + 1);
                                                    try
                                                      StrPCopy(ANE_LayerName,DataLayerName);
                                                      dataLayerHandle := ANE_LayerGetHandleByName(ModelHandle,
                                                        ANE_LayerName);
                                                    finally
                                                      FreeMem(ANE_LayerName);
                                                    end;}
//                                                    dataLayerHandle := ANE_LayerGetHandleByName(anehandle,
//                                                      PChar(DataLayerName)  );

                                                    if (dataLayerHandle = nil)
                                                    then
                                                      begin
                                                        aDataLayer := TMT3DDataLayer.Create(frmMODFLOW.MFLayerStructure.PostProcessingLayers, -1);
                                                        ADataLayer.Lock := [];
                                                        DataLayerTemplate := ADataLayer.WriteLayer(aneHandle);
                                                        PreviousLayerHandle := nil; // if the previous layer is not
                                                        // set to nil there is an access violation if the new data
                                                        // layer is not the last layer.
                                                        GetMem(ANE_LayerTemplate, Length(DataLayerTemplate) + 1);
                                                        try
                                                          StrPCopy(ANE_LayerTemplate, DataLayerTemplate);
                                                          dataLayerHandle := ANE_LayerAddByTemplate(anehandle,
                                                             ANE_LayerTemplate,
                                                             PreviousLayerHandle );
                                                        finally
                                                          FreeMem(ANE_LayerTemplate);
                                                        end;
                                                        ADataLayer.Free;
                                                      end
                                                    else
                                                      begin
                                                        GetValidLayer(anehandle, dataLayerHandle,
                                                          ModflowTypes.GetMT3DDataLayerType,
                                                          DataLayerName,
                                                          frmMODFLOW.MFLayerStructure.PostProcessingLayers, UserResponse);
                                                      end;
                                                    if dataLayerHandle = nil
                                                    then
                                                      begin
                                                        ShowMessage('Error creating data layer!');
                                                      end
                                                    else
                                                      begin
                                                        ANE_DataLayerSetTriangulatedData(aneHandle ,
                                                                      dataLayerHandle ,
                                                                      numNodes, // :	  ANE_INT32   ;
                                                                      @posX^, //:		  ANE_DOUBLE_PTR  ;
                                                                      @posY^, // :	    ANE_DOUBLE_PTR   ;
                                                                      numElements, //:	  ANE_INT32   ;
                                                                      @node0^, //:	  	ANE_INT32_PTR  ;
                                                                      @node1^, //:	  	ANE_INT32_PTR  ;
                                                                      @node2^, //:	  	ANE_INT32_PTR  ;
                                                                      numNodeParams, // : ANE_INT32     ;
                                                                      @dataParameters^, // : ANE_DOUBLE_PTR_PTR  ;
                                                                      @paramNames^  );

                                                        MapLayerName := ModflowTypes.GetMT3DPostProcessChartLayerType.ANE_LayerName;
                                                        mapLayerHandle := GetLayerHandle(anehandle,MapLayerName);
{                                                        GetMem(ANE_LayerName, Length(MapLayerName) + 1);
                                                        try
                                                          StrPCopy(ANE_LayerName,MapLayerName);
                                                          mapLayerHandle := ANE_LayerGetHandleByName(ModelHandle,
                                                            ANE_LayerName);
                                                        finally
                                                          FreeMem(ANE_LayerName);
                                                        end;   }
//                                                        mapLayerHandle := ANE_LayerGetHandleByName(anehandle,
//                                                          PChar(ModflowTypes.GetMT3DPostProcessChartLayerType.ANE_LayerName)  );

                                                        if (mapLayerHandle = nil)
                                                        then
                                                          begin
                                                            AMT3DPostProcessChartLayer := TMT3DPostProcessChartLayer.Create(frmMODFLOW.MFLayerStructure.PostProcessingLayers, -1);
                                                            AMT3DPostProcessChartLayer.Lock := [];
                                                            MapLayerTemplate := AMT3DPostProcessChartLayer.WriteLayer(aneHandle);
                                                            PreviousLayerHandle := nil; // if the previous layer is not
                                                            // set to nil there is an access violation if the new data
                                                            // layer is not the last layer.
                                                            GetMem(ANE_LayerTemplate, Length(MapLayerTemplate) + 1);
                                                            try
                                                              StrPCopy(ANE_LayerTemplate, MapLayerTemplate);
                                                              mapLayerHandle := ANE_LayerAddByTemplate(anehandle,
                                                                 ANE_LayerTemplate,
                                                                 PreviousLayerHandle );
                                                            finally
                                                              FreeMem(ANE_LayerTemplate);
                                                            end;
                                                            AMT3DPostProcessChartLayer.Free;
                                                            if mapLayerHandle = nil
                                                            then
                                                              begin
                                                                ShowMessage('Problem creating new maps layer!');
                                                              end;
{                                                          end
                                                        else
                                                          begin
                                                             if (ANE_UserMessageOkCancel(aneHandle,
                                                               'The Maps Layer "MT3D Post Processing Charts" already exist. Do you want to clear its content? Click Ok to clear, Cancel to add new Charts to layer.'))
                                                             then
                                                               begin
                                                                     ANE_LayerClear(aneHandle,  mapLayerHandle, false );
                                                               end;  }
                                                          end;
                                                        //6) Ask the user for type of chart
                                                        ChartType := ANE_UserSelectItem
                                                          (aneHandle, @chartTypes,
                                                          'Chart Types',
                                                          'Please Select chart type:');
                                                        if ChartType > -1 then
                                                        begin
                                                          if ChartType = 0 then
                                                            begin
                                                              AChartType := ctContour;
                                                            end
                                                          else if ChartType = 1 then
                                                            begin
                                                              AChartType := ctColor;
                                                            end
                                                          else if ChartType = 2 then
                                                            begin
                                                              AChartType := ct3D;
                                                            end
                                                          else
                                                          begin
                                                              AChartType := ctCrosssection;
                                                          end;
                                                          WritePostProcessing(aneHandle, NamesList,
                                                              ItemsToPlot,
                                                              AChartType, DataLayerName,
                                                              TMT3DPostProcessChartLayer,
                                                              MinX, MinY, MaxX, MaxY,
                                                              frmMODFLOW.MFLayerStructure.PostProcessingLayers) ;
                                                          // Continue here.
                                                        end;
                                                      end;
                                                  end;
                                                finally // try 4
                                                  begin
{                                                    FOR ParamNameIndex := numNodeParams-1 DOWNTO 0 DO
                                                    begin
                                                      assert(ParamNameIndex < numNodeParams);
                                                      FreeMem(paramNames[ParamNameIndex]);
                                                    end;  }
                                                  end;
                                                end;
                                              end;
                                            finally // try 3.5
                                              begin
                                                CloseFile(ParamNameFile);
                                              end;
                                            end;
                                          end;
                                      end;
                                    finally // try 3
                                      begin
                                        // free memory of arrays passed to Argus ONE.
                                        FOR j := numNodeParams-1 DOWNTO 0 DO
                                        begin
                                          assert(j < numNodeParams);
                                          FreeMem(dataParameters[j]);
                                        end;
                                        FreeMem(dataParameters  );
                                        FreeMem(posY, numNodes*SizeOf(double));
                                        FreeMem(posX, numNodes*SizeOf(double));
                                        FreeMem(node0, numElements*SizeOf(longInt));
                                        FreeMem(node1, numElements*SizeOf(longInt));
                                        FreeMem(node2, numElements*SizeOf(longInt));
                                        FreeMem(paramNames, numNodeParams*SizeOf(ANE_STR));
                                        NamesList.Free;
                                        ItemsToPlot.Free;
                                      end;
                                    end;
                              end;
                            finally // try 2.5
                              begin
                                CloseFile(MT3DFile);
                              end;
                            end;
                          end
                        else
                          begin
                            ShowMessage('Unable to start post processing utility');
                          end;
                      end;
                  end;

            end; // try 2
          except on Exception do
            begin
                // result := False;
            end;
          end  // try 2
        end;
      finally
        begin
          EditWindowOpen := False;
        end;
      end; // try 1
    end; // if EditWindowOpen else
end;

end.
